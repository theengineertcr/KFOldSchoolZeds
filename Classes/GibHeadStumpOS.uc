// All gibs are supposed to be infinite, create a KFGibOS
// In future if you really want them to be infinite,
// class is exactly the same, so could just add
// Lifespan = 0 for this if I really wanted to

// Spawns Trail on PostBeginPlay.
class GibHeadStumpOS extends KFGibOS;

// Load the texture and static mesh
#exec OBJ LOAD FILE=22Patch.usx
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
     DampenFactor=0.300000
     DrawType=DT_StaticMesh

     // This Mesh never changed, so don't change it
     StaticMesh=StaticMesh'22Patch.Severed_Head'
     RemoteRole=ROLE_SimulatedProxy
     NetUpdateFrequency=10.000000
     LifeSpan=9999.000000
     DrawScale=0.600000
     // This Texture never changed, so don't change it
     Skins(0)=Texture'22CharTex.SeveredSkin'
     bUnlit=false
     TransientSoundVolume=25.000000
     CollisionRadius=5.000000
     CollisionHeight=2.500000
}