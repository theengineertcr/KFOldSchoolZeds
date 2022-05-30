# To-Do

> return back to [README](../README.md#documentation)

## Gameplay Tweaks

- [ ] Mutator configurations to add:
   - [ ] Restore old Damage and Knockback values(includes disabling extra/less damage from Scrake attacks)
   - [ ] Restore old Health values
   - [ ] Restore old Speed values
   - [ ] Restore old Headshot function
   - [ ] Restore old Charge behavior for charging zeds(individually)
   - [ ] Restore old Scrake behavior
   - [ ] Restore old Bloat Bilebomb and Puke behavior
   - [ ] Restore Old Wave System(if possible)   
   - [ ] Disable player health scaling
   - [ ] Option to enable Hardpat
- [ ] Play minigun whirring sound when Ranged Pound enters prefire animation so that it's less unexpected. Maybe play a voice line as well?
- [ ] Ranged Pounds that have LoS timed out from their attack should fire nearly immediately after making contact with the player.
- [ ] Create an alternative Minigun Pound variant that does not use Incendiary rounds
- [ ] Explosive Pound movement speed increase
- [ ] Explosive Pound to prioritize Attack 1 when charging on Sui+
- [ ] Explosive Pound spawns alongside Fleshpounds
- [ ] Add additional Siren "explosive block" state in controller similar to Fleshpound Spinstate that causes each explosive within range to explode.
- [ ] Redo animation for RangedPreFireMG, removing excessive head shake and point minigun accurately
- [ ] Mirror Scrake melee animation for Explosive Pound(probably never?)
- [ ] Make Fleshpound Avoid Area's only spawn when enraged and make Avoid Area extend a couple of meters infront of Fleshpounds to make zeds "Clear the way"
  - Currently, Fleshpound Avoid Area has been temporarily removed until this is done.
- [ ] Disable collision, hittrace, projblock, etc. on death for all zeds
- [ ] Give Zed Models a "Head attach" and reimport all models + animation sets
- [ ] Make Patty Headshot offset lower when Knockdown or Healing Begin and reset to default when End either state
- [ ] Lower Zed Head Offset when Felldown() and go back to default when Stoodup()
- [ ] Fix Scrake Slow rage.

## Bugs
- Despite modifying OnlineHeadShot Z offset to lower when zed is charging, it does not seem to work online.
- Bloat Puke Damtype bugs out Bilebomb and puking generally for an unknown reasson
- Bloat puke can be seen through walls(KFMod issue).
- Blood Trails on gibs no longer work
 - Temporarily replaced with KF1 Blood trails

## Miscellaneous

- [ ] (Vel) Check for compatibility with Scrake [Spin Fix Mut](https://steamcommunity.com/sharedfiles/filedetails/?id=2046199794) (Or other muts e.g. Hard Pat, Texture mods etc... (?))
- [ ] Create HardPat version of Patty toggleable via bEnableHardPat option.
