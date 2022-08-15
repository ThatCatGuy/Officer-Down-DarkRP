CreateConVar( "officerdown_assistdelay", 120, FCVAR_SERVER_CAN_EXECUTE )
CreateConVar( "officerdown_wanttime", 300, FCVAR_SERVER_CAN_EXECUTE )

local officerdown_assistdelay = GetConVar( "officerdown_assistdelay" )
local officerdown_wanttime = GetConVar( "officerdown_wanttime" )

util.AddNetworkString("CPLocation")
local function BroadcastCPLocation(ply, dpos, type)
	net.Start("CPLocation")
		net.WriteEntity(ply)
		net.WriteVector(Vector(dpos))
		net.WriteString(type)
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

local function DeathSpot(ply)
	local cps = GetOfficers()
	if #cps >= 1 then return end
	if !ply:isCP() then return end
	if !ply:Alive() then return end

    if ply:isCP() then
 		local deathpos = ply:GetPos()
		for k, v in pairs(cps) do
			if v == ply then continue end
			DarkRP.notify(v, 1, 2, "An Officer Has Been Killed!")
			BroadcastCPLocation(v, deathpos, "cpdown")
		end
	end

    return ""
end

local function PingPolice(ply)
	local cps = GetOfficers()
	if #cps == 1 then return end
	if !ply:isCP() then return end
	if !ply:Alive() then return end

	if ply.NextPing and ply.NextPing > CurTime() then
		local TimeLeft = ply.NextPing
		DarkRP.notify(ply, 1, 2, "Ping Cooldown: " .. math.ceil(0 - (CurTime() - ply.NextPing)) .. " Seconds!")
			return false
	end
    ply.NextPing = CurTime() + officerdown_assistdelay:GetInt()

    if ply:isCP() then
	 	local pingpos = ply:GetPos()
		for k, v in pairs(cps) do
	    	if v == ply then continue end
	    	DarkRP.notify(v, 1, 4, "An Officer Has Requested Assistance!")
	    	BroadcastCPLocation(v, pingpos, "cpping")
	    end
	end

    return ""
end

hook.Add("PlayerDeath", "CPLocation", function(ply, inflictor, attacker)
	if not IsValid(ply) or not IsValid(attacker) then return end
	if ply != attacker and ply:isCP() then
		if not attacker:isCP() then
			MakeWantedPlayer(attacker, "Killing an Officer.", officerdown_wanttime:GetInt())
		end
	    DeathSpot(ply)
	end
end)

hook.Add( "PlayerSay", "CPLocation", function( ply, text )
    if  ( string.lower( text ) == "/backup" or string.lower( text ) == "!backup" ) then
         PingPolice(ply)
        return ""
    end
end )