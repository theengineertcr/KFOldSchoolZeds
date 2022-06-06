//2.5 BossLAWProj ✓
class BossLAWProjOS extends BossLAWProj;

//Usage:
//Boss Projectile. Mainly to play KFMod ExplosionSound and make StaticMesh visible.
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KillingFloorStatics.usx

defaultproperties
{
     DrawScale=0.75
     StaticMesh=StaticMesh'KillingFloorStatics.LAWRocket'
     ExplosionSound=Sound'KFOldSchoolZeds_Sounds.Shared.TankFire01'
}