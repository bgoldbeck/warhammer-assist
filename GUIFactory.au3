


Func _GUIFCreateButton($title, $x, $y, $width, $height, $font = "Tahoma", $fontSize = 12, $fontWeight = 400)

   $btn = GUICtrlCreateButton($title, $x, $y, $width, $height)
   GUICtrlSetState($btn, $GUI_DEFBUTTON)
   GUICtrlSetFont($btn, $fontSize, $fontWeight, $GUI_FONTNORMAL, $font)
   Return $btn
EndFunc