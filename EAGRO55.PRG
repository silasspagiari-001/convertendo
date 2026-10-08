#include "ptmenu.ch"

***************
function MANPRD
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("MENU","PRE-DATADO",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP)

*        @ 05, 52 prompt "Inclus„o " HIGHLITE R/BG PERMITE 5,5,1
*        @ 06, 52 prompt "Altera‡„o" HIGHLITE R/BG PERMITE 5,5,2
*        @ 07, 52 prompt "Consultas" HIGHLITE R/BG PERMITE 5,5,3
*        @ 08, 52 prompt "Exclus„o " HIGHLITE R/BG PERMITE 5,5,4
*        @ 09, 52 prompt "Listagens" HIGHLITE R/BG PERMITE 5,5,5
*        @ 10, 52 prompt "Baixa    " HIGHLITE R/BG PERMITE 5,5,6

      do case
         case M_OPC = 1 ; incprd()
         case M_OPC = 2 ; altprd()
         case M_OPC = 3 ; conprd(M_OPC1)
         case M_OPC = 4 ; excprd()
         case M_OPC = 5 ; lisprd(M_OPC1)
         case M_OPC = 6 ; baiprd()
      endcase

    fecha_arq()

return ""

***************
function INCPRD         && inclui Pre-datado  
***************

    do while .t.

        tlprd01()

        rodape("INCLUI","PRE_DATADO ",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

        M_PRDEMP = ME_EMP
        M_PRDCHE = 0
        M_PRDORD = 0
        M_PRDSIT = "A"
        M_PRDDEP = ctod("  /  /  ")
        M_PRDENT = ctod("  /  /  ")
        M_PRDBAN = 0
        M_BCODES = space(40)
        M_PRDDTE = ctod("  /  /  ")
        M_PRDVCT = ctod("  /  /  ")
        M_PRDPOR = space(40)
        M_PRDMUN = space(15)
        M_PRDEST = space(02)
        M_PRDTEL = space(15)       
        M_PRDVLR = 0
        M_PRDCTA = space(13)
        M_PRDHIS = 999
        M_PRDOBS = space(40)

        SetColor(_COREDICAO_)
        @ 09, 26 get     M_PRDCHE  picture "######"
        @ 09, 33 get     M_PRDORD  picture "##"
        read

        if M_PRDCHE = 0
          exit
        endif

        if APRD00->(dbseek(str(M_PRDEMP, 2, 0) + str(M_PRDCHE, 6, 0) + str(M_PRDORD, 2, 0)))
          msg( "* * * CHEQUE JA INCLUIDO * * *")
          loop
        endif

        edprd01()

        if lastkey() = 27
          msg( "* * * CHEQUE NAO INCLUIDO * * *")
          loop 
        endif 
 
        _append("APRD00")

        grprd01()                      && grava cheque pre-datado

        select ABCO00

        if !dbseek(str(M_PRDBAN, 3, 0))
          _append("ABCO00")
           grprd02()
        endif

        msg("* * * CHEQUE INCLUIDO * * *")

    enddo

return ""

***************
function ALTPRD         && altera Pre-datado  
***************

    do while .t.

        tlprd01()

        rodape("ALTERA","PRE_DATADO",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

        M_PRDEMP = ME_EMP
        M_PRDCHE = 0
        M_PRDORD = 0   
       
        SetColor(_COREDICAO_)
        @ 09, 26 get     M_PRDCHE  picture "######"
        @ 09, 33 get     M_PRDORD  picture "##"
        read

        if M_PRDCHE = 0
          exit
        endif

        if !APRD00->(dbseek(str(M_PRDEMP, 2, 0) + str(M_PRDCHE, 6, 0) + str(M_PRDORD, 2, 0)))
          msg( "* * * CHEQUE NAO INCLUIDO * * *")
          loop
        endif

        ABCO00->(dbseek(str(APRD00->PRDBAN, 3, 0)))

        M_PRDEMP = APRD00->PRDEMP
        M_PRDCHE = APRD00->PRDCHE
        M_PRDORD = APRD00->PRDORD
        M_PRDSIT = APRD00->PRDSIT
        M_PRDDEP = APRD00->PRDDEP
        M_PRDENT = APRD00->PRDENT
        M_PRDBAN = APRD00->PRDBAN
        M_PRDDTE = APRD00->PRDDTE
        M_PRDVCT = APRD00->PRDVCT
        M_PRDPOR = APRD00->PRDPOR
        M_PRDMUN = APRD00->PRDMUN
        M_PRDEST = APRD00->PRDEST
        M_PRDTEL = APRD00->PRDTEL
        M_PRDVLR = APRD00->PRDVLR
        M_PRDCTA = APRD00->PRDCTA
        M_PRDHIS = APRD00->PRDHIS
        M_PRDOBS = APRD00->PRDOBS
        M_BCODES = ABCO00->BCODES

        edprd01()

        if lastkey() = 27
          msg( "* * * CHEQUE NAO ALTERADO * * *")
          loop 
        endif 
 
        grprd01()                      && grava pre-datado

        msg("* * * CHEQUE ALTERADO * * *")

    enddo

return ""

***************
function CONPRD         && lista Pre-datado  
***************
parameters M_OPC,M_OPC1,M_OPC2


    rodape("MENU","CONSULTA",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

*      @ 08, 58 prompt "Cheque   " HIGHLITE R/BG
*      @ 09, 58 prompt "Banco    " HIGHLITE R/BG
*      @ 10, 58 prompt "Emissao  " HIGHLITE R/BG
*      @ 11, 58 prompt "Vencidos " HIGHLITE R/BG
*      @ 12, 58 prompt "Cliente  " POSITION 2 HIGHLITE R/BG
*      @ 13, 58 prompt "Valor    " POSITION 2 HIGHLITE R/BG
*      @ 14, 58 prompt "Entrada  " POSITION 2 HIGHLITE R/BG

    do case 
       case M_OPC = 1
         conprd_a()
       case M_OPC = 2
         conprd_b()
       case M_OPC = 3
         conprd_c()
       case M_OPC = 4
         conprd_d()
       case M_OPC = 5
         conprd_e()
       case M_OPC = 6
         conprd_f()
       case M_OPC = 7
         conprd_g()
    endcase

return ""

*****************
function CONPRD_A        && consulta Pre-datado  
*****************

private M_OPC ,;
        M_TELA

  do while .t.

    rodape("CONSULTA","PRE_DATADO ",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

    tlprd01()

    M_PRDEMP = ME_EMP
    M_PRDCHE = 0
    M_PRDORD = 0
    M_PRDBAN = 0
    M_PRDDTE = ctod("  /  /  ")
    M_PRDVCT = ctod("  /  /  ")
    M_PRDPOR = space(40)

    SetColor(_COREDICAO_)
    @ 09, 26 get     M_PRDCHE  picture "######"
    @ 09, 33 get     M_PRDORD  picture "##"
    read

    if lastkey() = 27
      exit
    endif

    if M_PRDCHE = 0
      SetColor(_COREDICAO_)
      @ 10, 26 get     M_PRDBAN  picture "###"
      read
      if lastkey() = 27
        loop
      endif 
      if M_PRDBAN = 0
        SetColor(_COREDICAO_)
        @ 12, 26 get     M_PRDDTE
        read
        if lastkey() = 27
          loop
        endif 
        if empty(M_PRDDTE)
          SetColor(_COREDICAO_)
          @ 12, 53 get     M_PRDVCT
          read
          if lastkey() = 27
            loop
          endif
          if empty(M_PRDVCT)
            SetColor(_COREDICAO_)
            @ 13, 26 get     M_PRDPOR  picture "@!"
            read
            if lastkey() = 27
              exit
            endif
            APRD00->(dbsetorder(5),dbseek(str(M_PRDEMP, 2, 0) + M_PRDPOR,.t.))
          else
            APRD00->(dbsetorder(4),dbseek(str(M_PRDEMP, 2, 0) + dtos(M_PRDVCT),.t.))
          endif
        else
          APRD00->(dbsetorder(3),dbseek(str(M_PRDEMP, 2, 0) + dtos(M_PRDDTE),.t.))
        endif
      else
        APRD00->(dbsetorder(2),dbseek(str(M_PRDEMP, 2, 0) + str(M_PRDBAN, 3, 0),.t.))
      endif 
    else
      APRD00->(dbsetorder(1),dbseek(str(M_PRDEMP, 2, 0) + str(M_PRDCHE, 6, 0),.t.))
    endif

    select APRD00

    setas()
 
    do while !eof()

      if PRDEMP != ME_EMP
        msg("* * * FIM O ARQUIVO * * *")
        loop
      endif

      ( msprd01() , inkey(0) )

      if lastkey() = 27
        exit
      endif

      iif(lastkey()=5 ,dbskip(-1),"")
      iif(lastkey()=24,dbskip(+1),"")

    enddo 

    ( setcursor(1) , dbsetorder(1) , devpos(24, 00) , devout(space(80),"N") )

  enddo

return ""

*****************
function CONPRD_B        && ordem banco          
*****************

  do while .t.

    rodape("CONSULTA","BANCO",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

    tlprd02()

    M_PRDINI = 0
    M_PRDFIN = 0
    M_PRDSIT = "A"

    set color to I
      @ 04, 04 say "Banco:     a     Situacao: "
    SetColor(_COREDICAO_)
    @ 04, 11 get     M_PRDINI  picture "###" valid verprd07()
    @ 04, 17 get     M_PRDFIN  picture "###"
    @ 04, 31 get     M_PRDSIT  picture "@!"
    read

    if lastkey() = 27
      exit
    endif

    M_PRDINI = iif(M_PRDINI = 0,  1,M_PRDINI)
    M_PRDFIN = iif(M_PRDFIN = 0,999,M_PRDFIN)

    mosprd()

  enddo

return ""

*****************
function CONPRD_C        && ordem emissao
*****************

  do while .t.

    rodape("CONSULTA","EMISSAO",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

    tlprd02()

    M_PRDINI = ctod("  /  /  ")
    M_PRDFIN = ctod("  /  /  ")
    M_PRDSIT = "A"

    set color to I
      @ 04, 04 say "Emissao:          a          Situacao: "
    SetColor(_COREDICAO_)
    @ 04, 13 get     M_PRDINI  valid verprd07()
    @ 04, 24 get     M_PRDFIN  
    @ 04, 43 get     M_PRDSIT  picture "@!" 
    read

    if lastkey() = 27
      exit
    endif

    M_PRDINI = iif(empty(M_PRDINI), ctod("01/01/80"),M_PRDINI)
    M_PRDFIN = iif(empty(M_PRDFIN), ctod("31/12/79"),M_PRDFIN)

    mosprd()

  enddo

return ""

*****************
function CONPRD_D        && ordem emissao
*****************

  do while .t.

    rodape("CONSULTA","VENCIDOS",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

    tlprd02()

    M_PRDINI = ctod("  /  /  ")
    M_PRDFIN = ctod("  /  /  ")
    M_PRDSIT = "A"

    set color to I
      @ 04, 04 say "Vencimento:          a          Situacao: "
    SetColor(_COREDICAO_)
    @ 04, 16 get     M_PRDINI valid verprd07()
    @ 04, 27 get     M_PRDFIN  
    @ 04, 46 get     M_PRDSIT picture "@!"
    read

    if lastkey() = 27
      exit
    endif

    M_PRDINI = iif(empty(M_PRDINI), ctod("01/01/80"),M_PRDINI)
    M_PRDFIN = iif(empty(M_PRDFIN), ctod("31/12/79"),M_PRDFIN)

    mosprd()

  enddo

return ""

*****************
function CONPRD_E        && ordem cliente
*****************

  do while .t.

    rodape("CONSULTA","CLIENTE",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

    tlprd02()

    M_PRDINI = space(40)
    M_PRDFIN = space(40)
    M_PRDSIT = "A"

    set color to I
      @ 04, 04 say "Cliente:                      a                      Situacao: "
    SetColor(_COREDICAO_)
    @ 04, 13 get M_PRDINI picture "@!@S20" valid verprd07()
    @ 04, 36 get M_PRDFIN picture "@!@S20"
    @ 04, 67 get M_PRDSIT picture "@!"
    read

    if lastkey() = 27
      exit
    endif

    M_PRDINI = iif(empty(M_PRDINI),                  "A",M_PRDINI)
    M_PRDFIN = iif(empty(M_PRDFIN), "ZZZZZZZZZZZZZZZZZZ",M_PRDFIN)

    mosprd()

  enddo

return ""

*****************
function CONPRD_F        && ordem valor          
*****************

  do while .t.

    rodape("CONSULTA","VALOR",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

    tlprd02()

    M_PRDINI = 0
    M_PRDFIN = 0
    M_PRDSIT = "A"

    set color to I
      @ 04, 04 say "Valor:            a            Situacao: "
    SetColor(_COREDICAO_)
    @ 04, 11 get     M_PRDINI  picture "#######.##" valid verprd07()
    @ 04, 24 get     M_PRDFIN  picture "#######.##"
    @ 04, 45 get     M_PRDSIT  picture "@!"
    read

    if lastkey() = 27 
      exit
    endif

    mosprd()

  enddo

return ""

*****************
function CONPRD_G        && ordem entrada 
*****************

  do while .t.

    rodape("CONSULTA","ENTRADA",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

    tlprd02()

    M_PRDINI = ctod("  /  /  ")
    M_PRDFIN = ctod("  /  /  ")
    M_PRDSIT = "A"

    set color to I
      @ 04, 04 say "   Entrada:          a          Situacao: "
    SetColor(_COREDICAO_)

    @ 04, 16 get     M_PRDINI valid verprd07()
    @ 04, 27 get     M_PRDFIN  
    @ 04, 46 get     M_PRDSIT picture "@!"
    read

    if lastkey() = 27
      exit
    endif

    M_PRDINI = iif(empty(M_PRDINI), ctod("01/01/80"),M_PRDINI)
    M_PRDFIN = iif(empty(M_PRDFIN), ctod("31/12/79"),M_PRDFIN)

    mosprd()

  enddo

return ""

***************
function MOSPRD
***************

  M_PRDMAT = {}

  M_TOTABE = 0
  M_TOTPAG = 0

  R = 1

  select APRD00

  if M_OPC = 2
    ( dbsetorder(2) , dbseek(str(ME_EMP, 2, 0) + str(M_PRDINI, 3, 0), .t.) )
    if eof() .or. str(PRDEMP, 2, 0) + str(PRDBAN, 3, 0) >  str(ME_EMP, 2, 0) + str(M_PRDFIN, 3, 0)
      msg("* * * NADA A CONSULTAR NO INTERVALO * * *")
      return ""
    endif
  endif

  if M_OPC = 3
    ( dbsetorder(3) , dbseek(str(ME_EMP, 2, 0) + dtos(M_PRDINI), .t.) )
    if eof() .or. str(PRDEMP, 2, 0) + dtos(PRDDTE) >  str(ME_EMP, 2, 0) + dtos(M_PRDFIN)
      msg("* * * NADA A CONSULTAR NO INTERVALO * * *")
      return ""
    endif
  endif

  if M_OPC = 4
    ( dbsetorder(4) , dbseek(str(ME_EMP, 2, 0) + dtos(M_PRDINI), .t.) )
    if eof() .or. str(PRDEMP, 2, 0) + dtos(PRDVCT) >  str(ME_EMP, 2, 0) + dtos(M_PRDFIN)
      msg("* * * NADA A CONSULTAR NO INTERVALO * * *")
      return
    endif
  endif

  if M_OPC = 5
    ( dbsetorder(5) , dbseek(str(ME_EMP, 2, 0) + M_PRDINI, .t.) )
    if eof() .or. str(PRDEMP, 2, 0) + PRDPOR > str(ME_EMP, 2, 0) + M_PRDFIN
      msg("* * * NADA A CONSULTAR NO INTERVALO * * *")
      return ""
    endif
  endif

  if M_OPC = 6
    ( dbsetorder(1) , dbseek(str(ME_EMP, 2, 0) + str(1, 6, 0), .t.) )
    if eof() .or. str(PRDEMP, 2, 0) > str(ME_EMP, 2, 0)
      msg("* * * NADA A CONSULTAR NO INTERVALO * * *")
      return ""
    endif
  endif

  if M_OPC = 7
    ( dbsetorder(6) , dbseek(str(ME_EMP, 2, 0) + dtos(M_PRDINI), .t.) )
    if eof() .or. str(PRDEMP, 2, 0) + dtos(PRDENT) >  str(ME_EMP, 2, 0) + dtos(M_PRDFIN)
      msg("* * * NADA A CONSULTAR NO INTERVALO * * *")
      return
    endif
  endif

  do while !eof()

    M_ESC = inkey()
 
    if M_ESC = 27
      M_SAI = decide("Deseja Cancelar o Processamento")
      if M_SAI = 1 
        return ""
      else
        M_ESC = inkey()
      endif
    endif  

    if M_OPC = 2 
      if eof() .or. str(PRDEMP, 2, 0) + str(PRDBAN, 3, 0) > str(ME_EMP, 2, 0) + str(M_PRDFIN, 3, 0)
        exit
      endif
    endif

    if M_OPC = 3 
      if eof() .or. str(PRDEMP, 2, 0) + dtos(PRDDTE) > str(ME_EMP, 2, 0) + dtos(M_PRDFIN)
        exit
      endif
    endif

    if M_OPC = 4 
      if eof() .or. str(PRDEMP, 2, 0) + dtos(PRDVCT) > str(ME_EMP, 2, 0) + dtos(M_PRDFIN)
        exit
      endif
    endif

    if M_OPC = 5 
      if eof() .or. str(PRDEMP, 2, 0) + PRDPOR > str(ME_EMP, 2, 0) + M_PRDFIN
        exit
      endif
    endif

    if M_OPC = 6 
      if eof() .or. str(PRDEMP, 2, 0)  > str(ME_EMP, 2, 0)
        exit
      endif
      if PRDVLR < M_PRDINI .or. PRDVLR > M_PRDFIN 
        skip
        loop
      endif
    endif

    if M_OPC = 7 
      if eof() .or. str(PRDEMP, 2, 0) + dtos(PRDENT) > str(ME_EMP, 2, 0) + dtos(M_PRDFIN)
        exit
      endif
    endif

    if !empty(M_PRDSIT)
      if !PRDSIT == M_PRDSIT
         skip
         loop
      endif
    endif

    ABCO00->(dbseek(str(APRD00->PRDBAN, 3, 0)))

    if R <= 4000
      aadd(M_PRDMAT,{space(70)})
      M_PRDMAT[R, 1] = str(PRDCHE, 6, 0) + "³" + str(PRDORD, 2, 0) + "³" + dtoc(PRDDTE) + "³" + dtoc(PRDVCT) + "³" + dtoc(PRDDEP) + "³" + pad(str(PRDBAN, 3, 0) + " " + alltrim(ABCO00->BCODES), 23) + "³" + PRDSIT + "³" + transform(PRDVLR,"@E ###,###.##")
    endif

    if PRDSIT = "A" 
      M_TOTABE = M_TOTABE + PRDVLR
    else
      M_TOTPAG = M_TOTPAG + PRDVLR
    endif

    R = R + 1

    msw("* * * AGUARDE ... PROCESSANDO (ESC) Abandona -=> " + str(R, 5) + " * * *")

    skip

  enddo

  setaprd()

  if len(M_PRDMAT) < 8
    declare M_VETORITE[8]
  else
    declare M_VETORITE[len(M_PRDMAT)]
  endif

  for S = 1 to len(M_PRDMAT)
   M_VETORITE[S] = M_PRDMAT[S,1]
   if empty(M_PRDMAT[S,1])
     M_VETORITE[S] = "      ³  ³        ³        ³        ³                      ³ ³          "
   endif
  next

  set color to I 
    @ 17, 63 say M_TOTABE          picture "@E ##,###,###.##"
    @ 18, 63 say M_TOTPAG          picture "@E ##,###,###.##"
    @ 19, 63 say M_TOTABE+M_TOTPAG picture "@E ##,###,###.##"
  set color to 

  do while .t.

    if len(M_PRDMAT) = 0
      exit
    endif

    APRD00->( dbsetorder(1) , (dbseek(str(ME_EMP, 2, 0) + str(val(substr(M_VETORITE[1], 1, 6)), 6, 0) + str(val(substr(M_VETORITE[1], 8, 2)), 2, 0))) )

    set color to GR+/B+
      @ 17, 15 say pad(PRDPOR, 39)
      @ 18, 15 say pad(alltrim(PRDMUN) + " " + PRDEST + " "  + dtoc(PRDENT) + " " + alltrim(PRDTEL), 39)
      @ 19, 15 say pad(PRDOBS, 39)
    set color to I

    set color to N/W,W+/N
      M_ACHO = achoice(08,03,15,75,M_VETORITE,,"achprd")
    set color to 

    if lastkey() = 27
      exit        
    endif

  enddo


  APRD00->(dbsetorder(1))

  set relation to

  set cursor on

return ""

***************
function EXCPRD         && exclui Pre-datado  
***************

private M_PRDEMP ,;     && codigo da empresa
        M_PRDCHE ,;   
        M_PRDORD ,;
        M_TELA   ,;
        M_OPC

    do while .t.

        tlprd01()

        rodape("EXCLUI","PRE_DATADO ",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

        M_PRDEMP = ME_EMP
        M_PRDCHE = 0
        M_PRDORD = 0

        SetColor(_COREDICAO_)
        @ 09, 26 get     M_PRDCHE  picture "######"
        @ 09, 33 get     M_PRDORD  picture "##"
        read

        if M_PRDCHE = 0
          exit
        endif

        if !APRD00->(dbseek(str(M_PRDEMP, 2, 0) + str(M_PRDCHE, 6, 0) + str(M_PRDORD, 2, 0)))
          msg( "* * * CHEQUE NAO INCLUIDO * * *")
          loop
        endif
 
        APRD00->(msprd01())
        
        M_OPC = confirma("do Cheque")

        if M_OPC != 1
          msg("* * * CHEQUE NAO EXCLUIDO * * *")
          loop
        endif

        select APRD00
 
        if !rlock()
          msg("* * * (APRD00) REGISTRO SENDO USADO * * *")
          loop
        endif

        elimina()

        msg("* * * CHEQUE EXCLUIDO * * *")

enddo

return ""

***************
function LISPRD         && lista Pre-datado  
***************
parameters M_OPC,M_OPC1,M_OPC2

    rodape("MENU","LISTA",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

*      @ 08, 58 prompt "Cheque   " HIGHLITE R/BG
*      @ 09, 58 prompt "Banco    " HIGHLITE R/BG
*      @ 10, 58 prompt "Emissao  " HIGHLITE R/BG
*      @ 11, 58 prompt "Vencidos " HIGHLITE R/BG
*      @ 12, 58 prompt "Cliente  " HIGHLITE R/BG
*      @ 13, 58 prompt "Entrada  " HIGHLITE R/BG

    do case 
       case M_OPC = 1
         lisprd_a()
       case M_OPC = 2
         lisprd_b()
       case M_OPC = 3
         lisprd_c()
       case M_OPC = 4
         lisprd_d()
       case M_OPC = 5
         lisprd_e()
       case M_OPC = 6
         lisprd_f()
    endcase

return ""

*****************
function LISPRD_A         && lista Pre-datado ordem cheque  
*****************

  do while .t.

    rodape("LISTA","CHEQUES",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

    store 0 to M_CHEINI,;
               M_CHEFIN,;
               M_ORDINI,;
               M_ORDFIN,;
               M_TOTCHE,;
               M_GERCHE

    store "A" to M_PRDSIT

 nbox(14, 31, 18, 58,"W/W+",.t.)
 setcolor("B/W")
      @ 15, 32 say           "Cheque Inicial:       /   "
      @ 16, 32 say           "         Final:       /   "
      @ 17, 32 say           "      Situacao:           "

    SetColor(_COREDICAO_)
    @ 15, 48 get M_CHEINI picture "######"
    @ 15, 55 get M_ORDINI picture "##"
    @ 16, 48 get M_CHEFIN picture "######"
    @ 16, 55 get M_ORDFIN picture "##"
    @ 17, 48 get M_PRDSIT picture "@!" valid verprd05()
    read

    if lastkey() = 27
      exit
    endif

    M_CHEINI = iif(M_CHEINI=0,     1,M_CHEINI)
    M_ORDINI = iif(M_ORDINI=0,     0,M_ORDINI)
    M_CHEFIN = iif(M_CHEFIN=0,999999,M_CHEFIN)
    M_ORDFIN = iif(M_ORDFIN=0,    99,M_ORDFIN)

    select APRD00

    set relation to str(PRDBAN, 3, 0) into ABCO00

    dbseek(str(ME_EMP, 2, 0) + str(M_CHEINI, 6, 0) + str(M_ORDINI, 2, 0),.t.)

    if str(PRDEMP, 2, 0) + str(PRDCHE, 6, 0) + str(PRDORD, 2 , 0) > str(ME_EMP, 2, 0) + str(M_CHEFIN, 6, 0) + str(M_ORDFIN, 2, 0)
      msg("* * * NADA A LISTAR NO INTERVALO * * *")   
      exit
    endif

    private M_ESC ,;
            LN    ,;
            PG

    M_IMPRE = impresn()

    if M_IMPRE = "N"
      return ""
    endif

    store 0   to   PG ,;
                   LN 

    store " " to   BR  

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(15)                        && comprime
    endif
          
    do while !eof()  
          
      store PG + 1 to  PG 

       if PG > 1
         eject
       endif

          ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE PRE-DATADO","EAGRO55",132) 
          ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
          ? "*---------*-------------------------*--------*--------*--------*------------------------------------*---------------*--*-----------*"
          ? "*  CHEQUE *      BANCO              *EMISSAO * VENCTO *DEPOSITO* CLIENTE                            *   MUNICIPIO   *UF*  VALOR    *"
          ? "*---------*-------------------------*--------*--------*--------*------------------------------------*---------------*--*-----------*"
*             999999/99 99999 XXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XX ####,###.##

          store 5 to LN
  
          do while !eof() .and. LN < 60 
 
            if str(PRDEMP, 2, 0) + str(PRDCHE, 6, 0) + str(PRDORD, 2, 0) > str(ME_EMP, 2, 0) + str(M_CHEFIN, 6, 0) + str(M_ORDFIN, 2, 0)
              go bottom
              skip 
              loop 
            endif
        
            if M_PRDSIT != PRDSIT
              skip
              loop
            endif 

            ? space(01)
              ?? str(PRDCHE, 6, 0)
              ?? "/"
              ?? str(PRDORD, 2, 0)
              ?? " " 
              ?? str(PRDBAN, 5, 0)
              ?? " "
              ?? pad(ABCO00->BCODES, 19)
              ?? " "
              ?? PRDDTE
              ?? " "
              ?? PRDVCT
              ?? " "
              ?? PRDDEP
              ?? " "
              ?? padl(PRDPOR, 36)
              ?? " "  
              ?? PRDMUN
              ?? " "
              ?? PRDEST
              ?? " "
              ?? transform(PRDVLR,"@E ####,###.##")
           
            M_TOTCHE = M_TOTCHE + PRDVLR
            M_GERCHE = M_GERCHE + PRDVLR

            LN++

            M_ESC = inkey()

            if M_ESC = 27
              if susimp() 
                ? space(15)
                 ?? replicate("-", 132)
                ? space(15)
                 ?? "* * * IMPRESSAO SUSPENSA * * *"
                go bottom
                skip
              else
                M_ESC = inkey()
              endif
            endif
 
            skip

          enddo     

        enddo
  
    ? space(90)
      ?? "TOTAL DOS CHEQUES . . . . ."
      ?? transform(M_TOTCHE,"@E ###,###,###.##")
    ? replicate("-", 132)
    ? space(90)
      ?? "TOTAL GERAL DOS CHEQUES . ."
      ?? transform(M_GERCHE,"@E ###,###,###.##")

    eject

desliga1()

  enddo
 
return ""

*****************
function LISPRD_B         && lista Pre-datado ordem banco
*****************

  do while .t.

    rodape("LISTA","CHEQUES",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

    store 0 to M_BANINI,;
               M_BANFIN,;
               M_TOTCHE,;
               M_GERCHE

    store "A" to M_PRDSIT

 nbox(14, 31, 18, 58,"W/W+",.t.)
 setcolor("B/W")
      @ 15, 32 say           " Banco Inicial:           "
      @ 16, 32 say           "         Final:           "
      @ 17, 32 say           "      Situacao:           "
    SetColor(_COREDICAO_)

    @ 15, 48 get M_BANINI picture "#####"
    @ 16, 48 get M_BANFIN picture "#####"
    @ 17, 48 get M_PRDSIT picture "@!" valid verprd05()
    read

    if lastkey() = 27
      exit
    endif

    M_BANINI = iif(M_BANINI=0,     1,M_BANINI)
    M_BANFIN = iif(M_BANFIN=0, 99999,M_BANFIN)

    select APRD00

    set relation to str(PRDBAN, 3, 0) into ABCO00

    set order to 2

    dbseek(str(ME_EMP, 2, 0) + str(M_BANINI, 5, 0),.t.)

    if str(PRDEMP, 2, 0) + str(PRDBAN, 3, 0) > str(ME_EMP, 2, 0) + str(M_BANFIN, 5, 0)
      msg("* * * NADA A LISTAR NO INTERVALO * * *")   
      exit
    endif

    private M_ESC ,;
            LN    ,;
            PG    ,;
            M_BANANT

    M_IMPRE = impresn()

    if M_IMPRE = "N"
      return ""
    endif

    store 0   to   PG ,;
                   LN 

    store " " to   BR

    store 0   to   M_BANANT

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(15)                        && comprime
    endif
          
    do while !eof()  
          
      store PG + 1 to  PG 

       if PG > 1
         eject
       endif

          ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE PRE-DATADO","EAGRO55",132) 
          ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
          ? "*---------*-------------------------*--------*--------*-----------------------------*---------------*--*---------------*-----------*"
          ? "*  CHEQUE *      BANCO              *EMISSAO * VENCTO * CLIENTE                     *   MUNICIPIO   *UF*   TELEFONE    *  VALOR    *"
          ? "*---------*-------------------------*--------*--------*-----------------------------*---------------*--*---------------*-----------*"
*             999999/99 99999 XXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXX ####,###.##

          store 5 to LN
  
          do while !eof() .and. LN < 60 
 
            if str(PRDEMP, 2, 0) + str(PRDBAN, 3, 0) > str(ME_EMP, 2, 0) + str(M_BANFIN, 5, 0)
              go bottom
              skip 
              loop 
            endif

            if M_PRDSIT != PRDSIT
              skip
              loop
            endif 

            if PRDBAN != M_BANANT
              if M_TOTCHE > 0
                ? space(90)
                  ?? "TOTAL DOS CHEQUES . . . . ."
                  ?? transform(M_TOTCHE,"@E ###,###,###.##")
                ? replicate("-", 132)
              endif 
              ? " "    
                ?? str(PRDBAN, 5, 0)
                ?? " - " 
                ?? ABCO00->BCODES
              ?      
              M_TOTCHE = 0
              M_BANANT = PRDBAN 
              LN = LN + 4 
            endif

            ? space(01)
              ?? str(PRDCHE, 6, 0)
              ?? "/"
              ?? str(PRDORD, 2, 0)
              ?? " " 
              ?? str(PRDBAN, 5, 0)
              ?? " "
              ?? pad(ABCO00->BCODES, 19)
              ?? " "
              ?? PRDDTE
              ?? " "
              ?? PRDVCT
              ?? " "
              ?? padl(PRDPOR, 29)
              ?? " "  
              ?? PRDMUN
              ?? " "
              ?? PRDEST
              ?? " "
              ?? PRDTEL
              ?? " "
              ?? transform(PRDVLR,"@E ####,###.##")

            LN++

            M_TOTCHE = M_TOTCHE + PRDVLR
            M_GERCHE = M_GERCHE + PRDVLR

            M_ESC = inkey()

            if M_ESC = 27
              if susimp()
                ? space(15)
                  ?? replicate("-", 132)
                ? space(15)
                  ?? "* * * IMPRESSAO SUSPENSA * * *"
                go bottom
                skip
              else
                M_ESC = inkey()
              endif
            endif
 
            skip

          enddo     

        enddo
  
    ? space(90)
      ?? "TOTAL DOS CHEQUES . . . . ."
      ?? transform(M_TOTCHE,"@E ###,###,###.##")
    ? replicate("-", 132)
    ? space(90)
      ?? "TOTAL GERAL DOS CHEQUES . ."
      ?? transform(M_GERCHE,"@E ###,###,###.##")

    eject

desliga1()

  enddo
 
return ""

*****************
function LISPRD_C         && lista Pre-datado ordem data de emissao
*****************

  local SEMANA[7]

  SEMANA[1]="Domingo"
  SEMANA[2]="Segunda"
  SEMANA[3]="Terca  "
  SEMANA[4]="Quarta "
  SEMANA[5]="Quinta "
  SEMANA[6]="Sexta  "
  SEMANA[7]="Sabado "

  do while .t.

    rodape("LISTA","CHEQUES",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

    store ctod("  /  /  ") to M_DTEINI,;
                              M_DTEFIN
    store 0                to M_TOTCHE,;
                              M_GERCHE
    

    store "A" to M_PRDSIT

 nbox(14, 31, 18, 58,"W/W+",.t.)
 setcolor("B/W")
      @ 15, 32 say           "Emissao Inicial:          "
      @ 16, 32 say           "          Final:          "
      @ 17, 32 say           "       Situacao:          "
    SetColor(_COREDICAO_)

    @ 15, 49 get M_DTEINI 
    @ 16, 49 get M_DTEFIN 
    @ 17, 49 get M_PRDSIT picture "@!" valid verprd05()
    read

    if lastkey() = 27
      exit
    endif

    M_DTEINI = iif(dtoc(M_DTEINI) = "  /  /  ",ctod("01/01/80"),M_DTEINI)
    M_DTEFIN = iif(dtoc(M_DTEFIN) = "  /  /  ",ctod("31/12/79"),M_DTEFIN)

    select APRD00

    set order to 3

    dbseek(str(ME_EMP, 2, 0) + dtos(M_DTEINI),.t.)

    if str(PRDEMP, 2, 0) + dtos(PRDDTE) > str(ME_EMP, 2, 0) + dtos(M_DTEFIN)
      msg("* * * NADA A LISTAR NO INTERVALO * * *")   
      exit
    endif

    private M_ESC ,;
            LN    ,;
            PG

    M_IMPRE = impresn()

    if M_IMPRE = "N"
      return ""
    endif

    store 0   to   PG ,;
                   LN 

    store " " to   BR

    store ctod("  /  /  ") to M_DTEANT

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(15)                        && comprime
    endif
          
    do while !eof()  
          
      store PG + 1 to  PG 

       if PG > 1
         eject
       endif

          ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE PRE-DATADO","EAGRO55",132) 
          ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
          ? "*---------*-------------------------*--------*--------*-----------------------------*---------------*--*---------------*-----------*"
          ? "*  CHEQUE *      BANCO              *EMISSAO * VENCTO * CLIENTE                     *   MUNICIPIO   *UF*   TELEFONE    *  VALOR    *"
          ? "*---------*-------------------------*--------*--------*-----------------------------*---------------*--*---------------*-----------*"
*             999999/99 99999 XXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXX ####,###.##

          store 5 to LN
  
          do while !eof() .and. LN < 60 
 
            if str(PRDEMP, 2, 0) + dtos(PRDDTE) > str(ME_EMP, 2, 0) + dtos(M_DTEFIN)
              go bottom
              skip 
              loop 
            endif

            if M_PRDSIT != PRDSIT
              skip
              loop
            endif 

            if PRDDTE != M_DTEANT
              if M_TOTCHE > 0
                ? space(90)
                  ?? "TOTAL DOS CHEQUES . . . . ."
                  ?? transform(M_TOTCHE,"@E ###,###,###.##")
                ? replicate("-", 132)
              endif 
              ? " "    
                ?? PRDDTE
                ?? " - " 
                ?? SEMANA[dow(PRDDTE)]
              ?      
              M_TOTCHE = 0
              M_DTEANT = PRDDTE 
              LN = LN + 4 
            endif

            ? space(01)
              ?? str(PRDCHE, 6, 0)
              ?? "/"
              ?? str(PRDORD, 2, 0)
              ?? " " 
              ?? str(PRDBAN, 5, 0)
              ?? " "
              ?? pad(ABCO00->BCODES, 19)
              ?? " "
              ?? PRDDTE
              ?? " "
              ?? PRDVCT
              ?? " "
              ?? padl(PRDPOR, 29)
              ?? " "  
              ?? PRDMUN
              ?? " "
              ?? PRDEST
              ?? " "
              ?? PRDTEL
              ?? " "
              ?? transform(PRDVLR,"@E ####,###.##")

            LN++

            M_TOTCHE = M_TOTCHE + PRDVLR
            M_GERCHE = M_GERCHE + PRDVLR

            M_ESC = inkey()

            if M_ESC = 27
                if susimp()
                  ? space(15)
                    ?? replicate("-", 132)
                  ? space(15)
                    ?? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                else
                  M_ESC = inkey()
                endif
            endif
 
            skip

          enddo     

        enddo
  
    ? space(90)
      ?? "TOTAL DOS CHEQUES . . . . ."
      ?? transform(M_TOTCHE,"@E ###,###,###.##")
    ? replicate("-", 132)
    ? space(90)
      ?? "TOTAL GERAL DOS CHEQUES . ."
      ?? transform(M_GERCHE,"@E ###,###,###.##")

    eject

desliga1()

  enddo
 
return ""

*****************
function LISPRD_D         && lista Pre-datado ordem data de vencimento
*****************

  local SEMANA[7]

  SEMANA[1]="Domingo"
  SEMANA[2]="Segunda"
  SEMANA[3]="Terca  "
  SEMANA[4]="Quarta "
  SEMANA[5]="Quinta "
  SEMANA[6]="Sexta  "
  SEMANA[7]="Sabado "

  do while .t.

    rodape("LISTA","CHEQUES",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

    store ctod("  /  /  ") to M_VCTINI,;
                              M_VCTFIN

    store "A" to M_PRDSIT

    store 0                to M_TOTCHE ,;
                              M_GERCHE

 nbox(14, 31, 18, 58,"W/W+",.t.)
 setcolor("B/W")
      @ 15, 32 say           " Vencto Inicial:          "
      @ 16, 32 say           "          Final:          "
      @ 17, 32 say           "       Situacao:          "
    SetColor(_COREDICAO_)

    @ 15, 49 get M_VCTINI 
    @ 16, 49 get M_VCTFIN 
    @ 17, 49 get M_PRDSIT picture "@!" valid verprd05()
    read

    if lastkey() = 27
      exit
    endif

    M_VCTINI = iif(dtoc(M_VCTINI) = "  /  /  ",ctod("01/01/80"),M_VCTINI)
    M_VCTFIN = iif(dtoc(M_VCTFIN) = "  /  /  ",ctod("31/12/79"),M_VCTFIN)

    select APRD00

    set order to 4

    dbseek(str(ME_EMP, 2, 0) + dtos(M_VCTINI),.t.)

    if str(PRDEMP, 2, 0) + dtos(PRDVCT) > str(ME_EMP, 2, 0) + dtos(M_VCTFIN)
      msg("* * * NADA A LISTAR NO INTERVALO * * *")   
      exit
    endif

    private M_ESC ,;
            LN    ,;
            PG

    M_IMPRE = impresn()

    if M_IMPRE = "N"
      return ""
    endif

    store 0   to   PG ,;
                   LN 
    store " " to   BR

    store ctod("  /  /  ") to M_VCTANT

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(15)                        && comprime
    endif
          
    do while !eof()  
          
      store PG + 1 to  PG 

       if PG > 1
         eject
       endif

          ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE PRE-DATADO","EAGRO55",132) 
          ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
          ? "*---------*-------------------------*--------*--------*--------*------------------------------------*---------------*--*-----------*"
          ? "*  CHEQUE *      BANCO              *EMISSAO * VENCTO *DEPOSITO* CLIENTE                            *   MUNICIPIO   *UF*  VALOR    *"
          ? "*---------*-------------------------*--------*--------*--------*------------------------------------*---------------*--*-----------*"
*             999999/99 99999 XXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XX ####,###.##

          store 5 to LN
  
          do while !eof() .and. LN < 60 
 
            if str(PRDEMP, 2, 0) + dtos(PRDVCT) > str(ME_EMP, 2, 0) + dtos(M_VCTFIN)
              go bottom
              skip 
              loop 
            endif

            if M_PRDSIT != PRDSIT
              skip
              loop
            endif 

            if PRDVCT != M_VCTANT
              if M_TOTCHE > 0
                ? space(90)
                  ?? "TOTAL DOS CHEQUES . . . . ."
                  ?? transform(M_TOTCHE,"@E ###,###,###.##")
                ? replicate("-", 132)
              endif 
              ? " "    
                ?? PRDVCT
                ?? " - " 
                ?? SEMANA[dow(PRDVCT)]
              ?      
              M_TOTCHE = 0
              M_VCTANT = PRDVCT 
              LN = LN + 4 
            endif


            ? space(01)
              ?? str(PRDCHE, 6, 0)
              ?? "/"
              ?? str(PRDORD, 2, 0)
              ?? " " 
              ?? str(PRDBAN, 5, 0)
              ?? " "
              ?? pad(ABCO00->BCODES, 19)
              ?? " "
              ?? PRDDTE
              ?? " "
              ?? PRDVCT
              ?? " "
              ?? PRDDEP
              ?? " "
              ?? padl(PRDPOR, 36)
              ?? " "  
              ?? PRDMUN
              ?? " "
              ?? PRDEST
              ?? " "
              ?? transform(PRDVLR,"@E ####,###.##")

            LN++

            M_TOTCHE = M_TOTCHE + PRDVLR
            M_GERCHE = M_GERCHE + PRDVLR

            M_ESC = inkey()

            if M_ESC = 27
                if susimp()
                  ? space(15)
                    ?? replicate("-", 132)
                  ? space(15)
                    ?? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                else
                  M_ESC = inkey()
                endif
            endif
 
            skip

          enddo     

        enddo
  
  
    ? space(90)
      ?? "TOTAL DOS CHEQUES . . . . ."
      ?? transform(M_TOTCHE,"@E ###,###,###.##")
    ? replicate("-", 132)
    ? space(90)
      ?? "TOTAL GERAL DOS CHEQUES . ."
      ?? transform(M_GERCHE,"@E ###,###,###.##")

    eject

desliga1()

  enddo
 
return ""

*****************
function LISPRD_E         && lista Pre-datado em ordem de portadores
*****************

  do while .t.

    rodape("LISTA","CHEQUES",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

    store space(40)  to M_PORINI,;
                        M_PORFIN

    store "A" to M_PRDSIT

    store 0                to M_TOTCHE ,;
                              M_GERCHE

 nbox(14, 21, 18, 58,"W/W+",.t.)
 setcolor("B/W")
      @ 15, 22 say " Cliente Inicial:                   "
      @ 16, 22 say "           Final:                   "
      @ 17, 22 say "        Situacao:                   "
    SetColor(_COREDICAO_)

    @ 15, 40 get M_PORINI picture "@!@S18"
    @ 16, 40 get M_PORFIN picture "@!@S18"
    @ 17, 40 get M_PRDSIT picture "@!" valid verprd05()
    read

    if lastkey() = 27
      exit
    endif

    M_PORINI = iif(empty(M_PORINI),"A"                  ,M_PORINI)
    M_PORFIN = iif(empty(M_PORFIN),"ZZZZZZZZZZZZZZZZZZZ",M_PORFIN)

    select APRD00

    set order to 5

    dbseek(str(ME_EMP, 2, 0) + alltrim(M_PORINI),.t.)

    if str(PRDEMP, 2, 0) + alltrim(PRDPOR) > str(ME_EMP, 2, 0) + alltrim(M_PORFIN)
      msg("* * * NADA A LISTAR NO INTERVALO * * *")   
      exit
    endif

    private M_ESC ,;
            LN    ,;
            PG

    M_IMPRE = impresn()

    if M_IMPRE = "N"
      return ""
    endif

    store 0   to   PG ,;
                   LN 
    store " " to   BR

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(15)                        && comprime
    endif
          
    do while !eof()  
          
      store PG + 1 to  PG 

       if PG > 1
         eject
       endif

          ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE PRE-DATADO","EAGRO55",132) 
          ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
          ? "*---------*-------------------------*--------*--------*-----------------------------*---------------*--*---------------*-----------*"
          ? "*  CHEQUE *      BANCO              *EMISSAO * VENCTO * CLIENTE                     *   MUNICIPIO   *UF*   TELEFONE    *  VALOR    *"
          ? "*---------*-------------------------*--------*--------*-----------------------------*---------------*--*---------------*-----------*"
*             999999/99 99999 XXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXX ####,###.##

          store 5 to LN
  
          do while !eof() .and. LN < 60 
 
            if str(PRDEMP, 2, 0) + alltrim(PRDPOR) > str(ME_EMP, 2, 0) + left(M_PORFIN,len(alltrim(PRDPOR)))
              go bottom
              skip 
              loop 
            endif

            if M_PRDSIT != PRDSIT
              skip
              loop
            endif 

            ? space(01)
              ?? str(PRDCHE, 6, 0)
              ?? "/"
              ?? str(PRDORD, 2, 0)
              ?? " " 
              ?? str(PRDBAN, 5, 0)
              ?? " "
              ?? pad(ABCO00->BCODES, 19)
              ?? " "
              ?? PRDDTE
              ?? " "
              ?? PRDVCT
              ?? " "
              ?? padl(PRDPOR, 29)
              ?? " "  
              ?? PRDMUN
              ?? " "
              ?? PRDEST
              ?? " "
              ?? PRDTEL
              ?? " "
              ?? transform(PRDVLR,"@E ####,###.##")

            LN ++

            M_TOTCHE = M_TOTCHE + PRDVLR
            M_GERCHE = M_GERCHE + PRDVLR

            M_ESC = inkey()

            if M_ESC = 27
              if susimp()
                ? space(15)
                  ?? replicate("-", 132)
                ? space(15)
                  ?? "* * * IMPRESSAO SUSPENSA * * *"
                go bottom
                skip
              else
                M_ESC = inkey()
              endif
            endif
 
            skip

          enddo     

        enddo
  
    ? space(90)
      ?? "TOTAL DOS CHEQUES . . . . ."
      ?? transform(M_TOTCHE,"@E ###,###,###.##")
    ? replicate("-", 132)
    ? space(90)
      ?? "TOTAL GERAL DOS CHEQUES . ."
      ?? transform(M_GERCHE,"@E ###,###,###.##")

    eject

desliga1()

  enddo
 
return ""

*****************
function LISPRD_F         && lista Pre-datado ordem entrada
*****************

  local SEMANA[7]

  SEMANA[1]="Domingo"
  SEMANA[2]="Segunda"
  SEMANA[3]="Terca  "
  SEMANA[4]="Quarta "
  SEMANA[5]="Quinta "
  SEMANA[6]="Sexta  "
  SEMANA[7]="Sabado "

  do while .t.

    rodape("LISTA","CHEQUES",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

    store ctod("  /  /  ") to M_ENTINI,;
                              M_ENTFIN

    store "A" to M_PRDSIT

    store 0                to M_TOTCHE ,;
                              M_GERCHE

 nbox(14, 31, 18, 58,"W/W+",.t.)
 setcolor("B/W")
      @ 15, 32 say           "Entrada Inicial:          "
      @ 16, 32 say           "          Final:          "
      @ 17, 32 say           "       Situacao:          "
    SetColor(_COREDICAO_)

    @ 15, 49 get M_ENTINI 
    @ 16, 49 get M_ENTFIN 
    @ 17, 49 get M_PRDSIT picture "@!" valid verprd05()
    read

    if lastkey() = 27
      exit
    endif

    M_ENTINI = iif(dtoc(M_ENTINI) = "  /  /  ",ctod("01/01/80"),M_ENTINI)
    M_ENTFIN = iif(dtoc(M_ENTFIN) = "  /  /  ",ctod("31/12/79"),M_ENTFIN)

    select APRD00

    set order to 6

    dbseek(str(ME_EMP, 2, 0) + dtos(M_ENTINI),.t.)

    if eof() .or. str(PRDEMP, 2, 0) + dtos(PRDENT) > str(ME_EMP, 2, 0) + dtos(M_ENTFIN)
      msg("* * * NADA A LISTAR NO INTERVALO * * *")   
      loop
    endif

    private M_ESC ,;
            LN    ,;
            PG

    M_IMPRE = impresn()

    if M_IMPRE = "N"
      return ""
    endif

    store 0   to   PG ,;
                   LN 
    store " " to   BR

    store ctod("  /  /  ") to M_ENTANT

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(15)                        && comprime
    endif
          
    do while !eof()  
          
      store PG + 1 to  PG 

       if PG > 1
         eject
       endif

          ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE PRE-DATADO - ENTRADA","EAGRO55",132) 
          ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
          ? "*---------*-------------------------*--------*--------*-----------------------------*---------------*--*---------------*-----------*"
          ? "*  CHEQUE *      BANCO              *EMISSAO * VENCTO * CLIENTE                     *   MUNICIPIO   *UF*   TELEFONE    *  VALOR    *"
          ? "*---------*-------------------------*--------*--------*-----------------------------*---------------*--*---------------*-----------*"
*             999999/99 99999 XXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXX ####,###.##

          store 5 to LN
  
          do while !eof() .and. LN < 60 
 
            if str(PRDEMP, 2, 0) + dtos(PRDENT) > str(ME_EMP, 2, 0) + dtos(M_ENTFIN)
              go bottom
              skip 
              loop 
            endif

            if M_PRDSIT != PRDSIT
              skip
              loop
            endif 

            if PRDENT != M_ENTANT
              if M_TOTCHE > 0
                ? space(90)
                  ?? "TOTAL DOS CHEQUES . . . . ."
                  ?? transform(M_TOTCHE,"@E ###,###,###.##")
                ? replicate("-", 132)
              endif 
              ? " "    
                ?? PRDENT
                ?? " - " 
                ?? SEMANA[dow(PRDENT)]
              ?      
              M_TOTCHE = 0
              M_ENTANT = PRDENT 
              LN = LN + 4 
            endif


            ? space(01)
              ?? str(PRDCHE, 6, 0)
              ?? "/"
              ?? str(PRDORD, 2, 0)
              ?? " " 
              ?? str(PRDBAN, 5, 0)
              ?? " "
              ?? pad(ABCO00->BCODES, 19)
              ?? " "
              ?? PRDDTE
              ?? " "
              ?? PRDVCT
              ?? " "
              ?? padl(PRDPOR, 29)
              ?? " "  
              ?? PRDMUN
              ?? " "
              ?? PRDEST
              ?? " "
              ?? PRDTEL
              ?? " "
              ?? transform(PRDVLR,"@E ####,###.##")

            LN++

            M_TOTCHE = M_TOTCHE + PRDVLR
            M_GERCHE = M_GERCHE + PRDVLR

            M_ESC = inkey()

            if M_ESC = 27
                if susimp()
                  ? space(15)
                    ?? replicate("-", 132)
                  ? space(15)
                    ?? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                else
                  M_ESC = inkey()
                endif
            endif
 
            skip

          enddo     

        enddo
  
  
    ? space(90)
      ?? "TOTAL DOS CHEQUES . . . . ."
      ?? transform(M_TOTCHE,"@E ###,###,###.##")
    ? replicate("-", 132)
    ? space(90)
      ?? "TOTAL GERAL DOS CHEQUES . ."
      ?? transform(M_GERCHE,"@E ###,###,###.##")

    eject

desliga1()

  enddo
 
return ""

***************
function BAIPRD         && altera Pre-datado  
***************

    do while .t.

        tlprd01()

        rodape("BAIXA","PRE_DATADO",M_FAN,"EAGRO55","Mem: " + str(memory(0), 5),M_EMP) 

        M_PRDEMP = ME_EMP
        M_PRDCHE = 0
        M_PRDORD = 0   
        M_BCODES = space(40)
       
        SetColor(_COREDICAO_)
        @ 09, 26 get     M_PRDCHE  picture "######"
        @ 09, 33 get     M_PRDORD  picture "##"
        read

        if M_PRDCHE = 0
          exit
        endif

        if !APRD00->(dbseek(str(M_PRDEMP, 2, 0) + str(M_PRDCHE, 6, 0) + str(M_PRDORD, 2, 0)))
          msg( "* * * CHEQUE NAO INCLUIDO * * *")
          loop
        endif

        if APRD00->PRDSIT = "B"
          msg("* * * CHEQUE JA BAIXADO * * *")
          loop
        endif

        M_PRDEMP = APRD00->PRDEMP
        M_PRDCHE = APRD00->PRDCHE
        M_PRDORD = APRD00->PRDORD
        M_PRDSIT = APRD00->PRDSIT
        M_PRDDEP = APRD00->PRDDEP
        M_PRDENT = APRD00->PRDENT
        M_PRDBAN = APRD00->PRDBAN
        M_PRDDTE = APRD00->PRDDTE
        M_PRDVCT = APRD00->PRDVCT
        M_PRDPOR = APRD00->PRDPOR
        M_PRDMUN = APRD00->PRDMUN
        M_PRDEST = APRD00->PRDEST
        M_PRDTEL = APRD00->PRDTEL
        M_PRDVLR = APRD00->PRDVLR
        M_PRDCTA = space(13)
        M_PRDHIS = 0
        M_PRDOBS = APRD00->PRDOBS
        M_BCODES = space(40)

        edprd01()

        if lastkey() = 27
          msg( "* * * CHEQUE NAO BAIXADO * * *")
          loop 
        endif 

        M_OPC = decide("Confirma baixa deste cheque")

        if M_OPC != 1
          msg( "* * * CHEQUE NAO BAIXADO * * *")
          loop
        endif

        select APRD00

        if !rlock()
          msg("* * * (APRD00) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_PRDSIT = "B"

        select ACTA00

        do while .t.         
          if dbseek(str(ME_EMP, 2, 0) + APRD00->PRDCTA)
            if !rlock()
              msg("* * * (ACTA00) REGISTRO SENDO USADO * * *")
              loop
            endif
          endif   
          M_LANSEQ = CTASEQ + 1
          exit
        enddo

        do while .t. 
          if rlock()                   
            replace CTASEQ with M_LANSEQ
            unlock
            commit 
            exit 
          else
            msg("* * * (ACTA00) REGISTRO SENDO USADO * * *")
          endif
          if lastkey()=17
            exit
          endif
        enddo

        AHIS00->(dbseek(str(M_PRDHIS, 3, 0)))

        select ALAB00

        _append("ALAB00")

        do while .t. 
          if rlock()                   
            replace LANEMP with M_PRDEMP
            replace LANCTA with M_PRDCTA 
            replace LANDUP with 0
            replace LANORD with 0
            replace LANAPL with 0
            replace LANDTA with M_PRDVCT
            replace LANSEQ with M_LANSEQ
            replace LANVLR with M_PRDVLR
            replace LANCOD with M_PRDHIS
            replace LANHIS with alltrim(AHIS00->HISDES) + " " + str(M_PRDCHE, 6, 0) + " " + alltrim(M_PRDPOR)
            replace LANTIP with AHIS00->HISTIP
            replace LANSIT with "N"
            unlock
            commit 
            exit 
          else
            msg("* * * (ALAB00) REGISTRO SENDO USADO * * *")
          endif
          if lastkey()=17
            exit
          endif
        enddo

        grprd01()                      && grava pre-datado

        msg("* * * CHEQUE BAIXADO * * *")

    enddo

return ""

****************
function TLPRD01
****************

 nbox(08, 13, 19, 67,"W/W+",.t.)
 setcolor("B/W")
    @ 09, 14 say     " Cheque   :       /          Situacao:   -           "
    @ 10, 14 say     " Banco    :                                          "
    @ 11, 14 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    @ 12, 14 say     " Emissao  :                Vencimento:               "
    @ 13, 14 say     " Cliente  :                                          "
    @ 14, 14 say     " Municipio:                    Estado:               "
    @ 15, 14 say     " Fone     :                     Conta:               "
    @ 16, 14 say     " Valor    :                 Historico:               "
    @ 17, 14 say     " O b s    :                                          "
    @ 18, 14 say     " Entrada  :                  Deposito:               "
  set color to

return ""    

****************
function TLPRD02 
****************

 nbox(03, 02, 20, 76,"W/W+",.t.)
 setcolor("B/W")
  @ 03, 03 say     "                                                                         "
  @ 04, 03 say     "                                                                         "
  @ 05, 03 say     "ÄÄÄÄÄÄÂÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÂÄÄÄÄÄÄÄÄÄÄ"
  @ 06, 03 say     "Cheque³Or³Emiss„o ³ Vencto ³Deposito³         Banco         ³S³   Valor  "
  @ 07, 03 say     "ÄÄÄÄÄÄÅÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÅÄÄÄÄÄÄÄÄÄÄ"
  @ 08, 03 say     "      ³  ³        ³        ³        ³                       ³ ³          "
  @ 09, 03 say     "      ³  ³        ³        ³        ³                       ³ ³          "
  @ 10, 03 say     "      ³  ³        ³        ³        ³                       ³ ³          "
  @ 11, 03 say     "      ³  ³        ³        ³        ³                       ³ ³          "
  @ 12, 03 say     "      ³  ³        ³        ³        ³                       ³ ³          "
  @ 13, 03 say     "      ³  ³        ³        ³        ³                       ³ ³          "
  @ 14, 03 say     "      ³  ³        ³        ³        ³                       ³ ³          "
  @ 15, 03 say     "      ³  ³        ³        ³        ³                       ³ ³          "
  @ 16, 03 say     "ÄÄÄÄÄÄÁÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÁÄÄÄÄÄÄÄÄÄÄ"
  @ 17, 03 say     "Cliente   :                                         Aberto:              "
  @ 18, 03 say     "Munic/Entr:                                         Pagos :              "
  @ 19, 03 say     "Observacao:                                         Total :              "
  @ 20, 03 say     "                                                                         "
set color to 

return "" 

****************
function EDPRD01
**************** 

SetColor(_COREDICAO_)
@ 09, 53 get     M_PRDSIT  picture "@!"           valid verprd01()
@ 10, 26 get     M_PRDBAN  picture "###"          valid verprd02()
@ 10, 31 get     M_BCODES  picture "@!@S12"

@ 12, 26 get     M_PRDDTE  
@ 12, 53 get     M_PRDVCT
@ 13, 26 get     M_PRDPOR  picture "@!"
@ 14, 26 get     M_PRDMUN  picture "@!"
@ 14, 53 get     M_PRDEST  picture "@!" 
@ 15, 26 get     M_PRDTEL  picture "@!"
@ 15, 53 get     M_PRDCTA  picture "@!"           valid verprd03()
@ 16, 26 get     M_PRDVLR  picture "#########.##" valid verprd06()
@ 16, 53 get     M_PRDHIS  picture "###"          valid verprd04()
@ 17, 26 get     M_PRDOBS  picture "@!"
@ 18, 26 get     M_PRDENT  
@ 18, 53 get     M_PRDDEP  
read

return ""

****************
function MSPRD01
**************** 

ABCO00->(dbseek(str(APRD00->PRDBAN, 3, 0)))

 setcolor("N/W*")

   @ 09, 53 say     PRDSIT         picture "@!"
   @ 09, 57 say     iif(PRDSIT="A","ABERTO ","BAIXADO")
   @ 09, 26 say     PRDCHE         picture "######"
   @ 09, 33 say     PRDORD         picture "##" 
   @ 10, 26 say     PRDBAN         picture "###"
   @ 10, 31 say     pad(ABCO00->BCODES, 36)
   @ 12, 26 say     PRDDTE  
   @ 12, 53 say     PRDVCT
   @ 13, 26 say     PRDPOR         picture "@!"
   @ 14, 26 say     PRDMUN         picture "@!"
   @ 14, 53 say     PRDEST         picture "@!" 
   @ 15, 26 say     PRDTEL         picture "@!"
   @ 15, 53 say     PRDCTA         picture "@!"
   @ 16, 26 say     PRDVLR         picture "#########.##"
   @ 16, 53 say     PRDHIS         picture "###"   
   @ 17, 26 say     PRDOBS         picture "@!"
   @ 18, 26 say     PRDENT  
   @ 18, 53 say     PRDDEP  

set color to 

return ""

****************
function GRPRD01
****************

  select APRD00

    do while .t. 
      if rlock()                  
        replace PRDEMP with M_PRDEMP
        replace PRDCHE with M_PRDCHE  
        replace PRDORD with M_PRDORD  
        replace PRDSIT with M_PRDSIT  
        replace PRDBAN with M_PRDBAN  
        replace PRDDEP with M_PRDDEP  
        replace PRDENT with M_PRDENT  
        replace PRDDTE with M_PRDDTE  
        replace PRDVCT with M_PRDVCT 
        replace PRDPOR with M_PRDPOR  
        replace PRDMUN with M_PRDMUN  
        replace PRDEST with M_PRDEST  
        replace PRDTEL with M_PRDTEL  
        replace PRDCTA with M_PRDCTA  
        replace PRDVLR with M_PRDVLR  
        replace PRDHIS with M_PRDHIS  
        replace PRDOBS with M_PRDOBS  
        unlock
        commit 
        exit 
      else
        msg("* * * (APRD00) REGISTRO SENDO USADO * * *")
      endif
      if lastkey()=17
        exit
      endif
    enddo

return ""

****************
function GRPRD02
****************

  select ABCO00

    do while .t. 
      if rlock()                  
        replace BCOCOD with M_PRDBAN
        replace BCODES with M_BCODES  
        unlock
        commit 
        exit 
      else
        msg("* * * (ABCO00) REGISTRO SENDO USADO * * *")
      endif
      if lastkey()=17
        exit
      endif
    enddo

return ""

*****************
function VERPRD01
*****************

  if lastkey() = 5
    return .t.
  endif 

  if M_PRDSIT $ "AB"
    set color to I
      if M_PRDSIT = "A"
        @ 09, 57 say "ABERTO "
      else
        @ 09, 57 say "BAIXADO"
      endif
    set color to
    return .t.
  endif

  msg("* * * (A)berto  (B)aixado * * *")

return .f.
  
*****************
function VERPRD02
*****************

  if lastkey() = 5
    return .t.
  endif 
  
  if M_PRDBAN = 0
    return .f.
  endif

  if ABCO00->(dbseek(str(M_PRDBAN, 3, 0)))
    M_BCODES = ABCO00->BCODES
    return .t.
  else
    M_BCODES = space(40)
    return .t.
  endif

return .t.

*****************
function VERPRD03
*****************

  if lastkey() = 5
    return .t.
  endif 

  select ACTA00 

  if empty(M_PRDCTA)
    sele_cta()
    M_PRDCTA = CTACTA
    return .f.
  endif

  if !dbseek(str(M_PRDEMP, 2, 0) + M_PRDCTA)
    msg("* * * CONTA NAO CADASTRADA * * *")
    M_PRDCTA = space(13)
    return .f.
  endif

  msg("* * * " + alltrim(CTAAGE) + " * * *")

return .t. 

*****************
function VERPRD04  
*****************

  if lastkey() = 5
    return .t.
  endif 

  if M_PRDHIS = 0
    sele_his()
    M_PRDHIS = HISCOD
    return .f.
  endif

  if !AHIS00->(dbseek(str(M_PRDHIS, 3, 0)))
    msg("* * * HISTORICO NAO CADASTRADO * * *")
    return .f.
  endif

*   M_PRDOBS = AHIS00->HISDES

return .t.

*****************
function VERPRD05
*****************

  if lastkey() = 5
    return .t.
  endif 

  if M_PRDSIT $ "ABT"
    return .t.
  endif

  msg("* * * (A)berto  (B)aixado  (T)odos * * *")

return .f.


*****************
function VERPRD06
*****************

  if lastkey() = 5
    return .t.
  endif 

  if M_PRDVLR = 0
    msg("* * * VALOR DEVE SER MAIOR QUE ZEROS * * *")
    return .f.
  endif

return .t.

*****************
function VERPRD07
*****************

  M_PRDFIN = M_PRDINI

return .t.

***************
function ACHPRD
***************

parameters  M_MODO, M_ELEM, M_POSI

if str(lastkey(), 2, 0) $ "27"
  return 0
endif

* if str(lastkey(), 3, 0)  $ "# 49# 50# 51# 52# 53# 54# 13"
*   M_ACHO = M_ELEM
*   return 1
* endif

  M_CHAVE = str(ME_EMP, 2, 0) + str(val(substr(M_VETORITE[M_ELEM], 1, 6)), 6, 0) + str(val(substr(M_VETORITE[M_ELEM], 8, 2)), 2, 0)

  APRD00->( dbsetorder(1) , dbseek(M_CHAVE))

  if lastkey() = 13
    altobsprd()
  endif

  set color to GR+/B+
    @ 17, 15 say pad(PRDPOR, 39)
    @ 18, 15 say pad(alltrim(PRDMUN) + " " + PRDEST + " "  + dtoc(PRDENT) + " " + alltrim(PRDTEL), 39)
    @ 19, 15 say pad(PRDOBS, 39)
  set color to I
 
  M_LINPOS = M_POSI

return 2

****************
function SETAPRD
****************

  set cursor off

  set color to R+
    @ 24, 15 say   "(ENTER) Observacoes  (ESPA€O) Totais  (ESC) Saida"
  set color to 

  set color to GR+
    @ 24, 16 say "ENTER"
    @ 24, 37 say "ESPA€O"
    @ 24, 54 say "ESC"
  set color to 

return ""

******************
function ALTOBSPRD
******************

    M_PRDOBS = pad(APRD00->PRDOBS , 40)

    SetColor(_COREDICAO_)
      @ 19, 15 get M_PRDOBS picture "@S39"
      read
    set color to N/W,W+/N

    select APRD00

    if dbseek(M_CHAVE)
      do while .t.
        if rlock()
          replace  PRDOBS   with  M_PRDOBS
          unlock   
          commit
          exit
        else
          msg("* * * (APRD00) REGISTRO SENDO USADO * * *") 
        endif
        if lastkey()=17
          exit
        endif
      enddo
    endif

return ""
