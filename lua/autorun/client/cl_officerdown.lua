local sounds = {
	"npc/metropolice/vo/11-99officerneedsassistance.wav",
	"npc/metropolice/takedown.wav",
	"npc/metropolice/vo/backup.wav",
	"npc/metropolice/vo/backmeupImout.wav"
}

local cvar = CreateClientConVar("officerdown_hide", 1)
local icondelay = CreateClientConVar("officerdown_removedelay", 45)
local deaths = {}
local pings = {}
local delete = Material("icon16/exclamation.png")
local ping = Material("icon16/transmit.png")
local black = Color(10, 10, 10, 200)

local function AddOfficerHook()
	hook.Add("HUDPaint", "CPLocation", function()
		if !LocalPlayer():Alive() then return end
		if !cvar:GetBool() then return end

		for index, posi in pairs(deaths) do
			local point = posi:ToScreen()
			local msg = "Officer Down!"
			surface.SetDrawColor(255,255,255)
			surface.SetMaterial(delete)
			surface.DrawTexturedRect(point.x - 10, point.y - 20, 20, 20)
			draw.SimpleTextOutlined(msg, "Default",point.x, point.y - 40, color_white, TEXT_ALIGN_CENTER, nil, 1, black)
		end

		for pindex, pposi in pairs(pings) do
			local ppoint = pposi:ToScreen()
			local msg = "Officer Needs Assistance!"
			surface.SetDrawColor(255,255,255)
			surface.SetMaterial(ping)
			surface.DrawTexturedRect(ppoint.x - 10, ppoint.y - 20, 20, 20)
			draw.SimpleTextOutlined(msg, "Default",ppoint.x, ppoint.y - 40, color_white, TEXT_ALIGN_CENTER, nil, 1, black)
		end
	end)
end

hook.Add("OnPlayerChangedTeam", "CPLocation.AddOfficerHook", function(ply, before, after)
	if GAMEMODE.CivilProtection[after] then
		AddOfficerHook()
	elseif GAMEMODE.CivilProtection[before] then
		hook.Remove("HUDPaint", "CPLocation")
	end
end)

net.Receive("CPLocation", function( len, pl )
	local ply = net.ReadEntity()
	local pos = net.ReadVector()
	local typ = net.ReadString()

	if pl == LocalPlayer() then
		return
	end
	
	if IsValid(ply) then 
		if cvar:GetBool() then
			surface.PlaySound(sounds[math.random(#sounds)])
		end
		
		local index = ply:EntIndex()
		
		if typ == "cpdown" then			
			deaths[ply] = pos
			timer.Create("PoliceDeath_Remove"..index, icondelay:GetInt(), 1, function()
				deaths[ply] = nil
			end)
		end
		
		if typ == "cpping" then
			pings[ply] = pos			
			timer.Create("PolicePing_Remove"..index, icondelay:GetInt(), 1, function()
				pings[ply] = nil
			end)
		end
	end
end)