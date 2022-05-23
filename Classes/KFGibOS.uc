// Spawns Trail on PostBeginPlay.

class KFGibOS extends GibOS;

//All code from Retail
simulated function PostBeginPlay()
{
   SpawnTrail();
}

simulated function HitWall( Vector HitNormal, Actor Wall )
{
    local float Speed, MinSpeed;

    Velocity = DampenFactor * ((Velocity dot HitNormal) * HitNormal*(-2.0) + Velocity);
    RandSpin(100000);
    Speed = VSize(Velocity);
    if (  Level.DetailMode == DM_Low )
    {
        MinSpeed = 250;
        LifeSpan = 8.0;
    }
    else
        MinSpeed = 150;

    if( (Level.NetMode != NM_DedicatedServer) && !Level.bDropDetail )
    {
        if ( GibGroupClass.default.BloodGibClass != None )
            Spawn( GibGroupClass.default.BloodGibClass,,, Location, Rotator(-HitNormal) );
        if ( (LifeSpan < 7.3)  && (Level.DetailMode != DM_Low) )
            PlaySound(HitSounds[Rand(2)]);
    }

    if( Speed < 20 )
    {
        if(!Level.bDropDetail && (Level.DetailMode != DM_Low) && GibGroupClass.default.BloodHitClass != None )
            Spawn( GibGroupClass.default.BloodHitClass,,, Location, Rotator(-HitNormal) );
        bBounce = False;
        SetPhysics(PHYS_None);
    }
}

defaultproperties
{
     //As much as I loved KFMod's infinite gibs, we don't
     //Want to kill people's PCs, so were keeping 'em temporarily
     LifeSpan=8.0
     DampenFactor=0.400000
     Mass=280.000000
}