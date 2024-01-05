-- **********************************************************
-- **             Deadly Boss Mods - SpellsUsed            **
-- **             http://www.deadlybossmods.com            **
-- **********************************************************
--
-- This addon is written and copyrighted by:
--    * Martin Verges (Nitram @ EU-Azshara)
--    * Paul Emmerich (Tandanu @ EU-Aegwynn)
--
-- The localizations are written by:
--    * enGB/enUS: Nitram/Tandanu        http://www.deadlybossmods.com
--    * deDE: Nitram/Tandanu             http://www.deadlybossmods.com
--    * zhCN: yleaf(yaroot@gmail.com)
--    * zhTW: yleaf(yaroot@gmail.com)/Juha
--    * koKR: BlueNyx(bluenyx@gmail.com)
--    * esES: Interplay/1nn7erpLaY       http://www.1nn7erpLaY.com
--
-- This work is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 License. (see license.txt)
--
--  You are free:
--    * to Share  to copy, distribute, display, and perform the work
--    * to Remix  to make derivative works
--  Under the following conditions:
--    * Attribution. You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work).
--    * Noncommercial. You may not use this work for commercial purposes.
--    * Share Alike. If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.
--

local L = DBM_SpellsUsed_Translations

local Revision = ("$Revision: 56 $"):sub(12, -3)

local default_bartext = "%spell: %player"
-- local default_bartextwtarget = "%spell: %player on %target"	-- Added by Florin Patan
local default_settings = {
	enabled = false,
	showlocal = true,
	only_from_raid = true,
	active_in_pvp = true,
	own_bargroup = false,
	show_portal = true,
	spells = {
		{ spell = 6346, bartext =	L["%spell: %player on %target"], cooldown = 180 }, -- Priest: Fear Ward
		{ spell = 1161, bartext =	default_bartext, cooldown = 180 }, -- Warrior: Challenging Shout (AE Taunt)
		{ spell = 871, bartext =	L["%spell on %player"], cooldown = 12 }, -- Warrior: Shieldwall Duration (for Healers to see how long cooldown runs)
		{ spell = 12975, bartext =	L["%spell on %player"], cooldown = 20 }, -- Warrior: Last Stand Duration (for Healers to see how long cooldown runs)
		{ spell = 48792, bartext =	L["%spell on %player"], cooldown = 12 }, -- Death Knight: Icebound Fortitude Duration (for Healers to see how long cooldown runs)
		{ spell = 498, bartext =	L["%spell on %player"], cooldown = 12 }, -- Paladin: Divine Protection Duration (for Healers to see how long cooldown runs)
		{ spell = 61336, bartext =	L["%spell on %player"], cooldown = 20 }, -- Druid: Survival Instincts Duration (for Healers to see how long cooldown runs)
		{ spell = 48477, bartext =	L["%spell: %player on %target"], cooldown = 600 }, -- Druid: Rebirth (Rank 7)
		{ spell = 29166, bartext =	L["%spell: %player on %target"], cooldown = 180 }, -- Druid: Innervate
		{ spell = 5209, bartext =	default_bartext, cooldown = 180 }, -- Druid: Challenging Roar (AE Taunt)
		{ spell = 33206, bartext =	L["%spell on %target"], cooldown = 8 }, -- Priest: Pain Suppression Duration (for Healers to see how long cooldown runs)
		{ spell = 6940, bartext =	L["%spell on %target"], cooldown = 12 }, -- Paladin: Hand of Sacrifice Duration (for Healers to see how long cooldown runs)
		{ spell = 64205, bartext =	default_bartext, cooldown = 10 }, -- Paladin: Divine Sacrifice Duration (for Healers to see how long cooldown runs)
		{ spell = 34477, bartext =	L["%spell: %player on %target"], cooldown = 30 }, -- Hunter: Missdirect
		{ spell = 57934, bartext =	L["%spell: %player on %target"], cooldown = 30 }, -- Rogue: Tricks of the Trade
		{ spell = 32182, bartext =	default_bartext, cooldown = 300 }, -- Shaman: Heroism (alliance)
		{ spell = 2825, bartext =	default_bartext, cooldown = 300 }, -- Shaman: Bloodlust (horde)
		{ spell = 20608, bartext =	default_bartext, cooldown = 1800 }, -- Shaman: Reincarnation
		{ spell = 22700, bartext =	default_bartext, cooldown = 600 }, -- Field Repair Bot 74A
		{ spell = 44389, bartext =	default_bartext, cooldown = 600 }, -- Field Repair Bot 110G
		{ spell = 54711, bartext =	default_bartext, cooldown = 300 }, -- Scrapbot Construction Kit
		{ spell = 67826, bartext =	default_bartext, cooldown = 600 }, -- Jeeves

	},
	portal_alliance = {
		{ spell = 53142, bartext = default_bartext, cooldown = 60 }, -- Portal: Dalaran
		{ spell = 33691, bartext = default_bartext, cooldown = 60 }, -- Portal: Shattrath (Alliance)
		{ spell = 11416, bartext = default_bartext, cooldown = 60 }, -- Portal: Ironforge
		{ spell = 10059, bartext = default_bartext, cooldown = 60 }, -- Portal: Stormwind
		{ spell = 49360, bartext = default_bartext, cooldown = 60 }, -- Portal: Theramore
		{ spell = 11419, bartext = default_bartext, cooldown = 60 }, -- Portal: Darnassus
		{ spell = 32266, bartext = default_bartext, cooldown = 60 }, -- Portal: Exodar
		{ spell = 316475, bartext = default_bartext, cooldown = 60 },
	},
	portal_horde = {
		{ spell = 53142, bartext = default_bartext, cooldown = 60 }, -- Portal: Dalaran
		{ spell = 35717, bartext = default_bartext, cooldown = 60 }, -- Portal: Shattrath (Horde)
		{ spell = 11417, bartext = default_bartext, cooldown = 60 }, -- Portal: Orgrimmar
		{ spell = 11418, bartext = default_bartext, cooldown = 60 }, -- Portal: Undercity
		{ spell = 11420, bartext = default_bartext, cooldown = 60 }, -- Portal: Thunder Bluff
		{ spell = 32667, bartext = default_bartext, cooldown = 60 }, -- Portal: Silvermoon
		{ spell = 49361, bartext = default_bartext, cooldown = 60 }, -- Portal: Stonard
		{ spell = 316475, bartext = default_bartext, cooldown = 60 },
	},

	portal_renegade = {
		--todo fxpw надо порталы для ренегатов переделать -- заглушка на пока
		{ spell = 53142, bartext = default_bartext, cooldown = 60 }, -- Portal: Dalaran
		{ spell = 33691, bartext = default_bartext, cooldown = 60 }, -- Portal: Shattrath (Alliance)
		{ spell = 11416, bartext = default_bartext, cooldown = 60 }, -- Portal: Ironforge
		{ spell = 10059, bartext = default_bartext, cooldown = 60 }, -- Portal: Stormwind
		{ spell = 49360, bartext = default_bartext, cooldown = 60 }, -- Portal: Theramore
		{ spell = 11419, bartext = default_bartext, cooldown = 60 }, -- Portal: Darnassus
		{ spell = 32266, bartext = default_bartext, cooldown = 60 }, -- Portal: Exodar
		{ spell = 35717, bartext = default_bartext, cooldown = 60 }, -- Portal: Shattrath (Horde)
		{ spell = 11417, bartext = default_bartext, cooldown = 60 }, -- Portal: Orgrimmar
		{ spell = 11418, bartext = default_bartext, cooldown = 60 }, -- Portal: Undercity
		{ spell = 11420, bartext = default_bartext, cooldown = 60 }, -- Portal: Thunder Bluff
		{ spell = 32667, bartext = default_bartext, cooldown = 60 }, -- Portal: Silvermoon
		{ spell = 49361, bartext = default_bartext, cooldown = 60 }, -- Portal: Stonard
		{ spell = 316475, bartext = default_bartext, cooldown = 60 },
	}
}
DBM_SpellTimers_Settings = {}
local settings = default_settings





local SpellBars
local SpellBarIndex = {}
local SpellIDIndex = {}

local function rebuildSpellIDIndex()
	SpellIDIndex = {}
	for k, v in pairs(settings.spells) do
		if v.spell then
			SpellIDIndex[v.spell] = k
		end
	end
end

-- functions
local addDefaultOptions, clearAllSpellBars
-- do
local function creategui()
	local createnewentry
	local CurCount = 0
	-- local panel = DBM_GUI:CreateNewPanel(L.TabCategory_SpellsUsed, "option")
	-- local BarSetupPanel = DBM_GUI.Cat_Timers:CreateNewPanel(L.Panel_ColorByType, "option")

	--~stuiaddstart
	local LGUI = DBM_GUI_L
	local DBTST = DBTST

	DBM_GUI.SpellTimersMainTab = DBM_GUI:CreateNewPanel("Настройки восст. заклинаний/навыков"
		, "option")
	local TimersArea1          = DBM_GUI.SpellTimersMainTab:CreateArea(LGUI.Area_BasicSetup)
	TimersArea1:CreateText("|cFF73C2FBhttps://github.com/DeadlyBossMods/DeadlyBossMods/wiki/%5BNew-User-Guide%5D-Initial-Setup-Tips|r"
		, nil, true, nil, "LEFT", 0)
	TimersArea1.frame:SetScript("OnMouseUp", function()
		DBM:ShowUpdateReminder(nil, nil, LGUI.Area_BasicSetup,
			"https://github.com/DeadlyBossMods/DeadlyBossMods/wiki/%5BNew-User-Guide%5D-Initial-Setup-Tips")
	end)

	local TimersArea2 = DBM_GUI.SpellTimersMainTab:CreateArea(LGUI.Area_ColorBytype)
	TimersArea2:CreateText("|cFF73C2FBhttps://github.com/DeadlyBossMods/DeadlyBossMods/wiki/%5BGuide%5D-Color-bars-by-type|r"
		, nil, true, nil, "LEFT", 0)
	TimersArea2.frame:SetScript("OnMouseUp", function()
		DBM:ShowUpdateReminder(nil, nil, LGUI.Area_ColorBytype,
			"https://github.com/DeadlyBossMods/DeadlyBossMods/wiki/%5BGuide%5D-Color-bars-by-type")
	end)

	local BarSetupPanel = DBM_GUI.SpellTimersMainTab:CreateNewPanel(LGUI.Panel_Appearance, "option")

	local BarSetup = BarSetupPanel:CreateArea(LGUI.AreaTitle_BarSetup)
	local movemebutton = BarSetup:CreateButton(LGUI.MoveMe, 100, 16)
	movemebutton:SetPoint("TOPRIGHT", BarSetup.frame, "TOPRIGHT", -2, -4)
	movemebutton:SetNormalFontObject(GameFontNormalSmall)
	movemebutton:SetHighlightFontObject(GameFontNormalSmall)
	movemebutton:SetScript("OnClick", function()
		DBTST:ShowMovableBar()
	end)

	local color1 = BarSetup:CreateColorSelect(64)
	local color2 = BarSetup:CreateColorSelect(64)
	color1:SetPoint("TOPLEFT", BarSetup.frame, "TOPLEFT", 30, -80)
	color2:SetPoint("TOPLEFT", color1, "TOPRIGHT", 20, 0)
	color1.myheight = 84
	color2.myheight = 0

	local color1reset = BarSetup:CreateButton(LGUI.Reset, 64, 10, nil, GameFontNormalSmall)
	local color2reset = BarSetup:CreateButton(LGUI.Reset, 64, 10, nil, GameFontNormalSmall)
	color1reset:SetPoint("TOP", color1, "BOTTOM", 5, -10)
	color2reset:SetPoint("TOP", color2, "BOTTOM", 5, -10)
	color1reset:SetScript("OnClick", function()
		color1:SetColorRGB(DBTST.DefaultOptions.StartColorR, DBTST.DefaultOptions.StartColorG, DBTST.DefaultOptions.StartColorB)
	end)
	color2reset:SetScript("OnClick", function()
		color2:SetColorRGB(DBTST.DefaultOptions.EndColorR, DBTST.DefaultOptions.EndColorG, DBTST.DefaultOptions.EndColorB)
	end)

	local color1text = BarSetup:CreateText(LGUI.BarStartColor, 80)
	local color2text = BarSetup:CreateText(LGUI.BarEndColor, 80)
	color1text:SetPoint("BOTTOM", color1, "TOP", 0, 4)
	color2text:SetPoint("BOTTOM", color2, "TOP", 0, 4)
	color1text.myheight = 0
	color2text.myheight = 0
	color1:SetColorRGB(DBTST.Options.StartColorR, DBTST.Options.StartColorG, DBTST.Options.StartColorB)
	color1text:SetTextColor(DBTST.Options.StartColorR, DBTST.Options.StartColorG, DBTST.Options.StartColorB)
	color2:SetColorRGB(DBTST.Options.EndColorR, DBTST.Options.EndColorG, DBTST.Options.EndColorB)
	color2text:SetTextColor(DBTST.Options.EndColorR, DBTST.Options.EndColorG, DBTST.Options.EndColorB)
	color1:SetScript("OnColorSelect", function(self)
		DBTST:SetOption("StartColorR", select(1, self:GetColorRGB()))
		DBTST:SetOption("StartColorG", select(2, self:GetColorRGB()))
		DBTST:SetOption("StartColorB", select(3, self:GetColorRGB()))
		color1text:SetTextColor(self:GetColorRGB())
	end)
	color2:SetScript("OnColorSelect", function(self)
		DBTST:SetOption("EndColorR", select(1, self:GetColorRGB()))
		DBTST:SetOption("EndColorG", select(2, self:GetColorRGB()))
		DBTST:SetOption("EndColorB", select(3, self:GetColorRGB()))
		color2text:SetTextColor(self:GetColorRGB())
	end)

	local maindummybar = DBTST:CreateDummyBar(nil, nil, L.Recovery)
	maindummybar.frame:SetParent(BarSetup.frame)
	maindummybar.frame:SetPoint("TOP", color2text, "LEFT", 10, 60)
	maindummybar.frame:SetScript("OnUpdate", function(_, elapsed)
		maindummybar:Update(elapsed)
	end)
	do
		-- little hook to prevent this bar from changing size/scale
		local old = maindummybar.ApplyStyle
		function maindummybar:ApplyStyle(...)
			old(self, ...)
			self.frame:SetWidth(183)
			self.frame:SetScale(0.9)
			_G[self.frame:GetName() .. "Bar"]:SetWidth(183)
		end
	end
	maindummybar:ApplyStyle()
	local maindummybarHuge = DBTST:CreateDummyBar(nil, nil, L.Big)
	maindummybarHuge.frame:SetParent(BarSetup.frame)
	maindummybarHuge.frame:SetPoint("TOP", color2text, "LEFT", 10, 35)
	maindummybarHuge.frame:SetScript("OnUpdate", function(_, elapsed)
		maindummybarHuge:Update(elapsed)
	end)
	maindummybarHuge.enlarged = true
	maindummybarHuge.dummyEnlarge = true
	do
		-- Little hook to prevent this bar from changing size/scale
		local old = maindummybarHuge.ApplyStyle
		function maindummybarHuge:ApplyStyle(...)
			old(self, ...)
			self.frame:SetWidth(183)
			self.frame:SetScale(0.9)
			_G[self.frame:GetName() .. "Bar"]:SetWidth(183)
		end
	end
	maindummybarHuge:ApplyStyle()

	local Styles = {
		{
			text = LGUI.BarDBM,
			value = "DBM"
		},
		{
			text = LGUI.BarSimple,
			value = "NoAnim"
		}
	}

	local StyleDropDown = BarSetup:CreateDropdown(LGUI.BarStyle, Styles, "DBTST", "BarStyle", function(value)
		DBTST:SetOption("BarStyle", value)
	end, 210)
	StyleDropDown:SetPoint("TOPLEFT", BarSetup.frame, "TOPLEFT", 210, -25)
	StyleDropDown.myheight = 0

	local Textures = DBM_GUI:MixinSharedMedia3("statusbar", {
		{
			text = DEFAULT,
			value = "Interface\\AddOns\\DBM-StatusBarTimers\\textures\\default.blp"
		},
		{
			text = "Blizzard",
			value = "Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar" -- 136570
		},
		{
			text = "Glaze",
			value = "Interface\\AddOns\\DBM-Core\\textures\\glaze.blp"
		},
		{
			text = "Otravi",
			value = "Interface\\AddOns\\DBM-Core\\textures\\otravi.blp"
		},
		{
			text = "Smooth",
			value = "Interface\\AddOns\\DBM-Core\\textures\\smooth.blp"
		}
	})

	local TextureDropDown = BarSetup:CreateDropdown(LGUI.BarTexture, Textures, "DBTST", "Texture", function(value)
		DBTST:SetOption("Texture", value)
	end)
	TextureDropDown:SetPoint("TOPLEFT", StyleDropDown, "BOTTOMLEFT", 0, -10)
	TextureDropDown.myheight = 0

	local Fonts = DBM_GUI:MixinSharedMedia3("font", {
		{
			text = DEFAULT,
			value = "standardFont"
		},
		{
			text = "Arial",
			value = "Fonts\\ARIALN.TTF"
		},
		{
			text = "Skurri",
			value = "Fonts\\skurri.ttf"
		},
		{
			text = "Morpheus",
			value = "Fonts\\MORPHEUS.ttf"
		}
	})

	local FontDropDown = BarSetup:CreateDropdown(LGUI.FontType, Fonts, "DBTST", "Font", function(value)
		DBTST:SetOption("Font", value)
	end)
	FontDropDown:SetPoint("TOPLEFT", TextureDropDown, "BOTTOMLEFT", 0, -10)
	FontDropDown.myheight = 0

	local FontFlags = {
		{
			text = LGUI.None,
			value = "None"
		},
		{
			text = LGUI.Outline,
			value = "OUTLINE",
			flag = true
		},
		{
			text = LGUI.ThickOutline,
			value = "THICKOUTLINE",
			flag = true
		},
		{
			text = LGUI.MonochromeOutline,
			value = "MONOCHROME,OUTLINE",
			flag = true
		},
		{
			text = LGUI.MonochromeThickOutline,
			value = "MONOCHROME,THICKOUTLINE",
			flag = true
		}
	}

	local FontFlagDropDown = BarSetup:CreateDropdown(LGUI.FontStyle, FontFlags, "DBTST", "FontFlag", function(value)
		DBTST:SetOption("FontFlag", value)
	end)
	FontFlagDropDown:SetPoint("TOPLEFT", FontDropDown, "BOTTOMLEFT", 0, -10)
	FontFlagDropDown.myheight = 0

	local iconleft = BarSetup:CreateCheckButton(LGUI.BarIconLeft, nil, nil, nil, "IconLeft")
	iconleft:SetPoint("TOPLEFT", FontFlagDropDown, "BOTTOMLEFT", 10, 0)

	local iconright = BarSetup:CreateCheckButton(LGUI.BarIconRight, nil, nil, nil, "IconRight")
	iconright:SetPoint("LEFT", iconleft, "LEFT", 130, 0)

	local SparkBars = BarSetup:CreateCheckButton(LGUI.BarSpark, false, nil, nil, "Spark")
	SparkBars:SetPoint("TOPLEFT", iconleft, "BOTTOMLEFT")

	local FlashBars = BarSetup:CreateCheckButton(LGUI.BarFlash, false, nil, nil, "FlashBar")
	FlashBars:SetPoint("TOPLEFT", SparkBars, "BOTTOMLEFT")

	local ColorBars = BarSetup:CreateCheckButton(LGUI.BarColorByType, false, nil, nil, "ColorByType")
	ColorBars:SetPoint("TOPLEFT", FlashBars, "BOTTOMLEFT")

	local InlineIcons = BarSetup:CreateCheckButton(LGUI.BarInlineIcons, false, nil, nil, "InlineIcons")
	InlineIcons:SetPoint("LEFT", ColorBars, "LEFT", 130, 0)

	-- Functions for bar setup
	local function createDBTSTOnValueChangedHandler(option)
		return function(self)
			DBTST:SetOption(option, self:GetValue())
			self:SetValue(DBTST.Options[option])
		end
	end

	local function resetDBTSTValueToDefault(slider, option)
		DBTST:SetOption(option, DBTST.DefaultOptions[option])
		slider:SetValue(DBTST.Options[option])
	end

	local FontSizeSlider = BarSetup:CreateSlider(LGUI.FontSize, 7, 18, 1)
	FontSizeSlider:SetPoint("TOPLEFT", BarSetup.frame, "TOPLEFT", 20, -180)
	FontSizeSlider:SetValue(DBTST.Options.FontSize)
	FontSizeSlider:HookScript("OnValueChanged", createDBTSTOnValueChangedHandler("FontSize"))

	local DisableBarFade = BarSetup:CreateCheckButton(LGUI.NoBarFade, false, nil, nil, "NoBarFade")
	DisableBarFade:SetPoint("TOPLEFT", FontSizeSlider, "BOTTOMLEFT", 0, -85)

	local skins = {}
	for id, skin in pairs(DBTST:GetSkins()) do
		table.insert(skins, {
			text = skin.name,
			value = id
		})
	end
	if #skins > 1 then
		local BarSkin = BarSetup:CreateDropdown(LGUI.BarSkin, skins, "DBTST", "Skin", function(value)
			DBTST:SetSkin(value)
		end, 210)
		BarSkin:SetPoint("TOPLEFT", DisableBarFade, "BOTTOMLEFT", -20, -10)
		BarSkin.myheight = 45
	end

	local Sorts = {
		{
			text = LGUI.None,
			value = "None"
		},
		{
			text = LGUI.Highest,
			value = "Sort"
		},
		{
			text = LGUI.Lowest,
			value = "Invert"
		}
	}

	local BarSetupSmall = BarSetupPanel:CreateArea(L.AreaTitle_BarSetup1)

	local smalldummybar = DBTST:CreateDummyBar(nil, nil, L.Recovery)
	smalldummybar.frame:SetParent(BarSetupSmall.frame)
	smalldummybar.frame:SetPoint("BOTTOM", BarSetupSmall.frame, "TOP", 0, -35)
	smalldummybar.frame:SetScript("OnUpdate", function(_, elapsed)
		smalldummybar:Update(elapsed)
	end)

	local ExpandUpwards = BarSetupSmall:CreateCheckButton(LGUI.ExpandUpwards, false, nil, nil, "ExpandUpwards")
	ExpandUpwards:SetPoint("TOPLEFT", smalldummybar.frame, "BOTTOMLEFT", -50, -15)

	local FillUpBars = BarSetupSmall:CreateCheckButton(LGUI.FillUpBars, false, nil, nil, "FillUpBars")
	FillUpBars:SetPoint("TOPLEFT", smalldummybar.frame, "BOTTOMLEFT", 100, -15)

	local BarWidthSlider = BarSetupSmall:CreateSlider(LGUI.Slider_BarWidth, 100, 400, 1, 310)
	BarWidthSlider:SetPoint("TOPLEFT", BarSetupSmall.frame, "TOPLEFT", 20, -90)
	BarWidthSlider:SetValue(DBTST.Options.Width)
	BarWidthSlider:HookScript("OnValueChanged", createDBTSTOnValueChangedHandler("Width"))

	local BarHeightSlider = BarSetupSmall:CreateSlider(LGUI.Bar_Height, 5, 35, 1, 310)
	BarHeightSlider:SetPoint("TOPLEFT", BarWidthSlider, "BOTTOMLEFT", 0, -10)
	BarHeightSlider:SetValue(DBTST.Options.Height)
	BarHeightSlider:HookScript("OnValueChanged", createDBTSTOnValueChangedHandler("Height"))

	local BarScaleSlider = BarSetupSmall:CreateSlider(LGUI.Slider_BarScale, 0.75, 2, 0.05, 310)
	BarScaleSlider:SetPoint("TOPLEFT", BarHeightSlider, "BOTTOMLEFT", 0, -10)
	BarScaleSlider:SetValue(DBTST.Options.Scale)
	BarScaleSlider:HookScript("OnValueChanged", createDBTSTOnValueChangedHandler("Scale"))

	local saturateSlider = BarSetup:CreateSlider(LGUI.BarSaturation, 0, 1, 0.05, 455)
	saturateSlider:SetPoint("TOPLEFT", BarScaleSlider, "BOTTOMLEFT", 0, -20)
	saturateSlider:SetValue(DBTST.Options.DesaturateValue)
	saturateSlider:HookScript("OnValueChanged", createDBTSTOnValueChangedHandler("DesaturateValue"))
	saturateSlider.myheight = 55

	local SortDropDown = BarSetupSmall:CreateDropdown(LGUI.BarSort, Sorts, "DBTST", "Sort", function(value)
		DBTST:SetOption("Sort", value)
	end)
	SortDropDown:SetPoint("TOPLEFT", saturateSlider, "BOTTOMLEFT", -20, -25)
	SortDropDown.myheight = 70

	local BarOffsetXSlider = BarSetupSmall:CreateSlider(LGUI.Slider_BarOffSetX, -50, 50, 1, 120)
	BarOffsetXSlider:SetPoint("TOPLEFT", BarSetupSmall.frame, "TOPLEFT", 350, -90)
	BarOffsetXSlider:SetValue(DBTST.Options.BarXOffset)
	BarOffsetXSlider:HookScript("OnValueChanged", createDBTSTOnValueChangedHandler("BarXOffset"))
	BarOffsetXSlider.myheight = 0

	local BarOffsetYSlider = BarSetupSmall:CreateSlider(LGUI.Slider_BarOffSetY, -5, 35, 1, 120)
	BarOffsetYSlider:SetPoint("TOPLEFT", BarOffsetXSlider, "BOTTOMLEFT", 0, -10)
	BarOffsetYSlider:SetValue(DBTST.Options.BarYOffset)
	BarOffsetYSlider:HookScript("OnValueChanged", createDBTSTOnValueChangedHandler("BarYOffset"))
	BarOffsetYSlider.myheight = 0

	local AlphaSlider = BarSetupSmall:CreateSlider(LGUI.Bar_Alpha, 0, 1, 0.1, 120)
	AlphaSlider:SetPoint("TOPLEFT", BarOffsetYSlider, "BOTTOMLEFT", 0, -10)
	AlphaSlider:SetValue(DBTST.Options.Alpha)
	AlphaSlider:HookScript("OnValueChanged", createDBTSTOnValueChangedHandler("Alpha"))
	AlphaSlider.myheight = 0

	local barResetbutton = BarSetupSmall:CreateButton(LGUI.SpecWarn_ResetMe, 120, 16)
	barResetbutton:SetPoint("BOTTOMRIGHT", BarSetupSmall.frame, "BOTTOMRIGHT", -2, 4)
	barResetbutton:SetNormalFontObject(GameFontNormalSmall)
	barResetbutton:SetHighlightFontObject(GameFontNormalSmall)
	barResetbutton:SetScript("OnClick", function()
		resetDBTSTValueToDefault(BarWidthSlider, "Width")
		resetDBTSTValueToDefault(BarHeightSlider, "Height")
		resetDBTSTValueToDefault(BarScaleSlider, "Scale")
		resetDBTSTValueToDefault(BarOffsetXSlider, "BarXOffset")
		resetDBTSTValueToDefault(BarOffsetYSlider, "BarYOffset")
		resetDBTSTValueToDefault(AlphaSlider, "Alpha")
	end)

	local BarSetupHuge = BarSetupPanel:CreateArea(LGUI.AreaTitle_BarSetupHuge)

	BarSetupHuge:CreateCheckButton(LGUI.EnableHugeBar, true, nil, nil, "HugeBarsEnabled")

	local hugedummybar = DBTST:CreateDummyBar(nil, nil, L.Big)
	hugedummybar.frame:SetParent(BarSetupHuge.frame)
	hugedummybar.frame:SetPoint("BOTTOM", BarSetupHuge.frame, "TOP", 0, -50)
	hugedummybar.frame:SetScript("OnUpdate", function(_, elapsed)
		hugedummybar:Update(elapsed)
	end)
	hugedummybar.enlarged = true
	hugedummybar.dummyEnlarge = true
	hugedummybar:ApplyStyle()

	local ExpandUpwardsLarge = BarSetupHuge:CreateCheckButton(LGUI.ExpandUpwards, false, nil, nil, "ExpandUpwardsLarge")
	ExpandUpwardsLarge:SetPoint("TOPLEFT", hugedummybar.frame, "BOTTOMLEFT", -50, -15)

	local FillUpBarsLarge = BarSetupHuge:CreateCheckButton(LGUI.FillUpBars, false, nil, nil, "FillUpLargeBars")
	FillUpBarsLarge:SetPoint("TOPLEFT", hugedummybar.frame, "BOTTOMLEFT", 100, -15)

	local HugeBarWidthSlider = BarSetupHuge:CreateSlider(LGUI.Slider_BarWidth, 100, 400, 1, 310)
	HugeBarWidthSlider:SetPoint("TOPLEFT", BarSetupHuge.frame, "TOPLEFT", 20, -105)
	HugeBarWidthSlider:SetValue(DBTST.Options.HugeWidth)
	HugeBarWidthSlider:HookScript("OnValueChanged", createDBTSTOnValueChangedHandler("HugeWidth"))

	local HugeBarHeightSlider = BarSetupHuge:CreateSlider(LGUI.Bar_Height, 5, 35, 1, 310)
	HugeBarHeightSlider:SetPoint("TOPLEFT", HugeBarWidthSlider, "BOTTOMLEFT", 0, -10)
	HugeBarHeightSlider:SetValue(DBTST.Options.HugeHeight)
	HugeBarHeightSlider:HookScript("OnValueChanged", createDBTSTOnValueChangedHandler("HugeHeight"))

	local HugeBarScaleSlider = BarSetupHuge:CreateSlider(LGUI.Slider_BarScale, 0.75, 2, 0.05, 310)
	HugeBarScaleSlider:SetPoint("TOPLEFT", HugeBarHeightSlider, "BOTTOMLEFT", 0, -10)
	HugeBarScaleSlider:SetValue(DBTST.Options.HugeScale)
	HugeBarScaleSlider:HookScript("OnValueChanged", createDBTSTOnValueChangedHandler("HugeScale"))

	local SortDropDownLarge = BarSetupHuge:CreateDropdown(LGUI.BarSort, Sorts, "DBTST", "HugeSort", function(value)
		DBTST:SetOption("HugeSort", value)
	end)
	SortDropDownLarge:SetPoint("TOPLEFT", HugeBarScaleSlider, "BOTTOMLEFT", -20, -25)

	local HugeBarOffsetXSlider = BarSetupHuge:CreateSlider(LGUI.Slider_BarOffSetX, -50, 50, 1, 120)
	HugeBarOffsetXSlider:SetPoint("TOPLEFT", BarSetupHuge.frame, "TOPLEFT", 350, -105)
	HugeBarOffsetXSlider:SetValue(DBTST.Options.HugeBarXOffset)
	HugeBarOffsetXSlider:HookScript("OnValueChanged", createDBTSTOnValueChangedHandler("HugeBarXOffset"))
	HugeBarOffsetXSlider.myheight = 0

	local HugeBarOffsetYSlider = BarSetupHuge:CreateSlider(LGUI.Slider_BarOffSetY, -5, 35, 1, 120)
	HugeBarOffsetYSlider:SetPoint("TOPLEFT", HugeBarOffsetXSlider, "BOTTOMLEFT", 0, -10)
	HugeBarOffsetYSlider:SetValue(DBTST.Options.HugeBarYOffset)
	HugeBarOffsetYSlider:HookScript("OnValueChanged", createDBTSTOnValueChangedHandler("HugeBarYOffset"))
	HugeBarOffsetYSlider.myheight = 0

	local HugeAlphaSlider = BarSetupHuge:CreateSlider(LGUI.Bar_Alpha, 0.1, 1, 0.1, 120)
	HugeAlphaSlider:SetPoint("TOPLEFT", HugeBarOffsetYSlider, "BOTTOMLEFT", 0, -10)
	HugeAlphaSlider:SetValue(DBTST.Options.HugeAlpha)
	HugeAlphaSlider:HookScript("OnValueChanged", createDBTSTOnValueChangedHandler("HugeAlpha"))
	HugeAlphaSlider.myheight = 0

	local hugeBarResetbutton = BarSetupHuge:CreateButton(LGUI.SpecWarn_ResetMe, 120, 16)
	hugeBarResetbutton:SetPoint("BOTTOMRIGHT", BarSetupHuge.frame, "BOTTOMRIGHT", -2, 4)
	hugeBarResetbutton:SetNormalFontObject(GameFontNormalSmall)
	hugeBarResetbutton:SetHighlightFontObject(GameFontNormalSmall)
	hugeBarResetbutton:SetScript("OnClick", function()
		resetDBTSTValueToDefault(HugeBarWidthSlider, "HugeWidth")
		resetDBTSTValueToDefault(HugeBarHeightSlider, "HugeHeight")
		resetDBTSTValueToDefault(HugeBarScaleSlider, "HugeScale")
		resetDBTSTValueToDefault(HugeBarOffsetXSlider, "HugeBarXOffset")
		resetDBTSTValueToDefault(HugeBarOffsetYSlider, "HugeBarYOffset")
		resetDBTSTValueToDefault(HugeAlphaSlider, "HugeAlpha")
	end)
	---------------------------------------------------------------------------------------------2 subtab
	--[[BarSetupPanel = DBM_GUI.SpellTimersMainTab:CreateNewPanel(LGUI.Panel_ColorByType, "option")

	local BarColors = BarSetupPanel:CreateArea(LGUI.AreaTitle_BarColors)
	movemebutton = BarColors:CreateButton(LGUI.MoveMe, 100, 16)
	movemebutton:SetPoint("TOPRIGHT", BarColors.frame, "TOPRIGHT", -2, -4)
	movemebutton:SetNormalFontObject(GameFontNormalSmall)
	movemebutton:SetHighlightFontObject(GameFontNormalSmall)
	movemebutton:SetScript("OnClick", function()
		DBTST:ShowMovableBar()
	end)


	--Color Type 1 (Adds)
	local color1Type1 = BarColors:CreateColorSelect(64)
	local color2Type1 = BarColors:CreateColorSelect(64)
	color1Type1:SetPoint("TOPLEFT", BarColors.frame, "TOPLEFT", 30, -65)
	color2Type1:SetPoint("TOPLEFT", color1Type1, "TOPRIGHT", 20, 0)
	color1Type1.myheight = 0
	color2Type1.myheight = 0

	local color1Type1reset = BarColors:CreateButton(LGUI.Reset, 64, 10, nil, GameFontNormalSmall)
	local color2Type1reset = BarColors:CreateButton(LGUI.Reset, 64, 10, nil, GameFontNormalSmall)
	color1Type1reset:SetPoint("TOP", color1Type1, "BOTTOM", 5, -10)
	color2Type1reset:SetPoint("TOP", color2Type1, "BOTTOM", 5, -10)
	color1Type1reset:SetScript("OnClick", function()
		color1Type1:SetColorRGB(DBTST.DefaultOptions.StartColorAR, DBTST.DefaultOptions.StartColorAG,
			DBTST.DefaultOptions.StartColorAB)
	end)
	color2Type1reset:SetScript("OnClick", function()
		color2Type1:SetColorRGB(DBTST.DefaultOptions.EndColorAR, DBTST.DefaultOptions.EndColorAG,
			DBTST.DefaultOptions.EndColorAB)
	end)

	local color1Type1text = BarColors:CreateText(LGUI.BarStartColorAdd, 80, nil, nil, "CENTER")
	local color2Type1text = BarColors:CreateText(LGUI.BarEndColorAdd, 80, nil, nil, "CENTER", 10)
	color1Type1text:SetPoint("BOTTOM", color1Type1, "TOP", 0, 4)
	color2Type1text:SetPoint("BOTTOM", color2Type1, "TOP", 0, 4)
	color1Type1text.myheight = 0
	color2Type1text.myheight = 0
	color1Type1:SetColorRGB(DBTST.Options.StartColorAR, DBTST.Options.StartColorAG, DBTST.Options.StartColorAB)
	color1Type1text:SetTextColor(DBTST.Options.StartColorAR, DBTST.Options.StartColorAG, DBTST.Options.StartColorAB)
	color2Type1:SetColorRGB(DBTST.Options.EndColorAR, DBTST.Options.EndColorAG, DBTST.Options.EndColorAB)
	color2Type1text:SetTextColor(DBTST.Options.EndColorAR, DBTST.Options.EndColorAG, DBTST.Options.EndColorAB)
	color1Type1:SetScript("OnColorSelect", function(self)
		DBTST:SetOption("StartColorAR", select(1, self:GetColorRGB()))
		DBTST:SetOption("StartColorAG", select(2, self:GetColorRGB()))
		DBTST:SetOption("StartColorAB", select(3, self:GetColorRGB()))
		color1Type1text:SetTextColor(self:GetColorRGB())
	end)
	color2Type1:SetScript("OnColorSelect", function(self)
		DBTST:SetOption("EndColorAR", select(1, self:GetColorRGB()))
		DBTST:SetOption("EndColorAG", select(2, self:GetColorRGB()))
		DBTST:SetOption("EndColorAB", select(3, self:GetColorRGB()))
		color2Type1text:SetTextColor(self:GetColorRGB())
	end)

	local dummybarcolor1 = DBTST:CreateDummyBar(1, nil, LGUI.CBTAdd)
	dummybarcolor1.frame:SetParent(BarColors.frame)
	dummybarcolor1.frame:SetPoint("TOP", color2Type1text, "LEFT", 10, 40)
	dummybarcolor1.frame:SetScript("OnUpdate", function(_, elapsed)
		dummybarcolor1:Update(elapsed)
	end)
	do
		-- little hook to prevent this bar from changing size/scale
		local old = dummybarcolor1.ApplyStyle
		function dummybarcolor1:ApplyStyle(...)
			old(self, ...)
			self.frame:SetWidth(183)
			self.frame:SetScale(0.9)
			_G[self.frame:GetName() .. "Bar"]:SetWidth(183)
		end
	end

	--Color Type 2 (AOE)
	local color1Type2 = BarColors:CreateColorSelect(64)
	local color2Type2 = BarColors:CreateColorSelect(64)
	color1Type2:SetPoint("TOPLEFT", BarColors.frame, "TOPLEFT", 250, -65)
	color2Type2:SetPoint("TOPLEFT", color1Type2, "TOPRIGHT", 20, 0)
	color1Type2.myheight = 0
	color2Type2.myheight = 0

	local color1Type2reset = BarColors:CreateButton(LGUI.Reset, 64, 10, nil, GameFontNormalSmall)
	local color2Type2reset = BarColors:CreateButton(LGUI.Reset, 64, 10, nil, GameFontNormalSmall)
	color1Type2reset:SetPoint("TOP", color1Type2, "BOTTOM", 5, -10)
	color2Type2reset:SetPoint("TOP", color2Type2, "BOTTOM", 5, -10)
	color1Type2reset:SetScript("OnClick", function()
		color1Type2:SetColorRGB(DBTST.DefaultOptions.StartColorAER, DBTST.DefaultOptions.StartColorAEG,
			DBTST.DefaultOptions.StartColorAEB)
	end)
	color2Type2reset:SetScript("OnClick", function()
		color2Type2:SetColorRGB(DBTST.DefaultOptions.EndColorAER, DBTST.DefaultOptions.EndColorAEG,
			DBTST.DefaultOptions.EndColorAEB)
	end)

	local color1Type2text = BarColors:CreateText(LGUI.BarStartColorAOE, 80, nil, nil, "CENTER")
	local color2Type2text = BarColors:CreateText(LGUI.BarEndColorAOE, 80, nil, nil, "CENTER", 0)
	color1Type2text:SetPoint("BOTTOM", color1Type2, "TOP", 0, 4)
	color2Type2text:SetPoint("BOTTOM", color2Type2, "TOP", 0, 4)
	color1Type2text.myheight = 0
	color2Type2text.myheight = 0
	color1Type2:SetColorRGB(DBTST.Options.StartColorAER, DBTST.Options.StartColorAEG, DBTST.Options.StartColorAEB)
	color1Type2text:SetTextColor(DBTST.Options.StartColorAER, DBTST.Options.StartColorAEG, DBTST.Options.StartColorAEB)
	color2Type2:SetColorRGB(DBTST.Options.EndColorAER, DBTST.Options.EndColorAEG, DBTST.Options.EndColorAEB)
	color2Type2text:SetTextColor(DBTST.Options.EndColorAER, DBTST.Options.EndColorAEG, DBTST.Options.EndColorAEB)
	color1Type2:SetScript("OnColorSelect", function(self)
		DBTST:SetOption("StartColorAER", select(1, self:GetColorRGB()))
		DBTST:SetOption("StartColorAEG", select(2, self:GetColorRGB()))
		DBTST:SetOption("StartColorAEB", select(3, self:GetColorRGB()))
		color1Type2text:SetTextColor(self:GetColorRGB())
	end)
	color2Type2:SetScript("OnColorSelect", function(self)
		DBTST:SetOption("EndColorAER", select(1, self:GetColorRGB()))
		DBTST:SetOption("EndColorAEG", select(2, self:GetColorRGB()))
		DBTST:SetOption("EndColorAEB", select(3, self:GetColorRGB()))
		color2Type2text:SetTextColor(self:GetColorRGB())
	end)

	local dummybarcolor2 = DBTST:CreateDummyBar(2, nil, LGUI.CBTAOE)
	dummybarcolor2.frame:SetParent(BarColors.frame)
	dummybarcolor2.frame:SetPoint("TOP", color2Type2text, "LEFT", 10, 40)
	dummybarcolor2.frame:SetScript("OnUpdate", function(_, elapsed)
		dummybarcolor2:Update(elapsed)
	end)
	do
		-- little hook to prevent this bar from changing size/scale
		local old = dummybarcolor2.ApplyStyle
		function dummybarcolor2:ApplyStyle(...)
			old(self, ...)
			self.frame:SetWidth(183)
			self.frame:SetScale(0.9)
			_G[self.frame:GetName() .. "Bar"]:SetWidth(183)
		end
	end

	--Color Type 3 (Debuff)
	local color1Type3 = BarColors:CreateColorSelect(64)
	local color2Type3 = BarColors:CreateColorSelect(64)
	color1Type3:SetPoint("TOPLEFT", BarColors.frame, "TOPLEFT", 30, -220)
	color2Type3:SetPoint("TOPLEFT", color1Type3, "TOPRIGHT", 20, 0)
	color1Type3.myheight = 74
	color2Type3.myheight = 0

	local color1Type3reset = BarColors:CreateButton(LGUI.Reset, 64, 10, nil, GameFontNormalSmall)
	local color2Type3reset = BarColors:CreateButton(LGUI.Reset, 64, 10, nil, GameFontNormalSmall)
	color1Type3reset:SetPoint("TOP", color1Type3, "BOTTOM", 5, -10)
	color2Type3reset:SetPoint("TOP", color2Type3, "BOTTOM", 5, -10)
	color1Type3reset:SetScript("OnClick", function()
		color1Type3:SetColorRGB(DBTST.DefaultOptions.StartColorDR, DBTST.DefaultOptions.StartColorDG,
			DBTST.DefaultOptions.StartColorDB)
	end)
	color2Type3reset:SetScript("OnClick", function()
		color2Type3:SetColorRGB(DBTST.DefaultOptions.EndColorDR, DBTST.DefaultOptions.EndColorDG,
			DBTST.DefaultOptions.EndColorDB)
	end)

	local color1Type3text = BarColors:CreateText(LGUI.BarStartColorDebuff, 80, nil, nil, "CENTER")
	local color2Type3text = BarColors:CreateText(LGUI.BarEndColorDebuff, 80, nil, nil, "CENTER", 0)
	color1Type3text:SetPoint("BOTTOM", color1Type3, "TOP", 0, 4)
	color2Type3text:SetPoint("BOTTOM", color2Type3, "TOP", 0, 4)
	color1Type3text.myheight = 0
	color2Type3text.myheight = 0
	color1Type3:SetColorRGB(DBTST.Options.StartColorDR, DBTST.Options.StartColorDG, DBTST.Options.StartColorDB)
	color1Type3text:SetTextColor(DBTST.Options.StartColorDR, DBTST.Options.StartColorDG, DBTST.Options.StartColorDB)
	color2Type3:SetColorRGB(DBTST.Options.EndColorDR, DBTST.Options.EndColorDG, DBTST.Options.EndColorDB)
	color2Type3text:SetTextColor(DBTST.Options.EndColorDR, DBTST.Options.EndColorDG, DBTST.Options.EndColorDB)
	color1Type3:SetScript("OnColorSelect", function(self)
		DBTST:SetOption("StartColorDR", select(1, self:GetColorRGB()))
		DBTST:SetOption("StartColorDG", select(2, self:GetColorRGB()))
		DBTST:SetOption("StartColorDB", select(3, self:GetColorRGB()))
		color1Type3text:SetTextColor(self:GetColorRGB())
	end)
	color2Type3:SetScript("OnColorSelect", function(self)
		DBTST:SetOption("EndColorDR", select(1, self:GetColorRGB()))
		DBTST:SetOption("EndColorDG", select(2, self:GetColorRGB()))
		DBTST:SetOption("EndColorDB", select(3, self:GetColorRGB()))
		color2Type3text:SetTextColor(self:GetColorRGB())
	end)

	local dummybarcolor3 = DBTST:CreateDummyBar(3, nil, LGUI.CBTTargeted)
	dummybarcolor3.frame:SetParent(BarColors.frame)
	dummybarcolor3.frame:SetPoint("TOP", color2Type3text, "LEFT", 10, 40)
	dummybarcolor3.frame:SetScript("OnUpdate", function(_, elapsed)
		dummybarcolor3:Update(elapsed)
	end)
	do
		-- little hook to prevent this bar from changing size/scale
		local old = dummybarcolor3.ApplyStyle
		function dummybarcolor3:ApplyStyle(...)
			old(self, ...)
			self.frame:SetWidth(183)
			self.frame:SetScale(0.9)
			_G[self.frame:GetName() .. "Bar"]:SetWidth(183)
		end
	end

	--Color Type 4 (Interrupt)
	local color1Type4 = BarColors:CreateColorSelect(64)
	local color2Type4 = BarColors:CreateColorSelect(64)
	color1Type4:SetPoint("TOPLEFT", BarColors.frame, "TOPLEFT", 250, -220)
	color2Type4:SetPoint("TOPLEFT", color1Type4, "TOPRIGHT", 20, 0)
	color1Type4.myheight = 0
	color2Type4.myheight = 0

	local color1Type4reset = BarColors:CreateButton(LGUI.Reset, 64, 10, nil, GameFontNormalSmall)
	local color2Type4reset = BarColors:CreateButton(LGUI.Reset, 64, 10, nil, GameFontNormalSmall)
	color1Type4reset:SetPoint("TOP", color1Type4, "BOTTOM", 5, -10)
	color2Type4reset:SetPoint("TOP", color2Type4, "BOTTOM", 5, -10)
	color1Type4reset:SetScript("OnClick", function()
		color1Type4:SetColorRGB(DBTST.DefaultOptions.StartColorIR, DBTST.DefaultOptions.StartColorIG,
			DBTST.DefaultOptions.StartColorIB)
	end)
	color2Type4reset:SetScript("OnClick", function()
		color2Type4:SetColorRGB(DBTST.DefaultOptions.EndColorIR, DBTST.DefaultOptions.EndColorIG,
			DBTST.DefaultOptions.EndColorIB)
	end)

	local color1Type4text = BarColors:CreateText(LGUI.BarStartColorInterrupt, 80, nil, nil, "CENTER")
	local color2Type4text = BarColors:CreateText(LGUI.BarEndColorInterrupt, 80, nil, nil, "CENTER", 0)
	color1Type4text:SetPoint("BOTTOM", color1Type4, "TOP", 0, 4)
	color2Type4text:SetPoint("BOTTOM", color2Type4, "TOP", 0, 4)
	color1Type4text.myheight = 0
	color2Type4text.myheight = 0
	color1Type4:SetColorRGB(DBTST.Options.StartColorIR, DBTST.Options.StartColorIG, DBTST.Options.StartColorIB)
	color1Type4text:SetTextColor(DBTST.Options.StartColorIR, DBTST.Options.StartColorIG, DBTST.Options.StartColorIB)
	color2Type4:SetColorRGB(DBTST.Options.EndColorIR, DBTST.Options.EndColorIG, DBTST.Options.EndColorIB)
	color2Type4text:SetTextColor(DBTST.Options.EndColorIR, DBTST.Options.EndColorIG, DBTST.Options.EndColorIB)
	color1Type4:SetScript("OnColorSelect", function(self)
		DBTST:SetOption("StartColorIR", select(1, self:GetColorRGB()))
		DBTST:SetOption("StartColorIG", select(2, self:GetColorRGB()))
		DBTST:SetOption("StartColorIB", select(3, self:GetColorRGB()))
		color1Type4text:SetTextColor(self:GetColorRGB())
	end)
	color2Type4:SetScript("OnColorSelect", function(self)
		DBTST:SetOption("EndColorIR", select(1, self:GetColorRGB()))
		DBTST:SetOption("EndColorIG", select(2, self:GetColorRGB()))
		DBTST:SetOption("EndColorIB", select(3, self:GetColorRGB()))
		color2Type4text:SetTextColor(self:GetColorRGB())
	end)

	local dummybarcolor4 = DBTST:CreateDummyBar(4, nil, LGUI.CBTInterrupt)
	dummybarcolor4.frame:SetParent(BarColors.frame)
	dummybarcolor4.frame:SetPoint("TOP", color2Type4text, "LEFT", 10, 40)
	dummybarcolor4.frame:SetScript("OnUpdate", function(_, elapsed)
		dummybarcolor4:Update(elapsed)
	end)
	do
		-- little hook to prevent this bar from changing size/scale
		local old = dummybarcolor4.ApplyStyle
		function dummybarcolor4:ApplyStyle(...)
			old(self, ...)
			self.frame:SetWidth(183)
			self.frame:SetScale(0.9)
			_G[self.frame:GetName() .. "Bar"]:SetWidth(183)
		end
	end

	--Color Type 5 (Role)
	local color1Type5 = BarColors:CreateColorSelect(64)
	local color2Type5 = BarColors:CreateColorSelect(64)
	color1Type5:SetPoint("TOPLEFT", BarColors.frame, "TOPLEFT", 30, -375)
	color2Type5:SetPoint("TOPLEFT", color1Type5, "TOPRIGHT", 20, 0)
	color1Type5.myheight = 0
	color2Type5.myheight = 0

	local color1Type5reset = BarColors:CreateButton(LGUI.Reset, 64, 10, nil, GameFontNormalSmall)
	local color2Type5reset = BarColors:CreateButton(LGUI.Reset, 64, 10, nil, GameFontNormalSmall)
	color1Type5reset:SetPoint("TOP", color1Type5, "BOTTOM", 5, -10)
	color2Type5reset:SetPoint("TOP", color2Type5, "BOTTOM", 5, -10)
	color1Type5reset:SetScript("OnClick", function()
		color1Type5:SetColorRGB(DBTST.DefaultOptions.StartColorRR, DBTST.DefaultOptions.StartColorRG,
			DBTST.DefaultOptions.StartColorRB)
	end)
	color2Type5reset:SetScript("OnClick", function()
		color2Type5:SetColorRGB(DBTST.DefaultOptions.EndColorRR, DBTST.DefaultOptions.EndColorRG,
			DBTST.DefaultOptions.EndColorRB)
	end)

	local color1Type5text = BarColors:CreateText(LGUI.BarStartColorRole, 80, nil, nil, "CENTER")
	local color2Type5text = BarColors:CreateText(LGUI.BarEndColorRole, 80, nil, nil, "CENTER", 0)
	color1Type5text:SetPoint("BOTTOM", color1Type5, "TOP", 0, 4)
	color2Type5text:SetPoint("BOTTOM", color2Type5, "TOP", 0, 4)
	color1Type5text.myheight = 0
	color2Type5text.myheight = 0
	color1Type5:SetColorRGB(DBTST.Options.StartColorRR, DBTST.Options.StartColorRG, DBTST.Options.StartColorRB)
	color1Type5text:SetTextColor(DBTST.Options.StartColorRR, DBTST.Options.StartColorRG, DBTST.Options.StartColorRB)
	color2Type5:SetColorRGB(DBTST.Options.EndColorRR, DBTST.Options.EndColorRG, DBTST.Options.EndColorRB)
	color2Type5text:SetTextColor(DBTST.Options.EndColorRR, DBTST.Options.EndColorRG, DBTST.Options.EndColorRB)
	color1Type5:SetScript("OnColorSelect", function(self)
		DBTST:SetOption("StartColorRR", select(1, self:GetColorRGB()))
		DBTST:SetOption("StartColorRG", select(2, self:GetColorRGB()))
		DBTST:SetOption("StartColorRB", select(3, self:GetColorRGB()))
		color1Type5text:SetTextColor(self:GetColorRGB())
	end)
	color2Type5:SetScript("OnColorSelect", function(self)
		DBTST:SetOption("EndColorRR", select(1, self:GetColorRGB()))
		DBTST:SetOption("EndColorRG", select(2, self:GetColorRGB()))
		DBTST:SetOption("EndColorRB", select(3, self:GetColorRGB()))
		color2Type5text:SetTextColor(self:GetColorRGB())
	end)

	local dummybarcolor5 = DBTST:CreateDummyBar(5, nil, LGUI.CBTRole)
	dummybarcolor5.frame:SetParent(BarColors.frame)
	dummybarcolor5.frame:SetPoint("TOP", color2Type5text, "LEFT", 10, 40)
	dummybarcolor5.frame:SetScript("OnUpdate", function(_, elapsed)
		dummybarcolor5:Update(elapsed)
	end)
	do
		-- little hook to prevent this bar from changing size/scale
		local old = dummybarcolor5.ApplyStyle
		function dummybarcolor5:ApplyStyle(...)
			old(self, ...)
			self.frame:SetWidth(183)
			self.frame:SetScale(0.9)
			_G[self.frame:GetName() .. "Bar"]:SetWidth(183)
		end
	end

	--Color Type 6 (Phase)
	local color1Type6 = BarColors:CreateColorSelect(64)
	local color2Type6 = BarColors:CreateColorSelect(64)
	color1Type6:SetPoint("TOPLEFT", BarColors.frame, "TOPLEFT", 250, -375)
	color2Type6:SetPoint("TOPLEFT", color1Type6, "TOPRIGHT", 20, 0)
	color1Type6.myheight = 0
	color2Type6.myheight = 0

	local color1Type6reset = BarColors:CreateButton(LGUI.Reset, 64, 10, nil, GameFontNormalSmall)
	local color2Type6reset = BarColors:CreateButton(LGUI.Reset, 64, 10, nil, GameFontNormalSmall)
	color1Type6reset:SetPoint("TOP", color1Type6, "BOTTOM", 5, -10)
	color2Type6reset:SetPoint("TOP", color2Type6, "BOTTOM", 5, -10)
	color1Type6reset:SetScript("OnClick", function()
		color1Type6:SetColorRGB(DBTST.DefaultOptions.StartColorPR, DBTST.DefaultOptions.StartColorPG,
			DBTST.DefaultOptions.StartColorPB)
	end)
	color2Type6reset:SetScript("OnClick", function()
		color2Type6:SetColorRGB(DBTST.DefaultOptions.EndColorPR, DBTST.DefaultOptions.EndColorPG,
			DBTST.DefaultOptions.EndColorPB)
	end)

	local color1Type6text = BarColors:CreateText(LGUI.BarStartColorPhase, 80, nil, nil, "CENTER")
	local color2Type6text = BarColors:CreateText(LGUI.BarEndColorPhase, 80, nil, nil, "CENTER", 0)
	color1Type6text:SetPoint("BOTTOM", color1Type6, "TOP", 0, 4)
	color2Type6text:SetPoint("BOTTOM", color2Type6, "TOP", 0, 4)
	color1Type6text.myheight = 0
	color2Type6text.myheight = 0
	color1Type6:SetColorRGB(DBTST.Options.StartColorPR, DBTST.Options.StartColorPG, DBTST.Options.StartColorPB)
	color1Type6text:SetTextColor(DBTST.Options.StartColorPR, DBTST.Options.StartColorPG, DBTST.Options.StartColorPB)
	color2Type6:SetColorRGB(DBTST.Options.EndColorPR, DBTST.Options.EndColorPG, DBTST.Options.EndColorPB)
	color2Type6text:SetTextColor(DBTST.Options.EndColorPR, DBTST.Options.EndColorPG, DBTST.Options.EndColorPB)
	color1Type6:SetScript("OnColorSelect", function(self)
		DBTST:SetOption("StartColorPR", select(1, self:GetColorRGB()))
		DBTST:SetOption("StartColorPG", select(2, self:GetColorRGB()))
		DBTST:SetOption("StartColorPB", select(3, self:GetColorRGB()))
		color1Type6text:SetTextColor(self:GetColorRGB())
	end)
	color2Type6:SetScript("OnColorSelect", function(self)
		DBTST:SetOption("EndColorPR", select(1, self:GetColorRGB()))
		DBTST:SetOption("EndColorPG", select(2, self:GetColorRGB()))
		DBTST:SetOption("EndColorPB", select(3, self:GetColorRGB()))
		color2Type6text:SetTextColor(self:GetColorRGB())
	end)

	local dummybarcolor6 = DBTST:CreateDummyBar(6, nil, LGUI.CBTPhase)
	dummybarcolor6.frame:SetParent(BarColors.frame)
	dummybarcolor6.frame:SetPoint("TOP", color2Type6text, "LEFT", 10, 40)
	dummybarcolor6.frame:SetScript("OnUpdate", function(_, elapsed)
		dummybarcolor6:Update(elapsed)
	end)
	do
		-- little hook to prevent this bar from changing size/scale
		local old = dummybarcolor6.ApplyStyle
		function dummybarcolor6:ApplyStyle(...)
			old(self, ...)
			self.frame:SetWidth(183)
			self.frame:SetScale(0.9)
			_G[self.frame:GetName() .. "Bar"]:SetWidth(183)
		end
	end

	--Color Type 7 (Important (User))
	local color1Type7 = BarColors:CreateColorSelect(64)
	local color2Type7 = BarColors:CreateColorSelect(64)
	color1Type7:SetPoint("TOPLEFT", BarColors.frame, "TOPLEFT", 30, -530)
	color2Type7:SetPoint("TOPLEFT", color1Type7, "TOPRIGHT", 20, 0)
	color1Type7.myheight = 0
	color2Type7.myheight = 0

	local color1Type7reset = BarColors:CreateButton(LGUI.Reset, 64, 10, nil, GameFontNormalSmall)
	local color2Type7reset = BarColors:CreateButton(LGUI.Reset, 64, 10, nil, GameFontNormalSmall)
	color1Type7reset:SetPoint("TOP", color1Type7, "BOTTOM", 5, -10)
	color2Type7reset:SetPoint("TOP", color2Type7, "BOTTOM", 5, -10)
	color1Type7reset:SetScript("OnClick", function()
		color1Type7:SetColorRGB(DBTST.DefaultOptions.StartColorUIR, DBTST.DefaultOptions.StartColorUIG,
			DBTST.DefaultOptions.StartColorUIB)
	end)
	color2Type7reset:SetScript("OnClick", function()
		color2Type7:SetColorRGB(DBTST.DefaultOptions.EndColorUIR, DBTST.DefaultOptions.EndColorUIG,
			DBTST.DefaultOptions.EndColorUIB)
	end)

	local color1Type7text = BarColors:CreateText(LGUI.BarStartColorUI, 80, nil, nil, "CENTER")
	local color2Type7text = BarColors:CreateText(LGUI.BarEndColorUI, 80, nil, nil, "CENTER", 0)
	color1Type7text:SetPoint("BOTTOM", color1Type7, "TOP", 0, 4)
	color2Type7text:SetPoint("BOTTOM", color2Type7, "TOP", 0, 4)
	color1Type7text.myheight = 0
	color2Type7text.myheight = 0
	color1Type7:SetColorRGB(DBTST.Options.StartColorUIR, DBTST.Options.StartColorUIG, DBTST.Options.StartColorUIB)
	color1Type7text:SetTextColor(DBTST.Options.StartColorUIR, DBTST.Options.StartColorUIG, DBTST.Options.StartColorUIB)
	color2Type7:SetColorRGB(DBTST.Options.EndColorUIR, DBTST.Options.EndColorUIG, DBTST.Options.EndColorUIB)
	color2Type7text:SetTextColor(DBTST.Options.EndColorUIR, DBTST.Options.EndColorUIG, DBTST.Options.EndColorUIB)
	color1Type7:SetScript("OnColorSelect", function(self)
		DBTST:SetOption("StartColorUIR", select(1, self:GetColorRGB()))
		DBTST:SetOption("StartColorUIG", select(2, self:GetColorRGB()))
		DBTST:SetOption("StartColorUIB", select(3, self:GetColorRGB()))
		color1Type7text:SetTextColor(self:GetColorRGB())
	end)
	color2Type7:SetScript("OnColorSelect", function(self)
		DBTST:SetOption("EndColorUIR", select(1, self:GetColorRGB()))
		DBTST:SetOption("EndColorUIG", select(2, self:GetColorRGB()))
		DBTST:SetOption("EndColorUIB", select(3, self:GetColorRGB()))
		color2Type7text:SetTextColor(self:GetColorRGB())
	end)

	local dummybarcolor7 = DBTST:CreateDummyBar(7, nil, LGUI.CBTImportant)
	dummybarcolor7.frame:SetParent(BarColors.frame)
	dummybarcolor7.frame:SetPoint("TOP", color2Type7text, "LEFT", 10, 40)
	dummybarcolor7.frame:SetScript("OnUpdate", function(_, elapsed)
		dummybarcolor7:Update(elapsed)
	end)
	do
		-- little hook to prevent this bar from changing size/scale
		local old = dummybarcolor7.ApplyStyle
		function dummybarcolor7:ApplyStyle(...)
			old(self, ...)
			self.frame:SetWidth(183)
			self.frame:SetScale(0.9)
			_G[self.frame:GetName() .. "Bar"]:SetWidth(183)
		end
	end
	dummybarcolor7:ApplyStyle()

	--Type 7 Extra Options
	local bar7OptionsText = BarColors:CreateText(LGUI.Bar7Header, 405, nil, nil, "LEFT")
	bar7OptionsText:SetPoint("TOPLEFT", color2Type7text, "TOPLEFT", 150, 0)
	bar7OptionsText.myheight = 0
]]
	-- ~stuiaddend

	local changeoptions = DBM_GUI.SpellTimersMainTab:CreateNewPanel(L.TabCategory_SpellsUsed, "option")
	local generalarea = changeoptions:CreateArea(L.AreaGeneral)
	local auraarea = changeoptions:CreateArea(L.AreaAuras)

	local function regenerate()
		-- FIXME here we can reuse the frames to save some memory (if the player deletes entries)
		for i = select("#", auraarea.frame:GetChildren()), 1, -1 do
			local v = select(i, auraarea.frame:GetChildren())
			v:Hide()
			v:SetParent(UIParent)
			v:ClearAllPoints()
		end
		auraarea.frame:SetHeight(20)
		CurCount = 0

		if #settings.spells == 0 then
			createnewentry()
		else
			for _, _ in pairs(settings.spells) do
				createnewentry()
			end
		end
	end

	do
		local area = generalarea
		local enabled = area:CreateCheckButton(L.Enabled, true)
		enabled:SetScript("OnShow", function(self) self:SetChecked(settings.enabled) end)
		enabled:SetScript("OnClick", function(self) settings.enabled = not not self:GetChecked() end)

		local showlocal = area:CreateCheckButton(L.ShowLocalMessage, true)
		showlocal:SetScript("OnShow", function(self) self:SetChecked(settings.showlocal) end)
		showlocal:SetScript("OnClick", function(self) settings.showlocal = not not self:GetChecked() end)

		local showinraid = area:CreateCheckButton(L.OnlyFromRaid, true)
		showinraid:SetScript("OnShow", function(self) self:SetChecked(settings.only_from_raid) end)
		showinraid:SetScript("OnClick", function(self) settings.only_from_raid = not not self:GetChecked() end)

		local showinpvp = area:CreateCheckButton(L.EnableInPVP, true)
		showinpvp:SetScript("OnShow", function(self) self:SetChecked(settings.active_in_pvp) end)
		showinpvp:SetScript("OnClick", function(self) settings.active_in_pvp = not not self:GetChecked() end)

		local show_portal = area:CreateCheckButton(L.EnablePortals, true)
		show_portal:SetScript("OnShow", function(self) self:SetChecked(settings.show_portal) end)
		show_portal:SetScript("OnClick", function(self) settings.show_portal = not not self:GetChecked() end)

		local resetbttn = area:CreateButton(L.Reset, 140, 20)
		resetbttn.myheight = 0
		resetbttn:SetPoint("TOPRIGHT", area.frame, "TOPRIGHT", -15, -15)
		resetbttn:SetScript("OnClick", function(self)
			table.wipe(DBM_SpellTimers_Settings)
			addDefaultOptions(settings, default_settings)
			for _, v in pairs(settings.spells) do
				if v.enabled == nil then
					v.enabled = true
				end
			end
			regenerate()
			_G["DBM_GUI_OptionsFrame"]:DisplayFrame(changeoptions.frame)
		end)

		local version = area:CreateText("r" .. Revision, nil, nil, GameFontDisableSmall, "RIGHT", 0)
		version:SetPoint("BOTTOMRIGHT", area.frame, "BOTTOMRIGHT", -5, 5)
	end
	do
		local function onchange_spell(field)
			return function(self)
				settings.spells[self.guikey] = settings.spells[self.guikey] or {}
				if field == "spell" then
					settings.spells[self.guikey][field] = self:GetNumber()
					rebuildSpellIDIndex()
				elseif field == "cooldown" then
					settings.spells[self.guikey][field] = self:GetNumber()
				elseif field == "enabled" then
					settings.spells[self.guikey].enabled = not not self:GetChecked()
				else
					settings.spells[self.guikey][field] = self:GetText()
				end
			end
		end

		local function onshow_spell(field)
			return function(self)
				settings.spells[self.guikey] = settings.spells[self.guikey] or {}
				if field == "bartext" and settings.spells[self.guikey].spell and settings.spells[self.guikey].spell > 0 then
					local text = settings.spells[self.guikey][field] or ""
					local spellinfo = GetSpellInfo(settings.spells[self.guikey].spell)
					if spellinfo == nil then
						DBM:AddMsg("Illegal SpellID found. Please remove the Spell " ..
							settings.spells[self.guikey].spell .. " from your DBM Options GUI (spelltimers)");
					else
						self:SetText(string.gsub(text, "%%spell", spellinfo))
					end
				elseif field == "enabled" then
					self:SetChecked(settings.spells[self.guikey].enabled)
				else
					self:SetText(settings.spells[self.guikey][field] or "")
				end
			end
		end

		local area = auraarea

		local getadditionalid = CreateFrame("Button", "GetAdditionalID_Pull", area.frame)
		getadditionalid:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-UP");
		getadditionalid:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-DOWN");
		getadditionalid:SetWidth(15)
		getadditionalid:SetHeight(15)

		function createnewentry()
			CurCount = CurCount + 1
			local spellid = auraarea:CreateEditBox(L.SpellID, "", 65)
			spellid.myheight = 35
			spellid.guikey = CurCount
			spellid:SetPoint("TOPLEFT", auraarea.frame, "TOPLEFT", 40, 15 - (CurCount * 35))
			spellid:SetScript("OnTextChanged", onchange_spell("spell"))
			spellid:SetScript("OnShow", onshow_spell("spell"))
			spellid:SetNumeric(true)
			-- print(709)
			local bartext = auraarea:CreateEditBox(L.BarText, "", 190)
			bartext.myheight = 0
			bartext.guikey = CurCount
			bartext:SetPoint('TOPLEFT', spellid, "TOPRIGHT", 40, 0)
			bartext:SetScript("OnTextChanged", onchange_spell("bartext"))
			bartext:SetScript("OnShow", onshow_spell("bartext"))
			-- print(716)
			local cooldown = auraarea:CreateEditBox(L.Cooldown, "", 45)
			cooldown.myheight = 0
			cooldown.guikey = CurCount
			cooldown:SetPoint("TOPLEFT", bartext, "TOPRIGHT", 40, 0)
			cooldown:SetScript("OnTextChanged", onchange_spell("cooldown"))
			cooldown:SetScript("OnShow", onshow_spell("cooldown"))
			cooldown:SetNumeric(true)
			-- print(724)
			local enableit = auraarea:CreateCheckButton("")
			enableit.myheight = 0
			enableit.guikey = CurCount
			enableit:SetScript("OnShow", onshow_spell("enabled"))
			enableit:SetScript("OnClick", onchange_spell("enabled"))
			enableit:SetPoint("LEFT", cooldown, "RIGHT", 5, 0)
			-- print(731)
			getadditionalid:ClearAllPoints()
			getadditionalid:SetPoint("RIGHT", spellid, "LEFT", -15, 0)
			area.frame:SetHeight(area.frame:GetHeight() + 35)
			area.frame:GetParent():SetHeight(area.frame:GetParent():GetHeight() + 35)
			-- print(736)
			-- if _G["DBM_GUI"].currentViewing == panel.frame and CurCount > 1 then
			-- 	_G["DBM_GUI_OptionsFrame"]:DisplayFrame(panel.frame)
			-- end
			-- print(740)
			getadditionalid:SetScript("OnClick", function()
				if spellid:GetNumber() > 0 and bartext:GetText():len() > 0 and cooldown:GetNumber() > 0 then
					createnewentry()
				else
					DBM:AddMsg(L.Error_FillUp)
				end
			end)
		end

		if #settings.spells == 0 then
			createnewentry()
		else
			for _ = 1, #settings.spells do
				createnewentry()
			end
		end
	end
end

-- end


do
	function addDefaultOptions(t1, t2)
		for i, v in pairs(t2) do
			if t1[i] == nil then
				t1[i] = v
			elseif type(v) == "table" then
				addDefaultOptions(v, t2[i])
			end
		end
	end

	function clearAllSpellBars()
		for k, _ in pairs(SpellBarIndex) do
			SpellBars:CancelBar(k)
			SpellBarIndex[k] = nil
		end
	end

	local myportals = {}
	local lastmsg = "";
	local mainframe = CreateFrame("frame", "DBM_SpellTimers", UIParent)
	local spellEvents = {
		["SPELL_CAST_SUCCESS"] = true,
		["SPELL_RESURRECT"] = true,
		["SPELL_HEAL"] = true,
		["SPELL_AURA_APPLIED"] = true,
		["SPELL_AURA_REFRESH"] = true,
	}
	mainframe:SetScript("OnEvent", function(self, event, ...)
		if event == "ADDON_LOADED" and select(1, ...) == "DBM-SpellTimers" then

			hooksecurefunc(DBM, "ADDON_LOADED", function()
				DBTST:LoadOptions("DBMST")
			end)

			hooksecurefunc(DBM, "CreateProfile", function()
				DBTST:CreateProfile("DBMST")
			end)

			hooksecurefunc(DBM, "ApplyProfile", function()
				DBTST:ApplyProfile("DBMST")
			end)


			hooksecurefunc(DBM, "CopyProfile", function(name)
				DBTST:CopyProfile(name, "DBMST", true)
			end)
			hooksecurefunc(DBM, "DeleteProfile", function(name)
				DBTST:DeleteProfile(name, "DBMST")
			end)

			DBM:RegisterOnGuiLoadCallback(creategui, 19)
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			self:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")

			-- Update settings of this Addon
			settings = DBM_SpellTimers_Settings
			addDefaultOptions(settings, default_settings)

			-- CreateBarObject
			--[[ hmm, damm mass options. this sucks!
			if settings.own_bargroup then
				SpellBars = DBTST:New()
				print_t(SpellBars.options)
				addDefaultOptions(SpellBars.options, DBTST.Options)
			else
				SpellBars = DBTST
			end --]]
			SpellBars = DBTST


			if UnitFactionGroup("player") == "Alliance" then
				myportals = settings.portal_alliance
			elseif UnitFactionGroup("player") == "Renegade" then
				myportals = settings.portal_renegade
			else
				myportals = settings.portal_horde
			end

			for _, v in pairs(settings.spells) do
				if v.enabled == nil then
					v.enabled = true
				end
			end

			rebuildSpellIDIndex()

		elseif settings.enabled and event == "COMBAT_LOG_EVENT_UNFILTERED" and spellEvents[select(2, ...)] then
			-- first some exeptions (we don't want to see any skill around the world)
			if settings.only_from_raid and not DBM:IsInRaid() then return end
			if not settings.active_in_pvp and (select(2, IsInInstance()) == "pvp") then return end

			local fromplayer = select(4, ...)
			local toplayer = select(7, ...) -- Added by Florin Patan
			local spellid = select(9, ...)

			-- now we filter if cast is from outside raidgrp (we don't want to see mass spam in Dalaran/...)
			if settings.only_from_raid and not DBM:GetRaidUnitId(fromplayer) then return end

			local guikey = SpellIDIndex[spellid]
			local v = (guikey and settings.spells[guikey])
			if v and v.enabled == true then
				if v.spell ~= spellid then
					print("DBM-SpellTimers Index mismatch error! " .. guikey .. " " .. spellid)
				end

				local spellinfo, _, icon = GetSpellInfo(spellid)
				local bartext = v.bartext:gsub("%%spell", spellinfo):gsub("%%player", fromplayer):gsub("%%target", toplayer) -- Changed by Florin Patan
				if (spellid == 34477 or spellid == 57934) and (fromplayer == toplayer) then
					return
				end
				SpellBarIndex[bartext] = SpellBars:CreateBar(v.cooldown, bartext, icon, nil, true)

				if settings.showlocal then
					local msg = L.Local_CastMessage:format(bartext)
					if not lastmsg or lastmsg ~= msg then
						DBM:AddMsg(msg)
						lastmsg = msg
					end
				end
			end

		elseif settings.enabled and event == "COMBAT_LOG_EVENT_UNFILTERED" and settings.show_portal and
			select(2, ...) == "SPELL_CREATE" then
			if settings.only_from_raid and not DBM:IsInRaid() then return end

			local fromplayer = select(4, ...)
			local toplayer = select(7, ...) -- Added by Florin Patan
			local spellid = select(9, ...)

			if settings.only_from_raid and not DBM:GetRaidUnitId(fromplayer) then return end

			for _, v in pairs(myportals) do
				if v.spell == spellid then
					local spellinfo, _, icon = GetSpellInfo(spellid)
					local bartext = v.bartext:gsub("%%spell", spellinfo):gsub("%%player", fromplayer):gsub("%%target", toplayer) -- Changed by Florin Patan
					SpellBarIndex[bartext] = SpellBars:CreateBar(v.cooldown, bartext, icon, nil, true)

					if settings.showlocal then
						DBM:AddMsg(L.Local_CastMessage:format(bartext))
					end
				end
			end
		elseif settings.enabled and event == "PLAYER_ENTERING_BATTLEGROUND" then
			-- spell cooldowns all reset on entering an arena or bg
			clearAllSpellBars()
		end
	end)
	mainframe:RegisterEvent("ADDON_LOADED")
end
