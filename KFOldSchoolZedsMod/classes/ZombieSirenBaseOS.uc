// Zombie Monster for KF Invasion gametype
class ZombieSirenBase extends KFMonster
    abstract;

var () int ScreamRadius; // AOE for scream attack.

var () class <DamageType> ScreamDamageType;
var () int ScreamForce;

var(Shake)  rotator RotMag;            // how far to rot view
var(Shake)  float   RotRate;           // how fast to rot view
var(Shake)  vector  OffsetMag;         // max view offset vertically
var(Shake)  float   OffsetRate;        // how fast to offset view vertically
var(Shake)  float   ShakeTime;         // how long to shake for per scream
var(Shake)  float   ShakeFadeTime;     // how long after starting to shake to start fading out
var(Shake)  float	ShakeEffectScalar; // Overall scale for shake/blur effect
var(Shake)  float	MinShakeEffectScale;// The minimum that the shake effect drops off over distance
var(Shake)  float	ScreamBlurScale;   // How much motion blur to give from screams

var bool bAboutToDie;
var float DeathTimer;

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
    bUseExtendedCollision=true
	ColOffset=(Z=48)
	ColRadius=25
	ColHeight=5

    ExtCollAttachBoneName="Collision_Attach"

    DrawScale=1.05
    PrePivot=(Z=3)
    ScreamRadius=700//800
    ScreamDamage=8 // 10
    ScreamDamageType=Class'KFMod.SirenScreamDamage'
    ScreamForce=-150000//-300000
    RotMag=(Pitch=150,Yaw=150,Roll=150)
    RotRate=500
    OffsetMag=(X=0.000000,Y=5.000000,Z=1.000000)
    OffsetRate=500
    MeleeAnims(0)="Siren_Bite"
    MeleeAnims(1)="Siren_Bite2"
    MeleeAnims(2)="Siren_Bite"
    HitAnims(0)="HitReactionF"
    HitAnims(1)="HitReactionF"
    HitAnims(2)="HitReactionF"
    MeleeDamage=13
    damageForce=5000
    KFRagdollName="Siren_Trip"
    ZombieDamType(0)=Class'KFMod.DamTypeSlashingAttack'
    ZombieDamType(1)=Class'KFMod.DamTypeSlashingAttack'
    ZombieDamType(2)=Class'KFMod.DamTypeSlashingAttack'

    ScoringValue=25
    SoundGroupClass=Class'KFMod.KFFemaleZombieSounds'
    IdleHeavyAnim="Siren_Idle"
    IdleRifleAnim="Siren_Idle"
    MeleeRange=45.000000
    GroundSpeed=100.0//100.000000
    WaterSpeed=80.000000
    Health=300//350
    HealthMax=300
    PlayerCountHealthScale=0.10
    PlayerNumHeadHealthScale=0.05
	HeadHealth=200
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

    AmbientGlow=0
    CollisionRadius=26.000000
    RotationRate=(Yaw=45000,Roll=0)

    // these could need to be moved into children if children change them
    ChallengeSound(0)=Sound'KF_EnemiesFinalSnd.Siren_Challenge'
    ChallengeSound(1)=Sound'KF_EnemiesFinalSnd.Siren_Challenge'
    ChallengeSound(2)=Sound'KF_EnemiesFinalSnd.Siren_Challenge'
    ChallengeSound(3)=Sound'KF_EnemiesFinalSnd.Siren_Challenge'

    MenuName="Siren"

    bCanDistanceAttackDoors=True
    ZombieFlag=1

    ShakeEffectScalar=1.0
    ShakeTime=2.0
    ShakeFadeTime=0.25
    MinShakeEffectScale=0.6
    ScreamBlurScale=0.85

	SeveredHeadAttachScale=1.0
	SeveredLegAttachScale=0.7
	SeveredArmAttachScale=1.0
	HeadHeight=1.0
	HeadScale=1.0
	CrispUpThreshhold=7
	OnlineHeadshotOffset=(X=6,Y=0,Z=41)
	OnlineHeadshotScale=1.2
	MotionDetectorThreat=2.0
	ZapThreshold=0.5
	ZappedDamageMod=1.5
}
