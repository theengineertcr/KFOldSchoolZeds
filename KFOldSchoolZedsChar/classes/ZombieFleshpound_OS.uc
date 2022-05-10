class ZombieFleshpound_STANDARD extends ZombieFleshpound;

defaultproperties
{
    DetachedArmClass=class'SeveredArmPound'
	DetachedLegClass=class'SeveredLegPound'
	DetachedHeadClass=class'SeveredHeadPound'

	Mesh=SkeletalMesh'KF_Freaks_Trip.FleshPound_Freak'

	Skins(0)=Combiner'KF_Specimens_Trip_T.fleshpound_cmb'

	AmbientSound=Sound'KF_BaseFleshpound.FP_IdleLoop'
	MoanVoice=Sound'KF_EnemiesFinalSnd.FP_Talk'
    JumpSound=Sound'KF_EnemiesFinalSnd.FP_Jump'
   	MeleeAttackHitSound=sound'KF_EnemiesFinalSnd.FP_HitPlayer'

	HitSound(0)=Sound'KF_EnemiesFinalSnd.FP_Pain'
    DeathSound(0)=Sound'KF_EnemiesFinalSnd.FP_Death'

    ChallengeSound(0)=Sound'KF_EnemiesFinalSnd.FP_Challenge'
    ChallengeSound(1)=Sound'KF_EnemiesFinalSnd.FP_Challenge'
    ChallengeSound(2)=Sound'KF_EnemiesFinalSnd.FP_Challenge'
    ChallengeSound(3)=Sound'KF_EnemiesFinalSnd.FP_Challenge'
}
