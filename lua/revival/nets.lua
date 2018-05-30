																		/************************************************************************
																				  Made by Loki611 (http://steamcommunity.com/id/Loki611)
																		***************************************************************************/

net.Receive("revival_revive_accept", function(len, cli)
	local forceRespawn = net.ReadBool() || false;
	REVIVAL.revivePlayer(cli, forceRespawn);
end)

net.Receive("revival_revive_deny", function(len, cli)
	if(cli.playerCorpse != nil)then
		cli.playerCorpse.hasBeenRevived = false;
		cli.playerCorpse:SetNWBool("hasBeenRevived", false);
	end
end)

net.Receive("revival_revive_alerted", function(len, cli)

end)

net.Receive("revival_revive_gottarget", function(len, pl)
	if(pl.lastUseCorpse && !pl.lastUseCorpse.hasBeenRevived)then
		pl:SetNWInt("revival_Compressions", pl:GetNWInt("revival_Compressions", 0) + 1);
	end
end)

net.Receive("revival_revive_misstarget", function(len, pl)
	pl:SetNWInt("revival_Compressions", 0);
end)