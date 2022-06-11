//2.5 BloodSpurt Emitter ✓
class BloodSpurtOS extends xEmitter;

//Usage:
//Decals for when blood impacts a wall
#exec OBJ LOAD FILE=KFOldSchool_XEffects.utx

var class<Actor>    BloodDecalClass;
var texture Splats[3];
var vector HitDir;
var bool bMustShow;

replication
{
    unreliable if ( bNetInitial && (Role==ROLE_Authority) )
        bMustShow,HitDir;
}

simulated function PostNetBeginPlay()
{
    if ( Level.NetMode != NM_DedicatedServer )
        WallSplat();
    else
        LifeSpan = 0.2;
}

simulated function WallSplat()
{
    local vector WallHit, WallNormal;
    local Actor WallActor;

    if ( Level.bDropDetail || (!bMustShow && (FRand() > 0.8)) || (BloodDecalClass == none) )
        return;

    if ( HitDir == vect(0,0,0) )
    {
        if ( Owner != none )
            HitDir = Location - Owner.Location;
        else
            HitDir.Z = -1;
    }

    HitDir = Normal(HitDir);
    WallActor = Trace(WallHit, WallNormal, Location + 350 * HitDir, Location, false);

    if ( WallActor != none )
        spawn(BloodDecalClass,,,WallHit + 20 * (WallNormal + VRand()), rotator(-WallNormal));
}

static function PrecacheContent(LevelInfo Level)
{
    local int i;

    super.PrecacheContent(Level);

    if ( default.BloodDecalClass != none )
        for ( i=0; i<3; i++ )
            Level.AddPrecacheMaterial(default.splats[i]);
}

defaultproperties
{
     BloodDecalClass=class'BloodSplatterOS'
     Splats(0)=Texture'KFOldSchool_XEffects.BloodSplat1'
     Splats(1)=Texture'KFOldSchool_XEffects.BloodSplat2'
     Splats(2)=Texture'KFOldSchool_XEffects.BloodSplat3'
     mRegen=false
     mStartParticles=13
     mMaxParticles=13
     mLifeRange(0)=1.000000
     mLifeRange(1)=2.000000
     mRegenRange(0)=0.000000
     mRegenRange(1)=0.000000
     mDirDev=(X=0.100000,Y=0.100000,Z=0.100000)
     mSpeedRange(0)=0.000000
     mSpeedRange(1)=85.000000
     mMassRange(0)=0.020000
     mMassRange(1)=0.040000
     mAirResistance=0.600000
     mRandOrient=true
     mSizeRange(0)=5.500000
     mSizeRange(1)=9.500000
     mGrowthRate=3.000000
     mRandTextures=true
     mNumTileColumns=4
     mNumTileRows=4
     bOnlyRelevantToOwner=true
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=3.500000
     Skins(0)=Texture'KFOldSchool_XEffects.pcl_Blooda'
     Style=STY_Alpha
}