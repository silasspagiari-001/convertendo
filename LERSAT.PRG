/* Desenvolvido por :
Analista/Programador : Scilas Spajares Antonio
Contato              : 18 8807-0590
scilas@hotmail.com.br
Objetivo : ler arquivo danfe formato xml e fazer o lancemento
de nota fiscal
*/


****************
function RESUMO_SAT
****************

local nReqAttr := LFN_NORMAL
local nAllowAttr := LFN_ARCHIVE + LFN_READONLY
local aDirectory := {}
local aFileInfo := {}
local nHandle := 0
local lNamesOnly := LFN_FULLINFO
local nBuffSize := 16                   // Read/write buffer size
local lLfnSupport := .F.                // Are LFNs supported?
local l7143Supp := .F.                  // Is function 7143h supported?
local nBytes := 0                       // Bytes copied
local nTotBytes := 0                    // Total bytes copied
local nSeconds := 0                     // For timing the job

select 0
use XML1 exclusive alias ANFTM1

select 0
use XML0 exclusive alias ANFETM

select C860 
zap

select C870
zap

lLeu2 = .f.

mListaArq  := Directory(cDirSpec)
mListaCan  := Directory(cDirCanc)

aCanc = ""

for ABC = 1 to len(mListaCan)
  Linha := Memoread(mDireCanc + mListaCan[ABC][6])
  nPos1 := At('chCanc="CFe',Linha)
  nPos1 := nPos1+Len('chCanc="CFe')
  cChave:= Substr(Linha,nPos1,44)
  aCanc += "#" + cChave + "#"
next

for ABC = 1 to len(mListaArq)

  setcolor("w+/N")
    @ 24, 0 say mListaArq[ABC][6] + " " + str((ABC/len(mListaArq))*100,7,2)
  setcolor("")

  if !substr(mListaArq[ABC][6],3,44) $ aCanc
    le_sat(mDiretorio + mListaArq[ABC][6],,"PRODUTO")
  endif
next


***************
function LE_SAT(TIPO,TIPO1,F_OQUE)
***************

local aDirectory := {}
local aFileInfo := {}
local nHandle := 0
local nBuffSize := 16                   // Read/write buffer size
local lLfnSupport := .F.                // Are LFNs supported?
local l7143Supp := .F.                  // Is function 7143h supported?
local nBytes := 0                       // Bytes copied
local nTotBytes := 0                    // Total bytes copied
local nSeconds := 0                     // For timing the job

if F_OQUE == NIL
  F_OQUE = "NORMAL"
endif

if TIPO1 == NIL
  TIPO1 = "NORMAL"
endif

select ANFETM
zap
select ANFTM1
zap

if F_OQUE == "NORMAL"
  select C870
  zap
endif

aCODFOR    := ""
A_CODFOR   := { }
A_CGCFOR   := ""

cFileDanfe := TIPO

if left(TIPO,2) == "\N"
  TIPO = "\" + TIPO
endif

If !file(cFileDanfe)
  Return .f.
Endif

Linha       := Memoread(cFileDanfe)
nLinhalidas := 0
Linhatotal  := Len(Linha)
cLinhaTxt   := Linha

lLeu2 = .f.

if Linhatotal = 0
  msg("MUITO GRANDE")
  return ""
endif

if !lLeu2
//-- Pega Id da Nota Fiscal
nPos1 := At('Id="',Linha)
If nPos1==0
  Alert('Erro no Arquivo '+tipo+Chr(10)+;
  'Id=')
  Return nil

Endif
nPos1 := nPos1+Len('Id="')
cChave:= Substr(Linha,nPos1,47)
endif

//-- Pegando Cgc para Pesquisa do Item na base 

if !lLeu2
  InicioDoDado := '<dest>'
  FinalDoDado  := '</dest>'
  nPosIni      := At(InicioDoDado,Linha)
  nPosFim      := At(FinalDoDado,Linha)
  cRetdest     := '0'
  If nPosIni==0 .or. nPosFim==0
  else
    cRetdest := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
  endif

  InicioDoDado := '<CPF>'
  FinalDoDado  := '</CPF>'
  nPosIni      := At(InicioDoDado,cRetdest)
  nPosFim      := At(FinalDoDado,cRetdest)
  cCGCEmit     := ''
  If nPosIni==0 .or. nPosFim==0
  else
    cCGCEmit := Substr(cRetdest,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
  endif

  if cCGCEmit == ''
    InicioDoDado := '<CNPJ>'
    FinalDoDado  := '</CNPJ>'
    nPosIni      := At(InicioDoDado,cRetdest)
    nPosFim      := At(FinalDoDado,cRetdest)
    cCGCEmit     := ''
    If nPosIni==0 .or. nPosFim==0
    else
      cCGCEmit := Substr(cRetdest,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
    endif
  endif
endif

//---Pegando Dados para Lancamento da Capa da Nf
mBaseSubs := 0
m_vNf   := PegaDados('vNF' ,Alltrim(Linha) ,.f.)
m_cNF   := PegaDados('nCFe' ,Alltrim(Linha)  ,.f.)
m_serie := PegaDados('serie' ,Alltrim(Linha),.f. )
m_dEmi  := Char3Data(PegaDados('dEmi' ,Alltrim(Linha),.f. ))
m_Razao := PegaDados('xNome',Alltrim(Linha),.f. )
mCodigo  := ''
mDataLanca   := Date()

M_CODCONT = 0
M_NFEEST = ""

cIdNota := StrZero(val(m_cnf),6)

  if !lLeu2
    if !capasat()
      return ""
    endif
  endif

nQdeitens = 0
nSeq = 0

M_VALORSUB = 0
lRecsub = 0
nMaiorsub = 0
lReduz = .f.
lDeveriaReduz = .f.
lTipoVenda = 0
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

do while .t.

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
  cRetPIS      := '0'
  If nPosIni==0 .or. nPosFim==0
  else
    cRetPIS := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
  endif

  M_NFEPIS := 0
  M_NFEDESCONT := 0
  M_NFEDESCONT := val(PegaDados('vDesc' ,Alltrim(Linha) ,.f.) )
  // voltamos a pegar o desconto

  M_NFEBICST := val(PegaDados('vBCST' ,Alltrim(cRet) ,.f.) )
  M_NFEVICST := val(PegaDados('vICMSST' ,Alltrim(cRet) ,.f.) )

  M_NFEPIC := val(PegaDados('pICMS' ,Alltrim(Linha) ,.f.) )
  M_NFEVIC := val(PegaDados('vICMS' ,Alltrim(Linha) ,.f.) )
  M_NFEBIC := val(PegaDados('vBC' ,Alltrim(cRet) ,.f.) )
  M_NFERED := val(PegaDados('pRedBC' ,Alltrim(cRet) ,.f.) )

  M_ORIG := PegaDados('Orig' ,Alltrim(Linha) ,.f.)

  if F_OQUE == "NORMAL"
    M_CST   := PegaDados('CST' ,Alltrim(cret) ,.f.)
  else
    M_CST   := PegaDados('CST' ,Alltrim(cRetPIS) ,.f.)
  endif

  mxProd  := PegaDados('xProd',Alltrim(Linha) ,.f.)

  mcprod   := tirazero(Alltrim(PegaDados('cProd',Alltrim(Linha),.f.)))
  mqcom    := Val(PegaDados('qCom' ,Alltrim(Linha) ,.f.) )
  mvprod   := Val(PegaDados('vProd',Alltrim(Linha) ,.f.) )
  M_NFEPUN := val(PegaDados('vUnCom' ,Alltrim(Linha) ,.f.) )

  M_VITEM := val(PegaDados('vItem' ,Alltrim(Linha) ,.f.) )

  M_CFOP   := PegaDados('CFOP' ,Alltrim(Linha) ,.f.)
  M_NFEOUT := val(PegaDados('vOutro' ,Alltrim(Linha) ,.f.) )
  M_NFEFRE := val(PegaDados('vFrete' ,Alltrim(Linha) ,.f.) )
  M_NFEBIP := val(PegaDados('vUnid' ,Alltrim(Linha) ,.f.) )
  M_NFESUB := val(PegaDados('vICMSST' ,Alltrim(Linha) ,.f.) )
  M_NFEPIP := val(PegaDados('pIPI' ,Alltrim(Linha) ,.f.) )
  M_NFEVIP := val(PegaDados('vIPI' ,Alltrim(Linha) ,.f.) )

  mVpis   := val(PegaDados('vPIS' ,Alltrim(Linha) ,.f.) )
  mVCofins:= val(PegaDados('vCOFINS' ,Alltrim(Linha) ,.f.) )

  select C870

  if F_OQUE == "NORMAL"
    if !dbseek(M_ORIG+M_CST+M_CFOP+ str(M_NFEPIC,6,2))
      append Blank
    endif
  else
    M_ORIG= "0"
    if !dbseek(dtos(m_dEmi) + str(val(mcprod),6)+M_ORIG+M_CST+M_CFOP)
      append Blank
    endif
  endif

    if SATINI = 0
      replace SATINI with val(m_cNF)
    endif

    replace SATFIN with val(m_cNF)
    replace SATDTA with m_dEmi
    replace PCAMAT with val(mcprod)
    replace CST   with M_ORIG+M_CST
    replace CFOP  with M_CFOP
    replace ALIQ_ICMS with M_NFEPIC
    replace VLR_OPR with VLR_OPR + M_VITEM
    if M_NFEVIC > 0
      replace BC_ICMS with BC_ICMS + M_VITEM
    endif
    replace VLR_ICMS with VLR_ICMS + M_NFEVIC
    replace VLR_ITEM with VLR_ITEM + mvprod
    replace VLR_DSC with VLR_DSC + M_NFEDESCONT


    select C860
    if !dbseek(dtos(m_dEmi))
      append Blank
      replace SATDTA with m_dEmi
      replace SATINI with val(m_cNF)
      replace SATFIN with val(m_cNF)
    else
      if val(m_cNF) < SATINI 
        replace SATINI with val(m_cNF)
      endif
      if val(m_cNF) >  SATFIN
        replace SATFIN with val(m_cNF)
      endif
    endif

    select ANFTM1
    append Blank

    replace NFEDTE with m_demi
    replace NFEDTR with mDataLanca
    replace NFEMAT With val(mcprod)
    replace NFEQDE   with NFEQDE + mqcom
    replace NFEPUN     with mvprod/mqcom
    replace NFESUB     with NFESUB + M_NFESUB
    replace NFEVLI     with NFEVLI + mvprod // sem desconto
    replace NFELIQ     with NFELIQ + (mvprod + m_nfeout - M_NFEDESCONT) // com desconto desconto
    replace NFELIQ1    with NFELIQ1 + mvprod // sem desconto
    replace NFEBIC with NFEBIC + M_NFEBIC
    replace NFEVIC with NFEVIC + M_NFEVIC
    replace NFEISE with NFEISE + (((mvprod - M_NFEDESCONT)+M_NFEFRE) - (M_NFEBIC))
    replace NFEBIP with NFEBIP + M_NFEBIP
    replace NFEPIC with M_NFEPIC
    replace NFEPIP with M_NFEPIP
    replace NFEVIP with NFEVIP + M_NFEVIP
    replace NFEFRE with NFEFRE + M_NFEFRE
    replace NFECST with "0" + M_CST
    replace PCADES with mxProd
    replace NFENATN with M_CFOP
    replace NFEBICST WITH M_NFEBICST 
    replace NFEVICST with M_NFEVICST


    select RESNFS
    if !dbseek(M_CFOP + str(M_NFEPIC,6,2))
      append blank
    endif

    replace NFECST with "0" + M_CST
    replace NFENATN with M_CFOP
    replace NFEPIC with M_NFEPIC
    replace NFEVLI with NFEVLI + M_VITEM
    replace NFEBIC with NFEBIC + M_NFEBIC
    replace NFEVIC with NFEVIC + M_NFEVIC

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

//------------------------------------------------
Static Function CAPASAT()
Local Ok         := .t.
Local cChaveNota
Local InicioDoDado := '<total>'
Local FinalDoDado  := '</total>'
Local nPosIni      := At(InicioDoDado,Linha)
Local nPosFim      := At(FinalDoDado,Linha)
Local cRet         := '0'
If nPosIni==0 .or. nPosFim==0
  Return cRet
Endif
cRet         := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)

mAgenda      := '003'
mContabil    := Val(PegaDados('vCFe'  ,Alltrim(cRet) ,.f.))
mTotalProd   := Val(PegaDados('vProd' ,Alltrim(cRet) ,.f.))
mTotalIcms   := Val(PegaDados('vICMS' ,Alltrim(cRet) ,.f.))
mBaseIcms    := Val(PegaDados('vBC'   ,Alltrim(cRet) ,.f.))
mDesconto    := Val(PegaDados('vDesc' ,Alltrim(cRet) ,.f.))
mFreteNf     := Val(PegaDados('vFrete',Alltrim(cRet) ,.f.))
mTotalIpi    := Val(PegaDados('vIPI'  ,Alltrim(cRet) ,.f.))
mBaseSubs    := Val(PegaDados('vST'   ,Alltrim(cRet) ,.f.))
mOutros      := Val(PegaDados('vOutro',Alltrim(cRet) ,.f.))
mEspecie     := 'CFe'
mValorSubs   := 0
mCodFisc     := '???'
mValorOutro  := 0
xPediUsar    := ''

Sele ANFETM
Append Blank
replace NFEEMP with 1
replace NFEDTE with m_demi
Replace NFEDTR with mDataLanca
replace NFEVLN with mContabil
replace NFENUM with val(cIdnota)
Replace NFEVLM with mTotalProd
Replace NFEVIC with mTotalIcms
Replace NFEBIC with mBaseIcms
Replace NFEDSC with mDesconto
Replace NFEFRE with mFreteNf
Replace NFEDSN with mOutros
Replace NFEVIP with mTotalIpi
Replace NFEEST with "SP"
Replace NFESUB With mBaseSubs
replace NFSUSU with cCGCEmit

Return Ok



****************
function RESUMO_NFS
****************

local nReqAttr := LFN_NORMAL
local nAllowAttr := LFN_ARCHIVE + LFN_READONLY
local aDirectory := {}
local aFileInfo := {}
local nHandle := 0
local lNamesOnly := LFN_FULLINFO
local nBuffSize := 16                   // Read/write buffer size
local lLfnSupport := .F.                // Are LFNs supported?
local l7143Supp := .F.                  // Is function 7143h supported?
local nBytes := 0                       // Bytes copied
local nTotBytes := 0                    // Total bytes copied
local nSeconds := 0                     // For timing the job

if file("RESNFS.CDX")
  erase("RESNFS.CDX")
endif

select 0
use XML1 exclusive alias ANFTM1
copy stru to RESNFS

select 0
use RESNFS exclusive
index on NFENATN + str(NFEPIC,6,2) tag 1 to RESNFS

select 0
use XML0 exclusive alias ANFETM

lLeu2 = .f.

mListaArq  := Directory(cDirSpec)
aCanc = ""

for ABC = 1 to len(mListaArq)
  if "NFEDFE" $ upper(mListaArq[ABC][6]) // cancelamento
    cChave:= left(mListaArq[ABC][6],44)
    aCanc += "#" + cChave + "#"
  endif
next

for ABC = 1 to len(mListaArq)
  if !left(mListaArq[ABC][6],44) $ aCanc

    setcolor("w+/N")
      @ 24, 0 say mListaArq[ABC][6] + " " + str((ABC/len(mListaArq))*100,7,2)
    setcolor("")

    cFiledanfe = mDiretorio + mListaArq[ABC][6]
    select ANFTM1
    zap
    select ANFETM
    zap

    Linha       := Memoread(cFileDanfe)
    nLinhalidas := 0
    Linhatotal  := Len(Linha)
    cLinhaTxt   := Linha

    if Linhatotal > 0
      InicioDoDado := '<dhEmi>'
      FinalDoDado  := '</dhEmi>'
      nPosIni      := At(InicioDoDado,Linha)
      nPosFim      := At(FinalDoDado,Linha)
      cRet         := '0'
      If nPosIni==0 .or. nPosFim==0
      else
        cRet := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
        cRet = ctod(substr(cRet,9,2) + "/" + substr(cRet,6,2) + "/" + left(cRet,4))
        if cRet > M_DATA2
          loop
        endif 
      endif
    endif


    M_NFSNUM = val(substr(mListaArq[ABC][6],38,6))

    M_VALNFS = 0
    M_VALAPU = 0

    if "cStat>302<" $ clinhatxt  // denegado nao ler
      loop
    endif

    if "<natOp>LANCAMENTO DE CREDITO ATIVO IMOBILIZADO</natOp>" $ clinhatxt
      loop
    endif

    select ANFS00
    if dbseek(str(ME_EMP,2,0) + str(M_NFSNUM, 6, 0) + AEMP00->EMPSER)
      M_VALNFS = NFSVLN
      if NFSCAN $ "CD"
        msg("NOTA " + str(NFSNUM,6) + " NAO DEVERIA ESTAR CANCELADA")
      endif
    else
      if "DEVOLUCAO DE VENDAS" $ clinhatxt
        loop
      else
        msg("nao encontrei " + mListaArq[ABC][6])
      endif
    endif

    if Linhatotal = 0
      lDenega = .f.
      lerxml3()
      pega3()

      if lDenega
        loop
      endif

      select ANFTM1
      go top
      do while !eof()

        select RESNFS
        if !dbseek(ANFTM1->NFENATN + str(ANFTM1->NFEPIC,6,2))
          append blank
        endif

        replace NFECST with ANFTM1->NFECST
        replace NFENATN with ANFTM1->NFENATN
        replace NFEPIC with ANFTM1->NFEPIC

        replace NFEVLI with NFEVLI + (ANFTM1->NFEVLI - ANFTM1->NFEDESC)
        replace NFEBIC with NFEBIC + ANFTM1->NFEBIC
        replace NFEVIC with NFEVIC + ANFTM1->NFEVIC

         M_VALAPU += (ANFTM1->NFEVLI - ANFTM1->NFEDESC)

        select ANFTM1
        skip

      enddo

      if "SCILAS" $ M_LOGNOM
        if !str(M_VALAPU,12,2) == str(M_VALNFS,12,2)
          msg(mListaArq[ABC][6] + " " + str(M_VALAPU,12,2) + "-" + str(M_VALNFS,12,2))
        endif
      endif

      select ARQUIVO
      use
    else

      do while .t.

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

        M_NFEPIC := val(PegaDados('pICMS' ,Alltrim(Linha) ,.f.) )
        M_NFEVIC := val(PegaDados('vICMS' ,Alltrim(Linha) ,.f.) )
        M_NFEBIC := val(PegaDados('vBC' ,Alltrim(cRet) ,.f.) )

        M_NFEVICS := val(PegaDados('vICMSST' ,Alltrim(Linha) ,.f.) )

        M_CST   := "0" + PegaDados('CST' ,Alltrim(Linha) ,.f.)
        M_CFOP   := PegaDados('CFOP' ,Alltrim(Linha) ,.f.)
        M_NFEDSC   := Val(PegaDados('vDesc',Alltrim(Linha) ,.f.) )

        M_NFEVLI   := Val(PegaDados('vProd',Alltrim(Linha) ,.f.)) - M_NFEDSC


        InicioDoDado := '<IPI>'
        FinalDoDado  := '</IPI>'
        nPosIni      := At(InicioDoDado,Linha)
        nPosFim      := At(FinalDoDado,Linha)
        cRet         := '0'
        If nPosIni==0 .or. nPosFim==0
        else
          cRet         := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
        endif

        M_NFEVIP   := Val(PegaDados('vIPI',Alltrim(Linha) ,.f.))


        select RESNFS
        if !dbseek(M_CFOP + str(M_NFEPIC,6,2))
          append blank
        endif

        replace NFECST with M_CST
        replace NFENATN with M_CFOP
        replace NFEPIC with M_NFEPIC
        replace NFEVLI with NFEVLI + M_NFEVLI + M_NFEVICS + M_NFEVIP
        replace NFEBIC with NFEBIC + M_NFEBIC
        replace NFEVIC with NFEVIC + M_NFEVIC

        M_VALAPU += M_NFEVLI

        nSize         := Linhatotal-nLinhaLidas
        cLinha        := Right(cLinhaTxt,nSize)
        cLinhaTxt     := cLinha
        if nLinhaLidas >= Linhatotal
          exit
        endif
      enddo

      if "SCILAS" $ M_LOGNOM
        if !str(M_VALAPU,12,2) == str(M_VALNFS,12,2)
          msg(mListaArq[ABC][6] + " " + str(M_VALAPU,12,2) + "-" + str(M_VALNFS,12,2))
        endif
      endif

    endif
  endif
next


