// Vomit for Bloat Zombie ✓
class KFBloatVomitOS extends KFBloatVomit;

#exec OBJ LOAD FILE=KillingFloorLabTextures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax

//TODO: Optimization. Extend to parent and shorten
state OnGround
{
    simulated function BeginState()
    {
        SetTimer(RestTime, false);
        BlowUp(Location);
    }
    simulated function Timer()
    {
        if (bDrip)
        {
            bDrip = false;
            SetCollisionSize(default.CollisionHeight, default.CollisionRadius);
            Velocity = PhysicsVolume.Gravity * 0.2;
            SetPhysics(PHYS_Falling);
            bCollideWorld = true;
            bCheckedsurface = false;
            bProjTarget = false;
            LoopAnim('flying', 1.0);
            GotoState('Flying');
        }
        else BlowUp(Location);
    }

    simulated function ProcessTouch(Actor Other, Vector HitLocation)
    {
        if ( Other != none )
            BlowUp(Location);
    }

    function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
    {
        if (DamageType.default.bDetonatesGoop)
        {
            bDrip = false;
            SetTimer(0.1, false);
        }
    }
    simulated function AnimEnd(int Channel)
    {
        local float DotProduct;

        if (!bCheckedSurface)
        {
            DotProduct = SurfaceNormal dot Vect(0,0,-1);
            if (DotProduct > 0.7)
            {
                PlayAnim('Drip', 0.66);
                bDrip = true;
                SetTimer(DripTime, false);
                if (bOnMover)
                    BlowUp(Location);
            }
            else if (DotProduct > -0.5)
            {
                PlayAnim('Slide', 1.0);
                if (bOnMover)
                    BlowUp(Location);
            }
            bCheckedSurface = true;
        }
    }
    simulated function MergeWithGlob(int AdditionalGoopLevel)
    {
        local int NewGoopLevel, ExtraSplash;
        NewGoopLevel = AdditionalGoopLevel + GoopLevel;
        if (NewGoopLevel > MaxGoopLevel)
        {
            Rand3 = (Rand3 + 1) % 3;
            ExtraSplash = Rand3;
            if (Role == ROLE_Authority)
                SplashGlobs(NewGoopLevel - MaxGoopLevel + ExtraSplash);
            NewGoopLevel = MaxGoopLevel - ExtraSplash;
        }
        SetGoopLevel(NewGoopLevel);
        SetCollisionSize(GoopVolume*10.0, GoopVolume*10.0);
        PlaySound(ImpactSound, SLOT_Misc);
        PlayAnim('hit');
        bCheckedSurface = false;
        SetTimer(RestTime, false);
    }
}

singular function SplashGlobs(int NumGloblings)
{
    local int g;
    local KFBloatVomitOS NewGlob;
    local Vector VNorm;

    for (g=0; g<NumGloblings; g++)
    {
        NewGlob = Spawn(class, self,, Location+GoopVolume*(CollisionHeight+4.0)*SurfaceNormal);
        if (NewGlob != none)
        {
            NewGlob.Velocity = (GloblingSpeed + FRand()*150.0) * (SurfaceNormal + VRand()*0.8);
            if (Physics == PHYS_Falling)
            {
                VNorm = (Velocity dot SurfaceNormal) * SurfaceNormal;
                NewGlob.Velocity += (-VNorm + (Velocity - VNorm)) * 0.1;
            }
            NewGlob.InstigatorController = InstigatorController;
        }
    }
}

simulated function Destroyed()
{
    if ( !bNoFX && EffectIsRelevant(Location,false) )
    {
        Spawn(class'VomGroundSplashOS');
    }

    if ( Fear != none )
        Fear.Destroy();

    if (Trail != none)
        Trail.Destroy();
}

auto state Flying
{
    simulated function Landed( Vector HitNormal )
    {
        local Rotator NewRot;
        local int CoreGoopLevel;

        if ( Level.NetMode != NM_DedicatedServer )
        {
            PlaySound(ImpactSound, SLOT_Misc);
        }

        SurfaceNormal = HitNormal;

        CoreGoopLevel = Rand3 + MaxGoopLevel - 3;
        if (GoopLevel > CoreGoopLevel)
        {
            if (Role == ROLE_Authority)
                SplashGlobs(GoopLevel - CoreGoopLevel);
            SetGoopLevel(CoreGoopLevel);
        }
        spawn(class'VomitDecalOS',,,, rotator(-HitNormal));

        bCollideWorld = false;
        SetCollisionSize(GoopVolume*10.0, GoopVolume*10.0);
        bProjTarget = true;

        NewRot = Rotator(HitNormal);
        NewRot.Roll += 32768;
        SetRotation(NewRot);
        SetPhysics(PHYS_None);
        bCheckedsurface = false;
        Fear = Spawn(class'AvoidMarker');
        GotoState('OnGround');
    }

    simulated function HitWall( Vector HitNormal, Actor Wall )
    {
        Landed(HitNormal);
        if ( !Wall.bStatic && !Wall.bWorldGeometry )
        {
            bOnMover = true;
            SetBase(Wall);
            if (Base == none)
                BlowUp(Location);
        }
    }

    simulated function ProcessTouch(Actor Other, Vector HitLocation)
    {
        if( ExtendedZCollision(Other)!=none )
            return;

        if (Other != Instigator && (Other.IsA('Pawn') || Other.IsA('DestroyableObjective') || Other.bProjTarget))
            HurtRadius(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
        else if ( Other != Instigator && Other.bBlockActors )
            HitWall( Normal(HitLocation-Location), Other );
    }
}

defaultproperties
{
    //DamTypeVomitOS does not deal immediate damage, fix this later
    //MyDamageType=class'DamTypeVomitOS'
    LifeSpan=1.000000//8.000000
    Skins(0)=Texture'KillingFloorLabTextures.LabCommon.voidtex'
    CollisionRadius=0.000000//2.000000
    CollisionHeight=0.000000//2.000000
    StaticMesh=none//Mesh'XWeapons_rc.GoopMesh'
    ExplodeSound=Sound'KFOldSchoolZeds_Sounds.Shared.BioRifleGoo1'
    ImpactSound=Sound'KFOldSchoolZeds_Sounds.Shared.BioRifleGoo2'
}