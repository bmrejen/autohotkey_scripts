;; Using Keyboard NumPad as a Mouse -- by deguix
; http://www.autohotkey.com
; This script makes mousing with your keyboard almost as easy
; as using a real mouse (maybe even easier for some tasks).
; It supports up to five mouse buttons and the turning of the
; mouse wheel.  It also features customizable movement speed,
; acceleration, and "axis inversion".
/*
o------------------------------------------------------------o
|Using Keyboard NumPad as a Mouse                            |
(------------------------------------------------------------)
| By Benoit Mrejen--- / A Script file for AutoHotkey 1.0.48+ |
|     based on deguix----------------------------------------|
|                                                            |
|    This script is an example of use of AutoHotkey. It uses |
| the remapping of NumPad keys of a keyboard to transform it |
| into a mouse. Some features are the acceleration which     |
| enables you to increase the mouse movement when holding    |
| a key for a long time, and the rotation which makes the    |
| NumPad mouse to "turn". I.e. NumPadDown as NumPadUp        |
| and vice-versa. See the list of keys used below:           |
|------------------------------------------------------------|
| Keys                  | Description                        |
|------------------------------------------------------------|
| NumLock (toggle on)| Activates NumPad mouse mode.       |
|-----------------------|------------------------------------|
| NumPad0               | Left mouse button click.           |
| NumPad5               | Middle mouse button click.         |
| NumPadDot             | Right mouse button click.          |
| NumPadDiv/NumPadMult  | X1/X2 mouse button click. (Win 2k+)|
| NumPadSub/NumPadAdd   | Moves up/down the mouse wheel.     |
| NumPadEnter           | Mouse movement speed modifier key. |
|-----------------------|------------------------------------|
| NumLock (toggled off) | Activates mouse movement mode.     |
|-----------------------|------------------------------------|
| NumPadEnd/Down/PgDn/  | Mouse movement.                    |
| /Left/Right/Home/Up/  |                                    |
| /PgUp                 |                                    |
| NumPadEnter           | Mouse movement speed modifier key. |
|-----------------------|------------------------------------|
| NumLock (toggled on)  | Activates mousewheel movement mode |
|-----------------------|------------------------------------|
| NumPad1-9 (except 5)  | Mouse wheel movement.*             |
| NumPadEnter           | Mouse wheel mov. speed mod. key.** |
|------------------------------------------------------------|
| NumPadEnter (pressed) | Activates mouse speed adj. mode.   |
|-----------------------|------------------------------------|
| NumPadHome/NumPadEnd/ | +/- acceleration (pixels/cycles).  |
| NumPad7/NumPad1       |                                    |
| NumPadUp/NumPadDown   | +/- initial speed (pixels).        |
| NumPad8/NumPad2       |                                    |
| NumPadPgUp/NumPadPgDn | +/- maximum speed (pixels).        |
| NumPad9/NumPad3       |                                    |
| NumPadLeft/NumPadRight| +/- clockwise rotation (45° degree)|
| NumPad4/NumPad6       |                                    |
|------------------------------------------------------------|
*/

;START OF CONFIG SECTION

#SingleInstance force
Menu, Tray, Icon, %A_ScriptDir%\grey.ico

#MaxHotkeysPerInterval 500

; Using the keyboard hook to implement the NumPad hotkeys prevents
; them from interfering with the generation of ANSI characters such
; as à.  This is because AutoHotkey generates such characters
; by holding down ALT and sending a series of NumPad keystrokes.
; Hook hotkeys are smart enough to ignore such keystrokes.
#UseHook

MouseSpeed:=15
MouseAccelerationSpeed:=20 ;in pixels/MouseAccelerationCycles
MouseAccelerationCycles:=25 ;interval of timer executions to increase speed by the variable above
MouseAccelerationTimerInterval:=10 ;in milliseconds (this ends up to being approximate depending on computer performance)
MouseMaxSpeed:=150
MouseRotationAngle:=0

;Mouse wheel speed is also set on Control Panel. As that
;will affect the normal mouse behavior, the real speed of
;these three below are times the normal mouse wheel speed.
MouseWheelSpeed:=2
MouseWheelAccelerationSpeed:=1 ;in pixels/MouseAccelerationCycles
MouseWheelAccelerationCycles:=50 ;interval of timer executions to increase speed by the variable above
MouseWheelAccelerationTimerInterval:=35 ;in milliseconds (this ends up to being approximate depending on computer performance)
MouseWheelMaxSpeed:=5
MouseWheelRotationAngle:=0

MouseButtonPressCheckTimerInterval:=10

;0=Pressing a button and releasing = down + up events. 1=First time pressing/releasing = down, second time = up.
MouseButtonClickLockDownState:=0
MouseButtonMovementLockDownState:=0

;END OF CONFIG SECTION

PI:= 4*ATan(1)

;This is needed or key presses would faulty send their natural
;actions. Like NumPadDiv would send sometimes "/" to the
;screen.
#InstallKeybdHook

Temp = 0
Temp2 = 0

MouseRotationAnglePart = %MouseRotationAngle%
;Divide by 45° because MouseMove only supports whole numbers,
;and changing the mouse rotation to a number lesser than 45°
;could make strange movements.
;
;For example: 22.5° when pressing NumPadUp:
;  First it would move upwards until the speed
;  to the side reaches 1.
MouseRotationAnglePart /= 45
MouseWheelRotationAnglePart = %MouseRotationAngle%
MouseWheelRotationAnglePart /= 45

MovementVectorMagnitude:=0
MovementVectorDirection:=0
MovementVectors:=0
MovementVectorDefaultMagnitude:=MouseSpeed

MovementWheelVectorMagnitude:=0
MovementWheelVectorDirection:=0
MovementWheelVectors:=0
MovementWheelVectorDefaultMagnitude:=MouseWheelSpeed

Buttons:=0

SetKeyDelay, -1
SetMouseDelay, -1

Hotkey, *NumPad0, ButtonLeftClick
Hotkey, *NumPadIns, ButtonLeftClickIns
Hotkey, *NumPad5, ButtonMiddleClick
Hotkey, *NumPadClear, ButtonLeftClick
Hotkey, *NumPadDot, ButtonRightClick
Hotkey, *NumPadDel, ButtonRightClickDel
Hotkey, *NumPadDiv, PreviousYoutubeVideo
Hotkey, *NumPadMult, NextYoutubeVideo

Hotkey, *NumPadSub, NumPadSub
Hotkey, *NumPadAdd, NumPadAdd

Hotkey, *NumPadRight, ButtonRight
; Hotkey, *NumPadPgUp, ButtonUpRight
Hotkey, *NumPadUp, ButtonUp
; Hotkey, *NumPadHome, ButtonUpLeft
Hotkey, *NumPadLeft, ButtonLeft
; Hotkey, *NumPadEnd, ButtonDownLeft
Hotkey, *NumPadDown, ButtonDown
; Hotkey, *NumPadPgDn, ButtonDownRight

Hotkey, *NumPad6, ButtonWheelRight
; ; Hotkey, *NumPad9, ButtonWheelUpRight
Hotkey, *NumPad8, ButtonWheelUp
; ; Hotkey, *NumPad7, ButtonWheelUpLeft
Hotkey, *NumPad4, ButtonWheelLeft
; ; Hotkey, *NumPad1, ButtonWheelDownLeft
Hotkey, *NumPad2, ButtonWheelDown
; Hotkey, *NumPad3, ButtonWheelDownRight

Hotkey, NumPadEnter & NumPadUp, ButtonSpeedUp
Hotkey, NumPadEnter & NumPadDown, ButtonSpeedDown
Hotkey, NumPadEnter & NumPadHome, ButtonAccelerationSpeedUp
Hotkey, NumPadEnter & NumPadEnd, ButtonAccelerationSpeedDown
Hotkey, NumPadEnter & NumPadPgUp, ButtonMaxSpeedUp
Hotkey, NumPadEnter & NumPadPgDn, ButtonMaxSpeedDown
Hotkey, NumPadEnter & NumPadLeft, ButtonRotationAngleUp
Hotkey, NumPadEnter & NumPadRight, ButtonRotationAngleDown

Hotkey, NumPadEnter & NumPad8, ButtonWheelSpeedUp
Hotkey, NumPadEnter & NumPad2, ButtonWheelSpeedDown
Hotkey, NumPadEnter & NumPad7, ButtonWheelAccelerationSpeedUp
Hotkey, NumPadEnter & NumPad1, ButtonWheelAccelerationSpeedDown
Hotkey, NumPadEnter & NumPad9, ButtonWheelMaxSpeedUp
Hotkey, NumPadEnter & NumPad3, ButtonWheelMaxSpeedDown
Hotkey, NumPadEnter & NumPad4, ButtonWheelRotationAngleUp
Hotkey, NumPadEnter & NumPad6, ButtonWheelRotationAngleDown

Hotkey, NumPadEnter, ButtonEnter

Gosub, ~NumLock  ; Initialize based on current NumLock state.
return

;Key activation support

~NumLock::
; Wait for it to be released because otherwise the hook state gets reset
; while the key is down, which causes the up-event to get suppressed,
; which in turn prevents toggling of the NumLock state/light:
KeyWait, NumLock
GetKeyState, NumLockState, NumLock, T
if (NumLockState = "U")
{
  Hotkey, *NumPad0, on
  Hotkey, *NumPadIns, on
  Hotkey, *NumPad5, on
  Hotkey, *NumPadDot, on
  Hotkey, *NumPadDel, on
  Hotkey, *NumPadDiv, on
  Hotkey, *NumPadMult, on

  Hotkey, *NumPadSub, on
  Hotkey, *NumPadAdd, on

  Hotkey, *NumPadUp, on
  Hotkey, *NumPadDown, on
  Hotkey, *NumPadLeft, on
  Hotkey, *NumPadRight, on
  ; Hotkey, *NumPadHome, on
  ; Hotkey, *NumPadEnd, on
  ; Hotkey, *NumPadPgUp, on
  ; Hotkey, *NumPadPgDn, on

  Hotkey, *NumPad6, on
  ; Hotkey, *NumPad9, on
  Hotkey, *NumPad8, on
  ; Hotkey, *NumPad7, on
  Hotkey, *NumPad4, on
  ; Hotkey, *NumPad1, on
  Hotkey, *NumPad2, on
  ; Hotkey, *NumPad3, on

  Hotkey, NumPadEnter & NumPadUp, on
  Hotkey, NumPadEnter & NumPadDown, on
  Hotkey, NumPadEnter & NumPadHome, on
  Hotkey, NumPadEnter & NumPadEnd, on
  Hotkey, NumPadEnter & NumPadPgUp, on
  Hotkey, NumPadEnter & NumPadPgDn, on
  Hotkey, NumPadEnter & NumPadLeft, on
  Hotkey, NumPadEnter & NumPadRight, on

  Hotkey, NumPadEnter & NumPad8, on
  Hotkey, NumPadEnter & NumPad2, on
  Hotkey, NumPadEnter & NumPad7, on
  Hotkey, NumPadEnter & NumPad1, on
  Hotkey, NumPadEnter & NumPad9, on
  Hotkey, NumPadEnter & NumPad3, on
 
  Hotkey, NumPadEnter, on
}
else
{
  Hotkey, *NumPad0, off
  Hotkey, *NumPadIns, off
  Hotkey, *NumPad5, off
  Hotkey, *NumPadDot, off
  Hotkey, *NumPadDel, off
  Hotkey, *NumPadDiv, off
  Hotkey, *NumPadMult, off

  Hotkey, *NumPadSub, off
  Hotkey, *NumPadAdd, off

  Hotkey, *NumPadUp, off
  Hotkey, *NumPadDown, off
  Hotkey, *NumPadLeft, off
  Hotkey, *NumPadRight, off
  ; Hotkey, *NumPadHome, off
  ; Hotkey, *NumPadEnd, off
  ; Hotkey, *NumPadPgUp, off
  ; Hotkey, *NumPadPgDn, off

  Hotkey, *NumPad6, off
  ; Hotkey, *NumPad9, off
  Hotkey, *NumPad8, off
  ; Hotkey, *NumPad7, off
  Hotkey, *NumPad4, off
  ; Hotkey, *NumPad1, off
  Hotkey, *NumPad2, off
  ; Hotkey, *NumPad3, off

  Hotkey, NumPadEnter & NumPadUp, off
  Hotkey, NumPadEnter & NumPadDown, off
  Hotkey, NumPadEnter & NumPadHome, off
  Hotkey, NumPadEnter & NumPadEnd, off
  Hotkey, NumPadEnter & NumPadPgUp, off
  Hotkey, NumPadEnter & NumPadPgDn, off
  Hotkey, NumPadEnter & NumPadLeft, off
  Hotkey, NumPadEnter & NumPadRight, off

  Hotkey, NumPadEnter & NumPad8, off
  Hotkey, NumPadEnter & NumPad2, off
  Hotkey, NumPadEnter & NumPad7, off
  Hotkey, NumPadEnter & NumPad1, off
  Hotkey, NumPadEnter & NumPad9, off
  Hotkey, NumPadEnter & NumPad3, off
 
  Hotkey, NumPadEnter, on
}
return

ButtonEnter:
Send, {NumPadEnter}
Return

;Mouse click support
ButtonLeftClick:
ButtonClickType:="Left"
MouseButtonName:="LButton"
Goto ButtonClickStart
ButtonMiddleClick:
ButtonMiddleClickClear:
ButtonLeftClickIns:
ButtonClickType:="Middle"
MouseButtonName:="MButton"
Goto ButtonClickStart
ButtonRightClick:
ButtonRightClickDel:
ButtonClickType:="Right"
MouseButtonName:="RButton"
Goto ButtonClickStart
ButtonClickStart:
StringReplace, ButtonName, A_ThisHotkey, *
If (ButtonDown_%ButtonName%!=1)
{
  ButtonDown_%ButtonName%:=1
  Buttons:=Buttons+1
  Button%Buttons%Name:=ButtonName
  Button%Buttons%ClickType:=ButtonClickType
  Button%Buttons%MouseButtonName:=MouseButtonName
  Button%Buttons%Initialized:=0
  Button%Buttons%UnHoldStep:=0
  If (Buttons = 1)
    SetTimer, MouseButtonPressCheck, % MouseButtonPressCheckTimerInterval
}
Return

MouseButtonPressCheck:
If (Buttons=0)
{
  SetTimer, MouseButtonPressCheck, off
  Return
}

Button:=0
Loop
{
  Button:=Button+1
  If (Button%Buttons%Initialized=0)
  {
    GetKeyState, MouseButtonState, % Button%Button%MouseButtonName
    If (MouseButtonState="D")
      Continue
    MouseClick, % Button%Button%ClickType,,, 1, 0, D
    Button%Buttons%Initialized:=1
  }
 
  GetKeyState, ButtonState, % Button%Button%Name, P
  If (ButtonState="U" and (MouseButtonClickLockDownState=0 or (MouseButtonClickLockDownState=1 and Button%Buttons%UnHoldStep=2)))
  {
    ButtonName:=Button%Buttons%Name
    ButtonDown_%ButtonName%:=0
    MouseClick, % Button%Button%ClickType,,, 1, 0, U
   
    ButtonTemp:=Button
    ButtonTempPrev:=ButtonTemp-1

    Loop
    {
      ButtonTemp:=ButtonTemp+1
      ButtonTempPrev:=ButtonTempPrev+1
     
      If (Buttons<ButtonTemp)
      {
        Button%ButtonTempPrev%Name:=""
        Button%ButtonTempPrev%ClickType:=""
        Button%ButtonTempPrev%MouseButtonName:=""
        Button%ButtonTempPrev%Initialized:=0
        Break
      }
      Button%ButtonTempPrev%Name:=Button%ButtonTemp%Name
      Button%ButtonTempPrev%ClickType:=Button%ButtonTemp%ClickType
      Button%ButtonTempPrev%MouseButtonName:=Button%ButtonTemp%MouseButtonName
      Button%ButtonTempPrev%Initialized:=Button%ButtonTemp%Initialized
    }
    Buttons:=Buttons-1
  }
  
  If(ButtonState="U" and MouseButtonClickLockDownState=1 and Button%Buttons%UnHoldStep=0)
    Button%Buttons%UnHoldStep:=1
  If(ButtonState="D" and MouseButtonClickLockDownState=1 and Button%Buttons%UnHoldStep=1)
    Button%Buttons%UnHoldStep:=2
  
  If (Buttons<=Button)
    Break
}
Return

;Mouse movement support
ButtonDownRight:
MovementVectorDirectionTemp+=1
ButtonDown:
MovementVectorDirectionTemp+=1
ButtonDownLeft:
MovementVectorDirectionTemp+=1
ButtonLeft:
MouseGetPos, xpos, ypos 
if (xpos < 12) {
  MouseMove, A_ScreenWidth, ypos
}
MovementVectorDirectionTemp+=1
ButtonUpLeft:
MovementVectorDirectionTemp+=1
ButtonUp:
MovementVectorDirectionTemp+=1
ButtonUpRight:
MovementVectorDirectionTemp+=1
ButtonRight:
MouseGetPos, xpos, ypos 
if (xpos > 3849) {
  MouseMove, 0, ypos
}
StringReplace, MovementButtonName, A_ThisHotkey, *
If (MovementButtonDown_%MovementButtonName%!=1)
{
  MovementButtonDown_%MovementButtonName%:=1
  MovementVectors:=MovementVectors+1
  MovementVector%MovementVectors%Name:=MovementButtonName
  MovementVector%MovementVectors%Direction:=(MovementVectorDirectionTemp*PI/4)+(MouseRotationAngle*PI/180)
  MovementVector%MovementVectors%Magnitude:=MouseSpeed
  MovementVector%MovementVectors%Initialized:=0
  MovementVector%MovementVectors%UnHoldStep:=0
  If (MovementVectors = 1)
  {
    MouseCurrentAccelerationSpeed:=MouseSpeed
    SetTimer, MovementVectorAcceleration, % MouseAccelerationTimerInterval
  }
}
MovementVectorDirectionTemp:=0
Return

MovementVectorAddition:
;Add 2 vectors
MovementVectorX:=MovementVectorMagnitude*Cos(MovementVectorDirection)+MovementVector%MovementVector%Magnitude*Cos(MovementVector%MovementVector%Direction)
MovementVectorY:=MovementVectorMagnitude*Sin(MovementVectorDirection)+MovementVector%MovementVector%Magnitude*Sin(MovementVector%MovementVector%Direction)
MovementVectorMagnitude:=Sqrt(MovementVectorX**2+MovementVectorY**2)
MovementVectorDirection:=ATan(MovementVectorY/MovementVectorX)
If (MovementVectorX<0)
{
  If (MovementVectorY>0)
    MovementVectorDirection:=MovementVectorDirection-PI
  Else
    MovementVectorDirection:=PI+MovementVectorDirection
}
MovementVectorMagnitudeRatio:=MovementVectorMagnitude/MouseSpeed
Return

MovementVectorAcceleration:
If (MovementVectors=0)
{
  MovementVectorX:=0.000000
  MovementVectorY:=0.000000
  MovementVectorMagnitude:=0.000000
  MovementVectorDirection:=0.000000
  MovementVectorMagnitudeRatio:=0.000000
  MovementResultantVectorMagnitude:=0.000000
  MovementResultantVectorDirection:=0.000000
  MovementResultantVectorX:=0.000000
  MovementResultantVectorY:=0.000000
  ;TrayTip,,% "(" . MovementResultantVectorMagnitude . "," . MovementResultantVectorDirection . ") - <" . MovementResultantVectorX . "," . MovementResultantVectorY . ">"
  SetTimer, MovementVectorAcceleration, off
  Return
}
MovementVector:=0
Loop
{
  MovementVector:=MovementVector+1
  If (MovementVector%MovementVector%Initialized=0)
  {
    Gosub, MovementVectorAddition
    MovementVector%MovementVector%Initialized:=1
  }
  GetKeyState, MovementButtonState, % MovementVector%MovementVector%Name, P
  If (MovementButtonState="U" and (MouseButtonMovementLockDownState=0 or (MouseButtonMovementLockDownState=1 and MovementVector%MovementVector%UnHoldStep=2)))
  {
    MovementButtonName:=MovementVector%MovementVector%Name
    MovementButtonDown_%MovementButtonName%:=0
    MovementVector%MovementVector%Magnitude:=-MovementVector%MovementVector%Magnitude
    Gosub, MovementVectorAddition
    MovementVectorTemp:=MovementVector
    MovementVectorTempPrev:=MovementVector-1
    Loop
    {
      MovementVectorTemp:=MovementVectorTemp+1
      MovementVectorTempPrev:=MovementVectorTempPrev+1
      If (MovementVectors<MovementVectorTemp)
      {
        MovementVector%MovementVectorTempPrev%Name:=""
        MovementVector%MovementVectorTempPrev%Direction:=0
        MovementVector%MovementVectorTempPrev%Magnitude:=0
        MovementVector%MovementVectorTempPrev%Initialized:=0
        MovementVector%MovementVectorTempPrev%UnHoldStep:=0
        Break
      }
      MovementVector%MovementVectorTempPrev%Name:=MovementVector%MovementVectorTemp%Name
      MovementVector%MovementVectorTempPrev%Direction:=MovementVector%MovementVectorTemp%Direction
      MovementVector%MovementVectorTempPrev%Magnitude:=MovementVector%MovementVectorTemp%Magnitude
      MovementVector%MovementVectorTempPrev%Initialized:=MovementVector%MovementVectorTemp%Initialized
      MovementVector%MovementVectorTempPrev%UnHoldStep:=MovementVector%MovementVectorTemp%UnHoldStep
    }
    MovementVectors:=MovementVectors-1
  }
  
  If(MovementButtonState="U" and MouseButtonMovementLockDownState=1 and MovementVector%MovementVector%UnHoldStep=0)
    MovementVector%MovementVector%UnHoldStep:=1
  If(MovementButtonState="D" and MouseButtonMovementLockDownState=1 and MovementVector%MovementVector%UnHoldStep=1)
    MovementVector%MovementVector%UnHoldStep:=2
  
  If (MovementVectors<=MovementVector)
    Break
}
If (MouseCurrentAccelerationSpeed<MouseMaxSpeed)
  MouseCurrentAccelerationSpeed:=MouseCurrentAccelerationSpeed+(MouseAccelerationSpeed/MouseAccelerationCycles)
MovementResultantVectorMagnitude:=MouseCurrentAccelerationSpeed*MovementVectorMagnitudeRatio
MovementResultantVectorDirection:=MovementVectorDirection
MovementResultantVectorX:=MovementResultantVectorMagnitude*Cos(MovementResultantVectorDirection)
MovementResultantVectorY:=MovementResultantVectorMagnitude*Sin(MovementResultantVectorDirection)
;TrayTip,,% "(" . MovementResultantVectorMagnitude . "," . MovementResultantVectorDirection . ") - <" . MovementResultantVectorX . "," . MovementResultantVectorY . ">"
MouseMove, % MovementResultantVectorX, % -MovementResultantVectorY, 0, R
Return

;Mouse wheel movement support
ButtonWheelDown:
MovementWheelVectorDirectionTemp+=1
ButtonWheelLeft:
MovementWheelVectorDirectionTemp+=1
ButtonWheelUp:
MovementWheelVectorDirectionTemp+=1
ButtonWheelRight:
StringReplace, MovementWheelButtonName, A_ThisHotkey, *
If (MovementWheelButtonDown_%MovementWheelButtonName%!=1)
{
  MovementWheelButtonDown_%MovementWheelButtonName%:=1
  MovementWheelVectors:=MovementWheelVectors+1
  MovementWheelVector%MovementWheelVectors%Name:=MovementWheelButtonName
  MovementWheelVector%MovementWheelVectors%Direction:=(MovementWheelVectorDirectionTemp*PI/4)+(MouseWheelRotationAngle*PI/180)
  MovementWheelVector%MovementWheelVectors%Magnitude:=MouseWheelSpeed
  MovementWheelVector%MovementWheelVectors%Initialized:=0
  MovementWheelVector%MovementWheelVectors%UnHoldStep:=0
 
  If (MovementWheelVectors = 1)
  {
    MouseWheelCurrentAccelerationSpeed:=MouseWheelSpeed
    SetTimer, MovementWheelVectorAcceleration, % MouseWheelAccelerationTimerInterval
  }
}
MovementWheelVectorDirectionTemp:=0
Return

MovementWheelVectorAddition:
;Add 2 vectors
MovementWheelVectorX:=MovementWheelVectorMagnitude*Cos(MovementWheelVectorDirection)+MovementWheelVector%MovementWheelVector%Magnitude*Cos(MovementWheelVector%MovementWheelVector%Direction)
MovementWheelVectorY:=MovementWheelVectorMagnitude*Sin(MovementWheelVectorDirection)+MovementWheelVector%MovementWheelVector%Magnitude*Sin(MovementWheelVector%MovementWheelVector%Direction)
MovementWheelVectorMagnitude:=Sqrt(MovementWheelVectorX**2+MovementWheelVectorY**2)
MovementWheelVectorDirection:=ATan(MovementWheelVectorY/MovementWheelVectorX)
If (MovementWheelVectorX<0)
{
  If (MovementWheelVectorY>0)
    MovementWheelVectorDirection:=MovementWheelVectorDirection-PI
  Else
    MovementWheelVectorDirection:=PI+MovementWheelVectorDirection
}
MovementWheelVectorMagnitudeRatio:=MovementWheelVectorMagnitude/MouseWheelSpeed
Return

MovementWheelVectorAcceleration:
If (MovementWheelVectors=0)
{
  MovementWheelVectorX:=0.000000
  MovementWheelVectorY:=0.000000
  MovementWheelVectorMagnitude:=0.000000
  MovementWheelVectorDirection:=0.000000
  MovementWheelVectorMagnitudeRatio:=0.000000

  MovementWheelResultantVectorMagnitude:=0.000000
  MovementWheelResultantVectorDirection:=0.000000
  MovementWheelResultantVectorX:=0.000000
  MovementWheelResultantVectorY:=0.000000
 
  ;TrayTip,,% "(" . MovementResultantVectorMagnitude . "," . MovementResultantVectorDirection . ") - <" . MovementResultantVectorX . "," . MovementResultantVectorY . ">"
  SetTimer, MovementWheelVectorAcceleration, off
  Return
}

MovementWheelVector:=0
Loop
{
  MovementWheelVector:=MovementWheelVector+1
  If (MovementWheelVector%MovementWheelVector%Initialized=0)
  {
    Gosub, MovementWheelVectorAddition
    MovementWheelVector%MovementWheelVector%Initialized:=1
  }
 
  GetKeyState, MovementWheelButtonState, % MovementWheelVector%MovementWheelVector%Name, P
  If (MovementWheelButtonState="U" and (MouseButtonMovementLockDownState=0 or (MouseButtonMovementLockDownState=1 and MovementWheelVector%MovementWheelVector%UnHoldStep=2)))
  {
    MovementWheelButtonName:=MovementWheelVector%MovementWheelVector%Name
    MovementWheelButtonDown_%MovementWheelButtonName%:=0
    MovementWheelVector%MovementWheelVector%Magnitude:=-MovementWheelVector%MovementWheelVector%Magnitude
    Gosub, MovementWheelVectorAddition
   
    MovementWheelVectorTemp:=MovementWheelVector
    MovementWheelVectorTempPrev:=MovementWheelVector-1
    Loop
    {
      MovementWheelVectorTemp:=MovementWheelVectorTemp+1
      MovementWheelVectorTempPrev:=MovementWheelVectorTempPrev+1
     
      If (MovementWheelVectors<MovementWheelVectorTemp)
      {
        MovementWheelVector%MovementWheelVectorTempPrev%Name:=""
        MovementWheelVector%MovementWheelVectorTempPrev%Direction:=0
        MovementWheelVector%MovementWheelVectorTempPrev%Magnitude:=0
        MovementWheelVector%MovementWheelVectorTempPrev%Initialized:=0
        MovementWheelVector%MovementWheelVectorTempPrev%UnHoldStep:=0
        Break
      }
     
      MovementWheelVector%MovementWheelVectorTempPrev%Name:=MovementWheelVector%MovementWheelVectorTemp%Name
      MovementWheelVector%MovementWheelVectorTempPrev%Direction:=MovementWheelVector%MovementWheelVectorTemp%Direction
      MovementWheelVector%MovementWheelVectorTempPrev%Magnitude:=MovementWheelVector%MovementWheelVectorTemp%Magnitude
      MovementWheelVector%MovementWheelVectorTempPrev%Initialized:=MovementWheelVector%MovementWheelVectorTemp%Initialized
      MovementWheelVector%MovementWheelVectorTempPrev%UnHoldStep:=MovementWheelVector%MovementWheelVectorTemp%UnHoldStep
    }
    MovementWheelVectors:=MovementWheelVectors-1
  }
  If(MovementWheelButtonState="U" and MouseButtonMovementLockDownState=1 and MovementWheelVector%MovementWheelVector%UnHoldStep=0)
    MovementWheelVector%MovementWheelVector%UnHoldStep:=1
  If(MovementWheelButtonState="D" and MouseButtonMovementLockDownState=1 and MovementWheelVector%MovementWheelVector%UnHoldStep=1)
    MovementWheelVector%MovementWheelVector%UnHoldStep:=2

  If (MovementWheelVectors<=MovementWheelVector)
    Break
}

If (MouseWheelCurrentAccelerationSpeed<MouseWheelMaxSpeed)
  MouseWheelCurrentAccelerationSpeed:=MouseWheelCurrentAccelerationSpeed+(MouseWheelAccelerationSpeed/MouseWheelAccelerationCycles)

MovementWheelResultantVectorMagnitude:=MouseWheelCurrentAccelerationSpeed*MovementWheelVectorMagnitudeRatio
MovementWheelResultantVectorDirection:=MovementWheelVectorDirection
MovementWheelResultantVectorX:=MovementWheelResultantVectorMagnitude*Cos(MovementWheelResultantVectorDirection)
MovementWheelResultantVectorY:=MovementWheelResultantVectorMagnitude*Sin(MovementWheelResultantVectorDirection)
;TrayTip,,% "(" . MovementResultantVectorMagnitude . "," . MovementResultantVectorDirection . ") - <" . MovementResultantVectorX . "," . MovementResultantVectorY . ">"

If (MovementWheelResultantVectorX>=0)
  MouseClick, wheelright,,, % MovementWheelResultantVectorX, 0, D
Else
  MouseClick, wheelleft,,, % -MovementWheelResultantVectorX, 0, D

If (MovementWheelResultantVectorY>=0)
  MouseClick, wheelup,,, % MovementWheelResultantVectorY, 0, D
Else
  MouseClick, wheeldown,,, % -MovementWheelResultantVectorY, 0, D
Return


;Speed/rotation configuration support
;Movement
ButtonSpeedUp:
MouseSpeed:=MouseSpeed+2
ButtonSpeedDown:
MouseSpeed--
If (MouseSpeed>MouseMaxSpeed)
  MouseSpeed:=MouseMaxSpeed
If (MouseSpeed<=1)
{
  MouseSpeed:=1
  ToolTip, Mouse speed: %MouseSpeed% pixel
}
Else
  ToolTip, Mouse speed: %MouseSpeed% pixels
SetTimer, RemoveToolTip, 1000
Return

ButtonAccelerationSpeedUp:
MouseAccelerationSpeed:=MouseAccelerationSpeed+2
ButtonAccelerationSpeedDown:
MouseAccelerationSpeed--
If (MouseAccelerationSpeed<=1)
{
  MouseAccelerationSpeed:=1
  ToolTip, Mouse acceleration speed: %MouseAccelerationSpeed% pixel/cycle
}
Else
  ToolTip, Mouse acceleration speed: %MouseAccelerationSpeed% pixels/cycle
SetTimer, RemoveToolTip, 1000
Return

ButtonMaxSpeedUp:
MouseMaxSpeed:=MouseMaxSpeed+2
ButtonMaxSpeedDown:
MouseMaxSpeed--
If (MouseSpeed>MouseMaxSpeed)
  MouseSpeed:=MouseMaxSpeed
If (MouseMaxSpeed<=1)
{
  MouseMaxSpeed:=1
  ToolTip, Mouse maximum speed: %MouseMaxSpeed% pixel
}
Else
  ToolTip, Mouse maximum speed: %MouseMaxSpeed% pixels
SetTimer, RemoveToolTip, 1000
Return

ButtonRotationAngleUp:
MouseRotationAnglePart:=MouseRotationAnglePart+2
ButtonRotationAngleDown:
MouseRotationAnglePart--
If(MouseRotationAnglePart>=8)
  MouseRotationAnglePart:=0
If(MouseRotationAnglePart<0)
  MouseRotationAnglePart:=7
MouseRotationAngle = %MouseRotationAnglePart%
MouseRotationAngle *= 45
ToolTip, Mouse rotation angle: %MouseRotationAngle%°
SetTimer, RemoveToolTip, 1000
Return

;Wheel
ButtonWheelSpeedUp:
MouseWheelSpeed:=MouseWheelSpeed+2
ButtonWheelSpeedDown:
MouseWheelSpeed--
If (MouseWheelSpeed>MouseWheelMaxSpeed)
  MouseWheelSpeed:=MouseWheelMaxSpeed
If (MouseWheelSpeed<=1)
  MouseWheelSpeed:=1
RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
MouseWheelSpeedTemp:=MouseWheelSpeed*MouseWheelSpeedMultiplier
If (MouseWheelSpeedTemp=1)
  ToolTip, Mouse wheel speed: %MouseWheelSpeedTemp% line
Else
  ToolTip, Mouse wheel speed: %MouseWheelSpeedTemp% lines
SetTimer, RemoveToolTip, 1000
Return

ButtonWheelAccelerationSpeedUp:
MouseWheelAccelerationSpeed:=MouseWheelAccelerationSpeed+2
ButtonWheelAccelerationSpeedDown:
MouseWheelAccelerationSpeed--
If (MouseWheelAccelerationSpeed<=1)
  MouseWheelAccelerationSpeed:=1
RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
MouseWheelAccelerationSpeedTemp:=MouseWheelAccelerationSpeed*MouseWheelSpeedMultiplier
If (MouseWheelAccelerationSpeedTemp=1)
  ToolTip, Mouse wheel acceleration speed: %MouseWheelAccelerationSpeedTemp% line/cycle
Else
  ToolTip, Mouse wheel acceleration speed: %MouseWheelAccelerationSpeedTemp% lines/cycle
SetTimer, RemoveToolTip, 1000
Return

ButtonWheelMaxSpeedUp:
MouseWheelMaxSpeed:=MouseWheelMaxSpeed+2
ButtonWheelMaxSpeedDown:
MouseWheelMaxSpeed--
If (MouseWheelSpeed>MouseWheelMaxSpeed)
  MouseWheelSpeed:=MouseWheelMaxSpeed
If (MouseWheelMaxSpeed<=1)
  MouseWheelMaxSpeed:=1
RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
MouseWheelMaxSpeedTemp:=MouseWheelMaxSpeed*MouseWheelSpeedMultiplier
If (MouseWheelMaxSpeedTemp=1)
  ToolTip, Mouse wheel max speed: %MouseWheelMaxSpeedTemp% line
Else
  ToolTip, Mouse wheel max speed: %MouseWheelMaxSpeedTemp% lines
SetTimer, RemoveToolTip, 1000
Return

ButtonWheelRotationAngleUp:
MouseWheelRotationAnglePart:=MouseWheelRotationAnglePart+2
ButtonWheelRotationAngleDown:
MouseWheelRotationAnglePart--
If(MouseWheelRotationAnglePart>=8)
  MouseWheelRotationAnglePart:=0
If(MouseWheelRotationAnglePart<0)
  MouseWheelRotationAnglePart:=7
MouseWheelRotationAngle = %MouseWheelRotationAnglePart%
MouseWheelRotationAngle *= 45
ToolTip, Mouse wheel rotation angle: %MouseWheelRotationAngle%°
SetTimer, RemoveToolTip, 1000
Return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
Return

NumPadAdd:
If GetKeyState("Ctrl", "P") 
  SendInput, {Ctrl down}{NumPadAdd}{Ctrl up}
else 
  SendInput {WheelDown}
Return

NumPadSub:
If GetKeyState("Ctrl", "P") 
  SendInput, {Ctrl down}{NumPadSub}{Ctrl up}
else 
  SendInput {WheelUp}
Return

; The following scripts allow Right Arrow to behave like Ctrl
; Right Arrow  NumPad9 sends Ctrl+PgUp
$*NumPadPgUp:: 
GetKeyState, state, Right, P
if (state="D" or GetKeyState("Ctrl", "P") )
  SendInput, {Ctrl down}{PgUp}{Ctrl up}
else
  SendInput, {PgUp}
return

; Right Arrow  NumPad3 sends Ctrl+PgDown
$*NumPadPgDn:: 
GetKeyState, state, Right, P
if (state="D" or GetKeyState("Ctrl", "P") )
  SendInput, {Ctrl down}{PgDn}{Ctrl up}
else
  SendInput, {PgDn}
return


NextYoutubeVideo:
Send, {Shift down}{N}{Shift up}
Return

PreviousYoutubeVideo:
Send, {Shift down}{P}{Shift up}
Return