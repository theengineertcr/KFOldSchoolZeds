// 2.5 Gib Class ✓
class KFGibOS extends KFGib;

#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFOldSchoolStatics.usx
#exec OBJ LOAD FILE=22Patch.usx
#exec OBJ LOAD FILE=22CharTex.utx
#exec OBJ LOAD FILE=KillingFloorTextures.utx

var() class<XEmitter> TrailClassOS;
var() XEmitter TrailOS;

//Override to use OS Trails which are XEmitters
simulated function SpawnTrail()
{
    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( bFlaming )
        {
            TrailOS = Spawn(class'HitFlameBig', self,,Location,Rotation);
            TrailOS.LifeSpan = 4 + 2*FRand();
            LifeSpan = TrailOS.LifeSpan;
            TrailOS.SetTimer(LifeSpan - 3.0,false);
        }
        else
        {
            TrailOS = Spawn(TrailClassOS, self,, Location, Rotation);
            TrailOS.LifeSpan = 1.8;
        }
        TrailOS.SetPhysics( PHYS_Trailer );
        RandSpin( 64000 );
    }
}

simulated function Destroyed()
{
    if( TrailOS != none )
        TrailOS.mRegen = false;

    Super.Destroyed();
}

defaultproperties
{
    HitSounds(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Giblets1'
    HitSounds(1)=Sound'KFOldSchoolZeds_Sounds.Shared.Giblets2'
}