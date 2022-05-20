class KFMonstersCollectionMixOS extends KFMonstersCollection;

defaultproperties
{
    MonsterClasses(0)=(MClassName="KFOldSchoolZedsChar.ZombieClotMix_OS",MID="A")
    MonsterClasses(1)=(MClassName="KFOldSchoolZedsChar.ZombieCrawlerMix_OS",MID="B")
    MonsterClasses(2)=(MClassName="KFOldSchoolZedsChar.ZombieGoreFastMix_OS",MID="C")
    MonsterClasses(3)=(MClassName="KFOldSchoolZedsChar.ZombieStalkerMix_OS",MID="D")
    MonsterClasses(4)=(MClassName="KFOldSchoolZedsChar.ZombieScrakeMix_OS",MID="E")
    MonsterClasses(5)=(MClassName="KFOldSchoolZedsChar.ZombieFleshpoundMix_OS",MID="F")
    MonsterClasses(6)=(MClassName="KFOldSchoolZedsChar.ZombieBloatMix_OS",MID="G")
    MonsterClasses(7)=(MClassName="KFOldSchoolZedsChar.ZombieSirenMix_OS",MID="H")
    MonsterClasses(8)=(MClassName="KFOldSchoolZedsChar.ZombieRangedPoundMix_OS",MID="I")

    StandardMonsterClasses(0)=(MClassName="KFOldSchoolZedsChar.ZombieClotMix_OS",MID="A")
    StandardMonsterClasses(1)=(MClassName="KFOldSchoolZedsChar.ZombieCrawlerMix_OS",MID="B")
    StandardMonsterClasses(2)=(MClassName="KFOldSchoolZedsChar.ZombieGoreFastMix_OS",MID="C")
    StandardMonsterClasses(3)=(MClassName="KFOldSchoolZedsChar.ZombieStalkerMix_OS",MID="D")
    StandardMonsterClasses(4)=(MClassName="KFOldSchoolZedsChar.ZombieScrakeMix_OS",MID="E")
    StandardMonsterClasses(5)=(MClassName="KFOldSchoolZedsChar.ZombieFleshpoundMix_OS",MID="F")
    StandardMonsterClasses(6)=(MClassName="KFOldSchoolZedsChar.ZombieBloatMix_OS",MID="G")
    StandardMonsterClasses(7)=(MClassName="KFOldSchoolZedsChar.ZombieSirenMix_OS",MID="H")
    StandardMonsterClasses(8)=(MClassName="KFOldSchoolZedsChar.ZombieRangedPoundMix_OS",MID="I")


    FinalSquads(0)=(ZedClass=("KFOldSchoolZedsChar.ZombieClotMix_OS"),NumZeds=(4))
    FinalSquads(1)=(ZedClass=("KFOldSchoolZedsChar.ZombieClotMix_OS","KFOldSchoolZedsChar.ZombieCrawlerMix_OS"),NumZeds=(3,1))
    FinalSquads(2)=(ZedClass=("KFOldSchoolZedsChar.ZombieClotMix_OS","KFOldSchoolZedsChar.ZombieStalkerMix_OS","KFOldSchoolZedsChar.ZombieCrawlerMix_OS"),NumZeds=(3,1,1))

    ShortSpecialSquads(2)=(ZedClass=("KFOldSchoolZedsChar.ZombieCrawlerMix_OS","KFOldSchoolZedsChar.ZombieGorefastMix_OS","KFOldSchoolZedsChar.ZombieStalkerMix_OS","KFOldSchoolZedsChar.ZombieScrakeMix_OS"),NumZeds=(2,2,1,1))
    ShortSpecialSquads(3)=(ZedClass=("KFOldSchoolZedsChar.ZombieBloatMix_OS","KFOldSchoolZedsChar.ZombieSirenMix_OS","KFOldSchoolZedsChar.ZombieFleshPoundMix_OS"),NumZeds=(1,2,1))

    NormalSpecialSquads(3)=(ZedClass=("KFOldSchoolZedsChar.ZombieCrawlerMix_OS","KFOldSchoolZedsChar.ZombieGorefastMix_OS","KFOldSchoolZedsChar.ZombieStalkerMix_OS","KFOldSchoolZedsChar.ZombieScrakeMix_OS"),NumZeds=(2,2,1,1))
    NormalSpecialSquads(4)=(ZedClass=("KFOldSchoolZedsChar.ZombieFleshPoundMix_OS"),NumZeds=(1))
    NormalSpecialSquads(5)=(ZedClass=("KFOldSchoolZedsChar.ZombieBloatMix_OS","KFOldSchoolZedsChar.ZombieSirenMix_OS","KFOldSchoolZedsChar.ZombieFleshPoundMix_OS"),NumZeds=(1,1,1))
    NormalSpecialSquads(6)=(ZedClass=("KFOldSchoolZedsChar.ZombieBloatMix_OS","KFOldSchoolZedsChar.ZombieSirenMix_OS","KFOldSchoolZedsChar.ZombieFleshPoundMix_OS"),NumZeds=(1,1,2))

    LongSpecialSquads(4)=(ZedClass=("KFOldSchoolZedsChar.ZombieCrawlerMix_OS","KFOldSchoolZedsChar.ZombieGorefastMix_OS","KFOldSchoolZedsChar.ZombieStalkerMix_OS","KFOldSchoolZedsChar.ZombieScrakeMix_OS"),NumZeds=(2,2,1,1))
    LongSpecialSquads(6)=(ZedClass=("KFOldSchoolZedsChar.ZombieFleshPoundMix_OS"),NumZeds=(1))
    LongSpecialSquads(7)=(ZedClass=("KFOldSchoolZedsChar.ZombieBloatMix_OS","KFOldSchoolZedsChar.ZombieSirenMix_OS","KFOldSchoolZedsChar.ZombieFleshPoundMix_OS"),NumZeds=(1,1,1))
    LongSpecialSquads(8)=(ZedClass=("KFOldSchoolZedsChar.ZombieBloatMix_OS","KFOldSchoolZedsChar.ZombieSirenMix_OS","KFOldSchoolZedsChar.ZombieScrakeMix_OS","KFOldSchoolZedsChar.ZombieFleshPoundMix_OS"),NumZeds=(1,2,1,1))
    LongSpecialSquads(9)=(ZedClass=("KFOldSchoolZedsChar.ZombieBloatMix_OS","KFOldSchoolZedsChar.ZombieSirenMix_OS","KFOldSchoolZedsChar.ZombieScrakeMix_OS","KFOldSchoolZedsChar.ZombieFleshPoundMix_OS"),NumZeds=(1,2,1,2))

    FallbackMonsterClass="KFOldSchoolZedsChar.ZombieStalkerMix_OS"
    EndGameBossClass="KFOldSchoolZedsChar.ZombieBossMix_OS"
}
