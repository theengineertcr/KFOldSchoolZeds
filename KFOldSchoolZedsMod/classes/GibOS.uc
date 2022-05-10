class Gib extends Actor
    abstract;

var class<xPawnGibGroup> GibGroupClass;
var() class<Emitter> TrailClass;
var() Emitter Trail;
var() float DampenFactor;
var Sound	HitSounds[2];
var bool bFlaming;

simulated function Destroyed()
{
    if( Trail != none )
        Trail.Kill();

	Super.Destroyed();
}

simulated final function RandSpin(float spinRate)
{
	DesiredRotation = RotRand();
	RotationRate.Yaw = spinRate * 2 *FRand() - spinRate;
	RotationRate.Pitch = spinRate * 2 *FRand() - spinRate;
	RotationRate.Roll = spinRate * 2 *FRand() - spinRate;
}

simulated function Landed( Vector HitNormal )
{
    HitWall( HitNormal, None );
}

simulated function HitWall( Vector HitNormal, Actor Wall )
{
    local float Speed, MinSpeed;

    Velocity = DampenFactor * ((Velocity dot HitNormal) * HitNormal*(-2.0) + Velocity);
    RandSpin(100000);
    Speed = VSize(Velocity);
	if (  Level.DetailMode == DM_Low )
    	MinSpeed = 250;
	else
		MinSpeed = 150;
	if( !bFlaming && (Speed > MinSpeed) )
    {
 		if( (Level.NetMode != NM_DedicatedServer) && !Level.bDropDetail )
 		{
 			if ( GibGroupClass.default.BloodHitClass != None )
				Spawn( GibGroupClass.default.BloodHitClass,,, Location, Rotator(-HitNormal) );
			if ( (LifeSpan < 7.3)  && (Level.DetailMode != DM_Low) )
				PlaySound(HitSounds[Rand(2)]);
		}
    }

    if( Speed < 20 )
    {
 		if( !bFlaming && !Level.bDropDetail && (Level.DetailMode != DM_Low) && GibGroupClass.default.BloodHitClass != None )
			Spawn( GibGroupClass.default.BloodHitClass,,, Location, Rotator(-HitNormal) );
        bBounce = False;
        SetPhysics(PHYS_None);
    }
}

simulated function SpawnTrail()
{
    if ( Level.NetMode != NM_DedicatedServer )
    {
		if ( bFlaming )
		{
			Trail = Spawn(class'ROEffects.FireTrail', self,,Location,Rotation);
			Trail.LifeSpan = 4 + 2*FRand();
			LifeSpan = Trail.LifeSpan;
			Trail.SetTimer(LifeSpan - 3.0,false);
		}
		else
		{
			Trail = Spawn(TrailClass, self,, Location, Rotation);
			Trail.LifeSpan = 1.8;
		}
		Trail.SetPhysics( PHYS_Trailer );
		RandSpin( 64000 );
	}
}

defaultproperties
{
	bUnlit=true
	TransientSoundVolume=+0.17
	GibGroupClass=class'xPawnGibGroup'
	LifeSpan=8.0
    bCollideWorld=true
    bCollideActors=false

    RemoteRole=ROLE_None

    Physics=PHYS_Falling
    bBounce=True
    bFixedRotationDir=True

    DampenFactor=0.65
    Mass=30
    bUseCylinderCollision=true

    HitSounds(0)=sound'Inf_Player.BodyImpact'
}

