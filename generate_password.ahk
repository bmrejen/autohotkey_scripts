#SingleInstance force
Menu, Tray, Icon, %A_ScriptDir%\grey.ico
;------------------------------------------------------------------------------
; Ctrl+Shift+U generates a password
;------------------------------------------------------------------------------
^+U::gen_password()

gen_password()
{
  Chars1 = abcdefghijklmnopqrstuvwxyz
  Chars2 = ABCDEFGHIJKLMNOPQRSTUVWXYZ
  Chars3 = 1234567890
  Chars4 = _-+=()!@#$^&*{}[]|\:;'<>?,./
  str =
  clipboard =
  UpperRange = 4 		;<-- use all 4 character strings
  len = 26 			;<-- number of characters in the password
   
  				; generate a new password
  loop, %len%
  { random,x,1,%UpperRange% 	;<-- selects the Character string
	random,y,1,26 		;<-- selects the character in the string
    if (x = 3) 			; if numeric there are only 10 digits
    { random,y,1,10
    }
    If (x = 4) 			;<-- if punctuation there are 28 characters
	{ random,y,1,28
    }
    StringMid,z,Chars%x%,%y%,1 	;<-- grab the selected letter
    str = %str%%z% 		;<-- and add it to the password string
  }
  clipboard = %str% 		;<-- put the completed string on the clipboard
}
