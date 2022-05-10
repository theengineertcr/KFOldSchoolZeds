// Spawns Trail on PostBeginPlay.

class GibHeadStump extends KFGib;

simulated function PostBeginPlay()
{
   SpawnTrail();
}

defaultproperties
{
     GibGroupClass=Class'KFMod.KFHumanGibGroup'
     TrailClass=Class'ROEffects.BloodTrail'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'22Patch.Severed_Head'
     DrawScale=0.6
     Skins(0)=Texture'22CharTex.SeveredSkin'
     bUnlit=False
     TransientSoundVolume=25.000000
     CollisionRadius=5.000000
     CollisionHeight=2.500000

     DampenFactor=0.300000
     Mass=280.000000
     LifeSpan=9999

     RemoteRole=ROLE_SimulatedProxy
     NetUpdateFrequency=10
     bNotOnDedServer = false
}
