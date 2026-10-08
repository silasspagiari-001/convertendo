#include "ptmenu.ch"

***************
function MANAPU
***************
parameters M_OPC,M_OPC1,M_OPC2


      rodape("MENU","APURACAO",M_FAN,"EAGRO73","Mem: " + str(memory(0), 5),M_EMP)

*        @ 05, 61 prompt "ResIcms  " HIGHLITE R/BG PERMITE 3,7,1
*        @ 06, 61 prompt "LivroIcms" HIGHLITE R/BG PERMITE 3,7,2
*        @ 07, 61 prompt "ApuraIcms" HIGHLITE R/BG PERMITE 3,7,3
*        @ 08, 61 prompt "GiaIcms  " HIGHLITE R/BG PERMITE 3,7,4
*        @ 09, 61 prompt "Pis/Cofin" HIGHLITE R/BG PERMITE 3,7,5
*        @ 10, 61 prompt "Sped ICMS" HIGHLITE R/BG POSITION 2 PERMITE 3,7,6


      do case
         case M_OPC = 1
         case M_OPC = 2
         case M_OPC = 3 ; apuicm()
         case M_OPC = 4 ; pis()
         case M_OPC = 5 ; sped()
      endcase


return ""

***************
function APUICM
***************

msw("AGUARDE ... ABRINDO ARQUIVOS * * *")

if file("&_PATH_\USR\LIVRO\AICE50.CDX")
  erase("&_PATH_\USR\LIVRO\AICE50.CDX")
endif

if file("&_PATH_\USR\LIVRO\AICS50.CDX")
  erase("&_PATH_\USR\LIVRO\AICS50.CDX")
endif

select 0        && nfs temporario

use &_PATH_\USR\LIVRO\AICE50 alias AICE50 exclusive

if neterr()
  msg("* * * (AICE50) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

index on str(ICEEMP, 2, 0) + ICENAT tag 1  to &_PATH_\USR\LIVRO\AICE50
set index to &_PATH_\USR\LIVRO\AICE50

select 0         && nfs temporario

use &_PATH_\USR\LIVRO\AICS50 alias AICS50 exclusive

if neterr()
  msg("* * * (AICS50) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

index on str(ICSEMP, 2, 0) + ICSNAT tag 1 to &_PATH_\USR\LIVRO\AICS50
set index to &_PATH_\USR\LIVRO\AICS50

private M_OPC ,;
M_TELA

do while .t.
  
  rodape("APURACAO","ICM",M_FAN,"EAGRO73","Mem: " + str(memory(0), 5),M_EMP)
  
  store 0                 to PG
  store "S"               to M_CLIENTES
  store ctod("  /  /  ")  to M_DATA1, M_DATA2
  store space(18)         to M_NFEANT
  store "P"               to M_TIPO
  store 0                 to M_MES, M_ANO, M_MES1
  M_PRI = .t.

  M_TOTFREC = 0
  M_TOTCREC = 0
  M_DESCRI = space(15)
  M_TELA =  savescreen(09, 25, 16, 63)
  store ctod("  /  /  ")  to M_DATA1, M_DATA2

  S_BASE01 = 0
  L_BASE01 = 0
  M_PIS = 0.65
  M_COF = 3.0
  M_CRESUB = 0

  M_TOTPIS  = 0
  S_TOTVPIS = 0
  M_TOTCOF  = 0
  S_TOTVCOF = 0
  
 nbox(10, 21, 15, 63,"W/W+",.t.)
 setcolor("B/W")
  @ 11, 22 say     " Periodo Inicial:                        "
  @ 12, 22 say     "           Final:                        "
  @ 13, 22 say     "                :                        "
  @ 14, 22 say     " Pagina Atual   :                        "
  SetColor(_COREDICAO_)
  @ 11, 40 get M_DATA1
  @ 12, 40 get M_DATA2
  @ 13, 40 get M_TOTCREC picture "999,999.99"
  @ 14, 40 get PG picture "9999"
  read

  PG --
  
  if lastkey() = 27
    exit
  endif
  
*  M_DATA1 = ctod("01/" + strzero(M_MES, 2, 0) + "/" + strzero(M_ANO, 2, 0))
 * M_DATA2 = lastday(ctod("01/" + strzero(M_MES, 2, 0) + "/" + strzero(M_ANO, 2, 0)))
  
  M_MES = month(M_DATA1)
  M_ANO = val(right(str(year(M_DATA1),4),2))

  *
  ** verifica parametros anteriores
  *
  
  select APAR00

  M_SLDANT = 0

  if !dbseek(str(ME_EMP, 2, 0) + strzero(iif(M_MES=1,12,M_MES-1), 2, 0) + strzero(iif(M_MES=1,iif(M_ANO=0,99,M_ANO-1),M_ANO), 2, 0))
    msg("* * * APURACAO DO MES ANTERIOR NAO EFETUADA * * *")
    restscreen(09, 25, 16, 60, M_TELA)
  else
    M_SLDANT = APAR00->PAR016c 
  endif
  
  if !dbseek(str(ME_EMP, 2, 0) + strzero(M_MES, 2, 0) + strzero(M_ANO, 2, 0))
    cria_par()
  endif
  
  *
  ** APURACAO DE ENTRADA
  *

  M_GIA = 0
  M_SUB = 0
  M_DEB = 0
  M_EST = 0
  M_DEBOU = 0

  select AICE50                 && limpa o arquivo
  zap
  
  select ANFE00
  set order to 2

  set softseek on
  seek str(ME_EMP, 2, 0) + dtos(M_DATA1)
  set softseek off
  
  if str(NFEEMP, 2, 0) + dtos(NFEDTR) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
    msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
    restscreen(09, 25, 16, 60, M_TELA)
    loop
  endif
  
  msw("* * * PROCESSANDO ENTRADA - (ESC) Cancela * * *")
  
  do while !eof()
    
    if str(NFEEMP, 2, 0) + dtos(NFEDTR) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
      exit
    endif
    
    M_DEB += NFEVIC

    AFOR00->(dbseek(str(ANFE00->NFEFOR, 7, 0)))

    AFIS00->(dbseek(ANFE00->NFENAT))

    lPegapis = .t.

    if !alltrim(tira_pto(AFIS00->FISNOV)) $ "#1253#"  
      if alltrim(tira_pto(AFIS00->FISNOV)) $ "#1653#"  
        lPegapis = .f.
      endif
      if AFIS00->FISCTB == "N" 
        lPegapis = .f.
      endif
    endif

    select ANFE01
    
    dbseek(str(ANFE00->NFEEMP, 2, 0) + str(ANFE00->NFENUM, 6, 0)  + ANFE00->NFESER + str(ANFE00->NFEFOR, 7, 0),.t.)
    
    do while !eof()
      
      if !str(ANFE01->NFEEMP, 2, 0) + str(ANFE01->NFENUM, 6, 0)  + ANFE01->NFESER + str(ANFE01->NFEFOR, 7, 0) == str(ANFE00->NFEEMP, 2, 0) + str(ANFE00->NFENUM, 6, 0) + ANFE00->NFESER + str(ANFE00->NFEFOR, 7, 0)
        exit
      endif
      
      select AICE50

      M_NFENAT = ANFE00->NFENATN
      AFIS00->(dbseek(M_NFENAT))

      M_NOV = AFIS00->FISNOV
      M_NOV = strtran(AFIS00->FISNOV,".","")
      M_NOV = strtran(M_NOV,",","")

      if !empty(ANFE01->NFENATN)
        M_NOV = ANFE01->NFENATN
      endif

      M_NOV = tira_pto(M_NOV)

      M_LIQ = iif(ANFE01->NFELIQ=0,ANFE01->NFEVLI,ANFE01->NFELIQ)

      seek str(ANFE01->NFEEMP, 2, 0) + M_NOV
      
      if eof()
        append blank
        replace ICEEMP  with ANFE01->NFEEMP
        replace ICENAT  with M_NOV
        replace ICEPIC  with ANFE01->NFEPIC
        replace ICEEST  with AFOR00->FOREST
      endif

      APCA00->(dbseek(str(ANFE01->NFEMAT, 6, 0)))

      if APCA00->PCATRI = 4 // substituicao vamos creditar
        replace ICEDEBI with (ICEDEBI + ANFE01->NFEVIC)
      endif

      replace ICECRIC with (ICECRIC + ANFE01->NFEVIC)
      replace ICEBIC  with (ICEBIC  + ANFE01->NFEBIC)
      replace ICEISIC with (ICEISIC + ANFE01->NFEISE)
      replace ICEOUIC with (ICEOUIC + ANFE01->NFEOUT)
      replace ICEVLN  with (ICEVLN  + M_LIQ + ANFE01->NFEDST + ANFE01->NFEVIP + ANFE01->NFEFRE + ANFE01->NFESUB)
      select ANFE01

      M_NFENAT = alltrim(NFENATN)

      if M_NFENAT == ""
        AFIS00->(dbseek(ANFE00->NFENAT))
        M_NFENAT = alltrim(tira_pto(AFIS00->FISNOV))
      endif

      skip
      
    enddo
    
    select ANFE00
    
    skip
    
    if inkey() = 27
      M_OPC = decide("Deseja Cancelar o Processamento")
      if M_OPC = 1
        select ANFE01
        go bottom
        skip
        select ANFE00
        go bottom
        skip
        msw("* * * PROCESSANDO ENTRADA - (ESC) Cancela * * *")
      endif
    endif
    
  enddo

  select ANFE00
  set relation to

  *
  ** APUCAO DE SAIDA
  *

  select AICS50
  zap
  
  select ANFS00
  set order to 2
  
  set softseek on
  seek str(ME_EMP, 2, 0) + dtos(M_DATA1)
  set softseek off
  
  if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
    msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
    loop
  endif
  
  msw("* * * PROCESSANDO SAIDA - (ESC) Cancela * * *")
  
  do while !eof()
    
    if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
      exit
    endif
    
    if NFSCAN $ "CD"
      skip
      loop
    endif
    
    select ANFS01
    
    set softseek on
    seek str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0)  + ANFS00->NFSSER
    set softseek off
    
    do while !eof()
      
      if !str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSNUM, 6, 0)  + ANFS01->NFSSER  == str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER
        exit
      endif

      AFIS00->(dbseek(ANFS00->NFSNATN))
      M_NOV = strtran(AFIS00->FISNOV,".","")
      M_NOV = strtran(M_NOV,",","")

      if NFSBIC = 0 .and. !left(str(ANFS00->NFSNAT, 5, 0),3) $ "599#699"
        ACLI00->(dbseek(str(ANFS00->NFSCLI, 5, 0)))        
        if len(alltrim(ACLI00->CLICGC1)) = 11
          M_NOV = "5405"
        else
*          if ACLI00->CLIREV == "S"
*            M_NOV = "5403"
*          else
            M_NOV = "5405"
*          endif
        endif
      endif

      select AICS50
      
      seek str(ME_EMP, 2, 0) + M_NOV
      
      M_LIQ = iif(ANFS01->NFSLIQ=0,ANFS01->NFSVLI,ANFS01->NFSLIQ)

      if eof()
        append blank
        replace ICSEMP  with ANFS01->NFSEMP
        replace ICSNAT  with M_NOV
        replace ICSPIC  with ANFS01->NFSPIC
        replace ICSEST  with ACLI00->CLIUF2
      endif

      * -> icm
      replace ICSCRIC with (ICSCRIC + ANFS01->NFSVIC)
      replace ICSBIC  with (ICSBIC  + ANFS01->NFSBIC)
      replace ICSISIC with (ICSISIC + ANFS01->NFSISE)

      if M_NOV $ "5405#5403"
        replace ICSOUIC with (ICSOUIC + M_LIQ+ ANFS01->NFSDSP)
      else
        replace ICSOUIC with (ICSOUIC + ANFS01->NFSOUT)
      endif

      replace ICSVLN  with (ICSVLN  + M_LIQ)

      if alltrim(M_NOV) $ "#5933#5102#6102#5405#5411#6108#6202#6411#"
        S_BASE01 += ANFS01->NFSLIQ
        L_BASE01 += ANFS01->NFSLIQ
        M_TOTPIS  += round(((ANFS01->NFSLIQ/100) * M_PIS),2)
        S_TOTVPIS += round(((ANFS01->NFSLIQ/100) * M_PIS),2)
        M_TOTCOF  += round(((ANFS01->NFSLIQ/100) * M_COF),2)
        S_TOTVCOF += round(((ANFS01->NFSLIQ/100) * M_COF),2)
      endif

      select ANFS01
      
      skip

    enddo
    
    select ANFS00
    
    skip
    
    if inkey() = 27
      M_OPC = decide("Deseja Cancela o Processamento")
      if M_OPC = 1
        select ANFS01
        go bottom
        skip
        select ANFS00
        go bottom
        skip
        msw("* * * PROCESSANDO SAIDA - (ESC) Cancela * * *")
      endif
    endif
    
  enddo

// cupom fiscal

  select ACUP00
  set order to 3
  
  set softseek on
  seek str(ME_EMP, 2, 0) + dtos(M_DATA1)
  set softseek off
  
  msw("* * * PROCESSANDO CUPOM - (ESC) Cancela * * *")
  
  do while !eof()
    
    if str(CUPEMP, 2, 0) + dtos(CUPDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
      exit
    endif
    
    if !CUPCAN == "E"
      skip
      loop
    endif
    
    select ACUP01
    
    dbseek(str(ACUP00->CUPEMP, 2, 0) + str(ACUP00->CUPNUM, 6, 0)  + ACUP00->CUPSER,.t.)
    
    do while !eof()
      
      if !str(ACUP01->CUPEMP, 2, 0) + str(ACUP01->CUPNUM, 6, 0)  + ACUP01->CUPSER  == str(ACUP00->CUPEMP, 2, 0) + str(ACUP00->CUPNUM, 6, 0) + ACUP00->CUPSER
        exit
      endif

      M_ICMS = 0

      M_NOV = left(str(CUPNAT,5),4)

      if CUPNAT = 51020
        M_ICMS = CUPCOM
      endif

      select AICS50
      
      seek str(ME_EMP, 2, 0) + M_NOV
      
      if eof()
        append blank
        replace ICSEMP  with ME_EMP
        replace ICSNAT  with M_NOV
        replace ICSPIC  with M_ICMS
        replace ICSEST  with "SP"
      endif
      * -> icm

      replace ICSCRIC with (ICSCRIC + ((ACUP01->CUPLIQ/100)*M_ICMS))

      if M_ICMS > 0
        replace ICSBIC  with (ICSBIC  + ACUP01->CUPLIQ)
      else
        replace ICSOUIC with (ICSOUIC + ACUP01->CUPLIQ)
      endif

      replace ICSVLN  with (ICSVLN  + ACUP01->CUPLIQ)

      S_BASE01 += ACUP01->CUPLIQ
      L_BASE01 += ACUP01->CUPLIQ
      M_TOTPIS  += round(((ACUP01->CUPLIQ/100) * M_PIS),2)
      S_TOTVPIS += round(((ACUP01->CUPLIQ/100) * M_PIS),2)
      M_TOTCOF  += round(((ACUP01->CUPLIQ/100) * M_COF),2)
      S_TOTVCOF += round(((ACUP01->CUPLIQ/100) * M_COF),2)

      select ACUP01
      
      skip

    enddo
    
    select ACUP00
    
    skip
    
    if inkey() = 27
      M_OPC = decide("Deseja Cancela o Processamento")
      if M_OPC = 1
        select ACUP01
        go bottom
        skip
        select ACUP00
        go bottom
        skip
        msw("* * * PROCESSANDO SAIDA - (ESC) Cancela * * *")
      endif
    endif
    
  enddo


  select ACUP00
  set order to 1

// fim cupom fiscal


  *
  ** EMISSAO DO RELATORIO
  *
  
  M_ARQI  = substr(time(),4,2) + substr(time(),7,2) + ".RPT"
  M_IMPRE = imprelaser()
  
  if M_IMPRE = "N"
    exit
  endif

  nTAMLIN = 60

  if M_IMPRE == "L"
    nTAMLIN = 80
  else
    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(15)                        && comprime
    endif
  endif
  
  M_TOTFRED = 0
  
  M_TVLCONT = 0
  M_TOTVLNT = 0
  M_TOTISIC = 0
  M_TOTOUIC = 0
  M_TOTCRET = 0

  M_TOTDEBI = 0
  
  M_SUBCONT = 0
  M_SUBVLNT = 0
  M_SUBISIC = 0
  M_SUBOUIC = 0
  M_SUBCRIC = 0
  m_DEBITO  = 0
  
  store  0 to LN
    
  select AICE50
  go top
  
  cab_apu()
  
  M_CFOANT = left(ICENAT, 1)
  
  do case
  case M_CFOANT = "1"
    ?
    ? " 100 - ENTRADAS E/OU AQUISICAO DE SERVICOS NO ESTADO     "
  case M_CFOANT = "2"
    ?
    ? " 200 - ENTRADAS E/OU AQUISICAO DE SERVICOS FORA DO ESTADO"
  endcase
  
  LN = LN + 2
  
  if LN > nTAMLIN
    cab_apu()
  endif
  
  do while !eof()
    
    if !M_CFOANT == left(ICENAT, 1)
      ?
      ? "     SUB TOTAL    -=>       "
      ?? transform(M_SUBCONT,"@E ###,###,###,###.##")
      ?? "   "
      ?? transform(M_SUBVLNT,"@E ###,###,###,###.##")
      ?? "  "
      ?? transform(M_SUBCRIC,"@E ###,###,###,###.##")
      ?? "  "
      ?? transform(M_SUBISIC,"@E ###,###,###,###.##")
      ?? "       "
      ?? transform(M_SUBOUIC,"@E ###,###,###,###.##")
      M_SUBCONT = 0
      M_SUBVLNT = 0
      M_SUBISIC = 0
      M_SUBOUIC = 0
      M_SUBCRIC = 0
      M_CFOANT  = left(ICENAT, 1)
      LN = LN + 2
      if LN > nTAMLIN
        cab_apu()
      endif
      do case
      case M_CFOANT = "1"
        ?
        ? " 100 - ENTRADAS E/OU AQUISICAO DE SERVICOS NO ESTADO     "
      case M_CFOANT = "2"
        ?
        ? " 200 - ENTRADAS E/OU AQUISICAO DE SERVICOS FORA DO ESTADO"
      endcase
      LN = LN + 2
      if LN > nTAMLIN
        cab_apu()
      endif
    endif
    
    ? " "
    ?? transform(ICENAT, "@R 9.999")
    ?? " "
    ?? pad(cfopdes(val(ICENAT)),27)
    ?? " "
    ?? transform(ICEVLN,"@E ####,###.##")
    ?? "   "
    ?? transform(ICEBIC,"@E ###,###,###,###.##")
    ?? "  "
    ?? transform(ICECRIC,"@E ###,###,###,###.##")
    ?? "  "
    ?? transform(ICEISIC,"@E ###,###,###,###.##")
    ?? "       "
    ?? transform(ICEOUIC,"@E ###,###,###,###.##")
    
    if ICENAT $ "#163#263"
      M_TOTFREC = M_TOTFREC + ICECRIC
    endif
    
    M_TVLCONT = M_TVLCONT + ICEVLN
    M_TOTVLNT = M_TOTVLNT + ICEBIC
    M_TOTISIC = M_TOTISIC + ICEISIC
    M_TOTOUIC = M_TOTOUIC + ICEOUIC
    M_TOTCRET = M_TOTCRET + ICECRIC
    
    M_TOTDEBI += ICEDEBI

    M_SUBCONT = M_SUBCONT + ICEVLN
    M_SUBVLNT = M_SUBVLNT + ICEBIC
    M_SUBISIC = M_SUBISIC + ICEISIC
    M_SUBOUIC = M_SUBOUIC + ICEOUIC
    M_SUBCRIC = M_SUBCRIC + ICECRIC
    
    LN = LN + 1
    
    if LN > nTAMLIN
      cab_apu()
    endif
    
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
  
  ?
  ? "     SUB TOTAL    -=>       "
  ?? transform(M_SUBCONT,"@E ###,###,###,###.##")
  ?? "   "
  ?? transform(M_SUBVLNT,"@E ###,###,###,###.##")
  ?? "  "
  ?? transform(M_SUBCRIC,"@E ###,###,###,###.##")
  ?? "  "
  ?? transform(M_SUBISIC,"@E ###,###,###,###.##")
  ?? "       "
  ?? transform(M_SUBOUIC,"@E ###,###,###,###.##")
  
  LN = LN + 2
  
  if LN > nTAMLIN
    cab_apu()
  endif
  
  ?
  ? "     TOTAL        -=>       "
  ?? transform(M_TVLCONT,"@E ###,###,###,###.##")
  ?? "   "
  ?? transform(M_TOTVLNT,"@E ###,###,###,###.##")
  ?? "  "
  ?? transform(M_TOTCRET,"@E ###,###,###,###.##")
  ?? "  "
  ?? transform(M_TOTISIC,"@E ###,###,###,###.##")
  ?? "       "
  ?? transform(M_TOTOUIC,"@E ###,###,###,###.##")
  
  ? replicate("-", 132)
  
  LN = LN + 3
  
  if LN > nTAMLIN
    cab_apu()
  endif
  
  M_TVLCONT = 0
  M_TOTVLNT = 0
  M_TOTISIC = 0
  M_TOTOUIC = 0
  M_TOTCRSD = 0
  
  M_SUBCONT = 0
  M_SUBVLNT = 0
  M_SUBISIC = 0
  M_SUBOUIC = 0
  M_SUBCRIC = 0
  
  select AICS50
  locate for ICSNAT = "5403"

  M_VAL = 0
  if ICSCRIC < 0
    M_VAL += ICSCRIC
    replace ICSCRIC with 0
  endif

  locate for ICSNAT = "5405"

  if ICSCRIC < 0
    replace ICSCRIC with 0
    M_VAL += ICSCRIC
  endif

  locate for ICSNAT = "5102"
  replace ICSCRIC with ICSCRIC + M_VAL

  go top
  
  M_CFOANT = left(ICSNAT, 1)
  
  do case
  case M_CFOANT = "5"
    ?
    ? " 500 - SAIDAS E/OU AQUISICAO DE SERVICOS NO ESTADO       "
  case M_CFOANT = "6"
    ?
    ? " 600 - SAIDAS E/OU AQUISICAO DE SERVICOS FORA DO ESTADO  "
  endcase
  
  LN = LN + 2
  
  if LN > nTAMLIN
    cab_apu()
  endif
  
  do while !eof()
    
    if !M_CFOANT == left(ICSNAT, 1)
      ?
      ? "     SUB TOTAL    -=>       "
      ?? transform(M_SUBCONT,"@E ###,###,###,###.##")
      ?? "   "
      ?? transform(M_SUBVLNT,"@E ###,###,###,###.##")
      ?? "  "
      ?? transform(M_SUBCRIC,"@E ###,###,###,###.##")
      ?? "  "
      ?? transform(M_SUBISIC,"@E ###,###,###,###.##")
      ?? "       "
      ?? transform(M_SUBOUIC,"@E ###,###,###,###.##")
      M_SUBCONT = 0
      M_SUBVLNT = 0
      M_SUBISIC = 0
      M_SUBOUIC = 0
      M_SUBCRIC = 0
      M_CFOANT  = left(ICSNAT, 1)
      LN = LN + 2
      if LN > nTAMLIN
        cab_apu()
      endif
      do case
      case M_CFOANT = "5"
        ?
        ? " 500 - SAIDAS E/OU AQUISICAO DE SERVICOS NO ESTADO       "
      case M_CFOANT = "6"
        ?
        ? " 600 - SAIDAS E/OU AQUISICAO DE SERVICOS FORA DO ESTADO  "
      endcase
      LN = LN + 2
      if LN > nTAMLIN
        cab_apu()
      endif
    endif
    
    ? " "
    ?? transform(ICSNAT,"@R 9.999")
    ?? " "
    ?? pad(cfopdes(val(ICSNAT)),27)
    ?? " "
    ?? transform(ICSVLN,"@E ####,###.##")
    ?? "   "
    ?? transform(ICSBIC,"@E ###,###,###,###.##")
    ?? "  "
    ?? transform(ICSCRIC,"@E ###,###,###,###.##")
    ?? "  "
    ?? transform(ICSISIC,"@E ###,###,###,###.##")
    ?? "       "
    ?? transform(ICSOUIC,"@E ###,###,###,###.##")
    
    M_TVLCONT = M_TVLCONT + ICSVLN
    M_TOTVLNT = M_TOTVLNT + ICSBIC
    M_TOTISIC = M_TOTISIC + ICSISIC
    M_TOTOUIC = M_TOTOUIC + ICSOUIC
    M_TOTCRSD = M_TOTCRSD + ICSCRIC
    
    M_SUBCONT = M_SUBCONT + ICSVLN
    M_SUBVLNT = M_SUBVLNT + ICSBIC
    M_SUBISIC = M_SUBISIC + ICSISIC
    M_SUBOUIC = M_SUBOUIC + ICSOUIC
    M_SUBCRIC = M_SUBCRIC + ICSCRIC
    
    LN = LN + 1
    
    if LN > nTAMLIN
      cab_apu()
    endif
    
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
  
  ?
  ? "     SUB TOTAL    -=>       "
  ?? transform(M_SUBCONT,"@E ###,###,###,###.##")
  ?? "   "
  ?? transform(M_SUBVLNT,"@E ###,###,###,###.##")
  ?? "  "
  ?? transform(M_SUBCRIC,"@E ###,###,###,###.##")
  ?? "  "
  ?? transform(M_SUBISIC,"@E ###,###,###,###.##")
  ?? "       "
  ?? transform(M_SUBOUIC,"@E ###,###,###,###.##")
  
  LN = LN + 2
  
  if LN > nTAMLIN
    cab_apu()
  endif
  
  ?
  ? "     TOTAL        -=>       "
  ?? transform(M_TVLCONT,"@E ###,###,###,###.##")
  ?? "   "
  ?? transform(M_TOTVLNT,"@E ###,###,###,###.##")
  ?? "  "
  ?? transform(M_TOTCRSD,"@E ###,###,###,###.##")
  ?? "  "
  ?? transform(M_TOTISIC,"@E ###,###,###,###.##")
  ?? "       "
  ?? transform(M_TOTOUIC,"@E ###,###,###,###.##")
  
  LN = LN + 2
  
  if LN > nTAMLIN
    cab_apu()
  endif

  ? replicate("-", 132)

  M_TOT1 = (M_DEBOU-M_EST)+M_GIA
  M_TOT2 = M_GIA+M_DEB

  ? space(40)
  ?? "    CREDITO DO IMPOSTO          "
  ?? transform(M_TOT2-M_TOT1,"@E ###,###,###.##")

  select ANFS00
  use
  select ANFS01
  use
  select ANFE00 
  use
  select ANFE01
  use

  ? space(40)
  ?? "    DEBITO  DO IMPOSTO          "
  ?? transform(M_TOTCRSD,"@E ###,###,###.##")
  ?? "         A RECOLHER PIS            "
  ?? transform(M_TOTPIS,"@E ###,###.##")

  ? space(40)
  ?? "    IMPOSTO A RECOLHER ICMS     "
  ?? transform((M_TOTCRSD-M_CRESUB-(M_TOT2-M_TOT1)),"@E ###,###,###.##")
  ?? "         A RECOLHER COFINS         "
  ?? transform(M_TOTCOF,"@E ###,###.##")

  ? replicate("-", 132)

  ? space(40)
  ?? "    APROXIMADO IMPOSTO MES      " 
  ?? transform((M_TOTCRSD-M_CRESUB-(M_TOT2-M_TOT1) + M_TOTPIS+M_TOTCOF),"@E ###,###,###.##")

  if !M_IMPRE $ "AL"
    eject
  else
    ?
  endif

    select APAR00
  
    do while .t.
      if rlock()
        replace  PAREMP   with  ME_EMP
        replace  PARMES   with  substr(dtoc(M_DATA2), 4, 2) + substr(dtoc(M_DATA2), 7, 2)
        replace  PAR001   with  M_TOTCRSD
        if M_TOTFREC > 0
          replace  DES0201  with  "TOMADA SERV C/ IMPOSTO PAGAR"
          replace  PAR0201  with  M_TOTFREC
        endif
        if M_TOTCREC > 0
          replace  DES0701  with  M_DESCRI
          replace  PAR0701  with  M_TOTCREC
        endif
        replace  PAR006   with  M_TOTCRET
        replace  PAR011   with  M_SLDANT   // cruufes(M_MES,M_ANO,M_SLDANT)
        replace  PAR074   with  M_TVLCONT  // cruufes(M_MES,M_ANO,M_TVLCONT)

        if ((M_TOTCRET + M_SLDANT + M_TOTCREC) - (M_TOTCRSD + M_TOTFREC)) > 0
          replace  PAR016c  with  ((M_TOTCRET + M_SLDANT + M_TOTCREC) - (M_TOTCRSD + M_TOTFREC)) // cruufes(M_MES,M_ANO,((M_TOTCRET + M_SLDANT + M_TOTCREC) - (M_TOTCRSD + M_TOTFREC)))
        endif

        unlock
        commit
        exit
      else
        msg("* * * (APAR00) REGISTRO SENDO USADO * * *")
      endif
      if lastkey()=17
        exit
      endif
    enddo

  set print off
  set printer to
  set console on
  set cursor on
  set relation to
  set order to 1

  desliga1(140)

  restscreen(09, 25, 16, 60, M_TELA)
  
enddo

unlock all

fecha_arq()

return ""

****************
function UFESCRU
****************

parameters M_PARMES ,;
M_PARANO ,;
M_PARVLR

M_AREA = str(select())

M_DTAUFE = lastday(ctod("01/" + strzero(M_PARMES, 2, 0) + "/" + strzero(M_PARANO, 2, 0)))

select ADOL00

if !dbseek(dtos(M_DTAUFE))
  select &M_AREA
  return 0
endif

select &M_AREA

return M_PARVLR * ADOL00->UFESP

****************
function CRUUFES
****************

parameters M_PARMES ,;
M_PARANO ,;
M_PARVLR

M_DTAUFE = lastday(ctod("01/" + strzero(M_PARMES, 2, 0) + "/" + strzero(M_PARANO, 2, 0)))

M_AREA = str(select())

select ADOL00

if !dbseek(dtos(M_DTAUFE))
  select &M_AREA
  return 0
endif

select &M_AREA

return M_PARVLR / ADOL00->UFESP

****************
function CAB_APU
****************

PG = PG + 1

  if PG > 1
    eject
  endif

?  "FIRMA        : "
?? AEMP00->EMPFAN
?? space(25)
?? "REGISTRO DE APURACAO DO I C M S"
?? space(34)
?? "EAGRO42B"
? "ENDERECO     : "
?? AEMP00->EMPEND
?? space(48)
? "INSC ESTADUAL: "
?? AEMP00->EMPIES
?? space(18)
?? "   MES OU PERIODO/ANO: "
?? M_DATA1
?? " A "
?? M_DATA2
?? space(16)
? "CGC (MF)     : "
?? transform(AEMP00->EMPCGC, "@R 999.999.999/9999-99")
? "PAGINA       : "
?? str(PG, 4)

? "*-----*------*----------*--------------------*--------------------*-------------------*-------------------*------------------------*"
? "* UF  * CFO  *  %ICMS   *   VALOR CONTABIL   *  BASE CALCULO ICMS * IMPOSTO DEBITADO  *      ISENTO       *         OUTRAS         *"
? "*-----*------*----------*--------------------*--------------------*-------------------*-------------------*------------------------*"

store  8 to LN

return ""

*****************
function CRIA_PAR
*****************

select APAR00

seek str(ME_EMP, 2, 0) + strzero(M_MES, 2, 0) + strzero(M_ANO, 2, 0)

if eof()
  seek str(00, 2, 0) + space(04)
  if eof()
    do while .t.
      append blank
      if neterr()
        msg("* * * (APAR00) ARQUIVO EM USO EXCLUSIVO) * * *")
        if lastkey()=17
          exit
        endif
        loop
      endif
      exit
    enddo
  endif
endif

do while .t.
  if rlock()
    replace  PAREMP   with  ME_EMP
    replace  PARMES   with  strzero(M_MES, 2, 0) + strzero(M_ANO, 2, 0)
    unlock
    commit
    exit
  else
    msg("* * * (APAR00) REGISTRO SENDO USADO * * *")
  endif
  if lastkey()=17
    exit
  endif
enddo
****************
function CFOPDES(F_TIPO)
****************

do case 
   case F_TIPO = 1253
   return "Compra Energia Eeletrica"
   case F_TIPO = 1102 .or. F_TIPO = 2102
   return "Compra para Comercializacao"
   case F_TIPO = 1303
   return "Servico de Comunicacao"
   case F_TIPO = 1353 .or. F_TIPO = 2353
   return "Servico de Transporte"
   case F_TIPO = 1403 .or. F_TIPO = 2403
   return "Compra Substituicao"
   case F_TIPO = 1406
   return "Compra Ativo Substituicao"
   case F_TIPO = 1407
   return "Compra p/uso consumo"
   case F_TIPO = 1551
   return "Compra Ativo"
   case F_TIPO = 1556
   return "Compra p/uso consumo"
   case F_TIPO = 1653
   return "Compra combustivel"
   case F_TIPO = 1910
   return "Doacao/Demonstracao/Bride" 
   case F_TIPO = 1911
   return "Amostra Gratis"
   case F_TIPO = 1949
   return "Outras entradas"
   case F_TIPO = 5102 .or. F_TIPO = 6102 
   return "Vende mercadoria"
   case F_TIPO = 5403
   return "Venda Substituicao"
   case F_TIPO = 5405
   return "Venda Substituicao"
   case F_TIPO = 5949
   return "Outras saidas"
   case F_TIPO = 6108
   return "Venda a nao contribuinte"
   case F_TIPO = 1411
   return "Devolucao C/Substituicao"
   case F_TIPO = 1202
   return "Devolucao de Vendas"

   case F_TIPO = 1908
   return "Entrada Contrato Comodato" 
   case F_TIPO = 1909
   return "Retorno Contrato Comodato" 
   case F_TIPO = 1933
   return "Aquisicao de Servico" 
   case F_TIPO = 2908
   return "Entrada Contrato Comodato" 

endcase

return ""

