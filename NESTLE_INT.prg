#include "HbLang.ch"
#include "Inkey.ch"

/*
================================================================================
MÓDULO      : NESTLE_INT.PRG
DESCRIÇÃO   : Módulo Separado para Integração Nestlé Sellout e Inventário
LINGUAGEM   : xHarbour / COM Automation (XMLHTTP / Excel)
DATA        : 2026-08-05
--------------------------------------------------------------------------------
MELHORIAS IMPLEMENTADAS:
  1. Extração completa do módulo EAGRO11 (Cadastro de Empresa), respeitando o
     princípio de responsabilidade única (SRP).
  2. Função auxiliar NESTLE_SafeJsonStr() para sanitizar strings JSON e evitar
     erros HTTP 400 causados por aspas, barras ou caracteres de controle.
  3. Tratamento de exceções robusto na comunicação COM com o Excel e HTTP.
  4. Organização limpa das lógicas de apuração de saldo (30/60/90 dias) e vendas.
================================================================================
*/

***************
FUNCTION ATU_NESTLE()
***************
   LOCAL nAbc := 0
   LOCAL dDtaIni

   dDtaIni := M_DTA1

   seexistesql( "APCA00" )

   IF File( "PCALOC.CDX" )
      FErase( "PCALOC.CDX" )
   ENDIF

   sqlRELATION := {}
   sqlCAMPO    := {}
   sqlCHAVE    := {}
   sqlARQUI    := {}
   sqlORDEM    := {}

   AAdd( sqlARQUI, { "APCA00", "APCA00" } )
   AAdd( sqlCAMPO, "APCA00.*" )
   AAdd( sqlCHAVE, "PCAFAB <> ''" )
   AAdd( sqlORDEM, "PCAMAT" )
   sqlrelation()

   SELECT APCA00
   Go Top

   DO WHILE !Eof()
      FOR nAbc := 1 TO 3 // 3 períodos: 30, 60 e 90 dias
         DO CASE
            CASE nAbc == 1 ; dDtaIni := M_DTA1
            CASE nAbc == 2 ; dDtaIni := dDtaIni - 30
            CASE nAbc == 3 ; dDtaIni := dDtaIni - 30
         ENDCASE

         SELECT APCA00

         msw( "* * * AGUARDE ... PROCESSANDO: " + Transform( APCA00->PCAMAT, "@E ###,###" ) + " * * *" )

         sqlRELATION := {}
         sqlCAMPO    := {}
         sqlCHAVE    := {}
         sqlARQUI    := {}
         sqlORDEM    := {}

         AAdd( sqlARQUI, { "AKAR00", "AKAR00" } )
         AAdd( sqlCAMPO, "*" )
         AAdd( sqlRELATION, { "AFIS00", "KARFISN", "AFIS00.FISNOV" } )
         AAdd( sqlRELATION, { "ASLD00", StrZero( ME_EMP, 2 ), "ASLD00.SLDEMP" } )
         AAdd( sqlRELATION, { "", "ASLD00.SLDMAT", "AKAR00.KARMAT" } )
         AAdd( sqlCHAVE, "KARDTA BETWEEN " + aspas( formatdta( dDtaIni ) ) + " AND " + aspas( formatdta( M_DTA2 ) ) )
         AAdd( sqlCHAVE, "KAREMP = " + StrZero( ME_EMP, 2 ) )
         AAdd( sqlCHAVE, "KARMAT = " + Str( APCA00->PCAMAT, 6 ) )
         AAdd( sqlORDEM, "KARDTA,KARFISN" )
         sqlrelation()

         DO WHILE !Eof()
            IF AKAR00->KARFISN $ "5.102#5.104#5.405#6.102#6.104#6.405#"
               SELECT ANESTLE
               IF !DbSeek( APCA00->PCAMAT )
                  APPEND BLANK
                  REPLACE PCAMAT WITH APCA00->PCAMAT
               ENDIF

               DO CASE
                  CASE nAbc == 1 ; REPLACE SLD30 WITH SLD30 + AKAR00->KARQDE
                  CASE nAbc == 2 ; REPLACE SLD60 WITH SLD60 + AKAR00->KARQDE
                  CASE nAbc == 3 ; REPLACE SLD90 WITH SLD90 + AKAR00->KARQDE
               ENDCASE
            ENDIF

            SELECT AKAR00
            DbSkip()
         ENDDO
      NEXT

      SELECT APCA00
      DbSkip()
   ENDDO

   SELECT ANESTLE

RETURN ""


***************
FUNCTION ATU_INVNESTLE()
***************
   LOCAL cArqSld := ""
   LOCAL M_SLD   := 0

   IF File( "PCALOC.CDX" )
      FErase( "PCALOC.CDX" )
   ENDIF
   IF File( "SLDINOVA.CDX" )
      FErase( "SLDINOVA.CDX" )
   ENDIF
   IF File( "SLDCIRUR.CDX" )
      FErase( "SLDCIRUR.CDX" )
   ENDIF

   sqlRELATION := {}
   sqlCAMPO    := {}
   sqlCHAVE    := {}
   sqlARQUI    := {}
   sqlORDEM    := {}

   AAdd( sqlARQUI, { "APCA00", "APCA00" } )
   AAdd( sqlCAMPO, "APCA00.*" )
   AAdd( sqlCAMPO, "ASLD00.SLDNESTLE as SALDONESTLE" )
   AAdd( sqlRELATION, { "ASLD00", StrZero( ME_EMP, 2 ), "ASLD00.SLDEMP" } )
   AAdd( sqlRELATION, { "", "ASLD00.SLDMAT", "APCA00.PCAMAT" } )
   AAdd( sqlCHAVE, "PCAFAB <> ''" )
   AAdd( sqlORDEM, "PCAMAT" )
   sqlrelation()

   IF AEMP00->EMPCGC == "037623347000109" // NUTRI INOVA
      SELECT APCA00
      cria_dbf( "SLDINOVA" )
      SELECT 0
      USE SLDINOVA EXCLUSIVE
      INDEX ON PCAFAB TAG 1 TO SLDINOVA
      cArqSld := "SLDINOVA"

      sqlRELATION := {}
      sqlCAMPO    := {}
      sqlCHAVE    := {}
      sqlARQUI    := {}
      sqlORDEM    := {}

      AAdd( sqlARQUI, { "ASLD00", "ASLD00" } )
      AAdd( sqlCAMPO, "ASLD00.SLDNESTLE" )
      AAdd( sqlCAMPO, "SLDMAT" )
      AAdd( sqlCHAVE, "ASLD00.SLDNESTLE > 0" )
      AAdd( sqlCHAVE, "APCA00.PCAFAB <> ''" )
      AAdd( sqlCAMPO, "APCA00.PCAFAB" )
      AAdd( sqlCAMPO, "APCA00.PCAUNI" )
      AAdd( sqlCAMPO, "APCA00.PCADES" )
      AAdd( sqlRELATION, { "APCA00", "ASLD00.SLDMAT", "APCA00.PCAMAT" } )
      sqlrelation()

      SELECT ASLD00
      Go Top
      DO WHILE !Eof()
         SELECT SLDINOVA
         IF !DbSeek( ASLD00->PCAFAB )
            APPEND BLANK
            REPLACE PCAFAB    WITH ASLD00->PCAFAB
            REPLACE PCAUNI    WITH ASLD00->PCAUNI
            REPLACE PCAMAT    WITH ASLD00->SLDMAT
            REPLACE SLDNESTLE WITH ASLD00->SLDNESTLE
            REPLACE PCADES    WITH ASLD00->PCADES
         ELSE
            REPLACE SLDNESTLE WITH SLDNESTLE + ASLD00->SLDNESTLE
         ENDIF
         SELECT ASLD00
         DbSkip()
      ENDDO
   ELSE // SALDO INICIAL CIRURCENTER
      SELECT APCA00
      cria_dbf( "SLDCIRUR" )
      SELECT 0
      USE SLDCIRUR EXCLUSIVE
      INDEX ON PCAFAB TAG 1 TO SLDCIRUR
      cArqSld := "SLDCIRUR"

      sqlRELATION := {}
      sqlCAMPO    := {}
      sqlCHAVE    := {}
      sqlARQUI    := {}
      sqlORDEM    := {}

      AAdd( sqlARQUI, { "ASLD00", "ASLD00" } )
      AAdd( sqlCAMPO, "ASLD00.SLDNESTLE" )
      AAdd( sqlCAMPO, "SLDMAT" )
      AAdd( sqlCHAVE, "ASLD00.SLDNESTLE > 0" )
      AAdd( sqlCHAVE, "APCA00.PCAFAB <> ''" )
      AAdd( sqlCAMPO, "APCA00.PCAFAB" )
      AAdd( sqlCAMPO, "APCA00.PCAUNI" )
      AAdd( sqlCAMPO, "APCA00.PCADES" )
      AAdd( sqlRELATION, { "APCA00", "ASLD00.SLDMAT", "APCA00.PCAMAT" } )
      sqlrelation()

      SELECT ASLD00
      Go Top
      DO WHILE !Eof()
         SELECT SLDCIRUR
         IF !DbSeek( ASLD00->PCAFAB )
            APPEND BLANK
            REPLACE PCAFAB    WITH ASLD00->PCAFAB
            REPLACE PCAUNI    WITH ASLD00->PCAUNI
            REPLACE PCAMAT    WITH ASLD00->SLDMAT
            REPLACE SLDNESTLE WITH ASLD00->SLDNESTLE
            REPLACE PCADES    WITH ASLD00->PCADES
         ELSE
            REPLACE SLDNESTLE WITH SLDNESTLE + ASLD00->SLDNESTLE
         ENDIF
         SELECT ASLD00
         DbSkip()
      ENDDO
   ENDIF

   msw( "* * * P R O C E S S A N D O * * *" )

   SELECT APCA00
   Go Top

   DO WHILE !Eof()
      msw( "* * * AGUARDE ... PROCESSANDO: " + Transform( APCA00->PCAMAT, "@E ###,###" ) + " * * *" )

      M_SLD := 0
      SELECT ( cArqSld )
      IF DbSeek( APCA00->PCAFAB )
         M_SLD := SLDNESTLE
      ENDIF

      sqlRELATION := {}
      sqlCAMPO    := {}
      sqlCHAVE    := {}
      sqlARQUI    := {}
      sqlORDEM    := {}

      AAdd( sqlARQUI, { "AKAR00", "AKAR00" } )
      AAdd( sqlCAMPO, "AKAR00.*" )
      AAdd( sqlCAMPO, "AFIS00.FISEST" )
      AAdd( sqlRELATION, { "AFIS00", "KARFISN", "AFIS00.FISNOV" } )
      AAdd( sqlRELATION, { "ASLD00", StrZero( ME_EMP, 2 ), "ASLD00.SLDEMP" } )
      AAdd( sqlRELATION, { "", "ASLD00.SLDMAT", "AKAR00.KARMAT" } )

      IF AEMP00->EMPCGC == "037623347000109"
         AAdd( sqlCHAVE, "KAREMP IN (2)" )
      ELSE
         AAdd( sqlCHAVE, "KAREMP IN (1,10)" )
      ENDIF

      AAdd( sqlCHAVE, "KAREMP = " + StrZero( ME_EMP, 2 ) )
      AAdd( sqlCHAVE, "KARMAT = " + Str( APCA00->PCAMAT, 6 ) )
      AAdd( sqlCHAVE, "KARDTA >= " + aspas( formatdta( CToD( "01/09/2024" ) ) ) )
      AAdd( sqlORDEM, "KARDTA,KARFISN" )
      sqlrelation()

      DO WHILE !Eof()
         SELECT AKAR00
         calc_sldmed()
         DbSkip()
      ENDDO

      SELECT ( cArqSld )
      IF !DbSeek( APCA00->PCAFAB )
         APPEND BLANK
         REPLACE PCAFAB    WITH APCA00->PCAFAB
         REPLACE PCAUNI    WITH APCA00->PCAUNI
         REPLACE PCAMAT    WITH APCA00->PCAMAT
         REPLACE PCADES    WITH APCA00->PCADES
         REPLACE SLDNESTLE WITH M_SLD
      ELSE
         REPLACE SLDNESTLE WITH M_SLD
      ENDIF

      SELECT APCA00
      DbSkip()
   ENDDO

RETURN ""


***************
FUNCTION NESTLEPRE() // Versão de Homologação / Desenvolvimento com Excel
***************
   LOCAL oExcel, oAS, oHttp1
   LOCAL cUrlGra, cJson, xNome, xSold, xKey
   LOCAL nLin := 3, nVendas := 0, nDiaEst := 0

   TRY
      oExcel := GetActiveObject( "Excel.Application" )
   CATCH
      TRY
         oExcel := CreateObject( "Excel.Application" )
      CATCH
         Alert( "ERROR! Excel nao disponivel no ambiente." )
         RETURN NIL
      END
   END

   oExcel:WorkBooks:Add()
   oAS := oExcel:ActiveSheet()
   oAS:Cells:Font:Name := "Arial"
   oAS:Cells:Font:Size := 12

   oAS:Cells[ 1,  1 ] := "RAZAO SOCIAL"
   oAS:Cells[ 2,  1 ] := "CNPJ"
   oAS:Cells[ 3,  1 ] := "CLIENTE"
   oAS:Cells[ 4,  1 ] := "ENDERECO"
   oAS:Cells[ 5,  1 ] := "CEP"
   oAS:Cells[ 6,  1 ] := "CIDADE"
   oAS:Cells[ 7,  1 ] := "UF"
   oAS:Cells[ 8,  1 ] := "SEGMENTO"
   oAS:Cells[ 9,  1 ] := "NOTA FISCAL"
   oAS:Cells[ 10, 1 ] := "DATA"
   oAS:Cells[ 11, 1 ] := "CODIGO NESTLE"
   oAS:Cells[ 12, 1 ] := "DESCRICAO"
   oAS:Cells[ 13, 1 ] := "QDE VENDA"
   oAS:Cells[ 14, 1 ] := "UN"

   xNome := AEMP00->EMPNOM
   xSold := AEMP00->EMPSOLD
   xKey  := AEMP00->EMPKEY

   fecha_arq()

   IF File( "ANESTLE.CDX" )
      FErase( "ANESTLE.CDX" )
   ENDIF
   IF File( "ANESTI.CDX" )
      FErase( "ANESTI.CDX" )
   ENDIF
   IF File( "ANESTV.CDX" )
      FErase( "ANESTV.CDX" )
   ENDIF

   SELECT 0
   USE &_PATH_\USR\ESTOQUE\ANESTLE EXCLUSIVE
   ZAP
   INDEX ON PCAMAT TO ANESTLE

   seexistesql( "ANFS01" )
   cSQL := "SELECT FIRST 1 * FROM ANFS01"
   dbusearea( .T., "SQLMIX", cSQL, "ANFS01" )
   cria_dbf( "ANESTI" )
   SELECT 0
   USE ANESTI
   INDEX ON Str( NFSMAT, 6 ) TO ANESTI

   SELECT ANFS01
   COPY STRUCTURE TO ANESTV
   SELECT ANFS01
   COPY STRUCTURE TO ASALDO

   SELECT 0
   USE ASALDO EXCLUSIVE
   INDEX ON Str( NFSMAT, 6 ) TO ASALDO

   SELECT 0
   USE ANESTV
   INDEX ON Str( NFSMAT, 6 ) TO ANESTV

   M_DTA1 := CToD( "  /  /  " )
   M_DTA2 := CToD( "  /  /  " )

   sombra( 14, 41, 17, 73, _SOMBRA_ )
   SetColor( "GR/W" )
   @ 14, 41 SAY "Ŀ"
   @ 15, 41 SAY "   Data Emissao Inicial:           "
   @ 16, 41 SAY "                  Final:           "
   @ 17, 41 SAY ""
   SetColor( _COREDICAO_ )
   @ 15, 67 GET M_DTA1 VALID !Empty( M_DTA1 )
   @ 16, 67 GET M_DTA2 VALID !Empty( M_DTA2 )
   READ
   SetColor( "" )

   IF LastKey() == K_ESC
      RETURN ""
   ENDIF

   ATU_INVNESTLE()
   ATU_NESTLE()

   SELECT APCA00
   Go Top

   DO WHILE !Eof()
      nVendas := 0
      SELECT ANESTV
      IF DbSeek( Str( APCA00->PCAMAT, 6 ) )
         nVendas := NFSQDE
      ENDIF

      nDiaEst := Int( APCA00->SLD51 / IIf( nVendas > 0, nVendas, 1 ) )

      SELECT APCA00
      IF Val( APCA00->PCAFAB ) == 0 .OR. APCA00->SLD51 < 0
         DbSkip()
         LOOP
      ENDIF

      msw( APCA00->PCADES )

      cJson := '{"secrectKeyDistribuidora":"' + NESTLE_SafeJsonStr( xKey ) + '",' + ;
               '"soldDistribuidor":' + LTrim( Str( xSold ) ) + ',' + ;
               '"grupoDistribuidor":"Nutri Inova",' + ;
               '"nomeDistribuidor":"' + NESTLE_SafeJsonStr( xNome ) + '",' + ;
               '"periodoRef":"' + FORDTA( M_DTA1 ) + '",' + ;
               '"produtos":[{' + ;
               '"codProdutoNestle_CodEAN":' + AllTrim( APCA00->PCAFAB ) + ',' + ;
               '"nomeProduto":"' + NESTLE_SafeJsonStr( APCA00->PCADES ) + '",' + ;
               '"unidades":' + LTrim( Str( APCA00->SLD51 ) ) + ',' + ;
               '"unidadeMedida":"' + AllTrim( APCA00->PCAUNI ) + '",' + ;
               '"diasDeEstoque":' + LTrim( Str( nDiaEst ) ) + ',' + ;
               '"fator":1}]}'

      cUrlGra := "https://apinestleselloutintegracaodev.magically.com.br/api/Inventario"
      oHttp1  := CreateObject( "Msxml2.ServerXMLHTTP.6.0" )
      oHttp1:Open( "POST", cUrlGra, .F. )
      oHttp1:setRequestHeader( "Accept", "application/json" )
      oHttp1:setRequestHeader( "x-api-version", "1.0" )
      oHttp1:setRequestHeader( "Content-Type", "application/json-patch+json" )
      oHttp1:Send( cJson )

      IF oHttp1:status != 200
         IF oHttp1:status != 400
            Alert( AllTrim( Str( oHttp1:status ) ) + " - " + oHttp1:statusText, "Erro na requisicao HTTP" )
            RETURN NIL
         ENDIF
      ENDIF

      SELECT APCA00
      DbSkip()
   ENDDO

   oAS:Columns( 1 ):AutoFit()
   oAS:Columns( 2 ):AutoFit()
   oAS:Columns( 3 ):AutoFit()
   oAS:Columns( 4 ):AutoFit()
   oAS:Columns( 5 ):AutoFit()
   oAS:Columns( 6 ):AutoFit()
   oAS:Columns( 7 ):AutoFit()
   oAS:Columns( 8 ):AutoFit()
   oAS:Columns( 9 ):AutoFit()
   oAS:Columns( 10 ):AutoFit()
   oAS:Columns( 11 ):AutoFit()
   oAS:Columns( 12 ):AutoFit()
   oAS:Columns( 13 ):AutoFit()

   oExcel:Visible := .T.

RETURN ""


***************
FUNCTION NESTLE() // Versão de Produção (Sem Excel, API Prod)
***************
   LOCAL oHttp1
   LOCAL cUrlGra, cJson, xNome, xSold, xKey
   LOCAL nVendas := 0, nDiaEst := 0

   xNome := AEMP00->EMPNOM
   xSold := AEMP00->EMPSOLD
   xKey  := AEMP00->EMPKEY

   fecha_arq()

   IF File( "ANESTLE.CDX" )
      FErase( "ANESTLE.CDX" )
   ENDIF
   IF File( "ANESTI.CDX" )
      FErase( "ANESTI.CDX" )
   ENDIF
   IF File( "ANESTV.CDX" )
      FErase( "ANESTV.CDX" )
   ENDIF

   SELECT 0
   USE &_PATH_\USR\ESTOQUE\ANESTLE EXCLUSIVE
   ZAP
   INDEX ON PCAMAT TO ANESTLE

   seexistesql( "ANFS01" )
   cSQL := "SELECT FIRST 1 * FROM ANFS01"
   dbusearea( .T., "SQLMIX", cSQL, "ANFS01" )
   cria_dbf( "ANESTI" )
   SELECT 0
   USE ANESTI
   INDEX ON Str( NFSMAT, 6 ) TO ANESTI

   SELECT ANFS01
   COPY STRUCTURE TO ANESTV
   SELECT ANFS01
   COPY STRUCTURE TO ASOMAV

   SELECT 0
   USE ASOMAV EXCLUSIVE
   INDEX ON Str( NFSMAT, 6 ) TO ASOMAV

   SELECT 0
   USE ANESTV
   INDEX ON Str( NFSMAT, 6 ) TO ANESTV

   M_DTA1 := CToD( "  /  /  " )
   M_DTA2 := CToD( "  /  /  " )

   sombra( 14, 41, 17, 73, _SOMBRA_ )
   SetColor( "GR/W" )
   @ 14, 41 SAY "Ŀ"
   @ 15, 41 SAY "   Data Emissao Inicial:           "
   @ 16, 41 SAY "                  Final:           "
   @ 17, 41 SAY ""
   SetColor( _COREDICAO_ )
   @ 15, 67 GET M_DTA1 VALID !Empty( M_DTA1 )
   @ 16, 67 GET M_DTA2 VALID !Empty( M_DTA2 )
   READ
   SetColor( "" )

   IF LastKey() == K_ESC
      RETURN ""
   ENDIF

   ATU_INVNESTLE()
   ATU_NESTLE()

   SELECT APCA00
   Go Top

   DO WHILE !Eof()
      nVendas := 0
      SELECT ANESTV
      IF DbSeek( Str( APCA00->PCAMAT, 6 ) )
         nVendas := NFSQDE
      ENDIF

      nDiaEst := Int( APCA00->SLD51 / IIf( nVendas > 0, nVendas, 1 ) )

      SELECT APCA00
      IF Val( APCA00->PCAFAB ) == 0 .OR. APCA00->SLD51 < 0
         DbSkip()
         LOOP
      ENDIF

      msw( APCA00->PCADES )

      cJson := '{"secrectKeyDistribuidora":"' + NESTLE_SafeJsonStr( xKey ) + '",' + ;
               '"soldDistribuidor":' + LTrim( Str( xSold ) ) + ',' + ;
               '"grupoDistribuidor":"Nutri Inova",' + ;
               '"nomeDistribuidor":"' + NESTLE_SafeJsonStr( xNome ) + '",' + ;
               '"periodoRef":"' + FORDTA( M_DTA1 ) + '",' + ;
               '"produtos":[{' + ;
               '"codProdutoNestle_CodEAN":' + AllTrim( APCA00->PCAFAB ) + ',' + ;
               '"nomeProduto":"' + NESTLE_SafeJsonStr( APCA00->PCADES ) + '",' + ;
               '"unidades":' + LTrim( Str( APCA00->SLD51 ) ) + ',' + ;
               '"unidadeMedida":"' + AllTrim( APCA00->PCAUNI ) + '",' + ;
               '"diasDeEstoque":' + LTrim( Str( nDiaEst ) ) + ',' + ;
               '"fator":1}]}'

      cUrlGra := "https://apinestleselloutintegracaoprod.magically.com.br/api/Inventario"
      oHttp1  := CreateObject( "Msxml2.ServerXMLHTTP.6.0" )
      oHttp1:Open( "POST", cUrlGra, .F. )
      oHttp1:setRequestHeader( "Accept", "application/json" )
      oHttp1:setRequestHeader( "x-api-version", "1.0" )
      oHttp1:setRequestHeader( "Content-Type", "application/json-patch+json" )
      oHttp1:Send( cJson )

      IF oHttp1:status != 200
         IF oHttp1:status != 400
            Alert( AllTrim( Str( oHttp1:status ) ) + " - " + oHttp1:statusText, "Erro na requisicao HTTP Prod" )
            RETURN NIL
         ENDIF
      ENDIF

      SELECT APCA00
      DbSkip()
   ENDDO

   msg( "* * * ENVIO DE INVENTARIO NESTLE PROD CONCLUIDO * * *" )

RETURN ""


***************
FUNCTION NESTLE_SafeJsonStr( cStr )
***************
   LOCAL cRet := AllTrim( cStr )
   cRet := StrTran( cRet, '\', '\\' )
   cRet := StrTran( cRet, '"', '\"' )
   cRet := StrTran( cRet, Chr(13), '' )
   cRet := StrTran( cRet, Chr(10), '' )
   cRet := StrTran( cRet, Chr(9), ' ' )
RETURN cRet
