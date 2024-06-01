#SingleInstance force
Menu, Tray, Icon, %A_ScriptDir%\grey.ico
;------------------------------------------------------------------------------
; Ctrl+G googles selected word
;------------------------------------------------------------------------------
^g:: ; GoogleSearch or Show Link with CTRL+G
  prevClipboard := ClipboardAll
  SendInput, ^c 
  ClipWait, 1
  if !(ErrorLevel)  { 
    Clipboard := RegExReplace(RegExReplace(Clipboard, "\r?\n"," "), "(^\s+|\s+$)")
    If SubStr(ClipBoard,1,7)="http://"
      Run, % Clipboard
    else 
      Run, % "http://www.google.com/search?hl=en&q=" Clipboard
  } 
  Clipboard := prevClipboard
return

