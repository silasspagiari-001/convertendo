#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)

#include "common.ch"
#include "inkey.ch"
#include "set.ch"
#include "Getexit.ch"
#include "hbgtinfo.ch"


******************
function GETRECORD(Arg1)
******************

   local Local1, Local2, Local3
   Local1:= {}
   if (!Empty(alias()))
      Local2:= RecNo()
      Arg1:= iif(ValType(Arg1) == ValType(0) .AND. Arg1 != Nil, ;
         Arg1, 0)
      if (Arg1 <= LastRec())
         goto Arg1
         Local1:= array(FCount())
         for Local3:= 1 to FCount()
            Local1[Local3]:= fieldget(Local3)
         next
      endif
      goto Local2
   endif
   return Local1

******************
function PUTRECORD(Arg1, Arg2)
******************

   local Local1, Local2, Local3
   Local1:= RecNo()
   Local3:= .F.

   if (ValType(Arg1) = "A")
      Arg2:= iif(ValType(Arg2) == ValType(0) .AND. Arg2 != Nil, ;
         Arg2, 0)
      if (Arg2 == 0)
         if (!Empty(alias()))
            Local3:= .T.
            append blank
         endif
      elseif (Arg2 <= LastRec() .AND. !Empty(alias()))
         Local3:= .T.
         goto Arg2
      endif
      if (Local3)
         for Local2:= 1 to Len(Arg1)
            if (Local2 > FCount())
               Local3:= .F.
               exit
            elseif (fieldput(Local2, Arg1[Local2]) != Arg1[Local2])
               Local3:= .F.
               exit
            endif
         next
      endif
*      if (!Empty(alias()))
*         goto Local1
*      endif
   endif
   return Local3

****************
function LASTDAY(Arg1)
****************

   Arg1:= iif(ValType(Arg1) == ValType(Date()) .AND. Arg1 != Nil, ;
      Arg1, Date())
   return (Arg1:= Arg1 + (45 - Day(Arg1))) - Day(Arg1)

*******************
FUNCTION SEATUALIZA
*******************

return .t.

    if !alltrim(netname()) $ "#SERVIDOR#SILASNITRO#"
      nAtua:= directory("F:\tmp\cirursql.EXE")
      nLoca:= directory("C:\CIRUR\cirursql.EXE")

      if nAtua[1][2] # nLoca[1][2] .or. nAtua[1][3] # nLoca[1][3] .or. nAtua[1][4] # nLoca[1][4]
        clear
        alert2("* * * FAVOR ATUALIZAR O SISTEMA * * *")
        clear
        quit
      endif
    endif

return ""

********************
Function RANDOMIZE()
Local nDat := 0   // Retorna Valor Data. Exemplo: "20090720" p/ Data = 20/07/2009
Local nHor := 0   // Retorna Valor Hora. Exemplo: "103717" p/ Hora = 10:37:17
Local nSec := 0   // Retorna segundos decorridos desde a meia noite = 0 a 86399.
Local nRet := 0   // Este sera o numero randomico que retornaremos. Por enquanto eh zero.

nDat := val( dtos( date() ) )
nHor := val( substr(time(),1,2) + substr(time(),4,2) + substr(time(),7,2) )
nSec := seconds()

// Vamos gerar o numero agora. Multiplicamos os tres valores...
nRet := nDat * nHor * nSec    // Esse ja eh um numero Randomico.
// Vamos embaralhar ainda mais...
* nRet := nRet * sqrt( nRet )   // Multiplicamos o valor pela sua propria raiz quadrada.
nRet := int( nRet )    // Tiramos os possiveis decimais. Retonamos somente valor inteiro.
// Agora sim... temos um valor randomico inteiro.

return nRet

function FREADLINE(Arg1, Arg2)

   local Local1, Local2, Local3, Local4, Local5

   Local1:= 4096
   Local2:= ""
   Arg2:= iif(ValType(Arg2) == ValType(.F.) .AND. Arg2 != Nil, Arg2, ;
      .F.)
   Arg1:= iif(ValType(Arg1) == ValType(0) .AND. Arg1 != Nil, Arg1, 0)
   if (Arg1 > 4)
      Local3:= Space(Local1)
      Local5:= fread(Arg1, @Local3, Local1)
      fseek(Arg1, -Local5, 1)
      Local4:= iif(Empty(Local4:= At(Chr(13) + Chr(10), Local3)), ;
         Local1, Local4 - 1)
      if (Empty(Local4))
         if (Chr(13) + Chr(10) == Left(Local3, 2))
            fseek(Arg1, Local4 + 2, 1)
            Local3:= ""
            Local4:= 1
         else
            fseek(Arg1, Local5, 1)
         endif
      else
         fseek(Arg1, Local4 + 2, 1)
      endif
      Local2:= Left(Local3, Local4)
      if (Arg2)
         fseek(Arg1, -(Len(Local2) + 2), 1)
      endif
   endif
   if Local5 = 0
     feof = .t.
   endif

   return iif(Len(Local2) == Local1, "", Local2)



*****************
function FIRSTDAY(Arg1)
*****************

   Arg1:= iif(ValType(Arg1) == ValType(Date()) .AND. Arg1 != Nil, ;
      Arg1, Date())
   return Arg1 - (Day(Arg1) - 1)


*********************
function ISDBF(Arg1)

   local Local1, Local2, Local3
   Local2:= .F.
   Local3:= Space(1)
   if (file(Arg1) .AND. (Local1:= fopen(Arg1)) > 4)
      fread(Local1, @Local3, 1)
      Local2:= bin2i(Local3) == 3 .OR. bin2i(Local3) == 131
      fclose(Local1)
   endif
   return Local2

********************************
function MENUROWCOL(Arg1, Arg2, Arg3, Arg4)

   local Local1
   Arg4:= iif(ValType(Arg4) == ValType(1) .AND. Arg4 != Nil, Arg4, 1)
   Arg2:= iif(ValType(Arg2) == ValType(Row()) .AND. Arg2 != Nil, ;
      Arg2, Row())
   Arg3:= iif(ValType(Arg3) == ValType(Col()) .AND. Arg3 != Nil, ;
      Arg3, Col())
   if (ValType(Arg1) = "A")
      for Local1:= 1 to Len(Arg1)
         Arg1[Local1][1]:= Arg2
         Arg1[Local1][2]:= Arg3
         Arg2:= Arg2 + Arg4
      next
   endif
   return Nil

********************************
function MENUPADR(Arg1, Arg2, Arg3)

   local Local1
   Arg3:= iif(ValType(Arg3) == ValType(" ") .AND. Arg3 != Nil, Arg3, ;
      " ")
   Arg2:= iif(ValType(Arg2) == ValType(1) .AND. Arg2 != Nil, Arg2, 1)
   if (ValType(Arg1) = "A")
      for Local1:= 1 to Len(Arg1)
         Arg1[Local1][3]:= padr(Arg1[Local1][3], Arg2, Arg3)
      next
   endif
   return Nil

       **********************
function ACOLOR(Arg1)

   local Local1, Local2, Local3, Local4
   Local1:= {}
   Local2:= ""
   Arg1:= iif(ValType(Arg1) == ValType(SetColor()) .AND. Arg1 != ;
      Nil, Arg1, SetColor())
   for Local4:= 1 to 5
      Local3:= At(",", Arg1)
      Local2:= Left(Arg1, Local3 - 1)
      Arg1:= SubStr(Arg1, Local3 + 1)
      if (Local4 == 5 .AND. Empty(Local2))
         AAdd(Local1, Local1[2])
      else
         AAdd(Local1, Local2)
      endif
      Local2:= ""
   next
   return Local1




*******************
function executasql
*******************

local ABC


*cArqant = select()

if type("sqlRETOR") == "U"
  sqlRETOR = ""
endif

if type("sqlORDEM") == "U"
  sqlORDEM = {}
endif

cSQL = ""


try


do case
case sqlARQUI[2] == "UPDATE OR INSERT"

  cSQL = "update or insert into " + sqlARQUI[1] + " ("

   for ABC = 1 to len(sqlCAMPO)
     cSQL += sqlCAMPO[ABC][1]
     if ABC < len(sqlCAMPO)
       cSQL += ","
     endif
   next

   cSQL += ") VALUES ("

   for ABC = 1 to len(sqlCAMPO)
     if sqlCAMPO[ABC][2] == "NULL"
       cSQL += sqlCAMPO[ABC][2]
     else
       cSQL += + "'" + sqlCAMPO[ABC][2] + "'"
     endif

     if ABC < len(sqlCAMPO)
       cSQL += ","
     endif
   next
   cSQL += ") matching ( "

  for ABC = 1 to len(sqlCHAVE)
    cSQL += sqlCHAVE[ABC][1]
    if ABC < len(sqlCHAVE)
      cSQL += ","
    endif
  next

  cSQL += " )"

case sqlARQUI[2] == "UPDATE"
  cSQL = "update " + sqlARQUI[1] + " set "

  for ABC = 1 to len(sqlCAMPO)

    if sqlCAMPO[ABC][1] == "CONDICAO"
      cSQL += sqlCAMPO[ABC][2]
    else
      if ValType(sqlCAMPO[ABC][2]) == ValType(" ") .and. sqlCAMPO[ABC][2] == "NULL"
        cSQL += sqlCAMPO[ABC][1]  + " = " + sqlCAMPO[ABC][2]  // sem aspas
      else
        if sqlCAMPO[ABC][3]
          cSQL += sqlCAMPO[ABC][1]  + " = '" + sqlCAMPO[ABC][2] + "'"
        else
          cSQL += sqlCAMPO[ABC][1]  + " = " + sqlCAMPO[ABC][2]
        endif
      endif
    endif

    if ABC < len(sqlCAMPO)
      cSQL += ","
    endif
  next

  cSQL += " where "

  for ABC = 1 to len(sqlCHAVE)
    if sqlCHAVE[ABC][1] == "CONDICAO"
      cSQL += sqlCHAVE[ABC][2]
    else
      cSQL += sqlCHAVE[ABC][1]  + " = " + sqlCHAVE[ABC][2]
      if ABC < len(sqlCHAVE)
        cSQL += " and "
      endif
    endif
  next

case sqlARQUI[2] == "INSERT"

     cSql := "INSERT INTO " + sqlARQUI[1] + " ("
     for ABC = 1 to len(sqlCAMPO)
       cSQL += sqlCAMPO[ABC][1]
       if ABC < len(sqlCAMPO)
         cSQL += ","
       endif
     next

     cSQL += ") VALUES ("

     for ABC = 1 to len(sqlCAMPO)
       if sqlCAMPO[ABC][2] == "NULL"
         cSQL += sqlCAMPO[ABC][2]
       else
         cSQL += + "'" + sqlCAMPO[ABC][2] + "'"
       endif

       if ABC < len(sqlCAMPO)
         cSQL += ","
       endif
     next
     cSQL += ")"

case sqlARQUI[2] == "DELETE"
       cSQL = "DELETE FROM " + sqlARQUI[1] + " where "

       for ABC = 1 to len(sqlCHAVE)
         cSQL += sqlCHAVE[ABC][1]  + " = " + sqlCHAVE[ABC][2]
         if ABC < len(sqlCHAVE)
           cSQL += " and "
         endif
       next

case sqlARQUI[2] == "SELECT"

      cSQL = "SELECT "

      if len(sqlCAMPO) > 0
        for ABC = 1 to len(sqlCAMPO)
          cSQL += sqlCAMPO[ABC][1]
          if ABC < len(sqlCAMPO)
            cSQL += ","
          endif
        next
        cSQL += " FROM " + sqlARQUI[1] + " where "
      else
        cSQL += "* FROM " + sqlARQUI[1]
      endif

      if len(sqlCHAVE) > 0
        cSQL += " where "
      endif

      for ABC = 1 to len(sqlCHAVE)
        if "LIKE" $ sqlCHAVE[ABC][2]
          cSQL += sqlCHAVE[ABC][1] + " " + sqlCHAVE[ABC][2]
        else
           if sqlCHAVE[ABC][1] == "CONDICAO"
             cSQL += sqlCHAVE[ABC][2]
           else
             cSQL += sqlCHAVE[ABC][1]  + " = " + sqlCHAVE[ABC][2]

             if sqlCHAVE[len(sqlCHAVE)][1] == "CONDICAO"
               if ABC < len(sqlCHAVE)-1
                 cSQL += " and "
               endif
             else
               if ABC < len(sqlCHAVE) .and. !sqlCHAVE[len(sqlCHAVE)][1] == "CONDICAO"
                 cSQL += " and "
               endif
             endif
           endif
        endif
      next

      if len(sqlORDEM) > 0
        cSQL += " order by "
      endif

      for ABC = 1 to len(sqlORDEM)
        cSQL += sqlORDEM[ABC]
        if ABC < len(sqlORDEM)
          cSQL += ", "
        endif
      next

endcase
catch oErro

  nHan := FCreate("Errosql.txt")   // a tentar CRIAR.
  FWrite( nHan, cSQL )
  FClose( nHan )   // Fechamos o Arquivo.

  msgbox1( { "Ocorreu um Erro.", "", ;
	               "Erro: " + oErro:subsystem + "/" + LTrim(Str(oErro:subcode)),  ;
	               "Descrição: " + LTrim(Str(oErro:genCode))  + " " + oErro:description, ;
	               "Operação: " + oErro:operation, ;
	               "Veja em Errosql.txt"    } ;
	            )

  return .f.
end


nHan := FCreate("sqlA.txt")   // a tentar CRIAR.
FWrite( nHan, cSQL )
FClose( nHan )   // Fechamos o Arquivo.

nMotivoSQL = ""

if !sqlARQUI[2] == "SELECT"   // QUANDO SELECT dbusearea(lJAEXISTE,,cSQL,"ANFS00")
  if !empty(sqlRETOR)
    cSQL += " " + sqlRETOR
  endif
  sqlRETOR = ""


*  seexiste("NOVOID")
*  if dbuseareasql(.T.,"SQLMIX",cSQL,"NOVOID")
*    select &cArqant
 *   return .t.
 * else
 *   select &cArqant
 *   return .f.
 * endif

 ALTD()
  trans := FBStartTransaction( db )
  ncod := FBExecute( db,cSQL,, trans )

  if nCod < 0
    nHan := FCreate("RELATO.RPT")   // a tentar CRIAR.
    FWrite( nHan, FBError(ncod) )
    FWrite( nHan, cSQL )
    FClose( nHan )   // Fechamos o Arquivo.
    if "duplicate column" $ FBError(ncod)
      nMotivoSQL = "DUPLICADO"
      FBROLLBACK(trans)
      EDITREL()
      return .f.
    endif
    FBROLLBACK(trans)
    EDITREL()
    return .f.
  endif
  FBCommit( trans )
else
  if len(sqlARQUI) = 3
    seexistesql(sqlARQUI[3])
    dbusearea(.t.,"SQLMIX",cSQL,sqlARQUI[3])
    if lastrec() = 0
      return .f.
    endif
  else
    seexistesql(sqlARQUI[1])
    dbusearea(.t.,"SQLMIX",cSQL,sqlARQUI[1])
    if lastrec() = 0
      return .f.
    endif
  endif
endif


return .t.

**************
function ASPAS(fVALOR)
**************

return "'" + fVALOR + "'"

**************
function ASPASDUPLAS(fVALOR)
**************

return '"' + fVALOR + '"'

***************
function FORMATDTA(F_DTA,F_MUDA)
*****************

if F_MUDA = NIL
  F_MUDA = .t.
endif

if !F_MUDA
  if F_DTA = NIL
    return ctod("  /  /  ")
  endif
  return F_DTA
endif

if F_DTA = NIL .or. empty(F_DTA)
  return "NULL"
endif

return strzero(month(F_DTA),2) + "/" + strzero(day(F_DTA),2) + "/" + str(year(F_DTA),4)

*************
function STR1(F_OQUE,F_DEC)
*************
if F_DEC > 0
  return alltrim(strtran(str(F_OQUE,15,F_DEC),",","."))
else
  return alltrim(strtran(str(F_OQUE),",","."))
endif

*************************
function INICIO_IMPRESSAO
*************************

oPrinter:Landscape := .F.

IF ! oPrinter:Create()
  Alert( "Nao foi possivel iniciar a impressao" )
  return .f.
ELSE
  IF !oPrinter:startDoc( "Impressao" )
    Alert( "Falha no inicio da impressao" )
  endif
endif

oPrinter:UnderLine( .F. )
oPrinter:Italic( .F. )

oPrinter:leftMargin  := oPrinter:mm_To_PosX(9) //9 Milimetros
oPrinter:TextOut("")
oPrinter:NewLine()
oPrinter:SetFont( "Courier New", 11.5,0)  // normal

return ""

function nAfterInkey(nkey)
* check if nkey is:
* (1) menu command, or
* (2) mouse button action
local bAction


// alert(nkey)

  if nkey==1024  // 9999 // WVW_DEFAULT_MENUKEYEVENT
     * MenuKeyEvent
*     return nMenuChecker(WVW_GETLASTMENUEVENT())
  //was: elseif ASCAN({K_LBUTTONDOWN, K_LBUTTONUP, K_MOUSEMOVE}, nKey) > 0
  elseif ASCAN({K_LBUTTONDOWN, K_LBUTTONUP, K_MOUSEMOVE, K_MMLEFTDOWN,;
                K_LDBLCLK}, nKey) > 0
     * MouseEvent
*     return wvwm_nMouseChecker(nkey)
  elseif (bAction := SETKEY(nKey)) != NIL
     eval(bAction, PROCNAME(), PROCLINE(), READVAR())
     return 0
  endif
return nkey //nAfterInkey(nkey)

****************
function PROTEGEA
****************

private M_TELA ,M_TELA1,;
M_TECLA,R,C,T,M_CURSOR

*cTelaIMGp := savescreen(0, 0, 24, 80 )  // salva a tela

*wvw_DrawImage(,2, 4, 22, 76, "c:\RACA\logo.jpg",,.f.)

*inkey(0)

M_CURSOR = setcursor()
M_CORES  = setcolor ()

*wvw_SetFont(0,'Consolas',_FONTET_,_FONTEL_,200,1)

*set color to N

*clear screen

set cursor off

do while .t.

*wvw_DrawImage(,2, 0, 22, 80, "&_PATH_\" + alltrim(aemp00->emptex) + ".jpg",,.f.)

  for R = 2 to 22
    for S = 0 to 80
 *     wvw_DrawColorRect(,R, S, R, S,{R, S, R, S},RGB(245,245,245))
      for T = 1 to 800
        M_TECLA = inkey()
        if M_TECLA > 0
          set color to &M_CORES
          iif(M_CURSOR=1,setcursor(1),setcursor(0))
          set color to &M_CORES
          return .f.
        endif
      next
    next
  next


/*
  for R = 2 to 22
    for S = 0 to 80
      @ R, S say " "
      for T = 1 to 600
        M_TECLA = inkey()
        if M_TECLA > 0
          set color to &M_CORES
          iif(M_CURSOR=1,setcursor(1),setcursor(0))
          set color to &M_CORES
            do while .t.
              if senha()
                exit
              endif
            enddo
          return .f.
        endif
      next
    next
  next

*/
  
*wvw_DrawImage(,2, 0, 22, 80, "&_PATH_\" + alltrim(aemp00->emptex) + ".jpg",,.f.)

  inkey(.3)

  for R = 22 to 2 step -1
    for S = 0 to 80
*      wvw_DrawColorRect(,R, S, R, S,{R, S, R, S},RGB(245,245,245))
      for T = 1 to 800
        M_TECLA = inkey()
        if M_TECLA > 0
          set color to &M_CORES
          iif(M_CURSOR=1,setcursor(1),setcursor(0))
          return .f.
        endif
      next
    next
  next

*wvw_DrawImage(,2, 0, 22, 80, "&_PATH_\" + alltrim(aemp00->emptex) + ".jpg",,.f.)

  inkey(.3)
  for S = 0 to 80
    for R = 2 to 22
*      wvw_DrawColorRect(,R, S, R, S,{R, S, R, S},RGB(245,245,245))
      for T = 1 to 800
        M_TECLA = inkey()
        if M_TECLA > 0
          set color to &M_CORES
          iif(M_CURSOR=1,setcursor(1),setcursor(0))
          return .f.
        endif
      next
    next
  next


*wvw_DrawImage(,2, 0, 22, 80, "&_PATH_\" + alltrim(aemp00->emptex) + ".jpg",,.f.)

  inkey(.3)
  for S = 80 to 0 step -1
    for R = 2 to 22
*      wvw_DrawColorRect(,R, S, R, S,{R, S, R, S},RGB(245,245,245))
      for T = 1 to 800
        M_TECLA = inkey()
        if M_TECLA > 0
          set color to &M_CORES
          iif(M_CURSOR=1,setcursor(1),setcursor(0))
          return .f.
        endif
      next
    next
  next

enddo

*wvw_SetFont(0,alltrim(_FONTEN_),_FONTET_,_FONTEL_,200,1)
*RestScreen(0, 0, 24, 80, cTelaIMGp )  // restaura a tela

return .f.

*****************
function SEEXISTE2(ARQUIVO)
*****************

local A

if ARQUIVO = NIL
  return ""
endif

A = select(ARQUIVO)

if A > 0
  select &ARQUIVO
  return .f.
endif

return .t.


********************
function GETPASSWORD(oGet)
********************

local nKey,nChar,cKey

M_CURSOR = setcursor()
set cursor on

if (GetPrevalidate(oGet))
oGet:SetFocus()
oGet:cargo:=""
do while(oGet:exitState==GE_NOEXIT)
if(oget:typeOut)
oGet:exitState:=GE_ENTER
endif
do while(oGet:exitState==GE_NOEXIT)
nKey:=inkey(0)
if nkey>=32.and.nkey<=255
oGet:cargo+=chr(nkey)
getApplykey(oGet,Asc("þ"))
elseif nkey==K_BS
oGet:cargo:=substr(oGet:cargo,1,len(oGet:cargo)-1)
GetApplykey(oGet,nKey)
elseif nkey==K_ENTER
GetApplykey(oGet,nKey)
elseif nkey==K_ESC
oGet:exitState:=GE_ENTER
exit
endif
enddo

if nkey==K_ESC
exit
endif

if(!GetPostValidate(oGet))
oGet:exitState:=GE_NOEXIT
endif
enddo
oget:KillFocus()
endif

if oGet:exitState!=GE_ESCAPE
oGet:varPut(oGet:cargo)
endif

setcursor(M_CURSOR)

return""

function MAY_INKEY(F_TEMPO,F_TIPO)

local nTecla

if F_TIPO = NIL
  if F_TEMPO = NIL
    nTecla = inkey()
  else
    nTecla = inkey(F_TEMPO)
  endif
else
  nTecla = lastkey()
endif

if ( nTecla== K_CTRL_T .or.  nTecla== K_ALT_T)
  do while .t.

    if nEscal = 3
      return 0
    endif

  enddo

endif

return nTecla

return ""

***************
function FORDTA(F_DTA)
*****************

return str(year(F_DTA),4) + "-" + strzero(month(F_DTA),2) + "-" + strzero(day(F_DTA),2)


********************
function SQLRELATION
********************

local ABC
local cSQL
local nHan

cSQL = ""

cSQL = "SELECT "

for ABC = 1 to len(sqlCAMPO)
  cSQL += sqlCAMPO[ABC]

  if ABC < len(sqlCAMPO)
    cSQL += ","
  endif
next

cSQL += " FROM " + sqlARQUI[1][1]

for ABC = 1 to len(sqlRELATION)
  if !empty(sqlRELATION[ABC][1])
    cSQL += " left outer join " + sqlRELATION[ABC][1] + " ON "
    cSQL += sqlRELATION[ABC][2] + " = " + sqlRELATION[ABC][3]
  else
    cSQL += " and " + sqlRELATION[ABC][2] + " = " + sqlRELATION[ABC][3]
  endif
next

if len(sqlCHAVE) > 0
  cSQL += " where "
  for ABC = 1 to len(sqlCHAVE)
    cSQL += sqlCHAVE[ABC]
    if ABC < len(sqlCHAVE)
      cSQL += " and "
    endif
  next
endif

if len(sqlORDEM) > 0
  cSQL += " order by " + sqlORDEM[1]
endif

nHan := FCreate("sql.txt")   // a tentar CRIAR.
FWrite( nHan, cSQL )
FClose( nHan )   // Fechamos o Arquivo.

try
  if HB_ISNIL(sqlARQUI[1][2])
    seexistesql(sqlARQUI[1][1])
    dbusearea(.t.,"SQLMIX",cSQL,sqlARQUI[1][1])
  else
    seexistesql(sqlARQUI[1][2])
    dbusearea(.t.,"SQLMIX",cSQL,sqlARQUI[1][2])
  endif
catch oErro
  ALERT(oErro:description)
  return .f.
end

sqlRELATION = {}
sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {}
sqlORDEM = {}

if !eof()
  return .t.
else
  return .f.
endif

*****************
function SEABERTO
*****************

local A
parame F_ABREARQUIVO

if select(F_ABREARQUIVO) > 0
  return .t.
endif


return .f.

*****************
function CRIA_DBF(fARQUIVO)
*****************

aStruct1 := dbStruct()     // pega a estrutura atual
DbCreate(fARQUIVO, aStruct1, "DBFCDX" )

return ""


