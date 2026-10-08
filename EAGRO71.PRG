#include "ptmenu.ch"

***************
function MANMSG
***************

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

nbox(05, 04, 17, 88,"W/W+",.t.)
setcolor("B/W")
@ 06, 05 say     " Mensagem no corpo da Nota Fiscal                                                 "
@ 07, 05 say     " 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 "
@ 08, 05 say     "                                                                                  "
@ 09, 05 say     "                                                                                  "
@ 10, 05 say     "                                                                                  "
@ 11, 05 say     "                                                                                  "
@ 12, 05 say     "                                                                                  "
@ 13, 05 say     "                                                                                  "
@ 14, 05 say     "                                                                                  "
@ 15, 05 say     "                                                                                  "
@ 16, 05 say     "                                                                                  "
set color to

if file("ANOTA.MSG")
  restore from ANOTA.MSG additive
endif

SetColor(_COREDICAO_)


@ 08, 06 get XMSG_1&MS
@ 09, 06 get XMSG_2&MS
@ 10, 06 get XMSG_3&MS
@ 11, 06 get XMSG_4&MS
@ 12, 06 get XMSG_5&MS
@ 13, 06 get XMSG_6&MS
@ 14, 06 get XMSG_7&MS
@ 15, 06 get XMSG_8&MS
@ 16, 06 get XMSG_9&MS
read

save all like XMSG* to ANOTA.MSG


***************
function MANCVE
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("MENU","CONVENIO",M_FAN,"EAGRO71","Mem: " + str(memory(0), 5),M_EMP)

*        @ 05, 61 prompt "Inclusao " HIGHLITE R/BG PERMITE 1,7,1
*        @ 06, 61 prompt "Alteracao" HIGHLITE R/BG PERMITE 1,7,2
*        @ 07, 61 prompt "Consulta " HIGHLITE R/BG PERMITE 1,7,3
*        @ 08, 61 prompt "Exclusao " HIGHLITE R/BG PERMITE 1,7,4
*        @ 09, 61 prompt "Listagem " HIGHLITE R/BG PERMITE 1,7,5

      do case
         case M_OPC = 1 ; inccve()
         case M_OPC = 2 ; altcve()
         case M_OPC = 3 ; concve()
         case M_OPC = 4 ; exccve()
         case M_OPC = 5 ; liscve()
      endcase

    fecha_arq()

return ""

***************
function INCCVE
***************

    do while .t.

      M_CVECOD = space(01)
      M_CVEEST = space(02)
      M_CVENOM = space(60)

      mocve01() 

      rodape("INCLUI","CONVENIO",M_FAN,"EAGRO71","Mem: " + str(memory(0), 5),M_EMP)

        SetColor(_COREDICAO_)
        @ 13, 14 get     M_CVECOD   picture "@!"
        @ 13, 27 get     M_CVEEST   picture "@!" valid vercve01()
        read

        if M_CVECOD = " " .or. lastkey() = 27
            exit
        endif

        select ACVE00

        if dbseek(M_CVEEST + M_CVECOD)
          msg("* * * CONVENIO  JA CADASTRADO * * *")
          loop
        endif

        edcve01()             

        if lastkey() = 27
          msg("* * * CONVENIO NAO CADASTRADO * * *")
          loop
        endif

        select ACVE00

        _append("ACVE00")

        grcve01()
        
        msg("* * * CONVENIO INCLUIDO * * *")

    enddo

return ""

***************
function ALTCVE
***************
        
    do while .t.

        M_CVECOD = " "
        M_CVEEST = "  "

      mocve01() 

      rodape("ALTERA","CONVENIO",M_FAN,"EAGRO71","Mem: " + str(memory(0), 5),M_EMP)

        SetColor(_COREDICAO_)
        @ 13, 14 get     M_CVECOD   picture "@!"
        @ 13, 27 get     M_CVEEST   picture "@!" valid vercve01()
        read

        if M_CVECOD = " " .or. lastkey() = 27
            exit
        endif

        select ACVE00

        if !dbseek(M_CVEEST + M_CVECOD)
          msg("* * * CONVENIO NAO CADASTRADO * * *")
          loop
        endif

        mscve01()

        if !rlock()
          msg("* * * (ACVE00) REGISTRO SENDO USADO * * *")
          loop 
        endif

        M_CVECOD = CVECOD
        M_CVEEST = CVEEST
        M_CVENOM = CVENOM

        edcve01()                      

        if lastkey() = 27
          msg("* * * CONVENIO NAO ALTERADO * * *")
          unlock
          loop
        endif

        grcve01()
        
        msg("* * * CONVENIO ALTERADO * * *")

    enddo

return ""

***************
function CONCVE
***************

    do while .t.

        M_CVECOD = " "
        M_CVEEST = "  "
        M_CVENOM = space(60)

      mocve01() 

      rodape("CONSULTA","CONVENIO",M_FAN,"EAGRO71","Mem: " + str(memory(0), 5),M_EMP)

        SetColor(_COREDICAO_)
        @ 13, 14 get     M_CVECOD   picture "@!"
        @ 13, 27 get     M_CVEEST   picture "@!" valid vercve01()
        read
       
        if lastkey() = 27 .or. empty(M_CVECOD+M_CVEEST)
          exit
        endif
 
        set softseek on
          seek M_CVECOD+M_CVEEST
        set softseek off

        setas()

        do while .t.

          if empty(CVECOD+CVEEST)
            skip 
            if eof()
              msg("* * * ARQUIVO VAZIO * * *")
              exit
            endif
            loop
          endif

          mscve01()

          inkey(0)

          if lastkey() = 5
             skip - 1
          endif         

          if lastkey() = 24
            skip 
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
        set order to 1

    enddo

return ""

***************
function EXCCVE
***************

private M_OPC
        
    do while .t.

        M_CVECOD = space(01)
        M_CVEEST = space(02)

      mocve01() 

      rodape("EXCLUI","CONVENIO",M_FAN,"EAGRO71","Mem: " + str(memory(0), 5),M_EMP)

        SetColor(_COREDICAO_)
        @ 13, 14 get     M_CVECOD   picture "@!"
        @ 13, 27 get     M_CVEEST   picture "@!" valid vercve01()
        read

        if lastkey() = 27
          exit
        endif

        select ACVE00

        if !dbseek(M_CVEEST + M_CVECOD)
          msg("* * * CONVENIO NAO CADASTRADO * * *")
          loop
        endif

        mscve01()

        if !rlock()
          msg("* * * (ACVE00) REGISTRO SENDO USADO * * *")
          loop 
        endif

        M_OPC = confirma("deste Convenio")

        if M_OPC != 1
          msg("* * * CONVENIO NAO EXCLUIDO * * *")
          unlock
          loop
        endif
        elimina()

        msg("* * * CONVENIO EXCLUIDO * * *")

    enddo

return ""

***************
function LISCVE
*************** 

private M_CVE1  ,;
        M_CVE2  ,; 
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_TELA
 
    do while .t.

        rodape("LISTA","CONVENIOS",M_FAN,"EAGRO71","Mem: " + str(memory(0), 5),M_EMP)

        store "A"      to M_CVE1
        store "Z"      to M_CVE2
        store "SP"     to M_EST1
        store "OU"     to M_EST2

 nbox(10, 39, 13, 63,"W/W+",.t.)
 setcolor("B/W")
         @ 11, 40 say      "Convenio Inicial:      "
         @ 12, 40 say      "           Final:      "

        SetColor(_COREDICAO_)
        @ 11, 58 get M_EST1 picture "@!"
        @ 11, 60 get M_CVE1 picture "@!"  
        @ 12, 58 get M_EST2 picture "@!"   
        @ 12, 60 get M_CVE2 picture "@!"   

        read

        if lastkey() = 27
          return ""
        endif

        M_CVE1 = iif(M_CVE1 = " ","A",M_CVE1)
        M_CVE2 = iif(M_CVE2 = " ","Z",M_CVE2) 

        M_EST1 = iif(M_EST1 = " ","AA",M_EST1)
        M_EST2 = iif(M_EST2 = " ","ZZ",M_EST2) 

        select ACVE00

        go top

        set softseek on
          seek M_CVE1 + M_EST1
        set softseek off

        if CVECOD + CVEEST > M_CVE2 + M_EST2
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

        ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE CONVENIOS","EAGRO71",132)
        ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
        ? "*-*--*---------------------------------------------------------*-*--*--------------------------------------------------------------*"
        ? "*C*UF* CONVENIO                                                *C*UF* CONVENIO                                                     *"
        ? "*-*--*---------------------------------------------------------*-*--*--------------------------------------------------------------*"
*           X XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX X XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

        store 5 to LN

        do while !eof() .and. LN < 60

          if  CVECOD + CVEEST > M_CVE2 + M_EST2
            go bottom
            skip
            loop
          endif 
          
            ? " "
              store 1 to CL
              do while !eof() .and. CL < 3
                ?? CVECOD
                ?? " "
                ?? CVEEST
                ?? " "
                ?? left(CVENOM, 57)
                ?? " "
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
function MOCVE01
****************

 nbox(12, 04, 15, 74,"W/W+",.t.)
 setcolor("B/W")
    @ 13, 05 say     " Codigo:      Estado:                                                "
    @ 14, 05 say     " Nome  :                                                             "
set color to

return ""

****************
function EDCVE01
****************

    SetColor(_COREDICAO_)
    @ 14, 14 get     M_CVENOM picture "@!"
    read

return ""

****************
function MSCVE01
****************

 setcolor("N/W*")
    @ 13, 14 say     CVECOD picture "@!"
    @ 13, 27 say     CVEEST picture "@!"  
    @ 14, 14 say     CVENOM picture "@!"    
  set color to
  
return ""

****************
function GRCVE01                      
****************

  select ACVE00

  do while .t.
    if rlock()
        replace CVECOD with M_CVECOD 
        replace CVEEST with M_CVEEST 
        replace CVENOM with M_CVENOM 
      unlock   
      commit
      exit
    else
      msg("* * * (AEMP00) REGISTRO SENDO USADO * * *") 
    endif
    if lastkey()=17
      exit
    endif
  enddo

return ""

*****************
function VERCVE01
*****************

if lastkey() = 5
    return .t.
endif

if rat(M_CVEEST,"SP#OU") = 0
  msg("* * * (SP) SAO PAULO  (OU) OUTROS ESTADOS * * *")
  return .f.
endif

return .t.
