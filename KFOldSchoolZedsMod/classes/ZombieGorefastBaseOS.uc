// Zombie Monster for KF Invasion gametype
// He's speedy, and swings with a Single enlongated arm, affording him slightly more range
class ZombieGoreFastBase extends KFMonster
    abstract;

#exec OBJ LOAD FILE=PlayerSounds.uax

var bool bRunning;
var float RunAttackTimeout;

replication
{
	reliable if(Role == ROLE_Authority)
		bRunning;
}

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
    DrawScale=1.2
    Prepivot=(Z=10.0)

    bUseExtendedCollision=true
	ColOffset=(Z=52)
	ColRadius=25
	ColHeight=10

    ExtCollAttachBoneName="Collision_Attach"

    MeleeAnims(0)="GoreAttack1"
    MeleeAnims(1)="GoreAttack2"
    MeleeAnims(2)="GoreAttack1"
    MeleeDamage=15
    damageForce=5000
    KFRagdollName="GoreFast_Trip"
    ScoringValue=12
    IdleHeavyAnim="GoreIdle"
    IdleRifleAnim="GoreIdle"
    MeleeRange=30.0//60.000000
    GroundSpeed=120.0//150.000000
    WaterSpeed=140.000000
    Health=250//350
    HealthMax=250
    PlayerCountHealthScale=0.15
    PlayerNumHeadHealthScale=0.0
	HeadHealth=25
    MovementAnims(0)="GoreWalk"
    WalkAnims(0)="GoreWalk"
    WalkAnims(1)="GoreWalk"
    WalkAnims(2)="GoreWalk"
    WalkAnims(3)="GoreWalk"
    IdleCrouchAnim="GoreIdle"
    IdleWeaponAnim="GoreIdle"
    IdleRestAnim="GoreIdle"
    AmbientGlow=0
    CollisionRadius=26.000000
    Mass=350.000000
    RotationRate=(Yaw=45000,Roll=0)

    bCannibal = true
    MenuName="Gorefast"

	SeveredHeadAttachScale=1.0
	SeveredLegAttachScale=0.9
	SeveredArmAttachScale=0.9
	HeadHeight=2.5
	HeadScale=1.5
	CrispUpThreshhold=8
	OnlineHeadshotOffset=(X=5,Y=0,Z=53)
	OnlineHeadshotScale=1.5
	MotionDetectorThreat=0.5
}
