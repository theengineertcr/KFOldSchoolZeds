//Because we want the zeds to extend to KFMonsterOS,
//We'll need to overhaul all class files of each zed, 
//Controllers as well if we count certain Zeds

// Chainsaw Zombie Monster for KF Invasion gametype
// He's not quite as speedy as the other Zombies, But his attacks are TRULY damaging.
class ZombieScrakeOS extends ZombieScrakeBaseOS
    abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

//----------------------------------------------------------------------------
// NOTE: All Variables are declared in the base class to eliminate hitching
//----------------------------------------------------------------------------

//Issues:
//Head Hitbox is kinda wonky, though it might be fine now?
//Needs more testing and user feedback.

//Same as KFMod
simulated function PostNetBeginPlay()
{
    EnableChannelNotify ( 1,1);
    AnimBlendParams(1, 1.0, 0.0,, SpineBone1);
    super.PostNetBeginPlay();
}

simulated function PostNetReceive()
{
    if (bCharging)
        MovementAnims[0]='ZombieRun';//'ChargeF'; Use the Gorefast charging anim
    else if( !(bCrispified && bBurnified) )
        MovementAnims[0]=default.MovementAnims[0];
}

//Not sure what the SetMindControlled function does, so were keeping it
// This zed has been taken control of. Boost its health and speed
function SetMindControlled(bool bNewMindControlled)
{
    if( bNewMindControlled )
    {
        NumZCDHits++;

        // if we hit him a couple of times, make him rage!
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

//Retail code we'll keep
// Handle the zed being commanded to move to a new location
function GivenNewMarker()
{
    if( bCharging && NumZCDHits > 1  )
    {
        GotoState('RunningToMarker');
    }
    else
    {
        GotoState('');
    }
}

//Retail code we'll keep
simulated function SetBurningBehavior()
{
    // If we're burning stop charging
    if( Role == Role_Authority && IsInState('RunningState') )
            {
        super.SetBurningBehavior();
        GotoState('');
            }

    super.SetBurningBehavior();
}

function RangedAttack(Actor A)
{
    //Retail variable
    local float Dist;

    Dist = VSize(A.Location - Location);
    
    if ( bShotAnim || Physics == PHYS_Swimming)
        return; //DistBeforeSaw added here
    else if ( Dist < (MeleeRange - DistBeforeSaw + CollisionRadius + A.CollisionRadius) && CanAttack(A) )
    {
        bShotAnim = true;
        SetAnimAction(MeleeAnims[Rand(2)]);
        CurrentDamType = ZombieDamType[0];
        PlaySound(sound'Claw2s', SLOT_None);//We have this sound, so we can play it
        GoToState('SawingLoop');
    }

    //Do more melee damage on the slower attack
    //And do less on the faster attack
    if(AnimAction == MeleeAnims[0])
        MeleeDamage = default.MeleeDamage*0.85;
    else if(AnimAction == MeleeAnims[1])
        MeleeDamage = default.MeleeDamage*1.15;
    else
        MeleeDamage = default.MeleeDamage;
        
    //Code that handles running when low on health, we need it
    //As we want retail Scrake behaviour, even if the Mod didn't have it
    if( !bShotAnim && !bDecapitated )
    {
        if ( Level.Game.GameDifficulty < 5.0 )
        {
            if ( float(Health)/HealthMax < 0.5 )
                GoToState('RunningState');
        }
        else
        {
            if ( float(Health)/HealthMax < 0.75 ) // Changed Rage Point from 0.5 to 0.75 in Balance Round 1(applied to only Suicidal and HoE in Round 7)
                GoToState('RunningState');
        }
    }
}

//Dont touch this retail code
state RunningState
{
    // Set the zed to the zapped behavior
    simulated function SetZappedBehavior()
    {
        Global.SetZappedBehavior();
        GoToState('');
    }

    // Don't override speed in this state
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
            SetGroundSpeed(OriginalGroundSpeed * 3.5);
            bCharging = true;
            if( Level.NetMode!=NM_DedicatedServer )
                PostNetReceive();

            NetUpdateTime = Level.TimeSeconds - 1;
        }
    }

    function EndState()
    {
        if( !bZapped )
        {
            SetGroundSpeed(GetOriginalGroundSpeed());
        }
        bCharging = False;
        if( Level.NetMode!=NM_DedicatedServer )
            PostNetReceive();
    }

    function RemoveHead()
    {
        GoToState('');
        Global.RemoveHead();
    }

    function RangedAttack(Actor A)
    {
        //Retail variable
        local float Dist;
        
        Dist = VSize(A.Location - Location);
        //Get even closer before doing an attack so you can get a
        //Guaranteed hit on the player!
        DistBeforeSaw = 20.0;
        
        if ( bShotAnim || Physics == PHYS_Swimming)
            return; //Added it here just incase
        else if ( Dist < (MeleeRange - DistBeforeSaw + CollisionRadius + A.CollisionRadius) && CanAttack(A) )
        {
            bShotAnim = true;
            //Code that makes it so Scrake on suicidal+ prefers attack 1 instead of 2 while charging
            if(Level.Game.GameDifficulty < 5.0)
                SetAnimAction(MeleeAnims[Rand(2)]);
            else
                SetAnimAction(MeleeAnims[0]);
            CurrentDamType = ZombieDamType[0];
            GoToState('SawingLoop');
        }
    }
}

// State where the zed is charging to a marked location.
// Not sure if we need this, but we'll keep it
state RunningToMarker extends RunningState
{
}


State SawingLoop
{
    //Keep this retail code
    // Don't override speed in this state
    function bool CanSpeedAdjust()
    {
        return false;
    }

    function bool CanGetOutOfWay()
    {
        return false;
    }

    function RangedAttack(Actor A)
    {
        if ( bShotAnim )
            return; //We dont need distance checking for sawing
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
        Super.AnimEnd(Channel);
        if( Controller!=None && Controller.Enemy!=None )
            RangedAttack(Controller.Enemy); // Keep on attacking if possible.
    }

    //Removed unnecessary code and added in some to increase Head Hitbox
    //Whenever he's doing his running animation because whenever he's
    //Doing that specific animation, he can't be headshot
    simulated function Tick(float DeltaTime)
    {
        if( MovementAnims[0] == 'ZombieRun' && !bShotAnim)
        {
            HeadScale=3.3;
            OnlineHeadshotScale=3.5;
        }
        else
        {
            HeadScale=default.HeadScale;
            OnlineHeadshotScale=default.OnlineHeadshotScale;
        }
        // Keep the scrake moving toward its target when attacking
        if( Role == ROLE_Authority && bShotAnim && !bWaitForAnim )
        {
            if( LookTarget!=None )
            {
                Acceleration = AccelRate * Normal(LookTarget.Location - Location);
            }
        }
    
        global.Tick(DeltaTime);
    }

    function EndState()
    {
        MeleeDamage = Max( DifficultyDamageModifer() * default.MeleeDamage, 1 );

        SetGroundSpeed(GetOriginalGroundSpeed());
        bCharging = False;
        if( Level.NetMode!=NM_DedicatedServer )
            PostNetReceive();
    }
}

//Dont touch this
// Added in Balance Round 1 to reduce the headshot damage taken from Crossbows
function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    local bool bIsHeadShot;
    local PlayerController PC;
    local KFSteamStatsAndAchievements Stats;

    bIsHeadShot = IsHeadShot(Hitlocation, normal(Momentum), 1.0);

    if ( Level.Game.GameDifficulty >= 5.0 && bIsHeadshot && (class<DamTypeCrossbow>(damageType) != none || class<DamTypeCrossbowHeadShot>(damageType) != none) )
    {
        Damage *= 0.5; // Was 0.5 in Balance Round 1, then 0.6 in Round 2, back to 0.5 in Round 3
    }

    Super.takeDamage(Damage, instigatedBy, hitLocation, momentum, damageType, HitIndex);

    // Added in Balance Round 3 to make the Scrake "Rage" more reliably when his health gets low(limited to Suicidal and HoE in Round 7)
    if ( Level.Game.GameDifficulty >= 5.0 && !IsInState('SawingLoop') && !IsInState('RunningState') && float(Health) / HealthMax < 0.75 )
        RangedAttack(InstigatedBy);

    //Can remove this but I dont want to
    if( damageType == class'DamTypeDBShotgun' )
    {
        PC = PlayerController( InstigatedBy.Controller );
        if( PC != none )
        {
            Stats = KFSteamStatsAndAchievements( PC.SteamStatsAndAchievements );
            if( Stats != none )
            {
                Stats.CheckAndSetAchievementComplete( Stats.KFACHIEVEMENT_PushScrakeSPJ );
            }
        }
    }
}

//More or less same as KFMod code
function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
    local int StunChance;

    StunChance = rand(5);

    if( Level.TimeSeconds - LastPainAnim < MinTimeBetweenPainAnims )
        return;

    if( (Level.Game.GameDifficulty < 5.0 || StunsRemaining != 0) && (Damage>=150 || (DamageType.name=='DamTypeStunNade' && StunChance>3) || (DamageType.name=='DamTypeCrossbowHeadshot' && Damage>=200)) )
        PlayDirectionalHit(HitLocation);

    LastPainAnim = Level.TimeSeconds;

    if( Level.TimeSeconds - LastPainSound < MinTimeBetweenPainSounds )
        return;

    LastPainSound = Level.TimeSeconds;
    PlaySound(HitSound[0], SLOT_Pain,1.25,,400);
}

//Overhauled with KFMod Code
simulated function int DoAnimAction( name AnimName )
{
    if( AnimName=='SawZombieAttack1' || AnimName=='SawZombieAttack2' || AnimName=='SawImpaleLoop' )
    {
        AnimBlendParams(1, 1.0, 0.0,, 'Bip01 Spine1');
        PlayAnim(AnimName,, 0.0, 1);
        Return 1;
    }
    Return Super.DoAnimAction(AnimName);
}

//Retail code we'll keep
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

    if( AnimNeedsWait(NewAction) )
    {
        bWaitForAnim = true;
    }

    if( Level.NetMode!=NM_Client )
    {
        AnimAction = NewAction;
        bResetAnimAct = True;
        ResetAnimActTime = Level.TimeSeconds+0.3;
    }
}

//Retail code we'll keep
// The animation is full body and should set the bWaitForAnim flag
simulated function bool AnimNeedsWait(name TestAnim)
{
    if( TestAnim == 'SawImpaleLoop' || TestAnim == 'DoorBash' || TestAnim == 'KnockDown' )
    {
        return true;
    }

    return false;
}


//We'll keep this Retail code, but without the Exhaust Effect code
// Maybe spawn some chunks when the player gets obliterated
simulated function SpawnGibs(Rotator HitRotation, float ChunkPerterbation)
{
    super.SpawnGibs(HitRotation,ChunkPerterbation);
}

//Precache KFMod textures
static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Scrake.ScrakeSkin');
    myLevel.AddPrecacheMaterial(TexOscillator'KFOldSchoolZeds_Textures.Scrake.SawChainOSC');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Scrake.ScrakeFrockSkin');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Scrake.ScrakeSawSkin');
}

defaultproperties
{
    //-------------------------------------------------------------------------------
    // NOTE: Most Default Properties are set in the base class to eliminate hitching
    //-------------------------------------------------------------------------------

    //Use KFMod Controller    
    ControllerClass=Class'KFOldSchoolZedsChar.SawZombieControllerOS'
}
