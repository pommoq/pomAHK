GetMonitor(){
	CoordMode, Mouse, Screen
	MouseGetPos, mx, my
	SysGet, monitorsCount, 80

	Loop %monitorsCount%{
		SysGet, monitor, Monitor, %A_Index%
		if (monitorLeft <= mx && mx <= monitorRight && monitorTop <= my && my <= monitorBottom){
			Return A_Index
		}
	}
	Return 1	
}
TextSize(text, size, font, ByRef width, ByRef height)
{
	global txt
	
	Critical
	Gui, DummyGUI: destroy
	Gui, DummyGUI: -DPIScale
	Gui, DummyGUI:Font, s%size%, %font%
	Gui, DummyGUI:Add, Text, vTxt, %text%
	GuiControlGet, ov, DummyGUI:Pos, Txt
	Critical Off
	
	width := ovw
	height := ovh
}

A_Scaling := A_ScreenDPI / 96
SysGet, monitorWorkArea, MonitorWorkArea, 1

Gui, 2: -DPIScale
w := 100 * A_Scaling
h := 100 * A_Scaling
x := monitorWorkAreaLeft + 100 * A_Scaling
y := monitorWorkAreaTop + 100 * A_Scaling
Gui, 2: Show, x%x% y%y% h%h% w%w%