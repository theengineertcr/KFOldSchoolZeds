//Because we want the zeds to extend to KFMonsterOS, there's no choice
//Other than to overhaul all 3 files of each zed, controllers as well if
//We count certain other Zeds

//Make sure this uses all appropriate sounds, model, textures, etc.
class ZombieStalker_OS extends ZombieStalkerOS;

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
	LinkSkelAnim(MeshAnimation'KFCharacterModelsOldSchool.SirenSet');
}

defaultproperties
{
	////Detached Limbs don't exist
    //DetachedArmClass=class'SeveredArmStalker'
	//DetachedLegClass=class'SeveredLegStalker'
	//DetachedHeadClass=class'SeveredHeadStalker'

	//Use KFMod Models and Textures
    Mesh=SkeletalMesh'KFCharacterModelsOldSchool.InfectedWhiteFemale'
    Skins(0) = Shader'KFOldSchoolZeds_Textures.StalkerHairShader'//Combiner'KF_Specimens_Trip_T.stalker_cmb'//Shader 'KFCharacters.StalkerHairShader'
    Skins(1) = Shader'KFOldSchoolZeds_Textures.StalkerCloakShader'//Shader'KFCharacters.CloakShader';

	//Use KFMod Sounds	
    AmbientSound=None
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Stalker.Stalker_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Female_ZombieJump'
	
	//Dont think we need this?	
	//MeleeAttackHitSound=sound'KFOldSchoolZeds_Sounds.Stalker_HitPlayer'

	
    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Female_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Stalker.Stalker_Death'

	//KFMod Zeds don't use challenge sounds
    ChallengeSound(0)=None
    ChallengeSound(1)=None
    ChallengeSound(2)=None
    ChallengeSound(3)=None
}

