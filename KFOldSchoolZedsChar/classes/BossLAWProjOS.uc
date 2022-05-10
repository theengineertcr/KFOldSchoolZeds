//We just want it to play the old explosion sound,
//Don't tweak anything else
class BossLAWProjOS extends BossLAWProj;

//-----------------------------------------------------------------------------
// PostBeginPlay
//-----------------------------------------------------------------------------

//Load the sound package
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax


defaultproperties
{
	 ExplosionSound=Sound'KFOldSchoolZeds_Sounds.Shared.TankFire01'
}
