//Because we want the zeds to extend to KFMonsterOS, there's no choice
//Other than to overhaul all 3 files of each zed, controllers as well if
//We count certain other Zeds

//Make sure this uses all appropriate sounds, model, textures, etc.
class ZombieSiren_OS extends ZombieSirenOS;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

defaultproperties
{
    ////Detached Limbs don't exist
    //DetachedLegClass=class'SeveredLegSiren'
    //DetachedHeadClass=class'SeveredHeadSiren'

    //Use KFMod Models and Textures
    Mesh=SkeletalMesh'KFCharacterModelsOldSchool.InfectedWhiteMale2'

    Skins(0)=Texture'KFOldSchoolZeds_Textures.Siren.SirenSkin'
    Skins(1)=FinalBlend'KFOldSchoolZeds_Textures.Siren.SirenHairFB'

    //Use KFMod Sounds
    //Let's not have her breathe
    AmbientSound=none
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Siren.Siren_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Female_ZombieJump'

    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Female_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Stalker.Siren_Die'
}