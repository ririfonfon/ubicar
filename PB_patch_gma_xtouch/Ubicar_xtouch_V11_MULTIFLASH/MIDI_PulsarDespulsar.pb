;Keyboard keys we press  -executors
; ALT          1 2 3 4 5 6 7 8  .. 20 midi notes 1.. 20
; shift         1 2 3 4 5 6 7 8  .. 20 midi notes 21 ..40
; Control     1 2 3 4 5 6 7 8  .. 20 midi notes 41 ..60 
;
;keys of the groups
;     61    Ctrl Z (Oops)            63    PgUp
;     62    BackSpace (Clear)     64    PgDn
;
;Faders  
;      65   Alt F1 (Ch1-10)       67      ALt F3  (Exc1-10)
;      66   Alt F2 (Ch11-20)      68     Alt F4  (Exc11-20)

; also      71 72 73
;            81 82 83
;            84 85 86
; 
; jun 2012 added  alt f5 in note 69 to press execbutton


Procedure.b PressKey(Key.l, KeyValue.l)

  If pHandle <> 0 
      If WriteProcessMemory_(pHandle, KeyAddress + Key, @KeyValue, 1, 0) = 0  ;
           Debug "Error writing Key values inside PressKey"+" pHandle= "+Hex(pHandle)
           ProcedureReturn #False
      EndIf
  EndIf     
  
  
  ProcedureReturn #False
EndProcedure

Procedure.b PulsarDespulsarTecla (nota.l, velocity.l,channel.l)

; fist we ensure MaonPC window is the active window, 
; the window that recieves the user entries (mouse and keyboard)
; maybe you think that is too much code to be shure that the window is
; not lost and is the active window, but we dont want to loose the key pressed by the user!!

;=========================
;if note number we dont need to process, we go out!
If nota = 0 Or nota > 128
  ProcedureReturn #False
EndIf

;=========================

Shared WHnd.l 
Shared Launch()
Shared  Behringer_FaderValues() 
Shared  MAonPC_FaderValues()
Shared Callkey()


;we check here if we have lost the MAonPC window...
If WHnd = 0 
    WHnd = FindWindow_("_GMAONPC", #Null)
    Debug "looking for the MAonPC window inside PulsarDespulsarTecla!"
    If WHnd = 0 
        Debug "we have lost the MAonPC window... maybe is closed, no succes with FindWindow_()"
        ProcedureReturn #False
    Else
        Debug "We found the MAonPC window, we set it to the active window!"
        OpenIcon_(WHnd) 
        SetForegroundWindow_(WHnd) 
        SetActiveWindow_(WHnd) 
        Debug "MAonPC window is now the active window!" 
        Delay(50)   ;we give time to the window to paint itself and load in the screen
    EndIf
EndIf

;if the current active window is not the MAonPC... we try to convert it in the active one.
; If  GetForegroundWindow_() <> WHnd   ;IsWindowEnabled_(WHnd) = 0 NO VA!
;     Debug "Activando la Ventana desde GetForegroundWindow_()"
;     OpenIcon_(WHnd) 
;     SetForegroundWindow_(WHnd) 
;     SetActiveWindow_(WHnd) 
;     Debug "Ventana Activada"
;     Delay(50)
;     If  GetForegroundWindow_() <> WHnd  ;IsWindowEnabled_(WHnd) = 0
;         Debug "Salimos desde GetForegroundWindow_()"
;         ProcedureReturn #False
;     EndIf
; EndIf

;=========================================================================================================================
;=========================================================================================================================
;-------------now that MAonPC window is ready, we can send the keys...----------------------------------------------------
;=========================================================================================================================
;=========================================================================================================================

;----------------------------------------


;=========================================================================================================================
;=========================================================================================================================
;----------------select MIDI channel 10-----------------------------------------------------------------------------------
;=========================================================================================================================
;=========================================================================================================================
;

;select channel 10
;
If channel = #channel


;=========================
; Note 72 Navigator Encoder direction, it depends from the last screen selected
If nota = 72
    If velocity = $7F : NV = 1
    midiOutShortMsg_(my_hMidiOut4, ($4001BA)) : Debug "horizontal on "
    
    EndIf
    
    If velocity = $00 : NV = 0
    midiOutShortMsg_(my_hMidiOut4, ($0001BA)) : Debug "vertical on "
    
    EndIf
    Debug "NavigDirection = " + Str(NavDirection)
    Debug "(ScreenNum-1) " +Str(ScreenNum-1)
    ProcedureReturn #True
EndIf
;=========================
; Note 73 Level Encoder Increment
If nota = 73
    If velocity = $7F : VL = 1
    midiOutShortMsg_(my_hMidiOut4, ($4002BA)) : Debug "COARSE on "
   
    EndIf
    
    If velocity = $00 : VL = 0
    midiOutShortMsg_(my_hMidiOut4, ($0002BA)) : Debug "FINE on "
    
    EndIf
    
    Debug "Level_Incr = " + Str(Level_Incr)
    Debug "(ScreenNum-1) " +Str(ScreenNum-1)
    ProcedureReturn #True
EndIf


;============================================
;Selecction of Faders  
;      65   Alt F1 (Ch1-10)        67      ALt F3  (Exc1-10)  
;      66   Alt F2 (Ch11-20)       68      Alt F4  (Exc11-20)   
If nota > 64 And nota < 69
    ;si vel = $7F Pulsar Alt   #VK_F1 = $70
    If velocity = $7F :keybd_event_(#VK_LMENU ,1,0,0):EndIf 

    If velocity = $7F :keybd_event_((#VK_F1 + (nota-65)),1,0,0) :EndIf
    If velocity = $00 :keybd_event_((#VK_F1 + (nota-65)),1,#KEYEVENTF_KEYUP,0) :EndIf

    ;si vel = $00 despulsar Alt
    If velocity = $00
      keybd_event_(#VK_LMENU,1,0,0) 
      keybd_event_(#VK_LMENU,1,#KEYEVENTF_KEYUP,0) 
    EndIf
    
  ProcedureReturn #True ;Means note processed but error?
EndIf

If nota = 72
    ;si vel = $7F Pulsar Alt   #VK_F1 = $70
    If velocity = $7F :keybd_event_(#VK_LMENU ,1,0,0):EndIf 

    If velocity = $7F :keybd_event_(#VK_F1,1,0,0) :EndIf
    If velocity = $00 :keybd_event_(#VK_F1,1,#KEYEVENTF_KEYUP,0) :EndIf

    ;si vel = $00 despulsar Alt
    If velocity = $00
      keybd_event_(#VK_LMENU,1,0,0) 
      keybd_event_(#VK_LMENU,1,#KEYEVENTF_KEYUP,0) 
    EndIf
    
  ProcedureReturn #True ;Means note processed but error?
EndIf


;============================================

;Execbutton  
;      69   Alt F5    EXT BT
If nota = 69 
    ;if vel = $7F press Alt  
    If velocity = $7F :keybd_event_(#VK_LMENU ,1,0,0):EndIf 

    If velocity = $7F :keybd_event_(#VK_F5,1,0,0) :EndIf
    If velocity = $00 :keybd_event_(#VK_F5,1,#KEYEVENTF_KEYUP,0) :EndIf

    ;if vel = $00 unpress Alt
    If velocity = $00
      keybd_event_(#VK_LMENU,1,0,0) 
      keybd_event_(#VK_LMENU,1,#KEYEVENTF_KEYUP,0) 
    EndIf
    
  ProcedureReturn #True ;Means note processed but error?
EndIf

If nota = 73
    ;if vel = $7F press Alt  
    If velocity = $7F :keybd_event_(#VK_LMENU ,1,0,0):EndIf 

    If velocity = $7F :keybd_event_(#VK_F5,1,0,0) :EndIf
    If velocity = $00 :keybd_event_(#VK_F5,1,#KEYEVENTF_KEYUP,0) :EndIf

    ;if vel = $00 unpress Alt
    If velocity = $00
      keybd_event_(#VK_LMENU,1,0,0) 
      keybd_event_(#VK_LMENU,1,#KEYEVENTF_KEYUP,0) 
    EndIf
    
  ProcedureReturn #True ;Means note processed but error?
EndIf

;==========================================
;Selecction of Encoders  
;     61     Alt F6  (Encoders)   
If nota = 61 
    ;if vel = $7F press Alt  
    If velocity = $7F :keybd_event_(#VK_LMENU ,1,0,0):EndIf 

    If velocity = $7F :keybd_event_(#VK_F6,1,0,0) :EndIf
    If velocity = $00 :keybd_event_(#VK_F6,1,#KEYEVENTF_KEYUP,0) :EndIf

    ;if vel = $00 unpress Alt
    If velocity = $00
      keybd_event_(#VK_LMENU,1,0,0) 
      keybd_event_(#VK_LMENU,1,#KEYEVENTF_KEYUP,0) 
    EndIf
    
  ProcedureReturn #True ;Means note processed but error?
EndIf

;==========================================
; ENTER
If nota = 71    
     If velocity = $7F :Callkey(29)=Callkey(29)+16:PressKey(29,Callkey(29)) :EndIf
     If velocity = $00 :Callkey(29)=Callkey(29)-16:PressKey(29,Callkey(29)) :EndIf
EndIf
;==========================================
; STORE 62
If nota = 62    
     If velocity = $7F :Callkey(17)=Callkey(17)+32:PressKey(17,Callkey(17)) :EndIf
     If velocity = $00 :Callkey(17)=Callkey(17)-32:PressKey(17,Callkey(17)) :EndIf
EndIf



;=========================================
; Selecction of  screens...
If nota > 80 And nota < 84       ;Ctrl F1 F2 o F3 Seleccion de pantallas
  
        OpenIcon_(WHnd) 
        SetForegroundWindow_(WHnd) 
        SetActiveWindow_(WHnd)
  
  
  ;if vel = $7F press Ctrl
    If velocity = $7F :keybd_event_(#VK_LCONTROL ,1,0,0):EndIf 
      

    If velocity = $7F :keybd_event_(#VK_F1 + (nota-81),1,0,0) :EndIf
    If velocity = $00 :keybd_event_(#VK_F1 + (nota-81),1,#KEYEVENTF_KEYUP,0) :EndIf

    ;if  vel = $00 unpress Ctrl
    If velocity = $00
      keybd_event_(#VK_LCONTROL,1,0,0) 
      keybd_event_(#VK_LCONTROL,1,#KEYEVENTF_KEYUP,0) 
    EndIf
    ;new= screen number to use in the encoders' code
    Select nota
    Case 81 : ScreenNum = 2 ;(1, 2, 3)
    Case 82 : ScreenNum = 1
    Case 83 : ScreenNum = 3
    EndSelect
    
  ProcedureReturn #True ;Means note processed but error?
EndIf

If nota = 63   ;63    PgUp   
    If velocity = $7F :Callkey(9)=Callkey(9)+64: PressKey (9,Callkey(9)) :EndIf
    If velocity = $00 :Callkey(9)=Callkey(9)-64:PressKey (9,Callkey(9)) :EndIf
  ProcedureReturn #True ;Means note processed but error? 
EndIf

If nota = 64   ;64    PgDn
    If velocity = $7F :Callkey(9)=Callkey(9)+128:PressKey (9,Callkey(9)) :EndIf
    If velocity = $00 :Callkey(9)=Callkey(9)-128:PressKey (9,Callkey(9)) :EndIf
  ProcedureReturn #True ;Means note processed but error? 
EndIf



;=========================================
;Groups of encoders keys
;     61    Ctrl Z (Oops)            63    PgUp
;     62    BackSpace (Clear)        64    PgDn

If nota = 84   ;     77    Escape 
    If velocity = $7F :Callkey(23)=Callkey(23)+32:PressKey(23,Callkey(23)):EndIf
    If velocity = $00 :Callkey(23)=Callkey(23)-32:PressKey(23,Callkey(23)) :EndIf
  ProcedureReturn #True ;Means note processed but error?
EndIf

If nota = 85       ;Ctrl Z (Oops)
     If velocity = $7F :Callkey(31)=Callkey(31)+2:PressKey(31,Callkey(31)) :EndIf
     If velocity = $00 :Callkey(31)=Callkey(31)-2:PressKey(31,Callkey(31)) :EndIf
EndIf

If nota = 86   ;     62    CLEAR
     If velocity = $7F :Callkey(23)=Callkey(23)+128:PressKey(23,Callkey(23)) :EndIf
     If velocity = $00 :Callkey(23)=Callkey(23)-128:PressKey(23,Callkey(23)) :EndIf
EndIf

;==========================================
; TIME 112
If nota = 112  

    If velocity = $7F :Callkey(25)=Callkey(25)+64:PressKey(25,Callkey(25)) :EndIf
    If velocity = $00 :Callkey(25)=Callkey(25)-64:PressKey(25,Callkey(25)) :EndIf
    
  ProcedureReturn #True ;Means note processed but error?

EndIf

;----------------------------------------



;=========================================================================================================================
;=========================================================================================================================
;-----------------news affect by riri CHANNEL 10--------------------------------------------------------------
;=========================================================================================================================
;=========================================================================================================================
;----------------------------------------


Select nota
    
    
;--------------- plus transbo

Case 70
  If velocity = $7F :Callkey(17)=Callkey(17)+1:PressKey(17,Callkey(17)) :EndIf; list
  If velocity = $00 :Callkey(17)=Callkey(17)-1:PressKey(17,Callkey(17)) :EndIf
;==========================================  
Case 87
  If velocity = $7F :Callkey(36)=Callkey(36)+4:PressKey(36,Callkey(36)) :EndIf ; viewpool
  If velocity = $00 :Callkey(36)=Callkey(36)-4:PressKey(36,Callkey(36)) :EndIf
;==========================================
Case 88
  If velocity = $7F :Callkey(25)=Callkey(25)+32:PressKey(25,Callkey(25)) :EndIf ; bo
  If velocity = $00 :Callkey(25)=Callkey(25)-32:PressKey(25,Callkey(25)) :EndIf
;==========================================
Case 89
  If velocity = $7F :Callkey(27)=Callkey(27)+2:PressKey(27,Callkey(27)) :EndIf ; delete
  If velocity = $00 :Callkey(27)=Callkey(27)-2:PressKey(27,Callkey(27)) :EndIf
;==========================================
Case 90
  If velocity = $7F :Callkey(23)=Callkey(23)+2:PressKey(23,Callkey(23)) :EndIf ; move
  If velocity = $00 :Callkey(23)=Callkey(23)-2:PressKey(23,Callkey(23)) :EndIf
;==========================================
Case 91
  If velocity = $7F :Callkey(23)=Callkey(23)+1:PressKey(23,Callkey(23)) :EndIf ; group
  If velocity = $00 :Callkey(23)=Callkey(23)-1:PressKey(23,Callkey(23)) :EndIf
  ;==========================================
  Case 92
  If velocity = $7F :Callkey(36)=Callkey(36)+32:PressKey(36,Callkey(36)) :EndIf ; FADER VUE
  If velocity = $00 :Callkey(36)=Callkey(36)-32:PressKey(36,Callkey(36)) :EndIf
;==========================================


;----------------------------------------
;----------------programmeur 





Case 96    
     If velocity = $7F :Callkey(21)=Callkey(21)+8:PressKey(21,Callkey(21)) :EndIf; 0
     If velocity = $00 :Callkey(21)=Callkey(21)-8:PressKey(21,Callkey(21)) :EndIf
;==========================================
Case 97
     If velocity = $7F :Callkey(31)=Callkey(31)+8:PressKey(31,Callkey(31)) :EndIf; 1
     If velocity = $00 :Callkey(31)=Callkey(31)-8:PressKey(31,Callkey(31)) :EndIf
;==========================================
Case 98
     If velocity = $7F :Callkey(29)=Callkey(29)+8:PressKey(29,Callkey(29)) :EndIf; 2
     If velocity = $00 :Callkey(29)=Callkey(29)-8:PressKey(29,Callkey(29)) :EndIf
;==========================================
Case 99   
     If velocity = $7F :Callkey(27)=Callkey(27)+8:PressKey(27,Callkey(27)) :EndIf; 3
     If velocity = $00 :Callkey(27)=Callkey(27)-8:PressKey(27,Callkey(27)) :EndIf
;==========================================
Case 100    
     If velocity = $7F :Callkey(17)=Callkey(17)+4:PressKey(17,Callkey(17)) :EndIf; 4
     If velocity = $00 :Callkey(17)=Callkey(17)-4:PressKey(17,Callkey(17)) :EndIf
;==========================================
Case 101    
     If velocity = $7F :Callkey(19)=Callkey(19)+4:PressKey(19,Callkey(19)) :EndIf; 5
     If velocity = $00 :Callkey(19)=Callkey(19)-4:PressKey(19,Callkey(19)) :EndIf
;==========================================
Case 102   
     If velocity = $7F :Callkey(21)=Callkey(21)+4:PressKey(21,Callkey(21)) :EndIf; 6
     If velocity = $00 :Callkey(21)=Callkey(21)-4:PressKey(21,Callkey(21)) :EndIf
;==========================================
Case 103    
     If velocity = $7F :Callkey(31)=Callkey(31)+4:PressKey(31,Callkey(31)) :EndIf; 7
     If velocity = $00 :Callkey(31)=Callkey(31)-4:PressKey(31,Callkey(31)) :EndIf
;==========================================
Case 104   
     If velocity = $7F :Callkey(29)=Callkey(29)+4:PressKey(29,Callkey(29)) :EndIf; 8
     If velocity = $00 :Callkey(29)=Callkey(29)-4:PressKey(29,Callkey(29)) :EndIf
;==========================================
Case 105   
     If velocity = $7F :Callkey(27)=Callkey(27)+4:PressKey(27,Callkey(27)) :EndIf; 9
     If velocity = $00 :Callkey(27)=Callkey(27)-4:PressKey(27,Callkey(27)) :EndIf
;==========================================
Case 106   
     If velocity = $7F :Callkey(23)=Callkey(23)+8:PressKey(23,Callkey(23)) :EndIf; .
     If velocity = $00 :Callkey(23)=Callkey(23)-8:PressKey(23,Callkey(23)) :EndIf
;==========================================
Case 107   
     If velocity = $7F :Callkey(19)=Callkey(19)+8:PressKey(19,Callkey(19)) :EndIf; IF
     If velocity = $00 :Callkey(19)=Callkey(19)-8:PressKey(19,Callkey(19)) :EndIf
;==========================================
Case 108    
     If velocity = $7F :Callkey(17)=Callkey(17)+8:PressKey(17,Callkey(17)) :EndIf; AT
     If velocity = $00 :Callkey(17)=Callkey(17)-8:PressKey(17,Callkey(17)) :EndIf
;==========================================
Case 109   
     If velocity = $7F :Callkey(25)=Callkey(25)+8:PressKey(25,Callkey(25)) :EndIf; -
     If velocity = $00 :Callkey(25)=Callkey(25)-8:PressKey(25,Callkey(25)) :EndIf
;==========================================
Case 110  
     If velocity = $7F :Callkey(23)=Callkey(23)+4:PressKey(23,Callkey(23)) :EndIf; THRU
     If velocity = $00 :Callkey(23)=Callkey(23)-4:PressKey(23,Callkey(23)) :EndIf
;==========================================
Case 111   
     If velocity = $7F :Callkey(25)=Callkey(25)+4:PressKey(25,Callkey(25)) :EndIf; +
     If velocity = $00 :Callkey(25)=Callkey(25)-4:PressKey(25,Callkey(25)) :EndIf
;==========================================
Case 113    
     If velocity = $7F :Callkey(29)=Callkey(29)+64:PressKey(29,Callkey(29)) :EndIf; UPDATE
     If velocity = $00 :Callkey(29)=Callkey(29)-64:PressKey(29,Callkey(29)) :EndIf
;==========================================
Case 114    
     If velocity = $7F :Callkey(27)=Callkey(27)+64:PressKey(27,Callkey(27)) :EndIf; EDIT
     If velocity = $00 :Callkey(27)=Callkey(27)-64:PressKey(27,Callkey(27)) :EndIf
;==========================================
Case 115    
     If velocity = $7F :Callkey(21)=Callkey(21)+32:PressKey(21,Callkey(21)) :EndIf; HIGHLIGHT
     If velocity = $00 :Callkey(21)=Callkey(21)-32:PressKey(21,Callkey(21)) :EndIf
;===========================
Case 116
     If velocity = $7F :Callkey(19)=Callkey(19)+32:PressKey(19,Callkey(19)) :EndIf; FULL OPEN
     If velocity = $00 :Callkey(19)=Callkey(19)-32:PressKey(19,Callkey(19)) :EndIf
;===========================
Case 117
     If velocity = $7F :Callkey(21)=Callkey(21)+2:PressKey(21,Callkey(21)) :EndIf; PREVIEW
     If velocity = $00 :Callkey(21)=Callkey(21)-2:PressKey(21,Callkey(21)) :EndIf
;===========================
Case 118
     If velocity = $7F :Callkey(19)=Callkey(19)+128:PressKey(19,Callkey(19)) :EndIf; BLIND
     If velocity = $00 :Callkey(19)=Callkey(19)-128:PressKey(19,Callkey(19)) :EndIf
;===========================
Case 119
     If velocity = $7F :PressKey(21,128) :EndIf; FREEZE
     If velocity = $00 :PressKey(21,0) :EndIf

;=========================================================================================================================
;=========================================================================================================================
;----------------------------------------
;=========================================================================================================================
;=========================================================================================================================
;----------------------------TEST
;=========================================================================================================================
;=========================================================================================================================



Case 120
     If velocity = $7F :ririb.l=(ririb-1) :Debug ririb:PrintN (Str(ririb)):EndIf 
Case 121
  If velocity = $7F
    If ririb=1 : riric=1 :EndIf
    If ririb=2 : riric=2 :EndIf
    If ririb=3 : riric=4 :EndIf
    If ririb=4 : riric=8 :EndIf
    If ririb=5 : riric=16 :EndIf
    If ririb=6 : riric=32 :EndIf
    If ririb=7 : riric=64 :EndIf
    If ririb=8 : riric=128 :EndIf
    If ririb=9 : riric=256 :EndIf
    If ririb=10 : riric=512 :EndIf
    If ririb=11 : ririb=1 :riric=1:EndIf
  PressKey(riria,riric) :PrintN (" range "+Str(riria)+" value "+Str(riric)):EndIf
  
  If velocity = $00 :PressKey(riria,0) :EndIf     
Case 122
     If velocity = $7F :ririb.l=(ririb+1):Debug ririb:PrintN (Str(ririb)) :EndIf
Case 123
     If velocity = $7F :For d=1 To 10:
        If d=1 :PressKey(riria,1) :PrintN (" range "+Str(riria)+" value 1"):Delay (800):EndIf
        If d=2 :PressKey(riria,2) :PrintN (" range "+Str(riria)+" value 2"):Delay (800):EndIf
        If d=3 :PressKey(riria,4) :PrintN (" range "+Str(riria)+" value 4"):Delay (800):EndIf 
        If d=4 :PressKey(riria,8) :PrintN (" range "+Str(riria)+" value 8"):Delay (00):EndIf
        If d=5 :PressKey(riria,16) :PrintN (" range "+Str(riria)+" value 16"):Delay (800):EndIf
        If d=6 :PressKey(riria,32) :PrintN (" range "+Str(riria)+" value 32"):Delay (800):EndIf
        If d=7 :PressKey(riria,64) :PrintN (" range "+Str(riria)+" value 64"):Delay (800):EndIf
        If d=8 :PressKey(riria,128) :PrintN (" range "+Str(riria)+" value 128"):Delay (800):EndIf
        If d=9 :PressKey(riria,256) :PrintN (" range "+Str(riria)+" value 256"):Delay (800):EndIf       
        If d=10 :PressKey(riria,512) :PrintN (" range "+Str(riria)+" value 512"):Delay (800):EndIf 
        
      Next d
        EndIf
             
Case 124
     If velocity = $7F :riria.l=(riria-1):Debug riria:PrintN (Str(riria)):EndIf
Case 125
     If velocity = $7F :riria.l=(riria+1):Debug riria:PrintN (Str(riria)):EndIf
Case 126
     If velocity = $7F :OpenConsole () :EndIf     
Case 127
     If velocity = $7F :riria.l = 0 :Debug riria.l:EndIf
     If velocity = $00 :ririb.l = 0 :Debug ririb.l:EndIf     



;----------------------------------------
;===========================
;---------------------------- SELECTION OF EXECUTORS
;===========================






;----------- BT3
;Executors 1-9 with Alt (button up)
Case 1
     If velocity = $7F :Callkey(2)=Callkey(2)+1:PressKey(2,Callkey(2)) :EndIf
     If velocity = $00 :Callkey(2)=Callkey(2)-1:PressKey(2,Callkey(2)) :EndIf;FADER 1
Case 2
     If velocity = $7F :Callkey(2)=Callkey(2)+8:PressKey(2,Callkey(2)) :EndIf
     If velocity = $00 :Callkey(2)=Callkey(2)-8:PressKey(2,Callkey(2)) :EndIf;FADER 2
Case 3
     If velocity = $7F :Callkey(2)=Callkey(2)+64:PressKey(2,Callkey(2)) :EndIf
     If velocity = $00 :Callkey(2)=Callkey(2)-64:PressKey(2,Callkey(2)) :EndIf;FADER 3
Case 4
     If velocity = $7F :Callkey(1)=Callkey(1)+2:PressKey(1,Callkey(1)) :EndIf
     If velocity = $00 :Callkey(1)=Callkey(1)-2:PressKey(1,Callkey(1)) :EndIf;FADER 4
Case 5
     If velocity = $7F :Callkey(1)=Callkey(1)+16:PressKey(1,Callkey(1)) :EndIf
     If velocity = $00 :Callkey(1)=Callkey(1)-16:PressKey(1,Callkey(1)) :EndIf;FADER 5
Case 6
     If velocity = $7F :Callkey(4)=Callkey(4)+1:PressKey(4,Callkey(4)) :EndIf
     If velocity = $00 :Callkey(4)=Callkey(4)-1:PressKey(4,Callkey(4)) :EndIf;FADER 6
Case 7
     If velocity = $7F :Callkey(4)=Callkey(4)+8:PressKey(4,Callkey(4)) :EndIf
     If velocity = $00 :Callkey(4)=Callkey(4)-8:PressKey(4,Callkey(4)) :EndIf;FADER 7
Case 8
     If velocity = $7F :Callkey(4)=Callkey(4)+64:PressKey(4,Callkey(4)) :EndIf
     If velocity = $00 :Callkey(4)=Callkey(4)-64:PressKey(4,Callkey(4)) :EndIf;FADER 8
Case 9
     If velocity = $7F :Callkey(3)=Callkey(3)+2:PressKey(3,Callkey(3)) :EndIf
     If velocity = $00 :Callkey(3)=Callkey(3)-2:PressKey(3,Callkey(3)) :EndIf;FADER 9
     
;Executors 10-20 with Alt (button up)
Case 10
     If velocity = $7F :Callkey(3)=Callkey(3)+16:PressKey(3,Callkey(3)) :EndIf;FADER 10
     If velocity = $00 :Callkey(3)=Callkey(3)-16:PressKey(3,Callkey(3)) :EndIf
Case 11
     If velocity = $7F :Callkey(6)=Callkey(6)+1:PressKey(6,Callkey(6)) :EndIf;FADER 11
     If velocity = $00 :Callkey(6)=Callkey(6)-1:PressKey(6,Callkey(6)) :EndIf
Case 12
     If velocity = $7F :Callkey(6)=Callkey(6)+8:PressKey(6,Callkey(6)) :EndIf;FADER 12
     If velocity = $00 :Callkey(6)=Callkey(6)-8:PressKey(6,Callkey(6)) :EndIf
Case 13
     If velocity = $7F :Callkey(6)=Callkey(6)+64:PressKey(6,Callkey(6)) :EndIf;FADER 13
     If velocity = $00 :Callkey(6)=Callkey(6)-64:PressKey(6,Callkey(6)) :EndIf
Case 14
     If velocity = $7F :Callkey(5)=Callkey(5)+2:PressKey(5,Callkey(5)) :EndIf;FADER 14
     If velocity = $00 :Callkey(5)=Callkey(5)-2:PressKey(5,Callkey(5)) :EndIf
Case 15
     If velocity = $7F :Callkey(5)=Callkey(5)+16:PressKey(5,Callkey(5)) :EndIf;FADER 15
     If velocity = $00 :Callkey(5)=Callkey(5)-16:PressKey(5,Callkey(5)) :EndIf
Case 16
     If velocity = $7F :Callkey(8)=Callkey(8)+1:PressKey(8,Callkey(8)) :EndIf;FADER 16
     If velocity = $00 :Callkey(8)=Callkey(8)-1:PressKey(8,Callkey(8)) :EndIf
Case 17
     If velocity = $7F :Callkey(8)=Callkey(8)+8:PressKey(8,Callkey(8)) :EndIf;FADER 17
     If velocity = $00 :Callkey(8)=Callkey(8)-8:PressKey(8,Callkey(8)) :EndIf
Case 18
     If velocity = $7F :Callkey(8)=Callkey(8)+64:PressKey(8,Callkey(8)) :EndIf;FADER 18
     If velocity = $00 :Callkey(8)=Callkey(8)-64:PressKey(8,Callkey(8)) :EndIf
Case 19
     If velocity = $7F :Callkey(7)=Callkey(7)+2:PressKey(7,Callkey(7)) :EndIf;FADER 19
     If velocity = $00 :Callkey(7)=Callkey(7)-2:PressKey(7,Callkey(7)) :EndIf
Case 20
     If velocity = $7F :Callkey(7)=Callkey(7)+16:PressKey(7,Callkey(7)) :EndIf;FADER 20
     If velocity = $00 :Callkey(7)=Callkey(7)-16:PressKey(7,Callkey(7)) :EndIf

;----------- BT2     
;Executors 1-9 (notes 21-29)  (center button) 
Case 21
     If velocity = $7F :Callkey(2)=Callkey(2)+2:PressKey(2,Callkey(2)) :EndIf;FADER 1
     If velocity = $00 :Callkey(2)=Callkey(2)-2:PressKey(2,Callkey(2)) :EndIf
Case 22
     If velocity = $7F :Callkey(2)=Callkey(2)+16:PressKey(2,Callkey(2)) :EndIf;FADER 2
     If velocity = $00 :Callkey(2)=Callkey(2)-16:PressKey(2,Callkey(2)) :EndIf
Case 23
     If velocity = $7F :Callkey(2)=Callkey(2)+128:PressKey(2,Callkey(2)) :EndIf;FADER 3
     If velocity = $00 :Callkey(2)=Callkey(2)-128:PressKey(2,Callkey(2)) :EndIf
Case 24
     If velocity = $7F :Callkey(1)=Callkey(1)+4:PressKey(1,Callkey(1)) :EndIf;FADER 4
     If velocity = $00 :Callkey(1)=Callkey(1)-4:PressKey(1,Callkey(1)) :EndIf
Case 25
     If velocity = $7F :Callkey(1)=Callkey(1)+32:PressKey(1,Callkey(1)) :EndIf;FADER 5
     If velocity = $00 :Callkey(1)=Callkey(1)-32:PressKey(1,Callkey(1)) :EndIf
Case 26
     If velocity = $7F :Callkey(4)=Callkey(4)+2:PressKey(4,Callkey(4)) :EndIf;FADER 6
     If velocity = $00 :Callkey(4)=Callkey(4)-2:PressKey(4,Callkey(4)) :EndIf
Case 27
     If velocity = $7F :Callkey(4)=Callkey(4)+16:PressKey(4,Callkey(4)) :EndIf;FADER 7
     If velocity = $00 :Callkey(4)=Callkey(4)-16:PressKey(4,Callkey(4)) :EndIf
Case 28
     If velocity = $7F :Callkey(4)=Callkey(4)+128:PressKey(4,Callkey(4)) :EndIf;FADER 8
     If velocity = $00 :Callkey(4)=Callkey(4)-128:PressKey(4,Callkey(4)) :EndIf
Case 29
     If velocity = $7F :Callkey(3)=Callkey(3)+4:PressKey(3,Callkey(3)) :EndIf;FADER 9
     If velocity = $00 :Callkey(3)=Callkey(3)-4:PressKey(3,Callkey(3)) :EndIf 
     
           
;Executors 10-20 (notas 30-40)  (center button)   
Case 30
     If velocity = $7F :Callkey(3)=Callkey(3)+32:PressKey(3,Callkey(3)) :EndIf;FADER 10
     If velocity = $00 :Callkey(3)=Callkey(3)-32:PressKey(3,Callkey(3)) :EndIf
Case 31
     If velocity = $7F :Callkey(6)=Callkey(6)+2:PressKey(6,Callkey(6)) :EndIf;FADER 11
     If velocity = $00 :Callkey(6)=Callkey(6)-2:PressKey(6,Callkey(6)) :EndIf
Case 32
     If velocity = $7F :Callkey(6)=Callkey(6)+16:PressKey(6,Callkey(6)) :EndIf;FADER 12
     If velocity = $00 :Callkey(6)=Callkey(6)-16:PressKey(6,Callkey(6)) :EndIf
Case 33
     If velocity = $7F :Callkey(6)=Callkey(6)+128:PressKey(6,Callkey(6)) :EndIf;FADER 13
     If velocity = $00 :Callkey(6)=Callkey(6)-128:PressKey(6,Callkey(6)) :EndIf
Case 34
     If velocity = $7F :Callkey(5)=Callkey(5)+4:PressKey(5,Callkey(5)) :EndIf;FADER 14
     If velocity = $00 :Callkey(5)=Callkey(5)-4:PressKey(5,Callkey(5)) :EndIf
Case 35
     If velocity = $7F :Callkey(5)=Callkey(5)+32:PressKey(5,Callkey(5)) :EndIf;FADER 15
     If velocity = $00 :Callkey(5)=Callkey(5)-32:PressKey(5,Callkey(5)) :EndIf
Case 36
     If velocity = $7F :Callkey(8)=Callkey(8)+2:PressKey(8,Callkey(8)) :EndIf;FADER 16
     If velocity = $00 :Callkey(8)=Callkey(8)-2:PressKey(8,Callkey(8)) :EndIf
Case 37
     If velocity = $7F :Callkey(8)=Callkey(8)+16:PressKey(8,Callkey(8)) :EndIf;FADER 17
     If velocity = $00 :Callkey(8)=Callkey(8)-16:PressKey(8,Callkey(8)) :EndIf
Case 38
     If velocity = $7F :Callkey(8)=Callkey(8)+128:PressKey(8,Callkey(8)) :EndIf;FADER 18
     If velocity = $00 :Callkey(8)=Callkey(8)-128:PressKey(8,Callkey(8)) :EndIf
Case 39
     If velocity = $7F :Callkey(7)=Callkey(7)+4:PressKey(7,Callkey(7)) :EndIf;FADER 19
     If velocity = $00 :Callkey(7)=Callkey(7)-4:PressKey(7,Callkey(7)) :EndIf
Case 40
     If velocity = $7F :Callkey(7)=Callkey(7)+32:PressKey(7,Callkey(7)) :EndIf;FADER 20
     If velocity = $00 :Callkey(7)=Callkey(7)-32:PressKey(7,Callkey(7)) :EndIf
     


  


;------------BT1

    
;Executors 1-9 (notas 41-49) (down button)    
Case 41
     If velocity = $7F :Callkey(2)=Callkey(2)+4:PressKey(2,Callkey(2)) :EndIf;FADER 1
     If velocity = $00 :Callkey(2)=Callkey(2)-4:PressKey(2,Callkey(2)) :EndIf
Case 42
     If velocity = $7F :Callkey(2)=Callkey(2)+32:PressKey(2,Callkey(2)) :EndIf;FADER 2
     If velocity = $00 :Callkey(2)=Callkey(2)-32:PressKey(2,Callkey(2)) :EndIf
Case 43
     If velocity = $7F :Callkey(1)=Callkey(1)+1:PressKey(1,Callkey(1)) :EndIf;FADER 3
     If velocity = $00 :Callkey(1)=Callkey(1)-1:PressKey(1,Callkey(1)) :EndIf
Case 44
     If velocity = $7F :Callkey(1)=Callkey(1)+8:PressKey(1,Callkey(1)) :EndIf;FADER 4
     If velocity = $00 :Callkey(1)=Callkey(1)-8:PressKey(1,Callkey(1)) :EndIf
Case 45
     If velocity = $7F :Callkey(1)=Callkey(1)+64:PressKey(1,Callkey(1)) :EndIf;FADER 5
     If velocity = $00 :Callkey(1)=Callkey(1)-64:PressKey(1,Callkey(1)) :EndIf
Case 46
     If velocity = $7F :Callkey(4)=Callkey(4)+4:PressKey(4,Callkey(4)) :EndIf;FADER 6
     If velocity = $00 :Callkey(4)=Callkey(4)-4:PressKey(4,Callkey(4)) :EndIf
Case 47
     If velocity = $7F :Callkey(4)=Callkey(4)+32:PressKey(4,Callkey(4)) :EndIf;FADER 7
     If velocity = $00 :Callkey(4)=Callkey(4)-32:PressKey(4,Callkey(4)) :EndIf
Case 48
     If velocity = $7F :Callkey(3)=Callkey(3)+1:PressKey(3,Callkey(3)) :EndIf;FADER 8
     If velocity = $00 :Callkey(3)=Callkey(3)-1:PressKey(3,Callkey(3)) :EndIf
Case 49
     If velocity = $7F :Callkey(3)=Callkey(3)+8:PressKey(3,Callkey(3)) :EndIf;FADER 9
     If velocity = $00 :Callkey(3)=Callkey(3)-8:PressKey(3,Callkey(3)) :EndIf
     
     
;Executors 10-20 (notes 50-60)  (down button)    
Case 50
     If velocity = $7F :Callkey(3)=Callkey(3)+64:PressKey(3,Callkey(3)) :EndIf;FADER 10
     If velocity = $00 :Callkey(3)=Callkey(3)-64:PressKey(3,Callkey(3)) :EndIf
Case 51
     If velocity = $7F :Callkey(6)=Callkey(6)+4:PressKey(6,Callkey(6)) :EndIf;FADER 11
     If velocity = $00 :Callkey(6)=Callkey(6)-4:PressKey(6,Callkey(6)) :EndIf
Case 52
     If velocity = $7F :Callkey(6)=Callkey(6)+32:PressKey(6,Callkey(6)) :EndIf;FADER 12
     If velocity = $00 :Callkey(6)=Callkey(6)-32:PressKey(6,Callkey(6)) :EndIf
Case 53
     If velocity = $7F :Callkey(5)=Callkey(5)+1:PressKey(5,Callkey(5)) :EndIf;FADER 13
     If velocity = $00 :Callkey(5)=Callkey(5)-1:PressKey(5,Callkey(5)) :EndIf
Case 54
     If velocity = $7F :Callkey(5)=Callkey(5)+8:PressKey(5,Callkey(5)) :EndIf;FADER 14
     If velocity = $00 :Callkey(5)=Callkey(5)-8:PressKey(5,Callkey(5)) :EndIf
Case 55
     If velocity = $7F :Callkey(5)=Callkey(5)+64:PressKey(5,Callkey(5)) :EndIf;FADER 15
     If velocity = $00 :Callkey(5)=Callkey(5)-64:PressKey(5,Callkey(5)) :EndIf
Case 56
     If velocity = $7F :Callkey(8)=Callkey(8)+4:PressKey(8,Callkey(8)) :EndIf;FADER 16
     If velocity = $00 :Callkey(8)=Callkey(8)-4:PressKey(8,Callkey(8)) :EndIf
Case 57
     If velocity = $7F :Callkey(8)=Callkey(8)+32:PressKey(8,Callkey(8)) :EndIf;FADER 17
     If velocity = $00 :Callkey(8)=Callkey(8)-32:PressKey(8,Callkey(8)) :EndIf
Case 58
     If velocity = $7F :Callkey(7)=Callkey(7)+1:PressKey(7,Callkey(7)) :EndIf;FADER 18
     If velocity = $00 :Callkey(7)=Callkey(7)-1:PressKey(7,Callkey(7)) :EndIf
Case 59
     If velocity = $7F :Callkey(7)=Callkey(7)+8:PressKey(7,Callkey(7)) :EndIf;FADER 19
     If velocity = $00 :Callkey(7)=Callkey(7)-8:PressKey(7,Callkey(7)) :EndIf
Case 60
     If velocity = $7F :Callkey(7)=Callkey(7)+64:PressKey(7,Callkey(7)) :EndIf;FADER 20
     If velocity = $00 :Callkey(7)=Callkey(7)-64:PressKey(7,Callkey(7)) :EndIf
     
     
;----------------------------------------     
; 
;=========================================================================================================================
;=========================================================================================================================
;                                                  news affect by riri
;=========================================================================================================================
;=========================================================================================================================
;-------- FONCTION D EXEC
Case 94
     If velocity = $7F :Callkey(40)=Callkey(40)+16:PressKey(40,Callkey(40)) :EndIf ;  tim man preset 
     If velocity = $00 :Callkey(40)=Callkey(40)-16:PressKey(40,Callkey(40)) :EndIf

Case 95
     If velocity = $7F :Callkey(17)=Callkey(17)+128:PressKey(17,Callkey(17)) :EndIf ;  tim man btn.
     If velocity = $00 :Callkey(17)=Callkey(17)-128:PressKey(17,Callkey(17)) :EndIf

Case 74
     If velocity = $7F :Callkey(1)=Callkey(1)+128:PressKey(1,Callkey(1)) :EndIf ;  pause select seq
     If velocity = $00 :Callkey(1)=Callkey(1)-128:PressKey(1,Callkey(1)) :EndIf

Case 75
     If velocity = $7F :Callkey(3)=Callkey(3)+128:PressKey(3,Callkey(3)) :EndIf ;  go- select seq
     If velocity = $00 :Callkey(3)=Callkey(3)-128:PressKey(3,Callkey(3)) :EndIf

Case 76
     If velocity = $7F :Callkey(5)=Callkey(5)+128:PressKey(5,Callkey(5)) :EndIf ;  go+ select seq
     If velocity = $00 :Callkey(5)=Callkey(5)-128:PressKey(5,Callkey(5)) :EndIf

Case 77
     If velocity = $7F :Callkey(5)=Callkey(5)+32:PressKey(25,Callkey(5)) :EndIf ;  black out
     If velocity = $00 :Callkey(5)=Callkey(5)-32:PressKey(25,Callkey(5)) :EndIf

Case 78
     If velocity = $7F :Callkey(19)=Callkey(19)+16:PressKey(19,Callkey(19)) :EndIf ;  previous
     If velocity = $00 :Callkey(19)=Callkey(19)-16:PressKey(19,Callkey(19)) :EndIf

Case 79
     If velocity = $7F :Callkey(21)=Callkey(21)+16:PressKey(21,Callkey(21)) :EndIf ;  set
     If velocity = $00 :Callkey(21)=Callkey(21)-16:PressKey(21,Callkey(21)) :EndIf

Case 80
     If velocity = $7F :Callkey(17)=Callkey(17)+16:PressKey(17,Callkey(17)) :EndIf ;  next
     If velocity = $00 :Callkey(17)=Callkey(17)-16:PressKey(17,Callkey(17)) :EndIf





     EndSelect
     
EndIf     

;----------------------------------------



;=========================================================================================================================
;=========================================================================================================================
;----------------select MIDI channel 11-----------------------------------------------------------------------------------
;=========================================================================================================================
;=========================================================================================================================
;

If channel = #channel2

Select nota



;--------EXEC BOUTON 21-60 ------------------------------
;Executors bouton 21-60
Case 1
     If velocity = $7F :Callkey(30)=Callkey(30)+1:PressKey(30,Callkey(30)) : EndIf  ;ex bt 21
     If velocity = $00 :Callkey(30)=Callkey(30)-1:PressKey(30,Callkey(30)) : EndIf
Case 2
     If velocity = $7F :Callkey(28)=Callkey(28)+1:PressKey(28,Callkey(28)) : EndIf  ;ex bt 22
     If velocity = $00 :Callkey(28)=Callkey(28)-1:PressKey(28,Callkey(28)) : EndIf
Case 3
     If velocity = $7F :Callkey(32)=Callkey(32)+2:PressKey(32,Callkey(32)) : EndIf  ;ex bt 23
     If velocity = $00 :Callkey(32)=Callkey(32)-2:PressKey(32,Callkey(32)) : EndIf
Case 4
     If velocity = $7F :Callkey(28)=Callkey(28)+2:PressKey(28,Callkey(28)) : EndIf  ;ex bt 24
     If velocity = $00 :Callkey(28)=Callkey(28)-2:PressKey(28,Callkey(28)) : EndIf
Case 5
     If velocity = $7F :Callkey(30)=Callkey(30)+4:PressKey(30,Callkey(30)) : EndIf  ;ex bt 25
     If velocity = $00 :Callkey(30)=Callkey(30)-4:PressKey(30,Callkey(30)) : EndIf
Case 6
     If velocity = $7F :Callkey(28)=Callkey(28)+4:PressKey(28,Callkey(28)) : EndIf  ;ex bt 26
     If velocity = $00 :Callkey(28)=Callkey(28)-4:PressKey(28,Callkey(28)) : EndIf
Case 7
     If velocity = $7F :Callkey(32)=Callkey(32)+8:PressKey(32,Callkey(32)) : EndIf  ;ex bt 27
     If velocity = $00 :Callkey(32)=Callkey(32)-8:PressKey(32,Callkey(32)) : EndIf
Case 8
     If velocity = $7F :Callkey(30)=Callkey(30)+8:PressKey(30,Callkey(30)) : EndIf  ;ex bt 28
     If velocity = $00 :Callkey(30)=Callkey(30)-8:PressKey(30,Callkey(30)) : EndIf
Case 9
     If velocity = $7F :Callkey(32)=Callkey(32)+16:PressKey(32,Callkey(32)) :EndIf  ;ex bt 29
     If velocity = $00 :Callkey(32)=Callkey(32)-16:PressKey(32,Callkey(32)) : EndIf
Case 10
     If velocity = $7F :Callkey(30)=Callkey(30)+16:PressKey(30,Callkey(30)) : EndIf  ;ex bt 30
     If velocity = $00 :Callkey(30)=Callkey(30)-16:PressKey(30,Callkey(30)) : EndIf
Case 11
     If velocity = $7F :Callkey(32)=Callkey(32)+1:PressKey(32,Callkey(32)) : EndIf  ;ex bt 31
     If velocity = $00 :Callkey(32)=Callkey(32)-1:PressKey(32,Callkey(32)) : EndIf
Case 12
     If velocity = $7F :Callkey(26)=Callkey(26)+1:PressKey(26,Callkey(26)) : EndIf  ;ex bt 32
     If velocity = $00 :Callkey(26)=Callkey(26)-1:PressKey(26,Callkey(26)) : EndIf
Case 13
     If velocity = $7F :Callkey(30)=Callkey(30)+2:PressKey(30,Callkey(30)) : EndIf  ;ex bt 33
     If velocity = $00 :Callkey(30)=Callkey(30)-2:PressKey(30,Callkey(30)) : EndIf
Case 14
     If velocity = $7F :Callkey(26)=Callkey(26)+2:PressKey(26,Callkey(26)) : EndIf  ;ex bt 34
     If velocity = $00 :Callkey(26)=Callkey(26)-2:PressKey(26,Callkey(26)) : EndIf
Case 15
     If velocity = $7F :Callkey(32)=Callkey(32)+4:PressKey(32,Callkey(32)) : EndIf  ;ex bt 35
     If velocity = $00 :Callkey(32)=Callkey(32)-4:PressKey(32,Callkey(32)) : EndIf
Case 16
     If velocity = $7F :Callkey(26)=Callkey(26)+4:PressKey(26,Callkey(26)) : EndIf  ;ex bt 36
     If velocity = $00 :Callkey(26)=Callkey(26)-4:PressKey(26,Callkey(26)) : EndIf
Case 17
     If velocity = $7F :Callkey(28)=Callkey(28)+8:PressKey(28,Callkey(28)) : EndIf  ;ex bt 37
     If velocity = $00 :Callkey(28)=Callkey(28)-8:PressKey(28,Callkey(28)) : EndIf
Case 18
     If velocity = $7F :Callkey(26)=Callkey(26)+8:PressKey(26,Callkey(26)) : EndIf  ;ex bt 38
     If velocity = $00 :Callkey(26)=Callkey(26)-8:PressKey(26,Callkey(26)) : EndIf
Case 19
     If velocity = $7F :Callkey(28)=Callkey(28)+16:PressKey(28,Callkey(28)) : EndIf  ;ex bt 39
     If velocity = $00 :Callkey(28)=Callkey(28)-16:PressKey(28,Callkey(28)) : EndIf
Case 20
     If velocity = $7F :Callkey(26)=Callkey(26)+16:PressKey(26,Callkey(26)) : EndIf  ;ex bt 40
     If velocity = $00 :Callkey(26)=Callkey(26)-16:PressKey(26,Callkey(26)) : EndIf 
Case 21
     If velocity = $7F :Callkey(18)=Callkey(18)+1:PressKey(18,Callkey(18)) : EndIf  ;ex bt 41
     If velocity = $00 :Callkey(18)=Callkey(18)-1:PressKey(18,Callkey(18)) : EndIf
Case 22
     If velocity = $7F :Callkey(24)=Callkey(24)+1:PressKey(24,Callkey(24)) : EndIf  ;ex bt 42
     If velocity = $00 :Callkey(24)=Callkey(24)-1:PressKey(24,Callkey(24)) : EndIf
Case 23
     If velocity = $7F :Callkey(18)=Callkey(18)+2:PressKey(18,Callkey(18)) : EndIf  ;ex bt 43
     If velocity = $00 :Callkey(18)=Callkey(18)-2:PressKey(18,Callkey(18)) : EndIf
Case 24
     If velocity = $7F :Callkey(24)=Callkey(24)+2:PressKey(24,Callkey(24)) : EndIf  ;ex bt 44
     If velocity = $00 :Callkey(24)=Callkey(24)-2:PressKey(24,Callkey(24)) : EndIf
Case 25
     If velocity = $7F :Callkey(18)=Callkey(18)+4:PressKey(18,Callkey(18)) : EndIf  ;ex bt 45
     If velocity = $00 :Callkey(18)=Callkey(18)-4:PressKey(18,Callkey(18)) : EndIf
Case 26
     If velocity = $7F :Callkey(22)=Callkey(22)+4:PressKey(22,Callkey(22)) : EndIf  ;ex bt 46
     If velocity = $00 :Callkey(22)=Callkey(22)-4:PressKey(22,Callkey(22)) : EndIf
Case 27
     If velocity = $7F :Callkey(24)=Callkey(24)+8:PressKey(24,Callkey(24)) : EndIf  ;ex bt 47
     If velocity = $00 :Callkey(24)=Callkey(24)-8:PressKey(24,Callkey(24)) : EndIf 
Case 28
     If velocity = $7F :Callkey(22)=Callkey(22)+8:PressKey(22,Callkey(22)) : EndIf  ;ex bt 48
     If velocity = $00 :Callkey(22)=Callkey(22)-8:PressKey(22,Callkey(22)) : EndIf 
Case 29
     If velocity = $7F :Callkey(18)=Callkey(18)+16:PressKey(18,Callkey(18)) :EndIf  ;ex bt 49
     If velocity = $00 :Callkey(18)=Callkey(18)-16:PressKey(18,Callkey(18)) : EndIf
Case 30
     If velocity = $7F :Callkey(22)=Callkey(22)+16:PressKey(22,Callkey(22)) : EndIf  ;ex bt 50
     If velocity = $00 :Callkey(22)=Callkey(22)-16:PressKey(22,Callkey(22)) : EndIf   
Case 31
     If velocity = $7F :Callkey(20)=Callkey(20)+1:PressKey(20,Callkey(20)) : EndIf  ;ex bt 51
     If velocity = $00 :Callkey(20)=Callkey(20)-1:PressKey(20,Callkey(20)) : EndIf
Case 32
     If velocity = $7F :Callkey(22)=Callkey(22)+1:PressKey(22,Callkey(22)) : EndIf  ;ex bt 52
     If velocity = $00 :Callkey(22)=Callkey(22)-1:PressKey(22,Callkey(22)) : EndIf
Case 33
     If velocity = $7F :Callkey(20)=Callkey(20)+2:PressKey(20,Callkey(20)) : EndIf  ;ex bt 53
     If velocity = $00 :Callkey(20)=Callkey(20)-2:PressKey(20,Callkey(20)) : EndIf
Case 34
     If velocity = $7F :Callkey(22)=Callkey(22)+2:PressKey(22,Callkey(22)) : EndIf  ;ex bt 54
     If velocity = $00 :Callkey(22)=Callkey(22)-2:PressKey(22,Callkey(22)) : EndIf
Case 35
     If velocity = $7F :Callkey(20)=Callkey(20)+4:PressKey(20,Callkey(20)) : EndIf  ;ex bt 55
     If velocity = $00 :Callkey(20)=Callkey(20)-4:PressKey(20,Callkey(20)) : EndIf
Case 36
     If velocity = $7F :Callkey(24)=Callkey(24)+4:PressKey(24,Callkey(24)) : EndIf  ;ex bt 56
     If velocity = $00 :Callkey(24)=Callkey(24)-4:PressKey(24,Callkey(24)) : EndIf
Case 37
     If velocity = $7F :Callkey(20)=Callkey(20)+8:PressKey(20,Callkey(20)) : EndIf  ;ex bt 57
     If velocity = $00 :Callkey(20)=Callkey(20)-8:PressKey(20,Callkey(20)) : EndIf
Case 38
     If velocity = $7F :Callkey(18)=Callkey(18)+8:PressKey(18,Callkey(18)) : EndIf  ;ex bt 58
     If velocity = $00 :Callkey(18)=Callkey(18)-8:PressKey(18,Callkey(18)) : EndIf
Case 39
     If velocity = $7F :Callkey(20)=Callkey(20)+16:PressKey(20,Callkey(20)) : EndIf  ;ex bt 59
     If velocity = $00 :Callkey(20)=Callkey(20)-16:PressKey(20,Callkey(20)) : EndIf
Case 40
     If velocity = $7F :Callkey(24)=Callkey(24)+16:PressKey(24,Callkey(24)) : EndIf  ;ex bt 60
     If velocity = $00 :Callkey(24)=Callkey(24)-16:PressKey(24,Callkey(24)) : EndIf








;=========================================================================================================================
;=========================================================================================================================
;                                                  FONCTION
;=========================================================================================================================
;=========================================================================================================================
;

Case 41
     If velocity = $7F :Callkey(7)=Callkey(7)+128:PressKey(7,Callkey(7)) :EndIf  ;PAGE BTN -
     If velocity = $00 :Callkey(7)=Callkey(7)-128:PressKey(7,Callkey(7)) :EndIf
Case 42
     If velocity = $7F :Callkey(12)=Callkey(12)+1:PressKey(12,Callkey(12)) :EndIf  ;PAGE BTN +
     If velocity = $00 :Callkey(12)=Callkey(12)-1:PressKey(12,Callkey(12)) :EndIf
Case 43
     If velocity = $7F :Callkey(36)=Callkey(36)+16:PressKey(36,Callkey(36)) :EndIf  ;KEYBRD
     If velocity = $00 :Callkey(36)=Callkey(36)-16:PressKey(36,Callkey(36)) :EndIf
Case 44
     If velocity = $7F :Callkey(36)=Callkey(36)+8:PressKey(36,Callkey(36)) :EndIf  ;BACKGRD
     If velocity = $00 :Callkey(36)=Callkey(36)-8:PressKey(36,Callkey(36)) :EndIf
Case 45
     If velocity = $7F :Callkey(31)=Callkey(31)+32:PressKey(31,Callkey(31)) :EndIf  ;TOOLS
     If velocity = $00 :Callkey(31)=Callkey(31)-32:PressKey(31,Callkey(31)) :EndIf
Case 46
     If velocity = $7F :Callkey(29)=Callkey(29)+32:PressKey(29,Callkey(29)) :EndIf  ;SETUP
     If velocity = $00 :Callkey(29)=Callkey(29)-32:PressKey(29,Callkey(29)) :EndIf
Case 47
     If velocity = $7F :Callkey(36)=Callkey(36)+4:PressKey(36,Callkey(36)) :EndIf  ;VIEWPOOL
     If velocity = $00 :Callkey(36)=Callkey(36)-4:PressKey(36,Callkey(36)) :EndIf
Case 48
     If velocity = $7F :Callkey(27)=Callkey(27)+2:PressKey(27,Callkey(27)) :EndIf  ;DELETE
     If velocity = $00 :Callkey(27)=Callkey(27)-2:PressKey(27,Callkey(27)) :EndIf
Case 49
     If velocity = $7F :Callkey(19)=Callkey(19)+2:PressKey(19,Callkey(19)) :EndIf  ;COPY
     If velocity = $00 :Callkey(19)=Callkey(19)-2:PressKey(19,Callkey(19)) :EndIf
Case 50
     If velocity = $7F :Callkey(23)=Callkey(23)+2:PressKey(23,Callkey(23)) :EndIf  ;MOVE
     If velocity = $00 :Callkey(23)=Callkey(23)-2:PressKey(23,Callkey(23)) :EndIf
Case 51
     If velocity = $7F :Callkey(19)=Callkey(19)+64:PressKey(19,Callkey(19)) :EndIf  ;VIEW
     If velocity = $00 :Callkey(19)=Callkey(19)-64:PressKey(19,Callkey(19)) :EndIf
Case 52
     If velocity = $7F :Callkey(21)=Callkey(21)+64:PressKey(21,Callkey(21)) :EndIf  ;EFFECT
     If velocity = $00 :Callkey(21)=Callkey(21)-64:PressKey(21,Callkey(21)) :EndIf
Case 53
     If velocity = $7F :Callkey(31)=Callkey(31)+64:PressKey(31,Callkey(31)) :EndIf  ;GOTO
     If velocity = $00 :Callkey(31)=Callkey(31)-64:PressKey(31,Callkey(31)) :EndIf
Case 54
     If velocity = $7F :Callkey(29)=Callkey(29)+2:PressKey(29,Callkey(29)) :EndIf  ;ASSIGN
     If velocity = $00 :Callkey(29)=Callkey(29)-2:PressKey(29,Callkey(29)) :EndIf
Case 55
     If velocity = $7F :Callkey(25)=Callkey(25)+1:PressKey(25,Callkey(25)) :EndIf  ;PAGE
     If velocity = $00 :Callkey(25)=Callkey(25)-1:PressKey(25,Callkey(25)) :EndIf
Case 56
     If velocity = $7F :Callkey(17)=Callkey(17)+64:PressKey(17,Callkey(17)) :EndIf  ;MACRO 
     If velocity = $00 :Callkey(17)=Callkey(17)-64:PressKey(17,Callkey(17)) :EndIf
Case 57
     If velocity = $7F :Callkey(23)=Callkey(23)+64:PressKey(23,Callkey(23)) :EndIf  ;PRESET
     If velocity = $00 :Callkey(23)=Callkey(23)-64:PressKey(23,Callkey(23)) :EndIf
Case 58
     If velocity = $7F :Callkey(25)=Callkey(25)+2:PressKey(25,Callkey(25)) :EndIf  ;HELP
     If velocity = $00 :Callkey(25)=Callkey(25)-2:PressKey(25,Callkey(25)) :EndIf
Case 59
     If velocity = $7F :Callkey(29)=Callkey(29)+1:PressKey(29,Callkey(29)) :EndIf  ;SEQ
     If velocity = $00 :Callkey(29)=Callkey(29)-1:PressKey(29,Callkey(29)) :EndIf
Case 60
     If velocity = $7F :Callkey(27)=Callkey(27)+1:PressKey(27,Callkey(27)) :EndIf  ;CUE
     If velocity = $00 :Callkey(27)=Callkey(27)-1:PressKey(27,Callkey(27)) :EndIf
Case 61
     If velocity = $7F :Callkey(31)=Callkey(31)+1:PressKey(31,Callkey(31)) :EndIf  ;EXEC
     If velocity = $00 :Callkey(31)=Callkey(31)-1:PressKey(31,Callkey(31)) :EndIf
Case 62
     If velocity = $7F :Callkey(17)=Callkey(17)+2:PressKey(17,Callkey(17)) :EndIf  ;ALIGN
     If velocity = $00 :Callkey(17)=Callkey(17)-2:PressKey(17,Callkey(17)) :EndIf 
Case 63
     If velocity = $7F :Callkey(19)=Callkey(19)+1:PressKey(19,Callkey(19)) :EndIf  ;CHANNEL
     If velocity = $00 :Callkey(19)=Callkey(19)-1:PressKey(19,Callkey(19)) :EndIf 
Case 64
     If velocity = $7F :Callkey(21)=Callkey(21)+1:PressKey(21,Callkey(21)) :EndIf  ;FIXTURE
     If velocity = $00 :Callkey(21)=Callkey(21)-1:PressKey(21,Callkey(21)) :EndIf
Case 65
     If velocity = $7F :Callkey(23)=Callkey(23)+1:PressKey(23,Callkey(23)) :EndIf  ;GROUP
     If velocity = $00 :Callkey(23)=Callkey(23)-1:PressKey(23,Callkey(23)) :EndIf
Case 66
     If velocity = $7F :Callkey(27)=Callkey(27)+32:PressKey(27,Callkey(27)) :EndIf  ;BACKUP
     If velocity = $00 :Callkey(27)=Callkey(27)-32:PressKey(27,Callkey(27)) :EndIf
Case 67
     If velocity = $7F :Callkey(10)=Callkey(10)+1:PressKey(10,Callkey(10)) :EndIf  ;FIX
     If velocity = $00 :Callkey(10)=Callkey(10)-1:PressKey(10,Callkey(10)) :EndIf
Case 68
     If velocity = $7F :Callkey(10)=Callkey(10)+2:PressKey(10,Callkey(10)) :EndIf  ;SELECT
     If velocity = $00 :Callkey(10)=Callkey(10)-2:PressKey(10,Callkey(10)) :EndIf
Case 69
     If velocity = $7F :Callkey(9)=Callkey(9)+1:PressKey(9,Callkey(9)) :EndIf  ;OFF
     If velocity = $00 :Callkey(9)=Callkey(9)-1:PressKey(9,Callkey(9)) :EndIf
Case 70
     If velocity = $7F :Callkey(10)=Callkey(10)+4:PressKey(10,Callkey(10)) :EndIf  ;TEMP
     If velocity = $00 :Callkey(10)=Callkey(10)-4:PressKey(10,Callkey(10)) :EndIf
Case 71
     If velocity = $7F :Callkey(10)=Callkey(10)+8:PressKey(10,Callkey(10)) :EndIf  ;TOP
     If velocity = $00 :Callkey(10)=Callkey(10)-8:PressKey(10,Callkey(10)) :EndIf
Case 72
     If velocity = $7F :Callkey(9)=Callkey(9)+2:PressKey(9,Callkey(9)) :EndIf  ;ON
     If velocity = $00 :Callkey(9)=Callkey(9)-2:PressKey(9,Callkey(9)) :EndIf
Case 73
     If velocity = $7F :Callkey(10)=Callkey(10)+16:PressKey(10,Callkey(10)) :EndIf  ;<<<
     If velocity = $00 :Callkey(10)=Callkey(10)-16:PressKey(10,Callkey(10)) :EndIf
Case 74
     If velocity = $7F :Callkey(9)=Callkey(9)+4:PressKey(9,Callkey(9)) :EndIf  ;LEARN
     If velocity = $00 :Callkey(9)=Callkey(9)-4:PressKey(9,Callkey(9)) :EndIf
Case 75
     If velocity = $7F :Callkey(9)=Callkey(9)+8:PressKey(9,Callkey(9)) :EndIf  ;>>>
     If velocity = $00 :Callkey(9)=Callkey(9)-8:PressKey(9,Callkey(9)) :EndIf
Case 76
     If velocity = $7F :Callkey(10)=Callkey(10)+32:PressKey(10,Callkey(10)) :EndIf  ;GO -
     If velocity = $00 :Callkey(10)=Callkey(10)-32:PressKey(10,Callkey(10)) :EndIf
Case 77
     If velocity = $7F :Callkey(9)=Callkey(9)+16:PressKey(9,Callkey(9)) :EndIf  ;PAUSE
     If velocity = $00 :Callkey(9)=Callkey(9)-16:PressKey(9,Callkey(9)) :EndIf
Case 78
     If velocity = $7F :Callkey(9)=Callkey(9)+32:PressKey(9,Callkey(9)) :EndIf  ;GO +
     If velocity = $00 :Callkey(9)=Callkey(9)-32:PressKey(9,Callkey(9)) :EndIf

Case 79
     If velocity = $7F :Callkey(34)=Callkey(34)+4:PressKey(34,Callkey(34)) :EndIf  ; VIEW BT 7
     If velocity = $00 :Callkey(34)=Callkey(34)-4:PressKey(34,Callkey(34)) :EndIf
Case 80
     If velocity = $7F :Callkey(34)=Callkey(34)+8:PressKey(34,Callkey(34)) :EndIf  ; VIEW VT 8
     If velocity = $00 :Callkey(34)=Callkey(34)-8:PressKey(34,Callkey(34)) :EndIf
Case 81
     If velocity = $7F :Callkey(34)=Callkey(34)+16:PressKey(34,Callkey(34)) :EndIf  ; VIEW BT 9
     If velocity = $00 :Callkey(34)=Callkey(34)-16:PressKey(34,Callkey(34)) :EndIf
Case 82
     If velocity = $7F :Callkey(34)=Callkey(34)+32:PressKey(34,Callkey(34)) :EndIf  ; VIEW BT 10
     If velocity = $00 :Callkey(34)=Callkey(34)-32:PressKey(34,Callkey(34)) :EndIf
Case 83
     If velocity = $7F :Callkey(34)=Callkey(34)+64:PressKey(34,Callkey(34)) :EndIf  ; VIEW BT 11
     If velocity = $00 :Callkey(34)=Callkey(34)-64:PressKey(34,Callkey(34)) :EndIf
Case 84
     If velocity = $7F :Callkey(34)=Callkey(34)+128:PressKey(34,Callkey(34)) :EndIf  ; VIEW BT 12
     If velocity = $00 :Callkey(34)=Callkey(34)-128:PressKey(34,Callkey(34)) :EndIf

Case 85
     If velocity = $7F :Callkey(38)=Callkey(38)+4:PressKey(38,Callkey(38)) :EndIf  ; VIEW BT 13
     If velocity = $00 :Callkey(38)=Callkey(38)-4:PressKey(38,Callkey(38)) :EndIf
Case 86
     If velocity = $7F :Callkey(38)=Callkey(38)+8:PressKey(38,Callkey(38)) :EndIf  ; VIEW BT 14
     If velocity = $00 :Callkey(38)=Callkey(38)-8:PressKey(38,Callkey(38)) :EndIf
Case 87
     If velocity = $7F :Callkey(38)=Callkey(38)+16:PressKey(38,Callkey(38)) :EndIf  ; VIEW BT 15
     If velocity = $00 :Callkey(38)=Callkey(38)-16:PressKey(38,Callkey(38)) :EndIf
Case 88
     If velocity = $7F :Callkey(38)=Callkey(38)+32:PressKey(38,Callkey(38)) :EndIf  ; VIEW BT 16
     If velocity = $00 :Callkey(38)=Callkey(38)-32:PressKey(38,Callkey(38)) :EndIf
Case 89
     If velocity = $7F :Callkey(38)=Callkey(38)+64:PressKey(38,Callkey(38)) :EndIf  ; VIEW BT 17
     If velocity = $00 :Callkey(38)=Callkey(38)-64:PressKey(38,Callkey(38)) :EndIf
Case 90
     If velocity = $7F :Callkey(38)=Callkey(38)+128:PressKey(38,Callkey(38)) :EndIf  ; VIEW BT 18
     If velocity = $00 :Callkey(38)=Callkey(38)-128:PressKey(38,Callkey(38)) :EndIf

     
     
     
;--------REM 1-16 ------------------------------     
     
Case 91
     If velocity = $7F :Callkey(14)=Callkey(14)+1: PressKey (14,Callkey(14)) :EndIf    ;rem 1
     If velocity = $00 :Callkey(14)=Callkey(14)-1: PressKey (14,Callkey(14)) :EndIf
Case 92
     If velocity = $7F :Callkey(14)=Callkey(14)+2: PressKey (14,Callkey(14)) :EndIf    ;rem 2
     If velocity = $00 :Callkey(14)=Callkey(14)-2: PressKey (14,Callkey(14)) :EndIf
Case 93
     If velocity = $7F :Callkey(14)=Callkey(14)+4: PressKey (14,Callkey(14)) :EndIf    ;rem 3
     If velocity = $00 :Callkey(14)=Callkey(14)-4: PressKey (14,Callkey(14)) :EndIf
Case 94
     If velocity = $7F :Callkey(14)=Callkey(14)+8: PressKey (14,Callkey(14)) :EndIf    ;rem 4
     If velocity = $00 :Callkey(14)=Callkey(14)-8: PressKey (14,Callkey(14)) :EndIf       
Case 95
     If velocity = $7F :Callkey(14)=Callkey(14)+16: PressKey (14,Callkey(14)) :EndIf   ;rem 5
     If velocity = $00 :Callkey(14)=Callkey(14)-16: PressKey (14,Callkey(14)) :EndIf
Case 96
     If velocity = $7F :Callkey(14)=Callkey(14)+32: PressKey (14,Callkey(14)) :EndIf   ;rem 6
     If velocity = $00 :Callkey(14)=Callkey(14)-32: PressKey (14,Callkey(14)) :EndIf
Case 97
     If velocity = $7F :Callkey(14)=Callkey(14)+64: PressKey (14,Callkey(14)) :EndIf   ;rem 7
     If velocity = $00 :Callkey(14)=Callkey(14)-64: PressKey (14,Callkey(14)) :EndIf
Case 98
     If velocity = $7F :Callkey(14)=Callkey(14)+128: PressKey (14,Callkey(14)) :EndIf  ;rem 8 
     If velocity = $00 :Callkey(14)=Callkey(14)-128: PressKey (14,Callkey(14)) :EndIf
Case 99
     If velocity = $7F :Callkey(13)=Callkey(13)+1: PressKey (13,Callkey(13)) :EndIf    ;rem 9
     If velocity = $00 :Callkey(13)=Callkey(13)-1: PressKey (13,Callkey(13)) :EndIf
Case 100
     If velocity = $7F :Callkey(13)=Callkey(13)+2: PressKey (13,Callkey(13)) :EndIf    ;rem 10
     If velocity = $00 :Callkey(13)=Callkey(13)-2: PressKey (13,Callkey(13)) :EndIf
Case 101
     If velocity = $7F :Callkey(13)=Callkey(13)+4: PressKey (13,Callkey(13)) :EndIf    ;rem 11
     If velocity = $00 :Callkey(13)=Callkey(13)-4: PressKey (13,Callkey(13)) :EndIf
Case 102
     If velocity = $7F :Callkey(13)=Callkey(13)+8: PressKey (13,Callkey(13)) :EndIf    ;rem 12
     If velocity = $00 :Callkey(13)=Callkey(13)-8: PressKey (13,Callkey(13)) :EndIf
Case 103
     If velocity = $7F :Callkey(13)=Callkey(13)+16: PressKey (13,Callkey(13)) :EndIf   ;rem 13
     If velocity = $00 :Callkey(13)=Callkey(13)-16: PressKey (13,Callkey(13)) :EndIf
Case 104
     If velocity = $7F :Callkey(13)=Callkey(13)+32: PressKey (13,Callkey(13)) :EndIf   ;rem 14
     If velocity = $00 :Callkey(13)=Callkey(13)-32: PressKey (13,Callkey(13)) :EndIf
Case 105
     If velocity = $7F :Callkey(13)=Callkey(13)+64: PressKey (13,Callkey(13)) :EndIf   ;rem 15
     If velocity = $00 :Callkey(13)=Callkey(13)-64: PressKey (13,Callkey(13)) :EndIf
Case 106
     If velocity = $7F :Callkey(13)=Callkey(13)+128: PressKey (13,Callkey(13)) :EndIf  ;rem 16
     If velocity = $00 :Callkey(13)=Callkey(13)-128: PressKey (13,Callkey(13)) :EndIf     
     
     
;-------- NEW ------------------------------     
     
Case 107
     If velocity = $7F :Callkey(17)=Callkey(17)+1: PressKey (17,Callkey(17)) :EndIf  ;LIST
     If velocity = $00 :Callkey(17)=Callkey(17)-1: PressKey (17,Callkey(17)) :EndIf 
Case 108
     If velocity = $7F :Callkey(16)=Callkey(16)+1: PressKey (16,Callkey(16)) :EndIf  ;PW_GOOD
     If velocity = $00 :Callkey(16)=Callkey(16)-1: PressKey (16,Callkey(16)) :EndIf      
Case 109
     If velocity = $7F :Callkey(16)=Callkey(16)+2: PressKey (16,Callkey(16)) :EndIf  ;PW_OFF
     If velocity = $00 :Callkey(16)=Callkey(16)-2: PressKey (16,Callkey(16)) :EndIf 
Case 110
     If velocity = $7F :Callkey(16)=Callkey(16)+4: PressKey (16,Callkey(16)) :EndIf  ;SND_TRIG
     If velocity = $00 :Callkey(16)=Callkey(16)-4: PressKey (16,Callkey(16)) :EndIf 
Case 111
     If velocity = $7F :Callkey(16)=Callkey(16)+16: PressKey (16,Callkey(16)) :EndIf  ;PW_LOST
     If velocity = $00 :Callkey(16)=Callkey(16)-16: PressKey (16,Callkey(16)) :EndIf      
Case 112
     If velocity = $7F :Callkey(27)=Callkey(27)+16: PressKey (27,Callkey(27)) :EndIf  ;MODE PT
     If velocity = $00 :Callkey(27)=Callkey(27)-16: PressKey (27,Callkey(27)) :EndIf      
Case 113
     If velocity = $7F :Callkey(25)=Callkey(25)+128: PressKey (25,Callkey(25)) :EndIf  ;ENC 4 PUSH
     If velocity = $00 :Callkey(25)=Callkey(25)-128: PressKey (25,Callkey(25)) :EndIf      
Case 114
     If velocity = $7F :Callkey(27)=Callkey(27)+128: PressKey (27,Callkey(27)) :EndIf  ;ENC 3 PUSH
     If velocity = $00 :Callkey(27)=Callkey(27)-128: PressKey (27,Callkey(27)) :EndIf      
Case 115
     If velocity = $7F :Callkey(29)=Callkey(29)+128: PressKey (29,Callkey(29)) :EndIf  ;ENC 2 PUSH 
     If velocity = $00 :Callkey(29)=Callkey(29)-128: PressKey (29,Callkey(29)) :EndIf 
Case 116
     If velocity = $7F :Callkey(31)=Callkey(31)+128: PressKey (31,Callkey(31)) :EndIf  ;ENC 1 PUSH 
     If velocity = $00 :Callkey(31)=Callkey(31)-128: PressKey (31,Callkey(31)) :EndIf 
Case 117
     If velocity = $7F :Callkey(36)=Callkey(36)+32: PressKey (36,Callkey(36)) :EndIf  ;LIST FADER
     If velocity = $00 :Callkey(36)=Callkey(36)-32: PressKey (36,Callkey(36)) :EndIf 
Case 118
     If velocity = $7F :Callkey(37)=Callkey(37)+1: PressKey (37,Callkey(37)) :EndIf  ;EXT VGA 1
     If velocity = $00 :Callkey(37)=Callkey(37)-1: PressKey (37,Callkey(37)) :EndIf 
Case 119
     If velocity = $7F :Callkey(37)=Callkey(37)+2: PressKey (37,Callkey(37)) :EndIf  ;EXT VGA 2
     If velocity = $00 :Callkey(37)=Callkey(37)-2: PressKey (37,Callkey(37)) :EndIf     
Case 120
     If velocity = $7F :Callkey(40)=Callkey(40)+2: PressKey (40,Callkey(40)) :EndIf  ;SCROLL 2
     If velocity = $00 :Callkey(40)=Callkey(40)-2: PressKey (40,Callkey(40)) :EndIf 
Case 121
     If velocity = $7F :Callkey(40)=Callkey(40)+4: PressKey (40,Callkey(40)) :EndIf  ;SCROLL 1
     If velocity = $00 :Callkey(40)=Callkey(40)-4: PressKey (40,Callkey(40)) :EndIf 
Case 122
     If velocity = $7F :Callkey(40)=Callkey(40)+8: PressKey (40,Callkey(40)) :EndIf  ;SCROLL 3
     If velocity = $00 :Callkey(40)=Callkey(40)-8: PressKey (40,Callkey(40)) :EndIf 

     
     
Case 123 
      For AuxIndex = 0 To 22
            
           
                ;Copy values
                Behringer_FaderValues(AuxIndex) = MAonPC_FaderValues(AuxIndex)
                ;send data to Behringer unit WE MUST TO PROCESS BACK 255 TO 127!!
                AuxVal = MAonPC_FaderValues(AuxIndex) & $FF ; to convert the signed byte into unsigned byte!
                AuxVal = AuxVal/2
                midimsg = $B0 + ((AuxIndex + 1) * $100) + (AuxVal * $10000) + #channel
               
               
              
                midiOutShortMsg_(my_hMidiOut, midimsg)
                midiOutShortMsg_(my_hMidiOut2, midimsg)
                midiOutShortMsg_(my_hMidiOut4, midimsg)

                Debug " ***RELOAD*** expédié vers MIDI "+ MAonPC_FaderValues(AuxIndex) +" sont "+AuxVal+ " au Fader num " + AuxIndex+1
               
                

        Next AuxIndex
     

  EndSelect


EndIf
;-------------------------------

;---------------------LAUNCH PAD


;=========================================================================================================================
;=========================================================================================================================
;----------------select MIDI channel 1----launchpad-----------------------------------------------------------------------
;=========================================================================================================================
;=========================================================================================================================
;

If channel = #channel1
Debug "#channel1"
Debug "nota: "+ Hex(nota)
; If nota = 120 ; fader view 
;     Debug "fader view 78" 
;     If velocity = $7F :keybd_event_(#VK_LMENU ,1,0,0):EndIf 
; 
;     If velocity = $7F :keybd_event_(#VK_F3 ,1,0,0) :midiOutShortMsg_(my_hMidiOut3,($7F68B0)):EndIf
;     If velocity = $00 :keybd_event_(#VK_F3,1,#KEYEVENTF_KEYUP,0) :EndIf
;     If velocity = $00
;       keybd_event_(#VK_LMENU,1,0,0) 
;       keybd_event_(#VK_LMENU,1,#KEYEVENTF_KEYUP,0)
;       midiOutShortMsg_(my_hMidiOut3,($1568B0)) 
;     EndIf
;     ProcedureReturn #True ;Means note processed but error?
;     EndIf
;     
; If nota = 121 ; ex btn view
;   Debug "ex btn view 79" 
;     If velocity = $7F :keybd_event_(#VK_LMENU ,1,0,0):EndIf 
;     If velocity = $7F :keybd_event_(#VK_F5,1,0,0) :midiOutShortMsg_(my_hMidiOut3,($7F69B0)):EndIf
; 
;     If velocity = $00 :keybd_event_(#VK_F5,1,#KEYEVENTF_KEYUP,0) :EndIf
;     If velocity = $00 :keybd_event_(#VK_LMENU,1,#KEYEVENTF_KEYUP,0) :midiOutShortMsg_(my_hMidiOut3,($1569B0)):EndIf
;     
;     ProcedureReturn #True ;Means note processed but error?
;   EndIf
  


Select nota

Case 1 ; fader view 
    If velocity = $7F :keybd_event_(#VK_LMENU ,1,0,0):EndIf 

    If velocity = $7F :keybd_event_(#VK_F3 ,1,0,0) :midiOutShortMsg_(my_hMidiOut3,($7F68B0)):EndIf
    If velocity = $00 :keybd_event_(#VK_F3,1,#KEYEVENTF_KEYUP,0) :EndIf
    If velocity = $00
      keybd_event_(#VK_LMENU,1,0,0) 
      keybd_event_(#VK_LMENU,1,#KEYEVENTF_KEYUP,0)
      midiOutShortMsg_(my_hMidiOut3,($1568B0)) 
    EndIf
ProcedureReturn #True ;Means note processed but error?
    
Case 2 ; ex btn view
    If velocity = $7F :keybd_event_(#VK_LMENU ,1,0,0):EndIf 
    If velocity = $7F :keybd_event_(#VK_F5,1,0,0) :midiOutShortMsg_(my_hMidiOut3,($7F69B0)):EndIf

    If velocity = $00 :keybd_event_(#VK_F5,1,#KEYEVENTF_KEYUP,0) :EndIf
    If velocity = $00 :keybd_event_(#VK_LMENU,1,#KEYEVENTF_KEYUP,0) :midiOutShortMsg_(my_hMidiOut3,($1569B0)):EndIf
    
  ProcedureReturn #True ;Means note processed but error?
    
;---------- retour des speed 1 -> 4 gma -> launchpad

Case 11            
            If velocity = $7F : midiOutShortMsg_(my_hMidiOut3,($5F6CB0)) :EndIf ;couleur orange
            If velocity = $00 : midiOutShortMsg_(my_hMidiOut3,($056CB0)) :EndIf ;couleur rouge
            If velocity = $7F : midiOutShortMsg_(my_hMidiOut,($7F78B0)):Debug " retour on" :EndIf ;couleur orange
            If velocity = $00 : midiOutShortMsg_(my_hMidiOut,($0078B0)):Debug " retour off" :EndIf ;couleur rouge
Case 12            
            If velocity = $7F : midiOutShortMsg_(my_hMidiOut3,($5F6DB0)) :EndIf ;orange
            If velocity = $00 : midiOutShortMsg_(my_hMidiOut3,($056DB0)) :EndIf ;rouge
Case 13            
            If velocity = $7F : midiOutShortMsg_(my_hMidiOut3,($5F6EB0)) :EndIf ;orange
            If velocity = $00 : midiOutShortMsg_(my_hMidiOut3,($056EB0)) :EndIf ;rouge
Case 14            
            If velocity = $7F : midiOutShortMsg_(my_hMidiOut3,($5F6FB0)) :EndIf ;orange
            If velocity = $00 : midiOutShortMsg_(my_hMidiOut3,($056FB0)) :EndIf ;rouge
            





;----------------------page fixe du gma
Case 9
     If velocity = $7F :Callkey(14)=Callkey(14)+1: PressKey (14,Callkey(14)) :midiOutShortMsg_(my_hMidiOut3,($7F0090)) :EndIf    ;rem 1
     If velocity = $00 :Callkey(14)=Callkey(14)-1: PressKey (14,Callkey(14)) :midiOutShortMsg_(my_hMidiOut3,($200090)) :EndIf
Case 1
     If velocity = $7F :Callkey(14)=Callkey(14)+2: PressKey (14,Callkey(14)) :midiOutShortMsg_(my_hMidiOut3,($7F0190)) :EndIf    ;rem 2
     If velocity = $00 :Callkey(14)=Callkey(14)-2: PressKey (14,Callkey(14)) :midiOutShortMsg_(my_hMidiOut3,($200190)) :EndIf
Case 2
     If velocity = $7F :Callkey(14)=Callkey(14)+4: PressKey (14,Callkey(14)) :midiOutShortMsg_(my_hMidiOut3,($7F0290)) :EndIf    ;rem 3
     If velocity = $00 :Callkey(14)=Callkey(14)-4: PressKey (14,Callkey(14)) :midiOutShortMsg_(my_hMidiOut3,($120290)) :EndIf
Case 3
     If velocity = $7F :Callkey(14)=Callkey(14)+8: PressKey (14,Callkey(14)) :midiOutShortMsg_(my_hMidiOut3,($7F0390)) :EndIf    ;rem 4
     If velocity = $00 :Callkey(14)=Callkey(14)-8: PressKey (14,Callkey(14)) :midiOutShortMsg_(my_hMidiOut3,($120390)) :EndIf
     
Case 4
     If velocity = $7F :Callkey(8)=Callkey(8)+16: PressKey (8,Callkey(8)) :midiOutShortMsg_(my_hMidiOut3,($7F0490)) :EndIf   ;btn m x17 SPEED 1*2
     If velocity = $00 :Callkey(8)=Callkey(8)-16: PressKey (8,Callkey(8)) :midiOutShortMsg_(my_hMidiOut3,($4F0490)) :EndIf   
Case 5
     If velocity = $7F :Callkey(8)=Callkey(8)+128: PressKey (8,Callkey(8)) :midiOutShortMsg_(my_hMidiOut3,($7F0590)) :EndIf   ;btn m x18 SPEED 2*2
     If velocity = $00 :Callkey(8)=Callkey(8)-128: PressKey (8,Callkey(8)) :midiOutShortMsg_(my_hMidiOut3,($4F0590)) :EndIf
Case 6
     If velocity = $7F :Callkey(7)=Callkey(7)+4: PressKey (7,Callkey(7)) :midiOutShortMsg_(my_hMidiOut3,($7F0690)) :EndIf   ;btn m x19 SPEED 3*2
     If velocity = $00 :Callkey(7)=Callkey(7)-4: PressKey (7,Callkey(7)) :midiOutShortMsg_(my_hMidiOut3,($4F0690)) :EndIf
Case 7
     If velocity = $7F :Callkey(7)=Callkey(7)+32: PressKey (7,Callkey(7)) :midiOutShortMsg_(my_hMidiOut3,($7F0790)) :EndIf   ;btn m x20 SPEED 4*2
     If velocity = $00 :Callkey(7)=Callkey(7)-32: PressKey (7,Callkey(7)) :midiOutShortMsg_(my_hMidiOut3,($4F0790)) :EndIf
     
Case 8
     If velocity = $7F :Callkey(30)=Callkey(30)+16: PressKey (30,Callkey(30)) :midiOutShortMsg_(my_hMidiOut3,($7F0890)) :EndIf    ; exe x30
     If velocity = $00 :Callkey(30)=Callkey(30)-16: PressKey (30,Callkey(30)) :midiOutShortMsg_(my_hMidiOut3,($100890)) :EndIf
     
     
     
     
     
Case 16
     If velocity = $7F :Callkey(14)=Callkey(14)+16: PressKey (14,Callkey(14)):midiOutShortMsg_(my_hMidiOut3,($7F1090)) :EndIf    ;rem 5
     If velocity = $00 :Callkey(14)=Callkey(14)-16: PressKey (14,Callkey(14)) :midiOutShortMsg_(my_hMidiOut3,($201090)) :EndIf
Case 17
     If velocity = $7F :Callkey(14)=Callkey(14)+32: PressKey (14,Callkey(14)) :midiOutShortMsg_(my_hMidiOut3,($7F1190)) :EndIf    ;rem 6
     If velocity = $00 :Callkey(14)=Callkey(14)-32: PressKey (14,Callkey(14)) :midiOutShortMsg_(my_hMidiOut3,($201190)) :EndIf
Case 18
     If velocity = $7F :Callkey(14)=Callkey(14)+64: PressKey (14,Callkey(14)) :midiOutShortMsg_(my_hMidiOut3,($7F1290)) :EndIf    ;rem 7
     If velocity = $00 :Callkey(14)=Callkey(14)-64: PressKey (14,Callkey(14)) :midiOutShortMsg_(my_hMidiOut3,($121290)) :EndIf
Case 19
     If velocity = $7F :Callkey(14)=Callkey(14)+128: PressKey (14,Callkey(14)) :midiOutShortMsg_(my_hMidiOut3,($7F1390)) :EndIf    ;rem 8 
     If velocity = $00 :Callkey(14)=Callkey(14)-128: PressKey (14,Callkey(14)) :midiOutShortMsg_(my_hMidiOut3,($121390)) :EndIf
     
Case 20
     If velocity = $7F :Callkey(8)=Callkey(8)+32: PressKey (8,Callkey(8)) :midiOutShortMsg_(my_hMidiOut3,($7F1490)) :EndIf    ;btn b x17 SPEED 1/2
     If velocity = $00 :Callkey(8)=Callkey(8)-32: PressKey (8,Callkey(8)) :midiOutShortMsg_(my_hMidiOut3,($021490)) :EndIf
Case 21
     If velocity = $7F :Callkey(7)=Callkey(7)+1: PressKey (7,Callkey(7)) :midiOutShortMsg_(my_hMidiOut3,($7F1590)) :EndIf    ;btn b x18  SPEED 2/2
     If velocity = $00 :Callkey(7)=Callkey(7)-1: PressKey (7,Callkey(7)) :midiOutShortMsg_(my_hMidiOut3,($021590)) :EndIf
Case 22
     If velocity = $7F :Callkey(7)=Callkey(7)+8: PressKey (7,Callkey(7)) :midiOutShortMsg_(my_hMidiOut3,($7F1690)) :EndIf    ;btn b x19  SPEED 3/2
     If velocity = $00 :Callkey(7)=Callkey(7)-8: PressKey (7,Callkey(7)) :midiOutShortMsg_(my_hMidiOut3,($021690)) :EndIf
Case 23
     If velocity = $7F :Callkey(7)=Callkey(7)+64: PressKey (7,Callkey(7)) :midiOutShortMsg_(my_hMidiOut3,($7F1790)) :EndIf    ;btn b x20  SPEED 4/2
     If velocity = $00 :Callkey(7)=Callkey(7)-64: PressKey (7,Callkey(7)) :midiOutShortMsg_(my_hMidiOut3,($021790)) :EndIf
     
Case 24
     If velocity = $7F :Callkey(26)=Callkey(26)+16: PressKey (26,Callkey(26)) :midiOutShortMsg_(my_hMidiOut3,($7F1890)) :EndIf    ;exec x40
     If velocity = $00 And Launch(18)=1 :Callkey(26)=Callkey(26)-16: PressKey (26,Callkey(26))   :midiOutShortMsg_(my_hMidiOut3,($111890)):EndIf
     If velocity = $00 And Launch(18)=0 :Callkey(26)=Callkey(26)-16: PressKey (26,Callkey(26))   :midiOutShortMsg_(my_hMidiOut3,($001890)):EndIf
     
     
     

Case 32
     If velocity = $7F :Callkey(13)=Callkey(13)+1: PressKey (13,Callkey(13)) :midiOutShortMsg_(my_hMidiOut3,($7F2090)) :EndIf    ;rem 9
     If velocity = $00 :Callkey(13)=Callkey(13)-1: PressKey (13,Callkey(13)) :midiOutShortMsg_(my_hMidiOut3,($112090)) :EndIf
Case 33
     If velocity = $7F :Callkey(13)=Callkey(13)+2: PressKey (13,Callkey(13)) :midiOutShortMsg_(my_hMidiOut3,($7F2190)) :EndIf    ;rem 10
     If velocity = $00 :Callkey(13)=Callkey(13)-2: PressKey (13,Callkey(13)) :midiOutShortMsg_(my_hMidiOut3,($112190)) :EndIf
Case 34
     If velocity = $7F :Callkey(13)=Callkey(13)+4: PressKey (13,Callkey(13)) :midiOutShortMsg_(my_hMidiOut3,($7F2290)) :EndIf    ;rem 11
     If velocity = $00 :Callkey(13)=Callkey(13)-4: PressKey (13,Callkey(13)) :midiOutShortMsg_(my_hMidiOut3,($012290)) :EndIf
Case 35
     If velocity = $7F :Callkey(13)=Callkey(13)+8: PressKey (13,Callkey(13)) :midiOutShortMsg_(my_hMidiOut3,($7F2390)) :EndIf    ;rem 12
     If velocity = $00 :Callkey(13)=Callkey(13)-8: PressKey (13,Callkey(13)) :midiOutShortMsg_(my_hMidiOut3,($012390)) :EndIf
     
Case 36
     If velocity = $7F : midiOutShortMsg_(my_hMidiOut5,($7F4490)) :midiOutShortMsg_(my_hMidiOut3,($7F2490)) :EndIf    ;stop speed 1
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($004490)) :midiOutShortMsg_(my_hMidiOut3,($5F2490)) :EndIf
Case 37
     If velocity = $7F : midiOutShortMsg_(my_hMidiOut5,($7F4590)) :midiOutShortMsg_(my_hMidiOut3,($7F2590)) :EndIf    ;stop speed 2
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($004590)) :midiOutShortMsg_(my_hMidiOut3,($5F2590)) :EndIf
Case 38
     If velocity = $7F : midiOutShortMsg_(my_hMidiOut5,($7F4690)) :midiOutShortMsg_(my_hMidiOut3,($7F2690)) :EndIf    ;stop speed 3
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($004690)) :midiOutShortMsg_(my_hMidiOut3,($5F2690)) :EndIf
Case 39
     If velocity = $7F : midiOutShortMsg_(my_hMidiOut5,($7F4790)) :midiOutShortMsg_(my_hMidiOut3,($7F2790)) :EndIf    ;stop speed 4
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($004790)) :midiOutShortMsg_(my_hMidiOut3,($5F2790)) :EndIf
     
Case 40
     If velocity = $7F :Callkey(22)=Callkey(22)+16: PressKey (22,Callkey(22)) :midiOutShortMsg_(my_hMidiOut3,($7F2890)) :EndIf   ;exec x50 
     If velocity = $00 And Launch(28)=1 :Callkey(22)=Callkey(22)-16: PressKey (22,Callkey(22))   :midiOutShortMsg_(my_hMidiOut3,($012890)):EndIf 
     If velocity = $00 And Launch(28)=0 :Callkey(22)=Callkey(22)-16: PressKey (22,Callkey(22))   :midiOutShortMsg_(my_hMidiOut3,($002890)):EndIf 
     
     
     
     
Case 48
     If velocity = $7F :Callkey(13)=Callkey(13)+16: PressKey (13,Callkey(13)) :midiOutShortMsg_(my_hMidiOut3,($7F3090)) :EndIf    ;rem 13
     If velocity = $00 :Callkey(13)=Callkey(13)-16: PressKey (13,Callkey(13)) :midiOutShortMsg_(my_hMidiOut3,($113090)) :EndIf
Case 49
     If velocity = $7F :Callkey(13)=Callkey(13)+32: PressKey (13,Callkey(13)) :midiOutShortMsg_(my_hMidiOut3,($7F3190)) :EndIf    ;rem 14
     If velocity = $00 :Callkey(13)=Callkey(13)-32: PressKey (13,Callkey(13)) :midiOutShortMsg_(my_hMidiOut3,($113190)) :EndIf
Case 50
     If velocity = $7F :Callkey(13)=Callkey(13)+64: PressKey (13,Callkey(13)) :midiOutShortMsg_(my_hMidiOut3,($7F3290)) :EndIf    ;rem 15
     If velocity = $00 :Callkey(13)=Callkey(13)-64: PressKey (13,Callkey(13)) :midiOutShortMsg_(my_hMidiOut3,($013290)) :EndIf
Case 51
     If velocity = $7F :Callkey(13)=Callkey(13)+128: PressKey (13,Callkey(13)) :midiOutShortMsg_(my_hMidiOut3,($7F3390)) :EndIf    ;rem 16
     If velocity = $00 :Callkey(13)=Callkey(13)-128: PressKey (13,Callkey(13)) :midiOutShortMsg_(my_hMidiOut3,($013390)) :EndIf
     
;Case 52
;     If velocity = $7F :Callkey(10)=Callkey(10)+2: PressKey (10,Callkey(10)) :midiOutShortMsg_(my_hMidiOut3,($6F3490)) :EndIf    ;select
;     If velocity = $00 :Callkey(10)=Callkey(10)-2: PressKey (10,Callkey(10)) :midiOutShortMsg_(my_hMidiOut3,($7F3490)) :EndIf
Case 53
     If velocity = $7F :Callkey(1)=Callkey(1)+128: PressKey (1,Callkey(1)) :midiOutShortMsg_(my_hMidiOut3,($6F3590)) :EndIf    ;pause
     If velocity = $00 :Callkey(1)=Callkey(1)-128: PressKey (1,Callkey(1)) :midiOutShortMsg_(my_hMidiOut3,($7F3590)) :EndIf
Case 54
     If velocity = $7F :Callkey(3)=Callkey(3)+128: PressKey (3,Callkey(3)) :midiOutShortMsg_(my_hMidiOut3,($6F3690)) :EndIf    ;go moins
     If velocity = $00 :Callkey(3)=Callkey(3)-128: PressKey (3,Callkey(3)) :midiOutShortMsg_(my_hMidiOut3,($7F3690)) :EndIf
Case 55
     If velocity = $7F :Callkey(5)=Callkey(5)+128: PressKey (5,Callkey(5)) :midiOutShortMsg_(my_hMidiOut3,($6F3790)) :EndIf    ;go plus
     If velocity = $00 :Callkey(5)=Callkey(5)-128: PressKey (5,Callkey(5)) :midiOutShortMsg_(my_hMidiOut3,($7F3790)) :EndIf
     
Case 56
     If velocity = $7F :Callkey(24)=Callkey(24)+16: PressKey (24,Callkey(24)) :midiOutShortMsg_(my_hMidiOut3,($7F3890)) :EndIf    ;exec x60
     If velocity = $00 And Launch(38)=1 :Callkey(24)=Callkey(24)-16: PressKey (24,Callkey(24))   :midiOutShortMsg_(my_hMidiOut3,($123890)):EndIf
     If velocity = $00 And Launch(38)=0 :Callkey(24)=Callkey(24)-16: PressKey (24,Callkey(24))   :midiOutShortMsg_(my_hMidiOut3,($003890)):EndIf
          
     
     
     
     
     
     
     
     
     
     
     
     
;---------------------Executors bouton 21-60


Case 64
  If velocity = $7F :Callkey(30)=Callkey(30)+1:PressKey(30,Callkey(30)) : midiOutShortMsg_(my_hMidiOut3,($7F4090)) :EndIf  ;ex bt 21
     If velocity = $00 And Launch(40)=1 :Callkey(30)=Callkey(30)-1:PressKey(30,Callkey(30)) : midiOutShortMsg_(my_hMidiOut3,($104090)):EndIf
     If velocity = $00 And Launch(40)=0 :Callkey(30)=Callkey(30)-1:PressKey(30,Callkey(30)) : midiOutShortMsg_(my_hMidiOut3,($004090)):EndIf
Case 65
     If velocity = $7F :Callkey(28)=Callkey(28)+1:PressKey(28,Callkey(28)) : midiOutShortMsg_(my_hMidiOut3,($7F4190)) :EndIf  ;ex bt 22
     If velocity = $00 And Launch(41)=1 :Callkey(28)=Callkey(28)-1:PressKey(28,Callkey(28)) : midiOutShortMsg_(my_hMidiOut3,($104190)):EndIf
     If velocity = $00 And Launch(41)=0 :Callkey(28)=Callkey(28)-1:PressKey(28,Callkey(28)) : midiOutShortMsg_(my_hMidiOut3,($004190)):EndIf
Case 66
     If velocity = $7F :Callkey(32)=Callkey(32)+2:PressKey(32,Callkey(32)) : midiOutShortMsg_(my_hMidiOut3,($7F4290)) :EndIf  ;ex bt 23
     If velocity = $00 And Launch(42)=1 :Callkey(32)=Callkey(32)-2:PressKey(32,Callkey(32)) : midiOutShortMsg_(my_hMidiOut3,($104290)):EndIf
     If velocity = $00 And Launch(42)=0 :Callkey(32)=Callkey(32)-2:PressKey(32,Callkey(32)) : midiOutShortMsg_(my_hMidiOut3,($004290)):EndIf
Case 67
     If velocity = $7F :Callkey(28)=Callkey(28)+2:PressKey(28,Callkey(28)) : midiOutShortMsg_(my_hMidiOut3,($7F4390)) :EndIf  ;ex bt 24
     If velocity = $00 And Launch(43)=1 :Callkey(28)=Callkey(28)-2:PressKey(28,Callkey(28)) : midiOutShortMsg_(my_hMidiOut3,($104390)):EndIf
     If velocity = $00 And Launch(43)=0 :Callkey(28)=Callkey(28)-2:PressKey(28,Callkey(28)) : midiOutShortMsg_(my_hMidiOut3,($004390)):EndIf
Case 68
     If velocity = $7F:Callkey(30)=Callkey(30)+4 :PressKey(30,Callkey(30)) : midiOutShortMsg_(my_hMidiOut3,($7F4490)) :EndIf  ;ex bt 25
     If velocity = $00 And Launch(44)=1 :Callkey(30)=Callkey(30)-4:PressKey(30,Callkey(30)) : midiOutShortMsg_(my_hMidiOut3,($104490)):EndIf
     If velocity = $00 And Launch(44)=0 :Callkey(30)=Callkey(30)-4:PressKey(30,Callkey(30)) : midiOutShortMsg_(my_hMidiOut3,($004490)):EndIf
Case 69
     If velocity = $7F :Callkey(28)=Callkey(28)+4:PressKey(28,Callkey(28)) : midiOutShortMsg_(my_hMidiOut3,($7F4590)) :EndIf  ;ex bt 26
     If velocity = $00 And Launch(45)=1 :Callkey(28)=Callkey(28)-4:PressKey(28,Callkey(28)) : midiOutShortMsg_(my_hMidiOut3,($104590)):EndIf
     If velocity = $00 And Launch(45)=0 :Callkey(28)=Callkey(28)-4:PressKey(28,Callkey(28)) : midiOutShortMsg_(my_hMidiOut3,($004590)):EndIf
Case 70
     If velocity = $7F :Callkey(32)=Callkey(32)+8:PressKey(32,Callkey(32)) : midiOutShortMsg_(my_hMidiOut3,($7F4690)) :EndIf  ;ex bt 27
     If velocity = $00 And Launch(46)=1 :Callkey(32)=Callkey(32)-8:PressKey(32,Callkey(32)) : midiOutShortMsg_(my_hMidiOut3,($104690)):EndIf
     If velocity = $00 And Launch(46)=0 :Callkey(32)=Callkey(32)-8:PressKey(32,Callkey(32)) : midiOutShortMsg_(my_hMidiOut3,($004690)):EndIf
Case 71
     If velocity = $7F :Callkey(30)=Callkey(30)+8:PressKey(30,Callkey(30)) : midiOutShortMsg_(my_hMidiOut3,($7F4790)) :EndIf  ;ex bt 28
     If velocity = $00 And Launch(47)=1 :Callkey(30)=Callkey(30)-8:PressKey(30,0) : midiOutShortMsg_(my_hMidiOut3,($104790)):EndIf
     If velocity = $00 And Launch(47)=0 :Callkey(30)=Callkey(30)-8:PressKey(30,0) : midiOutShortMsg_(my_hMidiOut3,($004790)):EndIf



Case 72
     If velocity = $7F :Callkey(32)=Callkey(32)+16:PressKey(32,Callkey(32)) : midiOutShortMsg_(my_hMidiOut3,($7F4890)) :EndIf  ;ex bt 29
     If velocity = $00 And Launch(48)=1 :Callkey(32)=Callkey(32)-16:PressKey(32,Callkey(32))  : midiOutShortMsg_(my_hMidiOut3,($104890)):EndIf
     If velocity = $00 And Launch(48)=0 :Callkey(32)=Callkey(32)-16:PressKey(32,Callkey(32))  : midiOutShortMsg_(my_hMidiOut3,($004890)):EndIf



Case 80
     If velocity = $7F :Callkey(32)=Callkey(32)+1:PressKey(32,Callkey(32)) : midiOutShortMsg_(my_hMidiOut3,($7F5090)) :EndIf  ;ex bt 31
     If velocity = $00 And Launch(50)=1 :Callkey(32)=Callkey(32)-1:PressKey(32,Callkey(32)) : midiOutShortMsg_(my_hMidiOut3,($115090)):EndIf
     If velocity = $00 And Launch(50)=0 :Callkey(32)=Callkey(32)-1:PressKey(32,Callkey(32)) : midiOutShortMsg_(my_hMidiOut3,($005090)):EndIf
Case 81
     If velocity = $7F :Callkey(26)=Callkey(26)+1:PressKey(26,Callkey(26)) : midiOutShortMsg_(my_hMidiOut3,($7F5190)) :EndIf  ;ex bt 32
     If velocity = $00 And Launch(51)=1 :Callkey(26)=Callkey(26)-1:PressKey(26,Callkey(26)) : midiOutShortMsg_(my_hMidiOut3,($115190)):EndIf
     If velocity = $00 And Launch(51)=0 :Callkey(26)=Callkey(26)-1:PressKey(26,Callkey(26)) : midiOutShortMsg_(my_hMidiOut3,($005190)):EndIf
Case 82
     If velocity = $7F :Callkey(30)=Callkey(30)+2:PressKey(30,Callkey(30)) : midiOutShortMsg_(my_hMidiOut3,($7F5290)) :EndIf  ;ex bt 33
     If velocity = $00 And Launch(52)=1 :Callkey(30)=Callkey(30)-2:PressKey(30,Callkey(30)) : midiOutShortMsg_(my_hMidiOut3,($115290)):EndIf
     If velocity = $00 And Launch(52)=0 :Callkey(30)=Callkey(30)-2:PressKey(30,Callkey(30)) : midiOutShortMsg_(my_hMidiOut3,($005290)):EndIf
Case 83
     If velocity = $7F :Callkey(26)=Callkey(26)+2:PressKey(26,Callkey(26)) : midiOutShortMsg_(my_hMidiOut3,($7F5390)) :EndIf  ;ex bt 34
     If velocity = $00 And Launch(53)=1 :Callkey(26)=Callkey(26)-2:PressKey(26,Callkey(26)) : midiOutShortMsg_(my_hMidiOut3,($115390)):EndIf
     If velocity = $00 And Launch(53)=0 :Callkey(26)=Callkey(26)-2:PressKey(26,Callkey(26)) : midiOutShortMsg_(my_hMidiOut3,($005390)):EndIf
Case 84
     If velocity = $7F :Callkey(32)=Callkey(32)+4:PressKey(32,Callkey(32)) : midiOutShortMsg_(my_hMidiOut3,($7F5490)) :EndIf  ;ex bt 35
     If velocity = $00 And Launch(54)=1 :Callkey(32)=Callkey(32)-4:PressKey(32,Callkey(32)) : midiOutShortMsg_(my_hMidiOut3,($115490)):EndIf
     If velocity = $00 And Launch(54)=0 :Callkey(32)=Callkey(32)-4:PressKey(32,Callkey(32)) : midiOutShortMsg_(my_hMidiOut3,($005490)):EndIf
Case 85
     If velocity = $7F :Callkey(26)=Callkey(26)+4:PressKey(26,Callkey(26)) : midiOutShortMsg_(my_hMidiOut3,($7F5590)) :EndIf  ;ex bt 36
     If velocity = $00 And Launch(55)=1 :Callkey(26)=Callkey(26)-4:PressKey(26,Callkey(26)) : midiOutShortMsg_(my_hMidiOut3,($115590)):EndIf
     If velocity = $00 And Launch(55)=0 :Callkey(26)=Callkey(26)-4:PressKey(26,Callkey(26)) : midiOutShortMsg_(my_hMidiOut3,($005590)):EndIf
Case 86
     If velocity = $7F :Callkey(28)=Callkey(28)+8:PressKey(28,Callkey(28)) : midiOutShortMsg_(my_hMidiOut3,($7F5690)) :EndIf  ;ex bt 37
     If velocity = $00 And Launch(56)=1 :Callkey(28)=Callkey(28)-8:PressKey(28,Callkey(28)) : midiOutShortMsg_(my_hMidiOut3,($115690)):EndIf
     If velocity = $00 And Launch(56)=0 :Callkey(28)=Callkey(28)-8:PressKey(28,Callkey(28)) : midiOutShortMsg_(my_hMidiOut3,($005690)):EndIf
Case 87
     If velocity = $7F :Callkey(26)=Callkey(26)+8:PressKey(26,Callkey(26)) : midiOutShortMsg_(my_hMidiOut3,($7F5790)) :EndIf  ;ex bt 38
     If velocity = $00 And Launch(57)=1 :Callkey(26)=Callkey(26)-8:PressKey(26,Callkey(26)) : midiOutShortMsg_(my_hMidiOut3,($115790)):EndIf
     If velocity = $00 And Launch(57)=0 :Callkey(26)=Callkey(26)-8:PressKey(26,Callkey(26)) : midiOutShortMsg_(my_hMidiOut3,($005790)):EndIf



Case 88
     If velocity = $7F :Callkey(28)=Callkey(28)+16:PressKey(28,Callkey(28)) : midiOutShortMsg_(my_hMidiOut3,($7F5890)) :EndIf  ;ex bt 39
     If velocity = $00 And Launch(58)=1 :Callkey(28)=Callkey(28)-16:PressKey(28,Callkey(28))  : midiOutShortMsg_(my_hMidiOut3,($115890)):EndIf
     If velocity = $00 And Launch(58)=0 :Callkey(28)=Callkey(28)-16:PressKey(28,Callkey(28))  : midiOutShortMsg_(my_hMidiOut3,($005890)):EndIf



Case 96
     If velocity = $7F :Callkey(18)=Callkey(18)+1:PressKey(18,Callkey(18)) : midiOutShortMsg_(my_hMidiOut3,($7F6090)) :EndIf  ;ex bt 41
     If velocity = $00 And Launch(60)=1 :Callkey(18)=Callkey(18)-1:PressKey(18,Callkey(18)) : midiOutShortMsg_(my_hMidiOut3,($016090)):EndIf
     If velocity = $00 And Launch(60)=0 :Callkey(18)=Callkey(18)-1:PressKey(18,Callkey(18)) : midiOutShortMsg_(my_hMidiOut3,($006090)):EndIf
Case 97
     If velocity = $7F :Callkey(24)=Callkey(24)+1:PressKey(24,Callkey(24)) : midiOutShortMsg_(my_hMidiOut3,($7F6190)) :EndIf  ;ex bt 42
     If velocity = $00 And Launch(61)=1 :Callkey(24)=Callkey(24)-1:PressKey(24,Callkey(24)) : midiOutShortMsg_(my_hMidiOut3,($016190)):EndIf
     If velocity = $00 And Launch(61)=0 :Callkey(24)=Callkey(24)-1:PressKey(24,Callkey(24)) : midiOutShortMsg_(my_hMidiOut3,($006190)):EndIf
Case 98
     If velocity = $7F :Callkey(18)=Callkey(18)+2:PressKey(18,Callkey(18)) : midiOutShortMsg_(my_hMidiOut3,($7F6290)) :EndIf  ;ex bt 43
     If velocity = $00 And Launch(62)=1 :Callkey(18)=Callkey(18)-2:PressKey(18,Callkey(18)) : midiOutShortMsg_(my_hMidiOut3,($016290)):EndIf
     If velocity = $00 And Launch(62)=0 :Callkey(18)=Callkey(18)-2:PressKey(18,Callkey(18)) : midiOutShortMsg_(my_hMidiOut3,($006290)):EndIf
Case 99
     If velocity = $7F :Callkey(24)=Callkey(24)+2:PressKey(24,Callkey(24)) : midiOutShortMsg_(my_hMidiOut3,($7F6390)) :EndIf  ;ex bt 44
     If velocity = $00 And Launch(63)=1 :Callkey(24)=Callkey(24)-2:PressKey(24,Callkey(24)) : midiOutShortMsg_(my_hMidiOut3,($016390)):EndIf
     If velocity = $00 And Launch(63)=0 :Callkey(24)=Callkey(24)-2:PressKey(24,Callkey(24)) : midiOutShortMsg_(my_hMidiOut3,($006390)):EndIf
Case 100
     If velocity = $7F :Callkey(18)=Callkey(18)+4:PressKey(18,Callkey(18)) : midiOutShortMsg_(my_hMidiOut3,($7F6490)) :EndIf  ;ex bt 45
     If velocity = $00 And Launch(64)=1 :Callkey(18)=Callkey(18)-4:PressKey(18,Callkey(18)) : midiOutShortMsg_(my_hMidiOut3,($016490)):EndIf
     If velocity = $00 And Launch(64)=0 :Callkey(18)=Callkey(18)-4:PressKey(18,Callkey(18)) : midiOutShortMsg_(my_hMidiOut3,($006490)):EndIf
Case 101
     If velocity = $7F :Callkey(22)=Callkey(22)+4:PressKey(22,Callkey(22)) : midiOutShortMsg_(my_hMidiOut3,($7F6590)) :EndIf  ;ex bt 46
     If velocity = $00 And Launch(65)=1 :Callkey(22)=Callkey(22)-4:PressKey(22,Callkey(22)) : midiOutShortMsg_(my_hMidiOut3,($016590)):EndIf
     If velocity = $00 And Launch(65)=0 :Callkey(22)=Callkey(22)-4:PressKey(22,Callkey(22)) : midiOutShortMsg_(my_hMidiOut3,($006590)):EndIf
Case 102
     If velocity = $7F :Callkey(24)=Callkey(24)+8:PressKey(24,Callkey(24)) : midiOutShortMsg_(my_hMidiOut3,($7F6690)) :EndIf  ;ex bt 47
     If velocity = $00 And Launch(66)=1 :Callkey(24)=Callkey(24)-8:PressKey(24,Callkey(24)) : midiOutShortMsg_(my_hMidiOut3,($016690)):EndIf
     If velocity = $00 And Launch(66)=0 :Callkey(24)=Callkey(24)-8:PressKey(24,Callkey(24)) : midiOutShortMsg_(my_hMidiOut3,($006690)):EndIf
Case 103
     If velocity = $7F :Callkey(22)=Callkey(22)+8:PressKey(22,Callkey(22)) : midiOutShortMsg_(my_hMidiOut3,($7F6790)) :EndIf  ;ex bt 48
     If velocity = $00 And Launch(67)=1 :Callkey(22)=Callkey(22)-8:PressKey(22,Callkey(22)) : midiOutShortMsg_(my_hMidiOut3,($016790)):EndIf 
     If velocity = $00 And Launch(67)=0 :Callkey(22)=Callkey(22)-8:PressKey(22,Callkey(22)) : midiOutShortMsg_(my_hMidiOut3,($006790)):EndIf



Case 104
     If velocity = $7F :Callkey(18)=Callkey(18)+16:PressKey(18,Callkey(18)) : midiOutShortMsg_(my_hMidiOut3,($7F6890)) :EndIf  ;ex bt 49
     If velocity = $00 And Launch(68)=1 :Callkey(18)=Callkey(18)-16:PressKey(18,Callkey(18)) : midiOutShortMsg_(my_hMidiOut3,($126890)):EndIf   
     If velocity = $00 And Launch(68)=0 :Callkey(18)=Callkey(18)-16:PressKey(18,Callkey(18)) : midiOutShortMsg_(my_hMidiOut3,($006890)):EndIf



Case 112
     If velocity = $7F :Callkey(20)=Callkey(20)+1:PressKey(20,Callkey(20)) : midiOutShortMsg_(my_hMidiOut3,($7F7090)) :EndIf  ;ex bt 51
     If velocity = $00 And Launch(70)=1 :Callkey(20)=Callkey(20)-1:PressKey(20,Callkey(20)) : midiOutShortMsg_(my_hMidiOut3,($127090)):EndIf
     If velocity = $00 And Launch(70)=0 :Callkey(20)=Callkey(20)-1:PressKey(20,Callkey(20)) : midiOutShortMsg_(my_hMidiOut3,($007090)):EndIf
Case 113
     If velocity = $7F :Callkey(22)=Callkey(22)+1:PressKey(22,Callkey(22)) : midiOutShortMsg_(my_hMidiOut3,($7F7190)) :EndIf  ;ex bt 52
     If velocity = $00 And Launch(71)=1 :Callkey(22)=Callkey(22)-1:PressKey(22,Callkey(22)) : midiOutShortMsg_(my_hMidiOut3,($127190)):EndIf
     If velocity = $00 And Launch(71)=0 :Callkey(22)=Callkey(22)-1:PressKey(22,Callkey(22)) : midiOutShortMsg_(my_hMidiOut3,($007190)):EndIf
Case 114
     If velocity = $7F :Callkey(20)=Callkey(20)+2:PressKey(20,Callkey(20)) : midiOutShortMsg_(my_hMidiOut3,($7F7290)) :EndIf  ;ex bt 53
     If velocity = $00 And Launch(72)=1 :Callkey(20)=Callkey(20)-2:PressKey(20,Callkey(20)) : midiOutShortMsg_(my_hMidiOut3,($127290)):EndIf
     If velocity = $00 And Launch(72)=0 :Callkey(20)=Callkey(20)-2:PressKey(20,Callkey(20)) : midiOutShortMsg_(my_hMidiOut3,($007290)):EndIf
Case 115
     If velocity = $7F :Callkey(22)=Callkey(22)+2:PressKey(22,Callkey(22)) : midiOutShortMsg_(my_hMidiOut3,($7F7390)) :EndIf  ;ex bt 54
     If velocity = $00 And Launch(73)=1 :Callkey(22)=Callkey(22)-2:PressKey(22,Callkey(22)) : midiOutShortMsg_(my_hMidiOut3,($127390)) :EndIf
     If velocity = $00 And Launch(73)=0 :Callkey(22)=Callkey(22)-2:PressKey(22,Callkey(22)) : midiOutShortMsg_(my_hMidiOut3,($007390)) :EndIf
Case 116
     If velocity = $7F :Callkey(20)=Callkey(20)+4:PressKey(20,Callkey(20)) : midiOutShortMsg_(my_hMidiOut3,($7F7490)) :EndIf  ;ex bt 55
     If velocity = $00 And Launch(74)=1 :Callkey(20)=Callkey(20)-4:PressKey(20,Callkey(20)) : midiOutShortMsg_(my_hMidiOut3,($127490)) :EndIf
     If velocity = $00 And Launch(74)=0 :Callkey(20)=Callkey(20)-4:PressKey(20,Callkey(20)) : midiOutShortMsg_(my_hMidiOut3,($007490)) :EndIf
Case 117
     If velocity = $7F :Callkey(24)=Callkey(24)+4:PressKey(24,Callkey(24)) : midiOutShortMsg_(my_hMidiOut3,($7F7590)) :EndIf  ;ex bt 56
     If velocity = $00 And Launch(75)=1 :Callkey(24)=Callkey(24)-4:PressKey(24,Callkey(24)) : midiOutShortMsg_(my_hMidiOut3,($127590)) :EndIf
     If velocity = $00 And Launch(75)=0 :Callkey(24)=Callkey(24)-4:PressKey(24,Callkey(24)) : midiOutShortMsg_(my_hMidiOut3,($007590)) :EndIf
Case 118
     If velocity = $7F :Callkey(20)=Callkey(20)+8:PressKey(20,Callkey(20)) : midiOutShortMsg_(my_hMidiOut3,($7F7690)) :EndIf  ;ex bt 57
     If velocity = $00 And Launch(76)=1 :Callkey(20)=Callkey(20)-8:PressKey(20,Callkey(20)) : midiOutShortMsg_(my_hMidiOut3,($127690)) :EndIf
     If velocity = $00 And Launch(76)=0 :Callkey(20)=Callkey(20)-8:PressKey(20,Callkey(20)) : midiOutShortMsg_(my_hMidiOut3,($007690)) :EndIf
Case 119
     If velocity = $7F :Callkey(18)=Callkey(18)+8:PressKey(18,Callkey(18)) : midiOutShortMsg_(my_hMidiOut3,($7F7790)) :EndIf  ;ex bt 58
     If velocity = $00 And Launch(77)=1 :Callkey(18)=Callkey(18)-8:PressKey(18,Callkey(18)) : midiOutShortMsg_(my_hMidiOut3,($127790)) :EndIf
     If velocity = $00 And Launch(77)=0 :Callkey(18)=Callkey(18)-8:PressKey(18,Callkey(18)) : midiOutShortMsg_(my_hMidiOut3,($007790)) :EndIf



Case 120
     If velocity = $7F :Callkey(20)=Callkey(20)+16:PressKey(20,Callkey(20)) : midiOutShortMsg_(my_hMidiOut3,($7F7890)) :EndIf  ;ex bt 59
     If velocity = $00 And Launch(78)=1 :Callkey(20)=Callkey(20)-16:PressKey(20,Callkey(20))  : midiOutShortMsg_(my_hMidiOut3,($127890)) :EndIf
     If velocity = $00 And Launch(78)=0 :Callkey(20)=Callkey(20)-16:PressKey(20,Callkey(20))  : midiOutShortMsg_(my_hMidiOut3,($007890)) :EndIf
    

;---------------------touch du haut launch pad

Case 121 ; fader view 
    If velocity = $7F :keybd_event_(#VK_LMENU ,1,0,0):EndIf 

    If velocity = $7F :keybd_event_(#VK_F3 ,1,0,0) :midiOutShortMsg_(my_hMidiOut3,($7F68B0)):EndIf
    If velocity = $00 :keybd_event_(#VK_F3,1,#KEYEVENTF_KEYUP,0) :EndIf
    If velocity = $00
      keybd_event_(#VK_LMENU,1,0,0) 
      keybd_event_(#VK_LMENU,1,#KEYEVENTF_KEYUP,0)
      midiOutShortMsg_(my_hMidiOut3,($1568B0)) 
    EndIf
ProcedureReturn #True ;Means note processed but error?
    
Case 122 ; ex btn view
    If velocity = $7F :keybd_event_(#VK_LMENU ,1,0,0):EndIf 
    If velocity = $7F :keybd_event_(#VK_F5,1,0,0) :midiOutShortMsg_(my_hMidiOut3,($7F69B0)):EndIf

    If velocity = $00 :keybd_event_(#VK_F5,1,#KEYEVENTF_KEYUP,0) :EndIf
    If velocity = $00 :keybd_event_(#VK_LMENU,1,#KEYEVENTF_KEYUP,0) :midiOutShortMsg_(my_hMidiOut3,($1569B0)):EndIf
    
  ProcedureReturn #True ;Means note processed but error?
    
    
Case 123 ; page - btn
     If velocity = $7F :Callkey(7)=Callkey(7)+128:PressKey(7,Callkey(7)) :midiOutShortMsg_(my_hMidiOut3,($7F6AB0)):EndIf 
     If velocity = $00 :Callkey(7)=Callkey(7)-128:PressKey(7,Callkey(7))   :midiOutShortMsg_(my_hMidiOut3,($156AB0)):EndIf
Case 124 ; page ° btn
     If velocity = $7F :Callkey(12)=Callkey(12)+1:PressKey(12,Callkey(12))  :midiOutShortMsg_(my_hMidiOut3,($7F6BB0)):EndIf 
     If velocity = $00 :Callkey(12)=Callkey(12)-1:PressKey(12,Callkey(12))  :midiOutShortMsg_(my_hMidiOut3,($156BB0)):EndIf     
Case 125 ; btn up exec 17   speed 1
     If velocity = $7F :Callkey(8)=Callkey(8)+8: PressKey(8,Callkey(8))  :midiOutShortMsg_(my_hMidiOut3,($7F6CB0)):EndIf    
     If velocity = $00 :Callkey(8)=Callkey(8)-8: PressKey(8,Callkey(8))  :midiOutShortMsg_(my_hMidiOut3,($016CB0)):EndIf
Case 126 ; btn up exec 18   speed 2
     If velocity = $7F :Callkey(8)=Callkey(8)+64: PressKey(8,Callkey(8)) :midiOutShortMsg_(my_hMidiOut3,($7F6DB0)):EndIf    
     If velocity = $00 :Callkey(8)=Callkey(8)-64: PressKey(8,Callkey(8))  :midiOutShortMsg_(my_hMidiOut3,($016DB0)):EndIf    
Case 127 ; btn up exec 19   speed 3
     If velocity = $7F :Callkey(7)=Callkey(7)+2: PressKey(7,Callkey(7))  :midiOutShortMsg_(my_hMidiOut3,($7F6EB0)):EndIf    
     If velocity = $00 :Callkey(7)=Callkey(7)-2: PressKey(7,Callkey(7))  :midiOutShortMsg_(my_hMidiOut3,($016EB0)):EndIf     
Case 128 ; btn up exec 20   speed 4
     If velocity = $7F :Callkey(7)=Callkey(7)+16: PressKey(7,Callkey(7)) :midiOutShortMsg_(my_hMidiOut3,($7F6FB0)):EndIf    
     If velocity = $00 :Callkey(7)=Callkey(7)-16: PressKey(7,Callkey(7))  :midiOutShortMsg_(my_hMidiOut3,($016FB0)):EndIf     
     

     
     
 EndSelect


EndIf


;----------------------------------------

;----------------------------------------
;--------- key de will en channel 2
;----------------------------------------



;----------------select MIDI channel 2----KEY DE WILL -----------------------------------------------------------------------
;=========================================================================================================================
;=========================================================================================================================
;

If channel = #channel4


Select nota





;----------------------page fixe du gma

Case 12
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F0090)) :EndIf   ;midi in note 0 
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($000090)) :EndIf
Case 13
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F0190)) :EndIf   ;midi in note 1 
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($000190)) :EndIf
Case 14
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F0290)) :EndIf    ;midi in note 2
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($000290)) :EndIf
Case 15
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F0390)) :EndIf    ;midi in note 3
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($000390)) :EndIf
Case 16
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F0490)) :EndIf    ;midi in note 4
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($000490)) :EndIf
Case 17
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F0590)) :EndIf    ;midi in note 5
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($000590)) :EndIf
Case 18
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F0690)) :EndIf    ;midi in note 6
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($000690)) :EndIf
Case 19
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F0790)) :EndIf    ;midi in note 7
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($000790)) :EndIf
Case 20
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F0890)) :EndIf    ;midi in note 8
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($000890)) :EndIf



Case 21
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F0990)) :EndIf    ;midi in note 9
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($000990)) :EndIf
Case 22
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F0A90)) :EndIf    ;midi in note 10
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($000A90)) :EndIf
Case 23
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F0B90)) :EndIf    ;midi in note 11
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($000B90)) :EndIf
Case 24
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F0C90)) :EndIf    ;midi in note 12
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($000C90)) :EndIf
Case 25
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F0D90)) :EndIf    ;midi in note 13
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($000D90)) :EndIf
Case 26
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F0E90)) :EndIf    ;midi in note 14
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($000E90)) :EndIf
Case 27
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F0F90)) :EndIf    ;midi in note 15
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($000F90)) :EndIf
Case 28
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F1090)) :EndIf    ;midi in note 16
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($001090)) :EndIf
Case 29
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F1190)) :EndIf    ;midi in note 17
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($001190)) :EndIf



Case 30
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F1290)) :EndIf    ;midi in note 18
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($001290)) :EndIf
Case 31
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F1390)) :EndIf    ;midi in note 19
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($001390)) :EndIf
Case 32
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F1490)) :EndIf    ;midi in note 20
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($001490)) :EndIf
Case 33
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F1590)) :EndIf    ;midi in note 21
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($001590)) :EndIf
Case 34
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F1690)) :EndIf    ;midi in note 22
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($001690)) :EndIf
Case 35
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F1790)) :EndIf    ;midi in note 23
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($001790)) :EndIf
Case 36
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F1890)) :EndIf    ;midi in note 24
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($001890)) :EndIf
Case 37
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F1990)) :EndIf    ;midi in note 25
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($001990)) :EndIf
Case 38
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F1A90)) :EndIf    ;midi in note 26
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($001A90)) :EndIf     
     

     
Case 39
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F1B90)) :EndIf    ;midi in note 27
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($001B90)) :EndIf
Case 40
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F1C90)) :EndIf    ;midi in note 28
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($001C90)) :EndIf
Case 41
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F1D90)) :EndIf    ;midi in note 29
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($001D90)) :EndIf
Case 42
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F1E90)) :EndIf    ;midi in note 30
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($001E90)) :EndIf
Case 43
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F1F90)) :EndIf    ;midi in note 31
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($001F90)) :EndIf
Case 44
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F2090)) :EndIf    ;midi in note 32
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($002090)) :EndIf
Case 45
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F2190)) :EndIf    ;midi in note 33
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($002190)) :EndIf
Case 46
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F2290)) :EndIf    ;midi in note 34
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($002290)) :EndIf
Case 47
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F2390)) :EndIf    ;midi in note 35
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($002390)) :EndIf     
Case 48
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F2490)) :EndIf    ;midi in note 36
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($002490)) :EndIf               
Case 49
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F2590)) :EndIf    ;midi in note 37
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($002590)) :EndIf     
Case 50
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F2690)) :EndIf    ;midi in note 38
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($002690)) :EndIf     
Case 51
     If velocity > $30 : midiOutShortMsg_(my_hMidiOut5,($7F2790)) :EndIf    ;midi in note 39
     If velocity = $00 : midiOutShortMsg_(my_hMidiOut5,($002790)) :EndIf     
     
     
     
     
     
     
     
     
     
;---------------------Executors bouton 21-60


Case 52
     If velocity > $30 :Callkey(30)=Callkey(30)+1:PressKey(30,Callkey(30)) :EndIf  ;ex bt 21
     If velocity = $00 :Callkey(30)=Callkey(30)-1:PressKey(30,Callkey(30)) :EndIf
Case 53
     If velocity > $30 :Callkey(28)=Callkey(28)+1:PressKey(28,Callkey(28)) : EndIf  ;ex bt 22
     If velocity = $00 :Callkey(28)=Callkey(28)-1:PressKey(28,Callkey(28)) : EndIf
Case 54
     If velocity > $30 :Callkey(32)=Callkey(32)+2:PressKey(32,Callkey(32)) : EndIf  ;ex bt 23
     If velocity = $00 :Callkey(32)=Callkey(32)-2:PressKey(32,Callkey(32)) : EndIf
Case 55
     If velocity > $30 :Callkey(28)=Callkey(28)+2:PressKey(28,Callkey(28)) : EndIf  ;ex bt 24
     If velocity = $00 :Callkey(28)=Callkey(28)-2:PressKey(28,Callkey(28)) : EndIf
Case 56
     If velocity > $30 :Callkey(30)=Callkey(30)+4:PressKey(30,Callkey(30)) : EndIf  ;ex bt 25
     If velocity = $00 :Callkey(30)=Callkey(30)-4:PressKey(30,Callkey(30)) : EndIf
Case 57
     If velocity > $30 :Callkey(28)=Callkey(28)+4:PressKey(28,Callkey(28)) : EndIf  ;ex bt 26
     If velocity = $00 :Callkey(28)=Callkey(28)-4:PressKey(28,Callkey(28)) : EndIf
Case 58
     If velocity > $30 :Callkey(32)=Callkey(32)+8:PressKey(32,Callkey(32)) : EndIf  ;ex bt 27
     If velocity = $00 :Callkey(32)=Callkey(32)-8:PressKey(32,Callkey(32)) : EndIf
Case 59
     If velocity > $30 :Callkey(30)=Callkey(30)+8:PressKey(30,Callkey(30)) :EndIf  ;ex bt 28
     If velocity = $00 :Callkey(30)=Callkey(30)-8:PressKey(30,Callkey(30)) :EndIf

Case 60
     If velocity > $30 :Callkey(32)=Callkey(32)+16:PressKey(32,Callkey(32)) : EndIf  ;ex bt 29
     If velocity = $00 :Callkey(32)=Callkey(32)-16:PressKey(32,Callkey(32))  : EndIf

Case 61
     If velocity > $30 :Callkey(30)=Callkey(30)+16: PressKey (30,Callkey(30)) :EndIf    ; exe BT 30
     If velocity = $00 :Callkey(30)=Callkey(30)-16: PressKey (30,Callkey(30)) : EndIf
     
     


Case 62
     If velocity > $30 :Callkey(32)=Callkey(32)+1:PressKey(32,Callkey(32)) : EndIf  ;ex bt 31
     If velocity = $00 :Callkey(32)=Callkey(32)-1:PressKey(32,Callkey(32)) : EndIf
Case 63
     If velocity > $30 :Callkey(26)=Callkey(26)+1:PressKey(26,Callkey(26)) : EndIf  ;ex bt 32
     If velocity = $00 :Callkey(26)=Callkey(26)-1:PressKey(26,Callkey(26)) : EndIf
Case 64
     If velocity > $30 :Callkey(30)=Callkey(30)+2:PressKey(30,Callkey(30)) : EndIf  ;ex bt 33
     If velocity = $00 :Callkey(30)=Callkey(30)-2:PressKey(30,Callkey(30)) : EndIf
Case 65
     If velocity > $30 :Callkey(26)=Callkey(26)+2:PressKey(26,Callkey(26)) : EndIf  ;ex bt 34
     If velocity = $00 :Callkey(26)=Callkey(26)-2:PressKey(26,Callkey(26)) : EndIf
Case 66
     If velocity > $30 :Callkey(32)=Callkey(32)+4:PressKey(32,Callkey(32)) : EndIf  ;ex bt 35
     If velocity = $00 :Callkey(32)=Callkey(32)-4:PressKey(32,Callkey(32)) : EndIf
Case 67
     If velocity > $30 :Callkey(26)=Callkey(26)+4:PressKey(26,Callkey(26)) : EndIf  ;ex bt 36
     If velocity = $00 :Callkey(26)=Callkey(26)-4:PressKey(26,Callkey(26)) : EndIf
Case 68
     If velocity > $30 :Callkey(28)=Callkey(28)+8:PressKey(28,Callkey(28)) : EndIf  ;ex bt 37
     If velocity = $00 :Callkey(28)=Callkey(28)-8:PressKey(28,Callkey(28)) : EndIf
Case 69
     If velocity > $30 :Callkey(26)=Callkey(26)+8:PressKey(26,Callkey(26)) :EndIf  ;ex bt 38
     If velocity = $00 :Callkey(26)=Callkey(26)-8:PressKey(26,Callkey(26)) : EndIf
     
Case 70
     If velocity > $30 :Callkey(28)=Callkey(28)+16:PressKey(28,Callkey(28)) : EndIf  ;ex bt 39
     If velocity = $00 :Callkey(28)=Callkey(28)-16:PressKey(28,Callkey(28))  : EndIf 
     

Case 71
     If velocity > $30 :Callkey(26)=Callkey(26)+16: PressKey (26,Callkey(26)) :EndIf    ;exec x40
     If velocity = $00 :Callkey(26)=Callkey(26)-16: PressKey (26,Callkey(26)) : EndIf



Case 72
     If velocity > $30 :Callkey(18)=Callkey(18)+1:PressKey(18,Callkey(18)) : EndIf  ;ex bt 41
     If velocity = $00 :Callkey(18)=Callkey(18)-1:PressKey(18,Callkey(18)) : EndIf
Case 73
     If velocity > $30 :Callkey(24)=Callkey(24)+1:PressKey(24,Callkey(24)) : EndIf  ;ex bt 42
     If velocity = $00 :Callkey(24)=Callkey(24)-1:PressKey(24,Callkey(24)) : EndIf
Case 74
     If velocity > $30 :Callkey(18)=Callkey(18)+2:PressKey(18,Callkey(18)) : EndIf  ;ex bt 43
     If velocity = $00 :Callkey(18)=Callkey(18)-2:PressKey(18,Callkey(18)) : EndIf
Case 75
     If velocity > $30 :Callkey(24)=Callkey(24)+2:PressKey(24,Callkey(24)) : EndIf  ;ex bt 44
     If velocity = $00 :Callkey(24)=Callkey(24)-2:PressKey(24,Callkey(24)) : EndIf
Case 76
     If velocity > $30 :Callkey(18)=Callkey(18)+4:PressKey(18,Callkey(18)) : EndIf  ;ex bt 45
     If velocity = $00 :Callkey(18)=Callkey(18)-4:PressKey(18,Callkey(18)) : EndIf
Case 77
     If velocity > $30 :Callkey(22)=Callkey(22)+4:PressKey(22,Callkey(22)) : EndIf  ;ex bt 46
     If velocity = $00 :Callkey(22)=Callkey(22)-4:PressKey(22,Callkey(22)) : EndIf
    
 Case 78
      If velocity > $30 :Callkey(24)=Callkey(24)+8:PressKey(24,Callkey(24)) : EndIf  ;ex bt 47
      If velocity = $00 :Callkey(24)=Callkey(24)-8:PressKey(24,Callkey(24)) : EndIf
 Case 79
      If velocity > $30 :Callkey(22)=Callkey(22)+8:PressKey(22,Callkey(22)) : EndIf  ;ex bt 48
      If velocity = $00 :Callkey(22)=Callkey(22)-8:PressKey(22,Callkey(22)) : EndIf  

Case 80
     If velocity > $30 :Callkey(18)=Callkey(18)+16:PressKey(18,Callkey(18)) : EndIf  ;ex bt 49
     If velocity = $00 :Callkey(18)=Callkey(18)-16:PressKey(18,Callkey(18))  : EndIf   

     
Case 81
     If velocity > $30 :Callkey(22)=Callkey(22)+16: PressKey (22,Callkey(22)) :EndIf   ;exec x50 
     If velocity = $00 :Callkey(22)=Callkey(22)-16: PressKey (22,Callkey(22)) : EndIf     





Case 82
     If velocity > $30 :Callkey(20)=Callkey(20)+1:PressKey(20,Callkey(20)) : EndIf  ;ex bt 51
     If velocity = $00 :Callkey(20)=Callkey(20)-1:PressKey(20,Callkey(20)) : EndIf
Case 83
     If velocity > $30 :Callkey(22)=Callkey(22)+1:PressKey(22,Callkey(22)) : EndIf  ;ex bt 52
     If velocity = $00 :Callkey(22)=Callkey(22)-1:PressKey(22,Callkey(22)) : EndIf
Case 84
     If velocity > $30 :Callkey(20)=Callkey(20)+2:PressKey(20,Callkey(20)) : EndIf  ;ex bt 53
     If velocity = $00 :Callkey(20)=Callkey(20)-2:PressKey(20,Callkey(20)) : EndIf
Case 85
     If velocity > $30 :Callkey(22)=Callkey(22)+2:PressKey(22,Callkey(22)) : EndIf  ;ex bt 54
     If velocity = $00 :Callkey(22)=Callkey(22)-2:PressKey(22,Callkey(22)) : EndIf
Case 86
     If velocity > $30 :Callkey(20)=Callkey(20)+4:PressKey(20,Callkey(20)) : EndIf  ;ex bt 55
     If velocity = $00 :Callkey(20)=Callkey(20)-4:PressKey(20,Callkey(20)) : EndIf
Case 87
     If velocity > $30 :Callkey(24)=Callkey(24)+4:PressKey(24,Callkey(24)) : EndIf  ;ex bt 56
     If velocity = $00 :Callkey(24)=Callkey(24)-4:PressKey(24,Callkey(24)) : EndIf
Case 88
     If velocity > $30 :Callkey(20)=Callkey(20)+8:PressKey(20,Callkey(20)) : EndIf  ;ex bt 57
     If velocity = $00 :Callkey(20)=Callkey(20)-8:PressKey(20,Callkey(20)) : EndIf
Case 89
     If velocity > $30 :Callkey(18)=Callkey(18)+8:PressKey(18,Callkey(18)) : EndIf  ;ex bt 58
     If velocity = $00 :Callkey(18)=Callkey(18)-8:PressKey(18,Callkey(18)) : EndIf

Case 90
     If velocity > $30 :Callkey(20)=Callkey(20)+16:PressKey(20,Callkey(20)) : EndIf  ;ex bt 59
     If velocity = $00 :Callkey(20)=Callkey(20)-16:PressKey(20,Callkey(20))  : EndIf
     
Case 91
     If velocity > $30 :Callkey(24)=Callkey(24)+16: PressKey (24,Callkey(24)) : EndIf    ;exec x60
     If velocity = $00 :Callkey(24)=Callkey(24)-16: PressKey (24,Callkey(24)) : EndIf          

    
;----------- BT 321 EXEC X.1 TO X.5

Case 92
     If velocity > $30 :Callkey(2)=Callkey(2)+1:PressKey(2,Callkey(2)) :EndIf;FADER 1 BT3
     If velocity = $00 :Callkey(2)=Callkey(2)-1:PressKey(2,Callkey(2)) :EndIf
Case 93
     If velocity > $30 :Callkey(2)=Callkey(2)+2:PressKey(2,Callkey(2)) :EndIf;FADER 1 BT2
     If velocity = $00 :Callkey(2)=Callkey(2)-2:PressKey(2,Callkey(2)) :EndIf
Case 94
     If velocity > $30 :Callkey(2)=Callkey(2)+4:PressKey(2,Callkey(2)) :EndIf;FADER 1 BT1
     If velocity = $00 :Callkey(2)=Callkey(2)-4:PressKey(2,Callkey(2)) :EndIf


Case 95
     If velocity > $30 :Callkey(2)=Callkey(2)+8:PressKey(2,Callkey(2)) :EndIf;FADER 2BT3
     If velocity = $00 :Callkey(2)=Callkey(2)-8:PressKey(2,Callkey(2)) :EndIf
Case 96
     If velocity > $30 :Callkey(2)=Callkey(2)+16:PressKey(2,Callkey(2)) :EndIf;FADER 2 BT2
     If velocity = $00 :Callkey(2)=Callkey(2)-16:PressKey(2,Callkey(2)) :EndIf
Case 97
     If velocity > $30 :Callkey(2)=Callkey(2)+32:PressKey(2,Callkey(2)) :EndIf;FADER 2 BT1
     If velocity = $00 :Callkey(2)=Callkey(2)-32:PressKey(2,Callkey(2)) :EndIf


Case 98
     If velocity > $30 :Callkey(2)=Callkey(2)+64:PressKey(2,Callkey(2)) :EndIf;FADER 3 BT3
     If velocity = $00 :Callkey(2)=Callkey(2)-64:PressKey(2,Callkey(2)) :EndIf
Case 99
     If velocity > $30 :Callkey(2)=Callkey(2)+128:PressKey(2,Callkey(2)) :EndIf;FADER 3 BT2
     If velocity = $00 :Callkey(2)=Callkey(2)-128:PressKey(2,Callkey(2)) :EndIf
Case 100
     If velocity > $30 :Callkey(1)=Callkey(1)+1:PressKey(1,Callkey(1)) :EndIf;FADER 3 BT1
     If velocity = $00 :Callkey(1)=Callkey(1)-1:PressKey(1,Callkey(1)) :EndIf


Case 101
     If velocity > $30 :Callkey(1)=Callkey(1)+2:PressKey(1,Callkey(1)) :EndIf;FADER 4 BT3
     If velocity = $00 :Callkey(1)=Callkey(1)-2:PressKey(1,Callkey(1)) :EndIf
Case 102
     If velocity > $30 :Callkey(1)=Callkey(1)+4:PressKey(1,Callkey(1)) :EndIf;FADER 4 BT2
     If velocity = $00 :Callkey(1)=Callkey(1)-4:PressKey(1,Callkey(1)) :EndIf
Case 103
     If velocity > $30 :Callkey(1)=Callkey(1)+8:PressKey(1,Callkey(1)) :EndIf;FADER 4 BT1
     If velocity = $00 :Callkey(1)=Callkey(1)-8:PressKey(1,Callkey(1)) :EndIf


Case 104
     If velocity > $30 :Callkey(1)=Callkey(1)+16:PressKey(1,Callkey(1)) :EndIf;FADER 5 BT3
     If velocity = $00 :Callkey(1)=Callkey(1)-16:PressKey(1,Callkey(1)) :EndIf
Case 105
     If velocity > $30 :Callkey(1)=Callkey(1)+32:PressKey(1,Callkey(1)) :EndIf;FADER 5 BT2
     If velocity = $00 :Callkey(1)=Callkey(1)-32:PressKey(1,Callkey(1)) :EndIf
Case 106
     If velocity > $30 :Callkey(1)=Callkey(1)+64:PressKey(1,Callkey(1)) :EndIf;FADER 5 BT1
     If velocity = $00 :Callkey(1)=Callkey(1)-64:PressKey(1,Callkey(1)) :EndIf 
 
     
 EndSelect


EndIf






EndProcedure
; IDE Options = PureBasic 5.50 (Windows - x86)
; CursorPosition = 1304
; FirstLine = 1303
; Folding = -
; UseIcon = ..\..\bcedit.ico