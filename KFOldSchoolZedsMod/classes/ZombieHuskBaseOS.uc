//=============================================================================
// ZombieHusk
//=============================================================================
// Husk burned up fire projectile launching zed pawn class
//=============================================================================
// Killing Floor Source
// Copyright (C) 2009 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class ZombieHuskBase extends KFMonster
    abstract;

var     float   NextFireProjectileTime; // Track when we will fire again
var()   float   ProjectileFireInterval; // How often to fire the fire projectile
var()   float   BurnDamageScale;        // How much to reduce fire damage for the Husk

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
    DrawScale=1.4
    Prepivot=(Z=22.0)

    MeleeAnims(0)="Strike"
    MeleeAnims(1)="Strike"
    MeleeAnims(2)="Strike"
    damageForce=70000
    bFatAss=True
    KFRagdollName="Burns_Trip"

    AmmunitionClass=Class'KFMod.BZombieAmmo'
    ScoringValue=17
    IdleHeavyAnim="Idle"
    IdleRifleAnim="Idle"
    MeleeRange=30.0//55.000000

    MovementAnims(0)="WalkF"
    MovementAnims(1)="WalkB"
    MovementAnims(2)="WalkL"
    MovementAnims(3)="WalkR"
    WalkAnims(0)="WalkF"
    WalkAnims(1)="WalkB"
    WalkAnims(2)="WalkL"
    WalkAnims(3)="WalkR"
    IdleCrouchAnim="Idle"
    IdleWeaponAnim="Idle"
    IdleRestAnim="Idle"
    //SoundRadius=2.5
    AmbientSoundScaling=8.0
    SoundVolume=200

    AmbientGlow=0

    Mass=400.000000
    RotationRate=(Yaw=45000,Roll=0)

    Skins(1)=Shader'KF_Specimens_Trip_T_Two.burns.burns_shdr'

    GroundSpeed=115.0
    WaterSpeed=102.000000
    Health=600//700
    HealthMax=600//700
    PlayerCountHealthScale=0.10//0.15
    PlayerNumHeadHealthScale=0.05
	HeadHealth=200//250
    MeleeDamage=15
    JumpZ=320.000000

    bCannibal = False // No animation for him.
    MenuName="Husk"

    CollisionRadius=26.000000
    CollisionHeight=44
    bCanDistanceAttackDoors=True
    Intelligence=BRAINS_Mammal
    bUseExtendedCollision=True
    ColOffset=(Z=36)
    ColRadius=30
    ColHeight=33
    ZombieFlag=1

	SeveredHeadAttachScale=0.9
	SeveredLegAttachScale=0.9
	SeveredArmAttachScale=0.9

	BleedOutDuration=6.0
	HeadHeight=1.0
	HeadScale=1.5
	ProjectileFireInterval=5.5
	BurnDamageScale=0.25
	OnlineHeadshotOffset=(X=20,Y=0,Z=55)
	OnlineHeadshotScale=1.0
	MotionDetectorThreat=1.0
	ZapThreshold=0.75
	bHarpoonToHeadStuns=true
	bHarpoonToBodyStuns=false
}
