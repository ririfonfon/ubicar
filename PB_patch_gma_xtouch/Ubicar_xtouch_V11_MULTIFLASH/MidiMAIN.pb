;=========================================================================================================================
;=========================================================================================================================
Global OsDetect    
Global check

check=0
OsDetect=0

OpenConsole ()

Select OSVersion()
    Case #PB_OS_Windows_95
      PrintN("OS Detect : Windows 95")
        OsDetect=1  
      
  Case #PB_OS_Windows_98
      PrintN("OS Detect : Windows 98")
        OsDetect=1
    
    Case #PB_OS_Windows_2000
      PrintN("OS Detect : Windows 2000")
        OsDetect=2  
    
    Case #PB_OS_Windows_XP
      PrintN("OS Detect : Windows XP")
         OsDetect=3   
    
    Case #PB_OS_Windows_Server_2003
      PrintN("OS Detect : Windows Server 2003")
      OsDetect=4 
      
    Case #PB_OS_Windows_Vista
      PrintN("OS Detect : Windows Vista")
      OsDetect=4
      
    Case #PB_OS_Windows_Server_2008
      PrintN("OS Detect : Windows Server 2008")
      OsDetect=4
      
    Case #PB_OS_Windows_Server_2008_R2
      PrintN("OS Detect : Windows Server 2008 R2")
      OsDetect=4
      
    Case #PB_OS_Windows_Server_2012
      PrintN("OS Detect : Windows Server 2012")
      OsDetect=4
      
      Case #PB_OS_Windows_Server_2012_R2
      PrintN("OS Detect : Windows Server 2012_R2")
      OsDetect=4
      
    Case #PB_OS_Windows_7
      PrintN("OS Detect : Windows 7")
        OsDetect=5
        
    Case #PB_OS_Windows_8
      PrintN("OSDetect : Windows 8")
      OsDetect=5  
      
       Case #PB_OS_Windows_8_1
      PrintN("OSDetect : Windows 8_1")
      OsDetect=5  
      
       Case #PB_OS_Windows_10
      PrintN("OSDetect : Windows 10")
      OsDetect=5 
      
      Case #PB_OS_Windows_Future
      PrintN("OS Detect : Windows future")
      OsDetect=5
        
      Default
      PrintN("OS Detect : NO detect a Default")    
        OsDetect=5
   
   
          
  EndSelect


;=========================================================================================================================
;=========================================================================================================================



; German forum: http://robsite.de/php/pureboard/viewtopic.php?t=2297&highlight=
; Author: NicTheQuick
; Date: 15. September 2003
; OS: Windows
; Demo: No


; MIDI-Connecter 
; by NicTheQuick 
;
; code modified by ManMartin to make the Behringer to MAonPC driver...
; code add by riri to make OSC to MAonPC driver

IncludeFile   "MIDI_MyVariables.pb"
IncludeFile   "MIDI_Faders.pb"
IncludeFile   "MIDI_Search_Register.pb"
IncludeFile   "MIDI_PulsarDespulsar.pb"



Dim Controller.s(127) 
Procedure InitController() 
  Shared Controller()
  
  Protected a.l 
  Restore ControllerNames 
  For a = 0 To 127 
    Read.s Controller(a) 
  Next 
EndProcedure
;---FIN de Procedure initController

;-----------------------------------
Procedure.s GetControllerName(Number.l) 
  Shared Controller()
  
  If Number >= 0 And Number <= 127 
    ProcedureReturn RSet(Str(Number), 3, "0") + " " + Controller(Number) 
  EndIf 
EndProcedure 
;---FIN de Procedure getControllername
;-----------------------------------

IncludeFile   "MidiRequester.pb"

;--------------- BCF 1

 Procedure MidiInProc(hMidiIn.l, wMsg.l, dwInstance.l, dwParam1.l, dwParam2.l) 
  Protected Status.l, OnOf.l, NoteNr.l, Velocity.l 
    midiin=1
  
    midiOutShortMsg_(my_hMidiOut2, dwParam1)
    midiOutShortMsg_(my_hMidiOut4, dwParam1)
  Debug " 1 midiout request 2 et 4 " + Hex(dwParam1)
  
   
  Select wMsg 
    Case #MM_MIM_OPEN 
      Debug "open" 
    
    Case #MM_MIM_CLOSE 
      Debug "close" 
      
    Case #MM_MIM_DATA 
      Status = dwParam1 & $FF 
      
      If Status < $F0 
        Select Status / 16 
          Case $8 ;note  off
            Debug "Note Off" 
            Debug "  Kanal: " + Hex(dwParam1 & $F) 
            Debug "  fonction: " + Hex(dwParam1  & $FF) 
            Debug "  Note: " + Hex((dwParam1 >> 8) & $FF) 
            Debug "  Velocity: " + Hex((dwParam1 >> 16) & $FF) 
            
;----- Added Note Off

            ;My procedure...
            If (dwParam1 & $F)  = #channel Or (dwParam1 & $F) = #channel2 Or (dwParam1 & $F) = #channel3 Or (dwParam1 & $F) = #channel1
                PulsarDespulsarTecla ((dwParam1 >> 8) & $FF, $00,dwParam1 & $F ); Always Off so $00 velocity
            EndIf
            
            ;--------note on
            Case $9 ;note on
            If dwParam1 & $FF0000 
              Debug "Note On "
            Else 
              Debug "Note Off "
            EndIf 
            Debug "  Kanal : " + Hex(dwParam1 & $F) 
            Debug "  fonction: " + Hex(dwParam1  & $FF) 
            Debug "  Note: " + Hex((dwParam1 >> 8) & $FF) 
            Debug "  Velocity: " + Hex((dwParam1 >> 16) & $FF)
            ;------note off 
            ;My procedure...
            If (dwParam1 & $F)  = #channel Or (dwParam1 & $F) = #channel2 Or (dwParam1 & $F) = #channel3 Or (dwParam1 & $F) = #channel1
              PulsarDespulsarTecla ((dwParam1 >> 8) & $FF, (dwParam1 >> 16) & $FF , dwParam1 & $F) 
              Debug "(dwParam1 & $F)  = #channel1 "  
            Debug "  dwParam1 >> 8: " + Hex((dwParam1 >> 8) & $FF) 
            Debug "  dwParam1 >> 16: " + Hex((dwParam1 >> 16) & $FF)
            Debug "  dwParam1 & $F : " + Hex(dwParam1 & $F)
            EndIf
            
            
            
            ;----> DEBUG  key aftertouch debug
            Case $A ;after touch
            Debug "Key Aftertouch" 
            Debug "  Kanal: " + Hex(dwParam1 & $F) 
            Debug "  fonction: " + Hex(dwParam1  & $FF) 
            Debug "  Note: " + Hex((dwParam1 >> 8) & $FF) 
            Debug "  Value: " + Hex((dwParam1 >> 16) & $FF) 
            
            
            ;----> DEBUG control change 
          Case $B ;control change
            Debug "Controller Change" 
            Debug "  Kanal: " + Hex(dwParam1 & $F) 
            Debug "  fonction: " + Hex(dwParam1  & $FF) 
            Debug "  Controller: " + GetControllerName((dwParam1 >> 8) & $FF) 
            Debug "  Wert: " + Hex((dwParam1 >> 16) & $FF)
            
          

                
            ;----> procedure midi in 1 Ecrit  faders et enc <------------- 
            ;My procedure...
            If (dwParam1 & $F)  = #channel
                  midiin=1
                  ;Faders
                  
                  WriteBehringerToMAonPC ((dwParam1 >> 8) & $FF, (dwParam1 >> 16) & $FF)
                  
                  
                  ;------------- proccess Encoders...
                  
                  
                  WriteEncodersToMAonPC  ((dwParam1 >> 8) & $FF, (dwParam1 >> 16) & $FF)
                  
                                    
                  Debug ";----> procedure midi in 1 Ecrit  faders et enc <------------- "
            EndIf                 
            
            ;----> DEBUG program change
          Case $C 
            Debug "Program Change" 
            Debug "  Kanal: " + Hex(dwParam1 & $F) 
            Debug "  fonction: " + Hex(dwParam1  & $FF) 
            Debug "  Instrument: " + Hex((dwParam1 >> 8 ) & $FF) 

            ;----> DEBUG  channel pressure 
          Case $D 
            Debug "Channel Pressure" 
            Debug "  Kanal: " + Hex(dwParam1 & $F) 
            Debug "  fonction: " + Hex(dwParam1  & $FF) 
            Debug "  Value: " + Hex((dwParam1 >> 8) & $FF) 
            ;----> DEBUG  pitch 
          Case $E 
            Debug "Pitch Wheel" 
            Debug "  Kanal: " + Hex(dwParam1 & $F) 
            Debug "  fonction: " + Hex(dwParam1  & $FF) 
            Debug "  Value: " + Hex((dwParam1 >> 16) & $FFFF) 
          Default 
            Debug Hex(Status) 
        EndSelect 
      EndIf 
    
    Case #MM_MIM_LONGDATA 
      Debug "Longdata: " + RSet(Hex(dwParam1), 2, "0") + RSet(Hex(dwParam2), 2, "0") 
      
    Case #MM_MIM_ERROR 
      Debug "Error: " + RSet(Hex(dwParam1), 2, "0") + RSet(Hex(dwParam2), 2, "0") 
    
    Case #MM_MIM_LONGERROR 
      Debug "LongError" 
    
    Default 
      Debug "??? default ??? de MidiMain.pb ???" 
  EndSelect 
EndProcedure




;------------------- BCF 2
Procedure MidiInProc2(hMidiIn2.l, wMsg2.l, dwInstance2.l, dwParam12.l, dwParam22.l) 
  Protected Status2.l, OnOf2.l, NoteNr2.l, Velocity2.l 
  
  midiin=2
  
  midiOutShortMsg_(my_hMidiOut, dwParam12)
  midiOutShortMsg_(my_hMidiOut4, dwParam12)
  Debug " 2 midiout request 1 et 4 " + Hex(dwParam12)
  
  
  Select wMsg2 
    Case #MM_MIM_OPEN 
      Debug "2 open" 
    
    Case #MM_MIM_CLOSE 
      Debug "2 close" 
      
    Case #MM_MIM_DATA 
      Status2 = dwParam12 & $FF 
      
      If Status2 < $F0 
        Select Status2 / 16 
          Case $8 
            Debug " 2 Note Off" 
            Debug " 2 Kanal: " + Hex(dwParam12 & $F) 
            Debug " 2 fonction: " + Hex(dwParam12  & $FF) 
            Debug " 2 Note: " + Hex((dwParam12 >> 8) & $FF) 
            Debug " 2 Velocity: " + Hex((dwParam12 >> 16) & $FF) 
            
;----- Added Note Off
             ;-------note off 
            ;My procedure...
            If (dwParam12 & $F)  = #channel Or (dwParam12 & $F) = #channel2 Or (dwParam12 & $F) = #channel3
                PulsarDespulsarTecla ((dwParam12 >> 8) & $FF, $00,dwParam12 & $F ); Always Off so $00 velocity
            EndIf
            
            ;----> DEBUG case $9 debug ???
            Case $9 
            If dwParam12 & $FF0000 
              Debug " 2 Note On "
            Else 
              Debug " 2 Note Off "
            EndIf 
            Debug " 2 Kanal : " + Hex(dwParam12 & $F) 
            Debug " 2 fonction: " + Hex(dwParam12  & $FF)
            Debug " 2 Note: " + Hex((dwParam12 >> 8) & $FF) 
            Debug " 2 Velocity: " + Hex((dwParam12 >> 16) & $FF)
            ;------note off 
            ;My procedure...
            If (dwParam12 & $F)  = #channel Or (dwParam12 & $F) = #channel2 Or (dwParam12 & $F) = #channel3
                PulsarDespulsarTecla ((dwParam12 >> 8) & $FF, (dwParam12 >> 16) & $FF , dwParam12 & $F) 
            EndIf
            
            
            
            ;----> DEBUG  key aftertouch debug
            Case $A
            Debug " 2 Key Aftertouch" 
            Debug " 2 Kanal: " + Hex(dwParam12 & $F) 
            Debug " 2 fonction: " + Hex(dwParam12  & $FF)
            Debug " 2 Note: " + Hex((dwParam12 >> 8) & $FF) 
            Debug " 2 Value: " + Hex((dwParam12 >> 16) & $FF) 
            ;----> DEBUG control change 
          Case $B 
            Debug " 2 Controller Change" 
            Debug " 2 Kanal: " + Hex(dwParam12 & $F) 
            Debug " 2 fonction: " + Hex(dwParam12  & $FF)
            Debug " 2 Controller: " + GetControllerName((dwParam12 >> 8) & $FF) 
            Debug " 2 Wert: " + Hex((dwParam12 >> 16) & $FF)
            
             
            ;----> procedure midi in 2 Ecrit  faders et enc <------------- 
            ;My procedure...
            If (dwParam12 & $F)  = #channel
                  midiin=2
                  ;Faders
                  WriteBehringerToMAonPC ((dwParam12 >> 8) & $FF, (dwParam12 >> 16) & $FF)
                  ;Encoders...
                  WriteEncodersToMAonPC  ((dwParam12 >> 8) & $FF, (dwParam12 >> 16) & $FF)
                  Debug ";----> procedure midi in 2 Ecrit  faders et enc <------------- "
            EndIf
           
            
          
            
            
            ;----> DEBUG program change
          Case $C 
            Debug " 2 Program Change" 
            Debug " 2 Kanal: " + Hex(dwParam12 & $F) 
            Debug " 2 fonction: " + Hex(dwParam12  & $FF)
            Debug " 2 Instrument: " + Hex((dwParam12 >> 8 ) & $FF) 

            ;----> DEBUG  channel pressure 
          Case $D 
            Debug " 2 Channel Pressure" 
            Debug " 2 Kanal: " + Hex(dwParam12 & $F) 
            Debug " 2 fonction: " + Hex(dwParam12  & $FF)
            Debug " 2 Value: " + Hex((dwParam12 >> 8) & $FF) 
            ;----> DEBUG  pitch 
          Case $E 
            Debug " 2 Pitch Wheel" 
            Debug " 2 Kanal: " + Hex(dwParam12 & $F) 
            Debug " 2 fonction: " + Hex(dwParam12  & $FF)
            Debug " 2 Value: " + Hex((dwParam12 >> 16) & $FFFF) 
          Default 
            Debug Hex(Status) 
        EndSelect 
      EndIf 
    
    Case #MM_MIM_LONGDATA 
      Debug "Longdata2: " + RSet(Hex(dwParam12), 2, "0") + RSet(Hex(dwParam22), 2, "0") 
      
    Case #MM_MIM_ERROR 
      Debug "Error2: " + RSet(Hex(dwParam12), 2, "0") + RSet(Hex(dwParam22), 2, "0") 
    
    Case #MM_MIM_LONGERROR 
      Debug "LongError2" 
    
    Default 
      Debug "??? default2 ??? de MidiMain.pb ???" 
  EndSelect 
EndProcedure

;------------- LAUNCH PAD


Procedure MidiInProc3(hMidiIn3.l, wMsg3.l, dwInstance3.l, dwParam13.l, dwParam23.l) 
  Protected Status3.l, OnOf3.l, NoteNr3.l, Velocity3.l 
  
  midiin=5
  ;midiOutShortMsg_(my_hMidiOut2, dwParam13) : Debug " 3 midiout request 2 " + Hex (dwParam13)
  Select wMsg3 
    
    Case #MM_MIM_OPEN 
      Debug "3 open" 
    
    Case #MM_MIM_CLOSE 
      Debug "3 close" 
      
    Case #MM_MIM_DATA
    
    
    
     
      Status3 = dwParam13 & $FF 
      
      If Status3 < $F0 
        
        Select Status3 / 16 
          Case $8 
            Debug " 3 Note Off" 
            Debug " 3 Kanal: " + Hex(dwParam13 & $F) 
            Debug " 3 fonction: " + Hex(dwParam13  & $FF) 
            Debug " 3 Note: " + Hex((dwParam13 >> 8) & $FF) 
            Debug " 3 Velocity: " + Hex((dwParam13 >> 16) & $FF) 
            
;----- Added Note Off
             ;-------note off 
            ;My procedure...
            ;If (dwParam13 & $F)  = #channel1 
            ;    PulsarDespulsarTecla ((dwParam13 >> 8) & $FF, $00 , dwParam13 & $F ); Always Off so $00 velocity
            ;EndIf
            
            ;----> DEBUG case $9 debug ???
            Case $9 
            If dwParam13 & $FF0000 
              Debug " 3 Note On "
            Else 
              Debug "3 Note Off "
            EndIf 
            Debug " 3 Kanal : " + Hex(dwParam13 & $F) 
            Debug " 3 fonction: " + Hex(dwParam13  & $FF)
            Debug " 3 Note: " + Hex((dwParam13 >> 8) & $FF) 
            Debug " 3 Velocity: " + Hex((dwParam13 >> 16) & $FF)
            
            If dwParam13 = $7F0090  
            Debug " dwparam13 = " + Hex(dwParam13)
            PulsarDespulsarTecla ( $9 , $7F , dwParam13 & $F):Debug "NOTE 0 ON":EndIf
            
            If dwParam13 < $190  
            Debug " dwparam13 = " + Hex(dwParam13)
            PulsarDespulsarTecla ( $9 , $00 , dwParam13 & $F):Debug "NOTE 0 OFF":EndIf  
            
            
            
            ;------note off 
            ;My procedure...

            
                     
            If dwParam13 >= $190
            Debug " dwparam13 = " + Hex(dwParam13)
               PulsarDespulsarTecla ((dwParam13 >> 8) & $FF , (dwParam13 >> 16) & $FF , dwParam13 & $F) 
            EndIf
            



            ;----> DEBUG  key aftertouch debug
            Case $A
            Debug " 3 Key Aftertouch" 
            Debug " 3 Kanal: " + Hex(dwParam13 & $F) 
            Debug " 3 fonction: " + Hex(dwParam13  & $FF)
            Debug " 3 Note: " + Hex((dwParam13 >> 8) & $FF) 
            Debug " 3 Value: " + Hex((dwParam13 >> 16) & $FF) 
     
     
     
            ;----> DEBUG control change 
          Case $B 
            Debug " 3 Controller Change" 
            Debug " 3 Kanal: " + Hex(dwParam13 & $F) 
            Debug " 3 fonction: " + Hex(dwParam13  & $FF)
            Debug " 3 Controller: " + GetControllerName((dwParam13 >> 8) & $FF) 
            Debug " 3 Wert: " + Hex((dwParam13 >> 16) & $FF)
            ;-------- TOUCH DU HAUT CONTROL CHANGE LAUNCHPAD

 
            If dwParam13  & $FF = $B0
                Debug "CONTROL CHANGE PASSE = $B0 OK "
                If (dwParam13 >> 8) & $FF >= $68
                    Debug " PULSARTECLA = " + Hex(((dwParam13 >> 8) & $FF )+ $11) + " , " + Hex((dwParam13 >> 16) & $FF) + "," + Hex ($00)
                    PulsarDespulsarTecla (((dwParam13 >> 8) & $FF ) + $11 , (dwParam13 >> 16) & $FF , $00)
                EndIf    
            EndIf    
     
     
     
     
     
     
            
             
                
            
            ;----> DEBUG program change
          Case $C 
            Debug " 3 Program Change" 
            Debug " 3 Kanal: " + Hex(dwParam13 & $F) 
            Debug " 3 fonction: " + Hex(dwParam13  & $FF)
            Debug " 3 Instrument: " + Hex((dwParam13 >> 8 ) & $FF) 








            ;----> DEBUG  channel pressure 
          Case $D 
            Debug " 3 Channel Pressure" 
            Debug " 3 Kanal: " + Hex(dwParam13 & $F) 
            Debug " 3 fonction: " + Hex(dwParam13  & $FF)
            Debug " 3 Value: " + Hex((dwParam13 >> 8) & $FF) 
           


           
        EndSelect 
      EndIf 
    
    Case #MM_MIM_LONGDATA 
      Debug "Longdata3: " + RSet(Hex(dwParam13), 2, "0") + RSet(Hex(dwParam23), 2, "0") 
      
    Case #MM_MIM_ERROR 
      Debug "Error3: " + RSet(Hex(dwParam13), 2, "0") + RSet(Hex(dwParam23), 2, "0") 
    
    Case #MM_MIM_LONGERROR 
      Debug "LongError3" 
    
    Default 
      Debug "??? default3 ??? de MidiMain.pb ???" 
  EndSelect 
EndProcedure




;-------------------- O S C

Procedure MidiInProc4(hMidiIn4.l, wMsg4.l, dwInstance4.l, dwParam14.l, dwParam24.l) 
  Protected Status4.l, OnOf4.l, NoteNr4.l, Velocity4.l 
  
  midiin=6
   midiOutShortMsg_(my_hMidiOut, dwParam14)
   midiOutShortMsg_(my_hMidiOut2, dwParam14)
  Debug " 4 midiout request 1 et 2 " + Hex(dwParam12)
  
  
  
  Select wMsg4 
    Case #MM_MIM_OPEN 
      Debug "4 open" 
    
    Case #MM_MIM_CLOSE 
      Debug "4 close" 
      
    Case #MM_MIM_DATA 
      Status4 = dwParam14 & $FF 
      
      If Status4 < $F0 
        Select Status4 / 16 
          Case $8 
            Debug " 4 Note Off" 
            Debug " 4 Kanal: " + Hex(dwParam14 & $F) 
            Debug " 4 fonction: " + Hex(dwParam14  & $FF) 
            Debug " 4 Note: " + Hex((dwParam14 >> 8) & $FF) 
            Debug " 4 Velocity: " + Hex((dwParam14 >> 16) & $FF) 
            
;----- Added Note Off
             ;-------note off 
            ;My procedure...
            If (dwParam14 & $F)  = #channel Or (dwParam14 & $F) = #channel2 Or (dwParam14 & $F) = #channel3
                PulsarDespulsarTecla ((dwParam14 >> 8) & $FF, $00,dwParam14 & $F ); Always Off so $00 velocity
            EndIf
            
            ;----> DEBUG case $9 debug ???
            Case $9 
            If dwParam14 & $FF0000 
              Debug "4 Note On "
            Else 
              Debug "4 Note Off "
            EndIf 
            Debug " 4 Kanal : " + Hex(dwParam14 & $F) 
            Debug " 4 fonction: " + Hex(dwParam14  & $FF)
            Debug " 4 Note: " + Hex((dwParam14 >> 8) & $FF) 
            Debug " 4 Velocity: " + Hex((dwParam14 >> 16) & $FF)
            ;------note off 
            
            
            ;My procedure...
            If (dwParam14 & $F)  = #channel Or (dwParam14 & $F) = #channel2 Or (dwParam14 & $F) = #channel3
                PulsarDespulsarTecla ((dwParam14 >> 8) & $FF, (dwParam14 >> 16) & $FF , dwParam14 & $F) 
            EndIf
            
            
            
            ;----> DEBUG  key aftertouch debug            
          Case $A
            Debug " 4 Key Aftertouch" 
            Debug " 4 Kanal: " + Hex(dwParam14 & $F) 
            Debug " 4 fonction: " + Hex(dwParam14  & $FF)
            Debug " 4 Note: " + Hex((dwParam14 >> 8) & $FF) 
            Debug " 4 Value: " + Hex((dwParam14 >> 16) & $FF) 
            ;----> DEBUG control change 
          Case $B 
            Debug " 4 Controller Change" 
            Debug " 4 Kanal: " + Hex(dwParam14 & $F) 
            Debug " 4 fonction: " + Hex(dwParam14  & $FF)
            Debug " 4 Controller: " + GetControllerName((dwParam14 >> 8) & $FF) 
            Debug " 4 CController: " + Hex((dwParam14 >> 8) & $FF)
            Debug " 4 Wert: " + Hex((dwParam14 >> 16) & $FF)
            
          ;----> procedure midi in 4 Ecrit  faders et enc <------------- 
            ;My procedure...
            If (dwParam14 & $F)  = #channel
                  midiin=4
                  ;Faders
                  WriteBehringerToMAonPC ((dwParam14 >> 8) & $FF, (dwParam14 >> 16) & $FF)
                  Debug ";----> procedure midi in 4 Ecrit  faders <------------- "
                  
                  
                  
                  
                  ;Encoders...
                  
                  If  NV = 1 And ((dwParam14 >> 8) & $FF) = $1E 
                    
                    WriteEncodersToMAonPC  (((dwParam14 >> 8) & $FF) + $A , (dwParam14 >> 16) & $FF)
                   Debug ";---------- +$A NV ----------------"
                 
                 EndIf
                 
                 If  NV = 0 And ((dwParam14 >> 8) & $FF) = $1E 
                 
                  WriteEncodersToMAonPC  ((dwParam14 >> 8) & $FF, (dwParam14 >> 16) & $FF)
                  Debug ";----> NV procedure midi in 4 Ecrit  enc <------------- "
                 
                EndIf
                
                 
                 
                 If  VL = 1 And ((dwParam14 >> 8) & $FF) < $28 And ((dwParam14 >> 8) & $FF) > $20
                    
                    WriteEncodersToMAonPC  (((dwParam14 >> 8) & $FF) + $A , (dwParam14 >> 16) & $FF)
                   Debug ";---------- +$A VL----------------"
                 
                 EndIf
                 
                 
                 If  VL = 0 And ((dwParam14 >> 8) & $FF) < $28 And ((dwParam14 >> 8) & $FF) > $20
                   
                  WriteEncodersToMAonPC  ((dwParam14 >> 8) & $FF, (dwParam14 >> 16) & $FF)
                  Debug ";----> VL procedure midi in 4 Ecrit  enc <------------- "
                 
                EndIf
                
                  
                  
            EndIf   
            
            
            
            ;----> DEBUG program change
          Case $C 
            Debug " 4 Program Change" 
            Debug " 4 Kanal: " + Hex(dwParam14 & $F) 
            Debug " 4 fonction: " + Hex(dwParam14  & $FF)
            Debug " 4 Instrument: " + Hex((dwParam14 >> 8 ) & $FF) 

            ;----> DEBUG  channel pressure 
          Case $D 
            Debug " 4 Channel Pressure" 
            Debug " 4 Kanal: " + Hex(dwParam14 & $F) 
            Debug " 4 fonction: " + Hex(dwParam14  & $FF)
            Debug " 4 Value: " + Hex((dwParam14 >> 8) & $FF) 
           
        EndSelect 
      EndIf 
    
    Case #MM_MIM_LONGDATA 
      Debug "Longdata4: " + RSet(Hex(dwParam14), 2, "0") + RSet(Hex(dwParam24), 2, "0") 
      
    Case #MM_MIM_ERROR 
      Debug "Error4: "+ RSet(Hex(dwParam14), 2, "0") + RSet(Hex(dwParam24), 2, "0") 
    
    Case #MM_MIM_LONGERROR 
      Debug "LongError4" 
    
    Default 
      Debug "??? default4 ??? de MidiMain.pb ???" 
  EndSelect 
EndProcedure


;---------------------- I O GMA

Procedure MidiInProc5(hMidiIn5.l, wMsg5.l, dwInstance5.l, dwParam15.l, dwParam25.l) 
  Protected Status5.l, OnOf5.l, NoteNr5.l, Velocity5.l 
  
  midiin=7


  
  
  
  
  
  Select wMsg5 
    Case #MM_MIM_OPEN 
      Debug "5 open" 

    
    
    
    Case #MM_MIM_CLOSE 
      Debug "5 close" 
      
    Case #MM_MIM_DATA 
      Status5 = dwParam15 & $FF 
      
      If Status5 < $F0 
        Select Status5 / 16 
          Case $8 
            Debug " 5 Note Off" 
            Debug " 5 Kanal: " + Hex(dwParam15 & $F) 
            Debug " 5 fonction: " + Hex(dwParam15  & $FF) 
            Debug " 5 Note: " + Hex((dwParam15 >> 8) & $FF) 
            Debug " 5 Velocity: " + Hex((dwParam15 >> 16) & $FF) 
            
;----- Added Note Off
             ;-------note off 
            ;My procedure...
            If (dwParam15 & $F)  = #channel Or (dwParam15 & $F) = #channel2 Or (dwParam15 & $F) = #channel3
                PulsarDespulsarTecla ((dwParam15 >> 8) & $FF, $00,dwParam15 & $F ); Always Off so $00 velocity
            EndIf
            
            ;----> DEBUG case $9 debug ???
            Case $9 
            If dwParam15 & $FF0000 
              Debug "5 Note On "
            Else 
              Debug "5 Note Off "
            EndIf 
            Debug " 5 Kanal : " + Hex(dwParam15 & $F) 
            Debug " 5 fonction: " + Hex(dwParam15  & $FF)
            Debug " 5 Note: " + Hex((dwParam15 >> 8) & $FF) 
            Debug " 5 Velocity: " + Hex((dwParam15 >> 16) & $FF)
            ;------note off 
            ;My procedure...
            If (dwParam15 & $F)  = #channel Or (dwParam15 & $F) = #channel2 Or (dwParam15 & $F) = #channel3 Or (dwParam15 & $F) = #channel1
                PulsarDespulsarTecla ((dwParam15 >> 8) & $FF, (dwParam15 >> 16) & $FF , dwParam15 & $F) 
            EndIf


            
            
            
            
            ;----> DEBUG  key aftertouch debug
            Case $A
            Debug " 5 Key Aftertouch" 
            Debug " 5 Kanal: " + Hex(dwParam15 & $F) 
            Debug " 5 fonction: " + Hex(dwParam15  & $FF)
            Debug " 5 Note: " + Hex((dwParam15 >> 8) & $FF) 
            Debug " 5 Value: " + Hex((dwParam15 >> 16) & $FF) 
            ;----> DEBUG control change 
          Case $B 
            Debug " 5 Controller Change" 
            Debug " 5 Kanal: " + Hex(dwParam15 & $F) 
            Debug " 5 fonction: " + Hex(dwParam15  & $FF)
            Debug " 5 Controller: " + GetControllerName((dwParam15 >> 8) & $FF) 
            Debug " 5 Wert: " + Hex((dwParam15 >> 16) & $FF)
            
             
            
            
            
            ;----> DEBUG program change
          Case $C 
            Debug " 5 Program Change" 
            Debug " 5 Kanal: " + Hex(dwParam15 & $F) 
            Debug " 5 fonction: " + Hex(dwParam15  & $FF)
            Debug " 5 Instrument: " + Hex((dwParam15 >> 8 ) & $FF) 

            ;----> DEBUG  channel pressure 
          Case $D 
            Debug " 5 Channel Pressure" 
            Debug " 5 Kanal: " + Hex(dwParam15 & $F) 
            Debug " 5 fonction: " + Hex(dwParam15  & $FF)
            Debug " 5 Value: " + Hex((dwParam15 >> 8) & $FF) 
           
        EndSelect 
      EndIf 
    
    Case #MM_MIM_LONGDATA 
      Debug "Longdata5: " + RSet(Hex(dwParam15), 2, "0") + RSet(Hex(dwParam25), 2, "0") 
      
    Case #MM_MIM_ERROR 
      Debug "Error5: "+ RSet(Hex(dwParam15), 2, "0") + RSet(Hex(dwParam25), 2, "0") 
    
    Case #MM_MIM_LONGERROR 
      Debug "LongError5" 
    
    Default 
      Debug "??? default5 ??? de MidiMain.pb ???" 
  EndSelect 
EndProcedure

;------------------------ KEY DE WILL

Procedure MidiInProc6(hMidiIn6.l, wMsg6.l, dwInstance6.l, dwParam16.l, dwParam26.l) 
  Protected Status6.l, OnOf6.l, NoteNr6.l, Velocity6.l 
  
  midiin=8


  
  
  
  
  
  Select wMsg6 
    Case #MM_MIM_OPEN 
      Debug "6 open" 

    
    
    
    Case #MM_MIM_CLOSE 
      Debug "6 close" 
      
    Case #MM_MIM_DATA 
      Status6 = dwParam16 & $FF 
      
      If Status6 < $F0 
        Select Status6 / 16 
          Case $8 
            Debug " 6 Note Off" 
            Debug " 6 Kanal: " + Hex(dwParam16 & $F) 
            Debug " 6 fonction: " + Hex(dwParam16  & $FF) 
            Debug " 6 Note: " + Hex((dwParam16 >> 8) & $FF) 
            Debug " 6 Velocity: " + Hex((dwParam16 >> 16) & $FF) 
            
;----- Added Note Off
             ;-------note off 
            ;My procedure...
            If (dwParam16 & $F)  = #channel4 
                PulsarDespulsarTecla ((dwParam16 >> 8) & $FF, $00,dwParam16 & $F ); Always Off so $00 velocity
            EndIf
            
            ;----> DEBUG case $9 debug ???
            Case $9 
            If dwParam16 & $FF0000 
              Debug "6 Note On "
            Else 
              Debug "6 Note Off "
            EndIf 
            Debug " 6 Kanal : " + Hex(dwParam16 & $F) 
            Debug " 6 fonction: " + Hex(dwParam16  & $FF)
            Debug " 6 Note: " + Hex((dwParam16 >> 8) & $FF) 
            Debug " 6 Velocity: " + Hex((dwParam16 >> 16) & $FF)
            ;------note off 
            ;My procedure...
            If (dwParam16 & $F)  = #channel4 
                PulsarDespulsarTecla ((dwParam16 >> 8) & $FF, (dwParam16 >> 16) & $FF , dwParam16 & $F) 
            EndIf


            
            
            
            
            ;----> DEBUG  key aftertouch debug
            Case $A
            Debug " 6 Key Aftertouch" 
            Debug " 6 Kanal: " + Hex(dwParam16 & $F) 
            Debug " 6 fonction: " + Hex(dwParam16  & $FF)
            Debug " 6 Note: " + Hex((dwParam16 >> 8) & $FF) 
            Debug " 6 Value: " + Hex((dwParam16 >> 16) & $FF) 
            ;----> DEBUG control change 
          Case $B 
            Debug " 6 Controller Change" 
            Debug " 6 Kanal: " + Hex(dwParam16 & $F) 
            Debug " 6 fonction: " + Hex(dwParam16  & $FF)
            Debug " 6 Controller: " + GetControllerName((dwParam16 >> 8) & $FF) 
            Debug " 6 Wert: " + Hex((dwParam16 >> 16) & $FF)
            
             
            
            
            
            ;----> DEBUG program change
          Case $C 
            Debug " 6 Program Change" 
            Debug " 6 Kanal: " + Hex(dwParam16 & $F) 
            Debug " 6 fonction: " + Hex(dwParam16  & $FF)
            Debug " 6 Instrument: " + Hex((dwParam16 >> 8 ) & $FF) 

            ;----> DEBUG  channel pressure 
          Case $D 
            Debug " 6 Channel Pressure" 
            Debug " 6 Kanal: " + Hex(dwParam16 & $F) 
            Debug " 6 fonction: " + Hex(dwParam16  & $FF)
            Debug " 6 Value: " + Hex((dwParam16 >> 8) & $FF) 
           
        EndSelect 
      EndIf 
    
    Case #MM_MIM_LONGDATA 
      Debug "Longdata6: " + RSet(Hex(dwParam16), 2, "0") + RSet(Hex(dwParam26), 2, "0") 
      
    Case #MM_MIM_ERROR 
      Debug "Error6: "+ RSet(Hex(dwParam16), 2, "0") + RSet(Hex(dwParam26), 2, "0") 
    
    Case #MM_MIM_LONGERROR 
      Debug "LongError6" 
    
    Default 
      Debug "??? default6 ??? de MidiMain.pb ???" 
  EndSelect 
EndProcedure


;-------------------------
;---FIN procedure midi in
;-------------------------


;--- MAINPROGRAM 

;-- def des controllers
InitController() 

;mis cosas
Init_Arrays()
NavDirection  = 0  ;It could be 0 or 4 (0= updown 4=leftright) We test it into note 71
Level_Incr    = 1   ;used to go faster in Level Encoder
Increm = 1
ScreenNum = 1

;=======================
;---  Look For the Window...
If WinFind() = #False : Goto EndProgram2 :EndIf

;=======================
;--- Search the memory values
If #ShowMsgBox : PrintN ("MULTIMIDI Setting the correct data... This process can take about 2 minutes.") :EndIf

If SearchMemPosition() <> 0  
      FaderAddress = PtoEncontrado - $15E4
      EncoderAddress = PtoEncontrado - $E6
      KeyAddress = PtoEncontrado - $10F
      LabelAddress = PtoEncontrado - $49ED27BC
      LedAddress= PtoEncontrado - $1809
      
      If #ShowMsgBox 
       PrintN ("MULTIMIDI Register Search finished   Value = " + Hex (PtoEncontrado))
       PrintN ("  Faders = "+Hex(FaderAddress)) 
       PrintN ("  Encoders = "+Hex(EncoderAddress))
       PrintN ("  KeyAddress = "+Hex(KeyAddress)) 
       PrintN ("  LabelAddress = "+Hex(LabelAddress)) 
       PrintN ("  LedAddress   = "+Hex(LedAddress))
       PrintN("Appuyez sur [Entree] pour Commencer   et   BON SHOW ")
    Input()
    CloseConsole()

     EndIf

Else ;PtoEncontrado = 0
  PrintN ("MULTIMIDI data can not be obtained! Sorry, impossible To set the correct Data. Maybe the Next time...")
  CloseConsole ()
      Goto EndProgram2       
EndIf

;------------------------------------------------
;---- OK here we go...
;------------------------------------------------------------------------

Global OutDevice.l 
Global InDevice.l 
Global OutDevice2.l
Global InDevice2.l
Global OutDevice3.l
Global InDevice3.l
Global OutDevice4.l
Global InDevice4.l
Global OutDevice5.l
Global InDevice5.l
Global OutDevice6.l
Global InDevice6.l

MIDIResult.l = MIDIRequester(@OutDevice,@InDevice,@InDevice2,@OutDevice2,@InDevice3,@OutDevice3,@InDevice4,@OutDevice4,@InDevice5,@OutDevice5,@InDevice6,@OutDevice6)



If MIDIResult & #MIDIRequ_InSet 
  hMidiIn.l 
  If midiInOpen_(@hMidiIn, InDevice, @MidiInProc(), 0, #CALLBACK_FUNCTION) = #MMSYSERR_NOERROR 
    Debug "OPEN: MidiIn" 
    If midiInStart_(hMidiIn) = #MMSYSERR_NOERROR 
      Debug "START: MidiIn= "  + Str(hMidiIn)   
    EndIf 
  EndIf 
EndIf 

If MIDIResult & #MIDIRequ_InSet2 
  hMidiIn2.l 
  If midiInOpen_(@hMidiIn2, InDevice2, @MidiInProc2(), 0, #CALLBACK_FUNCTION) = #MMSYSERR_NOERROR 
    Debug "OPEN: MidiIn2" 
    If midiInStart_(hMidiIn2) = #MMSYSERR_NOERROR 
    Debug "START: MidiIn2= "  + Str(hMidiIn2) 
    EndIf 
  EndIf 
EndIf

If MIDIResult & #MIDIRequ_InSet3 
  hMidiIn3.l 
  If midiInOpen_(@hMidiIn3, InDevice3, @MidiInProc3(), 0, #CALLBACK_FUNCTION) = #MMSYSERR_NOERROR 
    Debug "OPEN: MidiIn3" 
    If midiInStart_(hMidiIn3) = #MMSYSERR_NOERROR 
      Debug "START: MidiIn3= "  + Str(hMidiIn3) 
    EndIf 
  EndIf 
EndIf

If MIDIResult & #MIDIRequ_InSet4 
  hMidiIn4.l 
  If midiInOpen_(@hMidiIn4, InDevice4, @MidiInProc4(), 0, #CALLBACK_FUNCTION) = #MMSYSERR_NOERROR 
    Debug "OPEN: MidiIn4" 
    If midiInStart_(hMidiIn4) = #MMSYSERR_NOERROR 
      Debug "START: MidiIn4= "  + Str(hMidiIn4) 
    EndIf 
  EndIf 
EndIf

If MIDIResult & #MIDIRequ_InSet5 
  hMidiIn5.l 
  If midiInOpen_(@hMidiIn5, InDevice5, @MidiInProc5(), 0, #CALLBACK_FUNCTION) = #MMSYSERR_NOERROR 
    Debug "OPEN: MidiIn5" 
    If midiInStart_(hMidiIn5) = #MMSYSERR_NOERROR 
      Debug "START: MidiIn5= "  + Str(hMidiIn5) 
    EndIf 
  EndIf 
EndIf

If MIDIResult & #MIDIRequ_InSet6 
  hMidiIn6.l 
  If midiInOpen_(@hMidiIn6, InDevice6, @MidiInProc6(), 0, #CALLBACK_FUNCTION) = #MMSYSERR_NOERROR 
    Debug "OPEN: MidiIn6" 
    If midiInStart_(hMidiIn6) = #MMSYSERR_NOERROR 
      Debug "START: MidiIn6= "  + Str(hMidiIn6) 
    EndIf 
  EndIf 
EndIf

If MIDIResult & #MIDIRequ_OutSet 
  hMidiOut.l 
  If midiOutOpen_(@hMidiOut, OutDevice, 0, 0, 0) = 0 
    Debug "OPEN: MidiOut= "  + Hex(hMidiOut)
  EndIf 
EndIf

If MIDIResult & #MIDIRequ_OutSet2 
  hMidiOut2.l 
  If midiOutOpen_(@hMidiOut2, OutDevice2, 0, 0, 0) = 0 
    Debug "OPEN: MidiOut2 = "  + Hex(hMidiOut2)
  EndIf 
EndIf

If MIDIResult & #MIDIRequ_OutSet3 
  hMidiOut3.l 
  If midiOutOpen_(@hMidiOut3, OutDevice3, 0, 0, 0) = 0 
    Debug "OPEN: MidiOut3 = "  + Hex(hMidiOut3)
  EndIf  
EndIf 

If MIDIResult & #MIDIRequ_OutSet4 
  hMidiOut4.l 
  If midiOutOpen_(@hMidiOut4, OutDevice4, 0, 0, 0) = 0 
    Debug "OPEN: MidiOut4 = "  + Hex(hMidiOut4)
  EndIf  
EndIf 

If MIDIResult & #MIDIRequ_OutSet5 
  hMidiOut5.l 
  If midiOutOpen_(@hMidiOut5, OutDevice5, 0, 0, 0) = 0 
    Debug "OPEN: MidiOut5 = "  + Hex(hMidiOut5)
  EndIf  
EndIf 

If MIDIResult & #MIDIRequ_OutSet6 
  hMidiOut6.l 
  If midiOutOpen_(@hMidiOut6, OutDevice6, 0, 0, 0) = 0 
    Debug "OPEN: MidiOut6 = "  + Hex(hMidiOut6)
  EndIf  
EndIf 

  If hMidiIn And hMidiOut 
  my_hMidiOut = hMidiOut
  my_hMidiOut2 = hMidiOut2
  my_hMidiOut3 = hMidiOut3
  my_hMidiOut4 = hMidiOut4
  my_hMidiOut5 = hMidiOut5
  my_hMidiOut6 = hMidiOut6
  
  Debug "my_ = h"
  
  ;With those lines we enable Behringer In<->Out loop
  ;If midiConnect_(hMidiIn, hMidiOut, 0) = 0 
  ;EndIf 
EndIf

IncludeFile "MIDI_LED.pb"
IncludeFile "MIDI_LAUNCH.pb"


;=========================================================================================================================
;=========================================================================================================================


;Create if any midi out 
;If my_hMidiOut = 0 : Debug "err midi out" : Goto EndProgram : EndIf


;=========================================================================================================================
;=========================================================================================================================


AuxIndex.b
Salir.b
AuxVal.w  ;We need this dummie value cause byte is signed when we store it into another variable.

Salir = #False 

;=========================================================================================================================
;=========================================================================================================================


;-------------------MAIN LOOP              
Repeat

;----<<<>>>>Reads the fader values inside MAonPC

    If ReadProcessMemory_(pHandle, FaderAddress, @MAonPC_FaderValues(0), 23, 0) = 0  ;read faders
      ;mostrar error
      Debug " error pHandle ="+pHandle
      Debug "FaderAddress ="+FaderAddress
      Debug "@MAonPC_FaderValues(0) "+@MAonPC_FaderValues(0)
      
      
      Debug " + Error reading memory inside ReadMAonPCFaders_Timer"+" pHandle= "+Hex(pHandle)
      Salir = #True
    Else
        ;Compare and show if different
        For AuxIndex = 0 To 22
            ;Compare
            If MAonPC_FaderValues(AuxIndex) <> Behringer_FaderValues(AuxIndex) 
                ;Copy values
                Behringer_FaderValues(AuxIndex) = MAonPC_FaderValues(AuxIndex)
                ;send data to Behringer unit WE MUST TO PROCESS BACK 255 TO 127!!
                AuxVal = MAonPC_FaderValues(AuxIndex) & $FF ; to convert the signed byte into unsigned byte!
                AuxVal = AuxVal/2
                midimsg = $B0 + ((AuxIndex + 1) * $100) + (AuxVal * $10000) + #channel
               
                Debug "Le Message Midi est  " + Hex(midimsg) + " expédié vers handle " + Hex(my_hMidiOut)
                ;Send!
              
                
                midiOutShortMsg_(my_hMidiOut, midimsg)
                midiOutShortMsg_(my_hMidiOut2, midimsg)
                midiOutShortMsg_(my_hMidiOut4, midimsg)

                ;Debug " expédié vers MIDI "+StrU(MAonPC_FaderValues(AuxIndex),0) +" sont "+Str(AuxVal)+ " au Fader num " + Str(AuxIndex+1)
                Debug " expédié vers MIDI "+MAonPC_FaderValues(AuxIndex) +" sont "+AuxVal+ " au Fader num " + AuxIndex+1
                ;Else
                ;----------Debug "Faders " + Str(AuxIndex) + " are equal."
            EndIf
        Next AuxIndex
        
   EndIf
;---- read press key
 
      If WriteProcessMemory_(pHandle, KeyAddress + Key, @KeyValue, 1, 0) =0;
           Debug "Gma dit ca "+" pHandle= "+Hex(pHandle) + " KeyAddress + Key= " +Hex(KeyAddress + Key)+" @KeyValue= "+Hex(@KeyValue)
      EndIf
 
 
      readled1(*bidon)
      readled2(*bidon)
      readled3(*bidon)
      readled4(*bidon)
      readled5(*bidon)
      readled6(*bidon)
      readled7(*bidon)
      readled8(*bidon)
      readled9(*bidon)
      readled10(*bidon)
      readled11(*bidon)
      readled12(*bidon)
      readled13(*bidon)
      readled14(*bidon)
      readled15(*bidon)
      readled16(*bidon)
      readled17(*bidon)
      readled18(*bidon)
      readled19(*bidon)
      readled20(*bidon)
      readled21(*bidon)
      readled22(*bidon)
      readled23(*bidon)
      readled24(*bidon)
      readled25(*bidon)
      readled26(*bidon)
      readled28(*bidon)
      readled29(*bidon)
      
      
      LaunchLed(*bidon1)
      
 
 
 
 


Sleep_(#Interval)
Until Salir = #True

;=========================================================================================================================
;=========================================================================================================================



MessageRequester ("MULTIMIDI for MAonPC  by Riri", "Sorry, but now we quit")



;=========================================================================================================================
;=========================================================================================================================
;============================================== fader 0 ==================================================================
;=========================================================================================================================
;=========================================================================================================================


 For AuxIndex = 0 To 22
            
           
                ;Copy values
  ; Behringer_FaderValues(AuxIndex) = 0 
  ; MAonPC_FaderValues(AuxIndex) = 0
                ;send data to Behringer unit WE MUST TO PROCESS BACK 255 TO 127!!
                AuxVal = 0 & $FF ; to convert the signed byte into unsigned byte!
               ; AuxVal = AuxVal/2
                midimsg = $B0 + ((AuxIndex + 1) * $100) + (AuxVal * $10000) + #channel
               
               
              
                midiOutShortMsg_(my_hMidiOut, midimsg)
                midiOutShortMsg_(my_hMidiOut2, midimsg)
                midiOutShortMsg_(my_hMidiOut4, midimsg)

                Debug " ***fader 0*** expédié vers MIDI " + " sont "+ Str(AuxVal) + " au Fader num " + Str(AuxIndex+1)
               
                

        Next AuxIndex


;=========================================================================================================================
;=========================================================================================================================
;=================================== LAUNCH PAD COLOR 0 ==================================================================
;=========================================================================================================================
;=========================================================================================================================


midiOutShortMsg_(my_hMidiOut3,($000090))  
midiOutShortMsg_(my_hMidiOut3,($000190))
midiOutShortMsg_(my_hMidiOut3,($000290))
midiOutShortMsg_(my_hMidiOut3,($000390))  
midiOutShortMsg_(my_hMidiOut3,($000490))  
midiOutShortMsg_(my_hMidiOut3,($000590))  
midiOutShortMsg_(my_hMidiOut3,($000690))  
midiOutShortMsg_(my_hMidiOut3,($000790))  
midiOutShortMsg_(my_hMidiOut3,($000890))  

midiOutShortMsg_(my_hMidiOut3,($001090))  
midiOutShortMsg_(my_hMidiOut3,($001190))
midiOutShortMsg_(my_hMidiOut3,($001290))
midiOutShortMsg_(my_hMidiOut3,($001390))  
midiOutShortMsg_(my_hMidiOut3,($001490))  
midiOutShortMsg_(my_hMidiOut3,($001590))  
midiOutShortMsg_(my_hMidiOut3,($001690))  
midiOutShortMsg_(my_hMidiOut3,($001790))  
midiOutShortMsg_(my_hMidiOut3,($001890))  

midiOutShortMsg_(my_hMidiOut3,($002090))  
midiOutShortMsg_(my_hMidiOut3,($002190))
midiOutShortMsg_(my_hMidiOut3,($002290))
midiOutShortMsg_(my_hMidiOut3,($002390))  
midiOutShortMsg_(my_hMidiOut3,($002490))  
midiOutShortMsg_(my_hMidiOut3,($002590))  
midiOutShortMsg_(my_hMidiOut3,($002690))  
midiOutShortMsg_(my_hMidiOut3,($002790))  
midiOutShortMsg_(my_hMidiOut3,($002890))  

midiOutShortMsg_(my_hMidiOut3,($003090))  
midiOutShortMsg_(my_hMidiOut3,($003190))
midiOutShortMsg_(my_hMidiOut3,($003290))
midiOutShortMsg_(my_hMidiOut3,($003390))  
midiOutShortMsg_(my_hMidiOut3,($003490))  
midiOutShortMsg_(my_hMidiOut3,($003590))  
midiOutShortMsg_(my_hMidiOut3,($003690))  
midiOutShortMsg_(my_hMidiOut3,($003790))  
midiOutShortMsg_(my_hMidiOut3,($003890))  
      

midiOutShortMsg_(my_hMidiOut3,($004090))  
midiOutShortMsg_(my_hMidiOut3,($004190))
midiOutShortMsg_(my_hMidiOut3,($004290))
midiOutShortMsg_(my_hMidiOut3,($004390))  
midiOutShortMsg_(my_hMidiOut3,($004490))  
midiOutShortMsg_(my_hMidiOut3,($004590))  
midiOutShortMsg_(my_hMidiOut3,($004690))  
midiOutShortMsg_(my_hMidiOut3,($004790))  
midiOutShortMsg_(my_hMidiOut3,($004890))  

midiOutShortMsg_(my_hMidiOut3,($005090))  
midiOutShortMsg_(my_hMidiOut3,($005190))
midiOutShortMsg_(my_hMidiOut3,($005290))
midiOutShortMsg_(my_hMidiOut3,($005390))  
midiOutShortMsg_(my_hMidiOut3,($005490))  
midiOutShortMsg_(my_hMidiOut3,($005590))  
midiOutShortMsg_(my_hMidiOut3,($005690))  
midiOutShortMsg_(my_hMidiOut3,($005790))  
midiOutShortMsg_(my_hMidiOut3,($005890))  

midiOutShortMsg_(my_hMidiOut3,($006090))  
midiOutShortMsg_(my_hMidiOut3,($006190))
midiOutShortMsg_(my_hMidiOut3,($006290))
midiOutShortMsg_(my_hMidiOut3,($006390))  
midiOutShortMsg_(my_hMidiOut3,($006490))  
midiOutShortMsg_(my_hMidiOut3,($006590))  
midiOutShortMsg_(my_hMidiOut3,($006690))  
midiOutShortMsg_(my_hMidiOut3,($006790))  
midiOutShortMsg_(my_hMidiOut3,($006890))  

midiOutShortMsg_(my_hMidiOut3,($007090))  
midiOutShortMsg_(my_hMidiOut3,($007190))
midiOutShortMsg_(my_hMidiOut3,($007290))
midiOutShortMsg_(my_hMidiOut3,($007390))  
midiOutShortMsg_(my_hMidiOut3,($007490))  
midiOutShortMsg_(my_hMidiOut3,($007590))  
midiOutShortMsg_(my_hMidiOut3,($007690))  
midiOutShortMsg_(my_hMidiOut3,($007790))  
midiOutShortMsg_(my_hMidiOut3,($007890))   


midiOutShortMsg_(my_hMidiOut3,($0068B0))    
midiOutShortMsg_(my_hMidiOut3,($0069B0))    
midiOutShortMsg_(my_hMidiOut3,($006AB0))    
midiOutShortMsg_(my_hMidiOut3,($006BB0))

midiOutShortMsg_(my_hMidiOut3,($006CB0))    
midiOutShortMsg_(my_hMidiOut3,($006DB0))    
midiOutShortMsg_(my_hMidiOut3,($006EB0))    
midiOutShortMsg_(my_hMidiOut3,($006FB0))


midiDisconnect_(hMidiIn, hMidiOut, 0)
midiDisconnect_(hMidiIn2,hMidiOut2, 0) 
midiDisconnect_(hMidiIn3,hMidiOut3, 0) 
midiDisconnect_(hMidiIn4,hMidiOut4, 0) 
midiDisconnect_(hMidiIn5,hMidiOut5, 0)
midiDisconnect_(hMidiIn6,hMidiOut6, 0) 
While midiInClose_(hMidiIn) = #MIDIERR_STILLPLAYING : Wend 
While midiOutClose_(hMidiOut) = #MIDIERR_STILLPLAYING : Wend 
While midiInClose_(hMidiIn2) = #MIDIERR_STILLPLAYING : Wend 
While midiOutClose_(hMidiOut2) = #MIDIERR_STILLPLAYING : Wend 
While midiInClose_(hMidiIn3) = #MIDIERR_STILLPLAYING : Wend 
While midiOutClose_(hMidiOut3) = #MIDIERR_STILLPLAYING : Wend 
While midiInClose_(hMidiIn4) = #MIDIERR_STILLPLAYING : Wend 
While midiOutClose_(hMidiOut4) = #MIDIERR_STILLPLAYING : Wend 
While midiInClose_(hMidiIn5) = #MIDIERR_STILLPLAYING : Wend 
While midiOutClose_(hMidiOut5) = #MIDIERR_STILLPLAYING : Wend 
While midiInClose_(hMidiIn6) = #MIDIERR_STILLPLAYING : Wend 
While midiOutClose_(hMidiOut6) = #MIDIERR_STILLPLAYING : Wend 


EndProgram:


EndProgram2:
;WE MUST TO CLOSE PROCESS HANDLE!!
If pHandle <> 0 : CloseHandle_(pHandle) :EndIf

End
;--- data section
DataSection 
  ControllerNames: 
    Data.s "Bank Select", "Modulation", "Breath Controller", "", "4 (0x04) Foot Controller"                   ;0 - 4 
    Data.s "Portamento time", "Data Entry (MSB)", "Main Volume", "Balance", "", "Pan"                         ;5 - 10 
    Data.s "Expression Controller", "Effect Control 1", "Effect Control 2", "", ""                            ;11 - 15 
    Data.s "General-Purpose Controllers 1", "General-Purpose Controllers 2", "General-Purpose Controllers 3"  ;16 - 18 
    Data.s "General-Purpose Controllers 4", "", "", "", "", "", "", "", "", "", "", "", ""                    ;19 - 31 
    Data.s "LSB for Controller 0", "LSB for Controller 1", "LSB for Controller 2", "LSB for Controller 3"     ;32 - 35 
    Data.s "LSB for Controller 4", "LSB for Controller 5", "LSB for Controller 6", "LSB for Controller 7"     ;36 - 39 
    Data.s "LSB for Controller 8", "LSB for Controller 9", "LSB for Controller 10", "LSB for Controller 11"   ;40 - 43 
    Data.s "LSB for Controller 12", "LSB for Controller 13", "LSB for Controller 14", "LSB for Controller 15" ;44 - 47 
    Data.s "LSB for Controller 16", "LSB for Controller 17", "LSB for Controller 18", "LSB for Controller 19" ;48 - 51 
    Data.s "LSB for Controller 20", "LSB for Controller 21", "LSB for Controller 22", "LSB for Controller 23" ;52 - 55 
    Data.s "LSB for Controller 24", "LSB for Controller 25", "LSB for Controller 26", "LSB for Controller 27" ;56 - 59 
    Data.s "LSB for Controller 28", "LSB for Controller 29", "LSB for Controller 30", "LSB for Controller 31" ;60 - 63 
    Data.s "Damper pedal (sustain)", "Portamento", "Sostenuto", "Soft Pedal", "Legato Footswitch"             ;64 - 68 
    Data.s "Hold 2", "Sound Controller 1 (Default: Timber Variation)"                                         ;69 - 70 
    Data.s "Sound Controller 2 (Default: Timber/Harmonic Content)"                                            ;71 - 71 
    Data.s "Sound Controller 3 (Default: Release time)", "Sound Controller 4 (Default: Attack time)"          ;72 - 73 
    Data.s "Sound Controller 6", "Sound Controller 7", "Sound Controller 8", "Sound Controller 9"             ;74 - 77 
    Data.s "Sound Controller 10", "", "General-Purpose Controllers 5", "General-Purpose Controllers 6"        ;78 - 81 
    Data.s "General-Purpose Controllers 7", "General-Purpose Controllers 8", "Portamento Control"             ;82 - 84 
    Data.s "", "", "", "", "", "", "Effects 1 Depth (formerly External Effects Depth)"                        ;85 - 91 
    Data.s "Effects 2 Depth (formerly Tremolo Depth)", "Effects 3 Depth (formerly Chorus Depth)"              ;92 - 93 
    Data.s "Effects 4 Depth (formerly Celeste Detune)", "Effects 5 Depth (formerly Phaser Depth)"             ;94 - 95 
    Data.s "Data Increment", "Data Decrement", "Non-Registered Parameter Number (LSB)"                        ;96 - 98 
    Data.s "Non-Registered Parameter Number (MSB)", "Registered Parameter Number (LSB)"                       ;99 - 100 
    Data.s "Registered Parameter Number (MSB)", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""    ;101 - 116 
    Data.s "", "", "", "", "Mode Messages", "Mode Messages", "Mode Messages", "Mode Messages"                 ;117 - 124 
    Data.s "Mode Messages", "Mode Messages", "Mode Messages"                                                  ;125 - 127 
EndDataSection
;--- fin de data section 

; IDE Options = PureBasic 5.50 (Windows - x86)
; CursorPosition = 226
; FirstLine = 207
; Folding = --
; Markers = 209,1029
; UseIcon = ..\bcedit.ico
; Executable = ..\V2\812 002.exe