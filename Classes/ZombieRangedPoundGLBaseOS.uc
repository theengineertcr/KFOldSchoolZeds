//=============================================================================
// Explosives Gunner Pound! Basically the Ogre from Quake, without the Chainsaw(yet!)
//=============================================================================

//=============================================================================
// Killing Floor Source
// Copyright (C) 2009 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class ZombieRangedPoundGLBaseOS extends KFMonsterOS
    abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax


var bool bFireAtWill,bGLing;
var float LastGLTime;         //Basically Husk's NextFireProjectileTime
var vector TraceHitPos;
var Emitter mTracer,mMuzzleFlash;


var int GLFireCounter;


//Retail variable
var bool bClientGLing;


var()            float    GLFireRate;            // New variable, lower means faster, higher means slower
var()             int     GLFireBurst;         //New variable, determines how many bullets will be fired per burst

//We need this from the Husk
var()   float   GLFireInterval;//ProjectileFireInterval; // How often to fire the fire projectile

replication
{
    reliable if( Role==ROLE_Authority )
        TraceHitPos,bGLing;
}

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
    //These values were not set in KFMod
    //DrawScale=1.4
    ZombieFlag=1
    //AmmunitionClass=class'KFMod.BZombieAmmo'
    //SoundRadius=2.5
    //AmbientSoundScaling=8.0
    //SoundVolume=200
    //SeveredHeadAttachScale=0.9
    //SeveredLegAttachScale=0.9
    //SeveredArmAttachScale=0.9
    //AmbientGlow=0

    //Values that don't need to be changed
    bFatAss=true
    Mass=400.000000
    RotationRate=(Yaw=45000,Roll=0)
    bUseExtendedCollision=true

    //Skins set in event class ZombieRangedPound_OS
    //Skins(1)=Shader'KF_Specimens_Trip_T_Two.burns.burns_shdr'

    //We'll keep these values the same as the retail version
    //As this mod was made purely for the visual aspect, not gameplay
    ScoringValue=125
    GroundSpeed=75.0
    WaterSpeed=75.000000
    Health=1250//700
    HealthMax=1250//700
    PlayerCountHealthScale=0.10//0.15
    PlayerNumHeadHealthScale=0.05
    HeadHealth=655//250
    MeleeDamage=15
    JumpZ=320.000000
    bHarpoonToHeadStuns=true
    bHarpoonToBodyStuns=false
    BleedOutDuration=6.0
    MeleeRange=30.0//55.000000
    damageForce=70000
    Intelligence=BRAINS_Mammal
    MotionDetectorThreat=2.0
    ZapThreshold=1.25
    ZappedDamageMod=1.25
    GLFireInterval=5.5
    GLFireRate=0.75
    GLFireBurst=2

    AmmunitionClass=class'KFMod.BZombieAmmo'
    bCannibal = false // No animation for him.
    MenuName="Flesh Pound Explosives Gunner"

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
    bCanDistanceAttackDoors=false

    //These might need to be changed
    ColOffset=(Z=65)//(Z=50)
    ColRadius=27
    ColHeight=25//40
    PrePivot=(Z=0)

    SoloHeadScale=1.55

    //Updated
    OnlineHeadshotOffset=(X=30,Y=7,Z=68)
    OnlineHeadshotScale=1.75//1.3
}