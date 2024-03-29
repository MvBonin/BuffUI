--------------------------------------------------------------------------------
-- Integer functions
--------------------------------------------------------------------------------

function round(time)
	if not time then return nil end
	local int=math.floor(time)
	local rest=int~=0 and time%int or 0
	if rest<0.5 then
		return int
	end
	return int+1
end

--------------------------------------------------------------------------------
-- String functions
--------------------------------------------------------------------------------

local _lower = string.lower
local _upper = string.upper

function string.lower(s)
    return _lower(s:gsub("([�-�])",function(c) return string.char(c:byte()+32) end):gsub("�", "�"))
end

function string.upper(s)
    return _upper(s:gsub("([�-�])",function(c) return string.char(c:byte()-32) end):gsub("�", "�"))
end

function toWString(text)
	if not text then return nil end
	if not common.IsWString(text) then
		text=userMods.ToWString(tostring(text))
	end
	return text
end

function toString(text)
	if not text then return nil end
	if common.IsWString(text) then
		text=userMods.FromWString(text)
	end
	return tostring(text)
end

function find(text, word)
	text=toString(text)
	word=toString(word)
	if text and word and word~="" then
		text=string.lower(text)
		word=string.lower(word)
		return string.find(text, word, 1, true)
	end
	return false
end

function findWord(text)
	if not text then return {} end
	if string.gmatch then return string.gmatch(toString(text), "([^,]+),*%s*") end
	return pairs({toString(text)})
end

function formatText(text, align, fontSize, shadow, outline, fontName)
	return "<body fontname='"..(toString(fontName) or "AllodsWest").."' alignx = '"..(toString(align) or "left").."' fontsize='"..(toString(fontSize) or "14").."' shadow='"..(toString(shadow) or "1").."' outline='"..(toString(outline) or "0").."'><rs class='color'>"..(toString(text) or "").."</rs></body>"
end

function toValuedText(text, color, align, fontSize, shadow, outline, fontName)
	local valuedText=common.CreateValuedText()
	text=toWString(text)
	if not valuedText or not text then return nil end
	valuedText:SetFormat(toWString(formatText(text, align, fontSize, shadow, outline, fontName)))
	if color then
		valuedText:SetClassVal( "color", color )
	else
		valuedText:SetClassVal( "color", "LogColorYellow" )
	end
	return valuedText
end

function compare(name1, name2)
	name1=toWString(name1)
	name2=toWString(name2)
	if not name1 or not name2 then return nil end
	return common.CompareWStringEx(name1, name2)==0
end

function getTimeString(ms)
	if		ms<1000	then return "0."..toString(round(ms/100)).."s"
	else   	ms=round(ms/1000) end
	if		ms<60	then return toString(ms).."s"
	else    ms=math.floor(ms/60) end
	if		ms<60	then return toString(ms).."m"
	else    ms=round(ms/60) end
	if		ms<24	then return toString(ms).."h"
	else    ms=round(ms/24) end
	return toString(ms).."d"
end

--------------------------------------------------------------------------------
-- Log functions
--------------------------------------------------------------------------------

function logMemoryUsage()
	common.LogInfo( common.GetAddonName(), "usage "..tostring(gcinfo()).."kb" )
end

function logText(text)
	common.LogInfo("common", toWString(text))
end

function message(text, color, fontSize)
	local chat=stateMainForm:GetChildUnchecked("ChatLog", false)
	if not chat then
		chat=stateMainForm:GetChildUnchecked("Chat", true)
	else
		chat=chat:GetChildUnchecked("Container", true)
	end
	if not chat then return end

	text=common.GetAddonName()..": "..(toString(text) or "nil")
	chat:PushFrontValuedText(toValuedText(text, nil, nil, 16, nil, nil, "AllodsSystem"))
end

--------------------------------------------------------------------------------
-- Load/save
--------------------------------------------------------------------------------


--common.GetScriptCfgVar( name )

local profileName = nil

function setProfileName(name)
	profileName = name
end

local function getSection(prefix)
	local addonName = common.GetAddonName and common.GetAddonName() or ""
	local id = avatar.GetServerId and avatar.GetServerId() or object.GetName and avatar.GetId and object.GetName(avatar.GetId()) or ""
	local activeBuild = profileName or avatar.GetActiveBuild and avatar.GetActiveBuild() or ""
	if not prefix then prefix="" end
	return toString(addonName).."_"..toString(id).."_"..toString(activeBuild).."_"..toString(prefix)
end

function getTable(prefix)
	return userMods.GetGlobalConfigSection(getSection(prefix))
end

function getBool(prefix, def)
	local data = getTable(prefix)
	if data then
		local i, data=next(data)
		return data
	end
	return def
end

function save(prefix, data)
	if type(data)~="table" then data={ data } end
	userMods.SetGlobalConfigSection(getSection(prefix), data)
end

--------------------------------------------------------------------------------
-- Widget funtions
--------------------------------------------------------------------------------

Global("WIDGET_ALIGN_LOW", 0)
Global("WIDGET_ALIGN_HIGH", 1)
Global("WIDGET_ALIGN_CENTER", 2)
Global("WIDGET_ALIGN_BOTH", 3)
Global("WIDGET_ALIGN_LOW_ABS", 4)

function destroy(widget)
	if widget and widget.DestroyWidget then widget:DestroyWidget() end
end

function isVisible(widget)
	if widget and widget.IsVisible then return widget:IsVisible() end
	return nil
end

function getChild(widget, name, g)
	if g==nil then g=false end
	if not widget or not widget.GetChildUnchecked or not name then return nil end
	return widget:GetChildUnchecked(name, g)
end

function move(widget, posX, posY)
	if not widget then return end
	local BarPlace=widget.GetPlacementPlain and widget:GetPlacementPlain()
	if not BarPlace then return nil end
	if posX then
		BarPlace.posX = posX
		BarPlace.highPosX = posX
	end
	if posY then
		BarPlace.posY = posY
		BarPlace.highPosY = posY
	end
	if widget.SetPlacementPlain then widget:SetPlacementPlain(BarPlace) end
end

function setFade(widget, fade)
	if widget and fade and widget.SetFade then
		widget:SetFade(fade)
	end
end

function resize(widget, width, height)
	if not widget then return end
	local BarPlace=widget.GetPlacementPlain and widget:GetPlacementPlain()
	if not BarPlace then return nil end
	if width then BarPlace.sizeX = width end
	if height then BarPlace.sizeY = height end
	if widget.SetPlacementPlain then widget:SetPlacementPlain(BarPlace) end
end

function align(widget, alignX, alingY)
	if not widget then return end
	local BarPlace=widget.GetPlacementPlain and widget:GetPlacementPlain()
	if not BarPlace then return nil end
	if alignX then BarPlace.alignX = alignX end
	if alingY then BarPlace.alignY = alingY end
	if widget.SetPlacementPlain then widget:SetPlacementPlain(BarPlace) end
end

function priority(widget, priority)
	if not widget or not priority then return nil end
	if widget.SetPriority then widget:SetPriority(priority) end
end

function show(widget)
	if not widget  then return nil end
	if not widget.IsVisible or widget:IsVisible() then return nil end
	--if widget:IsVisible() then return nil end
	if widget.Show then widget:Show(true) end
end

function hide(widget)
	if not widget  then return nil end
	if not widget.IsVisible or not widget:IsVisible()  then return nil end
	--if not widget:IsVisible() then return nil end
	if widget.Show then widget:Show(false) end
end

function setName(widget, name)
	if not widget or not name then return nil end
	if widget.SetName then widget:SetName(name) end
end

function getName(widget)
	return widget and widget.GetName and widget:GetName() or nil
end

function getText(widget)
	return widget and widget.GetText and toString(widget:GetText()) or nil
end

function setText(widget, text, color, align, fontSize, shadow, outline, fontName)
	if not widget then return nil end
	text=toWString(text or "")
	if widget.SetVal 		then widget:SetVal("button_label", text)  end
	--if widget.SetTextColor	then widget:SetTextColor("button_label", { a = 1, r = 1, g = 0, b = 0 } ) end --ENUM_ColorType_SHADOW
	if widget.SetText		then widget:SetText(text) end
	if widget.SetValuedText then widget:SetValuedText(toValuedText(text, color or "ColorWhite", align, fontSize, shadow, outline, fontName)) end
end

function setBackgroundTexture(widget, texture)
	if not widget or not widget.SetBackgroundTexture then return nil end
	widget:SetBackgroundTexture(texture)
end

function setBackgroundColor(widget, color)
	if not widget or not widget.SetBackgroundColor then return nil end
	if not color then color={ r = 0; g = 0, b = 0; a = 0 } end
	widget:SetBackgroundColor(color)
end

local templateWidget=nil
local form=nil

function getDesc(name)
	local widget=templateWidget and name and templateWidget.GetChildUnchecked and templateWidget:GetChildUnchecked(name, false)
	return widget and widget.GetWidgetDesc and widget:GetWidgetDesc() or nil
end

function getParent(widget, num)
	if not num or num<1 then num=1 end
	if not widget or not widget.GetParent then return nil end
	local parent=widget:GetParent()
	if num==1 then return parent end
	return getParent(parent, num-1)
end

function getForm(widget)
	if not widget then return nil end
	if not widget.CreateWidgetByDesc then
		return getForm(getParent(widget))
	end
	return widget
end

function createWidget(parent, widgetName, templateName, alignX, alignY, width, height, posX, posY, noParent)
	local desc=getDesc(templateName)
	if not desc and parent then return nil end
	local owner=getForm(parent)
	local widget=owner and owner:CreateWidgetByDesc(desc) or common.AddonCreateChildForm(templateName)
	if parent and widget and not noParent then parent:AddChild(widget) end --
	setName(widget, widgetName)
	align(widget, alignX, alignY)
	move(widget, posX, posY)
	resize(widget, width, height)
	return widget
end

function setTemplateWidget(widget)
	templateWidget=widget
end

function equals(widget1, widget2)
	if not widget1 or not widget2 then return nil end
	return widget1.IsEqual and widget1:IsEqual(widget2) or widget2.IsEqual and widget2:IsEqual(widget1) or nil
end

function swap(widget)
	if widget and widget.IsVisible and not widget:IsVisible() then
		show(widget)
	else
		hide(widget)
	end
end

function changeCheckBox(widget)
	if not widget or not widget.GetVariantCount then return end
	if not widget.GetVariant or not widget.SetVariant then return end

	if 0==widget:GetVariant() then 	widget:SetVariant(1)
	else 							widget:SetVariant(0) end
end

function setCheckBox(widget, value)
	if not widget or not widget.SetVariant or not widget.GetVariantCount then return end
	if widget:GetVariantCount()<2 then return end
	if 		value 	then 	widget:SetVariant(1) return end
	widget:SetVariant(0)
end

function getCheckBoxState(widget)
	if not widget or not widget.GetVariant then return end
	return widget:GetVariant()==1 and true or false
end

function getModFromFlags(flags)
	local ctrl=flags>3
	if ctrl then flags=flags-4 end
	local alt=flags>1
	if alt then flags=flags-2 end
	local shift=flags>0
	return ctrl, alt, shift
end

--------------------------------------------------------------------------------
-- Timers functions
--------------------------------------------------------------------------------

local template=createWidget(nil, "Template", "Template")
local timers={}

function timer(params)
	if not params.effectType == ET_FADE then return end
	local name=nil
	for i, j in pairs(timers) do
		if j and equals(params.wtOwner, j.widget) then
			name=i
		end
	end
	if not name then return end


	if timers[name] then
		if timers[name].widget and not timers[name].one then
			timers[name].widget:PlayFadeEffect( 1.0, 1.0, timers[name].speed*1000, EA_MONOTONOUS_INCREASE )
		end
		userMods.SendEvent( timers[name].event, {sender = common.GetAddonName()} )
	end
end

function startTimer(name, eventname, speed, one)
	if name and timers[name] then destroy(timers[name].widget) end
	setTemplateWidget(template)
	local timerWidget=createWidget(mainForm, name, "Timer")
	if not timerWidget or not name or not eventname then return nil end
	timers[name]={}
	timers[name].event=eventname
	timers[name].widget=timerWidget
	timers[name].one=one
	timers[name].speed=tonumber(speed) or 1

	common.RegisterEventHandler(timer, "EVENT_EFFECT_FINISHED")
    timerWidget:PlayFadeEffect(1.0, 1.0, timers[name].speed*1000, EA_MONOTONOUS_INCREASE)
	return true
end

function stopTimer(name)
    common.UnRegisterEventHandler( timer, "EVENT_EFFECT_FINISHED" )
end

function setTimeout(name, speed)
	if name and timers[name] and speed then
		timers[name].speed=tonumber(speed) or 1
	end
end

function destroyTimer(name)
	if timers[name] then destroy(timers[name].widget) end
	timers[name]=nil
end

--------------------------------------------------------------------------------
-- Locales functions
--------------------------------------------------------------------------------
--[[
local locale=getLocale()

function setLocaleText(widget, checked)
	local name=getName(widget)
	local text=name and locale[name]
	if text then
		if checked~=nil then
			text=formatText(text, "left")
			setCheckBox(widget, checked)
		end
		setText(widget, text)
	end
end
]]--
--------------------------------------------------------------------------------
-- Spell functions
--------------------------------------------------------------------------------

Global("TYPE_SPELL", 0)
Global("TYPE_ITEM", 1)
Global("TYPE_NOT_DEFINED", 2)

local cacheSpellId={}

function getSpellIdFromName(name, nocache)  ---optimize and replace
	if not name then return nil end

	if not nocache and cacheSpellId and cacheSpellId[name] and spellLib.CanRunAvatarEx(cacheSpellId[name]) then return cacheSpellId[name] end

	local spellbook = avatar.GetSpellBook()
	if not spellbook then return nil end

	for i, spellId in pairs(spellbook) do
		local spellInfo=spellId and spellLib.GetDescription(spellId)
		if spellInfo and compare(spellInfo.name, name) then
			cacheSpellId[name]=spellId
			return spellId
		end
	end

	for i, spellId in pairs(spellbook) do
		local spellInfo=spellId and spellLib.GetDescription(spellId)
		if spellInfo and find(spellInfo.name, name) then
			cacheSpellId[name]=spellId
			return spellId
		end
	end

	return nil
end

local cacheItemId={}

function getItemIdFromName(name, nocache)
	if not name then return nil end

	if not nocache and cacheItemId and cacheItemId[name] and itemLib.IsItem(cacheItemId[name]) then return cacheItemId[name] end

	local inventory = avatar.GetInventoryItemIds()
	if not inventory then return nil end

	for i, itemId in pairs(inventory) do
		local itemInfo = itemId and itemLib.GetItemInfo(itemId)
		if itemInfo and compare(itemInfo.name, name) then
			cacheItemId[name]=itemId
			return itemId
		end
	end

	return nil
end

function clearCache()
	cacheItemId={}
	cacheSpellId={}
end

function getTypeFromName(name)
	if not name then return nil end
	local itemId=getItemIdFromName(name, true)
	if itemId then return TYPE_ITEM end
	local spellId=getSpellIdFromName(name, true)
	if spellId then return TYPE_SPELL end
	return TYPE_NOT_DEFINED
end

local lastTarget=nil
local currentTarget=nil

function getLastTarget()
	return lastTarget
end

function getCurrentTarget()
	return currentTarget
end

function setCurrentTarget(targetId)
	lastTarget=currentTarget
	currentTarget=targetId
end

function isExist(targetId)
	if targetId then
		if type(targetId)=="userdata" then return true
		elseif object.IsExist(targetId) then return true end
	end
	return false
end

function selectTarget(targetId)
	--lastTarget=avatar.GetTarget()
	if isExist(targetId) then
		avatar.SelectTarget(targetId)
	else
		avatar.UnselectTarget()
	end
end

function isEnemy(objectId)
	if not isExist(objectId) then return nil end
	local enemy=false
	if 		object.IsEnemy 	then enemy=object.IsEnemy(objectId)
	elseif unit.IsEnemy 	then enemy=unit.IsEnemy(objectId) 	end   ---For 5.0.1
	return enemy
end

function isFriend(objectId)
	if not isExist(objectId) then return nil end
	local friend=false
	if 		object.IsFriend then friend=object.IsFriend(objectId)
	elseif unit.IsFriend 	then friend=unit.IsFriend(objectId) 	end   ---For 5.0.1
	return friend
end

function isRaid()
	if raid.IsExist and avatar.IsExist then
		if avatar.IsExist() then return raid.IsExist() end
	end
	return false
end

function isGroup()
	if group.IsCreatureInGroup and avatar.IsExist and avatar.GetId then
		if avatar.IsExist() then return group.IsCreatureInGroup(avatar.GetId()) end
	end
	if group.IsExist then return group.IsExist() end
	return false
end

function cast(name, targetId)
	local spellId=name and getSpellIdFromName(name)
	if not spellId then return nil end
	local duration=spellLib.GetProperties(spellId).launchWhenReady
	local properties=spellLib.GetProperties(spellId)
	local duration=properties.prepareDuration
	local state=spellLib.GetState(spellId)
	if not state.prepared and duration and duration > 1 then selectTarget(targetId) end

	local targetType=properties.targetType and properties.targetType==SPELL_TYPE_SELF
	if targetId and object.IsExist(targetId) and not targetType then
		avatar.RunTargetSpell(spellId, targetId)
	else
		avatar.RunSpell(spellId)
	end

	return spellLib.CanRunAvatar(spellId)
end

function useItem(name, targetId)
	local itemId=name and getItemIdFromName(name)
	if not itemId then return nil end

	if targetId then
		selectTarget(targetId)
	end
	avatar.UseItem(itemId)
	return true
end

function testSpell(name, targetId)
	if not targetId then return nil end

	local spellId=name and getSpellIdFromName(name)
	return spellId and spellLib.CanRunAvatar(spellId)
end

function ressurect(targetId, ressurectName)
	if testSpell(ressurectName, targetId) then
		selectTarget(targetId)
		cast(ressurectName, targetId)
		return true
	end
	if not locale or not locale["defaultRessurectNames"] then return false end
	for i, v in ipairs(locale["defaultRessurectNames"]) do
		local name=v and v.name
		if testSpell(name, targetId) then
			selectTarget(targetId)
			cast(name, targetId)
			return true
		end
	end
	return false
end

function getDistanceToTarget(targetId)
	local t=isExist(targetId) and object.GetPos and object.GetPos(targetId)
	--if not t then
	--	t=objects.GetTrackInfo(targetId)
	--	if t then t=t.position end
	--end
	if not t then return nil end
	local p=avatar.GetPos()
	return ((t.posX-p.posX)^2+(t.posY-p.posY)^2+(t.posZ-p.posZ)^2)^0.5
end

function getBuffInfoFromUnitInfo(unitInfo, name)
	name=string.lower(toString(name))
	return name and name~="" and unitInfo and unitInfo.buffs and unitInfo.buffs[name] or nil
end

function getAngleToTarget(targetId)
	local t=isExist(targetId) and object.GetPos(targetId)
	if not t then return nil end
	local p=avatar.GetPos()
	return math.atan2(t.posY-p.posY, t.posX-p.posX)
end


function getPersIdToId(pid)
	if not pid then return nil end
	if isRaid() then
		local members=raid.GetMembers()
		for i, g in pairs(members) do
			for j, m in pairs(g) do
				if m and m.id==pid then return m.uniqueId or m.persistentId end
			end
		end
	elseif isGroup() then
		local members=group.GetMembers()
		for i, m in pairs(members) do
			if m and m.id==pid then return m.uniqueId or m.persistentId end
		end
	elseif avatar.GetId and avatar.GetId()==pid then
		return avatar.GetUniqueId and avatar.GetUniqueId() or avatar.GetServerId and avatar.GetServerId()
	end
	return pid
end

function getNameToPersId(pid)
	if not pid or type(pid)~="userdata" then return nil end
	if isRaid() then
		local members=raid.GetMembers()
		for i, g in pairs(members) do
			for j, m in pairs(g) do
				if m and (m.uniqueId and m.uniqueId.IsEqual and m.uniqueId.IsEqual(pid, m.uniqueId) or m.persistentId==pid) then return m.name end
			end
		end
	elseif isGroup() then
		local members=group.GetMembers()
		for i, m in pairs(members) do
			if m and (m.uniqueId and m.uniqueId.IsEqual and m.uniqueId.IsEqual(pid, m.uniqueId) or m.persistentId==pid) then return toString(m.name) end
		end
	end
	local avatarUniqueId=avatar.GetUniqueId and avatar.GetUniqueId()
	return (avatarUniqueId and avatarUniqueId.IsEqual and avatarUniqueId.IsEqual(pid, avatarUniqueId) or avatar.GetServerId and avatar.GetServerId()==pid) and avatar.GetId and object.GetName and object.GetName(avatar.GetId()) or nil
end

function getGroupFromPersId(pid)
	if not pid or type(pid)~="userdata" then return nil end
	if isRaid() and pid then
		local members=raid.GetMembers()
		if not members then return 0 end
		local activeGroups=0
		for i=0, 3 do
			if members[i] then
				local activeGroup=false
				for j, m in pairs(members[i]) do
					if m and (m.uniqueId and m.uniqueId.IsEqual and m.uniqueId.IsEqual(pid, m.uniqueId) or m.persistentId==pid) then return activeGroups end
					activeGroup=true
				end
				if activeGroup then activeGroups=activeGroups+1 end
			end
		end
	end
	return nil
end

function getGroupSizeFromPersId(pid)
	if not pid or type(pid)~="userdata" then return nil end
	if isRaid() then
		local group=nil
		local members=raid.GetMembers()
		if not members then return nil end
		for i=0, 3 do
			if members[i] then
				for j, m in pairs(members[i]) do
					if m and (m.uniqueId and m.uniqueId.IsEqual and m.uniqueId.IsEqual(pid, m.uniqueId) or m.persistentId==pid) then group=i end
				end
			end
		end
		if not group then return nil end

		local size=0
		for j, m in pairs(members[group]) do
			size=size+1
		end
		return size
	end
	return nil
end

function getFirstEmptyPartyInRaid()
	if isRaid() then
		local members=raid.GetMembers()
		if not members then return nil end
		for i=0, 3 do
			local active=false
			if members[i] then
				for j, m in pairs(members[i]) do
					active=true
				end
			end
			if not active then return i end
		end
	end
	return nil
end

function getLeaderName()
	local groupLeaderIndex=isGroup() and group.GetLeaderIndex and group.GetLeaderIndex()
	local raidLeaderIndex=isRaid() and raid.GetLeader and raid.GetLeader()
	local raidLeaderInfo=raidLeaderIndex and raid.GetMemberInfo and raid.GetMemberInfo(raidLeaderIndex)
	return 	raidLeaderInfo and raidLeaderInfo.name
		or 		groupLeaderIndex and groupLeaderIndex>-1 and group.GetMemberNameByIndex and group.GetMemberNameByIndex(groupLeaderIndex)
		or		isRaid() and raid.GetLeaderName and raid.GetLeaderName()
end
