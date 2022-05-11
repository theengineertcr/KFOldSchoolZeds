// ✔
//=============================================================================
// KF Blood Spray (normal shot effect)
//=============================================================================
class KFBloodPuffOS extends BloodSmallHit;

    // Load the texture package
    #exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

defaultproperties
{
     // Use the KFMod BloodSplatter
     BloodDecalClass=Class'KFOldSchoolZedsMod.KFBloodSplatterDecalOS'
     //KFX to KFOldSchoolZeds_Textures
     Splats(0)=Texture'KFOldSchoolZeds_Textures.BloodSplat1'
     Splats(1)=Texture'KFOldSchoolZeds_Textures.BloodSplat2'
     Splats(2)=Texture'KFOldSchoolZeds_Textures.BloodSplat3'
     mMaxParticles=6
     mLifeRange(1)=0.700000
     mDirDev=(X=0.000000,Y=15.000000,Z=10.000000)
     mPosDev=(X=0.000000,Y=0.000000,Z=0.000000)
     mSpeedRange(0)=2.000000
     mSpeedRange(1)=4.000000
     mMassRange(0)=1.000000
     mMassRange(1)=2.000000
     mRandOrient=False
     mSpinRange(0)=50.000000
     mSpinRange(1)=100.000000
     mSizeRange(1)=10.000000
     mGrowthRate=45.000000
     mNumTileColumns=4
     mNumTileRows=4
     // KFX to KFOldSchoolZeds_Textures
     Skins(0)=Texture'KFOldSchoolZeds_Textures.BloodySpray'
     Style=STY_Modulated
}
