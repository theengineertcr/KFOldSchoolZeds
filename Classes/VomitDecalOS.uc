class VomitDecalOS extends ProjectedDecal;

#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

simulated function BeginPlay()
{
    if ( !Level.bDropDetail && (FRand() < 0.5) )
        ProjTexture = texture'KFOldSchoolZeds_Textures.VomSplat';
    super.BeginPlay();
}

defaultproperties
{
    ProjTexture=Texture'KFOldSchoolZeds_Textures.VomSplat'
    bClipStaticMesh=true
    CullDistance=7000.000000
    LifeSpan=5.000000
    DrawScale=0.500000
}