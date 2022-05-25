class GibOS extends Gib
    abstract;

#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFOldSchoolStatics.usx
#exec OBJ LOAD FILE=22Patch.usx
#exec OBJ LOAD FILE=22CharTex.utx
#exec OBJ LOAD FILE=KillingFloorTextures.utx
    
var() class<xEmitter> TrailClass;
var() xEmitter Trail;


simulated function Destroyed()
{
    if( Trail != none )
        Trail.mRegen = false;

    super.Destroyed();
}

//Super above or below if statement?
simulated function SpawnTrail()
{
    super.SpawnTrail();   
        
    if ( Level.NetMode != NM_DedicatedServer && bFlaming )
    {
        Trail = Spawn(class'HitFlameBig', self,,Location,Rotation);
    } 
}

defaultproperties
{
     HitSounds(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Giblets1'
     HitSounds(1)=Sound'KFOldSchoolZeds_Sounds.Shared.Giblets2'
}