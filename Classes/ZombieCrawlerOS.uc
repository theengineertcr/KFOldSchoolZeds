class ZombieCrawlerOS extends KFMonsterOS;

var() float PounceSpeed;
var bool bPouncing;

simulated function ZombieCrispUp()
{
    super.ZombieCrispUp();

    Skins[1]=default.Skins[1];
}

function bool DoPounce()
{
    if ( bZapped || bIsCrouched || bWantsToCrouch || (Physics != PHYS_Walking) || VSize(Location - Controller.Target.Location) > (MeleeRange * 5) )
        return false;

    Velocity = Normal(Controller.Target.Location-Location)*PounceSpeed;
    Velocity.Z = JumpZ;
    SetPhysics(PHYS_Falling);
    ZombieSpringAnim();
    bPouncing=true;
    return true;
}

simulated function ZombieSpringAnim()
{
    SetAnimAction('ZombieSpring');
}

event Landed(vector HitNormal)
{
    bPouncing=false;
    super.Landed(HitNormal);
}

event Bump(actor Other)
{
    if(bPouncing && KFHumanPawn(Other)!=none )
    {
        KFHumanPawn(Other).TakeDamage(((MeleeDamage - (MeleeDamage * 0.05)) + (MeleeDamage * (FRand() * 0.1))), self ,self.Location,self.velocity, class 'KFmod.ZombieMeleeDamage');

        if (KFHumanPawn(Other).Health <=0)
            KFHumanPawn(Other).SpawnGibs(self.rotation, 1);
        bPouncing=false;
    }
}

simulated event SetAnimAction(name NewAction)
{
    super.SetAnimAction(NewAction);

    if ( AnimAction == 'ZombieLeapAttack' || AnimAction == 'LeapAttack3' || AnimAction == 'ZombieLeapAttack')
    {
      AnimBlendParams(1, 1.0, 0.0,, 'Bip01 Spine1');
      PlayAnim(NewAction,, 0.0, 1);
    }
}

function bool FlipOver()
{
    return false;
}


static simulated function PreCacheMaterials(LevelInfo myLevel)
{
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Crawler.CrawlerSkin');
    myLevel.AddPrecacheMaterial(FinalBlend'KFOldSchoolZeds_Textures.Crawler.CrawlerHairFB');
}

defaultproperties
{
    Mesh=SkeletalMesh'KFCharacterModelsOldSchool.Shade'
    Skins(0)=Texture'KFOldSchoolZeds_Textures.Crawler.CrawlerSkin'
    Skins(1)=FinalBlend'KFOldSchoolZeds_Textures.Crawler.CrawlerHairFB'
    AmbientSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieBreath'
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Crawler.Crawler_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieJump'
    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieDeath'
    ZombieFlag=2
    bDoTorsoTwist=false
    bCannibal = true
    Intelligence=BRAINS_Mammal
    bStunImmune=true
    damageForce=5000
    IdleHeavyAnim="ZombieLeapIdle"
    IdleRifleAnim="ZombieLeapIdle"
    TakeoffAnims(0)= "ZombieSpring"
    TakeoffAnims(1)= "ZombieSpring"
    TakeoffAnims(2)= "ZombieSpring"
    TakeoffAnims(3)= "ZombieSpring"
    AirAnims(0)="ZombieSpring"
    AirAnims(3)="ZombieSpring"
    AirStillAnim="ZombieSpring"
    IdleCrouchAnim="ZombieLeapIdle"
    IdleWeaponAnim="ZombieLeapIdle"
    IdleRestAnim="ZombieLeapIdle"
    CollisionHeight=25.000000
    bCrawler = true
    bOrientOnSlope = true
    MeleeDamage=6
    ScoringValue=10
    GroundSpeed=140.000000
    WaterSpeed=130.000000
    JumpZ=350.000000
    Health=70
    HealthMax=70
    PounceSpeed=330.000000
    MotionDetectorThreat=0.34
    CrispUpThreshhold=10
    TurnLeftAnim= "ZombieScuttle"
    TurnRightAnim= "ZombieScuttle"
    LandAnims(0)= "ZombieScuttle"
    LandAnims(1)="ZombieScuttle"
    LandAnims(2)="ZombieScuttle"
    LandAnims(3)="ZombieScuttle"
    MovementAnims(0)="ZombieScuttle"
    MovementAnims(1)="ZombieScuttle"
    MovementAnims(2)="ZombieScuttle"
    MovementAnims(3)="ZombieScuttle"
    WalkAnims(0)="ZombieLeap"
    WalkAnims(1)="ZombieLeap"
    WalkAnims(2)="ZombieLeap"
    WalkAnims(3)="ZombieLeap"
    HitAnims(0)=none//"HitF"
    HitAnims(1)=none//"HitF"
    HitAnims(2)=none//"HitF"
    KFHitFront=none//"HitF"
    KFHitBack=none//"HitF"
    KFHitLeft=none//"HitF"
    KFHitRight=none//"HitF"
    MeleeAnims(0)="ZombieLeapAttack"
    MeleeAnims(1)="ZombieLeapAttack"//"ZombieLeapAttack2"
    MeleeAnims(2)="LeapAttack3"//"ZombieLeapAttack2"
    TakeoffStillAnim="ZombieLeap"//"ZombieLeapIdle"
    KFRagdollName="CrawlerRag"
    MenuName="Crawler 2.5"
    SpineBone1=
    SpineBone2=
    HeadHeight=1.0
    HeadRadius=10
    OnlineHeadshotScale=1.1
    OnlineHeadshotOffset=(X=20,Y=-5,Z=-7)
    ControllerClass=class'ControllerCrawlerOS'
}