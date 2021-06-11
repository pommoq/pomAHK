#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


;lang1:=textTH("!@#$%^&*()_+ 1234567890-= QWERTYUIOP{}| qwertyuiop[]\ ASDFGHJKL:"" asdfghjkl;' ZXCVBNM<>? zxcvbnm,./ ") ; english
;lang2:=textTH("+๑๒๓๔ู฿๕๖๗๘๙ ๅ/-ภถุึคตจขช ๐""ฎฑธํ๊ณฯญฐ,ฅ ๆไำพะัีรนยบล ฤฆฏโฌ็๋ษศซ. ฟหกดเ้่าสวง ()ฉฮฺ์?ฒฬฦ ผปแอิืทมใฝ ") ; other language
; OutputDebug, % SwapLang(lang1,2) "=" lang1 ; to illustrate
; OutputDebug, % SwapLang(lang2,1) "=" lang2 ; to illustrate  

textTH(arText)
{
  ; arText := arText
  vSize := StrPut(arText, "CP0")
  VarSetCapacity(vUtf8, vSize)
  vSize := StrPut(arText, &vUtf8, vSize, "CP0")
  return StrGet(&vUtf8, "UTF-8") ;café
}




^BackSpace::
SendInput, ^x
Clipboard:=SwapLang(Clipboard)
SendInput, ^v
Return

SwapLang(text)
	{
  sourcetext := (text)
	;  lang1:="!@#$%^&*()_+ 1234567890-= QWERTYUIOP{}| ASDFGHJKL:"" ZXCVBNM<>? qwertyuiop[]\ asdfghjkl;'' zxcvbnm,./" ; english
  ;  lang2:=textTH("+๑๒๓๔ู฿๕๖๗๘๙ ๅ/-ภถุึคตจขช ๐""ฎฑธํ๊ณฯญฐ,ฅ ฤฆฏโฌ็๋ษศซ.. ()ฉฮฺ์?ฒฬฦ ๆไำพะัีรนยบลฃ ฟหกดเ้่าสวงง ผปแอิืทมใฝ") ; other language
   lang1:=textTH("!@#$%^&*()_+1234567890-=")
   lang2:=textTH("+๑๒๓๔ู฿๕๖๗๘๙ๅ/-ภถุึคตจขช")
    OutputDebug, % "1: "StrLen(lang1) ","StrLen(lang2)

   lang1:= lang1 . textTH("QWERTYUIOP{}|q\w]e[rptoyiu")
   lang2:= lang2 . textTH("๐""ฎฑธํ๊ณฯญฐ,ฅๆฃไลำบพยะนัรี")
    OutputDebug, % "2: "StrLen(lang1) ","StrLen(lang2)
   
   lang1:= lang1 . textTH("AHSJDKFLG:""ahsjdkflg;'")
   lang2:= lang2 . textTH("ฤ็ฆ๋ฏษโศฌซ.ฟ้ห่กาดสเวง")
    OutputDebug, % "3: "StrLen(lang1) ","StrLen(lang2)

   lang1:= lang1 . textTH("ZXCVBNM<>?zxcvbnm,./ ")
   lang2:= lang2 . textTH("()ฉฮฺ์?ฒฬฦผปแอิืทมใฝ ") ; other language
    OutputDebug, % "4: "StrLen(lang1) ","StrLen(lang2)

   findlang := InStr(lang1,SubStr(sourcetext,1,1),true)
   if (findlang = 0) {
   	Source = 2
    target = 1
   }
   else {
   	Source = 1
    target = 2
   }
  ;  MsgBox % target ":" source                       
   
   Loop, parse, sourcetext
   	{
   	 Get:=InStr(Lang%source%,A_Loopfield,true)
     swapTemp := SubStr(lang%target%,get,1)
   	 SwappedText .= swapTemp
     OutputDebug, %A_Loopfield%[%Get%] ">" SubStr(lang%target%,%get%,1)  ">" %SwappedText%
    
   	}
   Return (SwappedText)
	}

