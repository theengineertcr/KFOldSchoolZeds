// The Nice, nasty barf we'll be using for the Bloat's ranged attack.
// KFModified!
class KFBloatVomitOS extends KFBloatVomit;


// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KillingFloorLabTextures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax

//PostBeginPlay and DifficultyDamageModifer removed,
//We don't need to restate things in the parent class

//Some minor differences
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
            //KFMod wants to have the anim loop, so we'll loop it
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
                //KFMod Code
                PlayAnim('Drip', 0.66);
                bDrip = true;
                SetTimer(DripTime, false);
                if (bOnMover)
                    BlowUp(Location);
            }
            else if (DotProduct > -0.5)
            {
                //KFMode Code
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
        //KFMod Code
        PlayAnim('hit');
        bCheckedSurface = false;
        SetTimer(RestTime, false);
    }
}

//KFModified
singular function SplashGlobs(int NumGloblings)
{
    local int g;
    //Use KFMod Bloat Vomit
    local KFBloatVomitOS NewGlob;
    local Vector VNorm;

    for (g=0; g<NumGloblings; g++)
    {
        NewGlob = Spawn(Class, self,, Location+GoopVolume*(CollisionHeight+4.0)*SurfaceNormal);
        if (NewGlob != None)
        {
            NewGlob.Velocity = (GloblingSpeed + FRand()*150.0) * (SurfaceNormal + VRand()*0.8);
            if (Physics == PHYS_Falling)
            {
                VNorm = (Velocity dot SurfaceNormal) * SurfaceNormal;
                NewGlob.Velocity += (-VNorm + (Velocity - VNorm)) * 0.1;
            }
            NewGlob.InstigatorController = InstigatorController;
        }
        //else log("unable to spawn globling");
    }
}

//KFModified
simulated function Destroyed()
{
    if ( !bNoFX && EffectIsRelevant(Location,false) )
    {
        //Spawn(class'xEffects.GoopSmoke');
        //Use KFMod VomGroundSplash
        Spawn(class'VomGroundSplashOS');
    }
    if ( Fear != None )
        Fear.Destroy();
    if (Trail != None)
        Trail.Destroy();
    //Super.Destroyed();
}

//KFModified
auto state Flying
{
    simulated function Landed( Vector HitNormal )
    {
        local Rotator NewRot;
        local int CoreGoopLevel;

        if ( Level.NetMode != NM_DedicatedServer )
        {
            PlaySound(ImpactSound, SLOT_Misc);
            // explosion effects
        }

        SurfaceNormal = HitNormal;

        // spawn globlings
        CoreGoopLevel = Rand3 + MaxGoopLevel - 3;
        if (GoopLevel > CoreGoopLevel)
        {
            if (Role == ROLE_Authority)
                SplashGlobs(GoopLevel - CoreGoopLevel);
            SetGoopLevel(CoreGoopLevel);
        }
        //Use KFMod VomitDecal
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
            if (Base == None)
                BlowUp(Location);
        }
    }

    simulated function ProcessTouch(Actor Other, Vector HitLocation)
    {
        if( ExtendedZCollision(Other)!=None )
            Return;
        if (Other != Instigator && (Other.IsA('Pawn') || Other.IsA('DestroyableObjective') || Other.bProjTarget))
            HurtRadius(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
        else if ( Other != Instigator && Other.bBlockActors )
            HitWall( Normal(HitLocation-Location), Other );
    }
}

defaultproperties
{
     //Not set in KFMod, maybe set to none?
     //DrawType=DT_StaticMesh
     BaseDamage=3
     TouchDetonationDelay=0.000000
     Speed=400.000000
     Damage=4.000000
     MomentumTransfer=2000.000000
     //Use KFMod DamTypeVomit
     MyDamageType=Class'DamTypeVomitOS'
     bDynamicLight=False
     LifeSpan=1.000000//8.000000 Old value used
     //Use KFMod's texture, even though it wont be useful
     Skins(0)=Texture'KillingFloorLabTextures.LabCommon.voidtex'
     CollisionRadius=0.000000//2.000000 Old Values used here
     CollisionHeight=0.000000//2.000000
     bUseCollisionStaticMesh=False
     //Dont use modern chunks
     StaticMesh=none//Mesh'XWeapons_rc.GoopMesh'
     //Use BioGlob's Impact and Explosion sound
     ExplodeSound=Sound'KFOldSchoolZeds_Sounds.Shared.BioRifleGoo1'
     ImpactSound=Sound'KFOldSchoolZeds_Sounds.Shared.BioRifleGoo2'
     bBlockHitPointTraces=false
}