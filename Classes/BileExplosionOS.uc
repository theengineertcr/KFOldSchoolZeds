//2.5 Bile Explosion ✓
class BileExplosionOS extends FleshHitEmitterOS;

//Usage:
//Emitter for when Bloat dies, but not to bleedout
defaultproperties
{
    Begin Object class=SpriteEmitter Name=BileExplosionEmitter
        UseCollision=true
        UseCollisionPlanes=true
        FadeOut=true
        RespawnDeadParticles=false
        SpawnOnlyInDirectionOfNormal=true
        ZTest=false
        SpinParticles=true
        DampRotation=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        ScaleSizeYByVelocity=true
        ScaleSizeZByVelocity=true
        BlendBetweenSubdivisions=true
        UseRandomSubdivision=true
        Acceleration=(Z=-650.000000)
        DampingFactorRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        ColorScale(0)=(Color=(R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=255,A=255))
        ColorMultiplierRange=(Z=(Min=0.670000,Max=2.000000))
        MaxParticles=65
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Max=1.000000)
        StartMassRange=(Min=11.000000,Max=11.000000)
        AlphaRef=110
        UseRotationFrom=PTRS_Normal
        SpinCCWorCW=(X=1.000000)
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.520000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=1.000000,Max=30.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        ScaleSizeByVelocityMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        ScaleSizeByVelocityMax=3.000000
        ParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'KFOldSchoolZeds_Textures.BileSpray'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=1.000000,Max=1.500000)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-100.000000,Max=400.000000))
        MaxAbsVelocity=(X=100.000000,Y=100.000000)
    End Object

    Emitters(0)=BileExplosionEmitter
    LifeSpan=1.500000
}