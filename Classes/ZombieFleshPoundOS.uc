class ZombieFleshpoundOS extends KFMonsterOS;

var bool bChargingPlayer,bClientCharge;
var int TwoSecondDamageTotal;
var float LastDamagedTime,RageEndTime;
var() vector RotMag;
var() vector RotRate;
var() float    RotTime;
var() vector OffsetMag;
var() vector OffsetRate;
var() float    OffsetTime;
var name ChargingAnim;
var () int RageDamageThreshold;
var FleshPoundAvoidArea AvoidArea;
var bool    bFrustrated;
var bool bEnableOldFleshpoundBehavior;

replication
{
    reliable if(Role == ROLE_Authority)
        bChargingPlayer, bFrustrated;
}

simulated function PostNetBeginPlay()
{
    //TODO: Make Avoid Area spawn if Fleshy is charging
    //Also, extend AvoidArea box more forward so zeds
    //In front have chance to move away once Zeds notice
    //That he's pissed off. Or, just remove it entirely.

    //if (AvoidArea == none && bChargingPlayer )
    //    AvoidArea = Spawn(class'FleshPoundAvoidArea',self);
    //if (AvoidArea != none)
    //    AvoidArea.InitFor(self);

    EnableChannelNotify ( 1,1);
    AnimBlendParams(1, 1.0, 0.0,, SpineBone1);
    super.PostNetBeginPlay();
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
            SpinDamConst = default.SpinDamConst * 0.5;
        }
        else if( Level.Game.GameDifficulty < 4.0 )
        {
            SpinDamConst = default.SpinDamConst * 1.0;
        }
        else if( Level.Game.GameDifficulty < 5.0 )
        {
            SpinDamConst = default.SpinDamConst * 1.2;
        }
        else // Hardest difficulty
        {
            SpinDamConst = default.SpinDamConst * 1.6;
        }
    }

    super.PostBeginPlay();
}

// This zed has been taken control of. Boost its health and speed
function SetMindControlled(bool bNewMindControlled)
{
    if( bNewMindControlled )
    {
        NumZCDHits++;

        // if we hit him a couple of times, make him rage!
        if( NumZCDHits > 1 )
        {
            if( !IsInState('ChargeToMarker') )
            {
                GotoState('ChargeToMarker');
            }
            else
            {
                NumZCDHits = 1;
                if( IsInState('ChargeToMarker') )
                {
                    GotoState('');
                }
            }
        }
        else
        {
            if( IsInState('ChargeToMarker') )
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

// Handle the zed being commanded to move to a new location
function GivenNewMarker()
{
    if( bChargingPlayer && NumZCDHits > 1  )
    {
        GotoState('ChargeToMarker');
    }
    else
    {
        GotoState('');
    }
}


function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
    if( Level.TimeSeconds - LastPainAnim < MinTimeBetweenPainAnims )
        return;

    if( !Controller.IsInState('WaitForAnim') && Damage >= 10 )
        PlayDirectionalHit(HitLocation);

    LastPainAnim = Level.TimeSeconds;

    if( Level.TimeSeconds - LastPainSound < MinTimeBetweenPainSounds )
        return;

    LastPainSound = Level.TimeSeconds;

    PlaySound(HitSound[0], SLOT_Pain,1.25,,400);
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    local int OldHealth;
    local Vector X,Y,Z, Dir;
    local bool bIsHeadShot;
    local float HeadShotCheckScale;

    GetAxes(Rotation, X,Y,Z);

    if( LastDamagedTime<Level.TimeSeconds )
        TwoSecondDamageTotal = 0;

    LastDamagedTime = Level.TimeSeconds+2;
    OldHealth = Health;

    HeadShotCheckScale = 1.0;

    if( class<DamTypeMelee>(damageType) != none )
        HeadShotCheckScale *= 1.25;

    bIsHeadShot = IsHeadShot(Hitlocation, normal(Momentum), 1.0);

    if ( DamageType != class 'DamTypeFrag' && DamageType != class 'DamTypeLaw' && DamageType != class 'DamTypePipeBomb'
        && DamageType != class 'DamTypeM79Grenade' && DamageType != class 'DamTypeM32Grenade'
        && DamageType != class 'DamTypeM203Grenade' && DamageType != class 'DamTypeMedicNade'
        && DamageType != class 'DamTypeSPGrenade' && DamageType != class 'DamTypeSealSquealExplosion'
        && DamageType != class 'DamTypeSeekerSixRocket' )
    {
        if(bIsHeadShot && class<KFWeaponDamageType>(damageType)!=none &&
           class<KFWeaponDamageType>(damageType).default.HeadShotDamageMult >= 1.5)
            Damage *= 0.75;
        else if ( Level.Game.GameDifficulty >= 5.0 && bIsHeadshot && (class<DamTypeCrossbow>(damageType) != none || class<DamTypeCrossbowHeadShot>(damageType) != none) )
            Damage *= 0.35;
        else
            Damage *= 0.5;
    }
    else if (DamageType == class 'DamTypeFrag' || DamageType == class 'DamTypePipeBomb' || DamageType == class 'DamTypeMedicNade' )
        Damage *= 2.0;
    else if( DamageType == class 'DamTypeM79Grenade' || DamageType == class 'DamTypeM32Grenade'
         || DamageType == class 'DamTypeM203Grenade' || DamageType == class 'DamTypeSPGrenade'
         || DamageType == class 'DamTypeSealSquealExplosion' || DamageType == class 'DamTypeSeekerSixRocket')
        Damage *= 1.25;

    if (Damage >= Health)
        PostNetReceive();


    Dir = -Normal(Location - hitlocation);

    if (damageType == class 'DamTypeVomit')
        Damage = 0;
    else if( damageType == class 'DamTypeBlowerThrower' )
       Damage *= 0.25;

    super.takeDamage(Damage, instigatedBy, hitLocation, momentum, damageType,HitIndex) ;

    TwoSecondDamageTotal += OldHealth - Health;

    if (!bDecapitated && TwoSecondDamageTotal > RageDamageThreshold && !bChargingPlayer &&
        !bZapped && (!(bCrispified && bBurnified) || bFrustrated) )
        StartCharging();

}

simulated function DeviceGoRed()
{
    Skins[1]=FinalBlend'KFOldSchoolZeds_Textures.Fleshpound.RedPoundMeter';
    Skins[2]=Shader'KFOldSchoolZeds_Textures.Fleshpound.FPDeviceBloomRedShader';
}

simulated function DeviceGoNormal()
{
    Skins[1]=FinalBlend'KFOldSchoolZeds_Textures.Fleshpound.AmberPoundMeter';
    Skins[2]=Shader'KFOldSchoolZeds_Textures.Fleshpound.FPDeviceBloomAmberShader';
}

function RangedAttack(Actor A)
{
    local float Dist;

    Dist = VSize(A.Location - Location);

    if ( bShotAnim || Physics == PHYS_Swimming)
        return;
    else if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius || CanAttack(A))
    {
            bShotAnim = true;
            SetAnimAction('Claw');
            PlaySound(sound'Claw2s', SLOT_None);
            damageForce=default.damageForce;
            return;
    }
}

function StartCharging()
{
    local float RageAnimDur;

    if( Health <= 0 )
        return;

    SetAnimAction('PoundRage');
    Acceleration = vect(0,0,0);
    bShotAnim = true;
    Velocity.X = 0;
    Velocity.Y = 0;
    Controller.GoToState('WaitForAnim');
    KFMonsterControllerOS(Controller).bUseFreezeHack = true;
    RageAnimDur = GetAnimDuration('PoundRage');
    ControllerFleshpoundOS(Controller).SetPoundRageTimout(RageAnimDur);
    GoToState('BeginRaging');
}

state BeginRaging
{
    Ignores StartCharging;

    simulated function SetZappedBehavior()
    {
        Global.SetZappedBehavior();
        GoToState('');
    }

    function Tick( float Delta )
    {
        Acceleration = vect(0,0,0);

        global.Tick(Delta);
    }

Begin:
    Sleep(GetAnimDuration('PoundRage'));
    GotoState('RageCharging');
}


simulated function SetBurningBehavior()
{
    if( bFrustrated || bChargingPlayer )
        return;

    super.SetBurningBehavior();
}

state RageCharging
{
Ignores StartCharging;

    simulated function SetZappedBehavior()
    {
        Global.SetZappedBehavior();
           GoToState('');
    }

    function PlayDirectionalHit(Vector HitLoc)
    {
        if( !bShotAnim )
            super.PlayDirectionalHit(HitLoc);
    }

    function bool CanSpeedAdjust()
    {
        return false;
    }

    //Dont play hit anims while charging so people don't complain about broken head hitboxes :)
    function OldPlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum, optional int HitIndex){}

    function BeginState()
    {
        local float DifficultyModifier;

        if( bZapped )
        {
            GoToState('');
        }
        else
        {
            bChargingPlayer = true;
            if( Level.NetMode!=NM_DedicatedServer )
                ClientChargingAnims();

            if( Level.Game.GameDifficulty < 2.0 )
            {
                DifficultyModifier = 0.85;
            }
            else if( Level.Game.GameDifficulty < 4.0 )
            {
                DifficultyModifier = 1.0;
            }
            else if( Level.Game.GameDifficulty < 5.0 )
            {
                DifficultyModifier = 1.25;
            }
            else
            {
                DifficultyModifier = 3.0;
            }

            OnlineHeadshotOffset.Z=50;
            OnlineHeadshotOffset.X=44;
            OnlineHeadshotOffset.Y=-4;

            if(!bEnableOldFleshpoundBehavior)
                RageEndTime = (Level.TimeSeconds + 5 * DifficultyModifier) + (FRand() * 6 * DifficultyModifier);
            else
                RageEndTime = Level.TimeSeconds + 10;
            NetUpdateTime = Level.TimeSeconds - 1;
        }
    }

    function EndState()
    {
        bChargingPlayer = false;
        bFrustrated = false;

        ControllerFleshpoundOS(Controller).RageFrustrationTimer = 0;

        if( Health>0 && !bZapped )
            SetGroundSpeed(GetOriginalGroundSpeed());

        if( Level.NetMode!=NM_DedicatedServer )
            ClientChargingAnims();


        OnlineHeadshotOffset = default.OnlineHeadshotOffset;
        NetUpdateTime = Level.TimeSeconds - 1;
    }

    function Tick( float Delta )
    {
        if( !bShotAnim )
        {
            SetGroundSpeed(OriginalGroundSpeed * 2.3);
            if( !bFrustrated && !bZedUnderControl && Level.TimeSeconds>RageEndTime )
                GoToState('');
        }

        if( Role == ROLE_Authority && bShotAnim)
        {
            if( LookTarget!=None )
                Acceleration = AccelRate * Normal(LookTarget.Location - Location);
        }

        global.Tick(Delta);
    }

    function RangedAttack(Actor A)
    {
        local float Dist;

        Dist = VSize(A.Location - Location);

        if ( bShotAnim || Physics == PHYS_Swimming)
            return;
        else if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius )
        {
            bShotAnim = true;
            SetAnimAction('FPRageAttack'); // ACTUALLY do your rage attack when raged
            damageForce=-20000;            // Your rage attack looks like it pulls players, so actually pull them
            PlaySound(sound'Claw2s', SLOT_None);
            return;
        }
    }

    function Bump( Actor Other )
    {
        local float RageBumpDamage;
        local KFMonster KFMonst;

        KFMonst = KFMonster(Other);

        if( !bShotAnim && KFMonst!=none && ZombieFleshPound(Other)==none && ZombieFleshPoundOS(Other)==none && Pawn(Other).Health>0 )
        {
            if( FRand() < 0.4 )
                 RageBumpDamage = 501;
            else
                 RageBumpDamage = 450;

            RageBumpDamage *= KFMonst.PoundRageBumpDamScale;

            Other.TakeDamage(RageBumpDamage, self, Other.Location, Velocity * Other.Mass, class'DamTypePoundCrushed');
        }
        else Global.Bump(Other);
    }

    function bool MeleeDamageTarget(int hitdamage, vector pushdir)
    {
        local bool RetVal,bWasEnemy;

        bWasEnemy = (Controller.Target==Controller.Enemy);
        RetVal = super.MeleeDamageTarget(hitdamage*1.75, pushdir*3);

        if( RetVal && bWasEnemy )
            GoToState('');

        return RetVal;
    }
}

state ChargeToMarker extends RageCharging
{
Ignores StartCharging;

    function Tick( float Delta )
    {
        if( !bShotAnim )
        {
            SetGroundSpeed(OriginalGroundSpeed * 2.3);
            if( !bFrustrated && !bZedUnderControl && Level.TimeSeconds>RageEndTime )
                GoToState('');
        }

        global.Tick(Delta);
    }

    function RangedAttack(Actor A)
    {
        local float Dist;

        Dist = VSize(A.Location - Location);

        if ( bShotAnim || Physics == PHYS_Swimming)
            return;
        else if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius )
        {
            bShotAnim = true;
            SetAnimAction('Claw');
            PlaySound(sound'Claw2s', SLOT_None);
            return;
        }
    }
}

simulated function PostNetReceive()
{
    if( bClientCharge!=bChargingPlayer && !bZapped )
    {
        bClientCharge = bChargingPlayer;
        if (bChargingPlayer)
        {
            MovementAnims[0]=ChargingAnim;
            MeleeAnims[0]='FPRageAttack';
            MeleeAnims[1]='FPRageAttack';
            MeleeAnims[2]='FPRageAttack';
            DeviceGoRed();
        }
        else
        {
            MovementAnims[0]=default.MovementAnims[0];
            MeleeAnims[0]=default.MeleeAnims[0];
            MeleeAnims[1]=default.MeleeAnims[1];
            MeleeAnims[2]=default.MeleeAnims[2];
            DeviceGoNormal();
        }
    }
}

simulated function PlayDyingAnimation(class<DamageType> DamageType, vector HitLoc)
{
    super.PlayDyingAnimation(DamageType,HitLoc);
    if( Level.NetMode!=NM_DedicatedServer )
        DeviceGoNormal();
}

simulated function ClientChargingAnims()
{
    PostNetReceive();
}

function ClawDamageTarget()
{
    local vector PushDir;
    local KFHumanPawn HumanTarget;
    local KFPlayerController HumanTargetController;
    local float UsedMeleeDamage;
    local name  Sequence;
    local float Frame, Rate;

    GetAnimParams( ExpectingChannel, Sequence, Frame, Rate );

    if( MeleeDamage > 1 )
       UsedMeleeDamage = (MeleeDamage - (MeleeDamage * 0.05)) + (MeleeDamage * (FRand() * 0.1));
    else
       UsedMeleeDamage = MeleeDamage;

    if( Sequence == 'PoundAttack1' )
        UsedMeleeDamage *= 0.5;
    else if( Sequence == 'PoundAttack2' )
        UsedMeleeDamage *= 0.25;

    if(Controller!=none && Controller.Target!=none)
        PushDir = (damageForce * Normal(Controller.Target.Location - Location));
    else
        PushDir = damageForce * vector(Rotation);

    if (MeleeDamageTarget(UsedMeleeDamage,PushDir))
    {
        HumanTarget = KFHumanPawn(Controller.Target);
        if( HumanTarget!=none )
            HumanTargetController = KFPlayerController(HumanTarget.Controller);
        if( HumanTargetController!=none )
            HumanTargetController.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);
        PlayZombieAttackHitSound();
    }
}

function SpinDamage(actor Target)
{
    local vector HitLocation;
    local Name TearBone;
    local Float dummy;
    local float DamageAmount;
    local vector PushDir;
    local KFHumanPawn HumanTarget;

    if(target==none)
        return;

    PushDir = (damageForce * Normal(Target.Location - Location));
    damageamount = (SpinDamConst);

    if (Target.IsA('KFHumanPawn') && Pawn(Target).Health <= DamageAmount)
    {
        KFHumanPawn(Target).RagDeathVel *= 3;
        KFHumanPawn(Target).RagDeathUpKick *= 1.5;
    }

    if (Target !=none && Target.IsA('KFDoorMover'))
    {
        Target.TakeDamage(DamageAmount,self,HitLocation,pushdir,class'KFmod.ZombieMeleeDamage');
        PlayZombieAttackHitSound();
    }

    if (KFHumanPawn(Target)!=none)
    {
        HumanTarget = KFHumanPawn(Target);

        if (HumanTarget.Controller != none)
            HumanTarget.Controller.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);

        KFHumanPawn(Target).TakeDamage(DamageAmount,self,HitLocation,pushdir,class'KFmod.ZombieMeleeDamage');

        if (KFHumanPawn(Target).Health <=0)
        {
            KFHumanPawn(Target).SpawnGibs(rotator(pushdir), 1);
            TearBone=KFPawn(Target).GetClosestBone(HitLocation,Velocity,dummy);
            KFHumanPawn(Controller.Target).HideBone(TearBone);
        }
    }
}

simulated function int DoAnimAction( name AnimName )
{
    if( AnimName=='PoundAttack1' || AnimName=='PoundAttack2' || AnimName=='FPRageAttack' || AnimName=='ZombieFireGun' )
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

    if (!bWaitForAnim)
    {
        AnimAction = NewAction;

        if ( AnimAction == KFHitFront )
        {
            AnimBlendParams(1, 1.0, 0.0,,'Bip01 Spine1');
            PlayAnim(NewAction,, 0.0, 1);
        }
        else if ( AnimAction == KFHitBack )
        {
            AnimBlendParams(1, 1.0, 0.0,, 'Bip01 Spine1');
            PlayAnim(NewAction,, 0.0, 1);
        }
        else if ( AnimAction == KFHitRight )
        {
            AnimBlendParams(1, 1.0, 0.0,, 'Bip01 Spine1');
            PlayAnim(NewAction,, 0.0, 1);
        }
        else if ( AnimAction == KFHitLeft )
        {
            AnimBlendParams(1, 1.0, 0.0,, 'Bip01 Spine1');
            PlayAnim(NewAction,, 0.0, 1);
        }
        else if ( AnimAction == 'PoundRage' )
            PlayAnim(NewAction);
        else if ( AnimAction == 'PoundAttack1' )
        {
            AnimBlendParams(1, 1.0, 0.0,, 'Bip01 Spine1');
            PlayAnim(NewAction,, 0.0, 1);
        }
        else if ( AnimAction == 'PoundAttack2' )
        {
            AnimBlendParams(1, 1.0, 0.0,, 'Bip01 Spine1');
            PlayAnim(NewAction,, 0.0, 1);
        }
        else if ( AnimAction == 'FPRageAttack' )
        {
            AnimBlendParams(1, 1.0, 0.0,, 'Bip01 Spine1');
            PlayAnim(NewAction,, 0.0, 1);
        }
        else if(AnimAction == 'Claw')
        {
            meleeAnimIndex = Rand(3);
            AnimAction=meleeAnims[Rand(3)];
            CurrentDamtype = ZombieDamType[meleeAnimIndex];
            SetAnimAction(AnimAction);
            return;
        }

        //Maybe the reason this attack animation doesn't play online is because of it not being in AnimNeedsWait like Scrake's?
        if( AnimAction=='PoundAttack3' && Controller!=none )
            Controller.GotoState('spinattack');
        else if(NewAction == 'ZombieFeed')
        {
            AnimAction = NewAction;
            LoopAnim(AnimAction,,0.1);
        }
        else AnimAction = NewAction;

        if (PlayAnim(AnimAction,,0.1) && AnimAction != KFHitFront     && AnimAction != KFHitBack      && AnimAction != KFHitLeft &&
            AnimAction != KFHitRight  && AnimAction != 'PoundAttack1' && AnimAction != 'PoundAttack2' && AnimAction != 'FPRageAttack')
        {
            if ( Physics != PHYS_None )
                bWaitForAnim = true;
        }
    }
}

simulated function bool AnimNeedsWait(name TestAnim)
{
    if( TestAnim == 'PoundAttack3')
        return true;

    return false;
}

function bool FlipOver()
{
    return false;
}

function bool SameSpeciesAs(Pawn P)
{
    return (ZombieFleshPound(P)!=none || ZombieFleshPoundOS(P)!=none);
}

simulated function Destroyed()
{
    if( AvoidArea!=none )
        AvoidArea.Destroy();

    super.Destroyed();
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
    myLevel.AddPrecacheMaterial(FinalBlend'KFOldSchoolZeds_Textures.Fleshpound.RedPoundMeter');
    myLevel.AddPrecacheMaterial(FinalBlend'KFOldSchoolZeds_Textures.Fleshpound.AmberPoundMeter');
    myLevel.AddPrecacheMaterial(Shader'KFOldSchoolZeds_Textures.Fleshpound.FPDeviceBloomRedShader');
    myLevel.AddPrecacheMaterial(Shader'KFOldSchoolZeds_Textures.Fleshpound.FPDeviceBloomAmberShader');
    myLevel.AddPrecacheMaterial(Shader'KFOldSchoolZeds_Textures.Fleshpound.PoundBitsShader');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Fleshpound.PoundSkin');
}

defaultproperties
{
    Mesh=SkeletalMesh'KFCharacterModelsOldSchool.ZombieBoss'
    Skins(0)=Shader'KFOldSchoolZeds_Textures.Fleshpound.PoundBitsShader'
    Skins(1)=FinalBlend'KFOldSchoolZeds_Textures.Fleshpound.AmberPoundMeter'
    Skins(2)=Shader'KFOldSchoolZeds_Textures.Fleshpound.FPDeviceBloomAmberShader'
    Skins(3)=Texture'KFOldSchoolZeds_Textures.Fleshpound.PoundSkin'
    AmbientSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieBreath'
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Fleshpound.Fleshpound_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieJump'
    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieDeath'
    ZombieFlag=3
    bMeleeStunImmune = true
    bFatAss=true
    Mass=600.000000
    MeleeAnims(0)="PoundAttack1"
    MeleeAnims(1)="PoundAttack2"
    MeleeAnims(2)="PoundAttack3"
    IdleHeavyAnim="PoundIdle"
    IdleRifleAnim="PoundIdle"
    IdleCrouchAnim="PoundIdle"
    IdleWeaponAnim="PoundIdle"
    IdleRestAnim="PoundIdle"
    ChargingAnim = "PoundRun"
    RotationRate=(Yaw=45000,Roll=0)
    RagDeathVel=100.000000
    RagDeathUpKick=100.000000
    bBoss=true
    DamageToMonsterScale=5.0
    ScoringValue=200
    RotMag=(X=500.000000,Y=500.000000,Z=600.000000)
    RotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
    RotTime=6.000000
    OffsetMag=(X=5.000000,Y=10.000000,Z=5.000000)
    OffsetRate=(X=300.000000,Y=300.000000,Z=300.000000)
    OffsetTime=3.500000
    MeleeRange=55.000000
    damageForce=15000 //Extra 0 turns him into KFMod FP :)
    GroundSpeed=130.000000
    WaterSpeed=120.000000
    MeleeDamage=35
    SpinDamConst=5.000000
    Health=1500
    HealthMax=1500
    PlayerCountHealthScale=0.25
    PlayerNumHeadHealthScale=0.30
    HeadHealth=700
    RageDamageThreshold = 360
    Intelligence=BRAINS_Mammal
    BleedOutDuration=7.0
    MotionDetectorThreat=5.0
    ZapThreshold=1.75
    ZappedDamageMod=1.25
    bHarpoonToHeadStuns=true
    bHarpoonToBodyStuns=false
    MovementAnims(0)="PoundWalk"
    MovementAnims(1)="PoundWalk"
    MovementAnims(2)="PoundWalk"
    MovementAnims(3)="PoundWalk"
    WalkAnims(0)="PoundWalk"
    WalkAnims(1)="PoundWalk"
    WalkAnims(2)="PoundWalk"
    WalkAnims(3)="PoundWalk"
    KFRagdollName="FleshPoundRag"
    MenuName="Flesh Pound 2.5"
    HeadHeight=9
    HeadRadius=8.2
    bUseExtendedCollision=true
    ColOffset=(Z=52.000000)
    ColRadius=36.000000
    ColHeight=35.000000
    PrePivot=(Z=0)
    OnlineHeadshotScale=1.2
    OnlineHeadshotOffset=(X=-9,Y=-6,Z=69)
    ControllerClass=class'ControllerFleshpoundOS'
}