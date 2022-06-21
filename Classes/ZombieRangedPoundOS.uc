class ZombieRangedPoundOS extends KFMonsterOS;

var bool bFireAtWill,bMinigunning;
var float LastChainGunTime;
var vector TraceHitPos;
var Emitter mTracer,mMuzzleFlash;
var int MGFireCounter;
var bool bClientMiniGunning;
var             float   MGLostSightTimeout;
var()           float   MGDamage;
var()             float    MGAccuracy;
var()            float    MGFireRate;
var()             int     MGFireBurst;
var()   float   BurnDamageScale;
var()   float   MGFireInterval;
var bool bDisableIncendiaryRounds;
var bool bDisableIncendiaryResistance;
var () class <DamageType> MGDamageType;

replication
{
    reliable if( Role==ROLE_Authority )
        TraceHitPos,bMinigunning;
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
    GoToState('');
    SetAnimAction('RangedKnockDown');
    HandleWaitForAnim('RangedKnockDown');
    Acceleration = vect(0, 0, 0);
    Velocity.X = 0;
    Velocity.Y = 0;
    KFMonsterController(Controller).Focus = none;
    KFMonsterController(Controller).FocalPoint = KFMonsterController(Controller).LastSeenPos;
    Controller.GoToState('WaitForAnim');
    KFMonsterController(Controller).bUseFreezeHack = true;
    return true;
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
            BurnDamageScale = default.BurnDamageScale * 2.0;
            MGFireInterval = default.MGFireInterval * 1.25;
            MGDamage = default.MGDamage * 0.5;
            MGAccuracy = default.MGAccuracy * 1.25;
            MGFireBurst = default.MGFireBurst * 0.7;
            MGFireRate = default.MGFireRate * 1.5;
        }
        else if( Level.Game.GameDifficulty < 4.0 )
        {
            BurnDamageScale = default.BurnDamageScale * 1.0;
            MGFireInterval = default.MGFireInterval * 1;
            MGDamage = default.MGDamage * 1.0;
            MGAccuracy = default.MGAccuracy * 1.0;
            MGFireBurst = default.MGFireBurst * 1.0;
            MGFireRate = default.MGFireRate * 1.0;
        }
        else if( Level.Game.GameDifficulty < 5.0 )
        {
            BurnDamageScale = default.BurnDamageScale * 0.75;
            MGFireInterval = default.MGFireInterval * 0.75;
            MGDamage = default.MGDamage * 1.0;
            MGAccuracy = default.MGAccuracy * 0.9;
            MGFireBurst = default.MGFireBurst * 1.33;
            MGFireRate = default.MGFireRate * 0.833333;
        }
        else
        {
            BurnDamageScale = default.BurnDamageScale * 0.5;
            MGFireInterval = default.MGFireInterval * 0.6;
            MGDamage = default.MGDamage * 1.0;
            MGAccuracy = default.MGAccuracy * 0.80;
            MGFireBurst = default.MGFireBurst * 1.67;
            MGFireRate = default.MGFireRate * 0.68;
        }
    }

    if(bDisableIncendiaryRounds)
        MGDamageType=class'ZombieMeleeDamage';

    super.PostBeginPlay();
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

simulated Function PostNetBeginPlay()
{
    EnableChannelNotify ( 1,1);
    AnimBlendParams(1, 1.0, 0.0,, 'Bip01 Spine1');
    super.PostNetBeginPlay();
    TraceHitPos = vect(0,0,0);
    bNetNotify = true;
}


function RangedAttack(Actor A)
{
    local float Dist;
    local int LastFireTime;

    if ( bShotAnim )
        return;
    Dist = VSize(A.Location-Location);

    if ( Physics == PHYS_Swimming )
    {
        SetAnimAction('Claw');
        bShotAnim = true;
        LastFireTime = Level.TimeSeconds;
    }
    else if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius )
    {
        bShotAnim = true;
        LastFireTime = Level.TimeSeconds;
        SetAnimAction('Claw');
        PlaySound(sound'Claw2s', SLOT_Interact);
        Controller.bPreparingMove = true;
        Acceleration = vect(0,0,0);
    }
    else if ( !bWaitForAnim && !bShotAnim && !bDecapitated && LastChainGunTime<Level.TimeSeconds )
    {
        if (!Controller.LineOfSightTo(A))
        {
            //Maybe lower this further?
            LastChainGunTime = Level.TimeSeconds + MGFireInterval + (FRand() *1.0);
            return;
        }

        LastChainGunTime = Level.TimeSeconds + MGFireInterval + (FRand() *2.0);

        bShotAnim = true;
        Acceleration = vect(0,0,0);
        SetAnimAction('RangedPreFireMG');
        HandleWaitForAnim('RangedPreFireMG');

        MGFireCounter =  MGFireBurst;

        GoToState('FireChaingun');
    }
}

simulated function AddTraceHitFX( vector HitPos )
{
    local vector Start,SpawnVel,SpawnDir;
    local float hitDist;

    PlaySound(sound'KFOldSchoolZeds_Sounds.MinigunFire',SLOT_Misc,2,,1400,0.9+FRand()*0.2);
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

simulated function AnimEnd( int Channel )
{
    local name  Sequence;
    local float Frame, Rate;

    if( Level.NetMode==NM_Client && bMinigunning )
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

state FireChaingun
{
    function RangedAttack(Actor A)
    {
        Controller.Target = A;
        Controller.Focus = A;
    }

    function EndState()
    {
        TraceHitPos = vect(0,0,0);
        bMinigunning = false;

        AmbientSound = default.AmbientSound;
        SoundVolume=default.SoundVolume;
        SoundRadius=default.SoundRadius;
        MGFireCounter=0;

        LastChainGunTime = Level.TimeSeconds + MGFireInterval + (FRand() *2.0);
    }

    function BeginState()
    {
        bFireAtWill = false;
        Acceleration = vect(0,0,0);
        MGLostSightTimeout = 0.0;
        bMinigunning = true;
    }

    function AnimEnd( int Channel )
    {
        if( MGFireCounter <= 0 )
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
                    MGLostSightTimeout = 0.0;
                    Controller.Focus = Controller.Enemy;
                    Controller.FocalPoint = Controller.Enemy.Location;
                }
                else
                {
                    MGLostSightTimeout = Level.TimeSeconds + (0.25 + FRand() * 0.35);
                    Controller.Focus = none;
                }

                Controller.Target = Controller.Enemy;
            }
            else
            {
                MGLostSightTimeout = Level.TimeSeconds + (0.25 + FRand() * 0.35);
                Controller.Focus = none;
            }

            if ( FRand() < 0.03 && Controller.Enemy != none && PlayerController(Controller.Enemy.Controller) != none )
            {
                PlayerController(Controller.Enemy.Controller).Speech('AUTO', 9, "");
            }

            bFireAtWill = true;
            bShotAnim = true;
            Acceleration = vect(0,0,0);

            SetAnimAction('RangedFireMG');
            bWaitForAnim = true;
        }
    }

    function FireMGShot()
    {
        local vector Start,End,HL,HN,Dir;
        local rotator R;
        local Actor A;
        local KFPawn KFP;
        local float Dist;

        KFP = KFPawn(Controller.Target);
        Dist = VSize(Controller.Target.Location-Location);

        MGFireCounter--;

        Start = GetBoneCoords('FireBone').Origin;
        if( Controller.Focus!=none )
            R = rotator(Controller.Focus.Location-Start);
        else R = rotator(Controller.FocalPoint-Start);
        if( NeedToTurnFor(R) )
            R = Rotation;
        Dir = Normal(vector(R)+VRand()*MGAccuracy);
        End = Start+Dir*10000;

        bBlockHitPointTraces = false;
        A = Trace(HL,HN,End,Start,true);
        bBlockHitPointTraces = true;

        if( A==none )
            return;
        TraceHitPos = HL;
        if( Level.NetMode!=NM_DedicatedServer )
            AddTraceHitFX(HL);

        if( A!=Level && ( A == KFPawn(A) || A == KFGlassMover(A) || A == KFDoorMover(A)) )
        {
            // This spams server logs with "Accessed None PlayerReplicationInfo"
            if(KFPlayerReplicationInfo(KFP.PlayerReplicationInfo).ClientVeteranSkill != class'KFVetBerserker')
                A.TakeDamage(MGDamage,self,HL,Dir*500,MGDamageType);
            else
                A.TakeDamage((MGDamage + 1),self,HL,Dir*500,MGDamageType);
        }
        else    return;
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

        if( MGLostSightTimeout > 0 && Level.TimeSeconds > MGLostSightTimeout )
        {
            bShotAnim = true;
            Acceleration = vect(0,0,0);
            SetAnimAction('RangedFireMGEnd');
            HandleWaitForAnim('RangedFireMGEnd');
            GoToState('');
        }

        if( MGFireCounter <= 0 )
        {
            bShotAnim = true;
            Acceleration = vect(0,0,0);
            SetAnimAction('RangedFireMGEnd');
            HandleWaitForAnim('RangedFireMGEnd');
            GoToState('');
        }

        if( bFireAtWill )
            FireMGShot();
        Sleep(MGFireRate);
    }
}


simulated function PostNetReceive()
{
    if( bClientMiniGunning != bMinigunning )
    {
        bClientMiniGunning = bMinigunning;
        if( bMinigunning )
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

simulated function int DoAnimAction( name AnimName )
{
    if(AnimName=='PoundPunch2' || AnimName=='RangedHitF')
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
       ControllerRangedPoundOS(Controller).AnimWaitChannel = ExpectingChannel;
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

    ControllerRangedPoundOS(Controller).SetWaitForAnimTimout(RageAnimDur,NewAnim);
}

simulated function bool AnimNeedsWait(name TestAnim)
{
    if( TestAnim == 'RangedFireMG' || TestAnim == 'RangedPreFireMG' || TestAnim == 'RangedFireMGEnd' || TestAnim == 'RangedKnockDown')
    {
        return true;
    }

    return false;
}


function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    if ((DamageType == class 'DamTypeBurned' || DamageType == class 'DamTypeFlamethrower') && !bDisableIncendiaryResistance)
    {
        Damage *= BurnDamageScale;
    }

    super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType,HitIndex);
}

function OldPlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum, optional int HitIndex)
{
    if(LastChainGunTime<Level.TimeSeconds + 1)
        return;
    else
        super.OldPlayHit(Damage,InstigatedBy,HitLocation,damageType,Momentum,HitIndex);
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
    myLevel.AddPrecacheMaterial(Shader'KFOldSchoolZeds_Textures.Fleshpound.PoundBitsShader');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.GunPound.AutoTurretGunTex');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.GunPound.GunPoundSkin');
}

defaultproperties
{
    Mesh=SkeletalMesh'KFCharacterModelsOldSchool.Rangedpound'
    Skins(0)=Shader'KFOldSchoolZeds_Textures.Fleshpound.PoundBitsShader'
    Skins(1)=Texture'KFOldSchoolZeds_Textures.GunPound.AutoTurretGunTex'
    Skins(2)=Texture'KFOldSchoolZeds_Textures.GunPound.GunPoundSkin'

    AmbientSound=none
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Fleshpound.Fleshpound_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieJump'

    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieDeath'

    ZombieFlag=1

    bFatAss=true
    Mass=400.000000
    RotationRate=(Yaw=45000,Roll=0)
    bUseExtendedCollision=true


    ScoringValue=17
    GroundSpeed=115.0
    WaterSpeed=102.000000
    Health=600
    HealthMax=600
    PlayerCountHealthScale=0.10
    PlayerNumHeadHealthScale=0.05
    HeadHealth=200
    MeleeDamage=15
    JumpZ=320.000000
    bHarpoonToHeadStuns=true
    bHarpoonToBodyStuns=false
    BleedOutDuration=6.0
    MeleeRange=30.0
    damageForce=70000
    Intelligence=BRAINS_Mammal
    BurnDamageScale=0.25
    MotionDetectorThreat=1.0
    ZapThreshold=0.75
    MGFireInterval=5.5
    MGDamage=2.0
    MGAccuracy=0.04
    MGFireRate=0.06
    MGFireBurst=15

    bCannibal = false
    MenuName="Flesh Pound Chaingunner"

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

    MeleeAnims(0)="PoundPunch2"
    MeleeAnims(1)="PoundPunch2"
    MeleeAnims(2)="PoundPunch2"

    bCanDistanceAttackDoors=false

    HeadHeight=11.0
    HeadRadius=8.75
    ColOffset=(Z=65)
    ColRadius=27
    ColHeight=25
    PrePivot=(Z=0)

    OnlineHeadshotScale=1.2
    OnlineHeadshotOffset=(X=5,Y=7,Z=71)
    MGDamageType=class'DamTypeBurned'
    ControllerClass=class'ControllerRangedPoundOS'
}