//Because we want the zeds to extend to KFMonsterOS,
//We'll need to overhaul all class files of each zed,
//Controllers as well if we count certain Zeds

// Zombie Monster for KF Invasion gametype
class ZombieClotOS extends ZombieClotBaseOS
    abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

//----------------------------------------------------------------------------
// NOTE: All Variables are declared in the base class to eliminate hitching
//----------------------------------------------------------------------------

//Issues:
//Possible incompatability with Serverperks because of grabbing code?

//We'll use a combination of necessary Retail code and Old Code
function ClawDamageTarget()
{
    local vector PushDir;
    local KFPawn KFP;
    local float UsedMeleeDamage;


    if( MeleeDamage > 1 )
    {
       UsedMeleeDamage = (MeleeDamage - (MeleeDamage * 0.05)) + (MeleeDamage * (FRand() * 0.1));
    }
    else
    {
       UsedMeleeDamage = MeleeDamage;
    }

    // If zombie has latched onto us...
    if ( MeleeDamageTarget( UsedMeleeDamage, PushDir))
    {
        KFP = KFPawn(Controller.Target);

        if( !bDecapitated && KFP != none )
        {
            //Had to change this or the Clot will grab Berserkers
            //TODO:Make this Custom perk friendly somehow?
            if ( KFPlayerReplicationInfo(KFP.PlayerReplicationInfo).ClientVeteranSkill != class'KFVetBerserker')
            {
                if( DisabledPawn != none )
                {
                     DisabledPawn.bMovementDisabled = false;
                }

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
        //Bash that door
        SetAnimAction('DoorBash');
        //Play the Clawing noise here
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
        //We dont need this return, Clots dont play different anims after grabbing
        //return;
        //KFMod code to make the Clot move towards the target he is grappling
        Acceleration = Normal(A.Location-Location)*600;
        Controller.GoToState('WaitForAnim');
        Controller.MoveTarget = A;
        Controller.MoveTimer = 1.5;
    }
}

//We need clots to attack doors, not grapple them
simulated event SetAnimAction(name NewAction)
{
    local int meleeAnimIndex;

    if( NewAction=='' )
        Return;
    if(NewAction == 'Claw')
    {
        meleeAnimIndex = Rand(3);
        NewAction = meleeAnims[2];
        CurrentDamtype = ZombieDamType[meleeAnimIndex];
    }
    else if( NewAction == 'DoorBash' )
    {
       NewAction = meleeAnims[rand(2)];
       CurrentDamtype = ZombieDamType[Rand(3)];
    }

    ExpectingChannel = DoAnimAction(NewAction);

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


////This wasn't in KFMod, but we need it for voicelines
simulated function int DoAnimAction( name AnimName )
{
    //There is no ClotGrappleTwo or ClotGrappleThree, so we got rid of them
    if( AnimName=='ClotGrapple' )
    {
        //Dont need anything but voicelines
        //AnimBlendParams(1, 1.0, 0.1,, FireRootBone);
        //PlayAnim(AnimName,, 0.1, 1);

        // Randomly send out a message about Clot grabbing you(10% chance)
        if ( FRand() < 0.10 && LookTarget != none && KFPlayerController(LookTarget.Controller) != none &&
             VSizeSquared(Location - LookTarget.Location) < 2500 /* (MeleeRange + 20)^2 */ &&
             Level.TimeSeconds - KFPlayerController(LookTarget.Controller).LastClotGrabMessageTime > ClotGrabMessageDelay &&
             KFPlayerController(LookTarget.Controller).SelectedVeterancy != class'KFVetBerserker' )
        {
            PlayerController(LookTarget.Controller).Speech('AUTO', 11, "");
            KFPlayerController(LookTarget.Controller).LastClotGrabMessageTime = Level.TimeSeconds;
        }
    }
    return super.DoAnimAction( AnimName );
}

function RemoveHead()
{
    Super.RemoveHead();
    MeleeAnims[0] = 'Claw';
    MeleeAnims[1] = 'Claw';
    MeleeAnims[2] = 'Claw2';

    MeleeDamage *= 2;
    MeleeRange *= 2;
}


//Keep this
static simulated function PreCacheStaticMeshes(LevelInfo myLevel)
{//should be derived and used.
   Super.PreCacheStaticMeshes(myLevel);
///*
//    myLevel.AddPrecacheStaticMesh(StaticMesh'kf_gore_trip_sm.clot.clothead_piece_1');
//    myLevel.AddPrecacheStaticMesh(StaticMesh'kf_gore_trip_sm.clot.clothead_piece_2');
//    myLevel.AddPrecacheStaticMesh(StaticMesh'kf_gore_trip_sm.clot.clothead_piece_3');
//    myLevel.AddPrecacheStaticMesh(StaticMesh'kf_gore_trip_sm.clot.clothead_piece_4');
//    myLevel.AddPrecacheStaticMesh(StaticMesh'kf_gore_trip_sm.clot.clothead_piece_5');
//    myLevel.AddPrecacheStaticMesh(StaticMesh'kf_gore_trip_sm.clot.clothead_piece_6');
//*/
}

//Use KFMod textures for precache
static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Clot.ClotSkin');
}

defaultproperties
{
    //-------------------------------------------------------------------------------
    // NOTE: Most Default Properties are set in the base class to eliminate hitching
    //-------------------------------------------------------------------------------
}