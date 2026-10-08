/**************************************************************************
*   CALENDAR.PRG                                                          *
*   Version: 2.2 (03-18-96 01:10pm)                                       *
*   A Monthly Calendar Function which allows a user to view the           *
*   calendar for an input or current month and select a date.             *
*   Page-Down skips 30 days, Page-Up skips back 30 days.                  *
*   Cntr-Page-Down skips ahead 365 days, Cntr-Page-Down skips             *
*   back 365 days.                                                        *
*                                                                         *
*   Author: Rod Cushman                                                   *
*           c/o Tracy Time Systems                                        *
*           230 32nd SE                                                   *
*           Grand Rapids, MI 49548-2221                                   *
*           United States of America                                      *
*                   phone:  (616) 241-1661  ( work ) (U.S.A.)             *
*                   fax  :  (616) 241-5911  ( work ) (U.S.A.)             *
*                   Compuserve: 71212,1243                                *
*                                                                         *
*   calendar(dStartDate, nTRow, nLCol, cColorStr) -> dSlctDate            *
*                                                                         *
*   Compile: Clipper calendar /n                                          *
*                                                                         *
*   ====================================================================  *
*                                                                         *
*                                                                         *
*   HotKeys:                                                              *
*     KEY               DESCRIPTION                                       *
*     ---               ------------------------------------------------  *
*     K_CTRL_HOME       Revert to first day of the current year.          *
*                                                                         *
*     K_HOME            Revert to first day of the current month.         *
*                                                                         *
*     K_END             Go to the last day of the current month.          *
*                                                                         *
*     K_CTRL_END        Go to the last day of the current year.           *
*                                                                         *
*     K_ENTER           Accept current highlight as date to be returned   *
*                       to calling routine.                               *
*     K_UP              Move up row in the calendar, browse prior month   *
*                       if on top row or above cell is empty.             *
*     K_PGUP            Browse prior month.                               *
*     K_CTRL_PGUP       Browse same month, prior year.                    *
*     K_DOWN            Move down one row in the calendar, browse next    *
*                       month if on bottom row or below cell is empty.    *
*     K_PGDOWN          Browse next month.                                *
*     K_CTRL_PGDOWN     Browse same month, next year.                     *
*     K_ALT_Y           Pop-up box asking user for year.  Defualts to     *
*                       current year.                                     *
*     K_ALT_M           Pop-up menu asking user for month.  Menu defaults *
*                       to current month.  User can select first char     *
*                       of option as entry selector, or use normal menu   *
*                       keys.                                             *
*     K_ESC             Abort; returns default entry passed down to prog. *
*                                                                         *
*     SPACE             Return Blank Date (i.e. CtoD( Space(8) ) )        *
*                                                                         *
*                                                                         *
*       Please feel free to make revisions to the source.  I would        *
*       appreciate any comments or suggestions.  The code has some        *
*       possibility; especially with the use of tbrowse colors for        *
*       weekends, holidays, etc.                                          *
*                                                                         *
*                                                                         *
*   Mods  : Updated functionality to shrink size of box, Allow arrow keys *
*           to step for/back month; disallowed selection of blank cells;  *
*           and added hotkeys Alt-Y for Year Selection, Alt-M for Month   *
*           Selection.  Function checks position parameters versus        *
*           MaxRow(), MaxCol() and adjusts accordingly if needed.         *
*           Function saves and restores prior states.                     *
*                                                                         *
* Revision History:                                                       *
* 04/26/92 10:21am   Rod   Uploaded to BBS's and CompuServe; orig.        *
*                          version.                                       *
* 05/25/93 06:35pm   Rod   Fixed anomally in the 'Alt-M' to ensure        *
*                          date is proper; will revert to first day       *
*                          of month if not.                               *
* 05/26/93 00:35am   Rod   Performed several major modifications to       *
*                          the logic to flow better and more              *
*                          efficiently...                                 *
* 06/10/93 07:35pm   Rod   Fixed anomally with MoveMonth()                *
* 06/10/93 08:32pm   Rod   Submitted to PD/Shareware.                     *
* 07/27/93 07:04pm   Rod   Fixed anomally with year 2000; fixed           *
*                          anomally with 01/01/0100 (min date) and        *
*                          12/31/2999 (max date).                         *
* 03-18-96 12:02pm   Rod   Added code to make the day and month strings   *
*                          a little more global; allowing the user to pass*
*                          down the language (country) code for string    *
*                          determination.  Currently supports:            *
*                          nCountry = 1 (English-American)                *
*                          nCountry = 2 (Dutch) (per request by Mr. Rob   *
*                                     Bosma of Leeuwarden, Netherlands)   *
* 03-19-96 09:21am   Rod   Added gcMonthSel (file-wide static char string)*
*                          to allow for different Month Select strings.   *
**************************************************************************/

#include "InKey.ch"
#include "Box.ch"

#define MY_HSEP  ' '
#define MY_CSEP  ' '

#define MY_COLOR   "N/W, R/W"

// Scroll back/fwd 1 month ?
Static lMonthFwd  := .f.                        // Logical: Skip Month +1 ?
Static lMonthBck  := .f.                        // Logical: Skip Month -1 ?
Static ctColor    := "B/W,R/W"                 // Default Calendar Color
Static gnYear     := 1992                       // Default Year()
Static gdMinDate  := 0100                       // Min Date Value
Static gdMaxDate  := 2999                       // Max Date Value
Static gnMonth    := 1                          // Default Month()
Static gnEpoch    := 1900                       // Default Century
Static gnDateDoM  := 1                          // Default Target Day
Static gcMonthSel := " SELECT MONTH "           // Default GetMonth() title
Static gaMonthStr := {}                         // Month String array
Static gaDayStr   := {}                         // Day of Week String array

Function Calendar( dStartDate, nTRow, nLCol, cColorStr, nCountry)

   LOCAL aPalette   := Wvt_GetPalette()
   LOCAL aNewPalette:= aclone( aPalette )
   LOCAL aObjects   := WvtSetObjects( {} )
   LOCAL aBlocks    := {}


   Local cKey := 0, dOrigDate := dStartDate, cSaveWin, cOldColr, nOEpoch, ;
         lOScorBrd := .t., cODateFmt, tDate

   aLastPaint := WvtSetBlocks( aBlocks )

   Private nTargRow, nTargCol, aMonth
                /* Establish Calendar box coordinates */
   nTRow      := Iif(nTRow==NIL, 0,Iif(nTRow>MaxRow()- 7, MaxRow()- 7, nTRow))
   nLCol      := Iif(nLCol==NIL, 0,Iif(nLCol>MaxCol()-23, MaxCol()-23, nLCol))
   nBRow      := nTRow +  7
   nRCol      := nLCol + 21
   dStartDate := Iif(dStartDate == NIL, Date(), dStartDate)
   dStartDate := Iif( Empty(dStartDate), Date(), dStartDate)
   cColorStr  := Iif(cColorStr  == NIL,"B/W,R/W*",cColorStr)
   nCountry   := Iif(nCountry == NIL, 1, nCountry) // Default to U.S. Month/Day str format
   ctColor    := cColorStr

   cOldColr   := SetColor()                     // Save Calling func State
   lOScorBrd  := Set( _SET_SCOREBOARD, .f.)     // Disable Read Messages
                                                // Save old format,
                                                // force American
   cODateFmt  := Set( _SET_DATEFORMAT, "mm/dd/yy")

   cSaveWin   := wvt_SaveScreen( nTRow-2, nLCol-3, nBRow+4, nRCol+4 )

   cOldColr   := SetColor(ctColor)
   lDone      := .F.

   // Declare Min/Max Date values...
   gdMinDate  := CtoD('01/01/0100')
   gdMaxDate  := CtoD('12/31/2999')
   SetMonthStr(nCountry)




   DispWin(nTRow, nLCol, nBRow+2, nRCol+2, ctColor) // Disp Calendar Box

   Do While !lDone
      lMonthBck  := .f.                         // Scroll back 1 month
      lMonthFwd  := .f.                         // Scroll fore 1 month
      // Check for out-of-range dates...
      If dStartDate < gdMinDate .or. dStartDate > gdMaxDate
         dStartDate := Date()
      EndIf
      gnDateDoM  := Day(dStartDate)             // Highlite Day of Month
      m1stDay    := FirstDay2(dStartDate)        // First Day of Mo. (#)
      mLastDay   := LastDay2(dStartDate)         // Last Date of Month
      mWeeksInMo := WeeksInMo(m1stDay,mLastDay) // No. of Weeks (rows)
      gnYear     := Year(dStartDate)
      gnMonth    := Month(dStartDate)
      // Build Calendar Array
      aMonth     := MakCalArr(m1stDay, mLastDay, mWeeksInMo, gnDateDoM)

      DspCalHead(dStartDate,nTRow,nLCol,nRCol)  // Show Month and Year

      // Perform Cal. Browse
      dStartDate := CalBrowse( dStartDate, nTRow+1,nLCol+1, nBRow+1, nRCol+1)
      cKey       := LastKey()
      Do Case
         Case cKey == K_RETURN
              Exit

         Case Chr(cKey) == " "                  // Return Blank Date
              dStartDate := CtoD( Space(8) )
              Exit

         Case cKey == K_LEFT  .and. gnDateDoM = 1  // Move Back 1 month
              dStartDate--

         Case cKey == K_RIGHT .and. gnDateDoM = LastDay2( gnMonth )
              dStartDate++

         Case cKey == K_UP
              dStartDate -= 7

         Case cKey == K_DOWN
              dStartDate += 7

         Case cKey == K_PGDN .or. lMonthFwd
              dStartDate := MoveMonth(dStartDate,1, gnYear)  // Month Forward

         Case cKey == K_PGUP .or. lMonthBck
              dStartDate := MoveMonth(dStartDate,-1, gnYear) // Month Back

         Case cKey == K_HOME                    // Goto Beginning of Month
              dStartDate := Num2Date( gnMonth, 1, gnYear )

         Case cKey == K_END                     // Goto End of Month
              dStartDate := Num2Date( gnMonth, LastDay2( gnMonth ), gnYear )

         Case cKey == K_CTRL_PGDN
              dStartDate += 365                 // Increment Year by 1

         Case cKey == K_CTRL_PGUP
              dStartDate -= 365                 // Decrement Year by 1

         Case ( cKey == K_CTRL_HOME )           // First day of Year
              dStartDate := Num2Date( 1, 1, gnYear )

         Case ( cKey == K_CTRL_END )
              dStartDate := Num2Date( 12, 31, gnYear )


         Case cKey == K_ALT_M                   // Get New Month
              gnMonth := GetMonth( gnMonth, nTrow+1, nRCol+3, ctColor)

              tDate   := Num2Date( gnMonth, gnDateDoM, gnYear )
              If Empty( tDate )                 // Ensure Valid date
                 tDate := Num2Date( gnMonth, 1, gnYear )
              EndIf
              dStartDate := tDate


         Case cKey == K_ALT_Y                   // Get New Year
              gnYear     := GetYear( gnYear, nTrow+1, nRCol+3, ctColor )

              tDate   := Num2Date( gnMonth, gnDateDoM, gnYear )
              If Empty( tDate )                  // Ensure Valid date
                 tDate := Num2Date( gnMonth, 1, gnYear )
              EndIf
              dStartDate := tDate

         Case cKey == K_ESC
              dStartDate := dOrigDate           // Return Original Date
              Exit
      EndCase
   EndDo
   Set( _SET_SCOREBOARD, lOScorBrd )
   Set( _SET_DATEFORMAT, cODateFmt )
   SetColor( cOldColr )
   Wvt_SetPalette( aPalette )
   WvtSetObjects( aObjects )
   WvtSetBlocks( aLastPaint )


   wvt_RestScreen( nTRow-2, nLCol-3, nBRow+4, nRCol+4, cSaveWin )


Return dStartDate                               // Return Selected Date


/**************************************************************************
* CalBrowse( <aMonth>, <nTop>, <nLeft>, <nBottom>, <nRight> )             *
*                                                       --> nDaySelect    *
*   This Function adapted from Nantucket Array.prg contains the TBrowse   *
*   implementation                                                        *
* Revision History:                                                       *
**************************************************************************/
Function CalBrowse( dStartDate, nTop, nLft, nBot, nRit )

   LOCAL o                                      // TBrowse object
   LOCAL k                                      // used in o:SkipBlock
   LOCAL nKey := 0                              // keystroke holder

   Private n := 1                               // browse row index holder
   Private nACol                                // browse column subscript

   SetCursor( 0 )

   // Create the TBrowse object
   o         := TBrowseNew( nTop, nLft, nBot, nRit )

   o:headsep := MY_HSEP
   o:colsep  := MY_CSEP

				/******************************************
            *  Initialize the TBrowse blocks          *
            *  Note: during browse, the current row   *
            *        subscript is maintained          *
            *        by the blocks in private n       *
            *        LEN(aMonth) returns number of    *
            *        rows in array                    *
            ******************************************/

   o:SkipBlock     := { |nSkipVal| SkipFunc( @n, nSkipVal, Len(aMonth)) }
   o:GoTopBlock    := { || n := 1 }
   o:GoBottomBlock := { || n := Len( aMonth ) }

				/******************************************
            *  Create TBColumn objects, Initialize    *
            *  data retrieval blocks, and Add to      *
            *  TBrowse object                         *
				******************************************/
   FOR nACol = 1 TO LEN( aMonth[1] )
       o:AddColumn( TBColumnNew(gaDayStr[nACol], ABlock("aMonth[n]", nACol)))
   NEXT

						// Position Cursor to start
   o:ColPos := nTargCol
   o:RowPos := nTargRow

						// Start event handler loop
   Do While nKey != K_ESC .and. nKey != K_RETURN
      nKey := 0
						// Start stabilization loop
      Do While !o:Stabilize()
         nKey := InKey()
         If nKey != 0
            EXIT
         EndIf
      EndDo
      dStartDate := CtoD( StrZero(gnMonth,2,0)  + '/' +  ;
                          aMonth[ n, o:ColPos ] + '/' +  ;
                          Str(gnYear,4,0)                ;
                        )
      // Check for out-of-range dates...
      If dStartDate < gdMinDate .or. dStartDate > gdMaxDate
         dStartDate := Date()
      EndIf

      gnDateDoM  := Day(dStartDate)             // Highlite Date

      If nKey == 0
         nKey := InKey(0)
      EndIf

						// Process directional keys
      If o:Stable
         DO Case
            Case ( nKey == K_UP )
                 If n > 1
                    If !Empty(aMonth[ n-1, o:ColPos ])
                       o:Up()
                    Else
                       Return dStartDate
                    EndIf
                 Else
                    Return dStartDate
                 EndIf

            Case ( nKey == K_DOWN )
                 If n < LEN(aMonth)
                    If !Empty(aMonth[ n+1, o:ColPos ])
                       o:Down()
                    Else
                       Return dStartDate
                    EndIf
                 Else
                    Return dStartDate
                 EndIf

            Case ( nKey == K_RIGHT )
                 If o:colPos == 7
                    // Last day of month
                    If Val(aMonth[n,o:ColPos]) != LastDay2( gnMonth )
                       o:down()
                       o:home()
                    Else
                       Return dStartDate
                    EndIf
                 Else
                    // Last day of month
                    If Val(aMonth[n,o:ColPos]) != LastDay2( gnMonth )
                       o:Right()
                    Else
                       Return dStartDate
                    EndIf
                 EndIf

            Case ( nKey == K_LEFT )
                 If o:colPos == 1
                    If n > 1                     /* NOTE: */
                       o:up()
                       o:end()
                    Else
                       Return dStartDate
                    EndIf
                 Else
                    If aMonth[ n, o:ColPos] != " 1"     // 1rst of month
                       o:Left()
                    Else
                       Return dStartDate
                    EndIf
                 EndIf

            Case ( nKey == K_PGDN .or. nKey == K_CTRL_PGDN)
                 Return dStartDate

            Case ( nKey == K_PGUP .or. nKey == K_CTRL_PGUP)
                 Return dStartDate

            Case ( nKey == K_HOME )             // Return first DOM()
                 Return dStartDate

            Case ( nKey == K_END )
                 Return dStartDate

            Case ( nKey == K_CTRL_HOME )        // First day of Year
                 Return dStartDate

            Case ( nKey == K_CTRL_END )
                 Return dStartDate

            Case ( nKey == K_ALT_Y )
                 Return dStartDate

            Case ( nKey == K_ALT_M )
                 Return dStartDate

            Case ( Chr(nKey) == " " )
                 Return dStartDate

         EndCase
      EndIf
   EndDo

   SetCursor( 1 )
Return dStartDate


/**************************************************************************
* SkipFunc                                                                *
*  I don't know about you but I had to dissect the skipblock routine      *
*  in order to understand what it does.                                   *
*  - JP Steffen                                                           *
* Revision History:                                                       *
**************************************************************************/
static Function SkipFunc( n, nSkip_Val, nMaxVal)
   local nMove := 0                              // Return Value

   If nSkip_Val > 0
      Do While n + nMove < nMaxVal .and. nMove < nSkip_Val
        nMove++
      EndDo
   ElseIf nSkip_Val < 0
      Do While n + nMove > 1 .and. nMove > nSkip_Val
         nMove--
      EndDo
   EndIf
   n += nMove
Return nMove


/**************************************************************************
*  Function DispWin                                                       *
*       clear window area and draw box for window                         *
*       Parameters:                                                       *
*       nTop            Top Row of Box                                    *
*       nLft            Left Column of Box                                *
*       nBot            Bottom Row of Box                                 *
*       nRit            Right Column of Box                               *
**************************************************************************/
Static Function DispWin( nTop, nLft, nBot, nRit, cClr)
   cClr := Iif( cClr = NIL, SetColor(), cClr)
   SetColor( cClr )
   DispBegin()
   @ nTop,nLft CLEAR TO nBot-1,nRit

 setcolor("W/W+")
*   nbox(nTop,nLft,nBot-1,nRit,"W/W+",.t.)

*   @ nTop,nLft,nBot,nRit BOX B_DOUBLE_SINGLE  Color cClr
   DispEnd()
*   Wvt_DRAWBOXRECESSED( nTop,nLft,nBot-1,nRit,{0,0,0,0})
WVT_DRAWBOXRAISED( nTop,nLft,nBot-1,nRit,{0,0,0,0})
Return  NIL


/***************************************************************************
*  Function DspCalHead                                                     *
*  create a centered Month and Year String                                 *
*       Parameters:                                                        *
*       dStartD         Date to derive month and Year from                 *
*       nLine           Line to display Calenday header on                 *
*       nBeg            Beginning Column which to display header           *
*       nEnd            Ending Column which to display header.             *
* Revision History:                                                        *
* 03-18-96 11:02am   RJC   Modified to use file-wide static gaMonthStr[]   *
*                          to grab Month text from array instead of Clipper*
*                          internals.                                      *
***************************************************************************/
Function DspCalHead( dStartD, nLine, nBeg, nEnd)
   nBeg++
   nEnd--
*  cStr     := " " + Upper(Trim(CMonth(dStartd)) + " " +                   ;
*              LTrim(Str(Year(dStartD))))  + " "
   cStr     := " " + Upper(Trim(gaMonthStr[Month(dStartd)])) + " " +       ;
               LTrim(Str(Year(dStartD)))  + " "
   nLineLen := (nEnd-1) - (nBeg+1)
   nSpace   := Int((nLineLen - len(cStr)+2) / 2)+2       // Centered title
   DispBegin()
   @ nLine, nBeg Say Replicate(" ", nEnd-nBeg+3) Color ctColor
   @ nLine,nBeg+nSpace say cStr Color ctColor

*   @ nLine, nBeg Say Replicate(Chr(205), nEnd-nBeg+3) Color ctColor
*   @ nLine,nBeg+nSpace say cStr Color ctColor
   DispEnd()
Return NIL


/**************************************************************************
*  Function MakCalArr                                                     *
*       Builds the data structure for the TBrowse in CalBrowse.  This is  *
*       the key to the program & can no doubt be done better ie. faster.  *
*       Parameters:                                                       *
*       m1day                                                             *
*       mLastD          Last Day of month                                 *
*       mWeeks          Number of weeks in the month                      *
*       mTargD          Target Date                                       *
* Revision History:                                                       *
* 03-18-96 11:23am   RJC   Cleaned up code and made nRow, nCol and        *
*                          nDayOfMo local variables.                      *
**************************************************************************/
Function MakCalArr( m1day, mLastd, mWeeks,  mTargd )
   Local dArray[mWeeks][7]                       // Called by other funcs
   Local nRow, nCol, nDayOfMo

   nDayOfMo   := 1

   For nRow := 1 to mWeeks
      For nCol := 1 to 7
         // row & col of target day
         If nDayOfMo == mTargd
            nTargRow := nRow                      // put browse cursor here
            nTargCol := nCol
         EndIf
         If nCol + (nRow-1)*7 < m1Day .or. nDayOfMo > mLastD
            dArray[nRow][nCol] := "  "
         Else
            dArray[nRow][nCol] := PadNumber(nDayOfMo,2) // convert to str len=2
            nDayOfMo++
         EndIf
      Next nCol
   Next nRow
Return dArray


/**************************************************************************
* PadNumber()                                                             *
*     convert from num., trim, & apply leading Space                      *
* Revision History:                                                       *
**************************************************************************/
Function PadNumber( In_Num, Out_len )
   Local Num_Len := Len(LTrim(Str(In_Num)))
Return Space(Out_Len - Num_Len) + LTrim(Str(In_Num))


/**************************************************************************
*  Function MoveMonth()                                                   *
*  Simply adds or subtracts 30 days from date.  You may want to add more  *
*  sophistication to this to insure new day of month is same as current   *
*  day of month.                                                          *
*                       dStartD = Input Date                              *
*                       nMove   = +1 or -1 (times 30 days)                *
* Revision History:                                                       *
**************************************************************************/
Function MoveMonth( dStartD, nMove, nYear )
  Local nLastMnth, nLastDay, nLastYear,                                   ;
        nCurrMnth, nCurrDay, nCurrYear,                                   ;
        nNextMnth, nNextDay, nNextYear,                                   ;
        dTemp    , nAbsMove

  // Grab values...
  nAbsMove  := Abs( nMove )
  nDay      := Day( dStartD )
  nCurrMnth := Month( dStartD )
  nCurrDay  := LastDay2( nCurrMnth    )
  nCurrYear := Year( dStartD )

  nLastMnth := ( 12 + nCurrMnth - nAbsMove ) % 12
  nLastDay  := LastDay2( nLastMnth )
  nLastYear := nCurrYear - Int( ( nCurrMnth - nAbsMove ) / 12 )

  nNextMnth := ( nCurrMnth + nAbsMove ) % 12
  nNextDay  := LastDay2( nNextMnth )
  nNextYear := nCurrYear - Int( ( nCurrMnth + nAbsMove ) / 12 )

  If nMove > 0
     // Check if curr month longer than next
     // If so, go to end of next month
     If nDay <= nNextDay
        dStartD += nCurrDay
     Else
        dTemp := Num2Date( nNextMnth, nNextDay, nNextYear )
        If !Empty( dTemp )
           dStartD := dTemp
        EndIf
     EndIf
  Else
     // Check if curr month longer than next
     // If so, go to end of next month
     If nDay <= nLastDay
        dStartD -= nLastDay
     Else
        dTemp := Num2Date( nLastMnth, nLastDay, nLastYear )
        If !Empty( dTemp )
           dStartD := dTemp
        EndIf
     EndIf
  EndIf
Return dStartD


/**************************************************************************
*  Num2Date( nMonth, nDay, nYear ) => ctod('XX/XX/XX')                    *
*       Function converts the given numeric fields into date format.      *
*       Returns Empty(dDate) if invalid combination.                      *
* Revision History:                                                       *
**************************************************************************/
Function Num2Date( nMonth, nDay, nYear )
  Local dDate

  If LastDay2( nMonth ) < nDay                   // Invalid combination
     Return CtoD( Space(8) )
  EndIf

  If nYear < 100 .or. nYear > 2999              // Invalid year
     Return CtoD( Space(8) )
  EndIf

  dDate := CtoD( StrZero(nMonth,2,0)  + '/' +                             ;
                 StrZero(nDay,2,0) + '/' +                                ;
                 Str(nYear,4,0)                                           ;
               )

Return dDate


/**************************************************************************
*  LastDay()                                                              *
*       Returns the last date of month for input date                     *
*       Modified parameter so that it may either be date or month number  *
*       Parameters:                                                       *
*       nMnth           Either Numeric Month number of Date from which    *
*                       to calculate the month from.                      *
* Revision History:                                                       *
**************************************************************************/
Function LastDay2( nMnth )
  Local nMonth := Iif( ValType(nMnth)="D", Month(nMnth), nMnth ),          ;
	nDays    := 30

  Do Case
     Case nMonth =  0                   // Allow previous year, December
          nDays := 31

     // January
     Case nMonth =  1
          nDays := 31

     // February
     Case nMonth =  2                   // Is this leap year ?
          If !Empty( Day(CtoD("02/29/" + Str(gnYear,4,0) )) )
             nDays := 29
          Else
             nDays := 28
          EndIf

     // March
     Case nMonth =  3
          nDays := 31

     // April
     Case nMonth =  4
          nDays := 30

     // May
     Case nMonth =  5
          nDays := 31

     // June
     Case nMonth =  6
          nDays := 30

     // July
     Case nMonth =  7
          nDays := 31

     // August
     Case nMonth =  8
          nDays := 31

     // September
     Case nMonth =  9
          nDays := 30

     // October
     Case nMonth = 10
          nDays := 31

     // November
     Case nMonth = 11
          nDays := 30

     // December
     Case nMonth = 12
          nDays := 31
  EndCase
Return nDays


/**************************************************************************
*  FirstDay()                                                             *
*       Returns the day of week for first day of month                    *
* Revision History:                                                       *
**************************************************************************/
Function FirstDay2( nStartD )
Return Dow(nStartD - Day(nStartD) + 1)


/**************************************************************************
*  WeeksInMo()                                                            *
*       Calculates the number of rows needed for array                    *
*       Parameters:                                                       *
*       nBegDoW         Beginning Date Day of Week                        *
*       nDays           Number of days in the month.                      *
* Revision History:                                                       *
**************************************************************************/
Function WeeksInMo( nBegDoW, nDays )

  Do Case
     Case nDays == 31                           // 31 day month
          If nBegDoW >= 6
             Return 6
          Else
             Return 5
          EndIf

     Case nDays == 30                           // 30 day month
          If nBegDoW == 7
             Return 6
          Else
             Return 5
          EndIf

     Case nDays == 29                           // February - leap year
          Return 5

     Case nDays == 28                           // February - 28 days
          If nBegDoW == 1
             Return 4
          Else
             Return 5
          EndIf
  EndCase
Return 4


/**************************************************************************
*   ABlock( <cName>, <nSubx> ) -> bABlock                                 *
*       Given an array name and subscript, return a set-get block for     *
*       the array element indicated.                                      *
* Revision History:                                                       *
**************************************************************************/
Function ABlock( cName, nSubx )
   LOCAL caExpr, bRetVal

   caExpr := cName + "[" + LTrim(STR(nSubx)) + "]"
   bRetVal := &( "{||" + caExpr + "}" )
Return bRetVal


/**************************************************************************
*  SetMonthStr(nCountry)                                                  *
*     Function sets the file-wide static arrays for Month and Day string  *
*     for the appropriate text.  The following codes are valid (so far):  *
*     nCountry =        Language for Month & Day Strings:                 *
*     ----------        ---------------------------------                 *
*     1 or undef        English (default) - American format               *
*     2                 Dutch                                             *
*                                                                         *
* Revision History:                                                       *
* 03-18-96 11:42am   RJC   Created function per request to allow for      *
*                          Dutch language; easier to consolidate all lang.*
*                          changes to one spot in code.  Need a new set   *
*                          of month and day strings?  Add an option to the*
*                          Case statement below for your given language,  *
*                          and then pass down the number you specify to   *
*                          the main function (see Calendar() parameters at*
*                          the top of this program file).  When changing  *
*                          this program to add new strings, please mail   *
*                          me a copy so I can have it for others who      *
*                          request it...                                  *
* 03-19-96 09:21am   Rod   Added gcMonthSel (file-wide static char string)*
*                          to allow for different Month Select strings.   *
**************************************************************************/
Static Function SetMonthStr( nCountry )

   If !( 0 < nCountry .AND. nCountry <= 2)      // Not valid value - def = 1
      nCountry := 1
   EndIf

   Do Case
      Case nCountry = 1                         // English - American
           gcMonthSel := " SELECT MONTH "
           gaMonthStr := {                                                ;
                           "January",                                     ;
                           "February",                                    ;
                           "March",                                       ;
                           "April",                                       ;
                           "May",                                         ;
                           "June",                                        ;
                           "July",                                        ;
                           "August",                                      ;
                           "September",                                   ;
                           "October",                                     ;
                           "November",                                    ;
                           "December"                                     ;
                         }

           gaDayStr   := {                                                ;
                           "Su",                                          ;
                           "Mo",                                          ;
                           "Tu",                                          ;
                           "We",                                          ;
                           "Th",                                          ;
                           "Fr",                                          ;
                           "Sa"                                           ;
                         }

      Case nCountry = 2                         // Dutch
           gcMonthSel := " NIEUWE MAAND "
           gaMonthStr := {                                                ;
                           "Janeiro",                                     ;
                           "Fevereiro",                                    ;
                           "Marco",                                       ;
                           "Abril",                                       ;
                           "Maio",                                         ;
                           "Junho",                                        ;
                           "Julho",                                        ;
                           "Agosto",                                    ;
                           "Setembro",                                   ;
                           "Outubro",                                     ;
                           "Novembro",                                    ;
                           "Dezembro"                                     ;
                         }

           gaDayStr   := {                                                ;
                           "Do",                                          ;
                           "Se",                                          ;
                           "Te",                                          ;
                           "Qu",                                          ;
                           "Qu",                                          ;
                           "Se",                                          ;
                           "Sa"                                           ;
                         }
   EndCase
Return NIL


/**************************************************************************
*  GetMonth( )                                                            *
*       Pop - Up Menu for Month Selection.  Returns Selected Month        *
* Revision History:                                                       *
* 03-19-96 09:20am   Rod   Converted to file-wide static vars for month   *
*                          and box title; allowing for alternate languages*
**************************************************************************/
Static Function GetMonth( nDefaultMnth, nTop, nLft, cColor )
   Local nMonth := nDefaultMnth,                                          ;
         sWin   := "",                                                          ;
         tTop   := 11,                                                          ;
         tLft   := 63,                                                          ;
         coColr := SetColor()

   // Establish Calendar box coordinates
   tTop     := Iif(nTop == NIL, 0, Iif(nTop > MaxRow()-13, MaxRow()-13, nTop))
   tLft     := Iif(nLft == NIL, 0, Iif(nLft > MaxCol()-17, MaxCol()-17, nLft))

   KeyBoard Chr(K_HOME) + Replicate(Chr(K_DOWN), nDefaultMnth-1 )
   sWin   := SaveScreen(tTop, tLft, tTop+13, tLft+15)

   DispBegin()
   SetColor( cColor )
   DispWin( tTop, tLft, tTop+13, tLft+15, cColor )
   @ tTop+ 0, tLft+1 Say    gcMonthSel  Color cColor

   @ tTop+ 1, tLft+1 Prompt "1)  " + PadR(gaMonthStr[ 1], 9)
   @ tTop+ 2, tLft+1 Prompt "2)  " + PadR(gaMonthStr[ 2], 9)
   @ tTop+ 3, tLft+1 Prompt "3)  " + PadR(gaMonthStr[ 3], 9)
   @ tTop+ 4, tLft+1 Prompt "4)  " + PadR(gaMonthStr[ 4], 9)
   @ tTop+ 5, tLft+1 Prompt "5)  " + PadR(gaMonthStr[ 5], 9)
   @ tTop+ 6, tLft+1 Prompt "6)  " + PadR(gaMonthStr[ 6], 9)
   @ tTop+ 7, tLft+1 Prompt "7)  " + PadR(gaMonthStr[ 7], 9)
   @ tTop+ 8, tLft+1 Prompt "8)  " + PadR(gaMonthStr[ 8], 9)
   @ tTop+ 9, tLft+1 Prompt "9)  " + PadR(gaMonthStr[ 9], 9)
   @ tTop+10, tLft+1 Prompt "A)  " + PadR(gaMonthStr[10], 9)
   @ tTop+11, tLft+1 Prompt "B)  " + PadR(gaMonthStr[11], 9)
   @ tTop+12, tLft+1 Prompt "C)  " + PadR(gaMonthStr[12], 9)

   DispEnd()
   Menu to nMonth

   SetColor( coColr )
   RestScreen( tTop, tLft, tTop+13, tLft+15, sWin )
Return Iif(Empty(nMonth), 1, nMonth)


/**************************************************************************
*  GetYear( nDefaultYear )                                                *
*       Pop - Up Alert() for Year  selection.  Returns Selected Year.     *
**************************************************************************/
Static Function GetYear( nDefaultYear, nTop, nLft, cColor )
   Local nYear    := nDefaultYear,                                        ;
         sWin     := "",                                                        ;
         tTop     := 10, tLft := 50,                                            ;
         oGetList := GetList

   // Establish Calendar box coordinates
   tTop     := Iif(nTop == NIL, 0, Iif(nTop > MaxRow()- 2, MaxRow()- 2, nTop))
   tLft     := Iif(nLft == NIL, 0, Iif(nLft > MaxCol()-19, MaxCol()-19, nLft))
   GetList := {}                                 // Save old GetList, Reset
   sWin := SaveScreen(tTop, tLft, tTop+2, tLft+18)

   DispWin( tTop, tLft, tTop+2, tLft+18, cColor )
   @ tTop+ 0, tLft+3 Say     " SELECT YEAR "  Color cColor
   @ tTop+ 1, tLft+1 Say "ENTER YEAR "  Get nYear Picture "9999"          ;
              Valid ( 0100 <= nYear .and. nYear <= 2999 )  Color cColor
   Read

   RestScreen( tTop, tLft, tTop+2, tLft+18, sWin )
   GetList := oGetList                           // Restore prior GetList
Return Iif(Empty(nYear), 1992, nYear)
