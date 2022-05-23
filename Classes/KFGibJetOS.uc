//=============================================================================
// KF GibJet.      This streaks after bits of flesh. Yum.
//=============================================================================
class KFGibJetOS extends BloodJetOS;

// Load texture package
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

defaultproperties
{
     mMaxParticles=20
     mLifeRange(0)=2.500000
     mLifeRange(1)=3.000000
     mColorRange(0)=(B=120,G=120,R=120)
     mColorRange(1)=(B=120,G=120,R=120)
     // Bloody spray in KFX was imported to KFOldSchoolZeds_Textures
     Skins(0)=Texture'KFOldSchoolZeds_Textures.BloodySpray'
     Style=STY_Modulated
     bUnlit=False
}