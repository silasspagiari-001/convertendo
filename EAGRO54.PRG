#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)

#command @ <row> , <col>  GET <var> [<clauses,...>] F2 [<moreClauses,...>] funcao <func> retorno <Variavel>;
=>       @ <row> , <col>  GET <var> [<clauses>] SEND reader := {|oGet| Getf2(oGet,<func>,<Variavel>) } [<moreClauses>]

***************
function MANCHE
***************
parameters M_OPC,M_OPC1,M_OPC2

#include "ptmenu.ch"

      rodape("MENU","CHEQUES",M_FAN,"EAGRO54","Mem: " + str(memory(0), 5),M_EMP)

 *       @ 05, 52 prompt "Inclusao " HIGHLITE R/BG PERMITE 4,5,1
 *       @ 06, 52 prompt "Alteracao" HIGHLITE R/BG PERMITE 4,5,2
 *       @ 07, 52 prompt "Consultas" HIGHLITE R/BG PERMITE 4,5,3
 *       @ 08, 52 prompt "Exclusao " HIGHLITE R/BG PERMITE 4,5,4
 *       @ 09, 52 prompt "Listagens" HIGHLITE R/BG PERMITE 4,5,5
 *       @ 10, 52 prompt "Outros   " HIGHLITE R/BG PERMITE 4,5,6
 *       @ 11, 52 prompt "Liberacao" HIGHLITE R/BG PERMITE 4,5,5


      do case
         case M_OPC = 1 ; incche()
         case M_OPC = 2 ; altche(.t.)   
         case M_OPC = 3 
*               @ 09, 58 prompt "Cheque    " HIGHLITE R/BG
*               @ 10, 58 prompt "Fornecedor" HIGHLITE R/BG
           do case
              case M_OPC1 = 1 ; conche()
              case M_OPC1 = 2 ; concfor()
           endcase
         case M_OPC = 4 ; excche()   
         case M_OPC = 5 ; lische()   
         case M_OPC = 6 ; outche(M_OPC1)
         case M_OPC = 7 ; altche(.f.)
      endcase

    fecha_arq()

return ""

***************  
function INCCHE          && inclui cheques
***************  

private M_OPC

        M_CHEEMP   = ME_EMP
        M_CHEDTA   = date()             && ctod("  /   /  ")
        M_CHECTA   = space(13)

        M_CHENUM   = 0
        M_CHEDTE   = ctod("  /  /  ")
        M_CHEVCT   = ctod("  /  /  ")

        for ABC = 1 TO 12
          MS = strzero(ABC,2)
          M_CHEDUP&MS = 0
          M_CHEORD&MS = 0
          M_CHEFOR&MS = 0
        next

        M_CHEAPL = 0
        M_CHEPOR  = space(39)
        M_CHEPOR1 = space(39)
        M_CHEOBS = space(65)
        M_CHEVLR = 0
        M_CHEIPL = " "

    do while .t.

      tlche01()                         && monta tela inicial

      save get to M_G1
      edche01(.f.)  // somente para montar a tela
      restore get from M_G1

      rodape("INCLUI","CHEQUES",M_FAN,"EAGRO54","Mem: " + str(memory(0), 5),M_EMP)

      SetColor(_COREDICAO_)
      @ 09, 27 get     M_CHECTA picture "@!" valid verconta(@M_CHECTA)
      read

      if lastkey() = 27 .or. empty(M_CHECTA)
        exit
      endif        

      if !BUSCAREGISTRO("ACTA00",1,{str(M_CHEEMP, 2, 0),aspas(M_CHECTA)},"SELECT")
        msg("* * * CONTA NAO CADASTRADA * * *")
        loop
      endif

      set color to I
        @ 09, 41 say pad(CTAAGE, 25)
      set color to 

      do while .t.

        save get to M_G1
        edche01(.f.)
        restore get from M_G1

        M_CHENUM   = ACTA00->CTACHE + 1
        M_CHEDTE   = date()   && ctod("  /  /  ")   
        M_CHEVCT   = date()   && ctod("  /  /  ") 

        for ABC = 1 TO 12
          MS = strzero(ABC,2)
          M_CHEDUP&MS = 0
          M_CHEORD&MS = 0
          M_CHEFOR&MS = 0
        next

        M_CHEAPL = 0
        M_CHEPOR  = space(39)
        M_CHEPOR1 = space(39)
        M_CHEOBS = space(65)
        M_CHEVLR = 0
        M_CHEIPL = " "

        SetColor(_COREDICAO_)
        @ 11, 27 get  M_CHENUM picture "######"
        read

        if M_CHENUM = 0 .or. lastkey() = 27
          exit
        endif

        if BUSCAREGISTRO("ACHE00",1,{str(M_CHEEMP, 2, 0),aspas(M_CHECTA),str(M_CHENUM, 6, 0)},"SELECT")
          msg("* * * CHEQUE JA CADASTRADO * * *")
          loop
        endif

        edche01()

        if lastkey() = 27
          msg("* * * CHEQUE NAO INCLUIDO * * *")
          loop
        endif

        grche01("INSERT")                      && grava plano de contas

        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {"ACTA00","UPDATE"}
        aadd(sqlCHAVE,{"CTAEMP",str(M_CHEEMP,2)})
        aadd(sqlCHAVE,{"CTACTA",aspas(M_CHECTA)})
        aadd(sqlCAMPO,{"CTACHE",str(M_CHENUM),.t.})
        executasql()

        msg("* * * CHEQUE INCLUIDO * * *")

        lpche01()

     enddo

  enddo

return ""

***************  
function ALTCHE(TIPO)          && altera cheques
***************  

private M_OPC

        M_CHEEMP   = ME_EMP
        M_CHEDTA   = ctod("  /   /  ")
        M_CHECTA   = space(13)

    do while .t.

      tlche01()                         && monta tela inicial 
                                                             
      rodape(iif(TIPO,"ALTERA","LIBERA"),"CHEQUES",M_FAN,"EAGRO54","Mem: " + str(memory(0), 5),M_EMP) 

      SetColor(_COREDICAO_)
      @ 09, 27 get     M_CHECTA picture "@!"  valid verconta(@M_CHECTA)
      read

      if lastkey() = 27 .or. empty(M_CHECTA)
         exit
      endif        

      select ACTA00

      if !dbseek(str(M_CHEEMP, 2, 0) + M_CHECTA)
        msg("* * * CONTA NAO CADASTRADA * * *")
        loop
      endif

      set color to I
        @ 09, 41 say pad(CTAAGE, 25)
      set color to 

      do while .t.

        lpche01()

        M_CHENUM = 0

        SetColor(_COREDICAO_)
        @ 11, 27 get  M_CHENUM picture "######"
        read

        if M_CHENUM = 0 .or. lastkey() = 27
          exit
        endif

        select ACHE00

        if !dbseek(str(M_CHEEMP, 2, 0) + M_CHECTA + str(M_CHENUM, 6, 0))
          msg("* * * CHEQUE NAO CADASTRADO * * *")
          loop
        endif
        
        if !rlock()
          msg("* * * (ACHE00) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_CHEDTE  = CHEDTE
        M_CHEVCT  = CHEVCT
        M_CHEDUP01 = CHEDUP01
        M_CHEORD01 = CHEORD01
        M_CHEDUP02 = CHEDUP02
        M_CHEORD02 = CHEORD02
        M_CHEDUP03 = CHEDUP03
        M_CHEORD03 = CHEORD03
        M_CHEDUP04 = CHEDUP04
        M_CHEORD04 = CHEORD04
        M_CHEDUP05 = CHEDUP05
        M_CHEORD05 = CHEORD05
        M_CHEDUP06 = CHEDUP06
        M_CHEORD06 = CHEORD06
        M_CHEDUP07 = CHEDUP07
        M_CHEORD07 = CHEORD07
        M_CHEDUP08 = CHEDUP08
        M_CHEORD08 = CHEORD08

        M_CHEDUP09 = CHEDUP09
        M_CHEORD09 = CHEORD09
        M_CHEDUP10 = CHEDUP10
        M_CHEORD10 = CHEORD10
        M_CHEDUP11 = CHEDUP11
        M_CHEORD11 = CHEORD11
        M_CHEDUP12 = CHEDUP12
        M_CHEORD12 = CHEORD12

        M_CHEAPL = CHEAPL
        M_CHEPOR = CHEPOR
        M_CHEOBS = CHEOBS
        M_CHEVLR = CHEVLR
        M_CHEIPL = CHEIPL

        if TIPO // SE ESTIVER ALTERANDO
          edche01()

          if lastkey() = 27
            msg("* * * CHEQUE NAO ALTERADO * * *")
            loop
          endif

          grche01()                      && grava plano de contas

          msg("* * * CHEQUE ALTERADO * * *")
        else
          msche01()
          M_DEC = decide("Confirma liberacao para nova emissao")
          if M_DEC = 1
            do while .t. 
              if rlock()                   
                replace CHEIPL   with   "R"
                unlock
                commit 
                exit 
              else
                msg("* * * (ACHE00) REGISTRO SENDO USADO * * *")
              endif
              if lastkey()=17
                exit
              endif
            enddo
          endif
          msg("* * * CHEQUE LIBERADO * * *")
        endif

        lpche01()

     enddo

     unlock all

  enddo

return ""

***************  
function CONCHE          && consulta cheques
***************  

private M_OPC

        M_CHEEMP   = ME_EMP
        M_CHEDTA   = ctod("  /   /  ")
        M_CHECTA   = space(13)

    do while .t.

      tlche01()                         && monta tela inicial 
                                                             
      rodape("CONSULTA","CHEQUES",M_FAN,"EAGRO54","Mem: " + str(memory(0), 5),M_EMP) 

      SetColor(_COREDICAO_)
      @ 09, 27 get     M_CHECTA picture "@!"  valid verconta(@M_CHECTA)
      read

      if lastkey() = 27 .or. empty(M_CHECTA)
         exit
      endif        

      if !BUSCAREGISTRO("ACTA00",1,{str(M_CHEEMP, 2, 0),aspas(M_CHECTA)},"SELECT")
        msg("* * * CONTA NAO CADASTRADA * * *")
        loop
      endif

      set color to I
        @ 09, 41 say pad(CTAAGE, 25)
      set color to 

      M_CHENUM = 0

      SetColor(_COREDICAO_)
      @ 11, 27 get  M_CHENUM picture "######"
      read

      if M_CHENUM = 0 .or. lastkey() = 27
        exit
      endif

      if !BUSCAREGISTRO("ACHE00",1,{str(M_CHEEMP, 2, 0),aspas(M_CHECTA),str(M_CHENUM, 6, 0)},"SELECT")
        msgbox1("CHEQUE NAO CADASTRADO")
        loop
      endif

*      do while .t.
        save get to M_G1
        msche01()
        restore get from M_G1

        inkey(0)

 *       if lastkey() = 5
 *          skip - 1
 *       endif

 *       if lastkey() = 24
 *         skip
 *       endif

 *       if lastkey() = 27
 *         exit
 *       endif

  *    enddo

      set cursor on

*    msg("* * * FIM DA CONTA * * *")

  enddo

return ""

****************  
function CONCFOR          && consulta cheques
****************  

private M_OPC

        M_CHEEMP   = ME_EMP
        M_PER1 := M_PER2 := ctod("  /   /  ")
        M_CHECTA   = space(13)
        M_NFEFOR   = space(40)

    do while .t.

      tlche02()                         && monta tela inicial 
                                                             
      rodape("CONSULTA","CHEQUES",M_FAN,"EAGRO54","Mem: " + str(memory(0), 5),M_EMP) 

      SetColor(_COREDICAO_)
      @ 06, 23 get   M_NFEFOR picture "@!"
      @ 07, 31 get   M_PER1
      @ 07, 44 get   M_PER2
      read

      if lastkey() = 27
         exit
      endif        

      M_PER1 = iif(empty(M_PER1),ctod("01/01/1990"),M_PER1)
      M_PER2 = iif(empty(M_PER2),ctod("31/12/2099"),M_PER2)

      select ACHE00
      set order to 3
      dbseek(str(M_CHEEMP, 2, 0) + dtos(M_PER1),.t.)

      M_CHEQUE = { }
      M_CHEDUP = { }

      do while !eof()
        if str(CHEEMP, 2, 0) + dtos(CHEDTE) > str(ME_EMP, 2, 0) + dtos(M_PER2)
          exit
        endif
        msw("* * * PROCESSANDO CHEQUE " + str(CHENUM,6) + " !!! * * *")
        if alltrim(M_NFEFOR) == left(CHEPOR,LEN(alltrim(M_NFEFOR)))
          ACTA00->(dbseek(str(ME_EMP, 2, 0) + ACHE00->CHECTA))
          aadd(M_CHEQUE,pad(ACTA00->CTAAGE,30) + "³" + str(ACHE00->CHENUM,6) + "³" + transform(ACHE00->CHEVLR,"@R 999,999.99") + "³" + dtoc(ACHE00->CHEDTE) + str(ACHE00->(recno()),7))
          aadd(M_CHEDUP,0)
        else 
          for A = 1 TO 12
            MS = strzero(A,2)
            if ACHE00->CHEDUP&MS > 0
              select ADCP00
              set order to 1
              if dbseek(str(ME_EMP, 2, 0) + str(ACHE00->CHEDUP&MS, 6, 0) + str(ACHE00->CHEORD&MS, 2, 0))
                AFOR00->(dbseek(str(ADCP00->DUPFOR, 7, 0)))
                if alltrim(M_NFEFOR) == left(AFOR00->FORNOM,LEN(alltrim(M_NFEFOR)))
                  ACTA00->(dbseek(str(ME_EMP, 2, 0) + ACHE00->CHECTA))
                  aadd(M_CHEQUE,pad(ACTA00->CTAAGE,30) + "³" + str(ACHE00->CHENUM,6) + "³" + transform(ACHE00->CHEVLR,"@R 999,999.99") + "³" + dtoc(ACHE00->CHEDTE) + str(ACHE00->(recno()),7))
                  aadd(M_CHEDUP,A)
                endif             
              endif
            endif 
          next  
        endif
        select ACHE00
        skip  
      enddo

      setcolor("N/W,W+/N")
      achoice(11,11,20,69,M_CHEQUE,,"moschq")
      setcolor("")

  enddo

return ""

***************
function MOSCHQ
***************

parameters  M_MODO, M_ELEM, M_POSI

 if rat(str(lastkey(), 2, 0),"27") > 0
    return 0
 endif

 if rat(str(lastkey(), 2, 0),"13") > 0
   select ACHE00
   go val(right(M_CHEQUE[M_ELEM],7))
   lTela = savescreen(08, 12, 21, 68)
   tlche01(.t.)   && monta tela inicial
   msche01(M_CHEDUP[M_ELEM])
   msg("* * * PRESSIONE QUALQUER TECLA * * *")
   restscreen(08, 12, 21, 68,lTela)
   setcolor("N/W,W+/N")
   return 2
 endif

return 2

***************  
function EXCCHE          && altera cheques
***************  

private M_OPC

    M_CHEEMP   = ME_EMP
    M_CHEDTA   = ctod("  /   /  ")
    M_CHECTA   = space(13)

    do while .t.

      tlche01()                         && monta tela inicial 
                                                             
      rodape("EXCLUSAO","CHEQUES",M_FAN,"EAGRO54","Mem: " + str(memory(0), 5),M_EMP) 

      SetColor(_COREDICAO_)
      @ 09, 27 get     M_CHECTA picture "@!"  valid verconta(@M_CHECTA)
      read

      if lastkey() = 27 .or. empty(M_CHECTA)
         exit
      endif        

      select ACTA00

      if !dbseek(str(M_CHEEMP, 2, 0) + M_CHECTA)
        msg("* * * CONTA NAO CADASTRADA * * *")
        loop
      endif

      set color to I
        @ 09, 41 say pad(CTAAGE, 25)
      set color to 

      do while .t.

        lpche01()

        M_CHENUM = 0

        SetColor(_COREDICAO_)
        @ 11, 27 get  M_CHENUM picture "######"
        read

        if M_CHENUM = 0 .or. lastkey() = 27
          exit
        endif

        select ACHE00

        if !dbseek(str(M_CHEEMP, 2, 0) + M_CHECTA + str(M_CHENUM, 6, 0))
          msg("* * * CHEQUE NAO CADASTRADO * * *")
          loop
        endif
        
        msche01()

        if !rlock()
          msg("* * * (ACHE00) REGISTRO SENDO USADO * * *")
          loop
        endif

        set color to GR+
          @ 24, 18 say "Confirma Exclusao deste Cheque ? (Sim) (Nao)"
          store 2 to M_OPC
          @ 24, 52 prompt "Sim"
          @ 24, 58 prompt "Nao"
          menu to M_OPC
        set color to 

        @ 24, 00 clear

        if M_OPC = 2 .or. lastkey() = 27
          msg("* * * CHEQUE NAO EXCLUIDO * * *")
          unlock
          loop
        endif

        for ZZ = 1 to 12
          MS = strzero(ZZ,2)
          select ACHE00 
          if CHEDUP&MS > 0
            select ADCP00
            if dbseek(str(ME_EMP, 2, 0) + str(ACHE00->CHEDUP&MS, 6, 0) + str(ACHE00->CHEORD&MS, 2, 0))
              do while .t.
                if rlock()
                  replace DUPVLA with DUPVLO
                  replace DUPVLP with 0
                  replace DUPDTP with ctod("  /  /  ")
                  replace DUPHIS with 500
                  exit
                endif
              enddo
            endif
            select ALCP00
            if dbseek(str(ME_EMP, 2, 0) + str(ACHE00->CHEDUP&MS, 6, 0) + str(ACHE00->CHEORD&MS, 2, 0) + str(100, 3, 0))
              elimina()
            endif
          endif
        next
       
        select ACHE00
        elimina()

        msg("* * * CHEQUE EXCLUIDO * * *")

        lpche01()

     enddo

     unlock all

  enddo

return ""

***************
function LISCHE
*************** 
 
    do while .t.

      rodape("LISTA","CHEQUE",M_FAN,"EAGRO54","Mem: " + str(memory(0), 5),M_EMP) 

      store space(13) to M_CTAINI ,;
                         M_CTAFIN
      store 0         to M_CHEINI ,;
                         M_CHEFIN

      store 0         to PG, LN , M_TOTCHE

      sombra(10, 27, 15, 53,_SOMBRA_)

      set color to GR+/W+
        @ 10, 27 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
        @ 11, 27 say "³  Conta de:              ³" 
        @ 12, 27 say "³       Ate:              ³" 
        @ 13, 27 say "³ Cheque de:              ³" 
        @ 14, 27 say "³       Ate:              ³" 
        @ 15, 27 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
        SetColor(_COREDICAO_)
      @ 11, 40 get M_CTAINI picture "@!"     valid verconta(@M_CTAINI)
      @ 13, 40 get M_CHEINI picture "######"
      @ 14, 40 get M_CHEFIN picture "######"
      read

      if lastkey() = 27
        return ""
      endif

      M_CTAINI = iif(empty(M_CTAINI),"0            ",M_CTAINI)
      M_CTAFIN = iif(empty(M_CTAFIN),"9999999999999",M_CTAFIN) 
      M_CHEINI = iif(M_CHEINI=0,1     ,M_CHEINI)
      M_CHEFIN = iif(M_CHEFIN=0,999999,M_CHEFIN) 

      select ACTA00

      go top

      set softseek on
        seek str(ME_EMP, 2, 0) + M_CTAINI
      set softseek off

      if str(CTAEMP, 2, 0) + CTACTA > str(ME_EMP, 2, 0) + M_CTAFIN
        msg("* * * NADA A LISTAR NO INTERVALO * * *")
        loop
      endif

      M_IMPRE = impresn()

      if M_IMPRE = "N"
        loop
      endif

      if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
        ?? chr(15)                        && comprime
      endif

      cbche01()                           && cabecalho      

      do while !eof()

        if str(CTAEMP, 2, 0) + CTACTA  > str(ME_EMP, 2, 0) + M_CTAFIN 
          go bottom
          skip
          loop
        endif 

        select ACHE00

        set softseek on
          seek str(ACTA00->CTAEMP, 2, 0) + ACTA00->CTACTA 
        set softseek off

        if !str(CHEEMP, 2, 0) + CHECTA == str(ACTA00->CTAEMP, 2, 0) + ACTA00->CTACTA
          select ACTA00
          skip
          loop
        endif 
       
        if M_TOTCHE > 0
          ? space(86)
           ?? "TOTAL DE CHEQUES ..........   "
           ?? transform(M_TOTCHE,"@E ####,###,###.##")
          ? replicate("-", 132)
          LN = LN + 2
          M_TOTCHE = 0
          if LN > 60
            cbche01()
          endif
        endif

        ? " "        
          ?? ACTA00->CTACTA
          ?? " "
          ?? ACTA00->CTAAGE

          LN = LN + 1
 
          if LN > 60
            cbche01()
          endif
       
        do while !eof() 

          if !str(CHEEMP, 2, 0) + CHECTA == str(ACTA00->CTAEMP, 2, 0) + ACTA00->CTACTA
            exit
          endif 

          if CHENUM < M_CHEINI .or. CHENUM > M_CHEFIN
            skip
            loop
          endif
          
          ? space(15)
            ?? str(CHENUM, 6, 0)
            ?? " "
            ?? str(CHEAPL, 3, 0)
            ?? " "
            ?? CHEDTE
            ?? " "
            ?? CHEVCT
            ?? " "
            ?? " "
            ?? " "
            ?? CHEIPL
            ?? " "
            ?? CHEPOR
            ?? " "
            ?? pad(CHEOBS, 28)
            ?? " "
            ?? transform(CHEVLR,"@E ###,###,###.##")

            M_TOTCHE = M_TOTCHE + CHEVLR

            LN = LN + 1
 
            if LN > 60
              cbche01()
            endif

            M_ESC = inkey()

            if M_ESC = 27
              if susimp()
                ? replicate("-", 132)
                ? "* * * IMPRESSAO SUSPENSA * * *"
                select ACTA00 
                go bottom
                skip
                select ACHE00
                go bottom
                skip
                loop
              else
                M_ESC = inkey()
              endif
            endif

            skip

        enddo

        select ACTA00

        skip

    enddo

    ? space(86)
      ?? "TOTAL DE CHEQUES ..........   "
      ?? transform(M_TOTCHE,"@E ####,###,###.##")
    ? replicate("-", 132)

    eject

desliga1()

enddo 

return "" 

***************
function OUTCHE
***************
parameters M_OPC,M_OPC1,M_OPC2


      rodape("OUTROS","CHEQUES",M_FAN,"EAGRO54","Mem: " + str(memory(0), 5),M_EMP) 
*        @ 10, 58 prompt "Emissao   " HIGHLITE R/BG
*        @ 11, 58 prompt "Copia     " HIGHLITE R/BG
*        @ 12, 58 prompt "Eliminar  " POSITION 2 HIGHLITE R/BG

      do case
         case M_OPC = 1
              emiche()  
         case M_OPC = 2
              copche()   
         case M_OPC = 3
              eliche()     
      endcase

return ""

***************
function EMICHE
*************** 

private M_TELA ,;
        M_OPC  

declare VAL_EXT[ 3] 

declare MAT_MES[12]

MAT_MES [  1 ] = "Janeiro  "
MAT_MES [  2 ] = "Fevereiro"
MAT_MES [  3 ] = "Marco    "
MAT_MES [  4 ] = "Abril    "
MAT_MES [  5 ] = "Maio     "
MAT_MES [  6 ] = "Junho    "
MAT_MES [  7 ] = "Julho    "
MAT_MES [  8 ] = "Agosto   "
MAT_MES [  9 ] = "Setembro "
MAT_MES [ 10 ] = "Outubro  "
MAT_MES [ 11 ] = "Novembro "
MAT_MES [ 12 ] = "Dezembro "
 
    rodape("EMITE","CHEQUE",M_FAN,"EAGRO54","Mem: " + str(memory(0), 5),M_EMP)

    store space(13) to M_CHECTA

    store 0         to M_CHEINI ,;
                       M_CHEFIN

    nbox(15, 30, 19, 55,"W/W+",.t.)
    setcolor("B/W")
     @ 16, 31 say           "    Conta:              "
     @ 17, 31 say           "Cheque de:              "
     @ 18, 31 say           "      Ate:              "

      SetColor(_COREDICAO_)
      @ 16, 42 get M_CHECTA picture "@!" valid verconta(@M_CHECTA)
      @ 17, 42 get M_CHEINI picture "######"
      @ 18, 42 get M_CHEFIN picture "######"
      read

      if lastkey() = 27
        return ""
      endif

      M_CHEINI = iif(M_CHEINI=0,1     ,M_CHEINI)
      M_CHEFIN = iif(M_CHEFIN=0,999999,M_CHEFIN) 

      if !BUSCAREGISTRO("ACTA00",1,{str(ME_EMP, 2, 0),aspas(M_CHECTA)},"SELECT")
        msg("* * * CONTA NAO CADASTRADA * * *")
        return ""
      endif

      if !BUSCAREGISTRO("APCH00",1,{str(ACTA00->CTABAN, 3, 0)},"SELECT")
        msg("* * * PARAMETROS NAO CADASTRADO * * *")
        return ""
      endif

      sqlRELATION = {}
      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {}
      sqlORDEM = {}

      aadd(sqlARQUI,{"ACHE00","ACHE00"})
      aadd(sqlCAMPO,"ACHE00.*")
      aadd(sqlCHAVE,"CHENUM BETWEEN " + str(M_CHEINI,6) + " and " + str(M_CHEFIN,6))
      aadd(sqlCHAVE,"CHEEMP = " + str(ME_EMP,2))
      aadd(sqlCHAVE,"CHECTA = " + aspas(M_CHECTA))
      aadd(sqlCHAVE,"CHEIPL <> 'I'")

      if !sqlrelation()
        msg("* * * NAO HA CHEQUE A EMITIR * * *")
        return ""
      endif

      M_IMPRE = impresn()

      if M_IMPRE = "N"
        return ""
      endif

      ?? chr(18)
      ?? chr(27) + "2"

      if APCH00->PCHPL1 = "X"
        ?? chr(27) + "0" 
      endif

      ?? chr(27) + "x" + "1"
     
      do while !eof()

        if ACTA00->CTABAN  = 1
          emisila()
        else
          eminor()
        endif

           if inkey() = 27
             if susimp()
               select ACHE00
               go bottom
               skip
               loop
             endif
           endif

           if !CHEIPL == "R"
             grava_lab()    && grava lancamento bancario  */
             baixa_dcp()    && baixa duplicata a pagar
           endif

            sqlCAMPO = {}
            sqlCHAVE =  {}
            sqlARQUI = {"ACHE00","UPDATE"}
            aadd(sqlCHAVE,{"CHEEMP",str(ACHE00->CHEEMP,2)})
            aadd(sqlCHAVE,{"CHENUM",str(ACHE00->CHENUM,6)})
            aadd(sqlCHAVE,{"CHECTA",aspas(ACHE00->CHECTA)})
            aadd(sqlCAMPO,{"CHEIPL","I",.t.})
            executasql()

            select ACHE00

            skip

        enddo

  desliga1()

return ""

***************
function EMINOR
***************

 extenso(CHEVLR, VAL_EXT, 53)          

   for R=1 to APCH00->PCHET1
     ?
   next

       ?? space(APCH00->PCHMA1)
       ?? replicate("#",(14-len(alltrim(transform(CHEVLR,"@E ###,###,###.##")))))
       ?? alltrim(transform(CHEVLR,"@E ###,###,###.##"))
       ?

          for R=1 to APCH00->PCHET2
            ?
          next

          ? space(APCH00->PCHMA2)
          ?? rtrim(VAL_EXT[ 1 ])
            if !empty(VAL_EXT[1])
              ?? replicate("*",(53 - len(rtrim(VAL_EXT[1]))))
            endif

          for R=1 to APCH00->PCHET3
            ? iif(ACTA00->CTABAN=1,space(5) + substr(CHEPOR, 13, 12) ,"")
          next 

          ? space(APCH00->PCHMA3)
            ?? rtrim(VAL_EXT[ 2 ])
            if !empty(VAL_EXT[2])
              ?? replicate("*",(53 - len(rtrim(VAL_EXT[2]))))
            endif

          for R=1 to APCH00->PCHET4
            ?
          next 

          ? space(APCH00->PCHMA4)
            ?? CHEPOR

          for R=1 to APCH00->PCHET5
            ?
          next 

           ? space(APCH00->PCHMA5) 
             ?? ACTA00->CTAMUN
             ?? space(APCH00->PCHES1)
             ?? str(day(CHEDTE), 2, 0)
             ?? space(APCH00->PCHES2)
             ?? MAT_MES[month(CHEDTE)]
             ?? space(APCH00->PCHES3)
             ?? year(CHEDTE)

           for R = 1 to APCH00->PCHET6
             ?
           next

return ""

***************
function EMISILA
***************

 extenso(CHEVLR, VAL_EXT, 53)          

       ?? space(66)
       ?? replicate("#",(14-len(alltrim(transform(CHEVLR,"@E ###,###,###.##")))))
       ?? alltrim(transform(CHEVLR,"@E ###,###,###.##"))

       ?
 
       ? space(01)
         ?? substr(CHEPOR, 1, 12)
       ? space(01)
          ?? substr(CHEPOR, 13, 12)
          ?? space(10)
          ?? rtrim(VAL_EXT[ 1 ])
            if !empty(VAL_EXT[1])
              ?? replicate("*",(53 - len(rtrim(VAL_EXT[1]))))
            endif

       ? space(01)
          ?? substr(CHEPOR, 25, 12)

       ? space(23)
            ?? rtrim(VAL_EXT[ 2 ])
            if !empty(VAL_EXT[2])
              ?? replicate("*",(53 - len(rtrim(VAL_EXT[2]))))
            endif

       ? space(04)
         ?? CHEVCT
 
       ?

       ? space(19)
         ?? CHEPOR

       ?

       ? space(40) 
         ?? ACTA00->CTAMUN
         ?? space(APCH00->PCHES1)
         ?? str(day(CHEDTE), 2, 0)
         ?? space(APCH00->PCHES2)
         ?? MAT_MES[month(CHEDTE)]
         ?? space(APCH00->PCHES3)
         ?? right(dtoc(CHEDTE), 2)

        ?
        ?
        ?
        ?
        ?
        ?
        ?
        ? 
          ?? replicate("#",(13-len(alltrim(transform(CHEVLR,"@E ##,###,###.##")))))
          ?? alltrim(transform(CHEVLR,"@E ##,###,###.##"))

        ?
        ?
        ?
        ?
        ?
        ? 

return ""

***************
function EMICOP
***************

 extenso(CHEVLR, VAL_EXT, 53)          

   M_TOTDUP = 0

       if PG > 0
         ?
         ? "  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  "
         ?
       endif


       ? space(10)
       ?? "COPIA DO CHEQUE: "
       ?? chr(27) + "E"
       ?? str(CHENUM, 6, 0)
       ?? chr(27) + "F"
       ?? " Conta: "
       ?? pad(CHECTA, 13)
       ?? space(06)
       ?? chr(27) + "E"
       ?? replicate("#",(14-len(alltrim(transform(CHEVLR,"@E ###,###,###.##")))))
       ?? alltrim(transform(CHEVLR,"@E ###,###,###.##"))
       ?? chr(27) + "F"

       ?

          ? space(20)
          ?? rtrim(VAL_EXT[ 1 ])
            if !empty(VAL_EXT[1])
              ?? replicate("*",(53 - len(rtrim(VAL_EXT[1]))))
            endif

          ?

          ? space(20)
            ?? rtrim(VAL_EXT[ 2 ])
            if !empty(VAL_EXT[2])
              ?? replicate("*",(53 - len(rtrim(VAL_EXT[2]))))
            endif

          ?

          ? space(20)
            ?? CHEPOR

          ?

           ? space(31)
             ?? ACTA00->CTAMUN
             ?? space(05)
             ?? str(day(CHEDTE), 2, 0)
             ?? space(05)
             ?? MAT_MES[month(CHEDTE)]
             ?? space(05)
             ?? right(dtoc(CHEDTE), 2)

           ?

           ? "+---------+----------+--------------------------------+--------+--------------+"
           ? "|DUPLICATA|  NUMERO  |       CLIENTE/FORNECEDOR       |  VCTO  |    VALOR     |"
           ? "+---------+----------+--------------------------------+--------+--------------+"
*              999999/99 XXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 ###,###,###.## 

           LN = 0

           for R = 1 to 12
             S = strzero(R, 2, 0)
             if CHEDUP&S = 0
               loop
             endif

            sqlRELATION = {}
            sqlCAMPO = {}
            sqlCHAVE =  {}
            sqlARQUI = {}
            sqlORDEM = {}

            aadd(sqlARQUI,{"ADCP00","ADCP00"})
            aadd(sqlCAMPO,"ADCP00.DUPOBS")
            aadd(sqlCAMPO,"ADCP00.DUPVCT")
            aadd(sqlCAMPO,"ADCP00.DUPVLO")
            aadd(sqlCAMPO,"AFOR00.FORNOM")
            aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","ADCP00.DUPFOR"})
            aadd(sqlCHAVE,"DUPEMP =  " + str(ME_EMP, 2))
            aadd(sqlCHAVE,"DUPNUM =  " + str(ACHE00->CHEDUP&S, 9))
            aadd(sqlCHAVE,"DUPORD =  " + str(ACHE00->CHEORD&S, 2))
            aadd(sqlCHAVE,"DUPFOR =  " + str(ACHE00->CHEFOR&S, 5))
            sqlrelation()

            select ACHE00

             ? "|"
               ?? str(CHEDUP&S, 6, 0)
               ?? "/"
               ?? strzero(CHEORD&S, 2, 0)
               ?? " "
               ?? pad(DUPOBS, 10)
               ?? " "
               ?? pad(FORNOM, 32)
               ?? " "
               ?? DUPVCT
               ?? " "
               ?? transform(DUPVLO,"@E ###,###,###.##")
               ?? "|"
               LN = LN + 1
               M_TOTDUP = M_TOTDUP + DUPVLO
           next
           
           for R = LN to 09
             ? "|                                                                             |"              
           next         
           ? "|                                              T  O  T  A  L ..."
               ?? transform(M_TOTDUP,"@E ###,###,###.##")
               ?? "|"
           ? "+---------------------+----------------------------------------+--------------+"
           ? "|        BANCO        |              OBSERVACOES               |    VISTO     |"
           ? "+---------------------+----------------------------------------+--------------+"           
           ? "|"
             ?? pad(ACTA00->CTAAGE, 21)
             ?? "|"
             ?? pad(ACHE00->CHEOBS, 40)
             ?? "|              |"
           ? "+---------------------+----------------------------------------+--------------+"           
           
           PG = PG + 1


           if PG > 1
             if !eof()
               PG = 0
               eject
             endif
           endif

return ""

***************
function ELICHE
*************** 

private M_TELA ,;
        M_OPC

      rodape("ELIMINA","CHEQUE",M_FAN,"EAGRO54","Mem: " + str(memory(0), 5),M_EMP)

      set color to GR+
        @ 24, 13 say "Confirma Eliminacao dos Cheques Emitidos ? (Sim) (Nao)"
        @ 24, 57 prompt "Sim"
        @ 24, 63 prompt "Nao"
        menu to M_OPC
      set color to 

      @ 24, 00 clear

      if M_OPC = 2 .or. lastkey() = 27
         msg("* * * NADA FOI EFETUADO * * *")  
         return ""
      endif 

      select ACHE00

      set order to 2

      do while .t.

        set softseek on
          seek str(ME_EMP, 2, 0) + "I"
        set softseek off

        if !str(CHEEMP, 2, 0) + CHEIPL == str(ME_EMP, 2, 0) + "I"
          exit
        endif
 
        msw("* * * ELIMINADO: " + CHECTA + " " + str(CHENUM, 6, 0) + " " + dtoc(CHEDTE) + " * * *")

        do while .t.
          if rlock()
            replace CHEEMP with 0
            replace CHECTA with space(13)
            replace CHENUM with 0
            replace CHEDTE with ctod("  /  /  ")
            replace CHEVCT with ctod("  /  /  ")
            replace CHEDUP01 with 0
            replace CHEORD01 with 0
            replace CHEDUP02 with 0
            replace CHEORD02 with 0
            replace CHEDUP03 with 0
            replace CHEORD03 with 0
            replace CHEDUP04 with 0
            replace CHEORD04 with 0
            replace CHEDUP05 with 0
            replace CHEORD05 with 0
            replace CHEDUP06 with 0
            replace CHEORD06 with 0
            replace CHEDUP07 with 0
            replace CHEORD07 with 0
            replace CHEDUP08 with 0
            replace CHEORD08 with 0
            replace CHEDUP09 with 0
            replace CHEORD09 with 0
            replace CHEDUP10 with 0
            replace CHEORD10 with 0
            replace CHEDUP11 with 0
            replace CHEORD11 with 0
            replace CHEDUP12 with 0
            replace CHEORD12 with 0

            replace CHEAPL with 0
            replace CHEPOR with space(39)
            replace CHEOBS with space(65)
            replace CHEVLR with 0
            replace CHEIPL with " "
            unlock   
            commit
            exit
          else
            msg("* * * (ACHE00) REGISTRO SENDO USADO * * *") 
          endif
          if lastkey()=17
            exit
          endif
        enddo

      enddo

      set order to 1

      msg("* * * FIM DO PROCESSAMENTO * * *")

return "" 

***************
function COPCHE
*************** 

private M_TELA ,;
        M_OPC  

declare VAL_EXT[ 3] 

declare MAT_MES[12]

MAT_MES [  1 ] = "Janeiro  "
MAT_MES [  2 ] = "Fevereiro"
MAT_MES [  3 ] = "Marco    "
MAT_MES [  4 ] = "Abril    "
MAT_MES [  5 ] = "Maio     "
MAT_MES [  6 ] = "Junho    "
MAT_MES [  7 ] = "Julho    "
MAT_MES [  8 ] = "Agosto   "
MAT_MES [  9 ] = "Setembro "
MAT_MES [ 10 ] = "Outubro  "
MAT_MES [ 11 ] = "Novembro "
MAT_MES [ 12 ] = "Dezembro "
 
    do while .t.

      rodape("EMITE","CHEQUE",M_FAN,"EAGRO54","Mem: " + str(memory(0), 5),M_EMP) 

      store space(13) to M_CHECTA
      store 0         to M_CHEINI ,;
                         M_CHEFIN


    sombra(15, 30, 19, 55,_SOMBRA_)
    set color to GR+/W+
     @ 15, 30 say           "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
     @ 16, 30 say           "³    Conta:              ³" 
     @ 17, 30 say           "³Cheque de:              ³" 
     @ 18, 30 say           "³      Ate:              ³" 
     @ 19, 30 say           "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
        SetColor(_COREDICAO_)

      @ 16, 42 get M_CHECTA picture "@!"   valid verconta(@M_CHECTA)
      @ 17, 42 get M_CHEINI picture "######"
      @ 18, 42 get M_CHEFIN picture "######"
      read

      if lastkey() = 27
        return ""
      endif

      M_CHEINI = iif(M_CHEINI=0,1     ,M_CHEINI)
      M_CHEFIN = iif(M_CHEFIN=0,999999,M_CHEFIN) 

      if !BUSCAREGISTRO("ACTA00",1,{str(M_CHEEMP, 2, 0),aspas(M_CHECTA)},"SELECT")
        msg("* * * CONTA NAO CADASTRADA * * *")
        loop
      endif

      select APCH00
      if !BUSCAREGISTRO("APCH00",1,{str(ACTA00->CTABAN, 3, 0)},"SELECT")
        msg("* * * PARAMETROS NAO CADASTRADO * * *")
        loop
      endif

      sqlRELATION = {}
      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {}
      sqlORDEM = {}

      aadd(sqlARQUI,{"ACHE00","ACHE00"})
      aadd(sqlCAMPO,"ACHE00.*")
      aadd(sqlCHAVE,"CHENUM BETWEEN " + str(M_CHEINI,6) + " and " + str(M_CHEFIN,6))
      aadd(sqlCHAVE,"CHEEMP = " + str(ME_EMP,2))
      aadd(sqlORDEM,"CHECTA = " + aspas(M_CTAINI))
      if !sqlrelation()
        msg("* * * NAO HA CHEQUE A EMITIR * * *")
        loop
      endif

      M_IMPRE = impresn()

      if M_IMPRE = "N"
        loop
      endif

      LN = 0
      PG = 0

      do while !eof() 

        emicop()

        M_ESC = inkey()

        if M_ESC = 27
          if susimp()
            select ACHE00
            go bottom
            skip
            loop
          else
            M_ESC = inkey()
          endif
        endif

        skip

     enddo

    eject

desliga1()

enddo 

return "" 

****************
function CBCHE01
****************

store PG + 1 to PG

if PG > 1
  eject
endif

  ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE CHEQUES","EAGRO54",132) 
  ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
  ? "*-------------*------*---*--------*--------*-*-*---------------------------------------*----------------------------*--------------*"
  ? "*   CONTA     *CHEQUE*APL*EMISSAO *  VCTO  *T*S* P O R T A D O R                       *         OBSERVACAO         *   VALOR      *"
  ? "*-------------*------*---*--------*--------*-*-*---------------------------------------*----------------------------*--------------*"
*                   999999 999 99/99/99 99/99/99 P S XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXX ###,###,###.##  

  store 5 to LN

return ""

****************
function TLCHE01(TIPO)
****************

 nbox(08, 09, 21, 90,"W/W+",.t.)
 setcolor("B/W")
    @ 09, 10 say     " C o n t a  :                                                                    "
    @ 10, 10 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 11, 10 say     " Cheque Nro :                                                                    "
    @ 12, 10 say     " Emissao    :                    Vencto:                                         "
    @ 13, 10 say     " Portador   :                                                                    "
    @ 14, 10 say     "                                                                                 "
    @ 15, 10 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 16, 10 say     " Titulos    :       /                /                /                /         "
    @ 17, 10 say     "            :       /                /                /                /         "
    @ 18, 10 say     "            :       /                /                /                /         "
    @ 19, 10 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 20, 10 say     " Observacao :                    Valor:                                          "
  set color to

return ""

****************
function TLCHE02
****************

 nbox(05, 10, 21, 70,"W/W+",.t.)
 setcolor("B/W")
    @ 06, 11 say     "Fornecedor:                                                "
    @ 07, 11 say     "            Periodo            a                           "
    @ 08, 11 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ"
    @ 09, 11 say     "Conta                         ³Cheque³ Valor    ³ Data     "
    @ 10, 11 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ"
    @ 11, 11 say     "                              ³      ³          ³          "
    @ 12, 11 say     "                              ³      ³          ³          "
    @ 13, 11 say     "                              ³      ³          ³          "
    @ 14, 11 say     "                              ³      ³          ³          "
    @ 15, 11 say     "                              ³      ³          ³          "
    @ 16, 11 say     "                              ³      ³          ³          "
    @ 17, 11 say     "                              ³      ³          ³          "
    @ 18, 11 say     "                              ³      ³          ³          "
    @ 19, 11 say     "                              ³      ³          ³          "
    @ 20, 11 say     "                              ³      ³          ³          "
  set color to

return ""

****************
function EDCHE01(F_TIPO)
****************

if F_TIPO = NIL
  F_TIPO = .t.
endif

M_RETORNO = ""


  SetColor(_COREDICAO_)
*  @ 11, 54 get  M_CHEAPL picture "###"    valid verche02()
  @ 12, 27 get  M_CHEDTE                  valid(!empty(M_CHEDTE))
  @ 12, 54 get  M_CHEVCT                  valid verche04() 
  @ 13, 27 get  M_CHEPOR picture "@!"

  @ 16, 24 get M_CHEDUP01 picture "######" F2 color _CORF2_ funcao "verdupche(@M_CHEDUP01,@M_CHEORD01,@M_CHEFOR01)" retorno M_RETORNO
  @ 16, 31 get M_CHEORD01 picture "##"
  @ 16, 34 get M_CHEFOR01 picture "99999"  valid verche01(M_CHEDUP01,M_CHEORD01,M_CHEFOR01, 01)

  @ 16, 41 get M_CHEDUP02 picture "######" F2 color _CORF2_ funcao "verdupche(@M_CHEDUP02,@M_CHEORD02,@M_CHEFOR02)" retorno M_RETORNO
  @ 16, 48 get M_CHEORD02 picture "##"
  @ 16, 51 get M_CHEFOR02 picture "99999"  valid verche01(M_CHEDUP02,M_CHEORD02,M_CHEFOR02, 02)

  @ 16, 58 get M_CHEDUP03 picture "######" F2 color _CORF2_ funcao "verdupche(@M_CHEDUP03,@M_CHEORD03,@M_CHEFOR03)" retorno M_RETORNO
  @ 16, 65 get M_CHEORD03 picture "##"
  @ 16, 68 get M_CHEFOR03 picture "99999"  valid verche01(M_CHEDUP03,M_CHEORD03,M_CHEFOR03, 03)

  @ 16, 75 get M_CHEDUP04 picture "######" F2 color _CORF2_ funcao "verdupche(@M_CHEDUP04,@M_CHEORD04,@M_CHEFOR04)" retorno M_RETORNO
  @ 16, 82 get M_CHEORD04 picture "##"
  @ 16, 85 get M_CHEFOR04 picture "99999"  valid verche01(M_CHEDUP04,M_CHEORD04,M_CHEFOR04, 04)

  @ 17, 24 get M_CHEDUP05 picture "######" F2 color _CORF2_ funcao "verdupche(@M_CHEDUP05,@M_CHEORD05,@M_CHEFOR05)" retorno M_RETORNO
  @ 17, 31 get M_CHEORD05 picture "##"
  @ 17, 34 get M_CHEFOR05 picture "99999"  valid verche01(M_CHEDUP05,M_CHEORD05,M_CHEFOR05, 05)

  @ 17, 41 get M_CHEDUP06 picture "######" F2 color _CORF2_ funcao "verdupche(@M_CHEDUP06,@M_CHEORD06,@M_CHEFOR06)" retorno M_RETORNO
  @ 17, 48 get M_CHEORD06 picture "##"
  @ 17, 51 get M_CHEFOR06 picture "99999"  valid verche01(M_CHEDUP06,M_CHEORD06,M_CHEFOR06, 06)

  @ 17, 58 get M_CHEDUP07 picture "######" F2 color _CORF2_ funcao "verdupche(@M_CHEDUP07,@M_CHEORD07,@M_CHEFOR07)" retorno M_RETORNO
  @ 17, 65 get M_CHEORD07 picture "##"
  @ 17, 68 get M_CHEFOR07 picture "99999"  valid verche01(M_CHEDUP07,M_CHEORD07,M_CHEFOR07, 07)

  @ 17, 75 get M_CHEDUP08 picture "######" F2 color _CORF2_ funcao "verdupche(@M_CHEDUP08,@M_CHEORD08,@M_CHEFOR08)" retorno M_RETORNO
  @ 17, 82 get M_CHEORD08 picture "##"
  @ 17, 85 get M_CHEFOR08 picture "99999"  valid verche01(M_CHEDUP08,M_CHEORD08,M_CHEFOR08, 08)




  @ 18, 24 get M_CHEDUP09 picture "######" F2 color _CORF2_ funcao "verdupche(@M_CHEDUP09,@M_CHEORD09,@M_CHEFOR09)" retorno M_RETORNO
  @ 18, 31 get M_CHEORD09 picture "##"
  @ 18, 34 get M_CHEFOR09 picture "99999"  valid verche01(M_CHEDUP09,M_CHEORD09,M_CHEFOR09, 09)

  @ 18, 41 get M_CHEDUP10 picture "######" F2 color _CORF2_ funcao "verdupche(@M_CHEDUP10,@M_CHEORD10,@M_CHEFOR10)" retorno M_RETORNO
  @ 18, 48 get M_CHEORD10 picture "##"
  @ 18, 51 get M_CHEFOR10 picture "99999"  valid verche01(M_CHEDUP10,M_CHEORD10,M_CHEFOR10, 10)

  @ 18, 58 get M_CHEDUP11 picture "######" F2 color _CORF2_ funcao "verdupche(@M_CHEDUP11,@M_CHEORD11,@M_CHEFOR11)" retorno M_RETORNO
  @ 18, 65 get M_CHEORD11 picture "##"
  @ 18, 68 get M_CHEFOR11 picture "99999"  valid verche01(M_CHEDUP11,M_CHEORD11,M_CHEFOR11, 11)

  @ 18, 75 get M_CHEDUP12 picture "######" F2 color _CORF2_ funcao "verdupche(@M_CHEDUP12,@M_CHEORD12,@M_CHEFOR12)" retorno M_RETORNO
  @ 18, 82 get M_CHEORD12 picture "##"
  @ 18, 85 get M_CHEFOR12 picture "99999"  valid verche01(M_CHEDUP12,M_CHEORD12,M_CHEFOR12, 12)

  @ 20, 27 get  M_CHEOBS picture "@!@S18" valid verche07()
  @ 20, 54 get  M_CHEVLR picture "#########.##" valid(M_CHEVLR > 0)
  if F_TIPO
    read
  endif
  
return ""

****************
function MSCHE01(TIPO)
****************

 setcolor("N/W*")
  @ 11, 27 get CHENUM picture "######"
  @ 11, 54 get CHEAPL picture "###"
  @ 12, 27 get CHEDTE
  @ 12, 54 get CHEVCT

  @ 13, 27 get CHEPOR picture "@!@S20"

  @ 16, 24 get CHEDUP01 picture "######"
  @ 16, 31 get CHEORD01 picture "##"
  @ 16, 34 get CHEFOR01 picture "99999"

  @ 16, 41 get CHEDUP02 picture "######"
  @ 16, 48 get CHEORD02 picture "##"
  @ 16, 51 get CHEFOR02 picture "99999"

  @ 16, 58 get CHEDUP03 picture "######"
  @ 16, 65 get CHEORD03 picture "##"
  @ 16, 68 get CHEFOR03 picture "99999"

  @ 16, 75 get CHEDUP04 picture "######"
  @ 16, 82 get CHEORD04 picture "##"
  @ 16, 85 get CHEFOR04 picture "99999"

  @ 17, 24 get CHEDUP05 picture "######"
  @ 17, 31 get CHEORD05 picture "##"
  @ 17, 34 get CHEFOR05 picture "99999"

  @ 17, 41 get CHEDUP06 picture "######"
  @ 17, 48 get CHEORD06 picture "##"
  @ 17, 51 get CHEFOR06 picture "99999"

  @ 17, 58 get CHEDUP07 picture "######"
  @ 17, 65 get CHEORD07 picture "##"
  @ 17, 68 get CHEFOR07 picture "99999"

  @ 17, 75 get CHEDUP08 picture "######"
  @ 17, 82 get CHEORD08 picture "##"
  @ 17, 85 get CHEFOR08 picture "99999"

  @ 18, 24 get CHEDUP09 picture "######"
  @ 18, 31 get CHEORD09 picture "##"
  @ 18, 34 get CHEFOR09 picture "99999"

  @ 18, 41 get CHEDUP10 picture "######"
  @ 18, 48 get CHEORD10 picture "##"
  @ 18, 51 get CHEFOR10 picture "99999"

  @ 18, 58 get CHEDUP11 picture "######"
  @ 18, 65 get CHEORD11 picture "##"
  @ 18, 68 get CHEFOR11 picture "99999"

  @ 18, 75 get CHEDUP12 picture "######"
  @ 18, 82 get CHEORD12 picture "##"
  @ 18, 85 get CHEFOR12 picture "99999"

  @ 20, 24 get CHEOBS picture "@!@S18"
  @ 20, 54 get CHEVLR picture "#########.##"

set color to 

return ""

****************
function LPCHE01
****************

 setcolor("N/W*")
  @ 11, 54 say space(03)
  @ 12, 27 say space(08)       
  @ 12, 54 say space(08)       

  @ 13, 27 say space(20)
  @ 14, 54 say space(01)

  @ 16, 27 say space(06)
  @ 16, 34 say space(02)

  @ 16, 37 say space(06)
  @ 16, 44 say space(02)

  @ 16, 47 say space(06)
  @ 16, 54 say space(02)

  @ 16, 57 say space(06)
  @ 16, 64 say space(02)

  @ 17, 27 say space(06)
  @ 17, 34 say space(02)

  @ 17, 37 say space(06)
  @ 17, 44 say space(02)

  @ 17, 47 say space(06)
  @ 17, 54 say space(02)

  @ 17, 57 say space(06)
  @ 17, 64 say space(02)

  @ 18, 27 say space(06)
  @ 18, 34 say space(02)

  @ 18, 37 say space(06)
  @ 18, 44 say space(02)

  @ 18, 47 say space(06)
  @ 18, 54 say space(02)

  @ 18, 57 say space(06)
  @ 18, 64 say space(02)

  @ 20, 27 say space(18)
  @ 20, 54 say space(12)
set color to

return ""

*****************
function VERCHE01
*****************

parameters F_CHEDUP,F_CHEORD,F_CHEFOR,F_CHESEQ

if lastkey() = 5
  return .t.
endif

if F_CHEDUP = 0
  return .t.
endif

T = strzero(F_CHESEQ, 2, 0)

for R = 1 to 12
  S = strzero(R, 2, 0)
  if M_CHEDUP&S = 0 .or. F_CHESEQ = R
    loop
  endif
  if str(M_CHEDUP&S, 6, 0) +  str(M_CHEORD&S, 2, 0) == str(F_CHEDUP, 6, 0) +  str(F_CHEORD, 2, 0)
    msg("* * * TITULO JA DIGITADO * * *")
    M_CHEDUP&T = 0
    M_CHEORD&T = 0
    keyboard chr(05)
    return .f.
  endif
next

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ADCP00","ADCP00"})
  aadd(sqlCAMPO,"ADCP00.DUPHIS")
  aadd(sqlCAMPO,"ADCP00.DUPNOM")
  aadd(sqlCAMPO,"ADCP00.DUPVLA")
  aadd(sqlCAMPO,"ADCP00.DUPVCT")
  aadd(sqlCHAVE,"DUPEMP =  " + str(ME_EMP, 2))
  aadd(sqlCHAVE,"DUPNUM =  " + str(F_CHEDUP, 9))
  aadd(sqlCHAVE,"DUPORD =  " + str(F_CHEORD, 2))
  aadd(sqlCHAVE,"DUPFOR =  " + str(F_CHEFOR, 5))

  if !sqlrelation()
    msg("* * * TITULO NAO CADASTRADO * * *")
    return .f.
  endif

if DUPHIS = 100
  msg("* * * TITULO JA PAGO * * *")
  return .f.
endif

msg("* * * " + alltrim(DUPNOM) + " " + dtoc(DUPVCT) + " " + transform(DUPVLA,"@E ###,###,###.##") +  " * * *")

return .t.

*****************
function VERCHE02
*****************

if lastkey() = 5
  return .t.
endif

if M_CHEAPL = 0
  return .t.
endif

if !BUSCAREGISTRO("APLX00",1,{str(M_CHEEMP, 2, 0),str(M_CHEAPL, 3, 0)},"SELECT")
  msg("* * * APLICACAO NAO CADASTRADA * * *")
  return .f.
endif

msg("* * * " + alltrim(PLXNOM) + " * * *")

return .t.

*****************
function VERCHE04
*****************

if lastkey() = 5
  return .t.
endif

if empty(M_CHEVCT)
  return .f.
endif

return .t.

***************** 
function VERCONTA(FCONTA,FSEQ,FLACAO)
***************** 

  if lastkey() = 5
    return .t.
  endif 

  if empty(FCONTA)
    sele_arquivo("ACTA00")
    FCONTA = nCodRetorno
    return .f.
  endif

  if !BUSCAREGISTRO("ACTA00",1,{str(ME_EMP, 2, 0),aspas(FCONTA)},"SELECT")
    msg("* * * CONTA NAO CADASTRADA * * *")
    FCONTA = space(13)
    return .f.
  endif

  if !HB_ISNIL(FLACAO)
    FSEQ = ACTA00->CTASEQ + 1
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"ACTA00","UPDATE"}
    aadd(sqlCHAVE,{"CTAEMP",str(ME_EMP,2)})
    aadd(sqlCHAVE,{"CTACTA",aspas(M_LANCTA)})
    aadd(sqlCAMPO,{"CTASEQ",str(FSEQ),.t.})
    executasql()
  endif

return .t. 

*****************
function VERCHE07
***************** 

M_CHEVLR = 0

for R = 1 to 12
  S = strzero(R, 2, 0)
  if M_CHEDUP&S = 0
    loop
  endif
  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ADCP00","ADCP00"})
  aadd(sqlCAMPO,"ADCP00.DUPVLA")
  aadd(sqlCHAVE,"DUPEMP =  " + str(ME_EMP, 2))
  aadd(sqlCHAVE,"DUPNUM =  " + str(M_CHEDUP&S, 9))
  aadd(sqlCHAVE,"DUPORD =  " + str(M_CHEORD&S, 2))
  aadd(sqlCHAVE,"DUPFOR =  " + str(M_CHEFOR&S, 5))
  sqlrelation()
  M_CHEVLR = M_CHEVLR + ADCP00->DUPVLA
next

return .t. 

****************
function GRCHE01(cACAO)
****************
  sqlCAMPO = {}
  sqlCHAVE = {}
  sqlARQUI = {"ACHE00",(cACAO)}

  aadd(sqlCHAVE,{"CHEEMP",str(ME_EMP, 2)})
  aadd(sqlCHAVE,{"CHENUM",str(M_CHENUM, 6)})
  aadd(sqlCHAVE,{"CHECTA",M_CHECTA})

  if !cACAO $ "#DELETE#SELECT#"
    aadd(sqlCAMPO,{"CHEEMP",str(M_CHEEMP),.T.})
    aadd(sqlCAMPO,{"CHECTA",M_CHECTA,.T.})
    aadd(sqlCAMPO,{"CHENUM",str(M_CHENUM),.T.})
    aadd(sqlCAMPO,{"CHEDTE",formatdta(M_CHEDTE),.T.})
    aadd(sqlCAMPO,{"CHEVCT",formatdta(M_CHEVCT),.T.})
    for ABC = 1 to 12
      MS = strzero(ABC,2)
      aadd(sqlCAMPO,{"CHEDUP&MS",str(M_CHEDUP&MS,6),.T.})
      aadd(sqlCAMPO,{"CHEORD&MS",str(M_CHEORD&MS,2),.T.})
      aadd(sqlCAMPO,{"CHEFOR&MS",str(M_CHEFOR&MS,5),.T.})
    next
    aadd(sqlCAMPO,{"CHEPOR",M_CHEPOR,.T.})
    aadd(sqlCAMPO,{"CHEOBS",M_CHEOBS,.T.})
    aadd(sqlCAMPO,{"CHEVLR",str1(M_CHEVLR,2),.T.})
    aadd(sqlCAMPO,{"CHEIPL",M_CHEIPL,.T.})
  endif
  executasql()

return ""

*****************
functio GRAVA_LAB
*****************

M_LANEMP = ACHE00->CHEEMP
M_LANDTA = ACHE00->CHEVCT
M_LANCTA = ACHE00->CHECTA
M_LANSEQ = ACHE00->CHENUM
M_LANEMP = ACHE00->CHEEMP
M_LANVLR = ACHE00->CHEVLR
M_LANCOD = 500
M_LANHIS = alltrim(ACHE00->CHEOBS) + " " + alltrim(ACHE00->CHEPOR)
M_LANTIP = "D"

grlab01("INSERT")

*****************
functio BAIXA_DCP
*****************

private M_DUPDSC

for R = 1 to 12

  S = strzero(R, 2, 0)

  if ACHE00->CHEDUP&S = 0
    loop
  endif

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ADCP00","ADCP00"})
  aadd(sqlCAMPO,"ADCP00.DUPEMP")
  aadd(sqlCAMPO,"ADCP00.DUPNUM")
  aadd(sqlCAMPO,"ADCP00.DUPSER")
  aadd(sqlCAMPO,"ADCP00.DUPORD")
  aadd(sqlCAMPO,"ADCP00.DUPFOR")
  aadd(sqlCAMPO,"ADCP00.DUPVLA")
  aadd(sqlCHAVE,"DUPEMP =  " + str(ME_EMP, 2))
  aadd(sqlCHAVE,"DUPNUM =  " + str(ACHE00->CHEDUP&S, 9))
  aadd(sqlCHAVE,"DUPORD =  " + str(ACHE00->CHEORD&S, 2))
  aadd(sqlCHAVE,"DUPFOR =  " + str(ACHE00->CHEFOR&S, 5))
  aadd(sqlCHAVE,"DUPHIS <> 100")

  if !sqlrelation()
    loop
  endif

  M_VLRPGO = DUPVLA

*  select ABCP00

*  _append("ABCP00")

*  do while .t.
*    if rlock()
*      replace BAIEMP with ACHE00->CHEEMP
*      replace BAIDTM with ctod(M_DATA)
*      replace BAINUM with ACHE00->CHEDUP&S
*      replace BAIORD with ACHE00->CHEORD&S
*      replace BAISIT with "A"
*      unlock
*      exit
*    else
*      msg("* * * (ABCP00) REGISTRO SENDO USADO * * *")
*    endif
*    if lastkey() = 17
*      exit
*    endif
*  enddo

    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"ADCP00","UPDATE"}

    aadd(sqlCHAVE,{"DUPEMP",str(ADCP00->DUPEMP)})
    aadd(sqlCHAVE,{"DUPNUM",str(ADCP00->DUPNUM)})
    aadd(sqlCHAVE,{"DUPORD",str(ADCP00->DUPORD)})
    aadd(sqlCHAVE,{"DUPFOR",str(ADCP00->DUPFOR)})

    aadd(sqlCAMPO,{"DUPPOR",str(ACTA00->CTABAN),.t.})
    aadd(sqlCAMPO,{"DUPDTP",formatdta(ACHE00->CHEVCT),.t.})
    aadd(sqlCAMPO,{"DUPHIS",str(100),.t.})
    aadd(sqlCAMPO,{"DUPVLP",str1(M_VLRPGO,2),.t.})
    aadd(sqlCAMPO,{"DUPVLA",str1(0,2),.t.})
    aadd(sqlCAMPO,{"DUPTAX",str1(0,2),.t.})

    aadd(sqlCAMPO,{"CHEQUE",str(ACHE00->CHENUM,6),.t.})
    aadd(sqlCAMPO,{"BANCO",ACHE00->CHECTA,.t.})
    executasql()

*  if ADCP00->DUPAPL > 0
*    lanca_flx()
*  endif

next 

return ""

*****************
functio LANCA_FLX
*****************

    select APLX00                  && plano fluxo de caixa

    if dbseek(str(ME_EMP, 2, 0) + str(ADCP00->DUPAPL, 3, 0))
      M_CHEFLX = APLX00->PLXSEQ + 1
    else
      M_CHEFLX = 1
    endif

    select ALAX00                   && seleciona fluxo de caixa
    _append("ALAX00")
    do while .t. 
      if rlock()                   
        replace LAXEMP with ACHE00->CHEEMP
        replace LAXAPL with ADCP00->DUPAPL
        replace LAXDTA with ACHE00->CHEVCT
        replace LAXSEQ with M_CHEFLX
        replace LAXVLR with M_VLRPGO
        replace LAXHIS with "REF PAG " + alltrim(ADCP00->DUPOBS) + " " + alltrim(str(ADCP00->DUPNUM, 6, 0) + "/" + str(ADCP00->DUPORD, 2, 0)) + " " + alltrim(ADCP00->DUPNOM)
        replace LAXTIP with APLX00->PLXTIP 
        unlock
        exit 
      else
        msg("* * * (ALAX00) REGISTRO SENDO USADO * * *")
      endif
      if lastkey()=17
        exit
      endif
    enddo

    select APLX00
    do while .t. 
      if rlock()
        replace PLXSEQ with PLXSEQ + 1
        unlock
        exit 
      else
        msg("* * * (APLX00) REGISTRO SENDO USADO * * *")
      endif
      if lastkey()=17
        exit
      endif
    enddo

return ""

***************
function SUSCHE
***************

private M_TELA ,;
        M_OPC

 tone(300,8)

 M_TELA = savescreen(12, 12, 15, 67)

 sombra(12, 12, 14, 66,_SOMBRA_) 
 set color to W/R
   @ 12, 12 say "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»"
   @ 13, 12 say "º    Coloque outra Copia de Cheque e tecle (ENTER)    º"
   @ 14, 12 say "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
 set color to

 inkey(0)

 restscreen(12, 12, 15, 67, M_TELA)

return ""

******************
function VERDUPCHE
******************
parameters FDUP,FORD,FFOR

LOCAL aBlocks2 := {}
LOCAL aObjects2:= WvtSetObjects( {} )
LOCAL aLastPaint7
LOCAL cScr    := SaveScreen( 0,0,maxrow(),maxcol() )
LOCAL lTela
LOCAL M_GETANT

aAdd( aBlocks2, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
aAdd( aBlocks2, {|| WVT_DRAWBOXGROUP( 03, 03, 05, 74,{+15,+10,-15,-10})})
aAdd( aBlocks2, {|| WVT_DRAWBOXGROUP( 05, 03, 16, 74,{+15,+10,-15,-10})})
aAdd( aBlocks2, {|| WVT_DRAWBOXGROUP( 16, 03, 20, 74,{+15,+10,-15,-10})})
aAdd( aBlocks2, {|| WVT_DRAWBOXGROUP( 20, 03, 23, 74,{+15,+10,-15,-10})})

save get to M_GETANT

M_OPC = 4
C_OPC = 4

lTela := wvt_savescreen(03, 03, 25, 76)

tldcp03()

aLastPaint7 := WvtSetBlocks( aBlocks2 )

do while .t.
                set color to I
                  @ 04, 06 say " Codigo:                     Vencimento:          ate          "
                set color to
                store 0                to M_DUPFOR, M_CODINI, M_CODFIN, M_DUPEMP
                store ctod("  /  /  ") to M_VCTINI, M_VCTFIN
                store "A"              to M_TIPO
                SetColor(_COREDICAO_)
                @ 04, 15 get M_DUPFOR picture "#######" F2 color _CORF2_  valid fun_dcp08() funcao "sele_arquivo('AFOR00')" retorno @M_DUPFOR
                @ 04, 47 get M_VCTINI
                @ 04, 60 get M_VCTFIN
                read
                if lastkey() = 27
                  exit
                endif
                M_CODINI = iif(M_CODINI=0,1      ,M_CODINI)
                M_CODFIN = iif(M_CODFIN=0,9999999,M_CODFIN)
                M_VCTINI = iif(empty(M_VCTINI),ctod("01/01/80"),M_VCTINI)
                M_VCTFIN = iif(empty(M_VCTFIN),ctod("31/12/79"),M_VCTFIN)
                mosdcp("A")

                FDUP = ADCP00->DUPNUM
                FORD = ADCP00->DUPORD
                FFOR = ADCP00->DUPFOR

                exit
              enddo
              
wvt_restscreen(03, 03, 25, 76,lTela)
WvtSetBlocks( aLastPaint7 )
WvtSetObjects( aObjects2 )
restore get from M_GETANT

set cursor on

return

******************
function TECLANDO1
******************

parameters M_TAM ,;
           M_LIN ,;
           M_COL ,;
           M_COR

private M_NOM ,;
        M_LOC

      M_NOM = M_TAM
      M_LOC = 1

      set color to &M_COR

      lAchei = .t.

        do while M_LOC <= len(M_TAM)
          @ M_LIN, (1 + M_COL) say M_NOM
          @ M_LIN, (M_LOC + M_COL) say ""

          tecla = inkey(0)
          if str(tecla,2) $ "13#27" 
            exit
          endif
          lNao = .f.
          do case
             case str(tecla,2) $ " 5# 8"
               M_LOC = M_LOC - 1
               M_LOC = iif(M_LOC=0,1,M_LOC)
               M_NOM = stuff(M_NOM,M_LOC,1,"")
               M_NOM = stuff(M_NOM,M_LOC,1," ")
               lNao = .t.
             case str(tecla,2) $ " 4"
                M_LOC = M_LOC + 1
                M_LOC = iif(M_LOC>len(M_TAM),len(M_TAM),M_LOC)
                lNao = .t.
             case str(tecla,2) $ "19"
                M_LOC = M_LOC - 1
                M_LOC = iif(M_LOC<1,1,M_LOC)
                loop
             case str(tecla,2) $ " 7"
                M_NOM = left(M_NOM,M_LOC-1) + right(M_NOM,(len(M_NOM)-(M_LOC))) + " "
                loop
             case str(tecla,2) $ " 1"
                M_LOC = 1
                loop
             case str(tecla,2) $ " 6"
                M_LOC = len(M_TAM)
                loop
          endcase

          if lNao == .f.
            M_NOM = stuff(M_NOM,M_LOC,1,upper(chr(tecla)))
            M_LOC = M_LOC + 1
          endif

          select PORTADOR
          dbseek(M_NOM,.t.)
          lAchei = .f.

          if left(NOME,len(alltrim(M_NOM))) = alltrim(M_NOM)
            M_NOM = NOME
            lAchei = .t.
          else
            M_NOM = left(M_NOM,M_LOC-1) + space(len(M_TAM)+1-M_LOC)
            lAchei = .f.
          endif
        enddo

        @ M_LIN, (1 + M_COL) say M_NOM
      set color to

if lAchei = .f.
  select PORTADOR
  _append("PORTADOR")
  do while .t.
    if rlock()
      replace NOME with M_NOM
      unlock
      exit
    endif
  enddo
endif

return M_NOM


***************
function ACERTACHE
***************

      sqlRELATION = {}
      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {}
      sqlORDEM = {}

      aadd(sqlARQUI,{"ACHE00","ACHE00"})
      aadd(sqlCAMPO,"ACHE00.*")
      aadd(sqlCHAVE,"CHEDTE BETWEEN " + aspas(formatdta(ctod("01/04/2024"))) + " and " + aspas(formatdta(ctod("29/04/2024"))))

      if !sqlrelation()
        msg("* * * NAO HA CHEQUE A EMITIR * * *")
        return ""
      endif

      do while !eof()

        grava_lab()    && grava lancamento bancario  */

        select ACHE00

        skip

      enddo

return ""



***************
function ACERTANESTLE
***************

      sqlRELATION = {}
      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {}
      sqlORDEM = {}

      aadd(sqlARQUI,{"APCA00","APCA00"})
      aadd(sqlCAMPO,"APCA00.*")
      aadd(sqlCHAVE,"SLDNESTLE > 0")
      sqlrelation()

      do while !eof()

        if !BUSCAREGISTRO("ASLD00",1,{str(ME_EMP, 2, 0),str(APCA00->PCAMAT,6,0)},"SELECT")
          sqlORDEM = {}
          sqlCAMPO = {}
          sqlCHAVE =  {}
          sqlARQUI = {"ASLD00","INSERT"}

          aadd(sqlCHAVE,{"SLDMAT",str(APCA00->PCAMAT,6)})
          aadd(sqlCHAVE,{"SLDEMP",str(ME_EMP,2)})
          aadd(sqlCAMPO,{"SLDEMP",str(ME_EMP),.t.})
          aadd(sqlCAMPO,{"SLDMAT",str(APCA00->PCAMAT),.t.})
          aadd(sqlCAMPO,{"SLDNESTLE",str1(APCA00->SLDNESTLE,3),.t.})
          executasql()
        else
          sqlCAMPO = {}
          sqlCHAVE =  {}
          sqlARQUI = {"ASLD00","UPDATE"}
          aadd(sqlCHAVE,{"SLDEMP",str(ME_EMP,2)})
          aadd(sqlCHAVE,{"SLDMAT",str(APCA00->PCAMAT,6)})
          aadd(sqlCAMPO,{"SLDNESTLE",str1(APCA00->SLDNESTLE,3),.t.})
          executasql()
        endif

        select APCA00
        skip

      enddo

return ""