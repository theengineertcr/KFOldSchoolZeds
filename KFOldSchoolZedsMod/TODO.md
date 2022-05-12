# Gameplay Tweaks
 - Make Fleshpound Avoid Area's only spawn when enraged and make Avoid Area extend a couple of meters infront of Fleshpounds to make zeds "Clear the way" 
   - Currently, Fleshpound Avoid Area has been temporarily removed until this is done.

# Bugs
- FleshPound dealing continuous damage post-rage(online?) https://www.youtube.com/watch?v=ItSdKJu7KXE 
    - Potentially to do with a Vanilla Fleshpound bug where the Fleshpound stands aimlessly next to a player without attempting to melee them. In this case, however, the Fleshpound's melee distance is so short that He gets close enough to the player to bump into and obliterate them. Fix: Increase melee range?
- Zeds have buggier pathing compared to KF zeds for an unknown reason(Seen around KF-Offices typical hallway camp spot)


# Miscellaneous
- Check for compatibility with Scrake [Spin Fix Mut](https://steamcommunity.com/sharedfiles/filedetails/?id=2046199794) (Or other muts e.g. Hard Pat, Texture mods etc... (?))

## Finished / Fixed
- Prevent zeds from turning their whole body to face the player when knocked down(turn off targetting?)
- Fleshpound Chaingunner no longer skips stun animation
- Fix implemented for Chaingunner skipping Firing end animations
- Clot to use clawing animations on door instead of grappling
- Gorefast no longer stops charging after a short while of being in his charge state
- HitAnim immunity to be ignored while zed is melee attacking the player
- Scrake melee attack 1 should be preferred when raged on Suicidal+
  - Attack 1 deals 15% less damage as its faster and hits twice in quick succession
  - Attack 2 deals 15% more damage as it hits a 5 frames slower compared to Attack 1
- Zeds not playing TakeHit animations
- Rename all zed names to to "Zed Name 2.5"
- Hitanimation immunity while knocked down
- Format all code into proper 4x indentations for better Github readability
