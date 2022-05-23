//Because we want the zeds to extend to KFMonsterOS, there's no choice
//Other than to overhaul all 3 files of each zed, controllers as well if
//We count certain other Zeds

//Make sure this uses all appropriate sounds, model, textures, etc.
class ZombieFleshpound_OS extends ZombieFleshpoundOS;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

defaultproperties
{
    ////Detached Limbs don't exist
    //DetachedArmClass=class'SeveredArmPound'
    //DetachedLegClass=class'SeveredLegPound'
    //DetachedHeadClass=class'SeveredHeadPound'

    //Use KFMod Models and Textures
    Mesh=SkeletalMesh'KFCharacterModelsOldSchool.ZombieBoss'
    Skins(0)=Shader'KFOldSchoolZeds_Textures.Fleshpound.PoundBitsShader'
    Skins(1)=FinalBlend'KFOldSchoolZeds_Textures.Fleshpound.AmberPoundMeter'
    Skins(2)=Shader'KFOldSchoolZeds_Textures.Fleshpound.FPDeviceBloomAmberShader'
    Skins(3)=Texture'KFOldSchoolZeds_Textures.Fleshpound.PoundSkin'

    //Use KFMod Sounds
    AmbientSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieBreath'
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Fleshpound.Fleshpound_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieJump'

    //Dont think we need this?
    //MeleeAttackHitSound=sound'KF_EnemiesFinalSnd.FP_HitPlayer'

    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieDeath'

    //KFMod Zeds don't use challenge sounds
    ChallengeSound(0)=none
    ChallengeSound(1)=none
    ChallengeSound(2)=none
    ChallengeSound(3)=none
}