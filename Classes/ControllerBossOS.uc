//Controller class for Patriarch ✓
class ControllerBossOS extends KFMonsterControllerOS;

var NavigationPoint HidingSpots;

var     float       WaitAnimTimeout;
var     int         AnimWaitChannel;
var     name        AnimWaitingFor;
var     bool        bAlreadyFoundEnemy;


function bool CanKillMeYet()
{
    return false;
}


function TimedFireWeaponAtEnemy()
{
    if ( (Enemy == none) || FireWeaponAt(Enemy) )
        SetCombatTimer();
    else
        SetTimer(0.01, true);
}

function FightEnemy(bool bCanCharge)
{
    if( KFM.bShotAnim )
    {
        GoToState('WaitForAnim');
        return;
    }
    if (KFM.MeleeRange != KFM.default.MeleeRange)
        KFM.MeleeRange = KFM.default.MeleeRange;

    if ( Enemy == none || Enemy.Health <= 0 )
        FindNewEnemy();

    if ( (Enemy == FailedHuntEnemy) && (Level.TimeSeconds == FailedHuntTime) )
    {
        if ( Enemy == FailedHuntEnemy )
        {
                        GoalString = "FAILED HUNT - HANG OUT";
            if ( EnemyVisible() )
                bCanCharge = false;
        }
    }
    if ( !EnemyVisible() )
    {
        if( bAlreadyFoundEnemy || ZombieBossOS(Pawn).SneakCount > 2 )
        {
            bAlreadyFoundEnemy = true;
            GoalString = "Hunt";
            GotoState('ZombieHunt');
        }
        else
        {
            ZombieBossOS(Pawn).SneakCount++;
            GoalString = "InitialHunt";
            GotoState('InitialHunting');
        }
        return;
    }

    Target = Enemy;
    GoalString = "Charge";
    PathFindState = 2;
    DoCharge();
}

state InitialHunting extends Hunting
{
    event SeePlayer(Pawn SeenPlayer)
    {
        super.SeePlayer(SeenPlayer);
        bAlreadyFoundEnemy = true;
        GoalString = "Hunt";
        GotoState('ZombieHunt');
    }

    function BeginState()
    {
        local float ZDif;

        ZombieBossOS(Pawn).SneakCount++;

        if( Pawn.CollisionRadius>27 || Pawn.CollisionHeight>46 )
        {
            ZDif = Pawn.CollisionHeight-44;
            Pawn.SetCollisionSize(24,44);
            Pawn.MoveSmooth(vect(0,0,-1)*ZDif);
        }

        super.BeginState();
    }
    function EndState()
    {
        local float ZDif;

        if( Pawn.CollisionRadius!=Pawn.default.CollisionRadius || Pawn.CollisionHeight!=Pawn.default.CollisionHeight )
        {
            ZDif = Pawn.default.CollisionRadius-44;
            Pawn.MoveSmooth(vect(0,0,1)*ZDif);
            Pawn.SetCollisionSize(Pawn.default.CollisionRadius,Pawn.default.CollisionHeight);
        }

        super.EndState();
    }
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

state RunSomewhere
{
Ignores HearNoise,DamageAttitudeTo,Tick,EnemyChanged,Startle;

    function BeginState()
    {
        HidingSpots = none;
        Enemy = none;
        SetTimer(0.1,true);
    }
    event SeePlayer(Pawn SeenPlayer)
    {
        SetEnemy(SeenPlayer);
    }
    function Timer()
    {
        if( Enemy==none )
            return;
        Target = Enemy;
        KFM.RangedAttack(Target);
    }
Begin:
    if( Pawn.Physics==PHYS_Falling )
        WaitForLanding();
    While( KFM.bShotAnim )
        Sleep(0.25);
    if( HidingSpots==none )
        HidingSpots = FindRandomDest();
    if( HidingSpots==none )
        ZombieBossOS(Pawn).BeginHealing();
    if( ActorReachable(HidingSpots) )
    {
        MoveTarget = HidingSpots;
        HidingSpots = none;
    }
    else FindBestPathToward(HidingSpots,true,false);
    if( MoveTarget==none )
        ZombieBossOS(Pawn).BeginHealing();
    if( Enemy!=none && VSize(Enemy.Location-Pawn.Location)<100 )
        MoveToward(MoveTarget,Enemy,,false);
    else MoveToward(MoveTarget,MoveTarget,,false);
    if( HidingSpots==none || !PlayerSeesMe() )
        ZombieBossOS(Pawn).BeginHealing();
    GoTo'Begin';
}
State SyrRetreat
{
Ignores HearNoise,DamageAttitudeTo,Tick,EnemyChanged,Startle;

    function BeginState()
    {
        HidingSpots = none;
        Enemy = none;
        SetTimer(0.1,true);
    }
    event SeePlayer(Pawn SeenPlayer)
    {
        SetEnemy(SeenPlayer);
    }
    function Timer()
    {
        if( Enemy==none )
            return;
        Target = Enemy;
        KFM.RangedAttack(Target);
    }
    function FindHideSpot()
    {
        local NavigationPoint N,BN;
        local float Dist,BDist,MDist;
        local vector EnemyDir;

        if( Enemy==none )
        {
            HidingSpots = FindRandomDest();
            return;
        }
        EnemyDir = Normal(Enemy.Location-Pawn.Location);
        For( N=Level.NavigationPointList; N!=none; N=N.NextNavigationPoint )
        {
            MDist = VSize(N.Location-Pawn.Location);
            if( MDist<2500 && !FastTrace(N.Location,Enemy.Location) && FindPathToward(N)!=none )
            {
                Dist = VSize(N.Location-Enemy.Location)/FMax(MDist/800.f,1.5);
                if( (EnemyDir Dot Normal(Enemy.Location-N.Location))<0.2 )
                    Dist/=10;
                if( BN==none || BDist<Dist )
                {
                    BN = N;
                    BDist = Dist;
                }
            }
        }
        if( BN==none )
            HidingSpots = FindRandomDest();
        else HidingSpots = BN;
    }
Begin:
    if( Pawn.Physics==PHYS_Falling )
        WaitForLanding();
    While( KFM.bShotAnim )
        Sleep(0.25);
    if( HidingSpots==none )
        FindHideSpot();
    if( HidingSpots==none )
        ZombieBossOS(Pawn).BeginHealing();
    if( ActorReachable(HidingSpots) )
    {
        MoveTarget = HidingSpots;
        HidingSpots = none;
    }
    else FindBestPathToward(HidingSpots,true,false);
    if( MoveTarget==none )
        ZombieBossOS(Pawn).BeginHealing();
    if( Enemy!=none && VSize(Enemy.Location-Pawn.Location)<100 )
        MoveToward(MoveTarget,Enemy,,false);
    else MoveToward(MoveTarget,MoveTarget,,false);
    if( HidingSpots==none )
        ZombieBossOS(Pawn).BeginHealing();
    GoTo'Begin';
}
function bool PlayerSeesMe()
{
    local Controller C;

    For( C=Level.ControllerList; C!=none; C=C.NextController )
    {
        if( C.bIsPlayer && C.Pawn!=none && C.Pawn!=Pawn && LineOfSightTo(C.Pawn) )
            return true;
    }
    return false;
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