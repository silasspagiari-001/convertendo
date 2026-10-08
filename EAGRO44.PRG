#include "ptmenu.ch"

***************
function MANMCP
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("MENU","OPERACOES",M_FAN,"EAGRO44","Mem: " + str(memory(0), 5),M_EMP) 

*        @ 05, 41 prompt "Inclus„o " HIGHLITE R/BG PERMITE 4,4,1
*        @ 06, 41 prompt "Altera‡„o" HIGHLITE R/BG PERMITE 4,4,2
*        @ 07, 41 prompt "Consulta " HIGHLITE R/BG PERMITE 4,4,3
*        @ 08, 41 prompt "Exclus„o " HIGHLITE R/BG PERMITE 4,4,4
*        @ 09, 41 prompt "Listagem " HIGHLITE R/BG PERMITE 4,4,5

      do case
         case M_OPC = 1 ; incmcp()
         case M_OPC = 2 ; altmcp()
         case M_OPC = 3 ; conmcp()
         case M_OPC = 4 ; excmcp()
         case M_OPC = 5 ; lismcp()
      endcase

    fecha_arq()

return ""

***************
function INCMCP
***************
        
    do while .t.

        M_MOVEMP = ME_EMP
        M_MOVCOD = 0
        M_MOVDES = space(30)
        M_MOVDIA = "S"
        M_MOVRAZ = "S"
        M_MOVTIP = " "

        M_MOVRBA = 0     
        M_MOVRJU = 0  
        M_MOVRTX = 0 

        M_MOVPBA = 0  
        M_MOVPJU = 0 
        M_MOVPTX = 0 

        momcp01() 

        rodape("INCLUI","OPERACOES",M_FAN,"EAGRO44","Mem: " + str(memory(0), 5),M_EMP) 

        M_MOVEMP = ME_EMP 
        M_MOVCOD = 0

        SetColor(_COREDICAO_)
        @ 09, 31 get     M_MOVCOD   picture "###"
        read

        if M_MOVCOD = 0
            exit
        endif

        select AMOV00P

        if dbseek(str(M_MOVEMP, 2, 0) + str(M_MOVCOD, 3, 0))
          msg("* * * OPERACAO JA CADASTRADA * * *")
          loop
        endif

        edmcp01()                      && edita dados do movimento

        if lastkey() = 27
          msg("* * * OPERACAO NAO INCLUIDO * * *")
          loop
        endif

        _append("AMOV00P")

        grmcp01()                      && grava movimento

        msg("* * * OPERACAO INCLUIDO * * *")

    enddo

return ""

***************
function ALTMCP
***************
        
    do while .t.

      momcp01() 

      rodape("ALTERA","OPERACOES",M_FAN,"EAGRO44","Mem: " + str(memory(0), 5),M_EMP) 

        M_MOVEMP = ME_EMP
        M_MOVCOD = 0

        SetColor(_COREDICAO_)
        @ 09, 31 get     M_MOVCOD   picture "###"
        read

        if M_MOVCOD = 0
          exit
        endif

        select AMOV00P

        if !dbseek(str(M_MOVEMP, 2, 0) + str(M_MOVCOD, 3, 0)) 
          msg("* * * OPERACAO NAO CADASTRADA * * *")
          loop
        endif

        msmcp01()

        if !rlock()
          msg("* * * (AMOV00P) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_MOVEMP  = MOVEMP
        M_MOVCOD  = MOVCOD 
        M_MOVDES  = MOVDES 
        M_MOVDIA  = MOVDIA 
        M_MOVRAZ  = MOVRAZ 
        M_MOVTIP  = MOVTIP 

        M_MOVRJU  = MOVRJU  
        M_MOVRTX  = MOVRTX 

        M_MOVPJU  = MOVPJU 
        M_MOVPTX  = MOVPTX 

        edmcp01() 

        if lastkey() = 27
          msg("* * * OPERACAO NAO ALTERADA * * *")
          unlock
          loop 
        endif

        grmcp01()

        msg("* * * OPERACAO ALTERADA * * *")

    enddo

return ""

***************
function CONMCP
***************
        
    do while .t.

      momcp01() 

      rodape("CONSULTA","OPERACOES",M_FAN,"EAGRO44","Mem: " + str(memory(0), 5),M_EMP) 

        M_MOVEMP = ME_EMP
        M_MOVCOD = 0

        SetColor(_COREDICAO_)
        @ 09, 31 get     M_MOVCOD   picture "###"
        read

        if M_MOVCOD = 0
            exit
        endif

        select AMOV00P

        set softseek on
         seek str(M_MOVEMP, 2, 0) + str(M_MOVCOD, 3, 0)
        set softseek off

        if MOVEMP != M_MOVEMP
          msg("* * * NADA A CONSULTAR APARTIR DESTE CODIGO * * *")
          loop
        endif

        setas()

        do while .t.

          msmcp01()

          inkey(0)

          if lastkey() = 5
             skip - 1
          endif         

          if lastkey() = 24
            skip 
          endif

          if MOVEMP != M_MOVEMP
            msg("* * * FIM DO ARQUIVO * * *")
            exit
          endif

          if lastkey() = 27
            exit
          endif

        enddo 

        set cursor on

    enddo

return ""

***************
function EXCMCP
***************
        
private M_OPC
             
    do while .t.

      momcp01() 

      rodape("EXCLUI","OPERACOES",M_FAN,"EAGRO44","Mem: " + str(memory(0), 5),M_EMP) 

        M_MOVCOD = 0
        M_MOVEMP = ME_EMP

        SetColor(_COREDICAO_)
        @ 09, 31 get     M_MOVCOD   picture "###"
        read

        if M_MOVCOD = 0
            exit
        endif

        select AMOV00P

        if !dbseek(str(M_MOVEMP, 2, 0) + str(M_MOVCOD, 3, 0))
          msg("* * * OPERACAO NAO CADASTRADA * * *")
          loop
        endif
        
        msmcp01()

        if !rlock()
          msg("* * * (AMOV00P) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_OPC = confirma("desta Operacao")

        if M_OPC != 1
          msg("* * * OPERACAO NAO EXCLUIDA * * *")
          unlock
          loop
        endif
        elimina()

        msg("* * * OPERACAO EXCLUIDA * * *")

    enddo

return ""

***************
function LISMCP
*************** 

private M_COD1  ,;
        M_COD2  ,; 
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_TELA
 
    do while .t.

      rodape("LISTA","OPERACOES",M_FAN,"EAGRO44","Mem: " + str(memory(0), 5),M_EMP) 

        store 0        to M_COD1,;
                          M_COD2

 nbox(10, 46, 13, 70,"W/W+",.t.)
 setcolor("B/W")
         @ 11, 47 say "Operacoes Inicial:     "
         @ 12, 47 say "            Final:     "

        SetColor(_COREDICAO_)
        @ 11, 66 get M_COD1 picture "###"
        @ 12, 66 get M_COD2 picture "###"   
        read

        if lastkey() = 27
            return ""
        endif

        M_COD1 = iif(M_COD1 = 0,  1,M_COD1)
        M_COD2 = iif(M_COD2 = 0,999,M_COD2) 

        select AMOV00P

        go top

        set softseek on
          seek str(ME_EMP, 2, 0) + str(M_COD1, 3, 0)
        set softseek off

        if str(MOVEMP, 2, 0) + str(MOVCOD, 3, 0)  > str(ME_EMP, 2, 0) + str(M_COD2, 3, 0)
          msg("* * * NADA A LISTAR NO INTERVALO * * *")
          loop
        endif

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

    store 0 to PG

    do while !eof()

        store PG + 1 to PG

        if PG > 1
            eject
        endif

        ? cent_cab(AEMP00->EMPFAN,"TABELA DE OPERACOES FINANCEIRA","EAGRO44",132) 
        ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
        ? "*---*------------------------------*-------*-------*-------*------------*---*------------------------------*-------*-------*-------*"
        ? "*COD*DESCRICAO                     *DIARIO *RAZAO  * TIPO  *            *COD*DESCRICAO                     *DIARIO *RAZAO  * TIPO  *"
        ? "*---*------------------------------*-------*-------*-------*------------*---*------------------------------*-------*-------*-------*"
 *          999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXX XXXXXXX        
 *                                                                                           
 *                                                                                           
        store 5 to LN

        do while !eof() .and. LN < 60

          if str(MOVEMP, 2, 0) + str(MOVCOD, 3, 0) > str(ME_EMP, 2, 0) + str(M_COD2, 3, 0)
            go bottom
            skip
            loop
          endif 

            ? " "
              ?? str(MOVCOD, 3, 0)
              ?? " "
              ?? MOVDES
              ?? " "
              ?? iif(MOVDIA="S","SIM    ","NAO    ")
              ?? " "
              ?? iif(MOVRAZ="S","SIM    ","NAO    ")
              ?? " "
              ?? iif(MOVTIP="C","CREDITO",iif(MOVTIP="D","DEBITO ","NULO   "))

              skip

              if eof()
                loop
              endif

              ?? "              "
              ?? str(MOVCOD, 3, 0)
              ?? " "
              ?? MOVDES
              ?? " "
              ?? iif(MOVDIA="S","SIM    ","NAO    ")
              ?? " "
              ?? iif(MOVRAZ="S","SIM    ","NAO    ")
              ?? " "
              ?? iif(MOVTIP="C","CREDITO",iif(MOVTIP="D","DEBITO ","NULO   "))

            LN = LN + 1

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
function MOMCP01
****************
   
 nbox(08, 18, 17, 61,"W/W+",.t.)
 setcolor("B/W")
  @ 09, 19 say  " Codigo   :                               "
  @ 10, 19 say  " Descricao:                               "
  @ 11, 19 say  " Tipo     :                               "
  @ 12, 19 say  " Diario   :                               "
  @ 13, 19 say  " Razao    :                               "
  @ 14, 19 say  "ÄÄÄÄÄÄÄÄReceberÄÄÄÄÄÄÂÄÄÄÄÄÄPagarÄÄÄÄÄÄÄÄÄ"
  @ 15, 19 say  " Juros    :          ³  Juros    :        "
  @ 16, 19 say  " Taxas    :          ³  Taxas    :        "
set color to

return ""

****************
function EDMCP01
****************

    SetColor(_COREDICAO_)
    @ 10, 31 get     M_MOVDES  picture "@!"
    @ 11, 31 get     M_MOVTIP  picture "@!" valid vermcp1()
    @ 12, 31 get     M_MOVDIA  picture "@!" valid(M_MOVDIA = "S" .or. M_MOVDIA = "N")
    @ 13, 31 get     M_MOVRAZ  picture "@!" valid(M_MOVRAZ = "S" .or. M_MOVRAZ = "N")

    @ 15, 31 get     M_MOVRJU  picture "###" 
    @ 16, 31 get     M_MOVRTX  picture "###" 

    @ 15, 54 get     M_MOVPJU  picture "###" 
    @ 16, 54 get     M_MOVPTX  picture "###" 
    read

return ""

****************
function MSMCP01
****************

 setcolor("N/W*")
    @ 09, 31 say     MOVCOD picture "###"
    @ 10, 31 say     MOVDES  
    @ 11, 31 say     MOVTIP  
    @ 12, 31 say     MOVDIA  
    @ 13, 31 say     MOVRAZ  

    @ 15, 31 say     MOVRJU  picture "###" 
    @ 16, 31 say     MOVRTX  picture "###" 

    @ 15, 54 say     MOVPJU  picture "###" 
    @ 16, 54 say     MOVPTX  picture "###" 
  set color to 

return ""

****************
function VERMCP1
****************

if lastkey() = 5
  return .t.
endif

if rat(M_MOVTIP,"#D#C#-") = 0
  msg("* * * VALIDO SOMENTE (D)ebito (C)redito (-)Nulo * * *")
  return .f.
endif

return .t.

****************
function GRMCP01
****************

  select AMOV00P

  do while .t.
    if rlock()
      replace MOVEMP  with M_MOVEMP 
      replace MOVCOD  with M_MOVCOD 
      replace MOVDES  with M_MOVDES 
      replace MOVDIA  with M_MOVDIA 
      replace MOVRAZ  with M_MOVRAZ 
      replace MOVTIP  with M_MOVTIP 

      replace MOVRJU  with M_MOVRJU 
      replace MOVRTX  with M_MOVRTX 

      replace MOVPJU  with M_MOVPJU 
      replace MOVPTX  with M_MOVPTX 
      unlock   
      commit
      exit
    else
      msg("* * * (AMOVN0) REGISTRO SENDO USADO * * *") 
    endif
    if lastkey()=17
      exit
    endif
  enddo

return ""
