class KFMonstersCollectionMixOS extends KFMonstersCollection;

defaultproperties
{
    MonsterClasses(0)=(MClassName="KFOldSchoolZeds.ZombieClotMix_OS",MID="A")
    MonsterClasses(1)=(MClassName="KFOldSchoolZeds.ZombieCrawlerMix_OS",MID="B")
    MonsterClasses(2)=(MClassName="KFOldSchoolZeds.ZombieGoreFastMix_OS",MID="C")
    MonsterClasses(3)=(MClassName="KFOldSchoolZeds.ZombieStalkerMix_OS",MID="D")
    MonsterClasses(4)=(MClassName="KFOldSchoolZeds.ZombieScrakeMix_OS",MID="E")
    MonsterClasses(5)=(MClassName="KFOldSchoolZeds.ZombieFleshpoundMix_OS",MID="F")
    MonsterClasses(6)=(MClassName="KFOldSchoolZeds.ZombieBloatMix_OS",MID="G")
    MonsterClasses(7)=(MClassName="KFOldSchoolZeds.ZombieSirenMix_OS",MID="H")
    MonsterClasses(8)=(MClassName="KFOldSchoolZeds.ZombieRangedPoundMix_OS",MID="I")

    StandardMonsterClasses(0)=(MClassName="KFOldSchoolZeds.ZombieClotMix_OS",MID="A")
    StandardMonsterClasses(1)=(MClassName="KFOldSchoolZeds.ZombieCrawlerMix_OS",MID="B")
    StandardMonsterClasses(2)=(MClassName="KFOldSchoolZeds.ZombieGoreFastMix_OS",MID="C")
    StandardMonsterClasses(3)=(MClassName="KFOldSchoolZeds.ZombieStalkerMix_OS",MID="D")
    StandardMonsterClasses(4)=(MClassName="KFOldSchoolZeds.ZombieScrakeMix_OS",MID="E")
    StandardMonsterClasses(5)=(MClassName="KFOldSchoolZeds.ZombieFleshpoundMix_OS",MID="F")
    StandardMonsterClasses(6)=(MClassName="KFOldSchoolZeds.ZombieBloatMix_OS",MID="G")
    StandardMonsterClasses(7)=(MClassName="KFOldSchoolZeds.ZombieSirenMix_OS",MID="H")
    StandardMonsterClasses(8)=(MClassName="KFOldSchoolZeds.ZombieRangedPoundMix_OS",MID="I")


    FinalSquads(0)=(ZedClass=("KFOldSchoolZeds.ZombieClotMix_OS"),NumZeds=(4))
    FinalSquads(1)=(ZedClass=("KFOldSchoolZeds.ZombieClotMix_OS","KFOldSchoolZeds.ZombieCrawlerMix_OS"),NumZeds=(3,1))
    FinalSquads(2)=(ZedClass=("KFOldSchoolZeds.ZombieClotMix_OS","KFOldSchoolZeds.ZombieStalkerMix_OS","KFOldSchoolZeds.ZombieCrawlerMix_OS"),NumZeds=(3,1,1))

    ShortSpecialSquads(2)=(ZedClass=("KFOldSchoolZeds.ZombieCrawlerMix_OS","KFOldSchoolZeds.ZombieGorefastMix_OS","KFOldSchoolZeds.ZombieStalkerMix_OS","KFOldSchoolZeds.ZombieScrakeMix_OS"),NumZeds=(2,2,1,1))
    ShortSpecialSquads(3)=(ZedClass=("KFOldSchoolZeds.ZombieBloatMix_OS","KFOldSchoolZeds.ZombieSirenMix_OS","KFOldSchoolZeds.ZombieFleshPoundMix_OS"),NumZeds=(1,2,1))

    NormalSpecialSquads(3)=(ZedClass=("KFOldSchoolZeds.ZombieCrawlerMix_OS","KFOldSchoolZeds.ZombieGorefastMix_OS","KFOldSchoolZeds.ZombieStalkerMix_OS","KFOldSchoolZeds.ZombieScrakeMix_OS"),NumZeds=(2,2,1,1))
    NormalSpecialSquads(4)=(ZedClass=("KFOldSchoolZeds.ZombieFleshPoundMix_OS"),NumZeds=(1))
    NormalSpecialSquads(5)=(ZedClass=("KFOldSchoolZeds.ZombieBloatMix_OS","KFOldSchoolZeds.ZombieSirenMix_OS","KFOldSchoolZeds.ZombieFleshPoundMix_OS"),NumZeds=(1,1,1))
    NormalSpecialSquads(6)=(ZedClass=("KFOldSchoolZeds.ZombieBloatMix_OS","KFOldSchoolZeds.ZombieSirenMix_OS","KFOldSchoolZeds.ZombieFleshPoundMix_OS"),NumZeds=(1,1,2))

    LongSpecialSquads(4)=(ZedClass=("KFOldSchoolZeds.ZombieCrawlerMix_OS","KFOldSchoolZeds.ZombieGorefastMix_OS","KFOldSchoolZeds.ZombieStalkerMix_OS","KFOldSchoolZeds.ZombieScrakeMix_OS"),NumZeds=(2,2,1,1))
    LongSpecialSquads(6)=(ZedClass=("KFOldSchoolZeds.ZombieFleshPoundMix_OS"),NumZeds=(1))
    LongSpecialSquads(7)=(ZedClass=("KFOldSchoolZeds.ZombieBloatMix_OS","KFOldSchoolZeds.ZombieSirenMix_OS","KFOldSchoolZeds.ZombieFleshPoundMix_OS"),NumZeds=(1,1,1))
    LongSpecialSquads(8)=(ZedClass=("KFOldSchoolZeds.ZombieBloatMix_OS","KFOldSchoolZeds.ZombieSirenMix_OS","KFOldSchoolZeds.ZombieScrakeMix_OS","KFOldSchoolZeds.ZombieFleshPoundMix_OS"),NumZeds=(1,2,1,1))
    LongSpecialSquads(9)=(ZedClass=("KFOldSchoolZeds.ZombieBloatMix_OS","KFOldSchoolZeds.ZombieSirenMix_OS","KFOldSchoolZeds.ZombieScrakeMix_OS","KFOldSchoolZeds.ZombieFleshPoundMix_OS"),NumZeds=(1,2,1,2))

    FallbackMonsterClass="KFOldSchoolZeds.ZombieStalkerMix_OS"
    EndGameBossClass="KFOldSchoolZeds.ZombieBossMix_OS"
}
