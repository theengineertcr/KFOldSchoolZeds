//Because we want the zeds to extend to KFMonsterOS, there's no choice
//Other than to overhaul all 3 files of each zed, controllers as well if
//We count certain other Zeds

// Zombie Monster for KF Invasion gametype
class ZombieBossBaseOS extends KFMonsterOS
    abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFBossOld.ukx
#exec OBJ LOAD FILE=KFPatch2.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax

//bIsBossView introduced in retail
var bool bChargingPlayer,bClientCharg,bFireAtWill,bMinigunning,bIsBossView;
var float RageStartTime,LastChainGunTime,LastMissileTime,LastSneakedTime;

//Retail variable
var bool bClientMiniGunning;

var name ChargingAnim;		// How he runs when charging the player.
var byte SyringeCount,ClientSyrCount;

//MGFireCounter in KFMod was a byte, but this is fine too
var int MGFireCounter;

var vector TraceHitPos;
var Emitter mTracer,mMuzzleFlash;
var bool bClientCloaked;
var float LastCheckTimes;
var int HealingLevels[3],HealingAmount;

//This variable was in KFMod, but in the ZombieBossOS Class
//var BossHPNeedle CurrentNeedle;

//Modern variables we dont need
//var(Sounds)     sound   RocketFireSound;    // The sound of the rocket being fired
//var(Sounds)     sound   MiniGunFireSound;   // The sound of the minigun being fired
//var(Sounds)     sound   MiniGunSpinSound;   // The sound of the minigun spinning
//var(Sounds)     sound   MeleeImpaleHitSound;// The sound of melee impale attack hitting the player

//Retail variables we'll keep for balance
var             float   MGFireDuration;     // How long to fire for this burst
var             float   MGLostSightTimeout; // When to stop firing because we lost sight of the target
var()           float   MGDamage;           // How much damage the MG will do

//Modern variables were keeping for balance
var()           float   ClawMeleeDamageRange;// How long his arms melee strike is
var()           float   ImpaleMeleeDamageRange;// How long his spike melee strike is

//Retail variables we'll keep for balance
var             float   LastChargeTime;     // Last time the patriarch charged
var             float   LastForceChargeTime;// Last time patriarch was forced to charge
var             int     NumChargeAttacks;   // Number of attacks this charge
var             float   ChargeDamage;       // How much damage he's taken since the last charge
var             float   LastDamageTime;     // Last Time we took damage

//Retail variables we'll keep for balance
// Sneaking
var             float   SneakStartTime;     // When did we start sneaking
var             int     SneakCount;         // Keep track of the loop that sends the boss to initial hunting state

// PipeBomb damage
var()           float   PipeBombDamageScale;// Scale the pipe bomb damage over time

replication
{
	reliable if( Role==ROLE_Authority )
		bChargingPlayer,SyringeCount,TraceHitPos,bMinigunning,bIsBossView;
}

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
	//These values were not set in KFMod
	//DrawScale=1.05
	//bOnlyDamagedByCrossbow=true
    //SeveredHeadAttachScale=1.5
	//SeveredLegAttachScale=1.2
	//SeveredArmAttachScale=1.1
	//AmbientGlow=0
    //SoundVolume=75
	//bForceSkelUpdate=true
	
	//Values that don't need to be changed
    bMeleeStunImmune = true
	bFatAss=True
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
	bBoss=True
	bCanDistanceAttackDoors=True
	bNetNotify=False
	bUseExtendedCollision=True
	DamageToMonsterScale=5.0
	
	//We'll keep these values the same as the retail version
	//As this mod was made purely for the visual aspect, not gameplay
	ScoringValue=500
	GroundSpeed=120.000000
	WaterSpeed=120.000000
	MeleeDamage=75
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
	ZapResistanceScale=1.0 // don't let the patriarch gain resistance, since his zapp effects are pretty light
	bHarpoonToHeadStuns=false
	bHarpoonToBodyStuns=false
	ClawMeleeDamageRange=85//50
	ImpaleMeleeDamageRange=45//75
	
    TurnLeftAnim="BossHitF"//"TurnLeft"
    TurnRightAnim="BossHitF"//"TurnRight"
	MenuName="Old Patriarch"//"Patriarch"
	
	//This may need to be changed
	ColOffset=(Z=65)//(Z=50)
	ColRadius=27
	ColHeight=25//40
	PrePivot=(Z=3)

	//We'll keep this just incase
	ZombieFlag=3

	KFRagdollName="BossRag"//"Patriarch_Trip" Use KFMod ragdoll
	
	CollisionRadius=26
	CollisionHeight=44
	HeadHeight=2.0
	HeadScale=1.3
	OnlineHeadshotOffset=(X=28,Y=0,Z=75)
	OnlineHeadshotScale=1.2	
}
