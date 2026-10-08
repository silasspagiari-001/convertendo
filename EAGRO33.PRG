#command @ <row> , <col>  GET <var> [<clauses,...>] F2 [<moreClauses,...>] funcao <func> retorno <Variavel>;
=>       @ <row> , <col>  GET <var> [<clauses>] SEND reader := {|oGet| Getf2(oGet,<func>,<Variavel>) } [<moreClauses>]

***************
function MANBCR                        && baixa de Duplicata 
***************  
parameters M_OPC,M_OPC1,M_OPC2

      rodape("BAIXA","DUPLICATA",M_FAN,"EAGRO33","Mem: " + str(memory(0), 5),M_EMP)

*        @ 06, 30 prompt     "Documento" HIGHLITE R/BG PERMITE 3,3,1
*        @ 07, 30 prompt     "Cliente  " HIGHLITE R/BG PERMITE 3,3,2
*        @ 08, 30 prompt     "Recep‡„o " HIGHLITE R/BG PERMITE 3,3,3
*        @ 09, 30 prompt     "Consiste " HIGHLITE R/BG PERMITE 3,3,4
*        @ 10, 30 prompt     "Listagem " HIGHLITE R/BG PERMITE 3,3,5

      do case
         case M_OPC = 1 ; baibcr_a()
         case M_OPC = 2 ; baibcr_b()   
         case M_OPC = 3 ; baibcr_c()   
         case M_OPC = 4 ; baibcr_d()   
         case M_OPC = 5 ; baibcr_e()   
      endcase

return ""

*****************
function BAIBCR_A
*****************


do while .t.

  rodape("BAIXA","DUPLICATA",M_FAN,"EAGRO33","Mem: " + str(memory(0), 5),M_EMP) 

  M_BAIDTM = ctod("  /  /  ") 

  do while .t. 

    tlbcr01()

    M_BAIEMP = ME_EMP
    M_BAINUM = 0 
    M_BAIORD = 0 
    M_BAIBOL = 0 
    M_BAISER = AEMP00->EMPSER

*    verdupche(@M_BAINUM,@M_BAIORD,@M_BAISER)
    
    SetColor(_COREDICAO_)
    @ 08, 26 get M_BAINUM picture "######"  // F2 color _CORF2_ funcao "verdupche(@M_BAINUM,@M_BAIORD,@M_BAISER)" retorno "re"
    @ 08, 33 get M_BAIORD picture "##"
    @ 08, 45 get M_BAISER picture "@!"
    read

    if lastkey() = 27
      return ""
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
    aadd(sqlCHAVE,"ADCR00.DUPEMP = " + str(M_BAIEMP,2))
    aadd(sqlCHAVE,"ADCR00.DUPSER = " + aspas(M_BAISER))
    aadd(sqlCHAVE,"ADCR00.DUPNUM = " + str(M_BAINUM,9))
    aadd(sqlCHAVE,"ADCR00.DUPORD = " + str(M_BAIORD,2))
    if !sqlrelation()
      msg("* * * DUPLICATA NAO CADASTRADA * * *")
      loop
    endif

        if DUPHIS = 100
          msg("* * * DUPLICATA JA BAIXADA * * *")
          loop
        endif 

        M_BAINUM = DUPNUM
        M_BAIORD = DUPORD
        M_BAIPOR = 0 
        M_BAIDTM = date()
        M_BAIHIS = 100
        M_BAICLI = 0 
        M_BAIOBS = DUPOBS 
        M_BAIOBT = DUPOBT 
        M_BAIPOR = DUPPOR 
        M_BAIVAL = 0 
        M_BAIJUR = 0 
        M_BAIDSC = 0 
        M_BAITAX = 0 
        M_BAIAPL = ADCR00->DUPAPL

        select ADCR00

        msbcr01() 

        if DUPVLA = 0
          M_OPC = decide("Nao ha Saldo a Baixar Confirma")
          if !M_OPC == 1
             loop
          endif          
        endif                  

        M_BAICLI = DUPCLI
        M_BAIOBS = DUPOBS 
        M_BAIOBT = DUPOBT 
        M_BAIPOR = DUPPOR 

        edbcr03()

        if lastkey() = 27
          msg("* * * BAIXA NAO EFETUADA * * *")   
          loop
        endif 

        M_OPC = decide("Confirma Baixa da Duplicata")

        if M_OPC != 1 
          msg("* * * BAIXA NAO EFETUADA * * *")
          loop
        endif          

        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {"ADCR00","UPDATE"}
        aadd(sqlCHAVE,{"DUPEMP",str(ME_EMP,2)})
        aadd(sqlCHAVE,{"DUPNUM",str(M_BAINUM,9)})
        aadd(sqlCHAVE,{"DUPORD",str(M_BAIORD,2)})
        aadd(sqlCHAVE,{"DUPSER",aspas(M_BAISER)})

        aadd(sqlCAMPO,{"DUPPOR",str(M_BAIPOR,5),.t.})
        aadd(sqlCAMPO,{"DUPDTP",formatdta(M_BAIDTM),.t.})
        aadd(sqlCAMPO,{"DUPVLA",str1(0,2),.t.})
        aadd(sqlCAMPO,{"DUPOBS",M_BAIOBS,.t.})
        aadd(sqlCAMPO,{"DUPOBT",M_BAIOBT,.t.})
        aadd(sqlCAMPO,{"DUPHIS",str(100,3),.t.})
        aadd(sqlCAMPO,{"DUPJUR",str1(M_BAIJUR,2),.t.})
        aadd(sqlCAMPO,{"DUPDSC",str1(M_BAIDSC,2),.t.})
        aadd(sqlCAMPO,{"DUPTAX",str1(M_BAITAX,2),.t.})
        aadd(sqlCAMPO,{"DUPVLP",str1(M_BAIVAL,2),.t.})
        executasql()

        msg("* * * DUPLICATA BAIXADA * * *")
    
      enddo

      if lastkey() = 27
        exit
      endif

    enddo

return ""

*****************
function BAIBCR_B                      && baixa de Duplicata 
*****************

  do while .t.

    tlbcr02()

    rodape("BAIXA","TITULO",M_FAN,"EAGRO33","Mem: " + str(memory(0), 5),M_EMP) 

    keyfun()

    M_DUPCLI = 0
    M_DUPCLF = 0
*   M_DUPCOR = date()
    M_DUPMAT = {}

    M_BAIEMP = ME_EMP
    M_BAIPOR = 0
    M_BAIDSC = 0
    M_BAIOBS = space(40)
    M_BAIOBT = space(40)
    M_BAIAPL = 0

    SetColor(_COREDICAO_)
    @ 04, 14 get M_DUPCLI F2  picture "#######" valid verbcr03() color _CORF2_ funcao "sele_arquivo('ACLI00')" retorno @M_DUPCLI
*   @ 04, 66 get M_DUPCOR
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
    aadd(sqlCAMPO,"ACLI00.CLINOM")
    aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ADCR00.DUPCLI"})
    aadd(sqlCHAVE,"ADCR00.DUPCLI = " + str(M_DUPCLI,9))
    aadd(sqlCHAVE,"ADCR00.DUPHIS = 500")
    if !sqlrelation()
      msg("* * * CLIENTE SEM DUPLICATA EM ABERTO * * *")
      loop
    endif

    SQ = 1
    do while !eof()

        aadd(M_DUPMAT,{0,  0,  ctod("  /  /  "), ctod("  /  /  "),  0,  0,  0,  0,  0, 0, ctod("  /  /  "), 0,"  "})

        M_DUPMAT[SQ, 1] = DUPNUM
        M_DUPMAT[SQ, 2] = DUPORD
        M_DUPMAT[SQ, 3] = DUPDTE
        M_DUPMAT[SQ, 4] = DUPVCT
        M_DUPMAT[SQ, 5] = DUPVLA - DUPDSC
        M_DUPMAT[SQ, 6] = DUPTXD
        M_DUPMAT[SQ, 7] = 0
        M_DUPMAT[SQ, 8] = 0
        M_DUPMAT[SQ, 9] = M_DUPMAT[SQ, 5]
        M_DUPMAT[SQ,10] = DUPEMP
        M_DUPMAT[SQ,11] = DUPVCT
        M_DUPMAT[SQ,12] = DUPBOL
        M_DUPMAT[SQ,13] = DUPSER

        skip

        SQ = SQ + 1

      enddo

    declare M_VETORITE[len(M_DUPMAT)]

    TODUP = 0

    for R = 1 to len(M_DUPMAT)

      M_VETORITE[R] = str (M_DUPMAT[R, 1], 6, 0)               + "³" + ;
                      str (M_DUPMAT[R, 2], 2, 0)               + "³" + ;
                      left(dtoc(M_DUPMAT[R, 3]), 5)            + "³" + ;
                      left(dtoc(M_DUPMAT[R, 4]), 5)            + "³" + ;
                      str (M_DUPMAT[R, 4]-date(), 5)         + "³" + ;
                      transform(M_DUPMAT[R, 5],"@E #####.##") + "³" + ;
                      str (M_DUPMAT[R, 6], 5, 2)               + "³" + ;
                      str (M_DUPMAT[R, 7], 8, 2)               + "³" + ;
                      str (M_DUPMAT[R, 8], 8, 2)               + "³" + ;
                      transform(M_DUPMAT[R, 9],"@E ##,###.##") + "³" + ;
                      str (M_DUPMAT[R,10], 2, 0)               

      TODUP = TODUP + M_DUPMAT[R, 9]

    next

    setcolor("I")
      @ 19, 63 say transform(TODUP,"@E ####,###.##") 
    setcolor("")  

    M_LINPOS = 0

    do while .t.

      if len(M_DUPMAT) = 0
        msg("* * * CLIENTE SEM DUPLICATA EM ABERTO * * *")
        exit
      endif
      set color to I
        @ 19, 12 say M_DUPMAT[ 1, 11] 
        @ 19, 29 say M_DUPMAT[ 1, 12] picture "#######" 
      set color to GR+
        @ 24, 01 say "                    1.Imprimir  2.Baixar  6.Sair"
      set color to R+
        @ 24, 21 say "1"
        @ 24, 33 say "2"
        @ 24, 43 say "6"
      set color to N/W,W+/N
        M_OPC = achoice( 9, 3, 17, 75,M_VETORITE,,"mosbcr")
      set color to 

      if lastkey() = 13
        altbcracr() && altera item  
        loop
      endif

      if lastkey() = 49
        impbcracr() && imprime acerto  1
        loop
      endif

     if lastkey() = 50
        probcracr(M_OPC) && processa baixa do acerto  2
        loop
      endif

      if lastkey() = 54 
        exit        && abandona operacao  6
      endif

    enddo

  enddo

  fecha_arq()

return ""

******************
function ALTBCRACR
******************

    edbcr01(09 + M_LINPOS,M_OPC)

    TODUP = 0

    for R = 1 to len(M_DUPMAT)

      M_VETORITE[R] = str (M_DUPMAT[R, 1], 6, 0)               + "³" + ;
                      str (M_DUPMAT[R, 2], 2, 0)               + "³" + ;
                      left(dtoc(M_DUPMAT[R, 3]), 5)            + "³" + ;
                      left(dtoc(M_DUPMAT[R, 4]), 5)            + "³" + ;
                      str (M_DUPMAT[R, 4]-date(), 5)         + "³" + ;
                      transform(M_DUPMAT[R, 5],"@E #####.##")  + "³" + ;
                      str (M_DUPMAT[R, 6], 5, 2)               + "³" + ;
                      str (M_DUPMAT[R, 7], 8, 2)               + "³" + ;
                      str (M_DUPMAT[R, 8], 8, 2)               + "³" + ;
                      transform(M_DUPMAT[R, 9],"@E ##,###.##") + "³" + ;
                      str (M_DUPMAT[R,10], 2, 0)               

      TODUP = TODUP + M_DUPMAT[R, 9]

    next

    setcolor("I")
      @ 19, 63 say transform(TODUP,"@E ####,###.##") 
    setcolor("")  

    M_LINPOS = 0

return ""

******************
function IMPBCRACR
******************

  M_IMPRE = impresn()

  if M_IMPRE = "N"
    return ""
  endif

  if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
    ?? chr(15)                        && comprime
  endif

  store 0 to PG, LN
  
  M_TOTDUP = 0
  M_TOTJUR = 0
  M_TOTTAX = 0
  M_TOTDIV = 0
  M_TOTPAG = 0

  cabbcr01()

  for R = 1 to len(M_DUPMAT)

    ? " "
      ?? str(M_DUPMAT[R, 1], 6, 0)
      ?? "/"
      ?? strzero(M_DUPMAT[R, 2], 2, 0)
      ?? "-"
      ?? M_DUPMAT[R, 3]
      ?? " "
      ?? M_DUPMAT[R, 4]
      ?? " "
      ?? str(M_DUPMAT[R, 4]-date(), 5, 0)
      ?? " "
      ?? str(M_DUPCLI, 7)
      ?? " "
      ?? transform(M_DUPMAT[R, 5],"@E ###,###.##") 
      ?? " "
      ?? transform(M_DUPMAT[R, 6],"@E ##.##") 
      ?? " "
      ?? transform((M_DUPMAT[R, 9] - (M_DUPMAT[R, 5] - M_DUPMAT[R, 7] - M_DUPMAT[R, 8])),"@E ###,###.##") 
      ?? " "
      ?? transform(M_DUPMAT[R, 7],"@E ###,###.##") 
      ?? " "
      ?? transform(M_DUPMAT[R, 8],"@E ###,###.##") 
      ?? " "
      ?? transform(M_DUPMAT[R, 9],"@E ####,###.##") 
      ?? " "
      ?? str(M_DUPMAT[R,10],2)

      LN = LN + 1

      M_TOTPAG = M_TOTPAG + M_DUPMAT[R, 9]
      M_TOTJUR = M_TOTJUR + (M_DUPMAT[R, 9] - (M_DUPMAT[R, 5] - M_DUPMAT[R, 7] - M_DUPMAT[R, 8]))
      M_TOTTAX = M_TOTTAX + M_DUPMAT[R, 7]
      M_TOTDIV = M_TOTDIV + M_DUPMAT[R, 8]
      M_TOTDUP = M_TOTDUP + M_DUPMAT[R, 5]

      if LN > 60
        cabbcr01()
      endif

      M_ESC = inkey()

      if M_ESC = 27
        if susimp()
          ? replicate("-", 132)
          ? "* * * IMPRESSAO SUSPENSA * * *"
          exit
        else
          M_ESC = inkey()
        endif
      endif

    next
    ? replicate("-", 132)
    ? space(30)
     ?? "TOTAL GERAL A PAGAR . . .        "
     ?? " "
     ?? transform(M_TOTDUP,"@E #,###,###.##")
     ?? "     "
     ?? transform(M_TOTJUR,"@E #,###,###.##")
     ?? " "
     ?? transform(M_TOTTAX,"@E ###,###.##")
     ?? " "
     ?? transform(M_TOTDIV,"@E ###,###.##")
     ?? " "
     ?? transform(M_TOTPAG,"@E ####,###.##")

    for R = LN to 56
      ?
    next

    ? cent_cab("","----------------------------------------","",132)
    ? cent_cab("",alltrim(AEMP00->EMPNOM),"",132)
      
    eject

desliga1()

return ""

******************
function PROBCRACR
******************

 private M_TELA

 parameters SQ

  if !BUSCAREGISTRO("ADCR00",1,{str(M_DUPMAT[SQ, 10], 2),str(M_DUPMAT[SQ, 1], 6, 0),str(M_DUPMAT[SQ, 2], 2),aspas(M_DUPMAT[SQ, 13])},"SELECT")
    return ""
  endif

  BUSCAREGISTRO("AMOV00P",1,{str(100,3)},"SELECT")

  M_TELA = savescreen(06, 13, 14, 67)

  M_BAIDTM = date()
  M_BAIOBS = ADCR00->DUPOBS
  M_BAIOBT = ADCR00->DUPOBT

 nbox(06, 13, 13, 66,"W/W+",.t.)
 setcolor("B/W")
      @ 09, 14 say   "Desconto  :                                         "
      @ 10, 14 say   "Observacao:                                         "
      @ 11, 14 say   "          :                                         "
      @ 12, 14 say   "Data Baixa:                       Valor:            "
  SetColor(_COREDICAO_)
  @ 09, 26  get M_BAIDSC picture "#######.##" valid verbcr01()
  @ 10, 26  get M_BAIOBS picture "@!"
  @ 11, 26  get M_BAIOBT picture "@!"
  @ 12, 26  get M_BAIDTM                      valid verbcr07()
  read
  set color to I
   @ 12, 55 say M_DUPMAT[SQ, 9] picture "@E ####,###.##"
  set color to 

  if lastkey() = 27
    msg("* * * BAIXA NAO EFETUADA * * *")
    restscreen(06, 13, 14, 67, M_TELA)
    return ""
  endif          

  M_OPC = decide("Confirma Baixa deste Titulo")

  if M_OPC != 1 
    msg("* * * BAIXA NAO EFETUADA * * *")
    restscreen(06, 13, 14, 67, M_TELA)
    return ""
  endif          

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"ADCR00","UPDATE"}
  aadd(sqlCHAVE,{"DUPEMP",str(ADCR00->DUPEMP,2)})
  aadd(sqlCHAVE,{"DUPNUM",str(ADCR00->DUPNUM,9)})
  aadd(sqlCHAVE,{"DUPORD",str(ADCR00->DUPORD,2)})
  aadd(sqlCHAVE,{"DUPSER",aspas(ADCR00->DUPSER)})

  aadd(sqlCAMPO,{"DUPDTP",formatdta(M_BAIDTM),.t.})
  aadd(sqlCAMPO,{"DUPVLA",str1(0,2),.t.})
  aadd(sqlCAMPO,{"DUPHIS",str(100,3),.t.})
  aadd(sqlCAMPO,{"DUPJUR",str1(M_DUPMAT[SQ, 7],2),.t.})
  aadd(sqlCAMPO,{"DUPDSC",str1(0,2),.t.})
  aadd(sqlCAMPO,{"DUPTAX",str1(M_DUPMAT[SQ, 8],2),.t.})
  aadd(sqlCAMPO,{"DUPVLP",str1(M_DUPMAT[SQ, 9],2),.t.})
  aadd(sqlCAMPO,{"DUPOBS",M_BAIOBS,.t.})
  aadd(sqlCAMPO,{"DUPOBT",M_BAIOBT,.t.})
  executasql()

  msg("* * * TITULO BAIXADO * * *")

  restscreen(06, 13, 14, 67, M_TELA)

  adel(M_DUPMAT,SQ)
  adel(M_VETORITE,SQ)

  asize(M_DUPMAT,len(M_DUPMAT) - 1)
  asize(M_VETORITE,len(M_VETORITE) - 1)

  lpbcr01()

    TODUP = 0

    for R = 1 to len(M_DUPMAT)

      M_VETORITE[R] = str (M_DUPMAT[R, 1], 6, 0)               + "³" + ;
                      str (M_DUPMAT[R, 2], 2, 0)               + "³" + ;
                      left(dtoc(M_DUPMAT[R, 3]), 5)            + "³" + ;
                      left(dtoc(M_DUPMAT[R, 4]), 5)            + "³" + ;
                      str (M_DUPMAT[R, 4]-date(), 5)         + "³" + ;
                      transform(M_DUPMAT[R, 5],"@E #####.##")  + "³" + ;
                      str (M_DUPMAT[R, 6], 5, 2)               + "³" + ;
                      str (M_DUPMAT[R, 7], 8, 2)               + "³" + ;
                      str (M_DUPMAT[R, 8], 8, 2)               + "³" + ;
                      transform(M_DUPMAT[R, 9],"@E ##,###.##") + "³" + ;
                      str (M_DUPMAT[R,10], 2, 0)               

      TODUP = TODUP + M_DUPMAT[R, 9]

    next

    setcolor("I")
      @ 19, 63 say transform(TODUP,"@E ####,###.##") 
    setcolor("")  

    M_LINPOS = 0

return ""




****************
function EDBCR01
****************

  parameters LN,SQ

  SetColor(_COREDICAO_)
  @ LN, 40 get     M_DUPMAT[SQ, 6] picture "##.##"
  @ LN, 46 get     M_DUPMAT[SQ, 7] picture "#####.##"  
  @ LN, 55 get     M_DUPMAT[SQ, 8] picture "#####.##" valid verbcr04() 
  read

return .t.

****************
function EDBCR02
****************

  parameters LN,SQ

  SetColor(_COREDICAO_)
  @ LN, 03 get     M_DUPMAT[SQ, 1] picture "######"
  @ LN, 10 get     M_DUPMAT[SQ, 2] picture "##"       valid verbcr05()
  @ LN, 40 get     M_DUPMAT[SQ, 6] picture "##.##"     
  @ LN, 46 get     M_DUPMAT[SQ, 7] picture "#####.##"  
  @ LN, 55 get     M_DUPMAT[SQ, 8] picture "#####.##" valid verbcr04() 
  read

return .t.

****************
function EDBCR03
****************

  SetColor(_COREDICAO_)

  @ 11, 26 get M_BAIDTM                 valid verbcr10()
  @ 16, 26 get M_BAIJUR picture "#######.##"
  @ 17, 56 get M_BAIVAL picture "#######.##" valid verbcr08()
  read

return ""

***************
function MOSBCR
***************

parameters  M_MODO, M_ELEM, M_POSI

  if str(lastkey(), 2, 0) $ " 3#27#18"
    return 0
  endif

  if str(lastkey(), 3, 0)  $ "# 49# 50# 51# 52# 53# 54# 13"
    M_OPC = M_ELEM
    return 1
  endif

  set color to I
    @ 19, 12 say M_DUPMAT[M_ELEM, 11] 
    @ 19, 29 say M_DUPMAT[M_ELEM, 12] picture "#######" 
  set color to GR+
    @ 24, 01 say "                    1.Imprimir  2.Baixar  6.Sair"
  set color to R+
    @ 24, 21 say "1"
    @ 24, 33 say "2"
    @ 24, 43 say "6"
  set color to N/W,W+/N

  M_LINPOS = M_POSI

return 2

***************** 
function VERBCR01 
***************** 

if lastkey() = 5
  return .t.
endif

if M_BAIDSC > ADCR00->DUPVLA
  msg("* * * VALOR DA BAIXA MAIOR QUE O VALOR DA DUPLICATA * * *")
  return .f.
endif

return .t. 

***************** 
function VERBCR02 
***************** 

  select APOR00

  if !dbseek(str(M_BAIPOR, 5, 0))
    msg("* * * PORTADOR NAO CADASTRADO * * *")
    return .f.
  endif

  setcolor("I")
    @ 07, 33 say pad(PORNOM, 33)
  setcolor("")

return .t. 

***************** 
function VERBCR03 
***************** 

  if M_DUPCLI = 0
    return .f.
  endif

  if !BUSCAREGISTRO("ACLI00",1,{str(M_DUPCLI,7,0)},"SELECT")
    msg("* * * CLIENTE NAO CADASTRADO * * *")
    return .f.
  endif

  setcolor("I")
    @ 05, 15 say pad(CLINOM, 39)
    @ 05, 45 say pad(CLITEL3, 15)
    @ 05, 67 say CLIUF3
  setcolor("")

return .t. 

*****************
function VERBCR04
*****************


  M_DUPMAT[SQ, 9] = M_DUPMAT[SQ, 5] + M_DUPMAT[SQ, 7] + M_DUPMAT[SQ, 8]

  setcolor("I")
    @ LN, 64 say transform(M_DUPMAT[SQ, 9],"@E ##,###.##")
  setcolor("")

return .t.

*****************
function VERBCR05
*****************

  if lastkey() = 5
    return .t.
  endif

  for A = 1 to len(M_DUPMAT)
    if A = SQ
      loop
    endif
    if str(M_DUPMAT[A, 1], 6, 0) + str(M_DUPMAT[A, 2], 2, 0) == str(M_DUPMAT[SQ, 1], 6, 0) + str(M_DUPMAT[SQ, 2], 2, 0)
      msg("* * * TITULO JA ESTA NO ACERTO * * *")
      M_DUPMAT[SQ, 1] = 0
      M_DUPMAT[SQ, 2] = 0
      keyboard chr(5)
      return .f.
    endif
  next

  select ADCR00

  dbsetorder(1)

  if !dbseek(str(M_DUPMAT[SQ, 10], 2, 0) + str(M_DUPMAT[SQ, 1], 6, 0) + str(M_DUPMAT[SQ, 2], 2, 0))
    msg("* * * TITULO NAO INCLUIDO * * *")
    return .f.
  endif

  if DUPCLI != M_DUPCLI
    msg("* * * DUPLICATA NAO PERTENCE AO CLIENTE * * *")
    return .f.
  endif

  M_DUPMAT[SQ, 3] = DUPDTE
  M_DUPMAT[SQ, 4] = DUPVCT
  M_DUPMAT[SQ, 5] = DUPVLA - DUPDSC
  M_DUPMAT[SQ, 6] = DUPTXD
  M_DUPMAT[SQ, 7] = 0
  M_DUPMAT[SQ, 8] = 0
  M_DUPMAT[SQ, 9] = M_DUPMAT[SQ, 5]
  M_DUPMAT[SQ,10] = DUPEMP
  M_DUPMAT[SQ,11] = DUPVCT
  M_DUPMAT[SQ,12] = DUPBOL

  setcolor("I")
    @ LN, 13 say left(dtoc(M_DUPMAT[SQ, 3]), 5)
    @ LN, 19 say left(dtoc(M_DUPMAT[SQ, 4]), 5) 
    @ LN, 25 say str (M_DUPMAT[SQ, 4]-date(), 5)
    @ LN, 31 say transform(M_DUPMAT[SQ, 5],"##,###.##") 
    @ LN, 40 say transform(M_DUPMAT[SQ, 6],"##.##") 
  setcolor("")  

return .t.

***************** 
function VERBCR06 
***************** 

  if lastkey() = 5
     return .t.
  endif

  if M_BAIAPL = 0
     return .t.
  endif

  select APLX00

  if !dbseek(str(M_BAIEMP, 2, 0) + str(M_BAIAPL, 3, 0))
    msg("* * * APLICACAO NAO CADASTRADO * * *")
    return .f.
  endif

  setcolor("I")
    @ 08, 33 say pad(PLXNOM, 33)
  setcolor("")

return .t. 

***************** 
function VERBCR07 
***************** 

  if lastkey() = 5
     return .t.
  endif

  if empty(M_BAIDTM)
    msg("* * * DATA DA BAIXA NAO PODE SER ZEROS * * *")
    return .f.
  endif

return .t. 

***************** 
function VERBCR08 
***************** 

if lastkey() = 5
  return .t.
endif

if !str((M_BAIVAL + M_BAIDSC), 12, 2) == str(ADCR00->DUPVLA, 12, 2)
  msg("* * * VALOR DA BAIXA NAO BATE COM VALOR DA DUPLICATA * * *")
  return .f.
endif

return .t. 

***************** 
function VERBCR09 
***************** 

  select APOR00

  if !dbseek(str(M_BAIPOR, 5, 0))
    msg("* * * PORTADOR NAO CADASTRADO * * *")
    return .f.
  endif

  msg("* * * " + alltrim(APOR00->PORNOM) + " * * *")

return .t. 

***************** 
function VERBCR10 
***************** 

if lastkey() = 5
  return .t.
endif

if empty(M_BAIDTM) .or. M_BAIDTM < ADCR00->DUPDTE
  msg("* * * DATA DA BAIXA INVALIDA * * *")
  return .f.
endif

return .t. 

***************** 
function VERBCR11 
***************** 

  if lastkey() = 5
     return .t.
  endif

  if M_BAIAPL = 0
     return .t.
  endif

  select APLX00

  if !dbseek(str(M_BAIEMP, 2, 0) + str(M_BAIAPL, 3, 0))
    msg("* * * APLICACAO NAO CADASTRADA * * *")
    return .f.
  endif

  msg("* * * " + alltrim(APLX00->PLXNOM) + " * * *")

return .t. 

****************
function TLBCR01
****************

 nbox(07, 13, 18, 66,"W/W+",.t.)
 setcolor("B/W")
  @ 08, 14 say     "Duplicata :       /     Serie:           Por:       "
  @ 09, 14 say     "Emiss„o   :           Cliente:           Apl:       "
  @ 10, 14 say     "Vencto    :              Nome:                      "
  @ 11, 14 say     "Pagamento :             Valor:                      "
  @ 12, 14 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
  @ 13, 14 say     "Observa‡„o:                                         "
  @ 14, 14 say     "          :                                         "
  @ 15, 14 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
  @ 16, 14 say     "Vlr Juros :                 Vlr Desconto:           "
  @ 17, 14 say     "Vlr Taxas :                 Vlr Baixa   :           "
set color to

return ""

****************
function TLBCR02                       && tela baixa por grupo
****************

 nbox(03, 02, 20, 76,"W/W+",.t.)
 setcolor("B/W")
  @ 04, 03 say     " Cliente :         a                                     Data:           "
  @ 05, 03 say     " Nome    :                         Fone:                   Uf:           "
  @ 06, 03 say     "ÄÄÄÄÄÄÂÄÄÂÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄ"
  @ 07, 03 say     "T¡tulo³Or³ Dte ³ Vct ³Prazo³ Valor  ³Taxa ³Cart¢rio³Diversas³  Total  ³Em"
  @ 08, 03 say     "ÄÄÄÄÄÄÅÄÄÅÄÄÄÄÄÅÄÄÄÄÄÅÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄ"
  for zz = 9 to 17
  @ zz, 03 say     "      ³  ³     ³     ³     ³        ³     ³        ³        ³         ³  "
  next
  @ 18, 03 say     "ÄÄÄÄÄÄÁÄÄÁÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄ"
  @ 19, 03 say     " Vencto:          Boleto:                            Totais:             "
set color to

return "" 

**************** 
function MSBCR01
**************** 

setcolor("N/W*")
  @ 08, 26 say DUPNUM picture "######"
  @ 08, 33 say DUPORD picture "##"
  @ 08, 45 say DUPSER picture "@!"
  @ 08, 60 say DUPPOR picture "#####"

  @ 09, 26 say DUPDTE
  @ 09, 45 say DUPCLI picture "#######"
  @ 09, 60 say DUPCPG picture "#####"

  @ 10, 26 say DUPVCT
  @ 10, 45 say pad(CLINOM, 21)

  @ 11, 26 say iif(HB_ISNIL(DUPDTP),ctod("  /  /  "),DUPDTP)
  @ 11, 45 say DUPVLA picture "@E ###,###,###.##"

  @ 13, 26 say DUPOBS
  @ 14, 26 say DUPOBT
set color to 

return ""

**************** 
function MSBCR02
**************** 

parameters SQ,R

    setcolor("I")
      for S = SQ to len(M_DUPMAT)
        @ R, 03 say M_DUPMAT[S, 1] picture "######"     
        @ R, 10 say M_DUPMAT[S, 2] picture "##"   
        @ R, 13 say left(dtoc(M_DUPMAT[S, 3]), 5)
        @ R, 19 say left(dtoc(M_DUPMAT[S, 4]), 5) 
        @ R, 25 say str(iif(empty(M_DUPMAT[S, 4]),0,M_DUPMAT[S, 4])-date(), 5)
        @ R, 31 say transform(M_DUPMAT[S, 5],"#####.##") 
        @ R, 40 say transform(M_DUPMAT[S, 6],"##.##") 
        @ R, 46 say M_DUPMAT[S, 7] picture "#####.##"  
        @ R, 55 say M_DUPMAT[S, 8] picture "#####.##" 
        @ R, 64 say M_DUPMAT[S, 9] picture "##,###.##" 
        R++
        if R = 17
          exit
        endif
      next
    setcolor("")

return ""

**************** 
function LPBCR01
**************** 

  setcolor("I")
    for K = 09 to 17
      @ K, 02 say "³      ³  ³     ³     ³     ³        ³     ³        ³        ³         ³  ³"
    next
  setcolor("")

return ""

****************
functio CABBCR01
****************

  store PG + 1 to PG

  if PG > 1
    eject
  endif

  BUSCAREGISTRO("ACLI00",1,{str(M_DUPCLI,7,0)},"SELECT")

  ? cent_cab(AEMP00->EMPFAN,"RELACAO DE TITULOS EM DEBITO","",132) 
  ?
  ? "Cliente      : " +  ACLI00->CLINOM + " " + str(ACLI00->CLICOD, 7, 0)
  ? "Endereco     : " +  ACLI00->CLIEND3
  ? "Municipio    : " + strzero(ACLI00->CLICCL3, 5, 0) + " " + strzero(ACLI00->CLICCL3) +  " " + ACLI00->CLIMUN3 + " " + ACLI00->CLIUF3
  ? "Telefone     : " +  ACLI00->CLITEL3
  ?
  ? 
  ? "   TITULO    EMISSAO   VENCTO  PRAZO BANCO NOME          PROP       TITULO     % TXD    JUROS     CARTORIO   DIVERSAS     TOTAL Em"
  ? 
*     999999/99-3 99/99/99 99/99/99 99999 99999 XXXXXXXXXXX 99999.99 X ###,###.## ##.## ###.###,## ###,###.## ###,###.## ####,###.## 99

     store 11 to LN

return ""

******************
functio LAN_FLXBCR
******************

*
** Lanca valor da baixa
*

  if APLX00->(dbseek(str(ADCR00->DUPEMP, 2, 0) + str(ADCR00->DUPAPL, 3, 0)))
    select ALAX00                   && seleciona fluxo de caixa
    M_LAXSEQ = 1
    do while .t.
      if dbseek(str(M_BAIEMP, 2, 0) + dtos(M_BAIDTM) + str(M_LAXSEQ, 6, 0))   
        M_LAXSEQ = M_LAXSEQ + 1
        if M_LAXSEQ > 999999
          msg("* * * LANCAMENTOS ESGOTADOS * * *")
          exit     
        endif
        loop
      endif
      exit 
    enddo

    select ALAX00                   && seleciona fluxo de caixa
    _append("ALAX00") 
    do while .t. 
      if rlock()                   
        replace LAXEMP with M_BAIEMP
        replace LAXAPL with ADCR00->DUPAPL
        replace LAXDTA with M_BAIDTM
        replace LAXSEQ with M_LAXSEQ 
        replace LAXVLR with M_BAIVAL  
        replace LAXHIS with "REF PAG " + alltrim(M_BAIOBS) + " " + alltrim(str(M_BAINUM, 6, 0) + "/" + str(M_BAIORD, 2, 0)) + " " + alltrim(ADCR00->DUPNOM)
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

  endif

*
** Lanca valor dos juros
*

if M_BAIJUR > 0 
  if APLX00->(dbseek(str(ME_EMP, 2, 0) + str(AMOV00R->MOVPJU, 3, 0)))
    select ALAX00                   && seleciona fluxo de caixa
    M_LAXSEQ = 1
    do while .t.
      if dbseek(str(M_BAIEMP, 2, 0) + dtos(M_BAIDTM) + str(M_LAXSEQ, 6, 0))   
        M_LAXSEQ = M_LAXSEQ + 1
        if M_LAXSEQ > 999999
          msg("* * * LANCAMENTOS ESGOTADOS * * *")
          exit     
        endif
        loop
      endif
      exit 
    enddo
    select ALAX00                   && seleciona fluxo de caixa
    _append("ALAX00") 
    do while .t. 
      if rlock()                   
        replace LAXEMP with M_BAIEMP
        replace LAXAPL with AMOV00R->MOVRJU
        replace LAXDTA with M_BAIDTM
        replace LAXSEQ with M_LAXSEQ 
        replace LAXVLR with M_BAIJUR
        replace LAXHIS with "REF JUR " + alltrim(M_BAIOBS) + " " + alltrim(str(M_BAINUM, 6, 0) + "/" + str(M_BAIORD, 2, 0)) + " "  + alltrim(ADCR00->DUPNOM)
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
  endif
endif

*
** Lanca valor das taxas 
*

if M_BAITAX > 0 
  if APLX00->(dbseek(str(ME_EMP, 2, 0) + str(AMOV00R->MOVPTX, 3, 0)))
    select ALAX00                   && seleciona fluxo de caixa
    M_LAXSEQ = 1
    do while .t.
      if dbseek(str(M_BAIEMP, 2, 0) + dtos(M_BAIDTM) + str(M_LAXSEQ, 6, 0))   
        M_LAXSEQ = M_LAXSEQ + 1
        if M_LAXSEQ > 999999
          msg("* * * LANCAMENTOS ESGOTADOS * * *")
          exit     
        endif
        loop
      endif
      exit 
    enddo
    select ALAX00                   && seleciona fluxo de caixa
    _append("ALAX00") 
    do while .t. 
      if rlock()                   
        replace LAXEMP with M_BAIEMP
        replace LAXAPL with AMOV00R->MOVRTX
        replace LAXDTA with M_BAIDTM
        replace LAXSEQ with M_LAXSEQ 
        replace LAXVLR with M_BAITAX
        replace LAXHIS with "REF TAX " + alltrim(M_BAIOBS) + " " + alltrim(str(M_BAINUM, 6, 0) + "/" + str(M_BAIORD, 2, 0)) + " " + alltrim(ADCR00->DUPNOM)
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
  endif
endif

return ""



*****************
function BAIBCR_C                     && baixa por recepcao
*****************

abre_ret("11") && retorno

private PG       ,;
        LN       ,;
        M_TOTAL  ,;
        M_COP    ,;
        M_CON    ,;
        M_ESC    ,;
        M_OPC

  store 1       to M_COP,M_CON

  store date() to M_DTEREC

  sombra(10, 34, 12, 60,_SOMBRA_)

  set color to GR+/W+
    @ 10, 34 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
    @ 11, 34 say "³Data Recepcao  :         ³" 
    @ 12, 34 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 

  SetColor(_COREDICAO_)
  @ 11, 52 get M_DTEREC
  read

  if lastkey() = 27
    return ""
  endif

  M_ARQ = _PATH_ + "\RE" + substr(dtoc(M_DTEREC), 1, 2) + substr(dtoc(M_DTEREC), 4, 2) + substr(dtoc(M_DTEREC), 7, 2) + ".RET"

  if !file(M_ARQ)
    msg("* * * ARQUIVO: " + M_ARQ + " NAO ENCONTRADO * * *")
    return "" 
  endif 

  M_IMPRE = impresn()

  if M_IMPRE = "N"
    return ""
  endif

  if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
    ?? chr(15)                        && comprime
  endif

  PG = 0
  LN = 0

  M_OBSERV = space(11)
  M_TOTPAG = 0
  M_TOTJUR = 0
  M_TOTDSC = 0

  select ARET00

  zap

  append from &M_ARQ SDF

  go top

  cabbcr03()
   
  do while !eof()

    if !IDETRA == "1"
      skip
      loop
    endif

    if ME_EMP = 1
      if !IDEBAN == "03313014850"
        skip
        loop
      endif
    endif

    if ME_EMP = 2
      if !IDEBAN == "03313042484"
        skip
        loop
      endif
    endif

    if !ADCR00->(dbsetorder(8) , dbseek(str(ME_EMP, 2, 0) + substr(ARET00->IDETIT, 4, 7)) )
      M_OBSERV = "TIT NAO ENC"
    else
      if ADCR00->DUPHIS = 100
        M_OBSERV = "TIT JA BAIX"
      else
        if ADCR00->DUPVLA = 0
          M_OBSERV = "SEM SALDO !"
        else
          M_OBSERV = "BAIXA OK ! "
        endif                  
      endif 
    endif

    ACLI00->(dbseek(str(ADCR00->DUPCLI, 7, 0)))  

    ? " " 
     ?? ADCR00->DUPNUM 
     ?? "/" 
     ?? ADCR00->DUPORD 
     ?? " "
     ?? substr(IDETIT, 4, 7)
     ?? " "
     ?? ADCR00->DUPCLI 
     ?? " "
     ?? left(ACLI00->CLINOM, 29)
     ?? " "
     ?? ADCR00->DUPDTE
     ?? " "
     ?? ADCR00->DUPVCT
     ?? " "
     ?? substr(DTAOCO, 1, 2) + "/" + substr(DTAOCO, 3, 2) + "/" + substr(DTAOCO, 5, 2) 
     ?? " "
     ?? transform((val(VLRLAN) * .01) + (val(VLRTAR) * .01),"@E ####,###.##") 
     ?? " "
     ?? transform((val(VLRJUR) * .01),"@E ####,###.##") 
     ?? " "
     ?? transform((val(VLRDSC) * .01),"@E ####,###.##") 
     ?? " "  
     ?? M_OBSERV

     LN = LN + 1

     if LN > 60
       cabbcr03()
     endif
    
     if !ADCR00->(dbsetorder(8) , dbseek(str(ME_EMP, 2, 0) + substr(ARET00->IDETIT, 4, 7)) )
       skip
       loop
     endif
*/
     if ADCR00->DUPHIS = 100
       skip
       loop
     endif 

     if ADCR00->DUPVLA = 0
       skip
       loop
     endif                  

     M_BAIEMP = ADCR00->DUPEMP
     M_BAINUM = ADCR00->DUPNUM
     M_BAIORD = ADCR00->DUPORD
     M_BAIPOR = ADCR00->DUPPOR
     M_BAIDTM = ctod(substr(DTAOCO, 1, 2) + "/" + substr(DTAOCO, 3, 2) + "/" + substr(DTAOCO, 5, 2) )
     M_BAIHIS = 100 
     M_BAICLI = ADCR00->DUPCLI
     M_BAIOBS = ADCR00->DUPOBS 
     M_BAIOBT = ADCR00->DUPOBT 
     M_BAIVAL = ADCR00->DUPVLA - ADCR00->DUPDSC
     M_BAIJUR = (val(VLRJUR) * .01)
     M_BAIDSC = (val(VLRDSC) * .01)
     M_BAITAX = 0 
     M_BAIAPL = ADCR00->DUPAPL 

     select ALCR00 

     _append("ALCR00")

     do while .t. 
       if rlock()
         replace LANEMP with M_BAIEMP          
         replace LANNUM with M_BAINUM
         replace LANORD with M_BAIORD   
         replace LANHIS with M_BAIHIS   
         replace LANDTM with M_BAIDTM   
         replace LANCLI with M_BAICLI 
         replace LANVAL with M_BAIVAL   
         replace LANJUR with M_BAIJUR   
         replace LANDSC with M_BAIDSC   
         replace LANTAX with M_BAITAX   
         replace LANOBS with M_BAIOBS
         unlock
         exit 
       else
         msg("* * * (ALCR00) REGISTRO SENDO USADO * * *")
       endif
       if lastkey() = 17
         exit
       endif 
     enddo

* -> se houver desconto gera lancamento codigo 200 

     if M_BAIDSC > 0                 
       _append("ALCR00")
       do while .t. 
         if rlock()
           replace LANEMP with M_BAIEMP          
           replace LANNUM with M_BAINUM
           replace LANORD with M_BAIORD   
           replace LANHIS with val("200") 
           replace LANDTM with M_BAIDTM   
           replace LANCLI with M_BAICLI 
           replace LANVAL with M_BAIDSC   
           replace LANJUR with 0 
           replace LANDSC with 0 
           replace LANTAX with 0 
           replace LANOBS with M_BAIOBS 
           unlock
           exit 
         else
           msg("* * * (ALCR00) REGISTRO SENDO USADO * * *")
         endif
         if lastkey() = 17
           exit
         endif 
       enddo
     endif
 
     select ABCR00 

     if !dbseek(str(M_BAIEMP, 2, 0) + dtos(M_BAIDTM) + str(M_BAINUM, 6, 0) + str(M_BAIORD, 2, 0))
       _append("ABCR00")
     endif

     do while .t. 
       if rlock()
         replace BAIEMP with M_BAIEMP          
         replace BAIDTM with M_BAIDTM
         replace BAINUM with M_BAINUM
         replace BAIORD with M_BAIORD   
         replace BAISER with ADCR00->DUPSER
         replace BAIVAL with M_BAIVAL   
         replace BAIJUR with M_BAIJUR
         replace BAITAX with M_BAITAX
         replace BAISIT with "A" 
         unlock
         exit 
       else
         msg("* * * (ABCR00) REGISTRO SENDO USADO * * *")
       endif
       if lastkey() = 17
         exit
       endif 
     enddo

     if M_BAIPOR = 1
       if ADCR00->DUPAPL > 0
         lan_flxbcr()              && lanca fluxo de caixa 
       endif
     endif

     select ADCR00                && atualiza dados na duplicata 

     do while .t. 
       if rlock()
         replace DUPPOR with M_BAIPOR  
         replace DUPDTP with M_BAIDTM 
         replace DUPVLA with 0   
         replace DUPOBS with M_BAIOBS 
         replace DUPOBT with M_BAIOBT   
         replace DUPHIS with M_BAIHIS 
         replace DUPJUR with M_BAIJUR   
         replace DUPDSC with M_BAIDSC   
         replace DUPTAX with M_BAITAX   
         replace DUPVLP with M_BAIVAL 
         replace DUPDSC with M_BAIDSC 
         unlock
         commit
         exit 
       else
         msg("* * * (ADCR00) REGISTRO SENDO USADO * * *")
       endif
       if lastkey() = 17
         exit
       endif 
     enddo

     select ARET00 

     M_TOTPAG = M_TOTPAG + (val(VLRLAN) * .01) + (val(VLRTAR) * .01)
     M_TOTJUR = M_TOTJUR + (val(VLRJUR) * .01)
     M_TOTDSC = M_TOTDSC + (val(VLRDSC) * .01)

     skip

   enddo

   ? replicate("-", 132)
     ? space(64)
     ?? "TOTAIS -=>          "
     ?? transform(M_TOTPAG,"@E ####,###.##") 
     ?? " "
     ?? transform(M_TOTJUR,"@E ####,###.##") 
     ?? " "
     ?? transform(M_TOTDSC,"@E ####,###.##") 

   eject

desliga1()

return "" 

*****************
function CABBCR03
*****************

  store PG + 1 to PG

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"BAIXA DE TITULOS AUTOMATICA","EAGRO33",132) 
  ? cent_cab(M_DATA,M_ARQ,"PAG.: " + str(PG, 4, 0), 132)
  ? "*------*--*-------*-------------------------------------*--------*--------*--------*-----------*-----------*-----------*-----------*"
  ? "* DUP  *OR* COD   *        CLIENTE                      *EMISSAO *  VCTO  *  PGTO  *  BAIXADO  *  JUROS    * DESCONTO  *OCORRENCIA *"
  ? "*------*--*-------*-------------------------------------*--------*--------*--------*-----------*-----------*-----------*-----------*"
*     999999 99 9999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99 ####.###,## ####.###,## ####.###.## ...........

  LN = 5
 
return "" 



*****************
function BAIBCR_D                     && consistecia
*****************

abre_ret("11") && retorno

private PG       ,;
        LN       ,;
        M_TOTAL  ,;
        M_COP    ,;
        M_CON    ,;
        M_ESC    ,;
        M_OPC

  store 1       to M_COP,M_CON

  store date() to M_DTEREC

  sombra(10, 34, 12, 60,_SOMBRA_)

  set color to GR+/W+
    @ 10, 34 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
    @ 11, 34 say "³Data Recepcao  :         ³" 
    @ 12, 34 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
  SetColor(_COREDICAO_)

  @ 11, 52 get M_DTEREC
  read

  if lastkey() = 27
    return ""
  endif

  M_ARQ = _PATH_ + "\RE" + substr(dtoc(M_DTEREC), 1, 2) + substr(dtoc(M_DTEREC), 4, 2) + substr(dtoc(M_DTEREC), 7, 2) + ".RET"

  if !file(M_ARQ)
    msg("* * * ARQUIVO: " + M_ARQ + " NAO ENCONTRADO * * *")
    return "" 
  endif 

  M_IMPRE = impresn()

  if M_IMPRE = "N"
    return ""
  endif

  if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
    ?? chr(15)                        && comprime
  endif

  PG = 0
  LN = 0

  M_TOTVLA = 0
  M_TOTPAG = 0
  M_TOTJUR = 0
  M_TOTDSC = 0

  select ARET00

  zap

  append from &M_ARQ SDF

  go top

  cabbcr02()
   
  do while !eof()

    if !IDETRA == "1"
      skip
      loop
    endif

    if ME_EMP = 1
      if !IDEBAN == "03313014850"
        skip
        loop
      endif
    endif

    if ME_EMP = 2
      if !IDEBAN == "03313042484"
        skip
        loop
      endif
    endif

    ADCR00->(dbsetorder(8) , dbseek(str(ME_EMP, 2, 0) + substr(ARET00->IDETIT, 4, 7)) )
  
    ACLI00->(dbseek(str(ADCR00->DUPCLI, 7, 0)))  

    ? " " 
     ?? ADCR00->DUPNUM 
     ?? "/" 
     ?? ADCR00->DUPORD 
     ?? " "
     ?? substr(IDETIT, 4, 7)
     ?? " "
     ?? ADCR00->DUPCLI 
     ?? " "
     ?? left(ACLI00->CLINOM, 29)
     ?? " "
     ?? ADCR00->DUPDTE
     ?? " "
     ?? ADCR00->DUPVCT
     ?? " "
     ?? substr(DTAOCO, 1, 2) + "/" + substr(DTAOCO, 3, 2) + "/" + substr(DTAOCO, 5, 2) 
     ?? " "
     ?? transform(ADCR00->DUPVLA,"@E ####,###.##")
     ?? " "
     ?? transform((val(VLRLAN) * .01) + (val(VLRTAR) * .01),"@E ####,###.##") 
     ?? " "
     ?? transform((val(VLRJUR) * .01),"@E ####,###.##") 
     ?? " "
     ?? transform((val(VLRDSC) * .01),"@E ####,###.##") 

    M_TOTVLA = M_TOTVLA + ADCR00->DUPVLA
    M_TOTPAG = M_TOTPAG + (val(VLRLAN) * .01) + (val(VLRTAR) * .01)
    M_TOTJUR = M_TOTJUR + (val(VLRJUR) * .01)
    M_TOTDSC = M_TOTDSC + (val(VLRDSC) * .01)


     skip

     LN = LN + 1

     if LN > 60
       cabbcr02()
     endif

     M_ESC = inkey()

     if M_ESC = 27
       if susimp()
         ? replicate("-", 132)
         ? "* * * IMPRESSAO SUSPENSA * * *"
         exit
       else
         M_ESC = inkey()
       endif
     endif

   enddo

   ? replicate("-", 132)
     ? space(64)
     ?? "TOTAIS -=>          "
     ?? transform(M_TOTVLA,"@E ####,###.##")
     ?? " "
     ?? transform(M_TOTPAG,"@E ####,###.##") 
     ?? " "
     ?? transform(M_TOTJUR,"@E ####,###.##") 
     ?? " "
     ?? transform(M_TOTDSC,"@E ####,###.##") 

   eject

desliga1()

return "" 

*****************
function CABBCR02
*****************

  store PG + 1 to PG

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE CONSISTENCIA - DUPLICATAS BANCO","EAGRO33",132) 
  ? cent_cab(M_DATA,M_ARQ,"PAG.: " + str(PG, 4, 0), 132)
  ? "*------*--*-------*-------------------------------------*--------*--------*--------*-----------*-----------*-----------*-----------*"
  ? "* DUP  *OR* COD   *        CLIENTE                      *EMISSAO *  VCTO  *  PGTO  * ORIGINAL  *   PAGO    *   JUROS   * DESCONTO  *"
  ? "*------*--*-------*-------------------------------------*--------*--------*--------*-----------*-----------*-----------*-----------*"
*     999999 99 9999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99 ####.###,## ####.###,## ####.###,## ####.###.##

  LN = 5
 
return "" 

*****************
function BAIBCR_E                     && funcao de lista baixa 
*****************

private PG       ,;
        LN       ,;
        M_TOTAL  ,;
        M_COP    ,;
        M_CON    ,;
        M_ESC    ,;
        M_OPC

  store 1       to M_COP,M_CON

  store date() to M_DTEINI ,; 
                  M_DTEFIN

      sombra(09, 34, 13, 60,_SOMBRA_)

      set color to GR+/W+
        @ 09, 34 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
        @ 10, 34 say "³Periodo Inicial:         ³" 
        @ 11, 34 say "³          Final:         ³" 
        @ 12, 34 say "³Numero Copias  :         ³" 
        @ 13, 34 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
  SetColor(_COREDICAO_)

      @ 10, 52 get M_DTEINI
      @ 11, 52 get M_DTEFIN
      @ 12, 52 get M_COP picture "##"
      read

      if lastkey() = 27
        return ""
      endif

  M_IMPRE = impresn()

  if M_IMPRE = "N"
    return ""
  endif

  if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
    ?? chr(15)                        && comprime
  endif

  select ABCR00

  do while M_CON <= M_COP 

   store 0  to PG, M_TOTAL, M_JUROS

   select ABCR00 

   set softseek on
     seek str(ME_EMP, 2, 0) + dtos(ctod("01/01/80")) + str(000000, 6, 0) + str(00, 2, 0)
   set softseek off

   if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
     ?? chr(15)                         && comprime
   endif

   do while !eof()

     store PG + 1 to PG

     if PG > 1
       eject
     endif

     ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE BAIXAS EFETUADAS","EAGRO33",132) 
     ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
     ? "*--------*---------*-------*--------------------------*---------------*--*--------*--------*--------*--------------*-------------*-*"
     ? "* DATA   * DUPLIC  * COD   * CLIENTE                  * CIDADE        *UF*EMISSAO * VCTO   * PAGTO  * VLR ORIGINAL * VLR PAGO    *T*"
     ? "*--------*---------*-------*--------------------------*---------------*--*--------*--------*--------*--------------*-------------*-*"
 
          store 5 to LN

          do while !eof() .and. LN < 56
 
             if !str(BAIEMP, 2, 0) == str(ME_EMP, 2, 0)
               go bottom
               skip
               loop       
              endif

              if BAIDTM < M_DTEINI .or. BAIDTM > M_DTEFIN
                skip
                loop
              endif

              ADCR00->(dbseek(str(ABCR00->BAIEMP, 2, 0) + str(ABCR00->BAINUM, 6, 0) + str(ABCR00->BAIORD, 2, 0)))
              ACLI00->(dbseek(str(ADCR00->DUPCLI, 7, 0)))

              ? " " 
                ??  BAIDTM
                ?? " " 
                ?? ADCR00->DUPNUM 
                ?? "/" 
                ?? ADCR00->DUPORD 
                ?? " "
                ?? ADCR00->DUPCLI 
                ?? " "
                ?? left(ACLI00->CLINOM, 26)
                ?? " "
                ?? left(ACLI00->CLIMUN3, 15) 
                ?? " "
                ?? ACLI00->CLIUF3
                ?? " "
                ?? ADCR00->DUPDTE
                ?? " "
                ?? ADCR00->DUPVCT
                ?? " "
                ?? ADCR00->DUPDTP
                ?? " "
                ?? transform(BAIVAL, "@E ###,###,###.##")
                ?? " "
                ?? transform((BAIVAL + BAITAX + BAIJUR),"@E ##,###,###.##") 
                ?? " "
                ?? BAISIT

                  if BAIJUR > 0
                     ? space(105) 
                     ?? "JUROS....." 
                     ?? transform(BAIJUR, "@E ###,###,###.##")
                     LN = LN + 1 
                  endif 

                  if ADCR00->DUPDSC > 0
                     ? space(105) 
                     ?? "DESC......" 
                     ?? transform(ADCR00->DUPDSC, "@E ###,###,###.##")
                     LN = LN + 1 
                  endif 

                  if BAITAX > 0
                     ? space(105) 
                     ?? "TAXAS....." 
                     ?? transform(BAITAX, "@E ###,###,###.##")
                     LN = LN + 1 
                  endif 

                M_TOTAL = M_TOTAL + BAIVAL
                M_JUROS = M_JUROS + BAIJUR

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

     ? replicate("-", 132)
     ? space(90) 
       ?? "TOTAL DAS BAIXAS     -=> "
       ?? transform(M_TOTAL, "@E ###,###,###.##")
     ? space(90) 
       ?? "TOTAL JUROS/TAXAS    -=> "
       ?? transform(M_JUROS, "@E ###,###,###.##")

    eject

    M_CON = M_CON + 1 

  enddo

desliga1()

    M_OPC = deciden("Limpa arquivo de baixas")

    if M_OPC != 1
      select ABCR00
      set relation to
      return ""
    endif 
   
    select ABCR00
 
    set relation to 

    set order to 1 

    go top

    do while .t.

     set softseek on
       seek str(M_EMP, 2, 0) 
     set softseek off

     if BAIEMP != M_EMP  
       exit
     endif
 
     do while .t.
       if rlock()
         replace BAIEMP with 0
         replace BAIDTM with ctod("  /  /  ")
         replace BAINUM with 0
         replace BAIORD with 0
         replace BAISIT with " "
         unlock
         commit
         exit
       else
         msg("* * * (ABCR00) REGISTRO SENDO USADO * * *")
       endif  
       if lastkey() = 17
         exit
       endif 
     enddo

 enddo

msg("* * * BAIXAS ELIMINADAS * * *") 

return "" 
