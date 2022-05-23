//Because we want the zeds to extend to KFMonsterOS, there's no choice
//Other than to overhaul all 3 files of each zed, controllers as well if
//We count certain other Zeds

// Zombie Monster for KF Invasion gametype
// He's speedy, and swings with a Single enlongated arm, affording him slightly more range
class ZombieGoreFastBaseOS extends KFMonsterOS
    abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

var bool bRunning;

//Removed
//var float RunAttackTimeout;

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
    //These values were not set in KFMod
    //DrawScale=1.2
    //Prepivot=(Z=10.0)
    //ExtCollAttachBoneName="Collision_Attach"
    //KFRagdollName="GoreFast_Trip"
    //SeveredHeadAttachScale=1.0
    //SeveredLegAttachScale=0.9
    //SeveredArmAttachScale=0.9
    //AmbientGlow=0
    
    //Values that don't need to be changed    
    MeleeAnims(0)="GoreAttack1"
    MeleeAnims(1)="GoreAttack2"
    MeleeAnims(2)="GoreAttack1"
    MovementAnims(0)="GoreWalk"
    WalkAnims(0)="GoreWalk"
    WalkAnims(1)="GoreWalk"
    WalkAnims(2)="GoreWalk"
    WalkAnims(3)="GoreWalk"
    IdleCrouchAnim="GoreIdle"
    IdleWeaponAnim="GoreIdle"
    IdleRestAnim="GoreIdle"
    IdleHeavyAnim="GoreIdle"
    IdleRifleAnim="GoreIdle"
    Mass=350.000000
    RotationRate=(Yaw=45000,Roll=0)
    
    //We'll keep these values the same as the retail version
    //As this mod was made purely for the visual aspect, not gameplay    
    //Exception:Zed cannot charge anymore, so range has been increased.
    MeleeDamage=15
    damageForce=5000
    ScoringValue=12
    MeleeRange=45.0//30.0//60.000000
    GroundSpeed=120.0//150.000000
    WaterSpeed=140.000000
    Health=250//350
    HealthMax=250
    PlayerCountHealthScale=0.15
    PlayerNumHeadHealthScale=0.0
    HeadHealth=25
    CrispUpThreshhold=8    
    MotionDetectorThreat=0.5

    //A connoisseur of flesh, despite being jawless
    bCannibal = true
    MenuName="Gorefast 2.5"//"Gorefast"
    
    // Old melee
    damageConst = 100
    damageRand = 10
    
    SoloHeadScale=1.1
    
    //Updated
    OnlineHeadshotOffset=(X=25,Y=-5,Z=45)
    OnlineHeadshotScale=1.35
    
    bUseExtendedCollision=true
    ColOffset=(Z=52)
    ColRadius=25
    ColHeight=10    
}
