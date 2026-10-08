#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)
#xtranslate ISNIL( <xValue> )       => HB_ISNIL( <xValue> )

#command @ <row> , <col>  GET <var> [<clauses,...>] F2 [<moreClauses,...>] funcao <func> retorno <Variavel>;
=>       @ <row> , <col>  GET <var> [<clauses>] SEND reader := {|oGet| Getf2(oGet,<func>,<Variavel>) } [<moreClauses>]

#include "common.ch"
#include "inkey.ch"

#include "setcurs.ch"
#include "winuser.ch"
#include "ptmenu.ch"
#include "memoedit.ch"

#DEFINE IDM_DEMO_GET     101
#DEFINE IDM_DEMO_BROWSE  102
#DEFINE IDM_DEMO_EXIT    199
#DEFINE IDM_HELP_HELP    301
#DEFINE IDM_HELP_INFO    302
#DEFINE WVW_DEFAULT_MENUKEYEVENT  1024
#define TBSTYLE_FLAT            0x0800
#define MB_OK            0

#define nTiralin  3


***************
function MANPRO
***************
parameters M_OPC,M_OPC1,M_OPC2
local aBlocks := {}
local aLastPaint

*Hb_gtinfo( HB_GTI_PALETTE, 1,rgb( 0,0,0 ) )   // N
*Hb_gtinfo( HB_GTI_PALETTE, 2,rgb( 0,  48, 108) )   // B
*Hb_gtinfo( HB_GTI_PALETTE, 3,rgb( 0,  96,   0) )   // G
*Hb_gtinfo( HB_GTI_PALETTE, 4,rgb(  0,  96,  96) )   // BG
*Hb_gtinfo( HB_GTI_PALETTE, 5,rgb( 189,54,54 ) )  // R
*Hb_gtinfo( HB_GTI_PALETTE, 6,rgb( 0,63,107 ) )   // RB
*Hb_gtinfo( HB_GTI_PALETTE, 7,rgb( 249, 240, 108 ) )  // 255, 226, 140 ) )
*Hb_gtinfo( HB_GTI_PALETTE, 8,rgb( 179, 179, 179 ) )   // W
*Hb_gtinfo( HB_GTI_PALETTE, 9,rgb( 0, 0, 0) )   // N+ rgb( 155, 155, 155 ) )   // N+
*Hb_gtinfo( HB_GTI_PALETTE, 10,rgb( 0,  96,  192) )   // B+
*Hb_gtinfo( HB_GTI_PALETTE, 11,rgb( 240,240,240 ) )   // G+ rgb( 195,208,217 ) )   // G+
*Hb_gtinfo( HB_GTI_PALETTE, 12,rgb(   0,164,164 ) )   // BG+
*Hb_gtinfo( HB_GTI_PALETTE, 13,rgb( 153,0,0 ) )   // R+
*Hb_gtinfo( HB_GTI_PALETTE, 14,rgb(  96, 96,192 ) )   // RB+
*Hb_gtinfo( HB_GTI_PALETTE, 15,rgb( 255,213, 86 ) )   // GR+  192,144,  0 ) )   // GR+
*Hb_gtinfo( HB_GTI_PALETTE, 16,rgb( 240,240,240 ) )   // W+

aAdd( aBlocks, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )

aLastPaint := WvtSetBlocks( aBlocks )


*   cUseAlias := 'TEST'
*   USE 'TEST' NEW ALIAS ( cUseAlias ) SHARED  VIA "DBFCDX"
*   if !NetErr()
*      lOpen := .F.
*      oWvtBrw := CfgMyBrowse( { 1,7,9,10,8 }, cUseAlias, { 6,10,25,80 }, 'Test.dbf - 1,7,9,10,8', oDlg, 'N/W*,N/GR*',1001 )
*      oDlg:AddObject( oWvtBrw )
*   endif

*   EVAL(oWvtBrw)
   
*   oDlg:eval(oWvtBrw)
*   oDlg:Destroy()
*   oDlg:Create()


nWinNum = 0

#include "ptmenu.ch"

    _FUNCLI_ = "PRODUTO.f."
    _FUNPRO_ = "PRODUTO.t."
    _FUNFOR_ = "PRODUTO.t."
    _FUNCPG_ = "PRODUTO.f."
    _FUNTRA_ = "PRODUTO.f."
    _FUNVEN_ = "PRODUTO.f."

      rodape("MENU","PRODUTO",M_FAN,"EAGRO12","Mem: " + str(memory(0), 5),M_EMP)

*        @ 05, 08 prompt "InclusÑo " HIGHLITE R/BG PERMITE 2,1,1
*        @ 06, 08 prompt "AlteraáÑo" HIGHLITE R/BG PERMITE 2,1,2
*        @ 07, 08 prompt "Consulta " HIGHLITE R/BG PERMITE 2,1,3
*        @ 08, 08 prompt "ExclusÑo " HIGHLITE R/BG PERMITE 2,1,4
*        @ 09, 08 prompt "Listagem " HIGHLITE R/BG PERMITE 2,1,5
*        @ 10, 08 prompt "Preáos   " HIGHLITE R/BG PERMITE 2,1,6
*        @ 11, 08 prompt "Morto    " HIGHLITE R/BG PERMITE 2,1,6
*        @ 12, 08 prompt "CodFornec" HIGHLITE R/BG

      do case
         case M_OPC = 1 ; incpro()
         case M_OPC = 2 ; altpro()
         case M_OPC = 3 ; conpro("NORMAL")
         case M_OPC = 4 ; excpro()
         case M_OPC = 5 ; lispro(M_OPC1,M_OPC2)
         case M_OPC = 6 ; outpro(M_OPC1,M_OPC2)
         case M_OPC = 7 ; conpro("MORTO")
         case M_OPC = 8 ; altprofor()
      endcase

return ""

****************
function MOPCAFOR
****************

nbox(02, 05, 21, 74,"W/W+",.t.)
setcolor("BG/W")
@ 02, 05 say     "                                                                      "
@ 03, 05 say     " ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ "
@ 04, 05 say     "  Produto    :             Unidade:     Grupo:      Peso:             "
@ 05, 05 say     "  DescriáÑo  :                                                        "
@ 06, 05 say     "  % Base ICMS: SP)        1)         2)            Bruto:             "
@ 07, 05 say     "  % Aliq ICMS: SP)        1)         2)           Fornec:             "
@ 08, 05 say     " ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ "
@ 09, 05 say     " Fornecedor                                        Codigo             "
@ 10, 05 say     "                                                                      "
@ 11, 05 say     "                                                                      "
@ 12, 05 say     "                                                                      "
@ 13, 05 say     "                                                                      "
@ 14, 05 say     "                                                                      "
@ 15, 05 say     "                                                                      "
@ 16, 05 say     "                                                                      "
@ 17, 05 say     "                                                                      "
@ 18, 05 say     "                                                                      "
@ 19, 05 say     "                                                                      "
@ 20, 05 say     "                                                                      "
@ 21, 05 say     "                                                                      "
set color to

return ""

*****************
function MSPCAVEN
*****************

setcolor("B/W")
@ 04, 21 say  str(PCAMAT, 6, 0) picture "@R 99999-9"
@ 04, 41 say     PCAUNI   picture "@!"
@ 04, 52 say     PCAGRP   picture "####"
@ 04, 63 say     PCAPLQ   picture "#####.##"
@ 05, 21 say     left(PCADES, 52)
@ 06, 24 say     PCARG0   picture "###.##"
@ 06, 34 say     PCARG1   picture "###.##"
@ 06, 45 say     PCARG2   picture "###.##"
@ 06, 63 say     PCAPRB   picture "#####.##"
@ 07, 25 say     PCAIC0   picture "##.##"
@ 07, 35 say     PCAIC1   picture "##.##"
@ 07, 46 say     PCAIC2   picture "##.##"
@ 07, 63 say     PCAFOR   picture "99999"

set color to

return ""

******************
function VERPROFOR(F_VEN,F_LIN,F_COL)
******************

if lastkey() = 5
  return .t.
endif

if A_PCAFOR[F_VEN] = 0
  return .t.
endif

if !BUSCAREGISTRO("AFOR00",1,{str(A_PCAFOR[F_VEN], 7, 0)},"SELECT")
  msg("* * * FORNECEDOR NAO CADASTRADO * * *")
  return .f.
endif

A_PCACGC[F_VEN] = left(FORCGC,9)

setcolor("B/W")
@ F_LIN, F_COL+6 say pad(FORNOM,29)
setcolor("")

return .t.


***************
function ALTPROFOR(TIPO)                        && consulta produtos
***************

if TIPO = NIL
  TIPO = "N"
endif

_FUNFOR_ = "KEYBOARD"

do while .t.

  mopcafor()

  rodape("ALTERAÄéO","PRODUTO",M_FAN,"EAGRO12","Mem: " + str(memory(0), 5),M_EMP)

  store 0         to M_PCAMAT

  SetColor(_COREDICAO_)
  @ 04, 21 get     M_PCAMAT picture "######" F2 color _CORF2_ funcao "sele_arquivo('APCA00')" retorno @M_PCAMAT
  read

  if lastkey() = 27 .or. M_PCAMAT = 0
    exit
  endif

  if !BUSCAREGISTRO("APCA00",1,{str(M_PCAMAT,6,0)},"SELECT")
    msg("* * * PRODUTO NéO CADASTRADO * * *")
    loop
  endif

  mspcaven()

        M_PCALOT=PCALOT
        M_PCAMAT=PCAMAT
        M_PCADES=PCADES
        M_PCAREF=PCADES
        M_PCALIS=PCALIS
        M_PCAGRP=PCAGRP
        M_PCAUNI=PCAUNI
        M_PCAPLQ=PCAPLQ
        M_PCAFOR=PCAFOR
        M_PCATRI=PCATRI
        M_PCACSP=PCACSP
        M_PCACOU=PCACOU
        M_PCARG1=PCARG1
        M_PCARG2=PCARG2
        M_PCARG0=PCARG0 
        M_PCAIC1=PCAIC1
        M_PCAIC2=PCAIC2
        M_PCAIC0=PCAIC0 
        M_PCAPRB=PCAPRB
        M_PCAIPI=PCAIPI 
        M_PCAEMB=pad(PCAEMB,3)
        M_PCADOS=PCADOS
        M_PCAESC=PCAESC
        M_PCAMAR=PCAMAR
        M_PCACOM=PCACOM
        M_PCAFAB=PCAFAB
        M_PCANCM=PCANCM
        M_PCADSC=PCADSC // MENSAGEM ABBOT
        M_PCAINV=PCAINV
        M_REFERE01=REFERE01
        M_REFERENC=REFERENC

  A_PCAOPE = { }
  A_PCAMULT = { }
  A_PCAFOR = { }
  A_PCACODFOR = { }
  A_RECFOR = { }
  A_PCACGC = { }
  A_FORNOM = { }

  for A = 1 to 11
    aadd(A_PCACODFOR,space(22))
    aadd(A_PCAFOR,0)
    aadd(A_PCAMULT,0)
    aadd(A_RECFOR,0)
    aadd(A_PCAOPE," ")
    aadd(A_PCACGC,space(9))
    aadd(A_FORNOM,space(29))
  next


    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"APCFOR","APCFOR"})
    aadd(sqlCAMPO,"APCFOR.*")
    aadd(sqlCAMPO,"AFOR00.FORNOM")
    aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","APCFOR.PCAFOR"})
    aadd(sqlCHAVE,"PCAMAT = " + str(M_PCAMAT,6))
    sqlrelation()

  lPos = 1
  do while !eof()

    A_PCAOPE[lPos]  = PCAOPE
    A_PCAMULT[lPos] = PCAMULT
    A_PCAFOR[lPos]    = PCAFOR
    A_PCACODFOR[lPos] = PCACODFOR
    A_RECFOR[lPos]    = recno()
    A_PCACGC[lPos]    = PCACGC
    A_FORNOM[lPos]    = left(FORNOM,29)
    lPos ++
    skip
  enddo

  SETCOLOR( "N+/W,N/W, , , N/W" )


*  for AB = 1 to 2

*    if AB = 1
*      keyboard chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+;
 *     chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+;
 *     chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+;
 *     chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+chr(13)+;
 *     chr(13)+chr(13)
 *   endif

   setcolor("B/W")
    @ 10, 12 say A_FORNOM[ 1]
    @ 11, 12 say A_FORNOM[ 2]
    @ 12, 12 say A_FORNOM[ 3]
    @ 13, 12 say A_FORNOM[ 4]
    @ 14, 12 say A_FORNOM[ 5]
    @ 15, 12 say A_FORNOM[ 6]
    @ 16, 12 say A_FORNOM[ 7]
    @ 17, 12 say A_FORNOM[ 8]
    @ 18, 12 say A_FORNOM[ 9]
    @ 19, 12 say A_FORNOM[10]
    @ 20, 12 say A_FORNOM[11]
    SetColor(_COREDICAO_)
    @ 10, 06 get A_PCAFOR[ 1] picture "99999" color _COREDICAO_ valid verprofor(1,10,6)
    @ 10, 42 get A_PCACODFOR[ 1] color _COREDICAO_ valid iif(A_PCAFOR[ 1] > 0,!empty(A_PCACODFOR[ 1]),.t.)
    @ 10, 65 get A_PCAOPE[ 1] color _COREDICAO_ 
    @ 10, 67 get A_PCAMULT[ 1] color _COREDICAO_ picture "99999"

    @ 11, 06 get A_PCAFOR[ 2] picture "99999" color _COREDICAO_ valid verprofor(2,11,6)
    @ 11, 42 get A_PCACODFOR[ 2] color _COREDICAO_ valid iif(A_PCAFOR[ 2] > 0,!empty(A_PCACODFOR[ 2]),.t.)
    @ 11, 65 get A_PCAOPE[ 2] color _COREDICAO_ 
    @ 11, 67 get A_PCAMULT[ 2] color _COREDICAO_ picture "99999"

    @ 12, 06 get A_PCAFOR[ 3] picture "99999" color _COREDICAO_ valid verprofor(3,12,6)
    @ 12, 42 get A_PCACODFOR[ 3] color _COREDICAO_ valid iif(A_PCAFOR[ 3] > 0,!empty(A_PCACODFOR[ 3]),.t.)
    @ 12, 65 get A_PCAOPE[ 3] color _COREDICAO_ 
    @ 12, 67 get A_PCAMULT[ 3] color _COREDICAO_ picture "99999"

    @ 13, 06 get A_PCAFOR[ 4] picture "99999" color _COREDICAO_ valid verprofor(4,13,6)
    @ 13, 42 get A_PCACODFOR[ 4] color _COREDICAO_ valid iif(A_PCAFOR[ 4] > 0,!empty(A_PCACODFOR[ 4]),.t.)
    @ 13, 65 get A_PCAOPE[ 4] color _COREDICAO_ 
    @ 13, 67 get A_PCAMULT[ 4] color _COREDICAO_ picture "99999"

    @ 14, 06 get A_PCAFOR[ 5] picture "99999" color _COREDICAO_ valid verprofor(5,14,6)
    @ 14, 42 get A_PCACODFOR[ 5] color _COREDICAO_ valid iif(A_PCAFOR[ 5] > 0,!empty(A_PCACODFOR[ 5]),.t.)
    @ 14, 65 get A_PCAOPE[ 5] color _COREDICAO_ 
    @ 14, 67 get A_PCAMULT[ 5] color _COREDICAO_ picture "99999"

    @ 15, 06 get A_PCAFOR[ 6] picture "99999" color _COREDICAO_ valid verprofor(6,15,6)
    @ 15, 42 get A_PCACODFOR[ 6] color _COREDICAO_ valid iif(A_PCAFOR[ 6] > 0,!empty(A_PCACODFOR[ 6]),.t.)
    @ 15, 65 get A_PCAOPE[ 6] color _COREDICAO_ 
    @ 15, 67 get A_PCAMULT[ 6] color _COREDICAO_ picture "99999"

    @ 16, 06 get A_PCAFOR[ 7] picture "99999" color _COREDICAO_ valid verprofor(7,16,6)
    @ 16, 42 get A_PCACODFOR[ 7] color _COREDICAO_ valid iif(A_PCAFOR[ 7] > 0,!empty(A_PCACODFOR[ 7]),.t.)
    @ 16, 65 get A_PCAOPE[ 7] color _COREDICAO_ 
    @ 16, 67 get A_PCAMULT[ 7] color _COREDICAO_ picture "99999"
 
    @ 17, 06 get A_PCAFOR[ 8] picture "99999" color _COREDICAO_ valid verprofor(8,17,6)
    @ 17, 42 get A_PCACODFOR[ 8] color _COREDICAO_ valid iif(A_PCAFOR[ 8] > 0,!empty(A_PCACODFOR[ 8]),.t.)
    @ 17, 65 get A_PCAOPE[ 8] color _COREDICAO_ 
    @ 17, 67 get A_PCAMULT[ 8] color _COREDICAO_ picture "99999"

    @ 18, 06 get A_PCAFOR[ 9] picture "99999" color _COREDICAO_ valid verprofor(9,18,6)
    @ 18, 42 get A_PCACODFOR[ 9] color _COREDICAO_ valid iif(A_PCAFOR[ 9] > 0,!empty(A_PCACODFOR[ 9]),.t.)
    @ 18, 65 get A_PCAOPE[ 9] color _COREDICAO_ 
    @ 18, 67 get A_PCAMULT[ 9] color _COREDICAO_ picture "99999"

    @ 19, 06 get A_PCAFOR[10] picture "99999" color _COREDICAO_ valid verprofor(10,19,6)
    @ 19, 42 get A_PCACODFOR[10] color _COREDICAO_ valid iif(A_PCAFOR[10] > 0,!empty(A_PCACODFOR[10]),.t.)
    @ 19, 65 get A_PCAOPE[10] color _COREDICAO_ 
    @ 19, 67 get A_PCAMULT[10] color _COREDICAO_ picture "99999"
  
    @ 20, 06 get A_PCAFOR[11] picture "99999" color _COREDICAO_ valid verprofor(11,20,6)
    @ 20, 42 get A_PCACODFOR[11] color _COREDICAO_ valid iif(A_PCAFOR[11] > 0,!empty(A_PCACODFOR[11]),.t.)
    @ 20, 65 get A_PCAOPE[11] color _COREDICAO_ 
    @ 20, 67 get A_PCAMULT[11] color _COREDICAO_ picture "99999"
    read

  if lastkey() = 27
    msg("* * * PRODUTO NéO ALTERADO * * *")
    loop
  endif


  select APCFOR
  sqlCAMPO = {}
  sqlCHAVE = {}
  sqlARQUI = {"APCFOR","DELETE"}
  aadd(sqlCHAVE,{"PCAMAT",str(M_PCAMAT,6)})
  executasql()


  for A = 1 to 11
    if A_PCAFOR[A] > 0 .and. !empty(A_PCACODFOR[A])
      sqlCAMPO = {}
      sqlCHAVE = {}
      sqlARQUI = {"APCFOR","INSERT"}
      aadd(sqlCHAVE,{"PCAMAT",str(M_PCAMAT, 6)})
      aadd(sqlCAMPO,{"PCAMAT",str(M_PCAMAT),.t.})
      aadd(sqlCAMPO,{"PCAFOR",str(A_PCAFOR[A]),.t.})
      aadd(sqlCAMPO,{"PCACODFOR",A_PCACODFOR[A],.t.})
      aadd(sqlCAMPO,{"PCACGC",A_PCACGC[A],.t.})
      aadd(sqlCAMPO,{"PCAOPE",A_PCAOPE[A],.t.})
      aadd(sqlCAMPO,{"PCAMULT",str(A_PCAMULT[A]),.t.})
      executasql()
    endif
  next

  msg("* * * PRODUTO ALTERADO * * *")

enddo

return ""

****************
function TELAPRO(F_SIT)
****************

SetColor( s_cStdColor )

***************
function INCPRO
***************

    do while .t.

        tlpro01()

        rodape("INCLUSéO","PRODUTO",M_FAN,"EAGRO12","Mem: " + str(memory(0), 5),M_EMP)

        store 0                  to M_PCAMAT ,;
                                    M_PCAFLG

        store space(50)          to M_PCAREF 

        store  0 to M_PCAMAT

        store AEMP00->EMPPRO + 1 to M_PCAMAT

        SetColor(_COREDICAO_)
        @ 06, 20 get M_PCAMAT picture "@R 999999"
        read

        if lastkey()=27
          exit
        endif
        
        do while .t.
          if BUSCAREGISTRO("APCA00",1,{str(M_PCAMAT,6,0)},"SELECT")
            M_PCAMAT ++
            if M_PCAMAT > 999999
              msg("* * * CODIGO DE PRODUTO ESGOTADO * * *")
              return ""
            endif
            loop
          endif
          exit
        enddo
        
        M_CBNEF =space(8)
        M_PCABAR=space(13)
        M_PCAREF=space(50)
        M_PCALIS="SIM"
        M_PCAGRP=0
        M_PCAMAR = space(30)
        M_PCANCM = space(8)
        M_PCAUNI="   "
        M_PCAPLQ=1
        M_PCAFOR=0
        M_PCATRI=1
        M_PCACSP=" "
        M_PCACOU=" "
        M_PCARG1=0
        M_PCARG2=0
        M_PCARG0=0 
        M_PCAIC1=7
        M_PCAIC2=12
        M_PCAIC0=18 
        M_PCAIPI=0 
        M_PCAPRB=1
        M_PCAEMB=space(3)
        M_PCADOS=0
        M_PCAESC=0
        M_PCACOM=0
        M_PCAFAB=space(10)
        M_PCACLA=space(7)
        M_PCADSC="N" // MENSAGEM ABBOT
        M_PCAINV="S" // Inventario
        M_REFERE01 = space(20)
        M_REFERENC = " "
        M_PCALOT = " "
        M_PCADES=space(50)
        M_PCAORI=" "
        M_SLDEMP = ME_EMP
        M_SLDFAB = 0
        M_SLDCUS = 0
        M_SLDMAR = 0
        M_SLDPRC = 0
        M_SLDDSC = 0

        M_SLDCPA = 0
        M_SLDMAX = 0
        M_SLDMIN = 0

        M_SLDRES = 0
        M_SLDINV = 0
        M_SLDDIS = 0
        M_SLDCME = 0
        M_SLDDTE = ctod("  /  /  ")
        M_SLDDTP = ctod("  /  /  ")

       edpro01("I")

       if lastkey() = 27
         exit
       endif

  do while .t.
    if BUSCAREGISTRO("APCA00",1,{str(M_PCAMAT,6,0)},"SELECT")
      M_PCAMAT = M_PCAMAT + 1
      loop
    else
      if grpro01("INSERT")                       && grava produto
         sqlORDEM = {}
         sqlCAMPO = {}
         sqlCHAVE =  {}
         sqlARQUI = {"AEMP00","UPDATE"}
         aadd(sqlCHAVE,{"EMPCOD",str(ME_EMP,2)})
         aadd(sqlCAMPO,{"EMPPRO",str(M_PCAMAT,6),.t.})
         executasql()

         set color to I
           @ 07, 20 say str(M_PCAMAT, 6, 0) picture "@R 99999-9"
         set color to

         if AEMP00->EMPCGC == "002715655000171" .or. AEMP00->EMPCGC == "027435570000160"
           // CIRUR E NUTRI CENTER
           // INCLUIMOS SALDO NAS DUAS
           grpro02("INSERT",1)                       && grava saldo empresa 1
           grpro02("INSERT",10)                       && grava saldo empresa 1
         else
           grpro02("INSERT",ME_EMP)                       && grava saldo empresa 1
         endif
         
         msg("* * * PRODUTO E SALDO INCLUIDO * * *")
      else
        msgbox1("Problema na inclusao do produto, nao incluido")
      endif
    endif
    exit
  enddo

enddo

return ""

*************** 
function ALTPRO                        && consulta produtos   
***************                         

*telapro("ALTERAR")

private aBlocks2 := { }
aAdd( aBlocks2, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )

aLastPaint1 := WvtSetBlocks( aBlocks2 )
aLastPaint9 := aLastPaint1

    do while .t.

      tlpro01()

        rodape("ALTERACAO","PRODUTO",M_FAN,"EAGRO12","Mem: " + str(memory(0), 5),M_EMP)

        M_PCAMAT = 0

        SetColor(_COREDICAO_)

        @ 04, 20 get     M_PCAMAT picture "######" F2 color _CORF2_ funcao "sele_arquivo('APCA00')" retorno @M_PCAMAT

*        @ 06, 20 get     M_PCAMAT picture "######"
        read

        if M_PCAMAT = 0
          exit
        endif

        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"APCA00","APCA00"})
        aadd(sqlCAMPO,"ASLD00.SLDFAB")
        aadd(sqlCAMPO,"ASLD00.SLDCUS")
        aadd(sqlCAMPO,"ASLD00.SLDMAR")
        aadd(sqlCAMPO,"ASLD00.SLDPRC")
        aadd(sqlCAMPO,"ASLD00.SLDCPA")
        aadd(sqlCAMPO,"ASLD00.SLDCME")
        aadd(sqlCAMPO,"ASLD00.SLDRES")

        aadd(sqlCAMPO,"ASLD00.SLDMAX")
        aadd(sqlCAMPO,"ASLD00.SLDMIN")

        aadd(sqlCAMPO,"ASLD00.SLDDTE")
        aadd(sqlCAMPO,"ASLD00.SLDDTP")
        aadd(sqlCAMPO,"ASLD00.SLDINV")
        aadd(sqlCAMPO,"ASLD00.SLDDIS")
        aadd(sqlCAMPO,"ASLD00.SLDDSC")

        aadd(sqlCAMPO,"APCA00.*")
        aadd(sqlRELATION,{"ASLD00",str(ME_EMP, 2, 0),"ASLD00.SLDEMP"})
        aadd(sqlRELATION,{"","ASLD00.SLDMAT","APCA00.PCAMAT"})
        aadd(sqlCHAVE,"PCAMAT = " + str(M_PCAMAT, 6, 0))
        if !sqlrelation()
          msg("* * * PRODUTO NAO CADASTRADO * * *")
          loop
        endif

        mspro01()
       
        select APCA00

        M_CBNEF =CBNEF
        M_PCABAR=PCABAR
        M_PCALOT=PCALOT
        M_PCAMAT=PCAMAT
        M_PCADES=PCADES
        M_PCAREF=PCADES
        M_PCALIS=PCALIS
        M_PCAGRP=PCAGRP
        M_PCAUNI=PCAUNI
        M_PCAPLQ=PCAPLQ
        M_PCAFOR=PCAFOR
        M_PCATRI=PCATRI
        M_PCACSP=PCACSP
        M_PCACOU=PCACOU
        M_PCARG1=PCARG1
        M_PCARG2=PCARG2
        M_PCARG0=PCARG0 
        M_PCAIC1=PCAIC1
        M_PCAIC2=PCAIC2
        M_PCAIC0=PCAIC0 
        M_PCAPRB=PCAPRB
        M_PCAIPI=PCAIPI 
        M_PCAEMB=pad(PCAEMB,3)
        M_PCADOS=PCADOS
        M_PCAESC=PCAESC
        M_PCAMAR=PCAMAR
        M_PCACOM=PCACOM
        M_PCAFAB=PCAFAB
        M_PCANCM=PCANCM
        M_PCADSC=PCADSC // MENSAGEM ABBOT
        M_PCAINV=PCAINV
        M_REFERE01=REFERE01
        M_REFERENC=REFERENC
        M_PCAORI=PCAORI
        M_PCACLA=LEFT(PCACLA,7)

        M_SLDEMP = ME_EMP
        M_SLDFAB = SLDFAB
        M_SLDCUS = SLDCUS
        M_SLDMAR = SLDMAR
        M_SLDPRC = SLDPRC
        M_SLDDSC = SLDDSC
        M_SLDCPA = SLDCPA
        M_SLDMAX = SLDMAX
        M_SLDMIN = SLDMIN
        M_SLDRES = SLDRES
        M_SLDINV = SLDINV
        M_SLDDIS = SLDDIS
        M_SLDCME = SLDCME
        M_SLDDTE = iif(HB_ISNIL(SLDDTE), ctod("  /  /  "),SLDDTE)
        M_SLDDTP = iif(HB_ISNIL(SLDDTP), ctod("  /  /  "),SLDDTP)
        M_SLDCPA = SLDCPA
        M_SLDNESTLE = SLDNESTLE

        edpro01("A")
 
        if lastkey() = 27
          msg("* * * PRODUTO NéO ALTERADO * * *")
          loop
        endif
       
        M_PCAREF=M_PCADES

        grpro01("UPDATE")                       && regrava produto
        grpro02("UPDATE")                       && regrava saldo


        aLastPaint1 := aLastPaint9
        WvtSetBlocks( aLastPaint1)


        adicional()

        aLastPaint1 := WvtSetBlocks( aBlocks2 )
        aLastPaint9 := aLastPaint1


        msg("* * * PRODUTO ALTERADO * * *")

    enddo

return ""

***************
function CONPRO(TIPO)               && consulta kardex
***************

*teste4()

telapro("CONSULTA")


do while .t.

  tlpro01()

  rodape("CONSULTA","PRODUTO",M_FAN,"EAGRO12","Mem: " + str(memory(0), 5),M_EMP)

  M_PCAMAT = 0       
  M_PCAREF = space(50)
  M_PCADES = space(50)
 
  SetColor(_COREDICAO_)
  @ 04, 20 get M_PCAMAT picture "######" F2 color _CORF2_ funcao "sele_arquivo('APCA00')" retorno @M_PCAMAT
  read

  if lastkey() = 27
    exit
  endif

  if M_PCAMAT = 0
    @ 07, 20 get M_PCADES picture "@!"
    read
  endif

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}
  
  aadd(sqlARQUI,{"APCA00","APCA00"})
  aadd(sqlCAMPO,"ASLD00.SLDFAB")
  aadd(sqlCAMPO,"ASLD00.SLDCUS")
  aadd(sqlCAMPO,"ASLD00.SLDMAR")
  aadd(sqlCAMPO,"ASLD00.SLDPRC")
  aadd(sqlCAMPO,"ASLD00.SLDCPA")
  aadd(sqlCAMPO,"ASLD00.SLDCME")

  aadd(sqlCAMPO,"ASLD00.SLDMAX")
  aadd(sqlCAMPO,"ASLD00.SLDMIN")

  aadd(sqlCAMPO,"ASLD00.SLDDTE")
  aadd(sqlCAMPO,"ASLD00.SLDDTP")
  aadd(sqlCAMPO,"ASLD00.SLDINV")
  aadd(sqlCAMPO,"ASLD00.SLDDIS")
  aadd(sqlCAMPO,"APCA00.*")
  aadd(sqlRELATION,{"ASLD00",str(ME_EMP, 2, 0),"ASLD00.SLDEMP"})
  aadd(sqlRELATION,{"","ASLD00.SLDMAT","APCA00.PCAMAT"})

  nPCAMAT = 0

  do case
  case M_PCAMAT > 0
    nPCAMAT = M_PCAMAT
    aadd(sqlCHAVE,"PCAMAT = " + str(M_PCAMAT, 6, 0))
  case !empty(M_PCADES)
    aadd(sqlCHAVE,"PCADES LIKE '" + alltrim(M_PCADES) + "%'")
  endcase
  sqlORDEM = {"PCAMAT"}
  sqlrelation()

  if eof()
    msg("PRODUTO NAO CADASTRADO")
    loop
  endif

  do while .t.

    mspro01()

    waitstate()

    if lastkey() = 27
      exit
    endif

    if M_PCAMAT > 0
      if lastkey() = 5 .or. lastkey() = 19
        seexistesql("APCA00")
        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}
        aadd(sqlARQUI,{"APCA00","APCA00"})
        aadd(sqlCAMPO,"ASLD00.SLDFAB")
        aadd(sqlCAMPO,"ASLD00.SLDCUS")
        aadd(sqlCAMPO,"ASLD00.SLDMAR")
        aadd(sqlCAMPO,"ASLD00.SLDPRC")
        aadd(sqlCAMPO,"ASLD00.SLDCPA")
        aadd(sqlCAMPO,"ASLD00.SLDCME")
        aadd(sqlCAMPO,"ASLD00.SLDMAX")
        aadd(sqlCAMPO,"ASLD00.SLDMIN")
        aadd(sqlCAMPO,"ASLD00.SLDDTE")
        aadd(sqlCAMPO,"ASLD00.SLDDTP")
        aadd(sqlCAMPO,"ASLD00.SLDINV")
        aadd(sqlCAMPO,"ASLD00.SLDDIS")
        aadd(sqlCAMPO,"APCA00.*")
        aadd(sqlRELATION,{"ASLD00",str(ME_EMP, 2, 0),"ASLD00.SLDEMP"})
        aadd(sqlRELATION,{"","ASLD00.SLDMAT","APCA00.PCAMAT"})
        aadd(sqlCHAVE,"PCAMAT = (SELECT max(pcamat) FROM apca00 WHERE pcamat < " + str(nPCAMAT, 6, 0) + ")")
        sqlrelation()
      endif

      if lastkey() = 24 .or. lastkey() = 4
        seexistesql("APCA00")
        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}
        aadd(sqlARQUI,{"APCA00","APCA00"})
        aadd(sqlCAMPO,"ASLD00.SLDFAB")
        aadd(sqlCAMPO,"ASLD00.SLDCUS")
        aadd(sqlCAMPO,"ASLD00.SLDMAR")
        aadd(sqlCAMPO,"ASLD00.SLDPRC")
        aadd(sqlCAMPO,"ASLD00.SLDCPA")
        aadd(sqlCAMPO,"ASLD00.SLDCME")
        aadd(sqlCAMPO,"ASLD00.SLDMAX")
        aadd(sqlCAMPO,"ASLD00.SLDMIN")
        aadd(sqlCAMPO,"ASLD00.SLDDTE")
        aadd(sqlCAMPO,"ASLD00.SLDDTP")
        aadd(sqlCAMPO,"ASLD00.SLDINV")
        aadd(sqlCAMPO,"ASLD00.SLDDIS")
        aadd(sqlCAMPO,"APCA00.*")
        aadd(sqlRELATION,{"ASLD00",str(ME_EMP, 2, 0),"ASLD00.SLDEMP"})
        aadd(sqlRELATION,{"","ASLD00.SLDMAT","APCA00.PCAMAT"})
        aadd(sqlCHAVE,"PCAMAT = (SELECT min(pcamat) FROM apca00 WHERE pcamat > " + str(nPCAMAT, 6, 0) + ")")
        sqlrelation()
      endif
    else
      if lastkey() = 5 .or. lastkey() = 19
        skip -1
        if bof()
          go bottom
        endif
      endif
      if lastkey() = 24 .or. lastkey() = 4
        skip
        if eof()
          go top
        endif
      endif
    endif

    nPCAMAT = PCAMAT

  enddo

enddo

return "" 

***************
function EXCPRO
***************

  private M_OPC

  do while .t.

       tlpro01()

        rodape("EXCLUSéO","PRODUTO",M_FAN,"EAGRO12","Mem: " + str(memory(0), 5),M_EMP)

        M_PCAMAT = 0
        M_PCAREF = space(15)
        M_PCAFLG = 0

        SetColor(_COREDICAO_)
        @ 04, 20 get     M_PCAMAT picture "######"
        read

        if lastkey() = 27 
          exit
        endif

        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"APCA00","APCA00"})
        aadd(sqlCAMPO,"ASLD00.SLDFAB")
        aadd(sqlCAMPO,"ASLD00.SLDCUS")
        aadd(sqlCAMPO,"ASLD00.SLDMAR")
        aadd(sqlCAMPO,"ASLD00.SLDPRC")
        aadd(sqlCAMPO,"ASLD00.SLDCPA")
        aadd(sqlCAMPO,"ASLD00.SLDCME")
        aadd(sqlCAMPO,"ASLD00.SLDRES")

        aadd(sqlCAMPO,"ASLD00.SLDMAX")
        aadd(sqlCAMPO,"ASLD00.SLDMIN")

        aadd(sqlCAMPO,"ASLD00.SLDDTE")
        aadd(sqlCAMPO,"ASLD00.SLDDTP")
        aadd(sqlCAMPO,"ASLD00.SLDINV")
        aadd(sqlCAMPO,"ASLD00.SLDDIS")
        aadd(sqlCAMPO,"ASLD00.SLDDSC")

        aadd(sqlCAMPO,"APCA00.*")
        aadd(sqlRELATION,{"ASLD00",str(ME_EMP, 2, 0),"ASLD00.SLDEMP"})
        aadd(sqlRELATION,{"","ASLD00.SLDMAT","APCA00.PCAMAT"})
        aadd(sqlCHAVE,"PCAMAT = " + str(M_PCAMAT, 6, 0))
        if !sqlrelation()
          msg("* * * PRODUTO NAO CADASTRADO * * *")
          loop
        endif

        mspro01()

        M_OPC = confirma("deste Produto")

        if M_OPC != 1 .or. lastkey() = 27
          msg("* * * PRODUTO NéO EXCLUIDO * * *")
          loop
        endif 

        sqlORDEM = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {"ASLD00","DELETE"}
        aadd(sqlCHAVE,{"SLDMAT",str(M_PCAMAT,6)})
        executasql()

        BUSCAREGISTRO("APCA00",1,{str(M_PCAMAT,6,0)},"DELETE")

        msg("* * * PRODUTO E SALDOS EXCLUIDO * * *") 

    enddo


return  "" 

***************
function LISPRO
*************** 
parameters M_OPC,M_OPC1

        rodape("LISTA","PRODUTO",M_FAN,"EAGRO12","Mem: " + str(memory(0), 5),M_EMP)

*          @ 08, 14 prompt 1 "RelaáÑo de Compra   " POSITION 12 HIGHLITE R/BG
*          @ 09, 14 prompt 2 "RelaáÑo por Grupo   " POSITION 13 HIGHLITE R/BG
*          @ 10, 14 prompt 3 "Lista Preáo Venda   " POSITION 09 HIGHLITE R/BG
*          @ 11, 14 prompt 4 "Planilha Balanáo    " POSITION 10 HIGHLITE R/BG
*          @ 12, 14 prompt 5 "Invent†rio Confer   " POSITION 10 HIGHLITE R/BG
*          @ 13, 14 prompt 6 "RelaáÑo de Saldos   " POSITION 10 HIGHLITE R/BG
*          @ 14, 14 prompt 7 "Inventario Efetivo  " POSITION 10 HIGHLITE R/BG
*          @ 15, 14 prompt 8 "Lista por Fabricante" POSITION 10 HIGHLITE R/BG
*          @ 16, 14 prompt 9 "Classificaá∆o Fiscal" POSITION 01 HIGHLITE R/BG

        do case
           case M_OPC = 1 ; lisproa()
           case M_OPC = 2 ; lisprob()
           case M_OPC = 3 ; lisproc()
           case M_OPC = 4 ; lisprod()
           case M_OPC = 5 ; lisproe()
           case M_OPC = 6 ; lisprof(M_OPC1)
           case M_OPC = 7 ; lisprog()
           case M_OPC = 8 ; lisproh(M_OPC1)
           case M_OPC = 9 ; lisproi()
        endcase


return ""

****************
function LISPROa
****************


        store 0 to M_COD1,; 
                   M_COD2,;
                   M_FORINI,M_FORFIN,M_PCAFOR

         sombra(13, 25, 17, 50,_SOMBRA_)

        set color to GR+/W+
           @ 13, 25 say "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø" 
           @ 14, 25 say "≥  Grupo Inicial:        ≥" 
           @ 15, 25 say "≥          Final:        ≥" 
           @ 16, 25 say "≥     Fornecedor:        ≥" 
           @ 17, 25 say "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
         set color to 

        SetColor(_COREDICAO_)
         @ 14, 43 get     M_COD1 picture "####"
         @ 15, 43 get     M_COD2 picture "####"   
         @ 16, 43 get     M_PCAFOR picture "#######"   valid verpro11()
         read

         if lastkey() = 27
           return ""
         endif

        M_COD1 = iif(M_COD1 = 0,   1,M_COD1)
        M_COD2 = iif(M_COD2 = 0,9999,M_COD2)

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"APCA00","APCA00"})
  aadd(sqlCAMPO,"ASLD00.SLDPRC")
  aadd(sqlCAMPO,"ASLD00.SLDDTE")
  aadd(sqlCAMPO,"ASLD00.SLDCPA")
  aadd(sqlCAMPO,"ASLD00.SLDDIS")
  aadd(sqlCAMPO,"PCAMAT")
  aadd(sqlCAMPO,"PCADES")
  aadd(sqlCAMPO,"PCAUNI")
  aadd(sqlCAMPO,"PCAGRP")
  aadd(sqlCAMPO,"PCAFOR")
  aadd(sqlCAMPO,"AGRP00.GRPNOM")
  aadd(sqlCAMPO,"AFOR00.FORNOM")
  aadd(sqlCAMPO,"PCATRI")
  aadd(sqlCAMPO,"PCARG1")
  aadd(sqlCAMPO,"PCARG2")
  aadd(sqlCAMPO,"PCARG0")
  aadd(sqlCAMPO,"PCACSP")
  aadd(sqlCAMPO,"PCACOU")
  aadd(sqlRELATION,{"AGRP00","AGRP00.GRPCOD","APCA00.PCAGRP"})
  aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","APCA00.PCAFOR"})
  aadd(sqlRELATION,{"ASLD00",str(ME_EMP, 2, 0),"ASLD00.SLDEMP"})
  aadd(sqlRELATION,{"","ASLD00.SLDMAT","APCA00.PCAMAT"})
  aadd(sqlCHAVE,"PCAGRP BETWEEN " + aspas(str(M_COD1,4)) + " and " + aspas(str(M_COD2,4)))

  if M_PCAFOR > 0
    aadd(sqlCHAVE,"PCAFOR = " + aspas(str(M_PCAFOR,7)))
  endif

  aadd(sqlORDEM,"PCADES")

  sqlrelation()

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        ?? chr(15)                        && comprime

      store 0 to PG,GR

      do while !eof()

        store PG + 1 to PG

        if PG > 1
          eject
        endif

          ? cent_cab(AEMP00->EMPFAN,"LISTAGEM PARA COMPRAS","EAGRO12",132) 
          ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
          ? "*-------*--------------------------------------*---*------------------------------*--------*----------*----------*--------*--------*"
          ? "*PRODUTO*     D E S C R I C A O                *UNI*        FORNECEDOR            * ULTIMA *  COMPRA  *  VENDA   * SALDO  * PEDIDO *"
          ? "*-------*--------------------------------------*---*------------------------------*--------*----------*----------*--------*--------*"
*             999.999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 ###,###.## ###,###.## 99999.99 ........

        store 5 to LN

        do while !eof() .and. LN < 60

            if PCAGRP != GR
              ?
              ? cent_cab("","* * * " + alltrim(str(PCAGRP, 4, 0) + " - " + GRPNOM) + " * * *","", 132)
              ?
              LN = LN + 3
              GR = PCAGRP
            endif

            ? " "
            ?? transform(PCAMAT,"@E ###,###")
            ?? " "
            ?? pad(PCADES, 36)
            ?? " "
            ?? pad(PCAUNI, 03)
            ?? " "
            ?? pad(PCAFOR, 7, 0)
            ?? " "
            ?? pad(FORNOM, 24)
            ?? " "
            ?? iif(ISNIL(SLDDTE),ctod("  /  /  "),SLDDTE)
            ?? " "
            ?? transform(SLDCPA,"@E ###,###.##")
            ?? " "
            ?? transform(SLDPRC,"@E ###,###.##")
            ?? " "
            ?? transform(SLDDIS,"@E ########")
            ?? " "
            ?? "........"

            store LN + 1 to LN

            skip

            M_ESC = inkey()

            if M_ESC = 27
               if susimp()
                 ? replicate("-", 132)
                 ? "* * * IMPRESSAO SUSPENSA * * *"
                 go bottom
                 skip
               else
                 M_ESC = inkey()
               endif
            endif

        enddo

    enddo

    ? replicate("-", 132)

    eject
 
desliga1()

return "" 

****************
function LISPROb
****************

        store 0         to M_COD1,;
                           M_GRP1,;
                           M_COD2,;
                           M_GRP2

        store "V"  to M_PRECO

        sombra(13, 25, 17, 49,_SOMBRA_)

        set color to GR+/W+
           @ 13, 25 say "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø" 
           @ 14, 25 say "≥Inicial:               ≥"
           @ 15, 25 say "≥Final  :               ≥"
           @ 16, 25 say "≥Preco  :               ≥" 
           @ 17, 25 say "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ" 

        SetColor(_COREDICAO_)
        @ 14, 35 get     M_GRP1 picture "####"
        @ 15, 35 get     M_GRP2 picture "####"
        @ 16, 35 get     M_PRECO picture "@!" valid(iif(!M_PRECO $ "CVU",msg("* * * (V)enda (C)ompra ou C(u)sto * * *"),.t.))
        read

        if lastkey() = 27
          return ""
        endif
              
        M_GRP1 = iif(M_GRP1 = 0,     1,M_GRP1)
        M_GRP2 = iif(M_GRP2 = 0,  9999,M_GRP2) 


  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"APCA00","APCA00"})
  aadd(sqlCAMPO,"ASLD00.SLDPRC")
  aadd(sqlCAMPO,"ASLD00.SLDDTE")
  aadd(sqlCAMPO,"ASLD00.SLDCPA")
  aadd(sqlCAMPO,"ASLD00.SLDCUS")
  aadd(sqlCAMPO,"ASLD00.SLDDIS")
  aadd(sqlCAMPO,"PCAMAT")
  aadd(sqlCAMPO,"PCADES")
  aadd(sqlCAMPO,"PCAMAR")
  aadd(sqlCAMPO,"PCAUNI")
  aadd(sqlCAMPO,"PCAGRP")
  aadd(sqlCAMPO,"PCAFOR")
  aadd(sqlCAMPO,"AGRP00.GRPNOM")
  aadd(sqlCAMPO,"AFOR00.FORNOM")
  aadd(sqlCAMPO,"PCATRI")
  aadd(sqlCAMPO,"PCARG1")
  aadd(sqlCAMPO,"PCARG2")
  aadd(sqlCAMPO,"PCARG0")
  aadd(sqlCAMPO,"PCACSP")
  aadd(sqlCAMPO,"PCACOU")
  aadd(sqlRELATION,{"AGRP00","AGRP00.GRPCOD","APCA00.PCAGRP"})
  aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","APCA00.PCAFOR"})
  aadd(sqlRELATION,{"ASLD00",str(ME_EMP, 2, 0),"ASLD00.SLDEMP"})
  aadd(sqlRELATION,{"","ASLD00.SLDMAT","APCA00.PCAMAT"})
  aadd(sqlCHAVE,"PCAGRP BETWEEN " + aspas(str(M_GRP1,4)) + " and " + aspas(str(M_GRP2,4)))
  aadd(sqlORDEM,"PCADES")

  sqlrelation()

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif


        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

      store 0 to PG

      do while !eof()

        PG++

        if PG > 1
          eject
        endif

        ? cent_cab(AEMP00->EMPFAN,"LISTAGEM  DE  PRODUTOS - GRUPO","EAGRO12",132) 
        ? cent_cab(M_DATA,"PRECO DE " + iif(M_PRECO = "V","VENDA",iif(M_PRECO = "C","COMPRA","CUSTO")),"PAG.: " + str(PG, 4, 0), 132)
        ? "*------*---------------------------------------------*---*---------------*----*----------*-------*----------*--------*-------------*"
        ? "*CODIGO*             D E S C R I C A O               *UNI*    MARCA      *GRUP* NOME     * FORNEC*   NOME   * SALDO  *    PRECO    *"
        ? "*------*---------------------------------------------*---*---------------*----*----------*-------*----------*--------*-------------*"
*           999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXX XXXXXXXXXXXXXXX #### XXXXXXXXXX ####### XXXXXXXXXX #####.## ##,###,###.##

        store 5 to LN

        do while !eof() .and. LN < 60

            ? " "
            ?? transform(PCAMAT,"@E ######")
            ?? " "
            ?? pad(PCADES,45)
            ?? " "
            ?? pad(PCAUNI, 3)
            ?? " "
            ?? pad(PCAMAR, 15)
            ?? " "
            ?? str(PCAGRP, 4)
            ?? " "
            ?? pad(GRPNOM, 10)
            ?? " "
            ?? str(PCAFOR, 7)
            ?? " "
            ?? pad(FORNOM, 10)
            ?? " "
            ?? str(SLDDIS, 8, 0)
            ?? " "
            if M_PRECO = "C"
              ?? transform(SLDCPA,"@E ##,###,###.##")
            else
              if M_PRECO = "V" 
                ?? transform(SLDPRC,"@E ##,###,###.##")
              else
                 ?? transform(SLDCUS,"@E ##,###,###.##")
              endif
            endif

            LN++

            skip

            if inkey() = 27
              if susimp()
                ? replicate("-", 132)
                ? "* * * IMPRESSAO SUSPENSA * * *"
                go bottom
                skip
              endif
            endif

        enddo

    enddo

    ? replicate("-", 132)

    eject

desliga1()

return "" 

****************
function LISPROC
****************


        store 0 to M_FORINI, M_FORFIN, M_GRPINI, M_GRPFIN

        M_PCAFOR = 0
        store "                                                  " to M_ROD1
        store "                                                  " to M_ROD2

        store 0 to M_PERCEN

        sombra(12, 25, 19, 62,_SOMBRA_)

        set color to GR+/W+
          @ 12, 25 say "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø" 
          @ 13, 25 say "≥Grupo.....:      ate                ≥" 
          @ 14, 25 say "≥Fornecedor:                         ≥" 
          @ 15, 25 say "≥% Acresc  :                         ≥" 
          @ 16, 25 say "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒrodapÇƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
          @ 17, 25 say "≥                                    ≥" 
          @ 18, 25 say "≥                                    ≥" 
          @ 19, 25 say "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ" 
        SetColor(_COREDICAO_)

        @ 13, 38 get     M_GRPINI picture "####"
        @ 13, 47 get     M_GRPFIN picture "####"       
        @ 14, 38 get     M_PCAFOR picture "9999999"
        @ 15, 38 get     M_PERCEN  picture "###.##"
        @ 17, 27 get     M_ROD1    picture "@!@S34"
        @ 18, 27 get     M_ROD2    picture "@!@S34"
        read

*       M_GRPINI = iif(M_GRPINI = 0,    1, M_GRPINI)
        M_GRPFIN = iif(M_GRPFIN = 0, 9999, M_GRPFIN)

        if lastkey() = 27
          return ""
        endif

        select APCA00

        set relation to str(PCAGRP, 4, 0)                     into AGRP00,;
                     to str(ME_EMP, 2, 0) + str(PCAMAT, 6, 0) into ASLD00,;
                     to str(PCAFOR, 7, 0)                     into AFOR00
      go top

      set order to 4
      
      dbseek(str(M_GRPINI, 4, 0),.t.)

      M_IMPRE = impresn()

      if M_IMPRE = "N"
        return ""
      endif


      if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
        ?? chr(15)                        && comprime
      endif

      store 0 to PG , M_FORANT, M_GRPANT

      do while !eof()

         PG = PG + 1

         if PG > 1
           eject
         endif

         ? cent_cab(AEMP00->EMPFAN,"LISTA DE PRECOS DE VENDA","EAGRO12",100)
         ? cent_cab(M_DATA,"","PAG.: " + str(PG, 3), 100)
         ? "+-------+-----------------------------------------------------------------+--+----------+----------+"
         ? "|CODIGO |             D E S C R I C A O                                   |UN| A VISTA  | A PRAZO  |"
         ? "+-------+-----------------------------------------------------------------+--+----------+----------+"
*            99.9999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX 999,999.99 999,999.99

        store 11 to LN

        do while !eof() .and. LN < 52  

            if M_PCAFOR > 0
              if !PCAFOR = M_PCAFOR
                skip
                loop
              endif
            endif

*/
            if !PCALIS == "SIM"
              skip
              loop
            endif
*/

            if PCAGRP > M_GRPFIN
              go bottom    
              skip
              loop
            endif

            if PCAGRP != M_GRPANT
               ?
               ? " "       
                 ?? chr(27) + "E"
                 ?? str(PCAGRP, 4, 0)
                 ?? " "
                 ?? AGRP00->GRPNOM
                 ?? chr(27) + "F"
               ?
               M_GRPANT = PCAGRP
               LN = LN + 3
            endif

            ? " "
            ?? transform(PCAMAT,"@E #######")
            ?? " "
            ?? pad(alltrim(PCADES) + " " + PCAMAR, 65) 
            ?? " "
            ?? pad(PCAUNI,02)
            ?? " "
            ?? transform(ASLD00->SLDPRC,"@E ###,###.##")
            ?? " "
            ?? transform(ASLD00->SLDPRC + ((ASLD00->SLDPRC * .01) * M_PERCEN), "@E ###,###.##")

            LN++

            skip

            if inkey() = 27
              if susimp()
                 ? space(15) + replicate("-", 100)
                 ? "* * * IMPRESSAO SUSPENSA * * *"
                 go bottom
                 skip
                endif
            endif

        enddo
      
        ? replicate("=", 100)
        ? cent_cab("",alltrim(M_ROD1),"",100)
        ? cent_cab("",alltrim(M_ROD2),"",100)
        ? replicate("=", 100)

    enddo

    eject

desliga1()

return "" 

****************
function LISPROd
****************


        store space(35) to M_NOMINI ,;
                           M_NOMFIN

        store 0 to M_GRPINI, M_GRPFIN
        store 0 to M_FORINI, M_FORFIN

        sombra(13, 25, 18, 70,_SOMBRA_)

        set color to GR+/W+
          @ 13, 25 say "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø" 
          @ 14, 25 say "≥Inicial:                                    ≥" 
          @ 15, 25 say "≥Final  :                                    ≥" 
          @ 16, 25 say "≥Grupo  :      a                             ≥" 
          @ 17, 25 say "≥Fornec :         a                          ≥" 
          @ 18, 25 say "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ" 
        SetColor(_COREDICAO_)
        @ 14, 35 get     M_NOMINI picture "@!"
        @ 15, 35 get     M_NOMFIN picture "@!"
        @ 16, 35 get     M_GRPINI picture "####"
        @ 16, 42 get     M_GRPFIN picture "####"
        @ 17, 35 get     M_FORINI picture "#######"
        @ 17, 45 get     M_FORFIN picture "#######"
        read

        if lastkey() = 27
         return ""
        endif

        M_NOMINI = iif(empty(M_NOMINI),"A"               ,M_NOMINI)
        M_NOMFIN = iif(empty(M_NOMFIN),replicate("Z", 35),M_NOMFIN)

        M_GRPINI = iif(M_GRPINI=0,   1,M_GRPINI)
        M_GRPFIN = iif(M_GRPFIN=0,9999,M_GRPFIN)

        M_FORINI = iif(M_FORINI=0,      1,M_FORINI)
        M_FORFIN = iif(M_FORFIN=0,9999999,M_FORFIN)


        select APCA00

        set relation to str(ME_EMP, 2, 0) + str(PCAMAT, 6, 0) into ASLD00

        ( dbsetorder(3) , dbseek(M_NOMINI, .t.) )

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

      store 0 to PG

      do while !eof()

        store PG + 1 to PG

        if PG > 1
            eject
        endif

          ? cent_cab(AEMP00->EMPFAN,"PLANILHA PARA BALANCO","EAGRO12",80)    
          ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 80)
          ? "*------*-------------------------------------*----*------*-------*-------------*"
          ? "*CODIGO*  D E S C R I C A O                  *GRP *SALDO *CONTADO*     OBS     *"
          ? "*------*-------------------------------------*----*------*-------*-------------*"
*             999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXX ###### ####### .............

        store 5 to LN

        do while !eof() .and. LN < 60

            if alltrim(PCADES) > left(M_NOMFIN, len(alltrim(PCADES)))
              go bottom
              skip
              loop
            endif 

            if PCAGRP < M_GRPINI .or. PCAGRP > M_GRPFIN
              skip
              loop
            endif

            if PCAFOR < M_FORINI .or. PCAFOR > M_FORFIN
              skip
              loop
            endif

            ? " "
            ??  str(PCAMAT, 6, 0)
            ?? " "
            ?? pad(PCADES,37)
            ?? " "
            ?? transform(PCAGRP, "@E ####")
            ?? " "
            ?? transform(ASLD00->SLDDIS, "@E ######")
            ?? " "
            ?? replicate("_", 7)
            ?? " "
            ?? replicate("_", 13)
            ?? " "

            LN++

            skip

            M_ESC = inkey()

            if M_ESC = 27
                if susimp()
                   ? replicate("-", 80)
                   ? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                else
                    M_ESC = inkey()
                endif
            endif

        enddo

    enddo

    ? replicate("-", 80)

    eject

desliga1()

return "" 

****************
function LISPROE
****************

private M_TELA ,;
        M_OPC 

    M_TELA = savescreen(02, 05, 21, 77)
 
    do while .t.

       M_SPREC = { }

       rodape("LISTA","SALDOS",M_FAN,"EAGRO12","Mem: " + str(memory(0), 5),M_EMP) 

       store 0        to M_DESC,;
                         M_SLDCME

       store 1        to PG 

       store "C"      to M_TIPO

       store 0 to M_GRPINI ,;
                  M_GRPFIN

       store 0 to M_FORINI ,;
                  M_FORFIN

       store date() to M_DTAINV

       sombra(10, 20, 18, 50,_SOMBRA_)

       set color to GR+/W
         @ 10, 21 say "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø" 
         @ 11, 21 say "≥      Saldo no Dia:         ≥" 
         @ 12, 21 say "≥% Acrescimo Compra:         ≥" 
         @ 13, 21 say "≥Cpa/Med/Ven/cUsto :         ≥" 
         @ 14, 21 say "≥     Grupo Inicial:         ≥" 
         @ 15, 21 say "≥             Final:         ≥" 
         @ 16, 21 say "≥Fornecedor Inicial:         ≥" 
         @ 17, 21 say "≥             Final:         ≥" 
         @ 18, 21 say "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ" 
        SetColor(_COREDICAO_)
        @ 11, 42 get M_DTAINV
        @ 12, 42 get M_DESC   picture "###.##"
        @ 13, 42 get M_TIPO   picture "@!" valid(M_TIPO $ "CMVUF")
        @ 14, 42 get M_GRPINI picture "####"
        @ 15, 42 get M_GRPFIN picture "####"
        @ 16, 42 get M_FORINI picture "#######"
        @ 17, 42 get M_FORFIN picture "#######"
        read

        if lastkey() = 27
          return ""
        endif

        M_GRPINI = iif(M_GRPINI = 0,   0,M_GRPINI)
        M_GRPFIN = iif(M_GRPFIN = 0,9999,M_GRPFIN) 
        M_FORINI = iif(M_FORINI = 0,      0,M_FORINI)
        M_FORFIN = iif(M_FORFIN = 0,9999999,M_FORFIN) 

        M_OPC = decide("Confirma atualizaáÑo de saldo")

        if M_OPC = 1
          atualiza_inv(,ME_EMP,M_GRPINI,M_GRPFIN,M_FORINI,M_FORFIN)
        endif 

        select APCA00

        set relation to str(ME_EMP, 2, 0) + str(PCAMAT, 6, 0) into ASLD00 ,;
                     to str(PCAFOR, 7, 0)                     into AFOR00

        set order to 6

        go top

        dbseek(str(M_FORINI, 7, 0), .t.)

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

    store 0 to M_SLDANT ,;
               LN , PG  ,;
               M_GRPANT,;
               M_TOTFOR
                 
    do while !eof()
        
        store 0 to LN
            
        if M_SLDANT > 0
          ? space(90)
           ?? "A TRANSPORTAR .....      "
           ?? transform(M_SLDANT, "@E #####,###,###.##")
           LN = LN + 1
        endif

        PG = PG + 1

        if PG > 1
          eject
        endif
 
        ? cent_cab(AEMP00->EMPFAN,"INVENTARIO DE PRODUTOS  - " + substr(dtoc(M_DTAINV), 4, 5) + " " + iif(M_TIPO="C","COMPRA",iif(M_TIPO="M","MEDIO",iif(M_TIPO="V","VENDA",iif(M_TIPO="U","CUSTO","")))),"EAGRO12",132)
        ? cent_cab(transform(AEMP00->EMPCGC,"@R 999.999.999/9999-99"),"","PAG.: " + str(PG, 4, 0), 132)
        ? "*------*-----------------------------------------*--*----------*----------*----------*----------*-----------*----------*-----------*"
        ? "*CODIGO*        D E S C R I C A O                *UN*  MEDIO   *  COMPRA  *  VENDA   *  CUSTO   * QTDE      * UNITARIO *  TOTAL    *"
        ? "*------*-----------------------------------------*--*----------*----------*----------*----------*-----------*----------*-----------*"
*           999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX ###,###.## ###,###.## ###,###.## ###,###.## ###,###.### ###,###.## ####,###.##

        LN = LN + 5

        if M_SLDANT > 0
          ? space(94)
           ?? "DE TRANSPORTE .....  "
           ?? transform(M_SLDANT, "@E #####,###,###.##")
          LN = LN + 1
        endif

        do while !eof() .and. LN < 60

            if PCAGRP > M_GRPFIN
               go bottom
               skip
               loop
            endif

            if PCAFOR < M_FORINI .or. PCAFOR > M_FORFIN
              skip
              loop
            endif

            if PCAFOR # M_GRPANT
              if M_TOTFOR > 0
                ? space(94)
                ?? "SALDO FINAL FORNEC.  "
                ?? transform(M_TOTFOR, "@E #####,###,###.##")
                LN ++
                M_TOTFOR = 0
              endif
              ?
              ? "** " + str(PCAFOR, 7, 0) + " " + AFOR00->FORNOM
              ?
              LN += 3
              M_GRPANT = PCAFOR
            endif

            ?
              ?? str(PCAMAT, 7, 0)
              ?? " "
              ?? pad(PCADES, 41)
              ?? " "
              ?? pad(PCAUNI, 2)
              ?? " "
              ?? transform(ASLD00->SLDCME,"@E ###,###.##")
              ?? " "
              ?? transform(ASLD00->SLDCPA,"@E ###,###.##")
              ?? " "
              ?? transform(ASLD00->SLDPRC,"@E ###,###.##")
              ?? " "
              ?? transform(ASLD00->SLDCUS,"@E ###,###.##")
              ?? " "
              ?? transform(iif(M_DTAINV=date(),ASLD00->SLDDIS,ASLD00->SLDINV),"@E ###,###,###") 
              ?? " "
              if M_TIPO = "M"
                ?? transform(ASLD00->SLDCME,"@E ###,###.##")
                ?? " "
                ?? transfor((ASLD00->SLDCME * iif(M_DTAINV=date(),ASLD00->SLDDIS,ASLD00->SLDINV)),"@E ####,###.##")
                M_SLDANT = M_SLDANT + (ASLD00->SLDCME * iif(M_DTAINV=date(),ASLD00->SLDDIS,ASLD00->SLDINV))
                M_TOTFOR = M_TOTFOR + (ASLD00->SLDCME * iif(M_DTAINV=date(),ASLD00->SLDDIS,ASLD00->SLDINV))
              else
                if M_TIPO = "C"
                  ?? transform(ASLD00->SLDCPA,"@E ###,###.##")
                  ?? " "
                  ?? transform((ASLD00->SLDCPA * iif(M_DTAINV=date(),ASLD00->SLDDIS,ASLD00->SLDINV)),"@E ####,###.##")
                  M_SLDANT = M_SLDANT + (ASLD00->SLDCPA * iif(M_DTAINV=date(),ASLD00->SLDDIS,ASLD00->SLDINV))
                  M_TOTFOR = M_TOTFOR + (ASLD00->SLDCPA * iif(M_DTAINV=date(),ASLD00->SLDDIS,ASLD00->SLDINV))
                else
                  if M_TIPO = "V"
                    ?? transform(ASLD00->SLDPRC,"@E ###,###.##")
                    ?? " "
                    ?? transform((ASLD00->SLDPRC * iif(M_DTAINV=date(),ASLD00->SLDDIS,ASLD00->SLDINV)),"@E ####,###.##")
                    M_SLDANT = M_SLDANT + (ASLD00->SLDPRC * iif(M_DTAINV=date(),ASLD00->SLDDIS,ASLD00->SLDINV))
                    M_TOTFOR = M_TOTFOR + (ASLD00->SLDPRC * iif(M_DTAINV=date(),ASLD00->SLDDIS,ASLD00->SLDINV))
                  else
                    if M_TIPO = "F"  
                      ?? transform(ASLD00->SLDFAB,"@E ###,###.##")
                      ?? " "
                      ?? transform((ASLD00->SLDFAB * iif(M_DTAINV=date(),ASLD00->SLDDIS,ASLD00->SLDINV)),"@E ####,###.##")
                      M_SLDANT = M_SLDANT + (ASLD00->SLDCUS * iif(M_DTAINV=date(),ASLD00->SLDDIS,ASLD00->SLDINV))
                      M_TOTFOR = M_TOTFOR + (ASLD00->SLDCUS * iif(M_DTAINV=date(),ASLD00->SLDDIS,ASLD00->SLDINV))
                    else
                      ?? transform(ASLD00->SLDCUS,"@E ###,###.##")
                      ?? " "
                      ?? transform((ASLD00->SLDCUS * iif(M_DTAINV=date(),ASLD00->SLDDIS,ASLD00->SLDINV)),"@E ####,###.##")
                      M_SLDANT = M_SLDANT + (ASLD00->SLDCUS * iif(M_DTAINV=date(),ASLD00->SLDDIS,ASLD00->SLDINV))
                      M_TOTFOR = M_TOTFOR + (ASLD00->SLDCUS * iif(M_DTAINV=date(),ASLD00->SLDDIS,ASLD00->SLDINV))
                    endif  
                  endif
                endif
              endif 

            LN = LN + 1

            skip

            if inkey() = 27
                if susimp()
                  ? replicate("-", 132)
                  ? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                else
                  M_ESC = inkey()
                endif
            endif

        enddo

    enddo

    ? replicate("-", 132)
    ? space(94)
      ?? "SALDO FINAL .......  "
      ?? transform(M_SLDANT, "@E #####,###,###.##")

    eject

desliga1()

    restscreen(02, 05, 21, 77, M_TELA)

enddo 

return "" 

****************
function LISPROF
****************
parameters M_OPC

      rodape("LISTA","PRODUTO",M_FAN,"EAGRO12","Mem: " + str(memory(0), 5),M_EMP)

*          @ 11, 20 prompt  "Saldos de todos os Produtos   " position 01 highlite R/BG
*          @ 12, 20 prompt  "Produtos Com Saldo Positivo   " position 01 highlite R/BG
*          @ 13, 20 prompt  "Produtos Com Saldo Negativo   " position 22 highlite R/BG
*          @ 14, 20 prompt  "Produtos Com Saldo Zerado     " position 20 highlite R/BG
*          @ 15, 20 prompt  "NÑo Movimentados desde (MM/AA)" position 01 highlite R/BG
*          @ 16, 20 prompt  "Produtos Acima Estoque MAXIMO " position 10 highlite R/BG
*          @ 17, 20 prompt  "Produtos Abaixo Estoque MINIMO" position 25 highlite R/BG


        do case
           case M_OPC = 1
             lisslda("SALDO DE TODOS OS PRODUTOS")
           case M_OPC = 2
             lisslda("PRODUTOS COM SALDO POSITIVO")
           case M_OPC = 3
             lisslda("PRODUTOS COM SALDO NEGATIVO")
           case M_OPC = 4
             lisslda("PRODUTOS COM SALDO ZERADO  ")
           case M_OPC = 5
             store date() to M_DTA
             set color to GR+
             @ 24, 20 say "Entre com a data de partida:         "
            SetColor(_COREDICAO_)
             @ 24, 49 get M_DTA
             read
             if lastkey() = 27
               return ""
             endif
             lisslda("PRODUTOS NéO MOVIMENTADOS DESDE " + dtoc(M_DTA))
           case M_OPC = 6
             lisslda("PRODUTOS ACIMA DO ESTOQUE MAXIMO")
           case M_OPC = 7
             lisslda("PRODUTOS ABAIXO DO ESTOQUE MINIMO")
        endcase

return ""

****************
function LISSLDA
**************** 

parameters M_RELATO

private M_COD1  ,;
        M_COD2  ,; 
        M_GRP1  ,; 
        M_GRP2  ,;
        M_TIPO  ,;
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_TELA
 
    do while .t.

        rodape("LISTA","SALDOS",M_FAN,"EAGRO12","Mem: " + str(memory(0), 5),M_EMP) 

        store 0        to M_COD1,;
                          M_COD2,;
                          M_GRP1,;
                          M_GRP2

        sombra(16, 34, 19, 66,_SOMBRA_)
        set color to GR+/W
          @ 16, 34, 19, 66 box M_FRAME1a
          @ 17, 35 say "Fornecedor:          Grp:     "
          @ 18, 35 say "       Ate:          Grp:     "
        SetColor(_COREDICAO_)

        @ 17, 47 get M_COD1 picture "#######"  
        @ 18, 47 get M_COD2 picture "#######"   
        @ 17, 62 get M_GRP1 picture "####"     
        @ 18, 62 get M_GRP2 picture "####"     
        read

        if lastkey() = 27
            return ""
        endif

        M_COD1 = iif(M_COD1 = 0,      1,M_COD1)
        M_COD2 = iif(M_COD2 = 0,9999999,M_COD2) 
        M_GRP1 = iif(M_GRP1 = 0,      1,M_GRP1)
        M_GRP2 = iif(M_GRP2 = 0,   9999,M_GRP2) 

        select APCA00

        set relation to str(ME_EMP, 2, 0) + str(PCAMAT, 6, 0) into ASLD00 ,;
                     to str(PCAGRP, 4, 0)                     into AGRP00 ,;
                     to str(PCAFOR, 7, 0)                     into AFOR00

        go top

        set order to 4
 
        dbseek(str(M_GRP1, 4, 0),.t.)

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

    store 0 to PG , GR

    do while !eof()
                    
        store PG + 1 to PG

        if PG > 1
            eject
        endif

        ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE SALDOS ","EAGRO12",132) 
        ? cent_cab(M_DATA,alltrim(time() + " " + alltrim(M_RELATO)),"PAG.: " + str(PG, 4, 0), 132)
        ? "*-------*--------------------------------------------*-----*---------------------------*---*---------*--------------*--------------*"
        ? "* CODIG *        D E S C R I C A O                   *FORN * NOME                      *UNI*  SALDO  * PRC UNITARIO *VALOR ESTOQUE *"
        ? "*-------*--------------------------------------------*-----*---------------------------*---*---------*--------------*--------------*"
*           999,999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXX XXX #####.### ###,###,###.## ###,###,###.##

        store 5 to LN

        do while !eof() .and. LN < 60

          if PCAFOR < M_COD1 .or. PCAFOR > M_COD2
            skip
            loop
          endif

          if PCAGRP > M_GRP2
            go bottom
            skip
            loop
          endif

          if M_OPC != 1 
            if M_OPC = 2 
              if ASLD00->SLDDIS <= 0
                skip
                loop
              endif
            endif

            if M_OPC = 3 
              if ASLD00->SLDDIS >= 0
                skip
                loop
              endif
             endif

            if M_OPC = 4 
              if ASLD00->SLDDIS != 0
                skip
                loop
              endif
             endif

            if M_OPC = 5
              select AKAR00
              set order to 1
              dbseek(str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0) + dtos(M_DTA),.t.)

              lTemmov = .f.
              do while !eof()

                if !str(KARMAT, 6, 0) == str(APCA00->PCAMAT, 6, 0)
                  exit
                endif

                if KARFIS = 10000
                  skip
                  loop
                endif

                lTemmov = .t.
                exit
              enddo
              select APCA00

              if lTemmov
                skip 
                loop
              endif 

            endif

            if M_OPC = 6
              if ASLD00->SLDDIS <= ASLD00->SLDMAX
                skip
                loop
              endif
            endif

            if M_OPC = 7
              if ASLD00->SLDDIS >= ASLD00->SLDMIN
                skip
                loop
              endif
            endif
          endif

            if PCAGRP != GR
              ?
              ? cent_cab("","* * * " + alltrim(str(APCA00->PCAGRP, 4, 0) + " - " + AGRP00->GRPNOM) + " * * *","", 132)
              ?
              LN = LN + 3
              GR = PCAGRP
            endif

            ? " "
              ?? transform(PCAMAT,"@E ###,###")
              ?? " "
              ?? pad(PCADES,44)
              ?? " "
              ?? strzero(PCAFOR, 7, 0)
              ?? " "
              ?? pad(AFOR00->FORNOM, 27)
              ?? " "
              ?? PCAUNI
              ?? " "
              ?? str(ASLD00->SLDDIS, 9, 0)
              ?? " "
              ?? transform(ASLD00->SLDPRC,"@E ###,###,###.##")
              ?? " "
              ?? transfor((ASLD00->SLDPRC * ASLD00->SLDDIS),"@E ###,###,###.##")
  
            store LN + 1 to LN

            skip

            M_ESC = inkey()

            if M_ESC = 27
                if susimp()
                  ? replicate("-", 132)
                  ? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                else
                  M_ESC = inkey()
                endif
            endif

        enddo

    enddo

    ? replicate("-", 132)

    eject

desliga1()

enddo 

return "" 

****************
function PEGAEMP
****************
local A

parameters  M_MODO, M_ELEM, M_POSI

if str(lastkey(), 2, 0) $ "27"
  return 0
endif

if chr(lastkey()) $ " " // se confirma recebimento
  M_INVEMP[M_ELEM] = iif(substr(M_INVEMP[M_ELEM],1,1) == " ","*"," ") + right(M_INVEMP[M_ELEM],41)
  return 2
endif

return 2

****************
function LISPROG
****************

private M_TELA ,;
        M_OPC 

    M_TELA = savescreen(02, 05, 21, 77)
 
    do while .t.

       rodape("LISTA","SALDOS",M_FAN,"EAGRO12","Mem: " + str(memory(0), 5),M_EMP) 



       store 0        to M_DESC,;
                         M_SLDCME

       store 2        to PG 

       store "M"      to M_TIPO

       store 0 to M_GRPINI ,;
                  M_GRPFIN

       store 0 to M_FORINI ,;
                  M_FORFIN

       store date() to M_DTAINV

       store "S" to M_TIPREL
       M_SONEG  = " "
       M_IMPNBM = " "
       M_MOSICM = " "
       M_VALOR = 0
       M_QUALEMP = 0
       M_TOTICM = 0

       seexistesql("EMPINV")
       cSQL := "SELECT EMPNOM,EMPCOD FROM AEMP00"
       cSQL = cSQL + " where EMPNOM <> '' ORDER BY EMPNOM"
       dbusearea(.t.,"SQLMIX",cSQL,"EMPINV")
       go top

       M_INVEMP = { }
       M_INVCOD = { }

       do while !eof()
         aadd(M_INVEMP,"  " + EMPNOM)
         aadd(M_INVCOD,EMPCOD)
         skip
       enddo

       win(19,40,23,85,"(ESPACO) SELECIONA EMPRESA")

       set color to N/W,W+/N
       M_ACHO = achoice(20,40,22,85,M_INVEMP,,"PEGAEMP")
       set color to

       nQDEEMPRESA = 0    // quantidade de inventario
       nCodemp = 0

       for ABCD = 1 to len(M_INVEMP)
         if left(M_INVEMP[ABCD],1) == "*"
           nQDEEMPRESA ++
           nCodemp = iif(nCodemp=0,M_INVCOD[ABCD],nCodemp)
         endif
       next

      if nQDEEMPRESA = 0
        msgbox1("NAO FOI ESCOLHIDO NENHUMA EMPRESA")
        return ""
      endif

       set color to W/BG+
       nbox(9,21,20,53,"W/BG+",.t.)

         @ 10, 21 say "  Somente Negativos:            "
         @ 11, 21 say "       Saldo do Dia:            "
         @ 12, 21 say "   Valor do Estoque:            "
         @ 13, 21 say " Cpa/Med/Ven/cUsto : M          "
         @ 14, 21 say "              Grupo:            "
         @ 15, 21 say "          Forncedor:            "
         @ 16, 21 say "     Pagina Inicial:            "
         @ 17, 21 say "     Tipo Relatorio:            "
         @ 18, 21 say "       Imprimir NBM:            "
         @ 19, 21 say "        Mostra ICMS:            "
        SetColor(_COREDICAO_)

        @ 10, 42 get M_SONEG picture "@!" valid M_SONEG $ "SN"
        @ 11, 42 get M_DTAINV
        @ 12, 42 get M_VALOR picture "@R 999,999.99"
*        @ 13, 42 get M_TIPO picture "@!" valid(M_TIPO $ "CMVUF")
        @ 14, 42 get M_GRPINI picture "####"
        @ 15, 42 get M_FORINI picture "#######"
        @ 16, 42 get PG       picture "####"
        @ 17, 42 get M_TIPREL picture "@!" valid verinv01()
        @ 18, 42 get M_IMPNBM picture "@!" valid(M_IMPNBM $ "SN")
        @ 19, 42 get M_MOSICM picture "@!" valid(M_MOSICM $ "SN")
        read

        if lastkey() = 27
          return ""
        endif

        M_GRPINI = iif(M_GRPINI = 0,   0,M_GRPINI)
        M_GRPFIN = iif(M_GRPFIN = 0,9999,M_GRPFIN) 

        M_FORINI = iif(M_FORINI = 0,      0,M_FORINI)
        M_FORFIN = iif(M_FORFIN = 0,9999999,M_FORFIN)

        M_OPC = decide("Confirma atualizaáÑo de saldo")
 
        M_SPREC = { }


        if M_OPC = 1
          for ABCD = 1 to len(M_INVEMP)
            if left(M_INVEMP[ABCD],1) == "*"
              atualiza_inv(,M_INVCOD[ABCD],M_GRPINI,M_GRPFIN,M_FORINI,M_FORFIN)
            endif
          next
        endif

        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"APCA00","APCA00"})
        aadd(sqlCAMPO,"ASLD" + strzero(nCodemp,2) + ".SLDDIS")
        aadd(sqlCAMPO,"ASLD" + strzero(nCodemp,2) + ".SLDPRC")
        aadd(sqlCAMPO,"ASLD" + strzero(nCodemp,2) + ".SLDCME")
        aadd(sqlCAMPO,"ASLD" + strzero(nCodemp,2) + ".SLDCPA")
        aadd(sqlCAMPO,"PCAMAT")
        aadd(sqlCAMPO,"PCATRI")
        aadd(sqlCAMPO,"PCAIC0")
        aadd(sqlCAMPO,"PCAMAR")
        aadd(sqlCAMPO,"PCADES")
        aadd(sqlCAMPO,"PCAUNI")
        aadd(sqlCAMPO,"PCAGRP")
        aadd(sqlCAMPO,"AGRP00.GRPNOM")
        aadd(sqlRELATION,{"AGRP00","APCA00.PCAGRP","AGRP00.GRPCOD"})

        for ABCD = 1 to len(M_INVEMP)
          if left(M_INVEMP[ABCD],1) == "*"
            aadd(sqlCAMPO,"ASLD" + strzero(M_INVCOD[ABCD],2) + ".SLDINV AS SLDINV" + strzero(M_INVCOD[ABCD],2))
            aadd(sqlRELATION,{"ASLD00 ASLD" + strzero(M_INVCOD[ABCD],2),str(M_INVCOD[ABCD], 2, 0),"ASLD" + strzero(M_INVCOD[ABCD],2) + ".SLDEMP"})
            aadd(sqlRELATION,{"","ASLD" + strzero(M_INVCOD[ABCD],2) + ".SLDMAT","APCA00.PCAMAT"})
          endif
        next

        aadd(sqlCHAVE,"PCAINV <> 'N'")
        aadd(sqlCHAVE,"PCADES <> ''")

        if M_GRPINI > 0
          aadd(sqlCHAVE,"PCAGRP = " + aspas(str(M_GRPINI,4)))
        endif
        if M_FORINI > 0
          aadd(sqlCHAVE,"PCAFOR = " + aspas(str(M_FORINI,7)))
        endif

        if M_SONEG == "S"
          aadd(sqlCHAVE,"ASLD00.SLDINV < 0")
        endif

*        aadd(sqlCHAVE," APCA00.ATIVO = 'S'")

        aadd(sqlORDEM,"PCADES")
        sqlrelation()
        go top

        M_IMPRE = imprelaser()

        if M_IMPRE = "N"
          return ""
        endif

        ?? chr(15)                        && comprime

    store 0 to M_SLDANT ,;
               LN       ,;
               M_GRPANT ,;  
               M_TOTFOR 
               
// CALCULA VALOR

    M_S = strzero(nCodemp,2)

    do while !eof()

        M_SLDINV = 0

        for ABCD = 1 to len(M_INVEMP)
          if left(M_INVEMP[ABCD],1) == "*"
             M_S1 = strzero(M_INVCOD[ABCD],2)
             M_SLDINV += iif(HB_ISNIL(SLDINV&M_S1),0,SLDINV&M_S1)
          endif
        next

*           do case
*           case M_QUALEMP = 1
*             M_SLDINV = ASLD00->SLDINV
*           case M_QUALEMP = 2
*             M_SLDINV = ASLD10->SLDINV
*           case M_QUALEMP = 3
*             M_SLDINV = (ASLD00->SLDINV + ASLD10->SLDINV)
*           endcase

           if M_SONEG == "S"
             if M_SLDINV >= 0
               select APCA00
               skip
               loop
             endif
           else
             if M_DTAINV != date()
               if M_SLDINV <= 0
                 select APCA00
                 skip
                 loop
               endif
             else
               if M_SLDINV <= 0
                 select APCA00
                 skip
                 loop
               endif
             endif
           endif

              if M_TIPO = "M"
                M_SLDANT = M_SLDANT + (SLDCME * M_SLDINV)
                M_TOTFOR = M_TOTFOR + (SLDCME * M_SLDINV)
              else
                if M_TIPO = "C"
                  M_SLDANT = M_SLDANT + (SLDCPA * M_SLDINV)
                  M_TOTFOR = M_TOTFOR + (SLDCPA * M_SLDINV)
                else
                  if M_TIPO = "V"
                    M_SLDANT = M_SLDANT + (SLDPRC * M_SLDINV)
                    M_TOTFOR = M_TOTFOR + (SLDPRC * M_SLDINV)
                  else
                    if M_TIPO = "F"
                      M_SLDANT = M_SLDANT + (SLDFAB * M_SLDINV)
                      M_TOTFOR = M_TOTFOR + (SLDFAB * M_SLDINV)
                    else
                      M_SLDANT = M_SLDANT + (SLDCUS * M_SLDINV)
                      M_TOTFOR = M_TOTFOR + (SLDCUS * M_SLDINV)
                    endif
                  endif
                endif
              endif 

            skip

    enddo

if M_VALOR > 0
  M_PERC = M_VALOR / M_SLDANT 
else
  M_PERC = 1
endif

M_SLDANT = 0
M_TOTFOR = 0
M_SOTRIB = 0

// FINAL CALCULA VALOR

    select APCA00
    go top

    do while !eof()
        
        store 0 to LN

        if M_TIPREL = "A"            
          if M_SLDANT > 0
            ? space(90)
             ?? "A TRANSPORTAR .....      "
             ?? transform(M_SLDANT, "@E #####,###,###.##")
             LN = LN + 1
          endif
        endif

        if M_TIPREL = "A"
          if M_GRPANT > 0
            PG = PG + 1
            if PG > 2
              eject
            endif
          endif
        else
          if M_SLDANT > 0
            PG = PG + 1
            if PG > 2
              eject
            endif
          endif
        endif

        ? cent_cab(alltrim(AEMP00->EMPNOM),"INVENTARIO DE PRODUTOS  - " + dtoc(M_DTAINV) + " " + iif(M_TIPREL = "A",iif(M_TIPO="C","COMPRA",iif(M_TIPO="M","MEDIO",iif(M_TIPO="V","VENDA",iif(M_TIPO="U","CUSTO","")))) ,"") ,"EAGRO12",132)
        ? cent_cab(transform(AEMP00->EMPCGC,"@R 999.999.999/9999-99"),"","PAG.: " + str(PG, 4, 0), 132)
        if M_IMPNBM = "S"
            ? "+------+--------------------------------------------------------------------------+----------+--+-----------+----------+-----------+"
            ? "|CODIGO|        D E S C R I C A O                                                 |   NBM    |UN| QTDE      | UNITARIO |  TOTAL    |"
            ? "+------+--------------------------------------------------------------------------+----------+--+-----------+----------+-----------+"
*             999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXX XX ###,###.### ###,###.## ####,###.##
        else
          if M_MOSICM == "S"
            ? "+------+--------------------------------------------------------------------------+--+-----------+----------+-----------+----------+"
            ? "|CODIGO|        D E S C R I C A O                                                 |UN| QTDE      | UNITARIO |  TOTAL    |  ICMS    |"
            ? "+------+--------------------------------------------------------------------------+--+-----------+----------+-----------+----------+"
*             999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX ###,###.### ###,###.## ####,###.##
          else
            ? "+------+-------------------------------------------------------------------------------------+--+-----------+----------+-----------+"
            ? "|CODIGO|        D E S C R I C A O                                                            |UN| QTDE      | UNITARIO |  TOTAL    |"
            ? "+------+-------------------------------------------------------------------------------------+--+-----------+----------+-----------+"
*             999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX ###,###.### ###,###.## ####,###.##
          endif
          
        endif

        LN = LN + 5

        if M_TIPREL = "A"
          if M_SLDANT > 0
            ? space(94)
             ?? "DE TRANSPORTE .....  "
             ?? transform(M_SLDANT, "@E #####,###,###.##")
            LN = LN + 1
          endif 
        endif

        do while !eof() .and. LN < 55

          M_SLDINV = 0

          for ABCD = 1 to len(M_INVEMP)
            if left(M_INVEMP[ABCD],1) == "*"
               M_S1 = strzero(M_INVCOD[ABCD],2)
               M_SLDINV += iif(HB_ISNIL(SLDINV&M_S1),0,SLDINV&M_S1)  //  SLDINV&M_S1
            endif
          next

           if M_SONEG == "S"
             if M_SLDINV >= 0
               select APCA00
               skip
               loop
             endif
           else
             if M_DTAINV != date()
               if M_SLDINV <= 0
                 select APCA00
                 skip
                 loop
               endif
             else
               if M_SLDINV <= 0
                 select APCA00
                 skip
                 loop
               endif
             endif
           endif

            if M_TIPREL = "A"
              if PCAFOR # M_GRPANT
                if M_TOTFOR > 0
                  ? space(94)
                   ?? "TOT. DO FORNECEDOR.  "
                   ?? transform(M_TOTFOR, "@E #####,###,###.##")
                  M_TOTFOR = 0
                  LN++
                endif
                ?
                ? "** " + str(PCAFOR, 7, 0) + " " + AFOR00->FORNOM
                ?
                LN += 3
                M_GRPANT = PCAFOR
              endif
            endif

              ?
              ?? str(PCAMAT, 7, 0)
              ?? " "
              if M_IMPNBM = "S"
                ?? pad(alltrim(PCADES) + " - " + alltrim(PCAMAR), 74)
                ?? " "
                ?? transform(PCANCM, "@R 9999.99.99")
              else
                if M_MOSICM == "S"
                  ?? pad(alltrim(PCADES) + " - " + alltrim(PCAMAR), 74)
                else
                  ?? pad(alltrim(PCADES) + " - " + alltrim(PCAMAR), 85)
                endif
              endif
              ?? " "
              ?? pad(PCAUNI, 2)
              ?? " "
              ?? transform(M_SLDINV,"@E ###,###,###")
              ?? " "
              if M_TIPO = "M"

                M_VALINV = ((SLDCME * M_SLDINV)*M_PERC)
                M_SLDCME = M_VALINV / M_SLDINV
    
                if APCA00->PCATRI = 1 .OR. APCA00->PCATRI = 3
                  M_SOTRIB += M_VALINV
                endif

                ?? transform(M_SLDCME,"@E ###,###.##")
                ?? " "
                ?? transfor(M_VALINV,"@E ####,###.##")
                M_SLDANT = M_SLDANT + M_VALINV
                M_TOTFOR = M_TOTFOR + M_VALINV
              else
                if M_TIPO = "C"
                  ?? transform(SLDCPA,"@E ###,###.##")
                  ?? " "
                  ?? transform(SLDCPA * M_SLDINV,"@E ####,###.##")
                  M_SLDANT = M_SLDANT + (SLDCPA * M_SLDINV)
                  M_TOTFOR = M_TOTFOR + (SLDCPA * M_SLDINV)
                else
                  if M_TIPO = "V"
                    ?? transform(SLDPRC,"@E ###,###.##")
                    ?? " "
                    ?? transform(SLDPRC * M_SLDINV,"@E ####,###.##")
                    M_SLDANT = M_SLDANT + (SLDPRC * M_SLDINV)
                    M_TOTFOR = M_TOTFOR + (SLDPRC * M_SLDINV)
                  else
                    if M_TIPO = "F"
                      ?? transform(SLDFAB,"@E ###,###.##")
                      ?? " "
                      ?? transform((SLDFAB * M_SLDINV),"@E ####,###.##")
                      M_SLDANT = M_SLDANT + (SLDFAB * M_SLDINV)
                      M_TOTFOR = M_TOTFOR + (SLDFAB * M_SLDINV)
                    else
                      ?? transform(SLDCUS,"@E ###,###.##")
                      ?? " "
                      ?? transform((SLDCUS * M_SLDINV),"@E ####,###.##")
                      M_SLDANT = M_SLDANT + (SLDCUS * M_SLDINV)
                      M_TOTFOR = M_TOTFOR + (SLDCUS * M_SLDINV)
                    endif
                  endif
                endif
              endif 

              M_VALICM = 0
              if PCATRI = 1
                M_VALICM = (M_VALINV/100) * PCAIC0
              endif
              
              M_TOTICM += M_VALICM
              
              if M_MOSICM == "S"
                ?? transform(M_VALICM,"@R 9999,999.99")
              endif

            LN ++

            skip

            if inkey() = 27
                if susimp()
                  ? replicate("-", 132)
                  ? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                endif
            endif

        enddo

    enddo


    if M_TIPREL = "A"
      ? space(94)  
       ?? "TOT. DO FORNECEDOR.  "
       ?? transform(M_TOTFOR, "@E #####,###,###.##")
    endif
    ? replicate("-", 132)
    ? space(94)
      ?? "SALDO FINAL .......  "
      ?? transform(M_SLDANT, "@E #####,###,###.##")

    ? space(94)
      ?? "PRODUTOS TRIBUTADOS  "
      ?? transform(M_SOTRIB, "@E #####,###,###.##")

    if M_MOSICM == "S"
      ? space(94)
      ?? "VALOR DO ICMS .....  "
      ?? transform(M_TOTICM, "@E #####,###,###.##")
    endif


    ? chr(18)
    ?


  *  eject

desliga1(80)

restscreen(02, 05, 21, 77, M_TELA)

enddo 

return "" 


****************
function LISPROH
****************

private M_TELA ,;
        M_OPC3

    do while .t.

      rodape("LISTA","SALDO",M_FAN,"EAGRO12","Mem: " + str(memory(0), 5),M_EMP) 

      sombra(13, 23, 21, 54,_SOMBRA_)
      set color to N/BG
          @ 13, 23, 21, 54 box M_FRAME1     
      set color to W+/BG,W+/N
          @ 14, 24 prompt  "Saldos de todos os Produtos   " position 01 highlite R/BG
          @ 15, 24 prompt  "Produtos Com Saldo Positivo   " position 01 highlite R/BG
          @ 16, 24 prompt  "Produtos Com Saldo Negativo   " position 22 highlite R/BG
          @ 17, 24 prompt  "Produtos Com Saldo Zerado     " position 20 highlite R/BG
          @ 18, 24 prompt  "NÑo Movimentados desde (MM/AA)" position 01 highlite R/BG
          @ 19, 24 prompt  "Produtos Acima Estoque MAXIMO " position 10 highlite R/BG
          @ 20, 24 prompt  "Produtos Abaixo Estoque MINIMO" position 25 highlite R/BG
          menu to M_OPC
        set color to 

        M_TELA = savescreen(01, 01, 23, 79)
 
        do case
           case M_OPC = 0
             exit
           case M_OPC = 1
             lissldi("SALDO DE TODOS OS PRODUTOS")
           case M_OPC = 2
             lissldi("PRODUTOS COM SALDO POSITIVO")
           case M_OPC = 3
             lissldi("PRODUTOS COM SALDO NEGATIVO")
           case M_OPC = 4
             lissldi("PRODUTOS COM SALDO ZERADO  ")
           case M_OPC = 5
             store date() to M_DTA
             sombra(16, 19, 18, 57,_SOMBRA_)
             set color to W/RB
               @ 16, 19, 18, 57 box M_FRAME1a
               @ 17, 20 say "Entre com a data de partida:         "
              SetColor(_COREDICAO_)
               @ 17, 49 get M_DTA
               read
             set color to    
             if lastkey() = 27
               exit
             endif
             lissldi("PRODUTOS NAO MOVIMENTADOS DESDE " + dtoc(M_DTA))
           case M_OPC = 6
             lissldi("PRODUTOS ACIMA DO ESTOQUE MAXIMO")
           case M_OPC = 7
             lissldi("PRODUTOS ABAIXO DO ESTOQUE MINIMO")
        endcase

        restscreen(01, 01, 23, 79, M_TELA)

     enddo

return ""

****************
function LISPROI
****************


    store 0 to M_COD1, M_COD2,M_FORINI,M_FORFIN,M_PCAFOR,M_OPEINI, M_OPEFIN

    M_COMSUB = " "
    M_PCANCM = space(08)
     
    sombra(11, 25, 18, 54,_SOMBRA_)

    set color to B/W
      @ 11, 25 say     "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø"
      @ 12, 25 say     "≥  Grupo Inicial:            ≥"
      @ 13, 25 say     "≥          Final:            ≥"
      @ 14, 25 say     "≥     Fornecedor:            ≥"
      @ 15, 25 say     "≥            Ate:            ≥"
      @ 16, 25 say     "≥C/ Substituiá∆o:   (S/N/T)  ≥"
      @ 17, 25 say     "≥         NBM-SH:            ≥"
      @ 18, 25 say     "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
        SetColor(_COREDICAO_)

    @ 12, 43 get     M_COD1   picture "####"  
    @ 13, 43 get     M_COD2   picture "####"   
    @ 14, 43 get     M_PCAFOR picture "#######"       valid verpro11()
    @ 15, 43 get     M_FORFIN picture "#######"   
    @ 16, 43 get     M_COMSUB picture "@!"            valid M_COMSUB $ "SNT"
    @ 17, 43 get     M_PCANCM picture "@R 9999.99.99"
    read 

    if lastkey() = 27
      return ""
    endif

    M_COD1   = iif(M_COD1 = 0,   1,M_COD1)
    M_COD2   = iif(M_COD2 = 0,9999,M_COD2) 

    select APCA00

    set relation to str(ME_EMP, 2, 0) + str(PCAMAT, 6, 0) into ASLD00 ,;
                    str(PCAFOR, 7, 0)                     into AFOR00 ,;
                    str(PCAGRP, 4, 0)                     into AGRP00

    set order to 4
 
    dbseek(str(M_COD1, 4, 0),.t.)

    M_IMPRE = impresn()

    if M_IMPRE = "N"
      return ""
    endif

    ?? chr(18)

    store 0 to PG,GR

    do while !eof()

      PG++

      if PG > 1
        eject
      endif

      ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE PRODUTOS","EAGRO12",80)
      ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 80)
      ? "*------*----------------------------------------------*--*----------*-----*----*"
      ? "*CODIGO*              D E S C R I C A O               *UN* NBM-SH   * SUB *GRP *"
      ? "*------*----------------------------------------------*--*----------*-----*----*"
*         999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX 9999.99.99   X   ####

        store 5 to LN

        do while !eof() .and. LN < 59

            if str(PCAGRP, 4, 0) > str(M_COD2, 4, 0)
              go bottom
              skip
              loop
            endif 

            if M_FORINI > 0
              if PCAFOR <  M_FORINI .or. PCAFOR > M_FORFIN
                skip
                loop
              endif
            endif
            
            if !empty(M_PCANCM)
              if !PCANCM = M_PCANCM
                skip
                loop
              endif
            endif 

            if !M_COMSUB = "T"
              if M_COMSUB = "S"
                if !PCATRI = 4
                  skip
                  loop
                endif
              else
                if PCATRI = 4
                  skip
                  loop
                endif
              endif
            endif

            select APCA00

            if PCAGRP != GR
              ?
              ? cent_cab("","* * * " + alltrim(str(APCA00->PCAGRP, 4, 0) + " - " + AGRP00->GRPNOM) + " * * *","", 80)
              ?
              LN = LN + 3
              GR = PCAGRP
            endif

            ? " "
            ?? transform(str(PCAMAT, 6, 0),"@R 999999")
            ?? " "
            ?? pad(APCA00->PCADES, 46)
            ?? " "
            ?? pad(PCAUNI, 02)
            ?? " "
            ?? transform(PCANCM, "@R 9999.99.99")
            ?? "   "
            ?? iif(PCATRI = 4, "S", "N")
            ?? "   "
            ?? str(PCAGRP, 4, 0)

            LN++

            skip

            if inkey() = 27
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

    eject
 
    desliga1()

return "" 


****************
function LISSLDI
****************

parameters M_RELATO

private M_COD1  ,;
        M_COD2  ,; 
        M_GRP1  ,; 
        M_GRP2  ,;
        M_TIPO  ,;
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_TELA
 
 
    do while .t.

      rodape("LISTA","GRUPO",M_FAN,"EAGRO12","Mem: " + str(memory(0), 5),M_EMP) 

        store space(42) to M_COD1,;
                           M_COD2
        store 0         to M_GRP1,;
                           M_GRP2

        sombra(15, 20, 18, 69,_SOMBRA_)

        set color to GR+/W+
          @ 15, 20, 18, 69 box M_FRAME1a
          @ 16, 21 say    "Nome:                                           "
          @ 17, 21 say    " Ate:                                           "
        SetColor(_COREDICAO_)

        @ 16, 27 get M_COD1 picture "@!"     
        @ 17, 27 get M_COD2 picture "@!"     
        read

        if lastkey() = 27
          return ""
        endif

        M_GRP1 = iif(M_GRP1 = 0,     1,M_GRP1)
        M_GRP2 = iif(M_GRP2 = 0,  9999,M_GRP2) 
        M_COD1 = iif(empty(M_COD1)," "                                         ,M_COD1)
        M_COD2 = iif(empty(M_COD2),"ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ",M_COD2) 

        select APCA00

        set relation to str(ME_EMP, 2, 0) + str(PCAMAT, 6, 0) into ASLD00 

        go top

        set order to 7
 
        dbseek(M_COD1,.t.)

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

    store 0 to PG

    M_FABANT = " "

    do while !eof()

        PG++

        if PG > 1
          eject
        endif

        ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE SALDOS EM ORDEM DE FABRICANTE","EAGRO12",132) 
        ? cent_cab(M_DATA,M_RELATO,"PAG.: " + str(PG, 4, 0), 132)
        ? "*-------*------------------------------------------------------------*---*----------*------*------*------*--------*----------------*"
        ? "*  COD  *        D E S C R I C A O                                   *UNI* EMBALAGEM* MIN  * MAX  * SALDO*  DATA  *  R$ ULT COMPRA *"
        ? "*-------*------------------------------------------------------------*---*----------*------*------*------*--------*----------------*"
*           99999-9 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXX XXXXXXXXXX 999999 999999 999999 99/99/99 #####,###,###.##

        store 5 to LN

        do while !eof() .and. LN < 60
                    
          if left(PCAFAB,len(alltrim(M_COD2))) > left(M_COD2,len(alltrim(M_COD2)))
            go bottom
            skip
            loop
          endif 

          if M_OPC != 1 
            if M_OPC = 2 
              if ASLD00->SLDDIS <= 0
                skip
                loop
              endif
            endif
          endif

          if M_OPC != 1 
            if M_OPC = 3 
              if ASLD00->SLDDIS >= 0
                skip
                loop
              endif
             endif
          endif

          if M_OPC != 1 
            if M_OPC = 4 
              if ASLD00->SLDDIS != 0
                skip
                loop
              endif
             endif
          endif

          if M_OPC != 1 
            if M_OPC = 5
              if ASLD00->SLDDTS > M_DTA
                skip
                loop
              endif
            endif
          endif

          if M_OPC != 1 
            if M_OPC = 6
              if ASLD00->SLDDIS <= ASLD00->SLDMAX
                skip
                loop
              endif
            endif
          endif

          if M_OPC != 1 
            if M_OPC = 7
              if ASLD00->SLDDIS >= ASLD00->SLDMIN
                skip
                loop
              endif
            endif
          endif

          if !M_FABANT = PCAFAB
            ?
            ? "**** " + PCAFAB + "****"
            ?
            M_FABANT = PCAFAB
            LN += 3 
          endif

            ? " "
              ?? transform(str(PCAMAT, 6, 0),"@R 99999-9")
              ?? " "
              ?? pad(PCADES, 60)
              ?? " "
              ?? pad(PCAUNI, 3)
              ?? " "
              ?? pad(PCAREF, 10)
              ?? " "
              ?? str(int(ASLD00->SLDMIN), 6, 0)
              ?? " "
              ?? str(int(ASLD00->SLDMAX), 6, 0)
              ?? " "
              ?? str(int(ASLD00->SLDDIS), 6, 0)
              ?? " "
              ?? ASLD00->SLDDTE
              ?? " "
              ?? transform(ASLD00->SLDCPA,"@E #####,###,###.##")
  
            LN++

            skip

            if inkey() = 27
                if susimp()
                  ? replicate("-", 132)
                  ? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                endif
            endif

        enddo

    enddo

    ? replicate("-", 132)

    eject

desliga1()

enddo 

return "" 

*********************
function ATUALIZA_INV(TIPO,F_EMP,F_GRPINI,F_GRPFIN,F_FORINI,F_FORFIN)
*********************

if F_EMP = NIL
  F_EMP = ME_EMP
endif

private M_SLD


  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}
  aadd(sqlARQUI,{"AKAR00","PRODUTOS"})
  aadd(sqlCAMPO,"KARMAT")
  aadd(sqlCAMPO,"max(KARDTA) as KARDTA ")
*  aadd(sqlCHAVE,"KARMAT = " + str(PRODUTOS->KARMAT))
  cSQL = "KAREMP = " + str(F_EMP, 2, 0)
  cSQL = cSQL + " and KARDTA < " + aspas(formatdta(M_DTAINV))
  cSQL = cSQL + " and karfisn = '1.000'"

  if F_GRPINI > 0
    cSQL = cSQL + " and PCAGRP = " + aspas(str(F_GRPINI,4))
  endif

  if F_FORINI > 0
    cSQL = cSQL + " and PCAFOR = " + aspas(str(F_FORINI,7))
  endif

  cSQL = cSQL + " GROUP BY KARMAT"

  aadd(sqlCHAVE,cSQL)
  sqlrelation()

  sqlORDEM = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"ASLD00","UPDATE"}
  aadd(sqlCHAVE,{"SLDEMP",str(F_EMP,2)})
  aadd(sqlCAMPO,{"SLDINV",str1(0,2),.t.})
  executasql()

  select PRODUTOS

  go bottom
  nTotalrec = recno()
  go top
  oPBar2:Activate()

  do while !eof()

    oPBar2:Display( recno(),nTotalrec )

*    sqlRELATION = {}
*    sqlCAMPO = {}
*    sqlCHAVE =  {}
*    sqlARQUI = {}
*    sqlORDEM = {}
 *   aadd(sqlARQUI,{"AKAR00","AKARTM"})
 *   aadd(sqlCAMPO,"AKAR00.*")
*    aadd(sqlCHAVE,"KARMAT = " + str(PRODUTOS->KARMAT))
*    cDATA1 = "KAREMP = " + str(F_EMP, 2, 0)
*    cDATA1 = cDATA1 + " and KARDTA >= " + aspas(formatdta(PRODUTOS->KARDTA))
*    aadd(sqlCHAVE,cDATA1)
*    aadd(sqlORDEM,"KARMAT,KARDTA,KARFISN")
*    sqlrelation()

*    if !eof()
*      cDATA1 = KARDTA
*    else
*      cDATA1 = ctod("  /  /  ")
*    endif

    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}
    aadd(sqlARQUI,{"AKAR00","AKAR00"})
    aadd(sqlCAMPO,"KARMAT")
    aadd(sqlCAMPO,"KARDTA")
    aadd(sqlCAMPO,"KARFISN")
    aadd(sqlCAMPO,"KARQDE")
    aadd(sqlCAMPO,"KARVLI")
    aadd(sqlCAMPO,"KARICM")
    aadd(sqlCAMPO,"KARIPI")
    aadd(sqlCAMPO,"KARDSP")
    aadd(sqlCAMPO,"AFIS00.FISCOD")
    aadd(sqlCAMPO,"AFIS00.FISEST")
    aadd(sqlCAMPO,"AFIS00.FISMED")
    aadd(sqlRELATION,{"AFIS00","AFIS00.FISEMP",str(F_EMP,2,0)})
    aadd(sqlRELATION,{,"AFIS00.FISNOV","AKAR00.KARFISN"})

*    if !empty(cDATA1)
      aadd(sqlCHAVE,"KARDTA BETWEEN " + aspas(formatdta(PRODUTOS->KARDTA)) + " and " + aspas(formatdta(M_DTAINV)))
*    else
*      aadd(sqlCHAVE,"KARDTA <= " + aspas(formatdta(M_DTAINV)))
*    endif

    aadd(sqlCHAVE,"KAREMP = " + str(F_EMP, 2, 0))
    aadd(sqlCHAVE,"KARMAT = " + str(PRODUTOS->KARMAT, 6, 0))
    aadd(sqlORDEM,"KARDTA,KARFISN")
    sqlrelation()

    M_SLD    = 0
    M_SLDCME = 0
    M_SLDFIN = 0
    M_SLDCPA = 0
    M_FLAG1  = 0
    M_FLAG2  = 0
    k_ENTRADA = 0
    k_SAIDA  = 0
    n_TOTSAL = 0
    n_TOTVAL = 0


    do while !eof()

          select AKAR00

          calc_sldmed()

          if KARFISN $ "1.102#2.102"
            M_SLDCPA = ((KARVLI + KARDSP) / KARQDE)
          endif

          skip

        enddo

        */*/*/

 *       BUSCAREGISTRO("ASLD00",1,{str(F_EMP, 2, 0),str(M_NFSMAT[SQ,3],6,0)},"SELECT")

        sqlORDEM = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {"ASLD00","UPDATE"}
        aadd(sqlCHAVE,{"SLDEMP",str(F_EMP,2)})
        aadd(sqlCHAVE,{"SLDMAT",str(PRODUTOS->KARMAT,6)})
*        aadd(sqlCAMPO,{"SLDANT",str1(PRODUTOS->SLDCPA,2),.t.})
        aadd(sqlCAMPO,{"SLDINV",str1(M_SLD,2),.t.})
        aadd(sqlCAMPO,{"SLDFIN",str1(M_SLDFIN,2),.t.})
        if M_SLDCME > 0
          aadd(sqlCAMPO,{"SLDCME",str1(M_SLDCME,2),.t.})
        else
          seexistesql("ASLD00")
          cSQL := "SELECT SLDCUS FROM ASLD00 "
          cSQL = cSQL + " where SLDEMP = " + STR(F_EMP,2) + " and SLDMAT = " + str(PRODUTOS->KARMAT,6)
          dbusearea(.t.,"SQLMIX",cSQL,"ASLD00")
          aadd(sqlCAMPO,{"SLDCME",str1(ASLD00->SLDCUS,2),.t.})
        endif
        executasql()


*        if !TIPO = NIL
*          if M_SLD > 0
*            select AGRP00
*            dbseek(str(APCA00->PCAGRP, 4, 0))
*            do while .t.
*              if rlock()
*                replace VALOR with VALOR + (M_SLD*ASLD00->SLDCPA)
*                unlock
*                exit
*              endif
*            enddo
*          endif
*        else
*          if APCA00->PCAGRP > M_GRPFIN .or. APCA00->PCAGRP < M_GRPINI
*          else
*            if ASLD00->SLDCPA = 0 .and. ASLD00->SLDINV > 0
*              aadd(M_SPREC,APCA00->PCAMAT)
*            endif
*          endif
*        endif
*
*        select APCA00

 *       skip

      select PRODUTOS
      skip
      
    enddo

    oPBar2:DeActivate()


return "" 

***************
function OUTPRO
*************** 
parameters M_OPC,M_OPC1,M_OPC2

        rodape("PRECOS","PRODUTO",M_FAN,"EAGRO12","Mem: " + str(memory(0), 5),M_EMP)

*          @ 10, 14 prompt  "Altera Preco Custo" POSITION 14 HIGHLITE R/BG
*          @ 11, 14 prompt  "Altera Preco Venda" POSITION 14 HIGHLITE R/BG
*          @ 12, 14 prompt  "Altera Preco Geral" POSITION 14 HIGHLITE R/BG

        do case
           case M_OPC = 1
*             outproa()
           case M_OPC = 2
             outprob()
           case M_OPC = 3
*             outproc()
        endcase


return ""

***************
function OUTPROa
*************** 

    private M_PCAMAT ,;
            M_PCAPRC

    store space(50) to M_PCAREF

    do while .t.

        tlpro01()


        rodape("ALTERA","PRECO",M_FAN,"EAGRO12","Mem: " + str(memory(0), 5),M_EMP) 

        store 0         to M_PCAMAT ,;
                           M_SLDCUS ,;
                           M_SLDDSC ,;
                           M_SLDPRC

        SetColor(_COREDICAO_)
        @ 08, 20 get     M_PCAMAT picture "######"
        read

        if lastkey() = 27 .or. M_PCAMAT = 0
          exit
        endif

        select APCA00

        if !dbseek(str(M_PCAMAT, 6, 0))
          msg("* * * PRODUTO NéO CADASTRADO * * *")
          loop
        endif


        mspro01()

        select ASLD00

        ASLD00->(dbseek(str(ME_EMP, 2, 0) + str(M_PCAMAT, 6, 0)))

        if !rlock()
          msg("* * * (ASLD00) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_SLDCUS = SLDCUS
        M_SLDMAR = SLDMAR
        M_SLDPRC = SLDPRC
        SetColor(_COREDICAO_)

        @ 14, 20 get     M_PCAREF picture "@!"        valid verpro14()
        @ 16, 20 get     M_SLDCUS picture "#######.##"
        @ 17, 23 get     M_SLDMAR picture "##.####"   valid verpro09()
        @ 18, 20 get     M_SLDPRC picture "#######.##"
        read

        select ASLD00

        do while .t. 
          if rlock()
            replace SLDCUS with M_SLDCUS        
            replace SLDMAR with M_SLDMAR        
            replace SLDPRC with M_SLDPRC        
            unlock
            commit
            exit 
          else
            msg("* * * (ASLD00) REGISTRO SENDO USADO * * *")
          endif
          if lastkey()=27
            exit
          endif
        enddo

        APCA00->(dbseek(str(M_PCAMAT, 6, 0)))

        select APCA00

        do while .t. 
          if rlock()
            replace PCAREF with M_PCAREF        
            unlock
            commit
            exit 
          else
            msg("* * * (ASLD00) REGISTRO SENDO USADO * * *")
          endif
          if lastkey()=27
            exit
          endif
        enddo

        set order to 1

        msg("* * * PRECO ALTERADO * * *")

    enddo

return "" 

****************
function OUTPROb
****************

    private M_PCAMAT ,;
            M_PCAPRC



    do while .t.

        tlpro01()


        rodape("ALTERA","PRECO",M_FAN,"EAGRO12","Mem: " + str(memory(0), 5),M_EMP)

        store 0         to M_PCAMAT ,;
                           M_SLDCUS ,;
                           M_SLDDSC ,;
                           M_SLDPRC

        SetColor(_COREDICAO_)
        @ 06, 20 get     M_PCAMAT picture "######" F2 color _CORF2_ funcao "sele_arquivo('APCA00')" retorno @M_PCAMAT
        read

        if lastkey() = 27 .or. M_PCAMAT = 0
          exit
        endif

        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"APCA00","APCA00"})
        aadd(sqlCAMPO,"ASLD00.SLDFAB")
        aadd(sqlCAMPO,"ASLD00.SLDCUS")
        aadd(sqlCAMPO,"ASLD00.SLDMAR")
        aadd(sqlCAMPO,"ASLD00.SLDPRC")
        aadd(sqlCAMPO,"ASLD00.SLDCPA")
        aadd(sqlCAMPO,"ASLD00.SLDCME")

        aadd(sqlCAMPO,"ASLD00.SLDMAX")
        aadd(sqlCAMPO,"ASLD00.SLDMIN")

        aadd(sqlCAMPO,"ASLD00.SLDDTE")
        aadd(sqlCAMPO,"ASLD00.SLDDTP")
        aadd(sqlCAMPO,"ASLD00.SLDINV")
        aadd(sqlCAMPO,"ASLD00.SLDDIS")

        aadd(sqlCAMPO,"APCA00.*")
        aadd(sqlRELATION,{"ASLD00",str(ME_EMP, 2, 0),"ASLD00.SLDEMP"})
        aadd(sqlRELATION,{"","ASLD00.SLDMAT","APCA00.PCAMAT"})
        aadd(sqlCHAVE,"PCAMAT = " + str(M_PCAMAT, 6, 0))
        if !sqlrelation()
          msg("* * * PRODUTO NéO CADASTRADO * * *")
          loop
        endif

       mspro01()

       BUSCAREGISTRO("ASLD00",1,{str(ME_EMP, 2, 0),str(M_PCAMAT,6,0)},"SELECT")

       M_SLDCUS = SLDCUS
       M_SLDMAR = SLDMAR
       M_SLDPRC = SLDPRC
       M_SLDDSC = SLDDSC

       SetColor(_COREDICAO_)
       @ 18, 20 get M_SLDPRC picture "#######.##"
       read

        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {"ASLD00","UPDATE"}
        aadd(sqlCHAVE,{"SLDEMP",str(ME_EMP,2)})
        aadd(sqlCHAVE,{"SLDMAT",str(M_PCAMAT,6)})
        aadd(sqlCAMPO,{"SLDCUS",str1(M_SLDCUS,2),.t.})
        aadd(sqlCAMPO,{"SLDMAR",str1(M_SLDMAR,2),.t.})
        aadd(sqlCAMPO,{"SLDPRC",str1(M_SLDPRC,2),.t.})
        aadd(sqlCAMPO,{"SLDDSC",str1(M_SLDDSC,2),.t.})
        executasql()

       msg("* * * PRECO ALTERADO * * *")

    enddo

return "" 

****************
function OUTPROC
****************

  private M_OPC 


     store 0 to M_GRPINI,;
                M_GRPFIN

     store 0         to M_FORINI,;
                        M_FORFIN,; 
                        M_PERCEN 

     sombra(11, 25, 15, 61,_SOMBRA_)

     set color to B/W
       @ 11, 25 say    "                                     " 
       @ 12, 25 say    "      Grupo Inicial:                 " 
       @ 13, 25 say    " Fornecedor Inicial:                 " 
       @ 14, 25 say    "             Margem:                 " 
       @ 15, 25 say    "                                     " 
        SetColor(_COREDICAO_)

     @ 12, 46 get     M_GRPINI picture "####"
     @ 13, 46 get     M_FORINI picture "#####"
     @ 14, 46 get     M_PERCEN picture "###.##"
     read

     if lastkey() = 27
       return ""
     endif

     M_OPC = decide("Confirma Processo de Alteracao de Precos")

     if M_OPC != 1
       return ""
     endif

     select APCA00

     go top

     do while !eof()


        if M_GRPINI > 0 
          if !str(PCAGRP,4) == str(M_GRPINI,4)
            skip
            loop
          endif
        endif

        if M_FORINI > 0 
          if !str(PCAFOR,7) == str(M_FORINI,7)
            skip
            loop
          endif
        endif

        msw("* * * Pro: " + PCAREF + "  Fab: " + " Gru: " + str(PCAGRP, 4, 0) + " For: " + str(PCAFOR, 7, 0) + " * * *")

        ASLD00->(dbseek(str(1, 2, 0) + str(APCA00->PCAMAT, 6, 0)))

        select ASLD00

        do while .t. 
          if rlock()
            replace SLDMAR with M_PERCEN
            if SLDCUS > SLDCPA
              replace SLDPRC with SLDCUS + ((SLDCUS * .01) * M_PERCEN)
            else
              replace SLDPRC with SLDCPA + ((SLDCPA * .01) * M_PERCEN)
            endif
            unlock
            commit
            exit 
          else
            msg("* * * (ASLD00) REGISTRO SENDO USADO * * *")
          endif
          if lastkey()=27
            exit
          endif
        enddo

        select APCA00

        skip

     enddo

     msg("* * * FIM DO PROCESSO DE ALTERACAO DE PRECOS * * *")

return "" 

**************** 
function TLPRO01 
**************** 


  nbox(3, 05, 20, 74,"W/W+",.t.)
  setcolor("B/W")
    @ 04, 06 say     " Produto    :                    Pes:                  Uni:         "
    @ 05, 06 say     " DescriáÑo  :                                                       "
    @ 06, 06 say     " Origem     :       Codigo de Barras:                 Cest:         "
    @ 07, 06 say     "                                                                    "
    @ 08, 06 say     " NBM - SH   :                    Inv:                               "
    @ 09, 06 say     " % Base ICMS:   )        1)         2)                 For:         "
    @ 10, 06 say     " % Aliq ICMS:   )        1)         2)                 Ipi:         "
    @ 11, 06 say     " Classific. :                                                       "
    @ 12, 06 say     " TributaáÑo :       Com:         Grp:         Esc:     Csp:   Cou:  "
    @ 13, 06 say     " Marca      :                                 Emb:     Lis:         "
    @ 14, 06 say     " Páo Fabrica:            Páo Compra:            Dta Compra:         "
    @ 15, 06 say     " Páo Custo  :            Páo MÇdio :            Dta Pagto :         "
    @ 16, 06 say     " % Margem   :            Est M†ximo:            Saldo Inve:         "
    @ 17, 06 say     " Páo Venda  :            Est Minimo:            Saldo Hoje:         "
    @ 18, 06 say     " C¢d CBNEF  :                                                       "
    @ 19, 06 say     "                                                                    "

   set color to


return ""

****************
function TLPRO02                      && monta tela do movimento
****************

  sombra(03, 02, 20, 77, _SOMBRA_)

  set color to I
    @ 03, 02 say     "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø"
    @ 04, 02 say     "≥ Fornecedor:         a          Nome:                                     ≥"
    @ 05, 02 say     "≥ Telefone  :                  Cidade:                          Estado:    ≥"
    @ 06, 02 say     "√ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¥"
    @ 07, 02 say     "≥ Pro  ≥    D e s c r i c a o       ≥ Compra ≥  Qtde ≥  Custo   ≥  Venda   ≥"
    @ 08, 02 say     "√ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¥"
    @ 09, 02 say     "≥      ≥                            ≥        ≥       ≥          ≥          ≥"
    @ 10, 02 say     "≥      ≥                            ≥        ≥       ≥          ≥          ≥"
    @ 11, 02 say     "≥      ≥                            ≥        ≥       ≥          ≥          ≥"
    @ 12, 02 say     "≥      ≥                            ≥        ≥       ≥          ≥          ≥"
    @ 13, 02 say     "≥      ≥                            ≥        ≥       ≥          ≥          ≥"
    @ 14, 02 say     "≥      ≥                            ≥        ≥       ≥          ≥          ≥"
    @ 15, 02 say     "≥      ≥                            ≥        ≥       ≥          ≥          ≥"
    @ 16, 02 say     "√ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥"
    @ 17, 02 say     "≥D a t a :             Encargos:            Fabri:            Dup:         ≥"
    @ 18, 02 say     "≥Desconto:             Impostos:            % Mar:            Dis:         ≥"
    @ 19, 02 say     "≥Condicao:             Frete   :            Final:            Csg:         ≥"
    @ 20, 02 say     "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
  set color to

return ""


****************
function TLPRO03                      && monta tela do movimento
****************

  sombra(03, 02, 20, 77, _SOMBRA_)

  set color to I
    @ 03, 02 say     "⁄ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø"
    @ 04, 02 say     "≥ Pro  ≥                            ≥ Compra ≥ Saldo ≥  Custo   ≥  Venda   ≥"
    @ 05, 02 say     "√ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¥"
    @ 06, 02 say     "≥      ≥                            ≥        ≥       ≥          ≥          ≥"
    @ 07, 02 say     "≥      ≥                            ≥        ≥       ≥          ≥          ≥"
    @ 08, 02 say     "≥      ≥                            ≥        ≥       ≥          ≥          ≥"
    @ 09, 02 say     "≥      ≥                            ≥        ≥       ≥          ≥          ≥"
    @ 10, 02 say     "≥      ≥                            ≥        ≥       ≥          ≥          ≥"
    @ 11, 02 say     "√ƒƒ¬ƒƒƒ¡ƒ¬ƒƒƒƒƒ¬ƒƒƒƒƒ¬ƒƒƒƒƒ¬ƒƒƒƒƒ¬ƒƒ¡ƒƒ¬ƒƒƒƒƒ≈ƒƒƒƒƒ¬ƒ¡ƒƒƒ¬ƒƒƒƒƒ¬¡ƒƒƒƒ¬ƒƒƒƒƒ¥"
    @ 12, 02 say     "≥M ≥ Jan ≥ Fev ≥ Mar ≥ Abr ≥ Mai ≥ Jun ≥ Jul ≥ Ago ≥ Set ≥ Out ≥ Nov ≥ Dez ≥"
    @ 13, 02 say     "√ƒƒ≈ƒƒƒƒƒ≈ƒƒƒƒƒ≈ƒƒƒƒƒ≈ƒƒƒƒƒ≈ƒƒƒƒƒ≈ƒƒƒƒƒ≈ƒƒƒƒƒ≈ƒƒƒƒƒ≈ƒƒƒƒƒ≈ƒƒƒƒƒ≈ƒƒƒƒƒ≈ƒƒƒƒƒ¥"
    @ 14, 02 say     "≥V ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥"
    @ 15, 02 say     "≥C ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥"
    @ 16, 02 say     "√ƒƒ¡ƒƒƒƒƒ¡ƒƒƒƒƒ¡ƒƒƒƒƒ¡ƒƒƒƒƒ¡ƒƒƒƒƒ¡ƒƒƒƒƒ¡ƒƒƒƒƒ¡ƒƒƒƒƒ¡ƒƒƒƒƒ¡ƒƒƒƒƒ¡ƒƒƒƒƒ¡ƒƒƒƒƒ¥"
    @ 17, 02 say     "≥D a t a :             Encargos:            Fabri:            Dup:         ≥"
    @ 18, 02 say     "≥Desconto:             Impostos:            % Mar:            Dis:         ≥"
    @ 19, 02 say     "≥Condicao:             Frete   :            Final:            Csg:         ≥"
    @ 20, 02 say     "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
  set color to

return ""

****************
function VERORIG
****************

LOCAL scr, clr
LOCAL nPoslin1, nPoslin2, nPoscol1, nPoscol2

nPoslin1 = 6
nPoslin2 = 13

nPoscol1 = 12
nPoscol2 = 75

parameters F_HELP,F_OQUE

if lastkey(,.t.) = 5
  return .t.
endif


lDesligaRedraw = .t.


lTela = savescreen(nPoslin1,nPoscol1-1,nPoslin2+2,nPoscol2+1)

M_TIPOS = { }

aadd(M_TIPOS,"0. Nacional, Exceto as indicadas nos codigo 3 a 5              ")
aadd(M_TIPOS,"1. Estrangeira, Inportacao direta                              ")
aadd(M_TIPOS,"2. Estrangeira, Adquirida mercado interno                      ")
aadd(M_TIPOS,"3. Nacional, Conteudo importacao superior a 40%                ")
aadd(M_TIPOS,"5. Nacional, Conteudo importacao inferior a 40%                ")
aadd(M_TIPOS,"6. Estrangeira, Importacao direta, sem similar nacional        ")
aadd(M_TIPOS,"7. Estrangeira, Adquirida mercado interno, sem similar nacional")
aadd(M_TIPOS,"8. Estrangeira, Conteudo importacao Superior a 70%             ")

PosAcho = 1

for A = 1 to len(M_TIPOS)
  if left(M_TIPOS[A],1) == F_HELP
    PosAcho = A
    exit
  endif
next

scr := SaveScreen(nPoslin1,nPoscol1-1,nPoslin2+2,nPoscol2+1 )
clr := SetColor( 'N/W*,GR+/B*,,,GR+/B' )

Wvw_DrawBoxRaised(,nPoslin1+1, nPoscol1,nPoslin2+1, nPoscol2 )

TIPO1 = achoice(nPoslin1+1,nPoscol1,nPoslin2+1,nPoscol2,M_TIPOS,,,PosAcho)
setcolor("")

setColor( clr )
RestScreen(nPoslin1,nPoscol1-1,nPoslin2+2,nPoscol2+1, scr )

if lastkey() = 27
  lDesligaRedraw = .f.
  return .t.
endif

F_HELP = left(M_TIPOS[TIPO1],1)

if F_OQUE == "I" // so muda na inclusao
  if F_HELP $ "1238"
    M_PCARG0 = 0
    M_PCARG1 = 70
    M_PCARG2 = 100
    M_PCAIC0 = 0
    M_PCAIC1 = 4
    M_PCAIC2 = 4
  endif
endif

lDesligaRedraw = .f.
return .t.

******************
function ADICIONAL
******************
local ltela := savescreen(01,02,23,80)

local cInicIMG4ORIG := Wvt_SaveScreen(3, 05, 22, 76)  // salva a tela
local scr := SaveScreen(3, 05, 22, 76 )

edinfcli()

RestScreen(3, 05, 22, 76, scr )
Wvt_RestScreen(3, 05, 22, 76, cInicIMG4ORIG,.t. )


return .t.


*******************
function VESI_GRAVA
*******************

if lAlterou
  keyboard(chr(23))
else
  set key 27 to
  keyboard chr(27)
endif

****************
function IMPTEL3(aInfo)
****************

local nKey := inkey()

do case
case nKey == 27
  if lAlterou
    keyboard chr(23)
  endif
  lSaida = .t.
  return ME_EXIT
case nKey == 23
  lGrava = .t.
  lSaida = .t.
  return ME_EXIT
case !chr(nKey) $ "wertyuiop[]asdfghjkl;'zxcvbnm,./1234567890-=!@#$%^*()_+)" .and. !chr(nKey) $ upper("wertyuiop[]asdfghjkl;'zxcvbnm,./1234567890-=!@#$%^*()_+)")
  return ME_IGNORE
endcase

lAlterou = .t.

return ME_DEFAULT

*****************
function EDINFCLI
*****************

private TESTE,MENSAGEM,M_MEMO,M_ARQ,lSaida,lGrava

nbox(3, 05, 20, 74,"W/W+",.t.)

set cursor on

lSaida = .t.
lGrava = .f.
lAlterou = .f.

do while .t.

  M_ARQ = "&_PATH_\USR\MENSAGEM\APCA00\" + strzero(APCA00->PCAMAT,8) + ".MSG"

  M_MEMO1 = memoread("&M_ARQ")
  
  keyboard chr(5)
  setcolor("GR+/R,GR+/R")
   @ 03, 05 say padc("DADOS ADICIONAIS  -  <Ctrl><W> - Grava",70)
   setcolor("W+/R")
   @ 03, 43 say "Ctrl"
   @ 03, 49 say "W"
   setcolor("I")

  M_MEMO = memoedit(M_MEMO1,4, 06, 20, 74,.t.,"IMPTEL3",70)

  memowrit("&M_ARQ",M_MEMO)
  if lSaida
    exit
  endif
  lSaida = .t.
enddo

*set key 27 to

if lGrava
  memowrit("&M_ARQ",M_MEMO)
endif

setcolor("")

*set key 290 to

return ""
****************  
function EDPRO01(F_TIPO)
****************                  

    setcolor("N/W*")
      @ 09, 20  say AEMP00->EMPEST
      @ 10, 20  say AEMP00->EMPEST
    SetColor(_COREDICAO_)

    @ 04, 44  get     M_PCAPLQ picture "#####.##"
    @ 04, 66  get     M_PCAUNI picture "@!"

    @ 05, 20  get     M_PCADES picture "@!"


    @ 06, 20  get     M_PCAORI  picture "9" valid verorig(@M_PCAORI,F_TIPO)
    @ 06, 44  get     M_PCABAR picture "@!"
    @ 06, 66  get     M_PCACLA  picture "@R 9999999"


    @ 08, 20  get     M_PCANCM picture "@R 9999.99.99" valid verncm(M_PCANCM)
    @ 08, 44  get     M_PCAINV picture "@!" valid(iif(!M_PCAINV $ "SN", msg("* * * Lista este produto no Inventario? (Sim ou Nao) * * *"), .t.))

    @ 09, 24  get     M_PCARG0 picture "###.##"
    @ 09, 34  get     M_PCARG1 picture "###.##"
    @ 09, 45  get     M_PCARG2 picture "###.##"
    @ 09, 66  get     M_PCAFOR picture "#######" F2 color _CORF2_ valid verpro03() funcao "sele_arquivo('AFOR00')" retorno @M_PCAFOR

    @ 10, 25  get     M_PCAIC0 picture "##.##"
    @ 10, 35  get     M_PCAIC1 picture "##.##"
    @ 10, 46  get     M_PCAIC2 picture "##.##"
    @ 10, 69  get     M_PCAIPI picture "##.##"
    @ 11, 20  get     M_REFERE01 picture "@!" valid class()

*   @ 11, 66  get     M_REFERENC picture "@!" valid M_REFERENC $ "SN"

    @ 12, 20  get     M_PCATRI picture "#"         valid verpro01(@M_PCATRI)
    @ 12, 31  get     M_PCACOM picture "##.##"
    @ 12, 44  get     M_PCAGRP picture "####" F2 color _CORF2_ valid verpro04() funcao "sele_arquivo('AGRP00')" retorno @M_PCAGRP
    @ 12, 57  get     M_PCAESC picture "#"         valid verpro13(@M_PCAESC)
    @ 12, 66  get     M_PCACSP picture "@!"        valid verpro05(@M_PCACSP,AEMP00->EMPEST)
    @ 12, 73  get     M_PCACOU picture "@!"        valid verpro05(@M_PCACOU,"OU")

    @ 13, 20  get     M_PCAMAR picture "@!"
    @ 13, 57  get     M_PCAEMB picture "999"
    @ 13, 66  get     M_PCALIS picture "@!"

    @ 14, 20  get     M_SLDFAB picture "#######.##"
    @ 15, 20  get     M_SLDCUS picture "#######.##"
    @ 16, 20  get     M_SLDMAR picture "#####.####" valid verpro09()
    @ 17, 20  get     M_SLDPRC picture "#######.##"

    @ 14, 43  get     M_SLDCPA picture "#######.##"
    @ 15, 43  get     M_SLDCME picture "#######.##"
    @ 16, 43  get     M_SLDMAX picture "#######.##"
    @ 17, 43  get     M_SLDMIN picture "#######.##"

    @ 14, 66  get     M_SLDDTE
    @ 15, 66  get     M_SLDDTP
    @ 16, 66  get     M_SLDINV picture "########"
    @ 17, 66  say     M_SLDDIS picture "########"
    @ 18, 20  get     M_CBNEF  picture "@!" F2 color _CORF2_ valid vercbnef() funcao "sele_arquivo('CBNEF')" retorno @M_CBNEF
    read
 
return ""

*****************
function VERCBNEF
*****************

if lastkey() = 5
  return .t.
endif

if empty(M_CBNEF)
  sele_arquivo('CBNEF')
  M_CBNEF = left(CODCBNEF,8)
  return .f.
endif

if !BUSCAREGISTRO("CBNEF",1,{aspas(M_CBNEF)},"SELECT")
  msg("* * * BENEFICIO N«O CADASTRADO * * *")
  return .f.
endif

msg("* * * " + rtrim(DESCRICAO) + " * * *")

keyfun()

return .t.
***************
function VERNCM
***************

parameters F_HELP

if lastkey() = 5
  return .t.
endif

if !BUSCAREGISTRO("ANCM00",1,{aspas(F_HELP)},"SELECT")
  msg("* * * CODIGO NCM NAO CADASTRADO * * *")
  return .f.
endif

return .t.

**************
function CLASS
**************

  if alltrim(M_REFERE01) $ "CORE#TUBES#ESPECIALIZADAS#PEDIATRIC#DIVERSOS" .or. empty(M_REFERE01)
    return .t.
  endif

  msgbox1({"Preencha em branco ou com","CORE, TUBES, ESPECIALIZADAS","PEDIATRIC OU DIVERSOS"})

return .f.

******************
function TECLANDO2
******************

parameters M_TAM ,;
           M_LIN ,;
           M_COL ,;
           M_COR

private M_NOM ,;
        M_LOC

      M_NOM = M_TAM
      M_LOC = 1

      set color to &M_COR

      lAchei = .t.

        do while M_LOC <= len(M_TAM)
          @ M_LIN, (1 + M_COL) say M_NOM
          @ M_LIN, (M_LOC + M_COL) say ""

          tecla = inkey(0)
          if str(tecla,2) $ "13#27# 3"
            exit
          endif
          lNao = .f.
          do case
             case str(tecla,2) $ " 5# 8"
               M_LOC = M_LOC - 1
               M_LOC = iif(M_LOC=0,1,M_LOC)
               M_NOM = stuff(M_NOM,M_LOC,1,"")
               M_NOM = stuff(M_NOM,M_LOC,1," ")
               lNao = .t.
             case str(tecla,2) $ " 4"
                M_LOC = M_LOC + 1
                M_LOC = iif(M_LOC>len(M_TAM),len(M_TAM),M_LOC)
                lNao = .t.
             case str(tecla,2) $ "19"
                M_LOC = M_LOC - 1
                M_LOC = iif(M_LOC<1,1,M_LOC)
                loop
             case str(tecla,2) $ " 7"
                M_NOM = left(M_NOM,M_LOC-1) + right(M_NOM,(len(M_NOM)-(M_LOC))) + " "
                loop
             case str(tecla,2) $ " 1"
                M_LOC = 1
                loop
             case str(tecla,2) $ " 6"
                M_LOC = len(M_TAM)
                loop
          endcase

          if lNao == .f.
            M_NOM = stuff(M_NOM,M_LOC,1,upper(chr(tecla)))
            M_LOC = M_LOC + 1
          endif

          lAchei = .f.

          do case
             case  alltrim(M_NOM) == left("CORE",len(alltrim(M_NOM)))
                M_NOM = "CORE"
                lAchei = .t.
             case  alltrim(M_NOM) == left("TUBEES",len(alltrim(M_NOM)))
                M_NOM = "TUBES"
                lAchei = .t.
             case  alltrim(M_NOM) == left("ESPECIALIZADAS",len(alltrim(M_NOM)))
                M_NOM = "ESPECIALIZADAS"
                lAchei = .t.
             case  alltrim(M_NOM) == left("PEDIATRIC",len(alltrim(M_NOM)))
                M_NOM = "PEDIATRIC"
                lAchei = .t.
             case  alltrim(M_NOM) == left("DIVERSOS",len(alltrim(M_NOM)))
                M_NOM = "DIVERSOS"
                lAchei = .t.
             otherwise
               M_NOM = left(M_NOM,M_LOC-1) + space(len(M_TAM)+1-M_LOC)
               lAchei = .f.
          endcase

          set color to "I"
          @ M_LIN, (1 + M_COL) say M_NOM
          set color to ""
enddo

return M_NOM

**************** 
function MSPRO01
****************

MS = strzero(ME_EMP,2)

  select APCA00 

  setcolor("N/W*")

    @ 09, 20 say AEMP00->EMPEST
    @ 10, 20 say AEMP00->EMPEST

    @ 04, 20 say     transform(str(PCAMAT, 6, 0),"@R 99999-9")
    @ 04, 44 say     PCAPLQ picture "#####.##"
    @ 04, 66 say     PCAUNI picture "@!"

    @ 05, 20 say     PCADES picture "@!"

    @ 06, 20 say     PCAORI
    @ 06, 44 say     PCABAR picture "@!"
    @ 06, 66 say     PCACLA picture "@R 9999999"


    @ 08, 20 say     PCANCM picture "@R 9999.99.99"
    @ 08, 44 say     PCAINV picture "@!"

    @ 09, 24 say     PCARG0 picture "###.##"
    @ 09, 34 say     PCARG1 picture "###.##"
    @ 09, 45 say     PCARG2 picture "###.##"
    @ 09, 66 say     PCAFOR picture "#######"

    @ 10, 25 say     PCAIC0 picture "##.##"
    @ 10, 35 say     PCAIC1 picture "##.##"
    @ 10, 46 say     PCAIC2 picture "##.##"
    @ 10, 69 say     PCAIPI picture "##.##"
    @ 11, 20 say     REFERE01
*   @ 11, 66 say     REFERENC picture "@!"

    @ 12, 20 say     PCATRI picture "#"
    @ 12, 31 say     PCACOM picture "##.##"
    @ 12, 44 say     PCAGRP picture "####"
    @ 12, 57 say     PCAESC picture "#"
    @ 12, 66 say     PCACSP picture "@!"
    @ 12, 73 say     PCACOU picture "@!"

    @ 13, 20 say     PCAMAR picture "@!"
    @ 13, 57 say     PCAEMB picture "999"
    @ 13, 66 say     PCALIS picture "@!"

    @ 14, 20 say     SLDFAB picture "#######.##"
    @ 15, 20 say     SLDCUS picture "#######.##"
    @ 16, 20 say     SLDMAR picture "#####.####"
    @ 17, 20 say     SLDPRC picture "#######.##"

    @ 14, 43 say     SLDCPA picture "#######.##"
    @ 15, 43 say     SLDCME picture "#######.##"
    @ 16, 43 say     SLDMAX picture "#######.##"
    @ 17, 43 say     SLDMIN picture "#######.##"

    @ 14, 66 say     SLDDTE
    @ 15, 66 say     SLDDTP
    @ 16, 66 say     SLDINV picture "########"
    @ 17, 66 say     SLDDIS picture "########"

    */*/*/
  set color to

return ""


****************
function GRPRO01(cACAO)
****************

sqlORDEM = {}
sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"APCA00",cACAO}

aadd(sqlCHAVE,{"PCAMAT",str(M_PCAMAT,6)})

if !cACAO $ "#DELETE#SELECT#"
     aadd(sqlCAMPO,{"PCAMAT",str(M_PCAMAT),.t.})
     aadd(sqlCAMPO,{"PCAGRP",str(M_PCAGRP),.t.})
     aadd(sqlCAMPO,{"PCAFOR",str(M_PCAFOR),.t.})
     aadd(sqlCAMPO,{"PCATRI",str(M_PCATRI),.t.})
     aadd(sqlCAMPO,{"PCAESC",str(M_PCAESC),.t.})
     aadd(sqlCAMPO,{"PCARG0",str1(M_PCARG0,2),.t.})
     aadd(sqlCAMPO,{"PCARG1",str1(M_PCARG1,2),.t.})
     aadd(sqlCAMPO,{"PCARG2",str1(M_PCARG2,2),.t.})
     aadd(sqlCAMPO,{"PCAIC0",str1(M_PCAIC0,2),.t.})
     aadd(sqlCAMPO,{"PCAIC1",str1(M_PCAIC1,2),.t.})
     aadd(sqlCAMPO,{"PCAIC2",str1(M_PCAIC2,2),.t.})
     aadd(sqlCAMPO,{"PCAIPI",str1(M_PCAIPI,2),.t.})
     aadd(sqlCAMPO,{"PCAPLQ",str1(M_PCAPLQ,2),.t.})
     aadd(sqlCAMPO,{"PCADOS",str1(M_PCADOS,2),.t.})
     aadd(sqlCAMPO,{"PCAPRB",str1(M_PCAPRB,2),.t.})
     aadd(sqlCAMPO,{"PCACOM",str1(M_PCACOM,2),.t.})

     aadd(sqlCAMPO,{"PCABAR",M_PCABAR,.t.})
     aadd(sqlCAMPO,{"PCADES",M_PCADES,.t.})
     aadd(sqlCAMPO,{"PCAREF",M_PCAREF,.t.})
     aadd(sqlCAMPO,{"PCANCM",M_PCANCM,.t.})
     aadd(sqlCAMPO,{"PCADSC",M_PCADSC,.t.})
     aadd(sqlCAMPO,{"PCAUNI",M_PCAUNI,.t.})
     aadd(sqlCAMPO,{"PCACSP",M_PCACSP,.t.})
     aadd(sqlCAMPO,{"PCACOU",M_PCACOU,.t.})
     aadd(sqlCAMPO,{"PCAEMB",M_PCAEMB,.t.})
     aadd(sqlCAMPO,{"PCAMAR",M_PCAMAR,.t.})

     aadd(sqlCAMPO,{"PCALIS",M_PCALIS,.t.})
     aadd(sqlCAMPO,{"PCAFAB",M_PCAFAB,.t.})
     aadd(sqlCAMPO,{"PCAINV",M_PCAINV,.t.})
     aadd(sqlCAMPO,{"REFERE01",M_REFERE01,.t.})
     aadd(sqlCAMPO,{"REFERENC",M_REFERENC,.t.})
     aadd(sqlCAMPO,{"PCALOT",M_PCALOT,.t.})
     aadd(sqlCAMPO,{"PCAORI",M_PCAORI,.t.})
     aadd(sqlCAMPO,{"PCACLA",M_PCACLA,.t.})
  endif

  if !executasql()
    return .f.
  endif

  return .t.


**************** 
function GRPRO02(cACAO,cEMPRESA)
****************  

if cEMPRESA = NIL
  cEMPRESA = ME_EMP
endif

sqlORDEM = {}
sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"ASLD00",cACAO}

aadd(sqlCHAVE,{"SLDMAT",str(M_PCAMAT,6)})
aadd(sqlCHAVE,{"SLDEMP",str(cEMPRESA,2)})

if !cACAO $ "#DELETE#SELECT#"
  aadd(sqlCAMPO,{"SLDEMP",str(cEMPRESA),.t.})
  aadd(sqlCAMPO,{"SLDMAT",str(M_PCAMAT),.t.})
  aadd(sqlCAMPO,{"SLDINV",str1(M_SLDINV,3),.t.})
  aadd(sqlCAMPO,{"SLDDIS",str1(M_SLDDIS,3),.t.})
  aadd(sqlCAMPO,{"SLDRES",str1(M_SLDRES,2),.t.})
  aadd(sqlCAMPO,{"SLDMIN",str1(M_SLDMIN,3),.t.})
  aadd(sqlCAMPO,{"SLDMAX",str1(M_SLDMAX,3),.t.})
  aadd(sqlCAMPO,{"SLDCPA",str1(M_SLDCPA,2),.t.})
  aadd(sqlCAMPO,{"SLDCME",str1(M_SLDCME,2),.t.})
  aadd(sqlCAMPO,{"SLDMAR",str1(M_SLDMAR,4),.t.})
  aadd(sqlCAMPO,{"SLDCUS",str1(M_SLDCUS,2),.t.})
  aadd(sqlCAMPO,{"SLDPRC",str1(M_SLDPRC,2),.t.})
  aadd(sqlCAMPO,{"SLDDSC",str1(M_SLDDSC,2),.t.})
  aadd(sqlCAMPO,{"SLDFAB",str1(M_SLDFAB,2),.t.})
  aadd(sqlCAMPO,{"SLDDTP",formatdta(M_SLDDTP),.t.})
endif

executasql()

return ""

*****************
function VERPRO01
*****************

LOCAL scr, clr
LOCAL aBlocks := {}

parameters F_HELP,F_OQUE

if lastkey(,.t.) = 5
  return .t.
endif


lTela = savescreen(7,39,22,76)
M_TIPOS = { }

lDesligaRedraw = .t.

aadd(M_TIPOS,"1. Tributada Dentro e Fora do Estado    ")
aadd(M_TIPOS,"2. Isento Dentro e Fora do Estado       ")
aadd(M_TIPOS,"3. Com ReduáÑo Dentro ou Fora do Estado ")
aadd(M_TIPOS,"4. Substituicao Tributaria              ")
aadd(M_TIPOS,"5. 041 - nao tributada                  ")

PosAcho = 1

for A = 1 to len(M_TIPOS)
  if left(M_TIPOS[A],1) == str(F_HELP,1)
    PosAcho = A
    exit
  endif
next

scr := SaveScreen( 7+4,38-18,17,65 )
clr := SetColor( 'N/W*,GR+/B*,,,GR+/B' )

Wvw_DrawBoxRaised(, 8+4, 40-18, 16, 64 )

TIPO1 = achoice(8+4,40-18,16,64,M_TIPOS,,,PosAcho)
setcolor("")

setColor( clr )
RestScreen( 7+4,38-18,17,65, scr )

if lastkey() = 27
  lDesligaRedraw = .f.
  return .t.
endif

F_HELP = val(left(M_TIPOS[TIPO1],1))

lDesligaRedraw = .f.
return .t.

*****************
function VERPRO03
*****************

if lastkey() = 5
  return .t.
endif

if M_PCAFOR = 0
 sele_arquivo("AFOR00")
 M_PCAFOR = FORCOD
 return .f.
endif

if !BUSCAREGISTRO("AFOR00",1,{str(M_PCAFOR,5,0)},"SELECT")
  msg("* * * FORNECEDOR NAO CADASTRADO * * *")
  keyfun()
  M_PCAFOR = 0
  return .f.
endif

msg("* * * " + alltrim(FORNOM) + " * * *")

return .t.

*****************
function VERPRO04
*****************

if lastkey() = 5
  return .t.
endif

if M_PCAGRP = 0
  sele_arquivo('AGRP00')
  M_PCAGRP = GRPCOD
  return .f.
endif

if !BUSCAREGISTRO("AGRP00",1,{str(M_PCAGRP,4,0)},"SELECT")
  msg("* * * GRUPO N?O CADASTRADO * * *")
  keyfun()
  return .f.
endif

msg("* * * " + rtrim(GRPNOM) + " * * *")

keyfun()

return .t.

******************
function VERPRO05
******************

parameters M_CVE ,;
           M_EST

    if lastkey() = 5 .or. M_CVE = " "
        return .t.
    endif

    select ACVE00

    if !dbseek(M_EST + M_CVE)
      msg("* * * CONVENIO NéO CADASTRADO * * *")
      return .f.
    endif

    msg("* * * " + rtrim(CVENOM) + " * * *")


return .t.    

*****************
function VERPRO09
*****************

* M_SLDPRC = M_SLDCUS + ((M_SLDCUS * .01) * M_SLDMAR)

return .t.

*****************
function VERPRO10
*****************

private M_PCASEQ

  select APCA00

  dbseek(str(M_PCAMAT, 6, 0),.t.)

  M_PCASEQ = PCAMAT

  do while .t.

     if dbseek(str(M_PCASEQ, 6, 0))
       M_PCASEQ = M_PCASEQ + 1
       if M_PCASEQ = 999999
         msg("* * * CODIGOS ESGOTADOS * * *")
         M_PCAMAT = 0
         return .f.
       endif
       loop
     endif

     exit

  enddo

  if M_PCASEQ > 0
    M_PCAMAT = M_PCASEQ
  endif

return .f.

****************** 
function  VERPRO11
******************

  if lastkey() = 5
    return .t.
  endif
        
  if M_PCAFOR > 0
     M_FORINI = M_PCAFOR
     M_FORFIN = val(left(str(M_PCAFOR, 7, 0), 5) + str(99, 2, 0))
  endif

return .t.

****************** 
function  VERPRO13
******************

LOCAL scr, clr

parameters F_HELP,F_OQUE

if lastkey(,.t.) = 5
  return .t.
endif

lTela = savescreen(7,39,22,76)
M_TIPOS = { }

lDesligaRedraw = .t.
  
aadd(M_TIPOS,"2. Sem Credito Icms Isento   ")
aadd(M_TIPOS,"3. Sem Credito Icms Outros   ")
aadd(M_TIPOS,"5. Com Credito Icms          ")

PosAcho = 1

for A = 1 to len(M_TIPOS)
  if left(M_TIPOS[A],1) == str(F_HELP,1)
    PosAcho = A
    exit
  endif
next

scr := SaveScreen( 7+4,57,15,87 )
clr := SetColor( 'N/W*,GR+/B*,,,GR+/B' )

Wvw_DrawBoxRaised(, 8+4, 59, 14, 86 )

TIPO1 = achoice(8+4,59,14,86,M_TIPOS,,,PosAcho)
setcolor("")

setColor( clr )
RestScreen( 7+4,57,15,87, scr )

if lastkey() = 27
  lDesligaRedraw = .f.

  return .t.
endif

F_HELP = val(left(M_TIPOS[TIPO1],1))

lDesligaRedraw = .f.
return .t.

****************** 
function  VERPRO14
******************

if M_PCAREF = "+"
  M_PCAREF = pad(APCA00->PCADES, 50)
  return .f.
endif

return .t.

****************** 
function  VERPRO15
******************

  if lastkey() = 5
    return .t.
  endif

  if M_SLDDSC > 100
    msg("* * * DESCONTO NAO PODE SER MAIOR QUE 100 % * * *")
    return .f.
  endif

return .t.

*****************
function VERPRO16 
*****************

if M_PCAFOR > 0
   M_FORFIN = val(left(str(M_PCAFOR, 7, 0), 5) + str(99, 2, 0))
endif

return .t.    

*****************
function VERPRO17
*****************

if !M_ORDEM $ "AC"
  msg("* * * VALIDO SOMENTE (C)ODIGO OU (A)LFABETICA * * *")
  return .f.
endif

return .t.

*****************
function VERINV01
*****************

if lastkey() = 5
  return .t.
endif

if !M_TIPREL $ "SA"
  msg("* * * (A)nalitico = Fornecedor/Alfabetica (S)intetico = Alfabetica * * *")
  return .f.
endif

return .t.
******************
function SETAPRO_B
******************


  set cursor off

  set color to R+
    @ 24, 25 say       "(ENTER) Observacoes (ESC) Saida"
  set color to 

  set color to GR+
    @ 24, 26 say "ENTER"
    @ 24, 46 say "ESC"
  set color to 

return ""

******************
function SETAPRO_C
******************

  set cursor off

  set color to R+
    @ 24, 25 say       "(ENTER) Observacoes (ESC) Saida"
  set color to 

  set color to GR+
    @ 24, 26 say "ENTER"
    @ 24, 46 say "ESC"
  set color to 

return ""


******************
function ALTOBSPRO
******************

    M_SLDDFA = ASLD00->SLDDFA
    M_SLDDES = ASLD00->SLDDES
    M_SLDCPG = ASLD00->SLDCPG

    M_SLDENC = ASLD00->SLDENC
    M_SLDIMP = ASLD00->SLDIMP
    M_SLDFRE = ASLD00->SLDFRE
 
    M_SLDFAB = ASLD00->SLDFAB
    M_SLDMAR = ASLD00->SLDMAR
    M_SLDFNL = ASLD00->SLDFNL

    M_SLDDTP = ASLD00->SLDDTP
    M_SLDDIS = ASLD00->SLDDIS
    M_SLDINV = ASLD00->SLDINV 

      SetColor(_COREDICAO_)

      @ 17, 13 get M_SLDDFA
      @ 18, 13 get M_SLDDES picture "@!@S11"
      @ 19, 13 get M_SLDCPG picture "@!@S11"

      @ 17, 35 get M_SLDENC picture "@!"  
      @ 18, 35 get M_SLDIMP picture "@!"  
      @ 19, 35 get M_SLDFRE picture "@!"  
 
      @ 17, 53 get M_SLDFAB picture "#######.##"
      @ 18, 53 get M_SLDMAR picture "#####.####"
      @ 19, 53 get M_SLDFNL picture "#######.##"

      @ 17, 69 get M_SLDDTP
      @ 18, 69 get M_SLDDIS picture "########"
      @ 19, 69 get M_SLDINV picture "########"
      read
   set color to N/W,W+/N

   select ASLD00

   if dbseek(M_CHAVE)
     do while .t.
       if rlock()
         replace SLDDFA with M_SLDDFA
         replace SLDDES with M_SLDDES
         replace SLDCPG with M_SLDCPG

         replace SLDENC with M_SLDENC
         replace SLDIMP with M_SLDIMP
         replace SLDFRE with M_SLDFRE
 
         replace SLDFAB with M_SLDFAB
         replace SLDMAR with M_SLDMAR
         replace SLDFNL with M_SLDFNL

         replace SLDDTP with M_SLDDTP
         replace SLDDIS with M_SLDDIS
         replace SLDINV with M_SLDINV 
         unlock   
         commit
         exit
       else
         msg("* * * (ASLD00) REGISTRO SENDO USADO * * *") 
       endif
       if lastkey()=17
         exit
       endif
     enddo
   endif

return ""

*****************
function ALERTNEW(cMsg,aOptions,nBeginOption,lMsg,nTimeOut,data1,data2,tipo,cor)
*****************

*If AlertNew("Demonstracao de como se usa a ALERTNEW...;Use funcoes proprias,;substituindo a inkey e colocando uma sombra...;Pode substituir facilmente a funcao ALERT do Clipper!!!",{"Continuar..."},,,12) == 1
*End

*If AlertNew("Espera 7 Segundos;e retorna default = 2;<ESC> Retorna 0...",{"Sim","Nao"},2,,7) == 1
*End

*If AlertNew("Agora, So se escolher uma opcao..",{"Sim","Nao","Cancelar"},2) == 1
// Agora, So se Apertar Enter
*End

*AlertNew("",{"Sem","Mensagem","Alguma","As","Vezes","Ç","Util"})

*AlertNew("Mensagem Apenas;Nao fica esperando...",,,.T.)

Local nTop,  nLeft, nBottom, nRight
Local nRows, nCols
Local aRow,  aCol
Local nCtr,  nLenOpt, nMaxText, cPart, cTextTmp

Local aText := {}, nCursor := SetCursor(0)

if tipo = NIL
  tipo = "N"
endif

if COR = NIL
  Private cCorMoldura := "B/B"
  Private cCorNormal  := "W/B"
  Private cCorMsg     := "W+/B"
  Private cCorInverso := "w+/r"
else
  Private cCorMoldura := "G/G"
  Private cCorNormal  := "N/G"
  Private cCorMsg     := "W+/G"
  Private cCorInverso := "w+/r"
endif

Private nOutTime := If(nTimeOut==Nil,nTimeOut:=0,nTimeOut)

Save Screen

if lMsg==nil
  lMsg:=.f.
end

If aOptions == Nil
  aOptions := {" Ok "}
Else
  For nCtr:=1 To Len(aOptions)
    If Left(aOptions[nCtr],1)  != " " .And. ;
      Right(aOptions[nCtr],1) != " "
      aOptions[nCtr]=" "+aOptions[nCtr]+" "
    End
  Next nCtr
End

nLenOpt:=0

For nCtr:=1 To Len(aOptions)
  nLenOpt+=Len(aOptions[nCtr])
Next nCtr

If !Empty(cMsg)
  cMsg+=";"+If(!lMsg,";","")
End

cTextTmp:=""

nMaxText := 0

For nCtr:=1 To Len(cMsg)

  cPart:=SubStr(cMsg,nCtr,1)

  If cPart==";"
    aAdd(aText,cTextTmp)
    If Len(cTextTmp) > nMaxText
      nMaxText:=Len(cTextTmp)
    End
    cTextTmp:=""
  Else
    cTextTmp+=cPart
  End

Next nCtr

if !lMsg
  aAdd(aText,cTextTmp)
end

aCol:={(MaxCol()-nLenOpt)/2}

For nCtr:=2 To Len(aOptions)
  aAdd(aCol,aCol[nCtr-1]+Len(aOptions[nCtr-1]))
Next nCtr

nMaxText:=Max(nMaxText,nLenOpt)
nMaxText+=If(nMaxText/2==Int(nMaxText/2),0,1)

nRows   :=Len(aText)+if(lMsg,2,2)
nCols   :=nMaxText+4

nTop    :=(24-nRows)/2+if(lMsg,1,0)
nLeft   :=(80-nCols)/2-2
nBottom :=(24-nRows)/2+nRows-1+if(lMsg,1,0)
nRight  :=(80-nCols)/2+nCols-1

sombra(nTop,nLeft,nBottom,nRight,_SOMBRA_)

@ nTop,nLeft,nBottom,nRight Box "€€€€€€€€ " Color cCorMoldura

For nCtr:=1 To Len(aText)
  @ nTop+nCtr,nLeft+2 Say PadC(aText[nCtr],nMaxText+2) Color cCorMsg
Next nCtr

nBeginOption := If( ValType(nBeginOption) != "N", 1, nBeginOption )
nBeginOption := If( nBeginOption<1 .Or. nBeginOption>Len(aOptions), 1, nBeginOption )

nopt:=0

if TIPO == "N"
  if !lMsg
    nOpt := Opcoes(nBottom-1,aCol,aOptions,nBeginOption)
  end
else
  save get to M_GET1234

  aCol = int((((nRight+1 - nLeft) - 17)/2))

  SetColor(_COREDICAO_)
  @ nBottom-1, nLeft+aCol get data1
  @ nBottom-1, col()+1 get data2
  read
  setcolor("")

  restore get from M_GET1234
endif

if !lMsg
  restore screen
end

SetCursor(nCursor)

Return nOpt

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

