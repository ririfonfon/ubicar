
If LoadXML (10,"defo.xml")
   Debug "load defo.xml"
   
   Defo = MainXMLNode(10)

   
  

   
   
        d3$=GetXMLAttribute(Defo,"id3")
        d2$=GetXMLAttribute(Defo,"id2")
        d12$=GetXMLAttribute(Defo,"id12")
        d14$=GetXMLAttribute(Defo,"id14")
        d20$=GetXMLAttribute(Defo,"id20")
        d32$=GetXMLAttribute(Defo,"id32")
        d34$=GetXMLAttribute(Defo,"id34")
        d42$=GetXMLAttribute(Defo,"id42")
        d44$=GetXMLAttribute(Defo,"id44")
        d52$=GetXMLAttribute(Defo,"id52")
        d54$=GetXMLAttribute(Defo,"id54")
        Debug " xml load = " + d3$ + d2$ + d12$ + d14$ + d20$ + d32$ + d34$ +d42$ + d44$ + d52$ + d54$
        
       
      EndIf
; IDE Options = PureBasic 5.50 (Windows - x86)
; CursorPosition = 7
; EnableXP