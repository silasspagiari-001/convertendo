***************
function MANORC                        && manutencao de ORC
***************

#include "ptmenu.ch"

abre_orc0("2") && orc mestre && 6
abre_orc1("3") && orc itens  && 2
abre_cli ("4") && cliente    && 5 
abre_pca ("5") && produtos   && 6
abre_fis ("6") && fiscal     && 2
abre_ven ("7") && vendedores && 3 
abre_cpg ("8") && pagamentos && 3
abre_sld ("9") && saldos
abre_tra("10") && transporte && 3
abre_for("11") && fornecedor && 3
               && total      && 51

private M_OPC ,;
        M_TELA

    _FUNCLI_ = "ORCAMENTO.t."
    _FUNPRO_ = "ORCAMENTO.t."
    _FUNVEN_ = "ORCAMENTO.t."
    _FUNCPG_ = "ORCAMENTO.t."
    _FUNTRA_ = "ORCAMENTO.t."
    _FUNFOR_ = "ORCAMENTO.t."

    do while .t.

      rodape("MENU", "ORCAMENTO", M_FAN, "EAGRO77", "Mem: " + str(memory(0), 5), M_EMP)

      sombra(03, 61, 10, 71,_SOMBRA_)

      set color to N/BG
        @ 3, 61, 10, 71 box M_FRAME1a
      set color to W+/BG,W+/N
        @ 04, 62 prompt "Inclusao " HIGHLITE R/BG     
        @ 05, 62 prompt "Alteracao" HIGHLITE R/BG     
        @ 06, 62 prompt "Consulta " HIGHLITE R/BG     
        @ 07, 62 prompt "Exclusao " HIGHLITE R/BG     
        @ 08, 62 prompt "Listagem " HIGHLITE R/BG     
        @ 09, 62 prompt "Reemissao" POSITION 2 HIGHLITE R/BG     
        menu to M_OPC
      set color to 

      M_TELA = savescreen(02, 04, 21, 77)

      do case
         case M_OPC = 0
              exit
         case M_OPC = 1
              incorc()     
         case M_OPC = 2
              altorc()   
         case M_OPC = 3
              conorc()
         case M_OPC = 4
              excorc()
         case M_OPC = 5
              lisorc()
         case M_OPC = 6
              outorc()
      endcase

      restscreen(02, 04, 21, 77, M_TELA)

    enddo

    fecha_arq()

return ""

***************
function INCORC
***************

private M_TELA

declare M_ORCEMPIT[35],; 
        M_ORCNUMIT[35],; 
        M_ORCSEQIT[35],; 
        M_ORCMATIT[35],; 
        M_ORCQDEIT[35],; 
        M_ORCPRBIT[35],;
        M_ORCVLIIT[35],;
        M_ORCLIQIT[35]

    set key -1 to FUNCLI()
    set key -2 to FUNPRO()
    set key -3 to FUNVEN() 
    set key -4 to FUNCPG()
    set key -5 to FUNTRA()
    set key -9 to CALCULA()

    do while .t.

      rodape("INCLUSAO", "ORCAMENTO", M_FAN, "EAGRO77", "Mem: " + str(memory(0), 5), M_EMP)

      tlorc01()

       keyfun()                       && tela de funcoes

        M_ORCEMP  = ME_EMP
        M_ORCNUM  = AEMP00->EMPORC + 1
        M_ORCSER  = AEMP00->EMPOSE
        M_ORCCLI  = 0
        M_ORCVEN  = 0
        M_ORCCPG  = 0
        M_ORCTRA  = 1
        M_CLIUF2  = "SP"
         
        do while .t.
 setcolor("N/W*")
            @ 04, 15 say M_ORCNUM picture "######"
            @ 04, 22 say M_ORCSER picture "@!" 
          set color to
          select AORC00
          if dbseek(str(M_ORCEMP, 2, 0) + str(M_ORCNUM, 6, 0) + M_ORCSER)
            msg("* * * ORCAMENTO JA INCLUIDO * * *")
            keyfun()
            M_ORCNUM++
            loop
          endif
          exit
         enddo

         M_ORCDTE  = date()
         M_ORCDTS  = date()
         M_ORCCGC  = space(15)
         M_ORCNAT  = 0
         M_ORCAPL  = 0
         M_ORCDSC  = 0
         M_ORCHIS  = "N"
         M_DSCORC  = 0
         M_ORCCPL  = space(37)
         M_ORCVLM  = 0
         M_ORCFRE  = 0
         M_ORCVLN  = 0
         M_ORCCOM  = 0
         M_TOTORC  = 0
         M_ORCTIP  = " "
         M_ORCSIT  = "D"
         M_ORCVAL  = space(12)
         M_ORCFAT  = 0
         M_ORCOBS  = space(50)
    

         M_ORCVLD  = 0
         M_ORCIPL  = "I"

         M_ORCHS1 = "                                                            "
         M_ORCHS2 = "                                                            "
         M_ORCHS3 = "                                                            "
         M_ORCHS4 = "                                                            "
         M_ORCHS5 = "                                                            "
         M_LIMITE = 33
         R        = 0

        edorc01()     

        if M_ORCHIS = "S"
          verorc17() 
        endif

        if lastkey() = 27
          exit
        endif

        verorc20()

        if M_ORCCLI = 9999999
          cria_cli_orc()
        endif

        L      = 11
        LN     = 0

        for R = 1 to 35
          M_ORCEMPIT[R]=0
          M_ORCNUMIT[R]=0
          M_ORCSEQIT[R]=0
          M_ORCMATIT[R]=0
          M_ORCQDEIT[R]=0 
          M_ORCPRBIT[R]=0
          M_ORCVLIIT[R]=0
          M_ORCLIQIT[R]=0
        next

        for R = 1 to 33
          M_ORCEMPIT[R]=M_ORCEMP
          M_ORCNUMIT[R]=M_ORCNUM
          M_ORCSEQIT[R]=R 
          M_ORCMATIT[R]=0
          M_ORCQDEIT[R]=0 
          M_ORCPRBIT[R]=0
          M_ORCVLIIT[R]=0
          M_ORCLIQIT[R]=0
          M_FLAG       =0

          set color to I
            @ L, 05 say     M_ORCSEQIT[R] picture "##"
          SetColor(_COREDICAO_)
          @ L, 08 get     M_ORCMATIT[R] picture "######"       valid verorc6()
          @ L, 15 get     M_ORCQDEIT[R] picture "#####.##"     valid verorc7()
          @ L, 55 get     M_ORCPRBIT[R] picture "#######.##"   valid verorc8()
          read

          keyfun()                     && tela de funcoes

        if lastkey() = 27 
          if R = 1
            M_FLAG = 1
          endif
          M_ORCSEQIT[R]=0
          M_ORCMATIT[R]=0
          exit
        endif

        if L = 19
          lporc01()
          L = 10
        endif

        LN++

        if LN = M_LIMITE
          exit                          && encerra entrada de itens
        endif

        L++

      next &&  R

      if M_FLAG = 1
        loop
      endif
 
      M_TELA = savescreen(06, 20, 18, 60)

      do while .t.

        msorc02()                        && mostra dados

        M_OPC = sel_orc()

        do case
           case M_OPC = 0
             msg("* * * (ENTER) Continua  (ESC) Abandona * * *")
             if lastkey() = 27
               exit
             endif
             loop
           case M_OPC = 1
             emiorc(.t.)
             exit
           case M_OPC = 2
             altorcit()
           case M_OPC = 3
             incorcit()
           case M_OPC = 4
             excorcit()
        endcase 
      
      enddo

    enddo

  set key -1 to 
  set key -2 to 
  set key -3 to 
  set key -4 to 
  set key -5 to 

return ""

*****************
function ALTORCIT
*****************

  lporc01()                        && limpa a tela de itens

  L = 11
  R = 0

  SetColor(_COREDICAO_)
  @ L, 05 get R picture "##"
  read

  if R > M_LIMITE
    return .t.
  endif

  if R = 0
    return .t.
  endif

  if empty(M_ORCMATIT[R])
    msg("* * * SEQUENCIA NAO INCLUIDA * * *")
    keyfun()  
    return .t.
  endif

  set color to I
    @ L, 05 say     M_ORCSEQIT[R] picture "##"                             
  SetColor(_COREDICAO_)
  @ L, 08 get     M_ORCMATIT[R] picture "######"       valid verorc6()
  @ L, 15 get     M_ORCQDEIT[R] picture "#####.##"     valid verorc7()   
  @ L, 55 get     M_ORCPRBIT[R] picture "#######.##"   valid verorc8()   
  read

return .t.

*****************
function INCORCIT
*****************

  keyfun()

  lporc01()                        && limpa a tela de itens

  L  = 11
  R  = 1
  LN = 0

  do while .t.

    if M_ORCSEQIT[R] > 0
      R++
      LN++
      if LN >= M_LIMITE
        msg("* * * LIMITE DE ITENS ESGOTADO * * *")
        keyfun()
        exit
      endif
      loop
    endif

    M_ORCSEQIT[R]=R 

    set color to I
      @ L, 05 say     M_ORCSEQIT[R] picture "##"                             
    SetColor(_COREDICAO_)
    @ L, 08 get     M_ORCMATIT[R] picture "######"       valid verorc6()
    @ L, 15 get     M_ORCQDEIT[R] picture "#####.##"     valid verorc7()   
    @ L, 55 get     M_ORCPRBIT[R] picture "#######.##"   valid verorc8()   
    read

    if lastkey() = 27 
      M_ORCSEQIT[R]=0
      M_ORCMATIT[R]=0
      exit
    endif

    LN++
    R ++
    L ++

    if LN = M_LIMITE
      msg("* * * LIMITE DE ITENS ESGOTADO * * *")
      keyfun()
      exit
    endif

    if L = 19
      lporc01()
      L = 11
    endif

  enddo

return .t.

*****************
function EXCORCIT
*****************

  lporc01()                        && limpa a tela de itens

  L = 11
  R = 0

  SetColor(_COREDICAO_)
  @ L, 05 get R picture "##"
  read

  if R = 0
    return .t.
  endif

  if empty(M_ORCMATIT[R])
    msg("* * * SEQUENCIA NAO INCLUIDA * * *")
    keyfun()
    return .t.
  endif

  M_ORCEMPIT[R]=0
  M_ORCNUMIT[R]=0
  M_ORCSEQIT[R]=0
  M_ORCMATIT[R]=0
  M_ORCQDEIT[R]=0 
  M_ORCPRBIT[R]=0
  M_ORCVLIIT[R]=0
  M_ORCLIQIT[R]=0

return .t.

***************
function ALTORC
***************

private M_TELA ,;
        M_OPC 

declare M_ORCEMPIT[35],; 
        M_ORCNUMIT[35],; 
        M_ORCSEQIT[35],; 
        M_ORCSERIT[35],; 
        M_ORCMATIT[35],; 
        M_ORCQDEIT[35],; 
        M_ORCPRBIT[35],;
        M_ORCDSCIT[35],;
        M_ORCVLIIT[35],;
        M_ORCLIQIT[35]

    set key -1 to FUNCLI()
    set key -2 to FUNPRO()
    set key -3 to FUNVEN() 
    set key -4 to FUNCPG()

    do while .t.

      rodape("ALTERA", "ORCAMENTO", M_FAN, "EAGRO77", "Mem: " + str(memory(0), 5), M_EMP)

      tlorc01()

      keyfun()                       && tela de funcoes

      M_ORCEMP  = ME_EMP
      M_ORCNUM  = 0
      M_ORCSER  = AEMP00->EMPOSE

      SetColor(_COREDICAO_)
      @ 04, 15 get M_ORCNUM picture "######"
      @ 04, 22 get M_ORCSER picture "@!" 
      read

      if M_ORCNUM = 0 .or. lastkey() = 27
        exit
      endif

      select AORC00

      if !dbseek(str(M_ORCEMP, 2, 0) + str(M_ORCNUM, 6, 0) + M_ORCSER)
        msg("* * * ORCAMENTO NAO INCLUIDO * * *")
        keyfun()
        loop
      endif

      msorc01()

      msorc03()

      M_OPC = decide("Confirma Alteracao deste Orcamento")

      if M_OPC != 1
        loop
      endif

      select AORC00

      if !rlock()
        msg("* * * (AORC00) REGISTRO SENDO USADO * * *")
        keyfun()
        loop
      endif

      M_ORCDTE  = ORCDTE
      M_ORCDTS  = ORCDTS
      M_ORCCLI  = ORCCLI
      M_ORCNAT  = ORCNAT * .01
      M_ORCDSC  = ORCDSC
      M_ORCHIS  = ORCHIS
      M_DSCORC  = ORCVLD
      M_ORCVEN  = ORCVEN
      M_ORCCPG  = ORCCPG
      M_ORCCPL  = ORCCPL
      M_ORCVLM  = ORCVLM
      M_ORCFRE  = ORCFRE
      M_ORCVLN  = 0
      M_TOTORC  = 0
      M_ORCCOM  = ORCCOM
      M_ORCAPL  = ORCAPL

      M_ORCTIP  = ORCTIP
      M_ORCSIT  = ORCSIT

      M_ORCVLD  = 0
      M_ORCIPL  = ORCIPL
      M_ORCTRA  = ORCTRA

      M_ORCHS1 = ORCHS1
      M_ORCHS2 = ORCHS2
      M_ORCHS3 = ORCHS3
      M_ORCHS4 = ORCHS4
      M_ORCHS5 = ORCHS5

      M_ORCVAL = ORCVAL
      M_ORCFAT = ORCFAT
      M_ORCOBS = ORCOBS

      LN       = 0 
      M_LIMITE = 33
      M_CLIUF2 = "SP"

      for R = 1 to 33
        M_ORCEMPIT[R]=0
        M_ORCNUMIT[R]=0
        M_ORCSEQIT[R]=0
        M_ORCMATIT[R]=0
        M_ORCQDEIT[R]=0 
        M_ORCPRBIT[R]=0
        M_ORCVLIIT[R]=0
        M_ORCLIQIT[R]=0
      next

      select AORC01

      dbseek(str(AORC00->ORCEMP, 2, 0) + str(AORC00->ORCNUM, 6, 0) + AORC00->ORCSER, .t.)

      do while !eof() 
 
        if !str(ORCEMP, 2, 0) + str(ORCNUM, 6, 0) + ORCSER == str(AORC00->ORCEMP, 2, 0) + str(AORC00->ORCNUM, 6, 0) + AORC00->ORCSER
          exit
        endif

        M_ORCEMPIT[ORCSEQ] = ORCEMP
        M_ORCNUMIT[ORCSEQ] = ORCNUM
        M_ORCSEQIT[ORCSEQ] = ORCSEQ
        M_ORCMATIT[ORCSEQ] = ORCMAT
        M_ORCQDEIT[ORCSEQ] = ORCQDE
        M_ORCPRBIT[ORCSEQ] = ORCPRB
        M_ORCVLIIT[ORCSEQ] = ORCVLI
        M_ORCLIQIT[ORCSEQ] = ORCLIQ

        LN = LN + 1

        skip

      enddo

      retira_orc()            && retira o orcido do estoque e do financeiro

      edorc01()

      if M_ORCHIS = "S"
        verorc17() 
      endif

      keyfun()

      verorc20()

      M_TELA = savescreen(06, 20, 18, 60)

      do while .t.
        msorc02()                        && mostra dados
        M_OPC = sel_orc()
        do case
           case M_OPC = 0
             restscreen(06, 20, 18, 60, M_TELA)
             msg("* * * (ENTER) Continua  (ESC) Abandona * * *")
             if lastkey() = 27
               exit
             endif
             loop
           case M_OPC = 1
             emiorc(.f.)
             exit
           case M_OPC = 2
             altorcit()
           case M_OPC = 3
             incorcit()
           case M_OPC = 4
             excorcit()
        endcase 
      
      enddo

      msorc02()

      if lastkey() = 27
        msg("* * * ORCAMENTO NAO ALTERADO * * *")
        loop
      endif

      select AORC00                    && seleciona ORC mestre para gravacao 

      grorc01()                        && grava orcido mestre

      grorc03()                        && regrava orcido itens

      msg("* * * ORCAMENTO ALTERADO * * *")

    enddo

    set key -1 to 
    set key -2 to 
    set key -3 to 
    set key -4 to 
    set key -5 to 

return ""

***************
function CONORC
***************

private M_OPC ,;
        M_TELA

  do while .t.

      sombra(08, 54, 11, 64,_SOMBRA_)

      set color to N/BG
        @ 08, 54, 11, 64 box M_FRAME1a
      set color to W+/BG,W+/N
        @ 09, 55 prompt "Pre-Venda" HIGHLITE R/BG 
        @ 10, 55 prompt "Cliente  " HIGHLITE R/BG 
        menu to M_OPC
      set color to

      M_TELA = savescreen(02, 01, 21, 77)

      do case
        case M_OPC = 0 ; exit
        case M_OPC = 1 ; conorc_a()
        case M_OPC = 2 ; conorc_b("C")
      endcase             

      restscreen(02, 01, 21, 77, M_TELA)

  enddo

return ""

*****************
function CONORC_A
*****************

    do while .t.

      rodape("CONSULTA", "ORCAMENTO", M_FAN, "EAGRO77", "Mem: " + str(memory(0), 5), M_EMP)

      tlorc01()

      keyfun()                       && tela de funcoes

      M_ORCEMP  = ME_EMP
      M_ORCNUM  = 0
      M_ORCSER  = AEMP00->EMPOSE

      SetColor(_COREDICAO_)
      @ 04, 15 get M_ORCNUM picture "######"
      @ 04, 22 get M_ORCSER picture "@!" 
      read

      if M_ORCNUM = 0 .or. lastkey() = 27
        exit
      endif

      select AORC00

      if !dbseek(str(M_ORCEMP, 2, 0) + str(M_ORCNUM, 6, 0) + M_ORCSER)
        msg("* * * ORCAMENTO NAO INCLUIDO * * *")
        loop
      endif

      msorc01()
      msorc03()
 
      msg("* * * TECLE ENTER * * *")

    enddo

return ""

*****************
function CONORC_B
*****************

private MT_ITENS ,;
        MT_NUMPE ,;
        MT_OBSE1 ,;
        MT_OBSE2 ,;
        MT_OBSE3 ,;
        MT_REG   ,;
        M_TECLA     ,;
        M_TELA

  set key -1 to FUNCLI()

  do while .t.

    keyfun()

    rodape("CONSULTA", "PRE_VENDA", M_FAN, "EAGRO22","Mem: " + str(memory(0), 5), M_EMP)

    tlorc02()

    M_ORCEMP  = ME_EMP
    M_ORCCLI  = 0
    M_TECLA   = 0

    SetColor(_COREDICAO_)
    @ 04, 15 get M_ORCCLI picture "#####"
    read

    if lastkey() = 27
      exit
    endif

    select ACLI00
    if !dbseek(str(M_ORCCLI, 7, 0))
      msg("* * * CLIENTE NAO CADASTRADO * * *")
      loop
    endif
    
    set color to I
      @ 04, 29 say pad(ACLI00->CLINOM, 29)
      @ 04, 64 say pad(ACLI00->CLIMUN2, 12)
    set color to 
 
    select AORC00

    ( dbsetorder(6), dbseek(str(M_ORCEMP, 2, 0) + str(M_ORCCLI, 5, 0), .t.))

    if ORCCLI != M_ORCCLI
      msg("* * * NADA A CONSULTAR NESTE CLIENTE * * *")
      loop
    endif

      MT_ITENS = { }
      MT_NUMPE = { }
      MT_OBSE1 = { }
      MT_OBSE2 = { }
      MT_OBSE3 = { }
      MT_REG   = { }

    L = 8

    do while !eof()

      if ORCCLI != M_ORCCLI
        exit
      endif

      AVEN00->(dbseek(str(AORC00->ORCVEN, 3, 0)))
      aadd(MT_ITENS,dtoc(ORCDTE)  + "³" +  str(ORCNUM, 6, 0) + "³" + ORCSER + "³" + str(ORCCPG, 3, 0) + "³" + str(ORCTRA, 3, 0) + "³" + str(ORCVEN, 3, 0) + "³" + pad(AVEN00->VENNOM, 18) + "³" + str(ORCNAT * .01, 6, 2) + "³" + ORCSER +  "³" + transform(ORCVLN,"@E ####,###.##"))
      aadd(MT_NUMPE,str(ME_EMP, 2, 0) + str(ORCNUM, 6, 0) + ORCSER)
      aadd(MT_OBSE1,ORCHS1)
      aadd(MT_OBSE2,ORCHS2)
      aadd(MT_OBSE3,ORCHS3)
      aadd(MT_REG ,recno())
      skip 

    enddo

    set color to N/W,W+/N
      achoice(8,5,15,75,MT_ITENS,,"mosorc")
    set color to 

    setcursor(1)

  enddo

  AORC00->(dbsetorder(1))


return ""

***************
function EXCORC
***************

    do while .t.

      rodape("EXCLUI", "ORCAMENTO", M_FAN, "EAGRO77", "Mem: " + str(memory(0), 5), M_EMP)

      tlorc01()

      keyfun()                       && tela de funcoes

      M_ORCEMP  = ME_EMP
      M_ORCNUM  = 0
      M_ORCSER  = AEMP00->EMPOSE

      SetColor(_COREDICAO_)
      @ 04, 15 get M_ORCNUM picture "######"
      @ 04, 22 get M_ORCSER picture "@!" 
      read

      if M_ORCNUM = 0 .or. lastkey() = 27
        exit
      endif

      select AORC00

      if !dbseek(str(M_ORCEMP, 2, 0) + str(M_ORCNUM, 6, 0) + M_ORCSER)
        msg("* * * ORCAMENTO NAO INCLUIDO * * *")
        loop
      endif

      msorc01()
      msorc03()

      msg("* * * TECLE ENTER * * *")

      M_OPC = decide("Confirma Exclusao deste Orcamento")

      if M_OPC != 1
        msg("* * * ORCAMENTO NAO EXCLUIDO * * *")
        loop
      endif

      select AORC00

      if !rlock()
        msg("* * * (AORC00) REGISTRO SENDO USADO * * *")
        loop 
      endif

      retira_orc() && retira todos os lancamento do orcamento
 
      select AORC00
      elimina() 

      msg("* * * ORCAMENTO EXCLUIDO * * *")

  enddo

return ""

***************
function OUTORC
***************

private M_TELA ,;
        M_OPC 

declare M_ORCEMPIT[35],; 
        M_ORCNUMIT[35],; 
        M_ORCSEQIT[35],; 
        M_ORCSERIT[35],; 
        M_ORCMATIT[35],; 
        M_ORCQDEIT[35],; 
        M_ORCPRBIT[35],;
        M_ORCDSCIT[35],;
        M_ORCVLIIT[35],;
        M_ORCLIQIT[35]

    do while .t.

      rodape("REEMITE", "ORCAMENTO", M_FAN, "EAGRO77", "Mem: " + str(memory(0), 5), M_EMP)

      M_ORCEMP  = ME_EMP
      M_ORCNUM  = 0
      M_ORCSER  = AEMP00->EMPOSE

      sombra(10, 30, 12, 64,_SOMBRA_)

      set color to GR+/W
       @ 10, 30 say         "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 11, 30 say         "³ Orcamento Nro:        Serie:    ³" 
       @ 12, 30 say         "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
      set color to

      SetColor(_COREDICAO_)
      @ 11, 47 get M_ORCNUM picture "######"
      @ 11, 61 get M_ORCSER picture "@!"  
      read

      if lastkey() = 27
        return ""
      endif

      select AORC00

      if !dbseek(str(M_ORCEMP, 2, 0) + str(M_ORCNUM, 6, 0) + M_ORCSER)
        msg("* * * ORCAMENTO NAO INCLUIDO * * *")
        loop
      endif

      M_ORCDTE  = ORCDTE
      M_ORCDTS  = ORCDTS
      M_ORCCLI  = ORCCLI
      M_ORCNAT  = ORCNAT * .01
      M_ORCDSC  = ORCDSC
      M_ORCHIS  = ORCHIS
      M_DSCORC  = ORCVLD
      M_ORCVEN  = ORCVEN
      M_ORCCPG  = ORCCPG
      M_ORCCPL  = ORCCPL
      M_ORCVLM  = ORCVLM
      M_ORCFRE  = ORCFRE
      M_ORCVLN  = ORCVLN
      M_TOTORC  = 0
      M_ORCCOM  = ORCCOM
      M_ORCAPL  = ORCAPL

      M_ORCTIP  = ORCTIP
      M_ORCSIT  = ORCSIT

      M_ORCVLD  = 0
      M_ORCIPL  = ORCIPL
      M_ORCTRA  = ORCTRA

      M_ORCVAL  = ORCVAL
      M_ORCFAT  = ORCFAT
      M_ORCOBS  = ORCOBS

      M_ORCHS1 = ORCHS1
      M_ORCHS2 = ORCHS2
      M_ORCHS3 = ORCHS3
      M_ORCHS4 = ORCHS4
      M_ORCHS5 = ORCHS5
      LN       = 0 
      M_LIMITE = 33

      for R = 1 to 33
        M_ORCEMPIT[R]=0
        M_ORCNUMIT[R]=0
        M_ORCSEQIT[R]=0
        M_ORCMATIT[R]=0
        M_ORCQDEIT[R]=0 
        M_ORCPRBIT[R]=0
        M_ORCVLIIT[R]=0
        M_ORCLIQIT[R]=0
      next

      ACLI00->(dbseek(str(M_ORCCLI, 7, 0)))
      AVEN00->(dbseek(str(M_ORCVEN, 3, 0)))
      ACPG00->(dbseek(str(M_ORCCPG, 3, 0)))
      ATRA00->(dbseek(str(M_ORCTRA, 3, 0)))

      select AORC01

      dbseek(str(AORC00->ORCEMP, 2, 0) + str(AORC00->ORCNUM, 6, 0) + AORC00->ORCSER, .t.)

      do while !eof() 
 
        if !str(ORCEMP, 2, 0) + str(ORCNUM, 6, 0) + ORCSER == str(AORC00->ORCEMP, 2, 0) + str(AORC00->ORCNUM, 6, 0) + AORC00->ORCSER
          exit
        endif

        M_ORCEMPIT[ORCSEQ] = ORCEMP
        M_ORCNUMIT[ORCSEQ] = ORCNUM
        M_ORCSEQIT[ORCSEQ] = ORCSEQ
        M_ORCMATIT[ORCSEQ] = ORCMAT
        M_ORCQDEIT[ORCSEQ] = ORCQDE
        M_ORCPRBIT[ORCSEQ] = ORCPRB
        M_ORCVLIIT[ORCSEQ] = ORCVLI
        M_ORCLIQIT[ORCSEQ] = ORCLIQ

        LN++

        skip

      enddo


      M_IMPRE = impresn()

      if M_IMPRE = "N"
        return ""
      endif

      ?? chr(27) + "@"
      ?? chr(15)

      ?
      ?
      ?
      ?
      ?

      cab_eor1("")                   && imprime cabecalho

      M_FLAG = 0

      M_TOTPES = 0
      M_TOTPRO = 0
      M_TOTLIN = 0

      for R = 1 to 33
 
        if M_ORCMATIT[R] = 0
          loop
        endif

        select APCA00

        seek str(M_ORCMATIT[R], 6, 0)

        ? 
         ?? strzero(R, 4, 0)
         ?? " "
         ?? transform(M_ORCQDEIT[R],"@E@Z #####.##")
         ?? " "
         ?? pad(APCA00->PCAUNI, 2)
         ?? " "
         ?? str(APCA00->PCAMAT, 6, 0)
         ?? " " 
         ?? pad(APCA00->PCADES, 83)
         ?? " "
         ?? transform(M_ORCPRBIT[R],"@E ###,###.##") 
         ?? " "
         ?? iif(M_ORCQDEIT[R] > 0,transform(M_ORCVLIIT[R],"@E ##,###,###.##")," ") 

         M_TOTPES = M_TOTPES + (APCA00->PCAPLQ * M_ORCQDEIT[R])
         M_TOTPRO = M_TOTPRO + M_ORCQDEIT[R]                         
         M_TOTLIN++
 
         LN++

         if LN > 60
           cab_eor1("")
         endif

       next  && R 

       for R = M_TOTLIN to 5
         ?
       next

       ?? chr(18)

       ? space(50)
        ?? "Subtotal: R$ "
        ?? chr(27) + "E"
        ?? transform(M_ORCVLM,"@E ###,###,###.##")      
        ?? chr(27) + "F"

       ? space(49)
        ?? " Desconto: R$ "
        ?? chr(27) + "E"
        ?? transform(M_ORCVLD,"@E ###,###,###.##")      
        ?? chr(27) + "F"

       ? space(49)
        ?? "    Frete: R$ "
        ?? chr(27) + "E"
        ?? transform(M_ORCFRE,"@E ###,###,###.##")      
        ?? chr(27) + "F"

       ? space(51)
        ?? "Total  : R$ "
        ?? chr(27) + "E"
        ?? transform(M_ORCVLN,"@E ###,###,###.##")      
        ?? chr(27) + "F"
       ?

       ?
       ? cent_cab("","* * * REEMISSAO * * *","",80)
         
       eject

desliga1()

      msg("* * * ORCAMENTO REEMITIDO * * *")

    enddo

return ""

***************
function LISORC
***************

private M_TELA ,;
        M_OPC

   do while .t.

      rodape("MENU","RELATORIOS",M_FAN,"EAGRO77","Mem: " + str(memory(0), 5),M_EMP) 

      sombra(07, 42, 14, 65,_SOMBRA_)

      set color to N/BG
        @ 07, 42, 14, 65 box M_FRAME1a
      set color to W+/BG,W+/N
        @ 08, 43 prompt      "Listagem de Orcamentos" POSITION 1 HIGHLITE R/BG     
        @ 09, 43 prompt      "Relacao por Produto   " POSITION 1 HIGHLITE R/BG     
        @ 10, 43 prompt      "Orcamentos no Periodo " POSITION 1 HIGHLITE R/BG     
        @ 11, 43 prompt      "Resumo dos Orcamentos " POSITION 2 HIGHLITE R/BG     
        @ 12, 43 prompt      "Relacao por Cliente   " POSITION 3 HIGHLITE R/BG     
        @ 13, 43 prompt      "Analitico por Vendedor" POSITION 1 HIGHLITE R/BG     
        menu to M_OPC
      set color to

        M_TELA = savescreen(02, 04, 21, 79)

        do case
           case M_OPC = 0   
                exit
           case M_OPC = 1   
                lisorc_a()
           case M_OPC = 2  
                relorc_a()
           case M_OPC = 3  
                relorc_b()
           case M_OPC = 4   
                relorc_c()
           case M_OPC = 5  
                relorc_d()
           case M_OPC = 6  
                relorc_e()
        endcase

        restscreen(02, 04, 21, 79, M_TELA)
      
    enddo
  
return ""

*****************
function LISORC_A
***************** 

private M_ORC1 ,;
        M_ORC2 ,;
        M_SER1 ,;
        M_SER2 ,;
        LN     ,;
        PG     ,;
        M_ESC  ,;
        M_TELA
 
    do while .t.

        rodape("LISTA","ORCAMENTO",M_FAN,"EAGRO77","Mem: " + str(memory(0), 5),M_EMP) 

        store 0         to M_ORC1 ,;
                           M_ORC2

        store AEMP00->EMPOSE to M_SER1 ,;
                                M_SER2

        store date()           to M_DTA1 ,;
                                  M_DTA2 

        store "N"              to M_ORCIPL

       sombra(12, 21, 17, 57,_SOMBRA_)

       set color to GR+/W
         @ 12, 21 say                  "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
         @ 13, 21 say                  "³  Nro Orcamento Inicial:           ³" 
         @ 14, 21 say                  "³                  Final:           ³" 
         @ 15, 21 say                  "³   Data Emissao Inicial:           ³" 
         @ 16, 21 say                  "³                  Final:           ³" 
         @ 17, 21 say                  "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
         SetColor(_COREDICAO_)
         @ 13, 47 get M_ORC1 picture "######"
         @ 13, 54 get M_SER1 picture "@!"  
         @ 14, 47 get M_ORC2 picture "######"  
         @ 14, 54 get M_SER2 picture "@!"   
         @ 15, 47 get M_DTA1
         @ 16, 47 get M_DTA2
         read
       set color to

        if lastkey() = 27
          return ""
        endif

        M_ORC1 = iif(M_ORC1 = 0,     1,M_ORC1)
        M_ORC2 = iif(M_ORC2 = 0,999999,M_ORC2) 

        M_DTA1 = iif(dtoc(M_DTA1) = "  /  /  ",ctod("01/01/80"),M_DTA1)
        M_DTA2 = iif(dtoc(M_DTA2) = "  /  /  ",ctod("31/12/79"),M_DTA2) 

        select AORC00

        set relation to str(ORCEMP, 2, 0) + str(ORCNAT, 5, 0) into AFIS00 ,;
                     to str(ORCCLI, 7, 0)                     into ACLI00

        set order to 1

        dbseek(str(ME_EMP, 2, 0) + str(M_ORC1, 6, 0) + M_SER1,.t.)
       
        if eof()  .or. ORCEMP != ME_EMP
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          loop
        endif

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)
        endif

       store 0 to PG ,;
                  LN

       cab_orc1()                           && imprime cabecalho

       do while !eof()

          if str(ORCEMP, 2, 0) + str(ORCNUM, 6, 0) + ORCSER > str(ME_EMP, 2, 0) + str(M_ORC2, 6, 0) + M_SER2
            go bottom
            skip
            loop
          endif

          if ORCDTE < M_DTA1 .or. ORCDTE > M_DTA2
             skip
             loop
          endif

          cab_orc2()

           ? str(ORCNUM, 6, 0)
            ?? "  "
            ?? ORCSER
            ?? " "
            ?? str((ORCNAT * .01), 6, 2)
            ?? " "
            ?? pad(AFIS00->FISNOM, 27) 
            ?? " " 
            ?? ORCDTE
            ?? " "
            ?? str(ORCCLI, 7, 0)
            ?? " "
            ?? left(ACLI00->CLINOM, 32)
            ?? " " 
            ?? str(ORCVEN, 3, 0)
            ?? " "
            ?? ORCDTS
            ?? "  "
            ?? transform(ORCVLN,"@E ###,###,###.##") 
            ?? "  "
            ?? ORCIPL
 
            LN++

            if LN > 60
              cab_orc1()
              cab_orc2()
            endif  

            select AORC01

            dbseek(str(AORC00->ORCEMP, 2, 0) + str(AORC00->ORCNUM, 6, 0) + AORC00->ORCSER + "  ",.t.)

         cab_orc3()

         do while !eof() 

            if !str(ORCEMP, 2, 0) + str(ORCNUM, 6, 0) + ORCSER == str(AORC00->ORCEMP, 2, 0) + str(AORC00->ORCNUM, 6, 0) + AORC00->ORCSER
               exit
            endif

            APCA00->(dbseek(str(AORC01->ORCMAT, 6, 0)))

             ? "   " 
              ?? str(ORCSEQ, 2, 0)
              ?? "     " 
              ?? transform(str(ORCMAT, 6, 0),"@R 99.9999")
              ?? "            " 
              ?? str(APCA00->PCAMAT, 6, 0)
              ?? "   " 
              ?? pad(APCA00->PCADES, 40)
              ?? "      "
              ?? str(ORCQDE, 9, 3)
              ?? "  "
              ?? " "
              ?? " "
              ?? transform(ORCPRB,"@E ###,###,###.##") 
              ?? "  "
              ?? transform(ORCVLI,"@E ###,###,###.##") 
                         
              LN = LN + 1

              if LN > 60 
                cab_orc1()
                cab_orc3()
              endif
  
              skip 

         enddo

         select AORC00

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

       ? replicate("=", 132)

       eject

desliga1()

enddo 

return "" 

*****************
function RELORC_A                      && relacao de vendas por produtos
*****************

private M_TOTAL ,;
        M_DATA1 ,;
        M_DATA2 ,;
        M_ESC   ,;
        PG, LN  ,;
        M_TOTGER,;
        M_TOTVIS,;
        M_TOTPRZ,;
        M_SOMPER,;
        M_TELA  ,;
        M_TIPO
    
if file("AORC02.CDX")
  erase("AORC02.CDX")
endif

select 17         && orc temporario

use AORC02 alias AORC02 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif


    rodape("ORCAMENTOS","PRODUTO",M_FAN,"EAGRO77","Mem: " + str(memory(0), 5),M_EMP) 


    store date() to M_DATA1 ,;
                    M_DATA2

    store "S"    to M_TIPO

     sombra(13, 27, 17, 53,_SOMBRA_)
     set color to GR+/W+
       @ 13, 27 say      "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 14, 27 say      "³Periodo Inicial:         ³" 
       @ 15, 27 say      "³          Final:         ³" 
       @ 16, 27 say      "³    Ent/Sai/Tra:         ³" 
       @ 17, 27 say      "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
     SetColor(_COREDICAO_)
     @ 14, 45 get     M_DATA1
     @ 15, 45 get     M_DATA2 
     @ 16, 45 get     M_TIPO valid(M_TIPO $ "EST")
     read

     if lastkey() = 27
       return ""
     endif

     store 0 to M_TOTGER,;
                M_TOTPES

     select AORC02

     if !flock()
       msg("* * * (AORC02) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(ORCEMP, 2, 0) + str(ORCMAT, 6, 0)  tag 1 to AORC02
     index on str(ORCEMP, 2, 0) + str(ORCVLN, 14, 2) tag 2 to AORC02

     set index to AORC02 
  
     select AORC00

     set relation to str(ORCNAT, 5, 0) into AFIS00

     go top

        set order to 2 
         
        dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)

        if str(ORCEMP, 2, 0) + dtos(ORCDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2) .or. str(ORCEMP, 2, 0) + dtos(ORCDTE) < str(ME_EMP, 2, 0) + dtos(M_DATA1)
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          return ""
        endif
                
        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(ORCEMP, 2, 0) + dtos(ORCDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
            exit
          endif 
           
          if M_TIPO = "S"
            if rat(substr(str(ORCNAT, 5, 0), 1, 3),"#512#612") = 0
              skip
              loop
            endif
          endif

          if M_TIPO = "E"
            if rat(substr(str(ORCNAT, 5, 0), 1, 3),"#112#212") = 0
              skip
              loop
            endif
          endif

          if M_TIPO = "T"
            if rat(substr(str(ORCNAT, 5, 0), 1, 3),"#522") = 0
              skip
              loop
            endif
          endif

          select AORC01

          dbseek(str(AORC00->ORCEMP, 2, 0) + str(AORC00->ORCNUM, 6, 0) + AORC00->ORCSER,.t.)

          do while !eof()

            if str(AORC01->ORCEMP, 2, 0) + str(AORC01->ORCNUM, 6, 0) + AORC01->ORCSER > str(AORC00->ORCEMP, 2, 0) + str(AORC00->ORCNUM, 6, 0) + AORC00->ORCSER
              exit
            endif

            select AORC02
     
            seek str(AORC01->ORCEMP, 2, 0) + str(AORC01->ORCMAT, 6, 0)

            if eof()
              append blank         
              replace ORCEMP with AORC01->ORCEMP
              replace ORCMAT with AORC01->ORCMAT
            endif

            replace ORCQDE with ORCQDE + AORC01->ORCQDE

            if strzero(AORC00->ORCCPG, 3) $ "000#001#002"
              replace ORCVIS with ORCVIS + AORC01->ORCLIQ
              replace ORCVLN with ORCVLN + AORC01->ORCLIQ
            endif            

            if AORC00->ORCCPG > 9
              replace ORCPRZ with ORCPRZ + AORC01->ORCLIQ
              replace ORCVLN with ORCVLN + AORC01->ORCLIQ
            endif            

            M_TOTGER = M_TOTGER + AORC01->ORCLIQ
            M_TOTPES = M_TOTPES + AORC01->ORCQDE

            select AORC01

            M_ESC = inkey()

            if M_ESC = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                return ""
              else
                M_ESC = inkey()
              endif
            endif

            skip
 
          enddo
 
          select AORC00
 
          skip

        enddo
  

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)
        endif

        store  0 to PG, LN   ,;
                    M_TOTVIS ,;
                    M_TOTPRZ ,;
                    M_SOMPER ,;
                    M_TOTVCO ,;
                    M_TOTQCO 

        select AORC02

        set relation to str(ORCMAT, 6, 0) into APCA00

        set order to 2

        go bottom
                 
        do while !bof()
                              
            store PG + 1 to  PG 

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO DE " + iif(M_TIPO="S","VENDA",iif(M_TIPO="T","TRANSFERENCIA","COMPRA")) + " POR PRODUTOS","EAGRO77",132) 
            ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
            ? "*-------*----------------------------------------*---------*------------------*------------------*------------------*------*-------*"
            ? "* PROD  *        DESCRICAO DO PRODUTO            *  QTDE   *    A VISTA       *     A PRAZO      *   TOTAL VENDIDO  *% SFAT* REGUA *"
            ? "*-------*----------------------------------------*---------*------------------*------------------*------------------*------*-------*"
*               99999-9 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99999.999 ###,###,###,###.## ###,###,###,###.## ###,###,###,###.## ###,## ###,###

            store 5 to LN
  
            do while !bof() 
               
              if  LN > 60
                exit
              endif 
            
              ? " " 
               ?? transform(str(ORCMAT, 6, 0),"@R 99999-9")
               ?? " "
               ?? pad(APCA00->PCADES , 40)
               ?? " "
               ?? str(ORCQDE, 9, 3)
               ?? " "
               ?? transform(ORCVIS,"@E@Z ###,###,###,###.##")
               ?? " " 
               ?? transform(ORCPRZ,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(ORCVLN,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(((ORCVLN/M_TOTGER) * 100),"###.##")
               ?? " "
      
               M_SOMPER = M_SOMPER + ((ORCVLN/M_TOTGER) * 100)
              
               ?? transform(M_SOMPER,"####.##")

            LN++
                                
            M_TOTVIS = M_TOTVIS + ORCVIS
            M_TOTPRZ = M_TOTPRZ + ORCPRZ

            skip - 1
         
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
      ? space(31) 
        ?? "TOTAL GERAL..... "
        ?? " "
        ?? transform(M_TOTPES,"@E ######.###")
        ?? " "
        ?? transform(M_TOTVIS,"@E ###,###,###,###.##")
        ?? " "
        ?? transform(M_TOTPRZ,"@E ###,###,###,###.##")
        ?? " "
        ?? transform((M_TOTVIS + M_TOTPRZ),"@E ###,###,###,###.##")
      ? space(31) 
        ?? "TOTAL COMISSAO.. "
        ?? space(11)
        ?? transform(M_TOTQCO,"@E ##,###,###,###.###")
        ?? " "
        ?? "(Kg)          (R$)"
        ?? " "
        ?? transform(M_TOTVCO,"@E ###,###,###,###.##")

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(18)                       && descomprime
    endif

    eject

    unlock all

desliga1()

return ""

*****************
function RELORC_B                      && Pedidos no periodo
*****************

private M_TOTAL ,;
        M_DATA1 ,;
        M_DATA2 ,;
        M_ESC   ,;
        PG, LN  ,;
        M_TELA  ,;
        M_TIPO 

    rodape("RELACAO","ORCAMENTOS",M_FAN,"EAGRO77","Mem: " + str(memory(0), 5),M_EMP) 

    store date() to M_DATA1 ,;
                    M_DATA2


    store "S"    to M_TIPO

     sombra(13, 27, 17, 53,_SOMBRA_)
     set color to GR+/W+
       @ 13, 27 say      "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 14, 27 say      "³Periodo Inicial:         ³" 
       @ 15, 27 say      "³          Final:         ³" 
       @ 16, 27 say      "³    Ent/Sai/Tra:         ³" 
       @ 17, 27 say      "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
  SetColor(_COREDICAO_)
     @ 14, 45 get     M_DATA1
     @ 15, 45 get     M_DATA2 
     @ 16, 45 get     M_TIPO valid(M_TIPO $ "EST")
     read

     if lastkey() = 27
       return ""
     endif

        select AORC00

        set order to 3 

        go top
         
        dbseek(str(ME_EMP, 2, 0) + dtos(ctod("01" + substr(dtoc(M_DATA1), 3, 6))) + "    1",.t.)

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)
        endif

        store  0 to PG      ,;
                    LN      ,;
                    M_KILO  ,;
                    M_TOTPES,;
                    M_TOTDIN,;
                    M_TOTCHE,;
                    M_TOTBAN,;
                    M_TOTPEN,;
                    M_TOTORC,;
                    M_GERPES,;
                    M_GERDIN,;
                    M_GERCHE,;
                    M_GERBAN,;
                    M_GERPEN,;
                    M_GERORC

        select AORC00

        set relation to str(ORCCLI, 7, 0)                     into ACLI00 ,;
                     to str(ORCEMP, 2, 0) + str(ORCNAT, 5, 0) into AFIS00


        do while !eof()

          if str(ORCEMP, 2, 0) + dtos(ORCDTE) >= str(ME_EMP, 2, 0) + dtos(M_DATA1)
            exit
          endif 

          if M_TIPO = "S"
            if rat(substr(str(ORCNAT, 5, 0), 1, 3),"#512#612") = 0
              skip
              loop
            endif
          endif

          if M_TIPO = "E"
            if rat(substr(str(ORCNAT, 5, 0), 1, 3),"#112#212#111#211") = 0
              skip
              loop
            endif
          endif

          if M_TIPO = "T"
            if rat(substr(str(ORCNAT, 5, 0), 1, 3),"#522") = 0
              skip
              loop
            endif
          endif
          
          M_GERPES = M_GERPES + M_KILO
          M_GERORC = M_GERORC + ORCVLN

          skip

        enddo

        store ORCDTE to M_DTAANT

        cab_reo_b()                 

        do while !eof()

          if str(ORCEMP, 2, 0) + dtos(ORCDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
             go bottom
             skip
             loop
           endif 

           if M_TIPO = "S"
             if rat(substr(str(ORCNAT, 5, 0), 1, 3),"#512#612") = 0
               skip
               loop
             endif
           endif

           if M_TIPO = "E"
             if rat(substr(str(ORCNAT, 5, 0), 1, 3),"#112#212#111#211") = 0
               skip
               loop
             endif
           endif

          if M_TIPO = "T"
            if rat(substr(str(ORCNAT, 5, 0), 1, 3),"#522") = 0
              skip
              loop
            endif
          endif

              if ORCDTE != M_DTAANT
                ?
                ? space(71)
                 ?? "---------> TOTAL DO DIA           "
                 ?? transform(M_TOTPES,"@E ###,###.##")
                 ?? "  "
                 ?? transform(M_TOTORC,"@E ###,###,###.##")
                ? space(71)
                 ??  "---------> TOTAL DO MES           "
                 ?? transform(M_GERPES,"@E ###,###.##")
                 ?? "  "
                 ?? transform(M_GERORC,"@E ###,###,###.##")
                LN = LN + 3
                if LN > 56
                  cab_reo_b()
                endif
                ?
                ? space(30)
                  ?? "---------> RESUMO DO DIA - ** TOTAL EM DINHEIRO: "
                  ?? transform(M_TOTDIN,"@E ###,###,###.##")
                ? space(30)
                  ?? "                           ** TOTAL EM CHEQUE  : "
                  ?? transform(M_TOTCHE,"@E ###,###,###.##")
                ? space(30)
                  ?? "                           ** TOTAL EM BANCO   : "
                  ?? transform(M_TOTBAN,"@E ###,###,###.##")
                ? space(30)
                  ?? "                           ** TOTAL EM PENDENTE: "
                  ?? transform(M_TOTPEN,"@E ###,###,###.##")
                LN = LN + 5
                if LN > 56
                  cab_reo_b()
                endif
                M_TOTPES = 0
                M_TOTDIN = 0
                M_TOTCHE = 0
                M_TOTBAN = 0
                M_TOTPEN = 0
                M_TOTORC = 0
                M_DTAANT = ORCDTE
              endif


              ? " " 
                ?? str(ORCNUM, 6, 0)
                ?? " "
                ?? ORCSER 
                ?? " "
                ?? str(ORCCLI, 9, 0) 
                ?? " "
                if !empty(ORCCPL)
                  ?? pad(ORCCPL, 36)
                else
                  ?? left(ACLI00->CLINOM, 36) 
                endif
                ?? " "
                ?? ORCDTE
                ?? " "
                if ORCCPG = 1
                  ?? "A VISTA "
                else
                  if ORCCPG = 2
                    ?? "C/APRES "
                  else
                    ?? space(08)
                  endif
                endif
                ?? " "
                ?? space(08)
                ?? " "
                ?? space(08)
                ?? " "
                ?? " "
                ?? " "
                ?? str((ORCNAT * .01), 8, 2)
                ?? " " 
                ?? transform(M_KILO,"@E ###,###.##")
                ?? " "
                ?? ORCIPL
                ?? " "
                ?? " "
                ?? " "
                ?? transform(ORCVLN,"@E ####,###.##")

                LN = LN + 1

                if LN > 56
                  cab_reo_b()
                endif
     
                M_TOTPES = M_TOTPES + M_KILO

                M_GERPES = M_GERPES + M_KILO

                M_TOTORC = M_TOTORC + ORCVLN
                M_GERORC = M_GERORC + ORCVLN

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
                ?
                ? space(71)
                 ?? "---------> TOTAL DO DIA           "
                 ?? transform(M_TOTPES,"@E ###,###.##")
                 ?? "  "
                 ?? transform(M_TOTORC,"@E ###,###,###.##")
                ? space(71)
                 ??  "---------> TOTAL DO MES           "
                 ?? transform(M_GERPES,"@E ###,###.##")
                 ?? "  "
                 ?? transform(M_GERORC,"@E ###,###,###.##")
                LN = LN + 3
                if LN > 56
                  cab_reo_b()
                endif
                ?
                ? space(30)
                  ?? "---------> RESUMO DO DIA - ** TOTAL EM DINHEIRO: "
                  ?? transform(M_TOTDIN,"@E ###,###,###.##")
                ? space(30)
                  ?? "                           ** TOTAL EM CHEQUE  : "
                  ?? transform(M_TOTCHE,"@E ###,###,###.##")
                ? space(30)
                  ?? "                           ** TOTAL EM BANCO   : "
                  ?? transform(M_TOTBAN,"@E ###,###,###.##")
                ? space(30)
                  ?? "                           ** TOTAL EM PENDENTE: "
                  ?? transform(M_TOTPEN,"@E ###,###,###.##")
                ? space(30)
                  ?? "                         **** TOTAL G E R A L  : "
                  ?? transform((M_TOTDIN+M_TOTCHE+M_TOTBAN+M_TOTPEN),"@E ###,###,###.##")


    ? replicate("-", 132)

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(18)                       && descomprime
    endif

    eject

    select AORC00

desliga1()

return ""

******************
function CAB_REO_B
******************

  PG = PG + 1

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"RELACAO DE " + iif(M_TIPO="S","VENDA",iif(M_TIPO="T","TRANSFERENCIA","COMPRA")) + " NO PERIODO","EAGRO77",132) 
  ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
  ? "*------*--*---------*------------------------------------*--------*--------------------------*-*--------*----------*-*-*-----------*"
  ? "*ORCAMENTO*SR* CLIENTE *   NOME                             *EMISSAO *  V E N C I M E N T O S   *T*NATUREZA*  KILOS   *I*V* VALOR     *"
  ? "*------*--*---------*------------------------------------*--------*--------------------------*-*--------*----------*-*-*-----------*"
*     999999 99 999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99 99/99/99 X XXX XXXX ###,###.## # # ####,###.##    

  store 5 to LN

return ""

*****************
function RELORC_C                     && relacao de vendas por grupo
*****************

private M_TOTAL ,;
        M_DATA1 ,;
        M_DATA2 ,;
        M_ESC   ,;
        PG, LN  ,;
        M_TOTGER,;
        M_TOTVIS,;
        M_TOTPRZ,;
        M_SOMPER,;
        M_TELA  ,;
        M_TIPO

abre_grp("16") && grupos     && 3

if file("AORC04.CDX")
  erase("AORC04.CDX")
endif

select 17         && orc temporario
use AORC04 alias AORC04 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

    rodape("ORCAMENTOS","GRUPO",M_FAN,"EAGRO77","Mem: " + str(memory(0), 5),M_EMP) 


    store date() to M_DATA1 ,;
                    M_DATA2

    store "S"    to M_TIPO

     sombra(13, 27, 17, 53,_SOMBRA_)
     set color to GR+/W+
       @ 13, 27 say      "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 14, 27 say      "³Periodo Inicial:         ³" 
       @ 15, 27 say      "³          Final:         ³" 
       @ 16, 27 say      "³    Ent/Sai/Tra:         ³" 
       @ 17, 27 say      "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
  SetColor(_COREDICAO_)
     @ 14, 45 get     M_DATA1
     @ 15, 45 get     M_DATA2 
     @ 16, 45 get     M_TIPO valid(M_TIPO $ "EST")
     read

     if lastkey() = 27
       return ""
     endif

     store 0 to M_TOTGER

     select AORC04

     if !flock()
       msg("* * * (AORC04) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(ORCGRP, 4, 0) tag 1 to AORC04

     set index to AORC04 
  
     select AORC00

     set relation to str(ORCNAT, 5, 0) into AFIS00

     go top

     set order to 2 
         
        dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)

        if str(ORCEMP, 2, 0) + dtos(ORCDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2) .or. str(ORCEMP, 2, 0) + dtos(ORCDTE) < str(ME_EMP, 2, 0) + dtos(M_DATA1)
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          return ""
        endif
                
        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(ORCEMP, 2, 0) + dtos(ORCDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
            exit
          endif 
           
          if M_TIPO = "S"
            if rat(substr(str(ORCNAT, 5, 0), 1, 3),"#512#612") = 0
              skip
              loop
            endif
          endif

          if M_TIPO = "E"
            if rat(substr(str(ORCNAT, 5, 0), 1, 3),"#112#212#111#211") = 0
              skip
              loop
            endif
          endif

          if M_TIPO = "T"
            if rat(substr(str(ORCNAT, 5, 0), 1, 3),"#522") = 0
              skip
              loop
            endif
          endif

          select AORC01

          dbseek(str(AORC00->ORCEMP, 2, 0) + str(AORC00->ORCNUM, 6, 0) + AORC00->ORCSER,.t.)

          do while !eof()

            if !str(ORCEMP, 2, 0) + str(ORCNUM, 6, 0) + ORCSER == str(AORC00->ORCEMP, 2, 0) + str(AORC00->ORCNUM, 6, 0) + AORC00->ORCSER
              exit
            endif

            select APCA00

            seek str(AORC01->ORCMAT, 6, 0)

            select AORC04

            seek str(APCA00->PCAGRP, 4, 0)

            if eof()
              append blank         
              replace ORCGRP with APCA00->PCAGRP
            endif

            replace ORCQDE with ORCQDE + AORC01->ORCQDE
            replace ORCVLR with ORCVLR + AORC01->ORCLIQ

            select AORC01

            M_ESC = inkey()

            if M_ESC = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                return ""
              else
                M_ESC = inkey()
              endif
            endif

            skip
 
          enddo
 
          select AORC00
 
          skip

        enddo
  

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        store  0 to PG, LN   ,;
                    M_TOTCAI ,;
                    M_TOTMIU ,;
                    M_VLRCAI 
          
        select AORC04

        set relation to str(ORCGRP, 4, 0) into AGRP00

        go top
                 
        do while !eof()
                              
            PG++

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO DE " + iif(M_TIPO="S","VENDA",iif(M_TIPO="T","TRANSFERENCIA","COMPRA")) + " POR GRUPO","EAGRO77",80) 
            ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),80) 
            ? "*----*----------------------------*--------------*----------*------------------*"
            ? "*GRUP*     DESCRICAO DO GRUPO     *     VALOR    *  QTDE    *    PRECO MEDIO   *"
            ? "*----*----------------------------*--------------*----------*------------------*"
              * 9999 XXXXXXXXXXXXXXXXXXXXXXXXXXXX ###,###,###.## ###,###.## ###,###,###,###.##

            store 5 to LN
  
            do while !eof() 
               
              if  LN > 60
                exit
              endif 

              if ORCGRP = 0
                skip
                loop
              endif 

              ?
              ? " " 
               ?? str(ORCGRP, 4, 0)
               ?? " "
               ?? left(AGRP00->GRPNOM , 28)
               ?? " "
               ?? transform(ORCVLR,"@E@Z ###,###,###.##")
               if ORCGRP != 9999
                 ?? " " 
                 ?? transform(ORCQDE,"@Z #####.###")
                 ?? "   "
                 ?? transform(ORCVLR/ORCQDE,"@E@Z ####,###,###.##")
               endif
      
            LN = LN + 2
                                
            if ORCGRP = 9999
              M_TOTMIU = M_TOTMIU + ORCVLR
            else
              M_TOTCAI = M_TOTCAI + ORCQDE
              M_VLRCAI = M_VLRCAI + ORCVLR
            endif

            skip
         
            M_ESC = inkey()

            if M_ESC = 27
                if susimp()
                  ? replicate("-", 80)
                  ? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                else
                  M_ESC = inkey()
                endif
            endif

          enddo

      enddo

      ? chr(27) + "E"
      ? "TOTAL EM PRODUTOS:                 " 
        ?? transform(M_VLRCAI,"@E@Z ###,###,###.##")
        ?? " "
        ?? transform(M_TOTCAI,"@E@Z ###,###.##")
        ?? "    "
        ?? transform(M_VLRCAI/M_TOTCAI,"@E@Z ###,###,###.##")
      ?
      ? "TOTAL GERAL   :                    " 
        ?? transform((M_TOTMIU+M_VLRCAI),"@E@Z ###,###,###.##")
        ?? chr(27) + "F"

    eject

    unlock all

desliga1()

return ""

*****************
function RELORC_D
*****************

private M_TOTAL ,;
        M_DATA1 ,;
        M_DATA2 ,;
        M_TELA  ,;
        M_TIPO  ,;
        M_ESC   ,;
        PG, LN  

if file("ACLI01.CDX")
  erase("ACLI01.CDX")
endif

select 17        && resumo

use ACLI01 alias ACLI01 exclusive

if neterr()
  msg("* * * (ACLI01) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

rodape("RELACAO","CLIENTE",M_FAN,"EAGRO77","Mem: " + str(memory(0), 5),M_EMP) 

    store date() to M_DATA1 ,;
                    M_DATA2

    store "S"    to M_TIPO

     sombra(13, 27, 17, 53,_SOMBRA_)
     set color to GR+/W+
       @ 13, 27 say      "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 14, 27 say      "³Periodo Inicial:         ³" 
       @ 15, 27 say      "³          Final:         ³" 
       @ 16, 27 say      "³    Ent/Sai/Tra:         ³" 
       @ 17, 27 say      "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
  SetColor(_COREDICAO_)
     @ 14, 45 get     M_DATA1
     @ 15, 45 get     M_DATA2 
     @ 16, 45 get     M_TIPO valid(M_TIPO $ "EST")
     read

     if lastkey() = 27
       return ""
     endif

     select ACLI01

     if !flock()
       msg("* * * (ACLI01) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(CLICOD, 5, 0)  tag 1 to ACLI01
     index on str(CLITOT, 14, 2) tag 2 to ACLI01
     set index to ACLI01

     select AORC00

     set order to 3 
         
     dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)

        if str(ORCEMP, 2, 0) + dtos(ORCDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2) .or. str(ORCEMP, 2, 0) + dtos(ORCDTE) < str(ME_EMP, 2, 0) + dtos(M_DATA1)
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          return ""
        endif

        store 0 to M_CLITOT

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(ORCEMP, 2, 0) + dtos(ORCDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
            go bottom
            skip
            loop
          endif 

          if M_TIPO = "S"
            if rat(substr(str(ORCNAT, 5, 0), 1, 3),"#512#612") = 0
              skip
              loop
            endif
          endif

          if M_TIPO = "E"
            if rat(substr(str(ORCNAT, 5, 0), 1, 3),"#112#212#111#211") = 0
              skip
              loop
            endif
          endif

          if M_TIPO = "T"
            if rat(substr(str(ORCNAT, 5, 0), 1, 3),"#520") = 0
              skip
              loop
            endif
          endif

          if ORCCPG > 3 .and. ORCCPG < 10
            skip
            loop
          endif

          select ACLI01

          seek str(AORC00->ORCCLI, 7, 0)

            if eof()
              append blank
              replace CLICOD with AORC00->ORCCLI
            endif
   
            if AORC00->ORCCPG < 3
               replace CLIVIS with CLIVIS + AORC00->ORCVLN
               replace CLITOT with CLITOT + AORC00->ORCVLN
               M_CLITOT = M_CLITOT        + AORC00->ORCVLN
            else
              if AORC00->ORCCPG > 9
                replace CLIPRZ with CLIPRZ + AORC00->ORCVLN
                replace CLITOT with CLITOT + AORC00->ORCVLN
                M_CLITOT = M_CLITOT        + AORC00->ORCVLN
              endif
            endif

            select AORC00

             M_ESC = inkey()

             if M_ESC = 27
                 if suspro()
                   msg("* * * PROCESSO SUSPENSO * * *")
                   return ""
                 else
                   M_ESC = inkey()
                 endif
             endif

            skip  

        enddo


        select ACLI01

        set order to 2

        set relation to str(CLICOD, 7, 0) into ACLI00

        go bottom
                
        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        store  0 to PG      ,;
                    LN      ,;
                    M_TOTVIS,;
                    M_TOTPRZ,;
                    M_SOMPER

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)
        endif
          
        do while !bof()
                              
            store PG + 1 to  PG 

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO DE " + iif(M_TIPO="S","VENDA",iif(M_TIPO="T","TRANSFERENCIA","COMPRA")) + " POR CLIENTE/FORNECEDOR","EAGRO77",132) 
              ? cent_cab(M_DATA,"ORCIODO: " + dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
              ? "*---------*------------------------------*---------------*--*------------------*------------------*------------------*------*------*"
              ? "* CLIENTE *     DESCRICAO                *   MUNICIPIO   *UF*     A VISTA      *    A PRAZO       *      TOTAL       *% SFAT* REGUA*"
              ? "*---------*------------------------------*---------------*--*------------------*------------------*------------------*------*------*"
*                     99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XX ###,###,###,###.## ###,###,###,###.## ###,###,###,###.## ###.## ###.##

            store 5 to LN
  
            do while !bof() .and. LN < 60

                  ? "     "
                   ?? str(CLICOD, 5, 0)
                   ?? " "
                   ?? left(ACLI00->CLINOM, 30)
                   ?? " "
                   ?? left(ACLI00->CLIMUN1, 15) 
                   ?? " "
                   ?? ACLI00->CLIUF1
                   ?? " "
                   ?? transform(CLIVIS,"@E@Z ###,###,###,###.##")
                   ?? " "
                   ?? transform(CLIPRZ,"@E@Z ###,###,###,###.##")
                   ?? " "
                   ?? transform((CLIVIS + CLIPRZ),"@E@Z ###,###,###,###.##")
                   ?? " "
                   ?? transform(((CLITOT/M_CLITOT) * 100),"###.##")
                   ?? " "
                   M_SOMPER = M_SOMPER + ((CLITOT/M_CLITOT) * 100)
                   ?? transform(M_SOMPER,"###.##")

                M_TOTVIS = M_TOTVIS + CLIVIS
                M_TOTPRZ = M_TOTPRZ + CLIPRZ

              LN = LN + 1

              skip -1
               
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
        ? "TOTAL PERIODO.. "
        ?? space(44)
        ?? " "
        ?? transform(M_TOTVIS,"@E ###,###,###,###.##")
        ?? " "
        ?? transform(M_TOTPRZ,"@E ###,###,###,###.##")
        ?? " "
        ?? chr(27) + "E"
        ?? transform((M_TOTVIS + M_TOTPRZ),"@E ###,###,###,###.##")
        ?? chr(27) + "F"
        ? replicate("-", 132)

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(27) + "F"                       && descomprime
        endif

        eject

        unlock all
 
desliga1()

return ""

*****************
function RELORC_E                      && relacao de analitica por vendedor
*****************

private M_TOTAL ,;
        M_DATA1 ,;
        M_DATA2 ,;
        M_ESC   ,;
        PG, LN  ,;
        M_TOTGER,;
        M_TOTVIS,;
        M_TOTPRZ,;
        M_SOMPER,;
        M_TELA 

if file("AORC05.CDX")
  erase("AORC05.CDX")
endif

select 17        && nfs temporario

use AORC05 alias AORC05 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif


    rodape("ANALITICO","VENDEDOR",M_FAN,"EAGRO77","Mem: " + str(memory(0), 5),M_EMP) 

    store date() to M_DATA1 ,;
                    M_DATA2

    store "S"    to M_TIPO

     sombra(13, 27, 17, 67,_SOMBRA_)
     set color to GR+/W+
       @ 13, 27 say      "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 14, 27 say      "³Periodo Inicial:         ³" 
       @ 15, 27 say      "³          Final:         ³" 
       @ 16, 27 say      "³    Ent/Sai/Tra:         ³" 
       @ 17, 27 say      "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
  SetColor(_COREDICAO_)
     @ 14, 45 get     M_DATA1
     @ 15, 45 get     M_DATA2 
     @ 16, 45 get     M_TIPO valid(M_TIPO $ "EST")
     read

     if lastkey() = 27
       return ""
     endif

     store 0 to M_TOTGER ,;
                M_TOTPES
   
     select AORC05

     if !flock()
       msg("* * * (AORC05) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(ORCEMP, 2, 0) + str(ORCVEN, 3, 0) + str(ORCMAT, 6, 0)  tag 1 to AORC05
     index on str(ORCEMP, 2, 0) + str(ORCVEN, 3, 0) + str(ORCVLN, 14, 2) tag 2 to AORC05

     set index to AORC05   
  
     select AORC00

     set relation to str(ORCNAT, 5, 0) into AFIS00 ,;
                  to str(ORCVEN, 3, 0) into AVEN00

     go top

        set order to 2 
         
        dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)

        if str(ORCEMP, 2, 0) + dtos(ORCDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2) .or. str(ORCEMP, 2, 0) + dtos(ORCDTE) < str(ME_EMP, 2, 0) + dtos(M_DATA1)
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          return ""
        endif
                
        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(ORCEMP, 2, 0) + dtos(ORCDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
            exit
          endif 
           
          if ORCCPG > 2 
            if ORCCPG < 10
              skip
              loop
            endif
          endif       

          select AORC01

          set softseek on
            seek str(AORC00->ORCEMP, 2, 0) + str(AORC00->ORCNUM, 6, 0) + AORC00->ORCSER
          set softseek off

          do while !eof()

            if str(AORC01->ORCEMP, 2, 0) + str(AORC01->ORCNUM, 6, 0) + AORC01->ORCSER > str(AORC00->ORCEMP, 2, 0) + str(AORC00->ORCNUM, 6, 0) + AORC00->ORCSER
              exit
            endif

            select AORC05
     
            seek str(AORC01->ORCEMP, 2, 0) + str(AVEN00->VENCOD, 3, 0) + str(AORC01->ORCMAT, 6, 0)

            if eof()
              append blank         
              replace ORCEMP with AORC01->ORCEMP
              replace ORCVEN with AVEN00->VENCOD
              replace ORCMAT with AORC01->ORCMAT

            endif

            replace ORCQDE with ORCQDE + AORC01->ORCQDE

            if AORC00->ORCCPG = 1 .or. AORC00->ORCCPG = 2
              replace ORCVIS with ORCVIS + AORC01->ORCLIQ
              replace ORCVLN with ORCVLN + AORC01->ORCLIQ
            endif            

            if AORC00->ORCCPG > 9
              replace ORCPRZ with ORCPRZ + AORC01->ORCLIQ
              replace ORCVLN with ORCVLN + AORC01->ORCLIQ
            endif            

            M_TOTGER = M_TOTGER + AORC01->ORCLIQ

            select AORC01

            M_ESC = inkey()

            if M_ESC = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                return ""
              else
                M_ESC = inkey()
              endif
            endif

            skip
 
          enddo
 
          select AORC00
 
          skip

        enddo
  

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)
        endif

        store  0 to PG, LN   ,;
                    M_TOTVIS ,;
                    M_TOTPRZ ,;
                    M_VENVIS ,;
                    M_VENPRZ ,;
                    M_SOMPER ,;
                    M_VENANT ,;
                    M_VENPES
          
        select AORC05

        set relation to str(ORCMAT, 6, 0) into APCA00 ,;
                     to str(ORCVEN, 3, 0) into AVEN00

        set order to 2

        go top
                 
        do while !eof()
                              
            store PG + 1 to  PG 

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO ANALITICA POR VENDEDOR","EAGRO21D",132) 
            ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
            ? "*-------*----------------------------------------*---------*------------------*------------------*------------------*------*-------*"
            ? "* PROD  *        DESCRICAO DO PRODUTO            *  QTDE   *    A VISTA       *     A PRAZO      *   TOTAL VENDIDO  *% SFAT* REGUA *"
            ? "*-------*----------------------------------------*---------*------------------*------------------*------------------*------*-------*"
*               99999.9 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99999.999 ###,###,###,###.## ###,###,###,###.## ###,###,###,###.## ###,## ###,###

            store 5 to LN
  
            do while !eof() 
               
              if  LN > 60
                exit
              endif 

             if ORCVEN != M_VENANT
                if (M_VENVIS + M_VENPRZ) > 0
                  ? space(31) 
                    ?? "TOTAL VENDEDOR.."
                    ?? " "
                    ?? transform(M_VENPES,"###,###.###")
                    ?? " "
                    ?? transform(M_VENVIS,"@E ###,###,###,###.##")
                    ?? " " 
                    ?? transform(M_VENPRZ,"@E ###,###,###,###.##")
                    ?? " "
                    ?? transform((M_VENVIS + M_VENPRZ),"@E ###,###,###,###.##")
                  ? replicate("-", 132)
                  LN = LN + 2
                 endif
                 M_VENANT = ORCVEN
                 M_VENPES = 0
                 M_VENVIS = 0
                 M_VENPRZ = 0
                ? "***** VENDEDOR: "
                 ?? str(ORCVEN, 3, 0)
                 ?? " "
                 ?? AVEN00->VENNOM
                 ?? " "
                 ?? AVEN00->VENMUN
                 ?? " "
                 ?? AVEN00->VENEST
                 ?? " "
                 ?? AVEN00->VENTEL
                 ?? "  *****"
                ?
                 LN = LN + 2
              endif       
            
              ? " " 
               ?? transform(str(ORCMAT, 6, 0),"@R 99.9999")
               ?? " "
               ?? left(APCA00->PCADES , 35)
               ?? "      "
               ?? str(ORCQDE, 9, 3)
               ?? " "
               ?? transform(ORCVIS,"@E@Z ###,###,###,###.##")
               ?? " " 
               ?? transform(ORCPRZ,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(ORCVLN,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(((ORCVLN/M_TOTGER) * 100),"###.##")
               ?? " "
      
               M_SOMPER = M_SOMPER + ((ORCVLN/M_TOTGER) * 100)
              
               ?? transform(M_SOMPER,"####.##")

            LN = LN + 1
                                
            M_VENVIS = M_VENVIS + ORCVIS
            M_VENPRZ = M_VENPRZ + ORCPRZ
            M_TOTVIS = M_TOTVIS + ORCVIS
            M_TOTPRZ = M_TOTPRZ + ORCPRZ

            M_VENPES = M_VENPES + ORCQDE
            M_TOTPES = M_TOTPES + ORCQDE

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
        ? space(31) 
        ?? "TOTAL VENDEDOR.."
        ?? " "
        ?? transform(M_VENPES,"###,###.###")
        ?? " "
        ?? transform(M_VENVIS,"@E ###,###,###,###.##")
        ?? " " 
        ?? transform(M_VENPRZ,"@E ###,###,###,###.##")
        ?? " "
        ?? transform((M_VENVIS + M_VENPRZ),"@E ###,###,###,###.##")
      ? space(31) 
        ?? "TOTAL GERAL....."
        ?? " "
        ?? transform(M_TOTPES,"###,###.###")
        ?? " "
        ?? transform(M_TOTVIS,"@E ###,###,###,###.##")
        ?? " "
        ?? transform(M_TOTPRZ,"@E ###,###,###,###.##")
        ?? " "
        ?? transform((M_TOTVIS + M_TOTPRZ),"@E ###,###,###,###.##")

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(18)                       && descomprime
    endif

    eject

    unlock all

desliga1()

return ""

****************
function TLORC01                      
****************

sombra(03, 04, 20, 76,_SOMBRA_)

set color to I
    @ 03, 04 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
    @ 04, 04 say     "³Orcament:           Cli:            Cpg:              Tra:     His:    ³"
    @ 05, 04 say     "³Opera‡„o:           Ven:          % Dsc:           R$ Dsc:             ³"
    @ 06, 04 say     "³Mensagem:                           Dte:           R$ Fre:             ³"
    @ 07, 04 say     "³                                    Dts:                               ³"
    @ 08, 04 say     "ÃÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´"
    @ 09, 04 say     "³Sq³Codigo³  Qtde  ³         Descri‡„o            ³ Unit rio ³  Total   ³"
    @ 10, 04 say     "ÃÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´"
    for zz = 11 to 19
    @ zz, 04 say     "³  ³      ³        ³                              ³          ³          ³"
    next
    @ 20, 04 say     "ÀÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ"
set color to 

return ""

****************
function EDORC01  
****************

  SetColor(_COREDICAO_)
    @ 04, 30 get     M_ORCCLI picture "#######"   valid verorc1()
    @ 04, 46 get     M_ORCCPG picture "###"     valid verorc10() 
    @ 04, 64 get     M_ORCTRA picture "###"     valid verorc12()
    @ 04, 73 get     M_ORCHIS picture "@!" valid(M_ORCHIS $ "SN")  

    @ 05, 15 get     M_ORCNAT picture "###.##"  valid verorc3()  
    @ 05, 30 get     M_ORCVEN picture "###"     valid verorc11() 
    @ 05, 46 get     M_ORCDSC picture "##.##" 
    @ 05, 64 get     M_DSCORC picture "#########.##"             

    @ 06, 15 get     M_ORCCPL picture "@!@S25"  

    @ 06, 46 get     M_ORCDTE                   valid(M_ORCDTE != ctod("  /  /  "))
    @ 06, 64 get     M_ORCFRE picture "#########.##"             

    @ 07, 46 get     M_ORCDTS    

    read

return ""


****************
function MSORC01  
****************

  set color to I

    @ 04, 15 say ORCNUM picture "######"
    @ 04, 22 say ORCSER picture "@!" 

    @ 04, 30 say     ORCCLI         picture "#######"  
    @ 04, 46 say     ORCCPG         picture "###"    
    @ 04, 64 say     ORCTRA         picture "###"    
    @ 04, 73 say     ORCHIS         picture "@!" 

    @ 05, 15 say     (ORCNAT * .01) picture "###.##" 
    @ 05, 30 say     ORCVEN         picture "###"    
    @ 05, 46 say     ORCDSC         picture "##.##" 
    @ 05, 64 say     DSCORC         picture "#########.##"             

    @ 06, 15 say     ORCCPL         picture "@!@S25"
    @ 06, 46 say     ORCDTE
    @ 06, 64 say     ORCFRE         picture "#########.##"

    @ 07, 46 say     ORCDTS

  set color to

return ""

****************
function MSORC02                       && mostra dados e calcula nota fiscal
****************

    private  L,;
             R
             

    store 0 to M_ORCVLM  ,;
               M_ORCVLD  ,;
               M_ORCVLN  

    store  0 to LN       ,;
                M_IND    ,; 
                M_TOTORC 

    for R = 1 to 33                    && calcula o valor bruto da nota
      if M_ORCMATIT[R] = 0
        loop
      endif
      M_TOTORC = M_TOTORC + M_ORCVLIIT[R]
    next

    for R = 1 to 33                    && calcula o valor liquido da nota
      if M_ORCMATIT[R] = 0
        loop
      endif
      if M_DSCORC > 0
        M_ORCLIQIT[R] = (M_ORCVLIIT[R] - ((M_DSCORC/M_TOTORC) * M_ORCVLIIT[R]))
      else
        M_ORCLIQIT[R] = M_ORCVLIIT[R] 
      endif
      M_ORCVLM = M_ORCVLM + M_ORCVLIIT[R]
      M_ORCVLD = M_ORCVLD + (M_ORCVLIIT[R] - M_ORCLIQIT[R])
      M_ORCVLN = M_ORCVLN + M_ORCLIQIT[R]
    next R

    M_ORCVLN = M_ORCVLN + M_ORCFRE

    L = 11
    
    for R = 1 to 33

        if M_ORCMATIT[R] = 0
          loop
        endif

        APCA00->(dbseek(str(M_ORCMATIT[R], 6, 0)))

        set color to I
          @ L, 05 say   M_ORCSEQIT[R] picture "##"
          @ L, 08 say   M_ORCMATIT[R] picture "######"
          @ L, 15 say   M_ORCQDEIT[R] picture "#####.##"
          @ L, 24 say   left(APCA00->PCADES, 30)
          @ L, 55 say   M_ORCPRBIT[R] picture "#######.##"
          @ L, 66 say   M_ORCVLIIT[R] picture "#######.##"
        set color to

        L++

        if L > 19
          msg("* * * TECLE ENTER * * *")
          lporc01()
          L = 11
        endif

    next R

    aprorc()

return ""

****************
function LPORC01
****************

private K

set color to I
  for K = 11 to 19
    @ K, 04 say "³  ³      ³        ³                              ³          ³          ³"
  next &&  K
set color to 

return ""

***************
function APRORC                       && apuracao da orc
***************

nTela = savescreen(06, 20, 12, 60)

sombra(06, 20, 11, 59,_SOMBRA_)

set color to GR+/BG+
  @ 06, 20 say  "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
  @ 07, 20 say  "³Valor das Mercadorias:                ³" 
  @ 08, 20 say  "³Valor dos Descontos  :                ³" 
  @ 09, 20 say  "³Despesas (FRE/SEG)   :                ³" 
  @ 10, 20 say  "³Valor do Orcamento   :                ³" 
  @ 11, 20 say  "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
set color to 

set color to GR+/BG+
  @ 07, 45 say M_ORCVLM              picture "@E ###,###,###.##"
  @ 08, 45 say M_ORCVLD              picture "@E ###,###,###.##"
  @ 09, 45 say M_ORCFRE              picture "@E ###,###,###.##"
  @ 10, 45 say M_ORCVLN              picture "@E ###,###,###.##"
set color to

inkey(0)

restscreen(06, 20, 12, 60, nTela)

return .t.

*****************
function VERORC1                       && procura cliente
*****************

  if M_ORCCLI = 0
    funcli()
  endif

  if M_ORCCLI = 9999999
    M_CLIUF2 = "SP"
    M_ORCNAT = 512.00
    return .t.
  endif

  if !ACLI00->(dbseek(str(M_ORCCLI, 7, 0)))
    msg("* * * CLIENTE NAO CADASTRADO - 99999 Cadastra * * *")
    keyfun()
    return .f.
  endif

  msg(rtrim(ACLI00->CLINOM) + " - " + rtrim(ACLI00->CLIMUN2) + " " + ACLI00->CLIUF2)

  M_CLIUF2 = ACLI00->CLIUF2
  M_ORCTRA = ACLI00->CLITRA
  M_ORCVEN = ACLI00->CLIVEN

  if rat(M_CLIUF2,"MT#MS#TO#PA#AM#RD#RN#SE#PE#RO#AP#AL#CE#BA#DF#GO#MA#NO") > 0
    if ACLI00->CLIIES1 = "ISENTO"
      M_ORCNAT = 612.00
    else
      M_ORCNAT = 612.00
    endif
  else
    if rat(M_CLIUF2,"PR#SC#MG#RJ#RS#ES") > 0              
      if ACLI00->CLIIES1 = "ISENTO"
        M_ORCNAT = 612.00
      else
        M_ORCNAT = 612.00
      endif
    else
      M_ORCNAT = 512.00
    endif
  endif

  keyfun()


return .t.    

*****************
function VERORC02                       && procura condicao
*****************

  if lastkey() = 5
    return .t.
  endif

  if M_ORCCPG = 0
    return .f.
  endif

  if !ACPG00->(dbseek(str(M_ORCCPG, 3, 0)))
    msg("* * * CONDICAO DE PAGAMENTO NAO CADASTRADA * * *")
    keyfun()
    return .f.
  endif

  if M_ORCCPG > 499 
    msg("* * * CONDICAO INVALIDA PARA VENDA * * *")
    return .f.
  endif

  msg(alltrim(ACPG00->CPGDES))

  keyfun()

return .t.    

****************
function VERORC3                       && ve natureza
****************

  if lastkey() = 5
    return .t.
  endif

  if M_ORCNAT = 0
    return .f.
  endif

  select AFIS00

  if !dbseek(str(ME_EMP, 2, 0) + str((M_ORCNAT*100), 5, 0))
    msg("* * * OPERACAO NAO CADASTRADA * * *")
    keyfun()
    return .f.
  endif

  if M_OPC = 1
    M_ORCAPL = FISAPL
  endif

  if FISCOD < 50000
    msg("* * * NATUREZA INVALIDA PARA VENDA * * *")
    M_ORCNAT = 0
    keyfun()
    return .f.
  endif

  msg("* * * " + alltrim(FISNOM) + " - " +   FISICM + " %"  +  " * * *")

  M_ORCAPL  = FISAPL

  keyfun()

  M_ORCCPL = pad("O R C A M E N T O", 37)

  keyfun()

return .t.

*****************
function VERORC04                       && procura vendedor
*****************

  if lastkey() = 5 
    return .t.
  endif

  if M_ORCVEN = 0
    return .f.
  endif

  if !AVEN00->(dbseek(str(M_ORCVEN, 3, 0)))
    msg("* * * VENDEDOR NAO CADASTRADO * * *")
    keyfun()
    return .f.
  endif

  msg(alltrim(AVEN00->VENNOM))

  keyfun()

return .t.    

****************
function VERORC6                       && procura produto
****************

    if lastkey() = 5
        return .t.
    endif

    if M_ORCMATIT[R] = 0
      funpro()
    endif

    select APCA00

    if M_ORCMATIT[R] = 999999
      set key -3 to FUNFOR() 
      if !criapro_on()
        M_ORCMATIT[R] = 0
        set key -3 to FUNVEN() 
        return .f.
      endif     
    endif

    if !dbseek(str(M_ORCMATIT[R], 6, 0))
      msg("* * * PRODUTO NAO CADASTRADO * * *")
      M_ORCMATIT[R] = 0
      keyfun()
      return .f.
    endif

    set color to I
      @ L, 24 say left(PCADES, 30)  
    set color to

    ASLD00->(dbseek(str(M_ORCEMP, 2, 0) + str(M_ORCMATIT[R], 6, 0)))

    M_ORCPRBIT[R] = ASLD00->SLDPRC

return .t.    

****************
function VERORC7                       && valor > 0
****************

  if lastkey() = 5
    return .t.
  endif

  if M_ORCQDEIT[R] = 0
    return .t.
  endif

  ASLD00->(dbseek(str(M_ORCEMP, 2, 0) + str(M_ORCMATIT[R], 6, 0)))

  if M_ORCDSC > 0
    M_ORCPRBIT[R] = ASLD00->SLDPRC - ((ASLD00->SLDPRC * .01) * M_ORCDSC)
  else
    M_ORCPRBIT[R] = ASLD00->SLDPRC
  endif

  if ACPG00->CPGACR > 0
    M_ORCPRBIT[R] = round(ASLD00->SLDPRC + ((ASLD00->SLDPRC * .01) * ACPG00->CPGACR), 2)
  endif

return .t.

****************
function VERORC8                       && quantidade * valor unitario
****************

if lastkey() = 5
  return .t.
endif

if M_ORCPRBIT[R] = 0
  return .f.
endif

M_ORCVLIIT[R] = (iif(M_ORCQDEIT[R] = 0, 1, M_ORCQDEIT[R]) * M_ORCPRBIT[R])

set color to I
 @ L, 66 say     M_ORCVLIIT[R] picture "#######.##"
set color to 

return .t.

***************** 
function VERORC10                      && condicao de pagamento
*****************

if lastkey() = 5
  return .t.
endif

if M_ORCCPG = 0
  return .f.
endif

select ACPG00

if !dbseek(str(M_ORCCPG, 3, 0))
  msg("* * * CONDICAO DE PAGTO NAO CADASTRADA * * *")
  keyfun()
  return .f.
endif

msg(rtrim(CPGDES))

keyfun()

return .t.

**************** 
function VERORC11                      && procura vendedor
**************** 

    if lastkey() = 5
        return .t.
    endif

    if M_ORCVEN = 0 
        return .f.
    endif

    select AVEN00

    if !dbseek(str(M_ORCVEN, 3, 0))
      msg("* * * VENDEDOR NAO CADASTRADO * * *")
      keyfun()
      return .f.
    endif

    msg(rtrim(VENNOM) + " - " + rtrim(VENMUN) + " " + VENEST)

    keyfun()

return .t.    

*****************
function VERORC12                      && procura transportadora
*****************

    if lastkey() = 5
        return .t.
    endif

    if M_ORCTRA = 0 
        return .f.
    endif

    select ATRA00

    if !dbseek(str(M_ORCTRA, 3, 0))
      msg("* * * TRANPORTADORA NAO CADASTRADA * * *")
      keyfun()
      return .f.
    endif

    msg(rtrim(TRANOM) + " - " + rtrim(TRAMUN) + " " + TRAPLC)

    keyfun()

return .t.    

*****************
function VERORC13
*****************

if len(rtrim(M_ORCCGC)) = 15
  if !cgc(right(M_ORCCGC, 14))
    msg("* * * CGC INVALIDO * * *")
    return .t.
  endif
else
  if len(rtrim(M_ORCCGC)) = 11
    if !cpf(left(M_ORCCGC, 11))
      msg("* * * CPF INVALIDO * * *")
      return .t.
    endif
  else
    msg("* * * NAO E UM CGC/CPF * * *")
    return .t.
  endif
endif

return .t.

****************
function VERORC14                      && procura cliente
****************

    if lastkey() = 5
        return .t.
    endif

    if M_ORCCLI = 0 
        return.f.
    endif

    select ACLI00

    if !dbseek(str(M_ORCCLI, 7, 0))
      msg("* * * CLIENTE NAO CADASTRADO * * *")
      keyfun()
      M_ORCCLI = 0
      return .f.
    endif

    msg(rtrim(CLINOM) + " - " + rtrim(CLIMUN1) + " " + CLIUF1)

    M_CLIUF2 = CLIUF2

    keyfun()

return .t.    

*****************
function VERORC16
*****************

private M_TELA

  if !M_ORCSIT $ "ABCD"
    M_TELA = savescreen(09, 18, 15, 61)
    sombra(09, 18, 14, 60,_SOMBRA_)
    set color to G+/RB+
      @ 09, 18 say  "ÚÄÄÄÄÄÄÄSituacao de Acao do PedidoÄÄÄÄÄÄÄÄ¿"
      @ 10, 18 say  "³A - Gera Apenas o Estoque                ³"
      @ 11, 18 say  "³B - Gera Apenas o Financeiro             ³"
      @ 12, 18 say  "³C - Gera Financeiro e Baixa o Estoque    ³"
      @ 13, 18 say  "³D - Apenas Emite o Pedido                ³"
      @ 14, 18 say  "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
    set color to
    msg("* * * Tecle (ENTER) * * *")
    restscreen(09, 18, 15, 61, M_TELA)
    return .f.
  endif
    
return .t.


*****************
function VERORC17                      
*****************

private M_TELA

M_TELA = savescreen(08, 10, 14, 72)

sombra(08, 10, 13, 71,_SOMBRA_)

setcolor("GR+/BG+")
 @ 09, 10 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHistoricoÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
 @ 10, 10 say     "³                                                            ³"
 @ 11, 10 say     "³                                                            ³"
 @ 12, 10 say     "³                                                            ³"
 @ 13, 10 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
setcolor("")

do while .t.
  
  SetColor(_COREDICAO_)
  @ 10, 11 get M_ORCHS1 picture "@!"
  @ 11, 11 get M_ORCHS2 picture "@!"
  @ 12, 11 get M_ORCHS3 picture "@!"
  read

  msg("* * * (ENTER) Continua  (PgDn) Sai * * *")

  if lastkey() = 3
    exit
  endif

enddo

restscreen(08, 10, 14, 72, M_TELA)

keyfun()

return ""


**************** 
function GRORC01                       && grava orcido
**************** 

  select AORC00                   && seleciona ORC mestre para gravacao 

    do while .t. 
       if rlock()
         replace ORCEMP  with M_ORCEMP
         replace ORCNUM  with M_ORCNUM
         replace ORCSER  with M_ORCSER
         replace ORCDTE  with M_ORCDTE
         replace ORCDTS  with M_ORCDTS
         replace ORCCLI  with M_ORCCLI
         replace ORCCPL  with M_ORCCPL
         replace ORCCOM  with M_ORCCOM
         replace ORCNAT  with (M_ORCNAT * 100)
         replace ORCAPL  with M_ORCAPL
         replace ORCTRA  with M_ORCTRA
         replace ORCVLM  with M_ORCVLM
         replace ORCDSC  with M_ORCDSC
         replace DSCORC  with M_DSCORC
         replace ORCVEN  with M_ORCVEN
         replace ORCHIS  with M_ORCHIS
         replace ORCTIP  with M_ORCTIP
         replace ORCSIT  with M_ORCSIT
         replace ORCCPG  with M_ORCCPG  
         replace ORCFRE  with M_ORCFRE
         replace ORCVLN  with M_ORCVLN
         replace ORCVLD  with M_ORCVLD  
         replace ORCIPL  with M_ORCIPL
         replace ORCHS1  with M_ORCHS1
         replace ORCHS2  with M_ORCHS2
         replace ORCHS3  with M_ORCHS3
         replace ORCHS4  with M_ORCHS4
         replace ORCHS5  with M_ORCHS5
         replace ORCVAL  with M_ORCVAL 
         replace ORCFAT  with M_ORCFAT 
         replace ORCOBS  with M_ORCOBS 
         unlock
         commit
         exit 
       else
         msg("* * * (AORC00) REGISTRO SENDO USADO * * *")
       endif
       if lastkey()=17
         exit
       endif
    enddo

return ""

**************** 
function GRORC02                       && grava orcido itens
**************** 

private R

  for R = 1 to 33 

    if M_ORCMATIT[R] = 0
      loop
    endif

    select AORC01                      && seleciona ORC itens 

    _append("AORC01")

    do while .t.
      if rlock()
        replace ORCEMP  with M_ORCEMP
        replace ORCNUM  with M_ORCNUM
        replace ORCSER  with M_ORCSER
        replace ORCSEQ  with M_ORCSEQIT[R]
        replace ORCMAT  with M_ORCMATIT[R]
        replace ORCQDE  with M_ORCQDEIT[R]
        replace ORCPRB  with M_ORCPRBIT[R]
        replace ORCCOM  with M_ORCCOM
        replace ORCVLI  with M_ORCVLIIT[R]
        replace ORCLIQ  with M_ORCLIQIT[R]
        replace ORCNAT  with (M_ORCNAT * 100)
        replace ORCEST  with ACLI00->CLIUF2 
        replace ORCDTE  with M_ORCDTE
        unlock
        commit
        exit
      else
        msg("* * * (AORC01) REGISTRO SENDO USADO * * *") 
      endif
      if lastkey()=17
        exit
      endif
      loop            
    enddo

  next && R

return ""

**************** 
function GRORC03                       && regrava orcido itens
**************** 

  for R = 1 to 33 

    if M_ORCMATIT[R] = 0
      loop
    endif

    select AORC01                      && seleciona ORC itens 

    if !dbseek(str(M_ORCEMP, 2, 0) + str(M_ORCNUM, 6, 0) + M_ORCSER + str(M_ORCSEQIT[R], 2, 0))
      _append("AORC01")
    endif

    do while .t.
      if rlock()
        replace ORCEMP  with M_ORCEMP
        replace ORCNUM  with M_ORCNUM
        replace ORCSER  with M_ORCSER
        replace ORCSEQ  with M_ORCSEQIT[R]
        replace ORCMAT  with M_ORCMATIT[R]
        replace ORCQDE  with M_ORCQDEIT[R]
        replace ORCCOM  with M_ORCCOM
        replace ORCPRB  with M_ORCPRBIT[R]
        replace ORCVLI  with M_ORCVLIIT[R]
        replace ORCLIQ  with M_ORCLIQIT[R]
        replace ORCNAT  with (M_ORCNAT * 100)
        replace ORCEST  with ACLI00->CLIUF2 
        replace ORCDTE  with M_ORCDTE
        unlock
        commit
        exit
      else
        msg("* * * (AORC01) REGISTRO SENDO USADO * * *") 
      endif
      if lastkey()=17
        exit
      endif
      loop            
    enddo

  next && R

return ""

****************
function SEL_ORC
****************

private M_OPC  ,;
        M_TELA

M_TELA = savescreen(11, 58, 18, 75)

sombra(11, 60, 16, 72,_SOMBRA_)

painel(11, 60, 16, 72,"W+/BG","N/BG")

set color to W+/BG,W+/N
  @ 12, 61 prompt "  Emissao  " POSITION 3 HIGHLITE R/BG     
  @ 13, 61 prompt "  Alterar  " POSITION 4 HIGHLITE R/BG     
  @ 14, 61 prompt "  Incluir  " POSITION 4 HIGHLITE R/BG     
  @ 15, 61 prompt "  Excluir  " POSITION 4 HIGHLITE R/BG     
menu to M_OPC
set color to

restscreen(11, 58, 18, 75,M_TELA)

return M_OPC

*********************
function CRIA_CLI_ORC
*********************

private M_TELA   

        M_CLICOD = 0
        M_CLICGC = space(15)
        M_CLIIES = space(15)
        M_CLIDTE = date()
        M_CLINOM = space(40)
        M_CLIEND = space(40)
        M_CLIBAI = space(15)
        M_CLIMUN = space(20)
        M_CLIUF  = space(02)
        M_CLIAC  = space(01)
        M_CLICEP = 0
        M_CLICCL = 0 
        M_CLITEL = space(15)
        M_CLIFAX = space(15)

M_TELA = savescreen(09, 14, 18, 66)

sombra(09, 14, 17, 65,_SOMBRA_)

set color to W+/BG+
  @ 09, 14 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄClienteÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
  @ 10, 14 say     "³Cgc/Cpf :                  Codigo:                ³"
  @ 11, 14 say     "³Ins Est :                    Data:                ³"
  @ 12, 14 say     "³Nome    :                                         ³"
  @ 13, 14 say     "³Endereco:                                         ³"
  @ 14, 14 say     "³Cidade  :                      Uf:                ³"
  @ 15, 14 say     "³Bairro  :                     Cep:      -         ³"
  @ 16, 14 say     "³Telefone:                     Fax:                ³"
  @ 17, 14 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
set color to

M_CLICOD = AEMP00->EMPCLI + 1

select ACLI00

do while .t.

  set color to I
    @ 10, 60 say M_CLICOD  picture "#####"

  SetColor(_COREDICAO_)
  @ 10, 25 get M_CLICGC  picture "@R 999.999.999/9999-99"  valid verorccgc()
  @ 11, 25 get M_CLIIES  picture "@!"
  @ 11, 50 get M_CLIDTE
  @ 12, 25 get M_CLINOM  picture "@!"
  @ 13, 25 get M_CLIEND  picture "@!"
  @ 14, 25 get M_CLIMUN  picture "@!"
  @ 14, 50 get M_CLIUF   picture "@!" valid verest(M_CLIUF)
  @ 15, 25 get M_CLIBAI  picture "@!"
  @ 15, 50 get M_CLICEP  picture "#####"
  @ 15, 56 get M_CLICCL  picture "###"
  @ 16, 25 get M_CLITEL  picture "@!"
  @ 16, 50 get M_CLIFAX  picture "@!"
  read

  msg("* * * (ENTER) Continua  (PgDn) Sai * * *")

  if lastkey() = 3
    exit
  endif

enddo

restscreen(09, 14, 18, 66, M_TELA)


select ACLI00

do while .t.
  if dbseek(str(M_CLICOD, 5, 0))
    M_CLICOD = M_CLICOD + 1
    if M_CLICOD > 99999
      msg("* * * NUMERO DE CLIENTE ESGOTADO * * *")
      clear 
      quit
      return .t.
    endif
    loop
  endif
  exit
enddo

_append("ACLI00")

     do while .t. 
       if rlock()
         replace CLICOD  with M_CLICOD
         replace CLICGC1 with M_CLICGC
         replace CLIIES1 with M_CLIIES
         replace CLIDTE  with M_CLIDTE
         replace CLINOM  with M_CLINOM
         replace CLITEL1 with M_CLITEL
         replace CLIFAX1 with M_CLIFAX
         replace CLIEND1 with M_CLIEND
         replace CLIMUN1 with M_CLIMUN
         replace CLIUF1  with M_CLIUF
         replace CLICEP1 with M_CLICEP
         replace CLICCL1 with M_CLICCL
         replace CLICGC2 with M_CLICGC
         replace CLIIES2 with M_CLIIES
         replace CLIEND2 with M_CLIEND
         replace CLIMUN2 with M_CLIMUN
         replace CLIUF2  with M_CLIUF
         replace CLICEP2 with M_CLICEP
         replace CLICCL2 with M_CLICCL
         replace CLIEND3 with M_CLIEND
         replace CLIMUN3 with M_CLIMUN
         replace CLITEL3 with M_CLITEL
         replace CLIFAX3 with M_CLIFAX
         replace CLIUF3  with M_CLIUF
         replace CLICEP3 with M_CLICEP
         replace CLICCL3 with M_CLICCL
         commit
         unlock
         exit 
       else
         msg("* * * (ACLI00) REGISTRO SENDO USADO * * *")
       endif
       if lastkey()=17
         exit
       endif
     enddo

    M_ORCCLI = M_CLICOD
    M_CLIUF2 = M_CLIUF 

    select AEMP00

     do while .t. 
       if rlock()
         replace EMPCLI  with M_CLICOD
         unlock
         commit
         exit 
       else
         msg("* * * (AEMP00) REGISTRO SENDO USADO * * *")
       endif
       if lastkey()=17
         exit
       endif
     enddo

return .t.

****************
function MSORC03                       && mostra dados da nota
****************

private L        ,;
        M_TELA   ,;
        M_ORCVLM ,;
        M_ORCVLD

    store 11 to L

    store  0 to LN       ,;
                M_ORCVLM 

    select AORC01

    go top

    dbseek(str(AORC00->ORCEMP, 2, 0) + str(AORC00->ORCNUM, 6, 0) + AORC00->ORCSER,.t.)

    do while !eof()
    
        if !str(ORCEMP, 2, 0) + str(ORCNUM, 6, 0) + ORCSER == str(AORC00->ORCEMP, 2, 0) + str(AORC00->ORCNUM, 6, 0) + AORC00->ORCSER
          exit
        endif

        APCA00->(dbseek(str(AORC01->ORCMAT, 6, 0)))

        set color to I
          @ L, 05 say   ORCSEQ picture "##"
          @ L, 08 say   ORCMAT picture "######"
          @ L, 15 say   ORCQDE picture "#####.##"
          @ L, 24 say   left(APCA00->PCADES, 30)
          @ L, 55 say   ORCPRB picture "#######.##"
          @ L, 66 say   ORCVLI picture "#######.##"
        set color to

        M_ORCVLM = M_ORCVLM + ORCVLI

        if L > 18
          msg("* * * (ESC) Sai (ENTER) continua * * *")
          if lastkey() = 27
            exit
          endif
          lporc01()
          L=10
        endif
 
        skip

        L++

    enddo

  select AORC00

  M_TELA = savescreen(06, 20, 18, 60)

  sombra(06, 20, 11, 59,_SOMBRA_)

  set color to GR+/BG+
    @ 06, 20 say  "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
    @ 07, 20 say  "³Valor das Mercadorias:                ³" 
    @ 08, 20 say  "³Valor dos Descontos  :                ³" 
    @ 09, 20 say  "³Despesas (FRETE)     :                ³" 
    @ 10, 20 say  "³Valor do Orcamento   :                ³" 
    @ 11, 20 say  "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
  set color to 

 set color to GR+/BG+
    @ 07, 45 say ORCVLM              picture "@E ###,###,###.##"
    @ 08, 45 say ORCVLD              picture "@E ###,###,###.##"
    @ 09, 45 say ORCFRE              picture "@E ###,###,###.##"
    @ 10, 45 say ORCVLN              picture "@E ###,###,###.##"
  set color to

  inkey(0)

  restscreen(06, 20, 18, 60, M_TELA)

return ""

******************
function VERORCCGC
******************

if empty(M_CLICGC)
  return .t.
endif     

if len(alltrim(M_CLICGC))=15         
  if !cgc(right(M_CLICGC,14))
    msg("* * * CGC INVALIDO * * *")
    return .t.
  endif 
else
  if len(alltrim(M_CLICGC))=11
    if !cpf(left(M_CLICGC,11))
      msg("* * * CPF INVALIDO * * *")
      return .t.
    endif 
  else
    msg("* * * NAO E' CGC/CPF * * *")
    return .t.
  endif
endif

return .t.

*****************
function VERORC20
*****************

nTela = savescreen(01, 01, 23, 79)

sombra(10, 23, 14, 57, _SOMBRA_)

painel(10, 23, 14, 57,"GR+/R","N/R")

set color to R+/GR
  @ 11, 24 say "Validade da Proposta:            "
  @ 12, 24 say "Faturamento Minimo  :            "
  @ 13, 24 say "Observacao          :            "
set color to

do while .t.

SetColor(_COREDICAO_)
@ 11, 46 get M_ORCVAL picture "@!@S10"
@ 12, 46 get M_ORCFAT picture "@E ###,###.##"
@ 13, 46 get M_ORCOBS picture "@!@S10"
read

msg("* * * (ENTER) Continua (ESC) Sai * * *")

if lastkey() = 27
  exit
endif

enddo

restscreen(01, 01, 23, 79, nTela)

return ""

***************
function EMIORC
***************

parameter M_OPCAO 

  M_TOTPRO = 0
  M_UNIT   = 0
  M_ORCCOP = 1
  LN = 0
  PG = 0

  if M_OPCAO
    do while .t.
      if !AEMP00->(dbrlock())
        loop
      endif
      select AORC00
      if dbseek(str(M_ORCEMP, 2, 0) + str(M_ORCNUM, 6, 0) + M_ORCSER)
        M_ORCNUM = M_ORCNUM + 1
        loop
      else
        select AORC00
        _append("AORC00")
        grorc01()
        select AEMP00                    && seleciona empresa e grava ultima nota fiscal
        do while .t.            
          if rlock() 
            replace EMPORC with M_ORCNUM
            unlock
            commit
            exit
          else
            msg("* * * (AEMP00) REGISTRO SENDO USADO * * *")
            if lastkey()=17 
              exit
            endif
          endif
        enddo 
        exit
      endif
    enddo
  endif

  set color to I
    @ 04, 15 say M_ORCNUM picture "######"
    @ 04, 22 say M_ORCSER picture "@!" 
  set color to 

  nTela = savescreen(01, 01, 23, 79)

  sombra(09, 27, 11, 48, _SOMBRA_)

  painel(09, 27, 11, 48,"GR+/R","N/R")

  set color to R+/GR
    @ 10, 28 say "Numero de Copias:   "
  SetColor(_COREDICAO_)
  @ 10, 46 get M_ORCCOP picture "##" valid(M_ORCCOP > 0)
  read

  restscreen(01, 01, 23, 79, nTela)

  M_IMPRE = impresn()

  if M_IMPRE = "N"
    return ""
  endif

  for L = 1 to M_ORCCOP

    ACLI00->(dbseek(str(M_ORCCLI, 7, 0)))

    ?? chr(15)

    ?
    ?
    ?
    ?
    ?

    cab_eor1("")                   && imprime cabecalho

    M_FLAG = 0
    M_TOTPES = 0
    M_TOTPRO = 0
    M_TOTLIN = 0

    for R = 1 to 33

      if M_ORCMATIT[R] = 0
        loop
      endif
  
      select APCA00
  
      seek str(M_ORCMATIT[R], 6, 0)
  
      ? 
       ?? strzero(R, 4, 0)
       ?? " "
       ?? transform(M_ORCQDEIT[R],"@E@Z #####.##")
       ?? " "
       ?? pad(APCA00->PCAUNI, 2)
       ?? " "
       ?? str(APCA00->PCAMAT, 6, 0)
       ?? " " 
       ?? pad(alltrim(APCA00->PCADES) + " " + APCA00->PCAMAR, 83)
       ?? " "
       ?? transform(M_ORCPRBIT[R],"@E ###,###.##") 
       ?? " "
       ?? iif(M_ORCQDEIT[R] > 0,transform(M_ORCVLIIT[R],"@E ##,###,###.##")," ") 
  
       M_TOTPES = M_TOTPES + (APCA00->PCAPLQ * M_ORCQDEIT[R])
       M_TOTPRO = M_TOTPRO + M_ORCQDEIT[R]                         
       M_TOTLIN++
       LN++
    
       if M_ORCQDEIT[R] = 0
         M_UNIT = 1
       endif
  
       if LN > 60
         cab_eor1("")
       endif
  
    next  && R 

    for R = M_TOTLIN to 5
      ?
    next
  
    ?? chr(18)
  
    if !M_UNIT > 0
      ? space(50)
       ?? "Subtotal: R$ "
       ?? chr(27) + "E"
       ?? transform(M_ORCVLM,"@E ###,###,###.##")      
       ?? chr(27) + "F"
  
      ? space(49)
       ?? " Desconto: R$ "
       ?? chr(27) + "E"
       ?? transform(M_ORCVLD,"@E ###,###,###.##")      
       ?? chr(27) + "F"
    
      ? space(49)
       ?? "    Frete: R$ "
       ?? chr(27) + "E"
       ?? transform(M_ORCFRE,"@E ###,###,###.##")      
       ?? chr(27) + "F"
     
      ? space(51)
       ?? "Total  : R$ "
       ?? chr(27) + "E"
       ?? transform(M_ORCVLN,"@E ###,###,###.##")      
       ?? chr(27) + "F"
      ?
    endif
  
           
    eject

  next

  msw("* * * GRAVANDO ORCAMENTO * * *")

  for R = 1 to 33 

    if M_ORCMATIT[R] = 0
      loop
    endif

    select AORC01                      && seleciona ORC itens 

    _append("AORC01")

    do while .t.
      if rlock()
        replace ORCEMP  with M_ORCEMP
        replace ORCNUM  with M_ORCNUM
        replace ORCSER  with M_ORCSER
        replace ORCSEQ  with M_ORCSEQIT[R]
        replace ORCMAT  with M_ORCMATIT[R]
        replace ORCQDE  with M_ORCQDEIT[R]
        replace ORCPRB  with M_ORCPRBIT[R]
        replace ORCCOM  with M_ORCCOM
        replace ORCVLI  with M_ORCVLIIT[R]
        replace ORCLIQ  with M_ORCLIQIT[R]
        replace ORCNAT  with (M_ORCNAT * 100)
        replace ORCEST  with ACLI00->CLIUF2 
        replace ORCDTE  with M_ORCDTE
        unlock
        commit 
        exit
      else
        msg("* * * (AORC01) REGISTRO SENDO USADO * * *") 
      endif
      if lastkey()=17
        exit
      endif
      loop            
    enddo

  next && R

desliga1()

return "" 

*****************
function CAB_ORC1
*****************

 PG = PG + 1

 if PG > 1
   eject
 endif

 ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE ORCAMENTOS","EAGRO77",132) 
 ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)

 LN = 2

return ""

*****************
function CAB_ORC2
*****************

 ? replicate("-",132)  
 ? "DOCTO   SE CODFIS                              EMISSAO  CLIENTE                                VEN DATA SAIDA   VLR TOTAL   SITUACAO"

 LN = LN + 2

return ""

*****************
function CAB_ORC3
*****************

  ?
  ? "   SEQ    CODIGO             REFERENCIA   DESCRICAO                                      QUANTIDADE S   VLR UNITARIO    VALOR  TOTAL" 
                                                                                              
  LN = LN + 2

return ""

*****************
function CAB_EOR1
*****************

parameters M_VIA

 ?? chr(18) 
 ? cent_cab("","O R C A M E N T O","Numero: " + str(M_ORCNUM, 6, 0),80) 
 ? cent_cab("Emissao: " + dtoc(M_ORCDTE),"",time(),80) 
 ?? chr(27) + "E"
 ? cent_cab("",alltrim(AEMP00->EMPNOM),"",80) 
 ?? chr(27) + "F"
 ? cent_cab("Fone: (018) 221-1550",alltrim(AEMP00->EMPEND),alltrim(AEMP00->EMPMUN),80) 
 ? cent_cab("Fax : (018) 223-8243","CGC: " + transform(AEMP00->EMPCGC,"@R 999.999.999/9999-99"),"INSC. EST: " + AEMP00->EMPIES,80)
 ? replicate("-",80)
 ?? chr(15) 

 ? "Cliente    : "
   ?? pad(ACLI00->CLINOM, 40)
   ?? "  "
   ?? strzero(ACLI00->CLICOD, 5, 0)
   ?? space(23)
   ?? "Data                : " 
   ?? M_ORCDTE

 ? "Endereco   : "
   ?? pad(ACLI00->CLIEND2, 60)
   ?? space(7)
   ?? "   Telefone            : "
   ?? ACLI00->CLITEL3

 ? "Municipio  : "
   ?? ACLI00->CLIMUN2
   ?? " "
   ?? ACLI00->CLIUF2
   ?? space(47)
   ?? "Cep                 : "
   ?? strzero(ACLI00->CLICEP2, 5, 0)
   ?? " "
   ?? strzero(ACLI00->CLICCL2, 3, 0)

 ? "CGC(MF)/CPF: "
   if len(rtrim(ACLI00->CLICGC2)) = 11
     ?? transform(ACLI00->CLICGC2,"@R 999.999.999/99")
     ?? space(05)
   else
     ?? transform(ACLI00->CLICGC2,"@R 999.999.999/9999-99")
   endif
   ?? " IE: "
   ?? ACLI00->CLIIES2
   ?? space(29)
   ?? "Vendedor            : " 
   ?? pad(AVEN00->VENNOM, 20)

 ? "Cond. Pagto: "
   ?? pad(ACPG00->CPGDES, 64)
   ?? space(06)
   ?? "Validade da Proposta: "
   ?? M_ORCVAL
 
 ? "Transporte : "
   ?? ATRA00->TRANOM

 ? "Observacao : "
   ?? pad(M_ORCOBS, 60)
   ?? space(10)
   ?? "Faturamento Minimo  : R$"
   ?? transform(M_ORCFAT, "@E ###,###.##")

 ? "           : "
  ?? pad(M_ORCHS1, 60)
 ? "           : "
  ?? pad(M_ORCHS2, 60)
 ? "           : "
  ?? pad(M_ORCHS3, 60)
 ? space(13)
  ?? "Conforme solicitacao de V. Sas., segue nosso orcamento de precos dos produtos abaixo discriminados:" 

 
 ? replicate("-",132)
 ? "ITEM    QUANT UN CODIGO DESCRICAO                                                                             UNITARIO       TOTAL"
 ? replicate("-",132)

 LN = 20

return ""

*******************
function RETIRA_ORC
*******************

  msw("* * * AGUARDE ... RETIRANDO LANCAMENTOS !!! * * *")

   AFIS00->(dbseek(str(AORC00->ORCEMP, 2, 0) + str(AORC00->ORCNAT, 5, 0)))      

      do while .t.

        select AORC01

        dbseek(str(AORC00->ORCEMP, 2, 0) + str(AORC00->ORCNUM, 6, 0) + AORC00->ORCSER, .t.)

        if !str(ORCEMP, 2, 0) + str(ORCNUM, 6, 0) + ORCSER ==  str(AORC00->ORCEMP, 2, 0) + str(AORC00->ORCNUM, 6, 0) + AORC00->ORCSER
          exit
        endif
        
        select AORC01
        elimina()

      enddo


return ""

****************
function TLORC02
****************

sombra(03, 04, 20, 76,_SOMBRA_)

set color to I
    @ 03, 04 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
    @ 04, 04 say     "³Cliente :         Nome:                               Mun:             ³"
    @ 05, 04 say     "ÃÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÂÄÄÄÄÄÄÄÄÄÄÄ´"
    @ 06, 04 say     "³  Data  ³NumPed³Se³Cpg³Tra³Ven³Nome              ³ Ope  ³Se³  Total    ³"
    @ 07, 04 say     "ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÅÄÄÄÄÄÄÄÄÄÄÄ´"
    for zz = 8 to 15
    @ zz, 04 say     "³        ³      ³  ³   ³   ³   ³                  ³      ³  ³           ³"
    next
    @ 16, 04 say     "ÃÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´"
    @ 17, 04 say     "³" + space(71) + "³"
    @ 18, 04 say     "³" + space(71) + "³"
    @ 19, 04 say     "³" + space(71) + "³"
    @ 20, 04 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
set color to 

return ""

***************
function MOSORC
***************

parameters  M_MODO, M_ELEM, M_POSI

 if rat(str(lastkey(), 2, 0),"27") > 0
   return 0
 endif

 if rat(str(lastkey(), 2, 0),"13") > 0
   select AORC00
   go MT_REG[M_ELEM]
   M_TL = savescreen(02,02,24,79)
   tlorc01()
   msorc01()
   msorc03()
   restscreen(02,02,24,79,M_TL)
 endif

  set color to I
    @ 17, 11 say MT_OBSE1[M_ELEM]
    @ 18, 11 say MT_OBSE2[M_ELEM]
    @ 19, 11 say MT_OBSE3[M_ELEM]
  set color to

 set color to N/W,W+/N


return 2

