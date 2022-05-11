//Gametype that uses old zeds
class KFGameTypeOS extends KFGameType
    config;


defaultproperties
{
    //Use 2.5 monster classes
    MonsterClasses(0)=(MClassName="KFOldSchoolZedsChar.ZombieClot_OS",MID="A")
    MonsterClasses(1)=(MClassName="KFOldSchoolZedsChar.ZombieCrawler_OS",MID="B")
    MonsterClasses(2)=(MClassName="KFOldSchoolZedsChar.ZombieGoreFast_OS",MID="C")
    MonsterClasses(3)=(MClassName="KFOldSchoolZedsChar.ZombieStalker_OS",MID="D")
    MonsterClasses(4)=(MClassName="KFOldSchoolZedsChar.ZombieScrake_OS",MID="E")
    MonsterClasses(5)=(MClassName="KFOldSchoolZedsChar.ZombieFleshpound_OS",MID="F")
    MonsterClasses(6)=(MClassName="KFOldSchoolZedsChar.ZombieBloat_OS",MID="G")
    MonsterClasses(7)=(MClassName="KFOldSchoolZedsChar.ZombieSiren_OS",MID="H")
    MonsterClasses(8)=(MClassName="KFOldSchoolZedsChar.ZombieRangedPound_OS",MID="I")
    
    FallbackMonsterClass="KFOldSchoolZedsChar.ZombieStalker_OS"

    //Since were going to implement the rest of the zeds, let's name 
    //The gametype by the zeds versions instead of calling it "old"
    GameName="Killing Floor 2.5"

    //2.5 Monster class collection and bosses
    MonsterCollection = class'KFMonstersCollectionOS'
    EndGameBossClass="KFOldSchoolZedsChar.ZombieBoss_OS"

    //Override to use our KFMonstersCollection
    //As the default, Otherwise, they won't spawn. 
    //Additionally, replace the events ones as well
    //Until we get the rest of the old zeds in(?)
    SpecialEventMonsterCollections(0)=class'KFMonstersCollectionOS'
    SpecialEventMonsterCollections(1)=class'KFMonstersCollectionOS'
    SpecialEventMonsterCollections(2)=class'KFMonstersCollectionOS'
    SpecialEventMonsterCollections(3)=class'KFMonstersCollectionOS'
}

