#include "ptmenu.ch"

#command @ <row> , <col>  GET <var> ;
[<clauses,...>]         ;
PASSWORD                ;
[<moreClauses,...>]     ;
;
=> @ <row> , <col>  GET <var> ;
[<clauses>]             ;
SEND Reader := {|oGet|  ;
GetPassword(oGet) };
[<moreClauses>]

***************
function MANLOG
***************
parameters M_OPC,M_OPC1,M_OPC2

  rodape("MENU","USUARIOS",M_FAN,"EAGRO52","Mem: " + str(memory(0), 5),M_EMP)

  *@ 05, 60 prompt "Inclus„o " HIGHLITE R/BG SENHA 399
  *@ 06, 60 prompt "Altera‡„o" HIGHLITE R/BG SENHA 400
  *@ 07, 60 prompt "Consulta " HIGHLITE R/BG SENHA 401
  *@ 08, 60 prompt "Exclus„o " HIGHLITE R/BG SENHA 402
  *@ 09, 60 prompt "Listagem " HIGHLITE R/BG SENHA 403
  *@ 11, 60 prompt "Restricao" HIGHLITE R/BG SENHA 405

  do case
  case M_OPC = 1 ; iif(!alsen(),inclog(),"")
  case M_OPC = 2 ; altlog(.t.)
  case M_OPC = 3 ; iif(!alsen(),conlog(),"")
  case M_OPC = 4 ; iif(!alsen(),exclog(),"")
  case M_OPC = 5 ; altlog(.f.)
  endcase

return ""

***************
function INCLOG
***************

do while .t.

  M_LOGEMP = ME_EMP
  M_LOGNOM = space(10)
  M_LOGSEN = space(10)
  M_LOG11  = space(10)
  M_LOG12  = space(10)
  M_LOG13  = space(1)

  M_LOGANT = W_LOGGER
  W_LOGGER = replicate("N",750)

  tllog01()

  rodape("INCLUI","USUARIOS",M_FAN,"EAGRO52","Mem: " + str(memory(0), 5),M_EMP)

  SetColor(_COREDICAO_)
  @ 09, 28 get  M_LOGNOM   picture "@!" color _COREDICAO_
  read

  if empty(M_LOGNOM) .or. lastkey() = 27
    exit
  endif

  select ALOG10

  if dbseek(str(M_LOGEMP, 2, 0) + M_LOGNOM)
    msg("* * * USUARIO JA CADASTRADO * * *")
    loop
  endif

  _append(str(00,2)+space(10),"ALOG10")

  M_LOGSUP1 = " "

  edlog01(.t.)

  if lastkey() = 27
    msg("* * * USUARIO NAO INCLUIDO * * *")
    loop
  endif

  grlog01()

  W_LOGGER = M_LOGANT

  msg("* * * USUARIO INCLUIDO * * *")

enddo

W_LOGGER = M_LOGANT

return ""

***************
function ALTLOG(TIPO)
***************

do while .t.

  M_LOGEMP = ME_EMP
  M_LOGNOM = space(10)
  M_LOGSEN = space(10)

  tllog01()

  rodape("ALTERA","USUARIOS",M_FAN,"EAGRO52","Mem: " + str(memory(0), 5),M_EMP)

  select ALOG10

  if !TIPO .and. lLog
    go lPoslogrestricao
    M_LOGNOM = LOGNOM
  else
  SetColor(_COREDICAO_)
    @ 09, 28 get  M_LOGNOM   picture "@!" color _COREDICAO_
    read
    if empty(M_LOGNOM) .or. lastkey() = 27
      exit
    endif
    locate for LOGEMP = M_LOGEMP .and. LOGNOM = M_LOGNOM
    if eof()
      msg("* * * USUARIO NAO CADASTRADO * * *")
      loop
    endif
  endif

  do while .t.
    if !rlock()
      msw("* * * (ALOG10) REGISTRO SENDO USADO - AGUARDE * * *")
      inkey(.1)
      loop
    endif
    exit
  enddo

  if lLog = .f. // se nao estiver alterando
    M_LOGANT = W_LOGGER
    M_LOGGER = CAMPO1+CAMPO2+CAMPO3
    W_LOGGER = CAMPO1+CAMPO2+CAMPO3
    M_LOG11  = LOG11+left(LOG12,4)
    M_LOG12  = LOG11+left(LOG12,4)
    M_LOG13  = left(LOG13,1)
    M_LOGSUP = LOGSUP
    lPoslogrestricao = recno()
    lLog = .t.  // entra no modulo de alteracao
    NOVOMENU() // vamos ler o menu novamente
  else          // ou
    M_LOGSUP1 = LOGSUP
    if TIPO
      edlog01(.t.)
    else
      M_LOGSEN  = LOGSEN
      M_LOGSUP  = LOGSUP
      M_LOGSUP1 = LOGSUP
      edlog01(.f.)
    endif
    lLog = .f.  // volta ao modo normal
    M_ALT = decide("Altera todas empresas")

    if M_ALT # 1
      grlog01()   // grava alteracao
      if !TIPO
        do while .t.
          if rlock()
            replace  LOGSEN   with  M_LOGSEN
            replace  LOGSUP   with  M_LOGSUP1
            unlock
            commit
            exit
          else
            msg("* * * (ALOG10) REGISTRO SENDO USADO * * *")
          endif
          if lastkey()=17
            exit
          endif
        enddo
      endif
    else
      select ALOG10
      go top
      do while !eof()
        if LOGNOM = M_LOGNOM
          do while .t.
            if rlock()
              replace  LOGSEN   with  M_LOGSEN
              replace  LOGSUP   with  M_LOGSUP1
              replace  CAMPO1   with  left(W_LOGGER,250)
              replace  CAMPO2   with  substr(W_LOGGER,251,250)
              replace  CAMPO3   with  right(W_LOGGER,250)
              unlock
              commit
              exit
            else
              msg("* * * (ALOG10) REGISTRO SENDO USADO * * *")
            endif
            if lastkey()=17
              exit
            endif
          enddo
        endif
        skip
      enddo
    endif
    select ALOG10
    go lPoslogAtual
    W_LOGGER = CAMPO1 + CAMPO2 + CAMPO3
    XX_LOGSUP = LOGSUP
    M_LOGNOM = LOGNOM
    M_LOGSUP = LOGSUP
    NOVOMENU() // vamos ler o menu novamente

  endif

  exit

enddo

return ""

***************
function CONLOG
***************

do while .t.

  M_LOGEMP = ME_EMP
  M_LOGNOM = space(10)
  M_LOGSEN = space(10)

  tllog01()

  rodape("CONSULTA","USUARIOS",M_FAN,"EAGRO52","Mem: " + str(memory(0), 5),M_EMP)

  SetColor(_COREDICAO_)
  @ 09, 28 get  M_LOGNOM   picture "@!" color _COREDICAO_
  read

  if empty(M_LOGNOM) .or. lastkey() = 27
    exit
  endif

  select ALOG10

  set softseek on
  seek str(M_LOGEMP, 2, 0) + M_LOGNOM
  set softseek off

  if eof()
    go top
  endif

  setas()

  do while .t.

    if LOGEMP != ME_EMP
      msg("* * * FIM DO ARQUIVO * * *")
      exit
    endif

    mslog01()

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

  set cursor on
  set order to 1

enddo

return ""

***************
function EXCLOG
***************

private M_OPC

do while .t.

  M_LOGEMP = ME_EMP
  M_LOGNOM = space(10)
  M_LOGSEN = space(10)

  tllog01()

  rodape("EXCLUI","USUARIOS",M_FAN,"EAGRO52","Mem: " + str(memory(0), 5),M_EMP)

  SetColor(_COREDICAO_)
  @ 09, 28 get  M_LOGNOM   picture "@!" color _COREDICAO_
  read

  if empty(M_LOGNOM) .or. lastkey() = 27
    exit
  endif

  select ALOG10

  if !dbseek(str(M_LOGEMP, 2, 0) + M_LOGNOM)
    msg("* * * USUARIO NAO CADASTRADO * * *")
    loop
  endif

  mslog01()

  if !rlock()
    msg("* * * (ALOG10) REGISTRO SENDO USADO * * *")
    loop
  endif

  M_OPC = confirma("deste Usuario")

  if M_OPC != 1
    msg("* * * USUARIO NAO EXCLUIDO * * *")
    unlock
    loop
  endif

  elimina()

  msg("* * * USUARIO EXCLUIDO * * *")

enddo

return ""

***************
function LISLOG
***************

return

****************
function TLLOG01
****************

 nbox(08, 17, 12, 61,"W/W+",.t.)
 setcolor("B/W")
@ 09, 18 say     " Usuario:                Senha:            "
@ 10, 18 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ 11, 18 say     "              Supervisor  S/N :            "
set color to

return ""

****************
function EDLOG01(TIPO)
****************

setcursor(1)

M_LOG11 = space(10)

SetColor(_COREDICAO_)
@ 11, 50 get M_LOGSUP1 picture "@!" valid M_LOGSUP1 $ "SN" color _COREDICAO_
read

if !TIPO
  return .t.
endif

M_TELA10 := savescreen(13, 28, 18, 51)

nbox(13, 28, 17, 50,"W/W+",.t.)
setcolor("B/W")
@ 14, 29 say            " Entre com sua senha "
@ 15, 29 say            "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ 16, 29 say            "                     "
set color to

do while .t.

  M_LOGSEN = space(10)

  SetColor(_COREDICAO_)
  @ 16, 34 get M_LOGSEN PASSWORD pict "@!" color _COREDICAO_
  read
  setcolor("")

  if empty(M_LOGSEN)
    loop
  endif

  M_LOGSEN = upper(M_LOGSEN)

  setcolor("B/W")
  @ 14, 28 say            "³ Reentre com a senha ³"
  setcolor("")

  M_LOGSEN1 = space(10)

  SetColor(_COREDICAO_)
  @ 16, 34 get M_LOGSEN1 PASSWORD pict "@!" color _COREDICAO_
  read
  setcolor("")

  if empty(M_LOGSEN1)
    loop
  endif

  M_LOGSEN1 = upper(M_LOGSEN1)

  if !M_LOGSEN == M_LOGSEN1
    msg("* * * A SENHA NAO ESTA CORRETA * * *")
    setcolor("B/W")
    @ 14, 28 say            "³ Entre com sua senha ³"
    setcolor("")
    loop
  endif
  exit
enddo

****************
function MSLOG01
****************

setcolor("N/W*")
@ 09, 28 say  LOGNOM
@ 09, 50 say  "##########"
@ 11, 50 say  LOGSUP picture "@!"
@ 12, 50 say  LOG75
set color to

return ""

****************
function GRLOG01                       && grava dados da condicao de pagamento
****************

do while .t.
  if rlock()
    replace  LOGEMP   with  M_LOGEMP
    replace  LOGNOM   with  M_LOGNOM
    replace  LOGSUP   with  M_LOGSUP1
    replace  LOGSEN   with  M_LOGSEN
    replace  CAMPO1   with  left(W_LOGGER,250)
    replace  CAMPO2   with  substr(W_LOGGER,251,250)
    replace  CAMPO3   with  right(W_LOGGER,250)
    unlock
    commit
    exit
  else
    msg("* * * (ALOG10) REGISTRO SENDO USADO * * *")
  endif
  if lastkey()=17
    exit
  endif
enddo

return ""

**************
function ALSEN
**************

if lLog
  msg(M_MENSENHA)
  return .t.
endif

return .f.
