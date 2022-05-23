// ✔
// Effect for obliteration
class GibExplosionOS extends FleshHitEmitterOS;

// Load up the textures
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter43
         FadeOut=True
         RespawnDeadParticles=False
         SpawnOnlyInDirectionOfNormal=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ScaleSizeYByVelocity=True
         ScaleSizeZByVelocity=True
         BlendBetweenSubdivisions=True
         UseRandomSubdivision=True
         Acceleration=(Z=-350.000000)
         ColorScale(0)=(Color=(R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(R=255,A=255))
         ColorMultiplierRange=(Z=(Min=0.670000,Max=2.000000))
         FadeOutStartTime=0.126500
         MaxParticles=65
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=5.000000)
         StartMassRange=(Min=11.000000,Max=11.000000)
         UseRotationFrom=PTRS_Normal
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.120000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=3.500000)
         StartSizeRange=(X=(Min=45.000000,Max=50.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
         ScaleSizeByVelocityMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
         ScaleSizeByVelocityMax=3.000000
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_Modulated
         // Bloody spray in KFX was imported to KFOldSchoolZeds_Textures
         Texture=Texture'KFOldSchoolZeds_Textures.BloodySpray'
         TextureUSubdivisions=4
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.400000,Max=0.550000)
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=300.000000,Max=500.000000))
     End Object
     // This class uses this emitter, make sure that's known
     Emitters(0)=SpriteEmitter43
}