//Controller class for Gunner Pound ✓
class ControllerRangedPoundOS extends KFMonsterControllerOS;

var     float       WaitAnimTimeout;
var     int         AnimWaitChannel;
var     name        AnimWaitingFor;


function bool FireWeaponAt(Actor A)
{
    if ( A == none )
        A = Enemy;
    if ( (A == none) || (Focus != A) )
        return false;
    Target = A;

    if( (VSize(A.Location - Pawn.Location) >= ZombieRangedPoundOS(Pawn).MeleeRange + Pawn.CollisionRadius + Target.CollisionRadius) &&
        ZombieRangedPoundOS(Pawn).LastChainGunTime - Level.TimeSeconds > 0 )
    {
        return false;
    }

    Monster(Pawn).RangedAttack(Target);
    return false;
}

function TimedFireWeaponAtEnemy()
{
    if ( (Enemy == none) || FireWeaponAt(Enemy) )
        SetCombatTimer();
    else
        SetTimer(0.01, true);
}


state ZombieCharge
{
    function bool StrafeFromDamage(float Damage, class<DamageType> DamageType, bool bFindDest)
    {
        return false;
    }

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


function SetWaitForAnimTimout(float NewWaitAnimTimeout, name AnimToWaitFor)
{
    WaitAnimTimeout = NewWaitAnimTimeout;
    AnimWaitingFor = AnimToWaitFor;
}

state WaitForAnim
{
Ignores SeePlayer,HearNoise,Timer,EnemyNotVisible,NotifyBump,Startle;


    function WaitTimeout()
    {
        if( bUseFreezeHack )
        {
            if( Pawn!=none )
            {
                Pawn.AccelRate = Pawn.default.AccelRate;
                Pawn.GroundSpeed = Pawn.default.GroundSpeed;
            }
            bUseFreezeHack = false;
        }

        AnimEnd(AnimWaitChannel);
    }

    event AnimEnd(int Channel)
    {

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
            MoveTarget = none;
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

defaultproperties{}