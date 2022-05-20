// All Rangedpound classes are modified Boss classes

//Because we want the zeds to extend to KFMonsterOS, there's no choice
//Other than to overhaul all 3 files of each zed, controllers as well if
//We count certain other Zeds

class ZombieRangedPound_OS extends ZombieRangedPoundOS;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax


defaultproperties
{
    ////Detached Limbs don't exist    
    //DetachedArmClass=class'SeveredArmPatriarch'
    //DetachedSpecialArmClass=class'SeveredRocketArmPatriarch'
    //DetachedLegClass=class'SeveredLegPatriarch'
    //DetachedHeadClass=class'SeveredHeadPatriarch'

    //Use KFMod Models and Textures
    Mesh=SkeletalMesh'KFCharacterModelsOldSchool.Rangedpound'
    Skins(0)=Shader'KFOldSchoolZeds_Textures.Fleshpound.PoundBitsShader'
    Skins(1)=Texture'KFOldSchoolZeds_Textures.GunPound.AutoTurretGunTex'
    Skins(2)=Texture'KFOldSchoolZeds_Textures.GunPound.GunPoundSkin'    

    //Use KFMod Sounds
    //Removed cuz it was buggy
    AmbientSound=None
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Fleshpound.Fleshpound_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieJump'
    
    //Dont think we need this?        
    //MeleeAttackHitSound=sound'KF_EnemiesFinalSnd.Kev_HitPlayer_Fist'

    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieDeath'

    //Modern variables we dont want
    //MeleeImpaleHitSound=sound'KF_EnemiesFinalSnd.Kev_HitPlayer_Impale'
    //RocketFireSound=sound'KF_EnemiesFinalSnd.Kev_FireRocket'
    //MiniGunFireSound=sound'KF_BasePatriarch.Kev_MG_GunfireLoop'
    //MiniGunSpinSound=Sound'KF_BasePatriarch.Attack.Kev_MG_TurbineFireLoop'
}
