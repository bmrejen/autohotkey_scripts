#SingleInstance force
Menu, Tray, Icon, %A_ScriptDir%\grey.ico

;------------------------------------------------------------------------------
; Add and remove US layout by hitting Fn+F4
; This solves a common bug, when Windows adds the US layout out of nowhere
;------------------------------------------------------------------------------
F4::
Run, ms-settings:keyboard
Sleep 2000
Send {Tab}{Tab}{Enter}
Sleep 500
Send {Tab}{Tab}{Enter}
Sleep 500
Send {Tab}{Tab}{Tab}{Enter}
Sleep 500
Send {Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Down}{Enter}
Sleep 1000
Send {Tab}{Down}{Enter}
Sleep 1000
Send {Tab}{Enter}
Send !{f4}
Return