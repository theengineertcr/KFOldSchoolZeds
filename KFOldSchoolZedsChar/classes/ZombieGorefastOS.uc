//Because we want the zeds to extend to KFMonsterOS,
//We'll need to overhaul all class files of each zed, 
//Controllers as well if we count certain Zeds

// Zombie Monster for KF Invasion gametype
// GOREFAST.
// He's speedy, and swings with a Single enlongated arm, affording him slightly more range
class ZombieGoreFastOS extends ZombieGoreFastBaseOS
    abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

//----------------------------------------------------------------------------
// NOTE: All Variables are declared in the base class to eliminate hitching
//----------------------------------------------------------------------------

//Issues:
// Online head hitboxes dont scale while charging

simulated function PostNetReceive()
{
    if( !bZapped )
    {
        //Not sure if repositioning the head Hitboxes is a great idea, but we'll do it anyway
        if (bRunning)
        {
            MovementAnims[0]='ZombieRun';
            
            //If he's not attacking, increase his Z's Offset
            if( !bShotAnim )
            {
                OnlineHeadshotOffset.Z=30;
            }
            else
            {
                OnlineHeadshotOffset.Z=45;
            }                
        }
        else
        {
            MovementAnims[0]=default.MovementAnims[0];
            OnlineHeadshotOffset.Z=45;
        }
    }
}

//Not sure what this is used for so we'll keep it
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

//Not sure what this is used for so we'll keep it
// Handle the zed being commanded to move to a new location
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

//KFMod Code
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
    Super.RangedAttack(A);
    if( !bShotAnim && !bDecapitated && VSize(A.Location-Location)<=700 ) //VSize was 300 in KFMod, dont change though
    {
        GoToState('RunningState');
        
        //Additional increase here just incase
        //OnlineHeadshotScale = 3.0;
    }
    //TODO: Figure out if we need to revert back to original here as well?
}

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
            SetGroundSpeed(OriginalGroundSpeed * 1.875); //Was 1.5 in KFMod
            bRunning = true;
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
        bRunning = False;
        if( Level.NetMode!=NM_DedicatedServer )
            PostNetReceive();
        
        //RunAttackTimeout=0;

        NetUpdateTime = Level.TimeSeconds - 1;
    }

    function RemoveHead()
    {
        GoToState('');
        Global.RemoveHead();
    }

    //Old zeds don't support charging(full body anims), so all charging code removed
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
            // Once we attack stop running
            GoToState('');
            return;
        }
    }

    //Added in code to increase Head Hitbox whenever Gorefasts
    //Do their running animation because during that specific
    //Animation, they can't be headshot
    simulated function Tick(float DeltaTime)
    {
        local int i;
        
        //For some reason, this does not work on Network games
        if( MovementAnims[i] == 'ZombieRun' && !bShotAnim)
        {
            OnlineHeadshotOffset.Z=30;
        }
        else
        {
            OnlineHeadshotOffset.Z=45;
        }
    
        //Gorefasts dont attack and move
        // Keep the gorefast moving toward its target when attacking
        //if( Role == ROLE_Authority && bShotAnim && !bWaitForAnim )
        //{
        //    if( LookTarget!=None )
        //    {
        //        Acceleration = AccelRate * Normal(LookTarget.Location - Location);
        //    }
        //}
    
        global.Tick(DeltaTime);
    }


Begin:
    GoTo('CheckCharge');
CheckCharge:
    if( Controller!=None && Controller.Target!=None && VSize(Controller.Target.Location-Location)<700 ) 
    {
        Sleep(0.5+ FRand() * 0.5); 
        //log("Still charging");
        GoTo('CheckCharge');
    }
    else
    {
        //log("Done charging");
        GoToState('');
    }
}

// State where the zed is charging to a marked location.
state RunningToMarker extends RunningState
{
    simulated function Tick(float DeltaTime)
    {
        local int i;
        
        //For some reason, this does not work on Network games
        if( MovementAnims[i] == 'ZombieRun' && !bShotAnim)
        {
            OnlineHeadshotOffset.Z=30;
        }
        else
        {
            OnlineHeadshotOffset.Z=45;
        }
        
        // Keep the gorefast moving toward its target when attacking
        //if( Role == ROLE_Authority && bShotAnim && !bWaitForAnim )
        //{
        //    if( LookTarget!=None )
        //    {
        //        Acceleration = AccelRate * Normal(LookTarget.Location - Location);
        //    }
        //}
    
        global.Tick(DeltaTime);
    }

Begin:
    GoTo('CheckCharge');
CheckCharge:
    if( bZedUnderControl || (Controller!=None && Controller.Target!=None && VSize(Controller.Target.Location-Location)<700) )
    {
        Sleep(0.5+ FRand() * 0.5);
        GoTo('CheckCharge');
    }
    else
    {
        GoToState('');
    }
}


//Precache KFMod textures
static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Gorefast.GorefastSkin');
}

defaultproperties
{
    //-------------------------------------------------------------------------------
    // NOTE: Most Default Properties are set in the base class to eliminate hitching
    //-------------------------------------------------------------------------------
    
    //Use KFMod Controller
    ControllerClass=Class'KFOldSchoolZedsChar.GorefastControllerOS'
}
