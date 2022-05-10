// Spawns Trail on PostBeginPlay.

class ClotGibArm extends KFGib;

simulated function PostBeginPlay()
{
   SpawnTrail();
}

defaultproperties
{
     GibGroupClass=Class'KFMod.KFHumanGibGroup'
     TrailClass=Class'ROEffects.BloodTrail'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'22Patch.ClotGibArm'
     DrawScale=1
     Skins(0)=Texture'22CharTex.GibletsSkin'
     bUnlit=False
     TransientSoundVolume=25.000000
     CollisionRadius=5.000000
     CollisionHeight=2.500000

     DampenFactor=0.2500000
     Mass=280.000000
}
