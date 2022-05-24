//Randomized Patty
class ZombieBossMix_OS extends ZombieBoss_OS;

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

    Skins[2] = ZedSkins[MyRand];
    Skins[0] = HairSkins[HairRand];

    super.PostBeginPlay();
}

simulated function UnCloakBoss()
{
    super.UnCloakBoss();

    Skins[2] = ZedSkins[MyRand];
    Skins[0] = HairSkins[HairRand];
}

// Set the zed to the zapped behavior
simulated function SetZappedBehavior()
{
    super.SetZappedBehavior();

    if( Level.Netmode != NM_DedicatedServer )
    {
        Skins[2] = ZedSkins[MyRand];
        Skins[0] = HairSkins[HairRand];
    }
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    super.PlayDying(DamageType,HitLoc);

    Skins[2] = ZedSkins[MyRand];
    Skins[0] = HairSkins[HairRand];
}

defaultproperties{}