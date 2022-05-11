//Because we want the zeds to extend to KFMonsterOS,
//We'll need to overhaul all class files of each zed, 
//Controllers as well if we count certain Zeds

// Zombie Monster for KF Invasion gametype
class ZombieStalkerOS extends ZombieStalkerBaseOS
    abstract;

// Load all relevant texture, sound, and other packages
#exec OBJ LOAD FILE=KFOldSchoolZeds_Textures.utx
#exec OBJ LOAD FILE=KFOldSchoolZeds_Sounds.uax
#exec OBJ LOAD FILE=KFCharacterModelsOldSchool.ukx

//----------------------------------------------------------------------------
// NOTE: All Variables are declared in the base class to eliminate hitching
//----------------------------------------------------------------------------

//Issues:
//None currently, but we may need to overhaul the Commando
//Spotting to take into account the distance at which a 
//Commando can see a cloaked Stalker. Otherwise, a level 0
//And a level 6 Commando will see the red overlay at the
//Same distance.

//Retail Code we want
simulated event SetAnimAction(name NewAction)
{
    if ( NewAction == 'Claw' || NewAction == MeleeAnims[0] || NewAction == MeleeAnims[1] || NewAction == MeleeAnims[2] )
    {
        UncloakStalker();
    }

    super.SetAnimAction(NewAction);
}

simulated function Tick(float DeltaTime)
{
    //Instead of KFHumanPawn being a variable in base class,
    //It was a local variable here in KFMod, so we'll add it
    Local KFHumanPawn HP;

    Super.Tick(DeltaTime);
    if( Level.NetMode==NM_DedicatedServer )
        Return; // Servers aren't intrested in this info.

    //We want this for zapped effects
    if( bZapped )
    {
        // Make sure we check if we need to be cloaked as soon as the zap wears off
        NextCheckTime = Level.TimeSeconds;
    }
    else if( Level.TimeSeconds > NextCheckTime && Health > 0 )
    {
        NextCheckTime = Level.TimeSeconds + 0.8; //0.5; in retail
        //Old KFMod code
        ForEach VisibleCollidingActors(Class'KFHumanPawn',HP,800,Location)
        {
            if( HP.Health<=0 || !HP.ShowStalkers() ) //!HP.GetVeteran().Static.ShowStalkers()
                continue;

            // If he's a commando, we've been spotted.
            if( !bSpotted )
            {
                bSpotted = True;
                Skins[0] = Finalblend 'KFOldSchoolZeds_Textures.StalkerGlowFB';
                Skins[1] = Finalblend 'KFOldSchoolZeds_Textures.StalkerGlowFB';
            }
            Return;
        }
        // if we're uberbrite, turn down the light
        if( bSpotted )
        {
            bSpotted = False;
            bUnlit = false;
            CloakStalker();
        }
        
        //The rest of this is Retail code, not needed
        //TODO:After consideration, we might need this, least
        //The bit for the StalkerViewDistance for Commandos.
        
        //if( LocalKFHumanPawn != none && LocalKFHumanPawn.Health > 0 && LocalKFHumanPawn.ShowStalkers() &&
        //    VSizeSquared(Location - LocalKFHumanPawn.Location) < LocalKFHumanPawn.GetStalkerViewDistanceMulti() * 640000.0 ) // 640000 = 800 Units
        //{
        //    bSpotted = True;
        //}
        //else
        //{
        //    bSpotted = false;
        //}
    }
}

// Cloak Functions ( called from animation notifies to save Gibby trouble ;) )

simulated function CloakStalker()
{
    // No cloaking if zapped
    if( bZapped )
    {
        return;
    }

    //Stalkers shouldn't glow for Commandos when headless    
    if ( bSpotted && !bDecapitated )
    {
        if( Level.NetMode == NM_DedicatedServer )
            return;
        //Use KFMod textures
        Skins[0] = Finalblend 'KFOldSchoolZeds_Textures.StalkerGlowFB';
        Skins[1] = Finalblend 'KFOldSchoolZeds_Textures.StalkerGlowFB';
        bUnlit = true;
        return;
    }
    //Updated if statement to include !bCloaked, otherwise the 
    //Invisible bitch flickers whenever the function is called
    if ( !bDecapitated && !bCrispified && !bCloaked) // No head, no cloak, honey.  updated :  Being charred means no cloak either :D
    {
        Visibility = 1;
        bCloaked = true;

        if( Level.NetMode == NM_DedicatedServer )
            Return;
        
        //Use KFMod textures
        Skins[0] = Shader 'KFOldSchoolZeds_Textures.StalkerHairShader';
        Skins[1] = Shader 'KFOldSchoolZeds_Textures.StalkerCloakShader';

        // Invisible - no shadow
        if(PlayerShadow != none)
            PlayerShadow.bShadowActive = false;
        if(RealTimeShadow != none)
            RealTimeShadow.Destroy();

        // Remove/disallow projectors on invisible people
        Projectors.Remove(0, Projectors.Length);
        bAcceptsProjectors = false;
        //Use KFMod textures
        SetOverlayMaterial(Material'KFOldSchoolZeds_Textures.StalkerDeCloakfb', 0.25, true);
    }
}

simulated function UnCloakStalker()
{
    if( bZapped )
    {
        return;
    }

    if( !bCrispified )
    {
        //Removed retail variable
        //LastUncloakTime = Level.TimeSeconds;

        Visibility = default.Visibility;
        bCloaked = false;
        bUnlit = false;

        //Keep this voiceline
        // 25% chance of our Enemy saying something about us being invisible
        if( Level.NetMode!=NM_Client && !KFGameType(Level.Game).bDidStalkerInvisibleMessage && FRand()<0.25 && Controller.Enemy!=none &&
         PlayerController(Controller.Enemy.Controller)!=none )
        {
            PlayerController(Controller.Enemy.Controller).Speech('AUTO', 17, "");
            KFGameType(Level.Game).bDidStalkerInvisibleMessage = true;
        }
        if( Level.NetMode == NM_DedicatedServer )
            Return;
            
        Skins[1] = FinalBlend'KFOldSchoolZeds_Textures.StalkerHairFB';
        Skins[0] = Texture'KFOldSchoolZeds_Textures.StalkerSkin';    

        //KFMod Code
        if (PlayerShadow != none)
            PlayerShadow.bShadowActive = true;        

        bAcceptsProjectors = true;
        
        //Use KFMod textures
        SetOverlayMaterial(Material'KFOldSchoolZeds_Textures.StalkerDeCloakfb', 0.25, true);
    }
}

// Set the zed to the zapped behavior
simulated function SetZappedBehavior()
{
    super.SetZappedBehavior();

    bUnlit = false;

    // Handle setting the zed to uncloaked so the zapped overlay works properly
    if( Level.Netmode != NM_DedicatedServer )
    {
        //Use KFMod textures
        Skins[1] = FinalBlend'KFOldSchoolZeds_Textures.StalkerHairFB';
        Skins[0] = Texture'KFOldSchoolZeds_Textures.StalkerSkin';

        if (PlayerShadow != none)
            PlayerShadow.bShadowActive = true;

        bAcceptsProjectors = true;
        SetOverlayMaterial(Material'KFZED_FX_T.Energy.ZED_overlay_Hit_Shdr', 999, true);
    }
}

// Turn off the zapped behavior
simulated function UnSetZappedBehavior()
{
    super.UnSetZappedBehavior();

    // Handle getting the zed back cloaked if need be
    if( Level.Netmode != NM_DedicatedServer )
    {
        NextCheckTime = Level.TimeSeconds;
        SetOverlayMaterial(None, 0.0f, true);
    }
}

// Overridden because we need to handle the overlays differently for zombies that can cloak
function SetZapped(float ZapAmount, Pawn Instigator)
{
    LastZapTime = Level.TimeSeconds;

    if( bZapped )
    {
        TotalZap = ZapThreshold;
        RemainingZap = ZapDuration;
    }
    else
    {
        TotalZap += ZapAmount;

        if( TotalZap >= ZapThreshold )
        {
            RemainingZap = ZapDuration;
              bZapped = true;
        }
    }
    ZappedBy = Instigator;
}

function RemoveHead()
{
    Super.RemoveHead();

    if (!bCrispified)
    {
        //Use KFMod textures
        Skins[1] = FinalBlend'KFOldSchoolZeds_Textures.StalkerHairFB';
        Skins[0] = Texture'KFOldSchoolZeds_Textures.StalkerSkin';
    }
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    Super.PlayDying(DamageType,HitLoc);

    if(bUnlit)
        bUnlit=!bUnlit;

    //Removed Retail Variable
    //LocalKFHumanPawn = none;

    if (!bCrispified)
    {
        //Use KFMod textures
        Skins[1] = FinalBlend'KFOldSchoolZeds_Textures.StalkerHairFB';
        Skins[0] = Texture'KFOldSchoolZeds_Textures.StalkerSkin';
    }
}

//Exactly the same as KFMod, don't touch
// Give her the ability to spring.
function bool DoJump( bool bUpdating )
{
    if ( !bIsCrouched && !bWantsToCrouch && ((Physics == PHYS_Walking) || (Physics == PHYS_Ladder) || (Physics == PHYS_Spider)) )
    {
        if ( Role == ROLE_Authority )
        {
            if ( (Level.Game != None) && (Level.Game.GameDifficulty > 2) )
                MakeNoise(0.1 * Level.Game.GameDifficulty);
            if ( bCountJumps && (Inventory != None) )
                Inventory.OwnerEvent('Jumped');
        }
        if ( Physics == PHYS_Spider )
            Velocity = JumpZ * Floor;
        else if ( Physics == PHYS_Ladder )
            Velocity.Z = 0;
        else if ( bIsWalking )
        {
            Velocity.Z = Default.JumpZ;
            Velocity.X = (Default.JumpZ * 0.6);
        }
        else
        {
            Velocity.Z = JumpZ;
            Velocity.X = (JumpZ * 0.6);
        }
        if ( (Base != None) && !Base.bWorldGeometry )
        {
            Velocity.Z += Base.Velocity.Z;
            Velocity.X += Base.Velocity.X;
        }
        SetPhysics(PHYS_Falling);
        return true;
    }
    return false;
}

//Precache KFMod textures
static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
    myLevel.AddPrecacheMaterial(Shader'KFOldSchoolZeds_Textures.StalkerHairShader');
    myLevel.AddPrecacheMaterial(Shader'KFOldSchoolZeds_Textures.StalkerCloakShader');
    myLevel.AddPrecacheMaterial(Finalblend 'KFOldSchoolZeds_Textures.StalkerGlowFB');
    myLevel.AddPrecacheMaterial(Material'KFOldSchoolZeds_Textures.StalkerDeCloakfb');
    myLevel.AddPrecacheMaterial(Texture'KFOldSchoolZeds_Textures.StalkerSkin');
}

defaultproperties
{
    //-------------------------------------------------------------------------------
    // NOTE: Most Default Properties are set in the base class to eliminate hitching
    //-------------------------------------------------------------------------------
}
