#include "ptmenu.ch"

***************
function MANFIS
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("MENU","OPERACOES",M_FAN,"EAGRO72","Mem: " + str(memory(0), 5),M_EMP)

*        @ 05, 61 prompt "Inclusao " HIGHLITE R/BG PERMITE 2,7,1
*        @ 06, 61 prompt "Alteracao" HIGHLITE R/BG PERMITE 2,7,2
*        @ 07, 61 prompt "Consulta " HIGHLITE R/BG PERMITE 2,7,3
*        @ 08, 61 prompt "Exclusao " HIGHLITE R/BG PERMITE 2,7,4
*        @ 09, 61 prompt "Listagem " HIGHLITE R/BG PERMITE 2,7,5
*        @ 10, 61 prompt "Outros   " HIGHLITE R/BG PERMITE 2,7,6

      do case
         case M_OPC = 1 ; incfis()
         case M_OPC = 2 ; altfis()
         case M_OPC = 3 ; confis()
         case M_OPC = 4 ; excfis()
         case M_OPC = 5 ; lisfis()
      endcase

    fecha_arq()

return ""

***************
function INCFIS
***************

    do while .t.

        M_FISEMP = ME_EMP
        M_FISNOM = space(30)
        M_FISICM = "S"
        M_FISIPI = "S"
        M_FISICN = "N"
        M_FISENT = "N"
        M_FISSAI = "N"
        M_FISEST = " "
        M_FISMED = "S"
        M_FISINT = "-"
        M_FISCPL = "N"
        M_FISOBS = space(10)
        M_FISCTB = "N"
        M_FISANO = "-"
        M_FISPAN = "N"
        M_FISLIV = "N"
        M_FISESC = 0 
        M_FISEXE = 0
        M_FISAPL = 0
        M_FISCSG = "-"
        M_FISNOV = space(5)

      tlfis01() 

      rodape("INCLUI","OPERACOES",M_FAN,"EAGRO72","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 10, 25 get     M_FISNOV picture "9.999"
        read

        if val(M_FISNOV) = 0 .or. lastkey()=27
          exit
        endif

        if BUSCAREGISTRO("AFIS00",1,{str(ME_EMP, 2, 0),aspas(M_FISNOV)},"SELECT")
          msg("* * * NATUREZA Jµ CADASTRADA * * *")
          loop
        endif

        edfis01()                      && edita dados da fisresa

        if lastkey() = 27
          msg("* * * OPERACOES NéO CADASTRADA * * *")
          loop
        endif

        grfis01("INSERT")
        
        msg("* * * OPERACOES INCLUIDA * * *")

    enddo

return ""

***************
function ALTFIS
***************
        
    do while .t.

        M_FISEMP = ME_EMP
        M_FISNOV = space(5)

        tlfis01() 

        rodape("ALTERA","OPERACOES",M_FAN,"EAGRO72","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 10, 25 get     M_FISNOV picture "9.999"
        read

        if lastkey() = 27
          exit
        endif

        if !BUSCAREGISTRO("AFIS00",1,{str(ME_EMP, 2, 0),aspas(M_FISNOV)},"SELECT")
          msg("* * * OPERACOES NéO CADASTRADA * * *")
          loop
        endif

        M_FISNOM = FISNOM
        M_FISICM = FISICM
        M_FISIPI = FISIPI
        M_FISICN = FISICN
        M_FISENT = FISENT
        M_FISSAI = FISSAI
        M_FISEST = FISEST
        M_FISMED = FISMED
        M_FISINT = FISINT
        M_FISCPL = FISCPL
        M_FISOBS = FISOBS
        M_FISCTB = FISCTB
        M_FISANO = FISANO
        M_FISPAN = FISPAN
        M_FISLIV = FISLIV
        M_FISESC = FISESC
        M_FISEXE = FISEXE
        M_FISAPL = FISAPL
        M_FISCSG = FISCSG

        edfis01()                     

        if lastkey() = 27
          msg("* * * OPERACOES NéO ALTERADA * * *")
          loop
        endif

        grfis01("UPDATE")
        
        msg("* * * OPERACOES ALTERADA * * *")

    enddo

return ""

***************
function CONFIS
***************
        
    do while .t.

        M_FISEMP = ME_EMP
        M_FISNOV = space(5)

        tlfis01() 

        rodape("CONSULTA","OPERACOES",M_FAN,"EAGRO72","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 10, 25 get     M_FISNOV   picture "9.999"
        read

        if lastkey() =27
          exit
        endif

        select AFIS00

        dbseek(M_FISNOV)

        if empty(FISNOM) .or. eof()
          locate for !empty(FISNOM) 
        endif 

        setas()

        do while .t.

          msfis01()

          inkey(0)

          if lastkey() = 5
             skip - 1
             if bof() .or. empty(FISNOM) 
               go bottom
             endif  
          endif         

          if lastkey() = 24
            skip
            if eof()
              go top 
              locate for !empty(FISNOM) 
            endif
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
function EXCFIS
***************
        
private M_OPC 

    do while .t.

        M_FISEMP = ME_EMP
        M_FISNOV = space(5)

        tlfis01() 

        rodape("EXCLUSéO","OPERACOES",M_FAN,"EAGRO72","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 10, 25 get     M_FISNOV   picture "9.999"
        read

        if lastkey() = 27
          exit
        endif

        select AFIS00

        if !dbseek(M_FISNOV)
          msg("* * * OPERACAO NéO CADASTRADA * * *")
          loop
        endif

        msfis01()

        if !rlock()
          msg("* * * (AFIS00) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_OPC = confirma("desta Operacao")

        if M_OPC != 1
          msg("* * * OPERACOES NéO EXCLUIDA * * *")
          unlock
          loop
        endif
        elimina()

        msg("* * * OPERACAO EXCLUIDA * * *")

    enddo

return ""

***************
function LISFIS
*************** 

private M_COD1  ,;
        M_COD2  ,; 
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_TELA
 
    do while .t.

        rodape("LISTA","OPERACOES",M_FAN,"EAGRO72","Mem: " + str(memory(0), 5),M_EMP) 

        store 0        to M_COD1,;
                          M_COD2

       sombra(10, 39, 13, 64,_SOMBRA_)

       nbox(10, 39, 13, 64,"W/W+",.t.)
       setcolor("B/W")
          @ 11, 40 say     "OperaáÑo Inicial:       "
          @ 12, 40 say     "           Final:       "
        SetColor(_COREDICAO_)
        @ 11, 58 get M_COD1 picture "#####"
        @ 12, 58 get M_COD2 picture "#####"   
        read

        if lastkey() = 27
          return ""
        endif

        M_COD1 = iif(M_COD1 = 0,10000,M_COD1)
        M_COD2 = iif(M_COD2 = 0,99999,M_COD2) 

        select AFIS00

        go top

        set softseek on
          seek str(ME_EMP, 2, 0) + str(M_COD1, 5, 0)
        set softseek off

        if FISEMP != ME_EMP
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

        ? cent_cab(AEMP00->EMPFAN,"TABELA DE OPERACOES","EAGRO72",132) 
        ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
        ? "*------*----------------------------------------*-----*----*----*----*----*----*----*----*-----------*----*----*----*----*----*----*"
        ? "*CODIGO*DESCRICAO                               *CICMS*ICNO*ENTR*SAID*ESTO*MEDI*PGRE*CPLM*   OBS     *CONS*ANUA*IPI *LIVR*ESCR*EXEC*"
        ? "*------*----------------------------------------*-----*----*----*----*----*----*----*----*-----------*----*----*----*----*----*----*"
 *          999.99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ##.##    X    X    X    X    X    X    X XXXXXXXXXX     X    X    X    X    X    X

        store 5 to LN

        do while !eof() .and. LN < 60

          
          if str(FISEMP, 2, 0) + str(FISCOD, 5, 0) > str(ME_EMP, 2, 0) + str(M_COD2, 5, 0)
            go bottom
            skip
            loop
          endif 
          if empty(FISNOV)
            skip
            loop
          endif

            ? " "
              ?? FISNOV
              ?? " "
              ?? FISNOM
              ?? space(11)
              ?? pad(FISICM, 5)
              ?? "    "
              ?? FISICN
              ?? "    "
              ?? FISENT
              ?? "    "
              ?? FISSAI
              ?? "    "
              ?? FISEST
              ?? "    "
              ?? FISMED
              ?? "    "
              ?? FISINT
              ?? "    "
              ?? FISCPL
              ?? " "
              ?? pad(FISOBS, 10)
              ?? "     "
              ?? FISCSG
              ?? "    "
              ?? FISANO
              ?? "   "
              ?? FISIPI
              ?? "    "
              ?? " "
              ?? str(FISAPL, 3, 0)
              ?? " "
              ?? str(FISESC, 1, 0)
              ?? "    "
              ?? str(FISEXE, 1, 0)

            LN = LN + 1

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
function TLFIS01
****************

 nbox(09, 13, 17, 66,"W/W+",.t.)
 setcolor("B/W")
    @ 10, 14 say     " C¢digo  :                                          "
    @ 11, 14 say     " Nome    :                                          "
    @ 12, 14 say     "ƒSped S/N:          Calcula Pis/Cofins:   ƒƒƒƒƒƒƒƒƒƒ"
    @ 13, 14 say     " CalcIcms:        Icm^Nota:    CalcIpi:   Entrada:  "
    @ 14, 14 say     " Estoque :     Custo mÇdio:    Pag/Rec:     Saida:  "
    @ 15, 14 say     " Obs     :                       Anual:     Compl:  "
    @ 16, 14 say     " ExceáÑo :       AplicaáÑo:        Esc:     Consg:  "
set color to

return ""

****************
function EDFIS01
****************

    SetColor(_COREDICAO_)
    @ 11, 25 get     M_FISNOM picture "@!"

    @ 12, 25 get     M_FISPAN picture "@!" valid M_FISPAN $ "SN"
    @ 12, 54 get     M_FISCTB picture "@!" valid M_FISCTB $ "SN"

    @ 13, 25 get     M_FISICM picture "@!"         valid verfis01()
    @ 13, 42 get     M_FISICN picture "@!"         valid verfis02()
    @ 13, 54 get     M_FISIPI picture "@!"         valid verfis11()
    @ 13, 65 get     M_FISENT picture "@!"         valid verfis04() 

    @ 14, 25 get     M_FISEST picture "@!"         valid verfis05()
    @ 14, 42 get     M_FISMED picture "@!"         valid verfis06()
    @ 14, 54 get     M_FISINT picture "@!"         valid verfis07()
    @ 14, 65 get     M_FISSAI picture "@!"         valid verfis03() 

    @ 15, 25 get     M_FISOBS picture "@!"         valid verfis09()
*    @ 15, 54 get     M_FISANO picture "@!"         valid verfis10()
    @ 15, 65 get     M_FISCPL picture "@!"         valid verfis08()

    @ 16, 25 get     M_FISEXE picture "#"          valid verfis14() 
*    @ 16, 42 get     M_FISAPL picture "###"        valid verfis15()
    @ 16, 54 get     M_FISESC picture "#"          valid verfis13()
 *   @ 16, 65 get     M_FISCSG picture "@!"         valid verfis16()

    read

return ""

****************
function MSFIS01
****************

 setcolor("N/W*")

    @ 10, 25 say     FISNOV
    @ 11, 25 say     FISNOM picture "@!"    

    @ 12, 25 say     FISPAN picture "@!" 
    @ 12, 54 say     FISCTB picture "@!" 

    @ 13, 25 say     FISICM picture "@!"   
    @ 13, 42 say     FISICN picture "@!"   
    @ 13, 54 say     FISIPI picture "@!"   
    @ 13, 65 say     FISENT picture "@!"   

    @ 14, 25 say     FISEST picture "@!"   
    @ 14, 42 say     FISMED picture "@!"   
    @ 14, 54 say     FISINT picture "@!"   
    @ 14, 65 say     FISSAI picture "@!"   

    @ 15, 25 say     FISOBS picture "@!"   
    @ 15, 54 say     FISANO picture "@!"   
    @ 15, 65 say     FISCPL picture "@!"   

    @ 16, 25 say     FISEXE picture "#"    
    @ 16, 42 say     FISAPL picture "###"  
    @ 16, 54 say     FISESC picture "#"    
    @ 16, 65 say     FISCSG picture "@!"   

 set color to
  
return ""

****************
function GRFIS01(cACAO)
****************

sqlORDEM = {}
sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"AFIS00",cACAO}

aadd(sqlCHAVE,{"FISEMP",str(ME_EMP,2)})
aadd(sqlCHAVE,{"FISNOV",aspas(M_FISNOV)})

if !cACAO $ "#DELETE#SELECT#"
   aadd(sqlCAMPO,{"FISEMP",str(M_FISEMP),.t.})
   aadd(sqlCAMPO,{"FISNOM",M_FISNOM,.t.})
   aadd(sqlCAMPO,{"FISICM",M_FISICM,.t.})
   aadd(sqlCAMPO,{"FISIPI",M_FISIPI,.t.})
   aadd(sqlCAMPO,{"FISICN",M_FISICN,.t.})
   aadd(sqlCAMPO,{"FISENT",M_FISENT,.t.})
   aadd(sqlCAMPO,{"FISSAI",M_FISSAI,.t.})
   aadd(sqlCAMPO,{"FISEST",M_FISEST,.t.})
   aadd(sqlCAMPO,{"FISMED",M_FISMED,.t.})
   aadd(sqlCAMPO,{"FISINT",M_FISINT,.t.})
   aadd(sqlCAMPO,{"FISCPL",M_FISCPL,.t.})
   aadd(sqlCAMPO,{"FISOBS",M_FISOBS,.t.})
   aadd(sqlCAMPO,{"FISCTB",M_FISCTB,.t.})
   aadd(sqlCAMPO,{"FISANO",M_FISANO,.t.})
   aadd(sqlCAMPO,{"FISPAN",M_FISPAN,.t.})
   aadd(sqlCAMPO,{"FISESC",str(M_FISESC),.t.})
   aadd(sqlCAMPO,{"FISEXE",str(M_FISEXE),.t.})
   aadd(sqlCAMPO,{"FISCSG",M_FISCSG,.t.})
   aadd(sqlCAMPO,{"FISNOV",M_FISNOV,.t.})
endif

if !executasql()
  return .f.
endif

return .t.

*****************
function VERFIS01
*****************

  if lastkey() = 5
    return .t.
  endif

  if !M_FISICM $ "SN"
    msg("* * * Calcula ICMS (S)im (N)ao  * * *")
    return .f.
  endif

return .t.

*****************
function VERFIS02
*****************

  if lastkey() = 5
    return .t.
  endif

  if rat(M_FISICN,"SN") = 0
    msg("* * * VALOR DO ICMS SOBRE TOTAL DA NOTA (S)im (N)Ño * * *")
    return .f.
  endif

return .t.

*****************
function VERFIS03
*****************

  if lastkey() = 5
    return .t.
  endif

  if rat(M_FISENT,"SN") = 0
    msg("* * * SAI NO LIVRO DE ENTRADA (S)im (N)Ño * * *")
    return .f.
  endif

return .t.

*****************
function VERFIS04
*****************

  if lastkey() = 5
    return .t.
  endif

  if rat(M_FISSAI,"SN") = 0
    msg("* * * SAI NO LIVRO DE SAIDA (S)im (N)Ño * * *")
    return .f.
  endif

return .t.

*****************
function VERFIS05
*****************

    if lastkey() = 5
        return .t.
    endif

if rat(M_FISEST,"DC-") = 0
  msg("* * * ATUALIZA SALDO DISPONIVEL (D)Çbito  (C)redito (-)Nulo * * *")
  return .f.
endif

return .t.

*****************
function VERFIS06
*****************

    if lastkey() = 5
        return .t.
    endif

if rat(M_FISMED,"SN") = 0
  msg("* * * ATUALIZA CUSTO MêDIO (S)im (N)Ño * * *")
  return .f.
endif

return .t.

*****************
function VERFIS07
*****************

  if lastkey() = 5
    return .t.
  endif

  if rat(M_FISINT,"PR-") = 0
    msg("* * * ITEGRA Contas a (P)agar  Contas a (R)eceber (-) Nulo * * *")
    return .f.
  endif

return .t.

*****************
function VERFIS08
*****************

  if lastkey() = 5
      return .t.
  endif

  if rat(M_FISCPL,"SN") = 0
    msg("* * * E NOTA FISCAL DE COMPLEMENTO (S)im (N)ao * * *")
    return .f.
  endif

return .t.

*****************
function VERFIS09
*****************

  if lastkey() = 5
    return .t.
  endif

  msg("* * * OBSERVACAO A SER IMPRESSO NO LIVRO FISCAL * * *")

return .t.

*****************
function VERFIS10
*****************

private M_TELA

  if lastkey() = 5
    return .t.
  endif

  if !M_FISANO $ "--#VN#CN#DV#DC"
    M_TELA = savescreen(8, 18, 15, 61)
 nbox(08, 18, 14, 60,"W/W+",.t.)
 setcolor("B/W")
      @ 09, 19 say     " (--) Nulo                               "
      @ 10, 19 say     " (VN) Venda Normal                       "
      @ 11, 19 say     " (CN) Compra Normal                      "
      @ 12, 19 say     " (DV) Devolucao de Venda                 "
      @ 13, 19 say     " (DC) Devolucao de Compra                "
    set color to
    set cursor off
      inkey(0)
    set cursor on
    restscreen( 8, 18, 15, 61, M_TELA)
    return .f.
  endif

return .t.

*****************
function VERFIS11
*****************

  if lastkey() = 5
    return .t.
  endif

  if rat(M_FISIPI,"SN") = 0
    msg("* * * CALCULA IPI (S)im (N)Ño * * *")
    return .f.
  endif

return .t.

*****************
function VERFIS12
*****************

parameters F_FISCDD

  if lastkey() = 5
    return .t.
  endif

  if rat(F_FISCDD,"TI-") = 0
    msg("* * * ATUALIZA A CRêDITO POR (T)otal (I)ndividual (-) Nulo * * *")
    return .f.
  endif

return .t.

*****************
function VERFIS13
*****************

  if lastkey() = 5
    return .t.
  endif

  if !str(M_FISESC, 1, 0) $ "#1#2#3#4#5#6#7"  && ESC
    private M_TELA
    M_TELA = savescreen(6, 16, 17, 64)
 nbox(06, 16, 16, 63,"W/W+",.t.)
 setcolor("B/W")
      @ 07, 17 say     " Cod ≥             I c m s                    "
      @ 08, 17 say     "ƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ"
      @ 09, 17 say     "  1  ≥ Com Credito Ipi/Icms                   "
      @ 10, 17 say     "  2  ≥ Sem Credito Ipi/Icms Isento            "
      @ 11, 17 say     " *3  ≥ Sem Credito Ipi/Icms Outros            "
      @ 12, 17 say     "  4  ≥ Com Credito Icms Sem Credito Ipi Isento"
      @ 13, 17 say     " *5  ≥ Com Credito Icms Sem Credito Ipi Outros"
      @ 14, 17 say     "  6  ≥ Com Credito Ipi Sem Credito Icms Isento"
      @ 15, 17 say     "  7  ≥ Com Credito Ipi Sem Credito Icms Outros"
    set color to
    inkey(0)
    restscreen(6, 16, 17, 64, M_TELA)
    return .f.
  endif

return .t.

*****************
function VERFIS14
*****************

  if lastkey() = 5
    return .t.
  endif

  if rat(str(M_FISEXE, 1, 0),"1#2#3#4#5#6#7#8") = 0 
    private M_TELA
    M_TELA = savescreen(8, 18, 15, 60)
 nbox(08, 18, 14, 59,"W/W+",.t.)
 setcolor("B/W")
      @ 09, 19 say     " Cod ≥        S i t u a c a o           "
      @ 10, 19 say     "ƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ"
      @ 11, 19 say     "  1  ≥ Notas Fiscais Normais            "
      @ 12, 19 say     "  2  ≥ Credito de ICMS 50 % 512 612     "
      @ 13, 19 say     "  3  ≥ Inclui IPI Base de Calculo ICMS  "
    set color to
    inkey(0)
    restscreen(8, 18, 15, 60, M_TELA)
    return .f.
  endif

return .t.

*****************
function VERFIS15
*****************

if lastkey() = 5
  return .t.
endif

if M_FISAPL = 0
  return .t.
endif

select APLX00

if !dbseek(str(M_FISEMP, 2, 0) + str(M_FISAPL, 3, 0))
  msg("* * * APLICACAO NAO CADASTRADO * * *")
  return .f.
endif

msg("* * * " + alltrim(PLXNOM) + " * * *")

return .t.    

*****************
function VERFIS16
*****************

if lastkey() = 5
  return .t.
endif

if rat(M_FISCSG,"DC-") = 0
  msg("* * * ATUALIZA CONSIGNADA (D)Çbito  (C)redito (-)Nulo * * *")
  return .f.
endif

return .t.
