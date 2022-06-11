//Controller class for Fleshpound ✓
class ControllerFleshpoundOS extends KFMonsterControllerOS;

var     float   RageAnimTimeout;
var     bool    bDoneSpottedCheck;
var     float   RageFrustrationTimer;
var     float   RageFrustrationThreshhold;
var     bool    bEnableOldFleshpoundBehavior;

state ZombieHunt
{
    event SeePlayer(Pawn SeenPlayer)
    {
        if ( !bDoneSpottedCheck && PlayerController(SeenPlayer.Controller) != none )
        {
            if ( !KFGameType(Level.Game).bDidSpottedFleshpoundMessage && FRand() < 0.25 )
            {
                PlayerController(SeenPlayer.Controller).Speech('AUTO', 12, "");
                KFGameType(Level.Game).bDidSpottedFleshpoundMessage = true;
            }

            bDoneSpottedCheck = true;
        }

        super.SeePlayer(SeenPlayer);
    }
}

function TimedFireWeaponAtEnemy()
{
    if ( (Enemy == none) || FireWeaponAt(Enemy) )
        SetCombatTimer();
    else
        SetTimer(0.01, true);
}

state SpinAttack
{
ignores EnemyNotVisible;

    function GetOutOfTheWayOfShot(vector ShotDirection, vector ShotOrigin){}

    function DoSpinDamage()
    {
        local Actor A;

        foreach CollidingActors(class'actor', A, (ZombieFleshpoundOS(pawn).MeleeRange * 1.5)+pawn.CollisionRadius, pawn.Location)
            ZombieFleshpoundOS(pawn).SpinDamage(A);
    }

Begin:

WaitForAnim:
    While( KFM.bShotAnim )
    {
        Sleep(0.1);
        DoSpinDamage();
    }

    WhatToDoNext(152);
    if ( bSoaking )
        SoakStop("STUCK IN SPINATTACK!!!");
}

state ZombieCharge
{
    function Tick( float Delta )
    {
        local ZombieFleshpoundOS ZFP;
        Global.Tick(Delta);

        if( RageFrustrationTimer < RageFrustrationThreshhold && !bEnableOldFleshpoundBehavior )
        {
            RageFrustrationTimer += Delta;

            if( RageFrustrationTimer >= RageFrustrationThreshhold )
            {
                ZFP = ZombieFleshpoundOS(Pawn);

                if( ZFP != none && !ZFP.bChargingPlayer )
                {
                    ZFP.StartCharging();
                    ZFP.bFrustrated = true;
                }
            }
        }
    }

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

    function BeginState()
    {
        super.BeginState();

        if(!bEnableOldFleshpoundBehavior)
        {
        RageFrustrationThreshhold = default.RageFrustrationThreshhold + (Frand() * 5);
        RageFrustrationTimer = 0;
        }
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

function SetPoundRageTimout(float NewRageTimeOut)
{
    RageAnimTimeout = NewRageTimeOut;
}

state WaitForAnim
{
Ignores SeePlayer,HearNoise,Timer,EnemyNotVisible,NotifyBump;

    function GetOutOfTheWayOfShot(vector ShotDirection, vector ShotOrigin){}

    function BeginState()
    {
        bUseFreezeHack = false;
    }

    function RageTimeout()
    {
        if( bUseFreezeHack )
        {
            if( Pawn!=none )
            {
                Pawn.AccelRate = Pawn.default.AccelRate;
                Pawn.GroundSpeed = Pawn.default.GroundSpeed;
            }
            bUseFreezeHack = false;
            AnimEnd(0);
        }
    }

    function Tick( float Delta )
    {
        Global.Tick(Delta);

        if( RageAnimTimeout > 0 )
        {
            RageAnimTimeout -= Delta;

            if( RageAnimTimeout <= 0 )
            {
                RageAnimTimeout = 0;
                RageTimeout();
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
        if( Pawn!=none )
        {
            Pawn.AccelRate = Pawn.default.AccelRate;
            Pawn.GroundSpeed = Pawn.default.GroundSpeed;
        }
        bUseFreezeHack = false;
    }

Begin:
    While( KFM.bShotAnim )
    {
        Sleep(0.15);
    }
    WhatToDoNext(99);
}

defaultproperties
{
    RageFrustrationThreshhold=10.0
}