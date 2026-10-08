***************
function DEMONX
***************

select 0         && nfs temporario

if file("&_PATH_\USR\FLUXO\ADEM00.CDX")
  erase("&_PATH_\USR\FLUXO\ADEM00.CDX")
endif

use &_PATH_\USR\FLUXO\ADEM00 alias ADEM00 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  return
endif

    rodape("RESUMO","SINTETICO",M_FAN,"EAGRO66","Mem: " + str(memory(0), 5),M_EMP)

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

    msw("* * * P R O C E S S A N D O - (ESC) Cancela * * *")

    select ADEM00

    if !flock()
      msg("* * * (ADEM00) ARQUIVO NAO DISPONIVEL * * *")
      return
    endif

    zap
    index on str(DEMAPL, 3, 0) tag 1 to &_PATH_\USR\FLUXO\ADEM00
    set index to &_PATH_\USR\FLUXO\ADEM00

    select ALAX00

    dbseek(str(ME_EMP, 2, 0) + dtos(M_DTAINI),.t.)

    do while !eof()

      if str(LAXEMP, 2, 0) + dtos(LAXDTA) > str(ME_EMP, 2, 0) + dtos(M_DTAFIN)
        go bottom
        skip
        loop
      endif

      select ADEM00

      if !dbseek(str(ALAX00->LAXAPL, 3, 0))
        append blank
        replace DEMAPL with ALAX00->LAXAPL
      endif

      replace DEMVLR with DEMVLR + ALAX00->LAXVLR

      select ALAX00

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

      skip

    enddo 

    M_IMPRE = impresn()

    if M_IMPRE = "N"
      return
    endif

    ?? chr(27) + "0"

    select ADEM00

    go top

    M_CTAANT = " "
    M_FLAG   = .f.
    M_FLAG1  = .f.
    M_TOTGRU = 0
    M_TOTDEB = 0
    M_TOTCRE = 0
    PG       = 0

    do while !eof()                    && calcula saldo anterior

      PG = PG + 1
     
      if PG > 1
        eject
      endif

      ?
      ? cent_cab("","D  E  M  O  N  S  T  R  A  T  I  V  O","",80)
      ?
      ? cent_cab("","PERIODO: " + dtoc(M_DTAINI) + " A " + dtoc(M_DTAFIN),"",80)
      ?
      ? cent_cab("",chr(27) + "E" + alltrim(AEMP00->EMPFAN) + chr(27) + "F","",80)

      store 6 to LN

      do while !eof() .and. LN < 80

         APLX00->(dbseek(str(ADEM00->DEMAPL, 3, 0)))

         if left(str(DEMAPL, 3, 0), 1) != M_CTAANT
           if M_FLAG = .t.
             ?
             ? "   TOTAL DO GRUPO ............... "
               ?? chr(27) + "E"
               ?? transform(M_TOTGRU,"@E ###,###,###.##")
               ?? chr(27) + "F"
             LN = LN + 2
             M_TOTGRU = 0
           endif      
           if left(str(DEMAPL, 3, 0), 1) = "5"
             if M_FLAG1 = .f.
               ? 
               ? "SALDO GERAL (DESPESA) .......................... "
                 ?? chr(27) + "E"
                 ?? transform(M_TOTDEB,  "@E ###,###,###.##")
                 ?? chr(27) + "F"
               M_FLAG1 = .t.
               LN = LN + 2
             endif
           endif
         endif
 
         if right(str(DEMAPL, 3, 0), 2) == "00"
           ?
           ? " *** "
            ?? transform(DEMAPL,"###")  
            ?? " "
            ?? pad(APLX00->PLXNOM, 55)
           ?
           LN = LN + 3
           skip 
           loop
         endif

         ? "    "
           ?? left(APLX00->PLXNOM, 29)
           ?? " "
           ?? transform(DEMVLR,"@E ###,###,###.##")

         if DEMAPL < 500
           M_TOTDEB = M_TOTDEB + DEMVLR
         else
           M_TOTCRE = M_TOTCRE + DEMVLR
         endif

         M_TOTGRU = M_TOTGRU + DEMVLR

        LN = LN + 1 
          
        M_ESC = inkey()

        if M_ESC = 27
          if susimp()
            ? "        ------------------------------"
            ? "        * * * IMPRESSAO SUSPENSA * * *"
            go bottom
            skip
            loop              
          else
            M_ESC = inkey()
          endif
        endif

        skip

      enddo

    enddo

    ?
    ? "   TOTAL DO GRUPO ............... "
      ?? chr(27) + "E"
      ?? transform(M_TOTGRU,"@E ###,###,###.##")
      ?? chr(27) + "F"
    ?
    ? "SALDO GERAL (RECEITA) .......................... "
      ?? chr(27) + "E"
      ?? transform(M_TOTCRE,"@E ###,###,###.##")
      ?? chr(27) + "F"
    ? 
    ? "SALDO GERAL (RECEITA - DESPESA)........................... "
     ?? chr(27) + "E"
     ?? transform((M_TOTCRE - M_TOTDEB),"@E ###,###,###.##")
     ?? chr(27) + "F"
    ?
    ?
    ?
    ?
    ?
    ? "        ________________________          ________________________"
    ?
    ? "                                                                  " 
    ?

    eject

    ?? chr(27) + "@"
 
    desliga1()

return "" 
