class ZombieSiren_STANDARD extends ZombieSiren;

defaultproperties
{
    DetachedLegClass=class'SeveredLegSiren'
	DetachedHeadClass=class'SeveredHeadSiren'

    Mesh=SkeletalMesh'KF_Freaks_Trip.Siren_Freak'

    Skins(0)=FinalBlend'KF_Specimens_Trip_T.siren_hair_fb'
    Skins(1)=Combiner'KF_Specimens_Trip_T.siren_cmb'

    AmbientSound=Sound'KF_BaseSiren.Siren_IdleLoop'
    MoanVoice=Sound'KF_EnemiesFinalSnd.Siren_Talk'
    JumpSound=Sound'KF_EnemiesFinalSnd.Siren_Jump'

    HitSound(0)=Sound'KF_EnemiesFinalSnd.Siren_Pain'
    DeathSound(0)=Sound'KF_EnemiesFinalSnd.Siren_Death'
}

