//Because we want the zeds to extend to KFMonsterOS, there's no choice
//Other than to overhaul all 3 files of each zed, controllers as well if
//We count certain other Zeds

class ZombieBoss_OS extends ZombieBossOS;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFBossOld.ukx
#exec OBJ LOAD FILE=KFPatch2.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax


defaultproperties
{
	////Detached Limbs don't exist	
    //DetachedArmClass=class'SeveredArmPatriarch'
	//DetachedSpecialArmClass=class'SeveredRocketArmPatriarch'
	//DetachedLegClass=class'SeveredLegPatriarch'
	//DetachedHeadClass=class'SeveredHeadPatriarch'

	//Use KFMod Models and Textures
	Mesh=SkeletalMesh'KFBossOld.Boss'
    Skins(0)=FinalBlend'KFPatch2.BossHairFB'
    Skins(1)=Texture'KFPatch2.BossBits'
    Skins(2)=Texture'KFPatch2.GunPoundSkin'
    Skins(3)=Texture'KFPatch2.BossGun'
    Skins(4)=Texture'KFPatch2.BossBits'
    Skins(5)=Texture'KFPatch2.BossBits'
    Skins(6)=Shader'KFPatch2.LaserShader'

	//Use KFMod Sounds
    AmbientSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieBreath'
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Patriarch.Patriarch_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieJump'
	
	//Dont think we need this?		
    //MeleeAttackHitSound=sound'KF_EnemiesFinalSnd.Kev_HitPlayer_Fist'

    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Patriarch.Patriarch_Pain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieDeath'

	//Modern variables we dont want
	//MeleeImpaleHitSound=sound'KF_EnemiesFinalSnd.Kev_HitPlayer_Impale'
	//RocketFireSound=sound'KF_EnemiesFinalSnd.Kev_FireRocket'
	//MiniGunFireSound=sound'KF_BasePatriarch.Kev_MG_GunfireLoop'
	//MiniGunSpinSound=Sound'KF_BasePatriarch.Attack.Kev_MG_TurbineFireLoop'
}
