util.AddNetworkString("PoliceDeath")
local function BroadcastCPDeath(ply, dpos)
	net.Start("PoliceDeath")
		net.WriteEntity(ply)
		net.WriteVector(Vector(dpos))
	net.Send(ply)
end

function MakeWantedPlayer(ply, reason, time)
	ply:setDarkRPVar("wanted", true)
	DarkRP.notify(ply, 1, 5, "You are wanted: " .. reason)
	timer.Create(ply:SteamID64() .. " wantedtimer", time, 1, function()
		if not IsValid(ply) then return end
		ply:unWanted()
	end)
end

function GetOfficers()
	local pls = player.GetAll()
	local cps = {}
	for k = 1, #pls do
		local v = pls[k]
		if v:isCP() then
			table.insert(cps, v)
		end
	end
	return cps
end

hook.Add("PlayerDeath", "PoliceDeath", function(ply, inflictor, attacker)
	if ply != attacker and ply:isCP() then
		if not attacker:isCP() then
			MakeWantedPlayer(attacker, "Killing an Officer.", 300)
		end
		if ply:isCP() then
		 	local cps = GetOfficers()
		 	local deathpos = ply:GetPos()
		    for k, v in pairs(cps) do
		    	BroadcastCPDeath(v, deathpos)
		    end
		end
	end
end)