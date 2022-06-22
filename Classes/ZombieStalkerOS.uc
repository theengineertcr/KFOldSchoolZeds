class ZombieStalkerOS extends KFMonsterOS;

var bool bCloaking;
var float NextCheckTime;

simulated event SetAnimAction(name NewAction)
{
    if ( NewAction == 'Claw' || NewAction == MeleeAnims[0] || NewAction == MeleeAnims[1] || NewAction == MeleeAnims[2] )
    {
        UncloakStalker();
    }

    super.SetAnimAction(NewAction);
}

simulated function Tick(float DeltaTime)
{
    Local KFHumanPawn HP;

    super.Tick(DeltaTime);
    if( Level.NetMode==NM_DedicatedServer )
        return;

    if( bZapped )
    {
        NextCheckTime = Level.TimeSeconds;
    }
    else if( Level.TimeSeconds > NextCheckTime && Health > 0 )
    {
        NextCheckTime = Level.TimeSeconds + 0.8;

        //We need GetStalkerViewDistanceMulti here later
        ForEach VisibleCollidingActors(class'KFHumanPawn',HP,800,Location)
        {
            if( HP.Health<=0 || !HP.ShowStalkers() )
                continue;

            if( !bSpotted )
            {
                bSpotted = true;
                Skins[0] = Finalblend 'KFOldSchoolZeds_Textures.StalkerGlowFB';
                Skins[1] = Finalblend 'KFOldSchoolZeds_Textures.StalkerGlowFB';
            }
            return;
        }

        if( bSpotted )
        {
            bSpotted = false;
            bUnlit = false;
            CloakStalker();
        }
    }
}

// You can have this because you're invisible and annoying to headshot
function OldPlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum, optional int HitIndex)
{
    if(!bShotAnim)
        return;
    else
        super.OldPlayHit(Damage,InstigatedBy,hitlocation,damageType,momentum,HitIndex);
}

simulated function CloakStalker()
{
    if( bZapped )
    {
        return;
    }

    if ( bSpotted && !bDecapitated )
    {
        if( Level.NetMode == NM_DedicatedServer )
            return;

        Skins[0] = Finalblend 'KFOldSchoolZeds_Textures.StalkerGlowFB';
        Skins[1] = Finalblend 'KFOldSchoolZeds_Textures.StalkerGlowFB';
        bUnlit = true;
        return;
    }
    if ( !bDecapitated && !bCrispified && !bCloaked)
    {
        Visibility = 1;
        bCloaked = true;

        if( Level.NetMode == NM_DedicatedServer )
            return;

        Skins[0] = Shader 'KFOldSchoolZeds_Textures.StalkerHairShader';
        Skins[1] = Shader 'KFOldSchoolZeds_Textures.StalkerCloakShader';

        if(PlayerShadow != none)
            PlayerShadow.bShadowActive = false;
        if(RealTimeShadow != none)
            RealTimeShadow.Destroy();

        Projectors.Remove(0, Projectors.Length);
        bAcceptsProjectors = false;

        SetOverlayMaterial(Material'KFOldSchoolZeds_Textures.StalkerDeCloakfb', 0.25, true);
    }
}

simulated function UnCloakStalker()
{
    if( bZapped )
    {
        return;
    }

    if( !bCrispified )
    {
        Visibility = default.Visibility;
        bCloaked = false;
        bUnlit = false;

        if( Level.NetMode!=NM_Client && !KFGameType(Level.Game).bDidStalkerInvisibleMessage && FRand()<0.25 && Controller.Enemy!=none &&
         PlayerController(Controller.Enemy.Controller)!=none )
        {
            PlayerController(Controller.Enemy.Controller).Speech('AUTO', 17, "");
            KFGameType(Level.Game).bDidStalkerInvisibleMessage = true;
        }

        if( Level.NetMode == NM_DedicatedServer )
            return;

        Skins[1] = FinalBlend'KFOldSchoolZeds_Textures.StalkerHairFB';
        Skins[0] = Texture'KFOldSchoolZeds_Textures.StalkerSkin';

        if (PlayerShadow != none)
            PlayerShadow.bShadowActive = true;

        bAcceptsProjectors = true;

        SetOverlayMaterial(Material'KFOldSchoolZeds_Textures.StalkerDeCloakfb', 0.25, true);
    }
}

simulated function SetZappedBehavior()
{
    super.SetZappedBehavior();

    bUnlit = false;

    if( Level.Netmode != NM_DedicatedServer )
    {
        Skins[1] = FinalBlend'KFOldSchoolZeds_Textures.StalkerHairFB';
        Skins[0] = Texture'KFOldSchoolZeds_Textures.StalkerSkin';

        if (PlayerShadow != none)
            PlayerShadow.bShadowActive = true;

        bAcceptsProjectors = true;
        SetOverlayMaterial(Material'KFZED_FX_T.Energy.ZED_overlay_Hit_Shdr', 999, true);
    }
}

simulated function UnSetZappedBehavior()
{
    super.UnSetZappedBehavior();

    if( Level.Netmode != NM_DedicatedServer )
    {
        NextCheckTime = Level.TimeSeconds;
        SetOverlayMaterial(none, 0.0f, true);
    }
}

function SetZapped(float ZapAmount, Pawn Instigator)
{
    LastZapTime = Level.TimeSeconds;

    if( bZapped )
    {
        TotalZap = ZapThreshold;
        RemainingZap = ZapDuration;
    }
    else
    {
        TotalZap += ZapAmount;

        if( TotalZap >= ZapThreshold )
        {
            RemainingZap = ZapDuration;
            bZapped = true;
        }
    }
    ZappedBy = Instigator;
}

function RemoveHead()
{
    super.RemoveHead();

    if (!bCrispified)
    {
        Skins[1] = FinalBlend'KFOldSchoolZeds_Textures.StalkerHairFB';
        Skins[0] = Texture'KFOldSchoolZeds_Textures.StalkerSkin';
    }
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    super.PlayDying(DamageType,HitLoc);

    if(bUnlit)
        bUnlit=!bUnlit;

    if (!bCrispified)
    {
        Skins[1] = FinalBlend'KFOldSchoolZeds_Textures.StalkerHairFB';
        Skins[0] = Texture'KFOldSchoolZeds_Textures.StalkerSkin';
    }
}

function bool DoJump( bool bUpdating )
{
    if ( !bIsCrouched && !bWantsToCrouch && ((Physics == PHYS_Walking) || (Physics == PHYS_Ladder) || (Physics == PHYS_Spider)) )
    {
        if ( Role == ROLE_Authority )
        {
            if ( (Level.Game != none) && (Level.Game.GameDifficulty > 2) )
                MakeNoise(0.1 * Level.Game.GameDifficulty);
            if ( bCountJumps && (Inventory != none) )
                Inventory.OwnerEvent('Jumped');
        }

        if ( Physics == PHYS_Spider )
            Velocity = JumpZ * Floor;
        else if ( Physics == PHYS_Ladder )
            Velocity.Z = 0;
        else if ( bIsWalking )
        {
            Velocity.Z = default.JumpZ;
            Velocity.X = (default.JumpZ * 0.6);
        }
        else
        {
            Velocity.Z = JumpZ;
            Velocity.X = (JumpZ * 0.6);
        }

        if ( (Base != none) && !Base.bWorldGeometry )
        {
            Velocity.Z += Base.Velocity.Z;
            Velocity.X += Base.Velocity.X;
        }

        SetPhysics(PHYS_Falling);
        return true;
    }
    return false;
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
    myLevel.AddPrecacheMaterial(Shader'KFOldSchoolZeds_Textures.StalkerHairShader');
    myLevel.AddPrecacheMaterial(Shader'KFOldSchoolZeds_Textures.StalkerCloakShader');
    myLevel.AddPrecacheMaterial(Finalblend 'KFOldSchoolZeds_Textures.StalkerGlowFB');
    myLevel.AddPrecacheMaterial(Material'KFOldSchoolZeds_Textures.StalkerDeCloakfb');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.StalkerSkin');
    myLevel.AddPrecacheMaterial(FinalBlend 'KFOldSchoolZeds_Textures.StalkerHairFB');
}

defaultproperties
{
    Mesh=SkeletalMesh'KFCharacterModelsOldSchool.InfectedWhiteFemale'
    Skins(0) = Shader'KFOldSchoolZeds_Textures.StalkerHairShader'
    Skins(1) = Shader'KFOldSchoolZeds_Textures.StalkerCloakShader'

    AmbientSound=none
    MoanVoice=Sound'KFOldSchoolZeds_Sounds.Stalker.Stalker_Speech'
    JumpSound=Sound'KFOldSchoolZeds_Sounds.Shared.Female_ZombieJump'

    HitSound(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Female_ZombiePain'
    DeathSound(0)=Sound'KFOldSchoolZeds_Sounds.Stalker.Stalker_Death'

    ScoringValue=15
    MenuName="Stalker 2.5"

    IdleCrouchAnim="StalkerIdle"
    IdleWeaponAnim="StalkerIdle"
    IdleRestAnim="StalkerIdle"
    IdleHeavyAnim="StalkerIdle"
    IdleRifleAnim="StalkerIdle"

    MovementAnims(0)="ZombieRun"
    MovementAnims(1)="ZombieRun"
    MovementAnims(2)="ZombieRun"
    MovementAnims(3)="ZombieRun"
    WalkAnims(0)="ZombieRun"
    WalkAnims(1)="ZombieRun"
    WalkAnims(2)="ZombieRun"
    WalkAnims(3)="ZombieRun"

    MeleeAnims(0)="StalkerSpinAttack"
    MeleeAnims(1)="StalkerAttack1"
    MeleeAnims(2)="JumpAttack"

    PuntAnim="ClotPunt"

    HeadHeight=2.0
    OnlineHeadshotScale=1.2
    OnlineHeadshotOffset=(X=19,Y=-7,Z=25)

    bUseExtendedCollision=true
    ColOffset=(Z=48.000000)
    ColRadius=25.000000
    ColHeight=5.000000

    CrispUpThreshhold=10

    RotationRate=(Yaw=45000,Roll=0)

    MeleeRange=30.000000
    MeleeDamage=9
    damageForce=5000
    ZombieDamType(0)=class'KFMod.DamTypeSlashingAttack'
    ZombieDamType(1)=class'KFMod.DamTypeSlashingAttack'
    ZombieDamType(2)=class'KFMod.DamTypeSlashingAttack'

    Health=100
    HealthMax=100

    GroundSpeed=200.000000
    WaterSpeed=180.000000
    JumpZ=350.000000

    MotionDetectorThreat=0.25

    bCannibal=true

    SoundGroupClass=class'KFOldSchoolZeds.KFFemaleZombieSoundsOS'
}