//Need this for xEmitter so gibs spray blood trails
//Were in hot water going this far up, avoid touching anything!
class GibOS extends Gib
    abstract;

//Variables being Obscured, but as long as it works...
//We won't tweak the names of these unless necessary
var() class<xEmitter> TrailClass;
var() xEmitter Trail;
////These ones we don't care about
//var class<xPawnGibGroup> GibGroupClass;
//var() float DampenFactor;
//var Sound    HitSounds[2];
//var bool bFlaming;

//Load the sound package
    #exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax

simulated function Destroyed()
{
    if( Trail != none )
        Trail.mRegen = false;

    super.Destroyed();
}

//Can't override final functions, their definition don't differ so don't touch it
//simulated final function RandSpin(float spinRate)
//{
//    DesiredRotation = RotRand();
//    RotationRate.Yaw = spinRate * 2 *FRand() - spinRate;
//    RotationRate.Pitch = spinRate * 2 *FRand() - spinRate;
//    RotationRate.Roll = spinRate * 2 *FRand() - spinRate;
//}

simulated function Landed( Vector HitNormal )
{
    HitWall( HitNormal, none );
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
             if ( GibGroupClass.default.BloodHitClass != none )
                Spawn( GibGroupClass.default.BloodHitClass,,, Location, Rotator(-HitNormal) );
            if ( (LifeSpan < 7.3)  && (Level.DetailMode != DM_Low) )
                PlaySound(HitSounds[Rand(2)]);
        }
    }

    if( Speed < 20 )
    {
         if( !bFlaming && !Level.bDropDetail && (Level.DetailMode != DM_Low) && GibGroupClass.default.BloodHitClass != none )
            Spawn( GibGroupClass.default.BloodHitClass,,, Location, Rotator(-HitNormal) );
        bBounce = false;
        SetPhysics(PHYS_None);
    }
}

simulated function SpawnTrail()
{
    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( bFlaming )
        {
            Trail = Spawn(class'HitFlameBig', self,,Location,Rotation);
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
     //No XEffects class, just get xPawnGibGroup from wherever it currently is
     GibGroupClass=class'xPawnGibGroup'
     DampenFactor=0.650000
     //Retail KF doesn't use proper gib landing SFX, so we set them here
     HitSounds(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Giblets1'
     HitSounds(1)=Sound'KFOldSchoolZeds_Sounds.Shared.Giblets2'
     Physics=PHYS_Falling
     RemoteRole=ROLE_None
     LifeSpan=8.000000
     bUnlit=true
     TransientSoundVolume=0.170000
     bCollideWorld=true
     bUseCylinderCollision=true
     bBounce=true
     bFixedRotationDir=true
     Mass=30.000000
}