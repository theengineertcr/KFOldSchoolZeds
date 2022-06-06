//Controller class for Crawler ✓
class ControllerCrawlerOS extends KFMonsterControllerOS;

var    float   LastPounceTime;
var    bool    bDoneSpottedCheck;
var    bool    bEnableOldCrawlerBehaviour;

state ZombieHunt
{
    event SeePlayer(Pawn SeenPlayer)
    {
        if ( !bDoneSpottedCheck && PlayerController(SeenPlayer.Controller) != none )
        {
            if ( !KFGameType(Level.Game).bDidSpottedCrawlerMessage && FRand() < 0.25 )
            {
                PlayerController(SeenPlayer.Controller).Speech('AUTO', 18, "");
                KFGameType(Level.Game).bDidSpottedCrawlerMessage = true;
            }

            bDoneSpottedCheck = true;
        }

        super.SeePlayer(SeenPlayer);
    }
}

function bool IsInPounceDist(actor PTarget)
{
    local vector DistVec;
    local float time;

    local float HeightMoved;
    local float EndHeight;

    DistVec = pawn.location - PTarget.location;
    DistVec.Z=0;

    time = vsize(DistVec)/ZombieCrawlerOS(pawn).PounceSpeed;

    HeightMoved = Pawn.JumpZ*time + 0.5 * pawn.PhysicsVolume.Gravity.z * time * time;

    EndHeight = pawn.Location.z +HeightMoved;

    if((abs(EndHeight - PTarget.Location.Z)     < Pawn.CollisionHeight + PTarget.CollisionHeight) &&
        VSize(pawn.Location - PTarget.Location) < KFMonster(pawn).MeleeRange    *     5         )
        return true;
    else
        return false;
}

function bool FireWeaponAt(Actor A)
{
    local vector aFacing,aToB;
    local float RelativeDir;

    if ( A == none )
        A = Enemy;
    if ( (A == none) || (Focus != A) )
        return false;

    if(CanAttack(A))
    {
        Target = A;
        Monster(Pawn).RangedAttack(Target);
    }
    else
    {
        if(LastPounceTime +             1           < Level.TimeSeconds &&  bEnableOldCrawlerBehaviour ||
           LastPounceTime + (4.5 - (FRand() * 3.0)) < Level.TimeSeconds && !bEnableOldCrawlerBehaviour)
        {
            aFacing=Normal(Vector(Pawn.Rotation));

            aToB=A.Location-Pawn.Location;

            RelativeDir = aFacing dot aToB;

            if ( RelativeDir > 0.85 )
            {
                if(IsInPounceDist(A) )
                {
                    if(ZombieCrawlerOS(Pawn).DoPounce()==true )
                        LastPounceTime = Level.TimeSeconds;
                }
            }
        }
    }
    return false;
}

function bool NotifyLanded(vector HitNormal)
{
    if( ZombieCrawlerOS(pawn).bPouncing )
    {
        GotoState('hunting');
        return false;
    }
    else
        return super.NotifyLanded(HitNormal);
}

defaultproperties{}