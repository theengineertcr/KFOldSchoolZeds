//Because we want the zeds to extend to KFMonsterOS,
//We'll need to overhaul all class files of each zed, 
//Controllers as well if we count certain Zeds

// Zombie Monster for KF Invasion gametype
class ZombieSirenOS extends ZombieSirenBaseOS
    abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx


//----------------------------------------------------------------------------
// NOTE: All Variables are declared in the base class to eliminate hitching
//----------------------------------------------------------------------------

//Issues:
//Buggy head hitbox, but should be fine after the radius increase.


function bool FlipOver()
{
    Return False;
}

//Same as KFMod
function DoorAttack(Actor A)
{
    if ( bShotAnim || Physics == PHYS_Swimming || bDecapitated || A==None )
        return;
    bShotAnim = true;
    SetAnimAction('Siren_Scream');
}

function RangedAttack(Actor A)
{
    local int LastFireTime;
    local float Dist; //Retail variable were keeping

    if ( bShotAnim )
        return;

    Dist = VSize(A.Location - Location);

    //Most of the code is the same
    if ( Physics == PHYS_Swimming )
    {
        SetAnimAction('Claw');
        bShotAnim = true;
        LastFireTime = Level.TimeSeconds;
    }
    else if ( Dist < MeleeRange + CollisionRadius + A.CollisionRadius )
    {
        bShotAnim = true;
        LastFireTime = Level.TimeSeconds;
        SetAnimAction('Claw');
        //We can bring this sound back
        PlaySound(sound'Claw2s', SLOT_Interact); 
        Controller.bPreparingMove = true;
        Acceleration = vect(0,0,0);
    }    //Sirens cant move while screaming anymore, making them less of a risk,
        //So were going to have to make them get even closer before screaming,
        //Otherwise she'll scream at a distance where she deals no damage
    else if( Dist <= (ScreamRadius - DistBeforeScream) && !bDecapitated && !bZapped )
    {
        bShotAnim=true;
        SetAnimAction('Siren_Scream');
        Controller.bPreparingMove = true;
        Acceleration = vect(0,0,0);
    }
}

//We'll keep this retail code as the old scream effect was shit
// Scream Time
simulated function SpawnTwoShots()
{
    if( bZapped )
    {
        return;
    }

    DoShakeEffect();

    if( Level.NetMode!=NM_Client )
    {
        // Deal Actual Damage.
        if( Controller!=None && KFDoorMover(Controller.Target)!=None )
            Controller.Target.TakeDamage(ScreamDamage*0.6,Self,Location,vect(0,0,0),ScreamDamageType);
        else HurtRadius(ScreamDamage ,ScreamRadius, ScreamDamageType, ScreamForce, Location);
    }
}

//We'll keep this retail code as the old scream effect was shit
// Shake nearby players screens
simulated function DoShakeEffect()
{
    local PlayerController PC;
    local float Dist, scale, BlurScale;

    //viewshake
    if (Level.NetMode != NM_DedicatedServer)
    {
        PC = Level.GetLocalPlayerController();
        if (PC != None && PC.ViewTarget != None)
        {
            Dist = VSize(Location - PC.ViewTarget.Location);
            if (Dist < ScreamRadius )
            {
                scale = (ScreamRadius - Dist) / (ScreamRadius);
                scale *= ShakeEffectScalar;
                BlurScale = scale;

                // Reduce blur if there is something between us and the siren
                if( !FastTrace(PC.ViewTarget.Location,Location) )
                {
                    scale *= 0.25;
                    BlurScale = scale;
                }
                else
                {
                    scale = Lerp(scale,MinShakeEffectScale,1.0);
                }

                PC.SetAmbientShake(Level.TimeSeconds + ShakeFadeTime, ShakeTime, OffsetMag * Scale, OffsetRate, RotMag * Scale, RotRate);

                if( KFHumanPawn(PC.ViewTarget) != none )
                {
                    KFHumanPawn(PC.ViewTarget).AddBlur(ShakeTime, BlurScale * ScreamBlurScale);
                }

                // 10% chance of player saying something about our scream
                if ( Level != none && Level.Game != none && !KFGameType(Level.Game).bDidSirenScreamMessage && FRand() < 0.10 )
                {
                    PC.Speech('AUTO', 16, "");
                    KFGameType(Level.Game).bDidSirenScreamMessage = true;
                }
            }
        }
    }
}

//Don't touch this code, we want the Retail versions Siren Scream
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
        // don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
        // Or Karma actors in this case. Self inflicted Death due to flying chairs is uncool for a zombie of your stature.
        if( (Victims != self) && !Victims.IsA('FluidSurfaceInfo') && !Victims.IsA('KFMonster') && !Victims.IsA('ExtendedZCollision') )
        {
            dir = Victims.Location - HitLocation;
            dist = FMax(1,VSize(dir));
            dir = dir/dist;
            damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);

            if (!Victims.IsA('KFHumanPawn')) // If it aint human, don't pull the vortex crap on it.
                Momentum = 0;

            if (Victims.IsA('KFGlassMover'))   // Hack for shattering in interesting ways.
            {
                UsedDamageAmount = 100000; // Siren always shatters glass
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

//Same as KFMod
// When siren loses her head she's got nothin' Kill her.
function RemoveHead()
{
    Super.RemoveHead();
    if( FRand()<0.5 )
        KilledBy(LastDamagedBy);
    else
    {
        bAboutToDie = True;
        MeleeRange = -500;
        DeathTimer = Level.TimeSeconds+10*FRand();
    }
}

simulated function Tick( float Delta )
{
    Super.Tick(Delta);
    if( bAboutToDie && Level.TimeSeconds>DeathTimer )
    {
        if( Health>0 && Level.NetMode!=NM_Client )
            KilledBy(LastDamagedBy);
        bAboutToDie = False;
    }
}

function PlayDyingSound()
{
    if( !bAboutToDie )
        Super.PlayDyingSound();
}

//Precache KFMod textures
static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Siren.SirenSkin');
    myLevel.AddPrecacheMaterial(FinalBlend'KFOldSchoolZeds_Textures.Siren.SirenHairFB');
}

defaultproperties
{
    //-------------------------------------------------------------------------------
    // NOTE: Most Default Properties are set in the base class to eliminate hitching
    //-------------------------------------------------------------------------------

    //Use Old SirenZombieController
    ControllerClass=class'SirenZombieControllerOS'
}
