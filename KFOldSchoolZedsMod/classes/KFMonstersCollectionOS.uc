class KFMonstersCollection extends Object;

struct MClassTypes
{
	var() config string MClassName, MID;
};

var() globalconfig array<MClassTypes> MonsterClasses;
var()   array<MClassTypes>  StandardMonsterClasses; // The standard monster classed

// Store info for a special squad we want to spawn outside of the normal wave system
struct SpecialSquad
{
	var array<string> ZedClass;
	var array<int> NumZeds;
};

// Special squads are used to spawn a squad outside of the normal wave system so
// we have a bit more control. Basically. these will only spawn towards the
// end of the normal squad list. This way you don't end up with a bunch of really
// beast Zeds spawning one right after the other> It also guarantees that this
// squad will always get used - Ramm
var     array<SpecialSquad>     SpecialSquads;          // The currently used SpecialSquad array
var     array<SpecialSquad>     ShortSpecialSquads;     // The special squad array for a short game
var     array<SpecialSquad>     NormalSpecialSquads;    // The special squad array for a normal game
var     array<SpecialSquad>     LongSpecialSquads;      // The special squad array for a long game

var     array<SpecialSquad>     FinalSquads;            // Squads that spawn with the Patriarch

var config 	string	FallbackMonsterClass;
var() string EndGameBossClass; // class of the end game boss, moved to non config - Ramm

static function PreLoadAssets()
{
    local int i;
    for(i=0;i<default.MonsterClasses.Length;i++)
    {
         class<KFMonster>(DynamicLoadObject(default.MonsterClasses[i].MClassName, Class'class')).static.PreCacheAssets(none);
    }
}

static function string GetEventClotClassName()
{
    return default.MonsterClasses[0].MClassName;
}

static function string GetEventCrawlerClassName()
{
    return default.MonsterClasses[1].MClassName;
}

static function string GetEventGorefastClassName()
{
    return default.MonsterClasses[2].MClassName;
}

static function string GetEventStalkerClassName()
{
    return default.MonsterClasses[3].MClassName;
}

static function string GetEventScrakeClassName()
{
    return default.MonsterClasses[4].MClassName;
}

static function string GetEventFleshpoundClassName()
{
    return default.MonsterClasses[5].MClassName;
}

static function string GetEventBloatClassName()
{
    return default.MonsterClasses[6].MClassName;
}

static function string GetEventSirenClassName()
{
    return default.MonsterClasses[7].MClassName;
}

static function string GetEventHuskClassName()
{
    return default.MonsterClasses[8].MClassName;
}

defaultproperties
{
	MonsterClasses(0)=(MClassName="KFChar.ZombieClot_STANDARD",MID="A")
	MonsterClasses(1)=(MClassName="KFChar.ZombieCrawler_STANDARD",MID="B")
	MonsterClasses(2)=(MClassName="KFChar.ZombieGoreFast_STANDARD",MID="C")
	MonsterClasses(3)=(MClassName="KFChar.ZombieStalker_STANDARD",MID="D")
	MonsterClasses(4)=(MClassName="KFChar.ZombieScrake_STANDARD",MID="E")
	MonsterClasses(5)=(MClassName="KFChar.ZombieFleshpound_STANDARD",MID="F")
	MonsterClasses(6)=(MClassName="KFChar.ZombieBloat_STANDARD",MID="G")
	MonsterClasses(7)=(MClassName="KFChar.ZombieSiren_STANDARD",MID="H")
	MonsterClasses(8)=(MClassName="KFChar.ZombieHusk_STANDARD",MID="I")

	StandardMonsterClasses(0)=(MClassName="KFChar.ZombieClot_STANDARD",MID="A")
	StandardMonsterClasses(1)=(MClassName="KFChar.ZombieCrawler_STANDARD",MID="B")
	StandardMonsterClasses(2)=(MClassName="KFChar.ZombieGoreFast_STANDARD",MID="C")
	StandardMonsterClasses(3)=(MClassName="KFChar.ZombieStalker_STANDARD",MID="D")
	StandardMonsterClasses(4)=(MClassName="KFChar.ZombieScrake_STANDARD",MID="E")
	StandardMonsterClasses(5)=(MClassName="KFChar.ZombieFleshpound_STANDARD",MID="F")
	StandardMonsterClasses(6)=(MClassName="KFChar.ZombieBloat_STANDARD",MID="G")
	StandardMonsterClasses(7)=(MClassName="KFChar.ZombieSiren_STANDARD",MID="H")
	StandardMonsterClasses(8)=(MClassName="KFChar.ZombieHusk_STANDARD",MID="I")


    FinalSquads(0)=(ZedClass=("KFChar.ZombieClot_STANDARD"),NumZeds=(4))
    FinalSquads(1)=(ZedClass=("KFChar.ZombieClot_STANDARD","KFChar.ZombieCrawler_STANDARD"),NumZeds=(3,1))
    FinalSquads(2)=(ZedClass=("KFChar.ZombieClot_STANDARD","KFChar.ZombieStalker_STANDARD","KFChar.ZombieCrawler_STANDARD"),NumZeds=(3,1,1))

	ShortSpecialSquads(2)=(ZedClass=("KFChar.ZombieCrawler_STANDARD","KFChar.ZombieGorefast_STANDARD","KFChar.ZombieStalker_STANDARD","KFChar.ZombieScrake_STANDARD"),NumZeds=(2,2,1,1))
	ShortSpecialSquads(3)=(ZedClass=("KFChar.ZombieBloat_STANDARD","KFChar.ZombieSiren_STANDARD","KFChar.ZombieFleshPound_STANDARD"),NumZeds=(1,2,1))

	NormalSpecialSquads(3)=(ZedClass=("KFChar.ZombieCrawler_STANDARD","KFChar.ZombieGorefast_STANDARD","KFChar.ZombieStalker_STANDARD","KFChar.ZombieScrake_STANDARD"),NumZeds=(2,2,1,1))
	NormalSpecialSquads(4)=(ZedClass=("KFChar.ZombieFleshPound_STANDARD"),NumZeds=(1))
	NormalSpecialSquads(5)=(ZedClass=("KFChar.ZombieBloat_STANDARD","KFChar.ZombieSiren_STANDARD","KFChar.ZombieFleshPound_STANDARD"),NumZeds=(1,1,1))
	NormalSpecialSquads(6)=(ZedClass=("KFChar.ZombieBloat_STANDARD","KFChar.ZombieSiren_STANDARD","KFChar.ZombieFleshPound_STANDARD"),NumZeds=(1,1,2))

	LongSpecialSquads(4)=(ZedClass=("KFChar.ZombieCrawler_STANDARD","KFChar.ZombieGorefast_STANDARD","KFChar.ZombieStalker_STANDARD","KFChar.ZombieScrake_STANDARD"),NumZeds=(2,2,1,1))
	LongSpecialSquads(6)=(ZedClass=("KFChar.ZombieFleshPound_STANDARD"),NumZeds=(1))
	LongSpecialSquads(7)=(ZedClass=("KFChar.ZombieBloat_STANDARD","KFChar.ZombieSiren_STANDARD","KFChar.ZombieFleshPound_STANDARD"),NumZeds=(1,1,1))
	LongSpecialSquads(8)=(ZedClass=("KFChar.ZombieBloat_STANDARD","KFChar.ZombieSiren_STANDARD","KFChar.ZombieScrake_STANDARD","KFChar.ZombieFleshPound_STANDARD"),NumZeds=(1,2,1,1))
    LongSpecialSquads(9)=(ZedClass=("KFChar.ZombieBloat_STANDARD","KFChar.ZombieSiren_STANDARD","KFChar.ZombieScrake_STANDARD","KFChar.ZombieFleshPound_STANDARD"),NumZeds=(1,2,1,2))

    FallbackMonsterClass="KFChar.ZombieStalker_STANDARD"
    EndGameBossClass="KFChar.ZombieBoss_STANDARD"
}
