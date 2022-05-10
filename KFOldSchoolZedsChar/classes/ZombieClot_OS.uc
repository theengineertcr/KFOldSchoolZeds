class ZombieClot_STANDARD extends ZombieClot;

defaultproperties
{
    DetachedArmClass="SeveredArmClot"
	DetachedLegClass="SeveredLegClot"
	DetachedHeadClass="SeveredHeadClot"

    Mesh=SkeletalMesh'KF_Freaks_Trip.CLOT_Freak'

    Skins(0)=Combiner'KF_Specimens_Trip_T.clot_cmb'

    AmbientSound=Sound'KF_BaseClot.Clot_Idle1Loop'//Sound'KFPlayerSound.Zombiesbreath'//
    MoanVoice=Sound'KF_EnemiesFinalSnd.Clot_Talk'
    JumpSound=Sound'KF_EnemiesFinalSnd.Clot_Jump'
	MeleeAttackHitSound=sound'KF_EnemiesFinalSnd.Clot_HitPlayer'

    HitSound(0)=Sound'KF_EnemiesFinalSnd.Clot_Pain'
    DeathSound(0)=Sound'KF_EnemiesFinalSnd.Clot_Death'

    ChallengeSound(0)=Sound'KF_EnemiesFinalSnd.Clot_Challenge'
    ChallengeSound(1)=Sound'KF_EnemiesFinalSnd.Clot_Challenge'
    ChallengeSound(2)=Sound'KF_EnemiesFinalSnd.Clot_Challenge'
    ChallengeSound(3)=Sound'KF_EnemiesFinalSnd.Clot_Challenge'
}
