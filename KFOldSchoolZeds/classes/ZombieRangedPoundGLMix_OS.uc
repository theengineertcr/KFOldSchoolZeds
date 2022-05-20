//Randomized Demolitions Pound
class ZombieRangedPoundGLMix_OS extends ZombieRangedPoundGL_OS;

// Load textures
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

//Choose a random skin!
simulated function PostBeginPlay()
{
    local material ZedSkins[10];
    local int MyRand;
    
    MyRand = Rand(10);
    
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
    
    Skins[2] = ZedSkins[MyRand];
    
    super.PostBeginPlay();
}

defaultproperties
{
}
