#define HB_EXT_INKEY

#include "ptmenu.ch"
#include "inkey.ch"

#command @ <row> , <col>  GET <var> [<clauses,...>] F2 [<moreClauses,...>] funcao <func> retorno <Variavel>;
=>       @ <row> , <col>  GET <var> [<clauses>] SEND reader := {|oGet| Getf2(oGet,<func>,<Variavel>) } [<moreClauses>]

***************
function MANDCR
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("MENU","DUPLICATA",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP)

*        @ 05, 30 prompt "Inclus„o " HIGHLITE R/BG PERMITE 1,3,1
*        @ 06, 30 prompt "Altera‡„o" HIGHLITE R/BG PERMITE 1,3,2
*        @ 07, 30 prompt "Consulta " HIGHLITE R/BG PERMITE 1,3,3
*        @ 08, 30 prompt "Exclus„o " HIGHLITE R/BG PERMITE 1,3,4
*        @ 09, 30 prompt "Listagem " HIGHLITE R/BG PERMITE 1,3,5
*        @ 10, 30 prompt "Boletos  " HIGHLITE R/BG PERMITE 1,3,6

      do case
         case M_OPC = 1 ; incdcr()
         case M_OPC = 2 ; altdcr(M_OPC1)
         case M_OPC = 3 ; condcr(M_OPC1)
         case M_OPC = 4 ; excdcr()   
         case M_OPC = 5 ; lisdcr(M_OPC1)
         case M_OPC = 6 ; emidcr(M_OPC1)
      endcase

    fecha_arq()

return ""

***************
function INCDCR
***************

    do while .t.

        tldcr01() 

        rodape("INCLUI","DUPLICATA",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP)

        M_DUPEMP = ME_EMP
        M_DUPNUM = 0
        M_DUPORD = 0
        M_DUPSER = AEMP00->EMPSER
        M_DUPCLI = 0
        M_DUPDTE = ctod("  /  /  ")
        M_DUPVCT = ctod("  /  /  ")
        M_DUPPOR = 0
        M_DUPEXP = " "
        M_DUPVLO = 0
        M_DUPVLA = 0
        M_DUPBOL = 0
        M_DUPDTP = ctod("  /  /  ")
        M_DUPVLP = 0
        M_DUPHIS = 500
        M_DUPOBS = space(40)
        M_DUPOBT = space(40)
        M_DUPNOM = space(40)     
        M_DUPCPG = 0
        M_DUPVEN = 0
        M_DUPTXD = 0
        M_DUPDSC = 0
        M_DUPTAX = 0
        M_DUPJUR = 0
        M_DUPPER = " "

        SetColor(_COREDICAO_)
        @ 07, 26 get     M_DUPNUM   picture "######"
        @ 07, 33 get     M_DUPORD   picture "##"
        @ 07, 43 get     M_DUPSER   picture "@!"
        read

        if M_DUPNUM = 0 
          exit
        endif

        if BUSCAREGISTRO("ADCR00",1,{str(ME_EMP, 2, 0),str(M_DUPNUM, 6, 0),str(M_DUPORD, 2, 0),aspas(M_DUPSER)},"SELECT")
          msg("* * * DUPLICATA Jµ CADASTRADA * * *")
          loop
        endif

        eddcr01()                      && edita duplicata

        if lastkey() = 27
          msg("* * * DUPLICATA NAO INCLUIDA * * *")
          keyfun()
          loop 
        endif

        grdcr01("INSERT")                      && grava duplicata

        msg("* * * DUPLICATA INCLUIDA * * *")

    enddo


return ""

***************
function ALTDCR
***************
parameters M_OPC,M_OPC1,M_OPC2


        rodape("ALTERA","DUPLICATA",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP)  

*          @ 10, 36 prompt   "Titulo   " HIGHLITE R/BG
*          @ 11, 36 prompt   "Comissao " HIGHLITE R/BG
*          @ 12, 36 prompt   "Pagamento" HIGHLITE R/BG
*          @ 13, 36 prompt   "Exportar " HIGHLITE R/BG

        do case
           case M_OPC = 1 ; altdcr_a()
           case M_OPC = 2 ; altdcr_b()
           case M_OPC = 3 ; altdcr_c(1)
           case M_OPC = 4 ; altdcr_c(2)
        endcase


return ""

*****************
function ALTDCR_A
*****************

do while .t.

  tldcr01()
  rodape("ALTERA","DUPLICATA",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP)

  M_DUPEMP = ME_EMP
  M_DUPNUM = 0
  M_DUPORD = 0
  M_DUPSER = AEMP00->EMPSER

  SetColor(_COREDICAO_)
  @ 07, 26 get     M_DUPNUM picture "######" // F2 color _CORF2_ funcao "verdupche(@M_DUPNUM,@M_DUPORD,@M_DUPSER)" retorno "re"
  @ 07, 33 get     M_DUPORD   picture "##"
  @ 07, 43 get     M_DUPSER   picture "@!"
  read

  if M_DUPNUM = 0
    exit
  endif

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ADCR00","ADCR00"})
  aadd(sqlCAMPO,"ADCR00.*")
  aadd(sqlCAMPO,"ACLI00.CLINOM")
  aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ADCR00.DUPCLI"})
  aadd(sqlCHAVE,"ADCR00.DUPEMP = " + str(M_DUPEMP,2))
  aadd(sqlCHAVE,"ADCR00.DUPSER = " + aspas(M_DUPSER))
  aadd(sqlCHAVE,"ADCR00.DUPNUM = " + str(M_DUPNUM,9))
  aadd(sqlCHAVE,"ADCR00.DUPORD = " + str(M_DUPORD,2))
  if !sqlrelation()
    msg("* * * DUPLICATA NAO CADASTRADA * * *")
    loop
  endif

  msdcr01()                      && mostra a duplicata

  M_DUPNUM = DUPNUM
  M_DUPORD = DUPORD
  M_DUPSER = DUPSER
  M_DUPCLI = DUPCLI
  M_DUPDTP = iif(HB_ISNIL(DUPDTP),ctod("  /  /  "),DUPDTP)
  M_DUPDTE = DUPDTE
  M_DUPVCT = DUPVCT
  M_DUPPOR = DUPPOR
  M_DUPEXP = DUPEXP
  M_DUPVLO = DUPVLO
  M_DUPVLA = DUPVLA
  M_DUPBOL = DUPBOL
  M_DUPVLP = DUPVLP
  M_DUPHIS = DUPHIS
  M_DUPOBS = DUPOBS
  M_DUPOBT = DUPOBT
  M_DUPNOM = left(CLINOM, 40)
  M_DUPCPG = DUPCPG
  M_DUPDSC = DUPDSC
  M_DUPTAX = DUPTAX
  M_DUPJUR = DUPJUR
  M_DUPVEN = DUPVEN
  M_DUPTXD = DUPTXD
  M_DUPPER = DUPPER

  eddcr01()

  if lastkey() = 27
    msg("* * * DUPLICATA NAO ALTERADA * * *")
    loop
  endif

  grdcr01("UPDATE")                      && regrava duplicata

  msg("* * * DUPLICATA ALTERADA * * *")

enddo

return ""

*****************
function ALTDCR_B
*****************

    do while .t.

      tldcr01() 

        keyfun()

        rodape("ALTERA","DUPLICATA",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP) 

        M_DUPEMP = ME_EMP
        M_DUPNUM = 0
        M_DUPORD = 0

        SetColor(_COREDICAO_)
        @ 07, 26 get     M_DUPNUM   picture "######"
        @ 07, 33 get     M_DUPORD   picture "##"
        read

        if M_DUPNUM = 0
          exit
        endif

        select ADCR00

        if !dbseek(str(M_DUPEMP, 2, 0) + str(M_DUPNUM, 6, 0) + str(M_DUPORD, 2, 0))
          msg("* * * DUPLICATA NAO CADASTRADA * * *")
          keyfun()
          loop
        endif

        select ACLI00

        if !dbseek(str(ADCR00->DUPCLI, 7, 0))
          msg("* * * CLIENTE NAO CADASTRADO * * *")
        endif

        select APOR00

        if !dbseek(str(ADCR00->DUPPOR, 5, 0))
          msg("* * * PORTADOR NAO CADASTRADO * * *")
          keyfun()
        endif

        select ADCR00        

        msdcr01()                      && mostra a duplicata

        if !rlock()
          msg("* * * (ADCR00) REGISTRO SENDO USADO * * *")
          keyfun()
          loop
        endif

        M_DUPNUM = DUPNUM
        M_DUPORD = DUPORD
        M_DUPSER = DUPSER
        M_DUPCLI = DUPCLI
        M_DUPDTE = DUPDTE
        M_DUPVCT = DUPVCT
        M_DUPPOR = DUPPOR
        M_DUPEXP = DUPEXP
        M_DUPVLO = DUPVLO
        M_DUPVLA = DUPVLA
        M_DUPBOL = DUPBOL
        M_DUPDTP = DUPDTP
        M_DUPVLP = DUPVLP
        M_DUPHIS = DUPHIS
        M_DUPOBS = DUPOBS
        M_DUPOBT = DUPOBT
        M_DUPNOM = left(ACLI00->CLINOM, 40)
        M_DUPCPG = DUPCPG
        M_DUPDSC = DUPDSC
        M_DUPTAX = DUPTAX
        M_DUPJUR = DUPJUR
        M_DUPVEN = DUPVEN
        M_DUPTXD = DUPTXD
        M_DUPPER = DUPPER

        eddcr03() 

        if lastkey() = 27
          msg("* * * DUPLICATA NAO ALTERADA * * *")
          unlock
          loop 
        endif

        grdcr01()                      && regrava duplicata

        select ALCR00

        seek str(M_DUPEMP, 2, 0) + str(M_DUPNUM , 6, 0) + str(M_DUPORD, 2, 0) + str(M_DUPHIS, 3, 0) 

        if !eof()
          do while .t. 
            if rlock()
              if M_DUPHIS = 500 
                replace LANDTM with M_DUPDTE  
                replace LANVAL with M_DUPVLA  
              endif 
              if M_DUPHIS = 100
                replace LANDTM with M_DUPDTP  
              endif 
              unlock
              exit 
            else
              msg("* * * (ALCR00) REGISTRO SENDO USADO * * *")
            endif
          enddo
        endif      

        msg("* * * DUPLICATA ALTERADA * * *")

    enddo

return ""

*****************
function ALTDCR_C(TIPO)
*****************

do while .t.

  tldcr01() 

  keyfun()

  rodape("ALTERA","DUPLICATA",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP) 

  M_DUPEMP = ME_EMP
  M_DUPNUM = 0
  M_DUPORD = 0
  M_DUPSER = AEMP00->EMPSER

  SetColor(_COREDICAO_)
  @ 07, 26 get     M_DUPNUM picture "######"
  @ 07, 33 get     M_DUPORD picture "##"
  @ 07, 43 get     M_DUPSER picture "@!"
  read

  if M_DUPNUM = 0
    exit
  endif

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ADCR00","ADCR00"})
  aadd(sqlCAMPO,"ADCR00.*")
  aadd(sqlCAMPO,"ACLI00.CLINOM")
  aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ADCR00.DUPCLI"})
  aadd(sqlCHAVE,"ADCR00.DUPEMP = " + str(M_DUPEMP,2))
  aadd(sqlCHAVE,"ADCR00.DUPSER = " + aspas(M_DUPSER))
  aadd(sqlCHAVE,"ADCR00.DUPNUM = " + str(M_DUPNUM,9))
  aadd(sqlCHAVE,"ADCR00.DUPORD = " + str(M_DUPORD,2))
  if !sqlrelation()
    msg("* * * DUPLICATA NAO CADASTRADA * * *")
    loop
  endif

  if TIPO = 1
    if empty(DUPDTP)
      msg("* * * DUPLICATA NAO BAIXADA * * *")
      keyfun()
      loop
    endif
  else
    if DUPHIS = 100
      msg("* * * DUPLICATA JA BAIXADA * * *")
      keyfun()
      loop
    endif
  endif

  select ADCR00

  msdcr01()                      && mostra a duplicata

  M_DUPNUM = DUPNUM
  M_DUPORD = DUPORD
  M_DUPSER = DUPSER
  M_DUPCLI = DUPCLI
  M_DUPDTE = DUPDTE
  M_DUPVCT = DUPVCT
  M_DUPPOR = DUPPOR
  M_DUPEXP = DUPEXP
  M_DUPVLO = DUPVLO
  M_DUPVLA = DUPVLA
  M_DUPBOL = DUPBOL
  M_DUPDTP = DUPDTP
  M_DUPVLP = DUPVLP
  M_DUPHIS = DUPHIS
  M_DUPOBS = DUPOBS
  M_DUPOBT = DUPOBT
  M_DUPNOM = left(CLINOM, 40)
  M_DUPCPG = DUPCPG
  M_DUPDSC = DUPDSC
  M_DUPTAX = DUPTAX
  M_DUPJUR = DUPJUR
  M_DUPVEN = DUPVEN
  M_DUPTXD = DUPTXD
  M_DUPPER = DUPPER
  
  eddcr04(TIPO)

  if lastkey() = 27
    msg("* * * DUPLICATA NAO ALTERADA * * *")
    loop
  endif

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"ADCR00","UPDATE"}
  aadd(sqlCHAVE,{"DUPEMP",str(M_DUPEMP,2)})
  aadd(sqlCHAVE,{"DUPNUM",str(M_DUPNUM,6)})
  aadd(sqlCHAVE,{"DUPORD",str(M_DUPORD,2)})
  aadd(sqlCHAVE,{"DUPSER",aspas(M_DUPSER)})
  if TIPO = 2
    aadd(sqlCAMPO,{"DUPEXP",M_DUPEXP,.t.})
  else
    aadd(sqlCAMPO,{"DUPDTP",formatdta(M_DUPDTP),.t.})
  endif
  
  executasql()

  msg("* * * DUPLICATA ALTERADA * * *")

enddo

return ""

***************
function CONDCR(M_OPC,M_OPC1,M_OPC2)
***************

LOCAL lPritel


M_TOTDUP = 0
M_TOTPAG = 0
M_TOTAVE = 0
M_TOTVEN = 0
M_DUPCLI = 0

*SET( _SET_EVENTMASK, INKEY_ALL )
*Wvt_SetMouseMove( .t. )
*Wvt_SetMousePos( 2,40 )
*aAdd( aBlocks, {|| Wvt_Mouse( -1000001 ) } )

        rodape("CONSULTA","DUPLICATA",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP)

*          @ 08, 36 prompt   "Sequencia" HIGHLITE R/BG
*          @ 09, 36 prompt   "Vencer   " HIGHLITE R/BG
*          @ 10, 36 prompt   "Emissao  " HIGHLITE R/BG
*          @ 11, 36 prompt   "CodigoCli" HIGHLITE R/BG
*          @ 12, 36 prompt   "Portador " HIGHLITE R/BG
*          @ 13, 36 prompt   "Pagamento" POSITION 2  HIGHLITE R/BG

        do case
           case M_OPC = 1
              seqdcr()
  case M_OPC = 2
    do while .t.
      tlcon01()
      set color to I
      @ 04, 06 say "Vencimento:          ate           Cliente:       "
      set color to
      store ctod("  /  /  ") to M_VCTINI ,;
      M_VCTFIN
      store 0                to M_TOTDUP,M_DUPCLI
      setcolor(_COREDICAO_)
      @ 04, 18 get M_VCTINI
      @ 04, 31 get M_VCTFIN
      @ 04, 51 get M_DUPCLI F2 picture "#####" color _CORF2_ funcao "sele_arquivo('ACLI00')" retorno @M_DUPCLI
      read
      if may_inkey(,.t.) = 27
        exit
      endif
      M_VCTINI = iif(empty(M_VCTINI),ctod("01/01/80"),M_VCTINI)
      M_VCTFIN = iif(empty(M_VCTFIN),ctod("31/12/79"),M_VCTFIN)
      mosdcr2("N",M_OPC)
    enddo
  case M_OPC = 3
    do while .t.
      A_CLICGC = { }
      tlcon01()
      keyfun()
      set color to I
      @ 04, 06 say "Nome:                                       "
      set color to
      store ctod("  /  /  ") to M_VCTINI,M_VCTFIN
      store space(16) to M_NOMINI ,;
      M_NOMFIN
      store 0                to M_TOTDUP
      M_DUPCLI = 0
      M_DUPCGC = space(15)
      funcli()
      @ 04, 12 get M_NOMINI picture "@!" color _COREDICAO_
      read
      if may_inkey(,.t.) = 27
        exit
      endif
      select ADCR00
      set order to 9
      if len(alltrim(M_DUPCGC)) > 11
        dbseek(str(ME_EMP, 2, 0) + left(M_DUPCGC,9),.t.)
        if !str(DUPEMP, 2, 0) + left(DUPCGC,9) == str(ME_EMP, 2, 0) + left(M_DUPCGC,9)
          msg("* * * NADA A CONSULTAR NO CLIENTE * * *")
          loop
        endif
      else
        dbseek(str(ME_EMP, 2, 0) + M_DUPCGC,.t.)
        if !str(DUPEMP, 2, 0) + DUPCGC == str(ME_EMP, 2, 0) + M_DUPCGC
          msg("* * * NADA A CONSULTAR NO CLIENTE * * *")
          loop
        endif
      endif

      select ACLI00
      set order to 3

      if len(alltrim(M_DUPCGC)) > 11
        dbseek(left(M_DUPCGC,9),.t.)
      else
        dbseek(M_DUPCGC,.t.)
      endif

      M_VALJUR = 0

      do while !eof()
        if len(alltrim(M_DUPCGC)) > 11
          if !left(M_DUPCGC,9) == left(ACLI00->CLICGC1,9)
            exit
          endif
        else
          if !M_DUPCGC == ACLI00->CLICGC1
            exit
          endif
        endif
        M_VALJUR = iif(M_VALJUR>CLIJUR,M_VALJUR,CLIJUR)
        skip
      enddo
      set order to 1

      select ADCR00

      mosdcr("N",M_OPC)
    enddo
  case M_OPC = 4
    lPritel = .t.

    do while .t.
      tlcon01()

      set color to I
      @ 04, 06 say "Codigo :                    "
      set color to
      store 0 to M_CODINI ,;
      M_CODFIN
      store 0                to M_TOTDUP
      @ 04, 15 get M_CODINI picture "#######" valid M_CODINI > 0 F2 color _CORF2_ funcao "sele_arquivo('ACLI00')" retorno @M_CODINI
      read
      if may_inkey(,.t.) = 27
        exit
      endif
      mosdcr2("N",M_OPC)
    enddo
  case M_OPC = 5
    do while .t.
      tlcon01()
      set color to I
      @ 04, 06 say "Portador:       ate          "
      set color to
      store 0 to M_PORINI ,;
      M_PORFIN
      store 0                to M_TOTDUP
      @ 04, 16 get M_PORINI picture "#####" color _COREDICAO_
      @ 04, 26 get M_PORFIN picture "#####" color _COREDICAO_
      read
      if may_inkey(,.t.) = 27
        exit
      endif
      M_PORINI = iif(M_PORINI=0,1    ,M_PORINI)
      M_PORFIN = iif(M_PORFIN=0,99999,M_PORFIN)
      select ADCR00
      set order to 3
      set softseek on
      seek str(ME_EMP, 2, 0) + str(M_PORINI, 5, 0)
      set softseek off
      if eof() .or. str(DUPEMP, 2, 0) + str(DUPPOR, 5, 0) >  str(ME_EMP, 2, 0) + str(M_PORFIN, 5, 0)
        msg("* * * NADA A CONSULTAR NO PORTADOR * * *")
        loop
      endif
      mosdcr("N",M_OPC)
    enddo
  case M_OPC = 6
    do while .t.
      tlcon01()
      set color to I
      @ 04, 06 say " Pagamento:          ate          "
      set color to
      store ctod("  /  /  ") to M_DTPINI ,;
      M_DTPFIN
      store 0                to M_TOTDUP
      @ 04, 18 get M_DTPINI color _COREDICAO_
      @ 04, 31 get M_DTPFIN color _COREDICAO_
      read
      if may_inkey(,.t.) = 27
        exit
      endif
      M_DTPINI = iif(empty(M_DTPINI),ctod("01/01/80"),M_DTPINI)
      M_DTPFIN = iif(empty(M_DTPFIN),ctod("31/12/79"),M_DTPFIN)
      select ADCR00
      set order to 7
      set softseek on
      seek str(ME_EMP, 2, 0) + dtos(M_DTPINI)
      set softseek off
      if eof() .or. str(DUPEMP, 2, 0) + dtos(DUPDTP) >  str(ME_EMP, 2, 0) + dtos(M_DTPFIN)
        msg("* * * NADA A CONSULTAR NO PAGAMENTO * * *")
        loop
      endif
      mosdcr("N",M_OPC)
    enddo
  case M_OPC = 8
    do while .t.
      tlcon01()
      set color to I
      @ 04, 06 say "   Periodo:          ate                           "
      set color to
      store ctod("  /  /  ") to M_VCTINI ,;
      M_VCTFIN
      store 0                to M_TOTDUP,M_DUPPOR
      @ 04, 18 get M_VCTINI valid !empty(M_VCTINI) color _COREDICAO_
      @ 04, 31 get M_VCTFIN valid !empty(M_VCTFIN) color _COREDICAO_
      read
      if may_inkey(,.t.) = 27
        exit
      endif

      select ADCPES
      dbseek(dtos(M_VCTINI),.t.)
      if eof() .or. dtos(DTEMEN) > dtos(M_VCTFIN)
        msg("* * * NADA A CONSULTAR NO VENCIMENTO * * *")
        loop
      endif

      mosdcrpes()

    enddo
  case M_OPC = 7
    do while .t.
      tlcon01()
      store ctod("  /  /  ") to M_VCTINI , M_VCTFIN
      set color to I
      @ 04, 06 say "     Valor:               ate            "
      set color to
      store 0 to M_VALINI , M_VALFIN, M_TOTDUP
      @ 04, 13 get M_VALINI picture "@! 999,999.99" color _COREDICAO_
      @ 04, 31 get M_VALFIN picture "@! 999,999.99" color _COREDICAO_
      read
      if may_inkey(,.t.) = 27
        exit
      endif
      select ADCR00
      set order to 11
      set softseek on
      seek M_VALINI
      set softseek off
      if eof() .or. DUPVLO > M_VALFIN
        msg("* * * NADA A CONSULTAR NESTE VALOR * * *")
        loop
      endif
      mosdcr("N",M_OPC)
    enddo
  endcase


return ""

***************
function SEQDCR
***************
        
do while .t.

  tldcr01() 

  M_DUPEMP = ME_EMP
  M_DUPNUM = 0
  M_DUPORD = 0
  M_DUPSER = AEMP00->EMPSER

  SetColor(_COREDICAO_)
  @ 07, 26 get     M_DUPNUM picture "######" // F2 color _CORF2_ funcao "verdupche(@M_DUPNUM,@M_DUPORD,@M_DUPSER)" retorno "re"
  @ 07, 33 get     M_DUPORD   picture "##"
  @ 07, 43 get     M_DUPSER   picture "@!"
  read

  if M_DUPNUM = 0
    exit
  endif

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ADCR00","ADCR00"})
  aadd(sqlCAMPO,"ADCR00.*")
  aadd(sqlCAMPO,"ACLI00.CLINOM")
  aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ADCR00.DUPCLI"})
  aadd(sqlCHAVE,"ADCR00.DUPEMP = " + str(M_DUPEMP,2))
  aadd(sqlCHAVE,"ADCR00.DUPSER = " + aspas(M_DUPSER))
  aadd(sqlCHAVE,"ADCR00.DUPNUM = " + str(M_DUPNUM,9))
  aadd(sqlCHAVE,"ADCR00.DUPORD = " + str(M_DUPORD,2))
  if !sqlrelation()
    msg("* * * DUPLICATA NAO CADASTRADA * * *")
    loop
  endif

*       do while .t.

          msdcr01()

          inkey(0)

*          if lastkey() = 5
*             skip - 1
*          endif

 *         if lastkey() = 24
 *           skip
 *         endif

  *        if lastkey() = 27
  *          exit
  *        endif

  *      enddo

        set cursor on

enddo

return ""

***************
function MOSDCR
***************

  M_DUPMAT = {}
  M_DUPNFS = {}

  M_TOTDUP = 0
  M_TOTPAG = 0
  M_TOTVEN = 0
  M_TOTAVE = 0

  select AEMP00

  if M_DUPEMP > 0
    dbseek(str(M_DUPEMP, 2, 0), .t.)
  else
    dbseek(str(01, 2, 0), .t.)
  endif

  R = 1

  do while !eof()

    if eof()
      exit
    endif

    if M_DUPEMP > 0
      if M_DUPEMP != EMPCOD
        exit
      endif
    endif

    select ADCR00

    if M_OPC = 2
      ( dbsetorder(5) , dbseek(str(AEMP00->EMPCOD, 2, 0) + dtos(M_VCTINI), .t.) )
      if eof() .or. str(DUPEMP, 2, 0) + dtos(DUPVCT) >  str(AEMP00->EMPCOD, 2, 0) + dtos(M_VCTFIN) 
        select AEMP00
        skip
        loop
      endif
    endif

    if M_OPC = 3
      ( dbsetorder(4) , dbseek(str(AEMP00->EMPCOD, 2, 0) + dtos(M_DTEINI), .t.) )
      if eof() .or. str(DUPEMP, 2, 0) + dtos(DUPDTE) >  str(AEMP00->EMPCOD, 2, 0) + dtos(M_DTEFIN) 
        select AEMP00
        skip
        loop
      endif
    endif

    if M_OPC = 4
      (dbsetorder(2) , dbseek(str(AEMP00->EMPCOD, 2, 0) + str(M_CODINI, 7, 0), .t.) )
      if eof() .or. str(DUPEMP, 2, 0) + str(DUPCLI, 7, 0) > str(AEMP00->EMPCOD, 2, 0) + str(M_CODFIN, 7, 0)
        select AEMP00
        skip
        loop
      endif
    endif

    if M_OPC = 5
      (dbsetorder(3) , dbseek(str(AEMP00->EMPCOD, 2, 0) + str(M_PORINI, 5, 0) + str(M_CODINI, 7, 0), .t.) )
      if eof() .or. str(DUPEMP, 2, 0) + str(DUPPOR, 5, 0) + str(DUPCLI, 7, 0) + dtos(DUPVCT) > str(AEMP00->EMPCOD, 2, 0) + str(M_PORFIN, 5, 0) + str(M_CODFIN, 7, 0)
        select AEMP00
        skip
        loop
      endif
    endif

    if M_OPC = 6
      ( dbsetorder(7) , dbseek(str(AEMP00->EMPCOD, 2, 0) + dtos(M_DTPINI), .t.) )
      if eof() .or. str(DUPEMP, 2, 0) + dtos(DUPDTP) >  str(AEMP00->EMPCOD, 2, 0) + dtos(M_DTPFIN) 
        select AEMP00
        skip
        loop
      endif
    endif

    do while !eof()

      M_ESC = inkey()
 
      if M_ESC = 27
        M_SAI = decide("Deseja Cancelar o Processamento")
        if M_SAI = 1 
          return ""
        else
          M_ESC = inkey()
        endif
      endif  

      if !M_TIPO == "T"
        if M_TIPO == "A"
          if DUPHIS = 100
            skip
            loop
          endif
        else
          if M_TIPO == "P"
            if DUPHIS = 500
              skip
              loop
            endif
          endif
        endif
      endif

      if M_OPC = 2 
        if eof() .or. str(DUPEMP, 2, 0) + dtos(DUPVCT) >  str(AEMP00->EMPCOD, 2, 0) + dtos(M_VCTFIN)    
          exit
        endif
      endif

      if M_OPC = 3 
        if eof() .or. str(DUPEMP, 2, 0) + dtos(DUPDTE) >  str(AEMP00->EMPCOD, 2, 0) + dtos(M_DTEFIN)    
          exit
        endif
      endif

      if M_OPC = 4
        if eof() .or. str(DUPEMP, 2, 0) + str(DUPCLI, 7, 0) > str(AEMP00->EMPCOD, 2, 0) + str(M_CODFIN, 7, 0) 
          exit
        endif
        if DUPVCT < M_PARINI .or. DUPVCT > M_PARFIN
          skip
          loop
        endif
      endif

      if M_OPC = 5
        if eof() .or. str(DUPEMP, 2, 0) + str(DUPPOR, 5, 0) + str(DUPCLI, 7, 0) > str(AEMP00->EMPCOD, 2, 0) + str(M_PORINI, 5, 0) + str(M_CODFIN, 7, 0) 
          exit
        endif
        if DUPVCT < M_PARINI .or. DUPVCT > M_PARFIN
          skip
          loop
        endif
      endif

      if M_OPC = 6 
        if eof() .or. str(DUPEMP, 2, 0) + dtos(DUPDTP) >  str(AEMP00->EMPCOD, 2, 0) + dtos(M_DTPFIN)    
          exit
        endif
        if DUPDTE < M_PARINI .or. DUPDTE > M_PARFIN
          skip
          loop
        endif
      endif

      ACPG00->(dbseek(str(ADCR00->DUPCPG, 3, 0)))

      if R <= 4000
        aadd(M_DUPMAT,{space(70)})
        aadd(M_DUPNFS,{DUPEMP,DUPNUM,DUPSER})
        M_DUPMAT[R, 1] = str(DUPNUM, 6, 0) + "³" + str(DUPORD, 2, 0) + str(ACPG00->CPGPAR, 1, 0) + "³" + dtoc(DUPDTE) + "³" + dtoc(DUPVCT) + "³" + dtoc(DUPDTP) + "³" + iif(DUPHIS = 100,str((DUPDTP - DUPVCT), 3, 0),"   ")    + "³" + transform(iif(DUPVLA=0,DUPVLP,DUPVLA),"@E ###,###.##") + "³" + str(DUPCLI, 7, 0) + "³" + right(str(DUPPOR, 5, 0),3) + "³" + iif(DUPHIS = 500,str((DUPVCT - date()), 5, 0),"PAGA ")  + "³" + str(DUPEMP, 2, 0)
      endif

      if DUPHIS = 500
        M_TOTDUP = M_TOTDUP + DUPVLA
        if DUPVCT - date() < 0
          M_TOTVEN = M_TOTVEN + DUPVLA
        else
          M_TOTAVE = M_TOTAVE + DUPVLA
        endif
      else
        M_TOTPAG = M_TOTPAG + DUPVLP
      endif

      R = R + 1

      msw("* * * AGUARDE ... PROCESSANDO (ESC) Abandona -=> " + str(R, 5) + " * * *")

      skip

    enddo

    select AEMP00

    skip

  enddo

  setadcr()

  if len(M_DUPMAT) < 8
    declare M_VETORITE[8]
  else
    declare M_VETORITE[len(M_DUPMAT)]
  endif

  for S = 1 to len(M_DUPMAT)
   M_VETORITE[S] = M_DUPMAT[S,1]
   if empty(M_DUPMAT[S,1])
     M_VETORITE[S] = "      ³   ³        ³        ³        ³   ³          ³       ³   ³     ³  "
   endif
  next

    do while .t.

      if len(M_DUPMAT) = 0
        exit
      endif

      ADCR00->( dbsetorder(1) , (dbseek(str(val(substr(M_VETORITE[1], 72, 2)), 2, 0) + str(val(substr(M_VETORITE[1], 1, 6)), 6, 0) + str(val(substr(M_VETORITE[1], 8, 2)), 2, 0))) )
      ACLI00->(dbseek(str(ADCR00->DUPCLI, 7, 0)))

      set color to GR+/B+
        @ 17, 09 say pad(ACLI00->CLINOM , 40)
        @ 17, 59 say padl(alltrim(ACLI00->CLITEL3), 17)
        @ 18, 09 say pad(ADCR00->DUPOBS , 40)
        @ 18, 59 say ADCR00->DUPVLO picture "@E ##,###,###,###.##"
        @ 19, 09 say pad(ADCR00->DUPOBT , 40)
        @ 19, 59 say str(ADCR00->DUPBOL, 7, 0)
        @ 19, 67 say ADCR00->DUPDSC picture "@E ##,###.##"
        @ 20, 09 say ACLI00->CLIAC
        @ 20, 30 say iif(ADCR00->DUPPER=="S","(PERDA)","       ")
      set color to I

      set color to N/W,W+/N
        M_ACHO = achoice(08,03,15,75,M_VETORITE,,"achdcr")
      set color to 

      if lastkey() = 27
        exit        
      endif

  enddo


  set cursor on

return ""

*****************
function SORT_CLI
*****************

select 0

M_ARQTMP = "TM" + substr(time(),1,2) + substr(time(),4,2) + substr(time(),7,2) 
                   
cria_tmp(M_ARQTMP)
use &M_ARQTMP alias ANFS02 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

  setadcr()

  for S = 1 to len(M_DUPMAT)
   select ANFS02
   append blank
   replace NFSMAT with S
   replace NFSDTE with ctod(substr(M_DUPMAT[S,1], 21, 8))
   replace NFSCLI with val(substr(M_DUPMAT[S,1], 54, 7))
   replace NFSOBS with M_DUPMAT[S,1]
  next

  index on str(NFSCLI, 7, 0) + dtos(NFSDTE) tag 1 to &M_ARQTMP

  go top

  R = 1

  do while !eof()
    M_DUPMAT[R,1] = NFSOBS
    R ++
    skip
  enddo

  select ANFS02

  use  

return ""

***************
function EXCDCR
***************
        
private M_DUPEMP ,;
        M_DUPNUM ,;
        M_DUPORD ,;
        M_OPC
             
    do while .t.

      tldcr01() 

        rodape("EXCLUI","DUPLICATA",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP) 

        M_DUPEMP = ME_EMP
        M_DUPNUM = 0
        M_DUPORD = 0

        SetColor(_COREDICAO_)
        @ 07, 26 get     M_DUPNUM   picture "######"
        @ 07, 33 get     M_DUPORD   picture "##"
        read

        if M_DUPNUM = 0
            exit
        endif

        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}
        sqlRELATION = {}

        aadd(sqlARQUI,{"ADCR00","ADCR00"})
        aadd(sqlCAMPO,"ADCR00.*")
        aadd(sqlCAMPO,"ACLI00.CLINOM")
        aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ADCR00.DUPCLI"})
        aadd(sqlCHAVE,"DUPEMP = " + str(ME_EMP,2))
        aadd(sqlCHAVE,"DUPNUM = " + str(M_DUPNUM,9))
        aadd(sqlCHAVE,"DUPORD = " + str(M_DUPORD,2))
        if !sqlrelation()
          msg("* * * DUPLICATA NAO CADASTRADA * * *")
          loop
        endif

        msdcr01()

        M_OPC = confirma("da Duplicata")

        if M_OPC != 1
          msg("* * * DUPLICATA NAO EXCLUIDA * * *")
          loop
        endif
 
       if lastkey() = 27
          msg("* * * DUPLICATA NAO EXCLUIDA * * *")                 
          loop
       endif

    sqlCAMPO = {}
    sqlCHAVE = {}
    sqlARQUI = {"ADCR00","DELETE"}
    aadd(sqlCHAVE,{"DUPEMP",str(ME_EMP,2)})
    aadd(sqlCHAVE,{"DUPORD",str(M_DUPORD,2)})
    aadd(sqlCHAVE,{"DUPNUM",str(M_DUPNUM,9)})
    executasql()

*      select ADCR00

*       do while .t.
*         if rlock()
*           replace DUPEMP with 99
*           replace DUPUSU with M_LOGNOM
*           unlock
*           exit
*         endif
*       enddo
 *
 *      select ALCR00                  && exclui todos os lancamento da duplicata

 *      do while .t.

 *        set softseek on
 *          seek str(M_DUPEMP, 2, 0) + str(M_DUPNUM, 6, 0) + str(M_DUPORD, 2, 0) + "   "
 *        set softseek off
 *
 *        if !str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) == str(M_DUPEMP, 2, 0) + str(M_DUPNUM, 6, 0) + str(M_DUPORD, 2, 0)
 *          exit
 *        endif
 *        elimina()
 *      enddo
 *
        msg("* * * DUPLICATA EXCLUIDA * * *")

    enddo

return ""

***************
function LISDCR
***************
parameters M_OPC,M_OPC1,M_OPC2


        rodape("LISTA","DUPLICATA",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP)  

*          @ 08, 36 prompt   "Perda    " HIGHLITE R/BG
*          @ 09, 36 prompt   "Vencer   " HIGHLITE R/BG
*          @ 10, 36 prompt   "NomeCli  " HIGHLITE R/BG
*          @ 11, 36 prompt   "CodigoCli" HIGHLITE R/BG
*          @ 12, 36 prompt   "Portador " HIGHLITE R/BG
*          @ 13, 36 prompt   "Pagamento" POSITION 2  HIGHLITE R/BG
*          @ 14, 36 prompt   "Sequencia" HIGHLITE R/BG
*          @ 15, 36 prompt   "Emissao  " HIGHLITE R/BG
*          @ 16, 36 prompt   "Cidade   " HIGHLITE R/BG

        do case
           case M_OPC = 1 ; lisdcr_a()
           case M_OPC = 2 ; lisdcr_b()
           case M_OPC = 3 ; lisdcr_c()
           case M_OPC = 4 ; lisdcr_d()
           case M_OPC = 5 ; lisdcr_e()
           case M_OPC = 6 ; lisdcr_f()
           case M_OPC = 7 ; lisdcr_g()
           case M_OPC = 8 ; lisdcr_h(0)
           case M_OPC = 9 ; lisdcr_i()
        endcase

 return ""

*****************
function LISDCR_A
*****************


private M_CLIANT,; 
        M_TOTNOM,;
        M_NOMINI,;
        M_NOMFIN,;
        M_TOTAL ,;
        M_TELA  ,;
        M_TELA1 ,;
        M_QUE   ,;
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_OPC

  M_TELA = savescreen(13, 10, 23, 47)

  store 0   to M_OPC
  store "N" to M_QUE

  do while .t.

      rodape("DUPLICATA","PERDA",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP) 

        M_TELA1 = savescreen(10, 10, 21, 51)

        sombra(14, 14, 16, 50, _SOMBRA_)
        set color to GR+/W+
         @ 14, 14 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
         @ 15, 14 say "³  Data Baixa :                     ³"
         @ 16, 14 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
        set color to 

        M_NOMINI:=M_NOMFIN:=0

        M_EMIINI:=M_EMIFIN:=ctod("  /  /  ")
        M_DUPPOR:=0 
        M_SLDDTA:=date()

        SetColor(_COREDICAO_)
        @ 15, 30 get M_EMIINI valid !empty(M_EMIINI)
*        @ 16, 30 get M_QUE valid(M_QUE $ "SN")
        read 
        
        if lastkey() = 27
          restscreen(10, 10, 21, 51, M_TELA1)
          exit
        endif


  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ADCR00","ADCR00"})
  aadd(sqlCAMPO,"ADCR00.*")
  aadd(sqlCAMPO,"ACLI00.CLIUF3")
  aadd(sqlCAMPO,"ACLI00.CLIUF2")
  aadd(sqlCAMPO,"ACLI00.CLINOM")
  aadd(sqlCAMPO,"ACPG00.CPGPAR")
  aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ADCR00.DUPCLI"})
  aadd(sqlRELATION,{"APOR00","APOR00.PORCOD","ADCR00.DUPPOR"})
  aadd(sqlRELATION,{"ACPG00","ACPG00.CPGCOD","ADCR00.DUPCPG"})


  aadd(sqlCHAVE,"DUPDTP = " + aspas(formatdta(M_EMIINI)))
  aadd(sqlCHAVE,"ADCR00.DUPPER = 'S'")

  aadd(sqlCHAVE,"ADCR00.DUPEMP = " + str(ME_EMP,2))
  aadd(sqlORDEM,"ADCR00.DUPDTP,ADCR00.DUPNUM")

  sqlrelation()

  if eof()
            msg("* * * NADA A LISTAR NO INTERVALO * * *")
            restscreen(10, 10, 21, 51, M_TELA1)
            loop
        endif

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          exit
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        store 0         to PG      ,;
                           M_TOTDUP,;
                           M_GERDUP,;
                           M_TOTPAG,;
                           M_GERPAG

        store space(30) to M_CLIANT 

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                         && comprime
        endif

        M_INI = .t. 

        do while !eof() 
         
            PG++

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO DE PERDAS","EAGRO31",132)
            ? cent_cab(dtoc(M_SLDDTA),"","PAG.: " + str(PG, 4, 0), 132)
            ?     "*-----------*--------------------------------------------*--*---------------*--------*--------*--------*-----*-----------*---------*"
            ?     "* TITULO    * C L I E N T E                              *UF*VALOR ORIGINAL * EMISSAO* VENCTO * PAGTO  *BANCO* DUPLICATA * PRAZO   *"
            ?     "*-----------*--------------------------------------------*--*---------------*--------*--------*--------*-----*-----------*---------*"
 *                  999999/99-9 9999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99 99999 ####,###.## 9999999 


            store 5 to LN
            
            do while !eof() .and. LN < 56 

              if inkey() = 27
                if susimp()
                  ? replicate("-", 132)
                  ? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                endif
              endif

            if M_QUE = "S"
              if !DUPNOM == M_CLIANT
                M_CLIANT = DUPNOM
                if M_INI = .f.
                  ?     space(65)
                  ?? "TOTAL DO CLIENTE    (AB) -=>     "
                  ?? "     R$ "
                  ?? transform(M_TOTDUP, "@E ####,###,###.##") 
                  ?     replicate("-", 132)
                endif 
                M_INI = .f.

            valorescli(DUPCLI)
            select ADCR00

                ?     
                  ?? DUPCLI 
                  ?? " - " 
                  ?? ACLI00->CLINOM
                  ?? " "
                  ?? ACLI00->CLIEND3
                  ?? " "
                  ?? ACLI00->CLIMUN3
                  ?? " "
                  ?? ACLI00->CLIUF3
                  ?? " "
                  ?? ACLI00->CLITEL3
                ?      
                store 0 to M_TOTDUP 
                LN = LN + 4 
              endif
            endif

            ?     " "
              ?? DUPNUM 
              ?? "/"
              ?? strzero(DUPORD, 2, 0) 
              ?? "-"
              ?? str(CPGPAR, 1, 0)
              ?? " "
              ?? DUPCLI
              ?? " "
              ?? pad(CLINOM , 36)
              ?? " "
              ?? CLIUF2
              ?? " "
              ?? transform(DUPVLO,"@E ####,###,###.##") 
              ?? " "
              ?? DUPDTE
              ?? " "
              ?? DUPVCT
              ?? " "
              ?? DUPDTP
              ?? " "
              ?? str(DUPPOR, 5, 0)
              ?? " "
              ?? transform(iif(DUPVLA > 0, DUPVLA, DUPVLO),"@E ####,###.##")
              ?? "     "
              if DUPHIS = 500
                ?? str((DUPVCT - date()), 5, 0)
              else
*                ?? "PAGA "
              endif

            if DUPHIS = 500
              M_TOTDUP = M_TOTDUP + DUPVLA
              M_GERDUP = M_GERDUP + DUPVLA
            else
              M_TOTPAG = M_TOTPAG + DUPVLP
              M_GERPAG = M_GERPAG + DUPVLP
            endif 

            skip
 
            LN++

                if inkey() = 27
                  if susimp()
                    ? replicate("-", 132)
                    ? "* * * IMPRESSAO SUSPENSA * * *"
                    go bottom
                    skip
                  endif
                endif

            enddo

        enddo


        ?     replicate("-", 132)
        ?     padr("TOTAL PERDAS            -=> " + transform(M_GERPAG, "@E ####,###,###.##") + "          ",68)
        ?     replicate("-",132)

    eject 

desliga1()

    restscreen(10, 10, 21, 51, M_TELA1)

  enddo

  restscreen(13, 10, 23, 47, M_TELA)

return ""

*****************
function LISDCR_B
*****************

private M_VCTANT,; 
        M_TOTVCT,;
        M_VCTINI,;
        M_VCTFIN,;
        M_TOTAL ,;
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_OPC   ,;
        M_QUE   ,;
        M_TELA  ,;
        M_TELA1

private SEMANA[7]

declare SEMANA[7]

  SEMANA[1] = "Domingo" 
  SEMANA[2] = "Segunda"
  SEMANA[3] = "Terca  "
  SEMANA[4] = "Quarta "
  SEMANA[5] = "Quinta " 
  SEMANA[6] = "Sexta  "
  SEMANA[7] = "Sabado "

  M_TELA = savescreen(13, 21, 23, 47)

  store 0   to M_OPC
  store "S" to M_QUE

  do while .t.

      rodape("DUPLICATA","VENCIMENTO",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP) 

      M_OPC = msgbox3("Escolha uma opcao..","",,"Abertas","Pagas","Todas")

        if lastkey() = 27
           exit 
        endif 
 
        M_TELA1 = savescreen(10, 20, 21, 52)

        nbox(10, 25, 20, 50,"W/W+",.t.)
        setcolor("B/W")
          @ 11, 26 say "Vencto Inicial:         "
          @ 12, 26 say "         Final:         "
          @ 13, 26 say "EmissaoInicial:         "
          @ 14, 26 say "         Final:         "
          @ 15, 26 say "      Portador:         "
          @ 16, 26 say " Quebra Vencto:         "
          @ 17, 26 say "Data Relatorio:         "
          @ 18, 26 say "Perda S/N     :         "
          @ 19, 26 say "Aluguel S/N/T :         "
        set color to
        M_PER = " "
        M_ALU = " "
        store ctod("  /  /  ")  to M_VCTINI, M_VCTFIN, M_EMIINI, M_EMIFIN
        store date()            to M_SLDDTA
    
        store 0                 to M_DUPPOR

        SetColor(_COREDICAO_)
        @ 11, 42 get M_VCTINI
        @ 12, 42 get M_VCTFIN    
        @ 13, 42 get M_EMIINI    
        @ 14, 42 get M_EMIFIN    
        @ 15, 42 get M_DUPPOR picture "#####"
        @ 16, 42 get M_QUE valid(M_QUE="S" .or. M_QUE= "N")
        @ 17, 42 get M_SLDDTA valid !empty(M_SLDDTA)
        @ 18, 42 get M_PER   picture "@!" valid M_PER $ "SN"
        @ 19, 42 get M_ALU   picture "@!" valid M_ALU $ "SNT"
        read 
        
        if lastkey() = 27
          restscreen(10, 20, 21, 52,M_TELA1)
          loop
        endif

        M_EMIINI = iif(empty(M_EMIINI),ctod("01/01/80"),M_EMIINI)
        M_EMIFIN = iif(empty(M_EMIFIN),ctod("31/12/79"),M_EMIFIN)
        M_VCTINI = iif(empty(M_VCTINI),ctod("01/01/80"),M_VCTINI)
        M_VCTFIN = iif(empty(M_VCTFIN),ctod("31/12/79"),M_VCTFIN)

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ADCR00","ADCR00"})
  aadd(sqlCAMPO,"ADCR00.*")
  aadd(sqlCAMPO,"ACLI00.CLIUF3")
  aadd(sqlCAMPO,"ACLI00.CLINOM")
  aadd(sqlCAMPO,"ACLI00.CLITEL3")
  aadd(sqlCAMPO,"ACPG00.CPGPAR")
  aadd(sqlRELATION,{"ACPG00","ACPG00.CPGCOD","ADCR00.DUPCPG"})
  aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ADCR00.DUPCLI"})
  aadd(sqlCHAVE,"DUPVCT BETWEEN " + aspas(formatdta(M_VCTINI)) + ' and ' + aspas(formatdta(M_VCTFIN)))
  aadd(sqlCHAVE,"DUPDTE BETWEEN " + aspas(formatdta(M_EMIINI)) + ' and ' + aspas(formatdta(M_EMIFIN)))
  aadd(sqlCHAVE,"ADCR00.DUPEMP = " + str(ME_EMP,2))
  if M_DUPPOR > 0
    aadd(sqlCHAVE,"ADCR00.DUPPOR = " + str(M_DUPPOR,5))
  endif
  if M_PER == "N"
    aadd(sqlCHAVE,"ADCR00.DUPPER <> 'S'")
  endif

  if M_OPC = 2
    aadd(sqlCHAVE,"ADCR00.DUPHIS = 100")
  endif


  aadd(sqlORDEM,"ADCR00.DUPVCT,ADCR00.DUPCLI")

  if !sqlrelation()
          msg("* * * NADA A LISTAR NO INTERVALO * * *")
          restscreen(10, 20, 21, 52,M_TELA1)
          loop
        endif 

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          exit
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        store 0    to PG      ,;
                      M_GERDUP,;
                      M_TOTDUP,;
                      M_GERPAG,;
                      M_TOTPAG

        store ctod("  /  /  ")  to M_VCTANT 

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                         && comprime
        endif

        M_PERIODO = 0
        M_PONTUAL = 0
        M_QDETOT  = 0

        M_MENOR30 = 0
        M_MENOR60 = 0
        M_MENOR90 = 0
        M_MENOR   = 0

        do while !eof()
         
            PG++

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO DE DUPLICATAS A RECEBER - VENCIMENTO","EAGRO31",132) 
            ? cent_cab(dtoc(M_SLDDTA),iif(M_ALU = "S", "ALUGUEIS", ""),"PAG.: " + str(PG, 4, 0), 132)
            ?     "*-----------*--------------------------------------------*--*---------------*--------*--------*--------*-----*-----------*---------*"
            ?     "* TITULO    * C L I E N T E                              *UF*   TELEFONE    * EMISSAO* VENCTO * PAGTO  *BANCO* DUPLICATA *  PRAZO  *"
            ?     "*-----------*--------------------------------------------*--*---------------*--------*--------*--------*-----*-----------*---------*"
 *                  999999/99-9 99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX ####,###,###.## 99/99/99 99/99/99 99/99/99 99999 ####,###.## 9999999 

            store 5 to LN
            
            do while !eof() .and. LN < 56 

              if !M_ALU = "T"
                if M_ALU = "S"
                  if !isalug()   // Se nÆo for aluguel
                    select ADCR00
                    skip
                    loop
                  endif
                else
                  if isalug()   // Se for aluguel
                    select ADCR00
                    skip
                    loop
                  endif
                endif
              endif

              M_DUPDTP = iif(HB_ISNIL(DUPDTP),ctod("  /  /  "),DUPDTP)

              M_PERIODO += DUPVLO

              if M_OPC = 1
                if DUPHIS != 500 
                  if M_DUPDTP <= M_SLDDTA
                    skip                  
                    loop
                  endif
                endif
              endif          

            if M_QUE = "S"
              if DUPVCT != M_VCTANT
                M_VCTANT = DUPVCT 
                if M_TOTDUP > 0
                  ?     space(45)
                    ?? transform(M_TOTPAG, "@E ####,###,###.##") 
                    ?? " <=- (PG) TOTAL DO VENCIMENTO (AB) -=>"
                     ?? "     R$ "
                    ?? transform(M_TOTDUP, "@E ####,###,###.##") 
                  ?     replicate("-", 132)
                endif 
                ? " "    
                  ?? DUPVCT 
                  ?? " - " 
                  ?? SEMANA[dow(DUPVCT)]
                ?      
                store 0 to M_TOTDUP ,;
                           M_TOTPAG
                LN = LN + 4 

              endif
            endif

            M_QDETOT ++


            ?     " "
              ?? DUPNUM 
              ?? "/"
              ?? strzero(DUPORD, 2, 0) 
              ?? "-"
              ?? str(iif(HB_ISNIL(CPGPAR),0,CPGPAR), 1, 0)
              ?? " "
              ?? DUPCLI 
              ?? " "
              ?? left(CLINOM , 36)
              ?? " "
              ?? CLIUF3
              ?? " "
              ?? pad(CLITEL3, 15)
              ?? " "
              ?? DUPDTE
              ?? " "
              ?? DUPVCT
              ?? " "
              ?? iif(M_DUPDTP >= M_SLDDTA, "  /  /  ", M_DUPDTP)
              ?? " "
              ?? str(DUPPOR, 5, 0)
              ?? " "
              ?? transform(iif(DUPVLA > 0, DUPVLA, DUPVLO),"@E ####,###.##") 
              ?? "     "

            if DUPHIS = 500
              ?? str((DUPVCT - M_SLDDTA), 5, 0)
            else
              ?? str((DUPVCT - M_DUPDTP), 5, 0)
            endif

            if DUPVCT = M_DUPDTP .or. (M_DUPDTP < DUPVCT)
              M_PONTUAL ++
            elseif (M_DUPDTP - DUPVCT) < 30
              M_MENOR30 ++
            elseif (M_DUPDTP - DUPVCT) < 60
              M_MENOR60 ++
            elseif (M_DUPDTP - DUPVCT) < 90
              M_MENOR90 ++
            else
              M_MENOR ++
            endif

            if DUPHIS = 500
              M_TOTDUP = M_TOTDUP + DUPVLA
              M_GERDUP = M_GERDUP + DUPVLA
            else
              if DUPDTP <= M_SLDDTA
                M_TOTPAG = M_TOTPAG + DUPVLP
                M_GERPAG = M_GERPAG + DUPVLP
              else
                M_TOTDUP = M_TOTDUP + DUPVLO
                M_GERDUP = M_GERDUP + DUPVLO
              endif
            endif 

            skip
 
            LN++

            if inkey() = 27
              if susimp()
                ? replicate("-", 132)
                ? "* * * IMPRESSAO SUSPENSA * * *"
                go bottom
                skip
              endif
            endif

          enddo

        enddo


        ?    replicate("-", 132)
        ?     space(45)
         ?? transform(M_TOTPAG, "@E ####,###,###.##") 
         ?? " <=- (PG) TOTAL DO VENCIMENTO (AB) -=>"
         ?? "     R$ "
         ?? transform(M_TOTDUP, "@E ####,###,###.##") 

        ?     replicate("-", 132)

        ?     space(45)
         ?? transform(M_GERPAG, "@E ####,###,###.##") 
         ?? " <=- (PG) GERAL DO VENCIMENTO (AB) -=>"
         ?? "     R$ "
         ?? transform(M_GERDUP, "@E ####,###,###.##") 
        ?     replicate("-",132) 

/* BLOQUEADO DAQUI PRA BAIXO...

        ?     space(45)
         ?? transform(0, "@E@Z ####,###,###.##") 
         ?? " <=- (PG) FATURAMENTO PERIODO      -=>"
         ?? "     R$ "
         ?? transform(M_PERIODO, "@E ####,###,###.##") 

        ?     space(45)
         ?? transform(0, "@E@Z ####,###,###.##") 
         ?? " % RECEBIDO SOBRE FATURAMENTO      -=>"
         ?? "                 "
         ?? str((M_GERPAG/M_PERIODO)*100,6,2)
         ?? " %"

        ?     space(45)
         ?? transform(0, "@E@Z ####,###,###.##") 
         ?? " % PAGAMENTO PONTUAL               -=>"
         ?? "                 "
         ?? str((M_PONTUAL/M_QDETOT)*100,6,2)
         ?? " %"

        ?     space(45)
         ?? transform(0, "@E@Z ####,###,###.##") 
         ?? " % PAGAMENTO 1 A 30 DIAS           -=>"
         ?? "                 "
         ?? str((M_MENOR30/M_QDETOT)*100,6,2)
         ?? " %"

        ?     space(45)
         ?? transform(0, "@E@Z ####,###,###.##") 
         ?? " % PAGAMENTO 31 A 60 DIAS          -=>"
         ?? "                 "
         ?? str((M_MENOR60/M_QDETOT)*100,6,2)
         ?? " %"


        ?     space(45)
         ?? transform(0, "@E@Z ####,###,###.##") 
         ?? " % PAGAMENTO 61 A 90 DIAS          -=>"
         ?? "                 "
         ?? str((M_MENOR90/M_QDETOT)*100,6,2)
         ?? " %"

        ?     space(45)
         ?? transform(0, "@E@Z ####,###,###.##") 
         ?? " % PAGAMENTO MAIOR QUE 90 DIAS     -=>"
         ?? "                 "
         ?? str((M_MENOR/M_QDETOT)*100,6,2)
         ?? " %"
FIM DO BLOQUEIO */

    eject 

    desliga1()

    restscreen(10, 20, 21, 52,M_TELA1)

  enddo

  restscreen(13, 21, 23, 47, M_TELA)

return ""

*****************
function LISDCR_C
*****************


private M_CLIANT,; 
        M_TOTNOM,;
        M_NOMINI,;
        M_NOMFIN,;
        M_TOTAL ,;
        M_TELA  ,;
        M_TELA1 ,;
        M_QUE   ,;
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_OPC   ,;
        M_DUPVEN

  M_TELA = savescreen(13, 10, 23, 47)

  store 0   to M_OPC
  store "S" to M_QUE

  do while .t.

      rodape("DUPLICATA","ALFABETICA",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP) 

       M_OPC = msgbox3("Escolha uma opcao..","",,"Abertas","Pagas","Todas")

        if lastkey() = 27
           exit 
        endif 

        M_TELA1 = savescreen(10, 10, 21, 51)

 nbox(12, 14, 20, 50,"W/W+",.t.)
 setcolor("B/W")
         @ 13, 15 say "Nome Inicial :                     "
         @ 14, 15 say "       Final :                     "
         @ 15, 15 say "Emissao Inic :                     "
         @ 16, 15 say "       Final :                     "
         @ 17, 15 say "    Portador :       Vendedor:     "
         @ 18, 15 say "Quebra Nome  :                     "
         @ 19, 15 say "Data Relatori:                     "
         @ 20, 15 say "Perda S/N    :                     "
        set color to

        M_NOMINI:=M_NOMFIN:=space(40)
        M_EMIINI:=M_EMIFIN:=ctod("  /  /  ")
        M_DUPPOR:=M_DUPVEN:=0 
        M_SLDDTA:=date()
        M_PER = " "

        SetColor(_COREDICAO_)
        @ 13, 30 get M_NOMINI picture "@!@S20"
        @ 14, 30 get M_NOMFIN picture "@!@S20"
        @ 15, 30 get M_EMIINI 
        @ 16, 30 get M_EMIFIN 
        @ 17, 30 get M_DUPPOR picture "#####"
        @ 17, 46 get M_DUPVEN picture "###"
        @ 18, 30 get M_QUE valid(M_QUE $ "SN")
        @ 19, 30 get M_SLDDTA valid !empty(M_SLDDTA)
        @ 20, 30 get M_PER picture "@!" valid M_PER $ "SN"
        read 
        
        if lastkey() = 27
          restscreen(10, 10, 21, 51, M_TELA1)
          loop
        endif

        M_NOMINI = iif(empty(M_NOMINI),"A"             ,M_NOMINI)
        M_NOMFIN = iif(empty(M_NOMFIN),"ZZZZZZZZZZZZZZ",M_NOMFIN) 

        M_EMIINI = iif(empty(M_EMIINI), ctod("01/01/80"), M_EMIINI)
        M_EMIFIN = iif(empty(M_EMIFIN), ctod("31/12/79"), M_EMIFIN)

        select ADCR00

        set order to 6

        set relation to str(DUPPOR, 5, 0) into APOR00 ,;
                     to str(DUPCLI, 7, 0) into ACLI00 ,; 
                     to str(DUPCPG, 3, 0) into ACPG00

        dbseek(str(ME_EMP, 2, 0) + M_NOMINI,.t.)

        if str(DUPEMP, 2, 0) + DUPNOM > str(ME_EMP, 2, 0) + M_NOMFIN 
          msg("* * * NADA A LISTAR NO INTERVALO * * *")
          set relation to
          set order to 1 
          restscreen(10, 10, 21, 51, M_TELA1)
          loop
        endif 

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          exit
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        store 0         to PG      ,;
                           M_TOTDUP,;
                           M_GERDUP,;
                           M_TOTPAG,;
                           M_GERPAG,;
                           M_TOTPORA,M_TOTPORP,M_GERPORA,M_GERPORP

        store space(30) to M_CLIANT 

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                         && comprime
        endif

        do while !eof() 
         
            PG++

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO DE DUPLICATAS A RECEBER - ALFABETICA","EAGRO31",132)
            ? cent_cab(dtoc(M_SLDDTA),"","PAG.: " + str(PG, 4, 0), 132)
            ?     "*-----------*--------------------------------------------*--*---------------*--------*--------*--------*-----*-----------*---------*"
            ?     "* TITULO    * C L I E N T E                              *UF*VALOR ORIGINAL * EMISSAO* VENCTO * PAGTO  *BANCO* DUPLICATA * PRAZO   *"
            ?     "*-----------*--------------------------------------------*--*---------------*--------*--------*--------*-----*-----------*---------*"
 *                  999999/99-9 9999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99 99999 ####,###.## 9999999 

            store 5 to LN

            if M_DUPVEN > 0
              AVEN00->(dbseek(str(M_DUPVEN, 3, 0)))
              ?
              ? " Vendedor: "
              ?? AVEN00->VENNOM
              ?
              LN += 3             
            endif
            
            do while !eof() .and. LN < 56 

              if str(DUPEMP, 2, 0) + left(DUPNOM,len(alltrim(M_NOMFIN))) > str(ME_EMP, 2, 0) + alltrim(M_NOMFIN)
                go bottom
                skip
                loop
              endif 

              if dtos(DUPDTE) < dtos(M_EMIINI) .or. dtos(DUPDTE) > dtos(M_EMIFIN)
                skip
                loop
              endif

              if M_PER == "N"
                if DUPPER == "S"
                  skip
                  loop
                endif
              endif

              if M_DUPVEN > 0
                if DUPVEN # M_DUPVEN
                  skip
                  loop
                endif
              endif
 
              if !M_DUPPOR = 0
                if !DUPPOR = M_DUPPOR 
                  skip
                  loop
                endif
              endif

              if DUPPOR > 90000
                skip
                loop
              endif

              if M_OPC = 1
                 if DUPHIS != 500
                   if DUPDTP <= M_SLDDTA
                     skip                  
                     loop
                   endif  
                 endif
              endif          

              if M_OPC = 2 
                if DUPHIS != 100 
                  skip 
                  loop
                endif
              endif          
                           
            if M_QUE = "S"
              if !DUPNOM == M_CLIANT
                if M_TOTPORA+M_TOTPORP > 0
                  ?   space(13)
                  ?? "TOTAL DO CLIENTE    (AB) -=> R$ "
                  ?? transform(M_TOTPORA, "@E ####,###,###.##")
                  ?? "  (PG) -=> R$ "
                  ?? transform(M_TOTPORP, "@E ####,###,###.##")
                  ?? "  (AB+PG) -=> R$ "
                  ?? transform(M_TOTPORP+M_TOTPORA, "@E ####,###,###.##")
                  ?     replicate("-", 132)
                  LN += 2
                  M_TOTPORA = 0
                  M_TOTPORP = 0
                endif 

                M_CLIANT = DUPNOM
                if M_TOTDUP > 0
                  ?     space(65)
                    ?? "TOTAL DO CLIENTE    (AB) -=>     "
                     ?? "     R$ "
                    ?? transform(M_TOTDUP, "@E ####,###,###.##") 
                  ?     replicate("-", 132)
                endif 
                ?     
                  ?? DUPCLI 
                  ?? " - " 
                  ?? ACLI00->CLINOM
                  ?? " "
                  ?? ACLI00->CLIEND3
                  ?? " "
                  ?? ACLI00->CLIMUN3
                  ?? " "
                  ?? ACLI00->CLIUF3
                  ?? " "
                  ?? ACLI00->CLITEL3
                ?      
                store 0 to M_TOTDUP 
                LN = LN + 4 
              endif
            endif

            ?     " "
              ?? DUPNUM 
              ?? "/"
              ?? strzero(DUPORD, 2, 0) 
              ?? "-"
              ?? str(ACPG00->CPGPAR, 1, 0)
              ?? " "
              ?? DUPCLI
              ?? " "
              ?? pad(ACLI00->CLINOM , 36)
              ?? " "
              ?? ACLI00->CLIUF2 
              ?? " "
              ?? transform(DUPVLO,"@E ####,###,###.##") 
              ?? " "
              ?? DUPDTE
              ?? " "
              ?? DUPVCT
              ?? " "
              ?? iif(DUPDTP >= M_SLDDTA, "  /  /  ", DUPDTP)
              ?? " "
              ?? str(DUPPOR, 5, 0)
              ?? " "
              ?? transform(iif(DUPVLA > 0, DUPVLA, DUPVLO),"@E ####,###.##")
              ?? "     "
              if DUPHIS = 500
                ?? str((DUPVCT - M_SLDDTA), 5, 0)
              else
                if DUPDTP <= M_SLDDTA
                  ?? "PAGA "
                else
                  ?? str((DUPVCT - M_SLDDTA), 5, 0)
                endif 
              endif

            if DUPHIS = 500
              M_TOTDUP = M_TOTDUP + DUPVLA
              M_GERDUP = M_GERDUP + DUPVLA
            else
              if DUPDTP <= M_SLDDTA
                M_TOTPAG = M_TOTPAG + DUPVLP
                M_GERPAG = M_GERPAG + DUPVLP
              else
                M_TOTDUP = M_TOTDUP + DUPVLO
                M_GERDUP = M_GERDUP + DUPVLO
              endif
            endif 

            M_TOTPORA += DUPVLA
            M_TOTPORP += DUPVLP
            M_GERPORA += DUPVLA
            M_GERPORP += DUPVLP

            skip
 
            LN++

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

        if M_TOTPORA+M_TOTPORP > 0
          ?   space(13)
          ?? "TOTAL DO CLIENTE    (AB) -=> R$ "
          ?? transform(M_TOTPORA, "@E ####,###,###.##")
          ?? "  (PG) -=> R$ "
          ?? transform(M_TOTPORP, "@E ####,###,###.##")
          ?? "  (AB+PG) -=> R$ "
          ?? transform(M_TOTPORP+M_TOTPORA, "@E ####,###,###.##")
          ?     replicate("-", 132)
          LN += 2
          M_TOTPORA = 0
          M_TOTPORP = 0
        endif 

          ?   space(13)
          ?? "TOTAL GERAL         (AB) -=> R$ "
          ?? transform(M_GERPORA, "@E ####,###,###.##")
          ?? "  (PG) -=> R$ "
          ?? transform(M_GERPORP, "@E ####,###,###.##")
          ?? "  (AB+PG) -=> R$ "
          ?? transform(M_GERPORP+M_GERPORA, "@E ####,###,###.##")
          ?     replicate("-", 132)

    eject 

desliga1()

    restscreen(10, 10, 21, 51, M_TELA1)

  enddo

  restscreen(13, 10, 23, 47, M_TELA)

return ""

*****************
function LISDCR_D                       && relacao por CODIGO DE CLIENTE
*****************

private M_CLIANT,; 
        M_TOTCLI,;
        M_CLIINI,;
        M_CLIFIN,;
        M_TOTAL ,;
        M_TELA  ,;
        M_TELA1 ,;
        LN      ,;
        PG      ,;
        M_OPC   ,;
        M_ESC 

  M_TELA = savescreen(13, 10, 23, 50)

  store 0   to M_OPC
  store "S" to M_QUE

  set key -1 to FUNCLI()

  select ALCR00
  set relation to str(LANEMP, 2, 0) + str(LANHIS, 3, 0) into AMOV00
 
  do while .t.

      rodape("DUPLICATA","CLIENTE",M_FAN,"EA0RO31A","Mem: " + str(memory(0), 5),M_EMP) 

      M_OPC = msgbox3("Escolha uma opcao..","",,"Abertas","Pagas","Todas")

        if lastkey() = 27
           exit 
        endif 

        M_TELA1 = savescreen(13, 23, 21, 55)

        M_PERINI := M_PERFIN := ctod("  /  /  ")
        M_ALU    := " "

 nbox(13, 27, 20, 52,"W/W+",.t.)
 setcolor("B/W")
          @ 14, 28 say   " C¢digo Inicial:          "
          @ 15, 28 say   "          Final:          "
          @ 16, 28 say   "EmissÆo Inicial:          "
          @ 17, 28 say   "          Final:          "
          @ 18, 28 say   "  Quebra C¢digo:          "
          @ 19, 28 say   "Aluguel S/N/T  :          "
        set color to

        store 0 to M_DUPCLI ,;
                   M_CLIFIN

        SetColor(_COREDICAO_)
        @ 14, 45 get M_DUPCLI picture "#######"
        @ 15, 45 get M_CLIFIN picture "#######"    
        @ 16, 45 get M_PERINI
        @ 17, 45 get M_PERFIN
        @ 18, 45 get M_QUE valid(M_QUE="S" .or. M_QUE= "N") picture "@!"
        @ 19, 45 get M_ALU valid(M_ALU $ "SNT")             picture "@!"
        read 
        
        if lastkey() = 27
          restscreen(13, 23, 21, 55,M_TELA1)
          loop
        endif

        M_PERINI = iif(dtoc(M_PERINI) = "  /  /  ",ctod("01/01/80"),M_PERINI)
        M_PERFIN = iif(dtoc(M_PERFIN) = "  /  /  ",ctod("31/12/79"),M_PERFIN) 

        M_CLIINI = iif(M_DUPCLI = 0,       1,M_DUPCLI)
        M_CLIFIN = iif(M_CLIFIN = 0, 9999999,M_CLIFIN) 

        select ADCR00

        set order to 2

        set relation to str(DUPCLI, 7, 0) into ACLI00 ,;
                     to str(DUPPOR, 5, 0) into APOR00 ,;
                     to str(DUPCPG, 3, 0) into ACPG00 


        M_IMPRE = impresn()

        if M_IMPRE = "N"
          exit
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        store 0    to PG,LN   ,;
                      M_CLIANT,;
                      M_TOTDUP,;
                      M_GERDUP,;
                      M_TOTPAG,;
                      M_GERPAG,;
                      M_ATZCLI,;
                      M_ATZGER

    cabdcr04()
  
    select ADCR00

    ( dbsetorder(2) , dbseek(str(ME_EMP, 2, 0) + str(M_DUPCLI, 7, 0), .t.) ) 
  
      do while !eof()

        if eof() .or. str(DUPEMP, 2, 0) + str(DUPCLI, 7 ,0) > str(ME_EMP, 2, 0) + str(M_CLIFIN, 7, 0)
          exit
        endif 

        if DUPPOR > 90000
          skip
          loop
        endif

*          if DUPPER == "S"
*            skip
*            loop
*          endif

        if DUPDTE > M_PERFIN .or. DUPDTE < M_PERINI
          skip
          loop
        endif

        if M_OPC = 1  // ABERTAS
          if DUPHIS # 500
            skip
            loop
          endif
        endif

        M_VALPAG = pega_pagas()

        select ADCR00

        if M_OPC = 2 // PAGAS
          if DUPHIS # 100 .and. M_VALPAG = 0
            skip
            loop
          endif
        endif

        if !M_ALU = "T"
          if M_ALU = "S"
            if !isalug()   // Se nÆo for aluguel
              select ADCR00
              skip
              loop
            endif
          else
            if isalug()   // Se for aluguel
              select ADCR00
              skip
              loop
            endif
          endif
        endif

        if M_QUE = "S"
          if DUPCLI != M_CLIANT
            M_CLIANT = DUPCLI 
             if M_TOTDUP > 0
               ?  space(18)
                 ?? "VENCIDOS: "
                 ?? transform(M_ATZCLI, "@E ##,###,###.##") 
                 ?? "  VENCER: "
                 ?? transform(M_TOTDUP-M_ATZCLI, "@E ##,###,###.##") 
                 ?? "  TOTAL DO CLIENTE    (AB) -=>     "
                  ?? "     R$ "
                 ?? transform(M_TOTDUP, "@E ####,###,###.##") 
               ?     replicate("-", 132)
             endif 
             ?     
               ?? DUPCLI 
               ?? " - " 
               ?? ACLI00->CLINOM
               ?? " "
               ?? ACLI00->CLIMUN3
               ?? " "
               ?? ACLI00->CLIUF3
               ?? " "
               ?? ACLI00->CLITEL3
             ?      
             store 0 to M_TOTDUP,;
                        M_ATZCLI
             LN = LN + 4 
             iif(LN > 60,cabdcr04(),"")
           endif
         endif

         ? " "
          ?? DUPNUM 
          ?? "/"
          ?? strzero(DUPORD, 2, 0) 
          ?? "-"
          ?? str(ACPG00->CPGPAR, 1, 0)
          ?? " "
          ?? DUPPOR 
          ?? " "
          ?? left(APOR00->PORNOM , 20)
          ?? " "
          ?? pad(DUPOBS, 17)   
          ?? " "
          ?? APOR00->POREST 
          ?? " "
          ?? transform(DUPVLO,"@E ####,###,###.##") 
          ?? " "
          ?? DUPDTE
          ?? " "
          ?? DUPVCT
          ?? " "
          ?? DUPDTP
          ?? " "
          ?? str(DUPPOR, 5, 0)
          ?? " "
    
          if M_OPC = 1 // ABERTOS
            ?? transform(DUPVLA,"@E #,###,###.##")
          else
            ?? transform(M_VALPAG,"@E #,###,###.##")
          endif

          ?? " "
          ??  iif(DUPHIS = 500,str((DUPVCT - date()), 5, 0),"PAGA ")  
          ?? " "
          ?? str(DUPEMP, 2, 0)

          if DUPHIS = 500
            M_TOTDUP = M_TOTDUP + DUPVLA
            M_GERDUP = M_GERDUP + DUPVLA
            if (DUPVCT - date()) < 0
               M_ATZCLI = M_ATZCLI + DUPVLA
               M_ATZGER = M_ATZGER + DUPVLA
            endif
          else
            M_TOTPAG = M_TOTPAG + M_VALPAG
            M_GERPAG = M_GERPAG + M_VALPAG
          endif 

          skip
 
          LN = LN + 1

          iif(LN > 60,cabdcr04(),"")
             
          M_ESC = inkey()

          if M_ESC = 27
            if susimp()
              ? replicate("-", 132)
              ? "* * * IMPRESSAO SUSPENSA * * *"
              select AEMP00
              go bottom 
              skip   
              exit
            else
              M_ESC = inkey()
            endif
          endif

      enddo

    if M_TOTDUP > 0
      ? replicate("-", 132)
      ?  space(18)
      ?? "VENCIDOS: "
      ?? transform(M_ATZCLI, "@E ##,###,###.##") 
      ?? "  VENCER: "
      ?? transform(M_TOTDUP-M_ATZCLI, "@E ##,###,###.##") 
      ?? "  TOTAL DO CLIENTE    (AB) -=>     "
      ?? "     R$ "
      ?? transform(M_TOTDUP, "@E ####,###,###.##") 
      ? replicate("-", 132)

      ?  space(18)
      ?? "VENCIDOS: "
      ?? transform(M_ATZGER, "@E ##,###,###.##") 
      ?? "  VENCER: "
      ?? transform(M_GERDUP-M_ATZGER, "@E ##,###,###.##") 
      ?? "  TOTAL GERAL         (AB) -=>     "
      ?? "     R$ "
      ?? transform(M_GERDUP, "@E ####,###,###.##") 
      ?     replicate("-",132) 
    endif

    if M_TOTPAG > 0
      ? replicate("-", 132)
      ?  space(18)
      ?? "          "
      ?? transform(0, "@E@Z ##,###,###.##") 
      ?? "          "
      ?? transform(0, "@E@Z ##,###,###.##") 
      ?? "  TOTAL DO CLIENTE    (PG) -=>     "
      ?? "     R$ "
      ?? transform(M_TOTPAG, "@E ####,###,###.##") 
      ? replicate("-", 132)

      ?  space(18)
      ?? "          "
      ?? transform(0, "@E@Z ##,###,###.##") 
      ?? "          "
      ?? transform(0, "@E@Z ##,###,###.##") 
      ?? "  TOTAL GERAL         (PG) -=>     "
      ?? "     R$ "
      ?? transform(M_GERPAG, "@E ####,###,###.##") 
      ?     replicate("-",132) 
    endif

    eject 

    desliga1()

    restscreen(13, 23, 21, 55,M_TELA1)

  enddo

  restscreen(13, 10, 23, 50, M_TELA)

  select ALCR00
  set relation to

return ""

*******************
function PEGA_PAGAS
*******************

select ALCR00
set order to 1
dbseek(str(ME_EMP, 2, 0) + str(ADCR00->DUPNUM, 6, 0) + str(ADCR00->DUPORD, 2, 0),.t.)

M_VALPAG = 0
         
do while !eof()

  if !str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) == str(ME_EMP, 2, 0) + str(ADCR00->DUPNUM, 6, 0) + str(ADCR00->DUPORD, 2, 0)
    exit
  endif 
  
  if AMOV00->MOVTIP == "C"
    M_VALPAG += LANVAL
  endif

  skip 

enddo

return M_VALPAG

*****************         
function CABDCR04
*****************

  store PG + 1 to PG

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"RELACAO DE DUPLICATAS POR CLIENTE","EAGRO31",132) 
  ? cent_cab(M_DATA,iif(M_ALU = "S", "ALUGUEIS", ""),"PAG.: " + str(PG, 4, 0), 132)
  ? "*-----------*--------------------------*-----------------*--*---------------*--------*--------*--------*-----*------------*-----*--*"
  ? "* TITULO    * P O R T A D O R          *   OBSERVACOES   *UF* VALOR ORIGINAL* EMISSAO* VENCTO * PAGTO  *BANCO*  DUPLICATA *PRAZO*LJ*"
  ? "*-----------*--------------------------*-----------------*--*---------------*--------*--------*--------*-----*------------*-----*--*"
 *    999999/99-9 99999 XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99 99999 #,###,###.## 99999 99 
            
  store 5 to LN

return ""

*****************
function LISDCR_E
*****************

private M_CLIANT,; 
        M_TOTPOR,;
        M_PORINI,;
        M_PORFIN,;
        M_TOTAL ,;
        M_TELA  ,;
        M_TELA1 ,;
        LN      ,;
        PG      ,;
        M_OPC   ,;
        M_ESC 

  M_TELA = savescreen(13, 10, 23, 47)

  store 0   to M_OPC
  store "S" to M_QUE

  do while .t.

      rodape("DUPLICATA","PORTADOR",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP) 

      M_OPC = msgbox3("Escolha uma opcao..","",,"Abertas","Pagas","Todas")

        if lastkey() = 27
           exit 
        endif 

        M_TELA1 = savescreen(16, 20, 21, 51)

 nbox(16, 20, 20, 50,"W/W+",.t.)
 setcolor("B/W")
          @ 17, 21 say "Portador:          a         "
          @ 18, 21 say " Periodo:          a         "
          @ 19, 21 say "Quebra  :                    "
        set color to

        store 0 to M_PORINI ,;
                   M_PORFIN

       store ctod("  /  /  ") to M_PERINI ,;
                                 M_PERFIN 

        SetColor(_COREDICAO_)
        @ 17, 31 get M_PORINI picture "#####"
        @ 17, 42 get M_PORFIN picture "#####"    
        @ 18, 31 get M_PERINI
        @ 18, 42 get M_PERFIN
        @ 19, 31 get M_QUE valid(M_QUE="S" .or. M_QUE= "N")
        read 
        
        if lastkey() = 27
          restscreen(16, 20, 21, 51,M_TELA1)
          loop
        endif

        M_PORINI = iif(M_PORINI = 0,     1,M_PORINI)
        M_PORFIN = iif(M_PORFIN = 0, 99999,M_PORFIN) 

        select ADCR00

        set relation to str(DUPPOR, 5, 0) into APOR00 ,;
                     to str(DUPCLI, 7, 0) into ACLI00 ,;
                     to str(DUPCPG, 3, 0) into ACPG00

        set order to 3

        set softseek on 
          seek str(ME_EMP, 2, 0) + str(M_PORINI, 5, 0)
        set softseek off

        if str(DUPEMP, 2, 0) + str(DUPPOR, 5, 0) > str(ME_EMP, 2, 0) + str(M_PORFIN, 5, 0)
          msg("* * * NADA A LISTAR NO INTERVALO")
          set relation to
          set order to 1 
          restscreen(16, 20, 21, 51,M_TELA1)
          loop
        endif 

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          exit
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        store 0         to PG      ,;
                           M_TOTDUP,;
                           M_GERDUP,;
                           M_PORANT

        do while !eof() 
         
            store PG + 1 to PG

            if PG > 1
                eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO DE DUPLICATAS POR PORTADOR","EREC40",132) 
            ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
            ?     "*-----------*--------------------------------------------*--*---------------*--------*--------*--------*-----*-----------*---------*"
            ?     "* TITULO    * C L I E N T E                              *UF*   TELEFONE    * EMISSAO* VENCTO * PAGTO  *BANCO* DUPLICATA *  PRAZO  *"
            ?     "*-----------*--------------------------------------------*--*---------------*--------*--------*--------*-----*-----------*---------*"
 *                  999999/99-9 99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99 99999 ####,###.## 999999999 
            
            store 5 to LN

            do while !eof() .and. LN < 56 

              if str(DUPEMP, 2, 0) + str(DUPPOR, 5 ,0) > str(ME_EMP, 2, 0) + str(M_PORFIN, 5, 0)
                go bottom
                skip
                loop
              endif 

              if DUPVCT < M_PERINI .or. DUPVCT > M_PERFIN
                skip
                loop
              endif

*          if DUPPER == "S"
*            skip
*            loop
*          endif

              if M_OPC = 1
                if DUPHIS != 500 
                   skip                  
                   loop
                endif
              endif          

              if M_OPC = 2 
                if DUPHIS != 100 
                  skip 
                  loop
                endif
              endif          

            if M_QUE = "S"
             if DUPPOR != M_PORANT
               M_PORANT = DUPPOR 
                if M_TOTDUP > 0
                  ?     space(65)
                    ?? "TOTAL DO PORTADOR   (AB) -=>     "
                     ?? "     R$ "
                    ?? transform(M_TOTDUP, "@E ####,###,###.##") 
                  ?     replicate("-", 132)

                endif 
                ?     
                  ?? DUPPOR 
                  ?? " - " 
                  ?? APOR00->PORNOM
                  ?? " "
                  ?? APOR00->PORMUN
                  ?? " "
                  ?? APOR00->POREST
                  ?? " "
                  ?? APOR00->PORTEL 
                ?      
                store 0 to M_TOTDUP
                LN = LN + 4 
              endif
            endif

            ?     " "
              ?? DUPNUM 
              ?? "/"
              ?? strzero(DUPORD, 2, 0) 
              ?? "-"
              ?? str(ACPG00->CPGPAR, 1, 0)
              ?? " "
              ?? DUPCLI 
              ?? " "
              ?? left(ACLI00->CLINOM , 36)
              ?? " "
              ?? ACLI00->CLIUF3 
              ?? " "
              ?? pad(ACLI00->CLITEL3, 15)
              ?? " "
              ?? DUPDTE
              ?? " "
              ?? DUPVCT
              ?? " "
              ?? DUPDTP
              ?? " "
              ?? str(DUPPOR, 5, 0)
              ?? " "
              ?? transform(DUPVLA,"@E ####,###.##") 
              ?? "     "
              ??  iif(DUPHIS = 500,str((DUPVCT - date()), 5, 0),"PAGA ")  

            if DUPHIS = 500
              M_TOTDUP = M_TOTDUP + DUPVLA
              M_GERDUP = M_GERDUP + DUPVLA
            endif 

            skip
 
            LN = LN + 1

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

        ?     space(65)
          ?? "TOTAL DO PORTADOR   (AB) -=>     "
          ?? "     R$ "
          ?? transform(M_TOTDUP, "@E ####,###,###.##") 
        ?     replicate("-", 132)
        ?     space(68)
          ?? "TOTAL G E R A L  (AB) -=>     "
          ?? "     R$ "
          ?? transform(M_GERDUP, "@E ####,###,###.##") 
        ?     replicate("-",132) 

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(18)                        && descomprime
        endif

        eject 

desliga1()

    restscreen(16, 20, 21, 51,M_TELA1)

  enddo

  restscreen(13, 10, 23, 47, M_TELA)

return ""

*****************
function LISDCR_F
*****************

private M_DTPANT,; 
        M_TOTDTP,;
        M_DTPINI,;
        M_DTPFIN,;
        M_TOTAL ,;
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_OPC   ,;
        M_QUE   ,;
        M_TELA  

private SEMANA[7]

declare SEMANA[7]

  SEMANA[1] = "Domingo" 
  SEMANA[2] = "Segunda"
  SEMANA[3] = "Terca  "
  SEMANA[4] = "Quarta "
  SEMANA[5] = "Quinta " 
  SEMANA[6] = "Sexta  "
  SEMANA[7] = "Sabado "

  M_TELA = savescreen(13, 21, 23, 67)

  store 0   to M_OPC
  store "S" to M_QUE

  do while .t.

     rodape("DUPLICATA","PAGAMENTO",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP) 

 nbox(13, 41, 18, 66,"W/W+",.t.)
 setcolor("B/W")
       @ 14, 42 say                    "Pagto Inicial :         "
       @ 15, 42 say                    "        Final :         "
       @ 16, 42 say                    " Quebra Pagto :         "
       @ 17, 42 say                    "     Vendedor :         "
     set color to

        store ctod("  /  /  ")        to M_DTPINI
        store ctod("  /  /  ")        to M_DTPFIN
        M_DUPVEN = 0

        SetColor(_COREDICAO_)
        @ 14, 58 get M_DTPINI
        @ 15, 58 get M_DTPFIN     
        @ 16, 58 get M_QUE valid(M_QUE="S" .or. M_QUE= "N")
        @ 17, 58 get M_DUPVEN picture "999"
        read 
        
        if lastkey() = 27
          exit
        endif

        M_DTPINI = iif(dtoc(M_DTPINI) = "  /  /  ",ctod("01/01/80"),M_DTPINI)
        M_DTPFIN = iif(dtoc(M_DTPFIN) = "  /  /  ",ctod("31/12/79"),M_DTPFIN) 

        select ADCR00

        set order to 7 

        set relation to str(DUPCLI, 7, 0) into ACLI00 ,; 
                     to str(DUPCPG, 3, 0) into ACPG00

        set softseek on 
          seek str(ME_EMP, 2, 0) + dtos(M_DTPINI)
        set softseek off

        if str(DUPEMP, 2, 0) + dtos(DUPDTP) > str(ME_EMP, 2, 0) + dtos(M_DTPFIN) 
          msg("* * * NADA A LISTAR NO INTERVALO")
          set relation to
          set order to 1 
          restscreen(13, 21, 23, 67,M_TELA)
          loop
        endif 

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          exit
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        store 0         to PG      ,;
                           M_TOTDUP,;
                           M_GERDUP,; 
                           M_TOTJUR,;
                           M_GERJUR

        store ctod("  /  /  ")  to M_DTPANT 

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                         && comprime
        endif

        do while !eof() 
         
            store PG + 1 to PG

            if PG > 1
                eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO DE DUPLICATAS POR PAGAMENTO","EAGRO31",132) 
            ? cent_cab(M_DATA,"PEDIODO: " + dtoc(M_DTPINI) + " A " + dtoc(M_DTPFIN),"PAG.: " + str(PG, 4, 0), 132)
            ?     "*-----------*--------------------------------------------*--*---------------*--------*--------*--------*-----*-----------*---------*"
            ?     "* TITULO    * C L I E N T E                              *UF*   TELEFONE    * EMISSAO* VENCTO * PAGTO  *BANCO* DUPLICATA * ATRASO  *"
            ?     "*-----------*--------------------------------------------*--*---------------*--------*--------*--------*-----*-----------*---------*"
 *                  999999/99-9 99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99 99999 ####,###.## 

            store 5 to LN

            if M_DUPVEN > 0
              AVEN00->(dbseek(str(M_DUPVEN, 3, 0)))
              ?
              ? " Vendedor: "
              ?? AVEN00->VENNOM
              ?
              LN += 3             
            endif
            
            do while !eof() .and. LN < 56 

              if str(DUPEMP, 2, 0) + dtos(DUPDTP) > str(ME_EMP, 2, 0) + dtos(M_DTPFIN) 
                go bottom
                skip
                loop
              endif 

              if M_DUPVEN > 0
                if DUPVEN # M_DUPVEN
                  skip 
                  loop
                endif
              endif

*              if DUPPER == "S"
*                skip
*                loop
*              endif

             if DUPPOR > 90000 
                skip
               loop
             endif

             if DUPHIS != 100 
               skip 
               loop
             endif
                           
            if M_QUE = "S"
              if DUPDTP != M_DTPANT
                M_DTPANT = DUPDTP 
                if M_TOTDUP > 0
                  ?     space(45)
                    ?? transform(M_TOTDUP + M_TOTJUR, "@E ####,###,###.##") 
                    ?? " <=- TOTAL DO PAGAMENTO  (PG) -=>     "
                     ?? "     R$ "
                    ?? transform(M_TOTDUP, "@E ####,###,###.##") 
                     ?? " "
                    ?? transform(M_TOTJUR, "@E@Z ##,###.##") 
                  ?     replicate("-", 132)

                endif 
                ? " "    
                  ?? DUPDTP 
                  ?? " - " 
                  ?? SEMANA[dow(DUPDTP)]
                ?      
                store 0 to M_TOTDUP
                LN = LN + 4 
              endif
            endif

            ?     " "
              ?? DUPNUM 
              ?? "/"
              ?? strzero(DUPORD, 2, 0) 
              ?? "-"
              ?? str(ACPG00->CPGPAR, 1, 0)
              ?? " "
              ?? str(DUPCLI,5)
              ?? " "
              ?? left(ACLI00->CLINOM , 38)
              ?? " "
              ?? ACLI00->CLIUF3 
              ?? " "
              ?? pad(ACLI00->CLITEL3, 15)
              ?? " "
              ?? DUPDTE
              ?? " "
              ?? DUPVCT
              ?? " "
              ?? DUPDTP
              ?? " "
              ?? str(DUPPOR, 5, 0)
              ?? " "
              ?? transform(DUPVLP,"@E ####,###.##") 
              ?? " "
              ?? str(DUPVCT-DUPDTP,6)

              if DUPHIS = 100
                M_TOTDUP = M_TOTDUP + DUPVLP
                M_TOTJUR = M_TOTJUR + DUPJUR +  DUPTAX 
                M_GERDUP = M_GERDUP + DUPVLP
                M_GERJUR = M_GERJUR + DUPJUR + DUPTAX
              endif 

              skip
 
              LN = LN + 1

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

        ?     space(45)
         ?? transform(M_TOTDUP + M_TOTJUR, "@E ####,###,###.##") 
         ?? " <=- TOTAL DO PAGAMENTO  (PG) -=>     "
         ?? "     R$ "
         ?? transform(M_TOTDUP, "@E ####,###,###.##") 
         ?? " "
         ?? transform(M_TOTJUR, "@E@Z ##,###.##") 

        ?     replicate("-", 132)
        ?     space(45)
          ?? transform(M_GERDUP + M_GERJUR, "@E ####,###,###.##") 
          ?? "    <=- TOTAL G E R A L  (PG) -=>     "
          ?? "     R$ "
          ?? transform(M_GERDUP, "@E ####,###,###.##") 
          ?? " "
          ?? transform(M_GERJUR, "@E@Z ##,###.##") 
        ?     replicate("-",132) 

    eject 

desliga1()

  enddo

  restscreen(13, 21, 23, 67, M_TELA)

return ""

*****************
function LISDCR_G
*****************

private M_DTPANT,; 
        M_TOTDTP,;
        M_DTPINI,;
        M_DTPFIN,;
        M_TOTAL ,;
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_OPC   ,;
        M_QUE   ,;
        M_TELA  

private SEMANA[7]

declare SEMANA[7]

  SEMANA[1] = "Domingo" 
  SEMANA[2] = "Segunda"
  SEMANA[3] = "Terca  "
  SEMANA[4] = "Quarta "
  SEMANA[5] = "Quinta " 
  SEMANA[6] = "Sexta  "
  SEMANA[7] = "Sabado "

  M_TELA = savescreen(13, 21, 23, 67)

  store 0   to M_OPC
  store "S" to M_QUE
  store 0 to M_TOTDUP

  do while .t.

     rodape("DUPLICATA","SEQUENCIAL",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP)

     sombra(13, 41, 15, 68,_SOMBRA_)

     set color to GR+/W+
       @ 13, 41 say                    "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
       @ 14, 41 say                    "³Duplic Numero : ######/## ³"
       @ 15, 41 say                    "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
     set color to 

    store 0 to M_DUPNUM, M_DUPORD
        SetColor(_COREDICAO_)
    @ 14, 58 get M_DUPNUM picture "######"
    @ 14, 65 get M_DUPORD picture "##"
    read 
        
    if lastkey() = 27
      exit
    endif

    select ADCR00

    set order to 1 

    set relation to str(DUPCLI, 7, 0) into ACLI00  

    if !dbseek(str(ME_EMP, 2, 0) + str(M_DUPNUM, 6, 0) + str(M_DUPORD, 2, 0))
      msg("* * * DUPLICATA NAO CADASTRADA * * *")
      loop
    endif

    set printer to &_IMPNOR_
    set print on

    if !impdsl()                         && impressora ligada ?
      set print off
      loop
    endif

    msw("* * * AGUARDE ... IMPRIMINDO * * *")
    set console off

    ? " TITULO: " + str(DUPNUM, 6, 0) + "/" + str(DUPORD, 2, 0) + " " + pad(ACLI00->CLINOM, 45) + " " + transform(DUPVLP, "@E@Z ###,###,###.##")
    M_TOTDUP = M_TOTDUP + DUPVLP
 
    set print off
    set printer to
    set console on 
    set cursor on 
    set relation to
    set order to 1

  enddo

  do while .t.

    set printer to &_IMPNOR_
    set print on
    if !impdsl()                         && impressora ligada ?
      set print off
      loop      
    endif

    msw("* * * AGUARDE ... IMPRIMINDO * * *")
    set console off

    exit

  enddo

  if M_TOTDUP > 0
    ?
    ? "TOTAIS -=> " + transform(M_TOTDUP, "@E@Z ###,###,###.##")
  endif

  set print off
  set printer to
  set console on 
  set cursor on 
  set relation to
  set order to 1

  restscreen(13, 21, 23, 67, M_TELA)

return ""

*****************
function LISDCR_H(TIPO)
*****************

private M_VCTANT,; 
        M_TOTVCT,;
        M_VCTINI,;
        M_VCTFIN,;
        M_TOTAL ,;
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_OPC   ,;
        M_QUE   ,;
        M_TELA  ,;
        M_TELA1

private SEMANA[7]

declare SEMANA[7]

  SEMANA[1] = "Domingo" 
  SEMANA[2] = "Segunda"
  SEMANA[3] = "Terca  "
  SEMANA[4] = "Quarta "
  SEMANA[5] = "Quinta " 
  SEMANA[6] = "Sexta  "
  SEMANA[7] = "Sabado "

  M_TELA = savescreen(13, 21, 23, 47)

  store 0   to M_OPC
  store "S" to M_QUE

  do while .t.

      if TIPO = 0
        rodape("DUPLICATA","EMISSAO",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP) 

        M_OPC = msgbox3("Escolha uma opcao..","",,"Abertas","Pagas","Todas")

          if lastkey() = 27
           exit 
        endif 
 
        M_TELA1 = savescreen(12, 20, 21, 51)

 nbox(12, 25, 18, 50,"W/W+",.t.)
 setcolor("B/W")
          @ 13, 26 say "Emiss. Inicial:         "
          @ 14, 26 say "         Final:         "
          @ 15, 26 say "      Portador:         "
          @ 16, 26 say " Quebra Vencto:         "
          @ 17, 26 say " Condicao Pgto:         "
        set color to

        store ctod("  /  /  ")  to M_VCTINI, M_VCTFIN, M_EMIINI, M_EMIFIN
        store date()            to M_SLDDTA
    
        store 0                 to M_DUPPOR, M_DUPCPG

        SetColor(_COREDICAO_)
        @ 13, 42 get M_EMIINI
        @ 14, 42 get M_EMIFIN
        @ 15, 42 get M_DUPPOR picture "#####"
        @ 16, 42 get M_QUE valid(M_QUE="S" .or. M_QUE= "N")
        @ 17, 42 get M_DUPCPG picture "999"
        read 
        
        if lastkey() = 27
          restscreen(12, 20, 21, 51,M_TELA1)
          loop
        endif

        M_EMIINI = iif(empty(M_EMIINI),ctod("01/01/80"),M_EMIINI)
        M_EMIFIN = iif(empty(M_EMIFIN),ctod("31/12/79"),M_EMIFIN)
      else
        store date()            to M_SLDDTA
        M_TELA1 = savescreen(12, 20, 21, 51)
        M_DUPCPG = 0
        M_DUPPOR = 0
        M_EMIINI = M_DATA1
        M_EMIFIN = M_DATA2
        store "N" to M_QUE
        M_OPC = 1
      endif
       
        select ADCR00

        set order to 4 

        set relation to str(DUPCLI, 7, 0) into ACLI00 ,; 
                     to str(DUPCPG, 3, 0) into ACPG00

        dbseek(str(ME_EMP, 2, 0) + dtos(M_EMIINI),.t.)

        if str(DUPEMP, 2, 0) + dtos(DUPDTE) > str(ME_EMP, 2, 0) + dtos(M_EMIFIN)
          msg("* * * NADA A LISTAR NO INTERVALO * * *")
          set relation to
          set order to 1
          restscreen(12, 20, 21, 51,M_TELA1)
          if TIPO = 0
            loop
          else
            return ""
          endif
        endif

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          exit
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        store 0    to PG      ,;
                      M_GERDUP,;
                      M_TOTDUP,;
                      M_GERPAG,;
                      M_TOTPAG

        store ctod("  /  /  ")  to M_VCTANT 

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                         && comprime
        endif

        M_QDE = 0

        do while !eof() 
         
            PG++

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO DE DUPLICATAS - EMISSAO","EAGRO31",132) 
            ? cent_cab(dtoc(M_SLDDTA),"","PAG.: " + str(PG, 4, 0), 132)
            ?     "*-----------*--------------------------------------------*--*---------------*--------*--------*--------*-----*-----------*---------*"
            ?     "* TITULO    * C L I E N T E                              *UF*   TELEFONE    * EMISSAO* VENCTO * PAGTO  *BANCO* DUPLICATA *  PRAZO  *"
            ?     "*-----------*--------------------------------------------*--*---------------*--------*--------*--------*-----*-----------*---------*"
 *                  999999/99-9 99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX ####,###,###.## 99/99/99 99/99/99 99/99/99 99999 ####,###.## 9999999 

            store 5 to LN
            
            do while !eof() .and. LN < 56 

              if str(DUPEMP, 2, 0) + dtos(DUPDTE) > str(ME_EMP, 2, 0) + dtos(M_EMIFIN)
                go bottom
                skip
                loop
              endif 

              if M_DUPPOR > 0
                if !DUPPOR = M_DUPPOR
                  skip
                  loop
                endif
              endif 

              if M_DUPCPG > 0
                if !DUPCPG = M_DUPCPG
                  skip
                  loop
                endif
              endif 

              if DUPPER == "S"
                skip
                loop
              endif
 
              if DUPPOR > 90000 
                skip
                loop
              endif

              if TIPO > 0
                if !DUPEXP == "E"
                  skip
                  loop
                endif
              endif 

              if M_OPC = 1
                if DUPHIS != 500 
*                 if DUPDTP <= M_SLDDTA
                    skip                  
                    loop
*                 endif
                endif
              endif          

              if M_OPC = 2
                if DUPHIS != 100
                  skip 
                  loop
                endif
              endif          
                           
            if M_QUE = "S"
              if DUPDTE != M_VCTANT
                M_VCTANT = DUPDTE 
                if M_TOTDUP > 0
                  ?     space(45)
                    ?? transform(M_TOTPAG, "@E ####,###,###.##") 
                    ?? " <=- (PG) TOTAL DO VENCIMENTO (AB) -=>"
                     ?? "     R$ "
                    ?? transform(M_TOTDUP, "@E ####,###,###.##") 
                  ?     replicate("-", 132)
                endif 
                ? " "    
                  ?? DUPDTE 
                  ?? " - " 
                  ?? SEMANA[dow(DUPVCT)]
                ?      
                store 0 to M_TOTDUP ,;
                           M_TOTPAG
                LN = LN + 4 

              endif
            endif

            ?     " "
              ?? DUPNUM 
              ?? "/"
              ?? strzero(DUPORD, 2, 0) 
              ?? "-"
              ?? str(ACPG00->CPGPAR, 1, 0)
              ?? " "
              ?? DUPCLI 
              ?? " "
              ?? left(ACLI00->CLINOM , 36)
              ?? " "
              ?? ACLI00->CLIUF3 
              ?? " "
              ?? pad(ACLI00->CLITEL3, 15)
              ?? " "
              ?? DUPDTE
              ?? " "
              ?? DUPVCT
              ?? " "
              ?? iif(DUPDTP >= M_SLDDTA, "  /  /  ", DUPDTP)
              ?? " "
              ?? str(DUPPOR, 5, 0)
              ?? " "
              ?? transform(iif(DUPVLA > 0, DUPVLA, DUPVLO),"@E ####,###.##") 
              ?? "     "

              if DUPHIS = 500
                ?? str((DUPVCT - M_SLDDTA), 5, 0)
              else
                if DUPDTP <= M_SLDDTA
                  ?? "PAGA "
                else
                  ?? str((DUPVCT - M_SLDDTA), 5, 0)
                endif 
              endif

            if DUPHIS = 500
              M_TOTDUP = M_TOTDUP + DUPVLA
              M_GERDUP = M_GERDUP + DUPVLA
            else
              if DUPDTP <= M_SLDDTA
                M_TOTPAG = M_TOTPAG + DUPVLP
                M_GERPAG = M_GERPAG + DUPVLP
              else
                M_TOTDUP = M_TOTDUP + DUPVLO
                M_GERDUP = M_GERDUP + DUPVLO
              endif
            endif 

            skip

            M_QDE ++
 
            LN++

            if inkey()= 27
              if susimp()
                ? replicate("-", 132)
                ? "* * * IMPRESSAO SUSPENSA * * *"
                go bottom
                skip
              endif
            endif

          enddo

        enddo

        ?    replicate("-", 132)
        ?     pad("  QUANTIDADE DE TITULOS -=> " + str(M_QDE,5),45)
         ?? transform(M_TOTPAG, "@E ####,###,###.##") 
         ?? " <=- (PG) TOTAL DO VENCIMENTO (AB) -=>"
         ?? "     R$ "
         ?? transform(M_TOTDUP, "@E ####,###,###.##") 

        ?     replicate("-", 132)

        ?     space(45)
         ?? transform(M_GERPAG, "@E ####,###,###.##") 
         ?? " <=- (PG) GERAL DO VENCIMENTO (AB) -=>"
         ?? "     R$ "
         ?? transform(M_GERDUP, "@E ####,###,###.##") 
        ?     replicate("-",132) 

    eject 

    desliga1()

    restscreen(12, 20, 21, 51,M_TELA1)

    if TIPO > 0
      exit
    endif

  enddo

  restscreen(13, 21, 23, 47, M_TELA)

return ""

*****************
function LISDCR_I
*****************


private M_CLIANT,; 
        M_TOTNOM,;
        M_NOMINI,;
        M_NOMFIN,;
        M_TOTAL ,;
        M_TELA  ,;
        M_TELA1 ,;
        M_QUE   ,;
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_OPC   ,;
        M_DUPVEN

  M_TELA = savescreen(13, 10, 23, 47)

  store 0   to M_OPC
  store "S" to M_QUE

  do while .t.

      rodape("DUPLICATA","MUNICIPIO",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP) 

      M_OPC = msgbox3("Escolha uma opcao..","",,"Abertas","Pagas","Todas")

        if lastkey() = 27
           exit 
        endif 

        M_TELA1 = savescreen(10, 10, 21, 51)

 nbox(12, 14, 20, 50,"W/W+",.t.)
 setcolor("B/W")
         @ 13, 15 say "Cidade Inic. :                     "
         @ 14, 15 say "       Final :                     "
         @ 15, 15 say "Emissao Inic :                     "
         @ 16, 15 say "       Final :                     "
         @ 17, 15 say "    Portador :       Vendedor:     "
         @ 18, 15 say "Quebra Nome  :                     "
         @ 19, 15 say "Data Relatori:                     "
         @ 20, 15 say "Perda S/N    :                     "
        set color to

        M_NOMINI:=M_NOMFIN:=space(20)
        M_EMIINI:=M_EMIFIN:=ctod("  /  /  ")
        M_DUPPOR:=M_DUPVEN:=0 
        M_SLDDTA:=date()
        M_PER = " "

        SetColor(_COREDICAO_)
        @ 13, 30 get M_NOMINI picture "@!@S20"
        @ 14, 30 get M_NOMFIN picture "@!@S20"
        @ 15, 30 get M_EMIINI 
        @ 16, 30 get M_EMIFIN 
        @ 17, 30 get M_DUPPOR picture "#####"
        @ 17, 46 get M_DUPVEN picture "###"
        @ 18, 30 get M_QUE valid(M_QUE $ "SN")
        @ 19, 30 get M_SLDDTA valid !empty(M_SLDDTA)
        @ 20, 30 get M_PER picture "@!" valid M_PER $ "SN"
        read 
        
        if lastkey() = 27
          restscreen(10, 10, 21, 51, M_TELA1)
          loop
        endif

        M_NOMINI = iif(empty(M_NOMINI),"A"             ,M_NOMINI)
        M_NOMFIN = iif(empty(M_NOMFIN),"ZZZZZZZZZZZZZZ",M_NOMFIN) 

        M_EMIINI = iif(empty(M_EMIINI), ctod("01/01/80"), M_EMIINI)
        M_EMIFIN = iif(empty(M_EMIFIN), ctod("31/12/79"), M_EMIFIN)

        select ACLI00
        set order to 5

        select ADCR00
        set order to 2

        set relation to str(DUPPOR, 5, 0) into APOR00 ,;
                     to str(DUPCPG, 3, 0) into ACPG00

        select ACLI00
        dbseek(M_NOMINI,.t.)

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          exit
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        store 0         to PG      ,;
                           M_TOTDUP,;
                           M_GERDUP,;
                           M_TOTPAG,;
                           M_GERPAG,;
                           M_TOTPORA,M_TOTPORP,M_GERPORA,M_GERPORP

        store space(30) to M_CLIANT 

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                         && comprime
        endif

        M_CLIANT = space(10)
        M_CLIMUN = space(20)
        M_CLINOM = space(40)
        select ADCR00
        dbseek(str(ME_EMP, 2, 0) + str(ACLI00->CLICOD, 7, 0),.t.)
        M_CLIANT = str(DUPEMP, 2, 0) + str(DUPCLI, 7, 0)

        if !str(ME_EMP, 2, 0) + str(ACLI00->CLICOD, 7, 0) == str(DUPEMP, 2, 0) + str(DUPCLI, 7, 0)
          M_CLIANT = space(10)
        endif

        select ACLI00

        do while !eof()

          cab_mun()
          
            if M_DUPVEN > 0
              AVEN00->(dbseek(str(M_DUPVEN, 3, 0)))
              ?
              ? " Vendedor: "
              ?? AVEN00->VENNOM
              ?
              LN += 3             
            endif
            
            do while !eof() .and. LN < 58 
      
              if left(ACLI00->CLIMUN1,len(alltrim(M_NOMFIN))) > alltrim(M_NOMFIN)
                go bottom
                skip
                loop
              endif

              select ADCR00

              if !M_CLIANT == str(DUPEMP, 2, 0) + str(DUPCLI, 7, 0)
                select ACLI00
                skip

                msw("* * * CLIENTE: " + STR(CLICOD, 7) + " * * *")

                if left(ACLI00->CLIMUN2,len(alltrim(M_NOMFIN))) > alltrim(M_NOMFIN)
                  go bottom
                  skip
                  loop
                endif

                select ADCR00                
                dbseek(str(ME_EMP, 2, 0) + str(ACLI00->CLICOD, 7, 0),.t.)

                if !str(ME_EMP, 2, 0) + str(ACLI00->CLICOD, 7, 0) == str(DUPEMP, 2, 0) + str(DUPCLI, 7, 0)
                  select ACLI00
                  M_CLIANT = time()
                  loop
                endif

                M_CLIANT = str(DUPEMP, 2, 0) + str(ACLI00->CLICOD, 7, 0)
              endif
                 
              if dtos(DUPDTE) < dtos(M_EMIINI) .or. dtos(DUPDTE) > dtos(M_EMIFIN)
                skip
                select ACLI00
                loop
              endif

              if M_PER == "N"
                if DUPPER == "S"
                  skip
                  select ACLI00
                  loop
                endif
              endif

              if M_DUPVEN > 0
                if DUPVEN # M_DUPVEN
                  skip
                  select ACLI00  
                  loop
                endif
              endif
 
              if !M_DUPPOR = 0
                if !DUPPOR = M_DUPPOR 
                  skip
                  select ACLI00
                  loop
                endif
              endif

              if DUPPOR > 90000
                skip
                select ACLI00
                loop
              endif

              if M_OPC = 1
                 if DUPHIS != 500
                   if DUPDTP <= M_SLDDTA
                     skip                  
                     select ACLI00
                     loop
                   endif  
                 endif
              endif          

              if M_OPC = 2 
                if DUPHIS != 100 
                  skip 
                  select ACLI00
                  loop
                endif
              endif          
                           
            if M_QUE = "S"
              if !DUPNOM == M_CLINOM
                if M_TOTPORA+M_TOTPORP > 0
                  if LN > 58
                    cab_mun()
                  endif
                  ?   space(13)
                  ?? "TOTAL DO CLIENTE    (AB) -=> R$ "
                  ?? transform(M_TOTPORA, "@E ####,###,###.##")
                  ?? "  (PG) -=> R$ "
                  ?? transform(M_TOTPORP, "@E ####,###,###.##")
                  ?? "  (AB+PG) -=> R$ "
                  ?? transform(M_TOTPORP+M_TOTPORA, "@E ####,###,###.##")
                  ?     replicate("-", 132)
                  LN += 2
                  M_TOTPORA = 0
                  M_TOTPORP = 0
                endif 

            if !ACLI00->CLIMUN2 == M_CLIMUN
              if LN > 58
                cab_mun()
              endif
              ?     replicate("-", 132)
              ?? chr(18)
              ?? chr(27) + "E"
              ? ACLI00->CLIMUN2
              ?? " "
              ?? ACLI00->CLIUF2
              ?      
              ?? chr(15)
              ?? chr(27) + "F"
              LN = LN + 3 
              M_CLIMUN = ACLI00->CLIMUN2
            endif

                M_CLINOM = DUPNOM

                ?     
                  ?? DUPCLI 
                  ?? " - " 
                  ?? ACLI00->CLINOM
                  ?? " "
                  ?? ACLI00->CLIEND3
                  ?? " "
                  ?? ACLI00->CLIMUN3
                  ?? " "
                  ?? ACLI00->CLIUF3
                  ?? " "
                  ?? ACLI00->CLITEL3
                ?      
                store 0 to M_TOTDUP 
                LN = LN + 2 
              endif
            endif

            ?     " "
              ?? DUPNUM 
              ?? "/"
              ?? strzero(DUPORD, 2, 0) 
              ?? "-"
              ?? str(ACPG00->CPGPAR, 1, 0)
              ?? " "
              ?? DUPCLI
              ?? " "
              ?? pad(ACLI00->CLINOM , 36)
              ?? " "
              ?? ACLI00->CLIUF2 
              ?? " "
              ?? transform(DUPVLO,"@E ####,###,###.##") 
              ?? " "
              ?? DUPDTE
              ?? " "
              ?? DUPVCT
              ?? " "
              ?? iif(DUPDTP >= M_SLDDTA, "  /  /  ", DUPDTP)
              ?? " "
              ?? str(DUPPOR, 5, 0)
              ?? " "
              ?? transform(iif(DUPVLA > 0, DUPVLA, DUPVLO),"@E ####,###.##")
              ?? "     "
              if DUPHIS = 500
                ?? str((DUPVCT - M_SLDDTA), 5, 0)
              else
                if DUPDTP <= M_SLDDTA
                  ?? "PAGA "
                else
                  ?? str((DUPVCT - M_SLDDTA), 5, 0)
                endif 
              endif

            if DUPHIS = 500
              M_TOTDUP = M_TOTDUP + DUPVLA
              M_GERDUP = M_GERDUP + DUPVLA
            else
              if DUPDTP <= M_SLDDTA
                M_TOTPAG = M_TOTPAG + DUPVLP
                M_GERPAG = M_GERPAG + DUPVLP
              else
                M_TOTDUP = M_TOTDUP + DUPVLO
                M_GERDUP = M_GERDUP + DUPVLO
              endif
            endif 

            M_TOTPORA += DUPVLA
            M_TOTPORP += DUPVLP
            M_GERPORA += DUPVLA
            M_GERPORP += DUPVLP

            skip
 
            select ACLI00

            LN++

                if inkey()= 27
                  if susimp()
                    ? replicate("-", 132)
                    ? "* * * IMPRESSAO SUSPENSA * * *"
                    go bottom
                    skip
                  endif
                endif

            enddo

        enddo

        if M_TOTPORA+M_TOTPORP > 0
          ?   space(13)
          ?? "TOTAL DO CLIENTE    (AB) -=> R$ "
          ?? transform(M_TOTPORA, "@E ####,###,###.##")
          ?? "  (PG) -=> R$ "
          ?? transform(M_TOTPORP, "@E ####,###,###.##")
          ?? "  (AB+PG) -=> R$ "
          ?? transform(M_TOTPORP+M_TOTPORA, "@E ####,###,###.##")
          ?     replicate("-", 132)
          LN += 2
          M_TOTPORA = 0
          M_TOTPORP = 0
        endif 

          ?   space(13)
          ?? "TOTAL GERAL         (AB) -=> R$ "
          ?? transform(M_GERPORA, "@E ####,###,###.##")
          ?? "  (PG) -=> R$ "
          ?? transform(M_GERPORP, "@E ####,###,###.##")
          ?? "  (AB+PG) -=> R$ "
          ?? transform(M_GERPORP+M_GERPORA, "@E ####,###,###.##")
          ?     replicate("-", 132)

    eject 

desliga1()

    restscreen(10, 10, 21, 51, M_TELA1)

  enddo

  restscreen(13, 10, 23, 47, M_TELA)

return ""

****************
function CAB_MUN
****************

            PG++

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO DE DUPLICATAS A RECEBER - ALFABETICA","EAGRO31",132)
            ? cent_cab(dtoc(M_SLDDTA),"","PAG.: " + str(PG, 4, 0), 132)
            ?     "*-----------*--------------------------------------------*--*---------------*--------*--------*--------*-----*-----------*---------*"
            ?     "* TITULO    * C L I E N T E                              *UF*VALOR ORIGINAL * EMISSAO* VENCTO * PAGTO  *BANCO* DUPLICATA * PRAZO   *"
            ?     "*-----------*--------------------------------------------*--*---------------*--------*--------*--------*-----*-----------*---------*"
 *                  999999/99-9 9999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99 99999 ####,###.## 9999999 

            store 5 to LN

return ""

***************
function EMIDCR
***************
parameters nM_OPC,M_OPC1,M_OPC2

private VAL_EXT[ 3 ]
declare VAL_EXT[ 3 ] 


    rodape("EMITE","TITULOS",M_FAN,"EAGRO31D","Mem: " + str(memory(0), 5),M_EMP)  

*      @ 10, 37 prompt              "Duplicata " POSITION 1 HIGHLITE R/BG
*      @ 11, 37 prompt              "Banespa   " POSITION 1 HIGHLITE R/BG
*      @ 12, 37 prompt              "Banestado " POSITION 2 HIGHLITE R/BG
*      @ 13, 37 prompt              "Itau      " POSITION 2 HIGHLITE R/BG
*      @ 14, 37 prompt              "Brasil    " POSITION 3 HIGHLITE R/BG
*      @ 15, 37 prompt              "Bamerindus" POSITION 1 HIGHLITE R/BG
*      @ 16, 37 prompt              "Santander " POSITION 1 HIGHLITE R/BG


   if M_OPC = 2 // SICREDI
     filecopy("C:\ACBrMonitorPLU\ACBrSicredi.ini","C:\ACBrMonitorPLU\ACBrMonitor.ini")           // Copy the file
   else
     filecopy("C:\ACBrMonitorPLU\ACBrBrasil.ini","C:\ACBrMonitorPLU\ACBrMonitor.ini")           // Copy the file
   endif

   mon_env("ACBr.Lerini")
   cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
   emiblo()

return ""

***************
function EMIDUP
*************** 

private M_DUPNUM1 ,;
        M_DUPNUM2 ,;
        M_DUPORD1 ,;
        M_DUPORD2 ,;
        LN        ,;
        PG        ,;
        M_ESC     ,;
        nTELA     ,;
        M_OPC

private VAL_EXT[ 3 ]
declare VAL_EXT[ 3 ] 

private M_DUP[4, 3],M_ORD[4, 3],M_SER[4, 3],M_VAL[4, 3],M_DIA[4,3]
declare M_DUP[4, 3],M_ORD[4, 3],M_SER[4, 3],M_VAL[4, 3],M_DIA[4,3]

       store "APOS VENCIMENTO COBRAR JUROS DE 10% AO MES" to M_MENS01
       store "PROTESTAR APOS 3 DIAS DO VENCIMENTO       " to M_MENS02

nTELA = savescreen(01, 01, 23, 79)

    do while .t.

       store 0  to M_DUPNUM1 ,;
                   M_DUPNUM2 ,;
                   M_DUPORD1 ,;
                   M_DUPORD2 ,;
                   M_OPC,;
                   M_JUROS,;
                   M_BANCO

       for R = 1 to 4
         for S = 1 to 3
           M_DUP[R,S] = 0
           M_ORD[R,S] = 0
           M_VAL[R,S] = 0
           M_DIA[R,S] = 0
         next
       next

       M_AGR = "N"

       rodape("EMITE","DUPLICATA",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP)  

 nbox(15, 20, 18, 59,"W/W+",.t.)
 setcolor("B/W")
         @ 16, 21 say   "Duplicata Inicial:       /            "
         @ 17, 21 say   "            Final:       /            "


        SetColor(_COREDICAO_)
         @ 16, 40 get M_DUPNUM1 picture "######"
         @ 16, 47 get M_DUPORD1 picture "##"  

         @ 17, 40 get M_DUPNUM2 picture "######"
         @ 17, 47 get M_DUPORD2 picture "##"
         read
         M_DUPNUM1 = iif(M_DUPNUM1 = 0,     1,M_DUPNUM1)
         M_DUPNUM2 = iif(M_DUPNUM2 = 0,999999,M_DUPNUM2) 
         M_DUPORD1 = iif(M_DUPORD1 = 0, 0,M_DUPORD1)
         M_DUPORD2 = iif(M_DUPORD2 = 0,99,M_DUPORD2) 
         dcr_nor()

      if lastkey() = 27
        exit
      endif

    enddo

    restscreen(01, 01, 23, 79, nTELA)

return ""

****************
function DCR_NOR
****************

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ADCR00","ADCR00"})
  aadd(sqlCAMPO,"ADCR00.*")
  aadd(sqlCAMPO,"ACLI00.*")
  aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ADCR00.DUPCLI"})
  aadd(sqlCHAVE,"ADCR00.DUPEMP = " + str(ME_EMP,2))
  aadd(sqlCHAVE,"DUPNUM BETWEEN " + str(M_DUPNUM1,9) + ' and ' + str(M_DUPNUM2,9))

  if !sqlrelation()
    msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
    return ""
  endif

  M_IMPRE = impresn()

  if M_IMPRE = "N"
    return ""
  endif

  ?? chr(27) + "G"

    do while !eof()

      if DUPORD < M_DUPORD1 .or. DUPORD > M_DUPORD2
        skip
        loop
      endif

      M_DUPNFS = DUPNFS


      lay_dup(DUPVLA,DUPNUM,DUPORD,AEMP00->EMPSER, DUPDTE) && emite duplicata

        skip

        M_ESC = inkey()

        if M_ESC = 27
          if susimp()
            ? "------------------------------"
            ? "* * * IMPRESSAO SUSPENSA * * *"
            go bottom
            skip
            loop
          else
            M_ESC = inkey()
          endif
        endif

    enddo

desliga1()

return "" 

****************          
function DCR_AGR
****************
 
    M_IMPRE = impresn()

    if M_IMPRE = "N"
       return ""
    endif

    select ADCR00

    M_DUPVLA = 0
    M_DUPNFS = 0

    for R = 1 to 4
      for S = 1 to 3
        if M_DUP[R, S] = 0
          loop
        endif
        seek str(ME_EMP, 2, 0) + str(M_DUP[R, S]) + str(M_ORD[R, S], 2, 0) 
        if !eof()
          M_DUPVLA = M_DUPVLA + DUPVLA
          M_DUPNFS = M_DUPNFS + DUPVLA
        endif
      next
    next

    select ADCR00

    dbseek(str(ME_EMP, 2, 0) + str(M_DUP[1, 1], 6, 0) + str(M_ORD[1, 1], 2, 0))

    ACLI00->(dbseek(str(ADCR00->DUPCLI, 7, 0)))
    AVEN00->(dbseek(str(ADCR00->DUPVEN, 3, 0)))

    ?? chr(27) + "G"
    ?? chr(27) + "M"

    lay_dup(M_DUPVLA,M_DUP[1, 1],M_ORD[1, 1],AEMP00->EMPSER, ADCR00->DUPDTE) && emite duplicata

    ?? chr(27) + "@"        

desliga1()

return "" 

****************          
function LER_DCR
****************
  
  SetColor(_COREDICAO_)
  @ 11, 21 get M_DUP[1, 1] picture "######"
  @ 11, 28 get M_ORD[1, 1] picture "##"       valid fun_dcr8(M_DUP[1, 1],M_ORD[1, 1], 1, 1)

  @ 11, 34 get M_DUP[1, 2] picture "######"
  @ 11, 41 get M_ORD[1, 2] picture "##"     valid fun_dcr8(M_DUP[1, 2],M_ORD[1, 2], 1, 2)

  @ 11, 47 get M_DUP[1, 3] picture "######"
  @ 11, 54 get M_ORD[1, 3] picture "##"        valid fun_dcr8(M_DUP[1, 3],M_ORD[1, 3], 1, 3)


  @ 12, 21 get M_DUP[2, 1] picture "######"
  @ 12, 28 get M_ORD[2, 1] picture "##"        valid fun_dcr8(M_DUP[2, 1],M_ORD[2, 1], 2, 1)

  @ 12, 34 get M_DUP[2, 2] picture "######"
  @ 12, 41 get M_ORD[2, 2] picture "##"       valid fun_dcr8(M_DUP[2, 2],M_ORD[2, 2], 2, 2)
 
  @ 12, 47 get M_DUP[2, 3] picture "######"
  @ 12, 54 get M_ORD[2, 3] picture "##"       valid fun_dcr8(M_DUP[2, 3],M_ORD[2, 3], 2, 3)

  @ 13, 21 get M_DUP[3, 1] picture "######"
  @ 13, 28 get M_ORD[3, 1] picture "##"       valid fun_dcr8(M_DUP[3, 1],M_ORD[3, 1], 3, 1)

  @ 13, 34 get M_DUP[3, 2] picture "######"
  @ 13, 41 get M_ORD[3, 2] picture "##"       valid fun_dcr8(M_DUP[3, 2],M_ORD[3, 2], 3, 2)

  @ 13, 47 get M_DUP[3, 3] picture "######"
  @ 13, 54 get M_ORD[3, 3] picture "##"       valid fun_dcr8(M_DUP[3, 3],M_ORD[3, 3], 3, 3)

  @ 14, 21 get M_DUP[4, 1] picture "######"
  @ 14, 28 get M_ORD[4, 1] picture "##"       valid fun_dcr8(M_DUP[4, 1],M_ORD[4, 1], 4, 1)

  @ 14, 34 get M_DUP[4, 2] picture "######"
  @ 14, 41 get M_ORD[4, 2] picture "##"       valid fun_dcr8(M_DUP[4, 2],M_ORD[4, 2], 4, 2)

  @ 14, 47 get M_DUP[4, 3] picture "######"
  @ 14, 54 get M_ORD[4, 3] picture "##"       valid fun_dcr8(M_DUP[4, 3],M_ORD[4, 3], 4, 3)
  read

return ""

***************
function EMIBLO
*************** 

private M_DUPNUM1 ,;
        M_DUPNUM2 ,;
        M_DUPORD1 ,;
        M_DUPORD2 ,;
        LN        ,;
        PG        ,;
        M_ESC     ,;
        nTELA    ,;
        M_OPC

nTELA = savescreen(01, 01, 23, 79)

       store "APOS VENCIMENTO COBRAR JUROS DE 10% AO MES" to M_MENS01
       store "PROTESTAR APOS 3 DIAS DO VENCIMENTO       " to M_MENS02

private VAL_EXT[ 3 ]
declare VAL_EXT[ 3 ] 
private M_DUP[4, 3],M_ORD[4, 3],M_VAL[4, 3],M_DIA[4,3]
declare M_DUP[4, 3],M_ORD[4, 3],M_VAL[4, 3],M_DIA[4,3]

M_BANCO = 15 // SICRED

    do while .t.

       store 0  to M_DUPNUM1 ,;
                   M_DUPNUM2 ,;
                   M_DUPORD1 ,;
                   M_DUPORD2 ,;
                   M_OPC     ,;
                   M_JUROS   ,;
                   M_BANCO

       for R = 1 to 4
         for S = 1 to 3
           M_DUP[R,S] = 0
           M_ORD[R,S] = 0
           M_VAL[R,S] = 0
           M_DIA[R,S] = 0
         next
       next

       M_AGR = "N"

       rodape("BLOQUETO","DUPLICATA",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP)  

       nbox(15, 20, 20, 59,"W/W+",.t.)
       setcolor("B/W")
         @ 16, 21 say   "        Duplicata:       /            "
         @ 17, 21 say   "            Final:       /            "
         @ 18, 21 say   "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
         @ 19, 21 say   "Juros de mora    :                    "
       set color to
       
        SetColor(_COREDICAO_)
         @ 16, 40 get M_DUPNUM1 picture "######" valid M_DUPNUM1 > 0
         @ 16, 47 get M_DUPORD1 picture "##"  
         @ 17, 47 get M_DUPORD2 picture "##"
         @ 19, 40 get M_JUROS   picture "###.##"
         read

         M_DUPORD1 = iif(M_DUPORD1 = 0, 0,M_DUPORD1)
         M_DUPORD2 = iif(M_DUPORD2 = 0,99,M_DUPORD2) 

         if lastkey() = 27
           exit
         endif

         dup_nor()

    enddo

    restscreen(01, 01, 23, 79, nTELA)

return ""

***************
function EMISIL
*************** 
Local nBuffSize := 16                   // Read/write buffer size
Local l7143Supp := .F.                  // Is function 7143h supported?
local cRet := ""

private M_DUPNUM1 ,;
        M_DUPNUM2 ,;
        M_DUPORD1 ,;
        M_DUPORD2 ,;
        LN        ,;
        PG        ,;
        M_ESC     ,;
        nTELA    ,;
        M_OPC

nTELA = savescreen(01, 01, 23, 79)

       store "APOS VENCIMENTO COBRAR JUROS DE 10% AO MES" to M_MENS01
       store "PROTESTAR APOS 3 DIAS DO VENCIMENTO       " to M_MENS02

private VAL_EXT[ 3 ]
declare VAL_EXT[ 3 ] 
private M_DUP[4, 3],M_ORD[4, 3],M_VAL[4, 3],M_DIA[4,3]
declare M_DUP[4, 3],M_ORD[4, 3],M_VAL[4, 3],M_DIA[4,3]

    do while .t.

       store 0  to M_DUPNUM1 ,;
                   M_DUPNUM2 ,;
                   M_DUPORD1 ,;
                   M_DUPORD2 ,;
                   M_OPC     ,;
                   M_JUROS   ,;
                   M_BANCO


       M_JUROS = 10

       rodape("BLOQUETO","DUPLICATA",M_FAN,"EAGRO31","Mem: " + str(memory(0), 5),M_EMP)  

 nbox(15, 20, 20, 59,"W/W+",.t.)
 setcolor("B/W")
         @ 16, 21 say   "Duplicata Inicial:       /            "
         @ 17, 21 say   "            Final:       /            "
         @ 18, 21 say   "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
         @ 19, 21 say   "Juros de mora    :                    "
        SetColor(_COREDICAO_)

       @ 16, 40 get M_DUPNUM1 picture "######"
       @ 16, 47 get M_DUPORD1 picture "##"  
       @ 17, 40 get M_DUPNUM2 picture "######"
       @ 17, 47 get M_DUPORD2 picture "##"
       @ 19, 40 say M_JUROS   picture "###.##"
       read

       if lastkey() = 27
         exit
       endif

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ADCR00","ADCR00"})
  aadd(sqlCAMPO,"ADCR00.*")
  aadd(sqlCAMPO,"ACLI00.*")
  aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ADCR00.DUPCLI"})
  aadd(sqlCHAVE,"ADCR00.DUPEMP = " + str(ME_EMP,2))
  aadd(sqlCHAVE,"DUPNUM BETWEEN " + str(M_DUPNUM1,9) + ' and ' + str(M_DUPNUM2,9))

if !sqlrelation()
  msg("* * * NADA A SER LISTADO NO INTERVALO * * *")
  return ""
endif


if ME_EMP = 1
  Filecopy("C:\ACBrNfeMonitor\ACBrCirur.ini","C:\ACBrNfeMonitor\ACBrMonitor.ini")           // Copy the file
else
  Filecopy("C:\ACBrNfeMonitor\ACBrNutri.ini","C:\ACBrNfeMonitor\ACBrMonitor.ini")           // Copy the file
endif

mon_env("ACBr.Lerini")
cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.


  nSeqImp = 1
  lTemsem = .f.
  lTemcom = .f.

  mon_env("BOLETO.LimparLista")
  cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

do while !eof()

  BUSCAREGISTRO("ACLI00",1,{str(ADCR00->DUPCLI,7,0)},"SELECT")

  select ADCR00
  
  acbr_sil(DUPVLA,"TIPO","TIPO1","BOLETO") && emite duplicata

  select ADCR00
 
  skip

  if inkey() = 27
    if susimp()
      ? "------------------------------"
      ? "* * * IMPRESSAO SUSPENSA * * *"
      go bottom
      skip
      loop
    endif
  endif

  enddo

  mon_env("BOLETO.Imprimir")
  cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

  return ""


enddo
restscreen(01, 01, 23, 79, nTELA)

return ""

****************
function DUP_NOR
****************

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"ADCR00","SELECT"}
  aadd(sqlCHAVE,{"DUPEMP",str(ME_EMP,2)})
  aadd(sqlCHAVE,{"DUPNUM",str(M_DUPNUM1,6)})
  aadd(sqlCHAVE,{"DUPSER",aspas(AEMP00->EMPSER)})
  executasql()

  altd()
  
  mon_env("BOLETO.LimparLista")
  cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
  if ADCR00->DUPPOR = 15
    filecopy("C:\ACBrMonitorPLU\ACBrSicredi.ini","C:\ACBrMonitorPLU\ACBrMonitor.ini")           // Copy the file
  else
    filecopy("C:\ACBrMonitorPLU\ACBrBrasil.ini","C:\ACBrMonitorPLU\ACBrMonitor.ini")           // Copy the file
  endif

  mon_env("ACBr.Lerini")
  cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

  mon_env("BOLETO.LimparLista")
  cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

do while !eof()

  if DUPORD < M_DUPORD1 .or. DUPORD > M_DUPORD2
    skip
    loop
  endif

  if DUPPOR = 15
    sicredi(DUPVLA, str(DUPNUM, 6, 0) + "/" + strzero(DUPORD, 2, 0) + "-" + DUPSER,DUPBOL) && emite duplicata
  else
    lay_sil(DUPVLA, str(DUPNUM, 6, 0) + "/" + strzero(DUPORD, 2, 0) + "-" + DUPSER,DUPBOL) && emite duplicata
  endif

  select ADCR00
  skip

enddo

mon_env("BOLETO.Imprimir")
cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

return "" 

****************          
function DUP_AGR
****************
 
    M_IMPRE = impresn()

    if M_IMPRE = "N"
       return ""
    endif

    ?? chr(27) + "0"        
    ?? chr(27) + "G"
    ?? chr(27) + "M"

    select ADCR00

    M_DUPVLA = 0

    for R = 1 to 4
      for S = 1 to 3
        if M_DUP[R, S] = 0
          loop
        endif
        seek str(ME_EMP, 2, 0) + str(M_DUP[R, S]) + str(M_ORD[R, S], 2, 0)
        if !eof()
          M_DUPVLA = M_DUPVLA + DUPVLA
        endif
      next
    next

    select ADCR00

    dbseek(str(ME_EMP, 2, 0) + str(M_DUP[1, 1]) + str(M_ORD[1, 1], 2, 0))

    ACLI00->(dbseek(str(ADCR00->DUPCLI, 7, 0)))
    AVEN00->(dbseek(str(ADCR00->DUPVEN, 3, 0)))

    do case
       case nM_OPC = 2
            lay_ban(M_DUPVLA,M_DUP[1, 1],M_ORD[1, 1]) 
       case nM_OPC = 3 
            lay_bra(M_DUPVLA,M_DUP[1, 1],M_ORD[1, 1]) 
       case nM_OPC = 4 
            lay_ita(M_DUPVLA,M_DUP[1, 1],M_ORD[1, 1]) 
       case nM_OPC = 5 
            lay_sil(M_DUPVLA,M_DUP[1, 1],M_ORD[1, 1]) 
       case nM_OPC = 6 
            lay_bam(M_DUPVLA,M_DUP[1, 1],M_ORD[1, 1]) 
       case nM_OPC = 7 
            lay_san(M_DUPVLA,M_DUP[1, 1],M_ORD[1, 1]) 
    endcase

    ?? chr(27) + "@"        

desliga1()

return "" 

*****************
function FUN_DCR8
*****************

parameters F_DUP, F_ORD, L, C

if lastkey() = 5
  return .t.
endif

if F_DUP = 0
  return .t.
endif

select ADCR00

if !(dbsetorder(1),dbseek(str(ME_EMP, 2, 0) + str(F_DUP, 6, 0) + str(F_ORD, 2, 0)))
  msg("* * * DUPLICATA NŽO CADASTRADA * * *")
  return .f.
endif

msg("* * * " + dtoc(DUPDTE) + " " + transform(DUPVLA,"@E ###,###.##") + " * * *")

for S = 1 to 3
  for T = 1 to 4
    if S = C .and. T = L
      loop
    endif
    if str(F_DUP, 6, 0) + str(F_ORD, 2, 0) = str(M_DUP[T, S], 6, 0) + str(M_ORD[T, S], 2, 0) 
      msg("* * * DUPLICATA JA DIGITADA * * *")
      keyboard chr(05)
      return .f.
    endif
  next
next

if L = 1 .and. C = 1
  M_CLI = DUPCLI
else
  if !str(DUPCLI, 7, 0) == str(M_CLI, 7, 0)
    msg("* * * ESTA DUPLICATA NAO PERTENCE AO MESMO CLIENTE * * *")
    return .f.
  endif
endif

M_VAL[L,C] = DUPVLA
M_DIA[L,C] = day(DUPDTE)

return .t.    

*****************
function FUN_DCR9
*****************

if lastkey() = 5
  return .t.
endif

select APOR00

if M_BANCO = 0
  return .f.
endif

if !dbseek(str(M_BANCO, 5, 0))
  msg("* * * PORTADOR NŽO CADASTRADO * * *")
  return .f.
endif

msg("* * * " + alltrim(PORNOM) + " - " + alltrim(POROPE) + " * * *")

return .t.


***************
function SUSDCR
***************

private M_TELA ,;
        M_OPC

 tone(300,8)

 M_TELA = savescreen(12, 12, 15, 67)

 sombra(12, 12, 14, 66,_SOMBRA_) 
 set color to W/R
   @ 12, 12 say "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»"
   @ 13, 12 say "º       Coloque outra Duplicata e Tecle (ENTER)       º"
   @ 14, 12 say "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
 set color to

 inkey(0)

 restscreen(12, 12, 15, 67, M_TELA)

return ""

****************
function TLDCR01
****************
   
 nbox(06, 13, 20, 66,"W/W+",.t.)
 setcolor("B/W")
    @ 07, 14 say     " Duplicata:       /   S‚rie:    Cliente:            "
    @ 08, 14 say     " Nome     :                                         "
    @ 09, 14 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 10, 14 say     " Emiss„o  :                  Vencimento:            "
    @ 11, 14 say     " Portador :                 Taxa Mensal:            "
    @ 12, 14 say     " O b s    :                                         "
    @ 13, 14 say     "          :                                         "
    @ 14, 14 say     " Original :                   Vlr Desc :            "
    @ 15, 14 say     "    Atual :                   Vlr Juros:            "
    @ 16, 14 say     " Vrl Pago :                   Vlr Taxas:            "
    @ 17, 14 say     " Vd/Ap/Cp :    /   /          Dta Pagto:            "
    @ 18, 14 say     " Comiss„o :                   N§ Boleto:            "
    @ 19, 14 say     " Perda    :     Agrupar:      Exportar :            "
set color to

return ""

****************
function TLDCR02 
****************

 nbox(03, 02, 21, 76,"W/W+",.t.)
 setcolor("B/W")
  @ 04, 03 say     "                                                                         "
  @ 05, 03 say     "ÄÄÄÄÄÄÂÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÂÄÄÄÄÄÂÄÄ"
  @ 06, 03 say     "T¡tulo³Ord³Emiss„o ³ Vencto ³  Pgto  ³Atr³   Valor  ³Cliente³Por³Prazo³Em"
  @ 07, 03 say     "ÄÄÄÄÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÅÄÄÄÄÄÅÄÄ"
  for zz = 8 to 15
  @ zz, 03 say     "      ³   ³        ³        ³        ³   ³          ³       ³   ³     ³  "
  next
  @ 16, 03 say     "ÄÄÄÄÄÄÁÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÁÄÄÄÄÄÁÄÄ"
  @ 17, 03 say     "Nome:                                          Fone   :                  "
  @ 18, 03 say     "Obse:                                          Valor  :                  "
  @ 19, 03 say     "    :                                          Bol/Dsc:        /         "
  @ 20, 03 say     "Cred:                                                                    "
set color to

return "" 

****************
function EDDCR01
****************
SetColor(_COREDICAO_)
@ 07, 55 get     M_DUPCLI F2 picture "#######" valid fun_dcr01() color _CORF2_ funcao "sele_arquivo('ACLI00')" retorno @M_DUPCLI

@ 10, 26 get     M_DUPDTE F2 valid(M_DUPDTE != ctod("  /  /  ")) color _CORF2_ funcao "pegadata(10,26,@M_DUPDTE)" retorno "re"
@ 10, 55 get     M_DUPVCT F2 valid(M_DUPVCT != ctod("  /  /  ")) color _CORF2_ funcao "pegadata(10,55,@M_DUPVCT)" retorno "re"
@ 11, 26 get     M_DUPPOR F2 picture "#####"    color _CORF2_  valid verdcr02() funcao "sele_arquivo('APOR00')" retorno @M_DUPPOR
@ 11, 55 get     M_DUPTXD picture "##.####"
@ 12, 26 get     M_DUPOBS picture "@!"
@ 13, 26 get     M_DUPOBT picture "@!"

@ 14, 26 get     M_DUPVLO picture "#######.##"       valid fun_dcr03()
@ 15, 26 get     M_DUPVLA picture "#######.##"
@ 15, 55 get     M_DUPJUR picture "#######.##"

@ 16, 26 get     M_DUPVLP picture "#######.##"
@ 16, 55 get     M_DUPTAX picture "#######.##"

@ 17, 26 get     M_DUPVEN F2 picture "###"   color _CORF2_  valid fun_dcr05() funcao "sele_arquivo('AVEN00')" retorno @M_DUPVEN
@ 17, 34 get     M_DUPCPG F2 picture "###"   color _CORF2_  valid fun_dcr04() funcao "sele_arquivo('ACPG00')" retorno @M_DUPCPG

@ 18, 55 get     M_DUPBOL picture "#######"
@ 19, 26 get     M_DUPPER picture "@!" valid iif(M_DUPCPG#151,M_DUPPER $ "SN",M_DUPPER="N")
read

****************
function EDDCR03
****************

  SetColor(_COREDICAO_)
  @ 17, 26 get     M_DUPVEN picture "###"    valid fun_dcr05()
  @ 19, 26 get     M_DUPPER picture "@!" valid M_DUPPER $ "SN"
  read

return ""

****************
function EDDCR04(TIPO)
****************

  SetColor(_COREDICAO_)
  if TIPO = 1
    @ 17, 57 get     M_DUPDTP
  else
    @ 19, 55 get     M_DUPEXP picture "@!" valid M_DUPEXP $ "B "
  endif
  read

return ""

****************
function MSDCR01
****************

  setcolor("N/W*")

    @ 07, 26 say     DUPNUM         picture "######"
    @ 07, 33 say     DUPORD         picture "##"

    @ 07, 43 say     DUPSER         picture "@!"

    @ 07, 55 say     DUPCLI         picture "#######" 

    @ 08, 26 say     left(CLINOM, 39)

    @ 10, 26 say     DUPDTE 
    @ 10, 55 say     DUPVCT 

    @ 11, 26 say     DUPPOR         picture "#####"                   
    @ 11, 55 say     DUPTXD         picture "##.####"                   

    @ 12, 26 say     DUPOBS
    @ 13, 26 say     DUPOBT

    @ 14, 26 say     DUPVLO         picture "#######.##"               
    @ 14, 55 say     DUPDSC         picture "#######.##"               

    @ 15, 26 say     DUPVLA         picture "#######.##"
    @ 15, 55 say     DUPJUR         picture "#######.##"                   

    @ 16, 26 say     DUPVLP         picture "#######.##"
    @ 16, 55 say     DUPTAX         picture "#######.##"

    @ 17, 26 say     DUPVEN         picture "###"
    @ 17, 34 say     DUPCPG         picture "###"

    @ 17, 57 say     iif(HB_ISNIL(DUPDTP),ctod("  /  /  "),DUPDTP)

    @ 18, 55 say     DUPBOL         picture "#######"
    @ 19, 26 say     DUPPER         picture "@!" 
    @ 19, 55 say     DUPEXP 
  set color to
  
return ""

****************
function GRDCR01(cACAO)
****************

sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"ADCR00",cACAO}

aadd(sqlCHAVE,{"DUPEMP",str(M_DUPEMP,2)})
aadd(sqlCHAVE,{"DUPNUM",str(M_DUPNUM,6)})
aadd(sqlCHAVE,{"DUPORD",str(M_DUPORD,2)})
aadd(sqlCHAVE,{"DUPSER",aspas(M_DUPSER)})

if !cACAO $ "#DELETE#SELECT#"
  aadd(sqlCAMPO,{"DUPEMP",str(M_DUPEMP,2),.t.})
  aadd(sqlCAMPO,{"DUPNUM",str(M_DUPNUM,9),.t.})
  aadd(sqlCAMPO,{"DUPORD",str(M_DUPORD,2),.t.})
  aadd(sqlCAMPO,{"DUPSER",M_DUPSER,.t.})
  aadd(sqlCAMPO,{"DUPCLI",str(M_DUPCLI,5),.t.})
  aadd(sqlCAMPO,{"DUPDTE",formatdta(M_DUPDTE),.t.})
  aadd(sqlCAMPO,{"DUPVCT",formatdta(M_DUPVCT),.t.})
  aadd(sqlCAMPO,{"DUPPOR",str(M_DUPPOR,5),.t.})
  aadd(sqlCAMPO,{"DUPEXP",M_DUPEXP,.t.})
  aadd(sqlCAMPO,{"DUPVLO",str1(M_DUPVLO,2),.t.})
  aadd(sqlCAMPO,{"DUPVLA",str1(M_DUPVLA,2),.t.})
  aadd(sqlCAMPO,{"DUPBOL",str(M_DUPBOL),.t.})
  aadd(sqlCAMPO,{"DUPDTP",formatdta(M_DUPDTP),.t.})
  aadd(sqlCAMPO,{"DUPVLP",str1(M_DUPVLP,2),.t.})
  aadd(sqlCAMPO,{"DUPHIS",str(M_DUPHIS,3),.t.})
  aadd(sqlCAMPO,{"DUPOBS",M_DUPOBS,.t.})
  aadd(sqlCAMPO,{"DUPOBT",M_DUPOBT,.t.})
  aadd(sqlCAMPO,{"DUPNOM",M_DUPNOM,.t.})
  aadd(sqlCAMPO,{"DUPCPG",str(M_DUPCPG,3),.t.})
  aadd(sqlCAMPO,{"DUPDSC",str1(M_DUPDSC,2),.t.})
  aadd(sqlCAMPO,{"DUPTAX",str1(M_DUPTAX,2),.t.})
  aadd(sqlCAMPO,{"DUPJUR",str1(M_DUPJUR,2),.t.})
  aadd(sqlCAMPO,{"DUPVEN",str(M_DUPVEN,3),.t.})
  aadd(sqlCAMPO,{"DUPTXD",str1(M_DUPTXD,2),.t.})
  aadd(sqlCAMPO,{"DUPPER",M_DUPPER,.t.})

endif

executasql()

return ""

******************
function FUN_DCR01
******************

******************

if lastkey() = 5
  return .t.
endif

if M_DUPCLI = 0
  return .f.
endif

if !BUSCAREGISTRO("ACLI00",1,{str(M_DUPCLI,5,0)},"SELECT")
  msg("* * * CLIENTE NAO CADASTRADO * * *")
  keyfun()
  return .f.
endif

set color to I
@ 08, 26 say left(CLINOM, 39)
set color to

M_DUPNOM = CLINOM

keyfun()

return .t.

******************
function FUN_DCR02
******************

if lastkey() = 5
  return .t.
endif

if M_DUPPOR = 0
  return .f.
endif

select APOR00

if !dbseek(str(M_DUPPOR, 5, 0))
  msg("* * * PORTADOR NAO CADASTRADO * * *")
  keyfun()
  return .f.
endif

msg(alltrim(PORNOM))

keyfun()

return .t.    

******************
function FUN_DCR03
******************

if lastkey() = 5
  return .t.
endif

if M_DUPVLO = 0
  return .f. 
endif

if M_OPC = 1
*  M_DUPVLA = M_DUPVLO
endif

return .t.    

******************
function FUN_DCR04
******************

if lastkey() = 5
  return .t.
endif

if M_DUPCPG = 0
  return .f.
endif

if !BUSCAREGISTRO("ACPG00",1,{str(M_DUPCPG,3,0)},"SELECT")
  msg("* * * CONDICAO DE PAGAMENTO NAO CADASTRADO * * *")
  keyfun()
  return .f.
endif

msg(alltrim(CPGDES))

keyfun()

return .t.

******************
function FUN_DCR05
******************


if lastkey() = 5
  return .t.
endif

if M_DUPVEN = 0
  return .f.
endif

if !BUSCAREGISTRO("AVEN00",1,{str(M_DUPVEN,3,0)},"SELECT")
  msg("* * * VENDEDOR NAO CADASTRADO * * *")
  keyfun()
  return .f.
endif

msg(alltrim(VENNOM))

keyfun()

return .t.


******************
function FUN_DCR07
******************

if lastkey() = 5 .or. M_BANCO = 0
  return .t.
endif

if !APOR00->(dbseek(str(M_BANCO, 5, 0)))
  msg("* * * PORTADOR NAO CADASTRADO * * *")
  return .f.
endif

msg("* * * " + alltrim(APOR00->PORNOM) + " * * *")

return .t.    

******************
function FUN_DCR08
******************

if M_DUPCLI > 0
   M_CODINI = M_DUPCLI
   M_CODFIN = M_DUPCLI
endif

return .t.    

******************
function FUN_DCR09
******************

  if lastkey() = 5
    return .t.
  endif

  if !M_TIPO $ "APT"
    msg("* * * Valido Somente  (A)berto  (P)agas  (T)odas * * *")
    return .f.
  endif

return .t.    

******************
function FUN_DCR10
******************

if M_DUPPOR > 0
   M_PORINI = M_DUPPOR
   M_PORFIN = M_DUPPOR
endif

return .t.    

*****************
function VERDCR02
*****************

if lastkey() = 5
  return .t.
endif

if M_DUPPOR = 0
  return .f.
endif

if !BUSCAREGISTRO("APOR00",1,{str(M_DUPPOR,5,0)},"SELECT")
  msg("* * * PORTADOR NAO CADASTRADO * * *")
  keyfun()
  return .f.
endif

msg(alltrim(PORNOM))

return .t.

*****************
function VERDCR03
******************

  if lastkey() = 5
    return .t.
  endif

  if !M_DUPEXP $ "EXBG"
    msg("* * * Valido Somente (B)oleto  (E)xportar  e(X)portada a(G)rupar * * *")
    return .f.
  endif

return .t.    

*******************
function CALC_JUDCR
*******************

select ALCR00

M_LANDTM = ctod("  /  /  ")

dbsetorder(2)

dbseek(str(ADCR00->DUPEMP, 2, 0) + str(ADCR00->DUPNUM, 6, 0) + str(ADCR00->DUPORD, 2, 0), .t.)

do while !eof()

   if !str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) == str(ADCR00->DUPEMP, 2, 0) + str(ADCR00->DUPNUM, 6, 0) + str(ADCR00->DUPORD, 2, 0)        
     exit
   endif

   M_LANDTM = LANDTM

   skip

enddo

dbsetorder(1)

if empty(M_LANDTM)
  M_LANDTM = ADCR00->DUPVCT
endif  

if ADCR00->DUPVCT > M_LANDTM
  M_LANDTM = ADCR00->DUPVCT
endif  

M_VALOR = ADCR00->DUPVLA + ( (ADCR00->DUPVLA * .01) * ((ADCR00->DUPTXD/30) * abs((M_LANDTM - date()))))

select ADCR00

return M_VALOR

****************
function SETADCR
****************

  set cursor off

  set color to R+
    @ 24, 15 say   "(ENTER) Observacoes  (ESPA€O) Totais  (ESC) Saida"
  set color to 

  set color to GR+
    @ 24, 16 say "ENTER"
    @ 24, 37 say "ESPA€O"
    @ 24, 54 say "ESC"
  set color to 

return ""

***************
function ACHDCR
***************

parameters  M_MODO, M_ELEM, M_POSI

nTecla = lastkey()

if str(nTecla, 2, 0) $ "27"
  return 0
endif

  M_CHAVE = str(val(substr(M_VETORITE[M_ELEM], 72, 2)), 2, 0) + str(val(substr(M_VETORITE[M_ELEM], 1, 6)), 6, 0) + str(val(substr(M_VETORITE[M_ELEM], 8, 2)), 2, 0)

  ADCR00->( dbsetorder(1) , dbseek(M_CHAVE) )
  ACLI00->(dbseek(str(ADCR00->DUPCLI, 7, 0)))

  if nTecla = 13
    altobsdcr()
  endif

  if nTecla = 32
    mostotdcr()
  endif

  if nTecla = K_CTRL_N // CTR + N

    if substr(M_DUPNFS[M_ELEM][3], 1, 1) == "C"  // Cupom Fiscal
      @ 24, 00 say M_DUPNFS[M_ELEM][3] color("W+/R")
      select ACUP00
      if !dbseek(str(M_DUPNFS[M_ELEM][1], 2, 0) + str(M_DUPNFS[M_ELEM][2], 6, 0) + M_DUPNFS[M_ELEM][3])
        msg("* * * CUPOM FISCAL NAO CADASTRADO * * *")
        return 2
      endif
      lTelloc = savescreen(0,0,24,80)
      restscreen(0,0,24,80,lTelloc)
      set color to N/W,W+/N      
    else
      if M_DUPNFS[M_ELEM][3] $ "M1#NE#UN#"
        @ 24, 00 say M_DUPNFS[M_ELEM][3] color("W+/R")
        select ANFS00
        if !dbseek(str(M_DUPNFS[M_ELEM][1], 2, 0) + str(M_DUPNFS[M_ELEM][2], 6, 0) + M_DUPNFS[M_ELEM][3])
          msg("* * * NOTA FISCAL NAO CADASTRADA * * *")
          return 2
        endif
        lTelloc = savescreen(0,0,24,80)
        setcolor("B/B")

        tlnfs01()
        msnfs03() 
        msnfs04()
        vernfs5a()
        msg("* * * TECLE (ENTER) " + iif(ANFS00->NFSCAN="C","- NOTA CANCELADA","") + " * * *")
        restscreen(0,0,24,80,lTelloc)
        set color to N/W,W+/N
      else
        if ME_EMP = 51
          select AREQ00
          if !dbseek(str(M_DUPNFS[M_ELEM][1], 2, 0) + str(M_DUPNFS[M_ELEM][2], 6, 0) + M_DUPNFS[M_ELEM][3])
            msg("* * * REQUISICAO NAO CADASTRADA * * *")
            set color to N/W,W+/N
            return 2
          endif
          lTelloc = savescreen(0,0,24,80)
          tlreq01()
          msreq01() 
          msreq99()
          restscreen(0,0,24,80,lTelloc)
          set color to N/W,W+/N
        endif
      endif
    endif
  endif

  set color to GR+/B+
    @ 17, 09 say pad(ACLI00->CLINOM , 40)
    @ 17, 59 say padl(alltrim(ACLI00->CLITEL3), 17)
    @ 18, 09 say pad(ADCR00->DUPOBS , 40)
    @ 18, 59 say ADCR00->DUPVLO picture "@E ##,###,###,###.##"
    @ 19, 09 say pad(ADCR00->DUPOBT , 40)
    @ 19, 59 say str(ADCR00->DUPBOL, 7, 0)
    @ 19, 67 say ADCR00->DUPDSC picture "@E ##,###.##"
    @ 20, 09 say ACLI00->CLIAC
    @ 20, 30 say iif(ADCR00->DUPPER=="S","(PERDA)","       ")
  set color to I

  M_LINPOS = M_POSI

return 2

******************
function ALTOBSDCR
******************

    M_DUPOBS = pad(ADCR00->DUPOBS , 40)
    M_DUPOBT = pad(ADCR00->DUPOBT , 40)

     SetColor(_COREDICAO_)
      @ 21, 14 get M_DUPOBS
      @ 22, 14 get M_DUPOBT
      read
    set color to N/W,W+/N

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"ADCR00","UPDATE"}
  aadd(sqlCHAVE,{"DUPEMP",str(ADCR00->DUPEMP,2)})
  aadd(sqlCHAVE,{"DUPNUM",str(ADCR00->DUPNUM,6)})
  aadd(sqlCHAVE,{"DUPORD",str(ADCR00->DUPORD,2)})
  aadd(sqlCHAVE,{"DUPSER",aspas(ADCR00->DUPSER)})
  aadd(sqlCAMPO,{"DUPOBS",M_DUPOBS,.t.})
  aadd(sqlCAMPO,{"DUPOBT",M_DUPOBT,.t.})
  executasql()

  select ADCR00
  replace DUPOBS with M_DUPOBS
  replace DUPOBT with M_DUPOBT

return ""

******************
function MOSTOTDCR
******************

private M_TELA

  M_TELA = savescreen(04, 29, 08, 74)

  sombra(04, 29, 07, 73,_SOMBRA_)
  set color to W+/BG
    @  04, 29 , 07, 73 box "         "
  set color to 
  painel(04, 29, 07, 73,"W+/BG","N/BG")
  set color to GR+/BG+
    @ 05, 30 say "Vencidos: " + transform(M_TOTVEN,"@E #,###,###.##") + " Aberto: " + transform(M_TOTDUP,"@E #,###,###.##")
    @ 06, 30 say "A Vencer: " + transform(M_TOTAVE,"@E #,###,###.##") + " Pago  : " + transform(M_TOTPAG,"@E #,###,###.##")
  set color to

  set color to GR+*
    @ 24, 22 say "* * * Pressione Qualquer Tecla * * *"
    inkey(0)
    setadcr()
  set color to N/W,W+/N

  restscreen(04, 29, 08, 74, M_TELA)

return ""

****************
function MSREQ99
****************

    select AREQ01

    dbseek(str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER,.t.)

    L = 0

    do while !eof()
      if !str(REQEMP, 2, 0) + str(REQNUM, 6, 0) + REQSER == str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER
        exit
      endif
      skip
      L = L + 1
    enddo

    if L = 0
      msg("* * * REQUISI€AO NAO POSSUE ITENS * * *")
      return ""
    endif

    declare M_VETORITE[L]

    R = 1

    dbseek(str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER,.t.)

    do while !eof()

      if !str(REQEMP, 2, 0) + str(REQNUM, 6, 0) + REQSER == str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER
        exit
      endif

      APCA00->(dbseek(str(AREQ01->REQMAT, 6, 0)))
  
      M_VETORITE[R] = str(REQSEQ, 2, 0) + "³" + ;
                      str(REQMAT, 6, 0) + "³" + ;
                      pad(APCA00->PCADES, 28)   + "³" + ;
                      pad(APCA00->PCAUNI, 02)   + "³" + ;
                      str(REQQDE, 9, 3) + "³" + ;
                      str(REQPRB,10, 3) + "³" + ;
                      str(REQVLI,10, 2) + "³" 
      skip

      R = R + 1

    enddo

    M_LINPOS = 0

  do while .t.

    setas()

    set color to N/W,W+/N
      M_OPC = achoice(12, 3,19,75,M_VETORITE,,"mostec")
    set color to 

    if lastkey() = 13
      msreq04()
      loop
    endif

    if lastkey() = 27
      exit        && abandona operacao
    endif

  enddo

return ""

***************
function ISALUG   // Rotina para verificar se duplicata ‚ de aluguel
***************

if DUPSER = "M1"
  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ANFS00","ANFS00"})
  aadd(sqlCAMPO,"ANFS00.NFSNUM")
  aadd(sqlCAMPO,"APCA00.PCADES")
  aadd(sqlCAMPO,"ANFS01.NFSMAT")
  aadd(sqlRELATION,{"ANFS01","ANFS01.NFSEMP","ANFS00.NFSEMP"})
  aadd(sqlRELATION,{"","ANFS01.NFSNUM","ANFS00.NFSNUM"})
  aadd(sqlRELATION,{"","ANFS01.NFSSER","ANFS00.NFSSER"})
  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","ANFS01.NFSMAT"})
  aadd(sqlCHAVE,"ANFS00.NFSEMP = " + str(ADCR00->DUPEMP, 2, 0))
  aadd(sqlCHAVE,"ANFS00.NFSNUM = " + str(ADCR00->DUPNUM, 6, 0))
  aadd(sqlCHAVE,"ANFS00.NFSSER = " + aspas(ADCR00->DUPSER))
  if !sqlrelation()
    msg("* * * Nota Fiscal nÆo encontrada: " + str(ADCR00->DUPNUM, 6) + " " + ADCR00->DUPSER + " * * *")
    return .f.
  else
    if substr(PCADES, 1, 7) == "ALUGUEL"
      return .t.
    else
      return .f.
    endif
  endif
else
  if ME_EMP = nREQEMP
    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"AREQ00","AREQ00"})
    aadd(sqlCAMPO,"AREQ00.REQNUM")
    aadd(sqlCAMPO,"APCA00.PCADES")
    aadd(sqlCAMPO,"AREQ01.REQMAT")
    aadd(sqlRELATION,{"AREQ01","AREQ01.REQEMP","AREQ00.REQEMP"})
    aadd(sqlRELATION,{"","AREQ01.REQNUM","AREQ00.REQNUM"})
    aadd(sqlRELATION,{"","AREQ01.REQSER","AREQ00.REQSER"})
    aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","AREQ01.REQMAT"})
    aadd(sqlCHAVE,"AREQ00.REQEMP = " + str(ADCR00->DUPEMP, 2, 0))
    aadd(sqlCHAVE,"AREQ00.REQNUM = " + str(ADCR00->DUPNUM, 6, 0))
    aadd(sqlCHAVE,"AREQ00.REQSER = " + aspas(ADCR00->DUPSER))
    if !sqlrelation()
      msg("* * * Requisi‡Æo nÆo encontrada: " + str(ADCR00->DUPNUM, 6) + " " + ADCR00->DUPSER + " * * *")
      return .f.
    else
      if substr(PCADES, 1, 7) == "ALUGUEL"
        return .t.
      else
        return .f.
      endif
    endif
  endif
endif

return .f.


***************
function MOSDCR2(TIPO,ORDEM)
***************

LOCAL cScr    := WVT_SaveScreen( 0,0,maxrow(),maxcol() )

if ORDEM = NIL
  ORDEM = 0
endif

private M_AB

M_DUPMAT = {}
M_DUPCHA = {}
M_DUPEND = {}
A_PAGAS = {}
A_ABERTAS = {}

R = 1

M_TOTDUP = 0
M_TOTPAG = 0
M_TOTVEN = 0
M_TOTAVE = 0
M_TOTJUR = 0

if ORDEM # 6  // pagamento
  if ORDEM = 3
    M_AB = 1
  else
    if TIPO == "N"  // ESTA OPCAO E PARA A LIBERACAO DO CLIENTE F1
      M_AB = msgbox3("Escolha uma opcao..","",,"Abertas","Pagas","Todas")
      if ORDEM = 3 .or. ORDEM = 11
        alertnew("Periodo inicial e final..",,,,,@M_VCTINI,@M_VCTFIN,"D")
        M_VCTINI = iif(empty(M_VCTINI),ctod("01/01/1900"),M_VCTINI)
        M_VCTFIN = iif(empty(M_VCTFIN),ctod("31/12/2099"),M_VCTFIN)
      endif
    else
      M_AB = 1
    endif
  endif
endif

do case
  case ORDEM = 2

      seexistesql("ATOTAIS")
      cSQL := "SELECT cast(sum(DUPVLA) as float) as SOMA FROM ADCR00 WHERE DUPVCT  BETWEEN "
      cSQL := cSQL + aspas(formatdta(M_VCTINI)) + " and " + aspas(formatdta(M_VCTFIN)) +;
       " AND DUPHIS = 500 "
      if M_DUPCLI > 0
        cSQL := cSQL + " AND DUPCLI = " + STR(M_DUPCLI,7)
      endif
      cSQL := cSQL + "union ALL "
      cSQL := cSQL + "SELECT cast(sum(DUPVLP) as float) as SOMA FROM ADCR00 WHERE DUPVCT BETWEEN "
      cSQL := cSQL + aspas(formatdta(M_VCTINI)) + " and " + aspas(formatdta(M_VCTFIN)) +;
      " AND DUPHIS = 100 "
      if M_DUPCLI > 0
        cSQL := cSQL + " AND DUPCLI = " + STR(M_DUPCLI,7)
      endif

      cSQL := cSQL + "union ALL "
      cSQL := cSQL + "SELECT cast(sum(DUPVLA) as float) as SOMA FROM ADCR00 WHERE DUPVCT BETWEEN "
      cSQL := cSQL + aspas(formatdta(M_VCTINI)) + " and " + aspas(formatdta(M_VCTFIN)) +;
      " AND DUPHIS = 500 and ((DUPVCT - current_date) < 0) "
      if M_DUPCLI > 0
        cSQL := cSQL + " AND DUPCLI = " + STR(M_DUPCLI,7)
      endif
      cSQL := cSQL + "union ALL "
      cSQL := cSQL + "SELECT cast(sum(DUPVLA) as float) as SOMA FROM ADCR00 WHERE DUPVCT BETWEEN "
      cSQL := cSQL + aspas(formatdta(M_VCTINI)) + " and " + aspas(formatdta(M_VCTFIN)) +;
      " AND DUPHIS = 500 and ((DUPVCT - current_date) >= 0) "
      if M_DUPCLI > 0
        cSQL := cSQL + " AND DUPCLI = " + STR(M_DUPCLI,7)
      endif
      dbuseareasql(.T.,"SQLMIX",cSQL,"ATOTAIS")

      M_TOTDUP = iif(HB_ISNIL(SOMA),0,SOMA)
      skip
      M_TOTPAG = iif(HB_ISNIL(SOMA),0,SOMA)
      skip
      M_TOTVEN = iif(HB_ISNIL(SOMA),0,SOMA)
      skip
      M_TOTAVE = iif(HB_ISNIL(SOMA),0,SOMA)

      seexistesql("ADCR00")
      cSQL := "SELECT ADCR00.*, ACLI00.CLINOM, ACLI00.CLITEL3 FROM ADCR00 "
      cSQL := cSQL + "left outer join ACLI00 ON ACLI00.CLICOD = ADCR00.DUPCLI "
      cSQL := cSQL + 'where DUPEMP > ' + aspas(str(0,2))
      cSQL := cSQL + " and DUPVCT BETWEEN " + aspas(formatdta(M_VCTINI)) + " and " + aspas(formatdta(M_VCTFIN))
      if M_DUPCLI > 0
        cSQL := cSQL + " AND DUPCLI = " + STR(M_DUPCLI,7)
      endif

      if M_AB = 3  // todas
      else
        if M_AB = 1 // abertas
          cSQL := cSQL + " and DUPHIS = 500"
        else
          cSQL := cSQL + " and DUPHIS = 100"
        endif
      endif
      cSQL := cSQL + " order by DUPEMP,DUPVCT"

      dbuseareaSQL(.T.,"SQLMIX",cSQL,"ADCR00")
  case ORDEM = 3
      seexistesql("ADCR00")
      cSQL := "SELECT ADCR00.*, ACLI00.CLINOM, ACLI00.CLITEL3 FROM ADCR00 "
      cSQL := cSQL + "left outer join ACLI00 ON ACLI00.CLICOD = ADCR00.DUPCLI "
      cSQL := cSQL + "where DUPVLO BETWEEN " + STR(M_VALINI,12,2) + " and " + STR(M_VALFIN,12,2)
      cSQL := cSQL + " and DUPHIS = 500"
      cSQL := cSQL + " order by DUPEMP,DUPVLO"
      dbusearea(.T.,"SQLMIX",cSQL,"ADCR00")
  case ORDEM = 4
      seexistesql("ATOTAIS")
      cSQL := "SELECT sum(DUPVLA) FROM ADCR00 WHERE "
      cSQL := cSQL + " DUPHIS = 500 and DUPCLI = " + STR(M_CODINI,6)
      cSQL := cSQL + "union ALL "
      cSQL := cSQL + "SELECT sum(DUPVLP) FROM ADCR00 WHERE "
      cSQL := cSQL + " DUPHIS = 100 and DUPCLI = " + STR(M_CODINI,6)
      cSQL := cSQL + "union ALL "
      cSQL := cSQL + "SELECT sum(DUPVLA) FROM ADCR00 WHERE "
      cSQL := cSQL + " DUPHIS = 500 and ((DUPVCT - current_date) < 0) and DUPCLI = " + STR(M_CODINI,6)
      cSQL := cSQL + "union ALL "
      cSQL := cSQL + "SELECT sum(DUPVLA) FROM ADCR00 WHERE "
      cSQL := cSQL + " DUPHIS = 500 and ((DUPVCT - current_date) >= 0) and DUPCLI = " + STR(M_CODINI,6)

      dbusearea(.T.,"SQLMIX",cSQL,"ATOTAIS")

      M_TOTDUP = iif(HB_ISNIL(SUM),0,SUM)
      skip
      M_TOTPAG = iif(HB_ISNIL(SUM),0,SUM)
      skip
      M_TOTVEN = iif(HB_ISNIL(SUM),0,SUM)
      skip
      M_TOTAVE = iif(HB_ISNIL(SUM),0,SUM)

      seexistesql("ADCR00")
      cSQL := "SELECT ADCR00.*, ACLI00.CLINOM, ACLI00.CLITEL3 FROM ADCR00 "
      cSQL := cSQL + "left outer join ACLI00 ON ACLI00.CLICOD = ADCR00.DUPCLI "
      cSQL := cSQL + "where DUPCLI = " + STR(M_CODINI,6)

      if M_AB = 3  // todas
      else
        if M_AB = 1 // abertas
          cSQL := cSQL + " and DUPHIS = 500"
        else
          cSQL := cSQL + " and DUPHIS = 100"
        endif
      endif
      cSQL := cSQL + " order by DUPEMP,DUPVCT"

      dbusearea(.T.,"SQLMIX",cSQL,"ADCR00")
  case ORDEM = 5
  case ORDEM = 6
      seexistesql("ADCR00")
      cSQL := "SELECT ADCR00.*, ACLI00.CLINOM, ACLI00.CLITEL3 FROM ADCR00 "
      cSQL := cSQL + "left outer join ACLI00 ON ACLI00.CLICOD = ADCR00.DUPCLI "
      cSQL := cSQL + "where DUPDTP BETWEEN " + aspas(formatdta(M_DTPINI)) + " and " + aspas(formatdta(M_DTPFIN))
      cSQL := cSQL + " order by DUPEMP,DUPDTP"
      dbusearea(.T.,"SQLMIX",cSQL,"ADCR00")
  endcase

setcolor("B/W")
@ 20, 85 say transform(M_TOTDUP,"@E ###,###,###.##")
@ 21, 85 say transform(M_TOTPAG,"@E ###,###,###.##")
setcolor("R/W")
@ 22, 85 say transform(M_TOTVEN,"@E ###,###,###.##")
setcolor("G/W")
@ 23, 85 say transform(M_TOTAVE,"@E ###,###,###.##")
setcolor("")


cARQUIVO = "ADCR00"
select ADCR00
go top

cColor  := SetColor( 'N/W,W/N+,W+/R,W+/G,N/W*,GR+/BG,R/W,G/W' )

oBrowse := TBrowseDB():New(6, 4,18,100 )

*aBlocks := {}


cCAMPOS = "TRAN(DUPNUM,[@R 999999]) + ' ' + TRAN(DUPORD,[@R 999]) + ' ' + TRAN(DUPCLI,[@R 99999])  + ' ' + pad(CLINOM,30)"
cCAMPOS += " + ' ' + dtoc(DUPDTE) + ' ' + dtoc(DUPVCT) + ' ' + iif(!HB_ISNIL(DUPDTP),dtoc(DUPDTP),'  /  /  ')"
cCAMPOS += " + ' ' + iif(DUPHIS = 100,str((DUPDTP - DUPVCT), 4),'    ')"
cCAMPOS += " + ' ' + TRAN( iif(DUPVLA=0,DUPVLP,DUPVLA),[@R 99999,999.99])"
cCAMPOS += " + ' ' + TRAN(DUPPOR,[@R 999]) + ' ' + iif(DUPHIS = 100,'PAGA',str((DUPVCT - date()),4))"

*oBrowse:addColumn(TBColumnNew("Titulo Ord Cliente                              Emissao  Vencto   Pgto     Atr   Valor       Por Atr",&("{||&cCAMPOS}")))

oBrowse:addColumn(TBColumnNew("Titulo",&("{||TRAN(DUPNUM,[@R 999999])}")))
oBrowse:addColumn(TBColumnNew("Ord",&("{||TRAN(DUPORD,[@R 99])}")))
oBrowse:addColumn(TBColumnNew("Cli",&("{||TRAN(DUPCLI,[@R 99999])}")))
oBrowse:addColumn(TBColumnNew("Cliente",&("{||pad(CLINOM,25)}")))
oBrowse:addColumn(TBColumnNew("Sit",&("{||iif(2=2,'  ','  ') }")))
oBrowse:addColumn(TBColumnNew("Emissao",&("{||dtoc(DUPDTE)}")))
oBrowse:addColumn(TBColumnNew("Vencto",&("{||dtoc(DUPVCT)}")))
oBrowse:addColumn(TBColumnNew("Pgto",&("{|| iif(!HB_ISNIL(DUPDTP),dtoc(DUPDTP),'  /  /  ')}")))
oBrowse:addColumn(TBColumnNew("Atr",&('{||iif(DUPHIS = 100,str((DUPDTP - DUPVCT), 4),"    ")}')))
oBrowse:addColumn(TBColumnNew("Valor",&("{||TRAN( iif(DUPVLA=0,DUPVLP,DUPVLA),[@R 99999,999.99])}")))
oBrowse:addColumn(TBColumnNew("Por",&("{||TRAN(DUPPOR,[@R 999])}")))
oBrowse:addColumn(TBColumnNew("Atr",&('{||iif(DUPHIS = 100,"PAGA",str((DUPVCT - date()),4))}')))
oBrowse:addColumn(TBColumnNew("Em",&("{||TRAN(DUPEMP,[@R 99])}")))

oBrowse:GetColumn(1):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(2):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(3):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(4):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(5):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(6):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(7):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(8):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(9):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(10):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(11):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(12):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(13):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }

oBrowse:ColSep        := ' '
oBrowse:HeadSep       := 'ÄÄ'
oBrowse:GoTopBlock    := { || dbGoTop() }
oBrowse:GoBottomBlock := { || dbGoBottom() }
oBrowse:SkipBlock     := { | nSkip | dbSkipBlock( nSkip,oBrowse ) }
oBrowse:freeze := 1
oBrowse:colPos := 1
oBrowse:configure()

nAjusta = 2

setcolor("N/W")
*@ 26,8+nAjusta say " Advogado "
*@ 26,19+nAjusta say " Negativa "
*@ 26,30+nAjusta say " Mensagem "
*@ 26,41+nAjusta say " Cartorio "
*@ 26,52+nAjusta say " 1.Ver Nota "
*@ 26,65+nAjusta say " 2.Email Nota "
*@ 26,80+nAjusta say " 3.Email Duplicata "

*setcolor("G/W")
*@ 26,9+nAjusta  say "A"
*@ 26,20+nAjusta say "N"
*@ 26,31+nAjusta say "M"
*@ 26,42+nAjusta say "C"
*@ 26,53+nAjusta say "1"
*@ 26,66+nAjusta say "2"
*@ 26,81+nAjusta say "3"
*setcolor("")

*Wvt_SetPen( 0, 2, rgb( 244,244,244 ) )
*aAdd( aBlocks2, {|| Wvt_DRAWBOXRECESSED( 26, 07, 26, 16)})
*aAdd( aBlocks2, {|| WVT_DRAWBOXRAISED( 26, 08+nAjusta, 26, 17+nAjusta)})
*aAdd( aBlocks2, {|| WVT_DRAWBOXRAISED( 26, 19+nAjusta, 26, 28+nAjusta)})
*aAdd( aBlocks2, {|| WVT_DRAWBOXRAISED( 26, 30+nAjusta, 26, 39+nAjusta)})
*aAdd( aBlocks2, {|| WVT_DRAWBOXRAISED( 26, 41+nAjusta, 26, 50+nAjusta)})
*aAdd( aBlocks2, {|| WVT_DRAWBOXRAISED( 26, 52+nAjusta, 26, 63+nAjusta)})
*aAdd( aBlocks2, {|| WVT_DRAWBOXRAISED( 26, 65+nAjusta, 26, 78+nAjusta)})
*aAdd( aBlocks2, {|| WVT_DRAWBOXRAISED( 26, 80+nAjusta, 26, 98+nAjusta)})

*aAdd( aBlocks2, {|| WVT_DRAWBOXRAISED( 26, 19, 26, 28)})
*alert2(10,108,{"  $Advogado  ","   $1.Nota   ","  $Negativa  ","  $Mensagem  ","  $Cartorio  ","Email $2.Nota","Email $3.Dupl"})

*aLastPaint9 := aLastPaint7
*WvtSetBlocks( aBlocks2 )

lKeyWaiting := .F.
lBrowse := .T.
lPosrecloc = 0
NpOSIC = { }
cPosic = ""
nc = 1

lMsg = .f.
lDUPNEG = .f.
lDUPPRO = .f.
lDUPADI = .f.

lMsg = ""
lDUPNEG = ""
lDUPPRO = ""
lDUPADI = ""

  *statusbotoes()

DO WHILE (lBrowse)

  oBrowse:RefreshCurrent()
	oBrowse:Stabilize()
  oBrowse:colPos := 1

  if DUPHIS = 500
    if DUPVCT >= date()
      oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{4,5} ) // linha/coluna que está com o cursor
    else
      oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{3,5} ) // linha/coluna que está com o cursor
    endif
  else
    oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{2,5} ) // linha/coluna que está com o cursor
  endif


  set color to B/W
  @ 20, 10+4 say pad(CLINOM , 40)
  @ 20, 58+4 say padl(alltrim(CLITEL3), 14)
  @ 21, 10+4 say pad(DUPOBS , 40)
  @ 22, 10+4 say pad(DUPOBT , 40)

  @ 21, 58+4 say DUPVLO picture "@E ###,###,###.##"
  @ 22, 58+4 say DUPDSC picture "@E ###,###,###.##"


  do while .t.
    nMouse := waitstate()
    nKey := lastkey()

    lAnterior = .f.


*    @ 22, 80 say nMouse[1]
*    @ 23, 80 say nMouse[2]
*    @ 24, 80 say nMouse[3]
*    @ 25, 80 say nKey

    if nKey = 1002 .and. nMouse[2] = 26  // click na linha 26
      do case
*        case nMouse[3] >= 8+nAjusta .and. nMouse[3] <= 17+nAjusta
*          nKey = asc("A")
*          exit
*        case nMouse[3] >= 19+nAjusta .and. nMouse[3] <= 28+nAjusta
*          nKey = asc("N")
*          exit
*        case nMouse[3] >= 30+nAjusta .and. nMouse[3] <= 39+nAjusta
*          nKey = asc("M")
*          exit
*        case nMouse[3] >= 41+nAjusta .and. nMouse[3] <= 50+nAjusta
*          nKey = asc("C")
*          exit
*        case nMouse[3] >= 52+nAjusta .and. nMouse[3] <= 63+nAjusta
*          nKey = asc("1")
*          exit
*        case nMouse[3] >= 65+nAjusta .and. nMouse[3] <= 78+nAjusta
 *         nKey = asc("2")
 *         exit
 *       case nMouse[3] >= 80+nAjusta .and. nMouse[3] <= 98+nAjusta
  *        nKey = asc("3")
  *        exit
      endcase
    endif

    if nKey < 1000
      exit
    endif

  enddo

*   do while .t.
*     nKey := nInKey(1)
*     if nKey # 0
*       exit
*     endif
*   enddo

   do case
    CASE nKey = K_CTRL_N // CTR + N
      if DUPSER == "RQ"
        if !BUSCAREGISTRO("AREQ00",1,{str(DUPEMP, 2, 0),str(DUPNUM, 6, 0),aspas(DUPSER)},"SELECT")
          msg("* * * REQUISICAO NAO CADASTRADA * * *")
        else
          lTelloc = savescreen(0,0,24,80)
          tlreq01()
          msreq01()
          msreq99()
          restscreen(0,0,24,80,lTelloc)
          set color to N/W,W+/N
        endif
      else
        if !BUSCAREGISTRO("ANFS00",1,{str(DUPEMP, 2, 0),str(DUPNUM, 9, 0),aspas(DUPSER)},"SELECT")
          msg("* * * NOTA FISCAL NAO CADASTRADA * * *")
        else
          lTelloc = savescreen(0,0,24,80)
          setcolor("B/B")

          M_NFSEMP = ADCR00->DUPEMP
          M_NFSNUM = ADCR00->DUPNUM
          M_NFSSER = ADCR00->DUPSER

          aTela = savescreen(0,0,maxrow(),maxcol())
          aBlock7114 := {}

          aAdd( aBlock7114, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
          aAdd( aBlock7114, {|| Wvt_DRAWBOXRECESSED( 03, 04, 20, 76) } )
          aAdd( aBlock7114, {|| WVT_DRAWBOXGROUP( 08, 04, 10, 76,{+15,,-15,})})
          aAdd( aBlock7114, {|| WVT_DRAWBOXGROUP( 08, 04, 20, 7 ,{+15,,,-10})})
          aAdd( aBlock7114, {|| WVT_DRAWBOXGROUP( 08, 08, 20, 14,{+15,-10,,-10})})
          aAdd( aBlock7114, {|| WVT_DRAWBOXGROUP( 08, 15, 20, 23,{+15,-10,,-10})})
          aAdd( aBlock7114, {|| WVT_DRAWBOXGROUP( 08, 24, 20, 54,{+15,-10,,-10})})
          aAdd( aBlock7114, {|| WVT_DRAWBOXGROUP( 08, 55, 20, 65,{+15,-10,,-10})})
          aPaint7114 := WvtSetBlocks( aBlock7114 )

          tlnfs01()


          msnfs03()
          msnfs04()
          vernfs5a()
          msg("* * * TECLE (ENTER) " + iif(ANFS00->NFSCAN="C","- NOTA CANCELADA","") + " * * *")
          WvtSetBlocks( aPaint7114 )
          RestScreen(0,0,maxrow(),maxcol(),aTela)
          restscreen(0,0,24,80,lTelloc)
          set color to N/W,W+/N
          select ADCR00
        endif
      endif


     CASE chr(nKey) $ "1"

     CASE chr(nKey) $ "Mm"

*       aTela = savescreen(0,0,maxrow(),maxcol())
*       M_CLINOM = CLINOM
*       nLininf = 1
*       nColinf = 4

*       aBlock7114 := {}
*       aPaint7114 := WvtSetBlocks( aBlock7114 )
*       moinf01()
*        edinf10()
*       select ADCR00
*       set cursor off
*       WvtSetBlocks( aPaint7114 )
*       RestScreen(0,0,maxrow(),maxcol(),aTela)

    CASE (nKey == 27)
      lBrowse := .F.

    CASE (nKey == K_ENTER)
       altobsdcr()




*      aBlocks2 := {}
 *     aObjects2:= WvtSetObjects( {} )
 *     aLastPaint2 := WvtSetBlocks( aBlocks2 )

 *     BUSCAREGISTRO("ACLI00",1,{str(ADCR00->DUPCLI,5,0)},"SELECT")
 *     M_TELA = savescreen(02, 04, 22, 77)
 *     tlcon03()
 *     mscon03("")
 *     set cursor off
 *     inkey(0)
 *     set cursor on
  *    restscreen(02, 04, 22, 77, M_TELA)

  *    WvtSetBlocks( aLastPaint2 )
  *    WvtSetObjects( aObjects2 )

 *     select &cARQUIVO

    CASE (nKey == K_DOWN)
      oBrowse:down()

    CASE (nKey == K_UP)
      oBrowse:up()

    CASE (nKey == K_PGDN)
      oBrowse:pageDown()

    CASE (nKey == K_PGUP)
      oBrowse:pageUp()

    CASE (nKey == K_CTRL_PGUP)
      oBrowse:goTop()

    CASE (nKey == K_CTRL_PGDN)
      oBrowse:goBottom()

    CASE (nKey == K_RIGHT)
      oBrowse:right()

    CASE (nKey == K_LEFT)
      oBrowse:left()

    CASE (nKey == K_HOME)
      oBrowse:home()

    CASE (nKey == K_END)
      oBrowse:end()

    CASE (nKey == K_CTRL_LEFT)
      oBrowse:panLeft()

    CASE (nKey == K_CTRL_RIGHT)
      oBrowse:panRight()

    CASE (nKey == K_CTRL_HOME)
      oBrowse:panHome()

    CASE (nKey == K_CTRL_END)
      oBrowse:panEnd()

    CASE (nKey == K_F3)

    CASE (nKey == K_F2)

    CASE (nKey == K_SPACE)

    CASE (nKey == K_ESC)
      lBrowse := .F.

    CASE (nKey # 13) .and. nkey > 0
    ENDCASE

   oBrowse:RefreshCurrent()
   oBrowse:Stabilize()

*   statusbotoes()

   end

   SetColor( cColor )
   WVT_RestScreen( 0, 0, maxrow(), maxcol(), cScr )

return ""

****************
function TLCON03
****************

sombra(07, 13, 17, 66, _SOMBRA_)

set color to BG+/B+
@ 07, 13 say     " ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄDados de CobrancaÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ "
@ 08, 13 say     "  Codigo  :             Cgc/Cpf:                      "
@ 09, 13 say     "  Nome    :                                           "
@ 10, 13 say     " ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ "
@ 11, 13 say     "  Endereco:                                           "
@ 12, 13 say     "  Bairro  :                            Cep:           "
@ 13, 13 say     "  Cidade  :                             Uf:           "
@ 14, 13 say     "  Telefone:                   Telex:                  "
@ 15, 13 say     "  Fax     :                 Contato:                  "
@ 16, 13 say     "  Tipo    :                     IES:                  "
@ 17, 13 say     "                                                      "
set color to

return ""

****************
function MSCON03
****************

set color to GR+/B+
@ 08, 25 say     CLICOD picture "#####"
@ 08, 46 say     CLICGC1 picture "@R 999.999.999/9999-99"
@ 09, 25 say     left(CLINOM, 40)
@ 11, 25 say     CLIEND3
@ 12, 25 say     CLIBAI3
@ 12, 57 say     CLICEP3
@ 13, 25 say     CLIMUN3
@ 13, 63 say     CLIUF3
@ 14, 25 say     CLITEL3
@ 14, 50 say     CLITEX3
@ 15, 25 say     CLIFAX3
@ 15, 50 say     CLICON
@ 16, 25 say     iif(CLITIP="C","CLIENTE","FORNECEDOR")
@ 16, 50 say     CLIIES1
set color to

return ""

****************
function TLCON01
****************

setcolor("BG/W")
nbox(03, 03, 24, 100,"W/W+",.f.)
@ 04, 04 say     "                                                                                                 "
@ 05, 04 say     "                                                                                                 "
@ 06, 04 say     "                                                                                                 "
@ 07, 04 say     "                                                                                                 "
@ 08, 04 say     "                                                                                                 "
@ 09, 04 say     "                                                                                                 "
@ 10, 04 say     "                                                                                                 "
@ 11, 04 say     "                                                                                                 "
@ 12, 04 say     "                                                                                                 "
@ 13, 04 say     "                                                                                                 "
@ 14, 04 say     "                                                                                                 "
@ 15, 04 say     "                                                                                                 "
@ 16, 04 say     "                                                                                                 "
@ 17, 04 say     "                                                                                                 "
@ 18, 04 say     "                                                                                                 "
@ 19, 04 say     "                                                                                                 "
@ 20, 04 say     "   Nome:                                            Fone:                   Aberto:              "
@ 21, 04 say     "    Obs:                                           Valor:                     Pago:              "
@ 22, 04 say     "       :                                         Descont:                 Vencidos:              "
@ 23, 04 say     "                                                                          A Vencer:              "
set color to

return ""


***************
function MOSDCRPES
***************

private M_AB

M_DUPMAT = {}
M_DUPCHA = {}
M_DUPEND = {}
A_PAGAS = {}
A_ABERTAS = {}

R = 1
M_TOTDUP = 0
M_TOTPAG = 0
M_TOTVEN = 0
M_TOTAVE = 0
M_TOTJUR = 0

SetBlink(.T.)

*if TIPO == "N"  // ESTA OPCAO E PARA A LIBERACAO DO CLIENTE F1
*  M_AB = alertnew("Escolha uma opcao..",{"Abertas","Pagas","Todas"},1)
*  if M_OPC = 3 .or. ORDEM = 11
*    alertnew("Periodo inicial e final..",,,,,@M_VCTINI,@M_VCTFIN,"D")
*    M_VCTINI = iif(empty(M_VCTINI),ctod("01/01/1900"),M_VCTINI)
*    M_VCTFIN = iif(empty(M_VCTFIN),ctod("31/12/2099"),M_VCTFIN)
*  endif
*else
*  M_AB = 1
*endif

SetBlink(.f.)

select ADCPES
produps()

      A_PAGAS   := asort(A_PAGAS,,,{|X,Y| X[3] < Y[3]})
      A_ABERTAS := asort(A_ABERTAS,,,{|X,Y| X[2] < Y[2]})
      A_DUPMAT = M_DUPMAT
      A_DUPCHA = M_DUPCHA
      A_DUPEND = M_DUPEND
      M_DUPMAT = { }
      M_DUPCHA = { }
      M_DUPEND = { }

      for A = 1 to len(A_PAGAS)
        aadd(M_DUPMAT,A_DUPMAT[A_PAGAS[A][4]])
        aadd(M_DUPCHA,A_DUPCHA[A_PAGAS[A][4]])
        aadd(M_DUPEND,A_DUPEND[A_PAGAS[A][4]])
      next
      for A = 1 to len(A_ABERTAS)
        aadd(M_DUPMAT,A_DUPMAT[A_ABERTAS[A][4]])
        aadd(M_DUPCHA,A_DUPCHA[A_ABERTAS[A][4]])
        aadd(M_DUPEND,A_DUPEND[A_ABERTAS[A][4]])
      next

do while .t.

  if len(M_DUPMAT) = 0
    exit
  endif

  ADCR00->( dbsetorder(1) , (dbseek(M_DUPCHA[1])))
  ACLI00->(dbsetorder(6),dbseek(str(ADCR00->DUPCLI, 5, 0)))

  set color to GR+/B+
  @ 17, 09 say pad(ACLI00->CLINOM , 40)
  @ 17, 59 say padl(alltrim(ACLI00->CLITEL3), 17)
  @ 18, 09 say pad(ADCR00->DUPOBS , 40)
  @ 18, 59 say ADCR00->DUPVLO picture "@E ##,###,###,###.##"
  @ 19, 09 say pad(ADCR00->DUPOBT , 40)
  @ 19, 59 say ADCR00->DUPDSC picture "@E ##,###,###,###.##"
  @ 20, 59 say ADCR00->DUPVIS
  set color to I

  set color to GR+
  @ 24, 00 say        "<Esp>Totais Advogado 1.Nota Neg.Ser Neg.Itau Msg Cartorio Email(2.Nota 3.Dupl)"
                      //1          12       21     28          40   45  49       58    64     71
  set color to R+
  @ 24, 01 say "Esp"
  @ 24, 12 say "A"
  @ 24, 21 say "1"
  @ 24, 28 say "N"
  @ 24, 40 say "I"
  @ 24, 45 say "M"
  @ 24, 49 say "C"
  @ 24, 64 say "2"
  @ 24, 71 say "3"

  setcolor("W+/GR,W+/N")

  keyboard chr(4)

  set color to N/W,W+/N
  M_ACHO = achoice(08,03,15,75,M_DUPMAT,,"achdcr")
  set color to

  if may_inkey(,.t.) = 27
    exit
  endif

enddo


ADCR00->(dbsetorder(1))

AEMP00->(dbseek(str(ME_EMP, 2, 0)))

set relation to

set cursor on

return ""

set relation to
set order to 1
set cursor on

return ""

****************
function PRODUPS
****************

do while !eof()

  if DTEMEN > M_VCTFIN
    exit
  endif

  select ADCR00
  if !dbseek(str(ME_EMP, 2, 0) + str(ADCPES->DUPNUM, 6, 0) + str(ADCPES->DUPORD, 2, 0) + ADCPES->DUPSER)
    select ADCPES
    skip
    loop
  endif

  M_ARQM = "&_PATH_\USR\MENSAGEM\ADCR00\" + strzero(ADCR00->DUPNUM,6) + strzero(ADCR00->DUPORD,2) + "." + ADCR00->DUPSER
  M_MEMO = memoRead("&M_ARQM")

  if empty(M_MEMO)
    select ADCPES
    skip
    loop
  endif

  M_JUR = DUPVLA

  if R <= 4000
    M_ARQM = "&_PATH_\USR\MENSAGEM\ADCR00\" + strzero(ADCR00->DUPNUM,6) + strzero(ADCR00->DUPORD,2) + "." + ADCR00->DUPSER
    M_MEMO = memoRead("&M_ARQM")
    aadd(M_DUPMAT,str(DUPNUM, 6, 0) + "³" + str(DUPORD, 2) + "³" + dtoc(DUPDTE) + "³" + dtoc(DUPVCT) + "³" + dtoc(DUPDTP) + "³" + iif(DUPHIS = 100,str((DUPDTP - DUPVCT), 3, 0),"   ")    + "³" + iif(!empty(M_MEMO),"M"," ") + DUPPRO + DUPNEG + DUPADI + transform(iif(DUPVLA=0,DUPVLP,M_JUR),"@E ######.##") + "³" + str(DUPCLI, 5, 0) + "³" + right(str(DUPPOR, 5, 0),3) + "³" + iif(DUPHIS = 500,str((DUPVCT - date()), 5, 0),"PAGA ")  + "³"  + iif(DUPREGISTR=="S","C"," "))
    aadd(M_DUPCHA,str(DUPEMP, 2, 0) + str(DUPNUM, 6, 0) + str(DUPORD, 2, 0) + DUPSER)
    aadd(M_DUPEND,{ADCR00->DUPCLI,ADCR00->CLISEQ})
    if ADCR00->DUPHIS = 100 // pagas
      aadd(A_PAGAS,{ADCR00->DUPDTE,ADCR00->DUPVCT,ADCR00->DUPDTP,len(M_DUPMAT)})
    else
      aadd(A_ABERTAS,{ADCR00->DUPDTE,ADCR00->DUPVCT,ADCR00->DUPDTP,len(M_DUPMAT)})
    endif
  endif

  msw("* * * AGUARDE ... PROCESSANDO (ESC) Abandona -=> " + str(R, 5) + " * * *")

*  if ADCR00->DUPVLA > 0
*    M_TOTJUR += (calc_juros() - ADCR00->DUPVLA)
*  else
 *   M_TOTJUR += (calc_juros() - ADCR00->DUPVLO)
 * endif

  if DUPHIS = 500
    M_TOTDUP = M_TOTDUP + M_JUR
    if DUPVCT - date() < 0
      M_TOTVEN = M_TOTVEN + M_JUR
    else
      M_TOTAVE = M_TOTAVE + M_JUR
    endif
  else
    M_TOTPAG = M_TOTPAG + DUPVLP
  endif

  R ++

  select ADCPES
  skip

enddo

return ""