class ZombieClotOS extends KFMonsterOS;

//TODO: Break grapple immediately on death
var     KFPawn  DisabledPawn;           // The pawn that has been disabled by this zombie's grapple
var     bool    bGrappling;             // This zombie is grappling someone
var     float   GrappleEndTime;         // When the current grapple should be over
var()   float   GrappleDuration;        // How long a grapple by this zombie should last
var    float    ClotGrabMessageDelay;   // Amount of time between a player saying "I've been grabbed" message

replication
{
    reliable if(bNetDirty && Role == ROLE_Authority)
        bGrappling;
}

function BreakGrapple()
{
    if( DisabledPawn != none )
    {
         DisabledPawn.bMovementDisabled = false;
         DisabledPawn = none;
    }
}

function ClawDamageTarget()
{
    local vector PushDir;
    local KFPawn KFP;
    local float UsedMeleeDamage;

    if( MeleeDamage > 1 )
       UsedMeleeDamage = (MeleeDamage - (MeleeDamage * 0.05)) + (MeleeDamage * (FRand() * 0.1));
    else
       UsedMeleeDamage = MeleeDamage;

    if ( MeleeDamageTarget( UsedMeleeDamage, PushDir))
    {
        KFP = KFPawn(Controller.Target);

        if( !bDecapitated && KFP != none )
        {
            if ( KFPlayerReplicationInfo(KFP.PlayerReplicationInfo).ClientVeteranSkill != class'KFVetBerserker')
            {
                if( DisabledPawn != none )
                     DisabledPawn.bMovementDisabled = false;

                KFP.DisableMovement(GrappleDuration);
                DisabledPawn = KFP;
            }
        }
    }
}

function DoorAttack(Actor A)
{
    if ( bShotAnim || Physics == PHYS_Swimming)
        return;
    else if ( CanAttack(A) )
    {
        bShotAnim = true;
        SetAnimAction('Claw2');
        PlaySound(sound'Claw2s', SLOT_None);
        return;
    }
}

function RangedAttack(Actor A)
{
    if ( bShotAnim || Physics == PHYS_Swimming)
        return;
    else if ( CanAttack(A) )
    {
        bShotAnim = true;
        SetAnimAction('Claw');
        Acceleration = Normal(A.Location-Location)*600;
        Controller.GoToState('WaitForAnim');
        Controller.MoveTarget = A;
        Controller.MoveTimer = 1.5;
    }
}

simulated event SetAnimAction(name NewAction)
{
    local int meleeAnimIndex;

    if( NewAction=='' )
        return;
    if(NewAction == 'Claw')
    {
        meleeAnimIndex = Rand(3);
        NewAction = meleeAnims[2];
        CurrentDamtype = ZombieDamType[meleeAnimIndex];
    }

    ExpectingChannel = DoAnimAction(NewAction);

    if( AnimNeedsWait(NewAction) )
        bWaitForAnim = true;
    else
        bWaitForAnim = false;

    if( Level.NetMode!=NM_Client )
    {
        AnimAction = NewAction;
        bResetAnimAct = true;
        ResetAnimActTime = Level.TimeSeconds+0.3;
    }
}

simulated function int DoAnimAction( name AnimName )
{
    if( AnimName=='ClotGrapple' )
    {
        if ( FRand() < 0.10 && LookTarget != none && KFPlayerController(LookTarget.Controller) != none &&
             VSizeSquared(Location - LookTarget.Location) < 2500 &&
             Level.TimeSeconds - KFPlayerController(LookTarget.Controller).LastClotGrabMessageTime > ClotGrabMessageDelay &&
             KFPlayerController(LookTarget.Controller).SelectedVeterancy != class'KFVetBerserker' )
        {
            PlayerController(LookTarget.Controller).Speech('AUTO', 11, "");
            KFPlayerController(LookTarget.Controller).LastClotGrabMessageTime = Level.TimeSeconds;
        }
    }
    return super.DoAnimAction( AnimName );
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    super.takeDamage(Damage, instigatedBy, hitLocation, momentum, damageType);

    //Fixed log spam
    if( (Health < 0 || Damage > Health) && DisabledPawn != None)
        DisabledPawn.bMovementDisabled = false;
}

function RemoveHead()
{
    Super.RemoveHead();
    MeleeAnims[0] = 'Claw';
    MeleeAnims[1] = 'Claw';
    MeleeAnims[2] = 'Claw2';

    MeleeDamage *= 2;
    MeleeRange *= 2;

    if( DisabledPawn != none )
    {
         DisabledPawn.bMovementDisabled = false;
         DisabledPawn = none;
    }
}

static simulated function PreCacheStaticMeshes(LevelInfo myLevel)
{
   super.PreCacheStaticMeshes(myLevel);
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Clot.ClotSkin');
}

defaultproperties
{
    Mesh=SkeletalMesh'KFCharacterModelsOldSchool.InfectedWhiteMale1'
    Skins(0)=Texture'KFOldSchoolZeds_Textures.Clot.ClotSkin'
    AmbientSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieBreath'
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Clot.Clot_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieJump'
    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Male_ZombieDeath'
    MenuName="Clot 2.5"
    ScoringValue=7
    Intelligence=BRAINS_Mammal
    KFRagdollName="ClotRag"
    MovementAnims(0)="ClotWalk"
    WalkAnims(0)="ClotWalk"
    WalkAnims(1)="ClotWalk"
    WalkAnims(2)="ClotWalk"
    WalkAnims(3)="ClotWalk"
    AdditionalWalkAnims(0) = "ClotWalk"
    MeleeAnims(0)="Claw"
    MeleeAnims(1)="Claw2"
    MeleeAnims(2)="ClotGrapple"
    MeleeRange=20.0
    MeleeDamage=6
    damageForce=5000
    PuntAnim="ClotPunt"
    bUseExtendedCollision=true
    ColOffset=(Z=48.000000)
    ColRadius=25.000000
    ColHeight=5.000000
    OnlineHeadshotScale=1.2
    OnlineHeadshotOffset=(X=21,Y=-7,Z=43)
    Health=130
    HealthMax=130
    HeadHeight=5
    RotationRate=(Yaw=45000,Roll=0)
    GroundSpeed=105.000000
    WaterSpeed=105.000000
    JumpZ=340.000000
    MotionDetectorThreat=0.34
    CrispUpThreshhold=9
    GrappleDuration=1.0//1.5
    ClotGrabMessageDelay=12.0
    bCannibal = true
}