// KFs very own higher-res Bloodstains

class KFBloodStreakDecalOS extends KFBloodSplatterDecalOS;

// Load KFOldSchoolZeds_Textures
#exec OBJ LOAD File=KFOldSchoolZeds_Textures.utx

simulated function PostBeginPlay()
{
    /*
    local Vector RX, RY, RZ;
    local Rotator R;

    if ( PhysicsVolume.bNoDecals )
    {
        Destroy();
        return;
    }
    if( RandomOrient )
    {
        R.Yaw = 0;
        R.Pitch = 0;
        R.Roll = 0;
       // R.Roll = Rand(65535);
       // GetAxes(R,RX,RY,RZ);
       // RX = RX >> Rotation;
       // RY = RY >> Rotation;
       // RZ = RZ >> Rotation;
       // R = OrthoRotation(RX,RY,RZ);

        SetRotation(R);
    }
    SetLocation( Location - Vector(Rotation)*PushBack );

    Lifespan = FMax(0.5, LifeSpan + (Rand(4) - 2));

    if ( Level.bDropDetail )
        LifeSpan *= 0.5;
    AbandonProjector(LifeSpan*Level.DecalStayScale);
    Destroy();
    */

    ProjTexture = splats[Rand(3)];
    FOV = 1;
    SetDrawScale((Rand(2)-0.6));

    super.PostBeginPlay();
}

defaultproperties
{
    // KFX to KFOldSchoolZeds_Textures
     Splats(0)=Texture'KFOldSchoolZeds_Textures.BloodStreak'
     Splats(1)=Texture'KFOldSchoolZeds_Textures.BloodStreak'
     Splats(2)=Texture'KFOldSchoolZeds_Textures.BloodStreak'
     PushBack=5.000000
     RandomOrient=false
     ProjTexture=Texture'KFOldSchoolZeds_Textures.BloodStreak'
     LifeSpan=10.000000
}