local sounds = {
	"npc/metropolice/vo npc/metropolice/vo/11-99officerneedsassistance.wav",
	"npc/metropolice/takedown.wav",
	"npc/metropolice/vo/backup.wav",
	"npc/metropolice/vo/backmeupImout.wav"
}

local deaths = {}
local function AddHook()
	hook.Add("HUDPaint", "PoliceDeath.Point", function()
		for index, posi in pairs(deaths) do
			local point = posi:ToScreen()
			draw.DrawText("Officer Down!","Default",point.x, point.y - 55, color_white, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(255,255,255)
			surface.SetMaterial(Material("icon16/delete.png"))
			surface.DrawTexturedRect(point.x - 16, point.y - 32, 32, 32)
		end
	end)
end

hook.Add("OnPlayerChangedTeam", "PoliceDeath.AddHook", function(ply, before, after)
	if GAMEMODE.CivilProtection[after] then
		AddHook()
	elseif GAMEMODE.CivilProtection[before] then
		hook.Remove("HUDPaint", "PoliceDeath.Point")
	end
end)

net.Receive("PoliceDeath", function( len, pl )
	local ply = net.ReadEntity()
	local pos = net.ReadVector()
	
	if IsValid(ply) then 
		surface.PlaySound(sounds[math.random(#sounds)])
		local index = ply:EntIndex()
		deaths[index] = pos

		timer.Create("PoliceDeath_Point_Remove"..index, 30, 1, function()
			deaths[index] = nil
		end)
	end
end)