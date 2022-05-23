// KFMonster class modified to include appropriate visual effects
// For the KFMod zeds e.g appropriate blood splatter, gibbing, obliteration, etc.
class KFMonsterOS extends KFMonster
    hidecategories(AnimTweaks,DeRes,Force,Gib,Karma,Udamage,UnrealPawn)
    Abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

//KFMod attaches this to the head of a decapitated zed
//Whereas Retail KF Uses SeveredHead, which we dont want
//Update:KFGib to KFGibOS
var class <KFGibOS> HeadStubClass;
var KFGibOS HeadStub;

// Giblets use KFGibOS instead of KFGib now
// So we have to Obscure them
var class <KFGibOS> MonsterHeadGiblet;
var class <KFGibOS> MonsterThighGiblet;
var class <KFGibOS> MonsterArmGiblet;
var class <KFGibOS> MonsterLegGiblet;
var class <KFGibOS> MonsterTorsoGiblet;
var class <KFGibOS> MonsterLowerTorsoGiblet;

//KFMod Variables
var Vector LastBloodHitDirection;

//Headshot scaling for solo
var float SoloHeadScale;

//Mut configs
var bool bUseOldMeleeDamage;

//Old Melee Damage
var int damageRand;
var int damageConst;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    // Old difficulty scaling
    if (Level.Game != none && !bDiffAdjusted )
    {
        if(bUseOldMeleeDamage)
        {
            damageConst *= (Level.Game.GameDifficulty / 3);
            damageRand *= (Level.Game.GameDifficulty / 3);
        }

        bDiffAdjusted = true;
    }
}


// High damage was taken, make em fall over.
function bool FlipOver()
{
    if( Physics==PHYS_Falling )
    {
        SetPhysics(PHYS_Walking);
    }

    bShotAnim = true;
    SetAnimAction('KnockDown');
    Acceleration = vect(0, 0, 0);
    Velocity.X = 0;
    Velocity.Y = 0;
    //This prevents them from looking at the player while downed,
    //But it also makes them suddeny look away from the player
    //TODO: Figure out what to do with this(Done!)
    KFMonsterController(Controller).Focus = None;
    KFMonsterController(Controller).FocalPoint = KFMonsterController(Controller).LastSeenPos;
    Controller.GoToState('WaitForAnim');
    KFMonsterController(Controller).bUseFreezeHack = True;
    Return True;
}

//Old-ify this
simulated function DoDamageFX( Name boneName, int Damage, class<DamageType> DamageType, Rotator r )
{
    local float DismemberProbability;
    //local int RandBone; //Unreferenced
    local bool bDidSever;

    //KFMod Variables
    //local float PertDummy; //Unreferenced
    local bool bExtraGib;

    //log("DamageFX bonename = "$boneName$" "$Level.TimeSeconds$" Damage "$Damage);

    // Added back in the /**/ from `Health <= 0 /*|| DamageType == class 'DamTypeCrossbowHeadshot'*/`
    // Otherwise, Zeds would lose limbs even if they werent dead if they were headshot by crossbow
    if ( FRand() > 0.3f || Damage > 30 || Health <= 0 /*|| DamageType == class 'DamTypeCrossbowHeadshot'*/)
    {
        HitFX[HitFxTicker].damtype = DamageType;
        //Ditto, no more /**/
        if( Health <= 0 /*|| DamageType == class 'DamTypeCrossbowHeadshot'*/ )
        {
            //Overhauled from KFMod DoDamageFX
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
                if ( boneName == 'None' )
                {
                    //`FireRootBone` to `Bip01 R Forearm`
                    //ExtraGib added
                    boneName = 'Bip01 R Forearm';
                    bExtraGib = true;
                }
            } //else if overhauled
            else if( (Damage*DamageType.Default.GibModifier > 50+120*FRand()-9999999999) && (Damage >= 0) ) // total gib prob
            {
                HitFX[HitFxTicker].bSever = true;
                boneName = 'Bip01 R Forearm';
                bExtraGib = true;
            }//KFMod has another massive else here
            else
            {

                //boneCoords = GetBoneCoords( HitFX[SimHitFxTicker].bone );
                //Spawn(class'KFMod.BrainSplash',,,boneCoords.Origin,Self.Rotation);     //hacked


                DismemberProbability = Abs( (Health - Damage*DamageType.Default.GibModifier) / 130.0f );
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

        if ( DamageType.default.bNeverSevers || class'GameInfo'.static.UseLowGore()
            || (Level.Game != none && Level.Game.PreventSever(self, boneName, Damage, DamageType)) )
        {
            HitFX[HitFxTicker].bSever = false;
            bDidSever = false;
            //Don't spawn ExtraGibs in this case
            bExtraGib = false;
        }

        HitFX[HitFxTicker].bone = boneName;
        HitFX[HitFxTicker].rotDir = r;
        HitFxTicker = HitFxTicker + 1;
        if( HitFxTicker > ArrayCount(HitFX)-1 )
            HitFxTicker = 0;

        //KFMod Code
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

//Need this for HeadStub to stay on after a zed dies
//Stops the green shit when a player dies.
simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    local float frame, rate;
    local name seq;
    local LavaDeath LD;
    local MiscEmmiter BE;

    //KFMod Code
    //make sure dismemberments etc aquired while alive carry onto corpse
    if(bDecapitated)
    {
        HideBone('bip01 head');

        if (HeadStub == none && HeadStubClass != none)
        {
            HeadStub = Spawn(HeadStubClass,Self);
            AttachToBone( HeadStub,'Bip01 head');
        }
    }

    //KFMod Code
    if (Gored>0)
    {
        if (Gored == 1)
            HideBone('Bip01 L Clavicle');   // off with his left arm then!
        else if (Gored == 2)
            HideBone('Bip01 R Clavicle');   // or his right!
        else if (Gored == 3)
            HideBone('Bip01 Spine2');  // or the whole bleedin' upper body.
        else if (Gored == 4)
            HideBone('Bip01 Spine1'); // or everything but the legs!!!! :)
        else if (Gored == 5)
        {
            HideBone('Bip01');
            bHidden = true;
        }
    }

    AmbientSound = None;
    bCanTeleport = false; // sjs - fix karma going crazy when corpses land on teleporters
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;
    StopBurnFX();

    if (CurrentCombo != None)
        CurrentCombo.Destroy();

    HitDamageType = DamageType; // these are replicated to other clients
    TakeHitLocation = HitLoc;

    bSTUNNED = false;
    bMovable = true;

    if ( class<DamTypeBurned>(DamageType) != none || class<DamTypeFlamethrower>(DamageType) != none )
    {
        ZombieCrispUp();
    }

    ProcessHitFX() ;

    if ( DamageType != None )
    {
        if ( DamageType.default.bSkeletize )
        {
            SetOverlayMaterial(DamageType.Default.DamageOverlayMaterial, 4.0, true);
            if (!bSkeletized)
            {
                if ( (Level.NetMode != NM_DedicatedServer) && (SkeletonMesh != None) )
                {
                    if ( DamageType.default.bLeaveBodyEffect )
                    {
                        BE = spawn(class'MiscEmmiter',self);
                        if ( BE != None )
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
                    if ( LD != None )
                        LD.SetBase(self);
                    //We have this sound in KFOldSchoolZeds_Sounds, plug it in
                    PlaySound( sound'KFOldSchoolZeds_Sounds.BExplosion5', SLOT_None, 1.5*TransientSoundVolume );
                }
            }
        }
        else if ( DamageType.Default.DeathOverlayMaterial != None )
            SetOverlayMaterial(DamageType.Default.DeathOverlayMaterial, DamageType.default.DeathOverlayTime, true);
        else if ( (DamageType.Default.DamageOverlayMaterial != None) && (Level.DetailMode != DM_Low) && !Level.bDropDetail )
            SetOverlayMaterial(DamageType.Default.DamageOverlayMaterial, 2*DamageType.default.DamageOverlayTime, true);
    }

    // stop shooting
    AnimBlendParams(1, 0.0);
    FireState = FS_None;

    // Try to adjust around performance
    //log(Level.DetailMode);

    //This never existed in KFMod's version of the function
    //LifeSpan = RagdollLifeSpan;

    //This is the only time Zeds Goto the Dying state
    //Make sure it goes to the KFMod version
    GotoState('ZombieDyingOS');
    if ( BE != None )
        return;
    PlayDyingAnimation(DamageType, HitLoc);
}

//KFMod had ragdolls staying after death, so this function may need
//Some significant changes done to have that working again
//Starting off by making this a new state extending off of Dying
//Previously called ZombieDying
State ZombieDyingOS extends Dying
{
ignores AnimEnd, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer, Died, RangedAttack;     //Tick

    function bool CanGetOutOfWay()
    {
        return false;
    }

    simulated function Landed(vector HitNormal)
    {
        //This was commented out for some reason, were bringing it back
        SetPhysics(PHYS_None);

        SetCollision(false, false, false);
        //Not sure if we need this, commenting it out
        //if( !bDestroyNextTick )
        //{
        //    Disable('Tick');
        //}
        //Some KFMod code, may cause issues
        if ( !IsAnimating(0) )
            LandThump();
        Super.Landed(HitNormal);
    }

    simulated function Timer()
    {
        //KFMod Code from here on
        if( Level.NetMode==NM_DedicatedServer )
        {
            Destroy();
            Return;
        }

        if( Physics!=PHYS_None )
        {
            if( VSize(Velocity)>10 )
            {
                SetTimer(1,False);
                Return;
            }
            Disable('TakeDamage');
            SetPhysics(PHYS_None);
            SetTimer(30,False);
            if(PlayerShadow != None)
                PlayerShadow.bShadowActive = false;
        }
        else if( (Level.TimeSeconds-LastRenderTime)>40 || Level.bDropDetail )
            Destroy();
        else SetTimer(5,False);
    }

    simulated function BeginState()
    {
        //KFMod Code
        if( Controller!=None )
            Controller.Destroy();
        if( Level.NetMode==NM_DedicatedServer )
            SetTimer(1,False);
        SetTimer(5,False);
     }
}

// Old-ify this and replace all relevant gibs with the KFMod ones
// Also, swap out all instances of KFSpawnGiblet with SpawnGiblet
// SpawnSeveredGiblet is unnecessary as Old Zeds don't spawn severed limbs
simulated function ProcessHitFX()
{
    local Coords boneCoords;
    local class<xEmitter> HitEffects[4];
    local int i,j;
    local float GibPerterbation;

    // KFMod version defines i and j at the start as 0 for some reason
    j = 0 ;
    i = 0 ;

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

        if( (HitFX[SimHitFxTicker].damtype == None) || (Level.bDropDetail && (Level.TimeSeconds - LastRenderTime > 3) && !IsHumanControlled()) )
            continue;

        //log("Processing effects for damtype "$HitFX[SimHitFxTicker].damtype);

        boneCoords = GetBoneCoords( HitFX[SimHitFxTicker].bone );

        if ( !Level.bDropDetail && !class'GameInfo'.static.NoBlood() && !bSkeletized && !class'GameInfo'.static.UseLowGore())
        {
            //AttachEmitterEffect( BleedingEmitterClass, HitFX[SimHitFxTicker].bone, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir );
            //Old Code brought back
            AttachEffect( GibGroupClass.static.GetBloodEmitClass(), HitFX[SimHitFxTicker].bone, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir );

            HitFX[SimHitFxTicker].damtype.static.GetHitEffects( HitEffects, Health );

            if( !PhysicsVolume.bWaterVolume ) // don't attach effects under water
            {
                for( i = 0; i < ArrayCount(HitEffects); i++ )
                {
                    if( HitEffects[i] == None )
                        continue;

                      AttachEffect( HitEffects[i], HitFX[SimHitFxTicker].bone, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir );
                }
            }
        }

        //Replace all instances of gibs spawned here with KFMod gibs(Done!)
        //Gibbing sounds are in KFOldSchoolZeds_Sounds
        //Note: Old zeds limbs get destroyed, not amputated, so we won't add meshes of each limb
        //Overhauled to use KFMod's code instead of Retail
        if( HitFX[SimHitFxTicker].bSever )
        {
            GibPerterbation = HitFX[SimHitFxTicker].damtype.default.GibPerterbation;
            bFlaming = HitFX[SimHitFxTicker].DamType.Default.bFlaming;

            switch( HitFX[SimHitFxTicker].bone )
            {
                case 'Bip01 L Thigh':
                case 'Bip01 R Thigh':
                    Spawn(class'BrainSplashOS',,,boneCoords.Origin,Self.Rotation); //KFMod Brainsplash
                    SpawnGiblet( GetGibClass(EGT_Calf), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                    SpawnGiblet( GetGibClass(EGT_Calf), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                    PlaySound(sound'KFOldSchoolZeds_Sounds.Shared.Gibbing_Sound1', SLOT_Misc,255);
                    GibCountCalf -= 2;
                    break;
                case 'Bip01 R Forearm':
                case 'Bip01 L Forearm':
                    Spawn(class'BrainSplashOS',,,boneCoords.Origin,Self.Rotation);//KFMod Brainsplash
                    SpawnGiblet( GetGibClass(EGT_UpperArm), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                    SpawnGiblet( GetGibClass(EGT_Forearm), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                    PlaySound(sound'KFOldSchoolZeds_Sounds.Shared.Gibbing_Sound2', SLOT_Misc,255);
                    GibCountForearm--;
                    GibCountUpperArm--;
                    break;
                case 'Bip01 Head':
                    Spawn(class'BrainSplashOS',,,boneCoords.Origin,Self.Rotation);//KFMod Brainsplash
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
                        // extra gibs!!!
                        GibPerterbation = FMin(1.0, 1.5 * GibPerterbation);
                        PlaySound(sound'KFOldSchoolZeds_Sounds.Shared.Gibbing_Sound4', SLOT_Misc,255);
                                                SpawnGiblet( GetGibClass(EGT_Calf), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                        SpawnGiblet( GetGibClass(EGT_Calf), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                        SpawnGiblet( GetGibClass(EGT_UpperArm), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                        SpawnGiblet( GetGibClass(EGT_Forearm), boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation );
                    }
                    break;
            }
            //KFMod Code
            if (!bDecapitated)
                HideBone(HitFX[SimHitFxTicker].bone);
        }
    }
}

// Head destruction results in giblets spawning, loads of bits and pieces everywhere!
// Although, the way it works is different in KFMod and retail, where the former 
// defines spawning of giblets through the tick function, and the latter via the
// DecapFX Function. Also, swap out all instances of KFSpawnGiblet with SpawnGiblet.
// TODO: Redefine DecapFX to use old giblets, which would require getting all
// Relevant KFMod Brain Gib and Splash classes(Done!)
simulated function DecapFX( Vector DecapLocation, Rotator DecapRotation, bool bSpawnDetachedHead, optional bool bNoBrainBits )
{
    local float GibPerterbation;
    local BrainSplashOS SplatExplosion; // BrainSplash to BrainSplashOS
    local int i;

    // Do the cute version of the Decapitation
    if ( class'GameInfo'.static.UseLowGore() )
    {
        CuteDecapFX();

        return;
    }

    bNoBrainBitEmitter = bNoBrainBits;

    GibPerterbation = 0.060000; // damageType.default.GibPerterbation;

    if(bSpawnDetachedHead)
    {
       SpecialHideHead();
    }
    else
    {
        HideBone(HeadBone);
    }

    // Plug in headless anims if we have them
    // TODO: Old zeds don't have Headless walk anims, maybe get rid of this?
    //for( i = 0; i < 4; i++ )
    //{
    //    if( HeadlessWalkAnims[i] != '' && HasAnim(HeadlessWalkAnims[i]) )
    //    {
    //        MovementAnims[i] = HeadlessWalkAnims[i];
    //        WalkAnims[i]     = HeadlessWalkAnims[i];
    //    }
    //}

    if ( !bSpawnDetachedHead && !bNoBrainBits && EffectIsRelevant(DecapLocation,false) )
    {
        //Gibs replaced, KFSpawnGiblet swapped with SpawnGiblet as
        //KFSpawnGiblet has an optional Variable velocity, which we don't need
        SpawnGiblet( class'KFGibBrainOS',DecapLocation, self.Rotation, GibPerterbation) ;
        SpawnGiblet( class'KFGibBrainbOS',DecapLocation, self.Rotation, GibPerterbation) ;
        SpawnGiblet( class'KFGibBrainOS',DecapLocation, self.Rotation, GibPerterbation) ;
    }
    // Use KFMod's Brainsplash
    SplatExplosion = Spawn(class 'BrainSplashOS',self,, DecapLocation );
}

// Decapitation effects for melee attacks
// Neck bone in this function uses wrong name, change it to the appropriate one(Done!)
// Additional Note: Melee decapitation results in a head flying off, KFMod doesn't have this
// And as such Decapitated head models will not be added
simulated function SpecialHideHead()
{
    local int BoneScaleSlot;
    local coords boneCoords;

    // Only scale the bone down once
    //SeveredHead to HeadStub
    if(HeadStub == none && HeadStubClass != none)
    {
        boneScaleSlot = 4;
        // Use the old Headstub
        // Note: Original code had 2 additional properties after self,
        // ('',Location) Not sure what they do but can add them later?
        HeadStub = Spawn(HeadStubClass,self);

        //Headstub isn't scaled down, and we don't care about the SeveredHead
        //SeveredHead.SetDrawScale(SeveredHeadAttachScale);

        // `Neck` to `Bip01 Head`
        boneCoords = GetBoneCoords( 'Bip01 Head' );

        // Blood spurting from the neck didn't exist back then, so we don't need it
        // AttachEmitterEffect( NeckSpurtNoGibEmitterClass, 'Bip01 Neck', boneCoords.Origin, rot(0,0,0) );

        //Attach the stub to the Head
        //Maybe swap to neck?
        AttachToBone(HeadStub, 'Bip01 Head');
    }
    else
    {
        return;
    }
    // `Head` to `Bip01 Head`
    SetBoneScale(BoneScaleSlot, 0.0, 'Bip01 Head');
}

// Ditto
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
    // `Neck` to `Bip01 Neck
    SetBoneRotation('Bip01 Neck', NeckRot);
    RemoveHead();
}

// Old zeds don't have Severed Giblets, so this function is nulled
simulated function SpawnSeveredGiblet( class<SeveredAppendage> GibClass, Vector Location, Rotator Rotation, float GibPerterbation, rotator SpawnRotation )
{
}

// Retail KF overhauled this function, forcing a restriction to
// What bones can be hidden and not, while KFMod relied on XPawn's
// Code. We'll swap the new with the old as adapting the old models
// To modern code is a pain in the butt
// TODO: Not sure if this is a good idea, maybe we should have 2 separate
// Versions of KFMonster where one uses old code and other modernizes the code
// With changes to each function to emulate KFMod zeds?
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

//Looks like the only option I have to get proper gore
//Is to probably modify this?
simulated function Tick(float DeltaTime)
{
    local PlayerController P;
    local float DistSquared;
    //KFMod Variables
    local float GibPerterbation;
    local BrainSplashOS SplatExplosion;
    local Vector SplatLocation;
    local Rotator R;
    local GibExplosionOS GibbedExplosion;

    //KFMod code snippet
    if (AnimAction == 'KnockDown')
    {
        Acceleration = vect(0,0,0);
        Velocity = vect(0,0,0);
    }

//    if(Level.NetMode == NM_DedicatedServer)
//    {
//        IsHeadShot(vect(0,0,0), vect(0,0,0), 1.0);
//    }

    // If we've flagged this character to be destroyed next tick, handle that
    if( bDestroyNextTick && TimeSetDestroyNextTickTime < Level.TimeSeconds )
    {
        Destroy();
    }

    // Make Zeds move faster if they aren't net relevant, or noone has seen them
    // in a while. This well get the Zeds to the player in larger groups, and
    // quicker - Ramm
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
        bResetAnimAct = False;
    }

    if ( Controller != None )
    {
        LookTarget = Controller.Enemy;
    }

    // If the Zed has been bleeding long enough, make it die
    if ( Role == ROLE_Authority && bDecapitated )
    {
        if ( BleedOutTime > 0 && Level.TimeSeconds - BleedOutTime >= 0 )
        {
            Died(LastDamagedBy.Controller,class'DamTypeBleedOut',Location);
            BleedOutTime=0;
        }

    }

    //SPLATTER!!!!!!!!!
    //TODO - can we work this into Epic's gib code?
    //Will we see enough improvement in efficiency to be worth the effort?
    if ( Level.NetMode!=NM_DedicatedServer )
    {
        TickFX(DeltaTime);
        //Old code for zeds to look at the targets theyre aggroed to
        //Don't move your heads while your dead, that's creepy.
        if( LookTarget!=None && Health >= 1 )
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
            bAshen = False;
        }

        //KFMod Code
        if(bDecapitated && !bPlayBrainSplash )
        {
            SplatLocation = self.Location;
            SplatLocation.z += CollisionHeight;
            GibPerterbation = 0.060000; // damageType.default.GibPerterbation;
            HideBone('bip01 head');
            if (HeadStub == none && HeadStubClass != none)
            {
                HeadStub = Spawn(HeadStubClass,Self,'',Location);
                AttachToBone( HeadStub,'Bip01 head');
            }
            if ( EffectIsRelevant(Location,false) )
            {
                // use our classes
                SpawnGiblet( class'KFGibBrainOS',SplatLocation, self.Rotation, GibPerterbation ) ;
                SpawnGiblet( class'KFGibBrainbOS',SplatLocation, self.Rotation, GibPerterbation ) ;
                SpawnGiblet( class'KFGibBrainOS',SplatLocation, self.Rotation, GibPerterbation ) ;
            }
            //Use KFMod BrainSplash
            SplatExplosion = Spawn(class 'BrainSplashOS',self,, SplatLocation );
            bPlayBrainSplash = true;
        }
        if (Gored>0 && !bPlayGoreSplash)
        {
            SplatLocation = self.Location;
            SplatLocation.z += (CollisionHeight - (CollisionHeight * 0.5));
            GibPerterbation = 0.060000; //damageType.default.GibPerterbation;
            if (Gored == 1)
                HideBone('Bip01 L Clavicle');   // off with his left arm then!
            else if (Gored == 2)
                HideBone('Bip01 R Clavicle');   // or his right!
            else if (Gored == 3)
            {
                HideBone('Bip01 Spine2');  // or the whole bleedin' upper body.
                if (GoredMat != none)
                    Skins[0] = GoredMat;
            }
            else if (Gored == 4)
                HideBone('Bip01 Spine1'); // or everything but the legs!!!! :)

            //Log("I WAS GORED! SHOWING FX");

                        if ( EffectIsRelevant(Location,false) && Gored < 5 )
            {
                //Use KFMod classes
                Spawn(class'BrainSplashOS',,,SplatLocation,Self.Rotation);
                SpawnGiblet( class'KFGibBrainOS',SplatLocation, self.Rotation, GibPerterbation ) ;
                SpawnGiblet( class'KFGibBrainbOS',SplatLocation, self.Rotation, GibPerterbation ) ;
                SpawnGiblet( class'KFGibBrainOS',SplatLocation, self.Rotation, GibPerterbation ) ;
            }
            else if ( EffectIsRelevant(Location,false) && Gored == 5 )
            {
            //    Log("CHUNKED UP!");

                                //Use KFMod's BodySplash
                                Spawn(class'BodySplashOS',,,SplatLocation,Self.Rotation);

                if (!bDecapitated)
                    SpawnGiblet(MonsterHeadGiblet,SplatLocation, self.Rotation, GibPerterbation ) ;

                SpawnGiblet(MonsterTorsoGiblet,SplatLocation, self.Rotation, GibPerterbation ) ;
                SpawnGiblet(MonsterLowerTorsoGiblet,SplatLocation, self.Rotation, GibPerterbation ) ;

                SpawnGiblet(MonsterArmGiblet,SplatLocation, self.Rotation, GibPerterbation ) ;
                SpawnGiblet(MonsterArmGiblet,SplatLocation, self.Rotation, GibPerterbation ) ;

                SpawnGiblet(MonsterThighGiblet,SplatLocation, self.Rotation, GibPerterbation ) ;
                SpawnGiblet(MonsterThighGiblet,SplatLocation, self.Rotation, GibPerterbation ) ;

                SpawnGiblet(MonsterLegGiblet,SplatLocation, self.Rotation, GibPerterbation ) ;
                SpawnGiblet(MonsterLegGiblet,SplatLocation, self.Rotation, GibPerterbation ) ;

                //Use ObliteratedEffectClass?
                GibbedExplosion = Spawn(class'GibExplosionOS',self,, SplatLocation );
            //    bPlayGibSplash = true;


            }
            //Use KFMod BrainSplash
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
            bZapped = False;
            ZappedBy = none;
            // The Zed can take more zap each time they get zapped
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

// What happens when a zed gets absolutely annihilated!
// Replace all gibs with KFMod ones and swap out all instances of KFSpawnGiblet with SpawnGiblet
// Add in the nasty looking KFMod giblets for the explosion
// Aftermath: Decided to add in the Gib Explosion via Tick after all, we don't need this function anymore
// So were nullifying it
simulated function SpawnGibs(Rotator HitRotation, float ChunkPerterbation)
{
}

//Old Door Attack makes them use the claw animation
function DoorAttack(Actor A)
{
    if ( bShotAnim || Physics == PHYS_Swimming)
        return;
    else if ( CanAttack(A) ) // Used retail 'A!=None' instead of KFMod's 'CanAttack(A)'
    {
        bShotAnim = true;
        //DoorBash causes issues, just claw for now
        SetAnimAction('Claw');

        //After reviewing, DoorBashing does exist, just unused(?)
        //We'll bring it back regardless
        //This causes issues, so dont use it
        //GotoState('DoorBashing');

        //Play the Clawing noise here
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

    if(!bUseOldMeleeDamage)
    {
        if(Controller!=none && Controller.Target!=none)
            PushDir = (damageForce * Normal(Controller.Target.Location - Location));
        else PushDir = damageForce * vector(Rotation);
        // Melee damage is +/- 10% of default
        if ( MeleeDamageTarget(UsedMeleeDamage, PushDir) )
            PlayZombieAttackHitSound(); // Bringing back this old function!
    }
    else
    {
        if(Controller!=none && Controller.Target!=none)
            PushDir = (damageForce * Normal(Controller.Target.Location - Location));
        else PushDir = damageForce * vector(Rotation);
        if ( MeleeDamageTarget( (damageConst + rand(damageRand) ), PushDir))
            PlayZombieAttackHitSound();
    }
}

//KFMod sounds for when Zeds smack a player located in KFWeaponSound
function PlayZombieAttackHitSound()
{
    local int MeleeAttackSounds;

    MeleeAttackSounds = rand(4) ;
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

//Old BodyPartRemoval Function
function BodyPartRemoval(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
    local float Threshold;

    //The Damagetypes need to be expanded on newer weapons
    //TODO: Add all "heavy" melee weapons and Shotgun damage to this
    // Torso Sever... This is what happens when Overkill occurs.  Nasty.
    if ( Health - Damage < 0)
    {
        //Shotguns and other weapons dont need to deal a lot of damage to activate gore variations
        //Whilst certain other weapons like the Pistol need to deal a crapton of damage or be lucky
        //That the zed has 1 hp to gore them. Expand DamTypes as needed.
        if( DamageType.name != 'DamTypeShotgun' && DamageType.name != 'DamTypeDBShotgun' && DamageType.name != 'DamTypeAxe')
            Threshold = 0.5;
                else
            Threshold = 0.25;

         // How Splatty was it?
        if ((Health - Damage) < (0-(Threshold * HealthMax)) && (Health - Damage) > (0-((Threshold * 1.2) * HealthMax)) )
            Gored = rand(4)+1;
                else // Expand DamTypes as needed.
        if ((Health - Damage) <= (0-(1.0 * HealthMax))) 
            {
                if( damageType == class 'DamTypeFrag' || damageType == class 'DamTypeLAW' ||
                damageType == class 'DamTypeM79Grenade' || damageType == class 'DamTypeM203Grenade' ||
                damageType == class 'DamTypePipeBomb' || damageType == class 'DamTypeSealSquealExplosion') 
                    Gored = 5;
            }
        if(Gored > 0)
        {
            // Sorry, not even zombies are getting back up from this.
            //Health = 0;
            if( instigatedBy!=None )
                Died(instigatedBy.Controller,damageType,hitlocation);
                else Died(None,damageType,hitlocation);
        }

        // log(Gored);

    }

}

// Need some KFMod code in here
function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType, optional int HitIndex )
{
    // Added this back
    // Client check for Gore FX
    BodyPartRemoval(Damage,instigatedBy,hitlocation,momentum,damageType);

    //KFMod Code to make ragdolls fly if they died to an explosive damage
    //Modernized to also be effected by new Explosives
    if( Health-Damage <= 0 && DamageType!=class'DamTypeFrag' && DamageType!=class'DamTypePipeBomb'
        && DamageType!=class'DamTypeM79Grenade' && DamageType!=class'DamTypeM32Grenade'
        && DamageType!=class'DamTypeM203Grenade' && DamageType!=class'DamTypeSeekerSixRocket'
        && DamageType!=class'DamTypeSPGrenade' && DamageType!=class'DamTypeSealSquealExplosion'
        && DamageType!=class'DamTypeLAW')
    {
        RagDeathVel *= 5;
        RagDeathUpKick *= 1.5;
    }

    //TODO:Include all Shotgun damage types here
    if( Health-Damage > 0 && DamageType!=class'DamTypeFrag' && DamageType!=class'DamTypePipeBomb'
        && DamageType!=class'DamTypeM79Grenade' && DamageType!=class'DamTypeM32Grenade'
        && DamageType!=class'DamTypeM203Grenade' && DamageType!=class'DamTypeDwarfAxe'
        && DamageType!=class'DamTypeSPGrenade' && DamageType!=class'DamTypeSealSquealExplosion'
        && DamageType!=class'DamTypeSeekerSixRocket' && DamageType!=class'DamTypeLAW')
    {
        Momentum = vect(0,0,0);
    }

    Super.takeDamage(Damage, instigatedBy, hitLocation, momentum, damageType);
}

// Need to old-ify this
// New Hit FX for Zombies!
function PlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum, optional int HitIdx )
{
    local Vector HitNormal;
    local Vector HitRay ;
    local Name HitBone;
    local float HitBoneDist;
    local PlayerController PC;
    local bool bShowEffects, bRecentHit;
    // ProjectileBloodSplat to BloodSpurtOS
    local BloodSpurtOS BloodHit;
    //local rotator SplatRot; Obsolete

    bRecentHit = Level.TimeSeconds - LastPainTime < 0.2;

    //Adding this back
    LastDamageAmount = Damage;

    //Adding this back
    //Call the modified version of the original Pawn playhit
    //So that the Zeds can play their hitanims
    //We don't want this called when a zed is knocked down,
    //Is there a way I can do this without using bShotAnim?
    //Now checks FreezeHack instead which works much better
    if(KFMonsterController(Controller).bUseFreezeHack == False)
        OldPlayHit(Damage, InstigatedBy, HitLocation, DamageType,Momentum);

    //KFMod called Playhit here but we dont want it
    //Super.PlayHit(Damage,InstigatedBy,HitLocation,DamageType,Momentum);

    if ( Damage <= 0 )
        return;

    if( Health>0 && Damage>(float(Default.Health)/1.5) )
        FlipOver();

    PC = PlayerController(Controller);
    bShowEffects = ( (Level.NetMode != NM_Standalone) || (Level.TimeSeconds - LastRenderTime < 2.5)
                    || ((InstigatedBy != None) && (PlayerController(InstigatedBy.Controller) != None))
                    || (PC != None) );
    if ( !bShowEffects )
        return;

    if ( BurnDown > 0 && !bBurnified )
    {
        bBurnified = true;
    }

    HitRay = vect(0,0,0);
    if( InstigatedBy != None )
        HitRay = Normal(HitLocation-(InstigatedBy.Location+(vect(0,0,1)*InstigatedBy.EyeHeight)));

    if( DamageType.default.bLocationalHit )
    {
        CalcHitLoc( HitLocation, HitRay, HitBone, HitBoneDist );

        // Do a zapped effect is someone shoots us and we're zapped to help show that the zed is taking more damage
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

    if( InstigatedBy != None )
        HitNormal = Normal( Normal(InstigatedBy.Location-HitLocation) + VRand() * 0.2 + vect(0,0,2.8) );
    else
        HitNormal = Normal( Vect(0,0,1) + VRand() * 0.2 + vect(0,0,2.8) );

    //log("HitLocation "$Hitlocation) ;

    //Overhauled to use KFMod's code
    //SplatRot becomes obsolete
    if ( DamageType.Default.bCausesBlood && DamageType != class 'Burned' )
    {
        if ( class'GameInfo'.static.UseLowGore() )
        {
            if ( class'GameInfo'.static.NoBlood() )
                BloodHit = BloodSpurtOS(Spawn( GibGroupClass.default.NoBloodHitClass,InstigatedBy,, HitLocation ));
            else
                BloodHit = BloodSpurtOS(Spawn( GibGroupClass.default.LowGoreBloodHitClass,InstigatedBy,, HitLocation ));
        }
        else BloodHit = BloodSpurtOS(Spawn(GibGroupClass.default.BloodHitClass,InstigatedBy,, HitLocation, Rotator(HitNormal)));
        if ( BloodHit != None )
        {
            BloodHit.bMustShow = !bRecentHit;
            if ( Momentum != vect(0,0,0) )
            {
                BloodHit.HitDir = Momentum;
                LastBloodHitDirection = BloodHit.HitDir;
            }
            else
            {
                if ( InstigatedBy != None )
                    BloodHit.HitDir = Location - InstigatedBy.Location;
                else
                    BloodHit.HitDir = Location - HitLocation;
                BloodHit.HitDir.Z = 0;
            }
        }
    }

    if( InstigatedBy != none && InstigatedBy.PlayerReplicationInfo != none &&
        KFSteamStatsAndAchievements(InstigatedBy.PlayerReplicationInfo.SteamStatsAndAchievements) != none &&
        Health <= 0 && Damage > DamageType.default.HumanObliterationThreshhold && Damage != 1000 && (!bDecapitated || bPlayBrainSplash) )
    {
        KFSteamStatsAndAchievements(InstigatedBy.PlayerReplicationInfo.SteamStatsAndAchievements).AddGibKill(class<DamTypeM79Grenade>(damageType) != none);

        if ( self.IsA('ZombieFleshPound') )
        {
            KFSteamStatsAndAchievements(InstigatedBy.PlayerReplicationInfo.SteamStatsAndAchievements).AddFleshpoundGibKill();
        }
    }
    // KFMod Code
    // hack for Gibbing  :D
    if ( (DamageType.name == 'DamTypeShotgun' || DamageType.name == 'DamTypeDBShotgun' || DamageType.name == 'DamTypeFrag') && (Health < 0) && (InstigatedBy != None) && (VSize(InstigatedBy.Location - Location) < 350) )
        DoDamageFX( HitBone, 800*Damage, DamageType, Rotator(HitNormal) );
    else
        DoDamageFX( HitBone, Damage, DamageType, Rotator(HitNormal) );

    if (DamageType.default.DamageOverlayMaterial != None && Damage > 0 ) // additional check in case shield absorbed
        SetOverlayMaterial( DamageType.default.DamageOverlayMaterial, DamageType.default.DamageOverlayTime, false );
}


// Screw the broken solo headshots, use the online headshots value in solo
// If there's a way to trim this down, do so down the line
function bool IsHeadShot(vector loc, vector ray, float AdditionalScale)
{
    local coords C;
    local vector HeadLoc, B, M, diff;
    local float t, DotMM, Distance;
    local int look;
    local bool bUseAltHeadShotLocation;
    local bool bWasAnimating;

    if (HeadBone == '')
        return False;

    // If we are a dedicated server estimate what animation is most likely playing on the client
    if (Level.NetMode == NM_DedicatedServer)
    {
        if (Physics == PHYS_Falling)
            PlayAnim(AirAnims[0], 1.0, 0.0);
        else if (Physics == PHYS_Walking)
        {
            // Only play the idle anim if we're not already doing a different anim.
            // This prevents anims getting interrupted on the server and borking things up - Ramm

            if( !IsAnimating(0) && !IsAnimating(1) )
            {
                if (bIsCrouched)
                {
                    PlayAnim(IdleCrouchAnim, 1.0, 0.0);
                }
                else
                {
                    bUseAltHeadShotLocation=true;
                }
            }
            else
            {
                bWasAnimating = true;
            }

            if ( bDoTorsoTwist )
            {
                SmoothViewYaw = Rotation.Yaw;
                SmoothViewPitch = ViewPitch;

                look = (256 * ViewPitch) & 65535;
                if (look > 32768)
                    look -= 65536;

                SetTwistLook(0, look);
            }
        }
        else if (Physics == PHYS_Swimming)
            PlayAnim(SwimAnims[0], 1.0, 0.0);

        if( !bWasAnimating )
        {
            SetAnimFrame(0.5);
        }
    }

    if( bUseAltHeadShotLocation )
    {
        HeadLoc = Location + (OnlineHeadshotOffset >> Rotation);
        AdditionalScale *= OnlineHeadshotScale;
    }
    else
    {
        HeadLoc = Location + (OnlineHeadshotOffset >> Rotation);
        AdditionalScale *= SoloHeadScale;
    }
    //ServerHeadLocation = HeadLoc;

    // Express snipe trace line in terms of B + tM
    B = loc;
    M = ray * (2.0 * CollisionHeight + 2.0 * CollisionRadius);

    // Find Point-Line Squared Distance
    diff = HeadLoc - B;
    t = M Dot diff;
    if (t > 0)
    {
        DotMM = M dot M;
        if (t < DotMM)
        {
            t = t / DotMM;
            diff = diff - (t * M);
        }
        else
        {
            t = 1;
            diff -= M;
        }
    }
    else
        t = 0;

    Distance = Sqrt(diff Dot diff);

    return (Distance < (HeadRadius * HeadScale * AdditionalScale));
}

// Need this to get the HeadStub removed when Ragdoll is gone
// Overridden to handle making attached explosives explode when this pawn dies
simulated function Destroyed()
{
    local int i;

    for( i=0; i<Attached.length; i++ )
    {
        if( Emitter(Attached[i])!=None && Attached[i].IsA('DismembermentJet') )
        {
            Emitter(Attached[i]).Kill();
            Attached[i].LifeSpan = 2;
        }

        // Make attached explosives blow up when this pawn dies
        if( SealSquealProjectile(Attached[i])!=None )
        {
            SealSquealProjectile(Attached[i]).HandleBasePawnDestroyed();
        }
    }

    if( MyExtCollision!=None )
        MyExtCollision.Destroy();
    if( PlayerShadow != None )
        PlayerShadow.Destroy();

    if ( FlamingFXs != none )
    {
        FlamingFXs.Emitters[0].SkeletalMeshActor = none;
        FlamingFXs.Destroy();
    }

    if(RealtimeShadow !=none)
        RealtimeShadow.Destroy();

    if( SeveredLeftArm != none )
    {
        SeveredLeftArm.Destroy();
    }

    if( SeveredRightArm != none )
    {
        SeveredRightArm.Destroy();
    }

    if( SeveredRightLeg != none )
    {
        SeveredRightLeg.Destroy();
    }

    if( SeveredLeftLeg != none )
    {
        SeveredLeftLeg.Destroy();
    }

    if( SeveredHead != none )
    {
        SeveredHead.Destroy();
    }

    if(SpawnVolume != none)
    {
        SpawnVolume.RemoveZEDFromSpawnList(self);
    }

    // Hack to get rid of our head stump, if the ragdoll dissapears.
    if (HeadStub != none)
        HeadStub.Destroy();
    RemoveFlamingEffects();
    Super.Destroyed();
}

// Old Zeds use a different texture when burnt, so swap out
// The retail burnt skin texture with the KFMod one
simulated function ZombieCrispUp()
{
    // Call the parent class's definition of the function since we have no
    // Plans of modifying anything other than the textures
    super.ZombieCrispUp();

    // Swapped out new textures for old
    // TODO: Confirm if Fleshpound, which has more than 4 skins,
    // Needs us to extend the Skins array(Probably not)
    Skins[0]=Texture'KFOldSchoolZeds_Textures.Shared.BurntZedSkin';
    Skins[1]=Texture'KFOldSchoolZeds_Textures.Shared.BurntZedSkin';
    Skins[2]=Texture'KFOldSchoolZeds_Textures.Shared.BurntZedSkin';
    Skins[3]=Texture'KFOldSchoolZeds_Textures.Shared.BurntZedSkin';
}

//Overwritten, old zeds do not have burning animations
// Set the zed to the on fire behavior
simulated function SetBurningBehavior()
{
    if( Role == Role_Authority )
    {
        Intelligence = BRAINS_Retarded; // burning dumbasses!

        SetGroundSpeed(OriginalGroundSpeed * 0.8);
        AirSpeed *= 0.8;
        WaterSpeed *= 0.8;

        // Make them less accurate while they are burning
        if( Controller != none )
        {
           MonsterController(Controller).Accuracy = -5;  // More chance of missing. (he's burning now, after all) :-D
        }
    }

    //Don't do this please, we enjoy burning after all.
    // Set the forward movement anim to a random burning anim
    //MovementAnims[0] = BurningWalkFAnims[Rand(3)];
    //WalkAnims[0]     = BurningWalkFAnims[Rand(3)];

    // Set the rest of the movement anims to the headless anim (not sure if these ever even get played) - Ramm
    //MovementAnims[1] = BurningWalkAnims[0];
    //WalkAnims[1]     = BurningWalkAnims[0];
    //MovementAnims[2] = BurningWalkAnims[1];
    //WalkAnims[2]     = BurningWalkAnims[1];
    //MovementAnims[3] = BurningWalkAnims[2];
    //WalkAnims[3]     = BurningWalkAnims[2];
}

// Changed to use the old BloodStreak Decal, otherwise this is exactly the same
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

    //Added no blood for low gore
    if ( WallActor != None && Level.TimeSeconds > LastStreakTime + BloodStreakInterval && !class'GameInfo'.static.UseLowGore() )
    {
        if ( StreakDist < 1400 ) //0.75m
        {
           //log("Streak dist too small "$ Sqrt(StreakDist)/50$"m");
           return;
        }
        //Use KFMod BloodStreak
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

defaultproperties
{
    // Variables naming each bone in KFMod did not exist,
    // They were set by their exact names in each function
    // TODO: Determine what the names of these bones should be
    RootBone=None//Unknown, only called once in Retail KFMonster for a function not in old KFMonster, GetExposureTo
    HeadBone="Bip01 Head"//PostNetBeginPlay hints this
    SpineBone1="Bip01 Spine1"//PostNetBeginPlay hints this
    SpineBone2=None//No reference, but may potentially be "Bip01 Spine2", used in hiding upper body when gored
    FireRootBone="Bip01 Spine"// Playhit function hints this

    //These names were guessed and may be wrong
    LeftShoulderBone="Bip01 L Clavicle"
    RightShoulderBone="Bip01 R Clavicle"
    LeftThighBone="Bip01 L Thigh"
    RightThighBone="Bip01 R Thigh"
    LeftFArmBone="Bip01 L Forearm"
    RightFArmBone=rfarm//The odd one out, was declared `rfarm` in DoDamageFX
    LeftFootBone="Bip01 L Foot"
    RightFootBone="Bip01 R Foot"
    LeftHandBone="Bip01 L Hand"
    RightHandBone="Bip01 R Hand"
    NeckBone="Bip01 Neck"
    // There is no ExtCollision Bone in KFMod, have to look into how it's handled
    // After investigating, I have no fucking idea where the fuck this is used nor
    // do I care, all I know is that it's basically the FireRootBone
    ExtCollAttachBoneName="Bip01 Spine"

    //KFMod's piece of flesh that gets attached
    //To the neck after a zed loses his head
    HeadStubClass=Class'GibHeadStumpOS'

    // Obliteration is no longer a local variable in Tick called GibbedExplosion,
    // So we need to define it here. Look into SpawnGibs function as well.
    //// NO LONGER USED BUT WE'LL KEEP IT
    ObliteratedEffectClass=GibExplosionOS//TODO:Port this over from KFMod

    // The Giblets that spawn after an obliteration, KFMod ones
     MonsterHeadGiblet=Class'ClotGibHeadOS'
     MonsterThighGiblet=Class'ClotGibThighOS'
     MonsterArmGiblet=Class'ClotGibArmOS'
     MonsterLegGiblet=Class'ClotGibLegOS'
     MonsterTorsoGiblet=Class'ClotGibTorsoOS'
     MonsterLowerTorsoGiblet=Class'ClotGibLowerTorsoOS'

     //How Heavy a zed is
     Mass=300.000000//100.000000 in parent

     //Gib group containing Blood Splatter
     GibGroupClass=Class'KFNoGibGroupOS'

     //Time to wait before spawning BloodStreak decal when ragdoll impacts ground
     BloodStreakInterval=0.500000//0.250000 in Retail

     //Blood Spurt Class
     ProjectileBloodSplatClass=class'KFBloodPuffOS'

     //Use my own Controller Class
     ControllerClass=Class'KFMonsterControllerOS'

     //Values relating to the Head
     HeadHealth=25
     PlayerNumHeadHealthScale=0.0
     HeadHeight=2.0
     HeadScale=1.1
     HeadRadius=7.0

     //At some point we'll add the MaleZombieSoundsGroup, don't forget

     //False by default
     //bUseOldMeleeDamage=false

     ////KarmaParamsSkel
     Begin Object Class=KarmaParamsSkel Name=PawnKParams
         KConvulseSpacing=(Max=2.200000)
         KLinearDamping=0.150000
         KAngularDamping=0.050000
         KBuoyancy=1.000000
         KStartEnabled=True
         KVelDropBelowThreshold=50.000000
         bHighDetailOnly=False
         KFriction=0.600000
         KRestitution=0.300000
         KImpactThreshold=250.000000
     End Object
     KParams=PawnKParams

     //////////////////////////////////////////////////////
     //This portion deals with the ragdoll after a zed dies
     //We want their corpses to stay like they did in KFMod
     //Zeds don't deres here!
     DeResTime=0.000000
     //Ragdolls stay forever!
     RagdollLifeSpan=0.000000
     //Ragdoll Impact Sounds we got from GeneralImpacts
     RagImpactSounds(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Breakbone_01'
     RagImpactSounds(1)=Sound'KFOldSchoolZeds_Sounds.Shared.Breakbone_02'
     RagImpactSounds(2)=Sound'KFOldSchoolZeds_Sounds.Shared.Breakbone_03'
     RagImpactSoundInterval=0.500000
     //Other Ragdoll properties
     RagDeathVel=150.000000
     RagShootStrength=6000.000000
     RagDeathUpKick=170.000000
     RagGravScale=1.500000
     RagSpinScale=2.500000
     //This is something introduced in Retail, might have to
     //Do an overhaul on play dying just for this?
     RagMaxSpinAmount=1.000000
     //////////////////////////////////////////////////////
}