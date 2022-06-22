//Controller class for Explosive Gunner Pound ✓
class ControllerExplosivePound extends KFMonsterControllerOS;

var    float   WaitAnimTimeout;
var    int     AnimWaitChannel;
var    name    AnimWaitingFor;
var    bool    bDoneSpottedCheck;

state DoorBashing
{
    ignores EnemyNotVisible,SeeMonster;

    function EndState()
    {
        if (Pawn != None)
        {
            Pawn.AccelRate = Pawn.Default.AccelRate;
            Pawn.GroundSpeed = ZombieExplosivesPoundOS(Pawn).GetOriginalGroundSpeed();
        }
    }
}

//Players call out his Chainsaw when he sees them
state ZombieHunt
{
    event SeePlayer(Pawn SeenPlayer)
    {
        if ( !bDoneSpottedCheck && PlayerController(SeenPlayer.Controller) != none )
        {
            if ( !KFGameType(Level.Game).bDidSpottedScrakeMessage && FRand() < 0.25 )
            {
                PlayerController(SeenPlayer.Controller).Speech('AUTO', 14, "");
                KFGameType(Level.Game).bDidSpottedScrakeMessage = true;
            }

            bDoneSpottedCheck = true;
        }

        super.SeePlayer(SeenPlayer);
    }
}

function bool FireWeaponAt(Actor A)
{
    if ( A == none )
        A = Enemy;

    if ( (A == none) || (Focus != A) )
        return false;

    Target = A;

    if(ZombieExplosivesPoundOS(Pawn).Health / ZombieExplosivesPoundOS(Pawn).HealthMax < 0.5 )
        Monster(Pawn).RangedAttack(Target);

    if((VSize(A.Location - Pawn.Location) >= ZombieExplosivesPoundOS(Pawn).MeleeRange + Pawn.CollisionRadius + Target.CollisionRadius) &&
        ZombieExplosivesPoundOS(Pawn).LastGLTime - Level.TimeSeconds > 0 )
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
    function GetOutOfTheWayOfShot(vector ShotDirection, vector ShotOrigin){}

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
    While( Monster(Pawn).bShotAnim )
        Sleep(0.25);
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

        if (Pawn != None)
        {
            Pawn.AccelRate = Pawn.Default.AccelRate;
            Pawn.GroundSpeed = ZombieExplosivesPoundOS(Pawn).GetOriginalGroundSpeed();
        }
        bUseFreezeHack = False;

        AnimWaitingFor = '';
    }
}

function float AdjustAimError(float aimerror, float TargetDist, bool bDefendMelee, bool bInstantProj, bool bLeadTargetNow )
{
    //Always have the best accuracy, otherwise you aren't a threat
    return aimerror*=0;
}

defaultproperties{}