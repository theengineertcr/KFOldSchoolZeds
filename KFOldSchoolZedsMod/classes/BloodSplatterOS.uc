// ✔
// KFMod BloodSplatter, originally found in XEffects.u
// ProjectedDecal is the Modern XScorch, so extend from that class instead
// Note: Maybe look into BloodSpurt class and further modernize the code?
class BloodSplatterOS extends ProjectedDecal;

//Load relevant texture package
#exec OBJ LOAD FILE=KFOldSchool_XEffects.utx

var texture Splats[3];

simulated function PostBeginPlay()
{
    ProjTexture = splats[Rand(3)];
    Super.PostBeginPlay();
}

defaultproperties
{
     LifeSpan=5.000000//3.000000 in Parent
     FOV=6//1.000000 in Parent	 
	 // These variables were not declared in the parent class
	 // Use Relevant Splat Textures found in KFOldSchool_XEffects
     Splats(0)=Texture'KFOldSchool_XEffects.BloodSplat1'
     Splats(1)=Texture'KFOldSchool_XEffects.BloodSplat2'
     Splats(2)=Texture'KFOldSchool_XEffects.BloodSplat3'
     ProjTexture=Texture'KFOldSchool_XEffects.BloodSplat1'
     bClipStaticMesh=True
     CullDistance=7000.000000	 
}
