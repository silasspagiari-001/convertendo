#include "ptmenu.ch"

***************
function MANHIB
***************
parameters M_OPC,M_OPC1,M_OPC2

*abre_hib("2")

      rodape("MENU","HISTORICO",M_FAN,"EAGRO52","Mem: " + str(memory(0), 5),M_EMP)

*        @ 05, 52 prompt "Inclus„o " HIGHLITE R/BG PERMITE 2,5,1
*        @ 06, 52 prompt "Altera‡„o" HIGHLITE R/BG PERMITE 2,5,2
*        @ 07, 52 prompt "Consultas" HIGHLITE R/BG PERMITE 2,5,3
*        @ 08, 52 prompt "Exclus„o " HIGHLITE R/BG PERMITE 2,5,4
*        @ 09, 52 prompt "Listagens" HIGHLITE R/BG PERMITE 2,5,5
*        @ 10, 52 prompt "Outros   " HIGHLITE R/BG PERMITE 2,5,6

      do case
         case M_OPC = 1 ; inchib()
         case M_OPC = 2 ; althib()   
         case M_OPC = 3 ; conhib()     
         case M_OPC = 4 ; exchib()   
         case M_OPC = 5 ; lishib()   
      endcase

    fecha_arq()

return ""

***************
function INCHIB
***************
        
    do while .t.

      M_HISCOD = 0
      M_HISDES = space(40)
      M_HISTIP = space(01)

      mohib01() 

      rodape("INCLUI","HISTORICO",M_FAN,"EAGRO52","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 10, 25 get     M_HISCOD   picture "###"
        read

        if M_HISCOD = 0
            exit
        endif

        select AHIS00

        if dbseek(str(M_HISCOD, 3, 0))
          msg("* * * HISTORICO  JA CADASTRADO * * *")
          loop
        endif

        edhib01()                      && edita dados da fisresa 

        if lastkey() = 27
          msg("* * * HISTORICO NAO CADASTRADO * * *")
          loop
        endif

        select AHIS00

        _append("AHIS00")

        grhib01()
        
        msg("* * * HISTORICO INCLUIDO * * *")

    enddo

return ""

***************
function ALTHIB
***************
        
    do while .t.

        M_HISCOD = 0
        M_HISDES = space(40)
        M_HISTIP = space(01)

      mohib01() 

      rodape("ALTERA","HISTORICO",M_FAN,"EAGRO52","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 10, 25 get     M_HISCOD   picture "###"
        read

        if M_HISCOD = 0
            exit
        endif

        select AHIS00

        if !dbseek(str(M_HISCOD, 3, 0))
          msg("* * * HISTORICO NAO CADASTRADO * * *")
          loop
        endif

        mshib01()

        if !rlock()
          msg("* * * (AHIS00) REGISTRO SENDO USADO * * *")
          loop 
        endif

        M_HISDES = HISDES
        M_HISTIP = HISTIP

        edhib01()                      

        if lastkey() = 27
          msg("* * * HISTORICO NAO ALTERADO * * *")
          loop
        endif

        grhib01()
        
        msg("* * * HISTORICO ALTERADO * * *")

    enddo

return ""

***************
function CONHIB
***************

    do while .t.

        M_HISCOD = 0
        M_HISDES = space(40)
        M_HISTIP = space(01)

      mohib01() 

      rodape("CONSULTA","HISTORICO",M_FAN,"EAGRO52","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 10, 25 get     M_HISCOD   picture "###"
        read
       
        if lastkey() = 27
          exit
        endif

        if M_HISCOD = 0
        SetColor(_COREDICAO_)
          @ 11, 25 get     M_HISDES   picture "@!"
          read
          if empty(M_HISDES)
            exit
          endif
        endif

        select AHIS00

        do case
           case M_HISCOD > 0
                set softseek on
                  seek str(M_HISCOD, 3, 0)
                set softseek off
           case M_HISDES != space(40)
                set order to 2
                set softseek on
                  seek M_HISDES
                set softseek off
           otherwise
                select AHIS00
                go top
        endcase

        setas()

        do while .t.

          if HISCOD = 0
            skip 
            if eof()
              msg("* * * ARQUIVO VAZIO * * *")
              exit
            endif
            loop
          endif

          mshib01()

          inkey(0)

          if lastkey() = 5
             skip - 1
          endif         

          if lastkey() = 24
            skip 
          endif

          if eof() 
            go top
          endif

          if bof()
            go bottom
          endif

          if lastkey() = 27
            exit
          endif

        enddo 

        set cursor on

        set order to 1

    enddo

return ""

***************
function EXCHIB
***************
        
private M_OPC

    do while .t.

        M_HISCOD = 0
        M_HISDES = space(40)
        M_HISTIP = space(01)

      mohib01() 

      rodape("EXCLUI","HISTORICO",M_FAN,"EAGRO52","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 10, 25 get     M_HISCOD   picture "###"
        read
       
        if M_HISCOD = 0
          exit
        endif

        select AHIS00

        if !dbseek(str(M_HISCOD, 3, 0))
          msg("* * * HISTORICO NAO CADASTRADO * * *")
          loop
        endif

        mshib01()

        if !rlock()
          msg("* * * (AHIS00) REGISTRO SENDO USADO * * *")
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
function LISHIB
*************** 

private M_HIS1  ,;
        M_HIS2  ,; 
        LN      ,;
        PG      ,;
        M_ESC   
 
    do while .t.

      rodape("LISTA","HISTORICO",M_FAN,"EAGRO52","Mem: " + str(memory(0), 5),M_EMP) 

        store 0        to M_HIS1,;
                          M_HIS2

 nbox(10, 34, 13, 53,"W/W+",.t.)
 setcolor("B/W")
      @ 11, 34 say "Histo Inicial:    "
      @ 12, 34 say "        Final:    "
        SetColor(_COREDICAO_)
       @ 11, 50 get M_HIS1 picture "###"
       @ 12, 50 get M_HIS2 picture "###"   
       read

        if lastkey() = 27
          return ""
        endif

        M_HIS1 = iif(M_HIS1 = 0,  1,M_HIS1)
        M_HIS2 = iif(M_HIS2 = 0,999,M_HIS2) 

        select AHIS00

        go top

        set softseek on
          seek str(M_HIS1, 3, 0)
        set softseek off

        if HISCOD > M_HIS2
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

        ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE HISTORICO","EAGRO52",132) 
        ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
        ? "*----*------------------------------------*-*----*------------------------------------*-*----*-----------------------------------*-*"
        ? "*COD * DESCRICAO                          *T*COD * DESCRICAO                          *T*COD * DESCRICAO                         *T*"
        ? "*----*------------------------------------*-*----*------------------------------------*-*----*-----------------------------------*-*"
*           9999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX X 9999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX X 9999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX X 

        store 5 to LN

        do while !eof() .and. LN < 60
          
            ? " "
              store 1 to CL
              do while !eof() .and. CL < 4
                if  HISCOD > M_HIS2
                  go bottom
                  skip
                  loop
                endif 
                ?? str(HISCOD, 4, 0)
                ?? " "
                ?? iif(CL=3,left(HISDES, 35),left(HISDES, 36))
                ?? " "
                ?? HISTIP
                ?? " "
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
function MOHIB01
****************

 nbox(09, 13, 13, 66,"W/W+",.t.)
 setcolor("B/W")
    @ 10, 14 say     " Codigo  :                                          "
    @ 11, 14 say     " Nome    :                                          "
    @ 12, 14 say     " Tipo    :      (D)ebito    (C)redito    (N)ulo     "
set color to

return ""

****************
function EDHIB01
****************

        SetColor(_COREDICAO_)
    @ 11, 25 get     M_HISDES picture "@!"
    @ 12, 25 get     M_HISTIP picture "@!" valid(rat(M_HISTIP,"D#C#N") > 0)
    read

return ""

****************
function MSHIB01
****************

 setcolor("N/W*")
    @ 10, 25 say     HISCOD picture "###"
    @ 11, 25 say     HISDES picture "@!"    
    @ 12, 25 say     HISTIP picture "@!"    
  set color to
  
return ""

****************
function GRHIB01                      
****************

  select AHIS00

  do while .t.
    if rlock()
        replace HISCOD with M_HISCOD 
        replace HISDES with M_HISDES 
        replace HISTIP with M_HISTIP 
      unlock   
      commit
      exit
    else
      msg("* * * (AHIS00) REGISTRO SENDO USADO * * *") 
    endif
    if lastkey()=17
      exit
    endif
  enddo

return ""
