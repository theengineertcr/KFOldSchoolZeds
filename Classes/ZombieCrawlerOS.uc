//Because we want the zeds to extend to KFMonsterOS,
//We'll need to overhaul all class files of each zed,
//Controllers as well if we count certain Zeds

// Zombie Monster for KF Invasion gametype
class ZombieCrawlerOS extends ZombieCrawlerBaseOS
    abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

//----------------------------------------------------------------------------
// NOTE: All Variables are declared in the base class to eliminate hitching
//----------------------------------------------------------------------------

//Issues:
//None for now.

//For some reason, retail KF redefined the same functions in the base class here,
//So we'll redefine them here as well, except for ZombieMoan since Zeds already have
//A set MoanVoice, and nothing warrants redefining it for our special Crawler boy

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

//More or less unchanged, we just want the modern damage calculations
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

//Precache KFMod textures.
static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Crawler.CrawlerSkin');
    myLevel.AddPrecacheMaterial(FinalBlend'KFOldSchoolZeds_Textures.Crawler.CrawlerHairFB');
}

defaultproperties
{
    //-------------------------------------------------------------------------------
    // NOTE: Most Default Properties are set in the base class to eliminate hitching
    //-------------------------------------------------------------------------------

    //Use the Old CrawlerController
    ControllerClass=Class'CrawlerControllerOS'
}