;------------------------------------------------------------------------------
; Settings
;------------------------------------------------------------------------------
#NoEnv  			; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  		; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  	; Ensures a consistent starting directory.
#SingleInstance force

;------------------------------------------------------------------------------
; My scripts
;------------------------------------------------------------------------------
Run, %A_ScriptDir%\chrome_backspace.ahk
Run, %A_ScriptDir%\contextual_menu.ahk
Run, %A_ScriptDir%\generate_password.ahk
Run, %A_ScriptDir%\google_selected.ahk
Run, %A_ScriptDir%\mouse.ahk
Run, %A_ScriptDir%\personal_shortcuts.ahk
Run, %A_ScriptDir%\remove_US_layout.ahk
Run, %A_ScriptDir%\spelling_autocorrect.ahk

;------------------------------------------------------------------------------
;  Ctrl+Shift+X erases the extension search in VSCode
;------------------------------------------------------------------------------
$^+x::
Send ^+x
Sleep 100
Send +{Home}
Send {Backspace}
Return

;------------------------------------------------------------------------------
;  Personal shortcuts
;------------------------------------------------------------------------------
:*:ssite::https://www.benoitmrejen.com
:*:bmm::benoit.mrejen@gmail.com
:*:lii::https://www.linkedin.com/in/bmrejen
::cal::https://calendly.com/benoit-mrejen
:*:cdl::Cordialement
:*:àa::ça
::rsync::rsync -avhW --no-compress --progress
::cosnt::const
::gac::git add --all && git commit -m "
::NLUL::NULL
:*:2B0::0x71810Eeea9A286b994bbaFFb34FC540A0dD1e2B0
:*:;)::😉
:*:^^::😝
::satsh::stash
::geth attach_::geth attach ipc:\\.\pipe\geth.ipc 
::geth attach::geth attach ipc:/dev/shm/geth.ipc
::gac::git add --all && git commit -m "
::git prune::git remote update --prune && git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -d
::bhh::C:\Program Files\Git\git-bash.exe
<^>!é::Send {ASC 126}							; AltGr + é sends ~
^!a::Run, Edit "D:\Dropbox\AHK\AutoHotkey_shortcuts.ahk"			; Ctrl+Alt+A opens this file
^+!a::Reload	

;------------------------------------------------------------------------------
; Ctrl + Shift + V pastes without formatting
;------------------------------------------------------------------------------
^+v::
Clipboard := Clipboard
Send ^v
Return

