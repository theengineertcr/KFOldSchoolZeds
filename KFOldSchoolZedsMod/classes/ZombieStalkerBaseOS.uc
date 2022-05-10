// Zombie Monster for KF Invasion gametype
class ZombieStalkerBase extends KFMonster
    abstract;

#exec OBJ LOAD FILE=PlayerSounds.uax
#exec OBJ LOAD FILE=KFX.utx
#exec OBJ LOAD FILE=KF_BaseStalker.uax

var float NextCheckTime;
var KFHumanPawn LocalKFHumanPawn;
var float LastUncloakTime;

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
    DrawScale=1.1
    Prepivot=(Z=5.0)

    MeleeAnims(0)="StalkerSpinAttack"
    MeleeAnims(1)="StalkerAttack1"
    MeleeAnims(2)="JumpAttack"
    MeleeDamage=9
    damageForce=5000
    ZombieDamType(0)=Class'KFMod.DamTypeSlashingAttack'
    ZombieDamType(1)=Class'KFMod.DamTypeSlashingAttack'
    ZombieDamType(2)=Class'KFMod.DamTypeSlashingAttack'

    ScoringValue=15
    SoundGroupClass=Class'KFMod.KFFemaleZombieSounds'
    IdleHeavyAnim="StalkerIdle"
    IdleRifleAnim="StalkerIdle"
    GroundSpeed=200.000000
    WaterSpeed=180.000000
    JumpZ=350.000000
    Health=100 // 120
    HealthMax=100 // 120
    MovementAnims(0)="ZombieRun"
    MovementAnims(1)="ZombieRun"
    MovementAnims(2)="ZombieRun"
    MovementAnims(3)="ZombieRun"
    WalkAnims(0)="ZombieRun"
    WalkAnims(1)="ZombieRun"
    WalkAnims(2)="ZombieRun"
    WalkAnims(3)="ZombieRun"
    IdleCrouchAnim="StalkerIdle"
    IdleWeaponAnim="StalkerIdle"
    IdleRestAnim="StalkerIdle"

    AmbientGlow=0
    CollisionRadius=26.000000
    RotationRate=(Yaw=45000,Roll=0)

    PuntAnim="ClotPunt"

    bCannibal=false
    MenuName="Stalker"
    KFRagdollName="Stalker_Trip"

	SeveredHeadAttachScale=1.0
	SeveredLegAttachScale=0.7
	SeveredArmAttachScale=0.8


	MeleeRange=30.000000
	HeadHeight=2.5
	HeadScale=1.1
	CrispUpThreshhold=10
	OnlineHeadshotOffset=(X=18,Y=0,Z=33)
	OnlineHeadshotScale=1.2
	MotionDetectorThreat=0.25
}
