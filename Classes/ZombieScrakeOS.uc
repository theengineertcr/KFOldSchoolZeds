class ZombieScrakeOS extends KFMonsterOS;

var         bool    bCharging;
var float DistBeforeSaw;
var bool bEnableOldScrakeBehavior;

replication
{
    reliable if(Role == ROLE_Authority)
        bCharging;
}

simulated function PostNetBeginPlay()
{
    EnableChannelNotify ( 1,1);
    AnimBlendParams(1, 1.0, 0.0,, SpineBone1);
    super.PostNetBeginPlay();
}

simulated function PostNetReceive()
{
    if (bCharging)
        MovementAnims[0]='ZombieRun';
    else if( !(bCrispified && bBurnified) )
        MovementAnims[0]=default.MovementAnims[0];
}

// This zed has been taken control of. Boost its health and speed
function SetMindControlled(bool bNewMindControlled)
{
    if( bNewMindControlled )
    {
        NumZCDHits++;

        // if we hit him a couple of times, make him rage!
        if( NumZCDHits > 1 )
        {
            if( !IsInState('ChargeToMarker') )
            {
                GotoState('ChargeToMarker');
            }
            else
            {
                NumZCDHits = 1;
                if( IsInState('ChargeToMarker') )
                {
                    GotoState('');
                }
            }
        }
        else
        {
            if( IsInState('ChargeToMarker') )
            {
                GotoState('');
            }
        }

        if( bNewMindControlled != bZedUnderControl )
        {
            SetGroundSpeed(OriginalGroundSpeed * 1.25);
            Health *= 1.25;
            HealthMax *= 1.25;
        }
    }
    else
    {
        NumZCDHits=0;
    }

    bZedUnderControl = bNewMindControlled;
}

// Handle the zed being commanded to move to a new location
function GivenNewMarker()
{
    if( bCharging && NumZCDHits > 1  )
    {
        GotoState('ChargeToMarker');
    }
    else
    {
        GotoState('');
    }
}

simulated function SetBurningBehavior()
{
    if( Role == Role_Authority && IsInState('RunningState') )
    {
        super.SetBurningBehavior();
        GotoState('');
    }

    super.SetBurningBehavior();
}

function RangedAttack(Actor A)
{
    local float Dist;

    Dist = VSize(A.Location - Location);

    if ( bShotAnim || Physics == PHYS_Swimming)
        return;
    else if ( Dist < (MeleeRange - DistBeforeSaw + CollisionRadius + A.CollisionRadius) && CanAttack(A) )
    {
        //Reset to default when you swing
        OnlineHeadshotOffset = default.OnlineHeadshotOffset;
        bShotAnim = true;
        SetAnimAction(MeleeAnims[Rand(2)]);
        CurrentDamType = ZombieDamType[0];
        PlaySound(sound'Claw2s', SLOT_None);
        GoToState('SawingLoop');
    }

    if(AnimAction == MeleeAnims[0])
        MeleeDamage = Max( (DifficultyDamageModifer() * default.MeleeDamage * 0.85), 1 );
    else if(AnimAction == MeleeAnims[1])
         MeleeDamage = Max( (DifficultyDamageModifer() * default.MeleeDamage * 1.15), 1 );

    if( !bShotAnim && !bDecapitated && !bEnableOldScrakeBehavior )
    {
        if ( Level.Game.GameDifficulty < 5.0 )
        {
            if ( float(Health)/HealthMax < 0.5 )
                GoToState('RunningState');
        }
        else
        {
            if ( float(Health)/HealthMax < 0.75 )
                GoToState('RunningState');
        }
    }
}

state RunningState
{
    //Fixes slow charge for charging zeds
    //Credits:NikC for forum link, aleat0r for the code
    simulated function float GetOriginalGroundSpeed()
    {
        return 3.5 * OriginalGroundSpeed;
    }

    simulated function SetZappedBehavior()
    {
        Global.SetZappedBehavior();
        GoToState('');
    }

    function bool CanSpeedAdjust()
    {
        return false;
    }

    //Dont play hit anims while charging so people don't complain about broken head hitboxes :)
    function OldPlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum, optional int HitIndex){}

    function BeginState()
    {
        if( bZapped )
            GoToState('');
        else
        {
            SetGroundSpeed(OriginalGroundSpeed * 3.5);
            bCharging = true;
            if( Level.NetMode!=NM_DedicatedServer )
                PostNetReceive();

            OnlineHeadshotOffset.Z = 41;
            OnlineHeadshotOffset.X = 30;
            OnlineHeadshotOffset.Y = -10;
            NetUpdateTime = Level.TimeSeconds - 1;
        }
    }

    function EndState()
    {
        if( !bZapped )
            SetGroundSpeed(GetOriginalGroundSpeed());
        bCharging = false;
        if( Level.NetMode!=NM_DedicatedServer )
            PostNetReceive();
        OnlineHeadshotOffset = default.OnlineHeadshotOffset;
    }

    function RemoveHead()
    {
        GoToState('');
        Global.RemoveHead();
    }

    function RangedAttack(Actor A)
    {
        local float Dist;

        Dist = VSize(A.Location - Location);
        DistBeforeSaw = 20.0;

        if ( bShotAnim || Physics == PHYS_Swimming)
            return;
        else if ( Dist < (MeleeRange - DistBeforeSaw + CollisionRadius + A.CollisionRadius) && CanAttack(A) )
        {
            bShotAnim = true;
            if(Level.Game.GameDifficulty < 5.0)
                SetAnimAction(MeleeAnims[Rand(2)]);
            else
                SetAnimAction(MeleeAnims[0]);
            CurrentDamType = ZombieDamType[0];
            GoToState('SawingLoop');
            OnlineHeadshotOffset = default.OnlineHeadshotOffset;
        }
    }
}

state RunningToMarker extends RunningState
{
}

State SawingLoop
{

    function bool CanSpeedAdjust()
    {
        return false;
    }

    function RangedAttack(Actor A)
    {
        if ( bShotAnim )
            return;
        else if ( CanAttack(A) )
        {
            Acceleration = vect(0,0,0);
            bShotAnim = true;
            MeleeDamage = default.MeleeDamage*0.6;
            SetAnimAction('SawImpaleLoop');
            CurrentDamType = ZombieDamType[0];
        }
        else GoToState('');
    }
    function AnimEnd( int Channel )
    {
        super.AnimEnd(Channel);
        if( Controller!=none && Controller.Enemy!=none )
            RangedAttack(Controller.Enemy);
    }

    function EndState()
    {
        MeleeDamage = Max( DifficultyDamageModifer() * default.MeleeDamage, 1 );

        SetGroundSpeed(GetOriginalGroundSpeed());
        bCharging = false;
        if( Level.NetMode!=NM_DedicatedServer )
            PostNetReceive();
    }
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    local bool bIsHeadShot;

    bIsHeadShot = IsHeadShot(Hitlocation, normal(Momentum), 1.0);

    if ( Level.Game.GameDifficulty >= 5.0 && bIsHeadshot && (class<DamTypeCrossbow>(damageType) != none || class<DamTypeCrossbowHeadShot>(damageType) != none) )
    {
        Damage *= 0.5;
    }

    super.takeDamage(Damage, instigatedBy, hitLocation, momentum, damageType, HitIndex);

    if ( Level.Game.GameDifficulty >= 5.0 && !IsInState('SawingLoop') && !IsInState('RunningState') && float(Health) / HealthMax < 0.75 )
        RangedAttack(InstigatedBy);
}

function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
    super(ZombieScrake).PlayTakeHit(HitLocation,Damage,DamageType);
}

simulated function int DoAnimAction( name AnimName )
{
    if( AnimName=='SawZombieAttack1' || AnimName=='SawZombieAttack2' /*|| AnimName=='SawImpaleLoop' */)
    {
        AnimBlendParams(1, 1.0, 0.0,, 'Bip01 Spine1');
        PlayAnim(AnimName,, 0.0, 1);
        return 1;
    }
    return super.DoAnimAction(AnimName);
}

simulated event SetAnimAction(name NewAction)
{
    local int meleeAnimIndex;

    if( NewAction=='' )
        return;

    if(NewAction == 'Claw')
    {
        meleeAnimIndex = Rand(3);
        NewAction = meleeAnims[meleeAnimIndex];
        CurrentDamtype = ZombieDamType[meleeAnimIndex];
    }

    ExpectingChannel = DoAnimAction(NewAction);

    if( AnimNeedsWait(NewAction) )
        bWaitForAnim = true;

    if( Level.NetMode!=NM_Client )
    {
        AnimAction = NewAction;
        bResetAnimAct = true;
        ResetAnimActTime = Level.TimeSeconds+0.3;
    }
}

simulated function bool AnimNeedsWait(name TestAnim)
{
    if( TestAnim == 'SawImpaleLoop' || TestAnim == 'DoorBash' || TestAnim == 'KnockDown' )
        return true;

    return false;
}


simulated function SpawnGibs(Rotator HitRotation, float ChunkPerterbation)
{
    super.SpawnGibs(HitRotation,ChunkPerterbation);
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Scrake.ScrakeSkin');
    myLevel.AddPrecacheMaterial(TexOscillator'KFOldSchoolZeds_Textures.Scrake.SawChainOSC');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Scrake.ScrakeFrockSkin');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Scrake.ScrakeSawSkin');
}

defaultproperties
{
    Mesh=SkeletalMesh'KFCharacterModelsOldSchool.SawZombie'
    Skins(0)=Texture'KFOldSchoolZeds_Textures.Scrake.ScrakeSkin'
    Skins(1)=TexOscillator'KFOldSchoolZeds_Textures.Scrake.SawChainOSC'
    Skins(2)=Texture'KFOldSchoolZeds_Textures.Scrake.ScrakeFrockSkin'
    Skins(3)=Texture'KFOldSchoolZeds_Textures.Scrake.ScrakeSawSkin'
    AmbientSound=Sound'KFOldSchoolZeds_Sounds.Scrake.Saw_Idle'
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Scrake.Scrake_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieJump'
    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieDeath'
    ZombieFlag=3
    bMeleeStunImmune = true
    MeleeAnims(0)="SawZombieAttack1"
    MeleeAnims(1)="SawZombieAttack2"
    MovementAnims(0)="SawZombieWalk"
    MovementAnims(1)="SawZombieWalk"
    MovementAnims(2)="SawZombieWalk"
    MovementAnims(3)="SawZombieWalk"
    WalkAnims(0)="SawZombieWalk"
    WalkAnims(1)="SawZombieWalk"
    WalkAnims(2)="SawZombieWalk"
    WalkAnims(3)="SawZombieWalk"
    IdleCrouchAnim="SawZombieIdle"
    IdleWeaponAnim="SawZombieIdle"
    IdleRestAnim="SawZombieIdle"
    IdleHeavyAnim="SawZombieIdle"
    IdleRifleAnim="SawZombieIdle"
    bFatAss=true
    Mass=500.000000
    RotationRate=(Yaw=45000,Roll=0)
    bUseExtendedCollision=true
    DamageToMonsterScale=8.0
    PoundRageBumpDamScale=0.01
    MeleeDamage=20
    damageForce=-100000
    ScoringValue=75
    MeleeRange=60
    DistBeforeSaw=0.0
    GroundSpeed=85.000000
    WaterSpeed=75.000000
    Health=1000
    HealthMax=1000
    PlayerCountHealthScale=0.5
    PlayerNumHeadHealthScale=0.30
    HeadHealth=650
    BleedOutDuration=6.0
    MotionDetectorThreat=3.0
    ZapThreshold=1.25
    ZappedDamageMod=1.25
    bHarpoonToHeadStuns=true
    bHarpoonToBodyStuns=false
    Intelligence=BRAINS_Mammal
    KFRagdollName="FleshPoundRag"//SawZombieRag"
    bCannibal = true
    MenuName="Scrake 2.5"
    SoundRadius=200.000000
    AmbientSoundScaling=5
    ColOffset=(Z=55)
    ColRadius=29
    ColHeight=18
    Prepivot=(Z=0.0)
    HeadHeight=6
    HeadRadius=8
    OnlineHeadshotScale=1.2
    OnlineHeadshotOffset=(X=10,Y=-7,Z=58)
    ControllerClass=class'ControllerScrakeOS'
}