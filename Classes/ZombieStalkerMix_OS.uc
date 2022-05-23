//Randomized Stalker
class ZombieStalkerMix_OS extends ZombieStalker_OS;

// Load textures
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

var private material MixSkin, MixHair;

//Choose a random skin!
simulated function PostBeginPlay()
{
    MixSkin = MixTexturePool[rand(MixTexturePool.Length)];
    MixHair = MixHairPool[rand(MixHairPool.Length)];

    Skins[0] = MixSkin;
    Skins[1] = MixHair;

    super.PostBeginPlay();
}

simulated function CloakStalker()
{
    super.CloakStalker();

    if ( !bDecapitated && !bCrispified && !bCloaked) // No head, no cloak, honey.  updated :  Being charred means no cloak either :D
    {
        Skins[0] = MixSkin;
        Skins[1] = MixHair;
    }
}

simulated function UnCloakStalker()
{
    super.UnCloakStalker();

    if(!bCrispified)
    {
        Skins[0] = MixSkin;
        Skins[1] = MixHair;
    }
}

// Set the zed to the zapped behavior
simulated function SetZappedBehavior()
{
    super.SetZappedBehavior();

    if( Level.Netmode != NM_DedicatedServer )
    {
        Skins[0] = MixSkin;
        Skins[1] = MixHair;
    }
}

function RemoveHead()
{
    super.RemoveHead();

    if (!bCrispified)
    {
        Skins[0] = MixSkin;
        Skins[1] = MixHair;
    }
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    super.PlayDying(DamageType,HitLoc);
    if (!bCrispified)
    {
        Skins[0] = MixSkin;
        Skins[1] = MixHair;
    }
}

defaultproperties{}