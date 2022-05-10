class ZombieBloat_STANDARD extends ZombieBloat;

defaultproperties
{
    DetachedArmClass=class'SeveredArmBloat'
	DetachedLegClass=class'SeveredLegBloat'
	DetachedHeadClass=class'SeveredHeadBloat'

	BileExplosion=class'KFMod.BileExplosion'
	BileExplosionHeadless=class'KFMod.BileExplosionHeadless'

    Mesh=SkeletalMesh'KF_Freaks_Trip.Bloat_Freak'

    Skins(0)=Combiner'KF_Specimens_Trip_T.bloat_cmb'

    AmbientSound=Sound'KF_BaseBloat.Bloat_Idle1Loop'
    MoanVoice=Sound'KF_EnemiesFinalSnd.Bloat_Talk'
    JumpSound=Sound'KF_EnemiesFinalSnd.Bloat_Jump'
    MeleeAttackHitSound=sound'KF_EnemiesFinalSnd.Bloat_HitPlayer'

    HitSound(0)=Sound'KF_EnemiesFinalSnd.Bloat_Pain'
    DeathSound(0)=Sound'KF_EnemiesFinalSnd.Bloat_Death'

    ChallengeSound(0)=Sound'KF_EnemiesFinalSnd.Bloat_Challenge'
    ChallengeSound(1)=Sound'KF_EnemiesFinalSnd.Bloat_Challenge'
    ChallengeSound(2)=Sound'KF_EnemiesFinalSnd.Bloat_Challenge'
    ChallengeSound(3)=Sound'KF_EnemiesFinalSnd.Bloat_Challenge'
}
