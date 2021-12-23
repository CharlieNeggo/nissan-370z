-- This Source Code Form is subject to the terms of the bCDDL, v. 1.1.
-- If a copy of the bCDDL was not distributed with this
-- file, You can obtain one at http://beamng.com/bCDDL-1.1.txt

local M = {}
M.type = "auxiliary"
M.relevantDevice = nil

local htmlTexture = require("htmlTexture")

local min = math.min
local max = math.max

local gaugesScreenName = nil
local htmlPath = nil

local previousFuel = 0
local fuelSmoother = newTemporalSmoothing(50, 50)
local fuelDisplaySmoother = newTemporalSmoothing(5, 3)
local avgFuelSum = 0
local avgFuelCounter = 0
local updateTimer = 0
local updateFPS = 60
local invFPS = 1 / updateFPS

local function updateGFX(dt)
  updateTimer = updateTimer + dt
  if updateTimer > invFPS then
    local data = {}
	local fuel = electrics.values.fuel*330
	local temp = (electrics.values.watertemp-50)*3.3
    local wheelspeed = electrics.values.wheelspeed or 0
	data.fuel = fuel
	data.temp = temp
  data.mode = mode

  if mode == "mode" then
		data.mode = electrics.values.mode
	else
		data.mode = electrics.values.modeIndex
	end 

	if gearboxType == "auto" then
		data.gear = electrics.values.gear
	else
		data.gear = electrics.values.gearIndex
	end
    data.time = os.date("%I:%M") -- done to prevent seconds from being sent.
    data.speed = wheelspeed
    --dump(data)

    htmlTexture.call(gaugesScreenName, "updateData", data)
    updateTimer = 0
  end
end

local function init(jbeamData)
  previousFuel = 0
  avgFuelSum = 0
  avgFuelCounter = 0
  fuelSmoother:reset()
  fuelDisplaySmoother:reset()

  gaugesScreenName = jbeamData.materialName
  htmlPath = jbeamData.htmlPath
  local gearboxType = jbeamData.gearboxType or "manual"
  local width = jbeamData.textureWidth or 512
  local height = jbeamData.textureHeight or 256

  if not gaugesScreenName then
    log("E", "n370zGauges", "Got no material name for the texture, can't display anything...")
    M.updateGFX = nop
  else
    if htmlPath then
      htmlTexture.create(gaugesScreenName, htmlPath, width, height, updateFPS, "automatic")
      htmlTexture.call(gaugesScreenName, "setUnits", {unitType = unitType})
    else
      log("E", "n370zGauges", "Got no html path for the texture, can't display anything...")
      M.updateGFX = nop
    end
  end
end

M.init = init
M.updateGFX = updateGFX

return M
