#include "common.ch"
#include "inkey.ch"
#INCLUDE "GETEXIT.CH"

#command @ <row> , <col>  GET <var> ;
[<clauses,...>]         ;
PASSWORD                ;
[<moreClauses,...>]     ;
;
=> @ <row> , <col>  GET <var> ;
[<clauses>]             ;
SEND reader := {|oGet|  ;
GetPassword(oGet) };
[<moreClauses>]


#xtranslate ISNIL( <xValue> )       => HB_ISNIL( <xValue> )
#xtranslate ISBLOCK( <xValue> )     => HB_ISBLOCK( <xValue> )
#xtranslate ISARRAY( <xValue> )     => HB_ISARRAY( <xValue> )
#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)

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
   STATIC20:= 0, STATIC21:= 0, STATIC22:= {60, {|| vlmarquee()}}
STATIC ;
   arrMouseInfLeft  := { 0,0,0 },;
   arrMouseInfRight := { 0,0,0 }
STATIC ;
   sbGuiSupport   := .F.,;
   sbGuiSupportEx := .F.





********************************
STATIC function DISPLAYBAR(Arg1, Arg2, Arg3)

   aeval(Arg1, {|_1| (_1[6]:= Arg2, drawbarite(_1, 1, Arg3))})

   RETURN Nil


********************************
STATIC function SHOWBARFOC(Arg1, Arg2)


   drawbarite(Arg1, 2, Arg2)
   showbarmsg(Arg1, Arg2)
   RETURN Nil

********************************
STATIC function BARLEFT(Arg1, Arg2, Arg3)


   if (setmovflag() .And. setbarmsg())
      setbarmsg(.F.)
   endif
   hidebarfoc(Arg1[Arg2], Arg3)
   Arg2:= iif(--Arg2 == 0, Len(Arg1), Arg2)
   showbarfoc(Arg1[Arg2], Arg3)

*WvtSetBlocks( aLastPaint )

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

********************************
STATIC function BAREXECUTE(Arg1, Arg2, Arg3, Arg4, Arg5)

   local Local1

   if (ISARRAY(Arg1[Arg2][3]) .And. Arg1[Arg2][4])

      Local1:= downmenu(Arg1[Arg2][3], 1, Arg1[Arg2][6] + 1, ;
         Arg1[Arg2][7], 1, Arg5, Arg3, Arg1)
      Arg2:= iif(Local1 == -1, Arg2, Local1)
   elseif (ISBLOCK(Arg1[Arg2][3]) .And. Arg1[Arg2][4] .And. Arg4 !=    -1)

      if (setmovflag() .And. !setbarmsg())
         setbarmsg(.T.)
      else
         setmovflag(.F.)
         eval(Arg1[Arg2][3])
      endif
   endif


   RETURN Arg2

********************************
STATIC function BARESCAPE(Arg1, Arg2, Arg3)

   RETURN 0

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
STATIC function HIDEBARFOC(Arg1, Arg2)


   drawbarite(Arg1, 1, Arg2)


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
      Local7:= nbox(Arg4, Arg5, Local5, Local6, Arg8[9],.F.)
   else

     cImagemlocal := Wvt_SaveScreen(Arg4, Arg5, Local5+2, Local6+3)


     aadd(cInicIMG826,cImagemlocal)
     aadd(aInicIMG826,{Arg4, Arg5, Local5+2, Local6+3})
     
     
     Local7:= nbox(Arg4, Arg5, Local5, Local6, Arg8[9],.F.)


   end


   for Local4:= 1 to Local1
      Arg2[Local4][6]:= Arg4 + Local4
      Arg2[Local4][7]:= Arg5 + 1
   next
   AAdd(Arg1, {{Arg3, Local7, Arg4, Arg5, Local5, Local6}, Arg2})



   RETURN Nil

********************************
STATIC function DISPLAYDOWN(Arg1, Arg2)
   RETURN DISPLAYDOW(Arg1, Arg2)

STATIC function DISPLAYDOW(Arg1, Arg2)

   local Local1
   

   for Local1:= 1 to Len(Arg1[2])
      drawdownit(Arg1[2][Local1], 1, Arg2)
   next

*   cTelaIMG := savescreen(2, 0, 24, 80 )  // salva a tela


   RETURN Nil

********************************
STATIC function SHOWDWNFOC(Arg1, Arg2)

   drawdownit(Arg1, 2, Arg2)
   showdownms(Arg1, Arg2)

   RETURN Nil

********************************
STATIC function DWNGOTO(Arg1, Arg2, Arg3, Arg4)

   hidedwnfoc(Arg1[Arg2], Arg4)
   Arg2:= iif(Arg1[Arg3][9], Arg2, Arg3)
   showdwnfoc(Arg1[Arg2], Arg4)
   RETURN Arg2

********************************
STATIC function DWNEXECUTE(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)
   local lSavepri

   *    if !alltrim(netname()) $ "#PC-VIRTUAL#REDE#SERVIDOR#SILASNITRO#"
 *     nAtua:= directory("\\servidor\disk_ser\tmp\maxilit.EXE")
 *     nLoca:= directory("C:\MAXI\maxilit.EXE")

 *     if nAtua[1][2] # nLoca[1][2] .or. nAtua[1][3] # nLoca[1][3] .or. nAtua[1][4] # nLoca[1][4]
 *       clear
 *       alert2("* * * FAVOR ATUALIZAR O SISTEMA * * *")
 *       clear
 *       quit
 *     endif
 *   endif

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

     cTelaIMG3 := Wvt_SaveScreen(0, 0, maxrow(), maxcol())  // salva a tela
     eval(Arg2[Arg3][3])
     Wvt_RestScreen(0, 0, maxrow(), maxcol(), cTelaIMG3 )  // restaura a tela

*     wvt_DrawLabel(MAXROW()-1 ,0,space(100),,, RGB( 0, 0,0), RGB( 255, 255,255 )  , "Visualnova", _FONTET_, , , , , .f., .f. ,.f.)

     cF_ATV = "MENU          "
     cF_MOD = "PRINCIPAL     "
     cF_PRG = "SIS V.4.2     "
     M_FAN = "SISTEMA INGEGRADO"
     rodape()
   endif


   RETURN Arg3

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
STATIC function DWNESCAPE(Arg1, Arg2, Arg3)

   auxpopdown(Arg1)
   setbarmsg(.T.)
   
   RETURN 0

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
STATIC function AUXPOPDOWN(Arg1)

   local Local1
   Local1:= Len(Arg1)
*   rstenv(Arg1[Local1][1][2])
   asize(Arg1, Local1 - 1)

   // a tela foi gravada em AUXPSHDOWN

   Wvt_RestScreen(aInicIMG826[len(aInicIMG826)][1], aInicIMG826[len(aInicIMG826)][2], aInicIMG826[len(aInicIMG826)][3], aInicIMG826[len(aInicIMG826)][4],cInicIMG826[len(cInicIMG826)])  // restaura a tela

   adel(cInicIMG826,len(cInicIMG826))
   asize(cInicIMG826,len(cInicIMG826) - 1)

   adel(aInicIMG826,len(aInicIMG826))
   asize(aInicIMG826,len(aInicIMG826) - 1)


   RETURN Nil

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
function NBOX2(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)
   local Local1

   Local1:= savenv(Arg1, Arg2, Arg3 + 1, Arg4 + 2)
   Arg5:= iif(ISNil(Arg5), "W/W+", Arg5)
   Arg6:= iif(ISNil(Arg6), "W/W+", Arg6)

   B0 := "ÚÄ¿³ÙÄÀ³"
   B6 := 'ÉÐËÜÊÌÈº'


   if alltrim(_FONTEN_) == "NORMAL"
     vldispbox(Arg1, Arg2, Arg3, Arg4, B0, Arg5)
   else
     vldispbox(Arg1, Arg2, Arg3, Arg4, B6, Arg5)
   endif

*   painel(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)

  sombran(Arg1, Arg2, Arg3, Arg4)

   RETURN Local1


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
STATIC function SHOWDOWNMS(Arg1, Arg2)

   if (Arg1[2] != Nil .Or. Arg1[2] = "")
      dwnmsg(Arg1[2], Arg2[10])
   endif
   RETURN Nil

********************************
STATIC function HIDEDWNFOC(Arg1, Arg2)

   drawdownit(Arg1, 1, Arg2)
   RETURN Nil

**********************
Static Function Opcoes(nRow, aCol, aOptions, nBeginOption)
**********************

Local nCtr,lKeyValid,cLetter,nLastOption

Local nOption     := nBeginOption,  ;
nKeyPress   := 0,             ;
nOptions    := Len(aOptions), ;
cIniLets    := ""

*nRow--

For nCtr := 1 To nOptions
  cIniLets=cIniLets+Upper(Left(Ltrim(aOptions[nCtr]),1))
  @ nRow, aCol[nCtr] Say aOptions[nCtr] Color cCorNormal
Next nCtr

@ nRow, aCol[nOption] Say aOptions[nOption] Color cCorInverso

nLastOption := nOption

While .T.

  lKeyValid := .F.

  While !lKeyValid

    cLetter := Upper( Chr(nKeyPress) )

    If cLetter $ cIniLets

      nOption := At(cLetter, cIniLets)

      @ nRow, aCol[nLastOption] Say aOptions[nLastOption] Color cCorNormal
      @ nRow, aCol[nOption]     Say aOptions[nOption]     Color cCorInverso

      nLastOption := nOption

*      KeyBoard Chr(13)

    End

    nKeyPress := InKey(0)

    lKeyValid := ( nKeyPress == K_HOME  .Or. nKeyPress == K_END   .Or. ;
    nKeyPress == K_LEFT  .Or. nKeyPress == K_RIGHT .Or. ;
    nKeyPress == K_ENTER .Or. nKeyPress == K_ESC )

  End

  If nKeyPress == K_ESC

    nOption := 0

    Exit

  ElseIf nKeyPress == K_ENTER

    Exit

  ElseIf nKeyPress == K_LEFT

    If nOption > 1
      nOption --
    Else
      nOption := 1
    End

  ElseIf nKeyPress == K_RIGHT

    If nOption < nOptions
      nOption ++
    Else
      nOption := nOptions
    End

  ElseIf nKeyPress == K_HOME

    nOption := 1

  ElseIf nKeyPress == K_END

    nOption := nOptions

End

@ nRow, aCol[nLastOption] Say aOptions[nLastOption] Color cCorNormal
@ nRow, aCol[nOption] Say aOptions[nOption] Color cCorInverso

nLastOption := nOption

End

Return nOption



function SOMBRAN(Arg1, Arg2, Arg3, Arg4)


*   local Local1, Local2, Local3, Local4, vSombra

   sombra(Arg1, Arg2, Arg3, Arg4,_SOMBRA_)


*   vSombra = savescreen(Arg1 + 1, Arg4 + 1, Arg3 + 1, Arg4 + 1)
*             restscreen(Arg1 + 1, Arg4 + 1, Arg3 + 1, Arg4 + 1, replicate(" " + CHR(129), len(vSombra)))
*   vSombra:= vlsavescre(Arg3 + 1, Arg2 + 1, Arg3 + 1, Arg4 + 1)
*             restscreen(Arg3 + 1, Arg2 + 1, Arg3 + 1, Arg4 + 1, replicate(" " + CHR(129), len(vSombra)))

*   vSombra = savescreen(Arg1 + 1, Arg4 + 1, Arg3 + 1, Arg4 + 1)
*             restscreen(Arg1 + 1, Arg4 + 1, Arg3 + 1, Arg4 + 1, replicate(" " + chr(261), len(vSombra)))
*   vSombra:= vlsavescre(Arg3 + 1, Arg2 + 1, Arg3 + 1, Arg4 + 1)
*             restscreen(Arg3 + 1, Arg2 + 1, Arg3 + 1, Arg4 + 1, replicate(" " + chr(261), len(vSombra)))
*
RETURN Nil

*set console off
*clear screen

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
*   Local3:= {0, 0, 8, 8, 0, 8, 0, 8, 0, 1, 2, 3, 4, 5, 6, 7}
   Local3:= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

   Local1:= Local3[Local1 + 1]
   Local2:= Local3[Local2 + 1]
   RETURN Chr(16 * Local2 + Local1)


********************************
STATIC function TEXTBUTTON(Arg1)

   local Local1, Local2, Local3, Local4
   Local1:= ""
   Local2:= At("&", Arg1)
   Local3:= SubStr(Arg1, 1, Local2 - 1)
   Local4:= SubStr(Arg1, Local2 + 1)
   RETURN iif(Local2 != 0, Local3 + Local4, Arg1)


**************
function _SEEK                         && pesquisa
**************

  parameters F_CHAVE

  seek F_CHAVE

  if !eof()
    return .t.
  endif

return .f.


**************
function MOD11_STD                         && calculo digito verificador
**************

parameters F_DIG

private M_SOMA  ,;
        M_DIG

M_SOMA = (val(substr(F_DIG, 7, 1)) * 2) + ;
         (val(substr(F_DIG, 6, 1)) * 3) + ;
         (val(substr(F_DIG, 5, 1)) * 4) + ;
         (val(substr(F_DIG, 4, 1)) * 5) + ;
         (val(substr(F_DIG, 3, 1)) * 6) + ;
         (val(substr(F_DIG, 2, 1)) * 7) + ;
         (val(substr(F_DIG, 1, 1)) * 8)

M_DIG = iif((M_SOMA % 11)=0,0,iif((M_SOMA % 11)=1,0,(11-(M_SOMA % 11))))

return str(M_DIG, 1, 0)


**************
function MESES(TIPO)
**************

private MT_MES[12]

declare MT_MES[12]

MT_MES[ 1] = "JANEIRO"
MT_MES[ 2] = "FEVEREIRO"
MT_MES[ 3] = "MARCO"
MT_MES[ 4] = "ABRIL"
MT_MES[ 5] = "MAIO"
MT_MES[ 6] = "JUNHO"
MT_MES[ 7] = "JULHO"
MT_MES[ 8] = "AGOSTO"
MT_MES[ 9] = "SETEMBRO"
MT_MES[10] = "OUTUBRO"
MT_MES[11] = "NOVEMBRO"
MT_MES[12] = "DEZEMBRO"

return MT_MES[TIPO]


***************
Function JANELA(Li,Ci,Lf,Cf,Cor)
***************

sombra(li,Ci,Lf,Cf,_SOMBRA_)
SetColor(Cor)
@ li,Ci,Lf,Cf box M_FRAME1
painel(li, ci, lf, cf,"G+/G","N/G")
Return ""

function IMPTELA

local cSrc := ""
local cLin
local l,c

for l := 0 to 24
  clin := SaveScreen(l,0,l,80)
  for c := 1 to 80
    cLin := Stuff(clin,c+1,1,"")
  next
  cSrc += cLin+chr(13)+chr(10)
next

set console off
set print on
set printer to "TELA.TXT"

? cSrc
set printer to
set print off

filecopy("TELA.TXT","RELATO.RPT",.T.)
M_IMPRE = "L"
desliga1(80)

set console on

return ""

* PROXIMA SENHA 498

**************
Function ALERT2(string,Opcoes,som,poslinha,limpar,semopc,corfundo)
**************
Local CorSalva:=SetColor()
Local TamOpc:=0, TamStr:=0, nPos
Local NroLin:=1,A,linhas,texto
Local linha

if corfundo = NIL
  corfundo = "W+/G"
endif

if limpar = NIL
  limpar = .t.
endif

if SemOpc = NIL
  SemOpc = .f.
endif

if poslinha = NIL
  poslinha = 0
endif

linha = { }
texto = ""

for A = 1 to len(String)
  if substr(String,A,1) == ";"
    aadd(linha,TEXTO)
    TamStr = iif(len(TEXTO) > TamStr,len(TEXTO),TamStr)
    texto = ""
    NroLin ++
  else
    texto += substr(String,A,1)
  endif
next

TamStr = iif(len(TEXTO) > TamStr,len(TEXTO),TamStr)
aadd(linha,TEXTO)

If Opcoes == Nil
  if !SemOpc
    Opcoes:={"$Ok"}
  endif
EndIf

if !SemOpc
  For I:=1 To Len(Opcoes)
    nPos:=At("$",Opcoes[I])
    If nPos = 0
      TamOpc+=Len(Opcoes[I])
    Else
      TamOpc+=Len(Opcoes[I]) -1
    EndIf
  Next
  NroOpc:=Len(Opcoes)
else
  NroOpc:=0
endif


TamOpc+=(4*NroOpc)+(3*(NroOpc-1))
Li:=(maxrow()-NroLin-poslinha)/2
Lf:=Li+NroLin+4
TamStr = iif(TamStr>TamOpc,TamStr,TamOpc)

Ci:=((maxcol()-TamStr)/2)
Cf:=Ci+TamStr

*Telaalert:=SaveScreen(Li,Ci-3,Lf+1,Cf+3)

res1 = Li-3
res2 = Ci-3
res3 = Lf+4
res4 = Cf+5

Telaalert2:=WvT_SaveScreen(res1,res2,res3,res4)

nbox(li,ci-2,lf,cf+2,corfundo)
setcolor(corfundo)


ColBot:=((80-TamOpc)/2)+1
Li+=1

For I:= 1 To NroLin
  @ Li++,Ci Say Padc(linha[I],(Cf-Ci)+2)
Next

if !SemOpc
  Opc:=Botaoa(Lf-2,ColBot,Opcoes,som)
endif

if limpar
  *RestScreen(Li,Ci-3,Lf+1,Cf+3,Telaalert)
  WvT_RestScreen(res1,res2,res3,res4,Telaalert2)
 * zrevwindow()
endif

SetColor(CorSalva)

if !SemOpc
  Return(Opc)
else
  return 0
endif

**************
Function Botaoa(Li,Ci,Opcoes,som)
**************

// Parametros
//** Li - Linha onde vai ser desenhado o botao
//** Ci - Coluna Inicial onde vai ser comecado a desenhar o botao
//** Opcoes - Matriz com as Opcäes

Local CorSalva:=SetColor(), Col:={}, nPos, nTam, OpcAnt, nPosAnt
Local NroOpc:=Len(Opcoes), LetraCon:={}, NumOpc:=1, Escolheu:=.F.
Local CorFundo:=SubStr(CorSalva,At("/",CorSalva)+1,At(",",CorSalva)-At("/",CorSalva)-1)
Local CursorSalvo:=SetCursor()

Local CorBot1:="W+/BG", CorBot2:="GR+/BG"  // Variaveis que setam as
Local CorBot3:="W+/R" , CorBot4:="GR+/R"   // Cores do Botao

SetCursor(0)
For I:=1 To Len(Opcoes)
  nPos:=At("$",Opcoes[I])
  If nPos = 0
    nPos:=1
    Opcoes[I]:="$"+Opcoes[I]
  EndIf
  nTam:=Len(Opcoes[I]) - 1
  SetColor("B/B")
  @ Li  ,Ci+nTam+4 Say " "
  SetColor("U/"+ CorFundo)

  @ Li+1,Ci+1 Say Replicate("ß",nTam+4)
  AADD(Col,Ci)
  AADD(LetraCon,Upper(SubStr(Opcoes[I],nPos+1,1)))
  SetColor(CorBot1)
  @ Li,Ci Say "  " + SubStr(Opcoes[I],1,nPos - 1)
  @ Li,Ci+nPos+2 Say SubStr(Opcoes[I],nPos+2) +  "  "
  SetColor(CorBot2)
  @ Li,Ci+nPos+1 Say SubStr(Opcoes[I],nPos+1,1)
  Ci+=nTam+7
Next

nPos:=At("$",Opcoes[1])
SetColor(CorBot3)
@ Li,Col[1] Say " <" + SubStr(Opcoes[1],1,nPos - 1)
@ Li,Col[1]+nPos+2 Say SubStr(Opcoes[1],nPos+2) +  "> "
SetColor(CorBot4)
@ Li,Col[1]+nPos+1 Say SubStr(Opcoes[1],nPos+1,1)

Do While .T.

  do while .t.
    Tecla  :=ninkey()
    if Tecla > 0
      exit
    endif
    if som = nil
    else
      Tecla  :=ninkey()
      if Tecla > 0
        exit
      endif
      Tecla  :=ninkey()
      if Tecla > 0
        exit
      endif
    endif
  enddo

  OpcAnt :=NumOpc
  nPosAnt:=AT("$",Opcoes[NumOpc])

  If Tecla = 19 .or. Tecla = 5
    If NumOpc = 1
      NumOpc:=Len(Opcoes)
    Else
      NumOpc--
    EndIf
  ElseIf Tecla = 4 .or. Tecla = 24
    If NumOpc = Len(Opcoes)
      NumOpc:=1
    Else
      NumOpc++
    EndIf
  ElseIf (Tecla >= 65 .and. Tecla <= 90)  .or.;
    (Tecla >= 97 .and. Tecla <= 122) .or.;
    (Tecla >= 48 .and. Tecla <= 57)
    Letra:=Upper(Chr(Tecla))
    If Ascan(LetraCon,Letra) # 0
      NumOpc:=Ascan(LetraCon,Letra)
      Escolheu:=.T.
    Else
      Loop
    EndIf
  ElseIf Tecla = 13 .or.;
    Tecla = 32
    Escolheu:=.T.
  ElseIf Tecla = 27
    NumOpc:=0
    Exit
  EndIf

  If Escolheu = .T.

    If OpcAnt # NumOpc

      SetColor(CorBot1)
      @ Li,Col[OpcAnt] Say "  " + SubStr(Opcoes[OpcAnt],1,nPosAnt-1)
      @ Li,Col[OpcAnt]+nPos+2 Say SubStr(Opcoes[OpcAnt],nPosAnt+2) +  "  "
      SetColor(CorBot2)
      @ Li,Col[OpcAnt]+nPos+1 Say SubStr(Opcoes[OpcAnt],nPosAnt+1,1)

    EndIf

    nTam:=Len(Opcoes[NumOpc]) - 1
    SetColor(CorFundo + "/" + CorFundo)
    @ Li,Col[NumOpc]+nTam+4 Say Replicate("Û",1)
    @ Li+1,Col[NumOpc] Say Replicate("ß",nTam+5)
    @ Li,Col[NumOpc] Say "Û"
    @ Li,Col[NumOpc]+1 Say Replicate("Û",nTam+3)

    nPos:=At("$",Opcoes[NumOpc])
    SetColor(CorBot3)
    @ Li,Col[NumOpc]+1 Say "  " + SubStr(Opcoes[NumOpc],1,nPos - 1)
    @ Li,Col[NumOpc]+nPos+3 Say SubStr(Opcoes[NumOpc],nPos+2) +  "  "
    SetColor(CorBot4)
    @ Li,Col[NumOpc]+nPos+2 Say SubStr(Opcoes[NumOpc],nPos+1,1)
    ninkey(0.1)
    Exit
  EndIf

  SetColor(CorBot1)
  @ Li,Col[OpcAnt] Say "  " + SubStr(Opcoes[OpcAnt],1,nPos - 1)
  @ Li,Col[OpcAnt]+nPos+2 Say SubStr(Opcoes[OpcAnt],nPos+2) +  "  "
  SetColor(CorBot2)
  @ Li,Col[OpcAnt]+nPos+1 Say SubStr(Opcoes[OpcAnt],nPos+1,1)

  nPos:=At("$",Opcoes[NumOpc])
  SetColor(CorBot3)
  @ Li,Col[NumOpc] Say " <" + SubStr(Opcoes[NumOpc],1,nPos - 1)
  @ Li,Col[NumOpc]+nPos+2 Say SubStr(Opcoes[NumOpc],nPos+2) +  "> "
  SetColor(CorBot4)
  @ Li,Col[NumOpc]+nPos+1 Say SubStr(Opcoes[NumOpc],nPos+1,1)

EndDo
SetColor(CorSalva)
SetCursor(CursorSalvo)
Return(NumOpc)

**************************
function GetF2(oGet,funcao,retorno,validar)
**************************

local nKey,nChar,cKey

set cursor on

if (GetPrevalidate(oGet))
  oGet:SetFocus()
  oGet:cargo:=""
*  n_tempo = time()

  while(oGet:exitState==GE_NOEXIT)
    if(oget:typeOut)
      oGet:exitState:=GE_ENTER
    endif
    do while(oGet:exitState==GE_NOEXIT)
      nKey:=may_inkey(0)  // inkey(0)

      do case
        CASE ( nKey == K_INS )
        SET( _SET_INSERT, !SET( _SET_INSERT ) )
        ShowScoreboard()

        CASE ( nKey == K_HOME )
        oGet:home()

        CASE ( nKey == K_END )
        oGet:end()

        CASE ( nKey == K_RIGHT )
        oGet:right()

        CASE ( nKey == K_LEFT )
        oGet:left()

        CASE ( nKey == K_DEL )
        oGet:delete()

        CASE ( nKey == K_UP )
        oGet:exitState := GE_UP

        CASE ( nKey == K_SH_TAB )
        oGet:exitState := GE_UP

        CASE ( nKey == K_DOWN )
        oGet:exitState := GE_DOWN

        CASE ( nKey == K_TAB )
        oGet:exitState := GE_DOWN
        case ( nKey == K_ESC )
          oGet:undo()
          oGet:exitState := GE_ESCAPE
        case ( nKey == K_F2 )
          &funcao
          retorno = nCodRetorno
          oGet:updateBuffer()
        endcase
      if nkey>=32.and.nkey<=255
        oGet:cargo+=chr(nkey)
        getApplykey(oGet,chr(nkey))
      elseif nkey==K_BS
        oGet:cargo:=substr(oGet:cargo,1,len(oGet:cargo)-1)
        GetApplykey(oGet,nKey)
      elseif nkey==K_ENTER
        GetApplykey(oGet,nKey)
      elseif !(( bKeyBlock := setkey( nKey )) == NIL )
        GetDoSetKey( bKeyBlock, oGet )
      endif
    enddo
    if(!GetPostValidate(oGet))
      oGet:exitState:=GE_NOEXIT
    endif
  enddo
  oget:KillFocus()
endif

return""

*******************************
procedure SHOWSCOREBOARD()
*******************************

LOCAL nRow
LOCAL nCol

IF ( SET( _SET_SCOREBOARD ) )
nRow := ROW()
nCol := COL()

SETPOS( SCORE_ROW, SCORE_COL )
DISPOUT( IF( SET( _SET_INSERT ), NationMsg(_GET_INSERT_ON),;
NationMsg(_GET_INSERT_OFF)) )
SETPOS( nRow, nCol )
endif

RETURN
