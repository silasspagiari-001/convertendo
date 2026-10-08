******************
function FINALSPED
******************

select 0
use SPED00 exclusive
select SPED00
zap

append from C:\PIS\EFDICMS.TXT SDF

seexiste("ACLISP")

  select 0
  use ACLISP exclusive
  index on NFSCLI tag 1 to ACLISP
  set index to ACLISP

set console off
set print on
set printer to "C:\PIS\CIRUR_SPED.TXT"

select SPED00
go top

lPrifor = .t.

do while !eof()

  if left(NOME,7) == "|0150|F"
    skip
    loop
  endif

  if left(NOME,6) == "|0190|" .and. lPrifor = .t.

*    ? "|0150|CIELO|CIELO SA|1058|01027058000191|||3505708||Alameda Xingu|512|do 21 ao 31 andar|Alphaville|"
    ? "|0150|F609|ENERGISA SUL-SUDESTE DISTR ENERGIA S.A|1058|07282377000120||562408684115|3541406||ROD ASSIS CHATEAUBRIAND, KM 455|||VILA MARIA|"
*    ? "|0150|BRASIL|Banco do Brasil S/A|1058|00000000000191|||5300108||Setor de Autarquias Norte|Quadra 5|Lote B|Asa Norte|"
    lPrifor = .f.
    select ACLISP
    go top
    do while !eof()

      lNao = .f.

      if !left(NFSCLI,1) == "F"
        skip
        loop
      endif

      BUSCAREGISTRO("AFOR00",1,{str(val(right(ACLISP->NFSCLI,11)),7,0)},"SELECT")

      select ACLISP

      ? "|0150|"  // REGISTRO 01
      ?? alltrim(ACLISP->NFSCLI) + "|" // 02
      ?? alltrim(AFOR00->FORNOM) + "|" // 03
      ?? "1058|"              // 04 PAIS

      if len(alltrim(AFOR00->FORCGC))=15
        ?? right(AFOR00->FORCGC,14) + "|" + "|"     // 06 CPF
      else
        if !empty(AFOR00->FORCGC)
          ?? "|" + pad(alltrim(AFOR00->FORCGC),11) + "|"
        endif
      endif

      if "ISENTO" $ AFOR00->FORIES
        ?? "|"     // parei aqui
      else
        ?? tira_pto(AFOR00->FORIES) + "|"     // parei aqui
      endif

      ?? alltrim(str(AFOR00->FORCDM,7)) + "|"
      ?? "|"     // 09 SUFRAMA
      ?? alltrim(AFOR00->FOREND) + "|"     // 10 END
      ?? "|"     // 11 NUM
      ?? "|"     // 12 COMPL
      ?? alltrim(AFOR00->FORBAI) + "|"    // 13 BAIRRO

      skip
    enddo
  endif

  select SPED00

  ? NOME

  skip

enddo

set printer to
set print off

select SPED00
zap

append from C:\PIS\CIRUR_SPED.TXT SDF
delete all for NOME = space(250)
pack

go bottom
replace NOME with "|9999|" + alltrim(str(lastrec(),5)) + "|"

count for left(NOME,6) == "|9900|" to M_T9900
locate for left(NOME,11) == "|9900|9900|"
replace NOME with "|9900|9900|" + alltrim(str(M_T9900,5)) + "|"

count for left(NOME,2) == "|9" to M_T9
locate for left(NOME,6) == "|9990|"
replace NOME with "|9990|" + alltrim(str(M_T9,5)) + "|"

locate for left(NOME,6) == "|0990|"
replace NOME with "|0990|" + alltrim(str(recno(),5)) + "|"

count for left(NOME,2) == "|C" to M_C
locate for left(NOME,6) == "|C990|"
replace NOME with "|C990|" + alltrim(str(M_C,5)) + "|"

count for left(NOME,6) == "|0150|" to M_150
locate for left(NOME,11) == "|9900|0150|"
replace NOME with "|9900|0150|" + alltrim(str(M_150,5)) + "|"

count for left(NOME,6) == "|C176|" to M_C176
locate for left(NOME,11) == "|9900|C176|"
replace NOME with "|9900|C176|" + alltrim(str(M_C176,5)) + "|"

set console off
set print on
set printer to "C:\PIS\CIRUR_SPED.TXT"

go top

do while !eof()
 ?? alltrim(NOME)
 ?
 skip
enddo

set printer to
set print off

msg("fim do processo")

quit

return ""

*********************
function ULT_COMPRA(F_PROD,F_DTA,F_TIPO,F_C176,F_QDE)   // F_TIPO = ENTRADA, SAIDA
*********************

if F_QDE = NIL
  F_QDE = 0
  F_QDE1 = 0
endif

F_QDETOT = 0
F_QDE1 = F_QDE

select ANFE00
set order to 1

select ANFE01
set relation to str(NFEEMP,2,0) + str(NFENUM, 6, 0) + NFESER + str(NFEFOR, 5, 0) into ANFE00
set order to 2
dbseek(descend(str(ME_EMP, 2, 0) + str(F_PROD, 6, 0)),.t.)

do while !eof()

  if !str(NFEEMP, 2, 0) + str(NFEMAT, 6, 0) == str(ME_EMP, 2, 0) + str(F_PROD, 6, 0)
    exit
  endif

  if ANFE00->NFEDTR > F_DTA
    skip
    loop
  endif

  if lRecnfe = ANFE00->(recno())
    skip
    loop
  endif

  if ANFE00->NFESER == "EL"
    skip
    loop
  endif

  if rat(substr(str(ANFE00->NFENAT, 5, 0), 1, 3),"#172#112#212#272") > 0 .or. str(ANFE00->NFENAT,5) $ "14030#21020"

  *  if F_TIPO == "S"  // teria que pegar ST
  *    if NFEBICST = 0
  *      select ANFE01
  *      set relation to
  *      set order to 1
  *      return 0
  *    endif
  *  endif

    if M_COMPRA = 0
      M_COMPRA = NFELIQ    // UNITARIO
      M_BASEST = NFEBICST  // UNITARIO
      M_ALIQIC = NFEPIC2
      F_QDETOT = NFEQDE
    else
      if F_QDE1 > NFEQDE
        M_COMPRA += NFELIQ    // UNITARIO
        M_BASEST += NFEBICST  // UNITARIO
        F_QDETOT += NFEQDE
      else
        M_COMPRA += ((NFELIQ/NFEQDE)*F_QDE1)    // UNITARIO
        M_BASEST += ((NFEBICST/NFEQDE)*F_QDE1)  // UNITARIO
        F_QDETOT += F_QDE1
      endif
    endif

    if F_QDE1 > 0
      F_QDE1 -= NFEQDE
    endif

    if F_QDE1 <= 0
      M_COMPRA = M_COMPRA/F_QDETOT
      M_BASEST = M_BASEST/F_QDETOT
    endif

    if F_TIPO == "R"  // RESUMO DE ICMS EAGRO21
      M_IMPCPA1 = alltrim(str(iif(ANFE00->NFENUM1 > 0,ANFE00->NFENUM1,ANFE00->NFENUM), 9))
      M_IMPCPA1 += " - "
      if ANFE00->NFESER1 == "---"
        M_IMPCPA1 += "   "
      else
        if ANFE00->NFESER == "EL"
          M_IMPCPA1 +=  "1  "
        else
          M_IMPCPA1 +=  pad(alltrim(iif(!empty(ANFE00->NFESER1),ANFE00->NFESER1,ANFE00->NFESER)),3)
        endif
      endif

      M_IMPCPA1 +=  " "
      M_IMPCPA1 +=  dtoc(ANFE00->NFEDTR)
      M_IMPCPA1 +=  " Fornecedor: "
      M_IMPCPA1 +=  str(NFEFOR,7)
      M_IMPCPA1 +=  " Qtde: "
      M_IMPCPA1 += forvalor(NFEQDE)
      M_IMPCPA1 += " Unitario: "
      M_IMPCPA1 += forvalor((NFELIQ+NFEDSC+NFEFRE)/NFEQDE)
      M_IMPCPA1 += " Unitario BC ST: "
      M_IMPCPA1 += forvalor(NFEBICST/NFEQDE)
      aadd(M_IMPCPA,M_IMPCPA1)
    endif

    if F_C176
      QDE_C176 ++
      ? "|C176|"

      if len(alltrim(ANFE00->NFSID)) > 0
        ?? "55|"               // 05 MODELO NOTA FISCAL
      else
        ?? "01|"               // 05 MODELO NOTA FISCAL
      endif

      ?? alltrim(str(iif(ANFE00->NFENUM1 > 0,ANFE00->NFENUM1,ANFE00->NFENUM), 9)) + "|"   // 08 NUMERO DOCUMENTO

      if ANFE00->NFESER1 == "---"
        ?? "|"
      else
        if ANFE00->NFESER == "EL"
          ?? "1|"
        else
          ?? alltrim(iif(!empty(ANFE00->NFESER1),ANFE00->NFESER1,ANFE00->NFESER)) + "|"   // 07 serie obrigatorio nao
        endif
      endif

      ?? fordata(ANFE00->NFEDTR) + "|"     // 11 SAIDA OU RECEPCAO
      ?? alltrim("F"+alltrim(str(NFEFOR,7))) + "|" // 04 COD CLIENTE
      ?? forvalor(NFEQDE)  + "|"        // 05
      ?? forvalor((NFELIQ+NFEDSC+NFEFRE)/NFEQDE)  + "|"

      if NFEBICST > 0
        ?? forvalor(NFEBICST/NFEQDE) + "|"
      else
      ?? forvalor( ((NFELIQ+NFEDSC+NFEFRE)/NFEQDE)*1.35 )  + "|"
      endif

      M_DIG = ""
      if len(alltrim(ANFE00->NFSID)) = 43
        M_DIG = mod11_nfe(alltrim(ANFE00->NFSID))
      endif

      ?? alltrim(left(ANFE00->NFSID,44)) + M_DIG + "|" // 10
      ?? alltrim(str(NFESEQ)) + "|"    // 11

      if NFEBIC+NFEBIC2>0
        ?? forvalor(iif(NFEBIC>0,NFEBIC,NFEBIC2)/NFEQDE)  + "|"            // 12
      else
        ?? forvalor((NFELIQ+NFEDSC+NFEFRE)/NFEQDE)  + "|"
      endif

      ?? "|||||||||||||||"

      select ACLISP

      if !dbseek(pad("F"+alltrim(str(ANFE00->NFEFOR,7)),12))
        append blank
        replace NFSCLI with "F"+alltrim(str(ANFE00->NFEFOR,7))
      endif
    endif

    if F_QDE1 > 0
      skip
      loop
    endif

    nRetval = ANFE01->NFEBICST/ANFE01->NFEQDE

    select ANFE01
    set relation to
    set order to 1

    return nRetval

  else
    skip
  endif

enddo

select ANFE01
set relation to
set order to 1

return 0


*************
function SPED
*************

if upper(alltrim(netname())) $ "SERVIDOR"
  ACBrNFe_ENT = "D:\NFE\ENTNFE.TXT"
  ACBrNFe_SAI = "D:\NFE\SAINFE.TXT"
  ACBrNFe_TMP = "D:\NFE\ARQTMP.TXT"
  ACBrNFe_UNI = "D:"
endif

if file("RESNFS.CDX")
  erase("RESNFS.CDX")
endif

select 0
use RESNFS exclusive
index on NFENATN + str(NFEPIC,6,2) tag 1 to RESNFS

select 0
use C850 exclusive
index on CST + CFOP + str(ALIQ_ICMS,6,2) tag 1 to C850
set index to C850

if file("C870.CDX")
  erase("C870.CDX")
endif

select 0
use C870 exclusive
index on CST + CFOP + str(ALIQ_ICMS,6,2) tag 1 to C870
set index to C870

if file("C860.CDX")
  erase("C860.CDX")
endif

select 0
use C860 exclusive
index on dtos(SATDTA) tag 1 to C860
set index to C860

lTelapis = savescreen(07,24,11,51)

M_PIS = 1.65
M_COF = 7.6

@ 24, 00 clear

  rodape("SPED","FISCAL",M_FAN,"EAGRO47","Mem: " + str(memory(0), 5),M_EMP)

  store ctod("  /  /  ")  to M_DATA1, M_DATA2

  sombra(07, 24, 10, 50, _SOMBRA_)

  set color to GR+/W
  @ 07, 24 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
  @ 08, 24 say "³Periodo Inicial:         ³"
  @ 09, 24 say "³          Final:         ³"
  @ 10, 24 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
  set color to

  @ 08, 42 get M_DATA1
  @ 09, 42 get M_DATA2
  read

  if lastkey() = 27
    restscreen(07,24,11,51,lTelapis)
    return ""
  endif

  if M_DATA1 = ctod("  /  /  ")
    M_DATA1 = ctod("01" + substr(dtoc(date()), 3, 6))
  endif

  if M_DATA2 = ctod("  /  /  ")
    M_DIAFI = ctod("01/" + strzero((month(date()) + 1), 2, 0) + substr(dtoc(date()), 6, 3))
    M_DATA2 = (M_DIAFI - 1)
  endif

seexistesql("ANFS01")
cSQL := "SELECT first 1 * from ANFS01"
dbusearea(.t.,"SQLMIX",cSQL,"ANFS01")
cria_dbf("APROD")  // CRIA DBF A PARTIR DO ARQUIVO ABERTO COM O NOME INDICADO
select 0
use APROD
index on NFSMAT tag 1 to APROD
set index to APROD

aUnidade = { }
aadd(aUnidade,"PC")

M_VALPIS = 0
M_VALCOF = 0

select 0
use XML1 exclusive alias ANFTM1

select 0
use XML0 exclusive alias ANFETM

M_ICMSAIDA = 0 // = C190
M_ICMENTRA = 0 // = C190
M_ENTSUB = 0

set console off
set print on
set printer to "C:\PIS\EFDICMS.TXT"

// REGISTRO 0000 ABERTURA IDENTIFICACAO E REFERENCIA
??  "|0000|"
?? "019|"                                       // 02 versao do layout
?? "0|"                                         // 03 remessa arquivo
?? fordata(M_DATA1) + "|"                          // 06 data inicial
?? fordata(M_DATA2) + "|"                          // 07 data final
?? alltrim(AEMP00->EMPNOM) + "|"                // 08 nome
?? right(AEMP00->EMPCGC,14) + "|"               // 09 cnpj
?? "|"                                          // cpf
?? pad(AEMP00->EMPEST,2) + "|"                  // 10 uf
?? alltrim(tira_pto(AEMP00->EMPIES)) + "|"                //
?? "3541406|"                                   // 11 cod cidade\
?? "|"                                          // 12 incricao municipal
?? "|"                                          // 12 incricao suframa
?? "A|"                                        // 13 perfil
?? "1|"                                         // 14 outros

QDE_0000 = 1
BLOCO_0 = 1
QDE_LIN = 1

? "|0001|"
?? "0|"   // bloco com dados informados

QDE_LIN ++
QDE_0001 = 1
BLOCO_0 ++

// REGISTRO 0005 REGISTRO COMPLEMENTAR

?  "|0005|"
?? alltrim(AEMP00->EMPFAN) + "|"                  // 10 uf
?? strzero(AEMP00->EMPCEP,5) + strzero(AEMP00->EMPCCE,3) + "|"
?? "AV MANOEL GOULART" + "|"
?? "595|"
?? "|"
?? alltrim(AEMP00->EMPBAI) + "|"                //
?? tira_pto(AEMP00->EMPTEL)+ "|"                //
?? tira_pto(AEMP00->EMPTEL)+ "|"                //
?? "cirurcenter@ig.com.br"+ "|"
QDE_0005 = 1
BLOCO_0 ++
QDE_LIN ++

? "|0100|SERGIO ITIO TURUTA|05653197874|1SP13791501|57327827000121|"
?? "|"      // 06 cep
?? "|"      // 07 endereco
?? "|"      // 08 numero
?? "|"      // 09 complemento
?? "|"      // 10 bairro
?? "|"      // 11 fone
?? "|"      // 12 fax
?? "silvestrini@sawil.com.br|"      // 13 email
?? "3541406|"      // 14 cod_mun

QDE_0100 = 1
BLOCO_0 ++
QDE_LIN ++
QDE_C176 = 0

select 0
use ACLISP exclusive
index on NFSCLI tag 1 to ACLISP
set index to ACLISP
zap

select 0
use ACLI0 exclusive
index on NFSCLI tag 1 to ACLI0
set index to ACLI0
zap


sqlRELATION = {}
sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {}
sqlORDEM = {}
aadd(sqlARQUI,{"ANFS00","ANFS00"})
aadd(sqlCAMPO,"ANFS00.NFSDTE")
aadd(sqlCAMPO,"ANFS00.NFSCLI")
aadd(sqlCAMPO,"ACLI00.CLINOM")
aadd(sqlCAMPO,"ACLI00.CLICGC1")
aadd(sqlCAMPO,"ACLI00.CLIIES1")
aadd(sqlCAMPO,"ACLI00.CLIBAI2")
aadd(sqlCAMPO,"ACLI00.CLIEND2")
aadd(sqlCAMPO,"ACLI00.CLICDM2")
aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ANFS00.NFSCLI"})
aadd(sqlRELATION,{"AFIS00",str(ME_EMP, 2, 0),"AFIS00.FISEMP"})
aadd(sqlRELATION,{"","AFIS00.FISNOV","ANFS00.NFSNATN"})
aadd(sqlCHAVE,"ANFS00.NFSDTE BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
aadd(sqlCHAVE,"ANFS00.NFSEMP = " + str(ME_EMP, 2, 0))
aadd(sqlCHAVE,"ANFS00.nfscan not in ('C','D')")
aadd(sqlCHAVE,"AFIS00.FISPAN <> 'N'")
aadd(sqlCHAVE,"ANFS00.NFSSER <> 'E '")
aadd(sqlCHAVE,"ANFS00.NFSNATN <> '5.933'")

sqlrelation()

// 0150   CADASTRO CLIENTES FORNECEDORES

QDE_0150 = 0

  do while !eof()

    msw("Selecionando Clientes: " + dtoc(NFSDTE))

    if inkey() = 27
      if suspro()
        lCancelou = .t.
        msg("* * * PROCESSO SUSPENSO * * *")
        select ANFS00
        go bottom
        skip
        loop
      endif
    endif

    select ACLISP
    if !dbseek(pad(alltrim(str(ANFS00->NFSCLI,5)),12))
      append blank
      replace NFSCLI with alltrim(str(ANFS00->NFSCLI,7))
    else
      select ANFS00
      skip
      loop
    endif

    select ANFS00

    lNao = .f.

    ? "|0150|"  // REGISTRO 01
    ?? alltrim(str(NFSCLI, 7)) + "|" // 02
    ?? alltrim(CLINOM) + "|" // 03
    ?? "1058|"              // 04 PAIS

    if len(alltrim(CLICGC1))=15
      ?? right(CLICGC1,14) + "|" + "|"     // 06 CPF
    else
      if !empty(CLICGC1)
        ?? "|" + pad(alltrim(CLICGC1),11) + "|"
      endif
    endif

    if "ISENTO" $ CLIIES1
      ?? "|"     // parei aqui
    else
      ?? tira_ptoies(CLIIES1) + "|"     // parei aqui
    endif

    ?? alltrim(str(CLICDM2,7)) + "|"
    ?? "|"     // 09 SUFRAMA
    ?? alltrim(CLIEND2) + "|"     // 10 END
    ?? "|"     // 11 NUM
    ?? "|"     // 12 COMPL
    ?? alltrim(CLIBAI2) + "|"    // 13 BAIRRO

    QDE_0150 ++
    BLOCO_0 ++
    QDE_LIN ++

    select ANFS00
    skip
  enddo

// NFC-E CUPOM ELETRONICO

/*
   select ACUP00
   set order to 2
   dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)

  do while !eof()

    if str(CUPEMP, 2, 0) + dtos(CUPDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
      exit
    endif

    if CUPSER == "ST"
      skip
      loop
    endif

    msw("Selecionando Clientes: " + dtoc(CUPDTE))

    AFIS00->(dbseek(ACUP00->CUPNATN))

    if CUPCAN $ "CD"
      skip
      loop
    endif

    if inkey() = 27
      if suspro()
        lCancelou = .t.
        msg("* * * PROCESSO SUSPENSO * * *")
        select ACUP00
        go bottom
        skip
        loop
      endif
    endif

    select ACLISP
    if !dbseek(pad(alltrim(str(ACUP00->CUPCLI,5)),12))
      append blank
      replace NFSCLI with alltrim(str(ACUP00->CUPCLI,7))
    else
      select ACUP00
      skip
      loop
    endif

    select ACUP00

    lNao = .f.

    if !ACLI00->(dbseek(str(ACUP00->CUPCLI, 7, 0)))
      lNao = .t.
      msg("* * * CLIENTE NAO CADASTRADO " + str(ACUP00->CUPCLI,7) + "NOTA NUMERO: " + STR(ACUP00->CUPNUM,6) + " * * *")
      skip
      loop
    endif

    ? "|0150|"  // REGISTRO 01
    ?? alltrim(str(CUPCLI, 7)) + "|" // 02
    ?? alltrim(ACLI00->CLINOM) + "|" // 03
    ?? "1058|"              // 04 PAIS

    if len(alltrim(ACLI00->CLICGC1))=15
      ?? right(ACLI00->CLICGC1,14) + "|" + "|"     // 06 CPF
    else
      if !empty(ACLI00->CLICGC1)
        ?? "|" + pad(alltrim(ACLI00->CLICGC1),11) + "|"
      endif
    endif

    if "ISENTO" $ ACLI00->CLIIES1
      ?? "|"     // parei aqui
    else
      ?? tira_ptoies(ACLI00->CLIIES1) + "|"     // parei aqui
    endif

    ?? alltrim(str(ACLI00->CLICDM2,7)) + "|"
    ?? "|"     // 09 SUFRAMA
    ?? alltrim(ACLI00->CLIEND2) + "|"     // 10 END
    ?? "|"     // 11 NUM
    ?? "|"     // 12 COMPL
    ?? alltrim(ACLI00->CLIBAI2) + "|"    // 13 BAIRRO

    QDE_0150 ++
    BLOCO_0 ++
    QDE_LIN ++

    select ACUP00
    skip
  enddo

*/

// CADASTRO DE FORNECEDORES
  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}
  aadd(sqlARQUI,{"ANFE00","ANFE00"})
  aadd(sqlCAMPO,"ANFE00.NFEDTR")
  aadd(sqlCAMPO,"ANFE00.NFEFOR")
  aadd(sqlCAMPO,"AFOR00.FORNOM")
  aadd(sqlCAMPO,"AFOR00.FORCGC")
  aadd(sqlCAMPO,"AFOR00.FORIES")
*  aadd(sqlCAMPO,"AFOR00.FORIBGE")
  aadd(sqlCAMPO,"AFOR00.FORBAI")
  aadd(sqlCAMPO,"AFOR00.FOREND")
  aadd(sqlCAMPO,"AFOR00.FORCDM")
  aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","ANFE00.NFEFOR"})
  aadd(sqlRELATION,{"AFIS00",str(ME_EMP, 2, 0),"AFIS00.FISEMP"})
  aadd(sqlRELATION,{"","AFIS00.FISNOV","ANFE00.NFENATN"})
  aadd(sqlCHAVE,"ANFE00.NFEDTR BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
  aadd(sqlCHAVE,"ANFE00.NFEEMP = " + str(ME_EMP, 2, 0))
*  aadd(sqlCHAVE,"ANFE00.NFECAN not in ('C','D')")
  aadd(sqlCHAVE,"AFIS00.FISPAN <> 'N'")
  aadd(sqlCHAVE,"ANFE00.NFENATN not in ('2.353','1.253')")
  sqlrelation()

  do while !eof()

    @ 24, 00 say NFEDTR

  *  if alltrim(tira_pto(ANFE00->NFENATN)) $ "2353#1253#" // transporte
  *    skip
  *    loop
  *  endif

    if inkey() = 27
      if suspro()
        lCancelou = .t.
        msg("* * * PROCESSO SUSPENSO * * *")
        select ANFE00
        go bottom
        skip
        loop
      endif
    endif

    msw("Selecionando Fornecedores: " + dtoc(NFEDTR))

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

    ? "|0150|"  // REGISTRO 01
    ?? "F"+alltrim(str(NFEFOR, 7)) + "|" // 02
    ?? alltrim(FORNOM) + "|" // 03
    ?? "1058|"              // 04 PAIS

    if len(alltrim(FORCGC))=15
      ?? right(FORCGC,14) + "|" + "|"     // 06 CPF
    else
      if !empty(FORCGC)
        ?? "|" + pad(alltrim(FORCGC),11) + "|"
      endif
    endif

    if "ISENTO" $ FORIES
      ?? "|"     // parei aqui
    else
      ?? tira_pto(FORIES) + "|"     // parei aqui
    endif

    ?? alltrim(str(FORCDM,7)) + "|"
    ?? "|"     // 09 SUFRAMA
    ?? alltrim(FOREND) + "|"     // 10 END
    ?? "|"     // 11 NUM
    ?? "|"     // 12 COMPL
    ?? alltrim(FORBAI) + "|"    // 13 BAIRRO

    QDE_0150 ++
    BLOCO_0 ++
    QDE_LIN ++

    select ANFE00
    skip
  enddo

// FIM CADASTRO FORNECEDORES


// 0190   CADASTRO UNIDADES DE MEDIDA

QDE_0200 = 0

// 0200 CADASTRO PRODUTOS ANFS00

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}
  aadd(sqlARQUI,{"ANFE00","ANFE00"})
  aadd(sqlCAMPO,"distinct ANFE01.NFEMAT")
  aadd(sqlCAMPO,"APCA00.PCAUNI")
  aadd(sqlRELATION,{"AFIS00",str(ME_EMP, 2, 0),"AFIS00.FISEMP"})
  aadd(sqlRELATION,{"","AFIS00.FISNOV","ANFE00.NFENATN"})
  aadd(sqlRELATION,{"ANFE01","ANFE01.NFEEMP","ANFE00.NFEEMP"})
  aadd(sqlRELATION,{"","ANFE01.NFENUM","ANFE00.NFENUM"})
  aadd(sqlRELATION,{"","ANFE01.NFESER","ANFE00.NFESER"})
  aadd(sqlRELATION,{"","ANFE01.NFEFOR","ANFE00.NFEFOR"})
  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","ANFE01.NFEMAT"})
  aadd(sqlCHAVE,"ANFE00.NFEDTR BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
  aadd(sqlCHAVE,"ANFE00.NFEEMP = " + str(ME_EMP, 2, 0))
*  aadd(sqlCHAVE,"ANFE00.NFECAN not in ('C','D')")
  aadd(sqlCHAVE,"AFIS00.FISPAN <> 'N'")
  aadd(sqlCHAVE,"AFIS00.FISNOV not in ('2.353','1.353','1.253','1.303','1.932','2.932')")
  aadd(sqlCHAVE,"not (ANFE00.NFENAT = 19903 and ANFE00.NFESER = 'EL')")
  sqlrelation()

  do while !eof()

    IF HB_ISNIL(ANFE00->NFEMAT)
      SKIP
      LOOP
    ENDIF

    select APROD

    if !dbseek(ANFE00->NFEMAT)
      append blank
      replace NFSMAT with ANFE00->NFEMAT

      lAcheipro = .f.

      select ANFE00
      
      for ABC = 1 to len(aUnidade)
        if alltrim(PCAUNI) == alltrim(aUnidade[ABC])
          lAcheipro = .t.
          exit
        endif
      next
      if !lAcheipro
        aadd(aUnidade,PCAUNI)
      endif

    endif

    select ANFE00
    skip
  enddo



*  sqlRELATION = {}
*  sqlCAMPO = {}
*  sqlCHAVE =  {}
*  sqlARQUI = {}
*  sqlORDEM = {}
*  aadd(sqlARQUI,{"ACUP00","ACUP00"})
*  aadd(sqlCAMPO,"ACUP01.CUPMAT")
*  aadd(sqlCAMPO,"APCA00.PCAUNI")

*  aadd(sqlRELATION,{"AFIS00",str(1, 2, 0),"AFIS00.FISEMP"})
*  aadd(sqlRELATION,{"","AFIS00.FISNOV","ACUP00.CUPNATN"})
*  aadd(sqlRELATION,{"ACUP01","ACUP01.CUPEMP","ACUP00.CUPEMP"})
*  aadd(sqlRELATION,{"","ACUP01.CUPNUM","ACUP00.CUPNUM"})
*  aadd(sqlRELATION,{"","ACUP01.CUPSER","ACUP00.CUPSER"})
*  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","ANFE01.NFEMAT"})

*  aadd(sqlCHAVE,"ACUP00.CUPDTE BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
*  aadd(sqlCHAVE,"ACUP00.CUPSER <> 'ST'")
*  aadd(sqlCHAVE,"ACUP00.CUPCAN <> 'C'")

*  aadd(sqlCHAVE,"ANFE00.NFEEMP = " + str(ME_EMP, 2, 0))
*  aadd(sqlCHAVE,"ANFE00.NFECAN not in ('C','D')")
 * aadd(sqlCHAVE,"AFIS00.FISNOV not in ('2.353','1.353','1.253','1.303','1.932','2.932')")
*  aadd(sqlCHAVE,"not (ANFE00.NFENAT = 19903 and ANFE00.NFESER = 'EL')")
*  sqlrelation()


// CADASTRO DE PRODUTOS ANFE00

// 0200 CADASTRO PRODUTOS ANFE00


// FIM PRODUTOS ANFE00

// PG 45

// SOMENTE MES DE FEVEREIRO



  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"APCA00","APCA00"})
  aadd(sqlCAMPO,"ASLD00.SLDINV")
  aadd(sqlCAMPO,"ASLD00.SLDCME")
  aadd(sqlCAMPO,"PCAMAT")
  aadd(sqlCAMPO,"PCADES")
  aadd(sqlCAMPO,"PCAUNI")
  aadd(sqlCAMPO,"PCAGRP")
  aadd(sqlCAMPO,"PCAFOR")
  aadd(sqlCAMPO,"PCATRI")
  aadd(sqlCAMPO,"PCARG1")
  aadd(sqlCAMPO,"PCARG2")
  aadd(sqlCAMPO,"PCARG0")
  aadd(sqlCAMPO,"PCACSP")
  aadd(sqlCAMPO,"PCACOU")
  aadd(sqlRELATION,{"ASLD00",str(ME_EMP, 2, 0),"ASLD00.SLDEMP"})
  aadd(sqlRELATION,{"","ASLD00.SLDMAT","APCA00.PCAMAT"})
  aadd(sqlCHAVE,"PCAINV <> 'N'")
  aadd(sqlCHAVE,"ASLD00.SLDINV > 0")
  aadd(sqlCHAVE,"PCAMAT > 0")
  aadd(sqlORDEM,"PCADES")

  sqlrelation()

go top

do while !eof()

  if month(M_DATA1) # 2
    exit
  endif

  select APROD
  if !dbseek(APCA00->PCAMAT)
    append blank
    replace NFSMAT with APCA00->PCAMAT

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

  endif

  select APCA00

  msw("* * * PROCESSANDO PRODUTOS:" + str(PCAMAT,6) + " * * *")

  skip

enddo


QDE_0190 = 0

for ABC = 1 to len(aUnidade)
  do case
    case alltrim(aUnidade[ABC]) == "PCT"
      ? "|0190|PCT|PACOTE|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "EN"
      ? "|0190|EN|ENVELOPE|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "CT"
      ? "|0190|CT|CARTELA|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "SC"
      ? "|0190|SC|SACHE|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "KIT"
      ? "|0190|KIT|CONJUNTO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "GL"
      ? "|0190|GL|GALAO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "FC"
      ? "|0190|FC|FRASCO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "AMP"
      ? "|0190|AMP|AMPOLA|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "PAR"
      ? "|0190|PAR|PARES|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "LA"
      ? "|0190|LA|LATA|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "RL"
      ? "|0190|RL|ROLO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "TB"
      ? "|0190|TB|TUBO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "ENV"
      ? "|0190|ENV|ENVELOPE|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "FR"
      ? "|0190|FR|FRASCO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "PR"
      ? "|0190|PR|PAR|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "BL"
      ? "|0190|BL|BLOCO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "BR"
      ? "|0190|BR|BARRA|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "CX"
      ? "|0190|CX|CAIXA|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "JG"
      ? "|0190|JG|JOGO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "KG"
      ? "|0190|KG|KILO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "LT"
      ? "|0190|LT|LITRO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "MT"
      ? "|0190|MT|METRO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "MT2"
      ? "|0190|MT2|METRO QUADRADO|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "PC"
      ? "|0190|PC|PECA|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "UN"
      ? "|0190|UN|UNIDADE|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
    case alltrim(aUnidade[ABC]) == "BLD"
      ? "|0190|BLD|BALDE|"
      QDE_0190 ++
      BLOCO_0 ++
      QDE_LIN ++
  endcase
next


select APROD
go top
do while !eof()
  BUSCAREGISTRO("APCA00",1,{str(APROD->NFSMAT,6,0)},"SELECT")

  select APROD

  ? "|0200|"                           // 01
  ?? alltrim(str(NFSMAT,6)) + "|"      // 02
  ?? alltrim(APCA00->PCADES) + "|"     // 03
  ?? "|"                              // 04 COD BARRA
  ?? "|"                             // 05 COD ANTERIOR ITEN
  ?? alltrim(APCA00->PCAUNI) + "|"  // 06 UNIDADE MEDIDA
  ?? "00|"  // 07 TIPO ITEM - TODOS MERCADORIA REVENDA ALTERAR
  ?? alltrim(APCA00->PCANBM) + "|" // 08 COD NCM
  ?? "|"                      // 09
  ?? "|"                // 10 COD GENERO
  ?? "|"                  // 11 COD SERVICO
  ?? alltrim(str(APCA00->PCAIC0,6)) + "|"                  // 12 ALIQUOTA ICMS
  ?? "|"

  QDE_0200 ++
  BLOCO_0 ++
  QDE_LIN ++

  skip
enddo


? "|0460|998|AJUSTE DE DOC. FISCAL|" // OBS LIVRO FISCAL
? "|0460|000002|Valor do IPI|" // OBS LIVRO FISCAL
? "|0500|01012014|01|S|11500|1.1.5.01.0000|ESTOQUE|"
? "|0500|01012014|04|S|41100|4.1.1.01.0004|DEVOLUCAO DE MERCADORIA|"
? "|0500|01012014|01|S|12300|1.2.3.02.0000|ATIVO BENS MOVEIS|"
? "|0500|01012014|04|S|30000|3.0.0.00.0000|RECEITAS|"
? "|0500|01012014|04|S|41100|4.1.1.01.0000|COMPRAS DE MERCADORIA|"
? "|0500|01012014|04|S|45100|4.5.1.01.0000|DESPESAS ADMINISTRATIVAS|"
? "|0500|01012014|04|S|45100|4.5.1.02.0000|DESPESAS COM PESSOAL ADMINISTRATIVOS|"

? "|0500|01012014|04|S|45100|1.0.0.00.0001|CADASTRAR CONTA TRANSPORTE|"
? "|0500|01012014|04|S|45100|1.0.0.00.0002|CADASTRAR CONTA TELEFONE|"

BLOCO_0 += 10

// 205 ALTERACAO DO ITEM
// 206 CODIGO PRODUTO COMBUSTIVEL
// 220 FATORES DE CONVERSAO
// 0300 CADASTRO DE BENS
// 0400 NATUREZA DE OPERACAO    ???????
// 0450 INFORMACAO COMPLEMENTAR   --  PRECISA CRIAR
// 0500 PLANO DE CONTAS CONTABEIS
// 0600 CENTRO DE CUSTO
// 0990 ENCERRAMENTO DO BLOCO 0

? "|0990|" + alltrim(str(BLOCO_0+1,10)) + "|"  // QUANTIDADE DE LINHAS BLOCO 0

QDE_0990 = 1
BLOCO_C = 0
QDE_LIN ++


? "|B001|1|"  // BLOCO COM DADOS INFORMADOS
? "|B990|2|"  // BLOCO COM DADOS INFORMADOS
? "|C001|0|"  // BLOCO COM DADOS INFORMADOS

QDE_C001 = 1
QDE_LIN ++
BLOCO_C ++

M_200 = {}
aadd(M_200,{0,0,0,0,0,0,0,0,0,0,0,0})
M_210 = { }
aadd(M_210,{0,0,0,0,0,0,0,0,0,0,0,0})
M_400 = { }
M_410 = { }

aSUBTRIB = { }

  // REGISTRO C100 NOTA FISCAL

TOTBASPIS = 0
TOTBASCOF = 0
VL_REC_BRT = 0
M_TOTVPIS = 0
M_TOTVCOF = 0
M_NFSISE = 0
M_NFSBIC = 0
TOTVDA = 0

M_BASE05 = 0
M_BASE06 = 0
M_BASE52 = 0

QDE_C100 = 0
QDE_C170 = 0
QDE_C190 = 0
QDE_C195 = 0
QDE_C197 = 0

M_NFSVIC = 0

sqlRELATION = {}
sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {}
sqlORDEM = {}
aadd(sqlARQUI,{"ANFS00","ANFS00"})
aadd(sqlCAMPO,"ANFS00.*")
aadd(sqlCAMPO,"ACLI00.CLINOM")
aadd(sqlCAMPO,"ACLI00.CLICGC1")
aadd(sqlCAMPO,"ACLI00.CLIIES1")
*aadd(sqlCAMPO,"ACLI00.CLIIBGE")
aadd(sqlCAMPO,"ACLI00.CLIBAI2")
aadd(sqlCAMPO,"ACLI00.CLIEND2")
aadd(sqlCAMPO,"ACLI00.CLICDM2")
aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ANFS00.NFSCLI"})
aadd(sqlRELATION,{"AFIS00",str(ME_EMP, 2, 0),"AFIS00.FISEMP"})
aadd(sqlRELATION,{"","AFIS00.FISNOV","ANFS00.NFSNATN"})
aadd(sqlCHAVE,"ANFS00.NFSDTE BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
aadd(sqlCHAVE,"ANFS00.NFSEMP = " + str(ME_EMP, 2, 0))
*aadd(sqlCHAVE,"ANFS00.nfscan not in ('C','D')")
aadd(sqlCHAVE,"AFIS00.FISPAN <> 'N'")
aadd(sqlCHAVE,"ANFS00.NFSSER <> 'E '")
aadd(sqlCHAVE,"ANFS00.NFSNATN <> '5.933'")

sqlrelation()


  do while !eof()

    msw("Selecionando Notas Saida: C100 " + dtoc(ANFS00->NFSDTE))

    M_TOTPIS = 0
    M_TOTCOF = 0

    totpis()

    select ANFS00

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

  ? "|C100|"
  ?? "1|"     // 02 - 0=ENTRADA 1=SAIDA
  ?? "0|"     // 03 - EMISSAO PROPRIA

  if NFSCAN $ "CD"
    ?? "|" // 04 COD CLIENTE
  else
    ?? alltrim(str(NFSCLI,7)) + "|" // 04 COD CLIENTE
  endif

  ?? "55|"               // 05 MODELO NOTA FISCAL

  // 00 REGULAR
  // 02 CANCELADO
  // 06 COMPLEMENTAR
  // 04 DENEGADA

  if NFSCAN $ "C"
    ?? "02|"             // 06 00=REGULAR 02=CANCELADO
  else
    if NFSCAN $ "D"
      ?? "04|"             // 06 00=REGULAR 02=CANCELADO
    else
      if NFSCOMPLE == "S"
        ?? "06|"
      else
        ?? "00|"
      endif
    endif
  endif

  ?? "1|"                    // 07 serie obrigatorio nao
  ?? alltrim(str(NFSNUM, 6)) + "|"   // 08 NUMERO DOCUMENTO
  ?? left(NFSID,44) + "|"            // 09 CHAVE NFE

  if NFSCAN $ "CD"
    ?? "|"     // 10 EMISSAO
    ?? "|"     // 11 SAIDA OU RECEPCAO
    ?? "|" // 12 VALOR NOTA SEM DESCONTO
    ?? "|"               // 13 1=A PRAZO
    ?? "|" // 14 VALOR DESCONTO
    ?? "|"                    // 15 VALOR ABATIMENTO
    ?? "|" // 16 VALOR MERCADORIA SERVICO
    ?? "|"                 // 17 SEM COBRANCA DE FRETE
    ?? "|"                 // 18
    ?? "|"   // 19 VALOR SEGURO
    ?? "|"   // 20 OUTRAS DESPESAS
    ?? "|"    // 21 VALOR BASE ICMS
    ?? "|"    // 22 VALOR ICMS
    ?? "|"    // 23 VALOR BASE ICMS SUBSTITUICAO
    ?? "|"    // 24 VALOR ICMS SUBSTITUICAO
    ?? "|"     // 25 VALOR IPI
    ?? "|"     // 26 VALOR PIS
    ?? "|"  // 27 VALOR COFINS
    ?? "|"   // 28 PIS RETIDO
    ?? "|"   // 29 COFINS RETIDO
  else
    ?? fordata(NFSDTE) + "|"     // 10 EMISSAO
    ?? fordata(NFSDTE) + "|"     // 11 SAIDA OU RECEPCAO

    if NFSCOMPLE == "S"

      if NFSVLN > 0
        ?? forvalor(NFSVLN) + "|" // 12 VALOR NOTA SEM DESCONTO
      else
        ?? forvalor(NFSVLM) + "|" // 12 VALOR NOTA SEM DESCONTO
      endif

    else
      ?? forvalor(ANFETM->NFEVLN) + "|" // 12 VALOR NOTA SEM DESCONTO
    endif

    if NFSCPG = 1
      ?? "0|"                 // 13 0=A VISTA
    else
      ?? "1|"               // 13 1=A PRAZO
    endif
    ?? forvalor(NFSVLD) + "|" // 14 VALOR DESCONTO
    ?? "0|"                    // 15 VALOR ABATIMENTO

    if NFSCOMPLE == "S"
      ?? forvalor(0) + "|" // 16 VALOR MERCADORIA SERVICO
    else
      ?? forvalor(ANFETM->NFEVLM) + "|" // 16 VALOR MERCADORIA SERVICO
    endif

    if NFSFRE = 0
      ?? "9|"                 // 17 SEM COBRANCA DE FRETE
      ?? "0|"                 // 18
    else
      ?? "2|" // alltrim(NFSTRC) + "|"            // 17 FRETE POR CONTA
      ?? forvalor(NFSFRE) + "|"  // 18 VALOR FRETE
    endif
    ?? "0|"   // 19 VALOR SEGURO
    ?? "0|"   // 20 OUTRAS DESPESAS
    ?? forvalor(NFSBIC)  + "|"    // 21 VALOR BASE ICMS

    if NFSCOMPLE == "S"
      ?? forvalor(pcomple())  + "|"    // 22 VALOR ICMS
      select ANFS00
    else
      ?? forvalor(NFSVIC)  + "|"    // 22 VALOR ICMS
    endif


    ?? forvalor(0) + "|"    // 23 VALOR BASE ICMS SUBSTITUICAO
    ?? forvalor(ANFETM->NFEVICST) + "|"    // 24 VALOR ICMS SUBSTITUICAO

    ?? forvalor(ANFETM->NFEVIP)  + "|"     // 25 VALOR IPI


    M_NFSVIC += NFSVIC
    @ 24 , 00 say M_NFSVIC picture "999,999.99"

    ?? forvalor(M_TOTPIS)  + "|"     // 26 VALOR PIS
    ?? forvalor(M_TOTCOF)  + "|"  // 27 VALOR COFINS
    ?? "0|"   // 28 PIS RETIDO
    ?? "0|"   // 29 COFINS RETIDO

  endif

  QDE_C100 ++
  BLOCO_C ++
  QDE_LIN ++

  if !ANFS00->NFSCAN $ "CD"

    nVALNFS = 0

    reg170("NOTA")

  endif

  select ANFS00

  skip

enddo



*************************
* SAT ELETRONICO
*************************

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}
  aadd(sqlARQUI,{"ACUP00","ACUP00"})
  aadd(sqlCAMPO,"ACUP00.CUPCAN")
  aadd(sqlCAMPO,"ACUP00.CUPVLN")
  aadd(sqlCAMPO,"ACUP00.CUPCPG")
  aadd(sqlCAMPO,"ACUP00.CUPDSC")
  aadd(sqlCAMPO,"ACUP00.CUPNUM")
  aadd(sqlCAMPO,"ACUP00.CUPDTE")
  aadd(sqlCAMPO,"ACUP00.CUPTRN")
  aadd(sqlCAMPO,"ACUP00.CUPHS6")
 * aadd(sqlCAMPO,"ACUP01.CUPMAT")
 * aadd(sqlCAMPO,"APCA00.PCAUNI")

  aadd(sqlRELATION,{"AFIS00",str(ME_EMP, 2, 0),"AFIS00.FISEMP"})
  aadd(sqlRELATION,{"","AFIS00.FISNOV","ACUP00.CUPNATN"})
*  aadd(sqlRELATION,{"ACUP01","ACUP01.CUPEMP","ACUP00.CUPEMP"})
*  aadd(sqlRELATION,{"","ACUP01.CUPNUM","ACUP00.CUPNUM"})
*  aadd(sqlRELATION,{"","ACUP01.CUPSER","ACUP00.CUPSER"})
*  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","ACUP01.CUPMAT"})

  aadd(sqlCHAVE,"ACUP00.CUPDTE BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
  aadd(sqlCHAVE,"ACUP00.CUPSER <> 'ST'")
*  aadd(sqlCHAVE,"ACUP00.CUPCAN <> 'C'")

  aadd(sqlCHAVE,"ACUP00.CUPEMP = " + str(ME_EMP, 2, 0))
*  aadd(sqlCHAVE,"ANFE00.NFECAN not in ('C','D')")
*  aadd(sqlCHAVE,"AFIS00.FISNOV not in ('2.353','1.353','1.253','1.303','1.932','2.932')")
*  aadd(sqlCHAVE,"not (ANFE00.NFENAT = 19903 and ANFE00.NFESER = 'EL')")
  sqlrelation()


  */*/*/
  do while !eof()

    msw("Selecionando Sat Saida: C100 " + dtoc(ACUP00->CUPDTE))

    M_TOTPIS = 0
    M_TOTCOF = 0

    if ACUP00->CUPNUM = 8634
      altd()
    endif

    totpissat()

    select ACUP00

    if inkey() = 27
      if suspro()
        lCancelou = .t.
        msg("* * * PROCESSO SUSPENSO * * *")
        select ACUP00
        go bottom
        skip
        loop
      endif
    endif

  // REGISTRO C100 NOTA FISCAL

  ? "|C100|"
  ?? "1|"     // 02 - 0=ENTRADA 1=SAIDA
  ?? "0|"     // 03 - EMISSAO PROPRIA
  ?? "|" // 04 COD CLIENTE


* if CUPCAN $ "CD"
*   ?? "|" // 04 COD CLIENTE
* else
*   ?? alltrim(str(CUPCLI,7)) + "|" // 04 COD CLIENTE
* endif

  ?? "65|"               // 05 MODELO NOTA FISCAL

  // 00 REGULAR
  // 02 CANCELADO
  // 06 COMPLEMENTAR
  // 04 DENEGADA

  if CUPCAN $ "C"
    ?? "02|"             // 06 00=REGULAR 02=CANCELADO
  else
    if CUPCAN $ "D"
      ?? "04|"             // 06 00=REGULAR 02=CANCELADO
    else
      ?? "00|"
    endif
  endif

  ?? "1|"                    // 07 serie obrigatorio nao
  ?? alltrim(str(CUPNUM, 6)) + "|"   // 08 NUMERO DOCUMENTO
  ?? left(CUPHS6,44) + "|"            // 09 CHAVE NFE

  if CUPCAN $ "CD"
    ?? "|"     // 10 EMISSAO
    ?? "|"     // 11 SAIDA OU RECEPCAO
    ?? "|" // 12 VALOR NOTA SEM DESCONTO
    ?? "|"               // 13 1=A PRAZO
    ?? "|" // 14 VALOR DESCONTO
    ?? "|"                    // 15 VALOR ABATIMENTO
    ?? "|" // 16 VALOR MERCADORIA SERVICO
    ?? "|"                 // 17 SEM COBRANCA DE FRETE
    ?? "|"                 // 18
    ?? "|"   // 19 VALOR SEGURO
    ?? "|"   // 20 OUTRAS DESPESAS
    ?? "|"    // 21 VALOR BASE ICMS
    ?? "|"    // 22 VALOR ICMS
    ?? "|"    // 23 VALOR BASE ICMS SUBSTITUICAO
    ?? "|"    // 24 VALOR ICMS SUBSTITUICAO
    ?? "|"     // 25 VALOR IPI
    ?? "|"     // 26 VALOR PIS
    ?? "|"  // 27 VALOR COFINS
    ?? "|"   // 28 PIS RETIDO
    ?? "|"   // 29 COFINS RETIDO
  else
    ?? fordata(CUPDTE) + "|"     // 10 EMISSAO
    ?? fordata(CUPDTE) + "|"     // 11 SAIDA OU RECEPCAO
    ?? forvalor(ANFETM->NFEVLN) + "|" // 12 VALOR NOTA SEM DESCONTO

    if CUPCPG = 1
      ?? "0|"                 // 13 0=A VISTA
    else
      ?? "1|"               // 13 1=A PRAZO
    endif
    ?? forvalor(CUPDSC) + "|" // 14 VALOR DESCONTO
    ?? "0|"                    // 15 VALOR ABATIMENTO
    ?? forvalor(ANFETM->NFEVLM) + "|" // 16 VALOR MERCADORIA SERVICO
    ?? "9|"                 // 17 SEM COBRANCA DE FRETE
    ?? "0|"                 // 18
    ?? "0|"   // 19 VALOR SEGURO
    ?? "0|"   // 20 OUTRAS DESPESAS
    ?? forvalor(ANFETM->NFEBIC)  + "|"    // 21 VALOR BASE ICMS
    ?? forvalor(ANFETM->NFEVIC)  + "|"    // 22 VALOR ICMS
    ?? "|"    // 23 VALOR BASE ICMS SUBSTITUICAO
    ?? "|"    // 24 VALOR ICMS SUBSTITUICAO
    ?? "|"     // 25 VALOR IPI

    M_NFSVIC += ANFETM->NFEVIC
    @ 24 , 00 say M_NFSVIC picture "999,999.99"

    ?? "|"     // 26 VALOR PIS
    ?? "|"  // 27 VALOR COFINS
    ?? "|"   // 28 PIS RETIDO
    ?? "|"   // 29 COFINS RETIDO

  endif

  QDE_C100 ++
  BLOCO_C ++
  QDE_LIN ++

  if !ACUP00->CUPCAN $ "CD"
    nVALNFS = 0

    if ACUP00->CUPNUM = 8634
      altd()
    endif
    
    reg170("CUPOM")

  endif

  select ACUP00

  skip

enddo



*************************
// NOTAS FISCAIS ENTRADAS
*************************

TOTBASPIS = 0
TOTBASCOF = 0
VL_REC_BRT = 0
M_TOTVPIS = 0
M_TOTVCOF = 0
M_NFSISE = 0
M_NFSBIC = 0
TOTVDA = 0

M_BASE05 = 0
M_BASE06 = 0
M_BASE52 = 0

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}
  aadd(sqlARQUI,{"ANFE00","ANFE00"})
  aadd(sqlCAMPO,"ANFE00.*")
  aadd(sqlCAMPO,"ANFE00.NFEFOR")
  aadd(sqlCAMPO,"AFOR00.FORNOM")
  aadd(sqlCAMPO,"AFOR00.FORCGC")
  aadd(sqlCAMPO,"AFOR00.FORIES")
*  aadd(sqlCAMPO,"AFOR00.FORIBGE")
  aadd(sqlCAMPO,"AFOR00.FORBAI")
  aadd(sqlCAMPO,"AFOR00.FOREND")
  aadd(sqlCAMPO,"AFOR00.FORCDM")
  aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","ANFE00.NFEFOR"})
  aadd(sqlRELATION,{"AFIS00",str(ME_EMP, 2, 0),"AFIS00.FISEMP"})
  aadd(sqlRELATION,{"","AFIS00.FISNOV","ANFE00.NFENATN"})
  aadd(sqlCHAVE,"ANFE00.NFEDTR BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
  aadd(sqlCHAVE,"ANFE00.NFEEMP = " + str(ME_EMP, 2, 0))
*  aadd(sqlCHAVE,"ANFE00.NFECAN not in ('C','D')")
  aadd(sqlCHAVE,"AFIS00.FISPAN <> 'N'")
  aadd(sqlCHAVE,"ANFE00.NFENATN not in ('2.353','1.353','1.253','1.303')")
  sqlrelation()

  do while !eof()

    msw("Selecionando Notas Entradas: C100 " + dtoc(ANFE00->NFEDTR))

  // REGISTRO C100 NOTA FISCAL

  ? "|C100|"
  ?? "0|"     // 02 - 0=ENTRADA 1=SAIDA
  ?? "1|"     // 1 - EMISSAO TERCEIRO
  ?? alltrim("F"+alltrim(str(NFEFOR,7))) + "|" // 04 COD CLIENTE

  if len(alltrim(NFSID)) > 0
    ?? "55|"               // 05 MODELO NOTA FISCAL
  else
    if ANFE00->NFEMOD # 0
      ?? strzero(ANFE00->NFEMOD,2) + "|"               // 05 MODELO NOTA FISCAL
    else
      ?? strzero(1,2) + "|"               // 05 MODELO NOTA FISCAL
    endif
  endif

  // 00 REGULAR
  // 02 CANCELADO
  // 06 COMPLEMENTAR
  // 04 DENEGADA

  ?? "00|"

  if ANFE00->NFESER1 == "---"
    ?? "|"
  else
    if ANFE00->NFESER == "EL"
      ?? "1|"
    else
      ?? alltrim(iif(!empty(ANFE00->NFESER1),ANFE00->NFESER1,ANFE00->NFESER)) + "|"   // 07 serie obrigatorio nao
    endif
  endif

  ?? alltrim(str(iif(ANFE00->NFENUM1 > 0,ANFE00->NFENUM1,ANFE00->NFENUM), 9)) + "|"   // 08 NUMERO DOCUMENTO

  M_DIG = ""
  if len(alltrim(ANFE00->NFSID)) = 43
    M_DIG = mod11_nfe(alltrim(ANFE00->NFSID))
  endif

  ?? alltrim(left(NFSID,44)) + M_DIG + "|"            // 09 CHAVE NFE

  ?? fordata(NFEDTE) + "|"     // 10 EMISSAO
  ?? fordata(NFEDTR) + "|"     // 11 SAIDA OU RECEPCAO
  ?? forvalor(NFEVLM-NFEDSC+NFESUB+NFEVIP+NFEDST+NFEFRE) + "|" // 12 VALOR NOTA SEM DESCONTO

  if NFEPSN == "N"
    ?? "2|"                 // 13 0=A VISTA
  else
    if NFEDTE == NFEVC1 .and. NFEDP2 = 0  // A VISTA
      ?? "0|"                 // 13 0=A VISTA
    else
      ?? "1|"               // 13 1=A PRAZO
    endif
  endif

  ?? forvalor(NFEDSC) + "|" // 14 VALOR DESCONTO
  ?? "0|"                    // 15 VALOR ABATIMENTO
  ?? forvalor(NFEVLM+NFEFRE+NFEVIP) + "|" // 16 VALOR MERCADORIA SERVICO

  if NFEFRE = 0
    ?? "9|"                 // 17 SEM COBRANCA DE FRETE
    ?? "0|"                 // 18
  else
    ?? "1|"            // 17 FRETE POR CONTA
    ?? forvalor(NFEFRE) + "|"  // 18 VALOR FRETE
  endif

  ?? "0|"   // 19 VALOR SEGURO
  ?? forvalor(NFEDST) + "|"   // 20 OUTRAS DESPESAS
  ?? forvalor(NFEBIC)  + "|"    // 21 VALOR BASE ICMS
  ?? forvalor(NFEVIC)  + "|"    // 22 VALOR ICMS
  ?? forvalor(0) + "|"    // 23 VALOR BASE ICMS SUBSTITUICAO
*  ?? forvalor(NFESUB) + "|"    // 24 VALOR ICMS SUBSTITUICAO
  ?? forvalor(0) + "|"    // 24 VALOR ICMS SUBSTITUICAO
  ?? forvalor(0)  + "|"     // 25 VALOR IPI

  M_TOTPIS = 0
  M_TOTCOF = 0

  ?? forvalor(M_TOTPIS)  + "|"     // 26 VALOR PIS
  ?? forvalor(M_TOTCOF)  + "|"  // 27 VALOR COFINS
  ?? "0|"   // 28 PIS RETIDO
  ?? "0|"   // 29 COFINS RETIDO

  QDE_C100 ++
  BLOCO_C ++
  QDE_LIN ++

  reg170e()

  select ANFE00

  skip

enddo

*****************************
// FIM NOTA FISCAL ENTRADA
***************************

QDE_C400 = 0
QDE_C405 = 0
QDE_C410 = 0
QDE_C420 = 0
QDE_C425 = 0
QDE_C460 = 0
QDE_C470 = 0
QDE_C490 = 0
QDE_C800 = 0
QDE_C850 = 0
QDE_C860 = 0
QDE_C890 = 0

lRec460 = 0

M_VALPIS = 0
M_VALCOF = 0

*****************************
// ENERGIA ELETRICA
***************************

  QDE_C500 = 0
  QDE_C510 = 0
  QDE_C590 = 0

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}
  aadd(sqlARQUI,{"ANFE00","ANFE00"})
  aadd(sqlCAMPO,"ANFE00.*")
  aadd(sqlCAMPO,"AFOR00.FORNOM")
  aadd(sqlCAMPO,"AFOR00.FORCGC")
  aadd(sqlCAMPO,"AFOR00.FORIES")
*  aadd(sqlCAMPO,"AFOR00.FORIBGE")
  aadd(sqlCAMPO,"AFOR00.FORBAI")
  aadd(sqlCAMPO,"AFOR00.FOREND")
  aadd(sqlCAMPO,"AFOR00.FORCDM")
  aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","ANFE00.NFEFOR"})
  aadd(sqlRELATION,{"AFIS00",str(ME_EMP, 2, 0),"AFIS00.FISEMP"})
  aadd(sqlRELATION,{"","AFIS00.FISNOV","ANFE00.NFENATN"})
  aadd(sqlCHAVE,"ANFE00.NFEDTR BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
  aadd(sqlCHAVE,"ANFE00.NFEEMP = " + str(ME_EMP, 2, 0))
*  aadd(sqlCHAVE,"ANFE00.NFECAN not in ('C','D')")
  aadd(sqlCHAVE,"AFIS00.FISPAN <> 'N'")
  aadd(sqlCHAVE,"ANFE00.NFENATN in ('1.253')")
  sqlrelation()

  do while !eof()

    msw("Selecionando Notas Energia Eletrica: C100 " + dtoc(ANFE00->NFEDTR))

    ? "|C500|"  // 01
    ?? "0|"     // 02 - 0=AQUISICAO
    ?? "1|"     // 03 - 1-TERCEIROS
    ?? "F" + alltrim(str(NFEFOR,5)) + "|" // 04 COD CLIENTE
    ?? "06|"    // 05 MODELO NOTA FISCAL

    QDE_C500 ++
    BLOCO_C ++
    QDE_LIN ++

    ?? "00|"   // 06

    if NFESER == "---"
      ?? "|"
    else
      if NFESER == "EL"
        ?? "1 "
      else
        ?? alltrim(NFESER) + "|"   // 07 serie obrigatorio nao
      endif
    endif

    ?? "|"                             // 08 -sub-serie
    ?? "01|"                           // 09 - CLASSE DE CONSUMO
    ?? alltrim(str(NFENUM, 9)) + "|"   // 10 NUMERO DOCUMENTO
    ?? fordata(NFEDTE) + "|"           // 11 EMISSAO
    ?? fordata(NFEDTR) + "|"           // 12 SAIDA OU RECEPCAO
    ?? forvalor(NFEVLN) + "|"  // 13 VALOR TOTAL
    ?? forvalor(NFEDSC) + "|"  // 14 VALOR NOTA SEM DESCONTO
    ?? forvalor(NFEVLN) + "|"  // 15 VALOR CONSUMIDO
    ?? forvalor(NFEVLN) + "|"  // 16 VALOR NAO TRIBUTADO
    ?? forvalor(0)  + "|" // 17
    ?? forvalor(0)  + "|" // 18 DESPESAS
    ?? forvalor(NFEBIC)  + "|" // 19 VALOR BASE
    ?? forvalor(NFEVIC)  + "|" // 20 VALOR ICMS
    ?? forvalor(0)       + "|" // 21 VALOR NAO TRIBUTADO
    ?? forvalor(0)       + "|" // 22
    ?? "|" // 23
    ?? forvalor(0)       + "|" // 24 VALOR PIS
    ?? forvalor(0)       + "|" // 25 VALOR COFINS
    ?? "3|" // 26 TRIFASICO
    ?? "|" // 27 CODIGO TENSAO
    ?? alltrim(NFSID) + "|" // 28
    ?? "|" // 29 NORMAL
    ?? "|" // 30
    ?? "|" // 31
    ?? "|"
    ?? "4.5.1.01.0000016||||||||"

    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}
    aadd(sqlARQUI,{"ANFE01","ANFE01"})
    aadd(sqlCAMPO,"ANFE01.NFEPIC")
    aadd(sqlCAMPO,"ANFE01.NFELIQ")
    aadd(sqlCAMPO,"ANFE01.NFEBIC")
    aadd(sqlCAMPO,"ANFE01.NFEVIC")
    aadd(sqlCAMPO,"ANFE01.NFENATN")
    aadd(sqlCHAVE, "ANFE01.NFEEMP = " + str(ANFE00->NFEEMP,2) )
    aadd(sqlCHAVE, "ANFE01.NFENUM = " + str(ANFE00->NFENUM,9) )
    aadd(sqlCHAVE, "ANFE01.NFESER = " + aspas(ANFE00->NFESER) )
    aadd(sqlCHAVE, "ANFE01.NFEFOR = " + str(ANFE00->NFEFOR,5) )
    sqlrelation()

    do while !eof()

      M_NFENAT = alltrim(tira_pto(NFENATN))

      if M_NFENAT == ""
        M_NFENAT = alltrim(tira_pto(ANFE00->NFENATN))
      endif

      ? "|C590|090|"  // 01 e 02
      ?? M_NFENAT + "|" // 03
      ?? forvalor(NFEPIC) + "|"         // 12
      ?? forvalor(NFELIQ) + "|"         // 13
      ?? forvalor(NFEBIC) + "|"         // 13
      ?? forvalor(NFEVIC) + "|"         // 13
      ?? "0|" // 14
      ?? "0|"  // 15
      ?? "0|"                    // 17
      ?? "|"                     // 18

      M_ICMENTRA += NFEVIC

      QDE_C590 ++
      BLOCO_C ++
      QDE_LIN ++

      skip

    enddo

    select ANFE00
    skip
  enddo

if ME_EMP = 1
  M_SERSAT = "000151082"
else
  M_SERSAT = "001128938"
endif


M_MESANO = str(year(M_DATA1),4) + strzero(month(M_DATA1),2)
M_ANOMES = STR(year(M_DATA1),4) + strzero(month(M_DATA1),2)
mArquivo   := '*.XML'

cDirCanc := "C:\CIRUR\ENVIADO\SAT\Cancelamentos\" + M_ANOMES + "\*.XML"
cDirSpec := "C:\CIRUR\ENVIADO\SAT\Vendas\" + M_ANOMES + "\*.XML"

mDiretorio := "C:\CIRUR\ENVIADO\SAT\Vendas\" + M_ANOMES + "\"
mDireCanc  := "C:\CIRUR\ENVIADO\SAT\Cancelamentos\" + M_ANOMES + "\"

mListaArq  := Directory(cDirSpec)
mListaCan  := Directory(cDirCanc)

aCanc = ""

for ABC = 1 to len(mListaCan)
  Linha := Memoread(mDireCanc + mListaCan[ABC][1])
  nPos1 := At('chCanc="CFe',Linha)
  nPos1 := nPos1+Len('chCanc="CFe')
  cChave:= Substr(Linha,nPos1,44)
  aCanc += "#" + cChave + "#"
next

M_SATBRU = 0
M_SATDSC = 0
M_SATLIQ = 0

for ABC = 1 to len(mListaArq)

  select C870
  zap

  setcolor("w+/N")
    @ 24, 0 say mListaArq[ABC][1] + " " + str((ABC/len(mListaArq))*100,7,2)
  setcolor("")

  nSersat := Memoread(mDiretorio + mListaArq[ABC][1])

  if !"nserieSAT>" + M_SERSAT $ nSersat
    loop
  endif

  le_sat(mDiretorio + mListaArq[ABC][1])

  if substr(mListaArq[ABC][1],3,44) $ aCanc
    ? "|C800|"
    ?? "59|"
    ?? "02|"             // 06 00=REGULAR 02=CANCELADO
    ?? substr(mListaArq[ABC][1],34,6) + "|"
    ?? "|"     // 10 EMISSAO
    ?? "|" // 12 VALOR NOTA SEM DESCONTO
    ?? "|" // 12 VALOR NOTA SEM DESCONTO
    ??  "|" // 12 VALOR NOTA SEM DESCONTO
    ??  "|"
    ?? M_SERSAT + "|"
    ?? substr(mListaArq[ABC][1],3,44) + "|"
    ?? "|" // 12 VALOR NOTA SEM DESCONTO
    ?? "|" // 12 VALOR NOTA SEM DESCONTO
    ??  "|" // 12 VALOR NOTA SEM DESCONTO
    ??  "|" // 12 VALOR NOTA SEM DESCONTO
    ??  "|" // 12 VALOR NOTA SEM DESCONTO
    ??  "|" // 12 VALOR NOTA SEM DESCONTO
    QDE_C800 ++
    loop
  endif

  M_SATBRU += ANFETM->NFEVLM
  M_SATDSC += ANFETM->NFEDSC
  M_SATLIQ += ANFETM->NFEVLM-ANFETM->NFEDSC

  @ 10,20 say "Bruto   : " + str(M_SATBRU,12,2)
  @ 11,20 say "Desconto: " + str(M_SATDSC,12,2)
  @ 12,20 say "Liquido : " + str(M_SATLIQ,12,2)

  ? "|C800|"
  ?? "59|"
  ?? "00|"
  ?? alltrim(str(ANFETM->NFENUM, 9)) + "|"   // 10 NUMERO DOCUMENTO
  ?? fordata(ANFETM->NFEDTE) + "|"     // 10 EMISSAO
  ?? forvalor(ANFETM->NFEVLM-ANFETM->NFEDSC) + "|" // 12 VALOR NOTA SEM DESCONTO
  ?? forvalor(0) + "|" // 12 VALOR NOTA SEM DESCONTO
  ?? forvalor(0) + "|" // 12 VALOR NOTA SEM DESCONTO
  ?? alltrim(ANFETM->NFSUSU) + "|"  //
  ?? M_SERSAT + "|"
  ?? substr(mListaArq[ABC][1],3,44) + "|"
  ?? forvalor(ANFETM->NFEDSC) + "|" // 12 VALOR NOTA SEM DESCONTO
  ?? forvalor(ANFETM->NFEVLM) + "|" // 12 VALOR NOTA SEM DESCONTO
  ?? forvalor(0) + "|" // 12 VALOR NOTA SEM DESCONTO
  ?? forvalor(ANFETM->NFEVIC) + "|" // 12 VALOR NOTA SEM DESCONTO
  ?? forvalor(0) + "|" // 12 VALOR NOTA SEM DESCONTO
  ?? forvalor(0) + "|" // 12 VALOR NOTA SEM DESCONTO

  QDE_C800 ++
  BLOCO_C ++
  QDE_LIN ++

  select C870
  go top

  do while !eof()

    QDE_C850 ++
    BLOCO_C ++
    QDE_LIN ++

    ? "|C850|"
    ?? CST + "|"
    ?? CFOP + "|"
    ?? forvalor(ALIQ_ICMS) + "|" // 12 VALOR NOTA SEM DESCONTO
    ?? forvalor(VLR_OPR) + "|" // 12 VALOR NOTA SEM DESCONTO
    ?? forvalor(BC_ICMS) + "|" // 12 VALOR NOTA SEM DESCONTO
    ?? forvalor(VLR_ICMS) + "|" // 12 VALOR NOTA SEM DESCONTO
    ?? "|"

    skip

  enddo

next

? "|C990|" + alltrim(str(BLOCO_C+1,10)) + "|"  // QUANTIDADE DE LINHAS BLOCO 0
? "|D001|0|"

*****************************
// CONHECIMENTO DE TRANSPORTE
***************************

  QDE_D100 = 0
  QDE_D190 = 0
  BLOCO_D = 0

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}
  aadd(sqlARQUI,{"ANFE00","ANFE00"})
  aadd(sqlCAMPO,"ANFE00.*")
  aadd(sqlCAMPO,"AFOR00.FORNOM")
  aadd(sqlCAMPO,"AFOR00.FORCGC")
  aadd(sqlCAMPO,"AFOR00.FORIES")
*  aadd(sqlCAMPO,"AFOR00.FORIBGE")
  aadd(sqlCAMPO,"AFOR00.FORBAI")
  aadd(sqlCAMPO,"AFOR00.FOREND")
  aadd(sqlCAMPO,"AFOR00.FORCDM")
  aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","ANFE00.NFEFOR"})
  aadd(sqlRELATION,{"AFIS00",str(ME_EMP, 2, 0),"AFIS00.FISEMP"})
  aadd(sqlRELATION,{"","AFIS00.FISNOV","ANFE00.NFENATN"})
  aadd(sqlCHAVE,"ANFE00.NFEDTR BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
  aadd(sqlCHAVE,"ANFE00.NFEEMP = " + str(ME_EMP, 2, 0))
*  aadd(sqlCHAVE,"ANFE00.NFECAN not in ('C','D')")
  aadd(sqlCHAVE,"AFIS00.FISPAN <> 'N'")
  aadd(sqlCHAVE,"ANFE00.NFENATN in ('2.353','1.353')")
  sqlrelation()

  do while !eof()

    msw("Selecionando Notas Conhecimento: C100 " + dtoc(ANFE00->NFEDTR))

    ? "|D100|"  // 01
    ?? "0|"     // 02 - 0=AQUISICAO
    ?? "1|"     // 03 - 1-TERCEIROS
    ?? "F" + alltrim(str(NFEFOR,7)) + "|" // 04 COD CLIENTE

    if ANFE00->NFEMOD > 0
      ?? strzero(ANFE00->NFEMOD,2) + "|"               // 05 MODELO NOTA FISCAL
    else
      if !empty(ANFE00->NFSID)
        ?? substr(ANFE00->NFSID,21,2) + "|"    // 05 MODELO NOTA FISCAL
      else
        ?? "08|"    // 05 MODELO NOTA FISCAL
      endif
    endif

    QDE_D100 ++
    BLOCO_D ++
    QDE_LIN ++

    ?? "00|"   // 06

    if ANFE00->NFESER == "---"
      ?? "|"
    else
      if ANFE00->NFESER == "EL"
        ?? "1 "
      else
        ?? alltrim(ANFE00->NFESER) + "|"   // 07 serie obrigatorio nao
      endif
    endif
    ?? "|"                             // 08 -sub-serie

    ?? substr(NFSID,26,9) + "|"

    ?? alltrim(NFSID) + "|"            // 10 CHAVE NFE

    ?? fordata(NFEDTE) + "|"  // 11 EMISSAO
    ?? fordata(NFEDTR) + "|"  // 12 SAIDA OU RECEPCAO

    if ANFE00->NFEMOD > 0
      ?? "0|"                   // 13 TIPO 0=NORMAL
    else
      ?? "|"                   // 13 TIPO 0=NORMAL
    endif

    ?? "|"                    // 14 EM BRANCO
    ?? forvalor(NFEVLM) + "|" // 15 VALOR NOTA SEM DESCONTO
    ?? forvalor(NFEDSC) + "|" // 16 VALOR DESCONTO
    ?? "1|"                    // 17 TIPO
    ?? forvalor(NFEVLM)  + "|" // 18 VALOR MERCADORIA SERVICO
    ?? forvalor(NFEBIC)  + "|" // 19 VALOR BASE ICMS
    ?? forvalor(NFEVIC)  + "|" // 20 VALOR ICMS
    ?? forvalor(0)       + "|" // 21 VALOR NAO TRIBUTADO
    ?? "|" // 22
    ?? "1.0.0.00.0001|" // 37
    ?? alltrim(ANFE00->NFEMUNR) + "|" + alltrim(ANFE00->NFEMUND) + "|"

    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}
    aadd(sqlARQUI,{"ANFE01","ANFE01"})
    aadd(sqlCAMPO,"ANFE01.NFEPIC")
    aadd(sqlCAMPO,"ANFE01.NFELIQ")
    aadd(sqlCAMPO,"ANFE01.NFEVLI")
    aadd(sqlCAMPO,"ANFE01.NFEBIC")
    aadd(sqlCAMPO,"ANFE01.NFEVIC")
    aadd(sqlCAMPO,"ANFE01.NFENATN")
    aadd(sqlCHAVE, "ANFE01.NFEEMP = " + str(ANFE00->NFEEMP,2) )
    aadd(sqlCHAVE, "ANFE01.NFENUM = " + str(ANFE00->NFENUM,9) )
    aadd(sqlCHAVE, "ANFE01.NFESER = " + aspas(ANFE00->NFESER) )
    aadd(sqlCHAVE, "ANFE01.NFEFOR = " + str(ANFE00->NFEFOR,7) )
    sqlrelation()

    do while !eof()

      ? "|D190|"  // 01
      if NFEBIC > 0
        ?? "000|"     // 02 - TRIBUTADO
      else
        ?? "090|"     // 02 - OUTRAS
      endif

      M_NFENAT = alltrim(tira_pto(NFENATN))

      if M_NFENAT == ""
        M_NFENAT = alltrim(tira_pto(ANFE00->NFENATN))
      endif

      ?? M_NFENAT + "|"
      ?? forvalor(NFEPIC) + "|"
      ?? forvalor(NFEVLI) + "|" // 15 VALOR NOTA SEM DESCONTO
      ?? forvalor(NFEBIC) + "|" // 15 VALOR NOTA SEM DESCONTO
      ?? forvalor(NFEVIC) + "|" // 15 VALOR NOTA SEM DESCONTO
      ?? forvalor(0) + "|" // 15 VALOR NOTA SEM DESCONTO
      ?? "|"

      M_ICMENTRA += NFEVIC

      QDE_D190 ++
      BLOCO_D ++
      QDE_LIN ++

      skip

    enddo

    select ANFE00
    skip
  enddo


**************************
* TELEFONE
**************************

  QDE_D500 = 0
  QDE_D590 = 0


  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}
  aadd(sqlARQUI,{"ANFE00","ANFE00"})
  aadd(sqlCAMPO,"ANFE00.*")
  aadd(sqlCAMPO,"AFOR00.FORNOM")
  aadd(sqlCAMPO,"AFOR00.FORCGC")
  aadd(sqlCAMPO,"AFOR00.FORIES")
*  aadd(sqlCAMPO,"AFOR00.FORIBGE")
  aadd(sqlCAMPO,"AFOR00.FORBAI")
  aadd(sqlCAMPO,"AFOR00.FOREND")
  aadd(sqlCAMPO,"AFOR00.FORCDM")
  aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","ANFE00.NFEFOR"})
  aadd(sqlRELATION,{"AFIS00",str(ME_EMP, 2, 0),"AFIS00.FISEMP"})
  aadd(sqlRELATION,{"","AFIS00.FISNOV","ANFE00.NFENATN"})
  aadd(sqlCHAVE,"ANFE00.NFEDTR BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
  aadd(sqlCHAVE,"ANFE00.NFEEMP = " + str(ME_EMP, 2, 0))
*  aadd(sqlCHAVE,"ANFE00.NFECAN not in ('C','D')")
  aadd(sqlCHAVE,"AFIS00.FISPAN <> 'N'")
  aadd(sqlCHAVE,"ANFE00.NFENATN in ('1.303')")
  sqlrelation()

  do while !eof()

    msw("Selecionando Notas Telefone: C100 " + dtoc(ANFE00->NFEDTR))

    ? "|D500|"  // 01
    ?? "0|"     // 02 - 0=AQUISICAO
    ?? "1|"     // 03 - 1-TERCEIROS
    ?? "F" + alltrim(str(NFEFOR,5)) + "|" // 04 COD CLIENTE

    if ANFE00->NFEMOD > 0
      ?? strzero(ANFE00->NFEMOD,2) + "|"               // 05 MODELO NOTA FISCAL
    else
      ?? "22|"    // 05 MODELO NOTA FISCAL
    endif

    QDE_D500 ++
    BLOCO_D ++
    QDE_LIN ++

    ?? "00|"   // 06

    if ANFE00->NFESER1 == "---"
      ?? "|"
    else
      if ANFE00->NFESER == "EL"
        ?? "1 "
      else
        ?? alltrim(iif(!empty(ANFE00->NFESER1),ANFE00->NFESER1,ANFE00->NFESER)) + "|"   // 07 serie obrigatorio nao
      endif
    endif

    ?? "|"                             // 08 -sub-serie

    ?? alltrim(str(NFENUM, 9)) + "|"   // 09 NUMERO DOCUMENTO
    ?? fordata(NFEDTE) + "|"  // 10 EMISSAO
    ?? fordata(NFEDTR) + "|"  // 11 SAIDA OU RECEPCAO
    ?? forvalor(NFEVLM)  + "|" // 12 VALOR MERCADORIA SERVICO
    ?? forvalor(NFEDSC) + "|" // 13 VALOR NOTA SEM DESCONTO
    ?? forvalor(0)       + "|" // 14 VALOR NAO TRIBUTADO
    ?? forvalor(0)       + "|" // 15 VALOR NAO TRIBUTADO
    ?? forvalor(0)       + "|" // 16 VALOR NAO TRIBUTADO
    ?? forvalor(0)       + "|" // 17 VALOR NAO TRIBUTADO
    ?? forvalor(NFEBIC)  + "|" // 18 VALOR BASE ICMS
    ?? forvalor(NFEVIC)  + "|" // 19 VALOR ICMS
    ?? "|" // 20
    ?? forvalor(0) + "|" // 21 VALOR NOTA SEM DESCONTO
    ?? forvalor(0)       + "|" // 22 VALOR NAO TRIBUTADO
    ?? "1.0.0.00.0002|" // 37
    ?? "1|" // 24

    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}
    aadd(sqlARQUI,{"ANFE01","ANFE01"})
    aadd(sqlCAMPO,"ANFE01.NFEPIC")
    aadd(sqlCAMPO,"ANFE01.NFELIQ")
    aadd(sqlCAMPO,"ANFE01.NFEVLI")
    aadd(sqlCAMPO,"ANFE01.NFEBIC")
    aadd(sqlCAMPO,"ANFE01.NFEVIC")
    aadd(sqlCAMPO,"ANFE01.NFENATN")
    aadd(sqlCHAVE, "ANFE01.NFEEMP = " + str(ANFE00->NFEEMP,2) )
    aadd(sqlCHAVE, "ANFE01.NFENUM = " + str(ANFE00->NFENUM,9) )
    aadd(sqlCHAVE, "ANFE01.NFESER = " + aspas(ANFE00->NFESER) )
    aadd(sqlCHAVE, "ANFE01.NFEFOR = " + str(ANFE00->NFEFOR,7) )
    sqlrelation()

    do while !eof()

      ? "|D590|"  // 01
      if NFEBIC > 0
        ?? "000|"     // 02 - TRIBUTADO
      else
        ?? "090|"     // 02 - OUTRAS

      endif

      M_NFENAT = alltrim(tira_pto(NFENATN))

      if M_NFENAT == ""
        M_NFENAT = alltrim(tira_pto(ANFE00->NFENATN))
      endif

      ?? M_NFENAT + "|"  // 03
      ?? forvalor(NFEPIC) + "|"          // 04
      ?? forvalor(NFEVLI) + "|" // 05
      ?? forvalor(NFEBIC) + "|" // 06
      ?? forvalor(NFEVIC) + "|" // 07
      ?? forvalor(0) + "|" // 08
      ?? forvalor(0) + "|" // 09
      ?? forvalor(0) + "|" // 10
      ?? "|"

      M_ICMENTRA += NFEVIC

      QDE_D590 ++
      BLOCO_D ++
      QDE_LIN ++

      skip

    enddo

    select ANFE00
    skip
  enddo


? "|D990|" + alltrim(str(BLOCO_D+2,10)) + "|"  // QUANTIDADE DE LINHAS BLOCO 0


BLOCO_E = 0

*? "|M200|0|0|0|0|0|0|0|" + forvalor(M_TOTVPIS) + "|0|0|" + forvalor(M_TOTVPIS) + "|"+ forvalor(M_TOTVPIS) + "|"
*? "|M210|52|" + forvalor(M_BASE52) + "|" + forvalor(M_BASE52) + "|0,65|0||" + forvalor(M_TOTVPIS) + "|0|0|0|0|" + forvalor(M_TOTVPIS) + "|"

*? "|M400|05|"+ forvalor(M_BASE05) +"|||"
*? "|M410|101|"+ forvalor(M_BASE05) +"|||"
*? "|M400|06|"+ forvalor(M_BASE06) +"|||"
*? "|M410|101|"+ forvalor(M_BASE06) +"|||"

*? "|M600|0|0|0|0|0|0|0|" + forvalor(M_TOTVCOF) + "|0|0|" + forvalor(M_TOTVCOF) + "|"+ forvalor(M_TOTVCOF) + "|"
*? "|M610|52|" + forvalor(M_BASE52) + "|" + forvalor(M_BASE52) + "|3|0||" + forvalor(M_TOTVCOF) + "|0|0|0|0|" + forvalor(M_TOTVCOF) + "|"

*? "|M800|05|"+ forvalor(M_BASE05) +"|||"
*? "|M810|101|"+ forvalor(M_BASE05) +"|||"
*? "|M800|06|"+ forvalor(M_BASE06) +"|||"
*? "|M810|101|"+ forvalor(M_BASE06) +"|||"
*? "|M990|6|"

? "|E001|0|"  // APURACAO DO ICMS
? "|E100|"  // APURACAO DO ICMS
?? fordata(M_DATA1) + "|"
?? fordata(M_DATA2) + "|"

BLOCO_E += 2

? "|E110|"  // APURACAO DO ICMS
?? forvalor(M_ICMSAIDA) + "|" // 02 VL_TOT_DEBITOS
?? forvalor(0) + "|"          // 03 VL_AJ_DEBITOS
?? forvalor(0) + "|"          // 04 VL_TOT_AJ_DEBITOS
?? forvalor(0) + "|"          // 05 VL_ESTORNOS_CRED
?? forvalor(M_ICMENTRA) + "|" // 06 VL_TOT_CREDITOS
?? forvalor(0) + "|"          // 07 VL_AJ_CREDITOS
?? forvalor(0) + "|"          // 08 VL_TOT_AJ_CREDITOS
?? forvalor(0) + "|"          // 09 VL_ESTORNO_DEB
?? forvalor(0) + "|"          // 10 VL_SLD_CREDOR_ANT

BLOCO_E ++


if M_ICMSAIDA-M_ICMENTRA > 0
  ?? forvalor(M_ICMSAIDA-M_ICMENTRA) + "|" // 11 VALOR APURADO
else
  ?? forvalor(0) + "|" // 11 VALOR APURADO
endif

?? forvalor(0) + "|" // 12 VLR_TOT_DED

if M_ICMSAIDA-M_ICMENTRA > 0
  ?? forvalor(M_ICMSAIDA-M_ICMENTRA) + "|" // 13 VALOR A RECOLHER
else
  ?? forvalor(0) + "|" // 11 VALOR APURADO
endif

if M_ICMENTRA > M_ICMSAIDA
  ?? forvalor(M_ICMENTRA-M_ICMSAIDA) + "|" // 14
else
  ?? forvalor(0)       + "|" // 14
endif
?? forvalor(0)       + "|" // 15

M_DATPG = lastday(M_DATA1) + 20

if dow(M_DATPG) = 2
  M_DATPG -= 2
endif

if dow(M_DATPG)= 7
  M_DATPG -= 1
endif


? "|E116|000|"  // APURACAO DO ICMS
BLOCO_E ++

if M_ICMSAIDA-M_ICMENTRA > 0
  ?? forvalor(M_ICMSAIDA-M_ICMENTRA) + "|" // 03 VL_TOT_DEBITOS
else
  ?? forvalor(0)       + "|"
endif

?? fordata(M_DATPG) + "|"   // 04
?? "046-2|"                 // 05
?? "|"    // 06 VL_AJ_DEBITOS
?? "|"    // 07 VL_TOT_AJ_DEBITOS
?? "|"    // 08 VL_ESTORNOS_CRED
?? "|"    // 09 VL_TOT_CREDITOS
?? strzero(month(M_DATA1),2) + str(year(M_DATA1),4) + "|"    // 10 VL_AJ_CREDITOS

QDE_E200 = 0
QDE_E210 = 0

for ABC = 1 to len(aSUBTRIB)
  ? "|E200|"  // APURACAO DO ICMS SUBSTITUICAO
  ?? aSUBTRIB[ABC][1] + "|"
  ?? fordata(M_DATA1) + "|"
  ?? fordata(M_DATA2) + "|"
  QDE_E200 ++
  QDE_LIN ++
  BLOCO_E ++

  ? "|E210|1|"  // APURACAO DO ICMS
  ?? forvalor(0) + "|"          // 03 VL_AJ_DEBITOS
  ?? forvalor(0) + "|"          // 04 VL_TOT_AJ_DEBITOS
  ?? forvalor(0) + "|"          // 05 VL_ESTORNOS_CRED
  ?? forvalor(aSUBTRIB[ABC][2]) + "|" // 06 VL_TOT_CREDITOS
  ?? forvalor(0) + "|"          // 07 VL_AJ_CREDITOS
  ?? forvalor(aSUBTRIB[ABC][3]) + "|"          // 08 VL_TOT_AJ_CREDITOS
  ?? forvalor(0) + "|"          // 09 VL_ESTORNO_DEB
  ?? forvalor(0) + "|"          // 10 VL_SLD_CREDOR_ANT
  ?? forvalor(0) + "|" // 11 VALOR APURADO
  ?? forvalor(0) + "|" // 12 VLR_TOT_DED
  ?? forvalor(0) + "|" // 13 VALOR A RECOLHER
  ?? forvalor(aSUBTRIB[ABC][2]-aSUBTRIB[ABC][3])       + "|" // 14
  ?? forvalor(0)       + "|" // 15
  BLOCO_E ++
  QDE_E210 ++
  QDE_LIN ++
next

? "|E990|"   + alltrim(str(BLOCO_E+1,10)) +"|"
? "|G001|1|"
? "|G990|2|"


 ? "|H001|1|"

//? "|H001|0|"

  BLOCO_H = 1
  QDE_H001 = 1
  QDE_LIN ++
  QDE_H010 = 0

****************************
** INVENTARIO DE PRODUTOS **
****************************

// SOMENTE NO MES DE FEVEREIRO


M_DTAINV = ctod("31/12/2024")   // M_DATA1-1
M_TOTEST = 0

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"APCA00","APCA00"})
  aadd(sqlCAMPO,"ASLD00.SLDINV")
  aadd(sqlCAMPO,"ASLD00.SLDCME")
  aadd(sqlCAMPO,"PCAMAT")
  aadd(sqlCAMPO,"PCADES")
  aadd(sqlCAMPO,"PCAUNI")
  aadd(sqlCAMPO,"PCAGRP")
  aadd(sqlCAMPO,"PCAFOR")
  aadd(sqlCAMPO,"PCATRI")
  aadd(sqlCAMPO,"PCARG1")
  aadd(sqlCAMPO,"PCARG2")
  aadd(sqlCAMPO,"PCARG0")
  aadd(sqlCAMPO,"PCACSP")
  aadd(sqlCAMPO,"PCACOU")
  aadd(sqlRELATION,{"ASLD00",str(ME_EMP, 2, 0),"ASLD00.SLDEMP"})
  aadd(sqlRELATION,{"","ASLD00.SLDMAT","APCA00.PCAMAT"})
  aadd(sqlCHAVE,"PCAINV <> 'N'")
  aadd(sqlCHAVE,"ASLD00.SLDINV > 0")
  aadd(sqlCHAVE,"PCAMAT > 0")
  aadd(sqlORDEM,"PCADES")

  sqlrelation()

go top
do while !eof()

  if month(M_DATA1) # 2
    exit
  endif

  // INVENTARIO SOMETE UMA VEZ POR ANO

  // TOTAL DO ESTOQUE

  M_TOTEST += (SLDINV*SLDCME)

  msw("* * * PROCESSANDO SALDO INVENTARIO:" + str(M_TOTEST,12,2) + " * * *")
  skip

enddo

  // INVENTARIO SOMENTE UMA VEZ POR ANO

M_PERCINV = 1 // 1224628.24 / M_TOTEST
*M_TOTEST = 1224628.24

QDE_H005 = 0

if month(M_DATA1) # 2
else
  ? "|H005|"  // APURACAO DO ICMS SUBSTITUICAO
  ?? fordata(M_DTAINV) + "|"
  ?? forvalor(M_TOTEST) + "|"          // 03 VL_AJ_DEBITOS
  ?? "01|"  // APURACAO DO ICMS SUBSTITUICAO

  BLOCO_H ++
  QDE_H005 = 1
  QDE_LIN ++
endif

QDE_H010 = 0

go top

do while !eof()

  if month(M_DATA1) # 2
     exit
  endif

  // INVENTARIO SOMENTE UMA VEZ POR ANO


  ? "|H010|"  // APURACAO DO ICMS SUBSTITUICAO
  ?? alltrim(str(PCAMAT,6)) + "|"
  ?? alltrim(PCAUNI) + "|"
  ?? forvalor(SLDINV,3) + "|"          // 03 VL_AJ_DEBITOS
  ?? forvalor(SLDCME*M_PERCINV,6) + "|"          // 03 VL_AJ_DEBITOS
  ?? forvalor((SLDCME*M_PERCINV)*SLDINV,2) + "|"          // 03 VL_AJ_DEBITOS
  ?? "0|"  // APURACAO DO ICMS SUBSTITUICAO
  ?? "|"
  ?? "|"
  ?? "1.1.5.01.0001||"

  msw("* * * INVENTARIO:" + str(PCAMAT,6) + " * * *")

  BLOCO_H ++
  QDE_H010 ++
  QDE_LIN ++

  skip

enddo

? "|H990|"   + alltrim(str(BLOCO_H,10)) +"|"
? "|K001|1|"
? "|K990|2|"

? "|1001|0|"
? "|1010|N|N|N|N|N|N|N|N|N|N|N|N|N|"
? "|1990|5|"
? "|9001|0|"
? "|9900|0000|1|"
? "|9900|0001|1|"
? "|9900|0005|1|"
? "|9900|0100|1|"

// alterar depois

M_REG150 = 1
M_REG190 = 1
M_REG200 = 1

? "|9900|0990|1|"
? "|9900|0150|" + alltrim(str(QDE_0150,10)) + "|"
? "|9900|0190|" + alltrim(str(QDE_0190,10)) + "|"
? "|9900|0200|" + alltrim(str(QDE_0200,10)) + "|"
? "|9900|0460|" + alltrim(str(2,10)) + "|"
? "|9900|0500|" + alltrim(str(9,10)) + "|"
? "|9900|1601|" + alltrim(str(2,10)) + "|"
? "|9900|B001|" + alltrim(str(1,10)) + "|"
? "|9900|B990|" + alltrim(str(1,10)) + "|"
? "|9900|C001|" + alltrim(str(1,10)) + "|"
? "|9900|C100|" + alltrim(str(QDE_C100,10)) + "|"
? "|9900|C170|" + alltrim(str(QDE_C170,10)) + "|"
? "|9900|C176|" + alltrim(str(QDE_C170,10)) + "|"
? "|9900|C190|" + alltrim(str(QDE_C190,10)) + "|"
? "|9900|C195|" + alltrim(str(QDE_C195,10)) + "|"
? "|9900|C197|" + alltrim(str(QDE_C197,10)) + "|"
? "|9900|C400|" + alltrim(str(QDE_C400,10)) + "|"
? "|9900|C405|" + alltrim(str(QDE_C405,10)) + "|"
? "|9900|C410|" + alltrim(str(QDE_C410,10)) + "|"
? "|9900|C420|" + alltrim(str(QDE_C420,10)) + "|"
? "|9900|C425|" + alltrim(str(QDE_C425,10)) + "|"
? "|9900|C460|" + alltrim(str(QDE_C460,10)) + "|"
? "|9900|C470|" + alltrim(str(QDE_C470,10)) + "|"
? "|9900|C490|" + alltrim(str(QDE_C490,10)) + "|"
? "|9900|C500|" + alltrim(str(QDE_C500,10)) + "|"
? "|9900|C590|" + alltrim(str(QDE_C590,10)) + "|"
? "|9900|C800|" + alltrim(str(QDE_C800,10)) + "|"
? "|9900|C850|" + alltrim(str(QDE_C850,10)) + "|"
? "|9900|C990|1|"
? "|9900|D001|" + alltrim(str(1,10)) + "|"
? "|9900|D100|" + alltrim(str(QDE_D100,10)) + "|"
? "|9900|D190|" + alltrim(str(QDE_D190,10)) + "|"
? "|9900|D500|" + alltrim(str(QDE_D500,10)) + "|"
? "|9900|D590|" + alltrim(str(QDE_D590,10)) + "|"
? "|9900|D990|" + alltrim(str(1)) + "|"

? "|9900|E001|" + alltrim(str(1,10)) + "|"
? "|9900|E100|" + alltrim(str(1,10)) + "|"
? "|9900|E110|" + alltrim(str(1,10)) + "|"
? "|9900|E116|" + alltrim(str(1,10)) + "|"
? "|9900|E200|" + alltrim(str(QDE_E200,10)) + "|"
? "|9900|E210|" + alltrim(str(QDE_E210,10)) + "|"
? "|9900|E990|" + alltrim(str(1,10)) + "|"

? "|9900|G001|" + alltrim(str(1,10)) + "|"
? "|9900|G990|" + alltrim(str(1,10)) + "|"

? "|9900|H001|" + alltrim(str(1,10)) + "|"
? "|9900|H005|" + alltrim(str(0,10)) + "|"
? "|9900|H010|" + alltrim(str(QDE_H010,10)) + "|"
? "|9900|H990|" + alltrim(str(1,10)) + "|"

? "|9900|K001|1|"
? "|9900|K990|1|"

? "|9900|1001|1|"
? "|9900|1010|1|"
? "|9900|1990|1|"
? "|9900|9001|1|"
? "|9900|9990|1|"
? "|9900|9999|1|"
? "|9900|9900|52|"
? "|9990|55|"
? "|9999|" + alltrim(str(QDE_LIN+52+QDE_0190,10)) + "|"
?

set printer to
set print off

select 0
use SPED00 exclusive
select SPED00
zap

append from C:\PIS\EFDICMS.TXT SDF

finalsped()
commit
quit

set console off
set print on
set printer to "C:\PIS\CLIENTES.TXT"

select ACLISP
go top
do while !eof()

    lNao = .f.

    if !left(NFSCLI,1) == "F"
      skip
      loop
    endif

    AFOR00->(dbseek(str(val(right(ACLISP->NFSCLI,11)), 7, 0)))

    ? "|0150|"  // REGISTRO 01
    ?? alltrim(ACLISP->NFSCLI) + "|" // 02
    ?? alltrim(AFOR00->FORNOM) + "|" // 03
    ?? "1058|"              // 04 PAIS

    if len(alltrim(AFOR00->FORCGC))=15
      ?? right(AFOR00->FORCGC,14) + "|" + "|"     // 06 CPF
    else
      if !empty(AFOR00->FORCGC)
        ?? "|" + pad(alltrim(AFOR00->FORCGC),11) + "|"
      endif
    endif

    if "ISENTO" $ AFOR00->FORIES
      ?? "|"     // parei aqui
    else
      ?? tira_pto(AFOR00->FORIES) + "|"     // parei aqui
    endif

    ?? alltrim(AFOR00->FORIBGE) + "|"
    ?? "|"     // 09 SUFRAMA
    ?? alltrim(AFOR00->FOREND) + "|"     // 10 END
    ?? "|"     // 11 NUM
    ?? "|"     // 12 COMPL
    ?? alltrim(AFOR00->FORBAI) + "|"    // 13 BAIRRO

    skip

enddo

set printer to
set print off


****************
function FORDATA(TIPO)
****************

return strzero(day(TIPO),2) + strzero(month(TIPO),2) + strzero(year(TIPO),4)

function FORVALOR(TIPO,TAMANHO)

if TAMANHO = NIL
  TAMANHO = 2
endif

return  strtran(alltrim(STR(TIPO,12,TAMANHO)),".",",")

***************
function TOTPIS
***************

if ANFS00->NFSCAN $ "CD"
  return ""
endif

msw("Calculando Total do Pis Saidas " + dtoc(ANFS00->NFSDTE))

if !le_xml("C:\CIRUR\ENVIADO\" + alltrim(ANFS00->NFSUSU) + "\NFE\"+ ANFS00->NFSID)
  msg("* * * A-NAO ENCONTREI ARQUIVO XML NOTA NUMERO: " + str(ANFS00->NFSNUM,6) + " * * *")
  return ""
endif

select ANFTM1
go top

do while !eof()

  TOTVDA += NFELIQ
  VL_REC_BRT  += NFEVLI // SEM DESCONTO

  M_NFSBIC += NFELIQ // + ANFS01->NFSDSP + ANFS01->NFSVICS + ANFS01->NFSVIP
  M_TOTPIS += round(((NFELIQ/100) * M_PIS),2)
  M_TOTVPIS += round(((NFELIQ/100) * M_PIS),2)
  M_TOTCOF += round(((NFELIQ/100) * M_COF),2)
  M_TOTVCOF += round(((NFELIQ/100) * M_COF),2)

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
function TOTPISSAT
***************

if ACUP00->CUPCAN $ "CD"
  return ""
endif

msw("Calculando Total do Pis Saidas " + dtoc(ACUP00->CUPDTE))

if !le_xml("C:\CIRUR\ENVIADO\" + alltrim(ACUP00->CUPTRN) + "\NFCe\"+ alltrim(ACUP00->CUPHS6))
  msg("* * * XML NFCe NUMERO: " + str(ACUP00->CUPNUM,6) + " - " + alltrim(ACUP00->CUPHS6))
  return ""
endif

return ""


****************
function TOTPISE
****************

*if ANFE00->NFECAN $ "C"
*  return ""
*endif

msw("Calculando Total do Pis Entradas " + dtoc(ANFE00->NFEDTR))

select ANFE01
set order to 1
dbseek(str(ANFE00->NFEEMP, 2, 0) + str(ANFE00->NFENUM, 6, 0) + ANFE00->NFESER + str(ANFE00->NFEFOR, 7, 0),.t.)

do while !eof()

  if !str(NFEEMP, 2, 0) + str(NFENUM, 6, 0) + NFESER + str(NFEFOR, 7, 0) == str(ANFE00->NFEEMP, 2, 0) + str(ANFE00->NFENUM, 6, 0) + ANFE00->NFESER + str(ANFE00->NFEFOR, 7, 0)
    exit
  endif

  APCA00->(dbseek(str(ANFE01->NFEMAT, 6, 0)))

      if !ANCM00->(dbseek(APCA00->PCACLA))
        msg("* * * CODIGO NCM NAO CADASTRADO PRODUTO " + str(APCA00->PCAMAT) + " * * *")
        select ANFTM1
        skip
        loop
      endif

      TOTVDA += NFELIQ
      VL_REC_BRT  += NFEVLI // SEM DESCONTO

      M_NFENAT = alltrim(NFENAT)

      if M_NFENAT == ""
        AFIS00->(dbseek(str(ME_EMP, 2, 0) + str(ANFE00->NFENAT, 5, 0)))
        M_NFENAT = alltrim(tira_pto(AFIS00->FISNOV))
      endif

      // 1406 COMPRA PARA ATIVO
      // 1551 COMPRA DE BEM PARA ATIVO
      // 1556 COMPRA PARA USO CONSUMO
      // 1910 BONIFICACAO

        if M_NFENAT $ "#1918#1917#1552#2551#1949#2949#1910#1556#1406#1551"// nao da credito
          M_BASE05 += NFELIQ+NFEVIP+NFEDST+NFEFRE
          M_NFSISE += NFELIQ+NFEVIP+NFEDST+NFEFRE
        else
          if M_NFENAT $ "2202#1202#1411#2411#"  // devolucao
            E_BASE12 += NFELIQ+NFEVIP+NFEDST+NFEFRE
          endif
          if M_NFENAT $ "#2556#1407#1653#"  // insumos
            E_BASE02 += NFELIQ+NFEVIP+NFEDST+NFEFRE
          endif

          E_BASE01 += NFELIQ+NFEVIP+NFEDST+NFEFRE
          E_TOTVPIS += round((((NFELIQ+NFEVIP+NFEDST+NFEFRE)/100) * M_PIS),2)
          E_TOTVCOF += round((((NFELIQ+NFEVIP+NFEDST+NFEFRE)/100) * M_COF),2)

          M_NFSBIC += NFELIQ+NFEVIP+NFEDST+NFEFRE // + ANFS01->NFSDSP + ANFS01->NFSVICS + ANFS01->NFSVIP
          M_TOTPIS += round((((NFELIQ+NFEVIP+NFEDST+NFEFRE)/100) * M_PIS),2)
          M_TOTVPIS += round((((NFELIQ+NFEVIP+NFEDST+NFEFRE)/100) * M_PIS),2)
          M_TOTCOF += round((((NFELIQ+NFEVIP+NFEDST+NFEFRE)/100) * M_COF),2)
          M_TOTVCOF += round((((NFELIQ+NFEVIP+NFEDST+NFEFRE)/100) * M_COF),2)

        endif

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

***************
function PCOMPLE
***************

select ANFS01
dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER,.t.)

M_VALCOMP = 0

do while !eof()

  if str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSNUM, 6, 0) + ANFS01->NFSSER > str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER
    exit
  endif

  M_VALCOMP += NFSVIC

  skip

  if inkey() = 27
    if suspro()
      msg("* * * PROCESSO SUSPENSO * * *")
      return ""
    endif
  endif

enddo

return M_VALCOMP

***************
function REG170(F_TIPO)
***************

local nSEQ

nSEQ = 1

select ANFTM1
go top

msw("Gerando Registro C170 Saidas")

REG_190 = { }  // RESUMO POR OPERACAO

REG_C719 = { }  // SUB
REG_C721 = { }  // PROPRIA

nTOTSUB = 0

do while !eof()

  if len(REG_190) = 0
    aadd(REG_190,{0,NFECST,NFENATN,NFEPIC,0,0,0,0,0,0,0,0})
  endif

  aadd(REG_C721,{NFEMAT,0,0,0})
  aadd(REG_C719,{NFEMAT,0,0,0})

  select ANFTM1

  lTem190 = .f.

  for ABC = 1 to len(REG_190)
    if REG_190[ABC][2] == NFECST .and. REG_190[ABC][3] == NFENATN .and. REG_190[ABC][4] == NFEPIC
      lTem190 = .t.
      exit
    endif
  next

  if !lTem190
    aadd(REG_190,{0,NFECST,NFENATN,NFEPIC,0,0,0,0,0,0,0,0})
    ABC = len(REG_190)
  endif

  nVALNFS += NFELIQ

  REG_190[ABC][5] += NFELIQ
  REG_190[ABC][6] += NFEBIC
  REG_190[ABC][7] += NFEVIC
  REG_190[ABC][11] += NFEVIP


  if NFECST == "020" // COM REDUCAO
    REG_190[ABC][10] += NFELIQ-NFEBIC
  endif

  lTemsub = .f.
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

if F_TIPO == "NOTA"
   if !str(nVALNFS,12,2) == str(ANFS00->NFSVLN,12,2)
     if ANFS00->NFSVLN > nVALNFS
       REG_190[1][5] += (ANFS00->NFSVLN-nVALNFS)
     else
       REG_190[1][5] -= (nVALNFS-ANFS00->NFSVLN)
     endif
   endif
else
   if !str(nVALNFS,12,2) == str(ACUP00->CUPVLN,12,2)
     if ANFS00->NFSVLN > nVALNFS
       REG_190[1][5] += (ACUP00->CUPVLN-nVALNFS)
     else
       REG_190[1][5] -= (nVALNFS-ACUP00->CUPVLN)
     endif
   endif
endif

for ABC = 1 to len(REG_190)

  ? "|C190|"                         // 01
  ?? REG_190[ABC][2] + "|"           // 02
  ?? REG_190[ABC][3] + "|"           // 03
  ?? forvalor(REG_190[ABC][4]) + "|" // 04
  ?? forvalor(REG_190[ABC][5]) + "|" // 05
  ?? forvalor(REG_190[ABC][6]) + "|" // 06
  ?? forvalor(REG_190[ABC][7]) + "|" // 07 VALOR ICMS
  ?? forvalor(REG_190[ABC][8]) + "|"  // 08 BASE ST
  ?? forvalor(REG_190[ABC][9]) + "|"  // 09 VALOR ST

  if REG_190[ABC][5] > 0 .and. REG_190[ABC][6] > 0
    ?? forvalor(REG_190[ABC][5]-REG_190[ABC][6]) + "|" // 10 NAO TRIBUTADO
  else
    ?? forvalor(REG_190[ABC][10]) + "|" // 10 NAO TRIBUTADO
  endif


  ?? forvalor(REG_190[ABC][11]) + "|" // 11 VALOR IPI
  ?? "|"                             // 12

  M_ICMSAIDA += REG_190[ABC][7]

  QDE_C190 ++
  QDE_LIN ++
  BLOCO_C ++

next

if nTOTSUB > 0
  ? "|C195|000001|" + alltrim(str(nTOTSUB,12,2)) + "|"
  QDE_C195 ++
  QDE_LIN ++
  BLOCO_C ++


  // 721 OPERACAO PROPRIA

  for ABC = 1 to len(REG_C721)
    if REG_C721[ABC][4] > 0
      ? "|C197|SP10090721||"  + alltrim(str(REG_C721[ABC][1],6)) + "|"
      ?? forvalor(REG_C721[ABC][2]) + "|"  // 13
      ?? forvalor(REG_C721[ABC][3]) + "|"  // 13
      ?? forvalor(REG_C721[ABC][4]) + "|"  // 13
      ?? forvalor(0) + "|"

      ? "|C197|SP10090719||"  + alltrim(str(REG_C719[ABC][1],6)) + "|"
      ?? forvalor(REG_C719[ABC][2]) + "|"  // 13
      ?? forvalor(REG_C719[ABC][3]) + "|"  // 13
      ?? forvalor(REG_C719[ABC][4]) + "|"  // 13
      ?? forvalor(0) + "|"

      QDE_C197 += 2
      QDE_LIN += 2
      BLOCO_C += 2
    endif
  next

endif


return ""

***************
function REG170E // REGISTRO 170 ENTRADA
***************

local nSEQ
local nTOTSUB:= 0
local nTOTVIP:= 0

nSEQ = 1

REG_190 = { }  // RESUMO POR OPERACAO
REG_CST = { }  // RESUMO POR OPERACAO

msw("Gerando Registro C170 Entradas")

sqlRELATION = {}
sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {}
sqlORDEM = {}
aadd(sqlARQUI,{"ANFE01","ANFE01"})
aadd(sqlCAMPO,"ANFE01.*")
aadd(sqlCAMPO,"APCA00.PCAUNI")
aadd(sqlRELATION,{"AFIS00",str(ME_EMP, 2, 0),"AFIS00.FISEMP"})
aadd(sqlRELATION,{"","AFIS00.FISNOV","ANFE01.NFENATN"})

aadd(sqlCHAVE, "ANFE01.NFEEMP = " + str(ANFE00->NFEEMP,2) )
aadd(sqlCHAVE, "ANFE01.NFENUM = " + str(ANFE00->NFENUM,9) )
aadd(sqlCHAVE, "ANFE01.NFESER = " + aspas(ANFE00->NFESER) )
aadd(sqlCHAVE, "ANFE01.NFEFOR = " + str(ANFE00->NFEFOR,5) )

aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","ANFE01.NFEMAT"})
sqlrelation()

do while !eof()

  M_NFECST = alltrim(NFECST)

  if M_NFECST == "53"
    M_NFECST = ""
  endif

  if M_NFECST == "99"
    M_NFECST = "10"
  endif

  if M_NFECST == "08"
    M_NFECST = "00"
    if NFEBIC = 0
      M_NFECST = "40"
    endif
  endif

  if M_NFECST == "01"
    M_NFECST = "00"
    if NFEBIC = 0
      M_NFECST = "40"
    endif
  endif

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
  else
    if NFEORI == " "
      M_NFECST = "0" + M_NFECST
    else
      M_NFECST = NFEORI + M_NFECST
    endif
  endif

  M_NFENAT = alltrim(tira_pto(NFENATN))

  if M_NFENAT == ""
    M_NFENAT = alltrim(tira_pto(ANFE00->NFENATN))
  endif

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

  if M_NFECST $ "#249#049#"
    M_NFECST = "090"
  endif
  
  if len(REG_190) = 0
    aadd(REG_190,{0,M_NFECST,M_NFENAT,NFEPIC,0,0,0,0,0,0,0,0,0,0})
  endif

  // REGISTRO C170 NOTA FISCAL ITENS

    ? "|C170|"
    ?? alltrim(str(nSEQ)) + "|"
    ?? alltrim(str(NFEMAT,6)) + "|"
    ?? "|"
    ?? forvalor(NFEQDE)  + "|"
    ?? alltrim(PCAUNI)+ "|"

    ?? forvalor(NFELIQ+NFEDSC+NFEFRE)  + "|"

    ?? forvalor(NFEDSC)  + "|"  // DESCONTO
    ?? "0|"
    ?? M_NFECST + "|"
    ?? M_NFENAT + "|"  // 11
    ?? "|"   // 12 NAO OBRIGATORIO
    ?? forvalor(NFEBIC) + "|"  // 13
    ?? forvalor(NFEPIC) + "|"  // 14
    ?? forvalor(NFEVIC) + "|"  // 15
    ?? forvalor(0) + "|" // 16
    ?? forvalor(0) +"|"  // 17
    ?? forvalor(0) + "|"  // 18
    ?? "0|"  // 19

    if alltrim(M_NFENAT) $ "#1556#1407#"
      ?? "49|" // 20   // OUTRAS ANTRADAS
    else
      ?? "03|" // 20   // ENTRADA NAO TRIBUTADA = 00
    endif

    ?? "|"   // 21
    ?? forvalor(0)  + "|"  // 22
    ?? forvalor(0) + "|"  // 23
    ?? forvalor(0) + "|"  // 24

    QDE_C170 ++
    QDE_LIN ++
    BLOCO_C ++

    select ANFE01

    lCSTPIS = "00"

    if M_NFENAT $ "1407#1556#2556#" // nao tem pis
      lCSTPIS = "74"
    endif

    lCSTPIS = "98"

    lNaopis = .f.

    if lCSTPIS == "98"
      ?? "98|"  // 25
      ?? forvalor(0)  + "|"  // 26
      lNaopis = .t.
    else
      if !PCATP == "00" // CALCULA PIS COFINS 60-7 TIPO DO ITE
        lNaopis = .t.
        ?? "05|"  // 25
      else
        ?? "50|"  // 25 TRIBUTADO COM ALIQUOTA NORMAL
      endif
      ?? forvalor(NFELIQ)  + "|"  // 26
    endif

    if lNaopis
      ?? forvalor(0)  + "|"  // 27
      ?? "|" // 28
      ?? "|" // 29
      ?? forvalor(0)   + "|"  // 30
    else
      ?? forvalor(M_PIS)  + "|"  // 27
      ?? "|" // 28
      ?? "|" // 29
      ?? forvalor(round(((NFELIQ/100) * M_PIS),2))   + "|"  // 30
    endif

    if lCSTPIS == "98"
      ?? "98|"  // 25
      ?? forvalor(0)  + "|"  // 26
      lNaopis = .t.
    else
      if !PCATP == "00" // CALCULA PIS COFINS 60-7 TIPO DO ITEM
        ?? "05|"  // 31
      else
        ?? "50|"  // 31 TRIBUTADO COM ALIQUOTA BASICA
      endif
      ?? forvalor(NFELIQ)  + "|"  // 32
    endif

    if lNaopis
      ?? forvalor(0)  + "|"  // 33
      ?? "|" // 34
      ?? "|" // 35
      ?? forvalor(0)   + "|"  // 36
    else
      ?? forvalor(M_COF)  + "|"  // 33
      ?? "|" // 34
      ?? "|" // 35
      ?? forvalor(round(((NFELIQ/100) * M_COF),2))   + "|"  // 36
    endif

    ?? "4.1.1.01.0000|" // DEPOIS ALTERA SEMPRE COMPRA
    ?? "|" // 38

  select ANFE01

  lTemCST = .f.

  if NFESUB > 0
    for ABC = 1 to len(REG_CST)
      if REG_CST[ABC][3] == M_NFENAT
        lTemCST = .t.
        exit
      endif
    next
    if !lTemCST
      aadd(REG_CST,{0,M_NFECST,M_NFENAT,NFEPIC,0,0,0,0,0,0,0,0,0,0,0,0})
      ABC = len(REG_CST)
    endif
    REG_CST[ABC][5] += NFELIQ+NFESUB+NFEVIP+NFEDST+NFEFRE
    REG_CST[ABC][6] += NFEBIC
    REG_CST[ABC][7] += NFEVIC
    REG_CST[ABC][13] += NFEVIP
    REG_CST[ABC][14] += NFESUB
  endif

  lTem190 = .f.

  for ABC = 1 to len(REG_190)
    if REG_190[ABC][2] == M_NFECST .and. REG_190[ABC][3] == M_NFENAT .and. REG_190[ABC][4] == NFEPIC
      lTem190 = .t.
      exit
    endif
  next

  if !lTem190
    aadd(REG_190,{0,M_NFECST,M_NFENAT,NFEPIC,0,0,0,0,0,0,0,0,0,0,0,0})
    ABC = len(REG_190)
  endif

  REG_190[ABC][5] += NFELIQ+NFESUB+NFEVIP+NFEDST+NFEFRE
  REG_190[ABC][6] += NFEBIC
  REG_190[ABC][7] += NFEVIC

  REG_190[ABC][13] += NFEVIP
  REG_190[ABC][14] += NFESUB

  nTOTSUB += NFESUB
  nTOTVIP += NFEVIP

  if M_NFECST $ "#020#220#" // COM REDUCAO
    REG_190[ABC][10] += REG_190[ABC][5] - REG_190[ABC][6]
  endif

  REG_190[ABC][11] += 0

  lTemsub = .f.

  nSEQ ++

  select ANFE01

  skip

enddo

for ABC = 1 to len(REG_190)

    ? "|C190|"                          // 01
    ?? REG_190[ABC][2] + "|"            // 02
    ?? REG_190[ABC][3] + "|"            // 03
    ?? forvalor(REG_190[ABC][4]) + "|"  // 04
    ?? forvalor(REG_190[ABC][5]) + "|"  // CONTABIL
    ?? forvalor(REG_190[ABC][6]) + "|"  // BASE ICMS
    ?? forvalor(REG_190[ABC][7]) + "|"  // VALOR ICMS
    ?? forvalor(REG_190[ABC][8]) + "|"                // 08
    ?? forvalor(REG_190[ABC][9]) + "|"  // 09

     if REG_190[ABC][5] > 0 .and. REG_190[ABC][6] > 0
       ?? forvalor(REG_190[ABC][5]-REG_190[ABC][6]) + "|" // 10 NAO TRIBUTADO
     else
       ?? forvalor(REG_190[ABC][10]) + "|" // 10 NAO TRIBUTADO
     endif

    ?? forvalor(REG_190[ABC][11]) + "|" // 11
    ?? "|"                              // 12

    M_ICMENTRA += REG_190[ABC][7]
    M_ENTSUB += REG_190[ABC][9]

    QDE_C190 ++
    QDE_LIN ++
    BLOCO_C ++

next

// CAT 66

if nTOTVIP > 0 // IPI
  ? "|C195|000002|" + alltrim(str(nTOTVIP,12,2)) + "|"
  QDE_C195 ++
  QDE_LIN ++
  BLOCO_C ++
  ? "|C197|SP90090104|Valor referente ao IPI||"
  ?? forvalor(0.01) + "|"  // 13
  ?? forvalor(0) + "|"  // 13
  ?? forvalor(0) + "|"  // 13
  ?? forvalor(0) + "|"  // 13
  QDE_C197 += 1
  QDE_LIN += 1
  BLOCO_C += 1
endif

if nTOTSUB > 0 // ST
  ? "|C195|998|AJUSTE REF. SUBST. TRIBUTARIA|"
  QDE_C195 ++
  QDE_LIN ++
  BLOCO_C ++

  for ABC = 1 to len(REG_CST)
    if REG_CST[ABC][14] > 0 // ST
      ? "|C197|SP90090104|" + REG_CST[ABC][3] + " - Recolhimento Antecipado||"
      ?? "|"  // 13
      ?? "|"  // 13
      ?? "|"  // 13
      ?? forvalor(REG_CST[ABC][5]-REG_CST[ABC][13]-REG_CST[ABC][14]) + "|"

      ? "|C197|SP90090278|Referente ao ICMS ST||"
      ?? "|"  // 13
      ?? "|"  // 13
      ?? forvalor(REG_CST[ABC][14]) + "|"  // 13
      ?? "|"
      QDE_C197 += 2
      QDE_LIN += 2
      BLOCO_C += 2
    endif
  next
endif

return ""

 *****************
function SEEXISTE
*****************

local A
parame F_ABREARQUIVO

if select(F_ABREARQUIVO) > 0
  select &F_ABREARQUIVO
  use
endif

return ""

**************
function MOD11_NFE                         && calculo digito verificador
**************

parameters F_DIG

private M_SOMA  ,;
        M_DIG

M_SOMA = (val(substr(F_DIG, 43, 1)) * 2) + ;
         (val(substr(F_DIG, 42, 1)) * 3) + ;
         (val(substr(F_DIG, 41, 1)) * 4) + ;
         (val(substr(F_DIG, 40, 1)) * 5) + ;
         (val(substr(F_DIG, 39, 1)) * 6) + ;
         (val(substr(F_DIG, 38, 1)) * 7) + ;
         (val(substr(F_DIG, 37, 1)) * 8) + ;
         (val(substr(F_DIG, 36, 1)) * 9) + ;
         (val(substr(F_DIG, 35, 1)) * 2) + ;
         (val(substr(F_DIG, 34, 1)) * 3) + ;
         (val(substr(F_DIG, 33, 1)) * 4) + ;
         (val(substr(F_DIG, 32, 1)) * 5) + ;
         (val(substr(F_DIG, 31, 1)) * 6) + ;
         (val(substr(F_DIG, 30, 1)) * 7) + ;
         (val(substr(F_DIG, 29, 1)) * 8) + ;
         (val(substr(F_DIG, 28, 1)) * 9) + ;
         (val(substr(F_DIG, 27, 1)) * 2) + ;
         (val(substr(F_DIG, 26, 1)) * 3) + ;
         (val(substr(F_DIG, 25, 1)) * 4) + ;
         (val(substr(F_DIG, 24, 1)) * 5) + ;
         (val(substr(F_DIG, 23, 1)) * 6) + ;
         (val(substr(F_DIG, 22, 1)) * 7) + ;
         (val(substr(F_DIG, 21, 1)) * 8) + ;
         (val(substr(F_DIG, 20, 1)) * 9) + ;
         (val(substr(F_DIG, 19, 1)) * 2) + ;
         (val(substr(F_DIG, 18, 1)) * 3) + ;
         (val(substr(F_DIG, 17, 1)) * 4) + ;
         (val(substr(F_DIG, 16, 1)) * 5) + ;
         (val(substr(F_DIG, 15, 1)) * 6) + ;
         (val(substr(F_DIG, 14, 1)) * 7) + ;
         (val(substr(F_DIG, 13, 1)) * 8) + ;
         (val(substr(F_DIG, 12, 1)) * 9) + ;
         (val(substr(F_DIG, 11, 1)) * 2) + ;
         (val(substr(F_DIG, 10, 1)) * 3) + ;
         (val(substr(F_DIG,  9, 1)) * 4) + ;
         (val(substr(F_DIG,  8, 1)) * 5) + ;
         (val(substr(F_DIG,  7, 1)) * 6) + ;
         (val(substr(F_DIG,  6, 1)) * 7) + ;
         (val(substr(F_DIG,  5, 1)) * 8) + ;
         (val(substr(F_DIG,  4, 1)) * 9) + ;
         (val(substr(F_DIG,  3, 1)) * 2) + ;
         (val(substr(F_DIG,  2, 1)) * 3) + ;
         (val(substr(F_DIG,  1, 1)) * 4)

M_DIG = iif((M_SOMA % 11)=0,0,iif((M_SOMA % 11)=1,0,(11-(M_SOMA % 11))))

return str(M_DIG, 1, 0)
*****************
function TIRA_PTOIES
*****************

parameter M_CPOPTO

 M_CPOPTO = strtran(M_CPOPTO, ".","")
 M_CPOPTO = strtran(M_CPOPTO, "-","")
 M_CPOPTO = strtran(M_CPOPTO, "/","")
 M_CPOPTO = strtran(M_CPOPTO, "]","")
 M_CPOPTO = strtran(M_CPOPTO, "\","")
 M_CPOPTO = strtran(M_CPOPTO, ",","")
 M_CPOPTO = strtran(M_CPOPTO, "(","")
 M_CPOPTO = strtran(M_CPOPTO, ")","")
 M_CPOPTO = strtran(M_CPOPTO, " ","")
 M_CPOPTO = strtran(M_CPOPTO, "P","")

return M_CPOPTO

