//TODO: Modify DoorBash to use Old Code?
class KFMonsterControllerOS extends KFMonsterController;

//Moantime differs in KFMod
function PostBeginPlay()
{
    Super.PostBeginPlay();
    MoanTime = Level.TimeSeconds; //Level.TimeSeconds + 2 + (36*FRand());
}

//Moantime differs in KFMod
function tick(float DeltaTime)
{
    if( Level.TimeSeconds >= MoanTime )
    {
        ZombieMoan();
        MoanTime += (12 + (fRand() * 3)); //Level.TimeSeconds + 12 + (FRand()*8);
    }
    if( bAboutToGetDoor )
    {
        bAboutToGetDoor = False;
        if( TargetDoor!=None )
        {
            BreakUpDoor(TargetDoor, true);
        }
    }
}

defaultproperties{}