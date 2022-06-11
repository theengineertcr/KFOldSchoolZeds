// Blood Streak Decal ✓
class KFBloodStreakDecalOS extends KFBloodSplatterDecalOS;

simulated function PostBeginPlay()
{
    ProjTexture = splats[Rand(3)];
    FOV = 1;
    SetDrawScale((Rand(2)-0.6));

    super.PostBeginPlay();
}

defaultproperties
{
    Splats(0)=Texture'KFOldSchoolZeds_Textures.BloodStreak'
    Splats(1)=Texture'KFOldSchoolZeds_Textures.BloodStreak'
    Splats(2)=Texture'KFOldSchoolZeds_Textures.BloodStreak'
    PushBack=5.000000
    RandomOrient=false
    ProjTexture=Texture'KFOldSchoolZeds_Textures.BloodStreak'
}