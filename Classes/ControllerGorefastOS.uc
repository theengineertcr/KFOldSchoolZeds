//Controller class for Gorefast ✓
class ControllerGorefastOS extends KFMonsterControllerOS;

var    bool    bDoneSpottedCheck;

//Players that spot a Gorefast will have a 25% chance to call him out
state ZombieHunt
{
    event SeePlayer(Pawn SeenPlayer)
    {
        if ( !bDoneSpottedCheck && PlayerController(SeenPlayer.Controller) != none )
        {
            if ( !KFGameType(Level.Game).bDidSpottedGorefastMessage && FRand() < 0.25 )
            {
                PlayerController(SeenPlayer.Controller).Speech('AUTO', 13, "");
                KFGameType(Level.Game).bDidSpottedGorefastMessage = true;
            }

            bDoneSpottedCheck = true;
        }

        global.SeePlayer(SeenPlayer);
    }
}

defaultproperties
{
    //Makes him strafe left/right, same as KF1 Gorefast
    StrafingAbility=0.500000
}