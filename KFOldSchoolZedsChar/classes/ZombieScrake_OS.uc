//Because we want the zeds to extend to KFMonsterOS, there's no choice
//Other than to overhaul all 3 files of each zed, controllers as well if
//We count certain other Zeds

//Make sure this uses all appropriate sounds, model, textures, etc.
class ZombieScrake_OS extends ZombieScrakeOS;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

defaultproperties
{
    ////Detached Limbs don't exist
    //DetachedArmClass=class'SeveredArmScrake'
    //DetachedSpecialArmClass=class'SeveredArmScrakeSaw'
    //DetachedLegClass=class'SeveredLegScrake'
    //DetachedHeadClass=class'SeveredHeadScrake'

    //Use KFMod Models and Textures
    Mesh=SkeletalMesh'KFCharacterModelsOldSchool.SawZombie'
    Skins(0)=Texture'KFOldSchoolZeds_Textures.Scrake.ScrakeSkin'
    Skins(1)=TexOscillator'KFOldSchoolZeds_Textures.Scrake.SawChainOSC'    
    Skins(2)=Texture'KFOldSchoolZeds_Textures.Scrake.ScrakeFrockSkin'
    Skins(3)=Texture'KFOldSchoolZeds_Textures.Scrake.ScrakeSawSkin'    

    //Use KFMod Sounds
    AmbientSound=Sound'KFOldSchoolZeds_Sounds.Scrake.Saw_Idle'
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Scrake.Scrake_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieJump'

    //Dont think we need this?    
    //MeleeAttackHitSound=Sound'KF_EnemiesFinalSnd.Scrake_Chainsaw_HitPlayer'

    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieDeath'

    //KFMod Zeds don't use challenge sounds
    ChallengeSound(0)=None
    ChallengeSound(1)=None
    ChallengeSound(2)=None
    ChallengeSound(3)=None

    //Retail variables we dont want
    //SawAttackLoopSound=Sound'KF_BaseScrake.Scrake_Chainsaw_Impale'
    //ChainSawOffSound=Sound'KF_ChainsawSnd.Chainsaw_Deselect'
}

