// Chainsaw Zombie Monster for KF Invasion gametype
// He's not quite as speedy as the other Zombies, But his attacks are TRULY damaging.
class ZombieScrakeBase extends KFMonster
    abstract;

#exec OBJ LOAD FILE=PlayerSounds.uax

var(Sounds) sound   SawAttackLoopSound; // THe sound for the saw revved up, looping
var(Sounds) sound   ChainSawOffSound;   //The sound of this zombie dieing without a head

var         bool    bCharging;          // Scrake charges when his health gets low
var()       float   AttackChargeRate;   // Ratio to increase scrake movement speed when charging and attacking

// Exhaust effects
var()	class<VehicleExhaustEffect>	ExhaustEffectClass; // Effect class for the exhaust emitter
var()	VehicleExhaustEffect 		ExhaustEffect;
var 		bool	bNoExhaustRespawn;

replication
{
	reliable if(Role == ROLE_Authority)
		bCharging;
}

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
    DrawScale=1.05
    Prepivot=(Z=3.0)

    bMeleeStunImmune = true

    MeleeAnims(0)="SawZombieAttack1"
    MeleeAnims(1)="SawZombieAttack2"
    MeleeDamage=20
    damageForce=-75000//-400000
    KFRagdollName="Scrake_Trip"

    ScoringValue=75
    IdleHeavyAnim="SawZombieIdle"
    IdleRifleAnim="SawZombieIdle"
    MeleeRange=40.0//60.000000
    GroundSpeed=85.000000
    WaterSpeed=75.000000
	//StunTime=0.3 Was used in Balance Round 1(removed for Round 2)
	StunsRemaining=1 //Added in Balance Round 2
    Health=1000//1500
    HealthMax=1000
    PlayerCountHealthScale=0.5
	PlayerNumHeadHealthScale=0.30 // Was 0.35 in Balance Round 1
	HeadHealth=650
    MovementAnims(0)="SawZombieWalk"
    MovementAnims(1)="SawZombieWalk"
    MovementAnims(2)="SawZombieWalk"
    MovementAnims(3)="SawZombieWalk"
    WalkAnims(0)="SawZombieWalk"
    WalkAnims(1)="SawZombieWalk"
    WalkAnims(2)="SawZombieWalk"
    WalkAnims(3)="SawZombieWalk"
    IdleCrouchAnim="SawZombieIdle"
    IdleWeaponAnim="SawZombieIdle"
    IdleRestAnim="SawZombieIdle"


    AmbientGlow=0
    bFatAss=True
    Mass=500.000000
    RotationRate=(Yaw=45000,Roll=0)

    bCannibal = false
    MenuName="Scrake"

    CollisionRadius=26
    CollisionHeight=44

    SoundVolume=175
    SoundRadius=100.0


    Intelligence=BRAINS_Mammal
    bUseExtendedCollision=True
    ColOffset=(Z=55)
    ColRadius=29
    ColHeight=18
    ZombieFlag=3

	SeveredHeadAttachScale=1.0
	SeveredLegAttachScale=1.1
	SeveredArmAttachScale=1.1
	BleedOutDuration=6.0
	PoundRageBumpDamScale=0.01
	HeadHeight=2.2
	HeadScale=1.1
	AttackChargeRate=2.5

	ExhaustEffectClass=class'KFMOD.ChainSawExhaust'
	OnlineHeadshotOffset=(X=22,Y=5,Z=58)
	OnlineHeadshotScale=1.5
	MotionDetectorThreat=3.0
	ZapThreshold=1.25
	ZappedDamageMod=1.25

	DamageToMonsterScale=8.0
	bHarpoonToHeadStuns=true
	bHarpoonToBodyStuns=false
}
