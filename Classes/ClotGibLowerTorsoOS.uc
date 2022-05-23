// ✔

// Spawns Trail on PostBeginPlay.
class ClotGibLowerTorsoOS extends KFGibOS;

    // Load the texture and static mesh
    #exec OBJ LOAD FILE=KFOldSchoolStatics.usx
    #exec OBJ LOAD FILE=22CharTex.utx

simulated function PostBeginPlay()
{
   SpawnTrail();
}

defaultproperties
{
    // Use the KFMod GibGroup and GibJet
     GibGroupClass=class'KFHumanGibGroupOS'
     TrailClass=class'KFGibJetOS'
     DampenFactor=0.200000
     DrawType=DT_StaticMesh

     // Updated to use the 2.5 Meshes
     StaticMesh=StaticMesh'KFOldSchoolStatics.ClotGibLowerTorso'
     // This Texture never changed, so don't change it
     Skins(0)=Texture'22CharTex.GibletsSkin'
     bUnlit=false
     TransientSoundVolume=25.000000
     CollisionRadius=5.000000
     CollisionHeight=2.500000
}