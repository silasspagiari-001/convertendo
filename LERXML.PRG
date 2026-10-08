/* Desenvolvido por :
Analista/Programador : Scilas Spajares Antonio
Contato              : 18 8807-0590
scilas@hotmail.com.br
Objetivo : ler arquivo danfe formato xml e fazer o lancemento
de nota fiscal
*/

***************
function LE_XML(TIPO,TIPO1)
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

if TIPO1 == NIL
  TIPO1 = "NORMAL"
endif

select ANFETM
zap
select ANFTM1
zap

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
  lerxml2()
  lLeu2 = .t.
endif

if TIPO1 == "AUTORIZADA"
  InicioDoDado := '<cStat>'
  FinalDoDado  := '</cStat>'
  nPosIni      := At(InicioDoDado,Linha)
  nPosFim      := At(FinalDoDado,Linha)
  cRet         := 'XXX'
  If nPosIni==0 .or. nPosFim==0
  else
    cRet         := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
  endif
  return cRet
endif

if !lLeu2
//-- Pega Id da Nota Fiscal
nPos1 := At('Id="',Linha)
If nPos1==0
  Alert('Erro no Arquivo '+cFileDanfe+Chr(10)+;
  'Id=')
  Return nil
Endif
nPos1 := nPos1+Len('Id="')
cChave:= Substr(Linha,nPos1,47)
endif

//-- Pegando Cgc para Pesquisa do Item na base 

if !lLeu2
nPos1 := At('<CNPJ>',Linha)
If nPos1==0
  Alert('Erro no Arquivo '+cFileDanfe)
  Return nil
Endif

nPos1   := nPos1+Len('<CNPJ>')
cCGCEmit:= Substr(Linha,nPos1,14)
endif

//---Pegando Dados para Lancamento da Capa da Nf
mBaseSubs := 0
m_vNf   := PegaDados('vNF' ,Alltrim(Linha) ,.f.)
m_cNF   := PegaDados('nNF' ,Alltrim(Linha)  ,.f.)
m_serie := PegaDados('serie' ,Alltrim(Linha),.f. )
m_dEmi  := Char2Data(PegaDados('dEmi' ,Alltrim(Linha),.f. ))
m_Razao := PegaDados('xNome',Alltrim(Linha),.f. )
mCodigo  := ''
mDataLanca   := Date()

M_CODCONT = 0
M_NFEEST = ""

cIdNota := StrZero(val(m_cnf),6)

if !lLeu2
  if !capanota()
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
  cRet2         := '0'

  If nPosIni==0 .or. nPosFim==0
  else
    cRet2       := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
  endif

  InicioDoDado := '<infAdProd>'
  FinalDoDado  := '</infAdProd>'
  nPosIni      := At(InicioDoDado,Linha)
  nPosFim      := At(FinalDoDado,Linha)
  cRet3         := '0'

  If nPosIni==0 .or. nPosFim==0
  else
    cRet3       := Substr(Linha,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
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

  M_NFEBICST := val(PegaDados('vBCST' ,Alltrim(cRet) ,.f.) )
  M_NFEVICST := val(PegaDados('vICMSST' ,Alltrim(cRet) ,.f.) )

  M_NFEPIC := val(PegaDados('pICMS' ,Alltrim(Linha) ,.f.) )
  M_NFEVIC := val(PegaDados('vICMS' ,Alltrim(Linha) ,.f.) )
  M_NFEBIC := val(PegaDados('vBC' ,Alltrim(cRet) ,.f.) )
  M_NFERED := val(PegaDados('pRedBC' ,Alltrim(cRet) ,.f.) )

  M_CST   := PegaDados('CST' ,Alltrim(Linha) ,.f.)

  mxProd  := PegaDados('xProd',Alltrim(Linha) ,.f.)

  mcprod   := tirazero(Alltrim(PegaDados('cProd',Alltrim(Linha),.f.)))
  mqcom    := Val(PegaDados('qCom' ,Alltrim(Linha) ,.f.) )
  mvprod   := Val(PegaDados('vProd',Alltrim(Linha) ,.f.) )
  M_NFEPUN := val(PegaDados('vUnCom' ,Alltrim(Linha) ,.f.) )
  M_CFOP   := PegaDados('CFOP' ,Alltrim(Linha) ,.f.)
  M_NFEOUT := val(PegaDados('vOutro' ,Alltrim(Linha) ,.f.) )
  M_NFEFRE := val(PegaDados('vFrete' ,Alltrim(Linha) ,.f.) )
  M_NFEBIP := val(PegaDados('vUnid' ,Alltrim(Linha) ,.f.) )
  M_NFESUB := val(PegaDados('vICMSST' ,Alltrim(Linha) ,.f.) )
  M_NFEPIP := val(PegaDados('pIPI' ,Alltrim(Linha) ,.f.) )
  M_NFEVIP := val(PegaDados('vIPI' ,Alltrim(Linha) ,.f.) )

  mVpis   := val(PegaDados('vPIS' ,Alltrim(Linha) ,.f.) )
  mVCofins:= val(PegaDados('vCOFINS' ,Alltrim(Linha) ,.f.) )

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
    replace PARTIDA  with cRet3
    replace NFEBICST WITH M_NFEBICST 
    replace NFEVICST with M_NFEVICST

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

if lLeu2
  select ARQUIVO
  use
endif

Return .t.

//------------------------------------------------
Static Function CAPANOTA()
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

Sele ANFETM
Append Blank
replace NFEEMP with 1
replace NFEDTE with m_demi
Replace NFEDTR with mDataLanca
replace NFEVLN with mContabil
replace NFENUM with val(cIdnota)
Replace NFEVLM with mContabil  // mTotalProd
Replace NFEVIC with mTotalIcms
Replace NFEBIC with mBaseIcms
Replace NFEFRE with mFreteNf
Replace NFEDSN with mOutros
Replace NFEVIP with mTotalIpi
*Replace NFEEST with ANFE00->FOREST
Replace NFESUB With mBaseSubs

Return Ok

****************
function LERXML2
****************

select 0
use arquivo exclusive
zap 

cTextFile:=cFileDanfe
nFileHandle = FOPEN( cTextFile )
nFileSize = FSEEK( nFileHandle, 0, 2 ) 
FSEEK( nFileHandle, 0, 0 ) 
nBytesRead = 0 
cAccumText:="" 
DO WHILE nBytesRead<=nFileSize 
cSingle = FREADSTR( nFileHandle, 1 ) 
nBytesRead = nBytesRead + 1 
IF cSingle = ">" 
cSingle = FREADSTR( nFileHandle, 1 ) 
nBytesRead = nBytesRead + 1 
IF cSingle = "<" 
APPEND BLANK 
REPL nome WITH cAccumText+">" 
cSingle = "" 
cAccumText = "<" 
ELSE 
cAccumText = cAccumText + ">" +cSingle 
ENDIF 
ELSE 
cAccumText = cAccumText + cSingle 
ENDIF 
ENDDO 
IF !EMPT(cAccumText) 
APPEND BLANK 
REPL nome WITH cAccumText 
ENDIF 
FCLOSE( nFileHandle ) 
retu