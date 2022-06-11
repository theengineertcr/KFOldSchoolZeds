// Blood Splatter decal ✓
class KFBloodSplatterDecalOS extends BloodSplatterOS;

simulated function PostBeginPlay()
{
    ProjTexture = splats[Rand(3)];
    FOV = Rand(6);
    SetDrawScale((Rand(2)-0.7) + (Rand(1)+0.05));
    super.PostBeginPlay();
}

defaultproperties
{
    Splats(0)=Texture'KFOldSchoolZeds_Textures.BloodSplat1'
    Splats(1)=Texture'KFOldSchoolZeds_Textures.BloodSplat2'
    Splats(2)=Texture'KFOldSchoolZeds_Textures.BloodSplat3'
    ProjTexture=Texture'KFOldSchoolZeds_Textures.BloodSplat1'
    LifeSpan=10.000000
}