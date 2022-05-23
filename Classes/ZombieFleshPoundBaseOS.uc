//Because we want the zeds to extend to KFMonsterOS, there's no choice
//Other than to overhaul all 3 files of each zed, controllers as well if
//We count certain other Zeds

// Zombie Monster for KF Invasion gametype
class ZombieFleshpoundBaseOS extends KFMonsterOS
    abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

//KFMod and Retail dont make use of the blocking animation so we dont this variable
//var () float BlockDamageReduction;
var bool bChargingPlayer,bClientCharge;
var int TwoSecondDamageTotal;
var float LastDamagedTime,RageEndTime; //RageStartTime from KFMod became RageEndTime for some reason

var() vector RotMag;                        // how far to rot view
var() vector RotRate;                // how fast to rot view
var() float    RotTime;                // how much time to rot the instigator's view
var() vector OffsetMag;            // max view offset vertically
var() vector OffsetRate;                // how fast to offset view vertically
var() float    OffsetTime;                // how much time to offset view

var name ChargingAnim;        // How he runs when charging the player.

//var ONSHeadlightCorona DeviceGlow; //KFTODO: Don't think this is needed, its not reffed anywhere

var () int RageDamageThreshold;  // configurable.

//We want to keep this retail behaviour
var FleshPoundAvoidArea AvoidArea;  // Make the other AI fear this AI

//Ditto
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
    //These values were not set in KFMod
    //AmbientGlow=0
    //StunTime=0.3 //Was used in Balance Round 1(removed for Round 2)
    //StunsRemaining=1 //Added in Balance Round 2
    ZombieFlag=3
    //SeveredHeadAttachScale=1.5
    //SeveredLegAttachScale=1.2
    //SeveredArmAttachScale=1.3

    //Values that don't need to be changed
    bMeleeStunImmune = true
    bFatAss=True
    Mass=600.000000
    MeleeAnims(0)="PoundAttack1"
    MeleeAnims(1)="PoundAttack2"
    MeleeAnims(2)="PoundAttack1" //PoundAttack3 Causes issues, removed.
    IdleHeavyAnim="PoundIdle"
    IdleRifleAnim="PoundIdle"
    IdleCrouchAnim="PoundIdle"
    IdleWeaponAnim="PoundIdle"
    IdleRestAnim="PoundIdle"
    ChargingAnim = "PoundRun"
    RotationRate=(Yaw=45000,Roll=0)
    RagDeathVel=100.000000
    RagDeathUpKick=100.000000
    bBoss=True
    DamageToMonsterScale=5.0

    //We'll keep these values the same as the retail version
    //As this mod was made purely for the visual aspect, not gameplay
    ScoringValue=200
    RotMag=(X=500.000000,Y=500.000000,Z=600.000000)
    RotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
    RotTime=6.000000
    OffsetMag=(X=5.000000,Y=10.000000,Z=5.000000)
    OffsetRate=(X=300.000000,Y=300.000000,Z=300.000000)
    OffsetTime=3.500000
    MeleeRange=55.000000
    damageForce=15000//Old Fleshy had an extra 0 at the end...tempted to add that back for fun.
    GroundSpeed=130.000000
    WaterSpeed=120.000000
    MeleeDamage=35
    SpinDamConst=5.000000
    SpinDamRand=4.000000
    Health=1500//2000
    HealthMax=1500
    PlayerCountHealthScale=0.25
    PlayerNumHeadHealthScale=0.30 // Was 0.35 in Balance Round 1
    HeadHealth=700
    RageDamageThreshold = 360
    Intelligence=BRAINS_Mammal // Changed in Balance Round 1
    BleedOutDuration=7.0
    MotionDetectorThreat=5.0
    ZapThreshold=1.75
    ZappedDamageMod=1.25
    bHarpoonToHeadStuns=true
    bHarpoonToBodyStuns=false

    //All of these need to be PoundWalk
    MovementAnims(0)="PoundWalk"
    MovementAnims(1)="PoundWalk"//"WalkB"
    MovementAnims(2)="PoundWalk"//"RunL"
    MovementAnims(3)="PoundWalk"//"RunR"
    WalkAnims(0)="PoundWalk"
    WalkAnims(1)="PoundWalk"//"WalkB"
    WalkAnims(2)="PoundWalk"//"RunL"
    WalkAnims(3)="PoundWalk"//"RunR"

    KFRagdollName="FleshPoundRag"//"FleshPound_Trip" use KFMod ragdoll

    //Not needed anymore
    //BlockDamageReduction=0.400000

    MenuName="Flesh Pound 2.5"//"Flesh Pound"

    //Skins set in event class ZombieFleshpound_OS
    //Skins(1)=Shader'KFCharacters.FPAmberBloomShader'

    //These might need to be changed
    bUseExtendedCollision=True
    ColOffset=(Z=52.000000)
    ColRadius=36.000000
    ColHeight=35.000000
    PrePivot=(Z=0) //Y-15?

    //Headshot doesn't work properly with Projectile weapons and I don't want to scale this up
    //TODO:Do a quick patch, then investigate this further
    SoloHeadScale=1.4

    //Updated
    OnlineHeadshotOffset=(X=32,Y=-6,Z=68) // Z=50 when charging
    OnlineHeadshotScale=1.5
}