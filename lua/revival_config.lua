/******************
	Revival Core
*******************/
REVIVAL.reviveAtDeath = true; // Should revived players respawn where they died(true) or use normal spawning(false)?
REVIVAL.newSpawnOption = true; // Should a respawn option be avaliable to the user, on the revive menu, even if reviveAtDeath is enabled? (Note: This is automatically disabled if reviveAtDeath is disabled)
REVIVAL.canDragBodies = true; // Should users be able to drag corpses around?
REVIVAL.skeletonOnDeath = false; // Should the players corpse be a skeleton?
REVIVAL.deathScreenEffect = true; // Should the death screen effect be active?
REVIVAL.showRespawnText = true; // Should the respawn time and text be displayed?
REVIVAL.showReviveMessage = true; // When a player is revived, should they say something?
REVIVAL.removeBodyOnTime = false; // Should the corpse be removed as soon as the death timer is over (true) or should it remain there until the user respawns(false)?
REVIVAL.canSeeBodyInfo = true; // Do you want users to be able to see body information when they look at corpses.
REVIVAL.respawnBabygod = true; // Should a revived player respawn with default babygod setting? (DarkRP only)
REVIVAL.forceRevivalAccept = false; // Should a revived player be forcefully respawned without using the menu?
REVIVAL.useTeamWhitelist = false; // Should only the whitelisted teams be allowed to perform cpr?

REVIVAL.revivalChance = 100; // What percentage chance should a user have to successfully accept a revive?
REVIVAL.revivalFailedTextTime = 8; // How many seconds should the Revival failed text be shown for?
REVIVAL.reviveRange = 100; // How far away should you be able to perform CPR on bodies from?
REVIVAL.dragLength = 7; // How long, in seconds, should you be able to drag bodies?
REVIVAL.compressionCount = 1; // How many chest compressions does it take to revive someone?
REVIVAL.respawnTime = 15; // How many seconds before a user can respawn? (Unless overriden below)
REVIVAL.deathForce = 5; // How much to multiply the players velocity by when they die? Higher = body will fling further on death

REVIVAL.medkitRange = 80; // How far can the medkit heal from?
REVIVAL.medkitRate = 0.1; // How quickly(in seconds) should the mekit give health to the player?
REVIVAL.medkitHealth = 1; // How much health per heal should the medkit give?

REVIVAL.defibRange = 255; // How far should the Defibrillator be able to reach.
REVIVAL.defibRecharge = 40; // How long should it take the Defibrillator to recharge?
REVIVAL.defibRechargeMessage = "Recharging.. {TIME} left"; // What should it tell the user while the Defibrillator is still charging? {TIME} will be replaced with the remaning time.
REVIVAL.defibChargedMessage = "Charge ready!"; // What should it tell the user when the Defibrillator is charged?

REVIVAL.CPRFinished = "I think he's alive."; // When someone finishes CPR on someone what should it say?
REVIVAL.CPRSuccess = "CPR Successful!"; // The message to use when user successfully complete 1 chest compression.
REVIVAL.revivalFailedText = "REVIVAL FAILED"; // The message to use when user successfully complete 1 chest compression.
REVIVAL.helpText = "Hold E to drag the corpse."; // When a user presses E on a corpse what information should be given? (Note: Using {PLAYERNAME} will work here)
REVIVAL.reviveMessage = "I'm alive!"; // If the revive messsage is shown, what should it say?
REVIVAL.respawnTextFont = "REVIVAL_RespawnFont"; // What font should the respawn text use?
REVIVAL.respawnTimeFont = "REVIVAL_RespawnFont"; // What font should the respawn time text use?
REVIVAL.revivalFailedTextFont = "REVIVAL_FailedFont"; // What font should the revival failed text use?
REVIVAL.respawnText = "Respawning"; // What text should be above the time while the user is dead?
REVIVAL.respawnAfterTimeText = "Respawn"; // What text should be above the time after the timer is over?
REVIVAL.respawnTimeText = "{TIME}"; // What text the time be? {TIME} = Remaning respawn time.

REVIVAL.respawnTextColor = Color(255, 255, 255); // The color of respawn text.
REVIVAL.respawnTimeColor = Color(255, 255, 255); // The color of the respawn time text.
REVIVAL.deathScreenColor = Color(200, 0, 0); // The color of the death screen.
REVIVAL.revivalFailedFlash = Color(200, 0, 0); // The color of the flashing revival failed text.

REVIVAL.customRespawnTimes = { // Depending on what type of damage, how long, in seconds, should respawn time be? Damage type: https://wiki.garrysmod.com/page/Enums/DMG  (Note: DMG_SUICIDE is custom)
	[DMG_SUICIDE] = 5,
	[DMG_FALL] = 10,
}


REVIVAL.teamWhitelist = { // What teams should be allowed to perform cpr?
	TEAM_MEDIC,
	TEAM_PARAMEDIC
}

/******************
 Revival CPR Menu
*******************/
REVIVAL.arrowSpeed = 40;

REVIVAL.arrowColor = Color(255, 0, 0);
REVIVAL.arrowTargetColor = Color(0, 255, 255);
REVIVAL.backBarColor = Color(0, 0, 0);
REVIVAL.comprssionBarColor = Color(200, 0, 200);
REVIVAL.comprssionBarBackColor = Color(0, 0, 0);


/******************
   Revival Menu
*******************/
REVIVAL.title = "Revival Menu"; // The title of the revival menu.
REVIVAL.acceptText = "Accept"; // What should the agree to be revived button say?
REVIVAL.denyText = "Deny"; // What should the deny to be revived button say?
REVIVAL.respawnText = "Respawn"; // If newSpawnOption is enabled what should the text be on the respawn button?
REVIVAL.actionText = "{PLAYERNAME} wishes to revive you?"; // What should the revival menu ask when your being revived? {PLAYERNAME} will be replaced with the players name.
REVIVAL.buttonFont = "REVIVAL_MenuFont"; // What font should the buttons use?
REVIVAL.titleFont = "REVIVAL_MenuTitleFont"; // What font should the title use?
REVIVAL.actionFont = "REVIVAL_MenuTitleFont"; // What font should the action text use?

REVIVAL.menuColor = Color(58, 58, 58, 200); // Color of the entire revival menu.
REVIVAL.titleTextColor = Color(255, 255, 255); // Color of the revival menu's title text.
REVIVAL.actionTextColor = Color(255, 255, 255); // Color of the revival menu's action text.
REVIVAL.acceptTextColor = Color(255, 255, 255); // Color of the revival menu's accept text.
REVIVAL.acceptButtonColor = Color(60, 200, 60); // Color of the revival menu's accept button.
REVIVAL.denyTextColor = Color(255, 255, 255); // Color of the revival menu's deny text.
REVIVAL.denyButtonColor = Color(200, 60, 60); // Color of the revival menu's deny button.

REVIVAL.menuWidth = 25; // What percentage of the screen should the menus width take up?
REVIVAL.menuHeight = 22; // What percentage of the screen should the menu height take up?

/******************
  Revival Murder
*******************/
//(Note: This is only used for the Murder gamemode. Requested by: azuspl)
REVIVAL.shouldUseMurderSetting = false; // If you are using the Murder gamemode and want these additonal features set this to true.
REVIVAL.showDeathEffectWhileSpectating = false; // Do you want the death effect set above to be displayed while a user is dead and spectating?
REVIVAL.lootCost = 10; // How much loot must a player have to revive a body?
REVIVAL.notEnoughLootText = "Not enough loot!"; // What text should display above a corpse if a user doesn't have enough loot?
REVIVAL.notEnoughLootTextFont = "REVIVAL_NotEnoughLootFont"; // What font should the not enough loot text use?
REVIVAL.notEnoughLootTextColor = Color(125, 200, 50); // What color should the not enough loot text use?

/******************
 Revival Additions
*******************/
REVIVAL.costToRespawn = 0; // How much should it cost to accept a revive from someone? (This is only used for DarkRP)
REVIVAL.pointsToRespawn = 0; // How many points should it cost to accept a revive from someone? (This is only used for Pointshop or Pointshop 2)

/******************
   Revival Hooks
********************
Revival_OnRespawnTime:
  Realm:
	Serverside
  Desc:
    Called when calculating the respawn time. Returning a number will add it to the respawn time.
  Ex:
	// This will always ADD 5 seconds to a users respawn time.
	hook.Add("Revival_OnRespawnTime", "Hook ID", function(player, curRespawnTime)
		return 5;
	end)

Revival_OnCorpseMade:
  Realm:
	Serverside
  Desc:
    Called right after the player has died and the corpse is made.
  Ex:
	hook.Add("Revival_OnCorpseMade", "Hook ID", function(player, corpse, respawnTime)
		
	end)

	
	
	
WARNING: THIS PART IS STILL IN DEVELOPMENT. DON'T USE IT!!!!!
/******************
   Revival Alert 
*******************/
REVIVAL.alertHelpText = "Hit 'E' to call for help.";
REVIVAL.alertKey = KEY_E;

REVIVAL.alertFlashColor = Color(200, 0, 0); // What color should the text above dead bodies flash?

REVIVAL.alertedTeams = { // List of jobs that can be alerted when a user request help.
	//[TEAM_CITIZEN] = true,
	//TEAM_DOCTOR, // Remove the first "//" to enable this team.
}

REVIVAL.alertedTypes = { // List of alerts that will be sent. 
	//[ALERT_CHAT] = true, // Sends a alert message in chat box.
	//[ALERT_SOUND] = true, // Plays a alert sound.
	//[ALERT_VISUAL] = true, // Draws flashing text above dead corspses.
}
