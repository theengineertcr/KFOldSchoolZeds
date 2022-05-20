//KFMod-ify this
//KFMod Extends to AlienBloodJet, not Emitter
//AlienBloodJet extends to modern Bloodjet, and it has a snippet of code detailing it
//Using a different splatterclass, so we'll extend to KFMod Bloodjet and use its SplatterClass

class KFVomitJetOS extends BloodJetOS;

// Load KFOldSchoolZeds_Textures
#exec OBJ LOAD File=KFOldSchoolZeds_Textures.utx

//Overhauled, no longer defines emitter parameters
defaultproperties
{
    //Use KFModified version of BioDecal
     SplatterClass=Class'KFOldSchoolZeds.BioDecalOS'
     mMaxParticles=50
     mSpeedRange(0)=100.000000
     mSpeedRange(1)=180.000000
     mCollision=True
     mGrowthRate=50.000000
     LifeSpan=2.000000
    //Use KFMod Texture
     Skins(0)=Texture'KFOldSchoolZeds_Textures.VomitSplash'
     bUnlit=False
}