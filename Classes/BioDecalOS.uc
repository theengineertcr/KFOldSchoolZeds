class BioDecalOS extends ProjectedDecal;

#exec OBJ LOAD File=KFOldSchool_XEffects.utx

simulated function BeginPlay()
{
    if ( !Level.bDropDetail && (FRand() < 0.5) )
    {
        ProjTexture = texture'KFOldSchool_XEffects.xbiosplat2';
    }
    
    super.BeginPlay();
}

defaultproperties
{
    LifeSpan=6
    DrawScale=+0.65
    ProjTexture=Texture'KFOldSchool_XEffects.xbiosplat'
    bClipStaticMesh=true
    CullDistance=+7000.0
}