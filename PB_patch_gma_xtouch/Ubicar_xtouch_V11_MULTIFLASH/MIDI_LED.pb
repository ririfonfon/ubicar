;-------------  LED activitie  ---------------------

Procedure readled1(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+1,@LedValue(1),1,0)
      LedBin.s(1) = RSet(Bin(LedValue(1),#PB_Byte) ,8,"0") 
    
  
    
    
    ;------------------------------------------ 1 
    If LedValueIpad(1)<>LedValue(1)
      LedValueIpad(1)=LedValue(1)
    
      If Mid(LedBin(1),8,1) ="1";29V
        midiOutShortMsg_(my_hMidiOut4,($7F0197))
        Launch(48)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($000197))
        Launch(48)=0
      EndIf
      
      If Mid(LedBin(1),7,1) ="1";49V
        midiOutShortMsg_(my_hMidiOut4,($7F0297))
        Launch(68)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($000297))
        Launch(68)=0
      EndIf
 
      If Mid(LedBin(1),6,1) ="1";tim man bt R
        midiOutShortMsg_(my_hMidiOut4,($7F0397))
      Else
        midiOutShortMsg_(my_hMidiOut4,($000397))
      EndIf
      
      If Mid(LedBin(1),5,1) ="1";edit
        midiOutShortMsg_(my_hMidiOut4,($7F0497))
      Else
        midiOutShortMsg_(my_hMidiOut4,($000497))
      EndIf
      
      If Mid(LedBin(1),4,1) ="1";page
        midiOutShortMsg_(my_hMidiOut4,($7F0597))
      Else
        midiOutShortMsg_(my_hMidiOut4,($000597))
      EndIf
      
      If Mid(LedBin(1),3,1) ="1";fixture
        midiOutShortMsg_(my_hMidiOut4,($7F0697))
      Else
        midiOutShortMsg_(my_hMidiOut4,($000697))
      EndIf
      
      If Mid(LedBin(1),2,1) ="1";tools
        midiOutShortMsg_(my_hMidiOut4,($7F0797))
      Else
        midiOutShortMsg_(my_hMidiOut4,($000797))
      EndIf
    EndIf
    
  EndProcedure
  
  
  Procedure readled2(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+2,@LedValue(2),1,0)
      LedBin.s(2) = RSet(Bin(LedValue(2),#PB_Byte) ,8,"0") 
  
    
      ;------------------------------------------ 2      
If LedValueIpad(2)<>LedValue(2)
      LedValueIpad(2)=LedValue(2)      
      
      
      If Mid(LedBin(2),8,1) ="1";21V
        midiOutShortMsg_(my_hMidiOut4,($7F0997))
        Launch(40)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($000997))
        Launch(40)=0
      EndIf
      
      If Mid(LedBin(2),7,1) ="1";41V
        midiOutShortMsg_(my_hMidiOut4,($7F0A97))
        Launch(60)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($000A97))
        Launch(60)=0
      EndIf
 
      If Mid(LedBin(2),6,1) ="1";23V
        midiOutShortMsg_(my_hMidiOut4,($7F0B97)) 
        Launch(42)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($000B97))
        Launch(42)=0
      EndIf
      
      If Mid(LedBin(2),5,1) ="1";43V
        midiOutShortMsg_(my_hMidiOut4,($7F0C97)) 
        Launch(62)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($000C97))
        Launch(62)=0
      EndIf
      
      If Mid(LedBin(2),4,1) ="1";25V
        midiOutShortMsg_(my_hMidiOut4,($7F0D97))
        Launch(44)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($000D97))
        Launch(44)=0
      EndIf
      
      If Mid(LedBin(2),3,1) ="1";45V
        midiOutShortMsg_(my_hMidiOut4,($7F0E97))
        Launch(64)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($000E97))
        Launch(64)=0
      EndIf
      
      If Mid(LedBin(2),2,1) ="1";27V
        midiOutShortMsg_(my_hMidiOut4,($7F0F97))
        Launch(46)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($000F97))
        Launch(46)=0
      EndIf
      
      If Mid(LedBin(2),1,1) ="1";47V
        midiOutShortMsg_(my_hMidiOut4,($7F1097))
        Launch(66)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($001097))
        Launch(66)=0
      EndIf
    EndIf
    
      
  EndProcedure
  
  
  
  Procedure readled3(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+3,@LedValue(3),1,0)
      LedBin.s(3) = RSet(Bin(LedValue(3),#PB_Byte) ,8,"0") 
      
      ;------------------------------------------ 3      
      If LedValueIpad(3)<>LedValue(3)
      LedValueIpad(3)=LedValue(3)
      
      If Mid(LedBin(3),8,1) ="1";29 J
        midiOutShortMsg_(my_hMidiOut4,($7F1197))
        LaunchJ(48)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($001197))
        LaunchJ(48)=0
      EndIf
      
      If Mid(LedBin(3),7,1) ="1";49 J
        midiOutShortMsg_(my_hMidiOut4,($7F1297))
        LaunchJ(68)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($001297))
        LaunchJ(68)=0
      EndIf
 
      If Mid(LedBin(3),6,1) ="1";TIM MAN V
         midiOutShortMsg_(my_hMidiOut4,($7F1397))
      Else
         midiOutShortMsg_(my_hMidiOut4,($001397))
      EndIf
      
      If Mid(LedBin(3),5,1) ="1";MOVE
         midiOutShortMsg_(my_hMidiOut4,($7F1497))
      Else
         midiOutShortMsg_(my_hMidiOut4,($001497))
      EndIf
      
      If Mid(LedBin(3),4,1) ="1";VIEW
         midiOutShortMsg_(my_hMidiOut4,($7F1597))
      Else
         midiOutShortMsg_(my_hMidiOut4,($001597))
      EndIf
      
      If Mid(LedBin(3),3,1) ="1";CHANNEL
         midiOutShortMsg_(my_hMidiOut4,($7F1697))
      Else
        midiOutShortMsg_(my_hMidiOut4,($001697))
      EndIf
      
      If Mid(LedBin(3),2,1) ="1";setup
         midiOutShortMsg_(my_hMidiOut4,($7F1797))
      Else
        midiOutShortMsg_(my_hMidiOut4,($001797))
      EndIf
      
    EndIf
    
  EndProcedure
  
  
  
  Procedure readled4(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+4,@LedValue(4),1,0)
      LedBin.s(4) = RSet(Bin(LedValue(4),#PB_Byte) ,8,"0") 
    
    
    
      ;------------------------------------------ 4      
      If LedValueIpad(4)<>LedValue(4)
        LedValueIpad(4)=LedValue(4)
       Debug LedBin.s(4) 
      If Mid(LedBin(4),8,1) ="1";21J
        midiOutShortMsg_(my_hMidiOut4,($7F1997))
        LaunchJ(40)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($001997))
        LaunchJ(40)=0
      EndIf
      
      If Mid(LedBin(4),7,1) ="1";41J
        midiOutShortMsg_(my_hMidiOut4,($7F1A97))
        LaunchJ(60)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($001A97))
        LaunchJ(60)=0
      EndIf
 
      If Mid(LedBin(4),6,1) ="1";23J
        midiOutShortMsg_(my_hMidiOut4,($7F1B97))
        LaunchJ(42)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($001B97))
        LaunchJ(42)=0
      EndIf
      
      If Mid(LedBin(4),5,1) ="1";43J
        midiOutShortMsg_(my_hMidiOut4,($7F1C97))
        LaunchJ(62)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($001C97))
        LaunchJ(62)=0
      EndIf
      
      If Mid(LedBin(4),4,1) ="1";25J
        midiOutShortMsg_(my_hMidiOut4,($7F1D97))
        LaunchJ(44)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($001D97))
        LaunchJ(44)=0
      EndIf
      
      If Mid(LedBin(4),3,1) ="1";45J
        midiOutShortMsg_(my_hMidiOut4,($7F1E97))
        LaunchJ(64)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($001E97))
        LaunchJ(64)=0
      EndIf
      
      If Mid(LedBin(4),2,1) ="1";27J
        midiOutShortMsg_(my_hMidiOut4,($7F1F97))
        LaunchJ(46)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($001F97))
        LaunchJ(46)=0
      EndIf
      
      If Mid(LedBin(4),1,1) ="1";47J
        midiOutShortMsg_(my_hMidiOut4,($7F2097))
        LaunchJ(66)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($002097))
        LaunchJ(66)=0
      EndIf
    EndIf
    
  EndProcedure
  
  
  
  Procedure readled5(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+5,@LedValue(5),1,0)
      LedBin.s(5) = RSet(Bin(LedValue(5),#PB_Byte) ,8,"0") 
    
    
    
      ;------------------------------------------ 5      
   If LedValueIpad(5)<>LedValue(5)
      LedValueIpad(5)=LedValue(5)
      
      If Mid(LedBin(5),8,1) ="1";30V
        midiOutShortMsg_(my_hMidiOut4,($7F2197))
        Launch(8)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($002197))
        Launch(8)=0
      EndIf
      
      If Mid(LedBin(5),7,1) ="1";50V
        midiOutShortMsg_(my_hMidiOut4,($7F2297))
        Launch(28)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($002297))
        Launch(28)=0
      EndIf
 
      If Mid(LedBin(5),6,1) ="1";BLIND
         midiOutShortMsg_(my_hMidiOut4,($7F2397))
      Else
         midiOutShortMsg_(my_hMidiOut4,($002397))
      EndIf
      
      If Mid(LedBin(5),5,1) ="1";UPDATE
         midiOutShortMsg_(my_hMidiOut4,($7F2497))
      Else
         midiOutShortMsg_(my_hMidiOut4,($002497))
      EndIf
            
      If Mid(LedBin(5),4,1) ="1";EFFECT
         midiOutShortMsg_(my_hMidiOut4,($7F2597))
      Else
         midiOutShortMsg_(my_hMidiOut4,($002597))
      EndIf
      
      If Mid(LedBin(5),3,1) ="1";EX BTN
         midiOutShortMsg_(my_hMidiOut4,($7F2697))
      Else
         midiOutShortMsg_(my_hMidiOut4,($002697))
      EndIf
      
      If Mid(LedBin(5),2,1) ="1";BACK UP
         midiOutShortMsg_(my_hMidiOut4,($7F2797))
      Else
        midiOutShortMsg_(my_hMidiOut4,($002797))
      EndIf
    EndIf
    
  EndProcedure
  
  
  Procedure readled6(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+6,@LedValue(6),1,0)
      LedBin.s(6) = RSet(Bin(LedValue(6),#PB_Byte) ,8,"0") 
    
    
      ;------------------------------------------ 6      
      If LedValueIpad(6)<>LedValue(6)
      LedValueIpad(6)=LedValue(6)
      
      
      If Mid(LedBin(6),8,1) ="1";22V
        midiOutShortMsg_(my_hMidiOut4,($7F2997))
        Launch(41)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($002997))
        Launch(41)=0
      EndIf
      
      If Mid(LedBin(6),7,1) ="1";42V
        midiOutShortMsg_(my_hMidiOut4,($7F2A97))
        Launch(61)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($002A97))
        Launch(61)=0
      EndIf
 
      If Mid(LedBin(6),6,1) ="1";24V
        midiOutShortMsg_(my_hMidiOut4,($7F2B97))
        Launch(43)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($002B97))
        Launch(43)=0
      EndIf
      
      If Mid(LedBin(6),5,1) ="1";44V
        midiOutShortMsg_(my_hMidiOut4,($7F2C97))
        Launch(63)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($002C97))
        Launch(63)=0
      EndIf
      
      If Mid(LedBin(6),4,1) ="1";26V
        midiOutShortMsg_(my_hMidiOut4,($7F2D97))
        Launch(45)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($002D97))
        Launch(45)=0
      EndIf
      
      If Mid(LedBin(6),3,1) ="1";46V
        midiOutShortMsg_(my_hMidiOut4,($7F2E97))
        Launch(65)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($002E97))
        Launch(65)=0
      EndIf
      
      If Mid(LedBin(6),2,1) ="1";28V
        midiOutShortMsg_(my_hMidiOut4,($7F2F97))
        Launch(47)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($002F97))
        Launch(47)=0
      EndIf
      
      If Mid(LedBin(6),1,1) ="1";48V
        midiOutShortMsg_(my_hMidiOut4,($7F3097))
        Launch(67)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($003097))
        Launch(67)=0
      EndIf
    EndIf
    
  EndProcedure
  
  
  Procedure readled7(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+7,@LedValue(7),1,0)
      LedBin.s(7) = RSet(Bin(LedValue(7),#PB_Byte) ,8,"0") 
    
    
    ;------------------------------------------ 7
    If LedValueIpad(7)<>LedValue(7)
      LedValueIpad(7)=LedValue(7)
      
      If Mid(LedBin(7),8,1) ="1";30J
        midiOutShortMsg_(my_hMidiOut4,($7F3197))
        LaunchJ(8)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($003197))
        LaunchJ(8)=0
      EndIf
      
      If Mid(LedBin(7),7,1) ="1";50J
        midiOutShortMsg_(my_hMidiOut4,($7F3297))
        LaunchJ(28)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($003297))
        LaunchJ(28)=0
      EndIf
 
      If Mid(LedBin(7),6,1) ="1";FREEZE
         midiOutShortMsg_(my_hMidiOut4,($7F3397))
      Else
         midiOutShortMsg_(my_hMidiOut4,($003397))
      EndIf
      
      If Mid(LedBin(7),5,1) ="1";PREVIEW
         midiOutShortMsg_(my_hMidiOut4,($7F3497))
      Else
         midiOutShortMsg_(my_hMidiOut4,($003497))
      EndIf
      
      If Mid(LedBin(7),4,1) ="1";GOTO
         midiOutShortMsg_(my_hMidiOut4,($7F3597))
      Else
         midiOutShortMsg_(my_hMidiOut4,($003597))
      EndIf
      
      If Mid(LedBin(7),3,1) ="1";EXEC.
         midiOutShortMsg_(my_hMidiOut4,($7F3697))
      Else
         midiOutShortMsg_(my_hMidiOut4,($003697))
      EndIf
     
      If Mid(LedBin(7),2,1) ="1";B.O.
         midiOutShortMsg_(my_hMidiOut4,($7F3797))
      Else
         midiOutShortMsg_(my_hMidiOut4,($003797))
      EndIf
    EndIf
    
  EndProcedure
  
  
  Procedure readled8(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+8,@LedValue(8),1,0)
      LedBin.s(8) = RSet(Bin(LedValue(8),#PB_Byte) ,8,"0") 
    
    
    ;------------------------------------------ 8      
    If LedValueIpad(8)<>LedValue(8)
      LedValueIpad(8)=LedValue(8) 
      
      
      
      
      
      If Mid(LedBin(8),8,1) ="1";22J
        midiOutShortMsg_(my_hMidiOut4,($7F3997))
        LaunchJ(41)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($003997))
        LaunchJ(41)=0
      EndIf
      
      If Mid(LedBin(8),7,1) ="1";42J
        midiOutShortMsg_(my_hMidiOut4,($7F3A97))
        LaunchJ(61)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($003A97))
        LaunchJ(61)=0
      EndIf
 
      If Mid(LedBin(8),6,1) ="1";24J
        midiOutShortMsg_(my_hMidiOut4,($7F3B97))
        LaunchJ(43)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($003B97))
        LaunchJ(43)=0
      EndIf
      
      If Mid(LedBin(8),5,1) ="1";44J
        midiOutShortMsg_(my_hMidiOut4,($7F3C97))
        LaunchJ(63)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($003C97))
        LaunchJ(63)=0
      EndIf
      
      If Mid(LedBin(8),4,1) ="1";26J
        midiOutShortMsg_(my_hMidiOut4,($7F3D97))
        LaunchJ(45)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($003D97))
        LaunchJ(45)=0
      EndIf
      
      If Mid(LedBin(8),3,1) ="1";46J
        midiOutShortMsg_(my_hMidiOut4,($7F3E97))
        LaunchJ(65)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($003E97))
        LaunchJ(65)=0
      EndIf
     
      If Mid(LedBin(8),2,1) ="1";28J
        midiOutShortMsg_(my_hMidiOut4,($7F3F97))
        LaunchJ(47)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($003F97))
        LaunchJ(47)=0
      EndIf
      
      If Mid(LedBin(8),1,1) ="1";48J
        midiOutShortMsg_(my_hMidiOut4,($7F4097))
        LaunchJ(67)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($004097))
        LaunchJ(67)=0
       EndIf
       
       EndIf
       
     EndProcedure
     
     
     Procedure readled9(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+9,@LedValue(9),1,0)
      LedBin.s(9) = RSet(Bin(LedValue(9),#PB_Byte) ,8,"0") 
       
       
     
     ;------------------------------------------ 9       
     If LedValueIpad(9)<>LedValue(9)
      LedValueIpad(9)=LedValue(9)  
       
       
       
       If Mid(LedBin(9),8,1) ="1";39V
         midiOutShortMsg_(my_hMidiOut4,($7F4197))
         Launch(58)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($004197))
        Launch(58)=0
      EndIf
      
      If Mid(LedBin(9),7,1) ="1";59V
        midiOutShortMsg_(my_hMidiOut4,($7F4297))
        Launch(78)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($004297))
        Launch(78)=0
      EndIf
 
      
      
      If Mid(LedBin(9),5,1) ="1";DELETE
         midiOutShortMsg_(my_hMidiOut4,($7F4497))
      Else
         midiOutShortMsg_(my_hMidiOut4,($004497))
      EndIf
      
      If Mid(LedBin(9),4,1) ="1";SEQ
         midiOutShortMsg_(my_hMidiOut4,($7F4597))
      Else
         midiOutShortMsg_(my_hMidiOut4,($004597))
      EndIf
      
      If Mid(LedBin(9),3,1) ="1";GROUP
         midiOutShortMsg_(my_hMidiOut4,($7F4697))
      Else
         midiOutShortMsg_(my_hMidiOut4,($004697))
      EndIf
     
      
    EndIf
    
  EndProcedure
  
  
  Procedure readled10(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+10,@LedValue(10),1,0)
      LedBin.s(10) = RSet(Bin(LedValue(10),#PB_Byte) ,8,"0") 
       
       
 ;------------------------------------------ 10       
   If LedValueIpad(10)<>LedValue(10)
      LedValueIpad(10)=LedValue(10)    
       
       
       
       If Mid(LedBin(10),8,1) ="1";31V
         midiOutShortMsg_(my_hMidiOut4,($7F4997))
         Launch(50)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($004997))
        Launch(50)=0
      EndIf
      
      If Mid(LedBin(10),7,1) ="1";51V
        midiOutShortMsg_(my_hMidiOut4,($7F4A97))
        Launch(70)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($004A97))
        Launch(70)=0
      EndIf
 
      If Mid(LedBin(10),6,1) ="1";33V
        midiOutShortMsg_(my_hMidiOut4,($7F4B97))
        Launch(52)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($004B97))
        Launch(52)=0
      EndIf
      
      If Mid(LedBin(10),5,1) ="1";53V
        midiOutShortMsg_(my_hMidiOut4,($7F4C97))
        Launch(72)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($004C97))
        Launch(72)=0
      EndIf
      
      If Mid(LedBin(10),4,1) ="1";35V
        midiOutShortMsg_(my_hMidiOut4,($7F4D97))
        Launch(54)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($004D97))
        Launch(54)=0
      EndIf
      
      If Mid(LedBin(10),3,1) ="1";55V
        midiOutShortMsg_(my_hMidiOut4,($7F4E97))
        Launch(74)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($004E97))
        Launch(74)=0
      EndIf
     
      If Mid(LedBin(10),2,1) ="1";37V
        midiOutShortMsg_(my_hMidiOut4,($7F4F97))
        Launch(56)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($004F97))
        Launch(56)=0
      EndIf
      
      If Mid(LedBin(10),1,1) ="1";57V
        midiOutShortMsg_(my_hMidiOut4,($7F5097))
        Launch(76)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($005097))
        Launch(76)=0
       EndIf
       
     EndIf
     
   EndProcedure
   
   
   
   
   Procedure readled11(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+11,@LedValue(11),1,0)
      LedBin.s(11) = RSet(Bin(LedValue(11),#PB_Byte) ,8,"0") 
     
     
     
  ;------------------------------------------ 11      
     If LedValueIpad(11)<>LedValue(11)
      LedValueIpad(11)=LedValue(11)  
       
       
       
       
       If Mid(LedBin(11),8,1) ="1";39J
         midiOutShortMsg_(my_hMidiOut4,($7F5197))
         LaunchJ(58)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($005197))
        LaunchJ(58)=0
      EndIf
      
      If Mid(LedBin(11),7,1) ="1";59J
        midiOutShortMsg_(my_hMidiOut4,($7F5297))
        LaunchJ(78)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($005297))
        LaunchJ(78)=0
      EndIf
 
      If Mid(LedBin(11),6,1) ="1";ASSIGN
         midiOutShortMsg_(my_hMidiOut4,($7F5397))
      Else
         midiOutShortMsg_(my_hMidiOut4,($005397))
      EndIf
      
      If Mid(LedBin(11),5,1) ="1";COPY
         midiOutShortMsg_(my_hMidiOut4,($7F5497))
      Else
         midiOutShortMsg_(my_hMidiOut4,($005497))
      EndIf
      
      If Mid(LedBin(11),4,1) ="1";CUE
         midiOutShortMsg_(my_hMidiOut4,($7F5597))
      Else
         midiOutShortMsg_(my_hMidiOut4,($005597))
      EndIf
      
      If Mid(LedBin(11),3,1) ="1";IF
         midiOutShortMsg_(my_hMidiOut4,($7F5697))
      Else
         midiOutShortMsg_(my_hMidiOut4,($005697))
      EndIf
     
      If Mid(LedBin(11),2,1) ="1";STORE
         midiOutShortMsg_(my_hMidiOut4,($7F5797))
      Else
         midiOutShortMsg_(my_hMidiOut4,($005797))
      EndIf
      
    EndIf  
    
  EndProcedure
  
  
  
  Procedure readled12(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+12,@LedValue(12),1,0)
      LedBin.s(12) = RSet(Bin(LedValue(12),#PB_Byte) ,8,"0") 
    
    
    
       
  ;------------------------------------------ 12      
       If LedValueIpad(12)<>LedValue(12)
      LedValueIpad(12)=LedValue(12)
       
       
       
       
       If Mid(LedBin(12),8,1) ="1";31J
         midiOutShortMsg_(my_hMidiOut4,($7F5997))
         LaunchJ(50)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($005997))
        LaunchJ(50)=0
      EndIf
      
      If Mid(LedBin(12),7,1) ="1";51J
        midiOutShortMsg_(my_hMidiOut4,($7F5A97))
        LaunchJ(70)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($005A97))
        LaunchJ(70)=0
      EndIf
 
      If Mid(LedBin(12),6,1) ="1";33J
        midiOutShortMsg_(my_hMidiOut4,($7F5B97))
        LaunchJ(52)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($005B97))
        LaunchJ(52)=0
      EndIf
      
      If Mid(LedBin(12),5,1) ="1";53J
        midiOutShortMsg_(my_hMidiOut4,($7F5C97))
        LaunchJ(72)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($005C97))
        LaunchJ(72)=0
      EndIf
      
      If Mid(LedBin(12),4,1) ="1";35J
        midiOutShortMsg_(my_hMidiOut4,($7F5D97))
        LaunchJ(54)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($005D97))
        LaunchJ(54)=0
      EndIf
      
      If Mid(LedBin(12),3,1) ="1";55J
        midiOutShortMsg_(my_hMidiOut4,($7F5E97))
        LaunchJ(74)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($005E97))
        LaunchJ(74)=0
      EndIf
     
      If Mid(LedBin(12),2,1) ="1";37J
        midiOutShortMsg_(my_hMidiOut4,($7F5F97))
        LaunchJ(56)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($005F97))
        LaunchJ(56)=0
      EndIf
      
      If Mid(LedBin(12),1,1) ="1";57J
        midiOutShortMsg_(my_hMidiOut4,($7F6097))
        LaunchJ(76)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($006097))
        LaunchJ(76)=0
       EndIf
       
     EndIf
     
   EndProcedure
   
   
   Procedure readled13(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+13,@LedValue(13),1,0)
      LedBin.s(13) = RSet(Bin(LedValue(13),#PB_Byte) ,8,"0") 
     
     
  ;------------------------------------------ 13      
       
     If LedValueIpad(13)<>LedValue(13)
      LedValueIpad(13)=LedValue(13)  
       
       
       If Mid(LedBin(13),8,1) ="1";40V
         midiOutShortMsg_(my_hMidiOut4,($7F6197))
         Launch(18)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($006197))
        Launch(18)=0
      EndIf
      
      If Mid(LedBin(13),7,1) ="1";60V
        midiOutShortMsg_(my_hMidiOut4,($7F6297))
        Launch(38)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($006297))
        Launch(38)=0
      EndIf
 
      If Mid(LedBin(13),6,1) ="1";ALIGN
         midiOutShortMsg_(my_hMidiOut4,($7F6397))
      Else
         midiOutShortMsg_(my_hMidiOut4,($006397))
      EndIf
      
      If Mid(LedBin(13),5,1) ="1";THRU
         midiOutShortMsg_(my_hMidiOut4,($7F6497))
      Else
         midiOutShortMsg_(my_hMidiOut4,($006497))
      EndIf
      
      If Mid(LedBin(13),4,1) ="1";MACRO
         midiOutShortMsg_(my_hMidiOut4,($7F6597))
      Else
         midiOutShortMsg_(my_hMidiOut4,($006597))
      EndIf
      
      If Mid(LedBin(13),3,1) ="1";AT
         midiOutShortMsg_(my_hMidiOut4,($7F6697))
      Else
         midiOutShortMsg_(my_hMidiOut4,($006697))
      EndIf
     
     
    EndIf
    
  EndProcedure
  
  
  Procedure readled14(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+14,@LedValue(14),1,0)
      LedBin.s(14) = RSet(Bin(LedValue(14),#PB_Byte) ,8,"0") 
       
 ;------------------------------------------ 14       
     If LedValueIpad(14)<>LedValue(14)
      LedValueIpad(14)=LedValue(14)  
       
       
       
       If Mid(LedBin(14),8,1) ="1";32V
         midiOutShortMsg_(my_hMidiOut4,($7F6997))
         Launch(51)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($006997))
        Launch(51)=0
      EndIf
      
      If Mid(LedBin(14),7,1) ="1";52V
        midiOutShortMsg_(my_hMidiOut4,($7F6A97))
        Launch(71)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($006A97))
        Launch(71)=0
      EndIf
 
      If Mid(LedBin(14),6,1) ="1";34V
        midiOutShortMsg_(my_hMidiOut4,($7F6B97))
        Launch(53)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($006B97))
        Launch(53)=0
      EndIf
      
      If Mid(LedBin(14),5,1) ="1";54V
        midiOutShortMsg_(my_hMidiOut4,($7F6C97))
        Launch(73)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($006C97))
        Launch(73)=0
      EndIf
      
      If Mid(LedBin(14),4,1) ="1";36V
        midiOutShortMsg_(my_hMidiOut4,($7F6D97))
        Launch(55)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($006D97))
        Launch(55)=0
      EndIf
      
      If Mid(LedBin(14),3,1) ="1";56V
        midiOutShortMsg_(my_hMidiOut4,($7F6E97))
        Launch(75)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($006E97))
        Launch(75)=0
      EndIf
     
      If Mid(LedBin(14),2,1) ="1";38V
        midiOutShortMsg_(my_hMidiOut4,($7F6F97))
        Launch(57)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($006F97))
        Launch(57)=0
      EndIf
      
      If Mid(LedBin(14),1,1) ="1";58V
        midiOutShortMsg_(my_hMidiOut4,($7F7097))
        Launch(77)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($007097))
        Launch(77)=0
       EndIf
       
     EndIf
     
   EndProcedure
   
   
   Procedure readled15(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+15,@LedValue(15),1,0)
      LedBin.s(15) = RSet(Bin(LedValue(15),#PB_Byte) ,8,"0") 
     
     
     
 ;------------------------------------------ 15       
    If LedValueIpad(15)<>LedValue(15)
      LedValueIpad(15)=LedValue(15)   
       
       
       If Mid(LedBin(15),8,1) ="1";40J
         midiOutShortMsg_(my_hMidiOut4,($7F7197))
         LaunchJ(18)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($007197))
        LaunchJ(18)=0
      EndIf
      
      If Mid(LedBin(15),7,1) ="1";60J
        midiOutShortMsg_(my_hMidiOut4,($7F7297))
        LaunchJ(38)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($007297))
        LaunchJ(38)=0
      EndIf
 
      If Mid(LedBin(15),6,1) ="1";HELP
         midiOutShortMsg_(my_hMidiOut4,($7F7397))
      Else
         midiOutShortMsg_(my_hMidiOut4,($007397))
      EndIf
      
      If Mid(LedBin(15),5,1) ="1";+
         midiOutShortMsg_(my_hMidiOut4,($7F7497))
      Else
         midiOutShortMsg_(my_hMidiOut4,($007497))
      EndIf
      
      If Mid(LedBin(15),4,1) ="1";PRESET
         midiOutShortMsg_(my_hMidiOut4,($7F7597))
      Else
         midiOutShortMsg_(my_hMidiOut4,($007597))
      EndIf
       
      If Mid(LedBin(15),3,1) ="1";-
         midiOutShortMsg_(my_hMidiOut4,($7F7697))
      Else
         midiOutShortMsg_(my_hMidiOut4,($007697))
      EndIf
     
      If Mid(LedBin(15),2,1) ="1";HIGHLIGHT
         midiOutShortMsg_(my_hMidiOut4,($7F7797))
      Else
         midiOutShortMsg_(my_hMidiOut4,($007797))
      EndIf
    EndIf
    
  EndProcedure
  
  
  Procedure readled16(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+16,@LedValue(16),1,0)
      LedBin.s(16) = RSet(Bin(LedValue(16),#PB_Byte) ,8,"0") 
       
       
 ;------------------------------------------ 16       
       If LedValueIpad(16)<>LedValue(16)
      LedValueIpad(16)=LedValue(16)
       
       
       
       If Mid(LedBin(16),8,1) ="1";32J
         midiOutShortMsg_(my_hMidiOut4,($7F7997))
         LaunchJ(51)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($007997))
        LaunchJ(51)=0
      EndIf
      
      If Mid(LedBin(16),7,1) ="1";52J
        midiOutShortMsg_(my_hMidiOut4,($7F7A97))
        LaunchJ(71)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($007A97))
        LaunchJ(71)=0
      EndIf
 
      If Mid(LedBin(16),6,1) ="1";34J
        midiOutShortMsg_(my_hMidiOut4,($7F7B97))
        LaunchJ(53)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($007B97))
        LaunchJ(53)=0
      EndIf
      
      If Mid(LedBin(16),5,1) ="1";54J
        midiOutShortMsg_(my_hMidiOut4,($7F7C97))
        LaunchJ(73)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($007C97))
        LaunchJ(73)=0
      EndIf
      
      If Mid(LedBin(16),4,1) ="1";36J
        midiOutShortMsg_(my_hMidiOut4,($7F7D97))
        LaunchJ(55)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($007D97))
        LaunchJ(55)=0
      EndIf
      
      If Mid(LedBin(16),3,1) ="1";56J
        midiOutShortMsg_(my_hMidiOut4,($7F7E97))
        LaunchJ(75)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($007E97))
        LaunchJ(75)=0
      EndIf
     
      If Mid(LedBin(16),2,1) ="1";38J
        midiOutShortMsg_(my_hMidiOut4,($7F7F97))
        LaunchJ(57)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($007F97))
        LaunchJ(57)=0
      EndIf
      
      ;------------------- channel 9
      
      
      If Mid(LedBin(16),1,1) ="1";58J
        midiOutShortMsg_(my_hMidiOut4,($7F0198))
        LaunchJ(77)=1
      Else
        midiOutShortMsg_(my_hMidiOut4,($000198))
        LaunchJ(77)=0
      EndIf
       
       
    EndIf
    
  EndProcedure
  
  
  Procedure readled17(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+17,@LedValue(17),1,0)
      LedBin.s(17) = RSet(Bin(LedValue(17),#PB_Byte) ,8,"0") 
    
    
      
  ;------------------------------------------ 17     
    If LedValueIpad(17)<>LedValue(17)
      LedValueIpad(17)=LedValue(17)  
      
      
      
      If Mid(LedBin(17),7,1) ="1";F4J
         midiOutShortMsg_(my_hMidiOut4,($7F0398))
      Else
         midiOutShortMsg_(my_hMidiOut4,($000398))
      EndIf
 
      If Mid(LedBin(17),6,1) ="1";F4V
         midiOutShortMsg_(my_hMidiOut4,($7F0498))
      Else
         midiOutShortMsg_(my_hMidiOut4,($000498))
      EndIf
      
      
      
      If Mid(LedBin(17),4,1) ="1";F5J
         midiOutShortMsg_(my_hMidiOut4,($7F0698))
      Else
         midiOutShortMsg_(my_hMidiOut4,($000698))
      EndIf
      
      If Mid(LedBin(17),3,1) ="1";F5V
         midiOutShortMsg_(my_hMidiOut4,($7F0798))
      Else
         midiOutShortMsg_(my_hMidiOut4,($000798))
      EndIf
     
      
      
      If Mid(LedBin(17),1,1) ="1";PAUSE SEL
         midiOutShortMsg_(my_hMidiOut4,($7F0998))
      Else
         midiOutShortMsg_(my_hMidiOut4,($000998))
       EndIf
       
       
     EndIf
     
   EndProcedure
   
   
   Procedure readled18(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+18,@LedValue(18),1,0)
      LedBin.s(18) = RSet(Bin(LedValue(18),#PB_Byte) ,8,"0") 
     
 ;------------------------------------------ 18       
       
     If LedValueIpad(18)<>LedValue(18)
      LedValueIpad(18)=LedValue(18)  
       
       
       
       
       If Mid(LedBin(18),8,1) ="1";F1J
         midiOutShortMsg_(my_hMidiOut4,($7F0A98))
      Else
        midiOutShortMsg_(my_hMidiOut4,($000A98))
      EndIf
      
      If Mid(LedBin(18),7,1) ="1";F1V
         midiOutShortMsg_(my_hMidiOut4,($7F0B98))
      Else
         midiOutShortMsg_(my_hMidiOut4,($000B98))
      EndIf
 
      
      
      If Mid(LedBin(18),5,1) ="1";F2J
         midiOutShortMsg_(my_hMidiOut4,($7F0D98))
      Else
         midiOutShortMsg_(my_hMidiOut4,($000D98))
      EndIf
      
      If Mid(LedBin(18),4,1) ="1";F2V
         midiOutShortMsg_(my_hMidiOut4,($7F0E98))
      Else
         midiOutShortMsg_(my_hMidiOut4,($000E98))
      EndIf
      
      
     
      If Mid(LedBin(18),2,1) ="1";F3J
         midiOutShortMsg_(my_hMidiOut4,($7F1098))
      Else
         midiOutShortMsg_(my_hMidiOut4,($001098))
      EndIf
      
      If Mid(LedBin(18),1,1) ="1";F3V
         midiOutShortMsg_(my_hMidiOut4,($7F1198))
      Else
         midiOutShortMsg_(my_hMidiOut4,($001198))
       EndIf
       
       
     EndIf
     
   EndProcedure
   
   
   Procedure readled19(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+19,@LedValue(19),1,0)
      LedBin.s(19) = RSet(Bin(LedValue(19),#PB_Byte) ,8,"0") 
       
 ;------------------------------------------ 19
       
       If LedValueIpad(19)<>LedValue(19)
      LedValueIpad(19)=LedValue(19)
       
       
      
      If Mid(LedBin(19),7,1) ="1";F9J
         midiOutShortMsg_(my_hMidiOut4,($7F1398))
      Else
         midiOutShortMsg_(my_hMidiOut4,($001398))
      EndIf
 
      If Mid(LedBin(19),6,1) ="1";F9V
         midiOutShortMsg_(my_hMidiOut4,($7F1498))
      Else
         midiOutShortMsg_(my_hMidiOut4,($001498))
      EndIf
      
      
      
      If Mid(LedBin(19),4,1) ="1";F10J
         midiOutShortMsg_(my_hMidiOut4,($7F1698))
      Else
         midiOutShortMsg_(my_hMidiOut4,($001698))
      EndIf
      
      If Mid(LedBin(19),3,1) ="1";F10V
         midiOutShortMsg_(my_hMidiOut4,($7F1798))
      Else
         midiOutShortMsg_(my_hMidiOut4,($001798))
      EndIf
     
      
      
      If Mid(LedBin(19),1,1) ="1";GO- SEL
         midiOutShortMsg_(my_hMidiOut4,($7F1998))
      Else
         midiOutShortMsg_(my_hMidiOut4,($001998))
       EndIf
       
       
     EndIf
     
   EndProcedure
   
   Procedure readled20(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+20,@LedValue(20),1,0)
      LedBin.s(20) = RSet(Bin(LedValue(20),#PB_Byte) ,8,"0") 
     
     
  ;------------------------------------------ 20      
     If LedValueIpad(20)<>LedValue(20)
      LedValueIpad(20)=LedValue(20)  
       
       
       
       
       
       If Mid(LedBin(20),8,1) ="1";F6J
         midiOutShortMsg_(my_hMidiOut4,($7F1A98))
      Else
        midiOutShortMsg_(my_hMidiOut4,($001A98))
      EndIf
      
      If Mid(LedBin(20),7,1) ="1";F6V
         midiOutShortMsg_(my_hMidiOut4,($7F1B98))
      Else
         midiOutShortMsg_(my_hMidiOut4,($001B98))
      EndIf
 
      
      
      If Mid(LedBin(20),5,1) ="1";F7J
         midiOutShortMsg_(my_hMidiOut4,($7F1D98))
      Else
         midiOutShortMsg_(my_hMidiOut4,($001D98))
      EndIf
      
      If Mid(LedBin(20),4,1) ="1";F7V
         midiOutShortMsg_(my_hMidiOut4,($7F1E98))
      Else
         midiOutShortMsg_(my_hMidiOut4,($001E98))
      EndIf
      
      
     
      If Mid(LedBin(20),2,1) ="1";F8J
         midiOutShortMsg_(my_hMidiOut4,($7F2098))
      Else
         midiOutShortMsg_(my_hMidiOut4,($002098))
      EndIf
      
      If Mid(LedBin(20),1,1) ="1";F8V
         midiOutShortMsg_(my_hMidiOut4,($7F2198))
      Else
         midiOutShortMsg_(my_hMidiOut4,($002198))
       EndIf
       
       
     EndIf
     
   EndProcedure
   
   
      Procedure readled21(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+21,@LedValue(21),1,0)
      LedBin.s(21) = RSet(Bin(LedValue(21),#PB_Byte) ,8,"0") 
     
     
       
   ;------------------------------------------ 21     
       
       If LedValueIpad(21)<>LedValue(21)
      LedValueIpad(21)=LedValue(21)
       
       
       
      If Mid(LedBin(21),7,1) ="1";F14J
         midiOutShortMsg_(my_hMidiOut4,($7F2398))
      Else
         midiOutShortMsg_(my_hMidiOut4,($002398))
      EndIf
 
      If Mid(LedBin(21),6,1) ="1";F14V
         midiOutShortMsg_(my_hMidiOut4,($7F2498))
      Else
         midiOutShortMsg_(my_hMidiOut4,($002498))
      EndIf
      
      
      
      If Mid(LedBin(21),4,1) ="1";F15J
         midiOutShortMsg_(my_hMidiOut4,($7F2698))
      Else
         midiOutShortMsg_(my_hMidiOut4,($002698))
      EndIf
      
      If Mid(LedBin(21),3,1) ="1";F15V
         midiOutShortMsg_(my_hMidiOut4,($7F2798))
      Else
         midiOutShortMsg_(my_hMidiOut4,($002798))
      EndIf
     
      
      
      If Mid(LedBin(21),1,1) ="1";GO+ SEL
         midiOutShortMsg_(my_hMidiOut4,($7F2998))
      Else
         midiOutShortMsg_(my_hMidiOut4,($002998))
       EndIf
       
         EndIf   
       
     EndProcedure
     
     
        Procedure readled22(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+22,@LedValue(22),1,0)
      LedBin.s(22) = RSet(Bin(LedValue(22),#PB_Byte) ,8,"0") 
       
       
       
  
   ;------------------------------------------ 22
   
    If LedValueIpad(22)<>LedValue(22)
      LedValueIpad(22)=LedValue(22)
      
      
      If Mid(LedBin(22),8,1) ="1";F11J
         midiOutShortMsg_(my_hMidiOut4,($7F2A98))
      Else
        midiOutShortMsg_(my_hMidiOut4,($002A98))
      EndIf
      
      If Mid(LedBin(22),7,1) ="1";F11V
         midiOutShortMsg_(my_hMidiOut4,($7F2B98))
      Else
         midiOutShortMsg_(my_hMidiOut4,($002B98))
      EndIf
 
      
      
      If Mid(LedBin(22),5,1) ="1";F12J
         midiOutShortMsg_(my_hMidiOut4,($7F2D98))
      Else
         midiOutShortMsg_(my_hMidiOut4,($002D98))
      EndIf
      
      If Mid(LedBin(22),4,1) ="1";F12V
         midiOutShortMsg_(my_hMidiOut4,($7F2E98))
      Else
         midiOutShortMsg_(my_hMidiOut4,($002E98))
      EndIf
      
      
      
      If Mid(LedBin(22),2,1) ="1";F13J
         midiOutShortMsg_(my_hMidiOut4,($7F3098))
      Else
         midiOutShortMsg_(my_hMidiOut4,($003098))
      EndIf
      
      If Mid(LedBin(22),1,1) ="1";F13V
         midiOutShortMsg_(my_hMidiOut4,($7F3198))
      Else
         midiOutShortMsg_(my_hMidiOut4,($003198))
      EndIf
    EndIf
    
  EndProcedure
  
  
     Procedure readled23(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+23,@LedValue(23),1,0)
      LedBin.s(23) = RSet(Bin(LedValue(23),#PB_Byte) ,8,"0") 
    
    
       
  ;------------------------------------------ 23     
       
       If LedValueIpad(23)<>LedValue(23)
      LedValueIpad(23)=LedValue(23)
       
       
      
      If Mid(LedBin(23),7,1) ="1";F19J
         midiOutShortMsg_(my_hMidiOut4,($7F3398))
      Else
         midiOutShortMsg_(my_hMidiOut4,($003398))
      EndIf
 
      If Mid(LedBin(23),6,1) ="1";F19V
         midiOutShortMsg_(my_hMidiOut4,($7F3498))
      Else
         midiOutShortMsg_(my_hMidiOut4,($003498)) 
      EndIf
      
      
      
      If Mid(LedBin(23),4,1) ="1";F20J
         midiOutShortMsg_(my_hMidiOut4,($7F3698))
      Else
         midiOutShortMsg_(my_hMidiOut4,($003698))
      EndIf
      
      If Mid(LedBin(23),3,1) ="1";F20V
         midiOutShortMsg_(my_hMidiOut4,($7F3798))
      Else
         midiOutShortMsg_(my_hMidiOut4,($003798))
      EndIf
     
    EndIf
    
       
  EndProcedure
  
  
     Procedure readled24(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+24,@LedValue(24),1,0)
      LedBin.s(24) = RSet(Bin(LedValue(24),#PB_Byte) ,8,"0") 
       
       
  ;------------------------------------------ 24     
     If LedValueIpad(24)<>LedValue(24)
      LedValueIpad(24)=LedValue(24)  
       
       
       
       
       If Mid(LedBin(24),8,1) ="1";F16J
         midiOutShortMsg_(my_hMidiOut4,($7F3A98))
      Else
        midiOutShortMsg_(my_hMidiOut4,($003A98))
      EndIf
      
      If Mid(LedBin(24),7,1) ="1";F16V
         midiOutShortMsg_(my_hMidiOut4,($7F3B98))
      Else
         midiOutShortMsg_(my_hMidiOut4,($003B98))
      EndIf
 
      
      
      If Mid(LedBin(24),5,1) ="1";F17J
         midiOutShortMsg_(my_hMidiOut4,($7F3D98))
      Else
         midiOutShortMsg_(my_hMidiOut4,($003D98))
      EndIf
      
      If Mid(LedBin(24),4,1) ="1";F17V
         midiOutShortMsg_(my_hMidiOut4,($7F3E98))
      Else
         midiOutShortMsg_(my_hMidiOut4,($003E98))
      EndIf
      
      
     
      If Mid(LedBin(24),2,1) ="1";F18J
         midiOutShortMsg_(my_hMidiOut4,($7F4098))
      Else
         midiOutShortMsg_(my_hMidiOut4,($004098))
      EndIf
      
      If Mid(LedBin(24),1,1) ="1";F18V
         midiOutShortMsg_(my_hMidiOut4,($7F4198))
      Else
         midiOutShortMsg_(my_hMidiOut4,($004198))
       EndIf
       
       
     EndIf
     
   EndProcedure
   
   
      Procedure readled25(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+25,@LedValue(25),1,0)
      LedBin.s(25) = RSet(Bin(LedValue(25),#PB_Byte) ,8,"0") 
     
       
  ;------------------------------------------ 25      
       
     If LedValueIpad(25)<>LedValue(25)
      LedValueIpad(25)=LedValue(25) 
       
       
       If Mid(LedBin(25),8,1) ="1";LEARN
         midiOutShortMsg_(my_hMidiOut4,($7F4298))
      Else
        midiOutShortMsg_(my_hMidiOut4,($004298))
      EndIf
      
      If Mid(LedBin(25),7,1) ="1";PAUSE
         midiOutShortMsg_(my_hMidiOut4,($7F4398))
      Else
         midiOutShortMsg_(my_hMidiOut4,($004398))
      EndIf
 
      If Mid(LedBin(25),6,1) ="1";>>>
         midiOutShortMsg_(my_hMidiOut4,($7F4498))
      Else
         midiOutShortMsg_(my_hMidiOut4,($004498))
      EndIf
      
      If Mid(LedBin(25),5,1) ="1";GO+
         midiOutShortMsg_(my_hMidiOut4,($7F4598))
      Else
         midiOutShortMsg_(my_hMidiOut4,($004598))
      EndIf
      
      If Mid(LedBin(25),4,1) ="1";TEMP
         midiOutShortMsg_(my_hMidiOut4,($7F4698))
      Else
         midiOutShortMsg_(my_hMidiOut4,($004698))
      EndIf
      
      If Mid(LedBin(25),3,1) ="1";ON
         midiOutShortMsg_(my_hMidiOut4,($7F4798))
      Else
         midiOutShortMsg_(my_hMidiOut4,($004798))
      EndIf
     
      If Mid(LedBin(25),2,1) ="1";OFF
         midiOutShortMsg_(my_hMidiOut4,($7F4898))
      Else
         midiOutShortMsg_(my_hMidiOut4,($004898))
      EndIf
      
    EndIf
    
  EndProcedure
  
  
     Procedure readled26(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+26,@LedValue(26),1,0)
      LedBin.s(26) = RSet(Bin(LedValue(26),#PB_Byte) ,8,"0") 
    
    
 ;------------------------------------------ 26      
 
 If LedValueIpad(26)<>LedValue(26)
      LedValueIpad(26)=LedValue(26)
      
      
      
      If Mid(LedBin(26),5,1) ="1";FIX
         midiOutShortMsg_(my_hMidiOut4,($7F4D98))
      Else
         midiOutShortMsg_(my_hMidiOut4,($004D98))
      EndIf
      
      If Mid(LedBin(26),4,1) ="1";SELECT
         midiOutShortMsg_(my_hMidiOut4,($7F4E98))
      Else
         midiOutShortMsg_(my_hMidiOut4,($004E98))
      EndIf
      
      If Mid(LedBin(26),3,1) ="1";TOP
         midiOutShortMsg_(my_hMidiOut4,($7F4F98))
      Else
         midiOutShortMsg_(my_hMidiOut4,($004F98))
      EndIf
     
      If Mid(LedBin(26),2,1) ="1";<<<
         midiOutShortMsg_(my_hMidiOut4,($7F5098))
      Else
         midiOutShortMsg_(my_hMidiOut4,($005098))
      EndIf
      
      If Mid(LedBin(26),1,1) ="1";GO-
         midiOutShortMsg_(my_hMidiOut4,($7F5198))
      Else
         midiOutShortMsg_(my_hMidiOut4,($005198))
       EndIf
       
       
     EndIf
     
       
   EndProcedure
   
   
      Procedure readled28(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+28,@LedValue(28),1,0)
      LedBin.s(28) = RSet(Bin(LedValue(28),#PB_Byte) ,8,"0") 
       
 ;------------------------------------------ 28       
       
    If LedValueIpad(28)<>LedValue(28)
      LedValueIpad(28)=LedValue(28)   
       
       
       
       
       
       
       
       If Mid(LedBin(28),8,1) ="1";VIEW POOL
         midiOutShortMsg_(my_hMidiOut4,($7F5A98))
       Else
         midiOutShortMsg_(my_hMidiOut4,($005A98))
      EndIf
      
      If Mid(LedBin(28),7,1) ="1";BACKGRD
         midiOutShortMsg_(my_hMidiOut4,($7F5B98))
      Else
         midiOutShortMsg_(my_hMidiOut4,($005B98))
      EndIf
 
      If Mid(LedBin(28),6,1) ="1";KEYBRD
         midiOutShortMsg_(my_hMidiOut4,($7F5C98))
      Else
         midiOutShortMsg_(my_hMidiOut4,($005C98))
      EndIf
      
      
    EndIf
    
  EndProcedure
  
  
     Procedure readled29(*bidon)
  
  Shared LedValue()
  Shared LedBin.s()
  Shared LedValueIpad()
  Shared Launch()
  Shared LaunchJ()
  
   

      ReadProcessMemory_(pHandle,LedAddress+29,@LedValue(29),1,0)
      LedBin.s(29) = RSet(Bin(LedValue(29),#PB_Byte) ,8,"0") 
      
 ;------------------------------------------ 29 
 
 If LedValueIpad(29)<>LedValue(29)
      LedValueIpad(29)=LedValue(29)
 
 
     
      If Mid(LedBin(29),2,1) ="1";TIM MAN V
         midiOutShortMsg_(my_hMidiOut4,($7F6898))
      Else
         midiOutShortMsg_(my_hMidiOut4,($006898))
      EndIf
      
      If Mid(LedBin(29),1,1) ="1";TIM MAN R
         midiOutShortMsg_(my_hMidiOut4,($7F6998))
      Else
         midiOutShortMsg_(my_hMidiOut4,($006998))
       EndIf
     EndIf
     
       
     EndProcedure
     


     CreateThread (@readled1(),*bidon)
     CreateThread (@readled2(),*bidon)
     CreateThread (@readled3(),*bidon)
     CreateThread (@readled4(),*bidon)
     CreateThread (@readled5(),*bidon)
     CreateThread (@readled6(),*bidon)
     CreateThread (@readled7(),*bidon)
     CreateThread (@readled8(),*bidon)
     CreateThread (@readled9(),*bidon)
     CreateThread (@readled10(),*bidon)
     CreateThread (@readled11(),*bidon)
     CreateThread (@readled12(),*bidon)
     CreateThread (@readled13(),*bidon)
     CreateThread (@readled14(),*bidon)
     CreateThread (@readled15(),*bidon)
     CreateThread (@readled16(),*bidon)
     CreateThread (@readled17(),*bidon)
     CreateThread (@readled18(),*bidon)
     CreateThread (@readled19(),*bidon)
     CreateThread (@readled20(),*bidon)
     CreateThread (@readled21(),*bidon)
     CreateThread (@readled22(),*bidon)
     CreateThread (@readled23(),*bidon)
     CreateThread (@readled24(),*bidon)
     CreateThread (@readled25(),*bidon)
     CreateThread (@readled26(),*bidon)
     CreateThread (@readled28(),*bidon)
     CreateThread (@readled29(),*bidon)
; IDE Options = PureBasic 5.50 (Windows - x64)
; CursorPosition = 2011
; FirstLine = 1953
; Folding = -----
; EnableXP
; EnableUnicode