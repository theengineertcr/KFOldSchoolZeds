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

var config bool bEnableRangedPound;                 // Fleshpound Chaingunners replace Husks
var config bool bDisableIncendiaryRounds;           // Fleshpound Chaingunner does not use incendiary rounds
var config bool bDisableIncendiaryResistance;       // Fleshpound Chaingunner no longer has resistance to burned damagetype
var config bool bEnableExplosivesPound;             // Explosive Fleshpound Gunners spawn alongside Fleshpounds
var config bool bNerfEP;                            // Explosive Pound is nerfed.
var config bool bEnableOldBloatPuke;                // Bloat uses 2.5 puke behavior
var config bool bEnableOldCrawlerBehaviour;         // Crawler uses 2.5 leaping behavior
var config bool bEnableSirenNadeBoom;               // Swaps Siren Scream Damage type, causing explosives to explode
var config bool bEnableOldScrakeBehavior;           // Use 2.5 Scrake behavior: No rage charging.
var config bool bEnableOldFleshpoundBehavior;       // Use 2.5 Fleshpound behavior: No LoS rage and 10 second long rage.
//var config bool bEnableOldHeadshotBehavior;         // Use 2.5 Headshot behavior. No head health/bleedout. Damage Vs. Health / HealthMax * Multiplier determines if big zed loses head.
//var config bool bDisableHealthScaling;              // Disables Health Scaling, similar to the mod version of the game
var config bool bEnableRandomSkins;                 // Zeds use a random skin from other zeds

var private array< class<KFMonsterOS> > ZedList;
var bool bShowHeadHitbox;

const STEAMID1="76561198044316328";     // nikc
const STEAMID2="76561197993557589";     // bofa

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

    if (KF.MonsterCollection == class'KFGameType'.default.MonsterCollection)
    {
        KF.MonsterCollection = class'KFMonstersCollectionOS';
    }

    for (i = 0; i < KF.SpecialEventMonsterCollections.Length; i++)
    {
        KF.SpecialEventMonsterCollections[i] = KF.MonsterCollection;
    }

    if(bEnableRangedPound && KF.MonsterCollection.default.MonsterClasses[8].MClassName != "")
    {
        if(bEnableRangedPound)
            KF.MonsterCollection.default.MonsterClasses[8].MClassName = string(class'ZombieRangedPoundOS');
    }
    else
        KF.MonsterCollection.default.MonsterClasses[8].MClassName = "";

    if(bEnableExplosivesPound)
    {
        // Replace 2/3 Scrake Squad Spawns(temporary)
        // He's supposed to be as rare as a Fleshpound, but
        // This is fine for now. People will learn to fear him :)
        KF.StandardMonsterSquads[13]="2A1J";
        KF.MonsterSquad[13]="2A1J";
        KF.StandardMonsterSquads[14]="2A3C1J";
        KF.MonsterSquad[14]="2A3C1J";

        if(bNerfEP)
        {
            class'ZombieExplosivesPoundOS'.default.bNerfed = true;
            class'GunnerGLProjectile'.default.bNerfed = true;
        }
    }

    if(bEnableSirenNadeBoom)
        class'ZombieSirenOS'.default.bEnableSirenNadeBoom = true;

    if(bEnableOldScrakeBehavior)
        class'ZombieScrakeOS'.default.bEnableOldScrakeBehavior = true;

    if(bEnableOldCrawlerBehaviour)
        class'ControllerCrawlerOS'.default.bEnableOldCrawlerBehaviour = true;

    if(bEnableOldFleshpoundBehavior)
    {
        class'ZombieFleshPoundOS'.default.bEnableOldFleshpoundBehavior = true;
        class'ControllerFleshpoundOS'.default.bEnableOldFleshpoundBehavior = true;
    }

    if(bEnableOldBloatPuke)
        class'ZombieBloatOS'.default.bEnableOldBloatPuke = true;

    if(bDisableIncendiaryRounds)
        class'ZombieRangedPoundOS'.default.bDisableIncendiaryRounds = true;

    if(bDisableIncendiaryResistance)
        class'ZombieRangedPoundOS'.default.bDisableIncendiaryResistance = true;
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
    local Interaction KFOSInt;

    PC = Level.GetLocalPlayerController();
    if (PC != None)
    {
        KFOSInt = PC.Player.InteractionMaster.AddInteraction(string(class'KFOSInteraction'), PC.Player);
        KFOSInteraction(KFOSInt).Mut = Self;
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
    local string steamid;

    // don't break the chain!
    super.Mutate(MutateString, Sender);

    steamid = Sender.GetPlayerIDHash();
    if (steamid ~= STEAMID1 || steamid ~= STEAMID2)
    {
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

    //PlayInfo.AddSetting(default.FriendlyName, "bEnableCorpseDecay", "Corpses Decay", 0, 0, "Check",,,,true);
    PlayInfo.AddSetting(default.FriendlyName, "bEnableRangedPound", "Fleshpound Chaingunner", 0, 0, "Check",,,,false);
    PlayInfo.AddSetting(default.FriendlyName, "bEnableExplosivesPound", "Fleshpound Explosives Gunner", 0, 0, "Check",,,,false);
    PlayInfo.AddSetting(default.FriendlyName, "bNerfEP", "Fleshpound Explosives Gunner Nerf", 0, 0, "Check",,,,false);
    PlayInfo.AddSetting(default.FriendlyName, "bEnableOldBloatPuke", "Old Bloat Puke", 0, 0, "Check",,,,true);
    PlayInfo.AddSetting(default.FriendlyName, "bEnableOldCrawlerBehaviour", "Old Crawler Leap", 0, 0, "Check",,,,true);
    PlayInfo.AddSetting(default.FriendlyName, "bEnableSirenNadeBoom", "Old Siren Scream", 0, 0, "Check",,,,true);
    PlayInfo.AddSetting(default.FriendlyName, "bEnableOldScrakeBehavior", "Old Scrake Behavior", 0, 0, "Check",,,,true);
    PlayInfo.AddSetting(default.FriendlyName, "bEnableOldFleshpoundBehavior", "Old Fleshpound Rage", 0, 0, "Check",,,,true);
    PlayInfo.AddSetting(default.FriendlyName, "bDisableIncendiaryRounds", "Fleshpound Chaingunner - Disable Incendiary rounds", 0, 0, "Check",,,,false);
    PlayInfo.AddSetting(default.FriendlyName, "bDisableIncendiaryResistance", "Fleshpound Chaingunner - Disable Fire Resistance", 0, 0, "Check",,,,false);
    //PlayInfo.AddSetting(default.FriendlyName, "bEnableOldHeadshotBehavior", "Old Headshot System", 0, 0, "Check",,,,true);
    //PlayInfo.AddSetting(default.FriendlyName, "bDisableHealthScaling", "Disable Health Scaling", 0, 0, "Check",,,,true);
    //TODO: Implement this properly
    //PlayInfo.AddSetting(default.FriendlyName, "bEnableRandomSkins", "Mixed skins", 0, 0, "Check",,,,true);
}


static event string GetDescriptionText(string Property)
{
  switch (Property)
  {
    case "bEnableRangedPound":
      return "Enables the Fleshpound Chaingunner";
    case "bEnableExplosivesPound":
      return "Enables the Fleshpound Explosives Gunner";
    case "bNerfEP":
        return "Makes the Explosives Gunner more fair. Must be enabled with Explosives Pound.";
    case "bEnableOldBloatPuke":
        return "Bloat uses 2.5 puke behavior and effects.";
    case "bEnableOldCrawlerBehaviour":
        return "Crawler uses 2.5 leaping behavior";
    case "bEnableSirenNadeBoom":
        return "Use 2.5 Siren Behavior: Sirens scream blows up explosives.";
    case "bEnableOldScrakeBehavior":
        return "Use 2.5 Scrake behavior: No more rage state.";
    case "bEnableOldFleshpoundBehavior":
        return "Use 2.5 Fleshpound behavior: No LoS rage and 10 second rage duration.";
    case "bDisableIncendiaryRounds":
        return "Fleshpound Chaingunner does not fire incendiary rounds";
    case "bDisableIncendiaryResistance":
        return "Fleshpound Chaingunner does not resist fire damage";
    //case "bEnableOldHeadshotBehavior":
    //    return "Use 2.5 Headshot behavior. No head health/bleedout.";
    //case "bDisableHealthScaling":
    //    return "Zed health values does not scale with player count.";
    //case "bEnableRandomSkins":
    //    return "Zeds use random skins";
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
    bDisableIncendiaryRounds=false
    bDisableIncendiaryResistance=false
    bEnableExplosivesPound=false
    bNerfEP=false
    bEnableOldBloatPuke=false
    bEnableOldCrawlerBehaviour=false
    bEnableSirenNadeBoom=false
    bEnableOldScrakeBehavior=false
    bEnableOldFleshpoundBehavior=false
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