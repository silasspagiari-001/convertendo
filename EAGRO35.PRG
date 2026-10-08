#include "ptmenu.ch"

***************
function MANPOR
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("MENU","PORTADOR",M_FAN,"EAGRO35","Mem: " + str(memory(0), 5),M_EMP) 

*        @ 05, 30 prompt "Inclus„o " HIGHLITE R/BG PERMITE 5,3,1
*        @ 06, 30 prompt "Altera‡„o" HIGHLITE R/BG PERMITE 5,3,2
*        @ 07, 30 prompt "Consulta " HIGHLITE R/BG PERMITE 5,3,3
*        @ 08, 30 prompt "Exclus„o " HIGHLITE R/BG PERMITE 5,3,4
*        @ 09, 30 prompt "Listagem " HIGHLITE R/BG PERMITE 5,3,5
*        @ 10, 30 prompt "Outros   " HIGHLITE R/BG PERMITE 5,3,6

      do case
         case M_OPC = 1 ; incpor()
         case M_OPC = 2 ; altpor()
         case M_OPC = 3 ; conpor()
         case M_OPC = 4 ; excpor()
         case M_OPC = 5 ; lispor()
      endcase

    fecha_arq()

return ""

***************
function INCPOR
***************
             
    do while .t.

      M_PORCOD  = 0
      M_PORCGC  = space(15)
      M_PORNOM  = space(40)
      M_POREND  = space(40)
      M_PORMUN  = space(20)
      M_PORCEP  = space(08)
      M_POREST  = space(02)
      M_PORTEL  = space(15)
      M_PORTEX  = space(15)
      M_PORFAX  = space(15)
      M_PORAGE  = space(15)
      M_POROPE  = space(15)

      tlpor01() 

       rodape("INCLUI","PORTADOR",M_FAN,"EAGRO35","Mem: " + str(memory(0), 5),M_EMP) 

        select APOR00
        set order to 0
        go top

        do while !eof()
          M_PORCOD = iif(M_PORCOD>PORCOD,M_PORCOD,PORCOD)
          skip
        enddo
                
        M_PORCOD ++

        set color to I
          @ 08, 25 say     M_PORCOD picture "#####"
        setcolor("")

        select APOR00
        set order to 1 
        if dbseek(str(M_PORCOD, 5, 0))
          msg("* * * PORTADOR JA CADASTRADO * * *")
          loop
        endif

        edpor01()                      && edita dados portador

        if lastkey() = 27
          msg("* * * PORTADO NAO INCLUIDO * * *")
          exit
        endif

        _append("APOR00")
        grpor01()                      && grava portador

        msg("* * * PORTADOR INCLUIDO * * *")

    enddo

return ""

***************
function ALTPOR
***************

    do while .t.

      tlpor01() 

       rodape("ALTERA","PORTADOR",M_FAN,"EAGRO35","Mem: " + str(memory(0), 5),M_EMP) 

        store 0 to M_PORCOD
        SetColor(_COREDICAO_)
        @ 08, 25 get     M_PORCOD   picture "#####"
        read

        if M_PORCOD = 0
            exit
        endif

        select APOR00
 
        if !dbseek(str(M_PORCOD, 5, 0))
          msg("* * * PORTADOR NAO CADASTRADO * * *")
          loop
        endif

        mspor01()                      && mostra os dados

        if !rlock()
          msg("* * * (APOR00) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_PORCGC  = PORCGC
        M_PORNOM  = PORNOM
        M_POREND  = POREND
        M_PORMUN  = PORMUN
        M_PORCEP  = PORCEP
        M_POREST  = POREST
        M_PORTEL  = PORTEL
        M_PORTEX  = PORTEX
        M_PORFAX  = PORFAX
        M_PORAGE  = PORAGE
        M_POROPE  = POROPE

        edpor01() 

        if lastkey() = 27
          msg("* * * PORTADOR NAO ALTERADO * * *")
          unlock
          loop 
        endif
 
        grpor01()                      && regrava portador

        msg("* * * PORTADOR ALTERADO * * *")

    enddo

return ""

***************
function CONPOR
***************
        
private M_PORCOD
             
    do while .t.

      tlpor01() 

        rodape("CONSULTA","PORTADOR",M_FAN,"EAGRO35","Mem: " + str(memory(0), 5),M_EMP) 

        store 0 to M_PORCOD
        SetColor(_COREDICAO_)
        @ 08, 25 get     M_PORCOD   picture "#####"
        read

        if M_PORCOD = 0
            exit
        endif

        select APOR00

        set softseek on
          seek str(M_PORCOD, 5, 0)
        set softseek off
 
        if eof()
          go top
        endif

        setas()

        do while .t.

          mspor01()

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

    enddo

return ""

***************
function EXCPOR
***************
        
private M_PORCOD ,;
        M_OPC
             
    do while .t.

      tlpor01() 

        rodape("EXCLUI","PORTADOR",M_FAN,"EAGRO35","Mem: " + str(memory(0), 5),M_EMP) 

        store 0 to M_PORCOD
        SetColor(_COREDICAO_)
        @ 08, 25 get     M_PORCOD   picture "#####"
        read

        if M_PORCOD = 0
            exit
        endif

        select APOR00

        if !dbseek(str(M_PORCOD, 5, 0))
          msg("* * * PORTADOR NAO CADASTRADO * * *")
          loop
        endif
        
        mspor01()

        if !rlock()
          msg("* * * (APOR00) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_OPC = confirma("deste Portador")

        if M_OPC != 1
          msg("* * * PORTADOR NAO EXCLUIDO * * *")
          unlock
          loop
        endif

        elimina()

        msg("* * * PORTADOR EXCLUIDO * * *")

    enddo

return ""

***************
function LISPOR
*************** 

private M_COD1  ,;
        M_COD2  ,; 
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_TELA
 
    do while .t.

        rodape("LISTA","PORTADOR",M_FAN,"EAGRO35","Mem: " + str(memory(0), 5),M_EMP) 

        store 0        to M_COD1,;
                          M_COD2

       sombra(11, 35, 13, 59,_SOMBRA_)

       set color to GR+/W
         @ 10, 35 say             "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
         @ 11, 35 say             "³Portador Inicial:      ³" 
         @ 12, 35 say             "³           Final:      ³" 
         @ 13, 35 say             "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 

        SetColor(_COREDICAO_)
        @ 11, 53 get M_COD1 picture "#####"
        @ 12, 53 get M_COD2 picture "#####"   
        read

        if lastkey() = 27
            return ""
        endif

        M_COD1 = iif(M_COD1 = 0,    1,M_COD1)
        M_COD2 = iif(M_COD2 = 0,99999,M_COD2) 

        select APOR00

        go top

        set softseek on
          seek str(M_COD1, 5, 0)
        set softseek off

        if PORCOD > M_COD2
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

        ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE PORTADORES","EAGRO35",132) 
        ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
        ? "*------*-------------------*----------------------------------------*-------------------------------------*------------*-----------*"
        ? "*CODIGO* CGC (MF)          * NOME                                   * ENDERECO                            * AGENCIA    * OPERACAO  *"
        ? "*------*-------------------*----------------------------------------*-------------------------------------*------------*-----------*"
          * 999999 999.999.999/9999-99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXX XXXXXXXXXXX 

        store 5 to LN

        do while !eof() .and. LN < 60

          if  PORCOD > M_COD2
            go bottom
            skip
            loop
          endif 

            ? "  "
              ?? str(PORCOD, 5, 0)
              ?? " "
              ?? transform(PORCGC,"@R 999.999.999/9999-99")
              ?? " "
              ?? PORNOM
              ?? " "
              ?? left(POREND, 37)
              ?? " "
              ?? left(PORAGE, 12)
              ?? " "
              ?? left(POROPE, 11)
  
            store LN + 1 to LN

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
function TLPOR01
****************
   
 nbox(07, 13, 17, 66,"W/W+",.t.)
 setcolor("B/W")
    @ 08, 14 say     " Codigo  :                 Cgc:                     "
    @ 09, 14 say     " Nome    :                                          "
    @ 10, 14 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 11, 14 say     " Endereco:                                          "
    @ 12, 14 say     " Cidade  :                            Cep:          "
    @ 13, 14 say     " Telefone:                             Uf:          "
    @ 14, 14 say     " Telex   :                                          "
    @ 15, 14 say     " Fax     :                 Agencia:                 "
    @ 16, 14 say     " Operacao:                                          "
set color to

return ""

****************
function EDPOR01
****************

    SetColor(_COREDICAO_)
    @ 08, 46 get     M_PORCGC picture "@R 999.999.999/9999-99"
    @ 09, 25 get     M_PORNOM picture "@!"  
    @ 11, 25 get     M_POREND picture "@!"  
    @ 12, 25 get     M_PORMUN picture "@!"                      
    @ 12, 57 get     M_PORCEP picture "@!"   
    @ 13, 25 get     M_PORTEL picture "@!"                         
    @ 13, 63 get     M_POREST picture "@!" valid   verest(M_POREST) 
    @ 14, 25 get     M_PORTEX picture "@!"                         
    @ 15, 25 get     M_PORFAX picture "@!"                         
    @ 15, 50 get     M_PORAGE picture "@!"                             
    @ 16, 25 get     M_POROPE picture "@!"
    read

return ""

****************
function MSPOR01
****************

  setcolor("N/W*")
    @ 08, 25 say     PORCOD picture "#####"
    @ 08, 46 say     PORCGC picture "@R 999.999.999/9999-99"
    @ 09, 25 say     PORNOM 
    @ 11, 25 say     POREND 
    @ 12, 25 say     PORMUN 
    @ 12, 57 say     PORCEP 
    @ 13, 25 say     PORTEL 
    @ 13, 63 say     POREST 
    @ 14, 25 say     PORTEX 
    @ 15, 25 say     PORFAX 
    @ 15, 50 say     PORAGE 
    @ 16, 25 say     POROPE 
  set color to
  
return ""

****************
function GRPOR01
****************

  select APOR00

        do while .t.
          if rlock()
            replace  PORCOD   with  M_PORCOD
            replace  PORCGC   with  M_PORCGC
            replace  PORNOM   with  M_PORNOM
            replace  POREND   with  M_POREND
            replace  PORMUN   with  M_PORMUN
            replace  PORCEP   with  M_PORCEP
            replace  POREST   with  M_POREST
            replace  PORTEL   with  M_PORTEL
            replace  PORTEX   with  M_PORTEX
            replace  PORFAX   with  M_PORFAX
            replace  PORAGE   with  M_PORAGE 
            replace  POROPE   with  M_POROPE 
            unlock   
            commit
            exit
          else
            msg("* * * (APOR00) REGISTRO SENDO USADO * * *") 
          endif
          if lastkey()=17
            exit
          endif
        enddo

return ""
