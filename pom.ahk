#SingleInstance, Force
#NoEnv
SetWorkingDir %A_ScriptDir%
iconN(1)
Menu, TRAY, Tip, pomHotKey


mText := textTH("แสดง shrotcut key")
Menu, Tray, Add, %mText%, showShortCut

GroupAdd DisableKeyAuto, ahk_exe Code.exe
GroupAdd DisableKeyAuto, ahk_exe chrome.exe 


GroupAdd DisSwapLine, ahk_exe Code.exe
GroupAdd DisSwapLine, ahk_exe excel.exe 
GroupAdd DisSwapLine, ahk_exe chrome.exe 

; GroupAdd winBucket, ahk_exe Ssms.exe
; GroupAdd winBucket, ahk_exe notepad
; GroupAdd winBucket, ahk_exe notepad


ArrowEnable = 0

Run, Screen_clipping.ahk
Run, google_translate.ahk
Run, LayoutFix.exe

PasteWait(){
    ; https://www.autohotkey.com/boards/viewtopic.php?f=5&t=37209&p=171360#p271287
    while DllCall("user32\GetOpenClipboardWindow", "Ptr")
    	Sleep, 50
}

textTH(arText)
{
  ; arText := arText
  vSize := StrPut(arText, "CP0")
  VarSetCapacity(vUtf8, vSize)
  vSize := StrPut(arText, &vUtf8, vSize, "CP0")
  return StrGet(&vUtf8, "UTF-8") ;café
}

GetKeyboardLanguage()
{
	if !ThreadId := DllCall("user32.dll\GetWindowThreadProcessId", "Ptr", WinActive("A"), "UInt", 0, "UInt")
		return false
	
	if !KBLayout := DllCall("user32.dll\GetKeyboardLayout", "UInt", ThreadId, "UInt")
		return false
	
	return KBLayout & 0xFFFF
}

SwapLang(text)
	{
  currentLang := GetKeyboardLanguage()
  OutputDebug, % lang1
  OutputDebug, % lang2
  
  ; return
  sourcetext := (text)
	;  lang1:="!@#$%^&*()_+ 1234567890-= QWERTYUIOP{}| ASDFGHJKL:"" ZXCVBNM<>? qwertyuiop[]\ asdfghjkl;'' zxcvbnm,./" ; english
  ;  lang2:=textTH("+๑๒๓๔ู฿๕๖๗๘๙ ๅ/-ภถุึคตจขช ๐""ฎฑธํ๊ณฯญฐ,ฅ ฤฆฏโฌ็๋ษศซ.. ()ฉฮฺ์?ฒฬฦ ๆไำพะัีรนยบลฃ ฟหกดเ้่าสวงง ผปแอิืทมใฝ") ; other language
   lang1:=textTH(" @#$%^&*()_+1234567890-=!")
   lang2:=textTH(" ๑๒๓๔ู฿๕๖๗๘๙ๅ/-ภถุึคตจขช+")
    ;OutputDebug, % "1: "StrLen(lang1) ","StrLen(lang2)

   lang1:= lang1 . textTH("QWERTYUIOP{}|q\w]e[rptoyiu")
   lang2:= lang2 . textTH("๐""ฎฑธํ๊ณฯญฐ,ฅๆฃไลำบพยะนัรี")
    ;OutputDebug, % "2: "StrLen(lang1) ","StrLen(lang2)
   
   lang1:= lang1 . textTH("AHSJDKFLG:""ahsjdkflg;'")
   lang2:= lang2 . textTH("ฤ็ฆ๋ฏษโศฌซ.ฟ้ห่กาดสเวง")
    ;OutputDebug, % "3: "StrLen(lang1) ","StrLen(lang2)

   lang1:= lang1 . textTH("ZXCVBNM<>?zxcvbnm,./ ")
   lang2:= lang2 . textTH("()ฉฮฺ์?ฒฬฦผปแอิืทมใฝ ") ; other language
    ;OutputDebug, % "4: "StrLen(lang1) ","StrLen(lang2)

   
   if (currentLang = 1033){
    ;  'en'
    Source = 2
    target = 1
   }
   Else {
    Source = 1
    target = 2
   }
  ;  findlang := InStr(lang1,SubStr(sourcetext,1,1),true)
  ;  if (findlang = 0) {
  ;  	Source = 2
  ;   target = 1
  ;  }
  ;  else {
  ;  	Source = 1
  ;   target = 2
  ;  }
  ;  MsgBox % target ":" source                       
   
   Loop, parse, sourcetext
   	{
   	  Get:=InStr(Lang%source%,A_Loopfield,true)
      if (Get = 0) {
        swapTemp := A_Loopfield
      } 
      else {
        swapTemp := SubStr(lang%target%,get,1)
      }
      SwappedText .= swapTemp
      OutputDebug, %A_Loopfield%[%Get%] ">" SubStr(lang%target%,%get%,1)  ">" %SwappedText% "|" %lang2%
   	}
     OutputDebug, % currentLang " , " Source target
   Return (SwappedText)
	}

LenStrTH(str) {
  ; sourctText := str
  THWord:=textTH("อัอ็อิอีอึอือุอูอ่อ้อ๊อ๋อ์อํอฺอำ")
  THDelimiter := textTH("อ")
  Loop, parse, THWord , %THDelimiter%
  {
    str := StrReplace(str, A_Loopfield , "")
  }
  return StrLen(str)
}

addTagCut(b_char,e_char){
  temp:=Clipboard
  Sendinput, {CtrlDown}x{CtrlUp}
  ClipWait 0.1
  Sendinput, {%b_char%}
  sleep 40
  XCaret := A_CaretX
  YCaret := A_CaretY
  Sendinput, {CtrlDown}v{CtrlUp}{%e_char%}{left}
  sleep 20
  while (XCaret < A_CaretX || YCaret < A_CaretY ) ; || leftbk > A_Index) ; < A_CaretY && leftbk >= A_Index)
  {
    sendinput, +{left}
    sleep 10
    OutputDebug,  (%XCaret% < %A_CaretX% || %YCaret% < %A_CaretY%)
  }
    ; sendinput, +{left %leftbk%}
  Clipboard:=temp
}

addTag(b_char,e_char){
  sendinput, {%b_char%}{%e_char%}{left 1}{CtrlUp}
  return
}

iconN(numIcon){
  FullPathEXE := StrReplace(A_ScriptFullPath, ".ahk", ".exe")
  if (FullPathEXE = A_ScriptFullPath) {
    Menu, Tray, Icon, %FullPathEXE%, %numIcon%
  }
  else {
    if numIcon = 1
      Menu, Tray, Icon, arrows1.ico
    Else  
      Menu, Tray, Icon, arrows2.ico
  }
  return
}

Text := ""
ToolTipTimer:
  mousegetpos, x, y
  tooltip, %Text%, (x + 20), (y + 20), 1
return

;=================================
; Volume Control with Visual Feedback
;

#IfWinActive ahk_exe chrome.exe
:*:www::
send, ^lwww
return

#IfWinActive ahk_exe excel.exe 
F11::send, !vu
; ^+v::send !hvv
^+v::
  send !esv
  WinActive("ahk_class bosa_sdm_XL9")
  send {down 5}
  send {enter}
  return
#IfWinActive ahk_exe WINWORD.EXE
F11::send, !vu
^+v::send !hvt
#IfWinActive ahk_exe POWERPNT.EXE
F11::send, +{F5}
#IfWinActive ahk_exe AcroRd32.exe
F11::send, ^l


#IfWinActive ahk_exe blender.exe
$~shift::
    GetKeyState, MButtonState, MButton
    if (MButtonState == "D") {
      OutputDebug, % "s1" MButtonState
      send {MButton Up}{shift Down}{MButton Down}
    }
    keyWait, shift
    GetKeyState, MButtonState, MButton
    if (MButtonState == "D") {
      OutputDebug, % "s2" MButtonState
      send {MButton Up}{MButton Down}
    }
return
  FormatTime, CurrentDateTime,, yyMMddHHmmss
  OutputDebug, %  MButtonState  CurrentDateTime

    ; while MButtonState = "D"
    ; {
    ;     send {MButton Up}{MButton Down}
    ;     MButtonState := ""
    ; }
Return


return


#IfWinNotActive ahk_group DisableKeyAuto
; :?*:(::
; addTag("(",")")
; return

; :?*:{::
; addTag("{","}")
; return

; :?*:[::
; addTag("[","]")
; return

:?*:/*::
send, /*{enter}*/{left 3}
return

^(::
addTagCut("(",")")
return 

^[::
addTagCut("[","]")
return 

^{::
addTagCut("{","}")
return 



#IfWinNotActive ahk_group DisSwapLine


~RControl::
if (A_PriorHotkey != "~RControl" or A_TimeSincePriorHotkey > 400)
{
    ; Too much time between presses, so this isn't a double-press.
    KeyWait, RControl
    return
}
MsgBox You double-pressed the right control key.
return

~^+Down::
; SetKeyDelay, 500
; sendinput, {end}{ShiftDown}{up}{end}{del}{ShiftUp}{Down}{end}{ShiftDown}{Insert}{ShiftUp}
; BlockInput On
; Clipboard :=  ""
; sendinput, {home}{ShiftDown}{end}{del}{ShiftUp}{del}{down}{enter}{up}{ShiftDown}{Insert}{CtrlDown}{ShiftDown}
; sendinput, {home}{ShiftDown}{end}{del}{ShiftUp}{del}
; Clipboard :=  "`n" . Clipboard
; sendinput, {end}{ShiftDown}{Insert}
; sendinput,{ShiftDown}{CtrlDown}
tmp_clip := ClipboardAll ; preserve old clipboard 
Clipboard := "" ; empty the clipboard so the ClipWait can check that the new content has landed 
  sendinput, {home}{Shift Down}{end}{del}{Shift Up} ; CUT LINE
  sendinput, {del}
  Clipboard :=  "`n" . Clipboard
ClipWait ; wait until clipboard contains data 
sendinput, {end}{Shift Down}{Insert}{Shift Up}
; sendinput, {ShiftDown}{Insert}{ShiftDown}{CtrlDown}
PasteWait()
Clipboard := tmp_clip ; restore the clipboard 
ClipWait
; BlockInput Off
; KeyWait, Down
return

~^+Up::
; BlockInput On
; Clipboard :=  ""
; sendinput, {home}{ShiftDown}{end}{del}{ShiftUp}{del}{up}{enter}{up}{ShiftDown}{Insert}{CtrlDown}{ShiftDown}
; BlockInput Off
; sendinput, {home}{ShiftDown}{end}{del}{ShiftUp}{del}
; Clipboard :=  "`n" . Clipboard
; sendinput, {up 2}{end}{ShiftDown}{Insert}
; sendinput,{ShiftDown}{CtrlDown}
tmp_clip := ClipboardAll ; preserve old clipboard 
Clipboard := "" ; empty the clipboard so the ClipWait can check that the new content has landed 
  sendinput, {home}{Shift Down}{end}{del}{Shift Up} ; CUT LINE
  sendinput, {del}
  ; Clipboard :=  "`n" . Clipboard
  sendinput, {up}{enter}{up}
ClipWait ; wait until clipboard contains data   
sendinput, {Shift Down}{Insert}{Shift Up}
PasteWait()
Clipboard := tmp_clip ; restore the clipboard 
ClipWait
; OutputDebug, % A_KeyDelay
; sendinput, {end}{enter}{ShiftDown}{up}{del}{Shiftup}{BackSpace}{home}{ShiftDown}{Insert}{Shiftup}{up}{End}
; sendinput, {end}{enter}{ShiftDown}{up}{del}{ShiftUp}{BackSpace}{home}{ShiftDown}{Insert}{ShiftUp}{left}{End}
; KeyWait, Up
return

; ^+Down::SendInput {HOME 2}+{END}^x{Delete}{Down}^v{Enter}
; ^+Up::SendInput {HOME 2}+{END}^x{Delete}{Up}^v{Enter}{Up}

#if GetKeyState("CapsLock",P)


#if


::addr::
  sendinput ,% TextTH("406/3 หมู่5 ถ.ศรีนครินทร์ `nต.สำโรงเหนือ อ.เมืองสมุทรปราการ `nจ.สมุทรปราการ 10270`n")
return

::addr1::
  sendinput ,% TextTH("ชั้น 3-4 อาคารสำนักพัฒนาอุตสาหกรรมรายสาขา (สพข.) `nซ.ตรีมิตร กล้วยน้ำไท ถ.พระรามที่ 4 แขวงคลองเตย `nเขตคลองเตย กรุงเทพฯ 10110`n")
return

::addr2::
  sendinput ,% TextTH("655 ซอย 1 นิคมอุตสาหกรรมบางปู หมู่ 2 `nถนนสุขุมวิท กม.34 ตำบลบางปูใหม่่ `nอำเภอเมืองสมุทรปราการ จังหวัดสมุทรปราการ 10280`n")
return

::sup.::
  sendinput ,% TextTH("ศุภกร สิริสรรพสาร")
return

:*:tainet//::
  sendinput , www.thaiauto.or.th/tainet{enter}
  sleep 2000
  sendinput, 0090{tab}Pompom@7586tainet{enter}
return

:*:tainetv2//::
  sendinput , www.thaiauto.or.th/tainetv2{enter}
return

:*:thaiauto//::
  sendinput , http://www.thaiauto.or.th{enter}
return

; #a::

; return


checkSelectText() {
  return 0


  ClipSaved := ClipboardAll       ;save clipboard
  clipboard := ""  ; empty clipboard
  Send, ^c    ; copy the selected file
  ClipWait, 0.1		; wait for the clipboard to contain data
  sleep 200
  Clip1 := Clipboard       ;save clipboard
  Sendinput, {ShiftDown}{left}{ShiftUp}{CtrlDown}c{CtrlUp}
  ClipWait, 0.1		; wait for the clipboard to contain data
  sleep 100
  Clip2 := Clipboard       ;save clipboard
  if (Clip1 = Clip2){
    Sendinput, {right}
    return 0
  }
  else {
    Sendinput, {ShiftDown}{right}{ShiftUp}
    return 1
  }


ClipSaved := ClipboardAll       ;save clipboard
clipboard := ""  ; empty clipboard
Send, ^c    ; copy the selected file
ClipWait, 0.1		; wait for the clipboard to contain data
t0 := strLen(StrReplace(clipboard,"`n"))
if (!ErrorLevel)    ; if NOT ErrorLevel clipwait found data on the clipboard
{
  clipboard := ""  ; empty clipboard
  SendInput, {ShiftDown}{left}{ShiftUp}{CtrlDown}c{CtrlUp}{ShiftDown}{right}{ShiftUp}
  ClipWait, 0.1		; wait for the clipboard to contain data
  t1 := strLen(StrReplace(clipboard,"`n"))
  clipboard := ""  ; empty clipboard
  SendInput, {ShiftDown}{right}{ShiftUp}{CtrlDown}c{CtrlUp}{ShiftDown}{left}{ShiftUp}
  ClipWait, 0.1		; wait for the clipboard to contain data
  t2 := strLen(StrReplace(clipboard,"`n"))
  ; SendInput, +{right}
  if (abs(t0-t1) = 1 || abs(t0-t2) = 1) {
    OutputDebug, % "report " t0 "," t1 "," t2
    return 1
  }
}
Sleep, 100
clipboard := ClipSaved       ; restore original clipboard
ClipSaved := ""   ;  free the memory in case the clipboard was very large.
OutputDebug, % "report " t0 "," t1 "," t2
return 0

}


F1 & LButton::
MouseGetPos, MouseX, MouseY
PixelGetColor, color, %MouseX%, %MouseY%
colorR := SubStr(color, 7 , 2)
colorG := SubStr(color, 5 , 2)
colorB := SubStr(color, 3 , 2)
color := "#" . colorR . colorG . colorB
MsgBox The color at the current cursor position is %color%.
Clipboard := color
return


F1 & d::
formatTime, CurrentDateTime,, dd/MM/yyyy
SendInput, %CurrentDateTime%
OutputDebug, %CurrentDateTime%
return

F1 & NumpadDiv::
F1 & /::
if (getKeyState("Shift", "P"))
  send , dim pom{enter}pom = 1/pom{enter}
else  
  send , dim pommoq{enter}pom = 1/pommoq{enter}
return



F1 & '::
send , {home}'
return


F1 & n::
run, notepad.exe
return

F1 & c::
run, calc.exe
return

F1 & v::
run, code.exe
return

F1 & i::
command = ipconfig | find  ":" | find /v "Subnet" | find /v "Gateway" | find /v "DNS" |find /v "discon" |find /v "IPv6" |find /v "*" |find /v "Tunneli"|find /v "Bluetooth" > c:\temp\ip.txt
RunWait %ComSpec% /c %command% ,,Hide
FileRead, OutputVar, c:\temp\ip.txt
OutputVar := StrReplace(OutputVar, "IPv4 Address. . . . . . . . . . . :" ,"")
Clipboard := OutputVar
command := "del c:\temp\ip.txt /f"
Run %ComSpec% /c %command% ,,Hidei
; msgbox, %OutputVar%
MsgBox, 64, IP Address, %OutputVar%, 10
return



#f12::send ^!{CtrlBreak}
^!WheelUP::Send {Volume_Up 1}
^!WheelDown::Send {Volume_Down 1}
^!MButton::Send {Volume_Mute}
+space::send {Right}
+BackSpace::send {Left}
^+space::send {down}
^+BackSpace::send {up} 

; ^BackSpace::
; temp:=Clipboard
; Sendinput, {CtrlDown}x{CtrlUp}
; sleep 10
; XCaret := A_CaretX
; YCaret := A_CaretY
; ClipWait 0.1
; if ErrorLevel
;   return
; OutputDebug, % "textbefore: " Clipboard
; swaptext:=SwapLang(Clipboard)
; OutputDebug, % "textafter: " swaptext

; Clipboard:=swaptext
; Sendinput, {CtrlDown}v{CtrlUp}
; ; leftbk := LenStrTH(Clipboard)
; leftbk := StrLen(Clipboard) -1
; sleep 10
; ; OutputDebug, %XCaret% < %A_CaretX% || %YCaret% <= %A_CaretY% || %leftbk% > %A_Index%
; while (XCaret < A_CaretX || YCaret < A_CaretY ) ; || leftbk > A_Index) ; < A_CaretY && leftbk >= A_Index)
; {
;   sendinput, +{left}
;   sleep 10
;   ; OutputDebug,  (%XCaret% < %A_CaretX% || %YCaret% < %A_CaretY% || %leftbk% > %A_Index%)
; }
;   ; sendinput, +{left %leftbk%}
; Clipboard:=temp
; Return






#o::
WinActivate, LINE
if !WinExist("LINE") {
  run , C:\Users\suppakorn\AppData\Local\LINE\bin\LineLauncher.exe
}
WinWait, ahk_exe Line.exe
WinActivate, LINE
X:=30
Y:=118
OutputDebug, %X% %Y%
; MouseMove, %X%, %Y%,5
MouseClick,left, %X%, %Y%
X:=X+300
; MouseMove, %X%, %Y%,5
MouseClick,left, %X%, %Y%
; return
Sleep, 500
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *80 capture_line.bmp
OutputDebug, found= %FoundX%, %FoundY%
FoundX := FoundX +0
if (FoundX = null) {
  OutputDebug, r e t u r n %FoundX%, %FoundY%
  return
}
FoundX += 10
FoundY += 10

MouseMove, %FoundX%, %FoundY% , 5
MouseClick

KeyWait, LButton , D
KeyWait, LButton
SysGet, Mon1, Monitor, 1

OutputDebug, area=  %Mon1Right%,%Mon1Bottom%
Sleep, 500
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *60 scantext_line.bmp
OutputDebug, found= %FoundX%, %FoundY%
FoundX += 10
FoundY += 10
MouseMove, %FoundX%, %FoundY% , 5
MouseClick
Sleep, 2500
MouseMove, 722, 336 , 5
MouseClick
return


; F9::
; 	hwnd := WinExist("A")
; 	ret1 := DllCall("CreateCaret", UInt, hwnd, UInt, 1, Int, 5, Int, 5)
; 	ret2 := DllCall("ShowCaret", UInt, hwnd)
; 	msgbox, CreateCaret Return: %ret1%`nShowCaret Return: %ret2%
; 	return

:*:l5k::l5k[yopkopo9N
; :o:z,::z,xhv,gv'8iy[
:o:pp,::Pompom@7586
:o:tdga,::suppakorn@thaiauto.or.th{tab}Pompom@7586tdga
:o:supthai::suppakorn@thaiauto.or.th
:o:pomg::pommoq@gmail.com
:o:pom00::pom00moq@gmail.com
:o:pom69::pom69moq@gmail.com
:o:pomh::pom.moq@hotmail.com
:o:pom_h::pom_moq@hotmail.com




NumpadClear::Down
#t::  Winset, Alwaysontop, , A

; RAlt & l::
;   DllCall("LockWorkStation")
; return 
; ().., [Params...])

#u::

  if (ArrowEnable = 0) {
    iconN(2)
    ArrowEnable = 1
    Text := "JKLI Move"
    SetTimer, ToolTipTimer, 10  ;timer routine will occur every 10ms..
  } Else {
    iconN(1)
    ArrowEnable = 0
    SetTimer, ToolTipTimer, off  ;timer routine will occur every 10ms..
    Sleep, 50
    tooltip
  }
  return 

; +!i::send,{up}
; +!k::send,{down}
; +!j::send,{left}
; +!l::send,{right}

; ~$l::
; KeyWait, l, U
; KeyWait, k, D, T0.2
; KeyWait, k, U
; KeyWait, j, D, T0.2
; ; :*:aa::
; If (ErrorLevel = 0){
;   send {BackSpace}{BackSpace}{BackSpace}
;   ; #k::
;   if (ArrowEnable = 0) {
;     iconN(2)
;     ArrowEnable = 1
;     Text := "JKLI Move"
;     SetTimer, ToolTipTimer, 10  ;timer routine will occur every 10ms..


;   } Else {
;     iconN(1)
;     ArrowEnable = 0
;     tooltip, 
;     SetTimer, ToolTipTimer, off  ;timer routine will occur every 10ms..
;   }
;   ;MsgBox, %ArrowEnable%
;   return 
; }
; return

; #a::                             ; shortcut key is <Win>+a
; CoordMode, Screen
; MouseGetPos, mx, my
; Gui, DynamicInput: Margin, 0, 0
; Gui, DynamicInput:-Caption +ToolWindow +AlwaysOnTop +LastFound
; Gui, Font, s15, Tahoma
; Gui,DynamicInput:Add, Edit ,w150
; Gui,DynamicInput:Add, Edit ,w150

; Gui,DynamicInput:Show, x%mx% y%my%

; return

; #m::
; Gui, Color, White
; Gui, -caption +toolwindow +AlwaysOnTop
; Gui, font, s30 bold, Arial
; Gui, add, text, vTX cRed TransColor, Insert coin
; Gui, Show, % "x" A_ScreenWidth-300 " y" A_ScreenHeight-130 ,TRANS-WIN
; WinSet, TransColor, White, TRANS-WIN
; SetTimer, onoff, 1000
; return
; OnOff:	
; 	GuiControl, % (toggle := !toggle ) ? "Hide" : "Hide", TX
;   ; GuiControl, "Hide", TX 
; return 

#If ArrowEnable = 1
  9:: send {home}
  u:: send {Del}
  p:: send {BackSpace}
  +7:: send +{Insert}
  +u:: send +{Del}
  
  h:: send {home}
  o:: send {end}
  i:: send {up}
  k:: send {down}
  j:: send {left}
  l:: send {right}
  
  +h:: send {ShiftDown}{home}
  +o:: send {ShiftDown}{end}
  +i:: send {ShiftDown}{up}
  +k:: send {ShiftDown}{down}
  +j:: send {ShiftDown}{left}
  +l:: send {ShiftDown}{right}

  ^h:: send {CtrlDown}{home}
  ^o:: send {CtrlDown}{end}
  ^i:: send {CtrlDown}{up}
  ^k:: send {CtrlDown}{down}
  ^j:: send {CtrlDown}{left}
  ^l:: send {CtrlDown}{right}

  !h:: send {AltDown}{home}
  !o:: send {AltDown}{end}
  !i:: send {AltDown}{up}
  !k:: send {AltDown}{down}
  !j:: send {AltDown}{left}
  !l:: send {AltDown}{right}

  +^h:: send {CtrlDown}{ShiftDown}{home}
  +^o:: send {CtrlDown}{ShiftDown}{end}
  +^i:: send {CtrlDown}{ShiftDown}{up}
  +^k:: send {CtrlDown}{ShiftDown}{down}
  +^j:: send {CtrlDown}{ShiftDown}{left}
  +^l:: send {CtrlDown}{ShiftDown}{right}

  !^h:: send {AltDown}{CtrlDown}{home}
  !^o:: send {AltDown}{CtrlDown}{end}
  !^i:: send {AltDown}{CtrlDown}{up}
  !^k:: send {AltDown}{CtrlDown}{down}
  !^j:: send {AltDown}{CtrlDown}{left}
  !^l:: send {AltDown}{CtrlDown}{right}
  
  `;::
  ; send {end}
  iconN(1)
  ArrowEnable = 0
  SetTimer, ToolTipTimer, off  ;timer routine will occur every 10ms..
  Sleep, 50
  tooltip
  return 

  ~a::
  ~Esc::
  ~s::
  ~d::
  ~f::
  ~g::
  

  iconN(1)
  ArrowEnable = 0
  SetTimer, ToolTipTimer, off  ;timer routine will occur every 10ms..
  Sleep, 50
  tooltip
  return 
  ; Space::
  ; send {Space}
  ; iconN(1)
  ; ArrowEnable = 0
  ; tooltip, 
  ; SetTimer, ToolTipTimer, off  ;timer routine w'ill occur every 10ms..
  ; return 
  ; lksadfoiejkas;ilejfl;kjadfk
  ; Enter::
  ; send {Enter}
  ; iconN(1)
  ; ArrowEnable = 0
  ; tooltip, 
  ; SetTimer, ToolTipTimer, off  ;timer routine will occur every 10ms..
  ; return   
  ; ,::
  ;   send {CtrlDown}{right}
  ;   ; send {CtrlUp}
  ;   send {ShiftDown}{CtrlDown}{left}
  ;   send {ShiftUp}
  ;   send {CtrlUp}
  ;   return

  ; .::
  ;   send {CtrlDown}{left}
  ;   ; send {CtrlUp}
  ;   send {ShiftDown}{CtrlDown}{right}
  ;   send {ShiftUp}
  ;   send {CtrlUp}
  ;   return
#If

showShortCut:
; mText := ""
; mText := mText textTH("MS Office : (F11) Full Screen (!VU)`n")
; mText := mText textTH("Chrome : (CapLock) goto addressbar (^L)`n")
; mText := mText textTH("(F1+C) pick color pixle to clipboard`n")
; mText := mText textTH("(F1+D) send current date dd/mm/yyyy`n")
; mText := mText textTH("(F1+/) send asp debug `n")
; mText := mText textTH("(#T) Window Alway on Top `n")
; mText := mText textTH("(!T) Translate from Clipboard Eng to Thai`n")
; mText := mText textTH("(+!T) Translate from Clipboard Thai to Eng`n")
; mText := mText textTH("(^BackSpace) switch between [TH/ENG] language in select text`n")
; MsgBox,% mText
ListHotkeys
return

