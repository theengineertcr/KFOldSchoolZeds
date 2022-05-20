# To-Do

> Return back to [README](../README.md#documentation)

## Gameplay Tweaks

- [ ] Make Fleshpound Avoid Area's only spawn when enraged and make Avoid Area extend a couple of meters infront of Fleshpounds to make zeds "Clear the way"
  - Currently, Fleshpound Avoid Area has been temporarily removed until this is done.
- [ ] Bloat acid stays for far too long, make it go away earlier.
- [ ] Give a whirring sound when Ranged Pound enters prefire animation so that it's less unexpected. Maybe add a voice line as well?
- [ ] Make Gorefast prefer quicker attack on Suicidal+ while charging
- [ ] Make RangedPound super attack only available on Suicidal+
- [ ] Substantially increase Explosive Pound health and give explosive resistance
- [ ] Create an alternative Minigun Pound variant that does not use Incendiary rounds
- [ ] Figure out a way to make Explosive pound projectile speed(and timer) tied to actor distance from player instead of resorting to multiple projectile classes.
- [ ] Ranged Pounds that have timed out from their attack should fire immediately after making contact with the player.
- [ ] Add option in mutator to use old zed values(zed selectable).

## Bugs
- Zeds have buggier pathing compared to KF zeds for an unknown reason. They get stuck and lost more often.
- Bloat puke can be seen through walls(KFMod issue).
- Projectile weapons such as the Crossbow will not deal headshot damage nor apply headshot multiplier on certain zeds e.g the Fleshpound.
   - What's strange about this is that, the Crossbow WILL deal 1200 damage on headshots, but only apply it on the body.

## Miscellaneous

- [ ] (Vel) Check for compatibility with Scrake [Spin Fix Mut](https://steamcommunity.com/sharedfiles/filedetails/?id=2046199794) (Or other muts e.g. Hard Pat, Texture mods etc... (?))
- [ ] Create HardPat version of Patty toggleable via bEnableHardPat option.
- [ ] Create an Explosive Pound Model with Patriarch's Launcher as well as Scrake's Chainsaw for other hand(harder variant that charges when low on health)

<!-- Move this to Changelog! TODO: 5/20/2022 evening, when I'm not tired -->
### Finished / Fixed
- [x] RangedPound no longer skips Prefire anim whilst playing hurt anims.
- [x] Fleshpound no longer uses attack 3 due to animations not playing online and dealing obscene amounts of damage from SpinState
- [x] All Zeds use dedicated hitboxes offline due to them being improperly offset for certain zeds e.g RangedPound.
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
