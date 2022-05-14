# To-Do

> Return back to [README](../README.md#documentation)

## Gameplay Tweaks

- [ ] Make Fleshpound Avoid Area's only spawn when enraged and make Avoid Area extend a couple of meters infront of Fleshpounds to make zeds "Clear the way"
  - Currently, Fleshpound Avoid Area has been temporarily removed until this is done.
- [ ] Fleshpound / Ranged Pound head hitboxes too generous
- [ ] Bloat acid stays for far too long, make it go away earlier.

## Bugs

- FleshPound dealing continuous damage post-rage(online?) <https://www.youtube.com/watch?v=ItSdKJu7KXE>
  - Attempted fix is now in place.
  - May have to do with the Spin Damage? Maybe temporarily disable attack 3 to see if that's the case?(Done)
- Zeds have buggier pathing compared to KF zeds for an unknown reason(Seen around KF-Offices typical hallway camp spot)
- Many Zed head hitboxes (local & online) are broken/don't work properly.
- Bloat puke can be seen through walls(KFMod code issues).

## Miscellaneous

- [ ] Check for compatibility with Scrake [Spin Fix Mut](https://steamcommunity.com/sharedfiles/filedetails/?id=2046199794) (Or other muts e.g. Hard Pat, Texture mods etc... (?))

<!-- Move this to Changelog! -->
### Finished / Fixed

- [x] Fleshpound deals less damage on Spin attack
- [x] Zeds no longer turn their body while knocked down
- [x] Fleshpound Chaingunner no longer skips stun animation
- [x] Potential fix implemented for Chaingunner skipping Firing end animations
- [x] Clot uses clawing animations on door instead of grappling
- [x] Gorefast no longer stops charging after a short while of being in his charge state
- [x] Scrake's prefer to use their faster sawing attack(attack 1) when enraged on Suicidal+
  - Attack 1 deals 15% less damage as it's faster and hits twice in quick succession
  - Attack 2 deals 15% more damage as it hits a 5 frames slower compared to Attack 1
- [x] Zeds will now play hurt anims even whilst melee attacking
- [x] Zeds no longer play hurt animations while knocked down
- [x] Zeds now play TakeHit animations
- [x] All zeds menunames renamed to "Zed Name 2.5"
- [x] All code formatted into 4x indentations
