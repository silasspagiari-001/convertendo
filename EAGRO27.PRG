#include "ptmenu.ch"

***************
function MANCPG
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("MENU","PAGAMENTOS",M_FAN,"EAGRO27","Mem: " + str(memory(0), 5),M_EMP) 

*        @ 05, 19 prompt "Inclus„o " HIGHLITE R/BG PERMITE 7,2,1
*        @ 06, 19 prompt "Altera‡„o" HIGHLITE R/BG PERMITE 7,2,2
*        @ 07, 19 prompt "Consulta " HIGHLITE R/BG PERMITE 7,2,3
*        @ 08, 19 prompt "Exclus„o " HIGHLITE R/BG PERMITE 7,2,4
*        @ 09, 19 prompt "Listagem " HIGHLITE R/BG PERMITE 7,2,5

      do case
         case M_OPC = 1 ; inccpg()
         case M_OPC = 2 ; altcpg()
         case M_OPC = 3 ; concpg()
         case M_OPC = 4 ; exccpg()
         case M_OPC = 5 ; liscpg()
      endcase

    fecha_arq()

return ""

***************
function INCCPG
***************

    do while .t.

        M_CPGCOD = 0
        M_CPGACR = 0
        M_CPGPAR = 0
        M_CPGDES = space(30)
        M_CPGPR1 = 0
        M_CPGPE1 = 0
        M_CPGPR2 = 0
        M_CPGPE2 = 0
        M_CPGPR3 = 0
        M_CPGPE3 = 0
        M_CPGPR4 = 0
        M_CPGPE4 = 0
        M_CPGPR5 = 0
        M_CPGPE5 = 0
        M_CPGPR6 = 0
        M_CPGPE6 = 0

      tlcpg01() 

      rodape("INCLUI","PAGAMENTOS",M_FAN,"EAGRO27","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 09, 31 get     M_CPGCOD   picture "###"
        read

        if M_CPGCOD = 0
            exit
        endif

        select ACPG00

        if dbseek(str(M_CPGCOD, 3, 0))
          msg("* * * CONDICAO DE PAGAMENTO JA CADASTRADA * * *")
          loop
        endif

        _append("ACPG00")

        edcpg01()                      && edita dados da cpgdedor

        if lastkey() = 27
          msg("* * * CONDICAO DE PAGAMENTO NAO INCLUIDA * * *")
          loop
        endif

        grcpg01()                      && grava dados da cpgdedor
        
        msg("* * * CONDICAO DE PAGAMENTO INCLUIDA * * *")

    enddo

return ""

***************
function ALTCPG
***************

    do while .t.

    tlcpg01() 

        rodape("ALTERA","PAGAMENTOS",M_FAN,"EAGRO27","Mem: " + str(memory(0), 5),M_EMP) 

        store 0 to M_CPGCOD
        SetColor(_COREDICAO_)
        @ 09, 31 get     M_CPGCOD   picture "###"
        read

        if M_CPGCOD = 0
          exit
        endif

      if !BUSCAREGISTRO("ACPG00",1,{str(M_CPGCOD,3,0)},"SELECT")
        msg("* * * EMPRESA N?O CADASTRADA * * *")
        loop
      endif

        mscpg01()                      && mostra dados do cpgdedor

        M_CPGCOD = CPGCOD
        M_CPGACR = CPGACR
        M_CPGPAR = CPGPAR
        M_CPGDES = CPGDES
        M_CPGPR1 = CPGPR1
        M_CPGPE1 = CPGPE1
        M_CPGPR2 = CPGPR2
        M_CPGPE2 = CPGPE2
        M_CPGPR3 = CPGPR3
        M_CPGPE3 = CPGPE3
        M_CPGPR4 = CPGPR4
        M_CPGPE4 = CPGPE4
        M_CPGPR5 = CPGPR5
        M_CPGPE5 = CPGPE5
        M_CPGPR6 = CPGPR6
        M_CPGPE6 = CPGPE6

        edcpg01() 

        if lastkey() = 27
          msg("* * * CONDICAO DE PAGAMENTO NAO ALTERADA * * *")
          loop
        endif

        grcpg01("UPDATE")                      && grava dados da cpg

        msg("* * * CONDICAO DE PAGAMENTO ALTERADA * * *")

    enddo

return ""

***************
function CONCPG
***************
        
private M_CPGCOD
             
do while .t.

  tlcpg01()

  rodape("CONSULTA","PAGAMENTOS",M_FAN,"EAGRO27","Mem: " + str(memory(0), 5),M_EMP) 

  store 0 to M_CPGCOD
  SetColor(_COREDICAO_)
  @ 09, 31 get     M_CPGCOD   picture "###"
  read

  if M_CPGCOD = 0
      exit
  endif

  BUSCAREGISTRO("ACPG00",1,{str(M_CPGCOD,3,0)},"SELECT")

  nCPGCOD = CPGCOD


  do while .t.

    mscpg01()

    waitstate()

    if lastkey() = 5 .or. lastkey() = 19
      seexiste("ACPG00")
      cSQl := "SELECT * FROM ACPG00 WHERE CPGCOD = (SELECT max(CPGCOD) FROM ACPG00 WHERE CPGCOD < " + str(nCPGCOD, 3, 0) + ") and CPGCOD <> 0"
      dbusearea(.T.,"SQLMIX",cSQL,"ACPG00")
      if bof()
        seexiste("ACPG00")
        nCPGCOD = 999
        cSQl := "SELECT * FROM ACPG00 WHERE CPGCOD = (SELECT max(CPGCOD) FROM ACPG00 WHERE CPGCOD < " + str(nCPGCOD, 3, 0) + ") and CPGCOD <> 0"
        dbusearea(.T.,"SQLMIX",cSQL,"ACPG00")
      endif
    endif

    if lastkey() = 24 .or. lastkey() = 4
      seexiste("ACPG00")
      cSQl := "SELECT * FROM ACPG00 WHERE CPGCOD = (SELECT min(CPGCOD) FROM ACPG00 WHERE CPGCOD > " + str(nCPGCOD, 3, 0) + ") and CPGCOD <> 0"
      dbusearea(.t.,"SQLMIX",cSQL,"ACPG00")
      if eof()
        seexiste("ACPG00")
        nCPGCOD = 0
        cSQl := "SELECT * FROM ACPG00 WHERE CPGCOD = (SELECT min(CPGCOD) FROM ACPG00 WHERE CPGCOD > " + str(nCPGCOD, 3, 0) + ") and CPGCOD <> 0"
        dbusearea(.t.,"SQLMIX",cSQL,"ACPG00")
      endif
    endif

    nCPGCOD = CPGCOD

    if may_inkey(,.t.) = 27
     exit
    endif

enddo

enddo


return ""

***************
function EXCCPG
***************
        
private M_CPGCOD ,;
        M_OPC
             
    do while .t.

      tlcpg01() 
 
        rodape("EXCLUI","PAGAMENTOS",M_FAN,"EAGRO27","Mem: " + str(memory(0), 5),M_EMP) 

        store 0 to M_CPGCOD
        SetColor(_COREDICAO_)
        @ 09, 31 get     M_CPGCOD   picture "###"
        read

        if M_CPGCOD = 0
            exit
        endif

        select ACPG00

        if !dbseek(str(M_CPGCOD, 3, 0))
          msg("* * * CONDICAO DE PAGAMENTO NAO CADASTRADO * * *")
          loop
        endif
        
        mscpg01()

        if !rlock()
          msg("* * * (ACPG00) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_OPC = confirma("deste Pagamento")

        if M_OPC != 1
          msg("* * * CONDICAO DE PAGAMENTO NAO EXCLUIDA * * *")
          unlock
          loop
        endif
        
        elimina()

        msg("* * * CONDICAO DE PAGAMENTO EXCLUIDO * * *")

    enddo

return ""

***************
function LISCPG
*************** 

private M_COD1  ,;
        M_COD2  ,; 
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_TELA
 
    do while .t.

       rodape("LISTA","PAGAMENTOS",M_FAN,"EAGRO27","Mem: " + str(memory(0), 5),M_EMP) 

       sombra(09, 29, 12, 53,_SOMBRA_)

       store 0 to M_COD1  ,;
                  M_COD2  

       set color to GR+/W
         @ 09, 29 say      "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
         @ 10, 29 say      "³Pagamento Inicial:     ³" 
         @ 11, 29 say      "³            Final:     ³" 
         @ 12, 29 say      "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
        SetColor(_COREDICAO_)

        @ 10, 49 get M_COD1 picture "###"  
        @ 11, 49 get M_COD2 picture "###"   
        read

        if lastkey() = 27
          return ""
        endif

        M_COD1 = iif(M_COD1 = 0,  1,M_COD1)
        M_COD2 = iif(M_COD2 = 0,999,M_COD2) 

        select ACPG00

        go top

        set softseek on
          seek str(M_COD1, 3, 0)
        set softseek off

        if CPGCOD > M_COD2
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

        ? cent_cab(AEMP00->EMPFAN,"TABELA DE CONDICAO DE PAGAMENTO","EAGRO27",132) 
        ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
        ? "*-----*---*------*------------------------------*-------------*-------------*-------------*-------------*-------------*------------*"
        ? "* COD *PAR* AR   * DESCRICAO                    *  PARCELA 1  *  PARCELA 2  *  PARCELA 3  *  PARCELA 4  *  PARCELA 5  *  PARCELA 6 *" 
        ? "*-----*---*------*------------------------------*-------------*-------------*-------------*-------------*-------------*------------*"
*          |99999| 9 |999.99|XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|###    ###.##|###    ###.##|###    ###.##|###    ###.##|###    ###.##|###   ###.##|

        store 5 to LN

        do while !eof() .and. LN < 60

          if  CPGCOD > M_COD2
            go bottom
            skip
            loop
          endif 

            ? "|"
              ?? str(CPGCOD, 5, 0)
              ?? "| "
              ?? str(CPGPAR, 1, 0)
              ?? " |"
              ?? str(CPGACR, 6, 2)
              ?? "| "
              ?? pad(CPGDES, 36)
              ?? "|"
              if CPGPE1 > 0
                ?? str(CPGPR1, 3, 0)
                ?? "  "
                ?? str(CPGPE1, 6, 2)
                ?? "% |"
              else
                ?? "            |"
              endif
              if CPGPE2 > 0
                ?? str(CPGPR2, 3, 0)
                ?? "  "
                ?? str(CPGPE2, 6, 2)
                ?? "% |"
              else
                ?? "             |"
              endif
              if CPGPE3 > 0
                ?? str(CPGPR3, 3, 0)
                ?? "  "
                ?? str(CPGPE3, 6, 2)
                ?? "% |"
              else
                ?? "             |"
              endif
              if CPGPE4 > 0
                ?? str(CPGPR4, 3, 0)
                ?? "  "
                ?? str(CPGPE4, 6, 2)
                ?? "% |"
              else
                ?? "             |"
              endif
              if CPGPE5 > 0
                ?? str(CPGPR5, 3, 0)
                ?? "  "
                ?? str(CPGPE5, 6, 2)
                ?? "% |"
              else
                ?? "             |"
              endif
              if CPGPE6 > 0
                ?? str(CPGPR6, 3, 0)
                ?? " "
                ?? str(CPGPE6, 6, 2)
                ?? "% |"
              else
                ?? "            |"
              endif

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
function TLCPG01
****************


 nbox(8, 17, 18, 61,"W/W+",.t.)
 setcolor("B/W")
    @ 09, 18 say     "C o d i g o:        Acr:        Parcelas:  "
    @ 10, 18 say     "Descricao  :                               "
    @ 11, 18 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 12, 18 say     "Prazo  1   :        Percentual  1  :       "
    @ 13, 18 say     "       2   :                    2  :       "
    @ 14, 18 say     "       3   :                    3  :       "
    @ 15, 18 say     "       4   :                    4  :       "
    @ 16, 18 say     "       5   :                    5  :       "
    @ 17, 18 say     "       6   :                    6  :       "
  set color to

return ""

****************
function EDCPG01
****************

private R ,;
        S ,;
        P

do while .t.
  SetColor(_COREDICAO_)
  @ 09, 43 get     M_CPGACR picture "##.##"
  @ 09, 60 get     M_CPGPAR picture "#"
  @ 10, 31 get     M_CPGDES picture "@!"
  @ 12, 31 get     M_CPGPR1 picture "###"
  @ 12, 55 get     M_CPGPE1 picture "###.##"
  @ 13, 31 get     M_CPGPR2 picture "###"
  @ 13, 55 get     M_CPGPE2 picture "###.##"
  @ 14, 31 get     M_CPGPR3 picture "###"
  @ 14, 55 get     M_CPGPE3 picture "###.##"
  @ 15, 31 get     M_CPGPR4 picture "###"
  @ 15, 55 get     M_CPGPE4 picture "###.##"
  @ 16, 31 get     M_CPGPR5 picture "###"
  @ 16, 55 get     M_CPGPE5 picture "###.##"
  @ 17, 31 get     M_CPGPR6 picture "###"
  @ 17, 55 get     M_CPGPE6 picture "###.##"
  read

  P = 0

    for R = 1 to M_CPGPAR
      S = str(R, 1)
      P = P + M_CPGPE&S
    next

    for R = M_CPGPAR + 1 to 6
      S = str(R, 1)
      M_CPGPR&S = 0
      M_CPGPE&S = 0
    next 

    if P < 100.00
      msg("* * * VALOR DE 100 % NAO FOI ATINGIDO * * *")
      loop
    endif     
 
    if P > 100.00
      msg("* * * VALOR DE 100 % FOI ULTRAPASSADO * * *")
      loop
    endif

  set color to I
    for R = 1 to 6
      S = str(R, 1)
      @ R + 11, 31 say M_CPGPR&S picture "###"
      @ R + 11, 55 say M_CPGPE&S picture "###.##"
    next    
  set color to 

  exit

enddo

return ""

****************
function MSCPG01
****************

  setcolor("N/W*")
    @ 09, 31 say     CPGCOD picture "###"
    @ 09, 43 say     CPGACR picture "##.##"
    @ 09, 60 say     CPGPAR picture "#"
    @ 10, 31 say     CPGDES picture "@!"    
    @ 12, 31 say     CPGPR1 picture "###"
    @ 12, 55 say     CPGPE1 picture "###.##"
    @ 13, 31 say     CPGPR2 picture "###"
    @ 13, 55 say     CPGPE2 picture "###.##"
    @ 14, 31 say     CPGPR3 picture "###"
    @ 14, 55 say     CPGPE3 picture "###.##"
    @ 15, 31 say     CPGPR4 picture "###"
    @ 15, 55 say     CPGPE4 picture "###.##"
    @ 16, 31 say     CPGPR5 picture "###"
    @ 16, 55 say     CPGPE5 picture "###.##"
    @ 17, 31 say     CPGPR6 picture "###"
    @ 17, 55 say     CPGPE6 picture "###.##"
  set color to
  
return ""

****************
function GRCPG01(cAcao)                       && grava dados da condicao de pagamento
****************

sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"ACPG00",cACAO}

aadd(sqlCHAVE,{"CPGCOD",str(M_CPGCOD,3)})

if !cACAO == "DELETE"
   aadd(sqlCAMPO,{"CPGCOD",str(M_CPGCOD,3),.t.})
   aadd(sqlCAMPO,{"CPGACR",str1(M_CPGACR,2),.t.})
   aadd(sqlCAMPO,{"CPGPAR",str(M_CPGPAR,2),.t.})
   aadd(sqlCAMPO,{"CPGDES",M_CPGDES,.t.})
   aadd(sqlCAMPO,{"CPGPR1",str(M_CPGPR1,3),.t.})
   aadd(sqlCAMPO,{"CPGPE1",str1(M_CPGPE1,2),.t.})
   aadd(sqlCAMPO,{"CPGPR2",str(M_CPGPR2,3),.t.})
   aadd(sqlCAMPO,{"CPGPE2",str1(M_CPGPE2,2),.t.})
   aadd(sqlCAMPO,{"CPGPR3",str(M_CPGPR3,3),.t.})
   aadd(sqlCAMPO,{"CPGPE3",str1(M_CPGPE3,2),.t.})
   aadd(sqlCAMPO,{"CPGPR4",str(M_CPGPR4,3),.t.})
   aadd(sqlCAMPO,{"CPGPE4",str1(M_CPGPE4,2),.t.})
   aadd(sqlCAMPO,{"CPGPR5",str(M_CPGPR5,3),.t.})
   aadd(sqlCAMPO,{"CPGPE5",str1(M_CPGPE5,2),.t.})
   aadd(sqlCAMPO,{"CPGPR6",str(M_CPGPR6,3),.t.})
   aadd(sqlCAMPO,{"CPGPE6",str1(M_CPGPE6,2),.t.})
endif

executasql()

return ""
