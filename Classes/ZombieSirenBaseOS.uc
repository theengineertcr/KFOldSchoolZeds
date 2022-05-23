//Because we want the zeds to extend to KFMonsterOS, there's no choice
//Other than to overhaul all 3 files of each zed, controllers as well if
//We count certain other Zeds

// Zombie Monster for KF Invasion gametype
class ZombieSirenBaseOS extends KFMonsterOS
    abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

//This new variable controls how close the Siren has to be before she can Scream
//Higher means closer, lower means farther
var float DistBeforeScream;
var () int ScreamRadius; // AOE for scream attack.

var () class <DamageType> ScreamDamageType;
var () int ScreamForce;

//We don't want to mess with these as the old Scream view shake was terrible
var(Shake)  rotator RotMag;            // how far to rot view
var(Shake)  float   RotRate;           // how fast to rot view
var(Shake)  vector  OffsetMag;         // max view offset vertically
var(Shake)  float   OffsetRate;        // how fast to offset view vertically
var(Shake)  float   ShakeTime;         // how long to shake for per scream
var(Shake)  float   ShakeFadeTime;     // how long after starting to shake to start fading out
var(Shake)  float    ShakeEffectScalar; // Overall scale for shake/blur effect
var(Shake)  float    MinShakeEffectScale;// The minimum that the shake effect drops off over distance
var(Shake)  float    ScreamBlurScale;   // How much motion blur to give from screams

var bool bAboutToDie;
var float DeathTimer;

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
    //These values were not set in KFMod
    //ExtCollAttachBoneName="Collision_Attach"
    //DrawScale=1.05
    //AmbientGlow=0
    ZombieFlag=1
    //SeveredHeadAttachScale=1.0
    //SeveredLegAttachScale=0.7
    //SeveredArmAttachScale=1.0

    //Values that don't need to be changed
    MeleeAnims(0)="Siren_Bite"
    MeleeAnims(1)="Siren_Bite"//"Siren_Bite2"//Only had one bite anim in the Mod
    MeleeAnims(2)="Siren_Bite"
    HitAnims(0)="HitReactionF"
    HitAnims(1)="HitReactionF"
    HitAnims(2)="HitReactionF"
    damageForce=5000
    ZombieDamType(0)=class'KFMod.DamTypeSlashingAttack'
    ZombieDamType(1)=class'KFMod.DamTypeSlashingAttack'
    ZombieDamType(2)=class'KFMod.DamTypeSlashingAttack'
    IdleHeavyAnim="Siren_Idle"
    IdleRifleAnim="Siren_Idle"
    MovementAnims(0)="Siren_Walk"
    MovementAnims(1)="Siren_Walk"
    MovementAnims(2)="Siren_Walk"
    MovementAnims(3)="Siren_Walk"
    WalkAnims(0)="Siren_Walk"
    WalkAnims(1)="Siren_Walk"
    WalkAnims(2)="Siren_Walk"
    WalkAnims(3)="Siren_Walk"
    IdleCrouchAnim="Siren_Idle"
    IdleWeaponAnim="Siren_Idle"
    IdleRestAnim="Siren_Idle"
    RotationRate=(Yaw=45000,Roll=0)

    //We'll keep these values the same as the retail version
    //As this mod was made purely for the visual aspect, not gameplay
    //This is an exception for the Siren as she no longer can move
    //While Screaming, so were going to increase her ScreamRadius
    DistBeforeScream=200
    ScreamRadius=900//700//800
    ScreamDamage=8 // 10
    ScreamDamageType=class'SirenScreamDamageOS'
    ScreamForce=-150000//-300000
    RotMag=(Pitch=150,Yaw=150,Roll=150)
    RotRate=500
    OffsetMag=(X=0.000000,Y=5.000000,Z=1.000000)
    OffsetRate=500
    MeleeDamage=13
    ScoringValue=25
    MeleeRange=45.000000
    GroundSpeed=100.0//100.000000
    WaterSpeed=80.000000
    Health=300//350
    HealthMax=300
    PlayerCountHealthScale=0.10
    PlayerNumHeadHealthScale=0.05
    HeadHealth=200
    ShakeEffectScalar=1.0
    ShakeTime=2.0
    ShakeFadeTime=0.25
    MinShakeEffectScale=0.6
    ScreamBlurScale=0.85
    CrispUpThreshhold=7
    MotionDetectorThreat=2.0
    ZapThreshold=0.5
    ZappedDamageMod=1.5

    KFRagdollName="SirenRag"//"Siren_Trip"//Old Ragdoll

    //Yet to make this
    //SoundGroupClass=class'KFMod.KFFemaleZombieSounds'

    // these could need to be moved into children if children change them
    //KFMod zeds don't use challenge sounds
    ChallengeSound(0)=none
    ChallengeSound(1)=none
    ChallengeSound(2)=none
    ChallengeSound(3)=none

    MenuName="Siren 2.5"//"Siren"
    bCanDistanceAttackDoors=true

    PrePivot=(Z=-13)
    bUseExtendedCollision=true
    ColOffset=(Z=48)
    ColRadius=25
    ColHeight=5

    SoloHeadScale=1.2

    //Updated
    OnlineHeadshotOffset=(X=25,Y=-3,Z=41)
    OnlineHeadshotScale=1.2//1.3//1.2
}