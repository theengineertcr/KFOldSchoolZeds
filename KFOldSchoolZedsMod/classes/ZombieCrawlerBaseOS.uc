// Zombie Monster for KF Invasion gametype
class ZombieCrawlerBase extends KFMonster
    abstract;

#exec OBJ LOAD FILE=PlayerSounds.uax

var() float PounceSpeed;
var bool bPouncing;

var(Anims)  name    MeleeAirAnims[3]; // Attack anims for when flying through the air

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

function bool DoPounce()
{
	if ( bZapped || bIsCrouched || bWantsToCrouch || (Physics != PHYS_Walking) || VSize(Location - Controller.Target.Location) > (MeleeRange * 5) )
		return false;

	Velocity = Normal(Controller.Target.Location-Location)*PounceSpeed;
	Velocity.Z = JumpZ;
	SetPhysics(PHYS_Falling);
	ZombieSpringAnim();
	bPouncing=true;
	return true;
}

simulated function ZombieSpringAnim()
{
	SetAnimAction('ZombieSpring');
}

event Landed(vector HitNormal)
{
	bPouncing=false;
	super.Landed(HitNormal);
}

event Bump(actor Other)
{
	// TODO: is there a better way
	if(bPouncing && KFHumanPawn(Other)!=none )
	{
		KFHumanPawn(Other).TakeDamage(((MeleeDamage - (MeleeDamage * 0.05)) + (MeleeDamage * (FRand() * 0.1))), self ,self.Location,self.velocity, class 'KFmod.ZombieMeleeDamage');
		if (KFHumanPawn(Other).Health <=0)
		{
			//TODO - move this to humanpawn.takedamage? Also see KFMonster.MeleeDamageTarget
			KFHumanPawn(Other).SpawnGibs(self.rotation, 1);
		}
		//After impact, there'll be no momentum for further bumps
		bPouncing=false;
	}
}

// Blend his attacks so he can hit you in mid air.
simulated function int DoAnimAction( name AnimName )
{
    if( AnimName=='InAir_Attack1' || AnimName=='InAir_Attack2' )
	{
		AnimBlendParams(1, 1.0, 0.0,, FireRootBone);
		PlayAnim(AnimName,, 0.0, 1);
		return 1;
	}

    if( AnimName=='HitF' )
	{
		AnimBlendParams(1, 1.0, 0.0,, NeckBone);
		PlayAnim(AnimName,, 0.0, 1);
		return 1;
	}

	if( AnimName=='ZombieSpring' )
	{
        PlayAnim(AnimName,,0.02);
        return 0;
	}

	return Super.DoAnimAction(AnimName);
}

simulated event SetAnimAction(name NewAction)
{
	local int meleeAnimIndex;

	if( NewAction=='' )
		Return;
	if(NewAction == 'Claw')
	{
		meleeAnimIndex = Rand(2);
		if( Physics == PHYS_Falling )
		{
            NewAction = MeleeAirAnims[meleeAnimIndex];
		}
		else
		{
            NewAction = meleeAnims[meleeAnimIndex];
		}
		CurrentDamtype = ZombieDamType[meleeAnimIndex];
	}
	ExpectingChannel = DoAnimAction(NewAction);

    if( AnimNeedsWait(NewAction) )
    {
        bWaitForAnim = true;
    }

	if( Level.NetMode!=NM_Client )
	{
		AnimAction = NewAction;
		bResetAnimAct = True;
		ResetAnimActTime = Level.TimeSeconds+0.3;
	}
}

// The animation is full body and should set the bWaitForAnim flag
simulated function bool AnimNeedsWait(name TestAnim)
{
    if( TestAnim == 'ZombieSpring' || TestAnim == 'DoorBash' )
    {
        return true;
    }

    return false;
}

function bool FlipOver()
{
	Return False;
}

defaultproperties
{
    DrawScale=1.1
    Prepivot=(Z=0.0)


    PounceSpeed=330.000000   // 300
    MeleeAnims(0)="ZombieLeapAttack"
    MeleeAnims(1)="ZombieLeapAttack2"//"ZombieLeapAttack"
    //MeleeAnims(2)="ZombieLeapAttack2"//"LeapAttack3"
    MeleeAirAnims(0)="InAir_Attack1"
    MeleeAirAnims(1)="InAir_Attack2"//"ZombieLeapAttack"
    //MeleeAirAnims(2)="InAir_Attack2"//"LeapAttack3"
    bStunImmune=True


    MeleeDamage=6
    damageForce=5000

    ScoringValue=10
    IdleHeavyAnim="ZombieLeapIdle"
    IdleRifleAnim="ZombieLeapIdle"
    GroundSpeed=140.000000
    WaterSpeed=130.000000
    JumpZ=350.000000
    Health=70//100
    HealthMax=70//100
    MovementAnims(0)="ZombieScuttle"
    MovementAnims(1)="ZombieScuttleB"
    MovementAnims(2)="ZombieScuttleL"
    MovementAnims(3)="ZombieScuttleR"
    TurnLeftAnim= "TurnLeft"
    TurnRightAnim= "TurnRight"
    WalkAnims(0)="ZombieScuttle"
    WalkAnims(1)="ZombieScuttleB"
    WalkAnims(2)="ZombieScuttleL"
    WalkAnims(3)="ZombieScuttleR"
    AirAnims(0)="ZombieSpring"
    AirAnims(1)= "ZombieSpring"
    AirAnims(2)="ZombieSpring"
    AirAnims(3)="ZombieSpring"
    TakeoffAnims(0)= "ZombieSpring"
    TakeoffAnims(1)= "ZombieSpring"
    TakeoffAnims(2)= "ZombieSpring"
    TakeoffAnims(3)= "ZombieSpring"
    LandAnims(0)= "Landed"
    LandAnims(1)="Landed"
    LandAnims(2)="Landed"
    LandAnims(3)="Landed"
    AirStillAnim="ZombieSpring"
    TakeoffStillAnim="ZombieLeapIdle"//"ZombieLeap"
    IdleCrouchAnim="ZombieLeapIdle"
    IdleWeaponAnim="ZombieLeapIdle"
    IdleRestAnim="ZombieLeapIdle"

    CollisionRadius=26.000000
    CollisionHeight=25.000000
    HitAnims(0)="HitF"
    HitAnims(1)="HitF"
    HitAnims(2)="HitF"
    KFHitFront="HitF"
    KFHitBack="HitF"
    KFHitLeft="HitF"
    KFHitRight="HitF"
    KFRagdollName="Crawler_Trip"
    bCannibal = true
    bCrawler = true
    bOrientOnSlope = true
    MenuName="Crawler"
    Intelligence=BRAINS_Mammal
    ZombieFlag=2
    bDoTorsoTwist=False

	SeveredHeadAttachScale=1.1
	SeveredLegAttachScale=0.85
	SeveredArmAttachScale=0.8

	HeadHeight=2.5
	HeadScale=1.05
	CrispUpThreshhold=10
	OnlineHeadshotOffset=(X=28,Y=0,Z=7)
	OnlineHeadshotScale=1.2
	MotionDetectorThreat=0.34
}
