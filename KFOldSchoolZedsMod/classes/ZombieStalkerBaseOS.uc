// Zombie Monster for KF Invasion gametype
class ZombieStalkerBaseOS extends KFMonsterOS
    abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

//bCloaking was removed for some reason, we brought it back
var bool bCloaking;

//LastCheckTime became NextCheckTime in Retail for some reason
var float NextCheckTime;

//Not in old KFMod
//var KFHumanPawn LocalKFHumanPawn;
//var float LastUncloakTime;

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
	//These values were not set in KFMod	
    //DrawScale=1.1
    //Prepivot=(Z=5.0)
	//SeveredHeadAttachScale=1.0
	//SeveredLegAttachScale=0.7
	//SeveredArmAttachScale=0.8
    //AmbientGlow=0
    //KFRagdollName="Stalker_Trip"
	
	//Values that don't need to be changed
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
    IdleHeavyAnim="StalkerIdle"
    IdleRifleAnim="StalkerIdle"	
	CrispUpThreshhold=10
    RotationRate=(Yaw=45000,Roll=0)
    PuntAnim="ClotPunt"	
    MeleeAnims(0)="StalkerSpinAttack"
    MeleeAnims(1)="StalkerAttack1"
    MeleeAnims(2)="JumpAttack"
    ZombieDamType(0)=Class'KFMod.DamTypeSlashingAttack'
    ZombieDamType(1)=Class'KFMod.DamTypeSlashingAttack'
    ZombieDamType(2)=Class'KFMod.DamTypeSlashingAttack'

	//We'll keep these values the same as the retail version
	//As this mod was made purely for the visual aspect, not gameplay
	MeleeRange=30.000000	
    MeleeDamage=9
    damageForce=5000	
    ScoringValue=15
    GroundSpeed=200.000000
    WaterSpeed=180.000000
    JumpZ=350.000000
    Health=100 // 120
    HealthMax=100 // 120
	MotionDetectorThreat=0.25

	//She was a cannibal in KFMod, so keep feasting on their corpses, please.
    bCannibal=True
    MenuName="Old Stalker"//"Stalker"
	//Have yet to make this, will do it later
    //SoundGroupClass=Class'KFMod.KFFemaleZombieSounds'
	
    CollisionRadius=26.000000
	HeadHeight=2.0//2.5
	HeadScale=1.3//1.1
	OnlineHeadshotOffset=(X=18,Y=0,Z=33)
	OnlineHeadshotScale=1.4//1.2	
}
