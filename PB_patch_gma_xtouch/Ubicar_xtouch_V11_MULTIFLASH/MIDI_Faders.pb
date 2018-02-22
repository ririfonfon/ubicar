
Procedure Init_Arrays()
  Shared Behringer_FaderValues()
  Shared MAonPC_FaderValues()
  Shared MAonPC_EncoderValues()
  Shared LedValue()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
  
  AuxIndex.w
For AuxIndex = 0 To #MaxMidiInSliders
    Behringer_FaderValues(AuxIndex) = 0
    MAonPC_FaderValues(AuxIndex) 
Next AuxIndex

For AuxIndex = 0 To #NumEncoders
    MAonPC_EncoderValues(AuxIndex)
Next AuxIndex

For AuxIndex=0 To 29
  LedValue(AuxIndex)
Next AuxIndex  

For AuxIndex = 0 To 29
  LedValueIpad(AuxIndex)=0
Next AuxIndex

For AuxIndex = 0 To 78
  Launch (AuxIndex)=0
Next AuxIndex  

For AuxIndex = 0 To 78
  LaunchJ (AuxIndex)=0
Next AuxIndex    
  
  
EndProcedure


;================= code from mem spy =========
Procedure.b WinFind()
; trying to find the MAonPC window and get the process indentifier...

;int some vars
wHwnd = 0
pHandle = 0
pid = 0
    
    wHwnd = FindWindow_("_GMAONPC", vbNullString)
   
    If (wHwnd = 0) 
            PrintN("MULTIMIDI  by Riri Window Not detected Or lost!")
            ProcedureReturn #False
    Else
        ;We can now get the pid (process identifier)
        If GetWindowThreadProcessId_(wHwnd, @pid) <> 0 
            ;We can now get the pid to get a Process Handle
            pHandle = OpenProcess_(#PROCESS_ALL_ACCESS, 0, pid)
            If pHandle = 0 
                pid = 0
                PrintN("MULTIMIDI  by Riri Window GMAONPC found, Process Ok but Open Identifier error!")
                ProcedureReturn #False                

            Else
                PrintN("MULTIMIDI by Riri Window GMAONPC found!! All Data OK!")
                ProcedureReturn #True
            EndIf
        Else
            PrintN("MULTIMIDI  by Riri Window GMAONPC found, but Process Handle error!")
            ProcedureReturn #False
        EndIf
    EndIf
    
EndProcedure


;======================= faders code ========

Procedure.b WriteBehringerToMAonPC(Index.l, FadValue.l)
  
  Shared Behringer_FaderValues()
  Shared MAonPC_EncoderValues()
  
dato.b ;we need a dummie var to pass its pointer
dato = 1

If Index < 1 Or Index > 23 
    Debug "Error checking CC number WriteBehringerToMAonPC"+" pHandle= "+Hex(pHandle)
    ProcedureReturn #False
EndIf

Index = Index -1  ;As array starts in Index(0)

Debug "fadersvalues"+ Hex(index)+" = "+Hex(Int((FadValue / 127) * 255))
Behringer_FaderValues(Index) = Int((FadValue / 127) * 255)  ;we must to process the data from 127 to 255
;We must to write into 3 dif positions... REMEMBER! x and x+22 (also Mouse_Down)

    If pHandle <> 0 
        ;MouseDown value
        If WriteProcessMemory_(pHandle, FaderAddress + 48 + Index, @dato, 1, 0) = 0 
               Debug "Error writing memory inside WriteBehringerToMAonPC"+" pHandle= "+Hex(pHandle)
               ProcedureReturn #False
        Else
            ;First value of the slider
            WriteProcessMemory_(pHandle, FaderAddress + Index, @Behringer_FaderValues(Index), 1, 0)
            Debug ">>>>>>> phandle = "+Str(pHandle)+" fader = "+Str(FaderAddress + Index)+" beh = "+Str(@Behringer_FaderValues(Index))
            ;Second value -WE DISABLE THIS CAUSE WONT WORK!
            ;WriteProcessMemory_ (pHandle, #StartAddress + 22 + Index, VarPtr(Behringer_FaderValues(Index)), 1, 0&

     

                    ;send data to Behringer unit WE MUST TO PROCESS BACK 255 TO 127!!
                    AuxVal = Behringer_FaderValues(Index) & $FF ; to convert the signed byte into unsigned byte!
                    AuxVal = AuxVal/2
                    midimsg = $B0 + ((Index + 1) * $100) + (AuxVal * $10000) + #channel
                  ;pas de fader sur midi CH 11 midimsg = $B0 + ((AuxIndex + 1) * $100) + (AuxVal * $10000) + #channel2
                    Debug "Le retour Midi est  " + Hex(midimsg) + " reexpédié vers handle " + Hex(my_hMidiOut)
                    ;                                  Send!
                    
                    
;----------- add riri   demute Live effect on touch ipad                     
;                If Index = 0 And AuxVal = 0 ; si le fader 1 est a 0 alors demute les effects de live
;                   midiOutShortMsg_(my_hMidiOut2,($7F0190)) ; note 1 a 127 sur channel 1
;                Debug "demute effect"
;                EndIf
;                
;                If Index = 0 And AuxVal <> 0 ; si le fader 1 est different de 0 mute les effects de live
;                  midiOutShortMsg_(my_hMidiOut2,($280190)) ; noteoff 1 a 0 sur channel 1
;                Debug "mute effect"
;                EndIf
                
                
                
                   ;If midiin<>1 : midiOutShortMsg_(my_hMidiOut, midimsg) :Debug "midiin 2" :EndIf
                   ;If midiin<>2 : midiOutShortMsg_(my_hMidiOut2, midimsg):Debug "midiin 1" :EndIf
                    ;Debug " expédié vers MIDI "+StrU( MAonPC_FaderValues(AuxIndex),0) +" sont "+Str(AuxVal)+ " au Fader num " + Str(AuxIndex+1)
                    ;Debug "index = "+Str(Index)+"  aux val = "+Str(AuxVal)
                    
            ; we decide by now that NO, to detect when user move the MAonPC softslider
            ; MAonPC_FaderValues(Index) = Fader(Index).Value
            ;no error
            Debug "OK: Behringer to MAonPC Memory"
            ProcedureReturn #True : Debug " return process true"
        EndIf : Debug " endif 1"
    EndIf :Debug "endif 2"

Debug "Error, arrived final WriteBehringerToMAonPC"+" pHandle= "+Hex(pHandle)
  ProcedureReturn #False :Debug "return process false"
EndProcedure

;======================= ENCODERS code ========

Procedure.b WriteEncodersToMAonPC(Encoder.l, EncValue.l)

  Shared MAonPC_EncoderValues()
  
  
  ;When a CC 31 to 39 is produced this Procedure must be called
;only two values for eatch note number can be recieved,  64 and 65 that are increment or decrement the 
;current value... no MIDI Feedback to Behringer is needed....


If Encoder < 30 Or Encoder > 49  Or Encoder = 32 Or Encoder = 42;There is an empty space in index(1) we never must to use CC enc 32
    Debug "Error checking CC number WriteEncodersToMAonPC"+" pHandle= "+Hex(pHandle)
    ProcedureReturn #False
EndIf

If EncValue < 64 Or EncValue > 65
    Debug "Error checking CC EncValue WriteEncodersToMAonPC"+" pHandle= "+Hex(pHandle)
    ProcedureReturn #False
EndIf

If Encoder >= 33 And Encoder <= 39
  Increm = 16
  Encoder = Encoder - 30  ;As array starts in Index(0)
EndIf

If Encoder >= 43 And Encoder <= 49
  Increm = 0.5
  Encoder = Encoder - 40  ;As array starts in Index(0)
EndIf

If Encoder = 30
  Increm = 1
  Encoder = Encoder - 30  ;As array starts in Index(0)
  NavDirection = Pow(2,ScreenNum) 
EndIf

If Encoder = 40
  Increm = 1
  Encoder = Encoder - 40  ;As array starts in Index(0)
  NavDirection = 0
EndIf

Debug "Encoder = " + Str(Encoder) 
;CC num  : Array Index 
; 30 index 0 = V Navig Screen 1
; 31 index 1 = V Navig Screen 2(1bytes less direction 4/0) 
; 32 index 2 = V Navig Screen 3
; 33 index 3 = Enc1 coarse
; 34 index 4 = Enc2 coarse
; 35 index 5 = Enc3 coarse
; 36 index 6 = Enc4 coarse
; 37 index 7 = Tilt coarse
; 38 index 8 = Pan coarse
; 39 index 9 = Level coarse
; 40 index 10 = H Navig Screen 1
; 41 index 11 = H Navig Screen 2
; 42 index 12 = H Navig Screen 3
; 43 index 13 = Enc1 fine
; 44 index 14 = Enc2 fine
; 45 index 15 = Enc3 fine
; 46 index 16 = Enc4 fine
; 47 index 17 = Tilt fine
; 48 index 18 = Pan fine
; 49 index 19 = Level fine

    If pHandle <> 0 
        ;if Navigator Encoder we write also the direction stored into NavDirection
        If Encoder = 0
            If WriteProcessMemory_(pHandle, EncoderAddress - 1, @NavDirection, 1, 0) = 0  ;
                 Debug "Error writing Nevig Encoder Direction inside WriteEncodersToMAonPC"+" pHandle= "+Hex(pHandle)
                 ProcedureReturn #False
            EndIf
            ;We also must to read and write from the correct Nav mem position
            Encoder = (ScreenNum-1)            
        EndIf     
    
        ;Read the current value in MAonPC
        If ReadProcessMemory_(pHandle, EncoderAddress + (2 * Encoder), @MAonPC_EncoderValues(Encoder), 2, 0) = 0  ;read 2bytes WORD 
            ;show error
            Debug "Error reading memory inside WriteEncodersToMAonPC"+" pHandle= "+Hex(pHandle)
            ProcedureReturn #False
        Else
            Debug "Readed Encoder num "+Hex(Encoder)+" , Value "+Hex(MAonPC_EncoderValues(Encoder))
            Debug "From memory pos "+Hex(EncoderAddress + (2 * Encoder))
            
            ;is it the Level Encoder? If so we change the increment (not 1 but current increment..)
           ; If Encoder <= 3
           ;      Increm = Level_Incr 
           ; Else
           ;      Increm = Level_Incr
           ; EndIf
            
            ;We increment or decrement the readed value...            
            If EncValue = 64 : MAonPC_EncoderValues(Encoder) = MAonPC_EncoderValues(Encoder) - Increm :Debug "- increm" + Str (MAonPC_EncoderValues(Encoder))+"  "+Str(Increm):EndIf
            If EncValue = 65 : MAonPC_EncoderValues(Encoder) = MAonPC_EncoderValues(Encoder) + Increm :Debug "+ increm" + Str (MAonPC_EncoderValues(Encoder))+"  "+Str(Increm):EndIf  
            
  
            ;And then we write it back again... into the MAonPC memory..     
            If WriteProcessMemory_(pHandle, EncoderAddress + (2 * Encoder), @MAonPC_EncoderValues(Encoder), 2, 0) = 0  ;read 2bytes WORD 
               Debug "Error writing encoder value inside WriteEncodersToMAonPC"+" pHandle= "+Hex(pHandle)
               ProcedureReturn #False
            Else
              ;First value of the slider            
              Debug "OK: Encoder from Behringer to MAonPC Memory"
              ProcedureReturn #True
            EndIf
        EndIf
  EndIf
  
  Debug "Error, arrived final WriteEncodersToMAonPC"+" pHandle= "+Hex(pHandle)
  ProcedureReturn #False
EndProcedure


; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 166
; FirstLine = 166
; Folding = -
; Markers = 123,228