//2.5 ClotGibHead ✓
class ClotGibHeadOS extends KFGibOS;

//Usage:
//Giblet that spawns when Zed takes massive explosive damage.
simulated function PostBeginPlay()
{
    SpawnTrail();
}

defaultproperties
{
    GibGroupClass=Class'KFHumanGibGroupOS'
    TrailClassOS=Class'KFGibJetOS'
    DampenFactor=0.300000
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'KFOldSchoolStatics.ClotGibHead'
    Skins(0)=Texture'22CharTex.GibletsSkin'
    bUnlit=false
    TransientSoundVolume=25.000000
    CollisionRadius=5.000000
    CollisionHeight=2.500000
}