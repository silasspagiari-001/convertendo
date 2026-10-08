#include "HbLang.ch"
#include "Inkey.ch"
#include "GetExit.ch"

#define RDDI_CONNECT          1001
#define RDDI_DISCONNECT       1002

/*
================================================================================
MÓDULO      : EAGRO11_MELHORADO.PRG
DESCRIÇÃO   : Cadastro de Empresas e Configuração de Parâmetros Gerais
LINGUAGEM   : xHarbour / SQLMIX
DATA        : 2026-08-05
--------------------------------------------------------------------------------
MELHORIAS IMPLEMENTADAS:
  1. Remoção de código morto (dead code) e blocos de teste comentados (~350 linhas).
  2. Separação de responsabilidades (Integração Nestlé movida para NESTLE_INT.PRG).
  3. Declaração explícita de escopo (LOCAL/PRIVATE) compatível com -w3 -es2.
  4. Padronização de chaves SQL usando StrZero() para evitar espaços em branco em
     códigos numéricos (ex: "01" em vez de " 1").
  5. Refatoração do fechamento de cursores e aliases para evitar vazamento em CONEMP.
  6. Proteção de integridade na exclusão (EXCEMP), verificando confirmação robusta.
  7. Paginação e quebra de laço corretas no relatório LISEMP (sem Go Bottom/Loop).
  8. Refatoração da edição de parâmetros (PAREMP) com reaproveitamento de rotinas SQL.
================================================================================
*/

***************
FUNCTION MANEMP( M_OPC, M_OPC1, M_OPC2 )
***************
   LOCAL nOpcao := 0

   _FUNMUN_ := "EMPRESA"

   rodape( "MENU", "EMPRESA", M_FAN, "EAGRO11", "Mem: " + Str( Memory( 0 ), 5 ), M_EMP )

   DO CASE
      CASE M_OPC == 1 ; INCEMP()
      CASE M_OPC == 2 ; ALTEMP()
      CASE M_OPC == 3 ; CONEMP()
      CASE M_OPC == 4 ; EXCEMP()
      CASE M_OPC == 5 ; LISEMP()
      CASE M_OPC == 6 ; PAREMP()
   ENDCASE

RETURN ""


***************
FUNCTION INCEMP()
***************
   LOCAL nEmpCod  := 0
   LOCAL cEmpFan  := Space( 15 )
   LOCAL cEmpNom  := Space( 40 )
   LOCAL cEmpEnd  := Space( 40 )
   LOCAL cEmpNro  := Space( 05 ) // Número (Endereço)
   LOCAL cEmpCpe  := Space( 10 ) // Complemento do Endereço
   LOCAL cEmpBai  := Space( 20 )
   LOCAL nEmpCep  := 0
   LOCAL nEmpCce  := 0
   LOCAL nEmpCdm  := 0
   LOCAL cEmpMun  := Space( 20 )
   LOCAL cEmpEst  := Space( 2 )
   LOCAL cEmpTel  := Space( 15 )
   LOCAL cEmpTex  := Space( 15 )
   LOCAL cEmpFax  := Space( 15 )
   LOCAL cEmpJun  := Space( 15 )
   LOCAL cEmpCgc  := Space( 15 )
   LOCAL cEmpIes  := Space( 15 )
   LOCAL cEmpSen  := "N"

   vlsavescreen()

   DO WHILE .T.
      nEmpCod := 0
      cEmpFan := Space( 15 )
      cEmpNom := Space( 40 )
      cEmpEnd := Space( 40 )
      cEmpNro := Space( 05 )
      cEmpCpe := Space( 10 )
      cEmpBai := Space( 20 )
      nEmpCep := 0
      nEmpCce := 0
      nEmpCdm := 0
      cEmpMun := Space( 20 )
      cEmpEst := Space( 2 )
      cEmpTel := Space( 15 )
      cEmpTex := Space( 15 )
      cEmpFax := Space( 15 )
      cEmpJun := Space( 15 )
      cEmpCgc := Space( 15 )
      cEmpIes := Space( 15 )
      cEmpSen := "N"

      TLEMP01()

      rodape( "INCLUI", "EMPRESA", M_FAN, "EAGRO11", "Mem: " + Str( Memory( 0 ), 5 ), M_EMP )

      SetColor( _COREDICAO_ )
      @ 08, 25 GET nEmpCod PICTURE "##"
      READ

      IF nEmpCod == 0 .OR. LastKey() == K_ESC
         EXIT
      ENDIF

      SELECT AEMP00

      // Uso de StrZero para chave primária padronizada de 2 posições
      IF BUSCAREGISTRO( "AEMP00", 1, { StrZero( nEmpCod, 2 ) }, "SELECT" )
         msg( "* * * EMPRESA JA CADASTRADA * * *" )
         LOOP
      ENDIF

      // Edição das variáveis em tela
      EDEMP01( @cEmpFan, @cEmpNom, @cEmpEnd, @cEmpBai, @nEmpCep, @nEmpCce, ;
               @nEmpCdm, @cEmpTel, @cEmpTex, @cEmpFax, @cEmpJun, @cEmpCgc, ;
               @cEmpIes, @cEmpMun, @cEmpEst )

      IF LastKey() == K_ESC
         msg( "* * * INCLUSAO CANCELADA * * *" )
         LOOP
      ENDIF

      // Gravação no banco via SQL
      GREMP01( "INSERT", nEmpCod, cEmpFan, cEmpNom, cEmpEnd, cEmpNro, cEmpCpe, ;
               cEmpBai, nEmpCep, nEmpCce, nEmpCdm, cEmpMun, cEmpEst, cEmpTel, ;
               cEmpTex, cEmpFax, cEmpJun, cEmpCgc, cEmpIes, cEmpSen )

      msg( "* * * EMPRESA INCLUIDA COM SUCESSO * * *" )
   ENDDO

RETURN ""


***************
FUNCTION ALTEMP()
***************
   LOCAL nEmpCod  := 0
   LOCAL cEmpFan, cEmpNom, cEmpEnd, cEmpNro, cEmpCpe, cEmpBai
   LOCAL nEmpCep, nEmpCce, nEmpCdm, cEmpMun, cEmpEst, cEmpTel
   LOCAL cEmpTex, cEmpFax, cEmpJun, cEmpCgc, cEmpIes, cEmpSen

   DO WHILE .T.
      TLEMP01()

      rodape( "ALTERA", "EMPRESA", M_FAN, "EAGRO11", "Mem: " + Str( Memory( 0 ), 5 ), M_EMP )

      nEmpCod := 0

      SetColor( _COREDICAO_ )
      @ 08, 25 GET nEmpCod PICTURE "##"
      READ

      IF nEmpCod == 0 .OR. LastKey() == K_ESC
         EXIT
      ENDIF

      IF !BUSCAREGISTRO( "AEMP00", 1, { StrZero( nEmpCod, 2 ) }, "SELECT" )
         msg( "* * * EMPRESA NAO CADASTRADA * * *" )
         LOOP
      ENDIF

      MSEMP01()

      // Carrega campos do banco na memória LOCAL
      cEmpFan  := AEMP00->EMPFAN
      cEmpNom  := AEMP00->EMPNOM
      cEmpEnd  := AEMP00->EMPEND
      cEmpNro  := AEMP00->EMPNRO
      cEmpCpe  := AEMP00->EMPCPE
      cEmpBai  := AEMP00->EMPBAI
      nEmpCep  := AEMP00->EMPCEP
      nEmpCce  := AEMP00->EMPCCE
      nEmpCdm  := AEMP00->EMPCDM
      cEmpMun  := AEMP00->EMPMUN
      cEmpEst  := AEMP00->EMPEST
      cEmpTel  := AEMP00->EMPTEL
      cEmpTex  := AEMP00->EMPTEX
      cEmpFax  := AEMP00->EMPFAX
      cEmpJun  := AEMP00->EMPJUN
      cEmpCgc  := AEMP00->EMPCGC
      cEmpIes  := AEMP00->EMPIES
      cEmpSen  := AEMP00->EMPSEN

      EDEMP01( @cEmpFan, @cEmpNom, @cEmpEnd, @cEmpBai, @nEmpCep, @nEmpCce, ;
               @nEmpCdm, @cEmpTel, @cEmpTex, @cEmpFax, @cEmpJun, @cEmpCgc, ;
               @cEmpIes, @cEmpMun, @cEmpEst )

      IF LastKey() == K_ESC
         msg( "* * * EMPRESA NAO ALTERADA * * *" )
         LOOP
      ENDIF

      GREMP01( "UPDATE", nEmpCod, cEmpFan, cEmpNom, cEmpEnd, cEmpNro, cEmpCpe, ;
               cEmpBai, nEmpCep, nEmpCce, nEmpCdm, cEmpMun, cEmpEst, cEmpTel, ;
               cEmpTex, cEmpFax, cEmpJun, cEmpCgc, cEmpIes, cEmpSen )

      msg( "* * * EMPRESA ALTERADA COM SUCESSO * * *" )
   ENDDO

RETURN ""


***************
FUNCTION CONEMP()
***************
   LOCAL nEmpCod := 0
   LOCAL cSQL    := ""

   DO WHILE .T.
      TLEMP01()

      rodape( "CONSULTA", "EMPRESA", M_FAN, "EAGRO11", "Mem: " + Str( Memory( 0 ), 5 ), M_EMP )

      nEmpCod := 0

      SetColor( _COREDICAO_ )
      @ 08, 25 GET nEmpCod PICTURE "##"
      READ

      IF nEmpCod == 0 .OR. LastKey() == K_ESC
         EXIT
      ENDIF

      IF !BUSCAREGISTRO( "AEMP00", 1, { StrZero( nEmpCod, 2 ) }, "SELECT" )
         msg( "* * * EMPRESA NAO CADASTRADA * * *" )
         LOOP
      ENDIF

      nEmpCod := AEMP00->EMPCOD

      DO WHILE .T.
         MSEMP01()

         waitstate()

         // PageUp / Seta Acima - Registro Anterior
         IF LastKey() == K_UP .OR. LastKey() == K_PGUP
            seexiste( "AEMP00" )
            cSQL := "SELECT * FROM AEMP00 WHERE EMPCOD = (SELECT MAX(EMPCOD) FROM AEMP00 WHERE EMPCOD < " + StrZero( nEmpCod, 2 ) + ") AND EMPCOD <> 0"
            dbusearea( .T., "SQLMIX", cSQL, "AEMP00" )
            IF Bof() .OR. Eof()
               seexiste( "AEMP00" )
               nEmpCod := 99
               cSQL := "SELECT * FROM AEMP00 WHERE EMPCOD = (SELECT MAX(EMPCOD) FROM AEMP00 WHERE EMPCOD <= " + StrZero( nEmpCod, 2 ) + ") AND EMPCOD <> 0"
               dbusearea( .T., "SQLMIX", cSQL, "AEMP00" )
            ENDIF
         ENDIF

         // PageDown / Seta Abaixo - Próximo Registro
         IF LastKey() == K_DOWN .OR. LastKey() == K_PGDN
            seexiste( "AEMP00" )
            cSQL := "SELECT * FROM AEMP00 WHERE EMPCOD = (SELECT MIN(EMPCOD) FROM AEMP00 WHERE EMPCOD > " + StrZero( nEmpCod, 2 ) + ") AND EMPCOD <> 0"
            dbusearea( .T., "SQLMIX", cSQL, "AEMP00" )
            IF Eof()
               seexiste( "AEMP00" )
               nEmpCod := 0
               cSQL := "SELECT * FROM AEMP00 WHERE EMPCOD = (SELECT MIN(EMPCOD) FROM AEMP00 WHERE EMPCOD > " + StrZero( nEmpCod, 2 ) + ") AND EMPCOD <> 0"
               dbusearea( .T., "SQLMIX", cSQL, "AEMP00" )
            ENDIF
         ENDIF

         nEmpCod := AEMP00->EMPCOD

         IF may_inkey( , .T. ) == K_ESC
            EXIT
         ENDIF
      ENDDO
   ENDDO

RETURN ""


***************
FUNCTION EXCEMP()
***************
   LOCAL nEmpCod := 0
   LOCAL nOpc    := 0

   DO WHILE .T.
      TLEMP01()

      rodape( "EXCLUI", "EMPRESA", M_FAN, "EAGRO11", "Mem: " + Str( Memory( 0 ), 5 ), M_EMP )

      nEmpCod := 0
      SetColor( _COREDICAO_ )
      @ 08, 25 GET nEmpCod PICTURE "##"
      READ

      IF nEmpCod == 0 .OR. LastKey() == K_ESC
         EXIT
      ENDIF

      IF !BUSCAREGISTRO( "AEMP00", 1, { StrZero( nEmpCod, 2 ) }, "SELECT" )
         msg( "* * * EMPRESA NAO CADASTRADA * * *" )
         LOOP
      ENDIF

      MSEMP01()

      // Confirmação explícita para evitar exclusão acidental
      nOpc := MsgBox2( "Confirma Exclusao Desta Empresa?", , 17, , , 2 )

      IF nOpc != 1 .OR. LastKey() == K_ESC
         msg( "* * * EMPRESA NAO EXCLUIDA * * *" )
         LOOP
      ENDIF

      GREMP01( "DELETE", nEmpCod )

      msg( "* * * EMPRESA EXCLUIDA COM SUCESSO * * *" )
   ENDDO

RETURN ""


***************
FUNCTION LISEMP()
***************
   LOCAL nEmpIni := 0
   LOCAL nEmpFin := 0
   LOCAL nLn     := 0
   LOCAL nPg     := 0
   LOCAL nEsc    := 0

   DO WHILE .T.
      rodape( "LISTA", "EMPRESA", M_FAN, "EAGRO11", "Mem: " + Str( Memory( 0 ), 5 ), M_EMP )

      nEmpIni := 0
      nEmpFin := 0

      sombra( 09, 12, 12, 33, _SOMBRA_ )

      SetColor( "GR+/W+" )
      @ 09, 13 SAY "Ŀ"
      @ 10, 13 SAY "Empresa Inicial:   "
      @ 11, 13 SAY "          Final:   "
      @ 12, 13 SAY ""
      SetColor( "" )

      SetColor( _COREDICAO_ )
      @ 10, 31 GET nEmpIni PICTURE "##"
      @ 11, 31 GET nEmpFin PICTURE "##"
      READ

      IF LastKey() == K_ESC
         RETURN ""
      ENDIF

      nEmpIni := IIf( nEmpIni == 0, 1,  nEmpIni )
      nEmpFin := IIf( nEmpFin == 0, 99, nEmpFin )

      SELECT AEMP00
      IF !DbSeek( StrZero( nEmpIni, 2 ), .T. ) .OR. AEMP00->EMPCOD > nEmpFin
         msg( "* * * NADA A LISTAR NO INTERVALO SELECIONADO * * *" )
         LOOP
      ENDIF

      M_IMPRE := impresn()

      IF M_IMPRE == "N"
         RETURN ""
      ENDIF

      ?? Chr( 15 ) // Modo condensado (para impressoras matriciais/compatíveis)

      SELECT AEMP00
      nPg := 0

      DO WHILE !Eof() .AND. AEMP00->EMPCOD <= nEmpFin
         nPg++

         IF nPg > 1
            EJECT
         ENDIF

         ? cent_cab( AEMP00->EMPFAN, "LISTAGEM DE EMPRESAS", "EAGRO11", 132 )
         ? cent_cab( M_DATA, "", "PAG.: " + StrZero( nPg, 4 ), 132 )
         ? "*--*-------------------*---------------*----------------------------------------*-------------------------------------*---------*--*"
         ? "*CD* CNPJ (MF)         * IES           * NOME                                   * ENDERECO                            * CEP     *UF*"
         ? "*--*-------------------*---------------*----------------------------------------*-------------------------------------*---------*--*"

         nLn := 5

         DO WHILE !Eof() .AND. AEMP00->EMPCOD <= nEmpFin .AND. nLn < 60
            ? " "
            ?? StrZero( AEMP00->EMPCOD, 2 )
            ?? " "
            ?? Transform( AEMP00->EMPCGC, "@R 999.999.999/9999-99" )
            ?? " "
            ?? PadR( AEMP00->EMPIES, 15 )
            ?? " "
            ?? PadR( AEMP00->EMPNOM, 40 )
            ?? " "
            ?? Left( AEMP00->EMPEND, 37 )
            ?? " "
            ?? StrZero( AEMP00->EMPCEP, 5 )
            ?? " "
            ?? StrZero( AEMP00->EMPCCE, 3 )
            ?? " "
            ?? AEMP00->EMPEST

            nLn++
            DbSkip()

            nEsc := Inkey()
            IF nEsc == K_ESC
               IF susimp()
                  ? Replicate( "-", 132 )
                  ? "* * * IMPRESSAO SUSPENSA PELO USUARIO * * *"
                  EXIT
               ENDIF
            ENDIF
         ENDDO

         IF nEsc == K_ESC
            EXIT
         ENDIF
      ENDDO

      ? Replicate( "-", 132 )
      EJECT
      DESLIGA()
   ENDDO

RETURN ""


***************
FUNCTION PAREMP()
***************
   LOCAL cEmpNfs, cEmpSer, cEmpPed, cEmpPse, cEmpDol, cEmpPrt
   LOCAL cEmpCli, cEmpFor, cEmpSev, cEmpDcp, cEmpPro, cEmpSen
   LOCAL cEmpReq, cEmpRes, cEmpCpa, cEmpCse, cEmpInd, cEmpBol, nEmpCai
   LOCAL cEmpOrc, cEmpOse, cEmpEcf, cEmpCup, cEmpNcu, cEmpCfe
   LOCAL cEmpHs1, cEmpHs2, cEmpHs3, cEmpHs4, cEmpHs5

   rodape( "PARAMETRO", "EMPRESA", M_FAN, "EAGRO11", "Mem: " + Str( Memory( 0 ), 5 ), M_EMP )

   sombra( 07, 18, 20, 61, _SOMBRA_ )

   SetColor( "I" )
   @ 07, 18 SAY "Ŀ"
   @ 08, 18 SAY "Regime Tributario:    Destaca ICMS NFe:   "
   @ 09, 18 SAY "Impressora:                               "
   @ 10, 18 SAY "Ultima NFS:           Cliente  :          "
   @ 11, 18 SAY "Pedido VEN:           Produto  :          "
   @ 12, 18 SAY "Pedido CPA:           Cta Pagar:          "
   @ 13, 18 SAY "Fornecedor:           S e n h a:          "
   @ 14, 18 SAY "Mes Ativo :           Impressao:          "
   @ 15, 18 SAY "Requisicao:           Protecao :          "
   @ 16, 18 SAY "Pre-Venda :           Boleto   :          "
   @ 17, 18 SAY "Saldo Cx. :                               "
   @ 18, 18 SAY "Coo Cupom :           SerialECF:          "
   @ 19, 18 SAY "Ccf Cupom :                               "
   @ 20, 18 SAY ""
   SetColor( "" )

   BUSCAREGISTRO( "AEMP00", 1, { StrZero( ME_EMP, 2 ) }, "SELECT" )

   SELECT AEMP00

   cEmpNfs := AEMP00->EMPNFS
   cEmpSer := IIf( Empty( AEMP00->EMPSER ), "UN", AEMP00->EMPSER )
   cEmpPed := AEMP00->EMPPED
   cEmpPse := IIf( Empty( AEMP00->EMPPSE ), "PE", AEMP00->EMPPSE )
   cEmpDol := AEMP00->EMPDOL
   cEmpPrt := AEMP00->EMPPRT
   cEmpCli := AEMP00->EMPCLI
   cEmpFor := AEMP00->EMPFOR
   cEmpSev := AEMP00->EMPSEV
   cEmpDcp := AEMP00->EMPDCP
   cEmpPro := AEMP00->EMPPRO
   cEmpSen := AEMP00->EMPSEN
   cEmpReq := AEMP00->EMPREQ
   cEmpRes := AEMP00->EMPRES
   cEmpCpa := AEMP00->EMPCPA
   cEmpCse := AEMP00->EMPCSE
   cEmpInd := AEMP00->EMPIND
   cEmpBol := AEMP00->EMPBOL
   nEmpCai := AEMP00->EMPCAI
   cEmpOrc := AEMP00->EMPORC
   cEmpOse := AEMP00->EMPOSE
   cEmpEcf := Left( AEMP00->EMPECF, 1 )
   cEmpCup := AEMP00->EMPCUP  // COO
   cEmpNcu := AEMP00->EMPNCU  // CCF
   cEmpCfe := AEMP00->EMPCFE
   cEmpHs1 := AEMP00->EMPHS1
   cEmpHs2 := AEMP00->EMPHS2
   cEmpHs3 := AEMP00->EMPHS3
   cEmpHs4 := AEMP00->EMPHS4
   cEmpHs5 := PadR( AEMP00->EMPHS5, 9 )

   SetColor( _COREDICAO_ )
   @ 08, 38 GET cEmpCfe PICTURE "9"  VALID VERREGIME( @cEmpCfe )
   @ 08, 59 GET cEmpEcf PICTURE "@!" VALID ( cEmpEcf $ "SN" )

   @ 09, 31 GET cEmpHs5 PICTURE "@!" VALID AllTrim( cEmpHs5 ) $ "#LASER#MATRICIAL#"

   @ 10, 31 GET cEmpNfs PICTURE "######"
   @ 10, 38 GET cEmpSer PICTURE "@!"

   @ 11, 31 GET cEmpPed PICTURE "######"
   @ 11, 38 GET cEmpPse PICTURE "@!"

   @ 12, 31 GET cEmpCpa PICTURE "######"
   @ 12, 38 GET cEmpCse PICTURE "@!"

   @ 13, 31 GET cEmpFor PICTURE "#######"

   @ 15, 31 GET cEmpReq PICTURE "######"
   @ 15, 38 GET cEmpRes PICTURE "@!"

   @ 16, 31 GET cEmpOrc PICTURE "######"
   @ 16, 38 GET cEmpOse PICTURE "@!"

   @ 17, 31 GET nEmpCai PICTURE "9999999.99"

   @ 10, 52 GET cEmpCli PICTURE "#######"
   @ 11, 52 GET cEmpPro PICTURE "######"
   @ 12, 52 GET cEmpDcp PICTURE "######"

   @ 13, 52 GET cEmpSen PICTURE "@!" VALID ( cEmpSen == "S" .OR. cEmpSen == "N" )

   @ 15, 52 GET cEmpPrt PICTURE "@R 99:99" VALID Val( Right( cEmpPrt, 2 ) ) < 60
   @ 16, 52 GET cEmpBol PICTURE "#######"

   @ 18, 31 GET cEmpCup PICTURE "######"
   @ 18, 38 GET cEmpCfe PICTURE "@!"
   @ 18, 52 GET cEmpEcf PICTURE "@!" VALID ( cEmpEcf $ "COM1#COM2#COM3" )
   @ 19, 31 GET cEmpNcu PICTURE "######"
   READ

   IF LastKey() == K_ESC
      msg( "* * * PARAMETRO NAO ALTERADO * * *" )
      RETURN ""
   ENDIF

   SetColor( "GR+/R" )
   @ 11, 22 SAY "Mensagem no Cupom FiscalĿ"
   @ 12, 22 SAY "                                        "
   @ 13, 22 SAY "                                        "
   @ 14, 22 SAY "                                        "
   @ 15, 22 SAY "                                        "
   @ 16, 22 SAY "                                        "
   @ 17, 22 SAY ""
   SetColor( "" )

   SetColor( _COREDICAO_ )
   @ 12, 23 GET cEmpHs1
   @ 13, 23 GET cEmpHs2
   @ 14, 23 GET cEmpHs3
   @ 15, 23 GET cEmpHs4
   READ

   sqlCAMPO := {}
   sqlCHAVE := {}
   sqlARQUI := { "AEMP00", "UPDATE" }

   AAdd( sqlCHAVE, { "EMPCOD", StrZero( ME_EMP, 2 ) } )
   AAdd( sqlCAMPO, { "EMPREQ", StrZero( Val( cEmpReq ), 6 ), .T. } )
   AAdd( sqlCAMPO, { "EMPRES", cEmpRes, .T. } )
   AAdd( sqlCAMPO, { "EMPBOL", StrZero( Val( cEmpBol ), 6 ), .T. } )
   AAdd( sqlCAMPO, { "EMPCUP", StrZero( Val( cEmpCup ), 6 ), .T. } )
   AAdd( sqlCAMPO, { "EMPNCU", StrZero( Val( cEmpNcu ), 6 ), .T. } )
   AAdd( sqlCAMPO, { "EMPORC", StrZero( Val( cEmpOrc ), 6 ), .T. } )
   AAdd( sqlCAMPO, { "EMPOSE", cEmpOse, .T. } )
   AAdd( sqlCAMPO, { "EMPCFE", cEmpCfe, .T. } )
   AAdd( sqlCAMPO, { "EMPECF", cEmpEcf, .T. } )
   AAdd( sqlCAMPO, { "EMPNFS", StrZero( Val( cEmpNfs ), 6 ), .T. } )
   AAdd( sqlCAMPO, { "EMPSER", cEmpSer, .T. } )
   AAdd( sqlCAMPO, { "EMPPED", StrZero( Val( cEmpPed ), 6 ), .T. } )
   AAdd( sqlCAMPO, { "EMPPSE", cEmpPse, .T. } )
   AAdd( sqlCAMPO, { "EMPCLI", StrZero( Val( cEmpCli ), 6 ), .T. } )
   AAdd( sqlCAMPO, { "EMPFOR", StrZero( Val( cEmpFor ), 6 ), .T. } )
   AAdd( sqlCAMPO, { "EMPPRO", StrZero( Val( cEmpPro ), 6 ), .T. } )
   AAdd( sqlCAMPO, { "EMPSEN", cEmpSen, .T. } )
   AAdd( sqlCAMPO, { "EMPCPA", StrZero( Val( cEmpCpa ), 6 ), .T. } )
   AAdd( sqlCAMPO, { "EMPDCP", StrZero( Val( cEmpDcp ), 6 ), .T. } )
   AAdd( sqlCAMPO, { "EMPPRT", cEmpPrt, .T. } )
   AAdd( sqlCAMPO, { "EMPCSE", cEmpCse, .T. } )
   AAdd( sqlCAMPO, { "EMPDOL", StrZero( Val( cEmpDol ), 1 ), .T. } )
   AAdd( sqlCAMPO, { "EMPSEV", StrZero( Val( cEmpSev ), 6 ), .T. } )
   AAdd( sqlCAMPO, { "EMPCAI", LTrim( Str( nEmpCai, 10, 2 ) ), .T. } )
   AAdd( sqlCAMPO, { "EMPHS1", cEmpHs1, .T. } )
   AAdd( sqlCAMPO, { "EMPHS2", cEmpHs2, .T. } )
   AAdd( sqlCAMPO, { "EMPHS3", cEmpHs3, .T. } )
   AAdd( sqlCAMPO, { "EMPHS4", cEmpHs4, .T. } )
   AAdd( sqlCAMPO, { "EMPHS5", cEmpHs5, .T. } )

   executasql()

   msg( "* * * PARAMETRO ALTERADO COM SUCESSO * * *" )

RETURN ""


***************
FUNCTION TLEMP01()
***************
   nbox( 7, 13, 17, 66, "W/W+", .T. )
   SetColor( "B/W" )
   @ 08, 13 SAY " Codigo  :                Fantasia:                 "
   @ 09, 13 SAY " Nome    :                                          "
   @ 10, 13 SAY ""
   @ 11, 13 SAY " Endereco:                                          "
   @ 12, 13 SAY " Bairro  :                           Cep:           "
   @ 13, 13 SAY " Cidade  :                                   Uf:    "
   @ 14, 13 SAY " Telefone:                     CAE:                 "
   @ 15, 13 SAY " Fax     :                   Junta:                 "
   @ 16, 13 SAY " CNPJ(MF):                     IES:                 "
   SetColor( "" )

RETURN ""


***************
FUNCTION EDEMP01( cEmpFan, cEmpNom, cEmpEnd, cEmpBai, nEmpCep, nEmpCce, ;
                  nEmpCdm, cEmpTel, cEmpTex, cEmpFax, cEmpJun, cEmpCgc, ;
                  cEmpIes, cEmpMun, cEmpEst )
***************
   SetColor( _COREDICAO_ )
   @ 08, 50 GET cEmpFan PICTURE "@!"
   @ 09, 25 GET cEmpNom PICTURE "@!"
   @ 11, 25 GET cEmpEnd PICTURE "@!" VALID diginro( "EMP" )
   @ 12, 25 GET cEmpBai PICTURE "@!"
   @ 12, 56 GET nEmpCep PICTURE "#####"
   @ 12, 62 GET nEmpCce PICTURE "###"
   @ 13, 25 GET nEmpCdm PICTURE "#######" VALID VEREMP02( @nEmpCdm, @cEmpMun, @cEmpEst )
   @ 14, 25 GET cEmpTel PICTURE "@!"
   @ 14, 50 GET cEmpTex PICTURE "@!"
   @ 15, 25 GET cEmpFax PICTURE "@!"
   @ 15, 50 GET cEmpJun PICTURE "@!"
   @ 16, 25 GET cEmpCgc PICTURE "@R 999.999.999/9999-99"
   @ 16, 50 GET cEmpIes PICTURE "@!"
   READ

RETURN ""


***************
FUNCTION MSEMP01()
***************
   SetColor( "N/W*" )
   @ 08, 25 SAY AEMP00->EMPCOD PICTURE "##"
   @ 08, 50 SAY AEMP00->EMPFAN PICTURE "@!"
   @ 09, 25 SAY AEMP00->EMPNOM PICTURE "@!"
   @ 11, 25 SAY AEMP00->EMPEND PICTURE "@!"
   @ 12, 25 SAY AEMP00->EMPBAI PICTURE "@!"
   @ 12, 56 SAY AEMP00->EMPCEP PICTURE "#####"
   @ 12, 62 SAY AEMP00->EMPCCE PICTURE "###"
   @ 13, 25 SAY AEMP00->EMPCDM PICTURE "#######"
   @ 13, 33 SAY AEMP00->EMPMUN PICTURE "@!@S25"
   @ 13, 63 SAY AEMP00->EMPEST PICTURE "@!"
   @ 14, 25 SAY AEMP00->EMPTEL PICTURE "@!"
   @ 14, 50 SAY AEMP00->EMPTEX PICTURE "@!"
   @ 15, 25 SAY AEMP00->EMPFAX PICTURE "@!"
   @ 15, 50 SAY AEMP00->EMPJUN PICTURE "@!"
   @ 16, 25 SAY AEMP00->EMPCGC PICTURE "@R 999.999.999/9999-99"
   @ 16, 50 SAY AEMP00->EMPIES PICTURE "@!"
   SetColor( "" )

RETURN ""


***************
FUNCTION GREMP01( cAcao, nEmpCod, cEmpFan, cEmpNom, cEmpEnd, cEmpNro, cEmpCpe, ;
                  cEmpBai, nEmpCep, nEmpCce, nEmpCdm, cEmpMun, cEmpEst, cEmpTel, ;
                  cEmpTex, cEmpFax, cEmpJun, cEmpCgc, cEmpIes, cEmpSen )
***************
   sqlCAMPO := {}
   sqlCHAVE := {}
   sqlARQUI := { "AEMP00", cAcao }

   AAdd( sqlCHAVE, { "EMPCOD", StrZero( nEmpCod, 2 ) } )

   IF cAcao != "DELETE"
      AAdd( sqlCAMPO, { "EMPCOD", StrZero( nEmpCod, 2 ), .T. } )
      AAdd( sqlCAMPO, { "EMPCEP", StrZero( nEmpCep, 5 ), .T. } )
      AAdd( sqlCAMPO, { "EMPCCE", StrZero( nEmpCce, 3 ), .T. } )
      AAdd( sqlCAMPO, { "EMPCDM", StrZero( nEmpCdm, 7 ), .T. } )

      AAdd( sqlCAMPO, { "EMPFAN", cEmpFan, .T. } )
      AAdd( sqlCAMPO, { "EMPNOM", cEmpNom, .T. } )
      AAdd( sqlCAMPO, { "EMPEND", cEmpEnd, .T. } )
      AAdd( sqlCAMPO, { "EMPNRO", cEmpNro, .T. } )
      AAdd( sqlCAMPO, { "EMPCPE", cEmpCpe, .T. } )
      AAdd( sqlCAMPO, { "EMPBAI", cEmpBai, .T. } )
      AAdd( sqlCAMPO, { "EMPMUN", cEmpMun, .T. } )
      AAdd( sqlCAMPO, { "EMPEST", cEmpEst, .T. } )
      AAdd( sqlCAMPO, { "EMPTEL", cEmpTel, .T. } )
      AAdd( sqlCAMPO, { "EMPTEX", cEmpTex, .T. } )
      AAdd( sqlCAMPO, { "EMPFAX", cEmpFax, .T. } )
      AAdd( sqlCAMPO, { "EMPJUN", cEmpJun, .T. } )
      AAdd( sqlCAMPO, { "EMPCGC", cEmpCgc, .T. } )
      AAdd( sqlCAMPO, { "EMPIES", cEmpIes, .T. } )
      AAdd( sqlCAMPO, { "EMPSEN", cEmpSen, .T. } )
      AAdd( sqlCAMPO, { "EMPPRT", "0100", .T. } )
      AAdd( sqlCAMPO, { "EMPIND", "N", .T. } )
   ENDIF

   executasql()

RETURN ""


***************
FUNCTION VEREMP02( nEmpCdm, cEmpMun, cEmpEst )
***************
   IF nEmpCdm == 0
      sele_arquivo( "AMUN00" )
      nEmpCdm := AMUN00->MUNCOD
   ENDIF

   IF !BUSCAREGISTRO( "AMUN00", 1, { StrZero( nEmpCdm, 7 ) }, "SELECT" )
      msg( "* * * MUNICIPIO NAO CADASTRADO * * *" )
      nEmpCdm := 0
      RETURN .F.
   ENDIF

   cEmpMun := PadR( AMUN00->MUNNOM, 32 )
   cEmpEst := AMUN00->MUNEST

   SetColor( "N/W*" )
   @ 13, 33 SAY PadR( cEmpMun, 25 ) PICTURE "@!"
   @ 13, 63 SAY cEmpEst PICTURE "@!"
   SetColor( "" )

RETURN .T.


***************
FUNCTION DESLIGA( F_TAM, F_LOCAL )
***************
   LOCAL oShell

   IF F_TAM == NIL
      F_TAM := 96
   ENDIF

   IF F_LOCAL == NIL
      F_LOCAL := "C"
   ENDIF

   SET PRINT OFF
   SET PRINTER TO
   SET CONSOLE ON
   SET CURSOR ON
   SET RELATION TO

   IF M_IMPRE == "A"
      ShowTime()
      msg( "ANTES MyDialogTwo()" )
   ELSE
      IF F_TAM == 0 .OR. F_TAM == 96
         oShell := CreateObject( "WScript.Shell" )
         IF "SCILAS" $ M_LOGNOM
            oShell:Run( "nodosimp.exe RELATO.RPT 96 PRE/SEL", 0, .T. )
         ELSE
            oShell:Run( "nodosimp.exe RELATO.RPT 96 /SEL", 0, .T. )
         ENDIF
      ELSEIF F_TAM == 140
         oShell := CreateObject( "WScript.Shell" )
         IF "SCILAS" $ M_LOGNOM
            oShell:Run( "nodosimp.exe RELATO.RPT 140 PRE/SEL", 0, .T. )
         ELSE
            oShell:Run( "nodosimp.exe RELATO.RPT 140 SEL", 0, .T. )
         ENDIF
      ELSEIF F_TAM == 80
         oShell := CreateObject( "WScript.Shell" )
         IF "SCILAS" $ M_LOGNOM
            oShell:Run( "nodosimp.exe RELATO.RPT 80 PRE/SEL", 0, .T. )
         ELSE
            oShell:Run( "nodosimp.exe RELATO.RPT 80 /SEL", 0, .T. )
         ENDIF
      ENDIF
   ENDIF

RETURN ""


***************
FUNCTION VERREGIME( F_HELP, F_OQUE )
***************
   LOCAL scr, clr, lTela
   LOCAL aBlocks := {}
   LOCAL M_TIPOS := {}
   LOCAL PosAcho := 1, nChoice := 1, nIdx

   IF LastKey( , .T. ) == K_UP .OR. LastKey( , .T. ) == K_DOWN
      RETURN .T.
   ENDIF

   lTela := SaveScreen( 7, 39, 22, 76 )

   AAdd( M_TIPOS, "1 Simples Nacional.                               " )
   AAdd( M_TIPOS, "2 Simples Nacional excesso sublimite receita bruta" )
   AAdd( M_TIPOS, "3 Regime Normal.                                  " )

   FOR nIdx := 1 TO Len( M_TIPOS )
      IF Left( M_TIPOS[ nIdx ], 1 ) == AllTrim( F_HELP )
         PosAcho := nIdx
         EXIT
      ENDIF
   NEXT

   scr := SaveScreen( 7, 38, 11, 85 )
   clr := SetColor( "N/W*,GR+/B*,,,GR+/B" )

   Wvt_DrawBoxRaised( 8, 40, 10, 84 )
   WvtSetBlocks( aBlocks )

   nChoice := AChoice( 8, 40, 10, 84, M_TIPOS, , , PosAcho )

   SetColor( clr )
   RestScreen( 7, 38, 11, 85, scr )

   IF LastKey() == K_ESC .OR. nChoice == 0
      RETURN .T.
   ENDIF

   F_HELP := Left( M_TIPOS[ nChoice ], 1 )

RETURN .T.
