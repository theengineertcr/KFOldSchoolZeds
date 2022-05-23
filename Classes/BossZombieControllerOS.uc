//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BossZombieControllerOS extends KFMonsterControllerOS;

var NavigationPoint HidingSpots;

//Dont touch these retail variables
var     float       WaitAnimTimeout;    // How long until the Anim we are waiting for is completed; Hack so the server doesn't get stuck in idle when its doing the Rage anim
var     int         AnimWaitChannel;    // The channel we are waiting to end in WaitForAnim
var     name        AnimWaitingFor;     // The animation we are waiting to end in WaitForAnim, mostly used for debugging
var     bool        bAlreadyFoundEnemy; // The Boss has already found an enemy at least once

//Retail function, don't touch
function bool CanKillMeYet()
{
    return false;
}

//This function hasn't changed since KFMod, were keeping it
function TimedFireWeaponAtEnemy()
{
    if ( (Enemy == None) || FireWeaponAt(Enemy) )
        SetCombatTimer();
    else
        SetTimer(0.01, True);
}

//Fix this
function rotator AdjustAim(FireProperties FiredAmmunition, vector projStart, int aimerror)
{
    local rotator FireRotation, TargetLook;
    local float FireDist, TargetDist, ProjSpeed;
    local actor HitActor;
    local vector FireSpot, FireDir, TargetVel, HitLocation, HitNormal;
    local int realYaw;
    local bool bDefendMelee, bClean, bLeadTargetNow;
    local bool bWantsToAimAtFeet;

    if ( FiredAmmunition.ProjectileClass != None )
        projspeed = FiredAmmunition.ProjectileClass.default.speed;

    // make sure bot has a valid target
    if ( Target == None )
    {
        Target = Enemy;
        if ( Target == None )
            return Rotation;
    }
    FireSpot = Target.Location;
    TargetDist = VSize(Target.Location - Pawn.Location);

    // perfect aim at stationary objects
    if ( Pawn(Target) == None )
    {
        if ( !FiredAmmunition.bTossed )
            return rotator(Target.Location - projstart);
        else
        {
            FireDir = AdjustToss(projspeed,ProjStart,Target.Location,true);
            SetRotation(Rotator(FireDir));
            return Rotation;
        }
    }

    bLeadTargetNow = FiredAmmunition.bLeadTarget && bLeadTarget;
    bDefendMelee = ( (Target == Enemy) && DefendMelee(TargetDist) );
    aimerror = AdjustAimError(aimerror,TargetDist,bDefendMelee,FiredAmmunition.bInstantHit, bLeadTargetNow);

    // lead target with non instant hit projectiles
    if ( bLeadTargetNow )
    {
        TargetVel = Target.Velocity;
        // hack guess at projecting falling velocity of target
        if ( Target.Physics == PHYS_Falling )
        {
            if ( Target.PhysicsVolume.Gravity.Z <= Target.PhysicsVolume.Default.Gravity.Z )
                TargetVel.Z = FMin(TargetVel.Z + FMax(-400, Target.PhysicsVolume.Gravity.Z * FMin(1,TargetDist/projSpeed)),0);
            else
                TargetVel.Z = FMin(0, TargetVel.Z);
        }
        // more or less lead target (with some random variation)
        FireSpot += FMin(1, 0.7 + 0.6 * FRand()) * TargetVel * TargetDist/projSpeed;
        FireSpot.Z = FMin(Target.Location.Z, FireSpot.Z);

        if ( (Target.Physics != PHYS_Falling) && (FRand() < 0.55) && (VSize(FireSpot - ProjStart) > 1000) )
        {
            // don't always lead far away targets, especially if they are moving sideways with respect to the bot
            TargetLook = Target.Rotation;
            if ( Target.Physics == PHYS_Walking )
                TargetLook.Pitch = 0;
            bClean = ( ((Vector(TargetLook) Dot Normal(Target.Velocity)) >= 0.71) && FastTrace(FireSpot, ProjStart) );
        }
        else // make sure that bot isn't leading into a wall
            bClean = FastTrace(FireSpot, ProjStart);
        if ( !bClean)
        {
            // reduce amount of leading
            if ( FRand() < 0.3 )
                FireSpot = Target.Location;
            else
                FireSpot = 0.5 * (FireSpot + Target.Location);
        }
    }

    bClean = false; //so will fail first check unless shooting at feet

    // Randomly determine if we should try and splash damage with the fire projectile
    if( FiredAmmunition.bTrySplash )
    {
        if( Skill < 2.0 )
        {
            if(FRand() > 0.85)
            {
                bWantsToAimAtFeet = true;
            }
        }
        else if( Skill < 3.0 )
        {
            if(FRand() > 0.5)
            {
                bWantsToAimAtFeet = true;
            }
        }
        else if( Skill >= 3.0 )
        {
            bWantsToAimAtFeet = true;
        }
    }

    if ( FiredAmmunition.bTrySplash && (Pawn(Target) != None) && (((Target.Physics == PHYS_Falling)
        && (Pawn.Location.Z + 80 >= Target.Location.Z)) || ((Pawn.Location.Z + 19 >= Target.Location.Z)
        && (bDefendMelee || bWantsToAimAtFeet))) )
    {
        HitActor = Trace(HitLocation, HitNormal, FireSpot - vect(0,0,1) * (Target.CollisionHeight + 10), FireSpot, false);

         bClean = (HitActor == None);
        if ( !bClean )
        {
            FireSpot = HitLocation + vect(0,0,3);
            bClean = FastTrace(FireSpot, ProjStart);
        }
        else
            bClean = ( (Target.Physics == PHYS_Falling) && FastTrace(FireSpot, ProjStart) );
    }

    if ( !bClean )
    {
        //try middle
        FireSpot.Z = Target.Location.Z;
         bClean = FastTrace(FireSpot, ProjStart);
    }
    if ( FiredAmmunition.bTossed && !bClean && bEnemyInfoValid )
    {
        FireSpot = LastSeenPos;
         HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
        if ( HitActor != None )
        {
            bCanFire = false;
            FireSpot += 2 * Target.CollisionHeight * HitNormal;
        }
        bClean = true;
    }

    if( !bClean )
    {
        // try head
         FireSpot.Z = Target.Location.Z + 0.9 * Target.CollisionHeight;
         bClean = FastTrace(FireSpot, ProjStart);
    }
    if ( !bClean && (Target == Enemy) && bEnemyInfoValid )
    {
        FireSpot = LastSeenPos;
        if ( Pawn.Location.Z >= LastSeenPos.Z )
            FireSpot.Z -= 0.4 * Enemy.CollisionHeight;
         HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
        if ( HitActor != None )
        {
            FireSpot = LastSeenPos + 2 * Enemy.CollisionHeight * HitNormal;
            if ( Monster(Pawn).SplashDamage() && (Skill >= 4) )
            {
                 HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
                if ( HitActor != None )
                    FireSpot += 2 * Enemy.CollisionHeight * HitNormal;
            }
            bCanFire = false;
        }
    }

    // adjust for toss distance
    if ( FiredAmmunition.bTossed )
        FireDir = AdjustToss(projspeed,ProjStart,FireSpot,true);
    else
        FireDir = FireSpot - ProjStart;

    FireRotation = Rotator(FireDir);
    realYaw = FireRotation.Yaw;
    InstantWarnTarget(Target,FiredAmmunition,vector(FireRotation));

    FireRotation.Yaw = SetFireYaw(FireRotation.Yaw + aimerror);
    FireDir = vector(FireRotation);
    // avoid shooting into wall
    FireDist = FMin(VSize(FireSpot-ProjStart), 400);
    FireSpot = ProjStart + FireDist * FireDir;
    HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
    if ( HitActor != None )
    {
        if ( HitNormal.Z < 0.7 )
        {
            FireRotation.Yaw = SetFireYaw(realYaw - aimerror);
            FireDir = vector(FireRotation);
            FireSpot = ProjStart + FireDist * FireDir;
            HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
        }
        if ( HitActor != None )
        {
            FireSpot += HitNormal * 2 * Target.CollisionHeight;
            if ( Skill >= 4 )
            {
                HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
                if ( HitActor != None )
                    FireSpot += Target.CollisionHeight * HitNormal;
            }
            FireDir = Normal(FireSpot - ProjStart);
            FireRotation = rotator(FireDir);
        }
    }

    SetRotation(FireRotation);
    return FireRotation;
}

//Retail function we need
// Overridden to support a quick initial attack to get the boss to the players quickly
function FightEnemy(bool bCanCharge)
{
    if( KFM.bShotAnim )
    {
        GoToState('WaitForAnim');
        Return;
    }
    if (KFM.MeleeRange != KFM.default.MeleeRange)
        KFM.MeleeRange = KFM.default.MeleeRange;

    if ( Enemy == none || Enemy.Health <= 0 )
        FindNewEnemy();

    if ( (Enemy == FailedHuntEnemy) && (Level.TimeSeconds == FailedHuntTime) )
    {
    //    if ( Enemy.Controller.bIsPlayer )
        //    FindNewEnemy();

        if ( Enemy == FailedHuntEnemy )
        {
                        GoalString = "FAILED HUNT - HANG OUT";
            if ( EnemyVisible() )
                bCanCharge = false;
        }
    }
    if ( !EnemyVisible() )
    {
        //ZombieBoss to ZombieBossOS
        // Added sneakcount hack to try and fix the endless loop crash. Try and track down what was causing this later - Ramm
        if( bAlreadyFoundEnemy || ZombieBossOS(Pawn).SneakCount > 2 )
        {
            bAlreadyFoundEnemy = true;
            GoalString = "Hunt";
            GotoState('ZombieHunt');
        }
        else
        {
            //ZombieBoss to ZombieBossOS
            // Added sneakcount hack to try and fix the endless loop crash. Try and track down what was causing this later - Ramm
            ZombieBossOS(Pawn).SneakCount++;
            GoalString = "InitialHunt";
            GotoState('InitialHunting');
        }
        return;
    }

    // see enemy - decide whether to charge it or strafe around/stand and fire
    Target = Enemy;
    GoalString = "Charge";
    PathFindState = 2;
    DoCharge();
}


//Retail code we dont want to touch
// Get the boss to the players quickly after initial spawn
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

        //ZombieBoss to ZombieBossOS
        // Added sneakcount hack to try and fix the endless loop crash. Try and track down what was causing this later - Ramm
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

        if( Pawn.CollisionRadius!=Pawn.Default.CollisionRadius || Pawn.CollisionHeight!=Pawn.Default.CollisionHeight )
        {
            ZDif = Pawn.Default.CollisionRadius-44;
            Pawn.MoveSmooth(vect(0,0,1)*ZDif);
            Pawn.SetCollisionSize(Pawn.Default.CollisionRadius,Pawn.Default.CollisionHeight);
        }

        super.EndState();
    }
}

//Same as in KFMod
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

state RunSomewhere
{
Ignores HearNoise,DamageAttitudeTo,Tick,EnemyChanged,Startle; //Startle is new, but we dont care

    function BeginState()
    {
        HidingSpots = None;
        Enemy = None;
        SetTimer(0.1,True);
    }
    event SeePlayer(Pawn SeenPlayer)
    {
        SetEnemy(SeenPlayer);
    }
    function Timer()
    {
        if( Enemy==None )
            Return;
        Target = Enemy;
        KFM.RangedAttack(Target);
    }
Begin:
    if( Pawn.Physics==PHYS_Falling )
        WaitForLanding();
    While( KFM.bShotAnim )
        Sleep(0.25);
    if( HidingSpots==None )
        HidingSpots = FindRandomDest();
    if( HidingSpots==None )
        ZombieBossOS(Pawn).BeginHealing(); //ZombieBoss to ZombieBossOS
    if( ActorReachable(HidingSpots) )
    {
        MoveTarget = HidingSpots;
        HidingSpots = None;
    }
    else FindBestPathToward(HidingSpots,True,False);
    if( MoveTarget==None )
        ZombieBossOS(Pawn).BeginHealing(); //ZombieBoss to ZombieBossOS
    if( Enemy!=None && VSize(Enemy.Location-Pawn.Location)<100 )
        MoveToward(MoveTarget,Enemy,,False);
    else MoveToward(MoveTarget,MoveTarget,,False);
    if( HidingSpots==None || !PlayerSeesMe() )
        ZombieBossOS(Pawn).BeginHealing(); //ZombieBoss to ZombieBossOS
    GoTo'Begin';
}
State SyrRetreat
{
Ignores HearNoise,DamageAttitudeTo,Tick,EnemyChanged,Startle;

    function BeginState()
    {
        HidingSpots = None;
        Enemy = None;
        SetTimer(0.1,True);
    }
    event SeePlayer(Pawn SeenPlayer)
    {
        SetEnemy(SeenPlayer);
    }
    function Timer()
    {
        if( Enemy==None )
            Return;
        Target = Enemy;
        KFM.RangedAttack(Target);
    }
    function FindHideSpot()
    {
        local NavigationPoint N,BN;
        local float Dist,BDist,MDist;
        local vector EnemyDir;

        if( Enemy==None )
        {
            HidingSpots = FindRandomDest();
            Return;
        }
        EnemyDir = Normal(Enemy.Location-Pawn.Location);
        For( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
        {
            MDist = VSize(N.Location-Pawn.Location);
            if( MDist<2500 && !FastTrace(N.Location,Enemy.Location) && FindPathToward(N)!=None )
            {
                Dist = VSize(N.Location-Enemy.Location)/FMax(MDist/800.f,1.5);
                if( (EnemyDir Dot Normal(Enemy.Location-N.Location))<0.2 )
                    Dist/=10;
                if( BN==None || BDist<Dist )
                {
                    BN = N;
                    BDist = Dist;
                }
            }
        }
        if( BN==None )
            HidingSpots = FindRandomDest();
        else HidingSpots = BN;
    }
Begin:
    if( Pawn.Physics==PHYS_Falling )
        WaitForLanding();
    While( KFM.bShotAnim )
        Sleep(0.25);
    if( HidingSpots==None )
        FindHideSpot();
    if( HidingSpots==None )
        ZombieBossOS(Pawn).BeginHealing(); //ZombieBoss to ZombieBossOS
    if( ActorReachable(HidingSpots) )
    {
        MoveTarget = HidingSpots;
        HidingSpots = None;
    }
    else FindBestPathToward(HidingSpots,True,False);
    if( MoveTarget==None )
        ZombieBossOS(Pawn).BeginHealing(); //ZombieBoss to ZombieBossOS
    if( Enemy!=None && VSize(Enemy.Location-Pawn.Location)<100 )
        MoveToward(MoveTarget,Enemy,,False);
    else MoveToward(MoveTarget,MoveTarget,,False);
    if( HidingSpots==None )
        ZombieBossOS(Pawn).BeginHealing(); //ZombieBoss to ZombieBossOS
    GoTo'Begin';
}
function bool PlayerSeesMe()
{
    local Controller C;

    For( C=Level.ControllerList; C!=None; C=C.NextController )
    {
        if( C.bIsPlayer && C.Pawn!=None && C.Pawn!=Pawn && LineOfSightTo(C.Pawn) )
            Return True;
    }
    Return False;
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

defaultproperties{}