// Mutator that replaces zeds with their 2.5 counterpart
// GitHub: https://github.com/theengineertcr/KFOldSchoolZeds
class KF25OSMut extends Mutator
    config(KF25OSMut);

// We've taken this code from CssHDMut:
// https://github.com/InsultingPros/CsHDMut/blob/02a0cdd2b79de8e1c7ea26f12370b115c038e542/sources/CsHDMut.uc#L20

//config vars
var config bool bEnableRandomSkins;
var config bool bEnableRangedPound;
var config bool bEnableExplosivesPound;
//var config bool bEnableCorpseDecay;
//var config bool bEnableOldHealth;
//var config bool bEnableOldSpeed;
var config bool bEnableOldMeleeDamage;
//var config bool bEnableOldGorefastChargeSpeed;
//var config bool bEnableOldFleshpoundChargeSpeed;
//var config bool bEnableOldCrawlerBehaviour;
//var config bool bEnableOldScrakeBehavior;
//var config bool bEnableOldFleshpoundBehavior;
//var config bool bEnableOldHeadshotBehaviour;
//var config bool bEnableNoHealthScaling;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFPatch2.utx
#exec OBJ LOAD FILE=KillingFloorLabTextures.utx
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx
#exec OBJ LOAD FILE=KFBossOld.ukx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KF_M79Snd.uax

//=======================================
//          PostBeginPlay
//=======================================

event PostBeginPlay()
{
    local int i;
    local KFGameType KF;

    super.PostBeginPlay();

    KF = KFGameType(Level.Game);

    if (KF == none)
    {
        log("KFGameType not found, terminating!", self.name);
        Destroy();
        return;
    }

    if (KF.MonsterCollection == class'KFGameType'.default.MonsterCollection && !bEnableRandomSkins)
    {
        KF.MonsterCollection = class'KFMonstersCollectionOS';
    }

    for (i = 0; i < KF.SpecialEventMonsterCollections.Length; i++)
    {
        KF.SpecialEventMonsterCollections[i] = KF.MonsterCollection;
    }

    if(bEnableExplosivesPound   &&  KF.MonsterCollection.default.MonsterClasses[8].MClassName != "" || 
       bEnableRangedPound       &&  KF.MonsterCollection.default.MonsterClasses[8].MClassName != "")
    {
        KF.MonsterCollection.default.MonsterClasses[8].MClassName = string(class'ZombieRangedPoundOS');

        if( !bEnableRangedPound && bEnableExplosivesPound)
        {
            KF.MonsterCollection.default.MonsterClasses[8].MClassName = string(class'ZombieExplosivesPoundOS');
        }
    }
    else
        KF.MonsterCollection.default.MonsterClasses[8].MClassName = "";

    SetTimer(0.10, false);
}

simulated function Timer()
{
    super(Actor).Timer();
}

//=======================================
//          Mutator Info
//=======================================

static function FillPlayInfo(PlayInfo PlayInfo)
{
  super(Info).FillPlayInfo(PlayInfo);

  //TODO: Make it so you can't have both Ranged & Explosive pound enabled at same time? Is that even possible?
  PlayInfo.AddSetting(default.FriendlyName, "bEnableRangedPound", "Fleshpound Chaingunner", 0, 0, "Check",,,,true);
  PlayInfo.AddSetting(default.FriendlyName, "bEnableExplosivesPound", "Fleshpound Explosives Gunner", 0, 0, "Check",,,,true);
  //PlayInfo.AddSetting(default.FriendlyName, "bEnableRandomSkins", "Randomized Skins", 0, 0, "Check",,,,true);
  PlayInfo.AddSetting(default.FriendlyName, "bEnableOldMeleeDamage", "Old Melee Damage", 0, 0, "Check",,,,true);
}


static event string GetDescriptionText(string Property)
{
  switch (Property)
  {
    case "bEnableRangedPound":
      return "Enables the Fleshpound Chaingunner";
    case "bEnableExplosivesPound":
      return "Enables the Fleshpound Explosives Gunner";
    case "bEnableRandomSkins":
        return "Zeds use random skins";
    case "bEnableOldMeleeDamage":
        return "Zeds use 2.5 Melee damage";
    default:
      return super(Info).GetDescriptionText(Property);
  }
}

//This is potentially useless?
static simulated function PreCacheMaterials(LevelInfo myLevel)
{
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Clot.ClotSkin');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Gorefast.GorefastSkin');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Bloat.BloatSkin');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Crawler.CrawlerSkin');
    myLevel.AddPrecacheMaterial(Shader'KFOldSchoolZeds_Textures.StalkerHairShader');
    myLevel.AddPrecacheMaterial(Shader'KFOldSchoolZeds_Textures.StalkerCloakShader');
    myLevel.AddPrecacheMaterial(Finalblend 'KFOldSchoolZeds_Textures.StalkerGlowFB');
    myLevel.AddPrecacheMaterial(Material'KFOldSchoolZeds_Textures.StalkerDeCloakfb');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.StalkerSkin');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Siren.SirenSkin');
    myLevel.AddPrecacheMaterial(FinalBlend 'KFOldSchoolZeds_Textures.StalkerHairFB');
    myLevel.AddPrecacheMaterial(FinalBlend'KFOldSchoolZeds_Textures.Siren.SirenHairFB');
    myLevel.AddPrecacheMaterial(FinalBlend'KFOldSchoolZeds_Textures.Crawler.CrawlerHairFB');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.GunPound.AutoTurretGunTex');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.GunPound.GunPoundSkin');
    myLevel.AddPrecacheMaterial(FinalBlend'KFOldSchoolZeds_Textures.Fleshpound.RedPoundMeter');
    myLevel.AddPrecacheMaterial(FinalBlend'KFOldSchoolZeds_Textures.Fleshpound.AmberPoundMeter');
    myLevel.AddPrecacheMaterial(Shader'KFOldSchoolZeds_Textures.Fleshpound.FPDeviceBloomRedShader');
    myLevel.AddPrecacheMaterial(Shader'KFOldSchoolZeds_Textures.Fleshpound.FPDeviceBloomAmberShader');
    myLevel.AddPrecacheMaterial(Shader'KFOldSchoolZeds_Textures.Fleshpound.PoundBitsShader');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Fleshpound.PoundSkin');
    myLevel.AddPrecacheMaterial(FinalBlend'KFPatch2.BossHairFB');
    myLevel.AddPrecacheMaterial(FinalBlend'KFOldSchoolZeds_Textures.Patriarch.BossCloakFizzleFB');
    myLevel.AddPrecacheMaterial(Finalblend'KFOldSchoolZeds_Textures.Patriarch.BossGlowFB');
    myLevel.AddPrecacheMaterial(Texture'KFPatch2.BossBits');
    myLevel.AddPrecacheMaterial(Texture'KFPatch2.GunPoundSkin');
    myLevel.AddPrecacheMaterial(Texture'KFPatch2.BossGun');
    myLevel.AddPrecacheMaterial(Texture'KillingFloorLabTextures.LabCommon.voidtex');
    myLevel.AddPrecacheMaterial(Shader'KFPatch2.LaserShader');
    myLevel.AddPrecacheMaterial(Shader'KFOldSchoolZeds_Textures.BossCloakShader');
}

//=======================================
//          DefaultProperties
//=======================================

defaultproperties
{
    // Don't be active with TWI muts
    GroupName="KF-MonsterMut"
    FriendlyName="KFMod 2.5 Zeds"
    Description="Replaces zeds with their 2.5 counter-parts."

    bAlwaysRelevant=true
    RemoteRole=ROLE_SimulatedProxy
    bAddToServerPackages=true

    bEnableRangedPound=true
    bEnableExplosivesPound=false
    bEnableRandomSkins=false
    bEnableOldMeleeDamage=false
}