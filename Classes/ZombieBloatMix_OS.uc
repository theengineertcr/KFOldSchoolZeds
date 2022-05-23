//Randomized Bloat
class ZombieBloatMix_OS extends ZombieBloat_OS;

// Load textures
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

//Choose a random skin!
simulated function PostBeginPlay()
{
    Skins[0] = MixTexturePool[rand(MixTexturePool.Length)];

    super.PostBeginPlay();
}

defaultproperties{}