#include <SendMessage.au3>
#include <guiconstants.au3>
#include "AutoIT_ImageSearch/_ImageSearch.au3"
#include "AutoIT_ImageSearch/_ImageSearch_Debug.au3"
#include "GUIFactory.au3"
#include "AutoSynergyTab.au3"
#include "ConfigTab.au3"

#RequireAdmin

Opt("GUIOnEventMode", 1) ; Change to OnEvent mode
Global $windowTitle = "Warhammer: Age of Reckoning, Version 1.4.8, Copyright 2001-2012 Electronic Arts, Inc."
Global $timer = TimerInit()
Global $logTextColor = 0xFF8000
Global $timeout = 15000

Global $isStarted = false
Global $appName = "Warhammer Assist"

If _Singleton($appName, 1) = 0 Then
    Exit
   EndIf

Global $stdBtnHeight = 30
Global $stdBtnWidth = 100
Global $searchTolerance = 45
Global $nerfKey = 1
Global $lootKey = "{F5}"
Global $pullKey = "e"
Global $healKey = "q"
Global $guiHeight = 100
Global $guiWidth = 400

Global $harvestReadyPath = @ScriptDir & "\Images\harvest_ready.bmp"
Global $startHarvestPath = @ScriptDir & "\Images\start_harvest.bmp"

Global $inCombat = false
Global $logHwnd = GUICreate("Log Text Region",400,50,(@DesktopWidth / 2) - 200, 100,$WS_POPUP,BitOR($WS_EX_TOPMOST,$WS_EX_TOOLWINDOW))

GUISetBkColor($logTextColor)

Global $hGUI = GUICreate($appName, $guiWidth, $guiHeight,-1,-1)
Global $guiTab = GUICtrlCreateTab(0, 0, $guiWidth, $guiHeight)
Global $mainTab = GUICtrlCreateTabItem("Main")


;Buttons
Global $iClose = _GUIFCreateButton("Close", ($guiWidth / 2) - ($stdBtnWidth / 2), $guiHeight - $stdBtnHeight, $stdBtnWidth, $stdBtnHeight)
GUICtrlSetOnEvent($iClose, "ClosePressed")
GUISetOnEvent($GUI_EVENT_CLOSE, "ClosePressed")

Global $status = _GUIFCreateButton("Status", 0, 25, ($stdBtnWidth * 4) - 5, $stdBtnHeight)

Global $autoSynergyTab =_CreateAutoSynergyTab()
Global $configTab = _CreateConfigTab()

GUISetState(@SW_SHOW, $logHwnd)
;Sleep(750)
GUISetState(@SW_HIDE, $logHwnd)

Main()

Func Update()

   If WinActive($windowTitle, "") Then
	  ; Warhammer Window active.
		;GUICtrlSetData($status, "Status:  Active")
	  Sleep(250)
   Else
	  ; Warhammer Window not active.
	  GUICtrlSetData($status, "Status:  Waiting For Window")
	  Sleep(250)
	  Return
   EndIf

   Local $harvestReadyFound = _ImageSearch($harvestReadyPath, $searchTolerance)


   If $harvestReadyFound[0] == 1 Then
	  ; Click Harvest.
	  ClickHarvest($harvestReadyFound[1], $harvestReadyFound[2])
	  Sleep(3000)
   Else
	  Local $startHarvestFound = _ImageSearch($startHarvestPath, $searchTolerance)
	  ; No target.
	  If $startHarvestFound[0] == 1 Then
		 StartHarvest($startHarvestFound[1], $startHarvestFound[2])
		 Sleep(250)
	  Else
		 GUICtrlSetData($status, "Status:  Waiting For Harvest")
		 Sleep(250)
	  EndIf
   EndIf


EndFunc

Func StartHarvest($x, $y)
   MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1, 0)
EndFunc

Func ClickHarvest($x, $y)
   MouseClick($MOUSE_CLICK_LEFT, $x, $y, 1, 0)
EndFunc

Func Main()
   GUISetState(@SW_SHOW, $hGUI)
   While 1
	  Update()
   WEnd

   GUIDelete($hGUI)
EndFunc

Func ClosePressed()
   _OnSynergiesSerialize()
   _OnConfigSerialize()
   GUIDelete($hGUI)
   Exit
EndFunc

Func Combat()
   Send($nerfKey) ; Send Nerf Button
   Sleep(1000)
EndFunc















