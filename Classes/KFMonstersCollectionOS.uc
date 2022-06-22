class KFMonstersCollectionOS extends KFMonstersCollection;

defaultproperties
{
    MonsterClasses(0)=(MClassName="KFOldSchoolZeds.ZombieClotOS",MID="A")
    MonsterClasses(1)=(MClassName="KFOldSchoolZeds.ZombieCrawlerOS",MID="B")
    MonsterClasses(2)=(MClassName="KFOldSchoolZeds.ZombieGoreFastOS",MID="C")
    MonsterClasses(3)=(MClassName="KFOldSchoolZeds.ZombieStalkerOS",MID="D")
    MonsterClasses(4)=(MClassName="KFOldSchoolZeds.ZombieScrakeOS",MID="E")
    MonsterClasses(5)=(MClassName="KFOldSchoolZeds.ZombieFleshpoundOS",MID="F")
    MonsterClasses(6)=(MClassName="KFOldSchoolZeds.ZombieBloatOS",MID="G")
    MonsterClasses(7)=(MClassName="KFOldSchoolZeds.ZombieSirenOS",MID="H")
    MonsterClasses(8)=(MClassName="KFOldSchoolZeds.ZombieRangedPoundOS",MID="I")
    MonsterClasses(9)=(MClassName="KFOldSchoolZeds.ZombieExplosivesPoundOS",MID="J")

    StandardMonsterClasses(0)=(MClassName="KFOldSchoolZeds.ZombieClotOS",MID="A")
    StandardMonsterClasses(1)=(MClassName="KFOldSchoolZeds.ZombieCrawlerOS",MID="B")
    StandardMonsterClasses(2)=(MClassName="KFOldSchoolZeds.ZombieGoreFastOS",MID="C")
    StandardMonsterClasses(3)=(MClassName="KFOldSchoolZeds.ZombieStalkerOS",MID="D")
    StandardMonsterClasses(4)=(MClassName="KFOldSchoolZeds.ZombieScrakeOS",MID="E")
    StandardMonsterClasses(5)=(MClassName="KFOldSchoolZeds.ZombieFleshpoundOS",MID="F")
    StandardMonsterClasses(6)=(MClassName="KFOldSchoolZeds.ZombieBloatOS",MID="G")
    StandardMonsterClasses(7)=(MClassName="KFOldSchoolZeds.ZombieSirenOS",MID="H")
    StandardMonsterClasses(8)=(MClassName="KFOldSchoolZeds.ZombieRangedPoundOS",MID="I")
    StandardMonsterClasses(9)=(MClassName="KFOldSchoolZeds.ZombieExplosivesPoundOS",MID="J")


    FinalSquads(0)=(ZedClass=("KFOldSchoolZeds.ZombieClotOS"),NumZeds=(4))
    FinalSquads(1)=(ZedClass=("KFOldSchoolZeds.ZombieClotOS","KFOldSchoolZeds.ZombieCrawlerOS"),NumZeds=(3,1))
    FinalSquads(2)=(ZedClass=("KFOldSchoolZeds.ZombieClotOS","KFOldSchoolZeds.ZombieStalkerOS","KFOldSchoolZeds.ZombieCrawlerOS"),NumZeds=(3,1,1))

    ShortSpecialSquads(2)=(ZedClass=("KFOldSchoolZeds.ZombieCrawlerOS","KFOldSchoolZeds.ZombieGorefastOS","KFOldSchoolZeds.ZombieStalkerOS","KFOldSchoolZeds.ZombieScrakeOS"),NumZeds=(2,2,1,1))
    ShortSpecialSquads(3)=(ZedClass=("KFOldSchoolZeds.ZombieBloatOS","KFOldSchoolZeds.ZombieSirenOS","KFOldSchoolZeds.ZombieFleshPoundOS"),NumZeds=(1,2,1))

    NormalSpecialSquads(3)=(ZedClass=("KFOldSchoolZeds.ZombieCrawlerOS","KFOldSchoolZeds.ZombieGorefastOS","KFOldSchoolZeds.ZombieStalkerOS","KFOldSchoolZeds.ZombieScrakeOS"),NumZeds=(2,2,1,1))
    NormalSpecialSquads(4)=(ZedClass=("KFOldSchoolZeds.ZombieFleshPoundOS"),NumZeds=(1))
    NormalSpecialSquads(5)=(ZedClass=("KFOldSchoolZeds.ZombieBloatOS","KFOldSchoolZeds.ZombieSirenOS","KFOldSchoolZeds.ZombieFleshPoundOS"),NumZeds=(1,1,1))
    NormalSpecialSquads(6)=(ZedClass=("KFOldSchoolZeds.ZombieBloatOS","KFOldSchoolZeds.ZombieSirenOS","KFOldSchoolZeds.ZombieFleshPoundOS"),NumZeds=(1,1,2))

    LongSpecialSquads(4)=(ZedClass=("KFOldSchoolZeds.ZombieCrawlerOS","KFOldSchoolZeds.ZombieGorefastOS","KFOldSchoolZeds.ZombieStalkerOS","KFOldSchoolZeds.ZombieScrakeOS"),NumZeds=(2,2,1,1))
    LongSpecialSquads(6)=(ZedClass=("KFOldSchoolZeds.ZombieFleshPoundOS"),NumZeds=(1))
    LongSpecialSquads(7)=(ZedClass=("KFOldSchoolZeds.ZombieBloatOS","KFOldSchoolZeds.ZombieSirenOS","KFOldSchoolZeds.ZombieFleshPoundOS"),NumZeds=(1,1,1))
    LongSpecialSquads(8)=(ZedClass=("KFOldSchoolZeds.ZombieBloatOS","KFOldSchoolZeds.ZombieSirenOS","KFOldSchoolZeds.ZombieScrakeOS","KFOldSchoolZeds.ZombieFleshPoundOS"),NumZeds=(1,2,1,1))
    LongSpecialSquads(9)=(ZedClass=("KFOldSchoolZeds.ZombieBloatOS","KFOldSchoolZeds.ZombieSirenOS","KFOldSchoolZeds.ZombieScrakeOS","KFOldSchoolZeds.ZombieFleshPoundOS"),NumZeds=(1,2,1,2))

    FallbackMonsterClass="KFOldSchoolZeds.ZombieStalkerOS"
    EndGameBossClass="KFOldSchoolZeds.ZombieBossOS"
}