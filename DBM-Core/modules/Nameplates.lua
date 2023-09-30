local LD = DBM_CORE_L
local E
local NP
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
-----------------------------------
----------------------------------- dont delete anything
----------------------------------- fxpw fixes from retail
----------------------------------- only for ElvUI for now
-----------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------


local isElvUILoad = false

if ElvUI then
	E = unpack(ElvUI)
	NP = E:GetModule("NamePlates")
	if NP then
		isElvUILoad = true
	end
end

function DBM:CanUseNameplateIcons()
	return (isElvUILoad and DBM.Options.UseNPForElvUI) or false
end

-- globals
DBM.Nameplate = {}
-- locals

local units = {}
local num_units = 0


local twipe, floor = table.wipe, math.floor

--------------------
--  Create Frame  --
--------------------
local DBMNameplateFrame = CreateFrame("Frame", "DBMNameplate", UIParent)
DBMNameplateFrame:SetFrameStrata('BACKGROUND')
DBMNameplateFrame:Hide()

--------------------------
-- Aura frame functions --
--------------------------
local CreateAuraFrame
do
	local function AuraFrame_CreateIcon(frame)
		local icon = DBMNameplateFrame:CreateTexture(nil,'BACKGROUND',nil,0)
		icon:SetSize(DBM.Options.NPAuraSize, DBM.Options.NPAuraSize)
		icon:SetTexCoord(0.1,0.9,0.1,0.9)
		icon:Hide()

		tinsert(frame.iconsDBM,icon)

		return icon
	end
	local function AuraFrame_GetIcon(frame,texture)
		-- find unused icon or create new icon
		if not frame.iconsDBM or #frame.iconsDBM == 0 then
			return frame:CreateIcon()
		else
			if frame.texture_index[texture] then
				-- return icon already used for this texture
				return frame.texture_index[texture]
			else
				-- find unused icon:
				for _, icon in ipairs(frame.iconsDBM) do
					if not icon:IsShown() then
						return icon
					end
				end

				-- create new icon
				return frame:CreateIcon()
			end
		end
	end
	local function AuraFrame_ArrangeIcons(frame)
		if not frame.iconsDBM or #frame.iconsDBM == 0 then return end

		local prev,total_width,first_icon
		for _, icon in ipairs(frame.iconsDBM) do
			if icon:IsShown() then
				icon:ClearAllPoints()

				if not prev then
					total_width = 0
					first_icon = icon
					icon:SetPoint('BOTTOM',frame.parent,'TOP')
				else
					total_width = total_width + icon:GetWidth()
					icon:SetPoint('LEFT',prev,'RIGHT')
				end

				prev = icon
			end
		end

		if first_icon and total_width and total_width > 0 then
			-- shift first icon back to centre visible row
			first_icon:SetPoint('BOTTOM',frame.parent,'TOP',-floor(total_width/2),0)
		end
	end
	local function AuraFrame_AddAura(frame,aura_tbl)
		if not frame.iconsDBM then
			frame.iconsDBM = {}
		end
		if not frame.texture_index then
			frame.texture_index = {}
		end

		local icon = frame:GetIcon(aura_tbl.texture)
		icon:SetTexture(aura_tbl.texture)
		-- icon:SetTexCoord(0, 1, 0, 1)
		icon:Show()
		-- print(icon)
		frame.texture_index[aura_tbl.texture] = icon
		frame:ArrangeIcons()
	end
	local function AuraFrame_RemoveAura(frame,texture,batch)
		if not texture then return end
		if not frame.texture_index then return end

		local icon = frame.texture_index[texture]
		if not icon then return end

		icon:Hide()
		frame.texture_index[texture] = nil

		if not batch then
			frame:ArrangeIcons()
		end
	end
	local function AuraFrame_RemoveAll(frame)
		if not frame.iconsDBM or not frame.texture_index then return end

		for texture,_ in pairs(frame.texture_index) do
			frame:RemoveAura(texture,true)
		end
		twipe(frame.texture_index)
	end

	local auraframe_proto = {
		CreateIcon = AuraFrame_CreateIcon,
		GetIcon = AuraFrame_GetIcon,
		ArrangeIcons = AuraFrame_ArrangeIcons,
		AddAura = AuraFrame_AddAura,
		RemoveAura = AuraFrame_RemoveAura,
		RemoveAll = AuraFrame_RemoveAll,
	}
	auraframe_proto.__index = auraframe_proto

	function CreateAuraFrame(frame)
		if not frame then return end

		local new_frame = {}
		setmetatable(new_frame, auraframe_proto)
		new_frame.parent = frame

		return new_frame
	end
end
-------------------------
-- Nameplate functions --
-------------------------
local function Nameplate_OnHide(frame)
	if not frame then return end
	frame.DBMAuraFrame:RemoveAll()
end
local function HookNameplate(frame)
	if not frame then return end
	frame.DBMAuraFrame = CreateAuraFrame(frame)
	frame:HookScript('OnHide',Nameplate_OnHide)
end

local function Nameplate_AutoHide(self, isGUID, unit, spellId, texture)
	self:Hide(isGUID, unit, spellId, texture)
end

local function Nameplate_UnitAdded(frame,guid)
	if not frame or not guid then return end

	if not frame.DBMAuraFrame then
		HookNameplate(frame)
	end

	local unit_tbl

	if guid and units[guid] then
		unit_tbl = units[guid]
	end

	if unit_tbl and #unit_tbl > 0 then
		for _,aura_tbl in ipairs(unit_tbl) do
			frame.DBMAuraFrame:AddAura(aura_tbl)
		end
	end
end
----------------
--  On Event  --
----------------

-- DBMNameplateFrame:SetScript("OnEvent", function(_, event, ...)
-- 	if event == 'CHAT_MSG_ADDON' then
-- 		local prefix,guid,distribution,sender = ...
-- 		if prefix ~= "DBM_ShowIconAtPlate" then return end
-- 		-- local guid = ...
-- 		if not guid then return end
-- 		local f = NP:SearchNameplateByGUID(guid)
-- 		if not f then return end

-- 		Nameplate_UnitAdded(f,guid)
-- 	end
-- end)

-----------------
--  Functions  --
-----------------

--/run DBM:FireCustomEvent("DBM_ShowIconAtPlate", UnitGUID("target"))  no need

-- 	args 					 guid spellid  duration desaturate

-- /run DBM.Nameplate:Show(UnitGUID("target"), 309328,3) horde
-- /run DBM.Nameplate:Show(UnitGUID("target"), 309327) allience
-- /run DBM.Nameplate:Hide(UnitGUID("target"), 309327)



-- function nameplateFrame:SupportedNPMod()
-- 	if DBM:IsElvUILoad() and DBM.Options.UseNPForElvUI then return true end
-- 	return false
-- end

--isGUID: guid or name (bool)
function DBM.Nameplate:Show(guid, spellId, duration, desaturate)
	if not DBM:CanUseNameplateIcons() then return end
	-- if DBM.Options.DontShowNameplateIcons then return end
	-- ignore player nameplate;
	if not E or E.myguid == guid then return end

	--Texture Id passed as string so as not to get confused with spellID for GetSpellTexture
	local name, rank, currentTexture, castTime, minRange, maxRange, spellID = GetSpellInfo(spellId)
	-- local currentTexture = tonumber(texture) or texture or GetSpellTexture(spellId)

	-- Supported by nameplate mod, passing to their handler;
	-- if self:SupportedNPMod() then
	-- 	DBM:FireEvent("BossMod_ShowNameplateAura", true, guid, currentTexture, duration, desaturate)
	-- 	DBM:Debug("DBM.Nameplate Found supported NP mod, only sending Show callbacks", 3)
	-- 	return
	-- end

	--Not running supported NP Mod, internal handling
	if not self:IsShown() then
		DBMNameplateFrame:Show()
		-- DBMNameplateFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
		-- DBMNameplateFrame:RegisterEvent("CHAT_MSG_ADDON")
		DBM:Debug("DBM.Nameplate Enabling", 2)
	end

	if not units[guid] then
		units[guid] = {}
		num_units = num_units + 1
	end

	tinsert(units[guid], {
		texture = currentTexture
	})


	local frame = NP:SearchNameplateByGUID(guid)
	if frame then
		Nameplate_UnitAdded(frame, guid)
		if duration then
			DBM:Schedule(duration, Nameplate_AutoHide, self, true, guid, spellId, currentTexture)
		end
	end

end


function DBM.Nameplate:Hide(guid, spellId, force)
	if not DBM:CanUseNameplateIcons() then return end
	local name, rank, currentTexture, castTime, minRange, maxRange, spellID = GetSpellInfo(spellId)
	-- if self:SupportedNPMod() then
	-- 	DBM:Debug("DBM.Nameplate Found supported NP mod, only sending Hide callbacks", 3)

	-- 	if guid then
	-- 		DBM:FireEvent("BossMod_HideNameplateAura", true, guid, currentTexture)
	-- 	end

	-- 	return
	-- end

	--Not running supported NP Mod, internal handling
	if guid and units[guid] then
		if currentTexture then
			for i,aura_tbl in ipairs(units[guid]) do
				if aura_tbl.texture == currentTexture then
					tremove(units[guid],i)
					break
				end
			end
		end

		if not currentTexture or #units[guid] == 0 then
			units[guid] = nil
			num_units = num_units - 1
		end
	end

	local frame = NP:SearchNameplateByGUID(guid)
	if frame and frame.DBMAuraFrame then
		if not currentTexture then
			frame.DBMAuraFrame:RemoveAll()
		else
			frame.DBMAuraFrame:RemoveAura(currentTexture)
		end
	end

	-- disable nameplate hooking
	-- maybe that dont need?
	if force or num_units <= 0 then
		twipe(units)
		num_units = 0
		-- DBMNameplateFrame:UnregisterEvent("CHAT_MSG_ADDON")
		-- DBMNameplateFrame:UnregisterEvent("NAME_PLATE_UNIT_ADDED")
		DBMNameplateFrame:Hide()
		DBM:Debug("DBM.Nameplate Disabling", 2)
	end
end

function DBM.Nameplate:IsShown()
	return DBMNameplateFrame and DBMNameplateFrame:IsShown()
end

