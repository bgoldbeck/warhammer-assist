#include <SendMessage.au3>
#include <guiconstants.au3>
#include "AutoIT_ImageSearch/_ImageSearch.au3"
#include "AutoIT_ImageSearch/_ImageSearch_Debug.au3"
#include "GUIFactory.au3"
#include "AutoSynergyTab.au3"
#include "ConfigTab.au3"

#RequireAdmin

Opt("GUIOnEventMode", 1) ; Change to OnEvent mode
Global $windowTitle = "Warhammer: Age of Reckoning, Version 1	.4.8, Copyright 2001-2012 Electronic Arts, Inc."
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

Global $inCombatIndicatorPath = @ScriptDir & "\Images\in_combat_indicator.bmp"


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
	  Sleep(25)
   Else
	  ; Warhammer Window not active.
	  Sleep(250)
	  ;Return
   EndIf

   Local $enemyFrameFound = _ImageSearch($inCombatIndicatorPath, $searchTolerance)
   If $enemyFrameFound[0] == 1 and not $inCombat Then
	  ; Start combat.
	  OnCombat()
   ElseIf $enemyFrameFound[0] == 1 Then
	  ; Still in combat.
	  Combat()
   ElseIf $enemyFrameFound[0] == 0 and $inCombat or TimerDiff($timer) > $timeout Then
	  ; Target died.
	  OnTargetDied()
	  Loot()
	  $timer = TimerInit()
   Else
	  ; No target.
	  GUICtrlSetData($status, "Status:  Searching For Target")
	  Send("{TAB}")
	  Sleep(1000)
   EndIf


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

Func OnTargetDied()
   GUICtrlSetData($status, "Status: Target Removed.")
   $inCombat = false
EndFunc

Func Loot()
   GUICtrlSetData($status, "Status: Looting.")
   Send($lootKey) ; Send Loot Button
   Sleep(1000)
EndFunc

Func OnCombat()
   GUICtrlSetData($status, "Status: Combat Target Found.")
   Sleep(500)
   Pull()
   $inCombat = true
EndFunc

Func Pull()
   GUICtrlSetData($status, "Status: Pulling.")
   Send($pullKey) ; Send Pull Button
   Sleep(1500)
   Send($healKey) ; Send Heal Button
   Sleep(1000)
EndFunc

Func SetWindowRgn($h_win, $rgn)
    DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $rgn, "int", 1)
EndFunc

;Func CombineRgn(ByRef $rgn1, ByRef $rgn2)
;    DllCall("gdi32.dll", "long", "CombineRgn", "long", $rgn1, "long", $rgn1, "long", $rgn2, "int", 2)
;EndFunc

Func CreateTextRgn(ByRef $CTR_hwnd,$CTR_Text,$CTR_height,$CTR_font="Microsoft Sans Serif",$CTR_weight=1000)
    Local Const $ANSI_CHARSET = 0
    Local Const $OUT_CHARACTER_PRECIS = 2
    Local Const $CLIP_DEFAULT_PRECIS = 0
    Local Const $PROOF_QUALITY = 2
    Local Const $FIXED_PITCH = 1
    Local Const $RGN_XOR = 3
        If $CTR_font = "" Then $CTR_font = "Microsoft Sans Serif"
    If $CTR_weight = -1 Then $CTR_weight = 1000
    Local $gdi_dll = DLLOpen("gdi32.dll")
    Local $CTR_hDC= DLLCall("user32.dll","int","GetDC","hwnd",$CTR_hwnd)
    Local $CTR_hMyFont = DLLCall($gdi_dll,"hwnd","CreateFont","int",$CTR_height,"int",0,"int",0,"int",0, _
                "int",$CTR_weight,"int",0,"int",0,"int",0,"int",$ANSI_CHARSET,"int",$OUT_CHARACTER_PRECIS, _
                "int",$CLIP_DEFAULT_PRECIS,"int",$PROOF_QUALITY,"int",$FIXED_PITCH,"str",$CTR_font )
    Local $CTR_hOldFont = DLLCall($gdi_dll,"hwnd","SelectObject","int",$CTR_hDC[0],"hwnd",$CTR_hMyFont[0])
    DLLCall($gdi_dll,"int","BeginPath","int",$CTR_hDC[0])
    DLLCall($gdi_dll,"int","TextOut","int",$CTR_hDC[0],"int",0,"int",0,"str",$CTR_Text,"int",StringLen($CTR_Text))
    DLLCall($gdi_dll,"int","EndPath","int",$CTR_hDC[0])
    Local $CTR_hRgn1 = DLLCall($gdi_dll,"hwnd","PathToRegion","int",$CTR_hDC[0])
    Local $CTR_rc = DLLStructCreate("int;int;int;int")
    DLLCall($gdi_dll,"int","GetRgnBox","hwnd",$CTR_hRgn1[0],"ptr",DllStructGetPtr($CTR_rc))
    Local $CTR_hRgn2 = DLLCall($gdi_dll,"hwnd","CreateRectRgnIndirect","ptr",DllStructGetPtr($CTR_rc))
    DLLCall($gdi_dll,"int","CombineRgn","hwnd",$CTR_hRgn2[0],"hwnd",$CTR_hRgn2[0],"hwnd",$CTR_hRgn1[0],"int",$RGN_XOR)
    DLLCall($gdi_dll,"int","DeleteObject","hwnd",$CTR_hRgn1[0])
    DLLCall("user32.dll","int","ReleaseDC","hwnd",$CTR_hwnd,"int",$CTR_hDC[0])
    DLLCall($gdi_dll,"int","SelectObject","int",$CTR_hDC[0],"hwnd",$CTR_hOldFont[0])
    DLLClose($gdi_dll)
    Return $CTR_hRgn2[0]
EndFunc














