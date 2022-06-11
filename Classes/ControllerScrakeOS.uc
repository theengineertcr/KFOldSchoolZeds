// Controller Class for Scrake ✓
class ControllerScrakeOS extends KFMonsterControllerOS;

var    bool    bDoneSpottedCheck;

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

defaultproperties{}