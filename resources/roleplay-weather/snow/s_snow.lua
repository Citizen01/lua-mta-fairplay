local guiEnabled = get("gui_enabled")
local snowToggle = get("snow_toggle")
local isSetAlready = false

addEvent("onClientReady", true)
addEventHandler("onClientReady", root,
	function()
		triggerClientEvent(client, "triggerGuiEnabled", client, guiEnabled, snowToggle)
	end
)

addEvent(":_toggleSnowHandling_:",true)
addEventHandler(":_toggleSnowHandling_:", root,
	function(vehicle, state)
		if (isSetAlready) and (not state) then return end
		if (tonumber(getElementData(root, "roleplay:weather.snowing")) == 1) then
			if (vehicle) then
				if (getElementModel(v) ~= 431) then
					setVehicleHandling(vehicle, "engineAcceleration", 5)
					setVehicleHandling(vehicle, "engineInertia", 35)
					setVehicleHandling(vehicle, "tractionLoss", 0.6)
					setVehicleHandling(vehicle, "tractionBias", 0.7)
					setVehicleHandling(vehicle, "brakeDeceleration", 4)
					setVehicleHandling(vehicle, "brakeBias", 0.45)
				end
			else
				for i,v in ipairs(getElementsByType("vehicle")) do
					if (getElementModel(v) ~= 431) then
						setVehicleHandling(v, "engineAcceleration", 5)
						setVehicleHandling(v, "engineInertia", 35)
						setVehicleHandling(v, "tractionLoss", 0.6)
						setVehicleHandling(v, "tractionBias", 0.7)
						setVehicleHandling(v, "brakeDeceleration", 4)
						setVehicleHandling(v, "brakeBias", 0.45)
					end
				end
			end
			--outputDebugString("Vehicle handling set to 'Snowy'.")
		elseif (state) or (tonumber(getElementData(root, "roleplay:weather.snowing")) ~= 1) then
			if (vehicle) then
				if (getElementModel(vehicle) ~= 431) then
					setVehicleHandling(vehicle, true)
				end
			else
				for i,v in ipairs(getElementsByType("vehicle")) do
					if (getElementModel(v) ~= 431) then
						setVehicleHandling(v, true)
					end
				end
			end
			--outputDebugString("Vehicle handling set to 'Default'.")
		end
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function()
		triggerEvent(":_toggleSnowHandling_:", root)
	end
)