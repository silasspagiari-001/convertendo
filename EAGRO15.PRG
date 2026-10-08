***************
function MANGRP
***************
parameters M_OPC,M_OPC1,M_OPC2

#include "ptmenu.ch"

      rodape("MENU","GRUPOS",M_FAN,"EAGRO15","Mem: " + str(memory(0), 5),M_EMP)

*        @ 05, 08 prompt "Inclus�o " HIGHLITE R/BG PERMITE 5,1,1
*        @ 06, 08 prompt "Altera℡o" HIGHLITE R/BG PERMITE 5,1,2
*        @ 07, 08 prompt "Consulta " HIGHLITE R/BG PERMITE 5,1,3
*        @ 08, 08 prompt "Exclus�o " HIGHLITE R/BG PERMITE 5,1,4
*        @ 09, 08 prompt "Listagem " HIGHLITE R/BG PERMITE 5,1,5
*        @ 10, 08 prompt "Outros   " HIGHLITE R/BG PERMITE 5,1,6

      do case
         case M_OPC = 1 ; incgrp()
         case M_OPC = 2 ; altgrp()
         case M_OPC = 3 ; congrp()
         case M_OPC = 4 ; excgrp()
         case M_OPC = 5 ; lisgrp()
      endcase  

    fecha_arq()

return ""

***************
function INCGRP
***************
        
do while .t.

  M_GRPCOD = 0
  M_GRPNOM = space(40)
  M_GRPMAR = 0

  tlgrp01()

  rodape("INCLUI","GRUPOS",M_FAN,"EAGRO15","Mem: " + str(memory(0), 5),M_EMP)

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"AGRP00","AGRP00"})
  aadd(sqlCAMPO,"max(GRPCOD)")
  sqlrelation()

  M_GRPCOD = MAX+1

  setcolor("I")
  @ 12, 25 say     M_GRPCOD   picture "####"
  setcolor("")

  edgrp01()                      && edita dados da fisresa

  if lastkey() = 27
    msg("* * * GRUPO N三 CADASTRADO * * *")
    exit
  endif

  grgrp01("INSERT")
  
  msg("* * * GRUPO INCLUIDO * * *")

enddo

return ""

***************
function altgrp
***************

    do while .t.

      M_GRPCOD = 0
      M_GRPNOM = space(40)
      M_GRPMAR = 0

      tlgrp01() 

      rodape("ALTERA","GRUPOS",M_FAN,"EAGRO15","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 12, 25 get     M_GRPCOD   picture "####"
        read

        if M_GRPCOD = 0
          exit
        endif

        grgrp01("SELECT")

        if eof()
          msg("* * * GRUPO N三 CADASTRADO * * *")
          loop
        endif

        msgrp01()

        M_GRPNOM = GRPNOM
        M_GRPMAR = GRPMAR

        edgrp01()                      

        if lastkey() = 27
          msg("* * * GRUPO N三 ALTERADO * * *")
          loop
        endif

        grgrp01("UPDATE")
        
        msg("* * * GRUPO ALTERADO * * *")

    enddo

return ""

***************
function CONGRP
***************
        
    do while .t.

      M_GRPCOD = 0
      M_GRPNOM = space(40)
      M_GRPMAR = 0

      tlgrp01() 

      rodape("CONSULTA","GRUPOS",M_FAN,"EAGRO15","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 12, 25 get     M_GRPCOD   picture "####"
        read
       
        if lastkey() = 27
          exit
        endif

        if M_GRPCOD = 0
          SetColor(_COREDICAO_)
          @ 13, 25 get     M_GRPNOM   picture "@!"
          read
          if empty(M_GRPNOM)
            exit
          endif
          sqlRELATION = {}
          sqlCAMPO = {}
          sqlCHAVE =  {}
          sqlARQUI = {}
          sqlORDEM = {}

          aadd(sqlARQUI,{"AGRP00","AGRP00"})
          aadd(sqlCAMPO,"*")
          aadd(sqlCHAVE,"GRPNOM LIKE " + aspas(alltrim(M_GRPNOM) + "%"))
          aadd(sqlORDEM,"GRPNOM")
          sqlrelation()
        else
          grgrp01("SELECT")
        endif

        select AGRP00

        do while .t.

          msgrp01()

          waitstate()

          if lastkey() = 5
             skip - 1
          endif         

          if lastkey() = 24
            skip + 1
          endif

          if eof() 
            go top
          endif

          if bof()
            go bottom
          endif

          if lastkey() = 27
            exit
          endif

        enddo 

        set cursor on

     enddo

return ""

***************
function excgrp
***************
        
private M_OPC

    do while .t.

      M_GRPCOD = 0
      M_GRPNOM = space(40)
      M_GRPMAR = 0

      tlgrp01() 

      rodape("EXCLUI","GRUPOS",M_FAN,"EAGRO15","Mem: " + str(memory(0), 5),M_EMP) 

        store 0 to M_GRPCOD
        @ 12, 25 get     M_GRPCOD   picture "####"
        read
       
        if M_GRPCOD = 0
          exit
        endif

        select AGRP00

        if !dbseek(str(M_GRPCOD, 4, 0))
          msg("* * * GRUPO N三 CADASTRADO * * *")
          loop
        endif

        msgrp01()

        if !rlock()
          msg("* * * (AGRP00) REGISTRO SENDO USADO * * *")
          loop 
        endif
     
        M_OPC = confirma("deste Grupo")

        if M_OPC != 1
          msg("* * * GRUPO N三 EXCLUIDO * * *")
          unlock
          loop
        endif

        if lastkey() = 27
          msg("* * * GRUPO N三 EXCLUIDO * * *")      
          loop
        endif    

        elimina() 

        msg("* * * GRUPO EXCLUIDO * * *")

    enddo

return ""

***************
function LISGRP
*************** 

private M_TELA
 
    do while .t.

        rodape("LISTA","GRUPOS",M_FAN,"EAGRO15","Mem: " + str(memory(0), 5),M_EMP) 

        store 0        to M_GRP1,;
                          M_GRP2

         M_VALOR = " "
         M_DTAINV = date()
         M_DESC = 0

         sombra(09, 13, 12, 33,_SOMBRA_)

         set color to GR+/W
           @ 09, 13 say "ﾚﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄｿ" 
           @ 10, 13 say "ｳGrupo Inicial:     ｳ" 
           @ 11, 13 say "ｳ        Final:     ｳ" 
           @ 12, 13 say "ｳValores S/N  :     ｳ" 
           @ 13, 13 say "ﾀﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾙ"
         set color to  
           @ 10, 29 get M_GRP1 picture "####"  
           @ 11, 29 get M_GRP2 picture "####"   
           @ 12, 29 get M_VALOR picture "@!#"   valid M_VALOR $ "SN"
           read

        if lastkey() = 27
            return ""
        endif

        M_GRP1 = iif(M_GRP1 = 0,    1,M_GRP1)
        M_GRP2 = iif(M_GRP2 = 0,9999,M_GRP2) 

       
        if M_VALOR == "S"
          select AGRP00
          set order to 0

          do while !eof()
            if rlock()
              replace VALOR with 0
              unlock
            endif  
            skip
          enddo
          set order to 1

          atualiza_inv("GRUPO")
        endif

        select AGRP00

        go top

        set softseek on
          seek str(M_GRP1, 4, 0)
        set softseek off

        if GRPCOD > M_GRP2
          msg("* * * NADA A LISTAR NO INTERVALO * * *")
          loop
        endif

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

    store 0 to PG

    do while !eof()

        store PG + 1 to PG

        if PG > 1
            eject
        endif

        ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE GRUPOS","EAGRO15",132) 
        ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
        ? "*----*-------------------------------------*----*-------------------------------------*----*---------------------------------------*"
        ? "*COD * DESCRICAO                           *COD *  DESCRICAO                          *COD * DESCRICAO                             *"
        ? "*----*-------------------------------------*----*-------------------------------------*----*---------------------------------------*"
*           9999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXX 9999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  9999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99.999 

        store 5 to LN

        do while !eof() .and. LN < 60
          
            ? " "
              store 1 to CL
              do while !eof() .and. CL < 4
                if  GRPCOD > M_GRP2
                  go bottom
                  skip
                  loop
                endif 
                ?? str(GRPCOD, 4, 0)
                ?? " "
                ?? left(GRPNOM, 26)
                ?? " "
                ?? str(VALOR,10,2)
                if CL < 3
                  ?? " "
                endif
                CL = CL + 1
                skip
              enddo
  
            LN = LN + 1

            M_ESC = inkey()

            if M_ESC = 27
                if susimp()
                  ? replicate("-", 132)
                  ? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                else
                  M_ESC = inkey()
                endif
            endif

        enddo

    enddo

    ? replicate("-", 132)

    eject

desliga1()
enddo 

return "" 

****************
function TLGRP01
****************

nbox(11, 13, 15, 66,"W/W+",.t.)
setcolor("B/W")
    @ 12, 14 say     "C｢digo   :                                          "
    @ 13, 14 say     "Descri℡o:                                          "
    @ 14, 14 say     "Margem   :                                          "
set color to

return ""

****************
function EDGRP01
****************

  SetColor(_COREDICAO_)

    @ 13, 25 get     M_GRPNOM picture "@!"    
    @ 14, 25 get     M_GRPMAR picture "##.###"
    read

return ""

****************
function MSGRP01
****************

  set color to I
    @ 12, 25 say     GRPCOD picture "####"  
    @ 13, 25 say     GRPNOM picture "@!"    
    @ 14, 25 say     GRPMAR picture "##.###"
  set color to
  
return ""

****************
function GRGRP01(cACAO)
****************

sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"AGRP00",cACAO}

aadd(sqlCHAVE,{"GRPCOD",str(M_GRPCOD,4)})

if !cACAO $ "#DELETE#SELECT#"
   aadd(sqlCAMPO,{"GRPCOD",str(M_GRPCOD,4),.t.})
   aadd(sqlCAMPO,{"GRPNOM",M_GRPNOM,.t.})
   aadd(sqlCAMPO,{"GRPMAR",str1(M_GRPMAR,2),.t.})
endif

executasql()

return ""
