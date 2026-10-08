*****************
function CORRECAO
*****************

local cRet := ""
local nBuffSize := 16                   // Read/write buffer size
local l7143Supp := .F.                  // Is function 7143h supported?


if ME_EMP = 1
  Filecopy("C:\ACBrNfeMonitor\ACBrCirur.ini","C:\ACBrNfeMonitor\ACBrMonitor.ini")           // Copy the file
else
  Filecopy("C:\ACBrNfeMonitor\ACBrNutri.ini","C:\ACBrNfeMonitor\ACBrMonitor.ini")           // Copy the file
endif

mon_env("ACBr.Lerini")

nTela2 := savescreen(0,0,24,80)

setcolor("B/W")
nbox(5,10,18,70,"W/W+",.t.)

@ 6, 11 say padc("EMITINDO CARTA DE CORRECAO",59)

exc_arq(ACBrNFe_UNI)

// pedimos para mudar para embiente de homologacao teste

// 1 producao
// 2 homologacao

mon_env("NFE.SetAmbiente(1)")
cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

mon_env("NFE.SetFormaEmissao(1)")
cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

set print on
set printer to "CORRE.TXT"
set console off

M_COROQUE = ""

for CA_CO = 1 to 9
  MS = str(CA_CO,1)
  M_COROQUE += M_COR&MS += ";"  // chr(13) + chr(10)
next

?? 'NFE.CARTADECORRECAO("[CCE]'
? "idLote=1"
? "[EVENTO001]" 
? "chNFe=" + left(M_NFSID,44) 
? "cOrgao=35"
? "CNPJ=" + right(AEMP00->EMPCGC,14)
? "dhEvento=" + dtoc(date()) 
?? " " + time()
? "nSeqEvento=02"
? "xCorrecao=" + M_COROQUE +  '")' 
?

set printer to
set print off
set console on

M_ARQ = "CORRE.TXT"
M_MEMO1 = memoread("&M_ARQ")

mon_env(m_memo1)

cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

pos = rat("CSTAT=",upper(cret))

if pos > 0 
  lTemretorno = .t.
endif

M_NOAR = substr(cret,POS+6,3)

if M_NOAR = "135" // OK NOTA CONFIRMADA IMPRIMIR DANFE
  pos = rat("NPROT=",upper(cret))
  M_NOAR = substr(cret,POS+6,20)

  select 0
  use &_PATH_\USR\CORRECAO\CORRECAO exclusive via "DBFNTX"
  zap
  append blank
  replace protocolo with alltrim(str(val(M_NOAR)))
  replace chave     WITH left(M_NFSID,44) 
  replace NFSNUM    with M_NFSNUM
  replace CLINOM    with ACLI00->CLINOM
  if len(rtrim(ACLI00->CLICGC1)) = 11
    replace CNPJ with transform(ACLI00->CLICGC1,"@R 999.999.999/99")
  else
    replace CNPJ with  transform(ACLI00->CLICGC1,"@R 999.999.999/9999-99")
  endif
  replace LINHA1 with M_COR1
  replace LINHA2 with M_COR2
  replace LINHA3 with M_COR3
  replace LINHA4 with M_COR4
  replace LINHA5 with M_COR5
  replace LINHA6 with M_COR6
  replace LINHA7 with M_COR7
  replace LINHA8 with M_COR8
  replace LINHA9 with M_COR9
  use
else
  cRet += chr(13)+chr(10)
  cRet += "PRESSIONE (ESC) PARA SAIR"+ chr(13)+chr(10)
  cRet += chr(13)+chr(10)
  cRet += "A CARTA DE CORRECAO NAO FOI APROVADA"+ chr(13)+chr(10)
  keyboard chr(30)  // CTRL + PageDown
  setcolor("N/W*")
  M_MEMO = memoedit(cRet,07,11,17,69,.f.,,60)
  setcolor("")
  restscreen(0,0,24,80,nTela2)
  return .f.
endif

restscreen(0,0,24,80,nTela2)

return .t.

