class KFGibOS extends KFGib;

#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFOldSchoolStatics.usx
#exec OBJ LOAD FILE=22Patch.usx
#exec OBJ LOAD FILE=22CharTex.utx
#exec OBJ LOAD FILE=KillingFloorTextures.utx

defaultproperties
{
    HitSounds(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Giblets1'
    HitSounds(1)=Sound'KFOldSchoolZeds_Sounds.Shared.Giblets2'
}