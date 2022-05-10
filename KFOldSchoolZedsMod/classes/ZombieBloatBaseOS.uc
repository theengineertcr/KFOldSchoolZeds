// Zombie Monster for KF Invasion gametype
class ZombieBloatBase extends KFMonster
    abstract;

#exec OBJ LOAD FILE=PlayerSounds.uax
#exec OBJ LOAD FILE=KF_EnemiesFinalSnd.uax

var BileJet BloatJet;
var bool bPlayBileSplash;
var bool bMovingPukeAttack;
var float RunAttackTimeout;

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
    DrawScale=1.075
    Prepivot=(Z=5.0)

    MeleeAnims(0)="BloatChop2"
    MeleeAnims(1)="BloatChop2"
    MeleeAnims(2)="BloatChop2"
    damageForce=70000
    bFatAss=True
    KFRagdollName="Bloat_Trip"
    PuntAnim="BloatPunt"

    AmmunitionClass=Class'KFMod.BZombieAmmo'
    ScoringValue=17
    IdleHeavyAnim="BloatIdle"
    IdleRifleAnim="BloatIdle"
    MeleeRange=30.0//55.000000

    MovementAnims(0)="WalkBloat"
    MovementAnims(1)="WalkBloat"
    WalkAnims(0)="WalkBloat"
    WalkAnims(1)="WalkBloat"
    WalkAnims(2)="WalkBloat"
    WalkAnims(3)="WalkBloat"
    IdleCrouchAnim="BloatIdle"
    IdleWeaponAnim="BloatIdle"
    IdleRestAnim="BloatIdle"
    //SoundRadius=2.5
    AmbientSoundScaling=8.0
    SoundVolume=200
    AmbientGlow=0

    Mass=400.000000
    RotationRate=(Yaw=45000,Roll=0)

    GroundSpeed=75.0//105.000000
    WaterSpeed=102.000000
    Health=525//800
    HealthMax=525
    PlayerCountHealthScale=0.25
    PlayerNumHeadHealthScale=0.0
	HeadHealth=25
    MeleeDamage=14
    JumpZ=320.000000

    bCannibal = False // No animation for him.
    MenuName="Bloat"

    CollisionRadius=26.000000
    CollisionHeight=44
    bCanDistanceAttackDoors=True
    Intelligence=BRAINS_Stupid
    bUseExtendedCollision=True
    ColOffset=(Z=60)//(Z=42)
    ColRadius=27
    ColHeight=22//40
    ZombieFlag=1

	SeveredHeadAttachScale=1.7
	SeveredLegAttachScale=1.3
	SeveredArmAttachScale=1.1

	BleedOutDuration=6.0
	HeadHeight=2.5
	HeadScale=1.5
	OnlineHeadshotOffset=(X=5,Y=0,Z=70)
	OnlineHeadshotScale=1.5
	MotionDetectorThreat=1.0

	ZapThreshold=0.5
	ZappedDamageMod=1.5
	bHarpoonToHeadStuns=true
	bHarpoonToBodyStuns=false
}
