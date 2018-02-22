Procedure MIDIRequester(*OutDevice,*InDevice,*InDevice2,*OutDevice2,*InDevice3,*OutDevice3,*InDevice4,*OutDevice4,*InDevice5,*OutDevice5,*InDevice6,*OutDevice6) 
;this is the window shown to select the midi devices .
  #MOD_WAVETABLE = 6 
  #MOD_SWSYNTH = 7 
  
  #MIDIRequ_InSet = 2 
  #MIDIRequ_OutSet = 1 
  
  #MIDIRequ_InSet2 = 2
  #MIDIRequ_OutSet2 = 1
  
  #MIDIRequ_InSet3 = 2
  #MIDIRequ_OutSet3 = 1
  
  #MIDIRequ_InSet4 = 2
  #MIDIRequ_OutSet4 = 1
  
  #MIDIRequ_InSet5 = 2
  #MIDIRequ_OutSet5 = 1

  #MIDIRequ_InSet6 = 2
  #MIDIRequ_OutSet6 = 1

;---- ouverture de la fenetre---------------------------------------------------------------
  
  #Width = 1000
  If OpenWindow(0, 0, 0, #Width , 750, "Xtouch MULTI MIDI for MAonPC  by Riri" , #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
  
     ;If CreateGadgetList(WindowID()) 
      #Column = (#Width - 40) / 4
      #Offset = ((#Width - 10)/ 4) + 5 


;---------listage midi in Xtouch -----------------
      TextGadget(1, 5 , 5, #Column, 18, "xtouch 1 Input-Device:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(3, 5, 23, #Column, 100) 
        MaxInDev.l = midiInGetNumDevs_() 
        InfoIn.MIDIINCAPS 
        If MaxInDev 
          For a.l = 0 To MaxInDev - 1 
            midiInGetDevCaps_(a, InfoIn, SizeOf(MIDIINCAPS)) 
            AddGadgetItem(3, -1, PeekS(@InfoIn\szPname[0], 32)) 
          Next 
        Else 
          AddGadgetItem(3, -1, "(no input device)") 
          DisableGadget(3, 1) 
        EndIf 
        
;-------- listage midi out Xtouch --------------
      TextGadget(0, 5 + #Offset , 5, #Column, 18, "xtouch 1 Output-Device:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(2, 5 + #Offset , 23, #Column, 100) 
        MaxOutDev.l = midiOutGetNumDevs_() 
        InfoOut.MIDIOUTCAPS 
        If MaxOutDev 
          For a.l = -1 To MaxOutDev - 1 
            midiOutGetDevCaps_(a, InfoOut, SizeOf(MIDIOUTCAPS)) 
            AddGadgetItem(2, -1, PeekS(@InfoOut\szPname[0], 32)) 
          Next 
        Else 
          AddGadgetItem(2, -1, "(no output device)") 
          DisableGadget(2, 1) 
        EndIf 






;---- NEWS BCF 2 IN2 OUT2 MIDI -------------------------------------------------------------------------------------------------------------


;-------listage BCF 2 ------------
 TextGadget(11, #Offset + #Offset, 5, #Column, 18, "BCF 2 Input-Device:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(12, #Offset + #Offset, 23, #Column, 100) 
        MaxInDev2.l = midiInGetNumDevs_() 
        InfoIn2.MIDIINCAPS
        If MaxInDev2 
          For a.l = 0 To MaxInDev2 - 1 
            midiInGetDevCaps_(a, InfoIn2, SizeOf(MIDIINCAPS)) 
            AddGadgetItem(12, -1, PeekS(@InfoIn2\szPname[0], 32)) 
          Next 
        Else 
          AddGadgetItem(12, -1, "(no input device)") 
          DisableGadget(12, 1) 
       EndIf 

;------ listage BCF 2 --------
TextGadget(13, #Offset + #Offset + #Offset , 5, #Column, 18, "BCF 2 Output-Device:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(14, #Offset + #Offset + #Offset, 23, #Column, 100) 
        MaxOutDev2.l = midiOutGetNumDevs_() 
        InfoOut2.MIDIOUTCAPS 
        If MaxOutDev2
          For a.l = -1 To MaxOutDev2 - 1 
            midiOutGetDevCaps_(a, InfoOut2, SizeOf(MIDIOUTCAPS)) 
            AddGadgetItem(14, -1, PeekS(@InfoOut2\szPname[0], 32)) 
          Next 
        Else 
          AddGadgetItem(14, -1, "(no output device)") 
          DisableGadget(14, 1) 
        EndIf 






;---- NEWS LAUNCH IN3 OUT3 MIDI -------------------------------------------------------------------------------------------------------------


;-------listage LAUNCH 3 ------------
 TextGadget(27, 5 , 240 , #Column, 18 , "LAUNCHPAD Input-Device:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(20, 5 , 263, #Column, 100) 
        MaxInDev3.l = midiInGetNumDevs_() 
        InfoIn3.MIDIINCAPS
        If MaxInDev3 
          For a.l = 0 To MaxInDev3 - 1 
            midiInGetDevCaps_(a, InfoIn3, SizeOf(MIDIINCAPS)) 
            AddGadgetItem(20, -1, PeekS(@InfoIn3\szPname[0], 32)) 
          Next 
        Else 
          AddGadgetItem(20, -1, "(no input device)") 
          DisableGadget(20, 1) 
       EndIf 

;------ listage LAUNCH 3 --------
TextGadget(28, 5 + #Offset , 240, #Column, 18 , "LAUNCHPAD Output-Device:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(21, 5 + #Offset, 263 , #Column, 100) 
        MaxOutDev3.l = midiOutGetNumDevs_() 
        InfoOut3.MIDIOUTCAPS 
        If MaxOutDev3
          For a.l = -1 To MaxOutDev3 - 1 
            midiOutGetDevCaps_(a, InfoOut3, SizeOf(MIDIOUTCAPS)) 
            AddGadgetItem(21, -1, PeekS(@InfoOut3\szPname[0], 32)) 
          Next 
        Else 
          AddGadgetItem(21, -1, "(no output device)") 
          DisableGadget(21, 1) 
        EndIf 
 
 
        
;---- NEWS IPAD IN4 OUT4 MIDI -------------------------------------------------------------------------------------------------------------


;-------listage IPAD in 4 ------------
 TextGadget(31, #Offset + #Offset, 240, #Column, 18, "IPAD Input-Device:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(32, #Offset + #Offset, 263, #Column, 100) 
        MaxInDev4.l = midiInGetNumDevs_() 
        InfoIn4.MIDIINCAPS
        If MaxInDev4 
          For a.l = 0 To MaxInDev4 - 1 
            midiInGetDevCaps_(a, InfoIn4, SizeOf(MIDIINCAPS)) 
            AddGadgetItem(32, -1, PeekS(@InfoIn4\szPname[0], 32)) 
          Next 
        Else 
          AddGadgetItem(32, -1, "(no input device)") 
          DisableGadget(32, 1) 
       EndIf 

;------ listage IPAD out 4 --------
TextGadget(33, #Offset + #Offset + #Offset , 240, #Column, 18, "IPAD Output-Device:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(34, #Offset + #Offset + #Offset, 263, #Column, 100) 
        MaxOutDev4.l = midiOutGetNumDevs_() 
        InfoOut4.MIDIOUTCAPS 
        If MaxOutDev4
          For a.l = -1 To MaxOutDev4 - 1 
            midiOutGetDevCaps_(a, InfoOut4, SizeOf(MIDIOUTCAPS)) 
            AddGadgetItem(34, -1, PeekS(@InfoOut4\szPname[0], 32)) 
          Next 
        Else 
          AddGadgetItem(34, -1, "(no output device)") 
          DisableGadget(34, 1) 
        EndIf 



;---- NEWS IO GMA IN5 OUT5 MIDI -------------------------------------------------------------------------------------------------------------


;-------listage IO GMA in 5 ------------
 TextGadget(41, 5 , 500 , #Column, 18 , "I O GMA Input-Device:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(42, 5 , 523, #Column, 100) 
        MaxInDev5.l = midiInGetNumDevs_() 
        InfoIn5.MIDIINCAPS
        If MaxInDev5 
          For a.l = 0 To MaxInDev5 - 1 
            midiInGetDevCaps_(a, InfoIn5, SizeOf(MIDIINCAPS)) 
            AddGadgetItem(42, -1, PeekS(@InfoIn5\szPname[0], 32)) 
          Next 
        Else 
          AddGadgetItem(42, -1, "(no input device)") 
          DisableGadget(42, 1) 
       EndIf 

;------ listage IO GMA out 5 --------
TextGadget(43, 5 + #Offset , 500, #Column, 18 , "I O GMA Output-Device:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(44, 5 + #Offset, 523 , #Column, 100) 
        MaxOutDev5.l = midiOutGetNumDevs_() 
        InfoOut5.MIDIOUTCAPS 
        If MaxOutDev5
          For a.l = -1 To MaxOutDev5 - 1 
            midiOutGetDevCaps_(a, InfoOut5, SizeOf(MIDIOUTCAPS)) 
            AddGadgetItem(44, -1, PeekS(@InfoOut5\szPname[0], 32)) 
          Next 
        Else 
          AddGadgetItem(44, -1, "(no output device)") 
          DisableGadget(44, 1) 
        EndIf 
 
 
;---- NEWS KEY DE WILL IN6 OUT6 MIDI -------------------------------------------------------------------------------------------------------------


;-------listage KEY DE WILL in 6 ------------
 TextGadget(51, #Offset + #Offset , 500 , #Column, 18 , "Key DE WILL Input-Device:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(52, #Offset + #Offset , 523, #Column, 100) 
        MaxInDev6.l = midiInGetNumDevs_() 
        InfoIn6.MIDIINCAPS
        If MaxInDev6 
          For a.l = 0 To MaxInDev6 - 1 
            midiInGetDevCaps_(a, InfoIn6, SizeOf(MIDIINCAPS)) 
            AddGadgetItem(52, -1, PeekS(@InfoIn6\szPname[0], 32)) 
          Next 
        Else 
          AddGadgetItem(52, -1, "(no input device)") 
          DisableGadget(52, 1) 
       EndIf 

;------ listage KEY DE WILL out 6 --------
TextGadget(53, #Offset + #Offset + #Offset , 500, #Column, 18 , "Key DE WILL Output-Device:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(54, #Offset + #Offset + #Offset, 523 , #Column, 100) 
        MaxOutDev6.l = midiOutGetNumDevs_() 
        InfoOut6.MIDIOUTCAPS 
        If MaxOutDev6
          For a.l = -1 To MaxOutDev6 - 1 
            midiOutGetDevCaps_(a, InfoOut6, SizeOf(MIDIOUTCAPS)) 
            AddGadgetItem(54, -1, PeekS(@InfoOut6\szPname[0], 32)) 
          Next 
        Else 
          AddGadgetItem(54, -1, "(no output device)") 
          DisableGadget(54, 1) 
        EndIf  

 
 
;----- definition Reset at default Save at default OK Cancel et version des peripheriques -------------------------------------------------------------------------------------------

        
      
      ButtonGadget(91,5,730,#Column,24, "&Reset at default") 
      ButtonGadget(90,#Offset,730,#Column,24, "&Save at default")       
      ButtonGadget(4,  #Offset + #Offset, 730, #Column, 24, "&OK") 
      ButtonGadget(5,  #Offset + #Offset + #Offset , 730, #Column, 24, "&Cancel") 

      
      FrameGadget(6, 5, 130, (#Width - 20) / 2, 100 , "BCF Output-Device", #PB_Frame_Double) 
       TextGadget(7, 10, 145, ((#Width - 20) / 3), 18, "Version:") 
       TextGadget(8, 10, 165, ((#Width - 20) / 3), 18, "Technology:") 
       TextGadget(9, 10, 185, ((#Width - 20) / 3), 18, "Max. Voices:") 
       TextGadget(10, 10, 205, ((#Width - 20) / 3), 18, "Polyphonie:") 
     
      FrameGadget(19, #Offset + #Offset , 130, (#Width - 20 ) / 2, 100 , "OSC Output-Device", #PB_Frame_Double) 
       TextGadget(15, #Offset + #Offset + 10 , 145, ((#Width - 20) / 3), 18, "Version:") 
       TextGadget(16, #Offset + #Offset + 10 , 165, ((#Width - 20) / 3), 18, "Technology:") 
       TextGadget(17, #Offset + #Offset + 10 , 185, ((#Width - 20) / 3), 18, "Max. Voices:") 
       TextGadget(18, #Offset + #Offset + 10 , 205, ((#Width - 20) / 3), 18, "Polyphonie:")
      
      FrameGadget(26, 5, 370, (#Width - 20 ) / 2, 100 , "LAUNCHPAD Output-Device", #PB_Frame_Double) 
       TextGadget(22, 10 , 388, ((#Width - 20) / 3), 18, "Version:") 
       TextGadget(23, 10 , 406, ((#Width - 20) / 3), 18, "Technology:") 
       TextGadget(24, 10 , 424, ((#Width - 20) / 3), 18, "Max. Voices:") 
       TextGadget(25, 10 , 443, ((#Width - 20) / 3), 18, "Polyphonie:") 
       
       
      FrameGadget(39, #Offset + #Offset , 370, (#Width - 20 ) / 2, 100 , "I O WIDI Output-Device", #PB_Frame_Double) 
       TextGadget(35, #Offset + #Offset + 10 , 388, ((#Width - 20) / 3), 18, "Version:") 
       TextGadget(36, #Offset + #Offset + 10 , 406, ((#Width - 20) / 3), 18, "Technology:") 
       TextGadget(37, #Offset + #Offset + 10 , 424, ((#Width - 20) / 3), 18, "Max. Voices:") 
       TextGadget(38, #Offset + #Offset + 10 , 443, ((#Width - 20) / 3), 18, "Polyphonie:")
       
      FrameGadget(49, 5 , 630, (#Width - 20 ) / 2, 100 , "I O GMA Output-Device", #PB_Frame_Double) 
       TextGadget(45, 10 , 648, ((#Width - 20) / 3), 18, "Version:") 
       TextGadget(46, 10 , 664, ((#Width - 20) / 3), 18, "Technology:") 
       TextGadget(47, 10 , 682, ((#Width - 20) / 3), 18, "Max. Voices:") 
       TextGadget(48, 10 , 700, ((#Width - 20) / 3), 18, "Polyphonie:")
      
      FrameGadget(59, #Offset + #Offset , 630, (#Width - 20 ) / 2, 100 , "Key DE WILL Output-Device", #PB_Frame_Double) 
       TextGadget(55, #Offset + #Offset + 10 , 648, ((#Width - 20) / 3), 18, "Version:") 
       TextGadget(56, #Offset + #Offset + 10 , 664, ((#Width - 20) / 3), 18, "Technology:") 
       TextGadget(57, #Offset + #Offset + 10 , 682, ((#Width - 20) / 3), 18, "Max. Voices:") 
       TextGadget(58, #Offset + #Offset + 10 , 700, ((#Width - 20) / 3), 18, "Polyphonie:")       
                
               
      OutDev.l = 0 
      InDev.l = 0 
      
      OutDev2.l = 0
      InDev2.l = 0
      
      OutDev3.l = 0
      InDev3.l = 0
      
      OutDev4.l = 0
      InDev4.l = 0
      
      OutDev5.l = 0
      InDev5.l = 0
      
      OutDev6.l = 0
      InDev6.l = 0
      
      Quit.l = #False 
      OK.l = #False 
      
      Repeat 
 
;----- active ok --------------     
       ; If GetGadgetState(2) > -1 And GetGadgetState(3) > -1  ; And GetGadgetState(12) > -1 And GetGadgetState(14) > -1
       ;   DisableGadget(4, 0) 
       ; Else 
       ;   DisableGadget(4, 1) 
       ; EndIf 
        

;----------- validation des peripheriques -----------      
        If InDev.l <> GetGadgetState(3) 
          InDev.l = GetGadgetState(3) 
        EndIf 

        If InDev2.l <> GetGadgetState(12) 
          InDev2.l = GetGadgetState(12) 
        EndIf 

        If InDev3.l <> GetGadgetState(20) 
          InDev3.l = GetGadgetState(20) 
        EndIf 
        
        If InDev4.l <> GetGadgetState(32) 
          InDev4.l = GetGadgetState(32) 
        EndIf 
        
        If InDev5.l <> GetGadgetState(42) 
          InDev5.l = GetGadgetState(42) 
        EndIf 
        
        If InDev6.l <> GetGadgetState(52) 
          InDev6.l = GetGadgetState(52) 
        EndIf 

        If GetGadgetState(2) <> OutDev 
          OutDev.l = GetGadgetState(2) 
          midiOutGetDevCaps_(OutDev - 1, InfoOut, SizeOf(MIDIOUTCAPS)) 
          SetGadgetText(7,"Version: " + Str(InfoOut\vDriverVersion >> 8) + "." + Str(InfoOut\vDriverVersion & FF)) 
          Select InfoOut\wTechnology 
            Case #MOD_MIDIPORT :  TmpS.s = "Hardware Port" 
            Case #MOD_SYNTH :     TmpS.s = "Synthesizer" 
            Case #MOD_SQSYNTH :   TmpS.s = "Square Wave Synthesizer" 
            Case #MOD_FMSYNTH :   TmpS.s = "FM Synthesizer" 
            Case #MOD_MAPPER :    TmpS.s = "Microsoft MIDI Mapper" 
            Case #MOD_WAVETABLE : TmpS.s = "Hardware Wavetable Synthesizer" 
            Case #MOD_SWSYNTH :   TmpS.s = "Software Synthesizer" 
            Default: TmpS.s = "(Error Code " + Str(InfoOut\wTechnology) + ")" 
          EndSelect 
          SetGadgetText(8, "Technology: " + TmpS) 
          If InfoOut\wVoices = 0 : TmpS.s = "inf" : Else : TmpS.s = Str(InfoOut\wVoices) : EndIf 
          SetGadgetText(9, "Max. Voices: " + TmpS) 
          If InfoOut\wNotes = 0 : TmpS.s = "inf" : Else : TmpS.s = Str(InfoOut\wNotes) : EndIf 
          SetGadgetText(10, "Polyphonie: " + TmpS) 
        EndIf 
        
        If GetGadgetState(14) <> OutDev2 
          OutDev2.l = GetGadgetState(14) 
          midiOutGetDevCaps_(OutDev2 - 1, InfoOut, SizeOf(MIDIOUTCAPS)) 
          SetGadgetText(15, "Version: " + Str(InfoOut\vDriverVersion >> 8) + "." + Str(InfoOut\vDriverVersion & FF)) 
          Select InfoOut\wTechnology 
            Case #MOD_MIDIPORT :  TmpS.s = "Hardware Port" 
            Case #MOD_SYNTH :     TmpS.s = "Synthesizer" 
            Case #MOD_SQSYNTH :   TmpS.s = "Square Wave Synthesizer" 
            Case #MOD_FMSYNTH :   TmpS.s = "FM Synthesizer" 
            Case #MOD_MAPPER :    TmpS.s = "Microsoft MIDI Mapper" 
            Case #MOD_WAVETABLE : TmpS.s = "Hardware Wavetable Synthesizer" 
            Case #MOD_SWSYNTH :   TmpS.s = "Software Synthesizer" 
            Default: TmpS.s = "(Error Code " + Str(InfoOut\wTechnology) + ")" 
          EndSelect 
          SetGadgetText(16, "Technology: " + TmpS) 
          If InfoOut\wVoices = 0 : TmpS.s = "inf" : Else : TmpS.s = Str(InfoOut\wVoices) : EndIf 
          SetGadgetText(17, "Max. Voices: " + TmpS) 
          If InfoOut\wNotes = 0 : TmpS.s = "inf" : Else : TmpS.s = Str(InfoOut\wNotes) : EndIf 
          SetGadgetText(18, "Polyphonie: " + TmpS) 
        EndIf 
        
        If GetGadgetState(21) <> OutDev3 
          OutDev3.l = GetGadgetState(21) 
          midiOutGetDevCaps_(OutDev3 - 1, InfoOut, SizeOf(MIDIOUTCAPS)) 
          SetGadgetText(22, "Version: " + Str(InfoOut\vDriverVersion >> 8) + "." + Str(InfoOut\vDriverVersion & FF)) 
          Select InfoOut\wTechnology 
            Case #MOD_MIDIPORT :  TmpS.s = "Hardware Port" 
            Case #MOD_SYNTH :     TmpS.s = "Synthesizer" 
            Case #MOD_SQSYNTH :   TmpS.s = "Square Wave Synthesizer" 
            Case #MOD_FMSYNTH :   TmpS.s = "FM Synthesizer" 
            Case #MOD_MAPPER :    TmpS.s = "Microsoft MIDI Mapper" 
            Case #MOD_WAVETABLE : TmpS.s = "Hardware Wavetable Synthesizer" 
            Case #MOD_SWSYNTH :   TmpS.s = "Software Synthesizer" 
            Default: TmpS.s = "(Error Code " + Str(InfoOut\wTechnology) + ")" 
          EndSelect 
          SetGadgetText(23, "Technology: " + TmpS) 
          If InfoOut\wVoices = 0 : TmpS.s = "inf" : Else : TmpS.s = Str(InfoOut\wVoices) : EndIf 
          SetGadgetText(24, "Max. Voices: " + TmpS) 
          If InfoOut\wNotes = 0 : TmpS.s = "inf" : Else : TmpS.s = Str(InfoOut\wNotes) : EndIf 
          SetGadgetText(25, "Polyphonie: " + TmpS) 
        EndIf
        
        If GetGadgetState(34) <> OutDev4 
          OutDev4.l = GetGadgetState(34) 
          midiOutGetDevCaps_(OutDev4 - 1, InfoOut, SizeOf(MIDIOUTCAPS)) 
          SetGadgetText(35, "Version: " + Str(InfoOut\vDriverVersion >> 8) + "." + Str(InfoOut\vDriverVersion & FF)) 
          Select InfoOut\wTechnology 
            Case #MOD_MIDIPORT :  TmpS.s = "Hardware Port" 
            Case #MOD_SYNTH :     TmpS.s = "Synthesizer" 
            Case #MOD_SQSYNTH :   TmpS.s = "Square Wave Synthesizer" 
            Case #MOD_FMSYNTH :   TmpS.s = "FM Synthesizer" 
            Case #MOD_MAPPER :    TmpS.s = "Microsoft MIDI Mapper" 
            Case #MOD_WAVETABLE : TmpS.s = "Hardware Wavetable Synthesizer" 
            Case #MOD_SWSYNTH :   TmpS.s = "Software Synthesizer" 
            Default: TmpS.s = "(Error Code " + Str(InfoOut\wTechnology) + ")" 
          EndSelect 
          SetGadgetText(36, "Technology: " + TmpS) 
          If InfoOut\wVoices = 0 : TmpS.s = "inf" : Else : TmpS.s = Str(InfoOut\wVoices) : EndIf 
          SetGadgetText(37, "Max. Voices: " + TmpS) 
          If InfoOut\wNotes = 0 : TmpS.s = "inf" : Else : TmpS.s = Str(InfoOut\wNotes) : EndIf 
          SetGadgetText(38, "Polyphonie: " + TmpS) 
        EndIf
        
        If GetGadgetState(44) <> OutDev5 
          OutDev5.l = GetGadgetState(44) 
          midiOutGetDevCaps_(OutDev5 - 1, InfoOut, SizeOf(MIDIOUTCAPS)) 
          SetGadgetText(45, "Version: " + Str(InfoOut\vDriverVersion >> 8) + "." + Str(InfoOut\vDriverVersion & FF)) 
          Select InfoOut\wTechnology 
            Case #MOD_MIDIPORT :  TmpS.s = "Hardware Port" 
            Case #MOD_SYNTH :     TmpS.s = "Synthesizer" 
            Case #MOD_SQSYNTH :   TmpS.s = "Square Wave Synthesizer" 
            Case #MOD_FMSYNTH :   TmpS.s = "FM Synthesizer" 
            Case #MOD_MAPPER :    TmpS.s = "Microsoft MIDI Mapper" 
            Case #MOD_WAVETABLE : TmpS.s = "Hardware Wavetable Synthesizer" 
            Case #MOD_SWSYNTH :   TmpS.s = "Software Synthesizer" 
            Default: TmpS.s = "(Error Code " + Str(InfoOut\wTechnology) + ")" 
          EndSelect 
          SetGadgetText(46, "Technology: " + TmpS) 
          If InfoOut\wVoices = 0 : TmpS.s = "inf" : Else : TmpS.s = Str(InfoOut\wVoices) : EndIf 
          SetGadgetText(47, "Max. Voices: " + TmpS) 
          If InfoOut\wNotes = 0 : TmpS.s = "inf" : Else : TmpS.s = Str(InfoOut\wNotes) : EndIf 
          SetGadgetText(48, "Polyphonie: " + TmpS) 
        EndIf
      
        If GetGadgetState(54) <> OutDev6 
          OutDev6.l = GetGadgetState(54) 
          midiOutGetDevCaps_(OutDev6 - 1, InfoOut, SizeOf(MIDIOUTCAPS)) 
          SetGadgetText(55, "Version: " + Str(InfoOut\vDriverVersion >> 8) + "." + Str(InfoOut\vDriverVersion & FF)) 
          Select InfoOut\wTechnology 
            Case #MOD_MIDIPORT :  TmpS.s = "Hardware Port" 
            Case #MOD_SYNTH :     TmpS.s = "Synthesizer" 
            Case #MOD_SQSYNTH :   TmpS.s = "Square Wave Synthesizer" 
            Case #MOD_FMSYNTH :   TmpS.s = "FM Synthesizer" 
            Case #MOD_MAPPER :    TmpS.s = "Microsoft MIDI Mapper" 
            Case #MOD_WAVETABLE : TmpS.s = "Hardware Wavetable Synthesizer" 
            Case #MOD_SWSYNTH :   TmpS.s = "Software Synthesizer" 
            Default: TmpS.s = "(Error Code " + Str(InfoOut\wTechnology) + ")" 
          EndSelect 
          SetGadgetText(56, "Technology: " + TmpS) 
          If InfoOut\wVoices = 0 : TmpS.s = "inf" : Else : TmpS.s = Str(InfoOut\wVoices) : EndIf 
          SetGadgetText(57, "Max. Voices: " + TmpS) 
          If InfoOut\wNotes = 0 : TmpS.s = "inf" : Else : TmpS.s = Str(InfoOut\wNotes) : EndIf 
          SetGadgetText(58, "Polyphonie: " + TmpS) 
        EndIf
        
        ;------------------------ verif du defo --------------
        If LoadXML (10,"defo.xml") And check=0
          Debug "load defo.xml"
          Defo = MainXMLNode(10)

        d3$=GetXMLAttribute(Defo,"id3")
        d2$=GetXMLAttribute(Defo,"id2")
        d12$=GetXMLAttribute(Defo,"id12")
        d14$=GetXMLAttribute(Defo,"id14")
        d20$=GetXMLAttribute(Defo,"id20")
        d21$=GetXMLAttribute(Defo,"id21")
        d32$=GetXMLAttribute(Defo,"id32")
        d34$=GetXMLAttribute(Defo,"id34")
        d42$=GetXMLAttribute(Defo,"id42")
        d44$=GetXMLAttribute(Defo,"id44")
        d52$=GetXMLAttribute(Defo,"id52")
        d54$=GetXMLAttribute(Defo,"id54")
        Debug " xml load = " + d3$ + d2$ + d12$ + d14$ + d20$ + d21$ + d32$ + d34$ +d42$ + d44$ + d52$ + d54$
        
        SetGadgetState (3,Val(d3$))
        SetGadgetState (2,Val(d2$))
        SetGadgetState (12,Val(d12$))
        SetGadgetState (14,Val(d14$))
        SetGadgetState (20,Val(d20$))
        SetGadgetState (21,Val(d21$))
        SetGadgetState (32,Val(d32$))
        SetGadgetState (34,Val(d34$))
        SetGadgetState (42,Val(d42$))
        SetGadgetState (44,Val(d44$))
        SetGadgetState (52,Val(d52$))
        SetGadgetState (54,Val(d54$))
        
        check=1
        
      EndIf
      
;------ inscriptions en memoire des peripheriques valider par OK --------------       
      
     
      
             
            
            
      EventID.l = WaitWindowEvent() 
        Select EventID 
          Case #PB_Event_CloseWindow 
            Quit = #True 
            OK = #False       
         
          Case #PB_Event_Gadget 
            Select EventGadget() 
              Case 4 
                PokeL(*InDevice, InDev)
                PokeL(*OutDevice, OutDev - 1) 
                PokeL(*InDevice2, InDev2) 
                PokeL(*OutDevice2, OutDev2 - 1) 
                PokeL(*InDevice3, InDev3)
                PokeL(*OutDevice3, OutDev3 - 1)
                PokeL(*InDevice4, InDev4)
                PokeL(*OutDevice4, OutDev4 - 1)
                PokeL(*InDevice5, InDev5)
                PokeL(*OutDevice5, OutDev5 - 1)
                PokeL(*InDevice6, InDev6)
                PokeL(*OutDevice6, OutDev6 - 1)
                
                Quit = #True 
                OK = 3 
                
              Case 90
                xml= CreateXML(#PB_Any)
                mainNode = CreateXMLNode(RootXMLNode(xml), "Defo") 
                
                SetXMLAttribute (mainNode, "id3", Str(GetGadgetState(3)))                             
                SetXMLAttribute (mainNode, "id2", Str(GetGadgetState(2)))               
                SetXMLAttribute (mainNode, "id12", Str(GetGadgetState(12)))               
                SetXMLAttribute (mainNode, "id14", Str(GetGadgetState(14)))                              
                SetXMLAttribute (mainNode, "id20", Str(GetGadgetState(20)))                               
                SetXMLAttribute (mainNode, "id21", Str(GetGadgetState(21)))                              
                SetXMLAttribute (mainNode, "id32", Str(GetGadgetState(32)))                               
                SetXMLAttribute (mainNode, "id34", Str(GetGadgetState(34)))                                
                SetXMLAttribute (mainNode, "id42", Str(GetGadgetState(42)))                             
                SetXMLAttribute (mainNode, "id44", Str(GetGadgetState(44)))                              
                SetXMLAttribute (mainNode, "id52", Str(GetGadgetState(52)))                                
                SetXMLAttribute (mainNode, "id54", Str(GetGadgetState(54)))
                               
                SaveXML (xml,"defo.xml")
                Debug "save defo.xml"
                
                 ;------------------ reset at defo --------------------
              Case 91
                 SetGadgetState (3,-1)
                 SetGadgetState (2,-1)
                 SetGadgetState (12,-1)
                 SetGadgetState (14,-1)
                 SetGadgetState (20,-1)
                 SetGadgetState (21,-1)
                 SetGadgetState (32,-1)
                 SetGadgetState (34,-1)
                 SetGadgetState (42,-1)
                 SetGadgetState (44,-1)
                 SetGadgetState (52,-1)
                 SetGadgetState (54,-1)
                
                
;----- condition de validation de ok  -------------- 

              
                If (OutDev = -1 Or CountGadgetItems(2) = 0) And OK & #MIDIRequ_OutSet : OK ! #MIDIRequ_OutSet : EndIf 
                If (InDev = -1 Or CountGadgetItems(3) = 0) And OK & #MIDIRequ_InSet : OK ! #MIDIRequ_InSet : EndIf 
               
                 
              Case 5 
                Quit = #True 
                OK = #False 
            EndSelect 
        EndSelect 
      Until Quit 
      Debug "bcf 1 in = " + GetGadgetState(3) + " : out = "+ GetGadgetState(2)
      Debug "bcf 2 in = " + GetGadgetState(12) + " : out = "+ GetGadgetState(14)
      Debug "launchpad in = " + GetGadgetState(20) + " : out = "+ GetGadgetState(21)
      Debug "IPAD in = " + GetGadgetState(32) + " : out = "+ GetGadgetState(34)
      Debug "GMA IO in = " + GetGadgetState(42) + " : out = "+ GetGadgetState(44)
      Debug "keydewill in = " + GetGadgetState(52) + " : out = "+ GetGadgetState(54)
      CloseWindow(0) 
      ProcedureReturn OK 
    ;Else 
    ;  End 
   ; EndIf 
  Else 
    End 
  EndIf 
 
EndProcedure 
; IDE Options = PureBasic 5.50 (Windows - x86)
; CursorPosition = 33
; FirstLine = 81
; Folding = -