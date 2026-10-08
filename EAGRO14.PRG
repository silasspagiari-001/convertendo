#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)
#INCLUDE "ptmenu.ch"

#command @ <row> , <col>  GET <var> [<clauses,...>] F2 [<moreClauses,...>] funcao <func> retorno <Variavel>;
=>       @ <row> , <col>  GET <var> [<clauses>] SEND reader := {|oGet| Getf2(oGet,<func>,<Variavel>) } [<moreClauses>]


***************
function MANKAR
***************

parameters M_OPC,M_OPC1,M_OPC2

local aBlocks := {}
local aLastPaint

aAdd( aBlocks, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
aLastPaint := WvtSetBlocks( aBlocks )

_FUNCLI_ = "KARDEX.t."
_FUNPRO_ = "KARDEX.t."
_FUNVEN_ = "KARDEX.f."
_FUNCPG_ = "KARDEX.f."
_FUNTRA_ = "KARDEX.f."


  rodape("MENU","KARDEX",M_FAN,"EAGRO14","Mem: " + str(memory(0), 5),M_EMP)

*  @ 05, 10 prompt "Inclus?o " HIGHLITE R/BG SENHA 63
*  @ 06, 10 prompt "Altera??o" HIGHLITE R/BG SENHA 64
*  @ 07, 10 prompt "Consulta " HIGHLITE R/BG SENHA 65
*  @ 08, 10 prompt "Exclus?o " HIGHLITE R/BG SENHA 66
*  @ 09, 10 prompt "Listagem " HIGHLITE R/BG SENHA 67
*  @ 10, 10 prompt "Outros   " HIGHLITE R/BG SENHA 68

  do case
  case M_OPC = 1 ; inckar()
  case M_OPC = 2 ; altkar()
  case M_OPC = 3 ; conkar(M_OPC1)
  case M_OPC = 4 ; exckar()
  case M_OPC = 5 ; liskar(M_OPC1)
  case M_OPC = 6 ; prokar(M_OPC1)
  endcase

return ""

***************
function INCKAR                        && inclui kardex
***************

set key -9 to CALCULA()

M_KARDTA = date()
M_KARFISN = space(5)
M_KARDOC = 1
M_KARSEQ = 1
M_KARCLF = 1

do while .t.

  tlkar01()

  keyfun()

  rodape("INCLUI","KARDEX",M_FAN,"EAGRO14","Mem: " + str(memory(0), 5),M_EMP)

  M_KAREMP = ME_EMP
  M_KARMAT = 0

  @ 09, 25 get M_KARMAT F2 picture "######" color _F2_ funcao "sele_arquivo('APCA00')" retorno @M_KARMAT
  read

  if M_KARMAT = 0
    exit
  endif

  if !BUSCAREGISTRO("APCA00",1,{str(M_KARMAT,6,0)},"SELECT")
    msg("* * * PRODUTO N?O CADASTRADO * * *")
    loop
  endif

  if !BUSCAREGISTRO("ASLD00",1,{str(M_KAREMP, 2, 0),str(M_KARMAT, 6, 0)},"SELECT")
    cria_sld_kar()               && se saldo nao existir cria
  endif

  set color to I
  @ 09, 25 say str(M_KARMAT, 6, 0) picture "@R 99999-9"
  @ 09, 53 say SLDDIS picture "##########"
  @ 10, 25 say pad(APCA00->PCADES, 35)
  set color to

  do while .t.

    M_KARVLI = 0
    M_KARQDE = -1
    M_KARUNI = 0
    M_KARICM = 0
    M_KARIPI = 0
    M_KARDSP = 0

    M_KARREC = space(10)

    lpkar01()

    SetColor( 'N/W,N/GR*,,,N/W*' )
    @ 12, 26 get     M_KARDTA                    valid(M_KARDTA != ctod("  /  /  "))
    @ 12, 53 get     M_KARFISN picture "9.999"   valid vekar2()
    @ 13, 26 get     M_KARDOC  picture "######"  valid(M_KARDOC > 0)
    @ 13, 53 get     M_KARSEQ  picture "###"      valid(M_KARSEQ > 0)
    read

    if lastkey() = 27
      exit
    endif

    grkar01("SELECT")  // somente consulta

    if !eof()
      msg("* * * (AKAR00) MOVIMENTO JA CADASTRADO * * *")
      loop
    endif

    edkar01()

    if lastkey() = 27
      msg("* * * MOVIMENTO N?O INCLUIDO * * *")
      loop
    endif

    grkar01("INSERT")              && grava do registro

    msg("* * * MOVIMENTO INCLUIDO * * *")

  enddo

enddo


return ""

***************
function ALTKAR                        && altera kardex
***************

set key -9 to CALCULA()

do while .t.

  tlkar01()

  rodape("ALTERA","KARDEX",M_FAN,"EAGRO14","Mem: " + str(memory(0), 5),M_EMP)

  M_KAREMP = ME_EMP
  M_KARMAT = 0

  @ 09, 25 get M_KARMAT F2 picture "######" color "W+/G,N/GR*"  funcao "sele_arquivo('APCA00')" retorno @M_KARMAT
  read

  if M_KARMAT = 0
    exit
  endif

  if !BUSCAREGISTRO("APCA00",1,{str(M_KARMAT,6,0)},"SELECT")
    msg("* * * PRODUTO N?O CADASTRADO * * *")
    loop
  endif

  if !BUSCAREGISTRO("ASLD00",1,{str(M_KAREMP, 2, 0),str(M_KARMAT, 6, 0)},"SELECT")
    cria_sld_kar()               && se saldo nao existir cria
  endif

  set color to I
  @ 09, 25 say str(M_KARMAT, 6, 0) picture "@R 99999-9"
  @ 09, 53 say SLDDIS picture "##########"
  @ 10, 25 say pad(APCA00->PCADES, 35)
  set color to

  do while .t.

    M_KARDTA = ctod("  /  /  ")
    M_KARFISN = space(5)
    M_KARDOC = 0
    M_KARSEQ = 1

    lpkar01()

    SetColor( 'N/W,N/GR*,,,N/W*' )
    @ 12, 26 get     M_KARDTA                    valid(M_KARDTA != ctod("  /  /  "))
    @ 12, 53 get     M_KARFISN  picture "9.999"  valid vekar2()
    @ 13, 26 get     M_KARDOC  picture "######"  valid(M_KARDOC > 0)
    @ 13, 53 get     M_KARSEQ  picture "###"      valid(M_KARSEQ > 0)
    read

    if lastkey() = 27
      exit
    endif

    grkar01("SELECT")  // somente consulta

    if eof()
      msg("* * * (AKAR00) MOVIMENTO N?O CADASTRADO * * *")
      loop
    endif

    set escape off         && bloqueia o ESC

    M_KAREMP = KAREMP
    M_KARMAT = KARMAT
    M_KARDTA = KARDTA
    M_KARFISN = KARFISN
    M_KARDOC = KARDOC
    M_KARSEQ = KARSEQ
    M_KARQDE = KARQDE
    M_KARVLI = 0
    if KARQDE > 0
      M_KARUNI = (KARVLI/KARQDE)
    else
      M_KARUNI  = 0
    endif
    M_KARICM = KARICM
    M_KARIPI = KARIPI
    M_KARDSP = KARDSP
    M_KARCLF = KARCLF
    M_KARREC = KARREC

    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"ASLD00","UPDATE"}
    aadd(sqlCHAVE,{"SLDEMP",str(M_KAREMP,2)})
    aadd(sqlCHAVE,{"SLDMAT",str(M_KARMAT,6)})

    if AFIS00->FISEST = "C"
      aadd(sqlCAMPO,{"SLDDIS","SLDDIS - " + str1(M_KARQDE,2),.f.})
    else
      if AFIS00->FISEST = "D"
        aadd(sqlCAMPO,{"SLDDIS","SLDDIS + " + str1(M_KARQDE,2),.f.})
      endif
    endif
    executasql()

    edkar02()

    grkar01("UPDATE")             && grava o registro kardex

    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"ASLD00","UPDATE"}
    aadd(sqlCHAVE,{"SLDEMP",str(M_KAREMP,2)})
    aadd(sqlCHAVE,{"SLDMAT",str(M_KARMAT,6)})

    if AFIS00->FISEST = "C"
      aadd(sqlCAMPO,{"SLDDIS","SLDDIS + " + str1(M_KARQDE,2),.f.})
    else
      if AFIS00->FISEST = "D"
        aadd(sqlCAMPO,{"SLDDIS","SLDDIS - " + str1(M_KARQDE,2),.f.})
      endif
    endif
    executasql()

    set escape on

    msg("* * * MOVIMENTO ALTERADO * * *")

  enddo

enddo

return ""

***************
function CONKAR                    && consulta kardex
***************
parameters M_OPC

  rodape("CONSULTA","KARDEX",M_FAN,"EAGRO14","Mem: " + str(memory(0), 5),M_EMP)

*  @ 09, 15 prompt "Produto  " HIGHLITE R/BG SENHA 70
*  @ 10, 15 prompt "Movimento" HIGHLITE R/BG SENHA 69
*  @ 11, 15 prompt "Cliente  " HIGHLITE R/BG SENHA 71
*  @ 12, 15 prompt "Anual    " HIGHLITE R/BG SENHA 72
*  @ 13, 15 prompt "Gr?fico  " HIGHLITE R/BG SENHA 73
*  @ 14, 15 prompt "Gr?fiCli " HIGHLITE R/BG SENHA 74

  do case
  case M_OPC = 1
    conkar_bb()
  case M_OPC = 2
    conkar_a()
  case M_OPC = 3
    conkar_c()
  case M_OPC = 4
*    conkar_d()
  case M_OPC = 5
*    conkar_e()
  case M_OPC = 6
*    conkar_f()
  endcase

return ""

*****************
function CONKAR_A                      && consulta kardex
*****************

do while .t.

  tlkar01()

  rodape("CONSULTA","MOVIMENTO",M_FAN,"EAGRO14","Mem: " + str(memory(0), 5),M_EMP)

  M_KAREMP = ME_EMP
  M_KARMAT = 0

  @ 09, 25 get M_KARMAT F2 picture "######" color _COREDICAO_ funcao "sele_arquivo('APCA00')" retorno @M_KARMAT
  read

  if M_KARMAT = 0
    exit
  endif

  if !BUSCAREGISTRO("APCA00",1,{str(M_KARMAT,6,0)},"SELECT")
    msg("* * * PRODUTO N?O CADASTRADO * * *")
    loop
  endif

  if !BUSCAREGISTRO("ASLD00",1,{str(M_KAREMP, 2, 0),str(M_KARMAT, 6, 0)},"SELECT")
    cria_sld_kar()               && se saldo nao existir cria
  endif

  set color to I
  @ 09, 25 say str(M_KARMAT, 6, 0) picture "@R 99999-9"
  @ 09, 53 say SLDDIS picture "##########"
  @ 10, 25 say pad(APCA00->PCADES, 35)
  set color to

  do while .t.

    M_KARDTA = ctod("  /  /  ")
    M_KARFISN = "     "
    M_KARDOC = 0
    M_KARSEQ = 1

    lpkar01()

    @ 12, 26 get     M_KARDTA                    valid(M_KARDTA != ctod("  /  /  "))
    @ 12, 53 get     M_KARFISN  picture "9.999"  valid vekar2()
    @ 13, 26 get     M_KARDOC  picture "######"  valid(M_KARDOC > 0)
    @ 13, 53 get     M_KARSEQ  picture "###"      valid(M_KARSEQ > 0)
    read

    if lastkey() = 27
      exit
    endif

    grkar01("SELECT")  // somente consulta

    if eof()
      msg("* * * (AKAR00) MOVIMENTO N?O CADASTRADO * * *")
      loop
    endif

    mskar02()

    waitstate()

  enddo

enddo


return ""

*****************
function CONKAR_B
*****************

private L         ,;
M_TELA

set key -9 to CALCULA()

M_TELA = savescreen(04, 02, 21, 78)

do while .t.

  rodape("PRODUTO", "KARDEX",M_FAN,"EAGRO14", "Mem: " + str(memory(0), 5), M_EMP)

  tlkar02()

  keyfun()

  store 0 to  M_SLD   ,;
  M_KARMAT,;
  M_SLDVLR

  store space(30) to M_PCANOM

  M_DATA1 = firstday(date())
  M_DATA2 = lastday(date())

  store 10 to L

  @ 05, 15 get M_KARMAT F2 picture "######" color _COREDICAO_ funcao "sele_arquivo('APCA00')" retorno @M_KARMAT
  read

  if M_KARMAT = 0 .or. lastkey() = 27
    exit
  endif

  @ 05, 33 get M_DATA1
  @ 05, 44 get M_DATA2
  read

  if lastkey() = 27
    loop
  endif

  if !BUSCAREGISTRO("APCA00",1,{str(M_KARMAT,6,0)},"SELECT")
    msg("* * * PRODUTO N?O CADASTRADO * * *")
    loop
  endif

  if !BUSCAREGISTRO("ASLD00",1,{str(ME_EMP, 2, 0),str(M_KARMAT, 6, 0)},"SELECT")
    cria_sld_kar()               && se saldo nao existir cria
  endif

  set color to I
  @ 05, 15 say     str(PCAMAT, 6, 0) picture "@R 99999-9"
  @ 05, 61 say     ASLD00->SLDDIS      picture "#####.###"
  @ 06, 15 say     pad(PCADES, 30)
  @ 06, 61 say     ASLD00->SLDPRC              picture "@E ###,###,###.##"
  set color to

  M_SLD    = 0
  M_SLDCME = 0
  M_SLDFIN = 0

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,"AKAR00")
  aadd(sqlCAMPO,"KARMAT")
  aadd(sqlCAMPO,"KARQDE")
  aadd(sqlCAMPO,"KARVLI")
  aadd(sqlCAMPO,"KARFISN")
  aadd(sqlCAMPO,"AFIS00.FISEST")
  aadd(sqlCAMPO,"AFIS00.FISMED")
  aadd(sqlRELATION,{"ASLD00",str(ME_EMP, 2, 0),"ASLD00.SLDEMP"})
  aadd(sqlRELATION,{"","ASLD00.SLDMAT","AKAR00.KARMAT"})
  aadd(sqlCHAVE,"KARDTA < " + aspas(formatdta(M_DATA1)))
  aadd(sqlCHAVE,"KAREMP = " + str(ME_EMP, 2, 0))
  aadd(sqlCHAVE,"KARMAT = " + str(APCA00->PCAMAT, 6, 0))
  aadd(sqlORDEM,"KARDTA,KARFISN")
  sqlrelation()

  do while !eof()
    if KARFISN = "1.000"
      M_SLD    = KARQDE
      if KARQDE > 0                  && se quantidade igual zero
        M_SLDCME = (KARVLI / KARQDE)
      endif
      M_SLDFIN = KARVLI
    else
      if FISEST = "D"
        M_SLD = M_SLD - KARQDE
        if FISMED = "S"
          M_SLDFIN = (M_SLDFIN - (M_SLDCME * KARQDE))
        endif
      else
        if FISEST = "C"
          M_SLDFIN = M_SLDFIN + (KARVLI + KARDSP + KARIPI)
          M_SLD = (M_SLD + KARQDE)
          if M_SLD > 0                  && se quantidade igual zero
            if FISMED = "S"
              M_SLDCME = (M_SLDFIN / M_SLD)
            endif
          endif
        endif
      endif
    endif
    skip
  enddo

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,"AKAR00")
  aadd(sqlCAMPO,"KARMAT")
  aadd(sqlCAMPO,"KARQDE")
  aadd(sqlCAMPO,"KARVLI")
  aadd(sqlCAMPO,"KARFISN")
  aadd(sqlCAMPO,"KARDTA")
  aadd(sqlCAMPO,"KARDOC")
  aadd(sqlCAMPO,"KARSEQ")
  aadd(sqlCAMPO,"AFIS00.FISNOM")
  aadd(sqlCAMPO,"AFIS00.FISEST")
  aadd(sqlCAMPO,"AFIS00.FISMED")
  aadd(sqlRELATION,{"ASLD00",str(ME_EMP, 2, 0),"ASLD00.SLDEMP"})
  aadd(sqlRELATION,{"","ASLD00.SLDMAT","AKAR00.KARMAT"})
  aadd(sqlCHAVE,"KARDTA BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
  aadd(sqlCHAVE,"KAREMP = " + str(ME_EMP, 2, 0))
  aadd(sqlCHAVE,"KARMAT = " + str(APCA00->PCAMAT, 6, 0))
  aadd(sqlORDEM,"KARDTA,KARFISN")
  sqlrelation()

  do while !eof()
    if KARFISN = "1.000"
      M_SLD    = KARQDE
      if KARQDE > 0                  && se quantidade igual zero
        if FISMED = "S"
          M_SLDCME = (KARVLI / KARQDE)
        endif
      endif
      M_SLDFIN = KARVLI
    else
      if FISEST = "D"
        M_SLD = M_SLD - KARQDE
        if FISMED = "S"
          M_SLDFIN = (M_SLDFIN - (M_SLDCME * KARQDE))
        endif
      else
        if FISEST = "C"
          M_SLDFIN = M_SLDFIN + (KARVLI + KARDSP + KARIPI)
          M_SLD = (M_SLD + KARQDE)
          if M_SLD > 0                  && se quantidade igual zero
            if FISMED = "S"
              M_SLDCME = (M_SLDFIN / M_SLD)
            endif
          endif
        endif
      endif
    endif

    set color to I
    @ L, 03 say left(dtoc(KARDTA),5)
    @ L, 09 say KARFISN                picture "9.999"
    @ L, 16 say left(FISNOM, 16)
    @ L, 33 say KARDOC                      picture "######"
    @ L, 40 say KARQDE                      picture "#####.###"
    @ L, 50 say M_SLD                       picture "#####.###"
    @ L, 60 say KARSEQ                      picture "###"
    if KARVLI > 0
      @ L, 63 say KARVLI picture "@E ###,###,###.##"
    else
      @ L, 63 say 0.00 picture "@E ###,###,###.##"
    endif
    set color to

    L = L + 1

    if L > 17
      msg("* * * (ENTER) Continua (ESC) Sai * * *")
      for K = 10 to 17
        set color to I
        @ K, 03 say     space(05)
        @ K, 09 say     space(06)
        @ K, 16 say     space(16)
        @ K, 33 say     space(06)
        @ K, 40 say     space(09)
        @ K, 50 say     space(09)
        @ K, 60 say     space(02)
        @ K, 63 say     space(14)
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
  @ 19, 20 say M_SLDCME picture "@E ###,###,###.##"
  set color to

  msg("* * * Tecle (ENTER) * * *")

enddo

restscreen(04, 02, 21, 78, M_TELA)

return ""

*****************
function CONKAR_C
*****************

return ""

private L         ,;
M_TELA

set key -9 to CALCULA()


do while .t.

  rodape("CONSULTA", "KARDEX",M_FAN,"EAGRO14", "Mem: " + str(memory(0), 5), M_EMP)

  tlkar03()

  keyfun()

  store 0 to  M_SLD   ,;
  M_KARMAT,;
  M_SLDVLR

  store space(30)   to M_PCANOM

  store ctod("01/" + substr(dtoc(date()), 4, 5)) to M_DATA1
  store date()                                   to M_DATA2

  store 10 to L
  @ 05, 15 get M_KARMAT F2 picture "######" color _COREDICAO_ funcao "sele_arquivo('APCA00')" retorno @M_KARMAT
  read

  if lastkey() = 27 .or. M_KARMAT = 0
    exit
  endif

  @ 05, 33 get M_DATA1
  @ 05, 44 get M_DATA2
  read

  select APCA00                       && procura descricao da peca

  set relation to str(ME_EMP, 2, 0) + str(PCAMAT, 6, 0) into ASLD00

  if M_KARMAT > 0
    if !_seek(str(M_KARMAT, 6, 0))
      msg("* * * PRODUTO N?O CADASTRADO * * *")
      loop
    endif
  else
    set order to 3
    set softseek on
    seek M_PCANOM
    set softseek off
  endif

  set order to 1

  set color to I
  @ 05, 15 say     str(PCAMAT, 6, 0) picture "@R 99999-9"
  @ 05, 61 say     ASLD00->SLDDIS      picture "#########"
  @ 06, 15 say     pad(PCADES, 30)
  @ 06, 61 say     ASLD00->SLDPRC              picture "@E ###,###,###.##"
  set color to

  select AKAR00

  set relation to str(1, 2, 0) + str(KARFIS, 5, 0) into AFIS00 ,;
  to str(KARCLF, 5, 0)                     into ACLI00

  set softseek on
  seek str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0)
  set softseek off

  if eof() .or. str(ME_EMP, 2, 0) + str(KARMAT, 6, 0) > str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0)
    msg("* * * PRODUTO SEM MOVIMENTO * * *")
    loop
  endif

  M_SLD    = 0
  M_SLDCME = 0
  M_SLDFIN = 0

  do while !eof()
    if str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) >= str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0) + dtos(M_DATA1)
      exit
    endif
    if KARFIS = 10000
      M_SLD    = KARQDE
      if KARQDE > 0                  && se quantidade igual zero
        if AFIS00->FISMED = "S"
          M_SLDCME = (KARVLI / KARQDE)
        endif
      endif
      M_SLDFIN = KARVLI
    else
      if AFIS00->FISEST = "D"
        M_SLD = M_SLD - KARQDE
        if AFIS00->FISMED = "S"
          M_SLDFIN = (M_SLDFIN - (M_SLDCME * KARQDE))
        endif
      else
        if AFIS00->FISEST = "C"
          M_SLDFIN = M_SLDFIN + (KARVLI + KARDSP + KARIPI)
          M_SLD = (M_SLD + KARQDE)
          if M_SLD > 0                  && se quantidade igual zero
            if AFIS00->FISMED = "S"
              M_SLDCME = (M_SLDFIN / M_SLD)
            endif
          endif
        endif
      endif
    endif
    skip
  enddo

  do while !eof()
    if !str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) == str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0)
      exit
    endif
    if str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) > str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0) + dtos(M_DATA2)
      exit
    endif
    if KARFIS = 10000
      M_SLD    = KARQDE
      if KARQDE > 0
        if AFIS00->FISMED = "S"
          M_SLDCME = (KARVLI / KARQDE)
        endif
      endif
      M_SLDFIN = KARVLI
    else
      if AFIS00->FISEST = "D"
        M_SLD = M_SLD - KARQDE
        if AFIS00->FISMED = "S"
          M_SLDFIN = (M_SLDFIN - (M_SLDCME * KARQDE))
        endif
      else
        if AFIS00->FISEST = "C"
          M_SLDFIN = M_SLDFIN + (KARVLI + KARDSP + KARIPI)
          M_SLD = (M_SLD + KARQDE)
          if M_SLD > 0                  && se quantidade igual zero
            if AFIS00->FISMED = "S"
              M_SLDCME = (M_SLDFIN / M_SLD)
            endif
          endif
        endif
      endif
    endif

    set color to I
    @ L, 03 say left(dtoc(KARDTA),5)
    @ L, 09 say     (KARFIS*.01) picture "###.##"
    @ L, 16 say     left(AFIS00->FISNOM, 20)
    @ L, 37 say     KARDOC       picture "######"
    @ L, 44 say     KARQDE       picture "#####.###"
    @ L, 54 say     left(ACLI00->CLINOM, 23)
    set color to

    L = L + 1

    if L > 17
      msg("* * * (RETURN) Continua (ESC) Sai * * *")
      for K = 10 to 17
        set color to I
        @ K, 03 say     space(05)
        @ K, 09 say     space(06)
        @ K, 16 say     space(20)
        @ K, 37 say     space(06)
        @ K, 44 say     space(09)
        @ K, 54 say     space(23)
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
  @ 19, 18 say M_SLDCME picture "@E ###,###,###.##"
  set color to

  msg("* * * Tecle (ENTER) * * *")

enddo

select AKAR00
set relation to
select APCA00
set relation to
set order to 1

return ""

*****************
function CONKAR_D                     && quantidade e dolarizado
*****************

abre_ano("10") && anual

private L         ,;
M_TELA

M_TELA = savescreen(04, 04, 21, 76)

do while .t.

  rodape("GRAFICO", "KARDEX",M_FAN, "EAGRO14","Mem: " + str(memory(0), 5),M_EMP)

  tlkar04()

  store 0           to M_SLD   ,;
  M_ANOMAT,;
  M_SLDVLR

  store space(15)    to M_ANOREF
  store year(date()) to M_ANONUM

  store 10 to L

  @ 05, 17 get      M_ANOMAT   picture "######"
  read

  if lastkey() = 27
    exit
  endif

  if M_ANOMAT = 0
    @ 05, 30 get      M_ANOREF
    read
    if empty(M_ANOREF)
      loop
    endif
    APCA00->(dbsetorder(5),dbseek(M_ANOREF,.t.))
  else
    APCA00->(dbseek(str(M_ANOMAT, 6, 0),.t.))
  endif

  @ 05, 51 get      M_ANONUM   picture "####"
  read

  if lastkey() = 27
    exit
  endif

  setas()

  select APCA00

  do while !eof()

    AANO00->(dbseek(str(ME_EMP, 2, 0) + str(M_ANONUM, 4, 0) + str(APCA00->PCAMAT, 6, 0)))

    ASLD00->(dbseek(str(AANO00->ANOEMP, 2, 0) + str(AANO00->ANOMAT, 6, 0)))

    set color to I
    @ 05, 17 say     str(APCA00->PCAMAT, 6, 0) picture "@R 99999-9"
    @ 05, 30 say     APCA00->PCAREF
    @ 05, 65 say     ASLD00->SLDDIS            picture "@E ######.###"
    @ 06, 17 say     pad(APCA00->PCADES, 40)
    set color to

    TOTAL = 0
    MESES = 0

    set color to I
    for R = 1 to 12
      M_MES  = strzero(R, 2, 0)
      @ R + 7, 23 say AANO00->ANOQDS&M_MES picture "@E@Z ##,###.##"
      @ R + 7, 56 say AANO00->ANOVLS&M_MES picture "@E@Z ###,###,###.##"
      if AANO00->ANOQDS&M_MES > 0
        TOTAL = TOTAL + AANO00->ANOQDS&M_MES
        MESES = MESES + 1
      endif
    next
    @ 06, 65 say TOTAL/MESES picture "@E ######.###"
    set color to

    inkey(0)

    if lastkey() = 27
      exit
    endif

    iif(lastkey()=5 ,dbskip(-1),"")
    iif(lastkey()=24,dbskip(+1),"")
    iif(eof(),dbgotop(),"")
    iif(bof(),dbgobottom(),"")

    set color to I
    @ 08, 17 clear to 19, 41
    @ 08, 45 clear to 19, 74
    set color to

  enddo

  APCA00->(dbsetorder(1) , setcursor(1))


enddo

restscreen(04, 04, 21, 76, M_TELA)

return ""

*****************
function CONKAR_E
*****************

private L         ,;
M_TELA

set key -9 to CALCULA()

M_TELA = savescreen(04, 04, 21, 76)

do while .t.

  rodape("GRAFICO", "KARDEX",M_FAN, "EAGRO14","Mem: " + str(memory(0), 5),M_EMP)

  tlkar05()

  keyfun()

  store 0           to M_SLD   ,;
  M_KARMAT,;
  M_SLDVLR

  store space(15)    to M_ANOREF
  store year(date()) to M_ANONUM

  store 10 to L

  @ 05, 17 get M_KARMAT F2 picture "######" color _COREDICAO_ funcao "sele_arquivo('APCA00')" retorno @M_KARMAT
  read

  if lastkey() = 27
    exit
  endif

  select APCA00

  dbseek(str(M_KARMAT, 6, 0),.t.)

  @ 05, 51 get      M_ANONUM   picture "####"
  read

  if lastkey() = 27
    exit
  endif

  setas()

  select APCA00

  do while !eof()

    AANO00->(dbseek(str(ME_EMP, 2, 0) + str(M_ANONUM, 4, 0) + str(APCA00->PCAMAT, 6, 0)))

    ASLD00->(dbseek(str(AANO00->ANOEMP, 2, 0) + str(AANO00->ANOMAT, 6, 0)))

    set color to I
    @ 05, 17 say     str(APCA00->PCAMAT, 6, 0) picture "@R 99999-9"
    @ 05, 30 say     APCA00->PCAREF
    @ 05, 65 say     ASLD00->SLDDIS            picture "@E ######.###"
    @ 06, 17 say     pad(APCA00->PCADES, 40)
    set color to

    MAIOR  = AANO00->ANOQDS01
    MENOR  = AANO00->ANOQDS01
    TAMMAX = 50
    TOTAL  = 0
    MESES  = 0

    for R = 1 to 12
      M_MES = strzero(R, 2, 0)
      MAIOR = max(MAIOR,AANO00->ANOQDS&M_MES)
      MENOR = min(MENOR,AANO00->ANOQDS&M_MES)
      if AANO00->ANOQDS&M_MES > 0
        TOTAL = TOTAL + AANO00->ANOQDS&M_MES
        MESES = MESES + 1
      endif
    next

    MEDIA = MAIOR - MENOR

    set color to GR+/W
    for R = 1 to 12
      M_MES  = strzero(R, 2, 0)
      if AANO00->ANOQDS&M_MES > 0
        VALMAX = ((AANO00->ANOQDS&M_MES - MENOR)/MEDIA * TAMMAX + 1)
      endif
      if AANO00->ANOQDS&M_MES > 0
        @ R + 7, 15 say replicate("?", VALMAX ) + "(" + str(int(AANO00->ANOQDS&M_MES)) + ")"
      endif
    next
    set color to I
    @ 06, 65 say TOTAL/MESES picture "@E ######.###"
    set color to

    inkey(0)

    if lastkey() = 27
      exit
    endif

    iif(lastkey()=5 ,dbskip(-1),"")
    iif(lastkey()=24,dbskip(+1),"")
    iif(eof(),dbgotop(),"")
    iif(bof(),dbgobottom(),"")

    set color to I
    @ 08, 15 clear to 19, 74
    set color to

  enddo

  APCA00->(dbsetorder(1) , setcursor(1))

enddo

set key -1 to
set key -2 to

restscreen(04, 04, 21, 76, M_TELA)

return ""

*****************
function CONKAR_F
*****************

msw("* * * AGUARDE... ABRINDO ARQUIVOS * * *")


private L         ,;
M_TELA

set key -9 to CALCULA()

M_TELA = savescreen(04, 04, 21, 76)

do while .t.

  rodape("GRAFICO", "KARDEX",M_FAN, "EAGRO14","Mem: " + str(memory(0), 5),M_EMP)

  tlkar06()

  keyfun()

  store 0           to M_SLD   ,;
  M_KARCLF,;
  M_SLDVLR

  store space(15)    to M_ANOREF
  store year(date()) to M_ANONUM

  store 10 to L

  @ 05, 17 get      M_KARCLF   picture "#####"
  read

  if lastkey() = 27
    exit
  endif

  select ACLI00
  dbseek(str(M_KARCLF, 5, 0),.t.)

  @ 05, 71 get M_ANONUM   picture "####"
  read

  if lastkey() = 27
    exit
  endif

  setas()

  select ACLI00

  do while !eof()

    do while !eof()
      if !CLITIP == "R"
        skip
        loop
      endif
      exit
    enddo

    AANOCL->(dbseek(str(ME_EMP, 2, 0) + str(M_ANONUM, 4, 0) + str(ACLI00->CLICOD, 5, 0)))

    set color to I
    @ 05, 17 say     ACLI00->CLICOD
    @ 05, 24 say     ACLI00->CLINOM
    @ 06, 17 say     pad(ACLI00->CLIMUN1, 40)
    set color to

    MAIOR  = AANOCL->ANOVLS01
    MENOR  = AANOCL->ANOVLS01
    TAMMAX = 45
    TOTAL  = 0
    MESES  = 0

    for R = 1 to 12
      M_MES = strzero(R, 2, 0)
      MAIOR = max(MAIOR,AANOCL->ANOVLS&M_MES)
      MENOR = min(MENOR,AANOCL->ANOVLS&M_MES)
      if AANOCL->ANOVLS&M_MES > 0
        TOTAL = TOTAL + AANOCL->ANOVLS&M_MES
        MESES = MESES + 1
      endif
    next

    MEDIA = MAIOR - MENOR

    set color to GR+/W
    for R = 1 to 12
      M_MES  = strzero(R, 2, 0)
      if AANOCL->ANOVLS&M_MES > 0
        VALMAX = ((AANOCL->ANOVLS&M_MES - MENOR)/MEDIA * TAMMAX + 1)
      endif
      if AANOCL->ANOVLS&M_MES > 0
        @ R + 7, 15 say replicate("?", VALMAX ) + "(" + str(AANOCL->ANOVLS&M_MES,10,2) + ")"
      endif
    next
    set color to I
    @ 06, 65 say TOTAL/MESES picture "@E ######.###"
    set color to

    inkey(0)

    if lastkey() = 27
      exit
    endif

    select ACLI00

    if lastkey()=5
      dbskip(-1)
      do while !bof()
        if !CLITIP == "R"
          skip-1
          loop
        endif
        exit
      enddo
    endif

    if lastkey()=24
      dbskip(+1)
      do while !eof()
        if !CLITIP == "R"
          skip
          loop
        endif
        exit
      enddo
    endif

    iif(eof(),dbgotop(),"")
    iif(bof(),dbgobottom(),"")

    set color to I
    @ 08, 15 clear to 19, 74
    set color to

  enddo


enddo

set key -1 to
set key -2 to

restscreen(04, 04, 21, 76, M_TELA)

return ""

***************
function EXCKAR                        && exclui kardex
***************


do while .t.

  tlkar01()

  rodape("EXCLUI","KARDEX",M_FAN,"EAGRO14","Mem: " + str(memory(0), 5),M_EMP)

  M_KAREMP = ME_EMP
  M_KARMAT = 0

  @ 09, 25 get M_KARMAT F2 picture "######" color _COREDICAO_ funcao "sele_arquivo('APCA00')" retorno @M_KARMAT
  read

  if M_KARMAT = 0
    exit
  endif

  select APCA00

  if !dbseek( str(M_KARMAT, 6, 0))
    msg("* * * PRODUTO N?O CADASTRADO * * *")
    loop
  endif

  select ASLD00

  if !dbseek(str(M_KAREMP, 2, 0) + str(M_KARMAT, 6, 0))
    if !cria_sld_kar()               && se saldo nao existir cria
      msg("* * * (ASLD00) N?O EXISTE SALDO NA EMPRESA * * *")
      loop
    endif
  endif

  set color to I
  @ 09, 25 say str(M_KARMAT, 6, 0) picture "@R 99999-9"
  @ 09, 53 say SLDDIS picture "##########"
  @ 10, 25 say pad(APCA00->PCADES, 35)
  set color to

  do while .t.

    M_KARDTA = ctod("  /  /  ")
    M_KARFIS = 0
    M_KARDOC = 0
    M_KARSEQ = 1

    lpkar01()

    @ 12, 26 get     M_KARDTA                    valid(M_KARDTA != ctod("  /  /  "))
    @ 12, 53 get     M_KARFIS  picture "###.##"  valid vekar2()
    @ 13, 26 get     M_KARDOC  picture "######"  valid(M_KARDOC > 0)
    @ 13, 53 get     M_KARSEQ  picture "###"      valid(M_KARSEQ > 0)
    read

    if lastkey() = 27
      exit
    endif

    select AKAR00

    if !_seek(str(M_KAREMP, 2, 0) + str(M_KARMAT, 6, 0) + dtos(M_KARDTA) + str((M_KARFIS*100), 5, 0) + str(M_KARDOC, 6, 0) + str(M_KARSEQ, 3, 0))
      msg("* * * (AKAR00) MOVIMENTO N?O CADASTRADO * * *")
      loop
    endif

    mskar01()

    if !rlock()
      msg("* * * (AKAR00) RESTRO SENDO USADO * * *")
      loop
    endif

    M_OPC = confirma("do Movimento")

    if M_OPC # 1
      msg("* * * MOVIMENTO N?O EXCLUIDO * * *")
      unlock
      loop
    endif

    select ASLD00

    do while .t.
      if rlock()
        if AFIS00->FISEST = "C"
          replace SLDDIS with (SLDDIS - AKAR00->KARQDE)
        else
          if AFIS00->FISEST = "D"
            replace SLDDIS with (SLDDIS + AKAR00->KARQDE)
          endif
        endif
        unlock
        commit
        exit
      else
        msg("* * * (ASLD00) REGISTRO SENDO USADO * * *")
      endif
      if lastkey()=17
        exit
      endif
    enddo

    select AKAR00
    elimina()

    msg("* * * MOVIMENTO EXCLUIDO * * *")

  enddo

enddo


return ""

***************
function LISKAR
***************
parameters M_OPC


  rodape("LISTA","KARDEX",M_FAN,"EAGRO14","Mem: " + str(memory(0), 5),M_EMP)

*  @ 09, 15 prompt "Movimento" HIGHLITE R/BG SENHA 75
*  @ 10, 15 prompt "Custos   " HIGHLITE R/BG SENHA 76
*  @ 11, 15 prompt "Vendas   " HIGHLITE R/BG SENHA 77
*  @ 12, 15 prompt "Selecao  " HIGHLITE R/BG SENHA 78

  do case
  case M_OPC = 1
    liskar_a()
  case M_OPC = 2
    liskar_b()
  case M_OPC = 3
    liskar_c()
  case M_OPC = 4
*    liskar_d()
  endcase

return ""

*****************
function LISKAR_A                        && relatorio de kardex
*****************

private L        ,;
M_TELA

do while .t.

  rodape("LISTA","KARDEX",M_FAN,"EAGRO14","Mem: " + str(memory(0), 5),M_EMP)

  store 0               to M_COD1,;
  M_COD2

  store ctod(" /  /  ") to M_DATA1 ,;
  M_DATA2

  store 0               to M_NAT1 ,;
  M_NAT2

  sombra(12, 20, 19, 46, _SOMBRA_)

  set color to GR+/W
  @ 12, 20 say                     "???????????????????????????"
  @ 13, 20 say                     "? Produto Inicial:         ?"
  @ 14, 20 say                     "?           Final:         ?"
  @ 15, 20 say                     "? Per?odo Inicial:         ?"
  @ 16, 20 say                     "?           Final:         ?"
  @ 17, 20 say                     "?Operacao Inicial:         ?"
  @ 18, 20 say                     "?           Final:         ?"
  @ 19, 20 say                     "????????????????????????????"
  set color to

  @ 13, 39 get M_COD1 picture "######"
  @ 14, 39 get M_COD2 picture "######"
  @ 15, 39 get M_DATA1
  @ 16, 39 get M_DATA2
  @ 17, 39 get M_NAT1 picture "###.##"
  @ 18, 39 get M_NAT2 picture "###.##"
  read

  if lastkey() = 27
    return ""
  endif

  M_COD1 = iif(M_COD1 = 0,     1,M_COD1)
  M_COD2 = iif(M_COD2 = 0,999999,M_COD2)
  M_DATA1 = iif(dtoc(M_DATA1) = "  /  /  ",ctod("01/01/80"),M_DATA1)
  M_DATA2 = iif(dtoc(M_DATA2) = "  /  /  ",ctod("31/12/79"),M_DATA2)

*  M_NAT1 = iif(M_NAT1 = 0,100.00,M_NAT1)
*  M_NAT2 = iif(M_NAT2 = 0,999.99,M_NAT2)

  select AKAR00

  set relation to str(1, 2, 0) + str(KARFIS, 5, 0) into AFIS00 ,;
  to str(KAREMP, 2, 0) + str(KARMAT, 6, 0) into ASLD00 ,;
  to str(KARCLF, 5, 0)                     into ACLI00

  select APCA00

  set softseek on
  seek str(M_COD1, 6, 0)
  set softseek off
  M_ARQI  = substr(time(),4,2) + substr(time(),7,2) + ".RPT"
  M_IMPRE = impresn()

  if M_IMPRE = "N"
    return ""
  endif

  if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
    ?? chr(15)                        && comprime
  endif

  store 0 to PG      ,;
  LN      ,;
  M_SLD   ,;
  M_SLDVLR,;
  M_KARANT

  M_FLAG = .f.

  cab_kar1()

  do while !eof()

    if PCAMAT > M_COD2
      exit
    endif

    select AKAR00

    set softseek on
    seek str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0)
    set softseek off

    if !str(KAREMP, 2, 0) + str(KARMAT, 6, 0) == str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0)
      select APCA00
      skip
      loop
    endif

    M_SLD    = 0

    if M_NAT1 + M_NAT2 = 0
    do while !eof()
      if str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) >= str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0) + dtos(M_DATA1)
        exit
      endif

      if KARFIS = 10000
        M_SLD    = KARQDE
      else
        if AFIS00->FISEST = "D"
          M_SLD = M_SLD - KARQDE
        else
          if AFIS00->FISEST = "C"
            M_SLD = (M_SLD + KARQDE)
          endif
        endif
      endif
      skip
    enddo

    if str(KAREMP, 2, 0) + str(KARMAT, 6, 0) + dtos(KARDTA) > str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0) + dtos(M_DATA2)
      select APCA00
      skip
      loop
    endif
    else

      lTem = .f.
      set softseek on
      seek str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0) + dtos(M_DATA1)
      set softseek off

      do while !eof()
        if str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) >= str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0) + dtos(M_DATA2)
          exit
        endif

        if (KARFIS * .01) < M_NAT1 .or. (KARFIS * .01) > M_NAT2
          skip
          loop
        endif

       lTem = .t.

       exit

      enddo

      if !lTem
        select APCA00
        skip
        loop
      endif
    endif

    if LN > 60
      cab_kar1()
    endif

    if M_FLAG = .t.
      ? replicate("-", 132)
      LN ++
    endif

    M_FLAG = .t.

    ? transform(str(APCA00->PCAMAT, 6, 0),"@R 99999-9")
    ?? " "
    ?? pad(APCA00->PCADES, 35)
    ?? " "
    ?? APCA00->PCAUNI
    ?? "          "
    ?? "DISPONIVEL: "
    ?? str(ASLD00->SLDDIS, 9, 3)
    ?? "   "
    ?? "PENDENTE: "
    ?? str(ASLD00->SLDPEN, 9, 3)
    ?? "   "
    ?? "RESERVADO: "
    ?? str(ASLD00->SLDRES, 9, 3)
    ?

    LN += 2

    do while !eof()

      if str(KAREMP, 2, 0) + str(KARMAT, 6, 0) > str(ME_EMP, 2, 0) + str(M_COD2, 6, 0)
        exit
      endif

      if str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) > str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0) + dtos(M_DATA2)
        exit
      endif

      if AFIS00->FISEST = "D"
        M_SLD = M_SLD - KARQDE
      else
        if AFIS00->FISEST = "C"
          M_SLD = M_SLD + KARQDE
        endif
      endif

      if M_NAT1 + M_NAT2 > 0
        if (KARFIS * .01) < M_NAT1 .or. (KARFIS * .01) > M_NAT2
          skip
          loop
        endif
      endif

      ? space(21)
      ?? KARDTA
      ?? " "
      ?? str((KARFIS*.01), 6, 2)
      ?? " "
      ?? left(AFIS00->FISNOM, 18)
      ?? " "
      ?? str(KARDOC, 6, 0)
      ?? " "
      ?? str(KARSEQ, 3, 0)
      ?? " "
      ?? str(KARQDE, 9, 3)
      ?? " "
      ?? str(M_SLD, 9, 3)
      ?? " "
      ?? transform(KARVLI, "@E ###,###,###.##")
      ?? " "
      ?? str(KARCLF, 5, 0)
      ?? " "
      ?? left(ACLI00->CLINOM, 20)

      LN ++

      if LN > 60
        cab_kar1()
      endif

      skip

      if inkey() = 27
        if susimp()
          ? replicate("-", 132)
          ? "* * * IMPRESSAO SUSPENSA * * *"
          select APCA00
          go bottom
          skip
          select AKAR00
          go bottom
          skip
          loop
        endif
      endif

    enddo

    select APCA00

    skip

  enddo

  ? replicate("-", 132)

  eject

  if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
    ?? chr(18)                        && descomprime
  endif

  set print off
  set printer to
  set console on
  set cursor on
  set relation to


desliga1()
enddo

return ""

*****************
function LISKAR_B                      && relatorio de kardex
*****************

private L        ,;
M_TELA


do while .t.

  rodape("LISTA","KARDEX",M_FAN,"EAGRO14","Mem: " + str(memory(0), 5),M_EMP)

  store 0               to M_COD1,;
  M_COD2

  store ctod(" /  /  ") to M_DATA1 ,;
  M_DATA2

  store 0               to M_NAT1 ,;
  M_NAT2

  sombra(12, 20, 19, 46, _SOMBRA_)

  set color to GR+/W
  @ 12, 20 say                     "???????????????????????????"
  @ 13, 20 say                     "? Produto Inicial:         ?"
  @ 14, 20 say                     "?           Final:         ?"
  @ 15, 20 say                     "? Per?odo Inicial:         ?"
  @ 16, 20 say                     "?           Final:         ?"
  @ 17, 20 say                     "?Operacao Inicial:         ?"
  @ 18, 20 say                     "?           Final:         ?"
  @ 19, 20 say                     "????????????????????????????"
  set color to

  @ 13, 39 get M_COD1 picture "######"
  @ 14, 39 get M_COD2 picture "######"
  @ 15, 39 get M_DATA1
  @ 16, 39 get M_DATA2
  @ 17, 39 get M_NAT1 picture "###.##"
  @ 18, 39 get M_NAT2 picture "###.##"
  read

  if lastkey() = 27
    return ""
  endif

  M_COD1 = iif(M_COD1 = 0,     1,M_COD1)
  M_COD2 = iif(M_COD2 = 0,999999,M_COD2)
  M_DATA1 = iif(dtoc(M_DATA1) = "  /  /  ",ctod("01/01/80"),M_DATA1)
  M_DATA2 = iif(dtoc(M_DATA2) = "  /  /  ",ctod("31/12/79"),M_DATA2)
  M_NAT1 = iif(M_NAT1 = 0,100.00,M_NAT1)
  M_NAT2 = iif(M_NAT2 = 0,999.99,M_NAT2)

  select AKAR00

  set relation to str(1, 2, 0) + str(KARFIS, 5, 0) into AFIS00 ,;
  to str(KAREMP, 2, 0) + str(KARMAT, 6, 0) into ASLD00 ,;
  to str(KARCLF, 5, 0)                     into ACLI00

  select APCA00

  set softseek on
  seek str(M_COD1, 6, 0)
  set softseek off
  M_ARQI  = substr(time(),4,2) + substr(time(),7,2) + ".RPT"
  M_IMPRE = impresn()

  if M_IMPRE = "N"
    return ""
  endif

  if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
    ?? chr(15)                        && comprime
  endif

  store 0 to PG      ,;
  LN      ,;
  M_SLD   ,;
  M_SLDVLR,;
  M_KARANT

  M_FLAG = .f.

  cab_kar2()

  do while !eof()

    if PCAMAT > M_COD2
      exit
    endif

    select AKAR00

    set softseek on
    seek str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0)
    set softseek off

    if !str(KAREMP, 2, 0) + str(KARMAT, 6, 0) == str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0)
      select APCA00
      skip
      loop
    endif

    M_SLD    = 0
    M_SLDCME = 0
    M_SLDFIN = 0
    M_SLDCPA = 0

    do while !eof()

      if str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) >= str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0) + dtos(M_DATA1)
        exit
      endif

      if str(KAREMP, 2, 0) + str(KARMAT, 6, 0) + dtos(KARDTA) > str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0) + dtos(M_DATA2)
        exit
      endif


      ****** CALCULO DE CUSTO MEDIO ******

      if KARFIS = 10000
        M_SLD    = KARQDE
        if KARQDE > 0                  && se quantidade igual zero
          M_SLDCME = (KARVLI / KARQDE)
        endif
        M_SLDFIN = KARVLI
      else
        if AFIS00->FISEST = "D"
          M_SLD = M_SLD - KARQDE
          if AFIS00->FISMED = "S"
            M_SLDFIN = (M_SLDFIN - (M_SLDCME * KARQDE))
          endif
        else
          if AFIS00->FISEST = "C"
            M_SLDFIN = M_SLDFIN + (KARVLI + KARDSP + KARIPI)
            M_SLD = (M_SLD + KARQDE)
            if M_SLD > 0                  && se quantidade igual zero
              if AFIS00->FISMED = "S"
                M_SLDCME = (M_SLDFIN / M_SLD)
              endif
            endif
          endif
        endif
      endif
      skip
    enddo

    if LN > 60
      cab_kar2()
    endif

    if M_FLAG = .t.
      ? replicate("-", 132)
      LN = LN + 1
    endif


    ? transform(str(APCA00->PCAMAT, 6, 0),"@R 99999-9")
    ?? " "
    ?? pad(APCA00->PCADES, 35)
    ?? " "
    ?? APCA00->PCAUNI
    ?? "          "
    ?? "DISPONIVEL: "
    ?? str(ASLD00->SLDDIS, 9, 0)
    ?? "   "
    ?? "PENDENTE: "
    ?? str(ASLD00->SLDPEN, 9, 3)
    ?? "   "
    ?? "RESERVADO: "
    ?? str(ASLD00->SLDRES, 9, 3)
    ?

    LN = LN + 2

    do while !eof()

      if str(KAREMP, 2, 0) + str(KARMAT, 6, 0) > str(ME_EMP, 2, 0) + str(M_COD2, 6, 0)
        exit
      endif

      if str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) > str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0) + dtos(M_DATA2)
        exit
      endif

      ****** CALCULO DE CUSTO MEDIO ******

      if KARFIS = 10000
        M_SLD    = KARQDE
        if KARQDE > 0                  && se quantidade igual zero
          M_SLDCME = (KARVLI / KARQDE)
        endif
        M_SLDFIN = KARVLI
      else
        if AFIS00->FISEST = "D"
          M_SLD = M_SLD - KARQDE
          if AFIS00->FISMED = "S"
            M_SLDFIN = (M_SLDFIN - (M_SLDCME * KARQDE))
          endif
        else
          if AFIS00->FISEST = "C"
            M_SLDFIN = M_SLDFIN + (KARVLI + KARDSP + KARIPI)
            M_SLD = (M_SLD + KARQDE)
            if M_SLD > 0                  && se quantidade igual zero
              if AFIS00->FISMED = "S"
                M_SLDCME = (M_SLDFIN / M_SLD)
              endif
            endif
          endif
        endif
      endif

      if (KARFIS * .01) < M_NAT1 .or. (KARFIS * .01) > M_NAT2
        skip
        loop
      endif

      ? space(04)
      ?? KARDTA
      ?? " "
      ?? str((KARFIS*.01), 6, 2)
      ?? " "
      ?? left(AFIS00->FISNOM, 18)
      ?? " "
      ?? str(KARDOC, 6, 0)
      ?? " "
      ?? str(KARSEQ, 3, 0)
      ?? " "
      ?? str(KARQDE, 9, 3)
      ?? " "
      ?? str(M_SLD, 9, 3)
      ?? " "
      ?? transform((KARVLI/KARQDE),"@E ###,###,###.##")
      ?? " "
      ?? transform(KARVLI, "@E ####,###,###.##")
      ?? " "
      ?? transform(M_SLDFIN,"@E ####,###,###.##")
      ?? " "
      ?? transform(M_SLDCME, "@E ###,###,###.##")

      LN = LN + 1


      select ASLD00

      do while .t.
        if rlock()
          replace SLDINV with M_SLD
          if M_SLDCME > 99999999999.99
            replace SLDCME with 0
          else
            replace SLDCME with M_SLDCME
          endif
          unlock
          exit
        else
          msg("* * * (ASLD00) REGISTRO SENDO USADO * * *")
        endif
        if lastkey() = 17
          exit
        endif
      enddo

      select AKAR00



      if LN > 60
        cab_kar2()
      endif

      skip

      M_ESC = inkey()

      if M_ESC = 27
        if susimp()
          ? replicate("-", 132)
          ? "* * * IMPRESSAO SUSPENSA * * *"
          select APCA00
          go bottom
          skip
          select AKAR00
          go bottom
          skip
          loop
        else
          M_ESC = inkey()
        endif
      endif

    enddo

    select APCA00

    skip

  enddo

  ? replicate("-", 132)

  eject

  if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
    ?? chr(18)                        && descomprime
  endif

  set print off
  set printer to
  set console on
  set cursor on
  set relation to


desliga1()
enddo

return ""

*****************
function LISKAR_C                        && sintetico
*****************

private L        ,;
M_TELA

do while .t.

  rodape("LISTA","SINTETICO",M_FAN,"EAGRO14","Mem: " + str(memory(0), 5),M_EMP)

  store 0               to M_GRPINI ,;
  M_GRPFIN ,;
  M_PCAINI ,;
  M_PCAFIN
  M_SELEC := "S"

  M_ANONUM = year(date())

  sombra(11, 20, 19, 46, _SOMBRA_)

  set color to GR+/W
  @ 11, 20 say                     "???????????????????????????"
  @ 12, 20 say                     "?     Selecao S/N:         ?"
  @ 13, 20 say                     "??????????????????????????J"
  @ 14, 20 say                     "?   Grupo Inicial:         ?"
  @ 15, 20 say                     "?           Final:         ?"
  @ 16, 20 say                     "? Produto Inicial:         ?"
  @ 17, 20 say                     "?           Final:         ?"
  @ 18, 20 say                     "?       Exercicio:         ?"
  @ 19, 20 say                     "????????????????????????????"
  set color to

  @ 12, 39 get M_SELEC  picture "@!"  valid (M_SELEC $ "SN")
  read

  if lastkey() = 27
    return ""
  endif

  if M_SELEC == "N"
    @ 14, 39 get M_GRPINI picture "####"
    @ 15, 39 get M_GRPFIN picture "####"
    @ 16, 39 get M_PCAINI picture "######"
    @ 17, 39 get M_PCAFIN picture "######"
    @ 18, 39 get M_ANONUM picture "####"
    read
  else
    @ 18, 39 get M_ANONUM picture "####"
    read
  endif

  if lastkey() = 27
    return ""
  endif

  M_GRPINI = iif(M_GRPINI = 0,   1,M_GRPINI)
  M_GRPFIN = iif(M_GRPFIN = 0,9999,M_GRPFIN)

  M_PCAINI = iif(M_PCAINI = 0,     1,M_PCAINI)
  M_PCAFIN = iif(M_PCAFIN = 0,999999,M_PCAFIN)

  if M_SELEC == "N"
    select APCA00
    set relation to str(PCAGRP, 4, 0) into AGRP00

    (dbsetorder(2) , dbseek(str(M_GRPINI, 4, 0) + str(M_PCAINI, 6, 0), .t.))
  else
    select APCA00
    set relation to str(PCAGRP, 4, 0) into AGRP00

    select AKAR02
    set relation to str(KARMAT, 6, 0) into APCA00
    dbseek(str(ME_EMP, 2, 0) + str(1, 6, 0),.t.)
  endif
M_ARQI  = substr(time(),4,2) + substr(time(),7,2) + ".RPT"
  M_IMPRE = impresn()

  if M_IMPRE = "N"
    return ""
  endif

  if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
    ?? chr(15)                        && comprime
  endif

  store 0 to PG      ,;
  M_GRPANT

  do while !eof()

    PG++

    if PG > 1
      eject
    endif

    ? cent_cab(AEMP00->EMPFAN,"ESTATISTICAS DE SAIDAS MENSAIS","EAGRO14",132)
    ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
    ? "*-------*---------------*-------------------*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*--------*"
    ? "*  COD  *   FABRICA     *    DESCRICAO      * JAN * FEV * MAR * ABR * MAI * JUN * JUL * AGO * SET * OUT * NOV * DEZ * TOT * MEDIA  *"
    ? "*-------*---------------*-------------------*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*-----*--------*"
    *            99.9999 XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXX 99999 99999 99999 99999 99999 99999 99999 99999 99999 99999 99999 99999 99999 99999.99

    store 5 to LN

    do while !eof() .and. LN < 60

      if M_SELEC == "N"
        if str(PCAGRP, 4, 0) + str(PCAMAT, 6, 0) > str(M_GRPFIN, 4, 0) + str(M_PCAFIN, 6, 0)
          go bottom
          skip
          loop
        endif

        if !AANO00->(dbseek(str(ME_EMP, 2, 0) + str(M_ANONUM, 4, 0) + str(APCA00->PCAMAT, 6, 0)))
          select APCA00
          skip
          loop
        endif
      else
        if !AANO00->(dbseek(str(ME_EMP, 2, 0) + str(M_ANONUM, 4, 0) + str(APCA00->PCAMAT, 6, 0)))
          select AKAR02
          skip
          loop
        endif
      endif

      TOTAL = 0
      MESES = 0
      for R = 1 to 12
        S = strzero(R, 2, 0)
        if AANO00->ANOQDS&S > 0
          TOTAL = TOTAL + AANO00->ANOQDS&S
          MESES = MESES + 1
        endif
      next
      if TOTAL = 0
        skip
        loop
      endif

      if M_GRPANT != APCA00->PCAGRP
        if M_GRPANT > 0
          ? "+" + replicate("-", 130) + "+"
        endif
        ? "|"
        ?? chr(27) + "E"
        ?? str(APCA00->PCAGRP, 4, 0)
        ?? " - "
        ?? AGRP00->GRPNOM
        ?? space(73)
        ??  chr(27) + "F"
        ?? "|"
        ? "|" + space(130)
        ?? "|"
        M_GRPANT = APCA00->PCAGRP
        LN = LN + 3
      endif

      ? "|"
      ?? transform(str(APCA00->PCAMAT, 6, 0),"@R 99999-9")
      ?? "|"
      ?? pad(APCA00->PCAREF, 15)
      ?? "|"
      ?? pad(APCA00->PCADES,19)
      ?? "|"
      for R = 1 to 12
        S = strzero(R, 2, 0)
        ?? transform(AANO00->ANOQDS&S, "@Z #####")
        ?? "|"
      next
      ?? transform(TOTAL, "@Z #####")
      ?? "|"
      ?? transform(TOTAL/MESES, "@Z #####.##")
      ?? "|"

      store LN + 1 to LN

      skip

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

  ? replicate("-", 132)

  eject


  set print off
  set printer to
  set console on
  set cursor on
  select AKAR02
  set relation to
  select APCA00
  set relation to
  set order to 1

desliga1()
  restscreen(12, 21, 20, 63, M_TELA)

enddo

return ""

*****************
function LISKAR_D
*****************


LISTA := { }

select AKAR02
dbseek(str(ME_EMP, 2, 0),.t.)

do while !eof()
  if KARMAT = 0
    skip
    loop
  endif

  aadd(LISTA,{KARMAT})
  skip
enddo

if len(LISTA) = 0
  aadd(LISTA,{0})
endif

sombra(10,19,16,29,_SOMBRA_)

set color to N/BG
@ 10, 19 say   "??????????"
@ 11, 19 say   "?       ? ?"
@ 12, 19 say   "?       ? ?"
@ 13, 19 say   "?       ? ?"
@ 14, 19 say   "?       ? ?"
@ 15, 19 say   "?       ? ?"
@ 16, 19 say   "???????????"
set color to W+/BG,W+/N
acho1(11,20,15,26,LISTA)
setcolor("")

**************
function ACHO1
**************

para xLin1, xCol1, xLin2, xCol2, aList

local acolor   := acolor()
local saveele  := ""

private xLin1,xCol1, xLin2, xCol2, aList, funcao1,RET

xLin2 ++
xCol2 ++
RET = 0

Tan = xLin2 - xLin1

if Tan > len(aList)
  Tan = len(aList)
endif

for A = 1 to xLin2 - xLin1
  if A > len(aList)
    @ (xLin1-1)+A, xCol1 say space((xCol2-xCol1))
  else
    @ (xLin1-1)+A , xCol1 say pad(aList[A,1], (xCol2-xCol1))
  endif
next

pos_start = 0
POS = 1
LOC = 1
POSANT = 2

cScreacho = savescreen((xLin1-1)+LOC,xCol1,(xLin1-1)+LOC,xCol2)

do while .t.

  do while .t.

    setcolor(acolor[2])
    @ (xLin1-1)+LOC, xCol1 say pad(aList[POS,1], (xCol2-xCol1))
    setcolor(acolor[1])

    do while .t.

      tecla = 0
      tecla = inkey()

      if rat(str(tecla,2),"19.24. 5. 4.13. 9.27. 1.22. 7") > 0
        exit
      endif
    enddo

    do case
    case tecla = 22
      inclui()
    case tecla = 7
      exclui()
    case tecla = 27
      return ""
    endcase

    restscreen((xLin1-1)+LOC,xCol1,(xLin1-1)+LOC,xCol2,cScreacho)

    do case
    case tecla = 24
      LOC ++ // desce
      POS ++
    case tecla = 5
      LOC -- // sobe
      POS --
    case tecla = 19
      LOC -- // sobe
      POS --
    case tecla = 4
      LOC ++ // desce
      POS ++
    endcase
    exit
  enddo

  do case
  case POS > len(aList)
    POS = len(aList)
  case POS < 1
    POS = 1
  endcase

  if LOC > tan
    LOC = tan
    POSANT = tan

    pos_start ++

    if (tan + pos_start) > len(aList)
      pos_start = len(aList) - tan
    endif

    if LOC < len(aList)
      for A = 1 to tan
        if A > len(aList)
          @ (xLin1-1)+A, xCol1 say space((xCol2-xCol1))
        else
          @ (xLin1-1)+A, xCol1 say pad(aList[A+pos_start,1], (xCol2-xCol1))
        endif
      next
    endif
  endif

  if LOC < 1
    LOC = 1
    pos_start --
    if pos_start <= 0
      pos_start = 0
    endif

    for A = 1 to tan
      if A > len(aList)
        @ (xLin1-1)+A, xCol1 say space((xCol2-xCol1))
      else
        @ (xLin1-1)+A, xCol1 say pad(aList[A+pos_start,1], (xCol2-xCol1))
      endif
    next
  endif

  cScreacho = savescreen((xLin1-1)+LOC,xCol1,(xLin1-1)+LOC, xCol2)

enddo

return  ""

***************
function INCLUI
***************

nColor = setcolor()
N_CAMPO = 0

N_TELA = savescreen(12, 20, 15, 71)

sombra(12, 24, 14, 65,_SOMBRA_)

setcolor(nColor)
@ 12, 24, 14, 65 box M_FRAME1
@ 13, 25 say               "Qual o Codigo para acrescentar :        "
@ 13, 58 get N_CAMPO pict "######"
read

if !APCA00->(dbseek(str(N_CAMPO, 6, 0)))
  msg("* * * PRODUTO NAO CADASTRADO * * *")
  restscreen(12, 20, 15, 71,N_TELA)
  return ""
endif

if dbseek(str(ME_EMP, 2, 0) + str(N_CAMPO, 6, 0))
  msg("* * * CODIGO JA INCLUIDO * * *")
  restscreen(12, 20, 15, 71,N_TELA)
  return
endif

if aList[1,1] = 0
  aList[1,1] = N_CAMPO
else
  aadd(aList,{N_CAMPO})
endif

Tan = xLin2 - xLin1

if Tan > len(aList)
  Tan = len(aList)
endif

setcolor("W+/BG,W+/N")
for A = 1 to tan
  if A > len(aList)
    @ (xLin1-1)+A, xCol1 say space((xCol2-xCol1))
  else
    @ (xLin1-1)+A, xCol1 say pad(aList[A+pos_start,1], (xCol2-xCol1))
  endif
next
setcolor(nColor)

cScreacho = savescreen((xLin1-1)+LOC,xCol1,(xLin1-1)+LOC,xCol2)

select AKAR02

seek str(0, 2, 0) + str(0, 6, 0)

if eof()
  do while .t.
    append blank
    if neterr()
      msg("* * * (ASLD00) ARQUIVO EM USO EXCLUSIVO) * * *")
      if lastkey()=17
        exit
      endif
      loop
    endif
    exit
  enddo
endif

do while .t.
  if rlock()
    replace KAREMP with ME_EMP
    replace KARMAT with N_CAMPO
    unlock
    commit
    exit
  else
    msg("* * * (ASLD00) REGISTRO SENDO USADO * * *")
  endif
  if lastkey()=17
    exit
  endif
enddo

restscreen(12, 20, 15, 71,N_TELA)

return ""

***************
function EXCLUI
***************

select AKAR02

seek str(ME_EMP, 2, 0) + str(alist[POS,1], 6, 0)

do while .t.
  if rlock()
    replace KAREMP with 0
    replace KARMAT with 0
    unlock
    commit
    exit
  else
    msg("* * * (ASLD00) REGISTRO SENDO USADO * * *")
  endif
  if lastkey()=17
    exit
  endif
enddo

LISTA := { }

for ZZ = 1 to len(aList)
  if zz # POS
    aadd(LISTA,{aList[zz,1]})
  endif
next

aList = LISTA

if len(alist) = 0
  aadd(alist,{"      "})
endif

Tan = xLin2 - xLin1

if Tan > len(aList)
  Tan = len(aList)
endif

for A = 1 to xLin2 - xLin1
  if A > len(aList)
    @ (xLin1-1)+A, xCol1 say space((xCol2-xCol1))
  else
    @ (xLin1-1)+A, xCol1 say pad(aList[A,1], (xCol2-xCol1))
  endif
next

pos_start = 0
POS = 1
LOC = 1
POSANT = 2

cScreacho = savescreen((xLin1-1)+LOC,xCol1,(xLin1-1)+LOC,xCol2)

return ""

***************
function PROKAR                    && consulta kardex
***************

parameters M_OPC


  rodape("ATUALIZA","KARDEX",M_FAN,"EAGRO14","Mem: " + str(memory(0), 5),M_EMP)

*  @ 09, 15 prompt "Saldo Individual  " position 7 HIGHLITE R/BG SENHA 79
*  @ 10, 15 prompt "Saldo Geral       " position 7 HIGHLITE R/BG SENHA 80
*  @ 11, 15 prompt "Custo M?dio       " position 1 HIGHLITE R/BG SENHA 81
*  @ 12, 15 prompt "Gr?fico Anual     " position 9 HIGHLITE R/BG SENHA 82
*  @ 13, 15 prompt "Finaliza Exerc?cio" position 1 HIGHLITE R/BG SENHA 83

  do case
  case M_OPC = 1
    prokar_a()
  case M_OPC = 2
    prokar_b()
  case M_OPC = 3
    prokar_c()
  case M_OPC = 4
    prokar_d()
  case M_OPC = 5
    prokar_e()
  endcase


return ""

*****************
function PROKAR_A(F_PROD)
*****************

if F_PROD = NIL
  F_PROD = 0
endif

private M_KARMAT ,;
M_SLD    ,;
M_SLDDTE ,;
M_SLDDTS

if F_PROD = NIL
  F_PROD = 0
else
  M_KARMAT = F_PROD
endif

do while .t.

 rodape("ATUALIZA","SALDO",M_FAN,"EAGRO14","Mem: " + str(memory(0), 5),M_EMP)
 store 0 to M_KARMAT

 set color to GR+
 @ 23, 22 say   "Informe o C?digo do Produto:       "
 @ 23, 51 get M_KARMAT F2 picture "######" color _COREDICAO_ funcao "sele_arquivo('APCA00')" retorno @M_KARMAT
 read
 set color to

 if lastkey() = 27
   return ""
 endif

 msw("* * * AGUARDE ... PROCESSANDO !!! * * *")


cSQL = 'SELECT KARQDE,KARDTA '
cSQL = cSQL + 'FROM AKAR00 '
cSQL = cSQL + 'WHERE KAREMP = ' + str(ME_EMP,2) + ' AND '
cSQL = cSQL + 'KARMAT = ' + str(M_KARMAT,6) + ' AND '
cSQL = cSQL + "KARFISN = '1.000' order by kardta desc"
dbusearea(.t.,"SQLMIX",cSQL,"AKAR00")
SELECT AKAR00

m_sld = 0
M_SLDANT = 0

if !eof()
  M_SLDANT = KARQDE
  M_DTASAL = KARDTA
  cSQL = "SELECT afis00.fiscod, afis00.fisest,afis00.fismed, akar00.kardta, akar00.karfisn,"
  cSQL = cSQL + "COALESCE(akar00.karqde,0) as karqde,COALESCE(akar00.karliq,0) as karliq,COALESCE(akar00.karvli,0) as karvli"
  cSQL = cSQL + ",COALESCE(akar00.kardsp,0) as kardsp,COALESCE(akar00.karipi,0) as karipi from akar00 "
  cSQL = cSQL + 'left outer join afis00 on (akar00.karfisn = afis00.fisnov and akar00.karemp = afis00.fisemp) '
  cSQL = cSQL + 'where karemp = ' + aspas(str(ME_EMP,2))
  cSQL = cSQL + ' and KARMAT = ' + aspas(str(M_KARMAT,7))
  cSQL = cSQL + ' and KARDTA >= ' + aspas(formatdta(M_DTASAL))
  cSQL = cSQL + " order by KARDTA,karfisn"
else
  cSQL = "SELECT afis00.fiscod, afis00.fisest,afis00.fismed, akar00.kardta, akar00.karfisn,"
  cSQL = cSQL + "COALESCE(akar00.karqde,0) as karqde,COALESCE(akar00.karliq,0) as karliq,COALESCE(akar00.karvli,0) as karvli"
  cSQL = cSQL + ",COALESCE(akar00.kardsp,0) as kardsp,COALESCE(akar00.karipi,0) as karipi from akar00 "
  cSQL = cSQL + 'left outer join afis00 on (akar00.karfisn = afis00.fisnov and akar00.karemp = afis00.fisemp) '
  cSQL = cSQL + 'where karemp = ' + aspas(str(ME_EMP,2))
  cSQL = cSQL + ' and KARMAT = ' + aspas(str(M_KARMAT,7))
  cSQL = cSQL + " order by KARDTA,karfisn"
endif

SELECT AKAR00
use

dbusearea(.t.,"SQLMIX",cSQL,"AKAR00")

select AKAR00
go top

  M_SLD    = M_SLDANT
  M_SLDCME = 0
  M_SLDFIN = 0
  n_TOTSAL = 0
  n_TOTVAL = 0
  k_ENTRADA = 0
  k_SAIDA = 0

  do while !eof()
    M_FISEST = ""
    sldmed_kar()
    skip
  enddo

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"ASLD00","UPDATE"}
  aadd(sqlCHAVE,{"SLDEMP",str(ME_EMP,2)})
  aadd(sqlCHAVE,{"SLDMAT",str(M_KARMAT,6)})
  aadd(sqlCAMPO,{"SLDDIS",str1(M_SLD,2),.f.})
  executasql()

  MSG(STR(m_sld,12,2))

enddo


return ""

*****************
function PROKAR_B                      && acerta saldo kardex geral
*****************

private M_SLD    ,;
M_SLDDTE ,;
M_SLDDTS

rodape("ATUALIZA","SALDO",M_FAN,"EAGRO14","Mem: " + str(memory(0), 5),M_EMP)

msg("* * * (ENTER) Continua  (ESC) abandona * * *")

if lastkey() = 27
  return ""
endif

msw("* * * AGUARDE ... PROCESSANDO !!! * * *")

cSQL = 'SELECT PCAMAT '
cSQL = cSQL + 'FROM APCA00 '
dbusearea(.t.,"SQLMIX",cSQL,"APCA00")

select APCA00                       && procura descricao da peca
go top


do while !eof()

  msw("* * * AGUARDE ... PROCESSANDO: " + transform(str(PCAMAT, 6, 0),"@R 99999-9") + " * * *")
   seexistesql("AKAR00")
   cSQL = 'SELECT KARQDE,KARDTA '
   cSQL = cSQL + 'FROM AKAR00 '
   cSQL = cSQL + 'WHERE KAREMP = ' + str(ME_EMP,2) + ' AND '
   cSQL = cSQL + 'KARMAT = ' + str(APCA00->PCAMAT,6) + ' AND '
   cSQL = cSQL + "KARFISN = '1.000' order by kardta desc"
   dbusearea(.t.,"SQLMIX",cSQL,"AKAR00")
   SELECT AKAR00

   m_sld = 0
   M_SLDANT = 0

   if !eof()
     M_SLDANT = KARQDE
     M_DTASAL = KARDTA
     cSQL = "SELECT afis00.fiscod, afis00.fisest,afis00.fismed, akar00.kardta, akar00.karfisn,"
     cSQL = cSQL + "COALESCE(akar00.karqde,0) as karqde,COALESCE(akar00.karliq,0) as karliq,COALESCE(akar00.karvli,0) as karvli"
     cSQL = cSQL + ",COALESCE(akar00.kardsp,0) as kardsp,COALESCE(akar00.karipi,0) as karipi from akar00 "
     cSQL = cSQL + 'left outer join afis00 on (akar00.karfisn = afis00.fisnov and akar00.karemp = afis00.fisemp) '
     cSQL = cSQL + 'where karemp = ' + aspas(str(ME_EMP,2))
     cSQL = cSQL + ' and KARMAT = ' + aspas(str(APCA00->PCAMAT,7))
     cSQL = cSQL + ' and KARDTA >= ' + aspas(formatdta(M_DTASAL))
     cSQL = cSQL + " order by KARDTA,karfisn"
   else
     cSQL = "SELECT afis00.fiscod, afis00.fisest,afis00.fismed, akar00.kardta, akar00.karfisn,"
     cSQL = cSQL + "COALESCE(akar00.karqde,0) as karqde,COALESCE(akar00.karliq,0) as karliq,COALESCE(akar00.karvli,0) as karvli"
     cSQL = cSQL + ",COALESCE(akar00.kardsp,0) as kardsp,COALESCE(akar00.karipi,0) as karipi from akar00 "
     cSQL = cSQL + 'left outer join afis00 on (akar00.karfisn = afis00.fisnov and akar00.karemp = afis00.fisemp) '
     cSQL = cSQL + 'where karemp = ' + aspas(str(ME_EMP,2))
     cSQL = cSQL + ' and KARMAT = ' + aspas(str(APCA00->PCAMAT,7))
     cSQL = cSQL + " order by KARDTA,karfisn"
   endif

   seexistesql("AKAR00")
   dbusearea(.t.,"SQLMIX",cSQL,"AKAR00")

   select AKAR00
   go top

   M_SLD    = M_SLDANT
   M_SLDCME = 0
   M_SLDFIN = 0
   n_TOTSAL = 0
   n_TOTVAL = 0
   k_ENTRADA = 0
   k_SAIDA = 0

   do while !eof()
     M_FISEST = ""
     sldmed_kar()
     skip
   enddo

   sqlCAMPO = {}
   sqlCHAVE =  {}
   sqlARQUI = {"ASLD00","UPDATE"}
   aadd(sqlCHAVE,{"SLDEMP",str(ME_EMP,2)})
   aadd(sqlCHAVE,{"SLDMAT",str(APCA00->PCAMAT,6)})
   aadd(sqlCAMPO,{"SLDDIS",str1(M_SLD,2),.f.})
   executasql()

   select APCA00
   skip
enddo

msg("* * * FIM DO PROCESSAMENTO * * *")

return ""


*****************
function PROKAR_C                      && acerta custo medio
*****************

private M_SLD

rodape("ATUALIZA","CUSTO M?DIO",M_FAN,"EAGRO14","Mem: " + str(memory(0), 5),M_EMP)

msg("* * * (ENTER) Continua  (ESC) abandona * * *")

if lastkey() = 27
  return ""
endif

select AKAR00

set relation to str(1, 2, 0) + str(KARFIS, 5, 0) into AFIS00

select APCA00                       && procura descricao da peca

go top

do while !eof()

  msw("* * * AGUARDE ... PROCESSANDO: " + transform(str(PCAMAT, 6, 0),"@R 99999-9") + " * * *")

  select AKAR00

  set softseek on
  seek str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0)
  set softseek off

  if str(KAREMP, 2, 0) + str(KARMAT, 6, 0) > str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0) .or. str(KAREMP, 2, 0) + str(KARMAT, 6, 0) < str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0)
    select APCA00
    skip
    loop
  endif

  M_SLD    = 0
  M_SLDFIN = 0
  M_SLDCPA = 0
  M_SLDCME = 0

  do while !eof()

    if !str(ME_EMP, 2, 0) + str(KARMAT, 6, 0) == str(KAREMP, 2, 0) + str(APCA00->PCAMAT, 6, 0)
      exit
    endif

    ****** CALCULO DE CUSTO MEDIO ******

    if KARFIS = 10000
      M_SLD    = KARQDE
      if KARQDE > 0                  && se quantidade igual zero
        M_SLDCME = (KARVLI / KARQDE)
      endif
      M_SLDFIN = KARVLI
    else
      if AFIS00->FISEST = "D"
        M_SLD = M_SLD - KARQDE
        if AFIS00->FISMED = "S"
          M_SLDFIN = (M_SLDFIN - (M_SLDCME * KARQDE))
        endif
      else
        if AFIS00->FISEST = "C"
          M_SLDFIN = M_SLDFIN + (KARVLI + KARDSP + KARIPI)
          M_SLD = (M_SLD + KARQDE)
          if M_SLD > 0                  && se quantidade igual zero
            if AFIS00->FISMED = "S"
              M_SLDCME = (M_SLDFIN / M_SLD)
            endif
          endif
        endif
      endif
    endif

    if rat(substr(str(KARFIS, 5, 0), 1, 3),"112#212") > 0
      M_SLDCPA = ((KARVLI + KARDSP) / KARQDE)
    endif

    skip

  enddo

  select ASLD00

  seek str(ME_EMP, 2, 0) + str(APCA00->PCAMAT, 6, 0)

  if !eof()
    do while .t.
      if rlock()
        replace SLDFIN with M_SLDFIN
        if M_SLDCPA > 0
          replace SLDCPA with M_SLDCPA
        endif
        if M_SLDCME > 99999999999.99
          replace SLDCME with 0
        else
          replace SLDCME with M_SLDCME
        endif
        unlock
        exit
      else
        msg("* * * (ASLD00) REGISTRO SENDO USADO * * *")
      endif
      if lastkey() = 17
        exit
      endif
    enddo
  else
    do while .t.
      append blank
      if neterr()
        msg("* * * (ASLD00) ARQUIVO EM USO EXCLUSIVO) * * *")
        if lastkey()=17
          exit
        endif
        loop
      endif
      exit
    enddo
    do while .t.
      if rlock()
        replace SLDEMP with ME_EMP
        replace SLDMAT with APCA00->PCAMAT
        replace SLDFIN with M_SLDFIN
        if M_SLDCPA > 0
          replace SLDCPA with M_SLDCPA
        endif
        if M_SLDCME > 99999999999.99
          replace SLDCME with 0
        else
          replace SLDCME with M_SLDCME
        endif
        unlock
        exit
      else
        msg("* * * (ASLD00) REGISTRO SENDO USADO * * *")
      endif
      if lastkey()=17
        exit
      endif
    enddo
  endif

  select APCA00

  skip

enddo

commit

msg("* * * FIM DO PROCESSAMENTO * * *")

return ""

*****************
function PROKAR_D                      && gera movimento anual
*****************

msw("* * * AGUARDE... ABRINDO ARQUIVOS * * *")

private M_OPC

rodape("MOVIMENTO","ANUAL",M_FAN,"EAGRO14","Mem: " + str(memory(0), 5),M_EMP)

store 0 to M_PROINI,;
M_PROFIN

set century on
store substr(dtoc(date()), 4, 7) to M_PROEXE
set century off

sombra(13, 25, 16, 49,_SOMBRA_)

set color to GR+/W
@ 13, 25 say "                           "
@ 15, 25 say "      Referencia:          "
@ 16, 25 say "                           "
set color to

@ 15, 43 get     M_PROEXE valid vekar5()
read

if lastkey() = 27
  return ""
endif


M_MES    = substr(M_PROEXE, 1, 2)
M_ANO    = substr(M_PROEXE, 4, 4)
M_DATA1 = ctod("01/" + M_PROEXE)
M_DATA2 = lastday(M_DATA1)

sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"AANO00","UPDATE"}
aadd(sqlCHAVE,{"ANOEMP",str(ME_EMP,2)})
aadd(sqlCHAVE,{"ANONUM",M_ANO})
aadd(sqlCAMPO,{"ANOQDS" + strzero(val(M_MES),2),str1(0,2),.f.})
aadd(sqlCAMPO,{"ANOQDE" + strzero(val(M_MES),2),str1(0,2),.f.})
executasql()

seexistesql("APCA00")
cSQL = 'SELECT PCAMAT,PCAFAB '
cSQL = cSQL + "FROM APCA00 WHERE PCAFAB <> ''"
dbusearea(.t.,"SQLMIX",cSQL,"APCA00")

select APCA00                       && procura descricao da peca
go top

msw("* * * AGUARDE ... PROCESSANDO !!! * * *")

do while !eof()

  msw("* * * AGUARDE ... PROCESSANDO !!! " + transform(str(PCAMAT, 6, 0),"@R 99999-9") + " * * *")

  seexistesql("AKAR00")
  cSQL = 'SELECT KARQDE, KARFISN '
  cSQL = cSQL + 'FROM AKAR00 '
  cSQL = cSQL + 'WHERE KAREMP = ' + str(ME_EMP,2) + ' AND '
  cSQL = cSQL + 'KARMAT = ' + str(APCA00->PCAMAT,6) + ' AND '
  cSQL = cSQL + "KARDTA BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2))
  cSQL = cSQL + "AND KARFISN in ('5.102','5.104','5.405','6.102','6.104','6.405','1.102','1.403','1.910','1.949','2.102','5.202','6.202','1.202','2.202')"
  dbusearea(.t.,"SQLMIX",cSQL,"AKAR00")
  SELECT AKAR00

  M_ANOQDE = 0
  M_ANOQDS = 0
  
  do while !eof()

    do case
      case KARFISN $ "5.102#5.104#5.405#6.102#6.104#6.405"
        M_ANOQDS += KARQDE
      case KARFISN $ "1.102#1.403#1.910#1.949#2.102#"
        M_ANOQDE += KARQDE
      case KARFISN $ "5.202#6.202"
        M_ANOQDE -= KARQDE
      case KARFISN $ "1.202#2.202"
        M_ANOQDS -= KARQDE
    endcase

    select AKAR00
    skip
  enddo
  
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"AANO00","UPDATE OR INSERT"}
  aadd(sqlCHAVE,{"ANOEMP"})
  aadd(sqlCHAVE,{"ANOFAB"})
  aadd(sqlCHAVE,{"ANONUM"})
  aadd(sqlCAMPO,{"ANOEMP",str(ME_EMP,2)})
  aadd(sqlCAMPO,{"ANOFAB",APCA00->PCAFAB})
  aadd(sqlCAMPO,{"ANONUM",M_ANO})
  aadd(sqlCAMPO,{"ANOQDS" + strzero(val(M_MES),2),str1(M_ANOQDS,2),.f.})
  aadd(sqlCAMPO,{"ANOQDE" + strzero(val(M_MES),2),str1(M_ANOQDE,2),.f.})
  executasql()

  select APCA00

  skip

enddo

msg("* * * FIM DO PROCESSAMENTO * * *")

return ""

*****************
function PROKAR_E                      && fechamento de exercicio
*****************

private M_OPC   ,;
M_ARQ   ,;
M_DTAFEC

  rodape("FECHA","EXERCICIO",M_FAN,"EAGRO14","Mem: " + str(memory(0), 5), M_EMP)

  sombra(08, 15, 15, 64,_SOMBRA_)

  set color to GR+/W
  @ 08, 15 say "                                                 "
  @ 09, 15 say "               FECHAMENTO DE EXERCICIO           ?"
  @ 10, 15 say "                                                 ?"
  @ 11, 15 say "     Antes de executar este processo e importante?"
  @ 12, 15 say " que seja executado  os  processos  anteriores de?"
  @ 13, 15 say " Atualiza??o de  Saldo Geral,  Movimento Atual  e?"
  @ 14, 15 say " Custo M?dio.                                    ?"
  @ 15, 15 say "??????????????????????????????????????????????????"
  set color to

  store date()                 to M_DTAFEC

  set color to GR+
  @ 23, 23 say "Informe Data de Fechamento:         "
  @ 23, 51 get M_DTAFEC
  read
  set color to

  if lastkey() = 27
    return ""
  endif

  M_OPC = decide("Confirma Fechamento nesta Data")

  if M_OPC != 1
    return ""
  endif

  msw("* * * AGUARDE ... PROCESSANDO FASE 1  * * *")

  atualiza_kar()                     && atualiza saldo de inventario
  msg("* * * FIM DO FECHAMENTO * * *")

return ""

*****************
function CAB_KAR1
*****************

store PG + 1 to PG

if PG > 1
  eject
endif

? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE MOVIMENTACAO DOS PRODUTOS","EAGRO14",132)
? cent_cab(M_DATA,"","PAG.: " + str(PG, 4),132)
? "*-----------*-------*--------*------*-------------------*------*--*---------*---------*--------------*-----------------------------*"
? "*  PRODUTO  * DESC  *  DATA  * MOV  *  DESC MOVIMENTO   * DOC  *SQ*   QTDE  *  SALDO  *   VALOR      *      CLIENTE/FORNECEDOR     *"
? "*-----------*-------*--------*------*-------------------*------*--*---------*---------*--------------*-----------------------------*"

store 5 to LN

return ""

*****************
function CAB_KAR2
*****************

store PG + 1 to PG

if PG > 1
  eject
endif

? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE MOVIMENTACAO DOS PRODUTOS","EAGRO14",132)
? cent_cab(M_DATA,"","PAG.: " + str(PG, 4),132)
? "*--*-------*------*--------------------*------*--*---------*---------*--------------*---------------*---------------*--------------*"
? "*  * DATA  * MOV  *  DESC MOVIMENTO    * DOC  *SQ*   QTDE  *  SALDO  * PCO UNITARIO *  VALOR TOTAL  * SALDO FINAN   *  CUSTO MEDIO *"
? "*--*-------*------*--------------------*------*--*---------*---------*--------------*---------------*---------------*--------------*"

store 5 to LN

return ""

****************
function TLKAR01                       && monta tela
****************


nbox(08, 10, 18, 68,"W/W+",.t.)
setcolor("B/W")
*                10        20        30        40        50        60        70        80
*       0123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.
@ 09, 11 say     "  Produto   :                      Saldo:                "
@ 10, 11 say     "  Descri‡„o :                                            "
@ 11, 11 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ 12, 11 say     "  D a t a    :                  Opera‡„o:                "
@ 13, 11 say     "  Documento  :                 Sequˆncia:                "
@ 14, 11 say     "  Cliente    :                                           "
@ 15, 11 say     "  Quantidade :                Observa‡„o:                "
@ 16, 11 say     "  Vr Unit rio:                     Total:                "
@ 17, 11 say     "  Vr do Frete:                 Vr do IPI:                "
set color to

return ""


****************
function TLKAR02                      && monta tela do movimento
****************


  nbox(02, 02, 21, 77,"W/W+",.t.)
  setcolor("B/W")
    @ 03, 03 say     " Cliente  :                                                               "
    @ 04, 03 say     " C¢digo   :          Per¡odo:          a           Saldo:          C/V:   "
    @ 05, 03 say     " Descri‡„o:                                        Pre‡o:                 "
    @ 06, 03 say     "                                                                          "
    @ 07, 03 say     " Data    CodOpe   Descri‡„o    Docto  Se Sq   Qtde      Saldo    R$ Movto "
    @ 08, 03 say     "                                                                          "
    for zz = 9 to 16
    @ zz, 03 say     "                                                                          "
    next
    @ 17, 03 say     "                                                                          "
    @ 18, 03 say     "Cli/For:                                                 % Mar:           "
    @ 19, 03 say     "Vendido:            Custo:            Compra:             Icms:           "
    @ 20, 03 say     "                                                           Ipi:           "
  set color to

return ""

****************
function TLKAR03
****************


set color to I
@ 04, 02 say     "                                                                            "
@ 05, 02 say     "  C¢digo   :          Per¡odo:          a           Saldo:                  "
@ 06, 02 say     "  Descri‡„o:                                        Pre‡o:                  "
@ 07, 02 say     "ÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ 08, 02 say     " DATA ³CODFIS³    DESCRI€ŽO       ³ DOC  ³  QTDE   ³        NOME            "
@ 09, 02 say     "ÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ 10, 02 say     "      ³      ³                    ³      ³         ³                        "
@ 11, 02 say     "      ³      ³                    ³      ³         ³                        "
@ 12, 02 say     "      ³      ³                    ³      ³         ³                        "
@ 13, 02 say     "      ³      ³                    ³      ³         ³                        "
@ 14, 02 say     "      ³      ³                    ³      ³         ³                        "
@ 15, 02 say     "      ³      ³                    ³      ³         ³                        "
@ 16, 02 say     "      ³      ³                    ³      ³         ³                        "
@ 17, 02 say     "      ³      ³                    ³      ³         ³                        "
@ 18, 02 say     "ÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ 19, 02 say     "  Custo M‚dio:                                                              "
@ 20, 02 say     "                                                                            "
set color to

return ""


****************
function TLKAR04                       && monta tela 3 dolarizado
****************

sombra(04, 04, 20, 75, _SOMBRA_)

set color to I
@ 04, 04 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 05, 04 say     "³ C¢digo   :         Fab:                 Ano:        Saldo:           ³"
@ 06, 04 say     "³ Descri‡„o:                                          Media:           ³"
@ 07, 04 say     "ÃÄÄÄÄÄÄÄÄÄÂÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 08, 04 say     "³Janeiro  ³ ³                         ³ ³                              ³"
@ 09, 04 say     "³Fevereiro³Q³                         ³V³                              ³"
@ 10, 04 say     "³Mar‡o    ³u³                         ³a³                              ³"
@ 11, 04 say     "³Abril    ³a³                         ³l³                              ³"
@ 12, 04 say     "³Maio     ³n³                         ³o³                              ³"
@ 13, 04 say     "³Junho    ³t³                         ³r³                              ³"
@ 14, 04 say     "³Julho    ³i³                         ³ ³                              ³"
@ 15, 04 say     "³Agosto   ³d³                         ³ ³                              ³"
@ 16, 04 say     "³Setembro ³a³                         ³R³                              ³"
@ 17, 04 say     "³Outubro  ³d³                         ³$³                              ³"
@ 18, 04 say     "³Novembro ³e³                         ³ ³                              ³"
@ 19, 04 say     "³Dezembro ³ ³                         ³ ³                              ³"
@ 20, 04 say     "ÀÄÄÄÄÄÄÄÄÄÁÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
set color to

return ""

****************
function TLKAR05                       && monta tela 2 do kardex
****************

sombra(04, 04, 20, 75, _SOMBRA_)

set color to I
@ 04, 04 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 05, 04 say     "³ C¢digo   :         Fab:                 Ano:        Saldo:           ³"
@ 06, 04 say     "³ Descri‡„o:                                          Media:           ³"
@ 07, 04 say     "ÃÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 08, 04 say     "³Janeiro  ³                                                            ³"
@ 09, 04 say     "³Fevereiro³                                                            ³"
@ 10, 04 say     "³Mar‡o    ³                                                            ³"
@ 11, 04 say     "³Abril    ³                                                            ³"
@ 12, 04 say     "³Maio     ³                                                            ³"
@ 13, 04 say     "³Junho    ³                                                            ³"
@ 14, 04 say     "³Julho    ³                                                            ³"
@ 15, 04 say     "³Agosto   ³                                                            ³"
@ 16, 04 say     "³Setembro ³                                                            ³"
@ 17, 04 say     "³Outubro  ³                                                            ³"
@ 18, 04 say     "³Novembro ³                                                            ³"
@ 19, 04 say     "³Dezembro ³                                                            ³"
@ 20, 04 say     "ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
set color to

return ""

****************
function TLKAR06                       && monta tela 2 do kardex
****************

sombra(04, 04, 20, 75, _SOMBRA_)

set color to I
@ 04, 04 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 05, 04 say     "³ C¢digo   :                                                           ³"
@ 06, 04 say     "³ Municipio:                                          Media:           ³"
@ 07, 04 say     "ÃÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 08, 04 say     "³Janeiro  ³                                                            ³"
@ 09, 04 say     "³Fevereiro³                                                            ³"
@ 10, 04 say     "³Mar‡o    ³                                                            ³"
@ 11, 04 say     "³Abril    ³                                                            ³"
@ 12, 04 say     "³Maio     ³                                                            ³"
@ 13, 04 say     "³Junho    ³                                                            ³"
@ 14, 04 say     "³Julho    ³                                                            ³"
@ 15, 04 say     "³Agosto   ³                                                            ³"
@ 16, 04 say     "³Setembro ³                                                            ³"
@ 17, 04 say     "³Outubro  ³                                                            ³"
@ 18, 04 say     "³Novembro ³                                                            ³"
@ 19, 04 say     "³Dezembro ³                                                            ³"
@ 20, 04 say     "ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
set color to

return ""


****************
function EDKAR01
****************
SetColor( 'N/W,N/GR*,,,N/W*' )

@ 14, 26 get     M_KARCLF F2  valid vekar4() picture "######" color _CORF2_ funcao "sele_arquivo('ACLI00')" retorno @M_KARCLF
@ 15, 26 get     M_KARQDE   picture "######.###"    valid vekar6()
@ 15, 53 get     M_KARREC   picture "@!"
@ 16, 26 get     M_KARUNI   picture "###########.##"  valid vekar3()
@ 17, 26 get     M_KARDSP   picture "###########.##"
@ 17, 53 get     M_KARIPI   picture "###########.##"
read

return ""

****************
function EDKAR02                       && edita kardex
****************
SetColor( 'N/W,N/GR*,,,N/W*' )

@ 14, 26 get M_KARCLF F2  valid vekar4() picture "######" color _CORF2_ funcao "sele_arquivo('ACLI00')" retorno @M_KARCLF
@ 15, 26 get M_KARQDE   picture "######.###"
@ 15, 53 get M_KARREC   picture "@!"
@ 16, 26 get M_KARUNI   picture "###########.##"  valid vekar1()
@ 17, 26 get M_KARDSP   picture "###########.##"
@ 17, 53 get M_KARIPI   picture "###########.##"
read

return ""

****************
function GRKAR01(cACAO)
****************

sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"AKAR00",(cACAO)}

aadd(sqlCHAVE,{"KAREMP",str(ME_EMP, 2)})
aadd(sqlCHAVE,{"KARMAT",str(M_KARMAT, 6)})
aadd(sqlCHAVE,{"KARDTA",aspas(FORMATDTA(M_KARDTA))})
aadd(sqlCHAVE,{"KARFISN",M_KARFISN})
aadd(sqlCHAVE,{"KARDOC",str(M_KARDOC, 7)})
aadd(sqlCHAVE,{"KARSEQ",str(M_KARSEQ, 2)})

if !cACAO $ "#DELETE#SELECT#"
   aadd(sqlCAMPO,{"KAREMP",str(M_KAREMP,2),.t.})
   aadd(sqlCAMPO,{"KARMAT",str(M_KARMAT,6),.t.})
   aadd(sqlCAMPO,{"KARDTA",formatdta(M_KARDTA),.t.})
   aadd(sqlCAMPO,{"KARFISN",M_KARFISN,.t.})
   aadd(sqlCAMPO,{"KARDOC",str(M_KARDOC,7),.t.})
   aadd(sqlCAMPO,{"KARSEQ",str(M_KARSEQ,3),.t.})
   aadd(sqlCAMPO,{"KARQDE",str1(M_KARQDE,3),.t.})
   aadd(sqlCAMPO,{"KARQDEDC",str1(M_KARQDE*xx_FISEST,3),.t.})
   aadd(sqlCAMPO,{"KARVLI",str1(M_KARVLI,2),.t.})
   aadd(sqlCAMPO,{"KARLIQ",str1(M_KARVLI,2),.t.})
   aadd(sqlCAMPO,{"KARICM",str1(M_KARICM,2),.t.})
   aadd(sqlCAMPO,{"KARIPI",str1(M_KARIPI,2),.t.})
   aadd(sqlCAMPO,{"KARDSP",str1(M_KARDSP,2),.t.})
   aadd(sqlCAMPO,{"KARCLF",str(M_KARCLF,7),.t.})
   aadd(sqlCAMPO,{"KARSER","  ",.t.})
   aadd(sqlCAMPO,{"KARREC",M_KARREC,.t.})
endif

executasql()

return ""


****************
function MSKAR01                       && mostra kardex
****************

set color to I
@ 14, 26 say     KARCLF   picture "#######"
@ 15, 26 say     KARQDE   picture "######.###"
@ 15, 53 say     KARREC   picture "@!"
if KARQDE > 0
  @ 16, 26 say     (KARVLI / KARQDE )  picture "###########.##"
else
  @ 16, 26 say      0.00               picture "###########.##"
endif
@ 16, 53 say     KARVLI   picture "###########.##"
@ 17, 26 say     KARDSP   picture "###########.##"
@ 17, 53 say     KARIPI   picture "###########.##"
set color to

return ""

****************
function MSKAR02                       && mostra kardex
****************

select ACLI00

seek(str(AKAR00->KARCLF, 5, 0))

select AKAR00

set color to I
@ 12, 26 say     KARDTA
@ 12, 53 say     KARFISN        picture "9.999"
@ 13, 26 say     KARDOC         picture "######"
@ 13, 53 say     KARSEQ         picture "###"
@ 14, 26 say     KARCLF         picture "#####"
@ 14, 32 say left(ACLI00->CLINOM, 35)
@ 15, 26 say     KARQDE         picture "######.###"
@ 15, 53 say     KARREC         picture "@!"
if KARQDE > 0
  @ 16, 26 say (KARVLI/KARQDE) picture "###########.##"
else
  @ 16, 26 say 0.00            picture "###########.##"
endif
@ 16, 53 say     KARVLI         picture "###########.##"
@ 17, 26 say     KARDSP         picture "###########.##"
@ 17, 53 say     KARIPI         picture "###########.##"
set color to

return ""

****************
function LPKAR01                       && limpa kardex1
****************

set color to I
@ 12, 26 say     space(08)
@ 12, 53 say     space(06)
@ 13, 26 say     space(06)
@ 13, 53 say     space(02)
@ 14, 26 say     space(42)
@ 15, 26 say     space(10)
@ 15, 53 say     space(10)
@ 16, 26 say     space(14)
@ 16, 53 say     space(14)
@ 17, 26 say     space(14)
@ 17, 53 say     space(14)
set color to

return ""

***************
function VEKAR2
***************

if lastkey() = 5
  return .t.
endif

if !BUSCAREGISTRO("AFIS00",1,{str(ME_EMP, 2, 0),M_KARFISN},"SELECT")
  msg("* * * CODIGO FISCAL N?O CADASTRADO * * *")
  M_KARFISN = space(5)
  keyfun()
  return .f.
endif

tipoestoque()

msg("* * * " + alltrim(FISNOM) + " * * *")

keyfun()

return .t.

********************
function TIPOESTOQUE
********************

if FISEST == "C"
  xx_FISEST = 1
else
  if FISEST == "D"
    xx_FISEST = -1
  else
    xx_FISEST = 0
  endif
endif

return ""


***************
function VEKAR1
***************

M_KARVLI = ( M_KARUNI * M_KARQDE )

set color to I
@ 16, 53 say M_KARVLI picture "###########.##"
set color to

return .t.

***************
function VEKAR3
***************


M_KARVLI = ( M_KARUNI * M_KARQDE )

set color to I
@ 16, 26 say     M_KARUNI                  picture "###########.##"
@ 16, 53 say     M_KARVLI                  picture "###########.##"
set color to

return .t.

***************
function VEKAR4(F_LIN,F_COL)
***************

if F_LIN = NIL
  F_LIN = 0
endif

if lastkey() = 5
  return .t.
endif

if M_KARCLF = 0
  return .t.
endif

if !BUSCAREGISTRO("ACLI00",1,{str(M_KARCLF,7,0)},"SELECT")
  msg("* * * CLIENTE NÇO CADASTRADO * * *")
  M_KARCLF = 0
  return .f.
endif


set color to I
  if F_LIN = 0
    @ 14, 32 say left(CLINOM, 35)
  else
    @ F_LIN, F_COL say left(CLINOM, 35)
  endif
  set color to

keyfun()

return .t.

***************
function VEKAR5
***************

if lastkey() = 5
  return .t.
endif

if val(substr(M_PROEXE, 1, 2))  > 12 .or. val(substr(M_PROEXE, 1, 2)) < 1
  msg("* * * MES INVALIDO * * *")
  return .f.
endif

return .t.

***************
function VEKAR6
***************

if lastkey() = 5
  return .t.
endif

if M_KARQDE < 0
  return .f.
endif

BUSCAREGISTRO("ASLD00",1,{str(1, 2, 0),str(M_KARMAT, 6, 0)},"SELECT")

M_KARUNI = ASLD00->SLDCUS

return .t.

*********************
function CRIA_SLD_KAR
*********************

    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"ASLD00","INSERT"}
    DBFTOSQL("ASLD00")
    nPosarr := ascan(sqlCAMPO, {|_1| _1[1] == "SLDEMP"})
    sqlCAMPO[nPosarr][2] = str(M_KAREMP,2)
    nPosarr := ascan(sqlCAMPO, {|_1| _1[1] == "SLDMAT"})
    sqlCAMPO[nPosarr][2] = str(M_KARMAT,6)
    executasql()
    BUSCAREGISTRO("ASLD00",1,{str(ME_EMP, 2, 0),str(M_KARMAT, 6, 0)},"SELECT")

return .t.

*********************
function ATUALIZA_KAR
*********************

private M_SLD

fecha_arq()

if file("AKARTM.CDX")
  erase("AKARTM.CDX")
endif

M_EMPRESA = ME_EMP

*SELECT distinct KARMAT FROM AKAR00 where KARDTA BETWEEN '10/01/2022' and '10/24/2022' and KAREMP =  1

*  sqlRELATION = {}
*  sqlCAMPO = {}
*  sqlCHAVE =  {}
*  sqlARQUI = {}
*  sqlORDEM = {}
*  aadd(sqlARQUI,{"AKAR00","AKAR00"})
*  aadd(sqlCAMPO,"KARMAT")
*  aadd(sqlCHAVE,"KARDTA BETWEEN " + aspas(formatdta(cDATA1)) + " and " + aspas(formatdta(M_DTAINV)))
*  aadd(sqlCHAVE,"KAREMP = " + str(M_EMPRESA, 2, 0))
*  aadd(sqlCHAVE,"KARMAT = " + str(APCA00->PCAMAT, 6, 0))
*  aadd(sqlORDEM,"KARDTA,KARFIS")
*  sqlrelation()

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}
  aadd(sqlARQUI,{"APCA00","APCA00"})
  aadd(sqlCAMPO,"PCAMAT")
  aadd(sqlCAMPO,"ASLD00.SLDCUS")
  aadd(sqlCAMPO,"ASLD00.SLDDIS")
  aadd(sqlCAMPO,"ASLD00.SLDCPA")
  aadd(sqlRELATION,{"ASLD00",str(ME_EMP, 2, 0),"ASLD00.SLDEMP"})
  aadd(sqlRELATION,{"","ASLD00.SLDMAT","APCA00.PCAMAT"})
  aadd(sqlORDEM,"PCAMAT")
  sqlrelation()

  go bottom
  nTotalrec = recno()
  go top
*  oPBar2:Activate()

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}
  aadd(sqlARQUI,{"AKAR00","AKARTM"})
  aadd(sqlCAMPO,"KARMAT")
  aadd(sqlCAMPO,"KARDTA")
  cDATA1 = "KAREMP = " + str(M_EMPRESA, 2, 0)
  cDATA1 = cDATA1 + " and KARDTA < " + aspas(formatdta(M_DTAFEC))
  cDATA1 = cDATA1 + " and karfisn = '1.000'"
  aadd(sqlCHAVE,cDATA1)
  aadd(sqlORDEM,"KARMAT,KARDTA desc")
  sqlrelation()

  select AKARTM
  INDEX ON str(FIELD->KARMAT,6) TAG 1 TO AKARTM

  select APCA00


do while !eof()

*  msw("* * * AGUARDE ... PROCESSO " + str(iif(M_EMPRESA=1,1,2),1) + " -  " + transform(str(PCAMAT, 6, 0),"@R 99999-9") + " * * *")

  @ 24, 00 SAY  str((recno()/nTotalrec)*100)

  select AKARTM
  seek str(APCA00->PCAMAT,6)

  if found()
    cDATA1 = KARDTA
  else
    cDATA1 = ctod("01/01/1980")
  endif

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}
  aadd(sqlARQUI,{"AKAR00","AKAR00"})
  aadd(sqlCAMPO,"KARMAT")
  aadd(sqlCAMPO,"KARDTA")
  aadd(sqlCAMPO,"KARFISN")
  aadd(sqlCAMPO,"KARQDE")
  aadd(sqlCAMPO,"KARVLI")
  aadd(sqlCAMPO,"KARICM")
  aadd(sqlCAMPO,"KARDSP")
  aadd(sqlCAMPO,"KARIPI")
  aadd(sqlCAMPO,"KARFIS")
  aadd(sqlCAMPO,"KARDOC")
  aadd(sqlCAMPO,"AFIS00.FISCOD")
  aadd(sqlCAMPO,"AFIS00.FISEST")
  aadd(sqlCAMPO,"AFIS00.FISMED")
  aadd(sqlRELATION,{"AFIS00","AFIS00.FISEMP",str(ME_EMP,2,0)})
  *aadd(sqlRELATION,{,"AFIS00.FISNOV","AKAR00.KARFISN"})
  aadd(sqlRELATION,{,"AFIS00.FISCOD","AKAR00.KARFIS"})
  aadd(sqlCHAVE,"KARDTA BETWEEN " + aspas(formatdta(cDATA1)) + " and " + aspas(formatdta(M_DTAFEC)))
  aadd(sqlCHAVE,"KAREMP = " + str(M_EMPRESA, 2, 0))
  aadd(sqlCHAVE,"KARMAT = " + str(APCA00->PCAMAT, 6, 0))
  aadd(sqlORDEM,"KARDTA,KARFISN")
  sqlrelation()

  select AKAR00

  M_SLD    = 0
  M_SLDCME = 0
  M_SLDCMES = 0
  M_SLDFIN = 0
  M_SLDCPA = 0
  M_FLAG1  = 0
  M_FLAG2  = 0

  n_TOTSAL = 0
  n_TOTVAL = 0
  n_TOTVALS = 0

  do while !eof()

    if HB_ISNIL(KARFISN)
      msg("* * * " + str(AKAR00->KARDOC,9) + " NAO CADASTRADO * * *")
      browse()
    endif

    ****** CALCULO DE CUSTO MEDIO ******

    M_PIS = (KARVLI/100)*1.65
    M_COF = (KARVLI/100)*7.6

    if KARFISN = "1.000"
      M_SLD    = KARQDE
    else
      if FISEST = "D"
        M_SLD = M_SLD - KARQDE
      else
        if FISEST = "C"
          M_SLDANT = M_SLD
          M_SLDCME3 = M_SLDCME*M_SLD
          M_SLDCME4 = M_SLDCMES*M_SLD
          M_SLD = (M_SLD + KARQDE)

          if FISMED = "S"
            if M_SLD > 0
              M_SLDCME = round(((M_SLDCME3 + KARVLI)/M_SLD),2)
              M_SLDCMES = round(((M_SLDCME4 + (KARVLI-KARICM) - M_PIS - M_COF)/M_SLD),2)
            else
              M_SLDCME3 = 0
              M_SLDCME4 = 0
            endif
          endif
        endif
      endif
    endif

    skip

  enddo

  if M_SLDCME <= 0
    M_SLDCME = APCA00->SLDCUS
  endif

  M_SLDCME = iif(HB_ISNIL(M_SLDCME), 0,M_SLDCME)

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"AKAR00","INSERT"}
  aadd(sqlCAMPO,{"KAREMP",str(ME_EMP,2),.t.})
  aadd(sqlCAMPO,{"KARMAT",str(APCA00->PCAMAT,6),.t.})
  aadd(sqlCAMPO,{"KARDTA",formatdta(M_DTAFEC+1),.t.})
  aadd(sqlCAMPO,{"KARFISN","1.000",.t.})
  aadd(sqlCAMPO,{"KARDOC",str(1,7),.t.})
  aadd(sqlCAMPO,{"KARSER","",.t.})
  aadd(sqlCAMPO,{"KARSEQ",str(1,3),.t.})
  aadd(sqlCAMPO,{"KARQDE",str1(M_SLD,3),.t.})
  aadd(sqlCAMPO,{"KARVLI",str1(M_SLDCME,2),.t.})
  aadd(sqlCAMPO,{"KARLIQ",str1(M_SLDCME,2),.t.})
  aadd(sqlCAMPO,{"KARICM",str1(0,2),.t.})
  aadd(sqlCAMPO,{"KARIPI",str1(0,2),.t.})
  aadd(sqlCAMPO,{"KARDSP",str1(0,2),.t.})
  aadd(sqlCAMPO,{"KARCLF",str(1,7),.t.})
*  aadd(sqlCAMPO,{"KARQDEDC",str1(M_SLD,3),.t.})
  executasql()

  select APCA00
  skip

enddo

*oPBar2:DeActivate()

return ""

*****************
function CONKAR_BB
*****************

LOCAL aBlocks1 := {}

  aAdd( aBlocks1, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )

  aAdd( aBlocks1, {|| Wvt_DRAWBOXRECESSED( 02, 02, 21, 77) } )
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 06, 02, 08, 77,{+15,,-15,})})

  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 06, 02, 17, 11,{+14,,-16,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 06, 12, 17, 18,{+14,-11,-16,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 06, 19, 17, 33,{+14,-11,-16,-10})})

  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 06, 34, 17, 40,{+14,-11,-16,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 06, 41, 17, 43,{+14,-11,-16,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 06, 44, 17, 46,{+14,-11,-16,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 06, 47, 17, 56,{+14,-11,-16,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 06, 57, 17, 66,{+14,-11,-16,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 06, 67, 17, 77,{+14,-11,-16,})})

private L         ,;
M_TELA    ,;
M_TECLA

M_TELA = savescreen(01, 02, 21, 78)

tlkar02()
aLastPaint1 := WvtSetBlocks( aBlocks1 )

do while .t.

  SetColor(_COREDICAO_)

  rodape("PRODUTO", "KARDEX",M_FAN,"EAGRO14", "Mem: " + str(memory(0), 5), M_EMP)


  store 0         to  M_SLD, M_KARMAT, M_SLDVLR
  store space(30) to M_PCANOM
  store 10        to L

  M_DATA1   = firstday(date())
  M_DATA2   = lastday(date())
  M_KARTIP  = " "
  M_KARCLF = 0
  
  SetColor(_COREDICAO_)

  @ 03, 15 get M_KARCLF F2  valid vekar4(3,22) picture "#####" color _CORF2_ funcao "sele_arquivo('ACLI00')" retorno @M_KARCLF
  @ 04, 15 get M_KARMAT F2  valid verkar07() picture "######" color _CORF2_ funcao "sele_arquivo('APCA00')" retorno @M_KARMAT
  @ 04, 33 get M_DATA1
  @ 04, 44 get M_DATA2
  @ 04, 76 get M_KARTIP       picture "@!" valid(M_KARTIP $ " CV")
  read

  if (M_KARMAT = 0 .and. M_KARCLF = 0) .or. lastkey() = 27
    exit
  endif

  if M_KARCLF = 0  // se nao tem cliente calcula normal saldo
    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"AKAR00","AKAR00"})
    aadd(sqlCAMPO,"KARQDE")
    aadd(sqlCAMPO,"KARDTA")
    aadd(sqlCHAVE,"KARDTA < " + aspas(formatdta(M_DATA1)))
    aadd(sqlCHAVE,"KAREMP = " + str(ME_EMP, 2, 0))
    aadd(sqlCHAVE,"KARFISN = '1.000'")
    aadd(sqlCHAVE,"KARMAT = " + str(M_KARMAT, 6, 0))
    aadd(sqlORDEM,"KARDTA desc")

    sqlrelation()

    M_SLDANT = 0

    if lastrec() > 0
      go top
      M_SLDANT = KARQDE
      M_DTASAL = KARDTA

      sqlRELATION = {}
      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {}
      sqlORDEM = {}
      aadd(sqlARQUI,{"AKAR00","AKAR00"})
      aadd(sqlCAMPO,"KARCLF")
      aadd(sqlCAMPO,"KARFISN")
      aadd(sqlCAMPO,"KARDOC")
      aadd(sqlCAMPO,"KARSEQ")
      aadd(sqlCAMPO,"KARLIQ")
      aadd(sqlCAMPO,"KARVLI")
      aadd(sqlCAMPO,"KARDSP")
      aadd(sqlCAMPO,"KARIPI")
      aadd(sqlCAMPO,"KARQDE")
      aadd(sqlCAMPO,"KARDTA")
      aadd(sqlCAMPO,"AFIS00.FISEST")
      aadd(sqlRELATION,{"AFIS00","AFIS00.FISNOV","AKAR00.KARFISN"})
      aadd(sqlRELATION,{"","AFIS00.FISEMP","AKAR00.KAREMP"})
      aadd(sqlCHAVE,'KARDTA BETWEEN ' + aspas(formatdta(M_DTASAL)) + ' and ' + aspas(formatdta(M_DATA1-1)))
      aadd(sqlCHAVE,"KAREMP = " + str(ME_EMP, 2, 0))
      aadd(sqlCHAVE,'KARMAT = ' + str(M_KARMAT,6))
      aadd(sqlORDEM,"KARDTA,KARFISN")
      sqlrelation()
    else
      sqlRELATION = {}
      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {}
      sqlORDEM = {}

      aadd(sqlARQUI,{"AKAR00","AKAR00"})
      aadd(sqlCAMPO,"KARCLF")
      aadd(sqlCAMPO,"KARFISN")
      aadd(sqlCAMPO,"KARDOC")
      aadd(sqlCAMPO,"KARSEQ")
      aadd(sqlCAMPO,"KARLIQ")
      aadd(sqlCAMPO,"KARVLI")
      aadd(sqlCAMPO,"KARDSP")
      aadd(sqlCAMPO,"KARIPI")
      aadd(sqlCAMPO,"KARQDE")
      aadd(sqlCAMPO,"KARDTA")
      aadd(sqlCAMPO,"AFIS00.FISEST")
      aadd(sqlRELATION,{"AFIS00","AFIS00.FISNOV","AKAR00.KARFISN"})
      aadd(sqlRELATION,{"","AFIS00.FISEMP","AKAR00.KAREMP"})
      aadd(sqlCHAVE,'KARDTA < ' + aspas(formatdta(M_DATA1)))
      aadd(sqlCHAVE,"KAREMP = " + str(ME_EMP, 2, 0))
      aadd(sqlCHAVE,'KARMAT = ' + str(M_KARMAT,6))
      aadd(sqlORDEM,"KARDTA,KARFISN")
      sqlrelation()
    endif

    M_MATKAR = {}
    M_MATKAR1= {}
    M_RECKAR = {}
    M_FISKAR = {}

    M_SLD    = M_SLDANT
    M_SLDCME = 0
    M_SLDFIN = 0
    n_TOTSAL = 0
    n_TOTVAL = 0
    k_ENTRADA = 0
    k_SAIDA = 0

    R = 1

    msw("* * * AGUARDE ... PROCESSANDO (ESC) Abandona -=> " + str(R, 5) + " * * *")
    do while !eof()
      sldmed_kar()
      skip
    enddo
  else
    R = 1
    M_MATKAR = {}
    M_MATKAR1= {}
    M_RECKAR = {}
    M_FISKAR = {}
  endif


    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"AKAR00","AKAR00"})
    aadd(sqlCAMPO,"KARICM")
    aadd(sqlCAMPO,"KARSER")
    aadd(sqlCAMPO,"KARCLF")
    aadd(sqlCAMPO,"KARFISN")
    aadd(sqlCAMPO,"KARDOC")
    aadd(sqlCAMPO,"KARSEQ")
    aadd(sqlCAMPO,"KARLIQ")
    aadd(sqlCAMPO,"KARVLI")
    aadd(sqlCAMPO,"KARDSP")
    aadd(sqlCAMPO,"KARIPI")
    aadd(sqlCAMPO,"KARQDE")
    aadd(sqlCAMPO,"KARDTA")
    aadd(sqlCAMPO,"AFIS00.FISEST")
    aadd(sqlCAMPO,"AFIS00.FISNOV")
    aadd(sqlCAMPO,"AFIS00.FISNOM")
    aadd(sqlCAMPO,"COALESCE(ASLD00.SLDCPA,0) as SLDCPA")
    aadd(sqlCAMPO,"COALESCE(acli00.clinom,' ') as clinom")
    aadd(sqlCAMPO,"COALESCE(acli00.climun2,' ') as climun2")
    aadd(sqlCAMPO,"COALESCE(ACLI00.CLIUF2,' ') as cliuf2")
    aadd(sqlCAMPO,"COALESCE(afor00.fornom,' ') as fornom")
    aadd(sqlCAMPO,"COALESCE(AFOR00.FORMUN,' ') as formun")
    aadd(sqlCAMPO,"COALESCE(AFOR00.FOREST,' ') as forest")
    aadd(sqlRELATION,{"ASLD00","ASLD00.SLDEMP","AKAR00.KAREMP"})
    aadd(sqlRELATION,{"","ASLD00.SLDMAT","AKAR00.KARMAT"})
    aadd(sqlRELATION,{"AFIS00","AFIS00.FISNOV","AKAR00.KARFISN"})
    aadd(sqlRELATION,{"","AFIS00.FISEMP",str(ME_EMP,2)})
    if M_KARCLF > 0
      aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","AKAR00.KARMAT"})
      aadd(sqlCAMPO,"APCA00.PCADES")
      aadd(sqlCAMPO,"KARMAT")
    endif
    aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","AKAR00.KARCLF"})
    aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","AKAR00.KARCLF"})
    aadd(sqlCHAVE,"KAREMP = " + str(ME_EMP, 2, 0))
    if M_KARMAT > 0
      aadd(sqlCHAVE,'KARMAT = ' + str(M_KARMAT,6))
    endif
    
    if M_KARCLF > 0
      aadd(sqlCHAVE,"KARCLF = " + str(M_KARCLF, 5, 0))
      aadd(sqlCHAVE,"KARFISN in ('5.102','6.102','5.100','6.100','5.150','6.150')")
    endif

    aadd(sqlCHAVE,'KARDTA BETWEEN ' + aspas(formatdta(M_DATA1)) + ' and ' + aspas(formatdta(M_DATA2)))
    aadd(sqlORDEM,"KARDTA,KARFISN")
    sqlrelation()

  k_ENTRADA = 0
  k_SAIDA   = 0

  msw("* * * AGUARDE ... PROCESSANDO  * * *")

  do while !eof()

    if lastkey() = 27
      M_SAI = decide("Deseja Cancelar o Processamento")
      if M_SAI = 1
        exit
      endif
    endif

    M_FISEST = ""

    if M_KARCLF = 0
      sldmed_kar()

      if !empty(M_KARTIP)
        if M_KARTIP == "C"
          if !M_FISEST == "C"
            skip
            loop
          endif

          if alltrim(FISNOV) $ "#5199#1411#1000#"
            skip
            loop
          endif
        else
          if M_KARTIP == "V"
            if !M_FISEST == "D"
              skip
              loop
            endif
          endif
        endif
      endif
    endif

    if R <= 4000

      if M_KARCLF = 0
        aadd(M_MATKAR,dtoc(KARDTA) + " " + ;
        pad(KARFISN, 6) + " " + pad(FISNOM, 14) +  " " + ;
        str(KARDOC, 6, 0) + " " + KARSER +  " " + str(KARSEQ, 2, 0) + ;
        " " + str(KARQDE, 9, 2) + " " + str(M_SLD, 9, 2) + " " + ;
        transform(KARVLI,"@E ###,###.##") + " " + str(KARCLF, 7, 0) + " " ;
        + str((((KARVLI/KARQDE) / SLDCPA)-1) * 100, 12, 4) + " " + str(KARVLI/KARQDE, 12, 2) + " " + str(KARICM, 12, 2))
         aadd(M_MATKAR1,str(int(round(((KARIPI/KARVLI)*100),1)), 10, 2))
       else
        aadd(M_MATKAR,dtoc(KARDTA) + " " + ;
        pad(KARMAT, 6) + " " + pad(PCADES, 14) +  " " + ;
        str(KARDOC, 6, 0) + " " + KARSER +  " " + str(KARSEQ, 2, 0) + ;
        " " + str(KARQDE, 9, 2) + " " + str(M_SLD, 9, 2) + " " + ;
        transform(KARVLI,"@E ###,###.##") + " " + str(KARCLF, 7, 0) + " " ;
        + str((((KARVLI/KARQDE) / SLDCPA)-1) * 100, 12, 4) + " " + str(KARVLI/KARQDE, 12, 2) + " " + str(KARICM, 12, 2))
         aadd(M_MATKAR1,str(int(round(((KARIPI/KARVLI)*100),1)), 10, 2))
       endif
     
*     aadd(M_MATKAR,dtoc(KARDTA) + "³" + ;
*     transform(tira_pto(FISNOV),"@R 9.999") +  " ³" + ;
*     pad(FISNOM, 13) +  "³" + ;
*     str(KARDOC, 7, 0) + "³  ³" + ;
*     str(KARSEQ, 2, 0) + ;
*     "³" + str(KARQDE, 9, 2) + "³" + ;
*     str(M_SLD, 9, 2) + "³" + ;
*     transform(iif(KARLIQ=0,KARVLI,KARLIQ)+KARDSP+KARIPI,"@E ###,###.##") + "³" + ;
 *    str(KARCLF, 7, 0) + "³" + ;
 *    str(M_SLDFIN, 12, 2) + "³" + ;
  *   str(M_SLDCME, 12, 2))
      aadd(M_RECKAR,recno())
   *  aadd(M_FISKAR,M_FISEST)
    endif


    R ++

    select AKAR00

    skip

  enddo

  setas()

  if lastkey() = 27
    loop
  endif

  set color to GR+/N

  if M_KARCLF = 0
    @ 19, 49 say ASLD00->SLDCPA picture "@E ###,###.##"
    @ 19, 67 say M_SLDCME       picture "@E ###,###.##"
  endif
  
* @ 04, 59 say M_SLD   picture "#######.###"

  set color to

  lPoascho = 1

  do while .t.

    lAlterou = .f.

    if len(M_MATKAR) = 0
      exit
    endif

    select AKAR00
    go M_RECKAR[1]


    if M_KARCLF > 0
      @ 18, 12 say pad(substr(M_MATKAR[1], 76, 7) + " " + alltrim(PCADES), 47)
      @ 19, 30 say (KARVLI+KARDSP+KARIPI)/KARQDE picture "@E ###,###.##"
    else
    if (val(substr(M_MATKAR[1], 10, 6)) * 1000) > 5000
      set color to GR+/B+
      @ 18, 12 say pad(substr(M_MATKAR[1], 76, 7) + " " + alltrim(CLINOM) + " " + alltrim(CLIMUN2) + " " + CLIUF2, 47)
      @ 19, 30 say (KARVLI+KARDSP+KARIPI)/KARQDE picture "@E ###,###.##"
      set color to I
    else
      set color to GR+/B+
      @ 18, 12 say pad(substr(M_MATKAR[1], 76, 7) + " "  + alltrim(FORNOM) + " " + alltrim(FORMUN) + " " + FOREST, 47)
      @ 19, 30 say (KARVLI+KARDSP+KARIPI)/KARQDE picture "@E ###,###.##"
      set color to I
    endif
    endif
    
    set color to N/W,W+/N
    M_ACHO = achoice(09,03,16,76,M_MATKAR,,"achkar_a",lPoascho)

    if lastkey() = 27
      exit
    endif

  enddo

enddo

  WvtSetBlocks( aLastPaint1 )

return ""

*******************
function SLDMED_KAR
*******************

M_FISEST = ""

calc_sldmed()

return ""

********************
function CALC_SLDMED
********************

****** CALCULO DE CUSTO MEDIO ******

M_FISEST = FISEST

if KARFISN = "1.000"
  M_SLD    = KARQDE
  if KARQDE > 0                  && se quantidade igual zero
    n_TOTSAL = KARQDE
    n_TOTVAL = (KARVLI+KARDSP+KARIPI)
  else
    M_SLD    = KARQDE
    n_TOTSAL = KARQDE
    n_TOTVAL = (abs(KARVLI+KARDSP+KARIPI)/abs(KARQDE)*KARQDE)
  endif
else
  if M_FISEST == "D"
    M_SLD = M_SLD - KARQDE
    k_SAIDA   += KARQDE
  else
    if M_FISEST == "C"
      k_ENTRADA += KARQDE

      if !KARFISN $ "#5.910#" // cancelamento ou bonificacao
        M_SLDANT = M_SLD
        M_SLDCME1 = M_SLDCME*M_SLD
        M_SLD = (M_SLD + KARQDE)
        M_SLDCME = round(((M_SLDCME1 + ((KARVLI+KARDSP+KARIPI)))/M_SLD),2)

        M_SLD = M_SLDANT + KARQDE

        if M_SLDANT <= 0
          n_TOTSAL = KARQDE
          n_TOTVAL = (KARVLI+KARDSP+KARIPI)
        else
          if M_SLDCME1 = 0 // nao tinha saldo anterior
            n_TOTSAL = KARQDE
            n_TOTVAL = (KARVLI+KARDSP+KARIPI)
          else
            n_TOTSAL = 1
            n_TOTVAL = M_SLDCME
          endif
        endif
      else
        M_SLD = M_SLD + KARQDE
      endif
    endif
  endif
endif

M_SLDCME = round(n_TOTVAL/n_TOTSAL,2)

return ""

*****************
function VERKAR07
*****************

if M_KARMAT = 0 .and. M_KARCLF > 0
  return .t.
endif

BUSCAREGISTRO("ASLD00",1,{str(ME_EMP,2),str(M_KARMAT,6,0)},"SELECT")

if !BUSCAREGISTRO("APCA00",1,{str(M_KARMAT,6,0)},"SELECT")
  msg("* * * PRODUTO NÇO CADASTRADO * * *")
  M_KARMAT = 0
  keyfun()
  return .f.
endif

setcolor("I")
@ 04, 15 say     str(PCAMAT, 6, 0) picture "@R 999999"
@ 04, 59 say     ASLD00->SLDDIS   picture "#######.###"
@ 05, 15 say     pad(PCADES, 30)
@ 05, 61 say     ASLD00->SLDPRC    picture "@E ##,###,###.##"
setcolor("")

return .t.

*****************
function ACHKAR_A
*****************

parameters  M_MODO, M_ELEM, M_POSI

if str(lastkey(), 2, 0) $ "27"
  return 0
endif

lPoascho = M_ELEM

    select AKAR00
    go M_RECKAR[M_ELEM]

set color to GR+/B+

  set color to GR+/B+
  if M_LOGPRV == "S"
    @ 18, 67 say val(substr(M_MATKAR[M_ELEM],  84, 12)) picture "@E ##,###.###"
    @ 19, 12 say val(substr(M_MATKAR[M_ELEM],  97, 12)) picture "@E ###,###.##"
*   @ 19, 67 say aliq_icm() picture "@E ###,###.##"
    @ 20, 67 say M_MATKAR1[M_ELEM]
  endif
  set color to I

if M_KARCLF > 0
  @ 18, 12 say pad(str(KARMAT,6) + " " + alltrim(PCADES), 47)
  @ 19, 30 say (KARVLI+KARDSP+KARIPI)/KARQDE picture "@E ###,###.##"
else
  if (val(substr(M_MATKAR[M_ELEM], 10, 6)) * 1000) > 5000
    @ 18, 12 say pad(substr(M_MATKAR[M_ELEM], 76, 7) + " " + alltrim(CLINOM) + " " + alltrim(CLIMUN2) + " " + CLIUF2, 47)
  else
    @ 18, 12 say pad(substr(M_MATKAR[M_ELEM], 76, 7) + " "  + alltrim(FORNOM) + " " + alltrim(FORMUN) + " " + FOREST, 47)
  endif
endif

set color to I

M_LINPOS = M_POSI

return 2

function ACERTAKAR

select AKAR00
set order to 0
go top

do while !eof()

  gauge()

  if KARFIS = 0

    select ANFE00
    dbseek( str(AKAR00->KAREMP,2,0) + str(AKAR00->KARDOC,6,0),.t.)

    do while !eof()

      if !str(NFEEMP, 2, 0) + str(NFENUM, 6, 0) == str(AKAR00->KAREMP,2,0) + str(AKAR00->KARDOC,6,0)
        exit
      endif

      if !str(NFEFOR, 5, 0) == str(AKAR00->KARCLF, 5, 0)
        skip
        loop
      endif

      if AKAR00->KARDTA = ANFE00->NFEDTR
        select AKAR00
        do while .t.
          if rlock()
            replace KARFIS with ANFE00->NFENAT
            unlock
            exit
          endif
        enddo
      endif

      exit

    enddo

  endif

  select AKAR00
  skip


enddo

commit
quit
