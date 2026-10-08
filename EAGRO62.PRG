#include "ptmenu.ch"

***************
function MANHIX
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("MENU","HISTORICO",M_FAN,"EAGRO62","Mem: " + str(memory(0), 5),M_EMP)

*        @ 05, 50 prompt "Inclus꼘 " HIGHLITE R/BG PERMITE 2,6,1
*        @ 06, 50 prompt "Altera뇙o" HIGHLITE R/BG PERMITE 2,6,2
*        @ 07, 50 prompt "Consultas" HIGHLITE R/BG PERMITE 2,6,3
*        @ 08, 50 prompt "Exclus꼘 " HIGHLITE R/BG PERMITE 2,6,4
*        @ 09, 50 prompt "Listagens" HIGHLITE R/BG PERMITE 2,6,5
*        @ 10, 50 prompt "Outros   " HIGHLITE R/BG PERMITE 2,6,6

      do case
         case M_OPC = 1 ; inchix()
         case M_OPC = 2 ; althix()   
         case M_OPC = 3 ; conhix()     
         case M_OPC = 4 ; exchix()   
         case M_OPC = 5 ; lishix()   
      endcase

    fecha_arq()

return ""

***************
function INCHIX
***************
        
    do while .t.

      M_HIXCOD = 0
      M_HIXDES = space(40)

      tlhix01() 

      rodape("INCLUI","HISTORICO",M_FAN,"EAGRO62","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 12, 25 get     M_HIXCOD   picture "###"
        read

        if M_HIXCOD = 0
            exit
        endif

        select AHIX00

        if dbseek(str(M_HIXCOD, 3, 0))
          msg("* * * HISTORICO  JA CADASTRADO * * *")
          loop
        endif

        edhix01()                      && edita dados da fisresa 

        if lastkey() = 27
          msg("* * * HISTORICO NAO CADASTRADO * * *")
          loop
        endif

        select AHIX00

        _append("AHIX00")

        grhix01()
        
        msg("* * * HISTORICO INCLUIDO * * *")

    enddo

return ""

***************
function ALTHIX
***************

    do while .t.

      M_HIXCOD = 0
      M_HIXDES = space(40)

      tlhix01() 

      rodape("ALTERA","HISTORICO",M_FAN,"EAGRO62","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 12, 25 get     M_HIXCOD   picture "###"
        read

        if M_HIXCOD = 0
            exit
        endif

        select AHIX00

        if !dbseek(str(M_HIXCOD, 3, 0))
          msg("* * * HISTORICO NAO CADASTRADO * * *")
          loop
        endif

        mshix01()

        if !rlock()
          msg("* * * (AHIX00) REGISTRO SENDO USADO * * *")
          loop 
        endif

        M_HIXDES = HIXDES

        edhix01()                      

        if lastkey() = 27
          msg("* * * HISTORICO NAO ALTERADO * * *")
          loop
        endif

        grhix01()
        
        msg("* * * HISTORICO ALTERADO * * *")

    enddo

return ""

***************
function CONHIX
***************
        
    do while .t.

      M_HIXCOD = 0
      M_HIXDES = space(40)

      tlhix01() 

      rodape("CONSULTA","HISTORICO",M_FAN,"EAGRO62","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 12, 25 get     M_HIXCOD   picture "###"
        read
       
        if lastkey() = 27
          exit
        endif

        if M_HIXCOD = 0
        SetColor(_COREDICAO_)
          @ 11, 25 get     M_HIXDES   picture "@!"
          read
          if empty(M_HIXDES)
            exit
          endif
        endif

        select AHIX00

        do case
           case M_HIXCOD > 0
                set softseek on
                  seek str(M_HIXCOD, 3, 0)
                set softseek off
           case M_HIXDES != space(40)
                set order to 2
                set softseek on
                  seek M_HIXDES
                set softseek off
           otherwise
                select AHIX00
                go top
        endcase

        setas()

        do while .t.

          iif(empty(HIXCOD),dbseek(str(1, 3)),"")

          ( mshix01() , inkey(0) )

          if lastkey() = 27
            exit
          endif

          iif(lastkey()=5 ,dbskip(-1),"")
          iif(lastkey()=24,dbskip(+1),"")
          iif(eof(),dbgotop(),"")
          iif(bof(),dbgobottom(),"")

        enddo 

        set cursor on

        set order to 1

    enddo

return ""

***************
function EXCHIX
***************
        
private M_HIXCOD ,; && codigo 
        M_HIXDES ,; && descricao
        M_OPC

    do while .t.

      M_HIXCOD = 0
      M_HIXDES = space(40)

      tlhix01() 

      rodape("EXCLUI","HISTORICO",M_FAN,"EAGRO62","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 12, 25 get     M_HIXCOD   picture "###"
        read
       
        if lastkey() = 27
          exit
        endif

        select AHIX00

        if !dbseek(str(M_HIXCOD, 3, 0))
          msg("* * * HISTORICO NAO CADASTRADO * * *")
          loop
        endif

        mshix01()

        if !rlock()
          msg("* * * (AHIX00) REGISTRO SENDO USADO * * *")
          loop 
        endif

        M_OPC = confirma("deste Historico")

        if M_OPC != 1
          msg("* * * HISTORICO NAO EXCLUIDO * * *")
          unlock
          loop
        endif
        elimina()

        msg("* * * HISTORICO EXCLUIDO * * *")

    enddo

return ""

***************
function LISHIX
*************** 

    do while .t.

      rodape("LISTA","HISTORICO",M_FAN,"EAGRO62","Mem: " + str(memory(0), 5),M_EMP) 

      store 0        to M_HIX1,;
                        M_HIX2

      sombra(10, 29, 13, 52,_SOMBRA_)

      set color to GR+/W+
        @ 10, 29 say       "旼컴컴컴컴컴컴컴컴컴컴커" 
        @ 11, 29 say       "쿓istorico Inicial:    �" 
        @ 12, 29 say       "�            Final:    �" 
        @ 13, 29 say       "읕컴컴컴컴컴컴컴컴컴컴켸" 
      set color to 

        SetColor(_COREDICAO_)
      @ 11, 49 get M_HIX1 picture "###"
      @ 12, 49 get M_HIX2 picture "###"   
      read

      if lastkey() = 27
        return ""
      endif

      M_HIX1 = iif(M_HIX1 = 0,  1,M_HIX1)
      M_HIX2 = iif(M_HIX2 = 0,999,M_HIX2) 

      select AHIX00

        go top

        set softseek on
          seek str(M_HIX1, 3, 0)
        set softseek off

        if HIXCOD > M_HIX2
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

        ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE HISTORICO","EAGRO62",132) 
        ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
        ? "*----*--------------------------------------*----*--------------------------------------*----*-------------------------------------*"
        ? "*COD * DESCRICAO                            *COD * DESCRICAO                            *COD * DESCRICAO                           *"
        ? "*----*--------------------------------------*----*--------------------------------------*----*-------------------------------------*"
*           9999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

        store 5 to LN

        do while !eof() .and. LN < 60
          
            ? " "
              store 1 to CL
              do while !eof() .and. CL < 4
                if  HIXCOD > M_HIX2
                  go bottom
                  skip
                  loop
                endif 

                ?? str(HIXCOD, 4, 0)
                ?? " "
                ?? left(HIXDES, 38)
                if CL < 3
                  ?? " "
                endif
                CL = CL + 1
                skip
              enddo
  
            LN = LN + 1

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
function TLHIX01
****************

 nbox(11, 13, 14, 66,"W/W+",.t.)
 setcolor("B/W")
    @ 12, 14 say     " Codigo  :                                          "
    @ 13, 14 say     " Nome    :                                          "
set color to

return ""

****************
function EDHIX01
****************

    SetColor(_COREDICAO_)
    @ 13, 25 get     M_HIXDES picture "@!"
    read

return ""

****************
function MSHIX01
****************

 setcolor("N/W*")
    @ 12, 25 say     HIXCOD picture "###"
    @ 13, 25 say     HIXDES picture "@!"    
  set color to
  
return ""

****************
function GRHIX01                      
****************

  select AHIX00

  do while .t.
    if rlock()
      replace HIXCOD with M_HIXCOD 
      replace HIXDES with M_HIXDES 
      unlock   
      commit
      exit
    else
      msg("* * * (AHIX00) REGISTRO SENDO USADO * * *") 
    endif
    if lastkey()=17
      exit
    endif
  enddo

return ""
