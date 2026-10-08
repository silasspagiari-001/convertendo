
// ARQUIVOS MORTO APCMOR VAI SER GRAVADO JUNTO COM O APCA00


// CHAMAR CALENDARIO NA DATA
// @ 10, 29 get M_LANDTA  F2 color _CORF2_ funcao "pegadata(10,29,@M_LANDTA)" retorno "re"


#include 'inkey.ch'
#include 'common.ch'
#include 'wvtwin.ch'
#include "hbwin.ch"
#include "hbgtinfo.ch"

#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)
#xtranslate ISNIL( <xValue> )       => HB_ISNIL( <xValue> )

//-------------------------------------------------------------------//
//
//   WvtSetObjects() array structure
//
#define WVT_OBJ_TYPE               1
#define WVT_OBJ_ID                 2
#define WVT_OBJ_ROW                3
#define WVT_OBJ_COL                4
#define WVT_OBJ_ROWTO              5
#define WVT_OBJ_COLTO              6
#define WVT_OBJ_ONDISP             7
#define WVT_OBJ_ONMOUSEOVER        8
#define WVT_OBJ_ONBUTTONDOWN       9
#define WVT_OBJ_ONBUTTONUP        10
#define WVT_OBJ_TOOLTIP           11
#define WVT_OBJ_STATE             12
#define WVT_OBJ_DUMMY             13
#define ALTD_DISABLE   0
#define ALTD_ENABLE    1
#define WVT_OBJ_VRBLS             13

//   WVT_OBJ_TYPE  Constants
//
#define OBJ_TYPE_BUTTON            1


//   WVT_OBJ_STATE
//
#define OBJ_STATE_HIDE             0
#define OBJ_STATE_DISP             1
#define OBJ_STATE_MOUSEOVER        2
#define OBJ_STATE_BUTTONDOWN       3
#define OBJ_STATE_BUTTONUP         4

//-------------------------------------------------------------------//

#define  IMAGE_VOUCH          'vouch1.bmp'
#define  IMAGE_BROWSE         'v_browse.ico'
#define  IMAGE_VR             'vr_1.ico'
#define  IMAGE_NOTES          'v_notes.ico'
#define  IMAGE_TOOLS          'v_tools.ico'
#define  IMAGE_HELP           'v_notes.ico'

//-------------------------------------------------------------------//
//
//   Candidate for inkey.ch
//
#define K_SBLINEUP              1051
#define K_SBLINEDOWN            1052
#define K_SBPAGEUP              1053
#define K_SBPAGEDOWN            1054

#define K_SBLINELEFT            1055
#define K_SBLINERIGHT           1056
#define K_SBPAGELEFT            1057
#define K_SBPAGERIGHT           1058

#define K_SBTHUMBTRACKVERT      1059
#define K_SBTHUMBTRACKHORZ      1060

//-------------------------------------------------------------------//

#ifndef __SQL__
//ANNOUNCE Hb_NoStartUpWindow
#endif

//-------------------------------------------------------------------//

#define CRLF   chr( 13 )+chr( 10 )

#define DBI_QUERY             1001
#define RDDI_CONNECT          1001
#define RDDI_DISCONNECT       1002
#define RDDI_EXECUTE          1003
#define RDDI_ERROR            1004
#define RDDI_ERRORNO          1005
#define RDDI_NEWID            1006
#define RDDI_AFFECTEDROWS     1007
#define RDDI_QUERY            1008


//-------------------------------------------------------------------//



static wvtScreen := {}
static pic_:= { , , , , , , , , , , , , , , , , , , , }
static keys_:= { , , , , , , , , , , , , , , , , , , , }

static ahFonts := {}
static shIcon, shImage
static aSlides := {}
*static npaintt  := 0

#ifdef __XCC__
static paint_:= { { '', {} } }
#endif

//-------------------------------------------------------------------//
PROCEDURE Main()

   LOCAL aLastPaint, clr, scr
   LOCAL dDate   := ctod( '' )
   LOCAL nSlry   := 20000
   LOCAL nColGet := 8
   LOCAL GetList := {}
   LOCAL nTop    := 4
   LOCAL nLft    := 4
   LOCAL nBtm    := 20
   LOCAL nRgt    := 75
   LOCAL nMaxRows:= MaxRow()
   LOCAL nBtnRow := nMaxRows - 1

   LOCAL cLabel  := '(x)Harbour simulated GUI.'
   LOCAL aObjects:= WvtSetObjects( {} )
   LOCAL hPopup
   LOCAL oMenu
*  WVW_SetDefLineSpacing(5)
*  wvw_SetLineSpacing( , 5 )

   npaintt  := 0
   lResize  := .f.

   lPaintGets    := .t.
   lDesligaRedraw := .f.

   aRestauratelas := { }
   _LINHASIS_     :=  33
   _COLUNASIS_    :=  125

set talk off
set wrap on
set date british
set delete on
set exclusive off
set scoreboard off
set epoch to 1980

s_amiscobjlist := {}      //x misc object list (actually: list of codeblocks)
s_aGuiObjs := {}
wvw_SetPaintRefresh(0)
handleAberto=0
WVW_Size_Ready(.T.)

aChaRegistro := { }

MenuList := {}

   M_DATA = dtoc(date())
   M_LOGPRV = ""
   s_cStdColor := "N/W,N/GR*,,,N/W*"

   _path_ = "C:\ATLAS"
   _PATHSQL_  = "localhost/3050:C:\dados\ATLAS.fdb"
   _PATHODBC_ = "                                 "
   cNomAberto = space(10)
   M_LOGNOM = "SILAS"
   _CORBOXLISTA_ = "_W/BG+"
   _CORLETRAS_ = "N/W*"        // COR DAS LETRAS A SEREM MOSTRADAS SAY
   _CORPROMPT_ = "r/w,W+/N"
   _SOMBRA_   = "N*/N+"
   _COREDICAO_ = "N/W,N/GR*,,,N/W*"  // "N/W,N/W*"  // COR DOS CAMPOS GET
   _CORTELAS_  = "N/W"        // COR DO FUNDO E DAS LETRAS FIXAS (era "B/W")
   _COREDICAO_FOSCO = "N/W,N/GR"  // "N/W,N/W*"  // COR DOS CAMPOS GET
   _CORPROMPT_ = "r/w,W+/N"
   _CORF2_ = "N/W*,W+/G"
    lAltCFOP = .t.  // nao pode alterar cfop

   _COREDICAO_ = "N/RB*,N/GR*,,,N/W*"  // "N/W,N/W*"  // COR DOS CAMPOS GET
   // ---- PALETA VISUAL (estilo petroleo) - para voltar, restaurar os valores originais ----
   _CORBOXLISTA_ = "N/W+"                 // antes: "_W/BG+"
   _CORPROMPT_   = "W+/BG,N/W"            // antes: "r/w,W+/N"  (barra de menus / opcoes)
   _COREDICAO_   = "N/W+,W+/BG*,,,N/W+"   // antes: "N/RB*,N/GR*,,,N/W*" (campos: branco, foco ciano)
   _CORF2_       = "N/W*,W+/BG"           // antes: "N/W*,W+/G"

   _SOMBRA_   = "N+"
   lPosFunpro = 0
   M_FRAME1  =  "ÚÄ¿³ÙÄÀ³ "
   M_FRAME1A =  "ÚÄ¿³ÙÄÀ³ "
   AA_SESTOQUE = { }
   AA_PROMOCAO = { }
   AA_DESCONTO = { }
   ZZ_IMPRE = space(39)
   _IMPLIS_   = "L"
   _IMPFIL_   = "LPT1"
   cCRH27E = chr(27) + "E"
   cCRH27F = chr(27) + "F"
   _EMPPRT_ = "0100"

   RDDSETDEFAULT("DBFCDX")

   cF_ATV = "MENU          "
   cF_MOD = "PRINCIPAL     "
   cF_PRG = "SIS V.4.3     "
   M_FAN = "SISTEMA INGEGRADO"

   lLog = .f.
   _FONTET_   = 31
   _FONTEL_   = 18
   _FONTEN_   = "Visuallib"
*   _FONTEN_   = "Courier New"
*   _FONTEN_   = "Lucida Sans Typewriter"
*    _FONTEN_   = "LCDmono2"


    ACBrNFe_ENT = "C:\NFE\ENTNFE.TXT"
    ACBrNFe_SAI = "C:\NFE\SAINFE.TXT"
    ACBrNFe_TMP = "C:\NFE\ARQTMP.TXT"
    ACBrNFe_UNI = "C"

    M_ABBOTT = "#40702#410#"
    CSOSN_900 =  "#5.551#6.912#5.912#6.910#5.909#6.915#6.949#5.949#5.917#5.915#5.918#6.202#5.202#5.910#5.929#1.908#1.909#1.949#"
    cCFOPFORA  = "#1910#1949#1117#1912#1908#1917#1918#1906#1911#1916#1923#2910#2949#2912#2908#2923#2917#2922#2117#2916#5910#5117#5918#5949#5917#5556#5927#5911#5915#5905#6910#6117#6915#6949#6918#6908#6911#6913#" // nao altera preco
    lAge   = .f.
    lf3pro = .f.
    lf3cli = .f.
    lCriandoid = "F"
    lVeiodoF3 = .t.
    lEmitindonota = .f.
    lEditandomov = .f.
    lPoslogrestricao = 0
    lPoslogAtual = 0
    lNovaInscricao = .f.
    lReemitenfs = .f.
    lPageUp = .t.
    lAltiteped = .f.  // se alterou e deu esc esclui o item
    nUltprod = 0
    nUltClid = 0
    nUltFord = 0
    nCodRetorno = 0
    nMotivoSQL = ""   // porque deu erro no sql
    cPESQUISA = ""
    cPESQUISAFor = ""
    cPESQUISACli = ""

    cCODPESQ = 0
    
    SET( _SET_DEBUG, .T. )

   lKeyfun = .f.

   M_EMP = 1
   ME_EMP = 1
   W_LOGGER = replicate("S",750)
   lKeyfun = .f.

  _EMPRESA_  = 1
  _FUNDO_    = "B "
  _SOMBRA_   = "N+"
  _FRENTE_   = "B+"
  _INFERIOR_ = "N "
  _PROTECAO_ = "B+"
  _PATH_    = "C:\ATLAS                      "
  _LPT1_    = "\\FATURA\EPSON1                   "
  _FONTET2_   = 31
  _FONTEL2_   = 18
  M_FRAME3  =  "         "
  _NOMEMP_ = "CIRURCENTER"
  _PATHSQL_ = ""
  _PATHODBC_ = ""


nREQEMP = 1
lNanuvem = .F.
lPaint = .t.     // se repinta o formulario ou nao

XX_LOGSEN = space(10)

_path_ = alltrim(_path_)

   xx_FISEST = ""
   SET DATE BRITISH
   lSoesse = ""

  SET( _SET_EVENTMASK, INKEY_ALL )
  Wvt_SetMouseMove( .t. )
  wvw_SetMainCoord(.T.)

lTemporefhash = seconds()
cInicIMG826 := {} // Wvt_SaveScreen(Arg4, Arg5, Local5+2, Local6+3)
aInicIMG826 := {} // {Arg4, Arg5, Local5+2, Local6+3}


   _SOMBRA_   = "W/N*"

  MyDialogLocal()

   RETURN

//-------------------------------------------------------------------//

//------------------------------------------------------------------//


//-------------------------------------------------------------------//

   
//-------------------------------------------------------------------//
STATIC FUNCTION rgb( r,g,b )

   RETURN ( r + ( g * 256 ) + ( b * 256 * 256 ) )
//-------------------------------------------------------------------//

//-------------------------------------------------------------------//
FUNCTION SELE_ARQUIVO(fARQUIVO,FCODIGO)

   LOCAL nKey, bBlock, aLastPaint, i, info_
   LOCAL lEnd    := .f.
   LOCAL aBlocks := {}
   LOCAL nTop    :=  1
   LOCAL nLeft   :=  1
   LOCAL nBottom := 20 // maxrow() - 8
   LOCAL nRight  := maxcol() - 3
   LOCAL nCursor := setCursor( 0 )
   LOCAL nRow    := row()
   LOCAL nCol    := col()
   LOCAL cColor  := SetColor( 'N/W*,W/N+,W/R,,N/W*,GR+/BG,R+/W*' )
   LOCAL cScr0    := SaveScreen( 0,0,maxrow(),maxcol() )
 *  LOCAL cScr2    := wvt_SaveScreen( 0,0,maxrow(),maxcol() )
 *  LOCAL aObjects:= WvtSetObjects( {} )
   LOCAL cFileIndex, cFileDbf, cRDD, nIndex
   LOCAL lpri
   LOCAL aEBGets := {}

   STATIC nStyle := 0

   lDesligaRedraw := .t.


do case
  case fARQUIVO == "CBNEF"
    seexistesql("CBNEF")
    cSql := "SELECT * FROM CBNEF ORDER BY DESCRICAO"

    dbusearea(.t.,"SQLMIX",cSql,"CBNEF")
    lTampesq = len(DESCRICAO)
    lTangrade = 72
    cTitulo = "PESQUISA BENEFICIO"

                 ********
  case fARQUIVO == "AFOR00"
                 ********

    arqABERTO = "AFOR00"

*    if seaberto("AFOR00")
*    else
*      if nUltFord = 0
        seexistesql("AFOR00")
        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"AFOR00","AFOR00"})
        aadd(sqlCAMPO,"first 50 FORNOM")
        aadd(sqlCAMPO,"FORCOD")
        aadd(sqlCAMPO,"FOREND")
        aadd(sqlCAMPO,"FOREST")
        aadd(sqlCHAVE,"FORNOM <> ' '")
        aadd(sqlORDEM,"FORNOM")
 *     endif
*    endif

      aadd(sqlORDEM,"AFOR00.FORNOM")

      if !empty(cPESQUISAfor)
        aadd(sqlCHAVE,"FORNOM LIKE '" + alltrim(cPESQUISAfor) + "%'")
      else
        aadd(sqlCHAVE,"FORNOM <> ' '")
      endif

      sqlrelation()

    select AFOR00
    
    lTampesq = len(FORNOM)
    lTangrade = 72
    cTitulo = "PESQUISA FORNECEDOR"


  case fARQUIVO == "APOR00"
    seexistesql("APOR00")
    cSql := "SELECT * FROM APOR00 ORDER BY PORNOM"
    dbusearea(.t.,"SQLMIX",cSql,"APOR00")
    lTampesq = len(PORNOM)
    lTangrade = 72
    cTitulo = "PESQUISA PORTADOR"

  case fARQUIVO == "ATRA00"
    seexistesql("ATRA00")
    cSql := "SELECT * FROM ATRA00 ORDER BY TRANOM"
    dbusearea(.t.,"SQLMIX",cSql,"ATRA00")
    lTampesq = len(TRANOM)
    lTangrade = 72
    cTitulo = "PESQUISA TRANSPORTE"

  case fARQUIVO == "ACPG00"
    seexistesql("ACPG00")
    cSql := "SELECT first 50 * FROM ACPG00 WHERE CPGCOD > 0 and CPGDES <> ''"
    dbusearea(.t.,"SQLMIX",cSql,"ACPG00")
    lTampesq = len(CPGDES)
    lTangrade = 60
    cTitulo = "PESQUISA PAGAMENTO"
    locate for !empty(CPGDES)

  case fARQUIVO == "AHIS00"
    seexistesql("AHIS00")
    cSql := "SELECT * FROM AHIS00 ORDER BY HISDES"
    dbusearea(.t.,"SQLMIX",cSql,"AHIS00")
    lTampesq = len(HISDES)
    lTangrade = 46
    cTitulo = "PESQUISA HISTORICO"

  case fARQUIVO == "AMUN00"
    seexistesql("AMUN00")
    cSql := "SELECT * FROM AMUN00 WHERE MUNNOM LIKE 'PRESIDENTE%' ORDER BY MUNNOM"
    dbusearea(.t.,"SQLMIX",cSql,"AMUN00")
    lTampesq = len(MUNNOM)
    lTangrade = 72
    cTitulo = "PESQUISA MUNICIPIO"

  case fARQUIVO == "ACLI00"
    arqABERTO = "ACLI00"

*    if seaberto("ACLI00P")
*    else
*     if nUltClid = 0
        seexistesql("ACLI00")
        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"ACLI00","ACLI00"})
        aadd(sqlCAMPO,"first 50 CLINOM")
        aadd(sqlCAMPO,"CLICOD")
        aadd(sqlCAMPO,"CLIEND1")
        aadd(sqlCAMPO,"CLIUF1")
        aadd(sqlCAMPO,"CLIMUN1")
        aadd(sqlCAMPO,"CLICLF")
        aadd(sqlCHAVE,"CLINOM <> ' '")
        aadd(sqlORDEM,"CLINOM")
*     endif
    *endif

      aadd(sqlORDEM,"CLINOM")

      if !empty(cPESQUISAcli)
        aadd(sqlCHAVE,"CLINOM LIKE '" + alltrim(cPESQUISAcli) + "%'")
      else
        aadd(sqlCHAVE,"CLINOM <> ' '")
      endif

      sqlrelation()

    select ACLI00

    lTampesq = len(CLINOM)
    lTangrade = 100
    cTitulo = "PESQUISA CLIENTE"

  case fARQUIVO == "APCA00"

      arqABERTO = "APCA00"

*      if seaberto("APCA00P")
*      else
*        if nUltprod = 0
          seexistesql("APCA00")
          sqlRELATION = {}
          sqlCAMPO = {}
          sqlCHAVE =  {}
          sqlARQUI = {}
          sqlORDEM = {}

          aadd(sqlARQUI,{"APCA00","APCA00"})
          aadd(sqlCAMPO,"first 50 PCADES")
          aadd(sqlCAMPO,"PCAUNI")
          aadd(sqlCAMPO,"PCAMAR")
          aadd(sqlCAMPO,"PCAMAT")

          aadd(sqlCAMPO,"COALESCE(S1.SLDDIS,0) as SALDO1")
          aadd(sqlCAMPO,"COALESCE(S2.SLDDIS,0) as SALDO2")
          aadd(sqlCAMPO,"COALESCE(S1.SLDPRC,0) as SLDPRC")


          if AEMP00->EMPCGC == "037623347000109"
            aadd(sqlRELATION,{"ASLD00 S1",str(2, 2, 0),"S1.SLDEMP"})
            aadd(sqlRELATION,{"","S1.SLDMAT","APCA00.PCAMAT"})
            aadd(sqlRELATION,{"ASLD00 S2",str(10, 2, 0),"S2.SLDEMP"})
            aadd(sqlRELATION,{"","S2.SLDMAT","APCA00.PCAMAT"})
          else
            aadd(sqlRELATION,{"ASLD00 S1",str(1, 2, 0),"S1.SLDEMP"})
            aadd(sqlRELATION,{"","S1.SLDMAT","APCA00.PCAMAT"})
            aadd(sqlRELATION,{"ASLD00 S2",str(10, 2, 0),"S2.SLDEMP"})
            aadd(sqlRELATION,{"","S2.SLDMAT","APCA00.PCAMAT"})
          endif
          
*          if !lTodospro
            aadd(sqlCHAVE,"PCANUL <> 'S'")
*          endif

          aadd(sqlORDEM,"APCA00.PCADES")

          if !empty(cPESQUISA)
            aadd(sqlCHAVE,"PCADES LIKE '" + alltrim(cPESQUISA) + "%'")
          else
            aadd(sqlCHAVE,"PCADES <> ' '")
          endif

          if !sqlrelation()
             msgbox1("Erro na consulta, verifique sua pesquisa")

            * DevPos( nRow, nCol )
            * SetColor( cColor )
            * SetCursor( nCursor )

             RestScreen( 0, 0, maxrow(), maxcol(), cScr0 )
             wvw_lCloseWindow()

            return ""
          endif

          if cCODPESQ > 0
            locate for PCAMAT = cCODPESQ
          endif

 *       endif
 *     endif

    select APCA00

    lTampesq = len(PCADES)
    lTangrade = 100

    cTitulo = "PESQUISA PRODUTO"

  case fARQUIVO == "ASUB00"
    seexistesql("ASUB00")
    cSql := "SELECT first 50 * FROM ASUB00 WHERE SUBCOD > 0"
    dbusearea(.t.,"SQLMIX",cSql,"ASUB00")

    select &fARQUIVO
    locate for !empty(SUBNOM)
    lTampesq = len(SUBNOM)
    lTangrade = 45
    cTitulo = "PESQUISA SUB-GRUPO"


                   ********
  case fARQUIVO == "AGRP00"
                   ********
    seexistesql("AGRP00")
    cSql := "SELECT first 50 * FROM AGRP00 WHERE GRPCOD > 0"
    dbusearea(.t.,"SQLMIX",cSql,"AGRP00")

    select &fARQUIVO
    locate for !empty(GRPNOM)
    lTampesq = len(GRPNOM)
    lTangrade = 45
    cTitulo = "PESQUISA GRUPO"


  case fARQUIVO == "IBGE"
  case fARQUIVO == "AHIE00"
  case fARQUIVO == "AVEN00"
    cSql := "SELECT * FROM AVEN00 WHERE VENCOD > 0 order by VENNOM"
    dbusearea(.t.,"SQLMIX",cSql,"AVEN00")

    lTampesq = len(VENNOM)
    lTangrade = 45
    cTitulo = "PESQUISA VENDEDOR"

  case fARQUIVO == "AFIS00"
    seexistesql("AFIS00")

    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"AFIS00","AFIS00"})
    aadd(sqlCAMPO,"*")
    aadd(sqlCHAVE,"FISEMP = " + str(ME_EMP, 2, 0))
    aadd(sqlCHAVE,"FISNOV <> '    '")
    sqlrelation()
    lTampesq = len(FISNOM)
    lTangrade = 45
    cTitulo = "PESQUISA CFOP"
  case fARQUIVO == "ACTA00"
    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"ACTA00","ACTA00"})
    aadd(sqlCAMPO,"*")
    aadd(sqlCHAVE,"CTACTA <> ''")
    sqlrelation()
    lTampesq = len(CTACTA)
    lTangrade = 45
    cTitulo = "PESQUISA CONTA"
endcase

*/*/*/

IN_COL = int((105 - lTangrade) /2)
UL_COL = lTangrade + IN_COL

* oBrowse := TBrowseNew( nTop + 3, IN_COL,21,UL_COL)
* oBrowse := TBrowseWVG():New( nTop + 3, nLeft + 2, nBottom - 1, nRight - 2 )

*win(nTop + 2, IN_COL-1,22,UL_COL+1 ,cTITULO,"W/G","G/W*")

*NBOX(nTop + 2, IN_COL-1,22,UL_COL+1)
*NBOX(nTop + 3, IN_COL,21,UL_COL)



oBrowse := TBrowseDB():New( nTop + 3, IN_COL,21,UL_COL )

do case
  case fARQUIVO == "CBNEF"
    oBrowse:addColumn(TBColumnNew("Descricao", FieldBlock("DESCRICAO")))
    oBrowse:addColumn(TBColumnNew("Beneficio",FieldBlock("CODCBNEF")))
    oBrowse:addColumn(TBColumnNew("Codigo",FieldBlock("CODIGO")))
    oBrowse:GetColumn(1):Picture := "@!@S50"
    oBrowse:GetColumn(3):Picture := "999999"

  case fARQUIVO == "AHIS00"
    oBrowse:addColumn(TBColumnNew("Descricao", FieldBlock("HISDES")))
    oBrowse:addColumn(TBColumnNew("Tipo",FieldBlock("HISTIP")))
    oBrowse:addColumn(TBColumnNew("Codigo",FieldBlock("HISCOD")))
    oBrowse:GetColumn(3):Picture := "999"
  case fARQUIVO == "ACTA00"
    oBrowse:addColumn(TBColumnNew("Conta", FieldBlock("CTACTA")))
    oBrowse:addColumn(TBColumnNew("Nome da Agencia",FieldBlock("CTAAGE")))
    oBrowse:addColumn(TBColumnNew("Banco",FieldBlock("CTABAN")))
    oBrowse:GetColumn(3):Picture := "999"
  case fARQUIVO == "APOR00"
    oBrowse:addColumn(TBColumnNew("DESCRICAO",FieldBlock("PORNOM")))
    oBrowse:addColumn(TBColumnNew("CODIGO", FieldBlock("PORCOD")))
    oBrowse:GetColumn(2):Picture := "99999"
  case fARQUIVO == "ATRA00"
    oBrowse:addColumn(TBColumnNew("NOME",FieldBlock("TRANOM")))
    oBrowse:addColumn(TBColumnNew("CODIGO", FieldBlock("TRACOD")))
    oBrowse:addColumn(TBColumnNew("ENDERECO",FieldBlock("TRAEND")))
    oBrowse:addColumn(TBColumnNew("UF", FieldBlock("TRAEST")))
    oBrowse:GetColumn(1):Picture := "@s35"
    oBrowse:GetColumn(2):Picture := "99999"
    oBrowse:GetColumn(3):Picture := "@s25"
  case fARQUIVO == "ACPG00"
    oBrowse:addColumn(TBColumnNew("Descricao",FieldBlock("CPGDES")))
    oBrowse:addColumn(TBColumnNew("COD", FieldBlock("CPGCOD")))
    oBrowse:addColumn(TBColumnNew("P",FieldBlock("CPGPAR")))
    oBrowse:addColumn(TBColumnNew("PZ1",FieldBlock("CPGPR1")))
    oBrowse:addColumn(TBColumnNew("PZ2",FieldBlock("CPGPR2")))
    oBrowse:addColumn(TBColumnNew("PZ3",FieldBlock("CPGPR3")))
    oBrowse:addColumn(TBColumnNew("PZ4",FieldBlock("CPGPR4")))
    oBrowse:addColumn(TBColumnNew("PZ5",FieldBlock("CPGPR5")))
    oBrowse:addColumn(TBColumnNew("PZ6",FieldBlock("CPGPR6")))

    oBrowse:GetColumn(1):Picture := "@!"
    oBrowse:GetColumn(2):Picture := "999"
    oBrowse:GetColumn(3):Picture := "99"
    oBrowse:GetColumn(4):Picture := "999"
    oBrowse:GetColumn(5):Picture := "999"
    oBrowse:GetColumn(6):Picture := "999"
    oBrowse:GetColumn(7):Picture := "999"
    oBrowse:GetColumn(8):Picture := "999"
    oBrowse:GetColumn(9):Picture := "999"
  case fARQUIVO == "AHIE00"
    oBrowse:addColumn(TBColumnNew("DESCRICAO",FieldBlock("HIENOM")))
    oBrowse:addColumn(TBColumnNew("CODIGO", FieldBlock("HIEOPE")))
    oBrowse:GetColumn(2):Picture := "99999"
  case fARQUIVO == "AMUN00"
    oBrowse:addColumn(TBColumnNew("MUNICIPIO DESCRICAO",FieldBlock("MUNNOM")))
    oBrowse:addColumn(TBColumnNew("UF",FieldBlock("MUNEST")))
    oBrowse:addColumn(TBColumnNew("CODIGO", FieldBlock("MUNCOD")))
    oBrowse:GetColumn(3):Picture := "9999999"
  case fARQUIVO == "ASUB00"
    oBrowse:addColumn(TBColumnNew("DESCRICAO DO SUB-GRUPO",FieldBlock("SUBNOM")))
    oBrowse:addColumn(TBColumnNew("COD", FieldBlock("SUBCOD")))
    oBrowse:GetColumn(2):Picture := "9999"
  case fARQUIVO == "AGRP00"
    oBrowse:addColumn(TBColumnNew("DESCRICAO DO GRUPO",FieldBlock("GRPNOM")))
    oBrowse:addColumn(TBColumnNew("COD", FieldBlock("GRPCOD")))
    oBrowse:GetColumn(2):Picture := "9999"
  case fARQUIVO == "AFOR00"
    oBrowse:addColumn(TBColumnNew("NOME FORNECEDOR",FieldBlock("FORNOM")))
    oBrowse:addColumn(TBColumnNew("COD", FieldBlock("FORCOD")))
    oBrowse:addColumn(TBColumnNew("ENDERECO",FieldBlock("FOREND")))
    oBrowse:addColumn(TBColumnNew("UF", FieldBlock("FOREST")))
    oBrowse:GetColumn(1):Picture := "@!"
    oBrowse:GetColumn(2):Picture := "99999"
    oBrowse:GetColumn(3):Picture := "@s23"
  case fARQUIVO == "AVEN00"
    oBrowse:addColumn(TBColumnNew("NOME",FieldBlock("VENNOM")))
    oBrowse:addColumn(TBColumnNew("COD", FieldBlock("VENCOD")))
    oBrowse:GetColumn(1):Picture := "@!"
    oBrowse:GetColumn(2):Picture := "99999"
  case fARQUIVO == "AFIS00"
    oBrowse:addColumn(TBColumnNew("NOME",FieldBlock("FISNOM")))
    oBrowse:addColumn(TBColumnNew("CFOP", FieldBlock("FISNOV")))
    oBrowse:addColumn(TBColumnNew("ESTOQUE",FieldBlock("FISEST")))
    oBrowse:addColumn(TBColumnNew("COMPLEMENTAR", FieldBlock("FISCPL")))
  case fARQUIVO == "ACLI00"

    oCol := TBColumnNew("NOME",FieldBlock("CLINOM"))
    oCol:Picture := "@!@S40"
    oBrowse:addColumn(oCol)

    oCol := TBColumnNew("COD", FieldBlock("CLICOD"))
    oCol:Picture := "99999"
    oBrowse:addColumn(oCol)

    oCol := TBColumnNew("ENDERECO DE ENTREGA",FieldBlock("CLIEND1"))
    oCol:Picture := "@s23"
    oBrowse:addColumn(oCol)

    oCol := TBColumnNew("MUNICIPIO",FieldBlock("CLIMUN1"))
    oCol:Picture := "@s20"
    oBrowse:addColumn(oCol)

    oCol := TBColumnNew("UF", FieldBlock("CLIUF1"))
    oCol:Picture := "@!@S2"
    oBrowse:addColumn(oCol)

  case fARQUIVO == "APCA00"

    oBrowse:addColumn(TBColumnNew("Descricao dos Produtos",FieldBlock("PCADES")))
    oBrowse:addColumn(TBColumnNew("Marca",FieldBlock("PCAMAR")))
    oBrowse:addColumn(TBColumnNew("Codigo", FieldBlock("PCAMAT")))
    oBrowse:addColumn(TBColumnNew("Un",&("{||TRAN(pad(PCAUNI,2),[@!])}")))

    if ME_EMP = 1
      oBrowse:addColumn(TBColumnNew("Saldo",&("{||TRAN(SALDO1,[99999999])}")))
    ELSE
      oBrowse:addColumn(TBColumnNew("Saldo",&("{||TRAN(SALDO2,[99999999])}")))
    endif
    oBrowse:addColumn(TBColumnNew("Preco",&("{||TRAN(SLDPRC,[@R 9,999.99])}")))
*    oBrowse:GetColumn(1):Picture := "@!@S39"
    oBrowse:GetColumn(2):Picture := "@!@S20"
    oBrowse:GetColumn(3):Picture := "999999"


endcase

   oBrowse:ColSep        := ' '
   oBrowse:HeadSep       := 'Ä'
   oBrowse:GoTopBlock    := { || dbGoTop() }
   oBrowse:GoBottomBlock := { || dbGoBottom() }
   oBrowse:SkipBlock     := { | nSkip | dbSkipBlock( nSkip,oBrowse ) }
   oBrowse:freeze := 1
   oBrowse:colPos := 1
   oBrowse:configure()

*   if fARQUIVO == "APCA00"
*      oBrowse:colPos := 2
*   endif

   wvw_nOpenWindow( "SESSAO1", nTop + 2, IN_COL-1,22,UL_COL+1, NIL, 0 )
   win(nTop + 2, IN_COL-1,22,UL_COL+1 ,cTITULO,"N/RB*","RB+/W*")

   lKeyWaiting := .F.
   lBrowse := .T.
   lPosrecloc = 0

   M_PROC = ""
   NpOSIC = { }
   cPosic = ""

   nc = 1

   lPri = .t.
   
   DO WHILE (lBrowse)


     lErroconsulta = .f.
     oBrowse:RefreshCurrent()
     oBrowse:Stabilize()

     if lPri
       lPri := .f.
       cSave := DestacarArea(nTop + 3, IN_COL-1,nTop + 3,UL_COL+1 , 31 )  // 31 = W+/B
     endif
*     @ 27, 10 say recno() % 2

*     @ 27, 50 say "TESTE"

*     if fARQUIVO == "APCA00"
*       if recno() % 2 > 0
*         oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{3,5} ) // linha/coluna que está com o cursor
*       else
*         oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{2,5} ) // linha/coluna que está com o cursor
*       endif
*     else
*       oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{2,5} ) // linha/coluna que está com o cursor
*     endif



*     if fARQUIVO == "ACLI00"
*       if CLICLF == "C"
*         oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{3,5} ) // linha/coluna que está com o cursor
*       else
*         oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{2,5} ) // linha/coluna que está com o cursor
*       endif
*     else
*       oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{2,5} ) // linha/coluna que está com o cursor
*     endif

if !fARQUIVO == "ACLI00"
   oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{2,5} ) // linha/coluna que est? com o cursor
   oBrowse:colPos := 1
endif


*     oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{2,5} ) // linha/coluna que est? com o cursor


*     if fARQUIVO == "APCA00"
*       if lPosrecloc # recno()
*         @ maxrow()-1, 0 say "     " + pad(PCADES,maxcol()) color "W+/N"
*       endif
*     endif

*     if lPri
*       aLastPaint := WvtSetBlocks( aBlocks )
*       lPri = .f.
*     endif

 *    oBrowse:colPos := 1



     do while .t.
       nKey := nInKey(1)
       if nKey # 0
         exit
       endif
     enddo

     if nKey == K_F2
 *       nIndex := IndexOrd()
 *       nIndex++
 *       if nIndex > 3
 *          nIndex := 1
 *       endif
 *       Set Order To ( nIndex )
 *       oBrowse:RefreshAll()
     endif

    do case
    CASE (nKey == 27)
      lBrowse := .F.

    CASE (nKey == K_ENTER)
       do case
          case fARQUIVO == "AHIS00"
               nCodRetorno = HISCOD
          case fARQUIVO == "CBNEF"
               nCodRetorno = CODCBNEF
          case fARQUIVO == "ACTA00"
               nCodRetorno = CTACTA
          case fARQUIVO == "APOR00"
               nCodRetorno = PORCOD
          case fARQUIVO == "AFIS00"
               nCodRetorno = FISNOV
          case fARQUIVO == "ASUB00"
               nCodRetorno = SUBCOD
          case fARQUIVO == "AVEN00"
               nCodRetorno = VENCOD
          case fARQUIVO == "ATRA00"
               nCodRetorno = TRACOD
          case fARQUIVO == "ACPG00"
               nCodRetorno = CPGCOD
          case fARQUIVO == "AGRP00"
               nCodRetorno = GRPCOD
          case fARQUIVO == "ACLI00"
              if !empty(M_PROC)
                 cPESQUISAcli = M_PROC
              endif
               nUltClid = recno()
               nCodRetorno = CLICOD
          case fARQUIVO == "AFOR00"
              if !empty(M_PROC)
                 cPESQUISAfor = M_PROC
              endif
               nUltFord = recno()
               nCodRetorno = FORCOD
          case fARQUIVO == "AMUN00"
               nCodRetorno = MUNCOD
          case fARQUIVO == "APCA00"
              if !empty(M_PROC)
                 cPESQUISA = M_PROC
              endif

              cCODPESQ = PCAMAT

              nUltprod = recno()
              nCodRetorno = PCAMAT
       endcase

*       set order to 1


*       DevPos( nRow, nCol )
*       SetColor( cColor )
*       SetCursor( nCursor )

       wvw_lCloseWindow()
*       RestScreen( 0, 0, maxrow(), maxcol(), cScr0 )

*       RestScreen( 0, 0, maxrow(), maxcol(), cScr0 )
       lDesligaRedraw := .f.

       return ""

    CASE (nKey == K_DOWN)
      oBrowse:down()

    CASE (nKey == K_UP)
      oBrowse:up()

    CASE (nKey == K_PGDN)
      oBrowse:pageDown()

    CASE (nKey == K_PGUP)
      oBrowse:pageUp()

    CASE (nKey == K_CTRL_PGUP)
      oBrowse:goTop()

    CASE (nKey == K_CTRL_PGDN)
      oBrowse:goBottom()

    CASE (nKey == K_RIGHT)
      oBrowse:right()

    CASE (nKey == K_LEFT)
      oBrowse:left()

    CASE (nKey == K_HOME)
      oBrowse:home()

    CASE (nKey == K_END)
      oBrowse:end()

    CASE (nKey == K_CTRL_LEFT)
      oBrowse:panLeft()

    CASE (nKey == K_CTRL_RIGHT)
      oBrowse:panRight()

    CASE (nKey == K_CTRL_HOME)
      oBrowse:panHome()

    CASE (nKey == K_CTRL_END)
      oBrowse:panEnd()

    CASE (nKey == K_F3)

    CASE (nKey == K_F2)

    CASE (nKey == K_SPACE)

    CASE (nKey == K_ESC)
      lBrowse := .F.

    CASE (nKey # 13) .and. nkey > 0
      if oBrowse:colPos = 1

        save get to M_GETBRO
        keyboard chr(nKey)
        M_PROC = space(lTampesq)
        setcolor("W+/N,W/N+")
        @ oBrowse:rowpos+5,IN_COL get M_PROC picture "@!"
        read
        restore get from M_GETBRO

        do case
           case fARQUIVO == "CBNEF"
             seexistesql("CBNEF")
             cSql := "SELECT * FROM CBNEF WHERE DESCRICAO LIKE '%" + alltrim(M_PROC) + "%'"

             try
               dbusearea(.t.,"SQLMIX",cSql,"CBNEF")
             catch oErro
               lErroconsulta = .t.
             end

           case fARQUIVO == "ACTA00"
             seexistesql("ACTA00")
             cSql := "SELECT * FROM ACTA00 WHERE CTACTA LIKE '%" + alltrim(M_PROC) + "%'"
             try
               dbusearea(.t.,"SQLMIX",cSql,"ACTA00")
             catch oErro
               lErroconsulta = .t.
             end

           case fARQUIVO == "APOR00"
             seexistesql("APOR00")
             cSql := "SELECT * FROM APOR00 WHERE PORNOM LIKE '" + alltrim(M_PROC) + "%'"
             dbusearea(.t.,"SQLMIX",cSql,"APOR00")

           case fARQUIVO == "AHIS00"
             seexistesql("AHIS00")
             cSql := "SELECT * FROM AHIS00 WHERE HISNOM LIKE '" + alltrim(M_PROC) + "%' ORDER BY HISDES"
             dbusearea(.t.,"SQLMIX",cSql,"AHIS00")
           case fARQUIVO == "ASUB00"
             set order to 2
             dbseek( M_PROC,.t.)
           case fARQUIVO == "AVEN00"
             seexistesql("AVEN00")
             cSql := "SELECT * FROM AVEN00 WHERE VENNOM LIKE '" + alltrim(M_PROC) + "%' ORDER BY VENNOM"
             dbusearea(.t.,"SQLMIX",cSql,"AVEN00")
           case fARQUIVO == "ATRA00"
             seexistesql("ATRA00")
             cSql := "SELECT * FROM ATRA00 WHERE TRANOM LIKE '" + alltrim(M_PROC) + "%' ORDER BY TRANOM"
             dbusearea(.t.,"SQLMIX",cSql,"ATRA00")
           case fARQUIVO == "ACPG00"
             seexistesql("ACPG00")
             cSql := "SELECT * FROM ACPG00 WHERE CPGDES LIKE '" + alltrim(M_PROC) + "%' ORDER BY CPGDES"
             dbusearea(.t.,"SQLMIX",cSql,"ACPG00")
           case fARQUIVO == "AGRP00"
             seexistesql("AGRP00")
             cSql := "SELECT * FROM AGRP00 WHERE GRPNOM LIKE '" + alltrim(M_PROC) + "%'"
             try
               dbusearea(.t.,"SQLMIX",cSql,"AGRP00")
             catch oErro
               lErroconsulta = .t.
             end
           case fARQUIVO == "APCA00"
              seexistesql("APCA00")
              sqlRELATION = {}
              sqlCAMPO = {}
              sqlCHAVE = {}
              sqlARQUI = {}
              sqlORDEM = {}

              aadd(sqlARQUI,{"APCA00","APCA00"})
              aadd(sqlCAMPO,"PCADES")
              aadd(sqlCAMPO,"PCAUNI")
              aadd(sqlCAMPO,"PCAMAR")
              aadd(sqlCAMPO,"PCAMAT")
              aadd(sqlCAMPO,"COALESCE(S1.SLDDIS,0) as SALDO1")
              aadd(sqlCAMPO,"COALESCE(S2.SLDDIS,0) as SALDO2")
              aadd(sqlCAMPO,"COALESCE(S1.SLDPRC,0) as SLDPRC")
              if AEMP00->EMPCGC == "037623347000109"
                aadd(sqlRELATION,{"ASLD00 S1",str(2, 2, 0),"S1.SLDEMP"})
                aadd(sqlRELATION,{"","S1.SLDMAT","APCA00.PCAMAT"})
                aadd(sqlRELATION,{"ASLD00 S2",str(10, 2, 0),"S2.SLDEMP"})
                aadd(sqlRELATION,{"","S2.SLDMAT","APCA00.PCAMAT"})
              else
                aadd(sqlRELATION,{"ASLD00 S1",str(1, 2, 0),"S1.SLDEMP"})
                aadd(sqlRELATION,{"","S1.SLDMAT","APCA00.PCAMAT"})
                aadd(sqlRELATION,{"ASLD00 S2",str(10, 2, 0),"S2.SLDEMP"})
                aadd(sqlRELATION,{"","S2.SLDMAT","APCA00.PCAMAT"})
              endif
              
              aadd(sqlCHAVE,"PCANUL <> 'S'")
              aadd(sqlCHAVE,"PCADES LIKE '" + alltrim(M_PROC) + "%'")
              aadd(sqlORDEM,"APCA00.PCADES")
              if !sqlrelation()
                lErroconsulta = .t.
              else
                oBrowse:RefreshCurrent()
           	    oBrowse:Stabilize()
              endif

           case fARQUIVO == "AMUN00"
              seexistesql("AMUN00")
              cSql := "SELECT * FROM AMUN00 WHERE MUNNOM LIKE '" + alltrim(M_PROC) + "%'"
               try
                 dbusearea(.t.,"SQLMIX",cSql,"AMUN00")
               catch oErro
                 lErroconsulta = .t.
               end
              oBrowse:RefreshCurrent()
              oBrowse:Stabilize()
           case fARQUIVO == "ACLI00"
              seexistesql("ACLI00P")
              sqlRELATION = {}
              sqlCAMPO = {}
              sqlCHAVE =  {}
              sqlARQUI = {}
              sqlORDEM = {}

              aadd(sqlARQUI,{"ACLI00","ACLI00P"})
              aadd(sqlCAMPO,"CLINOM")
              aadd(sqlCAMPO,"CLICOD")
              aadd(sqlCAMPO,"CLIEND1")
              aadd(sqlCAMPO,"CLIMUN1")
              aadd(sqlCAMPO,"CLICLF")
              aadd(sqlCAMPO,"CLIUF1")
              aadd(sqlCHAVE,"CLINOM LIKE '" + alltrim(M_PROC) + "%'")
              aadd(sqlORDEM,"CLINOM")
              if !sqlrelation()
                lErroconsulta = .t.
              else
                oBrowse:RefreshCurrent()
            	  oBrowse:Stabilize()
              endif

           case fARQUIVO == "AFOR00"
              seexistesql("AFOR00")
              sqlRELATION = {}
              sqlCAMPO = {}
              sqlCHAVE =  {}
              sqlARQUI = {}
              sqlORDEM = {}

              aadd(sqlARQUI,{"AFOR00","AFOR00"})
              aadd(sqlCAMPO,"first 50 FORNOM")
              aadd(sqlCAMPO,"FORCOD")
              aadd(sqlCAMPO,"FOREND")
              aadd(sqlCAMPO,"FOREST")
              aadd(sqlCHAVE,"FORNOM LIKE '" + alltrim(M_PROC) + "%'")
              aadd(sqlORDEM,"FORNOM")
             if !sqlrelation()
                lErroconsulta = .t.
             else
               oBrowse:RefreshCurrent()
            	oBrowse:Stabilize()
             endif

           case fARQUIVO == "AFIS00"
              sqlRELATION = {}
              sqlCAMPO = {}
              sqlCHAVE =  {}
              sqlARQUI = {}
              sqlORDEM = {}

              aadd(sqlARQUI,{"AFIS00","AFIS00"})
              aadd(sqlCAMPO,"*")
              aadd(sqlCHAVE,"FISEMP = " + str(1, 2, 0))
              aadd(sqlCHAVE,"FISNOV <> '    '")
              aadd(sqlCHAVE,"FISNOM LIKE '%" + alltrim(M_PROC) + "%'")
              if !sqlrelation()
                lErroconsulta = .t.
              else
                oBrowse:RefreshCurrent()
            	  oBrowse:Stabilize()
              endif
           case fARQUIVO == "AHIE00"
             dbseek( M_PROC,.t.)
        endcase

        if lErroconsulta
          msgbox1("Nenhum registro encontrado")
          wvw_lCloseWindow()

          RestScreen( 0, 0, maxrow(), maxcol(), cScr0 )
*          DevPos( nRow, nCol )
*          SetColor( cColor )
*          SetCursor( nCursor )
          return 0
        endif

        oBrowse:refreshALL()
        oBrowse:ForceStable()

      endif
	  
      if oBrowse:colPos = 4 // municipio cliente
        save get to M_GETBRO
        keyboard chr(nKey)
        M_PROC = space(lTampesq)
        setcolor("W+/N,W/N+")
        @ oBrowse:rowpos+5,76 get M_PROC picture "@!"
        read

        restore get from M_GETBRO

        do case
           case fARQUIVO == "ACLI00"
              seexistesql("ACLI00P")
              sqlRELATION = {}
              sqlCAMPO = {}
              sqlCHAVE =  {}
              sqlARQUI = {}
              sqlORDEM = {}

              aadd(sqlARQUI,{"ACLI00","ACLI00P"})
              aadd(sqlCAMPO,"CLINOM")
              aadd(sqlCAMPO,"CLICOD")
              aadd(sqlCAMPO,"CLIEND1")
              aadd(sqlCAMPO,"CLIMUN1")
              aadd(sqlCAMPO,"CLICLF")
              aadd(sqlCAMPO,"CLIUF1")
              aadd(sqlCHAVE,"CLIMUN1 LIKE '" + alltrim(M_PROC) + "%'")
              aadd(sqlORDEM,"CLINOM")
              if !sqlrelation()
                lErroconsulta = .t.
              else
                oBrowse:RefreshCurrent()
            	  oBrowse:Stabilize()
              endif
        endcase

        if lErroconsulta
          wvw_lCloseWindow()
          msgbox1("Nenhum registro encontrado")

*          DevPos( nRow, nCol )
*          SetColor( cColor )
*          SetCursor( nCursor )
          RestScreen( 0, 0, maxrow(), maxcol(), cScr0 )
          lDesligaRedraw := .f.

          return 0
        endif

        oBrowse:refreshALL()
        oBrowse:ForceStable()

      endif
	  
	  
    ENDCASE

   end

 wvw_lCloseWindow()
 RestScreen( 0, 0, maxrow(), maxcol(), cScr0 )

 *  DevPos( nRow, nCol )
 *  SetColor( cColor )
 *  SetCursor( nCursor )

*   RestScreen( 0, 0, maxrow(), maxcol(), cScr0 )
   lDesligaRedraw := .f.

   nCodRetorno = 0
   RETURN ""

//-------------------------------------------------------------------//
FUNCTION DbSkipBlock( n, oTbr )

   LOCAL nSkipped := 0

   if n == 0
      DBSkip( 0 )

   elseif n > 0
      do while nSkipped != n .and. TBNext( oTbr )
         nSkipped++
      enddo
   else
      do while nSkipped != n .and. TBPrev( oTbr )
         nSkipped--
      enddo
   endif

   RETURN  nSkipped
//-------------------------------------------------------------------//
FUNCTION TBNext()

   LOCAL nSaveRecNum := recno()
   LOCAL lMoved := .T.

   if Eof()
      lMoved := .F.
   else
      DBSkip( 1 )
      if Eof()
         lMoved := .F.
         DBGoTo( nSaveRecNum )
      endif
   endif

   RETURN lMoved
//-------------------------------------------------------------------//
FUNCTION TBPrev()
   LOCAL nSaveRecNum := Recno()
   LOCAL lMoved := .T.

   DBSkip( -1 )

   if Bof()
      DBGoTo( nSaveRecNum )
      lMoved := .F.
   endif

   RETURN lMoved
//-------------------------------------------------------------------//
FUNCTION VouBlockField( i )

   RETURN  {|| fieldget( i ) }
//-------------------------------------------------------------------//
FUNCTION BrwHandleKey( oBrowse, nKey, lEnd )
   LOCAL lRet := .t.

   do case
   case nKey == K_ESC
      lEnd := .t.

   case nKey == K_ENTER
      lEnd := .t.

   case nKey == K_DOWN
      oBrowse:Down()

   case nKey == K_UP
      oBrowse:Up()

   case nKey == K_LEFT
      oBrowse:Left()

   case nKey == K_RIGHT
      oBrowse:Right()

   case nKey == K_PGDN
      oBrowse:pageDown()

   case nKey == K_PGUP
      oBrowse:pageUp()

   case nKey == K_CTRL_PGUP
      oBrowse:goTop()

   case nKey == K_CTRL_PGDN
      oBrowse:goBottom()

   case nKey == K_HOME
      oBrowse:home()

   case nKey == K_END
      oBrowse:end()

   case nKey == K_CTRL_LEFT
      oBrowse:panLeft()

   case nKey == K_CTRL_RIGHT
      oBrowse:panRight()

   case nKey == K_CTRL_HOME
      oBrowse:panHome()

   case nKey == K_CTRL_END
      oBrowse:panEnd()

   case nKey == K_MWBACKWARD
      oBrowse:down()

   case nKey == K_MWFORWARD
      oBrowse:up()

   otherwise
      lRet := .f.

   endcase

   RETURN lRet

//-------------------------------------------------------------------//

FUNCTION BrwOnEvent( oWvtBrw, cPaintID, oBrowse, nKey )
   LOCAL lRet := .t., lRefAll := .f.

   HB_SYMBOL_UNUSED( cPaintID )

   do case
   case nKey == K_DOWN
      oBrowse:Down()

   case nKey == K_UP
      oBrowse:Up()

   case nKey == K_LEFT
      oBrowse:Left()

   case nKey == K_RIGHT
      oBrowse:Right()

   case nKey == K_PGDN
      oBrowse:pageDown()
      lRefAll := .t.

   case nKey == K_PGUP
      oBrowse:pageUp()
      lRefAll := .t.

   case nKey == K_CTRL_PGUP
      oBrowse:goTop()
      lRefAll := .t.

   case nKey == K_CTRL_PGDN
      oBrowse:goBottom()
      lRefAll := .t.

   case nKey == K_HOME
      oBrowse:home()

   case nKey == K_END
      oBrowse:end()

   case nKey == K_CTRL_LEFT
      oBrowse:panLeft()

   case nKey == K_CTRL_RIGHT
      oBrowse:panRight()

   case nKey == K_CTRL_HOME
      oBrowse:panHome()

   case nKey == K_CTRL_END
      oBrowse:panEnd()

   case nKey == K_MWBACKWARD
      oBrowse:down()

   case nKey == K_MWFORWARD
      oBrowse:up()

   case nKey == K_SBTHUMBTRACKVERT
      OrdKeyGoTo( oWvtBrw:oVBar:GetPos() )
      lRefAll := .t.

   case nKey == K_SBTHUMBTRACKHORZ
      oBrowse:ColPos := oWvtBrw:oHBar:GetPos()

   case nKey == K_SBLINEUP
      oBrowse:up()

   case nKey == K_SBLINEDOWN
      oBrowse:down()

   case nKey == K_SBPAGEUP
     oBrowse:PageUp()

   case nKey == K_SBPAGEDOWN
      oBrowse:PageDown()

   case nKey == K_SBLINELEFT
      oBrowse:Left()

   case nKey == K_SBLINERIGHT
      oBrowse:Right()

   case nKey == K_SBPAGELEFT
      oBrowse:Left()

   case nKey == K_SBPAGERIGHT
      oBrowse:right()

   otherwise
      lRet := .f.

   endcase

   if lRet
      if lRefAll
         oBrowse:RefreshAll()
      endif
      oBrowse:ForceStable()

      oWvtBrw:oVBar:SetPos( OrdKeyCount(),OrdKeyNo() )
      oWvtBrw:oHBar:SetPos( oBrowse:ColCount, oBrowse:ColPos )
   endif

   RETURN lRet



//-------------------------------------------------------------------//

#define ID_BTN_OK          1
#define ID_MLE            10
#define ID_CHK_SATIS      11
#define ID_EDT_TIME       51
#define ID_LST_LIST       13
#define ID_CMB_COMBO      31
#define ID_RDO_XH         21
#define ID_RDO_CLIP       22
#define ID_RDO_XBASE      23
#define ID_EDT_TEXT       14
#define ID_EDT_NUMB       15
#define ID_STA_TEXT       71
#define ID_STA_IMAGE      72
#define ID_ICO_VOUCH      81

#define ID_GRP_COMP      113

#define ID_MNU_FILE      201
#define ID_MNU_CONTROL   202

//-------------------------------------------------------------------//


STATIC FUNCTION MyDialogLocal()

*   LOCAL aObjects := WvtSetBlocks( {} )

   Local nWinRows, nWinCols, cWinTitle, cFont, nHeight
   Local cUseAlias
   Local oText, oTBar, aImg_, oImg, oLine, oBox, oBtn, oBtn2
   Local oBBox, oCon, oGet, oBBox2, oTBx
   Local oBRsd, cTxt, oRct, nGetCol, nSayCol, bBlock, bBlock1
   Local oWvtBrw, oWvtBrw1, lOpen, lOpen1, cUseAlias1, oGetArea, oGet1
   LOCAL hPopup, nGetRow, aGets_, lChkMouse
   LOCAL g_oMenuBar, oMenu,oPBar3
   LOCAL dDate   := ctod( '' )
   LOCAL cName   := Pad( 'Pritpal Bedi', 35 )
   LOCAL cAdd1   := Pad( '60, New Professor Colony', 35 )
   LOCAL cAdd2   := Pad( 'Ludhiana, INDIA', 35 )
   LOCAL cAdd3   := Pad( 'http://www.vouchcac.com', 35 )
   LOCAL nColGet := 8
   LOCAL nSlry   := 20000


   STATIC sUnits := 18
   STATIC lUnits := 10

   REQUEST SDDODBC,SQLMIX,SIXCDX,SDDFB
   ANNOUNCE RDDSYS

   nWinRows  := 28
   nWinCols  := 105
   cWinTitle := 'Sistema Integrado V. 4.3'
   cFont     := 'VISUALLIB'

   nHeight   := 10
   _FONTET_   = 5

   _FONTET_   = 10
   _FONTEL_   = 5

    nHeight = 0
    nWidth  = 0


   RDDSETDEFAULT("SQLMIX")

   if file("CONFIG.CFG")
      le_config()
     _FONTET_   = val(_FONTET_)
     _FONTEL_   = val(_FONTEL_)
     _LINHASIS_   = val(_LINHASIS_)
     _COLUNASIS_   = val(_COLUNASIS_)
   else
     _PATHSQL_  = "servidor/3050:C:\dados\CIRUR.fdb"  // local
     _PATHODBC_ = ""
   endif

   cAttributes:="Server=;Database=" + _PATHSQL_ + ";User=SYSDBA;Password=masterkey;Driver={Firebird/InterBase(r) driver};DIALECT=3"
*   cAttributesODBC:="Server=;Database=" + _PATHSQL_ + ";User=SYSDBA;Password=masterkey;Driver={Firebird/InterBase(r) driver};DIALECT=3"

   if empty(_PATHODBC_)  // se odbc nao configurado pegamos mesmo path
     cAttributesOdbc:= cAttributes
   else
     cAttributesOdbc:=    cAttributes:="Server=;Database=" + _PATHODBC_ + ";User=SYSDBA;Password=masterkey;Driver={Firebird/InterBase(r) driver};DIALECT=3"
     cAttributesOdbc:=  _PATHODBC_
   endif


   db := FBConnect(_PATHSQL_, "SYSDBA", "masterkey")
*   nConn := RDDINFO( RDDI_CONNECT,{"ODBC", cAttributesOdbc} )  // este somente conecta assim funciona

   nConn := RDDINFO( RDDI_CONNECT,{"ODBC", cAttributesOdbc} )  // este somente conecta assim funciona

   // quando na nuvem criar conexao ODBC
   // nConn := RDDINFO( RDDI_CONNECT,{"ODBC","DSN=TESTE"} )

   IF nConn == 0
     nHan := FCreate("errosql.txt")   // a tentar CRIAR.
     FWrite( nHan, "nao conectado" )
     FClose( nHan )   // Fechamos o Arquivo.
     @ 24, 00 SAY "Unable connect to the server"
     ALERT("NAO CONECTADO")
     RETURN
   else
     nHan := FCreate("errosql.txt")   // a tentar CRIAR.
     FWrite( nHan, "conectado" )
     FClose( nHan )   // Fechamos o Arquivo.
   eNDIF

   sqlORDEM = {}
   sqlCAMPO = {}
   sqlCHAVE =  {}
   sqlARQUI = {"CONFIGURAR","SELECT"}
   aadd(sqlCHAVE,{"MAQUINA",aspas(netname())})

   lMaquinaok := .t.

   if executasql()
     if FONTET > 0
       lMaquinaok := .t.
       nHeight = FONTET
     endif
     if FONTEL > 0
       nWidth = FONTEL
     endif

     _FONTET_   = FONTET
     _FONTEL_   = FONTEL

     wvw_setcodepage(,255)
     SETMODE(_LINHASIS_,_COLUNASIS_)
     wvw_SETFONT(, _FONTEN_ , FONTET -1, FONTEL, 0,255 )
   else
     lMaquinaok := .F.
   endif

   if !lMaquinaok
     wvw_setcodepage(,255)
     SETMODE(_LINHASIS_,_COLUNASIS_)
     For ABC = 1 to 40
       sUnits += 1
       wvw_SETFONT(,_FONTEN_ , sUnits -1, lUnits, 0,255 )
       fnt_:= WvW_GetFontInfo()
     next

     sUnits = fnt_[ 2 ]

     For ABC = 1 to 40
       lUnits += 1
       wvw_SETFONT(,_FONTEN_ , sUnits -1, lUnits, 0,255 )
      fnt_:= WvW_GetFontInfo()
     next

     lUnits = fnt_[ 3 ]
     lUnits = ((sUnits * 12)/23)

     _FONTET_   = sUnits
     _FONTEL_   = lUnits

     wvw_setcodepage(,255)
     SETMODE(_LINHASIS_,_COLUNASIS_)
     wvw_SETFONT(,_FONTEN_, sUnits-1, lUnits-1, 0,255 )
   endif

   SETMODE(_LINHASIS_,_COLUNASIS_)


   REQUEST DBFCDX
   RDDSETDEFAULT("DBFCDX")

/*
   ESTAVA ASSIM
   Hb_gtinfo( HB_GTI_PALETTE, 1,rgb( 0,0,0 ) )         // N Preto   oficial
   Hb_gtinfo( HB_GTI_PALETTE, 2,rgb( 0,  48, 108) )    // B Azul    oficial
   Hb_gtinfo( HB_GTI_PALETTE, 3,rgb( 0,  96,   0) )    // G Verde         oficial
   Hb_gtinfo( HB_GTI_PALETTE, 4,rgb(  0,  96,  96) )   // BG Ciano        oficial
   Hb_gtinfo( HB_GTI_PALETTE, 5,rgb( 189,54,54 ) )     // R  Vermelho alterado
   Hb_gtinfo( HB_GTI_PALETTE, 6,rgb( 0,63,107 ) )      // RB magenta alterado
   Hb_gtinfo( HB_GTI_PALETTE, 7,rgb( 249, 240, 108 ) ) // GR marrom alterado
   Hb_gtinfo( HB_GTI_PALETTE, 8,rgb( 179, 179, 179 ) ) // W  cinza claro  alterado
   Hb_gtinfo( HB_GTI_PALETTE, 9,rgb(122, 122, 122) )   // N+ rgb( 155, 155, 155 ) )   // N+
   Hb_gtinfo( HB_GTI_PALETTE, 10,rgb( 0,  96,  192) )  // B+
   Hb_gtinfo( HB_GTI_PALETTE, 11,rgb( 240,240,240 ) )  // G+ rgb( 195,208,217 ) )   // G+
   Hb_gtinfo( HB_GTI_PALETTE, 12,rgb(   0,164,164 ) )  // BG+
   Hb_gtinfo( HB_GTI_PALETTE, 13,rgb( 153,0,0 ) )      // R+
   Hb_gtinfo( HB_GTI_PALETTE, 14,rgb(  96, 96,192 ) )  // RB+
   Hb_gtinfo( HB_GTI_PALETTE, 15,rgb( 255,213, 86 ) )  // GR+  192,144,  0 ) )   // GR+
   Hb_gtinfo( HB_GTI_PALETTE, 16,rgb( 240,240,240 ) )  // W+
*/

// CORES

Hb_GTInfo( HB_GTI_PALETTE,  1, RGB(   0,   0,   0 ) )   // Preto
Hb_GTInfo( HB_GTI_PALETTE,  2, RGB(  14,  12,  68 ) )   // Azul
Hb_GTInfo( HB_GTI_PALETTE,  3, RGB(   9,  75,  79) )    // Verde RGB(   0, 128,   0 )
Hb_GTInfo( HB_GTI_PALETTE,  4, RGB(   9,  96, 114 ) )   // Ciano RGB(   0, 128, 128 )
Hb_GTInfo( HB_GTI_PALETTE,  5, RGB( 128,   0,   0 ) )   // Vermelho
Hb_GTInfo( HB_GTI_PALETTE,  6, RGB( 237, 237, 237 ) )   // Magenta
Hb_GTInfo( HB_GTI_PALETTE,  7, RGB( 213, 204,  11 ) )   // Marrom RGB( 128, 128,   0 ) RGB( 213, 204,  11 )
Hb_GTInfo( HB_GTI_PALETTE,  8, RGB( 192, 192, 192 ) )   // Cinza Claro   W
Hb_GTInfo( HB_GTI_PALETTE,  9, RGB( 128, 128, 128 ) )   // Cinza Escuro
Hb_GTInfo( HB_GTI_PALETTE, 10, RGB(   0,   0, 255 ) )   // Azul Claro
Hb_GTInfo( HB_GTI_PALETTE, 11, RGB(   0, 255,   0 ) )   // Verde Claro
Hb_GTInfo( HB_GTI_PALETTE, 12, RGB(  93, 203, 211 ) )   // Ciano Claro RGB(   0, 255, 255 )
Hb_GTInfo( HB_GTI_PALETTE, 13, RGB( 255,   0,   0 ) )   // Vermelho Claro
Hb_GTInfo( HB_GTI_PALETTE, 14, RGB( 248, 248, 248 ) )   // Magenta Claro
Hb_GTInfo( HB_GTI_PALETTE, 15, RGB( 227, 193,  71 ) )   // Amarelo RGB( 255, 255,   0 )
Hb_GTInfo( HB_GTI_PALETTE, 16, RGB( 233, 233, 233 ) )   // Branco   W+

   if !alltrim(upper(netname())) $ "#SERVIDOR#"
    oScriptObj := CREATEOBJECT( "wbemScripting.SwbemLocator" )
    oWmiService := oScriptObj:ConnectServer()
    oListaProcess := oWmiService:ExecQuery( "select * from Win32_Process where Name='Cirursql.exe'" )
     oProcessos = ""
     nQdeInstancia = 0
     for Each oProcessos in oListaProcess
       nQdeInstancia ++
     next
     if nQdeInstancia > 1
        MSGBOX1("O programa ja se encontra em uso!","Verifique no rodape")
        quit
     endif
   endif



RDDSETDEFAULT("DBFCDX")
REQUEST DBFCDX




MS = strzero(ME_EMP,2)
XMSG_1&MS = space(80)
XMSG_2&MS = space(80)
XMSG_3&MS = space(80)
XMSG_4&MS = space(80)
XMSG_5&MS = space(80)
XMSG_6&MS = space(80)
XMSG_7&MS = space(80)
XMSG_8&MS = space(80)
XMSG_9&MS = space(80)

* WVW_SetDefLineSpacing(10)
* wvw_SetLineSpacing( , 10 )


   novomenu()

   RETURN Nil

*****************
FUNCTION NOVOMENU
*****************

local aEnv


set key K_F10 to VLMARQUEE()  //Funcao utilizar  VLExit() da Visual Lib

Desktop(alltrim("")) //Fun‡Æo que inicializa a Visual Lib - Sempre deve ser chamada no inicio

*DrawFn( 01, "Sobre" )   //VL-Desenha fun‡Æo na linha 24
*DrawFn( 02, "Ajuda" )   //VL-Desenha fun‡Æo na linha 24
*DrawFn( 10, "Sa¡da" )   //VL-Desenha fun‡Æo na linha 24

//msgbox1("vamos ver" + str(_FONTET_) +  " " + str(_FONTEL_))



   wvw_sbSetFont( ,_FONTEN_, _FONTET_, _FONTEL_, 0, 200)
   wvw_SETFONT(, _FONTEN_, _FONTET_ -1, _FONTEL_-1, 0,200 )
*   wvw_SETFONT(,, 23, 18, 0,100 )


   nstatus := wvw_sbCreate()
   wvw_sbAddPart( , NIL, 260 )
   wvw_sbAddPart( , NIL, 260 )
   wvw_sbAddPart( , NIL, 260 )
   wvw_sbAddPart( , NIL, 260 )
   wvw_sbAddPart( , NIL, 160 )

   wvw_sbSetText( ,0, "")
   wvw_sbSetText( ,1,"")
   wvw_sbSetText( ,5,time())
   wvw_sbRefresh()

   wvw_sbSetText( ,2,"")

   wvw_SetTimer( , 1000 )

SELEEMPRESA()

mBar := NewBarMenu()            //(VL) Cria Menu de Barra
mEst := NewDownMenu()           //(VL) Cria Menu Down vinculado a mBar
mFat := NewDownMenu()           //(VL) Cria Menu Down vinculado a mBar
mRec := NewDownMenu()           //(VL) Cria Menu Down vinculado a mBar
mPag := NewDownMenu()           //(VL) Cria Menu Down vinculado a mBar
mBan := NewDownMenu()           //(VL) Cria Menu Down vinculado a mBar
mCai := NewDownMenu()           //(VL) Cria Menu Down vinculado a mBar
mOut := NewDownMenu()           //(VL) Cria Menu Down vinculado a mBar

mOpcoes := NewDownMenu()          //(VL) Cria Sub-Menu vinculado a mPdn

mEstemp := NewDownMenu()
mEstpro := NewDownMenu()
mEstfor := NewDownMenu()           //(VL) Cria Menu Down vinculado a mBar
mEstKar := NewDownMenu()
mEstGru := NewDownMenu()
mEstNcm := NewDownMenu()
mEstNfe := NewDownMenu()


AddDownItem( mEst, "&Empresas"           ,,mEstemp,,,,,1)
AddDownItem( mEst, "&Produtos"           ,,mEstpro,,,,,2 )
AddDownItem( mEst, "&Fornecedores"       ,,mEstFor,,,,,3 )
AddDownSep ( mEst )                                       // Linha de separa‡Æo
AddDownItem( mEst, "&Kardex"             ,,mEstkar,,,,,4 )
AddDownItem( mEst, "&Grupos"             ,,mEstGru,,,,,5 )
AddDownItem( mEst, "&Codigo NCM"         ,,mEstNcm,,,,,6 )
AddDownSep ( mEst )                                                // Linha de separa‡Æo
AddDownItem( mEst, "&Nota Fiscal Entrada",,mEstNfe,,,,,7)

*AddDownItem( mPdnSet, "Set &1", "Habilita/Desabilita Set 1", { || SetDownItem( mPdnSet, 1, !SetDownItem( mPdnSet, 1 ) ) } )

// EMPRESA
   AddDownItem( mEstemp, "&InclusÆo"  ,,{ || manemp(1) },,,,,8)
   AddDownItem( mEstemp, "&Altera‡Æo" ,,{ || manemp(2) },,,,,9)
   AddDownItem( mEstemp, "&Consulta"  ,,{ || manemp(3) },,,,,10)
   AddDownItem( mEstemp, "&ExclusÆo"  ,,{ || manemp(4) },,,,,11)
   AddDownItem( mEstemp, "&Listagem"  ,,{ || manemp(5) },,,,,12)
   AddDownItem( mEstemp, "&Parametro" ,,{ || manemp(6) },,,,,13)

// PRODUTOS
AddDownItem( mEstpro, "&InclusÆo"                   ,,{ ||manpro(1)},,,,,14)
AddDownItem( mEstpro, "&Altera‡Æo"                  ,,{ ||manpro(2)},,,,,15)
AddDownItem( mEstpro, "&Consulta"                   ,,{ ||manpro(3)},,,,,16)
AddDownItem( mEstpro, "&ExclusÆo"                   ,,{ ||manpro(4)},,,,,17)
   mEstProlis := NewDownMenu()
   AddDownItem( mEstProlis, "&Rela‡„o de Compra"      ,,{ ||manpro(5,1)},,,,,18 )
   AddDownItem( mEstProlis, "&Rela‡„o por Grupo"      ,,{ ||manpro(5,2)},,,,,19 )
   AddDownItem( mEstProlis, "&Lista Pre‡os Venda"     ,,{ ||manpro(5,3)},,,,,20 )
   AddDownItem( mEstProlis, "&Planilha Balanco"       ,,{ ||manpro(5,4)},,,,,21 )
   AddDownItem( mEstProlis, "&Inventario Conferencia" ,,{ ||manpro(5,5)},,,,,22 )

     mEstProlisSaldo := NewDownMenu()
     AddDownItem( mEstProlisSaldo, "&Saldos de todos os Produtos"       ,,{ ||manpro(5,6,1)},,,,,23 )
     AddDownItem( mEstProlisSaldo, "&Produtos Com Saldo Positivo"       ,,{ ||manpro(5,6,2)},,,,,24 )
     AddDownItem( mEstProlisSaldo, "&Produtos Com Saldo Negativo"       ,,{ ||manpro(5,6,3)},,,,,25 )
     AddDownItem( mEstProlisSaldo, "&Produtos Com Saldo Zerado"         ,,{ ||manpro(5,6,4)},,,,,26 )
     AddDownItem( mEstProlisSaldo, "&N„o Movimentados desde (MM/AA)"    ,,{ ||manpro(5,6,5)},,,,,27 )
     AddDownItem( mEstProlisSaldo, "&Produtos Acima Estoque MAXIMO"     ,,{ ||manpro(5,6,6)},,,,,28 )
     AddDownItem( mEstProlisSaldo, "&Produtos Abaixo Estoque MINIMO"    ,,{ ||manpro(5,6,7)},,,,,29 )

   AddDownItem( mEstProlis, "&Lista de Saldos"       ,,mEstProlisSaldo     ,,,,,30 )
   AddDownItem( mEstProlis, "&Inventario Efetivo"    ,,{ ||manpro(5,7)}    ,,,,,31 )

     mEstProlisFabri := NewDownMenu()
     AddDownItem( mEstProlisFabri, "&Saldos de todos os Produtos"       ,,{ ||manpro(5,8,1)},,,,,32 )
     AddDownItem( mEstProlisFabri, "&Produtos Com Saldo Positivo"       ,,{ ||manpro(5,8,2)},,,,,33 )
     AddDownItem( mEstProlisFabri, "&Produtos Com Saldo Negativo"       ,,{ ||manpro(5,8,3)},,,,,34 )
     AddDownItem( mEstProlisFabri, "&Produtos Com Saldo Zerado"         ,,{ ||manpro(5,8,4)},,,,,35 )
     AddDownItem( mEstProlisFabri, "&N„o Movimentados desde (MM/AA)"    ,,{ ||manpro(5,8,5)},,,,,36 )
     AddDownItem( mEstProlisFabri, "&Produtos Acima Estoque MAXIMO"     ,,{ ||manpro(5,8,6)},,,,,37 )
     AddDownItem( mEstProlisFabri, "&Produtos Abaixo Estoque MINIMO"    ,,{ ||manpro(5,8,7)},,,,,38 )

   AddDownItem( mEstProlis, "&Lista por Fabricante"  ,,mEstProlisFabri    ,,,,,39 )
   AddDownItem( mEstProlis, "&Classificacao Fiscal"  ,,{ ||manpro(5,9)}   ,,,,,40 )

AddDownItem( mEstpro, "&Listagem"                   ,,mEstProlis          ,,,,,41 )
   mEstProPre := NewDownMenu()
   AddDownItem( mEstProPre, "&Altera pre‡o Custo"   ,,{ ||manpro(6,1)}      ,,,,,42 )
   AddDownItem( mEstProPre, "&Altera pre‡o Venda"   ,,{ ||manpro(6,2)}      ,,,,,43 )
   AddDownItem( mEstProPre, "&Altera pre‡o Geral"   ,,{ ||manpro(6,3)}      ,,,,,44 )
AddDownItem( mEstpro, "&Pre‡os"                     ,,mEstProPre            ,,,,,45 )
AddDownItem( mEstpro, "&Arquivo Morto"              ,,{ ||manpro(7)}        ,,,,,46 )
AddDownItem( mEstpro, "&Codigos Fornecedores"       ,,{ ||manpro(8)}        ,,,,,47 )

// FORNECEDOR
AddDownItem( mEstFor, "&InclusÆo"     ,,{ ||manfor(1)},,,,,48)
AddDownItem( mEstFor, "&Altera‡Æo"    ,,{ ||manfor(2)},,,,,49)
AddDownItem( mEstFor, "&Consulta"     ,,{ ||manfor(3)},,,,,50)
AddDownItem( mEstFor, "&ExclusÆo"     ,,{ ||manfor(4)},,,,,51)
AddDownItem( mEstFor, "&Listagem"     ,,{ ||manfor(5)},,,,,52)
AddDownItem( mEstFor, "&Etiquetas"    ,,{ ||manfor(6)},,,,,53)
AddDownItem( mEstFor, "&Arquivo Morto",,{ ||manfor(7)},,,,,54)

AddDownItem( mEstkar, "&InclusÆo"                   ,,{ ||mankar(1)}   ,,,,,55)
AddDownItem( mEstkar, "&Altera‡Æo"                  ,,{ ||mankar(2)}   ,,,,,56)

   mEstkarConsulta := NewDownMenu()
   AddDownItem( mEstkarConsulta, "&Movimento"      ,,{ ||mankar(3,1)} ,,,,,57)
   AddDownItem( mEstkarConsulta, "&Compras"        ,,{ ||mankar(3,2)} ,,,,,58)
   AddDownItem( mEstkarConsulta, "&Vendas"         ,,{ ||mankar(3,3)} ,,,,,59)
   AddDownItem( mEstkarConsulta, "&Grafico V"      ,,{ ||mankar(3,4)} ,,,,,60)
   AddDownItem( mEstkarConsulta, "&Grafico C"      ,,{ ||mankar(3,5)} ,,,,,61)
AddDownItem( mEstkar, "&Consulta"                  ,,mEstkarConsulta  ,,,,,62)
AddDownItem( mEstkar, "&ExclusÆo"                  ,,{ ||mankar(4)}   ,,,,,63)
   mEstkarListagem := NewDownMenu()
   AddDownItem( mEstkarListagem, "&Movimento"      ,,{ ||mankar(5,1)} ,,,,,64)
   AddDownItem( mEstkarListagem, "&Entrada/Saida"  ,,{ ||mankar(5,2)} ,,,,,65)
AddDownItem( mEstkar, "&Listagem"                  ,,mEstkarListagem  ,,,,,66)
   mEstkarOutros := NewDownMenu()
   AddDownItem( mEstkarOutros, "&Saldo Individual"  ,,{ ||mankar(6,1)} ,,,,,67)
   AddDownItem( mEstkarOutros, "&Saldo Geral"       ,,{ ||mankar(6,2)} ,,,,,68)
   AddDownItem( mEstkarOutros, "&Custo Medio"       ,,{ ||mankar(6,3)} ,,,,,70)
   AddDownItem( mEstkarOutros, "&Grafico Anual"     ,,{ ||mankar(6,4)} ,,,,,71)
   AddDownItem( mEstkarOutros, "&Finaliza Exercicio",,{ ||mankar(6,5)} ,,,,,72)
AddDownItem( mEstkar, "&Outros"                     ,,mEstkarOutros    ,,,,,73)


AddDownItem( mEstGru, "&InclusÆo" ,,{ ||mangrp(1)},,,,,74)
AddDownItem( mEstGru, "&Altera‡Æo",,{ ||mangrp(2)},,,,,75)
AddDownItem( mEstGru, "&Consulta" ,,{ ||mangrp(3)},,,,,76)
AddDownItem( mEstGru, "&ExclusÆo" ,,{ ||mangrp(4)},,,,,77)
AddDownItem( mEstGru, "&Listagem" ,,{ ||mangrp(5)},,,,,78)


AddDownItem( mEstNfe, "&InclusÆo"             ,,{ ||mannfe(1)}   ,,,,,79)
AddDownItem( mEstNfe, "&Altera‡Æo"            ,,{ ||mannfe(2)}   ,,,,,80)
AddDownItem( mEstNfe, "&Consulta"             ,,{ ||mannfe(3)}   ,,,,,81)
AddDownItem( mEstNfe, "&ExclusÆo"             ,,{ ||mannfe(4)}   ,,,,,82)
   mEstNfeListagem := NewDownMenu()
   AddDownItem( mEstNfeListagem, "&Analitico" ,,{ ||mannfe(5,1)} ,,,,,83)
   AddDownItem( mEstNfeListagem, "&Sint‚tico" ,,{ ||mannfe(5,2)} ,,,,,84)
AddDownItem( mEstNfe, "&Listagem"             ,,mEstNfeListagem  ,,,,,85)
AddDownItem( mEstNfe, "&Implementacao"        ,,{ ||mannfe(6)}   ,,,,,86)
AddDownItem( mEstNfe, "&Ler XML"              ,,{ ||mannfe(7)}   ,,,,,87)

*mEstncm := NewDownMenu()
AddDownItem( mEstNcm, "&InclusÆo"             ,,{ ||manncm(1)},,,,,88)
AddDownItem( mEstNcm, "&Altera‡Æo"            ,,{ ||manncm(2)},,,,,89)
AddDownItem( mEstNcm, "&Consulta"             ,,{ ||manncm(3)},,,,,90)
AddDownItem( mEstNcm, "&ExclusÆo"             ,,{ ||manncm(4)},,,,,91)
AddDownItem( mEstNcm, "&Listagem"             ,,{ ||manncm(5)},,,,,92)


AddBarItem( mBar, "&Estoque"   ,, mEst,,,,,93 )
AddBarItem( mBar, "&Faturar"   ,, mFat,,,,,94 )
AddBarItem( mBar, "&Receber"   ,, mRec,,,,,95 )
AddBarItem( mBar, "&Pagar"     ,, mPag,,,,,96 )
AddBarItem( mBar, "&Bancos"    ,, mBan,,,,,97 )
AddBarItem( mBar, "&Caixa"     ,, mCai,,,,,98 )
AddBarItem( mBar, "&Outros"    ,, mOut,,,,,99 )


 //  SetDownItem( mEstemp, 2, .f. )  // desabilita uma opcao exemplo empresa altera

   mFatNotas := NewDownMenu()
   AddDownItem( mFatNotas, "&EmissÆo" ,,{ || mannfs(1) },,,,,100)

     mFatNotasAlt := NewDownMenu()
     AddDownItem( mFatNotasAlt, "&Nota Fiscal"     ,,{ || mannfs(2,1) } ,,,,,101)
     AddDownItem( mFatNotasAlt, "&Escrituracao"    ,,{ || mannfs(2,2) } ,,,,,102)
     AddDownItem( mFatNotasAlt, "&Natureza"        ,,{ || mannfs(2,3) } ,,,,,103)
     AddDownItem( mFatNotasAlt, "&Relatorio"       ,,{ || mannfs(2,4) } ,,,,,104)

   AddDownItem( mFatNotas, "&Altera‡Æo"                         ,,mFatNotasAlt   ,,,,,105 )
   AddDownItem( mFatNotas, "&Consulta"                          ,,{ || mannfs(3)},,,,,106 )
   AddDownItem( mFatNotas, "&ExclusÆo"                          ,,{ || mannfs(4)},,,,,107 )
      mFatNotasListagem := NewDownMenu()
      AddDownItem( mFatNotasListagem, "&Sintetica Notas Fiscais"  ,,{ || mannfs(5,1) }       ,,,,,108)
      AddDownItem( mFatNotasListagem, "&Cliente Analitico"        ,,{ || mannfs(5,2) }       ,,,,,109)
      AddDownItem( mFatNotasListagem, "&Cliente Sintetico"        ,,{ || mannfs(5,3) }       ,,,,,110)
      AddDownItem( mFatNotasListagem, "&Nota de Servico"          ,,{ || mannfs(5,4) }       ,,,,,111)
      AddDownItem( mFatNotasListagem, "&Vendedor Notas"           ,,{ || mannfs(5,5) }       ,,,,,112)
      AddDownItem( mFatNotasListagem, "&Vendedor Sintetico"       ,,{ || mannfs(5,6) }       ,,,,,113)
      AddDownItem( mFatNotasListagem, "&Municipio Sintetico"      ,,{ || mannfs(5,7) }       ,,,,,114)
      AddDownItem( mFatNotasListagem, "&Produto Sintetico"        ,,{ || mannfs(5,8) }       ,,,,,115)
      AddDownItem( mFatNotasListagem, "&Notas Emitidas no Periodo",,{ || mannfs(5,9) }       ,,,,,116)
      AddDownItem( mFatNotasListagem, "&Margem Bruta de Vendas"   ,,{ || mannfs(5,11) }      ,,,,,117)
      AddDownItem( mFatNotasListagem, "&Etiquetas de Caixa"       ,,{ || mannfs(5,11) }      ,,,,,118)
      AddDownItem( mFatNotasListagem, "&Faturamento"              ,,{ || mannfs(5,12) }      ,,,,,119)
      AddDownItem( mFatNotasListagem, "&Notas no Periodo (Antigo)",,{ || mannfs(5,14) }      ,,,,,120)
      AddDownItem( mFatNotasListagem, "&Produtos Isentos"         ,,{ || mannfs(5,15) }      ,,,,,121)
      AddDownItem( mFatNotasListagem, "&IMS"                      ,,{ || mannfs(5,16) }      ,,,,,122)
      AddDownItem( mFatNotasListagem, "&Prodiet"                  ,,{ || mannfs(5,17) }      ,,,,,122)
   AddDownItem( mFatNotas, "&Listagem"                          ,,mFatNotasListagem          ,,,,,123)

     mFatNotasOut := NewDownMenu()
     AddDownItem( mFatNotasOut, "&Carta de Correcao"  ,,{ || mannfs(6,1)} ,,,,,124)
     AddDownItem( mFatNotasOut, "&Cancelamento"       ,,{ || mannfs(6,2)} ,,,,,125)
     AddDownItem( mFatNotasOut, "&Reemissao"          ,,{ || mannfs(6,3)} ,,,,,126)
     AddDownItem( mFatNotasOut, "&Enviar Email"       ,,{ || mannfs(6,4)} ,,,,,127)

   AddDownItem( mFatNotas, "&Outros"                  ,,mFatNotasOut      ,,,,,128)

   AddDownItem( mFatNotas, "&Transporte"              ,,{ || mannfs(7)}   ,,,,,129)
   AddDownItem( mFatNotas, "&Inclusao"                ,,{ || mannfs(8) }  ,,,,,130)
   AddDownItem( mFatNotas, "&Carta de Credito"                  ,,{ || emicre()},,,,,107 )
   AddDownItem( mFatNotas, "&Etiqueta Argox"                  ,,{ || mangel1()},,,,,107 )



AddDownItem( mFat, "&Nota Fiscal"                     ,,mFatNotas         ,,,,,131)


   mFatPedidos := NewDownMenu()
   AddDownItem( mFatPedidos, "&EmissÆo"   ,,{ || manped(1)},,,,,132)
   AddDownItem( mFatPedidos, "&Altera‡Æo" ,,{ || manped(2)},,,,,133)

        mFatPedidosCon := NewDownMenu()
     AddDownItem( mFatPedidosCon, "&Pedido"     ,,{ || manped(3,1)},,,,,134)
     AddDownItem( mFatPedidosCon, "&Cliente"    ,,{ || manped(3,2)},,,,,135)
*     AddDownItem( mFatPedidosCon, "&Fornecedor" ,,{ || manped(3,3)},,,,,136)

   AddDownItem( mFatPedidos, "&Consulta"       ,,mFatPedidosCon            ,,,,,137)
   AddDownItem( mFatPedidos, "&ExclusÆo"  ,,{ || manped(4)}                ,,,,,138)

      mFatPedidosListagem := NewDownMenu()
      AddDownItem( mFatPedidosListagem, "&Listagem de Pedidos"  ,,{ || manped(5,1)}             ,,,,,139)
      AddDownItem( mFatPedidosListagem, "&Relacao por Produto"  ,,{ || manped(5,2)}             ,,,,,140)
      AddDownItem( mFatPedidosListagem, "&Sintetica Pedidos"    ,,{ || manped(5,3)}             ,,,,,141)
      AddDownItem( mFatPedidosListagem, "&Relacao por Grupo"    ,,{ || manped(5,4)}             ,,,,,142)
      AddDownItem( mFatPedidosListagem, "&Relacao por Cliente"  ,,{ || manped(5,5)}             ,,,,,143)
      AddDownItem( mFatPedidosListagem, "&Analitico Vendedor"   ,,{ || manped(5,6)}             ,,,,,144)
   AddDownItem( mFatPedidos, "&Listagem",,mFatPedidosListagem       ,,,,,145)

      mFatPedidosOutros := NewDownMenu()
      AddDownItem( mFatPedidosOutros, "&Alteracao"      ,,{ || manped(6,1)}    ,,,,,146)
      AddDownItem( mFatPedidosOutros, "&Emissao Nota"   ,,{ || manped(6,2)}    ,,,,,147)
   AddDownItem( mFatPedidos, "&Agrupamento",,mFatPedidosOutros                 ,,,,,148)

AddDownItem( mFat, "&Orcamento",,mFatPedidos,,,,,149 )

   mFatRequisi := NewDownMenu()
   AddDownItem( mFatRequisi, "&EmissÆo"   ,,{ || manreq(1)},,,,,150)
   AddDownItem( mFatRequisi, "&ReemissÆo"   ,,{ || manreq(7)},,,,,150)
   AddDownItem( mFatRequisi, "&Altera‡Æo" ,,{ || manreq(2)},,,,,151)

        mFatRequisiCon := NewDownMenu()
     AddDownItem( mFatRequisiCon, "&Aluguel" ,,{ || manreq(3,1)},,,,,152)
     AddDownItem( mFatRequisiCon, "&Cliente"    ,,{ || manreq(3,2)},,,,,153)

   AddDownItem( mFatRequisi, "&Consulta"        ,,mFatRequisiCon           ,,,,,154 )
   AddDownItem( mFatRequisi, "&ExclusÆo"  ,,{ || manreq(4)}                ,,,,,155)

      mFatRequisiListagem := NewDownMenu()
      AddDownItem( mFatRequisiListagem, "&Listagem de Requisicoes",,{ || manreq(5,1)}      ,,,,,156)
      AddDownItem( mFatRequisiListagem, "&Relacao por Produto"    ,,{ || manreq(5,2)}      ,,,,,157)
      AddDownItem( mFatRequisiListagem, "&Analitica Requisicao"   ,,{ || manreq(5,3)}      ,,,,,158)
      AddDownItem( mFatRequisiListagem, "&Sintetica Requisicao"   ,,{ || manreq(5,4)}      ,,,,,159)
      AddDownItem( mFatRequisiListagem, "&Relacao por Cliente"    ,,{ || manreq(5,5)}      ,,,,,160)
      AddDownItem( mFatRequisiListagem, "&Analitico Vendedor"     ,,{ || manreq(5,6)}      ,,,,,161)
      AddDownItem( mFatRequisiListagem, "&Analitico Clilente"     ,,{ || manreq(5,7)}      ,,,,,162)
      AddDownItem( mFatRequisiListagem, "&Resumo de Vendas"       ,,{ || manreq(5,8)}      ,,,,,163)
      AddDownItem( mFatRequisiListagem, "&Mapa Resumido Indicado" ,,{ || manreq(5,9)}      ,,,,,164)
   AddDownItem( mFatRequisi, "&Listagem",,mFatRequisiListagem       ,,,,,165)

      mFatRequisiOutros := NewDownMenu()
      AddDownItem( mFatRequisiOutros, "&Renovacao"      ,,{ || manreq(6,1)}    ,,,,,166)
      AddDownItem( mFatRequisiOutros, "&Encerramento"   ,,{ || manreq(6,2)}    ,,,,,167)
      AddDownItem( mFatRequisiOutros, "&Listagem"       ,,{ || manreq(6,3)}    ,,,,,168)
   AddDownItem( mFatRequisi, "&Aluguel",,mFatRequisiOutros                     ,,,,,169)
AddDownItem( mFat, "&Requisi‡Æo",,mFatRequisi,,,,,170 )

// CUPOM SAT

   mFatSat := NewDownMenu()
   AddDownItem( mFatSat, "&EmissÆo"   ,,{ || mansat(1,1)},,,,,171)
   AddDownItem( mFatSat, "&InclusÆo"  ,,{ || mansat(1,2)},,,,,172)
   AddDownItem( mFatSat, "&Altera‡Æo" ,,{ || mansat(2)}  ,,,,,173)

        mFatSatCon := NewDownMenu()
     AddDownItem( mFatSatCon, "&Cupom Fiscal" ,,{ || mansat(3,1)},,,,,174)
     AddDownItem( mFatSatCon, "&Cliente"      ,,{ || mansat(3,2)},,,,,175)

   AddDownItem( mFatSat, "&Consulta"                        ,,mFatSatCon,,,,,176)
   AddDownItem( mFatSat, "&ReemissÆo"  ,,{ || mansat(4)}                ,,,,,177)

      mFatSatListagem := NewDownMenu()
      AddDownItem( mFatSatListagem, "&Faturamento do Dia" ,,{ || mansat(5,1)}     ,,,,,178)
      AddDownItem( mFatSatListagem, "&Mapa Resumo Fiscal" ,,{ || mansat(5,2)}     ,,,,,179)
      AddDownItem( mFatSatListagem, "&Produto Sintetica"  ,,{ || mansat(5,3)}     ,,,,,180)
   AddDownItem( mFatSat, "&Listagem",,mFatSatListagem                             ,,,,,181)
   AddDownItem( mFatSat, "&Cancelamento"  ,,{ || mansat(6)}                       ,,,,,182)

AddDownItem( mFat, "&Cupom Eletronico",,mFatSat,,,,,183 )

   mFatCli := NewDownMenu()
   AddDownItem( mFatCli, "&InclusÆo"  ,,{ || mancli(1) }  ,,,,,183)
   AddDownItem( mFatCli, "&Altera‡Æo" ,,{ || mancli(2) }  ,,,,,184)
   AddDownItem( mFatCli, "&Consulta"  ,,{ || mancli(3)}   ,,,,,185)
   AddDownItem( mFatCli, "&ExclusÆo"  ,,{ || mancli(4)}   ,,,,,186)

      mFatCliLista := NewDownMenu()
      AddDownItem( mFatCliLista, "&Completa Codigo"     ,,{ || mancli(5,1)} ,,,,,187 )
      AddDownItem( mFatCliLista, "&Completa CPF/CNPJ"   ,,{ || mancli(5,2)} ,,,,,188 )
      AddDownItem( mFatCliLista, "&Completa Alfabetica" ,,{ || mancli(5,3)} ,,,,,189 )
      AddDownItem( mFatCliLista, "&Catalogo Codigo"     ,,{ || mancli(5,4)} ,,,,,190 )
      AddDownItem( mFatCliLista, "&Catalogo CPF/CNPJ"   ,,{ || mancli(5,5)} ,,,,,191 )
      AddDownItem( mFatCliLista, "&Catalogo Alfabetica" ,,{ || mancli(5,6)} ,,,,,192 )
      AddDownItem( mFatCliLista, "&Catalogo Municipio"  ,,{ || mancli(5,7)} ,,,,,193 )
   AddDownItem( mFatCli, "&Listagem"        ,,mFatCliLista      ,,,,,194 )

      mFatCliEtiqueta := NewDownMenu()
      AddDownItem( mFatCliEtiqueta, "&Codigo"     ,,{ || mancli(6,1)} ,,,,,194 )
      AddDownItem( mFatCliEtiqueta, "&Sele‡Æo"    ,,{ || mancli(6,2)} ,,,,,195 )
      AddDownItem( mFatCliEtiqueta, "&Nome"       ,,{ || mancli(6,3)} ,,,,,196 )
      AddDownItem( mFatCliEtiqueta, "&Parametro"  ,,{ || mancli(6,4)} ,,,,,197 )

   AddDownItem( mFatCli, "&Etiqueta"              ,,mFatCliEtiqueta         ,,,,,198)
   AddDownItem( mFatCli, "&Arquivo Morto"         ,,{ || mancli(7)}         ,,,,,199)

      mFatCliTipo := NewDownMenu()
   AddDownItem( mFatCliTipo, "&InclusÆo"  ,,{ || mancli(8,1)} ,,,,,200)
   AddDownItem( mFatCliTipo, "&Altera‡Æo" ,,{ || mancli(8,2)} ,,,,,201)
   AddDownItem( mFatCliTipo, "&Consulta"  ,,{ || mancli(8,3)} ,,,,,202)
   AddDownItem( mFatCliTipo, "&ExclusÆo"  ,,{ || mancli(8,4)} ,,,,,203)
   AddDownItem( mFatCliTipo, "&Listagem"  ,,{ || mancli(8,5)} ,,,,,204)
   AddDownItem( mFatCli, "&Tipo Cliente"  ,,mFatCliTipo       ,,,,,205)


AddDownItem( mFat, "&Clientes",,mFatCli,,,,,206 )

AddDownSep ( mFat )     // Linha de separa‡Æo

   mFatVen := NewDownMenu()
   AddDownItem( mFatVen, "&InclusÆo"    ,,{ || manven(1)},,,,,207)
   AddDownItem( mFatVen, "&Altera‡Æo"   ,,{ || manven(2)},,,,,208)
   AddDownItem( mFatVen, "&Consulta"    ,,{ || manven(3)},,,,,209)
   AddDownItem( mFatVen, "&ExclusÆo"    ,,{ || manven(4)},,,,,210)
   AddDownItem( mFatVen, "&Listagem"    ,,{ || manven(5)},,,,,211)

      mFatVenComissao := NewDownMenu()
      AddDownItem( mFatVenComissao, "&Pagameto"      ,,{ || manven(6,1)},,,,,212)
      AddDownItem( mFatVenComissao, "&Vencimento"    ,,{ || manven(6,2)},,,,,213)
      AddDownItem( mFatVenComissao, "&Emissao"       ,,{ || manven(6,3)},,,,,214)
      AddDownItem( mFatVenComissao, "&Aberto"        ,,{ || manven(6,4)},,,,,215)
   AddDownItem( mFatVen, "&ComissÆo"    ,,mFatVenComissao,,,,,216)

AddDownItem( mFat, "&Vendedores",,mFatVen ,,,,,217)

   mFatTra := NewDownMenu()
   AddDownItem( mFatTra, "&InclusÆo"        ,,{ || mantra(1)},,,,,218)
   AddDownItem( mFatTra, "&Altera‡Æo"       ,,{ || mantra(2)},,,,,219)
   AddDownItem( mFatTra, "&Consulta"        ,,{ || mantra(3)},,,,,220)
   AddDownItem( mFatTra, "&ExclusÆo"        ,,{ || mantra(4)},,,,,221)
   AddDownItem( mFatTra, "&Listagem"        ,,{ || mantra(5)},,,,,222)
AddDownItem( mFat, "&Transportadora",,mFatTra ,,,,,223)
AddDownSep ( mFat )     // Linha de separa‡Æo

   mFatCpg := NewDownMenu()
   AddDownItem( mFatCpg, "&InclusÆo"      ,,{ || mancpg(1)},,,,,224)
   AddDownItem( mFatCpg, "&Altera‡Æo"     ,,{ || mancpg(2)},,,,,225)
   AddDownItem( mFatCpg, "&Consulta"      ,,{ || mancpg(3)},,,,,226)
   AddDownItem( mFatCpg, "&ExclusÆo"      ,,{ || mancpg(4)},,,,,227)
   AddDownItem( mFatCpg, "&Listagem"      ,,{ || mancpg(5)},,,,,228)
AddDownItem( mFat, "&Pagamentos",,mFatCpg   ,,,,,229)


   mFatInd := NewDownMenu()
   AddDownItem( mFatInd, "&InclusÆo"      ,,{ || manind(1)},,,,,230)
   AddDownItem( mFatInd, "&Altera‡Æo"     ,,{ || manind(2)},,,,,231)
   AddDownItem( mFatInd, "&Consulta"      ,,{ || manind(3)},,,,,232)
   AddDownItem( mFatInd, "&ExclusÆo"      ,,{ || manind(4)},,,,,233)
   AddDownItem( mFatInd, "&Listagem"      ,,{ || manind(5)},,,,,234)
AddDownItem( mFat, "&Indicado",,mFatInd   ,,,,,235)

AddDownItem( mFat, "&Mensagem NF",,{ || manmsg()},,,,,234)


  mFinReceberDup := NewDownMenu()

  AddDownItem( mFinReceberDup, "&InclusÆo",,{ || mandcr(1)}  ,,,,,236  )

    mFinReceberDupAlt := NewDownMenu()
    AddDownItem( mFinReceberDupAlt, "&Titulo"   ,,{ || mandcr(2,1)} ,,,,,237)
*    AddDownItem( mFinReceberDupAlt, "&Comissao" ,,{ || mandcr(2,2)} ,,,,,238)
    AddDownItem( mFinReceberDupAlt, "&Pagamento",,{ || mandcr(2,3)} ,,,,,239)
    AddDownItem( mFinReceberDupAlt, "&Exportar" ,,{ || mandcr(2,4)} ,,,,,240)
  AddDownItem( mFinReceberDup, "&Alteracao"     ,,mFinReceberDupAlt ,,,,,241)

    mFinReceberDupCon := NewDownMenu()
    AddDownItem( mFinReceberDupCon, "&Sequencia",,{ || mandcr(3,1)} ,,,,,242)
    AddDownItem( mFinReceberDupCon, "&Vencidas" ,,{ || mandcr(3,2)} ,,,,,243)
    AddDownItem( mFinReceberDupCon, "&Emissao"  ,,{ || mandcr(3,3)} ,,,,,244)
    AddDownItem( mFinReceberDupCon, "&Codigos"  ,,{ || mandcr(3,4)} ,,,,,245)
    AddDownItem( mFinReceberDupCon, "&Portador" ,,{ || mandcr(3,5)} ,,,,,246)
    AddDownItem( mFinReceberDupCon, "&Pagamento",,{ || mandcr(3,6)} ,,,,,247)
  AddDownItem( mFinReceberDup, "&Consulta"      ,,mFinReceberDupCon ,,,,,248)

  AddDownItem( mFinReceberDup, "&ExclusÆo",,{ || mandcr(4)}  ,,,,,249  )

    mFinReceberDupLis := NewDownMenu()
    AddDownItem( mFinReceberDupLis, "&Perda"    ,,{ || mandcr(5,1)} ,,,,,250)
    AddDownItem( mFinReceberDupLis, "&Vencidas" ,,{ || mandcr(5,2)} ,,,,,251)
    AddDownItem( mFinReceberDupLis, "&Nome"     ,,{ || mandcr(5,3)} ,,,,,252)
    AddDownItem( mFinReceberDupLis, "&Codigo"   ,,{ || mandcr(5,4)} ,,,,,253)
    AddDownItem( mFinReceberDupLis, "&Portador" ,,{ || mandcr(5,5)} ,,,,,254)
    AddDownItem( mFinReceberDupLis, "&Pagamento",,{ || mandcr(5,6)} ,,,,,255)
    AddDownItem( mFinReceberDupLis, "&Sequencia",,{ || mandcr(5,7)} ,,,,,256)
    AddDownItem( mFinReceberDupLis, "&EmissÆo"  ,,{ || mandcr(5,8)} ,,,,,257)
    AddDownItem( mFinReceberDupLis, "&Cidade"   ,,{ || mandcr(5,9)} ,,,,,258)
  AddDownItem( mFinReceberDup, "&Listagem"      ,,mFinReceberDupLis ,,,,,259)

    mFinReceberDupTit := NewDownMenu()
    AddDownItem( mFinReceberDupTit, "&Brasil"     ,,{ || mandcr(6,1)} ,,,,,264)
    AddDownItem( mFinReceberDupTit, "&Sicred    " ,,{ || mandcr(6,2)} ,,,,,265)
  AddDownItem( mFinReceberDup, "&Titulos"         ,,mFinReceberDupTit ,,,,,267)
  AddDownItem( mRec, "&Duplicata"          ,,mFinReceberDup           ,,,,,268)


  mFinReceberIns := NewDownMenu()
  AddDownItem( mFinReceberIns, "&InclusÆo"        ,,{ || manlcr(1)}       ,,,,,269)
  AddDownItem( mFinReceberIns, "&Altera‡Æo"       ,,{ || manlcr(2)}       ,,,,,270)

    mFinReceberInsCon := NewDownMenu()
    AddDownItem( mFinReceberInsCon, "&Instru‡Æo"  ,,{ || manlcr(3,1)}     ,,,,,271)
    AddDownItem( mFinReceberInsCon, "&Duplicata"  ,,{ || manlcr(3,2)}     ,,,,,272)
    AddDownItem( mFinReceberInsCon, "&Cliente"    ,,{ || manlcr(3,3)}     ,,,,,273)
  AddDownItem( mFinReceberIns, "&Consulta"        ,,mFinReceberInsCon     ,,,,,274)

  AddDownItem( mFinReceberIns, "&ExclusÆo"        ,,{ || manlcr(4)}       ,,,,,275)

    mFinReceberInsLis := NewDownMenu()
    AddDownItem( mFinReceberInsLis, "&Instru‡Æo"  ,,{ || manlcr(5,1)}     ,,,,,276)
    AddDownItem( mFinReceberInsLis, "&Diario"     ,,{ || manlcr(5,2)}     ,,,,,277)
    AddDownItem( mFinReceberInsLis, "&RazÆo"      ,,{ || manlcr(5,3)}     ,,,,,278)
  AddDownItem( mFinReceberIns, "&Listagem"        ,,mFinReceberInsLis     ,,,,,279)
  AddDownItem( mFinReceberIns, "&Fechamento"      ,,{ || manlcr(6)}       ,,,,,280)

  AddDownItem( mRec, "&Instru‡Æo"          ,,mFinReceberIns        ,,,,,281)



  mFinBaixa := NewDownMenu()
  AddDownItem( mFinBaixa, "&Documento"     ,,{ || manbcr(1)}        ,,,,,282)
  AddDownItem( mFinBaixa, "&Clientes"      ,,{ || manbcr(2)}        ,,,,,283)
  AddDownItem( mFinBaixa, "&RecepcÆo"      ,,{ || manbcr(3)}        ,,,,,284)
  AddDownItem( mFinBaixa, "&Consiste"      ,,{ || manbcr(4)}        ,,,,,285)
  AddDownItem( mFinBaixa, "&Listagem"      ,,{ || manbcr(5)}        ,,,,,286)
  AddDownItem( mRec, "&Baixas"          ,,mFinBaixa        ,,,,,287)


  mFinOpera := NewDownMenu()
  AddDownItem( mFinOpera, "&Inclusao"      ,,{ || manmcr(1)}        ,,,,,288)
  AddDownItem( mFinOpera, "&Alteracao"     ,,{ || manmcr(2)}        ,,,,,289)
  AddDownItem( mFinOpera, "&Consulta"      ,,{ || manmcr(3)}        ,,,,,290)
  AddDownItem( mFinOpera, "&Exclusao"      ,,{ || manmcr(4)}        ,,,,,291)
  AddDownItem( mFinOpera, "&Listagem"      ,,{ || manmcr(5)}        ,,,,,292)
  AddDownItem( mRec, "&Operacoes"       ,,mFinOpera        ,,,,,293)

  mFinBcoPor := NewDownMenu()
  AddDownItem( mFinBcoPor, "&InclusÆo"      ,,{ || manpor(1)},,,,,294)
  AddDownItem( mFinBcoPor, "&Altera‡Æo"     ,,{ || manpor(2)},,,,,295)
  AddDownItem( mFinBcoPor, "&Consulta"      ,,{ || manpor(3)},,,,,296)
  AddDownItem( mFinBcoPor, "&ExclusÆo"      ,,{ || manpor(4)},,,,,297)
  AddDownItem( mFinBcoPor, "&Listagem"      ,,{ || manpor(5)},,,,,298)
AddDownItem( mRec, "&Portadores",, mFinBcoPor ,,,,,299)

  mFinExport := NewDownMenu()
  AddDownItem( mFinExport, "&Remessa"       ,,{ || manexp(1)},,,,,300)
  AddDownItem( mFinExport, "&Lista Retorno" ,,{ || manexp(2)},,,,,301)
  AddDownItem( mFinExport, "&Baixa Retorno" ,,{ || manexp(3)},,,,,302)
AddDownItem( mRec, "&Exportar",, mFinExport ,,,,,303)


  mFinEtique := NewDownMenu()
  AddDownItem( mFinEtique, "&InclusÆo"      ,,{ || manetq(1)},,,,,304)
  AddDownItem( mFinEtique, "&Altera‡Æo"     ,,{ || manetq(2)},,,,,305)
  AddDownItem( mFinEtique, "&Consulta"      ,,{ || manetq(3)},,,,,306)
  AddDownItem( mFinEtique, "&ExclusÆo"      ,,{ || manetq(4)},,,,,307)
  AddDownItem( mFinEtique, "&Listagem"      ,,{ || manetq(5)},,,,,308)
  AddDownItem( mFinEtique, "&Parametro"     ,,{ || manetq(6)},,,,,309)
AddDownItem( mRec, "&Etiquetas",, mFinEtique ,,,,,310)


  mFinPagarDup := NewDownMenu()

  AddDownItem( mFinPagarDup, "&InclusÆo",,{ || mandcp(1)}  ,,,,,311  )

    mFinPagarDupAlt := NewDownMenu()
    AddDownItem( mFinPagarDupAlt, "&Titulo"   ,,{ || mandcp(2,1)} ,,,,,312)
    AddDownItem( mFinPagarDupAlt, "&Portador" ,,{ || mandcp(2,3)} ,,,,,313)
  AddDownItem( mFinPagarDup, "&Alteracao"      ,,mFinPagarDupAlt  ,,,,,314)

    mFinPagarDupCon := NewDownMenu()
    AddDownItem( mFinPagarDupCon, "&Sequencia",,{ || mandcp(3,1)} ,,,,,315)
    AddDownItem( mFinPagarDupCon, "&Vencidas" ,,{ || mandcp(3,2)} ,,,,,316)
    AddDownItem( mFinPagarDupCon, "&Emissao"  ,,{ || mandcp(3,3)} ,,,,,317)
    AddDownItem( mFinPagarDupCon, "&Codigos"  ,,{ || mandcp(3,4)} ,,,,,318)
    AddDownItem( mFinPagarDupCon, "&Portador" ,,{ || mandcp(3,5)} ,,,,,319)
    AddDownItem( mFinPagarDupCon, "&Pagamento",,{ || mandcp(3,6)} ,,,,,320)
  AddDownItem( mFinPagarDup, "&Consulta"      ,,mFinPagarDupCon   ,,,,,321)

  AddDownItem( mFinPagarDup, "&ExclusÆo",,{ || mandcp(4)}  ,,,,,322  )

    mFinPagarDupLis := NewDownMenu()
    AddDownItem( mFinPagarDupLis, "&Sequencia",,{ || mandcp(5,1)} ,,,,,323)
    AddDownItem( mFinPagarDupLis, "&Vencidas" ,,{ || mandcp(5,2)} ,,,,,324)
    AddDownItem( mFinPagarDupLis, "&Nome"     ,,{ || mandcp(5,3)} ,,,,,325)
    AddDownItem( mFinPagarDupLis, "&Codigo"   ,,{ || mandcp(5,4)} ,,,,,326)
    AddDownItem( mFinPagarDupLis, "&Portador" ,,{ || mandcp(5,5)} ,,,,,327)
    AddDownItem( mFinPagarDupLis, "&Pagamento",,{ || mandcp(5,6)} ,,,,,328)
  AddDownItem( mFinPagarDup, "&Listagem"      ,,mFinPagarDupLis   ,,,,,329)

  AddDownItem( mPag, "&Duplicata"          ,,mFinPagarDup         ,,,,,330)


  mFinPagarIns := NewDownMenu()
  AddDownItem( mFinPagarIns, "&InclusÆo"        ,,{ || manlcp(1)}        ,,,,,331)
  AddDownItem( mFinPagarIns, "&Altera‡Æo"       ,,{ || manlcp(2)}        ,,,,,332)

    mFinPagarInsCon := NewDownMenu()
    AddDownItem( mFinPagarInsCon, "&Instru‡Æo"  ,,{ || manlcp(3,1)}      ,,,,,333)
    AddDownItem( mFinPagarInsCon, "&Duplicata"  ,,{ || manlcp(3,2)}      ,,,,,334)
    AddDownItem( mFinPagarInsCon, "&Fornecedor" ,,{ || manlcp(3,3)}      ,,,,,335)
  AddDownItem( mFinPagarIns, "&Consulta"        ,,mFinPagarInsCon        ,,,,,336)

  AddDownItem( mFinPagarIns, "&ExclusÆo"        ,,{ || manlcp(4)}        ,,,,,337)

    mFinPagarInsLis := NewDownMenu()
    AddDownItem( mFinPagarInsLis, "&Instru‡Æo"  ,,{ || manlcp(5,1)}      ,,,,,338)
    AddDownItem( mFinPagarInsLis, "&Diario"     ,,{ || manlcp(5,2)}      ,,,,,339)
    AddDownItem( mFinPagarInsLis, "&RazÆo"      ,,{ || manlcp(5,3)}      ,,,,,340)
  AddDownItem( mFinPagarIns, "&Listagem"        ,,mFinPagarInsLis        ,,,,,341)
  AddDownItem( mFinPagarIns, "&Fechamento"      ,,{ || manlcp(6)}        ,,,,,342)

  AddDownItem( mPag, "&Instru‡Æo"          ,,mFinPagarIns        ,,,,,343)


  mFinBaixap := NewDownMenu()
  AddDownItem( mFinBaixap, "&Documento"     ,,{ || manbcp(1)}        ,,,,,344)
  AddDownItem( mFinBaixap, "&Fornecedor"    ,,{ || manbcp(2)}        ,,,,,345)
  AddDownItem( mFinBaixap, "&Listagem"      ,,{ || manbcp(3)}        ,,,,,346)
  AddDownItem( mPag, "&Baixas"          ,,mFinBaixap        ,,,,,347)


  mFinOperap := NewDownMenu()
  AddDownItem( mFinOperap, "&Inclusao"      ,,{ || manmcp(1)}        ,,,,,348)
  AddDownItem( mFinOperap, "&Alteracao"     ,,{ || manmcp(2)}        ,,,,,349)
  AddDownItem( mFinOperap, "&Consulta"      ,,{ || manmcp(3)}        ,,,,,350)
  AddDownItem( mFinOperap, "&Exclusao"      ,,{ || manmcp(4)}        ,,,,,351)
  AddDownItem( mFinOperap, "&Listagem"      ,,{ || manmcp(5)}        ,,,,,352)
  AddDownItem( mPag, "&Operacoes"       ,,mFinOperap        ,,,,,353)


  mFinBcoCta := NewDownMenu()
  AddDownItem( mFinBcoCta, "&InclusÆo"      ,,{ || manban(1)},,,,,354)
  AddDownItem( mFinBcoCta, "&Altera‡Æo"     ,,{ || manban(2)},,,,,355)
  AddDownItem( mFinBcoCta, "&Consulta"      ,,{ || manban(3)},,,,,356)
  AddDownItem( mFinBcoCta, "&ExclusÆo"      ,,{ || manban(4)},,,,,357)
  AddDownItem( mFinBcoCta, "&Listagem"      ,,{ || manban(5)},,,,,358)
  AddDownItem( mFinBcoCta, "&Exercicio"     ,,{ || manban(6)},,,,,359)
  AddDownItem( mBan, "&Conta",,mFinBcoCta    ,,,,,360)

     mFinFluxoHis := NewDownMenu()
     AddDownItem( mFinFluxoHis, "&InclusÆo"       ,,{ || manhib(1)},,,,,361)
     AddDownItem( mFinFluxoHis, "&Altera‡Æo"      ,,{ || manhib(2)},,,,,362)
     AddDownItem( mFinFluxoHis, "&Consulta"       ,,{ || manhib(3)},,,,,363)
     AddDownItem( mFinFluxoHis, "&ExclusÆo"       ,,{ || manhib(4)},,,,,364)
     AddDownItem( mFinFluxoHis, "&Listagem"       ,,{ || manhib(5)},,,,,365)
  AddDownItem( mBan, "&Historico",,mFinFluxoHis,,,,,366)

    mFinBcoMov := NewDownMenu()
    AddDownItem( mFinBcoMov, "&InclusÆo"      ,,{ || manlab(1)},,,,,367)
    AddDownItem( mFinBcoMov, "&Altera‡Æo"     ,,{ || manlab(2)},,,,,368)
    AddDownItem( mFinBcoMov, "&Consulta"      ,,{ || manlab(3)},,,,,369)
    AddDownItem( mFinBcoMov, "&ExclusÆo"      ,,{ || manlab(4)},,,,,370)

    mFinBanMovLis := NewDownMenu()
    AddDownItem( mFinBanMovLis, "&Analitico"  ,,{ || manlab(5,1)}      ,,,,,371)
    AddDownItem( mFinBanMovLis, "&Sintetico"  ,,{ || manlab(5,2)}      ,,,,,372)
    AddDownItem( mFinBanMovLis, "&Conciliar"  ,,{ || manlab(5,3)}      ,,,,,373)
    AddDownItem( mFinBanMovLis, "&Extrato"    ,,{ || manlab(5,4)}      ,,,,,374)
  AddDownItem( mFinBcoMov, "&Listagem"        ,,mFinPagarInsLis     ,,,,,375)
    AddDownItem( mFinBcoMov, "&Conciliar"     ,,{ || manlab(6)},,,,,376)

  AddDownItem( mBan, "&Movimento",,mFinBcoMov,,,,,377)


  mFinBcoCheDup := NewDownMenu()
  AddDownItem( mFinBcoCheDup, "&InclusÆo"   ,,{ || manche(1)},,,,,378)
  AddDownItem( mFinBcoCheDup, "&Alteracao"  ,,{ || manche(2)},,,,,379)

    mFinBcoCheCon := NewDownMenu()
    AddDownItem( mFinBcoCheCon, "&Cheque"     ,,{ || manche(3,1)}    ,,,,,380)
    AddDownItem( mFinBcoCheCon, "&Fornecedor" ,,{ || manche(3,2)}    ,,,,,381)
  AddDownItem( mFinBcoCheDup, "&Consulta"        ,,mFinBcoCheCon     ,,,,,382)
  AddDownItem( mFinBcoCheDup, "&Exclusao"   ,,{ || manche(4)},,,,,383)
  AddDownItem( mFinBcoCheDup, "&Listagem"   ,,{ || manche(5)},,,,,384)

    mFinBcoCheOut := NewDownMenu()
    AddDownItem( mFinBcoCheOut, "&Emissao",,{ || manche(6,1)}      ,,,,,385)
    AddDownItem( mFinBcoCheOut, "&Copia"  ,,{ || manche(6,2)}      ,,,,,386)
    AddDownItem( mFinBcoCheOut, "&Elimina",,{ || manche(6,3)}      ,,,,,387)
  AddDownItem( mFinBcoCheDup, "&Outros"        ,,mFinBcoCheOut     ,,,,,388)

  AddDownItem( mFinBcoCheDup, "&Liberacao",,{ || manche(7)},,,,,389)
AddDownItem( mBan, "&Cheque",,mFinBcoCheDup,,,,,390)


  mFinBcoChePre := NewDownMenu()
  AddDownItem( mFinBcoChePre, "&InclusÆo"   ,,{ || manprd(1)},,,,,391)
  AddDownItem( mFinBcoChePre, "&Alteracao"  ,,{ || manprd(2)},,,,,392)

    mFinBcoChePreCon := NewDownMenu()
    AddDownItem( mFinBcoChePreCon, "&Cheque"     ,,{ || manprd(3,1)}      ,,,,,393)
    AddDownItem( mFinBcoChePreCon, "&Banco"      ,,{ || manprd(3,2)}      ,,,,,394)
    AddDownItem( mFinBcoChePreCon, "&Emissao"    ,,{ || manprd(3,3)}      ,,,,,395)
    AddDownItem( mFinBcoChePreCon, "&Vencimento" ,,{ || manprd(3,4)}      ,,,,,396)
    AddDownItem( mFinBcoChePreCon, "&Cliente"    ,,{ || manprd(3,5)}      ,,,,,397)
    AddDownItem( mFinBcoChePreCon, "&Valor"      ,,{ || manprd(3,6)}      ,,,,,398)
    AddDownItem( mFinBcoChePreCon, "&Entrada"    ,,{ || manprd(3,7)}      ,,,,,399)
  AddDownItem( mFinBcoChePre, "&Consulta"        ,,mFinBcoChePreCon     ,,,,,400)

  AddDownItem( mFinBcoChePre, "&Exclusao"   ,,{ || manprd(4)},,,,,401)

    mFinBcoCheLis := NewDownMenu()
    AddDownItem( mFinBcoCheLis, "&Cheque"     ,,{ || manprd(5,1)}      ,,,,,402)
    AddDownItem( mFinBcoCheLis, "&Banco"      ,,{ || manprd(5,2)}      ,,,,,403)
    AddDownItem( mFinBcoCheLis, "&Emissao"    ,,{ || manprd(5,3)}      ,,,,,404)
    AddDownItem( mFinBcoCheLis, "&Vencimento" ,,{ || manprd(5,4)}      ,,,,,405)
    AddDownItem( mFinBcoCheLis, "&Cliente"    ,,{ || manprd(5,5)}      ,,,,,406)
    AddDownItem( mFinBcoCheLis, "&Entrada"    ,,{ || manprd(5,6)}      ,,,,,407)
  AddDownItem( mFinBcoChePre, "&Listagem"        ,,mFinBcoCheLis     ,,,,,408)
  AddDownItem( mFinBcoChePre, "&Baixa",,{ || manprd(6)},,,,,409)
AddDownItem( mBan, "&Cheque Pre",,mFinBcoChePre,,,,,410)

*    mFinBcoPar := NewDownMenu()
*    AddDownItem( mFinBcoPar, "&InclusÆo"      ,,{ || manpch(1)},,,,,411)
*    AddDownItem( mFinBcoPar, "&Altera‡Æo"     ,,{ || manpch(2)},,,,,412)
*    AddDownItem( mFinBcoPar, "&Consulta"      ,,{ || manpch(3)},,,,,413)
*    AddDownItem( mFinBcoPar, "&ExclusÆo"      ,,{ || manpch(4)},,,,,414)
*    AddDownItem( mFinBcoPar, "&Listagem"      ,,{ || manpch(5)},,,,,415)
*    AddDownItem( mFinBcoPar, "&Lay-Out"       ,,{ || manpch(6)},,,,,416)
*  AddDownItem( mBan, "&Parametro"        ,,mFinBcoPar,,,,,417)

    mFinFluxoApl := NewDownMenu()
     AddDownItem( mFinFluxoApl, "&InclusÆo"       ,,{ || manplx(1)},,,,,418)
     AddDownItem( mFinFluxoApl, "&Altera‡Æo"      ,,{ || manplx(2)},,,,,419)
     AddDownItem( mFinFluxoApl, "&Consulta"       ,,{ || manplx(3)},,,,,420)
     AddDownItem( mFinFluxoApl, "&ExclusÆo"       ,,{ || manplx(4)},,,,,421)
     AddDownItem( mFinFluxoApl, "&Listagem"       ,,{ || manplx(5)},,,,,422)
    AddDownItem( mCai, "&Aplica‡Æo",,mFinFluxoApl,,,,,423)

    mFinBcoHis := NewDownMenu()
    AddDownItem( mFinBcoHis, "&InclusÆo"      ,,{ || manhix(1)},,,,,424)
    AddDownItem( mFinBcoHis, "&Altera‡Æo"     ,,{ || manhix(2)},,,,,425)
    AddDownItem( mFinBcoHis, "&Consulta"      ,,{ || manhix(3)},,,,,426)
    AddDownItem( mFinBcoHis, "&ExclusÆo"      ,,{ || manhix(4)},,,,,427)
    AddDownItem( mFinBcoHis, "&Listagem"      ,,{ || manhix(5)},,,,,428)
  AddDownItem( mCai, "&Historico",,mFinBcoHis,,,,,429)


     mFinFluxoMov := NewDownMenu()
     AddDownItem( mFinFluxoMov, "&InclusÆo"       ,,{ || manlax(1)},,,,,430)
     AddDownItem( mFinFluxoMov, "&Altera‡Æo"      ,,{ || manlax(2)},,,,,431)
     AddDownItem( mFinFluxoMov, "&Consulta"       ,,{ || manlax(3)},,,,,432)
     AddDownItem( mFinFluxoMov, "&ExclusÆo"       ,,{ || manlax(4)},,,,,433)

     mFinFluxoLis := NewDownMenu()
     AddDownItem( mFinFluxoLis, "&Periodo"  ,,{ || manlax(5,1)},,,,,434)
     AddDownItem( mFinFluxoLis, "&Contas"   ,,{ || manlax(5,2)},,,,,435)
     AddDownItem( mFinFluxoMov, "&Listagem" ,,mFinFluxoLis,,,,,436)
  AddDownItem( mCai, "&Fluxo de Caixa",,mFinFluxoMov   ,,,,,437)


     mCaiAnalitic := NewDownMenu()
     AddDownItem( mCaiAnalitic, "&Titulos"  ,,{ || mananx(1)},,,,,438)
     AddDownItem( mCaiAnalitic, "&Aplicacao",,{ || mananx(2)},,,,,439)
     AddDownItem( mCaiAnalitic, "&Caixa"    ,,{ || mananx(3)},,,,,440)
  AddDownItem( mCai, "&Analitico",,mCaiAnalitic   ,,,,,441)

     mCaiSintetic := NewDownMenu()
     AddDownItem( mCaiSintetic, "&Titulos"  ,,{ || mansix(1)},,,,,442)
     AddDownItem( mCaiSintetic, "&Aplicacao",,{ || mansix(2)},,,,,443)
  AddDownItem( mCai, "&Sintetico",,mCaiSintetic   ,,,,,444)

  AddDownItem( mCai, "&Resultado",,{ || demonx()},,,,,445)

   mFatCve := NewDownMenu()
   AddDownItem( mFatCve, "&InclusÆo"      ,,{ || mancve(1)},,,,,446)
   AddDownItem( mFatCve, "&Altera‡Æo"     ,,{ || mancve(2)},,,,,447)
   AddDownItem( mFatCve, "&Consulta"      ,,{ || mancve(3)},,,,,448)
   AddDownItem( mFatCve, "&ExclusÆo"      ,,{ || mancve(4)},,,,,449)
   AddDownItem( mFatCve, "&Listagem"      ,,{ || mancve(5)},,,,,450)
AddDownItem( mOut, "&Convenios",, mFatCve   ,,,,,451)

  mFisCfop := NewDownMenu()
  AddDownItem( mFisCfop, "&InclusÆo"      ,,{ || manfis(1)},,,,,452)
  AddDownItem( mFisCfop, "&Altera‡Æo"     ,,{ || manfis(2)},,,,,453)
  AddDownItem( mFisCfop, "&Consulta"      ,,{ || manfis(3)},,,,,454)
  AddDownItem( mFisCfop, "&ExclusÆo"      ,,{ || manfis(4)},,,,,455)
  AddDownItem( mFisCfop, "&Listagem"      ,,{ || manfis(5)},,,,,456)
AddDownItem( mOut, "&CFOP Fiscal",,mFisCfop ,,,,,457)


  mFisCfop := NewDownMenu()
  AddDownItem( mFisCfop, "&Resumo ICMS"     ,,{ || manapu(1)},,,,,458)
  AddDownItem( mFisCfop, "&Livro ICMS"      ,,{ || manapu(2)},,,,,459)
  AddDownItem( mFisCfop, "&Apuracao ICMS"   ,,{ || manapu(3)},,,,,460)
  AddDownItem( mFisCfop, "&Pis/Cofins"      ,,{ || manapu(4)},,,,,461)
  AddDownItem( mFisCfop, "&Sped ICMS"       ,,{ || manapu(5)},,,,,462)
AddDownItem( mOut, "&Fiscal",,mFisCfop ,,,,,463)

  mOutUsu  := NewDownMenu()
  AddDownItem( mOutUsu, "&InclusÆo"   ,,{ || manlog(1)},,,,,464)
  AddDownItem( mOutUsu, "&Altera‡Æo"  ,,{ || manlog(2)},,,,,465)
  AddDownItem( mOutUsu, "&Consulta"   ,,{ || manlog(3)},,,,,466)
  AddDownItem( mOutUsu, "&ExclusÆo"   ,,{ || manlog(4)},,,,,467)
  AddDownItem( mOutUsu, "&Restricoes" ,,{ || manlog(5)},,,,,468)

*AddDownItem( mOutUsu, "LinButton&1()", , { || LinButton1( ,,,,), Clrted( 20 ) } )
*AddDownItem( mOutUsu, "LinButton&2()", , { || LinButton2( ,,,,,,,,), Clrted( 20 ) } )
*AddDownItem( mOutUsu, "LinButton&3()", , { || LinButton3( ,,,,,,,,,,), Clrted( 20 ) } )
*AddDownItem( mOutUsu, "LinButton&4()", , { || LinButton4( ,,,,,,,,,,,,), Clrted( 20 ) } )
*AddDownItem( mOutUsu, "Check &1", "Marca/Desmarca Check 1", { || ChkDownItem( mOutUsu, 3, !ChkDownItem( mOutUsu, 3 ) ) } )
*AddDownItem( mOutUsu, "&TBrowse"   , "TBrowse com uso de Mouse na Visual Lib", { || VLTBrow() } )

*AddDownItem( mOutUsu, "Estilo &1", "T¡tulo … esquerda / Baixo relevo" , { || aEnv := SavEnv( 02, 00, 23, 79 ), Clrted(), Frame( 05, 05, 16, 74, "T¡tulo" ), WaitState(), RstEnv( aEnv ) } )
*AddDownItem( mOutUsu, "Estilo &2", "T¡tulo centralizado / Alto relevo", { || aEnv := SavEnv( 02, 00, 23, 79 ), Clrted(), Frame( 05, 05, 16, 74, "T¡tulo", 2, 2 ), WaitState(), RstEnv( aEnv ) } )
*AddDownItem( mOutUsu, "Estilo &3", "T¡tulo … direita / Normal"        , { || aEnv := SavEnv( 02, 00, 23, 79 ), Clrted(), Frame( 05, 05, 16, 74, "T¡tulo", 3, 3 ), WaitState(), RstEnv( aEnv ) } )
*AddDownItem( mOutUsu, "Estilo &1", "DeskBox() em baixo relevo" , { || aEnv := SavEnv( 02, 00, 23, 79 ), Clrted(), DeskBox( 05, 05, 16, 74, 1 ), WaitState(), RstEnv( aEnv ) } )
*AddDownItem( mOutUsu, "Estilo &2", "DeskBox() em alto relevo"  , { || aEnv := SavEnv( 02, 00, 23, 79 ), Clrted(), DeskBox( 05, 05, 16, 74, 2 ), WaitState(), RstEnv( aEnv ) } )

*AddDownItem( mOutUsu, "Estilo &1", "T¡tulo … esquerda / Baixo relevo" , { || aEnv := SavEnv( 02, 00, 23, 79 ), Clrted(), win( 05, 05, 16, 74, "T¡tulo" ), WaitState(), RstEnv( aEnv ) } )
*AddDownItem( mOutUsu, "Estilo &2", "T¡tulo centralizado / Alto relevo", { || aEnv := SavEnv( 02, 00, 23, 79 ), Clrted(), win( 05, 05, 16, 74, "T¡tulo", 2, 2 ), WaitState(), RstEnv( aEnv ) } )
*AddDownItem( mOutUsu, "Estilo &3", "T¡tulo … direita / Normal"        , { || aEnv := SavEnv( 02, 00, 23, 79 ), Clrted(), win( 05, 05, 16, 74, "T¡tulo", 3, 3 ), WaitState(), RstEnv( aEnv ) } )

AddDownItem( mOut, "&Usuarios",,mOutUsu,,,,,469)
AddDownItem( mOut, "&Salva Configura‡Æo",, { || salvaconf() },,,,,469)
/*


*PROXIMA SENHA 556

*AddDownItem( mPdn, "Sai&r", "Encerra o programa", { || Saida() } )

*AddDownItem( mPdnChk, "Check &1", "Marca/Desmarca Check 1", { || ChkDownItem( mPdnChk, 1, !ChkDownItem( mPdnChk, 1 ) ) } )
*AddDownItem( mPdnChk, "Check &2", "Marca/Desmarca Check 2", { || ChkDownItem( mPdnChk, 2, !ChkDownItem( mPdnChk, 2 ) ) } )
*AddDownItem( mPdnChk, "Check &3", "Marca/Desmarca Check 3", { || ChkDownItem( mPdnChk, 3, !ChkDownItem( mPdnChk, 3 ) ) } )
*AddDownItem( mPdnChk, "Check &4", "Marca/Desmarca Check 4", { || ChkDownItem( mPdnChk, 4, !ChkDownItem( mPdnChk, 4 ) ) } )
*AddDownItem( mPdnChk, "Check &5", "Marca/Desmarca Check 5", { || ChkDownItem( mPdnChk, 5, !ChkDownItem( mPdnChk, 5 ) ) } )

*AddDownItem( mPdnSet, "Set &1", "Habilita/Desabilita Set 1", { || SetDownItem( mPdnSet, 1, !SetDownItem( mPdnSet, 1 ) ) } )
*AddDownItem( mPdnSet, "Set &2", "Habilita/Desabilita Set 2", { || SetDownItem( mPdnSet, 2, !SetDownItem( mPdnSet, 2 ) ) } )
*AddDownItem( mPdnSet, "Set &3", "Habilita/Desabilita Set 3", { || SetDownItem( mPdnSet, 3, !SetDownItem( mPdnSet, 3 ) ) } )
*AddDownItem( mPdnSet, "Set &4", "Habilita/Desabilita Set 4", { || SetDownItem( mPdnSet, 4, !SetDownItem( mPdnSet, 4 ) ) } )
*AddDownItem( mPdnSet, "Set &5", "Habilita/Desabilita Set 5", { || SetDownItem( mPdnSet, 5, !SetDownItem( mPdnSet, 5 ) ) } )




*AddDownItem( mDiv, "&Mouse/GET" , "Mouse no sistema GET padrÆo do Clipper", { || MouseGet() } )
*AddDownItem( mDiv, "&TBrowse"   , "TBrowse com uso de Mouse na Visual Lib", { || VLTBrow() } )
*AddDownItem( mDiv, "&Sombra..." , "Efeito de sombra da Visual Lib"       , { || TesteSombra() } )

*/




// terceiro parametro CHAMA LOGO NOVAMENTE OU NAO

Desktop(alltrim(AEMP00->EMPNOM),,.f.) //Fun‡Æo que inicializa a Visual Lib - Sempre deve ser chamada no inicio

set key 288 to NULO()

lPri = .t.

while .t.           // Loop principal

  BarMenu( mBar )  //VL-Ap¢s a definicao dos menus, BarMenu( mBar ) controla tudo

  set key K_F10 to // Desligamos set key
  SetKeyMouse( K_F10, {} ) //VL-Desativamos o Mouse para F10


  VLExit()         //VL-Pede confirmacao para sair

  set key K_F10 to VLMARQUEE() // Se chegou aqui, significa que nao saiu...
  SetKeyMouse( K_F10, { 24, 24, 72, 79 } ) //VL-Define novamente F10 p/ mouse

end

return nil


function SALVACONF

  fnt_:= WvW_GetFontInfo()
 _FONTET_   = fnt_[ 2 ]
 _FONTEL_   = fnt_[ 3 ]

 sqlORDEM = {}
 sqlCAMPO = {}
 sqlCHAVE =  {}
 sqlARQUI = {"CONFIGURAR","UPDATE OR INSERT"}
 aadd(sqlCHAVE,{"MAQUINA"})
 aadd(sqlCAMPO,{"MAQUINA",netname(),.t.})
 aadd(sqlCAMPO,{"FONTET",str(_FONTET_,3),.f.})
 aadd(sqlCAMPO,{"FONTEL",str(_FONTEL_,3),.f.})
 executasql()

 msgbox1("Configuracao de tela salva")
 return ""
 

//**************
function RODAPE
   //**************

   parameters F_ATV,F_MOD,F_NADA,F_PRG

   if !isnil(F_ATV)
      cF_ATV = F_ATV
   endif
   if !isnil(F_MOD)
      cF_MOD = F_MOD
   endif
   if !isnil(F_PRG)
      cF_PRG = F_PRG
   endif

   wvw_sbSetText( ,0, padc(alltrim(cF_ATV),14))
   wvw_sbSetText( ,1,padc(alltrim(cF_MOD),13))
   wvw_sbSetText( ,2,M_LOGNOM)
   wvw_sbSetText( ,3,cF_PRG)
   wvw_sbSetText( ,4,"EMPRESA: " + STR(ME_EMP,2))

return .T.

******************
function SE_EMITINDO(fTIPO,fOQUE)
******************

if fTIPO
  do case
    case fOQUE == "APED00"
      if file("&_PATH_\ABERTOP.TXT")
        handleAberto=fopen("&_PATH_\ABERTOP.TXT",16)
      else
        handleAberto=fcreate("&_PATH_\ABERTOP.TXT")
        fclose(handleAberto)
        handleAberto=fopen("&_PATH_\ABERTOP.TXT",16)
      endif
    case fOQUE == "ANFS00"
      if file("&_PATH_\ABERTON.TXT")
        handleAberto=fopen("&_PATH_\ABERTON.TXT",16)
      else
        handleAberto=fcreate("&_PATH_\ABERTON.TXT")
        fclose(handleAberto)
        handleAberto=fopen("&_PATH_\ABERTON.TXT",16)
      endif
  endcase
  if handleAberto < 0
    return .t.
  else
    return .f.
  endif
else
  fclose(handleAberto)
  return .t.
endif



*****************
function SEEXISTESQL
*****************

local A
parame F_ABREARQUIVO

if select(F_ABREARQUIVO) > 0
  select &F_ABREARQUIVO
  use
  return .F.
endif

return .T.



*****************
function CRIADBFTOclasse(fARQUIVO,fCRIAR)
*****************

select &farquivo

aFields := &fARQUIVO -> (dbStruct ())
nMax := len (aFields)

M_ARQ = fARQUIVO + ".pas"

set print on
set printer to &M_ARQ
set console off

? "unit classe_" + fARQUIVO + ";"
?
? "{$mode ObjFPC}{$H+}"
?
? "interface"
?
? "uses"
? "  Classes, SysUtils, Controls, ExtCtrls, Dialogs,utabela, ZDataset;"
? "  type"
?
? "    { T" + fARQUIVO  + " }"
?
? "    TAEMP00 = class"
? "      private"

FOR i := 1 TO nMax
   ? "        T" + aFields [i][1]
   ?? ":"
   DO CASE
*     CASE (aFields [i][2] == "L")
*       ?? "CHAR(1) DEFAULT ''"
   CASE (aFields [i][2] == "C")
     ?? "string;"
   CASE (aFields [i][2] == "D")
     ?? "tDATE;"
   CASE (aFields [i][2] == "N")
     if aFields [i][4] = 0 // TEM DECIMAL
       ?? "Integer;"
     else
       ?? "Double;"
     endif
   ENDCASE
next

? "        function retornaAI:Integer;"
? "      public"
? "        function incluir:Boolean;"
? "        function localiza(CODIGO:Integer):Boolean;"
? "        function altera(CODIGO:Integer):Boolean;"
? "        function excluir(CODIGO:Integer):Boolean;"
? "      published"
FOR i := 1 TO nMax
   ? "        property " + aFields [i][1]
   ?? ":"
   DO CASE
*     CASE (aFields [i][2] == "L")
*       ?? "CHAR(1) DEFAULT ''"
   CASE (aFields [i][2] == "C")
     ??   "string  read " + "T" + aFields [i][1] + " write T" + aFields [i][1] + ";"
   CASE (aFields [i][2] == "D")
     ??   "tDATE   read " + "T" + aFields [i][1] + " write T" + aFields [i][1] + ";"
   CASE (aFields [i][2] == "N")
     if aFields [i][4] = 0 // TEM DECIMAL
       ?? "Integer read " + "T" + aFields [i][1] + " write T" + aFields [i][1] + ";"
     else
       ?? "Double  read " + "T" + aFields [i][1] + " write T" + aFields [i][1] + ";"
     endif
   ENDCASE
next

? "    end;"
?
? "implementation"
?
? "{ T" + fARQUIVO + " }"
?
? "function T" + fARQUIVO + ".retornaAI: Integer;"
? "  var"
? "    qrAI : TZQuery;"
? "begin"
? "  qrAI := TZQuery.Create(Nil);"
? "  qrAI.Connection := TabGlobal.conexao;"
? "  qrAI.SQL.Add('select coalesce(max( IDARQUIVO_TROCAR ),0) + 1 as CODIGO from " + fARQUIVO + "');"
? "  qrAI.Open;"
? "  Result := qrAI.FieldByName('CODIGO').Value;"
? "  if Assigned(qrAI) then"
? "      FreeAndNil(qrAI);"
? "end;"
?
? "function T" + fARQUIVO + ".incluir: Boolean;"
? "var"
? "  qrInc : TZQuery;"
? "  cSQL : String;"
? "begin"
?
? "  cSQL:= 'INSERT INTO " + fARQUIVO + "'+"
? "  ' ('+"
FOR i := 1 TO nMax
  ? "   ' " + aFields [i][1]
  if i = nMax
   ?? ") VALUES (' +"
  else
   ?? ",'+"
  endif
next

FOR i := 1 TO nMax
  ? "   ' :" + aFields [i][1]
  if i = nMax
    ?? ")';"
  else
    ?? ",'+"
  endif
next

?
? "  qrInc := TZQuery.Create(Nil);"
? "  qrInc.Connection := TabGlobal.conexao;"
? "  qrInc.SQL.Text:= cSQL;"
?
? "  qrInc.ParamByName('CAMPOID_TROCAR').AsInteger:=retornaAI;"

FOR i := 1 TO nMax
  ? "  qrInc.ParamByName('" + aFields [i][1] + "').As"
  DO CASE
   CASE (aFields [i][2] == "C")
     ??   "string:=T" + aFields [i][1] + ";"
   CASE (aFields [i][2] == "D")
     ??   "DATE:=T" + aFields [i][1] + ";"
   CASE (aFields [i][2] == "N")
     if aFields [i][4] = 0 // TEM DECIMAL
       ?? "Integer:=T" + aFields [i][1] + ";"
     else
       ?? "Currency:=T" + aFields [i][1] + ";"
     endif
   ENDCASE
next

?
? "  TRY"
? "     qrInc.ExecSQL;"
? "     Result := True;"
? "  Except"
? "    On e: Exception do"
? "       Begin"
? "         Result := False;"
? "         ShowMessage('Erro ao incluir a Empresa' + sLineBreak + e.ClassName"
? "         +sLineBreak+e.Message);"
? "       end;"
? "  end;"
? "  if Assigned(qrInc) then"
? "    FreeAndNil(qrInc);"
? "end;"
?
? "function T" + fARQUIVO + ".localiza(CODIGO: Integer): Boolean;"
? "var"
? "  QrPesquisa : TZQuery;"
? "begin"
? "QrPesquisa := TZQuery.Create(Nil);"
? "QrPesquisa.Connection := TabGlobal.conexao;"
? "QrPesquisa.SQL.Text:= 'select * from " + fARQUIVO + " where IDCODIGO_TROCAR = :nCODIGO';"
? "QrPesquisa.ParamByName('nCODIGO').AsInteger:=CODIGO;"
? "QrPesquisa.Open;"
?
? "IF QrPesquisa.RecordCount >= 1 then"
? "  BEGIN"

FOR i := 1 TO nMax
  ? "    Self.T" + aFields [i][1] + ":= QrPesquisa.FieldByName('" + aFields [i][1] + "').As"
  DO CASE
  CASE (aFields [i][2] == "C")
    ?? "string;"
  CASE (aFields [i][2] == "D")
    ?? "DateTime;"
  CASE (aFields [i][2] == "N")
    if aFields [i][4] = 0 // TEM DECIMAL
      ?? "Integer;"
    else
      ?? "Currency;"
    endif
  ENDCASE
NEXT

? "    Result := True"
? "  end"
? "ELSE"
? "  Result := False;"
?
? "if Assigned(QrPesquisa) then"
? "    FreeAndNil(QrPesquisa);"
? "end;"
?
? "function T" + fARQUIVO + ".altera(CODIGO: Integer): Boolean;"
? "var"
? "  qrALT : TZQuery;"
? "  cSQL : String;"
? "begin"
?
? "  cSQL:= ' UPDATE " + fARQUIVO + " SET'+"
FOR i := 1 TO nMax
  ? "    ' " + aFields [i][1] + " = :" + aFields [i][1]
  if i < nMax
    ?? ",'+"
  endif
NEXT
??"         WHERE '+"
?"         ' " + fARQUIVO + ".IDCHAVE = :OLD_IDCHAVE';"
?
? "  qrALT := TZQuery.Create(Nil);"
? "  qrALT.Connection := TabGlobal.conexao;"
? "  qrALT.SQL.Text:= cSQL;"
? "  qrALT.ParamByName('OLD_IDCHAVE').AsInteger:=CODIGO;"

FOR i := 1 TO nMax
  ?"  qrALT.ParamByName('" + aFields [i][1] + "').As"
  DO CASE
  CASE (aFields [i][2] == "C")
    ?? "string:=T"
  CASE (aFields [i][2] == "D")
    ?? "DATE:=T"
  CASE (aFields [i][2] == "N")
    if aFields [i][4] = 0 // TEM DECIMAL
      ?? "Integer:=T"
    else
      ?? "Currency:=T"
    endif
  ENDCASE
  ?? aFields [i][1] + ";"
NEXT
?
? "  TRY"
? "     qrALT.ExecSQL;"
? "     Result := True;"
? "  Except"
? "    On e: Exception do"
? "       Begin"
? "         Result := False;"
? "         ShowMessage('Erro ao alterar Empresa' + sLineBreak + e.ClassName"
? "         +sLineBreak+e.Message);"
? "       end;"
? "  end;"
? "  if Assigned(qrALT) then"
? "    FreeAndNil(qrALT);"
? "end;"
?
? "function T" + fARQUIVO + ".excluir(CODIGO: Integer): Boolean;"
? "var"
? "  qrEXC : TZQuery;"
? "  cSQL : String;"
? "begin"
?
?"  cSQL:= 'DELETE FROM " + fARQUIVO + "'+"
?"         ' WHERE '+"
?"         ' " + fARQUIVO + ".IDCHAVE_ALTERAR = :OLD_IDCHAVE';"
?
? "  qrEXC := TZQuery.Create(Nil);"
? "  qrEXC.Connection := TabGlobal.conexao;"
? "  qrEXC.SQL.Text:= cSQL;"
? "  qrEXC.ParamByName('OLD_IDCHAVE').AsInteger:=CODIGO;"
?
? "  TRY"
? "     qrEXC.ExecSQL;"
? "     Result := True;"
? "  Except"
? "    On e: Exception do"
? "       Begin"
? "         Result := False;"
? "         ShowMessage('Erro ao excluir Empresa' + sLineBreak + e.ClassName"
? "         +sLineBreak+e.Message);"
? "       end;"
? "  end;"
? "  if Assigned(qrEXC) then"
? "    FreeAndNil(qrEXC);"
?
? "end;"
?
? "end."

set printer to
set print off


return ""


*****************
function CRIADBFTOSQL(fARQUIVO,fCRIAR,fCONDICAO)
*****************

select &farquivo

if fCRIAR
  aFields := &fARQUIVO -> (dbStruct ())
  nMax := len (aFields)

  M_ARQ = "C:\CIRURSQL\DADOS\" + fARQUIVO + ".SQL"

  set print on
  set printer to &M_ARQ
  set console off

  ? "CREATE TABLE " + fARQUIVO + " ("

  FOR i := 1 TO nMax
     ? aFields [i][1]
     ?? " "
     DO CASE
     CASE (aFields [i][2] == "L")
       ?? "CHAR(1) DEFAULT ''"
     CASE (aFields [i][2] == "C")
       ?? "CHAR(" + str(aFields [i][3],3) + ")  DEFAULT ''"
     CASE (aFields [i][2] == "D")
       ?? "DATE"
     CASE (aFields [i][2] == "N")
       if aFields [i][4] = 0 // TEM DECIMAL
         ?? 'NUMERIC(' + str(aFields[i][3],3) + ',0) DEFAULT 0'
       else
         ?? 'NUMERIC(' + str(aFields[i][3],3) + ',' + str(aFields[i][4],3) + ') DEFAULT 0'
       endif
     ENDCASE

     if i < nMax
       ?? ","
     endif

  next

  ?? ")"


  set printer to
  set print off
endif

M_ARQ = "C:\CIRURSQL\DADOS\" + fARQUIVO + "dados.SQL"

set print on
set printer to &M_ARQ
set console off

aFields := &fARQUIVO -> (dbStruct ())
nMax := len (aFields)

go top

do while !eof()

  if !fCONDICAO = NIL
  if &fCONDICAO
    skip
    loop
  endif
  endif

msw(str(recno()))

  ? "INSERT INTO " + fARQUIVO + " ("

  FOR i := 1 TO nMax
    ?? aFields [i][1]
    if i < nMax
      ?? ","
    endif
  next
  ?? ")"
  ? "     VALUES ("

  FOR i := 1 TO nMax

     DO CASE
     CASE (aFields [i][2] == "L")
       ?? "'" + iif(fieldget(i),"S","N") + "'"
     CASE (aFields [i][2] == "C")
       ?? "'" + TIRA_ACENTUACAO(fieldget(i)) + "'"
     CASE (aFields [i][2] == "D")
       if HB_ISNIL(fieldget(i)) .or. empty(fieldget(i))
         ?? "NULL"
       else
         ?? "'" + formatdta(fieldget(i)) + "'"
       endif
     CASE (aFields [i][2] == "N")
       if aFields [i][4] = 0 // TEM DECIMAL
         ?? str(fieldget(i))
       else
         ?? str1(fieldget(i),aFields [i][4])
       endif
     ENDCASE

    if i < nMax
      ?? ","
    endif

  next
  ?? ");"

  skip

enddo
? "COMMIT WORK;"

set printer to
set print off

return ""


// PEGAR OS XML NA CONSULTA

/*
Dim oErro, oExceptionInterop
Dim oConfiguracao, oConsSitNfe, oProcEventoNFe, X, oConsultaProtocolo, xmlEvento, nHandle, nomeArqDistribEvento
Dim oConfig, oConsSitNfeChNfe

'Criar configuraçao básica para consumir o serviço
Set oConfig = CreateObject("Unimake.Business.DFe.Servicos.Configuracao")
oConfig.TipoDFe = 0 '// 0=nfe
oConfig.CertificadoSenha = "12345678"
oConfig.CertificadoArquivo = "D:\projetos\UnimakePV.pfx"

'Criar XML da consulta protocolo
Set oConsSitNfe = CreateObject("Unimake.Business.DFe.Xml.NFe.ConsSitNfe")
oConsSitNfe.Versao = "4.00"
oConsSitNfe.TpAmb = 2   'Homologação
oConsSitNfe.ChNfe = "31240402046163000130550010000570591001308457"  'Chave da NFE

'Enviar a consulta
Set oConsultaProtocolo = CreateObject("Unimake.Business.DFe.Servicos.NFe.ConsultaProtocolo")
oConsultaProtocolo.Executar (oConsSitNfe), (oConfig)

MsgBox (oConsultaProtocolo.RetornoWSString)

If oConsultaProtocolo.Result.GetProcEventoNFeCount > 0 Then
   For X = 1 To oConsultaProtocolo.Result.GetProcEventoNFeCount
       Set oProcEventoNFe = oConsultaProtocolo.Result.GetProcEventoNFe(X - 1)

       nomeArqDistribEvento = "d:\testenfe\" + oProcEventoNFe.NomeArquivoDistribuicao

       MsgBox (nomeArqDistribEvento)

       xmlEvento = oProcEventoNFe.GerarXMLString() 'String do xml do evento

       MsgBox (xmlEvento)


       'Se quiser pegar um evento específico, só comparar o tipo de evento, conforme segue
       If oProcEventoNFe.Evento.InfEvento.tpEvento = 110111 Then ' //Cancelamento
          'Aqui dentro do IF só fazer o que foi feito fora dele, nas linhas anteriores,
          'mas só vai fazer se for um cancelamento.
       End If
     Next
End If

*/


******************
function LE_CONFIG
******************

feof = .f.

handle=fopen("CONFIG.CFG")

do while .t.
  if feof
    exit
  endif

  M_FRAZE = alltrim(freadline(handle))

  do case
     case left(M_FRAZE,9)  == "_PATHSQL_"  ; _PATHSQL_ = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,(at("//",M_FRAZE)-1)-at("=",M_FRAZE)))
     case left(M_FRAZE,10) == "_PATHODBC_" ; _PATHODBC_ = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,(at("//",M_FRAZE)-1)-at("=",M_FRAZE)))
     case left(M_FRAZE,9)  == "_EMPRESA_"  ; _EMPRESA_ = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,(at("//",M_FRAZE)-1)-at("=",M_FRAZE)))
     case left(M_FRAZE,7)  == "_FUNDO_"    ; _FUNDO_ = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,(at("//",M_FRAZE)-1)-at("=",M_FRAZE)))
     case left(M_FRAZE,8)  == "_SOMBRA_"   ; _SOMBRA_ = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,(at("//",M_FRAZE)-1)-at("=",M_FRAZE)))
     case left(M_FRAZE,8)  == "_FRENTE_"   ; _FRENTE_ = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,(at("//",M_FRAZE)-1)-at("=",M_FRAZE)))
     case left(M_FRAZE,10) == "_INFERIOR_" ; _INFERIOR_ = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,(at("//",M_FRAZE)-1)-at("=",M_FRAZE)))
     case left(M_FRAZE,10) == "_PROTECAO_" ; _PROTECAO_ = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,(at("//",M_FRAZE)-1)-at("=",M_FRAZE)))
     case left(M_FRAZE,10) == "_PROTECAO_" ; _PROTECAO_ = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,(at("//",M_FRAZE)-1)-at("=",M_FRAZE)))
     case left(M_FRAZE,6)  == "_PATH_"     ; _PATH_ = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,(at("//",M_FRAZE)-1)-at("=",M_FRAZE)))
     case left(M_FRAZE,8)  == "_FONTET_"   ; _FONTET_ = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,(at("//",M_FRAZE)-1)-at("=",M_FRAZE)))
     case left(M_FRAZE,8)  == "_FONTEL_"   ; _FONTEL_ = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,(at("//",M_FRAZE)-1)-at("=",M_FRAZE)))
     case left(M_FRAZE,10) == "_LINHASIS_" ; _LINHASIS_ = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,(at("//",M_FRAZE)-1)-at("=",M_FRAZE)))
     case left(M_FRAZE,11) == "_COLUNASIS_" ; _COLUNASIS_ = alltrim(substr(M_FRAZE,at("=",M_FRAZE)+1,(at("//",M_FRAZE)-1)-at("=",M_FRAZE)))

  endcase

enddo

fclose(handle)



  *******************
function TIRA_NULLO(cTABELA)
*******************

/*
csql := csql + "WHEN 261 THEN 'BLOB' "
csql := csql + "WHEN 14 THEN 'CHAR' "
csql := csql + "WHEN 40 THEN 'CSTRING' "
csql := csql + "WHEN 11 THEN 'D_FLOAT' "
csql := csql + "WHEN 27 THEN 'DOUBLE' "
csql := csql + "WHEN 10 THEN 'FLOAT' "
csql := csql + "WHEN 16 THEN 'INT64' "
csql := csql + "WHEN 8 THEN 'INTEGER' "
csql := csql + "WHEN 9 THEN 'QUAD' "
csql := csql + "WHEN 7 THEN 'SMALLINT' "
csql := csql + "WHEN 12 THEN 'DATE' "
csql := csql + "WHEN 13 THEN 'TIME' "
csql := csql + "WHEN 35 THEN 'TIMESTAMP' "
csql := csql + "WHEN 37 THEN 'VARCHAR' "
csql := csql + "ELSE 'UNKNOWN' "

*/


*db := FBConnect(_PATHSQL_, "sysdba", "masterkey")

*trans := FBStartTransaction( db )
*FBExecute( db, "update apca00 set pcades1 = 'SILAS NOVO' where pcamat = 19",, trans )
*FBCommit( trans )


csql := "SELECT r.RDB$FIELD_NAME AS nome, "
csql := csql + "r.RDB$DESCRIPTION AS descricao, "
csql := csql + "f.RDB$FIELD_LENGTH AS tamanho, "
csql := csql + "CASE f.RDB$FIELD_TYPE "
csql := csql + "WHEN 261 THEN 'CHAR' "
csql := csql + "WHEN 14 THEN 'CHAR' "
csql := csql + "WHEN 40 THEN 'CHAR' "
csql := csql + "WHEN 11 THEN 'NUM' "
csql := csql + "WHEN 27 THEN 'NUM' "
csql := csql + "WHEN 10 THEN 'NUM' "
csql := csql + "WHEN 16 THEN 'NUM' "
csql := csql + "WHEN 8 THEN 'NUM' "
csql := csql + "WHEN 9 THEN 'NUM' "
csql := csql + "WHEN 7 THEN 'NUM' "
csql := csql + "WHEN 12 THEN 'DATE' "
csql := csql + "WHEN 13 THEN 'TIME' "
csql := csql + "WHEN 35 THEN 'TIMESTAMP' "
csql := csql + "WHEN 37 THEN 'CHAR' "
csql := csql + "ELSE 'UNKNOWN' "
csql := csql + "END AS tipo "
csql := csql + "FROM RDB$RELATION_FIELDS r "
csql := csql + "LEFT JOIN RDB$FIELDS f ON r.RDB$FIELD_SOURCE = f.RDB$FIELD_NAME "
csql := csql + "WHERE r.RDB$RELATION_NAME='" + cTABELA + "' "
csql := csql + "ORDER BY r.RDB$FIELD_POSITION;"

seexistesql("AUXILIAR")
dbusearea(.t.,"SQLMIX",cSQL,"AUXILIAR")
select AUXILIAR
go top

set print on
set printer to "SQL.TXT"
setcolor("N/W")

do while !eof()


  @ 24, 00 SAY alltrim(NOME)

  if alltrim(TIPO) = "CHAR" .or. alltrim(TIPO) = "NUM"
  else
    skip
    loop
  endif

  cSQL = "UPDATE " + cTABELA + " SET " + alltrim(NOME) + " = "
  if TIPO = "CHAR"
    csql := csql + "'' where " + alltrim(NOME) + " IS NULL"
  else
    csql := csql + "0 where " + alltrim(NOME) + " IS NULL"
  endif

  ? csql

 set printer to
 set print off

*  seexiste("ATUALIZA")
*  dbusearea(.t.,"SQLMIX",cSQL,"ATUALIZA")

trans := FBStartTransaction( db )
FBExecute(db,cSQL,3)
//inkey(1)
FBCommit( trans )

*  cSQL = "UPDATE AEMP00 SET EMPFAN = 'DEU TERRADO' WHERE EMPCOD = '1'"

*  seexistesql("APED00")
*  dbusearea(.T.,"SQLMIX",cSQL,"APED00")


*    nConn:execute("UPDATE AEMP00 SET EMPFAN = 'DEU CERTO' WHERE EMPCOD = 1")
*  nConn:execute(cSQL)
* N := RDDINFO( RDDI_EXECUTE,"UPDATE AEMP00 SET EMPFAN = 'DEU CERTO' WHERE EMPCOD = 1")

* EXIT

  select AUXILIAR

  skip
enddo


*set printer to
*set print off

return ""

function wvt_DrawLabel
msg("wvt_DrawLabel")

function WVT_DRAWBOXGET
function WVT_SETPEN
function WVT_DRAWGRIDVERT
function WVT_DRAWSHADOW2

*function WVT_DRAWBOXRAISED

function WVT_SETMOUSEMOVE
function WVT_SETMOUSEPOS
function WVT_GETPALETTE
function WVT_SETPALETTE
function WVT_DRAWBOXGROUP
function WVT_GETFONTINFO
function WVT_GETWINDOWHANDLE
function WVT_DRAWBOXRECESSED
function WVT_DRAWCOLORRECT
function WVT_SAVESCREEN
function WVT_RESTSCREEN
function WVT_DRAWIMAGE
function WVT_SETPOPUPMENU
function WVT_SETTITLE
function WVT_DRAWLINE
function WVT_SETBRUSH
function WVT_DRAWELLIPSE
function WVT_DRAWRECTANGLE
function WVT_DRAWBOXGROUPRAISED
function WVT_DRAWBUTTON
function WVT_WVTPAINTOBJECTS
function WVT_GETLASTMENUEVENT
function WVT_WVTSETKEYS
function WVTSETOBJECTS
function WVT_DRAWBOXRAISED

FUNCTION WVW_TIMER( )

   // Atualiza a hora na StatusBar
   wvw_sbSetText( ,5, Time())

RETURN NIL


FUNCTION DestacarArea( nTop, nLeft, nBottom, nRight, nNovaCor )

LOCAL cOrig, cNovo, i

   // 1) Captura a região (texto + cores originais)
   cOrig := SaveScreen( nTop, nLeft, nBottom, nRight )

   // 2) Monta buffer igual, mas com o atributo de cor trocado
   cNovo := ""
   FOR i := 1 TO Len( cOrig ) STEP 2
      cNovo += SubStr( cOrig, i, 1 ) + Chr( nNovaCor )
              //  ^ caractere original    ^ nova cor
   NEXT

   // 3) Restaura na tela com a nova cor
   RestScreen( nTop, nLeft, nBottom, nRight, cNovo )

RETURN cOrig   // devolve o original p/ restaurar depois


// Tabela de atributos (byte de cor)
// A formula ‚ nAttr = cor_frente + (cor_fundo * 16) (some +128 para piscar)

// Valor	Resultado	Uso topico
// 31	   Branco brilhante s/ Azul (W+/B)	Destaque de seleção ?
// 112	Preto s/ Cinza (N/W)	Telas padrão
// 240	Preto s/ Branco brilhante	Como sua imagem
// 15	   Branco s/ Preto (W/N)	Modo DOS clássico
// 78	   Amarelo s/ Azul (GR+/B)	Títulos
// 0	   Preto s/ Preto	"Esconder" texto

FUNCTION WvtSetBlocks( a_ )

   LOCAL o
   STATIC s := {}

   o := aclone( s )

   IF a_ != nil
      s := aclone( a_ )
   ENDIF

   RETURN o
   
   

******************
function WVW_PAINT
******************
local POSPAINT

if valtype(lDesligaRedraw) = "L"
  if lDesligaRedraw  // sempre que estiver na consulta nunca vai restaurar a tela
    return ""
  endif
else
  return ""
endif

aEval(GetList,{|oGet|WVW_DrawBoxGet(,oGet:Row,oGet:Col,Len(Transform(oGet:VarGet(),oGet:Picture) ),{2,0,-2,0})})

for POSPAINT = 1 to len(aRestauratelas)

   if aRestauratelas[POSPAINT][1] == "TLREQ01" .and. aRestauratelas[POSPAINT][2]
     WvW_DRAWBOXRECESSED(, 03, 02, 20, 76)
     WVW_DRAWLINE(, 09, 02, 09, 76)
     WVW_DRAWLINE(, 11, 02, 11, 76)

*     WVW_DRAWLINE(, 11, 02, 20, 02,1,,,,,,{-14,,,})
     WVW_DRAWLINE(, 10, 05, 20, 05,1,,,,,,{-14,,,})
     WVW_DRAWLINE(, 10, 12, 20, 12,1,,,,,,{-14,,,})
     WVW_DRAWLINE(, 10, 44, 20, 44,1,,,,,,{-14,,,})
     WVW_DRAWLINE(, 10, 54, 20, 54,1,,,,,,{-14,,,})
     WVW_DRAWLINE(, 10, 65, 20, 65,1,,,,,,{-14,,,})
   endif



*     wvw_DrawBoxRecessed(, 03, 02, 21, 76)
*     WVW_DRAWLINE(, 10, 02, 10, 76)
*     WVW_DRAWLINE(, 12, 02, 12, 76)
*     WVW_DRAWLINE(, 11, 05, 21, 05,1,,,,,,{-14,,,})
*     WVW_DRAWLINE(, 11, 12, 21, 12,1,,,,,,{-14,,,})
*     WVW_DRAWLINE(, 11, 44, 21, 44,1,,,,,,{-14,,,})
*     WVW_DRAWLINE(, 11, 54, 21, 54,1,,,,,,{-14,,,})
*     WVW_DRAWLINE(, 11, 65, 21, 65,1,,,,,,{-14,,,})


   if aRestauratelas[POSPAINT][1] == "TLNFS01" .and. aRestauratelas[POSPAINT][2]
     *wvw_DrawImage( , 4, 5,25,79,"nf.jpg",,.t.)
     *WVW_DRAWBOXGROUP(, 04, 05, 09, 44)
     *wvw_DrawBoxRaised(, 04, 45, 09, 79)
     *wvw_DrawLabel(, 4, 5,"   Identifica‡Æo                   ",,,RGB( 233, 233, 233 ),RGB(   9,  75,  79),"Segoe UI 10",_FONTET_,_FONTEL_,0,200)
     *wvw_DrawLabel(, 4, 5,"   Identifica‡Æo                   ",,,RGB( 233, 233, 233 ),RGB(   9,  75,  79),"VISUALLIB",31,18,0,200)
     *wvw_DrawColorRect(, 11, 05, 16, 44,,RGB(   9,  75,  79))

     wvw_DrawBoxRecessed(, 04, 05, 09, 44)
     wvw_DrawBoxRecessed(, 04, 45, 09, 78)
     wvw_DrawBoxRecessed(, 10, 05, 14, 78)
   endif
next

return ""

function WVW_SIZE

*lPaintGets := .t.

*   aEval(GetList,{|oGet|WVW_DrawBoxGet(,oGet:Row,oGet:Col,Len(Transform(oGet:VarGet(),oGet:Picture)))})

*  npaintt ++
*  @ 26, 00 SAY "wvw_size nao " + str(npaintt) + " " + iif(lResize,"SIM","NAO")


return ""



***************************
********************************************************************************************************
// NOVO SELE_ARQUIVO


/*******************************************************************************
 * SISTEMA         : ERP EAGRO - GESTÃO AGROPECUÁRIA E INDUSTRIAL              *
 * MÓDULO          : SELE_ARQUIVO_INCREMENTAL.prg                              *
 * DESCRIÇÃO       : Função Universal de Pesquisa e Consulta (SELE_ARQUIVO)    *
 *                   com PESQUISA INCREMENTAL EM TEMPO REAL (ao digitar)       *
 * INTEGRIDADE     : 100% das regras de negócio, queries SQL e colunas intactas*
 * COORDENADAS     : Nenhuma coordenada de tela (nTop, IN_COL, UL_COL) alterada*
 *******************************************************************************/

#include "inkey.ch"

FUNCTION SELE_ARQUIVOINCRE( fARQUIVO, FCODIGO )

   LOCAL nKey, bBlock, aLastPaint, i, info_
   LOCAL lEnd    := .f.
   LOCAL aBlocks := {}
   LOCAL nTop    :=  1
   LOCAL nLeft   :=  1
   LOCAL nBottom := 20 // maxrow() - 8
   LOCAL nRight  := maxcol() - 3
   LOCAL nCursor := setCursor( 0 )
   LOCAL nRow    := row()
   LOCAL nCol    := col()
   LOCAL cColor  := SetColor( 'N/W*,W/N+,W/R,,N/W*,GR+/BG,R+/W*' )
   LOCAL cScr0   := SaveScreen( 0,0,maxrow(),maxcol() )
   LOCAL cFileIndex, cFileDbf, cRDD, nIndex
   LOCAL lpri
   LOCAL cPesqInc := ""  && BUFFER DA PESQUISA INCREMENTAL EM TEMPO REAL

   STATIC nStyle := 0
   lDesligaRedraw := .t.

do case
  case fARQUIVO == "CBNEF"
    seexistesql("CBNEF")
    cSql := "SELECT * FROM CBNEF ORDER BY DESCRICAO"
    dbusearea(.t.,"SQLMIX",cSql,"CBNEF")
    lTampesq = len(DESCRICAO)
    lTangrade = 72
    cTitulo = "PESQUISA BENEFICIO"

  case fARQUIVO == "AFOR00"
    arqABERTO = "AFOR00"
    seexistesql("AFOR00")
    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}
    aadd(sqlARQUI,{"AFOR00","AFOR00"})
    aadd(sqlCAMPO,"first 50 FORNOM")
    aadd(sqlCAMPO,"FORCOD")
    aadd(sqlCAMPO,"FOREND")
    aadd(sqlCAMPO,"FOREST")
    aadd(sqlORDEM,"AFOR00.FORNOM")
    if !empty(cPESQUISAfor)
      aadd(sqlCHAVE,"FORNOM LIKE '" + alltrim(cPESQUISAfor) + "%'")
    else
      aadd(sqlCHAVE,"FORNOM <> ' '")
    endif
    sqlrelation()
    select AFOR00
    lTampesq = len(FORNOM)
    lTangrade = 72
    cTitulo = "PESQUISA FORNECEDOR"

  case fARQUIVO == "APOR00"
    seexistesql("APOR00")
    cSql := "SELECT * FROM APOR00 ORDER BY PORNOM"
    dbusearea(.t.,"SQLMIX",cSql,"APOR00")
    lTampesq = len(PORNOM)
    lTangrade = 72
    cTitulo = "PESQUISA PORTADOR"

  case fARQUIVO == "ATRA00"
    seexistesql("ATRA00")
    cSql := "SELECT * FROM ATRA00 ORDER BY TRANOM"
    dbusearea(.t.,"SQLMIX",cSql,"ATRA00")
    lTampesq = len(TRANOM)
    lTangrade = 72
    cTitulo = "PESQUISA TRANSPORTE"

  case fARQUIVO == "ACPG00"
    seexistesql("ACPG00")
    cSql := "SELECT first 50 * FROM ACPG00 WHERE CPGCOD > 0 and CPGDES <> ''"
    dbusearea(.t.,"SQLMIX",cSql,"ACPG00")
    lTampesq = len(CPGDES)
    lTangrade = 60
    cTitulo = "PESQUISA PAGAMENTO"
    locate for !empty(CPGDES)

  case fARQUIVO == "AHIS00"
    seexistesql("AHIS00")
    cSql := "SELECT * FROM AHIS00 ORDER BY HISDES"
    dbusearea(.t.,"SQLMIX",cSql,"AHIS00")
    lTampesq = len(HISDES)
    lTangrade = 46
    cTitulo = "PESQUISA HISTORICO"

  case fARQUIVO == "AMUN00"
    seexistesql("AMUN00")
    cSql := "SELECT * FROM AMUN00 WHERE MUNNOM LIKE 'PRESIDENTE%' ORDER BY MUNNOM"
    dbusearea(.t.,"SQLMIX",cSql,"AMUN00")
    lTampesq = len(MUNNOM)
    lTangrade = 72
    cTitulo = "PESQUISA MUNICIPIO"

  case fARQUIVO == "ACLI00"
    arqABERTO = "ACLI00"
    seexistesql("ACLI00")
    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}
    aadd(sqlARQUI,{"ACLI00","ACLI00"})
    aadd(sqlCAMPO,"first 50 CLINOM")
    aadd(sqlCAMPO,"CLICOD")
    aadd(sqlCAMPO,"CLIEND1")
    aadd(sqlCAMPO,"CLIUF1")
    aadd(sqlCAMPO,"CLIMUN1")
    aadd(sqlCAMPO,"CLICLF")
    aadd(sqlORDEM,"CLINOM")
    if !empty(cPESQUISAcli)
      aadd(sqlCHAVE,"CLINOM LIKE '" + alltrim(cPESQUISAcli) + "%'")
    else
      aadd(sqlCHAVE,"CLINOM <> ' '")
    endif
    sqlrelation()
    select ACLI00
    lTampesq = len(CLINOM)
    lTangrade = 100
    cTitulo = "PESQUISA CLIENTE"

  case fARQUIVO == "APCA00"
    arqABERTO = "APCA00"
    seexistesql("APCA00")
    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}
    aadd(sqlARQUI,{"APCA00","APCA00"})
    aadd(sqlCAMPO,"first 50 PCADES")
    aadd(sqlCAMPO,"PCAUNI")
    aadd(sqlCAMPO,"PCAMAR")
    aadd(sqlCAMPO,"PCAMAT")
    aadd(sqlCAMPO,"COALESCE(S1.SLDDIS,0) as SALDO1")
    aadd(sqlCAMPO,"COALESCE(S2.SLDDIS,0) as SALDO2")
    aadd(sqlCAMPO,"COALESCE(S1.SLDPRC,0) as SLDPRC")
    if AEMP00->EMPCGC == "037623347000109"
      aadd(sqlRELATION,{"ASLD00 S1",str(2, 2, 0),"S1.SLDEMP"})
      aadd(sqlRELATION,{"","S1.SLDMAT","APCA00.PCAMAT"})
      aadd(sqlRELATION,{"ASLD00 S2",str(10, 2, 0),"S2.SLDEMP"})
      aadd(sqlRELATION,{"","S2.SLDMAT","APCA00.PCAMAT"})
    else
      aadd(sqlRELATION,{"ASLD00 S1",str(1, 2, 0),"S1.SLDEMP"})
      aadd(sqlRELATION,{"","S1.SLDMAT","APCA00.PCAMAT"})
      aadd(sqlRELATION,{"ASLD00 S2",str(10, 2, 0),"S2.SLDEMP"})
      aadd(sqlRELATION,{"","S2.SLDMAT","APCA00.PCAMAT"})
    endif
    aadd(sqlCHAVE,"PCANUL <> 'S'")
    aadd(sqlORDEM,"APCA00.PCADES")
    if !empty(cPESQUISA)
      aadd(sqlCHAVE,"PCADES LIKE '" + alltrim(cPESQUISA) + "%'")
    else
      aadd(sqlCHAVE,"PCADES <> ' '")
    endif
    if !sqlrelation()
       cPESQUISA = ""
       msgbox1("Erro na consulta, verifique sua pesquisa")
       RestScreen( 0, 0, maxrow(), maxcol(), cScr0 )
      return ""
    endif
    if cCODPESQ > 0
      locate for PCAMAT = cCODPESQ
    endif
    select APCA00
    lTampesq = len(PCADES)
    lTangrade = 100
    cTitulo = "PESQUISA PRODUTO"

  case fARQUIVO == "ASUB00"
    seexistesql("ASUB00")
    cSql := "SELECT first 50 * FROM ASUB00 WHERE SUBCOD > 0"
    dbusearea(.t.,"SQLMIX",cSql,"ASUB00")
    select &fARQUIVO
    locate for !empty(SUBNOM)
    lTampesq = len(SUBNOM)
    lTangrade = 45
    cTitulo = "PESQUISA SUB-GRUPO"

  case fARQUIVO == "AGRP00"
    seexistesql("AGRP00")
    cSql := "SELECT first 50 * FROM AGRP00 WHERE GRPCOD > 0"
    dbusearea(.t.,"SQLMIX",cSql,"AGRP00")
    select &fARQUIVO
    locate for !empty(GRPNOM)
    lTampesq = len(GRPNOM)
    lTangrade = 45
    cTitulo = "PESQUISA GRUPO"

  case fARQUIVO == "AVEN00"
    cSql := "SELECT * FROM AVEN00 WHERE VENCOD > 0 order by VENNOM"
    dbusearea(.t.,"SQLMIX",cSql,"AVEN00")
    lTampesq = len(VENNOM)
    lTangrade = 45
    cTitulo = "PESQUISA VENDEDOR"

  case fARQUIVO == "AFIS00"
    seexistesql("AFIS00")
    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}
    aadd(sqlARQUI,{"AFIS00","AFIS00"})
    aadd(sqlCAMPO,"*")
    aadd(sqlCHAVE,"FISEMP = " + str(ME_EMP, 2, 0))
    aadd(sqlCHAVE,"FISNOV <> '    '")
    sqlrelation()
    lTampesq = len(FISNOM)
    lTangrade = 45
    cTitulo = "PESQUISA CFOP"

  case fARQUIVO == "ACTA00"
    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}
    aadd(sqlARQUI,{"ACTA00","ACTA00"})
    aadd(sqlCAMPO,"*")
    aadd(sqlCHAVE,"CTACTA <> ''")
    sqlrelation()
    lTampesq = len(CTACTA)
    lTangrade = 45
    cTitulo = "PESQUISA CONTA"
endcase

IN_COL = int((105 - lTangrade) /2)
UL_COL = lTangrade + IN_COL

oBrowse := TBrowseDB():New( nTop + 3, IN_COL,21,UL_COL )

do case
  case fARQUIVO == "CBNEF"
    oBrowse:addColumn(TBColumnNew("Descricao", FieldBlock("DESCRICAO")))
    oBrowse:addColumn(TBColumnNew("Beneficio",FieldBlock("CODCBNEF")))
    oBrowse:addColumn(TBColumnNew("Codigo",FieldBlock("CODIGO")))
    oBrowse:GetColumn(1):Picture := "@!@S50"
    oBrowse:GetColumn(3):Picture := "999999"

  case fARQUIVO == "AHIS00"
    oBrowse:addColumn(TBColumnNew("Descricao", FieldBlock("HISDES")))
    oBrowse:addColumn(TBColumnNew("Tipo",FieldBlock("HISTIP")))
    oBrowse:addColumn(TBColumnNew("Codigo",FieldBlock("HISCOD")))
    oBrowse:GetColumn(3):Picture := "999"

  case fARQUIVO == "ACTA00"
    oBrowse:addColumn(TBColumnNew("Conta", FieldBlock("CTACTA")))
    oBrowse:addColumn(TBColumnNew("Nome da Agencia",FieldBlock("CTAAGE")))
    oBrowse:addColumn(TBColumnNew("Banco",FieldBlock("CTABAN")))
    oBrowse:GetColumn(3):Picture := "999"

  case fARQUIVO == "APOR00"
    oBrowse:addColumn(TBColumnNew("DESCRICAO",FieldBlock("PORNOM")))
    oBrowse:addColumn(TBColumnNew("CODIGO", FieldBlock("PORCOD")))
    oBrowse:GetColumn(2):Picture := "99999"

  case fARQUIVO == "ATRA00"
    oBrowse:addColumn(TBColumnNew("NOME",FieldBlock("TRANOM")))
    oBrowse:addColumn(TBColumnNew("CODIGO", FieldBlock("TRACOD")))
    oBrowse:addColumn(TBColumnNew("ENDERECO",FieldBlock("TRAEND")))
    oBrowse:addColumn(TBColumnNew("UF", FieldBlock("TRAEST")))
    oBrowse:GetColumn(1):Picture := "@s35"
    oBrowse:GetColumn(2):Picture := "99999"
    oBrowse:GetColumn(3):Picture := "@s25"

  case fARQUIVO == "ACPG00"
    oBrowse:addColumn(TBColumnNew("Descricao",FieldBlock("CPGDES")))
    oBrowse:addColumn(TBColumnNew("COD", FieldBlock("CPGCOD")))
    oBrowse:addColumn(TBColumnNew("P",FieldBlock("CPGPAR")))
    oBrowse:addColumn(TBColumnNew("PZ1",FieldBlock("CPGPR1")))
    oBrowse:addColumn(TBColumnNew("PZ2",FieldBlock("CPGPR2")))
    oBrowse:addColumn(TBColumnNew("PZ3",FieldBlock("CPGPR3")))
    oBrowse:addColumn(TBColumnNew("PZ4",FieldBlock("CPGPR4")))
    oBrowse:addColumn(TBColumnNew("PZ5",FieldBlock("CPGPR5")))
    oBrowse:addColumn(TBColumnNew("PZ6",FieldBlock("CPGPR6")))
    oBrowse:GetColumn(1):Picture := "@!"
    oBrowse:GetColumn(2):Picture := "999"

  case fARQUIVO == "AHIE00"
    oBrowse:addColumn(TBColumnNew("DESCRICAO",FieldBlock("HIENOM")))
    oBrowse:addColumn(TBColumnNew("CODIGO", FieldBlock("HIEOPE")))
    oBrowse:GetColumn(2):Picture := "99999"

  case fARQUIVO == "AMUN00"
    oBrowse:addColumn(TBColumnNew("MUNICIPIO DESCRICAO",FieldBlock("MUNNOM")))
    oBrowse:addColumn(TBColumnNew("UF",FieldBlock("MUNEST")))
    oBrowse:addColumn(TBColumnNew("CODIGO", FieldBlock("MUNCOD")))
    oBrowse:GetColumn(3):Picture := "9999999"

  case fARQUIVO == "ASUB00"
    oBrowse:addColumn(TBColumnNew("DESCRICAO DO SUB-GRUPO",FieldBlock("SUBNOM")))
    oBrowse:addColumn(TBColumnNew("COD", FieldBlock("SUBCOD")))
    oBrowse:GetColumn(2):Picture := "9999"

  case fARQUIVO == "AGRP00"
    oBrowse:addColumn(TBColumnNew("DESCRICAO DO GRUPO",FieldBlock("GRPNOM")))
    oBrowse:addColumn(TBColumnNew("COD", FieldBlock("GRPCOD")))
    oBrowse:GetColumn(2):Picture := "9999"

  case fARQUIVO == "AFOR00"
    oBrowse:addColumn(TBColumnNew("NOME FORNECEDOR",FieldBlock("FORNOM")))
    oBrowse:addColumn(TBColumnNew("COD", FieldBlock("FORCOD")))
    oBrowse:addColumn(TBColumnNew("ENDERECO",FieldBlock("FOREND")))
    oBrowse:addColumn(TBColumnNew("UF", FieldBlock("FOREST")))
    oBrowse:GetColumn(1):Picture := "@!"
    oBrowse:GetColumn(2):Picture := "99999"
    oBrowse:GetColumn(3):Picture := "@s23"

  case fARQUIVO == "AVEN00"
    oBrowse:addColumn(TBColumnNew("NOME",FieldBlock("VENNOM")))
    oBrowse:addColumn(TBColumnNew("COD", FieldBlock("VENCOD")))
    oBrowse:GetColumn(1):Picture := "@!"
    oBrowse:GetColumn(2):Picture := "99999"

  case fARQUIVO == "AFIS00"
    oBrowse:addColumn(TBColumnNew("NOME",FieldBlock("FISNOM")))
    oBrowse:addColumn(TBColumnNew("CFOP", FieldBlock("FISNOV")))
    oBrowse:addColumn(TBColumnNew("ESTOQUE",FieldBlock("FISEST")))
    oBrowse:addColumn(TBColumnNew("COMPLEMENTAR", FieldBlock("FISCPL")))

  case fARQUIVO == "ACLI00"
    oCol := TBColumnNew("NOME",FieldBlock("CLINOM"))
    oCol:Picture := "@!@S40"
    oBrowse:addColumn(oCol)
    oCol := TBColumnNew("COD", FieldBlock("CLICOD"))
    oCol:Picture := "99999"
    oBrowse:addColumn(oCol)
    oCol := TBColumnNew("ENDERECO DE ENTREGA",FieldBlock("CLIEND1"))
    oCol:Picture := "@s23"
    oBrowse:addColumn(oCol)
    oCol := TBColumnNew("MUNICIPIO",FieldBlock("CLIMUN1"))
    oCol:Picture := "@s20"
    oBrowse:addColumn(oCol)
    oCol := TBColumnNew("UF", FieldBlock("CLIUF1"))
    oCol:Picture := "@!@S2"
    oBrowse:addColumn(oCol)

  case fARQUIVO == "APCA00"
    oBrowse:addColumn(TBColumnNew("Descricao dos Produtos",FieldBlock("PCADES")))
    oBrowse:addColumn(TBColumnNew("Marca",FieldBlock("PCAMAR")))
    oBrowse:addColumn(TBColumnNew("Codigo", FieldBlock("PCAMAT")))
    oBrowse:addColumn(TBColumnNew("Un",&("{||TRAN(pad(PCAUNI,2),[@!])}")))
    if ME_EMP = 1
      oBrowse:addColumn(TBColumnNew("Saldo",&("{||TRAN(SALDO1,[99999999])}")))
    ELSE
      oBrowse:addColumn(TBColumnNew("Saldo",&("{||TRAN(SALDO2,[99999999])}")))
    endif
    oBrowse:addColumn(TBColumnNew("Preco",&("{||TRAN(SLDPRC,[@R 9,999.99])}")))
    oBrowse:GetColumn(2):Picture := "@!@S20"
    oBrowse:GetColumn(3):Picture := "999999"
endcase

   oBrowse:ColSep        := ' '
   oBrowse:HeadSep       := 'Ä'
   oBrowse:GoTopBlock    := { || dbGoTop() }
   oBrowse:GoBottomBlock := { || dbGoBottom() }
   oBrowse:SkipBlock     := { | nSkip | dbSkipBlock( nSkip,oBrowse ) }
   oBrowse:freeze := 1
   oBrowse:colPos := 1
   oBrowse:configure()

   wvw_nOpenWindow( "", nTop + 2, IN_COL-1,24,UL_COL+1, NIL, 0 )
   win(nTop + 2, IN_COL-1,22,UL_COL+1 ,cTITULO,"N/RB*","RB+/W*")

   lKeyWaiting := .F.
   lBrowse := .T.
   lPosrecloc = 0
   M_PROC = ""
   NpOSIC = { }
   cPosic = ""
   nc = 1
   lPri = .t.

   DO WHILE (lBrowse)
     lErroconsulta = .f.
     oBrowse:RefreshCurrent()
     oBrowse:Stabilize()
     if lPri
       lPri := .f.
       cSave := DestacarArea(nTop + 3, IN_COL-1,nTop + 3,UL_COL+1 , 31 )
     endif

     if !fARQUIVO == "ACLI00"
        oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{2,5} )
        oBrowse:colPos := 1
     endif

     // --- EXIBIR BARRA DE PESQUISA INCREMENTAL NO RODAPÉ (SEM ALTERAR LAYOUT DA GRADE) ---
     @ 23, IN_COL-1 SAY PadR( " Pesquisa: [" + cPesqInc + "]", (UL_COL - IN_COL) + 3 ) COLOR "N/RB*"

     do while .t.
       nKey := nInKey(1)
       if nKey # 0
         exit
       endif
     enddo

    do case
    CASE (nKey == 27)
      lBrowse := .F.

    CASE (nKey == K_ENTER)
       do case
          case fARQUIVO == "AHIS00"
               nCodRetorno = HISCOD
          case fARQUIVO == "CBNEF"
               nCodRetorno = CODCBNEF
          case fARQUIVO == "ACTA00"
               nCodRetorno = CTACTA
          case fARQUIVO == "APOR00"
               nCodRetorno = PORCOD
          case fARQUIVO == "AFIS00"
               nCodRetorno = FISNOV
          case fARQUIVO == "ASUB00"
               nCodRetorno = SUBCOD
          case fARQUIVO == "AVEN00"
               nCodRetorno = VENCOD
          case fARQUIVO == "ATRA00"
               nCodRetorno = TRACOD
          case fARQUIVO == "ACPG00"
               nCodRetorno = CPGCOD
          case fARQUIVO == "AGRP00"
               nCodRetorno = GRPCOD
          case fARQUIVO == "ACLI00"
              if !empty(M_PROC)
                 cPESQUISAcli = M_PROC
              endif
               nUltClid = recno()
               nCodRetorno = CLICOD
          case fARQUIVO == "AFOR00"
              if !empty(M_PROC)
                 cPESQUISAfor = M_PROC
              endif
               nUltFord = recno()
               nCodRetorno = FORCOD
          case fARQUIVO == "AMUN00"
               nCodRetorno = MUNCOD
          case fARQUIVO == "APCA00"
              if !empty(M_PROC)
                 cPESQUISA = M_PROC
              endif
              cCODPESQ = PCAMAT
              nUltprod = recno()
              nCodRetorno = PCAMAT
       endcase
       wvw_lCloseWindow()
       lDesligaRedraw := .f.
       return ""

    CASE (nKey == K_DOWN)
      oBrowse:down()
    CASE (nKey == K_UP)
      oBrowse:up()
    CASE (nKey == K_PGDN)
      oBrowse:pageDown()
    CASE (nKey == K_PGUP)
      oBrowse:pageUp()
    CASE (nKey == K_CTRL_PGUP)
      oBrowse:goTop()
    CASE (nKey == K_CTRL_PGDN)
      oBrowse:goBottom()
    CASE (nKey == K_RIGHT)
      oBrowse:right()
    CASE (nKey == K_LEFT)
      oBrowse:left()
    CASE (nKey == K_HOME)
      oBrowse:home()
    CASE (nKey == K_END)
      oBrowse:end()
    CASE (nKey == K_CTRL_LEFT)
      oBrowse:panLeft()
    CASE (nKey == K_CTRL_RIGHT)
      oBrowse:panRight()
    CASE (nKey == K_CTRL_HOME)
      oBrowse:panHome()
    CASE (nKey == K_CTRL_END)
      oBrowse:panEnd()
    CASE (nKey == K_F3)
    CASE (nKey == K_F2)
    CASE (nKey == K_ESC)
      lBrowse := .F.

    // --- TECLA BACKSPACE (APAGAR ÚLTIMO CARACTERE DO BUFFER E REFILTRAR EM TEMPO REAL) ---
    CASE (nKey == K_BS)
      if Len( cPesqInc ) > 0
         cPesqInc := Left( cPesqInc, Len( cPesqInc ) - 1 )
         M_PROC   := cPesqInc
         @ 23, IN_COL-1 SAY PadR( " Pesquisa: [" + cPesqInc + "]", (UL_COL - IN_COL) + 3 ) COLOR "N/RB*"

         lErroconsulta := ATUALIZAR_FILTRO_INCREMENTAL( fARQUIVO, cPesqInc, oBrowse )
         if !lErroconsulta
            oBrowse:RefreshAll()
            oBrowse:ForceStable()
         endif
      endif

    // --- DIGITAÇÃO INCREMENTAL EM TEMPO REAL (CARACTERES ALFANUMÉRICOS SEM ABRIR GET BLOQUEANTE) ---
    CASE (nKey >= 32 .AND. nKey <= 255) .AND. (nKey # K_ESC .AND. nKey # K_ENTER)
      cPesqInc := cPesqInc + Upper( Chr( nKey ) )
      M_PROC   := cPesqInc
      @ 23, IN_COL-1 SAY PadR( " Pesquisa: [" + cPesqInc + "]", (UL_COL - IN_COL) + 3 ) COLOR "N/RB*"

      lErroconsulta := ATUALIZAR_FILTRO_INCREMENTAL( fARQUIVO, cPesqInc, oBrowse )
      if lErroconsulta
      else
         oBrowse:RefreshAll()
         oBrowse:ForceStable()
      endif

    ENDCASE
   end

 wvw_lCloseWindow()
 RestScreen( 0, 0, maxrow(), maxcol(), cScr0 )
 lDesligaRedraw := .f.
 nCodRetorno = 0
 RETURN ""

/*******************************************************************************
 * ATUALIZAR_FILTRO_INCREMENTAL
 * Atualiza o filtro / query SQL em tempo real ao digitar ou apagar letras
 *******************************************************************************/
STATIC FUNCTION ATUALIZAR_FILTRO_INCREMENTAL( fARQUIVO, cTermo, oBrowse )
   LOCAL lErro := .F.
   LOCAL cSql  := ""

* @ 24, 50 say oBrowse:colPos

   if oBrowse:colPos = 1

   do case
      case fARQUIVO == "CBNEF"
         seexistesql("CBNEF")
         cSql := "SELECT * FROM CBNEF WHERE DESCRICAO LIKE '%" + alltrim(cTermo) + "%' ORDER BY DESCRICAO"
         try
           dbusearea(.t.,"SQLMIX",cSql,"CBNEF")
         catch
           lErro := .T.
         end

      case fARQUIVO == "ACTA00"
         seexistesql("ACTA00")
         cSql := "SELECT * FROM ACTA00 WHERE CTACTA LIKE '%" + alltrim(cTermo) + "%'"
         try
           dbusearea(.t.,"SQLMIX",cSql,"ACTA00")
         catch
           lErro := .T.
         end

      case fARQUIVO == "APOR00"
         seexistesql("APOR00")
         cSql := "SELECT * FROM APOR00 WHERE PORNOM LIKE '" + alltrim(cTermo) + "%' ORDER BY PORNOM"
         dbusearea(.t.,"SQLMIX",cSql,"APOR00")

      case fARQUIVO == "AHIS00"
         seexistesql("AHIS00")
         cSql := "SELECT * FROM AHIS00 WHERE HISDES LIKE '" + alltrim(cTermo) + "%' ORDER BY HISDES"
         dbusearea(.t.,"SQLMIX",cSql,"AHIS00")

      case fARQUIVO == "ASUB00"
         set order to 2
         dbseek( cTermo, .T. )

      case fARQUIVO == "AVEN00"
         seexistesql("AVEN00")
         cSql := "SELECT * FROM AVEN00 WHERE VENNOM LIKE '" + alltrim(cTermo) + "%' ORDER BY VENNOM"
         dbusearea(.t.,"SQLMIX",cSql,"AVEN00")

      case fARQUIVO == "ATRA00"
         seexistesql("ATRA00")
         cSql := "SELECT * FROM ATRA00 WHERE TRANOM LIKE '" + alltrim(cTermo) + "%' ORDER BY TRANOM"
         dbusearea(.t.,"SQLMIX",cSql,"ATRA00")

      case fARQUIVO == "ACPG00"
         seexistesql("ACPG00")
         cSql := "SELECT * FROM ACPG00 WHERE CPGDES LIKE '" + alltrim(cTermo) + "%' ORDER BY CPGDES"
         dbusearea(.t.,"SQLMIX",cSql,"ACPG00")

      case fARQUIVO == "AGRP00"
         seexistesql("AGRP00")
         cSql := "SELECT * FROM AGRP00 WHERE GRPNOM LIKE '" + alltrim(cTermo) + "%'"
         try
           dbusearea(.t.,"SQLMIX",cSql,"AGRP00")
         catch
           lErro := .T.
         end

      case fARQUIVO == "APCA00"
         seexistesql("APCA00")
         sqlRELATION = {}
         sqlCAMPO = {}
         sqlCHAVE = {}
         sqlARQUI = {}
         sqlORDEM = {}
         aadd(sqlARQUI,{"APCA00","APCA00"})
         aadd(sqlCAMPO,"PCADES")
         aadd(sqlCAMPO,"PCAUNI")
         aadd(sqlCAMPO,"PCAMAR")
         aadd(sqlCAMPO,"PCAMAT")
         aadd(sqlCAMPO,"COALESCE(S1.SLDDIS,0) as SALDO1")
         aadd(sqlCAMPO,"COALESCE(S2.SLDDIS,0) as SALDO2")
         aadd(sqlCAMPO,"COALESCE(S1.SLDPRC,0) as SLDPRC")
         if AEMP00->EMPCGC == "037623347000109"
           aadd(sqlRELATION,{"ASLD00 S1",str(2, 2, 0),"S1.SLDEMP"})
           aadd(sqlRELATION,{"","S1.SLDMAT","APCA00.PCAMAT"})
           aadd(sqlRELATION,{"ASLD00 S2",str(10, 2, 0),"S2.SLDEMP"})
           aadd(sqlRELATION,{"","S2.SLDMAT","APCA00.PCAMAT"})
         else
           aadd(sqlRELATION,{"ASLD00 S1",str(1, 2, 0),"S1.SLDEMP"})
           aadd(sqlRELATION,{"","S1.SLDMAT","APCA00.PCAMAT"})
           aadd(sqlRELATION,{"ASLD00 S2",str(10, 2, 0),"S2.SLDEMP"})
           aadd(sqlRELATION,{"","S2.SLDMAT","APCA00.PCAMAT"})
         endif
         aadd(sqlCHAVE,"PCANUL <> 'S'")

         if !Empty(cTermo)
            aadd(sqlCHAVE,"PCADES LIKE '" + alltrim(cTermo) + "%'")
         else
            aadd(sqlCHAVE,"PCADES <> ' '")
         endif
         aadd(sqlORDEM,"APCA00.PCADES")
         if !sqlrelation()
            lErro := .T.
         endif

      case fARQUIVO == "AMUN00"
         seexistesql("AMUN00")
         cSql := "SELECT * FROM AMUN00 WHERE MUNNOM LIKE '" + alltrim(cTermo) + "%' ORDER BY MUNNOM"
         try
           dbusearea(.t.,"SQLMIX",cSql,"AMUN00")
         catch
           lErro := .T.
         end

      case fARQUIVO == "ACLI00"
         seexistesql("ACLI00P")
         sqlRELATION = {}
         sqlCAMPO = {}
         sqlCHAVE =  {}
         sqlARQUI = {}
         sqlORDEM = {}
         aadd(sqlARQUI,{"ACLI00","ACLI00P"})
         aadd(sqlCAMPO,"CLINOM")
         aadd(sqlCAMPO,"CLICOD")
         aadd(sqlCAMPO,"CLIEND1")
         aadd(sqlCAMPO,"CLIMUN1")
         aadd(sqlCAMPO,"CLICLF")
         aadd(sqlCAMPO,"CLIUF1")
         if !Empty(cTermo)
            aadd(sqlCHAVE,"CLINOM LIKE '" + alltrim(cTermo) + "%'")
         else
            aadd(sqlCHAVE,"CLINOM <> ' '")
         endif
         aadd(sqlORDEM,"CLINOM")
         if !sqlrelation()
            lErro := .T.
         endif

      case fARQUIVO == "AFOR00"
         seexistesql("AFOR00")
         sqlRELATION = {}
         sqlCAMPO = {}
         sqlCHAVE =  {}
         sqlARQUI = {}
         sqlORDEM = {}
         aadd(sqlARQUI,{"AFOR00","AFOR00"})
         aadd(sqlCAMPO,"first 50 FORNOM")
         aadd(sqlCAMPO,"FORCOD")
         aadd(sqlCAMPO,"FOREND")
         aadd(sqlCAMPO,"FOREST")
         if !Empty(cTermo)
            aadd(sqlCHAVE,"FORNOM LIKE '" + alltrim(cTermo) + "%'")
         else
            aadd(sqlCHAVE,"FORNOM <> ' '")
         endif
         aadd(sqlORDEM,"FORNOM")
         if !sqlrelation()
            lErro := .T.
         endif

      case fARQUIVO == "AFIS00"
         sqlRELATION = {}
         sqlCAMPO = {}
         sqlCHAVE =  {}
         sqlARQUI = {}
         sqlORDEM = {}
         aadd(sqlARQUI,{"AFIS00","AFIS00"})
         aadd(sqlCAMPO,"*")
         aadd(sqlCHAVE,"FISEMP = " + str(ME_EMP, 2, 0))
         aadd(sqlCHAVE,"FISNOV <> '    '")
         if !Empty(cTermo)
            aadd(sqlCHAVE,"FISNOM LIKE '%" + alltrim(cTermo) + "%'")
         endif
         if !sqlrelation()
            lErro := .T.
         endif

      case fARQUIVO == "AHIE00"
         dbseek( cTermo, .T. )
   endcase
   endif

   if oBrowse:colPos = 4 // municipio cliente
     do case
        case fARQUIVO == "ACLI00"
           seexistesql("ACLI00P")
           sqlRELATION = {}
           sqlCAMPO = {}
           sqlCHAVE =  {}
           sqlARQUI = {}
           sqlORDEM = {}

           aadd(sqlARQUI,{"ACLI00","ACLI00P"})
           aadd(sqlCAMPO,"CLINOM")
           aadd(sqlCAMPO,"CLICOD")
           aadd(sqlCAMPO,"CLIEND1")
           aadd(sqlCAMPO,"CLIMUN1")
           aadd(sqlCAMPO,"CLICLF")
           aadd(sqlCAMPO,"CLIUF1")
           aadd(sqlCHAVE,"CLIMUN1 LIKE '%" + alltrim(cTermo) + "%'")
           aadd(sqlORDEM,"CLINOM")
           if !sqlrelation()
             lErro := .T.
           endif
     endcase
   endif

   RETURN lErro
