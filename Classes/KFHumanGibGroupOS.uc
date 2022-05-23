// ✔
// A group of gibs, how nice. Make sure this class
// Uses all of the KFMod Gibs and Blood puffs
class KFHumanGibGroupOS extends xPawnGibGroup;

defaultproperties
{
     //KFMod Gibs
     Gibs(0)=Class'KFGibHeadOS'
     Gibs(1)=Class'KFGibHeadbOS'
     Gibs(2)=Class'KFGibHeadOS'
     Gibs(3)=Class'KFGibHeadbOS'
     Gibs(4)=Class'KFGibHeadOS'
     Gibs(5)=Class'KFGibHeadOS'
     Gibs(6)=Class'KFGibHeadbOS'
     Gibs(7)=Class'KFGibHeadOS'

     //KFMod Blood Puffs
     BloodHitClass=Class'KFBloodPuffOS'
     LowGoreBloodHitClass=Class'KFBloodPuffOS'
     BloodGibClass=None
     LowGoreBloodGibClass=Class'KFBloodPuffOS'
     LowGoreBloodEmitClass=Class'KFBloodPuffOS'
     BloodEmitClass=Class'KFBloodPuffOS'
     NoBloodEmitClass=Class'KFBloodPuffOS'
     NoBloodHitClass=Class'KFBloodPuffOS'
}