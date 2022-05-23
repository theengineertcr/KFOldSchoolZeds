// Chunky bits of flesh
class KFGibHeadOS extends KFGibOS;

//Load necessary meshes and textures
#exec OBJ LOAD FILE=KillingFloorStatics.usx
#exec OBJ LOAD FILE=KillingFloorTextures.utx

defaultproperties
{
     // Use the KFMod version of KFHumanGibGroup & GibJet
     GibGroupClass=class'KFHumanGibGroupOS'
     TrailClass=class'KFGibJetOS'
     DrawType=DT_StaticMesh
     // Same model as in KFMod, no need to change
     StaticMesh=StaticMesh'KillingFloorStatics.Gib1'
     DrawScale=0.500000
     // Same Texture as in KFMod, no need to change
     Skins(0)=Texture'KillingFloorTextures.Statics.GibsSKin'
     bUnlit=false
     TransientSoundVolume=25.000000
     CollisionRadius=5.000000
     CollisionHeight=2.500000
}