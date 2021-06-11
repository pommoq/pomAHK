#SingleInstance, Force
; SendMode Input
SetWorkingDir, %A_ScriptDir%


; ControlGetFocus, FocusedControl, ahk_exe DroidCamApp.exe
; ControlGetPos,  X, Y, cWidth, cHeight, %FocusedControl%
; OutputDebug, %FocusedControl% %X% %Y% %cWidth% %cHeight%



; loop, 20
; {
;   c := "Button"A_Index

;   ControlGet, OutputVar, Enabled ,, %c%, ahk_exe DroidCamApp.exe

;   OutputDebug, %c% = %outputVar%

;   Control, Enable ,, %c%, ahk_exe DroidCamApp.exe

;   ControlGet, OutputVar, Enabled ,, %c%, ahk_exe DroidCamApp.exe
;   OutputDebug, %c% = %outputVar%
; }


WinGet, ActiveControlList, ControlList, ahk_exe DroidCamApp.exe
  OutputDebug, %ActiveControlList%
Loop, Parse, ActiveControlList, `n
{
  ; MsgBox, 4,, Control #%A_Index% is "%A_LoopField%". Continue?
  ; IfMsgBox, No
  ;     break
  Control, Enable ,, %A_LoopField%, ahk_exe DroidCamApp.exe    
}