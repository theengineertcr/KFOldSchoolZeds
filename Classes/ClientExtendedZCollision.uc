// Skell KFPro (c) ✓
class ClientExtendedZCollision extends ExtendedZCollision;

//Usage:
//Makes M14EBR Laser appear properly on Zeds

// We definitely don't want simulated proxies calling take damage on zeds.
function TakeDamage( int Damage, Pawn EventInstigator, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    return;
}