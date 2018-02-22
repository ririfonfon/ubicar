;=========================================================================================================================
;=========================================================================================================================

    ;--------- COLOR BASE LAUNCH PAD


;=========================================================================================================================
;=========================================================================================================================


midiOutShortMsg_(my_hMidiOut3,($1568B0))   ;LEARN 
midiOutShortMsg_(my_hMidiOut3,($1569B0))   ;VIEW
midiOutShortMsg_(my_hMidiOut3,($156AB0))   ;PAGE MOINS
midiOutShortMsg_(my_hMidiOut3,($156BB0))   ;PAGE PLUS

midiOutShortMsg_(my_hMidiOut3,($4F6CB0))    ;LEARN S1
midiOutShortMsg_(my_hMidiOut3,($4F6DB0))    ;LEARN S2
midiOutShortMsg_(my_hMidiOut3,($4F6EB0))    ;LEARN S3
midiOutShortMsg_(my_hMidiOut3,($4F6FB0))    ;LEARN S4

midiOutShortMsg_(my_hMidiOut3,($200090))  ;rem 1
midiOutShortMsg_(my_hMidiOut3,($200190))  ;rem 2
midiOutShortMsg_(my_hMidiOut3,($120290))  ;rem 3
midiOutShortMsg_(my_hMidiOut3,($120390))  ;rem 4 

midiOutShortMsg_(my_hMidiOut3,($4F0490))  ;S 1*2  
midiOutShortMsg_(my_hMidiOut3,($4F0590))  ;S 2*2   
midiOutShortMsg_(my_hMidiOut3,($4F0690))  ;S 3*2
midiOutShortMsg_(my_hMidiOut3,($4F0790))  ;S 4*2

midiOutShortMsg_(my_hMidiOut3,($201090))  ;rem 5
midiOutShortMsg_(my_hMidiOut3,($201190))  ;rem 6
midiOutShortMsg_(my_hMidiOut3,($121290))  ;rem 7
midiOutShortMsg_(my_hMidiOut3,($121390))  ;rem 8

midiOutShortMsg_(my_hMidiOut3,($021490))  ;S 1/2
midiOutShortMsg_(my_hMidiOut3,($021590))  ;S 2/2
midiOutShortMsg_(my_hMidiOut3,($021690))  ;S 3/2
midiOutShortMsg_(my_hMidiOut3,($021790))  ;S 4/2

midiOutShortMsg_(my_hMidiOut3,($112090))  ;rem 9
midiOutShortMsg_(my_hMidiOut3,($112190))  ;rem 10
midiOutShortMsg_(my_hMidiOut3,($012290))  ;rem 11
midiOutShortMsg_(my_hMidiOut3,($012390))  ;rem 12

midiOutShortMsg_(my_hMidiOut3,($5F2490))  ;STOP S 1
midiOutShortMsg_(my_hMidiOut3,($5F2590))  ;STOP S 2
midiOutShortMsg_(my_hMidiOut3,($5F2690))  ;STOP S 3
midiOutShortMsg_(my_hMidiOut3,($5F2790))  ;STOP S 4

midiOutShortMsg_(my_hMidiOut3,($113090))  ;rem 13
midiOutShortMsg_(my_hMidiOut3,($113190))  ;rem 14
midiOutShortMsg_(my_hMidiOut3,($013290))  ;rem 15
midiOutShortMsg_(my_hMidiOut3,($013390))  ;rem 16

midiOutShortMsg_(my_hMidiOut3,($003490))  ;select
midiOutShortMsg_(my_hMidiOut3,($7F3590))  ;pause
midiOutShortMsg_(my_hMidiOut3,($7F3690))  ;go moins
midiOutShortMsg_(my_hMidiOut3,($7F3790))  ;go plus





Procedure LaunchLed(*bidon1)
  
 Shared Launch()
 Shared LaunchJ()
 
;readled(*bidon)


 

;midiOutShortMsg_(my_hMidiOut7,($100890))  
If Launch(8)=1
  If LaunchJ(8)=0:midiOutShortMsg_(my_hMidiOut3,($100890)):EndIf
  If LaunchJ(8)=1:midiOutShortMsg_(my_hMidiOut3,($7F0890)):EndIf
EndIf

If Launch(8)=0:midiOutShortMsg_(my_hMidiOut3,($000890)):EndIf



;midiOutShortMsg_(my_hMidiOut7,($111890))  
If Launch(18)=1 
  If LaunchJ(18)=0:midiOutShortMsg_(my_hMidiOut3,($111890)):EndIf
  If LaunchJ(18)=1:midiOutShortMsg_(my_hMidiOut3,($7F1890)):EndIf
EndIf

If Launch(18)=0 :midiOutShortMsg_(my_hMidiOut3,($001890)):EndIf



;midiOutShortMsg_(my_hMidiOut7,($012890))  
If Launch(28)=1 
  If LaunchJ(28)=0:midiOutShortMsg_(my_hMidiOut3,($012890)):EndIf
  If LaunchJ(28)=1:midiOutShortMsg_(my_hMidiOut3,($7F2890)):EndIf
EndIf

If Launch(28)=0 :midiOutShortMsg_(my_hMidiOut3,($002890)):EndIf


;midiOutShortMsg_(my_hMidiOut7,($123890))  
If Launch(38)=1 
  If LaunchJ(38)=0:midiOutShortMsg_(my_hMidiOut3,($123890)):EndIf
  If LaunchJ(38)=1:midiOutShortMsg_(my_hMidiOut3,($7F3890)):EndIf
EndIf

If Launch(38)=0 :midiOutShortMsg_(my_hMidiOut3,($003890)):EndIf     


;midiOutShortMsg_(my_hMidiOut7,($104090))  
If Launch(40)=1 
  If LaunchJ(40)=0: midiOutShortMsg_(my_hMidiOut3,($104090)):EndIf
  If LaunchJ(40)=1: midiOutShortMsg_(my_hMidiOut3,($7F4090)):EndIf
EndIf

If Launch(40)=0 : midiOutShortMsg_(my_hMidiOut3,($004090)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($104190))
If Launch(41)=1 
  If LaunchJ(41)=0: midiOutShortMsg_(my_hMidiOut3,($104190)):EndIf
  If LaunchJ(41)=1: midiOutShortMsg_(my_hMidiOut3,($7F4190)):EndIf
EndIf

If Launch(41)=0 : midiOutShortMsg_(my_hMidiOut3,($004190)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($104290))
If Launch(42)=1 
  If LaunchJ(42)=0: midiOutShortMsg_(my_hMidiOut3,($104290)):EndIf
  If LaunchJ(42)=1: midiOutShortMsg_(my_hMidiOut3,($7F4290)):EndIf
EndIf

If Launch(42)=0 : midiOutShortMsg_(my_hMidiOut3,($004290)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($104390))
If Launch(43)=1
  If LaunchJ(43)=0: midiOutShortMsg_(my_hMidiOut3,($104390)):EndIf
  If LaunchJ(43)=1: midiOutShortMsg_(my_hMidiOut3,($7F4390)):EndIf
EndIf

If Launch(43)=0 : midiOutShortMsg_(my_hMidiOut3,($004390)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($104490))
If Launch(44)=1 
  If LaunchJ(44)=0: midiOutShortMsg_(my_hMidiOut3,($104490)):EndIf
  If LaunchJ(44)=1: midiOutShortMsg_(my_hMidiOut3,($7F4490)):EndIf
EndIf

If Launch(44)=0 : midiOutShortMsg_(my_hMidiOut3,($004490)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($104590))  
If Launch(45)=1 
  If LaunchJ(45)=0: midiOutShortMsg_(my_hMidiOut3,($104590)):EndIf
  If LaunchJ(45)=1: midiOutShortMsg_(my_hMidiOut3,($7F4590)):EndIf
EndIf

If Launch(45)=0 : midiOutShortMsg_(my_hMidiOut3,($004590)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($104690)) 
If Launch(46)=1 
  If LaunchJ(46)=0: midiOutShortMsg_(my_hMidiOut3,($104690)):EndIf
  If LaunchJ(46)=1: midiOutShortMsg_(my_hMidiOut3,($7F4690)):EndIf
EndIf

If Launch(46)=0 : midiOutShortMsg_(my_hMidiOut3,($004690)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($104790)) 
If Launch(47)=1 
  If LaunchJ(47)=0: midiOutShortMsg_(my_hMidiOut3,($104790)):EndIf
  If LaunchJ(47)=1: midiOutShortMsg_(my_hMidiOut3,($7F4790)):EndIf
EndIf

If Launch(47)=0 : midiOutShortMsg_(my_hMidiOut3,($004790)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($104890)) 
If launch(48)=1
  If LaunchJ(48)=0: midiOutShortMsg_(my_hMidiOut3,($104890)):EndIf
  If LaunchJ(48)=1: midiOutShortMsg_(my_hMidiOut3,($7F4890)):EndIf
EndIf

If Launch(48)=0 : midiOutShortMsg_(my_hMidiOut3,($004890)):EndIf

;midiOutShortMsg_(my_hMidiOut7,($115090)) 
If Launch(50)=1 
  If LaunchJ(50)=0: midiOutShortMsg_(my_hMidiOut3,($115090)):EndIf
  If LaunchJ(50)=1: midiOutShortMsg_(my_hMidiOut3,($7F5090)):EndIf
EndIf

If Launch(50)=0 : midiOutShortMsg_(my_hMidiOut3,($005090)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($115190))
If Launch(51)=1 
  If LaunchJ(51)=0: midiOutShortMsg_(my_hMidiOut3,($115190)):EndIf
  If LaunchJ(51)=1: midiOutShortMsg_(my_hMidiOut3,($7F5190)):EndIf
EndIf

If Launch(51)=0 : midiOutShortMsg_(my_hMidiOut3,($005190)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($115290))
If Launch(52)=1 
  If LaunchJ(52)=0: midiOutShortMsg_(my_hMidiOut3,($115290)):EndIf
  If LaunchJ(52)=1: midiOutShortMsg_(my_hMidiOut3,($7F5290)):EndIf
EndIf


If Launch(52)=0 : midiOutShortMsg_(my_hMidiOut3,($005290)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($115390))
If Launch(53)=1 
  If LaunchJ(53)=0: midiOutShortMsg_(my_hMidiOut3,($115390)):EndIf
  If LaunchJ(53)=1: midiOutShortMsg_(my_hMidiOut3,($7F5390)):EndIf
EndIf

If Launch(53)=0 : midiOutShortMsg_(my_hMidiOut3,($005390)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($115490)) 
If Launch(54)=1 
  If LaunchJ(54)=0: midiOutShortMsg_(my_hMidiOut3,($115490)):EndIf
  If LaunchJ(54)=1: midiOutShortMsg_(my_hMidiOut3,($7F5490)):EndIf
EndIf

If Launch(54)=0 : midiOutShortMsg_(my_hMidiOut3,($005490)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($115590)) 
If Launch(55)=1 
  If LaunchJ(55)=0: midiOutShortMsg_(my_hMidiOut3,($115590)):EndIf
  If LaunchJ(55)=1: midiOutShortMsg_(my_hMidiOut3,($7F5590)):EndIf
EndIf

If Launch(55)=0 : midiOutShortMsg_(my_hMidiOut3,($005590)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($115690)) 
If Launch(56)=1 
  If LaunchJ(56)=0: midiOutShortMsg_(my_hMidiOut3,($115690)):EndIf
  If LaunchJ(56)=1: midiOutShortMsg_(my_hMidiOut3,($7F5690)):EndIf
EndIf

If Launch(56)=0 : midiOutShortMsg_(my_hMidiOut3,($005690)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($115790)) 
If Launch(57)=1 
  If LaunchJ(57)=0: midiOutShortMsg_(my_hMidiOut3,($115790)):EndIf
  If LaunchJ(57)=1: midiOutShortMsg_(my_hMidiOut3,($7F5790)):EndIf
EndIf

If Launch(57)=0 : midiOutShortMsg_(my_hMidiOut3,($005790)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($115890))
If Launch(58)=1 
  If LaunchJ(58)=0: midiOutShortMsg_(my_hMidiOut3,($115890)):EndIf
  If LaunchJ(58)=1: midiOutShortMsg_(my_hMidiOut3,($7F5890)):EndIf
EndIf

If Launch(58)=0 : midiOutShortMsg_(my_hMidiOut3,($005890)):EndIf

;midiOutShortMsg_(my_hMidiOut7,($016090)) 
If Launch(60)=1 
  If LaunchJ(60)=0: midiOutShortMsg_(my_hMidiOut3,($016090)):EndIf
  If LaunchJ(60)=1: midiOutShortMsg_(my_hMidiOut3,($7F6090)):EndIf
EndIf

If Launch(60)=0 : midiOutShortMsg_(my_hMidiOut3,($006090)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($016190))
If Launch(61)=1 
  If LaunchJ(61)=0: midiOutShortMsg_(my_hMidiOut3,($016190)):EndIf
  If LaunchJ(61)=1: midiOutShortMsg_(my_hMidiOut3,($7F6190)):EndIf
EndIf

If Launch(61)=0 : midiOutShortMsg_(my_hMidiOut3,($006190)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($016290))
If Launch(62)=1 
  If LaunchJ(62)=0: midiOutShortMsg_(my_hMidiOut3,($016290)):EndIf
  If LaunchJ(62)=1: midiOutShortMsg_(my_hMidiOut3,($7F6290)):EndIf
EndIf

If Launch(62)=0 : midiOutShortMsg_(my_hMidiOut3,($006290)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($016390)) 
If Launch(63)=1 
  If LaunchJ(63)=0: midiOutShortMsg_(my_hMidiOut3,($016390)):EndIf
  If LaunchJ(63)=1: midiOutShortMsg_(my_hMidiOut3,($7F6390)):EndIf
EndIf

If Launch(63)=0 : midiOutShortMsg_(my_hMidiOut3,($006390)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($016490)) 
If Launch(64)=1 
  If LaunchJ(64)=0: midiOutShortMsg_(my_hMidiOut3,($016490)):EndIf
  If LaunchJ(64)=1: midiOutShortMsg_(my_hMidiOut3,($7F6490)):EndIf
EndIf

If Launch(64)=0 : midiOutShortMsg_(my_hMidiOut3,($006490)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($016590))
If Launch(65)=1 
  If LaunchJ(65)=0: midiOutShortMsg_(my_hMidiOut3,($016590)):EndIf
  If LaunchJ(65)=1: midiOutShortMsg_(my_hMidiOut3,($7F6590)):EndIf
EndIf

If Launch(65)=0 : midiOutShortMsg_(my_hMidiOut3,($006590)):EndIf 
;midiOutShortMsg_(my_hMidiOut7,($016690)) 
If Launch(66)=1
  If LaunchJ(66)=0: midiOutShortMsg_(my_hMidiOut3,($016690)):EndIf
  If LaunchJ(66)=1: midiOutShortMsg_(my_hMidiOut3,($7F6690)):EndIf
EndIf

If Launch(66)=0 : midiOutShortMsg_(my_hMidiOut3,($006690)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($016790)) 
If Launch(67)=1 
  If LaunchJ(67)=0: midiOutShortMsg_(my_hMidiOut3,($016790)):EndIf
  If LaunchJ(67)=1: midiOutShortMsg_(my_hMidiOut3,($7F6790)):EndIf
EndIf

If Launch(67)=0 : midiOutShortMsg_(my_hMidiOut3,($006790)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($016890)) 
If Launch(68)=1 
  If LaunchJ(68)=0: midiOutShortMsg_(my_hMidiOut3,($016890)):EndIf
  If LaunchJ(68)=1: midiOutShortMsg_(my_hMidiOut3,($7F6890)):EndIf
EndIf

If Launch(68)=0 : midiOutShortMsg_(my_hMidiOut3,($006890)):EndIf
     
;midiOutShortMsg_(my_hMidiOut7,($127090))
If Launch(70)=1 
  If LaunchJ(70)=0: midiOutShortMsg_(my_hMidiOut3,($127090)):EndIf
  If LaunchJ(70)=1: midiOutShortMsg_(my_hMidiOut3,($7F7090)):EndIf
EndIf

If Launch(70)=0 : midiOutShortMsg_(my_hMidiOut3,($007090)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($127190))
If Launch(71)=1 
  If LaunchJ(71)=0: midiOutShortMsg_(my_hMidiOut3,($127190)):EndIf
  If LaunchJ(71)=1: midiOutShortMsg_(my_hMidiOut3,($7F7190)):EndIf
EndIf

If Launch(71)=0 : midiOutShortMsg_(my_hMidiOut3,($007190)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($127290))
If Launch(72)=1 
  If LaunchJ(72)=0: midiOutShortMsg_(my_hMidiOut3,($127290)):EndIf
  If LaunchJ(72)=1: midiOutShortMsg_(my_hMidiOut3,($7F7290)):EndIf
EndIf

If Launch(72)=0 : midiOutShortMsg_(my_hMidiOut3,($007290)):EndIf
;midiOutShortMsg_(my_hMidiOut7,($127390))
If Launch(73)=1 
  If LaunchJ(73)=0: midiOutShortMsg_(my_hMidiOut3,($127390)) :EndIf
  If LaunchJ(73)=1: midiOutShortMsg_(my_hMidiOut3,($7F7390)) :EndIf
EndIf

If Launch(73)=0 : midiOutShortMsg_(my_hMidiOut3,($007390)) :EndIf
;midiOutShortMsg_(my_hMidiOut7,($127490))
If Launch(74)=1 
  If LaunchJ(74)=0: midiOutShortMsg_(my_hMidiOut3,($127490)) :EndIf
  If LaunchJ(74)=1: midiOutShortMsg_(my_hMidiOut3,($7F7490)) :EndIf
EndIf

If Launch(74)=0 : midiOutShortMsg_(my_hMidiOut3,($007490)) :EndIf
;midiOutShortMsg_(my_hMidiOut7,($127590))
If Launch(75)=1 
  If LaunchJ(75)=0: midiOutShortMsg_(my_hMidiOut3,($127590)) :EndIf
  If LaunchJ(75)=1: midiOutShortMsg_(my_hMidiOut3,($7F7590)) :EndIf
EndIf

If Launch(75)=0 : midiOutShortMsg_(my_hMidiOut3,($007590)) :EndIf
;midiOutShortMsg_(my_hMidiOut7,($127690)) 
If Launch(76)=1 
  If LaunchJ(76)=0: midiOutShortMsg_(my_hMidiOut3,($127690)) :EndIf
  If LaunchJ(76)=1: midiOutShortMsg_(my_hMidiOut3,($7F7690)) :EndIf
EndIf

If Launch(76)=0 : midiOutShortMsg_(my_hMidiOut3,($007690)) :EndIf
;midiOutShortMsg_(my_hMidiOut7,($127790)) 
If Launch(77)=1
  If LaunchJ(77)=0: midiOutShortMsg_(my_hMidiOut3,($127790)) :EndIf
  If LaunchJ(77)=1: midiOutShortMsg_(my_hMidiOut3,($7F7790)) :EndIf
EndIf

If Launch(77)=0 : midiOutShortMsg_(my_hMidiOut3,($007790)) :EndIf
;midiOutShortMsg_(my_hMidiOut7,($127890))
If Launch(78)=1 
  If LaunchJ(78)=0: midiOutShortMsg_(my_hMidiOut3,($127890)) :EndIf
  If LaunchJ(78)=1: midiOutShortMsg_(my_hMidiOut3,($7F7890)) :EndIf
EndIf

If Launch(78)=0 : midiOutShortMsg_(my_hMidiOut3,($007890)) :EndIf



;=========================================================================================================================
;=========================================================================================================================
EndProcedure



CreateThread (@LaunchLed(),*bidon1)
; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 69
; FirstLine = 65
; Folding = -
; EnableXP
; EnableUnicode