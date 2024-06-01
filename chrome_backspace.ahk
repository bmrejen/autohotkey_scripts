#SingleInstance force
Menu, Tray, Icon, %A_ScriptDir%\grey.ico

;------------------------------------------------------------------------------
; Backspace becomes Back in Google Chrome
;------------------------------------------------------------------------------
backspace_up_instead_of_back() {
  ControlGetFocus focused, A
  if (focused = "DirectUIHWND2")
  or (focused = "DirectUIHWND3")
  or (focused = "SysTreeView321")
      SendInput, !{Up}
  else
      SendInput, {Backspace}
}

#IfWinActive, ahk_class CabinetWClass
$Backspace::
  backspace_up_instead_of_back()
  return
#IfWinActive