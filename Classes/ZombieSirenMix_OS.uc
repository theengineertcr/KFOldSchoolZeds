//Randomized Siren
class ZombieSirenMix_OS extends ZombieSiren_OS;

// Load textures
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

//Choose a random skin!
simulated function PostBeginPlay()
{
    Skins[0] = MixTexturePool[rand(MixTexturePool.Length)];
    Skins[1] = MixHairPool[rand(MixHairPool.Length)];

    super.PostBeginPlay();
}

defaultproperties{}