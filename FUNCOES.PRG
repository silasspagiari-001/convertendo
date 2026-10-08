#command @ <row> , <col>  GET <var> ;
            [<clauses,...>]         ;
            PASSWORD                ;
            [<moreClauses,...>]     ;
                                    ;
      => @ <row> , <col>  GET <var> ;
            [<clauses>]             ;
            SEND reader := {|oGet|  ;
                 GetPassword(oGet)} ;
                 [<moreClauses>]

#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)
#xtranslate :fileHandle   => :cargo\[1\]
#xtranslate :fileLine     => :cargo\[2\]
#xtranslate :lineOffset   => :cargo\[3\]
#xtranslate FTell(<fHandle>) => FSeek(<fHandle>, 0, 1)

*********************
function dbuseareaSQL(fTipo,fRDD,fcSQL,fCARQUIVO)
*********************

nHan := FCreate("sql2.txt")   // a tentar CRIAR.
FWrite( nHan, fcSQL )
FClose( nHan )   // Fechamos o Arquivo.

nMotivoSQL = ""

seexistesql(fCARQUIVO)
dbusearea(.t.,"SQLMIX",fcSQL,fCARQUIVO)
if lastrec() = 0
  return .f.
endif

return .t.

********************
function CALC_DUPGER(TIPO)  // MODULO PARA CALCULO DE DUPLICATAS GERAL
********************
  lOCAL aBlocks2 := {}


  private M_PED[06] ,;
          M_VCT[06] ,;
          M_FER[08] ,;
          M_PR[06]  ,;
          M_PE[06]
  declare M_PED[06] ,;
          M_VCT[06] ,;
          M_FER[08] ,;
          M_PR[06]  ,;
          M_PE[06]
  private M_TOTDP ,;
          R, S    ,;
          M_S     ,;
          M_RES   ,;
          M_PARC  ,;
          M_TELA  ,;
          M_VALOR

  store 0 to M_VLR ,;
             M_RES

  if M_GERCPG > 2 .and. M_GERCPG <= 20
    return .f.
  endif

  for R = 1 to 6
     M_PED[ R ] = 0
     M_VCT[ R ] = ctod("  /  /  ")
  next &&  R

  if !BUSCAREGISTRO("ACPG00",1,{str(M_GERCPG,3,0)},"SELECT")
    msg("* * * CONDICAO PAGAMENTO NAO CADASTRADA * * *")
    return .f.
  endif

  M_VALOR = M_GERVLN

  select ACPG00

M_PARC    = CPGPAR

for S = 1 to 6
  M_S = strzero(S, 1, 0)
  M_PE[ S ] = CPGPE&M_S
  M_PR[ S ] = CPGPR&M_S
next && S

for R = 1 to M_PARC            && calcula as duplicatas
  M_PED[ R ] =  round((M_VALOR * .01) * M_PE[ R ], 2)
  M_VCT[ R ] = M_GERDTE + M_PR[ R ]
  M_VLR = M_VLR + round(M_PED[ R ], 2)   && somas as duplicatas
next &&  R

M_RES = ( M_VALOR - M_VLR )
M_PED[ M_PARC ] = M_PED[ M_PARC ] + M_RES

for S = 1 to 6
  M_S = strzero(S, 1, 0)
  M_GERDP&M_S = M_PED[ S ]
  M_GERVC&M_S = M_VCT[ S ]
next && S

  M_TELA = savescreen(06, 43, 20, 75)

  aAdd( aBlocks2, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
  aAdd( aBlocks2, {|| WVT_DRAWBOXRAISED( 08, 44, 19, 72) } )
  aAdd( aBlocks2, {|| WVT_DRAWBOXGROUP( 08, 44, 10, 72,{0,,0,})})
  aAdd( aBlocks2, {|| WVT_DRAWBOXGROUP( 17, 44, 19, 72,{0,0,,0})})
  aAdd( aBlocks2, {|| WVT_DRAWBOXGROUP( 08, 44, 16, 48,{0,,,0})})
  aAdd( aBlocks2, {|| WVT_DRAWBOXGROUP( 08, 57, 19, 72,{0,0,,0})})
  aLastPaint6 := WvtSetBlocks( aBlocks2 )

  do while .t.

    nbox(08, 44, 19, 72,"W/W+",.t.)
    setcolor("N/W")
       @ 09, 45 say     "DUP   VCTO       VALOR     "
       @ 10, 45 say     "                           "
       @ 11, 45 say     " 01                        "
       @ 12, 45 say     " 02                        "
       @ 13, 45 say     " 03                        "
       @ 14, 45 say     " 04                        "
       @ 15, 45 say     " 05                        "
       @ 16, 45 say     " 06                        "
       @ 17, 45 say     "                           "
       @ 18, 45 say     "Pedido   R$                "
     set color to

     setcolor("N/W*")
       @ 18, 60 say M_GERVLN   picture "#########.##"
     SetColor(_COREDICAO_)
     @ 11, 49 get     M_GERVC1
     @ 11, 60 get     M_GERDP1 picture "#########.##"
     @ 12, 49 get     M_GERVC2
     @ 12, 60 get     M_GERDP2 picture "#########.##"
     @ 13, 49 get     M_GERVC3
     @ 13, 60 get     M_GERDP3 picture "#########.##"
     @ 14, 49 get     M_GERVC4
     @ 14, 60 get     M_GERDP4 picture "#########.##"
     @ 15, 49 get     M_GERVC5
     @ 15, 60 get     M_GERDP5 picture "#########.##"
     @ 16, 49 get     M_GERVC6
     @ 16, 60 get     M_GERDP6 picture "#########.##"
     read

     M_TOTDP = (M_GERDP1 + M_GERDP2 + M_GERDP3 + M_GERDP4 + M_GERDP5 + M_GERDP6)

     if !str(M_GERVLN, 12, 2) == str(M_TOTDP, 12, 2)
        msg(str(M_GERVLN, 12, 2) + "* * * SOMA DE PEDLICATA NAO BATE COM O TOTAL * * *")
         if lastkey()=17
           exit
         endif
        loop
     endif

     exit

  enddo

  WvtSetBlocks( aLastPaint6 )
  restscreen(06, 43, 20, 75, M_TELA)

return .t.


***************
function VEREST          && verifica a existencia do estado
***************

parameters M_VER

  if lastkey() = 5
    return .t.
  endif

  if M_VER $ "AC#SP#PR#MT#MS#TO#PA#AM#SC#RJ#RD#RN#SE#PE#MG#ES#RO#AP#AL#CE#BA#DF#GO#MA#NO#RS"
    return .t.
  endif

  msg("* * * ESTADO INEXISTENTE * * *")

return .f.

************
function MSG
************

parameters F_MSG

ccolor := setcolor()

setcolor("W+/GR*")
  @ MAXROW()-1 ,0 say padc(F_MSG,Maxcol())
  inkey(.1)
setcolor("N/W*")
  @ MAXROW()-1 ,0 say padc(F_MSG,Maxcol())
setcolor(ccolor)

ninkey(.3)

return .f.

************
function MSW         && mensagens nao espera
************

parameters F_MSG


ccolor := setcolor()

setcolor("W+/GR*")
  @ MAXROW()-1 ,0 say padc(F_MSG,Maxcol())
  inkey(.1)
setcolor("N/W*")
  @ MAXROW()-1 ,0 say padc(F_MSG,Maxcol())
setcolor(ccolor)

return ""

************
function MSH         && mensagens tempo
************
local tecla

parameters F_MSG, F_TMP

nTempo = seconds()
set cursor off

  wvt_DrawLabel(MAXROW()-1 ,0,padc(F_MSG,Maxcol()+1),,, RGB( 255, 255,255), RGB(0, 0,0 )  , "Visualnova", _FONTET_, , , , , .f., .f. ,.f.)
  ninkey(0.5)
  wvt_DrawLabel(MAXROW()-1 ,0,padc(F_MSG,Maxcol()+1),,, RGB(  0,128,0), RGB(0, 0,0 )  , "Visualnova", _FONTET_, , , , , .f., .f. ,.f.)
  ninkey(0.5)

( devpos(MAXROW()-1, 0) , devout(padc("", Maxcol()+1),"N/W*") )

if lKeyfun
  keyfun()
endif


set cursor on

return .f.

*****************
function FINALIZA
*****************

  private M_TELA ,;
          M_OPC

   if lLog = .t.  // entra no modulo de alteracao
     alertnew("Voce esta no modulo de permissoes;Conclua a alteracao das senhas",{"Ok"},,,,,,,"VERDE")
     return nil
   endif

   M_OPC =  msgbox2(padc("Deseja Encerrar a Atividade Agora ?",50))

   Wvt_RestScreen(2, 0, maxrow(), maxcol(),cInicIMG4,.t.)  // salva a tela

    if M_OPC = 1
      set cursor off
      set key 19 to
      set key  4 to
      clear
      set cursor on
      clear all
      quit
    endif

return .f.

***************
function IMPDSL
***************

private M_TELA ,;
        M_OPC

if isprinter()
  return .t.
endif

M_TELA = savescreen(12, 12, 15, 67)

do while .t.
  if !isprinter()
    tone(2500,1)
    sombra(12, 12, 14, 66,_SOMBRA_)
    panel(12, 12, 14, 66,"R+","N","R")
    set color to W/R
      @ 13, 13 say " A impressora est  Desligada ! Retenta ? (Sim) (N„o) "
    set color to
    store 1 to M_OPC
    @ 13, 55 prompt "Sim"
    @ 13, 61 prompt "N„o"
    menu to M_OPC
    restscreen(12, 12, 15, 67, M_TELA)
    if M_OPC = 1
      loop
    endif
  else
    return .t.
  endif

  exit

enddo

return .f.

***************
function MANCOR
***************

private MT_COR[16] ,;
        M_COR[16]  
private M_OPC      ,; 
        M_OPC1     ,;
        M_TELA     ,;
        M_TELA1

declare M_COR[16]

      M_COR[ 1] = "N"
      M_COR[ 2] = "B"
      M_COR[ 3] = "G"
      M_COR[ 4] = "BG"
      M_COR[ 5] = "R"
      M_COR[ 6] = "RB"
      M_COR[ 7] = "GR"
      M_COR[ 8] = "W"
      M_COR[ 9] = "N+"
      M_COR[10] = "B+"
      M_COR[11] = "G+"
      M_COR[12] = "R+"
      M_COR[13] = "RB+"
      M_COR[14] = "GR+"
      M_COR[15] = "W+"
      M_COR[16] = "W"

      M_TELA = savescreen(10, 25, 17, 51)

      sombra(10, 25, 16, 50,_SOMBRA_)
      @ 10, 25 say "ÕÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸"
      @ 11, 25 say "³Superior³               ³"
      @ 12, 25 say "³Fundo   ³               ³"
      @ 13, 25 say "³Sombra  ³               ³"
      @ 14, 25 say "³Inferior³               ³"
      @ 15, 25 say "³Protecao³               ³"
      @ 16, 25 say "ÔÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾"

      for R = 1 to 15
        COR = M_COR[R]
        set color to &COR
          @ 12, 34 + R say chr(219)
          @ 13, 34 + R say chr(219)
          @ 14, 34 + R say chr(219)
          @ 15, 34 + R say chr(219)
        set color to
      next 

    do while .t.

      @ 11, 26 prompt "Superior"
      @ 12, 26 prompt "Fundo   "
      @ 13, 26 prompt "Sombra  "
      @ 14, 26 prompt "Inferior"
      @ 15, 26 prompt "Protecao"
      menu to M_OPC

      if lastkey() = 27
        exit
      endif

      do while .t.

        M_TELA1 = savescreen(11, 26, 14, 33)

        set color to N/N,W/N,,,B/GR+
          for R = 1 to 15
            @ 11, 34 + R prompt chr(31)
          next 
          menu to M_OPC1              
        set color to

        if lastkey() = 27
          exit
        endif

        do case 
           case M_OPC = 1
                _FRENTE_ =  M_COR[M_OPC1]
                set color to &_FRENTE_/&_FUNDO_
                  @  1,  0 , 22, 79 box M_FRAME3
                set color to 
                painel(01, 1, 22, 78,"&_FRENTE_/&_FUNDO_","&_INFERIOR_/&_FUNDO_")
           case M_OPC = 2
                _FUNDO_ =  M_COR[M_OPC1]
                set color to &_FRENTE_/&_FUNDO_
                  @  1,  0 , 22, 79 box M_FRAME3
                set color to 
                painel(01, 1, 22, 78,"&_FRENTE_/&_FUNDO_","&_INFERIOR_/&_FUNDO_")
           case M_OPC = 3
                _SOMBRA_ =  M_COR[M_OPC1]
           case M_OPC = 4
                _INFERIOR_ =  M_COR[M_OPC1]
                set color to &_FRENTE_/&_FUNDO_
                  @  1,  0 , 22, 79 box M_FRAME3
                set color to 
                painel(01, 1, 22, 78,"&_FRENTE_/&_FUNDO_","&_INFERIOR_/&_FUNDO_")
           case M_OPC = 5
                _PROTECAO_ =  M_COR[M_OPC1]
        endcase   

        msl()

        M_TELA = savescreen(10, 25, 17, 51)

        sombra(10, 25, 16, 50,_SOMBRA_)
        @ 10, 25 say "ÕÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸"
        @ 11, 25 say "³Superior³               ³"
        @ 12, 25 say "³Fundo   ³               ³"
        @ 13, 25 say "³Sombra  ³               ³"
        @ 14, 25 say "³Inferior³               ³"
        @ 15, 25 say "³Protecao³               ³"
        @ 16, 25 say "ÔÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾"

        for R = 1 to 15
          COR = M_COR[R]
          set color to &COR
            @ 12, 34 + R say chr(219)
            @ 13, 34 + R say chr(219)
            @ 14, 34 + R say chr(219)
            @ 15, 34 + R say chr(219)
          set color to
        next 

        restscreen(11, 26, 14, 33, M_TELA1)

      enddo 

      sombra(10, 25, 16, 50,_SOMBRA_)
      @ 10, 25 say "ÕÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸"
      @ 11, 25 say "³Superior³               ³"
      @ 12, 25 say "³Fundo   ³               ³"
      @ 13, 25 say "³Sombra  ³               ³"
      @ 14, 25 say "³Inferior³               ³"
      @ 15, 25 say "³Protecao³               ³"
      @ 16, 25 say "ÔÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾"

      for R = 1 to 15
        COR = M_COR[R]
        set color to &COR
          @ 12, 34 + R say chr(219)
          @ 13, 34 + R say chr(219)
          @ 14, 34 + R say chr(219)
          @ 15, 34 + R say chr(219)
        set color to
      next 

    enddo

    save all like _* to CONFIG

    restscreen(10, 25, 17, 51, M_TELA)

    set cursor off

return ""

****************
function IMPRELASER
****************

#include "ptmenu.ch"

private M_OPC ,;
        M_TELA

store 1 to M_OPC

M_TELA = savescreen(11, 33, 16, 47)

do while .t.

  M_OPC = msgbox3("Escolha uma Opcao",,,"Impressora","Arquivo","Laser")

  if lastkey() = 27
    restscreen(11, 33, 15, 47, M_TELA)
    return "N"
  endif

  if M_OPC = 1 
    set printer to "RELATO.RPT"
    set print on
    restscreen(11, 33, 15, 47, M_TELA)
    msw("* * * AGUARDE ... IMPRIMINDO * * *")
    set console off
    ?? chr(18)
    return "I"
  endif

  if M_OPC = 3  // laser
    set printer to "RELATO.RPT"
    set print on
    restscreen(11, 33, 15, 47, M_TELA)
    msw("* * * AGUARDE ... IMPRIMINDO * * *")
    set console off
    return "L"
  endif

  exit

enddo

restscreen(11, 33, 15, 47, M_TELA)

msw("* * * AGUARDE ... IMPRIMINDO * * *")

set printer to RELATO.RPT
set print on
set console off

return "A"

****************
function IMPRESN
****************

LOCAL aBlocks   := {}
LOCAL aLastPaint
LOCAL aObjects  := WvtSetObjects( {} )

aLastPaint := WvtSetBlocks( aBlocks )

private M_OPC ,;
        M_TELA

store 1 to M_OPC

  M_OPC = msgbox2("Escolha uma Opcao",,,"Impressora","Arquivo")

   if lastkey() = 27
     return "N"
   endif

   msw("* * * AGUARDE ... IMPRIMINDO * * *")
   set printer to "RELATO.RPT"
   set print on
   set console off

   WvtSetObjects( aObjects )
   WvtSetBlocks( aLastPaint )

   if M_OPC = 1
     ?? chr(18)
     return "I"
   endif

return "A"

****************
function IMPREBL
****************

#include "ptmenu.ch"

private M_OPC ,;
        M_TELA

store 1 to M_OPC

M_TELA = savescreen(11, 33, 15, 47)

do while .t.

  sombra(11, 33, 14, 46,_SOMBRA_)

  painel(11, 33, 14, 46,"W+/R","N/R")
    
  set color to W+/R,W+/N
    @ 11, 37 say "Boleto"
    @ 12, 34 prompt             " Impressora " POSITION 2 HIGHLITE R+/R     
    @ 13, 34 prompt             "  Arquivo   " POSITION 3 HIGHLITE R+/R     
    menu to M_OPC
   set color to
   if lastkey() = 27
     restscreen(11, 33, 15, 47, M_TELA)
     return "N"
   endif

   if M_OPC = 1

     set printer to "RELATO.RPT"
     set print on
      restscreen(11, 33, 15, 47, M_TELA)
      msw("* * * AGUARDE ... IMPRIMINDO * * *")
      set console off
      return "I"
   endif

  exit

enddo

restscreen(11, 33, 15, 47, M_TELA)

msw("* * * AGUARDE ... IMPRIMINDO * * *")

set printer to RELATO.RPT
set print on
set console off

return "A"

***************
function SUSIMP
***************

private M_TELA ,;
        M_OPC

 tone(2500,1)

 M_TELA = savescreen(12, 12, 15, 67)

 sombra(12, 12, 14, 66,_SOMBRA_) 
 panel(12, 12, 14, 66,"R+","N","R")
 set color to W/R
   @ 13, 13 say " Deseja Suspender a impress„o Agora ???? (Sim) (N„o) "
 set color to

 store 1 to M_OPC
 @ 13, 55 prompt "Sim"
 @ 13, 61 prompt "N„o"
 menu to M_OPC

 restscreen(12, 12, 15, 67, M_TELA)
 
 if M_OPC = 1
   return .t.
 endif

return .f.

***************
function SUSPRO
***************

private M_TELA ,;
        M_OPC

 tone(2500,1)

 M_TELA = savescreen(12, 12, 15, 67)

 sombra(12, 12, 14, 66,_SOMBRA_) 
 panel(12, 12, 14, 66,"R+","N","R")
 set color to W/R
   @ 13, 13 say " Deseja Suspender este Processo Agora ?  (Sim) (N„o) "
 set color to

 store 1 to M_OPC
 @ 13, 55 prompt "Sim"
 @ 13, 61 prompt "N„o"
 menu to M_OPC

 restscreen(12, 12, 15, 67, M_TELA)
 
 if M_OPC = 1
   return .t.
 endif

return .f.

****************
function VEREMPM
****************
               
parameters F_EMP 

if F_EMP = 0
  return .f.
endif

if !BUSCAREGISTRO("AEMP00",1,{str(F_EMP,2,0)},"SELECT")
  msg("* * * EMPRESA N?O CADASTRADA * * *")
  return .f.
endif

M_FAN    = EMPFAN
ME_EMP   = EMPCOD
_EMPPRT_ = EMPPRT

return .t.

***************
function VEREMP
***************

Wvt_RestScreen(2, 0, maxrow(), maxcol(), cInicIMG4,.t. )  // restaura a tela

TamStr = len("Empresa:   ")
Ci:=((maxcol()-TamStr)/2)
Cf:=Ci+TamStr
Arg3:= Int(maxrow() / 2)-2

nbox(Arg3, Ci-3, Arg3 + 4, cf+3, "B/W*",.f.)
*Local2:= win(Arg3, Ci-3, Arg3 + 4, cf+3 ,,,"B/W")

set color to B/W*
@ Arg3+2, Ci  say        "Empresa:   "
set color to
@ Arg3+2, Ci+TamStr-2  get M_EMP picture "##"  valid verempm(M_EMP) color _COREDICAO_
read

Wvt_RestScreen(2, 0, maxrow(), maxcol(),cInicIMG4,.t.)  // salva a tela

if may_inkey(,.t.) = 27
  return .t.
endif

M_FAN  = AEMP00->EMPFAN
ME_EMP = AEMP00->EMPCOD

if may_inkey(,.t.) != 27
  if AEMP00->EMPSEN = "S"
    if !senha()
      quit
    endif
  else
    abre_log("0") && usuarios
    for I = 1 to 7
      K=str(I,1)
      for J = 1 to 5
        S=str(J,1)
        W_LOG&K&S = "S"
      next
    next
  endif
endif

M_LOGNOM = ALOG10->LOGNOM
M_LOGSUP = ALOG10->LOGSUP
M_LOGEXT = ALOG10->LOG75

_EMPPRT_ = AEMP00->EMPPRT

rodape("MENU","ESTOQUE",M_FAN,"MENUAGRO","Mem: " + str(memory(0), 5),M_EMP)

return .t.

************
function MSL
************

#include "directry.ch"

dtc := dtoc(directory("menuagro.exe")[1,3])

  set color to GR+/&_FUNDO_

  @ 06, 10 say  "                                                            "
  @ 07, 10 say  "                    Sistema Integrado                       "
  @ 08, 10 say  "                                                            "
  @ 09, 10 say  "                                                            "
  @ 10, 10 say  "                                                            " 
  @ 11, 10 say  "         A U T O M A € Ž O   S  O  F  T  W  A  R  E         "
  @ 12, 10 say  "                                                            "
  @ 13, 10 say  "                                                            "
  @ 14, 10 say  "                                                            "
  @ 15, 10 say  "                                                            "
  @ 16, 10 say  "                                                            "
  @ 17, 10 say  "                       Vers„o 5.0.2                         "
  @ 18, 10 say  "                                                            "

  painel(06, 10, 18, 69,"&_FRENTE_/&_FUNDO_","&_INFERIOR_/&_FUNDO_")
 
  @ 13, (80 - (len(alltrim(AEMP00->EMPNOM)))) / 2 say alltrim(AEMP00->EMPNOM)
set color to &_FRENTE_/&_FUNDO_
  @ 02, 02 say "(" + alltrim(_PATH_) + ")"
  @ 21, 56 say "Compilado em: " + dtc
set color to 

return ""



*****************
function CENT_CAB
*****************

parameters TEXTO1 ,;
           TEXTO2 ,;
           TEXTO3 ,;
           TAM

private F_SPC ,;
        F_IMP 

F_SPC  = TAM - len(alltrim(TEXTO2))
F_IMP  = F_SPC % 2
F_SPC  = int(F_SPC/2)

return TEXTO1 + space(F_SPC - len(TEXTO1)) + alltrim(TEXTO2) + space(F_SPC - len(TEXTO3)) + iif(F_IMP > 0," ","") + TEXTO3 

**************
function MOD11                         && calculo digito verificador
**************

parameters F_DIG

private M_SOMA  ,;
        M_DIG   

M_SOMA = (val(substr(F_DIG, 5, 1)) * 2) + ;
         (val(substr(F_DIG, 4, 1)) * 3) + ;
         (val(substr(F_DIG, 3, 1)) * 4) + ;
         (val(substr(F_DIG, 2, 1)) * 5) + ;
         (val(substr(F_DIG, 1, 1)) * 6) 

M_DIG = iif((M_SOMA % 11)=0,0,iif((M_SOMA % 11)=1,0,(11-(M_SOMA % 11))))

return str(M_DIG, 1, 0)

***************
function SPCVAR
***************

parameters F_VAR, F_TAM

F_VAR = space(F_TAM - len(alltrim(F_VAR))) + alltrim(F_VAR)

return F_VAR

*******************
function __DOS_HOLD
*******************

return ""

*****************
function TECLANDO
*****************

parameters M_TAM ,;
           M_LIN ,;
           M_COL ,;
           M_COR


private M_NOM ,;
        M_LOC

      M_NOM = space(M_TAM)
      M_LOC = 1

      set color to &M_COR

        do while M_LOC <= M_TAM
          @ M_LIN, (1 + M_COL) say M_NOM
          @ M_LIN, (M_LOC + M_COL) say "" 
          inkey(0)
          if rat(str(lastkey(), 2, 0),"13#27# 8") > 0
            exit
          endif
          if rat(str(lastkey(), 2, 0),"19# 5") > 0
            M_LOC = M_LOC - 1
            M_LOC = iif(M_LOC=0,1,M_LOC)
            M_NOM = stuff(M_NOM,M_LOC,1,"")
            M_NOM = stuff(M_NOM,M_LOC,1," ")
            loop
          endif
          M_NOM = stuff(M_NOM,M_LOC,1,"")
          M_NOM = stuff(M_NOM,M_LOC,1,upper(chr(lastkey())))
          M_LOC = M_LOC + 1
        enddo

        @ M_LIN, (1 + M_COL) say M_NOM

      set color to

return M_NOM

//*************
function SENHA
   //*************

   local lTela,TamStr,Ci,Cf,Arg3

   save get to M_GETPROTEGE

   private M_TELA ,;
      M_SENHA,;
      R,S

   S = 0

   TamStr = len("Senha:           ")
   Ci:=((maxcol()-TamStr)/2)
   Cf:=Ci+TamStr
   Arg3:= maxrow()-6

   lTela := savescreen(Arg3-2, Ci-2, Arg3 + 2, cf+2)

   DeskBox(Arg3-2, Ci-2, Arg3 + 2, cf+2, 1 )
*   nbox(Arg3-1, Ci-2, Arg3 + 1, cf+2,"B/W",.f.)

*   Wvt_DrawBoxRaised(Arg3+2, Ci, Arg3+2, cf-1,{-15,-15,+15,+15})

   set color to B/W
   @ Arg3, Ci say "Senha:           "
   set color to

   do while .t.

      M_LOGSEN = space(10)
      @ Arg3, Ci+TamStr-10 get M_LOGSEN PASSWORD pict "@!" valid !empty(M_LOGSEN) color _COREDICAO_
      read
      setcolor("")

      M_LOGSEN = pad(upper(M_LOGSEN),10)

      if empty(M_LOGSEN)
         loop
      endif

      if !BUSCAREGISTRO("ALOG10",2,{str(ME_EMP,2,0),aspas(M_LOGSEN)},"SELECT")
         msg("* * * USUARIO DESCONHECIDO* * *")
         S = S + 1
         if S = 3
            restore get from M_GETPROTEGE
            set cursor on
            return .f.
         endif
         loop
      else
         exit
      endif
   enddo

   M_LOGNOM = padr(LOGNOM,10)
   W_LOGGER = CAMPO1 + CAMPO2 + CAMPO3
   XX_LOGSEN = LOGSEN
   M_LOGVEN = val(LOG41)
   XX_LOGSUP = LOGSUP
   M_LOGPRV = LOGPRV

//   MSG(STR(m_logven))

   if "SCILAS" $ M_LOGNOM .or. "TESTE" $ M_LOGNOM
      setcancel(.t.)
   else
      setcancel(.f.)
   endif

   restscreen(Arg3-2, Ci-2, Arg3 + 2, cf+2,lTela)

   restore get from M_GETPROTEGE
   set cursor on

return .t.

**************
function SETAS
**************

return ""

*****************
function SETASMOR
*****************

  set cursor off

  set color to R/w*
    @ maxrow()-1,  10 say "<F12> Envia p/arquivo morto"
  set color to 

  set color to G/w*
    @ maxrow()-1, 11 say "F12"
  set color to

return ""


************
function CGC
************
*
* Rotina Criada por APARECIDO DOS SANTOS SILVA
*

parameters F_CGC

private M_SOMA  ,;
        M_PRIDG ,;
        M_SEGDG
*
** calcula o primeiro digito
*
M_SOMA = (val(substr(F_CGC,12, 1)) * 2) + ;
         (val(substr(F_CGC,11, 1)) * 3) + ;
         (val(substr(F_CGC,10, 1)) * 4) + ;
         (val(substr(F_CGC, 9, 1)) * 5) + ;
         (val(substr(F_CGC, 8, 1)) * 6) + ;
         (val(substr(F_CGC, 7, 1)) * 7) + ;
         (val(substr(F_CGC, 6, 1)) * 8) + ;
         (val(substr(F_CGC, 5, 1)) * 9) + ;
         (val(substr(F_CGC, 4, 1)) * 2) + ;
         (val(substr(F_CGC, 3, 1)) * 3) + ;
         (val(substr(F_CGC, 2, 1)) * 4) + ;
         (val(substr(F_CGC, 1, 1)) * 5) 

M_PRIDG = iif((M_SOMA % 11)=0,0,iif((M_SOMA % 11)=1,0,(11-(M_SOMA % 11))))
*
** calcula o segundo digito
*
M_SOMA = M_PRIDG * 2                    +;
         (val(substr(F_CGC,12, 1)) * 3) + ;
         (val(substr(F_CGC,11, 1)) * 4) + ;
         (val(substr(F_CGC,10, 1)) * 5) + ;
         (val(substr(F_CGC, 9, 1)) * 6) + ;
         (val(substr(F_CGC, 8, 1)) * 7) + ;
         (val(substr(F_CGC, 7, 1)) * 8) + ;
         (val(substr(F_CGC, 6, 1)) * 9) + ;
         (val(substr(F_CGC, 5, 1)) * 2) + ;
         (val(substr(F_CGC, 4, 1)) * 3) + ;
         (val(substr(F_CGC, 3, 1)) * 4) + ;
         (val(substr(F_CGC, 2, 1)) * 5) + ;
         (val(substr(F_CGC, 1, 1)) * 6) 

M_SEGDG = iif((M_SOMA % 11)=0,0,iif((M_SOMA % 11)=1,0,(11-(M_SOMA % 11))))

if !right(F_CGC, 2) == str(M_PRIDG, 1, 0) + str(M_SEGDG, 1, 0)
  return .f.
endif

return .t.

************
function CPF                         && calculo do cpf
************
*
* Rotina Criada por APARECIDO DOS SANTOS SILVA
*

parameters F_CPF

private M_SOMA  ,;
        M_PRIDG ,;
        M_SEGDG

*
** calcula o primeiro digito
*

M_SOMA = (val(substr(F_CPF, 9, 1)) * 2) + ;
         (val(substr(F_CPF, 8, 1)) * 3) + ;
         (val(substr(F_CPF, 7, 1)) * 4) + ;
         (val(substr(F_CPF, 6, 1)) * 5) + ;
         (val(substr(F_CPF, 5, 1)) * 6) + ;
         (val(substr(F_CPF, 4, 1)) * 7) + ;
         (val(substr(F_CPF, 3, 1)) * 8) + ;
         (val(substr(F_CPF, 2, 1)) * 9) + ;
         (val(substr(F_CPF, 1, 1)) * 10) 

M_PRIDG = iif((M_SOMA % 11)=0,0,iif((M_SOMA % 11)=1,0,(11-(M_SOMA % 11))))

*
** calcula o segundo digito
*
M_SOMA = M_PRIDG * 2                     + ;
         (val(substr(F_CPF, 9, 1)) *  3) + ;
         (val(substr(F_CPF, 8, 1)) *  4) + ;
         (val(substr(F_CPF, 7, 1)) *  5) + ;
         (val(substr(F_CPF, 6, 1)) *  6) + ;
         (val(substr(F_CPF, 5, 1)) *  7) + ;
         (val(substr(F_CPF, 4, 1)) *  8) + ;
         (val(substr(F_CPF, 3, 1)) *  9) + ;
         (val(substr(F_CPF, 2, 1)) * 10) + ;
         (val(substr(F_CPF, 1, 1)) * 11) 

M_SEGDG = iif((M_SOMA % 11)=0,0,iif((M_SOMA % 11)=1,0,(11-(M_SOMA % 11))))

if !right(F_CPF, 2) == str(M_PRIDG, 1, 0) + str(M_SEGDG, 1, 0)
  return .f.
endif

return .t.

****************
function EXTENSO
****************

parameter   VALOR     ,;
            LINHAS    ,;
            TAM_LIN

private     SEXO      ,;
            FEMININO  ,;
            CENTAVOS  ,;
            NVALOR    ,;
            TEMP      ,;
            TEMP_BILH ,;
            TEMP_MILH ,;
            TEMP_MIL  ,;
            TEMP_UNI  ,;
            TEMP_CENT ,;
            VALOR_EXT

VALOR_EXT = ""
FEMININO  = .F.
SEXO      = .F.                         && N„o corrige o sexo da moeda

if VALOR <=  0
    frmt_lines( LINHAS, TAM_LIN )
    return ""
else
    NVALOR      =   int(VALOR)
    TEMP_CENT   =   100 * (VALOR - NVALOR)
    TEMP_CENT   =   val( str(TEMP_CENT, 3, 0) )
    if TEMP_CENT == 100
        TEMP_CENT = 0
        NVALOR = NVALOR + 1
    end
    CENTAVOS    =   ext_aux_u(TEMP_CENT)
    if NVALOR == 0
          VALOR_EXT = CENTAVOS + " CENTAVO" + iif(CENTAVOS != "UM", "S", "")
        frmt_lines( LINHAS, TAM_LIN )
        return ""
    end
end

UM = (NVALOR == 1)
TEMP        =   int(NVALOR/1000000000)
TEMP_BILH   =   TEMP

if TEMP > 0
   VALOR_EXT = VALOR_EXT + ext_aux(TEMP) + " BILH" + iif(TEMP=1, "AO ","OES ")
   NVALOR = NVALOR - TEMP * 1000000000
end

TEMP        =   int(NVALOR/1000000)
TEMP_MILH   =   TEMP

if TEMP>0
   VALOR_EXT = VALOR_EXT + ext_aux(TEMP) + " MILH"+iif(TEMP=1,"AO ","OES ")
   NVALOR = NVALOR - TEMP * 1000000
end

TEMP        =   int(NVALOR/1000)
TEMP_MIL    =   TEMP

SEXO = .T.      && Corrige o sexo da moeda

if TEMP >   0
  VALOR_EXT = VALOR_EXT + ext_aux(TEMP) + " MIL "
  NVALOR = NVALOR - TEMP * 1000
endif

TEMP        =   int(NVALOR/1000)
if TEMP > 0
  VALOR_EXT = VALOR_EXT + ext_aux(TEMP)
  NVALOR = NVALOR - TEMP * 1000
endif

TEMP    =   NVALOR
TEMP_UNI=   TEMP

if TEMP > 0
  VALOR_EXT = VALOR_EXT + ext_aux(TEMP)
endif

VALOR_EXT = VALOR_EXT + iif(UM," REAL", " REAIS")
ABREV      = "RE"

VALOR_EXT = VALOR_EXT + iif(TEMP_CENT==0, "", " E "+CENTAVOS+" CENTAVO"+iif(CENTAVOS!="UM","S",""))

VALOR_EXT = strtran(VALOR_EXT,"  "," ")

* Se for bilh„o ou milh„o e mais nada !

if (TEMP_BILH!=0 .or. TEMP_MILH!=0) .and. TEMP_MIL=0 .and. TEMP_UNI=0
     VALOR_EXT=strtran(VALOR_EXT, ABREV, "DE " + ABREV)
end

if TEMP_BILH !=0 .and. TEMP_MILH != 0 .and. TEMP_MIL != 0 .and.;
  (TEMP_CENT !=0 .or.  TEMP_UNI >= 100 .or. TEMP_MIL >= 100)
   if TEMP_BILH == 1
       VALOR_EXT = strtran(VALOR_EXT, "LHAO ", "LHAO, ")
    else
       VALOR_EXT = strtran(VALOR_EXT, "LHOES ", "LHOES, ")
   end
end

if TEMP_MILH != 0 .and. TEMP_MIL != 0 .and.;
  (TEMP_CENT != 0 .or.  TEMP_UNI >= 100 .or. TEMP_MIL >= 100)
   if TEMP_MILH == 1
       VALOR_EXT = strtran(VALOR_EXT, "LHAO ", "LHAO, ")
    else
       VALOR_EXT = strtran(VALOR_EXT, "LHOES ", "LHOES, ")
   endif
end

if  TEMP_MIL!=0 .and. TEMP_CENT!=0 .and. (TEMP_UNI>=100 .or. TEMP_MIL>=100)
     VALOR_EXT=strtran(VALOR_EXT, "MIL ", "MIL, ")

elseif  TEMP_MIL!=0 .and. TEMP_UNI!=0 .and. (TEMP_UNI<100 .or. TEMP_MIL<100)
     VALOR_EXT=strtran(VALOR_EXT, "MIL ", "MIL E ")
end

frmt_lines( LINHAS, TAM_LIN )

*******************
FUNCTION frmt_lines
*******************

parameters  LINHAS    ,;                    && Array para Formatacao
            TAM_LIN                         && Tamanho de Cada Linha

private     I         ,;
            NUM_LIN   ,;
            CLOSE_PAR

CLOSE_PAR = .F.                             && Parentese NAO Fechado

for I = 1 to len( LINHAS )

     LINHAS[ I ] = iif( I == 1, "(", " " ) + formata( TAM_LIN )
                                            && Formata Linha
next

****************
FUNCTION Formata
****************

parameter   TAM_LIN

private  TEMP, TAM

TEMP = substr(VALOR_EXT, TAM_LIN, 2)

if len(VALOR_EXT) <= TAM_LIN .or. TEMP = " " .or. TEMP = "," .or. TEMP == "E "

    TAM = TAM_LIN + 1

 else

    TAM = rat(" ", left( VALOR_EXT, TAM_LIN + 1 ))

endif

SEP = alltrim(left(VALOR_EXT, TAM-1))

VALOR_EXT = ltrim(substr(VALOR_EXT, TAM))

if ! CLOSE_PAR .and. empty( VALOR_EXT )

    SEP = SEP + ")"                              && Adiciona ")"
    CLOSE_PAR = .T.                         && Indica ")" Adicionado

endif

if len( SEP ) < TAM_LIN

    SEP = pad( SEP, TAM_LIN, "*" )          && Efetua PADDING

endif

return SEP

****************
function EXT_AUX
****************

parameter TEMP_VAL

private   TEMP_EXT,NVALOR1,CENTENA

TEMP_EXT=""
TEMP_VAL=round(TEMP_VAL,0)
CENTENA = .F.

if TEMP_VAL>=100
    NVALOR1=int(TEMP_VAL/100)
    if TEMP_VAL=100
        TEMP_EXT = TEMP_EXT + "CEM"
    else
        MASCFEM = alltrim(substr("CENTO       DUZENTOS    TREZENTOS   QUATROCENTOSQUINHENTOS  SEISCENTOS  SETECENTOS  OITOCENTOS  NOVECENTOS  ",12*NVALOR1-11,12))
        TEMP_EXT = TEMP_EXT + strtran(MASCFEM, "os", iif(FEMININO.and.SEXO, "AS", "OS") )
        CENTENA =.T.
    end
    TEMP_VAL = TEMP_VAL - NVALOR1*100
end

if TEMP_VAL > 19
    NVALOR1=int(TEMP_VAL/10)-1
    TEMP_EXT = TEMP_EXT + iif(CENTENA," E ","")+Alltrim(substr("VINTE    TRINTA   QUARENTA CINQUENTASESSENTA SETENTA  OITENTA  NOVENTA  ",9*NVALOR1-8,9))
    NVALOR1=int(TEMP_VAL/10)*10
    TEMP_VAL = TEMP_VAL - NVALOR1
    CENTENA=.f.
    if TEMP_VAL > 0
        TEMP_EXT = TEMP_EXT + " E "
    end
end

if TEMP_VAL > 0
    TEMP_EXT = TEMP_EXT + iif(CENTENA," E ","")
    MASCFEM   = iif(FEMININO .and. SEXO, "UMA      DUAS", "UM       DOIS") +;
                "     TRES     QUATRO   CINCO    SEIS     SETE     OITO     NOVE     DEZ      ONZE     DOZE     TREZE    QUATORZE QUINZE   DEZESSEISDEZESSETEDEZOITO  DEZENOVE "
    TEMP_EXT = TEMP_EXT + alltrim(substr(MASCFEM,9*TEMP_VAL-8,9))
    CENTENA = .F.
end

return TEMP_EXT                        && fim da funcao de extenso

******************
function EXT_AUX_U
******************

parameter TEMP_VAL

private   TEMP_EXT,NVALOR1,CENTENA

TEMP_EXT=""
TEMP_VAL=round(TEMP_VAL,0)
CENTENA = .F.

if TEMP_VAL>=100
    NVALOR1=int(TEMP_VAL/100)
    if TEMP_VAL=100
        TEMP_EXT = TEMP_EXT + "CEM"
    else
        MASCFEM = alltrim(substr("CENTO       DUZENTAS    TREZENTAS   QUATROCENTASQUINHENTAS  SEISCENTAS  SETECENTAS  OITOCENTAS  NOVECENTAS  ",12*NVALOR1-11,12))
        TEMP_EXT = TEMP_EXT + strtran(MASCFEM, "os", iif(FEMININO.and.SEXO, "AS", "OS") )
        CENTENA =.T.
    end
    TEMP_VAL = TEMP_VAL - NVALOR1*100
end

if TEMP_VAL > 19
    NVALOR1=int(TEMP_VAL/10)-1
    TEMP_EXT = TEMP_EXT + iif(CENTENA," E ","")+Alltrim(substr("VINTE    TRINTA   QUARENTA CINQUENTASESSENTA SETENTA  OITENTA  NOVENTA  ",9*NVALOR1-8,9))
    NVALOR1=int(TEMP_VAL/10)*10
    TEMP_VAL = TEMP_VAL - NVALOR1
    CENTENA=.f.
    if TEMP_VAL > 0
        TEMP_EXT = TEMP_EXT + " E "
    end
end

if TEMP_VAL > 0
    TEMP_EXT = TEMP_EXT + iif(CENTENA," E ","")
    MASCFEM   = iif(FEMININO .and. SEXO, "UMA      DUAS", "UM       DOIS") +;
                "     TRES     QUATRO   CINCO    SEIS     SETE     OITO     NOVE     DEZ      ONZE     DOZE     TREZE    QUATORZE QUINZE   DEZESSEISDEZESSETEDEZOITO  DEZENOVE "
    TEMP_EXT = TEMP_EXT + alltrim(substr(MASCFEM,9*TEMP_VAL-8,9))
    CENTENA = .F.
end

return TEMP_EXT                        && fim da funcao de extenso

****************
function EDITREL
****************
local lTela := savescreen(0,0,maxrow(),maxcol())
FBTest("RELATO.RPT")
restscreen(0,0,maxrow(),maxcol(),lTela)

return ""

****************
function M_EDITA
****************

parameters MODE,;
           LIN ,;
           COL

*if MODE = 0
*  set color to R+
*    @ maxrow(), 67 say "L: " + str(LIN, 3, 0)
*    @ maxrow(), 74 say "C: " + str(COL+1, 3, 0)
*  set color to W+/B
*endif

return 0

******************
function FECHA_ARQ
******************

  FOR A = 1 TO 150
    if !empty(ALIAS(A))
*    if !"#" + alltrim(ALIAS(A)) + "#" $ "#ACLI00P#APCA00P#AFOR00P#" .and. !empty(ALIAS(A))
      select ALIAS(A)
      use
    endif
  NEXT


  BUSCAREGISTRO("AEMP00",1,{str(ME_EMP,2,0)},"SELECT")
  BUSCAREGISTRO("ALOG10",1,{str(ME_EMP,2,0),aspas(M_LOGNOM)},"SELECT")

return ""

*****************
function TECSENHA 
*****************

parameters M_TAM ,;
           M_LIN ,;
           M_COL ,;
           M_COR

private M_NOM ,;
        M_LOC

      M_NOM = space(M_TAM)
      M_LOC = 1

      set color to &M_COR

        do while M_LOC <= M_TAM
          @ M_LIN, (M_LOC + M_COL) say "" 
          inkey(0)
          if lastkey() = 13 .or. lastkey() = 27
            exit
          endif
          if rat(str(lastkey(), 2, 0)," 8#19# 5") > 0
            M_LOC = M_LOC - 1
            M_LOC = iif(M_LOC=0,1,M_LOC)
            M_NOM = stuff(M_NOM,M_LOC,1,"")
            M_NOM = stuff(M_NOM,M_LOC,1," ")
            loop
          endif
          M_NOM = stuff(M_NOM,M_LOC,1,"")
          M_NOM = stuff(M_NOM,M_LOC,1,upper(chr(lastkey())))
          M_LOC = M_LOC + 1
        enddo

      set color to

return M_NOM

****************
function PERMITE
****************

parameters M_LIN,;
           M_COL,;
           M_POS

if substr(W_LOG&M_LIN&M_COL,M_POS, 1) = "N"
   msg("* * * NAO AUTORIZADO * * *")
   return .f.
endif

return .t.

*****************
function CONFIRMA
*****************

#include "ptmenu.ch"

parameters M_ITEM

private M_OPC

aLastPaint4 := WvtSetBlocks( aBlocks )

do while .t.
  M_OPC = msgbox3("Confirma Exclusao " + M_ITEM + " ?",,18,"Escolha","Sim","Nao")
  if M_OPC > 1
    exit
  endif
enddo

if M_OPC = 2
  M_OPC = 1
endif

WvtSetBlocks( aLastPaint4 )

return M_OPC


***************
function PAINEL
***************
parameters LI,CI,LF,CF,SUP,INF

COR = setcolor()

private I

set color to &SUP
  for I = (CI+1) to (CF-1)
    @ LI, I say "Ä"
  next
  for I = LI to LF
    @ I, CI say "³"
  next

  @ LI, CI say "Ú"
  @ LF, CI say "À"

set color to &INF
  for I = (CI+1) to (CF-1)
    @ LF, I say "Ä"
  next
  for I = (LI+1) to (LF-1)
    @ I, CF say "³"
  next

  @ LI, CF say "¿"
  @ LF, CF say "Ù"

set color to &COR

return ""

***************
function DECIDE
***************

local M_OPCDEC

#include "ptmenu.ch"

parameters M_ITEM

do while .t.
  M_OPCDEC = msgbox3(M_ITEM,,18,"Escolha","Sim","Nao")
  if M_OPCDEC > 1
    exit
  endif
enddo

M_OPCDEC = M_OPCDEC -1

return M_OPCDEC

****************
function DECIDEn
****************

#include "ptmenu.ch"

parameters M_ITEM

private M_OPC ,;
        M_TAB ,;
        M_TXT 

M_TXT =  M_ITEM + " ? (Sim) (N„o)"
M_TAB = (80 - (len(M_TXT))) / 2
M_OPC = 2

set color to GR+/N,GR+/W+
  @ 24, M_TAB say M_TXT
  @ 24, (M_TAB - 1) + rat("Sim",M_TXT) prompt "Sim" HIGHLITE R+
  @ 24, (M_TAB - 1) + rat("N„o",M_TXT) prompt "N„o" HIGHLITE R+
  menu to M_OPC
set color to 

@ 24, 00 clear

return M_OPC

****************
function LAY_DUP
****************

parameters M_DUPVLD, M_DUPNUM, M_DUPORD, M_DUPSER, M_DUPDTE


parameters M_DUPVLD
extenso(M_DUPVLD, VAL_EXT, 44)

  ?? "+------------------------------------------------------------------------------+"
  ? "| EMPRESA : " + AEMP00->EMPNOM + "        EMISSAO : " + dtoc(DUPDTE) + " |"
  ? "| ENDERECO: " + AEMP00->EMPEND +"                           |"
  ? "| CIDADE  : " + AEMP00->EMPMUN + " - " + AEMP00->EMPEST +"                                          |"
  ? "| C.N.P.J : " + iif(len(rtrim(AEMP00->EMPCGC)) = 11,pad(transform(AEMP00->EMPCGC,"@R 999.999.999/99"), 18),right(transform(AEMP00->EMPCGC,"@R 999.999.999/9999-99"), 18)) + "                            Ies: " + pad(AEMP00->EMPIES, 15) +  " |"
  ? "+----------------+----------+--------------+--+----------------+---------------+"
  ? "|   VALOR NFF    |  NUMERO  | VLR DUPLICATA   |     NUMERO     |  VENCIMENTO   |"
  ? "+----------------+----------+-----------------+----------------+---------------+"
  ? "| " + transform(DUPNFS,"@E ###,###,###.##") + " |  " + str(DUPNUM, 6, 0) + "  |  " + transform(M_DUPVLD,"@E ###,###,###.##") + " |    " + str(DUPNUM, 6, 0) + "/" + strzero(DUPORD, 2, 0) + "   |   " + dtoc(DUPVCT) + "    |"
  ? "+----------------+----------+-----------------+----------------+---------------+"
  ? "|                |Nome do Sacado: " + pad(CLINOM,  37) + " " + str(CLICOD, 7, 0) + "|"
  ? "|                |Endereco      : " + pad(CLIEND2, 40) + "     |"
  ? "|                |Municipio     : " + pad(CLIMUN2, 20) + "  Cep: "  + strzero(CLICEP2, 5, 0) + "-" + strzero(CLICCL2, 3, 0) + "  UF: " + CLIUF2 + " |"
  ? "|                |Endereco Pgto : " + pad(CLIEND2, 40) + "     |"
  ? "|                |Cep/Mun/Uf    : " + pad(strzero(CLICEP2, 5, 0) + "-" + strzero(CLICCL2, 3, 0) + " " + CLIMUN2 + " " + CLIUF2, 45) + "|"
  ? "|                |Inscr CGC/CPF : " + iif(len(rtrim(CLICGC1)) = 11,pad(transform(CLICGC1,"@R 999.999.999/99"), 18),right(transform(CLICGC1,"@R 999.999.999/9999-99"), 18)) + "  Ies: " + pad(CLIIES1, 15) + "     |"
  ? "|                |Telefone      : " + pad(CLITEL1,45) + "|"
  ? "|                +----------+--------------------------------------------------+"
  ? "|                |   VALOR  | " + rtrim(VAL_EXT[ 1 ] ) +  replicate("*",(44 - len(rtrim(VAL_EXT[1])))) + "    |"
  ? "|                |    POR   | " + rtrim(VAL_EXT[ 2 ] ) +  replicate("*",(44 - len(rtrim(VAL_EXT[2])))) + "    |"
  ? "|                |  EXTENSO | " + rtrim(VAL_EXT[ 3 ] ) +  replicate("*",(44 - len(rtrim(VAL_EXT[3])))) + "    |"
  ? "|                +----------+--------------------------------------------------+"
  ? "|                |Reconheco(emos) a Exatidao desta Duplicata de venda Mercantil|"
  ? "|                |que pagarei(emos) a "+ pad(AEMP00->EMPNOM,40) + ",|"
  ? "|                |OU A SUA ORDEM, NA PRACA E VENCIMENTO INDICADOS.             |"
  ? "|                |                                                             |"
  ? "|                |                                                             |"
  ? "|                |    ___/___/___                    ______________________    |"
  ? "|                |  Data do Aceite                    Assinatura do Sacado     |"
  ? "+----------------+-------------------------------------------------------------+"
  ?
  
  for AA = 1 to 10
    ?
  next

  ? "  " + transform(DUPNFS,"@E ###,###,###.##") + "    " + str(DUPNUM, 6, 0) + "     " + transform(M_DUPVLD,"@E ###,###,###.##") + "      " + str(DUPNUM, 6, 0) + "/" + strzero(DUPORD, 2, 0) + "       " + dtoc(DUPVCT)
  ? 
  ? "                                  " + pad(CLINOM,  37) + " " + str(CLICOD, 7, 0) + " "
  ? "                                  " + pad(CLIEND2, 40) + "      "
  ? "                                  " + pad(CLIMUN2, 20) + "  Cep: "  + strzero(CLICEP2, 5, 0) + "-" + strzero(CLICCL2, 3, 0) + "  UF: " + CLIUF2 + "  "
  ? "                                  " + pad(CLIEND2, 40) + "      "
  ? "                                  " + pad(strzero(CLICEP2, 5, 0) + "-" + strzero(CLICCL2, 3, 0) + " " + CLIMUN2 + " " + CLIUF2, 45) + " "
  ? "                                  " + iif(len(rtrim(CLICGC1)) = 11,pad(transform(CLICGC1,"@R 999.999.999/99"), 18),right(transform(CLICGC1,"@R 999.999.999/9999-99"), 18)) + "  Ies: " + pad(CLIIES1, 15) + "      "
  ? 
  ? "                              " + rtrim(VAL_EXT[ 1 ] ) +  replicate("*",(44 - len(rtrim(VAL_EXT[1]))))
  ? "                              " + rtrim(VAL_EXT[ 2 ] ) +  replicate("*",(44 - len(rtrim(VAL_EXT[2]))))
  ? "                              " + rtrim(VAL_EXT[ 3 ] ) +  replicate("*",(44 - len(rtrim(VAL_EXT[3]))))
  ? 

  eject

return ""

****************
function LAY_MAN 
****************

parameters M_DUPVLD
extenso(M_DUPVLD, VAL_EXT, 44)

  ?? "+------------------------------------------------------------------------------+"
  ? "| EMPRESA : " + AFOR00->FORNOM + "        EMISSAO : " + dtoc(DUPDTE) + " |"
  ? "| ENDERECO: " + AFOR00->FOREND +"                           |"
  ? "| CIDADE  : " + AFOR00->FORMUN + " - " + AFOR00->FOREST +"                                          |"
  ? "| C.N.P.J : " + iif(len(rtrim(AFOR00->FORCGC)) = 11,pad(transform(AFOR00->FORCGC,"@R 999.999.999/99"), 18),right(transform(AFOR00->FORCGC,"@R 999.999.999/9999-99"), 18)) + "                            Ies: " + pad(AFOR00->FORIES, 15) +  " |"
  ? "+----------------+----------+--------------+--+----------------+---------------+"
  ? "|   VALOR NFF    |  NUMERO  | VLR DUPLICATA   |     NUMERO     |  VENCIMENTO   |"
  ? "+----------------+----------+-----------------+----------------+---------------+"
  ? "| " + transform(DUPNFS,"@E ###,###,###.##") + " |  " + str(DUPNUM, 6, 0) + "  |  " + transform(M_DUPVLD,"@E ###,###,###.##") + " |    " + str(DUPNUM, 6, 0) + "/" + strzero(DUPORD, 2, 0) + "   |   " + dtoc(DUPVCT) + "    |"
  ? "+----------------+----------+-----------------+----------------+---------------+"
  ? "|                |Nome do Sacado: " + pad(AEMP00->EMPNOM,  37) + " " + str(AEMP00->EMPCOD, 7, 0) + "|"
  ? "|                |Endereco      : " + pad(AEMP00->EMPEND, 40) + "     |"
  ? "|                |Municipio     : " + pad(AEMP00->EMPMUN, 20) + "  Cep: "  + strzero(AEMP00->EMPCEP, 5, 0) + "-" + strzero(AEMP00->EMPCCE, 3, 0) + "  UF: " + AEMP00->EMPEST + " |"
  ? "|                |Endereco Pgto : " + pad(AEMP00->EMPEND, 40) + "     |"
  ? "|                |Cep/Mun/Uf    : " + pad(strzero(AEMP00->EMPCEP, 5, 0) + "-" + strzero(AEMP00->EMPCCE, 3, 0) + " " + AEMP00->EMPMUN + " " + AEMP00->EMPEST, 45) + "|"
  ? "|                |Inscr CGC/CPF : " + iif(len(rtrim(AEMP00->EMPCGC)) = 11,pad(transform(AEMP00->EMPCGC,"@R 999.999.999/99"), 18),right(transform(AEMP00->EMPCGC,"@R 999.999.999/9999-99"), 18)) + "  Ies: " + pad(AEMP00->EMPIES, 15) + "     |"
  ? "|                +----------+--------------------------------------------------+"
  ? "|                |   VALOR  | " + rtrim(VAL_EXT[ 1 ] ) +  replicate("*",(44 - len(rtrim(VAL_EXT[1])))) + "    |"
  ? "|                |    POR   | " + rtrim(VAL_EXT[ 2 ] ) +  replicate("*",(44 - len(rtrim(VAL_EXT[2])))) + "    |"
  ? "|                |  EXTENSO | " + rtrim(VAL_EXT[ 3 ] ) +  replicate("*",(44 - len(rtrim(VAL_EXT[3])))) + "    |"
  ? "|                +----------+--------------------------------------------------+"
  ? "|                |Reconheco(emos) a Exatidao desta Duplicata de venda Mercantil|"
  ? "|                |que pagarei(emos) a "+ pad(AFOR00->FORNOM,40) + ",|"
  ? "|                |OU A SUA ORDEM, NA PRACA E VENCIMENTO INDICADOS.             |"
  ? "|                |                                                             |"
  ? "|                |                                                             |"
  ? "|                |    ___/___/___                    ______________________    |"
  ? "|                |  Data do Aceite                    Assinatura do Sacado     |"
  ? "+----------------+-------------------------------------------------------------+"
  ?
  eject
return ""

****************
function LAY_NOR
****************

parameter M_DUPVLD

      ?
      ? 
       ?? pad("QUALQUER AGENCIA", 63)
       ?? DUPVCT

      ?
      ?
      ?

      ? 
       ?? DUPDTE
       ?? "  "
       ?? DUPNUM
       ?? "/"
       ?? strzero(DUPORD, 2, 0)
  
      ?

        ? space(57)
         ?? transform(M_DUPVLD,"@E ###,###,###.##")

      ?
      ?
      ?

      if M_JUROS > 0
        ? space(04)
          ?? "Cobrar Juros de "
          ?? spcvar("R$ " + alltrim(transform(((M_DUPVLD * .01) * (M_JUROS/30)),"@E #,###.##")), 8)
          ?? " por dia de atraso."
      else
        ?
      endif

      ?
      ? space(04) + "PROTESTO APOS 6 DIAS DO VENCIMENTO "
      ? space(04) + "APOS VENCIDA NAO DISPENSAR JUROS DE"
      ? space(04) + "0,27% AO DIA                       "
      ? space(04) + M_MENS03
      ? space(04) + M_MENS04
      ?
      ? space(06)
       ?? ACLI00->CLINOM
       ?? space(01)
       ?? str(DUPCLI, 7, 0)
       ?? space(01) 
        if len(rtrim(ACLI00->CLICGC2)) = 11
          ?? transform(ACLI00->CLICGC2,"@R 999.999.999/99")
          ?? space(04)
        else
          ?? transform(ACLI00->CLICGC2,"@R 999.999.999/9999-99")
        endif
      ? space(06)
       ?? ACLI00->CLIEND3
       ?? space(01)
       ?? iif(empty(ACLI00->CLITEL3),space(21),"FONE: " + ACLI00->CLITEL3)
      ? space(06)
       ?? strzero(ACLI00->CLICEP3, 5, 0)
       ?? space(01)
       ?? strzero(ACLI00->CLICCL3, 3, 0)
       ?? " "
       ?? ACLI00->CLIMUN3
       ?? " "
       ?? ACLI00->CLIUF2


      for R = 1 to 10
        ?
      next

return ""

****************
function LAY_BRA
****************

parameter M_DUPVLD

      ?
      ? 
       ?? ACLI00->CLIMUN3
       ?? space(01)
       ?? ACLI00->CLIUF3
       ?? space(44)
       ?? DUPVCT

      ?
      ?
      ?

      ? 
       ?? DUPDTE
       ?? "  "
       ?? DUPNUM
       ?? "/"
       ?? strzero(DUPORD, 2, 0)
  
      ?

        ? space(61)
         ?? transform(M_DUPVLD,"@E ###,###,###.##")

      ?
      ?
      ?

      if M_JUROS > 0
        ? space(04)
          ?? "Cobrar Juros de "
          ?? spcvar("R$ " + alltrim(transform(((M_DUPVLD * .01) * (M_JUROS/30)),"@E #,###.##")), 8)
          ?? " por dia de atraso."
      else
        ?
      endif

      ?
      ? 
      ? space(04) + transform(M_DUP[1, 1], "@Z ######") + " " + transform(M_DUP[1, 2], "@Z ######") + " " + transform(M_DUP[1, 3], "@Z ######") + " " + transform(M_DUP[2, 1], "@Z ######") + " " + transform(M_DUP[2, 2], "@Z ######") + " "
      ? space(04) + transform(M_DUP[2, 3], "@Z ######") + " " + transform(M_DUP[3, 1], "@Z ######") + " " + transform(M_DUP[3, 2], "@Z ######") + " " + transform(M_DUP[3, 3], "@Z ######") + " " + transform(M_DUP[4, 1], "@Z ######") + " "
      ? space(04) + transform(M_DUP[4, 2], "@Z ######") + " " + transform(M_DUP[4, 3], "@Z ######") 
      ?
      ?
      ? space(06)
       ?? ACLI00->CLINOM
       ?? space(01)
       ?? str(DUPCLI, 7, 0)

      ? space(06)
       ?? ACLI00->CLIEND3

      ? space(06)
       ?? strzero(ACLI00->CLICEP3, 5, 0)
       ?? space(01)
       ?? strzero(ACLI00->CLICCL3, 3, 0)
       ?? " "
       ?? ACLI00->CLIMUN3
       ?? " "
       ?? ACLI00->CLIUF2
       ?? "   "
        if len(rtrim(ACLI00->CLICGC2)) = 11
          ?? transform(ACLI00->CLICGC2,"@R 999.999.999/99")
          ?? space(04)
        else
          ?? transform(ACLI00->CLICGC2,"@R 999.999.999/9999-99")
        endif
      ? space(11)
       ?? iif(empty(ACLI00->CLITEL3),space(21),"FONE: " + ACLI00->CLITEL3)

      for R = 1 to 9
        ?
      next

return ""

****************
function LAY_ITA
****************

parameter M_DUPVLD

      ?
      ? space(02)
       ?? "PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO"
       ?? space(17)
       ?? DUPVCT

      ?
      ?
      ?
      ?
      ? space(02)
       ?? DUPDTE
       ?? "      "
       ?? DUPNUM
       ?? "/"
       ?? strzero(DUPORD, 2, 0)

      ?

        ? space(55)
         ?? spcvar(("R$ " + ltrim(transform(M_DUPVLD,"@E ###,###,###.##"))),14)

      ?
      ?
      
        if M_JUROS > 0
          ? space(04)
            ?? "Cobrar Juros de "
            ?? alltrim(spcvar("R$ " + alltrim(transform(((M_DUPVLD * .01) * (M_JUROS/30)),"@E ###,###.##")), 14))
            ?? space(01)
            ?? "por dia de atraso."
        else
          ?
        endif

      ?

      ? space(04) + transform(M_DUP[1, 1], "@Z ######") + " " + transform(M_DUP[1, 2], "@Z ######") + " " + transform(M_DUP[1, 3], "@Z ######") + " " + transform(M_DUP[2, 1], "@Z ######") + " " + transform(M_DUP[2, 2], "@Z ######") + " "
      ? space(04) + transform(M_DUP[2, 3], "@Z ######") + " " + transform(M_DUP[3, 1], "@Z ######") + " " + transform(M_DUP[3, 2], "@Z ######") + " " + transform(M_DUP[3, 3], "@Z ######") + " " + transform(M_DUP[4, 1], "@Z ######") + " "
      ? space(04) + transform(M_DUP[4, 2], "@Z ######") + " " + transform(M_DUP[4, 3], "@Z ######") 
      ?
      ?
      ? 
      ?
      ? space(11)
       ?? ACLI00->CLINOM
       ?? space(01)
       ?? str(DUPCLI, 7, 0)

      ? space(11)
       ?? ACLI00->CLIEND3

      ? space(11)
       ?? iif(empty(ACLI00->CLITEL3),space(21),"FONE: " + ACLI00->CLITEL3)
       ?? "   "
       if len(rtrim(ACLI00->CLICGC2)) = 11
         ?? transform(ACLI00->CLICGC2,"@R 999.999.999/99")
         ?? space(04)
       else
         ?? transform(ACLI00->CLICGC2,"@R 999.999.999/9999-99")
       endif

      ? space(11)
       ?? strzero(ACLI00->CLICEP3, 5, 0)
       ?? space(01)
       ?? strzero(ACLI00->CLICCL3, 3, 0)
       ?? " "
       ?? ACLI00->CLIMUN3
       ?? " "
       ?? ACLI00->CLIUF2

      for R = 1 to 8
        ?
      next

return ""

****************
function LAY_EST // BANESTADO
****************

parameter M_DUPVLD

      ? 
       ?? ACLI00->CLIMUN3
       ?? space(01)
       ?? ACLI00->CLIUF3
       ?? space(44)
       ?? DUPVCT

      ?
      ?
      ?

      ? 
       ?? DUPDTE
       ?? "  "
       ?? DUPNUM
       ?? "/"
       ?? strzero(DUPORD, 2, 0)
  
      ?

        ? space(61)
         ?? transform(M_DUPVLD,"@E ###,###,###.##")

      ?
      ?
      ?

      if M_JUROS > 0
        ? space(04)
          ?? "Cobrar Juros de "
          ?? spcvar("R$ " + alltrim(transform(((M_DUPVLD * .01) * (M_JUROS/30)),"@E #,###.##")), 8)
          ?? " por dia de atraso."
      else
        ?
      endif

      ?
      ? 
      ? space(04) + transform(M_DUP[1, 1], "@Z ######") + " " + transform(M_DUP[1, 2], "@Z ######") + " " + transform(M_DUP[1, 3], "@Z ######") + " " + transform(M_DUP[2, 1], "@Z ######") + " " + transform(M_DUP[2, 2], "@Z ######") + " "
      ? space(04) + transform(M_DUP[2, 3], "@Z ######") + " " + transform(M_DUP[3, 1], "@Z ######") + " " + transform(M_DUP[3, 2], "@Z ######") + " " + transform(M_DUP[3, 3], "@Z ######") + " " + transform(M_DUP[4, 1], "@Z ######") + " "
      ? space(04) + transform(M_DUP[4, 2], "@Z ######") + " " + transform(M_DUP[4, 3], "@Z ######") 
      ?
      ? space(06)
       ?? ACLI00->CLINOM
       ?? space(01)
       ?? str(DUPCLI, 7, 0)

      ? space(06)
       ?? ACLI00->CLIEND3

      ? space(06)
       ?? strzero(ACLI00->CLICEP3, 5, 0)
       ?? space(01)
       ?? strzero(ACLI00->CLICCL3, 3, 0)
       ?? " "
       ?? ACLI00->CLIMUN3
       ?? " "
       ?? ACLI00->CLIUF2
       ?? "   "
        if len(rtrim(ACLI00->CLICGC2)) = 11
          ?? transform(ACLI00->CLICGC2,"@R 999.999.999/99")
          ?? space(04)
        else
          ?? transform(ACLI00->CLICGC2,"@R 999.999.999/9999-99")
        endif
      ? space(11)
       ?? iif(empty(ACLI00->CLITEL3),space(21),"FONE: " + ACLI00->CLITEL3)

      for R = 1 to 11
        ?
      next

return ""

****************
function LAY_SAN
****************

parameter M_DUPVLD

      ?
      ? space(06)
       ?? "PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO"
       ?? space(21)
       ?? DUPVCT

      ?
      ?
      ?
      ? space(06)
       ?? DUPDTE
       ?? "      "
       ?? DUPNUM
       ?? "/"
       ?? strzero(DUPORD, 2, 0)

       ?
       ? space(63)
       ?? spcvar(("R$ " + ltrim(transform(M_DUPVLD,"@E ###,###,###.##"))),14)

      ?
      ?
      
        if M_JUROS > 0
          ? space(06)
            ?? "Cobrar Juros de "
            ?? alltrim(spcvar("R$ " + alltrim(transform(((M_DUPVLD * .01) * (M_JUROS/30)),"@E ###,###.##")), 14))
            ?? space(01)
            ?? "por dia de atraso."
        else
          ?
        endif

      ?

      ? space(04) + transform(M_DUP[1, 1], "@Z ######") + " " + transform(M_DUP[1, 2], "@Z ######") + " " + transform(M_DUP[1, 3], "@Z ######") + " " + transform(M_DUP[2, 1], "@Z ######") + " " + transform(M_DUP[2, 2], "@Z ######") + " "
      ? space(04) + transform(M_DUP[2, 3], "@Z ######") + " " + transform(M_DUP[3, 1], "@Z ######") + " " + transform(M_DUP[3, 2], "@Z ######") + " " + transform(M_DUP[3, 3], "@Z ######") + " " + transform(M_DUP[4, 1], "@Z ######") + " "
      ? space(04) + transform(M_DUP[4, 2], "@Z ######") + " " + transform(M_DUP[4, 3], "@Z ######") 
      ?
      ?
      ? 
      ? space(11)
       ?? ACLI00->CLINOM
       ?? space(01)
       ?? str(DUPCLI, 7, 0)

      ? space(11)
       ?? ACLI00->CLIEND3

      ? space(11)
       ?? iif(empty(ACLI00->CLITEL3),space(21),"FONE: " + ACLI00->CLITEL3)
       ?? "   "
       if len(rtrim(ACLI00->CLICGC2)) = 11
         ?? transform(ACLI00->CLICGC2,"@R 999.999.999/99")
         ?? space(04)
       else
         ?? transform(ACLI00->CLICGC2,"@R 999.999.999/9999-99")
       endif

      ? space(11)
       ?? strzero(ACLI00->CLICEP3, 5, 0)
       ?? space(01)
       ?? strzero(ACLI00->CLICCL3, 3, 0)
       ?? " "
       ?? ACLI00->CLIMUN3
       ?? " "
       ?? ACLI00->CLIUF2

      for R = 1 to 10
        ?
      next

return ""

****************
function LAY_BAM
****************

parameter M_DUPVLD

      ?
      ? space(02)
       ?? "                                          "
       ?? space(21)
       ?? DUPNUM
       ?? "/"
       ?? strzero(DUPORD, 2, 0)
       ?? " "
       ?? DUPVCT

      ?
      ?
      ?
      ?
      ? space(02)
       ?? DUPDTE
       ?? "   "
       ?? DUPNUM
       ?? "/"
       ?? strzero(DUPORD, 2, 0)

      ?

        ? space(70)
         ?? spcvar(("R$ " + ltrim(transform(M_DUPVLD,"@E ##,###,###.##"))),14)

      ?
      ?
      
        if M_JUROS > 0
          ? space(04)
            ?? "Cobrar Juros de "
            ?? alltrim(spcvar("R$ " + alltrim(transform(((M_DUPVLD * .01) * (M_JUROS/30)),"@E ###,###.##")), 14))
            ?? space(01)
            ?? "por dia de atraso."
        else
          ?
        endif

      ?

      ? space(04) + transform(M_DUP[1, 1], "@Z ######") + " " + transform(M_DUP[1, 2], "@Z ######") + " " + transform(M_DUP[1, 3], "@Z ######") + " " + transform(M_DUP[2, 1], "@Z ######") + " " + transform(M_DUP[2, 2], "@Z ######") + " "
      ? space(04) + transform(M_DUP[2, 3], "@Z ######") + " " + transform(M_DUP[3, 1], "@Z ######") + " " + transform(M_DUP[3, 2], "@Z ######") + " " + transform(M_DUP[3, 3], "@Z ######") + " " + transform(M_DUP[4, 1], "@Z ######") + " "
      ? space(04) + transform(M_DUP[4, 2], "@Z ######") + " " + transform(M_DUP[4, 3], "@Z ######") 
      ?
      ?
      ? 
      ? space(11)
       ?? ACLI00->CLINOM
       ?? space(01)
       ?? str(DUPCLI, 7, 0)

      ? space(11)
       ?? alltrim(ACLI00->CLIEND3)
       ?? " "
       if len(rtrim(ACLI00->CLICGC2)) = 11
         ?? transform(ACLI00->CLICGC2,"@R 999.999.999/99")
         ?? space(04)
       else
         ?? transform(ACLI00->CLICGC2,"@R 999.999.999/9999-99")
       endif

      ? space(11)
       ?? strzero(ACLI00->CLICEP3, 5, 0)
       ?? space(01)
       ?? strzero(ACLI00->CLICCL3, 3, 0)
       ?? " "
       ?? ACLI00->CLIMUN3
       ?? " "
       ?? ACLI00->CLIUF2

      for R = 1 to 10
        ?
      next

return ""

****************
function LAY_AME
****************

parameters M_DUPVLD

      ?
      ? space(03)
       ?? ACLI00->CLIMUN3
       ?? space(01)
       ?? ACLI00->CLIUF3
       ?? space(45)
       ?? DUPVCT

      ?
      ?
      ?
      ? space(03)
        ?? DUPDTE
        ?? "     "
        ?? str(DUPNUM, 6, 0)
        ?? "/"
        ?? strzero(DUPORD, 2, 0)
      ?
      ? space(25) 
        ?? "R$"
         ?? space(38)
        ?? spcvar("R$ " + alltrim(transform(M_DUPVLD,"@E ###,###,###.##")), 14)
      ?
      ?

        if M_JUROS > 0
          ? space(04)
            ?? "Cobrar Juros de "
            ?? alltrim(spcvar("R$ " + alltrim(transform(((M_DUPVLD * .01) * (M_JUROS/30)),"@E ###,###.##")), 14))
            ?? space(01)
            ?? "por dia de atraso."
        else
          ?
        endif


        ?  
        ? space(04) + M_MENS01
        ? 
        ? space(04) + M_MENS02
        ?
        ?
        ? 
        ?
      ? space(10)
       ?? ACLI00->CLINOM
       ?? space(01)
       ?? str(DUPCLI, 7, 0)

      ? space(10)
       ?? ACLI00->CLIEND3
       ?? space(03)
       ?? iif(empty(ACLI00->CLITEL3),space(21),"FONE: " + ACLI00->CLITEL3)

      ? space(10)
       ?? strzero(ACLI00->CLICEP2, 5, 0)
       ?? space(01)
       ?? strzero(ACLI00->CLICCL2, 3, 0)
       ?? " "
       ?? ACLI00->CLIMUN3
       ?? " "
       ?? ACLI00->CLIUF2
       ?? "   "
        if len(rtrim(ACLI00->CLICGC2)) = 11
          ?? transform(ACLI00->CLICGC2,"@R 999.999.999/99")
          ?? space(04)
        else
          ?? transform(ACLI00->CLICGC2,"@R 999.999.999/9999-99")
        endif

      for R = 1 to 10
        ?
      next

return ""

****************
function LAY_REA
****************

parameters M_DUPVLD

       ?? chr(27) + "G"
       ?? space(01)
       ?? ACLI00->CLIMUN3
       ?? space(01)
       ?? ACLI00->CLIUF3
       ?? space(30)
       ?? DUPVCT
       ?

      ?

      ? space(01)
       ?? DUPDTE
       ?? "  "
       ?? str(DUPNUM, 6, 0)
       ?? "/"
       ?? strzero(DUPORD, 1, 0)

      ?? chr(27) + "0"
       ?
      ?? chr(27) + "2"

      ? space(18)
       ?? " R$"
       ?? space(27)
       ?? spcvar("R$ " + alltrim(transform(M_DUPVLD,"@E ###,###,###.##")), 14)

      ?
      ?
      ? space(01)
        ?? "APOS O VENCIMENTO COBRA JUROS DE 15 % AO MES"
      ? space(01)
        ?? "VALORES EXPRESSOS EM REAIS                  "
      ? space(01)
        ?? "PROTESTAR CONTRA O SACADO, APOS 3 DIAS      "
      ? space(01)
        ?? "UTEIS DO VENCIMENTO                         "
      ? 
      ?

      ? space(01)
       ?? ACLI00->CLINOM
       ?? " "
       ?? str(DUPCLI, 7, 0)
       ?? " "
        if len(rtrim(ACLI00->CLICGC2)) = 11
          ?? transform(ACLI00->CLICGC2,"@R 999.999.999/99")
          ?? space(04)
        else
          ?? right(transform(ACLI00->CLICGC2,"@R 999.999.999/9999-99"), 18)
        endif

      ? space(01)
       ?? ACLI00->CLIEND3
       ?? " "
       ?? ACLI00->CLIBAI3

      ? space(09)
       ?? strzero(ACLI00->CLICEP3, 5, 0)
       ?? " "
       ?? strzero(ACLI00->CLICCL3, 3, 0)
       ?? " "
       ?? ACLI00->CLIMUN3
       ?? " "
       ?? ACLI00->CLIUF3
       ?? chr(27) + "H"

      for R = 1 to 8
        ?
      next

return ""

****************
function LAY_BAN
****************

parameter M_DUPVLD

      ?
      ? 
       ?? "ATE O VENCIMENTO, PAGAVEL EM QUALQUER AGENCIA BANCARIA"
       ?? space(10)
       ?? DUPVCT

      ?
      ?
      ?

      ? 
       ?? DUPDTE
       ?? "      "
       ?? DUPNUM
       ?? "/"
       ?? strzero(DUPORD, 2, 0)
       ?? "-"
       ?? str(ACPG00->CPGPAR, 1, 0)
  
        ?
        ? space(58)
         ?? spcvar((ltrim(transform(M_DUPVLD,"@E ###,###,###.##"))),14)
      ?
      ? space(58)

      if M_JUROS > 0
        ? space(04)
          ?? "Permanencia por dia de atraso "
          ?? alltrim(spcvar("R$ " + alltrim(transform(((M_DUPVLD * .01) * (M_JUROS/30)),"@E ###,###.##")), 14))
      else
        ?
      endif

      ?
      ? 
      ?
      ?
      ?
      ?
      ? DUPBOL
      ?  

      ? space(05)
       ?? ACLI00->CLINOM
       ?? space(01)
       ?? str(DUPCLI, 7, 0)

      ? space(05)
       ?? ACLI00->CLIEND3

      ? space(05)
       ?? iif(empty(ACLI00->CLITEL3),space(21),"FONE: " + ACLI00->CLITEL3)

      ? space(05)
       ?? strzero(ACLI00->CLICEP3, 5, 0)
       ?? space(01)
       ?? strzero(ACLI00->CLICCL3, 3, 0)
       ?? " "
       ?? pad(ACLI00->CLIMUN3, 18)
       ?? " "
       ?? ACLI00->CLIUF3
       ?? "  "
        if len(rtrim(ACLI00->CLICGC2)) = 11
          ?? transform(ACLI00->CLICGC2,"@R 999.999.999/99")
          ?? space(04)
        else
          ?? transform(ACLI00->CLICGC2,"@R 999.999.999/9999-99")
        endif

      for R = 1 to 9
        ?
      next

return ""

************
function UDM
************

parameters M_MES,;
           M_ANO

declare MT_UDM[12]

MT_UDM [ 1] = "31"
MT_UDM [ 2] = iif(M_ANO $ "960004","29","28")
MT_UDM [ 3] = "31"
MT_UDM [ 4] = "30"
MT_UDM [ 5] = "31"
MT_UDM [ 6] = "30"
MT_UDM [ 7] = "31"
MT_UDM [ 8] = "31"
MT_UDM [ 9] = "30"
MT_UDM [10] = "31"
MT_UDM [11] = "30"
MT_UDM [12] = "31"

return MT_UDM[val(M_MES)]

****************
function _APPEND
****************

parameters F_ARQUI

      do while .t.
        append blank
        if neterr()
          msg("* * * (" + F_ARQUI + ") ARQUIVO EM USO EXCLUSIVO * * *")
          if lastkey()=17
            return .f.
          endif
          loop
        endif
        exit
      enddo

return .t.

**************
function PANEL
**************

parameters LI,CI,LF,CF,SUP,INF,FUN

COR = setcolor()

private I

set color to W+/&FUN
  @ LI+1, CI + 1, LF - 1, CF - 1 box  "         "
set color to 

set color to &SUP/&FUN
  for I = (CI+1) to (CF-1)
    @ LI, I say "Ä"
  next
  for I = LI to LF
    @ I, CI say "³"
  next

  @ LI, CI say "Ú"
  @ LF, CI say "À"

set color to &INF/&FUN
  for I = (CI+1) to (CF-1)
    @ LF, I say "Ä"
  next
  for I = (LI+1) to (LF-1)
    @ I, CF say "³"
  next

  @ LI, CF say "¿"
  @ LF, CF say "Ù"

set color to &COR

return ""

***************
function DIASEM
***************

parameters M_DATA

if empty(M_DATA)
  return space(07)
endif

private SEMANA[7]

declare SEMANA[7]

SEMANA[1] = "Domingo"
SEMANA[2] = "Segunda"
SEMANA[3] = "Terca  "
SEMANA[4] = "Quarta "
SEMANA[5] = "Quinta "
SEMANA[6] = "Sexta  "
SEMANA[7] = "Sabado "

return SEMANA[dow(M_DATA)]

****************
function C_SENHA 
****************

private M_TELA   ,;
        M_SENHA  ,;
        M_NUMCON ,;
        R,S

 tone(2500,1)

 M_TELA = savescreen(12, 21, 16, 59)

  S = 0

  M_NUMCON = dtoc(date()) + " " + time()

  do while .t.

    sombra(12, 21, 15, 58,_SOMBRA_) 

    panel(12, 21, 15, 58,"G+","N","G")

    set color to W+/G
      @ 13, 22 say " Numero Controle:                 "
      @ 14, 22 say " Senha Liberacao:                 "
      @ 13, 40 say M_NUMCON
    set color to

    M_SENHA = tecsenha(10, 14, 39,"GR+/N+")

    if lastkey() = 27
      restscreen(12, 21, 16, 59,M_TELA)
      return .f.
    endif

    if !alltrim(M_SENHA) == alltrim(str(int(val(substr(M_NUMCON, 4, 2) + substr(M_NUMCON, 10, 2) + substr(M_NUMCON, 16, 2)) / 3)))
      msg("* * * SENHA INVALIDA * * *")
      S = S + 1
      if S = 3
        restscreen(12, 21, 16, 59,M_TELA)
        return .f.
      endif
      loop  
    else
      exit
    endif

  enddo

  restscreen(12, 21, 16, 59,M_TELA)

return .t.

***************
function SUSDUP
***************

  private M_TELA ,;
          M_OPC

  set print off
  set console on
 
  M_TELA = savescreen(12, 12, 15, 67)

  do while .t.
  
    tone(2500,1)

    sombra(12, 12, 14, 66,_SOMBRA_)

    set color to w/R
      @ 12, 12 say "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»"
      @ 13, 12 say "º     Coloque Outra Duplicata e Pressione (ENTER)     º"
      @ 14, 12 say "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
    set color to

    inkey(0)

    if lastkey() = 27
      if susimp()
        go bottom
        skip
      endif
      restscreen(12, 12, 15, 67, M_TELA)
      return ""
    endif

    set print on

    if !impdsl()                         && impressora ligada ?
      set print off
      loop
    endif

    restscreen(12, 12, 15, 67, M_TELA)

    exit

  enddo

  msw("* * * AGUARDE ... IMPRIMINDO * * *")

  set console off

return ""

********************
function ACHA_AGENDA
********************

M_AREA = str(select())

nHormem = space(05)

if AEMP00->EMPSEN == "S"

  M_AREA = str(select())

  select AAGE00

  dbseek(str(ME_EMP, 2, 0) + M_LOGNOM + dtos(date()),.t.)

  do while !eof()

    if !str(AGEEMP, 2, 0) + AGENOM + dtos(AGEDTA) == str(ME_EMP, 2, 0) + M_LOGNOM + dtos(date())
      exit
    endif
  
    if !empty(AGELID)
      skip
      loop
    endif
   
    nHormem = transform(AGEHOR,"@R 99:99")
      
    exit

  enddo

endif

select &M_AREA

return ""

*********************
function CHAMA_AGENDA
*********************

private M_TELA

M_TELA = savescreen(12, 12, 15, 67)

sombra(12, 12, 14, 66,_SOMBRA_)

set color to w/R
@ 12, 12 say "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»"
@ 13, 12 say "º Voce tem agenda " + nHormem + " <ENTER> Ler - <ESC> Abandona  º"
@ 14, 12 say "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
set color to

do while .t.

  M_TECLA = inkey()

  if M_TECLA = 13 .or. M_TECLA = 27
    exit
  endif
  tone(2500,1)
  tone(1000,1)
enddo

restscreen(12, 12, 15, 67,M_TELA)

aCur = setcursor()
set cursor off

M_AREA = str(select())

if M_TECLA = 27
  aMin = val(substr(nHormem,4,2)) + 10
  aHor = val(substr(nHormem,1,2))

  if aMin > 59
    aHor ++
    aMin -= 60
  endif

  select AAGE00

  dbseek(str(ME_EMP, 2, 0) + M_LOGNOM + dtos(date()) + substr(nHormem,1,2) + substr(nHormem,4,2))

  do while .t.
    if rlock()
      replace  AGEHOR   with  strzero(aHor,2) + strzero(aMin,2)
      exit
    else
      msg("* * * (AAGE00) REGISTRO SENDO USADO * * *")
    endif
    if lastkey()=17
      exit
    endif
  enddo

  select AAGE00

  nHormem = space(05)

  dbseek(str(ME_EMP, 2, 0) + M_LOGNOM + dtos(date()),.t.)

  do while !eof()
    if !str(AGEEMP, 2, 0) + AGENOM + dtos(AGEDTA) == str(ME_EMP, 2, 0) + M_LOGNOM + dtos(date())
      exit
    endif
    if !empty(AGELID)
      skip
      loop
    endif
    nHormem = transform(AGEHOR,"@R 99:99")
    exit
  enddo
else
  select AAGE00
  dbseek(str(ME_EMP, 2, 0) + M_LOGNOM + dtos(date()) + substr(nHormem,1,2) + substr(nHormem,4,2))
  M_TELA = savescreen(07, 13, 18, 65)       
  sombra(7, 13, 17, 64,_SOMBRA_)
  set color to GR+/R
    @ 07, 13 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
    @ 08, 13 say     "³Data    :            Semana:                      ³"
    @ 09, 13 say     "³Hora    :                                         ³"
    @ 10, 13 say     "³Nome    :              Lido:        Resolvido:    ³"
    @ 11, 13 say     "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄCompromissosÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
    @ 12, 13 say     "³                                                  ³"
    @ 13, 13 say     "³                                                  ³"
    @ 14, 13 say     "³                                                  ³"
    @ 15, 13 say     "³                                                  ³"
    @ 16, 13 say     "³                                                  ³"
    @ 17, 13 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
  set color to
  set color to R+/R
    @ 08, 24 say AGEDTA  
    @ 08, 43 say diasem(AGEDTA)
    @ 09, 24 say AGEHOR picture "@R 99:99"
    @ 10, 24 say AGENOM picture "@!"
    @ 10, 43 say substr(time(),1,5)
    @ 10, 62 say AGERES picture "@!"
    @ 12, 14 say AGEOB1 picture "@!"
    @ 13, 14 say AGEOB2 picture "@!"
    @ 14, 14 say AGEOB3 picture "@!"
    @ 15, 14 say AGEOB4 picture "@!"
  set color to
  inkey(0)

  @ 24, 00 clear

  aOpc = escolha("Resolvido")
  restscreen(07, 13, 18, 65, M_TELA)

  select AAGE00

  do while .t.
    if rlock()
      replace  AGELID  with  substr(time(),1,2) + substr(time(),4,2)
      replace  AGERES  with  iif(aOpc = 1,"S","N")
      exit
    else
      msg("* * * (AAGE00) REGISTRO SENDO USADO * * *")
    endif
    if lastkey()=17
      exit
    endif
  enddo

  nHormem = space(05)

  dbseek(str(ME_EMP,2, 0) + M_LOGNOM + dtos(date()),.t.)

  do while !eof()
  
    if !str(AGEEMP, 2, 0) + AGENOM + dtos(AGEDTA) == str(ME_EMP, 2, 0) + M_LOGNOM + dtos(date())
      exit
    endif
  
    if !empty(AGELID)
      skip
      loop
    endif
  
    nHormem = transform(AGEHOR,"@R 99:99")
    exit
  enddo
endif

select &M_AREA

setcursor(aCur)

return ""

****************
function ESCOLHA
****************

parameters M_ITEM

private M_OPC ,;
M_TAB ,;
M_TXT

M_TXT =  M_ITEM + " ? (Sim) (N„o)"
M_TAB = (80 - (len(M_TXT))) / 2
M_OPC = 1

set color to GR+/N
@ 24, M_TAB say M_TXT
set color to

keyboard chr(24)

aPos = 1

do while .t.

aTecla = inkey(0)

do case
  case atecla = 24 .or. atecla = 4
    aPos  ++
    if aPos > 1
      aPos = 0
    endif
  case atecla = 5 .or. atecla = 19
    aPos --
    if aPos < 0
      aPos = 1
    endif
  case atecla = 13
    exit
endcase

setcolor("GR+/N")
@ 24, (M_TAB - 1) + rat("Sim",M_TXT) say "Sim"
@ 24, (M_TAB - 1) + rat("N„o",M_TXT) say "N„o"
setcolor("R/BG")
if aPos = 1
  @ 24, (M_TAB - 1) + rat("Sim",M_TXT) say "Sim"
else
  @ 24, (M_TAB - 1) + rat("N„o",M_TXT) say "N„o"
endif
setcolor("")

enddo

@ 24, 00 clear

return iif(aPos = 1,1,2)

*******************
function ANALIZA_CL
*******************

parameters M_CLICOD

mosdcr1(M_CLICOD)

return .t.

********************
function CRIACLI_NFS 
********************

private M_TELA

 M_TELA = savescreen(06, 14, 19, 66)
   
 sombra(06, 14, 18, 65,_SOMBRA_)

 M_CLICOD = AEMP00->EMPCLI + 1

  setcolor("GR+/BG+")
    @ 06, 14 say     "                                                    "
    @ 07, 14 say     " Codigo  :             Revenda S/N:                 "
    @ 08, 14 say     " ÄDados de EntregaÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ "
    @ 09, 14 say     " Cgc (Mf):                     Ies:                 "
    @ 10, 14 say     " N o m e :                                          "
    @ 11, 14 say     " Endereco:                                          "
    @ 12, 14 say     " Bairro  :                     Mun:                 "
    @ 13, 14 say     " Cep     :      -    Est:      Tel:                 "
    @ 14, 14 say     " ÄDados de CobrancaÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ "
    @ 15, 14 say     " Endereco:                                          "
    @ 16, 14 say     " Bairro  :                     Mun:                 "
    @ 17, 14 say     " Cep     :      -    Est:      Fax:                 "
    @ 18, 14 say     "                                                    "
  setcolor("I")

  setcolor("")

  M_CLICGC1  = space(15)
  M_CLITIP   = "C"
  M_CLINOM   = space(40)
  M_CLIDTE   = date()
  M_CLIEND1  = space(40)
  M_CLIUF1   = space(02)
  M_CLIBAI1  = space(15)
  M_CLICEP1  = 0
  M_CLICCL1  = 0
  M_CLICCL2  = 0
  M_CLICCL3  = 0
  M_CLIMUN1  = "PRES PRUDENTE       "
  M_CLITEL1  = space(15)
  M_CLIFAX1  = space(15)
  M_CLITEX1  = space(15)
  M_CLIIES1  = space(17)
  M_CLIREG   = 0
  M_CLIVEN   = M_NFSVEN
  M_CLICLF   = " "
  M_CLIEND2  = space(40)
  M_CLITRA   = M_NFSTRA
  M_CLIUF2   = "SP"
  M_CLIBAI2  = space(15)
  M_CLICEP2  = 0
  M_CLIMUN2  =  "PRES PRUDENTE       "
  M_CLIIES2  = space(17)
  M_CLICGC2  = space(15)
  M_CLIAC    = space(15)
  M_CLIEND3  = space(40)
  M_CLIUF3   = space(2)
  M_CLIBAI3  = space(15)
  M_CLICEP3  = 0 
  M_CLIMUN3  = space(20)
  M_CLITEL3  = space(15)
  M_CLIFAX3  = space(15)
  M_CLITEX3  = space(15)
  M_CLICON   = space(15)
  M_CLIBCO   = 0
  M_CLIULC   = date()
  M_CLISITE = space(40)
  M_CLIEMAIL = space(40)
  M_INDICADO = space(20)
  M_REVENDA  = " "

  @ 07, 25 get     M_CLICOD   picture "#######"
  read
 
  if M_CLICOD = 0
    return .f.
  endif

  select ACLI00

  do while .t.
    if dbseek(str(M_CLICOD, 7, 0))
      M_CLICOD = M_CLICOD + 1
*      carrega_cli() 
      loop
    endif
    set color to I
       @ 07, 25 say M_CLICOD   picture "#######"
    set color to 
    exit
  enddo

  do while .t. 

    @ 07, 50 get     M_REVENDA   picture "@!" valid M_REVENDA $ "SN"
    @ 09, 25 get     M_CLICGC1    picture "@R 999.999.999/9999-99"  valid verclicgc()
    @ 09, 50 get     M_CLIIES1    picture "@!@S15"                           

    @ 10, 25 get     M_CLINOM     picture "@!@S40"
    @ 11, 25 get     M_CLIEND1    picture "@!"                           
    @ 12, 25 get     M_CLIBAI1    picture "@!"                           
    @ 12, 50 get     M_CLIMUN1    picture "@!@S15"                           

    @ 13, 25 get     M_CLICEP1    picture "#####"                        
    @ 13, 31 get     M_CLICCL1    picture "###"                          
    @ 13, 40 get     M_CLIUF1     picture "@!"                            valid vercli07(M_CLIUF1)    
    @ 13, 50 get     M_CLITEL1    picture "@!"                            valid troca()
  
    @ 15, 25 get     M_CLIEND3    picture "@!"    
                         
    @ 16, 25 get     M_CLIBAI3    picture "@!"                           
    @ 16, 50 get     M_CLIMUN3    picture "@!@S15"                           
 
    @ 17, 25 get     M_CLICEP3    picture "#####"                        
    @ 17, 31 get     M_CLICCL3    picture "###"                          
    @ 17, 40 get     M_CLIUF3     picture "@!"                            valid vercli07(M_CLIUF3)    
    @ 17, 50 get     M_CLIFAX3    picture "@!"                          
    read

    msg("* * * (ENTER) Continua  (ESC) Abandona  (PgDn) Sai * * *")

    if lastkey() = 3
      exit
    endif

    if lastkey() = 27
       return .f.
    endif

  enddo

  if empty(M_CLINOM)
    msg("* * * CLIENTE NAO PODE TER NOME VAZIO * * *")
    return .f.
  endif

  select ACLI00

  do while .t.
    if dbseek(str(M_CLICOD, 7, 0))
      M_CLICOD = M_CLICOD + 1
      if M_CLICOD > 9999999
        msg("* * * CODIGOS DE CLIENTES ESGOTADOS * * *")
        return ""
      endif
      loop
    else
      _append("ACLI00") 
      grcli01()                      && grava o cliente
      if right(str(M_CLICOD, 7, 0), 2) = "00"
        select AEMP00                    && seleciona empresa e grava ultima nota fiscal
        do while .t. 
          if rlock()
            replace EMPCLI with M_CLICOD
            unlock
            commit
            exit 
          else
            msg("* * * (AEMP00) REGISTRO SENDO USADO * * *")
          endif
          if lastkey()=17
            exit
          endif
        enddo
      endif
     endif
     exit
  enddo

  M_NFSCLI = M_CLICOD

  restscreen(06, 14, 19, 66, M_TELA)

  set color to I 
    @ 05, 47 say     M_NFSCLI picture "#######" 
  set color to 

  if left(str(M_NFSNAT, 6, 2), 3) $ "512#612"
    if M_CLIUF2 != "SP"
      M_NFSNAT = 612.00
    else
      M_NFSNAT = 512.00
    endif
      set color to I 
        @ 05, 15 say     M_NFSNAT picture "###.##" 
      set color to 
  endif 

return .t.

#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)

*******************
function CRIAPRO_ON 
*******************

private M_TELA

  abre_grp("14")
  abre_cve("15")

   M_TELA = savescreen(06, 05, 20, 75)

   save get to M_GETANT

        store AEMP00->EMPPRO + 1 to M_MATVLR           

        do while .t.
          M_PCAMAT = val(str(M_MATVLR, 5, 0) + mod11(str(M_MATVLR, 5, 0)))    && gera digito controle
          set color to I
            @ 07, 20 say str(M_PCAMAT, 6, 0) picture "@R 99999-9" 
          set color to 
          if dbseek(str(M_PCAMAT, 6, 0))
            msg("* * * PRODUTO J CADASTRADO * * *")
            if lastkey() = 17
              return ""
            endif
            M_MATVLR = M_MATVLR + 1
            loop
          endif
          exit
        enddo

        M_PCAREF=space(50)
        M_PCALIS="SIM"
        M_PCAGRP=0
        M_PCAMAR = space(30)
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
        M_PCADSC="N" // MENSAGEM ABBOT

        M_PCADES=space(50)

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

   sombra(06, 05, 19, 74,_SOMBRA_)

   set color to GR+/BG
    @ 06, 05 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
    @ 07, 05 say     "³ Produto    :                    Pes:                  Uni:         ³"
    @ 08, 05 say     "³ Descri‡„o  :                                                       ³"
    @ 09, 05 say     "³ % Base ICMS:   )        1)         2)                 For:         ³"
    @ 10, 05 say     "³ % Aliq ICMS:   )        1)         2)                 Ipi:         ³"
    @ 11, 05 say     "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
    @ 12, 05 say     "³ Tributa‡„o :       Com:         Grp:         Esc:     Csp:   Cou:  ³"
    @ 13, 05 say     "³ Marca      :                                          Lis:         ³"
    @ 14, 05 say     "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
    @ 15, 05 say     "³ P‡o Fabrica:            P‡o Compra:            Dta Compra:         ³"
    @ 16, 05 say     "³ P‡o Custo  :            P‡o M‚dio :            Dta Pagto :         ³"
    @ 17, 05 say     "³ % Margem   :            Est M ximo:            Saldo Inve:         ³"
    @ 18, 05 say     "³ P‡o Venda  :            Est Minimo:            Saldo Hoje:         ³"
    @ 19, 05 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
   set color to

    set color to I
      @ 09, 20 say AEMP00->EMPEST
      @ 10, 20 say AEMP00->EMPEST
      @ 07, 20 say str(M_PCAMAT, 6, 0) picture "@R 99999-9" 
    set color to  

    edpro01()

    if lastkey() = 27
      restscreen(06, 05, 20, 75, M_TELA)
      return .f.
    endif

    do while .t.
      M_PCAMAT = val(str(M_MATVLR, 5, 0) + mod11(str(M_MATVLR, 5, 0)))    && gera digito controle
      if APCA00->(dbseek(str(M_PCAMAT, 6, 0)))
        M_MATVLR = M_MATVLR + 1
        loop
      else
        select APCA00
        _append("APCA00")
        grpro01()                       && grava produto
        select AEMP00                   && seleciona empresa e grava ultima nota fiscal
        do while .t. 
          if rlock()
            replace EMPPRO with M_MATVLR 
            unlock
            commit
            exit 
          else
            msg("* * * (AEMP00) REGISTRO SENDO USADO * * *")
          endif
          if lastkey()=17
            exit
          endif
        enddo
      endif
      exit
    enddo

    set color to I
      @ 07, 20 say str(M_PCAMAT, 6, 0) picture "@R 99999-9"
    set color to 

    select ASLD00

    _append("ASLD00")

    grpro02()                       && grava saldo empresa 1

    msg("* * * PRODUTO E SALDO INCLUIDO * * *")

    select 14
    use
    select 15
    use

    restore get from M_GETANT

    setcursor("1")

    if left(_FUNPRO_, 3) = "NFE"
      M_NFEMAT[SQ, 6] = M_PCAMAT
    endif

    if left(_FUNPRO_, 3) = "NFS"
      M_NFSMAT[SQ, 3] = M_PCAMAT
    endif

    if left(_FUNPRO_, 3) = "PED"
      M_PEDMAT[SQ, 2] = M_PCAMAT
    endif

    if left(_FUNPRO_, 3) = "REQ"
      M_REQMAT[SQ, 2] = M_PCAMAT
    endif

    if left(_FUNPRO_, 3) = "ORC"
      M_ORCMATIT[R] = M_PCAMAT
    endif

    restscreen(06, 05, 20, 75, M_TELA)

return .t.

****************
function CALCULA
****************

#translate Say(<row>,<col>,<exp>)                                       => ;
           (DevPos(<row>,<col>),DevOut(<exp>))
#translate Say(<row>,<col>,<exp>,<cor>)                                 => ;
           (DevPos(<row>,<col>),DevOut(<exp>,<cor>))


tela := SAVESCREEN()
Calculadora()
RESTSCREEN(,,,,tela)

return ""


***
* A calculadora
*---------------------------->

**********************
FUNCTION Calculadora()
**********************

LOCAL tela   := SAVESCREEN(),;
      cursor := SETCURSOR(),;
      cor    := SETCOLOR()

PRIVATE val_fita   := {},;
        val_print  := .F.

PRIVATE val_string := "" ,;
        val_valor  := 0  ,;
        val_conta  := 0  ,;
        val_sinal  := "" ,;
        old_sinal  := "" ,;
        val_memo   := "" ,;
        val_guarda := "" ,;
        limpa      := .F.,;
        retorna    := .F.,;
        val_ultimo := 0  ,;
        val_pont   := 0  ,;
        val_array  := 0

PRIVATE _memoria   := 0  ,;
        c_jancal   := "GR+/BG" ,;
        c_descal   := "GR+/B"

***> ambiente
SETCURSOR(0)                           // desliga o cursor

***> montagem da tela
SETCOLOR(c_jancal)

*Quadro(06,11,08,38)
*Quadro(09,11,19,38)
*Quadro(06,39,19,66)

sombra(06, 11, 19, 66,_SOMBRA_)
panel(06, 11, 08, 38,"W+","N","BG")
panel(09, 11, 19, 38,"W+","N","BG")
panel(06, 39, 19, 66,"W+","N","BG")

SETCOLOR(c_descal)
Say(07,13,"                    ")
Say(07,34,"   ")
Say(10,33," cE ")
Say(14,34," F ")
Say(16,34," I ")
Say(12,29," L ")
Say(10,29," P ")
Say(18,25," + ")
Say(16,25," - ")
Say(14,25," * ")
Say(12,25," / ")
Say(18,29," ^ ")
Say(12,13," 7 ")
Say(10,13," <H> ajuda ")
Say(10,25," M ")
Say(12,17," 8 ")
Say(12,21," 9 ")
Say(12,34," R ")
Say(14,13," 4 ")
Say(14,17," 5 ")
Say(14,21," 6 ")
Say(14,29," T ")
Say(16,13," 1 ")
Say(16,17," 2 ")
Say(16,21," 3 ")
Say(16,29," % ")
Say(18,13," C ")
Say(18,17," 0 ")
Say(18,21," . ")
Say(18,33," " + CHR(17) + "Ù ")

MostraFita()

***> loop principal
WHILE .T.
   SET(_SET_DECIMALS,2)

   SETCOLOR(c_descal)
   ***> visor da calculadora
   IF EMPTY(val_string)
      @ 07,13 SAY PADL("0",20)
   ELSE
      IF LEN(val_string) > 20
         @ 07,13 SAY PADL("ERRO",20)
         val_guarda := val_string := ""
      ELSE
         val_guarda := val_string
         @ 07,13 SAY PADL(val_string,20)
      ENDIF
   ENDIF

   IF retorna
      RESTSCREEN(,,,,tela)
      SETCURSOR(cursor)
      SETCOLOR(cor)
      KEYBOARD ALLTRIM(val_guarda)
      RETURN
   ENDIF
   
   tecla := INKEY(0)                   // aguarda uma tecla

   IF tecla = 5 .OR. tecla = 24
      IF LEN(val_fita) >= 12
         IF tecla = 5
            val_pont := IF(val_pont - 1 >= 12,val_pont - 1,val_pont)
         ELSEIF tecla = 24
            val_pont := IF(val_pont + 1 <= LEN(val_fita),val_pont + 1,val_pont)
         ENDIF
         MoveFita(val_pont)
      ELSE
         TONE(3000,1)
      ENDIF
      LOOP
   ENDIF

   IF limpa
      val_string := ""
      limpa := .F.
   ENDIF
   
   IF tecla = 27                       // esc
      EXIT

   ELSEIF CHR(tecla) $ "0123456789"
      IF LEN(val_string) < 20
         val_string += CHR(tecla)
      ENDIF

   ELSEIF CHR(tecla) $ ".,"
      IF AT(".",val_string) = 0        // se ja nao houver ponto
         IF !EMPTY(val_string)
            val_string += "."
         ELSE
            val_string += "0."
         ENDIF
      ENDIF

   ELSEIF tecla = 8                    // back space apaga ultimo numero
      val_string := SUBSTR(val_string,1,LEN(val_string) - 1)

   ELSEIF tecla = 13 .OR. CHR(tecla) = "="   // enter ou igual
      IF !EMPTY(old_sinal)
         MostraSinal("T")
         val_valor := VAL(val_string)
 
         IF !EMPTY(val_string)
            AddFita(PADL(val_string,20) + " =")
         ENDIF

         IF old_sinal = "+"
            val_conta  += val_valor
         ELSEIF old_sinal = "-"
            val_conta  -= val_valor
         ELSEIF old_sinal = "*"
            val_conta  *= val_valor
         ELSEIF old_sinal = "/"
            IF !EMPTY(val_valor)
               val_conta  /= val_valor
            ELSE
               AddFita(PADL("DIVISAO POR ZERO",22))
               val_conta := 0
            ENDIF
         ELSEIF old_sinal = "^"
            val_conta  = val_conta ^ val_valor
         ENDIF

         val_string := STR(val_conta)
         val_sinal  := ""
         old_sinal  := ""
         limpa      := .T.
         val_ultimo := val_conta
         AddFita(" " + REPLICATE("Ä",21))
         AddFita(PADL(STR(val_ultimo),20) + " T")
         AddFita(PADL(" ",22))
         MostraFita()
      ENDIF

   ELSEIF CHR(tecla) = "^" .AND. !(old_sinal $ "+-*/%")
      val_string := IF(limpa,STR(val_conta),val_string)
      old_sinal  := "^"
      MostraSinal("^")
      AddFita(PADL(val_string,20) + " ^")
      MostraFita()
      val_conta := VAL(val_string)
      limpa := .T.
      
   ELSEIF CHR(tecla) $ "Cc"                 // zera o calculo
      MostraSinal("C")
      val_string := ""
      val_conta  := 0
      val_valor  := 0
      val_ultimo := 0
      val_sinal  := ""
      old_sinal  := ""
      limpa      := .T.
      AddFita(PADL(" ",22))
      AddFita(PADL("0",20) + " C")
      MostraFita()
			
   ELSEIF CHR(tecla) $ "Ee"                 // zera a parcela
      val_string := ""
      limpa      := .F.

   ElSEIF CHR(tecla) $ "Ff"                 // zera fita
      MostraSinal(" ")
      val_string := ""
      val_conta  := 0
      val_valor  := 0
      val_ultimo := 0
      val_sinal  := ""
      old_sinal  := ""
      limpa      := .T.
      val_fita   := {}
      SETCOLOR(c_jancal)
      DISPBOX(07,40,18,65,"         ")
      MostraFita()

   ELSEIF CHR(tecla) $ "Hh"
      SayCalcHelp()

   ELSEIF CHR(tecla) $ "Ii"
      IF ISPRINTER()
         SET DEVICE TO PRINTER
         SET CONSOLE OFF
         @ PROW() + 1,1 SAY PADL("Automacao Software, 96",22)
         @ PROW() + 1,1 SAY ""
         FOR val_array := 1 TO LEN(val_fita)
            IF AT("Ä",val_fita[val_array]) <> 0
               @ PROW() + 1,2 SAY " " + REPLICATE("-",21)
            ELSE
               @ PROW() + 1,2 SAY val_fita[val_array]
            ENDIF
         NEXT
         SET CONSOLE ON
         SET DEVICE TO SCREEN
      ELSE
         TONE(3000,1)
      ENDIF
      limpa := .F.

   // logaritmos
   ELSEIF CHR(tecla) $ "Ll" .AND. !(old_sinal $ "+-*/%")
      SET(_SET_DECIMALS,18)
      MostraSinal("L")

      IF EMPTY(VAL(val_string)) .AND. EMPTY(val_conta)
         AddFita(PADL("ERRO",22))
      ELSE
         AddFita(PADL(IF(EMPTY(val_conta),val_string,STR(val_conta)),20) + " L")
         val_conta  := LOG(IF(EMPTY(val_conta),VAL(val_string),val_conta))
         val_string := STR(val_conta)
         AddFita(PADL(val_string,20) + " =")
      ENDIF

      val_ultimo := val_conta
      limpa      := .T.
      MostraFita()

   // memoria
   ELSEIF CHR(tecla) $ "Mm"
      limpa := .F.
      tecla := INKEY(0)

      IF     CHR(tecla) $ "+"
         _memoria += VAL(val_guarda)

      ELSEIF CHR(tecla) $ "-"
         _memoria -= VAL(val_guarda)

      ELSEIF CHR(tecla) $ "Cc"
         _memoria   := 0
         val_string := 0
         limpa      := .T.

      ELSEIF CHR(tecla) $ "Rr"
         val_string := STR(_memoria)

      ENDIF

   // impressao
   ELSEIF CHR(tecla) $ "Pp"
      IF !ISPRINTER()
         TONE(3000,1)
      ELSE
         val_print := !(val_print)
      ENDIF

   // raiz quadrada
   ELSEIF CHR(tecla) $ "Rr" .AND. !(old_sinal $ "+-*/%")
      SET(_SET_DECIMALS,18)
      MostraSinal("û")

      IF EMPTY(VAL(val_string)) .AND. EMPTY(val_conta)
         AddFita(PADL("ERRO",22))
      ELSE
         AddFita(PADL(IF(EMPTY(val_conta),val_string,STR(val_conta)),20) + " û")
         val_conta  := SQRT(IF(EMPTY(val_conta),VAL(val_string),val_conta))
         val_string := STR(val_conta)
         AddFita(PADL(val_string,20) + " =")
      ENDIF

      val_ultimo := val_conta
      limpa      := .T.
      MostraFita()

   ELSEIF CHR(tecla) $ "Tt"
      retorna := .T.

   ELSEIF CHR(tecla) = "%"                 // percentagem
      MostraSinal("%")
      val_valor  := VAL(val_string)

      AddFita(PADL(val_string,20) + " %")
      MostraFita()

      IF old_sinal = "+"
	 val_conta  += ((val_conta * val_valor) / 100)
      ELSEIF old_sinal = "-"
	 val_conta  -= ((val_conta * val_valor) / 100)
      ELSEIF old_sinal = "*"
	 val_conta  := ((val_conta * val_valor) / 100)
      ELSEIF old_sinal = "/"
	 val_conta  := ((val_conta / val_valor) * 100)
      ENDIF

      val_string := STR(val_conta)
      val_ultimo := VAL(val_string)
      limpa      := .T.
      val_valor  := 0
      old_sinal  := "%"
      AddFita(PADL(val_string,20) + " =")
      MostraFita()

   ELSEIF CHR(tecla) $ "+-*/"              // quatro operacoes
      val_sinal  := CHR(tecla)
      MostraSinal(val_sinal)

      IF EMPTY(val_string)
         val_string := STR(val_ultimo)
      ENDIF

      AddFita(PADL(val_string,20) + " " + val_sinal)
      IF old_sinal = "%"
         val_ultimo = 0
      ELSE
         val_ultimo := VAL(val_string)
      ENDIF
      MostraFita()

      IF EMPTY(old_sinal)
         val_conta := VAL(val_string)
      ENDIF

      val_valor := VAL(val_string)
      IF old_sinal = "+"
	 val_conta  += val_valor
      ELSEIF old_sinal = "-"
	 val_conta  -= val_valor
      ELSEIF old_sinal = "*"
	 val_conta  *= val_valor
      ELSEIF old_sinal = "/"
         IF !EMPTY(val_valor)
            val_conta  /= val_valor
         ELSE
            AddFita(PADL("DIVISAO POR ZERO",22))
            val_conta  := 0
         ENDIF
      ENDIF

      val_string := STR(val_conta)
      limpa      := .T.
      old_sinal  := val_sinal

   ENDIF
ENDDO
SETPOS(24,0)
RESTSCREEN(,,,,tela)
SETCURSOR(cursor)
SETCOLOR(cor)
RETURN


***
* Funcao de exibicao da fita da calculadora
*------>
FUNCTION MostraFita()
LOCAL linhas := LEN(val_fita), ach, x, cor := SETCOLOR()
val_pont := LEN(val_fita)
SETCOLOR(c_jancal)
KEYBOARD CHR(30)
ach := ACHOICE(19 - IF(linhas < 11,linhas,12),43,18,65,val_fita,,"CtrlFita")
SETCOLOR(cor)


***
* Funcao para mover a fita para cima e para baixo
*------>
FUNCTION MoveFita(pont)
LOCAL cor := SETCOLOR(), ach, x, y, lin
SETCOLOR(c_jancal)
lin := 18
FOR y := pont TO pont - 11 STEP -1
   @ lin,43 SAY val_fita[y]
   lin--
NEXT
SETCOLOR(cor)

***
* Funcao de controle da ACHOICE em MostraFita()
*------>
FUNCTION CtrlFita(modo)
IF modo = 3
   RETURN(0)
ENDIF


***
* Funcao de exibicao da ajuda na posicao da fita
*------>
FUNCTION SayCalcHelp()
LOCAL telinha := SAVESCREEN(06,39,19,66), cor := SETCOLOR(c_jancal)
Say(07,40," E - zera visor           ")
Say(08,40," F - zera fita            ")
Say(09,40," C - zera c lculo         ")
Say(10,40," I - imprime fita         ")
Say(11,40," L - logar¡tmos           ")
Say(12,40," P - impress„o simultƒnea ")
Say(13,40," R - raiz quadrada        ")
Say(14,40," T - transfere valor      ")
Say(15,40," % - percentagem          ")
Say(16,40," ^ - exponencia‡„o        ")
Say(17,40,"                          ")
Say(18,40," H - mais ajuda           ")
INKEY(0)
IF !(CHR(LASTKEY()) $ "Hh")
   SETCOLOR(cor)
   RESTSCREEN(06,39,19,66,telinha)
   RETURN(NIL)
ENDIF
Say(07,40," M+ - mem¢ria adicionar   ")
Say(08,40," M- - mem¢ria subtrair    ")
Say(09,40," MR - mem¢ria resultado   ")
Say(10,40," MC - zera mem¢ria        ")
Say(11,40,"                          ")
Say(12,40," Esc - sai                ")
Say(13,40," Enter - totaliza         ")
Say(14,40,"                          ")
Say(15,40,"                          ")
Say(16,40,"                          ")
Say(17,40,"                          ")
Say(18,40,"                          ")
INKEY(0)
SETCOLOR(cor)
RESTSCREEN(06,39,19,66,telinha)


***
* Funcao que adiciona uma parcela na fita
*------>
FUNCTION AddFita(string)
AADD(val_fita,string)
IF val_print
   SET DEVICE TO PRINTER
   SET CONSOLE OFF
   IF AT("Ä",string) <> 0
      @ PROW() + 1,2 SAY " " + REPLICATE("-",21)
   ELSE
      @ PROW() + 1,2 SAY string
   ENDIF
   SET CONSOLE ON
   SET DEVICE TO SCREEN
ENDIF

***
* Funcao para a exibicao do operador selecionado
*------>
FUNCTION MostraSinal(sinal)
LOCAL cor := SETCOLOR()
SETCOLOR(c_descal)
@ 07,35 SAY sinal
SETCOLOR(cor)

***
* Funcao para montagem de retangulo
*------>
FUNCTION Quadro(l1,c1,l2,c2)
DISPBOX(l1,c1,l2,c2,1)
DISPBOX(l1+1,c1+1,l2-1,c2-1,"         ")

*----------------------->
* Fim do arquivo


***************
function NOMMES
***************

parameters M_DATA

  if empty(M_DATA)
    return space(09)
  endif

  private MESES[12]

  declare MESES[12]

  MESES[1]  = "Janeiro  " 
  MESES[2]  = "Fevereiro"
  MESES[3]  = "Marco    "
  MESES[4]  = "Abril    "
  MESES[5]  = "Maio     " 
  MESES[6]  = "Junho    "
  MESES[7]  = "Julho    "
  MESES[8]  = "Agosto   " 
  MESES[9]  = "Setembro "
  MESES[10] = "Outubro  "
  MESES[11] = "Novembro "
  MESES[12] = "Dezembro " 

return MESES[month(M_DATA)]

*****************
function LAY_DUP2
*****************

parameters M_DUPVLD

private MT_MES[12]

declare MT_MES[12]

MT_MES[ 1] = "JANEIRO  "
MT_MES[ 2] = "FEVEREIRO"
MT_MES[ 3] = "MARCO    "
MT_MES[ 4] = "ABRIL    "
MT_MES[ 5] = "MAIO     "
MT_MES[ 6] = "JUNHO    "
MT_MES[ 7] = "JULHO    "
MT_MES[ 8] = "AGOSTO   "
MT_MES[ 9] = "SETEMBRO "
MT_MES[10] = "OUTUBRO  "
MT_MES[11] = "NOVEMBRO "
MT_MES[12] = "DEZEMBRO "
      
      ?
      ?
      ?
      ?  
      ?
      ? space(70)
       ?? dtoc(DUPDTE)

      ?
      ?
      ?
      ?
      ? space(02)
        ?? str(DUPNUM, 6, 0)
        ?? "-"
        ?? DUPSER
        ?? space(01)
        ?? spcvar("R$ " + alltrim(transform(DUPNFS,"@E ###,###,###.##")), 15)
        ?? space(02)
        ?? spcvar("R$ " + alltrim(transform(M_DUPVLD,"@E ###,###,###.##")), 15)
        ?? space(02)

        ?? str(DUPNUM, 6, 0)
        ?? substr(dtoc(DUPDTE), 6, 3)
        ?? "-" 
        ?? strzero(DUPORD, 2, 0)
        ?? space(07)
        ?? DUPVCT 

      ? space(28)
        if M_JUROS > 0
          ?? "                 ATRASO COBRAR "
          ?? transform(((M_DUPVLD * .01) * M_JUROS),"@E #,###.##")
          ?? " REAIS AO DIA"
        endif 

      ?
      ? space(34)
       ?? ACLI00->CLINOM
       ?? space(01)
       ?? str(DUPCLI, 7, 0)

      ?
      ? space(34)
       ?? pad(ACLI00->CLIEND2, 36)

      ? space(34)
       ?? ACLI00->CLIMUN2
       ?? space(31)
       ?? ACLI00->CLIUF2

      ?
      ? space(34)
       ?? pad(ACLI00->CLIEND3, 38)

      ? space(34)
       ?? ACLI00->CLIMUN3
       ?? " "
       ?? ACLI00->CLIUF3
       ?? space(12)
       ?? strzero(ACLI00->CLICEP3, 5, 0)
       ?? "-"
       ?? strzero(ACLI00->CLICCL3, 3, 0)       

      ? space(34)
        if len(rtrim(ACLI00->CLICGC2)) = 11
          ?? transform(ACLI00->CLICGC2,"@R 999.999.999/99")
          ?? space(04)
        else
          ?? transform(ACLI00->CLICGC2,"@R 999.999.999/9999-99")
        endif
          ?? space(11)
          ?? ACLI00->CLIIES2

        extenso(M_DUPVLD, VAL_EXT, 60)

        ?
        ? space(32)
          ?? rtrim(VAL_EXT[ 1 ])
          if !empty(VAL_EXT[1])
            ?? replicate("*",(60 - len(rtrim(VAL_EXT[1]))))
          endif
        ? space(32)
          ?? rtrim(VAL_EXT[ 2 ])
          if !empty(VAL_EXT[2])
            ?? replicate("*",(60 - len(rtrim(VAL_EXT[2]))))
          endif
        ? space(32)
          ?? rtrim(VAL_EXT[ 3 ])
          if !empty(VAL_EXT[3])
            ?? replicate("*",(60 - len(rtrim(VAL_EXT[3]))))
          endif

return ""

************************
static procedure PROTEGE
************************

private M_TELA ,M_TELA1,;
        M_TECLA,R,C,T,M_CURSOR

  M_AREA = select()

  M_TELA1 := savescreen(00,00,24,79)

  M_COR = setcolor()
  setcolor("")
  clear screen

  M_SEG3 = val(substr(time(),8,1))

  declare M_NUM[7]

  M_NUM[1] = " ÜÜÜÜ      Ü ÜÜÜÜ  ÜÜÜÜ Ü    Ü ÜÜÜÜ  ÜÜÜÜ  ÜÜÜÜ  ÜÜÜÜ  ÜÜÜÜ "
  M_NUM[2] = "Û    Û     Û     Û     ÛÛ    ÛÛ     Û          ÛÛ    ÛÛ    Û"
  M_NUM[3] = "Û    Û     Û     Û     ÛÛ    ÛÛ     Û          ÛÛ    ÛÛ    Û"
  M_NUM[4] = "ß    ß     ß ÜÜÜÜß   ÜÜßßÜÜÜÜßßÜÜÜÜ ßÜÜÜÜ      ßßÜÜÜÜßßÜÜÜÜß"
  M_NUM[5] = "Û    Û     ÛÛ          Û     Û     ÛÛ    Û     ÛÛ    Û     Û"
  M_NUM[6] = "Û    Û     ÛÛ          Û     Û     ÛÛ    Û     ÛÛ    Û     Û"
  M_NUM[7] = "ßÜÜÜÜß     ÛßÜÜÜÜÜ ÜÜÜÜß     Û ÜÜÜÜßßÜÜÜÜß     ÛßÜÜÜÜß ÜÜÜÜß"

  set cursor off

  M_MOSTRA = .t.

  M_HORA1= val(substr(time(),1,1))
  M_HORA2= val(substr(time(),2,1))

  M_MIN1= val(substr(time(),4,1))
  M_MIN2= val(substr(time(),5,1))

  M_SEG1= val(substr(time(),7,1))
  M_SEG2= 99

  M_COL = 0
  M_LIN = 0
  M_COLANT = 0
  M_LINANT = 0
  M_SOB = "D"
  
  M_DIR = "D"

do while .t.

  M_TECLA = inkey(.3)

  if lAge = .t.
    if !nHormem == space(05)
      if AEMP00->EMPSEN == "S"
        if left(time(),5) >= nHormem
          lAge = .f.
          chama_agenda()
          lAge = .t.
        endif
      endif
    endif
  endif

  if M_TECLA > 0
    setcolor("&M_COR")
    M_CUR = setcursor()
    restscreen(00,00,24,79,M_TELA1)
    select &M_AREA
    return
  endif
 
  M_HORA1= val(substr(time(),1,1))
  M_HORA2= val(substr(time(),2,1))

  M_MIN1= val(substr(time(),4,1))
  M_MIN2= val(substr(time(),5,1))

  M_SEG1= val(substr(time(),7,1))
  M_SEG2= val(substr(time(),8,1))

  o_col2()               // posiciona coluna e linha

  mosrel()

enddo

***************
function MOSREL
***************

set color to &_PROTECAO_

if M_COL # M_COLANT .or. M_LIN # M_LINANT
   M_COLANT = M_COL
   M_LINANT = M_LIN

  @ M_LIN -2 , M_COL say space(54)
  @ M_LIN -1 , M_COL say padc(alltrim(AEMP00->EMPNOM), 55)
  @ M_LIN    , M_COL say space(54)
  @ M_LIN +1 , M_COL SAY " " + substr(M_NUM[1],(M_HORA1*6)+1,6) + "  "     + ;
             substr(M_NUM[1],(M_HORA2*6)+1,6) + "     " + ;
             substr(M_NUM[1],(M_MIN1*6)+1,6)  + "  "     + ;
             substr(M_NUM[1],(M_MIN2*6)+1,6)  + "     " + ;
             substr(M_NUM[1],(M_SEG1*6)+1,6)  + "  "     + ;
             substr(M_NUM[1],(M_SEG2*6)+1,6)  + "   " 

  @ M_LIN +2, M_COL SAY " " + substr(M_NUM[2],(M_HORA1*6)+1,6) + "  "     + ;
             substr(M_NUM[2],(M_HORA2*6)+1,6) + "     " + ;
             substr(M_NUM[2],(M_MIN1*6)+1,6)  + "  "     + ;
             substr(M_NUM[2],(M_MIN2*6)+1,6)  + "     " + ;
             substr(M_NUM[2],(M_SEG1*6)+1,6)  + "  "     + ;
             substr(M_NUM[2],(M_SEG2*6)+1,6)  + " " 

  @ M_LIN +3, M_COL SAY " " + substr(M_NUM[3],(M_HORA1*6)+1,6) + "  "     + ;
             substr(M_NUM[3],(M_HORA2*6)+1,6) + "     " + ;
             substr(M_NUM[3],(M_MIN1*6)+1,6)  + "  "     + ;
             substr(M_NUM[3],(M_MIN2*6)+1,6)  + "     " + ;
             substr(M_NUM[3],(M_SEG1*6)+1,6)  + "  "     + ;
             substr(M_NUM[3],(M_SEG2*6)+1,6)  + " " 

  @ M_LIN +4, M_COL SAY " " + substr(M_NUM[4],(M_HORA1*6)+1,6) + "  "     + ;
             substr(M_NUM[4],(M_HORA2*6)+1,6) + "     " + ;
             substr(M_NUM[4],(M_MIN1*6)+1,6)  + "  "     + ;
             substr(M_NUM[4],(M_MIN2*6)+1,6)  + "     " + ;
             substr(M_NUM[4],(M_SEG1*6)+1,6)  + "  "     + ;
             substr(M_NUM[4],(M_SEG2*6)+1,6)  + " " 

  @ M_LIN +5, M_COL SAY " " + substr(M_NUM[5],(M_HORA1*6)+1,6) + "  "     + ;
             substr(M_NUM[5],(M_HORA2*6)+1,6) + "     " + ;
             substr(M_NUM[5],(M_MIN1*6)+1,6)  + "  "     + ;
             substr(M_NUM[5],(M_MIN2*6)+1,6)  + "     " + ;
             substr(M_NUM[5],(M_SEG1*6)+1,6)  + "  "     + ;
             substr(M_NUM[5],(M_SEG2*6)+1,6)  + " " 

  @ M_LIN +6, M_COL SAY " " + substr(M_NUM[6],(M_HORA1*6)+1,6) + "  "     + ;
             substr(M_NUM[6],(M_HORA2*6)+1,6) + "     " + ;
             substr(M_NUM[6],(M_MIN1*6)+1,6)  + "  "     + ;
             substr(M_NUM[6],(M_MIN2*6)+1,6)  + "     " + ;
             substr(M_NUM[6],(M_SEG1*6)+1,6)  + "  "     + ;
             substr(M_NUM[6],(M_SEG2*6)+1,6)  + " " 
 
  @ M_LIN +7, M_COL SAY " " + substr(M_NUM[7],(M_HORA1*6)+1,6) + "  "     + ;
             substr(M_NUM[7],(M_HORA2*6)+1,6) + "     " + ;
             substr(M_NUM[7],(M_MIN1*6)+1,6)  + "  "     + ;
             substr(M_NUM[7],(M_MIN2*6)+1,6)  + "     " + ;
             substr(M_NUM[7],(M_SEG1*6)+1,6)  + "  "     + ;
             substr(M_NUM[7],(M_SEG2*6)+1,6)  + "   " 

  @ M_LIN +8, M_COL say space(54)

  if M_SEG3 # val(substr(time(),8,1))
    M_SEG3 = val(substr(time(),8,1))
    if M_MOSTRA = .f.
      M_MOSTRA = .t.
    else
      M_MOSTRA = .f.
    endif
  endif

  if M_MOSTRA = .f.
    @ M_LIN +3, M_COL+15 say "     " 
    @ M_LIN +3, M_COL+34 say "     " 

    @ M_LIN +5, M_COL+15 say "     " 
    @ M_LIN +5, M_COL+34 say "     " 
  else
    @ M_LIN +3, M_COL+15 say "  Û  "
    @ M_LIN +3, M_COL+34 say "  Û  "
    @ M_LIN +5, M_COL+15 say "  Û  "
    @ M_LIN +5, M_COL+34 say "  Û  "
  endif
endif

set color to

return ""

**************
function LINHA
**************

if M_SOB = "D"
  M_LIN ++
  if M_LIN > 16
    M_SOB = "S"
    M_LIN = 17
  endif
else
  M_LIN --
  if M_LIN < 1
    M_SOB = "D"
    M_LIN = 0
  endif
endif

return

************
function O_COL2
************

if M_DIR = "D"
  M_COL ++
  linha()
  if M_COL > 27
    M_COL = 27
    M_DIR = "E"
  endif
else
  M_COL --
  linha()
  if M_COL < 1
    M_COL = 0
    M_DIR = "D"
  endif
endif

return

* EOF

**************************************************************************

*********************
#include "common.ch"
#include "inkey.ch"
*********************

function MENUMODAL(Arg1, Arg2, Arg3, Arg4)

local Local1, Local2, Local3, Local4, Local5, Local6, Local7, ;
Local8, Local9, Local10
Local7:= setcursor(0)
Local8:= acolor()[2]
Local9:= acolor()[1]
Local10:= {|_1, _2| (DevPos((DevPos(Arg1[Arg2][1], ;
Arg1[Arg2][2]), DevOut(Arg1[Arg2][3], _1), Arg1[Arg2][1]), ;
Arg1[Arg2][2] + Arg1[Arg2][5] - 1), DevOut(Arg1[Arg2][4], ;
iif(_2, Arg1[Arg2][6], _1)))}
Arg1:= iif(ValType(Arg1) == ValType({}) .AND. Arg1 != Nil, Arg1, ;
{})
Arg3:= iif(ValType(Arg3) == ValType({0, 0, ""}) .AND. Arg3 != ;
Nil, Arg3, {0, 0, ""})
Arg4:= iif(ValType(Arg4) == ValType("") .AND. Arg4 != Nil, Arg4, ;
"")
Local4:= {|| iif(Empty(Arg1[Arg2][7]), Nil, ;
iif(Empty(Arg1[Arg2][8]), Nil, (DevPos(Arg1[Arg2][8], ;
Arg1[Arg2][9]), DevOut(Arg1[Arg2][7], Arg1[Arg2][10]))))}
readvar(Arg4)

if (ValType(Arg2) != "N")
  Arg2:= 1
endif
if (!Empty(Arg1))
  if (Arg2 > Len(Arg1))
    Arg2:= Len(Arg1)
  endif
  if (Arg2 < 1)
    Arg2:= 1
  endif
  menudispla(Arg1, Local9)

  if AEMP00->EMPSEN == "S"
    nLinlog = iif(Arg1[Arg2,13] != NIL,str(Arg1[Arg2,13],1),0)
    nCollog = iif(Arg1[Arg2,14] != NIL,str(Arg1[Arg2,14],1),0)
    nPoslog = iif(Arg1[Arg2,15] != NIL,Arg1[Arg2,15],Arg1[Arg2,15])

    if nPoslog != NIL
      if !substr(W_LOG&nLinlog&nCollog,nPoslog, 1) = "S"
        keyboard chr(24)
      endif
    endif
  endif

  while (.T.)

    Local5:= iif(Empty(Arg1[Arg2][7]), Nil, ;
    SaveScreen(Arg1[Arg2][8], Arg1[Arg2][9], Arg1[Arg2][8], ;
    Arg1[Arg2][9] + Len(Arg1[Arg2][7])))

    if AEMP00->EMPSEN == "S"
      nLinlog = iif(Arg1[Arg2,13] != NIL,str(Arg1[Arg2,13],1),0)
      nCollog = iif(Arg1[Arg2,14] != NIL,str(Arg1[Arg2,14],1),0)
      nPoslog = iif(Arg1[Arg2,15] != NIL,Arg1[Arg2,15],Arg1[Arg2,15])
      if nPoslog != NIL
        if substr(W_LOG&nLinlog&nCollog,nPoslog, 1) = "S"
          eval(Local10, Local8, .F.)
        else
          eval(Local10, "N+/N", .F.)
        endif
      else
         eval(Local10, Local8, .F.)
      endif
    else
      eval(Local10, Local8, .F.)
    endif

    eval(Local4)
    Local1:= 0
    nTempo = seconds()

    while (.T.)

      SetPos(Arg3[1], Arg3[2])
      DevOut(iif(ISBLOCK(Arg3[3]), eval(Arg3[3]), Arg3[3]))

      if (seconds() - nTempo) > (val(left(_EMPPRT_,2)) * 60)  + val(right(_EMPPRT_,2))
*        protege()
        nTempo = seconds()
      endif

      if lAge = .t.
        if !nHormem == space(05)
          if AEMP00->EMPSEN == "S"
            if left(time(),5) >= nHormem
              lAge = .f.
              chama_agenda()
              lAge = .t.
            endif
          endif
        endif
      endif

      if (Local1:= inkey()) != 0
        exit
      endif

    end


    if (Local5 != Nil)
      RestScreen(Arg1[Arg2][8], Arg1[Arg2][9], Arg1[Arg2][8], ;
      Arg1[Arg2][9] + Len(Arg1[Arg2][7]), Local5)
    endif

    if ((Local2:= setkey(Local1)) != Nil) .or. !((Local2:= setkey(Local1)) == NIL)
      eval(Local2, Arg1, @Arg2, Local1)
    else

    if AEMP00->EMPSEN == "S"
      if nPoslog != NIL
        if substr(W_LOG&nLinlog&nCollog,nPoslog, 1) = "S"
          eval(Local10, Local9, .T.)
        else
          eval(Local10, "N+/BG", .T.)
        endif
      else
         eval(Local10, Local9, .T.)
      endif
    else
      eval(Local10, Local9, .T.)
    endif

    if (Set(1))
      if (ascan(Arg1, {|_1| _1[4] == Chr(Local1)}, Arg2) == ;
        Arg2)
        if (Empty(Local3:= ascan(Arg1, {|_1| _1[4] == ;
          Chr(Local1)}, Arg2 + 1)))
          Local3:= ascan(Arg1, {|_1| _1[4] == Chr(Local1)})
        endif
      else
        Local3:= ascan(Arg1, {|_1| _1[4] == Chr(Local1)}, 1)
      endif
    elseif (ascan(Arg1, {|_1| Upper(_1[4]) == ;
      Upper(Chr(Local1))}, Arg2) == Arg2)
      if (Empty(Local3:= ascan(Arg1, {|_1| Upper(_1[4]) == ;
        Upper(Chr(Local1))}, Arg2 + 1)))
        Local3:= ascan(Arg1, {|_1| Upper(_1[4]) == ;
        Upper(Chr(Local1))})
      endif
    else
      Local3:= ascan(Arg1, {|_1| Upper(_1[4]) == ;
      Upper(Chr(Local1))}, 1)
    endif

    do case
      case !Empty(Local3)
        Arg2:= Local3
        nLinlog = iif(Arg1[Arg2,13] != NIL,str(Arg1[Arg2,13],1),0)
        nCollog = iif(Arg1[Arg2,14] != NIL,str(Arg1[Arg2,14],1),0)
        nPoslog = iif(Arg1[Arg2,15] != NIL,Arg1[Arg2,15],Arg1[Arg2,15])
        if nPoslog != NIL .and. AEMP00->EMPSEN == "S"
          if substr(W_LOG&nLinlog&nCollog,nPoslog, 1) = "S"
            if (!Set(27))
              eval(Local10, Local8, .F.)
              Local6:= eval(Arg1[Arg2][12], Arg1, @Arg2, Local1)
              Local6:= iif(ValType(Local6) == ValType(.F.) .AND. ;
              Local6 != Nil, Local6, .F.)
              if (!Local6)
                exit
              elseif (Arg2 < 1 .OR. Arg2 > Len(Arg1))
                Arg2:= 1
              endif
            endif
          endif
        else
          if (!Set(27))
            eval(Local10, Local8, .F.)
            Local6:= eval(Arg1[Arg2][12], Arg1, @Arg2, Local1)
            Local6:= iif(ValType(Local6) == ValType(.F.) .AND. ;
            Local6 != Nil, Local6, .F.)
            if (!Local6)
              exit
            elseif (Arg2 < 1 .OR. Arg2 > Len(Arg1))
              Arg2:= 1
            endif
          endif
        endif
      case Local1 == 27
        Arg2:= 0
        exit
      case Local1 == 5 .OR. Local1 == 4
         lPos1 = 0
         do while .t.
           if (--Arg2 < 1)
             Arg2:= iif(Set(35), Len(Arg1), 1)
           endif
           if AEMP00->EMPSEN == "S"
             nLinlog = iif(Arg1[Arg2,13] != NIL,str(Arg1[Arg2,13],1),0)
             nCollog = iif(Arg1[Arg2,14] != NIL,str(Arg1[Arg2,14],1),0)
             nPoslog = iif(Arg1[Arg2,15] != NIL,Arg1[Arg2,15],Arg1[Arg2,15])
             if nPoslog != NIL
               if substr(W_LOG&nLinlog&nCollog,nPoslog, 1) = "S"
                 exit
               endif
             else
               exit
             endif
             if(++lPos1 > len(Arg1))
               exit
             endif
           else
             exit
           endif
         enddo
      case Local1 == 24 .OR. Local1 == 19
        lPos1 = 0
        do while .t.
          if (++Arg2 > Len(Arg1))
            Arg2:= iif(Set(35), 1, Len(Arg1))
          endif
          if AEMP00->EMPSEN == "S"
            nLinlog = iif(Arg1[Arg2,13] != NIL,str(Arg1[Arg2,13],1),0)
            nCollog = iif(Arg1[Arg2,14] != NIL,str(Arg1[Arg2,14],1),0)
            nPoslog = iif(Arg1[Arg2,15] != NIL,Arg1[Arg2,15],Arg1[Arg2,15])
            if nPoslog != NIL
              if substr(W_LOG&nLinlog&nCollog,nPoslog, 1) = "S"
                exit
              endif
            else
              exit
            endif
            if(++lPos1 > len(Arg1))
              exit
            endif
          else
            exit
          endif
        enddo
      case Local1 == 13
       if AEMP00->EMPSEN == "S"
         nLinlog = iif(Arg1[Arg2,13] != NIL,str(Arg1[Arg2,13],1),0)
         nCollog = iif(Arg1[Arg2,14] != NIL,str(Arg1[Arg2,14],1),0)
         nPoslog = iif(Arg1[Arg2,15] != NIL,Arg1[Arg2,15],Arg1[Arg2,15])

         if nPoslog != NIL
           if substr(W_LOG&nLinlog&nCollog,nPoslog, 1) = "N"
             loop
           endif
         endif
       endif

        eval(Local10, Local8, .F.)
        Local6:= eval(Arg1[Arg2][12], Local1, Arg1, @Arg2)
        Local6:= iif(ValType(Local6) == ValType(.F.) .AND. ;
        Local6 != Nil, Local6, .F.)
        if (!Local6)
          exit
        elseif (Arg2 < 1 .OR. Arg2 > Len(Arg1))
          Arg2:= 1
        endif
      case Local1 == 1
        Arg2:= 1
      case Local1 == 6
        Arg2:= Len(Arg1)
    endcase
  endif
  end
endif
setcursor(Local7)
return iif(Empty(Arg1), .F., LastKey() != K_ESC)

* EOF

********************************
function MENUNEW(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, ;
   Arg9, Arg10, Arg11, Arg12, Arg13, Arg14)

   local Local1, Local2
   Arg5:= iif(ValType(Arg5) == ValType(acolor()[2]) .AND. Arg5 != ;
      Nil, Arg5, acolor()[2])
   Arg9:= iif(ValType(Arg9) == ValType(SetColor()) .AND. Arg9 != ;
      Nil, Arg9, SetColor())
   Arg8:= iif(ValType(Arg8) == ValType(0) .AND. Arg8 != Nil, Arg8, 0)
   Arg6:= iif(ValType(Arg6) == ValType("") .AND. Arg6 != Nil, Arg6, ;
      "")
   Arg11:= iif(ValType(Arg11) == ValType({|| .F.}) .AND. Arg11 != ;
      Nil, Arg11, {|| .F.})
   if (ValType(Arg4) != "N")
      Local2:= Left(alltrim(Arg3), 1)
      Arg4:= At(Local2, Arg3)
   else
      Local2:= SubStr(Arg3, Arg4, 1)
   endif
   if (Arg10)
      Arg7:= iif(ValType(Arg7) == ValType(Set(36)) .AND. Arg7 != ;
         Nil, Arg7, Set(36))
      Arg8:= MaxCol() / 2 - Int(Len(Arg6) / 2)
   elseif (ISNIL(Arg7))
      Arg7:= iif(ValType(Arg7) == ValType(Set(36)) .AND. Arg7 != ;
         Nil, Arg7, Set(36))
      Arg8:= 0
   endif
   Local1:= {Arg1, Arg2, Arg3, Local2, Arg4, Arg5, Arg6, Arg7, Arg8, ;
      Arg9, Arg10, Arg11, Arg12, Arg13, Arg14}
   return Local1

* EOF

*******************************
function MENUDISPLA(Arg1, Arg2)
*******************************

   local Local1
   if (ValType(Arg1) = "A")
      Arg2:= iif(ValType(Arg2) == ValType(acolor()[1]) .AND. Arg2 != ;
         Nil, Arg2, acolor()[1])
      dispbegin()
      for Local1:= 1 to Len(Arg1)
         DevPos(Arg1[Local1][1], Arg1[Local1][2])

         if AEMP00->EMPSEN == "S"
           nLinlog = iif(Arg1[Local1,13] != NIL,str(Arg1[Local1,13],1),0)
           nCollog = iif(Arg1[Local1,14] != NIL,str(Arg1[Local1,14],1),0)
           nPoslog = iif(Arg1[Local1,15] != NIL,Arg1[Local1,15],Arg1[Local1,15])

           if nPoslog != NIL
             if substr(W_LOG&nLinlog&nCollog,nPoslog, 1) = "S"
               DevOut(Arg1[Local1][3], Arg2)
             else
               DevOut(Arg1[Local1][3], "N+/BG")
             endif
           else
             DevOut(Arg1[Local1][3], Arg2)
           endif
         else
           DevOut(Arg1[Local1][3], Arg2)
         endif
         DevPos(Arg1[Local1][1], Arg1[Local1][2] + Arg1[Local1][5] - ;
            1)
         DevOut(Arg1[Local1][4], Arg1[Local1][6])
      next
      dispend()
   endif
   return Nil

* EOF

*****************
function CALENDAR2
*****************

#include "ptmenu.ch"

set cent on

private M_OPC

wLin = row()
wCol = col()
MMES="         Janeiro Fevereiro Marco    Abril    Maio     Junho    Julho    Agosto   Setembro Outubro  Novembro Dezembro "
DT = date()
set cursor off

TELAANT=savescreen(06, 00, 24, 79)
CORANT = setcolor()

painel(06, 21, 17, 57,"R+/R","N/R")

painel(06, 16, 08, 20,"R+/R","N/R")
  set color to GR+/R
     @ 07, 17 say " " + chr(24) + " "

painel(09, 16, 11, 20,"R+/R","N/R")
  set color to GR+/R
     @ 10, 17 say " " + chr(27) + " "

painel(12, 16, 14, 20,"R+/R","N/R")
  set color to GR+/R
     @ 13, 17 say "Ins"

painel(15, 16, 17, 20,"R+/R","N/R")
  set color to GR+/R
     @ 16, 17 say "   "

*************************************
painel(06, 58, 08, 62,"R+/R","N/R")
  set color to GR+/R
     @ 07, 59 say " " + chr(25) + " "

painel(09, 58, 11, 62,"R+/R","N/R")
  set color to GR+/R
     @ 10, 59 say " " + chr(26) + " "

painel(12, 58, 14, 62,"R+/R","N/R")
  set color to GR+/R
     @ 13, 59 say " ? "

painel(15, 58, 17, 62,"R+/R","N/R")
  set color to GR+/R
     @ 16, 59 say " " + chr(9) + " "

set color to W+/R 
@ 07, 22 say "                                   "
@ 08, 22 say "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ "
@ 09, 22 say " Dom  Seg  Ter  Qua  Qui  Sex  Sab "
@ 10, 22 say "                                   "
@ 11, 22 say "                                   "
@ 12, 22 say "                                   "
@ 13, 22 say "                                   "
@ 14, 22 say "                                   "
@ 15, 22 say "                                   "
@ 16, 22 say "                                   "

sombra(06, 16, 17, 62)

TCAL = savescreen(06, 16, 18, 63)

clear typeahead

monta_tela()

do while .t.

  LIN = 0
  COL = 0

  do while .t.

    tecla = 0
    tecla = inkey()
    if rat(strzero(tecla,3),"027.019.004.005.024.022") = 0
      loop
    endif

      do case
         case tecla = 19 
              invbotao(09, 16, 11, 20,"R+/R","N/R")
              if year(DT) = 100 .and. month(DT) = 1
                loop
              endif
              AT = DT
              DT = DT - (20 + day(DT))
              DT = ctod(substr(dtoc(AT), 1, 2) + substr(dtoc(DT), 3, 8))
              do while empty(DT)
                AT = AT - 1
                DT = AT
                DT = DT - (20 + day(DT))  
                DT = ctod(substr(dtoc(AT), 1, 2) + substr(dtoc(DT), 3, 8))
              enddo
         case tecla = 04 
              invbotao(09, 58, 11, 62,"R+/R","N/R")
              if year(DT) = 2999 .and. month(DT) = 12
                loop
              endif
              AT = DT
              DT = DT + (40 - day(DT))
              DT = ctod(substr(dtoc(AT), 1, 2) + substr(dtoc(DT), 3, 8))
         case tecla = 5 
              invbotao(06, 16, 08, 20,"R+/R","N/R") 
              if year(DT) = 2999
                loop
              endif 
              AT = year(DT) + 1
              DT = ctod(substr(dtoc(DT), 1, 6) + str(AT, 4))
         case tecla = 24 
              invbotao(06, 58, 08, 62,"R+/R","N/R")
              if year(DT) = 100
                loop
              endif
              AT = year(DT) - 1
              DT = ctod(substr(dtoc(DT), 1, 6) + str(AT, 4))
         case tecla = 22 
              invbotao(12, 16, 14, 20,"R+/R","N/R")
              wTelaData = savescreen(18, 16, 22, 63)
              MM=DT
              painel(18, 16, 20, 62,"R+/R","N/R")
              sombra(18, 16, 20, 62)
              set  color to GR+/R,W+/R
                @ 19, 17 say "              Data :   /  /                  "
              set cursor on
              @ 19, 38 get MM picture "99/99/9999" valid M1()
              read
              set cursor off
              DT = MM
              restscreen(18, 16, 22, 63, wTelaData)
         case tecla = 27
              invbotao(15, 58, 17, 62,"R+/R","N/R")
              set century off
              restscreen(06, 00, 24, 79, TELAANT)
              return ""
      endcase
      monta_tela()
  enddo
enddo

@ wLin, wCol say " " 
set century off
restscreen(06, 00, 24, 79, TELAANT)
set color to

return ""

***********
function M1
***********

if year(MM) < 100 .or. year(MM) > 2999
  msg("* * *  ANO DA DATA INVALIDO * * *")   
  return .f.
endif

monta_tela()

return .t.

*******************
function MONTA_TELA
*******************

  restscreen(06, 16, 18, 63, TCAL)
  T=ltri(str(day(DT))) + " de " + rtrim(substr(MMES, val(substr(dtoc(DT), 4, 2)) * 9,9)) + " de " + ltrim(str(year(DT))) + "."

  MENSA = T
  
  set color to GR+ /R
    @ 07, int((80 - len(MENSA))/2) say MENSA
  set color to

  store space(02) to DT01, DT02, DT03, DT04, DT05, DT06, DT07, DT08,;
                     DT09, DT10, DT11, DT12, DT13, DT14, DT15, DT16,;
                     DT17, DT18, DT19, DT20, DT21, DT22, DT23, DT24,;
                     DT25, DT26, DT27, DT28, DT29, DT30, DT31, DT32,;
                     DT33, DT34, DT35, DT36, DT37, DT38, DT39, DT40,;
                     DT41, DT42

  DATA = CTOD("01/" + substr(dtoc(DT), 4, 7))
  KONT = dow(DATA)
  MES  = month(DATA)

  do while month(DATA) = MES
    KK = strzero(KONT, 2)
    DT&KK. = str(day(DATA), 2)
    KONT = KONT + 1
    DATA = DATA + 1
  enddo

  set color to N/R
    @ 11, 24 say DT01 
    @ 11, 29 say DT02 
    @ 11, 34 say DT03 
    @ 11, 39 say DT04 
    @ 11, 44 say DT05 
    @ 11, 49 say DT06 
    @ 11, 54 say DT07 
    @ 12, 24 say DT08 
    @ 12, 29 say DT09 
    @ 12, 34 say DT10 
    @ 12, 39 say DT11 
    @ 12, 44 say DT12 
    @ 12, 49 say DT13 
    @ 12, 54 say DT14 
    @ 13, 24 say DT15 
    @ 13, 29 say DT16 
    @ 13, 34 say DT17 
    @ 13, 39 say DT18 
    @ 13, 44 say DT19 
    @ 13, 49 say DT20 
    @ 13, 54 say DT21 
    @ 14, 24 say DT22 
    @ 14, 29 say DT23 
    @ 14, 34 say DT24 
    @ 14, 39 say DT25 
    @ 14, 44 say DT26 
    @ 14, 49 say DT27 
    @ 14, 54 say DT28 
    @ 15, 24 say DT29 
    @ 15, 29 say DT30 
    @ 15, 34 say DT31 
    @ 15, 39 say DT32 
    @ 15, 44 say DT33 
    @ 15, 49 say DT34 
    @ 15, 54 say DT35 
    @ 16, 24 say DT36  
    @ 16, 29 say DT37  
    @ 16, 34 say DT38  
    @ 16, 39 say DT39  
    @ 16, 44 say DT40  
    @ 16, 49 say DT41  
    @ 16, 54 say DT42  

    KONT = 1

    for LIN = 11 to 16
      for COL = 24 to 54 step 5
        KC=strzero(KONT, 2)
        if DT&KC. = str(day(DT), 2)
          set color to GR+ /R
             @ LIN, COL say DT&KC
          set color to GR+ /BR
        endif
        KONT = KONT + 1
      next  
    next

return

*****************
function INVBOTAO
*****************

parameters LI,CI,LF,CF,CT,CD

 painel(LI, CI, LF, CF, CD, CT)
   inkey(.2)
 painel(LI, CI, LF, CF, CT, CD)

return ""

*****************
function TIRA_BAR     && retira barra de datas
*****************

parameters M_DATA

return substr(dtoc(M_DATA), 1, 2) + substr(dtoc(M_DATA), 4, 2) + substr(dtoc(M_DATA), 7, 2)

*****************
function TIRA_BAR4     && retira barra de datas
*****************

parameters M_DATA

return substr(dtoc(M_DATA), 1, 2) + substr(dtoc(M_DATA), 4, 2) + str(year(M_DATA),4)

***************
function MANSIS
***************

private M_TELA ,;
        M_OPC  

M_CURSOR = setcursor()

M_TELA = savescreen(02, 10, 24, 65)

set cursor off

sombra(02, 17, 20, 64,_SOMBRA_)

painel(02, 17, 20, 64,"R+/R","N/R")

set color to GR+/R
   @ 03, 18 say "  Automa‡„o Software                          "
   @ 04, 18 say "  Rua Paulo Gon‡alves 348 Cep 19023-650       "
   @ 05, 18 say "  Fone: (018) 223-5433 Presidente Prudente SP "
set color to N/R
   @ 06, 18 say " ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ "
set color to GR+/R
   @ 07, 18 say "  Sistema      :                              "
   @ 08, 18 say "  Linguagem    :                              "
set color to N/R
   @ 09, 18 say " ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ "
set color to GR+/R
   @ 10, 18 say "  Analista     :                              "
   @ 11, 18 say "  Programadores:                              "
   @ 12, 18 say "               :                              "
   @ 13, 18 say "               :                              "
set color to N/R
   @ 14, 18 say " ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ "
set color to GR+/R
   @ 15, 18 say "  Mem¢ria Livre:         Disco Livre:         "
set color to N/R
   @ 16, 18 say " ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ "
   @ 17, 18 say "                                              "
   @ 18, 18 say "                                              "
   @ 19, 18 say "                                              "
set color to W+/R
   @ 07, 35 say "Integrado    Vers„o 5.0"
   @ 08, 35 say "Clipper 5.2"
   @ 10, 35 say "Aparecido dos Santos Silva"
   @ 11, 35 say "Jo„o Carlos dos Santos Silva"
   @ 12, 35 say "Aparecido dos Santos Silva  "
   @ 13, 35 say "                      "
   @ 15, 35 say str(memory(0), 4) + " Kb"
   @ 15, 56 say str((diskspace(0)/1000000), 4) + " Mb"
set color to

painel(17, 35, 19, 46,"R+/R","N/R")

store 0 to M_OPC
set color to W+/R,W+/R
@ 18, 36 say "    Ok    " 
inkey(0)

iif(M_CURSOR=1,setcursor(1),setcursor(0))	

restscreen(02, 10, 24, 65, M_TELA)

return ""

***************
function INVSYS
***************

parameters LI,CI,LF,CF

 painel(LI, CI, LF, CF,"R+/R","N/R") 
   inkey(.01)
 painel(LI, CI, LF, CF,"N/R","R+/R") 

return ""

*****************
function CALC_DOL
*****************

parameters M_DOLVLR,M_DOLDTA

return M_DOLVLR

if M_MOEDA = "R"
  return M_DOLVLR
endif

M_DOLDTA = firstday(M_DOLDTA)

if ADOL00->(dbseek(dtos(M_DOLDTA)))
  M_DOLVLR = M_DOLVLR / ADOL00->DOLVLR
else
  M_DOLVLR = 0
endif

return M_DOLVLR

****************
function ELIMINA
****************

arecord = getrecord(0)

do while .t.
  if rlock()
    putrecord(arecord,recno())
    unlock   
    commit
    exit
  else
    msg("* * * (" + alias() + ") REGISTRO SENDO USADO * * *") 
  endif
  if lastkey()=17
    exit
  endif
enddo

return ""

*******************
function ACHA_LIVRE
*******************

if file("ANFS02.CDX")
  erase("ANFS02.CDX")
endif
if file("ANFS03.CDX")
  erase("ANFS03.CDX")
endif
if file("ANFS04.CDX")
  erase("ANFS04.CDX")
endif
if file("ANFS05.CDX")
  erase("ANFS05.CDX")
endif
if file("ANFS06.CDX")
  erase("ANFS06.CDX")
endif

use ANFS02 alias ANFS02 exclusive
if neterr()
  use ANFS03 alias ANFS02 exclusive
  if neterr()
    use ANFS04 alias ANFS02 exclusive
    if neterr()
      use ANFS05 alias ANFS02 exclusive
      if neterr()
        use ANFS06 alias ANFS02 exclusive
        if neterr()
          msg("* * ARQUIVO NAO DISPONIVEL * * *")
          return .f.
        else
          M_IND = "ANFS06"
        endif
      else
        M_IND = "ANFS05"
      endif
    else
      M_IND = "ANFS04"
    endif
  else
    M_IND = "ANFS03"
  endif
else
  M_IND = "ANFS02"
endif

return .f.



************************
function VER_PROTESTADOS(F_TIPO)
************************


aBlocks2 := {}
aObjects2:= WvtSetObjects( {} )
aLastPaint2 := WvtSetBlocks( aBlocks2 )

if F_TIPO == NIL
  F_TIPO = "N"
endif

M_EMPRESA = 1
M_PROTES := { }
LBloqueia = .f.

lProt = .f.

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ADCR00","ADCR00"})
  aadd(sqlCAMPO,"*")
  aadd(sqlCHAVE,"DUPCLI = " + str(F_TIPO, 5, 0))
  aadd(sqlCHAVE,"DUPHIS = " + str(500, 3, 0))
  aadd(sqlCHAVE,"DUPEMP <> 99")
  sqlrelation()

  M_TOTDUP = 0
  M_TOTVEN = 0
  M_TOTAVE = 0

do while !eof()

  if (DUPVCT - date()) <= -1
  else
     M_TOTAVE = M_TOTAVE + DUPVLA
     skip
     loop
  endif
  
  M_TOTDUP = M_TOTDUP + DUPVLA
  if DUPVCT - date() < 0
    M_TOTVEN = M_TOTVEN + DUPVLA
  else
    M_TOTAVE = M_TOTAVE + DUPVLA
  endif

  aadd(M_PROTES,{DUPVCT,;
       strzero(DUPNUM,6)+"/"+ strzero(DUPORD, 2),;
       DUPVCT - date(),;
       "DUP ATRASADA",DUPVLA})
  skip
enddo

ncOLMAIS = 5
nLinMAIS = 2

if len(M_PROTES) > 0
  declare PROT[len(M_PROTES)]
  for ZZ = 1 to len(M_PROTES)
    PROT[ZZ] = dtoc(M_PROTES[ZZ,1]) + " " + M_PROTES[ZZ,2] + " " + str(M_PROTES[ZZ,3],4) + " " + pad(M_PROTES[ZZ,4],13) + " " + transform(M_PROTES[ZZ,5],"@R 999,999.99")
  next

  n_TELA1 = savescreen(02+nLinMAIS,09+ncOLMAIS,15+nLinMAIS,59+ncOLMAIS+1)

  nbox(02+nLinMAIS,09+ncOLMAIS,13+nLinMAIS,58+ncOLMAIS,"W/W+",.t.)
  set color to N/W
  @ 03+nLinMAIS, 10+ncOLMAIS say     "  DATA   DUPLICAT  DIAS    MOTIVO       VALOR   "
  @ 04+nLinMAIS, 10+ncOLMAIS say     "                                                "
  @ 05+nLinMAIS, 10+ncOLMAIS say     "                                                "
  @ 06+nLinMAIS, 10+ncOLMAIS say     "                                                "
  @ 07+nLinMAIS, 10+ncOLMAIS say     "                                                "
  @ 08+nLinMAIS, 10+ncOLMAIS say     "                                                "
  @ 09+nLinMAIS, 10+ncOLMAIS say     "                                                "
  @ 10+nLinMAIS, 10+ncOLMAIS say     "                                                "
  @ 11+nLinMAIS, 10+ncOLMAIS say     "                                                "
  @ 12+nLinMAIS, 10+ncOLMAIS say     "                                                "
  set color to N/W,W+/N
  achoice(05+nLinMAIS, 10+ncOLMAIS, 12+nLinMAIS, 57+ncOLMAIS,PROT)
  setcolor("")

  restscreen(02+nLinMAIS,09+ncOLMAIS,15+nLinMAIS,59+ncOLMAIS+1,n_TELA1)

  WvtSetBlocks( aLastPaint2 )
  WvtSetObjects( aObjects2 )

  return .t.

endif

WvtSetBlocks( aLastPaint2 )
WvtSetObjects( aObjects2 )

return .t.


****************
function MOSDCR1(M_CLICOD)
****************

if M_CLICOD = 1
  return .t.
endif

return ver_protestados(M_CLICOD)



  if M_CLICOD = 1
    return .t.
  endif

  M_VETORITE = {}
  M_TOTDUP = 0
  M_TOTPAG = 0
  M_TOTVEN = 0
  M_TOTAVE = 0

  R = 1

    select ADCR00

    (dbsetorder(2) , dbseek(str(ME_EMP, 2, 0) + str(M_CLICOD, 7, 0), .t.) )

    do while !eof()

       if str(DUPEMP, 2, 0) + str(DUPCLI, 7, 0) > str(ME_EMP, 2, 0) + str(M_CLICOD, 7, 0) 
         exit
       endif

       if DUPHIS # 500
         skip
         loop
       endif

       if (DUPVCT - date()) <= -1
       else
         M_TOTAVE = M_TOTAVE + DUPVLA
         skip
         loop
       endif

       ACPG00->(dbseek(str(ADCR00->DUPCPG, 3, 0)))

       if R <= 4000
         aadd(M_VETORITE,str(DUPNUM, 6, 0) + "³" + str(DUPORD, 2, 0) + str(ACPG00->CPGPAR, 1, 0) + "³" + dtoc(DUPDTE) + "³" + dtoc(DUPVCT) + "³" + dtoc(DUPDTP) + "³   ³" + transform(DUPVLA,"@E ###,###.##") + "³" + str(DUPCLI, 7, 0) + "³" + right(str(DUPPOR, 5, 0),3) + "³" + str(DUPVCT - date(), 5, 0) + "³" + str(DUPEMP, 2, 0))
       endif

       M_TOTDUP = M_TOTDUP + DUPVLA
       if DUPVCT - date() < 0
         M_TOTVEN = M_TOTVEN + DUPVLA
       else
         M_TOTAVE = M_TOTAVE + DUPVLA
       endif

      R = R + 1

      msw("* * * AGUARDE ... PROCESSANDO (ESC) Abandona -=> " + str(R, 5) + " * * *")

      skip

    enddo
   
    if len(M_VETORITE) > 0
      lLoctel = savescreen(03,02,23,77)
      tldcr02()
      setadcr()

      ADCR00->( dbsetorder(1) , (dbseek(str(val(substr(M_VETORITE[1], 72, 2)), 2, 0) + str(val(substr(M_VETORITE[1], 1, 6)), 6, 0) + str(val(substr(M_VETORITE[1], 8, 2)), 2, 0))) )
*      ACLI00->(dbseek(str(ADCR00->DUPCLI, 7, 0)))

      set color to GR+/B+
        @ 17, 09 say pad(ACLI00->CLINOM , 40)
        @ 17, 59 say padl(alltrim(ACLI00->CLITEL3), 17)
        @ 18, 09 say pad(ADCR00->DUPOBS , 40)
        @ 18, 59 say ADCR00->DUPVLO picture "@E ##,###,###,###.##"
        @ 19, 09 say pad(ADCR00->DUPOBT , 40)
        @ 19, 59 say str(ADCR00->DUPBOL, 7, 0)
        @ 19, 67 say ADCR00->DUPDSC picture "@E ##,###.##"
      set color to I

      set color to N/W,W+/N
        M_ACHO = achoice(08,03,15,75,M_VETORITE,,"achdcr1")
      set color to 
      restscreen(03,02,23,77,lLoctel)
    else
      return .t.
    endif

  set cursor on

return .t.

***************
function ACHDCR1
***************

parameters  M_MODO, M_ELEM, M_POSI

if str(lastkey(), 2, 0) $ "27"
  return 0
endif

  M_CHAVE = str(val(substr(M_VETORITE[M_ELEM], 72, 2)), 2, 0) + str(val(substr(M_VETORITE[M_ELEM], 1, 6)), 6, 0) + str(val(substr(M_VETORITE[M_ELEM], 8, 2)), 2, 0)
  ADCR00->( dbsetorder(1) , dbseek(M_CHAVE) )
 
  ACLI00->(dbseek(str(ADCR00->DUPCLI, 7, 0)))

  if lastkey() = 32
    mostotdcr()
  endif

  set color to GR+/B+
    @ 17, 09 say pad(ACLI00->CLINOM , 40)
    @ 17, 59 say padl(alltrim(ACLI00->CLITEL3), 17)
    @ 18, 09 say pad(ADCR00->DUPOBS , 40)
    @ 18, 59 say ADCR00->DUPVLO picture "@E ##,###,###,###.##"
    @ 19, 09 say pad(ADCR00->DUPOBT , 40)
    @ 19, 59 say str(ADCR00->DUPBOL, 7, 0)
    @ 19, 67 say ADCR00->DUPDSC picture "@E ##,###.##"
  set color to I

  M_LINPOS = M_POSI

return 2



************
functio TONE
************

return ""


****************
function DIGINRO
****************

if lastkey() = 5
  return .t.
endif

parameters Modulo

save get to M_GETANT

dTela = savescreen(09, 52, 13, 78)

  nbox(09, 52, 12, 76,"W/W+",.t.)
  setcolor("B/W")
  @ 09, 59 say             "Endere‡o"
  @ 10, 53 say       "N£mero.....:           "
  @ 11, 53 say       "Complemento:           "
SetColor(_COREDICAO_)

do case
   case Modulo = "FOR"
     @ 10, 66 get M_FORNRO picture "@!"   valid !empty(M_FORNRO)
     @ 11, 66 get M_FORCPE
   case Modulo = "EMP"
     @ 10, 66 get M_EMPNRO picture "@!"   valid !empty(M_EMPNRO)
     @ 11, 66 get M_EMPCPE
   case Modulo = "CLI1"
     @ 10, 66 get M_CLINRO1 picture "@!"   valid !empty(M_CLINRO1)
     @ 11, 66 get M_CLICPE1
   case Modulo = "CLI2"
     @ 10, 66 get M_CLINRO2 picture "@!"   valid !empty(M_CLINRO2)
     @ 11, 66 get M_CLICPE2
   case Modulo = "CLI3"
     @ 10, 66 get M_CLINRO3 picture "@!"   valid !empty(M_CLINRO3)
     @ 11, 66 get M_CLICPE3
   case Modulo = "CLI"
     @ 10, 66 get M_CLINRO picture "@!"   valid !empty(M_CLINRO)
     @ 11, 66 get M_CLICPE
endcase

read

restscreen(09, 52, 13, 78, dTela)

restore get from M_GETANT

setcursor(1)

return .t.


***************
function DATNFE   && Datas no padrÆo da NF-e
***************

parameter xDatpar

xDatres = str(year(xDatpar), 4) + "-" + strzero(month(xDatpar), 2) + "-" + strzero(day(xDatpar), 2)

return xDatres


****************
function VERIDAT   && Verifica as datas de fabrica‡Æo e validade dos remedios
****************

parameter M_DATDIG

if len(alltrim(M_DATDIG)) < 4
  msg("* * * Informe a data no formato DD/MM * * *")
endif

if val(left(M_DATDIG, 2)) < 1 .or. val(left(M_DATDIG, 2)) > 12
  msg("* * * Data Inv lida * * *")
  return .f.
endif

if val(right(M_DATDIG, 2)) < 1 .or. val(right(M_DATDIG, 2)) > 40
  msg("* * * Data Inv lida * * *")
  return .f.
endif

return .t.

******************* 
function RET_DUPDCR                   && retira duplicatas contas a receber
******************* 

parameters F_DUPEMP,F_DUPNUM,F_DUPSER

select ADCR00

do while .t.

  (dbsetorder(1), dbseek(str(F_DUPEMP, 2, 0) + str(F_DUPNUM, 6, 0) + F_DUPSER, .t.))

  if !str(DUPEMP, 2, 0) + str(DUPNUM, 6, 0) + DUPSER == str(F_DUPEMP, 2, 0) + str(F_DUPNUM, 6, 0) + F_DUPSER
    exit
  endif

  select ALCR00

  do while .t.

    dbseek(str(ADCR00->DUPEMP, 2, 0) + str(ADCR00->DUPNUM, 6, 0) + str(ADCR00->DUPORD, 2, 0) + "   ", .t.)

    if !str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + LANSER + str(LANORD, 2, 0) == str(ADCR00->DUPEMP, 2, 0) + str(ADCR00->DUPNUM, 6, 0) + ADCR00->DUPSER + str(ADCR00->DUPORD, 2, 0) 
      exit
    endif

    do while .t. 
      if rlock()
        replace LANEMP with 0
        replace LANNUM with 0
        replace LANSER with ""
        replace LANORD with 0 
        replace LANHIS with 0 
        replace LANDTM with ctod("  /  /  ")
        replace LANCLI with 0 
        replace LANVAL with 0
        replace LANTRN with ""
        unlock
        exit 
      else
        msg("* * * (ALCR00) REGISTRO SENDO USADO * * *")
      endif
    enddo

  enddo

  select ADCR00

  do while .t.
    if rlock()    
      replace DUPEMP       with 0
      replace DUPNUM       with 0
      replace DUPSER       with ""
      replace DUPORD       with 0
      replace DUPCLI       with 0
      replace DUPDTE       with ctod("  /  /  ")
      replace DUPVCT       with ctod("  /  /  ")
      replace DUPVEN       with 0
      replace DUPPOR       with 0
      replace DUPAPL       with ""
      replace DUPNFS       with 0
      replace DUPVLA       with 0
      replace DUPVLO       with 0
      replace DUPCPG       with 0
      replace DUPFIS       with 0
      replace DUPHIS       with 0
      replace DUPTRN       with ""
      unlock
      exit
    else
      msg("* * * (ADCR00) REGISTRO SENDO USADO * * *") 
    endif
    if lastkey()=17
      exit
    endif
    loop            
  enddo

enddo

return ""

#define FILE_BRWS_NUM_IVARS 3
#define MAX_LINE_LEN  256
#define CR    Chr(13)
#define LF    Chr(10)
#define CRLF  CR + LF
#define SET_IVAR(iVar, p) iif(p == NIL, NIL, iVar := p)

***************
FUNCTION FBTest(cFname)
***************

LOCAL oTbr, oTbc
LOCAL lExitRequested := .F.
LOCAL cSearcher, nSavefPos
LOCAL nKey
LOCAL GetList := {}
LOCAL aBlocks := {}
LOCAL aLastPaint4

aLastPaint4 := WvtSetBlocks( aBlocks )

set_pesquisa = 0
cSearcher := Space(20)


  setcolor("W/B")
  SET SCOREBOARD OFF

  IF cFname == NIL .OR. !File(cFname)
    Alert("Usage: FBTest <cFileName>")
    QUIT
  ENDIF

*  @ 23, 0 SAY "[F2] - Procura abaixo [F3] - Procura acima  [F4] - repetir pesquisa"

  IF (oTbr := FBrowseNew()) != NIL
    FBrowseOpen(oTbr, cFname)
    oTbr:nTop    := 0
    oTbr:nLeft   := 0
    oTbr:nBottom := maxrow()-1 // 21
    oTbr:nRight  := maxcol() //78
    oTbc := TBColumnNew(, {|| SubStr(oTbr:fileLine, oTbr:lineOffset) })

    oTbc:width := 132 // 78
    oTbr:addColumn(oTbc)

    DO WHILE !lExitRequested
      DO WHILE !oTbr:stabilize()
      ENDDO

      nKey := InKey(0)
      
*     fnt_:= Wvt_GetFontInfo()
*     @ 24, 00 SAY str(fnt_[ 2 ],3)
*     @ 24, 20 SAY str(fnt_[ 3 ],3)

      
      DO CASE
      CASE nKey == 27
        lExitRequested := .T.

      CASE nKey == 19
        IF oTbr:lineOffset > 1
          oTbr:lineOffset--
          oTbr:refreshall()
        ENDIF

      CASE nKey == 4
        IF oTbr:lineOffset < len(oTbr:fileLine)
          oTbr:lineOffset++
          oTbr:refreshall()
        ENDIF

      CASE nKey == 1
        oTbr:lineOffset := 1
        oTbr:refreshall()

      CASE nKey == 6
        oTbr:lineOffset := Max(1, Len(oTbr:fileLine) - ;
                                  oTbc:width + 1)
        oTbr:refreshAll()

      #define TAB_SIZE 10

      CASE nKey == 9
        IF oTbr:lineOffset <= Len(oTbr:fileLine) - TAB_SIZE
          oTbr:lineOffset += TAB_SIZE
          oTbr:refreshAll()
        ENDIF

      CASE nKey == 271
        oTbr:lineOffset := MAX(1, oTbr:lineOffset - TAB_SIZE)
        oTbr:refreshall()

      CASE nKey == -1
        @ 24, 0
        @ 24, 10 SAY "Entre com o texto" GET cSearcher
        READ
        @ 24, 0
        IF FrwdSrch(oTbr, Trim(cSearcher))
          oTbr:refreshAll()
        ELSE
          Alert("Nao encontrado", {"OK"}, "B/W, W/B")
        ENDIF
        set_pesquisa = -1

      CASE nKey == -2
        @ 24, 0
        @ 24, 10 SAY "Entre com o texto" GET cSearcher
        READ
        @ 24, 0
        IF BkwdSrch(oTbr, Trim(cSearcher))
          nSavefPos := FilePos(oTbr)
          oTbr:refreshAll()
          DO WHILE !oTbr:stabilize()
          ENDDO

          // Ensure same line selected
          DO WHILE FilePos(oTbr) != nSavefPos
            oTbr:up()
            DO WHILE !oTbr:stabilize()
            ENDDO
          ENDDO
        ELSE
          Alert("Nao encontrado", {"OK"}, "B/W, W/B")
        ENDIF
        set_pesquisa = -2

      case nkey == -3
        do case
          case set_pesquisa = 0
            alert("Nao foi efetuado nenhuma pesquisa",{"OK"}, "B/W, W/B")
            loop
          case set_pesquisa = -1
            IF FrwdSrch(oTbr, Trim(cSearcher))
              oTbr:refreshAll()
            ELSE
             Alert("Nao encontrado", {"OK"}, "B/W, W/B")
            ENDIF
          case set_pesquisa = -2
           IF BkwdSrch(oTbr, Trim(cSearcher))
             nSavefPos := FilePos(oTbr)
             oTbr:refreshAll()
             DO WHILE !oTbr:stabilize()
             ENDDO
             DO WHILE FilePos(oTbr) != nSavefPos
               oTbr:up()
               DO WHILE !oTbr:stabilize()
               ENDDO
             ENDDO
           ELSE
             Alert("Nao encontrado", {"OK"}, "B/W, W/B")
           ENDIF
        endcase


      OTHERWISE
        IF StdMeth(oTbr, nKey)
          //  Handled as standard key
        ELSE
          // Otherwise ignore
        ENDIF
      ENDCASE
    ENDDO
  ENDIF

  FileBrowseClose(oTbr)
  WvtSetBlocks( aLastPaint4 )

RETURN NIL

FUNCTION FilePos(oTbr)

RETURN FTell(oTbr:fileHandle)



FUNCTION FBrowseNew

LOCAL oTbr := TBrowseNew()

  oTbr:cargo := Array(FILE_BRWS_NUM_IVARS)
  oTbr:lineOffset := 1

  oTbr:goTopBlock    := {| | FileGoFirst(oTbr) }
  oTbr:goBottomBlock := {| | FileGoLast(oTbr)  }
  oTbr:skipBlock     := {|n| FileSkip(n, oTbr) }

RETURN oTbr


FUNCTION FBrowseOpen(oTbr, cFileName)

LOCAL fHandle := FOpen(cFileName)

  IF fHandle >= 0
    oTbr:fileHandle := fHandle
    FileGoFirst(oTbr)
  ENDIF

RETURN fHandle > 0


PROCEDURE FileBrowseClose(oTbr)

  FClose(oTbr:filehandle)

RETURN


// Go to first line in file, and read it into oTbr:fileLine

STATIC PROCEDURE FileGoFirst(oTbr)

LOCAL cLine
LOCAL fHandle := oTbr:fileHandle

  FSeek(fHandle, 0, 0)
  FReadLn(fHandle, @cline, MAX_LINE_LEN)
  cline = strtran(cline,chr(12) + chr(13),chr(13) + chr(10))



  oTbr:fileLine := cLine
  FSeek(fHandle, 0, 0)

RETURN


// Go to last line in file, and read into oTbr:fileLine

STATIC PROCEDURE FileGoLast(oTbr)

  FSeek(oTbr:fileHandle, 0, 2)
  GoPrevLn(oTbr)

RETURN

// Skip n lines in the file. n can be positive or negative.
// Return how many skipped.

STATIC FUNCTION FileSkip(n, oTbr)

LOCAL nSkipped := 0

  IF n > 0
    DO WHILE nSkipped != n .AND. GoNextLn(oTbr)
      nSkipped++
    ENDDO
  ELSE
    DO WHILE nSkipped != n .AND. GoPrevLn(oTbr)
      nSkipped--
    ENDDO
  ENDIF

RETURN nSkipped


// Attempt to move to the next line in the file
// Return .T. if successful, .F. otherwise

// Needs to be public for search routine

FUNCTION GoNextLn(oTbr)

LOCAL fHandle := oTbr:fileHandle
LOCAL nSavePos := FTell(fHandle), ;
      cBuff := "", lMoved, nNewPos

  FSeek(fHandle, Len(oTbr:fileLine) + 2, 1)
  nNewPos := FTell(fHandle)
  IF FReadLn(fHandle, @cBuff, MAX_LINE_LEN)
    lMoved := .T.
    oTbr:fileLine := cBuff
    FSeek(fHandle, nNewPos, 0)
  ELSE
    lMoved := .F.
    FSeek(fHandle, nSavePos, 0)
  ENDIF

RETURN lMoved


// Needs to be public for search routines

FUNCTION GoPrevLn(oTbr)

LOCAL fHandle := oTbr:fileHandle
LOCAL nOrigPos := FTell(fHandle), nMaxRead, nNewPos, ;
          lMoved, cBuff, nWhereCrLf, nPrev, cTemp

  IF nOrigPos == 0
    lMoved := .F.
  ELSE
    lMoved := .T.
    //  Check preceeding 2 chars for CR / LF
    FSeek(fHandle, -2, 1)
    cTemp := Space(2)
    FRead(fHandle, @cTemp, 2)
    IF cTemp == CRLF
      FSeek(fHandle, -2, 1)
    ENDIF
    nMaxRead := MIN(MAX_LINE_LEN, FTell(fHandle))

    cBuff := Space(nMaxRead)
    nNewPos := FSeek(fHandle, -nMaxRead, 1)
    FRead(fHandle, @cBuff, nMaxRead)
*    cbuff = strtran(cbuff,chr(12) + chr(13),chr(13) + chr(10))
    nWhereCrLf := Rat(CRLF, cBuff)
    IF nWhereCrLf == 0
      nPrev := nNewPos
      oTbr:fileLine := cBuff
    ELSE
      nPrev := nNewPos + nWhereCrLf + 1
      oTbr:fileLine := SubStr(cBuff, nWhereCrLf + 2)
    ENDIF

    FSeek(fHandle, nPrev, 0)
  ENDIF

RETURN lMoved

// Return whether found or not - search forwards
// If found, cLine is set to current line and file pointer
// is at its start
// If not found, file pointer remains untouched

FUNCTION FrwdSrch(oTbr, cString)

LOCAL fHandle := oTbr:fileHandle
LOCAL lFound := .F.
LOCAL nSavePos := FTell(oTbr:fileHandle)
LOCAL cSavecLine := oTbr:fileLine

  DO WHILE !lFound .AND. GoNextLn(oTbr)
    lFound := cString $ oTbr:fileLine
  ENDDO

  IF !lFound
    FSeek(fHandle, nSavePos, 0)
    oTbr:fileLine := cSavecLine
  ENDIF

RETURN lFound


// Return whether found or not - search backwards
// If found, cLine is set to current line and file pointer
// is at its start
// If not found, file pointer remains untouched

FUNCTION bkwdSrch(oTbr, cString)

LOCAL lFound := .F.
LOCAL fHandle := oTbr:fileHandle
LOCAL nSavePos := FTell(fHandle)
LOCAL cSavecLine := oTbr:fileLine

  DO WHILE !lFound .AND. GoPrevLn(oTbr)
    lFound := cString $ oTbr:fileLine
  ENDDO

  IF !lFound
    FSeek(fHandle, nSavePos, 0)
    oTbr:fileLine := cSavecLine
  ENDIF

RETURN lFound



FUNCTION FReadLn(fHandle, cBuffer, nMaxLine)

LOCAL cLine, nEol, nNumRead, nSavePos

  cLine   := Space(nMaxLine)
  cBuffer := ""

  // Save current file position for later seek
  nSavePos := FTell(fHandle)

  nNumRead := FRead(fHandle, @cLine, nMaxLine)

  IF (nEol := At(CRLF, SubStr(cLine, 1, nNumRead))) == 0
    cBuffer := cLine                     // Line overflow or eof
  ELSE
    cBuffer := SubStr(cLine, 1, nEol - 1)  // Copy up to eol

    // Now position file to next line (skip lf) ...
    FSeek(fHandle, nSavePos + nEol + 1, 0)

  ENDIF

RETURN nNumRead != 0        // If last read didn't suceed, eof






FUNCTION StdMeth(oTbr, nKey)

LOCAL lKeyHandled := .T.

  DO CASE
    CASE nKey == 24     ;  oTbr:down()
    CASE nKey == 05     ;  oTbr:up()
    CASE nKey == 03     ;  oTbr:pageDown()
    CASE nKey == 18     ;  oTbr:pageUp()
    CASE nKey == 31     ;  oTbr:goTop()
    CASE nKey == 30     ;  oTbr:goBottom()
    CASE nKey == 04     ;  oTbr:right()
    CASE nKey == 19     ;  oTbr:left()
    CASE nKey == 01     ;  oTbr:home()
    CASE nKey == 06     ;  oTbr:end()
    CASE nKey == 26     ;  oTbr:panLeft()
    CASE nKey == 02     ;  oTbr:panRight()
    CASE nKey == 29     ;  oTbr:panHome()
    CASE nKey == 23     ;  oTbr:panEnd()
    OTHERWISE;             lKeyHandled := .F.
  ENDCASE

RETURN lKeyHandled




FUNCTION MemoBlock(nFieldNum)

RETURN {|nMode| iif(nMode == NIL, ;
                    "Memo", ;
                    FieldBlock(Field(nFieldNum))) }


// Repeatedly call stabilize until it returns .T., ensuring the same
// record is highlighted (for database edits)

PROC DbStabilize(oTbr)

LOCAL nSaveRecno := recno()

  oTbr:refreshAll()
  DO WHILE !oTbr:stabilize()
  ENDDO

  DO WHILE recno() != nSaveRecno
    oTbr:up()
    DO WHILE !oTbr:stabilize()
    ENDDO
  ENDDO

RETURN



function SELEEMPRESA
   //***************

   LOCAL scr, clr,Arg3,Ci,cf,aLastPaint4,M_TIPOS,M_CODEMP,TamStr,PosAcho,TIPO1
   LOCAL aBlocks := {}

   BUSCAREGISTRO("AEMP00",1,{},"SELECT")

   M_TIPOS = { }
   M_CODEMP = { }

   TamStr = len(EMPFAN)
   Ci:=((maxcol()-TamStr)/2)
   Cf:=Ci+TamStr
   Arg3:= Int(maxrow() / 2)-2

   do while !eof()
      aadd(M_TIPOS,AEMP00->EMPFAN)
      aadd(M_CODEMP,AEMP00->EMPCOD)
      skip
   enddo

   if len(M_TIPOS) > 1
     PosAcho = 1
     scr := SaveScreen(Arg3-2, Ci-4, Arg3 + len(M_TIPOS)+2, cf+4)
     nbox(Arg3, Ci-3, Arg3 + len(M_TIPOS)-1, cf+3, "B/W*",.t.)
     clr := SetColor( 'N/W*,GR+/B*,,,GR+/B' )

     do while .t.
        TIPO1 = achoice(Arg3, Ci-3, Arg3 + len(M_TIPOS), cf+3,M_TIPOS,,,PosAcho)
        setcolor("")
        if lastkey() = 27
           finaliza()
           loop
        endif
        exit
     enddo
     setColor( clr )

     RestScreen(Arg3-2, Ci-4, Arg3 + len(M_TIPOS)+2, cf+4,scr )
     ME_EMP = M_CODEMP[TIPO1]
   else
     TIPO1 = 1
   endif

   BUSCAREGISTRO("AEMP00",1,{str(M_CODEMP[TIPO1],2)},"SELECT")

   if !senha()
     quit
   endif

   M_LOGNOM = ALOG10->LOGNOM
   M_LOGSUP = ALOG10->LOGSUP
   M_LOGEXT = ALOG10->LOG75

   _EMPPRT_ = AEMP00->EMPPRT

rodape("MENU","ESTOQUE",M_FAN,"MENUAGRO","Mem: " + str(memory(0), 5),M_EMP)

return .t.

****************
function SELEREGIAO(fVALOR,nLinha,nColuna)  // CLASSIFICACAO PARA DESCONTO
****************

LOCAL scr, clr
LOCAL aBlocks := {}
local M_CODIGO

private PosAcho

M_TIPOS = { }

  aadd(M_TIPOS,"   Escolha  ")
  aadd(M_TIPOS," 0.Todos    ")
  aadd(M_TIPOS," 4.Prudente ")
  aadd(M_TIPOS," 5.Marilia  ")
  aadd(M_TIPOS,"10.Aracatuba")

  PosAcho = 1

  scr := SaveScreen(nLinha-2,nColuna-2,nLinha+len(M_TIPOS)+2,nColuna+len(M_TIPOS[1])+2)
  clr := SetColor( 'N/W*,GR+/B*,,,GR+/B' )

  Wvt_DrawBoxRaised( nLinha,nColuna,nLinha+len(M_TIPOS)-1,nColuna+len(M_TIPOS[1]))
  aLastPaint4 := WvtSetBlocks( aBlocks )

do while .t.

  TIPO1 = achoice(nLinha,nColuna,nLinha+len(M_TIPOS),nColuna+len(M_TIPOS[1]),M_TIPOS,,,PosAcho)

  if TIPO1 = 0
    loop
  endif

  fVALOR = left(M_TIPOS[TIPO1],2)

  if fVALOR == "  "
    loop
  endif

  exit

enddo

fVALOR = val(fVALOR)

setColor( clr )

 WvtSetBlocks( aLastPaint4 )
 RestScreen(nLinha-2,nColuna-2,nLinha+len(M_TIPOS)+2,nColuna+len(M_TIPOS[1])+2, scr )

keyboard chr(13)

return .t.


****************
function ABPGTO(fVALOR,nLinha,nColuna)  // ABERTAS PAGAS TODAS
****************

LOCAL scr, clr
LOCAL aBlocks := {}
local M_CODIGO

private PosAcho

M_TIPOS = { }

  aadd(M_TIPOS,"   Escolha ")
  aadd(M_TIPOS," 1.Abertas ")
  aadd(M_TIPOS," 2.Pagas   ")
  aadd(M_TIPOS," 3.Todas   ")

  PosAcho = 1

  scr := wvt_SaveScreen(nLinha-2,nColuna-2,nLinha+len(M_TIPOS)+2,nColuna+len(M_TIPOS[1])+2)
  clr := SetColor( 'N/W*,GR+/B*,,,GR+/B' )

  Wvt_DrawBoxRaised( nLinha,nColuna,nLinha+len(M_TIPOS)-1,nColuna+len(M_TIPOS[1]))
  aLastPaint4 := WvtSetBlocks( aBlocks )

do while .t.

  TIPO1 = achoice(nLinha,nColuna,nLinha+len(M_TIPOS),nColuna+len(M_TIPOS[1]),M_TIPOS,,,PosAcho)

  if lastkey()= 27
    wvt_RestScreen(nLinha-2,nColuna-2,nLinha+len(M_TIPOS)+2,nColuna+len(M_TIPOS[1])+2, scr )
    WvtSetBlocks( aLastPaint4 )
    return .t.
  endif
  
  if TIPO1 = 0
    loop
  endif

  if left(M_TIPOS[TIPO1],3) == "   "  // escolheu o E entao nao sai
    loop
  endif

  exit

enddo

fVALOR = alltrim(substr(M_TIPOS[TIPO1],2,9))

setColor( clr )

 wvt_RestScreen(nLinha-2,nColuna-2,nLinha+len(M_TIPOS)+2,nColuna+len(M_TIPOS[1])+2, scr )
 WvtSetBlocks( aLastPaint4 )

keyboard chr(13)

return .t.


*************************
function EXECUTESQLDIRETO
*************************

local nHanerr

  trans := FBStartTransaction( db )
  ncod := FBExecute( db,cSQL,, trans )

  if nCod < 0
    nHan := FCreate("RELATO.RPT")   // a tentar CRIAR.
    FWrite( nHanerr, FBError(ncod) )
    FWrite( nHanerr, cSQL )
    FClose( nHanerr )   // Fechamos o Arquivo.

    FBROLLBACK(trans)
    EDITREL()
    return .f.
  endif

  FBCommit( trans )
