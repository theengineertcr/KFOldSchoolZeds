// Extends to gib
class KFGibOS extends Gib;

//Load packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFOldSchoolStatics.usx
#exec OBJ LOAD FILE=22Patch.usx
#exec OBJ LOAD FILE=22CharTex.utx
#exec OBJ LOAD FILE=KillingFloorTextures.utx

simulated function PostBeginPlay()
{
    SpawnTrail();
}

simulated function HitWall( Vector HitNormal, Actor Wall )
{
    //Use KFGib hitwall instead of redefining it here for efficiency
    //KFGib does not use Gib Hitwall so we don't care about Gib
    super(KFGib).Hitwall(HitNormal, Wall);
}

defaultproperties
{
    GibGroupClass=Class'xPawnGibGroup'
    LifeSpan=8.0
    DampenFactor=0.400000
    Mass=280.000000
    //Hitsounds here
    HitSounds(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Giblets1'
    HitSounds(1)=Sound'KFOldSchoolZeds_Sounds.Shared.Giblets2'
}