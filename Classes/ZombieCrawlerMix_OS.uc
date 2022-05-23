//Randomized Crawler
class ZombieCrawlerMix_OS extends ZombieCrawler_OS;

// Load textures
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

//Choose a random skin!
simulated function PostBeginPlay()
{
    local material ZedSkins[10];
    local material HairSkins[3];
    local int MyRand;
    local int HairRand;

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

    Skins[0] = ZedSkins[MyRand];
    Skins[1] = HairSkins[HairRand];

    super.PostBeginPlay();
}

defaultproperties{}