***************
function SICREDI
***************

parameters M_DUPVLD,TIPO,F_NUM

if F_NUM = NIL
  F_NUM = 0
endif

M_JUROS = 2
lGravaseq = .f.
F_DESCONT = 0
X_NOSSONUM = 1
lJatemnum = .f.

if F_NUM = 0
  X_NOSSONUM = 0
  if file("&_PATH_\SICRED.DBF")
    restore from &_PATH_\SICRED.DBF additive
  endif

  X_NOSSONUM ++

  lGravaseq = .t.
else
  X_NOSSONUM = F_NUM
endif

BUSCAREGISTRO("ACLI00",1,{str(ADCR00->DUPCLI,7,0)},"SELECT")


set print on
set printer to "C:\ATLAS\TITULOS\BOLETO.INI"
set console off
set date brit
set century on

select ADCR00

? "[Titulo1]"
? "NumeroDocumento="+str(ADCR00->DUPNUM,6) + "/" + strzero(ADCR00->DUPORD,2) + "-" + ADCR00->DUPSER
? "NossoNumero=" + strzero(X_NOSSONUM,5)
? "Carteira=01"
? "ValorDocumento="+  strtran(alltrim(str(M_DUPVLD,12,2)),".",",")
? "Vencimento="+dtoc(ADCR00->DUPVCT)

*? "ValorDesconto=" + strtran(alltrim(str(F_DESCONT,12,2)),".",",")
*? "DataDesconto="+dtoc(ADCR00->DUPVCT)

? "TipoDiasProtesto=1"
? "CodigoNegativacao=1"
? "DiasDeProtesto=5"
? "DataDocumento="+dtoc(ADCR00->DUPDTE)
? "DataProcessamento="+dtoc(date())
? "DataMoraJuros="+dtoc(ADCR00->DUPVCT+1)
? "DataProtesto=" + dtoc(ADCR00->DUPVCT+5)

if M_JUROS > 0
  ? "ValorMoraJuros="+strtran(alltrim(str(((M_DUPVLD/100)*M_JUROS)/30,12,2)),".",",")
endif

? "LocalPagamento=PAGAVEL EM QUALQUER AGENCIA ATE O VENCIMENTO"

? "Especie=DM"
? "EspecieMod=R$"
? "Sacado.NomeSacado="+ACLI00->CLINOM

if len(rtrim(ACLI00->CLICGC1)) = 11
  ? "Sacado.CNPJCPF=" + transform(ACLI00->CLICGC1,"@R 999.999.999/99")
  ? "Sacado.Pessoa=0"
else
  ? "Sacado.CNPJCPF=" + right(transform(ACLI00->CLICGC1,"@R 999.999.999/9999-99"),18)
  ? "Sacado.Pessoa=1"
endif

? "Sacado.Logradouro="+ACLI00->CLIEND3
? "Sacado.Bairro="+ACLI00->CLIBAI3
? "Sacado.Cidade="+ACLI00->CLIMUN3
? "Sacado.UF="+ACLI00->CLIUF2
? "Sacado.CEP="+strzero(ACLI00->CLICEP2, 5) + "-" + strzero(ACLI00->CLICCL2, 3)

? "Aceite=1"
? "SeuNumero="+str(ADCR00->DUPNUM,6) + "/" + strzero(ADCR00->DUPORD,2) + "-" + ADCR00->DUPSER

set printer to
set print off
set console on
set century off

 sqlCAMPO = {}
 sqlCHAVE =  {}
 sqlARQUI = {"ADCR00","UPDATE"}
 aadd(sqlCHAVE,{"DUPEMP",str(ADCR00->DUPEMP,2)})
 aadd(sqlCHAVE,{"DUPNUM",str(ADCR00->DUPNUM,6)})
 aadd(sqlCHAVE,{"DUPSER",aspas(ADCR00->DUPSER)})
 aadd(sqlCHAVE,{"DUPORD",str(ADCR00->DUPORD,2)})
 aadd(sqlCAMPO,{"DUPBOL",str(X_NOSSONUM,12),.t.})
 aadd(sqlCAMPO,{"DUPTXD",str1(M_JUROS,2),.t.})

 if !ADCR00->DUPEXP == "*"  // ja exportado
   aadd(sqlCAMPO,{"DUPEXP","E",.t.})
 endif

 executasql()

set printer to
set print off
set console on

if lGravaseq
  save all like X_NOSSONUM to &_PATH_\SICRED.DBF
endif

mon_env('BOLETO.IncluirTitulos("c:\atlas\titulos\boleto.ini")')
cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

set century off

return ""

****************
function LAY_SIL
****************

parameters M_DUPVLD,TIPO,F_NUM

if F_NUM = NIL
  F_NUM = "0"
endif

M_JUROS = 2
lGravaseq = .f.

if F_NUM = 0

  X_NOSSONUM = 0

  if file("&_PATH_\BRASIL.DBF")
    restore from &_PATH_\BRASIL.DBF additive
  endif

  X_NOSSONUM ++

  lGravaseq = .t.
else
  X_NOSSONUM = F_NUM
endif

lJatemnum = .f.

// nova emissao
// acbr

set print on
set printer to "C:\ATLAS\TITULOS\BOLETO.INI"
set console off

set date brit
set century on

? "[Titulo1]"
? "NumeroDocumento="+str(ADCR00->DUPNUM,6) + "/" + strzero(ADCR00->DUPORD,2) + "-" + ADCR00->DUPSER
? "NossoNumero="+ strzero(X_NOSSONUM,10)
? "Carteira=17"
? "ValorDocumento="+  strtran(alltrim(str(M_DUPVLD,12,2)),".",",")
? "Vencimento="+dtoc(ADCR00->DUPVCT)

if M_JUROS > 0
  ? "ValorMoraJuros="+strtran(alltrim(str(((M_DUPVLD/100)*M_JUROS)/30,12,2)),".",",")
endif

? "DataDocumento="+dtoc(ADCR00->DUPDTE)
? "DataProcessamento="+dtoc(date())
? "DataMoraJuros="+dtoc(ADCR00->DUPVCT)
? "DataProtesto=" + dtoc(ADCR00->DUPVCT+5)
? "LocalPagamento=Pagavel em qualquer banco ate o vencimento."
? "Especie=DM"
? "EspecieMod=R$"
? "Sacado.NomeSacado="+ACLI00->CLINOM

if len(rtrim(ACLI00->CLICGC1)) = 11
  ? "Sacado.CNPJCPF=" + transform(ACLI00->CLICGC1,"@R 999.999.999/99") 
  ? "Sacado.Pessoa=0"
else
  ? "Sacado.CNPJCPF=" + right(transform(ACLI00->CLICGC1,"@R 999.999.999/9999-99"),18)
  ? "Sacado.Pessoa=1"
endif

? "Sacado.Logradouro="+ACLI00->CLIEND3
? "Sacado.Bairro="+ACLI00->CLIBAI3
? "Sacado.Cidade="+ACLI00->CLIMUN3
? "Sacado.UF="+ACLI00->CLIUF2
? "Sacado.CEP="+strzero(ACLI00->CLICEP2, 5) + "-" + strzero(ACLI00->CLICCL2, 3)
? "Mensagem=" + M_MENS01 + "|" + M_MENS02
? "Instrucao1=01"
? "Instrucao2=05"
? "Aceite=1"
? "OcorrenciaOriginal=0"
? "Parcela=1"
? "TotalParcelas=1"
? "SeuNumero="+str(ADCR00->DUPNUM,6) + "/" + strzero(ADCR00->DUPORD,2) + "-" + ADCR00->DUPSER
? "TipoDiasProtesto=1"
? "TipoImpressao=1"

set printer to
set print off
set console on
set century off

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"ADCR00","UPDATE"}
  aadd(sqlCHAVE,{"DUPEMP",str(ADCR00->DUPEMP,2)})
  aadd(sqlCHAVE,{"DUPNUM",str(ADCR00->DUPNUM,6)})
  aadd(sqlCHAVE,{"DUPSER",aspas(ADCR00->DUPSER)})
  aadd(sqlCHAVE,{"DUPORD",str(ADCR00->DUPORD,2)})
  aadd(sqlCAMPO,{"NUMBAN",str(X_NOSSONUM,12),.t.})
  aadd(sqlCAMPO,{"DUPTXD",str1(M_JUROS,2),.t.})
  if !DUPEXP == "*"  // ja exportado
    aadd(sqlCAMPO,{"DUPEXP","E",.t.})
  endif

  executasql()

if lGravaseq
  save all like X_NOSSONUM to &_PATH_\BRASIL.DBF
endif

*mon_env("BOLETO.LimparLista")
*cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
mon_env('BOLETO.IncluirTitulos("c:\atlas\titulos\boleto.ini")')
cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
*mon_env("BOLETO.Imprimir")
*cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

return ""

***************
function EXTMES
***************

parameter F_DATA

declare MT_MES[12]

MT_MES[ 1] = "JANEIRO  "
MT_MES[ 2] = "FEVEREIRO"
MT_MES[ 3] = "MARCO    "
MT_MES[ 4] = "ABRIL    "
MT_MES[ 5] = "MAIO     "
MT_MES[ 6] = "JUNHO    "
MT_MES[ 7] = "JULHO    "
MT_MES[ 8] = "AGOSTO   "
MT_MES[ 9] = "SETEMBRO "
MT_MES[10] = "OUTUBRO  "
MT_MES[11] = "NOVEMBRO "
MT_MES[12] = "DEZEMBRO "

return MT_MES[month(F_DATA)]

****************
function ACBR_SIL
****************

parameters M_DUPVLD

lGravaseq = .f.

X_NOSSOCIR = 0   // NUMERO CIRUR
X_NOSSONUT = 0   // NUMERO NUTRI

if file("&_PATH_\ISILNS.DBF")
  restore from &_PATH_\ISILNS.DBF additive
endif

if ME_EMP = 1
  X_NOSSOCIR ++
  X_NOSSONUM = X_NOSSOCIR
else
  X_NOSSONUT ++
  X_NOSSONUM = X_NOSSONUT
endif

lJatemnum = .f.

if ADCR00->DUPBOL > 0
  lJatemnum = .t.
  X_NOSSONUM  = ADCR00->DUPBOL
else
  // vamos pesquisar numero do boleto
  // se existir pegamos outro

  do while .t.
    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"ADCR00","ADCBOL"})
    aadd(sqlCAMPO,"DUPBOL")
    aadd(sqlCHAVE,"DUPEMP = " + str(ME_EMP,2))
    aadd(sqlCHAVE,"DUPBOL = " + str(X_NOSSONUM,12))
    sqlrelation()


    if !eof()
      if ME_EMP = 1
        X_NOSSOCIR ++
        X_NOSSONUM = X_NOSSOCIR
      else
        X_NOSSONUT ++
        X_NOSSONUM = X_NOSSONUT
      endif
      loop
    endif
    exit
  enddo
endif

select ADCR00

ZZ_ENDERECO = ""

set print on
set printer to "C:\CIRUR\TITULOS\BOLETO.INI"
set console off

set date brit
set century on

? "[Titulo1]"
? "NumeroDocumento="+str(ADCR00->DUPNUM,6) + "/" + strzero(ADCR00->DUPORD,2)
? "NossoNumero=" + strzero(X_NOSSONUM,8)
? "Carteira=17"
? "ValorDocumento="+  strtran(alltrim(str(M_DUPVLD,12,2)),".",",")
? "Vencimento="+dtoc(ADCR00->DUPVCT)
? "ValorDesconto=" + strtran(alltrim(str(0,12,2)),".",",")
? "DataDesconto="+dtoc(ADCR00->DUPVCT)

*if M_JUROS > 0
*  ? "ValorMoraJuros="+strtran(alltrim(str(((M_DUPVLD/100)*M_JUROS)/30,12,2)),".",",")
*endif

? "DataDocumento="+dtoc(ADCR00->DUPDTE)
? "DataProcessamento="+dtoc(date())
? "DataMoraJuros="+dtoc(ADCR00->DUPVCT)
? "LocalPagamento=Pagavel em qualquer banco ate o vencimento. Apos, atualize o boleto no site bb.com.br"
? "Especie=DM"
? "EspecieMod=R$"
? "Sacado.NomeSacado="+ACLI00->CLINOM

if len(rtrim(ACLI00->CLICGC1)) = 11
  ? "Sacado.CNPJCPF=" + transform(ACLI00->CLICGC1,"@R 999.999.999/99") 
  ? "Sacado.Pessoa=0"
else
  ? "Sacado.CNPJCPF=" + right(transform(ACLI00->CLICGC1,"@R 999.999.999/9999-99"),18)
  ? "Sacado.Pessoa=1"
endif

? "Sacado.Logradouro="+ACLI00->CLIEND3
? "Sacado.Bairro="+ACLI00->CLIBAI3
? "Sacado.Cidade="+ACLI00->CLIMUN3
? "Sacado.UF="+ACLI00->CLIUF2
? "Sacado.CEP="+strzero(ACLI00->CLICEP2, 5) + "-" + strzero(ACLI00->CLICCL2, 3)
? "Mensagem=Juros...: 10% ao mes - (R$ "  + strtran(alltrim(str(((M_DUPVLD/100)*M_JUROS)/30,12,2)),".",",") + " ao dia)|Multa...: 10% apos o 1 dia corrido do vencimento|Nao Protestar"
? "Instrucao1=07"
? "Instrucao2=00"
? "Aceite=1"
? "SeuNumero="+str(ADCR00->DUPNUM,6) + "/" + strzero(ADCR00->DUPORD,2) + "-" + ADCR00->DUPSER

set printer to 
set print off
set console on
set century off

mon_env('BOLETO.IncluirTitulos("C:\CIRUR\titulos\boleto.ini")')
cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"ADCR00","UPDATE"}
  aadd(sqlCHAVE,{"DUPEMP",str(ADCR00->DUPEMP,2)})
  aadd(sqlCHAVE,{"DUPNUM",str(ADCR00->DUPNUM,6)})
  aadd(sqlCHAVE,{"DUPSER",aspas(ADCR00->DUPSER)})
  aadd(sqlCHAVE,{"DUPORD",str(ADCR00->DUPORD,2)})
  aadd(sqlCAMPO,{"DUPBOL",str(X_NOSSONUM,12),.t.})

  executasql()

set century off

if !lJatemnum
  save all like X_NOSSO* to &_PATH_\ISILNS.DBF
endif

return ""
