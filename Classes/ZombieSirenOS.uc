class ZombieSirenOS extends KFMonsterOS;

var float DistBeforeScream;
var () int ScreamRadius;

var () class <DamageType> ScreamDamageType;
var () int ScreamForce;

var(Shake)  rotator RotMag;
var(Shake)  float   RotRate;
var(Shake)  vector  OffsetMag;
var(Shake)  float   OffsetRate;
var(Shake)  float   ShakeTime;
var(Shake)  float   ShakeFadeTime;
var(Shake)  float    ShakeEffectScalar;
var(Shake)  float    MinShakeEffectScale;
var(Shake)  float    ScreamBlurScale;

var bool bAboutToDie;
var float DeathTimer;
var bool bEnableSirenNadeBoom;

// Fixes credit: https://github.com/Shtoyan/KF1066/blob/main/docs/VeryAnnoying/ZedIssues.md

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if(bEnableSirenNadeBoom)
        ScreamDamageType=class'SirenScreamDamageOS';
}

function bool FlipOver()
{
    return false;
}

function DoorAttack(Actor A)
{
    if ( bShotAnim || Physics == PHYS_Swimming || bDecapitated || A==none )
        return;
    bShotAnim = true;
    SetAnimAction('Siren_Scream');
}

function RangedAttack(Actor A)
{
    local int LastFireTime;
    local float Dist;

    if ( bShotAnim )
        return;

    Dist = VSize(A.Location - Location);

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
    else if( Dist <= (ScreamRadius - DistBeforeScream) && !bDecapitated && !bZapped )
    {
        bShotAnim=true;
        SetAnimAction('Siren_Scream');
        Controller.bPreparingMove = true;
        Acceleration = vect(0,0,0);
    }
}

simulated function SpawnTwoShots()
{
    if( bZapped || bDecapitated)
    {
        return;
    }

    DoShakeEffect();

    if( Level.NetMode!=NM_Client )
    {
        if( Controller!=none && KFDoorMover(Controller.Target)!=none )
            Controller.Target.TakeDamage(ScreamDamage*0.6,self,Location,vect(0,0,0),ScreamDamageType);
        else
            HurtRadius(ScreamDamage ,ScreamRadius, ScreamDamageType, ScreamForce, Location);
    }
}

simulated function DoShakeEffect()
{
    local PlayerController PC;
    local float Dist, scale, BlurScale;

    if (Level.NetMode != NM_DedicatedServer)
    {
        PC = Level.GetLocalPlayerController();
        if (PC != none && PC.ViewTarget != none)
        {
            Dist = VSize(Location - PC.ViewTarget.Location);

            if (Dist < ScreamRadius )
            {
                scale = (ScreamRadius - Dist) / (ScreamRadius);
                scale *= ShakeEffectScalar;
                BlurScale = scale;

                if( !FastTrace(PC.ViewTarget.Location,Location) )
                {
                    scale *= 0.25;
                    BlurScale = scale;
                }
                else
                {
                    scale = Lerp(scale,MinShakeEffectScale,1.0);
                }

                PC.SetAmbientShake(Level.TimeSeconds + ShakeFadeTime, ShakeTime, OffsetMag * Scale, OffsetRate, RotMag * Scale, RotRate);

                if( KFHumanPawn(PC.ViewTarget) != none )
                {
                    KFHumanPawn(PC.ViewTarget).AddBlur(ShakeTime, BlurScale * ScreamBlurScale);
                }

                if ( Level != none && Level.Game != none && !KFGameType(Level.Game).bDidSirenScreamMessage && FRand() < 0.10 )
                {
                    PC.Speech('AUTO', 16, "");
                    KFGameType(Level.Game).bDidSirenScreamMessage = true;
                }
            }
        }
    }
}

simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
    local actor Victims;
    local float damageScale, dist;
    local vector dir;
    local float UsedDamageAmount;

    if( bHurtEntry )
        return;

    bHurtEntry = true;

    foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
    {
        if( (Victims != self) && !Victims.IsA('FluidSurfaceInfo') && !Victims.IsA('KFMonster') && !Victims.IsA('ExtendedZCollision') )
        {
            dir = Victims.Location - HitLocation;
            dist = FMax(1,VSize(dir));
            dir = dir/dist;
            damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);

            if (!Victims.IsA('KFHumanPawn'))
                Momentum = 0;

            if (Victims.IsA('KFGlassMover'))
            {
                UsedDamageAmount = 100000;
            }
            else
            {
                UsedDamageAmount = DamageAmount;
            }

            Victims.TakeDamage(damageScale * UsedDamageAmount,Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,(damageScale * Momentum * dir),DamageType);

            if (Instigator != none && Vehicle(Victims) != none && Vehicle(Victims).Health > 0)
                Vehicle(Victims).DriverRadiusDamage(UsedDamageAmount, DamageRadius, Instigator.Controller, DamageType, Momentum, HitLocation);
        }
    }

    bHurtEntry = false;
}

function RemoveHead()
{
    super.RemoveHead();
    if( FRand()<0.5 )
        KilledBy(LastDamagedBy);
    else
    {
        bAboutToDie = true;
        MeleeRange = -500;
        DeathTimer = Level.TimeSeconds+10*FRand();
    }
}

State ZombieDyingOS
{
    ignores AnimEnd, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer, Died, RangedAttack, SpawnTwoShots;
}

simulated function Tick( float Delta )
{
    super.Tick(Delta);
    if( bAboutToDie && Level.TimeSeconds>DeathTimer )
    {
        if( Health>0 && Level.NetMode!=NM_Client )
            KilledBy(LastDamagedBy);
        bAboutToDie = false;
    }
}

function PlayDyingSound()
{
    if( !bAboutToDie )
        super.PlayDyingSound();
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Siren.SirenSkin');
    myLevel.AddPrecacheMaterial(FinalBlend'KFOldSchoolZeds_Textures.Siren.SirenHairFB');
}

defaultproperties
{
    Mesh=SkeletalMesh'KFCharacterModelsOldSchool.InfectedWhiteMale2'
    Skins(0)=Texture'KFOldSchoolZeds_Textures.Siren.SirenSkin'
    Skins(1)=FinalBlend'KFOldSchoolZeds_Textures.Siren.SirenHairFB'

    AmbientSound=none
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Siren.Siren_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Female_ZombieJump'

    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Female_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Stalker.Siren_Die'

    MenuName="Siren 2.5"
    ScoringValue=25
    ZombieFlag=1
    ControllerClass=class'ControllerSirenOS'

    IdleHeavyAnim="Siren_Idle"
    IdleRifleAnim="Siren_Idle"
    IdleCrouchAnim="Siren_Idle"
    IdleWeaponAnim="Siren_Idle"
    IdleRestAnim="Siren_Idle"

    MovementAnims(0)="Siren_Walk"
    MovementAnims(1)="Siren_Walk"
    MovementAnims(2)="Siren_Walk"
    MovementAnims(3)="Siren_Walk"
    WalkAnims(0)="Siren_Walk"
    WalkAnims(1)="Siren_Walk"
    WalkAnims(2)="Siren_Walk"
    WalkAnims(3)="Siren_Walk"

    HitAnims(0)="HitReactionF"
    HitAnims(1)="HitReactionF"
    HitAnims(2)="HitReactionF"

    MeleeAnims(0)="Siren_Bite"
    MeleeAnims(1)="Siren_Bite"
    MeleeAnims(2)="Siren_Bite"

    MeleeDamage=13
    MeleeRange=45.000000
    damageForce=5000

    ZombieDamType(0)=class'KFMod.DamTypeSlashingAttack'
    ZombieDamType(1)=class'KFMod.DamTypeSlashingAttack'
    ZombieDamType(2)=class'KFMod.DamTypeSlashingAttack'

    PrePivot=(Z=-8)

    bUseExtendedCollision=true
    ColOffset=(Z=48)
    ColRadius=25
    ColHeight=5

    OnlineHeadshotScale=1.2
    OnlineHeadshotOffset=(X=12,Y=-3,Z=44)

    DistBeforeScream=200
    ScreamRadius=900
    ScreamDamage=8
    ScreamDamageType=class'SirenScreamDamage'
    ScreamForce=-150000
    RotMag=(Pitch=150,Yaw=150,Roll=150)
    RotRate=500
    OffsetMag=(X=0.000000,Y=5.000000,Z=1.000000)
    OffsetRate=500
    ShakeEffectScalar=1.0
    ShakeTime=2.0
    ShakeFadeTime=0.25
    MinShakeEffectScale=0.6
    ScreamBlurScale=0.85

    GroundSpeed=100.0
    WaterSpeed=80.000000

    HeadRadius=6.0
    HeadHeight=4.5
    Health=300
    HealthMax=300
    PlayerCountHealthScale=0.10
    HeadHealth=200
    PlayerNumHeadHealthScale=0.05

    RotationRate=(Yaw=45000,Roll=0)

    CrispUpThreshhold=7

    MotionDetectorThreat=2.0

    ZapThreshold=0.5
    ZappedDamageMod=1.5

    bCanDistanceAttackDoors=true

    KFRagdollName="SirenRag"
    SoundGroupClass=class'KFOldSchoolZeds.KFFemaleZombieSoundsOS'
}