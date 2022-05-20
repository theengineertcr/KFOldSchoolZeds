# To-Do

> Return back to [README](../README.md#documentation)

## Gameplay Tweaks

- [ ] Make Fleshpound Avoid Area's only spawn when enraged and make Avoid Area extend a couple of meters infront of Fleshpounds to make zeds "Clear the way"
  - Currently, Fleshpound Avoid Area has been temporarily removed until this is done.
- [ ] Make Bloat Acid function the same as Retail Bloat as it's buggy.
- [ ] Figure out a way to make Explosive pound projectile speed(and timer) tied to actor distance from player instead of resorting to multiple projectile classes.
- [ ] Substantially increase Explosive Pound health and give 50% explosive resistance and 25% Incendiary Vulnerability
- [ ] Ranged Pounds that have LoS timed out from their attack should fire nearly immediately after making contact with the player.
- [ ] Ranged Pound damage rebalance to be more similar to Husk(excessive damage currently being dealt)
- [ ] Make RangedPound super attack only available on Suicidal+
- [ ] Add option to disable Ranged Pound Super Attack
- [ ] Give a whirring sound when Ranged Pound enters prefire animation so that it's less unexpected. Maybe play a voice line as well?
- [ ] Create an alternative Minigun Pound variant that does not use Incendiary rounds
- [ ] Make Gorefast prefer quicker attack on Suicidal+ while charging
- [ ] Disable collision, hittrace, projblock, etc. on death for zeds
- [ ] Disable Siren scream after death so demos don't kill themselves shooting after a siren dies(bdecapitated return in spawntwoshot)
- [ ] Add additional Siren "explosive block" state in controller similar to Fleshpound Spinstate that causes each explosive within range to explode.
- [ ] Fix Scrake Slow rage.
- [ ] Fix online zeds not using appropriate animation set
   - Mainly an issue with Stalker/Gorefast running slower than in listen server despite being set to use appropriate animation set.
- [ ] Add option in mutator to use old zed values
   - [ ] Damage values
   - [ ] Health values
   - [ ] Speed values
- [ ] Option to turn off health scaling
- [ ] Make Fleshpound and Scrake head lower into body when charging Begin and go back to default when End
- [ ] Make Patty Headshot offset lower when Knockdown or Healing Begin and reset to default when End either state
- [ ] Lower Zed Head Offset when Felldown() and go back to default when Stoodup()

## Bugs
- Zeds have buggier pathing compared to KF zeds for an unknown reason. They get stuck and lost more often.
- Bloat puke can be seen through walls(KFMod issue).
- Projectile weapons such as the Crossbow will not deal headshot damage nor apply headshot multiplier on certain zeds e.g the Fleshpound.
   - What's strange about this is that, the Crossbow WILL deal 1200 damage on headshots, but only apply it on the body.
- Further improve headshot damage.

## Miscellaneous

- [ ] (Vel) Check for compatibility with Scrake [Spin Fix Mut](https://steamcommunity.com/sharedfiles/filedetails/?id=2046199794) (Or other muts e.g. Hard Pat, Texture mods etc... (?))
- [ ] Create HardPat version of Patty toggleable via bEnableHardPat option.
- [ ] Create an Explosive Pound Model with Patriarch's Launcher as well as Scrake's Chainsaw for other hand(harder variant that charges when low on health)

