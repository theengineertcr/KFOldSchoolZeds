// Projectile for Gunner Class ✓
class GunnerGLProjectile extends SPGrenadeProjectile;

#exec OBJ LOAD FILE=KFOldSchoolStatics.usx
#exec OBJ LOAD FILE=KF_GrenadeSnd.uax
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KF_IJC_HalloweenSnd.uax

var bool bNerfed;

// Does not work
function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    if ( Monster(instigatedBy) != none || instigatedBy == Instigator )
    {
        //If were hit by the zed guns, go away
        if( damageType == class'DamTypeZEDGun' || DamageType == class 'DamTypeZEDGunMKII')
        {
            Disintegrate(HitLocation, vect(0,0,1));
        }
        //If were hit by fire, explode
        else if(DamageType == class'DamTypeBurned')
        {
            Explode(HitLocation, vect(0,0,1));
        }
    }
}

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

    if (Level.Game != none)
    {
        if(!bNerfed)
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
            else
            {
                Damage = default.Damage * 1.66;
            }
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
        Velocity=0.6*Velocity;

    super(Projectile).PostBeginPlay();

    SetTimer(ExplodeTimer, false);
}

// override to prevent zeds from taking damage - taken from siren
simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
    local actor Victims;
    local float damageScale, dist;
    local vector dir;
    local float UsedDamageAmount;

    if( bHurtEntry )
        return;

    bHurtEntry = true;
    foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
    {
        if( (Victims != self) && !Victims.IsA('FluidSurfaceInfo') && !Victims.IsA('KFMonster') && !Victims.IsA('ExtendedZCollision') )
        {
            dir = Victims.Location - HitLocation;
            dist = FMax(1,VSize(dir));
            dir = dir/dist;
            damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);

            if (Victims.IsA('KFGlassMover'))
            {
                UsedDamageAmount = 100000;
            }
            else
            {
                UsedDamageAmount = DamageAmount;
            }

            Victims.TakeDamage(damageScale * UsedDamageAmount,Instigator, Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,(damageScale * Momentum * dir),DamageType);

            if (Instigator != None && Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
                Vehicle(Victims).DriverRadiusDamage(UsedDamageAmount, DamageRadius, Instigator.Controller, DamageType, Momentum, HitLocation);
        }
    }
    bHurtEntry = false;
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
    if ( Other == none || Other == Instigator || Other.Base == Instigator )
        return;

    if( KFBulletWhipAttachment(Other) != none )
    {
        return;
    }

    if( KFMonster(Other) != none && KFMonsterOS(Other) != none && Instigator != none )
    {
        return;
    }

    if( Instigator != none )
    {
        OrigLoc = Instigator.Location;
    }

    if( !bKillMomentum )
    {
       Explode(HitLocation,Normal(HitLocation-Other.Location));
    }
}

defaultproperties
{
    ArmDistSquared=0
    Speed=1
    MaxSpeed=2500
    Damage=75 // Balance Round 2
    DamageRadius=350 // Balance Round 2
    MyDamageType=class'DamTypeFrag'
    ImpactDamage=0
    DampenFactor=0.4
    DampenFactorParallel=0.3
    DrawScale=4.0
    ImpactSound=Sound'KFOldSchoolZeds_Sounds.Bounce'
    AmbientSound=None
    StaticMesh=StaticMesh'KFOldSchoolStatics.GunPoundProj'
    ExplosionSound=Sound'KF_GrenadeSnd.Nade_Explode_1'
    LightType=LT_Pulse
    LightPeriod=8.0
    LightPhase=0.0
    LightBrightness=160.0
    LightRadius=6.000000
    LightHue=0
    LightSaturation=0
    bDynamicLight=true
    bUnlit=true
}