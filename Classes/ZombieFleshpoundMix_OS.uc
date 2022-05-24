//Randomized Fleshpound
class ZombieFleshpoundMix_OS extends ZombieFleshpound_OS;

// Load textures
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

//Choose a random skin!
simulated function PostBeginPlay()
{
    Skins[3] = MixTexturePool[rand(MixTexturePool.Length)];

    super.PostBeginPlay();
}

defaultproperties{}