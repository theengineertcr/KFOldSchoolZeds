// Mutator that replaces zeds with their 2.5 counterpart
// GitHub: https://github.com/theengineertcr/KFOldSchoolZeds
class KF25OSMut extends Mutator
    config(KFOldSchoolZeds);

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFPatch2.utx
#exec OBJ LOAD FILE=KillingFloorLabTextures.utx
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx
#exec OBJ LOAD FILE=KFBossOld.ukx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KF_M79Snd.uax

// We've taken this code from CssHDMut:
// https://github.com/InsultingPros/CsHDMut/blob/02a0cdd2b79de8e1c7ea26f12370b115c038e542/sources/CsHDMut.uc#L20

//config vars
//var config bool bEnableRandomSkins;
var config bool bEnableRangedPound;
var config bool bEnableExplosivesPound;
//var config bool bEnableCorpseDecay;
//var config bool bEnableOldZedHealth;
//var config bool bEnableOldZedSpeed;
//var config bool bEnableOldZedMeleeDamage;
//var config bool bEnableOldGorefastChargeSpeed;
//var config bool bEnableOldFleshpoundChargeSpeed;
//var config bool bEnableOldCrawlerBehaviour;
//var config bool bEnableOldScrakeBehavior;
//var config bool bEnableOldFleshpoundBehavior;
//var config bool bEnableOldHeadshotBehaviour;
//var config bool bEnableNoHealthScaling;

var private array< class<KFMonsterOS> > ZedList;
var bool bShowHeadHitbox;

replication
{
    reliable if (Role == ROLE_Authority)
        bShowHeadHitbox;
}

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

    if (KF.MonsterCollection == class'KFGameType'.default.MonsterCollection/* && !bEnableRandomSkins*/)
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
        if(!bEnableExplosivesPound && bEnableRangedPound)
        {
            KF.MonsterCollection.default.MonsterClasses[8].MClassName = string(class'ZombieRangedPoundOS');
        }
        else if( !bEnableRangedPound && bEnableExplosivesPound)
        {
            KF.MonsterCollection.default.MonsterClasses[8].MClassName = string(class'ZombieExplosivesPoundOS');
        }
    }
    else
        KF.MonsterCollection.default.MonsterClasses[8].MClassName = "";
}

// precache materials
function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    // catch the PRI, most likely player is 'alive' at this point
    if (PlayerReplicationInfo(Other) != none)
    {
        PreCacheMaterials(PlayerController(PlayerReplicationInfo(other).owner));
    }

    return super.CheckReplacement(Other, bSuperRelevant);
}

// parse zed list and load their assets to avoid lags on their first appearance
final private function PreCacheMaterials(PlayerController pc)
{
    local int i;

    // just in case
    if (Level.NetMode != NM_DedicatedServer || pc == none)
        return;

    for (i = 0; i < ZedList.length; i++)
    {
        ZedList[i].static.PreCacheMaterials(Level);
    }
}

// add our interaction
simulated function Tick(float DeltaTime)
{
    local PlayerController PC;
    local KFOSInteraction KFOSInt;

    PC = Level.GetLocalPlayerController();
    if (PC != None)
    {
        KFOSInt = PC.Player.InteractionMaster.AddInteraction(string(class'KFOSInteraction'), PC.Player);
        KFOSInt.Mut = Self;
    }
    Disable('Tick');
}

// fancy, colored Mutate system
function Mutate(string MutateString, PlayerController Sender)
{
    local int i;
    local array<String> wordsArray;
    local String command, mod;
    local array<String> modArray;

    // don't break the chain!
    super.Mutate(MutateString, Sender);

    // ignore empty cmds and dont go further
    Split(MutateString, " ", wordsArray);
    if (wordsArray.Length == 0)
        return;

    // do stuff with our cmd
    command = wordsArray[0];
    if (wordsArray.Length > 1)
        mod = wordsArray[1];
    else
        mod = "";

    while (i + 1 < wordsArray.Length || i < 10)
    {
        if (i + 1 < wordsArray.Length)
        modArray[i] = wordsArray[i+1];
        else
        modArray[i] = "";
        i ++;
    }

    if (command ~= "HELP" || command ~= "HALP" || command ~= "HLP")
    {
        SendMessage(Sender, "^r^OLD SCHOOL ZEDS MUT HELPER");
        SendMessage(Sender, "^w^=============================");
        SendMessage(Sender, "^w^Available commands:");
        SendMessage(Sender, "^b^HEAD | HEADS | HITZONE | HEADZONE ^y^<ON / OFF> ^w^- toggle head hitbox rendering.");
    }
    // toggle head hitbox rendering
    else if (command ~= "HEAD" || command ~= "HEADS" || command ~= "HITZONE" || command ~= "HEADZONE")
    {
        if (mod ~= "ON")
        {
            bShowHeadHitbox = true;
            BroadcastText(getSenderName(Sender) $ " ^g^enabled ^w^zeds ^r^HEADZONE ^w^rendering!");
            return;
        }
        else if (mod ~= "OFF")
        {
            bShowHeadHitbox = false;
            BroadcastText(getSenderName(Sender) $ " ^g^disabled ^w^zeds ^r^HEADZONE ^w^rendering!");
            return;
        }
    }
}


//============================== BROADCASTING ==============================
// reference: https://github.com/InsultingPros/FakedPlus/blob/main/Classes/FakedPlus.uc

// send message to exact player
function SendMessage(PlayerController pc, coerce string message)
{
    if (pc == none || message == "")
        return;

    // clear all tags for WebAdmin
    if (pc.playerReplicationInfo.PlayerName ~= "WebAdmin" && pc.PlayerReplicationInfo.PlayerID == 0)
        message = class'Utility'.static.StriptTagsStatic(message);
    // create colors!
    else
        message = class'Utility'.static.ParseTagsStatic(message);

    pc.teamMessage(none, message, 'OldSchoolZeds');
}


// send message to everyone and save to server log file
function BroadcastText(string message, optional bool bSaveToLog)
{
    local Controller c;

    for (c = level.controllerList; c != none; c = c.nextController)
    {
        if (c.IsA('PlayerController'))
            SendMessage(PlayerController(c), message);
    }

    if (bSaveToLog)
    {
        // remove color tags for server log
        message = class'Utility'.static.StriptTagsStatic(message);
        log(">>> KF25OSMut: " $ message);
    }
}

final private function string getSenderName(PlayerController Sender)
{
    local PlayerReplicationInfo pri;
    local string s;

    pri = Sender.PlayerReplicationInfo;

    if (pri == none)
        s = "Someone";
    else
        s = pri.PlayerName;

    return "^w^[^b^" $ s $ " ^w^executed] ";
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
  //PlayInfo.AddSetting(default.FriendlyName, "bEnableOldZedMeleeDamage", "Old Melee Damage", 0, 0, "Check",,,,true);
}


static event string GetDescriptionText(string Property)
{
  switch (Property)
  {
    case "bEnableRangedPound":
      return "Enables the Fleshpound Chaingunner";
    case "bEnableExplosivesPound":
      return "Enables the Fleshpound Explosives Gunner";
    //case "bEnableRandomSkins":
    //    return "Zeds use random skins";
    //case "bEnableOldZedMeleeDamage":
    //    return "Zeds use 2.5 Melee damage";
    default:
      return super(Info).GetDescriptionText(Property);
  }
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
    //bEnableRandomSkins=false
    //bEnableOldZedMeleeDamage=false

    ZedList(00)=class'ZombieBloatOS'
    ZedList(01)=class'ZombieBossOS'
    ZedList(02)=class'ZombieClotOS'
    ZedList(03)=class'ZombieCrawlerOS'
    ZedList(04)=class'ZombieExplosivesPoundOS'
    ZedList(05)=class'ZombieFleshPoundOS'
    ZedList(06)=class'ZombieGorefastOS'
    ZedList(07)=class'ZombieRangedPoundOS'
    ZedList(08)=class'ZombieScrakeOS'
    ZedList(09)=class'ZombieSirenOS'
    ZedList(10)=class'ZombieStalkerOS'
}