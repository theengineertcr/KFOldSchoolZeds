//KFModified
class DamTypeVomitOS extends DamTypeVomit
    abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx

defaultproperties
{
    //Use KFMod Textures
     HUDDamageTex=FinalBlend'KFOldSchoolZeds_Textures.HUD.VomitFB'
     HUDUberDamageTex=FinalBlend'KFOldSchoolZeds_Textures.HUD.VomitFB'
     HUDTime=1.500000
     DeathString="%o was corroded by %k's vomit."
     FemaleSuicide="%o was corroded by some vomit."
     MaleSuicide="%o was corroded by some vomit."
     bDetonatesGoop=True

     KDamageImpulse = 0   // STOP BLOWING AROUND THE KARMA OBJECTS WITH YOUR UPCHUCK, FATTY!
     bCheckForHeadShots=false
     bLocationalHit=false
}
