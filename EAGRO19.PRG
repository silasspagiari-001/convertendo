#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)
#INCLUDE "ptmenu.ch"

***************
function MANNCM
***************
parameters M_OPC,M_OPC1,M_OPC2

local aBlocks := {}
local aLastPaint

aAdd( aBlocks, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
aLastPaint := WvtSetBlocks( aBlocks )

  rodape("MENU","CLAS FISCAL",M_FAN,"EAGRO19","Mem: " + str(memory(0), 5),M_EMP)

*  @ 05, 10 prompt " Inclus?o  " HIGHLITE GR+/BG SENHA 67
*  @ 06, 10 prompt " Altera??o " HIGHLITE GR+/BG SENHA 68
*  @ 07, 10 prompt " Consulta  " HIGHLITE GR+/BG SENHA 69
*  @ 08, 10 prompt " Exclus?o  " HIGHLITE GR+/BG SENHA 70
*  @ 09, 10 prompt " Listagem  " HIGHLITE GR+/BG SENHA 71
*  @ 10, 10 prompt " Outros    " HIGHLITE GR+/BG SENHA 72

    do case
    case M_OPC = 1 ; incncm()
    case M_OPC = 2 ; altncm()
    case M_OPC = 3 ; conncm()
    case M_OPC = 4 ; excncm()
    case M_OPC = 5 ; lisncm()
    endcase


return ""

***************
function INCNCM
***************

do while .t.

  M_NCMCOD  = space(8)
  M_NCMNOM01 = space(48)
  M_NCMNOM02 = space(60)
  M_NCMNOM03 = space(60)
  M_NCMNOM04 = space(60)
  M_NCMNOM05 = space(60)
  M_NCMNOM06 = space(60)
  M_NCMNOM07 = space(60)

  M_ALIQZERO = " "
  M_SUBSTRIB = " "
  M_PERPIS = 0
  M_PERCOF = 0
  M_ALIQNAC = 0
  M_ALIQIMP = 0
  M_NCMCODALI = 0
  M_NCMCODSUB = 0
  M_NCMCST = "  "
  M_ALIQINT = 0

  moncm01()

  rodape("INCLUI","CLAS FISCAL",M_FAN,"EAGRO19","Mem: " + str(memory(0), 5),M_EMP)

  SetColor(_COREDICAO_)
  @ 07, 23 get     M_NCMCOD   picture "@R 9999.99.99"
  read

  if M_NCMCOD = space(8) .or. lastkey()=27
    exit
  endif

  if BUSCAREGISTRO("ANCM00",1,{aspas(M_NCMCOD)},"SELECT")
    msg("* * * CODIGO NCM JA CADASTRADO * * *")
    loop
  endif

  edncm01()                      && edita dados da fisresa

  if lastkey() = 27
    msg("* * * CODIGO NCM N?O INCLUIDO * * *")
    loop
  endif

  grncm01("INSERT")

  msg("* * * CODIGO NCM INCLUIDO * * *")

enddo

return ""

***************
function ALTNCM
***************

do while .t.

  M_NCMCOD = space(8)

  moncm01()

  rodape("ALTERA","CLAS FISCAL",M_FAN,"EAGRO19","Mem: " + str(memory(0), 5),M_EMP)

  SetColor(_COREDICAO_)
  @ 07, 23 get     M_NCMCOD   picture "@R 9999.99.99"
  read

  if M_NCMCOD = space(8) .or. lastkey()=27
    exit
  endif

  if !BUSCAREGISTRO("ANCM00",1,{aspas(M_NCMCOD)},"SELECT")
    msg("* * * CODIGO NCM N?O CADASTRADO * * *")
    loop
  endif

  msncm01()

  M_NCMNOM01 = NCMNOM01
  M_NCMNOM02 = NCMNOM02
  M_NCMNOM03 = NCMNOM03
  M_NCMNOM04 = NCMNOM04
  M_NCMNOM05 = NCMNOM05
  M_NCMNOM06 = NCMNOM06
  M_NCMNOM07 = NCMNOM07

  M_ALIQINT = ALIQINT
  M_ALIQZERO = ALIQZERO
  M_SUBSTRIB = SUBSTRIB
  M_PERPIS   = PERPIS
  M_PERCOF   = PERCOF
  M_ALIQNAC   = ALIQNAC
  M_ALIQIMP   = ALIQIMP
  M_NCMCODALI = NCMCODALI
  M_NCMCODSUB = NCMCODSUB
  M_NCMCST = NCMCST

  edncm01()

  if lastkey() = 27
    msg("* * * CODIGO NCM N?O ALTERADO * * *")
    loop
  endif

  grncm01("UPDATE")

  msg("* * * CODIGO NCM ALTERADO * * *")

enddo

return ""

***************
function CONNCM
***************

do while .t.

  M_NCMCOD = space(8)
  M_NCMNOM01 = space(48)

  moncm01()

  rodape("CONSULTA","CLAS FISCAL",M_FAN,"EAGRO19","Mem: " + str(memory(0), 5),M_EMP)

  SetColor(_COREDICAO_)
  @ 07, 23 get     M_NCMCOD   picture "@R 9999.99.99"
  read

  if lastkey() = 27
    exit
  endif

  BUSCAREGISTRO("ANCM00",1,{aspas(M_NCMCOD)},"SELECT")
  if eof()
    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"ANCM00","ANCM00"})
    aadd(sqlCAMPO,"ANCM00.*")
    aadd(sqlCHAVE,"NCMCOD >= " + aspas(left(M_NCMCOD,4) + "0000"))
    sqlrelation()

  endif

  setas()

  do while .t.

    msncm01()

    waitstate()

    if lastkey() = 5
      skip - 1
    endif

    if lastkey() = 24
      skip + 1
    endif

    if eof()
      go top
    endif

    if bof()
      go bottom
    endif

    if lastkey() = 27
      exit
    endif

  enddo

  set cursor on

enddo

return ""

***************
function EXCNCM
***************

private M_OPC

do while .t.

  M_NCMCOD = space(8)

  moncm01()

  rodape("EXCLUI","CLAS FISCAL",M_FAN,"EAGRO19","Mem: " + str(memory(0), 5),M_EMP)

  SetColor(_COREDICAO_)
  @ 07, 23 get     M_NCMCOD   picture "@R 9999.99.99"
  read

  if M_NCMCOD = space(8) .or. lastkey()=27
    exit
  endif

  select ANCM00

  if !dbseek(M_NCMCOD)
    msg("* * * CODIGO NCM N?O CADASTRADO * * *")
    loop
  endif

  msncm01()

  if !rlock()
    msg("* * * (ANCM00) REGISTRO SENDO USADO * * *")
    loop
  endif

  M_OPC = confirma("desta Clas Fiscal")

  if M_OPC # 1
    msg("* * * CLAS FISCAL N?O EXCLUIDA * * *")
    unlock
    loop
  endif

  elimina()

  msg("* * * CLAS FISCAL EXCLUIDA * * *")

enddo

return ""

***************
function LISNCM
***************

private M_TELA

do while .t.

  rodape("LISTA","CLAS FISCAL",M_FAN,"EAGRO19","Mem: " + str(memory(0), 5),M_EMP)

  store 0        to M_NCM1,;
  M_NCM2

  sombra(10, 15, 13, 35,_SOMBRA_)

  set color to GR+/W
  @ 10, 15 say "????????????????????"
  @ 11, 15 say "?Grupo Inicial:     ?"
  @ 12, 15 say "?      Final:       ?"
  @ 13, 15 say "?????????????????????"
  @ 11, 31 get M_NCM1 picture "####"
  @ 12, 31 get M_NCM2 picture "####"
  read
  set color to

  if lastkey() = 27
    return ""
  endif

  M_NCM1 = iif(M_NCM1 = 0,    1,M_NCM1)
  M_NCM2 = iif(M_NCM2 = 0,9999,M_NCM2)

  select ANCM00

  go top

  dbseek(str(M_NCM1, 4),.t.)

  if left(NCMCOD,4) > str(M_NCM2,4)
    msg("* * * NADA A LISTAR NO INTERVALO * * *")
    loop
  endif

  M_ARQI = "RELATO.RPT"
  M_IMPRE = impresn()

  if M_IMPRE = "N"
    return ""
  endif

  store 0 to PG

  do while !eof()

    store PG + 1 to PG

    if PG > 1
      ?
      eject
    endif

    ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE CODIGOS NCM","EAGRO19",80)
    ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 80)
    ? "*----------*--------------------------------------*------*------*-----*------*"
    ? "*  CODIGO  * DESCRICAO                            * %PIS * %COF *ALIQ0*SUBTRI*"
    ? "*----------*--------------------------------------*------*------*-----*------*"

    store 5 to LN

    do while !eof() .and. LN < 60

      ? " "

      if  val(left(NCMCOD,4)) > M_NCM2
        go bottom
        skip
        loop
      endif

      ?? transform(NCMCOD,"@R 9999.99.99")
      ?? " "
      ?? left(NCMNOM01, 38)
      ?? " "
      ?? PERPIS
      ?? " "
      ?? PERCOF
      ?? "  "
      ?? iif(ALIQZERO=="S","Sim"," - ")
      ?? "    "
      ?? iif(SUBSTRIB=="S","Sim"," - ")

      skip

      LN ++

      if lastkey() = 27
        if susimp()
          ? replicate("-", 132)
          ? "* * * IMPRESSAO SUSPENSA * * *"
          go bottom
          skip
        endif
      endif

    enddo

  enddo

  ? replicate("-", 80)

  if M_IMPRE == "L" // laser ou hp
    desliga1(80)
  else
    ?? chr(18)                        && comprime
    eject
    desliga1()
  endif

enddo

return ""

****************
function MONCM01
****************

nbox(06, 10, 20, 71,"W/W+",.t.)
setcolor("B/W")

@ 07, 11 say "Codigo    :                                                 "
@ 08, 11 say "Descricao :                                                 "
@ 09, 11 say "                                                            "
@ 10, 11 say "CST. 01 Oper. Trib. Aliquota Basica                         "
@ 11, 11 say "CST. 02 Oper. Trib. Aliquota Diferenciada                   "
@ 12, 11 say "CST. 03 Oper. Trib. Aliquota por Unidade de Medida          "
@ 13, 11 say "CST. 04 Oper. Trib. Monofasica - Revenda a Aliquota Zero    "
@ 14, 11 say "CST. 05 Oper. Trib. por Substituicao Tributaria             "
@ 15, 11 say "CST. 06 Oper. Trib. a Aliquota Zero                         "
@ 16, 11 say "CST:    Codigo Aliq Zero :         Cod Sub Trib :           "
@ 17, 11 say "                    % Pis:              % Cofins:           "
@ 18, 11 say "        Imposto Nacinao %:         Extrangeiro %:           "
@ 19, 11 say "        Aliquota Interna%:                                  "
set color to

return ""

****************
function EDNCM01
****************

SetColor(_COREDICAO_)
@ 08, 23 get M_NCMNOM01
@ 09, 11 get M_NCMNOM02

@ 16, 16 get M_NCMCST picture "@!" valid strzero(val(M_NCMCST),2) $ "#01#02#03#04#05#06#"
@ 16, 38 get M_NCMCODALI picture "999"
@ 16, 61 get M_NCMCODSUB picture "999"
@ 17, 38 get M_PERPIS   picture "@R 999.99"
@ 17, 61 get M_PERCOF   picture "@R 999.99"
@ 18, 38 get M_ALIQNAC   picture "@R 999.99"
@ 18, 61 get M_ALIQIMP   picture "@R 999.99"
@ 19, 38 get M_ALIQINT  picture "@R 999.99"
read

return ""

****************
function MSNCM01
****************

setcolor("N/W*")
@ 07, 23 say     NCMCOD   picture "@R 9999.99.99"
@ 08, 23 say     NCMNOM01
@ 09, 11 say     NCMNOM02

@ 16, 16 say     NCMCST
@ 16, 38 say     NCMCODALI picture "999"
@ 16, 61 say     NCMCODSUB picture "999"

@ 17, 38 say     PERPIS   picture "@R 999.99"
@ 17, 61 say     PERCOF   picture "@R 999.99"
@ 18, 38 say     ALIQNAC   picture "@R 999.99"
@ 18, 61 say     ALIQIMP   picture "@R 999.99"

@ 19, 38 say     ALIQINT  picture "@R 999.99"

setcolor("B/W")
@ 10, 10 say " CST. 01 Oper. Trib. Aliquota Basica                         "
@ 11, 10 say " CST. 02 Oper. Trib. Aliquota Diferenciada                   "
@ 12, 10 say " CST. 03 Oper. Trib. Aliquota por Unidade de Medida          "
@ 13, 10 say " CST. 04 Oper. Trib. Monofasica - Revenda a Aliquota Zero    "
@ 14, 10 say " CST. 05 Oper. Trib. por Substituicao Tributaria             "
@ 15, 10 say " CST. 06 Oper. Trib. a Aliquota Zero                         "

setcolor("G/W")
do case
  case NCMCST == "01"
    @ 10, 10 say " CST. 01 Oper. Trib. Aliquota Basica                         "
  case NCMCST == "02"
    @ 11, 10 say " CST. 02 Oper. Trib. Aliquota Diferenciada                   "
  case NCMCST == "03"
    @ 12, 10 say " CST. 03 Oper. Trib. Aliquota por Unidade de Medida          "
  case NCMCST == "04"
    @ 13, 10 say " CST. 04 Oper. Trib. Monofasica - Revenda a Aliquota Zero    "
  case NCMCST == "05"
    @ 14, 10 say " CST. 05 Oper. Trib. por Substituicao Tributaria             "
  case NCMCST == "06"
    @ 15, 10 say " CST. 06 Oper. Trib. a Aliquota Zero                         "
endcase

set color to

return ""

****************
function GRNCM01(cACAO)
****************

sqlORDEM = {}
sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"ANCM00",cACAO}

aadd(sqlCHAVE,{"NCMCOD",aspas(M_NCMCOD)})

if !cACAO $ "#DELETE#SELECT#"
  aadd(sqlCAMPO,{"NCMCOD",M_NCMCOD,.t.})
  aadd(sqlCAMPO,{"NCMNOM01",M_NCMNOM01,.t.})
  aadd(sqlCAMPO,{"NCMNOM02",M_NCMNOM02,.t.})
  aadd(sqlCAMPO,{"NCMNOM03",M_NCMNOM03,.t.})
  aadd(sqlCAMPO,{"NCMNOM04",M_NCMNOM04,.t.})
  aadd(sqlCAMPO,{"NCMNOM05",M_NCMNOM05,.t.})
  aadd(sqlCAMPO,{"NCMNOM06",M_NCMNOM06,.t.})
  aadd(sqlCAMPO,{"NCMNOM07",M_NCMNOM07,.t.})
  aadd(sqlCAMPO,{"ALIQZERO",M_ALIQZERO,.t.})
  aadd(sqlCAMPO,{"SUBSTRIB",M_SUBSTRIB,.t.})
  aadd(sqlCAMPO,{"PERPIS",str1(M_PERPIS,2),.t.})
  aadd(sqlCAMPO,{"PERCOF",str1(M_PERCOF,2),.t.})
  aadd(sqlCAMPO,{"ALIQNAC",str1(M_ALIQNAC,2),.t.})
  aadd(sqlCAMPO,{"ALIQIMP",str1(M_ALIQIMP,2),.t.})
  aadd(sqlCAMPO,{"ALIQINT",str1(M_ALIQINT,2),.t.})
  aadd(sqlCAMPO,{"NCMCST",M_NCMCST,.t.})
  aadd(sqlCAMPO,{"NCMCODALI",str(M_NCMCODALI,3),.t.})
  aadd(sqlCAMPO,{"NCMCODSUB",str(M_NCMCODSUB,3),.t.})
endif

executasql()

return ""
