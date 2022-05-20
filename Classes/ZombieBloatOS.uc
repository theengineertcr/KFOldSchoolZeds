//Because we want the zeds to extend to KFMonsterOS,
//We'll need to overhaul all class files of each zed, 
//Controllers as well if we count certain Zeds

// Zombie Monster for KF Invasion gametype
class ZombieBloatOS extends ZombieBloatBaseOS
    abstract;


//----------------------------------------------------------------------------
// NOTE: All Variables are declared in the base class to eliminate hitching
//----------------------------------------------------------------------------

//Issues:
//The same issue with the Siren, since they both can't attack and move at the same time
//Need to increase puke range by 100-200 units and make him puke at a closer distance
//Though, making him puke farther isn't the same as increasing the Scream radius
//And It's confusing me, so were going to have to keep experimenting with this

//KFMod Code
function BodyPartRemoval(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
  super.BodyPartRemoval(Damage, instigatedBy, hitlocation, momentum, damageType);

  //TODO: This is a debug. Remove

    if((Health - Damage)<=0)
        Gored=3;
    if(Gored>=3 && Gored < 5)
        BileBomb();
}

function bool FlipOver()
{
    Return False;
}

//Retail code we're keeping
//Don't interrupt the bloat while he is puking
simulated function bool HitCanInterruptAction()
{
    if( bShotAnim )
    {
        return false;
    }

    return true;
}

//Overhauled with KFMod Code
function DoorAttack(Actor A)
{
    if ( bShotAnim || Physics == PHYS_Swimming)
        return;
    else if ( A!=None )
    {
        bShotAnim = true;
        if( !bDecapitated )
            SetAnimAction('ZombieBarf');
        else
        {
            SetAnimAction('Claw');
            PlaySound(sound'Claw2s', SLOT_None);
        }
    }
}

//Retail code modified with KFMod code
function RangedAttack(Actor A)
{
    local int LastFireTime;

    if ( bShotAnim )
        return;

    if ( Physics == PHYS_Swimming )
    {
        SetAnimAction('Claw');
        bShotAnim = true;
        LastFireTime = Level.TimeSeconds;
    }
    else if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
    {
        bShotAnim = true;
        LastFireTime = Level.TimeSeconds;
        SetAnimAction('Claw');
        PlaySound(sound'Claw2s', SLOT_Interact);
        Controller.bPreparingMove = true;
        Acceleration = vect(0,0,0);
    }
    else if( (KFDoorMover(A)!=None || VSize(A.Location-Location)<=DistBeforePuke) && !bDecapitated )
    {
        bShotAnim=true;
        SetAnimAction('ZombieBarf');
        Controller.bPreparingMove = true;
        Acceleration = vect(0,0,0);
        // We want those voicelines to play!
        // Randomly send out a message about Bloat Vomit burning(3% chance)
        if ( FRand() < 0.03 && KFHumanPawn(A) != none && PlayerController(KFHumanPawn(A).Controller) != none )
        {
            PlayerController(KFHumanPawn(A).Controller).Speech('AUTO', 7, "");
        }    
        //Controller.GotoState(,'WaitForAnim');
    }
}


// Barf Time.

//Retained Retail code for balance reasons
function SpawnTwoShots()
{
    local vector X,Y,Z, FireStart;
    local rotator FireRotation;

    
    if( Controller!=None && KFDoorMover(Controller.Target)!=None )
    {
        Controller.Target.TakeDamage(22,Self,Location,vect(0,0,0),Class'DamTypeVomit');
        return;
    }

    GetAxes(Rotation,X,Y,Z);
    FireStart = Location+(vect(30,0,64) >> Rotation)*DrawScale;
    if ( !SavedFireProperties.bInitialized )
    {
        SavedFireProperties.AmmoClass = Class'SkaarjAmmo';
        SavedFireProperties.ProjectileClass = Class'KFBloatVomitOS';
        SavedFireProperties.WarnTargetPct = 1;
        SavedFireProperties.MaxRange = 500;
        SavedFireProperties.bTossed = False;
        SavedFireProperties.bTrySplash = False;
        SavedFireProperties.bLeadTarget = True;
        SavedFireProperties.bInstantHit = True;
        SavedFireProperties.bInitialized = True;
    }
    
    // Turn off extra collision before spawning vomit, otherwise spawn fails
    ToggleAuxCollision(false);    
    FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);
    Spawn(Class'KFBloatVomitOS',,,FireStart,FireRotation);

    FireStart-=(0.5*CollisionRadius*Y);
    FireRotation.Yaw -= 1200;
    spawn(Class'KFBloatVomitOS',,,FireStart, FireRotation);

    FireStart+=(CollisionRadius*Y);
    FireRotation.Yaw += 2400;
    spawn(Class'KFBloatVomitOS',,,FireStart, FireRotation);
    // Turn extra collision back on    
    ToggleAuxCollision(true);    

}

//Overhauled with KFMod code
simulated function Tick(float deltatime)
{
    local vector BileExplosionLoc;
    local BileExplosionOS GibBileExplosion;
  
    Super.tick(deltatime);
  
    if( Level.NetMode!=NM_DedicatedServer &&
    Gored>0 && 
    !bPlayBileSplash )
    {
        BileExplosionLoc = self.Location;
        BileExplosionLoc.z += (CollisionHeight - (CollisionHeight * 0.5));
        GibBileExplosion = Spawn(class 'BileExplosionOS',self,, BileExplosionLoc );
        bPlayBileSplash = true;
    }
}

//Modified with KFMod code
function BileBomb()
{
    local bool AttachSucess;
    
    //Modified with KFMod Code
    BloatJet = spawn(class'BileJetOS', self,,,);
    
    //KFMod Code
    if(Gored < 5)
        AttachSucess=AttachToBone(BloatJet,'Bip01 Spine');

    if(!AttachSucess)
        BloatJet.SetBase(self);
    BloatJet.SetRelativeRotation(rot(0,-4096,0));
}

function PlayDyingAnimation(class<DamageType> DamageType, vector HitLoc)
{
    //KFMod variable brought back
    local bool AttachSucess;

    super.PlayDyingAnimation(DamageType, HitLoc);

    //Keeping this
    // Don't blow up with bleed out
    if( bDecapitated && DamageType == class'DamTypeBleedOut' )
    {
        return;
    }


    //Added this back in, otherwise they'd not bile bomb upon death
    if(Role == ROLE_Authority)
    {
        BileBomb();
        //KFMod code we want kept
        if(BloatJet!=none)
        {
            if(Gored < 5)
                AttachSucess=AttachToBone(BloatJet,'Bip01 Spine');
            // else
                // AttachSucess=AttachToBone(BloatJet,'Bip01 Spine1');

            if(!AttachSucess)
            {
                //log("DEAD Bloaty Bile didn't like the Boning :o");
                BloatJet.SetBase(self);
            }
        
            BloatJet.SetRelativeRotation(rot(0,-4096,0));
        }
    }
}

//KFMod code
State Dying
{
    function tick(float deltaTime)
    {
        if (BloatJet != none)
        {
            BloatJet.SetLocation(location);
            BloatJet.SetRotation(GetBoneRotation('Bip01 Spine'));
        }
        super.tick(deltaTime);
    }
}

function RemoveHead()
{
    bCanDistanceAttackDoors = False;
    Super.RemoveHead();
}

//KFMod Code
simulated function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType, optional int HitIndex)
{

    // Bloats are volatile. They burn faster than other zeds.
    if (DamageType == class 'Burned')
        Damage *= 1.5;
   
    //Dont take damage from your own puke or modern bloat puke!
    if (damageType == class 'DamTypeVomit' || damageType == class 'DamTypeVomitOS')
    {
        return;
    }
    else if( damageType == class 'DamTypeBlowerThrower' )
    {
       // Reduced damage from the blower thrower bile, but lets not zero it out entirely
       Damage *= 0.25;
    }   
   
  Super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
}


//Precache KFMod textures
static simulated function PreCacheMaterials(LevelInfo myLevel)
{
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.Bloat.BloatSkin');
}


defaultproperties
{
    //-------------------------------------------------------------------------------
    // NOTE: Most Default Properties are set in the base class to eliminate hitching
    //-------------------------------------------------------------------------------
    
    //Event classes dont exist in KFMod
    //EventClasses(0)="KFChar.ZombieBloat_STANDARD"
    
    //Use the Old BloatZombieController
    ControllerClass=Class'KFOldSchoolZeds.BloatZombieControllerOS'
}
