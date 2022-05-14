// Bouncy bombs for the GL!
class GunnerGLProjectile extends SPGrenadeProjectile;

#exec OBJ LOAD FILE=KF_IJC_Summer_Weps.usx
#exec OBJ LOAD FILE=ProjectileSounds.uax
#exec OBJ LOAD FILE=KF_GrenadeSnd.uax
#exec OBJ LOAD FILE=KF_IJC_HalloweenSnd.uax

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
    // Don't let it hit this player, or blow up on another player
    if ( Other == none || Other == Instigator || Other.Base == Instigator )
        return;

    // Don't collide with bullet whip attachments
    if( KFBulletWhipAttachment(Other) != none )
    {
        return;
    }

    // Don't allow hits on poeple on the same team
    if( KFMonster(Other) != none && Instigator != none )
    {
        return;
    }

    // Use the instigator's location if it exists. This fixes issues with
    // the original location of the projectile being really far away from
    // the real Origloc due to it taking a couple of milliseconds to
    // replicate the location to the client and the first replicated location has
    // already moved quite a bit.
    if( Instigator != none )
    {
        OrigLoc = Instigator.Location;
    }

    if( !bKillMomentum && ((VSizeSquared(Location - OrigLoc) < ArmDistSquared) || OrigLoc == vect(0,0,0)) )
    {
        if( Role == ROLE_Authority )
        {
            //AmbientSound=none;
            PlaySound(Sound'ProjectileSounds.PTRD_deflect04',,2.0);
            Other.TakeDamage( ImpactDamage, Instigator, HitLocation, Normal(Velocity), ImpactDamageType );
        }
        bKillMomentum = true;
        Velocity = vect(0,0,0);
    }

    if( !bKillMomentum )
    {
       Explode(HitLocation,Normal(HitLocation-Other.Location));
    }
}

defaultproperties
{
    ArmDistSquared=0 //Does not need to be armed//90000 // 6 meters
    Speed=1000
    MaxSpeed=1500
    Damage=75// No need to be that high //325
    DamageRadius=175// Halved radius //350
    MomentumTransfer=75000.000000
    MyDamageType=Class'KFMod.DamTypeSPGrenade'
    LifeSpan=10.000000
    ImpactDamage=25
    ExplodeTimer=3.5
    DampenFactor=0.5
    DampenFactorParallel=0.8
    bBounce=True
    TossZ=150    
    DrawScale=4.0
    
    //References are buggy, so screw 'em
    ImpactSound=Sound'KF_GrenadeSnd.Nade_HitSurf'
    AmbientSound=Sound'KF_IJC_HalloweenSnd.KF_FlarePistol_Projectile_Loop'
    //Place Holder Model until I get a visual reference on Quake 2 Grenades
    StaticMesh=StaticMesh'KF_IJC_Summer_Weps.SPGrenade_proj'
    ExplosionSound=Sound'KF_GrenadeSnd.Nade_Explode_1'
}
