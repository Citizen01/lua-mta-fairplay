--[[
	- FairPlay Gaming: Roleplay
	
	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.
	
	(c) Copyright 2014 FairPlay Gaming. All rights reserved.
]]

MTAoutputChatBox_ = outputChatBox
function outputLongChatBox(text, visibleTo, r, g, b, colorCoded)
	if (string.len(text) > 128) then
		MTAoutputChatBox_(string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded)
		outputChatBox(string.sub(text, 128), visibleTo, r, g, b, colorCoded)
	else
		MTAoutputChatBox_(text, visibleTo, r, g, b, colorCoded)
	end
end

local reports = {}

addEventHandler("onPlayerScreenShot", root,
	function(resource, status, pixels, timestamp, tag)
		if (resource ~= getThisResource()) then return end
		if (reports[source]) then
			outputChatBox("Your report screenshot is now saved.", source, 20, 245, 20, false)
			reports[source]["imageData"] = {status, pixels, timestamp}
		end
	end
)

addEventHandler("onPlayerQuit", root,
	function()
		if (reports[source]) then
			if (reports[source]["admin"]) then
				outputChatBox("[#" .. reports[source]["id"] .. "] " .. getPlayerName(source):gsub("_", " ") .. " left the game. Report is now closed.", reports[source]["admin"], 40, 200, 245, false)
			end
			reports[source] = nil
		else
			for i,v in pairs(reports) do
				if (reports[i]["reported"] == source) then
					if (reports[i]["admin"]) then
						outputChatBox("[#" .. reports[i]["id"] .. "] Reported player " .. getPlayerName(source):gsub("_", " ") .. " (" .. reports[i]["reportedAccountName"] .. ") left the game.", reports[i]["admin"], 40, 200, 245, false)
					end
					outputChatBox("The player you reported (" .. getPlayerName(source):gsub("_", " ") .. ") left the game. Report will stay open.", reports[i]["reporter"], 40, 200, 245, false)
					reports[i]["reported"] = false
				elseif (reports[i]["admin"] == source) then
					for _,player in ipairs(getElementsByType("player")) do
						if (exports['roleplay-accounts']:isClientModerator(player)) and (exports['roleplay-accounts']:getAdminState(player) == 1) then
							outputChatBox("[#" .. reports[i]["id"] .. "] An administrator handling " .. exports['roleplay-accounts']:getRealPlayerName2(reports[i]["reporter"]):gsub("_", " ") .. " report left the game. Please respond to the report.", player, 40, 200, 245, false)
						end
					end
					outputChatBox("The administrator that was handling your report left the game. Trying to get ahold of another administrator...", reports[i]["reporter"], 210, 160, 25, false)
					reports[i]["admin"] = false
				end
			end
		end
	end
)

function tablelength(table)
	local count = 0
	for _ in pairs(table) do count = count+1 end
	return count
end

addEvent(":_submitReport_:", true)
addEventHandler(":_submitReport_:", root,
	function(target, description, shotOrNot)
		if (source ~= client) then return end
		if (reports[client]) then
			outputChatBox("You already have a report pending. End it with /endreport before submitting a new one.", client, 245, 20, 20, false)
		else
			local hour, minute = getTime()
			outputChatBox("Report has now been submitted to the online administrators for review. You can end your report with /endreport if you have to.", client, 210, 160, 25, false)
			
			reports[client] = {
				["id"] = tablelength(reports)+1,
				["reporter"] = client,
				["reported"] = target,
				["reportedName"] = getPlayerName(target):gsub("_", " "),
				["reportedAccountName"] = exports['roleplay-accounts']:getAccountName(target),
				["description"] = description,
				["screenshotted"] = shotOrNot,
				["time"] = hour .. ":" .. minute,
				["admin"] = false,
				["imageData"] = {false, 0, 0}
			}
			
			if (shotOrNot) then
				takePlayerScreenShot(client, 1280, 720, "", 65, 10000)
				outputChatBox("Your report screenshot is being saved...", client, 210, 160, 25, false)
				outputServerLog("Reports: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] submitted a report with screenshot (ID " .. reports[client]["id"] .. ").")
			else
				outputServerLog("Reports: " .. getPlayerName(client) .. " [" .. exports['roleplay-accounts']:getAccountName(client) .. "] submitted a report (ID " .. reports[client]["id"] .. ").")
			end
			
			for i,v in ipairs(getElementsByType("player")) do
				if (exports['roleplay-accounts']:isClientTrialAdmin(v)) and (exports['roleplay-accounts']:getAdminState(v) == 1) then
					outputChatBox("[#" .. reports[client]["id"] .. "] A report was submitted by " .. getPlayerName(client):gsub("_", " ") .. " (" .. exports['roleplay-accounts']:getAccountName(client) .. ") at " .. reports[client]["time"] .. ".", v, 40, 200, 245, false)
					outputChatBox("[#" .. reports[client]["id"] .. "] Reported player: " .. (target == client and "-" or getPlayerName(target):gsub("_", " ") .. " (" .. exports['roleplay-accounts']:getAccountName(target) .. ")"), v, 40, 200, 245, false)
					outputChatBox("[#" .. reports[client]["id"] .. "] Description: " .. (string.len(description) > 83 and description:sub(1, 83) .. "..." or description), v, 40, 200, 245, false)
					if (shotOrNot) then
						outputChatBox("[#" .. reports[client]["id"] .. "] Additional notes: There is also a screenshot attached to the report. Review by typing /reviewshot " .. reports[client]["id"] .. ".", v, 40, 200, 245, false)
					end
				end
			end
		end
	end
)

-- Commands
local addCommandHandler_ = addCommandHandler
	addCommandHandler  = function(commandName, fn, restricted, caseSensitive)
	if (type(commandName) ~= "table") then
		commandName = {commandName}
	end
	for key, value in ipairs(commandName) do
		if (key == 1) then
			addCommandHandler_(value, fn, restricted, false)
		else
			addCommandHandler_(value,
				function(player, ...)
					fn(player, ...)
				end, false, false
			)
		end
	end
end

addCommandHandler("report",
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		if (reports[player]) then
			outputChatBox("You already have a report pending. End it with /endreport before submitting a new one.", player, 245, 20, 20, false)
		else
			triggerClientEvent(player, ":_reportStart_:", player)
		end
	end
)

addCommandHandler({"er", "endreport"},
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientPlaying(player)) then return end
		if (reports[player]) then
			if (not reports[player]["admin"]) then
				outputChatBox("Report has now been closed. Report again if something comes up.", player, 210, 160, 25, false)
				for i,v in ipairs(getElementsByType("player")) do
					if (exports['roleplay-accounts']:isClientModerator(v)) and (exports['roleplay-accounts']:getAdminState(v) == 1) then
						outputChatBox("[#" .. reports[player]["id"] .. "] " .. getPlayerName(player):gsub("_", " ") .. " closed their report.", v, 40, 200, 245, false)
					end
				end
				outputServerLog("Reports: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] closed their own report (ID " .. reports[player]["id"] .. ").")
				reports[player] = nil
			else
				outputChatBox("You cannot close a report that is being handled. Instead, ask the administrator to close it.", player, 245, 20, 20, false)
			end
		else
			outputChatBox("You don't have a report pending. You can submit a report by pressing F2 or typing /report.", player, 245, 20, 20, false)
		end
	end
)

addCommandHandler("reports",
	function(player, cmd)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local count = false
			
			for i,v in pairs(reports) do
				count = true
				outputChatBox("[#" .. v["id"] .. "] A report was submitted by " .. getPlayerName(v["reporter"]):gsub("_", " ") .. " (" .. exports['roleplay-accounts']:getAccountName(v["reporter"]) .. ") at " .. v["time"] .. ".", player, 40, 200, 245, false)
				outputChatBox("[#" .. v["id"] .. "] Reported player: " .. (v["reporter"] == v["reported"] and "-" or (v["reported"] and getPlayerName(v["reported"]):gsub("_", " ") or v["reportedName"] .. " (" .. v["reportedAccountName"] .. ") - Offline")), player, 40, 200, 245, false)
				outputLongChatBox("[#" .. v["id"] .. "] Description: " .. (string.len(v["description"]) > 83 and v["description"]:sub(1, 83) .. "..." or v["description"]), player, 40, 200, 245, false)
				outputServerLog("Reports: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] read report ID " .. v["id"] .. " by " .. getPlayerName(v["reporter"]):gsub("_", " ") .. " (" .. exports['roleplay-accounts']:getAccountName(v["reporter"]) .. ").")
			end
			
			if (not count) then
				outputChatBox("No reports posted at the moment.", player, 245, 20, 20, false)
			end
		end
	end
)

addCommandHandler({"ri", "readreport", "rr"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local id = tonumber(id)
			if (not id) or (id <= 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [report id]", player, 210, 160, 25, false)
				return
			else
				local found = false
				for i,v in pairs(reports) do
					if (reports[i]["id"] == id) then
						found = true
						outputChatBox("[#" .. reports[i]["id"] .. "] A report was submitted by " .. getPlayerName(reports[i]["reporter"]):gsub("_", " ") .. " (" .. exports['roleplay-accounts']:getAccountName(reports[i]["reporter"]) .. ") at " .. reports[i]["time"] .. ".", player, 40, 200, 245, false)
						outputChatBox("[#" .. reports[i]["id"] .. "] Reported player: " .. (reports[i]["reporter"] == reports[i]["reported"] and "-" or (reports[i]["reported"] and getPlayerName(reports[i]["reported"]):gsub("_", " ") or reports[i]["reportedName"] .. " (" .. reports[i]["reportedAccountName"] .. ") - Offline")), player, 40, 200, 245, false)
						outputLongChatBox("[#" .. reports[i]["id"] .. "] Description: " .. (string.len(reports[i]["description"]) > 83 and reports[i]["description"]:sub(1, 83) .. "..." or reports[i]["description"]), player, 40, 200, 245, false)
						outputServerLog("Reports: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] read report ID " .. id .. " by " .. getPlayerName(reports[i]["reporter"]):gsub("_", " ") .. " (" .. exports['roleplay-accounts']:getAccountName(reports[i]["reporter"]) .. ").")
						break
					end
				end
				
				if (not found) then
					outputChatBox("Couldn't find a report with that ID.", player, 245, 20, 20, false)
					return
				end
			end
		end
	end
)

addCommandHandler({"ar", "acceptreport", "areport"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local id = tonumber(id)
			if (not id) or (id <= 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [report id]", player, 210, 160, 25, false)
				return
			else
				local found = false
				for i,v in pairs(reports) do
					if (reports[i]["id"] == id) then
						found = true
						if (reports[i]["admin"] == false) then
							reports[i]["admin"] = player
							for _,player_ in ipairs(getElementsByType("player")) do
								if (exports['roleplay-accounts']:isClientTrialAdmin(player_)) and (exports['roleplay-accounts']:getAdminState(player_) == 1) then
									outputChatBox("[#" .. reports[i]["id"] .. "] " .. getPlayerName(player):gsub("_", " ") .. " assigned the report to themself.", player_, 40, 200, 245, false)
								end
							end
							outputChatBox(getPlayerName(player):gsub("_", " ") .. " accepted your report. Please wait patiently for the administrator's response.", reports[i]["reporter"], 210, 160, 25, false)
							outputServerLog("Reports: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] accepted report ID " .. id .. " by " .. getPlayerName(reports[i]["reporter"]):gsub("_", " ") .. " (" .. exports['roleplay-accounts']:getAccountName(reports[i]["reporter"]) .. ").")
						else
							outputChatBox("The report is already being handled by " .. getPlayerName(reports[i]["admin"]):gsub("_", " ") .. ".", player, 245, 20, 20, false)
						end
						break
					end
				end
				
				if (not found) then
					outputChatBox("Couldn't find a report with that ID.", player, 245, 20, 20, false)
					return
				end
			end
		end
	end
)

addCommandHandler({"cr", "closereport", "creport"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local id = tonumber(id)
			if (not id) or (id <= 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [report id]", player, 210, 160, 25, false)
				return
			else
				local found = false
				for i,v in pairs(reports) do
					if (reports[i]["id"] == id) then
						found = true
						if (reports[i]["admin"] == player) then
							for _,player_ in ipairs(getElementsByType("player")) do
								if (exports['roleplay-accounts']:isClientModerator(player_)) and (exports['roleplay-accounts']:getAdminState(player_) == 1) then
									outputChatBox("[#" .. reports[i]["id"] .. "] " .. getPlayerName(player):gsub("_", " ") .. " closed the report.", player_, 40, 200, 245, false)
								end
							end
							outputChatBox(getPlayerName(player):gsub("_", " ") .. " closed your report. If you feel unsatisfied of their response, please submit another report.", reports[i]["reporter"], 210, 160, 25, false)
							outputServerLog("Reports: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] closed report ID " .. id .. " by " .. getPlayerName(reports[i]["reporter"]):gsub("_", " ") .. " (" .. exports['roleplay-accounts']:getAccountName(reports[i]["reporter"]) .. ").")
							reports[i] = nil
						elseif (reports[i]["admin"] == false) then
							outputChatBox("You haven't accepted the report yet.", player, 245, 20, 20, false)
						else
							outputChatBox("You cannot close a report that some other admin is handling.", player, 245, 20, 20, false)
						end
						break
					end
				end
				
				if (not found) then
					outputChatBox("Couldn't find a report with that ID.", player, 245, 20, 20, false)
					return
				end
			end
		end
	end
)

addCommandHandler({"fr", "falsereport", "freport"},
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local id = tonumber(id)
			if (not id) or (id <= 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [report id]", player, 210, 160, 25, false)
				return
			else
				local found = false
				for i,v in pairs(reports) do
					if (reports[i]["id"] == id) then
						found = true
						if (not reports[i]["admin"]) then
							for _,player_ in ipairs(getElementsByType("player")) do
								if (exports['roleplay-accounts']:isClientModerator(player_)) and (exports['roleplay-accounts']:getAdminState(player_) == 1) then
									outputChatBox("[#" .. reports[i]["id"] .. "] " .. getPlayerName(player):gsub("_", " ") .. " marked the report as false.", player_, 40, 200, 245, false)
								end
							end
							outputChatBox(getPlayerName(player):gsub("_", " ") .. " marked your report as false. If you feel unsatisfied of their response, please submit another report.", reports[i]["reporter"], 210, 160, 25, false)
							outputServerLog("Reports: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] marked report ID " .. id .. " false by " .. getPlayerName(reports[i]["reporter"]):gsub("_", " ") .. " (" .. exports['roleplay-accounts']:getAccountName(reports[i]["reporter"]) .. ").")
							reports[i] = nil
						else
							outputChatBox("You cannot false a report that some other admin is handling.", player, 245, 20, 20, false)
						end
						break
					end
				end
				
				if (not found) then
					outputChatBox("Couldn't find a report with that ID.", player, 245, 20, 20, false)
					return
				end
			end
		end
	end
)

addCommandHandler("reviewshot",
	function(player, cmd, id)
		if (not exports['roleplay-accounts']:isClientTrialAdmin(player)) then
			outputServerLog("Command Error: " .. getPlayerName(player) .. " tried to execute command /" .. cmd .. ".")
			return
		else
			local id = tonumber(id)
			if (not id) or (id <= 0) then
				outputChatBox("SYNTAX: /" .. cmd .. " [report id]", player, 210, 160, 25, false)
				return
			else
				local found = false
				
				for i,v in pairs(reports) do
					if (reports[i]["id"] == id) then
						found = true
						if (tostring(reports[i]["imageData"][1]) == "ok") then
							triggerClientEvent(player, ":_displayReportShot_:", player, reports[i]["imageData"][2])
							outputServerLog("Reports: " .. getPlayerName(player) .. " [" .. exports['roleplay-accounts']:getAccountName(player) .. "] reviewed screenshot on report ID " .. id .. " by " .. getPlayerName(reports[i]["reporter"]):gsub("_", " ") .. " (" .. exports['roleplay-accounts']:getAccountName(reports[i]["reporter"]) .. ").")
						else
							outputChatBox((tostring(reports[i]["imageData"][1]) == "false" and "The image file is still loading. Please try again in a moment!" or "The image file was corrupted during submit (or client doesn't allow screenshots) and cannot be read."), player, 245, 20, 20, false)
						end
						break
					end
				end
				
				if (not found) then
					outputChatBox("Couldn't find a report with that ID.", player, 245, 20, 20, false)
					return
				end
			end
		end
	end
)