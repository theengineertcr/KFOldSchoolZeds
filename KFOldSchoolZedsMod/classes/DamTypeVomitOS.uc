class DamTypeVomit extends DamTypeZombieAttack
    abstract;

defaultproperties
{
     HUDDamageTex=FinalBlend'KillingFloorHUD.ClassMenu.VomitFB'
     HUDUberDamageTex=FinalBlend'KillingFloorHUD.ClassMenu.VomitFB'
     HUDTime=1.500000
     DeathString="%o was corroded by %k's vomit."
     FemaleSuicide="%o was corroded by some vomit."
     MaleSuicide="%o was corroded by some vomit."
     bDetonatesGoop=True

     KDamageImpulse = 0   // STOP BLOWING AROUND THE KARMA OBJECTS WITH YOUR UPCHUCK, FATTY!
     bCheckForHeadShots=false
     bLocationalHit=false
}
