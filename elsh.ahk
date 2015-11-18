#NoTrayIcon

NumberOfVariants:=4
goto StartProgram

ASKVariants:
Done := 0
Gui,5: Destroy
Gui,5: -MinimizeBox
Gui,5: Font, s18, Tahoma
Gui,5: Add, Text,, %req%
Gui,5: Font, s10, Tahoma
loop %NumberOfVariants%
{
	gui,5: Add, Button, gPress vV%A_Index%, % variant%A_Index%
}
Percent := round(PercentGood*100 / PercentTotal)
gui,5: show, center, ELSH  -- Choose from %NumberOfVariants% (%Percent% `%)
PercentTotal++
return

Press:
digit := substr(A_GuiControl,2,1)
if (which==digit)
{
Gui,5: Color, Green
sleep 200
if (!PercentWrong)
PercentGood++
PercentWrong := 0
Goto, %GoToWhere%
}
else
{
PercentWrong := 1
Gui,5: Color, Red
Guicontrol,5: Hide,%A_GuiControl%
}
return

ChooseList:
gui,destroy,
gui,-minimizebox
gui,font,s8,tahoma
gui,add,text,w300,Choose the file containing the words and expressions you want to exercise on.
gui,add,listbox,w300 h200 vLB,
gui,add,button,gStart,Choose
gui,add,button,gStartRand x+10,Choose randomly

gui,show,center,Choose file

numberfiles := 0
loop,files\*.txt
{
guicontrol,,lb,%A_LoopFileName%
numberfiles++
}
Done := 0
return

Start:
gui,submit
file := A_ScriptDir . "\files\" . LB
goto %GoToWhere%
return

StartRand:
random,rand,1,numberfiles
GuiControl, Choose, LB, %rand%
gui,submit
file := A_ScriptDir . "\files\" . LB
goto %GoToWhere%
return
ChooseRandomly:
gui,submit,nohide
file := A_ScriptDir . "\files\" . LB
Done:=1

return

StartProgram:
Menu,Main,Add,
Menu,Main,DeleteAll
Menu,Main,Add,Choose from variants (Word -> Explanation),Type1
Menu,Main,Add,Choose from variants (Explanation -> Word),Type2
Menu,Main,Add,
Menu,Main,Add,Settings,Settings

gui,1:default
gui,destroy
gui,font,s12,Tahoma
gui,add,text,,English-Language Study Helper
gui,font,s8
gui,add,text,w300,By your fellow Petru.

gui,add,button,gChooseTask,What do you want to do?
gui,show,center,English-Language Study Helper Main Window
return

ChooseTask:
Menu,Main,Show
return

Type1:
GoToWhere:="STARTASK1"
goto ChooseList
STARTASK1:
#singleinstance force

GoToWhere := "ASK1"
number := 0
fileread,aux,%file%
loop,parse,aux,`n
{
number++
}

PercentGood := 0
PercentTotal := 0

ASK1:
random,which,1,%NumberOfVariants%

random,rand,1,number
filereadline,text,%file%,%rand%
StringSplit,v,text,!

loop % NumberOfVariants
{
Variant%A_Index% := ""
}
Req := v1
Variant%which% := v2
loop % NumberOfVariants
{
if (which!=A_Index)
{
	ok := 0
        a := A_Index
	while (!ok)
		{
		random,x,1,number
		filereadline,text,%file%,%x%
		StringSplit,v,text,!
		Variant%a% := v2
		ok := 1
                if (Variant%a%=Variant%which%)
                ok := 0
                if (Variant%a%="")
                ok := 0
		loop % a-1
			{
			if (Variant%A_index%=v2)
			ok := 0
			}
		}
}
}

gosub ASKVariants
; #include t1.ahk
return

Type2:
GoToWhere:="STARTASK2"
goto ChooseList
STARTASK2:
#singleinstance force

GoToWhere := "ASK2"
number := 0
fileread,aux,%file%
loop,parse,aux,`n
{
number++
}

PercentGood := 0
PercentTotal := 0

ASK2:
random,which,1,%NumberOfVariants%

random,rand,1,number
filereadline,text,%file%,%rand%
StringSplit,v,text,!

loop % NumberOfVariants
{
Variant%A_Index% := ""
}
Req := v2
Variant%which% := v1
loop %NumberOfVariants%
{
if (which!=A_Index)
{
	ok := 0
        a := A_Index
	while (!ok)
		{
		random,x,1,number
		filereadline,text,%file%,%x%
		StringSplit,v,text,!
		Variant%a% := v1
		ok := 1
                if (Variant%a%=Variant%which%)
                ok := 0
                if (Variant%a%="")
                ok := 0
		loop % a-1
			{
			if (Variant%A_Index%=v1)
			ok := 0
			}
		}
}
}

gosub ASKVariants
; #include t2.ahk
return
GuiClose:
exitapp
return

5GuiClose:
gui,5:destroy
goto StartProgram
return

Setup:
return

Settings:
Gui, 99: Destroy
Gui, 99: Font,, Tahoma
Gui, 99: Add, GroupBox, x12 y10 w270 h50 , Variant-choosing exercises
Gui, 99: Add, Text, x22 y30 w110 h20 , How many variants?
Gui, 99: Add, Slider, x132 y30 w90 h20 Range1-10 vNumberOfVariants gNumberOfVariantsMod, %NumberOfVariants%
Gui, 99: Add, Text, x222 y30 w40 h20 vTextNumberOfVariants, 4
Gui, 99: Show, center h375 w564, Settings
Return

NumberOfVariantsMod:
Gui, 99: submit, nohide
Guicontrol, 99:, TextNumberOfVariants, %NumberOfVariants%
return
; #include setari.ahk
