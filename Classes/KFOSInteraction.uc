class KFOSInteraction extends Interaction;

var KF25OSMut Mut;

event NotifyLevelChange()
{
    mut = none;
    Master.RemoveInteraction(self);
}


simulated function PostRender(Canvas C)
{
    local HUDKillingFloor KFH;
    local KFHumanPawn p;
    // local KFMonsterOS KFM;
    local DebugHeadHitbox DHB;
    // local coords CO;
    // local vector HeadLoc;

    KFH = HUDKillingFloor(viewportOwner.actor.myHUD);
    KFH.ClearStayingDebugLines();

    if (!Mut.bShowHeadHitbox)
        return;

    p = getPawn();

    if (p == none || KFH == none)
        return;

    // Head hit-boxes
    foreach p.DynamicActors(class'DebugHeadHitbox', DHB)
    {
        KFH.DrawStayingDebugSphere(DHB.HeadLocation, DHB.headScale, 10, 255, 0, 0);
    }

    // foreach p.DynamicActors(class'KFMonsterOS', KFM)
    // {
    //     if (KFM == none || KFM.health <= 0 || KFM.bDecapitated) // && KFM.ServerHeadLocation != KFM.LastServerHeadLocation )
    //         continue;
    //     //KFM.DrawDebugSphere(KFM.Location + (KFM.OnlineHeadshotOffset >> KFM.Rotation), KFM.HeadRadius * KFM.HeadScale * KFM.OnlineHeadshotScale, 10, 0, 255, 0);
    //     // KFM.LastServerHeadLocation = KFM.ServerHeadLocation;
    //     // DrawStayingDebugSphere(KFM.ServerHeadLocation, KFM.HeadRadius * KFM.HeadScale, 10, 128, 255, 255);
    //     CO = KFM.GetBoneCoords(KFM.HeadBone);
    //     HeadLoc = CO.Origin + (KFM.HeadHeight * KFM.HeadScale * CO.XAxis);
    //     KFH.DrawStayingDebugSphere(HeadLoc, KFM.HeadRadius * KFM.HeadScale, 10, 0, 255, 0);
    // }
}

final private function KFHumanPawn getPawn()
{
    if (viewportOwner.actor == none)
        return none;
    return KFHumanPawn(KFPlayerController(viewportOwner.actor).pawn);
}


defaultproperties
{
    bVisible=True
}