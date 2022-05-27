class BossLAWProjOS extends BossLAWProj;

#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KillingFloorStatics.usx

/*
TODO: Make this a toggle in mutator
simulated function PostBeginPlay()
{
    if (Level.Game != none)
    {
        if( Level.Game.NumPlayers == 1 )
        {
            if( Level.Game.GameDifficulty < 2.0 )
            {
                Damage = default.Damage * 0.375;
                DamageRadius = default.DamageRadius * 0.55;
                Speed = default.Speed * 0.55;
            }
            else if( Level.Game.GameDifficulty < 4.0 )
            {
                Damage = default.Damage * 0.5;
                DamageRadius = default.DamageRadius * 0.75;
                Speed = default.Speed * 0.75;
            }
            else if( Level.Game.GameDifficulty < 5.0 )
            {
                Damage = default.Damage * 1.3;
                DamageRadius = default.DamageRadius * 1.15;
                Speed = default.Speed * 1.10;
            }
            else
            {
                Damage = default.Damage * 1.5;
                DamageRadius = default.DamageRadius * 1.3;
                Speed = default.Speed * 1.5;
            }
        }
        else
        {
            if( Level.Game.GameDifficulty < 2.0 )
            {
                Damage = default.Damage * 0.5;
                DamageRadius = default.DamageRadius * 0.75;
                Speed = default.Speed * 0.75;
            }
            else if( Level.Game.GameDifficulty < 4.0 )
            {
                Damage = default.Damage * 1.0;
                DamageRadius = default.DamageRadius * 1.0;
                Speed = default.Speed * 1.0;
            }
            else if( Level.Game.GameDifficulty < 5.0 )
            {
                Damage = default.Damage * 1.5;
                DamageRadius = default.DamageRadius * 1.25;
                Speed = default.Speed * 1.25;
            }
            else // Hardest difficulty
            {
                Damage = default.Damage * 2.0;
                DamageRadius = default.DamageRadius * 1.30;
                Speed = default.Speed * 1.5;
            }
        }
    }

    super.PostBeginPlay();
}
*/

defaultproperties
{
     DrawScale=1.0
     StaticMesh=StaticMesh'KillingFloorStatics.LAWRocket'
     ExplosionSound=Sound'KFOldSchoolZeds_Sounds.Shared.TankFire01'
}