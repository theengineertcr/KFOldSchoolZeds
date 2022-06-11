// Piece of the head when zed's head is destroyed ✓
class KFGibHeadbOS extends KFGibOS;

defaultproperties
{
    GibGroupClass=Class'KFHumanGibGroupOS'
    TrailClassOS=Class'KFGibJetOS'
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'KillingFloorStatics.Gib2'
    DrawScale=0.500000
    Skins(0)=Texture'KillingFloorTextures.Statics.GibsSKin'
    bUnlit=false
    TransientSoundVolume=25.000000
    CollisionRadius=5.000000
    CollisionHeight=2.500000
}