#include "ptmenu.ch"

***************
function MANLAX
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("MENU","LANCAMENTO",M_FAN,"EAGRO63","Mem: " + str(memory(0), 5),M_EMP)

*        @ 05, 50 prompt "Inclus„o " HIGHLITE R/BG PERMITE 3,6,1
*        @ 06, 50 prompt "Altera‡„o" HIGHLITE R/BG PERMITE 3,6,2
*        @ 07, 50 prompt "Consultas" HIGHLITE R/BG PERMITE 3,6,3
*        @ 08, 50 prompt "Exclus„o " HIGHLITE R/BG PERMITE 3,6,4
*        @ 09, 50 prompt "Listagens" HIGHLITE R/BG PERMITE 3,6,5
*        @ 10, 50 prompt "Outros   " HIGHLITE R/BG PERMITE 3,6,6

      do case
         case M_OPC = 1 ; inclax()
         case M_OPC = 2 ; altlax()   
         case M_OPC = 3 ; conlax()     
         case M_OPC = 4 ; exclax()   
         case M_OPC = 5 ; lislax(M_OPC1)
      endcase

    fecha_arq()

return ""

***************  
function INCLAX          && inclui Lancamento  
***************  

private L    ,;
        M_OPC

    rodape("INCLUI","LANCAMENTO",M_FAN,"EAGRO63","Mem: " + str(memory(0), 5),M_EMP) 

    M_LAXEMP   = ME_EMP
    M_LAXDTA   = ctod("  /  /  ")

    do while .t.

      tllax01()                         && monta tela inicial 

      M_LAXSEQ   = 0
      M_LAXAPL   = 0
      M_LAXHIS   = space(52)
      M_LAXTIP   = " "
      M_LAXVLR   = 0

      SetColor(_COREDICAO_)
      @ 09, 26 get     M_LAXDTA       valid verlax01()
      read

      if ALAX00->(dbseek(str(M_LAXEMP, 2, 0) + dtos(M_LAXDTA) + str(M_LAXSEQ, 6, 0)))
        msg("* * * LANCAMENTO JA CADASTRADO * * *")
        loop
      endif

      if lastkey() = 27 
        exit
      endif        

      edlax01()
    
      M_OPC = confirma("Inclusao deste Lancamento")

      if M_OPC =  1
        select ALAX00
        _append("ALAX00")
        grlax01()                      && grava plaxo de contas
        msg("* * * LANCAMENTO INCLUIDO * * *")
      else 
        msg("* * * LANCAMENTO NAO INCLUIDO * * *") 
      endif

  enddo

return ""

***************
function ALTLAX
***************
        
    do while .t.
   
      M_LAXEMP   = ME_EMP
      M_LAXDTA = ctod("  /  /  ")
      M_LAXSEQ = 0

      tllax01() 

      rodape("ALTERA","LANCAMENTO",M_FAN,"EAGRO63","Mem: " + str(memory(0), 5),M_EMP) 

      SetColor(_COREDICAO_)
      @ 09, 26 get     M_LAXDTA
      @ 10, 26 get     M_LAXSEQ picture "######"
      read
 
      if M_LAXDTA = ctod("  /  /  ")
        exit
      endif

      if !ALAX00->(dbseek(str(M_LAXEMP, 2, 0) + dtos(M_LAXDTA) + str(M_LAXSEQ, 6, 0)))
        msg("* * * LANCAMENTO NAO CADASTRADO * * *")
        loop
      endif

      mslax01()                      && mostra dados do lancamento

      if !rlock()
        msg("* * * (ALAX00) REGISTRO SENDO USADO * * *")
        loop
      endif

      M_LAXAPL = ALAX00->LAXAPL
      M_LAXHIS = ALAX00->LAXHIS
      M_LAXTIP = ALAX00->LAXTIP
      M_LAXVLR = ALAX00->LAXVLR

      edlax01() 

      if lastkey() = 27
        msg("* * * LANCAMENTO NŽO ALTERADO * * *")
        unlock
        loop 
      endif

      grlax01()                      && grava dados do lancamento

      msg("* * * LANCAMENTO ALTERADO * * *")

    enddo

return ""

***************
function CONLAX
***************

private L    ,;
        M_OPC

    do while .t.

       M_DTAINI = ctod("  /  /  ")
       M_DTAFIN = ctod("  /  /  ")

       tllax02()

       rodape("CONSULTA","LANCAMENTO",M_FAN,"EAGRO63","Mem: " + str(memory(0), 5),M_EMP) 

      SetColor(_COREDICAO_)
        @ 06, 30 get      M_DTAINI
        @ 06, 41 get      M_DTAFIN
        read

        if lastkey() = 27 
          exit
        endif

        M_DTAINI = iif(empty(M_DTAINI),ctod("01/01/80"),M_DTAINI)
        M_DTAFIN = iif(empty(M_DTAFIN),ctod("31/12/79"),M_DTAFIN)

        M_SALDO = 0

        select ALAX00

        dbseek(str(ME_EMP, 2, 0) + dtos(ctod("01/01/80")), .t.) 

        if str(LAXEMP, 2, 0) + dtos(LAXDTA) > str(ME_EMP, 2, 0) + dtos(M_DTAFIN)
          msg("* * * NADA A CONSULTAR NO INTERVALO * * *")
          loop
        endif

        do while !eof()
          if str(LAXEMP, 2, 0) + dtos(LAXDTA) >= str(ME_EMP, 2, 0) + dtos(M_DTAINI)
            exit
          endif
          if LAXTIP = "C"
             M_SALDO = M_SALDO + LAXVLR
          else
             if LAXTIP = "D"
                M_SALDO = M_SALDO - LAXVLR
             endif
          endif
          skip

        enddo

        set color to I
          @ 06, 61 say M_SALDO picture "@E ###,###,###.##"
        set color to 

        L = 10

        do while !eof()

          if str(LAXEMP, 2, 0) + dtos(LAXDTA) > str(ME_EMP, 2, 0) + dtos(M_DTAFIN)
            exit
          endif

          if LAXTIP = "C"
             M_SALDO = M_SALDO + LAXVLR
          else
             if LAXTIP = "D"
                M_SALDO = M_SALDO - LAXVLR
             endif
          endif

          set color to I
            @ L,  5 say LAXDTA   
            @ L, 14 say LAXSEQ picture "######"
            @ L, 21 say pad(LAXHIS, 26)
            @ L, 48 say LAXAPL picture "###"
            @ L, 52 say LAXVLR picture "@E ###,###.##"
            @ L, 63 say LAXTIP
            @ L, 65 say M_SALDO picture "@E ###,###.##"
          set color to

          if L > 17
            msg("* * * (ESC) Sai  (ENTER) Continua * * *")
            if lastkey() = 27 
              exit
            endif
            set color to I
            for K = 10 to 18
              @ K,  5 say space(08)
              @ K, 14 say space(06)
              @ K, 21 say space(26)
              @ K, 48 say space(03)
              @ K, 52 say space(10)
              @ K, 63 say space(01)
              @ K, 65 say space(10)
            next
            set color to
            L = 9
          endif

          L = L + 1

          skip

       enddo

       msg("* * * FIM DA CONSULTA * * *") 

  enddo

return ""

***************
function EXCLAX
***************
        
private M_OPC
             
    do while .t.

      M_LAXEMP   = ME_EMP
      M_LAXDTA = ctod("  /  /  ") 
      M_LAXSEQ = 0

      tllax01() 
 
      rodape("EXCLUI","LANCAMENTO",M_FAN,"EAGRO63","Mem: " + str(memory(0), 5),M_EMP) 

      SetColor(_COREDICAO_)
      @ 09, 26 get     M_LAXDTA
      @ 10, 26 get     M_LAXSEQ picture "######"
      read
 
      if M_LAXDTA = ctod("  /  /  ") .or. lastkey() = 27
        exit
      endif

      if !ALAX00->(dbseek(str(M_LAXEMP, 2, 0) + dtos(M_LAXDTA) + str(M_LAXSEQ, 6, 0)))
        msg("* * * LANCAMENTO NAO CADASTRADO * * *")
        loop
      endif

      mslax01()                      && mostra dados do lancamento

      select ALAX00

      if !rlock()
        msg("* * * (ALAX00) REGISTRO SENDO USADO * * *")
        loop
      endif
 
      M_OPC = decide("Confirma Exclusao deste Lancamento")

      if M_OPC != 1
        msg("* * * LANCAMENTO NŽO EXCLUIDO * * *")
        unlock
        loop
      endif
      elimina()
        msg("* * * LANCAMENTO EXCLUIDO * * *")

    enddo

return ""

***************
function LISLAX
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("MENU","LANCAMENTO",M_FAN,"EAGRO63","Mem: " + str(memory(0), 5),M_EMP) 

*        @ 10, 43 prompt "Periodo  " HIGHLITE R/BG
*        @ 11, 43 prompt "Contas   " HIGHLITE R/BG

      do case
         case M_OPC = 1
              lislax_a()  
         case M_OPC = 2
              lislax_b()
      endcase

return ""

*****************
function LISLAX_A
*****************

  do while .t.

    rodape("LISTA","LANCAMENTO",M_FAN,"EAGRO63","Mem: " + str(memory(0), 5),M_EMP) 

    store ctod("  /  /  ") to M_DTAINI, M_DTAFIN, M_DTAANT
    store  0               to PG, LN, M_SALDO, M_SLDANT, M_TOTDES, M_TOTREC

 nbox(12, 29, 15, 49,"W/W+",.t.)
 setcolor("B/W")
     @ 13, 30 say          " Periodo:          "
     @ 14, 30 say          "     Ate:          "
    SetColor(_COREDICAO_)
    @ 13, 40 get M_DTAINI
    @ 14, 40 get M_DTAFIN
    read

    M_DTAINI = iif(empty(M_DTAINI),ctod("01/01/80"),M_DTAINI)
    M_DTAFIN = iif(empty(M_DTAFIN),ctod("31/12/79"),M_DTAFIN)

    if lastkey() = 27
      exit
    endif

    select ALAX00

    set relation to str(LAXEMP, 2, 0) + str(LAXAPL, 3, 0) into APLX00

    dbseek(str(ME_EMP, 2, 0) + dtos(M_DTAINI),.t.)

    if str(LAXEMP, 2, 0) + dtos(LAXDTA) > str(ME_EMP, 2, 0) + dtos(M_DTAFIN)
      msg("* * * NADA A LISTAR NO INTERVALO * * *")
      exit
    endif

    M_IMPRE = impresn()

    if M_IMPRE = "N"
      exit
    endif

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(15)                        && comprime
    endif

    select ALAX00

    dbseek(str(ME_EMP, 2, 0) + dtos(ctod("01/01/80")), .t.) 

    if str(LAXEMP, 2, 0) + dtos(LAXDTA) > str(ME_EMP, 2, 0) + dtos(M_DTAFIN)
      msg("* * * NADA A CONSULTAR NO INTERVALO * * *")
      loop
    endif

    do while !eof()
      if str(LAXEMP, 2, 0) + dtos(LAXDTA) >= str(ME_EMP, 2, 0) + dtos(M_DTAINI)
         exit
       endif
       if LAXTIP = "C"
         M_SALDO = M_SALDO + LAXVLR
       else
         if LAXTIP = "D"
           M_SALDO = M_SALDO - LAXVLR
         endif
       endif

       skip

    enddo

    cab_lax()

    ? space(01)
      ?? space(79)
      ?? "          SALDO ANTERIOR .....  "
      ?? transform(M_SALDO,"@E ###,###,###,###.##")

    M_SLDANT = M_SALDO

    do while !eof()

      if str(LAXEMP, 2, 0) + dtos(LAXDTA) > str(ME_EMP, 2, 0) + dtos(M_DTAFIN)
        go bottom
        skip
        loop
      endif

      if LAXDTA != M_DTAANT
        if M_DTAANT != ctod("  /  /  ")
          ? replicate("-", 132)
        endif
        LN = LN + 1
        M_DTAANT = LAXDTA
      endif

      if LAXTIP = "C"
        M_SALDO = M_SALDO + LAXVLR
      else
        if LAXTIP = "D"
          M_SALDO = M_SALDO - LAXVLR
        endif
      endif
              
       ? space(01)
        ?? LAXDTA
        ?? " "
        ?? str(LAXSEQ, 6, 0)
        ?? " "
        ?? str(LAXAPL, 3, 0)
        ?? " "
        ?? pad(LAXHIS, 65)        
        ?? " "
        if LAXAPL < 500
          ?? transform(LAXVLR,"@E ###,###,###.##")  
          ?? space(14)
        else 
          ?? space(14)
          ?? transform(LAXVLR,"@E ###,###,###.##")  
        endif
        ?? " "
        ??   transform(M_SALDO,"@E ###,###,###.##")  
     
        LN++

        if LN > 60
          cab_lax()
        endif

        if LAXAPL < 500
          M_TOTDES = M_TOTDES + LAXVLR
        else 
          M_TOTREC = M_TOTREC + LAXVLR
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

   ? replicate("-", 132)
   ? "Totais Entrada: "
     ?? transform(M_TOTREC,"@E ###,###,###,###.##")  
     ?? "          Saldo Anterior: "
     ?? transform(M_SLDANT,"@E ###,###,###,###.##")       
   ? "       Saidas : "
     ?? transform(M_TOTDES,"@E ###,###,###,###.##")  
     ?? "          Saldo Atual   : "
     ?? transform(M_SALDO ,"@E ###,###,###,###.##")       

  eject

desliga1()

  enddo

return ""

*****************
function LISLAX_B
*****************

  do while .t.

    rodape("LISTA","LANCAMENTO",M_FAN,"EAGRO63","Mem: " + str(memory(0), 5),M_EMP) 

    store  0               to M_APLINI, M_APLFIN, M_APLANT
    store  0               to PG,   LN, M_TOTLAX,M_TOTGER
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

    select ALAX00

    set relation to str(LAXEMP, 2, 0) + str(LAXAPL, 3, 0) into APLX00
    
    dbsetorder(2)

    dbseek(str(ME_EMP, 2, 0) + str(M_APLINI, 3, 0), .t.)

    if str(LAXEMP, 2, 0) + str(LAXAPL, 3, 0) > str(ME_EMP, 2, 0) + str(M_APLFIN, 3, 0)
      msg("* * * NADA A LISTAR NO INTERVALO * * *")
      exit
    endif

    M_IMPRE = impresn()

    if M_IMPRE = "N"
      exit
    endif

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(15)                        && comprime
    endif

    cab_lax()

    nLin = 0

    do while !eof()

      if str(LAXEMP, 2, 0) + str(LAXAPL, 3, 0) > str(ME_EMP, 2, 0) + str(M_APLFIN, 3, 0)
        go bottom
        skip
        loop
      endif

      if LAXDTA < M_DTAINI .or. LAXDTA > M_DTAFIN
        skip
        loop
      endif

      if LAXAPL # M_APLANT
        if M_TOTLAX > 0
          if nLin > 1
            ? space(97)
            ?? "Total da Conta: "
            ?? transform(M_TOTLAX,"@E ###,###,###,###.##")  
            LN ++
          endif
          ? replicate("-", 132)
          LN ++
          M_TOTLAX = 0 
          nLin = 0
        endif
        M_APLANT = LAXAPL
        ? "*** "
        ?? str(LAXAPL, 3, 0)
        ?? " - "
        ?? APLX00->PLXNOM
        LN = LN + 1
      endif

      if LN > 60
        cab_lax()
      endif
       
       ? space(01)
        ?? LAXDTA
        ?? " "
        ?? str(LAXSEQ, 6, 0)
        ?? " "
        ?? str(LAXAPL, 3, 0)
        ?? " "
        ?? pad(LAXHIS, 95)        
        ?? " "
        ?? transform(LAXVLR,"@E ###,###,###.##")  

        nLin ++
        LN++

        if LN > 60
          cab_lax()
        endif

        M_TOTLAX = M_TOTLAX + LAXVLR
        M_TOTGER = M_TOTGER + LAXVLR
          
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

     ? replicate("-", 132)
     ? space(97)
       ?? "Total da Conta: "
       ?? transform(M_TOTLAX,"@E ###,###,###,###.##")  
     ?
     ? replicate("-", 132)
          ? space(97)
            ?? "Total Geral   : "
            ?? transform(M_TOTGER,"@E ###,###,###,###.##")  

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(18)                        && descomprime
    endif

    eject

desliga1()

  enddo

return ""

****************
function CAB_LAX
****************

 store PG + 1 to  PG 

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE LANCAMENTOS","EAGRO63",132) 
  ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
  ? "*--------*------*---*-----------------------------------------------------------------*--------------*--------------*--------------*" 
  ? "*  DATA  * SEQ  *APL*                          H I S T O R I C O                      *   DEBITO     *   CREDITO    *    SALDO     *" 
  ? "*--------*------*---*-----------------------------------------------------------------*--------------*--------------*--------------*" 
  *   99/99/99 999999 999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXxxxx ###,###,###.## ###,###,###.## ###,###,###.##  

  store 5 to LN

return ""

*****************
function CAB_LAX1
*****************

 store PG + 1 to  PG 

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE LANCAMENTOS","EAGRO63",132) 
  ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
  ? "*--------*------*---*-----------------------------------------------------------------------------------------------*--------------*" 
  ? "*  DATA  * SEQ  *APL*                          H I S T O R I C O                                                    *    VALOR     *" 
  ? "*--------*------*---*-----------------------------------------------------------------------------------------------*--------------*" 
  *   99/99/99 999999 999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ###,###,###.##  

  store 5 to LN

return ""

****************
function TLLAX01
****************

 nbox(08, 14, 16, 65,"W/W+",.t.)
 setcolor("B/W")
    @ 09, 15 say     "D a t a  :                                        "
    @ 10, 15 say     "Sequencia:                                        "
    @ 11, 15 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 12, 15 say     "Aplicacao:                                        "
    @ 13, 15 say     "Tipo     :                                        "
    @ 14, 15 say     "Historico:                                        "
    @ 15, 15 say     "Valor    :                                        "
  set color to

return ""

****************
function TLLAX02
****************

 nbox(05, 04, 19, 75,"W/W+",.t.)
 setcolor("B/W")
  @ 06, 05 say     " Movimentacao Referente:          a               Saldo:              "
  @ 07, 05 say     "ÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÂÄÄÄÄÄÄÄÄÄÄ"
  @ 08, 05 say     "  DATA  ³ SEQ  ³ H I S T O R I C O        ³APL³  VALOR   ³T³  SALDO   "
  @ 09, 05 say     "ÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÅÄÄÄÄÄÄÄÄÄÄ"
  @ 10, 05 say     "        ³      ³                          ³   ³          ³ ³          "
  @ 11, 05 say     "        ³      ³                          ³   ³          ³ ³          "
  @ 12, 05 say     "        ³      ³                          ³   ³          ³ ³          "
  @ 13, 05 say     "        ³      ³                          ³   ³          ³ ³          "
  @ 14, 05 say     "        ³      ³                          ³   ³          ³ ³          "
  @ 15, 05 say     "        ³      ³                          ³   ³          ³ ³          "
  @ 16, 05 say     "        ³      ³                          ³   ³          ³ ³          "
  @ 17, 05 say     "        ³      ³                          ³   ³          ³ ³          "
  @ 18, 05 say     "        ³      ³                          ³   ³          ³ ³          "
set color to

return "" 

****************
function EDLAX01
****************

  SetColor(_COREDICAO_)
  @ 12, 26 get     M_LAXAPL picture "###"        valid verlax02()
  @ 14, 26 get     M_LAXHIS picture "@!@S39"     valid verlax03()
  @ 15, 26 get     M_LAXVLR picture "#######.##"  valid verlax04()
  read

return ""

****************
function MSLAX01
****************
 
  APLX00->(dbseek(str(ALAX00->LAXEMP, 2, 0) + str(ALAX00->LAXAPL, 3, 0)))
  
 setcolor("N/W*")
    @ 09, 26 say     ALAX00->LAXDTA
    @ 10, 26 say     ALAX00->LAXSEQ picture "######"
    @ 12, 26 say     ALAX00->LAXAPL picture "###"  
    @ 12, 30 say     pad(APLX00->PLXNOM, 35)
    @ 13, 26 say     ALAX00->LAXTIP
    @ 14, 26 say     ALAX00->LAXHIS picture "@!@S39"
    @ 15, 26 say     ALAX00->LAXVLR picture "#######.##" 
  set color to

return ""

***************** 
function VERLAX01
***************** 

  if empty(M_LAXDTA)
    return .f.
  endif

  M_LAXSEQ = 1

  do while .t.

    if ALAX00->(dbseek(str(M_LAXEMP, 2, 0) + dtos(M_LAXDTA) + str(M_LAXSEQ, 6, 0)))   
      M_LAXSEQ = M_LAXSEQ + 1
      if M_LAXSEQ > 999999
        msg("* * * LANCAMENTOS ESGOTADOS * * *")
        return .f.
      endif
      loop
    endif

    exit 

  enddo

  set color to I
    @ 10, 28 say M_LAXSEQ picture "######"
  set color to 

return .t. 

***************** 
function VERLAX02
***************** 

  if lastkey() = 5
    return .t.
  endif 

  if empty(M_LAXAPL)
    return .f.
  endif

  select APLX00 



  if !dbseek(str(M_LAXEMP, 2, 0) + str(M_LAXAPL, 3, 0)) 
    msg("* * * CONTA NAO CADASTRADA * * *")
    M_LAXAPL = 0
    return .f.
  endif

  if right(str(M_LAXAPL, 3, 0), 2) == "00"
    msg("* * * APLICACAO SINTETICA NAO RECEBE LANCAMENTO * * *")
    return .f.
  endif

  M_LAXTIP = PLXTIP

  set color to I
    @ 12, 30 say pad(PLXNOM, 35)
    @ 13, 26 say M_LAXTIP 
  set color to 

return .t. 

***************** 
function VERLAX03
***************** 

  if lastkey() = 5
    return .t.
  endif 

  if val(left(M_LAXHIS, 3)) > 0
    AHIX00->(dbseek(str(val(left(M_LAXHIS, 3)), 3, 0)))
    M_LAXHIS = pad(AHIX00->HIXDES, 52)
    return .f.
  endif
  
return .t. 

***************** 
function VERLAX04
***************** 

  if lastkey() = 5
    return .t.
  endif 

  if M_LAXVLR <= 0
    msg("* * * VALOR DEVE SER MAIOR QUE ZEROS * * *")
    return .f.
  endif
  
return .t. 


****************
function GRLAX01
****************

  select ALAX00

  do while .t. 
    if rlock()                   
      replace LAXEMP with M_LAXEMP
      replace LAXDTA with M_LAXDTA 
      replace LAXSEQ with M_LAXSEQ
      replace LAXAPL with M_LAXAPL
      replace LAXHIS with M_LAXHIS
      replace LAXTIP with M_LAXTIP
      replace LAXVLR with M_LAXVLR
      unlock
      commit 
      exit 
    else
      msg("* * * (ALAX00) REGISTRO SENDO USADO * * *")
    endif
    if lastkey()=17
      exit
    endif
  enddo

return ""