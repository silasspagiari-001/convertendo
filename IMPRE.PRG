#define FW_DONTCARE    0
#define FW_THIN        100
#define FW_EXTRALIGHT  200
#define FW_LIGHT       300
#define FW_NORMAL      400
#define FW_MEDIUM      500
#define FW_SEMIBOLD    600
#define FW_BOLD        700
#define FW_EXTRABOLD   800
#define FW_HEAVY       900
#define DMPAPER_A4     9
 
 #include "common.ch"
#include "hbwin.ch"

FUNCTION Test2(cPrn)

   LOCAL oPrinter
   LOCAL aFonts, cFont, nFont
 
   oPrinter           := Win32Prn():new( cPrn) // Create printer object and configure print job
   oPrinter:landscape := .F.
   oPrinter:formType  := DMPAPER_A4
   oPrinter:copies    := 1                     // <--- 2 copies !!
 
   IF .NOT. oPrinter:create()                  // Create device context
 
      Alert( "Nao Foi Possivel Criar o Contexto de Dispositivo" )
 
      QUIT
 
   ENDIF
 
   IF .NOT. oPrinter:startDoc( "xHarbour Teste de Pagina" ) // Create print job
 
      Alert( "Nao Foi Possivel Criar o Documento" )
 
      QUIT
 
   ENDIF

   oPrinter:SetFont( "Courier New", 7, { 3, -50 } )
   oPrinter:textOut( "Texto em Fonte Padrao" ) // Text in fixed font
   oPrinter:bold( FW_NORMAL )
   oPrinter:textOut( oPrinter:fontName )
   oPrinter:bold( FW_NORMAL )
   oPrinter:newLine()

   oPrinter:textOut( "Texto em Fonte Arial: " )
   oPrinter:bold( FW_BOLD )
   oPrinter:textOut( oPrinter:fontName )
   oPrinter:bold( FW_NORMAL )
   oPrinter:newLine()
 
//   oPrinter:setColor( RGB_YELLOW, RGB_BLUE )    // Colored text
   oPrinter:textOut( "Amarelo no Azul - Yellow on Blue " )
   oPrinter:newLine()
 
*   oPrinter:setPen( PS_DASH, 5, '#000000' )    // Draw colored line across page
*   oPrinter:line( oPrinter:posX, ;
*                  oPrinter:posY, ;
*                  oPrinter:rightMargin, ;
*                  oPrinter:posY  )
 
   oPrinter:endDoc()       // Send output to printer
   oPrinter:destroy()
   
 function TEST3
   LOCAL nPrn := 1
//   LOCAL cBMPFile := Space( 40 )
   LOCAL aPrn := GETPRINTERS(.T.,.F.)
   LOCAL GetList := {}

   cBMPFile = "c:\cirur\LOGO_CIRUR.bmp"
   CLS

   IF Empty( aPrn )
      Alert("No printers installed - Cannot continue")
      QUIT
   ENDIF

 *  DO WHILE nPrn != 0
 *     CLS
 *     @ 0, 0 SAY "Win_Prn() Class test program. Choose a printer to test"
 *     @ 1, 0 SAY "Bitmap file name" GET cBMPFile PICT "@K"
 *     READ
 *     @ 2, 0 TO MaxRow(), MaxCol()
*      nPrn := AChoice( 3, 1, MaxRow() - 1, MaxCol() - 1, aPrn, .T.,, nPrn )
 *     IF nPrn != 0
         PrnTest( "")
*      ENDIF
 *  ENDDO

   RETURN

PROCEDURE PrnTest( cPrinter )
   LOCAL oPrinter := Win32Prn():New( cPrinter )
   LOCAL aFonts
   LOCAL x
   LOCAL nColFixed
   LOCAL nColTTF
   LOCAL nColCharSet

   oPrinter:Landscape := .F.
   oPrinter:FormType  := DMPAPER_A4
   oPrinter:Copies    := 2

   IF ! oPrinter:Create()
      Alert( "Cannot Create Printer" )
   ELSE
      IF ! oPrinter:startDoc( "Win_Prn(Doc name in Printer Properties)" )
         Alert( "StartDoc() failed" )
      ELSE
         oPrinter:UnderLine( .F. )
         oPrinter:Italic( .F. )

         oPrinter:leftMargin  := oPrinter:mm_To_PosX(5) //9 Milimetros
         oPrinter:topMargin   := oPrinter:mm_To_PosY(30) //9 Milimetros
         oPrinter:Bold( WIN_FW_EXTRABOLD )
         oPrinter:TextOut( oPrinter:PrinterName + ": MaxRow() = " +  Str( oPrinter:MaxRow(), 4 ) + "   MaxCol() = " + Str(oPrinter:MaxCol(), 4 ) )
         oPrinter:Bold( WIN_FW_DONTCARE )
         oPrinter:NewLine()
         //oPrinter:TextOut("   Partial list of available fonts that are available for OEM_")
         oPrinter:NewLine()
         oPrinter:SetFont( "Courier New", 11,0)  // Compressed print
oPrinter:TextOut("Cliente    : FATIMA APARECIDA BERNARDO DE OLIVEIRA      Codigo: 19447",.T.)
oPrinter:TextOut("Endereco   : ESTANCIA SANTA FE                        Telefone: 8114.2723",.T.)
oPrinter:TextOut("Municipio  : ALVARES MACHADO      SP                   Emissao: 22/08/19",.T.)
oPrinter:TextOut("CGC(MF)/CPF: 781.342.428/04                          Inscr Est: 162.077.267.116",.T.)
oPrinter:TextOut("Vendedor   :   1 LEANDRO BEZERRA DE MENEZES             Bairro:               ",.T.)
oPrinter:TextOut("--------------------------------------------------------------------------------",.T.)
oPrinter:TextOut(" Codigo   Qtde    Produto(s)                           Vlr Unitario    Vlr Total",.T.)
oPrinter:TextOut("--------------------------------------------------------------------------------",.T.)
oPrinter:TextOut("    19       1,00 ARAME FARPADO MOTTO MUNDIAL 500 MTS.      291,78        291,78",.T.)
oPrinter:TextOut("Quantidade:       1,00                                     Total : R$     291,78",.T.)




         oPrinter:TextOut( "FontName" )
         oPrinter:SetPos( nColFixed )
         oPrinter:TextOut( "Fixed?" )
         oPrinter:SetPos( nColTTF )
         oPrinter:TextOut( "TrueType?" )
         oPrinter:SetPos( nColCharset )
         oPrinter:TextOut( "CharSet#", .T. )
         oPrinter:NewLine()
         oPrinter:Italic( .F. )
         oPrinter:UnderLine( .F. )
         aFonts := oPrinter:GetFonts()
         oPrinter:NewLine()

      *   FOR x:= 1 TO Len( aFonts ) STEP 2
      *      oPrinter:CharSet( aFonts[ x, 4 ] )
      *      IF oPrinter:SetFont( aFonts[ x, 1 ] )       // Could use  "IF oPrinter:SetFontOk" after call to oPrinter:SetFont()
      *         IF oPrinter:FontName == aFonts[ x, 1 ]  // Make sure  Windows didn't pick a different font
      *            oPrinter:TextOut( aFonts[ x, 1 ] )
      *            oPrinter:SetPos( nColFixed )
      *            oPrinter:TextOut( iif( aFonts[ x, 2 ], "Yes", "No" ) )
      *            oPrinter:SetPos( nColTTF )
      *            oPrinter:TextOut( iif( aFonts[ x, 3 ], "Yes", "No" ) )
      *            oPrinter:SetPos( nColCharSet )
      *            oPrinter:TextOut( Str( aFonts[ x, 4 ], 5 ) )
      *            oPrinter:SetPos( oPrinter:LeftMargin, oPrinter:PosY + ( oPrinter:CharHeight * 2 ) )
      *            IF oPrinter:PRow() > oPrinter:MaxRow() - 16  // Could use "oPrinter:NewPage()" to start a new page
      *               EXIT
      *            ENDIF
      *         ENDIF
      *      ENDIF
        //    oPrinter:Line( 0, oPrinter:PosY + 5, 2000, oPrinter:PosY + 5 )
      *   NEXT
         
         oPrinter:SetFont( "Lucida Console", 8, { 3, -50 } )  // Alternative Compressed print
         oPrinter:CharSet( 0 )  // Reset default charset
         oPrinter:Bold( WIN_FW_EXTRABOLD )
         oPrinter:NewLine()
         oPrinter:TextOut( "This is on line" + Str( oPrinter:Prow(), 4) + ", Printed bold, " )
         oPrinter:TextOut( " finishing at Column: " )
         oPrinter:TextOut( Str( oPrinter:Pcol(), 4 ) )
         oPrinter:SetPrc( oPrinter:Prow() + 3, 0 )
         oPrinter:Bold( WIN_FW_DONTCARE )
         oPrinter:TextOut( "Notice: UNDERLINE only prints correctly if there is a blank line after", .T. )
         oPrinter:TextOut( "        it. This is because of :LineHeight and the next line", .T. )
         oPrinter:TextOut( "        printing over top of the underline. To avoid this happening", .T. )
         oPrinter:TextOut( "        you can to alter :LineHeight or use a smaller font, or use :SetBkMode( WIN_TRANSPARENT )" )
         oPrinter:NewLine()
         oPrinter:NewLine()
         oPrinter:SetFont( "Lucida Console", 18, 0 )  // Large print
         oPrinter:SetColor( HB_WIN_RGB_GREEN )
         oPrinter:TextOut( "Finally some larger print" )
         oPrinter:Box(   0, oPrinter:PosY + 100, 100, oPrinter:PosY + 200 )
         oPrinter:Arc( 200, oPrinter:PosY + 100, 300, oPrinter:PosY + 200 )
         oPrinter:Ellipse( 400, oPrinter:PosY + 100, 500, oPrinter:PosY + 200 )
         oPrinter:FillRect( 600, oPrinter:PosY + 100, 700,oPrinter:PosY + 200, HB_WIN_RGB_RED )

//       To print a barcode;
//       Replace 'BCod39HN' with your own bar code font or any other font
//         oPrinter:TextAtFont( oPrinter:MM_TO_POSX( 30 ),oPrinter:MM_TO_POSY( 60 ), "1234567890", "BCod39HN", 24, 0 )
//
        PrintBitMap( oPrinter, cBMPFile )

         oPrinter:EndDoc()
      ENDIF
      oPrinter:Destroy()
   ENDIF

   RETURN

STATIC PROCEDURE PrintBitMap( oPrn, cBitFile )
   LOCAL oBMP

   IF Empty( cBitFile )
      *
   ELSEIF ! hb_FileExists( cBitFile )
      Alert( cBitFile + " not found " )
   ELSE
      oBMP := Win32BMP():New()
      IF oBmp:loadFile( cBitFile )

         oBmp:Draw( oPrn, { 10, 10, 800, 400 } )

         // Note: Can also use this method to print bitmap
         //   oBmp:Rect := { 200, 200, 2000, 1500 }
         //   oPrn:DrawBitMap( oBmp )

      ENDIF
      oBMP:Destroy()
   ENDIF

   RETURN


