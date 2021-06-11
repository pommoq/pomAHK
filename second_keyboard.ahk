#SingleInstance Force
DetectHiddenWindows, ON
Arr_KBID := []
Soundbeep
Soundbeep

Keyboard2 := false


Gui, Font, cBlue
Gui, Add, Edit, 			h300 ReadOnly -VScroll vThatOne
Gui, Font, cRed
Gui, Add, Edit, x+10 	h300 ReadOnly -VScroll vThisOne
Gui, Show,, Two Keyboards

; OnMessage(0x104, "MyKEYDOWN")
OnMessage( 0x00FF, "YouPressed")
SizeofRawInputDeviceList	:= A_PtrSize * 2
SizeofRawInputDevice		:= 8 + A_PtrSize
RIDI_DEVICENAME				:= 0x20000007
RIDI_DEVICEINFO				:= 0x2000000b
RIDEV_INPUTSINK				:= 0x00000100
RID_INPUT					:= 0x10000003
HWND := WinExist( "Two Keyboards" )
Res := DllCall( "GetRawInputDeviceList", "Ptr", 0, "UInt*", Kount, UInt, SizeofRawInputDeviceList)
VarSetCapacity( RawInputList, SizeofRawInputDeviceList * Kount)
Res := DllCall( "GetRawInputDeviceList", "Ptr", &RawInputList, "UInt*", Kount, "UInt", SizeofRawInputDeviceList)
KeyboardRegistered := 0
Loop % Kount 
{
	Handle := NumGet( RawInputList, ( A_Index - 1) * SizeofRawInputDeviceList, "UInt")
	Type := NumGet( RawInputList, (( A_Index - 1) * SizeofRawInputDeviceList) + A_PtrSize, "UInt")
	If (Type <> 1)
		Continue
	KBDCount ++
	KbD%KBDCount% := Handle		
  Arr_KBID.Push(Handle)
	Res := DllCall( "GetRawInputDeviceInfo", "Ptr", Handle, "UInt", RIDI_DEVICENAME, "Ptr", 0, "UInt *", nLength)
	VarSetCapacity( Name, ( nLength + 1) * 2)
	Res := DllCall( "GetRawInputDeviceInfo", "Ptr", Handle, "UInt", RIDI_DEVICENAME, "Str", Name, "UInt*", nLength)
	Res := DllCall( "GetRawInputDeviceInfo", "Ptr", Handle, "UInt", RIDI_DEVICEINFO, "Ptr", 0, "UInt *", iLength)
	VarSetCapacity( Info, iLength)
	NumPut( iLength, Info, 0, "UInt")
	Res := DllCall( "GetRawInputDeviceInfo", "Ptr", Handle, "UInt", RIDI_DEVICEINFO, "UInt", &Info, "UInt *", iLength)
	VarSetCapacity( RawDevice, SizeofRawInputDevice, 0)
	NumPut( RIDEV_INPUTSINK, RawDevice, 4)
	NumPut( HWND, RawDevice, 8)
	DoRegister := 0
	If ( KeyboardRegistered = 0)
	{
		DoRegister := 1
		NumPut( 1, RawDevice, 0, "UShort")
		NumPut( 6, RawDevice, 2, "UShort")
		KeyboardRegistered := 1
	}
	If (DoRegister)
		Res := DllCall( "RegisterRawInputDevices", "Ptr", &RawDevice, "UInt", 1, "UInt", 8 + A_PtrSize ) 
}
Kount := 1 
; Gui, hide
Return

GuiClose:
Soundbeep
Soundbeep
ExitApp

MyKEYDOWN( wParam, lParam, msg, hwnd )
{
	Global
	Res := DllCall( "GetRawInputData", "UInt", lParam, "UInt", RID_INPUT, "Ptr", 0, "UInt *", Size, "UInt", 8 + A_PtrSize * 2)
	VarSetCapacity( Buffer, Size)
	Res := DllCall( "GetRawInputData", "UInt", lParam, "UInt", RID_INPUT, "Ptr", &Buffer, "UInt *", Size, "UInt", 8 + A_PtrSize * 2)
	If ( NumGet( Buffer, 0 * 4, "UInt") = 1)								
	{
		VKey := NumGet( Buffer, (14 + A_PtrSize * 2 ), "UShort")
		nn :=  GetKeyName( "vk" VKey)
		OutputDebug keydown %nn%
	}
}
YouPressed( wParam, lParam, msg, hwnd )
{
	Global
	Res := DllCall( "GetRawInputData", "UInt", lParam, "UInt", RID_INPUT, "Ptr", 0, "UInt *", Size, "UInt", 8 + A_PtrSize * 2)
	VarSetCapacity( Buffer, Size)
	Res := DllCall( "GetRawInputData", "UInt", lParam, "UInt", RID_INPUT, "Ptr", &Buffer, "UInt *", Size, "UInt", 8 + A_PtrSize * 2)
	If ( NumGet( Buffer, 0 * 4, "UInt") = 1)								
	{
		VKey := NumGet( Buffer, (14 + A_PtrSize * 2 ), "UShort")
		If ( NumGet( Buffer, (16 + A_PtrSize * 2 )) = 256 )    	
		{
			SetFormat, Integer, H					
			VKey += 0
      ; KbD1 keyboard ตัวสุดท้ายที่เสียบเข้ากับคอม
      KbOK := false
      for index, element in Arr_KBID ; Enumeration is the recommended approach in most cases.
      {
        keyid := element 
        If ( NumGet( Buffer, 2 * 4, "UInt") = keyid && index <> 1){
          KbOK := true
          OutputDebug, % index
        }
      }
      ; If ( NumGet( Buffer, 2 * 4, "UInt") = KbD1 ){
      ;   OutputDebug, % KbD1
      ;   KbOK := true
      ; }
      if (KbOK) {
        ; เป็น keyboard ตัวสุดท้าย
				Keyboard2 := false
        ThatWay( GetKeyName( "vk" VKey) "`r`n",VKey)
      } else {
				Keyboard2 := true
	      ThisWay( GetKeyName( "vk" VKey) "`r`n",VKey)
      }
			; If ( NumGet( Buffer, 2 * 4, "UInt") = KbD%A_Index% ) 				
			; 	ThisWay( GetKeyName( "vk" VKey) "`r`n",VKey)
			; Else
			; 	ThatWay( GetKeyName( "vk" VKey) "`r`n",VKey)				
			; }
    }
	}	
	Return true
}
ThatWay( Text,VKey)
{
	GuiControlGet, 	ThatOne
	GuiControl,, 	ThatOne, % Text ThatOne 
	KeybID := 1
	StringLeft, KeyID, Text, 3
	OutputDebug, 1, VKey=%VKey% ,Type, %KeybID% , %Text%
	; Switch VKey
	; {
  ;   case 0x61:
	; 	; Send, b
  ;   Return
  ;   Default:
  ;   return
	; }
	Return
}
ThisWay( Text,VKey)
{
	GuiControlGet,	ThisOne
	GuiControl,, 	ThisOne, % Text ThisOne , %KbD0% , %KbD1%
	KeybID := 0
	OutputDebug, 0, ,VKey=%VKey% ,Type, %KeybID% %Text%
	StringLeft, KeyID, Text, 3
	; Switch VKey
	; {
  ;   case tab:
	; 	; Send, {Tab 1}
  ;   Return
  ;   Default:
  ;   return
	; }

	Return
}

#If, Keyboard2
Numpad1::Numpad0

#if