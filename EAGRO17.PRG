#command @ <row> , <col>  GET <var> [<clauses,...>] F2 [<moreClauses,...>] funcao <func> retorno <Variavel>;
=>       @ <row> , <col>  GET <var> [<clauses>] SEND reader := {|oGet| Getf2(oGet,<func>,<Variavel>) } [<moreClauses>]

***************
function MANNFE
***************
parameters M_OPC,M_OPC1,M_OPC2

#include "ptmenu.ch"

_FUNFOR_ = "NFE.t."
_FUNCLI_ = "NFE.t."
_FUNPRO_ = "NFE.t."
_FUNVEN_ = "NFE.t."
_FUNCPG_ = "NFE.t."
_FUNTRA_ = "NFE.f."
_FUNPLX_ = "NFE.f."

lAlteranfe = .f.
lAltite = .f.
lPosnfe = 0
nLinnfe = 2

      rodape("MENU", "NFE", M_FAN, "EAGRO17","Mem: " + str(memory(0), 5), M_EMP)

*	@ 05, 10 prompt "Inclus„o " HIGHLITE R/BG SENHA 96
*	@ 06, 10 prompt "Altera‡„o" HIGHLITE R/BG SENHA 97
*  @ 07, 10 prompt "Consulta " HIGHLITE R/BG SENHA 98
*	@ 08, 10 prompt "Exclus„o " HIGHLITE R/BG SENHA 99
*	@ 09, 10 prompt "Listagem " HIGHLITE R/BG SENHA 100
*	@ 10, 10 prompt "Outros   " HIGHLITE R/BG SENHA 101
*	@ 11, 10 prompt "Sintegra " HIGHLITE R/BG SENHA 102
*	@ 12, 10 prompt "Lerdanfe " HIGHLITE R/BG SENHA 102

      do case
	 case M_OPC = 1
	      incnfe()   
	 case M_OPC = 2
	      altnfe()   
	 case M_OPC = 3
	      connfe()     
	 case M_OPC = 4
	      excnfe()   
	 case M_OPC = 5
	      lisnfe(M_OPC1)
	 case M_OPC = 6
	      outnfe()   
	 case M_OPC = 7
	      lerdanf()
      endcase

    fecha_arq()

return ""

*****************
function ATUSALDO(F_PRODUTO)
*****************

private M_SLD    ,;
        M_SLDDTE ,;
        M_SLDDTS ,;
        M_OPC

M_DTAINV = ctod("01/01/2015")

    select APCA00
    if !dbseek(str(F_PRODUTO, 6, 0))
      return ""
    endif
  
    select AKAR00 
    dbseek(str(ME_EMP, 2, 0) + str(F_PRODUTO, 6, 0) + dtos(M_DTAINV) + "1.000",.t.)

    if !str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) + KARFISN == str(ME_EMP, 2, 0) + str(F_PRODUTO, 6, 0) + dtos(M_DTAINV) + "1.000" 
      dbseek(str(ME_EMP, 2, 0) + str(F_PRODUTO, 6, 0),.t.)
    endif 
 
    M_SLD    = 0
    M_QDE    = 0  

    M_KAREMP = KAREMP
    M_KARDTA = KARDTA
    M_KARFISN = KARFISN
    M_KARDOC = KARDOC
    M_KARSEQ = KARSEQ
    M_KARSER = KARSER
    M_KARQDE = KARQDE
      
    do while !eof()

      if !str(KAREMP, 2, 0) + str(KARMAT, 6, 0) == str(ME_EMP, 2, 0) + str(F_PRODUTO, 6, 0)
        exit
      endif  

      AFIS00->(dbseek(AKAR00->KARFISN))

      if AFIS00->FISEST = "D"
        M_SLD    = M_SLD - KARQDE
      else
        if AFIS00->FISEST = "C"
          M_SLD    = M_SLD + KARQDE
        endif
      endif

      if KARFISN == "1.000"
        M_SLD  = KARQDE
      endif

      skip

    enddo

    select ASLD00

    if dbseek(str(ME_EMP, 2) + str(F_PRODUTO, 6))
      do while .t. 
        if rlock()
          replace SLDDIS with M_SLD
          unlock
          exit
        else
          msw("* * * (APCA00) REGISTRO SENDO USADO * * *")
        endif
        if lastkey() = 17
          exit
        endif
      enddo
    endif

    select APCA00

    MSE = strzero(ME_EMP,2)

    do while .t. 
      if rlock()
        replace SLD&MSE with M_SLD
        unlock
        exit
      else
        msw("* * * (APCA00) REGISTRO SENDO USADO * * *")
      endif
      if lastkey() = 17
        exit
      endif
    enddo

return ""

****************
function  INCNFE 
****************

LOCAL aBlocks1 := {}

  aAdd( aBlocks1, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
  aAdd( aBlocks1, {|| wvt_DrawLabel(21+nLinNfe,48,"Sair",,, RGB( 255, 255,255 )  ,RGB(0,0,0) , "Visualnova", _FONTET_*.9,_FONTEL_*.9 , , , , .f., .f. ,.f.)})
  aAdd( aBlocks1, {|| wvt_DrawLabel(21+nLinNfe,52,"Insere",,, RGB( 255, 255,255 )  ,RGB(0,0,0) , "Visualnova", _FONTET_*.9,_FONTEL_*.9 , , , , .f., .f. ,.f.)})
  aAdd( aBlocks1, {|| wvt_DrawLabel(21+nLinNfe,58,"Deleta",,, RGB( 255, 255,255 )  ,RGB(0,0,0) , "Visualnova", _FONTET_*.9,_FONTEL_*.9 , , , , .f., .f. ,.f.)})
  aAdd( aBlocks1, {|| wvt_DrawLabel(21+nLinNfe,64,"Adiciona",,, RGB( 255, 255,255 )  ,RGB(0,0,0) , "Visualnova", _FONTET_*.9,_FONTEL_*.9 , , , , .f., .f. ,.f.)})
  aAdd( aBlocks1, {|| wvt_DrawLabel(21+nLinNfe,72,"Bases",,, RGB( 255, 255,255 )  ,RGB(0,0,0) , "Visualnova", _FONTET_*.9,_FONTEL_*.9 , , , , .f., .f. ,.f.)})

  aAdd( aBlocks1, {|| wvt_DrawLabel(21+nLinNfe,48,"S",,, RGB(178,34,34),RGB(0,0,0) , "Visualnova", _FONTET_*.9,_FONTEL_*.9 , , , , .f., .f. ,.f.)})
  aAdd( aBlocks1, {|| wvt_DrawLabel(21+nLinNfe,52,"I",,, RGB(178,34,34),RGB(0,0,0) , "Visualnova", _FONTET_*.9,_FONTEL_*.9 , , , , .f., .f. ,.f.)})
  aAdd( aBlocks1, {|| wvt_DrawLabel(21+nLinNfe,58,"D",,, RGB(178,34,34),RGB(0,0,0) , "Visualnova", _FONTET_*.9,_FONTEL_*.9 , , , , .f., .f. ,.f.)})
  aAdd( aBlocks1, {|| wvt_DrawLabel(21+nLinNfe,64,"A",,, RGB(178,34,34),RGB(0,0,0) , "Visualnova", _FONTET_*.9,_FONTEL_*.9 , , , , .f., .f. ,.f.)})
  aAdd( aBlocks1, {|| wvt_DrawLabel(21+nLinNfe,72,"B",,, RGB(178,34,34),RGB(0,0,0) , "Visualnova", _FONTET_*.9,_FONTEL_*.9 , , , , .f., .f. ,.f.)})


  aAdd( aBlocks1, {|| Wvt_DRAWBOXRECESSED( 01+nLinnfe, 01, 20+nLinnfe, 77) } )
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 01, 11+nLinnfe, 77,{+15,,-15,})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 01, 20+nLinnfe, 5 ,{+15,,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 06, 20+nLinnfe, 12,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 13, 20+nLinnfe, 22,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 23, 20+nLinnfe, 33,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 34, 20+nLinnfe, 44,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 45, 20+nLinnfe, 50,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 51, 20+nLinnfe, 61,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 62, 20+nLinnfe, 63,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 64, 20+nLinnfe, 65,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 66, 20+nLinnfe, 71,{+15,-10,,-10})})


  set key -9 to CALCULA()

  private M_TELA

  declare M_NFENDP[24] ,;
	  M_NFEVDP[24]

  lAlteranfe = .f.

  do while .t. 

    M_NFEMAT = {}
    aEXCLUIK = { }

    tlnfe01()
    aLastPaint1 := WvtSetBlocks( aBlocks1 )

    rodape("INCLUI", "NFE", M_FAN, "EAGRO17","Mem: " + str(memory(0), 5), M_EMP)

    M_NFEEMP = ME_EMP
    M_NFENUM = 0
    M_NFESER = space(2)
    M_NFESER1 = space(3)
    M_NFEFOR = 0
    R        = 0
    
    SetColor(_COREDICAO_)
    @ 04+nLinnfe, 15 get M_NFENUM picture "#########"                 valid vernfe01(.t.)
    @ 05+nLinnfe, 15 get M_NFESER picture "@!"                        valid vernfe02()
    @ 06+nLinnfe, 15 get M_NFEFOR picture "#######" F2 color _CORF2_  valid vernfe03() funcao "sele_arquivo('AFOR00')" retorno @M_NFEFOR
    read

    if lastkey() = 27 
      exit
    endif

    if BUSCAREGISTRO("ANFE00",1,{str(ME_EMP, 2, 0),str(M_NFENUM, 9, 0),aspas(M_NFESER),str(M_NFEFOR, 5, 0)},"SELECT")
      msg("* * * NOTA DE ENTRADA JA INCLUIDA * * *")
      WvtSetBlocks( aLastPaint1 )
      loop
    endif

    M_NFEDTE = ctod("  /  /  ")             && 01 EMP codigo da empresa
    M_NFEDTR = ctod("  /  /  ")             && 02 NUM numero da nota fiscal

    M_NFENATN = space(5)                     && 03 SER serie da nota fiscal
    M_NFECPG = 0                            && 04 FOR codigo do fornecedor
    M_NFEPSN = "S"                          && 05 SEQ sequencia na nota fiscal
    M_NFESIT = " "                          && 07 QDE quantidade
    M_NFEIPL = " "                          && 08 PUN preco unitario

    M_NFEITE = 0                            && 09 VLI valor do item
    M_NFEDST = 0                            && 10 PIP percentual de ipi
    M_NFEDSN = 0                            && 11 VIP valo do ipi
    M_NFEDSC = 0                            && 12 ESC escrituracao fiscal
    M_NFEFRE = 0                            && 13 EXE execao

    M_NFEBIC = 0                            && 14 BIC base de calculo do icms
    M_NFEVIC = 0                            && 15 RED reducao de base de calculo
    M_NFEVLM = 0                            && 16 PIC percentual de icm
    M_NFEVIP = 0                            && 17 VIC valor do icms
    M_NFESUB = 0
    M_NFEVLN = 0                            && 18 ISE isento
    M_NFEOBS = space(20)
    M_NFSID = space(44)
    M_NFECOMP = " "
    M_NFEMOD = 0

    afill(M_NFENDP,0               )        && 20 DSN despesa nao tributada
    afill(M_NFEVDP,ctod("  /  /  "))        && 21 DST despesa tributada
					    && 22 FRE frete
    ednfe01()

    if lastkey() = 27
      msg("* * * NOTA DE ENTRADA NAO INCLUIDA * * *")
      WvtSetBlocks( aLastPaint1 )
      loop
    endif

    if M_NFEPSN = "S"
      cal_dupnfe()   && calcula duplicatas contas a pagar
    endif

    L = 12  && linha inicial digitacao
    S = 00  && flag de controle de saida 
    R = 01

    do while .t.

                 //  1  2    3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26    27  28 29 30  13,32,33
      aadd(M_NFEMAT,{0,"  ", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,"    ","N",0,"  ",0,0,0,,.t.})

      M_NFEMAT[R, 1] = ME_EMP            && EMP
      M_NFEMAT[R, 2] = M_NFENUM          && NUM
      M_NFEMAT[R, 3] = M_NFESER          && SER
      M_NFEMAT[R, 4] = M_NFEFOR          && FOR
      M_NFEMAT[R, 5] = R                 && SEQ
      M_NFEMAT[R,12] = AFIS00->FISESC    && ESC
      M_NFEMAT[R,13] = AFIS00->FISEXE    && EXE
      M_NFEMAT[R][25] = 0 // substituicao

      ednfe02(L,R,"I")

      if lastkey() = 27 
      	adel(M_NFEMAT,R)
      	asize(M_NFEMAT,len(M_NFEMAT) - 1)
      	exit
      endif

      if L = 19
      	lpnfe01()
      	L = 11
      endif

      R ++
      L ++

    enddo

    if len(M_NFEMAT) = 0
      msg("* * * NOTA DE ENTRADA NAO INCLUIDA * * *")
      loop
    endif

    lpnfe01()

    declare M_VETORITE[len(M_NFEMAT)]

    for R = 1 to len(M_NFEMAT)
      M_VETORITE[R] = str(M_NFEMAT[R, 5], 3, 0) + " " + ;
		      str(M_NFEMAT[R, 6], 6, 0) + " " + ;
		      str(M_NFEMAT[R, 7], 9, 3) + " " + ;
		      str(M_NFEMAT[R, 8], 10, 2)+ " " + ;
		      str(M_NFEMAT[R, 9], 10, 2)+ " " + ;
		      str(M_NFEMAT[R,10], 5, 2) + " " + ;
		      str(M_NFEMAT[R,11], 10, 2)+ " " + ;
		      str(M_NFEMAT[R,12], 1, 0) + " " + ;
		      str(M_NFEMAT[R,13], 1, 0) + " " + ;
		      str(M_NFEMAT[R,16], 5, 2) + " " + ;
		      str(M_NFEMAT[R,15], 5, 2)
    next

    M_LINPOS = 0

    do while .t.

      BUSCAREGISTRO("APCA00",1,{substr(M_VETORITE[1], 5, 6)},"SELECT")

      wvt_DrawLabel(21+nLinNfe,3,APCA00->PCADES,,, RGB( 255, 255,255 )  ,RGB(0,0,0) , "Visualnova", _FONTET_*.8,_FONTEL_*.7 , , , , .f., .f. ,.f.)

      set color to N/W,W+/N
      	M_OPC = achoice(12+nLinnfe, 2,19+nLinnfe,76,M_VETORITE,,"mosnfe")
      set color to 

      if lastkey() = 13
      	altitenfe() && altera item
      	loop
      endif

      if str(lastkey(), 3, 0 ) $ " 83#115"
      	exit        && abandona operacao
      endif

      if str(lastkey(), 3, 0 ) $ " 65# 97"
      	additenfe() && adiciona itens
      	loop
      endif

      if str(lastkey(), 3, 0 ) $ " 66# 98"
      	cal_div(.t.) && calcula divergencias
      	loop
      endif

      if str(lastkey(), 3, 0 ) $ " 68#100"
      	delitenfe() && deleta item
      	loop
      endif

      if str(lastkey(), 3, 0 ) $ " 73#105"
      	insitenfe() && insere item
      	loop
      endif

    enddo

    cal_div(.f.) && calcula divergencias
    cal_div(.t.)  && calcula divergencia

    M_NFE = decide("Confirma Inclusao desta Nota de Entrada")

    if M_NFE != 1
      msg("* * * NOTA DE ENTRADA NAO INCLUIDA * * *")
      WvtSetBlocks( aLastPaint1 )
      loop
    endif

    grnfe00("INSERT")  && grava nota fiscal de entrada mestre
    grnfe01("INSERT")  && grava nota fiscal de entrada itens
 
    msg("* * * NOTA DE ENTRADA INCLUIDA * * *")

enddo

WvtSetBlocks( aLastPaint1 )

set key -5 to

return ""

******************
function ALTITENFE  && altera item da nota
******************

  aadd(aEXCLUIK,M_NFEMAT[M_OPC][33]) // registro para excluir kardex

  M_NFEMAT[M_OPC][34] = .t. // alterou ou novo

  ednfe02(12 + M_LINPOS,M_OPC,"A")      

  for S = 1 to len(M_NFEMAT) 
    M_VETORITE[S] = str(M_NFEMAT[S, 5], 3, 0) + " " + str(M_NFEMAT[S, 6], 6, 0) + " " + str(M_NFEMAT[S, 7], 9, 3) + " " + str(M_NFEMAT[S, 8], 10, 2) + " " + str(M_NFEMAT[S, 9], 10, 2) + " " + str(M_NFEMAT[S, 10], 5, 2) + " " + str(M_NFEMAT[S, 11], 10, 2) + " " + str(M_NFEMAT[S, 12], 1, 0) + " " + str(M_NFEMAT[S, 13], 1, 0) + " " + str(M_NFEMAT[S, 16], 5, 2) + " " + str(M_NFEMAT[S, 15], 5, 2)
  next

return ""

******************
function INSITENFE && insere item na nota
******************

private R,S

  aadd(M_NFEMAT,{0,"  ", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0, 0,"    ","N",0,"  ",0,0,0,.t.})

  R = len(M_NFEMAT)

  M_MATANT = aclone(M_NFEMAT)

  acopy(M_MATANT,M_NFEMAT,R,1,M_OPC)

  if M_OPC-1 = 1
    acopy(M_MATANT,M_NFEMAT,M_OPC-1,M_OPC-1,1)
  endif

  acopy(M_MATANT,M_NFEMAT,M_OPC,R-M_OPC,M_OPC+1)

  M_NFEMAT[M_OPC, 1] = ME_EMP            && EMP
  M_NFEMAT[M_OPC, 2] = M_NFENUM          && NUM
  M_NFEMAT[M_OPC, 3] = M_NFESER          && SER
  M_NFEMAT[M_OPC, 4] = M_NFEFOR          && FOR
  M_NFEMAT[M_OPC, 5] = R                 && SEQ
  M_NFEMAT[M_OPC,12] = AFIS00->FISESC    && ESC
  M_NFEMAT[M_OPC,13] = AFIS00->FISEXE    && EXE

  for S = 1 to len(M_NFEMAT) 
    M_NFEMAT[S,5] = S
  next

  msnfe02(M_OPC,12 + M_LINPOS)

  ednfe02(12 + M_LINPOS, M_OPC,"I")

  asize(M_VETORITE, R)

  ains(M_VETORITE, len(M_VETORITE))

  for S = 1 to len(M_NFEMAT) 
    M_VETORITE[S] = str(M_NFEMAT[S, 5], 3, 0) + " " + str(M_NFEMAT[S, 6], 6, 0) + " " + str(M_NFEMAT[S, 7], 9, 3) + " " + str(M_NFEMAT[S, 8], 10, 2) + " " + str(M_NFEMAT[S, 9], 10, 2) + " " + str(M_NFEMAT[S, 10], 5, 2) + " " + str(M_NFEMAT[S, 11], 10, 2) + " " + str(M_NFEMAT[S, 12], 1, 0) + " " + str(M_NFEMAT[S, 13], 1, 0) + " " + str(M_NFEMAT[S, 16], 5, 2) + " " + str(M_NFEMAT[S, 15], 5, 2)
  next

return ""

******************
function DELITENFE && deleta item da nota
******************

private M_NFE, R

M_NFE = decide("Confirma Exclusao deste Item")

if M_NFE != 1
  return ""
endif

aadd(aEXCLUIK,M_NFEMAT[M_OPC][33]) // registro para excluir kardex

adel(M_NFEMAT,M_OPC)
adel(M_VETORITE,M_OPC)

asize(M_NFEMAT,len(M_NFEMAT) - 1)
asize(M_VETORITE,len(M_VETORITE) - 1)

for R = 1 to len(M_NFEMAT)
 M_NFEMAT[R, 5]  = R
 M_VETORITE[R] = str(M_NFEMAT[R, 5], 3, 0) + " " + str(M_NFEMAT[R, 6], 6, 0) + " " + str(M_NFEMAT[R, 7], 9, 3) + " " + str(M_NFEMAT[R, 8], 10, 2) + " " + str(M_NFEMAT[R, 9], 10, 2) + " " + str(M_NFEMAT[R, 10], 5, 2) + " " + str(M_NFEMAT[R, 11], 10, 2) + " " + str(M_NFEMAT[R, 12], 1, 0) + " " + str(M_NFEMAT[R, 13], 1, 0) + " " + str(M_NFEMAT[R, 16], 5, 2) + " " + str(M_NFEMAT[R, 15], 5, 2)
next

lpnfe01()

return ""

******************
function ADDITENFE && insere item na nota
******************

  R = len(M_NFEMAT) + 1
  L = 12

  for S = 1 to len(M_NFEMAT)
    if L = 19
      lpnfe01()
      L = 11
    endif
    L ++
  next

  if len(M_NFEMAT) - (int(len(M_NFEMAT)/8)*8) != 0
    msnfe02((int(len(M_NFEMAT)/8)*8)+1 , 12)
  endif

  do while .t.

    aadd(M_NFEMAT,{0,"  ", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0, 0,"    ","N",0,"  ",0,0,0,.t.})

    M_NFEMAT[R, 1] = ME_EMP            && EMP
    M_NFEMAT[R, 2] = M_NFENUM          && NUM
    M_NFEMAT[R, 3] = M_NFESER          && SER
    M_NFEMAT[R, 4] = M_NFEFOR          && FOR
    M_NFEMAT[R, 5] = R                 && SEQ
    M_NFEMAT[R,12] = AFIS00->FISESC    && ESC
    M_NFEMAT[R,13] = AFIS00->FISEXE    && EXE

    ednfe02(L,R,"I")

    if lastkey() = 27 
      adel(M_NFEMAT,R)
      asize(M_NFEMAT,len(M_NFEMAT) - 1)
      exit
    endif

    if L = 19
      lpnfe01()
      L = 11
    endif

    R ++
    L ++

  enddo

  if len(M_NFEMAT) = 0
    msg("* * * NOTA DE ENTRADA NAO INCLUIDA * * *")
    return ""
  endif

  lpnfe01()

  asize(M_VETORITE, R)

  ains(M_VETORITE, len(M_VETORITE))

  for S = 1 to len(M_NFEMAT) 
    M_VETORITE[S] = str(M_NFEMAT[S, 5], 3, 0) + " " + str(M_NFEMAT[S, 6], 6, 0) + " " + str(M_NFEMAT[S, 7], 9, 3) + " " + str(M_NFEMAT[S, 8], 10, 2) + " " + str(M_NFEMAT[S, 9], 10, 2) + " " + str(M_NFEMAT[S, 10], 5, 2) + " " + str(M_NFEMAT[S, 11], 10, 2) + " " + str(M_NFEMAT[S, 12], 1, 0) + " " + str(M_NFEMAT[S, 13], 1, 0) + " " + str(M_NFEMAT[S, 16], 5, 2) + " " + str(M_NFEMAT[S, 15], 5, 2)
  next

return ""

***************
function MOSNFE
***************

parameters  M_MODO, M_ELEM, M_POSI

  if str(lastkey(), 2, 0) $ " 3#27#18"
    return 0
  endif

  if chr(lastkey()) $ "Cc"
    M_OPC = M_ELEM
    return 1
  endif

  lPosnfe = M_ELEM

  if str(lastkey(), 3, 0)  $ "# 13# 83# 73# 68# 65# 66#115#105#100# 97# 98"
    M_OPC = M_ELEM
    return 1
  endif

  BUSCAREGISTRO("APCA00",1,{substr(M_VETORITE[M_ELEM], 5, 6)},"SELECT")

  wvt_DrawLabel(21+nLinNfe,3,APCA00->PCADES,,, RGB( 255, 255,255 )  ,RGB(0,0,0) , "Visualnova", _FONTET_*.8,_FONTEL_*.7 , , , , .f., .f. ,.f.)

  set color to N/W,W+/N

 M_LINPOS = M_POSI

return 2


****************
function  ALTNFE
****************

LOCAL aBlocks1 := {}


*   _CORF2_ = "N/W*,W+/G"
setcolor("W*/N")
  @ 21+nLinNfe,48-4 say "Sair"
  @ 21+nLinNfe,52-3 say "Insere"
  @ 21+nLinNfe,58-2 say "Deleta"
  @ 21+nLinNfe,64-1 say "Adiciona"
  @ 21+nLinNfe,72 say "Bases"
setcolor("R+/N")
  @ 21+nLinNfe,48-4 say "S"
  @ 21+nLinNfe,52-3 say "I"
  @ 21+nLinNfe,58-2 say "D"
  @ 21+nLinNfe,64-1 say "A"
  @ 21+nLinNfe,72 say "B"
setcolor("")

  aAdd( aBlocks1, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
  aAdd( aBlocks1, {|| Wvt_DRAWBOXRECESSED( 01+nLinnfe, 01, 20+nLinnfe, 77) } )
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 01, 11+nLinnfe, 77,{+15,,-15,})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 01, 20+nLinnfe, 5 ,{+15,,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 06, 20+nLinnfe, 12,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 13, 20+nLinnfe, 22,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 23, 20+nLinnfe, 33,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 34, 20+nLinnfe, 44,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 45, 20+nLinnfe, 50,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 51, 20+nLinnfe, 61,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 62, 20+nLinnfe, 63,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 64, 20+nLinnfe, 65,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 66, 20+nLinnfe, 71,{+15,-10,,-10})})

  aLastPaint1 := WvtSetBlocks( aBlocks1 )

  set key -9 to CALCULA()

  private M_TELA

  declare M_NFENDP[24] ,;
	  M_NFEVDP[24]

  lAlteranfe = .t.

  do while .t. 

    tlnfe01()
  
    keyfun()                       && tela de funcoes

    rodape("ALTERA", "NFE", M_FAN, "EAGRO17","Mem: " + str(memory(0), 5), M_EMP)

    M_NFEEMP = ME_EMP
    M_NFENUM = 0
    M_NFESER = space(2)
    M_NFEFOR = 0
    M_NFESER1 = "   "
    
    SetColor(_COREDICAO_)
    @ 04+nLinnfe, 15 get     M_NFENUM picture "#########"       valid vernfe01(.f.)
    @ 05+nLinnfe, 15 get     M_NFESER picture "@!"              valid vernfe02()
    @ 06+nLinnfe, 15 get     M_NFEFOR picture "#######"         valid vernfe03()
    read

    if lastkey() = 27 
      exit
    endif

    if !BUSCAREGISTRO("ANFE00",1,{str(ME_EMP, 2, 0),str(M_NFENUM, 9, 0),aspas(M_NFESER),str(M_NFEFOR, 5, 0)},"SELECT")
      msg("* * * NOTA DE ENTRADA NAO INCLUIDA * * *")
      loop
    endif

    M_NFESER1 = NFESER1
    M_NFEDTE = iif(HB_ISNIL(NFEDTE),ctod("  /  /  "),NFEDTE)
    M_NFEDTR = iif(HB_ISNIL(NFEDTR),ctod("  /  /  "),NFEDTR)
    M_NFENATN = NFENATN
    M_NFECPG = NFECPG
    M_NFEPSN = NFEPSN
    M_NFESIT = NFESIT
    M_NFEIPL = NFEIPL

    M_NFEITE = NFEITE
    M_NFEDST = NFEDST
    M_NFEDSN = NFEDSN
    M_NFEDSC = NFEDSC

    M_NFEFRE = NFEFRE
    M_NFESUB = NFESUB

    M_NFEBIC = NFEBIC
    M_NFEVIC = NFEVIC
    M_NFEVLM = NFEVLM
    M_NFEVIP = NFEVIP
    M_NFEVLN = NFEVLN
    M_NFEOBS  = NFEOBS  
    M_NFENATN = NFENATN
    M_NFSID = left(NFSID,44)
    M_NFECOMP = NFECOMP
    M_NFEMOD = NFEMOD

    for A = 1 to 6
      MS = str(A,1)
      M_NFEVDP[A] = iif(HB_ISNIL(NFEVC&MS),ctod("  /  /  "),NFEVC&MS)
      M_NFENDP[A] = NFEDP&MS
    next
					   
    ednfe01()

    if lastkey() = 27
      msg("* * * NOTA DE ENTRADA NAO ALTERADA * * *")
      loop
    endif

    if M_NFEPSN = "S"
      edi_dupnfe()   && calcula duplicatas contas a pagar
    endif

    L = 12  && linha inicial digitacao
    S = 00  && flag de controle de saida 
    R = 01

    M_NFEMAT = {}
    aEXCLUIK = { }

    grnfe01("SELECT")

    nSEQ = 1
    do while !eof()

      aadd(M_NFEMAT,{0,"  ", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0, 0,"    ","N",0,"  ",0,0,0,.f.})
      // 34 .t. ou .f. novo registro
      M_NFEMAT[NSEQ,  1] = NFEEMP
      M_NFEMAT[NSEQ,  2] = NFENUM
      M_NFEMAT[NSEQ,  3] = NFESER
      M_NFEMAT[NSEQ,  4] = NFEFOR
      M_NFEMAT[NSEQ,  5] = nSEQ
      M_NFEMAT[NSEQ,  6] = NFEMAT
      M_NFEMAT[NSEQ,  7] = NFEQDE
      M_NFEMAT[NSEQ,  8] = NFEPUN
      M_NFEMAT[NSEQ,  9] = NFEVLI
      M_NFEMAT[NSEQ, 10] = NFEPIP
      M_NFEMAT[NSEQ, 11] = NFEVIP
      M_NFEMAT[NSEQ, 12] = NFEESC
      M_NFEMAT[NSEQ, 13] = NFEEXE
      M_NFEMAT[NSEQ, 15] = NFERED
      M_NFEMAT[NSEQ, 14] = NFEBIC
      M_NFEMAT[NSEQ, 16] = NFEPIC
      M_NFEMAT[NSEQ, 17] = NFEVIC
      M_NFEMAT[NSEQ, 18] = NFEISE
      M_NFEMAT[NSEQ, 19] = NFEOUT
      M_NFEMAT[NSEQ, 21] = NFEDST
      M_NFEMAT[NSEQ, 20] = NFEDSN
      M_NFEMAT[NSEQ, 22] = NFEFRE
      M_NFEMAT[NSEQ, 23] = NFELIQ
      M_NFEMAT[NSEQ, 24] = NFEDSC
      M_NFEMAT[NSEQ, 25] = NFESUB
      M_NFEMAT[NSEQ, 27] = NFENATN
      M_NFEMAT[NSEQ, 28] = NFEEST
      M_NFEMAT[NSEQ, 30] = NFEORI+NFECST
      M_NFEMAT[NSEQ, 31] = NFEBICST
      M_NFEMAT[NSEQ, 33] = recno
      M_NFEMAT[NSEQ, 34] = .f.

      nSEQ ++

      skip

    enddo

    if len(M_NFEMAT) = 0
      msg("* * * NOTA DE ENTRADA NAO POSSUI ITENS * * *")
      loop
    endif

    lpnfe01()

    declare M_VETORITE[len(M_NFEMAT)]

    for R = 1 to len(M_NFEMAT)
      M_VETORITE[R] = str(M_NFEMAT[R, 5], 3, 0) + " " + ;
		      str(M_NFEMAT[R, 6], 6, 0) + " " + ;
		      str(M_NFEMAT[R, 7], 9, 3) + " " + ;
		      str(M_NFEMAT[R, 8], 10, 2)+ " " + ;
		      str(M_NFEMAT[R, 9], 10, 2)+ " " + ;
		      str(M_NFEMAT[R,10], 5, 2) + " " + ;
		      str(M_NFEMAT[R,11], 10, 2)+ " " + ;
		      str(M_NFEMAT[R,12], 1, 0) + " " + ;
		      str(M_NFEMAT[R,13], 1, 0) + " " + ;
		      str(M_NFEMAT[R,16], 5, 2) + " " + ;
		      str(M_NFEMAT[R,15], 5, 2)
    next

    M_LINPOS = 0
    lPosnfe = 1

    do while .t.

      BUSCAREGISTRO("APCA00",1,{substr(M_VETORITE[1], 5, 6)},"SELECT")

      wvt_DrawLabel(21+nLinNfe,3,APCA00->PCADES,,, RGB( 255, 255,255 )  ,RGB(0,0,0) , "Visualnova", _FONTET_*.8,_FONTEL_*.7 , , , , .f., .f. ,.f.)

      set color to N/W,W+/N
      	M_OPC = achoice(12+nLinnfe, 2,19+nLinnfe,76,M_VETORITE,,"mosnfe",lPosnfe)
      set color to

      if lastkey() = 13
        lAltite = .t.
      	altitenfe() && altera item
      	loop
      endif

      if str(lastkey(), 3, 0 ) $ " 83#115"
      	exit        && abandona operacao
      endif

      if str(lastkey(), 3, 0 ) $ " 65# 97"
        lAltite = .f.
      	additenfe() && adiciona itens
      	loop
      endif

      if str(lastkey(), 3, 0 ) $ " 66# 98"
      	cal_div(.t.) && calcula divergencias
      	loop
      endif

      if chr(lastkey()) $ "Cc"
      	ednfe01()
      	loop
      endif

      if str(lastkey(), 3, 0 ) $ " 68#100"
      	delitenfe() && deleta item
      	loop
      endif

      if str(lastkey(), 3, 0 ) $ " 73#105"
        lAltite = .f.
      	insitenfe() && insere item
      	loop
      endif

    enddo

    cal_div(.t.)  && calcula divergencia

    select ANFE00

    grnfe00("UPDATE")  && grava nota fiscal de entrada mestre
    grnfe01("INSERT") // SEMPRE GRAVA TUDO

    msg("* * * NOTA DE ENTRADA ALTERADA * * *")

enddo

WvtSetBlocks( aLastPaint1 )


return ""

****************
function  CONNFE(F_OQUE)
****************
LOCAL aBlocks1 := {}

if F_OQUE = NIL
  F_OQUE = "NORMAL"
endif

  aAdd( aBlocks1, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
  aAdd( aBlocks1, {|| Wvt_DRAWBOXRECESSED( 01+nLinnfe, 01, 20+nLinnfe, 77) } )
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 01, 11+nLinnfe, 77,{+15,,-15,})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 01, 20+nLinnfe, 5 ,{+15,,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 06, 20+nLinnfe, 12,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 13, 20+nLinnfe, 22,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 23, 20+nLinnfe, 33,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 34, 20+nLinnfe, 44,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 45, 20+nLinnfe, 50,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 51, 20+nLinnfe, 61,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 62, 20+nLinnfe, 63,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 64, 20+nLinnfe, 65,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 66, 20+nLinnfe, 71,{+15,-10,,-10})})
  aLastPaint1 := WvtSetBlocks( aBlocks1 )


  private M_TELA

  lPritela = .t.
  
  do while .t.

    tlnfe01()

*    if lPritela
*      aLastPaint1 := WvtSetBlocks( aBlocks1 )
*      lPritela = .f.
*    endif

    if F_OQUE == "NORMAL"
      rodape("CONSULTA", "NFE", M_FAN, "EAGRO17","Mem: " + str(memory(0), 5), M_EMP)
      M_NFEEMP = ME_EMP
      M_NFENUM = 0
      M_NFESER = space(2)
      M_NFEFOR = 0
    
       SetColor(_COREDICAO_)
       @ 04+nLinnfe, 15 get     M_NFENUM picture "#########"       valid vernfe01(.f.)
       @ 05+nLinnfe, 15 get     M_NFESER picture "@!"           valid vernfe02()
       @ 06+nLinnfe, 15 get     M_NFEFOR picture "#######"        valid vernfe03()
       read

       if lastkey() = 27
         exit
       endif

       if !BUSCAREGISTRO("ANFE00",1,{str(ME_EMP, 2, 0),str(M_NFENUM, 9, 0),aspas(M_NFESER),str(M_NFEFOR, 5, 0)},"SELECT")
         msg("* * * NOTA DE ENTRADA NAO INCLUIDA * * *")
         loop
       endif

     endif

     msnfe01()
     msnfe03()

     if F_OQUE == "PAGAR"
       exit
     endif

enddo

WvtSetBlocks( aLastPaint1 )

return ""

****************
function  EXCNFE 
****************

LOCAL aBlocks1 := {}

  aAdd( aBlocks1, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
  aAdd( aBlocks1, {|| Wvt_DRAWBOXRECESSED( 01+nLinnfe, 01, 20+nLinnfe, 77) } )
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 01, 11+nLinnfe, 77,{+15,,-15,})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 01, 20+nLinnfe, 5 ,{+15,,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 06, 20+nLinnfe, 12,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 13, 20+nLinnfe, 22,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 23, 20+nLinnfe, 33,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 34, 20+nLinnfe, 44,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 45, 20+nLinnfe, 50,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 51, 20+nLinnfe, 61,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 62, 20+nLinnfe, 63,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 64, 20+nLinnfe, 65,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09+nLinnfe, 66, 20+nLinnfe, 71,{+15,-10,,-10})})



  private M_TELA ,;
	  M_OPC

  lPritel = .t.
  
  do while .t. 

    tlnfe01()


    if lPritel
      aLastPaint1 := WvtSetBlocks( aBlocks1 )
      lPritel = .f.
    endif
    
    rodape("EXCLUSAO", "NFE", M_FAN, "EAGRO17","Mem: " + str(memory(0), 5), M_EMP)

    M_NFEEMP = ME_EMP
    M_NFENUM = 0
    M_NFESER = space(2)
    M_NFEFOR = 0
    
  SetColor(_COREDICAO_)
    @ 04+nLinnfe, 15 get     M_NFENUM picture "#########"       valid vernfe01(.f.)
    @ 05+nLinnfe, 15 get     M_NFESER picture "@!"           valid vernfe02()
    @ 06+nLinnfe, 15 get     M_NFEFOR picture "#######"      valid vernfe03()
    read

    if lastkey() = 27 
      exit
    endif

    if !BUSCAREGISTRO("ANFE00",1,{str(ME_EMP, 2, 0),str(M_NFENUM, 9, 0),aspas(M_NFESER),str(M_NFEFOR, 5, 0)},"SELECT")
      msg("* * * NOTA DE ENTRADA NAO INCLUIDA * * *")
      loop
    endif

    msnfe01()
    msnfe03()

    M_NFE = decide("Confirma Exclusao desta Nota de Entrada")

    if M_NFE != 1
      msg("* * * NOTA DE ENTRADA NAO EXCLUIDA * * *")
      loop
    endif

    sqlCAMPO = {}
    sqlCHAVE = {}
    sqlARQUI = {"ANFE01","DELETE"}
    aadd(sqlCHAVE,{"NFEEMP",str(ANFE00->NFEEMP,2)})
    aadd(sqlCHAVE,{"NFENUM",str(ANFE00->NFENUM,9)})
    aadd(sqlCHAVE,{"NFEFOR",str(ANFE00->NFEFOR,5)})
    aadd(sqlCHAVE,{"NFESER",aspas(ANFE00->NFESER)})
    executasql()


    sqlCAMPO = {}
    sqlCHAVE = {}
    sqlARQUI = {"AKAR00","DELETE"}
    aadd(sqlCHAVE,{"KAREMP",str(ANFE00->NFEEMP,2)})
    aadd(sqlCHAVE,{"KARDOC",str(ANFE00->NFENUM,9)})
    aadd(sqlCHAVE,{"KARCLF",str(ANFE00->NFEFOR,5)})
    aadd(sqlCHAVE,{"KARSER",aspas(ANFE00->NFESER)})
    executasql()

    sqlCAMPO = {}
    sqlCHAVE = {}
    sqlARQUI = {"ANFE00","DELETE"}
    aadd(sqlCHAVE,{"NFEEMP",str(ANFE00->NFEEMP,2)})
    aadd(sqlCHAVE,{"NFENUM",str(ANFE00->NFENUM,9)})
    aadd(sqlCHAVE,{"NFEFOR",str(ANFE00->NFEFOR,5)})
    aadd(sqlCHAVE,{"NFESER",aspas(ANFE00->NFESER)})
    executasql()


  msg("* * * NOTA FISCAL DE ENTRADA EXCLUIDA * * *")

enddo
WvtSetBlocks( aLastPaint1 )

return ""

****************
function  LISNFE 
****************
parameters M_OPC,M_OPC1,M_OPC2

    rodape("LISTA", "NFE", M_FAN, "EAGRO17", "Mem: " + str(memory(0), 5), M_EMP)

*    @ 11, 16 prompt "Analitica" HIGHLITE R/BG SENHA 103
*    @ 12, 16 prompt "Sintetica" HIGHLITE R/BG SENHA 104

  do case
	case M_OPC = 1
*	  lisnfe_a()
	case M_OPC = 2
	  lisnfe_b()
  endcase

return ""

*****************
function LISNFE_A 
*****************

  do while .t.

     M_RECINI = ctod("  /  /  ")
     M_RECFIN = ctod("  /  /  ")
     M_RECFOR = 0

     sombra(12, 20, 16, 47, _SOMBRA_)

     set color to GR+/W
       @ 12, 20 say    "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
       @ 13, 20 say    "³Recepcao Inicial:         ³"
       @ 14, 20 say    "³           Final:         ³"
       @ 15, 20 say    "³      Fornecedor:         ³"
       @ 16, 20 say    "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
  SetColor(_COREDICAO_)
     @ 13, 39 get     M_RECINI
     @ 14, 39 get     M_RECFIN
     @ 15, 39 get     M_RECFOR picture "#####"
     read

     if lastkey() = 27
       exit
     endif

     M_RECINI = iif(dtoc(M_RECINI) = "  /  /  ",ctod("01/01/80"),M_RECINI)
     M_RECFIN = iif(dtoc(M_RECFIN) = "  /  /  ",ctod("31/12/79"),M_RECFIN) 

     select ANFE00

     set relation to str(NFEFOR, 7, 0) into AFOR00

     ( dbsetorder(2) , dbseek(str(ME_EMP, 2, 0) + dtos(M_RECINI), .t.) )

     if str(NFEEMP, 2, 0) + dtos(NFEDTR) > str(ME_EMP, 2, 0) + dtos(M_RECFIN) 
       msg("* * * NADA A LISTAR NO INTERVALO * * *")
       loop
     endif
M_ARQI  = substr(time(),4,2) + substr(time(),7,2) + ".RPT"       
     M_IMPRE = impresn()

     if M_IMPRE = "N"
       loop
     endif

     if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
       ?? chr(15)                        && comprime
     endif

     store 0 to PG ,;
		LN

     select ANFE00

     cab_nfe()

     do while !eof() 

       if str(NFEEMP, 2, 0) + dtos(NFEDTR)  > str(ME_EMP, 2, 0) + dtos(M_RECFIN)
	 go bottom
	 skip
	 loop 
       endif
  
       if M_RECFOR > 0
	 if NFEFOR != M_RECFOR
	   skip
	   loop
	 endif
       endif

       ? replicate("-", 132)
       ? "NFE-NUM SERIE  FORNEC  NOME DO FORNECEDOR                  UF   NATUREZA        RECEPCAO  EMISSAO    CPG               OBSERVACOES   "

       LN = LN + 2

       if LN > 60
	 cab_nfe()
       endif              

       ? " "
	 ?? str(NFENUM, 6, 0)
	 ?? "    " 
	 ?? NFESER
	 ?? "  "
	 ?? str(NFEFOR, 7, 0)
	 ?? " "
	 ?? left(AFOR00->FORNOM, 35)
	 ?? " "
	 ?? AFOR00->FOREST
	 ?? "  "
	 ?? transform((NFENAT * .01),"###.##")
	 ?? "           "
	 ?? NFEDTR
	 ?? "  "
	 ?? NFEDTE
	 ?? "   "
	 ?? str(NFECPG, 3, 0)
  
	 LN = LN + 1

	 if LN > 60
	   cab_nfe()
	 endif

	 ?
	 ? "                             VALOR DO ICMS             DSP TRIBUTADA  NAO TRIBUTADA     VALOR MERC      VALOR IPI       VALOR NOTA"

	 LN = LN + 2

	 if LN > 60
	   cab_nfe()
	 endif

	 ? space(28)
	   ?? transform(NFEVIC, "@E ###,###,###.##")
	   ?? space(12)
	   ?? transform(NFEDST, "@E ###,###,###.##")
	   ?? ""
	   ?? transform(NFEDSN, "@E ####,###,###.##")
	   ?? " "
	   ?? transform(NFEVLM, "@E ###,###,###.##")
	   ?? " "
	   ?? transform(NFEVIP, "@E ###,###,###.##")
	   ?? " "
	   ?? transform(NFEVLN, "@E #####,###,###.##")
	 ?

	 LN = LN + 2

	 if LN > 60
	   cab_nfe()
	 endif

	 select ANFE01

	 dbseek(str(ME_EMP, 2, 0) + str(ANFE00->NFENUM, 6, 0) + ANFE00->NFESER + str(ANFE00->NFEFOR, 7, 0) + "  ",.t.)

	 ? " SQ CODIGO  REFERENCIA DESCRICAO                                 UN QTDE      VALOR INI  VALOR ITEM % IPI VALOR IPI  E X ICM % RED"
*            99 99999-9 XXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX ######### ########## ########## ##.## ########## # # ### ##.##

	 LN = LN + 1

	 if LN > 60
	   cab_nfe()
	 endif

	 do while !eof()

	   if !str(NFEEMP, 2, 0) + str(NFENUM, 6, 0) + NFESER + str(NFEFOR, 7, 0) == str(ANFE00->NFEEMP, 2, 0) + str(ANFE00->NFENUM, 6, 0) + ANFE00->NFESER + str(ANFE00->NFEFOR, 7, 0)
	     exit
	   endif

	   APCA00->(dbseek(str(ANFE01->NFEMAT, 6, 0)))

	   ?  
	     ?? str(NFESEQ, 3, 0)
	     ?? " "
	     ?? transform(str(NFEMAT, 6, 0), "@R 99999-9")
	     ?? " "                  
	     ?? pad(APCA00->PCAREF, 10)
	     ?? " " 
	     ?? left(APCA00->PCADES, 41)
	     ?? " "
	     ?? pad(APCA00->PCAUNI, 2)
	     ?? " "
	     ?? transform(NFEQDE,"#####.###")  
	     ?? " "
	     ?? transform(NFEPUN,"@E ###,###.##")
	     ?? " "
	     ?? transform(NFEVLI,"@E ###,###.##")
	     ?? " "
	     ?? transform(NFEPIP,"@E ##.##")
	     ?? " "
	     ?? transform(NFEVIP,"@E ###,###.##")
	     ?? " "
	     ?? NFEESC
	     ?? " "
	     ?? NFEEXE
	     ?? " "
	     ?? transform(NFEPIC,"###")  
	     ?? " "
	     ?? str(NFERED, 6, 2)


	     LN = LN + 1
    
	     if LN > 60
	       cab_nfe()
	     endif

	     skip

	   enddo

	   select ANFE00

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

    ? replicate("=", 132)

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(18)                        && descomprime
    endif

    eject
 
    set print off
    set printer to
    set console on 
    set cursor on 
    set relation to

    ANFE00->(dbsetorder(1))

desliga1()
  enddo
	
return ""

*****************
function LISNFE_B 
*****************

  do while .t.

     M_RECINI = ctod("  /  /  ")
     M_RECFIN = ctod("  /  /  ")
     M_RECFOR = 0

     sombra(12, 20, 16, 47, _SOMBRA_)

     set color to GR+/W
       @ 12, 20 say    "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
       @ 13, 20 say    "³Recepcao Inicial:         ³"
       @ 14, 20 say    "³           Final:         ³"
       @ 15, 20 say    "³      Fornecedor:         ³"
       @ 16, 20 say    "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
  SetColor(_COREDICAO_)
     @ 13, 39 get     M_RECINI
     @ 14, 39 get     M_RECFIN
     @ 15, 39 get     M_RECFOR picture "#####"
     read

     if lastkey() = 27
       exit
     endif

     M_RECINI = iif(dtoc(M_RECINI) = "  /  /  ",ctod("01/01/80"),M_RECINI)
     M_RECFIN = iif(dtoc(M_RECFIN) = "  /  /  ",ctod("31/12/79"),M_RECFIN) 

    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"ANFE00","ANFE00"})
    aadd(sqlCAMPO,"ANFE00.*")
    aadd(sqlCAMPO,"AFOR00.FORNOM")
    aadd(sqlCAMPO,"AFOR00.FOREST")
    aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","ANFE00.NFEFOR"})
    aadd(sqlCHAVE,"ANFE00.NFEDTR BETWEEN " + aspas(formatdta(M_RECINI)) + " and " + aspas(formatdta(M_RECFIN)))
    aadd(sqlCHAVE,"ANFE00.NFEEMP = " + str(ME_EMP,2))
    aadd(sqlORDEM,"ANFE00.NFEDTR,ANFE00.NFENUM")

	  if M_RECFOR > 0
      aadd(sqlCHAVE,"ANFE00.NFEFOR = " + str(M_RECFOR,5))
	  endif

    if !sqlrelation()
       msg("* * * NADA A LISTAR NO INTERVALO * * *")
       loop
     endif

     M_ARQI  = substr(time(),4,2) + substr(time(),7,2) + ".RPT"
     M_IMPRE = impresn()

     if M_IMPRE = "N"
       loop
     endif

     if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
       ?? chr(15)                        && comprime
     endif

     store 0 to PG ,;
		LN ,;
		M_TOTVLN

     select ANFE00

  do while !eof()

	store PG + 1 to  PG 

	if PG > 1
    ?
	  eject
	endif

	? cent_cab(AEMP00->EMPFAN,"NOTAS FISCAIS DE ENTRADA SINTETICA","EAGRO17",132) 
	? cent_cab(M_DATA,"PEDIODO: " + dtoc(M_RECINI) + " A " + dtoc(M_RECFIN),"PAG.: " + str(PG, 4),132) 
	? "*------*--*-----*------------------------------------*--------*--------*--*----------*----------*----------*----------*------------*"
	? "*  NF  *SR*FORN * FORNECEDOR                         *  DTE   *  DTR   *UF* VLR ICMS * VLR IPI  *DSP TRIB  * DSP N TRI*   VLR NOTA *"
	? "*------*--*-----*------------------------------------*--------*--------*--*----------*----------*----------*----------*------------*"
*           999999 XX 99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99 XX ########## ########## ########## ########## ############

	store 5 to LN
  
	do while !eof() .and. LN < 60

	  ? " "
	    ?? str(NFENUM, 6, 0)
	    ?? " "
	    ?? NFESER 
	    ?? " "
	    ?? str(NFEFOR, 7, 0) 
	    ?? " "
	    ?? pad(FORNOM, 34)
	    ?? " "
	    ?? NFEDTE
	    ?? " "
	    ?? NFEDTR
	    ?? " "
	    ?? FOREST
	    ?? " " 
	    ?? transform(NFEVIC,"@E ###,###.##")
	    ?? " "
	    ?? transform(NFEVIP,"@E ###,###.##")
	    ?? " "
	    ?? transform(NFEDST,"@E ###,###.##")
	    ?? " "
	    ?? transform(NFEDSN,"@E ###,###.##")
	    ?? " "
	    ?? transform(NFEVLN,"@E #,###,###.##")

	    LN = LN + 1

	    M_TOTVLN = M_TOTVLN + NFEVLN
			       
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

    ? space(96)
      ?? "TOTAL DAS NOTAS ... "
      ?? transform(M_TOTVLN,"@E ####,###,###.##")

*    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
*      ?? chr(18)                        && descomprime
*    endif
    ?
    ?
    
    set print off
    set printer to
    set console on 
    set cursor on 
    set relation to

    desliga1()

  enddo
	
return ""

****************
function CAB_NFE
****************

  store PG + 1 to PG

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE NOTAS DE ENTRADA","EAGRO17",132) 
  ? cent_cab(M_DATA,"PERIODO: " + dtoc(M_RECINI) + " A " + dtoc(M_RECFIN),"PAG.: " + str(PG, 4, 0), 132)

  store 2 to LN

return ""

*************** 
function OUTNFE                         && funcao de implementacao  
*************** 

private M_OPC    ,;
	M_TELA

_FUNCLI_ = "NFE.t."
_FUNPRO_ = "NFE.f."
_FUNVEN_ = "NFE.f."
_FUNCPG_ = "NFE.f."
_FUNTRA_ = "NFE.f."

  do while .t.

    keyfun()

    store ctod("  /  /  ") to M_PERINI,;
				  M_PERFIN
    store 0                to M_NFEFOR

    rodape("ATUALIZA", "NFE", M_FAN, "EAGRO17", "Mem: " + str(memory(0), 5), M_EMP)


    nbox(09, 14, 14, 40,"W/W+",.t.)
    setcolor("B/W")
      @ 10, 14 say               " Recebidas Entre:          "
      @ 11, 14 say               "             Ate:          "
      @ 12, 14 say               "      Fornecedor:          "
  SetColor(_COREDICAO_)
      @ 10, 32 get     M_PERINI
      @ 11, 32 get     M_PERFIN 
      @ 12, 32 get     M_NFEFOR picture "#######"  
      read
    set color to 

    if lastkey() = 27
      exit
    endif

    M_PERINI = iif(empty(M_PERINI),ctod("01/01/80"),M_PERINI)
    M_PERFIN = iif(empty(M_PERFIN),ctod("31/12/79"),M_PERFIN)

    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"ANFE00","ANFE00"})
    aadd(sqlCAMPO,"ANFE00.*")
    aadd(sqlCAMPO,"AFOR00.FORNOM")
    aadd(sqlCAMPO,"AFOR00.FOREST")
    aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","ANFE00.NFEFOR"})
    aadd(sqlCHAVE,"ANFE00.NFEDTR BETWEEN " + aspas(formatdta(M_PERINI)) + " and " + aspas(formatdta(M_PERFIN)))
    aadd(sqlCHAVE,"ANFE00.NFEEMP = " + str(ME_EMP,2))
    aadd(sqlCHAVE,"ANFE00.NFEIPL <> 'I'")

    aadd(sqlORDEM,"ANFE00.NFEDTR,ANFE00.NFENUM")

	  if M_NFEFOR > 0
      aadd(sqlCHAVE,"ANFE00.NFEFOR = " + str(M_NFEFOR,5))
	  endif

    if !sqlrelation()
      msg("* * * NADA A IMPLEMENTAR NO INTERVALO * * *")
      loop
    endif

    M_OPC = msgbox2("Tudo Ok!!! ... Para Implementa‡„o")

    if M_OPC != 1
      loop
    endif

    do while !eof()

      msw("* * * PROCESSANDO: " + str(NFENUM, 6, 0) + " " + NFESER + " " + str(NFEFOR, 7, 0) + " Emissao: " + dtoc(NFEDTE) + " Recepcao: " + dtoc(NFEDTR) + " * * *")

      if (NFEDP1 + NFEDP2 + NFEDP3 + NFEDP4 + NFEDP5 + NFEDP6) > 0
      	gra_dupdia()                 && cria duplicatas do dia
      endif 

      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {}
      sqlORDEM = {}
      aadd(sqlARQUI,{"ANFE01","ANFE01"})
      aadd(sqlCAMPO,"ANFE01.*")
      aadd(sqlCHAVE,"NFEEMP = " + str(ANFE00->NFEEMP, 2))
      aadd(sqlCHAVE,"NFENUM = " + str(ANFE00->NFENUM, 9))
      aadd(sqlCHAVE,"NFESER = " + aspas(ANFE00->NFESER))
      aadd(sqlCHAVE,"NFEFOR = " + str(ANFE00->NFEFOR, 5))
      sqlrelation()

      do while !eof()

        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {"ASLD00","UPDATE"}
        aadd(sqlCHAVE,{"SLDEMP",str(ANFE01->NFEEMP,2)})
        aadd(sqlCHAVE,{"SLDMAT",str(ANFE01->NFEMAT,6)})
        aadd(sqlCAMPO,{"SLDDTE",formatdta(ANFE00->NFEDTR),.t.})
        aadd(sqlCAMPO,{"SLDCPA",str1((ANFE01->NFELIQ / ANFE01->NFEQDE),2),.f.})
        M_SLDCUS = ((ANFE01->NFELIQ + ANFE01->NFEDST + ANFE01->NFEDSN + ANFE01->NFEFRE + ANFE01->NFEVIP + ANFE01->NFESUB) / ANFE01->NFEQDE)
        aadd(sqlCAMPO,{"SLDCUS",str1(M_SLDCUS,2),.f.})
        executasql()

        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {"AKAR00","INSERT"}
        aadd(sqlCAMPO,{"KAREMP",str(ANFE01->NFEEMP,2),.t.})
        aadd(sqlCAMPO,{"KARMAT",str(ANFE01->NFEMAT,6),.t.})
        aadd(sqlCAMPO,{"KARDOC",str(ANFE01->NFENUM,9),.t.})
        aadd(sqlCAMPO,{"KARSER",ANFE01->NFESER,.t.})
        aadd(sqlCAMPO,{"KARDTA",formatdta(ANFE01->NFEDTR),.t.})
        aadd(sqlCAMPO,{"KARFISN",ANFE00->NFENATN,.t.})
        aadd(sqlCAMPO,{"KARSEQ",str(ANFE01->NFESEQ,3),.t.})
        aadd(sqlCAMPO,{"KARQDE",str1(ANFE01->NFEQDE,3),.t.})
        aadd(sqlCAMPO,{"KARPRB",str1(ANFE01->NFEPUN,2),.t.})
        aadd(sqlCAMPO,{"KARVLI",str1(ANFE01->NFEVLI,2),.t.})
        aadd(sqlCAMPO,{"KARLIQ",str1(ANFE01->NFEVLI,2),.t.})
        aadd(sqlCAMPO,{"KARICM",str1(ANFE01->NFEVIC,2),.t.})
        aadd(sqlCAMPO,{"KARIPI",str1(ANFE01->NFEVIP,2),.t.})
        aadd(sqlCAMPO,{"KARCLF",str(ANFE00->NFEFOR,5),.t.})
        aadd(sqlCAMPO,{"KARDSP",str1((ANFE01->NFEDST + ANFE01->NFEDSN + ANFE01->NFEFRE),2),.t.})
        aadd(sqlCAMPO,{"KAROBS",ANFE00->NFEOBS,.t.})
*       aadd(sqlCAMPO,{"KARQDEDC",str1(ANFE01->NFEQDE*xx_FISEST,3),.t.})
        executasql()

        select ANFE01
        skip

      enddo

     /*

      do while !eof()

      	select ASLD00           && seleciona saldo para atualizacao
      	seek str(ANFE01->NFEEMP, 2, 0) + str(ANFE01->NFEMAT, 6, 0)

        APCA00->(dbseek(str(ANFE01->NFEMAT, 6, 0)))

      	if !eof()
      	  do while .t.
      	    if rlock()
      	      if AFIS00->FISEST = "C"
                replace SLDDIS with ( SLDDIS + ANFE01->NFEQDE )
                replace SLDQTE with ( SLDQTE + ANFE01->NFEQDE )
            		replace SLDDTE with ANFE00->NFEDTR
            		replace SLDCPA with (ANFE01->NFELIQ / ANFE01->NFEQDE)
                if !left(str(AFIS00->FISCOD, 5),3) $ "#199#299#132#232"
                  replace SLDCUS with ((ANFE01->NFELIQ + ANFE01->NFEDST + ANFE01->NFEDSN + ANFE01->NFEFRE + ANFE01->NFEVIP + ANFE01->NFESUB) / ANFE01->NFEQDE) 
                  if M_ALTPRC == "S"
                    replace SLDPRC with SLDCUS + ((SLDCUS * .01) * SLDMAR)
                  endif
                endif
      	      else
		            if AFIS00->FISEST = "D"
                  replace SLDDIS with ( SLDDIS - ANFE01->NFEQDE )
                  replace SLDQTS with ( SLDQTE + ANFE01->NFEQDE )
            		  replace SLDDTS with ANFE00->NFEDTR
            		endif
      	      endif
      	      unlock
      	      exit
      	    else
      	      msg("* * * (ASLD00) REGISTRO SENDO USADO * * *")
      	    endif
      	    if lastkey()=17
      	      exit
      	    endif
      	  enddo
      	else
      	  _append("ASLD00")
      	  do while .t.
      	    if rlock()
      	      replace SLDEMP with ANFE01->NFEEMP
      	      replace SLDMAT with ANFE01->NFEMAT
      	      if AFIS00->FISEST = "C"
                replace SLDDIS with ( SLDDIS + ANFE01->NFEQDE )
                replace SLDQTE with ( SLDQTE + ANFE01->NFEQDE )
            		replace SLDDTE with ANFE00->NFEDTR
            		replace SLDCPA with (ANFE01->NFEVLI / ANFE01->NFEQDE)
                if !left(str(AFIS00->FISCOD, 5),3) $ "#199#299#132#232"
                  replace SLDCUS with ((ANFE01->NFELIQ  + ANFE01->NFEDST + ANFE01->NFEDSN + ANFE01->NFEFRE + ANFE01->NFEVIP + ANFE01->NFESUB) / ANFE01->NFEQDE) 
                  if M_ALTPRC == "S"
                    replace SLDPRC with SLDCUS + ((SLDCUS * .01) * SLDMAR)
                  endif
                endif
      	      else
            		if AFIS00->FISEST = "D"
                  replace SLDDIS with ( SLDDIS - ANFE01->NFEQDE )
                  replace SLDQTS with ( SLDQTE + ANFE01->NFEQDE )
            	    replace SLDDTS with ANFE00->NFEDTR
            		endif
      	      endif
      	      unlock
      	      exit
      	    else
      	      msg("* * * (ASLD00) REGISTRO SENDO USADO * * *")
      	    endif
      	    if lastkey()=17
      	      exit
      	    endif
      	  enddo
      	endif

      	select AKAR00        && seleciona saldo para geracao do movimento

        if !dbseek(str(ANFE01->NFEEMP, 2, 0) + str(ANFE01->NFEMAT, 6, 0) + dtos(ANFE00->NFEDTR) + ANFE00->NFENATN + str(ANFE01->NFENUM, 6, 0) + ANFE00->NFESER + str(ANFE01->NFESEQ, 3, 0))
          _append("AKAR00")
        endif

      	do while .t.
      	  if rlock()
            replace KAREMP       with ANFE01->NFEEMP
            replace KARMAT       with ANFE01->NFEMAT
            replace KARDTA       with ANFE00->NFEDTR
            replace KARFISN      with ANFE00->NFENATN
            replace KARDOC       with ANFE01->NFENUM
            replace KARSER       with ANFE01->NFESER
            replace KARSEQ       with ANFE01->NFESEQ
            replace KARQDE       with ANFE01->NFEQDE
            replace KARPRB       with ANFE01->NFEPUN
            replace KARVLI       with ANFE01->NFEVLI
            replace KARLIQ       with ANFE01->NFEVLI
            replace KARICM       with ANFE01->NFEVIC 
            replace KARIPI       with ANFE01->NFEVIP
            replace KARCLF       with ANFE00->NFEFOR
            replace KARDSP       with ANFE01->NFEFRE + ANFE01->NFEDST + ANFE01->NFEDSN
            replace KAROBS       with ANFE01->NFEOBS
      	    unlock
      	    exit
      	  else
      	    msw("* * * (AKAR00) REGISTRO SENDO USADO * * *")
      	  endif
      	  if lastkey()=27
      	    exit
      	  endif
      	enddo

      	select ANFE01

        atusaldo(NFEMAT)

        select ANFE01

      	skip

      enddo

      */

      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {"ANFE00","UPDATE"}
      aadd(sqlCHAVE,{"NFEEMP",str(ANFE00->NFEEMP, 2)})
      aadd(sqlCHAVE,{"NFENUM",str(ANFE00->NFENUM, 9)})
      aadd(sqlCHAVE,{"NFESER",aspas(ANFE00->NFESER)})
      aadd(sqlCHAVE,{"NFEFOR",str(ANFE00->NFEFOR, 5)})
      aadd(sqlCAMPO,{"NFEIPL","I",.t.})
      executasql()

      select ANFE00

      skip

    enddo

    msg("* * * FIM DA IMPLEMENTA€ŽO * * *")
    exit

  enddo

_FUNCLI_ = "NFE.t."
_FUNPRO_ = "NFE.t."
_FUNVEN_ = "NFE.t."
_FUNCPG_ = "NFE.t."
_FUNTRA_ = "NFE.f."

set key -1 to

return ""


******************* 
function GRA_DUPDIA 
*******************

*/*/*/

  seexistesql("ADCPID")
  cSql := "select first 1 gen_id(gen_ADCP00_"  + strzero(ME_EMP,2) + ",1) from rdb$database"  // AQUI NAO ALTERAMOS A SEQUENCIA
  dbusearea(.t.,"SQLMIX",cSql,"ADCPID")                         // PEGAMOS O ULTIMO E ACRESCENTAMOS 1
  M_EMPDCP = GEN_ID
  select ADCPID
  use

  do while .t.
    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"ADCP00","ADCP00"})
    aadd(sqlCAMPO,"DUPNUM")
    aadd(sqlCHAVE,"DUPNUM = " + str(M_EMPDCP,9))
    aadd(sqlCHAVE,"DUPEMP = " + str(ME_EMP,2))

    sqlrelation()

    if !EOF()
      cSql := "select first 1 gen_id(gen_ADCP00_"  + strzero(ME_EMP,2) + ",1) from rdb$database"  // AQUI NAO ALTERAMOS A SEQUENCIA
      dbusearea(.t.,"SQLMIX",cSql,"ADCPID")
      M_ID = GEN_ID
      select ADCPID
      use
      M_EMPDCP = M_ID
      loop
    endif
    exit
  enddo

  BUSCAREGISTRO("ACPG00",1,{str(ANFE00->NFECPG,3,0)},"SELECT")

  if ANFE00->NFEDP1 > 0 .and. ANFE00->NFEDP2 = 0
    cria_dupdia( 0, ANFE00->NFEVC1, ANFE00->NFEDP1) 
  else
     for A = 1 to 6
       MS = str(A,1)
       if ANFE00->NFEDP&MS > 0
         cria_dupdia( A, ANFE00->NFEVC&MS, ANFE00->NFEDP&MS) 
       endif 
     next
   endif

return ""

******************** 
function CRIA_DUPDIA
******************** 

  parameters F_ORD,F_VCT,F_VLD 

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"ADCP00","INSERT"}
  aadd(sqlCAMPO,{"DUPEMP",str(ANFE00->NFEEMP,2),.t.})
  aadd(sqlCAMPO,{"DUPNUM",str(M_EMPDCP,9),.t.})
  aadd(sqlCAMPO,{"DUPORD",str(F_ORD,2),.t.})
  aadd(sqlCAMPO,{"DUPFOR",str(ANFE00->NFEFOR,5),.t.})
  aadd(sqlCAMPO,{"DUPNOM",ANFE00->FORNOM,.t.})
  aadd(sqlCAMPO,{"DUPDTE",formatdta(ANFE00->NFEDTE),.t.})
  aadd(sqlCAMPO,{"DUPVCT",formatdta(F_VCT),.t.})
  aadd(sqlCAMPO,{"DUPPOR",str(1,5),.t.})
  aadd(sqlCAMPO,{"DUPVEN",str(1,3),.t.})
  aadd(sqlCAMPO,{"DUPNFS",str1(ANFE00->NFEVLN,2),.t.})
  aadd(sqlCAMPO,{"DUPVLO",str1(F_VLD,2),.t.})
  aadd(sqlCAMPO,{"DUPVLA",str1(F_VLD,2),.t.})
  aadd(sqlCAMPO,{"DUPCPG",str(ANFE00->NFECPG,3),.t.})
  aadd(sqlCAMPO,{"DUPFISN",ANFE00->NFENATN,.t.})
  aadd(sqlCAMPO,{"DUPSER",ANFE00->NFESER,.t.})
  aadd(sqlCAMPO,{"DUPOBS","NF " + str(ANFE00->NFENUM, 9, 0),.t.})
  aadd(sqlCAMPO,{"DUPHIS",str(500,3),.t.})
  aadd(sqlCAMPO,{"NFENUM",str(ANFE00->NFENUM,9),.t.})
  aadd(sqlCAMPO,{"NFESER",ANFE00->NFESER,.t.})
  executasql()

return ""

****************** 
function  VERNFE01(F_TIPO)
******************

if F_TIPO
  if M_NFENUM = 0
    return .f.
  endif
else
  if M_NFENUM = 0
    return .f.
  endif
endif

return .t.

****************** 
function  VERNFE02
******************

  if lastkey() = 5
    return .t.
  endif

*  if empty(M_NFESER)
*    msg("* * * A SERIE NAO PODE ESTAR VAZIA * * *")
*    keyfun()
*    return .f.
*  endif

return .t.

****************** 
function  VERNFE03
******************

if lastkey() = 5
  return .t.
endif

if M_NFEFOR = 0
 sele_arquivo("AFOR00")
 M_NFEFOR = FORCOD
 return .f.
endif

if !BUSCAREGISTRO("AFOR00",1,{str(M_NFEFOR,5,0)},"SELECT")
  msg("* * * FORNECEDOR NAO CADASTRADO * * *")
  keyfun()
  M_NFEFOR = 0
  return .f.
endif

msw("* * * " + alltrim(FORNOM) + " * * *")

return .t.

******************
function  VERNFE04
******************

  if lastkey() = 5
    return .t.
  endif

  if empty(M_NFEDTE)
    return .f.
  endif

return .t.


****************** 
function  VERNFE05
******************

  if lastkey() = 5
    return .t.
  endif

  if empty(M_NFEDTR)
    return .f.
  endif

return .t.

****************** 
function  VERNFE06(F_TIPO)
******************

if !ver_afis00(@M_NFENATN)
  return .f.
endif

return .t.

****************** 
function  VERNFE07
******************

  if lastkey() = 5
    return .t.
  endif

  if M_NFECPG = 0
    return .f.
  endif

  if M_NFECPG < 499
    msg("* * * CONDICAO DE COMPRA DEVE SER MAIOR QUE 500 * * *")
    M_NFECPG = 0
    keyfun()
    return .f.
  endif

  if !BUSCAREGISTRO("ACPG00",1,{str(M_NFECPG,3,0)},"SELECT")
    msg("* * * CONDICAO DE PAGTO NAO CADASTRADA * * *")
    M_NFECPG = 0
    return .f.
  endif

  msg("* * * " + alltrim(CPGDES) + " * * *")

  keyfun()

return .t.

****************** 
function  VERNFE08
******************

  if lastkey() = 5
    return .t.
  endif

  if !M_NFEPSN $ "SN"
    msg("* * * GERA CONTAS A PAGAR (S)im (N)ao * * *")
    keyfun()
    return .f.
  endif

return .t.

******************
function  VERNFE10
******************

  if lastkey() = 5
    return .t.
  endif

  if !M_NFESIT $ " L"
    msg("* * * STATUS DE DIVERGENCIA DE NOTA FISCAL DE ENTRADA * * *")
    keyfun()
    return .f.
  endif

return .t.

****************** 
function  VERNFE11
******************

  if lastkey() = 5
    return .t.
  endif

  if !M_NFEIPL $ " I"
    msg("* * * STATUS DE IMPLEMENTACAO DE NOTA FISCAL DE ENTRADA * * *")
    keyfun()
    return .f.
  endif

return .t.

****************** 
function  VERNFE12
******************

  if lastkey() = 5
    return .t.
  endif

  if M_NFEITE = 0
    return .f.
  endif

return .t.


****************** 
function  VERNFE13
******************

  if lastkey() = 5
    return .t.
  endif

return .t.

****************** 
function  VERNFE14
******************

  if lastkey() = 5
    return .t.
  endif

return .t.

****************** 
function  VERNFE15
******************

  if lastkey() = 5
    return .t.
  endif

return .t.

****************** 
function  VERNFE16
******************

  if lastkey() = 5
    return .t.
  endif

  if M_NFEFRE > 0
  endif

return .t.

****************** 
function  VERNFE17
******************

  if lastkey() = 5
    return .t.
  endif

return .t.

****************** 
function  VERNFE18
******************

  if lastkey() = 5
    return .t.
  endif

  if M_NFEBIC > 0  
    if M_NFEVIC = 0
      return .f.
    endif
  endif

return .t.

****************** 
function  VERNFE19
******************

  if lastkey() = 5
    return .t.
  endif

  if M_NFEVLM = 0
    return .f.
  endif

return .t.

****************** 
function  VERNFE20
******************

  if lastkey() = 5
    return .t.
  endif

return .t.

****************** 
function  VERNFE21
******************

  if lastkey() = 5
    return .t.
  endif

  if M_NFEVLN = 0
    return .f.
  endif

return .t.

****************** 
function  VERNFE22
******************

  if lastkey() = 5
    return .t.
  endif

  if M_NFEMAT[SQ, 6] = 0 && MAT
    return .f.
  endif

  if !BUSCAREGISTRO("APCA00",1,{str(M_NFEMAT[SQ, 6],6,0)},"SELECT")
    msg("* * * PRODUTO NAO CADASTRADO * * *")
    M_NFEMAT[SQ, 6] = 0
    keyfun()
    return .f.
  endif

  wvt_DrawLabel(21+nLinNfe,3,APCA00->PCADES,,, RGB( 255, 255,255 )  ,RGB(0,0,0) , "Visualnova", _FONTET_*.8,_FONTEL_*.7 , , , , .f., .f. ,.f.)

  keyfun()

return .t.

****************** 
function  VERNFE23
******************

  if lastkey() = 5
    return .t.
  endif

  if M_NFEMAT[SQ, 7] = 0 && QDE
    return .f.
  endif

return .t.

****************** 
function  VERNFE24(TIPO)
******************

  if lastkey() = 5
    return .t.
  endif

  if M_NFEMAT[SQ][8] = 0 && PUN
    return .f.
  endif

  if !lAltite // se alterando item nao calcula
    M_NFEMAT[SQ][9] = round(M_NFEMAT[SQ][8] * M_NFEMAT[SQ][7], 2) && VLI = PUN * QDE
  
    if M_NFEMAT[SQ][23] = 0 .or. lAlteranfe  // se alterando
      if M_NFEDSC = 0
        M_NFEMAT[SQ][23] = M_NFEMAT[SQ][9]
      else
        M_NFEMAT[SQ][23] = M_NFEMAT[SQ][9] - round(((M_NFEDSC/M_NFEVLM)*M_NFEMAT[SQ][9]),2)
      endif
    endif
  endif

return .t.

****************** 
function  VERNFE25
******************

  if lastkey() = 5
    return .t.
  endif

  if M_NFEMAT[SQ, 9] = 0 && VLI
    return .f.
  endif

return .t.

****************** 
function  VERNFE26
******************

  if lastkey() = 5
    return .t.
  endif

  if !lAltite // se alterando item nao calcula
    if M_NFEVIP > 0 .and. M_NFEMAT[SQ][11] = 0
      M_NFEMAT[SQ][11] = round(((M_NFEMAT[SQ][9]/100)*M_NFEMAT[SQ][10]),2)
    endif
  endif

return .t.

****************** 
function  VERNFE27
******************

  if lastkey() = 5
    return .t.
  endif

  if M_NFEMAT[SQ, 10] > 0 && PIP
    if M_NFEMAT[SQ, 11] = 0 && VIP
      msg("* * * VALOR DO IPI NAO DEVE SER ZEROS * * *")
      keyfun()
      return .f.
    endif
  endif

return .t.

******************
function  VERNFE28
******************

local M_CODIGO
LOCAL clr
LOCAL aBlocks := {}
LOCAL aLastPaint4
LOCAL cScr0   := SaveScreen(  LN+nLinNfe-1,30-1-12,LN+nLinNfe+3+1,70+1-10 )
LOCAL cScr1   := wvt_SaveScreen(  LN+nLinNfe-1,30-1-12,LN+nLinNfe+3+1,70+1-10 )

private PosAcho

  if lastkey() = 5
    return .t.
  endif

  M_TIPOS = { }

  aadd(M_TIPOS," 2 - ICMS Sem Credito Isento/Nao Tributado")
  aadd(M_TIPOS," 4 - ICMS Sem Credito Outros              ")
  aadd(M_TIPOS," 5 - ICMS Com Credito de Imposto Tributado")

  PosAcho = 1


  *M_NFEMAT[SQ,12]

  for A = 1 to len(M_TIPOS)
    if str(val(left(M_TIPOS[A],3)),2) == str(M_NFEMAT[SQ, 12],2)
      PosAcho = A
      exit
    endif
  next

  scr := SaveScreen( LN+nLinNfe-1,30-1-12,LN+nLinNfe+3+1,70+1-10 )
  clr := SetColor( 'N/W*,GR+/B*,,,GR+/B' )

  Wvt_DrawBoxRaised(LN+nLinNfe,30-12,LN+nLinNfe+2,70-10 )
  aLastPaint4 := WvtSetBlocks( aBlocks )

  TIPO1 = achoice(LN+nLinNfe,30-12,LN+nLinNfe+2,70-10,M_TIPOS,,,PosAcho)
  setcolor("")

  setColor( clr )

  RestScreen(  LN+nLinNfe-1,30-1-12,LN+nLinNfe+3+1,70+1-10,cScr0 )
  wvt_RestScreen(  LN+nLinNfe-1,30-1-12,LN+nLinNfe+3+1,70+1-10,cScr1 )

  WvtSetBlocks( aLastPaint4 )

  M_NFEMAT[SQ, 12] = val(left(M_TIPOS[TIPO1],3))

return .t.


****************
function  VERMOD
****************

LOCAL scr,clr
LOCAL aBlocks := {}
LOCAL aLastPaint4

if lastkey() = 5
  return .t.
endif

set cursor off

M_TIPOS = { }
aadd(M_TIPOS," 1 - Nota Fiscal Manual                 ")
aadd(M_TIPOS," 4 - Nota Fiscal de Produtor            ")
aadd(M_TIPOS," 6 - Nota Fiscal/Conta de Energia       ")
aadd(M_TIPOS," 8 - Conhecimento Transposte            ")
aadd(M_TIPOS,"21 - Nota Fiscal Servico Comunicacao    ")
aadd(M_TIPOS,"22 - Nota Fiscal Servico Telecomunicacao")
aadd(M_TIPOS,"55 - Nota Fiscal Eletronica             ")
aadd(M_TIPOS,"57 - Conhecimento Transporte Eletronico ")

PosAcho = 1

for A = 1 to len(M_TIPOS)
  if str(VAL(left(M_TIPOS[A],2)),2) == str(M_NFEMOD,2)
    PosAcho = A
    exit
  endif
next

scr := SaveScreen( 04+nLinNfe-1,17-1,11+nLinNfe+2,57+2 )
clr := SetColor( 'N/W*,GR+/B*,,,GR+/B' )

Wvt_DrawBoxRaised( 04+nLinNfe,17,11+nLinNfe,57 )
aLastPaint4 := WvtSetBlocks( aBlocks )

TIPO1 = achoice(04+nLinNfe,17,11+nLinNfe,57,M_TIPOS,,,PosAcho)

WvtSetBlocks( aLastPaint4 )

setColor( clr )

RestScreen(04+nLinNfe-1,17-1,11+nLinNfe+2,57+2,Scr )

M_NFEMOD = VAL(left(M_TIPOS[TIPO1],2))

set cursor on

return .t.

****************** 
function  VERNFE29
******************

M_NFEMAT[SQ, 13] = 1
return .t.


****************** 
function  VERNFE30
******************

  if lastkey() = 5
    return .t.
  endif

  if M_NFEMAT[SQ, 12] = 5 && ESC
    if M_NFEMAT[SQ, 16] = 0
      msg("* * * PERCENTUAL DO ICMS NO PRODUTO NAO PODE SER ZEROS * * *")
      keyfun()
      return .f.
    endif 
  endif

  if M_NFEMAT[SQ, 12] != 5 && ESC
    if M_NFEMAT[SQ, 16] > 0 && PIC
      msg("* * * PERCENTUAL DO ICMS NO PRODUTO NAO PODE MAIOR QUE ZEROS * * *")
      keyfun()
      return .f.
    endif 
  endif

*  M_NFEMAT[SQ, 11] = round((M_NFEMAT[SQ, 9] * .01) * M_NFEMAT[SQ, 10], 2) && VIP = (VLI * .01) * PIP

return .t.

****************** 
function  VERNFE31
******************

  if lastkey() = 5
    return .t.
  endif

  if M_NFEMAT[SQ, 12] != 5 && ESC
    if M_NFEMAT[SQ, 15] > 0 && RED
      msg("* * * PERCENTUAL DE REDUCAO DO ICMS NAO PODE SER MAIOR QUE ZEROS * * *")
      keyfun()
      return .f.
    endif
  endif

return .t.

*****************
function  TLNFE01
*****************

nbox(01+nLinnfe, 01, 20+nLinnfe, 77,"W/W+",.t.)
setcolor("B/W")
  @  02+nLinnfe, 02 say     " Chave:                                                 NFE Complemento:   "
  @  03+nLinnfe, 02 say     "     Modelo:                         Icms Sub:              Fre:           "
  @  04+nLinnfe, 02 say     " Numero NFE:           Nat:          Qt Total:              Bic:           "
  @  05+nLinnfe, 02 say     " Serie  NFE:           Cpg:          Dsp Trib:              Vic:           "
  @  06+nLinnfe, 02 say     " Fornecedor:           Pag:          N„o Trib:              Vlm:           "
  @  07+nLinnfe, 02 say     " Emissao   :           Sit:          Desconto:              Vip:           "
  @  08+nLinnfe, 02 say     " Recepcao  :           Ipl:                                 Vln:           "
  @  09+nLinnfe, 02 say     "                                                                           "
  @  10+nLinnfe, 02 say     "Sq  Codigo   Qtde     Unitario     Total   % Ipi   R$ Ipi   E X % Icm % Red"
  @  11+nLinnfe, 02 say     "                                                                           "
  @  12+nLinnfe, 02 say     "                                                                           "
  @  13+nLinnfe, 02 say     "                                                                           "
  @  14+nLinnfe, 02 say     "                                                                           "
  @  15+nLinnfe, 02 say     "                                                                           "
  @  16+nLinnfe, 02 say     "                                                                           "
  @  17+nLinnfe, 02 say     "                                                                           "
  @  18+nLinnfe, 02 say     "                                                                           "
  @  19+nLinnfe, 02 say     "                                                                           "
set color to

return ""

****************
function EDNFE01
****************

  SetColor(_COREDICAO_)
  @ 02+nLinnfe, 10 get     M_NFSID
  @ 02+nLinnfe, 75 get     M_NFECOMP picture "@!" valid M_NFECOMP $ "SN"

  @ 03+nLinnfe, 15 get     M_NFEMOD picture "99" valid vermod()
  @ 07+nLinnfe, 15 get     M_NFEDTE                        valid vernfe04()
  @ 08+nLinnfe, 15 get     M_NFEDTR                        valid vernfe05()

  @ 04+nLinnfe, 30 get     M_NFENATN  picture "@E 9.999" F2 color _CORF2_  valid ver_afis00(@M_NFENATN) funcao "sele_arquivo('AFIS00')" retorno @M_NFENATN

  @ 05+nLinnfe, 30 get     M_NFECPG   picture "###" F2 color _CORF2_ valid vernfe07() funcao "sele_arquivo('ACPG00')" retorno @M_NFECPG
  @ 06+nLinnfe, 30 get     M_NFEPSN   picture "@!"         valid vernfe08()
  @ 07+nLinnfe, 30 get     M_NFESIT   picture "@"          valid vernfe10()
  @ 08+nLinnfe, 30 get     M_NFEIPL   picture "@"          valid vernfe11()

  @ 03+nLinnfe, 50 get     M_NFESUB   picture "@R 999,999.99"
  @ 04+nLinnfe, 50 get     M_NFEITE   picture "#####.####" valid vernfe12()
  @ 05+nLinnfe, 50 get     M_NFEDST   picture "#######.##" valid vernfe13()
  @ 06+nLinnfe, 50 get     M_NFEDSN   picture "#######.##" valid vernfe14()
  @ 07+nLinnfe, 50 get     M_NFEDSC   picture "#######.##" valid vernfe15()

  @ 03+nLinnfe, 67 get     M_NFEFRE   picture "#######.##" valid vernfe16()
  @ 04+nLinnfe, 67 get     M_NFEBIC   picture "#######.##" valid vernfe17()
  @ 05+nLinnfe, 67 get     M_NFEVIC   picture "#######.##" valid vernfe18()
  @ 06+nLinnfe, 67 get     M_NFEVLM   picture "#######.##" valid vernfe19()
  @ 07+nLinnfe, 67 get     M_NFEVIP   picture "#######.##" valid vernfe20()
  @ 08+nLinnfe, 67 get     M_NFEVLN   picture "#######.##" valid vernfe21()
  read

return ""

****************
function EDNFE02
****************

  parameters LN,SQ,SITUACAO

  set color to I
    @ LN+nLinnfe, 02 say M_NFEMAT[SQ,5] picture "###"
  set color to 

  SetColor(_COREDICAO_)
  @ LN+nLinnfe,  6 get M_NFEMAT[SQ, 6] picture "######"  F2 color _CORF2_ valid vernfe22() funcao "sele_arquivo('APCA00')" retorno @M_NFEMAT[SQ, 6]
  @ LN+nLinnfe, 13 get M_NFEMAT[SQ, 7] picture "#####.###"  valid vernfe23() && QDE
  @ LN+nLinnfe, 23 get M_NFEMAT[SQ, 8] picture "@R@S10 ######.####" valid vernfe24(SITUACAO) && PUN
  @ LN+nLinnfe, 34 get M_NFEMAT[SQ, 9] picture "#######.##" valid vernfe25() && VLI
  @ LN+nLinnfe, 45 get M_NFEMAT[SQ,10] picture "##.##"      valid vernfe26() && PIP
  @ LN+nLinnfe, 51 get M_NFEMAT[SQ,11] picture "#######.##" valid vernfe27() && VIP
  @ LN+nLinnfe, 62 get M_NFEMAT[SQ,12] picture "#"          valid vernfe28() && ESC
  @ LN+nLinnfe, 64 get M_NFEMAT[SQ,13] picture "#"          valid vernfe29() && EXE
  @ LN+nLinnfe, 66 get M_NFEMAT[SQ,16] picture "##.##"      valid vernfe30() && PIC
  @ LN+nLinnfe, 72 get M_NFEMAT[SQ,15] picture "##.##"      valid vernfe31() && RED
  read

  if lastkey() = 27
    return ""
  endif
  
  base_nfeit()     && calcula base de calculo
  
  ednfe03()      && edita base de calculo

return ""

****************
function EDNFE03
****************

LOCAL bBlock, aLastPaint
LOCAL aBlocks := {}
LOCAL nCursor := setCursor( 0 )
LOCAL cScr    := SaveScreen( 0,0,maxrow(),maxcol() )
LOCAL aObjects:= WvtSetObjects( {} )
aAdd( aBlocks, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
aLastPaint := WvtSetBlocks( aBlocks )


  nbox(03+2, 19, 19+2, 58,"W/BG+",.t.)
  set color to W/BG+
  @ 04+2, 20 say     "Valor do IPI..............:           "
  @ 05+2, 20 say     "Despesa Tributada.........:           "
  @ 06+2, 20 say     "Despesa Nao Tributada.....:           "
  @ 07+2, 20 say     "Base Calculo Icms.........:           "
  @ 08+2, 20 say     "Valor Credito Icms........:           "
  @ 09+2, 20 say     "Valor Coluna Isentos......:           "
  @ 10+2, 20 say     "Valor Coluna Outros.......:           "
  @ 11+2, 20 say     "Valor Frete ..............:           "
  @ 12+2, 20 say     "Valor do desconto.........:           "
  @ 13+2, 20 say     "Valor do produto..........:           "
  @ 14+2, 20 say     "Valor do ICMS Substituicao:           "
  @ 15+2, 20 say     "Valor da Gia .............:           "
  @ 16+2, 20 say     "Outras desp. Acessorias...:           "
  @ 17+2, 20 say     "Classificao Fiscal C.F.O..:           "
  @ 18+2, 20 say     "CST.......................:           "

  do while .t.
    msw("* * * Digite (PgDn) para Sair * * *")
    SetColor(_COREDICAO_)

    @ 04+2, 48 get M_NFEMAT[SQ][11] picture "#######.##"
    @ 05+2, 48 get M_NFEMAT[SQ][21] picture "#######.##"
    @ 06+2, 48 get M_NFEMAT[SQ][20] picture "#######.##"
    @ 07+2, 48 get M_NFEMAT[SQ][14] picture "#######.##"
    @ 08+2, 48 get M_NFEMAT[SQ][17] picture "#######.##"
    @ 09+2, 48 get M_NFEMAT[SQ][18] picture "#######.##"
    @ 10+2, 48 get M_NFEMAT[SQ][19] picture "#######.##"
    @ 11+2, 48 get M_NFEMAT[SQ][22] picture "#######.##"
    @ 12+2, 48 get M_NFEMAT[SQ][24] picture "#######.##"
    @ 13+2, 48 get M_NFEMAT[SQ][23] picture "#######.##"
    @ 14+2, 48 get M_NFEMAT[SQ][25] picture "#######.##"
    @ 15+2, 48 get M_NFEMAT[SQ][26] picture "#######.##"
    @ 16+2, 48 get M_NFEMAT[SQ][29] picture "#######.##"
    @ 17+2, 48 get M_NFEMAT[SQ][27] picture "@!"
    @ 18+2, 48 get M_NFEMAT[SQ][30] picture "@!"
    read

    if lastkey() = 3 .or. lastkey() = 27
      exit
    endif

  enddo


  WvtSetBlocks( aLastPaint )
  WvtSetObjects( aObjects )
  RestScreen( 0, 0, maxrow(), maxcol(), cScr )

return ""

****************
function MSNFE01
****************

select ANFE00

set color to I
  @ 02+nLinnfe, 10 say     NFSID
  @ 02+nLinnfe, 75 say     NFECOMP
  @ 03+nLinnfe, 15 say     NFEMOD picture "99"
  @ 07+nLinnfe, 15 say     NFEDTE
  @ 08+nLinnfe, 15 say     NFEDTR

  @ 04+nLinnfe, 30 say     NFENAT * .01 picture "###.##"
  @ 05+nLinnfe, 30 say     NFECPG       picture "###"
  @ 06+nLinnfe, 30 say     NFEPSN       picture "@!"
  @ 07+nLinnfe, 30 say     NFESIT       picture "@"
  @ 08+nLinnfe, 30 say     NFEIPL       picture "@"

  @ 03+nLinnfe, 50 say     NFESUB      picture "@R 999,999.99"
  @ 04+nLinnfe, 50 say     NFEITE      picture "#####.####"
  @ 05+nLinnfe, 50 say     NFEDST      picture "#######.##"
  @ 06+nLinnfe, 50 say     NFEDSN      picture "#######.##"
  @ 07+nLinnfe, 50 say     NFEDSC      picture "#######.##"
  @ 08+nLinnfe, 50 say     NFEFRE      picture "#######.##"

  @ 04+nLinnfe, 67 say     NFEBIC     picture "#######.##"
  @ 05+nLinnfe, 67 say     NFEVIC     picture "#######.##"
  @ 06+nLinnfe, 67 say     NFEVLM     picture "#######.##"
  @ 07+nLinnfe, 67 say     NFEVIP     picture "#######.##"
  @ 08+nLinnfe, 67 say     NFEVLN     picture "#######.##"
set color to

return ""

****************
function MSNFE02
****************

parameters SQ,R

set color to I
  for S = SQ to len(M_NFEMAT)
    @ R+nLinnfe, 02 say M_NFEMAT[S,5] picture "###"
    @ R+nLinnfe,  6 say M_NFEMAT[S, 6] picture "######"
    @ R+nLinnfe, 13 say M_NFEMAT[S, 7] picture "#####.###"
    @ R+nLinnfe, 23 say M_NFEMAT[S, 8] picture "#######.##"
    @ R+nLinnfe, 34 say M_NFEMAT[S, 9] picture "#######.##"
    @ R+nLinnfe, 45 say M_NFEMAT[S,10] picture "##.##"
    @ R+nLinnfe, 51 say M_NFEMAT[S,11] picture "#######.##"
    @ R+nLinnfe, 62 say M_NFEMAT[S,12] picture "#"
    @ R+nLinnfe, 64 say M_NFEMAT[S,13] picture "#"
    @ R+nLinnfe, 66 say M_NFEMAT[S,16] picture "##.##"
    @ R+nLinnfe, 72 say M_NFEMAT[S,15] picture "##.##"
    R ++
    if R = 19+nLinnfe
      exit
    endif
  next
set color to

return ""

****************
function MSNFE03
****************

    M_NFEMAT = {}
    aEXCLUIK = { }

    grnfe01("SELECT")

    nSEQ = 1
    do while !eof()

      aadd(M_NFEMAT,{0,"  ", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0, 0,"    ","N",0,"  ",0,0,0,.f.})
      // 34 .t. ou .f. novo registro
      M_NFEMAT[NSEQ,  1] = NFEEMP
      M_NFEMAT[NSEQ,  2] = NFENUM
      M_NFEMAT[NSEQ,  3] = NFESER
      M_NFEMAT[NSEQ,  4] = NFEFOR
      M_NFEMAT[NSEQ,  5] = nSEQ
      M_NFEMAT[NSEQ,  6] = NFEMAT
      M_NFEMAT[NSEQ,  7] = NFEQDE
      M_NFEMAT[NSEQ,  8] = NFEPUN
      M_NFEMAT[NSEQ,  9] = NFEVLI
      M_NFEMAT[NSEQ, 10] = NFEPIP
      M_NFEMAT[NSEQ, 11] = NFEVIP
      M_NFEMAT[NSEQ, 12] = NFEESC
      M_NFEMAT[NSEQ, 13] = NFEEXE
      M_NFEMAT[NSEQ, 15] = NFERED
      M_NFEMAT[NSEQ, 14] = NFEBIC
      M_NFEMAT[NSEQ, 16] = NFEPIC
      M_NFEMAT[NSEQ, 17] = NFEVIC
      M_NFEMAT[NSEQ, 18] = NFEISE
      M_NFEMAT[NSEQ, 19] = NFEOUT
      M_NFEMAT[NSEQ, 21] = NFEDST
      M_NFEMAT[NSEQ, 20] = NFEDSN
      M_NFEMAT[NSEQ, 22] = NFEFRE
      M_NFEMAT[NSEQ, 23] = NFELIQ
      M_NFEMAT[NSEQ, 24] = NFEDSC
      M_NFEMAT[NSEQ, 25] = NFESUB
      M_NFEMAT[NSEQ, 27] = NFENATN
      M_NFEMAT[NSEQ, 28] = NFEEST
      M_NFEMAT[NSEQ, 30] = NFEORI+NFECST
      M_NFEMAT[NSEQ, 31] = NFEBICST
      M_NFEMAT[NSEQ, 33] = recno
      M_NFEMAT[NSEQ, 34] = .f.

      nSEQ ++

      skip

    enddo

    if len(M_NFEMAT) = 0
      msg("* * * NOTA DE ENTRADA NAO POSSUI ITENS * * *")
      return ""
    endif

    lpnfe01()

    declare M_VETORITE[len(M_NFEMAT)]

    for R = 1 to len(M_NFEMAT)
      M_VETORITE[R] = str(M_NFEMAT[R, 5], 3, 0) + " " + ;
		      str(M_NFEMAT[R, 6], 6, 0) + " " + ;
		      str(M_NFEMAT[R, 7], 9, 3) + " " + ;
		      str(M_NFEMAT[R, 8], 10, 2)+ " " + ;
		      str(M_NFEMAT[R, 9], 10, 2)+ " " + ;
		      str(M_NFEMAT[R,10], 5, 2) + " " + ;
		      str(M_NFEMAT[R,11], 10, 2)+ " " + ;
		      str(M_NFEMAT[R,12], 1, 0) + " " + ;
		      str(M_NFEMAT[R,13], 1, 0) + " " + ;
		      str(M_NFEMAT[R,16], 5, 2) + " " + ;
		      str(M_NFEMAT[R,15], 5, 2)
    next

    M_LINPOS = 0
    lPosnfe = 1

    do while .t.

      BUSCAREGISTRO("APCA00",1,{substr(M_VETORITE[1], 5, 6)},"SELECT")

      wvt_DrawLabel(21+nLinNfe,3,APCA00->PCADES,,, RGB( 255, 255,255 )  ,RGB(0,0,0) , "Visualnova", _FONTET_*.8,_FONTEL_*.7 , , , , .f., .f. ,.f.)

      set color to N/W,W+/N
      	M_OPC = achoice(12+nLinnfe, 2,19+nLinnfe,76,M_VETORITE,,"mosnfe",lPosnfe)
      set color to

      if str(lastkey(), 3, 0 ) $ " 83#115# 27"
      	exit        && abandona operacao
      endif

    enddo

****************
function CAL_DIV(TIPO)
****************

LOCAL bBlock, aLastPaint
LOCAL aBlocks := {}
LOCAL nCursor := setCursor( 0 )
LOCAL cScr    := SaveScreen( 0,0,maxrow(),maxcol() )
LOCAL aObjects:= WvtSetObjects( {} )
aLastPaint := WvtSetBlocks( aBlocks )

if TIPO = NIL
  TIPO = .F.
endif

private M_TELA

store 0 to M_CALITE, M_CALDST, M_CALDSN, M_CALBIC, M_CALVIC, M_CALVIP, M_CALVLM, M_CALVLN
M_CALGIA = 0
M_CALSUB = 0
M_VALCHE = 0
M_CALFRE = 0
M_CALDESP= 0

  for R = 1 to len(M_NFEMAT)
    M_VALCHE += M_NFEMAT[R, 09] // valor da nota cheia
  next

  M_CALVLM1 = 0


  if !lAlteranfe  // se nao estiver alterando
    if M_NFEDSC > 0
      for SQ = 1 to len(M_NFEMAT)
        if M_NFEMAT[SQ, 24] = 0
          M_NFEMAT[SQ, 23] = M_NFEMAT[SQ, 9] - round(((M_NFEDSC/M_VALCHE)*M_NFEMAT[SQ, 9]),2)
          M_NFEMAT[SQ, 24] = M_NFEMAT[SQ, 9] - M_NFEMAT[SQ, 23] // desconto
          base_nfeit()
        endif
      next
    endif
  endif

  for R = 1 to len(M_NFEMAT)
    M_CALFRE = M_CALFRE + M_NFEMAT[R, 22]
    M_CALITE = M_CALITE + M_NFEMAT[R, 07]
    M_CALDST = M_CALDST + M_NFEMAT[R, 21] 
    M_CALDSN = M_CALDSN + M_NFEMAT[R, 20]
    M_CALBIC = M_CALBIC + M_NFEMAT[R, 14]
    M_CALVIC = M_CALVIC + M_NFEMAT[R, 17] 
    M_CALVIP = M_CALVIP + M_NFEMAT[R, 11] 

    M_CALVLM1 = M_CALVLM1 + M_NFEMAT[R, 23]
    M_CALVLN = M_CALVLN + M_NFEMAT[R][23] + M_NFEMAT[R][21] + M_NFEMAT[R][11] + M_NFEMAT[R][22]
  next

 * if M_NFESUB > 0
 *   M_SOCOMSUB = 0
 *   for R = 1 to len(M_NFEMAT)
 *     
 *     if APCA00->(dbseek(str(M_NFEMAT[R][6], 6, 0))) && MAT
 *       if APCA00->PCATRI = 5 // se substituicao
 *         M_SOCOMSUB += M_NFEMAT[R][9]
 *       endif
 *     endif
 *   next

 *   for R = 1 to len(M_NFEMAT)
 *     if APCA00->(dbseek(str(M_NFEMAT[R][6], 6, 0))) && MAT
 *       if APCA00->PCATRI = 5 // se substituicao
 *         if M_NFEMAT[R][25] = 0
 *           M_NFEMAT[R][25] = round(((M_NFESUB / M_SOCOMSUB) * M_NFEMAT[R][9]), 2)
 *         endif
 *       endif
 *     endif
 *   next
 * endif

  M_CALVLN = 0

  for R = 1 to len(M_NFEMAT)
    M_CALVLN = M_CALVLN + M_NFEMAT[R][23] + M_NFEMAT[R][21] + M_NFEMAT[R][11] + M_NFEMAT[R][22] + M_NFEMAT[R][25]
    M_CALGIA = M_CALGIA + M_NFEMAT[R, 26] 
    M_CALSUB = M_CALSUB + M_NFEMAT[R, 25] 
  next

  if TIPO
    nbox(08, 10, 20, 70,"W/BG+",.t.)
    Wvt_DrawBoxRaised( 08, 10, 20, 70 )
    set color to W/BG+

    LLN = 9

    L = 0
    if !str(M_CALVLM1, 12, 2) == str(M_NFEVLM-M_NFEDSC, 12, 2)
      @ LLN, 12 say     "MERCADORIA:   INFOR -=> " + str(M_NFEVLM-M_NFEDSC, 12, 2) + " CALC -=> " + str(M_CALVLM1, 12, 2)
      LLN ++
      L = 1
    endif
    if !str(M_NFEBIC, 12, 2) == str(M_CALBIC, 12, 2)
      @ LLN, 12 say     "BASE ICM:     INFOR -=> " + str(M_NFEBIC, 12, 2) + " CALC -=> " + str(M_CALBIC, 12, 2)
      L = 1
      LLN ++
    endif
    if !str(M_NFEVIC, 12, 2) == str(M_CALVIC, 12, 2)
      @ LLN, 12 say     "I C M:        INFOR -=> " + str(M_NFEVIC, 12, 2) + " CALC -=> " + str(M_CALVIC, 12, 2)
      L = 1
      LLN ++
    endif
    if !str(M_NFEVIP, 12, 2) == str(M_CALVIP, 12, 2)
      @ LLN, 12 say     "I P I:        INFOR -=> " + str(M_NFEVIP, 12, 2) + " CALC -=> " + str(M_CALVIP, 12, 2)
      L = 1
      LLN ++
    endif

    if !str(M_NFEVLN, 12, 2) == str(M_CALVLN, 12, 2)
      if !str(M_NFEVLN, 12, 2) == str(M_CALVLN-M_NFEFRE, 12, 2)
        @ LLN, 12 say     "VALOR DA NOTA INFOR -=> " + str(M_NFEVLN, 12, 2) + " CALC -=> " + str(M_CALVLN, 12, 2) 
        L = 1
        LLN ++
      endif
    endif

    if !str(M_NFEITE, 12, 2) == str(M_CALITE, 12, 2)
      @ LLN, 12 say     "ITENS:        INFOR -=> " + str(M_NFEITE, 12, 2) + " CALC -=> " + str(M_CALITE, 12, 2)
      L = 1
      LLN ++
    endif
    if !str(M_NFEDST, 12, 2) == str(M_CALDST, 12, 2)
      @ LLN, 12 say     "DESP TRIB:    INFOR -=> " + str(M_NFEDST, 12, 2) + " CALC -=> " + str(M_CALDST, 12, 2)
      L = 1
      LLN ++
    endif
    if !str(M_NFEDSN, 12, 2) == str(M_CALDSN, 12, 2)
      @ LLN, 12 say     "DESP N TRIB  :INFOR -=> " + str(M_NFEDSN, 12, 2) + " CALC -=> " + str(M_CALDSN, 12, 2)
      L = 1
      LLN ++
    endif
    if !str(M_NFEFRE, 12, 2) == str(M_CALFRE, 12, 2)
      @ LLN, 12 say     "VALOR FRETE  :INFOR -=> " + str(M_NFEFRE, 12, 2) + " CALC -=> " + str(M_CALFRE, 12, 2)
      L = 1
      LLN ++
    endif

    if !str(M_NFESUB, 12, 2) == str(M_CALSUB, 12, 2)
      @ LLN, 12 say     "VALOR SUBST. :INFOR -=> " + str(M_NFESUB, 12, 2) + " CALC -=> " + str(M_CALSUB, 12, 2)
      L = 1
      LLN ++
    endif

    if L = 0
      M_NFESIT = "L"
    else
      M_NFESIT = " "
    endif 

    if L = 0
      @ 12, 23 say     "* * * NFE SEM DIVERGENCIAS * * *"
    endif

    set color to

    msg("* * * Tecle (ENTER) * * *")

    RestScreen( 0, 0, maxrow(), maxcol(), cScr )
  endif

  WvtSetBlocks( aLastPaint )
  WvtSetObjects( aObjects )

return ""

****************
function LPNFE01
****************

set color to I
  for K = 12 to 19
    @ K+nLinnfe, 01 say "                                                                             "
  next
set color to

return ""

****************
function SEL_NFE
****************

private M_OPC  ,;
	M_TELA

M_TELA = wvt_savescreen(11, 58, 17, 75)

sombra(11, 60, 16, 72,_SOMBRA_)

painel(11, 60, 16, 72,"W+/BG","N/BG")

set color to W+/BG,W+/N
  @ 12, 61 prompt " Processar " POSITION 2 HIGHLITE R/BG
  @ 13, 61 prompt "  Incluir  " POSITION 3 HIGHLITE R/BG
  @ 14, 61 prompt "  Alterar  " POSITION 3 HIGHLITE R/BG
  @ 15, 61 prompt "  Excluir  " POSITION 3 HIGHLITE R/BG
menu to M_OPC
set color to

wvt_restscreen(11, 58, 17, 75,M_TELA,.t.)

return M_OPC

*******************
function BASE_NFEIT
*******************

  // substituicao 

  if lAltite   // se estou alterando o item
    return ""  // nao calculo nada
  endif

  if M_NFEDST > 0 .and. M_NFEMAT[SQ][21] = 0
    M_NFEMAT[SQ][21] = round(((M_NFEDST / M_NFEVLM) * M_NFEMAT[SQ][9]), 2)
  endif

  if M_NFEDSN > 0 .and. M_NFEMAT[SQ][20] = 0
    M_NFEMAT[SQ][20] = round(((M_NFEDSN / M_NFEVLM) * M_NFEMAT[SQ][9]), 2)
  endif

  if M_NFEFRE > 0 .and. M_NFEMAT[SQ][22] = 0
    M_NFEMAT[SQ][22] = round(((M_NFEFRE / M_NFEVLM) * M_NFEMAT[SQ][9]), 2)
  endif

  if M_NFEMAT[SQ][12] = 2 && ESC

    if M_NFEMAT[SQ][18] = 0
      M_NFEMAT[SQ][18] = M_NFEMAT[SQ, 23] + M_NFEMAT[SQ, 21] + M_NFEMAT[SQ, 20] + M_NFEMAT[SQ, 11] 
    endif

    M_NFEMAT[SQ, 17] = 0 && VIC
    M_NFEMAT[SQ, 16] = 0 && PIC
    M_NFEMAT[SQ, 15] = 0 && RED
    M_NFEMAT[SQ, 14] = 0 && BIC
  else
    M_NFEMAT[SQ, 18] = 0 && ISE
  endif

  if M_NFEMAT[SQ][12] = 4 && ESC
    if M_NFEMAT[SQ][19] = 0
      M_NFEMAT[SQ][19] = M_NFEMAT[SQ][23] + M_NFEMAT[SQ][21] + M_NFEMAT[SQ][22]
    endif    
    M_NFEMAT[SQ, 18] = 0 && ISE
    M_NFEMAT[SQ, 17] = 0 && VIC
    M_NFEMAT[SQ, 16] = 0 && PIC
    M_NFEMAT[SQ, 15] = 0 && RED
    M_NFEMAT[SQ, 14] = 0 && BIC
  else
    M_NFEMAT[SQ, 19] = 0
  endif

  if M_NFEMAT[SQ, 12] = 5 && ESC
    if M_NFEMAT[SQ, 13] = 1 && EXE
      if M_NFEMAT[SQ][14] = 0
        M_NFEMAT[SQ, 14] = round((M_NFEMAT[SQ, 23] + M_NFEMAT[SQ, 21]) - (((M_NFEMAT[SQ, 23] + M_NFEMAT[SQ, 21]) * .01) * M_NFEMAT[SQ, 15]), 2)
      endif
      if M_NFEMAT[SQ][17] = 0
        M_NFEMAT[SQ, 17] = round(((M_NFEMAT[SQ, 14]  * .01) * M_NFEMAT[SQ, 16]), 2)
      endif
      if M_NFEMAT[SQ][19] = 0
        M_NFEMAT[SQ, 19] = round((M_NFEMAT[SQ, 23] + M_NFEMAT[SQ, 21]) - M_NFEMAT[SQ, 14], 2)
      endif
      M_NFEMAT[SQ, 18] = 0 && ISE
    endif
    if M_NFEMAT[SQ, 13] = 2 && EXE
      if M_NFEMAT[SQ][14] = 0
        M_NFEMAT[SQ, 14] = round(M_NFEMAT[SQ, 9] + M_NFEMAT[SQ, 21], 2)
      endif
      if M_NFEMAT[SQ][17] = 0
        M_NFEMAT[SQ, 17] = round((((M_NFEMAT[SQ, 14]  * .01) * M_NFEMAT[SQ, 16])/2), 2)
      endif
    endif
    if M_NFEMAT[SQ, 13] = 3 && EXE
      if M_NFEMAT[SQ][14] = 0
        M_NFEMAT[SQ, 14] = round((M_NFEMAT[SQ, 9] + M_NFEMAT[SQ, 21] + M_NFEMAT[SQ, 11]) - (((M_NFEMAT[SQ, 9] + M_NFEMAT[SQ, 21] + M_NFEMAT[SQ, 11]) * .01) * M_NFEMAT[SQ, 15]), 2)
      endif
      if M_NFEMAT[SQ][17] = 0
        M_NFEMAT[SQ, 17] = round(((M_NFEMAT[SQ, 14]  * .01) * M_NFEMAT[SQ, 16]), 2)
      endif
      if M_NFEMAT[SQ][19] = 0
        M_NFEMAT[SQ, 19] = round((M_NFEMAT[SQ, 23] + M_NFEMAT[SQ, 21] + M_NFEMAT[SQ, 11]) - M_NFEMAT[SQ, 14], 2)
      endif
    endif
  endif

return ""

*******************
function CAL_DUPNFE
*******************

LOCAL aBlocks2 := {}
LOCAL aLastPaint5
  aLastPaint5 := WvtSetBlocks( aBlocks2 )


private M_DUP[06], M_VCT[06], M_PR[06], M_PE[06]

declare M_DUP[06], M_VCT[06], M_PR[06], M_PE[06]

private M_TOTDUP, R, S, M_S, M_RES, M_PARC, M_TELA
 
store 0 to M_VLR, M_RES  

  for R = 1 to 6
    M_DUP[ R ] = 0
    M_VCT[ R ] = ctod("  /  /  ")
  next &&  R

  if !BUSCAREGISTRO("ACPG00",1,{str(M_NFECPG,3,0)},"SELECT")
    msg("* * * CONDICAO PAGAMENTO NAO CADASTRADA * * *")
    return ""
  endif

  M_VALOR = M_NFEVLN

  M_PARC    = CPGPAR 

  for S = 1 to 6
    M_S = str(S, 1, 0)      
    M_PE[ S ] = CPGPE&M_S
    M_PR[ S ] = CPGPR&M_S
  next && S

  for R = 1 to M_PARC            && calcula as duplicatas
    M_DUP[ R ] = round((M_VALOR * .01) * M_PE[ R ], 2)
    M_VCT[ R ] = M_NFEDTE + M_PR[ R ]
  next &&  R
 
  for R = 1 to M_PARC            && verifica se vencimento e sabado ou domingo
    M_VLR = M_VLR + M_DUP[ R ]   && somas as duplicatas
    if dow(M_VCT[ R ]) = 1
      M_VCT[ R ] = M_VCT[ R ] + 1
    endif
    if dow(M_VCT[ R ]) = 7
      M_VCT[ R ] = M_VCT[ R ] - 1
    endif
  next &&  R

  M_RES = ( M_VALOR - M_VLR )

  M_DUP[ M_PARC ] = M_DUP[ M_PARC ] + M_RES
 
  for S = 1 to 6
    M_NFENDP[S] = M_DUP[ S ] 
    M_NFEVDP[S] = M_VCT[ S ]
  next && S

  M_TELA = savescreen(10, 51, 21, 78)

  do while .t.
 
  nbox(10, 51, 19, 76,"W/W+",.t.)
  setcolor("B/W")
      @ 11, 52 say "Pr³Vencimento³  Valor   "
      @ 12, 52 say "ÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ"
      @ 13, 52 say "01³          ³          "
      @ 14, 52 say "02³          ³          "
      @ 15, 52 say "03³          ³          "
      @ 16, 52 say "04³          ³          "
      @ 17, 52 say "05³          ³          "
      @ 18, 52 say "06³          ³          "
  SetColor(_COREDICAO_)

     @ 13, 56 get M_NFEVDP[1]                         
     @ 13, 66 get M_NFENDP[1] picture "#######.##"     
     @ 14, 56 get M_NFEVDP[2]                         
     @ 14, 66 get M_NFENDP[2] picture "#######.##"     
     @ 15, 56 get M_NFEVDP[3]                         
     @ 15, 66 get M_NFENDP[3] picture "#######.##"     
     @ 16, 56 get M_NFEVDP[4]                         
     @ 16, 66 get M_NFENDP[4] picture "#######.##"     
     @ 17, 56 get M_NFEVDP[5]                        
     @ 17, 66 get M_NFENDP[5] picture "#######.##"     
     @ 18, 56 get M_NFEVDP[6]                         
     @ 18, 66 get M_NFENDP[6] picture "#######.##"     
     read

     M_TOTDUP = 0

     for R = 1 to 6
       M_TOTDUP = M_TOTDUP + M_NFENDP[R]
     next

     if !str(M_NFEVLN, 10, 2) == str(M_TOTDUP, 10, 2) 
       msg("* * * " + alltrim(transform(M_NFEVLN,"@E ###,###,###.##")) + " <=- Valor da Nota  -  Valor Titulo -=> " + alltrim(transform(M_TOTDUP,"@E ###,###,###.##")) + " * * *")
       if lastkey()=17 
         exit
       endif 
       loop
     endif

     exit

  enddo

  WvtSetBlocks( aLastPaint5 )
  restscreen(10, 51, 21, 78, M_TELA)


return ""

*******************
function EDI_DUPNFE
*******************

LOCAL aBlocks2 := {}
LOCAL aLastPaint5
  aLastPaint5 := WvtSetBlocks( aBlocks2 )

private M_TOTDUP, M_TELA
 
  M_TELA = savescreen(10, 51, 22, 78)

  do while .t.
 
  nbox(10, 51, 19, 76,"W/W+",.t.)
  setcolor("B/W")
      @ 11, 52 say "Pr³Vencimento³  Valor   "
      @ 12, 52 say "ÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ"
      @ 13, 52 say "01³          ³          "
      @ 14, 52 say "02³          ³          "
      @ 15, 52 say "03³          ³          "
      @ 16, 52 say "04³          ³          "
      @ 17, 52 say "05³          ³          "
      @ 18, 52 say "06³          ³          "
  SetColor(_COREDICAO_)

     @ 13, 56 get M_NFEVDP[1]                         
     @ 13, 66 get M_NFENDP[1] picture "#######.##"     
     @ 14, 56 get M_NFEVDP[2]                         
     @ 14, 66 get M_NFENDP[2] picture "#######.##"     
     @ 15, 56 get M_NFEVDP[3]                         
     @ 15, 66 get M_NFENDP[3] picture "#######.##"     
     @ 16, 56 get M_NFEVDP[4]                         
     @ 16, 66 get M_NFENDP[4] picture "#######.##"     
     @ 17, 56 get M_NFEVDP[5]                        
     @ 17, 66 get M_NFENDP[5] picture "#######.##"     
     @ 18, 56 get M_NFEVDP[6]                         
     @ 18, 66 get M_NFENDP[6] picture "#######.##"     
     read

     M_TOTDUP = 0

     for R = 1 to 6
       M_TOTDUP = M_TOTDUP + M_NFENDP[R]
     next

     if !str(M_NFEVLN, 10, 2) == str(M_TOTDUP, 10, 2) 
       msg("* * * " + alltrim(transform(M_NFEVLN,"@E ###,###,###.##")) + " <=- Valor da Nota  -  Valor Titulo -=> " + alltrim(transform(M_TOTDUP,"@E ###,###,###.##")) + " * * *")
       if lastkey()=17 
         exit
       endif 
       loop
     endif

     exit

  enddo

  WvtSetBlocks( aLastPaint5 )
  restscreen(10, 51, 21, 78, M_TELA)

return ""

****************
function GRNFE00(cACAO)                       && grava pedido
****************

  sqlCAMPO = {}
  sqlCHAVE = {}
  sqlARQUI = {"ANFE00",(cACAO)}

  aadd(sqlCHAVE,{"NFEEMP",str(ME_EMP, 2)})
  aadd(sqlCHAVE,{"NFENUM",str(M_NFENUM, 9)})
  aadd(sqlCHAVE,{"NFEFOR",str(M_NFEFOR, 5)})
  aadd(sqlCHAVE,{"NFESER",aspas(M_NFESER)})

  if !cACAO $ "#DELETE#SELECT#"
    aadd(sqlCAMPO,{"NFEEMP"   ,str(M_NFEEMP),.T.})
    aadd(sqlCAMPO,{"NFENUM" ,str(M_NFENUM),.T.})
    aadd(sqlCAMPO,{"NFESER" ,M_NFESER,.T.})
    aadd(sqlCAMPO,{"NFEFOR" ,str(M_NFEFOR),.T.})
    aadd(sqlCAMPO,{"NFEDTE" ,formatdta(M_NFEDTE),.T.})
    aadd(sqlCAMPO,{"NFEDTR" ,formatdta(M_NFEDTR),.T.})
    aadd(sqlCAMPO,{"NFENATN",M_NFENATN,.T.})
    aadd(sqlCAMPO,{"NFECPG" ,str(M_NFECPG),.T.})
    aadd(sqlCAMPO,{"NFEPSN" ,M_NFEPSN,.T.})
    aadd(sqlCAMPO,{"NFESIT" ,M_NFESIT,.T.})
    aadd(sqlCAMPO,{"NFEIPL" ,M_NFEIPL,.T.})
    aadd(sqlCAMPO,{"NFEITE" ,str1(M_NFEITE,3),.T.})
    aadd(sqlCAMPO,{"NFEDST" ,str1(M_NFEDST,2),.T.})
    aadd(sqlCAMPO,{"NFEDSN" ,str1(M_NFEDSN,2),.T.})
    aadd(sqlCAMPO,{"NFEDSC" ,str1(M_NFEDSC,2),.T.})
    aadd(sqlCAMPO,{"NFEFRE" ,str1(M_NFEFRE,2),.T.})
    aadd(sqlCAMPO,{"NFEBIC" ,str1(M_NFEBIC,2),.T.})
    aadd(sqlCAMPO,{"NFEVIC" ,str1(M_NFEVIC,2),.T.})
    aadd(sqlCAMPO,{"NFEVLM" ,str1(M_NFEVLM,2),.T.})
    aadd(sqlCAMPO,{"NFEVIP" ,str1(M_NFEVIP,2),.T.})
    aadd(sqlCAMPO,{"NFEVLN" ,str1(M_NFEVLN,2),.T.})
    aadd(sqlCAMPO,{"NFESUB" ,str1(M_NFESUB,2),.T.})
    aadd(sqlCAMPO,{"NFSID"  ,M_NFSID,.T.})
    for A = 1 to 6
      MS = str(A,1)
      aadd(sqlCAMPO,{"NFEVC&MS",formatdta(M_NFEVDP[A]),.T.})
      aadd(sqlCAMPO,{"NFEDP&MS",str1(M_NFENDP[A],2),.T.})
    next
    aadd(sqlCAMPO,{"NFEOBS" ,M_NFEOBS,.T.})
    aadd(sqlCAMPO,{"NFECOMP", M_NFECOMP,.T.})
    aadd(sqlCAMPO,{"NFEMOD" ,str(M_NFEMOD),.T.})
  endif


  executasql()
  return ""

  */*/*/
  
****************
function GRNFE01(cACAO)
****************

if cACAO $ "#DELETE#INSERT#"
  sqlCAMPO = {}
  sqlCHAVE = {}
  sqlARQUI = {"ANFE01","DELETE"}
  aadd(sqlCHAVE,{"NFEEMP",str(M_NFEEMP,2)})
  aadd(sqlCHAVE,{"NFENUM",str(M_NFENUM,9)})
  aadd(sqlCHAVE,{"NFEFOR",str(M_NFEFOR,5)})
  aadd(sqlCHAVE,{"NFESER",aspas(M_NFESER)})
  executasql()
endif

if cACAO $ "#SELECT#"
  sqlCAMPO = {}
  sqlCHAVE = {}
  sqlARQUI = {"ANFE01","SELECT"}
  aadd(sqlCHAVE,{"NFEEMP",str(M_NFEEMP,2)})
  aadd(sqlCHAVE,{"NFENUM",str(M_NFENUM,9)})
  aadd(sqlCHAVE,{"NFEFOR",str(M_NFEFOR,5)})
  aadd(sqlCHAVE,{"NFESER",aspas(M_NFESER)})
  executasql()
  return ""
endif

if !cACAO $ "#DELETE#SELECT#"
  for R = 1 to len(M_NFEMAT)
    sqlCAMPO = {}
    sqlCHAVE = {}
    sqlARQUI = {"ANFE01",(cACAO)}

    aadd(sqlCHAVE,{"NFEEMP",str(M_NFEEMP,2)})
    aadd(sqlCHAVE,{"NFENUM",str(M_NFENUM,9)})
    aadd(sqlCHAVE,{"NFEFOR",str(M_NFEFOR,5)})
    aadd(sqlCHAVE,{"NFESER",aspas(M_NFESER)})

    aadd(sqlCAMPO,{"NFEEMP",str(M_NFEMAT[R][ 1],2),.T.})
    aadd(sqlCAMPO,{"NFENUM",str(M_NFEMAT[R][ 2],9),.T.})
    aadd(sqlCAMPO,{"NFESER",M_NFEMAT[R][ 3],.T.})
    aadd(sqlCAMPO,{"NFEFOR",str(M_NFEMAT[R][ 4],5),.T.})
    aadd(sqlCAMPO,{"NFESEQ",str(M_NFEMAT[R][ 5],3),.T.})
    aadd(sqlCAMPO,{"NFEMAT",str(M_NFEMAT[R][ 6],6),.T.})
    aadd(sqlCAMPO,{"NFEQDE",str1(M_NFEMAT[R][ 7],3),.T.})
    aadd(sqlCAMPO,{"NFEPUN",str1(M_NFEMAT[R][ 8],2),.T.})
    aadd(sqlCAMPO,{"NFEVLI",str1(M_NFEMAT[R][ 9],2),.T.})
    aadd(sqlCAMPO,{"NFEPIP",str1(M_NFEMAT[R][10],2),.T.})
    aadd(sqlCAMPO,{"NFEVIP",str1(M_NFEMAT[R][11],2),.T.})
    aadd(sqlCAMPO,{"NFEESC",str(M_NFEMAT[R][12],1),.T.})
    aadd(sqlCAMPO,{"NFEEXE",str(M_NFEMAT[R][13],1),.T.})
    aadd(sqlCAMPO,{"NFERED",str1(M_NFEMAT[R][15],2),.T.})
    aadd(sqlCAMPO,{"NFEBIC",str1(M_NFEMAT[R][14],2),.T.})
    aadd(sqlCAMPO,{"NFEPIC",str1(M_NFEMAT[R][16],2),.T.})
    aadd(sqlCAMPO,{"NFEVIC",str1(M_NFEMAT[R][17],2),.T.})
    aadd(sqlCAMPO,{"NFEISE",str1(M_NFEMAT[R][18],2),.T.})
    aadd(sqlCAMPO,{"NFEOUT",str1(M_NFEMAT[R][19],2),.T.})
    aadd(sqlCAMPO,{"NFEDST",str1(M_NFEMAT[R][21],2),.T.})
    aadd(sqlCAMPO,{"NFEDSN",str1(M_NFEMAT[R][20],2),.T.})
    aadd(sqlCAMPO,{"NFEFRE",str1(M_NFEMAT[R][22],2),.T.})
    aadd(sqlCAMPO,{"NFELIQ",str1(M_NFEMAT[R][23],2),.T.})
    aadd(sqlCAMPO,{"NFEDSC",str1(M_NFEMAT[R][24],2),.T.})
    aadd(sqlCAMPO,{"NFESUB",str1(M_NFEMAT[R][25],2),.T.})
    aadd(sqlCAMPO,{"NFENATN",M_NFEMAT[R][27],.T.})
    aadd(sqlCAMPO,{"NFECST",right(M_NFEMAT[R][30],2),.T.})
    aadd(sqlCAMPO,{"NFEORI",left(M_NFEMAT[R][30],1),.T.})
    aadd(sqlCAMPO,{"NFEBICST",str1(M_NFEMAT[R][31],2),.T.})
    aadd(sqlCAMPO,{"NFEPICST",str1(M_NFEMAT[R][32],2),.T.})
    aadd(sqlCAMPO,{"NFEDTE",formatdta(M_NFEDTE),.T.})
    aadd(sqlCAMPO,{"NFEDTR",formatdta(M_NFEDTR),.T.})
    executasql()
  next
endif

return ""

