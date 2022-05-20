// ✔
// A group of gibs, how nice. Make sure this class  
// Uses all of the KFMod Gibs and Blood puffs
class KFHumanGibGroupOS extends xPawnGibGroup;

defaultproperties
{
     //KFMod Gibs
     Gibs(0)=Class'KFOldSchoolZeds.KFGibHeadOS'
     Gibs(1)=Class'KFOldSchoolZeds.KFGibHeadbOS'
     Gibs(2)=Class'KFOldSchoolZeds.KFGibHeadOS'
     Gibs(3)=Class'KFOldSchoolZeds.KFGibHeadbOS'
     Gibs(4)=Class'KFOldSchoolZeds.KFGibHeadOS'
     Gibs(5)=Class'KFOldSchoolZeds.KFGibHeadOS'
     Gibs(6)=Class'KFOldSchoolZeds.KFGibHeadbOS'
     Gibs(7)=Class'KFOldSchoolZeds.KFGibHeadOS'
     
     //KFMod Blood Puffs
     BloodHitClass=Class'KFOldSchoolZeds.KFBloodPuffOS'
     LowGoreBloodHitClass=Class'KFOldSchoolZeds.KFBloodPuffOS'
     BloodGibClass=None
     LowGoreBloodGibClass=Class'KFOldSchoolZeds.KFBloodPuffOS'
     LowGoreBloodEmitClass=Class'KFOldSchoolZeds.KFBloodPuffOS'
     BloodEmitClass=Class'KFOldSchoolZeds.KFBloodPuffOS'
     NoBloodEmitClass=Class'KFOldSchoolZeds.KFBloodPuffOS'
     NoBloodHitClass=Class'KFOldSchoolZeds.KFBloodPuffOS'
}
