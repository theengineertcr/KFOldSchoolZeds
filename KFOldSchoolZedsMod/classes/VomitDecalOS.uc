//Old KFMod puke decal
class VomitDecalOS extends ProjectedDecal;

// Load relevant texture package
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

simulated function BeginPlay()
{
    if ( !Level.bDropDetail && (FRand() < 0.5) ) //Use KFMod Texture
        ProjTexture = texture'KFOldSchoolZeds_Textures.VomSplat';
    Super.BeginPlay();
}

defaultproperties
{
    //Use KFMod Texture
     ProjTexture=Texture'KFOldSchoolZeds_Textures.VomSplat'
     bClipStaticMesh=True
     CullDistance=7000.000000
     LifeSpan=5.000000
     DrawScale=0.500000
}
