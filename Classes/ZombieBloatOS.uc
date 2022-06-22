class ZombieBloatOS extends KFMonsterOS;

var class<Actor> VomitJet;
var Actor BloatJet;
var bool bPlayBileSplash;
var float DistBeforePuke;
var bool bEnableOldBloatPuke;

//Call Puke Emitter via AnimNotify_Script than Effect
//Otherwise, compiling will complain about missing meshes
//Redo this function to aim puke to player
//Also, bEnableOldBloatPuke doesn't work
simulated function SpawnPukeEmitter()
{
    local vector X,Y,Z, FireStart;

    GetAxes(Rotation,X,Y,Z);
    FireStart = GetBoneCoords('bip01 head').Origin;
    Spawn(VomitJet,,,FireStart,Rotation);
}

function BodyPartRemoval(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
    super.BodyPartRemoval(Damage, instigatedBy, hitlocation, momentum, damageType);

    if((Health - Damage)<=0)
        Gored=3;

    if(bEnableOldBloatPuke)
    {
        if(Gored>=3 && Gored < 5)
            BileBomb();
    }
}

function bool FlipOver()
{
    return false;
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
    // Actually become gored when you die to non-bleedout damage
    if(damagetype != class'DamTypeBleedOut')
        Gored=3;

    super.Died(Killer,damageType,HitLocation);
}

simulated function bool HitCanInterruptAction()
{
    if( bShotAnim )
        return false;

    return true;
}

function DoorAttack(Actor A)
{
    if ( bShotAnim || Physics == PHYS_Swimming)
        return;
    else if ( A!=none )
    {
        bShotAnim = true;
        if( !bDecapitated )
            SetAnimAction('ZombieBarf');
        else
        {
            SetAnimAction('Claw');
            PlaySound(sound'Claw2s', SLOT_None);
        }
    }
}

function RangedAttack(Actor A)
{
    local int LastFireTime;

    if ( bShotAnim )
        return;

    if ( Physics == PHYS_Swimming )
    {
        SetAnimAction('Claw');
        bShotAnim = true;
        LastFireTime = Level.TimeSeconds;
    }
    else if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
    {
        bShotAnim = true;
        LastFireTime = Level.TimeSeconds;
        SetAnimAction('Claw');
        PlaySound(sound'Claw2s', SLOT_Interact);
        Controller.bPreparingMove = true;
        Acceleration = vect(0,0,0);
    }
    else if( (KFDoorMover(A)!=none || VSize(A.Location-Location)<=DistBeforePuke) && !bDecapitated )
    {
        bShotAnim=true;
        SetAnimAction('ZombieBarf');
        Controller.bPreparingMove = true;
        Acceleration = vect(0,0,0);

        if ( FRand() < 0.03 && KFHumanPawn(A) != none && PlayerController(KFHumanPawn(A).Controller) != none )
            PlayerController(KFHumanPawn(A).Controller).Speech('AUTO', 7, "");
    }
}

function SpawnTwoShots()
{
    local vector X,Y,Z, FireStart;
    local rotator FireRotation;

    // Credit: https://github.com/InsultingPros/SuperZombieMut/blob/somechanges/Classes/ZombieSuperBloat.uc#L94
    // check this from the very start to prevent any log spam / dead bloats dont barf!(headless bloats dont barf either!)
    if (Controller == none || IsInState('ZombieDyingOS') || bDecapitated )
        return;

    if( Controller!=none && KFDoorMover(Controller.Target)!=none )
    {
        Controller.Target.TakeDamage(22,self,Location,vect(0,0,0),class'DamTypeVomit');
        return;
    }

    GetAxes(Rotation,X,Y,Z);
    FireStart = Location+(vect(30,0,64) >> Rotation)*DrawScale;

    if ( !SavedFireProperties.bInitialized )
    {
        SavedFireProperties.AmmoClass = class'SkaarjAmmo';
        SavedFireProperties.ProjectileClass = class'KFBloatVomitOS';
        SavedFireProperties.WarnTargetPct = 1;
        SavedFireProperties.MaxRange = 500;
        SavedFireProperties.bTossed = false;
        SavedFireProperties.bTrySplash = false;
        SavedFireProperties.bLeadTarget = true;
        SavedFireProperties.bInstantHit = true;
        SavedFireProperties.bInitialized = true;
    }

    ToggleAuxCollision(false);

    FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);

    Spawn(class'KFBloatVomit',,,FireStart,FireRotation);

    FireStart-=(0.5*CollisionRadius*Y);
    FireRotation.Yaw -= 1200;

    Spawn(class'KFBloatVomit',,,FireStart,FireRotation);

    FireStart+=(CollisionRadius*Y);
    FireRotation.Yaw += 2400;

    Spawn(class'KFBloatVomit',,,FireStart,FireRotation);

    ToggleAuxCollision(true);
}

simulated function Tick(float deltatime)
{
    local vector BileExplosionLoc;
    local Actor GibBileExplosion;

    super.tick(deltatime);

    if( Level.NetMode!=NM_DedicatedServer && Gored>0 && !bPlayBileSplash )
    {
        BileExplosionLoc = self.Location;
        BileExplosionLoc.z += (CollisionHeight - (CollisionHeight * 0.5));

        GibBileExplosion = Spawn(class 'BileExplosionOS',self,, BileExplosionLoc );

        bPlayBileSplash = true;
    }
}

function BileBomb()
{
    local bool AttachSucess;

    if(bEnableOldBloatPuke)
    {
        BloatJet = spawn(class'BileJetOS', self,,,);

        if(Gored < 5)
            AttachSucess=AttachToBone(BloatJet,'Bip01 Spine');

        if(!AttachSucess)
            BloatJet.SetBase(self);

        BloatJet.SetRelativeRotation(rot(0,-4096,0));
    }
    else

    BloatJet = spawn(class'BileJet', self,,Location,Rotator(-PhysicsVolume.Gravity));

}

function PlayDyingAnimation(class<DamageType> DamageType, vector HitLoc)
{
    local bool AttachSucess;

    super.PlayDyingAnimation(DamageType, HitLoc);

    if( bDecapitated && DamageType == class'DamTypeBleedOut' )
        return;

    if(Role == ROLE_Authority)
    {
        BileBomb();

        if(BloatJet!=none && bEnableOldBloatPuke)
        {
            if(Gored < 5)
                AttachSucess=AttachToBone(BloatJet,'Bip01 Spine');

            if(!AttachSucess)
                BloatJet.SetBase(self);

            BloatJet.SetRelativeRotation(rot(0,-4096,0));
        }
    }
}

State Dying
{
    function tick(float deltaTime)
    {
        if (BloatJet != none)
        {
            BloatJet.SetLocation(location);
            BloatJet.SetRotation(GetBoneRotation('Bip01 Spine'));
        }
        super.tick(deltaTime);
    }
}

function RemoveHead()
{
    bCanDistanceAttackDoors = false;
    super.RemoveHead();
}

simulated function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType, optional int HitIndex)
{
    if (DamageType == class 'Burned')
        Damage *= 1.5;

    if (damageType == class 'DamTypeVomit' || damageType == class 'DamTypeVomitOS')
        return;
    else if( damageType == class 'DamTypeBlowerThrower' )
       Damage *= 0.25;

    super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Bloat.BloatSkin');
}

defaultproperties
{
    Mesh=SkeletalMesh'KFCharacterModelsOldSchool.Bloat'
    Skins(0)=Texture'KFOldSchoolZeds_Textures.Bloat.BloatSkin'
    AmbientSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieBreath'
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Bloat.Bloat_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieJump'
    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieDeath'
    MenuName="Bloat 2.5"
    ScoringValue=17
    ZombieFlag=1
    Intelligence=BRAINS_Stupid
    IdleHeavyAnim="BloatIdle"
    IdleRifleAnim="BloatIdle"
    IdleCrouchAnim="BloatIdle"
    IdleWeaponAnim="BloatIdle"
    IdleRestAnim="BloatIdle"
    MovementAnims(0)="WalkBloat"
    MovementAnims(1)="WalkBloat"
    WalkAnims(0)="WalkBloat"
    WalkAnims(1)="WalkBloat"
    WalkAnims(2)="WalkBloat"
    WalkAnims(3)="WalkBloat"
    MeleeAnims(0)="BloatChop2"
    MeleeAnims(1)="BloatChop2"
    MeleeAnims(2)="BloatChop2"
    MeleeDamage=14
    MeleeRange=30.0//55.000000
    damageForce=70000
    PuntAnim="BloatPunt"
    CollisionRadius=26.000000
    CollisionHeight=44.000000
    Prepivot=(Z=8.000000) //(Z=5.0)
    bUseExtendedCollision=true
    ColOffset=(Z=60.000000)
    ColRadius=27.000000
    ColHeight=22.000000
    OnlineHeadshotScale=1.2
    OnlineHeadshotOffset=(X=10,Y=-5,Z=69)
    Health=525
    HealthMax=525
    PlayerCountHealthScale=0.25
    HeadHealth=25
    PlayerNumHeadHealthScale=0.0
    Mass=400.000000
    RotationRate=(Yaw=45000,Roll=0)
    bFatAss=true
    GroundSpeed=75.0//105.000000
    WaterSpeed=102.000000
    JumpZ=320.000000
    DistBeforePuke=250
    bCanDistanceAttackDoors=true
    AmmunitionClass=class'KFMod.BZombieAmmo'
    BleedOutDuration=6.0
    MotionDetectorThreat=1.0
    HeadRadius=8
    HeadHeight=5.5
    ZapThreshold=0.5
    ZappedDamageMod=1.5
    bHarpoonToHeadStuns=true
    bHarpoonToBodyStuns=false
    KFRagdollName="BloatRag"
    bCannibal=true
    VomitJet=class'KFVomitJetOS'
}