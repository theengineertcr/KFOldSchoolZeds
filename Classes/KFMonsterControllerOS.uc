class KFMonsterControllerOS extends KFMonsterController;

function PostBeginPlay()
{
    super.PostBeginPlay();
    MoanTime = Level.TimeSeconds; //Level.TimeSeconds + 2 + (36*FRand());
}

function tick(float DeltaTime)
{
    if( Level.TimeSeconds >= MoanTime )
    {
        ZombieMoan();
        MoanTime += (12 + (fRand() * 3)); //Level.TimeSeconds + 12 + (FRand()*8);
    }

    if( bAboutToGetDoor )
    {
        bAboutToGetDoor = false;

        if( TargetDoor!=none )
            BreakUpDoor(TargetDoor, true);
    }
}

defaultproperties{}