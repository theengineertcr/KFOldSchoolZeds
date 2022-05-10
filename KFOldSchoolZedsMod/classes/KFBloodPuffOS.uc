//=============================================================================
// KF Blood Spray (normal shot effect)
//=============================================================================
class KFBloodPuff extends BloodSmallHit;

#exec OBJ LOAD File=KFX.utx

defaultproperties
{
//=============================================================================
// KF Blood Spray (normal shot effect)       Original Style
//=============================================================================
//
//     BloodDecalClass=Class'KFMod.KFBloodSplatterDecal'
//     Splats(0)=Texture'KFX.BloodSplat1'
//     Splats(1)=Texture'KFX.BloodSplat2'
//     Splats(2)=Texture'KFX.BloodSplat3'
//
//     Skins(0)=Texture'KFX.BloodySpray'
//     //bForceAffected=False
//
//     mNumTileColumns = 4
//     mNumTileRows = 4
//     mGrowthRate = 45
//     Style = STY_Modulated  //   STY_Alpha
//     mRandOrient = false
//
//     mSpeedRange(0) = 2
//     mSpeedRange(1) = 4
//
//     mMassRange(0) = 1
//     mMassRange(1) = 2
//
//     mSpinRange(0) = 50
//     mSpinRange(1) = 100
//
//     mSizeRange(0) = 10
//     mSizeRange(1) = 10
//
//     mDirDev=(X=0,Y=15,Z=10)
//     mPosDev=(X=0,Y=0,Z=0)
//
//     mLifeRange(0)= 0.5
//     mLifeRange(1) = 0.7
//
//     mMaxParticles = 6
//
//    // mPosRelative = false

//

//=============================================================================
// KF Blood Spray (normal shot effect)       New 2d Style Style
//=============================================================================
             BloodDecalClass=Class'KFMod.KFBloodSplatterDecal'
     Splats(0)=Texture'KFX.BloodSplat1'
     Splats(1)=Texture'KFX.BloodSplat2'
     Splats(2)=Texture'KFX.BloodSplat3'

     Skins(0)=Texture'kf_fx_trip_t.Gore.blood_hit_c'
     //bForceAffected=False

     mNumTileColumns = 2
     mNumTileRows = 2
     mGrowthRate = 75
     Style = STY_Alpha  //   STY_Alpha
     mRandOrient = true

     mSpeedRange(0) = 2
     mSpeedRange(1) = 4

     mMassRange(0) = .2
     mMassRange(1) = .3

     mSpinRange(0) = 50
     mSpinRange(1) = 90

     mSizeRange(0) = 1
     mSizeRange(1) = 2

//     mDirDev=(X=0,Y=15,Z=10)
     mDirDev=(X=0,Y=15,Z=10)
     mPosDev=(X=0,Y=0,Z=0)

     mLifeRange(0)= 0.3
     mLifeRange(1) = 0.5

     mMaxParticles = 2
     mStartParticles= 2

    // mPosRelative = false



//=============================================================================
// KF Blood Spray (normal shot effect)       New 3d Style Style
//=============================================================================
//             BloodDecalClass=Class'KFMod.KFBloodSplatterDecal'
//     Splats(0)=Texture'KFX.BloodSplat1'
//     Splats(1)=Texture'KFX.BloodSplat2'
//     Splats(2)=Texture'KFX.BloodSplat3'
//
//     Skins(0)=Shader'kf_fx_trip_t.Gore.blood_mesh_shd'
//     //bForceAffected=False
//
//     mParticleType=PT_Mesh
//     mAirResistance=3.000000
//     mUseMeshNodes=True
//     mRandMeshes=True
//     mMeshNodes(0)=StaticMesh'kf_gore_trip_sm.Blood.bloodsplash_1'
//     mMeshNodes(1)=StaticMesh'kf_gore_trip_sm.Blood.bloodsplash_2'
//     mMeshNodes(2)=StaticMesh'kf_gore_trip_sm.Blood.bloodsplash_3'
//
//     mNumTileColumns = 1
//     mNumTileRows = 1
////     mGrowthRate = 45
//     Style = STY_Alpha  //   STY_Alpha
////     mRandOrient = true
//     ScaleGlow=0
//
//     mSpeedRange(0) = 2
//     mSpeedRange(1) = 4
//
//     mMassRange(0) = 0
//     mMassRange(1) = 0
//
//     mSpinRange(0) = 0
//     mSpinRange(1) = 0
//
//     mSizeRange(0) = .5
//     mSizeRange(1) = .5
//
//     mDirDev=(X=0,Y=0,Z=0)
//     mPosDev=(X=0,Y=0,Z=0)
//
//     LifeSpan=1
//     mLifeRange(0)= 0.25
//     mLifeRange(1) = 0.4
//
//     mMaxParticles = 1
//     mStartParticles=1
//
//     mRandOrient=True


//         Style=STY_Alpha
//    mParticleType=PT_Sprite
//    mDirDev=(X=0.1000000,Y=0.100000,Z=0.100000)
//    mPosDev=(X=0.00000,Y=0.00000,Z=0.00000)
//    mDelayRange(0)=0.000000
//    mDelayRange(1)=0.00000
//    mLifeRange(0)=1.00000
//    mLifeRange(1)=2.000000
//    mSpeedRange(0)=0.000000
//    mSpeedRange(1)=85.000000
//    mSizeRange(0)=5.500000
//    mSizeRange(1)=9.500000
//    mMassRange(0)=0.02000
//    mMassRange(1)=0.040000
//    mGrowthRate=3.0
//    mRegenRange(0)=0.000000
//    mRegenRange(1)=0.000000
//    mRegenDist=0.000000
//    mMaxParticles=13
//    mStartParticles=13
//    DrawScale=1.000000
//    ScaleGlow=1.000000
//    mAirResistance=0.6
//    mAttenuate=True
//    mRegen=False
//    Skins(0)=none//Texture'pcl_Blooda' KFTODO: replace this texture
//    CollisionRadius=0.000000
//    CollisionHeight=0.000000
//    mColorRange(0)=(R=255,G=255,B=255,A=255)
//    mColorRange(1)=(R=255,G=255,B=255,A=255)
//    mCollision=False
//    mRandOrient=True
//    bForceAffected=False
//    mRandTextures=True
//    mNumTileColumns=4
//    mNumTileRows=4
//    bUnlit=True


}
