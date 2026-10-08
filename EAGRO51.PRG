#include "ptmenu.ch"

***************
function MANBAN
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("MENU","BANCOS",M_FAN,"EAGRO51","Mem: " + str(memory(0), 5),M_EMP)

*        @ 05, 52 prompt "Inclus꼘 " HIGHLITE R/BG  PERMITE 1,5,1
*        @ 06, 52 prompt "Altera뇙o" HIGHLITE R/BG  PERMITE 1,5,2
*        @ 07, 52 prompt "Consultas" HIGHLITE R/BG  PERMITE 1,5,3
*        @ 08, 52 prompt "Exclus꼘 " HIGHLITE R/BG  PERMITE 1,5,4
*        @ 09, 52 prompt "Listagens" HIGHLITE R/BG  PERMITE 1,5,5
*        @ 10, 52 prompt "Exercicio" POSITION 2 HIGHLITE R/BG PERMITE 1,5,6

      do case
         case M_OPC = 1 ; inccta()
         case M_OPC = 2 ; altcta()   
         case M_OPC = 3 ; concta()     
         case M_OPC = 4 ; exccta()   
         case M_OPC = 5 ; liscta()   
         case M_OPC = 6 ; execta()   
      endcase

    fecha_arq()

return ""

***************
function INCCTA         && inclui Conta  
***************

    do while .t.

        tlcta01()

        rodape("INCLUI","BANCOS",M_FAN,"EAGRO51","Mem: " + str(memory(0), 5),M_EMP) 

        M_CTAEMP = ME_EMP
        M_CTACTA = space(13)
        M_CTABAN = 0
        M_CTAAGE = space(40)
        M_CTACHE = 0
        M_CTASEQ = 0
        M_CTAEND = space(40)
        M_CTACGC = space(15)
        M_CTAIES = space(15)
        M_CTATEL = space(15)
        M_CTAFAX = space(15)
        M_CTAMUN = space(15)
        M_CTAEST = space(02)
        M_CTAGER = space(15)
        M_CTAPOR = 0

        SetColor(_COREDICAO_)
        @ 08, 25 get     M_CTACTA  picture "@!"
        read

        if empty(M_CTACTA)
          exit
        endif

        select ACTA00

        if dbseek(str(M_CTAEMP, 2, 0) + M_CTACTA)
          msg( "* * * CONTA JA CADASTRADA * * *")
          loop
        endif

        edcta01()

        if lastkey() = 27
          msg( "* * * CONTA NAO INCLUIDA * * *")
          loop 
        endif 
 
        select ACTA00

        _append("ACTA00")
        grcta01()                      && grava plano de contas

        msg("* * * CONTA INCLUIDA * * *")

    enddo

return ""

***************
function ALTCTA         && altera Conta  
***************

    do while .t.

        tlcta01()

        rodape("ALTERA","BANCOS",M_FAN,"EAGRO51","Mem: " + str(memory(0), 5),M_EMP) 

        M_CTAEMP = ME_EMP
        M_CTACTA = space(13)

        SetColor(_COREDICAO_)
        @ 08, 25 get     M_CTACTA  picture "@!"
        read

        if empty(M_CTACTA)
          exit
        endif

        select ACTA00

        if !dbseek(str(M_CTAEMP, 2, 0) + M_CTACTA)
          msg( "* * * CONTA NAO CADASTRADA * * *")
          loop
        endif

        M_CTAEMP = CTAEMP
        M_CTACTA = CTACTA
        M_CTABAN = CTABAN
        M_CTAAGE = CTAAGE
        M_CTACHE = CTACHE
        M_CTASEQ = CTASEQ
        M_CTAEND = CTAEND
        M_CTACGC = CTACGC
        M_CTAIES = CTAIES
        M_CTATEL = CTATEL
        M_CTAFAX = CTAFAX
        M_CTAMUN = CTAMUN
        M_CTAEST = CTAEST
        M_CTAGER = CTAGER
        M_CTAPOR = CTAPOR
 
        edcta01()

        if lastkey() = 27
          msg( "* * * CONTA NAO ALTERADA * * *")
          loop 
        endif 
 
        grcta01()                      && grava plano de contas

        msg("* * * CONTA ALTERADA * * *")

    enddo

return ""

***************
function CONCTA         && consulta Conta  
***************

private M_OPC ,;
        M_TELA

  do while .t.

    rodape("CONSULTA","BANCOS",M_FAN,"EAGRO51","Mem: " + str(memory(0), 5),M_EMP) 

    tlcta01()

    M_CTAEMP = ME_EMP
    M_CTACTA = space(13)

    SetColor(_COREDICAO_)
    @ 08, 25 get     M_CTACTA  picture "@!"
    read

    if empty(M_CTACTA)
      exit
    endif

    select ACTA00

    set softseek on
       seek str(M_CTAEMP, 2, 0) + M_CTACTA
    set softseek off

    setas()

    do while .t.

      if CTAEMP != ME_EMP
        msg("* * * FIM DO ARQUIVO * * *")
        exit
      endif

      mscta01()
  
      inkey(0)

      if lastkey() = 5
        skip - 1
      endif         

      if lastkey() = 24
        skip 
      endif

      if lastkey() = 27
        exit
      endif
 
    enddo 

    set cursor on

  enddo

return "" 

***************
function EXCCTA         && exclui Conta  
***************


private M_CTAEMP ,;     && codigo da empresa
        M_CTACTA ,;     && codigo da conta
        M_TELA   ,;
        M_OPC

    do while .t.

        tlcta01()

        rodape("EXCLUI","BANCOS",M_FAN,"EAGRO51","Mem: " + str(memory(0), 5),M_EMP) 

        M_CTAEMP = ME_EMP
        M_CTACTA = space(13)

        SetColor(_COREDICAO_)
        @ 08, 25 get     M_CTACTA  picture "@!"
        read

        if empty(M_CTACTA)
          exit
        endif

        select ACTA00

        if !dbseek(str(M_CTAEMP, 2, 0) + M_CTACTA)
          msg( "* * * CONTA NAO CADASTRADA * * *")
          loop
        endif
 
        mscta01()
        
        store 2 to M_OPC

        set color to GR+ 
          @ 24, 23 say "Confirma Exclusao da Conta ? (Sim) (Nao)"
          @ 24, 53 prompt "Sim"
          @ 24, 59 prompt "Nao"
          menu to M_OPC
        set color to 

        if M_OPC = 2 .or. lastkey() = 27
          msg("* * * CONTA NAO EXCLUIDA * * *")
          unlock
          loop
        endif

        elimina() 

        msg("* * * CONTA EXCLUIDA * * *")

enddo

return ""

***************
function LISCTA         && lista Conta  
***************

private M_OPC ,;
        M_TELA   ,;
        M_CTACTA1,;
        M_CTACTA2

  do while .t.

    rodape("LISTA","BANCOS",M_FAN,"EAGRO51","Mem: " + str(memory(0), 5),M_EMP) 

    M_CTACTA1 = space(13)
    M_CTACTA2 = space(13)

 nbox(10, 24, 13, 53,"W/W+",.t.)
 setcolor("B/W")
      @ 11, 25 say  "Conta Inicial:              "
      @ 12, 25 say  "        Final:              "
    SetColor(_COREDICAO_)
    @ 11, 40 get M_CTACTA1 picture "@!"
    @ 12, 40 get M_CTACTA2 picture "@!"
    read

    if lastkey() = 27
      exit
    endif

    M_CTACTA1 = iif(empty(M_CTACTA1),"0"            ,M_CTACTA1)
    M_CTACTA2 = iif(empty(M_CTACTA2),"ZZZZZZZZZZZZZ",M_CTACTA2) 

    select ACTA00

    set softseek on
      seek str(ME_EMP, 2, 0) + M_CTACTA1
    set softseek off

    if str(CTAEMP, 2, 0) + CTACTA > str(ME_EMP, 2, 0) + M_CTACTA2
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

          ? cent_cab(AEMP00->EMPFAN,"LISTAGEM PLANO DE CONTAS","EAGRO51",80) 
          ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 80)
          ? "*-------------*----------------------------------------*-----*--------*--------*"
          ? "*    CONTA    *         AGENCIA                        *BANCO* CHEQUE *   SEQ  *"
          ? "*-------------*----------------------------------------*-----*--------*--------*"
*             xxxxxxxxxxxxx XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXX 99999999 99999999  

          store 6 to LN
  
          do while !eof() .and. LN < 60 
 
            if str(CTAEMP, 2, 0) + CTACTA > str(ME_EMP, 2, 0) + M_CTACTA2
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
              ?? str(CTACHE, 8)
              ?? " "
              ?? str(CTASEQ, 8)
 
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

***************
function EXECTA
***************

msw("* * * AGUARDE... ABRINDO ARQUIVOS * * *")

abre_lab("3")

private M_OPC

  do while .t.

        rodape("EXERCICIO","BANCOS",M_FAN,"EAGRO51","Mem: " + str(memory(0), 5),M_EMP) 

 nbox(09, 23, 15, 58,"W/W+",.t.)
 setcolor("B/W")
          @ 10, 24 say  "    ENCERRA EXERCICIO DA CONTA    "
          @ 11, 24 say  "----------------------------------"
          @ 12, 24 say  "Este processo elimina lancamentos "
          @ 13, 24 say  "da conta e gera saldo transporte. "
          @ 14, 24 say  "Conta:                            "
        set color to

        M_DTAFIN = ctod("31/12/99")
        M_CTACTA = space(13)
        M_FLGSIT = .f.

        SetColor(_COREDICAO_)
        @ 14, 31 get M_CTACTA picture "@!"
        read

        if lastkey()=27
          exit
        endif
 
        select ACTA00

        if !dbseek(str(ME_EMP, 2, 0) + M_CTACTA)
          msg("* * * CONTA NAO CADASTRADA * * *")
          loop
        endif

        store 2 to M_OPC

        set color to GR+
          @ 24, 19 say "Posso Iniciar o Processamento ? (Sim) (Nao)"
          @ 24, 52 prompt "Sim"
          @ 24, 58 prompt "Nao"
          menu to M_OPC
        set color to 

        if M_OPC = 2 .or. lastkey() = 27
          exit
        endif

        msw("* * * AGUARDE PROCESSANDO * * *")   

        select ALAB00

        set order to 2

        set softseek on
          seek str(ME_EMP, 2, 0) + M_CTACTA + dtos(ctod("  /  /  "))
        set softseek off

        M_SALDO = 0

        do while !eof()

          if str(LANEMP, 2, 0) + LANCTA + dtos(LANDTA) > str(ME_EMP, 2, 0) + M_CTACTA + dtos(M_DTAFIN)
            exit
          endif 

          if LANSIT = "P"
            M_FLGSIT = .t.
          endif

          M_LANDTA   = LANDTA

          if LANTIP = "C"
            M_SALDO = M_SALDO + LANVLR
          else
            if LANTIP = "D"
              M_SALDO = M_SALDO - LANVLR
            endif
          endif

          skip

        enddo

        if M_FLGSIT 
          msg("* * * CONTA POSSUE LANCAMENTO PRE-DATADO - PROCESSO SUSPENSO * * *")
          loop
        endif

        M_LANEMP   = ME_EMP
        M_LANCTA   = M_CTACTA
        M_LANSEQ   = 1
        M_LANVLR   = M_SALDO
        M_LANHIS   = "SALDO ANTERIOR ....."
        M_LANCOD   = 1
        M_LANTIP   = "C"
        M_LANSIT   = "N"

        do while .t.

          set softseek on
            seek str(ME_EMP, 2, 0) + M_CTACTA 
          set softseek off
         
          if !str(LANEMP, 2, 0) + LANCTA == str(ME_EMP, 2, 0) + M_CTACTA 
            exit
          endif

          do while .t. 
            if rlock()                   
              replace LANEMP with 0
              replace LANCTA with space(13)
              replace LANDTA with ctod("  /  /  ")
              replace LANSEQ with 0
              replace LANVLR with 0
              replace LANCOD with 0
              replace LANTIP with " "
              replace LANSIT with " "
              replace LANHIS with space(52)  
              unlock
              commit 
              exit 
            else
               msg("* * * (ALAB00) REGISTRO SENDO USADO * * *")
            endif
            if lastkey()=17
              exit
            endif
          enddo

        enddo

        select ALAB00

        _append("ALAB00")

        do while .t. 
          if rlock()                   
            replace LANEMP with M_LANEMP
            replace LANCTA with M_LANCTA 
            replace LANDTA with M_LANDTA
            replace LANSEQ with M_LANSEQ
            replace LANVLR with M_LANVLR
            replace LANCOD with M_LANCOD
            replace LANHIS with M_LANHIS
            replace LANTIP with M_LANTIP
            replace LANSIT with M_LANSIT
            unlock
            commit 
            exit 
          else
            msg("* * * (ALAB00) REGISTRO SENDO USADO * * *")
          endif
          if lastkey()=17
            exit
          endif
        enddo

        select ACTA00

        do while .t. 
          if rlock()
            replace CTASEQ with M_LANSEQ
            unlock
            commit
            exit 
          else
            msg("* * * (ACTA00) REGISTRO SENDO USADO * * *")
          endif
          if lastkey()=17
            exit
          endif
        enddo

        msg("* * * FIM DO PROCESSAMENTO * * *")

    exit 
 
  enddo

  commit

  fecha_arq()

  abre_cta("2")
  abre_por("3")

return ""
 
*****************
function VERCTA01
*****************

if lastkey() = 5
  return .t.
endif

if M_CTAPOR = 0
  return .f.
endif

select APOR00

if !dbseek(str(M_CTAPOR, 5, 0))
   msg("* * * PORTADOR NAO CADASTRADO * * *")
   return .f.
endif

msg("* * * " + alltrim(PORNOM) + " * * *")

return .t.
 
****************
function TLCTA01
****************

 nbox(07, 13, 17, 67,"W/W+",.t.)
 setcolor("B/W")
    @ 08, 14 say     " Conta   :                               Banco:      "
    @ 09, 14 say     " Agencia :                                           "
    @ 10, 14 say     "컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"
    @ 11, 14 say     " Cheque  :               Lancamentos:                "
    @ 12, 14 say     " Endereco:                                           "
    @ 13, 14 say     " CGC (MF):                       Ies:                "
    @ 14, 14 say     " Telefone:                       Fax:                "
    @ 15, 14 say     " Cidade  :                    Estado:                "
    @ 16, 14 say     " Gerente :                  Portador:                "
  set color to

return ""    

****************
function EDCTA01
**************** 

SetColor(_COREDICAO_)
@ 08, 62 get     M_CTABAN  picture "###" valid(M_CTABAN > 0)
@ 09, 25 get     M_CTAAGE  picture "@!"
@ 11, 25 get     M_CTACHE  picture "######"
@ 11, 52 get     M_CTASEQ  picture "######"
@ 12, 25 get     M_CTAEND  picture "@!"
@ 13, 25 get     M_CTACGC  picture "@R 999.999.999/9999-99"
@ 13, 52 get     M_CTAIES  picture "@!"
@ 14, 25 get     M_CTATEL  picture "@!"
@ 14, 52 get     M_CTAFAX  picture "@!"
@ 15, 25 get     M_CTAMUN  picture "@!"
@ 15, 52 get     M_CTAEST  picture "@!"
@ 16, 25 get     M_CTAGER  picture "@!"
@ 16, 52 get     M_CTAPOR  picture "#####" valid vercta01()
read

return ""

****************
function MSCTA01
**************** 

 setcolor("N/W*")
  @ 08, 25 say     CTACTA  picture "@!"
  @ 08, 62 say     CTABAN  picture "###"
  @ 09, 25 say     CTAAGE  picture "@!"
  @ 11, 25 say     CTACHE  picture "######"
  @ 11, 52 say     CTASEQ  picture "######"
  @ 12, 25 say     CTAEND  picture "@!"
  @ 13, 25 say     CTACGC  picture "@R 999.999.999/9999-99"
  @ 13, 52 say     CTAIES  picture "@!"
  @ 14, 25 say     CTATEL  picture "@!"
  @ 14, 52 say     CTAFAX  picture "@!"
  @ 15, 25 say     CTAMUN  picture "@!"
  @ 15, 52 say     CTAEST  picture "@!"
  @ 16, 25 say     CTAGER  picture "@!"
  @ 16, 52 say     CTAPOR  picture "@!"
set color to 

return ""

****************
function GRCTA01
****************

   select ACTA00

        do while .t. 
          if rlock()                   && grava rodapealho do Bordero
            replace CTAEMP with M_CTAEMP
            replace CTACTA with M_CTACTA
            replace CTABAN with M_CTABAN
            replace CTAAGE with M_CTAAGE
            replace CTACHE with M_CTACHE
            replace CTASEQ with M_CTASEQ
            replace CTAEND with M_CTAEND
            replace CTACGC with M_CTACGC
            replace CTAIES with M_CTAIES
            replace CTATEL with M_CTATEL
            replace CTAFAX with M_CTAFAX
            replace CTAMUN with M_CTAMUN
            replace CTAEST with M_CTAEST
            replace CTAGER with M_CTAGER
            replace CTAPOR with M_CTAPOR
            unlock
            commit 
            exit 
          else
            msg("* * * (ACTA00) REGISTRO SENDO USADO * * *")
          endif
          if lastkey()=17
            exit
          endif
        enddo

return ""