#include "ptmenu.ch"

***************
function MANTRA
***************
parameters M_OPC,M_OPC1,M_OPC2


cSql = "select * from rdb$generators where upper(rdb$generator_name) = upper('GEN_ATRA00')"
dbusearea(.t.,"SQLMIX",cSQL,"GENERATOR")
select GENERATOR

if eof()
  cSql = "CREATE SEQUENCE GEN_ATRA00 START WITH 0 INCREMENT BY 1; "
  executesqldireto()

  cSql = "ALTER SEQUENCE GEN_ATRA00 RESTART WITH 1; "
  executesqldireto()

  cSql = "GRANT USAGE ON SEQUENCE GEN_ATRA00 TO SYSDBA WITH GRANT OPTION;"
  executesqldireto()


  cSql = "CREATE OR ALTER TRIGGER ATRA00_BI FOR ATRA00 "
  cSql = cSql + "ACTIVE BEFORE INSERT POSITION 0 "
  cSql = cSql + "as "
  cSql = cSql + "begin "
  cSql = cSql + " if (new.TRACOD = 0) then "
  cSql = cSql + "   new.TRACOD = gen_id(gen_atra00,1); "
  cSql = cSql + " end "
  executesqldireto()
endif

      rodape("MENU","TRANSPORTE",M_FAN,"EAGRO26","Mem: " + str(memory(0), 5),M_EMP)

*        @ 05, 19 prompt "Inclus„o " HIGHLITE R/BG PERMITE 6,2,1
*        @ 06, 19 prompt "Altera‡„o" HIGHLITE R/BG PERMITE 6,2,2
*        @ 07, 19 prompt "Consulta " HIGHLITE R/BG PERMITE 6,2,3
*        @ 08, 19 prompt "Exclus„o " HIGHLITE R/BG PERMITE 6,2,4
*        @ 09, 19 prompt "Listagem " HIGHLITE R/BG PERMITE 6,2,5
*        @ 10, 19 prompt "Outros   " HIGHLITE R/BG PERMITE 6,2,6

      do case
         case M_OPC = 1 ; inctra()
         case M_OPC = 2 ; alttra()   
         case M_OPC = 3 ; contra()     
         case M_OPC = 4 ; exctra()   
         case M_OPC = 5 ; listra()   
      endcase

    fecha_arq()

return ""

***************
function INCTRA
***************
        
    do while .t.

        M_TRACOD  = 0
        M_TRANOM  = space(40)
        M_TRAEND  = space(40)
        M_TRABAI  = space(15)
        M_TRACEP  = 0
        M_TRACCL  = 0
        M_TRAMUN  = space(32)
        M_TRAEST  = space(02)
        M_TRAPLC  = space(08)
        M_TRATEL  = space(15)
        M_TRAVIA  = "RODOVIARIA"
        M_TRACGC  = space(15)
        M_TRAIES  = space(15)

      tltra01() 

      rodape("INCLUI","TRANSPORTE",M_FAN,"EAGRO26","Mem: " + str(memory(0), 5),M_EMP) 

*        setcolor("I")
*        @ 10, 25 say M_TRACOD   picture "###"
*        setcolor("")

        edtra01()                      && edita dados da transportadora

        if lastkey() = 27
          msg("* * * TRANSPORTE NAO INCLUIDO * * *")
          exit
        endif

        grtra01("INSERT")                      && grava dados da transportadora
        
        msg("* * * TRANSPORTE INCLUIDO * * *")

    enddo

return ""

***************
function ALTTRA
***************
        
    do while .t.

    tltra01() 

    rodape("ALTERA","TRANSPORTE",M_FAN,"EAGRO26","Mem: " + str(memory(0), 5),M_EMP) 

        store 0 to M_TRACOD
        SetColor(_COREDICAO_)
        @ 10, 25 get     M_TRACOD   picture "###"
        read

        if M_TRACOD = 0
          exit
        endif

        if !BUSCAREGISTRO("ATRA00",1,{str(M_TRACOD, 3)},"SELECT")
          msg("* * * TRANSPORTE NÇO CADASTRADO * * *")
          loop
        endif

        mstra01()                      && mostra dados do transportadora

        M_TRANOM = TRANOM
        M_TRAEND = TRAEND
        M_TRABAI = TRABAI
        M_TRACEP = TRACEP
        M_TRACCL = TRACCL
        M_TRAMUN = TRAMUN
        M_TRAEST = TRAEST
        M_TRAPLC = TRAPLC
        M_TRAVIA = TRAVIA
        M_TRACGC = TRACGC
        M_TRAIES = TRAIES
        M_TRATEL = TRATEL

        edtra01()

        if lastkey() = 27
          msg("* * * TRANSPORTE NAO ALTERADO * * *")
          loop
        endif

        grtra01("UPDATE")                      && grava dados da transportadora

        msg("* * * TRANSPORTE ALTERADO * * *")

    enddo

return ""

***************
function CONTRA
***************
        
private M_TRACOD
             
    do while .t.

      tltra01() 

      rodape("CONSULTA","TRANSPORTE",M_FAN,"EAGRO26","Mem: " + str(memory(0), 5),M_EMP) 

        store 0 to M_TRACOD
        M_TRANOM  = space(40)

        SetColor(_COREDICAO_)
        @ 10, 25 get     M_TRACOD   picture "###"
        read

        if M_TRACOD = 0
        SetColor(_COREDICAO_)
          @ 11, 25 get M_TRANOM picture "@!"
          read
          if empty(M_TRANOM)
            exit
          endif
        endif

        if M_TRACOD > 0
          sqlRELATION = {}
          sqlCAMPO = {}
          sqlCHAVE =  {}
          sqlARQUI = {}
          sqlORDEM = {}
          aadd(sqlARQUI,{"ATRA00","ATRA00"})
          aadd(sqlCAMPO,"*")
          aadd(sqlCHAVE,"TRACOD >= " + str(M_TRACOD, 3, 0))
          aadd(sqlORDEM,"TRACOD")
          sqlrelation()
        else
          sqlRELATION = {}
          sqlCAMPO = {}
          sqlCHAVE =  {}
          sqlARQUI = {}
          sqlORDEM = {}
          aadd(sqlARQUI,{"ATRA00","ATRA00"})
          aadd(sqlCAMPO,"*")
          aadd(sqlCHAVE,"TRANOM >= " + aspas(alltrim(M_TRANOM)))
          aadd(sqlORDEM,"TRANOM")
          sqlrelation()
        endif

        do while .t.

          mstra01()

          waitstate()

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
function EXCTRA
***************
        
private M_TRACOD ,;
        M_OPC
             
    do while .t.

      tltra01() 
 
      rodape("EXCLUI","TRANSPORTE",M_FAN,"EAGRO26","Mem: " + str(memory(0), 5),M_EMP) 

        store 0 to M_TRACOD
        SetColor(_COREDICAO_)
        @ 10, 25 get     M_TRACOD   picture "###"
        read

        if M_TRACOD = 0
            exit
        endif

        select ATRA00

        if !dbseek(str(M_TRACOD, 3, 0))
          msg("* * * TRANSPORTE NAO CADASTRADO * * *")
          loop
        endif
        
        mstra01()

        if !rlock()
          msg("* * * (ATRA00) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_OPC = confirma("deste Transporte")

        if M_OPC != 1
          msg("* * * TRANSPORTE NAO EXCLUIDO * * *")
          unlock
          loop
        endif

        elimina()

        msg("* * * TRANSPORTE EXCLUIDO * * *")

    enddo

return ""

***************
function LISTRA
*************** 

private M_COD1  ,;
        M_COD2  ,; 
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_TELA
 
    do while .t.

        rodape("LISTA","TRANSPORTE",M_FAN,"EAGRO26","Mem: " + str(memory(0), 5),M_EMP) 

        store 0        to M_COD1,;
                          M_COD2

       sombra(10, 29, 13, 53,_SOMBRA_)

       set color to GR+/W+
         @ 10, 29 say      "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
         @ 11, 29 say      "³Transporte Inicial:    ³" 
         @ 12, 29 say      "³             Final:    ³" 
         @ 13, 29 say      "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
        SetColor(_COREDICAO_)

        @ 11, 50 get M_COD1 picture "###"  
        @ 12, 50 get M_COD2 picture "###"   
        read

        if lastkey() = 27
            return ""
        endif

        M_COD1 = iif(M_COD1 = 0,  1,M_COD1)
        M_COD2 = iif(M_COD2 = 0,999,M_COD2) 

        select ATRA00

        go top

        set softseek on
          seek str(M_COD1, 3, 0)
        set softseek off

        if TRACOD > M_COD2
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

        ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE TRANSPORTADORA","EAGRO26",132) 
        ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
        ? "*------*-------------------*-------------------------------------- -*-------------------------------------*---------*--*-----------*"
        ? "*CODIGO*     VIA           * NOME                                   * ENDERECO                            * CEP     *UF* MUNICIPIO *"
        ? "*------*-------------------*----------------------------------------*-------------------------------------*---------*--*-----------*"
          * 999999 XXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99999 999 XX

        store 5 to LN

        do while !eof() .and. LN < 60

          if  TRACOD > M_COD2
            go bottom
            skip
            loop
          endif 

            ? "  "
              ?? str(TRACOD, 5, 0)
              ?? " "
              ?? TRAVIA           
              ?? space(10)
              ?? TRANOM
              ?? " "
              ?? left(TRAEND, 37)
              ?? " "
              ?? str(TRACEP, 5, 0)
              ?? " "
              ?? strzero(TRACCL, 3, 0)
              ?? " "
              ?? TRAEST
              ?? " " 
              ?? left(TRAMUN, 11)
  
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
function TLTRA01
****************

 nbox(9, 13, 19, 66,"W/W+",.t.)
 setcolor("B/W")
    @ 10, 14 say     " Codigo  :                                          "
    @ 11, 14 say     " Nome    :                                          "
    @ 12, 14 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 13, 14 say     " Endereco:                                          "
    @ 14, 14 say     " Bairro  :                      Cep:                "
    @ 15, 14 say     " Cidade  :                       Uf:                "
    @ 16, 14 say     " Fone    :                  Transp.:                "
    @ 17, 14 say     " Cnpj/Cpf:                      IES:                "
    @ 18, 14 say     " Placa   :                                          "
set color to

return ""

****************
function EDTRA01
****************

    SetColor(_COREDICAO_)
    @ 11, 25 get     M_TRANOM picture "@!"
    @ 13, 25 get     M_TRAEND picture "@!"
    @ 14, 25 get     M_TRABAI picture "@!"
    @ 14, 51 get     M_TRACEP picture "#####"
    @ 14, 58 get     M_TRACCL picture "###"
    @ 15, 25 get     M_TRAMUN picture "@!@S21"
    @ 15, 51 get     M_TRAEST picture "@!" valid   verest(M_TRAEST)
    @ 16, 25 get     M_TRATEL picture "@!"
    @ 16, 51 get     M_TRAVIA picture "@!"
    @ 17, 25 get     M_TRACGC picture "@R 999.999.999/9999-99"
    @ 17, 51 get     M_TRAIES picture "@!"
    @ 18, 25 get     M_TRAPLC picture "@!"
    read

return ""

****************
function MSTRA01
****************

  setcolor("N/W*")
    @ 10, 25 say     TRACOD   picture "###"
    @ 11, 25 say     TRANOM picture "@!"    
    @ 13, 25 say     TRAEND picture "@!"    
    @ 14, 25 say     TRABAI picture "@!"    
    @ 14, 51 say     TRACEP picture "#####"
    @ 14, 58 say     TRACCL picture "###"
    @ 15, 25 say     TRAMUN picture "@!@S21"
    @ 15, 51 say     TRAEST picture "@!"
    @ 16, 25 say     TRATEL picture "@!"
    @ 16, 51 say     TRAVIA picture "@!"
    @ 17, 25 say     TRACGC picture "@R 999.999.999/9999-99"
    @ 17, 51 say     TRAIES picture "@!"
    @ 18, 25 say     TRAPLC picture "@!"
 set color to
  
return ""

****************
function GRTRA01(cACAO)                       && grava dados da vendedor
****************

if cACAO == "INSERT"
  cSql := "select first 1 gen_id(gen_atra00,1) from atra00"
  dbusearea(.t.,"SQLMIX",cSql,"ATRAID")
  M_TRACOD = GEN_ID
  select ATRAID
  use

  do while .t.
    if BUSCAREGISTRO("ATRA00",1,{str(M_TRACOD, 3)},"SELECT")
      cSql := "select first 1 gen_id(gen_ATRA00,1) from ATRA00"
      dbusearea(.t.,"SQLMIX",cSql,"ATRAID")
      M_TRACOD = GEN_ID
      select ATRAID
      use
      loop
    endif
    exit
  enddo

  setcolor("I")
  @ 10, 25 say M_TRACOD   picture "###"
  setcolor("")

endif

sqlORDEM = {}
sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"ATRA00",cACAO}

aadd(sqlCHAVE,{"TRACOD",str(M_TRACOD,3)})

if !cACAO $ "#DELETE#SELECT#"
  aadd(sqlCAMPO,{"TRACOD",str(M_TRACOD,3),.t.})
  aadd(sqlCAMPO,{"TRANOM",M_TRANOM,.t.})
  aadd(sqlCAMPO,{"TRAEND",M_TRAEND,.t.})
  aadd(sqlCAMPO,{"TRABAI",M_TRABAI,.t.})
  aadd(sqlCAMPO,{"TRAMUN",M_TRAMUN,.t.})
  aadd(sqlCAMPO,{"TRAEST",M_TRAEST,.t.})
  aadd(sqlCAMPO,{"TRACEP", str(M_TRACEP,5,0),.t.})
  aadd(sqlCAMPO,{"TRACCL", str(M_TRACCL,3,0),.t.})
  aadd(sqlCAMPO,{"TRAPLC",M_TRAPLC,.t.})
  aadd(sqlCAMPO,{"TRAVIA",M_TRAVIA,.t.})
  aadd(sqlCAMPO,{"TRACGC",M_TRACGC,.t.})
  aadd(sqlCAMPO,{"TRAIES",M_TRAIES,.t.})
  aadd(sqlCAMPO,{"TRATEL",M_TRATEL,.t.})
endif

executasql()

return ""
