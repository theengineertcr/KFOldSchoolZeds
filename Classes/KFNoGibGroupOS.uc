//A gib group with no gibs, but there's plenty of blood!
class KFNoGibGroupOS extends xPawnGibGroup;

defaultproperties
{
     Gibs(0)=None
     Gibs(1)=None
     Gibs(2)=None
     Gibs(3)=None
     Gibs(4)=None
     Gibs(5)=None
     BloodHitClass=Class'KFBloodPuffOS'
     LowGoreBloodHitClass=Class'KFBloodPuffOS'
     BloodGibClass=None
     LowGoreBloodGibClass=Class'KFBloodPuffOS'
     LowGoreBloodEmitClass=Class'KFBloodPuffOS'
     BloodEmitClass=Class'KFBloodPuffOS'
     NoBloodEmitClass=Class'KFBloodPuffOS'
     NoBloodHitClass=Class'KFBloodPuffOS'
}
