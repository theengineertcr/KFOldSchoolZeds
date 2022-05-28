class KFGibBrainOS extends KFGib;

defaultproperties
{
    //Temp until Old Blood gets fixed
    GibGroupClass=Class'KFMod.KFHumanGibGroup'
    TrailClass=Class'ROEffects.BloodTrail'
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