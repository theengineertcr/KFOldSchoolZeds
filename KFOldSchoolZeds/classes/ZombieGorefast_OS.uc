//Because we want the zeds to extend to KFMonsterOS, there's no choice
//Other than to overhaul all 3 files of each zed, controllers as well if
//We count certain other Zeds

//Make sure this uses all appropriate sounds, model, textures, etc.
class ZombieGorefast_OS extends ZombieGorefastOS;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

//Because the fucking animation set doesn't save whenever I change the default
//Anims, Unreal Editor can go fuck itself, I'll just force the Mesh to use
//The desired animation right here
event PreBeginPlay()
{
    Super.PreBeginPlay();
    LinkSkelAnim(MeshAnimation'KFCharacterModelsOldSchool.BloatSet');
}

defaultproperties
{
    ////Detached Limbs don't exist
    //DetachedArmClass=class'SeveredArmGorefast'
    //DetachedLegClass=class'SeveredLegGorefast'
    //DetachedHeadClass=class'SeveredHeadGorefast'

    //Use KFMod Models and Textures    
    Mesh=SkeletalMesh'KFCharacterModelsOldSchool.GoreFast'
    Skins(0)=Texture'KFOldSchoolZeds_Textures.Gorefast.GorefastSkin'

    //Use KFMod Sounds
    AmbientSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieBreath'
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Gorefast.Gorefast_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieJump'
    
    //Dont think we need this?    
    //MeleeAttackHitSound=sound'KF_EnemiesFinalSnd.Gorefast_HitPlayer'

    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieDeath'

    //KFMod Zeds don't use challenge sounds
    ChallengeSound(0)=None
    ChallengeSound(1)=None
    ChallengeSound(2)=None
    ChallengeSound(3)=None
}

