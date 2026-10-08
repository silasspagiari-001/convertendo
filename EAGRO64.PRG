#include "ptmenu.ch"

***************
function MANANX
***************
parameters M_OPC,M_OPC1,M_OPC2

*     @ 07, 50 prompt "Titulos  " POSITION 1 HIGHLITE R/BG PERMITE 4,6,1
*     @ 08, 50 prompt "Aplica‡„o" POSITION 1 HIGHLITE R/BG PERMITE 4,6,2
*     @ 09, 50 prompt "Caixa    " POSITION 1 HIGHLITE R/BG PERMITE 4,6,3

   do case 
      case M_OPC = 1 ; relanx()
      case M_OPC = 2 ; relapx()
      case M_OPC = 3 ; relcai()
   endcase


return ""

***************
function RELANX
***************


abre_dcr("2") && aplicacoes
abre_dcp("3") && lancamentos
abre_cli("4") && clientes    
abre_por("5") && portadores  
abre_for("6") && fornecedor  

  do while .t.

    rodape("PREVISAO","CAIXA",M_FAN,"EAGRO64","Mem: " + str(memory(0), 5),M_EMP) 

    store ctod("  /  /  ")     to M_DTAINI ,;
                                  M_DTAFIN 

    store  0 to PG, LN, M_SALDO

 nbox(12, 29, 15, 49,"W/W+",.t.)
 setcolor("B/W")
     @ 13, 30 say          " Periodo:          "
     @ 14, 30 say          "     Ate:          "
    SetColor(_COREDICAO_)

    @ 13, 40 get M_DTAINI 
    @ 14, 40 get M_DTAFIN 
    read

    M_DTAINI = iif(empty(M_DTAINI),firstday(date()),M_DTAINI)
    M_DTAFIN = iif(empty(M_DTAFIN),lastday(M_DTAINI) ,M_DTAFIN)

    if lastkey() = 27
      exit
    endif

    M_IMPRE = impresn()

    if M_IMPRE = "N"
      exit
    endif

    if AEMP00->EMPIMP = 80
      ?? chr(15)
    endif 

    M_SALDO = 0

    cabvix01()

    do while .t.

        if M_DTAINI > M_DTAFIN
          exit
        endif

        select ADCP00

        set order to 5

        set softseek on
          seek str(ME_EMP, 2, 0) + dtos(M_DTAINI)
        set softseek off

        if DUPVCT = M_DTAINI 
          do while !eof()
            if DUPVCT != M_DTAINI
              exit
            endif
            if DUPHIS != 500
              skip
              loop
            endif
            if DUPPOR > 90000
              skip
              loop
            endif
            M_SALDO = M_SALDO - DUPVLA
            AFOR00->(dbseek(str(ADCP00->DUPFOR, 5, 0)))
            APOR00->(dbseek(str(ADCP00->DUPPOR, 5, 0)))
            ? " "
             ?? DUPVCT
             ?? " "
             ?? str(DUPNUM, 6, 0)
             ?? "/"
             ?? strzero(DUPORD, 2, 0)
             ?? " "
             ?? str(DUPFOR, 5, 0)
             ?? " "
             ?? pad(AFOR00->FORNOM, 40)
             ?? " "
             ?? pad(APOR00->PORNOM, 17)
             ?? " "
             ?? transform(DUPVLA,"@E ###,###,###.##") 
             ?? " "
             ?? space(14)
             ?? " "
             ?? transform(abs(M_SALDO),"@E ###,###,###.##")
             ?? " "
             ?? iif(M_SALDO < 0,"D","C")
             store LN + 1 to LN
             if LN > 60
               cabvix01()
             endif
             skip
          enddo
        endif

        select ADCR00

        set order to 5

        set softseek on
          seek str(ME_EMP, 2, 0) + dtos(M_DTAINI)
        set softseek off

        if DUPVCT = M_DTAINI 
          do while !eof()
            if DUPVCT != M_DTAINI
              exit
            endif
            if DUPHIS != 500
              skip
              loop
            endif
            if DUPPOR > 90000
              skip
              loop
            endif
            M_SALDO = M_SALDO + DUPVLA
            ACLI00->(dbseek(str(ADCR00->DUPCLI, 5, 0)))
            APOR00->(dbseek(str(ADCR00->DUPPOR, 5, 0)))
            ? " "
             ?? DUPVCT
             ?? " "
             ?? str(DUPNUM, 6, 0)
             ?? "/"
             ?? strzero(DUPORD, 2, 0)
             ?? " "
             ?? str(DUPCLI, 5, 0)
             ?? " "
             ?? pad(ACLI00->CLINOM, 40)
             ?? " "
             ?? pad(APOR00->PORNOM, 17)
             ?? " "
             ?? space(14)
             ?? " "
             ?? transform(DUPVLA,"@E ###,###,###.##") 
             ?? " "
             ?? transform(abs(M_SALDO),"@E ###,###,###.##")
             ?? " "
             ?? iif(M_SALDO < 0,"D","C")

             store LN + 1 to LN
             if LN > 60
               cabvix01()
             endif
             skip
          enddo
        endif

        M_DTAINI = M_DTAINI + 1
          
        M_ESC = inkey()

        if M_ESC = 27
          if susimp()
            ? "        ------------------------------"
            ? "        * * * IMPRESSAO SUSPENSA * * *"
            exit
          else
            M_ESC = inkey()
          endif
        endif

    enddo

    ? replicate("-", 132)

    eject

desliga1()

  enddo

  fecha_arq()

return "" 

*****************
function CABVIX01
*****************

 PG = PG + 1
     
 if PG > 1
   eject
 endif

 ? cent_cab(AEMP00->EMPFAN,"PREVISAO ANALITICA DE CAIXA","EAGRO33F",132) 
 ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
 ? "*--------*---------*-----*----------------------------------------*-----------------*--------------*--------------*--------------*-*"
 ? "* DATA   * DOCTO   * COD * HISTORICO                              *    PORTADOR     *   A PAGAR    *  A RECEBER   *    SALDO     *T*"
 ? "*--------*---------*-----*----------------------------------------*-----------------*--------------*--------------*--------------*-*"
*    99/99/99 999999/99 99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX ###,###,###,## ###,###,###.## ###,###,###.## X 
 
store 5 to LN

return ""


*****************
function CABVIX02
*****************

 PG = PG + 1
     
 if PG > 1
   eject
 endif

 ? cent_cab(AEMP00->EMPFAN,"PREVISAO SINTETICA DE CAIXA","EAGRO33F",80) 
 ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 80)
 ? "*--------*-------*--------------*--------------*--------------*--------------*-*"
 ? "*  DATA  * SEMANA* PAGAR        * RECEBER      * DIFERENCA    * SALDO        *T*"
 ? "*--------*-------*--------------*--------------*--------------*--------------*-*"
*    99/99/99 DOMINGO ###,###,###.## ###,###,###.## ###,###,###.## ###,###,###.## X

 
store 5 to LN

return ""

*****************
function CABVIX03
*****************

 PG = PG + 1
     
 if PG > 1
   eject
 endif

 ? space(06) + cent_cab(AEMP00->EMPFAN,"MOVIMENTACAO DO CAIXA DIARIO","EAGRO33F",74) 
 ? space(06) + cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 74)
 ? "      +--------+-----------+-----------+-----------+-----------+-----------+---+"
 ? "      | DATA   |  ENTRADAS |  SAIDAS   | DEPOSITOS | DIFERENCA |  SALDO    |D/C|"
 ? "      +--------+-----------+-----------+-----------+-----------+-----------+---+"
*           99/99/99 9999,999.99 9999,999.99 9999,999.99 9999,999.99 9999,999.99
store 5 to LN

return ""

***************
function RELAPX
***************

msw("* * * AGUARDE... ABRINDO ARQUIVOS * * *")

abre_dcr("2") && aplicacoes
abre_dcp("3") && lancamentos
abre_cli("4") && clientes    
abre_por("5") && portadores  
abre_for("6") && fornecedor  
abre_plx("7") && fornecedor  
abre_apx("8") && analitico fluxo de caixa aplicacao

  do while .t.

    rodape("ANALITICO","APLICACAO",M_FAN,"EAGRO64","Mem: " + str(memory(0), 5),M_EMP) 

    store  0               to M_APLINI, M_APLFIN, M_APLANT
    store  0               to PG,   LN, M_TOTLAX
    store ctod("  /  /  ") to M_DTAINI, M_DTAFIN

 nbox(12, 29, 17, 49,"W/W+",.t.)
 setcolor("B/W")
     @ 13, 30 say          "Conta Inicial:     "
     @ 14, 30 say          "        Final:     "
     @ 15, 30 say          " Periodo:          "
     @ 16, 30 say          "     Ate:          "
    SetColor(_COREDICAO_)
    @ 13, 45 get M_APLINI picture "###"
    @ 14, 45 get M_APLFIN picture "###"
    @ 15, 40 get M_DTAINI 
    @ 16, 40 get M_DTAFIN
    read

    M_DTAINI = iif(empty(M_DTAINI),ctod("01/01/80"),M_DTAINI)
    M_DTAFIN = iif(empty(M_DTAFIN),ctod("31/12/79"),M_DTAFIN)
    M_APLINI = iif(M_APLINI=0,  1,M_APLINI)
    M_APLFIN = iif(M_APLFIN=0,999,M_APLFIN)

    if lastkey() = 27
      exit
    endif

    select AAPX00

    if !flock()
      msg("* * * (AAPX00) ARQUIVO NAO DISPONIVEL * * *")
      loop
    endif

    zap

    index on str(APXAPL, 3, 0) tag 1 to &_PATH_\USR\FLUXO\AAPX00
    set index to &_PATH_\USR\FLUXO\AAPX00

*
**  contas a receber
*

    msw("* * * PROCESSANDO CONTAS A RECEBER ... AGUARDE !!! (ESC) CANCELA * * *")

    select ADCR00

    ( dbsetorder(4) , dbseek(str(ME_EMP, 2, 0) + dtos(M_DTAINI),.t.) )

    do while !eof()

      if str(DUPEMP, 2, 0) + dtos(DUPDTE) > str(ME_EMP, 2, 0) + dtos(M_DTAFIN)
        go bottom
        skip
        loop
      endif

      if DUPAPL = 0
        skip
        loop
      endif

      if DUPPOR > 90000 
        skip
        loop
      endif

      if DUPAPL > M_APLFIN .or. DUPAPL < M_APLINI
        skip
        loop
      endif

      ACLI00->(dbseek(str(ADCR00->DUPCLI, 5, 0)))
      APOR00->(dbseek(str(ADCR00->DUPPOR, 5, 0)))

      select AAPX00

      append blank

      replace APXAPL with ADCR00->DUPAPL
      replace APXDUP with ADCR00->DUPNUM
      replace APXORD with ADCR00->DUPORD
      replace APXDTE with ADCR00->DUPDTE
      replace APXVCT with ADCR00->DUPVCT
      replace APXCLF with ADCR00->DUPCLI
      replace APXHIS with ACLI00->CLINOM
      replace APXPOR with APOR00->PORNOM
      replace APXOBS with ADCR00->DUPOBS
      replace APXVLR with ADCR00->DUPVLO

      M_ESC = inkey()
 
      if M_ESC = 27
        store 2 to M_OPC 
        M_OPC = decide("Deseja Cancelar o Processamento")
        if M_OPC = 1 
          go bottom 
          skip
          loop
        else
          M_ESC = inkey()
          msw("* * * P R O C E S S A N D O - (ESC) Cancela * * *")
        endif
      endif 

      select ADCR00

      skip

    enddo 

*
**  contas a pagar
*
    msw("* * * PROCESSANDO CONTAS A PAGAR ... AGUARDE !!! (ESC) CANCELA * * *")

    select ADCP00

    ( dbsetorder(4) , dbseek(str(ME_EMP, 2, 0) + dtos(M_DTAINI),.t.) )

    do while !eof()

      if str(DUPEMP, 2, 0) + dtos(DUPDTE) > str(ME_EMP, 2, 0) + dtos(M_DTAFIN)
        go bottom
        skip
        loop
      endif

      if DUPAPL = 0
        skip
        loop
      endif

      if DUPPOR > 90000 
        skip
        loop
      endif

      if DUPAPL > M_APLFIN .or. DUPAPL < M_APLINI
        skip
        loop
      endif

      AFOR00->(dbseek(str(ADCP00->DUPFOR, 5, 0)))
      APOR00->(dbseek(str(ADCP00->DUPPOR, 5, 0)))

      select AAPX00

      append blank

      replace APXAPL with ADCP00->DUPAPL
      replace APXDUP with ADCP00->DUPNUM
      replace APXORD with ADCP00->DUPORD
      replace APXDTE with ADCP00->DUPDTE
      replace APXVCT with ADCP00->DUPVCT
      replace APXCLF with ADCP00->DUPFOR
      replace APXHIS with AFOR00->FORNOM
      replace APXPOR with APOR00->PORNOM
      replace APXOBS with ADCP00->DUPOBS
      replace APXVLR with ADCP00->DUPVLO

      M_ESC = inkey()
 
      if M_ESC = 27
        store 2 to M_OPC 
        M_OPC = decide("Deseja Cancelar o Processamento")
        if M_OPC = 1 
          go bottom 
          skip
          loop
        else
          M_ESC = inkey()
          msw("* * * P R O C E S S A N D O - (ESC) Cancela * * *")
        endif
      endif 

      select ADCP00

      skip

    enddo 

    M_IMPRE = impresn()

    if M_IMPRE = "N"
      exit
    endif

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(15)                        && comprime
    endif

    select AAPX00

    set relation to str(ME_EMP, 2, 0) + str(APXAPL, 3, 0) into APLX00

    go top

    cab_apx()

    M_SALDO  = 0
    M_APXANT = 0
    M_TOTSLD = 0
    M_TOTREC = 0
    M_TOTDES = 0

    do while !eof()

      if APXAPL != M_APXANT
        if M_TOTSLD > 0
          ? space(91) 
            ?? "TOTAL DOS LANCAMENTOS -=> " 
            ?? transform(M_TOTSLD,"@E ###,###,###.##")
          ? replicate("-", 132)
          LN = LN + 2
        endif
        ? "*** "
          ?? str(APXAPL, 3, 0)
          ?? " "
          ?? APLX00->PLXNOM
          ?? " SubGrupo: "
          ?? APLX00->PLXGRP
        ?
        M_APXANT = APXAPL
        LN = LN + 2
        M_TOTSLD = 0
      endif
              
       ? space(01)
        ?? APXDUP
        ?? "/"
        ?? strzero(APXORD, 2, 0)
        ?? " "
        ?? APXDTE
        ?? " "
        ?? APXVCT
        ?? " "
        ?? APXCLF
        ?? " "
        ?? APXHIS
        ?? " "
        ?? APXPOR
        ?? " "
        ?? APXOBS
        ?? " "
        ?? transform(APXVLR,"@E ###,###,###.##")  
     
        LN++
 
        M_TOTSLD = M_TOTSLD + APXVLR
 
        if APXAPL < 499
          M_TOTDES = M_TOTDES + APXVLR
        else
          M_TOTREC = M_TOTREC + APXVLR
        endif

        if LN > 60
          cab_apx()
        endif

        M_ESC = inkey()

          if M_ESC = 27
            if susimp()
              ? replicate("Ä", 132)
              ? "* * * IMPRESSAO SUSPENSA * * *"
              go bottom
              skip
              loop              
            else
              M_ESC = inkey()
            endif
          endif

        skip
      
      enddo
     ? space(91) 
       ?? "TOTAL DOS LANCAMENTOS -=> " 
       ?? transform(M_TOTSLD,"@E ###,###,###.##")
     ? replicate("-", 132)
     ? space(01)
       ??" Receitas  -=> "
       ?? transform(M_TOTREC,"@E ###,###,###,###.##")  
       ??" Despesas  -=> "
       ?? transform(M_TOTDES,"@E ###,###,###,###.##")  
       ??" Receita - Despesa -=> "
       ?? transform(M_TOTREC - M_TOTDES,"@E ###,###,###,###.##")  

    eject

desliga1()

  enddo

  fecha_arq()

return ""

****************
function CAB_APX
****************

 store PG + 1 to  PG 

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE PROVISAO ANALITICA","EAGRO64",132) 
  ? cent_cab(M_DATA,"PERIODO: " + dtoc(M_DTAINI) + " A " + dtoc(M_DTAFIN),"PAG.: " + str(PG, 4, 0), 132)
  ? "*---------*--------*--------*-----*---------------------------------------*-------------------*---------------------*--------------*" 
  ? "* TITULO  *EMISSAO *VENCTO  * COD * C L I E N T E  /  F O R N E C E D O R *  P O R T A D O R  *     OBSERVACOES     *    VALOR     *" 
  ? "*---------*--------*--------*-----*---------------------------------------*-------------------*---------------------*--------------*" 
  *   999999/99 99/99/99 99/99/99 99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXX ###,###,###.## 

  store 5 to LN
              
return ""

***************
function RELCAI
***************

abre_dcr("2") && aplicacoes
abre_dcp("3") && lancamentos
abre_cli("4") && clientes    
abre_por("5") && portadores  
abre_lab("6") && lancamento bancario
abre_for("7") && fornecedores

  do while .t.

    rodape("CAIXA","REAL",M_FAN,"EAGRO64","Mem: " + str(memory(0), 5),M_EMP)

    store ctod("  /  /  ")     to M_DTAINI ,;
                                  M_DTAFIN 
    store  0 to PG, LN, M_SALDO

 nbox(12, 29, 15, 49,"W/W+",.t.)
 setcolor("B/W")
     @ 13, 30 say          " Periodo:          "
     @ 14, 30 say          "     Ate:          "
    SetColor(_COREDICAO_)
    @ 13, 40 get M_DTAINI
    @ 14, 40 get M_DTAFIN 
    read

    M_DTAINI = iif(empty(M_DTAINI),firstday(date()),M_DTAINI)
    M_DTAFIN = iif(empty(M_DTAFIN),lastday(M_DTAINI) ,M_DTAFIN)

    if lastkey() = 27
      exit
    endif

    M_IMPRE = impresn()

    if M_IMPRE = "N"
      exit
    endif

    ?? chr(18)

    M_SALDOINI = AEMP00->EMPCAI

    M_SALDO = 0

    cabvix03()
    
    M_DATA2 = ctod("01/02/2002")

    do while .t.

        M_PAGAS  = 0  
        M_RECEBE = 0
        M_DEPOSITO = 0

        if M_DATA2 >= M_DTAINI
          exit
        endif

        select ADCP00
        set order to 7

        dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA2),.t.)

        if DUPDTP = M_DATA2
          do while !eof()
            if DUPDTP != M_DATA2
              exit
            endif
            if DUPHIS # 100
              skip
              loop
            endif
            if DUPPOR # 1
              skip
              loop
            endif
            M_PAGAS += DUPVLP
            skip
          enddo
        endif

        select ADCR00
        set order to 7

        dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA2),.t.)

        if DUPDTP = M_DATA2
          do while !eof()
            if DUPDTP != M_DATA2
              exit
            endif
            if DUPHIS # 100
              skip
              loop
            endif
            if DUPPOR # 1
              skip
              loop
            endif
            M_RECEBE += DUPVLP
            skip
          enddo
        endif

        select ALAB00
        set order to 1

        dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA2),.t.)

        if LANDTA = M_DATA2
          do while !eof()
            if LANDTA != M_DATA2
              exit
            endif
            if !CAIXA == "S"
              skip
              loop
            endif
            if LANTIP == "D"
              M_DEPOSITO += LANVLR
            else
              M_DEPOSITO -= LANVLR
            endif
            skip
          enddo
        endif

        M_SALDOINI = M_SALDOINI + M_RECEBE - M_PAGAS - abs(M_DEPOSITO)

        M_DATA2 ++

    enddo

    M_SALDO = M_SALDOINI    

    ?? chr(27) + "E"
    ? "                                   SALDO DISPONIVEL ANTERIOR " 
    ?? transform(abs(M_SALDO),"@E ###,###,###.##")
    ?? "   "
    ?? iif(M_SALDO < 0,"D","C")
    ?? chr(27) + "F"
    ?

    LN += 2

    do while .t.

        M_PAGAS    = 0
        M_RECEBE   = 0
        M_DEPOSITO = 0

        if M_DTAINI > M_DTAFIN
          exit
        endif

        select ADCP00
        set order to 7

        dbseek(str(ME_EMP, 2, 0) + dtos(M_DTAINI),.t.)

        if DUPDTP = M_DTAINI 
          do while !eof()
            if DUPDTP != M_DTAINI
              exit
            endif
            if DUPHIS # 100
              skip
              loop
            endif
            if DUPPOR # 1
              skip
              loop
            endif
            M_PAGAS += DUPVLP
            skip
          enddo
        endif

        select ADCR00
        set order to 7

        dbseek(str(ME_EMP, 2, 0) + dtos(M_DTAINI),.t.)

        if DUPDTP = M_DTAINI 
          do while !eof()
            if DUPDTP != M_DTAINI
              exit
            endif
            if DUPHIS # 100
              skip
              loop
            endif
            if DUPPOR # 1
              skip
              loop
            endif
            M_RECEBE += DUPVLP
            skip
          enddo
        endif

        select ALAB00
        set order to 1

        dbseek(str(ME_EMP, 2, 0) + dtos(M_DTAINI),.t.)
        
        if LANDTA = M_DTAINI
          do while !eof()
            if LANDTA != M_DTAINI
              exit
            endif
            if !CAIXA == "S"
              skip
              loop
            endif
            if LANTIP == "D"
              M_DEPOSITO += LANVLR
            else
              M_DEPOSITO -= LANVLR
            endif
            skip
          enddo
        endif

        M_SALDO = M_SALDO + M_RECEBE - M_PAGAS - abs(M_DEPOSITO)

        ? "       "
        ?? M_DTAINI
        ?? " "
        ?? transform(M_RECEBE,"@E@Z ####,###.##") 
        ?? " "
        ?? transform(M_PAGAS,"@E@Z ####,###.##") 
        ?? " "
        ?? transform(abs(M_DEPOSITO),"@E@Z ###,###.##") 
        if abs(M_DEPOSITO) # 0
          ?? iif(M_DEPOSITO<0,"D","C")
        else
          ?? " "
        endif
        ?? " "
        ?? transform(M_RECEBE - M_PAGAS - abs(M_DEPOSITO),"@E@Z ####,###.##") 
        ?? " "
        ?? transform(abs(M_SALDO),"@E@Z ####,###.##")
        ?? "   "
        ?? iif(M_SALDO < 0,"D","C")

        M_DTAINI = M_DTAINI + 1
        LN ++
        if LN > 60
          LN = 0
          cabvix03()
        endif

        if inkey() = 27
          if susimp()
            ? "        ------------------------------"
            ? "        * * * IMPRESSAO SUSPENSA * * *"
            exit
          endif
        endif

    enddo

    ? replicate("-", 80)

    eject

desliga1()

  enddo

  fecha_arq()

return "" 
