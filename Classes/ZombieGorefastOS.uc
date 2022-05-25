class ZombieGoreFastOS extends KFMonsterOS;

var bool bRunning;

replication
{
    reliable if(Role == ROLE_Authority)
        bRunning;
}

event PreBeginPlay()
{
    super.PreBeginPlay();
    LinkSkelAnim(MeshAnimation'KFCharacterModelsOldSchool.BloatSet');
}

simulated function PostNetReceive()
{
    if( !bZapped )
    {
        if (bRunning)
        {
            MovementAnims[0]='ZombieRun';
        }
        else
        {
            MovementAnims[0]=default.MovementAnims[0];
        }
    }
}

function SetMindControlled(bool bNewMindControlled)
{
    if( bNewMindControlled )
    {
        NumZCDHits++;

        if( NumZCDHits > 1 )
        {
            if( !IsInState('RunningToMarker') )
            {
                GotoState('RunningToMarker');
            }
            else
            {
                NumZCDHits = 1;
                if( IsInState('RunningToMarker') )
                {
                    GotoState('');
                }
            }
        }
        else
        {
            if( IsInState('RunningToMarker') )
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

function GivenNewMarker()
{
    if( bRunning && NumZCDHits > 1 )
    {
        GotoState('RunningToMarker');
    }
    else
    {
        GotoState('');
    }
}

function PlayZombieAttackHitSound()
{
    local int MeleeAttackSounds;

    MeleeAttackSounds = rand(3);

    switch(MeleeAttackSounds)
    {
        case 0:
            PlaySound(sound'KFOldSchoolZeds_Sounds.Stab_Hit1', SLOT_Interact);
            break;
        case 1:
            PlaySound(sound'KFOldSchoolZeds_Sounds.Stab_Hit2', SLOT_Interact);
            break;
        case 2:
            PlaySound(sound'KFOldSchoolZeds_Sounds.Stab_Hit3', SLOT_Interact);
    }
}

function RangedAttack(Actor A)
{
    super.RangedAttack(A);
    
    if( !bShotAnim && !bDecapitated && VSize(A.Location-Location)<=700 )
    {
        GoToState('RunningState');
    }
}

state RunningState
{
    simulated function SetZappedBehavior()
    {
        Global.SetZappedBehavior();
        GoToState('');
    }

    function bool CanSpeedAdjust()
    {
        return false;
    }

    function BeginState()
    {
        if( bZapped )
        {
            GoToState('');
        }
        else
        {
            SetGroundSpeed(OriginalGroundSpeed * 1.875);
            bRunning = true;
            if( Level.NetMode!=NM_DedicatedServer )
                PostNetReceive();

            OnlineHeadshotOffset.Z=30;
            NetUpdateTime = Level.TimeSeconds - 1;
        }
    }

    function EndState()
    {
        if( !bZapped )
        {
            SetGroundSpeed(GetOriginalGroundSpeed());
        }
        bRunning = false;
        if( Level.NetMode!=NM_DedicatedServer )
            PostNetReceive();

        OnlineHeadshotOffset.Z=45;
        NetUpdateTime = Level.TimeSeconds - 1;
    }

    function RemoveHead()
    {
        GoToState('');
        Global.RemoveHead();
    }

    function RangedAttack(Actor A)
    {
        if ( bShotAnim || Physics == PHYS_Swimming)
            return;
        else if ( CanAttack(A) )
        {
            bShotAnim = true;
            SetAnimAction('Claw');
            Controller.bPreparingMove = true;
            Acceleration = vect(0,0,0);
            GoToState('');
            return;
        }
    }

Begin:
    GoTo('CheckCharge');
    
CheckCharge:
    if( Controller!=none && Controller.Target!=none && VSize(Controller.Target.Location-Location)<700 )
    {
        Sleep(0.5+ FRand() * 0.5);
        GoTo('CheckCharge');
    }
    else
    {
        GoToState('');
    }
}

state RunningToMarker extends RunningState
{
Begin:
    GoTo('CheckCharge');
CheckCharge:
    if( bZedUnderControl || (Controller!=none && Controller.Target!=none && VSize(Controller.Target.Location-Location)<700) )
    {
        Sleep(0.5+ FRand() * 0.5);
        GoTo('CheckCharge');
    }
    else
    {
        GoToState('');
    }
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Gorefast.GorefastSkin');
}

defaultproperties
{
    Mesh=SkeletalMesh'KFCharacterModelsOldSchool.GoreFast'
    Skins(0)=Texture'KFOldSchoolZeds_Textures.Gorefast.GorefastSkin'
    
    AmbientSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieBreath'
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Gorefast.Gorefast_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieJump'
    
    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieDeath'
    
    MeleeAnims(0)="GoreAttack1"
    MeleeAnims(1)="GoreAttack2"
    MeleeAnims(2)="GoreAttack1"
    MovementAnims(0)="GoreWalk"
    WalkAnims(0)="GoreWalk"
    WalkAnims(1)="GoreWalk"
    WalkAnims(2)="GoreWalk"
    WalkAnims(3)="GoreWalk"
    IdleCrouchAnim="GoreIdle"
    IdleWeaponAnim="GoreIdle"
    IdleRestAnim="GoreIdle"
    IdleHeavyAnim="GoreIdle"
    IdleRifleAnim="GoreIdle"
    Mass=350.000000
    RotationRate=(Yaw=45000,Roll=0)

    MeleeDamage=15
    damageForce=5000
    ScoringValue=12
    MeleeRange=45.0
    GroundSpeed=120.0
    WaterSpeed=140.000000
    Health=250
    HealthMax=250
    PlayerCountHealthScale=0.15
    PlayerNumHeadHealthScale=0.0
    HeadHealth=25
    CrispUpThreshhold=8
    MotionDetectorThreat=0.5

    bCannibal = true
    MenuName="Gorefast 2.5"

    damageConst = 100
    damageRand = 10

    OnlineHeadshotOffset=(X=25,Y=-5,Z=45)
    SoloHeadScale=1.1
    OnlineHeadshotScale=1.35

    bUseExtendedCollision=true
    ColOffset=(Z=52)
    ColRadius=25
    ColHeight=10
    ControllerClass=class'GorefastControllerOS'
}