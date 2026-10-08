/* Desenvolvido por :
Analista/Programador : Scilas Spajares Antonio
Contato              : 18 8807-0590
scilas@hotmail.com.br
Objetivo : ler arquivo danfe formato xml e fazer o lancemento
de nota fiscal
*/
#command @ <row> , <col>  GET <var> [<clauses,...>] F2 [<moreClauses,...>] funcao <func> retorno <Variavel>;
=>       @ <row> , <col>  GET <var> [<clauses>] SEND reader := {|oGet| Getf2(oGet,<func>,<Variavel>) } [<moreClauses>]

****************
function LERDANF
****************

local cDirSpec := "C:\XML\*.XML"
local aDirectory := {}
local aFileInfo := {}
local nHandle := 0
local nBuffSize := 16                   // Read/write buffer size
local lLfnSupport := .F.                // Are LFNs supported?
local l7143Supp := .F.                  // Is function 7143h supported?
local nBytes := 0                       // Bytes copied
local nTotBytes := 0                    // Total bytes copied
local nSeconds := 0                     // For timing the job
mDiretorio := 'C:\XML\'
iDiretorio := 'C:\XML\NFEI\'  // IMPORTADOS
mArquivo   := '*.XML'
mListaArq  := Directory(mDiretorio+mArquivo,"D")
cLista     := {}
aCODFOR    := ""
A_CODFOR   := { }
A_CGCFOR   := ""
lLeu2 = .f.

fecha_arq()
lTRANSPORTE = .f.

aFileInfo := DIRECTORY(cDirSpec)

if file("DANFE.CDX")
  erase("DANFE.CDX")
endif

select 0
use DANFE exclusive
zap

for ABC = 1 to len(aFileInfo)
  aadd(aDirectory,aFileInfo)
  cNomeForne := PegaNomeArquivo(mDiretorio+aFileInfo[ABC,1])
  cFileDanfe := mDiretorio+aFileInfo[ABC,1]

  if !cNomeForne == "ERRO"
*  Linha       := Memoread(cFileDanfe)
    Aadd(cLista,cNomeForne)
    select DANFE
    replace DIRE01 with mDiretorio+aFileInfo[ABC,1]
    replace DIRE02 with iDiretorio+aFileInfo[ABC,1]
  endif
next

select DANFE
index on DATA to DANFE

cLista     := {}
cPosic     := {}
go bottom
do while !bof()
  aadd(cLista,DESCRICAO)
  aadd(cPosic,recno())
  skip -1
enddo

setcolor("B/W")
nbox(04,09,21,71,"W/W+",.t.)
set color to N/W,W+/N
nOpcao  := Achoice(05,10,20,70,cLista,.t.)
set color to

If nOpcao== 0
  Return Nil
Endif

select DANFE
go cPosic[nOpcao]
cFileDanfe := DIRE01
iFileDanfe := DIRE02

//    cFileDanfe := mDiretorio+aDirectory[nOpcao,1]
//    iFileDanfe := iDiretorio+aDirectory[nOpcao,6]         // IMPORTADO NOME EXTENSO

If cFileDanfe==Nil
  msgbox1('Informe o nome do Danfe em xml')
  Return nil
Endif

If !file(cFileDanfe)
  msgbox1('Arquivo nao Localizado'+cFileDanfe)
  Return nil
Endif

If LastKey()==27
  Return nil
Endif

Linha       := Memoread(cFileDanfe)
nLinhalidas := 0
Linhatotal  := Len(Linha)
cLinhaTxt   := Linha

**** adicinado

lLeu2 = .f.

if Linhatotal = 0
  lerxml2()
  lLeu2 = .t.
  Locate for "Id=" $ ARQUIVO->NOME
  Linha = ARQUIVO->NOME
endif

//-- Pega Id da Nota Fiscal
nPos1 := At('Id="',Linha)
If nPos1==0
  msgbox1('Erro no Arquivo '+cFileDanfe+Chr(10)+'Id=')
  Return nil
Endif
nPos1 := nPos1+Len('Id="')
cChave:= Substr(Linha,nPos1,47)

lTRANSPORTEF = .f.
c_MUNINI = ""
c_MUNFIM = ""

cMUNREN      := ''
cMUNDEST     := ''

if "CTE" $ upper(cChave)
  lTRANSPORTE := .t.  // conhecimento de transporte
endif

//-- Pegando Cgc para Pesquisa do Item na base de SKus

if lLeu2
  Locate for "<CNPJ>" $ ARQUIVO->NOME
  Linha = ARQUIVO->NOME
endif

nPos1 := At('<CNPJ>',Linha)
If nPos1==0
  msgbox1('Erro no Arquivo '+cFileDanfe)
  Return nil
Endif

nPos1   := nPos1+Len('<CNPJ>')
cCGCEmit:= Substr(Linha,nPos1,14)


if lTRANSPORTE .or. cCGCEmit == "57832180000195"
  InicioDoDado := '<emit>'
  FinalDoDado  := '</emit>'
  nPosIni      := At(InicioDoDado,Linha)
  nPosFim      := At(FinalDoDado,Linha)
  cRet3         := '0'

  If nPosIni==0 .or. nPosFim==0
  else
    cRet3       := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
  endif
  nPos1 := At('<CNPJ>',cRet3)
  nPos1   := nPos1+Len('<CNPJ>')
  cCGCEmit:= Substr(cRet3,nPos1,14)

  InicioDoDado := '<rem>'
  FinalDoDado  := '</rem>'
  nPosIni      := At(InicioDoDado,Linha)
  nPosFim      := At(FinalDoDado,Linha)
  cMUNREN      := ''

  If nPosIni==0 .or. nPosFim==0
  else
    cMUNREN := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
    InicioDoDado := '<cMun>'
    FinalDoDado  := '</cMun>'
    nPosIni      := At(InicioDoDado,Linha)
    nPosFim      := At(FinalDoDado,Linha)
    cMUNREN := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
  endif

  InicioDoDado := '<dest>'
  FinalDoDado  := '</dest>'
  nPosIni      := At(InicioDoDado,Linha)
  nPosFim      := At(FinalDoDado,Linha)
  cMUNDEST     := ''

  If nPosIni==0 .or. nPosFim==0
  else
    cMUNDEST := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
    InicioDoDado := '<cMun>'
    FinalDoDado  := '</cMun>'
    nPosIni      := At(InicioDoDado,Linha)
    nPosFim      := At(FinalDoDado,Linha)
    cMUNDEST := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
  endif

  InicioDoDado := '<cMunIni>'
  FinalDoDado  := '</cMunIni>'
  nPosIni      := At(InicioDoDado,Linha)
  nPosFim      := At(FinalDoDado,Linha)
  c_Munini     := ''

  If nPosIni==0 .or. nPosFim==0
  else
    c_Munini := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
  endif

  InicioDoDado := '<cMunFim>'
  FinalDoDado  := '</cMunFim>'
  nPosIni      := At(InicioDoDado,Linha)
  nPosFim      := At(FinalDoDado,Linha)
  c_Munfim     := ''

  If nPosIni==0 .or. nPosFim==0
  else
    c_Munfim := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
  endif
endif

//---Pegando Dados para Lancamento da Capa da Nf
mBaseSubs := 0

if lLeu2
  Locate for "vNF" $ ARQUIVO->NOME
  Linha = ARQUIVO->NOME
endif

m_vNf   := PegaDados('vNF' ,Alltrim(Linha) ,.f.)

if lLeu2
  Locate for "nNF" $ ARQUIVO->NOME
  Linha = ARQUIVO->NOME
endif

M_CNF   := PegaDados('nNF' ,Alltrim(Linha)  ,.f.)

if lLeu2
  Locate for "serie" $ ARQUIVO->NOME
  Linha = ARQUIVO->NOME
endif

m_serie := PegaDados('serie' ,Alltrim(Linha),.f. )

if lLeu2
  Locate for "dEmi" $ ARQUIVO->NOME
  Linha = ARQUIVO->NOME
endif

m_dEmi  := Char2Data(PegaDados('dEmi' ,Alltrim(Linha),.f. ))
m_Razao := PegaDados('xNome',Alltrim(Linha),.f. )
mCodigo  := ''
mDataLanca   := Date()

if lTRANSPORTE
  m_vNf   := PegaDados('vRec' ,Alltrim(Linha) ,.f.)
  m_dEmi  := Char2Data(PegaDados('dhEmi' ,Alltrim(Linha),.f. ))

  InicioDoDado := '<imp>'
  FinalDoDado  := '</imp>'
  nPosIni      := At(InicioDoDado,Linha)
  nPosFim      := At(FinalDoDado,Linha)
  cRet2         := '0'

  If nPosIni==0 .or. nPosFim==0
  else
    cRet2       := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
  endif

  M_NFEPIC := val(PegaDados('pICMS' ,Alltrim(cRet2) ,.f.) )
 
  M_NFEVIC := val(PegaDados('vICMS' ,Alltrim(cRet2) ,.f.) )
  M_NFEBIC := val(PegaDados('vBC' ,Alltrim(cRet2) ,.f.) )
  M_UF     := PegaDados('UF' ,Alltrim(Linha) ,.f.)
  m_cNF    := PegaDados('nCT' ,Alltrim(Linha)  ,.f.)

endif

cMsg = {}
aadd(cMsg,'###### IMPORTA DANFE ######')
aadd(cMsg,'Razao Social :'+m_Razao)
aadd(cMsg,'Nr Nota :'+m_cnf + ' Serie :'+m_serie)
aadd(cMsg,'Emissao :'+dtoc(m_Demi))
aadd(cMsg,'Valor :'+transf(Val(m_vnf),'@EZ 999,999.99'))
aadd(cMsg,'Nr.Chave :'+Substr(cChave,4,47))
aadd(cMsg,'CGC Emit :'+cCGcEmit)


M_DESPESA = 0
M_NFEGIA = 0

mOutros   = 0

*M_NFENOV = space(4)                     && 03 SER serie da nota fiscal
M_NFEEMP = ME_EMP
*M_NFENAT = 0

M_NFENAT = ""

msgbox1(cMsg)

do while .t.
  setcolor("B/W")
  nbox(06, 20, 10, 59,"W/W+",.t.)
  @ 07, 21 say    "Operacao             :                "
  @ 08, 21 say    "Valor Despesa        :                "
  @ 09, 21 say    "Valor da Gia         :                "
  SetColor(_COREDICAO_)
  @ 08, 45 get M_DESPESA picture "@E ###,###,###.##"
  @ 09, 45 get M_NFEGIA  picture "@E ###,###,###.##"
  read
  setcolor("")
  nLocesc = msgbox3(cMsg,,,"Escolha","Nao","Sim",1)
  if nLocesc = 2
    return ""
  endif
  if nLocesc = 3
    exit
  endif
enddo

if lLeu2
  select ARQUIVO
endif

*M_NFENAT1 = M_NFENAT  // operacao com 5 digitos

M_NFEEST = ""

cIdNota := StrZero(val(right(m_cnf,6)),6)

mContabil    := 0
mTotalProd   := 0
mTotalIcms   := 0
mBaseIcms    := 0
mDesconto    := 0
mFreteNf     := 0
mTotalIpi    := 0
mBaseSubs    := 0
mOutros      := 0


if !lanccapanota()
  return ""
endif

nQdeitens = 0
nSeq = 0

M_VALORSUB = 0
lRecsub = 0
nMaiorsub = 0
lReduz = .f.
lDeveriaReduz = .f.
lTipoVenda = space(4)
lNat = 0
M_SOCOMSUB = 0

lAcabou = .f.

if lLeu2
  select ARQUIVO
  go top
  do while !eof()
    if "det nItem" $ NOME
      exit
    endif
    skip
  enddo
endif

lLeu3 = lLeu2

do while .t.

  if lTRANSPORTE // nao pega itens
    exit
  endif

  lTemicms = .f.
  lTemipi  = .f.
  lSai = .f.

  if lLeu2
    cLinhaTxt = ""
    select ARQUIVO
    do while !eof()
      if "det nItem" $ NOME
        cLinhaTxt += alltrim(NOME)
        skip
        do while !eof()
          if "</det" $ NOME
            cLinhaTxt += alltrim(NOME)
            lSai = .t.
            exit 
          else
            cLinhaTxt += alltrim(NOME)
          endif
          skip
        enddo
        if lSai
          exit
        endif
      endif
      skip
    enddo
    if eof()
      lAcabou = .t.
    endif
  endif

  lLeu2 = .f.

  cLidos := PegaDados('det nItem',Alltrim(cLinhaTxt),.t.,'det' )

  Linha  := cLidos
  If Linha=='0'
    Exit
  Endif

  InicioDoDado := '<ICMS>'
  FinalDoDado  := '</ICMS>'
  nPosIni      := At(InicioDoDado,Linha)
  nPosFim      := At(FinalDoDado,Linha)
  cRet         := '0'
  If nPosIni==0 .or. nPosFim==0
  else
    cRet         := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
  endif

  InicioDoDado := '<PIS>'
  FinalDoDado  := '</PIS>'
  nPosIni      := At(InicioDoDado,Linha)
  nPosFim      := At(FinalDoDado,Linha)
  cRet2         := '0'

  If nPosIni==0 .or. nPosFim==0
  else
    cRet2       := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
  endif

  M_NFEPIS := 0
  M_NFEDESCONT := 0
  M_NFEDESCONT := val(PegaDados('vDesc' ,Alltrim(Linha) ,.f.) )
 
 // voltamos a pegar o desconto

  if "vBC" $ cRet2
    M_NFEPIS := val(PegaDados('vBC' ,Alltrim(cRet2) ,.f.) )
  else
    M_NFEDESCONT := val(PegaDados('vDesc' ,Alltrim(Linha) ,.f.) )
  endif

  M_NFEPIC := val(PegaDados('pICMS' ,Alltrim(Linha) ,.f.) )
  M_NFEVIC := val(PegaDados('vICMS' ,Alltrim(Linha) ,.f.) )
  M_NFEBIC := val(PegaDados('vBC' ,Alltrim(cRet) ,.f.) )
  M_NFERED := val(PegaDados('pRedBC' ,Alltrim(cRet) ,.f.) )

  if str(100 - M_NFERED,12,2) == str(58.33,12,2)
    M_NFERED := 58.33
  endif

  M_CST   := PegaDados('CST' ,Alltrim(Linha) ,.f.)
  M_ORIG  := PegaDados('orig' ,Alltrim(Linha) ,.f.)

  mxProd  := PegaDados('xProd',Alltrim(Linha) ,.f.)

  mcprod  := Alltrim(PegaDados('cProd',Alltrim(Linha),.f.))

  mqcom   := Val(PegaDados('qCom' ,Alltrim(Linha) ,.f.) )

  mvprod  := Val(PegaDados('vProd',Alltrim(Linha) ,.f.) )
  M_NFEPUN := val(PegaDados('vUnCom' ,Alltrim(Linha) ,.f.) )
  M_CFOP   := PegaDados('CFOP' ,Alltrim(Linha) ,.f.)

*  if lTipoVenda = space(4)
*    do case
*      case left(M_CFOP,2) $ "51#61#54#64"  // compras
*        if left(M_CFOP,2) $ "51#54"    // dentro estado
*          lTipoVenda = "1102"
*          lNat = 11200
*        else
*          lTipoVenda = "2102"
*          lNat = 21200
*        endif
*      case left(M_CFOP,2) $ "59#69"  // brindes
*        if left(M_CFOP,2) == "59"    // dentro estado
*          lTipoVenda = "1949"
*          lNat = 19900
*        else
*          lTipoVenda = "2949"
*          lNat = 29900
*        endif
*    endcase
*  endif

  M_NFENAT = ""

  do case
    case M_CFOP $ "#5102#5101#"
      M_NFENAT = "1.102" 
    case M_CFOP $ "#6102#6101#"
      M_NFENAT = "2.102" 
    case M_CFOP $ "#5401#5402#5403#5404#5405#"
      M_NFENAT = "1.403"
    case M_CFOP $ "#6401#6402#6403#6404#6405#"
      M_NFENAT = "2.403"
    case M_CFOP $ "#5152#"
      M_NFENAT = "2.552" 
    case M_CFOP $ "#5910#"
      M_NFENAT = "1.910" 
    case M_CFOP $ "#5911#"
      M_NFENAT = "1.911" 
    case M_CFOP $ "#6910#"
      M_NFENAT = "2.910" 
  endcase

  // valor do desconto

  M_NFEFRE := val(PegaDados('vFrete' ,Alltrim(Linha) ,.f.) )
  M_NFEBIP := val(PegaDados('vUnid' ,Alltrim(Linha) ,.f.) )
  M_NFEDESPOUT := val(PegaDados('vOutro' ,Alltrim(Linha) ,.f.) )

 // 14-02-2013 estava 0 M_NFEDESPOUT

  M_NFEDESPOUT := 0
 // nao vai pegar tem que ratear no final

  M_NFEPICST := val(PegaDados('pICMSST'  ,Alltrim(Linha) ,.f.) )
  M_NFEBSUB := val(PegaDados('vBCST'  ,Alltrim(Linha) ,.f.) )
  M_NFESUB := val(PegaDados('vICMSST',Alltrim(Linha) ,.f.) )
  M_NFEPIP := val(PegaDados('pIPI'   ,Alltrim(Linha) ,.f.) )
  M_NFEVIP := val(PegaDados('vIPI'   ,Alltrim(Linha) ,.f.) )

  if M_NFEVIP > 0 .and. M_NFEPIP = 0 // tem ipi vamos achar a aliquota
    M_NFEPIP = ((M_NFEVIP / M_NFEBIP)*100)
  endif

  mBaseSubs -= M_NFESUB

  if M_CST = "00"
    lTemicms = .t.
  endif

  if M_NFEVIP > 0 // TEM IPI
    lTemipi = .t.
  endif

  mVpis   := val(PegaDados('vPIS' ,Alltrim(Linha) ,.f.) )
  mVCofins:= val(PegaDados('vCOFINS' ,Alltrim(Linha) ,.f.) )


  mcprod = alltrim(tirazero(mcprod,22))

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"APCFOR","SELECT"}
  aadd(sqlCHAVE,{"PCACODFOR",aspas(mcprod)})
  executasql()

  lAchei = .f.

  do while !eof()
    if !str(PCAFOR,5) $ aCODFOR
      skip
      loop
    endif

    if BUSCAREGISTRO("APCA00",1,{str(APCFOR->PCAMAT,6,0)},"SELECT")
      lAchei = .t.
    endif
    exit
  enddo

  // se nao achar pelo codigo vamos pesquisar pelo CNPJ

  if !lAchei
    lTela2 = savescreen(09,24,15,67)
    _FUNPRO_ = "KEYBOARD"
    M_PCAMAT = 0

    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}
    aadd(sqlARQUI,{"APCA00","APCA00P"})
    aadd(sqlCAMPO,"first 50 PCADES")
    aadd(sqlCAMPO,"PCAUNI")
    aadd(sqlCAMPO,"PCAMAR")
    aadd(sqlCAMPO,"PCAMAT")
    aadd(sqlCAMPO,"S1.SLDDIS as SALDO1")
    aadd(sqlCAMPO,"S2.SLDDIS as SALDO2")
    aadd(sqlCAMPO,"S1.SLDPRC")
    aadd(sqlRELATION,{"ASLD00 S1",str(1, 2, 0),"S1.SLDEMP"})
    aadd(sqlRELATION,{"","S1.SLDMAT","APCA00.PCAMAT"})
    aadd(sqlRELATION,{"ASLD00 S2",str(10, 2, 0),"S2.SLDEMP"})
    aadd(sqlRELATION,{"","S2.SLDMAT","APCA00.PCAMAT"})
    aadd(sqlORDEM,"APCA00.PCADES")
    aadd(sqlCHAVE,"PCADES LIKE '" + left(alltrim(mxProd),20) + "%'")
    sqlrelation()

    do while .t.
      tone(500,1)
      setcolor("W+/R,W+/R,W+/R,W+/R")
      sombra(09,24,14,66,_SOMBRA_)
      @ 09, 24, 14, 66 box M_FRAME1
      @ 10, 25 say "CODIGO NAO CADASTRADO: " + alltrim(mcprod)
      @ 11, 25 say  pad(mxProd ,40)
      @ 12, 25 say "Informe o codigo do produto: "
      @ 13, 25 say "                <F2>produto  "
      @ 12, 54 get M_PCAMAT picture "######" F2 color _CORF2_ funcao "sele_arquivo('APCA00')" retorno @M_PCAMAT
      read
      setcolor("")

      if lastkey()=27
        select ANFTM1
        use
        return ""
      endif

      if !BUSCAREGISTRO("APCA00",1,{str(M_PCAMAT,6,0)},"SELECT")
        msg("* * * PRODUTO NAO CADASTRADO * * *")
        loop
      endif

      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {"APCFOR","UPDATE OR INSERT"}
      aadd(sqlCHAVE,{"PCAMAT"})
      aadd(sqlCHAVE,{"PCAFOR"})
      aadd(sqlCHAVE,{"PCACODFOR"})

      aadd(sqlCAMPO,{"PCAMAT",str(M_PCAMAT,6),.T.})
      aadd(sqlCAMPO,{"PCAFOR",str(mCodigo,6),.T.})
      aadd(sqlCAMPO,{"PCACODFOR",alltrim(mcprod),.T.})
      executasql()
      exit
    enddo

    restscreen(09,24,15,67,lTela2)

    lAchei = .t.  // se achou
  endif

  if APCFOR->PCAMULT > 0
    do while .t.
      if APCFOR->PCAOPE == "*"
        nDosesmanual = alert("Produto: " + alltrim(str(APCA00->PCAMAT,6)) + ";" +left(APCA00->PCADES,30) + ";;A quantidade sera multiplicado por " + alltrim(str(APCFOR->PCAMULT,6)) + ";;a quantidade lancada;sera de " + alltrim(str(mqcom*APCFOR->PCAMULT,6)),{"Confirma","Nao","Sim"})
      else
        nDosesmanual = alert("Produto: " + alltrim(str(APCA00->PCAMAT,6)) + ";" +left(APCA00->PCADES,30) + ";;A quantidade sera dividida por " + alltrim(str(APCFOR->PCAMULT,6)) + ";;a quantidade lancada;sera de " + alltrim(str(mqcom/APCFOR->PCAMULT,6)),{"Confirma","Nao","Sim"})
      endif

      if nDosesmanual = 3
        if APCFOR->PCAOPE == "*"
          mqcom = mqcom*APCFOR->PCAMULT
        else
          mqcom = mqcom/APCFOR->PCAMULT
        endif
        exit
      endif
      if nDosesmanual = 2 
        exit
      endif
    enddo
  endif

  nQdeitens += mqcom

  if lAchei  // se achou
    if APCA00->PCATRI = 5 // se substituicao
      M_SOCOMSUB += mvprod
    endif     

    select ANFTM1
    locate for NFEMAT = APCA00->PCAMAT

    if eof()
      append Blank
      nSeq ++
      replace NFESEQ with iif(nSeq > 99, 99, nseq)
    endif

    if len(alltrim(m_serie)) < 3
      replace NFESER  with m_serie  //mNotaSerie
    else
      replace NFESER  with "1 "  //mNotaSerie
    endif
    replace NFENUM     with val(cIdnota)
    replace NFENUM1    with val(M_CNF)
    replace NFEFOR     with mCodigo
    replace NFEEMP     with ME_EMP
    replace NFEDTE     with m_demi
    replace NFEDTR     with mDataLanca
    replace NFEMAT     With APCA00->PCAMAT
    replace NFEDSN     With M_NFEDESPOUT
    replace NFENATN    with M_NFENAT
    replace NFEPUN     with mvprod/mqcom
    replace NFEQDE     with NFEQDE + mqcom
    replace NFEDSC     with NFEDSC + M_NFEDESCONT
    replace NFESUB     with NFESUB + M_NFESUB
    replace NFEBICST   with NFEBICST + M_NFEBSUB
    replace NFEPICST   with M_NFEPICST
    replace NFEVLI     with NFEVLI + mvprod // sem desconto
    replace NFELIQ     with NFELIQ + (mvprod - M_NFEDESCONT) // com desconto desconto
    replace NFECST     with M_CST
    if M_ORIG == "1"
      replace NFEORI     with "2"
    else
      replace NFEORI     with M_ORIG
    endif

    if M_CST $ "20#" // REDUCAO NA BASE
      lDeveriaReduz = .t.
      if str(APCA00->PCARG1,12,2) == str(M_NFERED,12,2) .or. str(APCA00->PCARG2,12,2) == str(M_NFERED,12,2)
      else
        lReduz = .t.
      endif
    endif

    replace NFEPIC with M_NFEPIC
    replace NFEEST with "N" 

    if M_CFOP $ "5401#6401" .or. M_CST $ "10#30#40" // substituicao
//      replace NFEBICST with NFEBICST + M_NFEBIC
      replace NFEBIC with 0
      replace NFEVIC with 0
      replace NFEOUT with NFEOUT + ((mvprod - M_NFEDESCONT)+M_NFEFRE+M_NFEDESPOUT) // M_NFEBIC

    else
      replace NFEBIC with NFEBIC + M_NFEBIC
      replace NFEVIC with NFEVIC + M_NFEVIC
      if NFEBIC < NFELIQ
        replace NFEOUT with NFEOUT + (((mvprod - M_NFEDESCONT)+M_NFEFRE+M_NFEDESPOUT) - (M_NFEBIC))
      endif
      
    endif

    if NFEBIC = 0
      replace NFEPIC with 0
    endif

    replace NFEBIP with NFEBIP + M_NFEBIP

    replace NFEPIP with M_NFEPIP
    replace NFEVIP with NFEVIP + M_NFEVIP
    replace NFEFRE with NFEFRE + M_NFEFRE
    replace NFEESC with 0

    if lTemicms
      replace NFEESC with 5
    else
      if !lTemipi .and. lTemicms
        replace NFEESC with 5
      else
        if lTemipi .and. !lTemicms
          replace NFEESC with 2
        else
          if !lTemicms .and. !lTemipi
            replace NFEESC with 2
          endif
        endif
      endif
    endif

    replace NFEEXE with 1

    if M_NFESUB > nMaiorsub
      nMaiorsub = M_NFESUB
      lRecsub = recno()
    endif
  endif

  lLeu2 = lLeu3

  if lLeu2
    if lAcabou 
      exit
    endif
  else
    nSize         := Linhatotal-nLinhaLidas
    cLinha        := Right(cLinhaTxt,nSize)
    cLinhaTxt     := cLinha
    if nLinhaLidas >= Linhatotal
      exit
    endif
  endif

enddo

if lTRANSPORTE  // nao pega itens

  select ANFTM1
  append Blank
  replace NFESEQ with 1

  if len(alltrim(m_serie)) < 3
    replace NFESER  with m_serie  //mNotaSerie
  else
    replace NFESER  with "1 "  //mNotaSerie
  endif
  replace NFENUM with val(cIdnota)
  replace NFEFOR with mCodigo
  replace NFEEMP with ME_EMP
  replace NFEDTE with m_demi
  replace NFEDTR with mDataLanca
  replace NFEMAT With 1  
  replace NFEQDE with 1
  replace NFEPUN with val(m_vNf)
  replace NFEVLI  with val(m_vNf)
  replace NFELIQ  with val(m_vNf)
  replace NFEBIC with M_NFEBIC
  replace NFEVIC with M_NFEVIC
  replace NFEISE with val(m_vNf) - M_NFEBIC
  replace NFEPIC with M_NFEPIC
  if NFEBIC = 0
    replace NFEOUT with val(m_vNf)
  endif
  replace NFEESC with 4
  replace NFEEXE with 1 
  replace NFECST with "90"
  if M_UF == "SP"
    replace NFENATN with "1.353"
  else
    replace NFENATN with "2.353"
  endif
endif

if mBaseSubs <> 0
  select ANFTM1
  go lRecsub
  replace NFESUB with NFESUB + mBaseSubs
endif

select ANFTM1
go top
do while !eof()
  replace NFEPUN     with NFEVLI/NFEQDE
  skip
enddo

select ANFTM1
*sum NFEBIC     to M_NFEBIC
*sum NFEVIC     to M_NFEVIC
sum NFEQDE     to M_NFEQDE
*sum NFEDSC     to M_NFEDSC
sum NFELIQ     to M_NFELIQ  // VALOR DA NOTA
*sum NFESUB     to M_NFESUB  // valors substituicao
*sum NFEVIP     to M_NFEVIP  // valors substituicao
*sum NFEFRE     to M_NFEFRE
*sum NFEDST     to M_NFEDESPOUT
sum NFEBICST   to M_NFEBICST

*M_TOTLIQ = 0

*go top
*M_TOTBIC = 0

*do while !eof()
*  M_TOTBIC += NFEBIC+NFEBICST
*  M_TOTLIQ += NFELIQ
*  skip
*enddo

*if mOutros > 0  // vamos ratear somento produtos com icms
*  lPosICM = 0
*  M_TOTDSP = 0
*  go top
*  do while !eof()
*    if M_TOTBIC > 0 // tem icms
*      if NFEBIC+NFEBICST > 0
*        if NFEBIC > 0
*          if lPosICM = 0
*            lPosICM = recno()
*          endif
*        endif
*        replace NFEDST with round((mOutros/M_TOTBIC)*(NFEBIC+NFEBICST),2)
*        M_TOTDSP += NFEDST
*      endif
*    else  // rateamos em todos os itens NFEDSN 
*      replace NFEDST with round((mOutros/M_TOTLIQ)*NFELIQ,2)
*      M_TOTDSP += NFEDST
*    endif
*    skip
*  enddo

*  if lPosICM > 0
*    go lPosICM 
*  else
*    go 1
*  endif

*  if M_TOTDSP > mOutros 
*    if lPosICM > 0
*      replace NFEDST with NFEDST - (M_TOTDSP - mOutros)
*    else
*      replace NFEDST with NFEDST - (M_TOTDSP - mOutros)
*    endif
*  else
*    if M_TOTDSP < mOutros 
*      if lPosICM > 0
*        replace NFEDST with NFEDST + (mOutros - M_TOTDSP)
*      else
*        replace NFEDST with NFEDST + (mOutros - M_TOTDSP)
*      endif
*    endif
*  endif
*endif

M_TOTGIA = 0

if M_NFEGIA > 0

  go top

  M_TOTDSC = 0

  do while !eof()
    M_VALDES = round((((M_NFEGIA)/M_SOCOMSUB)*NFELIQ),2)
    replace NFEGIA with M_VALDES
    M_TOTGIA += NFEGIA
    skip
  enddo
  go 1

  if M_TOTGIA > M_NFEGIA
    replace NFEGIA with NFEGIA - (M_TOTGIA - M_NFEGIA)
  else
    if M_TOTGIA < M_NFEGIA
      replace NFEGIA with NFEGIA + (M_NFEGIA - M_TOTGIA)
    endif
  endif

endif

if M_DESPESA > 0
  go top
  M_TOTDSC = 0
  do while !eof()
    M_VALDES = round((((M_DESPESA)/M_NFELIQ)*NFELIQ),2)
    M_TOTDSC += M_VALDES
    replace NFEDSN with M_VALDES
    skip
  enddo
  go 1
  replace NFEDSN with NFEDSN + ((M_DESPESA) - M_TOTDSC)
endif

lMudoubase = .f.

*sum NFEDSC to M_NFEDSC

// vamos ver se base > 40% fora do estado

*if lReduz .or. (lMudoubase .and. lDeveriaReduz)

*  if !M_NFEEST == "SP"
*    select ANFTM1
*    go top
*    do while !eof()
*      APCA00->(dbseek(str(ANFTM1->NFEMAT, 6, 0)))
*      if NFEBIC > 0 .and. APCA00->PCARG1 > 0
*        if NFEBIC > ((((NFELIQ+NFEFRE)/100)*APCA00->PCARG1)+.05)
*          replace NFEBIC with (((NFELIQ+NFEFRE)/100)*APCA00->PCARG1)
*          replace NFEVIC with (NFEBIC/100)*NFEPIC
*          replace NFEOUT with (NFELIQ+NFEFRE) - NFEBIC
*        endif
*      endif
*      skip
*    enddo

*    select ANFTM1
*    sum NFEBIC     to M_NFEBIC
*    sum NFEVIC     to M_NFEVIC

*  endif
*endif


select ANFETM
replace NFEITE with M_NFEQDE
replace NFEBIC with mBaseIcms // M_NFEBIC
replace NFEVIC with mTotalIcms // M_NFEVIC
replace NFEDSC with mDesconto // M_NFEDSC
replace NFEVIP with mTotalIpi // M_NFEVIP
replace NFEFRE with mFreteNF  // M_NFEFRE
replace NFENATN with M_NFENAT //lNat
//replace NFENOV with lTipoVenda
replace NFSLOG with "ELETRONICA"
//replace NFENOVA with "S"
replace NFECOMP with "N"

if lTRANSPORTE  // nao pega itens
  replace NFEMOD with 57
  replace NFEMUNR with c_MUNINI
  replace NFEMUND with c_MUNFIM
else
  replace NFEMOD with 55
endif

replace NFEDSN with M_DESPESA
replace NFEGIA with M_NFEGIA
replace NFEDST with mOutros
replace NFEBICST with M_NFEBICST

M_NFENUM = NFENUM
M_NFESER = NFESER
M_NFEFOR = NFEFOR

select ANFETM
sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"ANFE00","UPDATE OR INSERT"}
DBFTOSQL("ANFETM")
aadd(sqlCHAVE,{"NFEEMP"})
aadd(sqlCHAVE,{"NFENUM"})
aadd(sqlCHAVE,{"NFESER"})
aadd(sqlCHAVE,{"NFEFOR"})
executasql()

select ANFTM1
go top
do while !eof()
   sqlCAMPO = {}
   sqlCHAVE =  {}
   sqlARQUI = {"ANFE01","UPDATE OR INSERT"}
   DBFTOSQL("ANFTM1")
   aadd(sqlCHAVE,{"NFEEMP"})
   aadd(sqlCHAVE,{"NFENUM"})
   aadd(sqlCHAVE,{"NFESER"})
   aadd(sqlCHAVE,{"NFEFOR"})
   aadd(sqlCHAVE,{"NFESEQ"})
   executasql()
   select ANFTM1
   skip
enddo

fecha_arq()

msg("ARQUIVO IMPORTADO COM EXITO")

Filecopy(cFileDanfe,iFileDanfe)           // Copy the file
erase("&cFileDanfe")

Return ""

//------------------------------------------------------
Function PEGADADOS(CpROC,ClINHA,LiTEM,CtEXTO2)
Local InicioDoDado :=Iif(cTexto2==Nil,"<"+cProc+">" , "<"+cProc )
Local FinalDoDado := Iif(cTexto2==Nil,"</"+cProc+">",'</'+cTexto2+'>')
Local nPosIni     := At(InicioDoDado,cLinha)
Local nPosFim     := At(FinalDoDado,cLinha)
Local cRet        := '0'

if lLeu2
  // parece que isto nao estava funcionando
  //  Locate for InicioDoDado $ ARQUIVO->NOME
  //  cLinha = ARQUIVO->NOME
  nPosIni     := At(InicioDoDado,cLinha)
  nPosFim     := At(FinalDoDado,cLinha)
endif

If nPosIni==0 .or. nPosFim==0
  Return cRet
Endif
cRet := Substr(cLinha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
If lItem ==.t.
  nLinhalidas  += nPosFim
Endif
Return  ( cRet)

//------------------------------------------------
Static Function LANCCAPANOTA()
Local Ok         := .t.
Local cChaveNota
Local InicioDoDado := '<total>'
Local FinalDoDado  := '</total>'
Local nPosIni      := At(InicioDoDado,Linha)
Local nPosFim      := At(FinalDoDado,Linha)
Local cRet         := '0'

lLeu22 = .f.

if lLeu2
  lLeu22 = .t.
  lLeu2 = .f.
  cRet = ""
  locate for InicioDoDado $ ARQUIVO->NOME
  cret += alltrim(ARQUIVO->NOME)
  do while !eof()
    if FinalDoDado $ ARQUIVO->NOME
      cret += alltrim(ARQUIVO->NOME)
      exit
    endif
    cret += alltrim(ARQUIVO->NOME)
    skip
  enddo
  nPosIni      := At(InicioDoDado,cret)
  nPosFim      := At(FinalDoDado,cret)
endif

if !lTRANSPORTE
  If nPosIni==0 .or. nPosFim==0
    Return cRet
  Endif

  if !lLeu22
    cRet         := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
  endif

  mAgenda      := '003'
  mContabil    := Val(PegaDados('vNF'   ,Alltrim(cRet) ,.f.))
  mTotalProd   := Val(PegaDados('vProd' ,Alltrim(cRet) ,.f.))
  mTotalIcms   := Val(PegaDados('vICMS' ,Alltrim(cRet) ,.f.))
  mBaseIcms    := Val(PegaDados('vBC'   ,Alltrim(cRet) ,.f.))
  mDesconto    := Val(PegaDados('vDesc' ,Alltrim(cRet) ,.f.))
  mFreteNf     := Val(PegaDados('vFrete',Alltrim(cRet) ,.f.))
  mTotalIpi    := Val(PegaDados('vIPI'  ,Alltrim(cRet) ,.f.))
  mBaseSubs    := Val(PegaDados('vST'   ,Alltrim(cRet) ,.f.))
  mOutros      := Val(PegaDados('vOutro',Alltrim(cRet) ,.f.))
  mEspecie     := 'NFe'
  mValorSubs   := 0
  mCodFisc     := '???'
  mValorOutro  := 0
  xPediUsar    := ''
else
  mAgenda      := '003'
  mContabil    := val(m_vNf)
  mTotalProd   := val(m_vNf)
  mTotalIcms   := M_NFEVIC
  mBaseIcms    := M_NFEBIC
  mEspecie     := 'NFe'
  mValorSubs   := 0
  mCodFisc     := '???'
  mValorOutro  := 0
  xPediUsar    := ''
  mDesconto    := 0
  mFreteNf     := 0
  mTotalIpi    := 0
  mBaseSubs    := 0
  mOutros      := 0
endif

if lLeu22
  lLeu2 = .t.
endif

if !BUSCAREGISTRO("AFOR00",3,{aspas(StrZero(Val(cCGCEmit),15))},"SELECT")
  msg("* * * FORNECEDOR NAO CADASTRADO COM ESTE CNPJ * * *")
  Return .f.
Endif

mCodigo    := AFOR00->FORCOD
lRecfor    := 0
MNOTASERIE := Substr(m_serie+Space(4),1,4)
cChaveNota := cIdNota+MNOTASERIE+str(mCodigo,5)

aCODFOR   := ""
A_CODFOR = { }
A_CGCFOR := ""

seexiste("AFORTM")
cSQL := "SELECT FORCOD,FORCGC FROM AFOR00 where SUBSTRING(FORCGC FROM 1 FOR 9) = " + aspas(left(StrZero(Val(cCGCEmit),15),9))
dbuseareasql(.t.,"SQLMIX",cSQL,"AFORTM")
do while !eof()
  aCODFOR += str(FORCOD,5) + "#"
  A_CGCFOR += left(FORCGC,9) + "#"
  skip
enddo

use

if aCODFOR == ""
  aCODFOR = str(mCodigo,5)
endif

if A_CGCFOR == ""
  A_CGCFOR = left(StrZero(Val(cCGCEmit),15),9)
endif

// vamos pegar os vencimento

InicioDoDado := '<cobr>'
FinalDoDado  := '</cobr>'

lLeu22 = .f.

if lLeu2
  lLeu22 = .t.
  lLeu2 = .f.
  Linha = ""
  select ARQUIVO
  locate for "<cobr>" $ ARQUIVO->NOME
  linha += alltrim(ARQUIVO->NOME)
  do while !eof()
    if "</cobr>" $ ARQUIVO->NOME
      linha += alltrim(ARQUIVO->NOME)
      exit
    endif
    linha += alltrim(ARQUIVO->NOME)
    skip
  enddo
endif

nPosIni      := At(InicioDoDado,Linha)
nPosFim2     := At(FinalDoDado,Linha)
cRet1        := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim2-nPosIni-Len(FinalDoDado)+1)
nPosFim2     := len(cRet1)

// vamos eliminar a fatura

InicioDoDado := '<fat>'
FinalDoDado  := '</fat>'
nPosIni      := At(InicioDoDado,cRet1)
nPosFim      := At(FinalDoDado,cRet1)

if nPosini + nPosfim > 0
  cRet1        := right(cret1,nPosFim2-(nPosfim+Len(FinalDoDado)-1))
  nPosFim2     := len(cRet1)
endif

// ja eliminamos a fatura agora pegamos a dup

InicioDoDado := '<dup>'
FinalDoDado  := '</dup>'
lTempagamento = .f.

aVCT = { }
aVAL = { }

do while .t.

  if lTRANSPORTE  // nao calcula dups
    lTempagamento = .t.
    exit
  endif

  nPosIni      := At(InicioDoDado,cRet1)

  if nPosini = 0
    exit
  endif

  nPosFim      := At(FinalDoDado,cRet1)
  cRet         := Substr(cRet1,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
  cRet1        := right(cret1,nPosFim2-(nPosfim+Len(FinalDoDado)-1))
  nPosFim2     := len(cRet1)

  cVct         := PegaDados('dVenc' ,Alltrim(cRet) ,.f.)
  cVct         := Char2Data(cVct)
  aadd(aVCT,cVct)

  cVal         := PegaDados('vDup' ,Alltrim(cRet) ,.f.)
  cVal         := val(cVal)
  aadd(aVAL,cVal)
enddo

M_NFECPG = 500 // trinta dias

if !lTRANSPORTE  // nao calcula dups
M_NFECPG = 530 // trinta dias

if len(aVAL) > 0
  if len(aVAL) = 1
    if aVCT[1] == m_demi
      M_NFECPG = 501 // a vista
    endif
  endif
  if len(aVAL) = 2
    M_NFECPG = 532
  endif
  if len(aVAL) = 3
    M_NFECPG = 533
  endif
  if len(aVAL) = 4
    M_NFECPG = 534
  endif
  if len(aVAL) = 5
    M_NFECPG = 535
  endif
  if len(aVAL) = 6
    M_NFECPG = 536
  endif
  if len(aVAL) = 7
    M_NFECPG = 537
  endif
  if len(aVAL) = 8
    M_NFECPG = 538
  endif
  if len(aVAL) = 9
    M_NFECPG = 539
  endif
  if len(aVAL) = 10
    M_NFECPG = 540
  endif
  if len(aVAL) = 11
    M_NFECPG = 541
  endif
  if len(aVAL) = 12
    M_NFECPG = 542
  endif
  if len(aVAL) = 13
    M_NFECPG = 543
  endif
  if len(aVAL) = 14
    M_NFECPG = 544
  endif
endif
endif


if lLeu22
  lLeu2 = .t.
endif

if BUSCAREGISTRO("ANFE00",1,{str(ME_EMP, 2, 0),str(val(cIdnota), 9, 0),aspas(m_serie),str(mCodigo, 7, 0)},"SELECT")
  alert("Nota de entrada ja cadastrada;para importar novamente;sera preciso excluir;a nota")

  if !"SCILAS" $ M_LOGNOM
    Filecopy(cFileDanfe,iFileDanfe)           // Copy the file
    erase("&cFileDanfe")
  endif
  return .f.
endif

seexistesql("ANFE00")
cSQL := "SELECT first 1 * from ANFE00"
dbusearea(.t.,"SQLMIX",cSQL,"ANFE00")
cria_dbf("ANFETM")  // CRIA DBF A PARTIR DO ARQUIVO ABERTO COM O NOME INDICADO
use
select 0
use ANFETM exclusive

Sele ANFETM
Append Blank
replace NFEEMP  with ME_EMP
replace NFEDTE  with m_demi
Replace NFEDTR  with mDataLanca
replace NFEVLN  with mContabil
replace NFENUM  with val(cIdnota)
replace NFENUM1 with val(M_CNF)

if len(alltrim(m_serie)) < 3
  replace NFESER  with m_serie  //mNotaSerie
else
  replace NFESER  with "1 "  //mNotaSerie
  replace NFESER1  with m_serie   //mNotaSerie
endif

replace NFEFOR  with mCodigo
replace NFECPG  with M_NFECPG
replace NFEDST  with mOutros
replace NFSID   with Substr(cChave,4,47)
replace NFEAPL  with 100

lTempagamento = .f.

for A = 1 to len(aVct)
  lTempagamento = .t.
  MS = alltrim(str(A,2))
  repla NFEVC&MS with aVCT[A]
  Repla NFEDP&MS With aVAL[A]
next

*                     Repla NFEDSC with mDesconto

if lTempagamento
  Repla NFEPSN with "S"
else
  Repla NFEPSN with "N"
endif

Repla NFEVLM with mTotalProd
Repla NFEVIC with mTotalIcms
Repla NFEBIC with mBaseIcms
Repla NFEFRE with mFreteNf
Repla NFEDST with mOutros
Repla NFEVIP with mTotalIpi
M_NFEEST = AFOR00->FOREST
Repla NFESUB With mBaseSubs

if lTRANSPORTE  // nao calcula dups
  if M_UF == "SP"
    replace NFENATN with "1.353"
  else
    replace NFENATN with "2.353"
  endif
endif

seexistesql("ANFE01")
cSQL := "SELECT first 1 * from ANFE01"
dbusearea(.t.,"SQLMIX",cSQL,"ANFE01")
cria_dbf("ANFTM1")  // CRIA DBF A PARTIR DO ARQUIVO ABERTO COM O NOME INDICADO
use

select 0
use ANFTM1 exclusive

Return Ok

//---------------------------------------
Function Char2Data(cString)
Local i
Local lRet := ''
Local cAno := Substr(cString,1,4)
Local cMes := Substr(cString,6,2)
Local cDia := Substr(cString,9,2)
lRet := cDia+'/'+cMes+'/'+cAno

Return Ctod(lRet)

//--------------------------------------------
Function Char3Data(cString)
Local i
Local lRet := ''
Local cAno := Substr(cString,1,4)
Local cMes := Substr(cString,5,2)
Local cDia := Substr(cString,7,2)
lRet := cDia+'/'+cMes+'/'+cAno

Return Ctod(lRet)

****************
function LERXML3
****************

private l7143Supp := .F.                  // Is function 7143h supported?

mon_env("NFE.Lernfe("  + cFiledanfe + ')')
cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
Filecopy(ACBrNFe_SAI,"NFE.TXT")           // Copy the file

if file("ARQUIVO.CDX")
  erase("ARQUIVO.CDX")
endif

select 0
use arquivo exclusive
zap 
append from NFE.TXT SDF

retu



*****************
function TIRAZERO
*****************

parameters F_TIRA

do while .t.
  if left(F_TIRA,1) == "0"
    F_TIRA = right(F_TIRA,len(F_TIRA)-1)
  else
    exit
  endif
enddo

return F_TIRA

************************
Function PEGANOMEARQUIVO(cArq)
Local cFileDanfe := cArq
Local Linha       := Memoread(cFileDanfe)
Local nLinhalidas := 0
Local Linhatotal  := Len(Linha)
Local cLinhaTxt   := Linha
Local m_cNF   := PegaDados('nNF' ,Alltrim(Linha)  ,.f.)
Local m_cNT   := PegaDados('nCT' ,Alltrim(Linha)  ,.f.)
Local m_serie := PegaDados('serie' ,Alltrim(Linha),.f. )
Local m_dEmi  := PegaDados('dEmi' ,Alltrim(Linha),.f. )
Local m_Razao := PegaDados('xNome',Alltrim(Linha),.f. )

nPos4 := At('Id="',Linha)
nPos4 := nPos4+Len('Id="')
lcChave:= Substr(Linha,nPos4,47)

if "CTE" $ upper(lcChave)
  InicioDoDado := '<emit>'
  FinalDoDado  := '</emit>'
  nPosIni      := At(InicioDoDado,Linha)
  nPosFim      := At(FinalDoDado,Linha)
  cRetDest     := '0'
  If nPosIni==0 .or. nPosFim==0
  else
    cRetDest   := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
  endif

  m_Razao := PegaDados('xNome',Alltrim(cRetDest),.f. )
endif

  InicioDoDado := '<dest>'
  FinalDoDado  := '</dest>'

  nPosIni      := At(InicioDoDado,Linha)
  nPosFim      := At(FinalDoDado,Linha)
  cRetDest     := '0'
  If nPosIni==0 .or. nPosFim==0
  else
    cRetDest   := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
  endif

  M_cnpjRaca := PegaDados('CNPJ' ,upper(Alltrim(cRetDest)) ,.f.)

  if !M_cnpjRaca == right(AEMP00->EMPCGC,14)
    // SE CONHECIMENTO TRANSPORTE PROCURAR COMO REMETENTE

    InicioDoDado := '<rem>'
    FinalDoDado  := '</rem>'
    nPosIni      := At(InicioDoDado,Linha)
    nPosFim      := At(FinalDoDado,Linha)
    cRetDest     := '0'
    If nPosIni==0 .or. nPosFim==0
    else
      cRetDest   := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
    endif

    M_cnpjRaca := PegaDados('CNPJ' ,Alltrim(cRetDest) ,.f.)

    if !M_cnpjRaca == right(AEMP00->EMPCGC,14)  // nao foi emitido para racaforte
      return "ERRO"
    endif
  endif

cString := dtoc(Char2Data(m_demi)) + " " + "NF:"+m_cNF+m_cNT+'_'+m_serie+" - "+m_Razao

select DANFE
append blank
replace DATA with Char2Data(m_demi)
replace DESCRICAO with cString

Return cString

**************
function PEGA3
**************

select ARQUIVO
index on NOME tag 1 to "ARQUIVO" 
go top

locate for "cStat=302" $ NOME
if !eof()
  lDenega = .t.
endif

locate for "ID=" $ NOME
cChave:= Substr(NOME,4,47)

seek "[Identificacao]"
lRecno = recno()
set order to 0
go lRecno
skip

do while !eof()
  M_FRAZE = alltrim(NOME)
  nTamfra = len(M_FRAZE)
  cCampo  = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,nTamfra-at("=",M_FRAZE)))
  cCampo = strtran(cCampo,",",".")

  do case
  case "nNF=" $ M_FRAZE
    M_NFSNUM := val(cCampo)
  case "dEmi=" $ M_FRAZE
    M_NFSDTE := ctod(cCampo)
  endcase

  skip

  if "[" $ NOME
    exit
  endif

enddo


mDataLanca   := Date()


set order to 1
seek "[Total]"
lRecno = recno()
set order to 0
go lRecno
skip

do while !eof()
  M_FRAZE = alltrim(NOME)
  nTamfra = len(M_FRAZE)
  cCampo  = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,nTamfra-at("=",M_FRAZE)))
  cCampo = strtran(cCampo,",",".")

  do case
  case "vNF=" $ M_FRAZE
    mContabil := val(cCampo)
  case "vProd=" $ M_FRAZE
    mTotalProd := val(cCampo)
  case "vICMS="  $ M_FRAZE
    mTotalIcms := val(cCampo)
  case "vBC=" $ M_FRAZE
    mBaseIcms := val(cCampo)
  case "vDesc=" $ M_FRAZE
    mDesconto := val(cCampo)
  case "vFrete=" $ M_FRAZE
    mFreteNf := val(cCampo)
  case "vIPI=" $ M_FRAZE
    mTotalIpi := val(cCampo)
  case "vBCST=" $ M_FRAZE
    mBaseSubs := val(cCampo)
  case "vOutro=" $ M_FRAZE
    mOutros := val(cCampo)
  case "vST=" $ M_FRAZE
    mValorSubs := val(cCampo)
  endcase

  skip

  if "[" $ NOME
    exit
  endif

enddo

mEspecie     := 'NFe'
mCodFisc     := '???'
xPediUsar    := ''

Sele ANFETM
Append Blank
replace NFEEMP with 1
replace NFEDTE with M_NFSDTE
Replace NFEDTR with mDataLanca
replace NFEVLN with mContabil
replace NFENUM with M_NFSNUM
Replace NFEVLM with mContabil  // mTotalProd
Replace NFEVIC with mTotalIcms
Replace NFEBIC with mBaseIcms
Replace NFEFRE with mFreteNf
Replace NFEDSN with mOutros
Replace NFEVIP with mTotalIpi
Replace NFEEST with AFOR00->FOREST
Replace NFESUB With mBaseSubs

//-- Pegando Cgc para Pesquisa do Item na base 

select ARQUIVO
set order to 1

seek "[Emitente]"
lRecno = recno()
set order to 0
go lRecno
skip
cCGCEmit:= Substr(NOME,9,14)

M_CODCONT = 0
M_NFEEST = ""

cIdNota := M_NFSNUM

nQdeitens = 0
nSeq = 0

M_VALORSUB = 0
lRecsub = 0
nMaiorsub = 0
lReduz = .f.
lDeveriaReduz = .f.
lTipoVenda = 0
lAcabou = .f.

select ARQUIVO
set order to 1
seek "[Produto001]"
lRecno = recno()
set order to 0
go lRecno
skip

        M_NFESUB := 0
        mxProd := ""
        mcprod := ""
        M_CFOP := ""
        mqcom := 0
        M_NFEPUN := 0
        mvprod   := 0
        M_NFEFRE := 0
        M_NFEDESCONT := 0
        M_NFEOUT := 0
        M_ORIGEM := ""
        M_CSTICM := ""
        M_NFEBICST := 0
        M_NFEVICST := 0
        M_NFEPIC := 0
        M_NFEVIC := 0
        M_NFEBIC := 0
        M_NFERED := 0
        M_NFESUB := 0
        M_CSTIPI := ""
        M_NFEBIP := 0
        M_NFEPIP := 0
        M_NFEVIP := 0
        M_CSTPIS := ""
        mVpis := 0
        M_CSTPIS := ""
        mVCofins := 0

do while .t.

  lTemicms = .f.
  lTemipi  = .f.
  lSai = .f.

  select ARQUIVO
  lProduto = .t.
  lICMS = .f. // quando chegar no ICMS
  lPIS  = .f.
  lIPI  = .f.
  lCofins = .f.

  do while !eof()
    if "nItem=" $ NOME
      skip
    endif

    M_FRAZE = alltrim(NOME)
    nTamfra = len(M_FRAZE)
    cCampo  = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,nTamfra-at("=",M_FRAZE)))
    cCampo = strtran(cCampo,",",".")

    if lProduto
      do case
      case "xProd=" $ M_FRAZE
        mxProd := cCampo
      case "cProd=" $ M_FRAZE
        mcprod := tirazero(cCampo)
      case "CFOP=" $ M_FRAZE         
        M_CFOP := cCampo
      case "qCom=" $ M_FRAZE         
        mqcom := Val(cCampo)
      case "vUnCom=" $ M_FRAZE         
        M_NFEPUN := Val(cCampo)
      case "vProd=" $ M_FRAZE         
        mvprod   := Val(cCampo)
      case "vFrete=" $ M_FRAZE         
        M_NFEFRE := Val(cCampo)
      case "vDesc=" $ M_FRAZE         
        M_NFEDESCONT := Val(cCampo)
      case "vOutro=" $ M_FRAZE         
        M_NFEOUT := Val(cCampo)
      endcase
    else 
      if lIcms
        do case
        case "orig=" $ M_FRAZE         
          M_ORIGEM := cCampo
        case "CST=" $ M_FRAZE         
          M_CSTICM := cCampo
        case "pRedBC=" $ M_FRAZE         
          M_NFERED := Val(cCampo)
        case "vBC=" $ M_FRAZE         
          M_NFEBIC := Val(cCampo)
        case "pICMS=" $ M_FRAZE         
          M_NFEPIC := Val(cCampo)
        case "vICMS=" $ M_FRAZE         
          M_NFEVIC := Val(cCampo)
        case "vBCST=" $ M_FRAZE         
          M_NFEBICST := Val(cCampo)
        case "vICMSST=" $ M_FRAZE         
          M_NFEVICST := Val(cCampo)
          M_NFESUB  := Val(cCampo)
        endcase
      else 
        if lIPI
          do case
          case "CST=" $ M_FRAZE         
            M_CSTIPI := cCampo
          case "vBC=" $ M_FRAZE         
            M_NFEBIP := Val(cCampo)
          case "pIPI=" $ M_FRAZE         
            M_NFEPIP := Val(cCampo)
          case "vIPI=" $ M_FRAZE         
            M_NFEVIP := Val(cCampo)
          endcase
        else 
          if lPIS
            do case
              case "CST=" $ M_FRAZE         
                M_CSTPIS := cCampo
              case "vPIS=" $ M_FRAZE         
                mVpis := Val(cCampo)
            endcase
          else 
            if lCofins
              do case
                case "CST=" $ M_FRAZE         
                  M_CSTPIS := cCampo
                case "vCOFINS=" $ M_FRAZE         
                  mVCofins := Val(cCampo)
              endcase
            endif
          endif
        endif
      endif
    endif
    skip

    if "[Produto" $ NOME .or. "[Total]" $ NOME
      select ANFTM1
      append Blank

      replace NFEDTE with M_NFSDTE
      replace NFEDTR with mDataLanca
      replace NFEMAT With val(mcprod)
      replace NFEQDE   with NFEQDE + mqcom
      replace NFEPUN     with mvprod/mqcom
      replace NFESUB     with NFESUB + M_NFESUB
      replace NFEVLI     with NFEVLI + mvprod // sem desconto
      replace NFELIQ     with NFELIQ + (mvprod + m_nfeout - M_NFEDESCONT) // com desconto desconto
      replace NFELIQ1    with NFELIQ1 + mvprod // sem desconto
      replace NFEDESC    with NFEDESC + M_NFEDESCONT
      replace NFEBIC with NFEBIC + M_NFEBIC
      replace NFEVIC with NFEVIC + M_NFEVIC
      replace NFEISE with NFEISE + (((mvprod - M_NFEDESCONT)+M_NFEFRE) - (M_NFEBIC))
      replace NFEBIP with NFEBIP + M_NFEBIP
      replace NFEPIC with M_NFEPIC
      replace NFEPIP with M_NFEPIP
      replace NFEVIP with NFEVIP + M_NFEVIP
      replace NFEFRE with NFEFRE + M_NFEFRE
      replace NFECST with "0" + M_CSTICM
      replace PCADES with mxProd
      replace NFENATN with M_CFOP
      replace NFEBICST WITH M_NFEBICST 
      replace NFEVICST with M_NFEVICST

      M_NFESUB := 0
      mxProd := ""
      mcprod := ""
      M_CFOP := ""
      mqcom := 0
      M_NFEPUN := 0
      mvprod   := 0
      M_NFEFRE := 0
      M_NFEDESCONT := 0
      M_NFEOUT := 0
      M_ORIGEM := ""
      M_CSTICM := ""
      M_NFEBICST := 0
      M_NFEVICST := 0
      M_NFEPIC := 0
      M_NFEVIC := 0
      M_NFEBIC := 0
      M_NFERED := 0
      M_NFESUB := 0
      M_CSTIPI := ""
      M_NFEBIP := 0
      M_NFEPIP := 0
      M_NFEVIP := 0
      M_CSTPIS := ""
      mVpis := 0
      M_CSTPIS := ""
      mVCofins := 0

      lProduto = .t.
      lICMS = .f. // quando chegar no ICMS
      lPIS  = .f.
      lIPI  = .f.
      lCofins = .f.
    endif

    select ARQUIVO

    do case
      case "[ICMS" $ NOME
        lICMS = .t. // quando chegar no ICMS
        lIPI = .f. // quando chegar no ICMS
        lProduto = .f.
        lPIS  = .f.
        lCofins = .f.
      case "[IPI" $ NOME
        lIPI = .t. // quando chegar no ICMS
        lICMS = .f. // quando chegar no ICMS
        lProduto = .f.
        lPIS  = .f.
        lCofins = .f.
      case "[PIS" $ NOME
        lIPI = .f. // quando chegar no ICMS
        lICMS = .f. // quando chegar no ICMS
        lProduto = .f.
        lPIS  = .t.
        lCofins = .f.
      case "[COFINS" $ NOME
        lIPI = .f. // quando chegar no ICMS
        lICMS = .f. // quando chegar no ICMS
        lProduto = .f.
        lPIS  = .f.
        lCofins = .t.
      case "[Total]" $ NOME
        lAcabou = .t.
        exit 
    endcase
  enddo

  if eof()
    exit
  endif

enddo


select ANFTM1
sum NFEBICST to M_NFEBICST 
sum NFEVICST to M_NFEVICST

select ANFETM
replace NFEBICST with M_NFEBICST 
replace NFEVICST with M_NFEVICST 

select APCA00
set order to 1

if lLeu2
  select ARQUIVO
  use
endif

Return .t.


