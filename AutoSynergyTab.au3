#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>

Global $synergyImages = ObjCreate("Scripting.Dictionary")
$synergyImages.Add("Conduit", @ScriptDir & "\Images\conduit_synergy.bmp")
$synergyImages.Add("Graverobber", @ScriptDir & "\Images\graverobber_synergy.bmp")
$synergyImages.Add("Energy Orb", @ScriptDir & "\Images\energyorb_synergy.bmp")
$synergyImages.Add("Blessed Shards", @ScriptDir & "\Images\blessedshards_synergy.bmp")
$synergyImages.Add("Holy Shards", @ScriptDir & "\Images\holyshards_synergy.bmp")
$synergyImages.Add("Purify", @ScriptDir & "\Images\purify_synergy.bmp")
$synergyImages.Add("Radiate", @ScriptDir & "\Images\radiate_synergy.bmp")
$synergyImages.Add("Black Widows", @ScriptDir & "\Images\blackwidows_synergy.bmp")
$synergyImages.Add("Charged Lightning", @ScriptDir & "\Images\chargedlightning_synergy.bmp")
$synergyImages.Add("Combustion", @ScriptDir & "\Images\combustino_synergy.bmp")
$synergyImages.Add("Spinal Surge", @ScriptDir & "\Images\spinalsurge_synergy.bmp")


Global $synergyCheckboxes[$synergyImages.Count]

; [0] = Conduit
;ReDim $synergyImages[UBound($synergyImages) + 1]
;$synergyImages[UBound($synergyImages) - 1] = @ScriptDir & "\Images\conduit_synergy.bmp"
; [1] = Graverobber
;ReDim $synergyImages[UBound($synergyImages) + 1]
;$synergyImages[UBound($synergyImages) - 1] = @ScriptDir & "\Images\graverobber_synergy.bmp"

Global $autoSynergyTab
Global $autoSynergyComboSelect
Global $autoSynergyTexture
Global $checkboxWidth = 175
Global $checkBoxHeight = 25
Global $vSpacing = 0

;  ; Add items into an array
;    $aItems = $oDictionary.Items

;    ; Display items in the array
;    For $i = 0 To $oDictionary.Count -1
;        MsgBox(0x0, 'Items [ ' & $i & ' ]', $aItems[$i], 2)
;    Next

Global Const $sUserSettingsPath = @ScriptDir & "/user_settings.ini"

Func _IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
 EndFunc   ;==>_IsChecked

Func _CreateAutoSynergyTab()

   $autoSynergyTab = GUICtrlCreateTabItem("Auto Synergy")

   ; Add keys into an array
   Dim $aKeys = $synergyImages.Keys
   ;Dim $comboSelectionSynergies

   $checkboxYPos = 0
   $checkboxXPos = 5
   For $i = 0 To $synergyImages.Count -1
	  $checkboxYPos = $checkboxYPos + $vSpacing + $checkboxHeight
	  $synergyCheckboxes[$i] = GUICtrlCreateCheckbox ($aKeys[$i], $checkboxXPos, $checkboxYPos, $checkboxWidth, $checkBoxHeight)
   Next
   _OnSynergiesDeserialize()
   ;For $i = 0 To $synergyImages.Count -1
	  ;If $i <> $synergyImages.Count Then
		 ;$comboSelectionSynergies = $comboSelectionSynergies & $aKeys[$i] & "|"
	  ;Else
		 ;$comboSelectionSynergies = $comboSelectionSynergies & $aKeys[$i]
	  ;EndIf
   ;Next

   ;$autoSynergyComboSelect = GUICtrlCreateCombo("", 5, 50, 125, 30)
   ;GUICtrlSetOnEvent($autoSynergyComboSelect, "_UpdateSynergyTexture")
   ;GUICtrlSetData($autoSynergyComboSelect, $comboSelectionSynergies, "Conduit")
   ;$autoSynergyTexture = GUICtrlCreatePic($synergyImages.Item("Conduit"), 135, 50, 64, 64)

   Return $autoSynergyTab
EndFunc

Func _OnSynergiesSerialize()
   ; Write the data to the disk.
   ConsoleWrite("_OnSynergiesSerialize" & @CRLF)
   Dim $aKeys = $synergyImages.Keys
   For $i = 0 To $synergyImages.Count -1
	  If _IsChecked($synergyCheckboxes[$i]) Then
		 ConsoleWrite("Value Written True " & $aKeys[$i] & @CRLF)
		 IniWrite($sUserSettingsPath, "Synergies", $aKeys[$i], "True")
	  Else
		 ConsoleWrite("Value Written False " & $aKeys[$i] & @CRLF)
		 IniWrite($sUserSettingsPath, "Synergies", $aKeys[$i], "False")
	  EndIf
   Next
EndFunc

Func _OnSynergiesDeserialize()
   ; Read the data from the disk.
   ConsoleWrite("_OnSynergiesDeserialize" & @CRLF)
   Dim $aKeys = $synergyImages.Keys
   For $i = 0 To $synergyImages.Count -1
	  Local $valueRead = IniRead($sUserSettingsPath, "Synergies", $aKeys[$i], "Unknown")
	  ;ConsoleWrite("Value Read " & $valueRead& @CRLF)
	  Select
		 Case $valueRead == "Unknown"
			; Must not have a user settings file. Write out the default value.
			IniWrite($sUserSettingsPath, "Synergies", $aKeys[$i], "False")
			GUICtrlSetState($synergyCheckboxes[$i], $GUI_UNCHECKED)
		 Case $valueRead == "False"
			GUICtrlSetState($synergyCheckboxes[$i], $GUI_UNCHECKED)
		 Case $valueRead == "True"
			GUICtrlSetState($synergyCheckboxes[$i], $GUI_CHECKED)
	  EndSelect
   Next
EndFunc

Func _UpdateSynergyTexture()
   $selected = GUICtrlRead($autoSynergyComboSelect)
   GUICtrlSetImage($autoSynergyTexture, $synergyImages.Item($selected))
EndFunc