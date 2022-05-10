// ✔
// A group of gibs, how nice. Make sure this class  
// Uses all of the KFMod Gibs and Blood puffs
class KFHumanGibGroupOS extends xPawnGibGroup;

defaultproperties
{
	 //KFMod Gibs
     Gibs(0)=Class'KFOldSchoolZedsMod.KFGibHeadOS'
     Gibs(1)=Class'KFOldSchoolZedsMod.KFGibHeadbOS'
     Gibs(2)=Class'KFOldSchoolZedsMod.KFGibHeadOS'
     Gibs(3)=Class'KFOldSchoolZedsMod.KFGibHeadbOS'
     Gibs(4)=Class'KFOldSchoolZedsMod.KFGibHeadOS'
     Gibs(5)=Class'KFOldSchoolZedsMod.KFGibHeadOS'
     Gibs(6)=Class'KFOldSchoolZedsMod.KFGibHeadbOS'
     Gibs(7)=Class'KFOldSchoolZedsMod.KFGibHeadOS'
	 
	 //KFMod Blood Puffs
     BloodHitClass=Class'KFOldSchoolZedsMod.KFBloodPuffOS'
     LowGoreBloodHitClass=Class'KFOldSchoolZedsMod.KFBloodPuffOS'
     BloodGibClass=None
     LowGoreBloodGibClass=Class'KFOldSchoolZedsMod.KFBloodPuffOS'
     LowGoreBloodEmitClass=Class'KFOldSchoolZedsMod.KFBloodPuffOS'
     BloodEmitClass=Class'KFOldSchoolZedsMod.KFBloodPuffOS'
     NoBloodEmitClass=Class'KFOldSchoolZedsMod.KFBloodPuffOS'
     NoBloodHitClass=Class'KFOldSchoolZedsMod.KFBloodPuffOS'
}
