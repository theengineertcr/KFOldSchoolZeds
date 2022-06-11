// Controller class for Siren
class ControllerSirenOS extends KFMonsterControllerOS;

var        bool        bDoneSpottedCheck;

state ZombieHunt
{
    event SeePlayer(Pawn SeenPlayer)
    {
        if ( !bDoneSpottedCheck && PlayerController(SeenPlayer.Controller) != none )
        {
            if ( !KFGameType(Level.Game).bDidSpottedSirenMessage && FRand() < 0.25 )
            {
                PlayerController(SeenPlayer.Controller).Speech('AUTO', 15, "");
                KFGameType(Level.Game).bDidSpottedSirenMessage = true;
            }

            bDoneSpottedCheck = true;
        }

        super.SeePlayer(SeenPlayer);
    }
}