// KFMod GibBrain is similar to retail with some minor differences
class KFGibBrainOS extends KFGibOS;

    //Load necessary meshes and textures
    #exec OBJ LOAD FILE=KillingFloorStatics.usx
    #exec OBJ LOAD FILE=KillingFloorTextures.utx

defaultproperties
{
    // Use the KFMod GibGroup and GibJet
     GibGroupClass=Class'KFHumanGibGroupOS'
     TrailClass=Class'KFGibJetOS'     
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'KillingFloorStatics.Gib1'     
     LifeSpan=6.000000
     DrawScale=0.300000
     Skins(0)=Texture'KillingFloorTextures.Statics.GibsSKin'
     bUnlit=False
     TransientSoundVolume=25.000000
     CollisionRadius=5.000000
     CollisionHeight=2.500000
}
