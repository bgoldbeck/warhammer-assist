#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
Global $guiWidth = 400
Global $guiHeight = 500

Global $controlWidth = ($guiWidth / 2) - 10
Global $controlHeight = 25
Global $vSpacing = 0
Global $usePotionsCheckbox


Global $usePotionCombo
Global $useSynergyCombo
Global $toleranceSlider
Global $toleranceLabel
Global $autoAFKCheckbox
Global $afkKeyCombo

Global $usePotionKey = "f"
Global $useSynergyKey = "q"
Global $afkKey = "w"
Global $imageSearchTolerance

Global $potionPath[4]

$potionPath[0] = @ScriptDir & "\Images\weaponpower_potion.bmp"
$potionPath[1] = @ScriptDir & "\Images\spellpower_potion.bmp"
$potionPath[2] = @ScriptDir & "\Images\green_potion.bmp"
$potionPath[3] = @ScriptDir & "\Images\immovability_potion.bmp"

Global $keyboardKeyData = "a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|{TAB}|{F1}|{F2}|{F3}|{F4}|{F5}|{F6}|{F7}|{F8}|{F9}|{F10}|{F11}|{F12}|{DEL}|{INS}|{HOME}|{END}|{PGUP}|{PGDN}|{CAPSLOCK}|{NUMPAD0}|{NUMPAD1}|{NUMPAD2}|{NUMPAD3}|{NUMPAD4}|{NUMPAD5}|{NUMPAD6}|{NUMPAD7}|{NUMPAD9}"

Func _CreateConfigTab()
   $configTab = GUICtrlCreateTabItem("Config")

   ; Weapon Power Potions
   $controlXPos = 5
   $controlYPos = 15
   $controlYPos = $controlYPos + $vSpacing + $controlHeight
   GUICtrlCreateLabel("Use Potions in Combat?", $controlXPos, $controlYPos, $controlWidth, $controlHeight)
   $usePotionsCheckbox = GUICtrlCreateCheckbox ("", $controlXPos + ($guiWidth / 2), $controlYPos, $controlWidth, $controlHeight)
   GUICtrlSetOnEvent($usePotionsCheckbox, "_UpdateConfigControls")

   ; Using Potion Key
   $controlYPos = $controlYPos + $vSpacing + $controlHeight
   GUICtrlCreateLabel("Use Potion Key", $controlXPos, $controlYPos, $controlWidth, $controlHeight)
   $usePotionCombo = GUICtrlCreateCombo("q", $controlXPos + ($guiWidth / 2), $controlYPos, $controlWidth, $controlHeight)
   GUICtrlSetOnEvent($usePotionCombo, "_UpdateConfigControls")


   ; Using Synergy Key
   $controlYPos = $controlYPos + $vSpacing + $controlHeight
   GUICtrlCreateLabel("Use Synergy Key", $controlXPos, $controlYPos, $controlWidth, $controlHeight)
   $useSynergyCombo = GUICtrlCreateCombo("x", $controlXPos + ($guiWidth / 2), $controlYPos, $controlWidth, $controlHeight)
   GUICtrlSetOnEvent($useSynergyCombo, "_UpdateConfigControls")


   ; Tolerance Slider
   $controlYPos = $controlYPos + $vSpacing + $controlHeight
   $toleranceLabel = GUICtrlCreateLabel("Tolerance (High --> Low)", $controlXPos, $controlYPos, $controlWidth, $controlHeight)
   $toleranceSlider = GUICtrlCreateSlider ($controlXPos + ($guiWidth / 2), $controlYPos)
   GUICtrlSetLimit($toleranceSlider, 255, 0) ; change min/max value
   GUICtrlSetOnEvent($toleranceSlider, "_UpdateConfigControls")

   ; Auto AFK
   $controlYPos = $controlYPos + $vSpacing + $controlHeight
   GUICtrlCreateLabel("Enable AFK Mode?", $controlXPos, $controlYPos, $controlWidth, $controlHeight)
   $autoAFKCheckbox = GUICtrlCreateCheckbox ("", $controlXPos + ($guiWidth / 2), $controlYPos, $controlWidth, $controlHeight)
   GUICtrlSetOnEvent($autoAFKCheckbox, "_UpdateConfigControls")

   ; AFK Key
   $controlYPos = $controlYPos + $vSpacing + $controlHeight
   GUICtrlCreateLabel("AFK Use Key", $controlXPos, $controlYPos, $controlWidth, $controlHeight)
   $afkKeyCombo = GUICtrlCreateCombo("w", $controlXPos + ($guiWidth / 2), $controlYPos, $controlWidth, $controlHeight)
   GUICtrlSetOnEvent($afkKeyCombo, "_UpdateConfigControls")

   _OnConfigDeserialize()

   return $configTab
EndFunc

Func _OnConfigSerialize()
   ; Write the data to the disk.
   IniWrite($sUserSettingsPath, "Config", "UsePotionKey", GUICtrlRead($usePotionCombo))
   IniWrite($sUserSettingsPath, "Config", "UseSynergyKey", GUICtrlRead($useSynergyCombo))
   IniWrite($sUserSettingsPath, "Config", "Tolerance", GUICtrlRead($toleranceSlider))
   IniWrite($sUserSettingsPath, "Config", "AFKKey", GUICtrlRead($afkKeyCombo))

   If _IsChecked($autoAFKCheckbox) Then
	  IniWrite($sUserSettingsPath, "Config", "AutoAFK", "True")
   Else
	  IniWrite($sUserSettingsPath, "Config", "AutoAFK", "False")
   EndIf

   If _IsChecked($usePotionsCheckbox) Then
	  IniWrite($sUserSettingsPath, "Config", "UsePotions", "True")
   Else
	  IniWrite($sUserSettingsPath, "Config", "UsePotions", "False")
   EndIf
EndFunc

Func _OnConfigDeserialize()
   ; Read the data from the disk.
   $usePotionKey = IniRead($sUserSettingsPath, "Config", "UsePotionKey", "q")
   $useSynergyKey = IniRead($sUserSettingsPath, "Config", "UseSynergyKey", "x")
   $imageSearchTolerance = IniRead($sUserSettingsPath, "Config", "Tolerance", "110")
   $afkKey = IniRead($sUserSettingsPath, "Config", "AFKKey", "w")

   GUICtrlSetData($usePotionCombo, $keyboardKeyData, $usePotionKey)
   GUICtrlSetData($useSynergyCombo, $keyboardKeyData, $useSynergyKey)
   GUICtrlSetData($toleranceSlider, $imageSearchTolerance)
   GUICtrlSetData($toleranceLabel, "Tolerance (High --> Low) " & $imageSearchTolerance)
   GUICtrlSetData($afkKeyCombo, $keyboardKeyData, $afkKey)

   If IniRead($sUserSettingsPath, "Config", "AutoAFK", "False") == "False" Then
	  GUICtrlSetState($autoAFKCheckbox, $GUI_UNCHECKED)
   Else
	  GUICtrlSetState($autoAFKCheckbox, $GUI_CHECKED)
   EndIf


   For $j = 0 To UBound($PotionPath) - 1

	  Local $valueRead = IniRead($sUserSettingsPath, "Config", "UsePotions", "Unknown")
	  Select
		 Case $valueRead == "Unknown"
			; Must not have a user settings file. Write out the default value.
			IniWrite($sUserSettingsPath, "Config", "UsePotions", "False")
			GUICtrlSetState($usePotionsCheckbox, $GUI_UNCHECKED)
		 Case $valueRead == "False"
			GUICtrlSetState($usePotionsCheckbox, $GUI_UNCHECKED)
		 Case $valueRead == "True"
			GUICtrlSetState($usePotionsCheckbox, $GUI_CHECKED)
	  EndSelect
   Next
EndFunc

Func _UpdateConfigControls()
   _OnConfigSerialize()
   _OnConfigDeserialize()
EndFunc