***************
function MANFOR
***************
parameters M_OPC,M_OPC1,M_OPC2
#command @ <row> , <col>  GET <var> [<clauses,...>] F2 [<moreClauses,...>] funcao <func> retorno <Variavel>;
=>       @ <row> , <col>  GET <var> [<clauses>] SEND reader := {|oGet| Getf2(oGet,<func>,<Variavel>) } [<moreClauses>]

#include "ptmenu.ch"

_FUNMUN_ = "FORNEC"

    _FUNCLI_ = "FORNEC.t."
    _FUNPRO_ = "FORNEC.f."
    _FUNFOR_ = "FORNEC.f."
    _FUNCPG_ = "FORNEC.f."
    _FUNTRA_ = "FORNEC.f."
    _FUNVEN_ = "FORNEC.f."
    _FUNPLX_ = "FORNEC.f."


      rodape("MENU","FORNECEDOR",M_FAN,"EAGRO13","Mem: " + str(memory(0), 5),M_EMP) 

 *       @ 05, 08 prompt "Inclus„o " HIGHLITE R/BG PERMITE 3,1,1
 *       @ 06, 08 prompt "Altera‡„o" HIGHLITE R/BG PERMITE 3,1,2
 *       @ 07, 08 prompt "Consulta " HIGHLITE R/BG PERMITE 3,1,3
 *       @ 08, 08 prompt "Exclus„o " HIGHLITE R/BG PERMITE 3,1,4
 *       @ 09, 08 prompt "Listagem " HIGHLITE R/BG PERMITE 3,1,5
 *       @ 10, 08 prompt "Etiquetas" HIGHLITE R/BG PERMITE 3,1,6
 *       @ 11, 08 prompt "Morto    " HIGHLITE R/BG PERMITE 3,1,6

      do case
         case M_OPC = 1 ; incfor()
         case M_OPC = 2 ; altfor()
         case M_OPC = 3 ; confor("NORMAL")
         case M_OPC = 4 ; excfor()
         case M_OPC = 5 ; lisfor()
         case M_OPC = 6 ; etifor()
         case M_OPC = 7 ; confor("MORTO")
      endcase

    fecha_arq()

return ""

***************
function INCFOR
***************

    do while .t.

        M_FORCOD  = 0
        M_FORCGC  = space(15)

        tlfor01() 

        rodape("INCLUI","FORNECEDOR",M_FAN,"EAGRO13","Mem: " + str(memory(0), 5),M_EMP)

        SetColor(_COREDICAO_)
        @ 16, 25 get     M_FORCGC picture "@R 999.999.999/9999-99"   valid verforcgc()
*        @ 09, 25 get     M_FORCOD   picture "#######"
        read

        if empty(M_FORCGC) .or. lastkey() = 27
          exit
        endif

        M_FORIES  = space(17)
        M_FORNOM  = space(40)
        M_FOREND  = space(40)
        M_FORNRO  = space(05)
        M_FORCPE  = space(10)
        M_FORBAI  = space(20)
        M_FORCEP  = space(08)
        M_FORCDM  = 0
        M_FORMUN  = space(32)
        M_FOREST  = space(2)
        M_FORTEL  = space(15)
        M_FORFAX  = space(15)
        M_FORIES  = space(17)
        M_FORCON  = space(40)
        M_FORTIP  = " "
        M_FORSITE = space(40)
        M_FOREMAIL= space(40)
        M_FORPER = 0

        if BUSCAREGISTRO("AFOR00",3,{aspas(M_FORCGC)},"SELECT")
          MSGBOX1("FORNECEDOR JA CADASTRADO - CODIGO: " + str(AFOR00->FORCOD,5))
          loop
        endif

        edfor01()                      && edita dados 

        if lastkey() = 27
          msg("* * * FORNECEDOR NAO INCLUIDO * * *")
          loop
        endif

        do while .t.
          cSql := "select first 1 gen_id(AFOR00_id,1) as FORCOD from AFOR00"
          dbusearea(.t.,"SQLMIX",cSql,"AFORID")
          M_FORCOD = AFORID->FORCOD
          use

          if BUSCAREGISTRO("AFOR00",1,{str(M_FORCOD,7,0)},"SELECT")
            loop
          endif
          exit
        enddo

        @ 09, 25 say M_FORCOD picture "#######"

        grfor01("INSERT")                       && grava produto

       msg("* * * FORNECEDOR INCLUIDO * * *")

     enddo

return ""

******************
function VERFORCGC(TIPO)
******************

if TIPO = NIL
  TIPO = .t.
endif

if empty(M_FORCGC)
  return .f.
endif

if len(alltrim(M_FORCGC))=15
  if !cgc(right(M_FORCGC,14))
    msg("* * * CGC INVALIDO * * *")
    return .f.
  endif
else
  if len(alltrim(M_FORCGC))=11
    if !cpf(left(M_FORCGC,11))
      msg("* * * CPF INVALIDO * * *")
      return .f.
    endif
  else
    msg("* * * NAO E' CGC/CPF * * *")
    return .f.
  endif
endif

return .t.


***************
function ALTFOR
***************
        
_FUNFOR_ = "FORNECEDOR"

    do while .t.

    tlfor01() 

    rodape("ALTERA","FORNECEDOR",M_FAN,"EAGRO13","Mem: " + str(memory(0), 5),M_EMP) 

        store 0 to M_FORCOD
        SetColor(_COREDICAO_)
        @ 09, 25 get M_FORCOD picture "#######" F2 color _CORF2_ funcao "sele_arquivo('AFOR00')" retorno @M_FORCOD
        read

        if lastkey() = 27 .or. M_FORCOD = 0
          exit
        endif

        if !BUSCAREGISTRO("AFOR00",1,{aspas(str(M_FORCOD, 7, 0))},"SELECT")
          MSGBOX1("FORNECEDOR NAO CADASTRADO")
          loop
        endif

        msfor01()

       M_FORCGC  =  FORCGC
       M_FORIES  =  FORIES
       M_FORNOM  =  FORNOM
       M_FOREND  =  FOREND
       M_FORNRO  =  FORNRO
       M_FORCPE  =  FORCPE
       M_FORBAI  =  FORBAI
       M_FORCEP  =  FORCEP
       M_FORCDM  =  FORCDM
       M_FORMUN  =  FORMUN
       M_FOREST  =  FOREST
       M_FORTEL  =  FORTEL
       M_FORFAX  =  FORFAX
       M_FORCON  =  FORCON
       M_FORTIP  =  FORTIP
       M_FORSITE =  FORSITE 
       M_FOREMAIL=  FOREMAIL 
       M_FORPER  =  FORPER

        edfor01() 

        if lastkey() = 27
          msg("* * * FORNECEDOR NAO ALTERADO * * *")
          loop
        endif

        grfor01("UPDATE")

        msg("* * * FORNECEDOR ALTERADO * * *")

    enddo

return ""

***************
function CONFOR(TIPO)
***************

*if TIPO == "NORMAL"
*  select AFOR00
*  use
*  abre_for("0")
*else
*  select AFOR00
*  use
*  aliasfor("0")  // abre arquivo morto com alias APCA00
*endif

private M_FORCOD
             
    do while .t.

      tlfor01() 

        rodape("CONSULTA","FORNECEDOR",M_FAN,"EAGRO13","Mem: " + str(memory(0), 5),M_EMP) 

        store 0         to M_FORCOD
        store space(40) to M_FORNOM

        SetColor(_COREDICAO_)
        @ 09, 25 get M_FORCOD picture "#######"  F2 color _CORF2_ funcao "sele_arquivo('AFOR00')" retorno @M_FORCOD
        read

        if lastkey() = 27
          exit
        endif

        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}
        aadd(sqlARQUI,{"AFOR00","AFOR00"})
        aadd(sqlCAMPO,"first 100 *")
        aadd(sqlCHAVE,"FORCOD >= " + str(M_FORCOD, 6, 0))
        aadd(sqlORDEM,"FORCOD")

        sqlrelation()

        do while .t.

          msfor01()

          WAITSTATE()

          if TIPO == "NORMAL"
            if lastkey()= -41  // envia para arquivo morto
              nEnvia = 0
              do while .t.
                nEnvia = alertnew("Deseja enviar este fornecedor para;o arquivo morto",{"Escolha","Sim","Nao"})
                if nEnvia > 1
                  exit
                endif
              enddo
              if nEnvia = 2  // arquivo morto
                arecord = getrecord(recno())

                select AFOMOR
                append blank

                do while .t.
                  if rlock()
                    putrecord(arecord,recno())
                    unlock   
                    commit
                    exit
                  else
                    msg("* * * (" + alias() + ") REGISTRO SENDO USADO * * *") 
                  endif
                  if lastkey()=17
                    exit
                  endif
                enddo
                select AFOR00
                elimina()
                dbskip(+1)
              endif
            endif
          endif

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

    enddo

return ""

***************
function EXCFOR
***************
        
private M_FORCOD ,;
        M_OPC
             
_FUNFOR_ = "FORNECEDOR"

    do while .t.

      tlfor01() 
 
 */*/*/
        rodape("EXCLUI","FORNECEDOR",M_FAN,"EAGRO13","Mem: " + str(memory(0), 5),M_EMP) 

        store 0 to M_FORCOD
        SetColor(_COREDICAO_)
        
        @ 09, 25 get M_FORCOD picture "#######" F2 color _CORF2_ funcao "sele_arquivo('AFOR00')" retorno @M_FORCOD
        read

        if lastkey() = 27
          exit
        endif

        if !BUSCAREGISTRO("AFOR00",1,{aspas(str(M_FORCOD, 7, 0))},"SELECT")
          MSGBOX1("FORNECEDOR NAO CADASTRADO")
          loop
        endif

        msfor01()

        M_OPC = confirma("deste fornecedor")

        if M_OPC != 1
          msg("* * * FORNECEDOR NAO EXCLUIDO * * *")
          loop
        endif

        grfor01("DELETE")

        msg("* * * FORNECEDOR EXCLUIDO * * *")

    enddo

return ""

***************
function LISFOR
*************** 

private M_COD1  ,;
        M_COD2  ,; 
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_TELA
 
    do while .t.

        rodape("LISTA","FORNECEDOR",M_FAN,"EAGRO13","Mem: " + str(memory(0), 5),M_EMP) 

        store 0        to M_COD1,;
                          M_COD2

       sombra(10, 15, 13, 41,_SOMBRA_)

       set color to GR+/W+
         @ 10, 15 say      "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
         @ 11, 15 say      "³Fornecedor Inicial:        ³" 
         @ 12, 15 say      "³             Final:        ³" 
         @ 13, 15 say      "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
       set color to 

      SetColor(_COREDICAO_)
        @ 11, 36 get M_COD1 picture "#######"
        @ 12, 36 get M_COD2 picture "#######"   
        read

        if lastkey() = 27
            return ""
        endif

        M_COD1 = iif(M_COD1 = 0,     1,M_COD1)
        M_COD2 = iif(M_COD2 = 0,99999,M_COD2) 

        select AFOR00

        go top

        set softseek on
          seek str(M_COD1, 7, 0)
        set softseek off

        if FORCOD > M_COD2
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

        ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE FORNECEDORES","EAGRO13",132) 
        ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
        ? "*------*-------------------*-------------------------------------- -*-------------------------------------*---------*--*-----------*"
        ? "*CODIGO* CNPJ(MF)          * NOME                                   * ENDERECO                            * CEP     *UF* MUNICIPIO *"
        ? "*------*-------------------*----------------------------------------*-------------------------------------*---------*--*-----------*"
          * 999999 999.999.999/9999-99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99999 999 XX

        store 5 to LN

        do while !eof() .and. LN < 60

          if  FORCOD > M_COD2
            go bottom
            skip
            loop
          endif 

            ? "  "
              ?? str(FORCOD, 7, 0)
              ?? " "
              ?? transform(FORCGC,"@R 999.999.999/9999-99")
              ?? " "
              ?? FORNOM
              ?? " "
              ?? left(FOREND, 37)
              ?? " "
              ?? transform(FORCEP,"@R 99999-999")
              ?? " "
              ?? FOREST
              ?? " " 
              ?? left(FORMUN, 11)
  
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
function TLFOR01
****************

  nbox(8, 13, 21, 68,"W/W+",.t.)
  setcolor("B/W")
    @ 09, 14 say     " Codigo  :            Percentual s/compra:            "
    @ 10, 14 say     " Nome    :                                            "
    @ 11, 14 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 12, 14 say     " Endereco:                                            "
    @ 13, 14 say     " Bairro  :                     Cep:           Tipo:   "
    @ 14, 14 say     " Cidade  :                                      Uf:   "
    @ 15, 14 say     " Telefone:                     Fax:                   "
    @ 16, 14 say     " Cnpj/Cpf:                     Ies:                   "
    @ 17, 14 say     " Contato :                                            "
    @ 18, 14 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄ Informacoes para Internet ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 19, 14 say     " site    :                                            "
    @ 20, 14 say     " e-mail  :                                            "

set color to

return ""

****************
function EDFOR01
****************

      SetColor(_COREDICAO_)
    @ 10, 25 get     M_FORNOM picture "@!" valid !empty(M_FORNOM)
    @ 09, 57 get     M_FORPER picture "999.99"
    @ 12, 25 get     M_FOREND picture "@!" valid diginro("FOR")
    @ 13, 25 get     M_FORBAI picture "@!"    
    @ 13, 50 get     M_FORCEP picture "@R 99999-999"            
    @ 13, 66 get     M_FORTIP picture "@!" valid iif(M_FORTIP $ "FD",.t.,msg("* * * <F>ornecedor   <D>iversos * * *"))
    @ 14, 25 get     M_FORCDM picture "#######" F2 color _CORF2_ valid verfor02() funcao "sele_arquivo('AMUN00')" retorno @M_FORCDM
    @ 15, 25 get     M_FORTEL picture "@!"
    @ 15, 50 get     M_FORFAX picture "@!"
    @ 16, 25 get     M_FORCGC picture "@R 999.999.999/9999-99"               
    @ 16, 50 get     M_FORIES picture "@!"
    @ 17, 25 get     M_FORCON picture "@!"
    @ 19, 25 get     M_FORSITE 
    @ 20, 25 get     M_FOREMAIL
    read

return ""

****************
function MSFOR01
****************

  setcolor("N/W*")
    @ 09, 25 say     FORCOD picture "#######"
    @ 09, 57 say     FORPER picture "999.99"
    @ 10, 25 say     FORNOM picture "@!"    
    @ 12, 25 say     FOREND picture "@!"    
    @ 13, 25 say     FORBAI picture "@!"    
    @ 13, 50 say     FORCEP picture "@R 99999-999"
    @ 13, 66 say     FORTIP picture "@!"
    @ 14, 25 say     FORCDM picture "#######"
    @ 14, 33 say     FORMUN picture "@!@S28"
    @ 14, 66 say     FOREST picture "@!"
    @ 15, 25 say     FORTEL picture "@!"               
    @ 15, 50 say     FORFAX picture "@!"               
    @ 16, 25 say     FORCGC picture "@R 999.999.999/9999-99"               
    @ 16, 50 say     FORIES picture "@!"
    @ 17, 25 say     FORCON picture "@!"
    @ 19, 25 say     FORSITE 
    @ 20, 25 say     FOREMAIL
 set color to
  
return ""

****************
function GRFOR01(cACAO)
****************

sqlORDEM = {}
sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"AFOR00",cACAO}

aadd(sqlCHAVE,{"FORCOD",str(M_FORCOD,6)})

if !cACAO $ "#DELETE#SELECT#"
   aadd(sqlCAMPO,{"FORCOD",str(M_FORCOD),.t.})
   aadd(sqlCAMPO,{"FORCDM",str(M_FORCDM),.t.})
   aadd(sqlCAMPO,{"FORNOM",M_FORNOM,.t.})
   aadd(sqlCAMPO,{"FOREND",M_FOREND,.t.})
   aadd(sqlCAMPO,{"FORNRO",M_FORNRO,.t.})
   aadd(sqlCAMPO,{"FORCPE",M_FORCPE,.t.})
   aadd(sqlCAMPO,{"FORBAI",M_FORBAI,.t.})
   aadd(sqlCAMPO,{"FORCEP",M_FORCEP,.t.})
   aadd(sqlCAMPO,{"FORMUN",M_FORMUN,.t.})
   aadd(sqlCAMPO,{"FOREST",M_FOREST,.t.})
   aadd(sqlCAMPO,{"FORTEL",M_FORTEL,.t.})
   aadd(sqlCAMPO,{"FORFAX",M_FORFAX,.t.})
   aadd(sqlCAMPO,{"FORCGC",M_FORCGC,.t.})
   aadd(sqlCAMPO,{"FORIES",M_FORIES,.t.})
   aadd(sqlCAMPO,{"FORCON",M_FORCON,.t.})
   aadd(sqlCAMPO,{"FORTIP",M_FORTIP,.t.})
   aadd(sqlCAMPO,{"FORPER",str1(M_FORPER,2),.t.})
   aadd(sqlCAMPO,{"FORSITE",M_FORSITE,.t.})
   aadd(sqlCAMPO,{"FOREMAIL",M_FOREMAIL,.t.})
endif

if !executasql()
   return .f.
endif

return .t.


****************
function ETIFOR
**************** 

private M_TELA   ,;
        M_OPC    ,;
        M_FOR1   ,;
        M_FOR2   ,;
        M_NOM1   ,;
        M_NOM2   ,;
        M_TIPO   ,;
        M_ETI[24]

        M_OPC  = 0

    do while .t.

        M_FOR1 = 0
        M_FOR2 = 0
        M_NOM1 = space(40)
        M_NOM2 = space(40)
        M_TIPO = space(01)

        rodape("ETIQUETA","FORNECEDOR",M_FAN,"EAGRO13","Mem: " + str(memory(0), 5),M_EMP) 

         sombra(09, 14, 14, 24,_SOMBRA_)

         set color to N/BG
           @ 09, 14, 14, 24 box M_FRAME1     
         set color to W+/BG,W+/N
           @ 10, 15 prompt   "Codigo   " HIGHLITE R/BG     
           @ 11, 15 prompt   "Selecao  " HIGHLITE R/BG     
           @ 12, 15 prompt   "Nome     " HIGHLITE R/BG     
           @ 13, 15 prompt   "Parametro" HIGHLITE R/BG     
           menu to M_OPC
         set color to
 
         M_TELA = savescreen(07, 20, 21, 75)
 
        do case
           case M_OPC = 0
             exit
           case M_OPC = 1
              sombra(13, 33, 17, 56,_SOMBRA_)
              set color to GR+/W+
                @ 13, 33 say   "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
                @ 14, 33 say   "³ CODIGO Inicial:        ³" 
                @ 15, 33 say   "³          Final:        ³" 
                @ 16, 33 say   "³   TIPO Fornec.:        ³" 
                @ 17, 33 say   "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
      SetColor(_COREDICAO_)
                @ 14, 51 get     M_FOR1 picture "#######"
                @ 15, 51 get     M_FOR2 picture "#######"   
                @ 16, 51 get     M_TIPO picture "@!"
                read 
                if lastkey() = 27
                  restscreen(07, 20, 21, 75, M_TELA)
                  loop
                endif
                M_FOR1 = iif(M_FOR1 = 0,    1,M_FOR1)
                M_FOR2 = iif(M_FOR2 = 0,9999999,M_FOR2) 
                etifor_a()
           case M_OPC = 2
              for R = 1 to 24
                M_ETI[R] = 0 
              next
              sombra(13, 25, 18, 75,_SOMBRA_)
              set color to N/RB+
        @ 13, 25 say   "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
        @ 14, 25 say   "³ ####### ####### ####### ####### ####### ####### ³" 
        @ 15, 25 say   "³                                                 ³" 
        @ 16, 25 say   "³                                                 ³" 
        @ 17, 25 say   "³                                                 ³" 
        @ 18, 25 say   "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
      SetColor(_COREDICAO_)

              @ 14, 27 get M_ETI[ 1] picture "#######" valid verfor03(M_ETI[ 1])
              @ 14, 35 get M_ETI[ 2] picture "#######" valid verfor03(M_ETI[ 2])
              @ 14, 43 get M_ETI[ 3] picture "#######" valid verfor03(M_ETI[ 3])
              @ 14, 51 get M_ETI[ 4] picture "#######" valid verfor03(M_ETI[ 4])
              @ 14, 59 get M_ETI[ 5] picture "#######" valid verfor03(M_ETI[ 5])
              @ 14, 67 get M_ETI[ 6] picture "#######" valid verfor03(M_ETI[ 6])

              @ 15, 27 get M_ETI[ 7] picture "#######" valid verfor03(M_ETI[ 7])
              @ 15, 35 get M_ETI[ 8] picture "#######" valid verfor03(M_ETI[ 8])
              @ 15, 43 get M_ETI[ 9] picture "#######" valid verfor03(M_ETI[ 9])
              @ 15, 51 get M_ETI[10] picture "#######" valid verfor03(M_ETI[10])
              @ 15, 59 get M_ETI[11] picture "#######" valid verfor03(M_ETI[11])
              @ 15, 67 get M_ETI[12] picture "#######" valid verfor03(M_ETI[12])

              @ 16, 27 get M_ETI[13] picture "#######" valid verfor03(M_ETI[13])
              @ 16, 35 get M_ETI[14] picture "#######" valid verfor03(M_ETI[14])
              @ 16, 43 get M_ETI[15] picture "#######" valid verfor03(M_ETI[15])
              @ 16, 51 get M_ETI[16] picture "#######" valid verfor03(M_ETI[16])
              @ 16, 59 get M_ETI[17] picture "#######" valid verfor03(M_ETI[17])
              @ 16, 67 get M_ETI[18] picture "#######" valid verfor03(M_ETI[18])

              @ 17, 27 get M_ETI[19] picture "#######" valid verfor03(M_ETI[19])
              @ 17, 35 get M_ETI[20] picture "#######" valid verfor03(M_ETI[20])
              @ 17, 43 get M_ETI[21] picture "#######" valid verfor03(M_ETI[21])
              @ 17, 51 get M_ETI[22] picture "#######" valid verfor03(M_ETI[22])
              @ 17, 59 get M_ETI[23] picture "#######" valid verfor03(M_ETI[23])
              @ 17, 67 get M_ETI[24] picture "#######" valid verfor03(M_ETI[24])
              read
              if lastkey() = 27
                restscreen(07, 20, 21, 75, M_TELA)
                loop
              endif
              etifor_b()
           case M_OPC = 3
              sombra(13, 33, 17, 70,_SOMBRA_)
              set color to GR+/W+
                @ 13, 33 say   "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
                @ 14, 33 say   "³NOME Inicial:                       ³" 
                @ 15, 33 say   "³       Final:                       ³" 
                @ 16, 33 say   "³TIPO Fornec.:                       ³" 
                @ 17, 33 say   "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
      SetColor(_COREDICAO_)
                @ 14, 48 get     M_NOM1 picture "@!@S22"
                @ 15, 48 get     M_NOM2 picture "@!@S22"
                @ 16, 51 get     M_TIPO picture "@!"
                read
                if lastkey() = 27
                  restscreen(07, 20, 21, 75, M_TELA)
                  loop
                endif
                M_NOM1 = iif(empty(M_NOM1),                     "A",M_NOM1)
                M_NOM2 = iif(empty(M_NOM2),"ZZZZZZZZZZZZZZZZZZZZZZ",M_NOM2) 
                etifor_a()
           case M_OPC = 4       
                if file("ETIQUETA.MEM")
                  restore from ETIQUETA.MEM additive
                else
                  ME_CAR  = 1
                  ME_TAM  = 40
                  ME_LIE  = 1
                  ME_COE  = 1
                  ME_CPP  = 10
                  ME_QLT  = "N"
                  ME_DAD  = 1
                endif
                sombra(12, 34, 20, 67, _SOMBRA_)        
                set color to BG+/G                                    
                  @ 12, 34 say  "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
                  @ 13, 34 say  "³ Numero de Carreiras    :       ³"
                  @ 14, 34 say  "³ Tamanho em Caracteres  :       ³"
                  @ 15, 34 say  "³ Linhas Entre Etiquetas :       ³"
                  @ 16, 34 say  "³ Colunas Entre Etiquetas:       ³"
                  @ 17, 34 say  "³ Tamanho do Caracter cpp:       ³"
                  @ 18, 34 say  "³ Qualidade Carta        :       ³"
                  @ 19, 34 say  "³ Dados na Etiqueta      :       ³"
                  @ 20, 34 say  "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
      SetColor(_COREDICAO_)

             @ 13, 61 get ME_CAR  picture "#"
             @ 14, 61 get ME_TAM  picture "##"
             @ 15, 61 get ME_LIE  picture "#"
             @ 16, 61 get ME_COE  picture "#"
             @ 17, 61 get ME_CPP  picture "##" valid(rat(str(ME_CPP, 2, 0),"10#12#18") > 0)
             @ 18, 61 get ME_QLT  picture "@!" valid(rat(ME_QLT,"S#N") > 0) 
             @ 19, 61 get ME_DAD  picture "#"  valid verfor04()
             read

             if lastkey() = 27
               restscreen(07, 20, 21, 75, M_TELA)
               loop
             endif

             save all like ME_* to ETIQUETA
 
        endcase

        restscreen(07, 20, 21, 75, M_TELA)

     enddo

return ""

*****************
function ETIFOR_A
*****************

private M_ESC  

         if file("ETIQUETA.MEM")
            restore from ETIQUETA.MEM additive
         else
            ME_CAR  = 1
            ME_TAM  = 40
            ME_LIE  = 1
            ME_COE  = 2
            ME_CPP  = 10
            ME_QLT  = "N"
            ME_DAD  = 1
         endif

        select AFOR00

        do case 
           case M_OPC = 1
             set order to 1
             set softseek on
               seek str(M_FOR1, 7, 0)
             set softseek off
           case M_OPC = 3
             set order to 2
             set softseek on
               seek M_NOM1
             set softseek off
        endcase

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if ME_CPP = 12
          ?? chr(27) + "M"
        else
          if ME_CPP = 17
            ?? chr(15)
          endif
        endif
        
        if ME_CPP = 10
          if ME_QLT = "S"
            ?? chr(27) + "G"
          endif
        endif

        declare MT_ETINOM[ME_CAR] ,;
                MT_ETIEND[ME_CAR] ,;
                MT_ETIBAI[ME_CAR] ,;
                MT_ETICON[ME_CAR] ,;
                MT_LINECT[ME_CAR] 

        for R = 1 to ME_CAR
          MT_ETINOM[R] = space(ME_TAM)
          MT_ETIEND[R] = space(ME_TAM)
          MT_ETIBAI[R] = space(ME_TAM)
          MT_ETICON[R] = space(ME_TAM)
          MT_LINECT[R] = space(ME_TAM)
        next
     
        do while !eof()

             for R = 1 to ME_CAR
               MT_ETINOM[R] = space(ME_TAM)
               MT_ETIEND[R] = space(ME_TAM)
               MT_ETIBAI[R] = space(ME_TAM)
               MT_ETICON[R] = space(ME_TAM)
               MT_LINECT[R] = space(ME_TAM)
             next

             for R = 1 to ME_CAR

               if ME_DAD = 1
                 MT_ETINOM[R] = pad(FORNOM, ME_TAM)
                 MT_ETIEND[R] = pad(FOREND, ME_TAM)
                 MT_ETIBAI[R] = pad(FORBAI, ME_TAM)
                 MT_ETICON[R] = pad(iif(!empty(FORCON),"A/C: " + FORCON, FORCON), ME_TAM)
                 MT_LINECT[R] = pad((FORCEP + " "  + rtrim(FORMUN) + " " + FOREST), ME_TAM)
               else
                 if ME_DAD = 2
                   MT_ETINOM[R] = pad(FORNOM, ME_TAM)
                   MT_ETIEND[R] = pad(FOREND, ME_TAM)
                   MT_ETIBAI[R] = pad(FORBAI, ME_TAM)
                   MT_ETICON[R] = pad(iif(!empty(FORCON),"A/C: " + FORCON, FORCON), ME_TAM)
                   MT_LINECT[R] = pad((FORCEP + " " + rtrim(FORMUN) + " " + FOREST), ME_TAM)
                 else
                   MT_ETINOM[R] = pad(FORNOM, ME_TAM)
                   MT_ETIEND[R] = pad(FOREND, ME_TAM)
                   MT_ETIBAI[R] = pad(FORBAI, ME_TAM)
                   MT_ETICON[R] = pad(iif(!empty(FORCON),"A/C: " + FORCON, FORCON), ME_TAM)
                   MT_LINECT[R] = pad((FORCEP + " " + rtrim(FORMUN) + " " + FOREST), ME_TAM)
                 endif
               endif
    
               skip

               if eof()
                 exit
               endif

               if M_OPC = 1
                 if FORCOD > M_FOR2
                   go bottom
                   skip
                   exit
                 endif
               endif

               if M_OPC = 3
                 if left(FORNOM, len(alltrim(M_NOM2))) > alltrim(M_NOM2)
                   go bottom
                   skip
                   loop
                 endif 
               endif

            next && R

            cab_etq1()                  && emite etiqueta

            M_ESC = inkey()

            if M_ESC = 27
               if susimp()
                 ? "------------------------------"
                 ? "* * * IMPRESSAO SUSPENSA * * *"
                 go bottom
                 skip
             else
                 M_ESC = inkey()
             endif
           endif

        enddo

    ?? chr(27) + "@"

desliga1()

return "" 

*****************
function CAB_ETQ1
*****************

?
  for R = 1 to ME_CAR
    ?? MT_ETINOM[R]
    ?? space(ME_COE)
  next && R

?
  for R = 1 to ME_CAR
     ?? MT_ETIEND[R]
     ?? space(ME_COE)
  next && R

?
  for R = 1 to ME_CAR
     ?? MT_ETIBAI[R]
     ?? space(ME_COE)
  next && R

?
  for R = 1 to ME_CAR
     ?? MT_LINECT[R]
     ?? space(ME_COE)
  next && R

?
  for R = 1 to ME_CAR
     ?? MT_ETICON[R]
     ?? space(ME_COE)
  next && R

for R = 1 to ME_LIE
  ?
next && R

return ""

*****************
function ETIFOR_B
*****************

private M_ESC  

         if file("ETIQUETA.MEM")
            restore from ETIQUETA.MEM additive
         else
            ME_CAR  = 1
            ME_TAM  = 40
            ME_LIE  = 1
            ME_COE  = 2
            ME_CPP  = 10
            ME_QLT  = "N"
            ME_DAD  = 1
         endif

        select AFOR00

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if ME_CPP = 12
          ?? chr(27) + "M"
        else
          if ME_CPP = 17
            ?? chr(15)
          endif
        endif
        
        if ME_CPP = 10
          if ME_QLT = "S"
            ?? chr(27) + "G"
          endif
        endif

        declare MT_ETINOM[ME_CAR] ,;
                MT_ETIEND[ME_CAR] ,;
                MT_ETIBAI[ME_CAR] ,;
                MT_ETICON[ME_CAR] ,;
                MT_LINECT[ME_CAR] 

        for R = 1 to ME_CAR
          MT_ETINOM[R] = space(ME_TAM)
          MT_ETIEND[R] = space(ME_TAM)
          MT_ETIBAI[R] = space(ME_TAM)
          MT_ETICON[R] = space(ME_TAM)
          MT_LINECT[R] = space(ME_TAM)
        next

        S = 1
     
        do while .t.

             for R = 1 to ME_CAR
               MT_ETINOM[R] = space(ME_TAM)
               MT_ETIEND[R] = space(ME_TAM)
               MT_ETIBAI[R] = space(ME_TAM)
               MT_ETICON[R] = space(ME_TAM)
               MT_LINECT[R] = space(ME_TAM)
             next

             for R = 1 to ME_CAR
               
               if M_ETI[S] = 0
                 R--
                 S++
                 if S > 24 
                   exit
                 endif
                 loop
               endif 
               
               dbseek(str(M_ETI[S], 7, 0))

               if ME_DAD = 1
                 MT_ETINOM[R] = pad(FORNOM, ME_TAM)
                 MT_ETIEND[R] = pad(FOREND, ME_TAM)
                 MT_ETIBAI[R] = pad(FORBAI, ME_TAM)
                 MT_ETICON[R] = pad(iif(!empty(FORCON),"A/C: " + FORCON, FORCON), ME_TAM)
                 MT_LINECT[R] = pad((FORCEP + " " + rtrim(FORMUN) + " " + FOREST), ME_TAM)
               else
                 if ME_DAD = 2
                   MT_ETINOM[R] = pad(FORNOM, ME_TAM)
                   MT_ETIEND[R] = pad(FOREND, ME_TAM)
                   MT_ETIBAI[R] = pad(FORBAI, ME_TAM)
                   MT_ETICON[R] = pad(iif(!empty(FORAC),"A/C: " + FORCON, FORCON), ME_TAM)
                   MT_LINECT[R] = pad((FORCEP + " " + rtrim(FORMUN) + " " + FOREST), ME_TAM)
                 else
                   MT_ETINOM[R] = pad(FORNOM, ME_TAM)
                   MT_ETIEND[R] = pad(FOREND, ME_TAM)
                   MT_ETIBAI[R] = pad(FORBAI, ME_TAM)
                   MT_ETICON[R] = pad(iif(!empty(FORAC),"A/C: " + FORCON, FORCON), ME_TAM)
                   MT_LINECT[R] = pad((FORCEP + " " + rtrim(FORMUN) + " " + FOREST), ME_TAM)
                 endif
               endif

               S++

               if S > 24 
                 exit
               endif

            next && R

            cab_etq1()                  && emite etiqueta

            if S > 24 
              exit
            endif

            M_ESC = inkey()

            if M_ESC = 27
               if susimp()
                 ? "------------------------------"
                 ? "* * * IMPRESSAO SUSPENSA * * *"
                 go bottom
                 skip
             else
                 M_ESC = inkey()
             endif
           endif

        enddo

    ?? chr(27) + "@"

desliga1()

return "" 

*****************
function VERFOR02   && Munic¡pios conforme tabela IBGE
*****************

if M_FORCDM = 0
  sele_arquivo("AMUN00")
  M_FORCDM = nCodRetorno
endif

if !BUSCAREGISTRO("AMUN00",1,{str(M_FORCDM,7,0)},"SELECT")
  msg("* * * MUNICIPIO NAO CADASTRADO * * *")
  M_FORCDM = 0
  return .f.
endif

M_FORMUN = pad(AMUN00->MUNNOM, 32)
M_FOREST = AMUN00->MUNEST

setcolor("N/W*")
  @ 14, 33 say    M_FORMUN picture "@!@S28"
  @ 14, 66 say    M_FOREST picture "@!"
set color to

return .t.


*****************
function VERFOR03
*****************

parameters M_FORCOD

if M_FORCOD = 0
  return .t.
endif

select AFOR00

if !dbseek(str(M_FORCOD, 7, 0))
  msg("* * * FORNECEDOR NAO CADASTRADO * * *")
  return .f.
endif

msg(alltrim(FORNOM))

return .t.

*****************
function VERFOR04
*****************

if rat(str(ME_DAD, 1, 0),"1#2#3") = 0
  msg("* * * (1) RESIDENCIA  (2) ENTREGA  (3) COBRANCA * * *")
  return .f.
endif

return .t.
