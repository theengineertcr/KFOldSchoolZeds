// Bouncy bombs for the GL!
class GunnerGLProjectile extends SPGrenadeProjectile;

#exec OBJ LOAD FILE=KFOldSchoolStatics.usx
#exec OBJ LOAD FILE=ProjectileSounds.uax
#exec OBJ LOAD FILE=KF_GrenadeSnd.uax
#exec OBJ LOAD FILE=KF_IJC_HalloweenSnd.uax

var float LastSeenOrRelevantTime;

//Don't disintegrate
simulated function Disintegrate(vector HitLocation, vector HitNormal)
{
}

//PostBeginPlay
simulated function PostBeginPlay()
{
    local vector Dir;

    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( !PhysicsVolume.bWaterVolume )
        {
            SmokeTrail = Spawn(SmokeTrailEmitterClass,self);
        }
    }

    // Difficulty Scaling
    if (Level.Game != none)
    {
        if( Level.Game.GameDifficulty < 2.0 )
        {
            Damage = default.Damage * 0.5;
        }
        else if( Level.Game.GameDifficulty < 4.0 )
        {
            Damage = default.Damage * 1.0;
        }
        else if( Level.Game.GameDifficulty < 5.0 )
        {
            Damage = default.Damage * 1.33;
        }
        else // Hardest difficulty
        {
            Damage = default.Damage * 1.66;
        }
    }

    OrigLoc = Location;

    if( !bKillMomentum )
    {
        Dir = vector(Rotation);
        Velocity = Speed * Dir;
        Velocity.Z += TossZ;
    }

    if (PhysicsVolume.bWaterVolume)
    {
        Velocity=0.6*Velocity;
    }
    super(Projectile).PostBeginPlay();

    SetTimer(ExplodeTimer, false);
}

//Don't explode when you've taken damage
function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
}

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

//TODO: Make grenades stop moving after it reaches 1.5 seconds until it explodes?
//Aftermath: After wasting a lot of time trying to figure this out, we'll just lower dampen factor

defaultproperties
{
    ArmDistSquared=0 //Does not need to be armed //90000 // 6 meters
    Speed=1//1500
    MaxSpeed=10000//In the future, we'll make his projectiles speed up when he's far away, so keep it high
    Damage=75 //Decreased to use difficulty for adjusting damage
    DamageRadius=350// Balance - Slightly reduced
    MomentumTransfer=75000.000000
    MyDamageType=Class'KFMod.DamTypeFrag' //Use Frag Damtype so Demos resist
    LifeSpan=10.000000
    //Doesn't impact enemies
    ImpactDamage=0
    //Decreased
    ExplodeTimer=2.0
    //lowered further
    DampenFactor=0.4// 0.4 //0.5
    DampenFactorParallel=0.3// 0.6 //0.8
    bBounce=True
    TossZ=150
    DrawScale=4.0

    //References are buggy, so screw 'em
    ImpactSound=Sound'KF_GrenadeSnd.Nade_HitSurf'
    AmbientSound=Sound'KF_IJC_HalloweenSnd.KF_FlarePistol_Projectile_Loop'

    //Place Holder Model until I get a visual reference on Quake 2 Grenades
    //We went with Quake style nades instead
    StaticMesh=StaticMesh'KFOldSchoolStatics.GunPoundProj'
    ExplosionSound=Sound'KF_GrenadeSnd.Nade_Explode_1'

    // Make our nade glow red!
    LightType=LT_Pulse
    LightPeriod=8.0
    LightPhase=0.0
    LightBrightness=160.0
    LightRadius=6.000000
    LightHue=0
    LightSaturation=0
    LightCone=16
    bDynamicLight=True

    //Always be bright
    bUnlit=True
}