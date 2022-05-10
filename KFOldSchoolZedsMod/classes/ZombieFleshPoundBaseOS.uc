// Zombie Monster for KF Invasion gametype
class ZombieFleshpoundBase extends KFMonster
    abstract;

#exec OBJ LOAD FILE=PlayerSounds.uax

var () float BlockDamageReduction;
var bool bChargingPlayer,bClientCharge;
var int TwoSecondDamageTotal;
var float LastDamagedTime,RageEndTime;

var() vector RotMag;						// how far to rot view
var() vector RotRate;				// how fast to rot view
var() float	RotTime;				// how much time to rot the instigator's view
var() vector OffsetMag;			// max view offset vertically
var() vector OffsetRate;				// how fast to offset view vertically
var() float	OffsetTime;				// how much time to offset view

var name ChargingAnim;		// How he runs when charging the player.

//var ONSHeadlightCorona DeviceGlow; //KFTODO: Don't think this is needed, its not reffed anywhere

var () int RageDamageThreshold;  // configurable.

var FleshPoundAvoidArea AvoidArea;  // Make the other AI fear this AI

var bool    bFrustrated;        // The fleshpound is tired of being kited and is pissed and ready to attack

replication
{
	reliable if(Role == ROLE_Authority)
		bChargingPlayer, bFrustrated;
}

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
	bMeleeStunImmune = true

	BlockDamageReduction=0.400000

	MeleeAnims(0)="PoundAttack1"
	MeleeAnims(1)="PoundAttack2"
	MeleeAnims(2)="PoundAttack3"

	damageForce=15000
	bFatAss=True
	KFRagdollName="FleshPound_Trip"

	ScoringValue=200
	IdleHeavyAnim="PoundIdle"
	IdleRifleAnim="PoundIdle"
	RagDeathVel=100.000000
	RagDeathUpKick=100.000000
	MeleeRange=55.000000

	MovementAnims(0)="PoundWalk"
	MovementAnims(1)="WalkB"
	MovementAnims(2)="RunL"
	MovementAnims(3)="RunR"
	WalkAnims(0)="PoundWalk"
	WalkAnims(1)="WalkB"
	WalkAnims(2)="RunL"
	WalkAnims(3)="RunR"
	IdleCrouchAnim="PoundIdle"
	IdleWeaponAnim="PoundIdle"
	IdleRestAnim="PoundIdle"
	ChargingAnim = "PoundRun"

	AmbientGlow=0
	Mass=600.000000
	RotationRate=(Yaw=45000,Roll=0)

	RotMag=(X=500.000000,Y=500.000000,Z=600.000000)
	RotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
	RotTime=6.000000
	OffsetMag=(X=5.000000,Y=10.000000,Z=5.000000)
	OffsetRate=(X=300.000000,Y=300.000000,Z=300.000000)
	OffsetTime=3.500000


	GroundSpeed=130.000000
	WaterSpeed=120.000000
	MeleeDamage=35
	//StunTime=0.3 //Was used in Balance Round 1(removed for Round 2)
	StunsRemaining=1 //Added in Balance Round 2

	Health=1500//2000
	HealthMax=1500
	PlayerCountHealthScale=0.25
	PlayerNumHeadHealthScale=0.30 // Was 0.35 in Balance Round 1
	HeadHealth=700

	SpinDamConst=20.000000
	SpinDamRand=20.000000
	bBoss=True
	MenuName="Flesh Pound"

	CollisionRadius=26
	CollisionHeight=44

	Skins(1)=Shader'KFCharacters.FPAmberBloomShader'

	RageDamageThreshold = 360

	Intelligence=BRAINS_Mammal // Changed in Balance Round 1
	bUseExtendedCollision=True
	ColOffset=(Z=52)
	ColRadius=36
	ColHeight=35//46
	PrePivot=(Z=0)
	ZombieFlag=3

	SeveredHeadAttachScale=1.5
	SeveredLegAttachScale=1.2
	SeveredArmAttachScale=1.3

	BleedOutDuration=7.0
	HeadHeight=2.5
	HeadScale=1.3
	OnlineHeadshotOffset=(X=22,Y=0,Z=68)
	OnlineHeadshotScale=1.3
	MotionDetectorThreat=5.0
	ZapThreshold=1.75
	ZappedDamageMod=1.25
	DamageToMonsterScale=5.0
	bHarpoonToHeadStuns=true
	bHarpoonToBodyStuns=false
}
