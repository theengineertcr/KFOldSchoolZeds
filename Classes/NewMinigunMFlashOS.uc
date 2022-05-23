//Originally from XEffects
class NewMinigunMFlashOS extends Emitter;

//Load correct texture package
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

defaultproperties
{
     Begin Object class=SpriteEmitter Name=SpriteEmitter4
         RespawnDeadParticles=false
         SpinParticles=true
         UniformSize=true
         AutomaticInitialSpawning=false
         BlendBetweenSubdivisions=true
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartLocationOffset=(X=8.000000)
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=15.000000,Max=20.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'KFOldSchoolZeds_Textures.Shared.Part_explode2s'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(0)=SpriteEmitter4

     Begin Object class=SpriteEmitter Name=SpriteEmitter5
         RespawnDeadParticles=false
         SpinParticles=true
         UniformSize=true
         AutomaticInitialSpawning=false
         BlendBetweenSubdivisions=true
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartLocationOffset=(X=16.000000)
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=10.000000,Max=15.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'KFOldSchoolZeds_Textures.Shared.Part_explode2s'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(1)=SpriteEmitter5

     Begin Object class=SpriteEmitter Name=SpriteEmitter6
         RespawnDeadParticles=false
         SpinParticles=true
         UniformSize=true
         AutomaticInitialSpawning=false
         BlendBetweenSubdivisions=true
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartLocationOffset=(X=24.000000)
         StartLocationRange=(X=(Max=8.000000))
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=5.000000,Max=10.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'KFOldSchoolZeds_Textures.Shared.Part_explode2s'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(2)=SpriteEmitter6

     Begin Object class=SpriteEmitter Name=SpriteEmitter7
         RespawnDeadParticles=false
         SpinParticles=true
         UniformSize=true
         AutomaticInitialSpawning=false
         BlendBetweenSubdivisions=true
         CoordinateSystem=PTCS_Relative
         MaxParticles=4
         StartLocationOffset=(X=32.000000)
         StartLocationRange=(X=(Max=8.000000))
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=2.500000,Max=5.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'KFOldSchoolZeds_Textures.Shared.Part_explode2s'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(3)=SpriteEmitter7

     bNoDelete=false
     bHardAttach=true
}