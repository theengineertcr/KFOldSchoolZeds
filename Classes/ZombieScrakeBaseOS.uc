//Because we want the zeds to extend to KFMonsterOS, there's no choice
//Other than to overhaul all 3 files of each zed, controllers as well if
//We count certain other Zeds

// Chainsaw Zombie Monster for KF Invasion gametype
// He's not quite as speedy as the other Zombies, But his attacks are TRULY damaging.
class ZombieScrakeBaseOS extends KFMonsterOS
    abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

//Retail variables that we don't need
//var(Sounds) sound   SawAttackLoopSound; // THe sound for the saw revved up, looping
//var(Sounds) sound   ChainSawOffSound;   //The sound of this zombie dieing without a head

//We want him to charge when he's hurt to keep consistency with retail zeds abilities
var         bool    bCharging;          // Scrake charges when his health gets low

//This new variable controls how close the Scrake has to be before he can Saw his victim
//Higher means closer, lower means farther
var float DistBeforeSaw;

//No full body anims means that this gets cut out
//var()       float   AttackChargeRate;   // Ratio to increase scrake movement speed when charging and attacking

//Retail variables that arent in the mod
// Exhaust effects
//var()    class<VehicleExhaustEffect>    ExhaustEffectClass; // Effect class for the exhaust emitter
//var()    VehicleExhaustEffect         ExhaustEffect;
//var         bool    bNoExhaustRespawn;

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
    //These values were not set in KFMod
    //DrawScale=1.05
    //AmbientGlow=0
    //StunTime=0.3 Was used in Balance Round 1(removed for Round 2)
    //StunsRemaining=1 //Added in Balance Round 2//This may effect balance(?)
    //SoundVolume=175
    //SeveredHeadAttachScale=1.0
    //SeveredLegAttachScale=1.1
    //SeveredArmAttachScale=1.1
    ZombieFlag=3
    //AttackChargeRate=2.5
    //ExhaustEffectClass=class'KFMOD.ChainSawExhaust'

    //Values that don't need to be changed
    bMeleeStunImmune = true
    MeleeAnims(0)="SawZombieAttack1"
    MeleeAnims(1)="SawZombieAttack2"
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
    IdleHeavyAnim="SawZombieIdle"
    IdleRifleAnim="SawZombieIdle"
    bFatAss=True
    Mass=500.000000
    RotationRate=(Yaw=45000,Roll=0)
    bUseExtendedCollision=True
    DamageToMonsterScale=8.0
    PoundRageBumpDamScale=0.01

    //We'll keep these values the same as the retail version
    //As this mod was made purely for the visual aspect, not gameplay
    MeleeDamage=20
    damageForce=-100000//-75000//-400000 //Exception - his loop attack is bloody useless, give it a little force increase
    ScoringValue=75
    //Exception - We had to increase melee range or he'll never hit a player
    //TODO:Maybe do a distance check to make him only attack when he's glued to the target?
    //Balance Round 1 Melee Range felt too long, reduced from 95 to 60, DistBeforeSaw to 2.5
    MeleeRange=60//95.000000//40.0
    DistBeforeSaw=0.0
    GroundSpeed=85.000000
    WaterSpeed=75.000000
    Health=1000//1500
    HealthMax=1000
    PlayerCountHealthScale=0.5
    PlayerNumHeadHealthScale=0.30 // Was 0.35 in Balance Round 1
    HeadHealth=650
    BleedOutDuration=6.0
    MotionDetectorThreat=3.0
    ZapThreshold=1.25
    ZappedDamageMod=1.25
    bHarpoonToHeadStuns=true
    bHarpoonToBodyStuns=false
    Intelligence=BRAINS_Mammal

    KFRagdollName="SawZombieRag"//"Scrake_Trip"//Used KFMod ragdoll
    //He doesn't cut them up just for fun, he's hungry too!
    bCannibal = true
    MenuName="Scrake 2.5"//"Scrake"
    SoundRadius=200.000000//100.0//Used KFMod value
    AmbientSoundScaling=1.800000//KFMod variable

    //These might need to be changed
    ColOffset=(Z=55)
    ColRadius=29
    ColHeight=18
    Prepivot=(Z=0.0)

    SoloHeadScale=1.3

    //Updated
    OnlineHeadshotOffset=(X=25,Y=-7,Z=57) //Z=39 while charging
    OnlineHeadshotScale=1.5//1.5
}