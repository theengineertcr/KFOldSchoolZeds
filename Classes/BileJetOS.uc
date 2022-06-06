//2.5 BileJet ✓
class BileJetOS extends Actor;

//Usage:
//Bile that flies out of a Bloat's stomach when he explodes
function PostBeginPlay()
{
    settimer(0.5, true);//settimer(0.1, false);
}

simulated function timer()
{
    local vector X,Y,Z, FireStart;
    local rotator FireRotation;

    GetAxes(Rotation,X,Y,Z);

    FireStart = location;
    FireRotation = rotation;

    Spawn(class'KFVomitJetOS',,,FireStart, FireRotation);
    Spawn(class'KFBloatVomitOS',,,FireStart,FireRotation);

    FireStart = FireStart - 1.8 * CollisionRadius * Y;
    FireRotation.Yaw += 400;
    spawn(class'KFBloatVomitOS',,,FireStart, FireRotation);

    FireStart = FireStart - 1.8 * CollisionRadius * Z;
    FireRotation.Pitch += 400;
    spawn(class'KFBloatVomitOS',,,FireStart, FireRotation);

    FireStart = FireStart - 1.8 * CollisionRadius * X;
    FireRotation.Roll += 400;
    spawn(class'KFBloatVomitOS',,,FireStart, FireRotation);
}

defaultproperties
{
    bHidden=true
    LifeSpan=2.500000
}