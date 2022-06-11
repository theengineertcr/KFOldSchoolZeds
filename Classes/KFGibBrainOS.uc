// Piece of the brain when zed's head is destroyed ✓
class KFGibBrainOS extends KFGibOS;

defaultproperties
{
    GibGroupClass=Class'KFHumanGibGroupOS'
    TrailClassOS=Class'KFGibJetOS'
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'KillingFloorStatics.Gib1'
    LifeSpan=6.000000
    DrawScale=0.300000
    Skins(0)=Texture'KillingFloorTextures.Statics.GibsSKin'
    bUnlit=false
    TransientSoundVolume=25.000000
    CollisionRadius=5.000000
    CollisionHeight=2.500000
}