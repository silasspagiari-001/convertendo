#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)
#INCLUDE "ptmenu.ch"
#include "inkey.CH"
#xtranslate CLEARESC() => ( __keyboard(chr(0)), inkey() )
#xtranslate ISNIL( <xValue> )       => HB_ISNIL( <xValue> )
#xtranslate ISARRAY( <xValue> )     => HB_ISARRAY( <xValue> )

#command @ <row> , <col>  GET <var> [<clauses,...>] F2 [<moreClauses,...>] funcao <func> retorno <Variavel>;
=>       @ <row> , <col>  GET <var> [<clauses>] SEND reader := {|oGet| Getf2(oGet,<func>,<Variavel>) } [<moreClauses>]

***************
function MANDCP
***************
parameters M_OPC,M_OPC1,M_OPC2


  rodape("MENU","DUPLICATA",M_FAN,"EAGRO32A","Mem: " + str(memory(0), 5),M_EMP)

*  @ 08, 48 prompt "Inclus„o " HIGHLITE R/BG SENHA 281
*  @ 09, 48 prompt "Altera‡„o" HIGHLITE R/BG SENHA 282
*  @ 10, 48 prompt "Consultas" HIGHLITE R/BG SENHA 283
*  @ 11, 48 prompt "Exclus„o " HIGHLITE R/BG SENHA 284
*  @ 12, 48 prompt "Listagens" HIGHLITE R/BG SENHA 285
*  @ 13, 48 prompt "Outros   " HIGHLITE R/BG SENHA 286

  do case
  case M_OPC = 1 ; incdcp()
  case M_OPC = 2 ; altdcp()
  case M_OPC = 3 ; condcp(M_OPC1)
  case M_OPC = 4 ; excdcp()
  case M_OPC = 5 ; lisdcp(M_OPC1)
  endcase


return ""

***************
function INCDCP
***************

do while .t.

  tldcp01()
  keyfun()

  rodape("INCLUI","DUPLICATA",M_FAN,"EAGRO32A","Mem: " + str(memory(0), 5),M_EMP)

  M_DUPEMP = ME_EMP
  M_DUPNUM = AEMP00->EMPDCP + 1
  M_DUPORD = 0
  M_DUPFOR = 0
  M_DUPDTE = ctod("  /  /  ")
  M_DUPVCT = ctod("  /  /  ")
  M_DUPVLO = 0
  M_DUPVLA = 0
  M_DUPNFS = 0
  M_DUPDTP = ctod("  /  /  ")
  M_DUPVLP = 0
  M_DUPHIS = 500
  M_DUPOBS = space(40)
  M_DUPNOM = space(40)
  M_DUPCPG = 0
  M_DUPVEN = 0
  M_DUPTXD = 0
  M_DUPAPL = 0

  SetColor( _COREDICAO_ )
  @ 08, 23 get     M_DUPNUM   picture "#########"
  @ 08, 33 get     M_DUPORD   picture "##"
  read

  if M_DUPNUM = 0 .or. lastkey() = 27
    exit
  endif

  seexistesql("ADCPID")
  cSql := "select first 1 gen_id(gen_ADCP00_"  + strzero(ME_EMP,2) + ",0) from rdb$database"  // AQUI NAO ALTERAMOS A SEQUENCIA
  dbusearea(.t.,"SQLMIX",cSql,"ADCPID")                         // PEGAMOS O ULTIMO E ACRESCENTAMOS 1
  M_DUPNUM = GEN_ID+1
  select ADCPID
  use

  setcolor("N/W*")
  @ 08, 23 say     M_DUPNUM   picture "#########"
  setcolor("")

  eddcp01()                      && edita duplicata

  if lastkey() = 27
    msg("* * * DUPLICATA NAO INCLUIDA * * *")
    loop
  endif

  do while .t.
    seexistesql("ADCPID")
    cSql := "select first 1 gen_id(gen_ADCP00_" + strzero(ME_EMP,2) + " ,1) from rdb$database"
    dbusearea(.t.,"SQLMIX",cSql,"ADCPID")
    M_DUPNUM = GEN_ID
    select ADCPID
    use
    if BUSCAREGISTRO("ADCP00",1,{str(M_DUPEMP, 2, 0),str(M_DUPNUM, 9, 0),str(M_DUPORD, 2, 0)},"SELECT")
      loop
    endif
    exit
  enddo

  grdcp01("INSERT")

  set color to I
  @ 08, 23 say   M_DUPNUM   picture "#########"
  set color to

  msg("* * * DUPLICATA INCLUIDA * * *")

enddo

return ""

***************
function ALTDCP
***************

do while .t.

  tldcp01()
  keyfun()

  rodape("ALTERA","DUPLICATA",M_FAN,"EAGRO32A","Mem: " + str(memory(0), 5),M_EMP)

  M_DUPEMP = ME_EMP
  M_DUPNUM = 0
  M_DUPHIS = 500  // nao alteramos duplicata paga
  M_DUPORD = 0
  M_DUPFOR = 0

  SetColor( _COREDICAO_ )
  @ 08, 23 get     M_DUPNUM   picture "#########"
  @ 08, 33 get     M_DUPORD   picture "##"
* @ 08, 60 get     M_DUPFOR   F2 picture "#####" valid verdcp01() funcao "sele_arquivo('AFOR00')" retorno @M_DUPFOR
  read

  if M_DUPNUM = 0
    exit
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
  aadd(sqlCHAVE,"ADCP00.DUPEMP = " + str(M_DUPEMP,2))
  aadd(sqlCHAVE,"ADCP00.DUPNUM = " + str(M_DUPNUM,9))
  aadd(sqlCHAVE,"ADCP00.DUPORD = " + str(M_DUPORD,2))
  sqlrelation()

  if eof()
    msg("* * * DUPLICATA NAO CADASTRADA * * *")
    loop
  endif

  msdcp01()                      && mostra a duplicata

  M_DUPNUM = DUPNUM
  M_DUPORD = DUPORD
  M_DUPFOR = DUPFOR
  M_DUPDTE = DUPDTE
  M_DUPVCT = DUPVCT
  M_DUPVLO = DUPVLO
  M_DUPVLA = DUPVLA
  M_DUPNFS = DUPNFS
  M_DUPDTP = iif(HB_ISNIL(DUPDTP),ctod("  /  /  "),DUPDTP)
  M_DUPVLP = DUPVLP
  M_DUPHIS = DUPHIS
  M_DUPOBS = DUPOBS
  M_DUPNOM = FORNOM
  M_DUPCPG = DUPCPG
  M_DUPVEN = DUPVEN
  M_DUPTXD = DUPTXD
  M_DUPAPL = DUPAPL

  eddcp01()

  if lastkey() = 27
    msg("* * * DUPLICATA NAO ALTERADA * * *")
    loop
  endif

  grdcp01("UPDATE")                      && regrava duplicata

  msg("* * * DUPLICATA ALTERADA * * *")

enddo

return ""

***************
function CONDCP
***************
parameters M_OPC,M_OPC1,M_OPC2


LOCAL aBlocks2 := {}
local aLastPaint7
local lSaida := .f.

if M_OPC > 1
  aAdd( aBlocks2, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
  aAdd( aBlocks2, {|| WVT_DRAWBOXGROUP( 03, 03, 05, 74,{+15,+10,-15,-10})})
  aAdd( aBlocks2, {|| WVT_DRAWBOXGROUP( 05, 03, 16, 74,{+15,+10,-15,-10})})
  aAdd( aBlocks2, {|| WVT_DRAWBOXGROUP( 16, 03, 20, 74,{+15,+10,-15,-10})})
  aAdd( aBlocks2, {|| WVT_DRAWBOXGROUP( 20, 03, 23, 74,{+15,+10,-15,-10})})
  lSaida := .t.
*  aLastPaint7 := WvtSetBlocks( aBlocks2 )
endif

private M_VCTINI ,;
M_VCTFIN ,;
M_NOMINI ,;
M_NOMFIN ,;
M_FORINI ,;
M_FORFIN ,;
M_DTEINI ,;
M_DTEFIN ,;
M_PORINI ,;
M_PORFIN ,;
M_DTPINI ,;
M_DTPFIN ,;
R        ,;
K        ,;
L

  rodape("CONSULTA","DUPLICATA",M_FAN,"EAGRO32A","Mem: " + str(memory(0), 5),M_EMP)

*  @ 11, 52 prompt   "Sequencia" HIGHLITE R/BG SENHA 287
*  @ 12, 52 prompt   "Vencidas " HIGHLITE R/BG SENHA 288
*  @ 13, 52 prompt   "Nomes    " HIGHLITE R/BG SENHA 289
*  @ 14, 52 prompt   "Codigo   " HIGHLITE R/BG SENHA 290
*  @ 15, 52 prompt   "Portador " HIGHLITE R/BG SENHA 291
*  @ 16, 52 prompt   "Pagamento" POSITION 2  HIGHLITE R/BG SENHA 292


  lPritel = .t.
  
  do case
  case M_OPC = 1
    seqdcp()
  case M_OPC = 2
    do while .t.
      tldcp03()
      if lPritel
        aLastPaint7 := WvtSetBlocks( aBlocks2 )
        lPritel = .f.
      endif
      
      set color to I
      @ 04, 06 say "Vencimento:          ate          "
      set color to
      store ctod("  /  /  ") to M_VCTINI ,;
      M_VCTFIN
      store 0                to M_TOTDUP
      SetColor(_COREDICAO_)
      @ 04, 18 get M_VCTINI
      @ 04, 31 get M_VCTFIN
      read
      if lastkey() = 27
        exit
      endif
      M_VCTINI = iif(empty(M_VCTINI),ctod("01/01/80"),M_VCTINI)
      M_VCTFIN = iif(empty(M_VCTFIN),ctod("31/12/79"),M_VCTFIN)
      mosdcp()
    enddo
  case M_OPC = 3
    do while .t.
      tldcp03()
      if lPritel
        aLastPaint7 := WvtSetBlocks( aBlocks2 )
        lPritel = .f.
      endif

      set color to I
      @ 04, 06 say "Nome:                                       "
      set color to
      store space(30) to M_NOMINI
      store 0         to M_TOTDUP
      SetColor(_COREDICAO_)
      @ 04, 12 get M_NOMINI picture "@!"
      read
      if lastkey() = 27
        exit
      endif
      M_NOMINI = iif(empty(M_NOMINI),"A"                ,M_NOMINI)
      mosdcp()
    enddo
  case M_OPC = 4
    do while .t.
      tldcp03()
      if lPritel
        aLastPaint7 := WvtSetBlocks( aBlocks2 )
        lPritel = .f.
      endif

      keyfun()
      set color to I
      @ 04, 06 say " Codigo:                     Vencimento:          ate          "
      set color to
      store ctod("  /  /  ") to M_VCTINI ,M_VCTFIN
      store 0 to M_CODINI, M_CODFIN, M_DUPFOR
      store 0                to M_TOTDUP
      SetColor(_COREDICAO_)
      @ 04, 15 get M_DUPFOR F2 picture "#####" valid fun_dcp08() funcao "sele_arquivo('AFOR00')" retorno @M_DUPFOR
      @ 04, 47 get M_VCTINI
      @ 04, 60 get M_VCTFIN
      read
      if lastkey() = 27
        exit
      endif
      M_DUPFOR = iif(M_DUPFOR=0,1    ,M_DUPFOR)
      M_VCTINI = iif(empty(M_VCTINI),ctod("01/01/80"),M_VCTINI)
      M_VCTFIN = iif(empty(M_VCTFIN),ctod("31/12/79"),M_VCTFIN)
      mosdcp()
    enddo
  case M_OPC = 5  // PORTADOR

  case M_OPC = 6
    do while .t.
      tldcp03()
      if lPritel
        aLastPaint7 := WvtSetBlocks( aBlocks2 )
        lPritel = .f.
      endif

      set color to I
      @ 04, 06 say " Pagamento:          ate          "
      set color to
      store ctod("  /  /  ") to M_DTPINI ,;
      M_DTPFIN
      store 0                to M_TOTDUP
      SetColor(_COREDICAO_)
      @ 04, 18 get M_DTPINI
      @ 04, 31 get M_DTPFIN
      read
      if lastkey() = 27
        exit
      endif
      M_DTPINI = iif(empty(M_DTPINI),ctod("01/01/80"),M_DTPINI)
      M_DTPFIN = iif(empty(M_DTPFIN),ctod("31/12/79"),M_DTPFIN)
      mosdcp()
    enddo
  endcase

if lSaida
  WvtSetBlocks( aLastPaint7 )
endif

return ""

***************
function SEQDCP
***************

private M_DUPEMP ,;
M_DUPNUM ,;
M_DUPORD

do while .t.

  tldcp01()

  M_DUPEMP = ME_EMP
  M_DUPNUM = 0
  M_DUPORD = 0
  M_DUPFOR = 0

  setcolor(_COREDICAO_)
  @ 08, 23 get     M_DUPNUM   picture "#########"
  @ 08, 33 get     M_DUPORD   picture "##"
* @ 08, 60 get     M_DUPFOR F2 picture "#####" valid verdcp01() funcao "sele_arquivo('AFOR00')" retorno @M_DUPFOR
  read

  if M_DUPNUM = 0
    exit
  endif

  seexistesql("ADCP00")
  cSQL := "SELECT ADCP00.*, AFOR00.FORNOM FROM ADCP00 "
  cSQL := cSQL + " left outer join AFOR00 on DUPFOR = AFOR00.FORCOD"
  cSQL := cSQL + " WHERE DUPNUM = " + str(M_DUPNUM, 9, 0)
  cSQL := cSQL + " and DUPEMP = " + str(ME_EMP,2)
  cSQL := cSQL + " order by DUPNUM,DUPORD"
  dbusearea(.T.,"SQLMIX",cSQL,"ADCP00")

  locate for DUPORD = M_DUPORD

  if eof()
    go top
  endif

  setas()

  do while .t.

    save get to M_GETANT
    msdcp01()
    restore get from M_GETANT

    WAITSTATE()

    if lastkey() = 27
      exit
    endif

    if (lastkey() = 5 .or. lastkey() = 19)
      skip -1
      if bof()
        go bottom
      endif
    endif

    if (lastkey() = 24 .or. lastkey() = 4)
      skip
      if eof()
        go top
      endif
    endif

  enddo

  set cursor on

enddo

return ""

***************
function MOSDCP(FTIPO)
***************

LOCAL aBlocks := {}
LOCAL aObjects:= WvtSetObjects( {} )
LOCAL aLastPaint
LOCAL cScr    := wvt_SaveScreen( 0,0,maxrow(),maxcol() )

  M_TOTDUP = 0
  M_TOTPAG = 0
  M_TOTVEN = 0
  M_TOTAVE = 0

  if !HB_ISNIL(FTIPO) .and. FTIPO == "A"
    M_AB = 1
  else
    if M_OPC < 6
      M_AB = msgbox3("Escolha uma opcao..","",,"Abertas","Pagas","Todas")
    endif
  endif
  
  if M_OPC = 2
    seexistesql("ATOTAIS")
    cSQL := "SELECT sum(DUPVLA) FROM ADCP00 WHERE DUPVCT  BETWEEN "
    cSQL := cSQL + aspas(formatdta(M_VCTINI)) + " and " + aspas(formatdta(M_VCTFIN)) +;
     " AND DUPHIS = 500 "
    cSQL := cSQL + "union ALL "
    cSQL := cSQL + "SELECT sum(DUPVLP) FROM ADCP00 WHERE DUPVCT BETWEEN "
    cSQL := cSQL + aspas(formatdta(M_VCTINI)) + " and " + aspas(formatdta(M_VCTFIN)) +;
    " AND DUPHIS = 100 "
    cSQL := cSQL + "union ALL "
    cSQL := cSQL + "SELECT sum(DUPVLA) FROM ADCR00 WHERE DUPVCT BETWEEN "
    cSQL := cSQL + aspas(formatdta(M_VCTINI)) + " and " + aspas(formatdta(M_VCTFIN)) +;
    " AND DUPHIS = 500 and ((DUPVCT - current_date) < 0) "
    cSQL := cSQL + "union ALL "
    cSQL := cSQL + "SELECT sum(DUPVLA) FROM ADCR00 WHERE DUPVCT BETWEEN "
    cSQL := cSQL + aspas(formatdta(M_VCTINI)) + " and " + aspas(formatdta(M_VCTFIN)) +;
    " AND DUPHIS = 500 and ((DUPVCT - current_date) >= 0) "

    dbusearea(.T.,"SQLMIX",cSQL,"ATOTAIS")

    M_TOTDUP = iif(HB_ISNIL(SUM),0,SUM)
    skip
    M_TOTPAG = iif(HB_ISNIL(SUM),0,SUM)
    skip
    M_TOTVEN = iif(HB_ISNIL(SUM),0,SUM)
    skip
    M_TOTAVE = iif(HB_ISNIL(SUM),0,SUM)

    seexistesql("ADCP00")
    cSQL := "SELECT ADCP00.*, AFOR00.FORNOM, AFOR00.FORTEL FROM ADCP00 "
    cSQL := cSQL + "left outer join AFOR00 ON AFOR00.FORCOD = ADCP00.DUPFOR "
    cSQL := cSQL + 'where DUPEMP > ' + aspas(str(0,2))
    cSQL := cSQL + " and DUPVCT BETWEEN " + aspas(formatdta(M_VCTINI)) + " and " + aspas(formatdta(M_VCTFIN))
    if M_AB = 3  // todas
    else
      if M_AB = 1 // abertas
        cSQL := cSQL + " and ADCP00.DUPHIS = 500"
      else
        cSQL := cSQL + " and ADCP00.DUPHIS = 100"
      endif
    endif
    cSQL := cSQL + " order by DUPVCT"

    dbusearea(.T.,"SQLMIX",cSQL,"ADCP00")

  endif

  if M_OPC = 3
    seexistesql("ADCP00")
    cSQL := "SELECT ADCP00.*, AFOR00.FORNOM, AFOR00.FORTEL FROM ADCP00 "
    cSQL := cSQL + "left outer join AFOR00 ON AFOR00.FORCOD = ADCP00.DUPFOR "
    cSQL := cSQL + 'where DUPEMP > ' + aspas(str(0,2))
    cSQL := cSQL + " and AFOR00.FORNOM LIKE '" + alltrim(M_NOMINI) + "%'"
    if M_AB = 3  // todas
    else
      if M_AB = 1 // abertas
        cSQL := cSQL + " and ADCP00.DUPHIS = 500"
      else
        cSQL := cSQL + " and ADCP00.DUPHIS = 100"
      endif
    endif
    cSQL := cSQL + " order by DUPVCT"

    dbusearea(.T.,"SQLMIX",cSQL,"ADCP00")
  endif

  if M_OPC = 4
    seexistesql("ATOTAIS")
    cSQL := "SELECT sum(DUPVLA) FROM ADCP00 WHERE DUPFOR = " + str(M_DUPFOR, 5)
    cSQL := cSQL + " and DUPVCT BETWEEN " + aspas(formatdta(M_VCTINI)) + " and " + aspas(formatdta(M_VCTFIN)) +;
     " AND DUPHIS = 500 "
    cSQL := cSQL + "union ALL "
    cSQL := cSQL + "SELECT sum(DUPVLP) FROM ADCP00 WHERE DUPFOR = " + str(M_DUPFOR, 5) + " and DUPVCT BETWEEN "
    cSQL := cSQL + aspas(formatdta(M_VCTINI)) + " and " + aspas(formatdta(M_VCTFIN)) +;
    " AND DUPHIS = 100 "
    cSQL := cSQL + "union ALL "
    cSQL := cSQL + "SELECT sum(DUPVLA) FROM ADCP00 WHERE DUPFOR = " + str(M_DUPFOR, 5) + " and DUPVCT BETWEEN "
    cSQL := cSQL + aspas(formatdta(M_VCTINI)) + " and " + aspas(formatdta(M_VCTFIN)) +;
    " AND DUPHIS = 500 and ((DUPVCT - current_date) < 0) "
    cSQL := cSQL + "union ALL "
    cSQL := cSQL + "SELECT sum(DUPVLA) FROM ADCP00 WHERE DUPFOR = " + str(M_DUPFOR, 5) + " and DUPVCT BETWEEN "
    cSQL := cSQL + aspas(formatdta(M_VCTINI)) + " and " + aspas(formatdta(M_VCTFIN)) +;
    " AND DUPHIS = 500 and ((DUPVCT - current_date) >= 0) "
    dbusearea(.T.,"SQLMIX",cSQL,"ATOTAIS")

    M_TOTDUP = iif(HB_ISNIL(SUM),0,SUM)
    skip
    M_TOTPAG = iif(HB_ISNIL(SUM),0,SUM)
    skip
    M_TOTVEN = iif(HB_ISNIL(SUM),0,SUM)
    skip
    M_TOTAVE = iif(HB_ISNIL(SUM),0,SUM)
    seexistesql("ADCP00")
    cSQL := "SELECT ADCP00.*, AFOR00.FORNOM, AFOR00.FORTEL FROM ADCP00 "
    cSQL := cSQL + "left outer join AFOR00 ON AFOR00.FORCOD = ADCP00.DUPFOR "
    cSQL := cSQL + "where DUPEMP in (1,10,2) and DUPFOR = " + str(M_DUPFOR, 5)
    cSQL := cSQL + " and DUPVCT BETWEEN " + aspas(formatdta(M_VCTINI)) + " and " + aspas(formatdta(M_VCTFIN))
    if M_AB = 3  // todas
    else
      if M_AB = 1 // abertas
        cSQL := cSQL + " and ADCP00.DUPHIS = 500"
      else
        cSQL := cSQL + " and ADCP00.DUPHIS = 100"
      endif
    endif
    cSQL := cSQL + " order by DUPFOR,DUPVCT"

    dbusearea(.T.,"SQLMIX",cSQL,"ADCP00")
  endif

  if M_OPC = 5
  endif

  if M_OPC = 6
    cSQL := "SELECT sum(DUPVLP) FROM ADCP00 WHERE DUPDTP BETWEEN "
    cSQL := cSQL + aspas(formatdta(M_DTPINI)) + " and " + aspas(formatdta(M_DTPFIN)) +;
    " AND DUPHIS = 100 "
    dbusearea(.T.,"SQLMIX",cSQL,"ATOTAIS")
    M_TOTPAG = iif(HB_ISNIL(SUM),0,SUM)

    cSQL := "SELECT ADCP00.*, AFOR00.FORNOM, AFOR00.FORTEL FROM ADCP00 "
    cSQL := cSQL + "left outer join AFOR00 ON AFOR00.FORCOD = ADCP00.DUPFOR "
    cSQL := cSQL + "where DUPEMP in (1,10,2) "
    cSQL := cSQL + " and DUPDTP BETWEEN " + aspas(formatdta(M_DTPINI)) + " and " + aspas(formatdta(M_DTPFIN))
    cSQL := cSQL + " order by DUPDTP"
    dbusearea(.T.,"SQLMIX",cSQL,"ADCP00")
  endif

setcolor("W+/BG")
@ 21, 15 say transform(M_TOTDUP,"@E #,###,###.##")
@ 22, 15 say transform(M_TOTPAG,"@E #,###,###.##")

@ 21, 50 say transform(M_TOTVEN,"@E #,###,###.##")
@ 22, 50 say transform(M_TOTAVE,"@E #,###,###.##")

cARQUIVO = "ADCP00"
select ADCP00
go top


cColor  := SetColor( 'N/W,W/N+,W/R,W/G,N/W*,GR+/BG,R/W,G/W' )

oBrowse := TBrowseDB():New(6, 4,15,73 )

aBlocks := {}
oBrowse:addColumn(TBColumnNew("Titulo",&("{||TRAN(DUPNUM,[@R 999999999])}")))
oBrowse:addColumn(TBColumnNew("Ord",&("{||TRAN(DUPORD,[@R 999])}")))
oBrowse:addColumn(TBColumnNew("Emissao",&("{|| iif(!HB_ISNIL(DUPDTE),dtoc(DUPDTE),'  /  /  ')}")))
oBrowse:addColumn(TBColumnNew("Vencto",&("{|| iif(!HB_ISNIL(DUPVCT),dtoc(DUPVCT),'  /  /  ')}")))
oBrowse:addColumn(TBColumnNew("Pgto",&("{|| iif(!HB_ISNIL(DUPDTP),dtoc(DUPDTP),'  /  /  ')}")))
oBrowse:addColumn(TBColumnNew("Valor",&("{||TRAN( iif(DUPVLA=0,DUPVLP,DUPVLA),[@R 99999,999.99])}")))
oBrowse:addColumn(TBColumnNew("For",&("{||TRAN(DUPFOR,[@R 99999])}")))
*oBrowse:addColumn(TBColumnNew("Por",&("{||TRAN(DUPPOR,[@R 999])}")))
oBrowse:addColumn(TBColumnNew("Atr",&('{||iif(DUPHIS = 100,"PAGA",str((DUPVCT - date()),4))}')))

oBrowse:GetColumn(1):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(2):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(3):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(4):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(5):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(6):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(7):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
*oBrowse:GetColumn(8):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }
oBrowse:GetColumn(8):colorBlock := { |x| If( DUPHIS = 500, iif( DUPVCT < date(), { 7, 7 },{ 8, 8 }), { 1, 2 } ) }

oBrowse:ColSep        := 'º'
oBrowse:HeadSep       := 'Ð'
oBrowse:GoTopBlock    := { || dbGoTop() }
oBrowse:GoBottomBlock := { || dbGoBottom() }
oBrowse:SkipBlock     := { | nSkip | dbSkipBlock( nSkip,oBrowse ) }
oBrowse:freeze := 1
oBrowse:colPos := 1
oBrowse:configure()

Wvt_SetPen( 0, 2, rgb( 244,244,244 ) )

lKeyWaiting := .F.
lBrowse := .T.
lPosrecloc = 0
NpOSIC = { }
cPosic = ""
nc = 1

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
  @ 17, 10 say pad(FORNOM , 40)
  @ 17, 58 say padl(alltrim(FORTEL), 14)
  @ 18, 10 say pad(DUPOBS , 40)
  @ 18, 58 say DUPVLO picture "@E ###,###,###.##"
  @ 19, 58 say DUPDSC picture "@E ###,###,###.##"

*  oBrowse:colPos := 1

   do while .t.
     nKey := nInKey(1)
     if nKey # 0
       exit
     endif
   enddo

   if nKey == K_F2
      nIndex := IndexOrd()
      nIndex++
      if nIndex > 3
         nIndex := 1
      endif
      Set Order To ( nIndex )
      oBrowse:RefreshAll()
   endif


*   IF NKEY # 24
*     ALTD()
*   ENDIF
   
   do case
    CASE (nKey == 27)
      lBrowse := .F.

    CASE (nKey == K_ENTER)
      if !HB_ISNIL(FTIPO) .and. FTIPO == "A"
        lBrowse := .F.
        exit
      endif

      aBlocks2 := {}
      aObjects2:= WvtSetObjects( {} )
      aLastPaint2 := WvtSetBlocks( aBlocks2 )

      BUSCAREGISTRO("AFOR00",1,{str(ADCP00->DUPFOR,5,0)},"SELECT")
      M_TELA = savescreen(02, 04, 22, 77)
      tldcp02()
      msdcp02()
      set cursor off
      inkey(0)
      set cursor on
      restscreen(02, 04, 22, 77, M_TELA)

      WvtSetBlocks( aLastPaint2 )
      WvtSetObjects( aObjects2 )

      select ADCP00 // &cARQUIVO

                */*/*/
                
    case nKey = 526  // K_CTRL_N // CTR + N
      if BUSCAREGISTRO("ANFE00",1,{str(ADCP00->DUPEMP, 2, 0),str(ADCP00->NFENUM, 9, 0) ,aspas(ADCP00->NFESER),str(ADCP00->DUPFOR, 7, 0)},"SELECT")
        select ADCP00
        lTelloc = WVT_savescreen(0,0,maxrow(),maxcol())
*        lTelloc = savescreen(0,0,maxrow(),maxcol())

 *        WVT_restscreen(01, 01, 23, 81, M_TELA)

        M_NFEEMP = DUPEMP
        M_NFENUM = NFENUM
        M_NFESER = NFESER
        M_NFEFOR = DUPFOR
        lAlteranfe = .f.
        lAltite = .f.
        lPosnfe = 0
        nLinnfe = 2

        CONNFE("PAGAR")
        select ADCP00
        wvt_restscreen(0,0,maxrow(),maxcol(),lTelloc)
*        restscreen(0,0,maxrow(),maxcol(),lTelloc)
      endif
      

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

   end

   Wvt_SetPen( 0 )
   WvtSetBlocks( aLastPaint )
   WvtSetObjects( aObjects )
   SetColor( cColor )
   wvt_RestScreen( 0, 0, maxrow(), maxcol(), cScr )

return ""

***************
function EXCDCP
***************

private M_DUPEMP ,;
M_DUPNUM ,;
M_DUPORD ,;
M_OPC

do while .t.

  tldcp01()

  rodape("EXCLUI","DUPLICATA",M_FAN,"EAGRO32A","Mem: " + str(memory(0), 5),M_EMP)

  M_DUPEMP = ME_EMP
  M_DUPNUM = 0
  M_DUPORD = 0
  M_DUPFOR = 0

  SetColor( _COREDICAO_ )
  @ 08, 23 get     M_DUPNUM   picture "#########"
  @ 08, 33 get     M_DUPORD   picture "##"
  @ 08, 60 get     M_DUPFOR F2 picture "#####" valid verdcp01() funcao "sele_arquivo('AFOR00')" retorno @M_DUPFOR
  read

  if M_DUPNUM = 0
    exit
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
  aadd(sqlCHAVE,"ADCP00.DUPEMP = " + str(M_DUPEMP,2))
  aadd(sqlCHAVE,"ADCP00.DUPNUM = " + str(M_DUPNUM,9))
  aadd(sqlCHAVE,"ADCP00.DUPORD = " + str(M_DUPORD,2))
  aadd(sqlCHAVE,"ADCP00.DUPFOR = " + str(M_DUPFOR,5))
  sqlrelation()

  if eof()
    msg("* * * DUPLICATA NAO CADASTRADA * * *")
    loop
  endif

  msdcp01()


  do while .t.
    M_OPC = msgbox3("Confirma Exclusao da Duplicata ?",,18,"Escolha","Sim","Nao")
    if M_OPC > 1
      exit
    endif
  enddo

  if M_OPC != 2
    msg("* * * DUPLICATA NAO EXCLUIDA * * *")
    loop
  endif

  if lastkey() = 27
    msg("* * * DUPLICATA NAO EXCLUIDA * * *")
    loop
  endif


  grdcp01("DELETE")


  msg("* * * DUPLICATA EXCLUIDA * * *")

enddo

return ""

***************
function LISDCP
***************
LOCAL aBlocks2 := {}
local aLastPaint7

parameters M_OPC

aAdd( aBlocks2, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
aLastPaint7 := WvtSetBlocks( aBlocks2 )

  rodape("LISTA","DUPLICATA",M_FAN,"EAGRO32A","Mem: " + str(memory(0), 5),M_EMP)
*  @ 11, 52 prompt   "Sequencia" HIGHLITE R/BG SENHA 293
*  @ 12, 52 prompt   "Vencidas " HIGHLITE R/BG SENHA 294
*  @ 13, 52 prompt   "Nomes    " HIGHLITE R/BG SENHA 295
*  @ 14, 52 prompt   "Codigo   " HIGHLITE R/BG SENHA 296
*  @ 15, 52 prompt   "Portador " HIGHLITE R/BG SENHA 297
*  @ 16, 52 prompt   "Pagamento" POSITION 2  HIGHLITE R/BG SENHA 298
*  @ 17, 52 prompt   "Emissao  " POSITION 2  HIGHLITE R/BG SENHA 299

  do case
  case M_OPC = 1
    lisdcp_a()
  case M_OPC = 2
    lisdcp_b()
  case M_OPC = 3
    lisdcp_c()
  case M_OPC = 4
    lisdcp_d()
  case M_OPC = 5
  case M_OPC = 6
    lisdcp_f()
  case M_OPC = 7
    lisdcp_g()
  endcase

  WvtSetBlocks( aLastPaint7 )

return ""

*****************
function LISDCP_A
*****************

LOCAL aBlocks := {}
local aLastPaint
parameters M_OPC
aAdd( aBlocks, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
aLastPaint := WvtSetBlocks( aBlocks )

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

store 0   to M_OPC
store "N" to M_QUE
M_ABPGTO = "      "

do while .t.

  rodape("DUPLICATA","VENCIMENTO",M_FAN,"EAGRO32A","Mem: " + str(memory(0), 5),M_EMP)

  nbox(10, 70-3, 14, 96-3,"W/BG+",.t.)
  set color to W/BG+

  @ 11, 71-3 say "Vencto Inicial:         "
  @ 12, 71-3 say "         Final:         "
  @ 13, 71-3 say "      Situa‡Æo:         "


  SetColor( _COREDICAO_ )

  store ctod("  /  /  ")        to M_VCTINI
  store ctod("  /  /  ")        to M_VCTFIN
  @ 11, 87-3 get M_VCTINI   F2 color _CORF2_ funcao "pegadata(11,87-3,@M_VCTINI)" retorno "re"
  @ 12, 87-3 get M_VCTFIN   F2 color _CORF2_ funcao "pegadata(12,87-3,@M_VCTFIN)" retorno "re"
  @ 13, 87-3 get M_ABPGTO when abpgto(@M_ABPGTO,14,87-3)
  read

  if lastkey() = 27 .or. empty(M_ABPGTO)
    exit
  endif

  M_AB = val(left(M_ABPGTO,1))

  if lastkey() = 27
    exit
  endif

  M_VCTINI = iif(dtoc(M_VCTINI) = "  /  /  ",ctod("01/01/80"),M_VCTINI)
  M_VCTFIN = iif(dtoc(M_VCTFIN) = "  /  /  ",ctod("31/12/79"),M_VCTFIN)

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ADCP00","ADCP00"})
  aadd(sqlCAMPO,"ADCP00.*")
  aadd(sqlCAMPO,"AFOR00.FOREST")
  aadd(sqlCAMPO,"AFOR00.FORNOM")
  aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","ADCP00.DUPFOR"})
  aadd(sqlCHAVE,"DUPVCT BETWEEN " + aspas(formatdta(M_VCTINI)) + ' and ' + aspas(formatdta(M_VCTFIN)))
  aadd(sqlCHAVE,"ADCP00.DUPEMP = " + str(ME_EMP,2))

  if M_AB = 3  // todas
  else
    if M_AB = 1 // abertas
      aadd(sqlCHAVE,"ADCP00.DUPHIS = 500")
    else
      aadd(sqlCHAVE,"ADCP00.DUPHIS = 100")
    endif
  endif
  aadd(sqlORDEM,"DUPVCT")

  sqlrelation()

  M_ARQI  = substr(time(),4,2) + substr(time(),7,2) + ".RPT"
  M_IMPRE = impresn()

  if M_IMPRE = "N"
    exit
  endif

  if M_IMPRE = "Z"
    set print on
    set printer to &M_ARQI
    set console off
  endif

  F_LNFIN = 56

  if !M_IMPRE == "Z"
    ?? chr(15)                        && comprime
  else
    F_LNFIN = 99
  endif

  store 0    to PG ,;
  M_GERDUP,;
  M_TOTDUP

  store ctod("  /  /  ")  to M_VCTANT

  if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
    ?? chr(15)                         && comprime
  endif

  do while !eof()

    store PG + 1 to PG

    if PG > 1
      ?
      eject
    endif

    ? cent_cab(AEMP00->EMPFAN,"RELACAO DE DUPLICATAS POR VENCIMENTO","EAGRO32A",132)
    ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
    ?     "*---------*----------------------------------------------*--*---------------*--------*--------*--------*-----------------*-------*"
    ?     "* DUPLIC  * F O R N E C E D O R                          *UF*   OBSERVACAO  * EMISSAO* VENCTO * PAGTO  * VALOR DUPLICATA * PRAZO *"
    ?     "*---------*----------------------------------------------*--*---------------*--------*--------*--------*-----------------*-------*"
    *                  999999/99 99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99    ###,###,###.## 9999999

    store 5 to LN

    do while !eof() .and.  LN < F_LNFIN

      if M_QUE = "S"
        if DUPVCT != M_VCTANT
          M_VCTANT = DUPVCT
          if M_TOTDUP > 0
            ?     space(65)
            ?? "TOTAL DO VENCIMENTO (AB) -=>     "
            ?? "     R$ "
            ?? transform(M_TOTDUP, "@E ####,###,###.##")
            ?     replicate("-", 132)
          endif
          ? " "
          ?? DUPVCT
          ?? " - "
          ?? SEMANA[dow(DUPVCT)]
          ?
          store 0 to M_TOTDUP
          LN = LN + 4

        endif
      endif

      ?  " "
      ?? str(DUPNUM,9)
      ?? "/"
      ?? strzero(DUPORD, 2, 0)
      ?? " "
      ?? str(DUPFOR,5)
      ?? " "
      ?? left(FORNOM , 37)
      ?? " "
      ?? FOREST
      ?? " "
      ?? pad(DUPOBS, 15)
      ?? " "
      ?? DUPDTE
      ?? " "
      ?? DUPVCT
      ?? " "
      ?? iif(HB_ISNIL(DUPDTP),ctod("  /  /  "),DUPDTP)
      ?? "    "
      ?? iif(DUPVLA=0,transform(DUPVLO,"@E ###,###,###.##"),transform(DUPVLA,"@E ###,###,###.##"))
      ?? " "
      ?? " "
      ?? "  "
      ??  iif(DUPHIS = 500,str((DUPVCT - date()), 5, 0),"PAGA ")

      if DUPHIS = 500
        M_GERDUP = M_GERDUP + DUPVLA
        M_TOTDUP = M_TOTDUP + DUPVLA
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

  ?    replicate("-", 132)
  ?     space(65)
  ?? "TOTAL DO VENCIMENTO (AB) -=>     "
  ?? "     R$ "
  ?? transform(M_TOTDUP, "@E ####,###,###.##")
  ?     replicate("-", 132)
  ?     space(68)
  ?? "TOTAL G E R A L  (AB) -=>     "
  ?? "     R$ "
  ?? transform(M_GERDUP, "@E ####,###,###.##")
  ?     replicate("-",132)

  ?

  if !M_IMPRE == "Z"
    eject
    ?? chr(18)                        && descomprime
  endif

  set print off
  set printer to
  set console on
  set cursor on

  if !M_IMPRE == "Z"
    desliga1()
  else
    desliga1(140)
  endif

enddo

WvtSetBlocks( aLastPaint)

return ""

*****************
function LISDCP_B
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

store 0   to M_OPC
store "S" to M_QUE

do while .t.

  rodape("DUPLICATA","VENCIMENTO",M_FAN,"EAGRO32A","Mem: " + str(memory(0), 5),M_EMP)

  nbox(16, 20, 20, 45,"W/BG+",.t.)
  set color to W/BG+
  @ 17, 21 say "Vencto Inicial:         "
  @ 18, 21 say "         Final:         "
  @ 19, 21 say " Quebra Vencto:         "
  SetColor( _COREDICAO_ )

  store ctod("  /  /  ")        to M_VCTINI
  store ctod("  /  /  ")        to M_VCTFIN
  @ 17, 37 get M_VCTINI
  @ 18, 37 get M_VCTFIN
  @ 19, 37 get M_QUE valid(M_QUE="S" .or. M_QUE= "N")
  read

  if lastkey() = 27
    exit
  endif

  M_AB = msgbox3(,,,"Aberto","Pagas","Todas")

  if lastkey() = 27
    exit
  endif

  M_VCTINI = iif(dtoc(M_VCTINI) = "  /  /  ",ctod("01/01/80"),M_VCTINI)
  M_VCTFIN = iif(dtoc(M_VCTFIN) = "  /  /  ",ctod("31/12/79"),M_VCTFIN)

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ADCP00","ADCP00"})
  aadd(sqlCAMPO,"ADCP00.*")
  aadd(sqlCAMPO,"AFOR00.FOREST")
  aadd(sqlCAMPO,"AFOR00.FORNOM")
  aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","ADCP00.DUPFOR"})
  aadd(sqlCHAVE,"DUPVCT BETWEEN " + aspas(formatdta(M_VCTINI)) + ' and ' + aspas(formatdta(M_VCTFIN)))
  aadd(sqlCHAVE,"ADCP00.DUPEMP = " + str(ME_EMP,2))

  if M_AB = 3  // todas
  else
    if M_AB = 1 // abertas
      aadd(sqlCHAVE,"ADCP00.DUPHIS = 500")
    else
      aadd(sqlCHAVE,"ADCP00.DUPHIS = 100")
    endif
  endif
  aadd(sqlORDEM,"DUPVCT")

  sqlrelation()

  M_ARQI  = substr(time(),4,2) + substr(time(),7,2) + ".RPT"
  M_IMPRE = impresn()

  if M_IMPRE = "N"
    exit
  endif

  if M_IMPRE = "Z"
    set print on
    set printer to &M_ARQI
    set console off
  endif

  F_LNFIN = 56

  if !M_IMPRE == "Z"
    ?? chr(15)                        && comprime
  else
    F_LNFIN = 99
  endif

  store 0    to PG ,;
  M_GERDUP,;
  M_TOTDUP

  store ctod("  /  /  ")  to M_VCTANT

  if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
    ?? chr(15)                         && comprime
  endif

  do while !eof()

    store PG + 1 to PG

    if PG > 1
      ?
      eject
    endif

    ? cent_cab(AEMP00->EMPFAN,"RELACAO DE DUPLICATAS POR VENCIMENTO","EAGRO32A",132)
    ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
    ?     "*---------*----------------------------------------------*--*---------------*--------*--------*--------*-----------------*-------*"
    ?     "* DUPLIC  * F O R N E C E D O R                          *UF*   OBSERVACAO  * EMISSAO* VENCTO * PAGTO  * VALOR DUPLICATA * PRAZO *"
    ?     "*---------*----------------------------------------------*--*---------------*--------*--------*--------*-----------------*-------*"
    *                  999999/99 99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99    ###,###,###.## 9999999

    store 5 to LN

    do while !eof() .and.  LN < F_LNFIN

      if M_QUE = "S"
        if DUPVCT != M_VCTANT
          M_VCTANT = DUPVCT
          if M_TOTDUP > 0
            ?     space(65)
            ?? "TOTAL DO VENCIMENTO (AB) -=>     "
            ?? "     R$ "
            ?? transform(M_TOTDUP, "@E ####,###,###.##")
            ?     replicate("-", 132)
          endif
          ? " "
          ?? DUPVCT
          ?? " - "
          ?? SEMANA[dow(DUPVCT)]
          ?
          store 0 to M_TOTDUP
          LN = LN + 4

        endif
      endif

      ?  " "
      ?? str(DUPNUM,9)
      ?? "/"
      ?? strzero(DUPORD, 2, 0)
      ?? " "
      ?? str(DUPFOR,5)
      ?? " "
      ?? left(FORNOM , 37)
      ?? " "
      ?? FOREST
      ?? " "
      ?? pad(DUPOBS, 15)
      ?? " "
      ?? DUPDTE
      ?? " "
      ?? DUPVCT
      ?? " "
      ?? iif(HB_ISNIL(DUPDTP),ctod("  /  /  "),DUPDTP)
      ?? "    "
      ?? iif(DUPVLA=0,transform(DUPVLO,"@E ###,###,###.##"),transform(DUPVLA,"@E ###,###,###.##"))
      ?? " "
      ?? " "
      ?? "  "
      ??  iif(DUPHIS = 500,str((DUPVCT - date()), 5, 0),"PAGA ")

      if DUPHIS = 500
        M_GERDUP = M_GERDUP + DUPVLA
        M_TOTDUP = M_TOTDUP + DUPVLA
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

  ?    replicate("-", 132)
  ?     space(65)
  ?? "TOTAL DO VENCIMENTO (AB) -=>     "
  ?? "     R$ "
  ?? transform(M_TOTDUP, "@E ####,###,###.##")
  ?     replicate("-", 132)
  ?     space(68)
  ?? "TOTAL G E R A L  (AB) -=>     "
  ?? "     R$ "
  ?? transform(M_GERDUP, "@E ####,###,###.##")
  ?     replicate("-",132)

  ?

  if !M_IMPRE == "Z"
    eject
    ?? chr(18)                        && descomprime
  endif

  set print off
  set printer to
  set console on
  set cursor on

  if !M_IMPRE == "Z"
    desliga1()
  else
    desliga1(140)
  endif

enddo

return ""

*****************
function LISDCP_C
*****************
private M_FORANT,;
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

store 0   to M_OPC
store "S" to M_QUE

do while .t.

  rodape("DUPLICATA","ALFABETICA",M_FAN,"EAGRO32A","Mem: " + str(memory(0), 5),M_EMP)

  nbox(16, 10, 19, 46,"W/BG+",.t.)
  set color to W/BG+
  @ 17, 11 say "    N o m e  :                     "
  @ 18, 11 say "Quebra Nome  :                     "
  SetColor( _COREDICAO_ )
  store space(40) to M_NOMINI
  store space(40) to M_NOMFIN
  @ 17, 26 get M_NOMINI picture "@!@S20"
  @ 18, 26 get M_QUE valid(M_QUE="S" .or. M_QUE= "N")
  read

  if lastkey() = 27
    exit
  endif

  M_AB = msgbox3(,,,"Aberto","Pagas","Todas")

  if lastkey() = 27
    exit
  endif

  M_NOMINI = iif(empty(M_NOMINI),"A"             ,M_NOMINI)

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ADCP00","ADCP00"})
  aadd(sqlCAMPO,"ADCP00.*")
  aadd(sqlCAMPO,"AFOR00.FORTEL")
  aadd(sqlCAMPO,"AFOR00.FORMUN")
  aadd(sqlCAMPO,"AFOR00.FOREST")
  aadd(sqlCAMPO,"AFOR00.FOREND")
  aadd(sqlCAMPO,"AFOR00.FOREST")
  aadd(sqlCAMPO,"AFOR00.FORNOM")
  aadd(sqlCAMPO,"APOR00.PORNOM")
  aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","ADCP00.DUPFOR"})
  aadd(sqlCHAVE,"ADCP00.DUPEMP = " + str(ME_EMP,2))

  if M_AB = 3  // todas
  else
    if M_AB = 1 // abertas
      aadd(sqlCHAVE,"ADCP00.DUPHIS = 500")
    else
      aadd(sqlCHAVE,"ADCP00.DUPHIS = 100")
    endif
  endif
  aadd(sqlORDEM,"AFOR00.FORNOM,DUPVCT")

  if !M_NOMINI = space(40)
    aadd(sqlCHAVE,"AFOR00.FORNOM LIKE '" + alltrim(M_NOMINI) + "%'")
  endif

  sqlrelation()

  M_ARQI  = substr(time(),4,2) + substr(time(),7,2) + ".RPT"
  M_IMPRE = impresn()

  if M_IMPRE = "N"
    exit
  endif

  if M_IMPRE = "Z"
    set print on
    set printer to &M_ARQI
    set console off
  endif

  F_LNFIN = 56

  if !M_IMPRE == "Z"
    ?? chr(15)                        && comprime
  else
    F_LNFIN = 99
  endif

  store 0         to PG      ,;
  M_TOTDUP,;
  M_GERDUP

  store space(30) to M_FORANT

  do while !eof()

    store PG + 1 to PG

    if PG > 1
      eject
    endif

    ? cent_cab(AEMP00->EMPFAN,"RELACAO DE DUPLICATAS ALFABETICA","EAGRO32A",132)
    ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
    ?     "*---------*----------------------------------------------*--*---------------*--------*--------*--------*-----------------*-*-------*"
    ?     "* DUPLIC  * F O R N E C E D O R                          *UF*   OBSERVACAO  * EMISSAO* VENCTO * PAGTO  * VALOR DUPLICATA * * PRAZO *"
    ?     "*---------*----------------------------------------------*--*---------------*--------*--------*--------*-----------------*-*-------*"
    *                  999999/99 99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99    ###,###,###.##   9999999


    store 5 to LN

    do while !eof() .and. LN < F_LNFIN

      if M_QUE = "S"
        if !FORNOM == M_FORANT
          M_FORANT = FORNOM
          if  M_TOTDUP > 0
            ? space(65)
            ?? "TOTAL DO FORNECEDOR (AB) -=>     "
            ?? "     R$ "
            ?? transform(M_TOTDUP, "@E ####,###,###.##")
            ?     replicate("-", 132)
          endif
          ?
          ?? DUPFOR
          ?? " - "
          ?? FORNOM
          ?? " "
          ?? FOREND
          ?? " "
          ?? FORMUN
          ?? " "
          ?? FOREST
          ?? " "
          ?? FORTEL
          ?
          store 0 to M_TOTDUP
          LN = LN + 4
        endif
      endif

      ?  " "
      ?? str(DUPNUM,9)
      ?? "/"
      ?? strzero(DUPORD, 2, 0)
      ?? "      "
      ?? " "
      ?? left(PORNOM , 37)
      ?? "    "
      ?? pad(DUPOBS, 15)
      ?? " "
      ?? DUPDTE
      ?? " "
      ?? DUPVCT
      ?? " "
      ?? iif(HB_ISNIL(DUPDTP),ctod("  /  /  "),DUPDTP)
      ?? "    "
      ?? iif(DUPVLA=0,transform(DUPVLO,"@E ###,###,###.##"),transform(DUPVLA,"@E ###,###,###.##"))
      ?? " "
      ?? " "
      ?? "  "
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

  ?    replicate("-", 132)
  ?     space(65)
  ?? "TOTAL DO FORNECEDOR (AB) -=>     "
  ?? "     R$ "
  ?? transform(M_TOTDUP, "@E ####,###,###.##")
  ?     replicate("-", 132)
  ?     space(68)
  ?? "TOTAL G E R A L  (AB) -=>     "
  ?? "     R$ "
  ?? transform(M_GERDUP, "@E ####,###,###.##")
  ?     replicate("-",132)

  ?

  if !M_IMPRE == "Z"
    eject
    ?? chr(18)                        && descomprime
  endif

  set print off
  set printer to
  set console on
  set cursor on

  if !M_IMPRE == "Z"
    desliga1()
  else
    desliga1(140)
  endif

enddo

return ""

*****************
function LISDCP_D                       && relacao por CODIGO DE FORNECEDOR
*****************

private M_FORANT,;
M_TOTFOR,;
M_FORINI,;
M_FORFIN,;
M_TOTAL ,;
M_TELA  ,;
M_TELA1 ,;
LN      ,;
PG      ,;
M_OPC   ,;
M_ESC

store 0   to M_OPC
store "S" to M_QUE

do while .t.

  rodape("DUPLICATA","FORNECEDOR",M_FAN,"EA0RO31A","Mem: " + str(memory(0), 5),M_EMP)

  nbox(16, 23, 19, 46,"W/BG+",.t.)
  set color to W/BG+
  @ 17, 24 say " Fornecedor....:      "
  @ 18, 24 say " Quebra Fornec.:      "
  set color to

  store 0 to M_FORINI ,;
  M_FORFIN

  SetColor( _COREDICAO_ )
  @ 17, 41 get M_FORINI F2 picture "#####"   funcao "sele_arquivo('AFOR00')" retorno @M_FORINI
  @ 18, 41 get M_QUE valid(M_QUE="S" .or. M_QUE= "N")
  read

  if lastkey() = 27
    exit
  endif

  M_AB = msgbox3(,,,"Aberto","Pagas","Todas")

  if lastkey() = 27
    exit
  endif

  M_FORINI = iif(M_FORINI = 0,     1,M_FORINI)

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ADCP00","ADCP00"})
  aadd(sqlCAMPO,"ADCP00.*")
  aadd(sqlCAMPO,"AFOR00.FORTEL")
  aadd(sqlCAMPO,"AFOR00.FORMUN")
  aadd(sqlCAMPO,"AFOR00.FOREST")
  aadd(sqlCAMPO,"AFOR00.FOREND")
  aadd(sqlCAMPO,"AFOR00.FOREST")
  aadd(sqlCAMPO,"AFOR00.FORNOM")
  aadd(sqlCAMPO,"APOR00.PORNOM")
  aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","ADCP00.DUPFOR"})
  aadd(sqlCHAVE,"ADCP00.DUPEMP = " + str(ME_EMP,2))

  if M_FORINI > 0
    aadd(sqlCHAVE,"ADCP00.DUPFOR = " + str(M_FORINI,5))
  endif

  if M_AB = 3  // todas
  else
    if M_AB = 1 // abertas
      aadd(sqlCHAVE,"ADCP00.DUPHIS = 500")
    else
      aadd(sqlCHAVE,"ADCP00.DUPHIS = 100")
    endif
  endif
  aadd(sqlORDEM,"DUPFOR,DUPVCT")

  sqlrelation()

  M_ARQI  = substr(time(),4,2) + substr(time(),7,2) + ".RPT"
  M_IMPRE = impresn()

  if M_IMPRE = "N"
    exit
  endif

  if M_IMPRE = "Z"
    set print on
    set printer to &M_ARQI
    set console off
  endif

  F_LNFIN = 56

  if !M_IMPRE == "Z"
    ?? chr(15)                        && comprime
  else
    F_LNFIN = 99
  endif

  store 0    to PG      ,;
  M_FORANT,;
  M_TOTDUP,;
  M_GERDUP

  do while !eof()

    store PG + 1 to PG

    if PG > 1
      eject
    endif

    ? cent_cab(AEMP00->EMPFAN,"RELACAO DE DUPLICATAS POR FORNECEDOR","EREC40",132)
    ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
    ?     "*---------*----------------------------------------------*--*---------------*--------*--------*--------*-----------------*-------*"
    ?     "* DUPLIC  * P O R T A D O R                              *UF*   OBSERVACAO  * EMISSAO* VENCTO * PAGTO  * VALOR DUPLICATA * PRAZO *"
    ?     "*---------*----------------------------------------------*--*---------------*--------*--------*--------*-----------------*-------*"
    *                  999999/99 99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99    ###,###,###.## 9999999

    store 5 to LN

    do while !eof() .and. LN < F_LNFIN

      if M_QUE = "S"
        if DUPFOR != M_FORANT
          M_FORANT = DUPFOR
          if M_TOTDUP > 0
            ?     space(65)
            ?? "TOTAL DO FORNECEDOR (AB) -=>     "
            ?? "     R$ "
            ?? transform(M_TOTDUP, "@E ####,###,###.##")
            ?     replicate("-", 132)
          endif
          ?
          ?? DUPFOR
          ?? " - "
          ?? FORNOM
          ?? " "
          ?? FORMUN
          ?? " "
          ?? FOREST
          ?? " "
          ?? FORTEL
          ?
          store 0 to M_TOTDUP
          LN = LN + 4
        endif
      endif

      ?  " "
      ?? str(DUPNUM,9)
      ?? "/"
      ?? strzero(DUPORD, 2, 0)
      ?? "      "
      ?? " "
      ?? left(PORNOM , 37)
      ?? "    "
      ?? pad(DUPOBS, 15)
      ?? " "
      ?? DUPDTE
      ?? " "
      ?? DUPVCT
      ?? " "
      ?? iif(HB_ISNIL(DUPDTP),ctod("  /  /  "),DUPDTP)
      ?? "    "
      ?? iif(DUPVLA=0,transform(DUPVLO,"@E ###,###,###.##"),transform(DUPVLA,"@E ###,###,###.##"))
      ?? " "
      ?? " "
      ?? "  "
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


  ?    replicate("-", 132)
  ?     space(65)
  ?? "TOTAL DO FORNECEDOR (AB) -=>     "
  ?? "     R$ "
  ?? transform(M_TOTDUP, "@E ####,###,###.##")
  ?     replicate("-", 132)
  ?     space(68)
  ?? "TOTAL G E R A L  (AB) -=>     "
  ?? "     R$ "
  ?? transform(M_GERDUP, "@E ####,###,###.##")
  ?     replicate("-",132)
  ?

  if !M_IMPRE == "Z"
    eject
    ?? chr(18)                        && descomprime
  endif

  set print off
  set printer to
  set console on
  set cursor on
  set relation to
  set order to 1


  if !M_IMPRE == "Z"
    desliga1()
  else
    desliga1(140)
  endif

enddo

return ""

*****************
function LISDCP_F
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

store 0   to M_OPC
store "S" to M_QUE

do while .t.

  rodape("DUPLICATA","PAGAMENTO",M_FAN,"EAGRO32A","Mem: " + str(memory(0), 5),M_EMP)

  nbox(16, 31, 20, 56,"W/BG+",.t.)
  set color to W/BG+
  @ 17, 32 say "Pagto Inicial :         "
  @ 18, 32 say "        Final :         "
  @ 19, 32 say "Quebra Pagto  :         "
  set color to

  store ctod("  /  /  ")        to M_DTPINI
  store ctod("  /  /  ")        to M_DTPFIN

  SetColor( _COREDICAO_ )
  @ 17, 48 get M_DTPINI
  @ 18, 48 get M_DTPFIN
  @ 19, 48 get M_QUE valid(M_QUE="S" .or. M_QUE= "N")
  read

  if lastkey() = 27
    exit
  endif

  M_DTPINI = iif(dtoc(M_DTPINI) = "  /  /  ",ctod("01/01/80"),M_DTPINI)
  M_DTPFIN = iif(dtoc(M_DTPFIN) = "  /  /  ",ctod("31/12/79"),M_DTPFIN)

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ADCP00","ADCP00"})
  aadd(sqlCAMPO,"ADCP00.*")
  aadd(sqlCAMPO,"AFOR00.FOREST")
  aadd(sqlCAMPO,"AFOR00.FORNOM")
  aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","ADCP00.DUPFOR"})
  aadd(sqlCHAVE,"DUPDTP BETWEEN " + aspas(formatdta(M_DTPINI)) + ' and ' + aspas(formatdta(M_DTPFIN)))
  aadd(sqlCHAVE,"ADCP00.DUPEMP = " + str(ME_EMP,2))
  aadd(sqlCHAVE,"ADCP00.DUPHIS = 100")
  aadd(sqlORDEM,"DUPDTP")

  sqlrelation()

  M_ARQI  = substr(time(),4,2) + substr(time(),7,2) + ".RPT"
  M_IMPRE = impresn()

  if M_IMPRE = "N"
    exit
  endif

  if M_IMPRE = "Z"
    set print on
    set printer to &M_ARQI
    set console off
  endif

  F_LNFIN = 56

  if !M_IMPRE == "Z"
    ?? chr(15)                        && comprime
  else
    F_LNFIN = 99
  endif

  store 0         to PG      ,;
  M_TOTDUP,;
  M_GERDUP

  store ctod("  /  /  ")  to M_DTPANT

  do while !eof()

    store PG + 1 to PG

    if PG > 1
      ?
      eject
    endif

    ? cent_cab(AEMP00->EMPFAN,"RELACAO DE DUPLICATAS POR PAGAMENTO","EAGRO32A",132)
    ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
    ?     "*---------*----------------------------------------------*--*---------------*--------*--------*--------*-----------------*-------*"
    ?     "* DUPLIC  * F O R N E C E D O R                          *UF*   OBSERVACAO  * EMISSAO* VENCTO * PAGTO  * VALOR DUPLICATA * PRAZO *"
    ?     "*---------*----------------------------------------------*--*---------------*--------*--------*--------*-----------------*-------*"
    *                  999999/99 99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99    ###,###,###.## 9999999

    store 5 to LN

    do while !eof() .and. LN < F_LNFIN

      if DUPHIS != 100
        skip
        loop
      endif

      if M_QUE = "S"
        if DUPDTP != M_DTPANT
          M_DTPANT = DUPDTP
          if M_TOTDUP > 0
            ?     space(65)
            ?? "TOTAL DO PAGAMENTO       -=>     "
            ?? "     R$ "
            ?? transform(M_TOTDUP, "@E ####,###,###.##")
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

      ?  " "
      ?? str(DUPNUM,9)
      ?? "/"
      ?? strzero(DUPORD, 2, 0)
      ?? " "
      ?? str(DUPFOR,5)
      ?? " "
      ?? left(FORNOM , 37)
      ?? " "
      ?? FOREST
      ?? " "
      ?? pad(DUPOBS, 15)
      ?? " "
      ?? DUPDTE
      ?? " "
      ?? DUPVCT
      ?? " "
      ?? iif(HB_ISNIL(DUPDTP),ctod("  /  /  "),DUPDTP)
      ?? "    "
      ?? iif(DUPVLP=0,transform(DUPVLO,"@E ###,###,###.##"),transform(DUPVLP,"@E ###,###,###.##"))
      ?? " "
      ?? " "
      ?? "  "
      ??  iif(DUPHIS = 500,str((DUPVCT - date()), 5, 0),"PAGA ")

      M_TOTDUP = M_TOTDUP + DUPVLP
      M_GERDUP = M_GERDUP + DUPVLP

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
  ?? "TOTAL DO PAGAMENTO       -=>     "
  ?? "     R$ "
  ?? transform(M_TOTDUP, "@E ####,###,###.##")
  ?     replicate("-", 132)
  ?     space(68)
  ?? "TOTAL G E R A L       -=>     "
  ?? "     R$ "
  ?? transform(M_GERDUP, "@E ####,###,###.##")
  ?     replicate("-",132)
  ?

  if !M_IMPRE == "Z"
    eject
    ?? chr(18)                        && descomprime
  endif

  set print off
  set printer to
  set console on
  set cursor on

  if !M_IMPRE == "Z"
    desliga1()
  else
    desliga1(140)
  endif

enddo

return ""

*****************
function LISDCP_G
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

store 0   to M_OPC
store "S" to M_QUE

do while .t.

  rodape("DUPLICATA","EMISSAO",M_FAN,"EAGRO32A","Mem: " + str(memory(0), 5),M_EMP)

  nbox(16, 31, 20, 56,"W/BG+",.t.)
  set color to W/BG+
  @ 17, 32 say "Emis  Inicial :         "
  @ 18, 32 say "        Final :         "
  @ 19, 32 say "Quebra Pagto  :         "
  set color to

  store ctod("  /  /  ")        to M_DTPINI
  store ctod("  /  /  ")        to M_DTPFIN
  SetColor( _COREDICAO_ )
  @ 17, 48 get M_DTPINI
  @ 18, 48 get M_DTPFIN
  @ 19, 48 get M_QUE valid(M_QUE="S" .or. M_QUE= "N")
  read

  if lastkey() = 27
    exit
  endif

  M_AB = msgbox3("Escolha uma opcao..","",,"Abertas","Pagas","Todas")

  if lastkey() = 27
    exit
  endif

  M_DTPINI = iif(dtoc(M_DTPINI) = "  /  /  ",ctod("01/01/80"),M_DTPINI)
  M_DTPFIN = iif(dtoc(M_DTPFIN) = "  /  /  ",ctod("31/12/79"),M_DTPFIN)

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ADCP00","ADCP00"})
  aadd(sqlCAMPO,"ADCP00.*")
  aadd(sqlCAMPO,"AFOR00.FOREST")
  aadd(sqlCAMPO,"AFOR00.FORNOM")
  aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","ADCP00.DUPFOR"})
  aadd(sqlCHAVE,"DUPDTE BETWEEN " + aspas(formatdta(M_DTPINI)) + ' and ' + aspas(formatdta(M_DTPFIN)))
  aadd(sqlCHAVE,"ADCP00.DUPEMP = " + str(ME_EMP,2))
  aadd(sqlCHAVE,"ADCP00.DUPHIS = 100")
  aadd(sqlORDEM,"DUPDTE")
  sqlrelation()

  M_ARQI  = substr(time(),4,2) + substr(time(),7,2) + ".RPT"
  M_IMPRE = impresn()

  if M_IMPRE = "N"
    exit
  endif

  if M_IMPRE = "Z"
    set print on
    set printer to &M_ARQI
    set console off
  endif

  F_LNFIN = 60

  if !M_IMPRE == "Z"
    ?? chr(15)                        && comprime
  else
    F_LNFIN = 99
  endif

  store 0         to PG      ,;
  M_TOTDUP,;
  M_GERDUP

  store ctod("  /  /  ")  to M_DTPANT

  do while !eof()

    store PG + 1 to PG

    if PG > 1
      eject
    endif

    ? cent_cab(AEMP00->EMPFAN,"RELACAO DE DUPLICATAS POR PAGAMENTO","EAGRO32A",132)
    ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
    ?     "*---------*----------------------------------------------*--*---------------*--------*--------*--------*-----------------*-------*"
    ?     "* DUPLIC  * F O R N E C E D O R                          *UF*   OBSERVACAO  * EMISSAO* VENCTO * PAGTO  * VALOR DUPLICATA * PRAZO *"
    ?     "*---------*----------------------------------------------*--*---------------*--------*--------*--------*-----------------*-------*"
    *                  999999/99 99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99    ###,###,###.## 9999999

    store 5 to LN

    do while !eof() .and. LN < 56

      if M_QUE = "S"
        if DUPDTE != M_DTPANT
          M_DTPANT = DUPDTE
          if M_TOTDUP > 0
            ?     space(65)
            ?? "TOTAL DUPLICATAS         -=>     "
            ?? "     R$ "
            ?? transform(M_TOTDUP, "@E ####,###,###.##")
            ?     replicate("-", 132)

          endif
          ? " "
          ?? DUPDTE
          ?? " - "
          ?? SEMANA[dow(DUPDTE)]
          ?
          store 0 to M_TOTDUP
          LN = LN + 4
        endif
      endif

      ?  " "
      ?? str(DUPNUM,9)
      ?? "/"
      ?? strzero(DUPORD, 2, 0)
      ?? " "
      ?? str(DUPFOR,5)
      ?? " "
      ?? left(FORNOM , 37)
      ?? " "
      ?? FOREST
      ?? " "
      ?? pad(DUPOBS, 15)
      ?? " "
      ?? DUPDTE
      ?? " "
      ?? DUPVCT
      ?? " "
      ?? iif(HB_ISNIL(DUPDTP),ctod("  /  /  "),DUPDTP)
      ?? "    "
      ?? iif(DUPVLP=0,transform(DUPVLO,"@E ###,###,###.##"),transform(DUPVLP,"@E ###,###,###.##"))
      ?? " "
      ?? " "
      ?? "  "
      ??  iif(DUPHIS = 500,str((DUPVCT - date()), 5, 0),"PAGA ")

      M_TOTDUP = M_TOTDUP + DUPVLO
      M_GERDUP = M_GERDUP + DUPVLO

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
  ?? "TOTAL G E R A L  (AB) -=>     "
  ?? "     R$ "
  ?? transform(M_GERDUP, "@E ####,###,###.##")
  ?     replicate("-",132)

  ?

  if !M_IMPRE == "Z"
    eject
    ?? chr(18)                        && descomprime
  endif

  set print off
  set printer to
  set console on
  set cursor on

  if !M_IMPRE == "Z"
    desliga1()
  else
    desliga1(140)
  endif

enddo

return ""

****************
function TLDCP01
****************

nbox(07, 13, 18, 66,"W/W+",.t.)
setcolor("B/W")
@ 08, 14 say     " Dupl.:           /              Fornecedor:        "
@ 09, 14 say     " Nome     :                                         "
@ 10, 14 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ 11, 14 say     " Emissao  :                  Vencimento:            "
@ 12, 14 say     " Portador :                                         "
@ 13, 14 say     " O b s    :                                         "
@ 14, 14 say     " Original :                   Atual:                "
@ 15, 14 say     " Pagamento:              Valor Pago:                "
@ 16, 14 say     "                         Valor Nota:                "
@ 17, 14 say     "                                                    "

set color to

return ""

****************
function EDDCP01
****************

SetColor( _COREDICAO_ )


@ 08, 60 get     M_DUPFOR   F2 picture "#####" valid verdcp01() funcao "sele_arquivo('AFOR00')" retorno @M_DUPFOR
@ 11, 26 get     M_DUPDTE  F2 color _CORF2_ valid(M_DUPDTE != ctod("  /  /  ")) funcao "pegadata(11,26,@M_DUPDTE)" retorno "re"
@ 11, 57 get     M_DUPVCT  F2 color _CORF2_ valid(M_DUPVCT != ctod("  /  /  ")) funcao "pegadata(11,26,@M_DUPVCT)" retorno "re"

*@ 12, 58 get     M_DUPTXD picture "##.####"
@ 13, 26 get     M_DUPOBS picture "@!"

@ 14, 26 get     M_DUPVLO picture "#########.##"      valid verdcp03()
@ 14, 51 get     M_DUPVLA picture "#########.##"

@ 15, 26 get     M_DUPDTP picture "#########.##"
@ 15, 51 get     M_DUPVLP picture "#########.##"
*@ 16, 26 get     M_DUPAPL picture "###"               valid verdcp06()
@ 16, 51 get     M_DUPNFS picture "#########.##"

*@ 17, 26 get     M_DUPCPG picture "###"               valid verdcp04()
*@ 17, 51 get     M_DUPVEN picture "###"               valid verdcp05()
read

return ""

****************
function MSDCP01
****************


M_DUPDTP = iif(HB_ISNIL(DUPDTP),ctod("  /  /  "),DUPDTP)

SetColor( _COREDICAO_ )
@ 08, 23 say     DUPNUM         picture "#########"
@ 08, 33 say     DUPORD         picture "##"
@ 08, 60 say     DUPFOR   picture "#####"
@ 09, 26 say     FORNOM   picture "@S39"
@ 11, 26 say     DUPDTE
@ 11, 57 say     DUPVCT
@ 13, 26 say     DUPOBS
@ 14, 26 say     DUPVLO   picture "#########.##"
@ 14, 51 say     DUPVLA   picture "#########.##"
@ 15, 26 say     M_DUPDTP
@ 15, 51 say     DUPVLP   picture "#########.##"
@ 16, 51 say     DUPNFS   picture "#########.##"
set color to

return ""

****************
function GRDCP01(cACAO)
****************

sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"ADCP00",cACAO}

aadd(sqlCHAVE,{"DUPEMP",str(M_DUPEMP)})
aadd(sqlCHAVE,{"DUPNUM",str(M_DUPNUM)})
aadd(sqlCHAVE,{"DUPORD",str(M_DUPORD)})
aadd(sqlCHAVE,{"DUPFOR",str(M_DUPFOR)})

if !cACAO $ "#DELETE#SELECT#"
  aadd(sqlCAMPO,{"DUPEMP",str(M_DUPEMP),.t.})
  aadd(sqlCAMPO,{"DUPNUM",str(M_DUPNUM),.t.})
  aadd(sqlCAMPO,{"DUPORD",str(M_DUPORD),.t.})
  aadd(sqlCAMPO,{"DUPFOR",str(M_DUPFOR),.t.})
  aadd(sqlCAMPO,{"DUPDTE",formatdta(M_DUPDTE),.t.})
  aadd(sqlCAMPO,{"DUPVCT",formatdta(M_DUPVCT),.t.})
  aadd(sqlCAMPO,{"DUPVLO",str1(M_DUPVLO,2),.t.})
  aadd(sqlCAMPO,{"DUPVLA",str1(M_DUPVLA,2),.t.})
  aadd(sqlCAMPO,{"DUPNFS",str1(M_DUPNFS,2),.t.})
  aadd(sqlCAMPO,{"DUPDTP",formatdta(M_DUPDTP),.t.})
  aadd(sqlCAMPO,{"DUPVLP",str1(M_DUPVLP,2),.t.})
  aadd(sqlCAMPO,{"DUPHIS",str(M_DUPHIS),.t.})
  aadd(sqlCAMPO,{"DUPOBS",M_DUPOBS,.t.})
  aadd(sqlCAMPO,{"DUPNOM",M_DUPNOM,.t.})
endif
executasql()

return ""


******************
function VERDCP01
******************

if lastkey() = 5
  return .t.
endif

if M_DUPFOR = 0
  return .f.
endif

if !BUSCAREGISTRO("AFOR00",1,{str(M_DUPFOR,5,0)},"SELECT")
  msg("* * * FORNECEDOR NAO CADASTRADO * * *")
  return .f.
endif

set color to I
@ 09, 26 say left(FORNOM, 39)
set color to

M_DUPNOM = FORNOM

return .t.


******************
function VERDCP03
******************

if lastkey() = 5
  return .t.
endif

if M_DUPVLO = 0
  return .f.
endif

if M_OPC = 1
  M_DUPVLA = M_DUPVLO
endif

return .t.

******************
function VERDCP04
******************

if lastkey() = 5
  return .t.
endif

if M_DUPCPG = 0
  return .f.
endif

select ACPG00

if !dbseek(str(M_DUPCPG, 3, 0))
  msg("* * * CONDICAO DE PAGAMENTO NAO CADASTRADO * * *")
  return .f.
endif

msg(alltrim(CPGDES))

return .t.

*****************
function VERDCP05
*****************

if lastkey() = 5
  return .t.
endif

if M_DUPVEN = 0
  return .f.
endif

select AVEN00

if !dbseek(str(M_DUPVEN, 3, 0))
  msg("* * * VENDEDOR NAO CADASTRADO * * *")
  return .f.
endif

msg(alltrim(VENNOM))

return .t.


****************
function TLDCP02
****************

sombra(07, 13, 17, 66, _SOMBRA_)

set color to BG+/B+
@ 07, 13 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄDados de CobrancaÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 08, 13 say     "³ Codigo  :             Cgc/Cpf:                     ³"
@ 09, 13 say     "³ Nome    :                                          ³"
@ 10, 13 say     "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 11, 13 say     "³ Endereco:                                          ³"
@ 12, 13 say     "³ Bairro  :                            Cep:          ³"
@ 13, 13 say     "³ Cidade  :                             Uf:          ³"
@ 14, 13 say     "³ Telefone:                   Telex:                 ³"
@ 15, 13 say     "³ Fax     :                 Contato:                 ³"
@ 16, 13 say     "³ Tipo    :                     IES:                 ³"
@ 17, 13 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
set color to

return ""

****************
function MSDCP02
****************

set color to GR+/B+
@ 08, 25 say     FORCOD picture "#####"
@ 08, 46 say     FORCGC picture "@R 999.999.999/9999-99"
@ 09, 25 say     left(FORNOM, 40)
@ 11, 25 say     FOREND
@ 12, 25 say     FORBAI
@ 12, 57 say     FORCEP
@ 13, 25 say     FORMUN
@ 13, 63 say     FOREST
@ 14, 25 say     FORTEL
@ 14, 50 say     space(15)
@ 15, 25 say     FORFAX
@ 16, 50 say     FORIES
set color to

return ""

****************
function TLDCP03
****************
nbox(03, 03, 23, 74,"W/W+",.t.)
setcolor("W+/W")

@ 04, 04 say     "                                                                      "
@ 05, 04 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ 06, 04 say     "                                                                      "
@ 07, 04 say     "                                                                      "
@ 08, 04 say     "                                                                      "
@ 09, 04 say     "                                                                      "
@ 10, 04 say     "                                                                      "
@ 11, 04 say     "                                                                      "
@ 12, 04 say     "                                                                      "
@ 13, 04 say     "                                                                      "
@ 14, 04 say     "                                                                      "
@ 15, 04 say     "                                                                      "
@ 16, 04 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
setcolor("N/W")
@ 17, 04 say     "Nome:                                         Fone   :                "
@ 18, 04 say     "Obse:                                         Valor  :                "
@ 19, 04 say     "    :                                         Descont:                "
@ 20, 04 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
*nbox(20, 03, 23, 74,"W/W+",.t.)
setcolor("W+/W")
@ 20, 04 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
setcolor("N/W")
@ 21, 04 say     "   Aberto:                         Vencidos:                          "
@ 22, 04 say     "     Pago:                         A Vencer:                          "
set color to

return ""

*****************
function VISUALCP
*****************

parameters V1

private R      ,;
M_OPC  ,;
M_AREA ,;
M_TELA

M_AREA = alias()

*selecao()

do while .t.

  set color to GR+/R+,N/BG
  M_OPC = achoice(10,58,18,62,V1,,"mostra")
  set color to

  if rat(str(lastkey(), 2, 0)," 3#27#18") > 0
    exit
  endif

  select AFOR00

  if dbseek(V1[M_OPC])
    M_TELA = savescreen(07, 13, 18, 67)
    tldcp02()
    msdcp02()
    ( setcursor(0) , inkey(0) , setcursor(1) )
    restscreen(07, 13, 18, 67, M_TELA)
  else
    msg("* * * FORNECEDOR NAO CADASTRADO * * *")
  endif

enddo

select &M_AREA


return lastkey()

******************
function FUN_DCP08
******************

if M_DUPFOR > 0
  M_CODINI = M_DUPFOR
  M_CODFIN = M_DUPFOR
endif

return .t.
