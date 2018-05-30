																		/************************************************************************
																				  Made by Loki611 (http://steamcommunity.com/id/Loki611)
																		***************************************************************************/

AddCSLuaFile();

REVIVAL = {};
DMG_SUICIDE = 6144; // There is no suicide damage type.

ALERT_VISUAL = 1881;
ALERT_CHAT = 1882;
ALERT_SOUND = 1883;

hook.Add("PostGamemodeLoaded", "revival_reloadConfig", function()
	include("revival_config.lua");
end)

if(SERVER)then
	util.AddNetworkString("revival_revive_menu");
	util.AddNetworkString("revival_revive_accept");
	util.AddNetworkString("revival_revive_deny");
	util.AddNetworkString("revival_revive_gottarget");
	util.AddNetworkString("revival_revive_misstarget");
	util.AddNetworkString("revival_revive_alerted");

	AddCSLuaFile("revival_config.lua");
	AddCSLuaFile("revival/revivemenu.lua");
	AddCSLuaFile("revival/hudelements.lua");
	AddCSLuaFile("revival/mainfuncs.lua");
	AddCSLuaFile("revival/meta.lua");
	
	include("revival_config.lua");
	include("revival/meta.lua");
	include("revival/mainfuncs.lua");
	include("revival/hooks.lua");
	include("revival/nets.lua");
elseif(CLIENT)then
	include("revival_config.lua");
	include("revival/mainfuncs.lua");
	include("revival/meta.lua");
	include("revival/revivemenu.lua");
	include("revival/hudelements.lua");
end
