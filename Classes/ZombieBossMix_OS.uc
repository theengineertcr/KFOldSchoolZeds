//Randomized Patty
class ZombieBossMix_OS extends ZombieBoss_OS;

// Load textures
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

var private material MixSkin, MixHair;

//Choose a random skin!
simulated function PostBeginPlay()
{
    MixSkin = MixTexturePool[rand(MixTexturePool.Length)];
    MixHair = MixHairPool[rand(MixHairPool.Length)];

    Skins[2] = MixSkin;
    Skins[0] = MixHair;

    super.PostBeginPlay();
}

simulated function UnCloakBoss()
{
    super.UnCloakBoss();

    Skins[2] = MixSkin;
    Skins[0] = MixHair;
}

// Set the zed to the zapped behavior
simulated function SetZappedBehavior()
{
    super.SetZappedBehavior();

    if( Level.Netmode != NM_DedicatedServer )
    {
        Skins[2] = MixSkin;
        Skins[0] = MixHair;
    }
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    super.PlayDying(DamageType,HitLoc);

    Skins[2] = MixSkin;
    Skins[0] = MixHair;
}

defaultproperties{}