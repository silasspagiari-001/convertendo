#xtranslate menuinit() => MenuList := {}

#xcommand @ <row>, <col> prompt <string> ;
            [position <num>][highlite <hcolor>];
            [message <message> [AT <mRow>, <mCol>];
            [color <color>][<cd:CENTER>]] ;
            [activate <func>];
            [permite <nLin>, <nCol> ,<nPos>];
            [senha <nSen>] => ;
  aadd( MenuList, MenuNew(<row>, <col>, <string>, ;
                         <num>, <(hcolor)>, <message>, ;
                         <mRow>, <mCol>, <(color)>, ;
                         <.cd.>, {|aList, nPos, nKey| <func>},;
                         <nLin>, <nCol>, <nPos>, <nSen> ))

#xcommand @ <row>, <col> prompt <string> ;
            [position <num>][highlite <hcolor>];
            [message <message> [AT <mRow>, <mCol>];
            [color <color>][<cd:CENTER>]] ;
            [perform <func>] ;
            [permite <nLin>, <nCol> ,<nPos>] ;
            [botao <tam>];
            [senha <nSen>] => ;
  aadd( MenuList, MenuNew(<row>, <col>, <string>, ;
           <num>, <(hcolor)>, <message>, ;
           <mRow>, <mCol>, <(color)>, ;
           <.cd.>, {|aList, nPos, nKey| <func>(aList, nPos, nKey)},;
           <nLin>, <nCol>, <nPos> ,;
           <tam>, <nSen> ))

#xcommand prompt <string> ;
            [position <num>][highlite <hcolor>];
            [message <message> [AT <mRow>, <mCol>];
            [color <color>][<cd:CENTER>]] ;
            [activate <func>];
            [senha <nSen>] => ;
  aadd( MenuList, MenuNew(,, <string>, ;
                         <num>, <(hcolor)>, <message>, ;
                         <mRow>, <mCol>, <(color)>, ;
                         <.cd.>, {|aList, nPos, nKey| <func>},,,,, <nSen> ))

#xcommand prompt <string> ;
            [position <num>][highlite <hcolor>];
            [message <message> [AT <mRow>, <mCol>];
            [color <color>][<cd:CENTER>]] ;
            [perform <func>];
            [senha <nSen>] => ;
  aadd( MenuList, MenuNew(,, <string>, ;
           <num>, <(hcolor)>, <message>, ;
           <mRow>, <mCol>, <(color)>, ;
           <.cd.>, {|aList, nPos, nKey| <func>(aList, nPos, nKey)},,,,, <nSen> ))

#xcommand menu to <choice> => ;
  MenuModal( MenuList, @<choice>,,<(choice)> ) ;;
  MenuList := {}

#xcommand menu to <choice> with <alist> [ display <adisp> ] => ;
  MenuModal( <alist>, @<choice>, <adisp>, <(choice)> ) 

#xcommand store menu to <var> => <var> := aclone( MenuList )  ;;
                                 MenuList := {}

#xtranslate MENUSETDISP( <aArray> ) => {|| MenuDisplay( <aArray> )}

* End of File
