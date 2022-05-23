// ✔
// A group of gibs, how nice. Make sure this class
// Uses all of the KFMod Gibs and Blood puffs
class KFHumanGibGroupOS extends xPawnGibGroup;

defaultproperties
{
     //KFMod Gibs
     Gibs(0)=class'KFGibHeadOS'
     Gibs(1)=class'KFGibHeadbOS'
     Gibs(2)=class'KFGibHeadOS'
     Gibs(3)=class'KFGibHeadbOS'
     Gibs(4)=class'KFGibHeadOS'
     Gibs(5)=class'KFGibHeadOS'
     Gibs(6)=class'KFGibHeadbOS'
     Gibs(7)=class'KFGibHeadOS'

     //KFMod Blood Puffs
     BloodHitClass=class'KFBloodPuffOS'
     LowGoreBloodHitClass=class'KFBloodPuffOS'
     BloodGibClass=none
     LowGoreBloodGibClass=class'KFBloodPuffOS'
     LowGoreBloodEmitClass=class'KFBloodPuffOS'
     BloodEmitClass=class'KFBloodPuffOS'
     NoBloodEmitClass=class'KFBloodPuffOS'
     NoBloodHitClass=class'KFBloodPuffOS'
}