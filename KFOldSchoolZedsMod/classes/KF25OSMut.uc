//Mutator that replaces zeds with their 2.5 counterpart
class KF25OSMut extends Mutator
    config(KF25OSMut);


//We've taken this code from CssHDMut
//Credits to Shtoyan for the source!


//Do we want Ranged pounds or gunners in our game?
var config bool bEnableRangedPound;
var config bool bEnableGunnerPound;
var config bool bEnableRandomSkins;

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
    
    //If enabled, spawn Ranged Pounds in place of Husks
    //Otherwise, replace them with Bloats
    if(bEnableRangedPound && KF.MonsterCollection.default.MonsterClasses[8].MClassName != "")
    {
        KF.MonsterCollection.default.MonsterClasses[8].MClassName = "KFOldSchoolZedsChar.ZombieRangedPound_OS";
    }
    else if(bEnableRandomSkins)
    {
        KF.MonsterCollection.default.MonsterClasses[8].MClassName = "KFOldSchoolZedsChar.ZombieRangedPoundMix_OS";
    }    
    else
    {
        KF.MonsterCollection.default.MonsterClasses[8].MClassName = "KFOldSchoolZedsChar.ZombieBloat_OS";
    }
    
    //If enabled, spawn Explosive gunners in place of Husks
    //Otherwise, replace them with Bloats    
    if(bEnableGunnerPound && KF.MonsterCollection.default.MonsterClasses[8].MClassName != "")
    {
        KF.MonsterCollection.default.MonsterClasses[8].MClassName = "KFOldSchoolZedsChar.ZombieRangedPoundGL_OS";
    }
    else if(bEnableRandomSkins)
    {
        KF.MonsterCollection.default.MonsterClasses[8].MClassName = "KFOldSchoolZedsChar.ZombieRangedPoundGLMix_OS";
    }
    else
    {
        KF.MonsterCollection.default.MonsterClasses[8].MClassName = "KFOldSchoolZedsChar.ZombieBloat_OS";
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
  PlayInfo.AddSetting(default.FriendlyName, "bEnableGunnerPound", "Fleshpound Explosives Gunner", 0, 0, "Check",,,,true);
  PlayInfo.AddSetting(default.FriendlyName, "bEnableRandomSkins", "Randomized Skins", 0, 0, "Check",,,,true);  
}


static event string GetDescriptionText(string Property)
{
  switch (Property)
  {
    case "bEnableRangedPound":
      return "Enables the Fleshpound Chaingunner";
    case "bEnableGunnerPound":
      return "Enables the Fleshpound Explosives Gunner";
    case "bEnableRandomSkins":
    return "Zeds use random skins";
    default:
      return super(Info).GetDescriptionText(Property);
  }
}

//=======================================
//          DefaultProperties
//=======================================

defaultproperties
{
    //Don't be active with other muts
    GroupName="KF-MonsterMut"
    FriendlyName="KFMod 2.5 Zeds"
    Description="Replaces zeds with their 2.5 counter-parts."
    bAlwaysRelevant=true
    RemoteRole=ROLE_SimulatedProxy
    bAddToServerPackages=True
    bEnableRangedPound=True
    bEnableGunnerPound=False
}
