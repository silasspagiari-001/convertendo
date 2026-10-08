STATIC s_nNormalMaxrow := 24
STATIC s_nNormalMaxcol := 79
STATIC s_aPObjList := {}

STATIC s_lSizeReady := .F.
STATIC s_zwin := {}
STATIC s_cStdColor := "N/W,N/GR*,,,N/W*"

#xcommand DEFAULT <exp> TO <value> [, <expN> TO <valN> ] => ;
          <exp> := if(( valtype(<exp>)==valtype(<value>) .and. (<exp> != nil)), <exp>, <value>) ;
          [; <expN> := if(( valtype(<expN>)==valtype(<valN>) .and. (<expN> != nil)), <expN>, <valN>) ]
















/*
 * $Id$
 */

/*
   Copyright 2004 Budyanto Dj. <budyanto@centrin.net.id>

   To present prettier displays we may want to use pseudo-GUI objects.
   This, however, is not as easy as the previous example.
   Once you understand how GTWVW draws these objects, you can put
   pseudo-GUI objects onto each window, one by one.

   Notes: GTWVW now also has native Windows Controls. See other samples.
*/

#include "inkey.ch"
#include "setcurs.ch"

#define __GTWVW__


STATIC s_amiscobjlist := {}      // x misc object list (actually: list of codeblocks)



#include "inkey.ch"
#include "setcurs.ch"




// displays a message on MaxRow() and returns .T.

// display cmsg with Yes/No option, returns .T. if Yes selected





*****************************************************************************************************************************************************************


/*
 * $Id$
 */

/*
   compile and link this file together with wutil.prg

   This is a sample of how to display an image file (.bmp,.gif,.jpg)
   in four ways:
   1. Image stretched to fit a region
      (all four coordinates are defined)
   2. Height is defined, width is proportional to height
      (right coordinate is passed as NIL)
   3. Width is defined, height is proportional to width
      (bottom coordinate is passed as NIL)
   4. Actual image size
      (bottom and right coordinate are NIL)

   Also shown in this sample:
   1. Image Caching
      Image is read from file only once, and then cached.
      Test: After image is displayed, delete the image file.
            Image should be still displayed with no problem,
            since gtwvw already store it in memory.
   2. Transparency
      If this option is used, topleft pixel is used as the transparent mask
      of the image.

   Remarks:
   Image drawing and wvw_paint management are performed by wutil.prg.
   wutil.prg is a simple "middle module" interfacing an application with
   gtwvw.
 */

#include "inkey.ch"
#include "setcurs.ch"
#include "hbclass.ch"

// WPAINTOBJ types
#define WPAINTOBJ_LABEL                  1
#define WPAINTOBJ_SHADEDRECT             2
#define WPAINTOBJ_TEXTBOX                3
#define WPAINTOBJ_PROGRESSBAR            4
#define WPAINTOBJ_BOXGET                 5
#define WPAINTOBJ_BOXRAISED              6
#define WPAINTOBJ_BOXRECESSED            7
#define WPAINTOBJ_BOXGROUP               8
#define WPAINTOBJ_BOXGROUPRAISED         9
#define WPAINTOBJ_IMAGE                 10
#define WPAINTOBJ_OUTLINE               11
#define WPAINTOBJ_LINE                  12
#define WPAINTOBJ_ELLIPSE               13
#define WPAINTOBJ_RECTANGLE             14
#define WPAINTOBJ_FILLRECTANGLE         15
#define WPAINTOBJ_ROUNDRECT             16
#define WPAINTOBJ_FOCUSRECT             17
#define WPAINTOBJ_GRIDHORZ              18
#define WPAINTOBJ_GRIDVERT              19
#define WPAINTOBJ_PICTURE               20
#define WPAINTOBJ_LABELEX               21
#define WPAINTOBJ_LINEEX                22
#define WPAINTOBJ_OUTLINEEX             23

// WCTRLOBJ types
#define WCTRLOBJ_PUSHBUTTON             1001
#define WCTRLOBJ_VSCROLLBAR             1002
#define WCTRLOBJ_HSCROLLBAR             1003
#define WCTRLOBJ_COMBOBOX               1004

// OBJECT OPERATION
#define WOBJ_ADD_OVERWRITE      1   // overwrite if exists
#define WOBJ_ADD_APPEND         2   // append even if exists (the same id can coexist)
#define WOBJ_ADD_NEWONLY        3   // cancel if exists


PROCEDURE IMAGEM()

   LOCAL ntop := 7, ;
      nleft := 3, ;
      nbot := MaxRow() - 2, ;
      nrig := MaxCol() - 2, ;
      nmidver := Int( ( ntop + nbot ) / 2 ), ;
      nmidhor := Int( ( nleft + nrig ) / 2 )
   LOCAL cpict := "logo_atlas.jpg"
   LOCAL ltransp := .F.
   LOCAL nMaxCache
   LOCAL i, j, oWPaint
   LOCAL getlist := {}

#if defined( __HBSCRIPT__HBSHELL ) .AND. defined( __PLATFORM__WINDOWS )
   hbshell_gtSelect( "GTWVW" )
#endif

   nMaxCache := wvw_SetMaxBMCache()

   SetColor( "N/W,N/GR*,,,N/W*" )
   wvw_SetCodepage( , 255 )
   wg_ResetWPaintObj( 0 )
   DO WHILE .T.
      CLS
      SetCursor( SC_NORMAL )
      cpict := PadR( cpict, 40 )
      @ 0, 0 SAY "FileName  :" GET cpict PICT "@K" VALID hb_FileExists( AllTrim( cpict ) )
      @ 1, 0 SAY "Transpar? :" GET ltransp PICT "Y"
      @ 2, 0 SAY "Max Cache :" GET nMaxCache PICT "999"
      @ 3, 0 SAY "NumOfCache=" + Transform( wvw_NumBMCache(), "999" ) + ;
         ", Max NumOfCache=" + Transform( wvw_SetMaxBMCache(), "999" )
      READ
      IF LastKey() == K_ESC
         EXIT
      ENDIF
      wvw_SetMaxBMCache( nMaxCache )
      @ 3, 0 SAY "NumOfCache=" + Transform( wvw_NumBMCache(), "999" ) + ;
         ", Max NumOfCache=" + Transform( wvw_SetMaxBMCache(), "999" )

      @ 5, 0 SAY "TOPLEFT: stretched image                 TOPRIGHT: fit vertically (proportional)"
      @ 6, 0 SAY "BOTLEFT: fit horizontally (proportional) BOTRIGHT: actual image size"

      cpict := AllTrim( cpict )

      // wvw_LoadPicture( 1, cpict ) //20060707

      // botright panel, actual image size
      oWPaint := wPaintObj():New( 0, WPAINTOBJ_IMAGE, "BOTRIGHT", 1, 1, maxrow()-1, maxcol()-1, NIL, ltransp )
      oWPaint:cImage := cpict
      nwp := wg_AddWPaintObj( 0, oWPaint )

      msgbox1(nwp)

*      // topleft panel, stretch/fit to panel
*      oWPaint := wPaintObj():New( 0, WPAINTOBJ_IMAGE, "TOPLEFT", ntop + 1, nleft + 1, nmidver - 1, nmidhor - 1, NIL, ltransp )
*      oWPaint:cImage := cpict
*      wg_AddWPaintObj( 0, oWPaint )

*      // topright panel, fit vertically
*      oWPaint := wPaintObj():New( 0, WPAINTOBJ_IMAGE, "TOPRIGHT", ntop + 1, nmidhor + 1, nmidver - 1, NIL, NIL, ltransp )
*      oWPaint:cImage := cpict
*      wg_AddWPaintObj( 0, oWPaint )

*      // botleft panel, fit horizontally
*      oWPaint := wPaintObj():New( 0, WPAINTOBJ_IMAGE, "BOTLEFT", nmidver + 1, nleft + 1, NIL, nmidhor - 1, NIL, ltransp )
*      oWPaint:cImage := cpict
*      wg_AddWPaintObj( 0, oWPaint )

      // botright panel, actual image size
*      oWPaint := wPaintObj():New( 0, WPAINTOBJ_IMAGE, "BOTRIGHT", nmidver + 1, nmidhor + 1, NIL, NIL, NIL, ltransp )
*      oWPaint:cImage := cpict
*      wg_AddWPaintObj( 0, oWPaint )

      Inkey( 0 )

      // delete all image objects
      wg_DelWPaintObj( 0, WPAINTOBJ_IMAGE, NIL )
   ENDDO // WHILE .T.
   SetCursor( SC_NORMAL )

   RETURN

// ************** simple wpaint organizer *******

/*********************************************************/

CREATE CLASS wGUIObj

   VAR nWinNum                      // parent window's number
   VAR lVisible                     // is the object visible
   VAR nType                        // Type
   VAR cId                          // Id
   VAR nRow1, nCol1, nRow2, nCol2   // mouse object region
   VAR aOffTLBR                     // offset in pixels

ENDCLASS

/*********************************************************/

CREATE CLASS wPaintObj FROM wGUIObj

   // image like wvtimage
   VAR cImage
   VAR lTransp

   METHOD New( nWinNum, nType, cId, nRow1, nCol1, nRow2, nCol2, aOffTLBR, lTransp )
   METHOD Draw()
   METHOD Undraw()
   METHOD Hide()
   METHOD Show()

ENDCLASS

METHOD New( nWinNum, nType, cId, nRow1, nCol1, nRow2, nCol2, aOffTLBR, lTransp ) CLASS wPaintObj

   aOffTLBR = { 0, 0, 0, 0 }
   lTransp = .F.

   ::nWinNum := nWinNum
   ::lVisible := .T.

   ::nType := nType
   ::cId := cId
   ::nRow1 := nRow1
   ::nCol1 := nCol1
   ::nRow2 := nRow2
   ::nCol2 := nCol2

   ::aOffTLBR := AClone( aOffTLBR )

   ::lTransp := lTransp

   RETURN Self

METHOD Draw() CLASS wPaintObj

   IF ! ::lVisible
      RETURN NIL
   ENDIF

   DO CASE
   case ::nType == WPAINTOBJ_IMAGE
      IF ! Empty( ::cImage )
         wvw_DrawImage( ::nWinNum, ::nRow1, ::nCol1, ::nRow2, ::nCol2, ;
            ::cImage, ::aOffTLBR, ::lTransp )
      ENDIF

   OTHERWISE
      // lBoxErrMessage()
   ENDCASE

   RETURN NIL  // DRAW()

// undraw the object
// normally this is called with ::lVisible == .F.,
// otherwise the object will be redrawn by WVW_PAINT
METHOD Undraw() CLASS wPaintObj

   LOCAL cScreen
   LOCAL nRow1, nCol1, nRow2, nCol2, nMaxRow, nMaxCol

   // to be safer, the area can be enlarged first
   nMaxRow := MaxRow()
   nMaxCol := MaxCol()

   DO CASE
   case ::nType == WPAINTOBJ_LABEL
      nRow1 := ::nRow1
      nCol1 := ::nCol1
      nRow2 := ::nRow2
      nCol2 := ::nCol2
   OTHERWISE
      nRow1 := Max( ::nRow1 - 1, 0 )
      nCol1 := Max( ::nCol1 - 1, 0 )
      nRow2 := Min( ::nRow2 + 1, nMaxRow )
      nCol2 := Min( ::nCol2 + 1, nMaxCol )
   ENDCASE

   cScreen := SaveScreen( nRow1, nCol1, nRow2, nCol2 )
   DispBegin()
   RestScreen( nRow1, nCol1, nRow2, nCol2, cScreen )
   DispEnd()

   RETURN NIL // undraw()

METHOD Hide() CLASS wPaintObj

   // temporarily hides the object
   ::lVisible := .F.
   ::Undraw()

   RETURN NIL

METHOD Show() CLASS wPaintObj

   // show the object
   ::lVisible := .T.
   ::draw()

   RETURN NIL

/*********************************************************/

// clears all wPaint objects from window nWinNum
// if nObjNum specified, clears object >= nObjNum
FUNCTION wg_ResetWPaintObj( nWinNum, nObjNum, lStrict )

   nObjNum = 0
   lStrict = .F.

   DO WHILE Len( s_aPObjList ) < nWinNum + 1
      AAdd( s_aPObjList, {} )
   ENDDO

   ASize( s_aPObjList[ nWinNum + 1 ], nObjNum )

   RETURN .T.

// adds a WPaint object oWPaint into window nWinNum
// returns ::cId if successful. "" if failed.
FUNCTION wg_AddWPaintObj( nWinNum, oWPaint, lStrict, nOperation )

   LOCAL i

   lStrict = .F.
   nOperation = WOBJ_ADD_OVERWRITE

   // simplified:
   nOperation := WOBJ_ADD_OVERWRITE

   // parameter checking...
   // ...

   // exist nType + cId ?
   i := AScan( s_aPObjList[ nWinNum + 1 ], {| x | x:nType == oWPaint:nType .AND. x:cId == oWPaint:cId } )

   IF i > 0
      // so we are about to overwrite now...
      // ::Hide() is ideal, but it can be slow
      // let's do it only of user want strict/perfect operation
      IF lStrict
         s_aPObjList[ nWinNum + 1 ][ i ]:Hide()
      ELSE
         s_aPObjList[ nWinNum + 1 ][ i ]:lVisible := .F.
      ENDIF
      s_aPObjList[ nWinNum + 1 ][ i ] := oWPaint

   ELSE
      AAdd( s_aPObjList[ nWinNum + 1 ], oWPaint )
   ENDIF

   // if it is visible, draw it now!
   IF oWPaint:lVisible
      oWPaint:draw()
   ENDIF

   RETURN oWPaint:cId // 20040811 was .T.

// deletes a WPaint object oWPaint from window nWinNum
// returns number of object deleted.
//
// NOTE: if cId is NIL, delete all object of type nType
FUNCTION wg_DelWPaintObj( nWinNum, nType, cId, lStrict )

   LOCAL i
   LOCAL lDelAll := ( cId == NIL )
   LOCAL nDeleted := 0
   LOCAL nLen

   lStrict = .F.

   // is nType set?
   IF nType < 1
      RETURN nDeleted
   ENDIF

   // exist nType + cId ?
   i := 1
   nLen := Len( s_aPObjList[ nWinNum + 1 ] )
   DO WHILE i <= nLen
      IF s_aPObjList[ nWinNum + 1 ][ i ]:nType == nType .AND. ;
         ( lDelAll .OR. s_aPObjList[ nWinNum + 1 ][ i ]:cId == cId )
         IF lStrict
            s_aPObjList[ nWinNum + 1 ][ i ]:Hide()
         ELSE
            s_aPObjList[ nWinNum + 1 ][ i ]:lVisible := .F.
         ENDIF
         ADel( s_aPObjList[ nWinNum + 1 ], i )
         ASize( s_aPObjList[ nWinNum + 1 ], --nLen )
         nDeleted++
      ELSE
         i++
      ENDIF
   ENDDO

   RETURN nDeleted




/*
 * $Id$
 */

/*
  copyright (c) Budyanto Dj. <budyanto@centrin.net.id>

  Editbox demo
  multi-field GET session(s) using editboxes
  with a simple sample of @...EBGET command translation

  This sample also shows simple implementation of WVW_INPUTFOCUS
  to handle some keyboard inputs on non topmost window

  (The editbox itself always accept input independent of WVW_INPUTFOCUS)

  Some parts of this sample are modifications from MINIGUI's sourcecode
  to handle "masks" during editbox input session:
    ProcessCharMask()
    CharMaskTekstOK()
    GetValFromText()
    GetNumMask()

 */

#include "inkey.ch"
#include "setcurs.ch"

#define EN_SETFOCUS         0x0100
#define EN_KILLFOCUS        0x0200
#define EN_CHANGE           0x0300
#define EN_UPDATE           0x0400
#define EN_ERRSPACE         0x0500
#define EN_MAXTEXT          0x0501
#define EN_HSCROLL          0x0601
#define EN_VSCROLL          0x0602

#define WM_KEYFIRST                     0x0100
#define WM_KEYDOWN                      0x0100
#define WM_KEYUP                        0x0101
#define WM_CHAR                         0x0102
#define WM_DEADCHAR                     0x0103
#define WM_SYSKEYDOWN                   0x0104
#define WM_SYSKEYUP                     0x0105
#define WM_SYSCHAR                      0x0106
#define WM_SYSDEADCHAR                  0x0107
#define WM_KEYLAST                      0x0108
#define WM_INITDIALOG                   0x0110
#define WM_COMMAND                      0x0111
#define WM_SYSCOMMAND                   0x0112
#define WM_TIMER                        0x0113
#define WM_HSCROLL                      0x0114
#define WM_VSCROLL                      0x0115
#define WM_INITMENU                     0x0116
#define WM_INITMENUPOPUP                0x0117
#define WM_MENUSELECT                   0x011F
#define WM_MENUCHAR                     0x0120
#define WM_ENTERIDLE                    0x0121

#command @ <row>, <col> EBGET <var>                                       ;
      [LABEL <label>]                                   ;
      [<multiline: MULTILINE>]                        ;
      [PICTURE <pic>]                                 ;
      ;
      => AddEBGet( aEBGets, <row>, <col>, @<var>, <"var">, {| x | <var> := x }, <label>, <.multiline.>, <pic> )

// ***************************
// constants to aEBGets member,
// according to EBReadGets() convention
// NOTE: a smarter way would be to use CLASS instead of arrays
// ***************************
#define __GET_LMULTILINE 1
#define __GET_CLABEL 2
#define __GET_NROW   3
#define __GET_NCOL   4
#define __GET_XINIT  5
#define __GET_CPICT  6
#define __GET_CVALTYPE  7
#define __GET_BTEXT   8
#define __GET_BASSIGN 9
#define __GET_NEBID  10
#define __GET_LFOCUSED  11

// REQUEST HB_NOSTARTUPWINDOW

PROCEDURE edbox()

   LOCAL lClosepermitted := .F.
   LOCAL bSetKey := SetKey( K_F8, {|| MyHelp() } )

#if defined( __HBSCRIPT__HBSHELL ) .AND. defined( __PLATFORM__WINDOWS )
   hbshell_gtSelect( "GTWVW" )
#endif

   Set( _SET_DATEFORMAT, "yyyy-mm-dd" )
//   SetMode( 4, 54 )   // a small window
   SetColor( "N/W" )
//   wvw_SetFont( 0, "Courier New", 16, - 7 )
   wvw_ebSetFont( 0, "Arial" )  // font for editbox
   wvw_pbSetFont( 0, "Arial" )  // font for pushbuttons

   wvw_SetCodepage( 0, 255 )
   wvw_AllowNonTopEvent( .T. )   // this will make pushbuttons to work
   // even on non-topmost window
   wvw_RecurseCBlock( .T. ) // this will allow recursed execution
   // of control's codeblocks
   // eg. multiple executions of pushbutton's codeblock
   //    invoking "GetSession()"

   SetCursor( SC_NONE ) // we don't need cursor

   CLS
   @ 0, 1 SAY "Click NEW to open a new GET session, CLOSE when done"
   wvw_pbCreate( 0, 2, 1, 2, 10, "New", NIL, {|| GetSession() } )
   wvw_pbCreate( 0, 2, 12, 2, 22, "Close", NIL, {|| ToCloseWindow( 0, @lClosepermitted ) } )

   // activate/show the main window
   wvw_ShowWindow( 0 )

   // wait until user click the close button
   DO WHILE ! lClosepermitted
      Inkey( 0.2 )
   ENDDO
   SetKey( K_F8, bSetKey )

   RETURN

// This is the sample of a GET session.
// This sample is reentrant, can be executed more than once if user clicks
// "NEW" button in the main window multiple times.
PROCEDURE GetSession()

   STATIC s_nsession := 0
   LOCAL aEBGets := {}
   LOCAL cName      := Space( 30 )
   LOCAL cNickName  := Space( 10 )
   LOCAL dBirthdate := date() // hb_SToD()
   LOCAL nBudget    := 125000
   LOCAL cRemark    := "Some notes" + chr(13) + ;
      "about this person"
   LOCAL nwinnum
   LOCAL nrow1, ncol1, nrow2, ncol2
   LOCAL cdebugreport

   IF s_nsession > 15
      MyMessageBox( 0, "Sorry, maximum number of sessions reached" )
      RETURN
   ENDIF

   s_nsession++
   nwinnum := s_nsession

   nrow1 := 4// + ( s_nsession - 1 ) * 1
   ncol1 := 10// + ( s_nsession - 1 ) * 2
   nrow2 := nrow1 + 15
   ncol2 := ncol1 + 60
   wvw_nOpenWindow( "Session " + hb_ntos( s_nsession ) + " (press F8 for help)", ;
      nrow1, ncol1, nrow2, ncol2, NIL, 0 )

   cRemark += hb_eol() + "(from Session " + hb_ntos( nwinnum ) + ")"

   @ 1, 15 ebGET cName      LABEL "Name:"
   @ 3, 15 ebGET cNickName  LABEL "Nickname:"   PICTURE Replicate( "!", Len( cNickName ) )
   @ 5, 15 ebGET dBirthDate LABEL "Birth Date:"
   @ 7, 15 ebGET nBudget    PICTURE "999,999.99"   // using default label
   @ 9, 15 ebGET cRemark    LABEL "Remarks:" MULTILINE
   EBReadGets( nwinnum, @aEBGets )   // READ

   // debugging text
   cdebugreport := "Back to GetSession() of window " + hb_ntos( nwinnum ) + " with these values returned:" + hb_eol()
   cdebugreport += "cName:" + cName + hb_eol()
   cdebugreport += "cNickName:" + cNickName + hb_eol()
   cdebugreport += "dBirthDate:" + DToC( dBirthDate ) + hb_eol()
   cdebugreport += "nBudget:" + Transform( nBudget, "999,999.99" ) + hb_eol()
   cdebugreport += "cRemark:" + cRemark
   MyMessageBox( nwinnum, cdebugreport )

   wvw_lCloseWindow()

   s_nsession--

   RETURN

FUNCTION MyHelp()

   LOCAL ccallstack, i

   ccallstack := ""
   FOR i := 0 TO 8
      ccallstack += hb_ntos( i ) + ". " + ProcName( i ) + "(" + hb_ntos( ProcLine( i ) ) + ")" + hb_eol()
   NEXT

   MyMessageBox( NIL, ;
      "Sorry, this is not really a help :-)" + hb_eol() + ;
      "It is only to show that SetKey() codeblock is handled by our editboxes" + hb_eol() + ;
      "Call stack:" + chr(13) + ;
      ccallstack )

   RETURN NIL

FUNCTION WVW_SETFOCUS( nWinNum, hWnd )

   IF nwinnum != 0
      wvw_nSetCurWindow( nwinnum )
   ENDIF

   RETURN NIL

/******************************************************
 Typical application ends here.
 Below are EBReadGets() and its supporters that are
 usable for general needs
 (can be put into separated module)
 ******************************************************/

// 20070525

// adding one EBGet variable into aEBGets array
// returns .T. if successful
FUNCTION AddEBGet( aEBGets, mnrow, mncol, mxValue, mcVarName, mbAssign, mcLabel, mlMultiline, mcPict )

   LOCAL mcVarType, mbText

   mcVarType := ValType( mxValue )
   DO CASE
   CASE mcVarType == "C"
      mcPict := iif( HB_ISSTRING( mcPict ), mcPict, Replicate( "X", Len( mxValue ) ) )
      mbText := {|| mxValue }
   CASE mcVarType == "N"
      mcPict := iif( HB_ISSTRING( mcPict ), mcPict, "999,999,999.99" )
      mbText := {|| Transform( mxValue, mcPict ) }
   CASE mcVarType == "D"
      mcPict := iif( HB_ISSTRING( mcPict ), mcPict, "9999-99-99" )
      mbText := {|| DToC( mxValue ) }
   OTHERWISE
      // unsupported valtype
      RETURN .F.
   ENDCASE

   aEBGEts = {}

   IF ! HB_ISLOGICAL( mlMultiline ) .OR. ;
      ! HB_ISSTRING( mxValue )
      mlMultiline := .F.
   ENDIF
   mcLabel = mcVarName + ":"

   AAdd( aEBGets, { ;
      mlMultiline, ;    // __GET_LMULTILINE
      mcLabel, ;        // __GET_CLABEL
      mnrow, ;          // __GET_NROW
      mncol, ;          // __GET_NCOL
      mxValue, ;        // __GET_XINIT
      mcPict, ;         // __GET_CPICT
      mcVarType, ;      // __GET_CVALTYPE
      mbText, ;         // __GET_BTEXT
      mbAssign, ;       // __GET_BASSIGN
      NIL, ;            // __GET_NEBID
      .F. } )           // __GET_LFOCUSED

   RETURN .T.

// generic procedure to run aEBGets, array of editboxes
PROCEDURE EBReadGets( nwinnum, aEBGets )

   LOCAL nmaxrow, nmincol
   LOCAL i, nlen, lmultiline, clabel, ;
      nrow1, ncol1, nrow2, ncol2
   LOCAL nOKbutton, nCancelbutton, nClosebutton, ldone := .F.
   LOCAL lclosePermitted := .F.
   LOCAL nNumGets := Len( aEBGets )
   LOCAL ch
   LOCAL nfocus, lchangefocus

   IF nNumGets == 0
      RETURN
   ENDIF

   wvw_nSetCurWindow( nwinnum )
   nmaxrow := 0
   nmincol := 99999
   FOR i := 1 TO nNumGets
      lmultiline := aEBGets[ i ][ __GET_LMULTILINE ]
      IF ! lmultiline
         nlen := Len( aEBGets[ i ][ __GET_CPICT ] )
      ELSE
         nlen := 30
      ENDIF
      clabel := aEBGets[ i ][ __GET_CLABEL ]
      nrow1 := aEBGets[ i ][ __GET_NROW ]
      ncol1 := aEBGets[ i ][ __GET_NCOL ]
      nrow2 := iif( aEBGets[ i ][ __GET_LMULTILINE ], nrow1 + 3, nrow1 )
      ncol2 := ncol1 + nlen - 1

      @ nrow1, ncol1 - Len( clabel ) - 1 SAY clabel

      aEBGets[ i ][ __GET_NEBID ] := wvw_ebCreate( nwinnum, nrow1, ncol1, nrow2, ncol2, ;
         Transform( aEBGets[ i ][ __GET_XINIT ], aEBGets[ i ][ __GET_CPICT ] ), ;
         {| nWinNum, nId, nEvent | MaskEditBox( nWinNum, nId, nEvent, @aEBGets ) }, ;
         aEBGets[ i ][ __GET_LMULTILINE ], ;  // EBtype
      0, ;  // nmorestyle
      iif( lmultiline, NIL, nlen + 1 ), ; // nMaxChar
      NIL, NIL )

      nmaxrow := Max( nmaxrow, nrow2 )
      nmincol := Min( nmincol, ncol1 )
   NEXT
   nrow1 := nmaxrow + 2 // Min(nmaxrow+2, MaxRow())
   ncol1 := nmincol // Min(nmincol, MaxCol()-33)
   nOKbutton := wvw_pbCreate( nwinnum, nrow1, ncol1, nrow1, ncol1 + 10 - 1, "OK", NIL, ;
      {|| SaveVar( nwinnum, @aEBGets, @lDone ), ;
      EndGets( nwinnum, @aEBGets, nOKbutton, nCancelbutton, nCloseButton );
      } )

   ncol1 := ncol1 + 10 + 1
   nCancelbutton := wvw_pbCreate( nwinnum, nrow1, ncol1, nrow1, ncol1 + 10 - 1, "Cancel", NIL, ;
      {|| CancelVar( nwinnum, @aEBGets, @lDone ), ;
      EndGets( nwinnum, @aEBGets, nOKbutton, nCancelbutton, nCloseButton );
      } )

   ncol1 := ncol1 + 10 + 1
   nClosebutton := wvw_pbCreate( nwinnum, nrow1, ncol1, nrow1, ncol1 + 10 - 1, "Close", NIL, ;
      {|| ToCloseWindow( nwinnum, @lClosepermitted ) } )
   wvw_pbEnable( nwinnum, nclosebutton, .F. )

   // register a keyhandler for WVW_INPFOCUS
   inp_handler( nwinnum, {| n, ch | InpKeyHandler( n, ch, aEBGets, nOKbutton, nCancelbutton ) } )

   wvw_ebSetFocus( nwinnum, aEBGets[ 1 ][ __GET_NEBID ] )
   nFocus := 1
   ch := Inkey( 0.5 )
   DO WHILE ! lDone
      IF HB_ISBLOCK( SetKey( ch ) )
         Eval( SetKey( ch ) )
      ELSEIF ch != 0
         lchangefocus := .T.
         DO CASE
         CASE ch == K_TAB .OR. ch == K_DOWN .OR. ch == K_ENTER
            IF nFocus < ( nNumGets + 2 )  // incl buttons
               nFocus++
            ELSE
               nFocus := 1
            ENDIF
         CASE ch == K_SH_TAB .OR. ch == K_UP
            IF nFocus > 1
               nFocus--
            ELSE
               nFocus := nNumGets + 2
            ENDIF
         OTHERWISE
            lchangefocus := .F. // ! wvw_ebIsFocused(nwinnum, aEBGets[nFocus][__GET_NEBID])
         ENDCASE
         IF lchangefocus
            IF nFocus <= nNumGets
               wvw_ebSetFocus( nwinnum, aEBGets[ nFocus ][ __GET_NEBID ] )
            ELSEIF nFocus == nNumGets + 1
               wvw_pbSetFocus( nwinnum, nOKbutton )
            ELSEIF nFocus == nNumGets + 2
               wvw_pbSetFocus( nwinnum, nCancelbutton )
            ENDIF
         ENDIF
      ENDIF
      IF wvw_pbIsFocused( nwinnum, nOKbutton )
         nFocus := nNumGets + 1
      ELSEIF wvw_pbIsFocused( nwinnum, nCancelbutton )
         nFocus := nNumGets + 2
      ELSE
         nFocus := nFocused( aEBGets )
      ENDIF
      ch := Inkey( 0.5 )
   ENDDO

   // session ended (already ended by OK or Cancel)

   lClosepermitted := ( nwinnum == wvw_nNumWindows() - 1 )
   // wait until user click the close button
   DO WHILE ! lClosepermitted
      Inkey( 0.5 )
   ENDDO

   RETURN // EBReadGets()

// inp_handler(nwinnum, bhandler)

STATIC PROCEDURE InpKeyHandler( nwinnum, ch, aEBGets, nOKbutton, nCancelbutton )

   LOCAL nNumGets := Len( aEBGets )
   LOCAL nFocus, lchangefocus

   IF HB_ISBLOCK( SetKey( ch ) )
      Eval( SetKey( ch ) )
      RETURN
   ELSEIF ch == 0
      RETURN
   ENDIF
   IF wvw_pbIsFocused( nwinnum, nOKbutton )
      nFocus := nNumGets + 1
   ELSEIF wvw_pbIsFocused( nwinnum, nCancelbutton )
      nFocus := nNumGets + 2
   ELSE
      nFocus := nFocused( aEBGets )
   ENDIF
   lchangefocus := .T.
   DO CASE
   CASE ch == K_TAB .AND. ! lShiftPressed()
      IF nFocus < ( nNumGets + 2 )  // incl buttons
         nFocus++
      ELSE
         nFocus := 1
      ENDIF
   CASE ch == K_TAB .AND. lShiftPressed()
      IF nFocus > 1
         nFocus--
      ELSE
         nFocus := nNumGets + 2
      ENDIF
   OTHERWISE
      lchangefocus := .F.
   ENDCASE
   IF lchangefocus
      IF nFocus <= nNumGets
         wvw_ebSetFocus( nwinnum, aEBGets[ nFocus ][ __GET_NEBID ] )
      ELSEIF nFocus == nNumGets + 1
         wvw_pbSetFocus( nwinnum, nOKbutton )
      ELSEIF nFocus == nNumGets + 2
         wvw_pbSetFocus( nwinnum, nCancelbutton )
      ENDIF
   ENDIF

   RETURN  // InpKeyHandler()

STATIC PROCEDURE EndGets( nwinnum, aEBGets, nOKbutton, nCancelbutton, nCloseButton )

   LOCAL i

   // session ended
   FOR i := 1 TO Len( aEBGets )
      wvw_ebEnable( nwinnum, aEBGets[ i ][ __GET_NEBID ], .F. )
   NEXT
   wvw_pbEnable( nwinnum, nOKbutton, .F. )
   wvw_pbEnable( nwinnum, nCancelbutton, .F. )

   // clear the getlist
   ASize( aEBGets, 0 )

   // wait until user click the close button
   wvw_pbEnable( nwinnum, nclosebutton, .T. )

   RETURN

// save values into variables
STATIC PROCEDURE SaveVar( nwinnum, aEBGets, lDone )

   LOCAL i, cdebugreport

   FOR i := 1 TO Len( aEBGets )
      // do some validation if necessary
      Eval( aEBGets[ i ][ __GET_BASSIGN ], ;
         GetValFromText( wvw_ebGetText( nwinnum, aEBGets[ i ][ __GET_NEBID ] ), aEBGets[ i ][ __GET_CVALTYPE ] ) )
   NEXT
   lDone := .T.

   // debugging text
   cdebugreport := "Get session in window " + hb_ntos( nwinnum ) + " is ended with confirmation" + hb_eol() + ;
      "Values have been assigned to the respective ebGET variables"
   MyMessageBox( nwinnum, cdebugreport )

   RETURN

// restore initial values into variables
STATIC PROCEDURE CancelVar( nwinnum, aEBGets, lDone )

   LOCAL i, cdebugreport

   FOR i := 1 TO Len( aEBGets )
      Eval( aEBGets[ i ][ __GET_BASSIGN ], ;
         aEBGets[ i ][ __GET_XINIT ] )
   NEXT
   lDone := .T.

   // debugging text
   cdebugreport := "Get session in window " + hb_ntos( nwinnum ) + " is ended with cancellation" + hb_eol() + ;
      "Values has been assigned to the respective initial ebGET variables"
   MyMessageBox( nwinnum, cdebugreport )

   RETURN

STATIC PROCEDURE ToCloseWindow( nwinnum, lPermitted )

   // allow to close topmost window only
   lPermitted := ( nwinnum == wvw_nNumWindows() - 1 )
   IF ! lpermitted
      MyMessageBox( nwinnum, "Window " + hb_ntos( nwinnum ) + " is not allowed to be closed, yet" + hb_eol() + ;
         "Please close window " + hb_ntos( wvw_nNumWindows() - 1 ) + " first" )
   ENDIF

   RETURN

// returns index to aEBGets array containing editbox nEBid

STATIC FUNCTION nGetIndex( aEBGets, nEBId )

   RETURN AScan( aEBGets, {| x | x[ __GET_NEBID ] == nEBId } )

// returns index to aEBGets array containing editbox that is/was in focus

STATIC FUNCTION nFocused( aEBGets )

   RETURN AScan( aEBGets, {| x | x[ __GET_LFOCUSED ] } )

// callback function called by GTWVW during some events on editbox
STATIC FUNCTION MaskEditBox( nWinNum, nId, nEvent, aEBGets )

   STATIC s_bBusy := .F.
   LOCAL ctext
   LOCAL nIndex := nGetIndex( aEBGets, nId )
   LOCAL mcvaltype, mcpict, mlmultiline
   LOCAL nwasfocus

   IF s_bBusy
      RETURN NIL
   ENDIF
   IF nIndex == 0
      RETURN NIL
   ENDIF
   s_bBusy := .T.
   mcvaltype := aEBGets[ nIndex ][ __GET_CVALTYPE ]
   mcpict := aEBGets[ nIndex ][ __GET_CPICT ]
   mlmultiline := aEBGets[ nIndex ][ __GET_LMULTILINE ]

   DO CASE
   CASE nEvent == EN_KILLFOCUS
      IF ! mlmultiline .AND. mcvaltype $ "ND"
         ctext := wvw_ebGetText( nwinnum, nid )
         IF mcvaltype == "D" .AND. IsBadDate( ctext )
            // don't leave it in an invalid state
            wvw_ebSetFocus( nwinnum, nid )
         ELSE
            wvw_ebSetText( nwinnum, nId, Transform( GetValFromText( ctext, mcvaltype ), mcpict ) )
         ENDIF
      ENDIF
   CASE nEvent == EN_SETFOCUS
      IF ! mlmultiline .AND. mcvaltype == "N"
         ctext := wvw_ebGetText( nwinnum, nid )
         wvw_ebSetText( nwinnum, nId, Transform( GetValFromText( ctext, mcvaltype ), GetNumMask( mcpict, mcvaltype ) ) )
      ENDIF
      wvw_ebSetSel( nwinnum, nid, 0, -1 )
      nwasFocus := nFocused( aEBGets )
      IF nwasFocus != 0
         aEBGets[ nwasFocus ][ __GET_LFOCUSED ] := .F.
      ENDIF
      aEBGets[ nIndex ][ __GET_LFOCUSED ] := .T.
   CASE nEvent == EN_CHANGE
      IF ! mlmultiline
         ProcessCharMask( nwinnum, nId, mcvaltype, mcpict )
      ENDIF
   ENDCASE
   s_bBusy := .F.

   RETURN NIL

/************* borrowed and modified from minigui *************/

// from h_textbox.prg

STATIC PROCEDURE ProcessCharMask( mnwinnum, mnebid, mcvaltype, mcpict )

   LOCAL InBuffer, OutBuffer := "", icp, x, CB, CM, BadEntry, InBufferLeft, InBufferRight, Mask, OldChar, BackInbuffer
   LOCAL pc
   LOCAL fnb := 0
   LOCAL dc := 0
   LOCAL pFlag
   LOCAL ncp
   LOCAL NegativeZero := .F.
   LOCAL Output
   LOCAL ol

   IF mcvaltype == "N"
      Mask := GetNumMask( mcpict, mcvaltype )
   ELSEIF mcvaltype == "D"
      Mask := mcpict // "9999-99-99"
   ELSE
      Mask := mcpict
   ENDIF

   // Store Initial CaretPos
   wvw_ebGetSel( mnwinnum, mnebid, NIL, @icp )

   // Get Current Content
   InBuffer := wvw_ebGetText( mnwinnum, mnebid )

   pc := 0 // x for clarity
   pFlag := .F. // x for clarity
   IF mcvaltype == "N"
      // RL 104
      IF Left( AllTrim( InBuffer ), 1 ) == "-" .AND. Val( InBuffer ) == 0
         NegativeZero := .T.
      ENDIF

      IF PCount() > 1
         // Point Count For Numeric InputMask
         FOR x := 1 TO Len( InBuffer )
            CB := SubStr( InBuffer, x, 1 )
            IF CB == "." .OR. CB == ","
               pc++
            ENDIF
         NEXT

         // RL 89
         IF Left( InBuffer, 1 ) == "." .OR. Left( InBuffer, 1 ) == ","
            pFlag := .T.
         ENDIF

         // Find First Non-Blank Position
         FOR x := 1 TO Len( InBuffer )
            CB := SubStr( InBuffer, x, 1 )
            IF !( CB == " " )
               fnb := x
               EXIT
            ENDIF
         NEXT
      ENDIF
   ENDIF

   BackInBuffer := InBuffer

   OldChar := SubStr( InBuffer, icp + 1, 1 )

   IF Len( InBuffer ) < Len( Mask )
      InBufferLeft := Left( InBuffer, icp )

      InBufferRight := Right( InBuffer, Len( InBuffer ) - icp )

      IF CharMaskTekstOK( InBufferLeft + " " + InBufferRight, mcvaltype, Mask ) .AND. ;
         ! CharMaskTekstOK( InBufferLeft + InBufferRight, mcvaltype, Mask )
         InBuffer := InBufferLeft + " " + InBufferRight
      ELSE
         InBuffer := InBufferLeft + InBufferRight
      ENDIF
   ENDIF

   IF Len( InBuffer ) > Len( Mask ) .AND. ;
         Len( Mask ) > 0

      InBufferLeft := Left( InBuffer, icp )

      InBufferRight := Right( InBuffer, Len( InBuffer ) - icp - 1 )

      InBuffer := InBufferLeft + InBufferRight
   ENDIF

   // Process Mask
   OutBuffer := "" // x for clarity
   BadEntry := .F. // x for clarity
   FOR x := 1 TO Len( Mask )
      CB := SubStr( InBuffer, x, 1 )
      CM := SubStr( Mask, x, 1 )

      DO CASE
      CASE CM == "A" .OR. CM == "!"
         IF IsAlpha( CB ) .OR. CB == " "
            IF CM == "!"
               OutBuffer := OutBuffer + Upper( CB )
            ELSE
               OutBuffer := OutBuffer + CB
            ENDIF
         ELSE
            IF x == icp
               BadEntry := .T.
               OutBuffer := OutBuffer + OldChar
            ELSE
               OutBuffer := OutBuffer + " "
            ENDIF
         ENDIF

      CASE CM == "9"
         IF IsDigit( CB ) .OR. CB == " " .OR. ;
            ( mcvaltype == "N" .AND. ; // x
            CB == "-" .AND. x == fnb .AND. PCount() > 1 )

            OutBuffer := OutBuffer + CB
         ELSE
            IF x == icp
               BadEntry := .T.
               OutBuffer := OutBuffer + OldChar
            ELSE
               OutBuffer := OutBuffer + " "
            ENDIF
         ENDIF

      CASE CM == " "
         IF CB == " "
            OutBuffer := OutBuffer + CB
         ELSE
            IF x == icp
               BadEntry := .T.
               OutBuffer := OutBuffer + OldChar
            ELSE
               OutBuffer := OutBuffer + " "
            ENDIF
         ENDIF

         // x
      CASE CM == "X"
         OutBuffer := OutBuffer + CB

      OTHERWISE
         OutBuffer := OutBuffer + CM

      ENDCASE
   NEXT

   // Replace Content
   IF ! ( BackInBuffer == OutBuffer )
      wvw_ebSetText( mnwinnum, mnebid, OutBuffer )
   ENDIF

   IF pc > 1
      // pc>1 means we must to JUMP to the decimal point

      // RL 104
      IF NegativeZero
         Output := Transform( GetValFromText( wvw_ebGetText( mnwinnum, mnebid ), mcvaltype ), Mask )

         // x better:
         ol := Len( Output )
         Output := PadL( "-" + SubStr( Output, At( ".", OutBuffer ) - 1 ), ol )

         // Replace Text
         wvw_ebSetText( mnwinnum, mnebid, Output )
         wvw_ebSetSel( mnwinnum, mnebid, At( ".", OutBuffer ) + dc, At( ".", OutBuffer ) + dc )
      ELSE
         wvw_ebSetText( mnwinnum, mnebid, Transform( GetValFromText( wvw_ebGetText( mnwinnum, mnebid ), mcvaltype ), Mask ) )
         wvw_ebSetSel( mnwinnum, mnebid, At( ".", OutBuffer ) + dc, At( ".", OutBuffer ) + dc )
      ENDIF

   ELSE
      IF pFlag
         ncp := At( ".", wvw_ebGetText( mnwinnum, mnebid ) )
         wvw_ebSetSel( mnwinnum, mnebid, ncp, ncp )
      ELSE
         // Restore Initial CaretPos
         IF BadEntry
            icp--
         ENDIF

         wvw_ebSetSel( mnwinnum, mnebid, icp, icp )

         // Skip Protected Characters
         FOR x := 1 TO Len( OutBuffer )
            CB := SubStr( OutBuffer, icp + x, 1 )
            CM := SubStr( Mask, icp + x, 1 )

            IF ! IsDigit( CB ) .AND. ! IsAlpha( CB ) .AND. ;
               ( !( CB == " " ) .OR. ( CB == " " .AND. CM == " " ) )
               wvw_ebSetSel( mnwinnum, mnebid, icp + x, icp + x )
            ELSE
               EXIT
            ENDIF
         NEXT
      ENDIF
   ENDIF

   RETURN

// from h_textbox.prg

STATIC FUNCTION CharMaskTekstOK( cString, cvaltype, cMask )

   // LOCAL lPassed := .T.
   LOCAL CB, CM, x

   IF cvaltype == "D"
      FOR x := 1 TO Min( Len( cString ), Len( cMask ) )
         CB := SubStr( cString, x, 1 )
         CM := SubStr( cMask, x, 1 )
         DO CASE
         CASE CM == "9"
            IF IsDigit( CB ) .OR. CB == " "
               // lPassed:=.T.
            ELSE
               RETURN .F.
            ENDIF
         OTHERWISE
            // lPassed:=.T.
         ENDCASE
      NEXT
      RETURN .T.
   ENDIF

   FOR x := 1 TO Min( Len( cString ), Len( cMask ) )
      CB := SubStr( cString, x, 1 )
      CM := SubStr( cMask, x, 1 )
      DO CASE
         // JK
      CASE CM == "A" .OR. CM == "!"
         IF IsAlpha( CB ) .OR. CB == " "
            // lPassed := .T.
         ELSE
            RETURN .F.
         ENDIF
      CASE CM == "9"
         IF IsDigit( CB ) .OR. CB == " "
            // lPassed := .T.
         ELSE
            RETURN .F.
         ENDIF
      CASE CM == " "
         IF CB == " "
            // lPassed := .T.
         ELSE
            RETURN .F.
         ENDIF
      OTHERWISE
         // lPassed := .T.
      ENDCASE
   NEXT

   RETURN .T. // lPassed

// from h_textbox.prg

STATIC FUNCTION GetValFromText( Text, mcvaltype )

   // eg. GetValFromText( "999,999.99" ) --> 999999.99
   LOCAL x, c, s

   IF mcvaltype == "C"
      RETURN TEXT
   ENDIF

   IF mcvaltype == "D"
      s := CToD( Text )
      RETURN s
   ENDIF

   // ASSUME numeric
   s := ""
   FOR x := 1 TO Len( Text )
      c := SubStr( Text, x, 1 )
      IF c $ "0123456789" .OR. c $ ".-"
         s += c
      ENDIF
   NEXT

   IF Left( AllTrim( Text ), 1 ) == "(" .OR.  Right( AllTrim( Text ), 2 ) == "DB"
      s := "-" + s
   ENDIF

   // useless!
   // s := Transform( Val( s ), Getnummask( s_cmask, mcvaltype ) )

   RETURN Val( s )

// from h_textbox.prg

STATIC FUNCTION GetNumMask( Text, mcvaltype )

   // eg. GetNumMask( "999,999.99" ) --> "999999.99"
   LOCAL i, c, s

   IF mcvaltype == "D" .OR. mcvaltype == "C"
      s := Text
      RETURN s
   ENDIF

   s := ""
   FOR i := 1 TO Len( Text )
      c := SubStr( Text, i, 1 )
      IF c == "9" .OR. c == "."
         s += c
      ENDIF
      IF c == "$" .OR. c == "*"
         s += "9"
      ENDIF
   NEXT

   RETURN s

// from tget.prg

STATIC FUNCTION IsBadDate( cBuffer ) // , cPicFunc )

   LOCAL cBuffer2

   IF Empty( cBuffer )
      RETURN .F.
   ENDIF

#if 0
   IF "E" $ cPicFunc
      cBuffer := InvertDwM( cBuffer )
   ENDIF
#endif

   cBuffer2 := StrTran( cBuffer, "/" )
   cBuffer2 := StrTran( cBuffer2, "-" )
   cBuffer2 := StrTran( cBuffer2, "." )

   IF Empty( cBuffer2 )
      RETURN .F.
   ENDIF

   IF Empty( CToD( cBuffer ) )
      MyMessageBox( NIL, "'" + cBuffer + "' is not a valid DATE" )
      RETURN .T.
   ENDIF

   RETURN .F.

/************ WVW_INPUTFOCUS ************/

// this is a simple sample of WVW_INPUTFOCUS
// only handles WM_CHAR, thus not all input characters are accepted
FUNCTION WVW_INPUTFOCUS( nWinNum, hWnd, message, wParam, lParam )

   LOCAL ch
   LOCAL bhandler

  // HB_SYMBOL_UNUSED( hWnd )
 //  HB_SYMBOL_UNUSED( wParam )
  // HB_SYMBOL_UNUSED( lParam )

   // did user perform a menu/toolbar action on Main Window?
#if 0
   IF message == WM_COMMAND .AND. nWinNum == 0  // menu,toolbar,pushbutton
      RETURN .F.
   ENDIF
#endif

   // now we handle input on other non-topmost windows

   DO CASE
   CASE message == WM_CHAR
      ch := wParam
      bhandler := inp_handler( nWinNum )
      IF HB_ISBLOCK( bhandler )
         Eval( bhandler, nWinNum, ch )
         RETURN .T.
      ELSE
         RETURN .F.
      ENDIF
   OTHERWISE
      // ignore
      RETURN .T.
   ENDCASE

   RETURN .F. // WVW_INPUTFOCUS()

FUNCTION inp_handler( nwinnum, bhandler )

   STATIC s_bhandlers := {}
   LOCAL retval := iif( Len( s_bhandlers ) >= nwinnum + 1, s_bhandlers[ nwinnum + 1 ], NIL )

   IF HB_ISBLOCK( bhandler )
      IF Len( s_bhandlers ) < nwinnum + 1
         ASize( s_bhandlers, nwinnum + 1 )
      ENDIF
      s_bhandlers[ nwinnum + 1 ] := bhandler
   ENDIF

   RETURN retval

/********** general helpers ************/

STATIC FUNCTION MyMessageBox( nwinnum, cMessage, cCaption, nFlags )

   LOCAL nParent

   cCaption = "Debug Message"
   nParent := wvw_GetWindowHandle( nwinnum )

   RETURN win_MessageBox( nParent, cMessage, cCaption, nFlags )

#define VK_SHIFT            16

STATIC FUNCTION lShiftPressed()
   RETURN GetKeyState( VK_SHIFT ) < 0

function hb_eol()
  return chr(13)
  



***********************************************************************************************************************************
***********************************************************************************************************************************
***********************************************************************************************************************************
***********************************************************************************************************************************

/*
 * $Id$
 */

/*
   sample on using Maximize Mode in gtwvw.
   budyanto@centrin.net.id
 */

#include "inkey.ch"

// this dimension will be used when user presses RESTORE button

PROCEDURE MAXI()

#if defined( __HBSCRIPT__HBSHELL ) .AND. defined( __PLATFORM__WINDOWS )
   hbshell_gtSelect( "GTWVW" )
#endif

   // activate WVW_SIZE()
   s_lSizeReady := .T.

   // the biggest possible window
   SetColor( "N/W" )
   SetMode( wvw_MaxMaxRow() + 1, wvw_MaxMaxCol() + 1 )

   // enable MAXIMIZE button
   wvw_EnableMaximize( 0, .T. )

   // set the window to MAXIMIZED state
   wvw_Maximize( 0 )

   updatescr()
   DO WHILE Inkey( 0 ) != K_ESC
      // refresh screen, probably in a new dimension
      // (You may alternatively call updatescr() from WVW_SIZE instead)
      updatescr()
   ENDDO

   RETURN

PROCEDURE diminfo()

   @ 0, 0 SAY "Window size: " + hb_ntos( MaxRow() + 1 ) + " x " + hb_ntos( MaxCol() + 1 ) + "   "

   RETURN

PROCEDURE updatescr()

   LOCAL i

   CLS
   FOR i := 0 TO MaxCol()
      @ 0, i SAY "T"
   NEXT
   FOR i := 0 TO MaxRow()
      @ i, 0 SAY "L"
   NEXT
   FOR i := 0 TO MaxCol()
      @ MaxRow(), i SAY "B"
#if 0
      @ MaxRow() - 1, i SAY Right( Transform( i, "999" ), 1 )
#endif
   NEXT
   FOR i := 0 TO MaxRow()
      @ i, MaxCol() SAY "R"
   NEXT
   @ Int( MaxRow() / 2 ) + 0, 2 SAY PadC( "Press MAXIMIZE/RESTORE button to change dimension", MaxCol() + 1 - 4 )
   @ Int( MaxRow() / 2 ) + 1, 2 SAY PadC( "Try also changing taskbar size/position", MaxCol() + 1 - 4 )
   @ Int( MaxRow() / 2 ) + 3, 2 SAY PadC( "Press any key to redraw screen", MaxCol() + 1 - 4 )
   @ Int( MaxRow() / 2 ) + 4, 2 SAY PadC( "Press ESC to quit", MaxCol() + 1 - 4 )
   diminfo()

   RETURN

// this function is called by gtwvw AFTER the size is changed
// WARNING: screen repainting is not performed completely by gtwvw at this point of call

FUNCTION WVW_SIZE2( nWinNum, hWnd, message, wParam, lParam )

   LOCAL cScreen
   LOCAL lNeedReset
   LOCAL maxsavedscrrow, maxsavedscrcol

   npaintt ++
  @ 26, 00 SAY npaintt

*   HB_SYMBOL_UNUSED( message )
*   HB_SYMBOL_UNUSED( hWnd )
*   HB_SYMBOL_UNUSED( lParam )

   IF ! s_lSizeReady
      // program is not ready to handle window resizing
      // (or this function is currently running)
      RETURN NIL
   ENDIF
   IF nWinNum != 0
      // only care about Main Window
      RETURN NIL
   ENDIF

   // avoid reentrance
   s_lSizeReady := .F.

   DO CASE
   CASE wParam == 2 // SIZE_MAXIMIZED
      // Alert( "MAXIMIZE" )
      // reset is required only if we are changing size
      lNeedReset := MaxCol() != wvw_MaxMaxCol();
         .OR. MaxRow() != wvw_MaxMaxRow()

      IF lNeedReset
         maxsavedscrrow := Min( Min( s_nNormalMaxrow, wvw_MaxMaxRow() ), MaxRow() )
         maxsavedscrcol := Min( Min( s_nNormalMaxcol, wvw_MaxMaxCol() ), MaxCol() )
         cScreen := SaveScreen( 0, 0, maxsavedscrrow, maxsavedscrcol )
         IF SetMode( wvw_MaxMaxRow() + 1, wvw_MaxMaxCol() + 1 ) // adjust MaxRow() & MaxCol()
            RestScreen( 0, 0, maxsavedscrrow, maxsavedscrcol, cScreen )
         ENDIF
         diminfo()  // updatescr()
      ENDIF
   CASE wParam == 0 // SIZE_RESTORED
      // Alert( "RESTORE" )
      lNeedReset := MaxCol() != s_nNormalMaxcol .OR. ;
         MaxRow() != s_nNormalMaxrow
      IF lNeedReset
         maxsavedscrrow := Min( s_nNormalMaxrow, MaxRow() )
         maxsavedscrcol := Min( s_nNormalMaxcol, MaxCol() )
         cScreen := SaveScreen( 0, 0, maxsavedscrrow, maxsavedscrcol )
         IF SetMode( s_nNormalMaxrow + 1, s_nNormalMaxcol + 1 )
            RestScreen( 0, 0, maxsavedscrrow, maxsavedscrcol, cScreen )
         ENDIF
         diminfo()  // updatescr()
      ENDIF
   OTHERWISE
      // do nothing
   ENDCASE

   // allow next call
   s_lSizeReady := .T.

   RETURN NIL
