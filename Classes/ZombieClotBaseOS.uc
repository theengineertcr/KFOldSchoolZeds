//Because we want the zeds to extend to KFMonsterOS, there's no choice
//Other than to overhaul all 3 files of each zed, controllers as well if
//We count certain other Zeds

// Zombie Monster for KF Invasion gametype
class ZombieClotBaseOS extends KFMonsterOS
    abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

var     KFPawn  DisabledPawn;           // The pawn that has been disabled by this zombie's grapple
var     bool    bGrappling;             // This zombie is grappling someone
var     float   GrappleEndTime;         // When the current grapple should be over
var()   float   GrappleDuration;        // How long a grapple by this zombie should last

var    float    ClotGrabMessageDelay;    // Amount of time between a player saying "I've been grabbed" message

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
    //These values were not set in KFMod
    //DrawScale=1.1
    //ExtCollAttachBoneName="Collision_Attach"
    //BurningWalkFAnims(0)="WalkF_Fire"
    //BurningWalkFAnims(1)="WalkF_Fire"
    //BurningWalkFAnims(2)="WalkF_Fire"
    //SoundRadius=80
    //SoundVolume=50
    //SeveredHeadAttachScale=0.8
    //SeveredLegAttachScale=0.8
    //SeveredArmAttachScale=0.8

    //Values that don't need to be changed
    damageForce=5000
    MovementAnims(0)="ClotWalk"
    WalkAnims(0)="ClotWalk"
    WalkAnims(1)="ClotWalk"
    WalkAnims(2)="ClotWalk"
    WalkAnims(3)="ClotWalk"
    RotationRate=(Yaw=45000,Roll=0)
    PuntAnim="ClotPunt"
    AdditionalWalkAnims(0) = "ClotWalk2"
    bCannibal = true
    CrispUpThreshhold=9
    ClotGrabMessageDelay=12.0

    //We'll keep these values the same as the retail version
    //As this mod was made purely for the visual aspect, not gameplay
    ScoringValue=7
    MeleeDamage=6
    Health=130//200
    HealthMax=130//200
    GroundSpeed=105.000000
    WaterSpeed=105.000000
    JumpZ=340.000000
    MeleeRange=20.0//30.000000
    Intelligence=BRAINS_Mammal
    MotionDetectorThreat=0.34

    //Clots only had one grapple animation
    //Exception for Doorbashing to work properly
    MeleeAnims(0)="Claw"
    MeleeAnims(1)="Claw2"
    MeleeAnims(2)="ClotGrapple"

    //"Clot_Trip" to "ClotRag"
    KFRagdollName="ClotRag"

    MenuName="Clot 2.5"

    GrappleDuration=1.0//1.5 shortened to match with KFMod Grapple Duration    as were not going to destroy grapples upon death

    //This makes him float, we don't want that
    //Prepivot=(Z=5.0)

    bUseExtendedCollision=true
    ColOffset=(Z=48.000000)
    ColRadius=25.000000
    ColHeight=5.000000

    SoloHeadScale=1.1

    //Updated
    OnlineHeadshotOffset=(X=25,Y=-7,Z=45)
    OnlineHeadshotScale=1.2
}