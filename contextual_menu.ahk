#SingleInstance force
Menu, Tray, Icon, %A_ScriptDir%\grey.ico
;-------contextual menu button + right shift closes current tab---------------------
;------you can tap the same contextual button again to close the menu---------------

; Initialize a variable to track the state of the AppsKey press
global appsKeyPressed := false

; Define the hotkey for AppsKey to open the menu or close it if already pressed
AppsKey::
if (appsKeyPressed) {
    ; If AppsKey was already pressed, send Escape to close the menu
    ;Send, {Esc}
    appsKeyPressed := false ; Reset the state
} else {
    ; If AppsKey was not pressed before, send AppsKey to open the menu
    Send, {AppsKey}
    appsKeyPressed := true ; Set the state to true
}
return

; Define the hotkey for AppsKey + Right Shift to close Chrome tabs
AppsKey & RShift::
Send, ^w
return