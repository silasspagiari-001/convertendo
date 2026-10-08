#include "ptmenu.ch"
***************
function MANPLX
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("MENU","APLICACOES",M_FAN,"EAGRO61","Mem: " + str(memory(0), 5),M_EMP)

*        @ 05, 50 prompt "Inclus„o " HIGHLITE R/BG PERMITE 1,6,1
*        @ 06, 50 prompt "Altera‡„o" HIGHLITE R/BG PERMITE 1,6,1
*        @ 07, 50 prompt "Consultas" HIGHLITE R/BG PERMITE 1,6,1
*        @ 08, 50 prompt "Exclus„o " HIGHLITE R/BG PERMITE 1,6,1
*        @ 09, 50 prompt "Listagens" HIGHLITE R/BG PERMITE 1,6,1
*        @ 10, 50 prompt "Outros   " HIGHLITE R/BG PERMITE 1,6,1

      do case
         case M_OPC = 1 ; incplx()
         case M_OPC = 2 ; altplx()   
         case M_OPC = 3 ; conplx()     
         case M_OPC = 4 ; excplx()   
         case M_OPC = 5 ; lisplx()   
      endcase

    fecha_arq()

return ""

***************
function INCPLX         && inclui Conta  
***************

private M_TELA

    do while .t.

        tlplx01()

        rodape("INCLUI","APLICACOES",M_FAN,"EAGRO61","Mem: " + str(memory(0), 5),M_EMP) 

        M_PLXEMP = ME_EMP
        M_PLXAPL = 0
        M_PLXGRP = 0
        M_PLXNOM = space(40)
        M_PLXTIP = space(01)
        M_PLXSIT = space(01)

        SetColor(_COREDICAO_)
        @ 12, 25 get     M_PLXAPL  picture "###" valid(M_PLXAPL > 99)
        read

        if M_PLXAPL = 0
          exit
        endif

        select APLX00

        if dbseek(str(M_PLXEMP, 2, 0) + str(M_PLXAPL, 3, 0))
          msg( "* * * CONTA JA CADASTRADA * * *")
          loop
        endif

        edplx01()

        if lastkey() = 27
          msg( "* * * CONTA NAO INCLUIDA * * *")
          loop 
        endif 
 
        select APLX00

        _append("APLX00")
        
        grplx01()                      && grava plano de contas

        msg("* * * CONTA INCLUIDA * * *")

    enddo

return ""

***************
function ALTPLX         && altera Conta  
***************

private M_TELA

    do while .t.

        tlplx01()

        rodape("ALTERA","APLICACOES",M_FAN,"EAGRO61","Mem: " + str(memory(0), 5),M_EMP) 

        M_PLXEMP = ME_EMP
        M_PLXAPL = 0

        SetColor(_COREDICAO_)
        @ 12, 25 get     M_PLXAPL  picture "###"
        read

        if M_PLXAPL = 0
          exit
        endif

        select APLX00

        if !dbseek(str(M_PLXEMP, 2, 0) + str(M_PLXAPL, 3, 0))
          msg( "* * * CONTA NAO CADASTRADA * * *")
          loop
        endif

        M_PLXEMP   = PLXEMP
        M_PLXAPL   = PLXAPL
        M_PLXGRP   = PLXGRP
        M_PLXNOM   = PLXNOM
        M_PLXTIP   = PLXTIP
        M_PLXSIT   = PLXSIT
 
        edplx01()

        if lastkey() = 27
          msg( "* * * CONTA NAO ALTERADA * * *")
          loop 
        endif 
 
        grplx01()                      && grava plano de contas

        msg("* * * CONTA ALTERADA * * *")

    enddo

return ""

***************
function CONPLX         && consulta Conta  
***************

private M_OPC ,;
        M_TELA

  do while .t.

    rodape("CONSULTA","APLICACOES",M_FAN,"EAGRO61","Mem: " + str(memory(0), 5),M_EMP) 

    tlplx01()

    M_PLXEMP = ME_EMP
    M_PLXAPL = 0

        SetColor(_COREDICAO_)
    @ 12, 25 get     M_PLXAPL  picture "###"
    read

    if M_PLXAPL = 0
      exit
    endif

    select APLX00

    dbseek(str(M_PLXEMP, 2, 0) + str(M_PLXAPL, 3, 0),.t.)

    setas()

    do while .t.

      iif(PLXEMP!=ME_EMP,dbseek(str(ME_EMP, 2, 0) + str(M_PLXAPL, 3, 0),.t.),"")

      ( msplx01() , inkey(0) )

      if lastkey() = 27
        exit
      endif

      iif(lastkey()=5 ,dbskip(-1),"")
      iif(lastkey()=24,dbskip(+1),"")
      iif(eof(),dbgotop(),"")
      iif(bof(),dbgobottom(),"")

     enddo 

     setcursor(1)

  enddo

return ""

***************
function EXCPLX         && exclui Conta  
***************


private M_OPC

  do while .t.

    tlplx01()

    rodape("EXCLUI","APLICACOES",M_FAN,"EAGRO61","Mem: " + str(memory(0), 5),M_EMP) 

    M_PLXEMP = ME_EMP
    M_PLXAPL = 0

        SetColor(_COREDICAO_)
    @ 12, 25 get     M_PLXAPL  picture "###"
    read

    if M_PLXAPL = 0 
      exit
    endif

    select APLX00

    if !dbseek(str(M_PLXEMP, 2, 0) + str(M_PLXAPL, 3, 0))
      msg( "* * * CONTA NAO CADASTRADA * * *")
      loop
    endif
 
    msplx01()

    M_OPC = confirma("desta Aplicacao")
 
    if M_OPC != 1
      msg("* * * CONTA NAO EXCLUIDA * * *")
      loop
    endif 
    elimina()

    msg("* * * CONTA EXCLUIDA * * *")

enddo

return ""

***************
function LISPLX         && lista Conta  
***************

private M_OPC ,;
        M_TELA   ,;
        M_PLXAPL1,;
        M_PLXAPL2

  do while .t.

    rodape("LISTA","APLICACOES",M_FAN,"EAGRO61","Mem: " + str(memory(0), 5),M_EMP) 

    M_PLXAPL1 = 0
    M_PLXAPL2 = 0

 nbox(10, 31, 13, 50,"W/W+",.t.)
 setcolor("B/W")
      @ 11, 32 say "Conta Inicial:    "
      @ 12, 32 say "        Final:    "

        SetColor(_COREDICAO_)
    @ 11, 47 get M_PLXAPL1 picture "###"
    @ 12, 47 get M_PLXAPL2 picture "###"
    read

    if lastkey() = 27
      exit
    endif

    M_PLXAPL1 = iif(M_PLXAPL1 = 0,100,M_PLXAPL1)
    M_PLXAPL2 = iif(M_PLXAPL2 = 0,999,M_PLXAPL2) 

    select APLX00

    dbseek(str(ME_EMP, 2, 0) + str(M_PLXAPL1, 3, 0))

    if str(PLXEMP, 2, 0) + str(PLXAPL, 3, 0) > str(ME_EMP, 2, 0) + str(M_PLXAPL2, 3, 0)
      msg("* * * NADA A LISTA NO INTERVALO * * *")   
      exit
    endif

    private M_ESC ,;
            LN    ,;
            PG

    M_IMPRE = impresn()

    if M_IMPRE = "N"
      return ""
    endif

    store 0   to   PG ,;
                   LN 
    store " " to   BR
          
    do while !eof()  
          
      store PG + 1 to  PG 

       if PG > 1
         eject
       endif

          ? cent_cab(AEMP00->EMPFAN,"LISTAGEM PLANO DE CONTAS","EAGRO61",80) 
          ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 80)
          ? "*---*---------------------------------------------------*---*---------*--------*"
          ? "*COD* NOME DA CONTA                                     *GRP*SITUACAO *  TIPO  *"
          ? "*---*---------------------------------------------------*---*---------*--------*"
*             999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXX ANALITICA CREDORA   

          store 6 to LN
  
          do while !eof() .and. LN < 60 
 
            if str(PLXEMP, 2, 0) + str(PLXAPL, 3, 0) > str(ME_EMP, 2, 0) + str(M_PLXAPL2, 3, 0)
              go bottom
              skip
              loop 
            endif

           if right(str(PLXAPL, 3, 0), 2) == "00"
             ?
              ? " *** "
              ?? transform(PLXAPL,"###")  
              ?? " "
              ?? pad(PLXNOM, 55)
             ?
             LN = LN + 3
           else
             ? " "
              ?? transform(PLXAPL,"###")  
              ?? " "
              ?? pad(PLXNOM, 51)
              ?? " " 
              ?? transform(PLXGRP,"###")  
              ?? " "
              ?? iif(PLXSIT="A","ANALITICA","SINTETICA")
              ?? " "
              ?? iif(PLXTIP="D","DEVEDORA","CREDORA  ")
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
  
    ? replicate("-", 80)

    eject

desliga1()

  enddo
 
return ""
 
****************
function TLPLX01
****************

 nbox(11, 13, 17, 66,"W/W+",.t.)
 setcolor("B/W")
    @ 12, 14 say     " Conta   :                                          "
    @ 13, 14 say     " SubGrupo:                                          "
    @ 14, 14 say     " Nome    :                                          "
    @ 15, 14 say     " Natureza:                                          "
    @ 16, 14 say     " Situacao:                                          "
  set color to

return ""    

****************
function EDPLX01
**************** 

SetColor(_COREDICAO_)
@ 13, 25 get     M_PLXGRP  picture "###"
@ 14, 25 get     M_PLXNOM  picture "@!"
@ 15, 25 get     M_PLXTIP  picture "@!" valid verplx01()
@ 16, 25 get     M_PLXSIT  picture "@!" valid verplx02()
read

return ""

****************
function MSPLX01
**************** 

set color to I
  @ 12, 25 say     PLXAPL  picture "###"
  @ 13, 25 say     PLXGRP  picture "###"
  @ 14, 25 say     PLXNOM  picture "@!"
  @ 15, 25 say     PLXTIP  picture "@!"
  @ 16, 25 say     PLXSIT  picture "@!"
set color to 

return ""

*****************
function VERPLX01
*****************

  if lastkey() = 5
    return .t.
  endif
   
  if M_PLXAPL < 500 
    if !M_PLXTIP $ "D"
      msg("* * * CONTA DEVEDORA - VALIDO SOMENTE (D) * * *")
      return .f.
    endif
  else
    if M_PLXAPL > 499
      if !M_PLXTIP $ "C"
        msg("* * * CONTA CREDORA - VALIDO SOMENTE (C) * * *")
        return .f.
      endif
    endif
  endif

  if right(str(M_PLXAPL, 3, 0), 2) == "00"
    M_PLXSIT = "S"
  else
    M_PLXSIT = "A"
  endif

return .t.

*****************
function VERPLX02
*****************

  if lastkey() = 5
    return .t.
  endif
   
  if right(str(M_PLXAPL, 3, 0), 2) == "00"
    if !M_PLXSIT = "S"
      msg("* * * CONTA (S)INTETICA NAO RECEBE LANCAMENTO * * *")
      return .f.
    endif
  else
    if !M_PLXSIT = "A"
      msg("* * * CONTA DEVE SER (A)NALITICA * * *")
      return .f.
    endif
  endif

return .t.

****************
function GRPLX01
****************

  select APLX00

  do while .t. 
    if rlock()                   && grava rodapealho do Bordero
      replace PLXEMP with M_PLXEMP
      replace PLXAPL with M_PLXAPL 
      replace PLXGRP with M_PLXGRP 
      replace PLXNOM with M_PLXNOM
      replace PLXTIP with M_PLXTIP
      replace PLXSIT with M_PLXSIT
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

return ""