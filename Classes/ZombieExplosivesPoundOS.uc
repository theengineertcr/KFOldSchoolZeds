class ZombieExplosivesPoundOS extends KFMonsterOS;

var class<Projectile> GunnerProjClass;
var bool bClientGLing;
var int GLFireCounter;
var bool bFireAtWill,bGLing;
var float LastGLTime;
var vector TraceHitPos;
var Emitter mTracer,mMuzzleFlash;
var()   float   GLFireRate;
var()   int     GLFireBurst;
var()   float   GLFireInterval;
var         bool    bCharging;
var float DistBeforeSaw;

replication
{
    reliable if( Role==ROLE_Authority )
        TraceHitPos,bGLing,bCharging;
}

// pawn doesnt load default animset so were forcing it here
event PreBeginPlay()
{
    super.PreBeginPlay();
    LinkSkelAnim(MeshAnimation'KFCharacterModelsOldSchool.InfectedWhiteMale1');
}

simulated function PostBeginPlay()
{
    if( Role < ROLE_Authority )
    {
        return;
    }

    if (Level.Game != none)
    {
        if( Level.Game.GameDifficulty < 2.0 )
        {
            GLFireBurst = default.GLFireBurst * 0.5;
            GLFireRate = default.GLFireRate * 1.66;
        }
        else if( Level.Game.GameDifficulty < 4.0 )
        {
            GLFireBurst = default.GLFireBurst * 1.0;
            GLFireRate = default.GLFireRate * 1.0;
        }
        else if( Level.Game.GameDifficulty < 5.0 )
        {
            GLFireBurst = default.GLFireBurst * 1.5;
            GLFireRate = default.GLFireRate * 0.8;
        }
        else
        {
            GLFireBurst = default.GLFireBurst * 2.0;
            GLFireRate = default.GLFireRate * 0.5;
        }

    }

    super.PostBeginPlay();
}

simulated Function PostNetBeginPlay()
{
    EnableChannelNotify ( 1,1);
    AnimBlendParams(1, 1.0, 0.0,, 'Bip01 Spine1');
    super.PostNetBeginPlay();
    TraceHitPos = vect(0,0,0);
    bNetNotify = true;
}

simulated function PostNetReceive()
{
    if (bCharging)
    {
        MovementAnims[0]='PoundRun';
    }
    else if( !(bCrispified && bBurnified) )
    {
        MovementAnims[0]=default.MovementAnims[0];
    }

    if( bClientGLing != bGLing )
    {
        bClientGLing = bGLing;

        if( bGLing )
        {
            IdleHeavyAnim='RangedFireMG';
            IdleRifleAnim='RangedFireMG';
            IdleCrouchAnim='RangedFireMG';
            IdleWeaponAnim='RangedFireMG';
            IdleRestAnim='RangedFireMG';
        }
        else
        {
            IdleHeavyAnim='RangedIdle';
            IdleRifleAnim='RangedIdle';
            IdleCrouchAnim='RangedIdle';
            IdleWeaponAnim='RangedIdle';
            IdleRestAnim='RangedIdle';
        }
    }

    if( TraceHitPos!=vect(0,0,0) )
    {
        AddTraceHitFX(TraceHitPos);
        TraceHitPos = vect(0,0,0);
    }
}

function SetMindControlled(bool bNewMindControlled)
{
    if( bNewMindControlled )
    {
        NumZCDHits++;

        if( NumZCDHits > 1 )
        {
            if( !IsInState('RunningToMarker') )
            {
                GotoState('RunningToMarker');
            }
            else
            {
                NumZCDHits = 1;
                if( IsInState('RunningToMarker') )
                {
                    GotoState('');
                }
            }
        }
        else
        {
            if( IsInState('RunningToMarker') )
            {
                GotoState('');
            }
        }

        if( bNewMindControlled != bZedUnderControl )
        {
            SetGroundSpeed(OriginalGroundSpeed * 1.25);
            Health *= 1.25;
            HealthMax *= 1.25;
        }
    }
    else
    {
        NumZCDHits=0;
    }

    bZedUnderControl = bNewMindControlled;
}

function GivenNewMarker()
{
    if( bCharging && NumZCDHits > 1  )
    {
        GotoState('RunningToMarker');
    }
    else
    {
        GotoState('');
    }
}

simulated function SetBurningBehavior()
{
    if( Role == Role_Authority && IsInState('RunningState') )
    {
        super.SetBurningBehavior();
        GotoState('');
    }

    super.SetBurningBehavior();
}

function vector ComputeTrajectoryByTime( vector StartPosition, vector EndPosition, float fTimeEnd  )
{
    local vector NewVelocity;

    NewVelocity = super.ComputeTrajectoryByTime( StartPosition, EndPosition, fTimeEnd );

    if( PhysicsVolume.IsA( 'KFPhysicsVolume' ) && StartPosition.Z < EndPosition.Z )
    {
        if( PhysicsVolume.Gravity.Z < class'PhysicsVolume'.default.Gravity.Z )
        {
            if( Mass > 900 )
            {
                NewVelocity.Z += 90;
            }
        }
    }
    return NewVelocity;
}

function bool CanGetOutOfWay()
{
    return false;
}

function bool FlipOver()
{
    if( Physics==PHYS_Falling )
    {
        SetPhysics(PHYS_Walking);
    }

    bShotAnim = true;
    //Explosive Pound has a unique animation for getting stunned
    GoToState('');
    SetAnimAction('StunState');
    HandleWaitForAnim('StunState');
    Acceleration = vect(0, 0, 0);
    Velocity.X = 0;
    Velocity.Y = 0;
    KFMonsterController(Controller).Focus = none;
    KFMonsterController(Controller).FocalPoint = KFMonsterController(Controller).LastSeenPos;
    Controller.GoToState('WaitForAnim');
    KFMonsterController(Controller).bUseFreezeHack = true;
    return true;
}

simulated function bool HitCanInterruptAction()
{
    if( bShotAnim )
    {
        return false;
    }

    return true;
}

simulated function Destroyed()
{
    if( mTracer!=none )
        mTracer.Destroy();

    if( mMuzzleFlash!=none )
        mMuzzleFlash.Destroy();

    super.Destroyed();
}

//bugged: does not consistently do rangedattack, waits for gltime
//and after performing ranged attack, slows down because gltime doesnt reset
function RangedAttack(Actor A)
{
    local float Dist;
    local int LastFireTime;

    Dist = VSize(Controller.Target.Location-Location);

    if ( bShotAnim  || Physics == PHYS_Swimming)
        return;
    else if ( Dist < (MeleeRange - DistBeforeSaw + CollisionRadius + A.CollisionRadius) && CanAttack(A) )
    {
        bShotAnim = true;
        LastFireTime = Level.TimeSeconds;
        SetAnimAction(MeleeAnims[Rand(2)]);
        CurrentDamType = ZombieDamType[0];
        PlaySound(sound'Claw2s', SLOT_Interact);
    }

    //if( !bShotAnim && !bDecapitated )
    //{
    //    if ( float(Health)/HealthMax < 0.5 )
    //        GoToState('RunningState');
    //}

    if ( !bWaitForAnim && !bShotAnim && !bDecapitated && LastGLTime<Level.TimeSeconds && Dist < 2500 && !bCharging)
    {
        LastGLTime = Level.TimeSeconds + GLFireInterval + (FRand() *2.0);
        bShotAnim = true;
        Acceleration = vect(0,0,0);
        SetAnimAction('RangedPreFireMG');
        HandleWaitForAnim('RangedPreFireMG');

        GLFireCounter =  GLFireBurst;
        GoToState('FireGrenades');
    }
}

state RunningState
{
    simulated function SetZappedBehavior()
    {
        Global.SetZappedBehavior();
        GoToState('');
    }

    function bool CanSpeedAdjust()
    {
        return false;
    }

    function BeginState()
    {
        if( bZapped )
        {
            GoToState('');
        }
        else
        {
            SetGroundSpeed(OriginalGroundSpeed * 3.5);
            bCharging = true;
            if( Level.NetMode!=NM_DedicatedServer )
                PostNetReceive();

            NetUpdateTime = Level.TimeSeconds - 1;
        }
    }

    function EndState()
    {
        if( !bZapped )
        {
            SetGroundSpeed(GetOriginalGroundSpeed());
        }
        bCharging = false;
        if( Level.NetMode!=NM_DedicatedServer )
            PostNetReceive();
    }

    function RemoveHead()
    {
        GoToState('');
        Global.RemoveHead();
    }

    function RangedAttack(Actor A)
    {
        local float Dist;

        Dist = VSize(A.Location - Location);
        DistBeforeSaw = 20.0;

        if ( bShotAnim || Physics == PHYS_Swimming)
            return;
        else if ( Dist < (MeleeRange - DistBeforeSaw + CollisionRadius + A.CollisionRadius) && CanAttack(A) )
        {
            bShotAnim = true;
            if(Level.Game.GameDifficulty < 5.0)
                SetAnimAction(MeleeAnims[Rand(2)]);
            else
                SetAnimAction(MeleeAnims[0]);
            CurrentDamType = ZombieDamType[0];
            GoToState('');
        }
    }
}

state RunningToMarker extends RunningState
{
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    local bool bIsHeadShot;

    bIsHeadShot = IsHeadShot(Hitlocation, normal(Momentum), 1.0);

    if ( Level.Game.GameDifficulty >= 5.0 && bIsHeadshot && (class<DamTypeCrossbow>(damageType) != none || class<DamTypeCrossbowHeadShot>(damageType) != none) )
    {
        Damage *= 0.5;
    }

    super.takeDamage(Damage, instigatedBy, hitLocation, momentum, damageType, HitIndex);
}

simulated function AddTraceHitFX( vector HitPos )
{
    local vector Start,SpawnVel,SpawnDir;
    local float hitDist;

    Start = GetBoneCoords('FireBone').Origin;
    if( mTracer==none )
        mTracer = Spawn(class'KFMod.KFNewTracer',,,Start);
    else mTracer.SetLocation(Start);

    if( mMuzzleFlash==none )
    {
        mMuzzleFlash = Spawn(class'NewMinigunMFlashOS');
        AttachToBone(mMuzzleFlash, 'FireBone');
    }
    else mMuzzleFlash.SpawnParticle(1);

    hitDist = VSize(HitPos - Start) - 50.f;

    if( hitDist>10 )
    {
        SpawnDir = Normal(HitPos - Start);
        SpawnVel = SpawnDir * 10000.f;
        mTracer.Emitters[0].StartVelocityRange.X.Min = SpawnVel.X;
        mTracer.Emitters[0].StartVelocityRange.X.Max = SpawnVel.X;
        mTracer.Emitters[0].StartVelocityRange.Y.Min = SpawnVel.Y;
        mTracer.Emitters[0].StartVelocityRange.Y.Max = SpawnVel.Y;
        mTracer.Emitters[0].StartVelocityRange.Z.Min = SpawnVel.Z;
        mTracer.Emitters[0].StartVelocityRange.Z.Max = SpawnVel.Z;
        mTracer.Emitters[0].LifetimeRange.Min = hitDist / 10000.f;
        mTracer.Emitters[0].LifetimeRange.Max = mTracer.Emitters[0].LifetimeRange.Min;
        mTracer.SpawnParticle(1);
    }

    Instigator = self;

    if( HitPos != vect(0,0,0) )
    {
        Spawn(class'ROBulletHitEffect',,, HitPos, Rotator(Normal(HitPos - Start)));
    }
}

function FireGLShot()
{
    local vector X,Y,Z, FireStart;
    local rotator FireRotation;

    GLFireCounter--;

    if( Controller!=none && KFDoorMover(Controller.Target)!=none )
    {
        Controller.Target.TakeDamage(22,self,Location,vect(0,0,0),class'DamTypeVomit');
        return;
    }

    GetAxes(Rotation,X,Y,Z);
    FireStart = GetBoneCoords('FireBone').Origin;

    if ( !SavedFireProperties.bInitialized )
    {
        SavedFireProperties.AmmoClass = class'SkaarjAmmo';
        SavedFireProperties.ProjectileClass = GunnerProjClass;
        SavedFireProperties.WarnTargetPct = 1;
        SavedFireProperties.MaxRange = 65535;
        SavedFireProperties.bTossed = false;
        SavedFireProperties.bTrySplash = true;
        SavedFireProperties.bLeadTarget = false;
        SavedFireProperties.bInstantHit = false;
        SavedFireProperties.bInitialized = true;
    }

    ToggleAuxCollision(false);

    FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);

    Spawn(GunnerProjClass,,,FireStart,FireRotation);
    PlaySound(sound'KF_M79Snd.M79_Fire',SLOT_Misc,2,,1400,0.9+FRand()*0.2);

    ToggleAuxCollision(true);
}

simulated function AnimEnd( int Channel )
{
    local name  Sequence;
    local float Frame, Rate;

    if( Level.NetMode==NM_Client && bGLing )
    {
        GetAnimParams( Channel, Sequence, Frame, Rate );

        if( Sequence != 'RangedPreFireMG' && Sequence != 'RangedFireMG' )
        {
            super.AnimEnd(Channel);
            return;
        }

        PlayAnim('RangedFireMG');
        bWaitForAnim = true;
        bShotAnim = true;
        IdleTime = Level.TimeSeconds;
    }
    else super.AnimEnd(Channel);
}

state FireGrenades
{
    function RangedAttack(Actor A)
    {
        Controller.Target = A;
        Controller.Focus = A;
    }

    simulated function Tick(float DeltaTime)
    {
        local float Dist;
        local float Speed;
        local float Timer;
        local float TossZ;
        local float AdditionalSpeed;
        local float TimerDivizor;
        local float TossZDivizor;

        Dist = VSize(Controller.Target.Location-Location);

        AdditionalSpeed = 250;
        TimerDivizor = 1250;
        TossZDivizor = 22;

        Speed = Dist + AdditionalSpeed;
        Timer = Dist / TimerDivizor;
        TossZ = Dist / TossZDivizor;

        class'GunnerGLProjectile'.default.Speed = Speed;
        class'GunnerGLProjectile'.default.ExplodeTimer = Timer;
        class'GunnerGLProjectile'.default.TossZ = TossZ;

        super.Tick(DeltaTime);
    }

    function EndState()
    {
        TraceHitPos = vect(0,0,0);
        bGLing = false;

        AmbientSound = default.AmbientSound;
        SoundVolume=default.SoundVolume;
        SoundRadius=default.SoundRadius;
        GLFireCounter=0;

        LastGLTime = Level.TimeSeconds + GLFireInterval + (FRand() *2.0);
    }

    function BeginState()
    {
        bFireAtWill = false;
        Acceleration = vect(0,0,0);
        bGLing = true;
    }

    function AnimEnd( int Channel )
    {
        if( GLFireCounter <= 0 )
        {
            bShotAnim = true;
            Acceleration = vect(0,0,0);
            SetAnimAction('RangedFireMGEnd');
            HandleWaitForAnim('RangedFireMGEnd');
            GoToState('');
        }
        else
        {
            if ( Controller.Enemy != none )
            {
                if ( Controller.LineOfSightTo(Controller.Enemy) && FastTrace(GetBoneCoords('FireBone').Origin,Controller.Enemy.Location))
                {
                    Controller.Focus = Controller.Enemy;
                    Controller.FocalPoint = Controller.Enemy.Location;
                }

                Controller.Target = Controller.Enemy;
            }

            bFireAtWill = true;
            bShotAnim = true;
            Acceleration = vect(0,0,0);

            SetAnimAction('RangedFireMG');
            bWaitForAnim = true;
        }
    }

    function bool NeedToTurnFor( rotator targ )
    {
        local int YawErr;

        targ.Yaw = DesiredRotation.Yaw & 65535;
        YawErr = (targ.Yaw - (Rotation.Yaw & 65535)) & 65535;
        return !((YawErr < 2000) || (YawErr > 64535));
    }

Begin:
    While( true )
    {
        Acceleration = vect(0,0,0);

        if( GLFireCounter <= 0 )
        {
            bShotAnim = true;
            Acceleration = vect(0,0,0);
            SetAnimAction('RangedFireMGEnd');
            HandleWaitForAnim('RangedFireMGEnd');
            GoToState('');
        }

        if( bFireAtWill )
            FireGLShot();
        Sleep(GLFireRate);
    }
}

simulated function int DoAnimAction( name AnimName )
{
    if(AnimName=='GoreAttack2' || AnimName=='GoreAttack1' ||AnimName=='RangedHitF' )
    {
        AnimBlendParams(1, 1.0, 0.0,, 'Bip01 Spine1');
        PlayAnim(AnimName,, 0.0, 1);
        return 1;
    }
    return super.DoAnimAction(AnimName);
}

simulated event SetAnimAction(name NewAction)
{
    local int meleeAnimIndex;

    if( NewAction=='' )
        return;

    if(NewAction == 'Claw')
    {
        meleeAnimIndex = Rand(3);
        NewAction = meleeAnims[meleeAnimIndex];
        CurrentDamtype = ZombieDamType[meleeAnimIndex];
    }

    ExpectingChannel = DoAnimAction(NewAction);

    if( Controller != none )
    {
       ExplosivesPoundZombieControllerOS(Controller).AnimWaitChannel = ExpectingChannel;
    }

    if( AnimNeedsWait(NewAction) )
    {
        bWaitForAnim = true;
    }
    else
    {
        bWaitForAnim = false;
    }

    if( Level.NetMode!=NM_Client )
    {
        AnimAction = NewAction;
        bResetAnimAct = true;
        ResetAnimActTime = Level.TimeSeconds+0.3;
    }
}

simulated function HandleWaitForAnim( name NewAnim )
{
    local float RageAnimDur;

    Controller.GoToState('WaitForAnim');
    RageAnimDur = GetAnimDuration(NewAnim);

    ExplosivesPoundZombieControllerOS(Controller).SetWaitForAnimTimout(RageAnimDur,NewAnim);
}

simulated function bool AnimNeedsWait(name TestAnim)
{
    if( TestAnim == 'RangedFireMG' || TestAnim == 'RangedPreFireMG' || TestAnim == 'RangedFireMGEnd' || TestAnim == 'StunState')
    {
        return true;
    }

    return false;
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
    myLevel.AddPrecacheMaterial(Shader'KFOldSchoolZeds_Textures.Fleshpound.PoundBitsShader');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.GunPound.AutoTurretGunTex');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.GunPound.GunPoundSkin');
}

function OldPlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum, optional int HitIndex)
{
    if(LastGLTime<Level.TimeSeconds + 1)
        return;
    else
        super.OldPlayHit(Damage,InstigatedBy,HitLocation,damageType,Momentum,HitIndex);
}

defaultproperties
{
    ControllerClass=class'ExplosivesPoundZombieControllerOS'
    GunnerProjClass=class'GunnerGLProjectile'

    Mesh=SkeletalMesh'KFCharacterModelsOldSchool.ExplosivesPound'
    Skins(0)=Shader'KFOldSchoolZeds_Textures.Fleshpound.PoundBitsShader'
    Skins(1)=TexOscillator'KillingFloorWeapons.Chainsaw.SAWCHAIN'
    Skins(2)=Texture'KFPatch2.BossGun'
    Skins(3)=Shader'KFPatch2.LaserShader'
    Skins(4)=Shader'KFCharacters.PoundBitsShader'
    Skins(5)=Texture'KFOldSchoolZeds_Textures.clot.ClotSkinVariant2'
    Skins(6)=Texture'KillingFloorWeapons.Chainsaw.ChainSawSkin3PZombie'

    //Maybe add ambient sound?
    AmbientSound=Sound'KFOldSchoolZeds_Sounds.Scrake.Saw_Idle'
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Fleshpound.Fleshpound_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieJump'

    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieDeath'

    ZombieFlag=1

    bFatAss=true
    Mass=400.000000
    RotationRate=(Yaw=45000,Roll=0)
    bUseExtendedCollision=true

    ScoringValue=125
    GroundSpeed=75.0
    WaterSpeed=75.000000
    Health=1250//700
    HealthMax=1250//700
    PlayerCountHealthScale=0.10//0.15
    PlayerNumHeadHealthScale=0.05
    HeadHealth=655//250
    MeleeDamage=35//15
    JumpZ=320.000000
    bHarpoonToHeadStuns=true
    bHarpoonToBodyStuns=false
    BleedOutDuration=6.0
    MeleeRange=60//30.0
    damageForce=-100000 //70000
    Intelligence=BRAINS_Mammal
    MotionDetectorThreat=2.0
    ZapThreshold=1.25
    ZappedDamageMod=1.25
    GLFireInterval=5.5
    GLFireRate=0.75
    GLFireBurst=2

    AmmunitionClass=class'KFMod.BZombieAmmo'
    bCannibal = false
    MenuName="Flesh Pound Explosives Gunner"

    IdleHeavyAnim="RangedIdle"
    IdleRifleAnim="RangedIdle"
    IdleCrouchAnim="RangedIdle"
    IdleWeaponAnim="RangedIdle"
    IdleRestAnim="RangedIdle"

    MovementAnims(0)="RangedWalkF"
    MovementAnims(1)="RangedWalkF"
    MovementAnims(2)="RangedWalkF"
    MovementAnims(3)="RangedWalkF"
    WalkAnims(0)="RangedWalkF"
    WalkAnims(1)="RangedWalkF"
    WalkAnims(2)="RangedWalkF"
    WalkAnims(3)="RangedWalkF"
    BurningWalkFAnims(0)="RangedWalkF"
    BurningWalkFAnims(1)="RangedWalkF"
    BurningWalkFAnims(2)="RangedWalkF"
    BurningWalkAnims(0)="RangedWalkF"
    BurningWalkAnims(1)="RangedWalkF"
    BurningWalkAnims(2)="RangedWalkF"

    AirAnims(0)="RangedJumpInAir"
    AirAnims(1)="RangedJumpInAir"
    AirAnims(2)="RangedJumpInAir"
    AirAnims(3)="RangedJumpInAir"
    TakeoffAnims(0)="RangedJumpTakeOff"
    TakeoffAnims(1)="RangedJumpTakeOff"
    TakeoffAnims(2)="RangedJumpTakeOff"
    TakeoffAnims(3)="RangedJumpTakeOff"
    LandAnims(0)="RangedJumpLanded"
    LandAnims(1)="RangedJumpLanded"
    LandAnims(2)="RangedJumpLanded"
    LandAnims(3)="RangedJumpLanded"
    AirStillAnim="RangedJumpInAir"
    TakeoffStillAnim="RangedJumpTakeOff"
    TurnLeftAnim="RangedBossHitF"
    TurnRightAnim="RangedBossHitF"

    KFRagdollName="FleshPoundRag"

    MeleeAnims(0)="GoreAttack2"
    MeleeAnims(1)="GoreAttack1"
    MeleeAnims(2)="GoreAttack2"

    bCanDistanceAttackDoors=false

    SoundRadius=200.00000
    AmbientSoundScaling=1.800000
    ColOffset=(Z=65)
    ColRadius=27
    ColHeight=25
    PrePivot=(Z=10)

    SoloHeadScale=1.55
    OnlineHeadshotScale=1.75//1.3
    OnlineHeadshotOffset=(X=30,Y=7,Z=68)
}