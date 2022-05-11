# Gameplay Tweaks

- Scrake melee attack 1 should be preferred when raged on Suicidal+
   - Attack 1 to deal less damage(20%?) as its faster and hits twice in quick succession
   - Attack 2 to deal a bit more damage(10-15%?) as it hits a 5 frames slower compared to Attack 1
 - Clot to use clawing animations on door instead of grappling
 - Review each Zed's door attack behavior in general to make sure they're using the correct animation
 - Prevent zeds from turning their whole body to face the player when knocked down(turn off targetting?)
 - Make Fleshpound Avoid Area's only spawn when enraged.

# Bugs

- FleshPound dealing continuous damage post-rage(online?) https://www.youtube.com/watch?v=ItSdKJu7KXE - Potentially to do with a Vanilla Fleshpound bug where the Fleshpound stands aimlessly next to a player without attempting to melee them. In this case, however, the Fleshpound's melee distance is so short that He gets close enough to the player to bump into and obliterate them. Fix: Increase melee range?
- Zeds do not play TakeHit animations, possibly because of OldPlayHit being commented out?
   - Review KFMonster and KFMonsterOS
- Zeds have buggier pathing compared to KF zeds for an unknown reason. Reevalaute individual zed classes and Controller class.

# Miscellaneous

- Rename all zed names to to "Zed Name 2.5"
- Meleestun/Hit animation immunity during knockdown(they're knocked on their ass so they shouldn't suddenly stand up and start moving around)
- Format all code into proper 4x indentations for better Github readability
- Check for compatibility with Scrake [Spin Fix Mut](https://steamcommunity.com/sharedfiles/filedetails/?id=2046199794) (Or other muts e.g. Hard Pat, Texture mods etc... (?))
