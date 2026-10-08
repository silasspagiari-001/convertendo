#include "ptmenu.ch"

***************
function MANIND
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("MENU","INDICAR",M_FAN,"EAGRO29","Mem: " + str(memory(0), 5),M_EMP) 

*        @ 05, 19 prompt "InclusÆo " HIGHLITE R/BG            PERMITE 5,2,1
*        @ 06, 19 prompt "Altera‡Æo" HIGHLITE R/BG            PERMITE 5,2,2
*        @ 07, 19 prompt "Consulta " HIGHLITE R/BG            PERMITE 5,2,3
*        @ 08, 19 prompt "ExclusÆo " HIGHLITE R/BG            PERMITE 5,2,4
*        @ 09, 19 prompt "Listagem " HIGHLITE R/BG            PERMITE 5,2,5

      do case
         case M_OPC = 1 ; incind()
         case M_OPC = 2 ; altind()
         case M_OPC = 3 ; conind()
         case M_OPC = 4 ; excind()
         case M_OPC = 5 ; lisind()
      endcase


    fecha_arq()

return ""

***************
function INCIND
***************

    do while .t.

        M_VENCOD  = 1
        M_VENCPF  = space(15)
        M_VENNOM  = space(40)
        M_VENEND  = space(40)
        M_VENBAI  = space(20)
        M_VENCEP  = 0
        M_VENCCE  = 0
        M_VENMUN  = space(20)
        M_VENEST  = space(2)
        M_VENTEL  = space(15)
        M_VENSUP  = "N"
        M_VENIMS  = " "

        tlind01() 
        rodape("INCLUI","INDICAR",M_FAN,"EAGRO29","Mem: " + str(memory(0), 5),M_EMP) 

        select AIND00
        set order to 1

        do while .t.
          if dbseek(str(M_VENCOD, 3))
            M_VENCOD++
            loop
          endif
          exit 
        enddo
                
        setcolor("I")
        @ 10, 25 say     M_VENCOD   picture "###"
        setcolor("")

        select AIND00
        set order to 1

        if dbseek(str(M_VENCOD, 3, 0))
          msg("* * * INDICAR JA CADASTRADO * * *")
          loop
        endif

        edind01()                      && edita dados da vendedor

        if lastkey() = 27
          msg("* * * INDICAR NAO INCLUIDO * * *")
          exit
        endif

        _append("AIND00")
        grind01()                      && grava dados da vendedor
        
        msg("* * * INDICAR INCLUIDO * * *")

    enddo

return ""

***************
function ALTIND
***************
        
    do while .t.

    tlind01() 

    rodape("ALTERA","INDICAR",M_FAN,"EAGRO29","Mem: " + str(memory(0), 5),M_EMP) 

        store 0 to M_VENCOD
        SetColor(_COREDICAO_)
        @ 10, 25 get     M_VENCOD   picture "###"
        read

        if M_VENCOD = 0
            exit
        endif

        select AIND00
 
        if !dbseek(str(M_VENCOD, 3, 0))
          msg("* * * INDICAR NAO CADASTRADO * * *")
          loop
        endif

        msind01()                      && mostra dados do vendedor

        if !rlock()
          msg("* * * (AIND00) REGISTRO SENDO USADO * * *")
          loop
        endif

       M_VENCPF  =  VENCPF
       M_VENNOM  =  VENNOM
       M_VENEND  =  VENEND
       M_VENBAI  =  VENBAI
       M_VENCEP  =  VENCEP
       M_VENCCE  =  VENCCE
       M_VENMUN  =  VENMUN
       M_VENEST  =  VENEST
       M_VENTEL  =  VENTEL
       M_VENIMS  =  VENIMS

        edind01() 

        if lastkey() = 27
          msg("* * * INDICAR NAO ALTERADO * * *")
          unlock
          loop 
        endif

        grind01()                      && grava dados da vendedor

        msg("* * * INDICAR ALTERADO * * *")

    enddo

return ""

***************
function CONIND
***************

private M_OPC ,;
        M_TELA

private M_VENCOD
             
    do while .t.

      tlind01() 

        rodape("CONSULTA","INDICAR",M_FAN,"EAGRO29","Mem: " + str(memory(0), 5),M_EMP) 

        store 0 to M_VENCOD
        SetColor(_COREDICAO_)
        @ 10, 25 get     M_VENCOD   picture "###"
        read

        if M_VENCOD = 0
            exit
        endif

        select AIND00

        set softseek on
          seek str(M_VENCOD, 3, 0)
        set softseek off

        setas()

        do while .t.

          if VENCOD = 0
            skip
            if eof()
              msg("* * * ARQUIVO VAZIO * * *")
              exit
            endif
            loop
          endif          

          msind01()

          inkey(0)

          if lastkey() = 5
             skip - 1
          endif         

          if lastkey() = 24
            skip + 1
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
function EXCIND
***************
        
private M_VENCOD ,;
        M_OPC
             
    do while .t.

      tlind01() 
 
        rodape("EXCLUI","INDICAR",M_FAN,"EAGRO29","Mem: " + str(memory(0), 5),M_EMP) 

        store 0 to M_VENCOD
        SetColor(_COREDICAO_)
        @ 10, 25 get     M_VENCOD   picture "###"
        read

        if M_VENCOD = 0
            exit
        endif

        select AIND00

        if !dbseek(str(M_VENCOD, 3, 0))
          msg("* * * INDICAR NAO CADASTRADO * * *")
          loop
        endif
        
        msind01()

        if !rlock()
          msg("* * * (AIND00) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_OPC = confirma("deste Codigo")

        if M_OPC != 1
          msg("* * * NAO EXCLUIDO * * *")
          unlock
          loop
        endif
        elimina()
        msg("* * * EXCLUIDO * * *")

    enddo

return ""

***************
function LISIND
*************** 

private M_COD1  ,;
        M_COD2  ,; 
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_TELA
 
    do while .t.

        rodape("LISTA","INDICAR",M_FAN,"EAGRO29","Mem: " + str(memory(0), 5),M_EMP) 

        store 0        to M_COD1,;
                          M_COD2

       sombra(10, 23, 13, 45,_SOMBRA_)

       set color to GR+/W+
         @ 10, 23 say      "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
         @ 11, 23 say      "³  Codigo Inicial:    ³" 
         @ 12, 23 say      "³           Final:    ³" 
         @ 13, 23 say      "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
        SetColor(_COREDICAO_)

        @ 11, 42 get M_COD1 picture "###"  
        @ 12, 42 get M_COD2 picture "###"   
        read

        if lastkey() = 27
            return ""
        endif

        M_COD1 = iif(M_COD1 = 0,  1,M_COD1)
        M_COD2 = iif(M_COD2 = 0,999,M_COD2) 

        select AIND00

        go top

        set softseek on
          seek str(M_COD1, 3, 0)
        set softseek off

        if VENCOD > M_COD2
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

        ? cent_cab(AEMP00->EMPFAN,"LISTAGEM","EAGRO29",132) 
        ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
        ? "*------*-------------------*----------------------------------------*-------------------------------------*---------*--*-----------*"
        ? "*CODIGO* CPF/CNPJ(MF)      * NOME                                   * ENDERECO                            * CEP     *UF* MUNICIPIO *"
        ? "*------*-------------------*----------------------------------------*-------------------------------------*---------*--*-----------*"
          * 999999 999.999.999/9999-99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99999 999 XX

        store 5 to LN

        do while !eof() .and. LN < 60

          if  VENCOD > M_COD2
            go bottom
            skip
            loop
          endif 

          ? "  "
            ?? str(VENCOD, 5, 0)
            ?? " "
            ?? transform(VENCPF,"@R 999.999.999/9999-99")
            ?? " "
            ?? VENNOM
            ?? " "
            ?? left(VENEND, 37)
            ?? " "
            ?? str(VENCEP, 5, 0)
            ?? " "
            ?? strzero(VENCCE, 3, 0)
            ?? " "
            ?? VENEST
            ?? " " 
            ?? left(VENMUN, 11)

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
function TLIND01
****************

 nbox(9, 13, 17, 66,"W/W+",.t.)
 setcolor("B/W")
    @ 10, 14 say     " Codigo  :            Cpf/Cnpj:                     "
    @ 11, 14 say     " Nome    :                                          "
    @ 12, 14 say     " Relatorio IMS S/N:   ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 13, 14 say     " Endereco:                                          "
    @ 14, 14 say     " Bairro  :                           Cep:           "
    @ 15, 14 say     " Cidade  :                            Uf:           "
    @ 16, 14 say     " Telefone:                                          "
set color to

return ""

****************
function EDIND01
****************
    SetColor(_COREDICAO_)
    @ 10, 46 get     M_VENCPF picture "@R 999.999.999/9999-99"
    @ 11, 25 get     M_VENNOM picture "@!"
    @ 12, 34 get     M_VENIMS picture "@!" valid M_VENIMS $ "SN"
    @ 13, 25 get     M_VENEND picture "@!"
    @ 14, 25 get     M_VENBAI picture "@!"
    @ 14, 56 get     M_VENCEP picture "#####"
    @ 14, 62 get     M_VENCCE picture "###"
    @ 15, 25 get     M_VENMUN picture "@!"
    @ 15, 56 get     M_VENEST picture "@!" valid   verest(M_VENEST)
    @ 16, 25 get     M_VENTEL picture "@!"
    read

return ""

****************
function MSIND01
****************

  setcolor("N/W*")
    @ 10, 25 say     VENCOD   picture "###"
    @ 10, 46 say     VENCPF picture "@R 999.999.999/9999-99"
    @ 11, 25 say     VENNOM picture "@!"    
    @ 12, 34 say     VENIMS picture "@!" 
    @ 13, 25 say     VENEND picture "@!"    
    @ 14, 25 say     VENBAI picture "@!"    
    @ 14, 56 say     VENCEP picture "#####"            
    @ 14, 62 say     VENCCE picture "###"            
    @ 15, 25 say     VENMUN picture "@!"               
    @ 15, 56 say     VENEST picture "@!" 
    @ 16, 25 say     VENTEL picture "@!"               
 set color to
  
return ""

****************
function GRIND01                       && grava dados da vendedor
****************

  do while .t.
    if rlock()
      replace  VENCOD   with  M_VENCOD
      replace  VENCPF   with  M_VENCPF
      replace  VENNOM   with  M_VENNOM
      replace  VENEND   with  M_VENEND
      replace  VENBAI   with  M_VENBAI
      replace  VENCEP   with  M_VENCEP
      replace  VENCCE   with  M_VENCCE 
      replace  VENMUN   with  M_VENMUN
      replace  VENEST   with  M_VENEST
      replace  VENTEL   with  M_VENTEL
      replace  VENIMS   with  M_VENIMS
      unlock   
      commit
      exit
    else
      msg("* * * (AIND00) REGISTRO SENDO USADO * * *") 
    endif
    if lastkey()=17
      exit
    endif
  enddo

return ""
