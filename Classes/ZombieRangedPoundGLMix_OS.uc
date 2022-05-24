//Randomized Demolitions Pound
class ZombieRangedPoundGLMix_OS extends ZombieRangedPoundGL_OS;

// Load textures
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

//Choose a random skin!
simulated function PostBeginPlay()
{
    Skins[2] = MixTexturePool[rand(MixTexturePool.Length)];

    super.PostBeginPlay();
}

defaultproperties{}