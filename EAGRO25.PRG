***************
function MANVEN
***************
parameters M_OPC,M_OPC1,M_OPC2

#include "ptmenu.ch"


      rodape("MENU","VENDEDOR",M_FAN,"EAGRO25","Mem: " + str(memory(0), 5),M_EMP) 

*        @ 05, 19 prompt "InclusÆo " HIGHLITE R/BG            PERMITE 5,2,1
*        @ 06, 19 prompt "Altera‡Æo" HIGHLITE R/BG            PERMITE 5,2,2
*        @ 07, 19 prompt "Consulta " HIGHLITE R/BG            PERMITE 5,2,3
*        @ 08, 19 prompt "ExclusÆo " HIGHLITE R/BG            PERMITE 5,2,4
*        @ 09, 19 prompt "Listagem " HIGHLITE R/BG            PERMITE 5,2,5
*        @ 10, 19 prompt "ComissÆo " HIGHLITE R/BG POSITION 2 PERMITE 5,2,6

      do case
         case M_OPC = 1 ; incven()
         case M_OPC = 2 ; altven()
         case M_OPC = 3 ; conven()
         case M_OPC = 4 ; excven()
*         case M_OPC = 5 ; lisven()
         case M_OPC = 6 ; outven(M_OPC1)
      endcase

    fecha_arq()

return ""

***************
function INCVEN
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

      tlven01() 

      rodape("INCLUI","VENDEDOR",M_FAN,"EAGRO25","Mem: " + str(memory(0), 5),M_EMP) 

        setcolor("I")
        @ 10, 25 get     M_VENCOD   picture "###"
        setcolor("")

        if BUSCAREGISTRO("AVEN00",1,{str(M_VENCOD, 3, 0)},"SELECT")
          msg("* * * VENDEDOR JA CADASTRADO * * *")
          loop
        endif

        edven01()                      && edita dados da vendedor

        if lastkey() = 27
          msg("* * * VENDEDOR NAO INCLUIDO * * *")
          exit
        endif

        grven01("INSERT")                      && grava dados da vendedor

        msg("* * * VENDEDOR INCLUIDO * * *")

    enddo

return ""

***************
function ALTVEN
***************
        
    do while .t.

    tlven01() 

    rodape("ALTERA","VENDEDOR",M_FAN,"EAGRO25","Mem: " + str(memory(0), 5),M_EMP) 

        store 0 to M_VENCOD
        SetColor(_COREDICAO_)
        @ 10, 25 get     M_VENCOD   picture "###"
        read

        if M_VENCOD = 0
            exit
        endif

  if !BUSCAREGISTRO("AVEN00",1,{str(M_VENCOD, 3, 0)},"SELECT")
    msg("* * * VENDEDOR NAO CADASTRADO * * *")
    loop
  endif

        msven01()                      && mostra dados do vendedor


       M_VENCPF  =  VENCPF
       M_VENNOM  =  VENNOM
       M_VENEND  =  VENEND
       M_VENBAI  =  VENBAI
       M_VENCEP  =  VENCEP
       M_VENCCE  =  VENCCE
       M_VENMUN  =  VENMUN
       M_VENEST  =  VENEST
       M_VENTEL  =  VENTEL
       M_VENSUP  =  VENSUP

        edven01() 

        if lastkey() = 27
          msg("* * * VENDEDOR NAO ALTERADO * * *")
          loop
        endif

  grven01("UPDATE")                      && grava dados da vendedor

        msg("* * * VENDEDOR ALTERADO * * *")

    enddo

return ""

***************
function CONVEN
***************

private M_VENCOD

do while .t.

  tlven01()

  rodape("CONSULTA","VENDEDOR",M_FAN,"EAGRO25","Mem: " + str(memory(0), 5),M_EMP)

  store 0 to M_VENCOD
  M_VENNOM  = space(40)

  SetColor(_COREDICAO_)
  @ 10, 25 get     M_VENCOD   picture "###"
  read

  if M_VENCOD = 0
    @ 11, 25 get M_VENNOM picture "@!"
    read
  endif

  if empty(M_VENNOM)
    if M_VENCOD = 0
      exit
    endif
    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}
    aadd(sqlARQUI,{"AVEN00","AVEN00"})
    aadd(sqlCAMPO,"*")
    aadd(sqlCHAVE,"VENCOD >= " + str(M_VENCOD, 3, 0))
    aadd(sqlORDEM,"VENCOD")
    sqlrelation()
  else
    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}
    aadd(sqlARQUI,{"AVEN00","AVEN00"})
    aadd(sqlCAMPO,"*")
    aadd(sqlCHAVE,"VENNOM >= " + aspas(alltrim(M_VENNOM)))
    aadd(sqlORDEM,"VENNOM")
    sqlrelation()
  endif


  do while .t.

    msven01()

    waitstate()

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

enddo

return ""
***************
function EXCVEN
***************
        
do while .t.

  tlven01()

  rodape("EXCLUI","VENDEDOR",M_FAN,"EAGRO25","Mem: " + str(memory(0), 5),M_EMP)

  store 0 to M_VENCOD
  SetColor(_COREDICAO_)
  @ 10, 25 get     M_VENCOD   picture "###"
  read

  if M_VENCOD = 0
    exit
  endif

  if !BUSCAREGISTRO("AVEN00",1,{str(M_VENCOD, 3, 0)},"SELECT")
    msg("* * * VENDEDOR NAO CADASTRADO * * *")
    loop
  endif

  msven01()

  M_OPC = confirma("deste Vendedor")

  if M_OPC # 1
    msg("* * * VENDEDOR NAO EXCLUIDO * * *")
    loop
  endif

  grven01("DELETE")                      && grava dados da vendedor

  msg("* * * VENDEDOR EXCLUIDO * * *")

enddo

return ""

***************
function LISVEN
*************** 

private M_COD1  ,;
        M_COD2  ,; 
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_TELA
 
    do while .t.

        rodape("LISTA","VENDEDOR",M_FAN,"EAGRO25","Mem: " + str(memory(0), 5),M_EMP) 

        store 0        to M_COD1,;
                          M_COD2

       sombra(10, 23, 13, 45,_SOMBRA_)

       set color to GR+/W+
         @ 10, 23 say      "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
         @ 11, 23 say      "³Vendedor Inicial:    ³" 
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

        select AVEN00

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

        ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE VENDEDORES","EEST24",132) 
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

***************
function OUTVEN
***************
parameters M_OPC,M_OPC1,M_OPC2

*        @ 09, 24 prompt "Pagamento " HIGHLITE R/BG
*        @ 10, 24 prompt "Vencimento" HIGHLITE R/BG
*        @ 11, 24 prompt "Emissao   " HIGHLITE R/BG
*        @ 12, 24 prompt "Aberto    " HIGHLITE R/BG

      do case
*         case M_OPC = 1 ; outven_a()
*         case M_OPC = 2 ; outven_b()
*         case M_OPC = 3 ; outven_c()
*         case M_OPC = 4 ; outven_d()
      endcase             


return ""

*****************
function OUTVEN_A
*****************

msw("* * * AGUARDE... ABRINDO ARQUIVOS * * *")

abre_dcr("3") && duplicatas 
abre_cli("4") && clientes  

if file("ACOM00.CDX")                   
  erase("ACOM00.CDX")                   
endif

select 7         && comissao         

use ACOM00 alias ACOM00 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

private M_TELA

  do while .t.

      rodape("COMISSAO","PAGAMENTO",M_FAN,"EAGRO25","Mem: " + str(memory(0), 5),M_EMP) 

        store 0               to M_VENINI,;
                                 M_VENFIN,;
                                 M_VENANT

        store 0               to M_DUPVEN ,;
                                 M_DUPGER ,;
                                 M_COMVEN ,;
                                 M_COMGER 

        store ctod("  /  /  ") to M_PERINI,;
                                  M_PERFIN

       store "N" to M_SUP

       sombra(09, 24, 15, 51,_SOMBRA_)

       set color to GR+/W+
         @ 09, 24 say      "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
         @ 10, 24 say      "³Vendedor Inicial:         ³" 
         @ 11, 24 say      "³           Final:         ³" 
         @ 12, 24 say      "³    Pgto Inicial:         ³" 
         @ 13, 24 say      "³           Final:         ³" 
         @ 14, 24 say      "³      Supervisor:         ³" 
         @ 15, 24 say      "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
  SetColor(_COREDICAO_)

        @ 10, 43 get M_VENINI picture "###"
        @ 11, 43 get M_VENFIN picture "###"
        @ 12, 43 get M_PERINI 
        @ 13, 43 get M_PERFIN 
        @ 14, 43 get M_SUP picture "@!"
        read

        if lastkey() = 27
          exit
        endif

        M_VENINI = iif(M_VENINI = 0,     1,M_VENINI)
        M_VENFIN = iif(M_VENFIN = 0, 99999,M_VENFIN) 
        M_PERINI = iif(dtoc(M_PERINI) = "  /  /  ",ctod("01/01/80"),M_PERINI)
        M_PERFIN = iif(dtoc(M_PERFIN) = "  /  /  ",ctod("31/12/79"),M_PERFIN) 

        select ACOM00

        if !flock()
          msg("* * * (ACOM00) ARQUIVO NAO DISPONIVEL * * *")
          exit
        endif

        zap

        index on str(DUPEMP, 2, 0) + str(DUPVEN, 3, 0) + dtos(DUPDTP) tag 1 to ACOM00

        set index to ACOM00

        select ADCR00

        set order to 7 

        dbseek(str(ME_EMP, 2, 0) + dtos(M_PERINI),.t.)

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(DUPEMP, 2, 0) + dtos(DUPDTP) > str(ME_EMP, 2, 0) + dtos(M_PERFIN)
            exit
          endif 

          if DUPVEN < M_VENINI .or. DUPVEN > M_VENFIN
            skip
            loop
          endif

          if M_SUP == "S"
            if DUPCMS = 0
              skip
              loop
            endif
          endif
          
          select ACOM00
     
          append blank         

          replace DUPEMP with ADCR00->DUPEMP
          replace DUPVEN with ADCR00->DUPVEN
          replace DUPDTP with ADCR00->DUPDTP
          replace DUPNUM with ADCR00->DUPNUM
          replace DUPORD with ADCR00->DUPORD
          replace DUPVCT with ADCR00->DUPVCT
          replace DUPVLO with ADCR00->DUPVLO
          replace DUPCMS with ADCR00->DUPCMS
          replace DUPCMV with ADCR00->DUPCMV  
          replace DUPCLI with ADCR00->DUPCLI  

          select ADCR00

          M_ESC = inkey()

          if M_ESC = 27
            if suspro()
              msg("* * * PROCESSO SUSPENSO * * *")
              go bottom
              skip
              loop
            else
              M_ESC = inkey()
            endif
          endif

          select ADCR00

          skip
 
        enddo

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          exit
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        PG = 0
        LN = 0

        select ACOM00

        go top

        set relation to str(DUPVEN, 3, 0) into AVEN00 ,;
                     to str(DUPCLI, 7, 0) into ACLI00

        cab_com1()

        do while !eof()

          if M_VENANT != DUPVEN 
            if M_DUPVEN > 0
              ? space(66)
                ?? "TOTAL DO VENDEDOR -=>         "
                ?? transform(M_DUPVEN,"@E ###,###.##")
                ?? "               "
                ?? transform(M_COMVEN,"@E ###,###.##")
              ? replicate("=",132)
              LN = LN + 2
              if LN > 60
                cab_com1()
              endif
            endif
            ? " **** "
              ?? str(DUPVEN, 3, 0)
              ?? " "
              ?? AVEN00->VENNOM 
              ?? " "
              ?? AVEN00->VENMUN
              ?? " "
              ?? AVEN00->VENEST
              ?? " **** "
              ?? iif(AVEN00->VENSUP="S","SUPERVISOR","NORMAL   ")
              ?? " ****"
            ?
              M_VENANT = DUPVEN
              M_DUPVEN = 0
              M_COMVEN = 0
              LN = LN + 2
              if LN > 60
                cab_com1()
              endif
          endif

          ? space(01)
            ?? DUPNUM
            ?? "/"
            ?? DUPORD
            ?? " "
            ?? str(DUPCLI, 7, 0)
            ?? " "
            ?? pad(ACLI00->CLINOM, 40)
            ?? " "            
            ?? pad(ACLI00->CLIMUN3, 14)
            ?? " "            
            ?? ACLI00->CLIUF3
            ?? " "
            ?? DUPVCT
            ?? " "
            ?? DUPDTP
            ?? " "
            ?? transform(DUPVLO,"@E ###,###.##")
            ?? " "
            ?? transform(DUPCMS,"@E@Z ###.##")
            ?? " "
            ?? transform(DUPCMV,"@E@Z ###.##")
            ?? " "
            if M_SUP = "S"
              ?? transform((DUPVLO * .01) * DUPCMS,"@E ###,###.##")
            else
              ?? transform((DUPVLO * .01) * DUPCMV,"@E ###,###.##")
            endif

            M_DUPVEN = M_DUPVEN + DUPVLO
            M_DUPGER = M_DUPGER + DUPVLO

            if M_SUP = "S"
              M_COMVEN = M_COMVEN + ((DUPVLO * .01) * DUPCMS)
              M_COMGER = M_COMGER + ((DUPVLO * .01) * DUPCMS)
            else
              M_COMVEN = M_COMVEN + ((DUPVLO * .01) * DUPCMV)
              M_COMGER = M_COMGER + ((DUPVLO * .01) * DUPCMV)
            endif

            LN = LN + 1

            if LN > 60
              cab_com1()
            endif

            select ACOM00

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

        ? space(66)
          ?? "TOTAL DO VENDEDOR -=>         "
          ?? transform(M_DUPVEN,"@E ###,###.##")
          ?? "               "
          ?? transform(M_COMVEN,"@E ###,###.##")
      ? replicate("=",132)
        ? space(66)
          ?? "TOTAL GERAL       -=>         "
          ?? transform(M_DUPGER,"@E ###,###.##")
          ?? "               "
          ?? transform(M_COMGER,"@E ###,###.##")

      eject

desliga1()

  enddo 

return "" 

*****************
function OUTVEN_B
*****************

msw("* * * AGUARDE... ABRINDO ARQUIVOS * * *")

abre_dcr("3") && duplicatas 
abre_cli("4") && clientes  

if file("ACOM00.CDX")
  erase("ACOM00.CDX")
endif

select 7         && comissao         

use ACOM00 alias ACOM00 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

private M_TELA

  do while .t.

      rodape("COMISSAO","VENCIMENTO",M_FAN,"EAGRO25","Mem: " + str(memory(0), 5),M_EMP) 

        store 0               to M_VENINI,;
                                 M_VENFIN,;
                                 M_VENANT

        store 0               to M_DUPVEN ,;
                                 M_DUPGER ,;
                                 M_COMVEN ,;
                                 M_COMGER 

        store ctod("  /  /  ") to M_PERINI,;
                                  M_PERFIN




       store "N" to M_SUP

       sombra(09, 24, 15, 51,_SOMBRA_)

       set color to GR+/W+
         @ 09, 24 say      "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
         @ 10, 24 say      "³Vendedor Inicial:         ³" 
         @ 11, 24 say      "³           Final:         ³" 
         @ 12, 24 say      "³  Vencto Inicial:         ³" 
         @ 13, 24 say      "³           Final:         ³" 
         @ 14, 24 say      "³      Supervisor:         ³" 
         @ 15, 24 say      "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
  SetColor(_COREDICAO_)

        @ 10, 43 get M_VENINI picture "###"
        @ 11, 43 get M_VENFIN picture "###"
        @ 12, 43 get M_PERINI 
        @ 13, 43 get M_PERFIN 
        @ 14, 43 get M_SUP picture "@!"
        read

        if lastkey() = 27
          exit
        endif

        M_VENINI = iif(M_VENINI = 0,     1,M_VENINI)
        M_VENFIN = iif(M_VENFIN = 0, 99999,M_VENFIN) 
        M_PERINI = iif(dtoc(M_PERINI) = "  /  /  ",ctod("01/01/80"),M_PERINI)
        M_PERFIN = iif(dtoc(M_PERFIN) = "  /  /  ",ctod("31/12/79"),M_PERFIN) 

        select ACOM00

        if !flock()
          msg("* * * (ACOM00) ARQUIVO NAO DISPONIVEL * * *")
          exit
        endif

        zap

        index on str(DUPEMP, 2, 0) + str(DUPVEN, 3, 0) + dtos(DUPVCT) tag 1 to ACOM00

        set index to ACOM00

        select ADCR00

        set order to 5 

        dbseek(str(ME_EMP, 2, 0) + dtos(M_PERINI),.t.)

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(DUPEMP, 2, 0) + dtos(DUPVCT) > str(ME_EMP, 2, 0) + dtos(M_PERFIN)
            exit
          endif 

          if DUPVEN < M_VENINI .or. DUPVEN > M_VENFIN
            skip
            loop
          endif

          if M_SUP == "S"
            if DUPCMS = 0
              skip
              loop
            endif
          endif

          select ACOM00
     
          append blank         

          replace DUPEMP with ADCR00->DUPEMP
          replace DUPVEN with ADCR00->DUPVEN
          replace DUPDTP with ADCR00->DUPDTP
          replace DUPNUM with ADCR00->DUPNUM
          replace DUPORD with ADCR00->DUPORD
          replace DUPDTE with ADCR00->DUPDTE
          replace DUPVCT with ADCR00->DUPVCT
          replace DUPVLO with ADCR00->DUPVLO
          replace DUPCMS with ADCR00->DUPCMS
          replace DUPCMV with ADCR00->DUPCMV  
          replace DUPCLI with ADCR00->DUPCLI  

          select ADCR00

          M_ESC = inkey()

          if M_ESC = 27
            if suspro()
              msg("* * * PROCESSO SUSPENSO * * *")
              go bottom
              skip
              loop
            else
              M_ESC = inkey()
            endif
          endif

          select ADCR00

          skip
 
        enddo

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          exit
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        PG = 0
        LN = 0

        select ACOM00

        go top

        set relation to str(DUPVEN, 3, 0) into AVEN00 ,;
                     to str(DUPCLI, 7, 0) into ACLI00

        cab_com1()

        do while !eof()

          if M_VENANT != DUPVEN 
            if M_DUPVEN > 0
              ? space(66)
                ?? "TOTAL DO VENDEDOR -=>         "
                ?? transform(M_DUPVEN,"@E ###,###.##")
                ?? "               "
                ?? transform(M_COMVEN,"@E ###,###.##")
              ? replicate("=",132)
              LN = LN + 2
              if LN > 60
                cab_com1()
              endif
            endif
            ? " **** "
              ?? str(DUPVEN, 3, 0)
              ?? " "
              ?? AVEN00->VENNOM 
              ?? " "
              ?? AVEN00->VENMUN
              ?? " "
              ?? AVEN00->VENEST
              ?? " **** "
              ?? iif(M_SUP="S","SUPERVISOR","NORMAL   ")
              ?? " ****"
            ?
              M_VENANT = DUPVEN
              M_DUPVEN = 0
              M_COMVEN = 0
              LN = LN + 2
              if LN > 60
                cab_com1()
              endif
          endif

          ? space(01)
            ?? DUPNUM
            ?? "/"
            ?? DUPORD
            ?? " "
            ?? str(DUPCLI, 7, 0)
            ?? " "
            ?? pad(ACLI00->CLINOM, 31)
            ?? " "            
            ?? pad(ACLI00->CLIMUN3, 14)
            ?? " "            
            ?? ACLI00->CLIUF3
            ?? " "
            ?? DUPDTE
            ?? " "
            ?? DUPVCT
            ?? " "
            ?? DUPDTP
            ?? " "
            ?? transform(DUPVLO,"@E ###,###.##")
            ?? " "
            ?? transform(DUPCMS,"@E@Z ###.##")
            ?? " "
            ?? transform(DUPCMV,"@E@Z ###.##")
            ?? " "
            if M_SUP = "S"
              ?? transform((DUPVLO * .01) * DUPCMS,"@E ###,###.##")
            else
              ?? transform((DUPVLO * .01) * DUPCMV,"@E ###,###.##")
            endif

            M_DUPVEN = M_DUPVEN + DUPVLO
            M_DUPGER = M_DUPGER + DUPVLO

            if M_SUP = "S"
              M_COMVEN = M_COMVEN + ((DUPVLO * .01) * DUPCMS)
              M_COMGER = M_COMGER + ((DUPVLO * .01) * DUPCMS)
            else
              M_COMVEN = M_COMVEN + ((DUPVLO * .01) * DUPCMV)
              M_COMGER = M_COMGER + ((DUPVLO * .01) * DUPCMV)
            endif

            LN = LN + 1

            if LN > 60
              cab_com1()
            endif

            select ACOM00

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

        ? space(66)
          ?? "TOTAL DO VENDEDOR -=>         "
          ?? transform(M_DUPVEN,"@E ###,###.##")
          ?? "               "
          ?? transform(M_COMVEN,"@E ###,###.##")
      ? replicate("=",132)
        ? space(66)
          ?? "TOTAL GERAL       -=>         "
          ?? transform(M_DUPGER,"@E ###,###.##")
          ?? "               "
          ?? transform(M_COMGER,"@E ###,###.##")

      eject

desliga1()

  enddo 

return "" 

*****************
function OUTVEN_C
*****************

msw("* * * AGUARDE... ABRINDO ARQUIVOS * * *")

abre_dcr("3") && duplicatas 
abre_cli("4") && clientes  

if file("ACOM00.CDX")
  erase("ACOM00.CDX")
endif

select 7         && comissao         

use ACOM00 alias ACOM00 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

private M_TELA

  do while .t.

      rodape("COMISSAO","EMISSAO",M_FAN,"EAGRO25","Mem: " + str(memory(0), 5),M_EMP) 

        store 0               to M_VENINI,;
                                 M_VENFIN,;
                                 M_VENANT

        store 0               to M_DUPVEN ,;
                                 M_DUPGER ,;
                                 M_COMVEN ,;
                                 M_COMGER 

        store ctod("  /  /  ") to M_PERINI,;
                                  M_PERFIN

       store "N" to M_SUP

       sombra(09, 24, 15, 51,_SOMBRA_)

       set color to GR+/W+
         @ 09, 24 say      "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
         @ 10, 24 say      "³Vendedor Inicial:         ³" 
         @ 11, 24 say      "³           Final:         ³" 
         @ 12, 24 say      "³ Emissao Inicial:         ³" 
         @ 13, 24 say      "³           Final:         ³" 
         @ 14, 24 say      "³      Supervisor:         ³" 
         @ 15, 24 say      "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
  SetColor(_COREDICAO_)

        @ 10, 43 get M_VENINI picture "###"
        @ 11, 43 get M_VENFIN picture "###"
        @ 12, 43 get M_PERINI 
        @ 13, 43 get M_PERFIN 
        @ 14, 43 get M_SUP    picture "@!"
        read

        if lastkey() = 27
          exit
        endif

        M_VENINI = iif(M_VENINI = 0,     1,M_VENINI)
        M_VENFIN = iif(M_VENFIN = 0, 99999,M_VENFIN) 
        M_PERINI = iif(dtoc(M_PERINI) = "  /  /  ",ctod("01/01/80"),M_PERINI)
        M_PERFIN = iif(dtoc(M_PERFIN) = "  /  /  ",ctod("31/12/79"),M_PERFIN) 

        select ACOM00

        if !flock()
          msg("* * * (ACOM00) ARQUIVO NAO DISPONIVEL * * *")
          exit
        endif

        zap

        index on str(DUPEMP, 2, 0) + str(DUPVEN, 3, 0) + dtos(DUPVCT) tag 1 to ACOM00

        set index to ACOM00

        select ADCR00

        set order to 4 

        dbseek(str(ME_EMP, 2, 0) + dtos(M_PERINI),.t.)

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(DUPEMP, 2, 0) + dtos(DUPDTE) > str(ME_EMP, 2, 0) + dtos(M_PERFIN)
            exit
          endif 

          if DUPVEN < M_VENINI .or. DUPVEN > M_VENFIN
            skip
            loop
          endif

          if M_SUP == "S"
            if DUPCMS = 0
              skip
              loop
            endif
          endif

          select ACOM00
     
          append blank         

          replace DUPEMP with ADCR00->DUPEMP
          replace DUPVEN with ADCR00->DUPVEN
          replace DUPDTP with ADCR00->DUPDTP
          replace DUPNUM with ADCR00->DUPNUM
          replace DUPORD with ADCR00->DUPORD
          replace DUPDTE with ADCR00->DUPDTE
          replace DUPVCT with ADCR00->DUPVCT
          replace DUPVLO with ADCR00->DUPVLO
          replace DUPCMS with ADCR00->DUPCMS
          replace DUPCMV with ADCR00->DUPCMV  
          replace DUPCLI with ADCR00->DUPCLI  

          select ADCR00

          M_ESC = inkey()

          if M_ESC = 27
            if suspro()
              msg("* * * PROCESSO SUSPENSO * * *")
              go bottom
              skip
              loop
            else
              M_ESC = inkey()
            endif
          endif

          select ADCR00

          skip
 
        enddo

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          exit
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        PG = 0
        LN = 0

        select ACOM00

        go top

        set relation to str(DUPVEN, 3, 0) into AVEN00 ,;
                     to str(DUPCLI, 7, 0) into ACLI00

        cab_com1()

        do while !eof()

          if M_VENANT != DUPVEN 
            if M_DUPVEN > 0
              ? space(66)
                ?? "TOTAL DO VENDEDOR -=>         "
                ?? transform(M_DUPVEN,"@E ###,###.##")
                ?? "               "
                ?? transform(M_COMVEN,"@E ###,###.##")
              ? replicate("=",132)
              LN = LN + 2
              if LN > 60
                cab_com1()
              endif
            endif
            ? " **** "
              ?? str(DUPVEN, 3, 0)
              ?? " "
              ?? AVEN00->VENNOM 
              ?? " "
              ?? AVEN00->VENMUN
              ?? " "
              ?? AVEN00->VENEST
              ?? " **** "
              ?? iif(M_SUP="S","SUPERVISOR","NORMAL   ")
              ?? " ****"
            ?
              M_VENANT = DUPVEN
              M_DUPVEN = 0
              M_COMVEN = 0
              LN = LN + 2
              if LN > 60
                cab_com1()
              endif
          endif

          ? space(01)
            ?? DUPNUM
            ?? "/"
            ?? DUPORD
            ?? " "
            ?? str(DUPCLI, 7, 0)
            ?? " "
            ?? pad(ACLI00->CLINOM, 31)
            ?? " "            
            ?? pad(ACLI00->CLIMUN3, 14)
            ?? " "            
            ?? ACLI00->CLIUF3
            ?? " "
            ?? DUPDTE
            ?? " "
            ?? DUPVCT
            ?? " "
            ?? DUPDTP
            ?? " "
            ?? transform(DUPVLO,"@E ###,###.##")
            ?? " "
            ?? transform(DUPCMS,"@E@Z ###.##")
            ?? " "
            ?? transform(DUPCMV,"@E@Z ###.##")
            ?? " "
            if M_SUP = "S"
              ?? transform((DUPVLO * .01) * DUPCMS,"@E ###,###.##")
            else
              ?? transform((DUPVLO * .01) * DUPCMV,"@E ###,###.##")
            endif

            M_DUPVEN = M_DUPVEN + DUPVLO
            M_DUPGER = M_DUPGER + DUPVLO

            if M_SUP = "S"
              M_COMVEN = M_COMVEN + ((DUPVLO * .01) * DUPCMS)
              M_COMGER = M_COMGER + ((DUPVLO * .01) * DUPCMS)
            else
              M_COMVEN = M_COMVEN + ((DUPVLO * .01) * DUPCMV)
              M_COMGER = M_COMGER + ((DUPVLO * .01) * DUPCMV)
            endif

            LN = LN + 1

            if LN > 60
              cab_com1()
            endif

            select ACOM00

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

        ? space(66)
          ?? "TOTAL DO VENDEDOR -=>         "
          ?? transform(M_DUPVEN,"@E ###,###.##")
          ?? "               "
          ?? transform(M_COMVEN,"@E ###,###.##")
      ? replicate("=",132)
        ? space(66)
          ?? "TOTAL GERAL       -=>         "
          ?? transform(M_DUPGER,"@E ###,###.##")
          ?? "               "
          ?? transform(M_COMGER,"@E ###,###.##")

      eject

desliga1()

  enddo 

return "" 

*****************
function OUTVEN_D
*****************

msw("* * * AGUARDE... ABRINDO ARQUIVOS * * *")

abre_dcr("3") && duplicatas 
abre_cli("4") && clientes  

if file("ACOM00.CDX")
  erase("ACOM00.CDX")
endif

select 7         && comissao         

use ACOM00 alias ACOM00 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

private M_TELA

  do while .t.

      rodape("COMISSAO","EMISSAO",M_FAN,"EAGRO25","Mem: " + str(memory(0), 5),M_EMP) 

        store 0               to M_VENINI,;
                                 M_VENFIN,;
                                 M_VENANT

        store 0               to M_DUPVEN ,;
                                 M_DUPGER ,;
                                 M_COMVEN ,;
                                 M_COMGER 

        store ctod("  /  /  ") to M_PERINI,;
                                  M_PERFIN

       store "A"               to M_SIT
       store "N"               to M_SUP

       sombra(09, 24, 16, 51,_SOMBRA_)

       set color to GR+/W+
         @ 09, 24 say      "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
         @ 10, 24 say      "³Vendedor Inicial:         ³" 
         @ 11, 24 say      "³           Final:         ³" 
         @ 12, 24 say      "³ Emissao Inicial:         ³" 
         @ 13, 24 say      "³           Final:         ³" 
         @ 14, 24 say      "³        Situacao:         ³" 
         @ 15, 24 say      "³      Supervisor:         ³" 
         @ 16, 24 say      "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
  SetColor(_COREDICAO_)

        @ 10, 43 get M_VENINI picture "###"
        @ 11, 43 get M_VENFIN picture "###"
        @ 12, 43 get M_PERINI 
        @ 13, 43 get M_PERFIN 
        @ 14, 43 get M_SIT    picture "@!" valid(M_SIT $ "APT")
        @ 15, 43 get M_SUP    picture "@!" valid(M_SUP $ "SN")
        read

        if lastkey() = 27
          exit
        endif

        M_VENINI = iif(M_VENINI = 0,     1,M_VENINI)
        M_VENFIN = iif(M_VENFIN = 0, 99999,M_VENFIN) 
        M_PERINI = iif(dtoc(M_PERINI) = "  /  /  ",ctod("01/01/80"),M_PERINI)
        M_PERFIN = iif(dtoc(M_PERFIN) = "  /  /  ",ctod("31/12/79"),M_PERFIN) 

        select ACOM00

        if !flock()
          msg("* * * (ACOM00) ARQUIVO NAO DISPONIVEL * * *")
          exit
        endif

        zap

        index on str(DUPEMP, 2, 0) + str(DUPVEN, 3, 0) + dtos(DUPVCT) tag 1 to ACOM00

        set index to ACOM00

        select ADCR00

        set order to 4 

        dbseek(str(ME_EMP, 2, 0) + dtos(M_PERINI),.t.)

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(DUPEMP, 2, 0) + dtos(DUPDTE) > str(ME_EMP, 2, 0) + dtos(M_PERFIN)
            exit
          endif 

          if DUPVEN < M_VENINI .or. DUPVEN > M_VENFIN
            skip
            loop
          endif

          if !M_SIT = "T"
            if M_SIT = "A"
              if DUPHIS != 500
                skip
                loop
              endif
            else
              if DUPHIS != 100
                skip
                loop
              endif
            endif
          endif

          if M_SUP == "S"
            if DUPCMS = 0
              skip
              loop
            endif
          endif
 
          select ACOM00
     
          append blank         

          replace DUPEMP with ADCR00->DUPEMP
          replace DUPVEN with ADCR00->DUPVEN
          replace DUPDTP with ADCR00->DUPDTP
          replace DUPNUM with ADCR00->DUPNUM
          replace DUPORD with ADCR00->DUPORD
          replace DUPDTE with ADCR00->DUPDTE
          replace DUPVCT with ADCR00->DUPVCT
          replace DUPVLO with ADCR00->DUPVLO
          replace DUPCMS with ADCR00->DUPCMS
          replace DUPCMV with ADCR00->DUPCMV  
          replace DUPCLI with ADCR00->DUPCLI  

          select ADCR00

          M_ESC = inkey()

          if M_ESC = 27
            if suspro()
              msg("* * * PROCESSO SUSPENSO * * *")
              go bottom
              skip
              loop
            else
              M_ESC = inkey()
            endif
          endif

          select ADCR00

          skip
 
        enddo

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          exit
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        PG = 0
        LN = 0

        select ACOM00

        go top

        set relation to str(DUPVEN, 3, 0) into AVEN00 ,;
                     to str(DUPCLI, 7, 0) into ACLI00

        cab_com1()

        do while !eof()

          if M_VENANT != DUPVEN 
            if M_DUPVEN > 0
              ? space(66)
                ?? "TOTAL DO VENDEDOR -=>         "
                ?? transform(M_DUPVEN,"@E ###,###.##")
                ?? "               "
                ?? transform(M_COMVEN,"@E ###,###.##")
              ? replicate("=",132)
              LN = LN + 2
              if LN > 60
                cab_com1()
              endif
            endif
            ? " **** "
              ?? str(DUPVEN, 3, 0)
              ?? " "
              ?? AVEN00->VENNOM 
              ?? " "
              ?? AVEN00->VENMUN
              ?? " "
              ?? AVEN00->VENEST
              ?? " **** "
              ?? iif(M_SUP="S","SUPERVISOR","NORMAL   ")
              ?? " ****"
            ?
              M_VENANT = DUPVEN
              M_DUPVEN = 0
              M_COMVEN = 0
              LN = LN + 2
              if LN > 60
                cab_com1()
              endif
          endif

          ? space(01)
            ?? DUPNUM
            ?? "/"
            ?? DUPORD
            ?? " "
            ?? str(DUPCLI, 7, 0)
            ?? " "
            ?? pad(ACLI00->CLINOM, 31)
            ?? " "            
            ?? pad(ACLI00->CLIMUN3, 14)
            ?? " "            
            ?? ACLI00->CLIUF3
            ?? " "
            ?? DUPDTE
            ?? " "
            ?? DUPVCT
            ?? " "
            ?? DUPDTP
            ?? " "
            ?? transform(DUPVLO,"@E ###,###.##")
            ?? " "
            ?? transform(DUPCMS,"@E@Z ###.##")
            ?? " "
            ?? transform(DUPCMV,"@E@Z ###.##")
            ?? " "
            if M_SUP = "S"
              ?? transform((DUPVLO * .01) * DUPCMS,"@E ###,###.##")
            else
              ?? transform((DUPVLO * .01) * DUPCMV,"@E ###,###.##")
            endif

            M_DUPVEN = M_DUPVEN + DUPVLO
            M_DUPGER = M_DUPGER + DUPVLO

            if M_SUP = "S"
              M_COMVEN = M_COMVEN + ((DUPVLO * .01) * DUPCMS)
              M_COMGER = M_COMGER + ((DUPVLO * .01) * DUPCMS)
            else
              M_COMVEN = M_COMVEN + ((DUPVLO * .01) * DUPCMV)
              M_COMGER = M_COMGER + ((DUPVLO * .01) * DUPCMV)
            endif

            LN = LN + 1

            if LN > 60
              cab_com1()
            endif

            select ACOM00

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

        ? space(66)
          ?? "TOTAL DO VENDEDOR -=>         "
          ?? transform(M_DUPVEN,"@E ###,###.##")
          ?? "               "
          ?? transform(M_COMVEN,"@E ###,###.##")
      ? replicate("=",132)
        ? space(66)
          ?? "TOTAL GERAL       -=>         "
          ?? transform(M_DUPGER,"@E ###,###.##")
          ?? "               "
          ?? transform(M_COMGER,"@E ###,###.##")

      eject

desliga1()

  enddo 

return "" 

*****************
function CAB_COM1
*****************

declare M_OPCAO[4]

M_OPCAO[1] = "PAGAMENTO "
M_OPCAO[2] = "VENCIMENTO"
M_OPCAO[3] = "EMISSAO   "
M_OPCAO[4] = "ABERTO    "

  PG = PG + 1

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"COMISSAO DE VENDEDORES - " +iif(M_SUP="S","SUPERVISOR","NORMAL")  + " " + M_OPCAO[M_OPC],"EAGRO25",132)
  ? cent_cab(M_DATA,"PERIODO: " + dtoc(M_PERINI) + " A " + dtoc(M_PERFIN),"PAG.: " + str(PG, 4, 0), 132)
  ? "*---------*-------*-------------------------------*--------------*--*--------*--------*--------*----------*------*------*----------*"
  ? "* TITULO  *  CLI  * NOME DO CLIENTE               *  MUNICIPIO   *UF*EMISSAO * VCTO   * PAGTO  *  VALOR   * CMS  * CMV  * COMISSAO *"
  ? "*---------*-------*-------------------------------*--------------*--*--------*--------*--------*----------*------*------*----------*"
 *    999999/99 9999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXX XX 99/99/99 99/99/99 99/99/99 ###,###.## ###.## ###.## ###,###.##

  LN = 5

return ""

****************
function TLVEN01
****************

 nbox(9, 13, 17, 66,"W/W+",.t.)
 setcolor("B/W")
    @ 10, 14 say     " Codigo  :            Cpf/Cnpj:                     "
    @ 11, 14 say     " Nome    :                                          "
    @ 12, 14 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 13, 14 say     " Endereco:                                          "
    @ 14, 14 say     " Bairro  :                           Cep:           "
    @ 15, 14 say     " Cidade  :                            Uf:           "
    @ 16, 14 say     " Telefone:                    Supervisor:           "
set color to

return ""

****************
function EDVEN01
****************
  SetColor(_COREDICAO_)

    @ 10, 46 get     M_VENCPF picture "@R 999.999.999/9999-99"
    @ 11, 25 get     M_VENNOM picture "@!"    
    @ 13, 25 get     M_VENEND picture "@!"    
    @ 14, 25 get     M_VENBAI picture "@!"    
    @ 14, 56 get     M_VENCEP picture "#####"            
    @ 14, 62 get     M_VENCCE picture "###"            
    @ 15, 25 get     M_VENMUN picture "@!"               
    @ 15, 56 get     M_VENEST picture "@!" valid   verest(M_VENEST)   
    @ 16, 25 get     M_VENTEL picture "@!"               
    @ 16, 56 get     M_VENSUP picture "@!" valid(M_VENSUP $ "SN")
    read

return ""

****************
function MSVEN01
****************

  setcolor("N/W*")
    @ 10, 25 say     VENCOD   picture "###"
    @ 10, 46 say     VENCPF picture "@R 999.999.999/9999-99"
    @ 11, 25 say     VENNOM picture "@!"    
    @ 13, 25 say     VENEND picture "@!"    
    @ 14, 25 say     VENBAI picture "@!"    
    @ 14, 56 say     VENCEP picture "#####"            
    @ 14, 62 say     VENCCE picture "###"            
    @ 15, 25 say     VENMUN picture "@!"               
    @ 15, 56 say     VENEST picture "@!" 
    @ 16, 25 say     VENTEL picture "@!"               
    @ 16, 56 say     VENSUP picture "@!"
 set color to
  
return ""

****************
function GRVEN01(cACAO)                       && grava dados da vendedor
****************
sqlORDEM = {}
sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"AVEN00",cACAO}

aadd(sqlCHAVE,{"VENCOD",str(M_VENCOD,3)})

if !cACAO $ "#DELETE#SELECT#"
  aadd(sqlCAMPO,{"VENCOD",str(M_VENCOD),.t.})
  aadd(sqlCAMPO,{"VENCPF",M_VENCPF,.t.})
  aadd(sqlCAMPO,{"VENNOM",M_VENNOM,.t.})
  aadd(sqlCAMPO,{"VENEND",M_VENEND,.t.})
  aadd(sqlCAMPO,{"VENBAI",M_VENBAI,.t.})
  aadd(sqlCAMPO,{"VENCEP",str(M_VENCEP),.t.})
  aadd(sqlCAMPO,{"VENCCE",str(M_VENCCE),.t.})
  aadd(sqlCAMPO,{"VENMUN",M_VENMUN,.t.})
  aadd(sqlCAMPO,{"VENEST",M_VENEST,.t.})
  aadd(sqlCAMPO,{"VENTEL",M_VENTEL,.t.})
  aadd(sqlCAMPO,{"VENSUP",M_VENSUP,.t.})
endif

executasql()

return ""
