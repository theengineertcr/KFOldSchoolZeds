// Code is... borrowed from SkellTestMap's mutator
class DebugHeadHitbox extends Actor;

var KFMonsterOS Zed;
var Vector HeadLocation;
var float headScale;

replication
{
    reliable if (Role == ROLE_Authority)
        HeadLocation, headScale;
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority && Owner != none)
    {
        SetLocation(Owner.Location);
        SetPhysics(PHYS_None);
        SetBase(Owner);
        Zed = KFMonsterOS(Owner);
    }
}

simulated event Tick(float deltaTime)
{
    local Coords C;
    local bool bAltHeadLoc;

    if (Zed == none || Zed.bDecapitated || Zed.HeadBone == '' || Zed.health <= 0)
    {
        Destroy();
        return;
    }

    // Server hit-boxes
    if (Role == ROLE_Authority)
    {
        if (Level.NetMode == NM_DedicatedServer && Zed.Physics == PHYS_Walking && !Zed.IsAnimating(0) && !Zed.IsAnimating(1) && !Zed.bIsCrouched)
            bAltHeadLoc = true;

        headScale = Zed.headRadius * Zed.headScale;
        if (bAltHeadLoc)
        {
            HeadLocation = Zed.Location + (Zed.OnlineHeadshotOffset >> Zed.Rotation);
            if (Level.NetMode == NM_DedicatedServer)
                headScale *= Zed.onlineHeadshotScale;
        }
        else
        {
            C = Zed.GetBoneCoords(Zed.HeadBone);
            HeadLocation = C.Origin + (Zed.headHeight * Zed.headScale * C.XAxis);
        }
    }
}

defaultproperties
{
    bHidden=true
    bSkipActorPropertyReplication=true
    RemoteRole=ROLE_SimulatedProxy
    NetPriority=2.000000
}