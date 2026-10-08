#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)

#command @ <row> , <col>  GET <var> [<clauses,...>] F2 [<moreClauses,...>] funcao <func> retorno <Variavel>;
=>       @ <row> , <col>  GET <var> [<clauses>] SEND reader := {|oGet| Getf2(oGet,<func>,<Variavel>) } [<moreClauses>]

#include "ptmenu.ch"
#include "inkey.ch"
#include "hbwin.ch"
#include "ACEL.CH"
#include "VISUAL2.CH"

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

******************
function ADDITEPED && insere item na nota
******************

  R = len(M_PEDMAT) + 1
  L = 12

  for S = 1 to len(M_PEDMAT)
    if L = 20
      lpped01()
      L = 12
    endif
    L ++
  next

*  if len(M_PEDMAT) - (int(len(M_PEDMAT)/9)*9) != 0
*    msped02((int(len(M_PEDMAT)/9)*9)+1 , 12)
*  endif

  do while .t.

    aadd(M_PEDMAT,{0,  0,  0,  0,  0,  0,  0,space(40),0})
    M_PEDMAT[R,1] = len(M_PEDMAT)
    R = len(M_PEDMAT)

    edped04(L,R)

    if lastkey() = 27
      adel(M_PEDMAT,R)
      asize(M_PEDMAT,len(M_PEDMAT) - 1)
      exit
    endif

    if L = 20
      lpped01()
      L = 12
    endif

    R ++
    L ++

  enddo

  M_LINPOS = 0

return ""


***************
function MANPED
***************
parameters M_OPC,M_OPC1,M_OPC2

    _FUNCLI_ = "PEDIDO.t."
    _FUNPRO_ = "PEDIDO.t."
    _FUNFOR_ = "PEDIDO.t."
    _FUNCPG_ = "PEDIDO.t."
    _FUNTRA_ = "PEDIDO.t."
    _FUNVEN_ = "PEDIDO.t."

    M_PCAFOR = 0

zPCAMAT = 0
zPCAREF=space(50)
zPCALIS="   "
zPCAGRP=0
zPCAMAR = space(30)
zPCANCM = space(8)
zPCAUNI="   "
zPCAPLQ=0
zPCAFOR=0
zPCATRI=1
zPCACSP=" "
zPCACOU=" "
zPCARG1=0
zPCARG2=0
zPCARG0=0 
zPCAIC1=0
zPCAIC2=0
zPCAIC0=0 
zPCAIPI=0 
zPCAPRB=0
zPCAEMB=space(3)
zPCADOS=0
zPCAESC=0
zPCACOM=0
zPCAFAB=space(10)
zPCADSC=" " // MENSAGEM ABBOT
zREFERE01 = space(20)
zREFERENC = " "
zSLD01 = 0
zSLD51 = 0
zPCADES=space(50)

      zCLICGC1  = space(15)
      zCLITIP   = " "
      zCLICOD   = 0
      zCLINOM   = space(40)
      zCLIDTE   = date()
      zCLIEND1  = space(40)
      zCLIUF1   = space(02)
      zCLIBAI1  = space(15)
      zCLICEP1  = 0
      zCLICCL1  = 0
      zCLICCL2  = 0
      zCLICCL3  = 0
      zCLIMUN1  = space(20)
      zCLITEL1  = space(15)
      zCLIFAX1  = space(15)
      zCLITEX1  = space(15)
      zCLIIES1  = pad("N/C",17)
      zCLIREG   = 0
      zCLIDCC   = 0
      zCLIVEN   = 0
      zCLICLF   = " "
      zCLIEND2  = space(40)
      zCLITRA   = 0
      zCLIUF2   = space(2)
      zCLIBAI2  = space(15)
      zCLICEP2  = 0
      zCLIMUN2  = space(20)
      zCLIIES2  = pad("N/C",17)
      zCLICGC2  = space(15)
      zCLIAC    = space(15)
      zCLIEND3  = space(15)
      zCLIUF3   = space(2)
      zCLIBAI3  = space(15)
      zCLICEP3  = 0 
      zCLIMUN3  = space(20)
      zCLITEL3  = space(15)
      zCLIFAX3  = space(15)
      zCLITEX3  = space(15)
      zCLICON   = space(15)
      zCLIBCO   = 0
      zCLIULC   = date()      // ctod("  /  /  ")
      zCLISITE = space(40)
      zCLIEMAIL = space(40)
      zINDICADO = space(20)
      zREVENDA = " " 
      zNOMEPAI = space(20)


      rodape("MENU", "OR€AMENTO", M_FAN, "EAGRO22", "Mem: " + str(memory(0), 5), M_EMP)

*        @ 05, 19 prompt "Emiss„o    " HIGHLITE R/BG PERMITE 2,2,1
*        @ 06, 19 prompt "Altera‡„o  " POSITION 3 HIGHLITE R/BG PERMITE 2,2,2
*        @ 07, 19 prompt "Consulta   " HIGHLITE R/BG PERMITE 2,2,3
*        @ 08, 19 prompt "Exclus„o   " HIGHLITE R/BG PERMITE 2,2,4
*        @ 09, 19 prompt "Listagem   " HIGHLITE R/BG PERMITE 2,2,5
*        @ 10, 19 prompt "Agrupamento" HIGHLITE R/BG PERMITE 2,2,6


      do case
         case M_OPC = 1 ; incped()
         case M_OPC = 2 ; altped()
         case M_OPC = 3 ; conped(M_OPC1)
         case M_OPC = 4 ; excped()
         case M_OPC = 5 ; lisped(M_OPC1)
         case M_OPC = 6 ; outped(M_OPC1)
      endcase

    fecha_arq()

return ""

*****************
function CONPED_C
*****************

  do while .t.

    rodape("CONSULTA", "AGRUPAMENTO", M_FAN, "EAGRO22","Mem: " + str(memory(0), 5), M_EMP)

    sombra(03, 02, 20, 76,_SOMBRA_)

    set color to I
    @ 03, 02 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
    @ 04, 02 say     "³Num_Orc:                                        Valor:                   ³"
    @ 05, 02 say     "ÃÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄ´"
    @ 06, 02 say     "³C¢digo³        Descri‡„o              ³ Qtde  ³ Unit rio³  Total  ³ Req  ³"
    @ 07, 02 say     "ÃÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄ´"
    for zz = 08 to 19
    @ zz, 02 say     "³      ³                               ³       ³         ³         ³      ³"
    next
    @ 20, 02 say     "ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÙ"
    set color to 

    M_PEDEMP  = ME_EMP
    M_PEDNUM  = 0
    M_PEDSER  = AEMP00->EMPPSE

    select APED00

    SetColor(_COREDICAO_)
    @ 04, 12 get M_PEDNUM picture "######"
    @ 04, 19 get M_PEDSER picture "@!"
    read

    if M_PEDNUM = 0
      exit
    endif

    select APED00

    if !dbseek(str(M_PEDEMP, 2, 0) + str(M_PEDNUM, 6, 0) + M_PEDSER)
      msg("* * * OR€AMENTO NAO INCLUIDO * * *")
      loop
    endif

    select APED01

    dbseek(str(APED00->PEDEMP, 2, 0) + str(APED00->PEDNUM, 6, 0) + APED00->PEDSER,.t.)

    M_VETORITE = { }
    M_PEDMAT = { }
    M_PEDDEL = { }

    R = 1

    M_PEDVLN = 0

    dbseek(str(APED00->PEDEMP, 2, 0) + str(APED00->PEDNUM, 6, 0) + APED00->PEDSER,.t.)

    do while !eof()

      if !str(PEDEMP, 2, 0) + str(PEDNUM, 6, 0) + PEDSER == str(APED00->PEDEMP, 2, 0) + str(APED00->PEDNUM, 6, 0) + APED00->PEDSER
        exit
      endif

      APCA00->(dbseek(str(APED01->PEDMAT, 6, 0)))
  
      aadd(M_VETORITE, str(PEDMAT, 6, 0) + "³" + ;
                      pad(APCA00->PCADES, 31)   + "³" + ;
                      str(PEDQDE, 7) + "³" + ;
                      str(PEDPRB,9, 2) + "³" + ;
                      str(PEDVLI,9, 2) + "³" + ;
                      str(REQNUM,6))

      aadd(M_PEDMAT,{0,  0,  0,  0,  0,  0,  0,space(40),0,0,"  ",0,"N",recno()})
 
      M_PEDMAT[R,  1] = PEDSEQ
      M_PEDMAT[R,  2] = PEDMAT
      M_PEDMAT[R,  3] = PEDQDE
      M_PEDMAT[R,  4] = PEDPRB
      M_PEDMAT[R,  5] = PEDVLI
      M_PEDMAT[R,  6] = PEDLIQ
      M_PEDMAT[R,  7] = PEDCOM
      M_PEDMAT[R,  8] = APCA00->PCADES
      M_PEDMAT[R, 10] = REQNUM
      M_PEDMAT[R, 11] = REQSER
      M_PEDMAT[R, 12] = REQREC
      M_PEDMAT[R, 13] = "N"
      M_PEDMAT[R, 14] = recno()

      M_PEDVLN += PEDVLI

      skip

      R = R + 1

    enddo

  setcolor("B/W")
  @ 04, 58 say M_PEDVLN picture "@R 999,999.99"
  setcolor("")

  M_LINPOS = 0
  nPosach  = 1

  do while .t.

    set color to GR+
      @ 24, 23 say   "<Enter>.Altera   <Del>eta   <Esc>.Cancela   <6>.Confirma"
    set color to R+
      @ 24, 24 say "Enter"
      @ 24, 41 say "Del"
      @ 24, 52 say "Esc"
      @ 24, 68 say "6"
    set color to N/W,W+/N
      M_OPC = achoice(8, 3,19,75,M_VETORITE,,"mosped2",nPosach)
    set color to 

    if lastkey() = 13
      n_altiteped() && altera item
      setcolor("B/W")
      @ 04, 58 say M_PEDVLN picture "@R 999,999.99"
      setcolor("")
      loop
    endif

    if lastkey() = 27
      exit
    endif

    if lastkey() = 7
      n_deliteped() && deleta item 
      setcolor("B/W")
      @ 04, 58 say M_PEDVLN picture "@R 999,999.99"
      setcolor("")
      loop
    endif

    if lastkey() = 54

      for A = 1 to len(M_PEDDEL)
        select APED01
        go M_PEDDEL[A]
        elimina()
      next

      select APED01

      for R = 1 to len(M_PEDMAT)
        if M_PEDMAT[R][13] = "N"  // se nao alterou nao regrava
          loop
        endif

        go M_PEDMAT[R][14]

        do while .t.
          if rlock()
            replace PEDQDE  with M_PEDMAT[R, 3]
            replace PEDPRB  with M_PEDMAT[R, 4]
            replace PEDVLI  with M_PEDMAT[R, 5]
            replace PEDLIQ  with M_PEDMAT[R, 6]
            unlock
            exit
          else
            msw("* * * (APED01) REGISTRO SENDO USADO * * *") 
          endif
          if lastkey()=17
            exit
          endif
        enddo
      next && R

      exit        && abandona operacao
    endif

  enddo

enddo

return ""

*****************
function CONPED_D  // EMISSAO DAS NOTAS
*****************

  lTela991 = savescreen(1,1,23,79)

  do while .t.

    rodape("CONSULTA", "NOTAS", M_FAN, "EAGRO22","Mem: " + str(memory(0), 5), M_EMP)

    sombra(03, 02, 20, 76,_SOMBRA_)

    set color to I
    @ 03, 02 say     "                                                                           "
    @ 04, 02 say     " Num_Orc:               Selecao:                 Resta:                    "
    @ 05, 02 say     " ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄ "
    @ 06, 02 say     " C¢digo³        Descri‡„o            ³S³ Qtde  ³ Unit rio³  Total  ³ Req   "
    @ 07, 02 say     " ÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄ "
    for zz = 08 to 19
    @ zz, 02 say     "       ³                             ³ ³       ³         ³         ³       "
    next
    @ 20, 02 say     "                                                                           "
    set color to 

    M_PEDEMP  = ME_EMP
    M_PEDNUM  = 0
    M_PEDSER  = AEMP00->EMPPSE

    select APED00

    SetColor(_COREDICAO_)
    @ 04, 12 get M_PEDNUM picture "######"
    @ 04, 19 get M_PEDSER picture "@!"
    read

    if M_PEDNUM = 0
      exit
    endif

    M_VETORITE = { }
    M_PEDMAT = { }
    M_PEDDEL = { }
    R = 1
    M_PEDVLN = 0
    M_PEDSEL = 0
    M_LINPOS = 0
    nPosach  = 1

    pega_vetores()

  do while .t.

    if len(M_VETORITE) = 0 
      msg("* * * FIM DOS ITENS * * *")
      exit
    endif 

    set color to GR+
      @ 24, 23 say   "<Ent>.Seleciona   <Esc>.Cancela   <6>.Emissao"
    set color to R+
      @ 24, 24 say "Enter"
      @ 24, 42 say "Esc"
      @ 24, 58 say "6"
    set color to N/W,W+/N
      M_OPC = achoice(8, 3,19,75,M_VETORITE,,"mosped2",nPosach)
    set color to 

    if lastkey() = 13
      e_altiteped() && altera item
      setcolor("B/W")
      M_PEDSEL = 0
      M_PEDVLN = 0
      for ABC = 1 to len(M_PEDMAT)
        M_PEDVLN += (M_PEDMAT[ABC,4] * M_PEDMAT[ABC,16])
        if M_PEDMAT[ABC][15] == "*"
          M_PEDSEL += M_PEDMAT[ABC,5]
          M_PEDVLN -= M_PEDMAT[ABC,5]
        endif
      next
      @ 04, 58 say M_PEDVLN picture "@R 999,999.99"
      @ 04, 35 say M_PEDSEL picture "@R 999,999.99"
      setcolor("")
      loop
    endif

    if lastkey() = 27
      exit
    endif

    if lastkey() = 54  // confirma emissao
      lTela99 = savescreen(1,1,23,79)
      restscreen(1,1,23,79,lTela991)

      ME_EMPANT = ME_EMP
      ME_EMP = 1
      AEMP00->(dbseek(str(1,2,0)))
      incnfs("PEDIDO")
      ME_EMP = ME_EMPANT
      AEMP00->(dbseek(str(ME_EMP,2,0)))
      select APED01
      restscreen(1,1,23,79,lTela99)

      for R = 1 to len(M_PEDMAT)

        if !M_PEDMAT[R][15] == "*"  // se emitido vamos atualizar
          loop
        endif

        select APED01
        go M_PEDMAT[R][14]

        // vamos excluir a venda desta quantidade
   
        select AKAR00
        dbseek(str(APED01->PEDEMP, 2, 0) + str(APED01->PEDMAT, 6, 0) + dtos(APED01->REQDTE) + str(APED01->REQNAT, 5, 0) + str(APED01->REQNUM, 6, 0) + APED01->REQSER,.t.)

        if str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) + str(KARFIS, 5, 0) + str(KARDOC, 6, 0) + KARSER == str(APED01->PEDEMP, 2, 0) + str(APED01->PEDMAT, 6, 0) + dtos(APED01->REQDTE) + str(APED01->REQNAT, 5, 0) + str(APED01->REQNUM, 6, 0) + APED01->REQSER
          do while .t.
            if rlock()
              replace KARQDE with KARQDE - M_PEDMAT[R, 3]
              replace KARVLI with KARPRB*KARQDE
              unlock
              exit
            else
              msw("* * * (AKAR00) REGISTRO SENDO USADO * * *")
            endif
            if lastkey()=17
              exit
            endif
          enddo
          
          if KARQDE <= 0
            elimina()
          endif

          MS = strzero(APED01->PEDEMP,2)
          select APCA00
          if dbseek(str(APED01->PEDMAT, 6, 0))
            do while .t.
              if rlock()
                replace SLD&MS with (SLD&MS + M_PEDMAT[R, 3])
                unlock
                exit
              else
                msw("* * * (APCA00) REGISTRO SENDO USADO * * *")
              endif
              if lastkey()=17
                exit
              endif
            enddo
          endif
        endif

        select AREQ01
        go APED01->REQREC

        do while .t.
          if rlock()
            replace REQQDENT with REQQDENT + M_PEDMAT[R, 3]
            unlock
            exit
          else
            msw("* * * (AREQ01) REGISTRO SENDO USADO * * *")
          endif
          if lastkey()=17
            exit
          endif
        enddo

        select APED01

        do while .t.
          if rlock()
            replace PEDQDE  with PEDQDE - M_PEDMAT[R, 3]
            replace PEDPRB  with M_PEDMAT[R, 4]
            replace PEDVLI  with PEDPRB * PEDQDE
            replace PEDLIQ  with PEDPRB * PEDQDE
            unlock
            exit
          else
            msw("* * * (APED01) REGISTRO SENDO USADO * * *") 
          endif
          if lastkey()=17
            exit
          endif
        enddo

        if PEDQDE <= 0 
          elimina()
        endif

      next && R

      setcolor("I")
      for zz = 08 to 19
        @ zz, 03 say     "                                                                         "
      next
      setcolor("")

      pega_vetores()
    endif

  enddo

enddo


return ""

*********************
function PEGA_VETORES
*********************

    M_VETORITE = { }
    M_PEDMAT = { }
    M_PEDDEL = { }
    R = 1
    M_PEDVLN = 0
    M_PEDSEL = 0
  
    select APED00

    if !dbseek(str(M_PEDEMP, 2, 0) + str(M_PEDNUM, 6, 0) + M_PEDSER)
      msg("* * * OR€AMENTO NAO INCLUIDO * * *")
      return ""
    endif

    select APED01

    dbseek(str(APED00->PEDEMP, 2, 0) + str(APED00->PEDNUM, 6, 0) + APED00->PEDSER,.t.)

    do while !eof()

      if !str(PEDEMP, 2, 0) + str(PEDNUM, 6, 0) + PEDSER == str(APED00->PEDEMP, 2, 0) + str(APED00->PEDNUM, 6, 0) + APED00->PEDSER
        exit
      endif

      APCA00->(dbseek(str(APED01->PEDMAT, 6, 0)))
  
      aadd(M_VETORITE, str(PEDMAT, 6, 0) + "³" + ;
                      pad(APCA00->PCADES, 31) + "³" + ;
                      str(PEDQDE, 7) + "³" + ;
                      str(PEDPRB,9, 2) + "³" + ;
                      str(PEDVLI,9, 2) + "³" + ;
                      str(REQNUM,6))

      aadd(M_PEDMAT,{0,  0,  0,  0,  0,  0,  0,space(40),0,0,"  ",0,"N",recno()," ",0})
 
      M_PEDMAT[R,  1] = PEDSEQ
      M_PEDMAT[R,  2] = PEDMAT
      M_PEDMAT[R,  3] = PEDQDE
      M_PEDMAT[R,  4] = PEDPRB
      M_PEDMAT[R,  5] = PEDVLI
      M_PEDMAT[R,  6] = PEDLIQ
      M_PEDMAT[R,  7] = PEDCOM
      M_PEDMAT[R,  8] = APCA00->PCADES
      M_PEDMAT[R, 10] = REQNUM
      M_PEDMAT[R, 11] = REQSER
      M_PEDMAT[R, 12] = REQREC
      M_PEDMAT[R, 13] = "N"
      M_PEDMAT[R, 14] = recno()
      M_PEDMAT[R, 15] = " "
      M_PEDMAT[R, 16] = PEDQDE

      M_PEDVLN += PEDVLI

      skip

      R = R + 1

    enddo

  setcolor("B/W")
  @ 04, 58 say M_PEDVLN picture "@R 999,999.99"
  @ 04, 35 say M_PEDSEL picture "@R 999,999.99"
  setcolor("")

  M_LINPOS = 0
  nPosach  = 1

return ""


******************
function N_DELITEPED && deleta item da nota
******************

private M_PED, R


M_PED = decide("Confirma Exclusao deste Item")

if M_PED != 1
  return ""
endif

M_PEDVLN -= M_PEDMAT[M_OPC][5]

aadd(M_PEDDEL,M_PEDMAT[M_OPC][14])

adel(M_PEDMAT,M_OPC)
asize(M_PEDMAT,len(M_PEDMAT) - 1)

if len(M_PEDMAT) = 0
  lpped01()
  M_LINPOS = 0
  return ""
endif

popula_vetores()
lpped01()

M_LINPOS = 0

return ""

***********************
function POPULA_VETORES
***********************
local S

declare M_VETORITE[len(M_PEDMAT)]

  for S = 1 to len(M_PEDMAT)
    M_VETORITE[S] = str(M_PEDMAT[S, 1], 2, 0) + "³" + ;
                    str(M_PEDMAT[S, 2], 6, 0) + "³" + ;
                    pad(M_PEDMAT[S ,8], 31)   + "³" + ;
                    str(M_PEDMAT[S, 3], 7) + "³" + ;
                    str(M_PEDMAT[S, 4],9, 2) + "³" + ;
                    str(M_PEDMAT[S, 5],9, 2)

  next

******************
function N_ALTITEPED  && altera item da nota
******************

  M_PEDMAT[M_OPC][13] = "A"

  M_PEDVLN -= M_PEDMAT[M_OPC, 5]
  edped05(8 + M_LINPOS,M_OPC)
  M_PEDVLN += M_PEDMAT[M_OPC, 5]

  LNPRO = 0

  popula_vetores()

  M_LINPOS = 0

return ""

******************
function E_ALTITEPED  && altera item da nota
******************

  M_PEDMAT[M_OPC][15] = iif(M_PEDMAT[M_OPC][15]="*"," ","*")

  M_PEDVLN -= M_PEDMAT[M_OPC,5]
  edped05(8 + M_LINPOS,M_OPC)
  M_PEDVLN += (M_PEDMAT[M_OPC,4] * M_PEDMAT[M_OPC,16])

  if M_PEDMAT[M_OPC][15] == "*"
    M_PEDSEL += M_PEDMAT[M_OPC, 5]
    M_PEDVLN -= (M_PEDMAT[M_OPC,4] * M_PEDMAT[M_OPC,16])
  endif

  LNPRO = 0

  popula_vetores()

  M_LINPOS = 0

return ""

***************
function INCPED
***************

local nKeyMouse, nKey

private M_TELA ,;
        M_OPC 

declare M_MSG[26] 

do while .t.

  rodape("EMISSAO","OR€AMENTO",M_FAN,"EAGRO22","Mem: " + str(memory(0), 5),M_EMP) 

  tlped01()

  M_PEDEMP  = ME_EMP
  M_PEDNUM  = AEMP00->EMPPED + 1
  M_PEDSER  = AEMP00->EMPPSE

*  do while .t.
*    set color to I
*      @ 04, 12 say M_PEDNUM picture "######"
*      @ 04, 19 say M_PEDSER picture "@!"
*    set color to
*    select APED00
*    if dbseek(str(M_PEDEMP, 2, 0) + str(M_PEDNUM, 6, 0) + M_PEDSER)
*      msg("* * * OR€AMENTO JA INCLUIDO * * *")
*      M_PEDNUM = M_PEDNUM + 1
*      loop
*    endif
*    exit
*  enddo

  M_PEDPRZ1 = "PRAZO DE ENTREGA       : 10 DIAS                            "
  M_PEDPRZ2 = "CONDICOES DE PAGAMENTO : A VISTA                            "
  M_PEDPRZ3 = "VALIDADE DA PROPOSTA   : 30 DIAS                            "
  M_PEDPRZ4 = "IPI                    : ISENTOS                            "
  M_PEDPRZ5 = "FRETE                  : FOOB                               "

  M_PEDDEC1 = "                                                            "
  M_PEDDEC2 = "                                                            "
  M_PEDDEC3 = "                                                            "
  M_PEDDEC4 = "                                                            "
  M_PEDDEC5 = "                                                            "
  M_PEDDEC6 = "                                                            "
  M_PEDDEC7 = "                                                            "


  M_PEDNFS  = 0
  M_PEDNSE  = "  "
  M_PEDDTE  = date()
  M_PEDEMI = M_LOGNOM

  M_PEDCLI  = 0
  M_PEDVEN  = 0
  M_PEDCPG  = 151

  M_PEDNAT  = 50000
  M_PEDOBS  = "N"
  M_PEDTRA  = 1
  M_PEDPOR  = 0
  M_NFSFRC  = " "
  M_PEDVLP  = 0
  M_PEDDSC  = 0
  M_PEDFRE  = 0
  M_PEDVLN  = 0
  M_PEDVLM  = 0
  M_PEDVICS = 0
  M_PEDVLMS = 0
  M_PEDVIC  = 0
  M_PEDIPL  = " "
  M_PEDEXT  = "U"

  M_PEDNOM = space(40)
  M_PEDEND = space(40)
  M_PEDBAI = space(15)
  M_PEDMUN = pad(AEMP00->EMPMUN, 19)
  M_PEDCEP = AEMP00->EMPCEP
  M_PEDCCL = AEMP00->EMPCCE
  M_PEDEST = AEMP00->EMPEST
  M_PEDIES = pad("N/C",15)
  M_PEDCGC = space(15)
  M_PEDTELTRA = space(15)

  M_PEDHS1 = space(60)
  M_PEDHS2 = space(60)
  M_PEDHS3 = space(60)

  M_PEDDP1 = 0
  M_PEDDP2 = 0
  M_PEDDP3 = 0
  M_PEDDP4 = 0 
  M_PEDDP5 = 0
  M_PEDDP6 = 0
 
  M_PEDVC1 = ctod("  /  /  ")
  M_PEDVC2 = ctod("  /  /  ")
  M_PEDVC3 = ctod("  /  /  ")
  M_PEDVC4 = ctod("  /  /  ")
  M_PEDVC5 = ctod("  /  /  ")
  M_PEDVC6 = ctod("  /  /  ") 

  M_CLIUF2 = space(02)
  M_CLIDCC = 1

  for R = 1 to 26
    M_MSG[R] = 0
  next 

  R         = 0

  // antes estava aqui
  
 edped01(.t.)

 if lastkey() = 27
   exit
 endif

 if M_PEDOBS = "S"
   verped12()
 endif

  R = 1        // sequencia
  L = 13       // linha inicial
  LNPRO  = 0
  M_LIMITE = 99

  M_PEDMAT = {}

  do while .t. 


*
*                  1   2   3   4   5   6   7 
*                SEQ MAT QDE PRB VLI LIQ COM

                                            
    aadd(M_PEDMAT,{0,  0,  0,  0,  0,  0,  0,space(40),0})

    M_PEDMAT[R,1] = R

    edped04(L,R)

    if lastkey() = 27 
      adel(M_PEDMAT,R)
      asize(M_PEDMAT,len(M_PEDMAT) - 1)
      exit
    endif

    calc_tot()     && calcula total do

    if L = 20
      lpped01()
      L = 12
    endif

    R ++
    L ++

    if ++ LNPRO >=  M_LIMITE
      exit
    endif

  enddo

  if len(M_PEDMAT) = 0
    msg("* * * OR€AMENTO NAO POSSUI ITENS * * *")
    exit
  endif

  lpped01()

  M_TELA1 = savescreen(06, 20, 18, 60)

  M_LINPOS = 0
  nPosach  = 1

  nAjusta = 0

  M_LINPOS   := 0
  nPosach    := 1
  lSaiEdicao := .f.
  lConsulta  := .f.

  do while .t.
    editaitensPed("I") // "I" para Inclusão, "A" para Alteração, "C" para Consulta

    if lSaiEdicao
      exit
    endif
  enddo

  calc_tot()     && calcula total do pedido



  M_OPC = msgbox3("Escolha uma Opcao",,,"Imprimir","Gravar","Abandonar")

  do case
     case M_OPC = 1 
         emiped(.t.)
     case M_OPC = 2
          graped(.t.)
     case M_OPC = 3 .or. lastkey() = 27
     M_OPZ = deciden("Tem Certeza que Quer Abandonar Orcamento")
     if M_OPZ == 1 
       exit
     endif
  endcase

enddo


restscreen(02, 04, 21, 77, M_TELA)

return ""

***********************
function LERLANCAMENTOSPED(sototal)
***********************

local nTOTALNFS := 0

if !sototal
  seexistesql("EDICOES")
  cSQL := "SELECT first 0 * from EDICOES"
  dbusearea(.t.,"SQLMIX",cSQL,"EDICOES")
endif

  for ABC = 1 to len(M_PEDMAT)
    if !sototal
      BUSCAREGISTRO("APCA00",1,{str(M_PEDMAT[ABC, 2],6,0)},"SELECT")
      select EDICOES
      append blank
      replace NFSSEQ with ABC
      replace NFSMAT with M_PEDMAT[ABC, 2]
      replace NFSQDE with M_PEDMAT[ABC, 3]
      replace NFSPRB with M_PEDMAT[ABC, 4]
      replace NFSVLI with M_PEDMAT[ABC, 5]
      replace PCADES with pad(APCA00->PCADES,30)
      replace PCADES1 with APCA00->PCADES

    endif

    nTOTALNFS += M_PEDMAT[ABC, 5]
  next

  calc_tot()


//*******************
function editaitensPed(fAcao)
//*******************

  local oBrowse, ABC, cColor
  local nColIni  := 10
  local cOpcoes
  local nTam
  local nButton  := 0
  local lBrowse  := .T.
  local nKeyMouse, nKey

  SET KEY K_SH_F3 TO
  SET KEY K_SH_F4 TO
  SET KEY K_SH_F5 TO
  SET KEY K_SH_F6 TO
  SET KEY K_SH_F7 TO

  SetKeyMouse( K_SH_F3 , {} )
  SetKeyMouse( K_SH_F4 , {} )
  SetKeyMouse( K_SH_F5 , {} )
  SetKeyMouse( K_SH_F6 , {} )
  SetKeyMouse( K_SH_F7 , {} )

  // Reseta e limpa a tabela temporária na memória (SQLMIX)
  seexistesql("EDICOES")
  cSQL := "SELECT first 0 * from EDICOES"
  dbusearea(.t.,"SQLMIX",cSQL,"EDICOES")

  lpped01()

  M_TELA1 = savescreen(06, 20, 18, 60)

  lerlancamentosPed(.f.)

  */*/
  
  if fAcao $ "IA"

    wvw_pbSetFont( ,'Visuallib', _FONTET_ -1 , _FONTEL_ -1 , 0, 200)
    nbt1 := wvw_pbCreate( 0, 24, 5, 24, 13, "1.Total", NIL, {|| VLKeyboard( CHR( 49 )) } )
    nbt2 := wvw_pbCreate( 0, 24, 15, 24, 26, "2.Desconto", NIL, {|| VLKeyboard( CHR( 50 )) } )
    nbt3 := wvw_pbCreate( 0, 24, 28, 24, 37, "3.Apagar", NIL, {|| VLKeyboard( CHR( 51 )) } )
    nbt4 := wvw_pbCreate( 0, 24, 39, 24, 50, "4.Adiciona", NIL, {|| VLKeyboard( CHR( 52 )) } )
    nbt5 := wvw_pbCreate( 0, 24, 52, 24, 64, "5.Cabecario", NIL, {|| VLKeyboard( CHR( 53 )) } )
    nbt6 := wvw_pbCreate( 0, 24, 66, 24, 76, "6.Emissao", NIL, {|| VLKeyboard( CHR( 54 )) } )

  endif

  select EDICOES
  go top

  */*/*/
  // Inicializa o TBrowseDB na área física correta (Linhas 17 a 25)
  cColor  := SetColor( 'N/W*,W/N+,W/R,W/G,N/W*,GR+/BG,R/W,G/W' )
  oBrowse := TBrowseDB(13, 3, 20, 76 )

  // Colunas perfeitamente alinhadas com o cabeçalho SAY da linha 15
  oBrowse:addColumn(TBColumnNew("",&("{||TRAN(NFSSEQ,[@R 99])}")))
  oBrowse:addColumn(TBColumnNew("",&("{||TRAN(NFSMAT,[@R 999999])}")))
  oBrowse:addColumn(TBColumnNew("",&("{||pad(PCADES,31)}")))
  oBrowse:addColumn(TBColumnNew("",&("{||TRAN(NFSQDE,[@R 999999999])}")))
  oBrowse:addColumn(TBColumnNew("",&("{||TRAN(NFSPRB,[@R 9999999.99])}")))
  oBrowse:addColumn(TBColumnNew("",&("{||TRAN(NFSVLI,[@R 9999999.99])}")))

  oBrowse:ColSep        := '³'
  oBrowse:HeadSep       := ''
  oBrowse:GoTopBlock    := { || dbGoTop() }
  oBrowse:GoBottomBlock := { || dbGoBottom() }
  oBrowse:SkipBlock     := { | nSkip | dbSkipBlock( nSkip, oBrowse ) }
  oBrowse:freeze        := 1
  oBrowse:colPos        := 1
  oBrowse:configure()

  // Força estabilização do cursor na linha inicial
  keyboard chr(4)
  oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{2,5} )

  do while (lBrowse)

    oBrowse:ForceStable()
    oBrowse:RefreshAll()

    select EDICOES
    setcolor("W+/N*")
    @ 22, 10 say PCADES1 // Mostra descrição longa na linha de status inferior

    SetColor( 'N/W*,W/N+,W/R,W/G,N/W*,GR+/BG,R/W,G/W' )
    oBrowse:RefreshAll()
    oBrowse:Stabilize()
    oBrowse:colPos := 1
    oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{2,5} )

    nKeyMouse := waitstate()

    select EDICOES

    if nKeyMouse:wsKey = 49 // .or. nKeyMouse:wsKey = K_F3 // 1
      wvw_pbenable(0,nbt1,.f.)
        totiteped()
        wvw_pbenable(0,nbt1,.t.)

        select EDICOES
        loop
    ENDIF

    if nKeyMouse:wsKey = 50 // 2
        wvw_pbenable(0,nbt2,.f.)
        dsciteped()
        wvw_pbenable(0,nbt2,.t.)
        select EDICOES
        loop
    ENDIF

    if nKeyMouse:wsKey = 51 // 3 apagar
        wvw_pbenable(0,nbt3,.f.)
        deliteped()
        lerlancamentosPed(.f.)
        wvw_pbenable(0,nbt3,.t.)

        select EDICOES
        go top

        oBrowse:RefreshAll()
        oBrowse:RefreshCurrent()
        oBrowse:Stabilize()
    ENDIF

    if nKeyMouse:wsKey = 52 // 4 adiciona
        wvw_pbenable(0,nbt4,.f.)
        insiteped()
        lerlancamentosPed(.f.)
        wvw_pbenable(0,nbt4,.t.)

        select EDICOES
        go top

        oBrowse:RefreshAll()
        oBrowse:RefreshCurrent()
        oBrowse:Stabilize()
    ENDIF


    if nKeyMouse:wsKey = 53 // 5
        wvw_pbenable(0,nbt5,.f.)
        edped01(.t.)
        wvw_pbenable(0,nbt5,.t.)

        select EDICOES
        loop
    ENDIF



    do case
      case (nKeyMouse:wsKey == 27) .or. (nKeyMouse:wsKey = 54)
        lBrowse := .F.
        lSaiEdicao := .t.
      case (nKeyMouse:wsKey == K_ENTER) // ENTER - Altera o item sob o cursor
        if !fAcao == "C"
          altiteped()
          lerlancamentosPed(.f.)
          select EDICOES
          go top

          oBrowse:RefreshAll()
          oBrowse:RefreshCurrent()
          oBrowse:Stabilize()
        endif

      case (nKeyMouse:wsKey == K_DOWN)
        oBrowse:down()

      case (nKeyMouse:wsKey == K_UP)
        oBrowse:up()

      case (nKeyMouse:wsKey == K_PGDN)
        oBrowse:pageDown()

      case (nKeyMouse:wsKey == K_PGUP)
        oBrowse:pageUp()

      case (nKeyMouse:wsKey == K_CTRL_PGUP)
        oBrowse:goTop()

      case (nKeyMouse:wsKey == K_CTRL_PGDN)
        oBrowse:goBottom()

    endcase

    oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{1,2} )

    M_OPC    := RECNO()
    M_LINPOS := oBrowse:RowPos - 1

    select EDICOES
    oBrowse:RefreshCurrent()
    oBrowse:Stabilize()

  enddo

  // Desativa os gatilhos de teclas e cliques do mouse ao sair do grid

  SET KEY K_SH_F3 TO
  SET KEY K_SH_F4 TO
  SET KEY K_SH_F5 TO
  SET KEY K_SH_F6 TO
  SET KEY K_SH_F7 TO

  SetKeyMouse( K_SH_F3 , {} )
  SetKeyMouse( K_SH_F4 , {} )
  SetKeyMouse( K_SH_F5 , {} )
  SetKeyMouse( K_SH_F6 , {} )
  SetKeyMouse( K_SH_F7 , {} )

  wvw_pbdestroy(0,nbt1)
  wvw_pbdestroy(0,nbt2)
  wvw_pbdestroy(0,nbt3)
  wvw_pbdestroy(0,nbt4)
  wvw_pbdestroy(0,nbt5)
  wvw_pbdestroy(0,nbt6)

return ""


******************
function ALTITEPED  && altera item da nota
******************


  edped04(13 + M_LINPOS,M_OPC)

  LNPRO = 0

  popula_vetores()

  M_LINPOS = 0

return ""

******************
function INSITEPED && insere item na nota
******************



private R,S


  LNPRO = 0

  aadd(M_PEDMAT,{0,  0,  0,  0,  0,  0,  0,space(40),0})

  R = len(M_PEDMAT)

  M_MATANT = aclone(M_PEDMAT)

  acopy(M_MATANT,M_PEDMAT,R,1,M_OPC)

  if M_OPC-1 = 1
    acopy(M_MATANT,M_PEDMAT,M_OPC-1,M_OPC-1,1)
  endif

  acopy(M_MATANT,M_PEDMAT,M_OPC,R-M_OPC,M_OPC+1)

  M_PEDMAT[M_OPC, 1] = R                 && SEQ

  for S = 1 to len(M_PEDMAT) 
    M_PEDMAT[S,1] = S
  next

  edped04(13 + M_LINPOS, M_OPC)

return ""

******************
function DELITEPED && deleta item da nota
******************

private M_PED, R

do while .t.
  M_PED = msgbox3("Escolha uma Opcao",,10,"Escolha","Sim","NÆo")

  if M_PED = 3
    return ""
  endif

  if M_PED = 2
    adel(M_PEDMAT,M_OPC)

    asize(M_PEDMAT,len(M_PEDMAT) - 1)

     if len(M_PEDMAT) = 0
       lpped01()
       M_LINPOS = 0
       return ""
     endif

    lpped01()
    exit
  endif

enddo

return ""

******************
function DSCITEPED  && desconto na nota    
******************

setcolor(_COREDICAO_)
  @ 08, 48 get M_PEDDSC  picture "#######.##"
  @ 08, 64 get M_PEDFRE  picture "#######.##"
  read
  
******************
function TOTITEPED                     && mostra dados e calcula nota fiscal
******************


private  M_TELA ,;
         R

   M_PEDVLP = 0
   M_PEDVLN = 0
   M_PEDVLM = 0
   M_PEDVIC = 0

   M_PEDVICS = 0
   M_PEDVLMS = 0

    for R = 1 to len(M_PEDMAT)            && calcula o valor bruto da nota
      M_PEDVLP = M_PEDVLP + M_PEDMAT[R,5]
      if "ALUGUEL" $ M_PEDMAT[R,8]
        M_PEDVICS = M_PEDVICS + M_PEDMAT[R,5]
      else
        M_PEDVLMS = M_PEDVLMS + M_PEDMAT[R,5]
      endif
    next

    for R = 1 to len(M_PEDMAT)                    && calcula o valor liquido da nota

      if M_PEDDSC > 0
        M_PEDMAT[R,6] = (M_PEDMAT[R,5] - ((M_PEDDSC/M_PEDVLP) * M_PEDMAT[R,5]))
      else
        M_PEDMAT[R,6] = M_PEDMAT[R,5]
      endif

      if "ALUGUEL" $ M_PEDMAT[R,8]
        M_PEDVIC = M_PEDVIC + M_PEDMAT[R,6]
      else
        M_PEDVLM = M_PEDVLM + M_PEDMAT[R,6]
      endif

      M_PEDVLN = M_PEDVLN + M_PEDMAT[R,6]

    next R

    M_PEDVLN = M_PEDVLN + M_PEDFRE

    M_TELA = savescreen(06, 20, 16, 62)

    nbox(06, 20, 12, 59,"W/W+",.t.)
    setcolor("BG/W")
*     @ 06, 20 say  "                                        "
      @ 07, 21 say  "  Valor do Produto:                   "
      @ 08, 21 say  "  Valor do Aluguel:                   "
      @ 09, 21 say  "          Desconto:                   "
      @ 10, 21 say  "             Frete:                   "
      @ 11, 21 say  "         Or‡amento:                   "
*     @ 12, 20 say  "                                      "
  setcolor("N/W")
      @ 07, 41 say M_PEDVICS          picture "@E ###,###,###,###.##"
      @ 08, 41 say M_PEDVLMS          picture "@E ###,###,###,###.##"
      @ 09, 41 say M_PEDDSC           picture "@E ###,###,###,###.##"
      @ 10, 41 say M_PEDFRE           picture "@E ###,###,###,###.##"
      @ 11, 41 say M_PEDVLN           picture "@E ###,###,###,###.##"
    set color to
     
    msg("* * * TECLE (ENTER) * * *")

    restscreen(06, 20, 16, 62, M_TELA)

return ""

*****************
function CALC_TOT                      && calcula total do pedido
*****************

  private R

  M_PEDVLP = 0
  M_PEDVLN = 0

  M_PEDVLM = 0
  M_PEDVIC = 0
  M_PEDVLMS = 0
  M_PEDVICS = 0

  for R = 1 to len(M_PEDMAT)            && calcula o valor bruto da nota
    M_PEDVLP = M_PEDVLP + M_PEDMAT[R,5]
  next

  for R = 1 to len(M_PEDMAT)                    && calcula o valor liquido da nota
    if M_PEDDSC > 0
      M_PEDMAT[R,6] = (M_PEDMAT[R,5] - ((M_PEDDSC/M_PEDVLP) * M_PEDMAT[R,5]))
    else
      M_PEDMAT[R,6] = M_PEDMAT[R,5]
    endif

    if "ALUGUEL" $ M_PEDMAT[R,8]
      M_PEDVIC = M_PEDVIC + M_PEDMAT[R,6]
      M_PEDVICS = M_PEDVICS + M_PEDMAT[R,5]
    else
      M_PEDVLM = M_PEDVLM + M_PEDMAT[R,6]
      M_PEDVLMS = M_PEDVLMS + M_PEDMAT[R,5]
    endif

    M_PEDVLN = M_PEDVLN + M_PEDMAT[R,6]
  next R

  M_PEDVLN = M_PEDVLN + M_PEDFRE


setcolor("G/W")
@ 09, 64 say M_PEDVLN picture "@R 999,999.99"
setcolor("")


return ""

***************
function ALTPED
***************

private M_TELA ,;
        M_OPC 

declare M_MSG[26]

lPri = .t.

do while .t.

  M_PEDMAT = {}

  rodape("ALTERA","OR€AMENTO",M_FAN,"EAGRO22","Mem: " + str(memory(0), 5),M_EMP) 

  tlped01()

  M_PEDEMP  = ME_EMP
  M_PEDNUM  = 0
  M_PEDSER  = AEMP00->EMPPSE

  SetColor(_COREDICAO_)
  @ 04, 12 get M_PEDNUM picture "######"
  @ 04, 19 get M_PEDSER picture "@!"
  read

  if M_PEDNUM = 0 .or. lastkey() = 27
    exit
  endif

  if !BUSCAREGISTRO("APED00",1,{str(M_PEDEMP, 2, 0),str(M_PEDNUM, 6, 0),aspas(M_PEDSER)},"SELECT")
    msg("* * * OR€AMENTO NAO INCLUIDO * * *")
    loop
  endif

  for R = 1 to 26
    M_MSG[R] = 0
  next 

  M_PEDNFS  = PEDNFS
  M_PEDNSE  = PEDNSE
  M_PEDDTE  = PEDDTE
  M_PEDEMI  = PEDEMI
  M_NFSFRC  = PEDFRC
  M_PEDCLI  = PEDCLI
  M_PEDVEN  = PEDVEN
  M_PEDCPG  = PEDCPG
  M_PEDEXT  = PEDEXT
  M_PEDNAT  = PEDNAT
  M_PEDTRA  = PEDTRA
  M_PEDPOR  = PEDPOR

  M_PEDOBS  = PEDOBS
  M_PEDTELTRA = PEDTELTRA
  M_PEDVLP  = PEDVLP
  M_PEDDSC  = PEDDSC
  M_PEDFRE  = PEDFRE
  M_PEDVLN  = 0
  M_PEDVLM  = 0
  M_PEDVIC  = 0
  M_PEDVLMS = 0
  M_PEDVICS = 0
  M_PEDIPL  = PEDIPL
  R         = 0

  M_PEDNOM = PEDNOM
  M_PEDEND = PEDEND
  M_PEDBAI = PEDBAI
  M_PEDMUN = PEDMUN
  M_PEDCEP = PEDCEP
  M_PEDCCL = PEDCCL
  M_PEDEST = PEDEST
  M_PEDIES = PEDIES
  M_PEDCGC = PEDCGC

  M_CLIUF2   = space(02)
  M_CLIDCC   = 1

  M_PEDHS1 = PEDHS1
  M_PEDHS2 = PEDHS2
  M_PEDHS3 = PEDHS3

  M_PEDDP1 = PEDDP1
  M_PEDDP2 = PEDDP2
  M_PEDDP3 = PEDDP3
  M_PEDDP4 = PEDDP4
  M_PEDDP5 = PEDDP5
  M_PEDDP6 = PEDDP6
 
  M_PEDVC1 = PEDVC1
  M_PEDVC2 = PEDVC2
  M_PEDVC3 = PEDVC3
  M_PEDVC4 = PEDVC4
  M_PEDVC5 = PEDVC5
  M_PEDVC6 = PEDVC6

  M_PEDPRZ1 = PEDPRZ1
  M_PEDPRZ2 = PEDPRZ2
  M_PEDPRZ3 = PEDPRZ3
  M_PEDPRZ4 = PEDPRZ4
  M_PEDPRZ5 = PEDPRZ5

  M_CLIDCC   = 1

  edped01(.f.)     

  if lastkey() = 27
    exit
  endif

  if M_PEDOBS = "S"
    verped12()
  endif

  LNPRO  = 0

  M_LIMITE = 99

  R = 1        // sequencia
  L = 12       // linha inicial

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"APED01","APED01"})
  aadd(sqlCAMPO,"APED01.*")
  aadd(sqlCAMPO,"APCA00.PCADES")
  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","APED01.PEDMAT"})
  aadd(sqlCHAVE,"PEDEMP = " + str(M_PEDEMP,2))
  aadd(sqlCHAVE,"PEDNUM = " + str(M_PEDNUM,9))
  aadd(sqlCHAVE,"PEDSER = " + aspas(M_PEDSER))
  sqlrelation()

  do while !eof()

    aadd(M_PEDMAT,{0,  0,  0,  0,  0,  0,  0,space(40),0})
 
    M_PEDMAT[R,  1] = PEDSEQ
    M_PEDMAT[R,  2] = PEDMAT
    M_PEDMAT[R,  3] = PEDQDE
    M_PEDMAT[R,  4] = PEDPRB
    M_PEDMAT[R,  5] = PEDVLI
    M_PEDMAT[R,  6] = PEDLIQ
    M_PEDMAT[R,  7] = PEDCOM
    M_PEDMAT[R,  8] = PCADES

    R++

    skip

  enddo

  lpped01()

  M_TELA1 = savescreen(06, 20, 18, 60)

  if len(M_PEDMAT) = 0
    msg("* * * OR€AMENTO NAO POSSUE ITENS DEVERA SER EXCLUIDO * * *")
    loop
  endif

  declare M_VETORITE[len(M_PEDMAT)]

  for R = 1 to len(M_PEDMAT)
    M_VETORITE[R] = str(M_PEDMAT[R, 1], 2, 0) + " " + ;
                    str(M_PEDMAT[R, 2], 6, 0) + " " + ;
                    pad(M_PEDMAT[R ,8], 31)   + " " + ;
                    str(M_PEDMAT[R, 3], 9, 0) + " " + ;
                    str(M_PEDMAT[R, 4],10, 2) + " " + ;
                    str(M_PEDMAT[R, 5],10, 2) 
  next

  M_LINPOS = 0
  nPosach  = 1

  do while .t.
    set color to GR+
      @ 22, 10 say "        1.Total  2.Desc/Fre  3.Deleta  4.Adiciona  5.Insere  6.Sair"
    set color to R+
      @ 22, 21-3 say "1"
      @ 22, 30-3 say "2"
      @ 22, 42-3 say "3"
      @ 22, 52-3 say "4"
      @ 22, 64-3 say "5"
      @ 22, 74-3 say "6"
    set color to N/W,W+/N
      M_OPC = achoice(13, 3,20,75,M_VETORITE,,"mosped",nPosach)
    set color to 

    if lastkey() = 13
      altiteped() && altera item
      loop
    endif

    if lastkey() = 51
      deliteped() && deleta item 
      loop
    endif

    if lastkey() = 49
      totiteped() && total   
      loop
    endif

    if lastkey() = 50
      dsciteped() && desconto
      loop
    endif


    if lastkey() = 53
      insiteped() && insere item
      loop
    endif

    if lastkey() = 54
      exit        && abandona operacao
    endif

  enddo

  calc_tot()     && calcula total do pedidoE

  M_OPC = msgbox3("Escolha uma Opcao",,,"Imprimir","Gravar","Abandonar")

  do case
     case M_OPC = 1 
         emiped(.f.)
         exit
     case M_OPC = 2 
         graped(.f.)
         exit
     case M_OPC = 3 .or. lastkey() = 27
     M_OPZ = deciden("Tem Certeza que Quer Abandonar Orcamento")
     if M_OPZ == 1 
       exit
     endif
  endcase

enddo

restscreen(02, 04, 21, 77, M_TELA)

return ""

***************
function CONPED
***************
parameters M_OPC,M_OPC1,M_OPC2

*        @ 11, 24 prompt "Pedido     " HIGHLITE R/BG
*        @ 12, 24 prompt "Cliente    " HIGHLITE R/BG
*        @ 13, 24 prompt "Fornecedor " HIGHLITE R/BG

      do case
         case M_OPC = 1 ; conped_a()
         case M_OPC = 2 ; conped_b("C")
         case M_OPC = 3 ; conped_b("F")
      endcase             

return ""

*****************
function CONPED_A
*****************

  lPri = .t.
  
  do while .t.

    rodape("CONSULTA", "OR€AMENTO", M_FAN, "EAGRO22","Mem: " + str(memory(0), 5), M_EMP)

    tlped01()

    M_PEDEMP  = ME_EMP
    M_PEDNUM  = 0
    M_PEDSER  = AEMP00->EMPPSE

    SetColor(_COREDICAO_)
    @ 04, 12 get M_PEDNUM picture "######"
    @ 04, 19 get M_PEDSER picture "@!"
    read

    if M_PEDNUM = 0
      exit
    endif

    if !BUSCAREGISTRO("APED00",1,{str(M_PEDEMP, 2, 0),str(M_PEDNUM, 6, 0),aspas(M_PEDSER)},"SELECT")
      msg("* * * OR€AMENTO NAO INCLUIDO * * *")
      loop
    endif

    msped01()
    msped03()

  enddo

return ""

***************
function MOSTEP
***************

parameters  M_MODO, M_ELEM, M_POSI


  if str(lastkey(), 2, 0) $ " 3#18"
    return 0
  endif

  if str(lastkey(), 3, 0)  $ " 27# 13"
    M_OPC = M_ELEM
    return 1
  endif

  M_LINPOS = M_POSI

return 2

*****************
function CONPED_B(TIPO)
*****************
private MT_ITENS[12] ,;
        MT_NUMPE[12] ,;
        MT_OBSE1[12] ,;
        MT_OBSE2[12] ,;
        MT_OBSE3[12] ,;
        M_TECLA     ,;
        M_TELA

  do while .t.

    rodape("CONSULTA", "OR€AMENTO", M_FAN, "EAGRO22","Mem: " + str(memory(0), 5), M_EMP)

    tlped02(TIPO)

    M_PEDEMP  = ME_EMP
    M_PEDCLI  = 0
    M_TECLA   = 0

    SetColor(_COREDICAO_)
    @ 04, 15 get M_PEDCLI picture "#######" F2 color _CORF2_ funcao "sele_arquivo('ACLI00')" retorno @M_PEDCLI
    read

    if lastkey() = 27
      exit
    endif

    if !valorescli(M_PEDCLI)
      msg("* * * CLIENTE NAO CADASTRADO * * *")
      loop
    endif
  
    setcolor("N/W*")
      @ 04, 29 say pad(ACLI00->CLINOM, 29)
      @ 04, 64 say pad(ACLI00->CLIMUN2, 12)
    set color to 

    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"APED00","APED00"})
    aadd(sqlCAMPO,"APED00.*")
    aadd(sqlCAMPO,"AVEN00.VENNOM")
    aadd(sqlRELATION,{"AVEN00","AVEN00.VENCOD","APED00.PEDVEN"})
    aadd(sqlCHAVE,"PEDEMP = " + str(M_PEDEMP,2))
    aadd(sqlCHAVE,"PEDCLI = " + str(M_PEDCLI,7))
    aadd(sqlORDEM,"PEDDTE desc, PEDNUM")

    sqlrelation()

    if eof()
      msg("* * * NADA A CONSULTAR NESTE CLIENTE * * *")
      loop
    endif

    MT_ITENS = { }
    MT_NUMPE = { }
    MT_OBSE1 = { }
    MT_OBSE2 = { }
    MT_OBSE3 = { }

    do while !eof()

*     if PEDNATN == "6.000"
*       skip
*       loop
*     endif

*     AVEN00->(dbseek(str(APED00->PEDVEN, 3, 0)))

      aadd(MT_ITENS,dtoc(PEDDTE)  + " " +  str(PEDNUM, 6, 0) + " " + PEDSER + " " + str(PEDCPG, 3, 0) + " " + str(PEDTRA, 3, 0) + " " + str(PEDVEN, 3, 0) + " " + pad(VENNOM, 11) + " " + pad(PEDNATN,6) + " " + str(PEDNFS, 6, 0) + " " + PEDSER +  " " + transform(PEDVLN,"@E ####,###.##"))
      aadd(MT_NUMPE,{ME_EMP,PEDNUM,PEDSER})
      aadd(MT_OBSE1,PEDHS1)
      aadd(MT_OBSE2,PEDHS2)
      aadd(MT_OBSE3,PEDHS3)

      skip

    enddo

    visualpeb(MT_ITENS,MT_NUMPE,MT_OBSE1,MT_OBSE2,MT_OBSE3)

  enddo
  
  APED00->(dbsetorder(1))

return ""

******************
function VISUALPEB
******************

parameters V1,V2,V3,V4,V5

private S      ,;
        M_OPC  ,;
        M_AREA ,;
        M_TELA

  M_AREA = alias()


  set color to I
    @ 17, 11 say V3[1]
    @ 18, 11 say V4[1]
    @ 19, 11 say V5[1]
  set color to

  nPosach  = 1

  do while .t.

    set color to N/W,W+/N
      M_OPC = achoice(08,05,15,75,V1,,"mosvrb",nPosach)
    set color to 

    if rat(str(lastkey(), 2, 0),"27") > 0
      exit
    endif
  
    if rat(str(lastkey(), 2, 0),"13#") > 0
      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {"APED00","SELECT"}
      aadd(sqlCHAVE,{"PEDEMP",str(V2[M_OPC][1],2)})
      aadd(sqlCHAVE,{"PEDNUM",str(V2[M_OPC][2],6)})
      aadd(sqlCHAVE,{"PEDSER",aspas(V2[M_OPC][3])})
      executasql()


        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"APED01","APED01"})
        aadd(sqlCAMPO,"APED01.*")
        aadd(sqlCAMPO,"APCA00.PCADES")
        aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","APED01.PEDMAT"})
        aadd(sqlCHAVE,"PEDEMP = " + str(V2[M_OPC][1],2))
        aadd(sqlCHAVE,"PEDNUM = " + str(V2[M_OPC][2],6))
        aadd(sqlCHAVE,"PEDSER = " + aspas(V2[M_OPC][3]))
        sqlrelation()

      mosdatped() && mostra dados tecnicos
      loop
    endif

  enddo

  select &M_AREA

return lastkey()

***************
function MOSVRB
***************

parameters  M_MODO, M_ELEM, M_POSI


 nPosach = M_ELEM

 if rat(str(lastkey(), 2, 0),"27") > 0
    return 0
 endif

 if rat(str(lastkey(), 2, 0),"13") > 0
   M_OPC = M_ELEM
   return 1
 endif

 set color to I
   @ 17, 11 say V3[M_ELEM]
   @ 18, 11 say V4[M_ELEM]
   @ 19, 11 say V5[M_ELEM]
 set color to N/W,W+/N

return 2

******************
function MOSDATPED
******************

LOCAL M_TELA9 := savescreen(01, 01, 22, 79)

parameters F_CHAVE

private R, L, M_OPC , M_VERTORITE


  tlped01()

  select APED00
  msped01()

  select APED01

  L = 0

  M_VETORITE = { }

  R = 1

  do while !eof()

    aadd(M_VETORITE,str(PEDSEQ, 2, 0) + " " + ;
                      str(PEDMAT, 6, 0) + " " + ;
                      pad(PCADES, 31) + " " + ;
                      str(PEDQDE, 9, 3) + " " + ;
                      str(PEDPRB,10, 2) + " " + ;
                      str(PEDVLI,10, 2) + " ")
  
    skip

    R = R + 1
  enddo

  M_LINPOS = 0

  do while .t.

    if len(M_VETORITE) = 0
      msg("ORCAMENTO NAO POSSUI ITENS")
      exit
    endif
    
    set color to N/W,W+/N
    M_OPC = achoice(12, 3,19,75,M_VETORITE,,"mostec")
    set color to 

    if lastkey() = 27
      exit        && abandona operacao
    endif
  enddo

restscreen(01, 01, 22, 79, M_TELA9)

return ""

***************
function EXCPED   
***************

private M_OPC 

  do while .t.

    rodape("EXCLUI", "OR€AMENTO", M_FAN, "EAGRO22","Mem: " + str(memory(0), 5), M_EMP)

    tlped01()

    M_PEDEMP  = ME_EMP
    M_PEDNUM  = 0
    M_PEDSER  = AEMP00->EMPPSE

    SetColor(_COREDICAO_)
    @ 04, 12 get M_PEDNUM picture "######"
    @ 04, 19 get M_PEDSER picture "@!"
    read

    if M_PEDNUM = 0
      exit
    endif

    if !BUSCAREGISTRO("APED00",1,{str(M_PEDEMP, 2, 0),str(M_PEDNUM, 6, 0),aspas(M_PEDSER)},"SELECT")
      msg("* * * OR€AMENTO NAO INCLUIDO * * *")
      loop
    endif

    msped01()
    msped03()

    M_OPC = confirma("deste Pedido")

    if M_OPC != 1
      msg("* * * OR€AMENTO NAO EXCLUIDO * * *")
      loop  
    endif

    msw("* * * EXCLUINDO OR€AMENTO * * *")


    grped01("DELETE")

    sqlCAMPO = {}
    sqlCHAVE = {}
    sqlARQUI = {"APED01","DELETE"}
    aadd(sqlCHAVE,{"PEDEMP",str(M_PEDEMP,2)})
    aadd(sqlCHAVE,{"PEDNUM",str(M_PEDNUM,6)})
    aadd(sqlCHAVE,{"PEDSER",aspas(M_PEDSER)})
    executasql()

    msg("* * * OR€AMENTO EXCLUIDO * * *")

  enddo


return ""

***************
function LISPED
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("MENU","RELATORIOS",M_FAN,"EAGRO22","Mem: " + str(memory(0), 5),M_EMP) 

*        @ 08, 24 prompt      "Listagem de Pedidos   " HIGHLITE R/BG
*        @ 09, 24 prompt      "Relacao por Produto   " HIGHLITE R/BG
*        @ 10, 24 prompt      "Sintetica Pedidos     " HIGHLITE R/BG
*        @ 11, 24 prompt      "Relacao por Grupo     " HIGHLITE R/BG
*        @ 12, 24 prompt      "Relacao por Cliente   " HIGHLITE R/BG
*        @ 13, 24 prompt      "Analitico por Vendedor" HIGHLITE R/BG

        do case
           case M_OPC = 1 ; lisped_a()
           case M_OPC = 2 ; relped_a()
           case M_OPC = 3 ; lisped_c()
           case M_OPC = 4 ; relped_c()
           case M_OPC = 5 ; relped_d()
           case M_OPC = 6 ; relped_e()
        endcase


return ""

*****************
function LISPED_A
***************** 

private M_PED1 ,;
        M_PED2 ,;
        M_SER1 ,;
        M_SER2 ,;
        LN     ,;
        PG     ,;
        M_ESC  ,;
        M_TELA
 
    do while .t.

        rodape("LISTA","OR€AMENTO",M_FAN,"EAGRO22","Mem: " + str(memory(0), 5),M_EMP) 

        store 0         to M_PED1 ,;
                           M_PED2 ,;
                           M_PROD

        store AEMP00->EMPPSE to M_SER1 ,;
                                M_SER2

        store date()           to M_DTA1 ,;
                                  M_DTA2 

       sombra(12, 35, 18, 71,_SOMBRA_)

       set color to GR/W
         @ 12, 35 say            "                                     "
         @ 13, 35 say            "   Numero Pedido Inicial:            "
         @ 14, 35 say            "                   Final:            "
         @ 15, 35 say            "    Data Emissao Inicial:            "
         @ 16, 35 say            "                   Final:            "
         @ 17, 35 say            "                 Produto:            "
         @ 18, 35 say            "                                     "
    SetColor(_COREDICAO_)
         @ 13, 61 get M_PED1 picture "######"
         @ 13, 68 get M_SER1 picture "@!"
         @ 14, 61 get M_PED2 picture "######"
         @ 14, 68 get M_SER2 picture "@!"
         @ 15, 61 get M_DTA1
         @ 16, 61 get M_DTA2
         @ 17, 61 get M_PROD picture "######"
         read
       set color to

        if lastkey() = 27
          return ""
        endif

        M_PED1 = iif(M_PED1 = 0,     1,M_PED1)
        M_PED2 = iif(M_PED2 = 0,999999,M_PED2) 

        M_DTA1 = iif(dtoc(M_DTA1) = "  /  /  ",ctod("01/01/80"),M_DTA1)
        M_DTA2 = iif(dtoc(M_DTA2) = "  /  /  ",ctod("31/12/79"),M_DTA2) 

        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"APED00","APED00"})
        aadd(sqlCAMPO,"APED00.*")
        aadd(sqlCAMPO,"APED01.PEDMAT")
        aadd(sqlCAMPO,"APED01.PEDSEQ")
        aadd(sqlCAMPO,"APED01.PEDQDE")
        aadd(sqlCAMPO,"APED01.PEDPRB")
        aadd(sqlCAMPO,"APED01.PEDVLI")
        aadd(sqlCAMPO,"APCA00.PCADES")
        aadd(sqlCAMPO,"APCA00.PCAREF")
        aadd(sqlCAMPO,"AFIS00.FISNOM")
        aadd(sqlCAMPO,"ACLI00.CLINOM")
        aadd(sqlRELATION,{"APED01","APED01.PEDEMP","APED00.PEDEMP"})
        aadd(sqlRELATION,{"","APED01.PEDNUM","APED00.PEDNUM"})
        aadd(sqlRELATION,{"","APED01.PEDSER","APED00.PEDSER"})
        aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","APED01.PEDMAT"})
        aadd(sqlRELATION,{"AFIS00",str(ME_EMP,2),"AFIS00.FISEMP"})
        aadd(sqlRELATION,{"","AFIS00.FISNOV","APED00.PEDNATN"})
        aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","APED00.PEDCLI"})
        aadd(sqlCHAVE,"APED00.PEDDTE BETWEEN " + aspas(formatdta(M_DTA1)) + " and " + aspas(formatdta(M_DTA2)))
        aadd(sqlCHAVE,"APED00.PEDNUM BETWEEN " + str(M_PED1,6) + " and " + str(M_PED2,6))
        aadd(sqlCHAVE,"APED00.PEDEMP = " + str(ME_EMP, 2, 0))
        aadd(sqlCHAVE,"APED00.PEDSER = " + aspas(M_SER1))

        if M_PROD > 0
          aadd(sqlCHAVE,"APED01.PEDMAT = " + str(M_PROD, 6, 0))
        endif

        aadd(sqlORDEM,"PEDDTE,PEDNUM,PEDSEQ")
        if !sqlrelation()
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          loop
        endif

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

       store 0 to PG ,;
                  LN

       cab_ped1()


       do while !eof()

          select APED00

          cab_ped2()

           ? str(PEDNUM, 6, 0)
            ?? "  "
            ?? PEDSER
            ?? " "
            ?? PEDNATN
            ?? "  "
            ?? pad(FISNOM, 27)
            ?? " " 
            ?? PEDDTE
            ?? " "
            ?? str(PEDCLI, 7, 0)
            ?? " "
            ?? left(CLINOM, 32)
            ?? " " 
            ?? str(PEDVEN, 3, 0)
            ?? " "
            ?? space(08)
            ?? "  "
            ?? transform(PEDVLN,"@E ###,###,###.##") 
            ?? "  "
            ?? PEDIPL
 
            LN = LN + 1

            if LN > 60
              cab_ped1()
              cab_ped2()
            endif  

            M_PEDNUM = PEDNUM

         cab_ped3()

         do while !eof() 

            if !str(PEDNUM, 6, 0) == str(M_PEDNUM, 6, 0)
              exit
            endif

             ? "   "
              ?? str(PEDSEQ, 2, 0)
              ?? "     " 
              ?? transform(str(PEDMAT, 6, 0),"@R 9999999")
              ?? "            " 
              ?? pad(PCAREF, 10)
              ?? " " 
              ?? PCADES
              ?? " "
              ?? str(PEDQDE, 9, 3)
              ?? " "
              ?? " "
              ?? " "
              ?? transform(PEDPRB,"@E ###,###,###.##") 
              ?? "  "
              ?? transform(PEDVLI,"@E ###,###,###.##") 
                         
              LN = LN + 1

              if LN > 60 
                cab_ped1()
                cab_ped3()
              endif
  
              skip 

         enddo

         select APED00

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

       ? replicate("=", 132)

       eject

desliga1()

enddo 

return "" 


*****************
function CAB_PED1
*****************

 PG = PG + 1

 if PG > 1
   eject
 endif

 ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE OR€AMENTO","EAGRO22",132) 
 ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)

 LN = 2

return ""

*****************
function CAB_PED2
*****************

 ? replicate("-",132)  
 ? "DOCTO   SE CODFIS                              EMISSAO  CLIENTE                                VEN DATA SAIDA   VLR TOTAL   SITUACAO"

 LN = LN + 2

return ""

*****************
function CAB_PED3
*****************

  ?
  ? "   SEQ    CODIGO            REFERENCIA DESCRICAO                                            QUANTIDADE  VLR UNITARIO   VALOR  TOTAL" 

  LN = LN + 2

return ""

*****************
function RELPED_A                      && relacao de vendas por produtos
*****************

private M_TOTAL ,;
        M_DATA1 ,;
        M_DATA2 ,;
        M_ESC   ,;
        PG, LN  ,;
        M_TOTGER,;
        M_TOTVIS,;
        M_TOTPRZ,;
        M_SOMPER,;
        M_TELA  ,;
        M_TIPO
                   
if file("APED02.CDX")
  erase("APED02.CDX")
endif

use APED02 alias APED02 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

    rodape("OR€AMENTO","PRODUTO",M_FAN,"EAGRO22","Mem: " + str(memory(0), 5),M_EMP)


    store date() to M_DATA1 ,;
                    M_DATA2

     sombra(13, 35, 16, 61,_SOMBRA_)
     set color to GR/W
       @ 13, 35 say              "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 14, 35 say              "³Periodo Inicial:         ³" 
       @ 15, 35 say              "³          Final:         ³" 
       @ 16, 35 say              "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
     SetColor(_COREDICAO_)
     @ 14, 53 get     M_DATA1
     @ 15, 53 get     M_DATA2
     read

     if lastkey() = 27
        return ""
     endif

     store 0 to M_TOTGER

     select APED02

     if !flock()
       msg("* * * (APED02) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(PEDEMP, 2, 0) + str(PEDMAT, 6, 0)  tag 1 to APED02
     index on str(PEDEMP, 2, 0) + str(PEDVLN, 14, 2) tag 2 to APED02

     set index to APED02 
  
        sqlRELATION = {}
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"APED00","APED00"})
        aadd(sqlCAMPO,"APED00.*")
        aadd(sqlCAMPO,"APED01.PEDMAT")
        aadd(sqlCAMPO,"APED01.PEDSEQ")
        aadd(sqlCAMPO,"APED01.PEDQDE")
        aadd(sqlCAMPO,"APED01.PEDPRB")
        aadd(sqlCAMPO,"APED01.PEDLIQ")
        aadd(sqlCAMPO,"APCA00.PCADES")
        aadd(sqlCAMPO,"APCA00.PCAREF")
        aadd(sqlCAMPO,"ACLI00.CLINOM")
        aadd(sqlRELATION,{"APED01","APED01.PEDEMP","APED00.PEDEMP"})
        aadd(sqlRELATION,{"","APED01.PEDNUM","APED00.PEDNUM"})
        aadd(sqlRELATION,{"","APED01.PEDSER","APED00.PEDSER"})
        aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","APED01.PEDMAT"})
        aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","APED00.PEDCLI"})
        aadd(sqlCHAVE,"APED00.PEDDTE BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
        aadd(sqlCHAVE,"APED00.PEDEMP = " + str(ME_EMP, 2, 0))
        aadd(sqlORDEM,"PEDDTE,PEDNUM,PEDSEQ")
        if !sqlrelation()
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          return ""
        endif

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

          do while !eof()

            select APED02
            seek str(APED00->PEDEMP, 2, 0) + str(APED00->PEDMAT, 6, 0)

            if eof()
              append blank         
              replace PEDEMP with APED00->PEDEMP
              replace PEDMAT with APED00->PEDMAT
            endif

            replace PEDQDE with PEDQDE + APED00->PEDQDE

            if strzero(APED00->PEDCPG, 3) $ "000#001#002"
              replace PEDVIS with PEDVIS + APED00->PEDLIQ
              replace PEDVLN with PEDVLN + APED00->PEDLIQ
            endif            

            if APED00->PEDCPG >= 20
              replace PEDPRZ with PEDPRZ + APED00->PEDLIQ
              replace PEDVLN with PEDVLN + APED00->PEDLIQ
            endif            

            M_TOTGER = M_TOTGER + APED00->PEDLIQ

            select APED00

            M_ESC = inkey()

            if M_ESC = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                return ""
              else
                M_ESC = inkey()
              endif
            endif

            skip
 
          enddo

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        store  0 to PG, LN   ,;
                    M_TOTVIS ,;
                    M_TOTPRZ ,;
                    M_SOMPER 
          
        select APED02
        set order to 2

        go bottom
                 
        do while !bof()
                              
            store PG + 1 to  PG 

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO DE " + iif(M_TIPO="S","VENDA",iif(M_TIPO="T","TRANSFERENCIA","COMPRA")) + " POR PRODUTOS","EAGRO22",132) 
            ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
            ? "*-------*----------------------------------------*---------*------------------*------------------*------------------*------*-------*"
            ? "* PROD  *        DESCRICAO DO PRODUTO            *  QTDE   *    A VISTA       *     A PRAZO      *   TOTAL VENDIDO  *% SFAT* REGUA *"
            ? "*-------*----------------------------------------*---------*------------------*------------------*------------------*------*-------*"
*               99999.9 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99999.999 ###,###,###,###.## ###,###,###,###.## ###,###,###,###.## ###,## ###,###

            store 5 to LN
  
            do while !bof() 
               
              if  LN > 60
                exit
              endif 
            
              BUSCAREGISTRO("APCA00",1,{str(PEDMAT,6,0)},"SELECT")
              select APED02

              ? " " 
               ?? transform(str(PEDMAT, 6, 0),"@R 9999999")
               ?? " "
               ?? left(APCA00->PCADES , 35)
               ?? "      "
               ?? str(PEDQDE, 9, 3)
               ?? " "
               ?? transform(PEDVIS,"@E@Z ###,###,###,###.##")
               ?? " " 
               ?? transform(PEDPRZ,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(PEDVLN,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(((PEDVLN/M_TOTGER) * 100),"###.##")
               ?? " "
      
               M_SOMPER = M_SOMPER + ((PEDVLN/M_TOTGER) * 100)
              
               ?? transform(M_SOMPER,"####.##")

            LN = LN + 1
                                
            M_TOTVIS = M_TOTVIS + PEDVIS
            M_TOTPRZ = M_TOTPRZ + PEDPRZ

            skip - 1
         
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
      ? space(31) 
        ?? "TOTAL GERAL . . . . . . . . ."
        ?? transform(M_TOTVIS,"@E ###,###,###,###.##")
        ?? " "
        ?? transform(M_TOTPRZ,"@E ###,###,###,###.##")
        ?? " "
        ?? transform((M_TOTVIS + M_TOTPRZ),"@E ###,###,###,###.##")

    eject

desliga1()

return ""

*****************
function LISPED_C                      && Pedidos no periodo
*****************

msgbox1("EM DESENVOLVIMENTO CONTATE SUPORTE")
return ""

private M_TOTAL ,;
        M_DATA1 ,;
        M_DATA2 ,;
        M_ESC   ,;
        PG, LN  ,;
        M_TELA


    rodape("RELACAO","OR€AMENTO",M_FAN,"EAGRO22","Mem: " + str(memory(0), 5),M_EMP) 


    store date() to M_DATA1 ,;
                    M_DATA2

    store 0      to M_PEDCLI
    M_PEDNATN = space(5)
    store "F"    to M_SITUAC

     sombra(13, 35, 19, 61,_SOMBRA_)
     set color to GR/W
       @ 13, 35 say              "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 14, 35 say              "³       Operacao:         ³" 
       @ 15, 35 say              "³Periodo Inicial:         ³" 
       @ 16, 35 say              "³          Final:         ³" 
       @ 17, 35 say              "³        Cliente:         ³" 
       @ 18, 35 say              "³(A)be(F)at(T)od:         ³" 
       @ 19, 35 say              "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
     set color to 

     SetColor(_COREDICAO_)
     @ 14, 53 get     M_PEDNATN picture "9.999"
     @ 15, 53 get     M_DATA1
     @ 16, 53 get     M_DATA2
     @ 17, 53 get     M_PEDCLI picture "#######"
     @ 18, 53 get     M_SITUAC picture "@!"
     read

     if lastkey() = 27
        return ""
     endif
  
     select APED00

     set order to 2 

     go top
         
     dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1) + "    1", .t.)  

     if str(PEDEMP, 2, 0) + dtos(PEDDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2) .or. str(PEDEMP, 2, 0) + dtos(PEDDTE) < str(ME_EMP, 2, 0) + dtos(M_DATA1)
       msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
       return ""
     endif
            
     M_IMPRE = impresn()

     if M_IMPRE = "N"
       return ""
     endif

     if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
       ?? chr(15)                        && comprime
     endif

        store  0 to PG      ,;
                    LN      ,;
                    M_TOTAL ,;
                    M_PEDOUT,;
                    M_PEDVIS,;
                    M_PEDPRZ,;
                    M_PEDAPR,;
                    M_PEDENT,;
                    M_TOTOUT,;
                    M_TOTVIS,;
                    M_TOTPRZ,;
                    M_TOTAPR,;
                    M_TOTENT

        store space(5) to  M_NATANT
          
        select APED00

        set relation to PEDNATN into AFIS00 
                 
        do while !eof()
                              
            store PG + 1 to  PG 

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO SINTETICA DE OR€AMENTO","EAGRO21",132) 
            ? cent_cab(M_DATA,"PEDIODO: " + dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
            ? "*------*--*------*--*-------------------------------------*---*--*--------*---*------*-------------*---------------*---------------*"
            ? "* ORC  *SR* NFS  *SE*   NOME                              *CPG*UF* EMISSAO*VEN* OPE  *   OUTRAS    *    A VISTA    *   A PRAZO     *"
            ? "*------*--*------*--*-------------------------------------*---*--*--------*---*------*-------------*---------------*---------------*"
*               999999 XX 999999 XX 99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999 

            store 5 to LN
  
            do while !eof() .and. LN < 60

              if str(PEDEMP, 2, 0) + dtos(PEDDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
                go bottom
                skip
                loop
              endif 

              if val(M_PEDNATN) > 0
                if !PEDNATN == M_PEDNATN
                  skip
                  loop
                endif
              endif

              if M_PEDCLI > 0
                if PEDCLI != M_PEDCLI
                  skip
                  loop
                endif
              endif

              ANFS00->(dbseek(str(APED00->PEDEMP, 2, 0) + str(APED00->PEDNFS, 6, 0) + APED00->PEDNSE))

              if ANFS00->NFSCAN == "C"
                skip
                loop
              endif

              if !M_SITUAC == "T"
                if M_SITUAC == "F"
                  if PEDNFS = 0   
                    skip
                    loop
                  endif
                else
                  if PEDNFS > 0   
                    skip
                    loop
                  endif
                endif
              endif

              ACLI00->(dbseek(str(APED00->PEDCLI, 7, 0)))

                ? " " 
                 ?? str(PEDNUM, 6, 0)
                 ?? " "
                 ?? PEDSER 
                 ?? " "
                 ?? str(PEDNFS, 6, 0)
                 ?? " "
                 ?? PEDNSE 
                 ?? " "
                 ?? str(PEDCLI, 7, 0) 
                 ?? " "
                 ?? left(ACLI00->CLINOM, 31) 
                 ?? " " 
                 ?? str(PEDCPG, 3)
                 ?? " " 
                 ?? ACLI00->CLIUF2
                 ?? " "
                 ?? PEDDTE
                 ?? " "
                 ?? str(PEDVEN, 3, 0)
                 ?? " "
                 ?? PEDNATN
                 ?? "  "
                 if PEDCPG > 2 .and. PEDCPG <= 20
                   ?? transform(PEDVLN,"@E ##,###,###.##")
                   M_PEDOUT = M_PEDOUT + PEDVLN
                   M_TOTOUT = M_TOTOUT + PEDVLN
                 else
                   if PEDCPG = 1
                     ?? space(15)
                     ?? " "
                     ?? transform(PEDVLN,"@E ##,###,###.##")
                     M_PEDVIS = M_PEDVIS + PEDVLN
                     M_TOTVIS = M_TOTVIS + PEDVLN
                   else
                     if PEDCPG = 2
                       ?? space(15)
                       ?? " "
                       ?? transform(PEDVLN,"@E ##,###,###.##")
                       M_PEDAPR = M_PEDAPR + PEDVLN
                       M_TOTAPR = M_TOTAPR + PEDVLN
                     else
                       if PEDCPG < 500
                         ?? space(31)
                         ?? " "
                         ?? transform(PEDVLN,"@E ##,###,###.##")
                         M_PEDPRZ = M_PEDPRZ + PEDVLN
                         M_TOTPRZ = M_TOTPRZ + PEDVLN
                       else
                          ?? transform(PEDVLN,"@E ##,###,###.##")
                           M_PEDENT = M_PEDENT + PEDVLN
                           M_TOTENT = M_TOTENT + PEDVLN 
                       endif
                     endif
                   endif
                 endif

               LN = LN + 1
                                
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

      if LN > 53
         eject
      endif 

       ?    replicate("-", 132)
       ?    space(39) 
        ?? "TOTAIS . . .  . . . . . . . .    A VISTA " 
        ?? transform(M_TOTVIS,"@E ##,###,###.##")
       ?    space(39) 
        ?? "                                 C/APRES " 
        ?? transform(M_TOTAPR,"@E ##,###,###.##")
       ?    space(39) 
        ?? "                                 A PRAZO " 
        ?? transform(M_TOTPRZ,"@E ##,###,###.##")
       ?    space(39) 
        ?? "           (A VISTA + C/APRES + A PRAZO) " 
        ?? transform(M_TOTPRZ+M_TOTVIS+M_TOTAPR,"@E ##,###,###.##")
       ?    space(39) 
        ?? "OUTRAS SAIDAS . . . . . . . .            " 
        ?? transform(M_TOTOUT,"@E ##,###,###.##")
       ?    space(39) 
        ?? "OUTRAS ENTRADAS . . . . . . .            " 
        ?? transform(M_TOTENT,"@E ##,###,###.##")

     ? replicate("-", 132)

     eject

desliga1()

return ""

******************
function CAB_REP_B
******************

  PG = PG + 1

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"RELACAO DE " + iif(M_TIPO="S","VENDA",iif(M_TIPO="T","TRANSFERENCIA","COMPRA")) + " NO PERIODO","EAGRO22",132) 
  ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
  ? "*------*--*---------*------------------------------------*--------*--------------------------*-*--------*----------*---------------*"
  ? "* ORC  *SR* CLIENTE *   NOME                             *EMISSAO *  V E N C I M E N T O S   *T*ESPECIE * PRODUTOS *     VALOR     *"
  ? "*------*--*---------*------------------------------------*--------*--------------------------*-*--------*----------*---------------*"
*     999999 99 999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99 99/99/99 X XXXXXXXX ###,###.## ####,###,###.##    

  store 5 to LN

return ""

*****************
function RELPED_C                     && relacao de vendas por grupo
*****************

msgbox1("EM DESENVOLVIMENTO CONTATE SUPORTE")
return ""

private M_TOTAL ,;
        M_DATA1 ,;
        M_DATA2 ,;
        M_ESC   ,;
        PG, LN  ,;
        M_TOTGER,;
        M_TOTVIS,;
        M_TOTPRZ,;
        M_SOMPER,;
        M_TELA  ,;
        M_TIPO

if file("APED02.CDX")
  erase("APED02.CDX")
endif

select 0
use APED02 alias APED02 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

    rodape("OR€AMENTO","GRUPO",M_FAN,"EAGRO22","Mem: " + str(memory(0), 5),M_EMP)

    store date() to M_DATA1 ,;
                    M_DATA2

    store space(5)   to M_PEDNATN

     sombra(13, 35, 17, 61,_SOMBRA_)
     set color to GR/W
       @ 13, 35 say              "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 14, 35 say              "³Periodo Inicial:         ³" 
       @ 15, 35 say              "³          Final:         ³" 
       @ 16, 35 say              "³       Operacao:         ³" 
       @ 17, 35 say              "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
    SetColor(_COREDICAO_)

     @ 14, 53 get     M_DATA1
     @ 15, 53 get     M_DATA2
     @ 16, 53 get     M_PEDNATN picture "9.999"
     read

     if lastkey() = 27
        select APED02
        use
        return ""
     endif

     store 0 to M_TOTGER

     select APED02

     if !flock()
       msg("* * * (APED02) ARQUIVO NAO DISPONIVEL * * *")
       select APED02
       use
       return ""
     endif

     zap

     index on str(PEDGRP, 4, 0) to APED02

     set index to APED02 

     select APED00
  
     go top

     set order to 2 
         
        set softseek on
          seek str(ME_EMP, 2, 0) + dtos(M_DATA1)   
        set softseek off

        if str(PEDEMP, 2, 0) + dtos(PEDDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2) .or. str(PEDEMP, 2, 0) + dtos(PEDDTE) < str(ME_EMP, 2, 0) + dtos(M_DATA1)
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          select APED02
          use
          return ""
        endif
                
        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(PEDEMP, 2, 0) + dtos(PEDDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
            exit
          endif 

          if val(M_PEDNATN) > 0
            if !PEDNATN == M_PEDNATN
              skip
              loop
            endif
          endif
           
          select APED01

          set softseek on
            seek str(APED00->PEDEMP, 2, 0) + str(APED00->PEDNUM, 6, 0) + APED00->PEDSER
          set softseek off

          do while !eof()

            if !str(PEDEMP, 2, 0) + str(PEDNUM, 6, 0) + PEDSER == str(APED00->PEDEMP, 2, 0) + str(APED00->PEDNUM, 6, 0) + APED00->PEDSER
              exit
            endif

            APCA00->(dbseek(str(APED01->PEDMAT, 6, 0)))

            select APED02

            seek str(APCA00->PCAGRP, 4, 0)

            if eof()
              append blank         
              replace PEDGRP with APCA00->PCAGRP
            endif

            replace PEDQDE with PEDQDE + APED01->PEDQDE
            replace PEDVLN with PEDVLN + APED01->PEDLIQ

            select APED01

            M_ESC = inkey()

            if M_ESC = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                return ""
              else
                M_ESC = inkey()
              endif
            endif

            skip
 
          enddo
 
          select APED00
 
          skip

        enddo
  
        M_IMPRE = impresn()

        if M_IMPRE = "N"
          select APED02
          use
          return ""
        endif

        store  0 to PG, LN   ,;
                    M_TOTCAI ,;
                    M_TOTMIU ,;
                    M_VLRCAI 
          
        select APED02

        set relation to str(PEDGRP, 4, 0) into AGRP00

        go top
                 
        do while !eof()
                              
            store PG + 1 to  PG 

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"PRODUTOS POR GRUPO","EAGRO22",80) 
            ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),80) 
            ? "*----*----------------------------*--------------*----------*------------------*"
            ? "*GRUP*     DESCRICAO DO GRUPO     *     VALOR    *  QTDE    *    PRECO MEDIO   *"
            ? "*----*----------------------------*--------------*----------*------------------*"
              * 9999 XXXXXXXXXXXXXXXXXXXXXXXXXXXX ###,###,###.## ###,###.## ###,###,###,###.##

            store 5 to LN
  
            do while !eof() 
               
              if  LN > 60
                exit
              endif 

              if PEDGRP = 0
                skip
                loop
              endif 

              ?
              ? " " 
               ?? str(PEDGRP, 4, 0)
               ?? " "
               ?? left(AGRP00->GRPNOM , 28)
               ?? " "
               ?? transform(PEDVLN,"@E@Z ###,###,###.##")
               if PEDGRP != 9999
                 ?? " " 
                 ?? transform(PEDQDE,"@Z #####.###")
                 ?? "   "
                 ?? transform(PEDVLN/PEDQDE,"@E@Z ####,###,###.##")
               endif
      
            LN = LN + 2
                                
            if PEDGRP = 9999
              M_TOTMIU = M_TOTMIU + PEDVLN
            else
              M_TOTCAI = M_TOTCAI + PEDQDE
              M_VLRCAI = M_VLRCAI + PEDVLN
            endif

            skip
         
            M_ESC = inkey()

            if M_ESC = 27
                if susimp()
                  ? replicate("-", 80)
                  ? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                else
                  M_ESC = inkey()
                endif
            endif

          enddo

      enddo

      ? chr(27) + "E"
      ? "TOTAL EM PRODUTOS:                 " 
        ?? transform(M_VLRCAI,"@E@Z ###,###,###.##")
        ?? " "
        ?? transform(M_TOTCAI,"@E@Z ###,###.##")
        ?? "    "
        ?? transform(M_VLRCAI/M_TOTCAI,"@E@Z ###,###,###.##")
      ?
      ? "TOTAL GERAL   :                    " 
        ?? transform((M_TOTMIU+M_VLRCAI),"@E@Z ###,###,###.##")
        ?? chr(27) + "F"

    eject

    unlock all

  desliga1()

  select APED02
  use

return ""

*****************
function RELPED_D
*****************

msgbox1("EM DESENVOLVIMENTO CONTATE SUPORTE")
return ""

private M_TOTAL ,;
        M_DATA1 ,;
        M_DATA2 ,;
        M_TELA  ,;
        M_TIPO  ,;
        M_ESC   ,;
        PG, LN  

if file("APED02.CDX")
  erase("APED02.CDX")
endif

select 0

use APED02 alias APED02 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

rodape("RELACAO","CLIENTE",M_FAN,"EAGRO22","Mem: " + str(memory(0), 5),M_EMP) 

    store date() to M_DATA1 ,;
                    M_DATA2

    M_PEDNATN = space(5)

     sombra(13, 35, 17, 61,_SOMBRA_)
     set color to GR/W
       @ 13, 35 say              "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 14, 35 say              "³Periodo Inicial:         ³" 
       @ 15, 35 say              "³          Final:         ³" 
       @ 16, 35 say              "³       Operacao:         ³" 
       @ 17, 35 say              "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
    SetColor(_COREDICAO_)

     @ 14, 53 get     M_DATA1
     @ 15, 53 get     M_DATA2
     @ 16, 53 get     M_PEDNATN picture "9.999"
     read

     if lastkey() = 27
        select APED02
        use
        return ""
     endif

     select APED02

     if !flock()
       msg("* * * (APED02) ARQUIVO NAO DISPONIVEL * * *")
        select APED02
        use
       return ""
     endif

     zap

     index on str(PEDCLI, 7, 0)            tag 1 to APED02
     index on str(PEDVLN, 14, 2)           tag 2 to APED02

     set index to APED02

     select APED00

     set order to 2 
         
     set softseek on
       seek str(ME_EMP, 2, 0) + dtos(M_DATA1)   
     set softseek off

        if str(PEDEMP, 2, 0) + dtos(PEDDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2) .or. str(PEDEMP, 2, 0) + dtos(PEDDTE) < str(ME_EMP, 2, 0) + dtos(M_DATA1)
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
        select APED02
        use
          return ""
        endif

        store 0 to M_CLITOT

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(PEDEMP, 2, 0) + dtos(PEDDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
            go bottom
            skip
            loop
          endif 

          if PEDCPG > 2 .and. PEDCPG <= 20
            skip
            loop
          endif

          select APED02

          seek str(APED00->PEDCLI, 7, 0)

            if eof()
              append blank
              replace PEDCLI with APED00->PEDCLI
            endif
   
            if APED00->PEDCPG < 3
               replace PEDVIS with PEDVIS + APED00->PEDVLN
               replace PEDVLN with PEDVLN + APED00->PEDVLN
               M_CLITOT = M_CLITOT        + APED00->PEDVLN
            else
              if APED00->PEDCPG > 20
                replace PEDPRZ with PEDPRZ + APED00->PEDVLN
                replace PEDVLN with PEDVLN + APED00->PEDVLN
                M_CLITOT = M_CLITOT        + APED00->PEDVLN
              endif
            endif

            select APED00

             M_ESC = inkey()

             if M_ESC = 27
                 if suspro()
                   msg("* * * PROCESSO SUSPENSO * * *")
        select APED02
        use
                   return ""
                 else
                   M_ESC = inkey()
                 endif
             endif

            skip  

        enddo

        select APED02

        set order to 2

        set relation to str(PEDCLI, 7, 0) into ACLI00

        go bottom
                
        M_IMPRE = impresn()

        if M_IMPRE = "N"
        select APED02
        use
          return ""
        endif

        store  0 to PG      ,;
                    LN      ,;
                    M_TOTVIS,;
                    M_TOTPRZ,;
                    M_SOMPER

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif
          
        do while !bof()
                              
            store PG + 1 to  PG 

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO DE " + iif(M_TIPO="S","VENDA",iif(M_TIPO="T","TRANSFERENCIA","COMPRA")) + " POR CLIENTE/FORNECEDOR","EAGRO22",132) 
              ? cent_cab(M_DATA,"PEDIODO: " + dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
              ? "*---------*------------------------------*---------------*--*------------------*------------------*------------------*------*------*"
              ? "* CLIENTE *     DESCRICAO                *   MUNICIPIO   *UF*     A VISTA      *    A PRAZO       *      TOTAL       *% SFAT* REGUA*"
              ? "*---------*------------------------------*---------------*--*------------------*------------------*------------------*------*------*"
*                     99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XX ###,###,###,###.## ###,###,###,###.## ###,###,###,###.## ###.## ###.##

            store 5 to LN
  
            do while !bof() .and. LN < 60

                  ? "     "
                   ?? str(PEDCLI, 7, 0)
                   ?? " "
                   ?? left(ACLI00->CLINOM, 30)
                   ?? " "
                   ?? left(ACLI00->CLIMUN1, 15) 
                   ?? " "
                   ?? ACLI00->CLIUF1
                   ?? " "
                   ?? transform(PEDVIS,"@E@Z ###,###,###,###.##")
                   ?? " "
                   ?? transform(PEDPRZ,"@E@Z ###,###,###,###.##")
                   ?? " "
                   ?? transform((PEDVIS + PEDPRZ),"@E@Z ###,###,###,###.##")
                   ?? " "
                   ?? transform(((PEDVLN/M_CLITOT) * 100),"###.##")
                   ?? " "
                   M_SOMPER = M_SOMPER + ((PEDVLN/M_CLITOT) * 100)
                   ?? transform(M_SOMPER,"###.##")

                M_TOTVIS = M_TOTVIS + PEDVIS
                M_TOTPRZ = M_TOTPRZ + PEDPRZ

              LN = LN + 1

              skip -1
               
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
        ? "TOTAL PERIODO.. "
        ?? space(44)
        ?? " "
        ?? transform(M_TOTVIS,"@E ###,###,###,###.##")
        ?? " "
        ?? transform(M_TOTPRZ,"@E ###,###,###,###.##")
        ?? " "
        ?? chr(27) + "E"
        ?? transform((M_TOTVIS + M_TOTPRZ),"@E ###,###,###,###.##")
        ?? chr(27) + "F"
        ? replicate("-", 132)

        eject

        unlock all
 
desliga1()

        select APED02
        use

return ""

*****************
function RELPED_E                      && relacao de analitica por vendedor
*****************

msgbox1("EM DESENVOLVIMENTO CONTATE SUPORTE")
return ""

private M_TOTAL ,;
        M_DATA1 ,;
        M_DATA2 ,;
        M_ESC   ,;
        PG, LN  ,;
        M_TOTGER,;
        M_TOTVIS,;
        M_TOTPRZ,;
        M_SOMPER,;
        M_TELA 

if file("APED02.CDX")
  erase("APED02.CDX")
endif

select 0
use APED02 alias APED02 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

    rodape("ANALITICO","VENDEDOR",M_FAN,"EAGRO22","Mem: " + str(memory(0), 5),M_EMP)

    store date() to M_DATA1 ,;
                    M_DATA2

    M_PEDNATN = space(5)

     sombra(13, 35, 17, 61,_SOMBRA_)
     set color to GR/W
       @ 13, 35 say              "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 14, 35 say              "³Periodo Inicial:         ³" 
       @ 15, 35 say              "³          Final:         ³" 
       @ 16, 35 say              "³       Operacao:         ³" 
       @ 17, 35 say              "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
    SetColor(_COREDICAO_)

     @ 14, 53 get     M_DATA1
     @ 15, 53 get     M_DATA2
     @ 16, 53 get     M_PEDNATN picture "9.999"
     read

     if lastkey() = 27
        return ""
     endif

     store 0 to M_TOTGER

     select APED02

     if !flock()
       msg("* * * (APED02) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(PEDEMP, 2, 0) + str(PEDVEN, 3, 0) + str(PEDMAT, 6, 0)  tag 1 to APED02
     index on str(PEDEMP, 2, 0) + str(PEDVEN, 3, 0) + str(PEDVLN, 14, 2) tag 2 to APED02

     set index to APED02 
  
     select APED00

     set relation to PEDNATN into AFIS00 ,;
                  to str(PEDVEN, 3, 0) into AVEN00

     go top

        set order to 2 
         
        set softseek on
          seek str(ME_EMP, 2, 0) + dtos(M_DATA1)   
        set softseek off

        if str(PEDEMP, 2, 0) + dtos(PEDDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2) .or. str(PEDEMP, 2, 0) + dtos(PEDDTE) < str(ME_EMP, 2, 0) + dtos(M_DATA1)
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          return ""
        endif
                
        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(PEDEMP, 2, 0) + dtos(PEDDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
            exit
          endif 
           
          if PEDCPG > 2 
            if PEDCPG <= 20
              skip
              loop
            endif
          endif       

          if val(M_PEDNATN) > 0
            if !PEDNATN == M_PEDNATN
              skip
              loop
            endif
          endif

          select APED01

          set softseek on
            seek str(APED00->PEDEMP, 2, 0) + str(APED00->PEDNUM, 6, 0) + APED00->PEDSER
          set softseek off

          do while !eof()

            if str(APED01->PEDEMP, 2, 0) + str(APED01->PEDNUM, 6, 0) + APED01->PEDSER > str(APED00->PEDEMP, 2, 0) + str(APED00->PEDNUM, 6, 0) + APED00->PEDSER
              exit
            endif

            select APED02
     
            seek str(APED01->PEDEMP, 2, 0) + str(AVEN00->VENCOD, 3, 0) + str(APED01->PEDMAT, 6, 0)

            if eof()
              append blank         
              replace PEDEMP with APED01->PEDEMP
              replace PEDVEN with AVEN00->VENCOD
              replace PEDMAT with APED01->PEDMAT

            endif

            replace PEDQDE with PEDQDE + APED01->PEDQDE

            if APED00->PEDCPG = 1 .or. APED00->PEDCPG = 2
              replace PEDVIS with PEDVIS + APED01->PEDLIQ
              replace PEDVLN with PEDVLN + APED01->PEDLIQ
            endif            

            if APED00->PEDCPG > 20
              replace PEDPRZ with PEDPRZ + APED01->PEDLIQ
              replace PEDVLN with PEDVLN + APED01->PEDLIQ
            endif            

            M_TOTGER = M_TOTGER + APED01->PEDLIQ

            select APED01

            M_ESC = inkey()

            if M_ESC = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                return ""
              else
                M_ESC = inkey()
              endif
            endif

            skip
 
          enddo
 
          select APED00
 
          skip

        enddo
  
        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        store  0 to PG, LN   ,;
                    M_TOTVIS ,;
                    M_TOTPRZ ,;
                    M_VENVIS ,;
                    M_VENPRZ ,;
                    M_SOMPER ,;
                    M_VENANT
          
        select APED02

        set relation to str(PEDMAT, 6, 0) into APCA00 ,;
                     to str(PEDVEN, 3, 0) into AVEN00

        set order to 2

        go top
                 
        do while !eof()
                              
            store PG + 1 to  PG 

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO ANALITICA POR VENDEDOR","EAGRO21D",132) 
            ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
            ? "*-------*----------------------------------------*---------*------------------*------------------*------------------*------*-------*"
            ? "* PROD  *        DESCRICAO DO PRODUTO            *  QTDE   *    A VISTA       *     A PRAZO      *   TOTAL VENDIDO  *% SFAT* REGUA *"
            ? "*-------*----------------------------------------*---------*------------------*------------------*------------------*------*-------*"
*               99999.9 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99999.999 ###,###,###,###.## ###,###,###,###.## ###,###,###,###.## ###,## ###,###

            store 5 to LN
  
            do while !eof() 
               
              if  LN > 60
                exit
              endif 

             if PEDVEN != M_VENANT
                if (M_VENVIS + M_VENPRZ) > 0
                  ? space(31) 
                    ?? "TOTAL DO VENDEDOR . . . . . ."
                    ?? transform(M_VENVIS,"@E ###,###,###,###.##")
                    ?? " " 
                    ?? transform(M_VENPRZ,"@E ###,###,###,###.##")
                    ?? " "
                    ?? transform((M_VENVIS + M_VENPRZ),"@E ###,###,###,###.##")
                  ? replicate("-", 132)
                  LN = LN + 2
                 endif
                 M_VENANT = PEDVEN
                 M_VENVIS = 0
                 M_VENPRZ = 0
                ? "***** VENDEDOR: "
                 ?? str(PEDVEN, 3, 0)
                 ?? " "
                 ?? AVEN00->VENNOM
                 ?? " "
                 ?? AVEN00->VENMUN
                 ?? " "
                 ?? AVEN00->VENEST
                 ?? " "
                 ?? AVEN00->VENTEL
                 ?? "  *****"
                ?
                 LN = LN + 2
              endif       
            
              ? " " 
               ?? transform(str(PEDMAT, 6, 0),"@R 9999999")
               ?? " "
               ?? left(APCA00->PCADES , 35)
               ?? "      "
               ?? str(PEDQDE, 9, 3)
               ?? " "
               ?? transform(PEDVIS,"@E@Z ###,###,###,###.##")
               ?? " " 
               ?? transform(PEDPRZ,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(PEDVLN,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(((PEDVLN/M_TOTGER) * 100),"###.##")
               ?? " "
      
               M_SOMPER = M_SOMPER + ((PEDVLN/M_TOTGER) * 100)
              
               ?? transform(M_SOMPER,"####.##")

            LN = LN + 1
                                
            M_VENVIS = M_VENVIS + PEDVIS
            M_VENPRZ = M_VENPRZ + PEDPRZ
            M_TOTVIS = M_TOTVIS + PEDVIS
            M_TOTPRZ = M_TOTPRZ + PEDPRZ

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
      ? space(31) 
        ?? "TOTAL GERAL . . . . . . . . ."
        ?? transform(M_TOTVIS,"@E ###,###,###,###.##")
        ?? " "
        ?? transform(M_TOTPRZ,"@E ###,###,###,###.##")
        ?? " "
        ?? transform((M_TOTVIS + M_TOTPRZ),"@E ###,###,###,###.##")

    eject

    unlock all
desliga1()

  select APED02

  use

return ""

****************
function TLPED01    
****************
nbox(03, 02, 21, 76,"RB+/W*",.T.)
setcolor("N+/W*")
    @ 04, 03 say     "Num_Orc:           Nom:                                          Cpg:    "
    @ 05, 03 say     "NFSaida:           End:                                          Ven:    "
    @ 06, 03 say     "Emissao:           Bai:                 Mun:                     Tra:    "
    @ 07, 03 say     "                   Cep:      -          Est:        Extenso:     Obs:    "
    @ 08, 03 say     "Cliente:           Ies:                 Dsc:            Fre:             "
    @ 09, 03 say     "                                                      Total:             "
    @ 10, 03 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    setcolor("W+/G")

    @ 11, 03 say     "Sq C¢digo         Descri‡„o                 Qtde     Unit rio    Total   "
setcolor("N+/W*")

    @ 12, 03 say     "                                                                         "
    for zz = 13 to 20
    @ zz, 03 say     "  ³      ³                               ³         ³          ³          "
    next
set color to

return ""

****************
function TLPED02(TIPO)    
****************

nbox(03, 04, 20, 76,"W/W+",.t.)
setcolor("B/W")
    @ 03, 04 say     "                                                                         "
    if TIPO == "C"
      @ 04, 04 say     " Cliente :         Nome:                               Mun:              "
    else
      @ 04, 04 say     " Fornec. :         Nome:                               Mun:              "
    endif
    @ 05, 04 say     "                                                                         "
    @ 06, 04 say     "   Data   NumPed Se Cpg Tra Ven Nome         Ope    Nfs   Se   Total     "
    @ 07, 04 say     "                                                                         "
    for zz = 8 to 15
    @ zz, 04 say     "                                                                         "
    next
    @ 16, 04 say     "                                                                         "
    @ 17, 04 say     " " + space(72)
    @ 18, 04 say     " " + space(72)
    @ 19, 04 say     " " + space(72)
    @ 20, 04 say     "                                                                         "
set color to 

return ""


*****************
function VERVENDA
*****************

LOCAL scr, clr
LOCAL aBlocks := {}

parameters F_HELP,F_OQUE

if lastkey(,.t.) = 5
  return .t.
endif

M_TIPOS = { }

aadd(M_TIPOS,"Escolha  ")
aadd(M_TIPOS,"Orcamento")
aadd(M_TIPOS,"Venda    ")
aadd(M_TIPOS,"Nota     ")

PosAcho = 1

for A = 1 to len(M_TIPOS)
  if M_TIPOS[A] == F_HELP
    PosAcho = A
    exit
  endif
next

scr := SaveScreen( 6,11,11,22 )
clr := SetColor( 'N/W*,GR+/B*,,,GR+/B' )

Wvw_DrawBoxRaised( 7, 12, 10, 20 )

TIPO1 = achoice(7,12,10,20,M_TIPOS,,,PosAcho)
setcolor("")

setColor( clr )
RestScreen( 6,11,11,22, scr )


if lastkey() = 27
  return .t.
endif

if M_TIPOS[TIPO1] == "Escolha  "
  return .f.
endif

F_HELP = M_TIPOS[TIPO1]

return .t.

****************
function EDPED01(TIPO)    
****************

  setcolor("N/W*")
    @ 05, 12 say M_PEDNFS picture "######"
    @ 05, 19 say M_PEDNSE picture "@!" 
  SetColor(_COREDICAO_)
  @ 06, 12 get M_PEDDTE                   valid !empty(M_PEDDTE)




*  @ 07, 12 get M_PEDNATN valid  vervenda(@M_PEDNATN)  // verped05()




  @ 08, 12 get M_PEDCLI picture "#######"  F2 color _CORF2_ valid verped01(TIPO) funcao "sele_arquivo('ACLI00')" retorno @M_PEDCLI

  @ 04, 73 get M_PEDCPG picture "###" F2 color _CORF2_ valid verped04(TIPO) funcao "sele_arquivo('ACPG00')" retorno @M_PEDCPG
  @ 05, 73 get M_PEDVEN picture "###" F2 color _CORF2_ valid verped03()  funcao "sele_arquivo('AVEN00')" retorno @M_PEDVEN
  @ 06, 73 get M_PEDTRA picture "###"     valid verped06()

  @ 07, 64 get M_PEDEXT picture "@!" valid (M_PEDEXT $ "UT")
  @ 07, 73 get M_PEDOBS picture "@!"      valid verped11()

  @ 08, 48 get M_PEDDSC  picture "#######.##" //valid (calc_tot(),.t.)
  @ 08, 64 get M_PEDFRE  picture "#######.##" //valid (calc_tot(),.t.)
  read

return ""

****************
function EDPED02    
****************

  setcolor("N/W*")
    @ 05, 12 say M_PEDNFS picture "######"
    @ 05, 19 say M_PEDNSE picture "@!" 
  SetColor(_COREDICAO_)
  @ 06, 12 get M_PEDDTE
*  @ 07, 12 get M_PEDNATN picture "9.999"  valid verped05()
  @ 08, 12 get M_PEDCLI picture "#####"   valid verped01()

  @ 04, 73 get M_PEDCPG picture "###"     valid verped04()
  @ 05, 73 get M_PEDVEN picture "###"     valid verped03()
  @ 06, 73 get M_PEDTRA picture "###"     valid verped06()
  @ 07, 64 get M_PEDEXT picture "@!"      valid (M_PEDEXT $ "UT")
  @ 07, 73 get M_PEDOBS picture "@!"      valid verped11()
  @ 08, 73 get M_PEDPOR picture "###"     valid verped13()
  @ 08, 64 get M_NFSFRC picture "@!"      valid vernfs15()
  read


return ""

****************
function EDPED04    
****************

parameters LN,SQ

setcolor("N/W*")
  @ LN, 03 say     M_PEDMAT[SQ,1] picture "##"
SetColor(_COREDICAO_)

@ LN, 06 get     M_PEDMAT[SQ, 2] picture "######" F2 color _CORF2_ valid verped07() funcao "sele_arquivo('APCA00')" retorno @M_PEDMAT[SQ, 2]
@ LN, 45 get     M_PEDMAT[SQ, 3] picture "#########"    valid verped08()
@ LN, 55 get     M_PEDMAT[SQ, 4] picture "#######.##"   valid verped09()
read

return .t.

****************
function EDPED05
****************

parameters LN,SQ

SetColor(_COREDICAO_)
@ LN, 42 get     M_PEDMAT[SQ, 3] picture "#######"   valid verped08()
@ LN, 50 get     M_PEDMAT[SQ, 4] picture "######.##" valid nverped09()
read

return .t.

****************
function MSPED01   
****************

  setcolor("N/W*")
    @ 05, 12 say PEDNFS picture "######"
    @ 05, 19 say PEDNSE picture "@!" 
    @ 06, 12 say PEDDTE
    @ 07, 12 say PEDNATN
    @ 08, 12 say PEDCLI       picture "#######"
    @ 04, 27 say PEDNOM       picture "@!"
    @ 05, 27 say PEDEND       picture "@!"
    @ 06, 27 say PEDBAI       picture "@!"
    @ 06, 48 say PEDMUN       picture "@!"
    @ 07, 27 say PEDCEP       picture "#####"
    @ 07, 33 say PEDCCL       picture "###"
    @ 07, 48 say PEDEST       picture "@!"
    @ 07, 64 say PEDEXT       picture "@!"
    @ 08, 27 say PEDIES       picture "@!"
    @ 08, 48 say PEDCGC       picture "@R 999.999.999/9999-99"
    @ 04, 73 say PEDCPG       picture "###"
    @ 05, 73 say PEDVEN       picture "###"
    @ 06, 73 say PEDTRA       picture "###"
    @ 07, 73 say PEDOBS       picture "@!"
    @ 08, 73 say PEDPOR       picture "###"
    @ 08, 64 say PEDFRC       picture "@!"
  set color to 

return ""


****************
function MSPED02   
****************

parameters SQ,R

    set color to I
      for S = SQ to len(M_PEDMAT)
        BUSCAREGISTRO("APCA00",1,{str(M_PEDMAT[S, 2],6,0)},"SELECT")

        @ R, 03 say     M_PEDMAT[S, 1] picture "##"
        @ R, 06 say     M_PEDMAT[S, 2] picture "######"  
        @ R, 13 say     pad(APCA00->PCADES, 31)
        @ R, 45 say     M_PEDMAT[S, 3] picture "#########"
        @ R, 55 say     M_PEDMAT[S, 4] picture "#######.##"
        @ R, 66 say     M_PEDMAT[S, 5] picture "#######.##"
        R++
        if R = 19
          exit
        endif
      next
    set color to

return ""

****************
function MSPED03   
****************

    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"APED01","APED01"})
    aadd(sqlCAMPO,"APED01.*")
    aadd(sqlCAMPO,"APCA00.PCAMAT")
    aadd(sqlCAMPO,"APCA00.PCADES")
    aadd(sqlCAMPO,"APCA00.PCAUNI")
    aadd(sqlCAMPO,"APCA00.PCAMAR")
    aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","APED01.PEDMAT"})
    aadd(sqlCHAVE,"PEDNUM = " + str(APED00->PEDNUM, 6, 0))
    aadd(sqlCHAVE,"PEDEMP = " + str(APED00->PEDEMP, 2, 0))
    aadd(sqlCHAVE,"PEDSER = " + aspas(APED00->PEDSER))
*    aadd(sqlORDEM,"PEDNUM,PCADES")
    sqlrelation()
    if eof()
      msg("* * * OR€AMENTO NAO POSSUE ITENS * * *")
      return ""
    endif

    M_VETORITE = {}

    R = 1

    do while !eof()

      aadd(M_VETORITE,str(PEDSEQ, 2, 0) + " " + ;
                      str(PEDMAT, 6, 0) + " " + ;
                      pad(PCADES, 31)   + " " + ;
                      str(PEDQDE, 9, 3) + " " + ;
                      str(PEDPRB,10, 2) + " " + ;
                      str(PEDVLI,10, 2) + " ")
      skip

      R = R + 1

    enddo

    M_LINPOS = 0

    do while .t.

      set color to N/W,W+/N
        M_OPC = achoice(13, 3,20,75,M_VETORITE,,"mostep")
      set color to

      if lastkey() = 13
        msped04()
        loop
      endif

      if lastkey() = 27
        exit        && abandona operacao
      endif

    enddo


****************
function LPPED01   
****************

private K

setcolor("N+/W*")
    for K = 12 to 20
      @ K, 03 say "  ³      ³                               ³         ³          ³          "
    next
  set color to

return ""

#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)

*****************
function VERPED01(TIPO)   
*****************

if lastkey() = 5
  return .t.
endif

if M_PEDCLI = 0
  sele_arquivo("ACLI00")
  M_PEDCLI = nCodRetorno
endif

if !valorescli(M_PEDCLI)
  msg("* * * CLIENTE NAO CADASTRADO * * *")
  M_PEDCLI = 0
  return .f.
endif

    if TIPO
      if !analiza_cl(M_PEDCLI)
        return .f.
      endif
    endif
    M_PEDNOM = pad(ACLI00->CLINOM, 40)
    M_PEDEND = pad(ACLI00->CLIEND2, 40)
    M_PEDBAI = pad(ACLI00->CLIBAI2, 15)
    M_PEDMUN = pad(ACLI00->CLIMUN2, 19)
    M_PEDCEP = ACLI00->CLICEP2
    M_PEDCCL = ACLI00->CLICCL2
    M_PEDEST = ACLI00->CLIUF2
    M_PEDIES = ACLI00->CLIIES2
    M_PEDCGC = ACLI00->CLICGC2
    M_PEDTRA = ACLI00->CLITRA
    M_PEDVEN = ACLI00->CLIVEN
    M_PEDPOR = ACLI00->CLIBCO

  setcolor("N/RB*")
    @ 04, 27 say M_PEDNOM picture "@!"
    @ 05, 27 say M_PEDEND picture "@!"
    @ 06, 27 say M_PEDBAI picture "@!"
    @ 06, 48 say M_PEDMUN picture "@!"
    @ 07, 27 say M_PEDCEP picture "#####"
    @ 07, 33 say M_PEDCCL picture "###"
    @ 07, 48 say M_PEDEST picture "@!"
    @ 08, 27 say pad(M_PEDIES,15) picture "@!"
  set color to 

setcursor(1)


return .t.

*****************
function VERPED02   
*****************

if lastkey() = 5
  return .t.
endif

if empty(M_PEDDTE)
  msg("* * * DATA DE EMISSAO NAO PODE ESTAR VAZIA  * * *")
  return .f.
endif

return .t.

*****************
function VERPED03   
*****************

if lastkey() = 5
  return .t.
endif

if M_PEDVEN = 0
  return .f.
endif

if !BUSCAREGISTRO("AVEN00",1,{str(M_PEDVEN,3,0)},"SELECT")
  msg("* * * VENDEDOR NAO CADASTRADO * * *")
  return .f.
endif

msg("* * * " + alltrim(AVEN00->VENNOM) + " * * *")


return .t.

*****************
function VERPED04(TIPO)
*****************

if lastkey() = 5
  return .t.
endif

if M_PEDCPG = 0
  return .f.
endif

if !BUSCAREGISTRO("ACPG00",1,{str(M_PEDCPG,3,0)},"SELECT")
  msw("* * * CONDICAO DE PAGTO NAO CADASTRADA * * *")
  return .f.
endif

msw("* * * " + alltrim(ACPG00->CPGDES) + " * * *")

set cursor on


return .t.

*****************
function VERPED05
*****************

if lastkey() = 5
  return .t.
endif

if val(M_PEDNATN) = 0
  return .f.
endif

if !BUSCAREGISTRO("AFIS00",1,{str(ME_EMP,2,0),M_PEDNATN},"SELECT")
  msw("* * * NATUREZA NAO CADASTRADA * * *")
  M_PEDNATN = space(5)
  return .f.
endif


return .t.

*****************
function VERPED06
*****************

 if lastkey() = 5
   return .t.
 endif

 if M_PEDTRA = 0
   return .f.
 endif

  if !BUSCAREGISTRO("ATRA00",1,{str(M_PEDTRA,3,0)},"SELECT")
    msw("* * * TRANPORTADORA NAO CADASTRADA * * *")
    return .f.
  endif

 msw("* * * " + alltrim(ATRA00->TRANOM) + " * * *")


 return .t.

*****************
function VERPED07                      && procura produto
*****************

  if lastkey() = 5
    return .t.
  endif

  if M_PEDMAT[SQ,2] = 0
    sele_arquivo('APCA00')
    if nCodRetorno = 0
      return .f.
    endif
    M_PEDMAT[SQ,2] = nCodRetorno
  endif

  if !valorespro(M_PEDMAT[SQ,2])
    msw("* * * PRODUTO NAO CADASTRADO * * *")
    M_PEDMAT[SQ,2] = 0
    return .f.
  endif

  setcolor("N/W*")

    @ LN, 13 say pad(APCA00->PCADES, 31)
  set color to

  M_PEDMAT[SQ, 8] = APCA00->PCADES

  BUSCAREGISTRO("ASLD00",1,{str(ME_EMP, 2, 0),str(M_PEDMAT[SQ,2],6,0)},"SELECT")

  M_PEDMAT[SQ, 4] = ASLD00->SLDPRC

  msw(zPCADES + " Saldo: " + str(saldo(zPCAMAT), 5, 0))


return .t.    

*****************
function VERPED08   
*****************

  if lastkey() = 5
    return .t.
  endif

  if M_PEDMAT[SQ, 3] = 0
    return .f.
  endif

return .t.

*****************
function VERPED09   
*****************

  if lastkey() = 5
    return .t.
  endif

  if M_PEDMAT[SQ, 4] = 0
    return .f.
  endif

  BUSCAREGISTRO("ASLD00",1,{str(ME_EMP, 2, 0),str(M_PEDMAT[SQ,2],6,0)},"SELECT")

  if M_PEDMAT[SQ, 4] < (ASLD00->SLDPRC - ((ASLD00->SLDPRC * .01) * ASLD00->SLDDSC))
    msg("* * * PRECO MENOR QUE DESCONTO PERMITIDO * * * ")
  endif

  M_PEDMAT[SQ, 5] = round(M_PEDMAT[SQ, 4] * M_PEDMAT[SQ, 3], 2)

  setcolor("N/W*")
    @ LN, 66 say M_PEDMAT[SQ, 5] picture "#######.##"
  set color to 

return .t.

******************
function NVERPED09   
******************

  if lastkey() = 5
    return .t.
  endif

  if M_PEDMAT[SQ, 4] = 0
    msg("* * * VALOR UNITARIO NAO PODE SER ZEROS * * *")
    return .f.
  endif

  M_PEDMAT[SQ, 5] = round(M_PEDMAT[SQ, 4] * M_PEDMAT[SQ, 3], 2)

  set color to I
    @ LN, 60 say M_PEDMAT[SQ, 5] picture "######.##" 
  set color to 

return .t.

*****************
function VERPED11
***************** 

if lastkey() = 5
  return .t.
endif

if !M_PEDOBS $ "SN"
  msw("* * * VALIDO SOMENTE (S)im ou (N)ao * * *")
  return .f.
endif


return .t.

*****************
function VERPED12                      && edita historico
*****************

LOCAL M_TELA

M_TELA = savescreen(08, 10, 15, 72)

nbox(09, 10, 13, 71,"W/W+",.t.)
setcolor("B/W")

 @ 09, 11 say     "Observacoes"
 @ 10, 11 say     "                                                            "
 @ 11, 11 say     "                                                            "
 @ 12, 11 say     "                                                            "
setcolor("")

do while .t.
  
  SetColor(_COREDICAO_)
  @ 10, 11 get M_PEDHS1 picture "@!"
  @ 11, 11 get M_PEDHS2 picture "@!"
  @ 12, 11 get M_PEDHS3 picture "@!"
  read

  msg("* * * (ENTER) Continua  (PgDn) Sai * * *")

  if lastkey() = 3
    exit
  endif

enddo

return ""

*****************
function VERPED13
*****************

 if lastkey() = 5
   return .t.
 endif

 if M_PEDPOR = 0
   return .f.
 endif

 if !APOR00->(dbseek(str(M_PEDPOR, 5, 0)))
   msg("* * * PORTADOR NAO CADASTRADO * * *")
   return .f.
 endif

 msg("* * * " + alltrim(APOR00->PORNOM) + " * * *")


 return .t.

***************
function MOSPED
***************
parameters  M_MODO, M_ELEM, M_POSI

  nKey := lastkey()

  if str(nKey, 2, 0) $ " 3#27#18"
    return 0
  endif

  nPosach  = M_ELEM

  if str(nKey, 3, 0)  $ "# 49# 50# 51# 52# 53# 54# 13"
    M_OPC = M_ELEM
    return 1
  endif

  set color to N/W,W+/N

  M_LINPOS = M_POSI

return 2

***************
function MOSPED2
***************

parameters  M_MODO, M_ELEM, M_POSI

  if str(lastkey(), 2, 0) $ "27"
    return 0
  endif

  nPosach  = M_ELEM

  if str(lastkey(), 3, 0)  $ " 54# 13#  7"
    M_OPC = M_ELEM
    return 1
  endif

  set color to
  set color to GR+
    @ 24, 23 say   "<Enter>.Altera   <Del>eta   <Esc>.Cancela   <6>.Confirma"
  set color to R+
    @ 24, 24 say "Enter"
    @ 24, 41 say "Del"
    @ 24, 52 say "Esc"
    @ 24, 68 say "6"
  set color to N/W,W+/N

  M_LINPOS = M_POSI

return 2

*******************
function DECLARACAO
*******************

private cTela
cTela = savescreen(06,08,20,73)

sombra(06,08,20,72,_SOMBRA_)

setcolor("B/BG,N/BG")
@ 06, 08, 20, 72 box M_FRAME1
@ 13, 10 say "D E C L A R A C A O"

@ 07, 10 get M_PEDPRZ1 picture "@!"
@ 08, 10 get M_PEDPRZ2 picture "@!"
@ 09, 10 get M_PEDPRZ3 picture "@!"
@ 10, 10 get M_PEDPRZ4 picture "@!"
@ 11, 10 get M_PEDPRZ5 picture "@!"

@ 14, 10 get M_PEDDEC1
@ 15, 10 get M_PEDDEC2
@ 16, 10 get M_PEDDEC3
@ 17, 10 get M_PEDDEC4
@ 18, 10 get M_PEDDEC5
read
setcolor("")

restscreen(06,08,20,73,cTela)

return ""

***************
function EMIPED
***************
LOCAL oWord, oDoc
LOCAL cArquivoModelo := "C:\ATLAS\modelo_orcamento.docx"
LOCAL cNovoArquivo   := "C:\ATLAS\orcamento.docx"
LOCAL nSeqLinha

declare VAL_EXT[ 1 ]
private VAL_EXT[ 1 ]

declare M_MESES[12]

M_MESES[1 ] = "JANEIRO"
M_MESES[2 ] = "FEVEREIRO"
M_MESES[3 ] = "MARCO"
M_MESES[4 ] = "ABRIL"
M_MESES[5 ] = "MAIO"
M_MESES[6 ] = "JUNHO"
M_MESES[7 ] = "JULHO"
M_MESES[8 ] = "AGOSTO"
M_MESES[9 ] = "SETEMBRO"
M_MESES[10] = "OUTUBRO"
M_MESES[11] = "NOVEMBRO"
M_MESES[12] = "DEZEMBRO"

oWord := CreateObject("Word.Application")
oWord:Visible := .F.
oDoc := oWord:Documents:Open(cArquivoModelo)

parameter M_OPCAO

  M_RG = ""
  M_TOTPRO = 0
  LN = 0
  PG = 0

  M_DECLARA = 1

 M_PEDDEC1 = "                                                            "
 M_PEDDEC2 = "                                                            "
 M_PEDDEC3 = "                                                            "
 M_PEDDEC4 = "                                                            "
 M_PEDDEC5 = "                                                            "
 M_PEDDEC6 = "                                                            "
 M_PEDDEC7 = "                                                            "
 M_PEDDEC8 = "                                                            "
 M_PEDDEC9 = "                                                            "


*  if left(M_PEDNATN,5) == "Venda"    // quando venda grava as duplicatas na 51 é uma venda SN
*    calc_dupped(.t.)
*  endif
  
  if M_OPCAO
    seexistesql("APEDID")
    cSql := "select first 1 gen_id(gen_APED00_id,1) from aped00"
    dbusearea(.t.,"SQLMIX",cSql,"APEDID")
    M_ID = GEN_ID
    select APEDID
    use
    M_PEDNUM = M_ID

    do while .t.
      if BUSCAREGISTRO("APED00",1,{str(M_PEDEMP, 2, 0),str(M_PEDNUM, 6, 0),aspas(M_PEDSER)},"SELECT")
        seexistesql("APEDID")
        cSql := "select first 1 gen_id(gen_APED00_id,1) from aped00"
        dbusearea(.t.,"SQLMIX",cSql,"APEDID")
        M_ID = GEN_ID
        select APEDID
        use
        M_PEDNUM = M_ID
        loop
      endif
      exit
    enddo
    grped01("INSERT")
    grped02("INSERT")
  else
    grped01("UPDATE")
    grped02("INSERT")
  endif

  set color to I         
    @ 04, 12 say M_PEDNUM picture "######"
    @ 04, 19 say M_PEDSER picture "@!" 
  set color to 

*  M_IMPRE = impresn()

*  if M_IMPRE = "N"
*    return ""
*  endif


  valorescli(M_PEDCLI)
  BUSCAREGISTRO("AVEN00",1,{str(M_PEDVEN,3,0)},"SELECT")
  BUSCAREGISTRO("APOR00",1,{str(M_PEDPOR,5,0)},"SELECT")


  M_FLAG = 0
  M_TOTLIN = 0

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"APED01","APED01"})
  aadd(sqlCAMPO,"APED01.*")
  aadd(sqlCAMPO,"APCA00.PCAMAT")
  aadd(sqlCAMPO,"APCA00.PCADES")
  aadd(sqlCAMPO,"APCA00.PCAUNI")
  aadd(sqlCAMPO,"APCA00.PCAMAR")
  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","APED01.PEDMAT"})
  aadd(sqlCHAVE,"PEDNUM = " + str(M_PEDNUM, 6, 0))
  aadd(sqlCHAVE,"PEDEMP = " + str(M_PEDEMP, 2, 0))
  aadd(sqlCHAVE,"PEDSER = " + aspas(M_PEDSER))
  aadd(sqlORDEM,"PEDNUM,PCADES")
  sqlrelation()
  go bottom
  go top

RR = 1

   Substituir(oDoc, "{{LINHA1}}", M_PEDHS1)
   Substituir(oDoc, "{{LINHA2}}", M_PEDHS2)
   Substituir(oDoc, "{{LINHA3}}", M_PEDHS3)

   Substituir(oDoc, "{{CLIENTE}}", M_PEDNOM)
   Substituir(oDoc, "{{ENDERECO}}", M_PEDEND)
   Substituir(oDoc, "{{MUNICIPIO}}", M_PEDMUN + " " + M_PEDEST)

   if len(rtrim(M_PEDCGC)) = 11
     m_cg = transform(M_PEDCGC,"@R 999.999.999/99")
     Substituir(oDoc, "{{CNPJ}}", m_cg)
   else
     m_cg = transform(M_PEDCGC,"@R 999.999.999/9999-99")
     Substituir(oDoc, "{{CNPJ}}", m_cg)
   endif

   Substituir(oDoc, "{{EMAIL}}", "")
   Substituir(oDoc, "{{CODIGO}}", str(M_PEDCLI, 5, 0))
   Substituir(oDoc, "{{TELEFONE}}", ACLI00->CLITEL1)
   Substituir(oDoc, "{{VENDEDOR}}", pad(AVEN00->VENNOM, 14))
   Substituir(oDoc, "{{INSCRICAO}}", M_PEDIES)
   Substituir(oDoc, "{{RG}}", M_RG)

    select APED01
    go top

    oTable := oDoc:Tables[oDoc:Tables:Count]
    oTable:Borders:Enable := 0
    nSeqLinha := 1

    do while !eof()

      nLinha := oTable:Rows:Count
      oTable:Cell(nLinha,1):Range:Text := str(nSeqLinha, 3, 0)
      oTable:Cell(nLinha,2):Range:Text := str(PEDMAT, 6, 0)
      oTable:Cell(nLinha,3):Range:Text := transform(PEDQDE,"@E #######")
      oTable:Cell(nLinha,4):Range:Text := pad(PCAUNI, 03)
      oTable:Cell(nLinha,5):Range:Text := PCADES
      oTable:Cell(nLinha,6):Range:Text := ""
      oTable:Cell(nLinha,7):Range:Text := ""
      oTable:Cell(nLinha,5):Range:Font:Size := 10
      oTable:Cell(nLinha,5):Range:Font:Name := "Times New Roman"

      for A = 1 to 7
        oTable:Cell(nLinha,A):Borders:Item(1):LineStyle := 1
        oTable:Cell(nLinha,A):Range:Font:Size := 10
        oTable:Cell(nLinha,A):Range:Font:Name := "Times New Roman"
        oTable:Cell(nLinha,A):Range:Font:Color := 0

      next

      oRow := oTable:Rows:Add()
      nLinha := oTable:Rows:Count
      oTable:Cell(nLinha,1):Range:Text := ""
      oTable:Cell(nLinha,2):Range:Text := ""
      oTable:Cell(nLinha,3):Range:Text := ""
      oTable:Cell(nLinha,4):Range:Text := ""
      oTable:Cell(nLinha,5):Range:Font:Size := 11
      oTable:Cell(nLinha,5):Range:Font:Name := "Times New Roman"
      oTable:Cell(nLinha,5):Range:Font:Color := 16711680
      oTable:Cell(nLinha,6):Range:Font:Color := 16711680
      oTable:Cell(nLinha,7):Range:Font:Color := 16711680

     if M_PEDEXT == "U"
       extenso(PEDPRB, VAL_EXT, 100)
       VAL_EXT[1] = strtran(VAL_EXT[1],"*","")
       oTable:Cell(nLinha,5):Range:Text := VAL_EXT[1]
     else
       extenso(PEDVLI, VAL_EXT, 100)
       VAL_EXT[1] = strtran(VAL_EXT[1],"*","")
       oTable:Cell(nLinha,5):Range:Text := VAL_EXT[1]
     endif


      oTable:Cell(nLinha,6):Range:Text := transform(PEDPRB,"@E@Z ###,###.##")
      oTable:Cell(nLinha,6):Range:ParagraphFormat:Alignment := 2
      oTable:Cell(nLinha,7):Range:ParagraphFormat:Alignment := 2
      oTable:Cell(nLinha,7):Range:Text := transform(PEDVLI,"@E@Z ###,###.##")

      for A = 1 to 7
        oTable:Cell(nLinha,A):Borders:Item(1):LineStyle := 0
      next

      oRow := oTable:Rows:Add()
      oRow := oTable:Rows:Add()

      skip
      
      nSeqLinha ++

    enddo

      nLinha := oTable:Rows:Count
      oTable:Cell(nLinha,1):Range:Text := ""
      oTable:Cell(nLinha,2):Range:Text := ""
      oTable:Cell(nLinha,3):Range:Text := ""
      oTable:Cell(nLinha,4):Range:Text := ""
      oTable:Cell(nLinha,5):Range:Text := ""
      oTable:Cell(nLinha,6):Range:Text := "Total"
      oTable:Cell(nLinha,7):Range:Text := transform(M_PEDVLN,"@E@Z ###,###.##")

      for A = 1 to 7
        oTable:Cell(nLinha,A):Borders:Item(1):LineStyle := 1
        oTable:Cell(nLinha,A):Range:Font:Size := 12
        oTable:Cell(nLinha,A):Range:Font:Name := "Times New Roman"
        oTable:Cell(nLinha,A):Range:Font:Color := 0
        oTable:Cell(nLinha,A):Range:Font:Bold := .t.
      next



      oRow := oTable:Rows:Add()
      nLinha := oTable:Rows:Count
      oTable:Cell(nLinha,1):Range:Text := ""
      oTable:Cell(nLinha,2):Range:Text := ""
      oTable:Cell(nLinha,3):Range:Text := ""
      oTable:Cell(nLinha,4):Range:Text := ""
      oTable:Cell(nLinha,5):Range:Font:Size := 11
      oTable:Cell(nLinha,5):Range:Font:Name := "Times New Roman"
      oTable:Cell(nLinha,5):Range:Font:Color := 16711680
      oTable:Cell(nLinha,6):Range:Font:Color := 16711680
      oTable:Cell(nLinha,7):Range:Font:Color := 16711680
      oTable:Cell(nLinha,6):Range:Text := ""
      oTable:Cell(nLinha,6):Range:ParagraphFormat:Alignment := 2
      oTable:Cell(nLinha,7):Range:ParagraphFormat:Alignment := 2
      oTable:Cell(nLinha,7):Range:Text := ""

      extenso(M_PEDVLN, VAL_EXT, 100)
      VAL_EXT[1] = strtran(VAL_EXT[1],"*","")
      oTable:Cell(nLinha,5):Range:Text := VAL_EXT[1]

      for A = 1 to 7
        oTable:Cell(nLinha,A):Borders:Item(1):LineStyle := 0
      next

      oAfterTable := oDoc:Range( oTable:Range:End, oTable:Range:End )
      oAfterTable:InsertParagraphAfter()
      oAfterTable:Select()

      oWord:Selection:TypeParagraph()

      oWord:Selection:Font:Name := "Courier New"
      oWord:Selection:Font:Size := 10
      oWord:Selection:ParagraphFormat:Alignment := 0 // wdAlignParagraphLeft
      oWord:Selection:TypeText(M_PEDNOM + " " + str(M_PEDCLI, 5, 0))
      oWord:Selection:TypeParagraph()

      oWord:Selection:Font:Name := "Courier New"
      oWord:Selection:Font:Size := 10
      oWord:Selection:ParagraphFormat:Alignment := 0 // wdAlignParagraphLeft
      oWord:Selection:TypeText(alltrim(M_PEDEND) + " - " + alltrim(M_PEDBAI) + " -  " + alltrim(M_PEDMUN) + " " + M_PEDEST)
      oWord:Selection:TypeParagraph()

      oWord:Selection:TypeParagraph()
      oWord:Selection:TypeParagraph()
      oWord:Selection:TypeParagraph()
      oWord:Selection:TypeParagraph()


      oWord:Selection:Font:Name := "Courier New"
      oWord:Selection:Font:Size := 10
      oWord:Selection:ParagraphFormat:Alignment := 0 // wdAlignParagraphLeft
      oWord:Selection:TypeText(M_PEDPRZ1)
      oWord:Selection:TypeParagraph()

      oWord:Selection:Font:Name := "Courier New"
      oWord:Selection:Font:Size := 10
      oWord:Selection:ParagraphFormat:Alignment := 0 // wdAlignParagraphLeft
      oWord:Selection:TypeText(M_PEDPRZ2)
      oWord:Selection:TypeParagraph()

      oWord:Selection:Font:Name := "Courier New"
      oWord:Selection:Font:Size := 10
      oWord:Selection:ParagraphFormat:Alignment := 0 // wdAlignParagraphLeft
      oWord:Selection:TypeText(M_PEDPRZ3)
      oWord:Selection:TypeParagraph()

      oWord:Selection:Font:Name := "Courier New"
      oWord:Selection:Font:Size := 10
      oWord:Selection:ParagraphFormat:Alignment := 0 // wdAlignParagraphLeft
      oWord:Selection:TypeText(M_PEDPRZ4)
      oWord:Selection:TypeParagraph()

      oWord:Selection:Font:Name := "Courier New"
      oWord:Selection:Font:Size := 10
      oWord:Selection:ParagraphFormat:Alignment := 0 // wdAlignParagraphLeft
      oWord:Selection:TypeText(M_PEDPRZ5)
      oWord:Selection:TypeParagraph()
      oWord:Selection:TypeParagraph()
      oWord:Selection:TypeParagraph()
      oWord:Selection:TypeParagraph()

  if M_DECLARA == 2
    oWord:Selection:Font:Name := "Courier New"
    oWord:Selection:Font:Size := 10
    oWord:Selection:ParagraphFormat:Alignment := 0 // wdAlignParagraphLeft
    oWord:Selection:TypeText("                         D E C L A R A C A O")
  else
    oWord:Selection:TypeParagraph()
  endif

  oWord:Selection:TypeParagraph()

  if M_DECLARA == 2
    for AB = 1 to 9
      MS = alltrim(str(AB))
      oWord:Selection:Font:Name := "Courier New"
      oWord:Selection:Font:Size := 10
      oWord:Selection:ParagraphFormat:Alignment := 0 // wdAlignParagraphLeft
      oWord:Selection:TypeText(space(10) +  M_PEDDEC&MS)
      oWord:Selection:TypeParagraph()
    next
  else
    for AB = 1 to 9
      oWord:Selection:TypeParagraph()
    next
  endif

  oWord:Selection:TypeParagraph()

  oWord:Selection:Font:Name := "Courier New"
  oWord:Selection:Font:Size := 10
  oWord:Selection:ParagraphFormat:Alignment := 0 // wdAlignParagraphLeft
  oWord:Selection:TypeText(space(10) + "PRESIDENTE PRUDENTE, " + strzero(day(M_PEDDTE),2) + " DE " + M_MESES[month(M_PEDDTE)] + str(year(M_PEDDTE)))
  oWord:Selection:TypeParagraph()

  oWord:Selection:TypeParagraph()
  oWord:Selection:TypeParagraph()
  oWord:Selection:TypeParagraph()
  oWord:Selection:TypeParagraph()
  oWord:Selection:TypeParagraph()
  oWord:Selection:TypeParagraph()

  oWord:Selection:Font:Name := "Courier New"
  oWord:Selection:Font:Size := 8
  oWord:Selection:ParagraphFormat:Alignment := 0 // wdAlignParagraphLeft
  oWord:Selection:TypeText(space(60) + "__________________________________________")
  oWord:Selection:TypeParagraph()

  oWord:Selection:Font:Name := "Courier New"
  oWord:Selection:Font:Size := 8
  oWord:Selection:ParagraphFormat:Alignment := 0 // wdAlignParagraphLeft
  oWord:Selection:TypeText(space(60) + AEMP00->EMPNOM)
  oWord:Selection:TypeParagraph()

  oWord:Selection:Font:Name := "Courier New"
  oWord:Selection:Font:Size := 8
  oWord:Selection:ParagraphFormat:Alignment := 0 // wdAlignParagraphLeft
  oWord:Selection:TypeText(space(60) + "CGC      : " + transform(AEMP00->EMPCGC,"@R 999.999.999/9999-99"))
  oWord:Selection:TypeParagraph()

  oWord:Selection:Font:Name := "Courier New"
  oWord:Selection:Font:Size := 8
  oWord:Selection:ParagraphFormat:Alignment := 0 // wdAlignParagraphLeft
  oWord:Selection:TypeText(space(60) + "Ins. Est.: " + AEMP00->EMPIES)
  oWord:Selection:TypeParagraph()

   oDoc:SaveAs(cNovoArquivo)
   oDoc:Close()
   oWord:Quit()

   ShellExecute("C:\ATLAS\orcamento.docx")


return ""

*****************
function CAB_EMI1
*****************

parameters M_VIA

 PG ++

 if PG > 1
   eject
 endif

 oPrinter:TextOut("",.t.)

* oPrinter:TextOut(cent_cab("Emissao: " + dtoc(M_PEDDTE),"",time(),80),.t.)
* oPrinter:TextOut(cent_cab("Fax : (18) 3223-8243","CNPJ: " + transform(AEMP00->EMPCGC,"@R 999.999.999/9999-99"),"INSC. EST: " + AEMP00->EMPIES,80),.t.)

 oPrinter:TextOut(cent_cab("Emissao: " + dtoc(M_PEDDTE),"O R C A M E N T O","Numero: " + str(M_PEDNUM, 6, 0),80),.T.)
 oPrinter:TextOut(cent_cab(alltrim(AEMP00->EMPNOM),"","CNPJ: " + transform(AEMP00->EMPCGC,"@R 999.999.999/9999-99"),80),.t.)
 oPrinter:TextOut(cent_cab("Fone: (18) 3221-1550",alltrim(AEMP00->EMPEND),alltrim(AEMP00->EMPMUN),80),.t.)
 oPrinter:TextOut(replicate("-",80),.t.)

 cLinha = "Cliente    : "
 cLinha += pad(M_PEDNOM + " " + str(M_PEDCLI, 5, 0), 46)
 cLinha += " Cpg: "
 cLinha += pad(ACPG00->CPGDES, 15)
 oPrinter:TextOut(cLinha,.t.)

 cLinha = "Endereco   : "
 cLinha += pad(M_PEDEND, 42)
 cLinha += "Telefone: "
 cLinha += ACLI00->CLITEL1
 oPrinter:TextOut(cLinha,.t.)

 cLinha = "Municipio  : "
 cLinha += M_PEDMUN
 cLinha += " "
 cLinha += M_PEDEST
 cLinha += " Cep: "
 cLinha += strzero(M_PEDCEP, 5, 0)
 cLinha += " "
 cLinha += strzero(M_PEDCCL, 3, 0)
 cLinha += "          Ven: "
 cLinha += pad(AVEN00->VENNOM, 15)
 oPrinter:TextOut(cLinha,.t.)

  cLinha = "CGC(MF)/CPF: "
  if len(rtrim(M_PEDCGC)) = 11
    cLinha += transform(M_PEDCGC,"@R 999.999.999/99")
    cLinha += space(04)
  else
    cLinha += transform(M_PEDCGC,"@R 999.999.999/9999-99")
  endif

  cLinha += "    Por: " + pad(APOR00->PORNOM, 18)
  cLinha += " Ies: "
  cLinha += pad(M_PEDIES, 15)
  oPrinter:TextOut(cLinha,.t.)

  cLinha = "Transporte : "
  cLinha += pad(ATRA00->TRANOM, 42)
  cLinha += "Telefone: "
  cLinha += ATRA00->TRAPLC
  oPrinter:TextOut(cLinha,.t.)

  cLinha = "Mensagem   : "
  cLinha += M_PEDHS1
  oPrinter:TextOut(cLinha,.t.)

  cLinha = "           : "
  cLinha += M_PEDHS2
  oPrinter:TextOut(cLinha,.t.)

  oPrinter:TextOut(replicate("-",80),.t.)
  oPrinter:TextOut(" Codigo   Qtde  Un  Produto(s)                             Unitario   Total ",.t.)
  oPrinter:TextOut(replicate("-",80),.t.)

  LN = 15

return ""

***************
function GRAPED
***************

parameters M_OPCAO


*  calc_dupped(.t.)

  if M_OPCAO
    seexistesql("APEDID")
    cSql := "select first 1 gen_id(gen_APED00_id,1) from aped00"
    dbusearea(.t.,"SQLMIX",cSql,"APEDID")
    M_ID = GEN_ID
    select APEDID
    use
    M_PEDNUM = M_ID

    if !BUSCAREGISTRO("AFIS00",1,{str(ME_EMP, 2, 0),M_PEDNATN},"SELECT")
      msg("* * * NATUREZA NAO CADASTRADA * * *")
      return ""
    endif

    do while .t.
      if BUSCAREGISTRO("APED00",1,{str(M_PEDEMP, 2, 0),str(M_PEDNUM, 6, 0),aspas(M_PEDSER)},"SELECT")
        seexistesql("APEDID")
        cSql := "select first 1 gen_id(gen_APED00_id,1) from aped00"
        dbusearea(.t.,"SQLMIX",cSql,"APEDID")
        M_ID = GEN_ID
        select APEDID
        use
        M_PEDNUM = M_ID
        loop
      endif
      exit
    enddo
    
    grped01("INSERT")
    grped02("INSERT")
  else
    grped01("UPDATE")
    grped02("INSERT")
  endif

  set color to I
    @ 04, 12 say M_PEDNUM picture "######"
    @ 04, 19 say M_PEDSER picture "@!" 
  set color to 


  msg("* * * OR€AMENTO GRAVADO * * *")

return "" 

****************
function GRPED01(cACAO)                       && grava pedido
****************

  sqlCAMPO = {}
  sqlCHAVE = {}
  sqlARQUI = {"APED00",(cACAO)}

  aadd(sqlCHAVE,{"PEDEMP",str(ME_EMP, 2)})
  aadd(sqlCHAVE,{"PEDNUM",str(M_PEDNUM, 6)})
  aadd(sqlCHAVE,{"PEDSER",aspas(M_PEDSER)})

  if !cACAO $ "#DELETE#SELECT#"
    aadd(sqlCAMPO,{"PEDEMP",str(M_PEDEMP,2),.T.})
    aadd(sqlCAMPO,{"PEDNUM",str(M_PEDNUM,6),.T.})
    aadd(sqlCAMPO,{"PEDSER",M_PEDSER,.T.})
    aadd(sqlCAMPO,{"PEDNFS",str(M_PEDNFS),.T.})
*    aadd(sqlCAMPO,{"PEDNSE",M_PEDNSE,.T.})
    aadd(sqlCAMPO,{"PEDDTE",formatdta(M_PEDDTE),.T.})
    aadd(sqlCAMPO,{"PEDFRC",M_NFSFRC,.T.})
    aadd(sqlCAMPO,{"PEDNAT",str(M_PEDNAT,5),.T.})
    aadd(sqlCAMPO,{"PEDCLI",str(M_PEDCLI,5),.T.})
    aadd(sqlCAMPO,{"PEDTELTRA",M_PEDTELTRA,.T.})
    aadd(sqlCAMPO,{"PEDNOM",M_PEDNOM,.T.})
    aadd(sqlCAMPO,{"PEDEND",M_PEDEND,.T.})
    aadd(sqlCAMPO,{"PEDBAI",M_PEDBAI,.T.})
    aadd(sqlCAMPO,{"PEDMUN",M_PEDMUN,.T.})
    aadd(sqlCAMPO,{"PEDCEP",str(M_PEDCEP,5),.T.})
    aadd(sqlCAMPO,{"PEDCCL",str(M_PEDCCL,3),.T.})
    aadd(sqlCAMPO,{"PEDEST",M_PEDEST,.T.})
    aadd(sqlCAMPO,{"PEDIES",M_PEDIES,.T.})
    aadd(sqlCAMPO,{"PEDCGC",M_PEDCGC,.T.})
    aadd(sqlCAMPO,{"PEDCPG",str(M_PEDCPG,3),.T.})
    aadd(sqlCAMPO,{"PEDVEN",str(M_PEDVEN,3),.T.})
    aadd(sqlCAMPO,{"PEDTRA",str(M_PEDTRA,3),.T.})
    aadd(sqlCAMPO,{"PEDPOR",str(M_PEDPOR,5),.T.})
    aadd(sqlCAMPO,{"PEDOBS",M_PEDOBS,.T.})
    aadd(sqlCAMPO,{"PEDIPL"," ",.T.})
    aadd(sqlCAMPO,{"PEDVLP",str1(M_PEDVLP,2),.T.})
    aadd(sqlCAMPO,{"PEDDSC",str1(M_PEDDSC,2),.T.})
    aadd(sqlCAMPO,{"PEDFRE",str1(M_PEDFRE,2),.T.})
    aadd(sqlCAMPO,{"PEDVLN",str1(M_PEDVLN,2),.T.})
    aadd(sqlCAMPO,{"PEDVLM",str1(M_PEDVLM,2),.T.})
    aadd(sqlCAMPO,{"PEDVIC",str1(M_PEDVIC,2),.T.})
    aadd(sqlCAMPO,{"PEDVLMS",str1(M_PEDVLMS,2),.T.})
    aadd(sqlCAMPO,{"PEDVICS",str1(M_PEDVICS,2),.T.})

    aadd(sqlCAMPO,{"PEDHS1",M_PEDHS1,.T.})
    aadd(sqlCAMPO,{"PEDHS2",M_PEDHS2,.T.})
    aadd(sqlCAMPO,{"PEDHS3",M_PEDHS3,.T.})
    aadd(sqlCAMPO,{"PEDVC1",formatdta(M_PEDVC1),.T.})
    aadd(sqlCAMPO,{"PEDVC2",formatdta(M_PEDVC2),.T.})
    aadd(sqlCAMPO,{"PEDVC3",formatdta(M_PEDVC3),.T.})
    aadd(sqlCAMPO,{"PEDVC4",formatdta(M_PEDVC4),.T.})
    aadd(sqlCAMPO,{"PEDVC5",formatdta(M_PEDVC5),.T.})
    aadd(sqlCAMPO,{"PEDVC6",formatdta(M_PEDVC6),.T.})
    aadd(sqlCAMPO,{"PEDDP1",str1(M_PEDDP1,2),.T.})
    aadd(sqlCAMPO,{"PEDDP2",str1(M_PEDDP2,2),.T.})
    aadd(sqlCAMPO,{"PEDDP3",str1(M_PEDDP3,2),.T.})
    aadd(sqlCAMPO,{"PEDDP4",str1(M_PEDDP4,2),.T.})
    aadd(sqlCAMPO,{"PEDDP5",str1(M_PEDDP5,2),.T.})
    aadd(sqlCAMPO,{"PEDDP6",str1(M_PEDDP6,2),.T.})
    aadd(sqlCAMPO,{"PEDEMI",M_PEDEMI,.T.})
  endif

  executasql()
  return ""


**************** 
function GRPED02                       && grava pedido itens
**************** 

sqlCAMPO = {}
sqlCHAVE = {}
sqlARQUI = {"APED01","DELETE"}
aadd(sqlCHAVE,{"PEDEMP",str(M_PEDEMP,2)})
aadd(sqlCHAVE,{"PEDNUM",str(M_PEDNUM,6)})
aadd(sqlCHAVE,{"PEDSER",aspas(M_PEDSER)})
executasql()

private R

for R = 1 to len(M_PEDMAT)

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"APED01","INSERT"}

  aadd(sqlCAMPO,{"PEDEMP",str(M_PEDEMP,2),.T.})
  aadd(sqlCAMPO,{"PEDNUM",str(M_PEDNUM,6),.T.})
  aadd(sqlCAMPO,{"PEDSER",M_PEDSER,.T.})
  aadd(sqlCAMPO,{"PEDSEQ",str(M_PEDMAT[R][1],3),.T.})
  aadd(sqlCAMPO,{"PEDMAT",str(M_PEDMAT[R][2],6),.T.})
  aadd(sqlCAMPO,{"PEDQDE",str1(M_PEDMAT[R][3],3),.T.})
  aadd(sqlCAMPO,{"PEDPRB",str1(M_PEDMAT[R][4],2),.T.})
  aadd(sqlCAMPO,{"PEDVLI",str1(M_PEDMAT[R][5],2),.T.})
  aadd(sqlCAMPO,{"PEDLIQ",str1(M_PEDMAT[R][6],2),.T.})
  aadd(sqlCAMPO,{"PEDCOM",str1(M_PEDMAT[R, 7],2),.T.})
  aadd(sqlCAMPO,{"PEDCLI",str(M_PEDCLI,5),.T.})
  aadd(sqlCAMPO,{"PEDDTE",formatdta(M_PEDDTE),.T.})
  aadd(sqlCAMPO,{"PEDIPL"," ",.T.})
  executasql()

next && R

return ""

*************** 
function GRPTMP                       && grava pedido itens
*************** 

private R

select ATEM00
zap

  for R = 1 to len(M_PEDMAT)
    append blank
    replace PEDEMP  with M_PEDEMP
    replace PEDNUM  with M_PEDNUM
    replace PEDSER  with M_PEDSER
    replace PEDSEQ  with M_PEDMAT[R, 1]
    replace PEDMAT  with M_PEDMAT[R, 2]
    replace PEDQDE  with M_PEDMAT[R, 3]
    replace PEDPRB  with M_PEDMAT[R, 4]
    replace PEDVLI  with M_PEDMAT[R, 5]
    replace PEDLIQ  with M_PEDMAT[R, 6]
    replace PEDCOM  with M_PEDMAT[R, 7]
    replace PEDCLI  with M_PEDCLI
    replace PEDDTE  with M_PEDDTE
    replace PEDIPL  with M_PEDIPL
  next && R

return ""

********************
function CALC_DUPPED(TIPO)
********************
LOCAL M_TELACALC_DUPPED

  lOCAL aCALC_DUPPED := {}


  private M_PED[06] ,;
          M_VCT[06] ,;
          M_FER[08] ,;
          M_PR[06]  ,;
          M_PE[06]
  declare M_PED[06] ,;
          M_VCT[06] ,;
          M_FER[08] ,;
          M_PR[06]  ,;
          M_PE[06]
  private M_TOTDP ,;
          R, S    ,;
          M_S     ,;
          M_RES   ,;
          M_PARC  ,;
          M_TELA  ,;
          M_VALOR
 
  store 0 to M_VLR ,;
             M_RES

  if M_PEDCPG > 2 .and. M_PEDCPG <= 20
    return ""
  endif

  for R = 1 to 6
     M_PED[ R ] = 0
     M_VCT[ R ] = ctod("  /  /  ")
  next &&  R

  if !BUSCAREGISTRO("ACPG00",1,{str(M_PEDCPG,3,0)},"SELECT")
    msg("* * * CONDICAO PAGAMENTO NAO CADASTRADA * * *")
    return ""
  endif

  M_VALOR = M_PEDVLN

  select ACPG00

M_PARC    = CPGPAR 

for S = 1 to 6
  M_S = strzero(S, 1, 0)      
  M_PE[ S ] = CPGPE&M_S
  M_PR[ S ] = CPGPR&M_S
next && S

for R = 1 to M_PARC            && calcula as duplicatas
  M_PED[ R ] =  round((M_VALOR * .01) * M_PE[ R ], 2)
  M_VCT[ R ] = M_PEDDTE + M_PR[ R ]
  M_VLR = M_VLR + round(M_PED[ R ], 2)   && somas as duplicatas
next &&  R

M_RES = ( M_VALOR - M_VLR )
M_PED[ M_PARC ] = M_PED[ M_PARC ] + M_RES

for S = 1 to 6
  M_S = strzero(S, 1, 0)      
  M_PEDDP&M_S = M_PED[ S ]
  M_PEDVC&M_S = M_VCT[ S ]
next && S

  M_TELACALC_DUPPED = savescreen(06, 43, 20, 75)


  do while .t.
 
    nbox(08, 44, 19, 72,"W/W+",.t.)
    setcolor("N/W")
       @ 09, 45 say     "DUP   VCTO       VALOR     "
       @ 10, 45 say     "                           "
       @ 11, 45 say     " 01                        "
       @ 12, 45 say     " 02                        "
       @ 13, 45 say     " 03                        "
       @ 14, 45 say     " 04                        "
       @ 15, 45 say     " 05                        "
       @ 16, 45 say     " 06                        "
       @ 17, 45 say     "                           "
       @ 18, 45 say     "Pedido   R$                "
     set color to

     setcolor("N/W*")
       @ 18, 60 say M_PEDVLN   picture "#########.##"
     SetColor(_COREDICAO_)
     @ 11, 49 get     M_PEDVC1
     @ 11, 60 get     M_PEDDP1 picture "#########.##"
     @ 12, 49 get     M_PEDVC2
     @ 12, 60 get     M_PEDDP2 picture "#########.##"
     @ 13, 49 get     M_PEDVC3
     @ 13, 60 get     M_PEDDP3 picture "#########.##"
     @ 14, 49 get     M_PEDVC4
     @ 14, 60 get     M_PEDDP4 picture "#########.##"
     @ 15, 49 get     M_PEDVC5
     @ 15, 60 get     M_PEDDP5 picture "#########.##"
     @ 16, 49 get     M_PEDVC6
     @ 16, 60 get     M_PEDDP6 picture "#########.##"
     read

     M_TOTDP = (M_PEDDP1 + M_PEDDP2 + M_PEDDP3 + M_PEDDP4 + M_PEDDP5 + M_PEDDP6)  

     if !str(M_PEDVLN, 12, 2) == str(M_TOTDP, 12, 2) 
        msg(str(M_PEDVLN, 12, 2) + "* * * SOMA DE PEDLICATA NAO BATE COM O OR€AMENTO * * *")
         if lastkey()=17 
           exit
         endif 
        loop
     endif

     exit

  enddo

  restscreen(06, 43, 20, 75, M_TELACALC_DUPPED)

return ""

****************
function MSPED04                     && mostra dados e calcula nota fiscal
****************


private  M_TELA ,;
         R

    M_TELA = savescreen(07, 20, 16, 62)

    nbox(07, 20, 12, 59,"W/W+",.t.)
    setcolor("B/W")
      @ 08, 21 say  "  Valor do Produto:                   "
      @ 09, 21 say  "          Desconto:                   "
      @ 10, 21 say  "             Frete:                   "
      @ 11, 21 say  "         Or‡amento:                   "
    setcolor("N/W*")
      @ 08, 41 say APED00->PEDVLP                 picture "@E ###,###,###,###.##"
      @ 09, 41 say APED00->PEDDSC                 picture "@E ###,###,###,###.##"
      @ 10, 41 say APED00->PEDFRE                 picture "@E ###,###,###,###.##"
      @ 11, 41 say APED00->PEDVLN                 picture "@E ###,###,###,###.##"
    set color to
     
    msg("* * * TECLE (ENTER) * * *")

    restscreen(07, 20, 16, 62, M_TELA)

return ""

#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)

***************
function REEPED
***************

private M_TELA  ,;
        M_PEDEMP,;
        M_PEDNUM,;
        M_PEDSER

M_TELA = savescreen(11, 25, 15, 54)

save get to M_GETANT

M_PEDEMP = ME_EMP
M_PEDNUM = 0
M_PEDSER = AEMP00->EMPPSE

do while .t.

  sombra(11, 27, 13, 51,_SOMBRA_)

  set color to GR+/BG+
    @ 11, 27 say         "ÚÄÄÄÄÄÄÄReemiss„oÄÄÄÄÄÄÄ¿"
    @ 12, 27 say         "³  Orcamento :          ³"
    @ 13, 27 say         "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
  set color to
  SetColor(_COREDICAO_)
  @ 12, 42 get M_PEDNUM picture "######"
  @ 12, 49 get M_PEDSER picture "@!"
  read

  if lastkey() = 27
    exit
  endif

  select APED00

  if !dbseek(str(M_PEDEMP, 2, 0) + str(M_PEDNUM, 6, 0) + M_PEDSER)
    msg("* * * OR€AMENTO NAO INCLUIDO * * *")
    loop
  endif

  M_IMPRE = impresn()

  if M_IMPRE = "N"
    return ""
  endif

*  ?? chr(27) + "0"
*  ?? chr(27) + "C" + chr(44)

  ACLI00->(dbseek(str(APED00->PEDCLI, 7, 0)))
  AVEN00->(dbseek(str(APED00->PEDVEN, 3, 0)))
  AFOR00->(dbseek(str(APED00->PEDCLI, 7, 0)))
  ACPG00->(dbseek(str(APED00->PEDCPG, 3, 0)))
  APOR00->(dbseek(str(APED00->PEDPOR, 5, 0)))

  M_TOTLIN = 0

  cab199()

  select APED01

  dbseek(str(APED00->PEDEMP, 2, 0) + str(APED00->PEDNUM, 6, 0) + APED00->PEDSER, .t.)

  LN = 0

  do while !eof()
    if !str(PEDEMP, 2, 0) + str(PEDNUM, 6, 0) + PEDSER == str(APED00->PEDEMP, 2, 0) + str(APED00->PEDNUM, 6, 0) + APED00->PEDSER
       exit
    endif

    APCA00->(dbseek(str(APED01->PEDMAT, 6, 0)))

    ? " "
     ?? str(APED01->PEDMAT, 6, 0)
     ?? " " 
     ?? transform(APED01->PEDQDE,"@E #######")
     ?? " " 
     ?? pad(APCA00->PCAUNI, 03)
     ?? " "
     ?? chr(15)
     ?? pad(APCA00->PCADES, 50)
     ?? chr(18)
     ?? "       "
     ?? transform(APED01->PEDPRB,"@E ###,###.##") 
     ?? " "
     ?? transform(APED01->PEDVLI,"@E ####,###.##") 
     LN ++

     if !APED00->PEDNATN == "6.000"
       ? 
       LN++
     endif

     M_TOTLIN = M_TOTLIN + 1

     if LN > 59
       eject
       cab199()
       LN = 0
       M_TOTLIN = 0
       select APED01
     endif

    skip
  enddo

  for R = M_TOTLIN to 15
    ?
  next

  ?? chr(27) + "2"

  ? replicate("-",80)

  ? pad("EMITIDO: " + APED00->PEDEMI ,54)
  ?? "   Produto : R$ "
  ?? transform(APED00->PEDVLP,"@E ###,###.##")

   ? iif(APED00->PEDDP1 > 0,"Vencimento(s) ",space(14))
    ?? iif(empty(APED00->PEDVC1),space(08),APED00->PEDVC1)
    ?? " "
    ?? transform(APED00->PEDDP1,"@E@Z ###,###.##")
    ?? "  "
    ?? iif(empty(APED00->PEDVC4),space(08),APED00->PEDVC4)
    ?? " "
    ?? transform(APED00->PEDDP4,"@E@Z ###,###.##")
    if !APED00->PEDNATN == "6.000"
      ?? "      Frete: R$ "
      ?? transform(M_PEDFRE,"@E ###,###.##")      
    endif
   ? "              "
    ?? iif(empty(APED00->PEDVC2),space(08),APED00->PEDVC2)
    ?? " "
    ?? transform(APED00->PEDDP2,"@E@Z ###,###.##")      
    ?? "  "
    ?? iif(empty(APED00->PEDVC5),space(08),APED00->PEDVC5)
    ?? " "
    ?? transform(APED00->PEDDP5,"@E@Z ###,###.##")      
    ?? "   Desconto: R$ "
    ?? transform(APED00->PEDDSC,"@E ###,###.##")      
   ? "              "
    ?? iif(empty(APED00->PEDVC3),space(08),APED00->PEDVC3)
    ?? " "
    ?? transform(APED00->PEDDP3,"@E@Z ###,###.##")      
    ?? "  "
    ?? iif(empty(APED00->PEDVC6),space(08),APED00->PEDVC6)
    ?? " "
    ?? transform(APED00->PEDDP6,"@E@Z ###,###.##")      
    ?? "   Total   : R$ "
    ?? chr(27) + "E"
    ?? transform(APED00->PEDVLN,"@E ###,###.##")      
    ?? chr(27) + "F" 

   ?
   ?
   ?
   ?
   ?
   ?
   ?

   ? cent_cab("","* * * REEMISSAO * * *","",80) 

   eject

desliga1(,"F")

   exit

enddo

restore get from M_GETANT

restscreen(11, 25, 15, 54, M_TELA)

return ""

***************
function CAB199
***************

 select APED00

 ? cent_cab("",iif(APED00->PEDNATN == "6.000","P  E  D  I  D  O","O R C A M E N T O"),"Numero: " + str(M_PEDNUM, 6, 0),80) 
 ? cent_cab("Emissao: " + dtoc(PEDDTE),"",time(),80) 
 ?? chr(27) + "E"
 ? cent_cab("",alltrim(AEMP00->EMPNOM),"",80) 
 ?? chr(27) + "F"
 ? cent_cab("Fone: (18) 3221-1550",alltrim(AEMP00->EMPEND),alltrim(AEMP00->EMPMUN),80) 
 ? cent_cab("Fax : (18) 3221-8243","CGC: " + transform(AEMP00->EMPCGC,"@R 999.999.999/9999-99"),"INSC. EST: " + AEMP00->EMPIES,80)
 ? replicate("-",80)

 if APED00->PEDNATN == "6.000"
   ? "Fornecedor : "
 else
   ? "Cliente    : "
 endif
   ?? pad(PEDNOM + " " + str(PEDCLI, 5, 0), 46)
   ?? " Cpg: " 
   ?? pad(ACPG00->CPGDES, 15)

   ? "Endereco   : "
   ?? pad(PEDEND, 42) 
   ?? "Telefone: "
   if APED00->PEDNATN == "6.000"   
     ?? AFOR00->FORTEL
   else
     ?? ACLI00->CLITEL1
   endif 

 ? "Municipio  : "
   ?? PEDMUN 
   ?? " "
   ?? PEDEST
   ?? " Cep: "
   ?? strzero(PEDCEP, 5, 0)
   ?? " "
   ?? strzero(PEDCCL, 3, 0)
   ?? "          Ven: "
   ?? pad(AVEN00->VENNOM, 15)

 ? "CGC(MF)/CPF: "
   if len(rtrim(PEDCGC)) = 11
     ?? transform(PEDCGC,"@R 999.999.999/99")
     ?? space(04)
   else
     ?? transform(PEDCGC,"@R 999.999.999/9999-99")
   endif
   ?? "    Por: " + pad(APOR00->PORNOM, 18)
   ?? " Ies: "
   ?? pad(PEDIES, 15)    

   ? "Transporte : "
   ?? pad(ATRA00->TRANOM, 42)
   ?? "Telefone: "
   if APED00->PEDNATN == "6.000"
     ?? APED00->PEDTELTRA
   else
     ?? ATRA00->TRAPLC    
   endif

 ? "Mensagem   : "
   ?? PEDHS1
 ? "           : "
   ?? PEDHS2

 ? replicate("-",80)
 ? " Codigo   Qtde  Un  Produto(s)                             Unitario   Total "
*    999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX ######### ###,###.## ###,###.## C
 ? replicate("-",80)

   if !APED00->PEDNATN == "6.000"
     ?? chr(27) + "0"
   endif

return ""

***************
function OUTPED
***************

msgbox1("EM DESENVOLVIMENTO CONTATE SUPORTE")
return ""

parameters M_OPC,M_OPC1,M_OPC2

*        @ 11, 24 prompt "Alteracao   " HIGHLITE R/BG
*        @ 12, 24 prompt "Emissao Nota" HIGHLITE R/BG

      do case
         case M_OPC = 1 ; conped_c()
         case M_OPC = 2 ; conped_d()
      endcase             

return ""


*FUNCTION __DBGENTRY

*return ""


***************
function EMIPED2
***************

parameter M_OPCAO

  M_TOTPRO = 0
  LN = 0
  PG = 0

  M_DECLARA = 1


    M_PEDDEC1 = "                                                            "
    M_PEDDEC2 = "                                                            "
    M_PEDDEC3 = "                                                            "
    M_PEDDEC4 = "                                                            "
    M_PEDDEC5 = "                                                            "
    M_PEDDEC6 = "                                                            "
    M_PEDDEC7 = "                                                            "
    M_PEDDEC8 = "                                                            "
    M_PEDDEC9 = "                                                            "


*  if left(M_PEDNATN,5) == "Venda"    // quando venda grava as duplicatas na 51 é uma venda SN
*    calc_dupped(.t.)
*  endif

  if M_OPCAO
    seexistesql("APEDID")
    cSql := "select first 1 gen_id(gen_APED00_id,1) from aped00"
    dbusearea(.t.,"SQLMIX",cSql,"APEDID")
    M_ID = GEN_ID
    select APEDID
    use
    M_PEDNUM = M_ID

    do while .t.
      if BUSCAREGISTRO("APED00",1,{str(M_PEDEMP, 2, 0),str(M_PEDNUM, 6, 0),aspas(M_PEDSER)},"SELECT")
        seexistesql("APEDID")
        cSql := "select first 1 gen_id(gen_APED00_id,1) from aped00"
        dbusearea(.t.,"SQLMIX",cSql,"APEDID")
        M_ID = GEN_ID
        select APEDID
        use
        M_PEDNUM = M_ID
        loop
      endif
      exit
    enddo
    grped01("INSERT")
    grped02("INSERT")
  else
    grped01("UPDATE")
    grped02("INSERT")
  endif

  set color to I
    @ 04, 12 say M_PEDNUM picture "######"
    @ 04, 19 say M_PEDSER picture "@!"
  set color to

  M_IMPRE = impresn()

  if M_IMPRE = "N"
    return ""
  endif

  oPrinter := Win32Prn():New( )
  oPrinter:Landscape := .F.
  oPrinter:FormType  := 9
  inicio_impressao()

*  if left(M_PEDNATN,5) == "Venda" .or. left(M_PEDNATN,4) == "Nota"
*    oPrinter:LineHeight := Int( oPrinter:PixelsPerInchY / 7 )  // Default 6 lines per inch == # of pixels per line
*  endif

  valorescli(M_PEDCLI)
  BUSCAREGISTRO("AVEN00",1,{str(M_PEDVEN,3,0)},"SELECT")
  BUSCAREGISTRO("APOR00",1,{str(M_PEDPOR,5,0)},"SELECT")


  M_FLAG = 0
  M_TOTLIN = 0

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"APED01","APED01"})
  aadd(sqlCAMPO,"APED01.*")
  aadd(sqlCAMPO,"APCA00.PCAMAT")
  aadd(sqlCAMPO,"APCA00.PCADES")
  aadd(sqlCAMPO,"APCA00.PCAUNI")
  aadd(sqlCAMPO,"APCA00.PCAMAR")
  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","APED01.PEDMAT"})
  aadd(sqlCHAVE,"PEDNUM = " + str(M_PEDNUM, 6, 0))
  aadd(sqlCHAVE,"PEDEMP = " + str(M_PEDEMP, 2, 0))
  aadd(sqlCHAVE,"PEDSER = " + aspas(M_PEDSER))
  aadd(sqlORDEM,"PEDNUM,PCADES")
  sqlrelation()
  go bottom
  go top

lMeia = .f.

if lastrec() <= 18
 lMeia = .t.
endif


RR = 1

if lMEIA
  for ABC = 1 to 2  // se venda meia pagina
    cab_emi1("")                   && imprime cabecalho

    select APED01
    go top

    do while !eof()
      oPrinter:SetFont( "Courier New", 11.5,0)  // Compressed print

      cLinha = " "
      cLinha += str(PEDMAT, 6, 0)
      cLinha += " "
      cLinha += transform(PEDQDE,"@E #######")
      cLinha += " "
      cLinha += pad(PCAUNI, 03)
      cLinha += " "
      oPrinter:TextOut(cLinha)

*      oPrinter:SetPrc( oPrinter:Prow(),oPrinter:Pcol())

      oPrinter:SetFont( "Courier New", 11.5, { 4, -80 } )  // Alternative Compressed print
      oPrinter:TextOut(pad(alltrim(PCADES + " " + PCAMAR), 57))

*      oPrinter:SetPrc( oPrinter:Prow(),oPrinter:Pcol())

      oPrinter:SetFont( "Courier New", 11.5,0)  // Compressed print

      cLinha = "       "
      cLinha += transform(PEDPRB,"@E ###,###.##")
      cLinha += " "
      cLinha += transform(PEDVLI,"@E ####,###.##")

      oPrinter:TextOut(cLinha,.t.)

      skip

    enddo

    if ABC = 1 // primeira pagina
      oPrinter:SetPrc(33, 0 )
    else
      oPrinter:SetPrc(74, 0 )
    endif

    oPrinter:TextOut(replicate("-",80),.t.)
    oPrinter:TextOut(pad("EMITIDO: " + M_PEDEMI ,54) + "   Produto : R$ " + transform(M_PEDVLMS,"@E ###,###.##"),.t.)
    oPrinter:TextOut(space(54) + "   Aluguel : R$ " + transform(M_PEDVICS,"@E ###,###.##"),.t.)

    cLinha = iif(M_PEDDP1 > 0,"Vencimento(s) ",space(14))
    cLinha += iif(empty(M_PEDVC1),space(08),dtoc(M_PEDVC1))
    cLinha += " "
    cLinha += transform(M_PEDDP1,"@E@Z ###,###.##")
    cLinha += "  "
    cLinha += iif(empty(M_PEDVC4),space(08),dtoc(M_PEDVC4))
    cLinha += " "
    cLinha += transform(M_PEDDP4,"@E@Z ###,###.##")
    cLinha += "      Frete: R$ "
    cLinha += transform(M_PEDFRE,"@E ###,###.##")
    oPrinter:TextOut(cLinha,.t.)

    cLinha = "              "
    cLinha += iif(empty(M_PEDVC2),space(08),dtoc(M_PEDVC2))
    cLinha += " "
    cLinha += transform(M_PEDDP2,"@E@Z ###,###.##")
    cLinha += "  "
    cLinha += iif(empty(M_PEDVC5),space(08),dtoc(M_PEDVC5))
    cLinha += " "
    cLinha += transform(M_PEDDP5,"@E@Z ###,###.##")
    cLinha += "   Desconto: R$ "
    cLinha += transform(M_PEDDSC,"@E ###,###.##")
    oPrinter:TextOut(cLinha,.t.)

    cLinha = "              "
    cLinha += iif(empty(M_PEDVC3),space(08),dtoc(M_PEDVC3))
    cLinha += " "
    cLinha += transform(M_PEDDP3,"@E@Z ###,###.##")
    cLinha += "  "
    cLinha += iif(empty(M_PEDVC6),space(08),dtoc(M_PEDVC6))
    cLinha += " "
    cLinha += transform(M_PEDDP6,"@E@Z ###,###.##")
    cLinha += "   Total   : R$ "
    oPrinter:TextOut(cLinha)
    oPrinter:Bold( WIN_FW_EXTRABOLD )
    oPrinter:SetPrc( oPrinter:Prow(),oPrinter:Pcol())
    oPrinter:TextOut(transform(M_PEDVLN,"@E ###,###.##"),.t.)
    oPrinter:Bold( WIN_FW_DONTCARE )
    oPrinter:TextOut("",.t.)
    oPrinter:TextOut("",.t.)

    if ABC = 1 // primeira pagina
      oPrinter:SetPrc(42, 0 )
    endif
  next
else  // PAGINA INTEIRA
    cab_emi1("")                   && imprime cabecalho

    select APED01
    go top

    do while !eof()
      oPrinter:SetFont( "Courier New", 11.5,0)  // Compressed print

      cLinha = " "
      cLinha += str(PEDMAT, 6, 0)
      cLinha += " "
      cLinha += transform(PEDQDE,"@E #######")
      cLinha += " "
      cLinha += pad(PCAUNI, 03)
      cLinha += " "
      oPrinter:TextOut(cLinha)

*      oPrinter:SetPrc( oPrinter:Prow(),oPrinter:Pcol())

      oPrinter:SetFont( "Courier New", 11.5, { 4, -80 } )  // Alternative Compressed print
      oPrinter:TextOut(pad(alltrim(PCADES + " " + PCAMAR), 57))

*      oPrinter:SetPrc( oPrinter:Prow(),oPrinter:Pcol())

      oPrinter:SetFont( "Courier New", 11.5,0)  // Compressed print

      cLinha = "       "
      cLinha += transform(PEDPRB,"@E ###,###.##")
      cLinha += " "
      cLinha += transform(PEDVLI,"@E ####,###.##")

      oPrinter:TextOut(cLinha,.t.)  // quando for separacao PULAR 2 LINHAS
      oPrinter:TextOut("",.t.)
      oPrinter:TextOut("",.t.)

      skip

    enddo

    oPrinter:SetPrc(62, 0 )

    oPrinter:TextOut(replicate("-",80),.t.)
    oPrinter:TextOut(pad("EMITIDO: " + M_PEDEMI ,54) + "   Produto : R$ " + transform(M_PEDVLMS,"@E ###,###.##"),.t.)
    oPrinter:TextOut(space(54) + "   Aluguel : R$ " + transform(M_PEDVICS,"@E ###,###.##"),.t.)

    cLinha = iif(M_PEDDP1 > 0,"Vencimento(s) ",space(14))
    cLinha += iif(empty(M_PEDVC1),space(08),dtoc(M_PEDVC1))
    cLinha += " "
    cLinha += transform(M_PEDDP1,"@E@Z ###,###.##")
    cLinha += "  "
    cLinha += iif(empty(M_PEDVC4),space(08),dtoc(M_PEDVC4))
    cLinha += " "
    cLinha += transform(M_PEDDP4,"@E@Z ###,###.##")
    cLinha += "      Frete: R$ "
    cLinha += transform(M_PEDFRE,"@E ###,###.##")
    oPrinter:TextOut(cLinha,.t.)

    cLinha = "              "
    cLinha += iif(empty(M_PEDVC2),space(08),dtoc(M_PEDVC2))
    cLinha += " "
    cLinha += transform(M_PEDDP2,"@E@Z ###,###.##")
    cLinha += "  "
    cLinha += iif(empty(M_PEDVC5),space(08),dtoc(M_PEDVC5))
    cLinha += " "
    cLinha += transform(M_PEDDP5,"@E@Z ###,###.##")
    cLinha += "   Desconto: R$ "
    cLinha += transform(M_PEDDSC,"@E ###,###.##")
    oPrinter:TextOut(cLinha,.t.)

    cLinha = "              "
    cLinha += iif(empty(M_PEDVC3),space(08),dtoc(M_PEDVC3))
    cLinha += " "
    cLinha += transform(M_PEDDP3,"@E@Z ###,###.##")
    cLinha += "  "
    cLinha += iif(empty(M_PEDVC6),space(08),dtoc(M_PEDVC6))
    cLinha += " "
    cLinha += transform(M_PEDDP6,"@E@Z ###,###.##")
    cLinha += "   Total   : R$ "
    oPrinter:TextOut(cLinha)
    oPrinter:Bold( WIN_FW_EXTRABOLD )
    oPrinter:SetPrc( oPrinter:Prow(),oPrinter:Pcol())
    oPrinter:TextOut(transform(M_PEDVLN,"@E ###,###.##"),.t.)
    oPrinter:Bold( WIN_FW_DONTCARE )
    oPrinter:TextOut("",.t.)
    oPrinter:TextOut("",.t.)

endif

/*
 for R = M_TOTLIN to 15
   oPrinter:TextOut("",.t.)
 next

  oPrinter:TextOut(replicate("-",80),.t.)
  oPrinter:TextOut(pad("EMITIDO: " + M_PEDEMI ,54) + "   Produto : R$ " + transform(M_PEDVLMS,"@E ###,###.##"),.t.)
  oPrinter:TextOut(space(54) + "   Aluguel : R$ " + transform(M_PEDVICS,"@E ###,###.##"),.t.)

  cLinha = iif(M_PEDDP1 > 0,"Vencimento(s) ",space(14))
  cLinha += iif(empty(M_PEDVC1),space(08),dtoc(M_PEDVC1))
  cLinha += " "
  cLinha += transform(M_PEDDP1,"@E@Z ###,###.##")
  cLinha += "  "
  cLinha += iif(empty(M_PEDVC4),space(08),dtoc(M_PEDVC4))
  cLinha += " "
  cLinha += transform(M_PEDDP4,"@E@Z ###,###.##")
  if !M_PEDNATN == "6.000"
    cLinha += "      Frete: R$ "
    cLinha += transform(M_PEDFRE,"@E ###,###.##")
  endif
  oPrinter:TextOut(cLinha,.t.)

  cLinha = "              "
  cLinha += iif(empty(M_PEDVC2),space(08),dtoc(M_PEDVC2))
  cLinha += " "
  cLinha += transform(M_PEDDP2,"@E@Z ###,###.##")
  cLinha += "  "
  cLinha += iif(empty(M_PEDVC5),space(08),dtoc(M_PEDVC5))
  cLinha += " "
  cLinha += transform(M_PEDDP5,"@E@Z ###,###.##")
  cLinha += "   Desconto: R$ "
  cLinha += transform(M_PEDDSC,"@E ###,###.##")
  oPrinter:TextOut(cLinha,.t.)

  cLinha = "              "
  cLinha += iif(empty(M_PEDVC3),space(08),dtoc(M_PEDVC3))
  cLinha += " "
  cLinha += transform(M_PEDDP3,"@E@Z ###,###.##")
  cLinha += "  "
  cLinha += iif(empty(M_PEDVC6),space(08),dtoc(M_PEDVC6))
  cLinha += " "
  cLinha += transform(M_PEDDP6,"@E@Z ###,###.##")
  cLinha += "   Total   : R$ "
  oPrinter:TextOut(cLinha)
  oPrinter:Bold( WIN_FW_EXTRABOLD )
  oPrinter:SetPrc( oPrinter:Prow(),oPrinter:Pcol())
  oPrinter:TextOut(transform(M_PEDVLN,"@E ###,###.##"),.t.)
  oPrinter:TextOut("",.t.)
  oPrinter:TextOut("",.t.)

*/

*  if M_IMPRE == "I"
    oPrinter:EndDoc()
    oPrinter:Destroy()
*  endif


return ""
