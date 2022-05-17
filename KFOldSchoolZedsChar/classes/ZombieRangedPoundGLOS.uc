//Because we want the zeds to extend to KFMonsterOS,
//We'll need to overhaul all class files of each zed, 
//Controllers as well if we count certain Zeds

// A "mini" patty that fires incendiary rounds as a Husk replacement
class ZombieRangedPoundGLOS extends ZombieRangedPoundGLBaseOS
    abstract;

//Issues
//Does not always play the FireMGEnd animation after he's finished firing,
//Resulting in him walking weirdly towards the player. Try to suss it out using logs?

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KF_M79Snd.uax

//----------------------------------------------------------------------------
// NOTE: Most Variables are declared in the base class to eliminate hitching
//----------------------------------------------------------------------------

//Grenades!
var class<Projectile> GunnerProjClass;


//We'll keep this retail code
function vector ComputeTrajectoryByTime( vector StartPosition, vector EndPosition, float fTimeEnd  )
{
    local vector NewVelocity;

    NewVelocity = Super.ComputeTrajectoryByTime( StartPosition, EndPosition, fTimeEnd );

    if( PhysicsVolume.IsA( 'KFPhysicsVolume' ) && StartPosition.Z < EndPosition.Z )
    {
        if( PhysicsVolume.Gravity.Z < class'PhysicsVolume'.default.Gravity.Z )
        {
            // Just checking mass to be extra-cautious.
            if( Mass > 900 )
            {
                // Extra velocity boost to counter oversized mass weighing the boss down.
                NewVelocity.Z += 90;
            }
        }
    }
    return NewVelocity;
}


//We want to keep this
function bool CanGetOutOfWay()
{
    return false;
}

// High damage was taken, make em fall over.
function bool FlipOver()
{
    if( Physics==PHYS_Falling )
    {
        SetPhysics(PHYS_Walking);
    }

    bShotAnim = true;
    //Ranged Pound has a unique animation for getting stunned
    GoToState('');
    SetAnimAction('RangedKnockDown');    
    HandleWaitForAnim('RangedKnockDown');
    Acceleration = vect(0, 0, 0);
    Velocity.X = 0;
    Velocity.Y = 0;
    KFMonsterController(Controller).Focus = None;
    KFMonsterController(Controller).FocalPoint = KFMonsterController(Controller).LastSeenPos;
    Controller.GoToState('WaitForAnim');
    KFMonsterController(Controller).bUseFreezeHack = True;
    Return True;
}

//-----------------------------------------------------------------------------
// PostBeginPlay
//-----------------------------------------------------------------------------

simulated function PostBeginPlay()
{
    if( Role < ROLE_Authority )
    {
        return;
    }

    // Difficulty Scaling
    // Grenade Launcher fired amount and rate of fire are set here
    // TODO: Implement these variables
    
    if (Level.Game != none)
    {
        if( Level.Game.GameDifficulty < 2.0 )
        {
            GLFireBurst = default.GLFireBurst * 0.5;
            GLFireRate = default.GLFireRate * 1.66;
        }
        else if( Level.Game.GameDifficulty < 4.0 )
        {
            GLFireBurst = default.GLFireBurst * 1.0;
            GLFireRate = default.GLFireRate * 1.0;            
        }
        else if( Level.Game.GameDifficulty < 5.0 )
        {
            GLFireBurst = default.GLFireBurst * 1.5;
            GLFireRate = default.GLFireRate * 0.8;        
        }
        else // Hardest difficulty
        {
            GLFireBurst = default.GLFireBurst * 2.0;
            GLFireRate = default.GLFireRate * 0.5;     
        }
     
    }

    super.PostBeginPlay();
}

// Copied from Husk
// don't interrupt the bloat while he is puking
simulated function bool HitCanInterruptAction()
{
    if( bShotAnim )
    {
        return false;
    }

    return true;
}

//Needed Retail Code
simulated function Destroyed()
{
    if( mTracer!=None )
        mTracer.Destroy();
    if( mMuzzleFlash!=None )
        mMuzzleFlash.Destroy();
    Super.Destroyed();
}

//Needed Retail Code
simulated Function PostNetBeginPlay()
{
    EnableChannelNotify ( 1,1);
    AnimBlendParams(1, 1.0, 0.0,, 'Bip01 Spine1'); //SpineBone1 to Bip01 Spine1
    super.PostNetBeginPlay();
    TraceHitPos = vect(0,0,0);
    bNetNotify = True;
}


//Need to overhaul this(Done!)
function RangedAttack(Actor A)
{
    local float Dist; //That distance check that was used for Siren
    local int LastFireTime; //Husk variable // Don't know if we need this

    if ( bShotAnim )
        return;
        
    Dist = VSize(A.Location-Location);
    
    //Is there a better way to do this?
    //All I want to do is tie Projectile speed to distance
    //So he doesn't overshoot or undershoot, creating classes
    //With different variables seems very efficient and I don't
    //Get how I'm supposed to do this...
    
    if (Dist < 400)
    {
        GunnerProjClass = class'GunnerGLProjectileS';
    }    
    else if(Dist < 800) 
    {
        GunnerProjClass = class'GunnerGLProjectileM';
    }
    else
    {
        GunnerProjClass = class'GunnerGLProjectile';
    }
    
    //Using the Husks code, albeit modified
    if ( Physics == PHYS_Swimming )
    {
        SetAnimAction('Claw');
        bShotAnim = true;
        LastFireTime = Level.TimeSeconds;
    }
    else if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius )
    {
        bShotAnim = true;
        LastFireTime = Level.TimeSeconds;
        SetAnimAction('Claw');
        PlaySound(sound'Claw2s', SLOT_Interact); // We have this sound, use it
        Controller.bPreparingMove = true;
        Acceleration = vect(0,0,0);    
    }
    else if ( !bWaitForAnim && !bShotAnim && !bDecapitated && LastGLTime<Level.TimeSeconds && Dist < 2000 )
    {
        LastGLTime = Level.TimeSeconds + GLFireInterval + (FRand() *2.0); //Level.TimeSeconds + 5 + FRand() * 10;

        bShotAnim = true;
        Acceleration = vect(0,0,0);
        SetAnimAction('RangedPreFireMG'); //PreFireMG
        HandleWaitForAnim('RangedPreFireMG'); //PreFireMG
        
        //How many nades to fire
         GLFireCounter =  GLFireBurst; // Balance 1 - Removed the random extra grenades
         
        //Ding ding ding! You won the lottery, and your prize is certain death!
        // Lowered the chance because this attack is pretty deadly
        if(FRand() < 0.05 && Level.Game.GameDifficulty >= 4.0) // Don't hurt the little babies who play on Easy Modo
            GLFireCounter =  GLFireBurst + 3 + Rand(4);
            
        GoToState('FireGrenades');
    }    
}

simulated function AddTraceHitFX( vector HitPos )
{
    local vector Start,SpawnVel,SpawnDir;
    local float hitDist;
    
    Start = GetBoneCoords('FireBone').Origin; //tip to FireBone
    if( mTracer==None )
        mTracer = Spawn(Class'KFMod.KFNewTracer',,,Start); //KFNewTracer from KFMod and Retail are similar, so were not replacing it
    else mTracer.SetLocation(Start);
    if( mMuzzleFlash==None )
    {
        //Swap with NewMinigunMFlash(Done!)
        mMuzzleFlash = Spawn(Class'NewMinigunMFlashOS');
        AttachToBone(mMuzzleFlash, 'FireBone'); //tip to FireBone
    }
    else mMuzzleFlash.SpawnParticle(1);
    hitDist = VSize(HitPos - Start) - 50.f;

    if( hitDist>10 )
    {
        SpawnDir = Normal(HitPos - Start);
        SpawnVel = SpawnDir * 10000.f;
        mTracer.Emitters[0].StartVelocityRange.X.Min = SpawnVel.X;
        mTracer.Emitters[0].StartVelocityRange.X.Max = SpawnVel.X;
        mTracer.Emitters[0].StartVelocityRange.Y.Min = SpawnVel.Y;
        mTracer.Emitters[0].StartVelocityRange.Y.Max = SpawnVel.Y;
        mTracer.Emitters[0].StartVelocityRange.Z.Min = SpawnVel.Z;
        mTracer.Emitters[0].StartVelocityRange.Z.Max = SpawnVel.Z;
        mTracer.Emitters[0].LifetimeRange.Min = hitDist / 10000.f;
        mTracer.Emitters[0].LifetimeRange.Max = mTracer.Emitters[0].LifetimeRange.Min;
        mTracer.SpawnParticle(1);
    }
    Instigator = Self;

    if( HitPos != vect(0,0,0) )
    {
        Spawn(class'ROBulletHitEffect',,, HitPos, Rotator(Normal(HitPos - Start))); //Can't be bothered to replace this
    }
}

function FireGLShot()
{
    local vector X,Y,Z, FireStart;
    local rotator FireRotation;
    local KFMonsterController KFMonstControl;
    
    GLFireCounter--;

    if( Controller!=None && KFDoorMover(Controller.Target)!=None )
    {
        Controller.Target.TakeDamage(22,Self,Location,vect(0,0,0),Class'DamTypeVomit');
        return;
    }

    GetAxes(Rotation,X,Y,Z);
    FireStart = GetBoneCoords('FireBone').Origin; //tip to FireBone
    //GunnerProjClass = Class'KFOldSchoolZedsMod.GunnerGLProjectile';
    
    if ( !SavedFireProperties.bInitialized )
    {
        SavedFireProperties.AmmoClass = Class'SkaarjAmmo';
        SavedFireProperties.ProjectileClass = GunnerProjClass;
        SavedFireProperties.WarnTargetPct = 1;
        SavedFireProperties.MaxRange = 65535;
        SavedFireProperties.bTossed = False;
        SavedFireProperties.bTrySplash = true;
        SavedFireProperties.bLeadTarget = true;
        SavedFireProperties.bInstantHit = False;
        SavedFireProperties.bInitialized = True;
    }
    
    ToggleAuxCollision(false);
    
    FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);
    
    Spawn(GunnerProjClass,,,FireStart,FireRotation);
    PlaySound(sound'KF_M79Snd.M79_Fire',SLOT_Misc,2,,1400,0.9+FRand()*0.2); 
    
    ToggleAuxCollision(true);
}

//Keep this the same as retail
simulated function AnimEnd( int Channel )
{
    local name  Sequence;
    local float Frame, Rate;
    
    if( Level.NetMode==NM_Client && bGLing )
    {
        GetAnimParams( Channel, Sequence, Frame, Rate );
    
        if( Sequence != 'RangedPreFireMG' && Sequence != 'RangedFireMG' ) //PreFireMG and FireMG now use RangedPound anims
        {
            Super.AnimEnd(Channel);
            return;
        }
    
        PlayAnim('RangedFireMG'); //Rangedpound Anims
        bWaitForAnim = true;
        bShotAnim = true;
        IdleTime = Level.TimeSeconds;
    }
    else Super.AnimEnd(Channel);
}

//We'll use retail code(modified) instead of KFMod code for this
state FireGrenades
{
    function RangedAttack(Actor A)
    {
        Controller.Target = A;
        Controller.Focus = A;
    }

    function EndState()
    {
        TraceHitPos = vect(0,0,0);
        bGLing = False;

        AmbientSound = default.AmbientSound;
        SoundVolume=default.SoundVolume;
        SoundRadius=default.SoundRadius;
        GLFireCounter=0;

        LastGLTime = Level.TimeSeconds + GLFireInterval + (FRand() *2.0); //Level.TimeSeconds + 5 + FRand() * 10;
    }

    function BeginState()
    {
        bFireAtWill = False;
        Acceleration = vect(0,0,0);
        bGLing = True;
    }

    function AnimEnd( int Channel )
    {
        if( GLFireCounter <= 0 )
        {
            bShotAnim = true;
            Acceleration = vect(0,0,0);
            SetAnimAction('RangedFireMGEnd'); //RangedPound Anims
            HandleWaitForAnim('RangedFireMGEnd'); //RangedPound Anims
            GoToState('');
        }
        else
        {
            if ( Controller.Enemy != none )
            {
                if ( Controller.LineOfSightTo(Controller.Enemy) && FastTrace(GetBoneCoords('FireBone').Origin,Controller.Enemy.Location)) //tip to FireBone
                {
                    Controller.Focus = Controller.Enemy;
                    Controller.FocalPoint = Controller.Enemy.Location;
                }

                Controller.Target = Controller.Enemy;
            }

            bFireAtWill = True;
            bShotAnim = true;
            Acceleration = vect(0,0,0);

            SetAnimAction('RangedFireMG'); //Use RangedPound anim
            bWaitForAnim = true;
        }
    }

    function bool NeedToTurnFor( rotator targ )
    {
        local int YawErr;

        targ.Yaw = DesiredRotation.Yaw & 65535;
        YawErr = (targ.Yaw - (Rotation.Yaw & 65535)) & 65535;
        return !((YawErr < 2000) || (YawErr > 64535));
    }

Begin:
    While( True )
    {
        Acceleration = vect(0,0,0);

        if( GLFireCounter <= 0 )
        {
            bShotAnim = true;
            Acceleration = vect(0,0,0);
            SetAnimAction('RangedFireMGEnd'); //Ranged Anims
            HandleWaitForAnim('RangedFireMGEnd'); //Ranged Anims
            GoToState('');
        }
        
        if( bFireAtWill )
            FireGLShot();
        Sleep(GLFireRate); //0.05//Uses our own fire rate set in the base file
    }
}


simulated function PostNetReceive()
{
    if( bClientGLing != bGLing )
    {
        bClientGLing = bGLing;
        // Hack so Patriarch won't go out of MG Firing to play his idle anim online
        if( bGLing )
        {
            //Make sure all of these are RangedPound Anims
            IdleHeavyAnim='RangedFireMG';
            IdleRifleAnim='RangedFireMG';
            IdleCrouchAnim='RangedFireMG';
            IdleWeaponAnim='RangedFireMG';
            IdleRestAnim='RangedFireMG';
        }
        else
        {
            IdleHeavyAnim='RangedIdle';
            IdleRifleAnim='RangedIdle';
            IdleCrouchAnim='RangedIdle';
            IdleWeaponAnim='RangedIdle';
            IdleRestAnim='RangedIdle';
        }
    }

    //We just need this, the else if portion in the retail version is unnecessary
    if( TraceHitPos!=vect(0,0,0) )
    {
        AddTraceHitFX(TraceHitPos);
        TraceHitPos = vect(0,0,0);
    }
}

//Overhauled with KFMod Code
simulated function int DoAnimAction( name AnimName )
{
    //Removed boss anims and replaced with Ranged
    if( AnimName=='PoundPunch2' || AnimName=='RangedHitF' /*|| AnimName=='RangedFireMG'*/  ) //Removing RangedFireMG may have potentially fixed the bug with him not playing end anims
    {
        AnimBlendParams(1, 1.0, 0.0,, 'Bip01 Spine1');
        PlayAnim(AnimName,, 0.0, 1);
        Return 1;
    }
    Return Super.DoAnimAction(AnimName);
}

//We need this retail Code
simulated event SetAnimAction(name NewAction)
{
    local int meleeAnimIndex;

    if( NewAction=='' )
        Return;
    if(NewAction == 'Claw')
    {
        meleeAnimIndex = Rand(3);
        NewAction = meleeAnims[meleeAnimIndex];
        CurrentDamtype = ZombieDamType[meleeAnimIndex];
    }

    ExpectingChannel = DoAnimAction(NewAction);

    if( Controller != none )
    {
       RangedPoundGLZombieControllerOS(Controller).AnimWaitChannel = ExpectingChannel;
    }

    if( AnimNeedsWait(NewAction) )
    {
        bWaitForAnim = true;
    }
    else
    {
        bWaitForAnim = false;
    }

    if( Level.NetMode!=NM_Client )
    {
        AnimAction = NewAction;
        bResetAnimAct = True;
        ResetAnimActTime = Level.TimeSeconds+0.3;
    }
}

//We need this retail code
simulated function HandleWaitForAnim( name NewAnim )
{
    local float RageAnimDur;

    Controller.GoToState('WaitForAnim');
    RageAnimDur = GetAnimDuration(NewAnim);

    //RangedPound controller
    RangedPoundGLZombieControllerOS(Controller).SetWaitForAnimTimout(RageAnimDur,NewAnim); //BossZombieController to BossZombieControllerOS
}

//We need this retail code
// The animation is full body and should set the bWaitForAnim flag
simulated function bool AnimNeedsWait(name TestAnim)
{
    //Removed the extra patty anims
    if( TestAnim == 'RangedFireMG' || TestAnim == 'RangedPreFireMG' || TestAnim == 'RangedFireMGEnd' || TestAnim == 'RangedKnockDown') 
    {
        return true;
    }

    return false;
}


//Precache KFMod textures
static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
    myLevel.AddPrecacheMaterial(Shader'KFOldSchoolZeds_Textures.Fleshpound.PoundBitsShader');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.GunPound.AutoTurretGunTex');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.GunPound.GunPoundSkin');
}

defaultproperties
{
    //-------------------------------------------------------------------------------
    // NOTE: Most Default Properties are set in the base class to eliminate hitching
    //-------------------------------------------------------------------------------
    
    //Use Rangedpound controller
    ControllerClass=Class'KFOldSchoolZedsChar.RangedPoundGLZombieControllerOS'
    GunnerProjClass=Class'KFOldSchoolZedsMod.GunnerGLProjectile'
}
