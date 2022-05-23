//-----------------------------------------------------------
////TODO: KFMod-ify this
//-----------------------------------------------------------
class BileJetOS extends Actor;

//Not in KFMod
//var() rotator BileRotation;

function PostBeginPlay()
{
    //KFMod increased timer
    settimer(0.5, true);//settimer(0.1, false);
}

//Overhauled with KFMod Code
simulated function timer()
{
    local vector X,Y,Z, FireStart;
    local rotator FireRotation;

    GetAxes(Rotation,X,Y,Z);
    FireStart = location;
    FireRotation = rotation;

    //Use KFMod classes
    Spawn(class'KFVomitJetOS',,,FireStart, FireRotation);
    Spawn(Class'KFBloatVomitOS',,,FireStart,FireRotation);

    FireStart = FireStart - 1.8 * CollisionRadius * Y;
    FireRotation.Yaw += 400;
    spawn(Class'KFBloatVomitOS',,,FireStart, FireRotation);

    FireStart = FireStart - 1.8 * CollisionRadius * Z;
    FireRotation.Pitch += 400;
    spawn(Class'KFBloatVomitOS',,,FireStart, FireRotation);

    FireStart = FireStart - 1.8 * CollisionRadius * X;
    FireRotation.Roll += 400;
    spawn(Class'KFBloatVomitOS',,,FireStart, FireRotation);
}

defaultproperties
{
     bHidden=True
     LifeSpan=2.500000
     //Not in KFMod
     //BileRotation=(Pitch=2000,Yaw=65535,Roll=0)
}