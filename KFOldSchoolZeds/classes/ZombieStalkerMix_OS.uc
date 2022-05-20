//Randomized Stalker
class ZombieStalkerMix_OS extends ZombieStalker_OS;

// Load textures
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

//Cannot be local here
var material ZedSkins[10], HairSkins[3];
var int MyRand, HairRand;

//Choose a random skin!
simulated function PostBeginPlay()
{   
    MyRand = Rand(10);
    HairRand = Rand(3);
    
    ZedSkins[0] = Texture'KFOldSchoolZeds_Textures.Bloat.BloatSkin';
    ZedSkins[1] = Texture'KFOldSchoolZeds_Textures.StalkerSkin';
    ZedSkins[2] = Texture'KFOldSchoolZeds_Textures.Clot.ClotSkin';
    ZedSkins[3] = Texture'KFOldSchoolZeds_Textures.Clot.ClotSkinVariant2';
    ZedSkins[4] = Texture'KFOldSchoolZeds_Textures.Crawler.CrawlerSkin';
    ZedSkins[5] = Texture'KFOldSchoolZeds_Textures.Fleshpound.Poundskin';
    ZedSkins[6] = Texture'KFOldSchoolZeds_Textures.Gorefast.GorefastSkin';
    ZedSkins[7] = Texture'KFOldSchoolZeds_Textures.Gunpound.GunpoundSkin';
    ZedSkins[8] = Texture'KFOldSchoolZeds_Textures.Patriarch.PatriarchSkin';
    ZedSkins[9] = Texture'KFOldSchoolZeds_Textures.Siren.SirenSkin';
    
    HairSkins[0] = FinalBlend'KFOldSchoolZeds_Textures.SirenHairFB'; 
    HairSkins[1] = FinalBlend'KFOldSchoolZeds_Textures.BossHairFB';
    HairSkins[2] = FinalBlend'KFOldSchoolZeds_Textures.StalkerHairFB';
    HairSkins[3] = FinalBlend'KFOldSchoolZeds_Textures.CrawlerHairFB';
    
    super.PostBeginPlay();
}

simulated function CloakStalker()
{
    super.CloakStalker();

    if ( !bDecapitated && !bCrispified && !bCloaked) // No head, no cloak, honey.  updated :  Being charred means no cloak either :D
    {
        Skins[0] = ZedSkins[MyRand];
        Skins[1] = HairSkins[HairRand];
    }
}

simulated function UnCloakStalker()
{
    super.UnCloakStalker();
    
    if(!bCrispified)
    {
        Skins[0] = ZedSkins[MyRand];
        Skins[1] = HairSkins[HairRand];
    }
}

// Set the zed to the zapped behavior
simulated function SetZappedBehavior()
{
    super.SetZappedBehavior();

    if( Level.Netmode != NM_DedicatedServer )
    {
        Skins[0] = ZedSkins[MyRand];
        Skins[1] = HairSkins[HairRand];
    }
}

function RemoveHead()
{
    Super.RemoveHead();

    if (!bCrispified)
    {
        Skins[0] = ZedSkins[MyRand];
        Skins[1] = HairSkins[HairRand];
    }
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    Super.PlayDying(DamageType,HitLoc);
    if (!bCrispified)
    {
        Skins[0] = ZedSkins[MyRand];
        Skins[1] = HairSkins[HairRand];
    }
}

defaultproperties
{
}
