Global( "wtControl3D", stateMainForm:GetChildChecked("MainAddonMainForm", false):GetChildChecked( "MainScreenControl3D", false) )
Global( "BuffInternal", mainForm:GetChildChecked("BuffInternal", false) )
Global( "BuffDesc", BuffInternal:GetWidgetDesc() )
Global( "wtCont", mainForm:GetChildChecked("ContainerBar", false) )
Global( "wtContDesc", wtCont:GetWidgetDesc() )
Global( "wtTarget", mainForm:GetChildChecked( "Target", false ))

do
	
	if not unit.IsEnemy then

		unit.IsEnemy = object.IsEnemy

	end
	
end

Global( "MODE", nil) -- on off
Global( "ContExist", {})
Global( "Buff", {} )
Global( "Unit", {} )
Global( "TimeTracker", {})
Global( "wtContainer", {} )  
Global( "wtChild", {} )
Global( "BuffListPVP", {} )
BuffListPVP = Locales["ger"]["PVP"]
Global( "BuffListPVE", {} )
BuffListPVE = Locales["ger"]["PVE"]
Global( "BuffListMOB", {} )
BuffListMOB = Locales["ger"]["MOB"]

Global( "UserListPVP", {} )
Global( "UserListPVE", {} )
Global( "UserListMOB", {} )

Global( "STACKFORMAT", userMods.ToWString("<header aligny='center' alignx='right' fontsize='18' outline='1' outlinecolor='0xFF000000'><rs class='class'><b><r name='stack' /></b></rs></header>") )
Global( "TIMEFORMAT", userMods.ToWString("<header alignx='center' fontsize='15' outline='1' outlinecolor='0xFF000000'><r name='timer'/></header>") )

Global( "CONT_Y", 90 ) ---must be higher than 60 (120)
Global( "CHILD_Y", 60 ) -- 60
Global( "CHILD_X", 40 ) -- 40



Global( "SHOWFRIENDLYMOBTARGET", false )
local anzPanel = 0

--------------------GS IMPLEMENTATION
Global( "GSInternal", mainForm:GetChildChecked( "GSInternal", false) )
Global( "TextGS", GSInternal:GetChildChecked("GS", false))
Global( "TextDesc", TextGS:GetWidgetDesc())
TextGS:Show(false)

local GSText = mainForm:CreateWidgetByDesc(TextDesc)
local RuneText = mainForm:CreateWidgetByDesc(TextDesc)
local MText = mainForm:CreateWidgetByDesc(TextDesc)
local lasttarget = nil
----------------------------------------

--To Do:
--Add Checkboxes and Modes:
--1. PvE mob
--2. PvE group
--3. PvP enemy
--4. PvP friend

--Target ClassColor, Mobcolor, evtl auch �ber Checkboxes?

--evtl Settings, wo man eigene Buffs adden kann
--evtl PlayerList  mit buffs
--evtl Austauschbare Targets

--BuffInternal Widget umbenennen, leicht ab�ndern
--------------------------------------------------------------------------
-------------------------SETTINGS SECTION---------------------------------
--------------------------------------------------------------------------
Global( "OptionPanel", mainForm:GetChildChecked( "OptionPanel", false ) )
Global( "TitleText", OptionPanel:GetChildChecked( "Title", false ) )
Global( "StatusText", OptionPanel:GetChildChecked( "StatusText", false ) )
Global( "StatusCounter", 0 )

Global( "Mode", OptionPanel:GetChildChecked( "Modes", false ) )
Global( "Mode2", OptionPanel:GetChildChecked( "Modes2", false ) )
Global( "Mode3", OptionPanel:GetChildChecked( "Modes3", false ) )
Global( "Mode4", OptionPanel:GetChildChecked( "Modes4", false ) )

-------------------------BUFFS------------------------------
Global( "CP1", OptionPanel:GetChildChecked( "CP1", false ) ) ---- Pvp
Global( "CP2", OptionPanel:GetChildChecked( "CP2", false ) ) ---- Mobs
Global( "CP3", OptionPanel:GetChildChecked( "CP3", false ) ) ---- Group
---------------------TARGET MARKER--------------------------
Global( "CP4", OptionPanel:GetChildChecked( "CP4", false ) ) ---- Mobs
Global( "CP5", OptionPanel:GetChildChecked( "CP5", false ) ) ---- PvP
Global( "CP6", OptionPanel:GetChildChecked( "CP6", false ) ) ---- Friendly Mobs
Global( "CP7", OptionPanel:GetChildChecked( "CP7", false ) ) ---- Friendly PvP
Global( "CP8", OptionPanel:GetChildChecked( "CP8", false ) ) ---- TargetGS
Global( "CP9", mainForm:CreateWidgetByDesc(CP8:GetWidgetDesc()) )

OptionPanel:AddChild(CP9)
CP9:SetName("CP9")

Global( "EPanel1", OptionPanel:GetChildChecked( "EPanel1", false ) )
Global( "EPanel2", OptionPanel:GetChildChecked( "EPanel2", false ) )
Global( "EPanel3", OptionPanel:GetChildChecked( "EPanel3", false ) )

Global( "OCBtn", mainForm:GetChildChecked( "OCBtn", false ) )

Global( "BuffPanel", mainForm:GetChildChecked( "BuffPanel", false ) )
Global( "BuffItem", BuffPanel:GetChildChecked( "BuffItem", false ) )
Global( "BuffItemDesc", BuffItem:GetWidgetDesc() )

Global( "PfeilPanel", mainForm:GetChildChecked("PfeilPanel", false))
Global( "Pfeil", PfeilPanel:GetChildChecked("Pfeil", false))
Global( "DistText", PfeilPanel:GetChildChecked("Dist", false))
PfeilPanel:Show(false)

Global( "BuffListButton", OptionPanel:GetChildChecked( "BPPanel", false):GetChildChecked( "BPButton", false) )

Global( "EditControl", OptionPanel:GetChildChecked( "EditPanel", false ):GetChildChecked( "BuffEdit", false ) )

Global( "PVP_MODE", nil )
Global( "MOB_MODE", nil )
Global( "GROUP_MODE", nil )

Global( "T_MOB", nil )
Global( "T_PVP", nil )
Global( "T_FMOB", nil )
Global( "T_FPVP", nil )
Global( "T_GS", nil )
Global( "T_DIST", nil )

local function GetConfig( name )
	local cfg = userMods.GetGlobalConfigSection( common.GetAddonName() )
	if not name then return cfg end
	return cfg and cfg[ name ]
end

local function SetConfig( name, value )
	local cfg = userMods.GetGlobalConfigSection( common.GetAddonName() ) or {}
	if type( name ) == "table" then
		for i, v in pairs( name ) do cfg[ i ] = v end
	elseif name ~= nil then
		cfg[ name ] = value
	end
	userMods.SetGlobalConfigSection( common.GetAddonName(), cfg )
end


--------------------------------------------------------------------------


function CheckBoxClicked( p ) 
	if p.widget:IsEqual( CP1:GetChildChecked( "CheckBox",false) ) then
		 local variant = ( { [ 0 ] = 1, [ 1 ] = 0 } )[ p.widget:GetVariant() ]
		 p.widget:SetVariant( variant )
		 if p.widget:GetVariant() == 1 then
		 PVP_MODE = true
		 SetConfig("PVP_MODE1", PVP_MODE)
		 elseif p.widget:GetVariant() == 0 then 
		 PVP_MODE = false
		 SetConfig("PVP_MODE1", 0)
		 end
		 
	end
	if p.widget:IsEqual( CP2:GetChildChecked( "CheckBox",false) ) then
		 local variant = ( { [ 0 ] = 1, [ 1 ] = 0 } )[ p.widget:GetVariant() ]
		 p.widget:SetVariant( variant )
		 if p.widget:GetVariant() == 1 then
		 MOB_MODE = true
		 SetConfig("MOB_MODE1", MOB_MODE)
		 elseif p.widget:GetVariant() == 0 then 
		 MOB_MODE = false
		 SetConfig("MOB_MODE1", 0)
		 end
		 
	end
	if p.widget:IsEqual( CP3:GetChildChecked( "CheckBox",false) ) then
		 local variant = ( { [ 0 ] = 1, [ 1 ] = 0 } )[ p.widget:GetVariant() ]
		 p.widget:SetVariant( variant )
		 if p.widget:GetVariant() == 1 then
		 GROUP_MODE = true
		 SetConfig("GROUP_MODE1", GROUP_MODE)
		 elseif p.widget:GetVariant() == 0 then 
		 GROUP_MODE = false
		 SetConfig("GROUP_MODE1", 0)
		 end
		
	end

	if p.widget:IsEqual( CP4:GetChildChecked( "CheckBox",false) ) then
		 local variant = ( { [ 0 ] = 1, [ 1 ] = 0 } )[ p.widget:GetVariant() ]
		 p.widget:SetVariant( variant )
		 if p.widget:GetVariant() == 1 then
		 T_MOB = true
		 SetConfig("T_MOB1", T_MOB)
		 elseif p.widget:GetVariant() == 0 then 
		 T_MOB = false
		 SetConfig("T_MOB1", 0)
		 end
		
	end
	if p.widget:IsEqual( CP5:GetChildChecked( "CheckBox",false) ) then
		 local variant = ( { [ 0 ] = 1, [ 1 ] = 0 } )[ p.widget:GetVariant() ]
		 p.widget:SetVariant( variant )
		 if p.widget:GetVariant() == 1 then
		 T_PVP = true
		 SetConfig("T_PVP1", T_PVP)
		 elseif p.widget:GetVariant() == 0 then 
		 T_PVP = false
		 SetConfig("T_PVP1", 0)
		 end
		
	end
	if p.widget:IsEqual( CP6:GetChildChecked( "CheckBox",false) ) then
		 local variant = ( { [ 0 ] = 1, [ 1 ] = 0 } )[ p.widget:GetVariant() ]
		 p.widget:SetVariant( variant )
		 if p.widget:GetVariant() == 1 then
		 T_FMOB = true
		 SetConfig("T_FMOB1", T_FMOB)
		 elseif p.widget:GetVariant() == 0 then 
		 T_FMOB = false
		 SetConfig("T_FMOB1", 0)
		 end
		 
	end
	if p.widget:IsEqual( CP7:GetChildChecked( "CheckBox",false) ) then
		 local variant = ( { [ 0 ] = 1, [ 1 ] = 0 } )[ p.widget:GetVariant() ]
		 p.widget:SetVariant( variant )
		 if p.widget:GetVariant() == 1 then
		 T_FPVP = true
		 SetConfig("T_FPVP1", T_FPVP)
		 elseif p.widget:GetVariant() == 0 then 
		 T_FPVP = false
		 SetConfig("T_FPVP1", 0)
		 end
		 
	end
	if p.widget:IsEqual( CP8:GetChildChecked( "CheckBox",false) ) then
		 local variant = ( { [ 0 ] = 1, [ 1 ] = 0 } )[ p.widget:GetVariant() ]
		 p.widget:SetVariant( variant )
		 if p.widget:GetVariant() == 1 then
		 T_GS = true
		 SetConfig("T_GS1", T_GS)
		 elseif p.widget:GetVariant() == 0 then 
		 T_GS = false
		 SetConfig("T_GS1", 0)
		 end
		 
	end
	if p.widget:IsEqual( CP9:GetChildChecked( "CheckBox",false) ) then
		 local variant = ( { [ 0 ] = 1, [ 1 ] = 0 } )[ p.widget:GetVariant() ]
		 p.widget:SetVariant( variant )
		 if p.widget:GetVariant() == 1 then
		 T_DIST = true
		 SetConfig("T_DIST1", T_DIST)
		 elseif p.widget:GetVariant() == 0 then 
		 T_DIST = false
		 SetConfig("T_DIST1", 0)
		 end
		 
	end
	
end

function SetVariants()

	if PVP_MODE == true then
		CP1:GetChildChecked( "CheckBox",false):SetVariant(1)
	elseif PVP_MODE == false then 
		CP1:GetChildChecked( "CheckBox",false):SetVariant(0)
	end
	if MOB_MODE == true then
		CP2:GetChildChecked( "CheckBox",false):SetVariant(1) 
	elseif MOB_MODE == false then 
		CP2:GetChildChecked( "CheckBox",false):SetVariant(0) 
	end
	if GROUP_MODE == true then
		CP3:GetChildChecked( "CheckBox",false):SetVariant(1) 
	elseif GROUP_MODE == false then 
		CP3:GetChildChecked( "CheckBox",false):SetVariant(0) 
	end
	if T_MOB == true then
		CP4:GetChildChecked( "CheckBox",false):SetVariant(1) 
	elseif T_MOB == false then 
		CP4:GetChildChecked( "CheckBox",false):SetVariant(0) 
	end
	if T_PVP == true then
		CP5:GetChildChecked( "CheckBox",false):SetVariant(1) 
	elseif T_PVP == false then 
		CP5:GetChildChecked( "CheckBox",false):SetVariant(0) 
	end
	if T_FMOB == true then
		CP6:GetChildChecked( "CheckBox",false):SetVariant(1) 
	elseif T_FMOB == false then 
		CP6:GetChildChecked( "CheckBox",false):SetVariant(0) 
	end
	if T_FPVP == true then
		CP7:GetChildChecked( "CheckBox",false):SetVariant(1) 
	elseif T_FPVP == false then 
		CP7:GetChildChecked( "CheckBox",false):SetVariant(0) 
	end
	if T_GS == true then
		CP8:GetChildChecked( "CheckBox",false):SetVariant(1) 
	elseif T_GS == false then 
		CP8:GetChildChecked( "CheckBox",false):SetVariant(0) 
	end
	
	if T_DIST == true then
		CP9:GetChildChecked( "CheckBox",false):SetVariant(1) 
	elseif T_DIST == false then 
		CP9:GetChildChecked( "CheckBox",false):SetVariant(0) 
	end

end

function SetupCheckboxes()

	
	local textformat = '<header color="0xFFFFFFFF" alignx="center" fontsize="14" outline="1" ><rs class="class"><r name="StatusText" /></rs></header>' 
	StatusText:SetFormat( userMods.ToWString( textformat ) )
	
	
	local P = CP1:GetPlacementPlain()
	textformat = '<header color="0xFFFFFFFF" alignx="center" fontsize="15" outline="1" outlinecolor="0xFF990000"><rs class="class"><r name="CheckText" /></rs></header>' 
	CP1:GetChildChecked( "CheckText", false ):SetFormat( userMods.ToWString( textformat ) )
	CP1:GetChildChecked( "CheckText", false ):SetVal( "CheckText", userMods.ToWString( "Enemy Players" ) )
	CP1:GetChildChecked( "CheckText", false ):Show(true)
	P.posY = 75
	CP1:SetPlacementPlain( P )
	textformat = '<header color="0xFFFFFFFF" alignx="center" fontsize="15" outline="1" outlinecolor="0xFFCC6600"><rs class="class"><r name="CheckText" /></rs></header>' 
	
	CP2:GetChildChecked( "CheckText", false ):SetFormat( userMods.ToWString( textformat ) )
	CP2:GetChildChecked( "CheckText", false ):SetVal( "CheckText", userMods.ToWString( "Mobs" ) )
	CP2:GetChildChecked( "CheckText", false ):Show(true)
	P.alignX = WIDGET_ALIGN_CENTER
	CP2:SetPlacementPlain( P )
	textformat = '<header color="0xFFFFFFFF" alignx="center" fontsize="15" outline="1" outlinecolor="0xFF006600"><rs class="class"><r name="CheckText" /></rs></header>' 
	CP3:GetChildChecked( "CheckText", false ):SetFormat( userMods.ToWString( textformat ) )
	CP3:GetChildChecked( "CheckText", false ):SetVal( "CheckText", userMods.ToWString( "Group/Raid" ) )
	CP3:GetChildChecked( "CheckText", false ):Show(true)
	P.alignX = WIDGET_ALIGN_HIGH
	
	CP3:SetPlacementPlain( P )
	
	P.posY = 155
	P.sizeX = 85
	textformat = '<header color="0xFFFFFFFF" alignx="center" fontsize="15" outline="1" outlinecolor="0xFF990000"><rs class="class"><r name="CheckText" /></rs></header>' 
	CP4:GetChildChecked( "CheckText", false ):SetFormat( userMods.ToWString( textformat ) )
	CP4:GetChildChecked( "CheckText", false ):SetVal( "CheckText", userMods.ToWString( "Mobs" ) )
	CP4:GetChildChecked( "CheckText", false ):Show(true)
	P.alignX = WIDGET_ALIGN_LOW
	P.posX = 15
	CP4:SetPlacementPlain( P )
	
	CP5:GetChildChecked( "CheckText", false ):SetFormat( userMods.ToWString( textformat ) )
	CP5:GetChildChecked( "CheckText", false ):SetVal( "CheckText", userMods.ToWString( "PvP" ) )
	CP5:GetChildChecked( "CheckText", false ):Show(true)
	P.alignX = WIDGET_ALIGN_LOW
	P.posX = 100
	CP5:SetPlacementPlain( P )
	textformat = '<header color="0xFFFFFFFF" alignx="center" fontsize="15" outline="1" outlinecolor="0xFF006600"><rs class="class"><r name="CheckText" /></rs></header>' 
	CP6:GetChildChecked( "CheckText", false ):SetFormat( userMods.ToWString( textformat ) )
	CP6:GetChildChecked( "CheckText", false ):SetVal( "CheckText", userMods.ToWString( "Fr. Mobs" ) )
	CP6:GetChildChecked( "CheckText", false ):Show(true)
	P.alignX = WIDGET_ALIGN_LOW
	P.posX = 195
	CP6:SetPlacementPlain( P )
	
	CP7:GetChildChecked( "CheckText", false ):SetFormat( userMods.ToWString( textformat ) )
	CP7:GetChildChecked( "CheckText", false ):SetVal( "CheckText", userMods.ToWString( "Fr. Players" ) )
	CP7:GetChildChecked( "CheckText", false ):Show(true)
	P.alignX = WIDGET_ALIGN_LOW
	P.posX = 290
	CP7:SetPlacementPlain( P )
	
	CP8:GetChildChecked( "CheckText", false ):SetFormat( userMods.ToWString( textformat ) )
	CP8:GetChildChecked( "CheckText", false ):SetVal( "CheckText", userMods.ToWString( "GS,Runes" ) )
	CP8:GetChildChecked( "CheckText", false ):Show(true)
	P.alignX = WIDGET_ALIGN_LOW
	P.posX = 15
	P.posY = 235
	CP8:SetPlacementPlain( P )
	
	CP9:GetChildChecked( "CheckText", false ):SetFormat( userMods.ToWString( textformat ) )
	CP9:GetChildChecked( "CheckText", false ):SetVal( "CheckText", userMods.ToWString( "Target Dist" ) )
	CP9:GetChildChecked( "CheckText", false ):Show(true)
	P.alignX = WIDGET_ALIGN_LOW
	P.posX = 100
	--P.posY = 235
	CP9:SetPlacementPlain( P )
	
	SetVariants()
	CP1:Show( true )
	CP2:Show( true )
	CP3:Show( true )
	CP4:Show( true )
	CP5:Show( true )
	CP6:Show( true )
	CP7:Show( true )
	CP8:Show( true )
	CP9:Show( true )
	
end

function SetupEPanels()
	local textformat = '<header color="0xFFFFFFFF" alignx="center" fontsize="15" outline="1" outlinecolor="0xFF990000"><rs class="class"><r name="EText" /></rs></header>'
	EPanel1:GetChildChecked( "EText", false ):SetFormat( userMods.ToWString( textformat ) )
	EPanel1:GetChildChecked( "EText", false ):SetVal( "EText", userMods.ToWString( "Enemy Players" ))
	textformat = '<header color="0xFFFFFFFF" alignx="center" fontsize="15" outline="1" outlinecolor="0xFFCC6600"><rs class="class"><r name="EText" /></rs></header>' 
	EPanel2:GetChildChecked( "EText", false ):SetFormat( userMods.ToWString( textformat ) )
	EPanel2:GetChildChecked( "EText", false ):SetVal( "EText", userMods.ToWString( "Mobs" ))
	textformat = '<header color="0xFFFFFFFF" alignx="center" fontsize="15" outline="1" outlinecolor="0xFF006600"><rs class="class"><r name="EText" /></rs></header>' 
	EPanel3:GetChildChecked( "EText", false ):SetFormat( userMods.ToWString( textformat ) )
	EPanel3:GetChildChecked( "EText", false ):SetVal( "EText", userMods.ToWString( "Group/Raid" ))
	
end

function CloseBtn(p)
OptionPanel:Show(not OptionPanel:IsVisible() )
BuffPanel:Show( false )
end

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end
	
local widlist = {}

function SetupBuffPanel()
	local greenformat = '<header color="0xFFFFFFFF" alignx="center" fontsize="15" outline="1" outlinecolor="0xFF006600"><rs class="class"><r name="BuffItem" /></rs></header>'
	local redformat = '<header color="0xFFFFFFFF" alignx="center" fontsize="15" outline="1" outlinecolor="0xFF500000"><rs class="class"><r name="BuffItem" /></rs></header>' 
	local P = BuffItem:GetPlacementPlain()
	local S = BuffPanel:GetPlacementPlain()
	local ystart = 80
	local y1 = ystart
	local y2 = ystart
	local y3 = ystart
	local yges = ystart
	
	for k,v in pairs( widlist ) do
		if v then 
		v:DestroyWidget() 
		v = nil
		widlist[k] = nil
		end
	end
	

	
	for k, v in spairs(BuffListPVP, function(t,a,b) return a < b end) do
	if k ~= "testvalue11" then
		P.alignX = WIDGET_ALIGN_LOW
		P.posX = 15
		if not widlist["p"..k] or widlist["p"..k] == nil then
		local wid = mainForm:CreateWidgetByDesc( BuffItemDesc )
		BuffPanel:AddChild( wid )
		P.posY = y1
		wid:SetPlacementPlain( P )
		y1 = y1 + 15
		if y1 > yges then yges = y1 end
		if v == true then
			wid:SetFormat( userMods.ToWString( greenformat ))
		elseif v == false then
			wid:SetFormat( userMods.ToWString( redformat ))
		end
		wid:SetVal( "BuffItem", userMods.ToWString( k ) )
		wid:Show( true )
		widlist["p"..k] = wid
		end
		end
	end
	for k, v in spairs(BuffListMOB, function(t,a,b) return a < b end) do
	if k ~= "testvalue11" then
		P.alignX = WIDGET_ALIGN_CENTER
		P.posX = 0
		if not widlist["m"..k] or widlist["m"..k] == nil then
		local wid = mainForm:CreateWidgetByDesc( BuffItemDesc )
		BuffPanel:AddChild( wid )
		P.posY = y2
		wid:SetPlacementPlain( P )
		y2 = y2 + 15
		if y2 > yges then yges = y2 end
		if v == true then
			wid:SetFormat( userMods.ToWString( greenformat ))
		elseif v == false then
			wid:SetFormat( userMods.ToWString( redformat ))
		end
		wid:SetVal( "BuffItem", userMods.ToWString( k ) )
		wid:Show( true )
		widlist["m"..k] = wid
		end
		end
	end
		for k, v in spairs(BuffListPVE, function(t,a,b) return a < b end) do
		if k ~= "testvalue11" then
		P.alignX = WIDGET_ALIGN_HIGH
		P.posX = 15
		P.highPosX = 15
		if not widlist["e"..k] or widlist["e"..k] == nil then
		local wid = mainForm:CreateWidgetByDesc( BuffItemDesc )
		BuffPanel:AddChild( wid )
		P.posY = y3
		wid:SetPlacementPlain( P )
		y3 = y3 + 15
		if y3 > yges then yges = y3 end
		if v == true then
			wid:SetFormat( userMods.ToWString( greenformat ))
		elseif v == false then
			wid:SetFormat( userMods.ToWString( redformat ))
		end
		wid:SetVal( "BuffItem", userMods.ToWString( k ) )
		wid:Show( true )
		widlist["e"..k] = wid
		end
		end
	end
	S.sizeY = yges + 20
	BuffPanel:SetPlacementPlain( S )
	end
	



function BuffPanelButton(p)
	
		BuffPanel:Show( not BuffPanel:IsVisible() ) --not BuffPanel:IsVisible()
		if BuffPanel:IsVisible() then
			SetupBuffPanel()
			
		end
	
	
end

function EditBtnClick(p)

	--StatusText:SetVal( "StatusText", userMods.ToWString( "Group/Raid" ) )
		local Text = userMods.FromWString(EditControl:GetText())
		
	if Text and Text ~= nil and Text ~= " "  then --and not string.find( Text, " " )
	if p.widget:IsEqual( EPanel1:GetChildChecked( "EditBtn1",false) ) then ---Pvp
	if not BuffListPVP[Text] or BuffListPVP[Text] == false then
		BuffListPVP[Text] = true
		UserListPVP[Text] = true
		SetConfig( "UserListPVP", UserListPVP )
		StatusText:Show( true )
		StatusText:SetVal( "StatusText", userMods.ToWString( Text .. " added to PVP List!" ) )
		StatusCounter = 10
	elseif BuffListPVP[Text] and BuffListPVP[Text] == true then
		BuffListPVP[Text] = false
		UserListPVP[Text] = false
		SetConfig( "UserListPVP", UserListPVP )
		StatusText:Show( true )
		StatusText:SetVal( "StatusText", userMods.ToWString( Text .. " disabled in PVP List!" ) )
		StatusCounter = 10
	end
	end
	
	if p.widget:IsEqual( EPanel2:GetChildChecked( "EditBtn2",false) ) then ---Mobs
	if not BuffListMOB[Text] or BuffListMOB[Text] == false then
		BuffListMOB[Text] = true
		UserListMOB[Text] = true
		SetConfig( "UserListMOB", UserListMOB )
		StatusText:Show( true )
		StatusText:SetVal( "StatusText", userMods.ToWString( Text .. " added to MOB List!" ) )	
		StatusCounter = 10
		elseif BuffListMOB[Text] and BuffListMOB[Text] == true then
		BuffListMOB[Text] = false
		UserListMOB[Text] = false
		SetConfig( "UserListMOB", UserListMOB )
		StatusText:Show( true )
		StatusText:SetVal( "StatusText", userMods.ToWString( Text .. " disabled in MOB List!" ) )
		StatusCounter = 10
	end
	end
	if p.widget:IsEqual( EPanel3:GetChildChecked( "EditBtn3",false) ) then ---Group/Raid
	if not BuffListPVE[Text] or BuffListPVE[Text] == false then
		BuffListPVE[Text] = true
		UserListPVE[Text] = true
		SetConfig( "UserListPVE", UserListPVE )
		StatusText:Show( true )
		StatusText:SetVal( "StatusText", userMods.ToWString( Text .. " added to GROUP/RAID List!" ) )	
		StatusCounter = 10
	elseif BuffListPVE[Text] and BuffListPVE[Text] == true then
		BuffListPVE[Text] = false
		UserListPVE[Text] = false
		SetConfig( "UserListPVE", UserListPVE )
		StatusText:Show( true )
		StatusText:SetVal( "StatusText", userMods.ToWString( Text .. " disabled in GROUP/RAID List!" ) )
		StatusCounter = 10
	end
	
	end
	SetupBuffPanel()
end
end

-------------------------------------------------------------------------------
-------------------------------END OF SETTINGS SECTION-------------------------
-------------------------------------------------------------------------------

local function SetGameLocalization()
     local id = options.GetOptionsByCustomType( "interface_option_localization" )[ 0 ]
     if id then
         local values = options.GetOptionInfo( id ).values
         local value = values and values[ 0 ]
         local name = value and value.name
         if name then
            BuffListPVP = Locales[userMods.FromWString( name )]["PVP"]
			BuffListPVE = Locales[userMods.FromWString( name )]["PVE"]
			BuffListMOB = Locales[userMods.FromWString( name )]["MOB"]
         else
             
          end
     end
end


local sysname = {
	[ "BARD" ] = "Bard",
	[ "DRUID" ] = "Druid",
	[ "MAGE" ] = "Mage",
	[ "NECROMANCER" ] = "Necromancer",
	[ "PALADIN" ] = "Paladin",
	[ "PRIEST" ] = "Priest",
	[ "PSIONIC" ] = "Psionic",
	[ "STALKER" ] = "Stalker",
	[ "WARRIOR" ] = "Warrior",
	[ "ENGINEER" ] = "Engineer"
}
local color = {
	[ "BARD" ] = { a = 255, r = 106, g = 230, b = 223 },
	[ "DRUID" ] = { a = 255, r = 255, g = 118, b = 60 },
	[ "MAGE" ] = { a = 255, r = 126, g = 159, b = 255 },
	[ "NECROMANCER" ] = { a = 255, r = 208, g = 69, b = 75 },
	[ "PALADIN" ] = { a = 255, r = 207, g = 220, b = 155 },
	[ "PRIEST" ] = { a = 255, r = 255, g = 207, b = 123 },
	[ "PSIONIC" ] = { a = 255, r = 221, g = 123, b = 245 },
	[ "STALKER" ] = { a = 255, r = 150, g = 204, b = 86 },
	[ "WARRIOR" ] = { a = 255, r = 143, g = 119, b = 75 },
	[ "ENGINEER" ] = { a = 255, r = 135, g = 163, b = 177 }
}

--------------------------------------------------------------------------------
for key, color in pairs( color ) do
	for id, component in pairs( color ) do
		color[ id ] = component / 255
	end
end
--------------------------------------------------------------------------------
-------------------------------------------------------------------------
local function GetClassName( sample )
	if sample then
		local sampletype = type( sample )
		
		if sampletype == "string" then
			if sysname[ sample ] then
				return sample
			else
				--LogWarning( "Invalid player class sysName passed: \"", tostring( sample ), "\"" )
			end
			
		elseif sampletype == "number" then
			if unit.IsPlayer( sample ) then
				return unit.GetClass( sample ).className
			end
		end
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function GetUnitClassColor( sample )
	local classname = GetClassName( sample )
	return classname and color[ classname ]
end

function DeadChanged(p)
if p.unitId == avatar.GetId() then
	for a, b in pairs(Unit) do
		for key, val in pairs(Buff[b]) do
			if wtChild[b][val] then
				wtChild[b][val]:GetChildChecked( "Icon", false):Show(false)
				wtChild[b][val]:GetChildChecked( "Icon", false):Show(false)
				wtChild[b][val]:GetChildChecked( "Icon", false):Show(false)
				wtChild[b][val]:Show(false)
				wtChild[b][val]:DestroyWidget()
				wtChild[b][val] = nil
				Buff[b][val] = nil
			end
		end
		local temp = 0
				for i,c in pairs(wtChild[b]) do
				temp = temp + 1
				end
				if temp == 0 then
				--Cont aufl�sen
				wtChild[b] = nil
				wtContainer[b]:DestroyWidget()
				wtContainer[b] = nil
				ContExist[b] = nil
				Buff[b] = nil
				Unit[b] = nil
				end
	end
end
end

function HandlePlacement(unitId)

local temp = 0
  
  for i,val in pairs(wtChild[unitId]) do
  local pla = val:GetPlacementPlain()
	pla.sizeX = CHILD_X
	pla.sizeY = CHILD_Y
	pla.posY = 0
	pla.posX = temp * CHILD_X
  wtChild[unitId][i]:SetPlacementPlain(pla)
-- Textur richten:
--local texture = object.GetBuffInfo(i)
--texture = texture.texture
--wtChild[unitId][i]:GetChildChecked( "Icon", false ):SetBackgroundTexture(texture)

  temp = temp + 1
  end
  if wtContainer[unitId] then
local CP = wtContainer[unitId]:GetPlacementPlain()
CP.sizeY = CONT_Y
CP.sizeX = (temp * CHILD_X) 
wtContainer[unitId]:SetPlacementPlain(CP)
end
end

function CreateCont(unitId)
if not wtContainer[unitId] then ---and not ContExist[unitId] == true
					Unit[unitId] = unitId
					wtContainer[unitId] = mainForm:CreateWidgetByDesc(wtContDesc) --Create  Container if there isnt already one
					wtContainer[unitId]:Show(false)
					local P = wtContainer[unitId]:GetPlacementPlain()
					P.sizeY = CONT_Y
					P.sizeX = CHILD_X + 1 ----------ANZPANEL: ERST CHILDS DURHZ�HLEN; DA NICHT ALLE AUF EINMAL ANGEZEIGT
					wtContainer[unitId]:SetPlacementPlain(P)
					ContExist[unitId] = true
				end
				
				

end

function CreateChild(unitId, buffs, buffId)

				if not wtChild[unitId] then
					wtChild[unitId] = {}
				end
				if not wtChild[unitId][buffId] then
					wtChild[unitId][buffId] = mainForm:CreateWidgetByDesc(BuffDesc)
					wtChild[unitId][buffId]:GetChildChecked( "Icon", false):SetBackgroundTexture(buffs.texture)
				end
				if buffs.isPositive then
					wtChild[unitId][buffId]:GetChildChecked( "Icon" , false):SetForegroundColor( { r = 0.0; g = 1.0; b = 0.0; a = 1.0 } )
				else
					wtChild[unitId][buffId]:GetChildChecked( "Icon" , false):SetForegroundColor( { r = 0.7; g = 0.0; b = 0.0; a = 1.0 } )
				end	
					
				local pa = wtChild[unitId][buffId]:GetPlacementPlain() -----oder direkt ins HandlePlacement
				pa. sizeX = CHILD_X
				pa.sizeY = CHILD_Y
				pa.posY = 0
				pa. posX = 0 
				wtChild[unitId][buffId]:SetPlacementPlain(pa)
				
				if not TimeTracker[unitId] then
					TimeTracker[unitId] = {}
				end
				if TimeTracker[unitId][buffId] then
					TimeTracker[unitId][buffId] = nil
				end
				local Stack = wtChild[unitId][buffId]:GetChildChecked("Stack", false)
				local Time = wtChild[unitId][buffId]:GetChildChecked("Time", false)
				
				Stack:SetFormat(STACKFORMAT)
				Time:SetFormat(TIMEFORMAT)
				Stack:Show(false)
				Time:Show(false)				
					if buffs.durationMs > 0 and buffs.remainingMs > 0 then
					local times = math.ceil( buffs.remainingMs / 1000 )
						local timetype = "s"
						if times >= 60 then
							times = math.ceil( times / 60 )
							timetype = "m"
							if times >= 60 then
								times = math.ceil( times / 60 )
								timetype = "h"
							end
						end

					if not TimeTracker[unitId][buffId] then
					TimeTracker[unitId][buffId] = true
					end
					Time:SetVal("timer", userMods.ToWString(times.." "..timetype))
					Time:Show(true)
				end
				if buffs.stackCount > 1 then
					
					Stack:SetVal("stack", common.FormatInt(buffs.stackCount, "%d"))
					
					Stack:Show(true)
					--end
				end	
					
				
end


function ExistCheck(p) 
local notExist
if wtChild[p.unitId] then
for j, val in pairs(wtChild[p.unitId]) do
		local notExist = true
		for i, v in pairs(object.GetBuffs(p.unitId)) do
			if v == j then
				notExist = false
			end
		end
		if notExist == true then -------l�schung des Child widgets
				wtChild[p.unitId][j]:GetChildChecked("Time", false):SetFormat( TIMEFORMAT )
				wtChild[p.unitId][j]:GetChildChecked("Time", false):SetVal("timer", userMods.ToWString("F"))
				--wtChild[p.unitId][j]:GetChildChecked( "Icon", false ):Show(false)
				--wtChild[p.unitId][j]:GetChildChecked( "Stack", false ):Show(false)
				--wtChild[p.unitId][j]:GetChildChecked( "Time", false ):Show(false)				
				---wtChild[p.unitId][j]:GetChildChecked( "Icon", false ):DestroyWidget()
				--wtChild[p.unitId][j]:GetChildChecked( "Stack", false ):DestroyWidget()
				--wtChild[p.unitId][j]:GetChildChecked( "Time", false ):DestroyWidget()
				wtChild[p.unitId][j]:Show(false)
				wtChild[p.unitId][j]:DestroyWidget() --Widget aufr�umen
				wtChild[p.unitId][j] = nil
				Buff[p.unitId][j] = nil
				HandlePlacement(p.unitId)
				if TimeTracker[p.unitId] and TimeTracker[p.unitId][j] then
					--TimeTracker[p.unitId][j] = nil
				end
				local temp = 0
				for i,c in pairs(wtChild[p.unitId]) do
				temp = temp + 1
				end
				if temp == 0 then
				--Cont aufl�sen
				wtChild[p.unitId] = nil
				wtContainer[p.unitId]:DestroyWidget()
				wtContainer[p.unitId] = nil
				ContExist[p] = nil
				Buff[p.unitId] = nil
				Unit[p.unitId] = nil
				end
				
		end
		
	end	

end



end

function AddBuff( List, p, buffs )
for key, val in pairs(List) do
						if List[userMods.FromWString(buffs.name)] and List[userMods.FromWString(buffs.name)] == true and buffs.texture then
							if not Buff[p.unitId] then Buff[p.unitId] = {} end
							if not Buff[p.unitId][p.buffId] then
							Buff[p.unitId][p.buffId] = p.buffId  --z.B. Buff["Phlebo"] == BuffId oder eher Buff[p.unitId][p.buffId] = true ??
							CreateCont(p.unitId) --create Container if needed			
							CreateChild(p.unitId, buffs, p.buffId)--create Child if needed
							wtContainer[p.unitId]:AddChild(wtChild[p.unitId][p.buffId])
							wtChild[p.unitId][p.buffId]:Show(true)
							wtContainer[p.unitId]:Show(true)
							
							HandlePlacement(p.unitId)
							
							local S = wtContainer[p.unitId]:GetPlacementPlain()
							
							local size = {}
							size.sizeX = CHILD_X + 1
							size.sizeY = S.sizeY
							--if not ContExist[p.unitId] then
							wtControl3D:AddWidget3D(wtContainer[p.unitId], size, object.GetPos(avatar.GetId()), true, false, 120.0, WIDGET_3D_BIND_POINT_HIGH, 0.7, 1.0 )
							object.AttachWidget3D(p.unitId, wtControl3D, wtContainer[p.unitId], 1)
					
							HandlePlacement(p.unitId)
							size.sizeX = S.sizeX 
							size.sizeY = S.sizeY 
							wtControl3D:SetWidget3DSize( wtContainer[p.unitId], size ) 
						end
						end		
						
end

end


function Buffs(p)
if p.init then
else
		local buffs
	if p.objectId then
		buffs = object.GetBuffInfo(p.buffId)
	else
		buffs = unit.GetBuff(p.unitId, p.index)
		p.buffId = buffs.buffId
	end
	if p.objectId then
		p.unitId = p.objectId
	end
	local unitId = p.unitId	
	
	 -----PVP BUFFS auf GEGNERN
	
	
		if unitId and unitId ~= nil and isExist(unitId) and object.IsUnit(unitId) and unit.IsPlayer(unitId) and PVP_MODE == true then
			if not avatar.GetFactionInfo( unit.GetFactionId( unitId ) ).isFriend or object.IsEnemy( unitId ) then
				if buffs and buffs.isPositive then
					AddBuff( BuffListPVP, p, buffs )
				end
				if buffs and not buffs.isPositive and buffs.producer.casterId and buffs.producer.casterId == avatar.GetId() or ( isExist( buffs.producer.casterId ) and object.IsUnit( buffs.producer.casterId ) and unit.IsPet( buffs.producer.casterId ) and avatar.GetId() == unit.GetPetOwner(buffs.producer.casterId ) ) then
					AddBuff( BuffListPVP, p, buffs )
				end
				
			end
		end 
		
	local notMe = true
	if  unitId == avatar.GetId() then
		notMe = false
	end
	
	-----PVE BUFFS AUF GRUPPE/RAID
	if unitId  and unitId ~= nil and unitId ~= avatar.GetId() and GROUP_MODE == true then
	if isGroup() or isRaid() then
	if unitId and isExist(unitId) and isFriend(unitId) and unit.IsPlayer(unitId) then
		if unitId  and group.IsCreatureInGroup(unitId) or raid.IsPlayerInAvatarsRaidGroup(object.GetName(unitId)) or  raid.IsPlayerInAvatarsRaid(object.GetName(unitId)) then
		
		AddBuff( BuffListPVE, p, buffs )
		
		
			end
		end
	end
	end

		-----PVE BUFFS AUF Mobs
--if unitId and not object.IsDead(unitId) and not unit.IsPlayer( unitId )  and object.IsEnemy( unitId ) then
if p.objectId and MOB_MODE == true then
if unitId  and unitId ~= nil and isExist(unitId) and object.IsUnit(unitId) and not unit.IsPlayer(unitId) then		
	if not avatar.GetFactionInfo( unit.GetFactionId( unitId ) ).isFriend then
	if buffs and buffs.isPositive then
		AddBuff( BuffListMOB, p, buffs )
		end
		
		if buffs and not buffs.isPositive and buffs.producer.casterId and buffs.producer.casterId ~= nil and buffs.producer.casterId == avatar.GetId() or ( isExist( buffs.producer.casterId ) and unit.IsPet( buffs.producer.casterId ) and avatar.GetId() == unit.GetPetOwner(buffs.producer.casterId ) ) then
		AddBuff( BuffListMOB, p, buffs )
		end
		
	end
end	
end	

end
end


function BuffEChanged(p)
if p.objects then
p.units = p.objects
end

	for key, value in pairs(p.units) do
		if object.GetBuffCount(key) and Buff[key]  then
			for j, x in pairs(value) do
				local buffs
				if p.objects and j and x then
					buffs = object.GetBuffInfo(j)
				else
					buffs = avatar.GetBuffInfoById(j)
				end
				if buffs and buffs.producer and buffs.producer.casterId then
					if buffs.stackLimit > 1 then ---buffs.isStackable and 
					if buffs.stackCount > 1 then
					if wtChild[key][j] then
						wtChild[key][j]:GetChildChecked( "Stack",false):SetVal("stack", common.FormatInt(buffs.stackCount, "%d"))
						--wtChild[value][j]:GetChildChecked( "Stack",false):PlayTextScaleEffect( max_text, min_text, time_text_scale, EA_MONOTONOUS_INCREASE )
						wtChild[key][j]:GetChildChecked( "Stack",false):Show(true)
					end
					end
					if buffs.stackCount == 1 then
					if wtChild[key][j] then
						wtChild[key][j]:GetChildChecked( "Stack",false):SetVal("stack", common.FormatInt(buffs.stackCount, "%d"))
						--wtChild[value][j]:GetChildChecked( "Stack",false):PlayTextScaleEffect( max_text, min_text, time_text_scale, EA_MONOTONOUS_INCREASE )
						wtChild[key][j]:GetChildChecked( "Stack",false):Show(false)
					end
					end
				end		
	
				end
			end
		end
	end
end

function BuffsChange(p)
	if p.objectId then
		p.unitId = p.objectId
	end
	
	ExistCheck(p)
end

function SecondTimer()

for i, v in pairs(TimeTracker) do --i = unitId  v == Liste{buffId1 = true, buffId2 = true}
		for j, x in pairs(v) do
			if wtChild[i] and wtChild[i][j] then
				local buffs
				for i, v in pairs(object.GetBuffs(i)) do
					if v == j then
						buffs = object.GetBuffInfo(v)
					end
				end
				if buffs then
					local times = math.ceil( buffs.remainingMs / 1000 )
					local timetype = "s"
					if times >= 60 then
						times = math.ceil( times / 60 )
						timetype = "m"
						if times >= 60 then
							times = math.ceil( times / 60 )
							timetype = "h"
						end
					end
					TimeTracker[i][j] = true
					wtChild[i][j]:GetChildChecked("Time", false):SetFormat(TIMEFORMAT)
					wtChild[i][j]:GetChildChecked( "Time",false):SetVal("timer", userMods.ToWString(times.." "..timetype))
				end
			end
		end
	end
	
	if StatusCounter > 0 then
	StatusCounter = StatusCounter - 1
	end
	if StatusCounter == 1 then
		StatusText:PlayFadeEffect( 0.9, 1.0, 1000, EA_MONOTONOUS_INCREASE )
		StatusText:PlayTextScaleEffect( 1.0, 0.8, 2000, EA_SYMMETRIC_FLASH )
	end
	if StatusCounter == 0 then 
	StatusText:Show( false )
	end
	

end

function ShowGearScore(params) -----------GS IMPLEMENTATION
	if params.unitId == avatar.GetTarget()  and T_GS == true then
		if params.gearscore and params.runesScoreOffensive then
			
			GSInternal:AddChild(GSText)
			GSText:SetFormat(userMods.ToWString( "<header color='0xFF001100' alignx='right' aligny='top' fontsize='15' outline='1'><rs class='class'><r name='GS' /></rs></header>" ))
			GSText:SetClassVal("class", params.gearscoreStyle)
			GSText:SetVal("GS", userMods.ToWString(string.format("%.0f",tostring(params.gearscore))))
			GSInternal:Show(true)
			GSText:Show(true)
			mainForm:Show(true)
			--common.LogInfo("common", userMods.ToWString(tostring(params.gearscore)))
			
			
			local p = RuneText:GetPlacementPlain()
			p.posY = 20
			RuneText:SetPlacementPlain(p)
			GSInternal:AddChild(RuneText)
			RuneText:SetFormat(userMods.ToWString( "<header color='0xFF888888' alignx='right' aligny='top' fontsize='15' outline='1'><rs class='offc'><r name='RunesOFF' /></rs>:<rs class='defc'><r name='RunesDEF' /></rs></header>" ))
			RuneText:SetClassVal("offc", params.runesStyleOffensive)
			RuneText:SetClassVal("defc", params.runesStyleDefensive)
			RuneText:SetVal("RunesOFF", userMods.ToWString(string.format("%.1f",tostring(params.runesQualityOffensive))))
			RuneText:SetVal("RunesDEF", userMods.ToWString(string.format("%.1f",tostring(params.runesQualityDefensive))))
			RuneText:Show(true)
			
			p = MText:GetPlacementPlain()
			p.posY = 40
			MText:SetPlacementPlain(p)
			GSInternal:AddChild(MText)
			MText:SetFormat(userMods.ToWString( "<header color='0xFF006600' alignx='right' aligny='top' fontsize='15' outline='1'><rs class='class'><r name='maert' /></rs></header>" ))
			MText:SetClassVal("class", params.fairyStyle)
			
			MText:SetVal("maert", userMods.ToWString(params.fairy))
			
			MText:Show(true)
			
			----ATTACH THE THING
			local size = {}
			size.sizeX = 500
			size.sizeY = 100
			wtControl3D:AddWidget3D(GSInternal, size, object.GetPos(avatar.GetId()),  false, true, 75.0, WIDGET_3D_BIND_POINT_CENTER, 1.0, 1.2 )
			object.AttachWidget3D(avatar.GetTarget(), wtControl3D, GSInternal, -1)
			--GSInternal:SetBackgroundBlendEffect( BLEND_EFFECT_HIGHLIGHT ) --BLEND_EFFECT_ADD BLEND_EFFECT_MUL
			--wtTarget:SetForegroundBlendEffect( BLEND_EFFECT_ADD )
			GSInternal:Show(true)
			lasttarget = avatar.GetTarget()
		end
	end
	
end


function PrimaryTargetChanged()
if lasttarget then
object.DetachWidget3D( lasttarget, wtTarget )
object.DetachWidget3D( lasttarget, GSInternal )
lasttarget = nil
end
Pfeil:Show(false)
		PfeilPanel:Show(false)
		DistText:Show(false)
PosChanged() 

local showit = false
local size = {}
	size.sizeX = 60
	size.sizeY = 60	
	wtTarget:SetForegroundColor( { r = 0.0; g = 1.0; b = 0.0; a = 1.0 } )
	wtTarget:SetBackgroundColor( { r = 0.0; g = 1.0; b = 0.0; a = 1.0 } )-- set a standard green
	
	
	if avatar.GetTarget() and unit.IsPlayer( avatar.GetTarget() ) and not object.IsDead(avatar.GetTarget()) and not group.IsCreatureInGroup(avatar.GetTarget()) and not raid.IsPlayerInAvatarsRaid(object.GetName(avatar.GetTarget())) and T_PVP == true then
	if avatar.GetTarget() and 	unit.GetClass( avatar.GetTarget() ) and not avatar.GetFactionInfo( unit.GetFactionId( avatar.GetTarget() ) ).isFriend or object.IsEnemy( avatar.GetTarget() ) then
	
	local className = unit.GetClass( avatar.GetTarget() ).className
	if className then
	wtTarget:SetForegroundColor( GetUnitClassColor(GetClassName(className)) )
	wtTarget:SetBackgroundColor(  GetUnitClassColor(GetClassName(className))  )
	else
	--{ r = 0.7; g = 0.0; b = 0.0; a = 1.0 }
		wtTarget:SetForegroundColor( { r = 0.7; g = 0.0; b = 0.0; a = 1.0 } )
	wtTarget:SetBackgroundColor( { r = 0.7; g = 0.0; b = 0.0; a = 1.0 } )
	
	end
	showit = true
	end
	
end
	if avatar.GetTarget() and avatar.GetTarget() ~= avatar.GetId() and unit.IsPlayer( avatar.GetTarget() ) and not object.IsDead(avatar.GetTarget()) and T_FPVP == true then
	if avatar.GetTarget() and 	unit.GetClass( avatar.GetTarget() ) and avatar.GetFactionInfo( unit.GetFactionId( avatar.GetTarget() ) ).isFriend and not object.IsEnemy( avatar.GetTarget() ) then
	
	local className = unit.GetClass( avatar.GetTarget() ).className
	if className then
	wtTarget:SetForegroundColor( GetUnitClassColor(GetClassName(className)) )
	wtTarget:SetBackgroundColor(  GetUnitClassColor(GetClassName(className))  )
	else
	--{ r = 0.7; g = 0.0; b = 0.0; a = 1.0 }
		wtTarget:SetForegroundColor( { r = 0.7; g = 0.0; b = 0.0; a = 1.0 } )
	wtTarget:SetBackgroundColor( { r = 0.7; g = 0.0; b = 0.0; a = 1.0 } )
	
	end
	showit = true
	end
	
end

if avatar.GetTarget() and isExist(avatar.GetTarget()) and object.IsUnit(avatar.GetTarget()) and not unit.IsPlayer(avatar.GetTarget()) then		
	
	wtTarget:SetForegroundColor( { r = 1.0; g = 1.0; b = 0.0; a = 1.0 } )
	wtTarget:SetBackgroundColor( { r = 1.0; g = 1.0; b = 0.0; a = 1.0 } )
	if not avatar.GetFactionInfo( unit.GetFactionId( avatar.GetTarget() ) ).isFriend and T_MOB == true then
	if unit.IsTagged( avatar.GetTarget() ) and not unit.IsTaggedByMainPlayer( avatar.GetTarget() ) then
			wtTarget:SetForegroundColor( { r = 0.6; g = 0.6; b = 0.6; a = 1.0 } )
			wtTarget:SetBackgroundColor( { r = 0.6; g = 0.6; b = 0.6; a = 1.0 } )
			showit = true
	else if (unit.IsTagged( avatar.GetTarget() ) and unit.IsTaggedByMainPlayer( avatar.GetTarget() )) or not unit.IsTagged( avatar.GetTarget() ) then
		if object.IsEnemy( avatar.GetTarget() ) then
			wtTarget:SetForegroundColor( { r = 0.7; g = 0.0; b = 0.0; a = 1.0 } )
			wtTarget:SetBackgroundColor( { r = 0.7; g = 0.0; b = 0.0; a = 1.0 } )
			showit = true
		else
			wtTarget:SetForegroundColor( { r = 1.0; g = 1.0; b = 0.0; a = 1.0 } )
			wtTarget:SetBackgroundColor( { r = 1.0; g = 1.0; b = 0.0; a = 1.0 } )
			showit = true
		end
	end
	end

	else if avatar.GetFactionInfo( unit.GetFactionId( avatar.GetTarget() ) ).isFriend and T_FMOB == true then
			wtTarget:SetForegroundColor( { r = 0.0; g = 1.0; b = 0.0; a = 1.0 } )
			wtTarget:SetBackgroundColor( { r = 0.0; g = 1.0; b = 0.0; a = 1.0 } )
			showit = true
		end
	end
end

	if showit == true and (T_MOB == true or T_PVP == true or T_FMOB == true or T_FPVP == true ) then
	wtControl3D:AddWidget3D(wtTarget, size, object.GetPos(avatar.GetId()),  false, true, 75.0, WIDGET_3D_BIND_POINT_CENTER, 0.8, 0.8 )
	object.AttachWidget3D(avatar.GetTarget(), wtControl3D, wtTarget, -1)
	wtTarget:SetBackgroundBlendEffect( BLEND_EFFECT_HIGHLIGHT ) --BLEND_EFFECT_ADD BLEND_EFFECT_MUL
	--wtTarget:SetForegroundBlendEffect( BLEND_EFFECT_ADD )
	wtTarget:Show(true)
	wtTarget:PlayRotationEffect( 0, 5, 10000, EA_SYMMETRIC_FLASH )----IM EVENT_EFFECT_FINISHED ERNEUERN
local f = wtTarget:GetPlacementPlain( )
local s  = f
s.sizeX = 10
s.sizeY = 10
--wtTarget:PlayResizeEffect( f, s, 4000, EA_MONOTONOUS_INCREASE )

	--wtTarget:PlayMoveEffect( f, s, 4000, EA_SYMMETRIC_FLASH )
	lasttarget = avatar.GetTarget()
	
	
	
	end
end

function UnitTagChanged(p)
if avatar.GetTarget() and p.unitId and isExist(avatar.GetTarget()) and isExist(p.unitId) and avatar.GetTarget() == p.unitId and object.IsUnit(avatar.GetTarget()) and not unit.IsPlayer(avatar.GetTarget()) then	
if not avatar.GetFactionInfo( unit.GetFactionId( avatar.GetTarget() ) ).isFriend then
	if unit.IsTagged( avatar.GetTarget() ) and not unit.IsTaggedByMainPlayer( avatar.GetTarget() ) then
			wtTarget:SetForegroundColor( { r = 0.6; g = 0.6; b = 0.6; a = 1.0 } )
			wtTarget:SetBackgroundColor( { r = 0.6; g = 0.6; b = 0.6; a = 1.0 } )
	else if (unit.IsTagged( avatar.GetTarget() ) and unit.IsTaggedByMainPlayer( avatar.GetTarget() )) or not unit.IsTagged( avatar.GetTarget() ) then
		if object.IsEnemy( avatar.GetTarget() ) then
			wtTarget:SetForegroundColor( { r = 0.7; g = 0.0; b = 0.0; a = 1.0 } )
			wtTarget:SetBackgroundColor( { r = 0.7; g = 0.0; b = 0.0; a = 1.0 } )
		else
			wtTarget:SetForegroundColor( { r = 1.0; g = 1.0; b = 0.0; a = 1.0 } )
			wtTarget:SetBackgroundColor( { r = 1.0; g = 1.0; b = 0.0; a = 1.0 } )
		end
	end
	end
	end


end
end


function EventEffectFinished(p)
if p.wtOwner:IsEqual( wtTarget ) and p.effectType == ET_TEXTURE_ROTATION then
	wtTarget:PlayRotationEffect( 0, 5, 10000, EA_SYMMETRIC_FLASH )----IM EVENT_EFFECT_FINISHED ERNEUERN
end
end

function UnknownSlashCommand(com)
local txt=userMods.FromWString(com.text)
if txt == "/BuffUI" then
OptionPanel:Show( not OptionPanel:IsVisible() )
BuffPanel:Show(false)
end
end

function UnitSpawned(p)
local buffs
	if p.objectId then
		p.unitId = p.objectId
	end		
	local unitId = p.unitId	
		for _, v in pairs(object.GetBuffs(p.unitId)) do
		p.buffId = v

		buffs = object.GetBuffInfo(v)
		p.buffId = v

		if unitId and buffs and unitId ~= nil and isExist(unitId) and unit.IsPlayer( unitId ) and not object.IsDead(unitId) and not group.IsCreatureInGroup(unitId) and not raid.IsPlayerInAvatarsRaid(object.GetName(unitId)) and PVP_MODE == true then
			if not avatar.GetFactionInfo( unit.GetFactionId( unitId ) ).isFriend or object.IsEnemy( unitId ) then
				if buffs and buffs.isPositive then
					AddBuff( BuffListPVP, p, buffs )
					end
				if buffs and not buffs.isPositive and buffs.producer.casterId == avatar.GetId() then
					AddBuff( BuffListPVP, p, buffs )
				end

			end
		end	
			if unitId and unitId ~= avatar.GetId() then
	if isGroup() or isRaid() then
	if unitId and unitId ~= nil and isExist(unitId) and isFriend(unitId) and unit.IsPlayer(unitId) then
		if unitId and group.IsCreatureInGroup(unitId) or raid.IsPlayerInAvatarsRaidGroup(object.GetName(unitId)) or  raid.IsPlayerInAvatarsRaid(object.GetName(unitId)) and GROUP_MODE == true then		
		AddBuff( BuffListPVE, p, buffs )
			end
		end
	end
	end

		-----PVE BUFFS AUF Mobs
--if unitId and not object.IsDead(unitId) and not unit.IsPlayer( unitId )  and object.IsEnemy( unitId ) then
if p.objectId then
if unitId and isExist(unitId) and object.IsUnit(unitId) and not unit.IsPlayer(unitId) and MOB_MODE == true then		
	if not avatar.GetFactionInfo( unit.GetFactionId( unitId ) ).isFriend then
	if buffs and buffs.isPositive then
		AddBuff( BuffListMOB, p, buffs )
		end
		
		if buffs and not buffs.isPositive and buffs.producer.casterId == avatar.GetId() then
		AddBuff( BuffListMOB, p, buffs )
		end
		
	end
end	
end	

end
	
end

function PosChanged()
	local TID = avatar.GetTarget()
	if TID and TID ~= nil and T_DIST == true then
		local TDist = getDistanceToTarget(TID)
		local TAngle = getAngleToTarget(TID)
		
		if TDist and  TAngle then
		local distancetext = "" .. tostring(string.format("%.1f", TDist)) .. "m"
		local f = '<header color="0xFFFFFFFF" alignx="left" aligny="bottom" fontsize="11" outline="1"><rs class="class"><r name="dist" /></rs></header>'
		DistText:SetFormat(f)
		DistText:SetVal("dist", userMods.ToWString(distancetext))
		--object.GetPos(TID)
		DistText:Show(true)
		
		Pfeil:Rotate(360 - ((360-TAngle) + mission.GetCameraDirection()))
		Pfeil:Show(true)
		PfeilPanel:Show(true)
		else
		Pfeil:Show(false)
		PfeilPanel:Show(false)
		DistText:Show(false)
		end
		
	else
		Pfeil:Show(false)
		PfeilPanel:Show(false)
		DistText:Show(false)
	end
	
end


function ZoneChanged(p)

end
function AOPanelStart()
local val = "BuffUI"
local SetVal
if val then
		SetVal = { val1 = userMods.ToWString( val ), class1 = "LogColorGreen" }   ---string.format("%d",val)
	local params3 = { header = SetVal, ptype = "button", size = 70, } 
	userMods.SendEvent( "AOPANEL_SEND_ADDON", { name = "BuffUI", sysName = "BuffUI", param = params3 } )
end
OCBtn:Show(false)

------------Hide Button
end

function UpdateAddon()

end

function AOPanelSend(p)
if p.sender == "BuffUI" then
OptionPanel:Show( not OptionPanel:IsVisible() )
BuffPanel:Show(false)
end
end

function PostInit()
-- Because avatar.GetId() works only after EVENT_AVATAR_CREATED.
	
	PrimaryTargetChanged(avatar.GetId())
	local a ={}
	a.init = true
	Buffs(a)
end
function SetupConfig()
PVP_MODE = GetConfig("PVP_MODE1")
	if not PVP_MODE then
	PVP_MODE = true
	SetConfig("PVP_MODE1", PVP_MODE)
	end
	if PVP_MODE == 0 then PVP_MODE = false end
	MOB_MODE = GetConfig("MOB_MODE1")
	if not MOB_MODE then
	MOB_MODE = true
	SetConfig("MOB_MODE1", MOB_MODE)
	end
	if MOB_MODE == 0 then MOB_MODE = false end
	GROUP_MODE = GetConfig("GROUP_MODE1")
	if not GROUP_MODE then
	GROUP_MODE = true
	SetConfig("GROUP_MODE1", GROUP_MODE)
	end
	if GROUP_MODE == 0 then GROUP_MODE = false end
	T_MOB = GetConfig("T_MOB1")
	if not T_MOB then
	T_MOB = true
	SetConfig("T_MOB1", T_MOB)
	end
	if T_MOB == 0 then T_MOB = false end
	T_PVP = GetConfig("T_PVP1")
	if not T_PVP then
	T_PVP = true
	SetConfig("T_PVP1", T_PVP)
	end
	if T_PVP == 0 then T_PVP = false end
	T_FMOB = GetConfig("T_FMOB1")
	if not T_FMOB then
	T_FMOB = false
	SetConfig("T_FMOB1", T_FMOB)
	end
	if T_FMOB == 0 then T_FMOB = false end
	T_FPVP = GetConfig("T_FPVP1")
	if not T_FPVP then
	T_FPVP = false
	SetConfig("T_FPVP1", T_FPVP)
	end
	if T_FPVP == 0 then T_FPVP = false end
	
	T_GS = GetConfig("T_GS1")
	if not T_GS then
	T_GS = false
	SetConfig("T_GS1", T_GS)
	end
	if T_GS == 0 then T_GS = false end
	
	T_DIST = GetConfig("T_DIST1")
	if not T_DIST then
	T_DIST = true
	SetConfig("T_DIST1", T_DIST)
	end
	if T_DIST == 0 then T_DIST = false end
end
function Init()
	if not unit.IsFriend then unit.IsFriend = object.IsFriend end -- aus ShowEnemyLevel
wtTarget:Show(false)
wtCont:Show(false)


	Pfeil:Rotate(0) --Reset Pfeil Widget
	
	
	SetGameLocalization()
	
	common.RegisterEventHandler( PostInit, "EVENT_AVATAR_CREATED" ) -- Start :)
	--target mark:
	common.RegisterEventHandler( PrimaryTargetChanged, "EVENT_AVATAR_TARGET_CHANGED" )
	common.RegisterEventHandler( UnitTagChanged, "EVENT_UNIT_TAG_CHANGED" )
	
	common.RegisterEventHandler( BuffEChanged, "EVENT_UNIT_BUFFS_ELEMENT_CHANGED" )
	common.RegisterEventHandler( BuffEChanged, "EVENT_OBJECT_BUFFS_ELEMENT_CHANGED" )
	common.RegisterEventHandler( DeadChanged, "EVENT_UNIT_DESPAWNED" )
	common.RegisterEventHandler( DeadChanged, "EVENT_UNIT_DEAD_CHANGED" )
	common.RegisterEventHandler( Buffs, "EVENT_OBJECT_BUFF_ADDED" )
	common.RegisterEventHandler( BuffsChange, "EVENT_OBJECT_BUFFS_CHANGED" )
	common.RegisterEventHandler( SecondTimer, "EVENT_SECOND_TIMER" )
	common.RegisterEventHandler( ZoneChanged, "EVENT_AVATAR_ZONE_CHANGED" )
	common.RegisterEventHandler( UnitSpawned, "EVENT_UNIT_SPAWNED" )
		--- AOPANEL:
	common.RegisterEventHandler(AOPanelStart,"AOPANEL_START")
	common.RegisterEventHandler( AOPanelSend, "AOPANEL_BUTTON_LEFT_CLICK" )
	    --- REST
	common.RegisterEventHandler( UnknownSlashCommand, "EVENT_UNKNOWN_SLASH_COMMAND" )

	common.RegisterEventHandler( EventEffectFinished, "EVENT_EFFECT_FINISHED" )
	--PosChanged
	common.RegisterEventHandler( PosChanged, "EVENT_UNIT_POS_CHANGED" )
	common.RegisterEventHandler( PosChanged, "EVENT_AVATAR_DIR_CHANGED" )
	common.RegisterEventHandler( PosChanged, "EVENT_AVATAR_POS_CHANGED" )
	common.RegisterEventHandler( PosChanged, "EVENT_CAMERA_DIRECTION_CHANGED")
	------------GS IMPLEMENTATION
	if GS.Init then GS.Init() end
	GS.EnableTargetInspection( true )
	common.RegisterEventHandler( ShowGearScore, "LIBGS_GEARSCORE_AVAILABLE" )
	GS.Callback = ShowGearScore
	-----------------------------
	
------------------------------------------------------------------------------
--------------------------SETTINGS SECTION------------------------------------
------------------------------------------------------------------------------

	OptionPanel:Show(false)
	OCBtn:Show(true)
	EditControl:Show( true )
	TitleText:SetVal( "Title", userMods.ToWString( "BuffUI Settings" ) )
	local f = '<header color="0xFFFFFFFF" alignx="left" aligny="bottom" fontsize="20" outline="1"><rs class="class"><r name="Modes" /></rs></header>'
	Mode:SetFormat(userMods.ToWString(f))
	Mode:SetVal( "Modes", userMods.ToWString( "Buff Modes" ) )
	Mode2:SetFormat(userMods.ToWString(f))
	Mode2:SetVal( "Modes", userMods.ToWString( "Target Marker" ) )
	Mode3:SetFormat(userMods.ToWString(f))
	Mode3:SetVal( "Modes", userMods.ToWString("Other Settings" ) )	
	Mode4:SetFormat(userMods.ToWString(f))
	Mode4:SetVal( "Modes", userMods.ToWString( "Add/Disable Buffs"  ) )	
	
	DnD:Init(BuffPanel, BuffPanel, true, false, {-1,-1,-1,-1}, nil )
	DnD:Init(OptionPanel,OptionPanel, true, false, {-1,-1,-1,-1}, nil )
	DnD:Init(OCBtn,OCBtn, true, true, {-1,-1,-1,-1}, KBF_SHIFT )
	DnD:Init(PfeilPanel,PfeilPanel, true, true, {-1,-1,-1,-1}, KBF_SHIFT )
	
	
	common.RegisterReactionHandler( CheckBoxClicked, "click_checkbox" )
	common.RegisterReactionHandler( CloseBtn, "CloseBtn" )
	common.RegisterReactionHandler( EditBtnClick, "clicklistbtn" )
	common.RegisterReactionHandler( BuffPanelButton ,"bpbutton" )
	
	
	
	UserListPVP = GetConfig( "UserListPVP" )
	if UserListPVP then
		for k, v in pairs( UserListPVP ) do
			BuffListPVP[k] = v			
		end
	else
		UserListPVP = {}
		UserListPVP["testvalue11"] = false
		SetConfig( "UserListPVP", UserListPVP )
	end
	
		UserListPVE = GetConfig( "UserListPVE" )
	if UserListPVE then
		for k, v in pairs( UserListPVE ) do
			BuffListPVE[k] = v			
		end
	else
		UserListPVE = {}
		UserListPVE["testvalue11"] = false
		SetConfig( "UserListPVE", UserListPVE )
	end
	
	UserListMOB = GetConfig( "UserListMOB" )
		if UserListMOB then
		for k, v in pairs( UserListMOB ) do
			BuffListMOB[k] = v			
		end
	else
		UserListMOB = {}
		UserListMOB["testvalue11"] = false
		SetConfig( "UserListMOB", UserListMOB )
	end
	
	
	SetupConfig()
	SetupCheckboxes()
	SetupEPanels()
	SetVariants()
	----------------------------------------------------------------------------
	
	if avatar.IsExist() then
		PostInit()
	end
	
end



Init()
