// Zombie Monster for KF Invasion gametype
class ZombieClotBase extends KFMonster
    abstract;

#exec OBJ LOAD FILE=PlayerSounds.uax
#exec OBJ LOAD FILE=KF_Freaks_Trip.ukx
#exec OBJ LOAD FILE=KF_Specimens_Trip_T.utx

var     KFPawn  DisabledPawn;           // The pawn that has been disabled by this zombie's grapple
var     bool    bGrappling;             // This zombie is grappling someone
var     float   GrappleEndTime;         // When the current grapple should be over
var()   float   GrappleDuration;        // How long a grapple by this zombie should last

var	float	ClotGrabMessageDelay;	// Amount of time between a player saying "I've been grabbed" message

replication
{
	reliable if(bNetDirty && Role == ROLE_Authority)
		bGrappling;
}

function BreakGrapple()
{
	if( DisabledPawn != none )
	{
	     DisabledPawn.bMovementDisabled = false;
	     DisabledPawn = none;
	}
}

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
    DrawScale=1.1
    Prepivot=(Z=5.0)

    bUseExtendedCollision=true
	ColOffset=(Z=48)
	ColRadius=25
	ColHeight=5

    ExtCollAttachBoneName="Collision_Attach"

    BurningWalkFAnims(0)="WalkF_Fire"
    BurningWalkFAnims(1)="WalkF_Fire"
    BurningWalkFAnims(2)="WalkF_Fire"

    MeleeAnims(0)="ClotGrapple"
    MeleeAnims(1)="ClotGrappleTwo"
    MeleeAnims(2)="ClotGrappleThree"

    damageForce=5000
    KFRagdollName="Clot_Trip"

    ScoringValue=7

    MovementAnims(0)="ClotWalk"
    WalkAnims(0)="ClotWalk"
    WalkAnims(1)="ClotWalk"
    WalkAnims(2)="ClotWalk"
    WalkAnims(3)="ClotWalk"
    SoundRadius=80
    SoundVolume=50

    CollisionRadius=26.000000
    RotationRate=(Yaw=45000,Roll=0)

    GroundSpeed=105.000000
    WaterSpeed=105.000000
    MeleeDamage=6
    Health=130//200
    HealthMax=130//200
    JumpZ=340.000000

    MeleeRange=20.0//30.000000

    PuntAnim="ClotPunt"

    bCannibal = true
    MenuName="Clot"

    AdditionalWalkAnims(0) = "ClotWalk2"

    Intelligence=BRAINS_Mammal
    GrappleDuration=1.5

	SeveredHeadAttachScale=0.8
	SeveredLegAttachScale=0.8
	SeveredArmAttachScale=0.8

	ClotGrabMessageDelay=12.0
	HeadHeight=2.0
	HeadScale=1.1
	CrispUpThreshhold=9
	OnlineHeadshotOffset=(X=20,Y=0,Z=37)
	OnlineHeadshotScale=1.3
	MotionDetectorThreat=0.34
}
