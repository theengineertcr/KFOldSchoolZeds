class GorefastControllerOS extends KFMonsterControllerOS;

var    bool    bDoneSpottedCheck;

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
     StrafingAbility=0.500000
}