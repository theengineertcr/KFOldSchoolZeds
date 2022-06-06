//2.5 FleshHitEmitter ✓
class FleshHitEmitterOS extends KFHitEmitter
    abstract
    hidedropdown;

//Usage:
//Parent class. Holds information for blood that comes out of zeds.
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

defaultproperties
{
    ImpactSounds(0)=Sound'KFOldSchoolZeds_Sounds.Shared.Heavy_FleshImpact1'
    ImpactSounds(1)=Sound'KFOldSchoolZeds_Sounds.Shared.Heavy_FleshImpact1'
    ImpactSounds(2)=Sound'KFOldSchoolZeds_Sounds.Shared.Heavy_FleshImpact2'
    ImpactSounds(3)=Sound'KFOldSchoolZeds_Sounds.Shared.Heavy_FleshImpact3'

    Begin Object class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=true
        RespawnDeadParticles=false
        SpawnOnlyInDirectionOfNormal=true
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        ScaleSizeYByVelocity=true
        ScaleSizeZByVelocity=true
        AutomaticInitialSpawning=false
        BlendBetweenSubdivisions=true
        UseRandomSubdivision=true
        Acceleration=(Z=-350.000000)
        ColorScale(1)=(RelativeTime=0.300000,Color=(B=255,G=255,R=255))
        ColorScale(2)=(RelativeTime=0.750000,Color=(B=96,G=160,R=255))
        ColorScale(3)=(RelativeTime=1.000000)
        ColorMultiplierRange=(Z=(Min=0.670000,Max=2.000000))
        FadeOutStartTime=0.300000
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Max=5.000000)
        StartMassRange=(Min=11.000000,Max=11.000000)
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.120000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=3.500000)
        StartSizeRange=(X=(Min=8.000000,Max=12.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        ScaleSizeByVelocityMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        ScaleSizeByVelocityMax=3.000000
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_Modulated
        Texture=Texture'KFOldSchoolZeds_Textures.BloodySpray'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=0.500000,Max=0.750000)
        StartVelocityRange=(Z=(Min=120.000000,Max=150.000000))
    End Object
    Emitters(0)=SpriteEmitter0

    LifeSpan=1.000000
}