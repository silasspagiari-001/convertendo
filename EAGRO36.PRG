#include "ptmenu.ch"

***************
function MANEXP
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("MENU","EXPORTAR",M_FAN,"EAGRO36","Mem: " + str(memory(0), 5),M_EMP)

*               @ 11, 53 prompt "Remessa      " HIGHLITE R/BG
*               @ 12, 53 prompt "Lista Retorno" HIGHLITE R/BG
*               @ 13, 53 prompt "Baixa Retorno"  HIGHLITE R/BG

             do case
               case M_OPC = 1 ; expsil()   // BRASIL
               case M_OPC = 2 ; lisretb()  // BRASIL   
               case M_OPC = 3 ; bairetob() // BRASIL   
             endcase        

    fecha_arq()

return ""

***************
function EXPSIL  // TRANSMISSAO BRASIL
*************** 

Local nBuffSize := 16                   // Read/write buffer size
Local l7143Supp := .F.                  // Is function 7143h supported?
local cRet := ""

rodape("TRANSMISSAO","BRASIL",M_FAN,"EAGRO36","Mem: " + str(memory(0), 5),M_EMP)

if file("REMESSA.MEM")
  restore from REMESSA.MEM additive
else
  RE_TAX    = 0
  RE_REM    = 0
endif

RE_REM ++

M_CARTEIRA = "17"
M_DESCONTADA = "     "

do while .t.

  M_OPC = msgbox3("Confirma Geracao da Remessa",,16,"Escolha","Sim","Nao")

  if M_OPC = 3
    return ""
  endif

  if M_OPC = 2
    exit
  endif
enddo  

M_ARQ = "B" + strzero(RE_REM, 7, 0) + ".TXT"

handle = fcreate(M_ARQ)

nSeq = 1

do case
  case AEMP00->EMPCGC == "037623347000109"
    M_FRAZE =  "00100000         237623347000109                    0765540000000004162 NUTRI INOVA SUPLEMENTOS NUTRICBANCO DO BRASIL S.A.                    1"
  case AEMP00->EMPCGC == "002715655000171"
    M_FRAZE =  "00100000         202715655000171                    0009730000001016695 CIRURCENTER PRODUTOS HOSPITALABANCO DO BRASIL S.A.                    1"
  case AEMP00->EMPCGC == "027435570000160"
    M_FRAZE =  "00100000         227435570000160                    0009730000000864382 NUTRI CENTER PRODUTOS NUTRICIOBANCO DO BRASIL S.A.                    1"
endcase

M_FRAZE = M_FRAZE + tira_bar4(date()) +;
             LEFT(TIME(),2)      +;
             SUBSTR(TIME(),4,2)  +;
             right(TIME(),2)     +;
             "00000008000000                                                                     "

fwrite(handle,M_FRAZE,240)
fwrite(handle,chr(13)+chr(10),2)

do case
  case AEMP00->EMPCGC == "002715655000171"
    M_FRAZE = "00100011R0100020 2002715655000171003004204001417019  0009730000001016695 CIRURCENTER PRODUTOS HOSPITALA                                                                                00000000" +;
    tira_bar4(date()) +;
    "0000000000000000003004204        CBR20702"
  case AEMP00->EMPCGC == "027435570000160"
    M_FRAZE = "00100011R0100020 2027435570000160003039421001417019  0009730000000864382 NUTRI CENTER PRODUTOS NUTRICIO                                                                                00000000" +;
    tira_bar4(date()) +;
    "0000000000000000003039421        CBR20702"
  case AEMP00->EMPCGC == "037623347000109"
    M_FRAZE = "00100011R0100020 2037623347000109003308315001417019  0765540000000004162 NUTRI INOVA SUPLEMENTOS NUTRIC                                                                                00000000" +;
    tira_bar4(date()) +;
    "0000000000000000003308315        CBR20702"
endcase

fwrite(handle,M_FRAZE,240)
fwrite(handle,chr(13)+chr(10),2)


sqlRELATION = {}
sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {}
sqlORDEM = {}

aadd(sqlARQUI,{"ADCR00","ADCR00"})
aadd(sqlCAMPO,"ADCR00.*")
aadd(sqlCAMPO,"ACLI00.CLINOM")
aadd(sqlCAMPO,"ACLI00.CLICGC2")
aadd(sqlCAMPO,"ACLI00.CLIEND3")
aadd(sqlCAMPO,"ACLI00.CLIBAI3")
aadd(sqlCAMPO,"ACLI00.CLIMUN3")
aadd(sqlCAMPO,"ACLI00.CLIUF3")
aadd(sqlCAMPO,"ACLI00.CLICEP3")
aadd(sqlCAMPO,"ACLI00.CLICCL3")
aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ADCR00.DUPCLI"})
aadd(sqlCHAVE,"DUPDTE <= " + aspas(formatdta(date()-1)))
aadd(sqlCHAVE,"ADCR00.DUPEMP = " + str(ME_EMP,2))
aadd(sqlCHAVE,"ADCR00.DUPHIS = 500")
aadd(sqlCHAVE,"ADCR00.DUPVLA > 0")
aadd(sqlCHAVE,"ADCR00.DUPBOL > 0")
aadd(sqlCHAVE,"ADCR00.DUPEXP = 'B'")  // ENVIA OU NAO PARA BANCO
sqlrelation()

aEXPORTADA = { }

do while !eof()

  msw(strzero(DUPNUM, 6, 0)  + "/" + strzero(DUPORD, 2, 0))

do case
  case AEMP00->EMPCGC == "002715655000171"
        M_FRAZE =  "00100013" + ;
        strzero(nSeq,5) + ; 
        "P 010009730000001016695 3004204" +;
        strzero(DUPBOL,10)  + ;
        "   11111" +;
        pad(alltrim(str(DUPNUM, 6, 0))  + "/" + alltrim(str(DUPORD, 2, 0)), 15) +;
        tira_bar4(DUPVCT)                      +;         // VENCIMENTO      POS 121 126 006
        stuff(strzero(DUPVLA,16, 2),14,1,"")  +;         // VALOR TITULO    POS 127 139 013
        "00000 02N" +;
        tira_bar4(DUPDTE)                      +;
        "200000000000000000001000000000000000000000000000000000000000000000000000000000                         30020000900197933251"
  case AEMP00->EMPCGC == "027435570000160"
        M_FRAZE =  "00100013" + ;
        strzero(nSeq,5) + ; 
        "P 010009730000000864382 3039421" +;
        strzero(DUPBOL,10)  + ;
        "   11111" +;
        pad(alltrim(str(DUPNUM, 6, 0))  + "/" + alltrim(str(DUPORD, 2, 0)), 15) +;
        tira_bar4(DUPVCT)                      +;         // VENCIMENTO      POS 121 126 006
        stuff(strzero(DUPVLA,16, 2),14,1,"")  +;         // VALOR TITULO    POS 127 139 013
        "00000 02N" +;
        tira_bar4(DUPDTE)                      +;
        "200000000000000000001000000000000000000000000000000000000000000000000000000000                         30020000900198278351"
  case AEMP00->EMPCGC == "037623347000109"
        M_FRAZE =  "00100013" + ;
        strzero(nSeq,5) + ;
        "P 010765540000000004162 3308315" +;
        strzero(DUPBOL,10)  + ;
        "   11111" +;
        pad(alltrim(str(DUPNUM, 6, 0))  + "/" + alltrim(str(DUPORD, 2, 0)), 15) +;
        tira_bar4(DUPVCT)                      +;         // VENCIMENTO      POS 121 126 006
        stuff(strzero(DUPVLA,16, 2),14,1,"")  +;         // VALOR TITULO    POS 127 139 013
        "00000 02N" +;
        tira_bar4(DUPDTE)                      +;
        "200000000000000000001000000000000000000000000000000000000000000000000000000000                         30020000900197933251"
endcase

  fwrite(handle,M_FRAZE,240) 
  fwrite(handle,chr(13)+chr(10),2)

  nSeq ++ 

  M_FRAZE =  "00100013" + strzero(nSeq,5) + "Q 01"  +;
              iif(len(rtrim(CLICGC2)) = 11,"1","2") +;
              strzero(val(CLICGC2),15)        +;
              pad(CLINOM,40)                  +;
              pad(CLIEND3,40)                 +;
              pad(CLIBAI3,15)                 +;
              strzero(CLICEP3,5)              +;
              strzero(CLICCL3,3)              +;
              pad(CLIMUN3,15)                 +;
              CLIUF3

do case
  case AEMP00->EMPCGC == "002715655000171"
              M_FRAZE = M_FRAZE + "0000000000000000                                        0003004204"
  case AEMP00->EMPCGC == "027435570000160"
              M_FRAZE = M_FRAZE + "0000000000000000                                        0003039421"
  case AEMP00->EMPCGC == "037623347000109"
              M_FRAZE = M_FRAZE + "0000000000000000                                        0003308315"
endcase

M_FRAZE = M_FRAZE + strzero(DUPBOL,10)  + "   12345678"


  fwrite(handle,M_FRAZE,240) 
  fwrite(handle,chr(13)+chr(10),2)

  nSeq ++  // SEGUIMENTO R

  M_FRAZE =  "00100013" + strzero(nSeq,5) + "R 010000000000000000000000000000000000000000000000002"  +; 
        tira_bar4(DUPVCT+1)                      +;         // VENCIMENTO      POS 121 126 006
        "000000000001000                                                                                          000000000000000000000000000000000000 000000000000  0000000000"

  fwrite(handle,M_FRAZE,240) 
  fwrite(handle,chr(13)+chr(10),2)

  nSeq = nSeq + 1  // SEGUIMENTO R

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"ADCR00","UPDATE"}
  aadd(sqlCHAVE,{"RECNO",str(ADCR00->RECNO,9)})
  aadd(sqlCAMPO,{"DUPEXP",aspas("*"),.f.})
  executasql()

  select ADCR00
  skip

enddo

 M_FRAZE =  "00100015         " +;
 strzero(nSeq,6) +;                  // SEQUENCIAL      POS 395 400 006
 "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000                                                                                                                             " 
                                
fwrite(handle,M_FRAZE,240) 
fwrite(handle,chr(13)+chr(10),2)

nSeq += 2 

M_FRAZE =  "00199999         000001" + strzero(nSeq,6) + "000000                                                                                                                                                                                                             "

fwrite(handle,M_FRAZE,240) 
fwrite(handle,chr(13)+chr(10),2)

fclose(handle)

save all like RE_* to REMESSA

do case
  case AEMP00->EMPCGC == "002715655000171"
  M_ARQ1 = "CNAB240_97_101669_"  +  tira_bar(date()) + "_" + alltrim(str(RE_REM, 7)) + ".REM"
  case AEMP00->EMPCGC == "027435570000160"
  M_ARQ1 = "CNAB240_97_86438_"  +  tira_bar(date()) + "_" + alltrim(str(RE_REM, 7)) + ".REM"
  case AEMP00->EMPCGC == "037623347000109"
  M_ARQ1 = "CNAB240_97_0004162_" +  tira_bar(date()) + "_" + alltrim(str(RE_REM, 7)) + ".REM"
endcase

Filecopy(M_ARQ,"C:\BancoBrasil\BBTransf\Remessa\"+M_ARQ1)           // Copy the file

fecha_arq()

msg("* * * FIM DO PROCESSO - TRANSMITA O ARQUIVO * * *")

return "" 

****************
function LERARQ
****************

cTextFile:=cFileDanfe
nFileHandle = FOPEN( cTextFile )
nFileSize = FSEEK( nFileHandle, 0, 2 ) 
FSEEK( nFileHandle, 0, 0 ) 
nBytesRead = 0 
cAccumText:="" 

DO WHILE nBytesRead<=nFileSize 
  cSingle = FREADSTR( nFileHandle, 1 ) 
  nBytesRead = nBytesRead + 1 
  IF cSingle = chr(13)  
    cSingle = FREADSTR( nFileHandle, 1 ) 
    nBytesRead = nBytesRead + 1 
    APPEND BLANK 
    REPL CAMPO WITH cAccumText
    cSingle = "" 
    cAccumText = ""
  ELSE 
    cAccumText = cAccumText + cSingle 
  ENDIF 
ENDDO 
IF !EMPT(cAccumText) 
  APPEND BLANK 
  REPL CAMPO WITH cAccumText 
ENDIF 
FCLOSE( nFileHandle ) 
retu

****************
function LISRETB // BRASIL
****************

M_CRITICA = { }

aadd(M_CRITICA,"01 - Identificacao invalida   ")
aadd(M_CRITICA,"02 - Variacao de carteira invalida")
aadd(M_CRITICA,"03 - Valor dos juros por um dia invalido")
aadd(M_CRITICA,"04 - Valor do desconto invalido")
aadd(M_CRITICA,"05 - Especie de titulo invalido para carteira")
aadd(M_CRITICA,"06 - Especie de valor variavel invalido")
aadd(M_CRITICA,"07 - Prefixo de agencia usuaria invalida")
aadd(M_CRITICA,"08 - Valor do titulo/apolice invalida")
aadd(M_CRITICA,"09 - Data do vencimento invalida")
aadd(M_CRITICA,"10 - Fora do prazo")
aadd(M_CRITICA,"11 - Inexistencia de margem para desconto")
aadd(M_CRITICA,"12 - O banco nao tem agencia na praca do sacado")
aadd(M_CRITICA,"13 - Razoes cadastrais")
aadd(M_CRITICA,"14 - Sacado interligado com o sacador")
aadd(M_CRITICA,"15 - Titulo sacado contra orgao do poder publico")
aadd(M_CRITICA,"16 - Titulo preenchido de forma irregular")
aadd(M_CRITICA,"17 - Titulo rasurado")
aadd(M_CRITICA,"18 - Endereco do sacado nao localizado ou imcompleto")
aadd(M_CRITICA,"19 - Codigo do cedente invalido")
aadd(M_CRITICA,"20 - Nome/endereco do cliente nao informado/ECT/")
aadd(M_CRITICA,"21 - Carteira invalida")
aadd(M_CRITICA,"22 - Quantidade de valor variavel invalida")
aadd(M_CRITICA,"23 - Faixa nosso-numero excedida")
aadd(M_CRITICA,"24 - Valor do abatimento invalido")
aadd(M_CRITICA,"25 - Novo numero do titulo dado pelo cedente invalido")
aadd(M_CRITICA,"26 - Valor do IOF de seguro invalido")
aadd(M_CRITICA,"27 - Nome do sacado/cedente invalido ou nao informado")
aadd(M_CRITICA,"28 - Data do novo vencimento invalido")
aadd(M_CRITICA,"29 - Valor do desconto maior ou igual ao valor do titulo.")
aadd(M_CRITICA,"30 - Registro de titulo ja liquidado")
aadd(M_CRITICA,"31 - Numero do bordero invalido")
aadd(M_CRITICA,"32 - Nome da pessoa autorizada invalido")
aadd(M_CRITICA,"33 - Nosso numero jah existente")
aadd(M_CRITICA,"34 - Numero da prestacao do contrato invalido")
aadd(M_CRITICA,"35 - Percentual de desconto invalido")
aadd(M_CRITICA,"36 - Dias para fichamento de protesto invalido")
aadd(M_CRITICA,"37 - Data de emissao do titulo invalida")
aadd(M_CRITICA,"38 - Data do vencimento anterior aa data da emissao do titulo")
aadd(M_CRITICA,"39 - Comando de alteracao indevido para a carteira")
aadd(M_CRITICA,"40 - Tipo de moeda invalido")
aadd(M_CRITICA,"41 - Abatimento nao permitido")
aadd(M_CRITICA,"42 - CEP/UF invalido/nao compativeis/ECT/")
aadd(M_CRITICA,"43 - Codigo de unidade variavel imcompativel com a data de emissao do titulo")
aadd(M_CRITICA,"44 - Dados para deposito ao sacado invalidos")
aadd(M_CRITICA,"45 - Carteira/variacao encerrada")
// parei aqui

aadd(M_CRITICA,"46 - Tipo/numero de inscricao do sacado invalidos.")
aadd(M_CRITICA,"47 - Endereco do sacado nao informado.")
aadd(M_CRITICA,"48 - CEP invalido.")
aadd(M_CRITICA,"49 - CEP sem praca de cobranca (nao localizado).")
aadd(M_CRITICA,"50")
aadd(M_CRITICA,"51")
aadd(M_CRITICA,"52 - Unidade da federacao invalida.")
aadd(M_CRITICA,"53 - Tipo/numero de inscricao do sacador/avalista invalidos.")
aadd(M_CRITICA,"54")
aadd(M_CRITICA,"55")
aadd(M_CRITICA,"56")
aadd(M_CRITICA,"57 - Codigo da multa invalido.")
aadd(M_CRITICA,"58 - Data da multa invalida.")
aadd(M_CRITICA,"59 - Valor/Percentual da multa invalido.")
aadd(M_CRITICA,"60 - Movimento para titulo nao cadastrado.")
aadd(M_CRITICA,"61 - Agencia cobradora invalida.")
aadd(M_CRITICA,"62 - Tipo de impressao invalido.")
aadd(M_CRITICA,"63 - Entrada para titulo ja cadastrado.")
aadd(M_CRITICA,"64")
aadd(M_CRITICA,"65")
aadd(M_CRITICA,"66")
aadd(M_CRITICA,"67")
aadd(M_CRITICA,"68 - Movimentacao invalida para o titulo.")
aadd(M_CRITICA,"69 - Alteracao de dados invalida.")
aadd(M_CRITICA,"70 - Apelido do cliente nao cadastrado.")
aadd(M_CRITICA,"71 - Erro na composicao do arquivo.")
aadd(M_CRITICA,"72 - Lote de servico invalido.")
aadd(M_CRITICA,"73 - Codigo do cedente invalido.")
aadd(M_CRITICA,"74 - Cedente nao pertence a cobranca eletronica/apelido nao confere com cedente.")
aadd(M_CRITICA,"75 - Nome da empresa invalido.")
aadd(M_CRITICA,"76 - Nome do banco invalido.")
aadd(M_CRITICA,"77 - Codigo da remessa invalido.")
aadd(M_CRITICA,"78 - Data/Hora de geracao do arquivo invalida.")
aadd(M_CRITICA,"79 - Numero sequencial do arquivo invalido.")
aadd(M_CRITICA,"80 - Numero da versao do Layout do arquivo/lote invalido.")
aadd(M_CRITICA,"81 - Literal 'REMESSA-TESTE' valida somente para fase de testes.")
aadd(M_CRITICA,"82 - Literal 'REMESSA-TESTE' obrigatorio para fase de testes.")
aadd(M_CRITICA,"83 - Tipo/numero de inscricao da empresa invalidos.")
aadd(M_CRITICA,"84 - Tipo de operacao invalido.")
aadd(M_CRITICA,"85 - Tipo de servico invalido.")
aadd(M_CRITICA,"86 - Forma de lancamento invalido.")
aadd(M_CRITICA,"87 - Numero da remessa invalido.")
aadd(M_CRITICA,"88 - Numero da remessa menor/igual que da remessa anterior.")
aadd(M_CRITICA,"89 - Lote de servico divergente.")
aadd(M_CRITICA,"90 - Numero sequencial do registro invalido.")
aadd(M_CRITICA,"91 - Erro na sequencia de segmento do registro detalhe.")
aadd(M_CRITICA,"92 - Codigo de movimento divergente entre grupo de segmentos.")
aadd(M_CRITICA,"93 - Quantidade de registros no lote invalido.")
aadd(M_CRITICA,"94 - Quantidade de registros no lote divergente.")
aadd(M_CRITICA,"95 - Quantidade de lotes do arquivo invalido.")
aadd(M_CRITICA,"96 - Quantidade de lotes no arquivo divergente.")
aadd(M_CRITICA,"97 - Quantidade de registros no arquivo invalido.")

abre_dcr("02")
abre_cli("03")

select 4
use &_PATH_\USR\CONREC\ARET00 alias ARET00 exclusive

rodape("LISTA","RETORNO",M_FAN,"EAGRO36","Mem: " + str(memory(0), 5),M_EMP)

sombra(12, 24, 14, 55,_SOMBRA_)

store space(12) to M_ARQUIVO

set color to GR+/W+
  @ 12, 24 say        "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴커"
  @ 13, 24 say        "쿙ome do Arquivo:              �"
  @ 14, 24 say        "읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸"
set color to 

@ 13, 42 get M_ARQUIVO pict "@!" valid !empty(M_ARQUIVO)
read

if lastkey()=27
  select ARET00
  use
  return ""
endif

select ARET00
zap

cFileDanfe = "C:\BANCOBRASIL\BBTRANSF\RETORNO\&M_ARQUIVO"
lerarq()

select ARET00
go top

if lastrec()=0
  msg("* * * ARQUIVO NAO ENCONTRADO * * *")
  select ARET00
  use
  select ADCR00
  set order to 1
  return ""
endif

select ADCR00
set order to 9

select ARET00

M_IMPRE = impresn()

if M_IMPRE = "N"
  select ARET00
  use
  select ADCR00
  set order to 1
  return ""
endif

if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
  ?? chr(15)                        && comprime
endif

store 0 to PG

M_TOT1 = 0
M_TOT2 = 0
M_QDE = 0

do while !eof()

  store PG + 1 to PG

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DO ARQUIVO DE RETORNO","EAGRO36",132)
  ? cent_cab(M_DATA,M_ARQUIVO,"PAG.: " + str(PG, 4, 0), 132)
  ? "+---------+------------+--------+--------+---------------------------------------------+--+------------+-----+-----+--------------+"
  ? "|  TITULO |NOSSO NUMERO|EMISSAO | VENCTO | CLI * NOME DO CLIENTE                       |UF|VLR ORIGINAL| POR |PRAZO| OBSERVACAO   |"
  ? "+---------+------------+--------+--------+---------------------------------------------+--+------------+-----+-----+--------------+"

  store 5 to LN

  do while !eof() .and. LN < 60

    if !substr(CAMPO, 1, 1) == "7"
      skip
      loop
    endif

    if !substr(ARET00->CAMPO, 107, 2) $ "17"  // sem registro pode pular
      select ARET00
      skip
      loop
    endif

    M_DUPBAN = val(substr(ARET00->CAMPO, 71,10))  // numero do boleto

    select ADCR00

    if !dbseek(M_DUPBAN)
      msg("* * * TITULO -=> " + M_DUPBAN + " NAO CADASTRADO * * *")
      select ARET00
      skip
      loop
    endif

    M_DUPNUM = DUPNUM
    M_DUPORD = DUPORD
    M_DUPSER = DUPSER


    M_VLO = DUPVLO
    M_VLA = DUPVLA

     ? " "
      ?? DUPNUM
      ?? "/"
      ?? strzero(DUPORD, 2, 0)
      ?? " "
      ?? M_DUPBAN
      ?? " "
      ?? DUPDTE
      ?? " "
      ?? DUPVCT
      ?? " "
      ?? DUPCLI
      ?? " "
      ACLI00->(dbsetorder(1), dbseek(str(ADCR00->DUPCLI, 5, 0)))
      ?? pad(ACLI00->CLINOM, 39)
      ?? " "
      ?? ACLI00->CLIUF3
      ?? " "
      ?? transform(M_VLO,"@E #,###,###.##") 
      ?? " "
      ?? str(DUPPOR, 5, 0)
      ?? " "
      ?? iif(DUPHIS = 500,str((DUPVCT - date()), 5, 0),"PAGA ")
      ?? " "
      do case
         case substr(ARET00->CAMPO, 109, 2) = "02"
         ?? "Tit Confirmado"
         case substr(ARET00->CAMPO, 109, 2) = "05"
         ?? "Liq sem regist"
         case substr(ARET00->CAMPO, 109, 2) = "15"
         ?? "Liq em Cartori"
         case substr(ARET00->CAMPO, 109, 2) = "06"
         ?? "Liquidacao    "
         case substr(ARET00->CAMPO, 109, 2) = "09"
         ?? "Baixa         "
         case substr(ARET00->CAMPO, 109, 2) = "10"
         ?? "Baixa Solicit."
         case substr(ARET00->CAMPO, 109, 2) = "03"         
         ?? "Tit Rejeitado "
         M_REJ = { } 
         pega_rejebra()
         for A = 1 to len(M_REJ)
           ? M_REJ[A]
           LN ++
         next
      endcase

     if !substr(ARET00->CAMPO, 109, 2) $ "06#09"
       M_TOT1 += M_VLO
       M_TOT2 += M_VLA
     endif

     LN++

     select ARET00

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

  ? replicate("-", 132)

  ? " TOTAL DE TITULOS " + str(M_QDE,4) + "                                                         TOTAL -=> "
  ?? transform(M_TOT1,"@R 9,999,999.99")
  ?? "      "
  ?? transform(M_TOT2,"@R 9,999,999.99")
  if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
    ?? chr(18)                        && descomprime
  endif

enddo

eject
 
set print off
set printer to
set console on 
set cursor on 
set relation to

if M_IMPRE = "A"
  editrel()
else
  msg("* * * FIM DE EMISSAO * * *")
endif

msg("* * * FIM DO PROCESSAMENTO * * *")

fecha_arq()

return "" 

*********************
function PEGA_REJEBRA
*********************

private M1,M2,M3,M4,M5
  M1 = substr(ARET00->CAMPO, 81,2)

  if val(M1) > 0
    aadd(M_REJ,M_CRITICA[val(M1)])
  endif

return ""

*********************
function PEGA_REJEDES
*********************

private M1,M2,M3,M4,M5
  M1 = substr(ARET00->CAMPO+ARET00->CAMPO1, 319,2)

  if val(M1) > 0
    aadd(M_REJ,M_CRITICA[val(M1)])
  endif

return ""

*****************
function BAIRETOB  // NAO SAI
*****************

abre_dcr("02")
abre_lcr("03")

select 4

use &_PATH_\USR\CONREC\ARET00 alias ARET00 exclusive

rodape("PROCESSA","RETORNO",M_FAN,"EAGRO36","Mem: " + str(memory(0), 5),M_EMP)

sombra(12, 24, 14, 55,_SOMBRA_)

store space(12) to M_ARQUIVO

set color to GR+/W+
  @ 12, 24 say        "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴커"
  @ 13, 24 say        "쿙ome do Arquivo:              �"
  @ 14, 24 say        "읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸"
set color to 

@ 13, 42 get M_ARQUIVO pict "@!" valid !empty(M_ARQUIVO)
read

if lastkey()=27
  return ""
endif

select ARET00
zap
cFileDanfe = "C:\BANCOBRASIL\BBTRANSF\RETORNO\&M_ARQUIVO"
lerarq()

select ARET00
go top

if lastrec()=0
  msg("* * * ARQUIVO NAO ENCONTRADO * * *")
  select ARET00
  use
  select ADCR00
  set order to 1
  return ""
endif

M_OPC = decide("Confirma Processamento deste Arquivo")

if M_OPC != 1
  return ""
endif

select ADCR00
set order to 9

M_T = "S"

do while !eof()
  
  if !substr(ARET00->CAMPO, 1, 1) == "7"
    select ARET00
    skip
    loop
  endif

  if !substr(ARET00->CAMPO, 109, 2) $ "05.06.07.08.09.10.15"
    select ARET00
    skip
    loop
  endif

  if !substr(ARET00->CAMPO, 107, 2) $ "17"  // sem registro pode pular
    select ARET00
    skip
    loop
  endif
    
  select ADCR00

  M_DUPBAN = val(substr(ARET00->CAMPO, 71,10))  // numero do boleto

  if !dbseek(M_DUPBAN)
    msg("* * * TITULO -=> " + str(M_DUPBAN,10) + " NAO CADASTRADO * * *")
    select ARET00
    skip
    loop
  endif

  if DUPHIS = 100
    select ARET00
    skip
    loop
  endif

  msw("* * * PROCESSANDO TITULOS -=> " + str(DUPNUM, 6, 0) + "/" + str(DUPORD, 2, 0) + " * * *")
  select ALCR00 

  _append(str(0, 2, 0) + "  " + str(0, 6, 0) + str(0, 2, 0) + str(0, 3, 0),"ALCR00")

  do while .t.
    if rlock()
      replace LANEMP with ME_EMP
      replace LANNUM with ADCR00->DUPNUM
      replace LANORD with ADCR00->DUPORD
      replace LANSER with ADCR00->DUPSER
      replace LANHIS with 100
      replace LANDTM with ctod(substr(ARET00->CAMPO, 111, 2) + "/" + substr(ARET00->CAMPO, 113, 2) + "/" + substr(ARET00->CAMPO, 115, 2))
      replace LANCLI with ADCR00->DUPCLI
      replace LANVAL with val(substr(ARET00->CAMPO+ARET00->CAMPO1, 254, 13))/100
      unlock
      exit 
    else
      msg("* * * (ALCR00) REGISTRO SENDO USADO * * *")
    endif
    if lastkey() = 17
      exit
    endif 
  enddo

  select ADCR00                && atualiza dados na duplicata 

  do while .t. 
    if rlock()
      replace DUPDTP with ctod(substr(ARET00->CAMPO, 111, 2) + "/" + substr(ARET00->CAMPO, 113, 2) + "/" + substr(ARET00->CAMPO, 115, 2))
      replace DUPHIS with 100
      replace DUPDSC with 0
      replace DUPVLP with DUPVLP + val(substr(ARET00->CAMPO+ARET00->CAMPO1, 254, 13))/100
      replace DUPVLA with 0
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
  skip

enddo

msg("* * * FIM DO PROCESSAMENTO * * *")

fecha_arq()

return "" 
