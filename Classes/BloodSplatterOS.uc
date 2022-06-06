//2.5 BloodSplatter Decal ✓
class BloodSplatterOS extends ProjectedDecal;

//Usage:
//Blood Decals for when zed corpse impacts the floor
#exec OBJ LOAD FILE=KFOldSchool_XEffects.utx
#exec OBJ LOAD File=KFOldSchoolZeds_Textures.utx

var texture Splats[3];

simulated function PostBeginPlay()
{
    ProjTexture = splats[Rand(3)];

    super.PostBeginPlay();
}

defaultproperties
{
    LifeSpan=5.000000  //3.000000
    FOV=6  //1.000000
    Splats(0)=Texture'KFOldSchool_XEffects.BloodSplat1'
    Splats(1)=Texture'KFOldSchool_XEffects.BloodSplat2'
    Splats(2)=Texture'KFOldSchool_XEffects.BloodSplat3'
    ProjTexture=Texture'KFOldSchool_XEffects.BloodSplat1'
    bClipStaticMesh=true
    CullDistance=7000.000000
}