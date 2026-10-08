***************
function MANTEL
***************

#include "ptmenu.ch"

abre_tel("2")

private M_OPC ,;
        M_TELA

    do while .t.

      rodape("MENU","TELEFONE",M_FAN,"EAGRO46","Mem: " + str(memory(0), 5),M_EMP) 

      sombra(04, 40, 11, 50,_SOMBRA_)

      set color to N/BG
        @ 4, 40, 11, 50 box M_FRAME1a
      set color to W+/BG,W+/N
        @ 05, 41 prompt "Inclus„o " HIGHLITE R/BG     
        @ 06, 41 prompt "Altera‡„o" HIGHLITE R/BG     
        @ 07, 41 prompt "Consulta " HIGHLITE R/BG     
        @ 08, 41 prompt "Exclus„o " HIGHLITE R/BG     
        @ 09, 41 prompt "Listagem " HIGHLITE R/BG     
        @ 10, 41 prompt "Outros   " HIGHLITE R/BG     
        menu to M_OPC
      set color to

      M_TELA = savescreen(02, 04, 22, 77)

      do case
         case M_OPC = 0
              exit
         case M_OPC = 1
              inctel()
         case M_OPC = 2
              alttel()
         case M_OPC = 3
              contel()
         case M_OPC = 4
              exctel()
         case M_OPC = 5
              listel()
         case M_OPC = 6
              outtel()
      endcase

      restscreen(02, 04, 22, 77, M_TELA)

    enddo

    fecha_arq()

return ""

***************
function INCTEL
***************

    do while .t.

      M_TELNUM  = space(08)
      M_TELDDD  = space(04)
      M_TELNOM  = space(40)
      M_TELEND  = space(40)
      M_TELCEP  = space(09)
      M_TELMUN  = space(18)
      M_TELEST  = space(02)
      M_TELOB1  = space(48)
      M_TELOB2  = space(48)
      M_TELOB3  = space(48)
      M_TELOB4  = space(48)
      M_TELSITE = space(40)
      M_TELEMAIL= space(40)

      tltel01() 

      rodape("INCLUI","TELEFONE",M_FAN,"EAGRO46","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 08, 24 get     M_TELNUM   picture "@!"
        @ 08, 34 get     M_TELDDD   picture "@R 9999" valid(!empty(M_TELDDD))
        read

        if empty(M_TELNUM) .or. lastkey() = 27
          exit
        endif

        select ATEL00

        if dbseek(M_TELNUM + M_TELDDD)
          msg("* * * TELEFONE JA CADASTRADO * * *")
          loop
        endif

        edtel01(.f.)                      && edita dados da agenda

        if lastkey() = 27
          msg("* * * TELEFONE NAO INCLUIDO * * *")
          loop
        endif
       
        _append("ATEL00")
     
        grtel01()                      && grava dados da agenda
        
        msg("* * * TELEFONE INCLUIDO * * *")

    enddo

return ""

***************
function ALTTEL
***************
        
    do while .t.

    tltel01() 

    M_TELNUM = space(08)
    M_TELDDD = space(04)

    rodape("ALTERA","TELEFONE",M_FAN,"EAGRO46","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
      @ 08, 24 get     M_TELNUM   picture "@!"
      @ 08, 34 get     M_TELDDD   picture "@R 9999" valid(!empty(M_TELDDD))
      read
       
      if empty(M_TELNUM) .or. lastkey() = 27
        exit
      endif

      select ATEL00
    
      if !dbseek(M_TELNUM + M_TELDDD)
        msg("* * * TELEFONE NAO CADASTRADO * * *")
        loop
      endif

      mstel01()                      && mostra dados do telefone

      if !rlock()
        msg("* * * (ATEL00) REGISTRO SENDO USADO * * *")
        loop
      endif

      M_TELNUM  = TELNUM
      M_TELDDD  = TELDDD
      M_TELNOM  = TELNOM
      M_TELEND  = TELEND
      M_TELCEP  = TELCEP
      M_TELMUN  = TELMUN
      M_TELEST  = TELEST
      M_TELOB1  = TELOB1
      M_TELOB2  = TELOB2
      M_TELOB3  = TELOB3
      M_TELOB4  = TELOB4
      M_TELSITE = TELSITE  
      M_TELEMAIL= TELEMAIL
 
      edtel01(.t.) 

      if lastkey() = 27
        msg("* * * TELEFONE NAO ALTERADO * * *")
        unlock
        loop 
      endif

      grtel01()                      && grava dados do telefone

      msg("* * * TELEFONE ALTERADO * * *")

    enddo

return ""

***************
function CONTEL
***************
        
    do while .t.

      tltel01() 

        M_TELNUM  = space(08)
        M_TELDDD  = space(04)
        M_TELNOM  = space(40)
        M_TELMUN  = space(18)

        rodape("CONSULTA","TELEFONE",M_FAN,"EAGRO46","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 08, 24 get M_TELNUM picture "@!"
        @ 08, 34 get M_TELDDD picture "@!"
        read

        if lastkey() = 27
          exit
        endif

        select ATEL00

        if empty(M_TELNUM + M_TELDDD)
        SetColor(_COREDICAO_)
          @ 09, 24 get M_TELNOM picture "@!"
          read
          if empty(M_TELNOM)
            @ 11, 24 get M_TELMUN picture "@!"
            read                 
            if empty(M_TELMUN)
              loop
            else
              (dbsetorder(3), dbseek(M_TELMUN,.t.))
            endif
          else
            (dbsetorder(2), dbseek(M_TELNOM,.t.))
          endif
        else
          (dbsetorder(1), dbseek(M_TELNUM + M_TELDDD,.t.))
        endif

        setas()

        do while .t.

          mstel01()

          inkey(0)

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
    
        ( setcursor(1) , dbsetorder(1) ) 

    enddo

return ""

***************
function EXCTEL
***************
        
private  M_OPC
             
    do while .t.

      M_TELNUM = space(08)
      M_TELDDD = space(04)

      tltel01() 
 
        rodape("EXCLUI","TELEFONE",M_FAN,"EAGRO46","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 08, 24 get     M_TELNUM   picture "@!"
        @ 08, 34 get     M_TELDDD   picture "@R 9999" valid(!empty(M_TELDDD))
        read

        if empty(M_TELNUM) .or. lastkey() = 27
          exit
        endif

        select ATEL00

        if !dbseek(M_TELNUM + M_TELDDD)
          msg("* * * TELEFONE NAO CADASTRADO * * *")
          loop
        endif
        
        mstel01()

        if !rlock()
          msg("* * * (ATEL00) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_OPC = confirma("deste Telefone")

        if M_OPC != 1
          msg("* * * TELEFONE NAO EXCLUIDO * * *")
          unlock
          loop
        endif
        elimina()

        msg("* * * TELEFONE EXCLUIDO * * *")

        set order to 1 

    enddo


return ""

***************
function LISTEL
*************** 

private LN      ,;
        PG      ,;
        M_ESC   ,;
        M_TELA
 
    do while .t.

        rodape("LISTA","TELEFONE",M_FAN,"EAGRO46","Mem: " + str(memory(0), 5),M_EMP) 
 
        store space(08)     to M_TELINI,;
                               M_TELFIN
        store space(04)     to M_DDDINI,;
                               M_DDDFIN
       
       sombra(10, 29, 13, 63,_SOMBRA_)

       set color to GR+/W+
         @ 10, 29 say             "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
         @ 11, 29 say             "³Telefone Inicial:          (    )³" 
         @ 12, 29 say             "³           Final:          (    )³" 
         @ 13, 29 say             "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
       set color to 

        SetColor(_COREDICAO_)
        @ 11, 48 get M_TELINI picture "@!"
        @ 11, 58 get M_DDDINI picture "@!"   
        @ 12, 48 get M_TELFIN picture "@!"   
        @ 12, 58 get M_DDDFIN picture "@!"   
        read

        if lastkey() = 27
            return ""
        endif
 
        M_TELINI = iif(empty(M_TELINI),"11111111",M_TELINI)
        M_TELFIN = iif(empty(M_TELFIN),"99999999",M_TELFIN)

        M_DDDINI = iif(empty(M_DDDINI),"1111",M_DDDINI)
        M_DDDFIN = iif(empty(M_DDDFIN),"9999",M_DDDFIN)

        select ATEL00
        set order to 8
     
        go top

        dbseek(M_DDDINI + M_TELINI,.t.) 

        if TELDDD + TELNUM > M_DDDFIN + M_TELFIN
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

        ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE TELEFONES","EAGRO46",132) 
        ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
        ? "*---------------*--------------------------------------*-------------------------------------*------------------------*---------*--*"
        ? "*   TELEFONE    *                NOME                  *              ENDERECO               *         CIDADE         *   CEP   *UF*"
        ? "*---------------*--------------------------------------*-------------------------------------*------------------------*---------*--*"
*           (9999) 999-9999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXX XX  

        store 5 to LN

        do while !eof() .and. LN < 60

          if  TELDDD + TELNUM > M_DDDFIN + M_TELFIN
            go bottom
            skip
            loop
          endif 

            ? " "
              ?? transform(TELDDD,"@R (9999)")
              ?? " "
              ?? TELNUM
              ?? " "
              ?? pad(TELNOM, 38)
              ?? " "
              ?? pad(TELEND, 37)
              ?? " "
              ?? pad(TELMUN, 24) 
              ?? " "
              ?? TELCEP
              ?? " "  
              ?? TELEST 

            LN++

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

enddo 

return "" 

***************
function OUTTEL
*************** 

private M_NOME ,;
        M_NOME1,;
        K      ,; 
        Y      ,;
        L      ,;
        M_TELA ,;
        M_TECLA,;
        M_CURSOR

private MT_TEL[09],MT_OBS1[09],MT_OBS2[09]
declare MT_TEL[09],MT_OBS1[09],MT_OBS2[09]
 
    M_TELA = savescreen(06, 05, 20, 75) 

    M_CURSOR = setcursor()

    setcursor(1)

    do while .t.

      tlfuntel()

      L = 9  

      M_NOME = teclando(30, 07, 17," GR+/BG+")

      if lastkey() = 27
        exit
      endif

      M_LEFT  = space(01)
      M_TECLA = 32

      select ATEL00

      go top

      if left(M_NOME, 1) = "&" .or. left(M_NOME, 1) = "$"
        M_LEFT = left(M_NOME, 1)
        M_NOME = substr(M_NOME, 2,(len(M_NOME) - 1))
      endif

      if M_LEFT == "&"
        (dbsetorder(1) , dbseek(M_NOME, .t.))
      else
        if !M_LEFT == "$"
          (dbsetorder(2) , dbseek(M_NOME, .t.))
        endif
      endif

        if eof()
          loop
        endif

        for S = 1 to 9
          MT_TEL[S] =  "    ³                                        ³        ³             ³" 
          MT_OBS1[S] =  space(40)
          MT_OBS2[S] =  space(40)
        next

        do while !eof()

          if M_LEFT = "$"
            if !alltrim(M_NOME) $ alltrim(TELNOM)
              M_ESC = inkey()
              if M_ESC = 27
                exit 
              endif
              skip
              loop
            endif
          else
            if empty(TELNUM)
              skip
              loop
            endif
          endif

            MT_TEL[L - 8] = pad(TELDDD, 4) + "³" + pad(TELNOM, 40) + "³" + pad(TELNUM, 08) + "³" + pad(TELMUN, 13) + "³" 
            MT_OBS1[L - 8] = TELSITE
            MT_OBS2[L - 8] = TELEMAIL

            if L > 16
              M_TECLA = visualtel(MT_TEL,MT_OBS1,MT_OBS2)
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
                  @ K, 05 say "³    ³                                        ³        ³             ³" 
                next
              set color to 
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
           visualtel(MT_TEL,MT_OBS1,MT_OBS2)
         endif
       endif

       if lastkey() = 13
         exit
       endif  

       setcursor(1)

    enddo

    ATEL00->(dbsetorder(1))

    iif(M_CURSOR=0,setcursor(0),setcursor(1))	

    restscreen(06, 05, 20, 75, M_TELA) 

return ""


*****************
function TLFUNTEL
*****************

  sombra(06, 05, 21, 74,_SOMBRA_)

  set color to GR+/BG+

    @ 06, 05 say     "ÚÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄTelefonesÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
    @ 07, 05 say     "³DDD ³Nome:                                   ³Telefone³   Cidade    ³" 
    @ 08, 05 say     "ÃÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´" 
    for zz = 9 to 17
    @ zz, 05 say     "³    ³                                        ³        ³             ³" 
    next
    @ 18, 05 say     "ÃÄÄÄÄÁÄÄÄÄÄ Informacoes para Internet ÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´" 
    @ 19, 05 say     "³site   :                                                            ³" 
    @ 20, 05 say     "³e-mail :                                                            ³" 
    @ 21, 05 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
  set color to
   
return ""

******************
function VISUALTEL
******************

parameters V1,V2,V3

private S      ,;
        M_OPC  ,;
        M_AREA ,;
        M_TELA ,;
        M_POSI

  M_AREA = alias()


  do while .t.

    setcolor("B/BG")
      @ 19, 15 say V2[1]
      @ 20, 15 say V3[1]
    set color to GR+/BG+,N/W
      M_OPC = achoice(09,6,18,73,V1,,"mostratel")
    set color to 

    if rat(str(lastkey(), 2, 0)," 3#27#18") > 0
      exit
    endif

    if rat(str(lastkey(), 2, 0),"13#") > 0
      M_POSI = TELNOM
      ATEL00->(dbsetorder(1),dbseek(substr(V1[M_OPC], 47, 8) + TELDDD))
      M_TELA = savescreen(07, 13, 18, 65)       
      tltel01()
      set color to R+/R
        @ 08, 24 say TELNUM picture "@!"
        @ 08, 34 say TELDDD picture "@R 9999"
        @ 09, 24 say TELNOM picture "@!"
        @ 10, 24 say TELEND picture "@!"
        @ 11, 24 say TELMUN picture "@!"
        @ 11, 48 say TELCEP picture "@!"
        @ 11, 62 say TELEST picture "@!" 
        @ 13, 15 say TELOB1 picture "@!"
        @ 14, 15 say TELOB2 picture "@!"
        @ 15, 15 say TELOB3 picture "@!"
        @ 16, 15 say TELOB4 picture "@!"
        @ 18, 22 say TELSITE
        @ 19, 22 say TELEMAIL
      set color to
      ( setcursor(0),inkey(0),setcursor(1) )
      restscreen(07, 13, 18, 65, M_TELA)       
      if M_LEFT == "&"
        (dbsetorder(1) , dbseek(M_POSI, .t.))
      else
        if !M_LEFT == "$"
          (dbsetorder(2) , dbseek(M_POSI, .t.))
        endif
      endif
      loop
    endif
  
    exit

  enddo

  select &M_AREA


return lastkey()

****************
function TLTEL01
****************

sombra(7, 13, 20, 64,_SOMBRA_)

set color to I
    @ 07, 13 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
    @ 08, 13 say     "³Telefone:          (    )                         ³"
    @ 09, 13 say     "³Nome    :                                         ³"
    @ 10, 13 say     "³Endereco:                                         ³"
    @ 11, 13 say     "³Cidade  :                    Cep:           Uf:   ³"
    @ 12, 13 say     "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄObservacoesÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
    for zz = 13 to 16
    @ zz, 13 say     "³                                                  ³"
    next
    @ 17, 13 say     "ÃÄÄÄÄÄÄÄÄÄÄÄ Informacoes para Internet ÄÄÄÄÄÄÄÄÄÄÄÄ´"
    @ 18, 13 say     "³site  :                                           ³"
    @ 19, 13 say     "³e-mail:                                           ³"
    @ 20, 13 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
set color to

return ""

****************
function EDTEL01(TIPO)
****************

        SetColor(_COREDICAO_)
    if TIPO
      @ 08, 24 get     M_TELNUM   picture "@!"
      @ 08, 34 get     M_TELDDD   picture "@R 9999" valid(!empty(M_TELDDD))
    endif
    @ 09, 24 get M_TELNOM picture "@!"
    @ 10, 24 get M_TELEND picture "@!"
    @ 11, 24 get M_TELMUN picture "@!"
    @ 11, 48 get M_TELCEP picture "@!"
    @ 11, 62 get M_TELEST picture "@!" valid verest(M_TELEST)
    @ 13, 15 get M_TELOB1 picture "@!"
    @ 14, 15 get M_TELOB2 picture "@!"
    @ 15, 15 get M_TELOB3 picture "@!"
    @ 16, 15 get M_TELOB4 picture "@!"
    @ 18, 22 get M_TELSITE
    @ 19, 22 get M_TELEMAIL
    read
 
return ""

****************
function MSTEL01
****************

  set color to I
    @ 08, 24 say TELNUM picture "@!"
    @ 08, 34 say TELDDD picture "@R 9999"
    @ 09, 24 say TELNOM picture "@!"
    @ 10, 24 say TELEND picture "@!"
    @ 11, 24 say TELMUN picture "@!"
    @ 11, 48 say TELCEP picture "@!"
    @ 11, 62 say TELEST picture "@!" 
    @ 13, 15 say TELOB1 picture "@!"
    @ 14, 15 say TELOB2 picture "@!"
    @ 15, 15 say TELOB3 picture "@!"
    @ 16, 15 say TELOB4 picture "@!"

    @ 18, 22 say TELSITE
    @ 19, 22 say TELEMAIL
  set color to
  
return ""

****************
function GRTEL01                       && grava dados da agenda
****************

  do while .t.
    if rlock()
      replace TELNUM with M_TELNUM  
      replace TELDDD with M_TELDDD  
      replace TELNOM with M_TELNOM  
      replace TELEND with M_TELEND  
      replace TELCEP with M_TELCEP  
      replace TELMUN with M_TELMUN  
      replace TELEST with M_TELEST  
      replace TELSITE with M_TELSITE
      replace TELEMAIL with M_TELEMAIL
      if !empty(M_TELOB1)
        replace TELOB1 with M_TELOB1
      endif 
      if !empty(M_TELOB2)
        replace TELOB2 with M_TELOB2
      endif 
      if !empty(M_TELOB3)
        replace TELOB3 with M_TELOB3
      endif 
      if !empty(M_TELOB4)
        replace TELOB4 with M_TELOB4
      endif 
      unlock   
      commit
      exit
    else
      msg("* * * (ATEL00) REGISTRO SENDO USADO * * *") 
    endif
    if lastkey()=17
      exit
    endif
  enddo

return ""

******************
function MOSTRATEL
******************

parameters  M_MODO, M_ELEM, M_POSI

 if rat(str(lastkey(), 2, 0),"27") > 0
   return 0
 endif

 setcolor("B/BG")
 @ 19, 15 say V2[M_ELEM]
 @ 20, 15 say V3[M_ELEM]
 set color to GR+/BG+,N/W
return 2
