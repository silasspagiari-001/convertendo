#command @ <row> , <col>  GET <var> [<clauses,...>] F2 [<moreClauses,...>] funcao <func> retorno <Variavel>;
=>       @ <row> , <col>  GET <var> [<clauses>] SEND reader := {|oGet| Getf2(oGet,<func>,<Variavel>) } [<moreClauses>]

***************
function MANBCP                        && baixa de Duplicata 
***************  
parameters M_OPC,M_OPC1,M_OPC2

_FUNCLI_ = "CONPAG.f."
_FUNPRO_ = "CONPAG.f."
_FUNFOR_ = "CONPAG.t."
_FUNCPG_ = "CONPAG.f."
_FUNTRA_ = "CONPAG.f."
_FUNVEN_ = "CONPAG.f."
_FUNPLX_ = "CONPAG.f."

      rodape("BAIXA","DUPLICATA",M_FAN,"EAGRO43","Mem: " + str(memory(0), 5),M_EMP)

*        @ 07, 40 prompt "Documento " HIGHLITE R/BG PERMITE 3,4,1
*        @ 08, 40 prompt "Fornecedor" HIGHLITE R/BG PERMITE 3,4,2
*        @ 09, 40 prompt "Listagem  " HIGHLITE R/BG PERMITE 3,4,3

      do case
         case M_OPC = 1 ; baibcp_a()
         case M_OPC = 2 ; baibcp_b()   
         case M_OPC = 3 ; baibcp_c()   
      endcase


    fecha_arq()

return ""

*****************
function BAIBCP_A
*****************

    do while .t.

      rodape("BAIXA","DUPLICATA",M_FAN,"EAGRO43","Mem: " + str(memory(0), 5),M_EMP) 

      M_BAIDTM = ctod("  /  /  ") 

      do while .t. 

        tlbcp01()

        M_BAIEMP = ME_EMP
        M_BAINUM = 0 
        M_BAIORD = 0 
        M_BAIFOR = 0

        SetColor(_COREDICAO_)
        @ 08, 26 get M_BAINUM F2 picture "######" color _CORF2_ funcao "verdupche(@M_BAINUM,@M_BAIORD,@M_BAIFOR)" retorno "RE"
        @ 08, 33 get M_BAIORD picture "##"
        @ 08, 48 get M_BAIFOR picture "#####"
        read

        if lastkey() = 27
          return ""
        endif

        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"ADCP00","ADCP00"})
        aadd(sqlCAMPO,"ADCP00.*")
        aadd(sqlCAMPO,"AFOR00.FORNOM")
        aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","ADCP00.DUPFOR"})
        aadd(sqlCHAVE,"DUPEMP =  " + str(ME_EMP, 2))
        aadd(sqlCHAVE,"DUPNUM =  " + str(M_BAINUM, 9))
        aadd(sqlCHAVE,"DUPORD =  " + str(M_BAIORD, 2))
        aadd(sqlCHAVE,"DUPFOR =  " + str(M_BAIFOR, 5))
        sqlrelation()


        if DUPHIS = 100
          msg("* * * DUPLICATA JA BAIXADA * * *")
          loop
        endif 

        M_BAINUM = DUPNUM
        M_BAIORD = DUPORD 
        M_BAIDTM = ctod("  /  /  ")
        M_BAIHIS = 100 
        M_BAIFOR = 0 
        M_BAIOBS = DUPOBS 
        M_BAIOBT = DUPOBT 
        M_BAIVAL = 0
        M_BAIJUR = 0 
        M_BAIDSC = 0 
        M_BAITAX = 0 

        select ADCP00

        msbcp01() 

        if DUPVLA = 0
          M_OPC = decide("Nao ha Saldo a Baixar Confirma")
          if !M_OPC == 1
             loop
          endif          
        endif                  

        M_BAIFOR = DUPFOR
        M_BAIOBS = DUPOBS 
        M_BAIOBT = DUPOBT 

        edbcp03()

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
    sqlARQUI = {"ADCP00","UPDATE"}

    aadd(sqlCHAVE,{"DUPEMP",str(ADCP00->DUPEMP)})
    aadd(sqlCHAVE,{"DUPNUM",str(ADCP00->DUPNUM)})
    aadd(sqlCHAVE,{"DUPORD",str(ADCP00->DUPORD)})
    aadd(sqlCHAVE,{"DUPFOR",str(ADCP00->DUPFOR)})
    aadd(sqlCAMPO,{"DUPDTP",formatdta(M_BAIDTM),.t.})
    aadd(sqlCAMPO,{"DUPVLA",str1(0,2),.t.})
    aadd(sqlCAMPO,{"DUPOBS",M_BAIOBS,.t.})
    aadd(sqlCAMPO,{"DUPOBT",M_BAIOBT,.t.})
    aadd(sqlCAMPO,{"DUPHIS",str(100),.t.})
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
*/*
*****************
function BAIBCP_B                      && baixa de Duplicata 
*****************

  set key -3 to FUNFOR()
  set key -9 to CALCULA()

  do while .t.

    tlbcp02()

    rodape("BAIXA","TITULO",M_FAN,"EAGRO43","Mem: " + str(memory(0), 5),M_EMP) 

    keyfun()

    M_DUPFOR = 0
    M_DUPCLF = 0
    M_DUPCOR = date()
    M_DUPMAT = {}

    M_BAIEMP = ME_EMP
    M_BAIDSC = 0
    M_BAIOBS = space(40)
    M_BAIOBT = space(40)

    SetColor(_COREDICAO_)
    @ 04, 14 get M_DUPFOR picture "#######" valid verbcp03()
    @ 04, 24 get M_DUPCLF picture "#######" 
    @ 04, 66 get M_DUPCOR 
    read

    if lastkey() = 27
      exit
    endif
  
    select AEMP00

    dbseek(str(1, 2, 0))

    SQ = 1

    do while !eof()

      if eof()
        exit
      endif

      select ADCP00

      ( dbsetorder(2) , dbseek(str(AEMP00->EMPCOD, 2, 0) + str(M_DUPFOR, 7, 0), .t.) ) 
  
      if str(DUPEMP, 2, 0) + str(DUPFOR, 7, 0) > str(AEMP00->EMPCOD, 2, 0) + str( M_DUPCLF, 7, 0)
        select AEMP00
        skip
        loop
      endif 
    
      do while !eof()

        if str(DUPEMP, 2, 0) + str(DUPFOR, 7, 0) > str(AEMP00->EMPCOD, 2, 0) + str(M_DUPCLF, 7, 0)
          exit
        endif 

        if DUPHIS = 100
          skip
          loop
        endif

  *                  1   2   3                 4                  5   6   7   8   9   10  11  12
  *                  DUP ORD DTE               VCT                VLA TXD CAR DIV TOT EMP VCT BOL

        aadd(M_DUPMAT,{0,  0,  ctod("  /  /  "), ctod("  /  /  "),  0,  0,  0,  0,  0, 0, ctod("  /  /  "), 0})

        M_DUPMAT[SQ, 1] = DUPNUM
        M_DUPMAT[SQ, 2] = DUPORD
        M_DUPMAT[SQ, 3] = DUPDTE
        M_DUPMAT[SQ, 4] = DUPVCT
        M_DUPMAT[SQ, 5] = DUPVLA
        M_DUPMAT[SQ, 6] = DUPTXD
        M_DUPMAT[SQ, 7] = 0
        M_DUPMAT[SQ, 8] = 0
        M_DUPMAT[SQ, 9] = juros_bcpx(M_DUPMAT[SQ, 5] ,  M_DUPMAT[SQ, 7] , M_DUPMAT[SQ, 8])
        M_DUPMAT[SQ,10] = DUPEMP
        M_DUPMAT[SQ,11] = DUPVCT
        M_DUPMAT[SQ,12] = DUPBOL

        skip

        SQ = SQ + 1

      enddo

      select AEMP00

      skip

    enddo

    if len(M_DUPMAT) = 0
      msg("* * * FORNECEDOR SEM DUPLICATA EM ABERTO * * *")
      loop
    endif

    ADCP00->(dbsetorder(1))

    AEMP00->(dbseek(str(ME_EMP, 2, 0)))

    declare M_VETORITE[len(M_DUPMAT)]

    TODUP = 0

    for R = 1 to len(M_DUPMAT)

      M_VETORITE[R] = str (M_DUPMAT[R, 1], 6, 0)               + "³" + ;
                      str (M_DUPMAT[R, 2], 2, 0)               + "³" + ;
                      left(dtoc(M_DUPMAT[R, 3]), 5)            + "³" + ;
                      left(dtoc(M_DUPMAT[R, 4]), 5)            + "³" + ;
                      str (M_DUPMAT[R, 4]-M_DUPCOR, 5)         + "³" + ;
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
        msg("* * * FORNECEDOR SEM DUPLICATA EM ABERTO * * *")
        exit
      endif
      set color to I
        @ 19, 12 say M_DUPMAT[ 1, 11] 
        @ 19, 29 say M_DUPMAT[ 1, 12] picture "#######" 
      set color to GR+
        @ 24, 01 say "                    1.Imprimir  2.Baixar  3.Deleta  4.Adiciona  5.Insere  6.Sair"
      set color to R+
        @ 24, 21 say "1"
        @ 24, 33 say "2"
        @ 24, 43 say "3"
        @ 24, 53 say "4"
        @ 24, 65 say "5"
        @ 24, 75 say "6"
      set color to N/W,W+/N
        M_OPC = achoice( 9, 3, 17, 75,M_VETORITE,,"mosbcp")
      set color to 

      if lastkey() = 13
        altbcpacp() && altera item  
        loop
      endif

      if lastkey() = 49
        impbcpacp() && imprime acerto  1
        loop
      endif

     if lastkey() = 50
        probcpacp(M_OPC) && processa baixa do acerto  2
        loop
      endif

      if lastkey() = 51
        delbcpacp() && deleta item  3
        loop
      endif

      if lastkey() = 52
        addbcpacp() && adiciona itens  4
        loop
      endif

      if lastkey() = 53
        insbcpacp() && insere item  5
        loop
      endif

      if lastkey() = 54 
        exit        && abandona operacao  6
      endif

    enddo

  enddo

return ""

******************
function ALTBCPACP
******************

    edbcp01(09 + M_LINPOS,M_OPC)

    TODUP = 0

    for R = 1 to len(M_DUPMAT)

      M_VETORITE[R] = str (M_DUPMAT[R, 1], 6, 0)               + "³" + ;
                      str (M_DUPMAT[R, 2], 2, 0)               + "³" + ;
                      left(dtoc(M_DUPMAT[R, 3]), 5)            + "³" + ;
                      left(dtoc(M_DUPMAT[R, 4]), 5)            + "³" + ;
                      str (M_DUPMAT[R, 4]-M_DUPCOR, 5)         + "³" + ;
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
function IMPBCPACP
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

  cabbcp01()

  ADCP00->(dbsetorder(1))

  for R = 1 to len(M_DUPMAT)

    ADCP00->(dbseek(str(M_DUPMAT[R, 10], 2, 0) + str(M_DUPMAT[R, 1], 6, 0) + str(M_DUPMAT[R, 2], 2, 0)))
    ACPG00->(dbseek(str(ADCP00->DUPCPG, 3, 0)))
    APOR00->(dbseek(str(ADCP00->DUPPOR, 5, 0)))

    ? " "
      ?? str(M_DUPMAT[R, 1], 6, 0)
      ?? "/"
      ?? strzero(M_DUPMAT[R, 2], 2, 0)
      ?? "-"
      ?? str(ACPG00->CPGPAR, 1, 0)
      ?? " "
      ?? M_DUPMAT[R, 3]
      ?? " "
      ?? M_DUPMAT[R, 4]
      ?? " "
      ?? str(M_DUPMAT[R, 4]-M_DUPCOR, 5, 0) 
      ?? " "
      ?? str(ADCP00->DUPPOR, 5, 0)
      ?? " "
      ?? pad(APOR00->PORNOM, 14)
      ?? " "
      ?? str((ADCP00->DUPFOR * .01), 7, 2)
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
        cabbcp01()
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
function PROBCPACP
******************

 private M_TELA

 parameters SQ

  if !ADCP00->(dbsetorder(1) , dbseek(str(M_DUPMAT[SQ, 10], 2, 0) + str(M_DUPMAT[SQ, 1], 6, 0) + str(M_DUPMAT[SQ, 2], 2, 0)))
    return ""
  endif

  AMOV00P->(dbseek(str(M_BAIEMP, 2, 0) + str(100, 3, 0)))

  M_TELA = savescreen(06, 13, 14, 67)

  M_BAIDTM = ADCP00->DUPDTP
  M_BAIOBS = ADCP00->DUPOBS
  M_BAIOBT = ADCP00->DUPOBT

 nbox(06, 13, 13, 66,"W/W+",.t.)
 setcolor("B/W")
      @ 07, 14 say   "Portador  :                                         "
      @ 08, 14 say   "Aplicacao :                                         "
      @ 09, 14 say   "Desconto  :                                         "
      @ 10, 14 say   "Observacao:                                         "
      @ 11, 14 say   "          :                                         "
      @ 12, 14 say   "Data Baixa:                       Valor:            "
        SetColor(_COREDICAO_)
  @ 09, 26  get M_BAIDSC picture "#######.##" valid verbcp01()
  @ 10, 26  get M_BAIOBS picture "@!"
  @ 11, 26  get M_BAIOBT picture "@!"
  @ 12, 26  get M_BAIDTM                      valid verbcp07()
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

  select ALCP00 

  _append("ALCP00")

        do while .t. 
          if rlock()
            replace LANEMP with M_DUPMAT[SQ, 10]
            replace LANNUM with ADCP00->DUPNUM
            replace LANORD with ADCP00->DUPORD
            replace LANHIS with 100
            replace LANDTM with M_DUPCOR
            replace LANFOR with ADCP00->DUPFOR
            replace LANVAL with ADCP00->DUPVLA
            replace LANJUR with M_DUPMAT[SQ, 7]
            replace LANDSC with 0
            replace LANTAX with M_DUPMAT[SQ, 8]
            unlock
            exit 
          else
            msg("* * * (ALCP00) REGISTRO SENDO USADO * * *")
          endif
          if lastkey() = 17
            exit
          endif 
        enddo

        select ABCP00 

        _append("ABCP00")

        do while .t. 
          if rlock()
            replace BAIEMP with M_DUPMAT[SQ, 10]
            replace BAIDTM with ADCP00->DUPDTP
            replace BAINUM with ADCP00->DUPNUM
            replace BAIORD with ADCP00->DUPORD
            replace BAISIT with "M" 
            unlock
            exit 
          else
            msg("* * * (ABCP00) REGISTRO SENDO USADO * * *")
          endif
          if lastkey() = 17
            exit
          endif 
        enddo

        if ADCP00->DUPAPL > 0
          lan_flxacp()              && lanca fluxo de caixa acerto
        endif

        select ADCP00                && atualiza dados na duplicata 

        do while .t. 
          if rlock()
            replace DUPDTP with M_BAIDTM 
            replace DUPVLA with 0   
            replace DUPHIS with 100
            replace DUPJUR with M_DUPMAT[SQ, 7]
            replace DUPDSC with 0
            replace DUPTAX with M_DUPMAT[SQ, 8]
            replace DUPVLP with M_DUPMAT[SQ, 9]
            replace DUPOBS with M_BAIOBS
            replace DUPOBT with M_BAIOBT
            unlock
            commit
            exit 
          else
            msg("* * * (ADCP00) REGISTRO SENDO USADO * * *")
          endif
          if lastkey() = 17
            exit
          endif 
        enddo

     msg("* * * TITULO BAIXADO * * *")

  restscreen(06, 13, 14, 67, M_TELA)

  adel(M_DUPMAT,SQ)
  adel(M_VETORITE,SQ)

  asize(M_DUPMAT,len(M_DUPMAT) - 1)
  asize(M_VETORITE,len(M_VETORITE) - 1)

  lpbcp01()

    TODUP = 0

    for R = 1 to len(M_DUPMAT)

      M_VETORITE[R] = str (M_DUPMAT[R, 1], 6, 0)               + "³" + ;
                      str (M_DUPMAT[R, 2], 2, 0)               + "³" + ;
                      left(dtoc(M_DUPMAT[R, 3]), 5)            + "³" + ;
                      left(dtoc(M_DUPMAT[R, 4]), 5)            + "³" + ;
                      str (M_DUPMAT[R, 4]-M_DUPCOR, 5)         + "³" + ;
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
function DELBCPACP
******************

private M_DUP, R

  M_DUP = decide("Confirma Exclusao deste Item")

  if M_DUP != 1
    return ""
  endif

  adel(M_DUPMAT,M_OPC)
  adel(M_VETORITE,M_OPC)

  asize(M_DUPMAT,len(M_DUPMAT) - 1)
  asize(M_VETORITE,len(M_VETORITE) - 1)

  lpbcp01()

  TODUP = 0

  for R = 1 to len(M_DUPMAT)

    M_VETORITE[R] = str (M_DUPMAT[R, 1], 6, 0)               + "³" + ;
                    str (M_DUPMAT[R, 2], 2, 0)               + "³" + ;
                    left(dtoc(M_DUPMAT[R, 3]), 5)            + "³" + ;
                    left(dtoc(M_DUPMAT[R, 4]), 5)            + "³" + ;
                    str (M_DUPMAT[R, 4]-M_DUPCOR, 5)         + "³" + ;
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
function ADDBCPACP
******************

  R = len(M_DUPMAT) + 1
  L = 09

  for S = 1 to len(M_DUPMAT)
    if L = 17
      lpbcp01()
      L = 8
    endif
    L ++
  next

  if len(M_DUPMAT) - (int(len(M_DUPMAT)/9)*9) != 0
    msbcp01((int(len(M_DUPMAT)/9)*9)+1 , 9)
  endif

  do while .t.

    aadd(M_DUPMAT,{0,  0,  ctod("  /  /  "), ctod("  /  /  "),  0,  0,  0,  0,  0, 0, ctod("  /  /  "), 0})

    edbcp02(L,R)

    if lastkey() = 27 
      adel(M_DUPMAT,R)
      asize(M_DUPMAT,len(M_DUPMAT) - 1)
      exit
    endif

    if L = 17
      lpbcp01()
      L = 8
    endif

    R ++
    L ++

  enddo

  lpbcp01()

  asize(M_VETORITE, R)

  ains(M_VETORITE, len(M_VETORITE))

  TODUP = 0

  for R = 1 to len(M_DUPMAT)

    M_VETORITE[R] = str (M_DUPMAT[R, 1], 6, 0)               + "³" + ;
                    str (M_DUPMAT[R, 2], 2, 0)               + "³" + ;
                    left(dtoc(M_DUPMAT[R, 3]), 5)            + "³" + ;
                    left(dtoc(M_DUPMAT[R, 4]), 5)            + "³" + ;
                    str (M_DUPMAT[R, 4]-M_DUPCOR, 5)         + "³" + ;
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

return ""

******************
function INSBCPACP
******************

private R,S

  aadd(M_DUPMAT,{0,  0,  ctod("  /  /  "), ctod("  /  /  "),  0,  0,  0,  0,  0, 0, ctod("  /  /  "), 0})
 
  R = len(M_DUPMAT)

  M_MATANT = aclone(M_DUPMAT)

  acopy(M_MATANT,M_DUPMAT,R,1,M_OPC)

  if M_OPC-1 = 1
    acopy(M_MATANT,M_DUPMAT,M_OPC-1,M_OPC-1,1)
  endif

  acopy(M_MATANT,M_DUPMAT,M_OPC,R-M_OPC,M_OPC+1)

  msbcp01(M_OPC,09 + M_LINPOS)

  edbcp02(09 + M_LINPOS, M_OPC)

  if M_DUPMAT[M_OPC, 1] = 0
    adel(M_DUPMAT,M_OPC)
    asize(M_DUPMAT,len(M_DUPMAT) - 1)
    R = len(M_DUPMAT)
    lpbcp01()
  endif

  asize(M_VETORITE, R)

  ains(M_VETORITE, len(M_VETORITE))

  TODUP = 0

  for S = 1 to len(M_DUPMAT)

    M_VETORITE[S] = str (M_DUPMAT[S, 1], 6, 0)               + "³" + ;
                    str (M_DUPMAT[S, 2], 2, 0)               + "³" + ;
                    left(dtoc(M_DUPMAT[S, 3]), 5)            + "³" + ;
                    left(dtoc(M_DUPMAT[S, 4]), 5)            + "³" + ;
                    str (M_DUPMAT[S, 4]-M_DUPCOR, 5)         + "³" + ;
                    transform(M_DUPMAT[S, 5],"@E #####.##")  + "³" + ;
                    str (M_DUPMAT[S, 6], 5, 2)               + "³" + ;
                    str (M_DUPMAT[S, 7], 8, 2)               + "³" + ;
                    str (M_DUPMAT[S, 8], 8, 2)               + "³" + ;
                    transform(M_DUPMAT[S, 9],"@E ##,###.##") + "³" + ;
                    str (M_DUPMAT[R,10], 2, 0)                

     TODUP = TODUP + M_DUPMAT[S, 9]

  next

  setcolor("I")
    @ 19, 63 say transform(TODUP,"@E ####,###.##") 
  setcolor("")  

return ""

****************
function EDBCP01
****************

  parameters LN,SQ

        SetColor(_COREDICAO_)
  @ LN, 40 get     M_DUPMAT[SQ, 6] picture "##.##"
  @ LN, 46 get     M_DUPMAT[SQ, 7] picture "#####.##"  
  @ LN, 55 get     M_DUPMAT[SQ, 8] picture "#####.##" valid verbcp04() 
  read

return .t.

****************
function EDBCP02
****************

  parameters LN,SQ

  SetColor(_COREDICAO_)
  @ LN, 03 get     M_DUPMAT[SQ, 1] picture "######"
  @ LN, 10 get     M_DUPMAT[SQ, 2] picture "##"       valid verbcp05()
  @ LN, 40 get     M_DUPMAT[SQ, 6] picture "##.##"     
  @ LN, 46 get     M_DUPMAT[SQ, 7] picture "#####.##"  
  @ LN, 55 get     M_DUPMAT[SQ, 8] picture "#####.##" valid verbcp04() 
  read

return .t.

****************
function EDBCP03
****************

  SetColor(_COREDICAO_)
  @ 11, 26 get M_BAIDTM F2 valid verbcp10() color _CORF2_ funcao "pegadata(11,26,@M_BAIDTM)" retorno "re"
  @ 13, 26 get M_BAIOBS picture "@!"
  @ 14, 26 get M_BAIOBT picture "@!"
  @ 17, 56 get M_BAIVAL picture "#######.##" valid verbcp08()
  @ 16, 26 get M_BAIJUR picture "#######.##"
  @ 17, 26 get M_BAITAX picture "#######.##"
  @ 16, 56 get M_BAIDSC picture "#######.##" valid verbcp01()
  @ 17, 56 get M_BAIVAL picture "#######.##" valid verbcp08()
  read

return ""

***************
function MOSBCP
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
    @ 24, 01 say "                    1.Imprimir  2.Baixar  3.Deleta  4.Adiciona  5.Insere  6.Sair"
  set color to R+
    @ 24, 21 say "1"
    @ 24, 33 say "2"
    @ 24, 43 say "3"
    @ 24, 53 say "4"
    @ 24, 65 say "5"
    @ 24, 75 say "6"
  set color to N/W,W+/N

  M_LINPOS = M_POSI

return 2

***************** 
function VERBCP01 
***************** 

if lastkey() = 5
  return .t.
endif

if M_BAIDSC > ADCP00->DUPVLA
  msg("* * * VALOR DA BAIXA MAIOR QUE O VALOR DA DUPLICATA * * *")
  return .f.
endif

return .t. 


***************** 
function VERBCP03 
***************** 

  if M_DUPFOR = 0
    return .f.
  endif

  if M_DUPFOR > 0
     M_DUPCLF = val(left(str(M_DUPFOR, 7, 0), 5) + str(99, 2, 0))
  endif

  select AFOR00

  if !dbseek(str(M_DUPFOR, 7, 0))
    msg("* * * FORNECEDOR NAO CADASTRADO * * *")
    return .f.
  endif

  setcolor("I")
    @ 05, 15 say pad(FORNOM, 39)
    @ 05, 45 say pad(FORTEL, 15)
    @ 05, 67 say FOREST
  setcolor("")

return .t. 

*****************
function VERBCP04
*****************

  select ALCP00

  M_LANDTM = ctod("  /  /  ")

  dbsetorder(2)

  dbseek(str(M_DUPMAT[SQ, 10], 2, 0) + str(M_DUPMAT[SQ, 1], 6, 0) + str(M_DUPMAT[SQ, 2], 2, 0), .t.)

  do while !eof()
 
     if !str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) == str(M_DUPMAT[SQ, 10], 2, 0) + str(M_DUPMAT[SQ, 1], 6, 0) + str(M_DUPMAT[SQ, 2], 2, 0)        
       exit
     endif

     if LANHIS < 200
       M_LANDTM = LANDTM
     endif

     skip
 
  enddo

  dbsetorder(1)

  if empty(M_LANDTM)
    M_LANDTM = M_DUPMAT[SQ, 4]
  endif  

  if M_DUPMAT[SQ, 4] > M_LANDTM
    M_LANDTM = M_DUPMAT[SQ, 4]
  endif  

  if (M_LANDTM - M_DUPCOR) < 0
    M_DUPMAT[SQ, 9] = (M_DUPMAT[SQ, 5]+M_DUPMAT[SQ, 7]+M_DUPMAT[SQ, 8]) + (((M_DUPMAT[SQ, 5]+M_DUPMAT[SQ, 7]+M_DUPMAT[SQ, 8]) * .01) * ((M_DUPMAT[SQ, 6]/30) * abs((M_LANDTM - M_DUPCOR))))
  else
    M_DUPMAT[SQ, 9] = M_DUPMAT[SQ, 5] + M_DUPMAT[SQ, 7] + M_DUPMAT[SQ, 8]
  endif

  setcolor("I")
    @ LN, 64 say transform(M_DUPMAT[SQ, 9],"@E ##,###.##") 
  setcolor("")  

return .t.

*****************
function VERBCP05
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

  select ADCP00

  dbsetorder(1)

  if !dbseek(str(M_DUPMAT[SQ, 10], 2, 0) + str(M_DUPMAT[SQ, 1], 6, 0) + str(M_DUPMAT[SQ, 2], 2, 0))
    msg("* * * TITULO NAO INCLUIDO * * *")
    return .f.
  endif

  if DUPFOR != M_DUPFOR
    msg("* * * DUPLICATA NAO PERTENCE AO FORNECEDOR * * *")
    return .f.
  endif

  M_DUPMAT[SQ, 3] = DUPDTE
  M_DUPMAT[SQ, 4] = DUPVCT
  M_DUPMAT[SQ, 5] = DUPVLA
  M_DUPMAT[SQ, 6] = DUPTXD
  M_DUPMAT[SQ, 7] = 0
  M_DUPMAT[SQ, 8] = 0
  M_DUPMAT[SQ, 9] = juros_bcpx(M_DUPMAT[SQ, 5] ,  M_DUPMAT[SQ, 7] , M_DUPMAT[SQ, 8])
  M_DUPMAT[SQ,10] = DUPEMP
  M_DUPMAT[SQ,11] = DUPVCT
  M_DUPMAT[SQ,12] = DUPBOL

  setcolor("I")
    @ LN, 13 say left(dtoc(M_DUPMAT[SQ, 3]), 5)
    @ LN, 19 say left(dtoc(M_DUPMAT[SQ, 4]), 5) 
    @ LN, 25 say str (M_DUPMAT[SQ, 4]-M_DUPCOR, 5)
    @ LN, 31 say transform(M_DUPMAT[SQ, 5],"##,###.##") 
    @ LN, 40 say transform(M_DUPMAT[SQ, 6],"##.##") 
  setcolor("")  

return .t.


***************** 
function VERBCP07 
***************** 

  if lastkey() = 5
     return .t.
  endif

  if empty(M_BAIDTM)
    msg("* * * DATA DA BAIXA NAO PODE SER ZEROS * * *")
    return .f.
  endif

return .t. 
*///////
***************** 
function VERBCP08 
***************** 

if lastkey() = 5
  return .t.
endif

if !str((M_BAIVAL + M_BAIDSC), 12, 2) == str(ADCP00->DUPVLA, 12, 2)
  msg("* * * VALOR DA BAIXA NAO BATE COM VALOR DA DUPLICATA * * *")
  return .f.
endif

return .t. 


***************** 
function VERBCP10 
***************** 

if lastkey() = 5
  return .t.
endif

if empty(M_BAIDTM)
  msg("* * * DATA DA BAIXA INVALIDA * * *")
  return .f.
endif

return .t. 


****************
function TLBCP01
****************

 nbox(07, 13, 18, 66,"W/W+",.t.)
 setcolor("B/W")
  @ 08, 14 say     "Duplicata :       /   Fornecedor:                   "
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
function TLBCP02                       && tela baixa por grupo
****************

 nbox(03, 02, 20, 76,"W/W+",.t.)
 setcolor("B/W")
  @ 04, 03 say     " Fornec  :         a                                     Data:           "
  @ 05, 03 say     " Nome    :                         Fone:                   Uf:           "
  @ 06, 03 say     "ÄÄÄÄÄÄÂÄÄÂÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄ"
  @ 07, 03 say     "T¡tulo³Or³ Dte ³ Vct ³Prazo³ Valor  ³Taxa ³Cart¢rio³Diversas³  Total  ³Em"
  @ 08, 03 say     "ÄÄÄÄÄÄÅÄÄÅÄÄÄÄÄÅÄÄÄÄÄÅÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄ"
  @ 09, 03 say     "      ³  ³     ³     ³     ³        ³     ³        ³        ³         ³  "
  @ 10, 03 say     "      ³  ³     ³     ³     ³        ³     ³        ³        ³         ³  "
  @ 11, 03 say     "      ³  ³     ³     ³     ³        ³     ³        ³        ³         ³  "
  @ 12, 03 say     "      ³  ³     ³     ³     ³        ³     ³        ³        ³         ³  "
  @ 13, 03 say     "      ³  ³     ³     ³     ³        ³     ³        ³        ³         ³  "
  @ 14, 03 say     "      ³  ³     ³     ³     ³        ³     ³        ³        ³         ³  "
  @ 15, 03 say     "      ³  ³     ³     ³     ³        ³     ³        ³        ³         ³  "
  @ 16, 03 say     "      ³  ³     ³     ³     ³        ³     ³        ³        ³         ³  "
  @ 17, 03 say     "      ³  ³     ³     ³     ³        ³     ³        ³        ³         ³  "
  @ 18, 03 say     "ÄÄÄÄÄÄÁÄÄÁÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄ"
  @ 19, 03 say     " Vencto:          Boleto:                            Totais:             "
set color to

return "" 

**************** 
function MSBCP01
**************** 

 setcolor("N/W*")
  @ 08, 26 say DUPNUM picture "######"
  @ 08, 33 say DUPORD picture "##"
  @ 08, 45 say DUPBOL picture "#######"
  @ 08, 60 say DUPPOR picture "#####"

  @ 09, 26 say DUPDTE
  @ 09, 45 say DUPFOR picture "#######"
  @ 09, 60 say DUPCPG picture "#####"

  @ 10, 26 say DUPVCT
  @ 10, 45 say pad(FORNOM, 21)

  @ 11, 26 say DUPDTP
  @ 11, 45 say DUPVLA picture "@E ###,###,###.##"

  @ 13, 26 say DUPOBS
  @ 14, 26 say DUPOBT
set color to 

return ""

**************** 
function MSBCP02
**************** 

parameters SQ,R

 setcolor("N/W*")
      for S = SQ to len(M_DUPMAT)
        @ R, 03 say M_DUPMAT[S, 1] picture "######"     
        @ R, 10 say M_DUPMAT[S, 2] picture "##"   
        @ R, 13 say left(dtoc(M_DUPMAT[S, 3]), 5)
        @ R, 19 say left(dtoc(M_DUPMAT[S, 4]), 5) 
        @ R, 25 say str(iif(empty(M_DUPMAT[S, 4]),M_DUPCOR,M_DUPMAT[S, 4])-M_DUPCOR, 5)
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
function LPBCP01
**************** 

 setcolor("N/W*")
    for K = 09 to 17
      @ K, 02 say "³      ³  ³     ³     ³     ³        ³     ³        ³        ³         ³  ³"
    next
  setcolor("")

return ""

****************
functio CABBCP01
****************

  store PG + 1 to PG

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"RELACAO DE TITULOS EM DEBITO","",132) 
  ?
  ? "Cliente      : " +  AFOR00->FORNOM + " " + str(AFOR00->FORCOD, 7, 0)
  ? "Endereco     : " +  AFOR00->FOREND
  ? "Municipio    : " +  AFOR00->FORCEP +  " " + AFOR00->FORMUN + " " + AFOR00->FOREST
  ? "Telefone     : " +  AFOR00->FORTEL
  ? "Corrigido ate: " + dtoc(M_DUPCOR)
  ?
  ? 
  ? "   TITULO    EMISSAO   VENCTO  PRAZO BANCO NOME          PROP       TITULO     % TXD    JUROS     CARTORIO   DIVERSAS     TOTAL Em"
  ? 
*     999999/99-3 99/99/99 99/99/99 99999 99999 XXXXXXXXXXX 99999.99 X ###,###.## ##.## ###.###,## ###,###.## ###,###.## ####,###.## 99

     store 11 to LN

return ""

******************
functio LAN_FLXBCP
******************

*
** Lanca valor da baixa
*

  if APLX00->(dbseek(str(ADCP00->DUPEMP, 2, 0) + str(ADCP00->DUPAPL, 3, 0)))
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
        replace LAXAPL with ADCP00->DUPAPL
        replace LAXDTA with M_BAIDTM
        replace LAXSEQ with M_LAXSEQ 
        replace LAXVLR with M_BAIVAL  
        replace LAXHIS with "REF PAG " + alltrim(M_BAIOBS) + " " + alltrim(str(M_BAINUM, 6, 0) + "/" + str(M_BAIORD, 2, 0)) + " " + alltrim(ADCP00->DUPNOM)
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
  if APLX00->(dbseek(str(ME_EMP, 2, 0) + str(AMOV00P->MOVPJU, 3, 0)))
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
        replace LAXAPL with AMOV00P->MOVRJU
        replace LAXDTA with M_BAIDTM
        replace LAXSEQ with M_LAXSEQ 
        replace LAXVLR with M_BAIJUR
        replace LAXHIS with "REF JUR " + alltrim(M_BAIOBS) + " " + alltrim(str(M_BAINUM, 6, 0) + "/" + str(M_BAIORD, 2, 0)) + " "  + alltrim(ADCP00->DUPNOM)
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
  if APLX00->(dbseek(str(ME_EMP, 2, 0) + str(AMOV00P->MOVPTX, 3, 0)))
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
        replace LAXAPL with AMOV00P->MOVRTX
        replace LAXDTA with M_BAIDTM
        replace LAXSEQ with M_LAXSEQ 
        replace LAXVLR with M_BAITAX
        replace LAXHIS with "REF TAX " + alltrim(M_BAIOBS) + " " + alltrim(str(M_BAINUM, 6, 0) + "/" + str(M_BAIORD, 2, 0)) + " " + alltrim(ADCP00->DUPNOM)
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

*/
******************
functio LAN_FLXACP
******************

*
** Lanca valor da baixa
*

  if APLX00->(dbseek(str(M_DUPMAT[SQ, 10], 2, 0) + str(ADCP00->DUPAPL, 3, 0)))
    select ALAX00                   && seleciona fluxo de caixa
    M_LAXSEQ = 1
    do while .t.
      if dbseek(str(M_DUPMAT[SQ, 10], 2, 0) + dtos(M_DUPCOR) + str(M_LAXSEQ, 6, 0))   
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
        replace LAXEMP with M_DUPMAT[SQ, 10]
        replace LAXDTA with M_DUPCOR
        replace LAXSEQ with M_LAXSEQ 
        replace LAXVLR with ADCP00->DUPVLA
        replace LAXHIS with "REF PAG " + alltrim(str(ADCP00->DUPNUM, 6, 0) + "/" + str(ADCP00->DUPORD, 2, 0)) + " " + alltrim(ADCP00->DUPNOM)
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

if M_DUPMAT[SQ, 7] > 0 
  if APLX00->(dbseek(str(M_DUPMAT[SQ, 10], 2, 0) + str(AMOV00P->MOVPJU, 3, 0)))
    select ALAX00                   && seleciona fluxo de caixa
    M_LAXSEQ = 1
    do while .t.
      if dbseek(str(M_DUPMAT[SQ, 10], 2, 0) + dtos(M_DUPCOR) + str(M_LAXSEQ, 6, 0))   
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
        replace LAXEMP with M_DUPMAT[SQ, 10]
        replace LAXAPL with AMOV00P->MOVRJU
        replace LAXDTA with M_DUPCOR
        replace LAXSEQ with M_LAXSEQ 
        replace LAXVLR with M_DUPMAT[SQ, 7]
        replace LAXHIS with "REF JUR " + " " + alltrim(str(ADCP00->DUPNUM, 6, 0) + "/" + str(ADCP00->DUPORD, 2, 0)) + " " + alltrim(ADCP00->DUPNOM)
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

if M_DUPMAT[SQ, 8] > 0 
  if APLX00->(dbseek(str(M_DUPMAT[SQ, 10], 2, 0) + str(AMOV00P->MOVPTX, 3, 0)))
    select ALAX00                   && seleciona fluxo de caixa
    M_LAXSEQ = 1
    do while .t.
      if dbseek(str(M_DUPMAT[SQ, 10], 2, 0) + dtos(M_DUPCOR) + str(M_LAXSEQ, 6, 0))   
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
        replace LAXEMP with M_DUPMAT[SQ, 10]
        replace LAXAPL with AMOV00P->MOVRTX
        replace LAXDTA with M_DUPCOR
        replace LAXSEQ with M_LAXSEQ 
        replace LAXVLR with M_DUPMAT[SQ, 8]
        replace LAXHIS with "REF TAX " + " " + alltrim(str(ADCP00->DUPNUM, 6, 0) + "/" + str(ADCP00->DUPORD, 2, 0)) + " " + alltrim(ADCP00->DUPNOM)
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

*******************
function JUROS_BCPX
*******************

parameters M_DUPVLA,M_DUPCAR,M_DUPDIV

select ALCP00

M_LANDTM = ctod("  /  /  ")

dbsetorder(2)

dbseek(str(ADCP00->DUPEMP, 2, 0) + str(ADCP00->DUPNUM, 6, 0) + str(ADCP00->DUPORD, 2, 0), .t.)

do while !eof()

   if !str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) == str(ADCP00->DUPEMP, 2, 0) + str(ADCP00->DUPNUM, 6, 0) + str(ADCP00->DUPORD, 2, 0)        
     exit
   endif

   if LANHIS < 200
     M_LANDTM = LANDTM
   endif

   skip

enddo

dbsetorder(1)

if empty(M_LANDTM)
  M_LANDTM = ADCP00->DUPVCT
endif  

if ADCP00->DUPVCT > M_LANDTM
  M_LANDTM = ADCP00->DUPVCT
endif  

if (M_LANDTM - date()) < 0
  M_VALOR = (M_DUPVLA+M_DUPCAR+M_DUPDIV) + (((M_DUPVLA+M_DUPCAR+M_DUPDIV) * .01) * ((ADCP00->DUPTXD/30) * abs((M_LANDTM - date()))))
else
  M_VALOR = (M_DUPVLA+M_DUPCAR+M_DUPDIV)
endif

select ADCP00

return M_VALOR

*****************
function BAIBCP_C                     && funcao de lista baixa 
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

 nbox(09, 34, 13, 60,"W/W+",.t.)
 setcolor("B/W")
        @ 10, 35 say "Periodo Inicial:         "
        @ 11, 35 say "          Final:         "
        @ 12, 35 say "Numero Copias  :         "
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

  select ABCP00

  do while M_CON <= M_COP 

   store 0  to PG, M_TOTAL 

   select ABCP00 

   set softseek on
     seek str(ME_EMP, 2, 0) + dtos(ctod("01/01/80")) + str(0, 6, 0) + str(00, 2, 0)
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
     ? "* DATA   * DUPLIC  * COD   * FORNECEDOR               * CIDADE        *UF*EMISSAO * VCTO   * PAGTO  * VLR ORIGINAL * VLR PAGO    *T*"
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

              ADCP00->(dbseek(str(ABCP00->BAIEMP, 2, 0) + str(ABCP00->BAINUM, 6, 0) + str(ABCP00->BAIORD, 2, 0)))
              AFOR00->(dbseek(str(ADCP00->DUPFOR, 7, 0)))

              ? " " 
                ??  BAIDTM
                ?? " " 
                ?? ADCP00->DUPNUM 
                ?? "/" 
                ?? ADCP00->DUPORD 
                ?? " "
                ?? ADCP00->DUPFOR 
                ?? " "
                ?? left(AFOR00->FORNOM, 26)
                ?? " "
                ?? left(AFOR00->FORMUN, 15) 
                ?? " "
                ?? AFOR00->FOREST
                ?? " "
                ?? ADCP00->DUPDTE
                ?? " "
                ?? ADCP00->DUPVCT
                ?? " "
                ?? ADCP00->DUPDTP
                ?? " "
                ?? transform(ADCP00->DUPVLO, "@E ###,###,###.##")
                ?? " "
                ?? transform((ADCP00->DUPVLP + ADCP00->DUPTAX + ADCP00->DUPJUR),"@E ##,###,###.##") 
                ?? " "
                ?? BAISIT

                  if ADCP00->DUPJUR > 0
                     ? space(105) 
                     ?? "JUROS....." 
                     ?? transform(ADCP00->DUPJUR, "@E ###,###,###.##")
                     LN = LN + 1 
                  endif 

                  if ADCP00->DUPDSC > 0
                     ? space(105) 
                     ?? "DESC......" 
                     ?? transform(ADCP00->DUPDSC, "@E ###,###,###.##")
                     LN = LN + 1 
                  endif 

                  if ADCP00->DUPTAX > 0
                     ? space(105) 
                     ?? "TAXAS....." 
                     ?? transform(ADCP00->DUPTAX, "@E ###,###,###.##")
                     LN = LN + 1 
                  endif 

                M_TOTAL = M_TOTAL + ADCP00->DUPVLP

                select ABCP00

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

    eject

    M_CON = M_CON + 1 

  enddo

desliga1()

    M_OPC = deciden("Limpa arquivo de baixas")

    if M_OPC != 1
      select ABCP00
      set relation to
      return ""
    endif 
   
    select ABCP00
 
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
         msg("* * * (ABCP00) REGISTRO SENDO USADO * * *")
       endif  
       if lastkey() = 17
         exit
       endif 
     enddo

 enddo

msg("* * * BAIXAS ELIMINADAS * * *") 

return "" 
