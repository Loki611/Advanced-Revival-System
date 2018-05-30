																		/************************************************************************
																				  Made by Loki611 (http://steamcommunity.com/id/Loki611)
																		***************************************************************************/


surface.CreateFont("REVIVAL_MenuFont", {
	font = "Arial",
	size = ScreenScale(8),
	weight = 600
})

surface.CreateFont("REVIVAL_MenuTitleFont", {
	font = "Arial",
	size = ScreenScale(11),
	weight = 800
})

net.Receive("revival_revive_menu", function()
	local reviver = net.ReadEntity();
	
	local menuW = REVIVAL.getSetting("menuWidth", 17);
	local menuH = REVIVAL.getSetting("menuHeight", 17);
	local window = vgui.Create("DFrame");
	window:SetSize(ScrW() * (menuW / 100), ScrH() * (menuH / 100));
	window:SetTitle("");
	window:Center();
	window:SetVisible(true);
	window:MakePopup();
	window:ShowCloseButton(false);
	window.Paint = function(p, w, h)
		draw.RoundedBox(4, 0, 0, w, h, REVIVAL.getSetting("menuColor", Color(58, 58, 58, 200)));
		draw.SimpleText(REVIVAL.getSetting("title", "Revival Menu"), REVIVAL.getSetting("titleFont", "REVIVAL_MenuTitleFont"), w/2, h / 200, REVIVAL.getSetting("titleTextColor", Color(255, 255, 255)), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP);
	end
	
	local actionText = vgui.Create("DTextEntry", window);
	actionText:SetText(string.Replace(REVIVAL.getSetting("actionText", ""), "{PLAYERNAME}", (reviver:Nick() || "")));
	actionText:SetPos(0, window:GetTall() / 4);
	actionText:SetFont(REVIVAL.getSetting("titleFont", "REVIVAL_MenuTitleFont"));
	actionText:SetSize(window:GetWide() / 1.1, window:GetTall() / 3.5);
	actionText:SetMultiline(true);
	actionText:SetEditable(false);
	actionText:CenterHorizontal();
	actionText:SetDrawBackground(false);
	actionText:SetTextColor(REVIVAL.getSetting("actionTextColor", Color(255, 255, 255)));	
	
	local paddingW = window:GetWide() / 25;
	local paddingH = window:GetTall() / 35;
	local accept = vgui.Create("DButton", window);
	accept:SetText("");
	accept:SetSize(window:GetWide() / 2.3, window:GetTall() / 6);
	accept:SetPos(paddingW, window:GetTall() - accept:GetTall() - paddingH);
	accept.DoClick = function()
		net.Start("revival_revive_accept");
		net.SendToServer();
		
		window:Close();
	end
	accept.Paint = function(p, w, h)
		draw.RoundedBox(4, 0, 0, w, h, REVIVAL.getSetting("acceptButtonColor", Color(60, 200, 60, 255)));
		draw.SimpleText(REVIVAL.getSetting("acceptText", "Accept"), REVIVAL.getSetting("buttonFont", "REVIVAL_MenuFont"), w/2, h/2, REVIVAL.getSetting("acceptTextColor", Color(255, 255, 255)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
	end
	
	local deny = vgui.Create("DButton", window);
	deny:SetText("");
	deny:SetSize(window:GetWide() / 2.3, window:GetTall() / 6);
	deny:SetPos(window:GetWide() - deny:GetWide() - paddingW, window:GetTall() - deny:GetTall() - paddingH);
	deny.DoClick = function()
		net.Start("revival_revive_deny");
		net.SendToServer();
	
		window:Close();
	end
	deny.Paint = function(p, w, h)
		draw.RoundedBox(4, 0, 0, w, h, REVIVAL.getSetting("denyButtonColor", Color(200, 60, 60, 255)));
		draw.SimpleText(REVIVAL.getSetting("denyText", "Deny"), REVIVAL.getSetting("buttonFont", "REVIVAL_MenuFont"), w/2, h/2, REVIVAL.getSetting("denyTextColor", Color(255, 255, 255)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
	end
	
	if(REVIVAL.getSetting("reviveAtDeath", false) && REVIVAL.getSetting("newSpawnOption", false))then
		local respawn = vgui.Create("DButton", window);
		respawn:SetText("");
		respawn:SetSize(window:GetWide() / 2.3, window:GetTall() / 6);
		respawn:SetPos(0, window:GetTall() - deny:GetTall() - paddingH);
		respawn:CenterHorizontal();
		respawn.DoClick = function()
			net.Start("revival_revive_accept");
				net.WriteBool(true);
			net.SendToServer();
		
			window:Close();
		end
		respawn.Paint = function(p, w, h)
			draw.RoundedBox(4, 0, 0, w, h, REVIVAL.getSetting("denyButtonColor", Color(200, 60, 60, 255)));
			draw.SimpleText(REVIVAL.getSetting("respawnText", "Respawn"), REVIVAL.getSetting("buttonFont", "REVIVAL_MenuFont"), w/2, h/2, REVIVAL.getSetting("denyTextColor", Color(255, 255, 255)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		end
		
		local dX, dY = deny:GetPos();
		local aX, aY = accept:GetPos();
		deny:SetPos(dX, dY - (respawn:GetTall() * 1.1));
		accept:SetPos(aX, aY - (respawn:GetTall() * 1.1));
	end
end)