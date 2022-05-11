//Because we want the zeds to extend to KFMonsterOS, there's no choice
//Other than to overhaul all 3 files of each zed, controllers as well if
//We count certain other Zeds

// Zombie Monster for KF Invasion gametype
class ZombieBloatBaseOS extends KFMonsterOS
    abstract;

//Use KFMod versions of these files
var BileJetOS BloatJet;
var bool bPlayBileSplash;

//We cant make the Bloat move and attack, he's too damn fat for that
//Also, because old zeds dont handle upper and lower body parts separately,
//a.k.a All animations are "full" animations, controlling every bone
//var bool bMovingPukeAttack;
//var float RunAttackTimeout;

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

//This new variable controls how close the Bloat has to be before he can puke
//Higher means closer, lower means farther
var float DistBeforePuke;

defaultproperties
{
	//These values were not set in KFMod 
    //DrawScale=1.075
    //SoundRadius=2.5
    //AmbientSoundScaling=8.0
    //SoundVolume=200
    //AmbientGlow=0
	//CollisionRadius=26.000000
    //ZombieFlag=1
	//SeveredHeadAttachScale=1.7
	//SeveredLegAttachScale=1.3
	//SeveredArmAttachScale=1.1
	
	//Values that don't need to be changed
    MeleeAnims(0)="BloatChop2"
    MeleeAnims(1)="BloatChop2"
    MeleeAnims(2)="BloatChop2"
    damageForce=70000
    bFatAss=True
    PuntAnim="BloatPunt"
    AmmunitionClass=Class'KFMod.BZombieAmmo'
    IdleHeavyAnim="BloatIdle"
    IdleRifleAnim="BloatIdle"
    MovementAnims(0)="WalkBloat"
    MovementAnims(1)="WalkBloat"
    WalkAnims(0)="WalkBloat"
    WalkAnims(1)="WalkBloat"
    WalkAnims(2)="WalkBloat"
    WalkAnims(3)="WalkBloat"
    IdleCrouchAnim="BloatIdle"
    IdleWeaponAnim="BloatIdle"
    IdleRestAnim="BloatIdle"
    Mass=400.000000
    RotationRate=(Yaw=45000,Roll=0)	
    bCanDistanceAttackDoors=True
	bUseExtendedCollision=True
    ColRadius=27
	Intelligence=BRAINS_Stupid	
	
	//We'll keep these values the same as the retail version
	//As this mod was made purely for the visual aspect, not gameplay
	//This is an exception for the Bloat as he no longer can move
	//While puking, so were going to increase his puke attack's range
	DistBeforePuke=250//250
    ScoringValue=17
    MeleeRange=30.0//55.000000
    GroundSpeed=75.0//105.000000
    WaterSpeed=102.000000
    Health=525//800
    HealthMax=525
    PlayerCountHealthScale=0.25
    PlayerNumHeadHealthScale=0.0
	HeadHealth=25
    MeleeDamage=14
    JumpZ=320.000000	
	BleedOutDuration=6.0	
	MotionDetectorThreat=1.0
	ZapThreshold=0.5
	ZappedDamageMod=1.5
	bHarpoonToHeadStuns=true
	bHarpoonToBodyStuns=false
	
	//Use old ragdoll
    KFRagdollName="BloatRag"
	
	//Looks like Shreks a little hungry
    bCannibal=True
	
    MenuName="Bloat 2.5"

	Prepivot=(Z=8.000000) //(Z=5.0)

	//Tweak these, we dont want a floating fatty!
	CollisionHeight=44.000000//previously  44
    ColOffset=(Z=60)//(Z=60)
    ColHeight=22//22

	HeadHeight=2.5//2.5
	HeadScale=1.5	
	
	OnlineHeadshotOffset=(X=5,Y=0,Z=70)
	OnlineHeadshotScale=1.5		
}
