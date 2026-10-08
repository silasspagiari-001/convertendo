#include "ptmenu.ch"
#command @ <row> , <col>  GET <var> [<clauses,...>] F2 [<moreClauses,...>] funcao <func> retorno <Variavel>;
=>       @ <row> , <col>  GET <var> [<clauses>] SEND reader := {|oGet| Getf2(oGet,<func>,<Variavel>) } [<moreClauses>]

***************
function MANLAB
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("MENU","LANCAMENTO",M_FAN,"EAGRO53","Mem: " + str(memory(0), 5),M_EMP)

*        @ 05, 52 prompt "Inclus„o " HIGHLITE R/BG PERMITE 3,5,1
*        @ 06, 52 prompt "Altera‡„o" HIGHLITE R/BG PERMITE 3,5,2
*        @ 07, 52 prompt "Consultas" HIGHLITE R/BG PERMITE 3,5,3
*        @ 08, 52 prompt "Exclus„o " HIGHLITE R/BG PERMITE 3,5,4
*        @ 09, 52 prompt "Listagens" HIGHLITE R/BG PERMITE 3,5,5
*        @ 10, 52 prompt "Conciliar" POSITION 2 HIGHLITE R/BG PERMITE 3,5,6

      do case
         case M_OPC = 1 ; inclab()
         case M_OPC = 2 ; altlab()   
         case M_OPC = 3 ; conlab()     
         case M_OPC = 4 ; exclab()   
         case M_OPC = 5 ; lislab()   
         case M_OPC = 6 ; liblab()   
      endcase

    fecha_arq()

return ""

*****************
function PEGADATA(FLIN,FCOL,FDATA)
******************

FDATA = calendar(, FLIN-1, FCOL+10,, 2)
return .t.

***************  
function INCLAB          && inclui Lancamento  
***************  

private M_OPN

        M_LANEMP   = ME_EMP
        M_LANDTA   = date()
        M_LANCTA   = space(13)

    do while .t.

      tllab01()                         && monta tela inicial 
                                                             
      rodape("INCLUI","LANCAMENTO",M_FAN,"EAGRO53","Mem: " + str(memory(0), 5),M_EMP) 

        M_LANSEQ   = 0
        M_LANSEX   = 0
        M_LANVLR   = 0
        M_LANCOD   = 0
        M_LANTIP   = " "
        M_LANHIS   = space(65)
        M_FLAG     = 0
        SetColor(_COREDICAO_)
*        @ 04, 15 get M_PEDCLI picture "#######" F2 color _CORF2_ funcao "sele_arquivo('ACLI00')" retorno @M_PEDCLI

        @ 10, 29 get M_LANDTA  F2 color _CORF2_ funcao "pegadata(10,29,@M_LANDTA)" retorno "re"
        @ 12, 29 get     M_LANCTA picture "@!"     valid verconta(@M_LANCTA,@M_LANSEQ,"SEQ")
        @ 13, 29 get     M_LANSEQ picture "######"
        read

        if lastkey() = 27 
          exit
        endif        

        if BUSCAREGISTRO("ALAB00",1,{str(M_LANEMP, 2, 0),aspas(M_LANCTA),str(M_LANSEQ, 6, 0)},"SELECT")
          msg("* * * LANCAMENTO JA CADASTRADO * * *")
          loop
        endif
 
        edlab01()

        if lastkey() = 27
          msg("* * * LANCAMENTO NAO INCLUIDO * * *")
          loop
        endif

        M_OPN = decide("Confirma Inclusao do Lancamento")

        if M_OPN != 1
          msg("* * * LANCAMENTO NAO INCLUIDO * * *")
          loop
        endif       


        grlab01("INSERT")                      && grava plano de contas

        msg("* * * LANCAMENTO INCLUIDO * * *")

  enddo

return ""

***************  
function ALTLAB          && altera Lancamento  
***************  

private M_OPN

    M_LANEMP   = ME_EMP
    M_LANCTA   = space(13)
    M_LANDTA   = ctod("  /   /  ")

    do while .t.

      tllab01()                         && monta tela inicial 
                                                             
      rodape("ALTERA","LANCAMENTO",M_FAN,"EAGRO53","Mem: " + str(memory(0), 5),M_EMP) 

        M_LANSEQ   = 0
        M_LANVLR   = 0
        M_LANCOD   = 0
        M_LANTIP   = " "
        M_LANHIS   = space(65)
        SetColor(_COREDICAO_)
        @ 10, 29 get     M_LANDTA              valid verlab05()
        @ 12, 29 get     M_LANCTA picture "@!" valid verlab02()
        @ 13, 29 get     M_LANSEQ picture "######"
        read

        if lastkey() = 27 
          exit
        endif        

        select ALAB00

        if !dbseek(str(M_LANEMP, 2, 0) + dtos(M_LANDTA) + M_LANCTA + str(M_LANSEQ, 6, 0))
          msg("* * * LANCAMENTO NAO CADASTRADO * * *")
          loop
        endif

        mslab01()

        if !rlock()
          msg("* * * (ALAB00) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_LANEMP   = LANEMP
        M_LANCTA   = LANCTA
        M_LANDTA   = LANDTA
        M_LANSEQ   = LANSEQ
        M_LANVLR   = LANVLR
        M_LANHIS   = LANHIS
        M_LANCOD   = LANCOD
        M_LANTIP   = LANTIP
        edlab01()

        if lastkey() = 27
          msg("* * * LANCAMENTO NAO ALTERADO * * *")
          select ALAB00
          unlock
          loop
        endif

        grlab01()                      && grava lancamento

        msg("* * * LANCAMENTO ALTERADO * * *")

  enddo

return ""

***************
function CONLAB        && consulta Lancamento  
***************

private M_LANEMP   ,;         
        M_LANCTA   ,;         
        M_LANDTA   ,;          
        M_OPN      ,;
        M_MES      ,;
        M_SALDO  

    M_LANCTA   = space(13)
    M_LANEMP   = ME_EMP
    M_DTAINI   = ctod("  /   /  ")
    M_DTAFIN   = ctod("  /   /  ")

    do while .t.

      tllab02()                         && monta tela inicial 
                                                             
      rodape("CONSULTA","LANCAMENTO",M_FAN,"EAGRO53","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 05, 16 get     M_LANCTA picture "@!" valid verconta(@M_LANCTA)   // verlab09()
        @ 05, 45 get     M_DTAINI
        @ 05, 57 get     M_DTAFIN
        read

        if lastkey() = 27 
          exit
        endif        

        M_DTAINI = iif(dtoc(M_DTAINI) = "  /  /  ",ctod("01/01/80"),M_DTAINI)
        M_DTAFIN = iif(dtoc(M_DTAFIN) = "  /  /  ",ctod("31/12/79"),M_DTAFIN) 

        if !BUSCAREGISTRO("ACTA00",1,{str(M_LANEMP, 2, 0),aspas(M_LANCTA)},"SELECT")
          msg("* * * CONTA NAO CADASTRADA * * *")
          loop
        endif


  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ALAB00","ALAB00"})
  aadd(sqlCAMPO,"ALAB00.*")
  aadd(sqlCHAVE,"LANEMP = " + str(M_LANEMP, 2, 0))
  aadd(sqlCHAVE,"LANCTA = " + aspas(M_LANCTA))
  aadd(sqlCHAVE,"LANDTA BETWEEN " + aspas(formatdta(M_DTAINI)) + " and " + aspas(formatdta(M_DTAFIN)))
  aadd(sqlORDEM,"LANDTA,LANSEQ")
  sqlrelation()

        M_SALDO = 0

        do while !eof()

          if dtos(LANDTA) >= dtos(M_DTAINI)
            exit
          endif 

          if LANTIP = "C"
            M_SALDO = M_SALDO + LANVLR
          else
            if LANTIP = "D"
              M_SALDO = M_SALDO - LANVLR
            endif
          endif

          skip

        enddo

        set color to I
          @ 06, 63 say M_SALDO picture "@E ###,###,###.##"
        set color to 

        L = 10

        do while !eof()

          if LANTIP = "C"
            M_SALDO = M_SALDO + LANVLR
          else
            if LANTIP = "D"
              M_SALDO = M_SALDO - LANVLR
            endif
          endif

          set color to I
            @ L, 03 say left(dtoc(LANDTA), 5)
            @ L, 09 say LANCOD picture "###"
            @ L, 13 say left(LANHIS, 24)
            @ L, 40 say LANSEQ picture "######"
            @ L, 47 say LANVLR picture "@E ###,###,###.##"
            @ L, 61 say LANTIP
            @ L, 63 say M_SALDO picture "@E ###,###,###.##"
          set color to 

          L = L + 1

          if L > 17
             msg("* * * (ENTER) Continua (ESC) Sai * * *")
             for K=10 to 17
               set color to I
                 @ K, 03 say space(05)
                 @ K, 09 say space(03)
                 @ K, 13 say space(24)
                 @ K, 38 say space(01)
                 @ K, 40 say space(06)
                 @ K, 47 say space(15)
                 @ K, 63 say space(14)
               set color to 
             next 
             if lastkey() = 27
               exit
             endif
             L = 10
           endif

           skip

        enddo

        set color to I
          @ 19, 63 say M_SALDO picture "@E ###,###,###.##" 
        set color to 

        msg("* * * TECLE (ENTER) * * *")

    enddo

    set order to 1

return ""

***************  
function EXCLAB          && exclui Lancamento  
***************  

private M_OPN

    M_LANEMP   = ME_EMP
    M_LANCTA   = space(13)
    M_LANDTA   = ctod("  /   /  ")
    M_LANSEQ   = 0

    do while .t.

      tllab01()                         && monta tela inicial 
                                                             
      rodape("EXCLUI","LANCAMENTO",M_FAN,"EAGRO53","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 10, 29 get     M_LANDTA              valid verlab05()
        @ 12, 29 get     M_LANCTA picture "@!" valid verlab02()
        @ 13, 29 get     M_LANSEQ picture "######"
        read

        if lastkey() = 27 
          exit
        endif        

        select ALAB00

        if !dbseek(str(M_LANEMP, 2, 0) + dtos(M_LANDTA) + M_LANCTA + str(M_LANSEQ, 6, 0))
          msg("* * * LANCAMENTO NAO CADASTRADO * * *")
          loop
        endif

        mslab01()

        if !rlock()
          msg("* * * (ALAB00) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_OPN = confirma("deste Lancamento")

        if M_OPN != 1
          msg("* * * LANCAMENTO NAO EXCLUIDO * * *")
          unlock all
          loop
        endif
        elimina()

        msg("* * * LANCAMENTO EXCLUIDO * * *")

  enddo

return ""

***************  
function LISLAB
***************  

private M_TELA ,;
        M_OPN  

    do while .t.

        rodape("LISTA","LANCAMENTOS",M_FAN,"EAGRO53","Mem: " + str(memory(0), 5),M_EMP)  

        sombra(08, 57, 13, 68,_SOMBRA_)
        set color to N/BG
          @ 08, 57, 13, 68 box M_FRAME1a     
        set color to W+/BG,W+/N
          @ 09, 58 prompt   "Analitico " HIGHLITE R/BG     
          @ 10, 58 prompt   "Sintetico " HIGHLITE R/BG     
          @ 11, 58 prompt   "Conciliar " HIGHLITE R/BG     
          @ 12, 58 prompt   "Extrato   " HIGHLITE R/BG     
          menu to M_OPN
        set color to

        M_TELA = savescreen(01, 01, 23, 79)
 
        do case
           case M_OPN = 0
             exit
           case M_OPN = 1
              lislab_a()
           case M_OPN = 2 
              lislab_b()
           case M_OPN = 3 
              lislab_c()
           case M_OPN = 4 
              lislab_d()
        endcase

        restscreen(01, 01, 23, 79, M_TELA)

     enddo

return ""

*****************
function LISLAB_A         && listagem
*****************

private M_SALDO  ,;
        M_DTAINI ,; 
        M_DTAFIN ,;
        M_CTAINI ,; 
        M_CTAFIN ,;
        M_TOTDES ,;
        M_TOTREC ,;
        M_TELA

  do while .t.

    rodape("LISTA","LANCAMENTO",M_FAN,"EAGRO53","Mem: " + str(memory(0), 5),M_EMP) 
     
    store space(13) to M_CTAINI ,;
                       M_CTAFIN 
    store 0         to M_TOTDES ,;
                       M_TOTREC
                      

    store ctod("  /  /  ")     to M_DTAINI ,;
                                  M_DTAFIN ,; 
                                  M_DTAANT
    store  0 to PG, LN, M_SALDO

 nbox(14, 32, 19, 56,"W/W+",.t.)
 setcolor("B/W")
     @ 15, 33 say             " Periodo:              "
     @ 16, 33 say             "     Ate:              "
     @ 17, 33 say             "   Conta:              "
     @ 18, 33 say             "     Ate:              "
    SetColor(_COREDICAO_)
    @ 15, 43 get M_DTAINI
    @ 16, 43 get M_DTAFIN
    @ 17, 43 get M_CTAINI picture "@!"
    @ 18, 43 get M_CTAFIN picture "@!"
    read

    M_CTAINI = iif(empty(M_CTAINI),"0            ",M_CTAINI)
    M_CTAFIN = iif(empty(M_CTAFIN),"9999999999999",M_CTAFIN) 
    M_DTAINI = iif(dtoc(M_DTAINI) = "  /  /  ",ctod("01/01/80"),M_DTAINI)
    M_DTAFIN = iif(dtoc(M_DTAFIN) = "  /  /  ",ctod("31/12/79"),M_DTAFIN) 

    if lastkey() = 27
      exit
    endif

    select ALAB00

    set relation to str(LANEMP, 2, 0) + LANCTA into ACTA00

    set softseek on 
      seek str(ME_EMP, 2, 0) + dtos(M_DTAINI)
    set softseek off

    if str(LANEMP, 2, 0) + dtos(LANDTA) > str(ME_EMP, 2, 0) + dtos(M_DTAFIN)
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

    cab_lab()

    do while !eof()

      if str(LANEMP, 2, 0) + dtos(LANDTA) > str(ME_EMP, 2, 0) + dtos(M_DTAFIN)
        go bottom
        skip
        loop
      endif

      if LANCTA > M_CTAFIN .or. LANCTA < M_CTAINI
        skip
        loop
      endif

      if LANDTA != M_DTAANT
        if M_DTAANT != ctod("  /  /  ")
          ? replicate("-", 132)
        endif
        ? LANDTA
        LN = LN + 2
        M_DTAANT = LANDTA
      endif

      if LN > 60
        cab_lab()
      endif

       ? space(01)
        ?? ACTA00->CTACTA 
        ?? " "
        ?? left(ACTA00->CTAAGE,30)
        ?? " "
        ?? pad(LANHIS, 55)
        ?? " "
        ?? " "
        ?? " "
        ?? LANTIP
        ?? " "
        ?? str(LANSEQ, 6, 0)
        ?? " "
        ?? transform(LANVLR,"@E ###,###,###,###.##")

        LN = LN + 1

        if LN > 60
          cab_lab()
        endif

        if LANTIP = "D"
          M_TOTDES = M_TOTDES + LANVLR
        else
          if LANTIP = "C"
            M_TOTREC = M_TOTREC + LANVLR
          endif
        endif
          
        M_ESC = inkey()

          if M_ESC = 27
            if susimp()
              ? replicate("-", 132)
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
   ? "Total (Credito - Debito ) "
     ?? transform((M_TOTREC - M_TOTDES),"@E ###,###,###,###.##")  
     ?? "     Credito.......       " 
     ?? transform(M_TOTREC,"@E ###,###,###,###.##")  
     ?? "     Debitos......       " 
     ?? transform(M_TOTDES,"@E ###,###,###,###.##")  
     

  eject

desliga1()

  enddo

return ""

***************  
function LISLAB_B         && saldo de contas
***************  

private M_DTASLD ,;
        M_CTAINI ,; 
        M_CTAFIN ,;
        M_TELA   

  do while .t.

    rodape("LISTA","SINTETICO",M_FAN,"EAGRO53","Mem: " + str(memory(0), 5),M_EMP) 
     
    store space(13) to M_CTAINI ,;
                       M_CTAFIN 

    store date() to M_DTASLD

    store  0 to PG, LN

 nbox(14, 32, 18, 56,"W/W+",.t.)
 setcolor("B/W")
     @ 15, 33 say             "   Conta:              "
     @ 16, 33 say             "     Ate:              "
     @ 17, 33 say             "Ate Data:              "
    SetColor(_COREDICAO_)
    @ 15, 43 get M_CTAINI picture "@!"
    @ 16, 43 get M_CTAFIN picture "@!"
    @ 17, 43 get M_DTASLD 
    read

    M_CTAINI = iif(empty(M_CTAINI),"0            ",M_CTAINI)
    M_CTAFIN = iif(empty(M_CTAFIN),"ZZZZZZZZZZZZZ",M_CTAFIN) 

    if lastkey() = 27
      exit
    endif

    select ACTA00

    set softseek on
      seek str(ME_EMP, 2, 0) + M_CTAINI
    set softseek off

    if str(CTAEMP, 2, 0) + CTACTA > str(ME_EMP, 2, 0) + M_CTAFIN
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

          ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE SALDO DAS CONTAS - ATE: " + dtoc(M_DTASLD),"EAGRO53",80) 
          ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 80)
          ? "*-------------*----------------------------------------*-----*-----------------*"
          ? "*    CONTA    *         AGENCIA                        *BANCO*   SALDO ATUAL   *"
          ? "*-------------*----------------------------------------*-----*-----------------*"
*             xxxxxxxxxxxxx XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXX #################  

          store 6 to LN
  
          do while !eof() .and. LN < 60 
 
            if str(CTAEMP, 2, 0) + CTACTA > str(ME_EMP, 2, 0) + M_CTAFIN
              go bottom
              skip 
              loop
            endif

            ? space(01)
              ?? CTACTA
              ?? " "
              ?? CTAAGE
              ?? " " 
              ?? str(CTABAN, 5)
              ?? " "
              ?? transform(sld_cta(CTACTA),"@E ##,###,###,###.##")
 
            select ACTA00

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

*****************
function LISLAB_C         && lancamentos pre-datados
*****************

private M_SALDO  ,;
        M_DTAINI ,; 
        M_DTAFIN ,;
        M_CTAINI ,; 
        M_CTAFIN ,;
        M_TOTDES ,;
        M_TOTREC ,;
        M_TELA   

  do while .t.

    rodape("LISTA","PRE-DATADO",M_FAN,"EAGRO53","Mem: " + str(memory(0), 5),M_EMP) 
     
    store space(13) to M_CTAINI ,;
                       M_CTAFIN 

    store 0         to M_TOTCHE ,;
                       M_GERCHE

    store ctod("  /  /  ")     to M_DTAINI ,;
                                  M_DTAFIN ,; 
                                  M_DTAANT
    store  0 to PG, LN, M_SALDO
 nbox(14, 32, 19, 56,"W/W+",.t.)
 setcolor("B/W")
     @ 15, 33 say             " Periodo:              "
     @ 16, 33 say             "     Ate:              "
     @ 17, 33 say             "   Conta:              "
     @ 18, 33 say             "     Ate:              "

    SetColor(_COREDICAO_)
    @ 15, 43 get M_DTAINI
    @ 16, 43 get M_DTAFIN
    @ 17, 43 get M_CTAINI picture "@!"
    @ 18, 43 get M_CTAFIN picture "@!"
    read

    M_CTAINI = iif(empty(M_CTAINI),"0            ",M_CTAINI)
    M_CTAFIN = iif(empty(M_CTAFIN),"ZZZZZZZZZZZZZ",M_CTAFIN) 
    M_DTAINI = iif(dtoc(M_DTAINI) = "  /  /  ",ctod("01/01/80"),M_DTAINI)
    M_DTAFIN = iif(dtoc(M_DTAFIN) = "  /  /  ",ctod("31/12/79"),M_DTAFIN) 

    if lastkey() = 27
      exit
    endif

    select ALAB00

    set relation to str(LANEMP, 2, 0) + LANCTA into ACTA00

    set softseek on 
      seek str(ME_EMP, 2, 0) + dtos(M_DTAINI)
    set softseek off

    if str(LANEMP, 2, 0) + dtos(LANDTA) > str(ME_EMP, 2, 0) + dtos(M_DTAFIN)
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

    cab_lab()

    do while !eof()

      if str(LANEMP, 2, 0) + dtos(LANDTA) > str(ME_EMP, 2, 0) + dtos(M_DTAFIN)
        go bottom
        skip
        loop
      endif

      if LANCTA > M_CTAFIN
        skip
        loop
      endif

      if  LANCTA < M_CTAINI
        skip
        loop
      endif

      if LANDTA != M_DTAANT
        if M_TOTCHE > 0
          ? space(89)
            ?? "Total dos Cheques .....  " 
            ?? transform(M_TOTCHE,"@E ##,###,###,###.##")  
            ? replicate("-", 132)
        endif 
        ? LANDTA
        LN = LN + 2
        M_DTAANT = LANDTA
        M_TOTCHE = 0
      endif

      if LN > 60
        cab_lab()
      endif

       ? space(01)
        ?? ACTA00->CTACTA 
        ?? " "
        ?? left(ACTA00->CTAAGE,30)
        ?? " "
        ?? pad(LANHIS, 55)
        ?? " "
        ?? " "
        ?? " "
        ?? LANTIP
        ?? " "
        ?? str(LANSEQ, 6, 0)
        ?? " "
        ?? transform(LANVLR,"@E ###,###,###,###.##")

        LN = LN + 1

        if LN > 60
          cab_lab()
        endif

        M_TOTCHE = M_TOTCHE + LANVLR
        M_GERCHE = M_GERCHE + LANVLR
          
        M_ESC = inkey()

          if M_ESC = 27
            if susimp()
              ? replicate("-", 132)
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
   ? space(89)
     ?? "Total dos Cheques .....  " 
     ?? transform(M_TOTCHE,"@E ##,###,###,###.##")  
   ? replicate("-", 132)
   ? space(89)
     ?? "Total G e r a l  ......  " 
     ?? transform(M_GERCHE,"@E ##,###,###,###.##")  

    eject

desliga1()

  enddo

return ""

*****************
function LISLAB_D         && extrato
*****************


private M_TELA   ,;
        M_OPC          


  do while .t.

    rodape("LISTA","LANCAMENTO",M_FAN,"EAGRO53","Mem: " + str(memory(0), 5),M_EMP) 
     
    store space(13) to M_CTAINI ,;
                       M_CTAFIN 
    store 0         to M_TOTDES ,;
                       M_TOTREC
                      

    store date()               to M_DTAINI ,;
                                  M_DTAFIN ,; 
                                  M_DTAAN 
    store  0 to PG,;
                LN,;
                M_SALDO ,;
                M_TOTDEB,;
                M_TOTCRE

 nbox(14, 32, 19, 58,"W/W+",.t.)
 setcolor("B/W")
        @ 15, 33 say "  Conta de:              "
        @ 16, 33 say "       ate:              "
        @ 17, 33 say "Periodo de:              "
        @ 18, 33 say "       Ate:              "
      SetColor(_COREDICAO_)
      @ 15, 45 get M_CTAINI picture "@!"  valid verext01()
      @ 16, 45 get M_CTAFIN picture "@!"   
      @ 17, 45 get M_DTAINI 
      @ 18, 45 get M_DTAFIN 
      read

      if lastkey() = 27
        exit
      endif

      M_CTAINI = iif(empty(M_CTAINI),"0            ",M_CTAINI)
      M_CTAFIN = iif(empty(M_CTAFIN),"9999999999999",M_CTAFIN) 
      M_DTAINI = iif(dtoc(M_DTAINI) = "  /  /  ",ctod("01/01/80"),M_DTAINI)
      M_DTAFIN = iif(dtoc(M_DTAFIN) = "  /  /  ",ctod("31/12/79"),M_DTAFIN) 
      M_MES    = strzero((month(M_DTAINI)-1), 2, 0)
      M_ANO    = right(str(year(M_DTAINI), 4, 0), 2)

     select ACTA00

     set softseek on
       seek str(ME_EMP, 2, 0) + M_CTAINI
     set softseek off

     if eof() .or. str(CTAEMP, 2, 0) + CTACTA > str(ME_EMP, 2, 0) + M_CTAFIN
       msg("* * * NADA A LISTAR NO INTERVALO * * *")
       loop
     endif

     M_IMPRE = impresn()

     if M_IMPRE = "N"
       exit
     endif

     if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
       ?? chr(15)                        && comprime
     endif

    cab_ext()
 
    do while !eof()

      if str(CTAEMP, 2, 0) + CTACTA > str(ME_EMP, 2, 0) + M_CTAFIN
        exit
      endif

      M_SALDO  = 0
      M_TOTDEB = 0
      M_TOTCRE = 0

      select ALAB00

      set order to 2

      set softseek on 
        seek str(ME_EMP, 2, 0) + ACTA00->CTACTA + dtos(ctod("01/01/80"))
      set softseek off

      if !str(LANEMP, 2, 0) + LANCTA  == str(ME_EMP, 2, 0) + ACTA00->CTACTA
        select ACTA00
        skip
        loop 
      endif

      M_DTAAN = ctod("  /  /  ")

      do while !eof()

        if str(LANEMP, 2, 0) + LANCTA + dtos(LANDTA) >= str(ME_EMP, 2, 0) + ACTA00->CTACTA + dtos(M_DTAINI)
          exit
        endif

        if LANTIP = "C"
          M_SALDO = M_SALDO + LANVLR
          M_TOTCRE = M_TOTCRE + LANVLR
        else
          if LANTIP = "D"
            M_SALDO = M_SALDO - LANVLR
            M_TOTDEB = M_TOTDEB + LANVLR
          endif
        endif

        skip

      enddo            

        ? space(01)
          ?? (LANDTA - 1)
          ?? "   SALDO ANTERIOR .....  "
          ?? space(79)
          ?? transform(M_SALDO,"@E ###,###,###,###.##")

      do while !eof()

        if str(LANEMP, 2, 0) + LANCTA + dtos(LANDTA) > str(ME_EMP, 2, 0) + ACTA00->CTACTA + dtos(M_DTAFIN)
          go bottom
          skip
          loop
        endif

        if !str(LANEMP, 2, 0) + LANCTA  == str(ME_EMP, 2, 0) + ACTA00->CTACTA
          go bottom
          skip
          loop 
         endif

        if LN > 60
          cab_ext()
        endif

        if LANTIP = "C"
          M_SALDO = M_SALDO + LANVLR
          M_TOTCRE = M_TOTCRE + LANVLR
        else
          if LANTIP = "D"
            M_SALDO = M_SALDO - LANVLR
            M_TOTDEB = M_TOTDEB + LANVLR
          endif
        endif

       ? space(01)
        ?? LANDTA
        ?? " "
        ?? " "
        ?? " "
        ?? str(LANSEQ, 6, 0)
        ?? " "
        ?? alltrim(LANHIS)
        ?? replicate(".",65 - len(alltrim(LANHIS))) 
        ?? " "
        if LANTIP = "D"
          ?? transform(LANVLR,"@E ###,###,###.##")
          ?? space(15)
        else 
          if LANTIP = "C"
            ?? space(15)
            ?? transform(LANVLR,"@E ###,###,###.##")
          else
            ?? space(29)
          endif
        endif

        skip

        if M_DTAAN != LANDTA
          ?? " "
          ?? transform(M_SALDO,"@E #####,###,###.##")
          M_DTAAN = LANDTA
        endif

        LN = LN + 1

        if LN > 60
          cab_ext()
        endif
          
        M_ESC = inkey()

          if M_ESC = 27
            if susimp()
              ? replicate("-", 132)
              ? "* * * IMPRESSAO SUSPENSA * * *"
              go bottom
              skip
              loop              
            else
              M_ESC = inkey()
            endif
          endif

      enddo

      ? replicate("-", 132)
      ? space(09)
        ?? "    TOTAIS/SALDO FINAL  .......  "
        ?? space(39)
        ?? transform(M_TOTDEB,"@E ###,###,###,###.##")
        ?? " "
        ?? transform(M_TOTCRE,"@E ###,###,###.##")
        ?? " "
        ?? transform(M_SALDO,"@E #,###,###,###.##")

      select ACTA00

      skip

    enddo

    eject

desliga1()

  enddo

return ""

****************
function CAB_EXT
****************

 store PG + 1 to  PG 

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"EXTRATO DE CONTA BANCARIA ","EAGRO53",132) 
  ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
  ? cent_cab("","CONTA: " + ACTA00->CTACTA + " " + ACTA00->CTAAGE,"", 132)
  ? "*--------*-*------*------------------------------------------------------------------*--------------*--------------*----------------*"
  ? "  DATA   *S* DOC  *           H  I  S  T  O  R  I  C  O                              * D E B I T O  *C R E D I T O *   S A L D O    *"
  ? "*--------*-*------*------------------------------------------------------------------*--------------*--------------*----------------*"
*     99/99/99 P XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ###,###,###.## ###,###,###.## #####,###,###.##

  store 6 to LN

return ""

***************** 
function VEREXT01
***************** 

  select ACTA00 

  if empty(M_CTAINI)
    sele_cta()
    M_CTAINI = CTACTA
    M_CTAFIN = CTACTA
    return .f.
  endif

  if !dbseek(str(ME_EMP, 2, 0) + M_CTAINI)
    msg("* * * CONTA NAO CADASTRADA * * *")
    M_CTAINI = space(13)
    M_CTAFIN = space(13)
    return .f.
  endif

return .t. 

***************  
function LIBLAB          && libera Lancamento  
***************  

private M_OPC 

    M_LANEMP   = ME_EMP
    M_LANCTA   = space(13)
    M_LANDTA   = ctod("  /   /  ")
    M_LANSEQ   = 0

    do while .t.

      tllab01()                         && monta tela inicial 
                                                             
      rodape("LIBERA","LANCAMENTO",M_FAN,"EAGRO53","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 10, 29 get     M_LANDTA              valid verlab05()
        @ 12, 29 get     M_LANCTA picture "@!" valid verlab02()
        @ 13, 29 get     M_LANSEQ picture "######"
        read

        if lastkey() = 27 
          exit
        endif        

        select ALAB00

        if !dbseek(str(M_LANEMP, 2, 0) + dtos(M_LANDTA) + M_LANCTA + str(M_LANSEQ, 6, 0))
          msg("* * * LANCAMENTO NAO CADASTRADO * * *")
          loop
        endif

        mslab01()

        if !rlock()
          msg("* * * (ALAB00) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_LANEMP   = LANEMP
        M_LANCTA   = LANCTA
        M_LANDTA   = LANDTA
        M_LANSEQ   = LANSEQ
        M_LANVLR   = LANVLR
        M_LANHIS   = LANHIS
        M_LANCOD   = LANCOD
        M_LANTIP   = LANTIP

        M_OPC = decide("Confirma Conciliacao")

        if M_OPC != 1
          msg("* * * LANCAMENTO NAO CONCILIADO * * *")
          unlock
          loop
        endif


        grlab01()                      && grava lancamento

        msg("* * * LANCAMENTO CONCILIADO * * *")

  enddo

return ""

****************
function SLD_CTA
****************

parameters M_CTACTA

private M_SALDO 

M_SALDO = 0

select ALAB00

set order to 2

set softseek on
  seek str(ME_EMP, 2, 0) + M_CTACTA + dtos(ctod("  /  /  "))
set softseek off

do while !eof()

   if str(LANEMP, 2, 0) + LANCTA + dtos(LANDTA) > str(ME_EMP, 2, 0) + M_CTACTA + dtos(M_DTASLD)
     exit
   endif

   if LANTIP = "C"
        M_SALDO = M_SALDO + LANVLR
   else
      if LANTIP = "D"
          M_SALDO = M_SALDO - LANVLR
      endif
   endif

   skip

enddo

set order to 1

return M_SALDO

****************
function CAB_LAB
****************

 store PG + 1 to  PG 

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE LANCAMENTOS " + iif(M_OPN=1,"ANALITICO ",iif(M_OPN=2,"SINTETICO ","PRE-DATADO")), "EAGRO53",132) 
  ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
  ? "*-------------*------------------------------*-------------------------------------------------------*-*-*------*------------------*" 
  ? "*    CONTA    * AGENCIA                      *                 H I S T O R I C O                     *S*T* SEQ  *    V A L O R     *" 
  ? "*-------------*------------------------------*-------------------------------------------------------*-*-*------*------------------*" 
  *   XXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX X X 999999 ###,###,###,###.##

  store 5 to LN

return ""

****************
function TLLAB01
****************

 nbox(09, 14, 18, 65,"W/W+",.t.)
 setcolor("B/W")
    @ 10, 15 say     " Data Lancto:                                     "
    @ 11, 15 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 12, 15 say     " C o n t a  :               Banco:                "
    @ 13, 15 say     " Documento  :                                     "
    @ 14, 15 say     "                                                  "
    @ 15, 15 say     " V a l o r  :                  R$:                "
    @ 16, 15 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 17, 15 say     " Historico  :                                     "
  set color to

return ""

****************
function EDLAB01
****************

   SetColor(_COREDICAO_)
   @ 15, 29 get M_LANVLR picture "#########.##"    valid verlab10()
   @ 17, 29 get M_LANCOD F2 picture "###" valid verlab03() color _CORF2_ funcao "sele_arquivo('AHIS00')" retorno @M_LANCOD
   @ 17, 33 get M_LANTIP picture "@!" valid verlab04()
   @ 17, 35 get M_LANHIS picture "@!@S30"
   read

return .t.

****************
function TLLAB02                      && monta tela 2 do kardex
****************

 nbox(04, 02, 20, 77,"W/W+",.t.)
 setcolor("B/W")
    @ 05, 03 say     " Conta    :                      Per¡odo:          a                      "
    @ 06, 03 say     " Descri‡„o:                                Saldo Anterior:                "
    @ 07, 03 say     "ÄÄÄÄÄÂÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 08, 03 say     "DATA ³COD³   DESCRI€O            ³S³ SEQ  ³    VALOR      ³    SALDO     "
    @ 09, 03 say     "ÄÄÄÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 10, 03 say     "     ³   ³                        ³ ³      ³               ³              "
    @ 11, 03 say     "     ³   ³                        ³ ³      ³               ³              "
    @ 12, 03 say     "     ³   ³                        ³ ³      ³               ³              "
    @ 13, 03 say     "     ³   ³                        ³ ³      ³               ³              "
    @ 14, 03 say     "     ³   ³                        ³ ³      ³               ³              "
    @ 15, 03 say     "     ³   ³                        ³ ³      ³               ³              "
    @ 16, 03 say     "     ³   ³                        ³ ³      ³               ³              "
    @ 17, 03 say     "     ³   ³                        ³ ³      ³               ³              "
    @ 18, 03 say     "ÄÄÄÄÄÁÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 19, 03 say     "                                              Saldo Atual:                "
  set color to

return ""

****************
function MSLAB01
****************

 setcolor("N/W*")
    @ 15, 29 say LANVLR picture "#########.##"
    @ 15, 50 say LANVLR picture "@E ##,###,###.##"
    @ 17, 29 say LANCOD picture "###"          
    @ 17, 33 say LANTIP 
    @ 17, 35 say pad(LANHIS, 30)
  set color to 

return ""

*****************
function VERLAB02
***************** 

  if lastkey() = 5
    return .t.
  endif 

  select ACTA00 

  if empty(M_LANCTA)
    sele_cta()
    M_LANCTA = CTACTA
    return .f.
  endif

  if !dbseek(str(M_LANEMP, 2, 0) + M_LANCTA) 
    msg("* * * CONTA NAO CADASTRADA * * *")
    M_LANCTA = space(13)
    return .f.
  endif

  set color to I 
    @ 12, 50 say pad(CTAAGE, 15)          
  set color to 

return .t. 

***************** 
function VERLAB03
***************** 

  if lastkey() = 5
    return .t.
  endif 

  if M_LANCOD = 0 
    return .f.
  endif

  if !BUSCAREGISTRO("AHIS00",1,{str(M_LANCOD, 3)},"SELECT")
    msg("* * * HISTORICO NAO CADASTRADO * * *")
    return .f.
  endif

  if M_OPC = 1
    M_LANHIS = pad(HISDES, 65)
    M_LANTIP = HISTIP
  endif

return .t. 

***************** 
function VERLAB04
***************** 

  if lastkey() = 5
    return .t.
  endif 

  if !M_LANTIP $ "-DC"
     msg("* * * VALIDO SOMENTE (-)NULO  (D)EBITO  (C)REDITO * * *")
     return .f.
  endif

return .t.

***************** 
function VERLAB05
***************** 


return .t.


*****************
function VERLAB08
*****************

if lastkey() = 5
  return .t.
endif

if M_LANAPL = 0
  return .t.
endif

select APLX00

if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANAPL, 3, 0))
   msg("* * * APLICACAO NAO CADASTRADA * * *")
   return .f.
endif

msg("* * * " + alltrim(PLXNOM) + " * * *")

return .t.

***************** 
function VERLAB09
***************** 

  select ACTA00 

  if empty(M_LANCTA)
    sele_cta()
    M_LANCTA = CTACTA
    return .f.
  endif

  if !dbseek(str(M_LANEMP, 2, 0) + M_LANCTA)
    msg("* * * CONTA NAO CADASTRADA * * *")
    M_LANCTA = space(13)
    return .f.
  endif

  set color to I
    @ 06, 15 say pad(CTAAGE, 30)
  set color to

return .t. 

*****************
function VERLAB10
*****************

if lastkey() = 5
  return .t.
endif

if M_LANVLR <= 0
  msg("* * * VALOR NAO PODE SER ZEROS * * *")
  return .f.
endif

set color to I
  @ 15, 50 say M_LANVLR picture "@E ##,###,###.##"
set color to 

return .t.


*****************
function VERLAB11
*****************

  if lastkey() = 5
    return .t.
  endif

  if M_LANSEQ = 0
    M_LANSEQ = ACTA00->CTASEQ + 1
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"ACTA00","UPDATE"}
    aadd(sqlCHAVE,{"CTAEMP",str(ME_EMP,2)})
    aadd(sqlCHAVE,{"CTACTA",aspas(M_LANCTA)})
    aadd(sqlCAMPO,{"CTASEQ",str(M_LANSEQ),.t.})
    executasql()
    return .f.
  else
    return .t.
  endif

return .t.

****************
function GRLAB01(cACAO)
****************

sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"ALAB00",cACAO}

aadd(sqlCHAVE,{"LANEMP",str(M_LANEMP,2)})
aadd(sqlCHAVE,{"LANDTA",formatdta(M_LANDTA)})
aadd(sqlCHAVE,{"LANCTA",aspas(M_LANCTA)})
aadd(sqlCHAVE,{"LANSEQ",str(M_LANSEQ,6)})

if !cACAO $ "#DELETE#SELECT#"
  aadd(sqlCAMPO,{"LANEMP",str(M_LANEMP),.t.})
  aadd(sqlCAMPO,{"LANCTA",M_LANCTA,.t.})
  aadd(sqlCAMPO,{"LANDTA",formatdta(M_LANDTA),.t.})
  aadd(sqlCAMPO,{"LANSEQ",str(M_LANSEQ),.t.})
  aadd(sqlCAMPO,{"LANVLR",str1(M_LANVLR,2),.t.})
  aadd(sqlCAMPO,{"LANCOD",str(M_LANCOD),.t.})
  aadd(sqlCAMPO,{"LANHIS",M_LANHIS,.t.})
  aadd(sqlCAMPO,{"LANTIP",M_LANTIP,.t.})
endif

executasql()

return ""

