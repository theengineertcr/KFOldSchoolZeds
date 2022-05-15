//=============================================================================
// Ranged Fleshpound! An alternative to the Husk, using a bloody gatling gun!
//=============================================================================
// TODO:We still want Firebugs to be a counter to the RangedPound, so we'll make him fire
// Incendiary rounds and Rangedpounds counter Firebugs by being Fire resistant.
//=============================================================================
// Killing Floor Source
// Copyright (C) 2009 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class ZombieRangedPoundBaseOS extends KFMonsterOS
    abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
    
//We don't want this guy to have a rage state or charge at player
//Since he's a Husk's replacement

//The Rangedpound is basically the Patty with the MG attack,
//So make sure to give this guy the Boss variables and functions

var bool bFireAtWill,bMinigunning;
var float LastChainGunTime;         //Basically Husk's NextFireProjectileTime
var vector TraceHitPos;
var Emitter mTracer,mMuzzleFlash;

//MGFireCounter in KFMod was a byte, but this is fine too
var int MGFireCounter;


//Retail variable
var bool bClientMiniGunning;

//Retail variables we'll keep
//var             float   MGFireDuration;     // How long to fire for this burst
var             float   MGLostSightTimeout; // When to stop firing because we lost sight of the target
var()           float   MGDamage;           // How much damage the MG will do
var()             float    MGAccuracy;            // New variable, higher means more spread and vice versa
var()            float    MGFireRate;            // New variable, lower means faster, higher means slower
var()             int     MGFireBurst;         //New variable, determines how many bullets will be fired per burst

//We want 'em to take less Fire damage since he's a Husk replacement
var()   float   BurnDamageScale;        // How much to reduce fire damage for the Husk

//We need this from the Husk
var()   float   MGFireInterval;//ProjectileFireInterval; // How often to fire the fire projectile

replication
{
    reliable if( Role==ROLE_Authority )
        TraceHitPos,bMinigunning;
}

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
    //These values were not set in KFMod
    //DrawScale=1.4
    //ZombieFlag=1
    //AmmunitionClass=Class'KFMod.BZombieAmmo'
    //SoundRadius=2.5
    //AmbientSoundScaling=8.0
    //SoundVolume=200    
    //SeveredHeadAttachScale=0.9
    //SeveredLegAttachScale=0.9
    //SeveredArmAttachScale=0.9
    //AmbientGlow=0
    
    //Values that don't need to be changed
    bFatAss=True
    Mass=400.000000
    RotationRate=(Yaw=45000,Roll=0)        
    bUseExtendedCollision=True

    //Skins set in event class ZombieRangedPound_OS
    //Skins(1)=Shader'KF_Specimens_Trip_T_Two.burns.burns_shdr'

    //We'll keep these values the same as the retail version
    //As this mod was made purely for the visual aspect, not gameplay
    ScoringValue=17    
    GroundSpeed=115.0
    WaterSpeed=102.000000
    Health=600//700
    HealthMax=600//700
    PlayerCountHealthScale=0.10//0.15
    PlayerNumHeadHealthScale=0.05
    HeadHealth=200//250
    MeleeDamage=15
    JumpZ=320.000000
    bHarpoonToHeadStuns=true
    bHarpoonToBodyStuns=false
    BleedOutDuration=6.0
    MeleeRange=30.0//55.000000
    damageForce=70000
    Intelligence=BRAINS_Mammal
    BurnDamageScale=0.25
    MotionDetectorThreat=1.0
    ZapThreshold=0.75
    MGFireInterval=5.5
    MGDamage=2.0//2.0//6.0 This was too much
    MGAccuracy=0.06 //0.06//0.08// Rebalanced
    MGFireRate=0.06//0.05 
    MGFireBurst=15//5//15//30 // We'll stick with 10 after all, we want the bursts to be a bit short and slightly damaging, it'd be a problem if they shot for too long and dealt excessive damage
    
    bCannibal = False // No animation for him.
    MenuName="Flesh Pound Chaingunner"

    //Use RangedIdle
    IdleHeavyAnim="RangedIdle"
    IdleRifleAnim="RangedIdle"    
    IdleCrouchAnim="RangedIdle"
    IdleWeaponAnim="RangedIdle"
    IdleRestAnim="RangedIdle"

    //Use WalkF Only
    MovementAnims(0)="RangedWalkF"
    MovementAnims(1)="RangedWalkF"
    MovementAnims(2)="RangedWalkF"
    MovementAnims(3)="RangedWalkF"
    WalkAnims(0)="RangedWalkF"
    WalkAnims(1)="RangedWalkF"
    WalkAnims(2)="RangedWalkF"
    WalkAnims(3)="RangedWalkF"
    BurningWalkFAnims(0)="RangedWalkF"
    BurningWalkFAnims(1)="RangedWalkF"
    BurningWalkFAnims(2)="RangedWalkF"
    BurningWalkAnims(0)="RangedWalkF"
    BurningWalkAnims(1)="RangedWalkF"
    BurningWalkAnims(2)="RangedWalkF"

    //Additional Boss anims we need
    AirAnims(0)="RangedJumpInAir"
    AirAnims(1)="RangedJumpInAir"
    AirAnims(2)="RangedJumpInAir"
    AirAnims(3)="RangedJumpInAir"
    TakeoffAnims(0)="RangedJumpTakeOff"
    TakeoffAnims(1)="RangedJumpTakeOff"
    TakeoffAnims(2)="RangedJumpTakeOff"
    TakeoffAnims(3)="RangedJumpTakeOff"
    LandAnims(0)="RangedJumpLanded"
    LandAnims(1)="RangedJumpLanded"
    LandAnims(2)="RangedJumpLanded"
    LandAnims(3)="RangedJumpLanded"
    AirStillAnim="RangedJumpInAir"
    TakeoffStillAnim="RangedJumpTakeOff"    
    TurnLeftAnim="RangedBossHitF"//"TurnLeft"
    TurnRightAnim="RangedBossHitF"//"TurnRight"
    
    KFRagdollName="FleshPoundRag"//use KFMod ragdoll
    
    //Bonk them with the Minigun!
    MeleeAnims(0)="PoundPunch2"
    MeleeAnims(1)="PoundPunch2"
    MeleeAnims(2)="PoundPunch2"
    
    //Dont attack doors with the minigun
    bCanDistanceAttackDoors=False
    
    //These might need to be changed    
    ColOffset=(Z=52) 
    ColRadius=36
    ColHeight=35//46
    PrePivot=(Z=0)

    CollisionRadius=26
    CollisionHeight=44
    HeadHeight=2.5
    HeadScale=3.5
    //Maybe increase this?
    OnlineHeadshotOffset=(X=22,Y=0,Z=68)
    //After consideration, Headscale online has been reduced
    OnlineHeadshotScale=2.4//1.3    
}
