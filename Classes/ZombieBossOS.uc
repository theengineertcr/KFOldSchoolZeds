class ZombieBossOS extends KFMonsterOS;

var BossHPNeedle CurrentNeedle;
var bool bChargingPlayer,bClientCharg,bFireAtWill,bMinigunning,bIsBossView;
var float RageStartTime,LastChainGunTime,LastMissileTime,LastSneakedTime;
var bool bClientMiniGunning;
var name ChargingAnim;
var byte SyringeCount,ClientSyrCount;
var int MGFireCounter;

var vector TraceHitPos;
var Emitter mTracer,mMuzzleFlash;
var bool bClientCloaked;
var float LastCheckTimes;
var int HealingLevels[3],HealingAmount;
var             float   MGFireDuration;
var             float   MGLostSightTimeout;
var()           float   MGDamage;
var()           float   ClawMeleeDamageRange;
var()           float   ImpaleMeleeDamageRange;
var             float   LastChargeTime;
var             float   LastForceChargeTime;
var             int     NumChargeAttacks;
var             float   ChargeDamage;
var             float   LastDamageTime;
var             float   SneakStartTime;
var             int     SneakCount;
var()           float   PipeBombDamageScale;

replication
{
    reliable if( Role==ROLE_Authority )
        bChargingPlayer,SyringeCount,TraceHitPos,bMinigunning,bIsBossView;
}

simulated function CalcAmbientRelevancyScale()
{
    CustomAmbientRelevancyScale = 5000/(100 * SoundRadius);
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

function ZombieMoan()
{
    if( !bShotAnim )
        super.ZombieMoan();
}

simulated function SetBurningBehavior(){}
simulated function UnSetBurningBehavior(){}

function bool CanGetOutOfWay()
{
    return false;
}

simulated function Tick(float DeltaTime)
{
    local KFHumanPawn HP;

    super.Tick(DeltaTime);

    if( Role == ROLE_Authority )
    {
        PipeBombDamageScale -= DeltaTime * 0.33;

        if( PipeBombDamageScale < 0 )
        {
            PipeBombDamageScale = 0;
        }
    }

    if( Level.NetMode==NM_DedicatedServer )
        return;

    bSpecialCalcView = bIsBossView;

    if( bZapped )
    {
        LastCheckTimes = Level.TimeSeconds;
    }
    else if( bCloaked && Level.TimeSeconds>LastCheckTimes )
    {
        LastCheckTimes = Level.TimeSeconds+0.8;

        ForEach VisibleCollidingActors(class'KFHumanPawn',HP,1000,Location)
        {
            if( HP.Health <= 0 || !HP.ShowStalkers() )
                continue;

            if( !bSpotted )
            {
                bSpotted = true;
                CloakBoss();
            }

            return;
        }

        if( bSpotted )
        {
            bSpotted = false;
            bUnlit = false;
            CloakBoss();
        }
    }
}

simulated function CloakBoss()
{
    local Controller C;
    local int Index;

    if( bZapped )
    {
        return;
    }

    if( bSpotted )
    {
        Visibility = 120;
        if( Level.NetMode==NM_DedicatedServer )
            return;
        Skins[0] = Finalblend'KFOldSchoolZeds_Textures.Patriarch.BossGlowFB';
        Skins[1] = Finalblend'KFOldSchoolZeds_Textures.Patriarch.BossGlowFB';
        Skins[2] = Finalblend'KFOldSchoolZeds_Textures.Patriarch.BossGlowFB';
        Skins[3] = Finalblend'KFOldSchoolZeds_Textures.Patriarch.BossGlowFB';
        Skins[4] = Finalblend'KFOldSchoolZeds_Textures.Patriarch.BossGlowFB';
        Skins[5] = Finalblend'KFOldSchoolZeds_Textures.Patriarch.BossGlowFB';
        Skins[6] = Finalblend'KFOldSchoolZeds_Textures.Patriarch.BossGlowFB';
        bUnlit = true;
        return;
    }

    Visibility = 1;
    bCloaked = true;

    if( Level.NetMode!=NM_Client )
    {
        For( C=Level.ControllerList; C!=none; C=C.NextController )
        {
            if( C.bIsPlayer && C.Enemy==self )
                C.Enemy = none;
        }
    }

    if( Level.NetMode==NM_DedicatedServer )
        return;

    Skins[0] = Shader'KFOldSchoolZeds_Textures.BossCloakShader';
    Skins[1] = Shader'KFOldSchoolZeds_Textures.BossCloakShader';
    Skins[2] = Shader'KFOldSchoolZeds_Textures.BossCloakShader';
    Skins[3] = Shader'KFOldSchoolZeds_Textures.BossCloakShader';
    Skins[4] = Shader'KFOldSchoolZeds_Textures.BossCloakShader';
    Skins[5] = Shader'KFOldSchoolZeds_Textures.BossCloakShader';
    Skins[6] = Texture'KillingFloorLabTextures.LabCommon.voidtex';

    if(PlayerShadow != none)
        PlayerShadow.bShadowActive = false;

    Projectors.Remove(0, Projectors.Length);
    bAcceptsProjectors = false;

    SetOverlayMaterial(FinalBlend'KFOldSchoolZeds_Textures.Patriarch.BossCloakFizzleFB', 1.0, true);

    if ( FRand() < 0.10 )
    {
        Index = Rand(Level.Game.NumPlayers);

        for ( C = Level.ControllerList; C != none; C = C.NextController )
        {
            if ( PlayerController(C) != none )
            {
                if ( Index == 0 )
                {
                    PlayerController(C).Speech('AUTO', 8, "");
                    break;
                }

                Index--;
            }
        }
    }
}

simulated function UnCloakBoss()
{
    if( bZapped )
    {
        return;
    }

    Visibility = default.Visibility;
    bCloaked = false;
    bSpotted = false;
    bUnlit = false;

    if( Level.NetMode==NM_DedicatedServer )
        return;

    Skins = default.Skins;

    if (PlayerShadow != none)
        PlayerShadow.bShadowActive = true;

    bAcceptsProjectors = true;
    SetOverlayMaterial( none, 0.0, true );
}

simulated function SetZappedBehavior()
{
    super.SetZappedBehavior();

    if( Level.Netmode != NM_DedicatedServer )
    {
        bUnlit = false;
        Skins = default.Skins;

        if (PlayerShadow != none)
            PlayerShadow.bShadowActive = true;

        bAcceptsProjectors = true;
        SetOverlayMaterial(Material'KFZED_FX_T.Energy.ZED_overlay_Hit_Shdr', 999, true);
    }
}

simulated function UnSetZappedBehavior()
{
    super.UnSetZappedBehavior();

    if( Level.Netmode != NM_DedicatedServer )
    {
        LastCheckTimes = Level.TimeSeconds;
        SetOverlayMaterial(none, 0.0f, true);
    }
}

function SetZapped(float ZapAmount, Pawn Instigator)
{
    LastZapTime = Level.TimeSeconds;

    if( bZapped )
    {
        TotalZap = ZapThreshold;
        RemainingZap = ZapDuration;
    }
    else
    {
        TotalZap += ZapAmount;

        if( TotalZap >= ZapThreshold )
        {
            RemainingZap = ZapDuration;
            bZapped = true;
        }
    }
    ZappedBy = Instigator;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if( Role < ROLE_Authority )
    {
        return;
    }

    if (Level.Game != none)
    {
        if( Level.Game.NumPlayers == 1 )
        {
            if( Level.Game.GameDifficulty < 2.0 )
            {
                MGDamage = default.MGDamage * 0.375;
            }
            else if( Level.Game.GameDifficulty < 4.0 )
            {
                MGDamage = default.MGDamage * 0.75;
            }
            else if( Level.Game.GameDifficulty < 5.0 )
            {
                MGDamage = default.MGDamage * 1.15;
            }
            else
            {
                MGDamage = default.MGDamage * 1.3;
            }
        }
        else
        {
            if( Level.Game.GameDifficulty < 2.0 )
            {
                MGDamage = default.MGDamage * 0.375;
            }
            else if( Level.Game.GameDifficulty < 4.0 )
            {
                MGDamage = default.MGDamage * 1.0;
            }
            else if( Level.Game.GameDifficulty < 5.0 )
            {
                MGDamage = default.MGDamage * 1.15;
            }
            else
            {
                MGDamage = default.MGDamage * 1.3;
            }
        }
    }

    HealingLevels[0] = Health/1.25;
    HealingLevels[1] = Health/2.f;
    HealingLevels[2] = Health/3.2;

    HealingAmount = Health/4;
}

function bool MakeGrandEntry()
{
    bShotAnim = true;
    Acceleration = vect(0,0,0);
    SetAnimAction('Entrance');
    HandleWaitForAnim('Entrance');
    GotoState('MakingEntrance');

    return true;
}

state MakingEntrance
{
    Ignores RangedAttack;

    function Tick( float Delta )
    {
        Acceleration = vect(0,0,0);

        global.Tick(Delta);
    }

Begin:
    Sleep(GetAnimDuration('Entrance'));
    GotoState('InitialSneak');
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

function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
    if( Level.TimeSeconds - LastPainAnim < MinTimeBetweenPainAnims )
        return;

    if( Damage>=150 || (DamageType.name=='DamTypeStunNade' && rand(5)>3) || (DamageType.name=='DamTypeCrossbowHeadshot' && Damage>=200) )
        PlayDirectionalHit(HitLocation);

    LastPainAnim = Level.TimeSeconds;

    if( Level.TimeSeconds - LastPainSound < MinTimeBetweenPainSounds )
        return;

    LastPainSound = Level.TimeSeconds;
    PlaySound(HitSound[0], SLOT_Pain,2*TransientSoundVolume,,400);
}

function bool OnlyEnemyAround( Pawn Other )
{
    local Controller C;

    For( C=Level.ControllerList; C!=none; C=C.NextController )
    {
        if( C.bIsPlayer && C.Pawn!=none && C.Pawn!=Other && ((VSize(C.Pawn.Location-Location)<1500 && FastTrace(C.Pawn.Location,Location))
         || (VSize(C.Pawn.Location-Other.Location)<1000 && FastTrace(C.Pawn.Location,Other.Location))) )
            return false;
    }
    return true;
}

function bool IsCloseEnuf( Actor A )
{
    local vector V;

    if( A==none )
        return false;
    V = A.Location-Location;
    if( Abs(V.Z)>(CollisionHeight+A.CollisionHeight) )
        return false;
    V.Z = 0;
    return (VSize(V)<(CollisionRadius+A.CollisionRadius+25));
}

function RangedAttack(Actor A)
{
    local float D;
    local bool bOnlyE;
    local bool bDesireChainGun;

    if( Controller.LineOfSightTo(A) && FRand() < 0.15 && LastChainGunTime<Level.TimeSeconds )
    {
        bDesireChainGun = true;
    }

    if ( bShotAnim )
        return;

    D = VSize(A.Location-Location);
    bOnlyE = (Pawn(A)!=none && OnlyEnemyAround(Pawn(A)));

    if ( IsCloseEnuf(A) )
    {
        bShotAnim = true;
        if( Health>1500 && Pawn(A)!=none && FRand() < 0.5 )
        {
            SetAnimAction('MeleeImpale');
        }
        else
        {
            SetAnimAction('MeleeClaw');
            PlaySound(sound'Claw2s', SLOT_None);
        }
    }
    else if( Level.TimeSeconds - LastSneakedTime > 20.0 )
    {
        if( FRand() < 0.3 )
        {
            LastSneakedTime = Level.TimeSeconds;
            return;
        }
        SetAnimAction('BossHitF');
        GoToState('SneakAround');
    }
    else if( bChargingPlayer && (bOnlyE || D<200) )
        return;
    else if( !bDesireChainGun && !bChargingPlayer && (D<300 || (D<700 && bOnlyE)) &&
        (Level.TimeSeconds - LastChargeTime > (5.0 + 5.0 * FRand())) )
    {
        SetAnimAction('BossHitF');
        GoToState('Charging');
    }
    else if( LastMissileTime<Level.TimeSeconds && D > 500 )
    {
        if( !Controller.LineOfSightTo(A) || FRand() > 0.75 )
        {
            LastMissileTime = Level.TimeSeconds+FRand() * 5;
            return;
        }

        LastMissileTime = Level.TimeSeconds + 10 + FRand() * 15;

        bShotAnim = true;
        Acceleration = vect(0,0,0);
        SetAnimAction('PreFireMG');

        HandleWaitForAnim('PreFireMG');

        GoToState('FireMissile');
    }
    else if ( !bWaitForAnim && !bShotAnim && LastChainGunTime<Level.TimeSeconds )
    {
        if ( !Controller.LineOfSightTo(A) || FRand()> 0.85 )
        {
            LastChainGunTime = Level.TimeSeconds+FRand()*4;
            return;
        }

        LastChainGunTime = Level.TimeSeconds + 5 + FRand() * 10;

        bShotAnim = true;
        Acceleration = vect(0,0,0);
        SetAnimAction('PreFireMG');

        HandleWaitForAnim('PreFireMG');
        MGFireCounter =  Rand(60) + 35;

        GoToState('FireChaingun');
    }
}

event Bump(actor Other)
{
    super(Monster).Bump(Other);
    if( Other==none )
        return;

    if( Other.IsA('NetKActor') && Physics != PHYS_Falling && !bShotAnim && Abs(Other.Location.Z-Location.Z)<(CollisionHeight+Other.CollisionHeight) )
    {
        Controller.Target = Other;
        Controller.Focus = Other;
        bShotAnim = true;
        Acceleration = (Other.Location-Location);
        SetAnimAction('MeleeClaw');
        PlaySound(sound'Claw2s', SLOT_None);
        HandleWaitForAnim('MeleeClaw');
    }
}

simulated function AddTraceHitFX( vector HitPos )
{
    local vector Start,SpawnVel,SpawnDir;
    local float hitDist;


    PlaySound(sound'KFOldSchoolZeds_Sounds.MinigunFire',SLOT_Misc,2,,1400,0.9+FRand()*0.2);
    Start = GetBoneCoords('tip').Origin;
    if( mTracer==none )
        mTracer = Spawn(class'KFMod.KFNewTracer',,,Start);
    else mTracer.SetLocation(Start);
    if( mMuzzleFlash==none )
    {
        mMuzzleFlash = Spawn(class'NewMinigunMFlashOS');
        AttachToBone(mMuzzleFlash, 'tip');
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

        if( Sequence != 'PreFireMG' && Sequence != 'FireMG' )
        {
            super.AnimEnd(Channel);
            return;
        }

        PlayAnim('FireMG');
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

    function bool ShouldChargeFromDamage()
    {
        return false;
    }

    function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
    {
        local float EnemyDistSq, DamagerDistSq;

        global.TakeDamage(Damage,instigatedBy,hitlocation,Momentum,damageType);

        if( InstigatedBy != none )
        {
            DamagerDistSq = VSizeSquared(Location - InstigatedBy.Location);

            if( (ChargeDamage > 200 && DamagerDistSq < (500 * 500)) || DamagerDistSq < (100 * 100) )
            {
                SetAnimAction('BossHitF');
                GoToState('Charging');
                return;
            }
        }

        if( Controller.Enemy != none && InstigatedBy != none && InstigatedBy != Controller.Enemy )
        {
            EnemyDistSq = VSizeSquared(Location - Controller.Enemy.Location);
            DamagerDistSq = VSizeSquared(Location - InstigatedBy.Location);
        }

        if( InstigatedBy != none && (DamagerDistSq < EnemyDistSq || Controller.Enemy == none) )
        {
            MonsterController(Controller).ChangeEnemy(InstigatedBy,Controller.CanSee(InstigatedBy));
            Controller.Target = InstigatedBy;
            Controller.Focus = InstigatedBy;

            if( DamagerDistSq < (500 * 500) )
            {
                SetAnimAction('BossHitF');
                GoToState('Charging');
            }
        }
    }

    function EndState()
    {
        TraceHitPos = vect(0,0,0);
        bMinigunning = false;

        AmbientSound = default.AmbientSound;
        SoundVolume=default.SoundVolume;
        SoundRadius=default.SoundRadius;
        MGFireCounter=0;

        LastChainGunTime = Level.TimeSeconds + 5 + (FRand()*10);
    }

    function BeginState()
    {
        OnlineHeadshotOffset=default.OnlineHeadshotOffset;
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
            SetAnimAction('FireEndMG');
            HandleWaitForAnim('FireEndMG');
            GoToState('');
        }
        else
        {
            if ( Controller.Enemy != none )
            {
                if ( Controller.LineOfSightTo(Controller.Enemy) && FastTrace(GetBoneCoords('tip').Origin,Controller.Enemy.Location))
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

            if( !bFireAtWill )
            {
                MGFireDuration = Level.TimeSeconds + (0.75 + FRand() * 0.5);
            }
            else if ( FRand() < 0.03 && Controller.Enemy != none && PlayerController(Controller.Enemy.Controller) != none )
            {
                PlayerController(Controller.Enemy.Controller).Speech('AUTO', 9, "");
            }

            bFireAtWill = true;
            bShotAnim = true;
            Acceleration = vect(0,0,0);

            SetAnimAction('FireMG');
            bWaitForAnim = true;
        }
    }

    function FireMGShot()
    {
        local vector Start,End,HL,HN,Dir;
        local rotator R;
        local Actor A;

        MGFireCounter--;

        Start = GetBoneCoords('tip').Origin;
        if( Controller.Focus!=none )
            R = rotator(Controller.Focus.Location-Start);
        else R = rotator(Controller.FocalPoint-Start);
        if( NeedToTurnFor(R) )
            R = Rotation;

        Dir = Normal(vector(R)+VRand()*0.06); //*0.04
        End = Start+Dir*10000;

        bBlockHitPointTraces = false;
        A = Trace(HL,HN,End,Start,true);
        bBlockHitPointTraces = true;

        if( A==none )
            return;
        TraceHitPos = HL;
        if( Level.NetMode!=NM_DedicatedServer )
            AddTraceHitFX(HL);

        if( A!=Level )
        {
            A.TakeDamage(MGDamage+Rand(3),self,HL,Dir*500,class'DamageType');
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

        if( MGLostSightTimeout > 0 && Level.TimeSeconds > MGLostSightTimeout )
        {
            bShotAnim = true;
            Acceleration = vect(0,0,0);
            SetAnimAction('FireEndMG');
            HandleWaitForAnim('FireEndMG');
            GoToState('');
        }

        if( MGFireCounter <= 0 )
        {
            bShotAnim = true;
            Acceleration = vect(0,0,0);
            SetAnimAction('FireEndMG');
            HandleWaitForAnim('FireEndMG');
            GoToState('');
        }

        if( bFireAtWill )
            FireMGShot();
        Sleep(0.05);
    }
}

state FireMissile
{
Ignores RangedAttack;

    function bool ShouldChargeFromDamage()
    {
        return false;
    }

    function BeginState()
    {
        OnlineHeadshotOffset=default.OnlineHeadshotOffset;
        Acceleration = vect(0,0,0);
    }

    function AnimEnd( int Channel )
    {
        local vector Start;
        local Rotator R;

        Start = GetBoneCoords('tip').Origin;
        if ( !SavedFireProperties.bInitialized )
        {
            SavedFireProperties.AmmoClass = MyAmmo.class;
            SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
            SavedFireProperties.WarnTargetPct = 0.15;
            SavedFireProperties.MaxRange = 10000;
            SavedFireProperties.bTossed = false;
            SavedFireProperties.bTrySplash = false;
            SavedFireProperties.bLeadTarget = true;
            SavedFireProperties.bInstantHit = true;
            SavedFireProperties.bInitialized = true;
        }
        R = AdjustAim(SavedFireProperties,Start,100);
        PlaySound(Sound'KFOldSchoolZeds_Sounds.Shared.LAWFire');
        Spawn(class'BossLAWProjOS',,,Start,R);

        bShotAnim = true;
        Acceleration = vect(0,0,0);
        SetAnimAction('FireEndMG');
        HandleWaitForAnim('FireEndMG');

        if ( FRand() < 0.05 && Controller.Enemy != none && PlayerController(Controller.Enemy.Controller) != none )
        {
            PlayerController(Controller.Enemy.Controller).Speech('AUTO', 10, "");
        }

        GoToState('');
    }
Begin:
    while ( true )
    {
        Acceleration = vect(0,0,0);
        Sleep(0.1);
    }
}

function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
    if( Controller.Target!=none && Controller.Target.IsA('NetKActor') )
        pushdir = Normal(Controller.Target.Location-Location)*100000;


    return super.MeleeDamageTarget(hitdamage, pushdir);
}

state Charging
{
    function bool CanSpeedAdjust()
    {
        return false;
    }

    function bool ShouldChargeFromDamage()
    {
        return false;
    }

    //Dont play hit anims while charging so people don't complain about broken head hitboxes :)
    function OldPlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum, optional int HitIndex){}

    function BeginState()
    {
        bChargingPlayer = true;
        if( Level.NetMode!=NM_DedicatedServer )
            PostNetReceive();

        NumChargeAttacks = Rand(2) + 1;

        OnlineHeadshotOffset.Z=60;
        OnlineHeadshotOffset.X=30;
    }

    function EndState()
    {
        SetGroundSpeed(GetOriginalGroundSpeed());
        bChargingPlayer = false;
        ChargeDamage = 0;
        if( Level.NetMode!=NM_DedicatedServer )
            PostNetReceive();

        OnlineHeadshotOffset=default.OnlineHeadshotOffset;
        LastChargeTime = Level.TimeSeconds;
    }

    function Tick( float Delta )
    {

        if( NumChargeAttacks <= 0 )
        {
            GoToState('');
        }

        if( Role == ROLE_Authority && bShotAnim)
        {
            if( bChargingPlayer )
            {
                bChargingPlayer = false;
                if( Level.NetMode!=NM_DedicatedServer )
                    PostNetReceive();
            }
            SetGroundSpeed(OriginalGroundSpeed * 1.25);
            if( LookTarget!=none )
            {
                Acceleration = AccelRate * Normal(LookTarget.Location - Location);
            }
        }
        else
        {
            if( !bChargingPlayer )
            {
                bChargingPlayer = true;
                if( Level.NetMode!=NM_DedicatedServer )
                    PostNetReceive();
            }

            if( bZapped )
            {
                SetGroundSpeed(OriginalGroundSpeed * 1.5);
            }
            else
            {
                SetGroundSpeed(OriginalGroundSpeed * 2.5);
            }
        }


        Global.Tick(Delta);
    }

    function bool MeleeDamageTarget(int hitdamage, vector pushdir)
    {
        local bool RetVal;

        NumChargeAttacks--;

        RetVal = Global.MeleeDamageTarget(hitdamage, pushdir*1.5);
        if( RetVal )
            GoToState('');
        return RetVal;
    }

    function RangedAttack(Actor A)
    {
        if( VSize(A.Location-Location)>700 && Level.TimeSeconds - LastForceChargeTime > 3.0 )
            GoToState('');
        Global.RangedAttack(A);
    }
Begin:
    Sleep(6);
    GoToState('');
}

function BeginHealing()
{
    MonsterController(Controller).WhatToDoNext(55);
}


state Healing // Healing
{
    function bool ShouldChargeFromDamage()
    {
        return false;
    }

Begin:
    Sleep(GetAnimDuration('Heal'));
    GoToState('');
}

state KnockDown // Knocked
{
    function bool ShouldChargeFromDamage()
    {
        return false;
    }

Begin:
    if( Health > 0 )
    {
        Sleep(GetAnimDuration('KnockDown'));
        CloakBoss();
        if( KFGameType(Level.Game).FinalSquadNum == SyringeCount )
        {
           KFGameType(Level.Game).AddBossBuddySquad();
        }
        GotoState('Escaping');
    }
    else
    {
       GotoState('');
    }
}

State Escaping extends Charging // Got hurt and running away...
{
    function BeginHealing()
    {
        bShotAnim = true;
        Acceleration = vect(0,0,0);
        SetAnimAction('Heal');
        HandleWaitForAnim('Heal');

        GoToState('Healing');
    }

    function RangedAttack(Actor A)
    {
        if ( bShotAnim )
            return;
        else if ( IsCloseEnuf(A) )
        {
            if( bCloaked )
                UnCloakBoss();
            bShotAnim = true;
            Acceleration = vect(0,0,0);
            Acceleration = (A.Location-Location);
            SetAnimAction('MeleeClaw');
            PlaySound(sound'Claw2s', SLOT_None);
        }
    }

    function bool MeleeDamageTarget(int hitdamage, vector pushdir)
    {
        return Global.MeleeDamageTarget(hitdamage, pushdir*1.5);
    }

    function Tick( float Delta )
    {

        if( Role == ROLE_Authority && bShotAnim)
        {
            if( bChargingPlayer )
            {
                bChargingPlayer = false;
                if( Level.NetMode!=NM_DedicatedServer )
                    PostNetReceive();
            }
            SetGroundSpeed(GetOriginalGroundSpeed());
        }
        else
        {
            if( !bChargingPlayer )
            {
                bChargingPlayer = true;
                if( Level.NetMode!=NM_DedicatedServer )
                    PostNetReceive();
            }

            if( bZapped )
            {
                SetGroundSpeed(OriginalGroundSpeed * 1.5);
            }
            else
            {
                SetGroundSpeed(OriginalGroundSpeed * 2.5);
            }
        }


        Global.Tick(Delta);
    }

    function EndState()
    {
        SetGroundSpeed(GetOriginalGroundSpeed());
        bChargingPlayer = false;
        if( Level.NetMode!=NM_DedicatedServer )
            PostNetReceive();
        if( bCloaked )
            UnCloakBoss();
    }

Begin:
    While( true )
    {
        Sleep(0.5);
        if( !bCloaked && !bShotAnim )
            CloakBoss();
        if( !Controller.IsInState('SyrRetreat') && !Controller.IsInState('WaitForAnim'))
            Controller.GoToState('SyrRetreat');
    }
}

State SneakAround extends Escaping // Attempt to sneak around.
{
    function BeginHealing()
    {
        MonsterController(Controller).WhatToDoNext(56);
        GoToState('');
    }

    function bool MeleeDamageTarget(int hitdamage, vector pushdir)
    {
        local bool RetVal;

        RetVal = super.MeleeDamageTarget(hitdamage, pushdir);

        GoToState('');
        return RetVal;
    }

    function BeginState()
    {
        super.BeginState();
        SneakStartTime = Level.TimeSeconds;
    }

    function EndState()
    {
        super.EndState();
        LastSneakedTime = Level.TimeSeconds;
    }


Begin:
    CloakBoss();
    While( true )
    {
        Sleep(0.5);

        if( Level.TimeSeconds - SneakStartTime > 10.0 )
        {
            GoToState('');
        }

        if( !bCloaked && !bShotAnim )
            CloakBoss();
        if( !Controller.IsInState('ZombieHunt') && !Controller.IsInState('WaitForAnim') )
        {
            Controller.GoToState('ZombieHunt');
        }
    }
}

State InitialSneak extends SneakAround // Sneak attack the players straight off the bat.
{
Begin:
    CloakBoss();
    While( true )
    {
        Sleep(0.5);
        SneakCount++;

        if( SneakCount > 1000 || (Controller != none && ControllerBossOS(Controller).bAlreadyFoundEnemy) ) //BossZombieController to ControllerBossOS
        {
            GoToState('');
        }

        if( !bCloaked && !bShotAnim )
            CloakBoss();
        if( !Controller.IsInState('InitialHunting') && !Controller.IsInState('WaitForAnim') )
        {
            Controller.GoToState('InitialHunting');
        }
    }
}

simulated function DropNeedle()
{
    if( CurrentNeedle!=none )
    {
        DetachFromBone(CurrentNeedle);
        CurrentNeedle.SetLocation(GetBoneCoords('Bip01 R Finger0').Origin);
        CurrentNeedle.DroppedNow();
        CurrentNeedle = none;
    }
}
simulated function NotifySyringeA()
{
    if( Level.NetMode!=NM_Client )
    {
        if( SyringeCount<3 )
            SyringeCount++;
        if( Level.NetMode!=NM_DedicatedServer )
             PostNetReceive();
    }
    if( Level.NetMode!=NM_DedicatedServer )
    {
        DropNeedle();
        CurrentNeedle = Spawn(class'BossHPNeedle');
        AttachToBone(CurrentNeedle,'Bip01 R Finger0');
    }
}
function NotifySyringeB()
{
    if( Level.NetMode != NM_Client )
    {
        Health += HealingAmount;
        bHealed = true;
    }
}
simulated function NotifySyringeC()
{
    if( Level.NetMode!=NM_DedicatedServer && CurrentNeedle!=none )
    {
        CurrentNeedle.Velocity = vect(-45,300,-90) >> Rotation;
        DropNeedle();
    }
}

simulated function PostNetReceive()
{
    if( bClientMiniGunning != bMinigunning )
    {
        bClientMiniGunning = bMinigunning;
        if( bMinigunning )
        {
            IdleHeavyAnim='FireMG';
            IdleRifleAnim='FireMG';
            IdleCrouchAnim='FireMG';
            IdleWeaponAnim='FireMG';
            IdleRestAnim='FireMG';
        }
        else
        {
            IdleHeavyAnim='BossIdle';
            IdleRifleAnim='BossIdle';
            IdleCrouchAnim='BossIdle';
            IdleWeaponAnim='BossIdle';
            IdleRestAnim='BossIdle';
        }
    }

    if( bClientCharg!=bChargingPlayer )
    {
        bClientCharg = bChargingPlayer;
        if (bChargingPlayer)
        {
            MovementAnims[0] = ChargingAnim;
            MovementAnims[1] = ChargingAnim;
            MovementAnims[2] = ChargingAnim;
            MovementAnims[3] = ChargingAnim;
        }
        else if( !bChargingPlayer )
        {
            MovementAnims[0] = default.MovementAnims[0];
            MovementAnims[1] = default.MovementAnims[1];
            MovementAnims[2] = default.MovementAnims[2];
            MovementAnims[3] = default.MovementAnims[3];
        }
    }
    else if( ClientSyrCount!=SyringeCount )
    {
        ClientSyrCount = SyringeCount;
        Switch( SyringeCount )
        {
            Case 1:
                SetBoneScale(3,0,'SyringeBoneOne');
                Break;
            Case 2:
                SetBoneScale(3,0,'SyringeBoneOne');
                SetBoneScale(4,0,'SyringeBoneTwo');
                Break;
            Case 3:
                SetBoneScale(3,0,'SyringeBoneOne');
                SetBoneScale(4,0,'SyringeBoneTwo');
                SetBoneScale(5,0,'SyringeBoneThree');
                Break;
            default:
                SetBoneScale(3,1,'SyringeBoneOne');
                SetBoneScale(4,1,'SyringeBoneTwo');
                SetBoneScale(5,1,'SyringeBoneThree');
                Break;
        }
    }
    else if( TraceHitPos!=vect(0,0,0) )
    {
        AddTraceHitFX(TraceHitPos);
        TraceHitPos = vect(0,0,0);
    }
    else if( bClientCloaked!=bCloaked )
    {
        bClientCloaked = bCloaked;
        bCloaked = !bCloaked;
        if( bCloaked )
            UnCloakBoss();
        else CloakBoss();
        bCloaked = bClientCloaked;
    }
}

simulated function int DoAnimAction( name AnimName )
{
    if(AnimName=='MeleeImpale' || AnimName=='MeleeClaw' || AnimName=='BossHitF')
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
       ControllerBossOS(Controller).AnimWaitChannel = ExpectingChannel;
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

    ControllerBossOS(Controller).SetWaitForAnimTimout(RageAnimDur,NewAnim); //BossZombieController to ControllerBossOS
}

simulated function bool AnimNeedsWait(name TestAnim)
{
    if(TestAnim == 'FireMG' ||TestAnim == 'PreFireMG' || TestAnim == 'FireEndMG' || TestAnim == 'Heal'
       || TestAnim == 'KnockDown' || TestAnim == 'Entrance' || TestAnim == 'VictoryLaugh' )
    {
        return true;
    }

    return false;
}

simulated function HandleBumpGlass()
{
}


function bool FlipOver()
{
    return false;
}

function bool ShouldChargeFromDamage()
{
    if( (SyringeCount==0 && Health<HealingLevels[0]) || (SyringeCount==1 && Health<HealingLevels[1]) || (SyringeCount==2 && Health<HealingLevels[2]) )
    {
        return false;
    }
    else if( !bChargingPlayer && Level.TimeSeconds - LastForceChargeTime > (5.0 + 5.0 * FRand()) )
    {
        return true;
    }

    return false;
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    local float DamagerDistSq;
    local float UsedPipeBombDamScale;

    if ( class<DamTypeCrossbow>(damageType) == none && class<DamTypeCrossbowHeadShot>(damageType) == none )
    {
        bOnlyDamagedByCrossbow = false;
    }

    if ( class<DamTypePipeBomb>(damageType) != none )
    {
       UsedPipeBombDamScale = FMax(0,(1.0 - PipeBombDamageScale));

       PipeBombDamageScale += 0.075;

       if( PipeBombDamageScale > 1.0 )
       {
           PipeBombDamageScale = 1.0;
       }

       Damage *= UsedPipeBombDamScale;
    }

    super.TakeDamage(Damage,instigatedBy,hitlocation,Momentum,damageType);

    if( Level.TimeSeconds - LastDamageTime > 10 )
    {
        ChargeDamage = 0;
    }
    else
    {
        LastDamageTime = Level.TimeSeconds;
        ChargeDamage += Damage;
    }

    if( ShouldChargeFromDamage() && ChargeDamage > 200 )
    {
        if( InstigatedBy != none )
        {
            DamagerDistSq = VSizeSquared(Location - InstigatedBy.Location);

            if( DamagerDistSq < (700 * 700) )
            {
                SetAnimAction('BossHitF');
                ChargeDamage=0;
                LastForceChargeTime = Level.TimeSeconds;
                GoToState('Charging');
                return;
            }
        }
    }

    if( Health<=0 || SyringeCount==3 || IsInState('Escaping') || IsInState('KnockDown'))
        return;

    if( ((SyringeCount==0 && Health<HealingLevels[0]) || (SyringeCount==1 && Health<HealingLevels[1]) || (SyringeCount==2 && Health<HealingLevels[2]) ))
    {
        bShotAnim = true;
        Acceleration = vect(0,0,0);
        SetAnimAction('KnockDown');
        HandleWaitForAnim('KnockDown');
        KFMonsterController(Controller).bUseFreezeHack = true;
        GoToState('KnockDown');
    }
}

function OldPlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum, optional int HitIndex)
{
    if(LastChainGunTime<Level.TimeSeconds + 1 || LastMissileTime<Level.TimeSeconds + 1)
        return;
    else
        super.OldPlayHit(Damage,InstigatedBy,HitLocation,damageType,Momentum,HitIndex);
}

function DoorAttack(Actor A)
{
    if ( bShotAnim )
        return;
    else if ( A!=none )
    {
        Controller.Target = A;
        bShotAnim = true;
        Acceleration = vect(0,0,0);
        SetAnimAction('PreFireMG');
        HandleWaitForAnim('PreFireMG');
        MGFireCounter = Rand(20);
        GoToState('FireMissile');
    }
}

function RemoveHead();
function PlayDirectionalHit(Vector HitLoc);

function bool SameSpeciesAs(Pawn P)
{
    return false;
}

function bool SetBossLaught()
{
    local Controller C;
    local string sHealthInfo;

    GoToState('');
    bShotAnim = true;
    Acceleration = vect(0,0,0);
    SetAnimAction('VictoryLaugh');
    HandleWaitForAnim('VictoryLaugh');
    bIsBossView = true;
    bSpecialCalcView = true;

    sHealthInfo = class'Utility'.static.ParseTagsStatic("^r^" $ MenuName $ "^w^'s health is ^b^" $ health $ " ^w^/ ^b^" $ HealthMax $ "^w^. Syringes used - ^b^" $ SyringeCount);

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        // ignore Messaging Spectators (Web Admin)
        if (c.bIsPlayer && PlayerController(C) != none)
        {
            PlayerController(C).SetViewTarget(self);
            PlayerController(C).ClientSetViewTarget(self);
            PlayerController(C).ClientSetBehindView(true);

            // send a cute message to loosers
            PlayerController(C).teamMessage(none, sHealthInfo, 'ZombieBossOS');
        }
    }

    return true;
}

simulated function bool SpectatorSpecialCalcView(PlayerController Viewer, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    Viewer.bBehindView = true;
    ViewActor = self;
    CameraRotation.Yaw = Rotation.Yaw-32768;
    CameraRotation.Pitch = 0;
    CameraRotation.Roll = Rotation.Roll;
    CameraLocation = Location + (vect(80,0,80) >> Rotation);
    return true;
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
    local Controller C;

    super.Died(Killer,damageType,HitLocation);

    KFGameType(Level.Game).DoBossDeath();

    For( C=Level.ControllerList; C!=none; C=C.NextController )
    {
        if( PlayerController(C)!=none )
        {
            PlayerController(C).SetViewTarget(self);
            PlayerController(C).ClientSetViewTarget(self);
            PlayerController(C).bBehindView = true;
            PlayerController(C).ClientSetBehindView(true);
        }
    }
}

function ClawDamageTarget()
{
    local vector PushDir;
    local name Anim;
    local float frame,rate;
    local float UsedMeleeDamage;
    local bool bDamagedSomeone;
    local KFHumanPawn P;
    local Actor OldTarget;

    if( MeleeDamage > 1 )
    {
        UsedMeleeDamage = (MeleeDamage - (MeleeDamage * 0.05)) + (MeleeDamage * (FRand() * 0.1));
    }
    else
    {
        UsedMeleeDamage = MeleeDamage;
    }

    GetAnimParams(1, Anim,frame,rate);

    if( Anim == 'MeleeImpale' )
    {
        MeleeRange = ImpaleMeleeDamageRange;
    }
    else
    {
        MeleeRange = ClawMeleeDamageRange;
    }

    if(Controller!=none && Controller.Target!=none)
        PushDir = (damageForce * Normal(Controller.Target.Location - Location));
    else
        PushDir = damageForce * vector(Rotation);

    if( Anim == 'MeleeImpale' )
    {
        bDamagedSomeone = MeleeDamageTarget(UsedMeleeDamage, PushDir);
    }
    else
    {
        OldTarget = Controller.Target;

        foreach DynamicActors(class'KFHumanPawn', P)
        {
            if ( (P.Location - Location) dot PushDir > 0.0 )
            {
                Controller.Target = P;
                bDamagedSomeone = bDamagedSomeone || MeleeDamageTarget(UsedMeleeDamage, damageForce * Normal(P.Location - Location));
            }
        }

        Controller.Target = OldTarget;
    }

    MeleeRange = default.MeleeRange;
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
    myLevel.AddPrecacheMaterial(FinalBlend'KFPatch2.BossHairFB');
    myLevel.AddPrecacheMaterial(FinalBlend'KFOldSchoolZeds_Textures.Patriarch.BossCloakFizzleFB');
    myLevel.AddPrecacheMaterial(Finalblend'KFOldSchoolZeds_Textures.Patriarch.BossGlowFB');
    myLevel.AddPrecacheMaterial(Texture'KFPatch2.BossBits');
    myLevel.AddPrecacheMaterial(Texture'KFPatch2.GunPoundSkin');
    myLevel.AddPrecacheMaterial(Texture'KFPatch2.BossGun');
    myLevel.AddPrecacheMaterial(Texture'KillingFloorLabTextures.LabCommon.voidtex');
    myLevel.AddPrecacheMaterial(Shader'KFPatch2.LaserShader');
    myLevel.AddPrecacheMaterial(Shader'KFOldSchoolZeds_Textures.BossCloakShader');
}

defaultproperties
{
    Mesh=SkeletalMesh'KFBossOld.Boss'
    Skins(0)=FinalBlend'KFPatch2.BossHairFB'
    Skins(1)=Texture'KFPatch2.BossBits'
    Skins(2)=Texture'KFPatch2.GunPoundSkin'
    Skins(3)=Texture'KFPatch2.BossGun'
    Skins(4)=Texture'KFPatch2.BossBits'
    Skins(5)=Texture'KFPatch2.BossBits'
    Skins(6)=Shader'KFPatch2.LaserShader'

    AmbientSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieBreath'
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Patriarch.Patriarch_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieJump'

    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Patriarch.Patriarch_Pain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieDeath'

    bMeleeStunImmune = true
    bFatAss=true
    RagDeathVel=80.000000
    RagDeathUpKick=100.000000
    MeleeRange=10.000000
    MovementAnims(0)="WalkF"
    MovementAnims(1)="WalkF"
    MovementAnims(2)="WalkF"
    MovementAnims(3)="WalkF"
    WalkAnims(0)="WalkF"
    WalkAnims(1)="WalkF"
    WalkAnims(2)="WalkF"
    WalkAnims(3)="WalkF"
    BurningWalkFAnims(0)="WalkF"
    BurningWalkFAnims(1)="WalkF"
    BurningWalkFAnims(2)="WalkF"
    BurningWalkAnims(0)="WalkF"
    BurningWalkAnims(1)="WalkF"
    BurningWalkAnims(2)="WalkF"
    AirAnims(0)="JumpInAir"
    AirAnims(1)="JumpInAir"
    AirAnims(2)="JumpInAir"
    AirAnims(3)="JumpInAir"
    TakeoffAnims(0)="JumpTakeOff"
    TakeoffAnims(1)="JumpTakeOff"
    TakeoffAnims(2)="JumpTakeOff"
    TakeoffAnims(3)="JumpTakeOff"
    LandAnims(0)="JumpLanded"
    LandAnims(1)="JumpLanded"
    LandAnims(2)="JumpLanded"
    LandAnims(3)="JumpLanded"
    AirStillAnim="JumpInAir"
    TakeoffStillAnim="JumpTakeOff"
    ChargingAnim="RunF"
    IdleHeavyAnim="BossIdle"
    IdleRifleAnim="BossIdle"
    IdleCrouchAnim="BossIdle"
    IdleWeaponAnim="BossIdle"
    IdleRestAnim="BossIdle"
    Mass=1000.000000
    RotationRate=(Yaw=36000,Roll=0)
    bBoss=true
    bCanDistanceAttackDoors=true
    bNetNotify=false
    bUseExtendedCollision=true
    DamageToMonsterScale=5.0

    ScoringValue=500
    GroundSpeed=120.000000
    WaterSpeed=120.000000
    MeleeDamage=100//75 - he does 100 + Rand(100) in the mod
    Health=4000//4000
    HealthMax=4000//4000
    PlayerCountHealthScale=0.75
    Intelligence=BRAINS_Human
    MGDamage=6.0
    HealingLevels(0)=5600
    HealingLevels(1)=3500
    HealingLevels(2)=2187
    HealingAmount=1750
    damageForce=170000
    CrispUpThreshhold=1
    MotionDetectorThreat=10.0
    PipeBombDamageScale=0.0
    ZapThreshold=5.0
    ZappedDamageMod=1.25
    ZapResistanceScale=1.0
    bHarpoonToHeadStuns=false
    bHarpoonToBodyStuns=false
    ClawMeleeDamageRange=85//50
    ImpaleMeleeDamageRange=45//75

    TurnLeftAnim="BossHitF"
    TurnRightAnim="BossHitF"
    MenuName="Patriarch 2.5"

    ColOffset=(Z=65)//(Z=50)
    ColRadius=27
    ColHeight=25//40
    PrePivot=(Z=3)

    ZombieFlag=3

    KFRagdollName="FleshPoundRag" // "BossRag" - this is buggy and dumb looking, use fleshpound instead since it's weighty

    HeadHeight=8.5
    HeadRadius=8.2
    OnlineHeadshotScale=1.1
    OnlineHeadshotOffset=(X=2,Y=-6,Z=74)

    ControllerClass=class'ControllerBossOS'
}