/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³VLIB - Modificada para trabalhar com a fonte VisualLib                    ³
  ³Modificada em: 01/05/2009                                                 ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
#include "common.ch"
#include "inkey.ch"

#ifdef K_MINMOUSE
   
#else
   #define K_MINMOUSE              1001
   #define K_MAXMOUSE              1007
#endif

STATIC STATIC1, STATIC2:= .F., STATIC3, STATIC4, STATIC5, STATIC6, ;
   STATIC7, STATIC8, STATIC9, STATIC10
STATIC STATIC11:= ""
STATIC STATIC12, STATIC13:= .T., STATIC14:= .F., STATIC15:= .F., ;
   STATIC16:= .F., STATIC17:= 0, STATIC18:= {}, STATIC19:= 0, ;
   STATIC20:= 0, STATIC21:= 0, STATIC22:= {180, {|| vlmarquee()}}
STATIC ;
   arrMouseInfLeft  := { 0,0,0 },;
   arrMouseInfRight := { 0,0,0 }
STATIC ;
   sbGuiSupport   := .F.,;
   sbGuiSupportEx := .F.


********************************
function WAITSTATE

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7
   Local1:= {0, Nil, Nil}
   Local3:= array(4)
   Local4:= vlscrsaver()
   resettimer()
   do while (Local1[1] == 0)
/***
      rrr := row()
      ccc := col()

      @ 0,0 say rrr
      ?? ' ', ccc, ' cursor: ', setcursor(0)
      setpos(rrr,ccc)
      /***/
      if (Seconds() - gettimer() > Local4[1])
         eval(Local4[2])
         resettimer()
      endif
      if ((Local2:= nInkey(0.5)) != 0)//.1
         Local1[2]:= Local2
         Local1[1]:= 1
      else
         vlmouseinf(Local3)
         if (Local3[1] .Or. Local3[2])
            if (STATIC19 == 0 .Or. STATIC19 == 3)
               Local1[1]:= STATIC19:= 2
               Local1[2]:= Local3[3]
               Local1[3]:= Local3[4]
               STATIC20:= Local3[3]
               STATIC21:= Local3[4]
            elseif ((STATIC19 == 2 .Or. STATIC19 == 4) .And. ;
                  (Local3[3] != STATIC20 .Or. Local3[4] != STATIC21))
               Local1[1]:= STATIC19:= 4
               Local1[2]:= Local3[3]
               Local1[3]:= Local3[4]
               STATIC20:= Local3[3]
               STATIC21:= Local3[4]
            endif
         elseif (STATIC19 == 2 .Or. STATIC19 == 4)
            Local1[1]:= STATIC19:= 3
            Local1[2]:= Local3[3]
            Local1[3]:= Local3[4]
         else
            Local1[1]:= STATIC19:= 0
         endif
      endif
      if (Local1[1] == 3)
         Local7:= aclone(getkeymouse())
         for Local6:= 1 to Len(Local7)
            if (Local1[2] >= Local7[Local6][2][1] .And. Local1[2] <= ;
                  Local7[Local6][2][2] .And. Local1[3] >= ;
                  Local7[Local6][2][3] .And. Local1[3] <= ;
                  Local7[Local6][2][4])
               Local1[1]:= STATIC19:= 0
               if ((Local5:= SetKey(Local7[Local6][1])) != Nil)
                  eval(Local5, procname(1), procline(1), "")
               endif
            endif
         next
      endif
   enddo
   RETURN Local1

//*******************************
function MSGBOX4(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, ;
      Arg9, Arg10, Arg11, Arg12)

   local Local1, Local2, Local3, Local4
   lDesligaRedraw := .t.

   Arg4:= iif(ISNil(Arg4), "&Sim", Arg4)
   Arg5:= iif(ISNil(Arg5), "&NÆo", Arg5)
   Arg6:= iif(ISNil(Arg6), "&Cancelar", Arg6)
   Arg7:= iif(ISNil(Arg7), "&Outros", Arg7)

   Arg8:= iif(ISNil(Arg8), 1, Arg8)
   Arg9:= iif(ISNil(Arg9), 3, Arg9)
   Arg1:= iif(ISNil(Arg1), "", Arg1)
   Arg2:= iif(ISNil(Arg2), "Aten‡Æo!", Arg2)
   Local1:= iif(ISARRAY(Arg1), Len(Arg1), 1)
   Arg3:= iif(ISNil(Arg3), Int(12 - (Local1 + 7) / 2), Arg3)
   Arg10:= iif(ISNil(Arg10), "W+/R", Arg10)
   Arg11:= iif(ISNil(Arg11), "R/W*", Arg11)
   Arg12:= iif(ISNil(Arg12), "N*/W", Arg12)
   Local3:= newbutton()
   nColIni:=(MaxCol()-64) / 2

   ciAdicional = 0
   TamStr = 0
   TamOpc = 0
   TamOpc += len(Arg4)+4+4
   TamOpc += len(Arg5)+4+4
   TamOpc += len(Arg6)+4+4
   TamOpc += len(Arg7)+4

   if (ISARRAY(Arg1)) // mensagem
      for Local4:= 1 to len(Arg1)
         TamStr = iif(len(Arg1[Local4]) > TamStr,len(Arg1[Local4]),TamStr)
      next
   else
      TamStr = len(Arg1)
   endif

   if TamOpc < TamStr
      ciAdicional = (TamStr-TamOpc)/2
   endif

   TamStr = iif(TamStr>TamOpc,TamStr,TamOpc)

   Ci:=int(((maxcol()-TamStr)/2))
   Cf:=Ci+TamStr

   addbutton(Local3, Arg3 + 3 + Local1, Ci+ciAdicional                                    , len(Arg4)+6, Arg4, Nil,     iif(Arg9 == 1, .T., .F.))
   addbutton(Local3, Arg3 + 3 + Local1, Ci+len(Arg4)+8+ciAdicional                        , len(Arg5)+6, Arg5, Nil, iif(Arg9 == 2, .T., .F.))
   addbutton(Local3, Arg3 + 3 + Local1, Ci+len(Arg4)+8+len(Arg5)+8+ciAdicional            , len(Arg6)+6, Arg6, Nil, iif(Arg9 == 3, .T., .F.))
   addbutton(Local3, Arg3 + 3 + Local1, Ci+len(Arg4)+8+len(Arg5)+8+len(Arg6)+8+ciAdicional, len(Arg7)+6, Arg7, Nil, iif(Arg9 == 3, .T., .F.))

   Local2:= win(Arg3, Ci-3, Arg3 + 5 + Local1, cf+3, Arg2, Arg10, Arg11)

   if (ISARRAY(Arg1))
      for Local4:= 1 to Local1
         DevPos(Arg3 + 1 + Local4, ci)
         vldevout(padc(Arg1[Local4],TamStr), Arg12)
      next
   else
      DevPos(Arg3 + 2, ci)
      vldevout(padc(Arg1,TamStr), Arg12)
   endif
   setcursor(0)
   Local4:= procbutton(Local3, 2, iif(Arg8 < 3, Arg8, 2))
   rstenv(Local2)

   lDesligaRedraw := .f.

RETURN Local4

********************************
function NEWBUTTON

   RETURN {}

********************************
function ADDBUTTON(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, ;
   Arg9)

   local Local1
   Arg5:= iif(At("&", Arg5) == 0, "&" + Arg5, Arg5)
   Arg7:= iif(ISNil(Arg7), .F., Arg7)
   Arg8:= iif(ISNil(Arg8), {|| Nil}, Arg8)
   Arg9:= iif(ISNil(Arg9), .T., Arg9)
   Local1:= SubStr(Arg5, At("&", Arg5) + 1, 1)
   AAdd(Arg1, {Arg5, Arg6, Arg8, Arg9, Arg7, Arg2, Arg3, Local1, ;
      Arg4})
   RETURN Nil

********************************
function SHOWBUTTON(Arg1, Arg2, Arg3)

   aeval(Arg1, {|_1| drawbutton(_1, Arg2, Arg3)})
   RETURN Nil

********************************
STATIC function BUTEXECUTE(Arg1, Arg2, Arg3, Arg4)

   drawbutton(Arg1[Arg2], Arg3, Arg4, 3, .F., .F.)
   InKey(0.1) //.1
   drawbutton(Arg1[Arg2], Arg3, Arg4, 2, .F.)
   eval(Arg1[Arg2][3])
   InKey(0.1) //.1
   hidebutfoc(Arg1[Arg2], Arg3, Arg4)
   RETURN Arg2

********************************
function BUTTONCOLOr(Arg1)
   RETURN BUTTONCOLO(Arg1)

function BUTTONCOLOrs(Arg1)
   RETURN BUTTONCOLO(Arg1)

function BUTTONCOLO(Arg1)

   local Local1
   Local1:= {}
   Arg1:= iif(ISNil(Arg1), 1, 2)
   if (Arg1 == 1)
      AAdd(Local1, "N/W")
      AAdd(Local1, "W*/N")
      AAdd(Local1, "N*/N")
      AAdd(Local1, "W+*/N")
      AAdd(Local1, "W*/N")
      AAdd(Local1, "W+*/N")
      AAdd(Local1, "N+*/N")
      AAdd(Local1, "GR+*/N")
      AAdd(Local1, "R*/W")
   elseif (Arg1 == 2)
      AAdd(Local1, "N*/W")
      AAdd(Local1, "W+/W")
      AAdd(Local1, "N+/W")
      AAdd(Local1, "N/W")
      AAdd(Local1, "N+/W")
      AAdd(Local1, "N/W")
      AAdd(Local1, "W/W")
      AAdd(Local1, "W+/W")
      AAdd(Local1, "R*/W")
   endif
   RETURN Local1

********************************
function VLGETGOTO(Arg1)

   local Local1, Local2
   Local1:= getactive()
   Local2:= ascan(getlist, {|_1| _1 == Local1})
   if (Local2 > Arg1)
      Local1:exitstate(1)
   else
      Local1:exitstate(2)
   endif
   vlgetmovto(Arg1)
   RETURN Nil

********************************
function NEWBARMENU

   RETURN {}

********************************
function TEXTMENU(Arg1)

   local Local1, Local2, Local3
   Local1:= At("&", Arg1)
   Local2:= SubStr(Arg1, 1, Local1 - 1)
   Local3:= SubStr(Arg1, Local1 + 1)
   RETURN iif(Local1 != 0, Local2 + Local3, Arg1)

********************************
function SETBARMSG(Arg1)

   local Local1
   Local1:= STATIC13
   if (Arg1 != Nil)
      STATIC13:= Arg1
   endif
   RETURN Local1

********************************
STATIC function DRAWBUTTON(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7, ;
      Local8, Local9, Local10, Local11, Local12, Local13, Local14, ;
      Local15, Local16, Local17, Local18, Local19, Local20, Local21
   Arg4:= iif(ISNil(Arg4), 1, Arg4)
   Arg5:= iif(ISNil(Arg5), .T., Arg5)
   Arg6:= iif(ISNil(Arg6), .T., Arg6)
   Local10:= textbutton(Arg1[1])
   if (Arg2 == 1)
      Local1:= "N/W"
      Local2:= iif(Arg6, "W*/N", "N*/N")
      Local3:= "W+*/N"
      Local4:= "W*/N"
      Local6:= "W+*/N"
      Local7:= "N+*/N"
      Local9:= iif(Arg1[4], "GR+*/N", "W*/N")
   elseif (Arg2 == 2)
      Local1:= "N*/W"
      Local2:= iif(Arg6, "W+/W", "N+/W")
      Local3:= "N/W"
      Local4:= "N+/W"
      Local6:= "N/W"
      Local7:= "W/W"
      Local9:= iif(Arg1[4], "W+/W", "N+/W")
   elseif (Arg2 == 3)
      Local1:= Arg3[1]
      Local2:= iif(Arg6, Arg3[2], Arg3[3])
      Local3:= Arg3[4]
      Local4:= Arg3[5]
      Local6:= Arg3[6]
      Local7:= Arg3[7]
      Local9:= iif(Arg1[4], Arg3[8], Arg3[5])
   endif
   if (Arg4 == 1)
      Local10:= padc(Local10, Arg1[9] - 3)
      Local11:= At(Upper(Arg1[8]), Upper(Local10)) - 1
      Local5:= iif(Arg1[4], Local3, Local4)
      Local8:= Local7
   elseif (Arg4 == 2)
      Local10:= padc(Local10, Arg1[9] - 3)
      Local11:= At(Upper(Arg1[8]), Upper(Local10)) - 1
      Local5:= iif(Arg1[4], Local3, Local4)
      Local8:= Local6
   elseif (Arg4 == 3)
      Local10:= " " + Left(padc(Local10, Arg1[9] - 3), Arg1[9] - 4)
      Local11:= At(Upper(Arg1[8]), Upper(Local10)) - 1
      Local5:= iif(Arg1[4], Local3, Local4)
      Local8:= Local6
   endif

   // <<<< CORRECAO 1: usa o texto VISIVEL (sem o "&") no calculo da sombra
   Local20:= At(alltrim(Local10), Local10) - 1
   Local21:= Local20 + Len(alltrim(Local10)) + 2

   if (Arg5)
      Local12:= "Õ"
      Local13:= iif(Arg6, "Ý", "×")
      Local14:= "©"
      Local15:= "º"
      Local16:= "½"
      Local17:= "Ð"
      Local18:= "Ó"
      Local19:= "Ü"
   else
      Local12:= "Õ"
      Local13:= "Ý"
      Local14:= "©"
      Local15:= "º"
      Local16:= "½"
      Local17:= "Ð"
      Local18:= "Ó"
      Local19:= "Ü"
   endif

   DevPos(Arg1[6] - 1, Arg1[7])
   vldevout(Local12 + Replicate(Local13, Arg1[9] - 2) + Local14, ;
      Local1)
   DevPos(Arg1[6], Arg1[7])
   vldevout(Local19, Local1)
   DevPos(Arg1[6], Arg1[7] + 1)
   vldevout("º", Local2)
   DevPos(Arg1[6], Arg1[7] + 2)
   vldevout(Local10, Local5)
   DevPos(Arg1[6], Arg1[7] + 2 + Local11)
   vldevout(Arg1[8], Local9)
   DevPos(Arg1[6], Arg1[7] + Arg1[9] - 1)
   vldevout(Local15, Local1)
   DevPos(Arg1[6] + 1, Arg1[7])
   vldevout(Local18 + Replicate(Local17, Arg1[9] - 2) + Local16, ;
      Local1)

   // <<<< CORRECAO 2: limita a sombra 3D DENTRO das bordas
   DevPos(Arg1[6], iif(Arg1[7] + Local20 < Arg1[7] + 1, ;
                       Arg1[7] + 1, Arg1[7] + Local20))
   vldevout(iif( sbGuiSupport,"®","ò"), Local8)

   DevPos(Arg1[6], iif(Arg1[7] + Local21 > Arg1[7] + Arg1[9] - 2, ;
                       Arg1[7] + Arg1[9] - 2, Arg1[7] + Local21))
   vldevout(iif( sbGuiSupport,"¯","ó"), Local8)

   RETURN Nil
   
********************************
STATIC function DRAWBUTTON3(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7, ;
      Local8, Local9, Local10, Local11, Local12, Local13, Local14, ;
      Local15, Local16, Local17, Local18, Local19, Local20, Local21
   Arg4:= iif(ISNil(Arg4), 1, Arg4)
   Arg5:= iif(ISNil(Arg5), .T., Arg5)
   Arg6:= iif(ISNil(Arg6), .T., Arg6)
   Local10:= textbutton(Arg1[1])
   if (Arg2 == 1)
      Local1:= "N/W"
      Local2:= iif(Arg6, "W*/N", "N*/N")
      Local3:= "W+*/N"
      Local4:= "W*/N"
      Local6:= "W+*/N"
      Local7:= "N+*/N"
      Local9:= iif(Arg1[4], "GR+*/N", "W*/N")
   elseif (Arg2 == 2)
      Local1:= "N*/W"
      Local2:= iif(Arg6, "W+/W", "N+/W")
      Local3:= "N/W"
      Local4:= "N+/W"
      Local6:= "N/W"
      Local7:= "W/W"
      Local9:= iif(Arg1[4], "W+/W", "N+/W")
   elseif (Arg2 == 3)
      Local1:= Arg3[1]
      Local2:= iif(Arg6, Arg3[2], Arg3[3])
      Local3:= Arg3[4]
      Local4:= Arg3[5]
      Local6:= Arg3[6]
      Local7:= Arg3[7]
      Local9:= iif(Arg1[4], Arg3[8], Arg3[5])
   endif
   if (Arg4 == 1)
      Local10:= padc(Local10, Arg1[9] - 3)
      Local11:= At(Upper(Arg1[8]), Upper(Local10)) - 1
      Local5:= iif(Arg1[4], Local3, Local4)
      Local8:= Local7
   elseif (Arg4 == 2)
      Local10:= padc(Local10, Arg1[9] - 3)
      Local11:= At(Upper(Arg1[8]), Upper(Local10)) - 1
      Local5:= iif(Arg1[4], Local3, Local4)
      Local8:= Local6
   elseif (Arg4 == 3)
      Local10:= " " + Left(padc(Local10, Arg1[9] - 3), Arg1[9] - 4)
      Local11:= At(Upper(Arg1[8]), Upper(Local10)) - 1
      Local5:= iif(Arg1[4], Local3, Local4)
      Local8:= Local6
   endif
   Local20:= At(alltrim(Local10), Local10) - 1
   Local21:= Local20 + Len(Arg1[1]) + 2
   if (Arg5)
      Local12:= "Õ"
      Local13:= iif(Arg6, "Ý", "×")
      Local14:= "©"
      Local15:= "º"
      Local16:= "½"
      Local17:= "Ð"
      Local18:= "Ó"
      Local19:= "Ü"
   else

      Local12:= "Õ"
      Local13:= "Ý"
      Local14:= "©"
      Local15:= "º"
      Local16:= "½"
      Local17:= "Ð"
      Local18:= "Ó"
      Local19:= "Ü"


   endif
   
   DevPos(Arg1[6] - 1, Arg1[7])
   vldevout(Local12 + Replicate(Local13, Arg1[9] - 2) + Local14, ;
      Local1)
   DevPos(Arg1[6], Arg1[7])
   vldevout(Local19, Local1)
   DevPos(Arg1[6], Arg1[7] + 1)

   vldevout("º", Local2)
   
   DevPos(Arg1[6], Arg1[7] + 2)
   vldevout(Local10, Local5)
   DevPos(Arg1[6], Arg1[7] + 2 + Local11)
   vldevout(Arg1[8], Local9)
   DevPos(Arg1[6], Arg1[7] + Arg1[9] - 1)
   vldevout(Local15, Local1)
   DevPos(Arg1[6] + 1, Arg1[7])
   vldevout(Local18 + Replicate(Local17, Arg1[9] - 2) + Local16, ;
      Local1)
   DevPos(Arg1[6], Arg1[7] + Local20)
   vldevout(iif( sbGuiSupport,"®","ò"), Local8)
   DevPos(Arg1[6], Arg1[7] + Local21)
   vldevout(iif( sbGuiSupport,"¯","ó"), Local8)
   RETURN Nil

********************************
STATIC function TEXTBUTTON(Arg1)

   local Local1, Local2, Local3, Local4
   Local1:= ""
   Local2:= At("&", Arg1)
   Local3:= SubStr(Arg1, 1, Local2 - 1)
   Local4:= SubStr(Arg1, Local2 + 1)
   RETURN iif(Local2 != 0, Local3 + Local4, Arg1)

********************************
function SETBUTTON(Arg1, Arg2, Arg3)

   local Local1
   Local1:= Arg1[Arg2][4]
   if (Arg3 != Nil)
      Arg1[Arg2][4]:= Arg3
   endif
   RETURN Local1

********************************
STATIC function SHOWBUTFOC(Arg1, Arg2, Arg3)

   drawbutton(Arg1, Arg2, Arg3, 2, .F.)
   showbutmsg(Arg1, Arg2, Arg3)
   RETURN Nil

********************************
STATIC function CHKBTMOUSE(Arg1, Arg2)

   local Local1, Local2, Local3, Local4
   Local1:= nbut:= 0
   for Local1:= 1 to Len(Arg1)
      Local2:= Arg1[Local1][6]
      Local3:= Arg1[Local1][7]
      Local4:= Arg1[Local1][7] + Arg1[Local1][9] - 1
      if (Arg2[2] == Local2 .And. Arg2[3] >= Local3 .And. Arg2[3] <= ;
            Local4)
         nbut:= Local1
         exit
      endif
   next
   RETURN nbut

********************************
STATIC function BUTLEFT(Arg1, Arg2, Arg3, Arg4)

   hidebutfoc(Arg1[Arg2], Arg3, Arg4)
   Arg2:= iif(--Arg2 == 0, Len(Arg1), Arg2)
   showbutfoc(Arg1[Arg2], Arg3, Arg4)
   RETURN Arg2

********************************
STATIC function BUTRIGHT(Arg1, Arg2, Arg3, Arg4)

   hidebutfoc(Arg1[Arg2], Arg3, Arg4)
   Arg2:= iif(++Arg2 > Len(Arg1), 1, Arg2)
   showbutfoc(Arg1[Arg2], Arg3, Arg4)
   RETURN Arg2

********************************
STATIC function BUTGOTO(Arg1, Arg2, Arg3, Arg4, Arg5)

   hidebutfoc(Arg1[Arg2], Arg4, Arg5)
   Arg2:= iif(Len(Arg1) >= Arg3, Arg3, Arg2)
   showbutfoc(Arg1[Arg2], Arg4, Arg5)
   RETURN Arg2

********************************
function VLGETMOVTO(Arg1)

   local Local1
   Local1:= STATIC12
   if (PCount() > 0)
      STATIC12:= Arg1
   endif
   RETURN Local1

********************************
function PROCBUTTON(Arg1, Arg2, Arg3, Arg4)

   local Local1, Local2, Local3, Local4, Local5
   Local1:= setcursor(0)
   Local5:= 0
   Arg2:= iif(ISNil(Arg2), 1, Arg2)
   Arg3:= iif(ISNil(Arg3), 1, Arg3)
   showbutton(Arg1, Arg2, Arg4)
   do while (!Arg1[Arg3][4])
      Arg3:= iif(++Arg3 > Len(Arg1), 1, Arg3)
   enddo
   do while (Local5 == 0)
      showbutfoc(Arg1[Arg3], Arg2, Arg4)
      Local2:= waitstate()
      do case
      case Local2[1] == 1
         do case
         case (Local3:= ascan(Arg1, {|_1| Upper(Chr(Local2[2])) == ;
               Upper(_1[8])})) != 0
            Arg3:= butgoto(Arg1, Arg3, Local3, Arg2, Arg4)
            Arg3:= Local5:= butexecute(Arg1, Arg3, Arg2, Arg4)
         case Local2[2] == 19 .Or. Local2[2] == 271 .Or. Local2[2] ;
               == 5
            Arg3:= butleft(Arg1, Arg3, Arg2, Arg4)
         case Local2[2] == 4 .Or. Local2[2] == 9 .Or. Local2[2] == 24
            Arg3:= butright(Arg1, Arg3, Arg2, Arg4)
         case Local2[2] == 27
            if ((Local3:= ascan(Arg1, {|_1| _1[5]})) != 0 .And. ;
                  Arg1[Local3][4])
               Arg3:= butgoto(Arg1, Arg3, Local3, Arg2, Arg4)
               Arg3:= Local5:= butexecute(Arg1, Arg3, Arg2, Arg4)
            endif
         case Local2[2] == 13 .And. Arg1[Arg3][4]
            Arg3:= Local5:= butexecute(Arg1, Arg3, Arg2, Arg4)
         endcase
      case Local2[1] == 2
         if ((Local4:= chkbtmouse(Arg1, Local2)) != 0 .And. Local4 ;
               != Arg3)
            Arg3:= butgoto(Arg1, Arg3, Local4, Arg2, Arg4)
         endif
      case Local2[1] == 3
         if ((Local4:= chkbtmouse(Arg1, Local2)) != 0)
            Arg3:= butgoto(Arg1, Arg3, Local4, Arg2, Arg4)
            Arg3:= Local5:= butexecute(Arg1, Local4, Arg2, Arg4)
         endif
      case Local2[1] == 4
         if ((Local4:= chkbtmouse(Arg1, Local2)) != 0 .And. Local4 ;
               != Arg3)
            Arg3:= butgoto(Arg1, Arg3, Local4, Arg2, Arg4)
         endif
      endcase
   enddo
   setcursor(Local1)
   RETURN Local5

********************************
STATIC function SHOWBUTMSG(Arg1, Arg2, Arg3)

   local Local1
   Local1:= iif(Arg2 == 3, Arg3[9], "R*/W")
   if (Arg1[2] != Nil .Or. Arg1[2] != "")
      dwnmsg(Arg1[2], Local1)
   endif
   RETURN Nil

********************************
STATIC function HIDEBUTFOC(Arg1, Arg2, Arg3)

   drawbutton(Arg1, Arg2, Arg3, 1, .T.)
   RETURN Nil

********************************
procedure VLGETReadER(Arg1)
      RETURN VLGETReadE(Arg1)

procedure VLGETReadE(Arg1)
/**
@ 0,0 say len (getlist )
?? ' ', seconds()

#ifndef __XHARBOUR__
   RETURN __GetListActive():Reader()
#else
   RETURN Arg1:Reader()
#endif
/**/
/**/
   local Local1, Local2, Local3, Local4, Local5, Local6, Local7, ;
      Local8, Local9, Local10, Local11, Local12, Local13
   Local12:= array(4)
   Local1:= ascan(getlist, {|_1| _1 == Arg1})



//   aEval(GetList,{|oGet|WVW_DrawBoxGet(,oGet:Row,oGet:Col,Len(Transform(oGet:VarGet(),oGet:Picture)))})
   
   //WVW_DrawBoxGet(,Arg1:Row,Arg1:Col,Len(Transform(Arg1:VarGet(),Arg1:Picture)))
   

//   MSGBOX1("PASSEI")

   if (!(ISNil(vlgetmovto())) .And. Local1 != vlgetmovto())
      if (Local1 > vlgetmovto())
         Arg1:exitstate(1)
      else
         Arg1:exitstate(2)
      endif
   else
      vlgetmovto(Nil)
      Local10:= getprevalidate(Arg1)
      if (Local10)
         Arg1:setfocus()
         
         SetCursor(1)

         do while (Arg1:exitstate() == 0)
            if (Arg1:typeout())
               Arg1:exitstate(5)
            endif
            do while (Arg1:exitstate() == 0)
               Local3:= .F.
               Local4:= .F.
               do while (!Local4 .And. !Local3)
                  Local13:= waitstate()
                  if (Local13[1] == 1)
                     Local2:= Local13[2]
                     Local4:= .T.
                  endif
                  if (!Local4)
                     Local7:= Local13[2]
                     Local8:= Local13[3]
                     if (Local13[1] == 2)
                        Local9:= ascan(getlist, {|_1| Local7 == ;
                           _1:row() .And. Local8 >= _1:col() .And. ;
                           Local8 <= _1:col() + ;
                           Len(TransForm(_1:varget(), _1:picture())) ;
                           - 1})
                        Local3:= Local9 > 0
                     endif
                  endif
               enddo
               if (Local4)
                  getapplykey(Arg1, Local2)
               else
                  vlgetgoto(Local9)
               endif
            enddo
            Local11:= getpostvalidate(Arg1)
            if (!Local11)
               Arg1:exitstate(0)
               vlgetmovto(Nil)
            endif
         enddo
         Arg1:killfocus()
      endif
   endif
   RETURN
/**/
********************************
/*
function ADDBARITEM(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7)

   local Local1, Local2, Local3
   Local3:= Len(Arg1)
   Arg2:= iif(At("&", Arg2) == 0, "&" + Arg2, Arg2)
   Arg4:= iif(ISNil(Arg4), {|| nret()}, Arg4)
   Arg5:= iif(ISNil(Arg5), .T., Arg5)
   Arg6:= iif(ISNil(Arg6), 1, Arg6)
   Local1:= SubStr(Arg2, At("&", Arg2) + 1, 1)
   Local2:= Len(Arg2) + 1
   if (Local3 == 0)
      Arg7:= iif(ISNil(Arg7), 1, Arg7)
   else
      Arg7:= iif(ISNil(Arg7), Arg1[Local3][7] + Arg1[Local3][8], Arg7)
   endif
   AAdd(Arg1, {Arg2, Arg3, Arg4, Arg5, Local1, Arg6, Arg7, Local2})
   RETURN Nil

*/
function ADDBARITEM(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9)

   local Local1, Local2, Local3
   Local3:= Len(Arg1)
   Arg2:= iif(At("&", Arg2) == 0, "&" + Arg2, Arg2)
   Arg4:= iif(ISNil(Arg4), {|| nret()}, Arg4)
   Arg5:= iif(ISNil(Arg5), .T., Arg5)
   Arg6:= iif(ISNil(Arg6), 1, Arg6)
   Local1:= SubStr(Arg2, At("&", Arg2) + 1, 1)
   Local2:= Len(Arg2) + 1
   if (Local3 == 0)
      Arg7:= iif(ISNil(Arg7), 1, Arg7)
   else
      Arg7:= iif(ISNil(Arg7), Arg1[Local3][7] + Arg1[Local3][8], Arg7)
   endif

   if ISNil(Arg9)
      Arg9 = 0
   endif


   //  AAdd(Arg1, {Arg2, Arg3, Arg4, Arg6, Local1, Arg7, Arg8, .F.   , .F., Arg5, Arg9})
   AAdd(Arg1, {Arg2, Arg3, Arg4, Arg5, Local1, Arg6, Arg7, Local2,    ,     ,Arg9})
RETURN Nil

********************************
function SETBARITEM(Arg1, Arg2, Arg3)

   local Local1
   Local1:= Arg1[Arg2][4]
   if (Arg3 != Nil)
      Arg1[Arg2][4]:= Arg3
   endif
   RETURN Local1

********************************
STATIC function DISPLAYBAR(Arg1, Arg2, Arg3)

   aeval(Arg1, {|_1| (_1[6]:= Arg2, drawbarite(_1, 1, Arg3))})
   RETURN Nil

********************************
STATIC function BARESCAPE(Arg1, Arg2, Arg3)

   RETURN 0

********************************
function NEWDOWNMENU
   RETURN NEWDOWNMEN()

function NEWDOWNMEN

   RETURN {}

********************************
function BARMENU(Arg1, Arg2, Arg3, Arg4)

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7, ;
      Local8
   Local1:= array(4)
   Local2:= setcursor(0)
   Local6:= .T.
   Local7:= .T.
   Local8:= 0
   Arg2:= iif(ISNil(Arg2), 1, Arg2)
   Arg3:= iif(ISNil(Arg3), 1, Arg3)
   Arg4:= iif(PCount() == 4, Arg4, menucolors())
   keyboard Chr(13)
   InKey(0.2) //.1
   do while (Arg3 != 0)
      if (Local6)
         displaybar(Arg1, Arg2, Arg4)
         showbarfoc(Arg1[Arg3], Arg4)
         Local6:= .F.
      endif
      do case
      case setmovleft()
         Arg3:= barleft(Arg1, Arg3, Arg4)
         setmovleft(.F.)
         keyboard Chr(13)
      case setmovrigh()
         Arg3:= barright(Arg1, Arg3, Arg4)
         setmovrigh(.F.)
         keyboard Chr(13)
      case setmovflag() .And. !setbarmsg() .And. (Local3[2] == 19 ;
            .Or. Local3[2] == 4)
         keyboard Chr(13)
      case Arg3 == Local8 .And. LastKey() == K_ESC
         keyboard Chr(13)
         InKey(0.2) //.1
         Local8:= 0
      endcase
      Local3:= waitstate()
      do case
      case Local3[1] == 1
         Local8:= 0
         do case
         case (Local5:= ascan(Arg1, {|_1| Upper(Chr(Local3[2])) == ;
               Upper(_1[5])})) != 0
            Arg3:= bargoto(Arg1, Arg3, Local5, Arg4)
            Arg3:= barexecute(Arg1, Arg3, Arg2, Local5, Arg4)
            Local6:= .T.
         case Local3[2] == 19
            Arg3:= barleft(Arg1, Arg3, Arg4)
         case Local3[2] == 4
            Arg3:= barright(Arg1, Arg3, Arg4)
         case Local3[2] == 27
            Arg3:= barescape(Arg1, Arg3, Arg4)
         case Local3[2] == 13 .And. Arg1[Arg3][4]
            Arg3:= barexecute(Arg1, Arg3, Arg2, Arg3, Arg4)
            Local6:= .T.
         endcase
      case Local3[1] == 2
         if ((Local4:= chkbrmouse(Arg1, Arg2, Local3, Arg3)) > 0)
            setbarmsg(.T.)
            setmovflag(.F.)
            Arg3:= bargoto(Arg1, Arg3, Local4, Arg4)
            Local7:= .T.
         else
            Local7:= .F.
         endif
      case Local3[1] == 3
         if ((Local4:= chkbrmouse(Arg1, Arg2, Local3, Arg3)) > 0 ;
               .And. Local7 .And. Local8 != Arg3 .Or. Local4 > 0 ;
               .And. ISBLOCK(Arg1[Arg3][3]))
            setbarmsg(.T.)
            setmovflag(.F.)
            Arg3:= bargoto(Arg1, Arg3, Local4, Arg4)
            Local8:= Arg3
            Arg3:= barexecute(Arg1, Local4, Arg2, Local4, Arg4)
            Local6:= .T.
         elseif (Local4 > 0)
            Local8:= 0
         endif
      case Local3[1] == 4
         if ((Local4:= chkbrmouse(Arg1, Arg2, Local3, Arg3)) > 0 ;
               .And. Local4 != Arg3 .And. Local7)
            setbarmsg(.T.)
            setmovflag(.F.)
            Arg3:= bargoto(Arg1, Arg3, Local4, Arg4)
            Local8:= 0
         elseif (Local4 == -1 .And. Local7)
            setbarmsg(.T.)
            setmovflag(.F.)
            Local8:= Arg3
            Arg3:= barexecute(Arg1, Arg3, Arg2, Local4, Arg4)
            Local6:= .T.
         endif
      endcase
   enddo
   setcursor(Local2)
   RETURN Arg3

********************************
STATIC function DRAWBARITE(Arg1, Arg2, Arg3)

   local Local1, Local2, Local3, Local4
   Local3:= padr(" " + textmenu(Arg1[1]), Arg1[8])
   Local4:= At("&", Arg1[1])
   if (Arg2 == 1)
      Local1:= iif(Arg1[4], Arg3[1], Arg3[2])
      Local2:= iif(Arg1[4], Arg3[6], Arg3[8])
   elseif (Arg2 == 2)
      Local1:= iif(Arg1[4], Arg3[3], Arg3[4])
      Local2:= iif(Arg1[4], Arg3[5], Arg3[7])
   endif
   DevPos(Arg1[6], Arg1[7])
   vldevout(Local3, Local1)
   DevPos(Arg1[6], Arg1[7] + Local4)
   vldevout(Arg1[5], Local2)
   RETURN Nil

********************************
STATIC function SHOWBARMSG(Arg1, Arg2)

   if (setbarmsg() .And. (Arg1[2] != Nil .Or. Arg1[2] = ""))
      dwnmsg(Arg1[2], Arg2[10])
   endif
   RETURN Nil

********************************
STATIC function SHOWBARFOC(Arg1, Arg2)

   drawbarite(Arg1, 2, Arg2)
   showbarmsg(Arg1, Arg2)
   RETURN Nil

********************************
STATIC function HIDEBARFOC(Arg1, Arg2)

   drawbarite(Arg1, 1, Arg2)
   RETURN Nil

********************************
STATIC function CHKBRMOUSE(Arg1, Arg2, Arg3, Arg4)

   local Local1, Local2, Local3
   nret:= 0
   if (Arg3[2] == Arg2 + 2)
      Local2:= Arg1[Arg4][7]
      Local3:= Arg1[Arg4][7] + Arg1[Arg4][8]
      if (Arg3[3] >= Local2 .And. Arg3[3] <= Local3)
         nret:= -1
      endif
   elseif (Arg3[2] == Arg2)
      for Local1:= 1 to Len(Arg1)
         Local2:= Arg1[Local1][7]
         Local3:= Arg1[Local1][7] + Arg1[Local1][8]
         if (Arg3[3] >= Local2 .And. Arg3[3] <= Local3)
            nret:= Local1
            setmovflag(.F.)
            exit
         endif
      next
   endif
   RETURN nret

********************************
function SETMOVLEFT(Arg1)

   local Local1
   Local1:= STATIC14
   if (Arg1 != Nil)
      STATIC14:= Arg1
   endif
   RETURN Local1

********************************
STATIC function BARLEFT(Arg1, Arg2, Arg3)

   if (setmovflag() .And. setbarmsg())
      setbarmsg(.F.)
   endif
   hidebarfoc(Arg1[Arg2], Arg3)
   Arg2:= iif(--Arg2 == 0, Len(Arg1), Arg2)
   showbarfoc(Arg1[Arg2], Arg3)
   RETURN Arg2

********************************
STATIC function BARRIGHT(Arg1, Arg2, Arg3)

   if (setmovflag() .And. setbarmsg())
      setbarmsg(.F.)
   endif
   hidebarfoc(Arg1[Arg2], Arg3)
   Arg2:= iif(++Arg2 > Len(Arg1), 1, Arg2)
   showbarfoc(Arg1[Arg2], Arg3)
   RETURN Arg2

********************************
STATIC function BARGOTO(Arg1, Arg2, Arg3, Arg4)

   hidebarfoc(Arg1[Arg2], Arg4)
   Arg2:= iif(Len(Arg1) >= Arg3, Arg3, Arg2)
   showbarfoc(Arg1[Arg2], Arg4)
   RETURN Arg2

********************************
STATIC function BAREXECUTE(Arg1, Arg2, Arg3, Arg4, Arg5)

   local Local1
   if (ISARRAY(Arg1[Arg2][3]) .And. Arg1[Arg2][4])
      Local1:= downmenu(Arg1[Arg2][3], 1, Arg1[Arg2][6] + 1, ;
         Arg1[Arg2][7], 1, Arg5, Arg3, Arg1)
      Arg2:= iif(Local1 == -1, Arg2, Local1)
   elseif (ISBLOCK(Arg1[Arg2][3]) .And. Arg1[Arg2][4] .And. Arg4 != ;
         -1)
      if (setmovflag() .And. !setbarmsg())
         setbarmsg(.T.)
      else
         setmovflag(.F.)
         eval(Arg1[Arg2][3])
      endif
   endif
   RETURN Arg2

********************************
function SETMOVRIGHT(Arg1)
   RETURN SETMOVRIGH(Arg1)

function SETMOVRIGH(Arg1)

   local Local1
   Local1:= STATIC15
   if (Arg1 != Nil)
      STATIC15:= Arg1
   endif
   RETURN Local1

********************************
function SETMOVFLAG(Arg1)

   local Local1
   Local1:= STATIC16
   if (Arg1 != Nil)
      STATIC16:= Arg1
   endif
   RETURN Local1

********************************
function MENUCOLORS

   local Local1
   Local1:= {}
   AAdd(Local1, "N*/W")
   AAdd(Local1, "W*/W")
   AAdd(Local1, "W+/N")
   AAdd(Local1, "W/N")
   AAdd(Local1, "R+/N")
   AAdd(Local1, "R+*/W")
   AAdd(Local1, "W+/N")
   AAdd(Local1, "N*/W")
   AAdd(Local1, "N*/W")
   AAdd(Local1, "R*/W")
   RETURN Local1

********************************
function ADDDOWNSEP(Arg1, Arg2)

   local Local1, Local2, Local3
   Local3:= Len(Arg1)
   Arg2:= iif(ISNil(Arg2), 1, Arg2)
   Local2:= iif(ISNil(Local2), 3, Local2)
   if (Local3 == 0)
      Local1:= iif(ISNil(Local1), 3, Local1)
   else
      Local1:= iif(ISNil(Local1), Arg1[Local3][6] + 1, Local1)
   endif
   AAdd(Arg1, {Nil, Nil, Nil, .T., "", Local1, Local2, .F., .T., ;
      Arg2})
   RETURN Nil

********************************
STATIC function HIDEDWNFOC(Arg1, Arg2)

   drawdownit(Arg1, 1, Arg2)
   RETURN Nil

********************************
function ADDDOWNITE(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8)
      RETURN ADDDOWNITEM(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8)

/*
function ADDDOWNITEM(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8)

   local Local1, Local2
   Local2:= Len(Arg1)
   Arg2:= iif(At("&", Arg2) == 0, "&" + Arg2, Arg2)
   Arg4:= iif(ISNil(Arg4), {|| nret()}, Arg4)
   Arg6:= iif(ISNil(Arg6), .T., Arg6)
   Arg8:= iif(ISNil(Arg8), 3, Arg8)
   Local1:= SubStr(Arg2, At("&", Arg2) + 1, 1)
   if (Local2 == 0)
      Arg7:= iif(ISNil(Arg7), 3, Arg7)
      Arg5:= iif(ISNil(Arg5), Len(Arg2) + 4, Arg5)
   else
      Arg7:= iif(ISNil(Arg7), Arg1[Local2][6] + 1, Arg7)
      Arg5:= iif(ISNil(Arg5), Max(Arg1[Local2][10], Len(Arg2) + 4), ;
         Arg5)
   endif
   AAdd(Arg1, {Arg2, Arg3, Arg4, Arg6, Local1, Arg7, Arg8, .F., .F., ;
      Arg5})
   RETURN Nil
*/

function ADDDOWNITEM(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9)

   local Local1, Local2
   Local2:= Len(Arg1)

   Arg2:= iif(At("&", Arg2) == 0, "&" + Arg2, Arg2)
   Arg4:= iif(ISNil(Arg4), {|| nret()}, Arg4)
   Arg6:= iif(ISNil(Arg6), .T., Arg6)

   if ISNil(Arg9)
      Arg9 = 0
   else
      if substr(W_LOGGER,Arg9,1) == "N"
         Arg6:= .f.
      endif
   endif

   Arg8:= iif(ISNil(Arg8), 3, Arg8)
   Local1:= SubStr(Arg2, At("&", Arg2) + 1, 1)
   if (Local2 == 0)
      Arg7:= iif(ISNil(Arg7), 3, Arg7)
      Arg5:= iif(ISNil(Arg5), Len(Arg2) + 4, Arg5)
   else
      Arg7:= iif(ISNil(Arg7), Arg1[Local2][6] + 1, Arg7)
      Arg5:= iif(ISNil(Arg5), Max(Arg1[Local2][10], Len(Arg2) + 4), ;
         Arg5)
   endif
   AAdd(Arg1, {Arg2, Arg3, Arg4, Arg6, Local1, Arg7, Arg8, .F., .F., Arg5, Arg9})
RETURN Nil

********************************
STATIC function DRAWDOWNIT(Arg1, Arg2, Arg3)

   local Local1, Local2, Local3, Local4, Local5, Local6
   Local5:= iif(Arg1[8], "û ", "  ")
   Local6:= iif(ISARRAY(Arg1[3]), iif(sbGuiSupport,'>',Chr(16)), " ")
   Local3:= iif(Arg1[9], Replicate("Ä", Arg1[10]), padr(Local5 + ;
      textmenu(Arg1[1]), Arg1[10] - 1) + Local6)
   Local4:= iif(Arg1[9], 0, At("&", Arg1[1]) + 1)
   if (Arg2 == 1)
      Local1:= iif(Arg1[4], Arg3[1], Arg3[2])
      Local2:= iif(Arg1[4], Arg3[6], Arg3[8])
   elseif (Arg2 == 2)
      Local1:= iif(Arg1[4], Arg3[3], Arg3[4])
      Local2:= iif(Arg1[4], Arg3[5], Arg3[7])
   endif
   if (Arg1[9])
      if !sbGuiSupport
         DevPos(Arg1[6], Arg1[7])
         vldevout(Local3, Local1)
      else
         DevPos(Arg1[6], Arg1[7]-1)
         if sbGuiSupportEX
            vldevout(' '+Local3+' ', Local1)
         else
            vldevout('Ã'+Local3+'´', Local1)
         end
      end
   else
      DevPos(Arg1[6], Arg1[7])
      vldevout(Local3, Local1)
      DevPos(Arg1[6], Arg1[7] + Local4)
      vldevout(Arg1[5], Local2)
   endif
   RETURN Nil

********************************
function CHKDOWNITEM(Arg1, Arg2, Arg3)
   RETURN CHKDOWNITE(Arg1, Arg2, Arg3)

function CHKDOWNITE(Arg1, Arg2, Arg3)

   local Local1
   Local1:= Arg1[Arg2][8]
   if (Arg3 != Nil)
      Arg1[Arg2][8]:= Arg3
   endif
   RETURN Local1


/*
********************************
function SETDOWNITEM(Arg1, Arg2, Arg3)
   RETURN SETDOWNITE(Arg1, Arg2, Arg3)

function SETDOWNITE(Arg1, Arg2, Arg3)

   local Local1
   Local1:= Arg1[Arg2][4]
   if (Arg3 != Nil)
      Arg1[Arg2][4]:= Arg3
   endif
   RETURN Local1

*/

function SETDOWNITEM(Arg1, Arg2, Arg3)
RETURN SETDOWNITE(Arg1, Arg2, Arg3)

function SETDOWNITE(Arg1, Arg2, Arg3)

   local Local1
   Local1:= Arg1[Arg2][4]
   Arg1[Arg2][4]:= !Arg1[Arg2][4]
   W_LOGGER = stuff(W_LOGGER,Arg1[Arg2][11],1,iif(substr(W_LOGGER,Arg1[Arg2][11],1)=="N","S","N"))

RETURN Local1


********************************
STATIC function DISPLAYDOWN(Arg1, Arg2)
   RETURN DISPLAYDOW(Arg1, Arg2)
   
STATIC function DISPLAYDOW(Arg1, Arg2)

   local Local1
   for Local1:= 1 to Len(Arg1[2])
      drawdownit(Arg1[2][Local1], 1, Arg2)
   next
   RETURN Nil

********************************
STATIC function SHOWDOWNMS(Arg1, Arg2)

   if (Arg1[2] != Nil .Or. Arg1[2] = "")
      dwnmsg(Arg1[2], Arg2[10])
   endif
   RETURN Nil

********************************
function GETTimeR

   RETURN STATIC17



/*
********************************
function DOWNMENU(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8)

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7, ;
      Local8, Local9, Local10, Local11, Local12, Local13, Local14, ;
      Local15, Local16
   Local1:= array(4)
   Local2:= setcursor(0)
   Local3:= Len(Arg1)
   Local4:= Arg1[1][10]
   Local8:= 1
   Local11:= {}
   Local15:= 0
   Local16:= .T.
   Arg7:= iif(ISNil(Arg7), -1, Arg7)
   Arg8:= iif(ValType(Arg8) != "A", {}, Arg8)
   Arg6:= iif(PCount() < 6, menucolors(), Arg6)
   
   if sbGuiSupportEx
      //Arg3 += 2
   endif
   
   auxpshdown(Local11, Arg1, Arg2, Arg3, Arg4, Arg5, Local8, Arg6)
   do while (Local15 == 0)
      setmovflag(.F.)
      Local12:= Local11[Local8][1]
      Local13:= Local11[Local8][2]
      Arg2:= Local12[1]
      do while (Local13[Arg2][9])
         Arg2:= iif(++Arg2 > Len(Local13), 1, Arg2)
      enddo
      do while (Arg2 != 0)
         if (Local16)
            displaydow(Local11[Local8], Arg6)
            showdwnfoc(Local13[Arg2], Arg6)
            Local16:= .F.
         endif
         Local7:= waitstate()
         do case
         case Local7[1] == 1
            do case
            case (Local10:= ascan(Local13, {|_1| ;
                  Upper(Chr(Local7[2])) == Upper(_1[5])})) != 0
               Arg2:= dwngoto(Local13, Arg2, Local10, Arg6)
               Arg2:= dwnexecute(Local11, Local13, Arg2, Local12, ;
                  Local8, Arg6)
               Local8:= Len(Local11)
               Local16:= .T.
            case Local7[2] == 5
               Arg2:= dwnup(Local13, Arg2, Arg6)
            case Local7[2] == 24
               Arg2:= dwndown(Local13, Arg2, Arg6)
            case Local7[2] == 19
               Arg2:= dwnleft(Local11, Local13, Local8, Arg6)
               Local8:= Len(Local11)
               Local15:= -1
            case Local7[2] == 4
               Arg2:= dwnrigh(Local11, Local13, Local8, Arg6)
               Local8:= Len(Local11)
               Local15:= -1
            case Local7[2] == 27
               Arg2:= dwnescape(Local11, Local13, Arg2, Arg6)
               Local8--
               Local15:= iif(Local8 == 0, -1, Local15)
            case Local7[2] == 13 .And. Local13[Arg2][4]
               Arg2:= dwnexecute(Local11, Local13, Arg2, Local12, ;
                  Local8, Arg6)
               Local8:= Len(Local11)
               Local16:= .T.
            endcase
         case Local7[1] == 2
            Local14:= chkdnmouse(Local11, Local13, Arg2, Local7, ;
               Local8, Arg8, Arg7)
            if (Local14[2] != 0)
               do while (Local8 > Local14[1])
                  auxpopdown(Local11)
                  Local8--
               enddo
               if (Local8 > 0)
                  Local11[Local8][1][1]:= Local14[2]
               else
                  Local15:= Local14[2]
               endif
               Arg2:= 0
               Local16:= .T.
            endif
         case Local7[1] == 3
            if (Local8 > 0 .And. (Local9:= chkupmouse(Local11, ;
                  Local13, Arg2, Local7, Local8)) != 0)
               Arg2:= dwngoto(Local13, Arg2, Local9, Arg6)
               Arg2:= dwnexecute(Local11, Local13, Arg2, Local12, ;
                  Local8, Arg6)
               Local8:= Len(Local11)
               Local16:= .T.
            endif
         case Local7[1] == 4
            if (Local8 > 0 .And. (Local9:= chkupmouse(Local11, ;
                  Local13, Arg2, Local7, Local8)) != 0)
               Arg2:= dwngoto(Local13, Arg2, Local9, Arg6)
            endif
         endcase
      enddo
      if (Local8 == 0)
         exit
      endif
   enddo
   setcursor(Local2)
   RETURN Local15

*/

//*******************************
function DOWNMENU(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8)

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7, ;
      Local8, Local9, Local10, Local11, Local12, Local13, Local14, ;
      Local15, Local16, LSalvaTela



   Local1:= array(4)
   Local2:= setcursor(0)
   Local3:= Len(Arg1)
   Local4:= Arg1[1][10]
   Local8:= 1
   Local11:= {}
   Local15:= 0
   Local16:= .T.
   Arg7:= iif(ISNil(Arg7), -1, Arg7)
   Arg8:= iif(ValType(Arg8) != "A", {}, Arg8)
   Arg6:= iif(PCount() < 6, menucolors(), Arg6)
   LSalvaTela := 1
   cLSalvaTela := { }


   if sbGuiSupportEx
      //Arg3 += 2
   endif


   // voltar

   //   wvw_DrawImage(,2, 0, 22, 80, "c:\RACA\logo.jpg",,.f.)

   //msw("ENTRANDO DOWNMENU")

   // aqui

   auxpshdown(Local11, Arg1, Arg2, Arg3, Arg4, Arg5, Local8, Arg6)


   do while (Local15 == 0)
      setmovflag(.F.)
      Local12:= Local11[Local8][1]
      Local13:= Local11[Local8][2]
      Arg2:= Local12[1]
      do while (Local13[Arg2][9])
         Arg2:= iif(++Arg2 > Len(Local13), 1, Arg2)
      enddo
      do while (Arg2 != 0)
         if (Local16)
            displaydow(Local11[Local8], Arg6)
            showdwnfoc(Local13[Arg2], Arg6)
            Local16:= .F.
         endif
         Local7:= waitstate()

         do case


            case Local7[1] == 1

               // aqui

               do case
                  case (Local10:= ascan(Local13, {|_1| ;
                        Upper(Chr(Local7[2])) == Upper(_1[5])})) != 0
                     Arg2:= dwngoto(Local13, Arg2, Local10, Arg6)
                     Arg2:= dwnexecute(Local11, Local13, Arg2, Local12, ;
                        Local8, Arg6)
                     Local8:= Len(Local11)
                     Local16:= .T.
                  case Local7[2] == 32 .and. lLog = .t. // espaco
                     SetDownItem(Local13, Arg2)

                  case Local7[2] == 5
                     Arg2:= dwnup(Local13, Arg2, Arg6)
                  case Local7[2] == 24
                     Arg2:= dwndown(Local13, Arg2, Arg6)

                  case Local7[2] == 4
                     Arg2:= dwnrigh(Local11, Local13, Local8, Arg6)
                     Local8:= Len(Local11)
                     Local15:= -1

                  case Local7[2] == 19
                     Arg2:= dwnleft(Local11, Local13, Local8, Arg6)
                     Local8:= Len(Local11)
                     Local15:= -1

                  case Local7[2] == 27

                     Arg2:= dwnescape(Local11, Local13, Arg2, Arg6)
                     Local8--
                     Local15:= iif(Local8 == 0, -1, Local15)

                     // aqui
                     //               msg("vamos restaurar")
                     //               vlrestscre(2, 0, maxrow()-2, maxcol(),cInicIMG4,.f.)  // salva a tela

                     //               vlrestscre(2, 0, maxrow()-2, maxcol(),cLSalvaTela[len(cLSalvaTela)],.t.)  // salva a tela
                     //               adel(cLSalvaTela,len(cLSalvaTela))

                  case Local7[2] == 13 .And.  lLog = .t. // espaco

                     Arg2:= dwnexecute(Local11, Local13, Arg2, Local12, Local8, Arg6)
                     Local8:= Len(Local11)
                     Local16:= .T.

                  case Local7[2] == 13 .And. Local13[Arg2][4]

                     //            msg("vamos desenhar")
                     //             aadd(cLSalvaTela,vlsavescre(2, 0, maxrow()-2, maxcol()))
                     Arg2:= dwnexecute(Local11, Local13, Arg2, Local12, Local8, Arg6)
                     Local8:= Len(Local11)
                     Local16:= .T.

               endcase
            case Local7[1] == 2
               Local14:= chkdnmouse(Local11, Local13, Arg2, Local7, ;
                  Local8, Arg8, Arg7)
               if (Local14[2] != 0)
                  do while (Local8 > Local14[1])
                     auxpopdown(Local11)
                     Local8--
                  enddo
                  if (Local8 > 0)
                     Local11[Local8][1][1]:= Local14[2]
                  else
                     Local15:= Local14[2]
                  endif
                  Arg2:= 0
                  Local16:= .T.
               endif
            case Local7[1] == 3
               if (Local8 > 0 .And. (Local9:= chkupmouse(Local11, ;
                     Local13, Arg2, Local7, Local8)) != 0)
                  Arg2:= dwngoto(Local13, Arg2, Local9, Arg6)
                  Arg2:= dwnexecute(Local11, Local13, Arg2, Local12, ;
                     Local8, Arg6)
                  Local8:= Len(Local11)
                  Local16:= .T.
               endif
            case Local7[1] == 4
               if (Local8 > 0 .And. (Local9:= chkupmouse(Local11, ;
                     Local13, Arg2, Local7, Local8)) != 0)
                  Arg2:= dwngoto(Local13, Arg2, Local9, Arg6)
               endif
         endcase
      enddo
      if (Local8 == 0)
         exit
      endif
   enddo


   //  msw("SAINDO DOWNMENU")

   setcursor(Local2)


   // voltar

   //   wvw_DrawImage(,2, 0, 22, 80, "C:\RACA\logo.jpg",,.f.)

RETURN Local15

********************************
STATIC function CHKDNMOUSE(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7)

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7, ;
      Local8, Local9, Local10, Local11
   Local11:= xmik2:= 0
   if (Arg4[2] == Arg7)
      for Local3:= 1 to Len(Arg6)
         Local4:= Arg6[Local3][7]
         Local5:= Arg6[Local3][7] + Arg6[Local3][8]
         if (Arg4[3] >= Local4 .And. Arg4[3] <= Local5)
            Local11:= 0
            xmik2:= Local3
            exit
         endif
      next
   else
      for Local1:= 1 to Arg5
         Local10:= Len(Arg1[Local1][2])
         Local6:= Arg1[Local1][1][3] + 1
         Local7:= Arg1[Local1][1][4] + 1
         Local8:= Arg1[Local1][1][5] - 1
         Local9:= Arg1[Local1][1][6] - 1
         if (Arg4[2] >= Local6 .And. Arg4[2] <= Local8 .And. Arg4[3] ;
               >= Local7 .And. Arg4[3] <= Local9)
            for Local2:= 1 to Local10
               if (Arg4[2] == Arg1[Local1][2][Local2][6] .And. ;
                     !Arg1[Local1][2][Local2][9])
                  Local11:= Local1
                  xmik2:= Local2
                  exit
               endif
            next
         endif
         if (Local11 != 0)
            exit
         endif
      next
   endif
   RETURN {Local11, xmik2}

********************************
STATIC function CHKUPMOUSE(Arg1, Arg2, Arg3, Arg4, Arg5)

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7
   Local7:= 0
   Local6:= Len(Arg2)
   Local2:= Arg1[Arg5][1][3] + 1
   Local3:= Arg1[Arg5][1][4] + 1
   Local4:= Arg1[Arg5][1][5] - 1
   Local5:= Arg1[Arg5][1][6] - 1
   if (Arg4[2] >= Local2 .And. Arg4[2] <= Local4 .And. Arg4[3] >= ;
         Local3 .And. Arg4[3] <= Local5)
      for Local1:= 1 to Local6
         if (Arg4[2] == Arg2[Local1][6] .And. !Arg2[Local1][9])
            Local7:= Local1
            exit
         endif
      next
   endif
   RETURN Local7

********************************
function NRET

   RETURN Nil

********************************
STATIC function AUXPSHDOWN(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, ;
   Arg8)

   local Local1, Local2, Local3, Local4, Local5, Local6, Local7
   local r22 := MaxRow()-2
   local c80 := MaxCol()
   
   Local1:= Len(Arg2)
   Local2:= Arg2[1][10]
   Arg3:= iif(ISNil(Arg3), 1, Arg3)
   for Local4:= 1 to Local1
      Local2:= Max(Arg2[Local4][10], Local2)
   next
   for Local4:= 1 to Local1
      Arg2[Local4][10]:= Local2
   next
   Local5:= Arg4 + Local1 + 1
   Local6:= Arg5 + Arg2[1][10] + 1
   if (Arg7 > 1 .And. (Arg5 > 45 .Or. Arg5 + Arg6 > 65))
      Arg5:= Arg5 + Arg6
      Local6:= Local6 + Arg6
      Arg5:= Arg5 - iif(Local6 + 3 > c80, Arg6 + Arg2[1][10] + 2, 0)
      Local6:= Local6 - iif(Local6 + 3 > c80, Arg6 + Arg2[1][10] + 2, ;
         0)
      Arg4:= Arg4 - iif(Local5 + 1 > r22, Local5 + 1 - r22, 0)
      Local5:= Local5 - iif(Local5 + 1 > r22, Local5 + 1 - r22, 0)
      if (Arg5 < 0)
         Arg5:= MaxCol()-2 - (Local6 - Arg5)
         Local6:= Arg5 + Arg2[1][10] + 1
      endif
   elseif (Arg7 > 1)
      Arg5:= Arg5 + Arg6
      Local6:= Local6 + Arg6
      Arg5:= Arg5 - iif(Local6 + 3 > c80, Local6 + 3 - c80, 0)
      Local6:= Local6 - iif(Local6 + 3 > c80, Local6 + 3 - c80, 0)
      Arg4:= Arg4 - iif(Local5 + 1 > r22, Local5 + 1 - r22, 0)
      Local5:= Local5 - iif(Local5 + 1 > r22, Local5 + 1 - r22, 0)
   else
      Arg5:= Arg5 - iif(Local6 + 3 > c80, Local6 + 3 - c80, 0)
      Local6:= Local6 - iif(Local6 + 3 > c80, Local6 + 3 - c80, 0)
      Arg4:= Arg4 - iif(Local5 + 1 > r22, Local5 + 1 - r22, 0)
      Local5:= Local5 - iif(Local5 + 1 > r22, Local5 + 1 - r22, 0)
   endif
   
   if sbGuiSupportEx
      Local7:= nbox(Arg4, Arg5, Local5, Local6, Arg8[9],.T.)
   else
      Local7:= nbox(Arg4, Arg5, Local5, Local6, Arg8[9])
   end
   
   for Local4:= 1 to Local1
      Arg2[Local4][6]:= Arg4 + Local4
      Arg2[Local4][7]:= Arg5 + 1
   next
   AAdd(Arg1, {{Arg3, Local7, Arg4, Arg5, Local5, Local6}, Arg2})
   RETURN Nil

********************************
STATIC function AUXPOPDOWN(Arg1)

   local Local1
   Local1:= Len(Arg1)
   rstenv(Arg1[Local1][1][2])
   asize(Arg1, Local1 - 1)
   RETURN Nil

********************************
STATIC function SHOWDWNFOC(Arg1, Arg2)

   drawdownit(Arg1, 2, Arg2)
   showdownms(Arg1, Arg2)
   RETURN Nil

********************************
STATIC function DWNUP(Arg1, Arg2, Arg3)

   hidedwnfoc(Arg1[Arg2], Arg3)
   Arg2:= iif(--Arg2 == 0, Len(Arg1), Arg2)
   do while (Arg1[Arg2][9])
      Arg2:= iif(--Arg2 == 0, Len(Arg1), Arg2)
   enddo
   showdwnfoc(Arg1[Arg2], Arg3)
   RETURN Arg2

********************************
STATIC function DWNDOWN(Arg1, Arg2, Arg3)

   hidedwnfoc(Arg1[Arg2], Arg3)
   Arg2:= iif(++Arg2 > Len(Arg1), 1, Arg2)
   do while (Arg1[Arg2][9])
      Arg2:= iif(++Arg2 > Len(Arg1), 1, Arg2)
   enddo
   showdwnfoc(Arg1[Arg2], Arg3)
   RETURN Arg2

********************************
STATIC function DWNLEFT(Arg1, Arg2, Arg3)

   do while (Arg3 > 0)
      auxpopdown(Arg1)
      Arg3--
   enddo
   setmovflag(.T.)
   setmovleft(.T.)
   setbarmsg(.F.)
   RETURN 0

********************************
STATIC function DWNRIGH(Arg1, Arg2, Arg3)

   do while (Arg3 > 0)
      auxpopdown(Arg1)
      Arg3--
   enddo
   setmovflag(.T.)
   setmovrigh(.T.)
   setbarmsg(.F.)
   RETURN 0

********************************
STATIC function DWNGOTO(Arg1, Arg2, Arg3, Arg4)

   hidedwnfoc(Arg1[Arg2], Arg4)
   Arg2:= iif(Arg1[Arg3][9], Arg2, Arg3)
   showdwnfoc(Arg1[Arg2], Arg4)
   RETURN Arg2



/*
********************************
STATIC function DWNEXECUTE(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)

   if (ISARRAY(Arg2[Arg3][3]) .And. Arg2[Arg3][4])
      Arg4[1]:= Arg3
      Arg5++
      auxpshdown(Arg1, Arg2[Arg3][3], 1, Arg2[Arg3][6] - 1, ;
         Arg2[Arg3][7], Arg2[Arg3][10], Arg5, Arg6)
      Arg3:= 0
   elseif (ISBLOCK(Arg2[Arg3][3]) .And. Arg2[Arg3][4])
      eval(Arg2[Arg3][3])
   endif
   RETURN Arg3


*/

STATIC function DWNEXECUTE(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)
   local lSavepri

   SEATUALIZA()
//   SELOGADO()

   if (ISARRAY(Arg2[Arg3][3]) .And. lLog = .t.)
      Arg4[1]:= Arg3
      Arg5++
      auxpshdown(Arg1, Arg2[Arg3][3], 1, Arg2[Arg3][6] - 1, ;
         Arg2[Arg3][7], Arg2[Arg3][10], Arg5, Arg6)
      Arg3:= 0

   elseif (ISARRAY(Arg2[Arg3][3]) .And. Arg2[Arg3][4])
      Arg4[1]:= Arg3
      Arg5++
      auxpshdown(Arg1, Arg2[Arg3][3], 1, Arg2[Arg3][6] - 1, ;
         Arg2[Arg3][7], Arg2[Arg3][10], Arg5, Arg6)
      Arg3:= 0

      // POSICAO SENHA RESTRICAO

   elseif (ISBLOCK(Arg2[Arg3][3]) .And. Arg2[Arg3][4]) .or. (Arg2[Arg3][11] = 430 .and.  lLog = .t.)

      if Arg2[Arg3][11] = 430 .and.  lLog = .t.  // entra no modulo de alteracao// restricao vamos liberar para concluir
      else
         if lLog = .t.  // entra no modulo de alteracao
            alertnew("Voce esta no modulo de permissoes;Conclua a alteracao das senhas",{"Ok"},,,,,,,"VERDE")
            return 0
         endif
      endif

      cDWNEXECUTE := vlsavescre(2, 0, maxrow()-2, maxcol())  // salva a tela

      eval(Arg2[Arg3][3])

      vlrestscre(2, 0, maxrow()-2, maxcol(),cDWNEXECUTE,.t.)  // salva a tela

      cF_ATV = "MENU          "
      cF_MOD = "PRINCIPAL     "
      cF_PRG = "SIS V.4.0     "
      M_FAN = "SISTEMA INGEGRADO"
      rodape()
   endif
RETURN Arg3

********************************
STATIC function DWNESCAPE(Arg1, Arg2, Arg3)

   auxpopdown(Arg1)
   setbarmsg(.T.)
   RETURN 0

********************************
function NInkey(Arg1)

   local Local1, Local2, Local3
   do while (.T.)
      Local1:= .F.
      if (Arg1 = Nil)
         Local2:= InKey(0.10,159)
      else
         Local2:= InKey(Arg1,159)
      endif

      if Local2 >= K_MINMOUSE .And. ;
         Local2 <= K_MAXMOUSE
         
         if Local2 == K_LBUTTONDOWN .or. ;
            Local2 == K_LBUTTONUP .or. ;
            Local2 == K_LDBLCLK

            if Local2 == K_LDBLCLK
               arrMouseInfLeft[1] := 2
            else
               arrMouseInfLeft[1] := 1
            end
            arrMouseInfLeft[2] := mRow()
            arrMouseInfLeft[3] := mCol()
         end

         if Local2 == K_RBUTTONDOWN .or. ;
            Local2 == K_RBUTTONUP .or. ;
            Local2 == K_RDBLCLK

            if Local2 == K_RDBLCLK
               arrMouseInfRight[1] := 2
            else
               arrMouseInfRight[1] := 1
            end
            arrMouseInfRight[2] := mRow()
            arrMouseInfRight[3] := mCol()
         end
         Local2 := 0
         Setswmouse(.T.)
      end
      
      if (Local2 != 0 .And. (Local3:= SetKey(Local2)) != Nil)
         eval(Local3, procname(2), procline(2), "")
         Local1:= .T.
         resettimer()
      endif
      if (!Local1)
         exit
      endif
   enddo
   RETURN Local2

********************************
function DWNMSG(Arg1, Arg2)
   local r24 := MaxRow()
   local c80 := MaxCol()+1
   
   Arg2:= iif(ISNil(Arg2), "R*/W", Arg2)
   DevPos(r24, 0)
   vldevout(padc(Arg1, c80), Arg2)
   RETURN .T.

********************************
function CLOCK

   local Local1, Local2, Local3, Local4
   Local3:= vlscrsaver()
   Local4:= array(3)
   Local1:= win(10, 29, 13, 50, "Rel¢gio - " + DToC(Date()), ;
      "W+*/B", "B+*/W")
   setcursor(0)
   resettimer()
   vlmousedn(0, Local4)
   do while (.T.)
      DevPos(12, 36)
      vldevout(Time(), "N*/W")
      if ((Local2:= InKey(1)) != 0)
         exit
      endif
      vlmousedn(0, Local4)
      if (Local4[1] > 0)
         exit
      endif
      if (Seconds() - gettimer() > Local3[1])
         eval(Local3[2])
         resettimer()
      endif
   enddo
   rstenv(Local1)
   RETURN Nil

********************************
function CHKPRN

   local Local1
   Local1:= .T.
   do while (!isprinter())
      If (msgbox2("Impressora n„o preparada. Continuar ?") == 2)
         Local1:= .F.
         exit
      endif
   enddo
   RETURN Local1

********************************
function SavEnv(Arg1, Arg2, Arg3, Arg4,lNoCaption)
   local Local1
   local win
   local a,b,c

   Local1:= {}
   AAdd(Local1, Arg1)
   AAdd(Local1, Arg2)
   AAdd(Local1, Arg3)
   AAdd(Local1, Arg4)
   AAdd(Local1, vlsavescre(Arg1, Arg2, Arg3, Arg4))
   AAdd(Local1, SetColor())
   AAdd(Local1, setcursor())
   AAdd(Local1, Row())
   AAdd(Local1, Col())

   if sbGuiSupportEx
      a := &("{|| WVW_NSETCURWINDOW() }")
      b := &("{|| WVW_NNUMWINDOWS() }")
      c := &("{|p1,p2,p3,p4,p5,p6,p7| WVW_nOpenWindow(p1,p2,p3,p4,p5,p6,p7) }")
      
      AADD(Local1, a:Eval() ) // 10 item
      AADD(Local1, b:EVal() )   // 11 item

      if lNoCaption <> nil .And. lNoCaption
         win := c:EVal('',Arg1, Arg2, Arg3, Arg4,KS_NOCAPTION(),0)
      else
         win := c:EVal('',Arg1, Arg2, Arg3, Arg4)
      end
      AADD(Local1, win )                 // 12 item
   else
      AADD(Local1, 00 )   // 10 item
      AADD(Local1, 00 )   // 11 item
      AADD(Local1, nil )  // 12 item
   end
   
   RETURN Local1

********************************
function RstEnv(Arg1)
   LOCAL i := 00
   LOCAL b,c,d

   if sbGuiSupportEx

      b := &( "{|| WVW_NNUMWINDOWS() }" )
      c := &( "{|| WVW_lCloseWindow() }" )
      d := &( "{|_1| WVW_NSETCURWINDOW(_1) }" )
      
      While ( b:Eval() <> Arg1[11] )
            i++
            c:Eval()

            if i > 5
               exit
            end
      End

      d:Eval( Arg1[10] )
   else
      vlrestscre(Arg1[1], Arg1[2], Arg1[3], Arg1[4], Arg1[5])
      set color to (Arg1[6])
      setcursor(Arg1[7])
      SetPos(Arg1[8], Arg1[9])
   end
   RETURN Nil

********************************
function VLExit(Arg1, Arg2, Arg3, Arg4)

   local Local1
   //Local1:= savenv(33, 0, 33, 79)
   Arg4:= iif(ISNil(Arg4), .T., Arg4)

   if (!Arg4)
      if sbGuiSupport
         vlmouseoff()
         set color to
         vlscroll()
         SetPos(0, 0)
         close databases
         setcursor(1)
      else
         vlmouseoff()
         set color to n/n
         setcursor(0)
         vlscroll()
*         run vlfont.exe off

         set color to
         vlscroll()
         SetPos(0, 0)
         vlsetmode(25, MaxCol()+1)
         close databases
         vlsetblink(.T.)
         setcursor(1)
      end
      quit
   elseif (msgbox2("Confirma o encerramento ?", "Sa¡da", Nil, Nil, ;
         Nil, Nil, 2) == 1)
      if sbGuiSupport
         setcursor(0)
         vlmouseoff()
         set color to
         vlscroll()
         SetPos(0, 0)
         close databases
         setcursor(1)
      else
         setcursor(0)
         vlmouseoff()
         set color to n/n
         vlscroll()
*         run vlfont.exe off

         set color to
         vlscroll()
         SetPos(0, 0)
         vlsetmode(25, MaxCol()+1)
         close databases
         vlsetblink(.T.)
         setcursor(1)
      end
      quit
   endif
   //rstenv(Local1)
   RETURN Nil

********************************
function QExit(Arg1, Arg2, Arg3, Arg4)

   vlexit(Arg1, Arg2, Arg3, Arg4)
   RETURN Nil

********************************
function VLSCROLL(Arg1, Arg2, Arg3, Arg4, Arg5)

   local Local1
   Local1:= vlsetmouse(.F.)
   Scroll(Arg1, Arg2, Arg3, Arg4, Arg5)
   vlsetmouse(Local1)
   RETURN Nil

********************************
function RESETTimeR

   RETURN STATIC17:= Seconds()

********************************
function VLSETMODE(Arg1, Arg2)

   local Local1, Local2
   Local1:= vlsetmouse(.F.)
   Local2:= setmode(Arg1, Arg2)
   vlmouseini()
   vlsetmouse(Local1)
   RETURN Local2

********************************
function VLSAVESCREEN(Arg1, Arg2, Arg3, Arg4)
   RETURN VLSAVESCRE(Arg1, Arg2, Arg3, Arg4)

function VLSAVESCRE(Arg1, Arg2, Arg3, Arg4)

   local Local1, Local2
   Local2:= vlsetmouse(.F.)
   Local1:= SaveScreen(Arg1, Arg2, Arg3, Arg4)
   vlsetmouse(Local2)
   RETURN Local1

********************************
function VLRESTSCREEN(Arg1, Arg2, Arg3, Arg4, Arg5)
   RETURN VLRESTSCRE(Arg1, Arg2, Arg3, Arg4, Arg5)

function VLRESTSCRE(Arg1, Arg2, Arg3, Arg4, Arg5)

   local Local1
   Local1:= vlsetmouse(.F.)
   RestScreen(Arg1, Arg2, Arg3, Arg4, Arg5)
   vlsetmouse(Local1)
   RETURN Nil

********************************
function VLQOUT(Arg1)

   local Local1, Local2
   Local1:= vlsetmouse(.F.)
   Local2:= Len(Arg1)
   do case
   case Local2 == 1
      ? Arg1[1]
   case Local2 == 2
      ? Arg1[1], Arg1[2]
   case Local2 == 3
      ? Arg1[1], Arg1[2], Arg1[3]
   case Local2 == 4
      ? Arg1[1], Arg1[2], Arg1[3], Arg1[4]
   case Local2 == 5
      ? Arg1[1], Arg1[2], Arg1[3], Arg1[4], Arg1[5]
   endcase
   vlsetmouse(Local1)
   RETURN Nil

********************************
function VLQQOUT(Arg1)

   local Local1
   Local1:= vlsetmouse(.F.)
   aeval(Arg1, {|_1| QQOut(_1)})
   vlsetmouse(Local1)
   RETURN Nil

********************************
function VLDEVOUT(Arg1, Arg2)

   local Local1
   Local1:= vlsetmouse(.F.)
   DevOut(Arg1, Arg2)
   vlmouseon(Local1)
   RETURN Nil

********************************
function VLDEVOUTPICT(Arg1, Arg2, Arg3)
   RETURN VLDEVOUTPI(Arg1, Arg2, Arg3)
   
function VLDEVOUTPI(Arg1, Arg2, Arg3)

   local Local1
   Local1:= vlsetmouse(.F.)
   DevOutPict(Arg1, Arg2, Arg3)
   vlmouseon(Local1)
   RETURN Nil

********************************
function VLDISPBOX(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)

   local Local1
   Local1:= vlsetmouse(.F.)
   @ Arg1, Arg2, Arg3, Arg4 box Arg5 color Arg6
   vlmouseon(Local1)
   RETURN Nil

********************************
function DESKTOP(Arg1, Arg2,lCallSetMode,lCallSetFont)

   local Local1
   local c80 := MaxCol()+1
   local r24 := MaxRow()
   
   Arg1:= iif(ISNil(Arg1), ;
      "Analyze Tecnologia em Sistemas - Visual Lib 2.0", Arg1)
   Arg2:= iif(ISNil(Arg2), "W+/BG", Arg2)
   //vl850(lCallSetMode,lCallSetFont)
   if (vlmouseini(@Local1))
      vlmouseon()
   endif
   //vlsetblink(.F.)
   set color to W+/W
   vlscroll()
   SetPos(0, 0)
   DevPos(0, 0)
   vldevout(padc(Arg1, c80), Arg2)
   DevPos(r24, 0)
   vldevout(padc(" ", c80), Arg2)
   DevPos(1, 0)
   vldevout(padc(" ", c80), "N*/W")
   DevPos(r24-1, 0)
   vldevout(padc(" ", c80), "N*/W")
   RETURN Nil

********************************
function DRAWFN(Arg1, Arg2, Arg3, Arg4)

   local Local1
   local r24 := MaxRow()
   
   Local1:= {1, 9, 17, 25, 33, 41, 49, 57, 65, 73}
   Arg3:= iif(ISNil(Arg3), "W+/BG", Arg3)
   Arg4:= iif(ISNil(Arg4), "N/BG", Arg4)
   DevPos(r24, Local1[Arg1])
   vldevout(Left(Arg2, 7), Arg4)
   DevPos(r24, Local1[Arg1] - 1)
   
   if sbGuiSupport
      if Arg1 == 10
         Arg1 := 48
      else
         Arg1 += 48
      end
      vldevout(Chr(Arg1), Arg3)
   else
      vldevout(Chr(Arg1), Arg3)
   end
   RETURN Nil

********************************
function NBOX(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7)
   local Local1

   if sbGuiSupportEX
      Local1:= savenv(Arg1, Arg2, Arg3, Arg4, Arg6 )
      dispbox(Arg1, Arg2, Arg3, Arg4, "           ", Arg5)
   else
      Local1:= savenv(Arg1, Arg2, Arg3 + 1, Arg4 + 2)
      Arg5:= iif(ISNil(Arg5), "N*/W", Arg5)
      Arg6:= iif(ISNil(Arg6), .T., Arg6)
      Arg7:= iif(ISNil(Arg7), .F., Arg7)

      if sbGuiSupport
         //vldispbox(Arg1, Arg2, Arg3, Arg4, "ÚÄ¿³ÙÄÀ³ " /*"ÉÍ»º¼ÍÈº "*/, Arg5)
      else
         //vldispbox(Arg1, Arg2, Arg3, Arg4, "ÉÐËÜÊÌÈº ", Arg5)

         //vldispbox(Arg1, Arg2, Arg3, Arg4, "ÚÄ¿³ÙÄÀ³ ", Arg5)

         B0 := "ÚÄ¿³ÙÄÀ³ "

         B1 := 'ÕÝ©º½ÐÓÜ '
         B2 := 'ÕÑ©º½ÏÓÜ '
         B3 := '×Ñ¸¹¾ÏÔÛ '
         B4 := 'ÛÏ¹¹¹ØÛ '
         B5 := 'ÚÄ¿°ÙÄÀ° '

         B6 := 'ÉÐËÜÊÌÈº '

 *        B6 := '         '
*         B6 := "ÚÄ¿³ÙÄÀ³ "

         //220 Ü
         //186 º
         //208 Ð  Ï ÐÑÒ

*          wvw_DrawBoxRecessed(, Arg1, Arg2, Arg3, Arg4)

         //vldispbox(Arg1, Arg2, Arg3, Arg4, "ÉÐËÜÊÌÈº ", Arg5)
         If Arg7
            vldispbox(Arg1, Arg2, Arg3, Arg4, B0, Arg5)
         Else
            vldispbox(Arg1, Arg2, Arg3, Arg4, B6, Arg5)
         Endif
      end

      if (Arg6)
         sombra(Arg1, Arg2, Arg3, Arg4)
      endif
   end
   RETURN Local1

********************************
function WIN(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8,lNoCaption)
   local Local1
   local a

   Arg5:= iif(ISNil(Arg5), "", Arg5)
   Arg6:= iif(ISNil(Arg6), "W+/B", Arg6)
   Arg7:= iif(ISNil(Arg7), "B*/W", Arg7)
   Arg8:= iif(ISNil(Arg8), .T., Arg8)

   if sbGuiSupportEX
      Local1:= nbox(Arg1, Arg2, Arg3, Arg4, Arg7, /*Arg8*/lNoCaption)
      a := &( "{|_1,_2| WVW_SETTITLE(_1,_2) }")
      a:Eval(,hb_oemtoansi(Arg5))
   else
      Local1:= nbox(Arg1, Arg2, Arg3, Arg4, Arg7, Arg8)
      DevPos(Arg1, Arg2)
      vldevout(padc(Arg5, Arg4 - Arg2 + 1), Arg6)
   end
   RETURN Local1

********************************
function SOMBRA(Arg1, Arg2, Arg3, Arg4)

   local Local1, Local2, Local3, Local4
   Local3:= vlsavescre(Arg1 + 1, Arg4 + 1, Arg3 + 1, Arg4 + 2)
   Local4:= vlsavescre(Arg3 + 1, Arg2 + 2, Arg3 + 1, Arg4 + 2)
   for Local1:= 2 to Len(Local3) step 2
      Local2:= shadow(Asc(SubStr(Local3, Local1, 1)))
      Local3:= stuff(Local3, Local1, 1, Local2)
   next
   for Local1:= 2 to Len(Local4) step 2
      Local2:= shadow(Asc(SubStr(Local4, Local1, 1)))
      Local4:= stuff(Local4, Local1, 1, Local2)
   next
   vlrestscre(Arg1 + 1, Arg4 + 1, Arg3 + 1, Arg4 + 2, Local3)
   vlrestscre(Arg3 + 1, Arg2 + 2, Arg3 + 1, Arg4 + 2, Local4)
   RETURN Nil

********************************
STATIC function SHADOW(Arg1)

   local Local1, Local2, Local3
   Local1:= Arg1 % 16
   Local2:= (Arg1 - Local1) / 16
   Local3:= {0, 0, 8, 8, 0, 8, 0, 8, 0, 1, 2, 3, 4, 5, 6, 7}
   Local1:= Local3[Local1 + 1]
   Local2:= Local3[Local2 + 1]
   RETURN Chr(16 * Local2 + Local1)

********************************
function MSGBOX3D1(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7)

   local Local1:= i:= 0, Local2:= obut:= {}
   Arg4:= iif(ISNil(Arg4), "&OK", Arg4)
   Arg1:= iif(ISNil(Arg1), "", Arg1)
   Arg2:= iif(ISNil(Arg2), "Aten‡Æo!", Arg2)
   Local1:= iif(ISARRAY(Arg1), Len(Arg1), 1)

   Arg3:= iif(ISNil(Arg3), Int(12 - (Local1 + 8) / 2), Arg3)

   Arg5:= iif(ISNil(Arg5), "W+/N", Arg5)
   Arg6:= iif(ISNil(Arg6), "N/W", Arg6)
   Arg7:= iif(ISNil(Arg7), "N/W", Arg7)
   obut:= newbutton()
   nColIni:=(MaxCol()-18) / 2 + 1
   addbutton(obut, Arg3 + 5 + Local1, nColIni, 18, Arg4, Nil, .T.)

   Local2:= win(Arg3, 10, Arg3 + 8 + Local1, MaxCol()-10, Arg2, Arg5, Arg6)

   DESKBOX(Arg3 + 2, 11, Arg3 + 7 + Local1, MaxCol()-11, , "W+/W", "N+/W")
   
   if (ISARRAY(Arg1))
      for i:= 1 to Local1
         DevPos(Arg3 + 2 + i, 13)
         vldevout(padc(Arg1[i], MaxCol()-25), Arg7)
      next
   else
      DevPos(Arg3 + 3, 13)
      vldevout(padc(Arg1, MaxCol()-25), Arg7)
   endif
   setcursor(0)
   procbutton(obut, 1, 1)
   rstenv(Local2)
   RETURN Nil

********************************
function DESKBOX(Arg1, Arg2, Arg3, Arg4, Arg5, COR1, COR2)

   local Local1:= "N+/W", Local2:= "W+/W"
   
   Arg5:= iif(ISNil(Arg5), 1, Arg5)
   if (Arg5 == 2)
      Local1:= "W+/W"
      Local2:= "N+/W"
   endif
   
   if cor1 <> nil;Local1 := cor1; end
   if cor2 <> nil;Local2 := cor2; end
   
   if sbGuiSupport
      if sbGuiSupportEx
         dispbox(Arg1, Arg2, Arg3, Arg4, "           ", Local1)
      /*
         vldispbox(Arg1, Arg2, Arg3, Arg4, "ÚÄ¿³ÙÄÀ³ ", Local1)
         vldispbox(Arg1, Arg2, Arg3, Arg4, "ÚÄ¿³ÙÄÀ³ ", Local2)

         DevPos(Arg1, Arg2)
         vldevout(Replicate("Ä", Arg4 - Arg2 + 1), Local1)
         DevPos(Arg3, Arg2)
         vldevout(Replicate("Ä", Arg4 - Arg2 + 1), Local2)

         DevPos(Arg1, Arg2)
         vldevout("Ú", Local1)
         DevPos(Arg1, Arg4)
         vldevout("¿", Local2)

         DevPos(Arg3, Arg4)
         vldevout("Ù", Local2)
         DevPos(Arg3, Arg2)
         vldevout("À", Local1)
         
         @ arg1, arg2 say ''
         ?? Arg1, Arg2, Arg3, Arg4
         /**/
      else
         vldispbox(Arg1, Arg2, Arg3, Arg2, "ÚÄ¿³ÙÄÀ³ ", Local1)
         vldispbox(Arg1, Arg4, Arg3, Arg4, "ÚÄ¿³ÙÄÀ³ ", Local2)
         DevPos(Arg1, Arg2)
         vldevout(Replicate("Ä", Arg4 - Arg2 + 1), Local1)
         DevPos(Arg3, Arg2)
         vldevout(Replicate("Ä", Arg4 - Arg2 + 1), Local2)

         DevPos(Arg1, Arg2)
         vldevout("Ú", Local1)
         DevPos(Arg1, Arg4)
         vldevout("¿", Local2)

         DevPos(Arg3, Arg4)
         vldevout("Ù", Local2)
         DevPos(Arg3, Arg2)
         vldevout("À", Local1)
      end
   else
      vldispbox(Arg1, Arg2, Arg3, Arg2, "ººººººººº", Local1)
      vldispbox(Arg1, Arg4, Arg3, Arg4, "ÜÜÜÜÜÜÜÜÜ", Local2)
      DevPos(Arg1, Arg2)
      vldevout(Replicate("Ì", Arg4 - Arg2 + 1), Local1)
      DevPos(Arg3, Arg2)
      vldevout(Replicate("Ð", Arg4 - Arg2 + 1), Local2)
   end
   RETURN Nil

********************************
function MSGBOX3D2(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, ;
   Arg9, Arg10)

   local Local1:= i:= 0, Local2:= obut:= {}
   Arg4:= iif(ISNil(Arg4), "&Sim", Arg4)
   Arg5:= iif(ISNil(Arg5), "&NÆo", Arg5)
   Arg6:= iif(ISNil(Arg6), 1, Arg6)
   Arg7:= iif(ISNil(Arg7), 2, Arg7)
   Arg1:= iif(ISNil(Arg1), "", Arg1)
   Arg2:= iif(ISNil(Arg2), "Aten‡Æo!", Arg2)
   Local1:= iif(ISARRAY(Arg1), Len(Arg1), 1)
   Arg3:= iif(ISNil(Arg3), Int(12 - (Local1 + 8) / 2), Arg3)
   Arg8:= iif(ISNil(Arg8), "W+/N", Arg8)
   Arg9:= iif(ISNil(Arg9), "N/W", Arg9)
   Arg10:= iif(ISNil(Arg10), "N/W", Arg10)
   obut:= newbutton()
   nColIni:=(MaxCol()-36) / 2
   addbutton(obut, Arg3 + 5 + Local1, nColIni, 18, Arg4, Nil, iif(Arg7 == ;
      1, .T., .F.))
   addbutton(obut, Arg3 + 5 + Local1, nColIni+20, 18, Arg5, Nil, iif(Arg7 == ;
      2, .T., .F.))
   Local2:= win(Arg3, 10, Arg3 + 8 + Local1, MaxCol()-10, Arg2, Arg8, Arg9)

   DESKBOX(Arg3 + 2, 11, Arg3 + 7 + Local1, MaxCol()-11, , "W+/W", "N+/W")

   if (ISARRAY(Arg1))
      for i:= 1 to Local1
         DevPos(Arg3 + 2 + i, 13)
         vldevout(padc(Arg1[i], MaxCol()-25), Arg10)
      next
   else
      DevPos(Arg3 + 3, 13)
      vldevout(padc(Arg1, MaxCol()-25), Arg10)
   endif
   setcursor(0)
   i:= procbutton(obut, 1, iif(Arg6 < 3, Arg6, 2))
   rstenv(Local2)
   RETURN i

********************************
STATIC function CLEARGETSYS
   RETURN CLEARGETSYS()
   
STATIC function CLEARGETSY

   local Local1[9]
   Local1[1]:= STATIC3
   Local1[2]:= STATIC4
   Local1[3]:= STATIC5
   Local1[4]:= STATIC6
   Local1[5]:= STATIC7
   Local1[6]:= getactive(Nil)
   Local1[7]:= readvar("")
   Local1[8]:= STATIC9
   Local1[9]:= STATIC10
   STATIC3:= .F.
   STATIC4:= .F.
   STATIC5:= .F.
   STATIC6:= 0
   STATIC7:= 0
   STATIC9:= ""
   STATIC10:= 0
   STATIC2:= .F.
   RETURN Local1

********************************
function MSGBOX3D3(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, ;
   Arg9, Arg10, Arg11)

   local Local1, Local2, Local3, Local4
   Arg4:= iif(ISNil(Arg4), "&Sim", Arg4)
   Arg5:= iif(ISNil(Arg5), "&NÆo", Arg5)
   Arg6:= iif(ISNil(Arg6), "&Cancelar", Arg6)
   Arg7:= iif(ISNil(Arg7), 1, Arg7)
   Arg8:= iif(ISNil(Arg8), 3, Arg8)
   Arg1:= iif(ISNil(Arg1), "", Arg1)
   Arg2:= iif(ISNil(Arg2), "Aten‡Æo!", Arg2)
   Local1:= iif(ISARRAY(Arg1), Len(Arg1), 1)
   Arg3:= iif(ISNil(Arg3), Int(12 - (Local1 + 8) / 2), Arg3)
   Arg9:= iif(ISNil(Arg9), "W+/N", Arg9)
   Arg10:= iif(ISNil(Arg10), "N/W", Arg10)
   Arg11:= iif(ISNil(Arg11), "N/W", Arg11)
   Local3:= newbutton()

   nColIni:=(MaxCol() - 54) / 2
   // 13
   // 31
   // 49
   addbutton(Local3, Arg3 + 5 + Local1, nColIni,    18, Arg4, Nil, iif(Arg8 ;
      == 1, .T., .F.))
   addbutton(Local3, Arg3 + 5 + Local1, nColIni+18, 18, Arg5, Nil, iif(Arg8 ;
      == 2, .T., .F.))
   addbutton(Local3, Arg3 + 5 + Local1, nColIni+36, 18, Arg6, Nil, iif(Arg8 ;
      == 3, .T., .F.))
   Local2:= win(Arg3, 10, Arg3 + 8 + Local1, MaxCol()-10, Arg2, Arg9, Arg10)

   DESKBOX(Arg3 + 2, 11, Arg3 + 7 + Local1, MaxCol()-11, , "W+/W", "N+/W")
   if (ISARRAY(Arg1))
      for Local4:= 1 to Local1
         DevPos(Arg3 + 2 + Local4, 13)
         vldevout(padc(Arg1[Local4], MaxCol()-25), Arg11)
      next
   else
      DevPos(Arg3 + 3, 13)
      vldevout(padc(Arg1, MaxCol()-25), Arg11)
   endif
   setcursor(0)
   Local4:= procbutton(Local3, 1, iif(Arg7 < 4, Arg7, 3))
   rstenv(Local2)
   RETURN Local4

********************************
function CLRTED(Arg1, Arg2)

   local Local1
   local r22 := maxrow()-2
   local c79 := maxcol()//-1

   RETURN Nil

   Local1:= SetColor("N/W")
   Arg1:= iif(ISNil(Arg1), 2, Arg1)
   Arg2:= iif(ISNil(Arg2), r22, Arg2)
   vlscroll(Arg1, 0, Arg2, c79)
   set color to (Local1)
   RETURN Nil

********************************
function MSGBOX1(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7)

   local Local1, Local2, Local3, Local4,Savetela

   lDesligaRedraw := .t.

   Arg4:= iif(ISNil(Arg4), "&OK", Arg4)
   Arg1:= iif(ISNil(Arg1), "", Arg1)
   Arg2:= iif(ISNil(Arg2), "Aten‡Æo!", Arg2)
   Local1:= iif(ISARRAY(Arg1), Len(Arg1), 1)
   Arg3:= iif(ISNil(Arg3), Int(12 - (Local1 + 5) / 2), Arg3)
   Arg5:= iif(ISNil(Arg5), "W+/R", Arg5)
   Arg6:= iif(ISNil(Arg6), "R/W*", Arg6)
   Arg7:= iif(ISNil(Arg7), "N*/W", Arg7)

   ciAdicional = 0
   TamStr = 0
   TamOpc = 0
   TamOpc += len(Arg4)+4
   if (ISARRAY(Arg1)) // mensagem
      for Local4:= 1 to len(Arg1)
         TamStr = iif(len(Arg1[Local4]) > TamStr,len(Arg1[Local4]),TamStr)
      next
   else
      TamStr = len(Arg1)
   endif

   if TamOpc < TamStr
      ciAdicional = (TamStr-TamOpc)/2
   endif

   TamStr = iif(TamStr>TamOpc,TamStr,TamOpc)

   Ci:=((maxcol()-TamStr)/2)
   Cf:=Ci+TamStr

   Local3:= newbutton()

   addbutton(Local3, Arg3 + 3 + Local1,Ci+ciAdicional,len(Arg4)+6, Arg4, Nil,.T.)

   Savetela := savescreen(Arg3, Ci-3, Arg3 + 7 + Local1, cf+5)

   Local2:= win(Arg3, Ci-3, Arg3 + 5 + Local1, cf+3       , Arg2, Arg5, Arg6)

   if (ISARRAY(Arg1))
      for Local4:= 1 to Local1
         DevPos(Arg3 + 1 + Local4, ci)
          vldevout(padc(Arg1[Local4],TamStr), Arg7)
      next
   else
     DevPos(Arg3 + 2, ci)
     vldevout(padc(Arg1,TamStr)      , Arg7)
   endif
   setcursor(0)
   procbutton(Local3, 2, 1)
   rstenv(Local2)

   lDesligaRedraw := .f.

   RETURN Nil

********************************
function LINBUTTON3(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, ;
   Arg9, Arg10, Arg11, Arg12)

   local Local1
   Local1:= newbutton()
   Arg1:= iif(ISNil(Arg1), .T., Arg1)
   Arg2:= iif(ISNil(Arg2), 1, Arg2)
   Arg3:= iif(ISNil(Arg3), 21, Arg3)
   Arg4:= iif(ISNil(Arg4), 1, Arg4)
   Arg5:= iif(ISNil(Arg5), 3, Arg5)
   Arg6:= iif(ISNil(Arg6), "&OK", Arg6)
   Arg8:= iif(ISNil(Arg8), "&Alterar", Arg8)
   Arg10:= iif(ISNil(Arg10), "&Cancelar", Arg10)
   nColIni:=(MaxCol()-54) / 2 - 2
   //11
   //31
   //51
   addbutton(Local1, Arg3, nColIni,18, Arg6, Arg7, iif(Arg5 == 1, .T., ;
      .F.))
   addbutton(Local1, Arg3, nColIni+20, 18, Arg8, Arg9, iif(Arg5 == 2, .T., ;
      .F.))
   addbutton(Local1, Arg3, nColIni+40, 18, Arg10, Arg11, iif(Arg5 == 3, .T., ;
      .F.))
   if (Arg1)
      Arg3:= procbutton(Local1, Arg2, iif(Arg4 < 4, Arg4, 3), Arg12)
   else
      showbutton(Local1, Arg2, Arg12)
   endif
   RETURN Arg3


********************************
//*******************************
FUNCTION MSGBOX2(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, ;
      Arg9, Arg10)

   local Local1, Local2, Local3, Local4

   lDesligaRedraw := .t.

   Arg4:= iif(ISNil(Arg4), "Sim", Arg4)
   Arg5:= iif(ISNil(Arg5), "NÆo", Arg5)
   Arg6:= iif(ISNil(Arg6), 1, Arg6)
   Arg7:= iif(ISNil(Arg7), 2, Arg7)
   Arg1:= iif(ISNil(Arg1), "", Arg1)
   Arg2:= iif(ISNil(Arg2), "Aten‡Æo!", Arg2)
   Local1:= iif(ISARRAY(Arg1), Len(Arg1), 1)
   Arg3:= iif(ISNil(Arg3), Int(12 - (Local1 + 7) / 2), Arg3)
   Arg8:= iif(ISNil(Arg8), "W+/R", Arg8)
   Arg9:= iif(ISNil(Arg9), "R/W*", Arg9)
   Arg10:= iif(ISNil(Arg10), "N*/W", Arg10)

   ciAdicional = 0
   TamStr = 0
   TamOpc = 0
   TamOpc += len(Arg4)+4+4
   TamOpc += len(Arg5)+4

   if (ISARRAY(Arg1)) // mensagem
      for Local4:= 1 to len(Arg1)
         TamStr = iif(len(Arg1[Local4]) > TamStr,len(Arg1[Local4]),TamStr)
      next
   else
      TamStr = len(Arg1)
   endif

   if TamOpc < TamStr
      ciAdicional = (TamStr-TamOpc)/2
   endif

   TamStr = iif(TamStr>TamOpc,TamStr,TamOpc)

   Ci:=((maxcol()-TamStr)/2)
   Cf:=Ci+TamStr

   Local3:= newbutton()

   addbutton(Local3, Arg3 + 3 + Local1, Ci+ciAdicional                        ,len(Arg4)+6, Arg4, Nil, iif(Arg7 == 1, .T., .F.))
   addbutton(Local3, Arg3 + 3 + Local1, Ci+len(Arg4)+8+ciAdicional            ,len(Arg5)+6, Arg5, Nil, iif(Arg7 == 2, .T., .F.))

   Local2:= win(Arg3, Ci-3, Arg3 + 5 + Local1, cf+3, Arg2, Arg8, Arg9)

   if (ISARRAY(Arg1))
      for Local4:= 1 to Local1
         DevPos(Arg3 + 1 + Local4, ci)
         vldevout(padc(Arg1[Local4],TamStr), Arg10)
      next
   else
      DevPos(Arg3 + 2, ci)
      vldevout(padc(Arg1,TamStr), Arg10)
   endif
   setcursor(0)
   Local4:= procbutton(Local3, 2, iif(Arg6 < 3, Arg6, 2))
   rstenv(Local2)

   lDesligaRedraw := .f.


RETURN Local4

********************************
function LINBUTTON2(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, ;
   Arg9, Arg10)

   local Local1
   Local1:= newbutton()
   Arg1:= iif(ISNil(Arg1), .T., Arg1)
   Arg2:= iif(ISNil(Arg2), 1, Arg2)
   Arg3:= iif(ISNil(Arg3), 21, Arg3)
   Arg4:= iif(ISNil(Arg4), 1, Arg4)
   Arg5:= iif(ISNil(Arg5), 2, Arg5)
   Arg6:= iif(ISNil(Arg6), "&Salvar", Arg6)
   Arg8:= iif(ISNil(Arg8), "&Cancelar", Arg8)
   nColIni:=(MaxCol()-36) / 2
   addbutton(Local1, Arg3, nColIni,18, Arg6, Arg7, iif(Arg5 == 1, .T., ;
      .F.))
   addbutton(Local1, Arg3, nColIni+20, 18, Arg8, Arg9, iif(Arg5 == 2, .T., ;
      .F.))
   if (Arg1)
      Arg3:= procbutton(Local1, Arg2, iif(Arg4 < 3, Arg4, 2), Arg10)
   else
      showbutton(Local1, Arg2, Arg10)
   endif
   RETURN Arg3

//*******************************
function MSGBOX3(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, ;
      Arg9, Arg10, Arg11)

   local Local1, Local2, Local3, Local4
   lDesligaRedraw := .t.

   Arg4:= iif(ISNil(Arg4), "Sim", Arg4)
   Arg5:= iif(ISNil(Arg5), "NÆo", Arg5)
   Arg6:= iif(ISNil(Arg6), "Cancelar", Arg6)
   Arg7:= iif(ISNil(Arg7), 1, Arg7)
   Arg8:= iif(ISNil(Arg8), 3, Arg8)
   Arg1:= iif(ISNil(Arg1), "", Arg1)
   Arg2:= iif(ISNil(Arg2), "Aten‡Æo!", Arg2)
   Local1:= iif(ISARRAY(Arg1), Len(Arg1), 1)
   Arg3:= iif(ISNil(Arg3), Int(12 - (Local1 + 7) / 2), Arg3)
   Arg9:= iif(ISNil(Arg9), "W+/R", Arg9)
   Arg10:= iif(ISNil(Arg10), "R/W*", Arg10)
   Arg11:= iif(ISNil(Arg11), "N*/W", Arg11)
   Local3:= newbutton()
   nColIni:=(MaxCol()-54) / 2

   ciAdicional = 0
   TamStr = 0
   TamOpc = 0
   TamOpc += len(Arg4)+4+4
   TamOpc += len(Arg5)+4+4
   TamOpc += len(Arg6)+4

   if (ISARRAY(Arg1)) // mensagem
      for Local4:= 1 to len(Arg1)
         TamStr = iif(len(Arg1[Local4]) > TamStr,len(Arg1[Local4]),TamStr)
      next
   else
      TamStr = len(Arg1)
   endif

   if TamOpc < TamStr
      ciAdicional = (TamStr-TamOpc)/2
   endif

   TamStr = iif(TamStr>TamOpc,TamStr,TamOpc)

   Ci:=int(((maxcol()-TamStr)/2))
   Cf:=Ci+TamStr

   addbutton(Local3, Arg3 + 3 + Local1, Ci+ciAdicional                              ,len(Arg4)+6, Arg4, Nil, iif(Arg8 == 1, .T., .F.))
   addbutton(Local3, Arg3 + 3 + Local1, Ci+len(Arg4)+8+ciAdicional          ,len(Arg5)+6, Arg5, Nil, iif(Arg8 == 2, .T., .F.))
   addbutton(Local3, Arg3 + 3 + Local1, Ci+len(Arg4)+8+len(Arg5)+8+ciAdicional,len(Arg6)+6, Arg6, Nil, iif(Arg8 == 3, .T., .F.))

   Local2:= win(Arg3, Ci-3, Arg3 + 5 + Local1, cf+3, Arg2, Arg9, Arg10)

   if (ISARRAY(Arg1)) // mensagem
      for Local4:= 1 to len(Arg1)
         DevPos(Arg3 + 1 + Local4, ci)
         vldevout(padc(Arg1[Local4],TamStr), Arg11)
      next
   else
      DevPos(Arg3 + 2, ci)
      vldevout(padc(Arg1,TamStr), Arg11)
   endif
   setcursor(0)

   Local4:= procbutton(Local3, 2, iif(Arg7 < 3, Arg7, 2))
   rstenv(Local2)

   lDesligaRedraw := .f.

RETURN Local4


********************************
function LINBUTTON1(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)

   local Local1
   Local1:= newbutton()
   Arg1:= iif(ISNil(Arg1), .T., Arg1)
   Arg2:= iif(ISNil(Arg2), 1, Arg2)
   Arg3:= iif(ISNil(Arg3), 21, Arg3)
   Arg4:= iif(ISNil(Arg4), "&OK", Arg4)
   addbutton(Local1, Arg3, (MaxCol()-18)/2, 18, Arg4, Arg5, .T.)
   if (Arg1)
      Arg3:= procbutton(Local1, Arg2, 1, Arg6)
   else
      showbutton(Local1, Arg2, Arg6)
   endif
   RETURN Arg3

********************************
function VLSCRSAVER(Arg1, Arg2)

   local Local1
   Local1:= aclone(STATIC22)
   STATIC22[1]:= iif(Arg1 != Nil, Arg1, STATIC22[1])
   STATIC22[2]:= iif(Arg2 != Nil, Arg2, STATIC22[2])
   RETURN Local1

********************************
function MSGBOX3D(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)

   local Local1, Local2, Local3
   Arg1:= iif(ISNil(Arg1), "", Arg1)
   Arg2:= iif(ISNil(Arg2), "Aguarde", Arg2)
   Local1:= iif(ISARRAY(Arg1), Len(Arg1), 1)
   Arg3:= iif(ISNil(Arg3), 12 - (Local1 + 6) / 2, Arg3)
   Arg4:= iif(ISNil(Arg4), "W+/N", Arg4)
   Arg5:= iif(ISNil(Arg5), "N/W", Arg5)
   Arg6:= iif(ISNil(Arg6), "N/W", Arg6)
   Local2:= win(Arg3, 16, Arg3 + 6 + Local1, 63, Arg2, Arg4, Arg5)
/*
   vldispbox(Arg3 + 2, 17, Arg3 + 5 + Local1, 17, "ÜÜÜÜÜÜÜÜÜ", "W+/W")
   vldispbox(Arg3 + 2, 62, Arg3 + 5 + Local1, 62, "ººººººººº", "N+/W")
   DevPos(Arg3 + 2, 18)
   vldevout(Replicate("Ð", 44), "W+/W")
   DevPos(Arg3 + 5 + Local1, 18)
   vldevout(Replicate("Ì", 44), "N+/W")
/**/
   DESKBOX(Arg3 + 2, 17, Arg3 + 5 + Local1, 62, , "W+/W", "N+/W")

   if (ISARRAY(Arg1))
      for Local3:= 1 to Local1
         DevPos(Arg3 + 3 + Local3, 19)
         vldevout(padc(Arg1[Local3], 42), Arg6)
      next
   else
      DevPos(Arg3 + 4, 19)
      vldevout(padc(Arg1, 42), Arg6)
   endif
   setcursor(0)
   RETURN Local2

********************************
function MSGBOX(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)

   local Local1, Local2, Local3
   Arg1:= iif(ISNil(Arg1), "", Arg1)
   Arg2:= iif(ISNil(Arg2), "Aguarde", Arg2)
   Local1:= iif(ISARRAY(Arg1), Len(Arg1), 1)
   Arg3:= iif(ISNil(Arg3), 12 - (Local1 + 5) / 2, Arg3)
   Arg4:= iif(ISNil(Arg4), "W+*/B", Arg4)
   Arg5:= iif(ISNil(Arg5), "B+*/W", Arg5)
   Arg6:= iif(ISNil(Arg6), "N*/W", Arg6)
   Local2:= win(Arg3, 18, Arg3 + 5 + Local1, 61, Arg2, Arg4, Arg5)
   if (ISARRAY(Arg1))
      for Local3:= 1 to Local1
         DevPos(Arg3 + 2 + Local3, 20)
         vldevout(padc(Arg1[Local3], 40), Arg6)
      next
   else
      DevPos(Arg3 + 3, 20)
      vldevout(padc(Arg1, 40), Arg6)
   endif
   setcursor(0)
   RETURN Local2

********************************
FUNCTION Frame(LI,CI,LF,CF,cRelevo,cTitulo,cPosicao)
DEFAULT cRelevo  To "R",;
        cTitulo  To "" ,;
        cPosicao To "E"

   B1 := "ÕÝ©º½ÐÓÜ"

   @ LI,CI,LF,CF BOX B1 COLOR "N/W,W/N"

   ColorWin(LI,CI,LF,CF,"W+/W,N+/W")

   ClearWin(LI+1,CI+1,LF-1,CF-1,"N/W,N/W")

   If cRelevo $ "RB"
      If cRelevo = "R"
         ColorWin(LI,CF,LF,CF,"N+/W,W/N+")
         ColorWin(LF,CI+1,LF,CF,"N+/W,W/N+")
      Else
         ColorWin(LI,CI,LI,CF - 1,"N+/W,W/N+")
         ColorWin(LI,CI,LF,CI,"N+/W,W/N+")
      EndIf
   EndIf
   If !Empty(cTitulo)
      Do Case
      Case cPosicao == "E"
         @LI,CI+2 Say cTitulo Color "N/W"
      Case cPosicao == "C"
         nPos:=(CF-Len(cTitulo)+2) / 2
         @LI,nPos Say cTitulo Color "N/W"
      Case cPosicao == "D"
         @LI,CF-Len(cTitulo)-1 Say cTitulo Color "N/W"
      EndCase
   EndIf

RETURN Nil

********************************
function SETKEYMOUSE(Arg1, Arg2)
   RETURN SETKEYMOUS(Arg1, Arg2)

function SETKEYMOUS(Arg1, Arg2)

   local Local1, Local2, Local3
   Local3:= {}
   if (PCount() == 1)
      Local1:= ascan(STATIC18, {|_1| _1[1] == Arg1})
      if (Local1 > 0)
         Local3:= STATIC18[Local1][2]
      endif
   elseif (Len(Arg2) == 4)
      Local1:= ascan(STATIC18, {|_1| _1[1] == Arg1})
      if (Local1 > 0)
         Local3:= STATIC18[Local1][2]
         STATIC18[Local1][1]:= Arg1
         STATIC18[Local1][2]:= Arg2
      else
         AAdd(STATIC18, {Arg1, Arg2})
      endif
   elseif (Len(Arg2) == 0)
      Local1:= ascan(STATIC18, {|_1| _1[1] == Arg1})
      if (Local1 > 0)
         Local3:= STATIC18[Local1][2]
         adel(STATIC18, Local1)
         asize(STATIC18, Len(STATIC18) - 1)
      else
      endif
   endif
   RETURN Local3

********************************
function VLKeyboard(Arg1)
   keyboard Arg1
   RETURN Nil

********************************
function LINBUTTON(Arg1, Arg2, Arg3, Arg4, Arg5, Opcoes, Arg7, Arg8, ;
   Arg9, Arg10, Arg11, Arg12, Arg13, Arg14,Arg15)

   local Local1
   Local TamOpc:=0, TamStr:=0, nPos
   Local1:= newbutton()
   Arg1:= iif(ISNil(Arg1), .T., Arg1)
   Arg2:= iif(ISNil(Arg2), 1, Arg2)
   Arg3:= iif(ISNil(Arg3), 21, Arg3)
   Arg4:= iif(ISNil(Arg4), 1, Arg4)
   Arg5:= iif(ISNil(Arg5), 6, Arg5)

   nColIni:= iif(ISNil(Arg15),10, Arg15)  // POSICAO COLULA

   For I:=1 To Len(Opcoes)
     nPos:=At("$",Opcoes[I])
     If nPos = 0
       TamOpc+=Len(Opcoes[I])
     Else
       TamOpc+=Len(Opcoes[I]) -1
     EndIf
   Next
   NroOpc:=Len(Opcoes)

   //TamOpc+=(4*NroOpc)+(3*(NroOpc-1))
   TamOpc+=(4*NroOpc)+(3*(NroOpc-1))


   TamStr = iif(TamStr>TamOpc,TamStr,TamOpc)

   For I:=1 To Len(Opcoes)
      nTam:=Len(Opcoes[I])+4 // era 6
      addbutton(Local1, Arg3, nColIni, nTam, Opcoes[I],   Arg7, iif(Arg5 == I, .T., .F.))
      aadd(aPosicoes,{Arg3,Arg3,nColIni,nColIni+nTam})
      nColIni +=nTam
   next

   if (Arg1)
      Arg3:= procbutton(Local1, Arg2, iif(Arg4 <= NroOpc, Arg4, NroOpc), Arg14)
   else
      showbutton(Local1, Arg2, Arg14)
   endif
   RETURN Arg3


********************************
function LINBUTTON4(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, ;
   Arg9, Arg10, Arg11, Arg12, Arg13, Arg14)

   local Local1
   Local1:= newbutton()
   Arg1:= iif(ISNil(Arg1), .T., Arg1)
   Arg2:= iif(ISNil(Arg2), 1, Arg2)
   Arg3:= iif(ISNil(Arg3), 21, Arg3)
   Arg4:= iif(ISNil(Arg4), 1, Arg4)
   Arg5:= iif(ISNil(Arg5), 4, Arg5)
   Arg6:= iif(ISNil(Arg6), "&Salvar", Arg6)
   Arg8:= iif(ISNil(Arg8), "&Alterar", Arg8)
   Arg10:= iif(ISNil(Arg10), "&Excluir", Arg10)
   Arg12:= iif(ISNil(Arg12), "&Cancelar", Arg12)
   nColIni:=(MaxCol()-72) / 2

   addbutton(Local1, Arg3, nColIni,    18, Arg6,   Arg7, iif(Arg5 == 1, .T., .F.))
   addbutton(Local1, Arg3, nColIni+20, 18, Arg8,   Arg9, iif(Arg5 == 2, .T., .F.))
   addbutton(Local1, Arg3, nColIni+40, 18, Arg10, Arg11, iif(Arg5 == 3, .T., .F.))
   addbutton(Local1, Arg3, nColIni+60, 18, Arg12, Arg13, iif(Arg5 == 4, .T., .F.))
   if (Arg1)
      Arg3:= procbutton(Local1, Arg2, iif(Arg4 < 5, Arg4, 4), Arg14)
   else
      showbutton(Local1, Arg2, Arg14)
   endif
   RETURN Arg3

********************************
function VLMARQUEE(Arg1, Arg2, Arg3)

   local Local1, Local2, Local3, Local4
   local r24 := MaxRow()
   local c79 := MaxCol()-1
   
   Local1:= savenv(0, 0, r24, c79)
   setcursor(0)
   Arg1:= iif(ISNil(Arg1), "Pressione algo para continuar...", Arg1)
   Arg2:= iif(ISNil(Arg2), "W/N", Arg2)
   Arg3:= iif(ISNil(Arg3), 0.1, Arg3)
   set color to
   vlscroll()
   SetPos(0, 0)
   do while (.T.)
      for Local3:= 0 to r24
         for Local4:= 0 to c79
            DevPos(Local3, Local4)
            vldevout(Arg1, Arg2)
            Local2:= waitsaver(Arg3)
            if (Local2)
               exit
            endif
            DevPos(Local3, Local4)
            vldevout("  ")
         next
         if (Local2)
            exit
         endif
      next
      if (Local2)
         exit
      endif
   enddo
   rstenv(Local1)
   RETURN Nil


********************************
function WAITSAVER(Arg1)

   local Local1, Local2, Local3, Local4
   Local1:= array(4)
   Local2:= array(4)
   Local4:= .F.
   vlmouseinf(Local1)
   Local2:= aclone(Local1)
   resettimer()
   do while (.T.)
      if ((Local3:= InKey(.5)) != 0)//.1
         Local4:= .T.
         exit
      endif
      vlmouseinf(Local1)
      if (Local2[1] != Local1[1] .Or. Local2[2] != Local1[2] .Or. ;
            Local2[3] != Local1[3] .Or. Local2[4] != Local1[4])
         Local4:= .T.
         exit
      endif
      if (ISNil(Arg1))
         exit
      elseif (Arg1 == 0)
         loop
      elseif (Seconds() - gettimer() >= Arg1)
         exit
      endif
   enddo
   RETURN Local4

********************************
function GETKEYMOUSE
   RETURN GETKEYMOUS()

function GETKEYMOUS
   RETURN STATIC18

/* Mouse FUNCTION's */
function VLMouseDN(i,a)
   // Botao esquerdo
   if i == 00
      a[1] := arrMouseInfLeft[1]
      a[2] := arrMouseInfLeft[2]
      a[3] := arrMouseInfLeft[3]
      
      arrMouseInfLeft[1] := 00
      arrMouseInfLeft[2] := 00
      arrMouseInfLeft[3] := 00
      //RETURN aClone( arrMouseInfLeft )
   else
      a[1] := arrMouseInfRight[1]
      a[2] := arrMouseInfRight[2]
      a[3] := arrMouseInfRight[3]
      
      arrMouseInfRight[1] := 00
      arrMouseInfRight[2] := 00
      arrMouseInfRight[3] := 00
      //RETURN aClone( arrMouseInfRight )
   endif
   RETURN

function VLMouseINF(a)
      a[1] = mLeftDown()   // .F.
      a[2] = mRightDown()  // .F.
      a[3] = mRow()        // 00
      a[4] = mCol()        // 00
   RETURN

function VLMouseINI(a)
   RETURN mPresent()

function VLMouseON()
   RETURN mSetCursor(.T.)

function VLMouseOFF()
   RETURN mSetCursor(.F.)

function VLMouseUP(i,a)
   if i == 00
      RETURN aClone( arrMouseInfLeft )
   else
      RETURN aClone( arrMouseInfRight )
   endif
   RETURN

function VLSetMouse(l)
   //STATIC sl := .F.
   //   if l <> nil ; sl := l ; end
   //RETURN sl
   if pcount() == 00
      RETURN mSetCursor()
   else
      RETURN mSetCursor(l)
   endif

/*** API FUNCTIONs ... **/
function vl850(lCallSetMode,lCallSetFont)
   local l := 'vlfont.exe on blink'
   local c := setcursor(0)
   
   if GuiSupport()
      RETURN nil
   end
   
   if lCallSetMode == nil
      lCallSetMode := .T.
   endif
   
   if lCallSetFont == nil
      lCallSetFont := .T.
   endif
   
   if lCallSetMode
      vlsetmode(25, MaxCol()+1)
   end
   
   if lCallSetFont
      __run(l)
   endif
   setcursor(c)
   RETURN

function vlSetBlink( l )
   STATIC x := .T.
   local u  := x
   local c := setcursor(0)
   if sbGuiSupport; RETURN u; end
   if l <> nil
      l := 'vlfont.exe ' + iif( !l, 'noblink', 'blink' )
      __Run( l )
   endif
   setcursor(c)
   RETURN u

function Setswmouse(x)
   STATIC swMouse := .F.
   
   if pcount()<>00
      swMouse := x
   end
   
   RETURN swMouse

function GuiSupport(X,XX)
   LOCAL y := sbGuiSupport
   LOCAL yy:= sbGuiSupportEx

   If PCount()>0
      sbGuiSupport := x
   End

   If PCount()==02
      sbGuiSupportEx := xx
   End
   RETURN y

INIT PROCEDURE VLInit
   LOCAL x := Nil
   LOCAL d := ErrorBlock( {|x| Break(x) } )
   
   BEGIN SEQUENCE
      x := "{|| WVT_SETCODEPAGE(255),GUISUpport(.F.) }"
      x := &X.
      x := X:Eval()
   RECOVER USING x

   End

   BEGIN SEQUENCE
      x := "{|| WVW_SETCODEPAGE(0,255),GUISUpport(.F.,.F.) }"
      x := &X.
      x := X:Eval()
   RECOVER USING x

   End

   ErrorBlock(d)
   RETURN Nil

#pragma BEGINDUMP
#define HB_OS_WIN_USED
//-------------------------------0--------------------------------------------//
#include "hbapi.h"
#include "windows.h"
#include "ocidl.h"
#include "olectl.h"

HB_FUNC( KS_NOCAPTION )
{
  DWORD Style = (WS_POPUP|WS_BORDER |WS_SYSMENU |WS_CLIPCHILDREN);
  hb_retni( Style );
}
#pragma ENDDUMP
