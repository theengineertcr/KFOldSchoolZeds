class KFMonstersCollectionOS extends KFMonstersCollection;

defaultproperties
{
    MonsterClasses(0)=(MClassName="KFOldSchoolZedsChar.ZombieClot_OS",MID="A")
    MonsterClasses(1)=(MClassName="KFOldSchoolZedsChar.ZombieCrawler_OS",MID="B")
    MonsterClasses(2)=(MClassName="KFOldSchoolZedsChar.ZombieGoreFast_OS",MID="C")
    MonsterClasses(3)=(MClassName="KFOldSchoolZedsChar.ZombieStalker_OS",MID="D")
    MonsterClasses(4)=(MClassName="KFOldSchoolZedsChar.ZombieScrake_OS",MID="E")
    MonsterClasses(5)=(MClassName="KFOldSchoolZedsChar.ZombieFleshpound_OS",MID="F")
    MonsterClasses(6)=(MClassName="KFOldSchoolZedsChar.ZombieBloat_OS",MID="G")
    MonsterClasses(7)=(MClassName="KFOldSchoolZedsChar.ZombieSiren_OS",MID="H")
    MonsterClasses(8)=(MClassName="KFOldSchoolZedsChar.ZombieRangedPound_OS",MID="I")

    StandardMonsterClasses(0)=(MClassName="KFOldSchoolZedsChar.ZombieClot_OS",MID="A")
    StandardMonsterClasses(1)=(MClassName="KFOldSchoolZedsChar.ZombieCrawler_OS",MID="B")
    StandardMonsterClasses(2)=(MClassName="KFOldSchoolZedsChar.ZombieGoreFast_OS",MID="C")
    StandardMonsterClasses(3)=(MClassName="KFOldSchoolZedsChar.ZombieStalker_OS",MID="D")
    StandardMonsterClasses(4)=(MClassName="KFOldSchoolZedsChar.ZombieScrake_OS",MID="E")
    StandardMonsterClasses(5)=(MClassName="KFOldSchoolZedsChar.ZombieFleshpound_OS",MID="F")
    StandardMonsterClasses(6)=(MClassName="KFOldSchoolZedsChar.ZombieBloat_OS",MID="G")
    StandardMonsterClasses(7)=(MClassName="KFOldSchoolZedsChar.ZombieSiren_OS",MID="H")
    StandardMonsterClasses(8)=(MClassName="KFOldSchoolZedsChar.ZombieRangedPound_OS",MID="I")


    FinalSquads(0)=(ZedClass=("KFOldSchoolZedsChar.ZombieClot_OS"),NumZeds=(4))
    FinalSquads(1)=(ZedClass=("KFOldSchoolZedsChar.ZombieClot_OS","KFOldSchoolZedsChar.ZombieCrawler_OS"),NumZeds=(3,1))
    FinalSquads(2)=(ZedClass=("KFOldSchoolZedsChar.ZombieClot_OS","KFOldSchoolZedsChar.ZombieStalker_OS","KFOldSchoolZedsChar.ZombieCrawler_OS"),NumZeds=(3,1,1))

    ShortSpecialSquads(2)=(ZedClass=("KFOldSchoolZedsChar.ZombieCrawler_OS","KFOldSchoolZedsChar.ZombieGorefast_OS","KFOldSchoolZedsChar.ZombieStalker_OS","KFOldSchoolZedsChar.ZombieScrake_OS"),NumZeds=(2,2,1,1))
    ShortSpecialSquads(3)=(ZedClass=("KFOldSchoolZedsChar.ZombieBloat_OS","KFOldSchoolZedsChar.ZombieSiren_OS","KFOldSchoolZedsChar.ZombieFleshPound_OS"),NumZeds=(1,2,1))

    NormalSpecialSquads(3)=(ZedClass=("KFOldSchoolZedsChar.ZombieCrawler_OS","KFOldSchoolZedsChar.ZombieGorefast_OS","KFOldSchoolZedsChar.ZombieStalker_OS","KFOldSchoolZedsChar.ZombieScrake_OS"),NumZeds=(2,2,1,1))
    NormalSpecialSquads(4)=(ZedClass=("KFOldSchoolZedsChar.ZombieFleshPound_OS"),NumZeds=(1))
    NormalSpecialSquads(5)=(ZedClass=("KFOldSchoolZedsChar.ZombieBloat_OS","KFOldSchoolZedsChar.ZombieSiren_OS","KFOldSchoolZedsChar.ZombieFleshPound_OS"),NumZeds=(1,1,1))
    NormalSpecialSquads(6)=(ZedClass=("KFOldSchoolZedsChar.ZombieBloat_OS","KFOldSchoolZedsChar.ZombieSiren_OS","KFOldSchoolZedsChar.ZombieFleshPound_OS"),NumZeds=(1,1,2))

    LongSpecialSquads(4)=(ZedClass=("KFOldSchoolZedsChar.ZombieCrawler_OS","KFOldSchoolZedsChar.ZombieGorefast_OS","KFOldSchoolZedsChar.ZombieStalker_OS","KFOldSchoolZedsChar.ZombieScrake_OS"),NumZeds=(2,2,1,1))
    LongSpecialSquads(6)=(ZedClass=("KFOldSchoolZedsChar.ZombieFleshPound_OS"),NumZeds=(1))
    LongSpecialSquads(7)=(ZedClass=("KFOldSchoolZedsChar.ZombieBloat_OS","KFOldSchoolZedsChar.ZombieSiren_OS","KFOldSchoolZedsChar.ZombieFleshPound_OS"),NumZeds=(1,1,1))
    LongSpecialSquads(8)=(ZedClass=("KFOldSchoolZedsChar.ZombieBloat_OS","KFOldSchoolZedsChar.ZombieSiren_OS","KFOldSchoolZedsChar.ZombieScrake_OS","KFOldSchoolZedsChar.ZombieFleshPound_OS"),NumZeds=(1,2,1,1))
    LongSpecialSquads(9)=(ZedClass=("KFOldSchoolZedsChar.ZombieBloat_OS","KFOldSchoolZedsChar.ZombieSiren_OS","KFOldSchoolZedsChar.ZombieScrake_OS","KFOldSchoolZedsChar.ZombieFleshPound_OS"),NumZeds=(1,2,1,2))

    FallbackMonsterClass="KFOldSchoolZedsChar.ZombieStalker_OS"
    EndGameBossClass="KFOldSchoolZedsChar.ZombieBoss_OS"
}
