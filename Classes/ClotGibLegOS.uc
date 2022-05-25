class ClotGibLegOS extends KFGibOS;

simulated function PostBeginPlay()
{
   SpawnTrail();
}

defaultproperties
{
     GibGroupClass=class'KFHumanGibGroupOS'
     TrailClass=class'KFGibJetOS'
     DampenFactor=0.250000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'KFOldSchoolStatics.ClotGibLeg'
     Skins(0)=Texture'22CharTex.GibletsSkin'
     bUnlit=false
     TransientSoundVolume=25.000000
     CollisionRadius=5.000000
     CollisionHeight=2.500000
}