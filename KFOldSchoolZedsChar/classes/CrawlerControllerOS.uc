//This doesn't need much changes
//At least I don't think so?
class CrawlerControllerOS extends KFMonsterControllerOS;

var	float	LastPounceTime;
var	bool	bDoneSpottedCheck; //Need this for voicelines to play

state ZombieHunt
{
	event SeePlayer(Pawn SeenPlayer)
	{
		if ( !bDoneSpottedCheck && PlayerController(SeenPlayer.Controller) != none )
		{
			// 25% chance of first player to see this Crawler saying something
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

  //work out time needed to reach target

  DistVec = pawn.location - PTarget.location;
  DistVec.Z=0;

  time = vsize(DistVec)/ZombieCrawlerOS(pawn).PounceSpeed; //ZombieCrawler to ZombieCrawlerOS

  // vertical change in that time

  //assumes downward grav only
  HeightMoved = Pawn.JumpZ*time + 0.5*pawn.PhysicsVolume.Gravity.z*time*time;

  EndHeight = pawn.Location.z +HeightMoved;

  //log(Vsize(Pawn.Location - PTarget.Location));


  if((abs(EndHeight - PTarget.Location.Z) < Pawn.CollisionHeight + PTarget.CollisionHeight) &&
  VSize(pawn.Location - PTarget.Location) < KFMonster(pawn).MeleeRange * 5)
    return true;
  else
    return false;
}

function bool FireWeaponAt(Actor A)
{
	local vector aFacing,aToB;
	local float RelativeDir;
	//Were bringing back this old KFMod variable
	//local rotator newrot;
	
    if ( A == None )
		A = Enemy;
	if ( (A == None) || (Focus != A) )
		return false;

	if(CanAttack(A))
    {
	  Target = A;
	  Monster(Pawn).RangedAttack(Target);
    }
    else
    {
        //TODO - base off land time rather than launch time?
        if((LastPounceTime + (4.5 - (FRand() * 3.0))) < Level.TimeSeconds )
        {
            aFacing=Normal(Vector(Pawn.Rotation));
            // Get the vector from A to B
            aToB=A.Location-Pawn.Location;

            RelativeDir = aFacing dot aToB;
            if ( RelativeDir > 0.85 )
            {
                //Facing enemy
                if(IsInPounceDist(A) )
                {
                    if(ZombieCrawlerOS(Pawn).DoPounce()==true ) //ZombieCrawler to ZombieCrawlerOS
                        LastPounceTime = Level.TimeSeconds;
                }
				//Old KFMod code were bringing back for newrot
				//Bad idea, it spins them around like crazy
	            //else
				//{
				//	//TODO: if the DoPounce borks, undo rot change?
				//	//      or can we guarantee no borkage?
				//	if(frand() < 0.5 )
				//		newrot = pawn.Rotation + rot(0, 10920,0);//8190,0);
				//	else
				//		newrot = pawn.Rotation + rot(0,54616,0); // 57346,0);
				//	pawn.SetRotation( newrot );
				//	if(ZombieCrawlerOS(Pawn).DoPounce()==true ) //ZombieCrawler to ZombieCrawlerOS
				//		LastPounceTime = Level.TimeSeconds;
				//}			
            }
        }
    }
    return false;
}

function bool NotifyLanded(vector HitNormal)
{
  if( ZombieCrawlerOS(pawn).bPouncing ) //ZombieCrawler to ZombieCrawlerOS
  {
     // restart pathfinding from landing location
     GotoState('hunting');
     return false;
  }
  else
    return super.NotifyLanded(HitNormal);
}

defaultproperties
{
}
