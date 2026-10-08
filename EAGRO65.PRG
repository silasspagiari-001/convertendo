#include "ptmenu.ch"

***************
function MANSIX
***************
parameters M_OPC,M_OPC1,M_OPC2

    rodape("PREVISAO","CAIXA",M_FAN,"EAGRO65","Mem: " + str(memory(0), 5),M_EMP)

*     @ 07, 50 prompt "Titulos  " POSITION 1 HIGHLITE R/BG PERMITE 5,6,1
*     @ 08, 50 prompt "Aplica‡„o" POSITION 1 HIGHLITE R/BG PERMITE 5,6,2

   do case 
      case M_OPC = 1 ; relsix()
      case M_OPC = 2 ; relapi()
   endcase

return ""

***************
function RELSIX                        && relatorio sintetico fluxo de caixa
***************

M_CON = "N"

if ME_EMP # 1
  @ 24, 00 say "Consolida S/N: "
  SetColor(_COREDICAO_)
  @ 24, col() get M_CON picture "@!" valid M_CON $ "SN"
  read
endif
  
select 0         && nfs temporario

if file("&_PATH_\USR\FLUXO\APRV00.CDX")
  erase("&_PATH_\USR\FLUXO\APRV00.CDX")
endif

use &_PATH_\USR\FLUXO\APRV00 alias APRV00 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

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
      return
    endif

    select APRV00

    if !flock()
      msg("* * * (APRV00) ARQUIVO NAO DISPONIVEL * * *")
      return
    endif

    zap

    index on dtos(PRVDTA) tag 1 to &_PATH_\USR\FLUXO\APRV00
    set index to &_PATH_\USR\FLUXO\APRV00 

    if M_CON == "N"
      calc_apl(ME_EMP)
    else
      M_DTAANT = M_DTAINI
      calc_apl(1)
      M_DTAINI = M_DTAANT 
      calc_apl(51)
    endif

    M_IMPRE = impresn()

    if M_IMPRE = "N"
      return
    endif

    M_SALDO = 0
    LN      = 0
    PG      = 0

    cabvix02()

    select APRV00

    go top

    do while !eof()

      M_SALDO = M_SALDO + (PRVREC - PRVPAG)

      ? " "
        ?? PRVDTA
        ?? " "
        ?? diasem(PRVDTA)
        ?? " "
        ?? transform(PRVPAG,"@E@Z ###,###,###.##")
        ?? " "
        ?? transform(PRVREC,"@E@Z ###,###,###.##")
        ?? " "
        ?? transform(PRVREC-PRVPAG,"@E ###,###,###.##")
        ?? " "
        ?? transform(M_SALDO, "@E ###,###,###.##")
        ?? " "
        ?? iif(M_SALDO < 0,"D","C")

        LN ++

        skip

        if LN > 60
          cabvix02()
        endif

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

    ? replicate("-", 80)

    eject
 
    desliga1()

return ""


***************
function RELAPI
***************

    rodape("SINTETICO","APLICACAO",M_FAN,"EAGRO65","Mem: " + str(memory(0), 5),M_EMP)

    store  0               to M_APLINI, M_APLFIN, M_APLANT
    store  0               to PG,   LN, M_TOTLAX
    store ctod("  /  /  ") to M_DTAINI, M_DTAFIN

 nbox(12, 29, 15, 49,"W/W+",.t.)
 setcolor("B/W")
     @ 13, 30 say          " Periodo:          "
     @ 14, 30 say          "     Ate:          "
  SetColor(_COREDICAO_)

    @ 13, 40 get M_DTAINI 
    @ 14, 40 get M_DTAFIN
    read

    if lastkey() = 27
      return
    endif

    M_DTAINI = iif(empty(M_DTAINI),ctod("01/01/80"),M_DTAINI)
    M_DTAFIN = iif(empty(M_DTAFIN),ctod("31/12/79"),M_DTAFIN)

    msw("* * * PROCESSANDO CONTAS A RECEBER ... AGUARDE !!! (ESC) CANCELA * * *")

    select APLX00

    if !flock()
      msg("* * * (APLX00) ARQUIVO SENDO USADO * * *")
      return
    endif

    ( dbgotop() , dbseek(str(ME_EMP, 2, 0)) )

    do while !eof()
      if PLXEMP != ME_EMP
        go bottom
        skip
        loop 
      endif
      do while .t.
        if rlock()
          replace PLXVLR with 0
          unlock   
          commit
          exit
        else
          msg("* * * (APLX00) REGISTRO SENDO USADO * * *") 
        endif
        if lastkey()=17
          exit
        endif
      enddo
      skip
    enddo

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

      select APLX00

      if dbseek(str(ME_EMP, 2, 0) + str(ADCR00->DUPAPL, 3, 0))
        do while .t.
          if rlock()
            replace PLXVLR with PLXVLR + ADCR00->DUPVLO
            unlock   
            commit
            exit
          else
            msg("* * * (ADCR00) REGISTRO SENDO USADO * * *") 
          endif
          if lastkey()=17
            exit
          endif
        enddo
      endif

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

      select APLX00

      if dbseek(str(ME_EMP, 2, 0) + str(ADCP00->DUPAPL, 3, 0))
        do while .t.
          if rlock()
            replace PLXVLR with PLXVLR + ADCP00->DUPVLO
            unlock   
            commit
            exit
          else
            msg("* * * (ADCR00) REGISTRO SENDO USADO * * *") 
          endif
          if lastkey()=17
            exit
          endif
        enddo
      endif

      M_ESC = inkey()
 
      if M_ESC = 27
        store 2 to M_OPC 
        M_OPC = decide("Deseja Cancelar o Processamento")
        if M_OPC = 1 
          go bottom 
          skip
          return
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
      return
    endif

    store 0   to   PG ,;
                   LN 
    store " " to   BR

    M_TOTSGR = 0
    M_TOTREC = 0
    M_TOTDES = 0
    M_TOTGRP = 0
    M_SGRANT = 0
    M_100    = 0 
    M_200    = 0 
    M_300    = 0 
    M_400    = 0 
    M_500    = 0 
    M_600    = 0 
    M_700    = 0 
    M_800    = 0 
    M_900    = 0 

    select APLX00

    (dbgotop() , dbsetorder(3) , dbseek(str(ME_EMP, 2, 0)) )
   
    do while !eof()
      if PLXEMP != ME_EMP 
        go bottom
        skip
        loop
      endif
      S = left(str(PLXAPL, 3, 0), 1) + "00"
      M_&S = M_&S + PLXVLR
      skip
    enddo

    (dbgotop() , dbsetorder(3) , dbseek(str(ME_EMP, 2, 0)))

    do while !eof()  
          
      store PG + 1 to  PG 

       if PG > 1
         eject
       endif

          ? cent_cab(AEMP00->EMPFAN,"DEMOSTRATIVO SINTETICO DE PROVISAO","EAGRO65",80) 
          ? cent_cab(M_DATA,"PERIODO: " + dtoc(M_DTAINI) + " A " + dtoc(M_DTAFIN),"PAG.: " + str(PG, 4, 0), 80)
          ? "*---*---*---------------------------------------------------*------------------*"
          ? "*COD*GRP*NOME DA CONTA                                      *      VALOR       *"
          ? "*---*---*---------------------------------------------------*------------------*"
*             999 999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ###,###,###.###.##  

          store 6 to LN
  
          do while !eof() .and. LN < 60 
            
           if PLXEMP != ME_EMP 
             go bottom
             skip
             loop
           endif

           if right(str(PLXAPL, 3, 0), 2) == "00"
             if M_TOTSGR > 0 
               ? space(42)
                ?? chr(27) + "E"
                ??   "TOTAL SUBGRUPO     -=> " 
                ?? transform(M_TOTSGR,"@E ###,###,###.##")
                ?? chr(27) + "F"
               M_TOTSGR = 0
               LN = LN + 1
             endif 
             if M_TOTGRP > 0 
               ? space(42)
                ?? "TOTAL DO GRUPO     -=> " 
                ?? transform(M_TOTGRP,"@E ###,###,###.##")
               M_TOTGRP = 0
               M_TOTSGR = 0
               LN = LN + 1
             endif
             if PLXAPL = 500
               ? space(42)
                ?? "TOTAL DA DESPESA   -=> " 
                ?? transform(M_TOTDES,"@E ###,###,###.##")
               ? replicate("-", 80)
                LN = LN + 2 
             endif
             S = left(str(PLXAPL, 3, 0), 1) + "00"
             if M_&S = 0
               skip
               loop
             endif
             ?
              ? " *** "
              ?? transform(PLXAPL,"###")  
              ?? " "
              ?? pad(PLXNOM, 55)
             ?
             LN = LN + 3
             skip
             M_SGRANT = PLXGRP
             loop		
           endif

           if !right(str(PLXAPL, 3, 0), 2) == "00"
             if PLXVLR = 0
               skip
               loop
             endif
           endif

           if PLXGRP != M_SGRANT
             if M_TOTSGR > 0 
               ? space(42)
                ?? chr(27) + "E"
                ??   "TOTAL SUBGRUPO     -=> " 
                ?? transform(M_TOTSGR,"@E ###,###,###.##")
                ?? chr(27) + "F"
               M_TOTSGR = 0
               LN = LN + 1
             endif 
             M_SGRANT = PLXGRP
           endif

           ? " "
            ?? transform(PLXAPL,"###")  
            ?? " "
            ?? strzero(PLXGRP, 03)
            ?? " "
            ?? pad(PLXNOM, 51)
            ?? " " 
            ?? transform(PLXVLR,"@E ###,###,###,###.##")

           M_TOTGRP = M_TOTGRP + PLXVLR
           M_TOTSGR = M_TOTSGR + PLXVLR

           if PLXAPL < 499
             M_TOTDES = M_TOTDES + PLXVLR
           else
             M_TOTREC = M_TOTREC + PLXVLR
           endif

            LN = LN + 1 
 
            M_ESC = inkey()

            if M_ESC = 27
              if susimp()
                ? space(15)
                  ?? replicate("-", 80)
                ? space(15)
                  ?? "* * * IMPRESSAO SUSPENSA * * *"
                go bottom
                skip
              else
                M_ESC = inkey()
              endif
            endif

            skip

          enddo     

        enddo

        ? space(42) 
         ?? "TOTAL DA RECEITA   -=> " 
         ?? transform(M_TOTREC,"@E ###,###,###.##")
        ? replicate("-", 80)
        ? space(42)
         ?? "RECEITA - DESPESA  -=> "
         ?? transform(M_TOTREC - M_TOTDES,"@E ###,###,###.##")

    ? replicate("-", 80)

    eject

    unlock all
    desliga1()

return ""

*****************
function CALC_APL(TIPO)
*****************

    do while .t.

        if M_DTAINI > M_DTAFIN
          exit
        endif

        select ADCP00

        set order to 5

        set softseek on
          seek str(TIPO, 2, 0) + dtos(M_DTAINI)
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
            select APRV00
            if !dbseek(dtos(ADCP00->DUPVCT))
              append blank
              replace PRVDTA with ADCP00->DUPVCT
            endif
            replace PRVPAG with PRVPAG + ADCP00->DUPVLA
            msw("* * * AGUARDE ... PROCESSANDO !!! " + dtoc(M_DTAINI) + " * * *")
            select ADCP00
            skip
          enddo
        endif

        select ADCR00

        set order to 5

        set softseek on
          seek str(TIPO, 2, 0) + dtos(M_DTAINI)
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
            select APRV00
            if !dbseek(dtos(ADCR00->DUPVCT))
              append blank
              replace PRVDTA with ADCR00->DUPVCT
            endif
            replace PRVREC with PRVREC + ADCR00->DUPVLA
            msw("* * * AGUARDE ... PROCESSANDO !!! " + dtoc(M_DTAINI) + " * * *")
            select ADCR00
            skip
          enddo
        endif

        M_DTAINI = M_DTAINI + 1

        if inkey() = 27
          if suspro()
            msg("* * * PROCESSO SUSPENSO * * *")
            exit
          endif
       endif

    enddo

return ""