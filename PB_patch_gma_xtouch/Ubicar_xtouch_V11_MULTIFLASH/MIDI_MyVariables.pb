#True = 1  ;I think this is not needed ;(
#False = 0

;================= fader variables ===========
Global FaderAddress.l 
Global EncoderAddress.l  
Global KeyAddress.l 
Global LedAddress.l

Global NavDirection.b  ;It could be 0 , 2, 4, 8 (0= updown 4=leftright) We test it into note 71
Global Level_Incr.w     ;to go faster!! byte is signed so I use Word to test
Global Increm.w               ;value to add to the encoders value, it only changes in case level encoder's button is pressed
Global ScreenNum.w     ;stores the last screen selected from the Behringer surface (mem pos 0 1 2  are screen 2 1 3)
                                                                                            ;notes  81 82 83

;Write/ReadProcessMemory variables
Global wHwnd.l
Global pid.l
Global pHandle.l
Global riria.l
Global ririb.l
Global e.l
Global midiin.l


Global NV.l
Global VL.l

Global Callkey.l

NV = 0
VL = 0


#MaxMidiInSliders = 23
#NumEncoders = 20

Dim Behringer_FaderValues.b(#MaxMidiInSliders)  ;we store here the midi in recieved values from the sliders
Dim MAonPC_FaderValues.b(#MaxMidiInSliders) ;here we store the fader values of the MAonPC
Dim MAonPC_EncoderValues.w(#NumEncoders) ; the encoders use 2 bytes eatch, Word type
Dim LedValue.b(29)
Dim LedBin.s(29) 
Dim LedValueIpad.b(29)
Dim Launch.b(78)
Dim LaunchJ.b(78)

Dim Callkey.l(50)

#MaxMidiCodeur =512
Dim Codeur_CodeurValues.b(#MaxMidiCodeur)


#Interval = 40

#channel1 = 0
#channel4 = 1
#channelled1=7
#channelled2=8
#channel = 9  ; midi output #channel 1..16 (= 0..15)
#channel2 = 10 ; midi output #channel 2 1..16 (= 0..15)
#channel3 = 11 ; midi output #channel 3 1..16 (= 0..15)
#channelson = 15


Global delay

delay = 60

Global midimsg.l         ; midi output message buffer
Global my_hMidiOut.l
Global midimsg2.l
Global my_hMidiOut2.l
Global midimsg3.l
Global my_hMidiOut3.l
Global midimsg4.l
Global my_hMidiOut4.l
Global midimsg5.l
Global my_hMidiOut5.l
Global midimsg6.l
Global my_hMidiOut6.l

;
;FROM SEARCH PROCEDURE
#ShowMsgBox = #True  ;IF #TRUE IT SHOWS MESSAGE DEBUG BOXES
Global PtoEncontrado

; IDE Options = PureBasic 5.50 (Windows - x86)
; CursorPosition = 62
; UseIcon = bcedit.ico
; Executable = ..\W7_FlashNov2012_Wait.exe