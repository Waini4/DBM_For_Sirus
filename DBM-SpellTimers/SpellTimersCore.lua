--~spelltimerscore copu from statusbars

---------------
--  Globals  --
---------------
DBTST = {
	bars = {},
	numBars = 0
}
local DBTST = DBTST
local testMod
local testWarning1, testWarning2, testWarning3
local testTimer1, testTimer2, testTimer3, testTimer4, testTimer5, testTimer6, testTimer7, testTimer8
local testSpecialWarning1, testSpecialWarning2, testSpecialWarning3
local L = DBM_CORE_L

function DBM:DemoModeST()
	if not testMod then
		testMod = self:NewMod("TestMod")
		self:GetModLocalization("TestMod"):SetGeneralLocalization { name = "Test Mod" }
		testWarning1 = testMod:NewAnnounce("%s", 1, "Interface\\Icons\\Spell_Nature_WispSplode")
		testWarning2 = testMod:NewAnnounce("%s", 2, "Interface\\Icons\\Spell_Shadow_Shadesofdarkness")
		testWarning3 = testMod:NewAnnounce("%s", 3, "Interface\\Icons\\Spell_Fire_SelfDestruct")
		testTimer1 = testMod:NewTimer(20, "%s", "Interface\\Icons\\Spell_Nature_WispSplode", nil, nil)
		testTimer2 = testMod:NewTimer(20, "%s ", "Interface\\Icons\\INV_Misc_Head_Orc_01", nil, nil, 1)
		testTimer3 = testMod:NewTimer(20, "%s  ", "Interface\\Icons\\Spell_Shadow_Shadesofdarkness", nil, nil, 3, L.MAGIC_ICON
			, nil, 1, 4) --inlineIcon, keep, countdown, countdownMax
		testTimer4 = testMod:NewTimer(20, "%s   ", "Interface\\Icons\\Spell_Nature_WispSplode", nil, nil, 4, L.INTERRUPT_ICON)
		testTimer5 = testMod:NewTimer(20, "%s    ", "Interface\\Icons\\Spell_Fire_SelfDestruct", nil, nil, 2, L.HEALER_ICON,
			nil, 3, 4) --inlineIcon, keep, countdown, countdownMax
		testTimer6 = testMod:NewTimer(20, "%s     ", "Interface\\Icons\\Spell_Nature_WispSplode", nil, nil, 5, L.TANK_ICON, nil
			, 2, 4) --inlineIcon, keep, countdown, countdownMax
		testTimer7 = testMod:NewTimer(20, "%s      ", "Interface\\Icons\\Spell_Nature_WispSplode", nil, nil, 6)
		testTimer8 = testMod:NewTimer(20, "%s       ", "Interface\\Icons\\Spell_Nature_WispSplode", nil, nil, 7)
		testSpecialWarning1 = testMod:NewSpecialWarning("%s", nil, nil, nil, 1, 2)
		testSpecialWarning2 = testMod:NewSpecialWarning(" %s ", nil, nil, nil, 2, 2)
		testSpecialWarning3 = testMod:NewSpecialWarning("  %s  ", nil, nil, nil, 3, 2) -- hack: non auto-generated special warnings need distinct names (we could go ahead and give them proper names with proper localization entries, but this is much easier)
	end
	testTimer1:Stop("Test Bar")
	testTimer2:Stop("Adds")
	testTimer3:Stop("Evil Debuff")
	testTimer4:Stop("Important Interrupt")
	testTimer5:Stop("Boom!")
	testTimer6:Stop("Handle your Role")
	testTimer7:Stop("Next Stage")
	testTimer8:Stop("Custom User Bar")
	testTimer1:Start(10, "Test Bar")
	testTimer2:Start(30, "Adds")
	testTimer3:Start(43, "Evil Debuff")
	testTimer4:Start(20, "Important Interrupt")
	testTimer5:Start(60, "Boom!")
	testTimer6:Start(35, "Handle your Role")
	testTimer7:Start(50, "Next Stage")
	testTimer8:Start(55, "Custom User Bar")
	testWarning1:Cancel()
	testWarning2:Cancel()
	testWarning3:Cancel()
	testSpecialWarning1:Cancel()
	testSpecialWarning1:CancelVoice()
	testSpecialWarning2:Cancel()
	testSpecialWarning2:CancelVoice()
	testSpecialWarning3:Cancel()
	testSpecialWarning3:CancelVoice()
	testWarning1:Show("Test-mode started...")
	testWarning1:Schedule(62, "Test-mode finished!")
	testWarning3:Schedule(50, "Boom in 10 sec!")
	testWarning3:Schedule(20, "Pew Pew Laser Owl!")
	testWarning2:Schedule(38, "Evil Spell in 5 sec!")
	testWarning2:Schedule(43, "Evil Spell!")
	testWarning1:Schedule(10, "Test bar expired!")
	testSpecialWarning1:Schedule(20, "Pew Pew Laser Owl")
	testSpecialWarning1:ScheduleVoice(20, "runaway")
	testSpecialWarning2:Schedule(43, "Fear!")
	testSpecialWarning2:ScheduleVoice(43, "fearsoon")
	testSpecialWarning3:Schedule(60, "Boom!")
	testSpecialWarning3:ScheduleVoice(60, "defensive")
end

local ipairs, pairs, next, type, setmetatable, tinsert, tsort = ipairs, pairs, next, type, setmetatable, table.insert,
	table.sort
local UIParent = UIParent
local standardFont
if LOCALE_koKR then
	standardFont = "Fonts\\2002.TTF"
elseif LOCALE_zhCN then
	standardFont = "Fonts\\ARKai_T.ttf"
elseif LOCALE_zhTW then
	standardFont = "Fonts\\blei00d.TTF"
elseif LOCALE_ruRU then
	standardFont = "Fonts\\FRIZQT___CYR.TTF"
else
	standardFont = "Fonts\\FRIZQT__.TTF"
end

DBTST.DefaultOptions = {
	StartColorR = 1,
	StartColorG = 0.7,
	StartColorB = 0,
	EndColorR = 1,
	EndColorG = 0,
	EndColorB = 0,
	--Type 1 (Add)
	StartColorAR = 0.375,
	StartColorAG = 0.545,
	StartColorAB = 1,
	EndColorAR = 0.15,
	EndColorAG = 0.385,
	EndColorAB = 1,
	--Type 2 (AOE)
	StartColorAER = 1,
	StartColorAEG = 0.466,
	StartColorAEB = 0.459,
	EndColorAER = 1,
	EndColorAEG = 0.043,
	EndColorAEB = 0.247,
	--Type 3 (Targeted)
	StartColorDR = 0.9,
	StartColorDG = 0.3,
	StartColorDB = 1,
	EndColorDR = 1,
	EndColorDG = 0,
	EndColorDB = 1,
	--Type 4 (Interrupt)
	StartColorIR = 0.47,
	StartColorIG = 0.97,
	StartColorIB = 1,
	EndColorIR = 0.047,
	EndColorIG = 0.88,
	EndColorIB = 1,
	--Type 5 (Role)
	StartColorRR = 0.5,
	StartColorRG = 1,
	StartColorRB = 0.5,
	EndColorRR = 0.11,
	EndColorRG = 1,
	EndColorRB = 0.3,
	--Type 6 (Phase)
	StartColorPR = 1,
	StartColorPG = 0.776,
	StartColorPB = 0.420,
	EndColorPR = 0.5,
	EndColorPG = 0.41,
	EndColorPB = 0.285,
	--Type 7 (Important/User set only)
	StartColorUIR = 1,
	StartColorUIG = 1,
	StartColorUIB = 0.0627450980392157,
	EndColorUIR = 1,
	EndColorUIG = 0.92156862745098,
	EndColorUIB = 0.0117647058823529,
	Bar7ForceLarge = false,
	Bar7CustomInline = true,
	-- Small bar
	BarXOffset = 0,
	BarYOffset = 0,
	Width = 183,
	Height = 20,
	Alpha = 0.8,
	Scale = 0.9,
	TimerX = -100,
	TimerY = -260,
	ExpandUpwards = false,
	FillUpBars = true,
	TimerPoint = "TOPRIGHT",
	Sort = "Sort",
	DesaturateValue = 1,
	-- Huge bar
	EnlargeBarTime = 11,
	HugeBarXOffset = 0,
	HugeBarYOffset = 0,
	HugeWidth = 200,
	HugeHeight = 20,
	HugeAlpha = 1,
	HugeScale = 1.03,
	HugeTimerX = -50,
	HugeTimerY = -120,
	ExpandUpwardsLarge = false,
	FillUpLargeBars = true,
	HugeBarsEnabled = true,
	HugeTimerPoint = "CENTER",
	HugeSort = "Sort",
	-- Misc
	TextColorR = 1,
	TextColorG = 1,
	TextColorB = 1,
	TDecimal = 11,
	FontSize = 10,
	FlashBar = false,
	Spark = true,
	ColorByType = true,
	NoBarFade = false,
	InlineIcons = true,
	IconLeft = true,
	IconRight = false,
	IconLocked = true,
	DynamicColor = true,
	ClickThrough = false,
	StripCDText = false,
	KeepBars = true,
	FadeBars = true,
	Texture = "Interface\\AddOns\\DBM-StatusBarTimers\\textures\\default.blp",
	Font = "standardFont",
	FontFlag = "None",
	BarStyle = "NoAnim",
	Skin = ""
}

local barPrototypeST, unusedBarObjectsST, barIsAnimatingST = {}, {}, false
local smallBarsST, largeBarsST = {}, {}

local smallBarsAnchorST, largeBarsAnchorST = CreateFrame("Frame", nil, UIParent), CreateFrame("Frame", nil, UIParent)
smallBarsAnchorST:SetSize(1, 1)
smallBarsAnchorST:SetPoint("TOPRIGHT", -100, -260)
smallBarsAnchorST:SetClampedToScreen(true)
smallBarsAnchorST:SetMovable(true)
smallBarsAnchorST:Show()
largeBarsAnchorST:SetSize(1, 1)
largeBarsAnchorST:SetPoint("CENTER", -50, -120)
largeBarsAnchorST:SetClampedToScreen(true)
largeBarsAnchorST:SetMovable(true)
largeBarsAnchorST:Show()


function DBTST:AddDefaultOptions(t1, t2)
	for i, v in pairs(t2) do
		if t1[i] == nil then
			t1[i] = v
		elseif type(v) == "table" and type(t1[i]) == "table" then
			self:AddDefaultOptions(t1[i], v)
		end
	end
end

do
	local CreateFrame, GetTime, IsShiftKeyDown = CreateFrame, GetTime, IsShiftKeyDown

	local function onUpdate(self)
		if self.obj then
			self.obj.curTime = GetTime()
			self.obj.delta = self.obj.curTime - self.obj.lastUpdate
			if barIsAnimatingST and self.obj.delta >= 0.01 or self.obj.delta >= 0.02 then
				self.obj.lastUpdate = self.obj.curTime
				self.obj:Update(self.obj.delta)
			end
		end
	end

	local function onMouseDown(self, btn)
		if self.obj and btn == "LeftButton" and DBTST.movable then
			if self.obj.enlarged then
				largeBarsAnchorST:StartMoving()
			else
				smallBarsAnchorST:StartMoving()
			end
		end
	end

	local function onMouseUp(self, btn)
		if self.obj then
			smallBarsAnchorST:StopMovingOrSizing()
			largeBarsAnchorST:StopMovingOrSizing()
			DBTST:SavePosition()
			if btn == "RightButton" then
				self.obj:Cancel()
			elseif btn == "LeftButton" and IsShiftKeyDown() then
				self.obj:Announce()
			end
		end
	end

	local function onHide(self)
		smallBarsAnchorST:StopMovingOrSizing()
		largeBarsAnchorST:StopMovingOrSizing()
	end

	local fCounterST = 1

	local function createBarFrameST(self)
		local frame = CreateFrame("Frame", "DBT_Bar_ST_" .. fCounterST, smallBarsAnchorST)
		frame:SetSize(195, 20)
		frame:SetScript("OnUpdate", onUpdate)
		frame:SetScript("OnMouseDown", onMouseDown)
		frame:SetScript("OnMouseUp", onMouseUp)
		frame:SetScript("OnHide", onHide)
		local bar = CreateFrame("StatusBar", "$parentBar", frame)
		bar:SetPoint("CENTER", frame, "CENTER")
		bar:SetSize(195, 20)
		bar:SetMinMaxValues(0, 1)
		bar:SetStatusBarTexture(self.Options.Texture)
		bar:SetStatusBarColor(1, 0.7, 0)
		local barBackdrop = {
			bgFile = "Interface\\Buttons\\WHITE8X8",
		}
		bar:SetBackdrop(barBackdrop)
		bar:SetBackdropColor(0, 0, 0, 0.3)
		local spark = bar:CreateTexture("$parentSpark", "OVERLAY")
		spark:SetPoint("CENTER", bar, "CENTER")
		spark:SetSize(32, 64)
		spark:SetTexture("Interface\\AddOns\\DBM-StatusBarTimers\\textures\\Spark.blp")
		spark:SetBlendMode("ADD")
		local timer = bar:CreateFontString("$parentTimer", "OVERLAY", "GameFontHighlightSmall")
		timer:SetPoint("RIGHT", bar, "RIGHT", -1, 0.5)
		local name = bar:CreateFontString("$parentName", "OVERLAY", "GameFontHighlightSmall")
		name:SetPoint("LEFT", bar, "LEFT", 7, 0.5)
		name:SetPoint("RIGHT", timer, "LEFT", -7, 0)
		name:SetWordWrap(false)
		name:SetJustifyH("LEFT")
		local icon1 = bar:CreateTexture("$parentIcon1", "OVERLAY")
		icon1:SetPoint("RIGHT", bar, "LEFT")
		icon1:SetSize(20, 20)
		local icon2 = bar:CreateTexture("$parentIcon2", "OVERLAY")
		icon2:SetPoint("LEFT", bar, "RIGHT")
		icon2:SetSize(20, 20)

		fCounterST = fCounterST + 1

		frame:EnableMouse(not self.Options.ClickThrough or self.movable)
		return frame
	end

	local mtST = { __index = barPrototypeST }

	function DBTST:CreateBar(timer, id, icon, huge, small, color, isDummy, colorType, inlineIcon, keep, fade, countdown,
	                         countdownMax)
		if (not timer or type(timer) == "string" or timer <= 0) or (self.numBars >= 15 and not isDummy) then
			return
		end
		-- Most efficient place to block it, nil colorType instead of checking option every update
		if not self.Options.ColorByType then
			colorType = nil
		end
		local newBar = self:GetBar(id)
		if newBar then -- Update an existing bar
			newBar.lastUpdate = GetTime()
			newBar.huge = huge or nil
			newBar.paused = nil
			newBar:SetTimer(timer) -- This can kill the timer and the timer methods don't like dead timers
			if newBar.dead then
				return
			end
			newBar:SetElapsed(0)
			if newBar.dead then
				return
			end
			newBar:ApplyStyle()
			newBar:SetText(id)
			newBar:SetIcon(icon)
		else -- Create a new bar
			newBar = next(unusedBarObjectsST)
			if newBar then
				newBar.lastUpdate = GetTime()
				unusedBarObjectsST[newBar] = nil
				newBar.dead = nil -- Resurrected it :)
				newBar.id = id
				newBar.timer = timer
				newBar.totalTime = timer
				newBar.moving = nil
				newBar.enlarged = nil
				newBar.fadingIn = 0
				newBar.small = small
				newBar.color = color
				newBar.colorType = colorType
				newBar.flashing = nil
				newBar.inlineIcon = inlineIcon
				newBar.keep = keep
				newBar.fade = fade
				newBar.countdown = countdown
				newBar.countdownMax = countdownMax
			else -- Duplicate code ;(
				local newFrame = createBarFrameST(self)
				newBar = setmetatable({
					frame = newFrame,
					id = id,
					timer = timer,
					totalTime = timer,
					owner = self,
					moving = nil,
					enlarged = nil,
					fadingIn = 0,
					small = small,
					color = color,
					flashing = nil,
					colorType = colorType,
					inlineIcon = inlineIcon,
					keep = keep,
					fade = fade,
					countdown = countdown,
					countdownMax = countdownMax,
					lastUpdate = GetTime()
				}, mtST)
				newFrame.obj = newBar
			end
			self.numBars = self.numBars + 1
			if (
				(colorType and colorType == 7 and self.Options.Bar7ForceLarge) or
					(timer <= (self.Options.EnlargeBarTime or 11) or huge)) and self.Options.HugeBarsEnabled then -- Start enlarged
				newBar.enlarged = true
				newBar.huge = true
				tinsert(largeBarsST, newBar)
			else
				newBar.huge = nil
				tinsert(smallBarsST, newBar)
			end
			newBar:SetText(id)
			newBar:SetIcon(icon)
			self.bars[newBar] = true
			self:UpdateBars(true)
			newBar:ApplyStyle()
			newBar:Update(0)
		end
		return newBar
	end
end

do
	-- local gsub = string.gsub

	-- local function fixElv(optionName)
	-- 	if DBTST.Options[optionName]:lower():find("interface\\addons\\elvui\\media\\") then
	-- 		DBTST.Options[optionName] = gsub(DBTST.Options[optionName], gsub("Interface\\AddOns\\ElvUI\\Media\\", "(%a)", function(v)
	-- 			return "[" .. v:upper() .. v:lower() .. "]"
	-- 		end), "Interface\\AddOns\\ElvUI\\Core\\Media\\")
	-- 	end
	-- end

	function DBTST:LoadOptions(id)
		if not DBT_AllPersistentOptions then
			DBT_AllPersistentOptions = {}
		end
		local DBM_UsedProfile = DBM_UsedProfile or "Default"
		if not DBT_AllPersistentOptions[DBM_UsedProfile] then
			DBT_AllPersistentOptions[DBM_UsedProfile] = {}
		end
		DBT_AllPersistentOptions[DBM_UsedProfile][id] = DBT_AllPersistentOptions[DBM_UsedProfile][id] or {}
		self:AddDefaultOptions(DBT_AllPersistentOptions[DBM_UsedProfile][id], self.DefaultOptions)
		self.Options = DBT_AllPersistentOptions[DBM_UsedProfile][id]
		self:Rearrange()
		-- Fix font if it's nil or set to any of standard font values
		if not self.Options.Font or
			(
			self.Options.Font == "Fonts\\2002.TTF" or self.Options.Font == "Fonts\\ARKai_T.ttf" or
				self.Options.Font == "Fonts\\blei00d.TTF" or self.Options.Font == "Fonts\\FRIZQT___CYR.TTF" or
				self.Options.Font == "Fonts\\FRIZQT__.TTF") then
			self.Options.Font = self.DefaultOptions.Font
		end
		-- Migrate texture from default skin to internal
		if self.Options.Texture == "Interface\\AddOns\\DBM-DefaultSkin\\textures\\default.blp" then
			self.Options.Texture = self.DefaultOptions.Texture
		end
		-- Migrate sort
		if self.Options.Sort == true then
			self.Options.Sort = "Sort"
		end
		-- Migrate ElvUI changes
		-- fixElv("Texture")
		-- fixElv("Font")
	end

	function DBTST:CreateProfile(id)
		if not id or id == "" or id:find(" ") then
			self:AddMsg(DBM_CORE_L.PROFILE_CREATE_ERROR)
			return
		end
		local DBM_UsedProfile = DBM_UsedProfile or "Default"
		if not DBT_AllPersistentOptions then
			DBT_AllPersistentOptions = {}
		end
		if not DBT_AllPersistentOptions[DBM_UsedProfile] then
			DBT_AllPersistentOptions[DBM_UsedProfile] = {}
		end
		if DBT_AllPersistentOptions[DBM_UsedProfile][id] then
			DBM:AddMsg(DBM_CORE_L.PROFILE_CREATE_ERROR_D:format(id))
			return
		end
		DBT_AllPersistentOptions[DBM_UsedProfile][id] = DBT_AllPersistentOptions[DBM_UsedProfile][id] or {}
		self:AddDefaultOptions(DBT_AllPersistentOptions[DBM_UsedProfile][id], self.DefaultOptions)
		self.Options = DBT_AllPersistentOptions[DBM_UsedProfile][id]
		self:Rearrange()
		DBM:AddMsg(DBM_CORE_L.PROFILE_CREATED:format(id))
	end

	function DBTST:ApplyProfile(id, hasPrinted)
		if not DBT_AllPersistentOptions then
			DBT_AllPersistentOptions = {}
		end
		local DBM_UsedProfile = DBM_UsedProfile or "Default"
		if not id or not DBT_AllPersistentOptions[DBM_UsedProfile] or not DBT_AllPersistentOptions[DBM_UsedProfile][id] then
			DBM:AddMsg(DBM_CORE_L.PROFILE_APPLY_ERROR:format(id or DBM_CORE_L.UNKNOWN))
			return
		end
		self:AddDefaultOptions(DBT_AllPersistentOptions[DBM_UsedProfile][id], self.DefaultOptions)
		self.Options = DBT_AllPersistentOptions[DBM_UsedProfile][id]
		self:Rearrange()
		if not hasPrinted then
			DBM:AddMsg(DBM_CORE_L.PROFILE_APPLIED:format(id))
		end
	end

	function DBTST:CopyProfile(name, id, hasPrinted)
		if not DBT_AllPersistentOptions then
			DBT_AllPersistentOptions = {}
		end
		local DBM_UsedProfile = DBM_UsedProfile or "Default"
		if not hasPrinted then
			if not name or not DBT_AllPersistentOptions[name] then
				DBM:AddMsg(DBM_CORE_L.PROFILE_COPY_ERROR:format(name or DBM_CORE_L.UNKNOWN))
				return
			elseif name == DBM_UsedProfile then
				DBM:AddMsg(DBM_CORE_L.PROFILE_COPY_ERROR_SELF)
				return
			end
		end
		if not DBT_AllPersistentOptions[DBM_UsedProfile] then
			DBT_AllPersistentOptions[DBM_UsedProfile] = {}
		end
		if not DBT_AllPersistentOptions[name] then
			DBT_AllPersistentOptions[name] = {}
		end
		DBT_AllPersistentOptions[DBM_UsedProfile][id] = DBT_AllPersistentOptions[name][id] or {}
		self:AddDefaultOptions(DBT_AllPersistentOptions[DBM_UsedProfile][id], self.DefaultOptions)
		self.Options = DBT_AllPersistentOptions[DBM_UsedProfile][id]
		self:Rearrange()
		if not hasPrinted then
			DBM:AddMsg(DBM_CORE_L.PROFILE_COPIED:format(name))
		end
	end

	function DBTST:DeleteProfile(name, id)
		if not DBT_AllPersistentOptions then
			DBT_AllPersistentOptions = {}
		end
		if name == "Default" or not DBT_AllPersistentOptions[name] then
			return
		end
		DBT_AllPersistentOptions[name] = nil
		local DBM_UsedProfile = DBM_UsedProfile or "Default"
		self.Options = DBT_AllPersistentOptions[DBM_UsedProfile][id]
		self:Rearrange()
	end

	function DBTST:Rearrange()
		smallBarsAnchorST:ClearAllPoints()
		largeBarsAnchorST:ClearAllPoints()
		smallBarsAnchorST:SetPoint(self.Options.TimerPoint, UIParent, self.Options.TimerPoint, self.Options.TimerX,
			self.Options.TimerY)
		largeBarsAnchorST:SetPoint(self.Options.HugeTimerPoint, UIParent, self.Options.HugeTimerPoint, self.Options.HugeTimerX
			, self.Options.HugeTimerY)
		self:ApplyStyle()
	end
end

do
	local oldInfoFrameLocked, oldRangeFrameLocked

	local function updateClickThrough(self, newValue)
		if not self.movable then
			for bar in self:GetBarIterator() do
				if not bar.dummy then
					bar.frame:EnableMouse(not newValue)
				end
			end
		end
	end

	function DBTST:ShowMovableBar(small, large)
		if small or small == nil then
			self:CreateBar(20, "Move1", "Interface\\Icons\\Spell_Nature_WispSplode", nil, true):SetText(DBM_CORE_L.MOVABLE_BAR)
		end
		updateClickThrough(self, false)
		self.movable = true
	end

	function DBTST:SetOption(option, value, noUpdate)
		if option == "ExpandUpwards" or option == "ExpandUpwardsLarge" or option == "BarYOffset" or option == "BarXOffset" or
			option == "HugeBarYOffset" or option == "HugeBarXOffset" then
			for bar in self:GetBarIterator() do
				if not bar.dummy then
					if bar.moving == "enlarge" then
						bar.enlarged = true
						bar.moving = nil
						tinsert(largeBarsST, bar)
					else
						bar.moving = nil
					end
				end
			end
		elseif option == "ClickThrough" then
			updateClickThrough(self, value)
		end
		self.Options[option] = value
		if not noUpdate then
			self:UpdateBars(true)
			self:ApplyStyle()
		end
	end
end

do
	local dummyBars = 0
	local function dummyCancel(self)
		self.timer = self.totalTime
		self.flashing = nil
		self:Update(0)
		self.flashing = nil
		_G[self.frame:GetName() .. "BarSpark"]:SetAlpha(1)
	end

	function DBTST:CreateDummyBar(colorType, inlineIcon, text)
		dummyBars = dummyBars + 1
		local dummy = self:CreateBar(25, "dummy" .. dummyBars, "Interface\\Icons\\Spell_Nature_WispSplode", nil, true, nil,
			true, colorType, inlineIcon)
		dummy:SetText(text or "Dummy", inlineIcon)
		dummy:Cancel()
		self.bars[dummy] = true
		unusedBarObjectsST[dummy] = nil
		dummy.frame:SetParent(UIParent)
		dummy.frame:ClearAllPoints()
		dummy.frame:SetScript("OnUpdate", nil)
		dummy.Cancel = dummyCancel
		dummy:ApplyStyle()
		dummy.dummy = true
		return dummy
	end
end

function DBTST:GetBarIterator()
	if not self.bars then
		DBM:Debug("GetBarIterator failed for unknown reasons")
		return
	end
	return pairs(self.bars)
end

function DBTST:GetBar(id)
	for bar in self:GetBarIterator() do
		if id == bar.id then
			return bar
		end
	end
end

function DBTST:CancelBar(id)
	for bar in self:GetBarIterator() do
		if id == bar.id then
			bar.paused = nil
			bar:Cancel()
			return true
		end
	end
	return false
end

function DBTST:UpdateBar(id, elapsed, totalTime)
	for bar in self:GetBarIterator() do
		if id == bar.id then
			bar:SetTimer(totalTime or bar.totalTime)
			bar:SetElapsed(elapsed or self.totalTime - self.timer)
			return true
		end
	end
	return false
end

function DBTST:SetAnnounceHook(f)
	self.announceHook = f
end

function DBTST:UpdateBars(sortBars)
	if sortBars and self.Options.Sort ~= "None" then
		tsort(largeBarsST, function(x, y)
			if self.Options.HugeSort == "Invert" then
				return x.timer < y.timer
			end
			return x.timer > y.timer
		end)
		tsort(smallBarsST, function(x, y)
			if self.Options.Sort == "Invert" then
				return x.timer < y.timer
			end
			return x.timer > y.timer
		end)
	end
	for i, bar in ipairs(largeBarsST) do
		bar.frame:ClearAllPoints()
		bar.frame:SetPoint("TOP", largeBarsAnchorST, "TOP", (i - 1) * self.Options.HugeBarXOffset,
			((i - 1) * (self.Options.HugeHeight + self.Options.HugeBarYOffset)) * (self.Options.ExpandUpwardsLarge and 1 or -1))
	end
	for i, bar in ipairs(smallBarsST) do
		bar.frame:ClearAllPoints()
		bar.frame:SetPoint("TOP", smallBarsAnchorST, "TOP", (i - 1) * self.Options.BarXOffset,
			((i - 1) * (self.Options.Height + self.Options.BarYOffset)) * (self.Options.ExpandUpwards and 1 or -1))
	end
end

function DBTST:ApplyStyle()
	for bar in self:GetBarIterator() do
		bar:ApplyStyle()
	end
end

function DBTST:SavePosition()
	local point, _, _, x, y = smallBarsAnchorST:GetPoint(1)
	self:SetOption("TimerPoint", point)
	self:SetOption("TimerX", x)
	self:SetOption("TimerY", y)
	point, _, _, x, y = largeBarsAnchorST:GetPoint(1)
	self:SetOption("HugeTimerPoint", point)
	self:SetOption("HugeTimerX", x)
	self:SetOption("HugeTimerY", y)
end

function DBTST:ShowTestBars()
	self:CreateBar(10, "Test 1", "Interface\\Icons\\Spell_Nature_WispSplode")
	self:CreateBar(14, "Test 2", "Interface\\Icons\\Spell_Nature_WispSplode")
	self:CreateBar(20, "Test 3", "Interface\\Icons\\Spell_Nature_WispSplode")
	self:CreateBar(12, "Test 4", "Interface\\Icons\\Spell_Nature_WispSplode")
	self:CreateBar(21.5, "Test 5", "Interface\\Icons\\Spell_Nature_WispSplode")
end

function barPrototypeST:SetTimer(timer)
	self.totalTime = timer
	self:Update(0)
end

function barPrototypeST:ResetAnimations(makeBig)
	self:RemoveFromList()
	self.moving = nil
	if DBTST.Options.HugeBarsEnabled and makeBig then
		self.enlarged = true
		tinsert(largeBarsST, self)
	else
		self.enlarged = nil
		tinsert(smallBarsST, self)
	end
	self:ApplyStyle()
end

function barPrototypeST:Pause()
	self.flashing = nil
	self.ftimer = nil
	self:Update(0)
	self.paused = true
	self:ResetAnimations() -- Forces paused bar into small bars so they don't clutter huge bars anchor
	DBTST:UpdateBars(true)
end

function barPrototypeST:Resume()
	self.paused = nil
	DBTST:UpdateBars(true)
end

function barPrototypeST:SetElapsed(elapsed)
	self.timer = self.totalTime - elapsed
	local enlargeTime = DBTST.Options.EnlargeBarTime or 11
	-- Bar was large, or moving (animating from the small to large bar anchor) at time this was called
	-- Force reset animation and move it back to the small anchor since time was added to bar
	if (self.enlarged or self.moving == "enlarge") and self.timer > enlargeTime then
		self:ResetAnimations()
		-- Bar was small, or moving from small to large when time was removed
		-- Also force reset animation but this time move it from small anchor into large one
	elseif (not self.enlarged or self.moving == "enlarge") and self.timer <= enlargeTime then
		self:ResetAnimations(true)
	end
	self:Update(0)
	DBTST:UpdateBars(true)
end

function barPrototypeST:SetText(text, inlineIcon)
	if not DBTST.Options.InlineIcons then
		inlineIcon = nil
	end
	-- Force change color type 7 to custom inlineIcon
	_G[self.frame:GetName() .. "BarName"]:SetText((
		(self.colorType and self.colorType == 7 and DBTST.Options.Bar7CustomInline) and DBM_COMMON_L.IMPORTANT_ICON or
			inlineIcon or "") .. text)
end

function barPrototypeST:SetIcon(icon)
	local frame_name = self.frame:GetName()
	_G[frame_name .. "BarIcon1"]:SetTexture(icon)
	_G[frame_name .. "BarIcon2"]:SetTexture(icon)
end

function barPrototypeST:SetColor(color)
	-- Fix to allow colors not require the table keys
	if color[1] and not color.r then
		color = {
			r = color[1],
			g = color[2],
			b = color[3]
		}
	end
	self.color = color
	local frame_name = self.frame:GetName()
	_G[frame_name .. "Bar"]:SetStatusBarColor(color.r, color.g, color.b)
	_G[frame_name .. "BarSpark"]:SetVertexColor(color.r, color.g, color.b)
end

local colorVariables = {
	[1] = "A", --Add
	[2] = "AE", --AoE
	[3] = "D", --Debuff/Targeted attack
	[4] = "I", --Interrupt
	[5] = "R", --Role
	[6] = "P", --Phase
	[7] = "UI", --User
}

local function stringFromTimer(t)
	if t <= DBTST.Options.TDecimal then
		return ("%.1f"):format(t)
	elseif t <= 60 then
		return ("%d"):format(t)
	else
		return ("%d:%0.2d"):format(t / 60, math.fmod(t, 60))
	end
end

function barPrototypeST:Update(elapsed)
	local frame = self.frame
	local frame_name = frame:GetName()
	local bar = _G[frame_name .. "Bar"]
	local spark = _G[frame_name .. "BarSpark"]
	local timer = _G[frame_name .. "BarTimer"]
	local paused = self.paused
	self.timer = self.timer - (paused and 0 or elapsed)
	local timerValue = self.timer
	local totaltimeValue = self.totalTime
	local barOptions = DBTST.Options
	local currentStyle = barOptions.BarStyle
	local sparkEnabled = barOptions.Spark
	local isMoving = self.moving
	local isFadingIn = self.fadingIn
	local colorCount = self.colorType
	local enlargeEnabled = DBTST.Options.HugeBarsEnabled
	local enlargeHack = self.dummyEnlarge or colorCount == 7 and barOptions.Bar7ForceLarge and enlargeEnabled
	local enlargeTime = barOptions.EnlargeBarTime or 11
	local isEnlarged = self.enlarged and not paused
	local fillUpBars = isEnlarged and barOptions.FillUpLargeBars or not isEnlarged and barOptions.FillUpBars
	local ExpandUpwards = isEnlarged and barOptions.ExpandUpwardsLarge or not isEnlarged and barOptions.ExpandUpwards
	if barOptions.DynamicColor and not self.color then
		local r, g, b
		if colorCount and colorCount >= 1 then
			local colorVar = colorVariables[colorCount]
			if barOptions.NoBarFade then
				r = isEnlarged and barOptions["EndColor" .. colorVar .. "R"] or barOptions["StartColor" .. colorVar .. "R"]
				g = isEnlarged and barOptions["EndColor" .. colorVar .. "G"] or barOptions["StartColor" .. colorVar .. "G"]
				b = isEnlarged and barOptions["EndColor" .. colorVar .. "B"] or barOptions["StartColor" .. colorVar .. "B"]
			else
				r = barOptions["StartColor" .. colorVar .. "R"] +
					(barOptions["EndColor" .. colorVar .. "R"] - barOptions["StartColor" .. colorVar .. "R"]) *
					(1 - timerValue / totaltimeValue)
				g = barOptions["StartColor" .. colorVar .. "G"] +
					(barOptions["EndColor" .. colorVar .. "G"] - barOptions["StartColor" .. colorVar .. "G"]) *
					(1 - timerValue / totaltimeValue)
				b = barOptions["StartColor" .. colorVar .. "B"] +
					(barOptions["EndColor" .. colorVar .. "B"] - barOptions["StartColor" .. colorVar .. "B"]) *
					(1 - timerValue / totaltimeValue)
			end
		else
			if barOptions.NoBarFade then
				r = isEnlarged and barOptions.EndColorR or barOptions.StartColorR
				g = isEnlarged and barOptions.EndColorG or barOptions.StartColorG
				b = isEnlarged and barOptions.EndColorB or barOptions.StartColorB
			else
				r = barOptions.StartColorR + (barOptions.EndColorR - barOptions.StartColorR) * (1 - timerValue / totaltimeValue)
				g = barOptions.StartColorG + (barOptions.EndColorG - barOptions.StartColorG) * (1 - timerValue / totaltimeValue)
				b = barOptions.StartColorB + (barOptions.EndColorB - barOptions.StartColorB) * (1 - timerValue / totaltimeValue)
			end
		end
		if not enlargeEnabled and timerValue > enlargeTime then
			r, g, b = barOptions.DesaturateValue * r, barOptions.DesaturateValue * g, barOptions.DesaturateValue * b
		end
		bar:SetStatusBarColor(r, g, b)
		if sparkEnabled then
			spark:SetVertexColor(r, g, b)
		end
	end
	if timerValue <= 0 and not (barOptions.KeepBars and self.keep) then
		return self:Cancel()
	else
		if fillUpBars then
			if currentStyle == "NoAnim" and timerValue <= enlargeTime and not enlargeHack then
				-- Simple/NoAnim Bar mimics BW in creating a new bar on large bar anchor instead of just moving the small bar
				bar:SetValue(1 - timerValue / (totaltimeValue < enlargeTime and totaltimeValue or enlargeTime))
			else
				bar:SetValue(1 - timerValue / totaltimeValue)
			end
		else
			if currentStyle == "NoAnim" and timerValue <= enlargeTime and not enlargeHack then
				-- Simple/NoAnim Bar mimics BW in creating a new bar on large bar anchor instead of just moving the small bar
				bar:SetValue(timerValue / (totaltimeValue < enlargeTime and totaltimeValue or enlargeTime))
			else
				bar:SetValue(timerValue / totaltimeValue)
			end
		end
		timer:SetText(stringFromTimer(timerValue))
	end
	if isFadingIn and isFadingIn < 0.5 and currentStyle ~= "NoAnim" then
		self.fadingIn = isFadingIn + elapsed
		if (isEnlarged and barOptions.HugeAlpha == 1) or barOptions.Alpha == 1 then -- Only fade in if alpha is 1, otherwise we already have a faded bar
			frame:SetAlpha((isFadingIn) / 0.5)
		end
	elseif isFadingIn then
		self.fadingIn = nil
	end
	if timerValue <= 7.75 and not self.flashing and barOptions.FlashBar and not paused then
		self.flashing = true
		self.ftimer = 0
	elseif self.flashing and timerValue > 7.75 then
		self.flashing = nil
		self.ftimer = nil
	end
	if sparkEnabled then
		spark:ClearAllPoints()
		spark:SetSize(12, barOptions[isEnlarged and 'HugeHeight' or 'Height'] * 3)
		spark:SetPoint("CENTER", bar, "LEFT", bar:GetValue() * bar:GetWidth(), -1)
	else
		spark:SetAlpha(0)
	end
	if self.flashing then
		local r, g, b = bar:GetStatusBarColor()
		local ftime = self.ftimer % 1.25
		if ftime >= 0.5 then
			bar:SetStatusBarColor(r, g, b, 1)
			if sparkEnabled then
				spark:SetAlpha(1)
			end
		elseif ftime >= 0.25 then
			bar:SetStatusBarColor(r, g, b, 1 - (0.5 - ftime) / 0.25)
			if sparkEnabled then
				spark:SetAlpha(1 - (0.5 - ftime) / 0.25)
			end
		else
			bar:SetStatusBarColor(r, g, b, 1 - (ftime / 0.25))
			if sparkEnabled then
				spark:SetAlpha(1 - (ftime / 0.25))
			end
		end
		self.ftimer = self.ftimer + elapsed
	end
	local melapsed = self.moveElapsed
	if isMoving == "move" and melapsed <= 0.5 then
		barIsAnimatingST = true
		self.moveElapsed = melapsed + elapsed
		local newX = self.moveOffsetX +
			(barOptions[isEnlarged and "HugeBarXOffset" or "BarXOffset"] - self.moveOffsetX) * (melapsed / 0.5)
		local newY
		if ExpandUpwards then
			newY = self.moveOffsetY +
				(barOptions[isEnlarged and "HugeBarYOffset" or "BarYOffset"] - self.moveOffsetY) * (melapsed / 0.5)
		else
			newY = self.moveOffsetY +
				(-barOptions[isEnlarged and "HugeBarYOffset" or "BarYOffset"] - self.moveOffsetY) * (melapsed / 0.5)
		end
		frame:ClearAllPoints()
		frame:SetPoint(self.movePoint, self.moveAnchor, self.movePoint, newX, newY)
	elseif isMoving == "move" then
		barIsAnimatingST = false
		self.moving = nil
		isMoving = nil
	elseif isMoving == "enlarge" and melapsed <= 1 then
		barIsAnimatingST = true
		self:AnimateEnlarge(elapsed)
	elseif isMoving == "enlarge" then
		barIsAnimatingST = false
		self.moving = nil
		isMoving = nil
		self.enlarged = true
		isEnlarged = true
		tinsert(largeBarsST, self)
		self:ApplyStyle()
		DBTST:UpdateBars(true)
	elseif isMoving == "nextEnlarge" then
		barIsAnimatingST = false
		self.moving = nil
		isMoving = nil
		self.enlarged = true
		isEnlarged = true
		tinsert(largeBarsST, self)
		self:ApplyStyle()
		DBTST:UpdateBars(true)
	end
	if not paused and (timerValue <= enlargeTime) and not self.small and not isEnlarged and isMoving ~= "enlarge" and
		enlargeEnabled then
		self:RemoveFromList()
		self:Enlarge()
	end
	DBTST:UpdateBars()
end

function barPrototypeST:RemoveFromList()
	if self.moving ~= "enlarge" then
		tDeleteItem(self.enlarged and largeBarsST or smallBarsST, self)
	end
end

function barPrototypeST:Cancel()
	self.frame:Hide()
	self:RemoveFromList()
	DBTST.bars[self] = nil
	unusedBarObjectsST[self] = self
	self.dead = true
	DBTST.numBars = DBTST.numBars - 1
end

function barPrototypeST:ApplyStyle()
	local frame = self.frame
	local frame_name = frame:GetName()
	local bar = _G[frame_name .. "Bar"]
	local spark = _G[frame_name .. "BarSpark"]
	local icon1 = _G[frame_name .. "BarIcon1"]
	local icon2 = _G[frame_name .. "BarIcon2"]
	local name = _G[frame_name .. "BarName"]
	local timer = _G[frame_name .. "BarTimer"]
	local barOptions = DBTST.Options
	local sparkEnabled = barOptions.Spark
	local enlarged = self.enlarged
	if self.color then
		local barRed, barGreen, barBlue = self.color.r, self.color.g, self.color.b
		bar:SetStatusBarColor(barRed, barGreen, barBlue)
		if sparkEnabled then
			spark:SetVertexColor(barRed, barGreen, barBlue)
		end
	else
		local barStartRed, barStartGreen, barStartBlue
		if self.colorType then
			local colorCount = self.colorType
			if colorCount == 1 then --Add
				barStartRed, barStartGreen, barStartBlue = barOptions.StartColorAR, barOptions.StartColorAG, barOptions.StartColorAB
			elseif colorCount == 2 then --AOE
				barStartRed, barStartGreen, barStartBlue = barOptions.StartColorAER, barOptions.StartColorAEG,
					barOptions.StartColorAEB
			elseif colorCount == 3 then --Debuff
				barStartRed, barStartGreen, barStartBlue = barOptions.StartColorDR, barOptions.StartColorDG, barOptions.StartColorDB
			elseif colorCount == 4 then --Interrupt
				barStartRed, barStartGreen, barStartBlue = barOptions.StartColorIR, barOptions.StartColorIG, barOptions.StartColorIB
			elseif colorCount == 5 then --Role
				barStartRed, barStartGreen, barStartBlue = barOptions.StartColorRR, barOptions.StartColorRG, barOptions.StartColorRB
			elseif colorCount == 6 then --Phase
				barStartRed, barStartGreen, barStartBlue = barOptions.StartColorPR, barOptions.StartColorPG, barOptions.StartColorPB
			elseif colorCount == 7 then --Important
				barStartRed, barStartGreen, barStartBlue = barOptions.StartColorUIR, barOptions.StartColorUIG,
					barOptions.StartColorUIB
			end
		else
			barStartRed, barStartGreen, barStartBlue = barOptions.StartColorR, barOptions.StartColorG, barOptions.StartColorB
		end
		bar:SetStatusBarColor(barStartRed, barStartGreen, barStartBlue)
		if sparkEnabled then
			spark:SetVertexColor(barStartRed, barStartGreen, barStartBlue)
		end
	end
	local barTextColorRed, barTextColorGreen, barTextColorBlue = barOptions.TextColorR, barOptions.TextColorG,
		barOptions.TextColorB
	local barHeight, barHugeHeight, barWidth, barHugeWidth = barOptions.Height, barOptions.HugeHeight, barOptions.Width,
		barOptions.HugeWidth
	name:SetTextColor(barTextColorRed, barTextColorGreen, barTextColorBlue)
	timer:SetTextColor(barTextColorRed, barTextColorGreen, barTextColorBlue)
	if barOptions.IconLeft then icon1:Show() else icon1:Hide() end
	if barOptions.IconRight then icon2:Show() else icon2:Hide() end
	if enlarged then
		bar:SetSize(barHugeWidth, barHugeHeight)
		frame:SetScale(barOptions.HugeScale)
		if barOptions.FadeBars and self.fade then
			frame:SetAlpha(barOptions.HugeAlpha / 2)
		else
			frame:SetAlpha(barOptions.HugeAlpha)
		end
	else
		bar:SetSize(barWidth, barHeight)
		frame:SetScale(barOptions.Scale)
		if barOptions.FadeBars and self.fade and barOptions.Alpha ~= 0 then
			frame:SetAlpha(barOptions.Alpha / 2)
		else
			frame:SetAlpha(barOptions.Alpha)
		end
	end
	if barOptions.IconLocked then
		local sizeHeight = enlarged and barHugeHeight or barHeight
		frame:SetSize(enlarged and barHugeWidth or barWidth, sizeHeight)
		icon1:SetSize(sizeHeight, sizeHeight)
		icon2:SetSize(sizeHeight, sizeHeight)
	end
	self.frame:Show()
	if sparkEnabled then
		spark:SetAlpha(1)
	end
	local r, g, b = bar:GetStatusBarColor()
	bar:SetStatusBarColor(r, g, b, 1)
	bar:SetStatusBarTexture(barOptions.Texture)
	local barFont = barOptions.Font == "standardFont" and standardFont or barOptions.Font
	local barFontSize, barFontFlag = barOptions.FontSize, barOptions.FontFlag
	name:SetFont(barFont, barFontSize, barFontFlag)
	name:SetPoint("LEFT", bar, "LEFT", 3, 0)
	timer:SetFont(barFont, barFontSize, barFontFlag)
	self:Update(0)
end

do
	local tostring, mfloor = tostring, math.floor
	local ChatEdit_GetActiveWindow, SendChatMessage, IsInInstance, GetNumRaidMembers = ChatEdit_GetActiveWindow,
		SendChatMessage, IsInInstance, GetNumRaidMembers

	function barPrototypeST:Announce()
		local msg
		if DBTST.announceHook then
			msg = DBTST.announceHook(self)
		end
		msg = msg or
			("%s %d:%02d"):format(tostring(_G[self.frame:GetName() .. "BarName"]:GetText()):gsub("|T.-|t", ""),
				mfloor(self.timer / 60), self.timer % 60)
		local chatWindow = ChatEdit_GetActiveWindow()
		if chatWindow then
			chatWindow:Insert(msg)
		else
			SendChatMessage(msg, (select(2, IsInInstance()) == "pvp" and "BATTLEGROUND") or (IsInRaid() and "RAID") or "PARTY")
		end
	end
end

function barPrototypeST:MoveToNextPosition()
	if self.moving == "enlarge" or not self.frame then
		return
	end
	local newAnchor = self.enlarged and largeBarsAnchorST or smallBarsAnchorST
	local oldX = self.frame:GetRight() - self.frame:GetWidth() / 2
	local oldY = self.frame:GetTop()
	local Enlarged = self.enlarged
	local ExpandUpwards = Enlarged and DBTST.Options.ExpandUpwardsLarge or not Enlarged and DBTST.Options.ExpandUpwards
	self.frame:ClearAllPoints()
	if ExpandUpwards then
		self.movePoint = "BOTTOM"
		self.frame:SetPoint("BOTTOM", newAnchor, "BOTTOM", DBTST.Options[Enlarged and "HugeBarXOffset" or "BarXOffset"],
			DBTST.Options[Enlarged and "HugeBarYOffset" or "BarYOffset"])
	else
		self.movePoint = "TOP"
		self.frame:SetPoint("TOP", newAnchor, "TOP", DBTST.Options[Enlarged and "HugeBarXOffset" or "BarXOffset"],
			-DBTST.Options[Enlarged and "HugeBarYOffset" or "BarYOffset"])
	end
	local newX = self.frame:GetRight() - self.frame:GetWidth() / 2
	local newY = self.frame:GetTop()
	if DBTST.Options.BarStyle ~= "NoAnim" then
		self.frame:ClearAllPoints()
		self.frame:SetPoint(self.movePoint, newAnchor, self.moveRelPoint, -(newX - oldX), -(newY - oldY))
		self.moving = "move"
	end
	self.moveAnchor = newAnchor
	self.moveOffsetX = -(newX - oldX)
	self.moveOffsetY = -(newY - oldY)
	self.moveElapsed = 0
end

function barPrototypeST:Enlarge()
	local oldX = self.frame:GetRight() - self.frame:GetWidth() / 2
	local oldY = self.frame:GetTop()
	local Enlarged = self.enlarged
	local ExpandUpwards = Enlarged and DBTST.Options.ExpandUpwardsLarge or not Enlarged and DBTST.Options.ExpandUpwards
	self.frame:ClearAllPoints()
	if ExpandUpwards then
		self.movePoint = "BOTTOM"
		self.frame:SetPoint("BOTTOM", largeBarsAnchorST, "BOTTOM",
			DBTST.Options[Enlarged and "HugeBarXOffset" or "BarXOffset"
			], DBTST.Options[Enlarged and "HugeBarYOffset" or "BarYOffset"])
	else
		self.movePoint = "TOP"
		self.frame:SetPoint("TOP", largeBarsAnchorST, "TOP", DBTST.Options[Enlarged and "HugeBarXOffset" or "BarXOffset"],
			-DBTST.Options[Enlarged and "HugeBarYOffset" or "BarYOffset"])
	end
	local newX = self.frame:GetRight() - self.frame:GetWidth() / 2
	local newY = self.frame:GetTop()
	self.frame:ClearAllPoints()
	self.frame:SetPoint("TOP", largeBarsAnchorST, "BOTTOM", -(newX - oldX), -(newY - oldY))
	self.moving = DBTST.Options.BarStyle == "NoAnim" and "nextEnlarge" or "enlarge"
	self.moveAnchor = largeBarsAnchorST
	self.moveOffsetX = -(newX - oldX)
	self.moveOffsetY = -(newY - oldY)
	self.moveElapsed = 0
end

function barPrototypeST:AnimateEnlarge(elapsed)
	self.moveElapsed = self.moveElapsed + elapsed
	local melapsed = self.moveElapsed
	if melapsed < 1 then
		local calc = melapsed / 1
		local newX = self.moveOffsetX + (DBTST.Options.HugeBarXOffset - self.moveOffsetX) * calc
		local newY = self.moveOffsetY + (DBTST.Options.HugeBarYOffset - self.moveOffsetY) * calc
		local newWidth = DBTST.Options.HugeWidth + (DBTST.Options.Width - DBTST.Options.HugeWidth) * calc
		local newHeight = DBTST.Options.HugeHeight + (DBTST.Options.Height - DBTST.Options.HugeHeight) * calc
		local newScale = DBTST.Options.HugeScale + (DBTST.Options.Scale - DBTST.Options.HugeScale) * calc
		self.frame:ClearAllPoints()
		self.frame:SetPoint(self.movePoint, self.moveAnchor, self.movePoint, newX, newY)
		self.frame:SetScale(newScale)
		self.frame:SetSize(newWidth, newHeight)
		_G[self.frame:GetName() .. "Bar"]:SetWidth(newWidth)
	else
		self.moving = nil
		self.enlarged = true
		tinsert(largeBarsST, self)
		DBTST:UpdateBars(true)
		self:ApplyStyle()
	end
end

do
	local skins = {}

	local skin = {}
	skin.__index = skin

	function DBTST:RegisterSkin(id)
		if id == "DefaultSkin" then
			DBM:AddMsg("DBM-DefaultSkin no longer used, please remove")
			DBM:AddMsg("DBM-DefaultSkin no longer used, please remove")
			DBM:AddMsg("DBM-DefaultSkin no longer used, please remove")
			return {}
		end
		if skins[id] then
			error("Skin '" .. id .. "' is already registered.", 2)
		end
		local obj = setmetatable({
			name     = id,
			Defaults = {},
			Options  = {}
		}, skin)
		skins[id] = obj
		return obj
	end

	function DBTST:SetSkin(id)
		if not skins[id] then
			error("Skin '" .. id .. "' doesn't exist", 2)
		end
		local DBM_UsedProfile = DBM_UsedProfile or "Default"
		if not DBT_AllPersistentOptions then
			DBT_AllPersistentOptions = {}
		end
		if not DBT_AllPersistentOptions[DBM_UsedProfile] then
			DBT_AllPersistentOptions[DBM_UsedProfile] = {}
		end
		if not DBT_AllPersistentOptions[DBM_UsedProfile][id] then
			DBT_AllPersistentOptions[DBM_UsedProfile][id] = DBT_AllPersistentOptions[DBM_UsedProfile].DBM or {}
			for option, value in pairs(skins[id].Defaults) do
				DBT_AllPersistentOptions[DBM_UsedProfile][id][option] = value
			end
		end
		self:ApplyProfile(id, true)
		for option, value in pairs(skins[id].Options) do
			self:SetOption(option, value, true)
		end
		self:SetOption("Skin", id) -- Forces an UpdateBars and ApplyStyle
	end

	function DBTST:ResetSkin()
		local DBM_UsedProfile = DBM_UsedProfile or "Default"
		if not DBT_AllPersistentOptions then
			DBT_AllPersistentOptions = {}
		end
		if not DBT_AllPersistentOptions[DBM_UsedProfile] then
			DBT_AllPersistentOptions[DBM_UsedProfile] = {}
		end
		DBT_AllPersistentOptions[DBM_UsedProfile]["DBM"] = self.DefaultOptions
		self.Options = self.DefaultOptions
		self:SetOption("Skin", "") -- Forces an UpdateBars and ApplyStyle
	end

	function DBTST:GetSkins()
		return skins
	end
end
