//=============================================================================
// BloodJet.
//=============================================================================
class BloodJet extends xEmitter;

//#exec OBJ LOAD File=XGameShadersB.utx

var class<ProjectedDecal> SplatterClass;

state Ticking
{
	simulated function Tick( float dt )
	{
		if( LifeSpan < 1.0 )
		{
			mRegenRange[0] *= LifeSpan;
			mRegenRange[1] = mRegenRange[0];
		}
	}
}

simulated function timer()
{
	GotoState('Ticking');
}

simulated function PostNetBeginPlay()
{
	SetTimer(LifeSpan - 1.0,false);
	if ( Level.NetMode != NM_DedicatedServer )
		WallSplat();
	Super.PostNetBeginPlay();
}

simulated function WallSplat()
{
	local vector WallHit, WallNormal;
	local Actor WallActor;

	if ( FRand() > 0.8 )
		return;
	WallActor = Trace(WallHit, WallNormal, Location + vect(0,0,-200), Location, false);
	if ( WallActor != None )
		spawn(SplatterClass,,,WallHit + 20 * (WallNormal + VRand()), rotator(-WallNormal));
}

defaultproperties
{
	SplatterClass=class'ROBloodSplatter'
    LifeSpan=3.5
    Style=STY_Alpha
    mParticleType=PT_Sprite
    mDirDev=(X=0.05,Y=0.05,Z=0.05)
    mPosDev=(X=0.0,Y=0.0,Z=0.0)
    mDelayRange(0)=0.000000
    mDelayRange(1)=0.00000
    mLifeRange(0)=1.00000
    mLifeRange(1)=1.000000
    mSpeedRange(0)=50.000000
    mSpeedRange(1)=90.000000
    mSizeRange(0)=1.5
    mSizeRange(1)=2.5
    mMassRange(0)=0.4
    mMassRange(1)=0.5
    mGrowthRate=12.0
	mRegenRange(0)=80.000000
	mRegenRange(1)=80.000000
    mRegenOnTime(0)=1.0
	mRegenOnTime(1)=2.0
	mRegenOffTime(0)=0.4
	mRegenOffTime(1)=1.0
    mRegenDist=0.000000
    mRandOrient=true
    mMaxParticles=60
    mStartParticles=0
    DrawScale=1.000000
    ScaleGlow=1.000000
    mAirResistance=0.6
    mAttenuate=true
    mRegenPause=true
    mRegen=true
    Skins(0)=none//Material'XGameShadersB.Blood.BloodJetC' KFTODO: replace this texture
    CollisionRadius=0.000000
    CollisionHeight=0.000000
    mColorRange(0)=(R=255,G=255,B=255,A=255)
    mColorRange(1)=(R=255,G=255,B=255,A=255)
    mCollision=False
    bForceAffected=False
    mRandTextures=True
    mNumTileColumns=4
    mNumTileRows=4
    bUnlit=true
    bNetTemporary=true
    RemoteRole=ROLE_None
}
