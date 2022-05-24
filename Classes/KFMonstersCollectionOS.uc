class KFMonstersCollectionOS extends KFMonstersCollection;

defaultproperties
{
    MonsterClasses(0)=(MClassName="KFOldSchoolZeds.ZombieClot_OS",MID="A")
    MonsterClasses(1)=(MClassName="KFOldSchoolZeds.ZombieCrawler_OS",MID="B")
    MonsterClasses(2)=(MClassName="KFOldSchoolZeds.ZombieGoreFast_OS",MID="C")
    MonsterClasses(3)=(MClassName="KFOldSchoolZeds.ZombieStalker_OS",MID="D")
    MonsterClasses(4)=(MClassName="KFOldSchoolZeds.ZombieScrake_OS",MID="E")
    MonsterClasses(5)=(MClassName="KFOldSchoolZeds.ZombieFleshpound_OS",MID="F")
    MonsterClasses(6)=(MClassName="KFOldSchoolZeds.ZombieBloat_OS",MID="G")
    MonsterClasses(7)=(MClassName="KFOldSchoolZeds.ZombieSiren_OS",MID="H")
    MonsterClasses(8)=(MClassName="KFOldSchoolZeds.ZombieRangedPound_OS",MID="I")

    StandardMonsterClasses(0)=(MClassName="KFOldSchoolZeds.ZombieClot_OS",MID="A")
    StandardMonsterClasses(1)=(MClassName="KFOldSchoolZeds.ZombieCrawler_OS",MID="B")
    StandardMonsterClasses(2)=(MClassName="KFOldSchoolZeds.ZombieGoreFast_OS",MID="C")
    StandardMonsterClasses(3)=(MClassName="KFOldSchoolZeds.ZombieStalker_OS",MID="D")
    StandardMonsterClasses(4)=(MClassName="KFOldSchoolZeds.ZombieScrake_OS",MID="E")
    StandardMonsterClasses(5)=(MClassName="KFOldSchoolZeds.ZombieFleshpound_OS",MID="F")
    StandardMonsterClasses(6)=(MClassName="KFOldSchoolZeds.ZombieBloat_OS",MID="G")
    StandardMonsterClasses(7)=(MClassName="KFOldSchoolZeds.ZombieSiren_OS",MID="H")
    StandardMonsterClasses(8)=(MClassName="KFOldSchoolZeds.ZombieRangedPound_OS",MID="I")


    FinalSquads(0)=(ZedClass=("KFOldSchoolZeds.ZombieClot_OS"),NumZeds=(4))
    FinalSquads(1)=(ZedClass=("KFOldSchoolZeds.ZombieClot_OS","KFOldSchoolZeds.ZombieCrawler_OS"),NumZeds=(3,1))
    FinalSquads(2)=(ZedClass=("KFOldSchoolZeds.ZombieClot_OS","KFOldSchoolZeds.ZombieStalker_OS","KFOldSchoolZeds.ZombieCrawler_OS"),NumZeds=(3,1,1))

    ShortSpecialSquads(2)=(ZedClass=("KFOldSchoolZeds.ZombieCrawler_OS","KFOldSchoolZeds.ZombieGorefast_OS","KFOldSchoolZeds.ZombieStalker_OS","KFOldSchoolZeds.ZombieScrake_OS"),NumZeds=(2,2,1,1))
    ShortSpecialSquads(3)=(ZedClass=("KFOldSchoolZeds.ZombieBloat_OS","KFOldSchoolZeds.ZombieSiren_OS","KFOldSchoolZeds.ZombieFleshPound_OS"),NumZeds=(1,2,1))

    NormalSpecialSquads(3)=(ZedClass=("KFOldSchoolZeds.ZombieCrawler_OS","KFOldSchoolZeds.ZombieGorefast_OS","KFOldSchoolZeds.ZombieStalker_OS","KFOldSchoolZeds.ZombieScrake_OS"),NumZeds=(2,2,1,1))
    NormalSpecialSquads(4)=(ZedClass=("KFOldSchoolZeds.ZombieFleshPound_OS"),NumZeds=(1))
    NormalSpecialSquads(5)=(ZedClass=("KFOldSchoolZeds.ZombieBloat_OS","KFOldSchoolZeds.ZombieSiren_OS","KFOldSchoolZeds.ZombieFleshPound_OS"),NumZeds=(1,1,1))
    NormalSpecialSquads(6)=(ZedClass=("KFOldSchoolZeds.ZombieBloat_OS","KFOldSchoolZeds.ZombieSiren_OS","KFOldSchoolZeds.ZombieFleshPound_OS"),NumZeds=(1,1,2))

    LongSpecialSquads(4)=(ZedClass=("KFOldSchoolZeds.ZombieCrawler_OS","KFOldSchoolZeds.ZombieGorefast_OS","KFOldSchoolZeds.ZombieStalker_OS","KFOldSchoolZeds.ZombieScrake_OS"),NumZeds=(2,2,1,1))
    LongSpecialSquads(6)=(ZedClass=("KFOldSchoolZeds.ZombieFleshPound_OS"),NumZeds=(1))
    LongSpecialSquads(7)=(ZedClass=("KFOldSchoolZeds.ZombieBloat_OS","KFOldSchoolZeds.ZombieSiren_OS","KFOldSchoolZeds.ZombieFleshPound_OS"),NumZeds=(1,1,1))
    LongSpecialSquads(8)=(ZedClass=("KFOldSchoolZeds.ZombieBloat_OS","KFOldSchoolZeds.ZombieSiren_OS","KFOldSchoolZeds.ZombieScrake_OS","KFOldSchoolZeds.ZombieFleshPound_OS"),NumZeds=(1,2,1,1))
    LongSpecialSquads(9)=(ZedClass=("KFOldSchoolZeds.ZombieBloat_OS","KFOldSchoolZeds.ZombieSiren_OS","KFOldSchoolZeds.ZombieScrake_OS","KFOldSchoolZeds.ZombieFleshPound_OS"),NumZeds=(1,2,1,2))

    FallbackMonsterClass="KFOldSchoolZeds.ZombieStalker_OS"
    EndGameBossClass="KFOldSchoolZeds.ZombieBoss_OS"
}