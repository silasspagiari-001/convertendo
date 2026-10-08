***************
function EMICRE
***************

private M_FLAG    ,;
L         ,;
R         ,;
LN        ,;
M_TELA    ,;
M_TELA1   ,;
M_QDE,oPrinter

#define FW_DONTCARE    0
#define FW_THIN        100
#define FW_EXTRALIGHT  200
#define FW_LIGHT       300
#define FW_NORMAL      400
#define FW_MEDIUM      500
#define FW_SEMIBOLD    600
#define FW_BOLD        700
#define FW_EXTRABOLD   800
#define FW_HEAVY       900
#define DMPAPER_A4     9

#include "hbwin.ch"

M_TELA = savescreen(02, 04, 21, 77)

_FUNCLI_ = "CREDITO"
_FUNPRO_ = "CREDITO"
_FUNVEN_ = "CREDITO"
_FUNCPG_ = "CREDITO"
_FUNAPL_ = "CREDITO"


private aBlocks1 := {}
  aAdd( aBlocks1, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 03, 04, 20, 76) } )
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 08, 04, 10, 76,{+15,,-15,})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 08, 04, 20, 7 ,{+15,,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 08, 08, 20, 15,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 08, 16, 20, 21,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 08, 22, 20, 24,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 08, 25, 20, 52,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 08, 53, 20, 63,{+15,-10,,-10})})


do while .t.

  rodape("EMISSAO","CREDITO",M_FAN,"EAGRO56","Mem: " + str(memory(0), 5),M_EMP)

  msw("<ENTER> Seleciona     -    <ESC> encerra selecao")
  tlcre02()

  aLastPaint1 := WvtSetBlocks( aBlocks1 )
  aLastPaint9 := aLastPaint1

  M_CRENUM = 0
  M_CRESER = AEMP00->EMPSER

  SetColor(_COREDICAO_)

  @ 04, 15 get     M_CRENUM picture "######"
  @ 04, 29 get     M_CRESER picture "@!"
  read

  if lastkey() = 27
    exit
  endif

  M_CRESER = padr(alltrim(M_CRESER),2)

  if !BUSCAREGISTRO("ANFS00",1,{str(ME_EMP, 2, 0),str(M_CRENUM, 6, 0),aspas(M_CRESER)},"SELECT")
    msg("* * * NOTA FISCAL NAO CADASTRADA * * *")
    loop
  endif

  BUSCAREGISTRO("ACLI00",1,{str(ANFS00->NFSCLI,7,0)},"SELECT")

  mscre01()

  BUSCAREGISTRO("ANFS01",1,{str(ANFS00->NFSEMP, 2, 0),str(ANFS00->NFSNUM, 6, 0),aspas(ANFS00->NFSSER)},"SELECT")

  M_QDE = 0
  M_PROD = { }
  M_QUA = 0

  do while !eof()
    M_QUA ++
    skip
  enddo

  declare M_PRODUTO[M_QUA]

  M_QUA = 0

  go top

  do while !eof()

    M_QUA ++

    BUSCAREGISTRO("APCA00",1,{str(ANFS01->NFSMAT,6,0)},"SELECT")

    select ANFS01

    M_PRODUTO[M_QUA] = "  " + " " + ;
                    transform(NFSMAT,"@R 99999-9")   + " " + ;
                    str(NFSQDE,5)                    + " " + ;
                    left(APCA00->PCAUNI,2)           + " " + ;
                    pad(APCA00->PCADES,27)           + " " + ;
                    transform(NFSPRB,"999,999.99")   + " " + ;
                    transform(NFSVLI,"9,999,999.99")

    skip

  enddo

  setcolor("N/W,W+/N")
    M_T = achoice(11,5,19,75,M_PRODUTO,,"SELECIONA")
  setcolor("")

  M_TELA1 = savescreen(06, 20, 18, 60)

  lpcre01()

  L = 11

  setcolor("I")
    for A = 1 to len(M_PRODUTO)
      if left(M_PRODUTO[A],2) == "  "
        loop
      endif
      @ L, 5 say M_PRODUTO[A]
      L ++
      if L = 20
        setcolor("")
          msg("* * * PRESSIONE QUALQUER TECLA * * *")
          lpcre01()
        setcolor("I")
        L = 11
      endif
    next
  setcolor("")

  emissao_cre()                        && emite a nota
  exit

enddo

aLastPaint1 := aLastPaint9
WvtSetBlocks( aLastPaint1 )

restscreen(02, 04, 21, 77, M_TELA)

return ""

********************
function EMISSAO_CRE                      && emissao de con normal
********************

private M_LP ,;
        M_TELA  ,;
        M_MESES

declare M_MESES[12]

M_MESES[1 ] = "janeiro"
M_MESES[2 ] = "fevereiro"
M_MESES[3 ] = "marco"
M_MESES[4 ] = "abril"
M_MESES[5 ] = "maio"
M_MESES[6 ] = "junho"
M_MESES[7 ] = "julho"
M_MESES[8 ] = "agosto"
M_MESES[9 ] = "setembro"
M_MESES[10] = "outubro"
M_MESES[11] = "novembro"
M_MESES[12] = "dezembro"

M_TELA = savescreen(08, 15, 13, 51)

M_DEC = 0
M_IMPRE = imprecre()

if M_IMPRE = "N"
  return ""
endif

M_LP = 0

for ABC = 1 to M_DEC -1

  cab_cre()

  for R = 1 to len(M_PRODUTO)

    if left(M_PRODUTO[R],2) == "  "
      loop
    endif

    M_PCA = val(substr(M_PRODUTO[R],4,5) + substr(M_PRODUTO[R],10,1))

    BUSCAREGISTRO("APCA00",1,{str(M_PCA,6,0)},"SELECT")

    cLinha = "       "
    cLinha += substr(M_PRODUTO[R],12,5)
    cLinha += "  "
    cLinha += substr(M_PRODUTO[R],18,2)
    cLinha += " "
    cLinha += pad(APCA00->PCADES,46)
    cLinha += " "
    cLinha += substr(M_PRODUTO[R],49,10)
    oPrinter:TextOut(cLinha,.t.)

    M_LP ++

  next && R

   for A = 1 to 20-M_LP
     oPrinter:TextOut("",.t.)
   next

   oPrinter:TextOut("            Material faturado em falta em sua nota fiscal numero " + STR(m_crenum, 6, 0),.t.)
   oPrinter:TextOut("       e nao enviado por falta no momento em nosso estoque, o qual sera",.t.)
   oPrinter:TextOut("       enviado assim que recebermos.",.t.)
   oPrinter:TextOut("",.t.)
   oPrinter:TextOut("",.t.)
   oPrinter:TextOut("",.t.)
   oPrinter:TextOut("",.t.)
   oPrinter:TextOut("                  Certos de sua compreensao, agradecemos.",.t.)
   oPrinter:TextOut("",.t.)
   oPrinter:TextOut("",.t.)
   oPrinter:TextOut("",.t.)
   oPrinter:TextOut("",.t.)

   cLinha = "                      Presidente Prudente, "
   cLinha += str(day(date()),2)
   cLinha += " de "
   cLinha += M_MESES[month(date())]
   cLinha += " de "
   cLinha += str(year(date()),4)
   oPrinter:TextOut(cLinha,.t.)

   if ABC # M_DEC -1
     oprinter:newpage()
   endif

next

set print off
set printer to
set console on
set cursor on
set relation to

if M_IMPRE = "A"
  editrel()
else
    oPrinter:EndDoc()
    oPrinter:Destroy()
endif


msg("* * * FIM DE EMISSAO * * *")

return ""

****************
function TLCRE02                       && tela da nota fiscal
****************
nbox(03, 04, 20, 76,"W/W+",.f.)
setcolor("B/W")

@ 04, 05 say     "Nota Fis :       Serie:     Emissao:          Valor:                   "
@ 05, 05 say     "Cliente  :                                                             "
@ 06, 05 say     "Endereco :                                                             "
@ 07, 05 say     "Municipio:                                             Quantidade:     "
@ 08, 05 say     "                                                                       "
@ 09, 05 say     "SQ CODIGO   QDE  UN  DESCRICAO                   VLR UNIT   VLR TOTAL  "
@ 10, 05 say     "                                                                       "
@ 11, 05 say     "                                                                       "
@ 12, 05 say     "                                                                       "
@ 13, 05 say     "                                                                       "
@ 14, 05 say     "                                                                       "
@ 15, 05 say     "                                                                       "
@ 16, 05 say     "                                                                       "
@ 17, 05 say     "                                                                       "
@ 18, 05 say     "                                                                       "
@ 19, 05 say     "                                                                       "
set color to

return ""

****************
function MSCRE01
****************

setcolor("I")
  @ 04, 42 say ANFS00->NFSDTE
  @ 04, 58 say ANFS00->NFSVLM picture "999,999,999.99"
  @ 05, 15 say pad(ACLI00->CLINOM,30)
  @ 05, col() + 1 say ACLI00->CLICOD picture "#####"
  @ 06, 15 say ACLI00->CLIEND1
  @ 07, 15 say ACLI00->CLIMUN1
setcolor()

return ""

****************
function LPCRE01
****************

private K

set color to I

for K = 11 to 19
  @ K, 04 say "                                                                         "
next &&  K

set color to

return ""

*****************
function IMPRECRE
*****************

private M_OPC  ,;
M_NOTA

store 3 to M_OPC

set color to GR+

do while .t.
   M_OPC = msgbox3("Destino do Relatorio",,,"Escolha","Cancela","Impressora")
   if M_OPC > 1
     exit
   endif
enddo

if M_OPC = 2
  return "N"
endif

do while .t.

  M_DEC = 0

  if M_OPC = 3
    do while .t.
      M_DEC = msgbox3("Emite duas vias",,,"Escolha","NÆo","Sim")
      if M_DEC > 1
        exit
      endif
    enddo

    oPrinter := Win32Prn():New( )
    oPrinter:Landscape := .F.
    oPrinter:FormType  := 9
    inicio_impressao()

    msw("* * * AGUARDE ... IMPRIMINDO * * *")
    set console off
    return "I"
  endif

  exit

enddo


****************
function CAB_CRE
****************

    oPrinter:TextOut("",.t.)
    oPrinter:TextOut("",.t.)
    oPrinter:TextOut("",.t.)
    oPrinter:TextOut("",.t.)
    oPrinter:TextOut("",.t.)
    oPrinter:Bold( WIN_FW_EXTRABOLD )
    oPrinter:TextOut(padc("CARTA DE CREDITO",80),.t.)
    oPrinter:TextOut("",.t.)
    oPrinter:TextOut("",.t.)
    oPrinter:TextOut("",.t.)
    oPrinter:TextOut("",.t.)

    cLinha = "      CLIENTE  : " + pad(ACLI00->CLINOM,40)
    cLinha += " "
    cLinha += str(ACLI00->CLICOD, 5, 0)
    oPrinter:TextOut(cLinha,.t.)

    cLinha = "      ENDERECO : " + alltrim(ACLI00->CLIEND1)
    oPrinter:TextOut(cLinha,.t.)

    cLinha = "      CIDADE   : " + alltrim(ACLI00->CLIMUN1) + "  - ESTADO : " + ACLI00->CLIUF1
    oPrinter:TextOut(cLinha,.t.)

    cLinha = "      CEP      : " + strzero(ACLI00->CLICEP1,5) + "-" + strzero(ACLI00->CLICCL1,3) + " FONE : " + ACLI00->CLITEL1
    oPrinter:TextOut(cLinha,.t.)

    oPrinter:Bold( WIN_FW_DONTCARE )

    oPrinter:TextOut("",.t.)
    oPrinter:TextOut("",.t.)
    oPrinter:TextOut("",.t.)

    oPrinter:TextOut("      QUANT. UNI MATERIAL                                      PRECO UNIT.",.t.)
    oPrinter:TextOut("      ------ --- --------------------------------------------- -----------",.t.)

return ""

******************
function SELECIONA
******************

parameters MODO, POSICAO, POSI2

M_TECLA = lastkey()

if rat(strzero(M_TECLA,2),"27") > 0
  return 0
endif

if rat(strzero(M_TECLA,2),"05.24") > 0
  return 2
endif

if M_TECLA = 13
  M_PRODUTO[POSICAO] = iif(left(M_PRODUTO[POSICAO],2) == "  "," û","  ") + right(M_PRODUTO[POSICAO],69)
  if left(M_PRODUTO[POSICAO],2) == "  "
    M_QDE --
  else
    M_POSI3 = POSICAO
    M_QDE ++
    M_QUANTI = 0
    @ 11+POSI2, 16 get M_QUANTI picture "99999"
    read
    M_PRODUTO[M_POSI3] = substr(M_PRODUTO[M_POSI3],1,11) + str(M_QUANTI,5,0) + substr(M_PRODUTO[M_POSI3],17,55)
  endif
  setcolor("B/W")
    @ 07, 72 say M_QDE picture "99"
  setcolor("N/W,W+/N")
endif

return 2
