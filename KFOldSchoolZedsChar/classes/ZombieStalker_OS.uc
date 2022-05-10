class ZombieStalker_STANDARD extends ZombieStalker;

defaultproperties
{
    DetachedArmClass=class'SeveredArmStalker'
	DetachedLegClass=class'SeveredLegStalker'
	DetachedHeadClass=class'SeveredHeadStalker'

    Mesh=SkeletalMesh'KF_Freaks_Trip.Stalker_Freak'
    Skins(0) = Shader'KF_Specimens_Trip_T.stalker_invisible'//Combiner'KF_Specimens_Trip_T.stalker_cmb'//Shader 'KFCharacters.StalkerHairShader'
    Skins(1) = Shader'KF_Specimens_Trip_T.stalker_invisible'//Shader'KFCharacters.CloakShader';

    AmbientSound=Sound'KF_BaseStalker.Stalker_IdleLoop'
    MoanVoice=Sound'KF_EnemiesFinalSnd.Stalker_Talk'
    JumpSound=Sound'KF_EnemiesFinalSnd.Stalker_Jump'
	MeleeAttackHitSound=sound'KF_EnemiesFinalSnd.Stalker_HitPlayer'

    HitSound(0)=Sound'KF_EnemiesFinalSnd.Stalker_Pain'
    DeathSound(0)=Sound'KF_EnemiesFinalSnd.Stalker_Death'

    ChallengeSound(0)=Sound'KF_EnemiesFinalSnd.Stalker_Challenge'
    ChallengeSound(1)=Sound'KF_EnemiesFinalSnd.Stalker_Challenge'
    ChallengeSound(2)=Sound'KF_EnemiesFinalSnd.Stalker_Challenge'
    ChallengeSound(3)=Sound'KF_EnemiesFinalSnd.Stalker_Challenge'
}

