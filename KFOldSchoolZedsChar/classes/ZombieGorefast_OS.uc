class ZombieGorefast_STANDARD extends ZombieGorefast;

defaultproperties
{
    DetachedArmClass=class'SeveredArmGorefast'
	DetachedLegClass=class'SeveredLegGorefast'
	DetachedHeadClass=class'SeveredHeadGorefast'

    Mesh=SkeletalMesh'KF_Freaks_Trip.GoreFast_Freak'

    Skins(0)=Combiner'KF_Specimens_Trip_T.Gorefast_cmb'

    AmbientSound=Sound'KF_BaseGorefast.Gorefast_Idle'
    MoanVoice=Sound'KF_EnemiesFinalSnd.Gorefast_Talk'
    JumpSound=Sound'KF_EnemiesFinalSnd.Gorefast_Jump'
    MeleeAttackHitSound=sound'KF_EnemiesFinalSnd.Gorefast_HitPlayer'

    HitSound(0)=Sound'KF_EnemiesFinalSnd.Gorefast_Pain'
    DeathSound(0)=Sound'KF_EnemiesFinalSnd.Gorefast_Death'

    ChallengeSound(0)=Sound'KF_EnemiesFinalSnd.Gorefast_Challenge'
    ChallengeSound(1)=Sound'KF_EnemiesFinalSnd.Gorefast_Challenge'
    ChallengeSound(2)=Sound'KF_EnemiesFinalSnd.Gorefast_Challenge'
    ChallengeSound(3)=Sound'KF_EnemiesFinalSnd.Gorefast_Challenge'
}

