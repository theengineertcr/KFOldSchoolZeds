//Because we want the zeds to extend to KFMonsterOS, there's no choice
//Other than to overhaul all 3 files of each zed, controllers as well if
//We count certain other Zeds

//Make sure this uses all appropriate sounds, model, textures, etc.
class ZombieBloat_OS extends ZombieBloatOS;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

defaultproperties
{
    ////Detached Limbs don't exist
    //DetachedArmClass=class'SeveredArmBloat'
    //DetachedLegClass=class'SeveredLegBloat'
    //DetachedHeadClass=class'SeveredHeadBloat'

    //This doesn't need to be stated, keep it in ZombieBloat
    //BileExplosion=class'KFMod.BileExplosion'
    //BileExplosionHeadless=class'KFMod.BileExplosionHeadless'

    //Use KFMod Models and Textures
    Mesh=SkeletalMesh'KFCharacterModelsOldSchool.Bloat'
    Skins(0)=Texture'KFOldSchoolZeds_Textures.Bloat.BloatSkin'

    //Use KFMod Sounds
    AmbientSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieBreath'
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Bloat.Bloat_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieJump'

    //Dont think we need this?
    //MeleeAttackHitSound=sound'KF_EnemiesFinalSnd.Bloat_HitPlayer'

    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieDeath'

    //KFMod Zeds don't use challenge sounds
    ChallengeSound(0)=None
    ChallengeSound(1)=None
    ChallengeSound(2)=None
    ChallengeSound(3)=None
}