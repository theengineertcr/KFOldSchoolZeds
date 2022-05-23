// Mutator that replaces zeds with their 2.5 counterpart
// GitHub: https://github.com/theengineertcr/KFOldSchoolZeds
class KF25OSMut extends Mutator
    config(KF25OSMut);


// We've taken this code from CssHDMut:
// https://github.com/InsultingPros/CsHDMut/blob/02a0cdd2b79de8e1c7ea26f12370b115c038e542/sources/CsHDMut.uc#L20


//Do we want Ranged pounds or gunners in our game?
var config bool bEnableRangedPound;
var config bool bEnableExplosivesPound;

//Enable Random Zed skins?
var config bool bEnableRandomSkins;

//Use KFMod 2.5 Melee Damage?
var config bool bEnableOldMeleeDamage;

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
    local string Pounds[2];
    local string PoundsMix[2];
    local int MyRand;
    local KFMonsterOS KFMOS;
    
    super.PostBeginPlay();
    
    //This BS doesn't work because I can't classify KFMos as a (Pawn) without erroring
    //KFMOS = KFMonsterOS(Pawn);
    KF = KFGameType(Level.Game);
    if (KF == none)
    {
      log("KFGameType not found, terminating!", self.name);
      Destroy();
      return;
    }

    // change vanilla monster collection
    if (KF.MonsterCollection == class'KFGameType'.default.MonsterCollection && !bEnableRandomSkins)
    {
      KF.MonsterCollection = class'KFMonstersCollectionOS';
    }
    else if(bEnableRandomSkins)
    {
        KF.MonsterCollection = class'KFMonstersCollectionMixOS';
    }

    // shut down default event system
    for (i = 0; i < KF.SpecialEventMonsterCollections.Length; i++)
    {
        KF.SpecialEventMonsterCollections[i] = KF.MonsterCollection;
    }    
    
    Pounds[0] = string(class'ZombieRangedPound_OS');
    Pounds[1] = string(class'ZombieRangedPoundGL_OS');
    
    PoundsMix[0] = string(class'ZombieRangedPoundMix_OS');
    PoundsMix[1] = string(class'ZombieRangedPoundGLMix_OS');
    
    MyRand = Rand(2);    
    
    //If enabled, spawn Ranged Pounds in place of Husks
    //Otherwise, replace them with Bloats
    if(bEnableRangedPound && KF.MonsterCollection.default.MonsterClasses[8].MClassName != "" || bEnableExplosivesPound && KF.MonsterCollection.default.MonsterClasses[8].MClassName != "")
    {
        if(!bEnableRandomSkins)
        {        
            KF.MonsterCollection.default.MonsterClasses[8].MClassName = Pounds[MyRand];
        }
        else
        {
            KF.MonsterCollection.default.MonsterClasses[8].MClassName = PoundsMix[MyRand];
        }     
      
        if(!bEnableExplosivesPound && bEnableRangedPound)
        {
            if(!bEnableRandomSkins)
                KF.MonsterCollection.default.MonsterClasses[8].MClassName = string(class'ZombieRangedPound_OS');
            else
                KF.MonsterCollection.default.MonsterClasses[8].MClassName = string(class'ZombieRangedPoundMix_OS');
        }
        else if( !bEnableRangedPound && bEnableExplosivesPound)
        {
            if(!bEnableRandomSkins)
                KF.MonsterCollection.default.MonsterClasses[8].MClassName = string(class'ZombieRangedPoundGL_OS');
            else
                KF.MonsterCollection.default.MonsterClasses[8].MClassName = string(class'ZombieRangedPoundGLMix_OS');
        }    
    }
    else
    {
        KF.MonsterCollection.default.MonsterClasses[8].MClassName = string(class'ZombieBloat_OS');
    }
   

    // start the timer
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
  
  //TODO: Make it so you can't have both of these checked at the same time
  PlayInfo.AddSetting(default.FriendlyName, "bEnableRangedPound", "Fleshpound Chaingunner", 0, 0, "Check",,,,true);
  PlayInfo.AddSetting(default.FriendlyName, "bEnableExplosivesPound", "Fleshpound Explosives Gunner", 0, 0, "Check",,,,true);
  PlayInfo.AddSetting(default.FriendlyName, "bEnableRandomSkins", "Randomized Skins", 0, 0, "Check",,,,true);
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


//Precache KFMod textures
static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
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
    // Don't be active with other muts
    GroupName="KF-MonsterMut"
    FriendlyName="KFMod 2.5 Zeds"
    Description="Replaces zeds with their 2.5 counter-parts."

    bAlwaysRelevant=true
    RemoteRole=ROLE_SimulatedProxy
    bAddToServerPackages=True

    bEnableRangedPound=True
    bEnableExplosivesPound=False
    bEnableRandomSkins=False
    bEnableOldMeleeDamage=False
}