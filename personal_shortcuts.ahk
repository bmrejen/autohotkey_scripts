#SingleInstance force
Menu, Tray, Icon, %A_ScriptDir%\grey.ico

PrintScreen::Send +{F10}						;PrintScreen button becomes right click
^PrintScreen::Send {F12}						;PrintScreen and Ctrl becomes F12 (definition in VSCode)

#IfWinActive ahk_class CabinetWClass
>^Enter::Send +{F10}{i 100 200}						; Right Ctrl + Enter opens VS Code in current directory
^>!Enter::Send +{F10}{s 100 200}{Enter}					; AltGr + Enter opens Git Bash in current directory
#IfWinActive
^>!RShift UP::Send +{F10}					;Alt Gr + Right Shift = righ-click (for external keyboard) 
							; add Shift to reload it
#e::Run explorer.exe D:\Dropbox
#n::Run notepad++.exe
#g::Run "C:\Program Files\Google\Chrome\Application\chrome.exe" --disable-features=HardwareMediaKeyHandling
^!::Run "C:\Program Files\Everything\Everything.exe"
;<^>!{Del}::Send {Delete}						; AltGr + Suppr sends Suppr (VSCode deletes files faster this way)

del::Send {AltGr}{Del}

<^>!Space::Send {Space}							; AltGr + Space behaves like Space
^+J::Run explorer.exe C:\Users\Ben\Downloads				; Ctrl + Shift + J opens Downloads folder
<^>!8::MsgBox You pressed AltGr+m.
+*::Send {ASC 124}							; Shift + * sends the pipe |
+$::Send {ASC 96}							; Shift + $ sends the backtick `


>^~RShift UP::								; Right Ctrl + Right Shift closes tab
If (A_PriorKey="RShift")
    Send, ^w
return		

>+Enter::AltTab								; Shift+Enter becomes Alt-Tab
;SC029::Send {f2}							; exponent-2 key becomes F2
SC029::>								; exponent-2 key becomes >
+SC029::<								; exponent-2 key becomes <
Insert::Send !{f4}							; Insert becomes Alt-F4
:*:ppp::Put each individual sentence of this text on its own line. For each line you should have three columns: the sentence in Hebrew | Hebrew pronunciation with latin letters | English meaning. For example: שלום | shalom | Hello. The headers of the table must be: Hebrew | Pronunciation | Meaning
:*:anii::אני  
:*:aal::אל 


; *** Caps Lock becomes Alt-F4 ***
Capslock:: Send !{f4}							
+Capslock::Capslock

; *** Caps Lock in Discord will minimize it to tray instead of killing it ***
#SingleInstance, Force

#IfWinActive ahk_exe Discord.exe
    Capslock::WinClose
#IfWinActive	

; *** Ctrl + Up becomes Home ***
^Up::Send {Home}							
^+Up::Send +{Home}

; *** Ctrl + Down becomes End ***
^Down::Send {End}							
^+Down::Send +{End}