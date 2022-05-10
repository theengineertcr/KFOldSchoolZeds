//Because we want the zeds to extend to KFMonsterOS, there's no choice
//Other than to overhaul all 3 files of each zed, controllers as well if
//We count certain other Zeds

//Make sure this uses all appropriate sounds, model, textures, etc.
class ZombieCrawler_OS extends ZombieCrawlerOS;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
//Textures are flipped from the modified model resulting in it looking weird, use the animation package that comes with the game
#exec OBJ LOAD FILE=KFCharacterModels.ukx

//Force it to use our anim set
event PreBeginPlay()
{
	Super.PreBeginPlay();
	LinkSkelAnim(MeshAnimation'KFCharacterModelsOldSchool.InfectedWhiteMale1');
}

defaultproperties
{
	////Detached Limbs don't exist
    //DetachedArmClass=class'SeveredArmCrawler'
	//DetachedLegClass=class'SeveredLegCrawler'
	//DetachedHeadClass=class'SeveredHeadCrawler'

	//Use KFMod Models and Textures
    Mesh=SkeletalMesh'KFCharacterModels.Shade'
    Skins(0)=Texture'KFOldSchoolZeds_Textures.Crawler.CrawlerSkin'
    Skins(1)=FinalBlend'KFOldSchoolZeds_Textures.Crawler.CrawlerHairFB'
	
	//Use KFMod Sounds
    AmbientSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieBreath'
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Crawler.Crawler_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieJump'
	
	//Dont think we need this?
    //MeleeAttackHitSound=sound'KF_EnemiesFinalSnd.Crawler_HitPlayer'

    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieDeath'

	//KFMod Zeds don't use challenge sounds
    ChallengeSound(0)=None
    ChallengeSound(1)=None
    ChallengeSound(2)=None
    ChallengeSound(3)=None
}

