//Because we want the zeds to extend to KFMonsterOS, there's no choice
//Other than to overhaul all 3 files of each zed, controllers as well if
//We count certain other Zeds

// Zombie Monster for KF Invasion gametype
class ZombieCrawlerBaseOS extends KFMonsterOS
    abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

//Both variables are in KFMod
var() float PounceSpeed;
var bool bPouncing;

//Not in KFMod
//var(Anims)  name    MeleeAirAnims[3]; // Attack anims for when flying through the air

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

//Exact same as in KFMod, do not touch
function bool DoPounce()
{
    if ( bZapped || bIsCrouched || bWantsToCrouch || (Physics != PHYS_Walking) || VSize(Location - Controller.Target.Location) > (MeleeRange * 5) )
        return false;

    Velocity = Normal(Controller.Target.Location-Location)*PounceSpeed;
    Velocity.Z = JumpZ;
    SetPhysics(PHYS_Falling);
    ZombieSpringAnim();
    bPouncing=true;
    return true;
}

//Exact same as in KFMod, do not touch
simulated function ZombieSpringAnim()
{
    SetAnimAction('ZombieSpring');
}

//Exact same as in KFMod, do not touch
event Landed(vector HitNormal)
{
    bPouncing=false;
    super.Landed(HitNormal);
}

//Mostly, Unchanged, we just want the Retail damage calculations
event Bump(actor Other)
{
    // TODO: is there a better way
    if(bPouncing && KFHumanPawn(Other)!=none )
    {
        KFHumanPawn(Other).TakeDamage(((MeleeDamage - (MeleeDamage * 0.05)) + (MeleeDamage * (FRand() * 0.1))), self ,self.Location,self.velocity, class 'KFmod.ZombieMeleeDamage');
        if (KFHumanPawn(Other).Health <=0)
        {
            //TODO - move this to humanpawn.takedamage? Also see KFMonster.MeleeDamageTarget
            KFHumanPawn(Other).SpawnGibs(self.rotation, 1);
        }
        //After impact, there'll be no momentum for further bumps
        bPouncing=false;
    }
}

// KFMod doesn't have this
// Blend his attacks so he can hit you in mid air.
//simulated function int DoAnimAction( name AnimName )
//{
//    if( AnimName=='ZombieLeapAttack' || AnimName=='LeapAttack3' || AnimName=='ZombieLeapAttack' )
//    {
//        AnimBlendParams(1, 1.0, 0.0,, 'Bip01 Spine1');
//        PlayAnim(AnimName,, 0.0, 1);
//        Return 1;
//    }
//    Return Super.DoAnimAction(AnimName);
//}

//KFMod SetAnimAction
// Blend his attacks so he can hit you in mid air.
simulated event SetAnimAction(name NewAction)
{
  Super.SetAnimAction(NewAction);

        if ( AnimAction == 'ZombieLeapAttack' || AnimAction == 'LeapAttack3'
            || AnimAction == 'ZombieLeapAttack')
        {
          AnimBlendParams(1, 1.0, 0.0,, 'Bip01 Spine1');
          PlayAnim(NewAction,, 0.0, 1);
        }

}

//Retail code not in KFMod
// The animation is full body and should set the bWaitForAnim flag
//simulated function bool AnimNeedsWait(name TestAnim)
//{
//    if( TestAnim == 'ZombieSpring' /*|| TestAnim == 'DoorBash'*/ ) //Crawlers don't use Doorbash anims
//    {
//        return true;
//    }
//
//    return false;
//}

function bool FlipOver()
{
    Return False;
}

defaultproperties
{
    //These values were not set in KFMod
    //DrawScale=1.1
    //Prepivot=(X=0.0)
    //MeleeAirAnims(0)="InAir_Attack1"
    //MeleeAirAnims(1)="InAir_Attack2"//"ZombieLeapAttack"
    //MeleeAirAnims(2)="InAir_Attack2"//"LeapAttack3"
    //SeveredHeadAttachScale=1.1
    //SeveredLegAttachScale=0.85
    //SeveredArmAttachScale=0.8
    //ZombieFlag=2
    //bDoTorsoTwist=False
    
    //Values that don't need to be changed
    bCannibal = true    
    Intelligence=BRAINS_Mammal    
    bStunImmune=True
    damageForce=5000
    IdleHeavyAnim="ZombieLeapIdle"
    IdleRifleAnim="ZombieLeapIdle"    
    TakeoffAnims(0)= "ZombieSpring"
    TakeoffAnims(1)= "ZombieSpring"
    TakeoffAnims(2)= "ZombieSpring"
    TakeoffAnims(3)= "ZombieSpring"
    AirAnims(0)="ZombieSpring"
    
    AirAnims(3)="ZombieSpring"    
    AirStillAnim="ZombieSpring"
    IdleCrouchAnim="ZombieLeapIdle"
    IdleWeaponAnim="ZombieLeapIdle"
    IdleRestAnim="ZombieLeapIdle"
    CollisionHeight=25.000000
    bCrawler = true
    bOrientOnSlope = true
    
    //We'll keep these values the same as the retail version
    //As this mod was made purely for the visual aspect, not gameplay
    MeleeDamage=6
    ScoringValue=10
    GroundSpeed=140.000000
    WaterSpeed=130.000000
    JumpZ=350.000000
    Health=70//100
    HealthMax=70//100
    PounceSpeed=330.000000   // 300
    MotionDetectorThreat=0.34
    CrispUpThreshhold=10
    
    //All of these need to be ZombieLeapIdle
    //Previous comment obsolete, bad idea from the old code That makes Crawlers
    //Walk while doing idle anims. Swap with ZombieScuttle instead.
    TurnLeftAnim= "ZombieScuttle"
    TurnRightAnim= "ZombieScuttle"
    LandAnims(0)= "ZombieScuttle"
    LandAnims(1)="ZombieScuttle"
    LandAnims(2)="ZombieScuttle"
    LandAnims(3)="ZombieScuttle"
    
    //All of these need to be ZombieScuttle
    MovementAnims(0)="ZombieScuttle"
    MovementAnims(1)="ZombieScuttle"
    MovementAnims(2)="ZombieScuttle"
    MovementAnims(3)="ZombieScuttle"    
    WalkAnims(0)="ZombieLeap"
    WalkAnims(1)="ZombieLeap"
    WalkAnims(2)="ZombieLeap"
    WalkAnims(3)="ZombieLeap"

    //All of these used the ZombieSpring anim in KFMod
    //Bad idea, don't use any anims when getting hit
    HitAnims(0)=None//"HitF"
    HitAnims(1)=None//"HitF"
    HitAnims(2)=None//"HitF"
    KFHitFront=None//"HitF"
    KFHitBack=None//"HitF"
    KFHitLeft=None//"HitF"
    KFHitRight=None//"HitF"

    MeleeAnims(0)="ZombieLeapAttack"
    MeleeAnims(1)="ZombieLeapAttack"//"ZombieLeapAttack2"//Swapped to Old Anim
    MeleeAnims(2)="LeapAttack3"//"ZombieLeapAttack2"//Swapped to Old Anim

    TakeoffStillAnim="ZombieLeap"//"ZombieLeapIdle"//Swapped to Old Anim
    
    //Use Old Ragdoll
    KFRagdollName="CrawlerRag"
    MenuName="Crawler 2.5"//"Crawler"
    
    //KFMod had this so were bringing it here
    SpineBone1=
    SpineBone2=    

    HeadHeight=2.5
    HeadScale=1.5//1.05
    OnlineHeadshotOffset=(X=28,Y=0,Z=7)
    OnlineHeadshotScale=1.75//1.2    
    CollisionRadius=26.000000    
}
