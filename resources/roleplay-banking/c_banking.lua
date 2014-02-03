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
local atmData = {0, 0, 0, 0, 0, 0, false} -- ID, Limit, Withdraw, Deposit, Bank Money, Cash, Verified
local bankGui = {
    window = {},
    tabpanel = {},
    tab = {},
    edit = {},
    button = {},
    label = {}
}

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		local bank = createPed(150, 359.29, 173.56, 1008.88, 0, false)
		setElementInterior(bank, 3)
		setElementDimension(bank, 22)
		setElementRotation(bank, 0, 0, -90)
		setTimer(setPedAnimation, 100, 1, bank, "FOOD", "FF_Sit_Look", -1, true, false, false, true)
		setTimer(setPedAnimation, 5000, 0, bank, "FOOD", "FF_Sit_Look", -1, true, false, false, true)
		setElementData(bank, "roleplay:bank.element", 1, false)
		setElementData(bank, "roleplay:peds.name", "Maria Sanderson", false)
	end
)
--[[
addEventHandler("onClientResourceStart", resourceRoot,
    function()
		bankGui.window[1] = guiCreateWindow(587, 292, 543, 484, "Bank", false)
		guiWindowSetSizable(bankGui.window[1], false)
		
		bankGui.tabpanel[1] = guiCreateTabPanel(10, 25, 523, 386, false, bankGui.window[1])
		
		-- Personal stuff
		bankGui.tab[1] = guiCreateTab("Personal", bankGui.tabpanel[1])

		bankGui.tabpanel[2] = guiCreateTabPanel(10, 10, 503, 342, false, bankGui.tab[1])
		bankGui.tab[2] = guiCreateTab("Withdraw", bankGui.tabpanel[2])
		bankGui.edit[1] = guiCreateEdit(87, 107, 336, 78, "", false, bankGui.tab[2])
		bankGui.label[1] = guiCreateLabel(87, 38, 336, 15, "Available money on bank account: 1,000,000 USD", false, bankGui.tab[2])
		guiSetFont(bankGui.label[1], "default-bold-small")
		bankGui.label[2] = guiCreateLabel(87, 59, 336, 15, "Cash in wallet: 100 USD", false, bankGui.tab[2])
		guiSetFont(bankGui.label[2], "default-bold-small")
		bankGui.button[1] = guiCreateButton(86, 195, 337, 68, "Withdraw Amount", false, bankGui.tab[2])
		guiSetFont(bankGui.button[1], "clear-normal")
		
		bankGui.tab[3] = guiCreateTab("Deposit", bankGui.tabpanel[2])
		bankGui.tab[4] = guiCreateTab("Transfer", bankGui.tabpanel[2])
		
		-- Faction stuff
		bankGui.tab[5] = guiCreateTab("Faction", bankGui.tabpanel[1])

		bankGui.button[2] = guiCreateButton(10, 417, 523, 55, "Exit Bank", false, bankGui.window[1])
		guiSetFont(bankGui.button[2], "clear-normal")
    end
)
]]
local function displayATMWindow()
	if (isElement(g_atm_window)) then
		destroyElement(g_atm_window)
		showCursor(false, false)
		atmData[1] = 0
		atmData[2] = 0
		atmData[3] = 0
		atmData[4] = 0
		atmData[5] = 0
		atmData[6] = 0
		atmData[7] = false
		if (isTimer(verif)) then killTimer(verif) end
		return
	end
	
	if (atmData[3] ~= 1) and (atmData[4] ~= 1) then
		g_atm_window = guiCreateWindow((sx-477)/2, (sy-316)/2, 477, 180, "Bank of Los Santos", false)
	else
		if (atmData[4] == 1) then
			if (atmData[3] == 1) then
				g_atm_window = guiCreateWindow((sx-477)/2, (sy-316)/2, 477, 316, "Bank of Los Santos", false)
			else
				g_atm_window = guiCreateWindow((sx-477)/2, (sy-316)/2, 477, 247, "Bank of Los Santos", false)
			end
		else
			g_atm_window = guiCreateWindow((sx-477)/2, (sy-316)/2, 477, 247, "Bank of Los Santos", false)
		end
	end
	
	guiWindowSetSizable(g_atm_window, false)
	
	g_atm_current_label = guiCreateLabel(17, 36, 573, 17, "You have currently " .. getFormattedValue(atmData[5]) .. " USD stored on your bank account.", false, g_atm_window)
	guiSetFont(g_atm_current_label, "default-bold-small")
	
	-- Withdrawal
	if (atmData[3] == 1) then
		g_atm_withdrawal_label = guiCreateLabel(17, 67, 165, 15, "Withdrawal", false, g_atm_window)
		g_atm_withdrawal_amount = guiCreateEdit(16, 92, 166, 32, "", false, g_atm_window)
		g_atm_withdrawal_btn = guiCreateButton(192, 92, 121, 32, "Withdraw", false, g_atm_window)
		
		addEventHandler("onClientGUIClick", g_atm_withdrawal_btn,
			function()
				triggerServerEvent(":_doGetMoneyAmount_:", localPlayer)
				local amount = tonumber(guiGetText(g_atm_withdrawal_amount))
				if (not amount) then
					outputChatBox("You have to enter in a number value to withdraw.", 245, 20, 20, false)
				else
					local amount = math.ceil(amount)
					if (amount <= 0) then
						outputChatBox("You have to enter in a withdraw value more than 0.", 245, 20, 20, false)
					else
						if (amount > atmData[5]) then
							outputChatBox("You have insufficient funds to withdraw such amount.", 245, 20, 20, false)
						else
							triggerServerEvent(":_doWithdraw_:", localPlayer, amount)
						end
					end
				end
			end, false
		)
		
		guiSetFont(g_atm_withdrawal_label, "default-bold-small")
	end
	
	-- Deposit
	if (atmData[4] == 1) then
		if (atmData[3] == 1) then
			g_atm_deposit_label = guiCreateLabel(17, 134, 165, 15, "Deposit", false, g_atm_window)
			g_atm_deposit_amount = guiCreateEdit(16, 159, 166, 32, "", false, g_atm_window)
			g_atm_deposit_btn = guiCreateButton(192, 159, 121, 32, "Deposit", false, g_atm_window)
		else
			g_atm_deposit_label = guiCreateLabel(17, 67, 165, 15, "Deposit", false, g_atm_window)
			g_atm_deposit_amount = guiCreateEdit(16, 92, 166, 32, "", false, g_atm_window)
			g_atm_deposit_btn = guiCreateButton(192, 92, 121, 32, "Deposit", false, g_atm_window)
		end
		
		guiSetFont(g_atm_deposit_label, "default-bold-small")
		
		addEventHandler("onClientGUIClick", g_atm_deposit_btn,
			function()
				triggerServerEvent(":_doGetMoneyAmount_:", localPlayer)
				local amount = tonumber(guiGetText(g_atm_deposit_amount))
				if (not amount) then
					outputChatBox("You have to enter in a number value to deposit.", 245, 20, 20, false)
				else
					local amount = math.ceil(amount)
					if (amount <= 0) then
						outputChatBox("You have to enter in a deposit value more than 0.", 245, 20, 20, false)
					else
						if (amount > atmData[6]) then
							outputChatBox("You have insufficient funds to deposit such amount.", 245, 20, 20, false)
						else
							triggerServerEvent(":_doDeposit_:", localPlayer, amount)
						end
					end
				end
			end, false
		)
	end
	
	-- Transfer
	if (atmData[3] ~= 1) and (atmData[4] ~= 1) then
		g_atm_transfer_label = guiCreateLabel(17, 67, 165, 15, "Transfer", false, g_atm_window)
		g_atm_transfer_amount = guiCreateEdit(16, 92, 166, 32, "", false, g_atm_window)
		g_atm_transfer_to_label = guiCreateLabel(202, 102, 15, 12, "to", false, g_atm_window)
		g_atm_transfer_name = guiCreateEdit(237, 92, 222, 32, "", false, g_atm_window)
		g_atm_transfer_btn = guiCreateButton(16, 134, 121, 32, "Transfer", false, g_atm_window)
		g_atm_exit_btn = guiCreateButton(147, 134, 312, 32, "Exit ATM", false, g_atm_window)
	else
		if (atmData[4] == 1) then
			if (atmData[3] == 1) then
				g_atm_transfer_label = guiCreateLabel(17, 201, 165, 15, "Transfer", false, g_atm_window)
				g_atm_transfer_amount = guiCreateEdit(16, 226, 166, 32, "", false, g_atm_window)
				g_atm_transfer_to_label = guiCreateLabel(202, 236, 15, 12, "to", false, g_atm_window)
				g_atm_transfer_name = guiCreateEdit(237, 226, 222, 32, "", false, g_atm_window)
				g_atm_transfer_btn = guiCreateButton(16, 268, 121, 32, "Transfer", false, g_atm_window)
				g_atm_exit_btn = guiCreateButton(147, 268, 312, 32, "Exit ATM", false, g_atm_window)
			else
				g_atm_transfer_label = guiCreateLabel(17, 134, 165, 15, "Transfer", false, g_atm_window)
				g_atm_transfer_amount = guiCreateEdit(16, 159, 166, 32, "", false, g_atm_window)
				g_atm_transfer_to_label = guiCreateLabel(202, 169, 15, 12, "to", false, g_atm_window)
				g_atm_transfer_name = guiCreateEdit(237, 159, 222, 32, "", false, g_atm_window)
				g_atm_transfer_btn = guiCreateButton(16, 201, 121, 32, "Transfer", false, g_atm_window)
				g_atm_exit_btn = guiCreateButton(147, 201, 312, 32, "Exit ATM", false, g_atm_window)
			end
		else
			g_atm_transfer_label = guiCreateLabel(17, 134, 165, 15, "Transfer", false, g_atm_window)
			g_atm_transfer_amount = guiCreateEdit(16, 159, 166, 32, "", false, g_atm_window)
			g_atm_transfer_to_label = guiCreateLabel(202, 169, 15, 12, "to", false, g_atm_window)
			g_atm_transfer_name = guiCreateEdit(237, 159, 222, 32, "", false, g_atm_window)
			g_atm_transfer_btn = guiCreateButton(16, 201, 121, 32, "Transfer", false, g_atm_window)
			g_atm_exit_btn = guiCreateButton(147, 201, 312, 32, "Exit ATM", false, g_atm_window)
		end
	end
	
	guiSetFont(g_atm_transfer_label, "default-bold-small")
	guiSetFont(g_atm_transfer_to_label, "default-bold-small")
	
	addEventHandler("onClientGUIClick", g_atm_transfer_btn,
		function()
			triggerServerEvent(":_doGetMoneyAmount_:", localPlayer)
			local amount = tonumber(guiGetText(g_atm_transfer_amount))
			
			if (not amount) then
				outputChatBox("Please define a value before transferring money.", 245, 20, 20, false)
				return
			end
			
			local amount = math.ceil(amount)
			local receiver = guiGetText(g_atm_transfer_name)
			
			if (not amount) then
				outputChatBox("You have to enter in a number value to transfer.", 245, 20, 20, false)
			else
				if (amount <= 0) then
					outputChatBox("You have to enter in a transfer value more than 0.", 245, 20, 20, false)
				else
					if (amount > atmData[5]) then
						outputChatBox("You have insufficient funds to transfer such amount.", 245, 20, 20, false)
					else
						if (not receiver) or (#receiver < 6) then
							outputChatBox("Enter a valid name in order to proceed 1.", 245, 20, 20, false)
						else
							for i=1,#receiver do
								local char = string.sub(receiver, i, i)
								if (char >= "A" and char <= "Z") or (char >= "a" and char <= "z") or (string.find(char, "%s")) or (char == "_") then
									if (i == #receiver) then
										triggerServerEvent(":_doTransfer_:", localPlayer, amount, receiver)
									end
								else
									outputChatBox("Enter a valid name in order to proceed.", 245, 20, 20, false)
									break
								end
							end
						end
					end
				end
			end
		end, false
	)
	
	addEventHandler("onClientGUIClick", g_atm_exit_btn,
		function()
			displayATMWindow()
		end, false
	)
end

addEvent(":_REMOTE.CLOSE_WINDOW_:", true)
addEventHandler(":_REMOTE.CLOSE_WINDOW_:", root,
	function()
		if (not isElement(g_atm_window)) then return end
		destroyElement(g_atm_window)
		showCursor(false, false)
		atmData[1] = 0
		atmData[2] = 0
		atmData[3] = 0
		atmData[4] = 0
		atmData[5] = 0
		atmData[6] = 0
		atmData[7] = false
		if (isTimer(verif)) then killTimer(verif) end
	end
)

addEventHandler("onClientClick", root,
	function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
		if (button == "left") and (state == "down") then
			if (clickedElement and getElementType(clickedElement) == "object") then
				if (getATMID(clickedElement)) then
					if (isElement(g_atm_window)) then return end
					local x, y, z = getElementPosition(localPlayer)
					if (getDistanceBetweenPoints3D(x, y, z, worldX, worldY, worldZ) > 1.5) then return end
					atmData[1] = getATMID(clickedElement)
					atmData[2] = getATMLimit(clickedElement)
					atmData[3] = getATMWithdraw(clickedElement)
					atmData[4] = getATMDeposit(clickedElement)
					triggerServerEvent(":_doGetMoneyAmount_:", localPlayer)
					verif = setTimer(function()
						if (isElement(g_atm_window)) then return end
						if (atmData[7] == true) then
							displayATMWindow()
						else
							if (not isTimer(verif)) then return end
							triggerServerEvent(":_doGetMoneyAmount_:", localPlayer)
							resetTimer(verif)
						end
					end, 50, 1)
				end
			elseif (clickedElement and getElementType(clickedElement) == "ped") then
				if (getElementData(clickedElement, "roleplay:bank.element")) then
					if (isElement(g_atm_window)) then return end
					local x, y, z = getElementPosition(localPlayer)
					if (getDistanceBetweenPoints3D(x, y, z, worldX, worldY, worldZ) > 3.5) then return end
					atmData[1] = 1
					atmData[2] = 10000000000
					atmData[3] = 1
					atmData[4] = 1
					triggerServerEvent(":_doGetMoneyAmount_:", localPlayer)
					verif = setTimer(function()
						if (isElement(g_atm_window)) then return end
						if (atmData[7] == true) then
							displayATMWindow()
						else
							if (not isTimer(verif)) then return end
							triggerServerEvent(":_doGetMoneyAmount_:", localPlayer)
							resetTimer(verif)
						end
					end, 50, 1)
				end
			end
		end
	end
)

addEvent(":_doneWithdraw_:", true)
addEventHandler(":_doneWithdraw_:", root,
	function(value)
		displayATMWindow()
		outputChatBox("You have successfully withdrawn " .. getFormattedValue(value) .. " USD from your bank account.", 20, 245, 20, false)
	end
)

addEvent(":_doneDeposit_:", true)
addEventHandler(":_doneDeposit_:", root,
	function(value)
		displayATMWindow()
		outputChatBox("You have successfully deposited " .. getFormattedValue(value) .. " USD to your bank account.", 20, 245, 20, false)
	end
)

addEvent(":_doneTransfer_:", true)
addEventHandler(":_doneTransfer_:", root,
	function(value, name)
		displayATMWindow()
		outputChatBox("You have successfully transferred " .. getFormattedValue(value) .. " USD to " .. exports['roleplay-accounts']:getRealPlayerName2(name) .. " bank account.", 20, 245, 20, false)
	end
)

addEvent(":_doFetchMoneyAmount_:", true)
addEventHandler(":_doFetchMoneyAmount_:", root,
	function(bank, cash)
		atmData[5] = bank
		atmData[6] = cash
		atmData[7] = true
	end
)