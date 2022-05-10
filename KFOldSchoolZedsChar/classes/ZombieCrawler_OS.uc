class ZombieCrawler_STANDARD extends ZombieCrawler;

defaultproperties
{
    DetachedArmClass=class'SeveredArmCrawler'
	DetachedLegClass=class'SeveredLegCrawler'
	DetachedHeadClass=class'SeveredHeadCrawler'

    Mesh=SkeletalMesh'KF_Freaks_Trip.Crawler_Freak'

    Skins(0)=Combiner'KF_Specimens_Trip_T.crawler_cmb'

    AmbientSound=Sound'KF_BaseCrawler.Crawler_Idle'
    MoanVoice=Sound'KF_EnemiesFinalSnd.Crawler_Talk'
    JumpSound=Sound'KF_EnemiesFinalSnd.Crawler_Jump'
    MeleeAttackHitSound=sound'KF_EnemiesFinalSnd.Crawler_HitPlayer'

    HitSound(0)=Sound'KF_EnemiesFinalSnd.Crawler_Pain'
    DeathSound(0)=Sound'KF_EnemiesFinalSnd.Crawler_Death'

    ChallengeSound(0)=Sound'KF_EnemiesFinalSnd.Crawler_Acquire'
    ChallengeSound(1)=Sound'KF_EnemiesFinalSnd.Crawler_Acquire'
    ChallengeSound(2)=Sound'KF_EnemiesFinalSnd.Crawler_Acquire'
    ChallengeSound(3)=Sound'KF_EnemiesFinalSnd.Crawler_Acquire'
}

