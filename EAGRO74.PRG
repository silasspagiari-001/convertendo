***************
function MANAGE
***************

#include "ptmenu.ch"

private M_OPC ,;
        M_TELA

    do while .t.

      rodape("MENU","AGENDA",M_FAN,"EAGRO74","Mem: " + str(memory(0), 5),M_EMP) 

      sombra(04, 60, 11, 70,_SOMBRA_)

      set color to N/BG
        @ 4, 60, 11, 70 box M_FRAME1a
      set color to W+/BG,W+/N
        @ 05, 61 prompt "Inclus„o " HIGHLITE R/BG  PERMITE 4,7,1         
        @ 06, 61 prompt "Altera‡„o" HIGHLITE R/BG  PERMITE 4,7,2              
        @ 07, 61 prompt "Consulta " HIGHLITE R/BG  PERMITE 4,7,3              
        @ 08, 61 prompt "Exclus„o " HIGHLITE R/BG  PERMITE 4,7,4              
        @ 09, 61 prompt "Listagem " HIGHLITE R/BG  PERMITE 4,7,5              
        @ 10, 61 prompt "Outros   " HIGHLITE R/BG  PERMITE 4,7,6              
        menu to M_OPC
      set color to

      M_TELA = savescreen(02, 04, 21, 77)

      do case
         case M_OPC = 0
              exit
         case M_OPC = 1 ; incage()
         case M_OPC = 2 ; altage()
         case M_OPC = 3 ; conage()
         case M_OPC = 4 ; excage()
         case M_OPC = 5 ; lisage()
         case M_OPC = 6 ; outage()
      endcase

      restscreen(02, 04, 21, 77, M_TELA)

    enddo

return ""

***************
function INCAGE
***************

    do while .t.

      M_AGEEMP  = ME_EMP
      M_AGEDTA  = ctod("  /  /  ")
      M_AGEHOR  = space(04)
      M_AGELID  = space(04)
      M_AGERES  = "N"
      M_AGENOM  = M_LOGNOM
      M_AGEOB1  = space(50)
      M_AGEOB2  = space(50)
      M_AGEOB3  = space(50)
      M_AGEOB4  = space(50)
      M_AGEOB5  = space(50)


      tlage01() 

      rodape("INCLUI","AGENDA",M_FAN,"EAGRO74","Mem: " + str(memory(0), 5),M_EMP) 

        set color to I
            @ 10, 24 say M_AGENOM picture "@!" 

        SetColor(_COREDICAO_)
        @ 08, 24 get     M_AGEDTA  valid(verage01(M_AGEDTA))
        @ 09, 24 get     M_AGEHOR  picture "@R 99:99" valid verage02()
        read

        if M_AGEDTA = ctod("  /  /  ") .or. lastkey() = 27
          exit
        endif

        select AAGE00

        if dbseek(str(M_AGEEMP, 2, 0) + M_AGENOM + dtos(M_AGEDTA) + M_AGEHOR)
          msg("* * * AGENDA JA CADASTRADA * * *")
           loop
        endif

        edage01()                      && edita dados da agenda

        if lastkey() = 27
          msg("* * * AGENDA NAO INCLUIDA * * *")
          loop
        endif

        _append("AAGE00")
     
        grage01()                      && grava dados da agenda
        
        msg("* * * AGENDA INCLUIDA * * *")

    enddo

    if AEMP00->EMPSEN == "S"
      acha_agenda()
    endif

return ""

***************
function ALTAGE
***************
        
    do while .t.

      tlage01() 

      M_AGEEMP = ME_EMP
      M_AGEDTA = ctod("  /  /  ")
      M_AGEHOR = space(04)
      M_AGENOM = M_LOGNOM

      rodape("ALTERA","AGENDA",M_FAN,"EAGRO74","Mem: " + str(memory(0), 5),M_EMP) 

      set color to I
        @ 10, 24 say M_AGENOM picture "@!" 
        SetColor(_COREDICAO_)

      @ 08, 24 get     M_AGEDTA   valid(verage01(M_AGEDTA))
      @ 09, 24 get     M_AGEHOR   picture "@R 99:99" valid verage02()
      read
       
      if M_AGEDTA = ctod("  /  /  ") .or. lastkey() = 27
        exit
      endif

      select AAGE00
    
      if !dbseek(str(M_AGEEMP, 2, 0) + M_AGENOM + dtos(M_AGEDTA) + M_AGEHOR)
        msg("* * * AGENDA NAO CADASTRADA * * *")
        loop
      endif

      msage01()                      && mostra dados da agenda

      if !rlock()
        msg("* * * (AAGE00) REGISTRO SENDO USADO * * *")
        loop
      endif

      M_AGEEMP  = AGEEMP
      M_AGEDTA  = AGEDTA
      M_AGEHOR  = AGEHOR
      M_AGENOM  = AGENOM
      M_AGELID  = AGELID
      M_AGERES  = AGERES
      M_AGEOB1  = AGEOB1
      M_AGEOB2  = AGEOB2
      M_AGEOB3  = AGEOB3
      M_AGEOB4  = AGEOB4
      M_AGEOB5  = AGEOB5
      M_DTAANT  = AGEDTA
      M_HORANT  = AGEHOR

      edage02() 

      if !dtos(M_AGEDTA) = dtos(AGEDTA) .or. !M_AGEHOR = AGEHOR
        if dbseek(str(M_AGEEMP, 2, 0) + M_AGENOM + dtos(M_AGEDTA) + M_AGEHOR)
          msg("* * * HORA JA CADASTRADA * * *")
          loop
        else
          dbseek(str(M_AGEEMP, 2, 0) + M_AGENOM + dtos(M_DTAANT) + M_HORANT)
        endif
      endif

      if lastkey() = 27
        msg("* * * AGENDA NAO ALTERADA * * *")
        unlock
        loop 
      endif

      grage01()                      && grava dados do ageefone

      msg("* * * AGENDA ALTERADA * * *")

    enddo

return ""

***************
function CONAGE
***************
        
    do while .t.

      tlage01() 

        M_AGEEMP  = ME_EMP
        M_AGEDTA  = date()
        M_AGEHOR  = space(04)
        M_AGENOM  = M_LOGNOM

        rodape("CONSULTA","AGENDA",M_FAN,"EAGRO74","Mem: " + str(memory(0), 5),M_EMP) 

        set color to I
          @ 10, 24 say M_AGENOM picture "@!" 
        SetColor(_COREDICAO_)

        @ 08, 24 get     M_AGEDTA  valid(verage01(M_AGEDTA))
        read

        if lastkey() = 27
          exit
        endif

        select AAGE00

        dbseek(str(ME_EMP, 2, 0) + M_AGENOM + dtos(M_AGEDTA), .t.) 

        setas()

        do while .t.

          if !AGENOM==M_LOGNOM
            dbskip(+1)
            M_TECLA = inkey(0)
            if M_TECLA = 27
              exit
            endif
            loop
          endif


          iif(empty(AGEEMP),dbseek(str(ME_EMP, 2, 0) + M_LOGNOM + dtos(M_AGEDTA), .t.),"")
   
          ( msage01() , inkey(0) )

          if lastkey() = 27
            exit
          endif

          iif(lastkey()=5 ,dbskip(-1),"")
          iif(lastkey()=24,dbskip(+1),"")
          iif(eof(),dbgotop(),"")
          iif(bof(),dbgobottom(),"")

        enddo 

        setcursor(1)

        @ 24, 00 clear
 
    enddo


return ""

***************
function EXCAGE
***************
        
private  M_OPC
             
    do while .t.


      M_AGEEMP  = ME_EMP
      M_AGEDTA  = ctod("  /  /  ")
      M_AGEHOR  = space(04)
      M_AGENOM  = M_LOGNOM

      tlage01() 
 
        rodape("EXCLUI","AGENDA",M_FAN,"EAGRO74","Mem: " + str(memory(0), 5),M_EMP) 

        set color to I
            @ 10, 24 say M_AGENOM picture "@!" 
        SetColor(_COREDICAO_)

        @ 08, 24 get     M_AGEDTA  valid(verage01(M_AGEDTA))
        @ 09, 24 get     M_AGEHOR  picture "@R 99:99" valid verage02()
        read

        if M_AGEDTA = ctod("  /  /  ") .or. lastkey() = 27
          exit
        endif

        select AAGE00

        if !dbseek(str(M_AGEEMP, 2, 0) + M_LOGNOM + dtos(M_AGEDTA) + M_AGEHOR)
          msg("* * * AGENDA NAO ENCONTRADA * * *")
          loop
        endif
        
        msage01()

        if !rlock()
          msg("* * * (AAGE00) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_OPC = confirma("desta Agenda")

        if M_OPC != 1
          msg("* * * AGENDA NAO EXCLUIDA * * *")
          unlock
          loop
        endif
        elimina()

        msg("* * * AGENDA EXCLUIDA * * *")

    enddo

    if AEMP00->EMPSEN == "S"
      acha_agenda()
    endif

return ""

***************
function LISAGE
*************** 

    if AEMP00->EMPSEN == "S"
      acha_agenda()
    endif

private LN      ,;
        PG      ,;
        M_ESC   ,;
        M_AGEA
 
    do while .t.

        rodape("LISTA","AGENDA",M_FAN,"EAGRO74","Mem: " + str(memory(0), 5),M_EMP) 
 
        store ctod("  /  /  ")   to M_AGEINI
        store ctod("  /  /  ")   to M_AGEFIN
       
        store space(04)     to M_DDDINI,;
                               M_DDDFIN


       sombra(10, 40, 13, 64,_SOMBRA_)

       set color to GR+/W+ 
         @ 10, 40 say                 "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"   
         @ 11, 40 say                 "³Data Inicial:          ³" 
         @ 12, 40 say                 "³       Final:          ³" 
         @ 13, 40 say                 "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
        SetColor(_COREDICAO_)

        @ 11, 55 get M_AGEINI
        @ 12, 55 get M_AGEFIN
        read

        if lastkey() = 27
            return ""
        endif

        M_AGEINI = iif(dtoc(M_AGEINI) = "  /  /  ",ctod("01/01/80"),M_AGEINI)
        M_AGEFIN = iif(dtoc(M_AGEFIN) = "  /  /  ",ctod("31/12/79"),M_AGEFIN)
 
        M_DDDINI = iif(empty(M_DDDINI),"1111",M_DDDINI)
        M_DDDFIN = iif(empty(M_DDDFIN),"9999",M_DDDFIN)


        select AAGE00
         
        set order to 2
         
        go top

        dbseek(str(ME_EMP, 2, 0) + dtos(M_AGEINI),.t.)

        if str(ME_EMP, 2, 0) + dtos(M_AGEFIN) < str(AGEEMP, 2, 0) + dtos(AGEDTA)
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

        ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE AGENDAS","EAGRO74",132) 
        ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
        ? "*--------*------*----------*-------------------------------------------------------------------------------------------------------*"
        ? "*  DATA  * HORA *   NOME   *                                               COMPROMISSOS                                            *"
        ? "*--------*------*----------*-------------------------------------------------------------------------------------------------------*"
*           99/99/99 99:99  XXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  

        store 5 to LN

        do while !eof() .and. LN < 60

          if str(ME_EMP, 2, 0) +  dtos(M_AGEFIN) < str(AGEEMP, 2, 0) + dtos(AGEDTA)
            go bottom
            skip
            loop
          endif 

          if !AGENOM==M_LOGNOM
            dbskip(+1)
            loop
          endif

          ? " "
            ?? AGEDTA
            ?? "  "
            ?? AGEHOR
            ?? "   "
            ?? pad(AGENOM, 10)
            ?? " "
            ?? AGEOB1
            ?? "  "
            ?? AGEOB2
          ? space(29)
            ?? AGEOB3
            ?? " "
            ?? AGEOB4

          LN = LN+2

          skip

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

    if AEMP00->EMPSEN == "S"
      acha_agenda()
    endif

enddo 

return "" 

***************
function OUTAGE
*************** 

private M_NOME ,;
        M_NOME1,;
        K      ,; 
        Y      ,;
        L      ,;
        M_TELA ,;
        M_TECLA,;
        M_CURSOR

private MT_AGE[09] 
declare MT_AGE[09]
 
    M_TELA = savescreen(06, 05, 20, 75) 

    M_CURSOR = setcursor()

    setcursor(1)

    do while .t.

      tlfunage()

      L = 9  

      M_NOME = teclando(30, 07, 27," GR+/BG+")

      if lastkey() = 27
        exit
      endif

      M_TECLA = 32

      if empty(ctod(M_NOME))
        M_NOME = ctod("01/01/80")
      else
        M_NOME = ctod(M_NOME) 
      endif

      select AAGE00

      go top

      dbsetorder(2)

      dbseek(str(ME_EMP, 2, 0) + dtos(M_NOME), .t.)

        if eof()
          loop
        endif

        @ 24, 00 clear

        for S = 1 to 9
          MT_AGE[S] = "        ³     ³                                     ³     ³ ³       ³" 
        next

        do while !eof()

            if !AGENOM == M_LOGNOM
              dbskip(+1)
              loop
            endif

            if AGERES == "S"
              dbskip(+1)
              loop
            endif           

            MT_AGE[L - 8] = dtoc(AGEDTA) + "³" + transform(AGEHOR,"@R 99:99") + "³" + pad(AGEOB1, 37) + "³" + transform(AGELID,"@R 99:99") + "³" + pad(AGERES, 1) + "³" + pad(diasem(AGEDTA), 7) + "³" 

            if L > 16
              M_TECLA = visualage(MT_AGE)
              if M_TECLA = 27
                exit
              endif
              if M_TECLA = 13
                exit
              endif
              if M_TECLA = 18
                skip - 15
              endif
              set color to GR+/BG+
                for K = 9 to 17 
                  @ K, 05 say "³        ³     ³                                     ³     ³ ³       ³" 
                next
              set color to 
              for S = 1 to 9
                MT_AGE[S] =  "        ³     ³                                     ³     ³ ³       ³" 
              next
              L = 8
            endif

            L = L + 1

            skip

        enddo

       L = L - 1

       if M_TECLA = 13
         exit
       endif  

       if M_TECLA != 27 
         if M_TECLA != 13
           visualage(MT_AGE)
         endif
       endif

       if lastkey() = 13
         exit
       endif  

       setcursor(1)

    enddo

    set relation to
    set order to 1

    iif(M_CURSOR=0,setcursor(0),setcursor(1))	

    restscreen(06, 05, 20, 75, M_TELA) 

return ""

*****************
function TLFUNAGE
*****************

  sombra(06, 05, 18, 74,_SOMBRA_)

  set color to GR+/BG+

    @ 06, 05 say     "ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAgendaÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÂÄÄÄÄÄÄÄ¿" 
    @ 07, 05 say     "³  Data  ³Hora ³Data:                                ³Lido ³S³Semana ³" 
    @ 08, 05 say     "ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÅÄÅÄÄÄÄÄÄÄ´" 
    for zz = 9 to 17
    @ zz, 05 say     "³        ³     ³                                     ³     ³ ³       ³" 
    next
    @ 18, 05 say     "ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÁÄÄÄÄÄÄÄÙ" 
  set color to
   
return ""

******************
function VISUALAGE
******************

parameters V1 

private S      ,;
        M_OPC  ,;
        M_AREA ,;
        M_TELA ,;
        M_POSI

  M_AREA = alias()


  do while .t.

    set color to GR+/BG+,N/W
      M_OPC = achoice(09,6,18,73,V1,,"mostra")
    set color to 

    if rat(str(lastkey(), 2, 0)," 3#27#18") > 0
      exit
    endif

    if rat(str(lastkey(), 2, 0),"13#") > 0
      M_POSI = str(ME_EMP, 2, 0) + M_LOGNOM + dtos(AGEDTA) + AGEHOR
      AAGE00->(dbseek(str(ME_EMP, 2, 0) + M_LOGNOM + dtos(ctod(substr(V1[M_OPC], 1, 8))) + substr(V1[M_OPC], 10, 2) + substr(V1[M_OPC], 13, 2)))
      M_TELA = savescreen(07, 13, 18, 65)       
      tlage01()
      set color to R+/R
        @ 08, 24 say AGEDTA  
        @ 08, 43 say diasem(AGEDTA)
        @ 09, 24 say AGEHOR picture "@R 99:99"
        @ 10, 24 say AGENOM picture "@!"
        @ 10, 43 say AGELID picture "@R 99:99"
        @ 10, 62 say AGERES picture "@!" 
        @ 12, 14 say AGEOB1 picture "@!"
        @ 13, 14 say AGEOB2 picture "@!"
        @ 14, 14 say AGEOB3 picture "@!"
        @ 15, 14 say AGEOB4 picture "@!"
      set color to
      ( setcursor(0),inkey(0),setcursor(1) )
      restscreen(07, 13, 18, 65, M_TELA)       
      (dbsetorder(1) , dbseek(M_POSI, .t.))
      loop
    endif
  
    exit

  enddo

  select &M_AREA

  @ 24, 00 clear

return lastkey()

****************
function TLAGE01
****************

sombra(7, 13, 17, 64,_SOMBRA_)

set color to I
    @ 07, 13 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
    @ 08, 13 say     "³Data    :            Semana:                      ³"
    @ 09, 13 say     "³Hora    :                                         ³"
    @ 10, 13 say     "³Nome    :              Lido:        Resolvido:    ³"
    @ 11, 13 say     "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄCompromissosÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
    for zz = 12 to 16
    @ zz, 13 say     "³                                                  ³"
    next
    @ 17, 13 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
set color to

return ""

****************
function EDAGE01
****************

  SetColor(_COREDICAO_)
  @ 10, 43 get M_AGELID picture "@R 99:99"
  @ 10, 62 get M_AGERES picture "@!" valid (M_AGERES $ "SN")
  @ 12, 14 get M_AGEOB1 picture "@!"
  @ 13, 14 get M_AGEOB2 picture "@!"
  @ 14, 14 get M_AGEOB3 picture "@!"
  @ 15, 14 get M_AGEOB4 picture "@!"
  @ 16, 14 get M_AGEOB5 picture "@!"
  read
 
return ""

****************
function EDAGE02
****************

  SetColor(_COREDICAO_)
  @ 08, 24 get M_AGEDTA  valid(verage01(M_AGEDTA))
  @ 09, 24 get M_AGEHOR picture "@R 99:99" valid verage02()
  @ 10, 43 get M_AGELID picture "@R 99:99"
  @ 10, 62 get M_AGERES picture "@!" valid (M_AGERES $ "SN")
  @ 12, 14 get M_AGEOB1 picture "@!"
  @ 13, 14 get M_AGEOB2 picture "@!"
  @ 14, 14 get M_AGEOB3 picture "@!"
  @ 15, 14 get M_AGEOB4 picture "@!"
  @ 16, 14 get M_AGEOB5 picture "@!"
  read
 
return ""

****************
function MSAGE01
****************

  set color to I
    @ 08, 24 say AGEDTA
    @ 08, 24 get M_AGEDTA  valid(verage01(M_AGEDTA))  
    @ 09, 24 say AGEHOR picture "@R 99:99"
    @ 10, 24 say AGENOM picture "@!"
    @ 10, 43 say AGELID picture "@R 99:99"
    @ 10, 62 say AGERES picture "@!"
    @ 12, 14 say AGEOB1 picture "@!"
    @ 13, 14 say AGEOB2 picture "@!"
    @ 14, 14 say AGEOB3 picture "@!"
    @ 15, 14 say AGEOB4 picture "@!"
    @ 16, 14 say AGEOB5 picture "@!"
  set color to
  
return ""

****************
function GRAGE01                       && grava dados da agenda
****************

  do while .t.
    if rlock()
      replace AGEEMP with M_AGEEMP  
      replace AGEDTA with M_AGEDTA  
      replace AGEHOR with M_AGEHOR  
      replace AGENOM with M_AGENOM  
      replace AGELID with M_AGELID  
      replace AGERES with M_AGERES  
      replace AGEOB1 with M_AGEOB1
      replace AGEOB2 with M_AGEOB2
      replace AGEOB3 with M_AGEOB3
      replace AGEOB4 with M_AGEOB4
      replace AGEOB5 with M_AGEOB5
      unlock   
      commit
      exit
    else
      msg("* * * (AAGE00) REGISTRO SENDO USADO * * *") 
    endif
    if lastkey()=17
      exit
    endif
  enddo

return ""

*****************
function VERAGE01
*****************

parameters M_AGE

if empty(M_AGE)
  return .t.
endif

set color to I
  @ 08, 43 say diasem(M_AGE)
set color to

return .t.

*****************
function VERAGE02
*****************

if val(left(M_AGEHOR, 2)) < 0 .or.  val(left(M_AGEHOR, 2)) > 23
  msg("* * * HORA INVALIDA * * *")
  return .f.
endif

if val(right(M_AGEHOR, 2)) < 0 .or.  val(right(M_AGEHOR, 2)) > 59
  msg("* * * MINUTO INVALIDO * * *")
  return .f.
endif

return .t.

