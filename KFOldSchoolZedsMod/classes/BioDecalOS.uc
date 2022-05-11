//KFModified BioDecal
class BioDecalOS extends ProjectedDecal;

// Load XEffects Texture Package
#exec OBJ LOAD File=KFOldSchool_XEffects.utx

simulated function BeginPlay()
{
    //Bringing this back
    if ( !Level.bDropDetail && (FRand() < 0.5) )
        ProjTexture = texture'KFOldSchool_XEffects.xbiosplat2';
    Super.BeginPlay();
}

defaultproperties
{
    LifeSpan=6
    DrawScale=+0.65
    ProjTexture=Texture'KFOldSchool_XEffects.xbiosplat'//Brought this back
    bClipStaticMesh=True
    CullDistance=+7000.0
}
