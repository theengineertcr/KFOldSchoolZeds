//-----------------------------------------------------------
//
//-----------------------------------------------------------
class RangedPoundGLZombieControllerOS extends KFMonsterControllerOS;

//var NavigationPoint HidingSpots;

//Dont touch these retail variables
var     float       WaitAnimTimeout;    // How long until the Anim we are waiting for is completed; Hack so the server doesn't get stuck in idle when its doing the Rage anim
var     int         AnimWaitChannel;    // The channel we are waiting to end in WaitForAnim
var     name        AnimWaitingFor;     // The animation we are waiting to end in WaitForAnim, mostly used for debugging


// Overridden to create a delay between when the Rangedpound fires his minigun
function bool FireWeaponAt(Actor A)
{
    if ( A == None )
        A = Enemy;
    if ( (A == None) || (Focus != A) )
        return false;
    Target = A;

    //ZombieHusk to ZombieRangedPoundGLOS
    if( (VSize(A.Location - Pawn.Location) >= ZombieRangedPoundGLOS(Pawn).MeleeRange + Pawn.CollisionRadius + Target.CollisionRadius) &&
        ZombieRangedPoundGLOS(Pawn).LastGLTime - Level.TimeSeconds > 0 )
    {
        return false;
    }

    Monster(Pawn).RangedAttack(Target);
    return false;
}

//Same as KFMod
function TimedFireWeaponAtEnemy()
{
    if ( (Enemy == None) || FireWeaponAt(Enemy) )
        SetCombatTimer();
    else
        SetTimer(0.01, True);
}


//We'll keep this because it might have to do with the Ranged Attack
//Exactly same as in KFMod
state ZombieCharge
{
    function bool StrafeFromDamage(float Damage, class<DamageType> DamageType, bool bFindDest)
    {
        return false;
    }

    // I suspect this function causes bloats to get confused
    function bool TryStrafe(vector sideDir)
    {
        return false;
    }

    function Timer()
    {
        Disable('NotifyBump');
        Target = Enemy;
        TimedFireWeaponAtEnemy();
    }

WaitForAnim:

    if ( Monster(Pawn).bShotAnim )
    {
        Goto('Moving');
    }
    if ( !FindBestPathToward(Enemy, false,true) )
        GotoState('ZombieRestFormation');
Moving:
    MoveToward(Enemy);
    WhatToDoNext(17);
    if ( bSoaking )
        SoakStop("STUCK IN CHARGING!");
}


//The rest of this is Retail Code that we'll keep
// Used to set a timeout for the WaitForAnim state. This is a bit of a hack fix
// for the Patriach getting stuck in its idle anim on a dedicated server when it
// is supposed to doing something. For some reason, on a dedicated server only, it
// never gets an animend call for some of the anims, instead the anim gets
// interrupted by the idle anim. If we figure that bug out, we can
// probably take this out in the future. But for now the fix works - Ramm
function SetWaitForAnimTimout(float NewWaitAnimTimeout, name AnimToWaitFor)
{
    WaitAnimTimeout = NewWaitAnimTimeout;
    AnimWaitingFor = AnimToWaitFor;
}

state WaitForAnim
{
Ignores SeePlayer,HearNoise,Timer,EnemyNotVisible,NotifyBump,Startle;


    // The anim has ended, clear the flags and let the AI do its thing
    function WaitTimeout()
    {
        if( bUseFreezeHack )
        {
            if( Pawn!=None )
            {
                Pawn.AccelRate = Pawn.Default.AccelRate;
                Pawn.GroundSpeed = Pawn.Default.GroundSpeed;
            }
            bUseFreezeHack = False;
        }

        AnimEnd(AnimWaitChannel);
    }

    event AnimEnd(int Channel)
    {
        /*local name  Sequence;
        local float Frame, Rate;


        Pawn.GetAnimParams( KFMonster(Pawn).ExpectingChannel, Sequence, Frame, Rate );

        log(GetStateName()$" AnimEnd for Exp Chan "$KFMonster(Pawn).ExpectingChannel$" = "$Sequence$" Channel = "$Channel);

        Pawn.GetAnimParams( 0, Sequence, Frame, Rate );
        log(GetStateName()$" AnimEnd for Chan 0 = "$Sequence);

        Pawn.GetAnimParams( 1, Sequence, Frame, Rate );
        log(GetStateName()$" AnimEnd for Chan 1 = "$Sequence);

        log(GetStateName()$" AnimEnd bShotAnim = "$Monster(Pawn).bShotAnim); */

        Pawn.AnimEnd(Channel);
        if ( !Monster(Pawn).bShotAnim )
            WhatToDoNext(99);
    }

    function Tick( float Delta )
    {
        Global.Tick(Delta);

        if( WaitAnimTimeout > 0 )
        {
            WaitAnimTimeout -= Delta;

            if( WaitAnimTimeout <= 0 )
            {
                WaitAnimTimeout = 0;
                WaitTimeout();
            }
        }

        if( bUseFreezeHack )
        {
            MoveTarget = None;
            MoveTimer = -1;
            Pawn.Acceleration = vect(0,0,0);
            Pawn.GroundSpeed = 1;
            Pawn.AccelRate = 0;
        }
    }
    function EndState()
    {
        super.EndState();

        AnimWaitingFor = '';
    }
}

defaultproperties
{
}
