;======== make by riri ==============


Procedure.l SearchMemPosition()  

  ;If no valid data, go out
  If (wHwnd = 0) And (pHandle = 0) And (pid = 0)     
    If #ShowMsgBox : CloseConsole () :MessageRequester ("ERROR", "Window seems to be Closed") : EndIf
    ProcedureReturn #False
  EndIf
  
  ;Declare Variables
  i.l
  j.l 
  f.s


  PtoInicio.l   ;Init mem value to search from
  PtoFinal.l    ;Final mem value to search to
  Salto.l        ;We jump page to page (&H1000) if we enter or we are in no Readable memory, to go faster.
               
  Comparar.b   ;"Boolean" Flad to compare or not 
  Size.l           ;Size of Array we look for.....
  
  Dim CadenaParaBuscar.b(30);pour la chaine de recherche   ;PureBasic arrays always global, index 0 not used. Array with the data we search
  Dim CadenaLeida.b(30);le chemin de la chaine             ;idem, readed array from memory


chkTurboFind.b    ;#True or #False
chkTurboFind = #True
LecturaCorrecta.b     ;Flag to know if we are in readable memory or not

PtoEncontrado = 0        ;Stores the mem position if found, else = 0


;======================================================================================================================
;======================================================================================================================


;Values to define the limits of the search inside onPC memory to realize the connection
; if we know the common values we can make the search faster by changing them here.
;======================================================================================================================
;; Pto Une erreur s'est produite à la fin il était très faible. 
;; (je suis allé jusqu'à 8 chiffres pour w7, 7 chiffres, c'est pour XP)
;; 7FFFFFF $ est la limite positive signé long, donne un bug dans la boucle while principal!  
;; ne peut pas aller au-delà, mais pas hors de tout et recommencer à partir de zéro (je suppose)
;======================================================================================================================
;              W7         XP          W7          XP W7 Wait
;PtoInicio =  $10000000 ; $1000000    $10000000   $10000000    
;PtoFinal =   $7FFFFFFF ; $6FFFFFF    $70000000   $7F000000          
 
                                                                
 If OsDetect=1
      PtoInicio = $1000000
      PtoFinal =  $6FFFFFF
      CadenaParaBuscar(0)  = 11
 EndIf
 
 If OsDetect=2
      PtoInicio = $1000000
      PtoFinal =  $6FFFFFF
      CadenaParaBuscar(0)  = 11
 EndIf
 
 If OsDetect=3
      PtoInicio = $1000000
      PtoFinal =  $6FFFFFF
      CadenaParaBuscar(0)  = 11 ;tablet pc = 0
 EndIf
 
 If OsDetect=4
      PtoInicio = $1000000
      PtoFinal =  $6FFFFFF
      CadenaParaBuscar(0)  = 11
 EndIf
 If OsDetect=5
      PtoInicio = $10000000
      PtoFinal =  $7FFFFFFF
      CadenaParaBuscar(0)  = 11
 EndIf
 
      
;  "11" "24 24 24 24 24 24 24" "00"  This is the reference string we must to look for                                          

;  "00" "24 24 24 24 24 24 24" "00"  This is the string we look for in the Windows 7 of the user  "riri" 


; We give the values to the string, byte by byte (from index zero to 8)

;CadenaParaBuscar(0)  = 0 ; only for use in Windows 7 for "ririfonfon@free.fr"
;CadenaParaBuscar(0)  = 11 default xp ? TRANSBO 
 

Size = 7 
For i = 1 To Size
      CadenaParaBuscar(i)  = 24
Next i

CadenaParaBuscar(8)  = 0   ;dernier octet de voir là où la chaîne touche


; Pour rendre la recherche plus rapide d'abord regarder si il ya un "24" et le cas échéant regarder le reste

Size = 8 ; test 8 japan, test 4 faster

; Calculer la position de départ, sinon hex1000 lisible et si elle n'est pas ronde saut vers le bas
If ReadProcessMemory_(pHandle, PtoInicio, @CadenaLeida(1), 1, 0) = 0  ;Avant de lire indice en chaîne était de 1
        Salto = 4096                  ;We will go page to page (&H1000) jumping    
        ;To do that I set the beginning to the beginning of the closest page
        PtoInicio = PtoInicio - (PtoInicio % 4096)
Else
        Salto = 8                      ;We go 8 by 8 as explained above
        ;I set the beginning of the first "ending 0" memory position, if not we can not go 8 by 8...
        PtoInicio = PtoInicio - (PtoInicio % 16) 
EndIf
   

j = PtoInicio             ;Variable to strore the actual start position if the search

;Main LOOP


PrintN ("First Mem Position &h"+Hex(j))
Debug "First Mem Position &h"+Hex(j)

While (j <= PtoFinal)

;Debug "&h"+Hex(j)

    If ReadProcessMemory_(pHandle, j , @CadenaLeida(1), 1, 0) = 0
    
          ; we enter into non readeable memory so we go page by page (&H1000)
          ;*Debug "error reading target memory"
          
          Salto = 4096 
          ;*Debug "big jump = 4096 " + Hex(j + salto)+"&h"

    Else

          ; we can comparare ... 
          If CadenaLeida(1) = 24
              
                  ; we read also the byte before the target string to verify!!
                  If ReadProcessMemory_(pHandle, j - 1 , @CadenaLeida(0), 9, 0) = 0
                      PrintN ("error reading byte before target string no 11 else 00 ")
                     If CadenaParaBuscar(0)  = 11 : CadenaParaBuscar(0)  = 00 :EndIf
                      
                  Else
                      ;;;;i=i+1
  ;;RIRI              Debug Hex(j)+"&h"+ " Found 24s = " + Str(i)
                      If CompareMemory(@CadenaParaBuscar(0), @CadenaLeida(0), 9)
                           Debug "The match in " + Hex(j)
                           If #ShowMsgBox = 1 : PrintN ("One possible number Found! Take note of number &h"+Hex(j)) :EndIf
                           PtoEncontrado = j 
                           ProcedureReturn PtoEncontrado 
                      EndIf
                  EndIf
              
          EndIf
      
          Salto = 8      ;so we go 8 by 8 again
      
    EndIf
        
 j = j + Salto  ;increment the position.... 
 
Wend
   
  ProcedureReturn 0
EndProcedure



; IDE Options = PureBasic 5.50 (Windows - x86)
; CursorPosition = 78
; FirstLine = 42
; Folding = -
; UseIcon = ..\..\812\icon.ico
; Executable = ..\..\midi 2\MAT 2.exe