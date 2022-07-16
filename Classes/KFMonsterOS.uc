class KFMonsterOS extends KFMonster
    hidecategories(AnimTweaks,DeRes,Force,Gib,Karma,Udamage,UnrealPawn)
    Abstract;

#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFPatch2.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KF_M79Snd.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx
#exec OBJ LOAD FILE=KFBossOld.ukx

var KFGibOS HeadStubOS;

var class <KFGibOS> HeadStubClassOS;
var class <KFGibOS> MonsterHeadGibletOS;
var class <KFGibOS> MonsterThighGibletOS;
var class <KFGibOS> MonsterArmGibletOS;
var class <KFGibOS> MonsterLegGibletOS;
var class <KFGibOS> MonsterTorsoGibletOS;
var class <KFGibOS> MonsterLowerTorsoGibletOS;

var Vector LastBloodHitDirection;

// Zed specific vars moved to their respective classes

// Enabling these via casting from the mutator "works"
// But it does not pass to child classes for whatever reason
// (KFMonsterOS has it enabled, but zeds that spawn won't)
//var bool bEnableOldHeadshotBehavior;
//var bool bDisableHealthScaling;
//var bool bEnableRandomSkins;

// contains textures for mixed zed variants
var protected array<material> MixTexturePool;
var protected array<material> MixHairPool;

var private bool bHeadSpawned;

// Zeds shouldn't be doing this at all
function bool CanGetOutOfWay()
{
    return false;
}

// shut these, since we dont' use them
simulated function SpawnSeveredGiblet(class<SeveredAppendage> GibClass, Vector Location, Rotator Rotation, float GibPerterbation, rotator SpawnRotation){}
simulated function SpawnGibs(Rotator HitRotation, float ChunkPerterbation){}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    // N.B. this must be commented at some point!
    // draw some accurate heads (i hope :D)
    // it will be deleted  on it's own
    if (!bHeadSpawned)
    {
        spawn(class'DebugHeadHitbox', self);
        bHeadSpawned = true;
    }

    SpawnClientExtendedZCollision();
}

// Fix client side projectors (i.e. ebr laser dot)
// NOTE: No special destroy code is needed. EZCollision is already
// destroyed on any zed that has it (not role-dependent).
final private function SpawnClientExtendedZCollision()
{
    local vector AttachPos;

    // Auth has already created this hitbox.
    if (Role == ROLE_Authority)
        return;

    if (bUseExtendedCollision && MyExtCollision == none)
    {
        MyExtCollision = spawn(class'ClientExtendedZCollision', self);
        // Slightly smaller version for non auth clients
        MyExtCollision.SetCollisionSize(ColRadius * 0.9f, ColHeight * 0.9f);

        MyExtCollision.bHardAttach = true;
        AttachPos = Location + (ColOffset >> Rotation);
        MyExtCollision.SetLocation(AttachPos);
        MyExtCollision.SetPhysics(PHYS_None);
        MyExtCollision.SetBase(self);
        SavedExtCollision = MyExtCollision.bCollideActors;
    }
}

function bool FlipOver()
{
    if( Physics==PHYS_Falling )
        SetPhysics(PHYS_Walking);

    bShotAnim = true;
    SetAnimAction('KnockDown');
    Acceleration = vect(0, 0, 0);
    Velocity.X = 0;
    Velocity.Y = 0;
    Controller.GoToState('WaitForAnim');
    KFMonsterController(Controller).Focus = none;
    KFMonsterController(Controller).FocalPoint = KFMonsterController(Controller).LastSeenPos;
    KFMonsterController(Controller).bUseFreezeHack = true;
    return true;
}

simulated function DoDamageFX( Name boneName, int Damage, class<DamageType> DamageType, Rotator r )
{
    local float DismemberProbability;
    local bool bDidSever;
    local bool bExtraGib;

    if ( FRand() > 0.3f || Damage > 30 || Health <= 0 )
    {
        HitFX[HitFxTicker].damtype = DamageType;

        if( Health <= 0  )
        {
            switch( boneName )
            {
                case 'Bip01 L Foot':
                    boneName = 'Bip01 L Thigh';
                    break;

                case 'Bip01 R Foot':
                    boneName = 'Bip01 R Thigh';
                    break;

                case 'Bip01 R Hand':
                    boneName = 'rfarm';
                    break;

                case 'Bip01 L Hand':
                    boneName = 'Bip01 L Forearm';
                    break;

                case 'Bip01 R Clavicle':
                case 'Bip01 L Clavicle':
                    boneName = 'Bip01 Spine';
                    break;
            }

            if( DamageType.default.bAlwaysSevers || (Damage == 1000) )
            {
                HitFX[HitFxTicker].bSever = true;
                bDidSever = true;
                if ( boneName == 'none' )
                {
                    boneName = 'Bip01 R Forearm';
                    bExtraGib = true;
                }
            }
            else if( (Damage*DamageType.default.GibModifier > 50+120*FRand()-9999999999) && (Damage >= 0) )
            {
                HitFX[HitFxTicker].bSever = true;
                boneName = 'Bip01 R Forearm';
                bExtraGib = true;
            }
            else
            {
                DismemberProbability = Abs( (Health - Damage*DamageType.default.GibModifier) / 130.0f );
                switch( boneName )
                {
                    case 'Bip01 L Thigh':
                    case 'Bip01 R Thigh':
                    case 'Bip01 R Forearm':
                    case 'Bip01 L Forearm':
                    case 'Bip01 Spine':
                    case 'Bip01 Head':
                        if( FRand() < DismemberProbability )
                            HitFX[HitFxTicker].bSever = true;
                        break;


                    case 'Bip01 Head':
                        boneName = 'Bip01 Head';
                     case 'Bip01 Head':
                        if( FRand() < DismemberProbability * 0.3 )
                        {
                            HitFX[HitFxTicker].bSever = true;
                            if ( FRand() < 0.65 )
                                bExtraGib = true;
                        }
                        break;
                }
            }
        }

        if ( DamageType.default.bNeverSevers || class'GameInfo'.static.UseLowGore() ||
           (Level.Game != none && Level.Game.PreventSever(self, boneName, Damage, DamageType)) )
        {
            HitFX[HitFxTicker].bSever = false;
            bDidSever = false;
            bExtraGib = false;
        }

        HitFX[HitFxTicker].bone = boneName;
        HitFX[HitFxTicker].rotDir = r;
        HitFxTicker = HitFxTicker + 1;

        if( HitFxTicker > ArrayCount(HitFX)-1 )
            HitFxTicker = 0;

        if ( bExtraGib )
        {
            if ( FRand() < 0.25 )
            {
                DoDamageFX('Bip01 L Forearm',1000,DamageType,r);
                DoDamageFX('Bip01 R Forearm',1000,DamageType,r);
            }
            else if ( FRand() < 0.35 )
                DoDamageFX('Bip01 L Thigh',1000,DamageType,r);
            else if ( FRand() < 0.5 )
                DoDamageFX('Bip01 Head',1000,DamageType,r);
            else
                DoDamageFX('Bip01 Head',1000,DamageType,r);
        }
    }
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    local float frame, rate;
    local name seq;
    local LavaDeath LD;
    local MiscEmmiter BE;

    if(bDecapitated)
    {
        HideBone('bip01 head');

        if (HeadStubOS == none && HeadStubClassOS != none)
        {
            HeadStubOS = Spawn(HeadStubClassOS,self);
            AttachToBone( HeadStubOS,'Bip01 head');
        }
    }

    if (Gored>0)
    {
        if (Gored == 1)
            HideBone('Bip01 L Clavicle');
        else if (Gored == 2)
            HideBone('Bip01 R Clavicle');
        else if (Gored == 3)
            HideBone('Bip01 Spine2');
        else if (Gored == 4)
            HideBone('Bip01 Spine1');
        else if (Gored == 5)
        {
            HideBone('Bip01');
            bHidden = true;
        }
    }

    AmbientSound = none;
    bCanTeleport = false;
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;
    StopBurnFX();

    if (CurrentCombo != none)
        CurrentCombo.Destroy();

    HitDamageType = DamageType;
    TakeHitLocation = HitLoc;

    bSTUNNED = false;
    bMovable = true;

    if ( class<DamTypeBurned>(DamageType) != none || class<DamTypeFlamethrower>(DamageType) != none )
    {
        ZombieCrispUp();
    }

    ProcessHitFX() ;

    if ( DamageType != none )
    {
        if ( DamageType.default.bSkeletize )
        {
            SetOverlayMaterial(DamageType.default.DamageOverlayMaterial, 4.0, true);
            if (!bSkeletized)
            {
                if ( (Level.NetMode != NM_DedicatedServer) && (SkeletonMesh != none) )
                {
                    if ( DamageType.default.bLeaveBodyEffect )
                    {
                        BE = spawn(class'MiscEmmiter',self);

                        if ( BE != none )
                        {
                            BE.DamageType = DamageType;
                            BE.HitLoc = HitLoc;
                            bFrozenBody = true;
                        }
                    }

                    GetAnimParams( 0, seq, frame, rate );
                    LinkMesh(SkeletonMesh, true);
                    Skins.Length = 0;
                    PlayAnim(seq, 0, 0);
                    SetAnimFrame(frame);
                }

                if (Physics == PHYS_Walking)
                    Velocity = Vect(0,0,0);

                SetTearOffMomemtum(GetTearOffMomemtum() * 0.25);
                bSkeletized = true;

                if ( (Level.NetMode != NM_DedicatedServer) && (DamageType == class'FellLava') )
                {
                    LD = spawn(class'LavaDeath', , , Location + vect(0, 0, 10), Rotation );

                    if ( LD != none )
                        LD.SetBase(self);

                    PlaySound( sound'KFOldSchoolZeds_Sounds.BExplosion5', SLOT_None, 1.5*TransientSoundVolume );
                }
            }
        }
        else if ( DamageType.default.DeathOverlayMaterial != none )
            SetOverlayMaterial(DamageType.default.DeathOverlayMaterial, DamageType.default.DeathOverlayTime, true);
        else if ( (DamageType.default.DamageOverlayMaterial != none) && (Level.DetailMode != DM_Low) && !Level.bDropDetail )
            SetOverlayMaterial(DamageType.default.DamageOverlayMaterial, 2*DamageType.default.DamageOverlayTime, true);
    }


    AnimBlendParams(1, 0.0);
    FireState = FS_None;

    GotoState('ZombieDyingOS');

    if ( BE != none )
        return;

    PlayDyingAnimation(DamageType, HitLoc);
}

State ZombieDyingDecay extends ZombieDying
{
    ignores AnimEnd, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer, Died, RangedAttack, TakeDamage;
}

//Until I can fix Decay not being enabled, I'll make corpses decay & not eat bullets here
State ZombieDyingOS extends Dying
{
ignores AnimEnd, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer, Died, RangedAttack;

    function bool CanGetOutOfWay()
    {
        return false;
    }

    simulated function Landed(vector HitNormal)
    {
        SetPhysics(PHYS_None);
        SetCollision(false, false, false);

        if ( !IsAnimating(0) )
            LandThump();

        super.Landed(HitNormal);
    }

    simulated function Timer()
    {
        if( Level.NetMode==NM_DedicatedServer )
        {
            Destroy();
            return;
        }

        if( Physics!=PHYS_None )
        {
            if( VSize(Velocity)>10 )
            {
                SetTimer(1,false);
                return;
            }

            //This just spams the clients log, get rid of it
            //Disable('TakeDamage');
            SetPhysics(PHYS_None);
            SetTimer(30,false);

            if(PlayerShadow != none)
                PlayerShadow.bShadowActive = false;
        }
        else if( (Level.TimeSeconds-LastRenderTime)>40 || Level.bDropDetail )
            Destroy();
        else SetTimer(5,false);
    }

    simulated function BeginState()
    {
        if( Controller!=none )
            Controller.Destroy();

        if( Level.NetMode==NM_DedicatedServer )
            SetTimer(1,false);

        //Don't eat bullets or block shit
        bBlockHitPointTraces=false;
        bBlockPlayers=false;
        bBlockProjectiles=false;
        SetTimer(5,false);
     }
}

simulated function ProcessHitFX()
{
    local Coords boneCoords;
    local class<xEmitter> HitEffects[4];
    local int i,j;
    local float GibPerterbation;

    if( (Level.NetMode == NM_DedicatedServer) || bSkeletized || (Mesh == SkeletonMesh))
    {
        SimHitFxTicker = HitFxTicker;
        return;
    }

    for ( SimHitFxTicker = SimHitFxTicker; SimHitFxTicker != HitFxTicker; SimHitFxTicker = (SimHitFxTicker + 1) % ArrayCount(HitFX) )
    {
        j++;
        if ( j > 30 )
        {
            SimHitFxTicker = HitFxTicker;
            return;
        }

        if( (HitFX[SimHitFxTicker].damtype == none) || (Level.bDropDetail && (Level.TimeSeconds - LastRenderTime > 3) && !IsHumanControlled()) )
            continue;

        boneCoords = GetBoneCoords( HitFX[SimHitFxTicker].bone );

        if ( !Level.bDropDetail && !class'GameInfo'.static.NoBlood() && !bSkeletized && !class'GameInfo'.static.UseLowGore())
        {
            AttachEffect( GibGroupClass.static.GetBloodEmitClass(), HitFX[SimHitFxTicker].bone, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir );

            HitFX[SimHitFxTicker].damtype.static.GetHitEffects( HitEffects, Health );

            if( !PhysicsVolume.bWaterVolume )
            {
                for( i = 0; i < ArrayCount(HitEffects); i++ )
                {
                    if( HitEffects[i] == none )
                        continue;

                      AttachEffect( HitEffects[i], HitFX[SimHitFxTicker].bone, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir );
                }
            }
        }

        if( HitFX[SimHitFxTicker].bSever )
        {
            GibPerterbation = HitFX[SimHitFxTicker].damtype.default.GibPerterbation;
            bFlaming = HitFX[SimHitFxTicker].DamType.default.bFlaming;

            switch( HitFX[SimHitFxTicker].bone )
            {
                case 'Bip01 L Thigh':
                case 'Bip01 R Thigh':
                    Spawn(class'BrainSplashOS',,,boneCoords.Origin,self.Rotation);
                    SpawnGiblet( GetGibClass(EGT_Calf), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                    SpawnGiblet( GetGibClass(EGT_Calf), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                    PlaySound(sound'KFOldSchoolZeds_Sounds.Shared.Gibbing_Sound1', SLOT_Misc,255);
                    GibCountCalf -= 2;
                    break;
                case 'Bip01 R Forearm':
                case 'Bip01 L Forearm':
                    Spawn(class'BrainSplashOS',,,boneCoords.Origin,self.Rotation);
                    SpawnGiblet( GetGibClass(EGT_UpperArm), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                    SpawnGiblet( GetGibClass(EGT_Forearm), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                    PlaySound(sound'KFOldSchoolZeds_Sounds.Shared.Gibbing_Sound2', SLOT_Misc,255);
                    GibCountForearm--;
                    GibCountUpperArm--;
                    break;
                case 'Bip01 Head':
                    Spawn(class'BrainSplashOS',,,boneCoords.Origin,self.Rotation);
                    SpawnGiblet( GetGibClass(EGT_Head), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                    PlaySound(sound'KFOldSchoolZeds_Sounds.Shared.Gibbing_Sound2', SLOT_Misc,255);
                    GibCountTorso--;
                    break;
                case 'Bip01 Spine':
                case 'Bip01 Spine':
                    SpawnGiblet( GetGibClass(EGT_Torso), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                    PlaySound(sound'KFOldSchoolZeds_Sounds.Shared.Gibbing_Sound3', SLOT_Misc,255);
                    GibCountTorso--;
                    bGibbed = true;
                    while( GibCountHead-- > 0 )
                        SpawnGiblet( GetGibClass(EGT_Head), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                    while( GibCountForearm-- > 0 )
                        SpawnGiblet( GetGibClass(EGT_UpperArm), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                    while( GibCountUpperArm-- > 0 )
                        SpawnGiblet( GetGibClass(EGT_Forearm), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                    if ( !bFlaming && !Level.bDropDetail && (Level.DetailMode != DM_Low) && PlayerCanSeeMe() )
                    {
                        GibPerterbation = FMin(1.0, 1.5 * GibPerterbation);
                        PlaySound(sound'KFOldSchoolZeds_Sounds.Shared.Gibbing_Sound4', SLOT_Misc,255);
                                                SpawnGiblet( GetGibClass(EGT_Calf), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                        SpawnGiblet( GetGibClass(EGT_Calf), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                        SpawnGiblet( GetGibClass(EGT_UpperArm), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                        SpawnGiblet( GetGibClass(EGT_Forearm), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                    }
                    break;
            }

            if (!bDecapitated)
                HideBone(HitFX[SimHitFxTicker].bone);
        }
    }
}

simulated function DecapFX( Vector DecapLocation, Rotator DecapRotation, bool bSpawnDetachedHead, optional bool bNoBrainBits )
{
    local float GibPerterbation;
    local BrainSplashOS SplatExplosion;

    if ( class'GameInfo'.static.UseLowGore() )
    {
        CuteDecapFX();

        return;
    }

    bNoBrainBitEmitter = bNoBrainBits;

    GibPerterbation = 0.060000;

    if(bSpawnDetachedHead)
    {
       SpecialHideHead();
    }
    else
    {
        HideBone(HeadBone);
    }


    if ( !bSpawnDetachedHead && !bNoBrainBits && EffectIsRelevant(DecapLocation,false) )
    {
        SpawnGiblet( class'KFGibBrainOS',DecapLocation, self.Rotation, GibPerterbation) ;
        SpawnGiblet( class'KFGibBrainbOS',DecapLocation, self.Rotation, GibPerterbation) ;
        SpawnGiblet( class'KFGibBrainOS',DecapLocation, self.Rotation, GibPerterbation) ;
    }
    SplatExplosion = Spawn(class 'BrainSplashOS',self,, DecapLocation );
}

// swapped SeveredHead with HeadStubOS
simulated function SpecialHideHead()
{
    local int BoneScaleSlot;
    local coords boneCoords;

    if (HeadStubOS == none && HeadStubClassOS != none)
    {
        boneScaleSlot = 4;
        HeadStubOS = Spawn(HeadStubClassOS,self);
        boneCoords = GetBoneCoords('Bip01 Head');
        AttachToBone(HeadStubOS, 'Bip01 Head');
    }
    else
    {
        return;
    }
    SetBoneScale(BoneScaleSlot, 0.0, 'Bip01 Head');
}

simulated function CuteDecapFX()
{
    local int LeftRight;

    LeftRight = 1;

    if ( rand(10) > 5 )
    {
        LeftRight = -1;
    }

    NeckRot.Yaw = -clamp(rand(24000), 14000, 24000);
    NeckRot.Roll = LeftRight * clamp(rand(8000), 2000, 8000);
    NeckRot.Pitch =  LeftRight * clamp(rand(12000), 2000, 12000);
    // was 'neck'
    SetBoneRotation('Bip01 Neck', NeckRot);
    RemoveHead();
}

simulated function HideBone(name boneName)
{
    local int BoneScaleSlot;

    if( boneName == 'lthigh' )
        boneScaleSlot = 0;
    else if ( boneName == 'rthigh' )
        boneScaleSlot = 1;
    else if( boneName == 'rfarm' )
        boneScaleSlot = 2;
    else if ( boneName == 'lfarm' )
        boneScaleSlot = 3;
    else if ( boneName == 'head' )
        boneScaleSlot = 4;
    else if ( boneName == 'spine' )
        boneScaleSlot = 5;

    SetBoneScale(BoneScaleSlot, 0.0, BoneName);
}

simulated function Tick(float DeltaTime)
{
    local PlayerController P;
    local float DistSquared;
    local float GibPerterbation;
    local BrainSplashOS SplatExplosion;
    local Vector SplatLocation;
    local Rotator R;
    local GibExplosionOS GibbedExplosion;

    if (AnimAction == 'KnockDown')
    {
        Acceleration = vect(0,0,0);
        Velocity = vect(0,0,0);
    }


    if( bDestroyNextTick && TimeSetDestroyNextTickTime < Level.TimeSeconds )
    {
        Destroy();
    }

    if ( Level.NetMode != NM_Client && CanSpeedAdjust() )
    {
        if ( Level.NetMode == NM_Standalone )
        {
            if ( Level.TimeSeconds - LastRenderTime > 5.0 )
            {
                P = Level.GetLocalPlayerController();

                if ( P != none && P.Pawn != none )
                {
                    if ( Level.TimeSeconds - LastViewCheckTime > 1.0 )
                    {
                        LastViewCheckTime = Level.TimeSeconds;
                        DistSquared = VSizeSquared(P.Pawn.Location - Location);
                        if( (!P.Pawn.Region.Zone.bDistanceFog || (DistSquared < Square(P.Pawn.Region.Zone.DistanceFogEnd))) &&
                            FastTrace(Location + EyePosition(), P.Pawn.Location + P.Pawn.EyePosition()) )
                        {
                            LastSeenOrRelevantTime = Level.TimeSeconds;
                            SetGroundSpeed(GetOriginalGroundSpeed());
                        }
                        else
                        {
                            SetGroundSpeed(default.GroundSpeed * (HiddenGroundSpeed / default.GroundSpeed));
                        }
                    }
                }
            }
            else
            {
                LastSeenOrRelevantTime = Level.TimeSeconds;
                SetGroundSpeed(GetOriginalGroundSpeed());
            }
        }
        else if ( Level.NetMode == NM_DedicatedServer )
        {
            if ( Level.TimeSeconds - LastReplicateTime > 0.5 )
            {
                SetGroundSpeed(default.GroundSpeed * (300.0 / default.GroundSpeed));
            }
            else
            {
                LastSeenOrRelevantTime = Level.TimeSeconds;
                SetGroundSpeed(GetOriginalGroundSpeed());
            }
        }
        else if ( Level.NetMode == NM_ListenServer )
        {
            if ( Level.TimeSeconds - LastReplicateTime > 0.5 && Level.TimeSeconds - LastRenderTime > 5.0 )
            {
                P = Level.GetLocalPlayerController();

                if ( P != none && P.Pawn != none )
                {
                    if ( Level.TimeSeconds - LastViewCheckTime > 1.0 )
                    {
                        LastViewCheckTime = Level.TimeSeconds;
                        DistSquared = VSizeSquared(P.Pawn.Location - Location);

                        if ( (!P.Pawn.Region.Zone.bDistanceFog || (DistSquared < Square(P.Pawn.Region.Zone.DistanceFogEnd))) &&
                            FastTrace(Location + EyePosition(), P.Pawn.Location + P.Pawn.EyePosition()) )
                        {
                            LastSeenOrRelevantTime = Level.TimeSeconds;
                            SetGroundSpeed(GetOriginalGroundSpeed());
                        }
                        else
                        {
                            SetGroundSpeed(default.GroundSpeed * (300.0 / default.GroundSpeed));
                        }
                    }
                }
            }
            else
            {
                LastSeenOrRelevantTime = Level.TimeSeconds;
                SetGroundSpeed(GetOriginalGroundSpeed());
            }
        }
    }

    if ( bResetAnimAct && ResetAnimActTime<Level.TimeSeconds )
    {
        AnimAction = '';
        bResetAnimAct = false;
    }

    if ( Controller != none )
    {
        LookTarget = Controller.Enemy;
    }

    if ( Role == ROLE_Authority && bDecapitated )
    {
        if ( BleedOutTime > 0 && Level.TimeSeconds - BleedOutTime >= 0 )
        {
            Died(LastDamagedBy.Controller,class'DamTypeBleedOut',Location);
            BleedOutTime=0;
        }

    }

    if ( Level.NetMode!=NM_DedicatedServer )
    {
        TickFX(DeltaTime);
        if( LookTarget!=none && Health >= 1 )
        {
            R = Normalize(rotator(LookTarget.Location-Location)-Rotation);
            R.Pitch = 0;
            R.Roll = 0;
            if( R.Yaw>18000 )
                R.Yaw = 18000;
            else if( R.Yaw<-18000 )
                R.Yaw = -18000;
            R.Pitch = R.Yaw;
            R.Yaw = 0;
            SetBoneDirection('Bip01 Head',R*-1.8,,0.5);
        }
        else SetBoneDirection('Bip01 Head',rot(0,0,0),,0.5);

        if ( bBurnified && !bBurnApplied )
        {
            if ( !bGibbed )
            {
                StartBurnFX();
            }
        }
        else if ( !bBurnified && bBurnApplied )
        {
            StopBurnFX();
        }

        if ( bAshen && Level.NetMode == NM_Client && !class'GameInfo'.static.UseLowGore() )
        {
            ZombieCrispUp();
            bAshen = false;
        }

        if(bDecapitated && !bPlayBrainSplash )
        {
            SplatLocation = self.Location;
            SplatLocation.z += CollisionHeight;
            GibPerterbation = 0.060000;
            HideBone('bip01 head');
            if (HeadStubOS == none && HeadStubClassOS != none)
            {
                HeadStubOS = Spawn(HeadStubClassOS,self,'',Location);
                AttachToBone( HeadStubOS,'Bip01 head');
            }
            if ( EffectIsRelevant(Location,false) )
            {
                SpawnGiblet( class'KFGibBrainOS',SplatLocation, self.Rotation, GibPerterbation ) ;
                SpawnGiblet( class'KFGibBrainbOS',SplatLocation, self.Rotation, GibPerterbation ) ;
                SpawnGiblet( class'KFGibBrainOS',SplatLocation, self.Rotation, GibPerterbation ) ;
            }
            SplatExplosion = Spawn(class 'BrainSplashOS',self,, SplatLocation );
            bPlayBrainSplash = true;
        }
        if (Gored>0 && !bPlayGoreSplash)
        {
            SplatLocation = self.Location;
            SplatLocation.z += (CollisionHeight - (CollisionHeight * 0.5));
            GibPerterbation = 0.060000;

            if (Gored == 1)
                HideBone('Bip01 L Clavicle');
            else if (Gored == 2)
                HideBone('Bip01 R Clavicle');
            else if (Gored == 3)
            {
                HideBone('Bip01 Spine2');

                if (GoredMat != none)
                    Skins[0] = GoredMat;
            }
            else if (Gored == 4)
                HideBone('Bip01 Spine1');


            if ( EffectIsRelevant(Location,false) && Gored < 5 )
            {
                Spawn(class'BrainSplashOS',,,SplatLocation,self.Rotation);
                SpawnGiblet( class'KFGibBrainOS',SplatLocation, self.Rotation, GibPerterbation ) ;
                SpawnGiblet( class'KFGibBrainbOS',SplatLocation, self.Rotation, GibPerterbation ) ;
                SpawnGiblet( class'KFGibBrainOS',SplatLocation, self.Rotation, GibPerterbation ) ;
            }
            else if ( EffectIsRelevant(Location,false) && Gored == 5 )
            {

                Spawn(class'BodySplashOS',,,SplatLocation,self.Rotation);

                if (!bDecapitated)
                    SpawnGiblet(MonsterHeadGibletOS,SplatLocation, self.Rotation, GibPerterbation ) ;

                SpawnGiblet(MonsterTorsoGibletOS,SplatLocation, self.Rotation, GibPerterbation ) ;
                SpawnGiblet(MonsterLowerTorsoGibletOS,SplatLocation, self.Rotation, GibPerterbation ) ;

                SpawnGiblet(MonsterArmGibletOS,SplatLocation, self.Rotation, GibPerterbation ) ;
                SpawnGiblet(MonsterArmGibletOS,SplatLocation, self.Rotation, GibPerterbation ) ;

                SpawnGiblet(MonsterThighGibletOS,SplatLocation, self.Rotation, GibPerterbation ) ;
                SpawnGiblet(MonsterThighGibletOS,SplatLocation, self.Rotation, GibPerterbation ) ;

                SpawnGiblet(MonsterLegGibletOS,SplatLocation, self.Rotation, GibPerterbation ) ;
                SpawnGiblet(MonsterLegGibletOS,SplatLocation, self.Rotation, GibPerterbation ) ;

                GibbedExplosion = Spawn(class'GibExplosionOS',self,, SplatLocation );

            }

            SplatExplosion = Spawn(class 'BrainSplashOS',self,, SplatLocation );
            bPlayGoreSplash = true;
        }
    }

    if ( DECAP )
    {
        if ( Level.TimeSeconds > (DecapTime + 2.0) && Controller != none )
        {
            DECAP = false;
            MonsterController(Controller).ExecuteWhatToDoNext();
        }
    }

    if ( BileCount > 0 && NextBileTime<level.TimeSeconds )
    {
        --BileCount;
        NextBileTime+=BileFrequency;
        TakeBileDamage();
    }

    if( bZapped && Role == ROLE_Authority )
    {
        RemainingZap -= DeltaTime;

        if( RemainingZap <= 0 )
        {
            RemainingZap = 0;
            bZapped = false;
            ZappedBy = none;
            ZapThreshold *= ZapResistanceScale;
        }
    }

    if( !bZapped && TotalZap > 0 && ((Level.TimeSeconds - LastZapTime) > 0.1)  )
    {
        TotalZap -= DeltaTime;
    }

    if( bZapped != bOldZapped )
    {
        if( bZapped )
        {
            SetZappedBehavior();
        }
        else
        {
            UnSetZappedBehavior();
        }

        bOldZapped = bZapped;
    }

    if( bHarpoonStunned != bOldHarpoonStunned )
    {
        if( bHarpoonStunned )
        {
            SetBurningBehavior();
        }
        else
        {
            UnSetBurningBehavior();
        }

        bOldHarpoonStunned = bHarpoonStunned;
    }
}

//Slow rage from burn damage fix
function TakeFireDamage(int Damage,pawn Instigator)
{
    local Vector DummyHitLoc,DummyMomentum;

    TakeDamage(Damage, BurnInstigator, DummyHitLoc, DummyMomentum, FireDamageClass);

    if ( BurnDown > 0 )
    {
        // Decrement the number of FireDamage calls left before our Zombie is extinguished :)
        BurnDown --;
    }

    // Melt em' :)
    if ( BurnDown < CrispUpThreshhold )
    {
        ZombieCrispUp();
    }

    if ( BurnDown == 0 )
    {
        bBurnified = false;
        if( !bZapped )
        {
            SetGroundSpeed(GetOriginalGroundSpeed());
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
        SetAnimAction('Claw');
        PlaySound(sound'Claw2s', SLOT_None);
        return;
    }
}


function ClawDamageTarget()
{
    local vector PushDir;
    local float UsedMeleeDamage;

    if( MeleeDamage > 1 )
    {
       UsedMeleeDamage = (MeleeDamage - (MeleeDamage * 0.05)) + (MeleeDamage * (FRand() * 0.1));
    }
    else
    {
       UsedMeleeDamage = MeleeDamage;
    }

    if(Controller!=none && Controller.Target!=none)
        PushDir = (damageForce * Normal(Controller.Target.Location - Location));
    else PushDir = damageForce * vector(Rotation);

    if ( MeleeDamageTarget(UsedMeleeDamage, PushDir) )
        PlayZombieAttackHitSound();
}

function PlayZombieAttackHitSound()
{
    local int MeleeAttackSounds;

    MeleeAttackSounds = rand(4);

    switch(MeleeAttackSounds)
    {
        case 0:
            PlaySound(sound'KFOldSchoolZeds_Sounds.Melee_Hit1', SLOT_Interact);
            break;
        case 1:
            PlaySound(sound'KFOldSchoolZeds_Sounds.Melee_Hit2', SLOT_Interact);
            break;
        case 2:
            PlaySound(sound'KFOldSchoolZeds_Sounds.Melee_Hit3', SLOT_Interact);
            break;
        case 3:
            PlaySound(sound'KFOldSchoolZeds_Sounds.Melee_Hit4', SLOT_Interact);
            break;
    }
}

function BodyPartRemoval(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
    local float Threshold;

    if ( Health - Damage < 0)
    {
        if( DamageType.name != 'DamTypeShotgun' && DamageType.name != 'DamTypeDBShotgun' && DamageType.name != 'DamTypeAxe')
            Threshold = 0.5;
                else
            Threshold = 0.25;

        if ((Health - Damage) < (0-(Threshold * HealthMax)) && (Health - Damage) > (0-((Threshold * 1.2) * HealthMax)) )
            Gored = rand(4)+1;
                else
        if ((Health - Damage) <= (0-(1.0 * HealthMax)))
            {
                if( damageType == class 'DamTypeFrag' || damageType == class 'DamTypeLAW' ||
                damageType == class 'DamTypeM79Grenade' || damageType == class 'DamTypeM203Grenade' ||
                damageType == class 'DamTypePipeBomb' || damageType == class 'DamTypeSealSquealExplosion')
                    Gored = 5;
            }
        if(Gored > 0)
        {
            if( instigatedBy!=none )
                Died(instigatedBy.Controller,damageType,hitlocation);
                else Died(none,damageType,hitlocation);
        }


    }

}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType, optional int HitIndex )
{
    local bool bIsHeadshot;
    local KFPlayerReplicationInfo KFPRI;
    local float HeadShotCheckScale;

    LastDamagedBy = instigatedBy;
    LastDamagedByType = damageType;
    HitMomentum = VSize(momentum);
    LastHitLocation = hitlocation;
    LastMomentum = momentum;

    if ( KFPawn(instigatedBy) != none && instigatedBy.PlayerReplicationInfo != none )
    {
        KFPRI = KFPlayerReplicationInfo(instigatedBy.PlayerReplicationInfo);
    }

    // Scale damage if the Zed has been zapped
    if( bZapped )
    {
        Damage *= ZappedDamageMod;
    }

    // Zeds and fire dont mix.
    if ( class<KFWeaponDamageType>(damageType) != none && class<KFWeaponDamageType>(damageType).default.bDealBurningDamage )
    {
        if( BurnDown<=0 || Damage > LastBurnDamage )
        {
             // LastBurnDamage variable is storing last burn damage (unperked) received,
            // which will be used to make additional damage per every burn tick (second).
            LastBurnDamage = Damage;

            // FireDamageClass variable stores damage type, which started zed's burning
            // and will be passed to this function again every next burn tick (as damageType argument)
            if ( class<DamTypeTrenchgun>(damageType) != none ||
                 class<DamTypeFlareRevolver>(damageType) != none ||
                 class<DamTypeMAC10MPInc>(damageType) != none)
            {
                 FireDamageClass = damageType;
            }
            else
            {
                FireDamageClass = class'DamTypeFlamethrower';
            }
        }

        if ( class<DamTypeMAC10MPInc>(damageType) == none )
        {
            Damage *= 1.5; // Increase burn damage 1.5 times, except MAC10.
        }

        // BurnDown variable indicates how many ticks are remaining for zed to burn.
        // It is 0, when zed isn't burning (or stopped burning).
        // So all the code below will be executed only, if zed isn't already burning
        if( BurnDown<=0 )
        {
            if( HeatAmount>4 || Damage >= 15 )
            {
                bBurnified = true;
                BurnDown = 10; // Inits burn tick count to 10
                SetGroundSpeed(GroundSpeed *= 0.80); // Lowers movement speed by 20%
                BurnInstigator = instigatedBy;
                SetTimer(1.0,false); // Sets timer function to be executed each second
            }
            else HeatAmount++;
        }
    }

    if ( !bDecapitated && class<KFWeaponDamageType>(damageType)!=none &&
        class<KFWeaponDamageType>(damageType).default.bCheckForHeadShots )
    {
        HeadShotCheckScale = 1.0;

        // Do larger headshot checks if it is a melee attach
        if( class<DamTypeMelee>(damageType) != none )
        {
            HeadShotCheckScale *= 1.25;
        }

        bIsHeadShot = IsHeadShot(hitlocation, normal(momentum), HeadShotCheckScale);
        bLaserSightedEBRM14Headshotted = bIsHeadshot && M14EBRBattleRifle(instigatedBy.Weapon) != none && M14EBRBattleRifle(instigatedBy.Weapon).bLaserActive;
    }
    else
    {
        bLaserSightedEBRM14Headshotted = bLaserSightedEBRM14Headshotted && bDecapitated;
    }

    if ( KFPRI != none  )
    {
        if ( KFPRI.ClientVeteranSkill != none )
        {
            Damage = KFPRI.ClientVeteranSkill.Static.AddDamage(KFPRI, self, KFPawn(instigatedBy), Damage, DamageType);
        }
    }

    if ( damageType != none && LastDamagedBy.IsPlayerPawn() && LastDamagedBy.Controller != none )
    {
        if ( KFMonsterController(Controller) != none )
        {
            KFMonsterController(Controller).AddKillAssistant(LastDamagedBy.Controller, FMin(Health, Damage));
        }
    }

    if ( (bDecapitated || bIsHeadShot) && class<DamTypeBurned>(DamageType) == none && class<DamTypeFlamethrower>(DamageType) == none )
    {
        if(class<KFWeaponDamageType>(damageType)!=none)
            Damage = Damage * class<KFWeaponDamageType>(damageType).default.HeadShotDamageMult;

        if ( class<DamTypeMelee>(damageType) == none && KFPRI != none &&
             KFPRI.ClientVeteranSkill != none )
        {
            Damage = float(Damage) * KFPRI.ClientVeteranSkill.Static.GetHeadShotDamMulti(KFPRI, KFPawn(instigatedBy), DamageType);
        }

        LastDamageAmount = Damage;

        if( !bDecapitated )
        {
            if( bIsHeadShot )
            {
                // Play a sound when someone gets a headshot TODO: Put in the real sound here
                if( bIsHeadShot )
                {
                    PlaySound(sound'KF_EnemyGlobalSndTwo.Impact_Skull', SLOT_None,2.0,true,500);
                }
                HeadHealth -= LastDamageAmount;
                if( HeadHealth <= 0 || Damage > Health )
                {
                   RemoveHead();
                }
            }

            // Award headshot here, not when zombie died.
            if( bDecapitated && Class<KFWeaponDamageType>(damageType) != none && instigatedBy != none && KFPlayerController(instigatedBy.Controller) != none )
            {
                bLaserSightedEBRM14Headshotted = M14EBRBattleRifle(instigatedBy.Weapon) != none && M14EBRBattleRifle(instigatedBy.Weapon).bLaserActive;
                Class<KFWeaponDamageType>(damageType).Static.ScoredHeadshot(KFSteamStatsAndAchievements(PlayerController(instigatedBy.Controller).SteamStatsAndAchievements), self.Class, bLaserSightedEBRM14Headshotted);
            }
        }
    }

    // Client check for Gore FX
    BodyPartRemoval(Damage,instigatedBy,hitlocation,momentum,damageType);

    if( Health-Damage > 0 && DamageType!=class'DamTypeFrag' && DamageType!=class'DamTypePipeBomb'
        && DamageType!=class'DamTypeM79Grenade' && DamageType!=class'DamTypeM32Grenade'
        && DamageType!=class'DamTypeM203Grenade' && DamageType!=class'DamTypeDwarfAxe'
        && DamageType!=class'DamTypeSPGrenade' && DamageType!=class'DamTypeSealSquealExplosion'
        && DamageType!=class'DamTypeSeekerSixRocket')
    {
        Momentum = vect(0,0,0);
    }

    if(class<DamTypeVomit>(DamageType)!=none) // Same rules apply to zombies as players.
    {
        BileCount=7;
        BileInstigator = instigatedBy;
        LastBileDamagedByType=class<DamTypeVomit>(DamageType);
        if(NextBileTime< Level.TimeSeconds )
            NextBileTime = Level.TimeSeconds+BileFrequency;
    }

    if ( KFPRI != none && Health-Damage <= 0 && KFPRI.ClientVeteranSkill != none && KFPRI.ClientVeteranSkill.static.KilledShouldExplode(KFPRI, KFPawn(instigatedBy)) )
    {
        Super(pawn).takeDamage(Damage + 600, instigatedBy, hitLocation, momentum, damageType);
        HurtRadius(500, 1000, class'DamTypeFrag', 100000, Location);
    }
    else
    {
        Super(pawn).takeDamage(Damage, instigatedBy, hitLocation, momentum, damageType);
    }

    if( bIsHeadShot && Health <= 0 )
    {
       KFGameType(Level.Game).DramaticEvent(0.03);
    }

    bBackstabbed = false;
}

function PlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum, optional int HitIdx )
{
    local Vector HitNormal;
    local Vector HitRay ;
    local Name HitBone;
    local float HitBoneDist;
    local PlayerController PC;
    local bool bShowEffects, bRecentHit;
    local BloodSpurtOS BloodHit;

    bRecentHit = Level.TimeSeconds - LastPainTime < 0.2;

    LastDamageAmount = Damage;

    if(KFMonsterController(Controller).bUseFreezeHack == false)
        OldPlayHit(Damage, InstigatedBy, HitLocation, DamageType,Momentum);


    if ( Damage <= 0 )
        return;

    if( Health>0 && Damage>(float(default.Health)/1.5) )
        FlipOver();

    PC = PlayerController(Controller);
    bShowEffects = ( (Level.NetMode != NM_Standalone) || (Level.TimeSeconds - LastRenderTime < 2.5)
                    || ((InstigatedBy != none) && (PlayerController(InstigatedBy.Controller) != none))
                    || (PC != none) );
    if ( !bShowEffects )
        return;

    if ( BurnDown > 0 && !bBurnified )
    {
        bBurnified = true;
    }

    HitRay = vect(0,0,0);

    if( InstigatedBy != none )
        HitRay = Normal(HitLocation-(InstigatedBy.Location+(vect(0,0,1)*InstigatedBy.EyeHeight)));

    if( DamageType.default.bLocationalHit )
    {
        CalcHitLoc( HitLocation, HitRay, HitBone, HitBoneDist );

        if ( bZapped && DamageType.name != 'DamTypeZEDGun' )
        {
            PlaySound(class'ZedGunProjectile'.default.ExplosionSound,,class'ZedGunProjectile'.default.ExplosionSoundVolume);
            Spawn(class'ZedGunProjectile'.default.ExplosionEmitter,,,HitLocation + HitNormal*20,rotator(HitNormal));
        }
    }
    else
    {
        HitLocation = Location ;
        HitBone = FireRootBone;
        HitBoneDist = 0.0f;
    }

    if( DamageType.default.bAlwaysSevers && DamageType.default.bSpecial )
        HitBone = 'head';

    if( InstigatedBy != none )
        HitNormal = Normal( Normal(InstigatedBy.Location-HitLocation) + VRand() * 0.2 + vect(0,0,2.8) );
    else
        HitNormal = Normal( Vect(0,0,1) + VRand() * 0.2 + vect(0,0,2.8) );

    if ( DamageType.default.bCausesBlood && DamageType != class 'Burned' )
    {
        if ( class'GameInfo'.static.UseLowGore() )
        {
            if ( class'GameInfo'.static.NoBlood() )
                BloodHit = BloodSpurtOS(Spawn( GibGroupClass.default.NoBloodHitClass,InstigatedBy,, HitLocation ));
            else
                BloodHit = BloodSpurtOS(Spawn( GibGroupClass.default.LowGoreBloodHitClass,InstigatedBy,, HitLocation ));
        }
        else BloodHit = BloodSpurtOS(Spawn(GibGroupClass.default.BloodHitClass,InstigatedBy,, HitLocation, Rotator(HitNormal)));

        if ( BloodHit != none )
        {
            BloodHit.bMustShow = !bRecentHit;
            if ( Momentum != vect(0,0,0) )
            {
                BloodHit.HitDir = Momentum;
                LastBloodHitDirection = BloodHit.HitDir;
            }
            else
            {
                if ( InstigatedBy != none )
                    BloodHit.HitDir = Location - InstigatedBy.Location;
                else
                    BloodHit.HitDir = Location - HitLocation;
                BloodHit.HitDir.Z = 0;
            }
        }
    }

    if ( (DamageType.name == 'DamTypeShotgun' || DamageType.name == 'DamTypeDBShotgun' || DamageType.name == 'DamTypeFrag') && (Health < 0) && (InstigatedBy != none) && (VSize(InstigatedBy.Location - Location) < 350) )
        DoDamageFX( HitBone, 800*Damage, DamageType, Rotator(HitNormal) );
    else
        DoDamageFX( HitBone, Damage, DamageType, Rotator(HitNormal) );

    if (DamageType.default.DamageOverlayMaterial != none && Damage > 0 )
        SetOverlayMaterial( DamageType.default.DamageOverlayMaterial, DamageType.default.DamageOverlayTime, false );
}

// added HeadStubOS
simulated function Destroyed()
{
    if (HeadStubOS != none)
        HeadStubOS.Destroy();

    super.Destroyed();
}

//todo: simplify using int i?
simulated function ZombieCrispUp()
{
    local int i;
    super.ZombieCrispUp();

    for (i = 0; i < Skins.Length; i++)
    {
        Skins[i]=Texture'KFOldSchoolZeds_Textures.Shared.BurntZedSkin';
    }
}

simulated function SetBurningBehavior()
{
    if( Role == Role_Authority )
    {
        Intelligence = BRAINS_Retarded;

        SetGroundSpeed(OriginalGroundSpeed * 0.8);
        AirSpeed *= 0.8;
        WaterSpeed *= 0.8;

        if( Controller != none )
        {
           MonsterController(Controller).Accuracy = -5;
        }
    }


}

// copy-paste, just to replace the blood streak decal
event KImpact(actor other, vector pos, vector impactVel, vector impactNorm)
{
    local int numSounds, soundNum;
    local vector WallHit, WallNormal;
    local Actor WallActor;
    local KFBloodStreakDecalOS Streak;
    local float VelocitySquared;
    local float RagHitVolume;
    local float StreakDist;

    numSounds = RagImpactSounds.Length;

    if ( LastStreakLocation == vect(0,0,0) )
    {
        StreakDist = 0;
    }
    else
    {
        StreakDist = VSizeSquared(LastStreakLocation - pos);
    }

    LastStreakLocation = pos;

    WallActor = Trace(WallHit, WallNormal, pos - impactNorm * 16, pos + impactNorm * 16, false);

    if ( WallActor != none && Level.TimeSeconds > LastStreakTime + BloodStreakInterval && !class'GameInfo'.static.UseLowGore() )
    {
        if ( StreakDist < 1400 )
        {
           return;
        }
        Streak = spawn(class'KFBloodStreakDecalOS',,, WallHit, rotator(-WallNormal));

        LastStreakTime = Level.TimeSeconds;
    }

    if ( numSounds > 0 && Level.TimeSeconds > RagLastSoundTime + RagImpactSoundInterval )
    {
        VelocitySquared = VSizeSquared(impactVel);
        RagHitVolume = FMin(2.0, (VelocitySquared / 40000));
        soundNum = Rand(numSounds);

        PlaySound(RagImpactSounds[soundNum], SLOT_None, RagHitVolume);
        RagLastSoundTime = Level.TimeSeconds;
    }
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
    AmbientSound = none;
    super.Died( Killer, damageType, HitLocation );
}

defaultproperties
{
    MixTexturePool(0)=Texture'KFOldSchoolZeds_Textures.Bloat.BloatSkin'
    MixTexturePool(1)=Texture'KFOldSchoolZeds_Textures.Clot.ClotSkin'
    MixTexturePool(2)=Texture'KFOldSchoolZeds_Textures.Clot.ClotSkinVariant2'
    MixTexturePool(3)=Texture'KFOldSchoolZeds_Textures.Crawler.CrawlerSkin'
    MixTexturePool(4)=Texture'KFOldSchoolZeds_Textures.Fleshpound.Poundskin'
    MixTexturePool(5)=Texture'KFOldSchoolZeds_Textures.Gorefast.GorefastSkin'
    MixTexturePool(6)=Texture'KFOldSchoolZeds_Textures.Gunpound.GunpoundSkin'
    MixTexturePool(7)=Texture'KFOldSchoolZeds_Textures.Patriarch.PatriarchSkin'
    MixTexturePool(8)=Texture'KFOldSchoolZeds_Textures.Siren.SirenSkin'
    MixTexturePool(9)=Texture'KFOldSchoolZeds_Textures.StalkerSkin'

    MixHairPool(0)=FinalBlend'KFOldSchoolZeds_Textures.BossHairFB'
    MixHairPool(1)=FinalBlend'KFOldSchoolZeds_Textures.CrawlerHairFB'
    MixHairPool(2)=FinalBlend'KFOldSchoolZeds_Textures.SirenHairFB'
    MixHairPool(3)=FinalBlend'KFOldSchoolZeds_Textures.StalkerHairFB'

    RootBone=none
    HeadBone="Bip01 Head"
    SpineBone1="Bip01 Spine1"
    SpineBone2=none
    FireRootBone="Bip01 Spine"

    LeftShoulderBone="Bip01 L Clavicle"
    RightShoulderBone="Bip01 R Clavicle"
    LeftThighBone="Bip01 L Thigh"
    RightThighBone="Bip01 R Thigh"
    LeftFArmBone="Bip01 L Forearm"
    RightFArmBone=rfarm
    LeftFootBone="Bip01 L Foot"
    RightFootBone="Bip01 R Foot"
    LeftHandBone="Bip01 L Hand"
    RightHandBone="Bip01 R Hand"
    NeckBone="Bip01 Neck"
    ExtCollAttachBoneName="Bip01 Spine"

    ObliteratedEffectClass=GibExplosionOS

    HeadStubClassOS=class'GibHeadStumpOS'
    MonsterHeadGibletOS=class'ClotGibHeadOS'
    MonsterThighGibletOS=class'ClotGibThighOS'
    MonsterArmGibletOS=class'ClotGibArmOS'
    MonsterLegGibletOS=class'ClotGibLegOS'
    MonsterTorsoGibletOS=class'ClotGibTorsoOS'
    MonsterLowerTorsoGibletOS=class'ClotGibLowerTorsoOS'

    MonsterHeadGiblet=none
    MonsterThighGiblet=none
    MonsterArmGiblet=none
    MonsterLegGiblet=none
    MonsterTorsoGiblet=none
    MonsterLowerTorsoGiblet=none

    Mass=300.000000

    GibGroupClass=class'KFNoGibGroupOS'

    BloodStreakInterval=0.500000

    ProjectileBloodSplatClass=class'KFBloodPuffOS'

    ControllerClass=class'KFMonsterControllerOS'

    HeadHealth=25
    PlayerNumHeadHealthScale=0.0
    HeadHeight=2.0
    HeadScale=1.1
    HeadRadius=7.0

    Begin Object class=KarmaParamsSkel Name=PawnKParams
        KConvulseSpacing=(Max=2.200000)
        KLinearDamping=0.150000
        KAngularDamping=0.050000
        KBuoyancy=1.000000
        KStartEnabled=true
        KVelDropBelowThreshold=50.000000
        bHighDetailOnly=false
        KFriction=0.600000
        KRestitution=0.300000
        KImpactThreshold=250.000000
    End Object
    KParams=PawnKParams

    DeResTime=0.000000
    RagdollLifeSpan=0.000000
    RagImpactSounds(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Breakbone_01'
    RagImpactSounds(1)=Sound'KFOldSchoolZeds_Sounds.Shared.Breakbone_02'
    RagImpactSounds(2)=Sound'KFOldSchoolZeds_Sounds.Shared.Breakbone_03'
    RagImpactSoundInterval=0.500000
    RagDeathVel=150.000000
    RagShootStrength=6000.000000
    RagDeathUpKick=170.000000
    RagGravScale=1.500000
    RagSpinScale=2.500000
    RagMaxSpinAmount=1.000000
    MoanVolume=10
    SoundVolume=200
    SoundGroupClass=Class'KFOldSchoolZeds.KFMaleZombieSoundsOS'
}