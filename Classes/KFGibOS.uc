class KFGibOS extends GibOS;

simulated function PostBeginPlay()
{
   SpawnTrail();
}

simulated function HitWall( Vector HitNormal, Actor Wall )
{
    local float Speed, MinSpeed;

    Velocity = DampenFactor * ((Velocity dot HitNormal) * HitNormal*(-2.0) + Velocity);
    Speed = VSize(Velocity);

    RandSpin(100000);

    if (  Level.DetailMode == DM_Low )
    {
        MinSpeed = 250;
        LifeSpan = 8.0;
    }
    else
        MinSpeed = 150;

    if( (Level.NetMode != NM_DedicatedServer) && !Level.bDropDetail )
    {
        if ( GibGroupClass.default.BloodGibClass != none )
            Spawn( GibGroupClass.default.BloodGibClass,,, Location, Rotator(-HitNormal) );

        if ( (LifeSpan < 7.3)  && (Level.DetailMode != DM_Low) )
            PlaySound(HitSounds[Rand(2)]);
    }

    if( Speed < 20 )
    {
        if(!Level.bDropDetail && (Level.DetailMode != DM_Low) && GibGroupClass.default.BloodHitClass != none )
            Spawn( GibGroupClass.default.BloodHitClass,,, Location, Rotator(-HitNormal) );

        bBounce = false;
        SetPhysics(PHYS_None);
    }
}

defaultproperties
{
    LifeSpan=8.0
    DampenFactor=0.400000
    Mass=280.000000
}