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

local sx, sy = guiGetScreenSize()
local gWidth, gHeight = 859, 450
local commandHelp = {
    window = {},
    button = {},
    tabpanel = {},
    tab = {},
    gridlist = {}
}

local adminCommands = {
	{ --trial
		{"/a", 					"/a", "Talk in the admin private chat."},
		{"/adminduty", 			"/adminduty", "Toggle admin duty."},
		{"/adminlounge", 		"/adminlounge", "Teleport to the admin lounge space."},
		{"/ah", 				"/ah", "Open up a window with all admin commands listed on it."},
		{"/ann", 				"/ann [message]", "Send a global broadcast to all players on the server."},
		{"/ar", 				"/ar [report id]", "Accept an open report and assign it to yourself."},
		{"/atogooc", 			"/atogooc", "Toggle the global out-of-character chat."},
		{"/ban", 				"/ban [player] [hour] [reason]", "Ban a player from the server for the amount of time passed in."},
		{"/changename", 		"/changename [player] [new name]", "Change a player's character name."},
		{"/check", 				"/check [player]", "Check a player's information."},
		{"/cr", 				"/cr [report id]", "Close a report that you've picked up."},
		{"/disappear", 			"/disappear", "Turn (in)visible. Useful when flying in the sky."},
		{"/fixveh", 			"/fixveh [player]", "Repair a vehicle."},
		{"/fr", 				"/fr [report id]", "Mark an open report as false."},
		{"/fuelveh", 			"/fuelveh [player]", "Refuel a vehicle."},
		{"/giveitem", 			"/giveitem [player] [item id] [value]", "Give an item to a player."},
		{"/givelanguage", 		"/givelanguage [player] [lang id] [value]", "Give player a language with the specified amount."},
		{"/goto", 				"/goto [player]", "Teleport to a player."},
		{"/gotoatm", 			"/gotoatm [player] [atm id]", "Teleport to an ATM machine."},
		{"/gotoint", 			"/gotoint [interior id]", "Teleport to the outside of an interior."},
		{"/gotointi", 			"/gotointi [interior id]", "Teleport to the inside of an interior."},
		{"/gotoplace", 			"/gotoplace [place name]", "Teleport to a pre-defined place."},
		{"/gotoveh", 			"/gotoveh [vehicle id]", "Teleport to a vehicle with the passed in vehicle ID."},
		{"/gethere", 			"/gethere [player]", "Teleport a player to you."},
		{"/getpos", 			"/getpos <[player]>", "Get the position of your own or another player."},
		{"/getveh", 			"/getveh [vehicle id]", "Teleport a vehicle to you with the passed in vehicle ID."},
		{"/issuedriverslicense","/issuedriverslicense [player] [type]", "Issue a player a driver's license with the type passed in."},
		{"/jail", 				"/jail [player] [length] [reason]", "Jail a player for the amount of time passed in."},
		{"/kick", 				"/kick [player] [reason]", "Kick a player from the server."},
		{"/nearbyatms", 		"/nearbyatms", "List all nearby ATMs in the chatbox."},
		{"/nearbyelevators", 	"/nearbyelevators", "List all nearby elevators in the chatbox."},
		{"/nearbyints", 		"/nearbyints", "List all nearby interiors in the chatbox."},
		{"/nearbyvehs", 		"/nearbyvehs", "List all nearby vehicles in the chatbox."},
		{"/reports", 			"/reports", "List all the reports in the chatbox."},
		{"/respawndistrict", 	"/respawndistrict", "Respawn all vehicles on the specific district you're in."},
		{"/respawnfaction", 	"/respawnfaction", "Respawn all vehicles in a specific faction."},
		{"/respawnveh", 		"/respawnveh [vehicle id]", "Respawn a vehicle with the passed in vehicle ID."},
		{"/respawnvehs", 		"/respawnvehs", "Respawn all vehicles on the server."},
		{"/sendto", 			"/sendto [player] [target]", "Send a player to another player."},
		{"/setarmor", 			"/setarmor [player] [value]", "Set the armor efficiency on a player."},
		{"/setcolor", 			"/setcolor [r] [g] [b]...", "Set the RGB colors of a vehicle."},
		{"/setdim", 			"/setdim [player] [dimension]", "Set the dimension of a player."},
		{"/sethp", 				"/sethp [player] [value]", "Set the health of a player."},
		{"/setfaction", 		"/setfaction [player] [faction id]", "Set the faction of a player."},
		{"/setgearbox", 		"/setgearbox [player] [type]", "Set the transmission type of a vehicle."},
		{"/setint", 			"/setint [player] [interior]", "Set the interior of a player."},
		{"/setpos", 			"/setpos [player] [x] [y] [z]", "Set the position of a player."},
		{"/sll", 				"/sll [player] [height]", "Set the suspension lower level of a vehicle."},
		{"/stogooc", 			"/stogooc", "Silently toggle the global out-of-character chat."},
		{"/takeitem", 			"/takeitem [player] [item id] [value]", "Take an item from a player."},
		{"/takelanguage", 		"/takelanguage [player] [lang id]", "Take a language from a player."},
		{"/unflip", 			"/unflip [player]", "Unflip a vehicle."},
		{"/unjail", 			"/unjail [player]", "Unjail a player."},
		{"/veh", 				"/veh [model]", "Create a temporary vehicle with limited features."},
		{"/x", 					"/x [amount]", "Increase or decrease your current x-coordinate."},
		{"/y", 					"/y [amount]", "Increase or decrease your current y-coordinate."},
		{"/z", 					"/z [amount]", "Increase or decrease your current z-coordinate."},
	},
	
	{ --full
		{"/delatm", 			"/delatm [atm id]", "Delete an ATM machine with the ATM ID."},
		{"/delint", 			"/delint [interior]", "Delete an interior with the interior ID."},
		{"/delthisveh", 		"/delthisveh", "Deletes the vehicle that you're in."},
		{"/delveh", 			"/delveh [vehicle]", "Delete a vehicle with the vehicle ID."},
		{"/makeatm", 			"/makeatm <[deposit]> <[withdraw]> <[limit]>", "Create an ATM machine."},
		{"/makeint", 			"/makeint [id] [type] [price] [name]", "Create an interior with the passed in arguments."},
		{"/makecivveh", 		"/makecivveh [model] [job type]", "Create a civilian vehicle with the passed in arguments."},
		{"/makeveh", 			"/makeveh [model] [player/faction] [faction (0/1)] [cost] [tint]", "Create a vehicle with the passed in arguments."},
		{"/setinteriorid", 		"/setinteriorid [interior] [id]", "Set inside interior of an interior."},
		{"/setinteriorname",	"/setinteriorname [interior] [name]", "Set the name of an interior."},
		{"/setinteriorprice",	"/setinteriorprice [interior] [cost]", "Set the cost of an interior."},
		{"/setinteriortype",	"/setinteriortype [interior] [type]", "Set the type of an interior."},
	},
	
	{ --lead
		--{"/delfaction", 		"/delfaction [faction id]", "Delete a faction from the server."},
		{"/l", 					"/l [message]", "Talk in the lead admin private chat."},
		{"/makefaction", 		"/makefaction [type] [name]", "Create a faction with the passed in arguments."},
		{"/setfactionleader", 	"/setfactionleader [player] [leader status]", "Set the faction leader status of a player."},
		{"/setfactionbalance", 	"/setfactionbalance [player] [value]", "Set the balance of a faction."},
		{"/setvehfaction",		"/setvehfaction [player] [faction id]", "Set the faction a vehicle belongs to."},
		{"/setvehowner", 		"/setvehowner [player]", "Set the owner of the vehicle."},
		{"/setvehtint", 		"/setvehtint [player] [tint]", "Set the tinted windows of a vehicle."},
	},
	
	{ --head
		{"/h", 					"/h [message]", "Talk in the head admin private chat."},
		{"/hideadmin", 			"/hideadmin [message]", "Toggle hidden admin duty."},
		{"/givemoney", 			"/givemoney [player] [amount]", "Give money to a player."},
		{"/setmoney", 			"/setmoney [player] [amount]", "Set the money of a player."},
		{"/takemoney", 			"/takemoney [player] [amount]", "Take money from a player."},
	},
	
	{ --leader
		{"/cl", 				"/cl [message]", "Talk in the leader private chat."},
		{"/makeadmin", 			"/makeadmin [player] [rank]", "Make a player an administrator with the specified level."},
		{"/restartres", 		"/restartres [resource]", "Restarts a resource."},
		{"/setstatebenefit", 	"/setstatebenefit [new amount]", "Set the state benefit value."},
		{"/setpropertytax", 	"/setpropertytax [new amount]", "Set the property tax value."},
		{"/setvehicletax", 		"/setvehicletax [new amount]", "Set the vehicle tax value."},
		{"/startres", 			"/startres [resource]", "Starts a resource."},
		{"/stopres", 			"/stopres [resource]", "Stops a resource."},
	}
}

function displayAdminHelp()
	if (isElement(commandHelp.window[1])) then
		destroyElement(commandHelp.window[1])
		showCursor(false)
		return
	end
	
	if (not exports['roleplay-accounts']:isClientTrialAdmin(localPlayer)) then return end
	
	commandHelp.window[1] = guiCreateWindow((sx-gWidth)/2, (sy-gHeight)/2, gWidth, gHeight, "Admin Commands", false)
	guiWindowSetSizable(commandHelp.window[1], false)
	
	commandHelp.tabpanel[1] = guiCreateTabPanel(9, 25, 840, 361, false, commandHelp.window[1])
	
	commandHelp.tab[1] = guiCreateTab("Trial Admin", commandHelp.tabpanel[1])
	commandHelp.gridlist[1] = guiCreateGridList(10, 10, 820, 317, false, commandHelp.tab[1])
	guiGridListAddColumn(commandHelp.gridlist[1], "Command", 0.15)
	guiGridListAddColumn(commandHelp.gridlist[1], "Usage", 0.3)
	guiGridListAddColumn(commandHelp.gridlist[1], "Description", 0.5)
	
	for _,command in pairs(adminCommands[1]) do
		local row = guiGridListAddRow(commandHelp.gridlist[1])
		guiGridListSetItemText(commandHelp.gridlist[1], row, 1, command[1], false, false)
		guiGridListSetItemText(commandHelp.gridlist[1], row, 2, command[2], false, false)
		guiGridListSetItemText(commandHelp.gridlist[1], row, 3, command[3], false, false)
	end
	
	commandHelp.tab[2] = guiCreateTab("Admin", commandHelp.tabpanel[1])
	commandHelp.gridlist[2] = guiCreateGridList(10, 10, 820, 317, false, commandHelp.tab[2])
	guiGridListAddColumn(commandHelp.gridlist[2], "Command", 0.15)
	guiGridListAddColumn(commandHelp.gridlist[2], "Usage", 0.3)
	guiGridListAddColumn(commandHelp.gridlist[2], "Description", 0.5)
	
	for _,command in pairs(adminCommands[2]) do
		local row = guiGridListAddRow(commandHelp.gridlist[2])
		guiGridListSetItemText(commandHelp.gridlist[2], row, 1, command[1], false, false)
		guiGridListSetItemText(commandHelp.gridlist[2], row, 2, command[2], false, false)
		guiGridListSetItemText(commandHelp.gridlist[2], row, 3, command[3], false, false)
	end
	
	commandHelp.tab[3] = guiCreateTab("Lead Admin", commandHelp.tabpanel[1])
	commandHelp.gridlist[3] = guiCreateGridList(10, 10, 820, 317, false, commandHelp.tab[3])
	guiGridListAddColumn(commandHelp.gridlist[3], "Command", 0.15)
	guiGridListAddColumn(commandHelp.gridlist[3], "Usage", 0.3)
	guiGridListAddColumn(commandHelp.gridlist[3], "Description", 0.5)
	
	for _,command in pairs(adminCommands[3]) do
		local row = guiGridListAddRow(commandHelp.gridlist[3])
		guiGridListSetItemText(commandHelp.gridlist[3], row, 1, command[1], false, false)
		guiGridListSetItemText(commandHelp.gridlist[3], row, 2, command[2], false, false)
		guiGridListSetItemText(commandHelp.gridlist[3], row, 3, command[3], false, false)
	end
	
	commandHelp.tab[4] = guiCreateTab("Head Admin", commandHelp.tabpanel[1])
	commandHelp.gridlist[4] = guiCreateGridList(10, 10, 820, 317, false, commandHelp.tab[4])
	guiGridListAddColumn(commandHelp.gridlist[4], "Command", 0.15)
	guiGridListAddColumn(commandHelp.gridlist[4], "Usage", 0.3)
	guiGridListAddColumn(commandHelp.gridlist[4], "Description", 0.5)
	
	for _,command in pairs(adminCommands[4]) do
		local row = guiGridListAddRow(commandHelp.gridlist[4])
		guiGridListSetItemText(commandHelp.gridlist[4], row, 1, command[1], false, false)
		guiGridListSetItemText(commandHelp.gridlist[4], row, 2, command[2], false, false)
		guiGridListSetItemText(commandHelp.gridlist[4], row, 3, command[3], false, false)
	end
	
	commandHelp.tab[5] = guiCreateTab("Leader", commandHelp.tabpanel[1])
	commandHelp.gridlist[5] = guiCreateGridList(10, 10, 820, 317, false, commandHelp.tab[5])
	guiGridListAddColumn(commandHelp.gridlist[5], "Command", 0.15)
	guiGridListAddColumn(commandHelp.gridlist[5], "Usage", 0.3)
	guiGridListAddColumn(commandHelp.gridlist[5], "Description", 0.5)
	
	for _,command in pairs(adminCommands[5]) do
		local row = guiGridListAddRow(commandHelp.gridlist[5])
		guiGridListSetItemText(commandHelp.gridlist[5], row, 1, command[1], false, false)
		guiGridListSetItemText(commandHelp.gridlist[5], row, 2, command[2], false, false)
		guiGridListSetItemText(commandHelp.gridlist[5], row, 3, command[3], false, false)
	end
	
	commandHelp.button[1] = guiCreateButton(9, 392, 840, 48, "Close Window", false, commandHelp.window[1])
	
	addEventHandler("onClientGUIClick", commandHelp.button[1], displayAdminHelp, false)
	
	showCursor(true)
end

addCommandHandler("ah",
	function(cmd)
		displayAdminHelp()
	end, false, false
)