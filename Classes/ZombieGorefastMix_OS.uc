//Randomized Gorefast
class ZombieGorefastMix_OS extends ZombieGorefast_OS;

// Load textures
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

//Choose a random skin!
simulated function PostBeginPlay()
{
    Skins[0] = MixTexturePool[rand(MixTexturePool.Length)];

    super.PostBeginPlay();
}

defaultproperties{}