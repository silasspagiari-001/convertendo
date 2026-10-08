************
function PIS
************

select 0
use PISCOF exclusive
zap

select 0
use XML1 exclusive alias ANFTM1

select 0
use XML0 exclusive alias ANFETM

if file("SPED1.CDX")
  erase("SPED1.CDX")
endif

select 0
use SPED1 exclusive
index on CST + CODIGO tag 1 to SPED1
zap

M_DATA1 = ctod("01/09/2016")
M_DATA2 = lastday(M_DATA1)

set print on
set printer to "C:\PIS\COFINS.TXT"

//    0.65
//    3.00

M_PIS = 0.65
M_COF = 3.0

TOTVDA = 0
VL_REC_BRT = 0
M_NFSBIC = 0
M_TOTVPIS = 0
M_TOTVCOF = 0
M_BASE05 = 0
M_NFSISE = 0
M_REG190 = 0

QDE_LIN = 1

// REGISTRO 0000 ABERTURA IDENTIFICACAO E REFERENCIA

nCAMPO = "|0000|" 
nCAMPO += "003|"                                       // 02 versao do layout
nCAMPO += "0|"                                         // 03 tipo inscricao 0=original 1-retificadora
nCAMPO += "|"                                         // 04 indicador de situacao especial
nCAMPO += "|"                                          // 05 numero recibo quando campo 03 = 1
nCAMPO += fordata(M_DATA1) + "|"                          // 06 data inicial
nCAMPO += fordata(M_DATA2) + "|"                          // 07 data final
nCAMPO += alltrim(AEMP00->EMPNOM) + "|"                // 08 nome
nCAMPO += right(AEMP00->EMPCGC,14) + "|"               // 09 cnpj
nCAMPO += pad(AEMP00->EMPEST,2) + "|"                  // 10 uf
nCAMPO += "3541406|"                                   // 11 cod cidade\
nCAMPO += "|"                                          // 12 suframa
nCAMPO += "00|"                                        // 13 natureza pessoa juridica
nCAMPO += "2|"                                         // 14 tipo de atividade

select PISCOF
append blank
replace CODIGO with "0000"
replace CAMPO with nCAMPO

QDE_D100 = 0
QDE_D101 = 0
QDE_D105 = 0

BLOCO_D = 0

BLOCO_0 = 0
QDE_C500 = 0
QDE_C501 = 0
QDE_C505 = 0
BLOCO_C = 0 

nCAMPO = "|0001|"
nCAMPO += "0|"

select PISCOF
append blank
replace CODIGO with "0001"
replace CAMPO with nCAMPO

QDE_LIN ++

nCAMPO =  "|0100|SERGIO ANTONIO MARTINS|01774747855|1SP20456/0-8|67664342000187|||||||||3541406|"

select PISCOF
append blank
replace CODIGO with "0100"
replace CAMPO with nCAMPO

QDE_LIN ++

nCAMPO = "|0110|2|1|1||"   // 04

select PISCOF
append blank
replace CODIGO with "0110"
replace CAMPO with nCAMPO

QDE_LIN ++

nCAMPO =  "|0140|0532|CIRURCENTER PROD HOSPITALARES LTDA|02715655000171|SP|562165596111|3541406|||"

select PISCOF
append blank
replace CODIGO with "0140"
replace CAMPO with nCAMPO

QDE_LIN ++

select 0
use ACLISP exclusive
index on NFSCLI tag 1 to ACLISP
set index to ACLISP
zap

select ANFS00
copy stru to ACLI0  // PRODUTOS
select 0
use ACLI0 exclusive
index on NFSCLI tag 1 to ACLI0
set index to ACLI0

select ANFS01
copy stru to APROD  // PRODUTOS

select 0
use APROD exclusive
index on NFSMAT tag 1 to APROD
set index to APROD

  select ANFS00
  set order to 2

  dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)

// 0150   CADASTRO CLIENTES FORNECEDORES

M_REG150 = 0

  do while !eof()

    if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
      exit
    endif


//    0.65
//    3.00


    @ 24, 00 say NFSDTE

    // 1411
    // 1909
    // 5102 OK
    // 5202 
    // 5411
    // 5551
    // 5908 OK
    // 5909
    // 5910 OK
    // 5915
    // 5917
    // 5918
    // 5929
    // 5949
    // 6102 OK
    // 6108
    // 6202 OK
    // 6912
    // 6915
    // 6949
    // 

    if !alltrim(tira_pto(NFSNATN)) $ "#5102#6102#5405#5411#6108#6202#6411#5933#"
      skip
      loop
    endif

    if ANFS00->NFSCAN $ "CD"  
      skip
      loop
    endif

    if inkey() = 27
      if suspro()
        lCancelou = .t.
        msg("* * * PROCESSO SUSPENSO * * *")
        select ANFS00
        go bottom
        skip
        select ANFS01
        go bottom
        skip
        loop
      endif
    endif

    select ACLISP
    if !dbseek(pad(alltrim(str(ANFS00->NFSCLI,7)),12))
      append blank
      replace NFSCLI with alltrim(str(ANFS00->NFSCLI,7))
    else
      select ANFS00
      skip
      loop
    endif

    select ANFS00

    lNao = .f.

    if !ACLI00->(dbseek(str(ANFS00->NFSCLI, 7, 0)))
      lNao = .t.
      msg("* * * CLIENTE NAO CADASTRADO " + str(ANFS00->NFSCLI,7) + "NOTA NUMERO: " + STR(ANFS00->NFSNUM,6) + " * * *")
      skip
      loop
    endif

    M_REG150 ++

    nCAMPO = "|0150|"  // REGISTRO 01
    nCAMPO += alltrim(str(ANFS00->NFSCLI,7)) + "|" // 02
    nCAMPO += alltrim(ACLI00->CLINOM) + "|" // 03
    nCAMPO += "1058|"              // 04 PAIS

    if len(alltrim(ACLI00->CLICGC1))=15
      nCAMPO += right(ACLI00->CLICGC1,14) + "|" + "|"     // 06 CPF
    else
      if !empty(ACLI00->CLICGC1)
        nCAMPO += "|" + pad(alltrim(ACLI00->CLICGC1),11) + "|" 
      endif
    endif

    nCAMPO += "|"     // 07 IE

    nCAMPO += str(ACLI00->CLICDM2,7) + "|"

    nCAMPO += "|"     // 09 SUFRAMA
    nCAMPO += "|"     // 10 END
    nCAMPO += "|"     // 11 NUM
    nCAMPO += "|"     // 12 COMPL
    nCAMPO += "|"     // 13 BAIRRO

    select PISCOF
    append blank
    replace CODIGO with "0150"
    replace CAMPO with nCAMPO

    QDE_LIN ++
    select ANFS00
    skip
  enddo

// FORNECEDORES

  select ANFE00
  set order to 2

  dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)

  do while !eof()

    @ 24, 00 say NFEDTE
    
    if str(NFEEMP, 2, 0) + dtos(NFEDTR) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
      exit
    endif

    AFIS00->(dbseek(ANFE00->NFENATN))

    if !alltrim(tira_pto(NFENATN)) $ "#1202#"  // DEVOLUCAO
      skip
      loop
    endif

    if inkey() = 27
      if suspro()
        lCancelou = .t.
        msg("* * * PROCESSO SUSPENSO * * *")
        select ANFS00
        go bottom
        skip
        select ANFS01
        go bottom
        skip
        loop
      endif
    endif

    select ACLISP
    if !dbseek(pad("F"+alltrim(str(ANFE00->NFEFOR,7)),12))
      append blank
      replace NFSCLI with "F"+alltrim(str(ANFE00->NFEFOR,7))
    else
      select ANFE00
      skip
      loop
    endif

    select ANFE00

    lNao = .f.

    if !AFOR00->(dbseek(str(ANFE00->NFEFOR, 7, 0)))
      lNao = .t.
      msg("* * * FORNECEDOR NAO CADASTRADO " + str(ANFE00->NFEFOR,7) + "NOTA NUMERO: " + STR(ANFE00->NFENUM,6) + " * * *")
      skip
      loop
    endif

    M_REG150 ++

    nCAMPO = "|0150|"  // REGISTRO 01
    nCAMPO += "F"+alltrim(str(ANFE00->NFEFOR,7)) + "|" // 02
    nCAMPO += alltrim(AFOR00->FORNOM) + "|" // 03
    nCAMPO += "1058|"              // 04 PAIS

    if len(alltrim(AFOR00->FORCGC))=15
      nCAMPO += right(AFOR00->FORCGC,14) + "|" + "|"     // 06 CPF
    else
      if !empty(AFOR00->FORCGC)
        nCAMPO += "|" + pad(alltrim(AFOR00->FORCGC),11) + "|" 
      endif
    endif

    nCAMPO += "|"     // 07 IE

    nCAMPO += str(AFOR00->FORCDM,7) + "|"
    nCAMPO += "|"     // 09 SUFRAMA
    nCAMPO += alltrim(AFOR00->FOREND) + "|"     // 10 END
    nCAMPO += "|"     // 11 NUM
    nCAMPO += "|"     // 12 COMPL
    nCAMPO += alltrim(AFOR00->FORBAI) + "|"    // 13 BAIRRO

    select PISCOF
    append blank
    replace CODIGO with "0150"
    replace CAMPO with nCAMPO

    QDE_LIN ++
    select ANFE00
    skip
  enddo

// FIM FORNECEDORES

// 0190   CADASTRO UNIDADES DE MEDIDA

// 0200 CADASTRO PRODUTOS

aUnidade = { }
aadd(aUnidade,"PC")

  select ANFS00
  set order to 2

  dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)

  do while !eof()

    if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
      exit
    endif

    AFIS00->(dbseek(ANFS00->NFSNATN))

    if !alltrim(tira_pto(NFSNATN)) $ "#5102#6102#5405#5411#6108#6202#6411#5933#"
      skip
      loop
    endif

    if ANFS00->NFSCAN $ "CD"  
      skip
      loop
    endif

    if inkey() = 27
      if suspro()
        lCancelou = .t.
        msg("* * * PROCESSO SUSPENSO * * *")
        select ANFS00
        go bottom
        skip
        select ANFS01
        go bottom
        skip
        loop
      endif
    endif

    msw("Lendo xml: " +  ANFS00->NFSID)

    if !alltrim(tira_pto(NFSNATN)) $ "#5933#"  // NAO TEM XML
      if !le_xml("F:\CIRUR\ENVIADO\" + alltrim(ANFS00->NFSUSU) + "\NFE\"+ ANFS00->NFSID)
        select ANFS00
        skip
        loop
      endif

      select ANFTM1
      go top
    else
      select ANFS01
      dbsetorder(1)
      dbseek(str(ANFS00->NFSEMP, 2) + str(ANFS00->NFSNUM, 6) + ANFS00->NFSSER, .t.)
    endif

    do while !eof()

      if alltrim(tira_pto(ANFS00->NFSNATN)) $ "#5933#"  // NAO TEM XML
        if !str(NFSEMP, 2) + str(NFSNUM, 6) + NFSSER == str(ANFS00->NFSEMP, 2) + str(ANFS00->NFSNUM, 6) + ANFS00->NFSSER
          exit
        endif
      endif

      select APROD

      if !alltrim(tira_pto(ANFS00->NFSNATN)) $ "#5933#"  // NAO TEM XML
        if !dbseek(ANFTM1->NFEMAT)
          append blank
          replace NFSMAT with ANFTM1->NFEMAT
        endif

        APCA00->(dbseek(str(ANFTM1->NFEMAT, 6,0)))
      else
        if !dbseek(ANFS01->NFSMAT)
          append blank
          replace NFSMAT with ANFS01->NFSMAT
        endif

        APCA00->(dbseek(str(ANFS01->NFSMAT, 6,0)))
      endif

      lAcheipro = .f.

      for ABC = 1 to len(aUnidade)
        if alltrim(APCA00->PCAUNI) == alltrim(aUnidade[ABC])
          lAcheipro = .t.
          exit
        endif
      next

      if !lAcheipro
        aadd(aUnidade,APCA00->PCAUNI)
      endif

      if !alltrim(tira_pto(ANFS00->NFSNATN)) $ "#5933#"  // NAO TEM XML
        select ANFTM1
      else
        select ANFS01 
      endif

      skip

    enddo

    select ANFS00
    skip
  enddo

  select ANFE00
  set order to 2

  dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)

  do while !eof()

    if str(NFEEMP, 2, 0) + dtos(NFEDTR) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
      exit
    endif

    msw("NOTA FISCAL ENTRADA -=> " + dtoc(ANFE00->NFEDTR) )

    AFIS00->(dbseek(ANFE00->NFENATN))

    if !alltrim(tira_pto(NFENATN)) $ "#1202#"  // SOMENTE DEVOLUCAO
      skip
      loop
    endif

    if inkey() = 27
      if suspro()
        lCancelou = .t.
        msg("* * * PROCESSO SUSPENSO * * *")
        select ANFE00
        go bottom
        skip
        select ANFE01
        go bottom
        skip
        loop
      endif
    endif

    select ANFE01
    dbseek(str(ANFE00->NFEEMP, 2, 0) + str(ANFE00->NFENUM, 6, 0) + ANFE00->NFESER + str(ANFE00->NFEFOR, 7, 0), .t.)

    do while !eof()

      if !str(NFEEMP, 2, 0) + str(NFENUM, 6, 0) + NFESER + str(NFEFOR, 7, 0) == str(ANFE00->NFEEMP, 2, 0) + str(ANFE00->NFENUM, 6, 0) + ANFE00->NFESER + str(ANFE00->NFEFOR, 7, 0)
        exit
      endif

      select APROD
      if !dbseek(ANFE01->NFEMAT)
        append blank
        replace NFSMAT with ANFE01->NFEMAT
      endif

      APCA00->(dbseek(str(ANFE01->NFEMAT, 6,0)))

        lAcheipro = .f.

        for ABC = 1 to len(aUnidade)
          if alltrim(APCA00->PCAUNI) == alltrim(aUnidade[ABC])
            lAcheipro = .t.
            exit
          endif
        next
        if !lAcheipro
          aadd(aUnidade,APCA00->PCAUNI)
        endif

      select ANFE01
      skip

    enddo

    select ANFE00
    skip
  enddo


select 0 
use SPED

// FIM PRODUTOS ANFE00

// PG 45

QDE_0190 = 0

for ABC = 1 to len(aUnidade)
  nCAMPO = ""
  do case
    case alltrim(aUnidade[ABC]) == "CT"
      nCAMPO = "|0190|CT|CARTELA|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "PT"
      nCAMPO = "|0190|PT|POTE|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "SC"
      nCAMPO = "|0190|SC|SACHE|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "KIT"
      nCAMPO = "|0190|KIT|CONJUNTO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "GL"
      nCAMPO = "|0190|GL|GALAO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "FC"
      nCAMPO = "|0190|FC|FRASCO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "AMP"
      nCAMPO = "|0190|AMP|AMPOLA|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "PAR"
      nCAMPO = "|0190|PAR|PARES|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "LA"
      nCAMPO = "|0190|LA|LATA|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "RL"
      nCAMPO = "|0190|RL|ROLO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "TB"
      nCAMPO = "|0190|TB|TUBO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "ENV"
      nCAMPO = "|0190|ENV|ENVELOPE|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "FR"
      nCAMPO = "|0190|FR|FRASCO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "PCT"
      nCAMPO = "|0190|PCT|PACOTE|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "PR"
      nCAMPO = "|0190|PR|PAR|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "BL"
      nCAMPO = "|0190|BL|BLOCO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "BR"
      nCAMPO = "|0190|BR|BARRA|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "CX"
      nCAMPO = "|0190|CX|CAIXA|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "JG"
      nCAMPO = "|0190|JG|JOGO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "KG"
      nCAMPO = "|0190|KG|KILO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "LT"
      nCAMPO = "|0190|LT|LITRO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "MT"
      nCAMPO = "|0190|MT|METRO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "MT2"
      nCAMPO = "|0190|MT2|METRO QUADRADO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "M3"
      nCAMPO = "|0190|M3|METRO CUBICO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "PC"
      nCAMPO = "|0190|PC|PECA|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "UN"
      nCAMPO = "|0190|UN|UNIDADE|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "BLD"
      nCAMPO = "|0190|BLD|BALDE|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
  endcase

  if !nCAMPO == ""
    select PISCOF
    append blank
    replace CODIGO with "0190"
    replace CAMPO with nCAMPO
  endif

next

M_REG200 = 0

select APROD
go top
do while !eof()
  APCA00->(dbseek(str(APROD->NFSMAT, 6, 0)))

  M_REG200 ++

  nCAMPO = "|0200|" 
  nCAMPO += alltrim(str(NFSMAT,6)) + "|"
  nCAMPO += alltrim(APCA00->PCADES) + "|"
  nCAMPO += "|"                  // 04 COD BARRA
  nCAMPO += "|"                  // 05 COD ANTERIOR ITEN
  nCAMPO += alltrim(APCA00->PCAUNI) + "|"  // 06 UNIDADE MEDIDA
  nCAMPO += "00|" // APCA00->PCATP  // 07 TIPO ITEM - TODOS MERCADORIA REVENDA ALTERAR
  nCAMPO += alltrim(APCA00->PCANBM) + "|" // 08 COD NCM
  nCAMPO += "|"                  // 09 
  nCAMPO += "|"                  //+ alltrim(APCA00->PCAGEN)                 // 10 COD GENERO
  nCAMPO += "|"                  // 11 COD SERVICO
  nCAMPO += alltrim(str(APCA00->PCAIC0,6)) + "|"                  // 12 ALIQUOTA ICMS

  select PISCOF
  append blank
  replace CODIGO with "0200"
  replace CAMPO with nCAMPO

  select APROD 
  QDE_LIN ++
  skip
enddo  


// 205 ALTERACAO DO ITEM
// 206 CODIGO PRODUTO COMBUSTIVEL
// 208 CODIGO GRUPO BEBIDAS FRIAS

// 0400 NATUREZA DE OPERACAO
// 0450 INFORMACAO COMPLEMENTAR
// 0500 PLANO DE CONTAS CONTABEIS
// 0600 CENTRO DE CUSTO

  select PISCOF
  append blank
  replace CODIGO with "0500"
  replace CAMPO with "|0500|01012014|01|S|11500|1.1.5.01.0000|ESTOQUE|||"
  replace CONTA with "1.1.5.01.0000"

  append blank
  replace CODIGO with "0500"
  replace CAMPO with "|0500|01012014|04|S|41100|4.1.1.01.0004|DEVOLUCAO DE MERCADORIA|||"
  replace CONTA with "4.1.1.01.0004"

  append blank
  replace CODIGO with "0500"
  replace CAMPO with "|0500|01012014|04|S|31200|3.1.2.01.0008|DEVOLUCAO DEVENDAS|||"
  replace CONTA with "3.1.2.01.0008"

  append blank
  replace CODIGO with "0500"
  replace CAMPO with "|0500|01012014|01|S|12300|1.2.3.02.0000|ATIVO BENS MOVEIS|||"
  replace CONTA with "1.2.3.02.0000"

  append blank
  replace CODIGO with "0500"
  replace CAMPO with "|0500|01012014|04|S|30000|3.0.0.00.0000|RECEITAS|||"
  replace CONTA with "3.0.0.00.0000"

  append blank
  replace CODIGO with "0500"
  replace CAMPO with "|0500|01012014|04|S|41100|4.1.1.01.0000|COMPRAS DE MERCADORIA|||"
  replace CONTA with "4.1.1.01.0000"

  append blank
  replace CODIGO with "0500"
  replace CAMPO with "|0500|01012014|04|S|45100|4.5.1.01.0000|DESPESAS ADMINISTRATIVAS|||"
  replace CONTA with "4.5.1.01.0000"

  append blank
  replace CODIGO with "0500"
  replace CAMPO with "|0500|01012014|04|S|45100|4.5.1.02.0000|DESPESAS COM PESSOAL ADMINISTRATIVOS|||"
  replace CONTA with "4.5.1.02.0000"

QDE_LIN += 6

// 0990 ENCERRAMENTO DO BLOCO 0

nCAMPO = "|0990|" + alltrim(str(QDE_LIN+1,10)) + "|"  // QUANTIDADE DE LINHAS BLOCO 0

  select PISCOF
  append blank
  replace CODIGO with "0990"
  replace CAMPO with nCAMPO

QDE_LIN ++
*********************************************

// REGISTRO A001 ABERTURA BLOCO A

nCAMPO = "|A001|0|"  // BLOCO SEM DADOS INFORMADOS

  select PISCOF
  append blank
  replace CODIGO with "A001"
  replace CAMPO with nCAMPO

nCAMPO = "|A010|02715655000171|" // APURACAO COM BASE NO REGISTRO INDIVUDUAL

  select PISCOF
  append blank
  replace CODIGO with "A010"
  replace CAMPO with nCAMPO

QDE_LIN_C = 1

QDE_LIN ++

QDE_LIN_C ++
QDE_LIN ++

M_200 = {}
aadd(M_200,{0,0,0,0,0,0,0,0,0,0,0,0})
M_210 = { }
aadd(M_210,{0,0,0,0,0,0,0,0,0,0,0,0})
M_400 = { }
M_410 = { }

  // REGISTRO C100 NOTA FISCAL

M_TOTPIS  = 0
M_TOTCOF  = 0

S_TOTVCOF = 0
S_TOTVPIS = 0

E_TOTVCOF = 0
E_TOTVPIS = 0

S_BASE01 = 0
L_BASE01 = 0
E_BASE01 = 0
E_BASE02 = 0
E_BASE12 = 0
S_BASE06 = 0  // SAIDA BASE
S_BASE05 = 0  // SAIDA BASE
E_BASE06 = 0  // ENTRADA BASE
E_BASE05 = 0  // ENTRADA BASE



// SERVICOS

M_REGA100 = 0
M_REGA170 = 0


  select ANFS00
  set order to 2

  dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)

  do while !eof()

    if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
      exit
    endif

    AFIS00->(dbseek(ANFS00->NFSNATN))

    if !alltrim(tira_pto(NFSNATN)) $ "#5933#"
      skip
      loop
    endif

    if inkey() = 27
      if suspro()
        lCancelou = .t.
        msg("* * * PROCESSO SUSPENSO * * *")
        select ANFS00
        go bottom
        skip
        select ANFS01
        go bottom
        skip
        loop
      endif
    endif

  // REGISTRO C100 NOTA FISCAL
  M_REGA100 ++
  QDE_LIN ++

  nCAMPO = "|A100|"
  nCAMPO += "1|"     // 02 - 1=SAIDA
  nCAMPO += "0|"     // 03 - EMISSAO PROPRIA

  if NFSCAN $ "CD"
    nCAMPO += "|" //
  else
    nCAMPO += alltrim(str(ANFS00->NFSCLI,7)) + "|" // 04 COD CLIENTE
  endif

  if NFSCAN $ "C"
    nCAMPO += "02|"             // 06 00=REGULAR 02=CANCELADO
  else
    nCAMPO += "00|"             // 06 00=REGULAR 02=CANCELADO
  endif

  nCAMPO += "E|"                    // 07 serie obrigatorio nao              
  nCAMPO += "|"                    // 07 serie obrigatorio nao              
  nCAMPO += alltrim(str(NFSNUM, 6)) + "|"   // 08 NUMERO DOCUMENTO
  nCAMPO += alltrim(left(NFSID,44)) + "|"            // 09 CHAVE NFE

  if !NFSCAN $ "CD"
    nCAMPO += fordata(NFSDTE) + "|"     // 10 EMISSAO
    nCAMPO += fordata(NFSDTE) + "|"     // 11 SAIDA OU RECEPCAO

      if NFSVLN > 0
        nCAMPO += forvalor(NFSVLN) + "|" // 12 VALOR NOTA SEM DESCONTO
      else
        nCAMPO += forvalor(NFSVLM) + "|" // 12 VALOR NOTA SEM DESCONTO
      endif

    if NFSCPG = 1
      nCAMPO += "0|"                 // 13 0=A VISTA
    else
      if NFSCPG > 2 .and. NFSCPG < 10 
        nCAMPO += "2|"               // 13 9=SEM PAGAMENTO
      else
        nCAMPO += "1|"               // 13 1=A PRAZO
      endif  
    endif     

    nCAMPO += forvalor(NFSVLD) + "|" // 14 VALOR DESCONTO

    M_TOTPIS = 0
    M_TOTCOF = 0

    totpis_ser()

    select ANFS00

    nCAMPO += forvalor(NFSVLN) + "|" // 15 BASE PIS
    nCAMPO += forvalor(M_TOTPIS)  + "|"     // 26 VALOR PIS
    nCAMPO += forvalor(NFSVLN) + "|" // 15 BASE PIS
    nCAMPO += forvalor(M_TOTCOF)  + "|"  // 27 VALOR COFINS
    nCAMPO += "0|"   // 28 PIS RETIDO
    nCAMPO += "0|"   // 29 COFINS RETIDO
    nCAMPO += "0|"   // 29 ISS
  else
    nCAMPO += "||||||||||||"
  endif

  select PISCOF
  append blank
  replace CODIGO with "A100"
  replace CAMPO with nCAMPO

  QDE_LIN_C ++

  if !ANFS00->NFSCAN $ "CD"  
    regA170_s()
  endif

  select ANFS00

  skip

enddo


nCAMPO = "|A990|2|"  // FECHAMENTO BLOCO A - QUANTIDADE DE LINHAS

  select PISCOF
  append blank
  replace CODIGO with "A001"
  replace CAMPO with nCAMPO

QDE_LIN ++

*********************************************



// REGISTRO C001 ABERTURA BLOCO C
nCAMPO = "|C001|0|"  // BLOCO COM DADOS INFORMADOS

  select PISCOF
  append blank
  replace CODIGO with "C001"
  replace CAMPO with nCAMPO

QDE_LIN ++

// REGISTRO C010 IDENTIFICACAO DO ESTABELECIMENTO

nCAMPO = "|C010|02715655000171|2|" // APURACAO COM BASE NO REGISTRO INDIVUDUAL

  select PISCOF
  append blank
  replace CODIGO with "C010"
  replace CAMPO with nCAMPO


M_REGC100 = 0
M_REGC170 = 0

  select ANFS00
  set order to 2

  dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)

  do while !eof()

    if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
      exit
    endif

    AFIS00->(dbseek(ANFS00->NFSNATN))

    if !alltrim(tira_pto(NFSNATN)) $ "#5102#6102#5405#5411#6108#6202#6411#"
      skip
      loop
    endif

    if inkey() = 27
      if suspro()
        lCancelou = .t.
        msg("* * * PROCESSO SUSPENSO * * *")
        select ANFS00
        go bottom
        skip
        select ANFS01
        go bottom
        skip
        loop
      endif
    endif

  // REGISTRO C100 NOTA FISCAL
  M_REGC100 ++
  QDE_LIN ++

  nCAMPO = "|C100|"
  nCAMPO += "1|"     // 02 - 0=ENTRADA 1=SAIDA
  nCAMPO += "0|"     // 03 - EMISSAO PROPRIA

  if NFSCAN $ "CD"
    nCAMPO += "|" //
  else
    nCAMPO += alltrim(str(ANFS00->NFSCLI,7)) + "|" // 04 COD CLIENTE
  endif

  nCAMPO += "55|"               // 05 MODELO NOTA FISCAL

  if NFSCAN $ "C"
    nCAMPO += "02|"             // 06 00=REGULAR 02=CANCELADO
  else
    if NFSCAN $ "D"
      nCAMPO += "04|"             // 06 00=REGULAR 02=CANCELADO
    else
      if NFSCOMPLE == "S"
        nCAMPO += "06|"
      else
        nCAMPO += "00|"
      endif
    endif
  endif

  nCAMPO += "001|"                    // 07 serie obrigatorio nao              
  nCAMPO += alltrim(str(NFSNUM, 6)) + "|"   // 08 NUMERO DOCUMENTO
  nCAMPO += left(NFSID,44) + "|"            // 09 CHAVE NFE

  if !NFSCAN $ "CD"
    nCAMPO += fordata(NFSDTE) + "|"     // 10 EMISSAO
    nCAMPO += fordata(NFSDTE) + "|"     // 11 SAIDA OU RECEPCAO

    if NFSCOMPLE == "S"

      if NFSVLN > 0
        nCAMPO += forvalor(NFSVLN) + "|" // 12 VALOR NOTA SEM DESCONTO
      else
        nCAMPO += forvalor(NFSVLM) + "|" // 12 VALOR NOTA SEM DESCONTO
      endif

    else
      if NFSVLN > 0
        nCAMPO += forvalor(NFSVLN) + "|" // 12 VALOR NOTA SEM DESCONTO
      else
        nCAMPO += forvalor(NFSVLM) + "|" // 12 VALOR NOTA SEM DESCONTO
      endif
    endif

    if NFSCPG = 1
      nCAMPO += "0|"                 // 13 0=A VISTA
    else
      if NFSCPG > 2 .and. NFSCPG < 10 
        nCAMPO += "2|"               // 13 9=SEM PAGAMENTO
      else
        nCAMPO += "1|"               // 13 1=A PRAZO
      endif  
    endif     

    nCAMPO += forvalor(NFSVLD) + "|" // 14 VALOR DESCONTO
    nCAMPO += "0|"                    // 15 VALOR ABATIMENTO

    if NFSCOMPLE == "S"
      nCAMPO += forvalor(0) + "|" // 16 VALOR MERCADORIA SERVICO
    else
      nCAMPO += forvalor(NFSVLM) + "|" // 16 VALOR MERCADORIA SERVICO
    endif

    if NFSFRE = 0
      nCAMPO += "9|"                 // 17 SEM COBRANCA DE FRETE
      nCAMPO += "0|"                 // 18 
    else
      nCAMPO += alltrim(NFSFRC) + "|"            // 17 FRETE POR CONTA 
      nCAMPO += forvalor(NFSFRE) + "|"  // 18 VALOR FRETE
    endif

    nCAMPO += "0|"   // 19 VALOR SEGURO
    nCAMPO += "0|"   // 20 OUTRAS DESPESAS 
    nCAMPO += forvalor(NFSBIC)  + "|"    // 21 VALOR BASE ICMS

    if NFSCOMPLE == "S"    
      nCAMPO += forvalor(pcomple())  + "|"    // 22 VALOR ICMS
      select ANFS00
    else
      nCAMPO += forvalor(NFSVIC)  + "|"    // 22 VALOR ICMS
    endif

    nCAMPO += forvalor(NFSBICS) + "|"    // 23 VALOR BASE ICMS SUBSTITUICAO
    nCAMPO += forvalor(NFSVICS) + "|"    // 24 VALOR ICMS SUBSTITUICAO
    nCAMPO += forvalor(NFSVIP)  + "|"     // 25 VALOR IPI

    M_TOTPIS = 0
    M_TOTCOF = 0

    totpis_s()


    nCAMPO += forvalor(M_TOTPIS)  + "|"     // 26 VALOR PIS
    nCAMPO += forvalor(M_TOTCOF)  + "|"  // 27 VALOR COFINS
    nCAMPO += "0|"   // 28 PIS RETIDO
    nCAMPO += "0|"   // 29 COFINS RETIDO
  else
    nCAMPO += "||||||||||||||||||||"
  endif

  select PISCOF
  append blank
  replace CODIGO with "C100"
  replace CAMPO with nCAMPO

  QDE_LIN_C ++

  if !ANFS00->NFSCAN $ "CD"  
    reg170_s()
  endif

  select ANFS00

  skip

enddo






// NOTA FISCAL ENTRADA

  select ANFE00
  set order to 2

  dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)

  do while !eof()

    if str(NFEEMP, 2, 0) + dtos(NFEDTR) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
      exit
    endif

    if !alltrim(tira_pto(NFENATN)) $ "#1202#"  // SOMENTE DEVOLUCAO
      skip
      loop
    endif

    if inkey() = 27
      if suspro()
        lCancelou = .t.
        msg("* * * PROCESSO SUSPENSO * * *")
        select ANFS00
        go bottom
        skip
        select ANFS01
        go bottom
        skip
        loop
      endif
    endif

  // REGISTRO C100 NOTA FISCAL
  M_REGC100 ++
  QDE_LIN ++

  nCAMPO = "|C100|"
  nCAMPO += "0|"     // 02 - 0=ENTRADA 1=SAIDA
  nCAMPO += "1|"     // 03 - EMISSAO PROPRIA

  nCAMPO += alltrim("F"+alltrim(str(NFEFOR,7))) + "|" // 04 COD CLIENTE

  if len(alltrim(NFSID)) > 0 
    nCAMPO += "55|"               // 05 MODELO NOTA FISCAL
  else
    if ANFE00->NFEMOD > 0
      nCAMPO += strzero(ANFE00->NFEMOD,2) + "|"               // 05 MODELO NOTA FISCAL
    else
      nCAMPO += strzero(1,2) + "|"               // 05 MODELO NOTA FISCAL
    endif
  endif 

  nCAMPO += "00|"
  nCAMPO += "001|"                    // 07 serie obrigatorio nao              
  nCAMPO += alltrim(str(iif(ANFE00->NFENUM1 > 0,ANFE00->NFENUM1,ANFE00->NFENUM), 9)) + "|"   // 08 NUMERO DOCUMENTO
  nCAMPO += alltrim(left(NFSID,44)) + "|"            // 09 CHAVE NFE

    nCAMPO += fordata(NFEDTE) + "|"     // 10 EMISSAO
    nCAMPO += fordata(NFEDTR) + "|"     // 11 SAIDA OU RECEPCAO
    nCAMPO += forvalor(NFEVLN) + "|" // 12 VALOR NOTA SEM DESCONTO

    if alltrim(tira_pto(NFENATN)) $ "2916#2912#1910#2910#5910#6915#6908#6910#6913#"  // SEM PAGAMENTO
      nCAMPO += "2|"                 // 13 0=A VISTA
    else
      nCAMPO += "0|"                 // 13 0=A VISTA
    endif

    nCAMPO += forvalor(NFEDSC) + "|" // 14 VALOR DESCONTO
    nCAMPO += "0|"                    // 15 VALOR ABATIMENTO

    if alltrim(ANFE00->NFESER) == "1" // NOTA DE SAIDA GRAVADA NA ENTRADA
      nCAMPO += forvalor(NFEVLN) + "|" // 16 VALOR MERCADORIA SERVICO
    else
      nCAMPO += forvalor(NFEVLM) + "|" // 16 VALOR MERCADORIA SERVICO

//      ?? forvalor(NFEVLM-NFESUB-NFEVIP-NFEFRE) + "|"
    endif

    if NFEFRE = 0
      nCAMPO += "9|"                 // 17 SEM COBRANCA DE FRETE
      nCAMPO += "0|"                 // 18 
    else
      nCAMPO += "1|"            // 17 FRETE POR CONTA 
      nCAMPO += forvalor(NFEFRE) + "|"  // 18 VALOR FRETE
    endif

    nCAMPO += "0|"   // 19 VALOR SEGURO
    nCAMPO += forvalor(NFEDST) + "|"   // 20 OUTRAS DESPESAS 
    nCAMPO += forvalor(NFEBIC)  + "|"    // 21 VALOR BASE ICMS
    nCAMPO += forvalor(NFEVIC)  + "|"    // 22 VALOR ICMS
    nCAMPO += forvalor(0) + "|"    // 23 VALOR BASE ICMS SUBSTITUICAO
    nCAMPO += forvalor(0) + "|"    // 24 VALOR ICMS SUBSTITUICAO
    nCAMPO += forvalor(0)  + "|"     // 25 VALOR IPI

    M_TOTPIS = 0
    M_TOTCOF = 0

    AFOR00->(dbseek(str(ANFE00->NFEFOR, 7, 0)))

    lcpf = .f.

*    if len(alltrim(AFOR00->FORCGC)) = 11  // cpf nao tributa
*      lcpf = .t.
*    endif

*    if !lcpf
      totpise()
*    endif

    nCAMPO += forvalor(M_TOTPIS)  + "|"     // 26 VALOR PIS
    nCAMPO += forvalor(M_TOTCOF)  + "|"  // 27 VALOR COFINS
    nCAMPO += "0|"   // 28 PIS RETIDO
    nCAMPO += "0|"   // 29 COFINS RETIDO

  select PISCOF
  append blank
  replace CODIGO with "C100"
  replace CAMPO with nCAMPO

  QDE_LIN_C ++

  reg170epi()

  select ANFE00

  skip

enddo

QDE_C400 = 0
QDE_C405 = 0
QDE_C490 = 0
QDE_C481 = 0
QDE_C485 = 0

// REGISTROS CUPOM FISCAL

  QDE_C500 = 0
  QDE_C510 = 0
  QDE_C590 = 0

  select ANFE00
  set order to 2

  dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)

  do while !eof()

    exit // NAO ENTRA

    if str(NFEEMP, 2, 0) + dtos(NFEDTR) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
      exit
    endif

    if !alltrim(tira_pto(NFENATN)) $ "1253" // ENERGIA ELETRICA
      skip
      loop
    endif

    if inkey() = 27
      if suspro()
        lCancelou = .t.
        msg("* * * PROCESSO SUSPENSO * * *")
        select ANFE00
        go bottom
        skip
        select ANFE01
        go bottom
        skip
        loop
      endif
    endif

    QDE_C500 ++
    BLOCO_C ++
    QDE_LIN_C ++
    QDE_LIN ++

    nCampo = "|C500|"  // 01
    nCampo += "F" + alltrim(str(NFEFOR,7)) + "|" // 04 COD CLIENTE
    nCampo += "06|"    // 03 MODELO NOTA FISCAL
    nCampo += "00|"   // 04 SITUACAO
    nCampo += "|"      // 05 SERIE
    nCampo += "|"                             // 06 -sub-serie
    nCampo += alltrim(str(NFENUM, 7)) + "|"   // 07 NUMERO DOCUMENTO
    nCampo += fordata(NFEDTE) + "|"           // 08 EMISSAO
    nCampo += fordata(NFEDTR) + "|"           // 09 SAIDA OU RECEPCAO
    nCampo += forvalor(NFEVLN) + "|"  // 10 VALOR TOTAL
    nCampo += forvalor(NFEVIC)  + "|" // 11 VALOR ICMS
    nCampo += "|"                     // 12 CODIGO INFORMACAO
    nCampo += forvalor((NFEVLN/100)*M_PIS) + "|" // 24 VALOR PIS
    nCampo += forvalor((NFEVLN/100)*M_COF) + "|" // 25 VALOR COFINS
    gravapis("C500",nCampo)

    select ANFE00
    nCampo = "|C501|"  // 01
    nCampo += "50|"    // 02
    nCampo += forvalor(NFEVLN)  + "|"        // 03
    nCampo += "04|"                          // 04
    nCampo += forvalor(NFEVLN)   + "|"         // 05
    nCampo += forvalor(M_PIS)    + "|"         // 06
    nCampo += forvalor((NFEVLN/100)*M_PIS) + "|" // 07 VALOR PIS
    nCampo += "|"         // 08 CODIGO CONTA

    gravapis("C501",nCampo)
    select ANFE00
    QDE_C501 ++
    BLOCO_C ++
    QDE_LIN_C ++
    QDE_LIN ++

    nCampo = "|C505|"  // 01
    nCampo += "50|"    // 02
    nCampo += forvalor(NFEVLN)  + "|"        // 03
    nCampo += "04|"                          // 04
    nCampo += forvalor(NFEVLN)   + "|"         // 05
    nCampo += forvalor(M_COF)    + "|"         // 06
    nCampo += forvalor((NFEVLN/100)*M_COF) + "|" // 07 VALOR PIS
    nCampo += "|"         // 08 CODIGO CONTA

    E_BASE01 += NFEVLN

    gravapis("C505",nCampo)

    QDE_C505 ++
    BLOCO_C ++
    QDE_LIN_C ++
    QDE_LIN ++
    select ANFE00
    skip

  enddo

nCampo = "|C990|" + alltrim(str(QDE_LIN_C+1,10)) + "|"  // QUANTIDADE DE LINHAS BLOCO 0
gravapis("C990",nCampo)

*****************************
// CONHECIMENTO DE TRANSPORTE
***************************

nCampo = "|D001|0|"
gravapis("D001",nCampo)

nCampo = "|D010|" + right(AEMP00->EMPCGC,14) + "|"               // 09 cnpj
gravapis("D010",nCampo)

BLOCO_D = 2

  QDE_D100 = 0

  select ANFE00
  set order to 2

  dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)

  do while !eof()

    exit // NAO ENTRA 

    if str(NFEEMP, 2, 0) + dtos(NFEDTR) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
      exit
    endif

    if !alltrim(tira_pto(NFENATN)) $ "2353#1353" // transporte
      skip
      loop
    endif

    if inkey() = 27
      if suspro()
        lCancelou = .t.
        msg("* * * PROCESSO SUSPENSO * * *")
        select ANFE00
        go bottom
        skip
        select ANFE01
        go bottom
        skip
        loop
      endif
    endif

    nCampo = "|D100|"  // 01
    nCampo += "0|"     // 02 - 0=AQUISICAO
    nCampo += "1|"     // 03 - 1-TERCEIROS
    nCampo += "F" + alltrim(str(NFEFOR,7)) + "|" // 04 COD CLIENTE

    if !empty(NFSID)
      nCampo += "57|"    // 05 MODELO NOTA FISCAL
    else
      nCampo += "08|"    // 05 MODELO NOTA FISCAL
    endif

    nCampo += "00|"   // 06
    nCampo += "|" 
    nCampo += "|"                             // 08 -sub-serie
    nCampo += alltrim(str(NFENUM, 7)) + "|"   // 09 NUMERO DOCUMENTO
    nCampo += alltrim(NFSID) + "|"            // 10 CHAVE NFE
    nCampo += fordata(NFEDTE) + "|"  // 11 EMISSAO
    nCampo += fordata(NFEDTR) + "|"  // 12 SAIDA OU RECEPCAO
    nCampo += "0|"                   // 13 TIPO 0=NORMAL
    nCampo += "|"                    // 14 EM BRANCO
    nCampo += forvalor(NFEVLM) + "|" // 15 VALOR NOTA SEM DESCONTO
    nCampo += forvalor(NFEDSC) + "|" // 16 VALOR DESCONTO
    nCampo += "1|"                    // 17 TIPO
    nCampo += forvalor(NFEVLM)  + "|" // 18 VALOR MERCADORIA SERVICO
    nCampo += forvalor(NFEBIC)  + "|" // 19 VALOR BASE ICMS
    nCampo += forvalor(NFEVIC)  + "|" // 20 VALOR ICMS
    nCampo += forvalor(0)       + "|" // 21 VALOR NAO TRIBUTADO
    nCampo += "|" // 22 
    nCampo += "|" // 23 

    gravapis("D100",nCampo)
    select ANFE00
    QDE_D100 ++
    BLOCO_D ++
    QDE_LIN ++

    nCampo = "|D101|"  // 01
    nCampo += "2|"     // 02 - TRIBUTADO
    nCampo += forvalor(NFEVLN) + "|" // 03 VALOR NOTA SEM DESCONTO
    nCampo += "50|"            // 04 - TRIBUTADO
    nCampo += "01|"            // 05 - TRIBUTADO
    nCampo += forvalor(NFEVLN) + "|" // 06 VALOR NOTA SEM DESCONTO
    nCampo += forvalor(M_PIS) + "|" //  07 VALOR NOTA SEM DESCONTO
    nCampo += forvalor((NFEVLN/100)*M_PIS) + "|" // 08 VALOR NOTA SEM DESCONTO
    nCampo += "|" 
    
    gravapis("D101",nCampo)
    select ANFE00
    QDE_D101 ++
    BLOCO_D ++
    QDE_LIN ++

    nCampo = "|D105|"  // 01
    nCampo += "2|"     // 02 - TRIBUTADO
    nCampo += forvalor(NFEVLN) + "|" // 03 VALOR NOTA SEM DESCONTO
    nCampo += "50|"            // 04 - TRIBUTADO
    nCampo += "01|"            // 05 - TRIBUTADO
    nCampo += forvalor(NFEVLN) + "|" // 06 VALOR NOTA SEM DESCONTO
    nCampo += forvalor(M_COF) + "|" //  07 VALOR NOTA SEM DESCONTO
    nCampo += forvalor((NFEVLN/100)*M_COF) + "|" // 08 VALOR NOTA SEM DESCONTO
    nCampo += "|" 
    
    E_BASE01 += NFEVLN

    gravapis("D105",nCampo)

    QDE_D105 ++
    BLOCO_D ++
    QDE_LIN ++

    select ANFE00
    skip
  enddo

BLOCO_D ++
nCampo = "|D990|"  + alltrim(str(BLOCO_D,10)) + "|"
gravapis("D990",nCampo)

append blank
replace CODIGO with "F001"
replace CAMPO with "|F001|0|"

nCampo = "|F010|02715655000171|"
gravapis("F010",nCampo)

*nCampo ="|F150|18|1674926,31||1674926,31|139577,19|50|0,65|907,25|50|3|4187,31|||"
*gravapis("F150",nCampo)

append blank
replace CODIGO with "F990"
replace CAMPO with "|F990|4|"

append blank
replace CODIGO with "M001"
replace CAMPO with "|M001|0|"

*nCAMPO = "|M100|"                   // 01 REG
*nCAMPO += "101|"                    // 02 COD_CRED
*nCAMPO += "0|"                      // 03 IND_CRED_ORI
*nCAMPO += forvalor(E_BASE01) + "|"  // 04 VL_BC_PIS
*nCAMPO += "1,65|"                   // 05 ALIQ_PIS
*nCAMPO += "0|"                      // 06 QUANT_BC_PIS
*nCAMPO += "|"                       // 07 ALIQ_PIS_QUANT
*nCAMPO += forvalor(E_TOTVPIS) + "|" // 08 VL_CRED
*nCAMPO += "0|"                      // 09 VL_AJUS_ACRES
*nCAMPO += "0|"                      // 10 VL_AJUS_REDUC
*nCAMPO += "0|"                      // 11 VL_CRED_DIF
*nCAMPO += forvalor(E_TOTVPIS) + "|" // 12 VL_CRED_DISP

M100_14 = 0

*if E_TOTVPIS > S_TOTVPIS
*  nCAMPO += "1|"                                // 13 IND_DESC_CRED
*  nCAMPO += forvalor(S_TOTVPIS) + "|"           // 14 VL_CRED_DESC
*  nCAMPO += forvalor(E_TOTVPIS-S_TOTVPIS) + "|" // 15 SLD_CRED
*  M100_14 = S_TOTVPIS
*else
*  nCAMPO += "0|"                       // 13 IND_DESC_CRED
*  nCAMPO += forvalor(E_TOTVPIS) + "|"  // 14 VL_CRED_DESC
*  nCAMPO += "0|"                       // 15 SLD_CRED
*  M100_14 = E_TOTVPIS
*endif

*append blank
*replace CODIGO with "M100"
*replace CAMPO with nCAMPO

*nCAMPO = "|M105|"                   // 01 REG
*nCAMPO += "01|"                     // 02 NAT_BC_CRED
*nCAMPO += "50|"                     // 03 CST_PIS
*nCAMPO += forvalor(E_BASE01-E_BASE12-E_BASE02) + "|" // 04 VL_BC_PIS_TOT
*nCAMPO += "|"                      // 05 VL_BC_PIS_CUM
*nCAMPO += forvalor(E_BASE01-E_BASE12-E_BASE02) + "|" // 06 VL_BC_PIS_NC
*nCAMPO += forvalor(E_BASE01-E_BASE12-E_BASE02) + "|" // 07 VL_BC_PIS
*nCAMPO += "|"                      // 08 QUANT_BC_PIS_TOT
*nCAMPO += "0|"                      // 09 QUANT_BC_PIS
*nCAMPO += "|"                       // 10 DESC_CRED

*append blank
*replace CODIGO with "M105"
*replace CAMPO with nCAMPO

*if E_BASE02 > 0  // insumos
*  nCAMPO = "|M105|"                   // 01 REG
*  nCAMPO += "02|"                     // 02 NAT_BC_CRED
*  nCAMPO += "50|"                     // 03 CST_PIS
*  nCAMPO += forvalor(E_BASE02) + "|" // 04 VL_BC_PIS_TOT
*  nCAMPO += "|"                      // 05 VL_BC_PIS_CUM
*  nCAMPO += forvalor(E_BASE02) + "|" // 06 VL_BC_PIS_NC
*  nCAMPO += forvalor(E_BASE02) + "|" // 07 VL_BC_PIS
*  nCAMPO += "|"                      // 08 QUANT_BC_PIS_TOT
*  nCAMPO += "0|"                      // 09 QUANT_BC_PIS
*  nCAMPO += "|"                       // 10 DESC_CRED

*  append blank
*  replace CODIGO with "M105"
*  replace CAMPO with nCAMPO*

*endif

*if E_BASE12 > 0  // devolucoes
*  nCAMPO = "|M105|"                   // 01 REG
*  nCAMPO += "12|"                     // 02 NAT_BC_CRED
*  nCAMPO += "50|"                     // 03 CST_PIS
*  nCAMPO += forvalor(E_BASE12) + "|" // 04 VL_BC_PIS_TOT
*  nCAMPO += "|"                      // 05 VL_BC_PIS_CUM
*  nCAMPO += forvalor(E_BASE12) + "|" // 06 VL_BC_PIS_NC
*  nCAMPO += forvalor(E_BASE12) + "|" // 07 VL_BC_PIS
*  nCAMPO += "|"                      // 08 QUANT_BC_PIS_TOT
*  nCAMPO += "0|"                      // 09 QUANT_BC_PIS
*  nCAMPO += "|"                       // 10 DESC_CRED*

*  append blank
*  replace CODIGO with "M105"
*  replace CAMPO with nCAMPO*

*endif

// CREDITO ESTOQUE

*nCAMPO = "|M100|"                   // 01 REG
*nCAMPO += "104|"                    // 02 COD_CRED
*nCAMPO += "0|"                      // 03 IND_CRED_ORI
*nCAMPO += forvalor(139577.19) + "|"  // 04 VL_BC_PIS
*nCAMPO += "0,65|"                   // 05 ALIQ_PIS
*nCAMPO += "0|"                      // 06 QUANT_BC_PIS
*nCAMPO += "|"                       // 07 ALIQ_PIS_QUANT
*nCAMPO += forvalor(907.25) + "|" // 08 VL_CRED
*nCAMPO += "0|"                      // 09 VL_AJUS_ACRES
*nCAMPO += "0|"                      // 10 VL_AJUS_REDUC
*nCAMPO += "0|"                      // 11 VL_CRED_DIF
*nCAMPO += forvalor(907.25) + "|" // 12 VL_CRED_DISP
*nCAMPO += "0|"                       // 13 IND_DESC_CRED
*nCAMPO += forvalor(907.25) + "|"  // 14 VL_CRED_DESC
*nCAMPO += "0|"                       // 15 SLD_CRED

*append blank
*replace CODIGO with "M100"
*replace CAMPO with nCAMPO

*nCAMPO = "|M105|"                   // 01 REG
*nCAMPO += "18|"                     // 02 NAT_BC_CRED
*nCAMPO += "50|"                     // 03 CST_PIS
*nCAMPO += forvalor(139577.19) + "|" // 04 VL_BC_PIS_TOT
*nCAMPO += "|"                      // 05 VL_BC_PIS_CUM
*nCAMPO += forvalor(139577.19) + "|" // 06 VL_BC_PIS_NC
*nCAMPO += forvalor(139577.19) + "|" // 07 VL_BC_PIS
*nCAMPO += "|"                      // 08 QUANT_BC_PIS_TOT
*nCAMPO += "0|"                      // 09 QUANT_BC_PIS
*nCAMPO += "|"                       // 10 DESC_CRED

*append blank
*replace CODIGO with "M105"
*replace CAMPO with nCAMPO

nCAMPO = "|M200|"                              // 01 REG
nCAMPO += forvalor(S_TOTVPIS) + "|"            // 02 VL_TOT_CONT_NC_PER
nCAMPO += forvalor(M100_14) + "|"              // 03 VL_TOT_CRED_DESC
nCAMPO += "0|"                                 // 04 VL_TOT_CRED_DESC_ANT

if S_TOTVPIS > E_TOTVPIS
  nCAMPO += forvalor(S_TOTVPIS-E_TOTVPIS) + "|" // 05 VL_TOT_CONT_NC_DEV
else
  nCAMPO += "0|"                                // 05 VL_TOT_CONT_NC_DEV
endif

nCAMPO += "0|"                                 // 06 VL_RET_NC
nCAMPO += "0|"                                 // 07 VL_OUT_DED_NC

if S_TOTVPIS > E_TOTVPIS
  nCAMPO += forvalor(S_TOTVPIS-E_TOTVPIS) + "|" // 08 VL_CONT_NC_REC
else
  nCAMPO += "0|"                                // 08 VL_CONT_NC_REC
endif

nCAMPO += "0|"                                 // 09 VL_TOT_CONT_CUM_PER
nCAMPO += "0|"                                 // 10 VL_RET_CUM
nCAMPO += "0|"                                 // 11 VL_OUT_DED_CUM
nCAMPO += "0|"                                 // 12 VL_CONT_CUM_REC

if S_TOTVPIS > E_TOTVPIS
  nCAMPO += forvalor(S_TOTVPIS-E_TOTVPIS) + "|" // 13 VL_TOT_CONT_REC
else
  nCAMPO += "0|"                                // 13 VL_TOT_CONT_REC
endif

  append blank
  replace CODIGO with "M200"
  replace CAMPO with nCAMPO

nCAMPO = "|M205|"                   // 01 REG
nCAMPO += "12|"                     // 02 COD_CONT
nCAMPO += "810902|"                     // 02 COD_CONT
if S_TOTVPIS > E_TOTVPIS
  nCAMPO += forvalor(S_TOTVPIS-E_TOTVPIS) + "|" // 13 VL_TOT_CONT_REC
else
  nCAMPO += "0|"                                // 13 VL_TOT_CONT_REC
endif

  append blank
  replace CODIGO with "M205"
  replace CAMPO with nCAMPO

nCAMPO = "|M210|"                   // 01 REG
nCAMPO += "01|"                     // 02 COD_CONT
nCAMPO += forvalor(S_BASE01) + "|"  // 03 VL_REC_BRT
nCAMPO += forvalor(L_BASE01) + "|"  // 04 VL_BC_CONT
nCAMPO += "1,65|"                   // 05 ALIQ_PIS
nCAMPO += "0|"                      // 06 QUANT_BC_PIS
nCAMPO += "|"                       // 07 ALIQ_PIS_QUANT
nCAMPO += forvalor(S_TOTVPIS) + "|" // 08 VL_CONT_APUR
nCAMPO += "0|"                      // 09 VL_AJUS_ACRES
nCAMPO += "0|"                      // 10 VL_AJUS_REDUC
nCAMPO += "0|"                      // 11 VL_CONT_DIFER
nCAMPO += "0|"                      // 12 VL_CONT_DIFER
nCAMPO += forvalor(S_TOTVPIS) + "|" // 13 VL_CONT_PER

  append blank
  replace CODIGO with "M210"
  replace CAMPO with nCAMPO


select SPED1

sum VALOR to M_CST04 for CST = "04"
sum VALOR to M_CST06 for CST = "06"

M_400 = 0
M_410 = 0

if M_CST04 > 0
  nCampo = "|M400|"                   // 01 REG
  nCampo += "04|"                     // 02 CST_PIS
  nCampo += forvalor(M_CST04) + "|"   // 03 VL_TOT_REC
  nCampo += "|"                       // 04 COD_CTA
  nCampo += "|"                       // 05 DESC_COMPL
  gravapis("M400",nCampo)

  select SPED1
  M_400 ++
  go top
  do while !eof()
    if !CST == "04"
      skip
      loop
    endif

    M_410 ++
    nCampo = "|M410|"                   // 01 REG
    nCampo += strzero(val(CODIGO),3) + "|"                     // 02 CST_PIS
    nCampo += forvalor(VALOR) + "|"  // 03 VL_TOT_REC
    nCampo += "|"                       // 04 COD_CTA
    nCampo += "|"                       // 05 DESC_COMPL

    gravapis("M410",nCampo)
    select SPED1
    skip
  enddo
endif

if M_CST06 > 0
  nCampo = "|M400|"                   // 01 REG
  nCampo += "06|"                     // 02 CST_PIS
  nCampo += forvalor(M_CST06) + "|"  // 03 VL_TOT_REC
  nCampo += "|"                       // 04 COD_CTA
  nCampo += "|"                       // 05 DESC_COMPL
  gravapis("M400",nCampo)
  M_400 ++
  select SPED1
  go top
  do while !eof()
    if !CST == "06"
      skip
      loop
    endif

    M_410 ++
    nCampo = "|M410|"                   // 01 REG
    nCampo += strzero(val(CODIGO),3) + "|"                     // 02 CST_PIS
    nCampo += forvalor(VALOR) + "|"  // 03 VL_TOT_REC
    nCampo += "|"                       // 04 COD_CTA
    nCampo += "|"                       // 05 DESC_COMPL
    gravapis("M410",nCampo)
    select SPED1
    skip
  enddo
endif

*nCAMPO = "|M500|"                   // 01 REG
*nCAMPO += "101|"                    // 02 COD_CRED
*nCAMPO += "0|"                      // 03 IND_CRED_ORI
*nCAMPO += forvalor(E_BASE01) + "|"  // 04 VL_BC_PIS
*nCAMPO += "7,6|"                    // 05 ALIQ_PIS
*nCAMPO += "0|"                      // 06 QUANT_BC_PIS
*nCAMPO += "|"                       // 07 ALIQ_PIS_QUANT
*nCAMPO += forvalor(E_TOTVCOF) + "|" // 08 VL_CRED
*nCAMPO += "0|"                      // 09 VL_AJUS_ACRES
*nCAMPO += "0|"                      // 10 VL_AJUS_REDUC
*nCAMPO += "0|"                      // 11 VL_CRED_DIF
*nCAMPO += forvalor(E_TOTVCOF) + "|" // 12 VL_CRED_DISP

M500_14 = 0

*if E_TOTVCOF > S_TOTVCOF
*  nCAMPO += "1|"                                // 13 IND_DESC_CRED
*  nCAMPO += forvalor(S_TOTVCOF) + "|"           // 14 VL_CRED_DESC
*  nCAMPO += forvalor(E_TOTVCOF-S_TOTVCOF) + "|" // 15 SLD_CRED
*  M500_14 = S_TOTVCOF
*else
*  nCAMPO += "0|"                      // 13 IND_DESC_CRED
*  nCAMPO += forvalor(E_TOTVCOF) + "|" // 14 VL_CRED_DESC
*  nCAMPO += "0|"                      // 15 SLD_CRED
*  M500_14 = E_TOTVCOF
*endif

*gravapis("M500",nCampo)
  select SPED1

*nCAMPO = "|M505|"                   // 01 REG
*nCAMPO += "01|"                     // 02 NAT_BC_CRED
*nCAMPO += "50|"                     // 03 CST_PIS
*nCAMPO += forvalor(E_BASE01-E_BASE12-E_BASE02) + "|" // 04 VL_BC_PIS_TOT
*nCAMPO += "|"                      // 05 VL_BC_PIS_CUM
*nCAMPO += forvalor(E_BASE01-E_BASE12-E_BASE02) + "|" // 06 VL_BC_PIS_NC
*nCAMPO += forvalor(E_BASE01-E_BASE12-E_BASE02) + "|" // 07 VL_BC_PIS
*nCAMPO += "|"                      // 08 QUANT_BC_PIS_TOT
*nCAMPO += "0|"                      // 09 QUANT_BC_PIS
*nCAMPO += "|"                       // 10 DESC_CRED

*gravapis("M505",nCampo)
  select SPED1
*if E_BASE02 > 0  // devolucoes
*  nCAMPO = "|M505|"                   // 01 REG
*  nCAMPO += "02|"                     // 02 NAT_BC_CRED
*  nCAMPO += "50|"                     // 03 CST_PIS
*  nCAMPO += forvalor(E_BASE02) + "|" // 04 VL_BC_PIS_TOT
*  nCAMPO += "|"                      // 05 VL_BC_PIS_CUM
*  nCAMPO += forvalor(E_BASE02) + "|" // 06 VL_BC_PIS_NC
*  nCAMPO += forvalor(E_BASE02) + "|" // 07 VL_BC_PIS
*  nCAMPO += "|"                      // 08 QUANT_BC_PIS_TOT
*  nCAMPO += "0|"                      // 09 QUANT_BC_PIS
*  nCAMPO += "|"                       // 10 DESC_CRED

*  gravapis("M505",nCampo)
*  select SPED1
*endif

*if E_BASE12 > 0  // devolucoes
*  nCAMPO = "|M505|"                   // 01 REG
*  nCAMPO += "12|"                     // 02 NAT_BC_CRED
*  nCAMPO += "50|"                     // 03 CST_PIS
*  nCAMPO += forvalor(E_BASE12) + "|" // 04 VL_BC_PIS_TOT
*  nCAMPO += "|"                      // 05 VL_BC_PIS_CUM
*  nCAMPO += forvalor(E_BASE12) + "|" // 06 VL_BC_PIS_NC
*  nCAMPO += forvalor(E_BASE12) + "|" // 07 VL_BC_PIS
*  nCAMPO += "|"                      // 08 QUANT_BC_PIS_TOT
*  nCAMPO += "0|"                      // 09 QUANT_BC_PIS
*  nCAMPO += "|"                       // 10 DESC_CRED
*  gravapis("M505",nCampo)
*  select SPED1
*endif

// CREDITO ESTOQUE

*nCAMPO = "|M500|"                   // 01 REG
*nCAMPO += "104|"                    // 02 COD_CRED
*nCAMPO += "0|"                      // 03 IND_CRED_ORI
*nCAMPO += forvalor(139577.19) + "|"  // 04 VL_BC_PIS
*nCAMPO += "3|"                   // 05 ALIQ_PIS
*nCAMPO += "0|"                      // 06 QUANT_BC_PIS
*nCAMPO += "|"                       // 07 ALIQ_PIS_QUANT
*nCAMPO += forvalor(4187.32) + "|" // 08 VL_CRED
*nCAMPO += "0|"                      // 09 VL_AJUS_ACRES
*nCAMPO += "0|"                      // 10 VL_AJUS_REDUC
*nCAMPO += "0|"                      // 11 VL_CRED_DIF
*nCAMPO += forvalor(4187.32) + "|" // 12 VL_CRED_DISP
*nCAMPO += "0|"                       // 13 IND_DESC_CRED
*nCAMPO += forvalor(4187.32) + "|"  // 14 VL_CRED_DESC
*nCAMPO += "0|"                       // 15 SLD_CRED

*append blank
*replace CODIGO with "M500"
*replace CAMPO with nCAMPO

*nCAMPO = "|M505|"                   // 01 REG
*nCAMPO += "18|"                     // 02 NAT_BC_CRED
*nCAMPO += "50|"                     // 03 CST_PIS
*nCAMPO += forvalor(139577.19) + "|" // 04 VL_BC_PIS_TOT
*nCAMPO += "|"                      // 05 VL_BC_PIS_CUM
*nCAMPO += forvalor(139577.19) + "|" // 06 VL_BC_PIS_NC
*nCAMPO += forvalor(139577.19) + "|" // 07 VL_BC_PIS
*nCAMPO += "|"                      // 08 QUANT_BC_PIS_TOT
*nCAMPO += "0|"                      // 09 QUANT_BC_PIS
*nCAMPO += "|"                       // 10 DESC_CRED

*append blank
*replace CODIGO with "M505"
*replace CAMPO with nCAMPO

nCAMPO = "|M600|"                              // 01 REG
nCAMPO += forvalor(S_TOTVCOF) + "|"            // 02 VL_TOT_CONT_NC_PER
nCAMPO += forvalor(M500_14) + "|"              // 03 VL_TOT_CRED_DESC
nCAMPO += "0|"                                 // 04 VL_TOT_CRED_DESC_ANT

if S_TOTVCOF > E_TOTVCOF
  nCAMPO += forvalor(S_TOTVCOF-E_TOTVCOF) + "|"  // 05 VL_TOT_CONT_NC_DEV
else
  nCAMPO += "0|"  // 05 VL_TOT_CONT_NC_DEV
endif

nCAMPO += "0|"                                 // 06 VL_RET_NC
nCAMPO += "0|"                                 // 07 VL_OUT_DED_NC

if S_TOTVCOF > E_TOTVCOF
  nCAMPO += forvalor(S_TOTVCOF-E_TOTVCOF) + "|"  // 08 VL_CONT_NC_REC
else
  nCAMPO += "0|"  // 08 VL_CONT_NC_REC
endif

nCAMPO += "0|"                                 // 09 VL_TOT_CONT_CUM_PER
nCAMPO += "0|"                                 // 10 VL_RET_CUM
nCAMPO += "0|"                                 // 11 VL_OUT_DED_CUM
nCAMPO += "0|"                                 // 12 VL_CONT_CUM_REC

if S_TOTVCOF > E_TOTVCOF
  nCAMPO += forvalor(S_TOTVCOF-E_TOTVCOF) + "|"  // 13 VL_TOT_CONT_REC
else
  nCAMPO += "0|"  // 13 VL_TOT_CONT_REC
endif

gravapis("M500",nCampo)
  select SPED1
nCAMPO = "|M605|"                   // 01 REG
nCAMPO += "12|"                     // 02 COD_CONT
nCAMPO += "217201|"                     // 02 COD_CONT
if S_TOTVCOF > E_TOTVCOF
  nCAMPO += forvalor(S_TOTVCOF-E_TOTVCOF) + "|"  // 13 VL_TOT_CONT_REC
else
  nCAMPO += "0|"  // 13 VL_TOT_CONT_REC
endif
gravapis("M605",nCampo)
  select SPED1
nCAMPO = "|M610|"                   // 01 REG
nCAMPO += "01|"                     // 02 COD_CONT
nCAMPO += forvalor(S_BASE01) + "|"  // 03 VL_REC_BRT
nCAMPO += forvalor(L_BASE01) + "|"  // 04 VL_BC_CONT
nCAMPO += "7,6|"                    // 05 ALIQ_PIS
nCAMPO += "0|"                      // 06 QUANT_BC_PIS
nCAMPO += "|"                       // 07 ALIQ_PIS_QUANT
nCAMPO += forvalor(S_TOTVCOF) + "|" // 08 VL_CONT_APUR
nCAMPO += "0|"                      // 09 VL_AJUS_ACRES
nCAMPO += "0|"                      // 10 VL_AJUS_REDUC
nCAMPO += "0|"                      // 11 VL_CONT_DIFER
nCAMPO += "0|"                      // 12 VL_CONT_DIFER
nCAMPO += forvalor(S_TOTVCOF) + "|" // 13 VL_CONT_PER
gravapis("M610",nCampo)
  select SPED1
if M_CST04 > 0
  nCampo = "|M800|"                   // 01 REG
  nCampo += "04|"                     // 02 CST_PIS
  nCampo += forvalor(M_CST04) + "|"  // 03 VL_TOT_REC
  nCampo += "|"                       // 04 COD_CTA
  nCampo += "|"                       // 05 DESC_COMPL
  gravapis("M800",nCampo)
  select SPED1

  go top
  do while !eof()
    if !CST == "04"
      skip
      loop
    endif

    nCampo = "|M810|"                   // 01 REG
    nCampo += strzero(val(CODIGO),3) + "|"                     // 02 CST_PIS
    nCampo += forvalor(VALOR) + "|"  // 03 VL_TOT_REC
    nCampo += "|"                       // 04 COD_CTA
    nCampo += "|"                       // 05 DESC_COMPL
    gravapis("M810",nCampo)

    select SPED1
    skip
  enddo
endif

if M_CST06 > 0
  nCampo = "|M800|"                   // 01 REG
  nCampo += "06|"                     // 02 CST_PIS
  nCampo += forvalor(M_CST06) + "|"  // 03 VL_TOT_REC
  nCampo += "|"                       // 04 COD_CTA
  nCampo += "|"                       // 05 DESC_COMPL
  gravapis("M800",nCampo)
  select SPED1
  go top
  do while !eof()
    if !CST == "06"
      skip
      loop
    endif

    nCampo = "|M810|"                   // 01 REG
    nCampo += strzero(val(CODIGO),3) + "|"                     // 02 CST_PIS
    nCampo += forvalor(VALOR) + "|"  // 03 VL_TOT_REC
    nCampo += "|"                       // 04 COD_CTA
    nCampo += "|"                       // 05 DESC_COMPL
    gravapis("M810",nCampo)
    select SPED1
    skip
  enddo
endif

M990 = 14
M105 = 1
M505 = 1

if E_BASE12 > 0
  M990 += 2
  M105 ++
  M505 ++
endif

if E_BASE02 > 0
  M990 += 2
  M105 ++
  M505 ++
endif

select PISCOF
  append blank
  replace CODIGO with "M990"
  replace CAMPO with "|M990|" + str(M990,2) + "|"

  append blank
  replace CODIGO with "1001"
  replace CAMPO with "|1001|1|"

  append blank
  replace CODIGO with "M990"
  replace CAMPO with "|1990|2|"

  append blank
  replace CODIGO with "9001"
  replace CAMPO with "|9001|0|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|0000|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|0001|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|0100|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|0110|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|0140|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|0150|" + alltrim(str(M_REG150,10)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|0190|" + alltrim(str(M_REG190,10)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|0200|" + alltrim(str(M_REG200,10)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|0500|" + alltrim(str(6,10)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|0990|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|A001|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|A010|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|A100|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|A170|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|A990|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|C001|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|C010|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|C100|" + alltrim(str(M_REGC100,10)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|C170|" + alltrim(str(M_REGC170,10)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|C400|" + alltrim(str(QDE_C400,10)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|C405|" + alltrim(str(QDE_C405,10)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|C481|" + alltrim(str(QDE_C481,10)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|C485|" + alltrim(str(QDE_C485,10)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|C500|" + alltrim(str(QDE_C500,10)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|C501|" + alltrim(str(QDE_C501,10)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|C505|" + alltrim(str(QDE_C505,10)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|C990|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|D001|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|D010|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|D100|" + alltrim(str(QDE_D100,10)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|D101|" + alltrim(str(QDE_D101,10)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|D105|" + alltrim(str(QDE_D105,10)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|D990|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|F001|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|F010|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|F150|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|F990|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|M001|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|M100|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|M105|" + alltrim(str(M105,2)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|M200|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|M205|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|M210|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|M400|2|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|M410|2|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|M500|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|M505|"+ alltrim(str(M505,2)) + "|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|M600|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|M605|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|M610|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|M800|2|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|M810|2|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|M990|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|1001|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|1990|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|9001|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|9990|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|9999|1|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9900|9900|41|"

  append blank
  replace CODIGO with "9900"
  replace CAMPO with "|9990|55|"

  append blank
  replace CODIGO with "9990"
  replace CAMPO with "|9999|" + alltrim(str(QDE_LIN+61,10)) + "|"

set console off
set print on
set printer to "C:\PIS\COFINS.TXT"


lRecPos = 0

select PISCOF
locate for CODIGO = "0500" .and. recno() > lRecPos

if !eof()
  lRecPos = recno()
  nCONTA = CONTA
  locate for nCONTA = CONTA .and. CODIGO # "0500"
  if eof()
    go lRecPos
    delete
  endif
endif

do while .t.
  go lRecPos
  skip
  if CODIGO == "0500"
    lRecPos = recno()
    nCONTA = CONTA
    locate for nCONTA = CONTA .and. CODIGO # "0500"
    if eof()
      go lRecPos
      delete
    endif
  else
    exit
  endif
enddo

select PISCOF
pack

locate for CODIGO = "0990"
replace CAMPO with "|0990|" + alltrim(str(recno(),6)) + "|"

go top
do while !eof()
  ?? alltrim(CAMPO)
  ?
  skip
enddo

set printer to
set print off
set console on

set console off
set print on
set printer to "RELATO.RPT"

?
? "TOTAL SAIDA : " + transform(S_BASE01,"@R 9999,999.99")
?? "BASE PIS/COFINS: " + transform(L_BASE01,"@R 9999,999.99")
?? "VALOR PIS: " + transform((L_BASE01/100)*M_PIS,"@R 9999,999.99")
?? " VALOR COFINS: " + transform((L_BASE01/100)*M_COF,"@R 9999,999.99")

?
? "TOTAL ENTRADA : " + transform(E_BASE01,"@R 9999,999.99")
?? "BASE PIS/COFINS: " + transform(E_BASE01,"@R 9999,999.99")
?? "VALOR PIS: " + transform((E_BASE01/100)*M_PIS,"@R 9999,999.99")
?? " VALOR COFINS: " + transform((E_BASE01/100)*M_COF,"@R 9999,999.99")

set console on
set printer to 
set print off


***************
function TOTPIS_S
***************

if ANFS00->NFSCAN $ "CD"
  return ""
endif

msw("Lendo xml: " +  ANFS00->NFSID)

if !le_xml("F:\CIRUR\ENVIADO\" + alltrim(ANFS00->NFSUSU) + "\NFE\"+ ANFS00->NFSID)
  return ""
endif

select ANFTM1
go top

do while !eof()

      APCA00->(dbseek(str(ANFTM1->NFEMAT, 6, 0)))

      if empty(APCA00->PCANBM)
        msg("* * * PRODUTO + " + str(APCA00->PCAMAT) + " SEM CODIGO NCM * * *")
        select ANFTM1
        skip
        loop
      endif
    
      lNaopis = .f.

        S_BASE01 += NFEVLI
        L_BASE01 += NFELIQ

        M_NFSBIC += NFELIQ // + ANFS01->NFSDSP + ANFS01->NFSVICS + ANFS01->NFSVIP
        M_TOTPIS += round(((NFELIQ/100) * M_PIS),2)
        S_TOTVPIS += round(((NFELIQ/100) * M_PIS),2)
        M_TOTCOF += round(((NFELIQ/100) * M_COF),2)
        S_TOTVCOF += round(((NFELIQ/100) * M_COF),2)

      select ANFTM1

      if inkey() = 27
        if suspro()
          msg("* * * PROCESSO SUSPENSO * * *")
          return ""
        endif
      endif

      skip

    enddo

return ""

***************
function TOTPIS_SER
***************

if ANFS00->NFSCAN $ "CD"
  return ""
endif

select ANFS01
dbsetorder(1)
dbseek(str(ANFS00->NFSEMP, 2) + str(ANFS00->NFSNUM, 6) + ANFS00->NFSSER, .t.)

do while !eof()

  if !str(NFSEMP, 2) + str(NFSNUM, 6) + NFSSER == str(ANFS00->NFSEMP, 2) + str(ANFS00->NFSNUM, 6) + ANFS00->NFSSER
    exit
  endif

      APCA00->(dbseek(str(ANFS01->NFSMAT, 6, 0)))

        S_BASE01 += NFSLIQ
        L_BASE01 += NFSLIQ

        M_NFSBIC += NFSLIQ 
        M_TOTPIS += round(((NFSLIQ/100) * M_PIS),2)
        S_TOTVPIS += round(((NFSLIQ/100) * M_PIS),2)
        M_TOTCOF += round(((NFSLIQ/100) * M_COF),2)
        S_TOTVCOF += round(((NFSLIQ/100) * M_COF),2)

      select ANFS01

      if inkey() = 27
        if suspro()
          msg("* * * PROCESSO SUSPENSO * * *")
          return ""
        endif
      endif

      skip

    enddo

return ""

***************
function REG170_S
***************

local nSEQ

nSEQ = 1

select ANFTM1
go top

do while !eof()

//    1  2  3    4 5 6  7   8   9  10  11   12   13 14 15 16 17 18 19 20 21 22 23 24 25
// |C170|2|20550| |2|JG|24|0,96|0|060|5405|51200|0 |0 |0 |0 |0 |0 |0 |00|  |0 | 0| 0|01|23,04|1,65|||0,38|01|23,04|7,6|||1,75||

      APCA00->(dbseek(str(ANFTM1->NFEMAT, 6, 0)))

      // REGISTRO C170 NOTA FISCAL ITENS

      M_REGC170 ++
      QDE_LIN ++

      nCAMPO = "|C170|"
      nCAMPO += alltrim(str(nSEQ)) + "|"
      nCAMPO += alltrim(str(NFEMAT,6)) + "|" 
      nCAMPO += "|"
      nCAMPO += forvalor(NFEQDE)  + "|"  
      nCAMPO += alltrim(APCA00->PCAUNI)+ "|"  
      nCAMPO += forvalor(NFEVLI)  + "|"  
      nCAMPO += forvalor(NFEVLI-NFELIQ)  + "|"  // DESCONTO


  M_NFECST = ""

  if M_NFECST == ""
    if NFEVLI = NFEBIC .or. NFEBIC > NFEVLI
      M_NFECST = "000"
    else
      if NFEBIC = 0
        M_NFECST = "010"
      else
        if NFEBIC < NFEVLI
          M_NFECST = "020"  // reducao icms
        endif
      endif
    endif
  endif


      if NFEPIC = 3 .OR. NFEPIC = 4 .or. NFEPIC = 5
        nCAMPO += "0|100|"
      else        
        if NFEBIC > 0 
          nCAMPO += "0|"
          nCAMPO += M_NFECST + "|"
        else
          nCAMPO += "0|040|"
        endif
      endif

      select AFIS00
      lRecfis = recno()

      if !dbseek(left(ANFTM1->NFENATN,1) + "." + right(ANFTM1->NFENATN,3))
        msg("CFOP: " + ANFTM1->NFENATN + " CONTA SINTETICA NAO CADASTRADA")
      else
        if AFIS00->FISDEB = space(15)
          msg("CFOP: " + ANFTM1->NFENATN + " CONTA SINTETICA NAO CADASTRADA")
        endif
      endif

      select ANFTM1

      nCAMPO += NFENATN + "|"  // 11
      nCAMPO += "|"   // 12 NAO OBRIGATORIO
      nCAMPO += forvalor(NFEBIC) + "|"  // 13

      if NFEPIC = 6
        nCAMPO += forvalor(7) + "|"  // 14
      else
        if NFEPIC = 11
          nCAMPO += forvalor(12) + "|"  // 14
        else
          if NFEPIC = 17
            nCAMPO += forvalor(18) + "|"  // 14
          else
            if NFEPIC = 3
              nCAMPO += forvalor(4) + "|"  // 14
            else
              if NFEPIC = 8
                nCAMPO += forvalor(7) + "|"  // 14
              else
                if NFEPIC = 5
                  nCAMPO += forvalor(4) + "|"  // 14
                else
                  nCAMPO += forvalor(NFEPIC) + "|"  // 14
                endif
              endif
            endif
          endif
        endif
      endif

      nCAMPO += forvalor(NFEVIC) + "|"  // 15
      nCAMPO += "0|" // 16
      nCAMPO += "0|"  // 17
      nCAMPO += "0|"  // 18
      nCAMPO += "0|"  // 19
      nCAMPO += "99|" // 20
      nCAMPO += "|"   // 21
      nCAMPO += "0|"  // 22
      nCAMPO += "0|"  // 23
      nCAMPO += "0|"  // 24

      if empty(APCA00->PCANBM)
        msg("* * * PRODUTO + " + str(APCA00->PCAMAT) + " SEM CODIGO NCM * * *")
        select ANFTM1
        skip
        loop
      endif

      select ANCM00

      if !dbseek(APCA00->PCANBM)
        msg("* * * CODIGO NCM NAO CADASTRADO PRODUTO " + str(APCA00->PCAMAT) + " * * *")
        select ANFTM1
        skip
        loop
      endif
    
      select ANFTM1

      lNaopis = .f.

      if ANCM00->ALIQZERO == "S" .or. ANCM00->SUBSTRIB == "S"
        lNaopis = .t.
        nCampo += ANCM00->NCMCST + "|"  // 25 

        select SPED1

        if !dbseek(ANCM00->NCMCST + str(ANCM00->NCMCODALI,3))
          append blank
        endif
        replace CODIGO with str(ANCM00->NCMCODALI,3)
        replace CST    with ANCM00->NCMCST
        replace VALOR  with VALOR + ANFTM1->NFELIQ

      else
        nCampo += "01|"  // 25 TRIBUTADO COM ALIQUOTA BASICA
      endif

      select ANFTM1

      if lNaopis
        nCAMPO += forvalor(0)  + "|"  // 26
        nCAMPO += forvalor(0)  + "|"  // 27
        nCAMPO += "|" // 28
        nCAMPO += "|" // 29
        nCAMPO += forvalor(0)   + "|"  // 30
      else
        nCAMPO += forvalor(NFELIQ)  + "|"  // 26
        nCAMPO += forvalor(M_PIS)  + "|"  // 27
        nCAMPO += "|" // 28
        nCAMPO += "|" // 29
        nCAMPO += forvalor(round(((NFELIQ/100) * M_PIS),2))   + "|"  // 30
      endif

// COFINS

      if ANCM00->ALIQZERO == "S" .or. ANCM00->SUBSTRIB == "S"
        nCampo += ANCM00->NCMCST + "|"  // 25 
      else
        nCampo += "01|"  // 31 TRIBUTADO COM ALIQUOTA BASICA
      endif

      if lNaopis
        nCAMPO += forvalor(0)  + "|"  // 32
        nCAMPO += forvalor(0)  + "|"  // 33
        nCAMPO += "|" // 34
        nCAMPO += "|" // 35
        nCAMPO += forvalor(0)   + "|"  // 36
      else
        nCAMPO += forvalor(NFELIQ)  + "|"  // 32
        nCAMPO += forvalor(M_COF)  + "|"  // 33
        nCAMPO += "|" // 34
        nCAMPO += "|" // 35
        nCAMPO += forvalor(round(((NFELIQ/100) * M_COF),2))   + "|"  // 36
      endif

      nCAMPO += alltrim(transform(AFIS00->FISDEB,"@R 9.9.9.99.9999")) + "|" // 37

      select PISCOF
      append blank
      replace CODIGO with "C170"
      replace CAMPO with nCAMPO
      replace CONTA with alltrim(transform(AFIS00->FISDEB,"@R 9.9.9.99.9999"))

      select AFIS00
      go lRecfis

      QDE_LIN_C ++
      nSEQ ++

      select ANFTM1

      if inkey() = 27
        if suspro()
          msg("* * * PROCESSO SUSPENSO * * *")
          return ""
        endif
      endif

      skip

    enddo

return ""

***************
function REGA170_S
***************

local nSEQ

nSEQ = 1

select ANFS01 
dbsetorder(1)
dbseek(str(ANFS00->NFSEMP, 2) + str(ANFS00->NFSNUM, 6) + ANFS00->NFSSER, .t.)

do while !eof()

  if !str(NFSEMP, 2) + str(NFSNUM, 6) + NFSSER == str(ANFS00->NFSEMP, 2) + str(ANFS00->NFSNUM, 6) + ANFS00->NFSSER
    exit
  endif

      APCA00->(dbseek(str(ANFS01->NFSMAT, 6, 0)))

      // REGISTRO C170 NOTA FISCAL ITENS

      M_REGA170 ++
      QDE_LIN ++

      nCAMPO = "|A170|"
      nCAMPO += alltrim(str(nSEQ)) + "|"
      nCAMPO += alltrim(str(NFSMAT,6)) + "|" 
      nCAMPO += "|"
      nCAMPO += forvalor(NFSVLI)  + "|"  
      nCAMPO += forvalor(NFSVLI-NFSLIQ)  + "|"  // DESCONTO
      nCampo += "06|"  // ALUGUEL
      nCAMPO += "0|"   // MERCADO INTERNO


      select ANFS01

      nCAMPO += "01|"   // TRIBUTAVEL ALIQUOTA BASICA
      nCAMPO += forvalor(NFSLIQ)  + "|"  // 26
      nCAMPO += forvalor(M_PIS)  + "|"  // 27
      nCAMPO += forvalor(round(((NFSLIQ/100) * M_PIS),2))   + "|"  // 30

// COFINS

      nCAMPO += "01|"   // TRIBUTAVEL ALIQUOTA BASICA
      nCAMPO += forvalor(NFSLIQ)  + "|"  // 32
      nCAMPO += forvalor(M_COF)  + "|"  // 33
      nCAMPO += forvalor(round(((NFSLIQ/100) * M_COF),2))   + "|"  // 36

      nCAMPO += "|" // 37
      nCAMPO += "|" // 37

      select PISCOF
      append blank
      replace CODIGO with "A170"
      replace CAMPO with nCAMPO

      nSEQ ++

      select ANFS01

      if inkey() = 27
        if suspro()
          msg("* * * PROCESSO SUSPENSO * * *")
          return ""
        endif
      endif

      skip

    enddo

return ""

***************
function REG170EPI
***************

local nSEQ

nSEQ = 1

select ANFE01
dbseek(str(ANFE00->NFEEMP, 2, 0) + str(ANFE00->NFENUM, 6, 0) + ANFE00->NFESER + str(ANFE00->NFEFOR, 7, 0), .t.)

do while !eof()

  if !str(NFEEMP, 2, 0) + str(NFENUM, 6, 0) + NFESER + str(NFEFOR, 7, 0) == str(ANFE00->NFEEMP, 2, 0) + str(ANFE00->NFENUM, 6, 0) + ANFE00->NFESER + str(ANFE00->NFEFOR, 7, 0)
    exit
  endif

  M_NFECST = alltrim(NFECST)
  M_NFEORI = alltrim(NFEORI)

  if M_NFEORI == ""
    M_NFEORI = "0"
  endif

  if M_NFECST == ""
    if NFEVLI = NFEBIC .or. NFEBIC > NFEVLI
       M_NFECST = M_NFEORI + "00"
    else
      if NFEBIC = 0
        M_NFECST = M_NFEORI + "40"
      else
        if NFEBIC < NFEVLI
          M_NFECST = M_NFEORI + "20"  // reducao icms
        endif
      endif
    endif
  else
    if NFEORI == " "
      M_NFECST = M_NFEORI + M_NFECST
    else
      M_NFECST = M_NFEORI + M_NFECST
    endif
  endif

  if NFEPIC = 4 // quando 4% importado
    M_NFECST = "100"  // 1=IMPORTADO 00=TRIBUTADO INTEGRAL
  endif

  M_NFENAT = alltrim(tira_pto(NFENATN))

  if M_NFENAT $ "#1551#1556#2556#"
    M_NFECST = "090"  // sempre 090 OUTRAS
  endif

  if !M_NFENAT $ "#1406#"
    if M_NFECST = "060"  // sempra substituicao
      if M_NFENAT $ "1102"
        M_NFENAT = "1403"
      else
        if M_NFENAT $ "2102"
          M_NFENAT = "2403"
        endif
      endif   
    endif
  endif

  if M_NFENAT $ "#2403#1403#"
    if NFEBIC = 0
      M_NFECST = "060"
    endif
  endif

  APCA00->(dbseek(str(ANFE01->NFEMAT, 6, 0)))

  // REGISTRO C170 NOTA FISCAL ITENS

  M_REGC170 ++
  QDE_LIN ++

  nCAMPO = "|C170|"  // 1
  nCAMPO += alltrim(str(nSEQ)) + "|" // 2
  nCAMPO += alltrim(str(NFEMAT,6)) + "|" // 3
  nCAMPO += "|"                          // 4
  nCAMPO += forvalor(NFEQDE)  + "|"   // 5
  nCAMPO += alltrim(APCA00->PCAUNI)+ "|"   // 6
  nCAMPO += forvalor(NFEVLI)  + "|"       // 7

  if NFEDSC > 0
    nCAMPO += forvalor(NFEDSC)  + "|"  // DESCONTO
  else
    nCAMPO += forvalor(0)  + "|"  // DESCONTO  8
  endif

  nCAMPO += "0|"  // 9
  nCAMPO += M_NFECST + "|"  // 10
  nCAMPO += M_NFENAT + "|"  // 11

      nCAMPO += "|"                     // 12 NAO OBRIGATORIO
      nCAMPO += forvalor(NFEBIC) + "|"  // 13
      nCAMPO += forvalor(NFEPIC) + "|"  // 14
      nCAMPO += forvalor(NFEVIC) + "|"  // 15
      nCAMPO += "0|" // 16
      nCAMPO += "0|"  // 17
      nCAMPO += "0|"  // 18

*      nCAMPO += "0|"  // 19
*      nCAMPO += "99|" // 20
*      nCAMPO += "|"   // 21

      nCAMPO += "|"  // 19
      nCAMPO += "|" // 20
      nCAMPO += "|"   // 21

      nCAMPO += "0|"  // 22
      nCAMPO += "0|"  // 23
      nCAMPO += "0|"  // 24

      select ANCM00

      if !dbseek(APCA00->PCANBM)
        msg("* * * CODIGO NCM NAO CADASTRADO PRODUTO " + str(APCA00->PCAMAT) + " * * *")
        select ANFE01
        skip
        loop
      endif

      select ANFE01

      lCSTPIS = "50"
      lNaopis = .f.

      if ANCM00->ALIQZERO == "S" .or. ANCM00->SUBSTRIB == "S"
        lNaopis = .t.
        if ANCM00->ALIQZERO == "S"
          lCSTPIS = "73"
        else
          lCSTPIS = "75"
        endif
      endif

      if M_NFENAT $ "#1653#1407#2910#1353#2353#2949#1552#2551#1949#1910#1556#2556#1406#1551" .or. right(M_NFECST,2) == "40"
        lCSTPIS = "70"
        lNaopis = .t.
      endif

      if lNaopis
        nCAMPO += lCSTPIS + "|"  // 25 
        nCAMPO += forvalor(0)  + "|"  // 26
        nCAMPO += forvalor(0)  + "|"  // 27
        nCAMPO += "|" // 28
        nCAMPO += "|" // 29
        nCAMPO += forvalor(0)   + "|"  // 30
      else
        // EM 24/02 SAWIL INFORMOU
        // INCLUIR IPI BASE CALCULO PIS/COFINS

        nCAMPO += lCSTPIS + "|"  // 25 
        nCAMPO += forvalor(NFEVLI+NFEVIP+NFEDST+NFEFRE)  + "|"  // 26
        nCAMPO += forvalor(M_PIS)  + "|"  // 27
        nCAMPO += "|" // 28
        nCAMPO += "|" // 29
        nCAMPO += forvalor(round((((NFEVLI+NFEVIP+NFEDST+NFEFRE)/100) * M_PIS),2))   + "|"  // 30
      endif

      if lNaopis
        nCAMPO += lCSTPIS + "|"  // 31 
        nCAMPO += forvalor(0)  + "|"  // 32
        nCAMPO += forvalor(0)  + "|"  // 33
        nCAMPO += "|" // 34
        nCAMPO += "|" // 35
        nCAMPO += forvalor(0)   + "|"  // 36
      else
        nCAMPO += lCSTPIS + "|"  // 31 
        nCAMPO += forvalor(NFEVLI+NFEVIP+NFEDST+NFEFRE)  + "|"  // 32
        nCAMPO += forvalor(M_COF)  + "|"  // 33
        nCAMPO += "|" // 34
        nCAMPO += "|" // 35
        nCAMPO += forvalor(round((((NFEVLI+NFEVIP+NFEDST+NFEFRE)/100) * M_COF),2))   + "|"  // 36
      endif

      select AFIS00
      lRecfis = recno()


      if !dbseek(left(M_NFENAT,1) + "." + right(M_NFENAT,3))
        msg("CFOP: " + M_NFENAT + " CONTA SINTETICA NAO CADASTRADA")
      endif

      if AFIS00->FISDEB = space(15)
        msg("CFOP: " + M_NFENAT + " CONTA SINTETICA NAO CADASTRADA")
      endif

      nCAMPO += alltrim(transform(AFIS00->FISDEB,"@R 9.9.9.99.9999")) + "|" // 37

      select PISCOF
      append blank
      replace CODIGO with "C170"
      replace CAMPO with nCAMPO
      replace CONTA with alltrim(transform(AFIS00->FISDEB,"@R 9.9.9.99.9999"))

      select AFIS00
      go lRecfis

      QDE_LIN_C ++
      nSEQ ++

      select ANFE01

      if inkey() = 27
        if suspro()
          msg("* * * PROCESSO SUSPENSO * * *")
          return ""
        endif
      endif

      skip

    enddo

return ""

*********************************
function GRAVAPIS(F_CAMPO,F_DESC)
*********************************

select PISCOF
append blank
replace CODIGO with F_CAMPO
replace CAMPO with F_DESC

return ""