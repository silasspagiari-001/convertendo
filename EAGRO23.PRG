#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)

#command @ <row> , <col>  GET <var> [<clauses,...>] F2 [<moreClauses,...>] funcao <func> retorno <Variavel>;
=>       @ <row> , <col>  GET <var> [<clauses>] SEND reader := {|oGet| Getf2(oGet,<func>,<Variavel>) } [<moreClauses>]

#define FW_BOLD        700
#define FW_NORMAL      400

***************
function MANREQ
***************

parameters M_OPC,M_OPC1,M_OPC2

nREQEMP = ME_EMP

#include "ptmenu.ch"

    _FUNCLI_ = "REQUISICAO.t."
    _FUNPRO_ = "REQUISICAO.t."
    _FUNFOR_ = "REQUISICAO.t."
    _FUNCPG_ = "REQUISICAO.t."
    _FUNTRA_ = "REQUISICAO.t."
    _FUNVEN_ = "REQUISICAO.t."

    vgSituacao = ""
    lRenova    = .f.

      rodape("MENU", "REQUISICAO", M_FAN, "EAGRO23", "Mem: " + str(memory(0), 5), M_EMP)

*        @ 05, 19 prompt "Emiss„o  " HIGHLITE R/BG PERMITE 3,2,1
*        @ 06, 19 prompt "Altera‡„o" HIGHLITE R/BG PERMITE 3,2,2
*        @ 07, 19 prompt "Consulta " HIGHLITE R/BG PERMITE 3,2,3
*        @ 08, 19 prompt "Exclus„o " HIGHLITE R/BG PERMITE 3,2,4
*        @ 09, 19 prompt "Listagem " HIGHLITE R/BG PERMITE 3,2,5
*        @ 10, 19 prompt "Aluguel  " HIGHLITE R/BG PERMITE 3,2,6

      lRenova    = .f.

      do case
         case M_OPC = 1 ; increq()
         case M_OPC = 2 ; altreq("N")
         case M_OPC = 3 ; conreq(M_OPC1)
         case M_OPC = 4 ; excreq()
         case M_OPC = 5 ; lisreq(M_OPC1)
         case M_OPC = 6 ; outreq(M_OPC1)
         case M_OPC = 7 ; reereq()
      endcase

    fecha_arq()

return ""


***************
function INCREQ
***************

private M_TELA ,;
        M_OPC 

vgSituacao = "INCLUINDO"

set key -9 to CALCULA()
set key -7 to NUMREQ()
set key 275 to REEREQ()

AlteraRestauraTela("TLREQ01",.T.)

do while .t.

  rodape("EMISSAO","REQUISICAO",M_FAN,"EAGRO23","Mem: " + str(memory(0), 5),M_EMP) 

  lRenova    = .f.

  tlreq01()

  seexistesql("AREQID")
  cSql := "select first 1 gen_id(gen_AREQ00_id,0) from AREQ00"
  dbusearea(.t.,"SQLMIX",cSql,"AREQID")
  M_ID = GEN_ID
  select AREQID
  use

  M_REQNUM = M_ID+1
  M_REQSER  = AEMP00->EMPRES


  setcolor("B/W")
  @ 04, 12 say M_REQNUM picture "######"
  @ 04, 19 say M_REQSER picture "@!"

  setcolor("")


  M_REQEMP  = nREQEMP
  M_NFSFRC  = " "
  M_REQNFS  = 0
  M_REQNSE  = "  "
  M_REQDTE  = date()
  M_REQEMI  = M_LOGNOM
  M_REQCLI  = 0
  M_REQVEN  = 1
  M_REQCPG  = 0

  M_REQNATN  = "5.104"
  M_REQOBS  = "N"
  M_REQTRA  = 1

  M_REQVLP  = 0
  M_REQDSC  = 0
  M_REQVLN  = 0
  M_REQVLM  = 0
  M_REQVIC  = 0
  M_REQVLMS = 0
  M_REQVICS = 0

  M_REQIPL  = " "

  M_REQMEM = space(20)
  M_REQNOM = space(40)
  M_REQEND = space(40)
  M_REQBAI = space(15)
  M_REQMUN = pad(AEMP00->EMPMUN, 19)
  M_REQCEP = AEMP00->EMPCEP
  M_REQCCL = AEMP00->EMPCCE
  M_REQEST = AEMP00->EMPEST
  M_REQIES = pad("N/C",15)
  M_REQCGC = space(15)
  M_REQTEL = space(15)
  M_REQ800 = " "
  M_REQHS1 = space(60)
  M_REQHS2 = space(60)
  M_REQHS3 = space(60)

  M_REQDP1 = 0
  M_REQDP2 = 0
  M_REQDP3 = 0
  M_REQDP4 = 0 
  M_REQDP5 = 0
  M_REQDP6 = 0
 
  M_REQVC1 = ctod("  /  /  ")
  M_REQVC2 = ctod("  /  /  ")
  M_REQVC3 = ctod("  /  /  ")
  M_REQVC4 = ctod("  /  /  ")
  M_REQVC5 = date()
  M_REQVC6 = ctod("  /  /  ") 

  M_CLIDCC   = 2

  R         = 0

  edreq01()     

  if lastkey() = 27
    exit
  endif

  if M_REQOBS = "S"
    verreq12()
  endif

  R = 1        // sequencia
  L = 12       // linha inicial
  LNPRO  = 0
  M_LIMITE = 18

  M_REQMAT = {}
  M_REQDEL = {} // SE ALTERAR OU EXCLUIR MARCA O REGISTRO

  do while .t. 




*


*                  1   2   3   4   5   6
*                SEQ MAT QDE PRB VLI LIQ
                                            
    aadd(M_REQMAT,{0,  0,  0,  0,  0,  0,space(40),0," ",space(40),space(20),0,"N"})
    aadd(M_REQDEL,{0," "}) // SE ALTERAR OU EXCLUIR MARCA O REGISTRO 

    M_REQMAT[R,1] = R

    edreq04(L,R)

    if lastkey() = 27 
      adel(M_REQMAT,R)
      asize(M_REQMAT,len(M_REQMAT) - 1)
      exit
    endif

    BUSCAREGISTRO("APCA00",1,{str(M_REQMAT[R, 2],6,0)},"SELECT")

   if APCA00->PCAFOR = 40702 // ABBOTT
     if empty(M_REQMEM)
       alert("INFORME QUEM INDICOU")
      SetColor(_COREDICAO_)
       @ 08, 32 get M_REQMEM picture "@!"
*      @ 08, 73 get M_REQ800 picture "@!"      valid M_REQ800 $ "SN"
       read
     endif
   endif

    if L = 19
      lpreq01()
      L = 11
    endif

    R ++
    L ++

    if ++ LNPRO >=  M_LIMITE
      exit
    endif

  enddo

  if len(M_REQMAT) = 0
    aLastPaint1 := aLastPaint9
    WvtSetBlocks( aLastPaint1 )
    msg("* * * REQUISICAO NAO POSSUI ITENS * * *")
    loop
  endif

  lpreq01()

  M_TELA1 = savescreen(06, 20, 18, 60)

  declare M_VETORITE[len(M_REQMAT)]

  for R = 1 to len(M_REQMAT)
    M_VETORITE[R] = str(M_REQMAT[R, 1], 2, 0) + " " + ;
                    str(M_REQMAT[R, 2], 6, 0) + " " + ;
                    pad(M_REQMAT[R ,7], 31)   + " " + ;
                    str(M_REQMAT[R, 3], 9, 0) + " " + ;
                    str(M_REQMAT[R, 4],10, 2) + " " + ;
                    str(M_REQMAT[R, 5],10, 2) 
  next

  M_LINPOS = 0
  nPosach  = 1

    wvw_pbSetFont( ,'Visuallib', _FONTET_ -1, _FONTEL_ -1 , 0, 200)
    nbt1 := wvw_pbCreate( , 23, 5, 23, 13, "1.Total", NIL, {|| VLKeyboard( CHR( 49 )) } )
    nbt2 := wvw_pbCreate( , 23, 15, 23, 26, "2.Desconto", NIL, {|| VLKeyboard( CHR( 50 )) } )
    nbt3 := wvw_pbCreate( , 23, 28, 23, 37, "3.Apagar", NIL, {|| VLKeyboard( CHR( 51 )) } )
    nbt4 := wvw_pbCreate( , 23, 39, 23, 50, "4.Adiciona", NIL, {|| VLKeyboard( CHR( 52 )) } )
    nbt5 := wvw_pbCreate( , 23, 52, 23, 64, "5.Cabecario", NIL, {|| VLKeyboard( CHR( 53 )) } )
    nbt6 := wvw_pbCreate( , 23, 66, 23, 76, "6.Emissao", NIL, {|| VLKeyboard( CHR( 54 )) } )


* aAdd( aBlocks1, {|| wvt_DrawLabel(23 ,7,"1.Total  2.Desconto        3.Deleta  4.Adiciona  5.Insere  6.Sair",,, RGB( 0, 0,0),RGB( 222, 223,227 )  , "Visualnova", _FONTET_, , , , , .f., .f. ,.f.)})
* aAdd( aBlocks1, {|| wvt_DrawLabel(23 , 7,"1",,, RGB( 255, 0,0),RGB( 222, 223,227 )  , "Visualnova", _FONTET_, , , , , .f., .f. ,.f.)})
* aAdd( aBlocks1, {|| wvt_DrawLabel(23 ,16,"2",,, RGB( 255, 0,0),RGB( 222, 223,227 )  , "Visualnova", _FONTET_, , , , , .f., .f. ,.f.)})
* aAdd( aBlocks1, {|| wvt_DrawLabel(23 ,34,"3",,, RGB( 255, 0,0),RGB( 222, 223,227 )  , "Visualnova", _FONTET_, , , , , .f., .f. ,.f.)})
* aAdd( aBlocks1, {|| wvt_DrawLabel(23 ,44,"4",,, RGB( 255, 0,0),RGB( 222, 223,227 )  , "Visualnova", _FONTET_, , , , , .f., .f. ,.f.)})
* aAdd( aBlocks1, {|| wvt_DrawLabel(23 ,56,"5",,, RGB( 255, 0,0),RGB( 222, 223,227 )  , "Visualnova", _FONTET_, , , , , .f., .f. ,.f.)})
* aAdd( aBlocks1, {|| wvt_DrawLabel(23 ,66,"6",,, RGB( 255, 0,0),RGB( 222, 223,227 )  , "Visualnova", _FONTET_, , , , , .f., .f. ,.f.)})
* aAdd( aBlocks1, {|| Wvt_DrawBoxRaised(23, 7, 23, 13,{-3,-3,+3,+3})}) // total
* aAdd( aBlocks1, {|| Wvt_DrawBoxRaised(23, 16, 23,25,{-3,-3,+3,+3})})
* aAdd( aBlocks1, {|| Wvt_DrawBoxRaised(23, 34, 23,41,{-3,-3,+3,+3})})
* aAdd( aBlocks1, {|| Wvt_DrawBoxRaised(23, 44, 23,53,{-3,-3,+3,+3})})
* aAdd( aBlocks1, {|| Wvt_DrawBoxRaised(23, 56, 23,63,{-3,-3,+3,+3})})
* aAdd( aBlocks1, {|| Wvt_DrawBoxRaised(23, 66, 23,71,{-3,-3,+3,+3})})

  do while .t.

    nMouse := 0
    nKey := 0

    set color to N/W,W+/N
      M_OPC = achoice(12, 3,19,75,M_VETORITE,,"mosreq",nPosach)
    set color to 

    if lastkey() = 13
      altitereq() && altera item
      loop
    endif

    if lastkey() = 49
      AlteraRestauraTela("TLREQ01",.f.)
      totitereq() && total   
      AlteraRestauraTela("TLREQ01",.T.)
      loop
    endif

    if lastkey() = 50
      AlteraRestauraTela("TLREQ01",.f.)
      dscitereq() && desconto
      AlteraRestauraTela("TLREQ01",.T.)
      loop
    endif

    if lastkey() = 51
      AlteraRestauraTela("TLREQ01",.f.)
      delitereq() && deleta item
      AlteraRestauraTela("TLREQ01",.T.)
      loop
    endif


    if lastkey() = 52
      additereq() && adiciona itens 
      loop
    endif

    if lastkey() = 53
      edreq01() // AQUI
      loop
    endif

    if lastkey() = 54
      exit        && abandona operacao
    endif

  enddo

  AlteraRestauraTela("TLREQ01",.f.)
  calc_req()     && calcula total do reqido
  totitereq() && total   
  AlteraRestauraTela("TLREQ01",.T.)

  N_TELA = savescreen(11, 33, 16, 47)

  do while .t.
    M_OPC = msgbox4("Escolha uma Opcao",,,"Escolha","Imprimir","Gravar","Abandonar")
     lDesligaRedraw := .t.

     do case
          case M_OPC = 2
            emireq(.t.)
            exit
          case M_OPC = 3
            grareq(.t.)
            exit
          case M_OPC = 4
            exit
     endcase

  enddo

  wvw_pbdestroy(,nbt1)
  wvw_pbdestroy(,nbt2)
  wvw_pbdestroy(,nbt3)
  wvw_pbdestroy(,nbt4)
  wvw_pbdestroy(,nbt5)
  wvw_pbdestroy(,nbt6)


  lDesligaRedraw := .f.

  
enddo

AlteraRestauraTela("TLREQ01",.F.)

restscreen(02, 04, 21, 77, M_TELA)

return ""

******************
function ALTITEREQ  && altera item da nota
******************

  edreq04(12 + M_LINPOS,M_OPC)

 BUSCAREGISTRO("APCA00",1,{str(M_REQMAT[M_OPC, 2], 6)},"SELECT")

 if APCA00->PCAFOR = 40702 // ABBOTT
   if empty(M_REQMEM)
     msgbox1("INFORME QUEM INDICOU")
     SetColor(_COREDICAO_)
     @ 08, 32 get M_REQMEM picture "@!"
     read
   endif
 endif


  LNPRO = 0

  for S = 1 to len(M_REQMAT)
    M_VETORITE[S] = str(M_REQMAT[S, 1], 2, 0) + " " + ;
                    str(M_REQMAT[S, 2], 6, 0) + " " + ;
                    pad(M_REQMAT[S ,7], 31)   + " " + ;
                    str(M_REQMAT[S, 3], 9, 0) + " " + ;
                    str(M_REQMAT[S, 4],10, 2) + " " + ;
                    str(M_REQMAT[S, 5],10, 2)
  next

  M_LINPOS = 0

return ""

******************
function INSITEREQ && insere item na nota
******************

private R,S

  LNPRO = 0

  for A = 1 to len(M_REQMAT)
    if ++ LNPRO >=  M_LIMITE
      msg("* * * EXCEDIDO O NUMERO DE ITENS * * *")
      return ""
    endif
  next

  aadd(M_REQMAT,{0,  0,  0,  0,  0,  0,space(40),0,"N",space(40),space(20),0,"N"})

  R = len(M_REQMAT)

  M_MATANT = aclone(M_REQMAT)

  acopy(M_MATANT,M_REQMAT,R,1,M_OPC)

  if M_OPC-1 = 1
    acopy(M_MATANT,M_REQMAT,M_OPC-1,M_OPC-1,1)
  endif

  acopy(M_MATANT,M_REQMAT,M_OPC,R-M_OPC,M_OPC+1)

  M_REQMAT[M_OPC, 1] = R                 && SEQ

  for S = 1 to len(M_REQMAT) 
    M_REQMAT[S,1] = S
  next

  msreq02(M_OPC, 12 + M_LINPOS)

  edreq04(12 + M_LINPOS, M_OPC)

  asize(M_VETORITE, R)

  ains(M_VETORITE, len(M_VETORITE))

 BUSCAREGISTRO("APCA00",1,{str(M_REQMAT[M_OPC, 2],6,0)},"SELECT")

 if APCA00->PCAFOR = 40702 // ABBOTT
   if empty(M_REQMEM)
     alert("INFORME QUEM INDICOU")
      SetColor(_COREDICAO_)
     @ 08, 32 get M_REQMEM picture "@!"
     read
   endif
 endif

  LNPRO = 0

  for S = 1 to len(M_REQMAT)
    M_VETORITE[S] = str(M_REQMAT[S, 1], 2, 0) + " " + ;
                    str(M_REQMAT[S, 2], 6, 0) + " " + ;
                    pad(M_REQMAT[S ,7], 31)   + " " + ;
                    str(M_REQMAT[S, 3], 9, 0) + " " + ;
                    str(M_REQMAT[S, 4],10, 2) + " " + ;
                    str(M_REQMAT[S, 5],10, 2) 
  next

  M_LINPOS = 0

return ""

******************
function DELITEREQ && deleta item da nota
******************
local M_ESCOLHA

private M_REQ, R

 do while .t.
   M_ESCOLHA = msgbox3("Confirma Exclusao deste Item",,,"Escolha","Sim","Nao")
   if M_ESCOLHA = 2
     exit
   endif
   if M_ESCOLHA = 3
     return ""
   endif
 enddo

M_REQMAT[M_OPC][9] = "E" // excluiu
M_REQDEL[M_OPC][2] = "E" // excluiu

adel(M_REQMAT,M_OPC)
adel(M_VETORITE,M_OPC)

asize(M_REQMAT,len(M_REQMAT) - 1)
asize(M_VETORITE,len(M_VETORITE) - 1)

declare M_VETORITE[len(M_REQMAT)]

for S = 1 to len(M_REQMAT)
    M_REQMAT[S, 1]  = S
    M_VETORITE[S] = str(M_REQMAT[S, 1], 2, 0) + " " + ;
                    str(M_REQMAT[S, 2], 6, 0) + " " + ;
                    pad(M_REQMAT[S ,7], 31)   + " " + ;
                    str(M_REQMAT[S, 3], 9, 0) + " " + ;
                    str(M_REQMAT[S, 4],10, 2) + " " + ;
                    str(M_REQMAT[S, 5],10, 2)

next

lpreq01()

M_LINPOS = 0

return ""

******************
function ADDITEREQ && insere item na nota
******************

  R = len(M_REQMAT) + 1
  L = 12

  for S = 1 to len(M_REQMAT)
    if L = 19
      lpreq01()
      L = 12
    endif
    L ++
  next

  */*/*/

  if len(M_REQMAT) - (int(len(M_REQMAT)/9)*9) != 0
    msreq02((int(len(M_REQMAT)/9)*9)+1 , 12)
  endif

  do while .t.

    LNPRO = 0

    for A = 1 to len(M_REQMAT)

      if ++ LNPRO >=  M_LIMITE
        msg("* * * EXCEDIDO O NUMERO DE ITENS * * *")
        asize(M_VETORITE, R)
        ains(M_VETORITE, len(M_VETORITE))
        for S = 1 to len(M_REQMAT)
           M_VETORITE[S] = str(M_REQMAT[S, 1], 2, 0) + " " + ;
                           str(M_REQMAT[S, 2], 6, 0) + " " + ;
                           pad(M_REQMAT[S ,7], 31)   + " " + ;
                           str(M_REQMAT[S, 3], 9, 0) + " " + ;
                           str(M_REQMAT[S, 4],10, 2) + " " + ;
                           str(M_REQMAT[S, 5],10, 2) 
        next
        return ""
      endif
    next

    aadd(M_REQMAT,{0,  0,  0,  0,  0,  0,space(40),0,"N",space(40),space(20),0,"N"})

    M_REQMAT[R, 1] = R                 && SEQ

    edreq04(L,R)

    if lastkey() = 27 
      adel(M_REQMAT,R)
      asize(M_REQMAT,len(M_REQMAT) - 1)
      exit
    endif

    BUSCAREGISTRO("APCA00",1,{str(M_REQMAT[R, 2],6,0)},"SELECT")

    if APCA00->PCAFOR = 40702 // ABBOTT
      if empty(M_REQMEM)
        alert("INFORME QUEM INDICOU")
        SetColor(_COREDICAO_)
        @ 08, 32 get M_REQMEM picture "@!"
        read
      endif
    endif

    if L = 19
      lpreq01()
      L = 11
    endif

    R ++
    L ++

  enddo

  if len(M_REQMAT) = 0
    msg("* * * NOTA DE ENTRADA NAO INCLUIDA * * *")
    return ""
  endif

  lpreq01()

  asize(M_VETORITE, R)

  ains(M_VETORITE, len(M_VETORITE))

  for S = 1 to len(M_REQMAT)
    M_VETORITE[S] = str(M_REQMAT[S, 1], 2, 0) + " " + ;
                    str(M_REQMAT[S, 2], 6, 0) + " " + ;
                    pad(M_REQMAT[S ,7], 31)   + " " + ;
                    str(M_REQMAT[S, 3], 9, 0) + " " + ;
                    str(M_REQMAT[S, 4],10, 2) + " " + ;
                    str(M_REQMAT[S, 5],10, 2) 
  next

  M_LINPOS = 0

return ""

******************
function DSCITEREQ  && desconto na nota    
******************

private M_TELA

    M_TELA = savescreen(06, 19, 13, 62)

    nbox(07, 19, 11, 60,"W/W+",.t.)
    setcolor("B/W")
      @ 08, 20 say  "                                        "
      @ 09, 20 say  " Valor do Desconto :                    "
      @ 10, 20 say  "                                        "
    SetColor(_COREDICAO_)
      @ 09, 49 get M_REQDSC  picture "#######.##"
      read
    set color to
     
    msg("* * * TECLE (ENTER) * * *")

    restscreen(06, 19, 13, 62, M_TELA)

return ""

******************
function TOTITEREQ                     && mostra dados e calcula nota fiscal
******************

lOCAL aBlocks2 := {}
aLastPaint6 := WvtSetBlocks( aBlocks2 )

private  M_TELA ,;
         R

   M_REQVLP = 0
   M_REQVLN = 0
   M_REQVLM = 0
   M_REQVIC = 0
   M_REQVLMS= 0
   M_REQVICS= 0

    for R = 1 to len(M_REQMAT)            && calcula o valor bruto da nota
      M_REQVLP = M_REQVLP + M_REQMAT[R,5]
      if "ALUGUEL" $ M_REQMAT[R,7] 
        M_REQVICS = M_REQVICS + M_REQMAT[R,5]
      else
        M_REQVLMS = M_REQVLMS + M_REQMAT[R,5]
      endif
    next

    for R = 1 to len(M_REQMAT)                    && calcula o valor liquido da nota

      if M_REQDSC > 0
        M_REQMAT[R,6] = (M_REQMAT[R,5] - ((M_REQDSC/M_REQVLP) * M_REQMAT[R,5]))
      else
        M_REQMAT[R,6] = M_REQMAT[R,5]
      endif

      if "ALUGUEL" $ M_REQMAT[R,7]
        M_REQVIC = M_REQVIC + M_REQMAT[R,6]
      else
        M_REQVLM = M_REQVLM + M_REQMAT[R,6]
      endif

      M_REQVLN = M_REQVLN + M_REQMAT[R,6]

    next R

    M_TELA = savescreen(06, 20, 16, 62)

    nbox(06, 20, 11, 59,"W/W+",.t.)
    setcolor("B/W")
      @ 07, 21 say  "  Valor do Produto:                   "
      @ 08, 21 say  "  Valor do Aluguel:                   "
      @ 09, 21 say  "          Desconto:                   "
      @ 10, 21 say  "        Requisicao:                   "
    set color to N/W*
      @ 07, 41 say M_REQVICS           picture "@E ###,###,###,###.##"
      @ 08, 41 say M_REQVLMS           picture "@E ###,###,###,###.##"
      @ 09, 41 say M_REQDSC           picture "@E ###,###,###,###.##"
      @ 10, 41 say M_REQVLN           picture "@E ###,###,###,###.##"
    set color to
     
    msg("* * * TECLE (ENTER) * * *")

    WvtSetBlocks( aLastPaint6 )
    restscreen(06, 20, 16, 62, M_TELA)

return ""

*****************
function CALC_REQ                      && calcula total do reqido
*****************

private R

  M_REQVLP = 0
  M_REQVLN = 0

  for R = 1 to len(M_REQMAT)            && calcula o valor bruto da nota
    M_REQVLP = M_REQVLP + M_REQMAT[R,5]
  next

  for R = 1 to len(M_REQMAT)                    && calcula o valor liquido da nota

    if M_REQDSC > 0
      M_REQMAT[R,6] = (M_REQMAT[R,5] - ((M_REQDSC/M_REQVLP) * M_REQMAT[R,5]))
    else
      M_REQMAT[R,6] = M_REQMAT[R,5]
    endif

    M_REQVLN = M_REQVLN + M_REQMAT[R,6]

  next R

return ""

***************
function ALTREQ(F_TIPO)
***************

LOCAL aBlocks1 := {}

  aAdd( aBlocks1, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
  aAdd( aBlocks1, {|| Wvt_DRAWBOXRECESSED( 03, 02, 20, 76) } )
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 11, 76,{+15,,-15,})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 20, 5 ,{+15,,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 06, 20, 12,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 13, 20, 44,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 45, 20, 54,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 55, 20, 65,{+15,-10,,-10})})


private M_TELA ,;
        M_OPC 

vgSituacao = "ALTERANDO"

lPaint = .t.

do while .t.

  M_REQMAT = {}
  M_REQDEL = {} // SE ALTERAR OU EXCLUIR MARCA O REGISTRO

  rodape("ALTERA","REQUISICAO",M_FAN,"EAGRO23","Mem: " + str(memory(0), 5),M_EMP) 

  tlreq01()
  if lPaint
    aLastPaint1 := WvtSetBlocks( aBlocks1 )
    lPaint = .f.
  endif

  M_REQEMP  = nREQEMP
  M_REQNUM  = 0
  M_REQSER  = AEMP00->EMPRES

  SetColor(_COREDICAO_)
  @ 04, 12 get M_REQNUM picture "######"
  @ 04, 19 get M_REQSER picture "@!"
  read

  if M_REQNUM = 0 .or. lastkey() = 27
    exit
  endif

  if !BUSCAREGISTRO("AREQ00",1,{str(M_REQEMP, 2, 0),str(M_REQNUM, 6, 0),aspas(M_REQSER)},"SELECT")
    msg("* * * REQUISICAO NAO INCLUIDA * * *")
    loop
  endif

  if F_TIPO $ "RE" // renovacao ou encerramento tem que ser aluguel
    if !REQFRC == "S" 
       msg("* * * REQUISICAO NAO E' DE ALUGUEL * * *")
       loop
    endif
  endif

  msreq01()

  M_REQNFS  = REQNFS
  M_REQNSE  = REQNSE
  M_REQDTE  = REQDTE
  M_NFSFRC  = REQFRC
  M_REQCLI  = REQCLI
  M_REQVEN  = REQVEN
  M_REQCPG  = REQCPG
  M_REQEMI  = REQEMI
  M_REQNATN = REQNATN
  M_REQTRA  = REQTRA
  M_REQMEM  = left(REQMEM,20)
  M_REQ800  = REQFRC
  M_REQOBS  = REQOBS

  M_REQVLP  = REQVLP
  M_REQDSC  = REQDSC
  M_REQVLN  = 0
  M_REQIPL  = REQIPL
  M_REQVLM  = 0
  M_REQVIC  = 0
  M_REQVLMS = 0
  M_REQVICS = 0

  R         = 0

  M_REQNOM = REQNOM
  M_REQEND = REQEND
  M_REQBAI = REQBAI
  M_REQMUN = REQMUN
  M_REQCEP = REQCEP
  M_REQCCL = REQCCL
  M_REQEST = REQEST
  M_REQIES = REQIES
  M_REQCGC = REQCGC
  M_REQTEL = space(15)
  M_REQHS1 = REQHS1
  M_REQHS2 = REQHS2
  M_REQHS3 = REQHS3

  M_REQDP1 = 0
  M_REQDP2 = 0
  M_REQDP3 = 0
  M_REQDP4 = 0 
  M_REQDP5 = 0
  M_REQDP6 = 0
 
  M_REQVC1 = ctod("  /  /  ")
  M_REQVC2 = ctod("  /  /  ")
  M_REQVC3 = ctod("  /  /  ")
  M_REQVC4 = ctod("  /  /  ")
  M_REQVC5 = iif(HB_ISNIL(REQVC5),ctod("  /  /  "),REQVC5)
  M_REQVC6 = iif(HB_ISNIL(REQVC6),ctod("  /  /  "),REQVC6)

  M_CLIDCC   = 2

  edreq02(F_TIPO)

  if lastkey() = 27
    exit
  endif

  if M_REQOBS = "S"
    verreq12()
  endif

  LNPRO  = 0
  M_LIMITE = 18

  R = 1        // sequencia
  L = 12       // linha inicial

    BUSCAREGISTRO("AREQ01",1,{str(M_REQEMP, 2, 0),str(M_REQNUM, 6, 0),aspas(M_REQSER)},"SELECT")
    if eof()
      msg("* * * REQUISICAO NAO POSSUE ITENS * * *")
      loop
    endif

    M_VETORITE = {}

    R = 1

    do while !eof()

      BUSCAREGISTRO("APCA00",1,{str(AREQ01->REQMAT,6,0)},"SELECT")
      select AREQ01

      aadd(M_REQMAT,{0,  0,  0,  0,  0,  0,space(40),0,"J",space(40),space(20),0," "})
      aadd(M_REQDEL,{recno," "}) // SE ALTERAR OU EXCLUIR MARCA O REGISTRO

      M_REQMAT[R,  1] = R
      M_REQMAT[R,  2] = REQMAT
      M_REQMAT[R,  3] = REQQDE
      M_REQMAT[R,  4] = REQPRB
      M_REQMAT[R,  5] = REQVLI
      M_REQMAT[R,  6] = REQLIQ
      M_REQMAT[R,  7] = APCA00->PCADES
      M_REQMAT[R, 10] = PACIENTE
      M_REQMAT[R, 11] = INDICADO
      M_REQMAT[R, 12] = recno
      M_REQMAT[R, 13] = SN0800

      aadd(M_VETORITE,str(M_REQMAT[R, 1], 2, 0) + " " + ;
                    str(M_REQMAT[R, 2], 6, 0) + " " + ;
                    pad(M_REQMAT[R ,7], 31)   + " " + ;
                    str(M_REQMAT[R, 3], 9, 0) + " " + ;
                    str(M_REQMAT[R, 4],10, 2) + " " + ;
                    str(M_REQMAT[R, 5],10, 2))
      skip

      R = R + 1

    enddo

  lpreq01()

  M_TELA1 = savescreen(06, 20, 18, 60)


  for R = 1 to len(M_REQMAT)

  next

  M_LINPOS = 0
  nPosach  = 1

  do while .t.

    set color to GR+
      @ 21, 10 say "        1.Total  2.Desconto  3.Deleta  4.Adiciona  5.Insere  6.Sair"
    set color to R+
      @ 21, 21-3 say "1"
      @ 21, 30-3 say "2"
      @ 21, 42-3 say "3"
      @ 21, 52-3 say "4"
      @ 21, 64-3 say "5"
      @ 21, 74-3 say "6"
    set color to N/W,W+/N
      M_OPC = achoice(12, 3,19,75,M_VETORITE,,"mosreq",nPosach)
    set color to 

    if lastkey() = 13
      altitereq() && altera item
      loop
    endif

    if lastkey() = 49
      totitereq() && total   
      loop
    endif

    if lastkey() = 50
      dscitereq() && desconto
      loop
    endif

    if lastkey() = 51
      delitereq() && deleta item 
      loop
    endif

    if lastkey() = 52
      additereq() && adiciona itens 
      loop
    endif

    if lastkey() = 53
      insitereq() && insere item
      loop
    endif

    if lastkey() = 54
      exit        && abandona operacao
    endif

  enddo

  totitereq() && total   

  M_OPC = msgbox3("Escolha uma Opcao",,,"Imprimir","Gravar","Abandonar")

  do case
     case M_OPC = 1
         emireq(.f.)
         exit
     case M_OPC = 2
         grareq(.f.)
         exit
     case M_OPC = 3 .or. lastkey() = 27
         M_OPZ = deciden("Tem Certeza que Quer Abandonar Requisicao")
         if M_OPZ == 1
           exit
         endif
  endcase

enddo

WvtSetBlocks( aLastPaint1 )
restscreen(02, 04, 21, 77, M_TELA)

return ""

***************
function CONREQ
***************
parameters M_OPC,M_OPC1,M_OPC2
*        @ 11, 25 prompt "Requisi‡„o" HIGHLITE R/BG
*        @ 12, 25 prompt "Cliente   " HIGHLITE R/BG

      do case
         case M_OPC = 1 ; conreq_a()
         case M_OPC = 2 ; conreq_b()
      endcase             

return ""

*****************
function CONREQ_A(F_TIPO)
*****************
LOCAL aBlocks1 := {}

  aAdd( aBlocks1, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
  aAdd( aBlocks1, {|| Wvt_DRAWBOXRECESSED( 03, 02, 20, 76) } )
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 11, 76,{+15,,-15,})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 20, 5 ,{+15,,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 06, 20, 12,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 13, 20, 44,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 45, 20, 54,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 55, 20, 65,{+15,-10,,-10})})

  lPaint = .t.

if F_TIPO = NIL
  F_TIPO = "N"
endif

  do while .t.

    rodape("CONSULTA", "REQUISICAO", M_FAN, "EAGRO23","Mem: " + str(memory(0), 5), M_EMP)

    tlreq01()
    if lPaint
      aLastPaint1 := WvtSetBlocks( aBlocks1 )
      lPaint = .f.
    endif
    
    M_REQEMP  = nREQEMP
    M_REQNUM  = 0
    M_REQSER  = AEMP00->EMPRES

    SetColor(_COREDICAO_)
    @ 04, 12 get M_REQNUM picture "######"
    @ 04, 19 get M_REQSER picture "@!"
    read

    if M_REQNUM = 0
      exit
    endif

    if !BUSCAREGISTRO("AREQ00",1,{str(M_REQEMP, 2, 0),str(M_REQNUM, 6, 0),aspas(M_REQSER)},"SELECT")
      msg("* * * REQUISICAO NAO INCLUIDA * * *")
      loop
    endif

    if F_TIPO == "E"
      if !AREQ00->REQFRC == "S"
        msg("ESTA REQUISICAO NAO E' DE ALUGUEL")
        loop
      endif
    endif

    msreq01()

    BUSCAREGISTRO("AREQ01",1,{str(M_REQEMP, 2, 0),str(M_REQNUM, 6, 0),aspas(M_REQSER)},"SELECT")
    if eof()
      msg("* * * REQUISICAO NAO POSSUE ITENS * * *")
      loop
    endif

    M_VETORITE = {}

    R = 1

    do while !eof()
      BUSCAREGISTRO("APCA00",1,{str(AREQ01->REQMAT,6,0)},"SELECT")
      select AREQ01

      aadd(M_VETORITE,str(REQSEQ, 2, 0) + " " + ;
                      str(REQMAT, 6, 0) + " " + ;
                      pad(APCA00->PCADES, 31)   + " " + ;
                      str(REQQDE, 9, 3) + " " + ;
                      str(REQPRB,10, 3) + " " + ;
                      str(REQVLI,10, 2) + " ")
      skip

      R = R + 1

    enddo

    M_LINPOS = 0

    do while .t.

      set color to N/W,W+/N
        M_OPC = achoice(12, 3,19,75,M_VETORITE,,"mostec")
      set color to 

      if lastkey() = 13
        msreq04()
        loop
      endif

      if lastkey() = 27
        exit        && abandona operacao
      endif

    enddo

    if F_TIPO == "E" 
      if AREQ00->REQFRC == "N"
        msg("ESTE ALUGUEL JA FOI ENCERRADO")
      else
        do while .t.
          M_ESCOLHA = msgbox3("Confirma Encerramento deste aluguel",,,"Escolha","Sim","Nao")
          if M_ESCOLHA = 2
            sqlCAMPO = {}
            sqlCHAVE =  {}
            sqlARQUI = {"AREQ00","UPDATE"}
            aadd(sqlCHAVE,{"REQEMP",str(M_REQEMP,2)})
            aadd(sqlCHAVE,{"REQNUM",str(M_REQNUM,6)})
            aadd(sqlCHAVE,{"REQSER",aspas(M_REQSER)})
            aadd(sqlCAMPO,{"REQFRC","N",.t.})
            executasql()
            msg("* * * ALUGUEL ENCERRADO * * *")
            exit
          endif
          if M_ESCOLHA = 3
            exit
          endif
        enddo
      endif
    endif
  enddo

WvtSetBlocks( aLastPaint1 )

return ""

***************
function MOSTEC
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
function CONREQ_B
*****************

LOCAL aBlocks3 := {}

  aAdd( aBlocks3, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
  aAdd( aBlocks3, {|| Wvt_DRAWBOXRECESSED( 03, 04, 21, 76) } )
  aAdd( aBlocks3, {|| WVT_DRAWBOXGROUP( 06, 04, 08, 76,{+15,,-15,})})
  aAdd( aBlocks3, {|| WVT_DRAWBOXGROUP( 08, 04, 17, 76,{+12,,-15,})})

  aAdd( aBlocks3, {|| WVT_DRAWBOXGROUP( 06, 04, 17, 13 ,{+15,,-15,-10})})
  aAdd( aBlocks3, {|| WVT_DRAWBOXGROUP( 06, 14, 17, 20 ,{+15,-10,-15,-10})})
  aAdd( aBlocks3, {|| WVT_DRAWBOXGROUP( 06, 21, 17, 23 ,{+15,-10,-15,-10})})
  aAdd( aBlocks3, {|| WVT_DRAWBOXGROUP( 06, 24, 17, 27 ,{+15,-10,-15,-10})})
  aAdd( aBlocks3, {|| WVT_DRAWBOXGROUP( 06, 28, 17, 31 ,{+15,-10,-15,-10})})
  aAdd( aBlocks3, {|| WVT_DRAWBOXGROUP( 06, 32, 17, 35 ,{+15,-10,-15,-10})})
  aAdd( aBlocks3, {|| WVT_DRAWBOXGROUP( 06, 36, 17, 47 ,{+15,-10,-15,-10})})
  aAdd( aBlocks3, {|| WVT_DRAWBOXGROUP( 06, 48, 17, 54 ,{+15,-10,-15,-10})})
  aAdd( aBlocks3, {|| WVT_DRAWBOXGROUP( 06, 55, 17, 61 ,{+15,-10,-15,-10})})
  aAdd( aBlocks3, {|| WVT_DRAWBOXGROUP( 06, 62, 17, 64 ,{+15,-10,-15,-10})})
* aAdd( aBlocks3, {|| WVT_DRAWBOXGROUP( 05, 21, 16, 23 ,{+15,-10,-15,-10})})


* aAdd( aBlocks3, {|| WVT_DRAWBOXGROUP( 09, 06, 20, 12,{+15,-10,,-10})})
* aAdd( aBlocks3, {|| WVT_DRAWBOXGROUP( 09, 13, 20, 44,{+15,-10,,-10})})
* aAdd( aBlocks3, {|| WVT_DRAWBOXGROUP( 09, 45, 20, 54,{+15,-10,,-10})})
* aAdd( aBlocks3, {|| WVT_DRAWBOXGROUP( 09, 55, 20, 65,{+15,-10,,-10})})

  aLastPaint3 := WvtSetBlocks( aBlocks3 )


private MT_ITENS ,;
        MT_NUMPE ,;
        MT_OBSE1 ,;
        MT_OBSE2 ,;
        MT_OBSE3 ,;
        M_TECLA  ,;
        M_TELA

  do while .t.

    rodape("CONSULTA", "REQUISICAO", M_FAN, "EAGRO23","Mem: " + str(memory(0), 5), M_EMP)

    tlreq02()

    M_REQEMP  = nREQEMP
    M_REQCLI  = 0
    M_TECLA   = 0
    M_PERINI  = ctod("01/01/90") 
    M_PERFIN  = date()

  SetColor(_COREDICAO_)
    @ 04, 15 get M_REQCLI picture "#######"  F2 color _CORF2_ funcao "sele_arquivo('ACLI00')" retorno @M_REQCLI
    @ 05, 15 get M_PERINI
    @ 05, 26 get M_PERFIN
    read

    if lastkey() = 27
      exit
    endif

    if !BUSCAREGISTRO("ACLI00",1,{str(M_REQCLI,7,0)},"SELECT")
      msg("* * * CLIENTE NAO CADASTRADO * * *")
      loop
    endif

    set color to I
      @ 04, 30 say pad(ACLI00->CLINOM, 28)
      @ 04, 64 say pad(ACLI00->CLIMUN2, 12)
    set color to 

*    if !BUSCAREGISTRO("AREQ00",1,{str(M_REQEMP, 2, 0),str(M_REQNUM, 6, 0),aspas(M_REQSER)},"SELECT")

    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"AREQ00","AREQ00"})
    aadd(sqlCAMPO,"AREQ00.*")
    aadd(sqlCAMPO,"AVEN00.VENNOM")
    aadd(sqlRELATION,{"AVEN00","AVEN00.VENCOD","AREQ00.REQVEN"})
    aadd(sqlCHAVE,"REQEMP = " + str(M_REQEMP,2))
    aadd(sqlCHAVE,"REQCLI = " + str(M_REQCLI,7))
    aadd(sqlCHAVE,"AREQ00.REQDTE BETWEEN " + aspas(formatdta(M_PERINI)) + " and " + aspas(formatdta(M_PERFIN)))
    aadd(sqlORDEM,"REQDTE desc, REQNUM")
    if !sqlrelation()
      msg("* * * NADA A CONSULTAR NESTE CLIENTE * * *")
      loop
    endif

    L = 8

    MT_ITENS = { }
    MT_NUMPE = { }
    MT_OBSE1 = { }
    MT_OBSE2 = { }
    MT_OBSE3 = { }

    do while !eof()
      aadd(MT_ITENS,dtoc(REQDTE)  + " " +  str(REQNUM, 6, 0) + " " + REQSER + " " + str(REQCPG, 3, 0) + " " + str(REQTRA, 3, 0) + " " + str(REQVEN, 3, 0) + " " + pad(VENNOM, 11) + " " + pad(REQNATN, 6) + " " + str(REQNFS, 6, 0) + " " + REQSER +  " " + transform(REQVLN,"@E ####,###.##"))
      aadd(MT_NUMPE,{str(REQEMP, 2, 0),str(REQNUM, 6, 0),REQSER})
      aadd(MT_OBSE1,REQHS1)
      aadd(MT_OBSE2,REQHS2)
      aadd(MT_OBSE3,REQHS3)
      skip
    enddo

    if len(MT_ITENS) > 0
      visualreb(MT_ITENS,MT_NUMPE,MT_OBSE1,MT_OBSE2,MT_OBSE3)
    endif

    setcursor(1)

  enddo

WvtSetBlocks( aLastPaint3 )

return ""

******************
function VISUALREB
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

  do while .t.

    set color to N/W,W+/N
      M_OPC = achoice(09,05,16,75,V1,,"mosvpb")
    set color to 

*    if rat(str(lastkey(), 2, 0)," 3#27#18") > 0
*      exit
*    endif
  
    if rat(str(lastkey(), 2, 0),"#27") > 0
      exit
    endif
  
    if rat(str(lastkey(), 2, 0),"13#") > 0
      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {"AREQ00","SELECT"}
      aadd(sqlCHAVE,{"REQEMP",V2[M_OPC][1]})
      aadd(sqlCHAVE,{"REQNUM",V2[M_OPC][2]})
      aadd(sqlCHAVE,{"REQSER",aspas(V2[M_OPC][3])})
      executasql()

      sqlRELATION = {}
      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {}
      sqlORDEM = {}

      aadd(sqlARQUI,{"AREQ01","AREQ01"})
      aadd(sqlCAMPO,"AREQ01.*")
      aadd(sqlCAMPO,"APCA00.PCADES")
      aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","AREQ01.REQMAT"})
      aadd(sqlCHAVE,"REQEMP = " + V2[M_OPC][1])
      aadd(sqlCHAVE,"REQNUM = " + V2[M_OPC][2])
      aadd(sqlCHAVE,"REQSER = " + aspas(V2[M_OPC][3]))
      sqlrelation()
      mosdatreq() && mostra dados tecnicos
      loop
    endif

    exit

  enddo

  select &M_AREA

return lastkey()

***************
function MOSVPB
***************

parameters  M_MODO, M_ELEM, M_POSI

* if rat(str(lastkey(), 2, 0)," 3#27#18") > 0
*    return 0
* endif

 if rat(str(lastkey(), 2, 0),"#27") > 0
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
function MOSDATREQ
******************

LOCAL aBlocks1 := {}

parameters F_CHAVE

  aAdd( aBlocks1, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
  aAdd( aBlocks1, {|| Wvt_DRAWBOXRECESSED( 03, 02, 20, 76) } )
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 11, 76,{+15,,-15,})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 20, 5 ,{+15,,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 06, 20, 12,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 13, 20, 44,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 45, 20, 54,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 55, 20, 65,{+15,-10,,-10})})

  aLastPaint1 := WvtSetBlocks( aBlocks1 )


private M_TELA, R, L, M_OPC , M_VERTORITE


  M_TELA = savescreen(01, 01, 21, 77)

  tlreq01() 

  select AREQ00
  msreq01()

  select AREQ01
  go top
  
  M_VETORITE = { }

  do while !eof()

      aadd(M_VETORITE, str(REQSEQ, 2, 0) + " " + ;
                      str(REQMAT, 6, 0) + " " + ;
                      pad(PCADES, 31)   + " " + ;
                      str(REQQDE, 9, 3) + " " + ;
                      str(REQPRB,10, 3) + " " + ;
                      str(REQVLI,10, 2) + " ")
  
    skip

  enddo

  M_LINPOS = 0

  do while .t.

    set color to N/W,W+/N
      M_OPC = achoice(12, 3,19,75,M_VETORITE,,"mostec")
    set color to 

    if lastkey() = 27
      exit        && abandona operacao
    endif

  enddo

  WvtSetBlocks( aLastPaint1 )
  restscreen(01, 01, 21, 77, M_TELA)

return ""

***************
function EXCREQ   
***************


LOCAL aBlocks1 := {}

  aAdd( aBlocks1, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
  aAdd( aBlocks1, {|| Wvt_DRAWBOXRECESSED( 03, 02, 20, 76) } )
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 11, 76,{+15,,-15,})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 20, 5 ,{+15,,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 06, 20, 12,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 13, 20, 44,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 45, 20, 54,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 55, 20, 65,{+15,-10,,-10})})

private M_OPC

lPaint = .t.

  do while .t.

    rodape("EXCLUI", "REQUISICAO", M_FAN, "EAGRO23","Mem: " + str(memory(0), 5), M_EMP)

    tlreq01()

    if lPaint
      aLastPaint1 := WvtSetBlocks( aBlocks1 )
      lPaint = .f.
    endif

    M_REQEMP  = nREQEMP
    M_REQNUM  = 0
    M_REQSER  = AEMP00->EMPRES

  SetColor(_COREDICAO_)
    @ 04, 12 get M_REQNUM picture "######"
    @ 04, 19 get M_REQSER picture "@!"
    read

    if M_REQNUM = 0
      exit
    endif

    if !BUSCAREGISTRO("AREQ00",1,{str(M_REQEMP, 2, 0),str(M_REQNUM, 6, 0),aspas(M_REQSER)},"SELECT")
      msg("* * * REQUISICAO NAO INCLUIDA * * *")
      loop
    endif

    M_REQCLI = REQCLI

    msreq01()
    BUSCAREGISTRO("AREQ01",1,{str(M_REQEMP, 2, 0),str(M_REQNUM, 6, 0),aspas(M_REQSER)},"SELECT")

    M_VETORITE = {}

    R = 1

    do while !eof()
      BUSCAREGISTRO("APCA00",1,{str(AREQ01->REQMAT,6,0)},"SELECT")
      select AREQ01

      aadd(M_VETORITE,str(REQSEQ, 2, 0) + " " + ;
                      str(REQMAT, 6, 0) + " " + ;
                      pad(APCA00->PCADES, 31)   + " " + ;
                      str(REQQDE, 9, 3) + " " + ;
                      str(REQPRB,10, 3) + " " + ;
                      str(REQVLI,10, 2) + " ")
      skip

      R = R + 1

    enddo

    M_LINPOS = 0

    do while .t.

      set color to N/W,W+/N
        M_OPC = achoice(12, 3,19,75,M_VETORITE,,"mostec")
      set color to

      if lastkey() = 27
        exit        && abandona operacao
      endif

    enddo

    M_OPC = 2
    M_OPC = confirma("deste Or‡amento")

    if M_OPC != 1
      msg("* * * REQUISICAO NAO EXCLUIDO * * *")
      loop  
    endif

    grreq01("DELETE")
    ret_itensrq()                 && retira kardex duplicatas
    grreq02("DELETE")

    msg("* * * REQUISICAO EXCLUIDO * * *")

  enddo
  
  WvtSetBlocks( aLastPaint1 )

return ""

***************
function LISREQ
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("LISTA","REQUISICAO",M_FAN,"EAGRO23","Mem: " + str(memory(0), 5),M_EMP) 

*        @ 08, 24 prompt      "Listagem Requisicoes  " HIGHLITE R/BG
*        @ 09, 24 prompt      "Relacao por Produto   " HIGHLITE R/BG
*        @ 10, 24 prompt      "Analitica Requisicao  " HIGHLITE R/BG
*        @ 11, 24 prompt      "Sintetica Requisicao  " HIGHLITE R/BG
*        @ 12, 24 prompt      "Relacao por Cliente   " HIGHLITE R/BG
*        @ 13, 24 prompt      "Analitico por Vendedor" HIGHLITE R/BG
*        @ 14, 24 prompt      "Analitico por Cliente " HIGHLITE R/BG
*        @ 15, 24 prompt      "Resumo de Vendas      " HIGHLITE R/BG
*        @ 16, 24 prompt      "Mapa resumido Indicado" HIGHLITE R/BG

        do case
           case M_OPC = 1  ; lisreq_a()
           case M_OPC = 2  ; lisreq_b()
           case M_OPC = 3  ; lisreq_c()
           case M_OPC = 4  ; lisreq_n()
           case M_OPC = 5  ; lisreq_e()
           case M_OPC = 6  ; lisreq_f()
           case M_OPC = 7  ; lisreq_g()
           case M_OPC = 8  ; lisreq_h()
           case M_OPC = 9  ; mapares("I")
        endcase


return ""

*****************
function LISREQ_A
***************** 

private M_REQ1 ,;
        M_REQ2 ,;
        M_SER1 ,;
        M_SER2 ,;
        LN     ,;
        PG     ,;
        M_ESC  ,;
        M_TELA
 
    do while .t.

        rodape("LISTA","REQUISICAO",M_FAN,"EAGRO23","Mem: " + str(memory(0), 5),M_EMP) 

        store 0         to M_REQ1 ,;
                           M_REQ2

        store AEMP00->EMPRES to M_SER1 ,;
                                M_SER2

        store date()           to M_DTA1 ,;
                                  M_DTA2 

        store "3"              to M_REQIPL

       sombra(12, 41, 18, 73,_SOMBRA_)

       set color to B/W
         @ 12, 41 say                  "                                     " 
         @ 13, 41 say                  "   Nro Or‡amento Inicial:            " 
         @ 14, 41 say                  "                   Final:            " 
         @ 15, 41 say                  "    Data Emissao Inicial:            " 
         @ 16, 41 say                  "                   Final:            " 
         @ 17, 41 say                  " 1.Todas  2.Fat  3.A fat:            " 
         @ 18, 41 say                  "                                     " 
      SetColor(_COREDICAO_)
         @ 13, 67 get M_REQ1 picture "######"
         @ 13, 74 get M_SER1 picture "@!"
         @ 14, 67 get M_REQ2 picture "######"
         @ 14, 74 get M_SER2 picture "@!"
         @ 15, 67 get M_DTA1
         @ 16, 67 get M_DTA2
         @ 17, 67 get M_REQIPL valid(M_REQIPL $ "123")
         read
       set color to

        if lastkey() = 27
          return ""
        endif

        M_REQ1 = iif(M_REQ1 = 0,     1,M_REQ1)
        M_REQ2 = iif(M_REQ2 = 0,999999,M_REQ2) 

        M_DTA1 = iif(dtoc(M_DTA1) = "  /  /  ",ctod("01/01/80"),M_DTA1)
        M_DTA2 = iif(dtoc(M_DTA2) = "  /  /  ",ctod("31/12/79"),M_DTA2) 

        select AREQ00

        set relation to REQNATN into AFIS00 ,;
                     to str(REQCLI, 7, 0)                     into ACLI00

        set order to 1

        set softseek on
          seek str(nREQEMP, 2, 0) + str(M_REQ1, 6, 0) + M_SER1
        set softseek off
       
        if eof()  .or. REQEMP != nREQEMP
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          loop
        endif

        M_IMPRE = imprelaser()

        if M_IMPRE = "N"
          return ""
        endif

        ?? chr(15)                        && comprime

       store 0 to PG ,;
                  LN

       cab_req1()                           && imprime cabecalho

       do while !eof()

          if str(REQEMP, 2, 0) + str(REQNUM, 6, 0) + REQSER > str(nREQEMP, 2, 0) + str(M_REQ2, 6, 0) + M_SER2
            go bottom
            skip
            loop
          endif

          if !M_REQIPL == "1"
            if M_REQIPL = "2"
              if REQNFS = 0
                skip
                loop
              endif
            else
              if M_REQIPL = "3"
                if REQNFS > 0
                  skip
                  loop
                endif
              endif
            endif
          endif

          if REQDTE < M_DTA1 .or. REQDTE > M_DTA2
             skip
             loop
          endif

          cab_req2()

           ? str(REQNUM, 6, 0)
            ?? "  "
            ?? REQSER
            ?? " "
            ?? REQNATN
            ?? "  "
            ?? pad(AFIS00->FISNOM, 27) 
            ?? " " 
            ?? REQDTE
            ?? " "
            ?? str(REQCLI, 7, 0)
            ?? " "
            ?? left(ACLI00->CLINOM, 32)
            ?? " " 
            ?? str(REQVEN, 3, 0)
            ?? " "
            ?? space(08)
            ?? "  "
            ?? transform(REQVLN,"@E ###,###,###.##") 
            ?? "  "
            ?? REQIPL
 
            LN = LN + 1

            if LN > 60
              cab_req1()
              cab_req2()
            endif  

            select AREQ01

            set softseek on
              seek str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER + "  " 
            set softseek off                                                                

         cab_req3()

         do while !eof() 

            if !str(REQEMP, 2, 0) + str(REQNUM, 6, 0) + REQSER == str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER
               exit
            endif

             select APCA00
        
             seek str(AREQ01->REQMAT, 6, 0)

             select AREQ01 

             ? "   " 
              ?? str(REQSEQ, 2, 0)
              ?? "     " 
              ?? transform(str(REQMAT, 6, 0),"@R 9999999")
              ?? "            " 
              ?? APCA00->PCAREF 
              ?? "   " 
              ?? APCA00->PCADES
              ?? "       "
              ?? str(REQQDE, 9, 3)
              ?? "  "
              ?? " "
              ?? " "
              ?? transform(REQPRB,"@E ###,###,###.##") 
              ?? "  "
              ?? transform(REQVLI,"@E ###,###,###.##") 
                         
              LN = LN + 1

              if LN > 60 
                cab_req1()
                cab_req3()
              endif
  
              skip 

         enddo

         select AREQ00

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

       ? replicate("=", 132)

       eject

desliga1(80)

enddo 

return "" 

*****************
function CAB_REQ1
*****************

 PG = PG + 1

 if PG > 1
   eject
 endif

 ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE REQUISICOES","EAGRO23",132) 
 ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)

 LN = 2

return ""

*****************
function CAB_REQ2
*****************

 ? replicate("-",132)  
 ? "DOCTO   SE CODFIS                 EMISSAO  CLIENTE                                        PRODUTOS       ALUGUEIS        TOTAL"

 LN = LN + 2

return ""

*****************
function CAB_REQ3
*****************

  ?
  ? "   SEQ    CODIGO             REFERENCIA   DESCRICAO                                      QUANTIDADE S   VLR UNITARIO    VALOR  TOTAL" 

  LN = LN + 2

return ""

*****************
function LISREQ_B                      && relacao de vendas por produtos
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
    
if file("AREQ02.CDX")               
  erase("AREQ02.CDX")               
endif

select 13         && req temporario

use AREQ02 alias AREQ02 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

    rodape("REQUISICAO","PRODUTO",M_FAN,"EAGRO23","Mem: " + str(memory(0), 5),M_EMP)


    store date() to M_DATA1 ,;
                    M_DATA2

    store "S"    to M_TIPO

     sombra(13, 41, 17, 67,_SOMBRA_)
     set color to B/W
       @ 13, 41 say                    "                           " 
       @ 14, 41 say                    " Periodo Inicial:          " 
       @ 15, 41 say                    "           Final:          " 
       @ 16, 41 say                    "     Ent/Sai/Tra:          " 
       @ 17, 41 say                    "                           " 
  SetColor(_COREDICAO_)
     @ 14, 59 get     M_DATA1
     @ 15, 59 get     M_DATA2
     @ 16, 59 get     M_TIPO valid(M_TIPO $ "EST")
     read

     if lastkey() = 27
        return ""
     endif

     store 0 to M_TOTGER

     select AREQ02

     if !flock()
       msg("* * * (AREQ02) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(REQEMP, 2, 0) + str(REQMAT, 6, 0)  tag 1 to AREQ02
     index on str(REQEMP, 2, 0) + str(REQVLN, 14, 2) tag 2 to AREQ02

     set index to AREQ02 
  
     select AREQ00

     set relation to REQNATN into AFIS00

     go top

        set order to 2 
         
        set softseek on
          seek str(nREQEMP, 2, 0) + dtos(M_DATA1)
        set softseek off

        if str(REQEMP, 2, 0) + dtos(REQDTE) > str(nREQEMP, 2, 0) + dtos(M_DATA2) .or. str(REQEMP, 2, 0) + dtos(REQDTE) < str(nREQEMP, 2, 0) + dtos(M_DATA1)
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          return ""
        endif
                
        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(REQEMP, 2, 0) + dtos(REQDTE) > str(nREQEMP, 2, 0) + dtos(M_DATA2)
            exit
          endif 
           
          if REQCPG > 2 
            if REQCPG <= 20
              skip
              loop
            endif
          endif       
  
          if M_TIPO = "S"
            if !REQNATN $ "5.000#6.000"
              skip
              loop
            endif
          endif

          if M_TIPO = "E"
            if !REQNATN $ "1.102#2.102"
              skip
              loop
            endif
          endif

          if M_TIPO = "T"
            if !REQNATN $ "5.152"
              skip
              loop
            endif
          endif

          select AREQ01

          set softseek on
            seek str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER
          set softseek off

          do while !eof()

            if str(AREQ01->REQEMP, 2, 0) + str(AREQ01->REQNUM, 6, 0) + AREQ01->REQSER > str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER
              exit
            endif

            select AREQ02
     
            seek str(AREQ01->REQEMP, 2, 0) + str(AREQ01->REQMAT, 6, 0)

            if eof()
              append blank         
              replace REQEMP with AREQ01->REQEMP
              replace REQMAT with AREQ01->REQMAT
            endif

            replace REQQDE with REQQDE + AREQ01->REQQDE

            if strzero(AREQ00->REQCPG, 3) $ "000#001#002"
              replace REQVIS with REQVIS + AREQ01->REQLIQ
              replace REQVLN with REQVLN + AREQ01->REQLIQ
            endif            

            if AREQ00->REQCPG > 20
              replace REQPRZ with REQPRZ + AREQ01->REQLIQ
              replace REQVLN with REQVLN + AREQ01->REQLIQ
            endif            

            M_TOTGER = M_TOTGER + AREQ01->REQLIQ

            select AREQ01

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
 
          select AREQ00
 
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
          
        select AREQ02

        set relation to str(REQMAT, 6, 0) into APCA00

        set order to 2

        go bottom
                 
        do while !bof()
                              
            store PG + 1 to  PG 

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO DE " + iif(M_TIPO="S","VENDA",iif(M_TIPO="T","TRANSFERENCIA","COMPRA")) + " POR PRODUTOS","EAGRO23",132) 
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
            
              ? " " 
               ?? transform(str(REQMAT, 6, 0),"@R 9999999")
               ?? " "
               ?? left(APCA00->PCADES , 35)
               ?? "      "
               ?? str(REQQDE, 9, 3)
               ?? " "
               ?? transform(REQVIS,"@E@Z ###,###,###,###.##")
               ?? " " 
               ?? transform(REQPRZ,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(REQVLN,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(((REQVLN/M_TOTGER) * 100),"###.##")
               ?? " "
      
               M_SOMPER = M_SOMPER + ((REQVLN/M_TOTGER) * 100)
              
               ?? transform(M_SOMPER,"####.##")

            LN = LN + 1
                                
            M_TOTVIS = M_TOTVIS + REQVIS
            M_TOTPRZ = M_TOTPRZ + REQPRZ

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

    unlock all

desliga1()

return ""

*****************
function LISREQ_C                      && analitica requisicao
*****************

private M_OPC ,;
        M_TELA
                   
    do while .t.

      rodape("LISTA","ANALITICA",M_FAN,"EAGRO23","Mem: " + str(memory(0), 5),M_EMP) 

       M_CLIINI = 0
       M_CLIFIN = 0
       M_CLIDTI = date()
       M_CLIDTF = date()
       M_CLITIP = "A"

       sombra(11, 32, 18, 60,_SOMBRA_)
       set color to B/W
         @ 12, 32 say         "                             " 
         @ 13, 32 say         "   Cliente Inicial:          " 
         @ 14, 32 say         "             Final:          " 
         @ 15, 32 say         "   Periodo Inicial:          " 
         @ 16, 32 say         "             Final:          " 
         @ 17, 32 say         " (G)eral (A)grupar:          " 
         @ 18, 32 say         "                             " 

  SetColor(_COREDICAO_)
        @ 13, 52 get M_CLIINI picture "#######"
        @ 14, 52 get M_CLIFIN picture "#######"
        @ 15, 52 get M_CLIDTI
        @ 16, 52 get M_CLIDTF
        @ 17, 52 get M_CLITIP picture "@!" valid(M_CLITIP $ "AG")
        read

        M_CLIINI = iif(M_CLIINI = 0,      1,M_CLIINI)
        M_CLIFIN = iif(M_CLIFIN = 0,9999999,M_CLIFIN) 

        if lastkey() = 27
          exit
        endif

        select AREQ00

        set relation to str(REQCLI, 7, 0) into ACLI00 

        ( dbsetorder(5) , dbseek(str(nREQEMP, 2, 0) + str(M_CLIINI, 7, 0) + dtos(M_CLIDTI),.t.) )

        if str(REQEMP, 2, 0) + str(REQCLI, 7, 0) + dtos(REQDTE) > str(nREQEMP, 2, 0) + str(M_CLIFIN, 7, 0) + dtos(M_CLIDTF)
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

        store 0 to PG,LN   ,;
                   M_CLIANT,;
                   M_TOTPRE,;
                   M_TOTCLI,;
                   M_GERCLI
 
          cab_req1()

          do while !eof() .and. LN < 60

            if str(REQEMP, 2, 0) + str(REQCLI, 7, 0) > str(nREQEMP, 2, 0) + str(M_CLIFIN, 7, 0)
              go bottom
              skip
              loop
            endif 
           
            if REQDTE > M_CLIDTF .or. REQDTE < M_CLIDTI
               skip
               loop
            endif 

            if M_CLITIP = "A"
              if REQNFS > 0
                skip
                loop
              endif
            endif

            if REQCLI != M_CLIANT 
              if M_TOTCLI > 0
                ? space(90)
                  ?? "TOTAL DO CLIENTE ....      " 
                  ?? transform(M_TOTCLI,"@E ###,###,###.##")
                ? replicate("-",132)
                M_TOTCLI = 0
                LN = LN + 2
                if LN > 56
                  cab_req1() 
                endif
              endif
              ? " "
               ?? str(REQCLI, 7, 0) 
               ?? " "
               ?? ACLI00->CLINOM
               ?? " "
               ?? pad(ACLI00->CLIMUN3, 13)
               ?? " "
               ?? ACLI00->CLIUF3
               ?? " "
               ?? ACLI00->CLITEL3
               M_CLIANT = REQCLI
               LN = LN + 1
               if LN > 56
                 cab_req1() 
               endif
            endif

            ? "--------------------------------------------------------------------------------"
            ? space(62)
              ?? "   *** REQUISICAO -=>"
              ?? str(REQNUM, 6, 0)
              ?? " "
              ?? REQSER
              ?? " "
              ?? REQDTE
              ?? " "
              ?? str(REQVEN, 3, 0)
              ?? " "
              ?? transform(REQVLN,"@E ###,###,###.##")
              ?? " "
              ?? "   " 
              ?? " "
              ?? str(REQNFS, 6, 0)

              LN = LN + 2

              if LN > 56
                cab_req1() 
              endif

            ? "                                PRODUTO REFERENCIA UN DESCRICAO                                      QTDE     UNITARIO        TOTAL"
              *                                99999-9 XXXXXXXXXX XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ###,###.## #.###,###.## #,###,###.##

            LN = LN + 1

            if LN > 56
              cab_req1() 
            endif

            select AREQ01

            dbseek(str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER,.t.)

            do while !eof()

              if !str(REQEMP, 2, 0) + str(REQNUM, 6, 0) + REQSER == str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER
                exit
              endif

              APCA00->(dbseek(str(AREQ01->REQMAT, 6, 0)))

              ? space(32)
                ?? str(REQMAT, 7, 0)
                ?? " "
                ?? space(10)
                ?? " "
                ?? pad(APCA00->PCAUNI, 2)
                ?? " "
                ?? pad(APCA00->PCADES, 40)
                ?? " "
                ?? transform(REQQDE,"@E ###,###.##")
                ?? " "
                ?? transform(REQPRB,"@E #,###,###.##")
                ?? " "
                ?? transform(REQLIQ,"@E #,###,###.##")

                LN = LN + 1

                if LN > 56
                  cab_req1() 
                endif
          
                skip

             enddo 

            select AREQ00

            M_TOTCLI = M_TOTCLI + REQVLN
            M_GERCLI = M_GERCLI + REQVLN

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

    ? space(90)
     ?? "TOTAL DO CLIENTE ....      " 
     ?? transform(M_TOTCLI,"@E ###,###,###.##")
    ? space(90)
     ?? "TOTAL GERAL .........      " 
     ?? transform(M_GERCLI,"@E ###,###,###.##")
    ? replicate("=", 132)

    eject

desliga1()

  enddo 

return ""

*****************
function LISREQ_D                      && sintetica requisicao 
*****************

private M_OPC ,;
        M_TELA
             
if file("AREQ02.CDX")      
  erase("AREQ02.CDX")      
endif

    select 13         && pre temporario

    use AREQ02 alias AREQ02 exclusive

    if neterr()
      msg("* * ARQUIVO NAO DISPONIVEL * * *")
      clear
      clear all
      quit
    endif

    do while .t.

      rodape("LISTA","ANALITICA",M_FAN,"EAGRO23","Mem: " + str(memory(0), 5),M_EMP) 

       M_CLIINI = 0
       M_CLIFIN = 0
       M_CLIDTI = date()
       M_CLIDTF = date()
       M_REQIPL = "3" 

       sombra(12, 32, 18, 60,_SOMBRA_)
       set color to B/W
         @ 12, 32 say         "                             " 
         @ 13, 32 say         "   Cliente Inicial:          " 
         @ 14, 32 say         "             Final:          " 
         @ 15, 32 say         "   Periodo Inicial:          " 
         @ 16, 32 say         "             Final:          " 
         @ 17, 32 say         " 1.Tod 2.Fat 3.A f:          " 
         @ 18, 32 say         "                             " 
    SetColor(_COREDICAO_)
        @ 13, 52 get M_CLIINI picture "#######"
        @ 14, 52 get M_CLIFIN picture "#######"
        @ 15, 52 get M_CLIDTI
        @ 16, 52 get M_CLIDTF
        @ 17, 52 get M_REQIPL picture "@!" valid(M_REQIPL $ "123")
        read

        M_CLIINI = iif(M_CLIINI = 0,      1,M_CLIINI)
        M_CLIFIN = iif(M_CLIFIN = 0,9999999,M_CLIFIN)

        if lastkey() = 27
          exit
        endif

        select AREQ02

        if !flock()
          msg("* * * (AREQ02) ARQUIVO NAO DISPONIVEL * * *")
          exit
        endif

        zap

        index on str(REQEMP, 2, 0) + str(REQCLI, 7, 0) + str(REQMAT, 6, 0) tag 1 to AREQ02

        set index to AREQ02     

        select AREQ00

        ( dbsetorder(5) , dbseek(str(nREQEMP, 2, 0) + str(M_CLIINI, 7, 0) + dtos(M_CLIDTI),.t.) )

        if str(REQEMP, 2, 0) + str(REQCLI, 7, 0) + dtos(REQDTE) > str(nREQEMP, 2, 0) + str(M_CLIFIN, 7, 0) + dtos(M_CLIDTF)
          msg( "* * * NADA A SER PROCESSADO NO INTERVALO * * *")
          loop
        endif

        msw("* * * AGUARDE ... PROCESSANDO !!!! * * *")

        do while !eof()

          if str(REQEMP, 2, 0) + str(REQCLI, 7, 0) > str(nREQEMP, 2, 0) + str(M_CLIFIN, 7, 0)
            exit
          endif 
           
          if REQDTE < M_CLIDTI .or. REQDTE > M_CLIDTF
            skip
            loop
          endif

          if !M_REQIPL == "3"
            if M_REQIPL == "2"
              if !REQNATN == "5.104"
                skip 
                loop
              endif
            else
              if !REQNATN == "6.000"
                skip 
                loop
              endif
            endif 
          endif

          select AREQ01

          dbseek(str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER,.t.)

          do while !eof()

            if !str(REQEMP, 2, 0) + str(REQNUM, 6, 0) + REQSER == str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER
              exit
            endif

            select AREQ02
     
            seek str(AREQ01->REQEMP, 2, 0) + str(AREQ00->REQCLI, 7, 0) + str(AREQ01->REQMAT, 6, 0)

            if eof()
              append blank         
              replace REQEMP with AREQ01->REQEMP
              replace REQCLI with AREQ00->REQCLI
              replace REQMAT with AREQ01->REQMAT
            endif

            replace REQQDE with REQQDE + AREQ01->REQQDE
            replace REQVLI with REQVLI + AREQ01->REQLIQ

            select AREQ01

            skip
 
          enddo
 
          select AREQ00

          skip

        enddo

        select AREQ02

        set relation to str(REQCLI, 7, 0) into ACLI00 ,;
                        str(REQMAT, 6, 0) into APCA00

        dbseek(str(nREQEMP, 2, 0) + str(M_CLIINI, 7, 0),.t.)

        if str(REQEMP, 2, 0) + str(REQCLI, 7, 0) > str(nREQEMP, 2, 0) + str(M_CLIFIN, 7, 0)
          msg( "* * * NADA A LISTAR NO INTERVALO * * *")
          loop
        endif

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          exit
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        store 0 to PG      ,;
                   M_CLIANT,;
                   M_TOTPRE

        do while !eof()

          store PG + 1 to PG

          if PG > 1
            eject
          endif

          ? cent_cab(AEMP00->EMPFAN,"RELACAO SINTETICA REQUISICAO","EAGRO23",132) 
          ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
          ? "*------------------------------*-------*----------*--*----------------------------------------*----------*------------*------------*"
          ? "*       CLIENTE                *PRODUTO*REFERENCIA*UN* DESCRICAO                              *   QTDE   *  UNITARIO  *    TOTAL   *"
          ? "*------------------------------*-------*----------*--*----------------------------------------*----------*------------*------------*"

*                                            99999-9 XXXXXXXXXX XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ######,### #.###.###,## #.###.###,##

          store 5 to LN

          do while !eof() .and. LN < 60

            if str(REQEMP, 2, 0) + str(REQCLI, 7, 0) > str(nREQEMP, 2, 0) + str(M_CLIFIN, 7, 0)
              go bottom
              skip
              loop
            endif 

            if REQCLI != M_CLIANT 
              if M_TOTPRE > 0
                ? space(90)
                  ?? "TOTAL DO CLIENTE ....      " 
                  ?? transform(M_TOTPRE,"@E ###,###,###.##")
                ? replicate("-",132)
                M_TOTPRE = 0
                LN = LN + 2
              endif
              ? " "
               ?? str(REQCLI, 7, 0) 
               ?? " "
               ?? ACLI00->CLINOM
               ?? " "
               ?? ACLI00->CLIMUN3
               ?? " "
               ?? ACLI00->CLIUF3
               ?? " "
               ?? ACLI00->CLITEL3
               M_CLIANT = REQCLI
               LN = LN + 1
            endif

            ? space(32)
              ?? str(REQMAT, 7, 0)
              ?? " "
              ?? pad(APCA00->PCAREF, 10)
              ?? " "
              ?? pad(APCA00->PCAUNI, 2)
              ?? " "
              ?? pad(APCA00->PCADES, 40)
              ?? " "
              ?? transform(REQQDE,"@E ###,###.##")
              ?? " "
              ?? transform(REQVLI/REQQDE,"@E #,###,###.##")
              ?? " "
              ?? transform(REQVLI,"@E #,###,###.##")
  
            store LN + 1 to LN

            M_TOTPRE = M_TOTPRE + REQVLI

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

    ? space(90)
     ?? "TOTAL DO CLIENTE ....      " 
     ?? transform(M_TOTPRE,"@E ###,###,###.##")
    ? replicate("-", 132)

    eject

desliga1()

  enddo 

  select 13

  use

return ""

******************
function CAB_REL_B
******************

  PG = PG + 1

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"RELACAO DE " + iif(M_TIPO="S","VENDA",iif(M_TIPO="T","TRANSFERENCIA","COMPRA")) + " NO PERIODO","EAGRO23",132) 
  ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
  ? "*------*--*---------*------------------------------------*--------*--------------------------*-*--------*----------*---------------*"
  ? "*REQIDO*SR* CLIENTE *   NOME                             *EMISSAO *  V E N C I M E N T O S   *T*ESPECIE * PRODUTOS *     VALOR     *"
  ? "*------*--*---------*------------------------------------*--------*--------------------------*-*--------*----------*---------------*"
*     999999 99 999999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99 99/99/99 99/99/99 X XXXXXXXX ###,###.## ####,###,###.##    

  store 5 to LN

return ""

*****************
function LISREQ_E
*****************

private M_TOTAL ,;
        M_DATA1 ,;
        M_DATA2 ,;
        M_TELA  ,;
        M_TIPO  ,;
        M_ESC   ,;
        PG, LN  


if file("ACLI01.CDX")
  erase("ACLI01.CDX")
endif

select 13        && resumo

use ACLI01 alias ACLI01 exclusive

if neterr()
  msg("* * * (ACLI01) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

rodape("RELACAO","CLIENTE",M_FAN,"EAGRO23","Mem: " + str(memory(0), 5),M_EMP) 

    store date() to M_DATA1 ,;
                    M_DATA2

    store "S"    to M_TIPO

     sombra(13, 41, 17, 67,_SOMBRA_)
     set color to B/W
       @ 13, 41 say                    "                           " 
       @ 14, 41 say                    " Periodo Inicial:          " 
       @ 15, 41 say                    "           Final:          " 
       @ 16, 41 say                    "     Ent/Sai/Tra:          " 
       @ 17, 41 say                    "                           " 
  SetColor(_COREDICAO_)

     @ 14, 59 get     M_DATA1
     @ 15, 59 get     M_DATA2
     @ 16, 59 get     M_TIPO valid(M_TIPO $ "EST")
     read

     if lastkey() = 27
        return ""
     endif

     select ACLI01

     if !flock()
       msg("* * * (ACLI01) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(CLICOD, 7, 0)            tag 1 to ACLI01
     index on str(CLITOT, 14, 2)           tag 2 to ACLI01

     set index to ACLI01 

     select AREQ00

     set order to 3 
         
     set softseek on
       seek str(nREQEMP, 2, 0) + dtos(M_DATA1)
     set softseek off

        if str(REQEMP, 2, 0) + dtos(REQDTE) > str(nREQEMP, 2, 0) + dtos(M_DATA2) .or. str(REQEMP, 2, 0) + dtos(REQDTE) < str(nREQEMP, 2, 0) + dtos(M_DATA1)
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          return ""
        endif

        store 0 to M_CLITOT

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(REQEMP, 2, 0) + dtos(REQDTE) > str(nREQEMP, 2, 0) + dtos(M_DATA2)
            go bottom
            skip
            loop
          endif 

          if M_TIPO = "S"
            if !REQNATN $ "5.000#6.000"
              skip
              loop
            endif
          endif

          if M_TIPO = "E"
            if !REQNATN $ "1.102#2.102"
              skip
              loop
            endif
          endif

          if M_TIPO = "T"
            if !REQNATN $ "5.150"
              skip
              loop
            endif
          endif

          if REQCPG > 3 .and. REQCPG <= 20
            skip
            loop
          endif

          select ACLI01

          seek str(AREQ00->REQCLI, 7, 0)

            if eof()
              append blank
              replace CLICOD with AREQ00->REQCLI
            endif
   
            if AREQ00->REQCPG < 3
               replace CLIVIS with CLIVIS + AREQ00->REQVLN
               replace CLITOT with CLITOT + AREQ00->REQVLN
               M_CLITOT = M_CLITOT        + AREQ00->REQVLN
            else
              if AREQ00->REQCPG > 20
                replace CLIPRZ with CLIPRZ + AREQ00->REQVLN
                replace CLITOT with CLITOT + AREQ00->REQVLN
                M_CLITOT = M_CLITOT        + AREQ00->REQVLN
              endif
            endif

            select AREQ00

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

        select ACLI01

        set order to 2

        set relation to str(CLICOD, 7, 0) into ACLI00

        go bottom
                
        M_IMPRE = impresn()

        if M_IMPRE = "N"
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

            ? cent_cab(AEMP00->EMPFAN,"RELACAO DE " + iif(M_TIPO="S","VENDA",iif(M_TIPO="T","TRANSFERENCIA","COMPRA")) + " POR CLIENTE/FORNECEDOR","EAGRO23",132) 
              ? cent_cab(M_DATA,"REQIODO: " + dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
              ? "*---------*------------------------------*---------------*--*------------------*------------------*------------------*------*------*"
              ? "* CLIENTE *     DESCRICAO                *   MUNICIPIO   *UF*     A VISTA      *    A PRAZO       *      TOTAL       *% SFAT* REGUA*"
              ? "*---------*------------------------------*---------------*--*------------------*------------------*------------------*------*------*"
*                     99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XX ###,###,###,###.## ###,###,###,###.## ###,###,###,###.## ###.## ###.##

            store 5 to LN
  
            do while !bof() .and. LN < 60

                  ? "     "
                   ?? str(CLICOD, 7, 0)
                   ?? " "
                   ?? left(ACLI00->CLINOM, 30)
                   ?? " "
                   ?? left(ACLI00->CLIMUN1, 15) 
                   ?? " "
                   ?? ACLI00->CLIUF1
                   ?? " "
                   ?? transform(CLIVIS,"@E@Z ###,###,###,###.##")
                   ?? " "
                   ?? transform(CLIPRZ,"@E@Z ###,###,###,###.##")
                   ?? " "
                   ?? transform((CLIVIS + CLIPRZ),"@E@Z ###,###,###,###.##")
                   ?? " "
                   ?? transform(((CLITOT/M_CLITOT) * 100),"###.##")
                   ?? " "
                   M_SOMPER = M_SOMPER + ((CLITOT/M_CLITOT) * 100)
                   ?? transform(M_SOMPER,"###.##")

                M_TOTVIS = M_TOTVIS + CLIVIS
                M_TOTPRZ = M_TOTPRZ + CLIPRZ

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
return ""

*****************
function LISREQ_F                      && relacao de analitica por vendedor
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
        M_TELA 

if file("AREQ05.CDX")
  erase("AREQ05.CDX")
endif

select 13        && nfs temporario

use AREQ05 alias AREQ05 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif


    rodape("ANALITICO","VENDEDOR",M_FAN,"EAGRO23","Mem: " + str(memory(0), 5),M_EMP) 

    store date() to M_DATA1 ,;
                    M_DATA2

    store "S"    to M_TIPO

     sombra(13, 41, 17, 67,_SOMBRA_)
     set color to B/W
       @ 13, 41 say                    "                           " 
       @ 14, 41 say                    " Periodo Inicial:          " 
       @ 15, 41 say                    "           Final:          " 
       @ 16, 41 say                    "     Ent/Sai/Tra:          " 
       @ 17, 41 say                    "                           " 
  SetColor(_COREDICAO_)
     @ 14, 59 get     M_DATA1
     @ 15, 59 get     M_DATA2
     @ 16, 59 get     M_TIPO valid(M_TIPO $ "EST")
     read

     if lastkey() = 27
        return ""
     endif

     store 0 to M_TOTGER

     select AREQ05

     if !flock()
       msg("* * * (AREQ05) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(REQEMP, 2, 0) + str(REQVEN, 3, 0) + str(REQMAT, 6, 0)  tag 1 to AREQ05
     index on str(REQEMP, 2, 0) + str(REQVEN, 3, 0) + str(REQVLN, 14, 2) tag 2 to AREQ05

     set index to AREQ05 
  
     select AREQ00

     set relation to REQNATN into AFIS00 ,;
                  to str(REQVEN, 3, 0) into AVEN00

     go top

        set order to 2 
         
        set softseek on
          seek str(nREQEMP, 2, 0) + dtos(M_DATA1)
        set softseek off

        if str(REQEMP, 2, 0) + dtos(REQDTE) > str(nREQEMP, 2, 0) + dtos(M_DATA2) .or. str(REQEMP, 2, 0) + dtos(REQDTE) < str(nREQEMP, 2, 0) + dtos(M_DATA1)
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          return ""
        endif
                
        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(REQEMP, 2, 0) + dtos(REQDTE) > str(nREQEMP, 2, 0) + dtos(M_DATA2)
            exit
          endif 
           
          if REQCPG > 2 
            if REQCPG <= 20
              skip
              loop
            endif
          endif       

          select AREQ01

          set softseek on
            seek str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER
          set softseek off

          do while !eof()

            if str(AREQ01->REQEMP, 2, 0) + str(AREQ01->REQNUM, 6, 0) + AREQ01->REQSER > str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER
              exit
            endif

            select AREQ05
     
            seek str(AREQ01->REQEMP, 2, 0) + str(AVEN00->VENCOD, 3, 0) + str(AREQ01->REQMAT, 6, 0)

            if eof()
              append blank         
              replace REQEMP with AREQ01->REQEMP
              replace REQVEN with AVEN00->VENCOD
              replace REQMAT with AREQ01->REQMAT

            endif

            replace REQQDE with REQQDE + AREQ01->REQQDE

            if AREQ00->REQCPG = 1 .or. AREQ00->REQCPG = 2
              replace REQVIS with REQVIS + AREQ01->REQLIQ
              replace REQVLN with REQVLN + AREQ01->REQLIQ
            endif            

            if AREQ00->REQCPG > 20
              replace REQPRZ with REQPRZ + AREQ01->REQLIQ
              replace REQVLN with REQVLN + AREQ01->REQLIQ
            endif            

            M_TOTGER = M_TOTGER + AREQ01->REQLIQ

            select AREQ01

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
 
          select AREQ00
 
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
          
        select AREQ05

        set relation to str(REQMAT, 6, 0) into APCA00 ,;
                     to str(REQVEN, 3, 0) into AVEN00

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

             if REQVEN != M_VENANT
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
                 M_VENANT = REQVEN
                 M_VENVIS = 0
                 M_VENPRZ = 0
                ? "***** VENDEDOR: "
                 ?? str(REQVEN, 3, 0)
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
               ?? transform(str(REQMAT, 6, 0),"@R 9999999")
               ?? " "
               ?? left(APCA00->PCADES , 35)
               ?? "      "
               ?? str(REQQDE, 9, 3)
               ?? " "
               ?? transform(REQVIS,"@E@Z ###,###,###,###.##")
               ?? " " 
               ?? transform(REQPRZ,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(REQVLN,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(((REQVLN/M_TOTGER) * 100),"###.##")
               ?? " "
      
               M_SOMPER = M_SOMPER + ((REQVLN/M_TOTGER) * 100)
              
               ?? transform(M_SOMPER,"####.##")

            LN = LN + 1
                                
            M_VENVIS = M_VENVIS + REQVIS
            M_VENPRZ = M_VENPRZ + REQPRZ
            M_TOTVIS = M_TOTVIS + REQVIS
            M_TOTPRZ = M_TOTPRZ + REQPRZ

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

return ""

*****************
function LISREQ_G                      && relacao de analitica por vendedor
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
        M_TELA 

select 22         && nfs temporario

M_IND = ""
M_INDA = ""
M_INDB = ""
acha_livre()

    rodape("ANALITICO","CLIENTE",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP)

    store date() to M_DATA1 ,;
                    M_DATA2


    store 0      to M_DUPCLI,;
                    M_REQCLI,;
                    M_CODINI,;
                    M_CODFIN

     sombra(14, 35, 17, 72,_SOMBRA_)
     set color to B/W
       @ 14, 35 say   "                                      " 
       @ 15, 35 say   " Periodo Inicial:          a          " 
       @ 16, 35 say   "         Cliente:          a          " 
       @ 17, 35 say   "                                      " 
  SetColor(_COREDICAO_)

     @ 15, 53 get     M_DATA1
     @ 15, 64 get     M_DATA2
     @ 16, 53 get     M_REQCLI picture "#######"
     @ 16, 64 get     M_CODFIN picture "#######"
     read

     M_CODINI = iif(M_REQCLI = 0,      1, M_REQCLI)
     M_CODFIN = iif(M_CODFIN = 0,9999999, M_CODFIN)

     if lastkey() = 27
       return ""
     endif

     store 0 to M_TOTGER

     select ANFS02

     if !flock()
       msg("* * * (ANFS02) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(NFSEMP, 2, 0) + str(NFSCLI, 7, 0) + str(NFSMAT, 6, 0)  tag 1 to &M_IND
     index on str(NFSEMP, 2, 0) + str(NFSCLI, 7, 0) + str(NFSVLN, 14, 2) tag 2 to &M_IND
     index on str(NFSEMP, 2, 0) + str(NFSCLI, 7, 0) + NFSDES             tag 3 to &M_IND

     set index to &M_IND 
  
     select AREQ00

     set relation to REQNATN into AFIS00 ,;
                  to str(REQCLI, 7, 0) into ACLI00

     go top

        set order to 2 
         
        dbseek(str(nREQEMP, 2, 0) + dtos(M_DATA1),.t.)

        if str(REQEMP, 2, 0) + dtos(REQDTE) > str(nREQEMP, 2, 0) + dtos(M_DATA2)
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          return ""
        endif
                
        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(REQEMP, 2, 0) + dtos(REQDTE) > str(nREQEMP, 2, 0) + dtos(M_DATA2)
            exit
          endif 

          if REQCLI < M_CODINI .or. REQCLI > M_CODFIN 
            skip
            loop
          endif
   
          if REQCPG > 2 
            if REQCPG <= 20
              skip
              loop
            endif
          endif       
  
          select AREQ01

          dbseek(str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER,.t.)

          do while !eof()

            if str(AREQ01->REQEMP, 2, 0) + str(AREQ01->REQNUM, 6, 0) + AREQ01->REQSER > str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER
              exit
            endif

            select ANFS02
     
            seek str(AREQ01->REQEMP, 2, 0) + str(ACLI00->CLICOD, 7, 0) + str(AREQ01->REQMAT, 6, 0)

            if eof()
              append blank         
              replace NFSEMP with AREQ01->REQEMP
              replace NFSCLI with ACLI00->CLICOD
              replace NFSMAT with AREQ01->REQMAT
              APCA00->(dbseek(str(AREQ01->REQMAT, 6, 0)))
              replace NFSDES with APCA00->PCADES
            endif

            replace NFSQDE with NFSQDE + AREQ01->REQQDE
            replace NFSULC with AREQ00->REQDTE
            replace NFSVLI with AREQ01->REQLIQ
            replace NFSUQT with AREQ01->REQQDE
            replace NFSNUM with AREQ00->REQNUM
            replace NFSSER with AREQ00->REQSER

            if AREQ00->REQCPG = 1 .or. AREQ00->REQCPG = 2
              replace NFSVIS with NFSVIS + AREQ01->REQLIQ
              replace NFSVLN with NFSVLN + AREQ01->REQLIQ
            endif            

            if AREQ00->REQCPG > 20
              replace NFSPRZ with NFSPRZ + AREQ01->REQLIQ
              replace NFSVLN with NFSVLN + AREQ01->REQLIQ
            endif            

            M_TOTGER = M_TOTGER + AREQ01->REQLIQ

            select AREQ01

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                return ""
              endif
            endif

            skip
 
          enddo
 
          select AREQ00
 
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
                    M_CLIVIS ,;
                    M_CLIPRZ ,;
                    M_SOMPER ,;
                    M_CLIANT
          
        select ANFS02

        set relation  to str(NFSCLI, 7, 0) into ACLI00

        set order to 3

        go top
                 
        do while !eof()
                              
            PG++

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO ANALITICA POR CLIENTE","EAGRO23",132) 
            ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
            ? "*-------*----------------------------------------*------*--*--------*--------*-----------*--------*-----------------*------*-------*"
            ? "* PROD  *        DESCRICAO DO PRODUTO            * REQ  *SE*   DTE  *ULT QDE * ULT PRECO *QT TOTAL*  TOTAL VENDIDO  *% SFAT* REGUA *"
            ? "*-------*----------------------------------------*------*--*--------*--------*-----------*--------*-----------------*------*-------*"
*               99999.9 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 XX 99/99/99 99999.99 ####,###.## 99999.99 ##,###,###,###.## ###,## ###,###

            store 5 to LN
  
            do while !eof() 
               
              if LN > 60
                exit
              endif 

             if NFSCLI != M_CLIANT
                if (M_CLIVIS + M_CLIPRZ) > 0
                  ? space(02) 
                    ?? "TOTAL GERAL . . . . . . . . .       VISTA: "
                    ?? transform(M_TOTVIS,"@E ###,###,###.##")
                    ?? "         PRAZO: "
                    ?? transform(M_TOTPRZ,"@E ###,###,###.##")
                    ?? "      TOTAL: "
                    ?? transform((M_TOTVIS + M_TOTPRZ),"@E ###,###,###.##")
                  ? replicate("-", 132)
                  LN = LN + 2
                 endif
                 M_CLIANT = NFSCLI
                 M_CLIVIS = 0
                 M_CLIPRZ = 0
                ? "***** CLIENTE: "
                 ?? str(NFSCLI, 7, 0)
                 ?? " "
                 ?? ACLI00->CLINOM
                 ?? " "
                 ?? ACLI00->CLIMUN3
                 ?? " "
                 ?? ACLI00->CLIUF3 
                 ?? " "
                 ?? ACLI00->CLITEL3
                 ?? "  *****"
                 ?
                 LN = LN + 2
              endif       

              APCA00->(dbseek(str(ANFS02->NFSMAT, 6, 0)))

              ? " " 
               ?? transform(str(NFSMAT, 6, 0),"@R 99999-9")
               ?? " "
               ?? pad(APCA00->PCADES, 40)
               ?? " "
               ?? str(NFSNUM, 6, 0)
               ?? " "
               ?? NFSSER
               ?? " "
               ?? NFSULC
               ?? " "
               ?? str(NFSUQT, 8, 0)
               ?? " " 
               ?? transform(NFSVLI/NFSUQT,"@E@Z ####,###.##")
               ?? " " 
               ?? str(NFSQDE, 8, 0)
               ?? " "
               ?? transform(NFSVLN,"@E@Z ##,###,###,###.##")
               ?? " "
               ?? transform(((NFSVLN/M_TOTGER) * 100),"###.##")
               ?? " "
      
               M_SOMPER = M_SOMPER + ((NFSVLN/M_TOTGER) * 100)
              
               ?? transform(M_SOMPER,"####.##")

            LN++
                                
            M_CLIVIS = M_CLIVIS + NFSVIS
            M_CLIPRZ = M_CLIPRZ + NFSPRZ
            M_TOTVIS = M_TOTVIS + NFSVIS
            M_TOTPRZ = M_TOTPRZ + NFSPRZ

            skip 
         
            if inkey() = 27
                if susimp()
                  ? replicate("-", 132)
                  ? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                endif
            endif

          enddo

      enddo

      ? replicate("-", 132)
      ? space(02) 
        ?? "TOTAL GERAL . . . . . . . . .       VISTA: "
        ?? transform(M_TOTVIS,"@E ###,###,###.##")
        ?? "         PRAZO: "
        ?? transform(M_TOTPRZ,"@E ###,###,###.##")
        ?? "      TOTAL: "
        ?? transform((M_TOTVIS + M_TOTPRZ),"@E ###,###,###.##")

    eject

    unlock all

desliga1()

return ""

***************
function OUTREQ
***************
parameters M_OPC,M_OPC1,M_OPC2


      rodape("MENU","REQUISICAO",M_FAN,"EAGRO23","Mem: " + str(memory(0), 5),M_EMP) 
*        @ 11, 24 prompt      "Renovacao     " HIGHLITE R/BG
*        @ 12, 24 prompt      "Encerramento  " HIGHLITE R/BG
*        @ 13, 24 prompt      "Listagem      " HIGHLITE R/BG

        do case
           case M_OPC = 1
                lRenova  = .t.
                altreq("R")  // RENOVACAO
           case M_OPC = 2   
                conreq_a("E") // ENCERRAMENTO
           case M_OPC = 3   
                lisaluguel() 
        endcase

return ""

*****************
function REQ_MENS                      && numero de mensagens
*****************

  if ACLI00->CLIUF2 = "SP"
    M_IND = rat(APCA00->PCACSP,"ABCDEFGHIJKLMNOPQRSTUVWXYZ")
  else
    M_IND = rat(APCA00->PCACOU,"ABCDEFGHIJKLMNOPQRSTUVWXYZ")
  endif

  if M_IND > 0
    if M_MSG[M_IND] = 0
      M_MSG[M_IND] = 1
      L = L + 1
    endif
  endif

return ""

*****************
function CABREQ01
*****************

  store PG + 1 to PG

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"RELACAO DO AGRUPAMENTO","EAGRO23",132) 
  ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
  ? "*------*--*--------*-----*-----*-------*----------*--*----------------------------------------*----------*------------*------------*"
  ? "*PEDIDO*SE*EMISSAO * CLI *     *PRODUTO*REFERENCIA*UN* DESCRICAO                              *   QTDE   *  UNITARIO  *    TOTAL   *"
  ? "*------*--*--------*-----*-----*-------*----------*--*----------------------------------------*----------*------------*------------*"

*                                          99999-9 XXXXXXXXXX XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ######,### #.###.###,## #.###.###,##

  store 5 to LN

return ""

****************
function TLREQ01    
****************

nbox(03, 02, 20, 76,"W/W+",.t.)
setcolor("B/W")
    @ 04, 03 say     "Num_Req:           Nom:                                                  "
    @ 05, 03 say     "DcSaida:           End:                                          Ven:    "
    @ 06, 03 say     "Emissao:           Bai:                 Mun:                             "
    @ 07, 03 say     "CodOper:           Cep:      -          Est:                     Obs:    "
    @ 08, 03 say     "Cliente:                                                                 "
    @ 09, 03 say     "                                                                         "
    @ 10, 03 say     "Sq C¢digo         Descri‡„o                 Qtde     Unit rio    Total   "
    @ 11, 03 say     "                                                                         "
    for zz = 12 to 19
    @ zz, 03 say     "                                                                         "
    next

set color to 

return ""

****************
function TLREQ02
****************

nbox(03, 04, 21, 76,"W/W+",.t.)
setcolor("B/W")
    @ 04, 05 say     "Cliente :          Nome:                              Mun:             "
    @ 05, 05 say     "Periodo :          a                                                   "
    @ 06, 05 say     "                                                                       "
    @ 07, 05 say     "  Data   NumOrc Se Cpg Tra Ven Nome         Ope    Nfs   Se   Total    "
    @ 08, 05 say     "                                                                       "
    for zz = 9 to 16
    @ zz, 05 say     "                                                                       "
    next
    @ 17, 05 say     "                                                                       "
    @ 18, 05 say     "" + space(71) + ""
    @ 19, 05 say     "" + space(71) + ""
    @ 20, 05 say     "" + space(71) + ""
set color to

return ""

****************
function EDREQ01
****************

*verreq05()

*/*/*/

// VERREQ03

  setcolor("N/W*")
    @ 06, 12 say M_REQDTE //                  valid !empty(M_REQDTE)
  SetColor(_COREDICAO_)
*  @ 07, 12 get M_REQNATN picture "9.999"  valid verreq05()
  @ 08, 12 get M_REQCLI picture "#######" F2 color _CORF2_ valid verreq01() funcao "sele_arquivo('ACLI00')" retorno @M_REQCLI
* @ 04, 73 get M_REQCPG picture "###"     F2 color _CORF2_ valid verreq04() funcao "sele_arquivo('ACPG00')" retorno @M_REQCPG
  @ 05, 73 get M_REQVEN picture "###"     F2 color _CORF2_ valid verreq03() funcao "sele_arquivo('AVEN00')" retorno @M_REQVEN

  @ 07, 73 get M_REQOBS picture "@!"      valid verreq11()
*  @ 08, 35 get M_REQ800 picture "@!"      valid M_REQ800 $ "SN"
  read

*  if M_REQ800 == "S"  // ALUGUEL
*    SetColor(_COREDICAO_)
*    @ 08, 48 get M_REQVC5 valid !empty(M_REQVC5)
*    @ 08, 59 get M_REQVC6 valid !empty(M_REQVC6)
*    read
*  endif

return ""

****************
function EDREQ02(F_TIPO)
****************

if F_TIPO == "N"
  SetColor(_COREDICAO_)
  @ 05, 12 get M_REQNFS picture "######"
  @ 05, 19 get M_REQNSE picture "@!"
  @ 06, 12 get M_REQDTE
*  @ 07, 12 get M_REQNATN picture "9.999"  valid verreq05()
  @ 08, 12 get M_REQCLI picture "#######" F2 color _CORF2_ valid verreq01(F_TIPO) funcao "sele_arquivo('ACLI00')" retorno @M_REQCLI

* @ 04, 73 get M_REQCPG picture "###"  F2 color _CORF2_ valid verreq04(F_TIPO) funcao "sele_arquivo('ACPG00')" retorno @M_REQCPG
  @ 07, 73 get M_REQOBS picture "@!"      valid verreq11()
  @ 08, 32 get M_REQMEM picture "@!"
  @ 08, 73 get M_REQ800 picture "@!"      valid M_REQ800 $ "SN"
  read
endif

if F_TIPO == "R"
  if M_REQ800 == "S"  // ALUGUEL
  SetColor(_COREDICAO_)
    @ 08, 48 get M_REQVC5 valid !empty(M_REQVC5)
    @ 08, 59 get M_REQVC6 valid !empty(M_REQVC6) .and. M_REQVC6 >= date()
    read
  endif
endif

return ""

****************
function EDREQ04    
****************

parameters LN,SQ

set color to I
  @ LN, 03 say     M_REQMAT[SQ,1] picture "##"                             
SetColor(_COREDICAO_)
@ LN, 06 get     M_REQMAT[SQ, 2] picture "######" F2 color _CORF2_ valid verreq07() funcao "sele_arquivo('APCA00')" retorno @M_REQMAT[SQ, 2]
@ LN, 45 get     M_REQMAT[SQ, 3] picture "#########"    valid verreq08()
@ LN, 55 get     M_REQMAT[SQ, 4] picture "#######.##"   valid verreq09()
read

return .t.

****************
function MSREQ01   
****************

  setcolor("N/W*")
    @ 04, 12 say REQNUM picture "######"
    @ 04, 19 say REQSER picture "@!" 
    @ 05, 12 say REQNFS picture "######"
    @ 05, 19 say REQNSE picture "@!"
    @ 06, 12 say REQDTE
*    @ 07, 12 say REQNATN
    @ 08, 12 say REQCLI       picture "#######"
    @ 04, 27 say REQNOM       picture "@!"
    @ 05, 27 say REQEND       picture "@!"
    @ 06, 27 say REQBAI       picture "@!"
    @ 06, 48 say REQMUN       picture "@!"
    @ 07, 27 say REQCEP       picture "#####"
    @ 07, 33 say REQCCL       picture "###"
    @ 07, 48 say REQEST       picture "@!"
    @ 04, 73 say REQCPG       picture "###"
    @ 05, 73 say REQVEN       picture "###"
    @ 06, 73 say REQTRA       picture "###"
    @ 07, 73 say REQOBS       picture "@!"
    @ 08, 35 say REQFRC       picture "@!"

    @ 08, 48 say REQVC5
    @ 08, 59 say REQVC6

  set color to 

return ""

****************
function MSREQ02   
****************

parameters SQ,R

    setcolor("N/W*")
      for S = SQ to len(M_REQMAT)
        BUSCAREGISTRO("APCA00",1,{str(M_REQMAT[SQ, 2],6,0)},"SELECT")
        @ R, 03 say     M_REQMAT[S, 1] picture "##"
        @ R, 06 say     M_REQMAT[S, 2] picture "######"  
        @ R, 13 say     pad(APCA00->PCADES, 28)
        @ R, 42 say     pad(APCA00->PCAUNI, 02)
        @ R, 45 say     M_REQMAT[S, 3] picture "#########"
        @ R, 55 say     M_REQMAT[S, 4] picture "#######.##"
        @ R, 66 say     M_REQMAT[S, 5] picture "#######.##"
        R++
        if R = 19
          exit
        endif
      next
    set color to

return ""

****************
function MSREQ03   
****************

  store 12 to L

    do while !eof()
      setcolor("N/W*")
      BUSCAREGISTRO("APCA00",1,{str(AREQ01->REQMAT,6,0)},"SELECT")
      select AREQ01
       @ L, 03 say     REQSEQ    picture "##"
        @ L, 06 say     REQMAT    picture "######"  
        @ L, 13 say     pad(APCA00->PCADES, 28)
        @ L, 42 say     pad(APCA00->PCAUNI, 02)
        @ L, 45 say     REQQDE    picture "######.##"
        @ L, 55 say     REQPRB    picture "#######.##"
        @ L, 66 say     REQVLI    picture "#######.##"
      set color to
      if L > 18
        msg("* * * (ESC) Sai (ENTER) continua * * *")
        if lastkey() = 27
          exit
        endif
        lpreq01()
        L=11
      endif
      skip
      L = L + 1
    enddo

return ""

****************
function LPREQ01   
****************

private K

  set color to I
    for K = 12 to 19
      @ K, 03 say "                                                                         "
    next
  set color to

return ""

#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)

*****************
function VERREQ01(TIPO)   
*****************

if lastkey() = 5
  return .t.
endif

if M_REQCLI = 0
  sele_arquivo('ACLI00')
  M_REQCLI = nCodRetorno
endif

if M_REQCLI = 9000000
  if AFIS00->FISINT = "R"
    msg("* * * CLIENTE NAO PODE SER CONSUMIDOR * * *")
    return .f.
  endif
endif

if M_REQCLI = 9000000
  save get to M_GETANT
  SetColor(_COREDICAO_)
  @ 04, 27 get M_REQNOM picture "@!"
  @ 05, 27 get M_REQEND picture "@!"
  @ 06, 27 get M_REQBAI picture "@!"
  @ 06, 48 get M_REQMUN picture "@!"
  @ 07, 27 get M_REQCEP picture "#####"
  @ 07, 33 get M_REQCCL picture "###"
  @ 07, 48 get M_REQEST picture "@!"
  read
  restore get from M_GETANT
else

  if !valorescli(M_REQCLI)
    msg("* * * CLIENTE NAO CADASTRADO * * *")
    M_REQCLI = 0
    return .f.
  endif

  if !analiza_cl(M_REQCLI)
    return .f.
  endif
  
  M_REQNOM = pad(ACLI00->CLINOM, 40)
  M_REQEND = pad(ACLI00->CLIEND2, 40)
  M_REQBAI = pad(ACLI00->CLIBAI2, 15)
  M_REQMUN = pad(ACLI00->CLIMUN2, 19)
  M_REQCEP = ACLI00->CLICEP2
  M_REQCCL = ACLI00->CLICCL2
  M_REQEST = ACLI00->CLIUF2
  M_REQIES = ACLI00->CLIIES2
  M_REQCGC = ACLI00->CLICGC2
  M_REQTEL = ACLI00->CLITEL3
  M_REQVEN = iif(M_REQVEN=0,ACLI00->CLIVEN,M_REQVEN)
  M_REQTRA = ACLI00->CLITRA 
  M_REQMEM = pad(ACLI00->NOMEPAI,20)
  
  setcolor("N/W*")
    @ 04, 27 say M_REQNOM picture "@!"
    @ 05, 27 say M_REQEND picture "@!"
    @ 06, 27 say M_REQBAI picture "@!"
    @ 06, 48 say M_REQMUN picture "@!"
    @ 07, 27 say M_REQCEP picture "#####"
    @ 07, 33 say M_REQCCL picture "###"
    @ 07, 48 say M_REQEST picture "@!"
  set color to 
endif

setcursor(1)

return .t.

*****************
function VERREQ02   
*****************

if lastkey() = 5
  return .t.
endif

if empty(M_REQDTE)
  msg("* * * DATA DE EMISSAO NAO PODE ESTAR VAZIA  * * *")
  return .f.
endif

return .t.

*****************
function VERREQ03   
*****************

if lastkey() = 5
  return .t.
endif

if M_REQVEN = 0
  return .f.
endif

if !BUSCAREGISTRO("AVEN00",1,{str(M_REQVEN,3,0)},"SELECT")
  msg("* * * VENDEDOR NAO CADASTRADO * * *")
  return .f.
endif

msg("* * * " + alltrim(AVEN00->VENNOM) + " * * *")


return .t.

*****************
function VERREQ04
*****************

if lastkey() = 5
  return .t.
endif

if M_REQCPG = 0
  return .f.
endif

if !BUSCAREGISTRO("ACPG00",1,{str(M_REQCPG,3,0)},"SELECT")
  msg("* * * CONDICAO DE PAGTO NAO CADASTRADA * * *")
  return .f.
endif

if M_REQCPG > 20
  if ACLI00->CLITIP = "A"
    msg("* * * NECESSARIO CONSULTAR A GERENCIA * * *")
    return .f.
  endif
endif

return .t.

*****************
function VERREQ05
*****************

if lastkey() = 5
  return .t.
endif

if val(M_REQNATN) = 0
  return .f.
endif

if !BUSCAREGISTRO("AFIS00",1,{str(1,2,0),M_REQNATN},"SELECT")
  msg("* * * NATUREZA NAO CADASTRADA * * *")
  return .f.
endif

return .t.

*****************
function VERREQ06
*****************

 if lastkey() = 5
   return .t.
 endif

 if M_REQTRA = 0
   return .f.
 endif

 if !BUSCAREGISTRO("ATRA00",1,{str(M_REQTRA,3,0)},"SELECT")
   msg("* * * TRANPORTADORA NAO CADASTRADA * * *")
   return .f.
 endif


 return .t.

*****************
function VERREQ07                      && procura produto
*****************

  if lastkey() = 5
    return .t.
  endif

  if M_REQMAT[SQ,2] = 0
    sele_arquivo('APCA00')
    M_REQMAT[SQ,2] = nCodRetorno
  endif

  if !BUSCAREGISTRO("APCA00",1,{str(M_REQMAT[SQ,2],6,0)},"SELECT")
    msg("* * * PRODUTO NAO CADASTRADO * * *")
    M_REQMAT[SQ,2] = 0
    return .f.
  endif

  setcolor("N/W*")
    @ LN, 13 say pad(APCA00->PCADES, 31)
  set color to

  BUSCAREGISTRO("ASLD00",1,{str(1, 2, 0),str(M_REQMAT[SQ,2],6,0)},"SELECT")

  M_REQMAT[SQ, 4] = ASLD00->SLDPRC
  M_REQMAT[SQ, 7] = APCA00->PCADES

  BUSCAREGISTRO("ASLD00",1,{str(51, 2, 0),str(M_REQMAT[SQ,2],6,0)},"SELECT")
  msw(APCA00->PCADES + " Saldo: " + str(ASLD00->SLDDIS, 5, 0))

  setcursor(1)

return .t.    

*****************
function VERREQ08   
*****************

  if lastkey() = 5
    return .t.
  endif

  if M_REQMAT[SQ, 3] = 0
    return .f.
  endif

  BUSCAREGISTRO("ASLD00",1,{str(1, 2, 0),str(M_REQMAT[SQ,2],6,0)},"SELECT")

  if M_REQMAT[SQ, 3] > ASLD00->SLDDIS
     msg("* * * PRODUTO SEM SALDO DE ESTOQUE -=> " + str(ASLD00->SLDDIS, 5, 0) + " * * * ")
     if _NOMEMP_ = "PAULISTA"
       if !c_senha()
         return .f.
       endif
     endif
  endif 
  
return .t.

*****************
function VERREQ09   
*****************

  if lastkey() = 5
    return .t.
  endif

  if M_REQMAT[SQ, 4] = 0
    return .f.
  endif

  M_REQMAT[SQ, 5] = round(M_REQMAT[SQ, 4] * M_REQMAT[SQ, 3], 2)

  set color to I
    @ LN, 66 say M_REQMAT[SQ, 5] picture "#######.##" 
  set color to 

return .t.
 
*****************
function VERREQ10   
*****************

if lastkey() = 5
  return .t.
endif

if M_REQCLI = 9000000
  return .t.
endif

if M_REQCLI = 0
  return .f.
endif


if !BUSCAREGISTRO("ACLI00",1,{str(M_REQCLI,7,0)},"SELECT")
  msg("* * * CLIENTE NAO CADASTRADO * * *")
  return .f.
endif

M_CLIEND1  = ACLI00->CLIEND1
M_CLIIES2  = ACLI00->CLIIES2
M_CLICGC2  = ACLI00->CLICGC2
M_CLINOM   = ACLI00->CLINOM 
M_CLIEND2  = ACLI00->CLIEND2
M_CLIUF2   = ACLI00->CLIUF2
M_CLIBAI2  = ACLI00->CLIBAI2
M_CLICEP2  = ACLI00->CLICEP2
M_CLICCL2  = ACLI00->CLICCL2
M_CLIMUN2  = ACLI00->CLIMUN2
M_CLITEL3  = ACLI00->CLITEL3
M_CLIEND3  = ACLI00->CLIEND3
M_CLIDCC   = ACLI00->CLIDCC
M_REQVEN   = ACLI00->CLIVEN

if !analiza_cl(M_REQCLI)
  return .f.
endif

return .t.

*****************
function VERREQ11
***************** 

if lastkey() = 5
  return .t.
endif

if !M_REQOBS $ "SN"
  msg("* * * VALIDO SOMENTE (S)im ou (N)ao * * *")
  return .f.
endif


return .t.

*****************
function VERREQ12                      && edita historico
*****************

private M_TELA

M_TELA = savescreen(08, 10, 14, 72)

sombra(08, 10, 13, 71,_SOMBRA_)

setcolor("GR+/BG+")
 @ 09, 10 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄObservacoesÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
 @ 10, 10 say     "³                                                            ³"
 @ 11, 10 say     "³                                                            ³"
 @ 12, 10 say     "³                                                            ³"
 @ 13, 10 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
setcolor("")

do while .t.
  SetColor(_COREDICAO_)
  @ 10, 11 get M_REQHS1 picture "@!"
  @ 11, 11 get M_REQHS2 picture "@!"
  @ 12, 11 get M_REQHS3 picture "@!"
  read

  msg("* * * (ENTER) Continua  (PgDn) Sai * * *")

  if lastkey() = 3
    exit
  endif

enddo

restscreen(08, 10, 14, 72, M_TELA)


return ""

*****************
function VERREQ13
*****************
 
parameters M_REQNUM,;
           M_REQSER

if lastkey() = 5
  return .t.
endif

if M_REQNUM = 0
  return .t.
endif

select AREQ00

if !dbseek(str(nREQEMP, 2, 0) + str(M_REQNUM, 6, 0) + M_REQSER)
  msg(" * * * REQUISICAO NAO ENCONTRADA * * * ")
  return .f.
endif

if REQCLI != M_PEDCLI
  msg("* * *  " + str(AREQ00->REQCLI, 7, 0) + " ESTA REQUISICAO NAO PERTENCE AO MESMO CLIENTE " + str(M_PEDCLI, 5, 0) + " * * *")
  return .f.
endif

if REQNFS > 0
  msg("* * * REQUISICAO JA FATURADA -=> " + str(REQNFS, 6, 0) + " " + REQSER + " * * *")
  return .f.
endif

msg("* * * " + dtoc(AREQ00->REQDTE) + " " + str(AREQ00->REQVLN, 14, 2) + " * * *")

return .t.

***************** 
function VERREQ16                 
***************** 

  if lastkey() = 5
    return .t.
  endif

  select ACLI00

  if !dbseek(str(M_PEDCLI, 7, 0))
    msg("* * * CLIENTE NAO CADASTRADO * * *")
    return .f.
  endif

  msg("* * * " + alltrim(CLINOM) + " * * *")

return .t.    

***************** 
function VERREQ17                 
***************** 

  if lastkey() = 5
    return .t.
  endif

  if M_PEDCPG = 0 
    return .f.
  endif

  select ACPG00

  if !dbseek(str(M_PEDCPG, 3, 0))
    msg("* * * CONDICAO NAO CADASTRADO * * *")
    return .f.
  endif

  msg("* * * " + alltrim(CPGDES) + " * * *")

return .t.    

***************** 
function VERREQ18                 
***************** 

  if lastkey() = 5
    return .t.
  endif

  if empty(M_PEDDTE)
     return .f.
  endif

return .t.    

***************
function MOSREQ
***************
nMouse:= array(4)


parameters  M_MODO, M_ELEM, M_POSI

  vlmouseinf(nMouse)
  nKey := lastkey()

  if (nMouse[1] .Or. nMouse[2])
    if nKey = 1002 .and. nMouse[3] = 23  // click na linha 26
      do case
        case nMouse[4] >= 7 .and. nMouse[4] <= 13
          nKey = asc("1")
        case nMouse[4] >= 16 .and. nMouse[4] <= 31
          nKey = asc("2")
        case nMouse[4] >= 34 .and. nMouse[4] <= 41
          nKey = asc("3")
        case nMouse[4] >= 44 .and. nMouse[4] <= 53
          nKey = asc("4")
        case nMouse[4] >= 56 .and. nMouse[4] <= 63
          nKey = asc("5")
        case nMouse[4] >= 66 .and. nMouse[4] <= 71
          nKey = asc("6")
      endcase
    endif
  endif

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
function EMIREQ
***************

parameter M_OPCAO 

  M_TOTPRO = 0
  LN = 0
  PG = 0
  
  if M_OPCAO
    seexistesql("AREQID")
    cSql := "select first 1 gen_id(gen_AREQ00_id,1) from AREQ00"
    dbusearea(.t.,"SQLMIX",cSql,"AREQID")
    M_ID = GEN_ID
    select AREQID
    use
    M_REQNUM = M_ID
    do while .t.
      if BUSCAREGISTRO("AREQ00",1,{str(M_REQEMP, 2, 0),str(M_REQNUM, 6, 0),aspas(M_REQSER)},"SELECT")
        seexistesql("AREQID")
        cSql := "select first 1 gen_id(gen_AREQ00_id,1) from AREQ00"
        dbusearea(.t.,"SQLMIX",cSql,"AREQID")
        M_ID = GEN_ID
        select AREQID
        use
        M_REQNUM = M_ID
        loop
      endif
      exit
    enddo

    grreq01("INSERT")
    grreq02("INSERT")
  else
    grreq01("UPDATE")
    grreq02("INSERT")  // sempre inclui tudo
  endif

  calc_req()                    && calcula valor da requisicao

* if M_REQNATN == "5.104"
*   calc_dupreq()
* endif

  set color to I
    @ 04, 12 say M_REQNUM picture "######"
    @ 04, 19 say M_REQSER picture "@!" 
  set color to 


   msw("* * * AGUARDE ... IMPRIMINDO * * *")
   set console off

   lLaser = .t.

   oPrinter := Win32Prn():New( )
   oPrinter:Landscape := .F.
   oPrinter:FormType  := 9
   inicio_impressao()
   oPrinter:LineHeight := Int( oPrinter:PixelsPerInchY / 7 )  // Default 6 lines per inch == # of pixels per line

  *  ACLI00->(dbseek(str(M_REQCLI, 5, 0)))

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"AREQ01","AREQ01"})
  aadd(sqlCAMPO,"AREQ01.*")
  aadd(sqlCAMPO,"APCA00.PCAMAT")
  aadd(sqlCAMPO,"APCA00.PCADES")
  aadd(sqlCAMPO,"APCA00.PCAUNI")
  aadd(sqlCAMPO,"APCA00.PCAMAR")
  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","AREQ01.REQMAT"})
  aadd(sqlCHAVE,"REQNUM = " + str(M_REQNUM, 6, 0))
  aadd(sqlCHAVE,"REQEMP = " + str(M_REQEMP, 2, 0))
  aadd(sqlCHAVE,"REQSER = " + aspas(M_REQSER))
  aadd(sqlORDEM,"REQNUM,PCADES")
  sqlrelation()

  M_FLAG = 0
  M_TOTLIN = 0
  RR = 1


for ABC = 1 to 2

  cab_rmi("")                   && imprime cabecalho

  select AREQ01
  go top

  do while !eof()

      oPrinter:TextOut(" ")
      oPrinter:TextOut(str(REQMAT, 6, 0))
      oPrinter:TextOut(" ")

      oPrinter:SetFont( "Lucida Console", 10, { 3, 55 } )
      oPrinter:TextOut(pad(alltrim(PCADES) + " " + PCAMAR, 61))
      oPrinter:SetFont( "Courier New", 11.5,0)  // normal

      oPrinter:TextOut(" ")
      oPrinter:TextOut(pad(PCAUNI, 02))
      oPrinter:TextOut(" ")
      oPrinter:TextOut(transform(REQQDE,"@E #######"))
      oPrinter:TextOut(" ")
      oPrinter:TextOut(transform(REQPRB,"@E ###,###.##"))
      oPrinter:TextOut(" ")
      oPrinter:TextOut(transform(REQVLI,"@E ###,###.##"),.t.)

     M_TOTLIN = M_TOTLIN + 1

     LN = LN + 1
     RR ++

     if !lLaser
       if LN > 60
         cab_rmi("")
       endif
     else
       IF oPrinter:PRow() > oPrinter:MaxRow() - 6 // Could use
         oPrinter:NewPage()
         cab_rmi("")
       endif
     endif

     skip

  enddo

    for R = M_TOTLIN to 18
      oPrinter:TextOut("",.T.)
    next
    oPrinter:TextOut(replicate("-",80),.t.)

    oPrinter:TextOut(pad("EMITIDO: " + M_REQEMI,54))
    oPrinter:TextOut("   Produto : R$ ")
    oPrinter:TextOut(transform(M_REQVLMS,"@E ###,###.##"),.t.)

    oPrinter:TextOut("              ")
    oPrinter:TextOut(space(08))
    oPrinter:TextOut(" ")
    oPrinter:TextOut(space(10))
    oPrinter:TextOut("  ")
    oPrinter:TextOut(space(08))
    oPrinter:TextOut(" ")
    oPrinter:TextOut(space(10))
    oPrinter:TextOut("   Desconto: R$ ")
    oPrinter:TextOut(transform(M_REQDSC,"@E ###,###.##"),.t.)

    oPrinter:TextOut("              ")
    oPrinter:TextOut(space(08))
    oPrinter:TextOut(" ")
    oPrinter:TextOut(space(10))
    oPrinter:TextOut("  ")
    oPrinter:TextOut(space(08))
    oPrinter:TextOut(" ")
    oPrinter:TextOut(space(10))
    oPrinter:TextOut("   Total   : R$ ")
    oPrinter:TextOut(transform(M_REQVLN,"@E ###,###.##"),.t.)

    oPrinter:TextOut("",.t.)
    oPrinter:TextOut(replicate("-", 80),.t.)
    oPrinter:TextOut("",.t.)

next

oPrinter:TextOut("",.T.)
oPrinter:EndDoc()
oPrinter:Destroy()

  for R = 1 to len(M_REQMAT)
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"AKAR00","INSERT"}
    aadd(sqlCAMPO,{"KAREMP",str(M_REQEMP,2),.t.})
    aadd(sqlCAMPO,{"KARMAT",str(M_REQMAT[R,2],6),.t.})
    aadd(sqlCAMPO,{"KARDTA",formatdta(M_REQDTE),.t.})
  	aadd(sqlCAMPO,{"KARFISN",M_REQNATN,.t.})
    aadd(sqlCAMPO,{"KARDOC",str(M_REQNUM,7),.t.})
    aadd(sqlCAMPO,{"KARSER",M_REQSER,.t.})
    aadd(sqlCAMPO,{"KARCLF",str(M_REQCLI,5),.t.})
    aadd(sqlCAMPO,{"KARSEQ",str(M_REQMAT[R,1],3),.t.})
    aadd(sqlCAMPO,{"KARQDE",str1(M_REQMAT[R,3],3),.t.})
    aadd(sqlCAMPO,{"KARPRB",str1(M_REQMAT[R,4],2),.t.})
    aadd(sqlCAMPO,{"KARVLI",str1(M_REQMAT[R,6],2),.t.})
    executasql()

    * ATUALIZAR SALDO
    
  next && R

  if lRenova
    gra_renova()
  else
    if M_REQNATN == "5.104"
      gra_reqdcr()
    endif
  endif


return ""

****************
function CAB_RMI
****************

parameters M_VIA

*/*/*/

BUSCAREGISTRO("AVEN00",1,{str(M_REQVEN,3,0)},"SELECT")
BUSCAREGISTRO("ACLI00",1,{str(M_REQCLI,7,0)},"SELECT")

  oPrinter:TextOut("",.t.)
  oPrinter:TextOut(cent_cab("",alltrim("R E Q U I S I C A O - " + M_VIA),"Numero: " + str(M_REQNUM, 6, 0) ,80),.t.)
  oPrinter:TextOut(cent_cab("Emissao: " + dtoc(M_REQDTE),"",time(),80),.t.)
  oPrinter:TextOut(replicate("-",80),.t.)

  oPrinter:bold( FW_NORMAL )
  oPrinter:TextOut("Cliente    : ")
  oPrinter:bold( FW_BOLD )
  oPrinter:TextOut(M_REQNOM)
  oPrinter:bold( FW_NORMAL )
  oPrinter:TextOut(" Codigo: ")
  oPrinter:bold( FW_BOLD )
  oPrinter:TextOut(str(M_REQCLI, 7, 0),.t.)
  oPrinter:bold( FW_NORMAL )


  oPrinter:TextOut("Endereco   : ")
  oPrinter:bold( FW_BOLD )
  oPrinter:TextOut(M_REQEND)
  oPrinter:TextOut(" - ")
  oPrinter:TextOut(M_REQBAI,.t.)
  oPrinter:bold( FW_NORMAL )

  oPrinter:TextOut("Municipio  : ")
  oPrinter:bold( FW_BOLD )
  oPrinter:TextOut(M_REQMUN)
  oPrinter:TextOut(" ")
  oPrinter:TextOut(M_REQEST)
  oPrinter:bold( FW_NORMAL )
  oPrinter:TextOut(" Cep: ")
  oPrinter:bold( FW_BOLD )
  oPrinter:TextOut(strzero(M_REQCEP, 5, 0))
  oPrinter:TextOut(" ")
  oPrinter:TextOut(strzero(M_REQCCL, 3, 0))
  oPrinter:bold( FW_NORMAL )
  oPrinter:TextOut("   Vendedor: ")
  oPrinter:bold( FW_BOLD )
  oPrinter:TextOut(pad(AVEN00->VENNOM, 16),.t.)
  oPrinter:bold( FW_NORMAL )

  oPrinter:TextOut("CGC(MF)/CPF: ")
  oPrinter:bold( FW_BOLD )
  if len(rtrim(M_REQCGC)) = 11
    oPrinter:TextOut(transform(M_REQCGC,"@R 999.999.999/99"))
    oPrinter:TextOut(space(05))
  else
    oPrinter:TextOut(transform(M_REQCGC,"@R 999.999.999/9999-99"))
  endif
  oPrinter:bold( FW_NORMAL )

  oPrinter:TextOut("                    Inscr Est: ")
  oPrinter:bold( FW_BOLD )
  oPrinter:TextOut(M_REQIES,.t.)
  oPrinter:bold( FW_NORMAL )

  oPrinter:TextOut("Mensagem   : " + alltrim(ACLI00->CLITEL3))
  oPrinter:bold( FW_BOLD )
  oPrinter:TextOut(M_REQHS1,.t.)

  oPrinter:TextOut("           : ")
  oPrinter:TextOut(M_REQHS2,.t.)

  oPrinter:TextOut("           : ")
  oPrinter:TextOut(M_REQHS3,.t.)
  oPrinter:bold( FW_NORMAL )

  oPrinter:TextOut(replicate("-",80),.t.)
  oPrinter:TextOut("Produto         D e s c r i c a o            Un  Qtde      Unitario     Total  ",.t.)
  oPrinter:TextOut(replicate("-",80),.t.)

return ""

***************
function GRAREQ
***************

parameters M_OPCAO

  if M_OPCAO
    seexistesql("AREQID")
    cSql := "select first 1 gen_id(gen_AREQ00_id,1) from AREQ00"
    dbusearea(.t.,"SQLMIX",cSql,"AREQID")
    M_ID = GEN_ID
    select AREQID
    use
    M_REQNUM = M_ID
    do while .t.
      if BUSCAREGISTRO("AREQ00",1,{str(M_REQEMP, 2, 0),str(M_REQNUM, 6, 0),aspas(M_REQSER)},"SELECT")
        seexistesql("AREQID")
        cSql := "select first 1 gen_id(gen_AREQ00_id,1) from AREQ00"
        dbusearea(.t.,"SQLMIX",cSql,"AREQID")
        M_ID = GEN_ID
        select AREQID
        use
        M_REQNUM = M_ID
        loop
      endif
      exit
    enddo

    grreq01("INSERT")
    grreq02("INSERT")
  else
    grreq01("UPDATE")
    grreq02("INSERT")
  endif

*  if M_REQNATN == "5.104"
*    calc_dupreq()
*  endif

  set color to I
    @ 04, 12 say M_REQNUM picture "######"
    @ 04, 19 say M_REQSER picture "@!" 
  set color to 

 ret_itensrq()                 && retira kardex duplicatas

  for R = 1 to len(M_REQMAT)

    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"AKAR00","INSERT"}
    aadd(sqlCAMPO,{"KAREMP",str(M_REQEMP,2),.t.})
    aadd(sqlCAMPO,{"KARMAT",str(M_REQMAT[R,2],6),.t.})
    aadd(sqlCAMPO,{"KARDTA",formatdta(M_REQDTE),.t.})
  	aadd(sqlCAMPO,{"KARFISN",M_REQNATN,.t.})
    aadd(sqlCAMPO,{"KARDOC",str(M_REQNUM,7),.t.})
    aadd(sqlCAMPO,{"KARSER",M_REQSER,.t.})
    aadd(sqlCAMPO,{"KARCLF",str(M_REQCLI,5),.t.})
    aadd(sqlCAMPO,{"KARSEQ",str(M_REQMAT[R,1],3),.t.})
    aadd(sqlCAMPO,{"KARQDE",str1(M_REQMAT[R,3],3),.t.})
    aadd(sqlCAMPO,{"KARPRB",str1(M_REQMAT[R,4],2),.t.})
    aadd(sqlCAMPO,{"KARVLI",str1(M_REQMAT[R,6],2),.t.})
    executasql()

    * ATUALIZAR SALDO
  next && R

*  if M_REQNATN == "5.104"
*    gra_reqdcr()
*  endif

  msw("* * * REQUISI€AO GRAVADO * * *")

return "" 

**************** 
function GRREQ01(cACAO)                       && grava pedido
****************

  sqlCAMPO = {}
  sqlCHAVE = {}
  sqlARQUI = {"AREQ00",(cACAO)}

  aadd(sqlCHAVE,{"REQEMP",str(nREQEMP, 2)})
  aadd(sqlCHAVE,{"REQNUM",str(M_REQNUM, 6)})
  aadd(sqlCHAVE,{"REQSER",aspas(M_REQSER)})

  if !cACAO $ "#DELETE#SELECT#"
    aadd(sqlCAMPO,{"REQEMP",str(nREQEMP,2),.T.})
    aadd(sqlCAMPO,{"REQNUM",str(M_REQNUM,6),.T.})
    aadd(sqlCAMPO,{"REQCLI",str(M_REQCLI,6),.T.})
    aadd(sqlCAMPO,{"REQCEP",str(M_REQCEP,5),.T.})
    aadd(sqlCAMPO,{"REQCCL",str(M_REQCCL,3),.T.})
    aadd(sqlCAMPO,{"REQCPG",str(M_REQCPG,3),.T.})
    aadd(sqlCAMPO,{"REQVEN",str(M_REQVEN,3),.T.})
    aadd(sqlCAMPO,{"REQTRA",str(M_REQTRA,3),.T.})
    aadd(sqlCAMPO,{"REQNFS",str(M_REQNFS,6),.T.})

    aadd(sqlCAMPO,{"REQDTE",formatdta(M_REQDTE),.T.})
    aadd(sqlCAMPO,{"REQVC1",formatdta(M_REQVC1),.T.})
    aadd(sqlCAMPO,{"REQVC2",formatdta(M_REQVC2),.T.})
    aadd(sqlCAMPO,{"REQVC3",formatdta(M_REQVC3),.T.})
    aadd(sqlCAMPO,{"REQVC4",formatdta(M_REQVC4),.T.})
    aadd(sqlCAMPO,{"REQVC5",formatdta(M_REQVC5),.T.})
    aadd(sqlCAMPO,{"REQVC6",formatdta(M_REQVC6),.T.})

    aadd(sqlCAMPO,{"REQSER",M_REQSER,.T.})
    aadd(sqlCAMPO,{"REQNSE",M_REQNSE,.T.})
    aadd(sqlCAMPO,{"REQNATN",M_REQNATN,.T.})
    aadd(sqlCAMPO,{"REQMEM",M_REQMEM,.T.})
    aadd(sqlCAMPO,{"REQFRC",M_REQ800,.T.})
    aadd(sqlCAMPO,{"REQNOM",M_REQNOM,.T.})
    aadd(sqlCAMPO,{"REQEND",M_REQEND,.T.})
    aadd(sqlCAMPO,{"REQBAI",M_REQBAI,.T.})
    aadd(sqlCAMPO,{"REQMUN",M_REQMUN,.T.})
    aadd(sqlCAMPO,{"REQEST",M_REQEST,.T.})
    aadd(sqlCAMPO,{"REQIES",M_REQIES,.T.})
    aadd(sqlCAMPO,{"REQCGC",M_REQCGC,.T.})
    aadd(sqlCAMPO,{"REQOBS",M_REQOBS,.T.})
    aadd(sqlCAMPO,{"REQIPL",M_REQIPL,.T.})
    aadd(sqlCAMPO,{"REQHS1",M_REQHS1,.T.})
    aadd(sqlCAMPO,{"REQHS2",M_REQHS2,.T.})
    aadd(sqlCAMPO,{"REQHS3",M_REQHS3,.T.})
    aadd(sqlCAMPO,{"REQEMI",M_REQEMI,.T.})

    aadd(sqlCAMPO,{"REQVLP",str1(M_REQVLP,2),.T.})
    aadd(sqlCAMPO,{"REQDSC",str1(M_REQDSC,2),.T.})
    aadd(sqlCAMPO,{"REQVLN",str1(M_REQVLN,2),.T.})
    aadd(sqlCAMPO,{"REQVLM",str1(M_REQVLM,2),.T.})
    aadd(sqlCAMPO,{"REQVIC",str1(M_REQVIC,2),.T.})
    aadd(sqlCAMPO,{"REQVLMS",str1(M_REQVLMS,2),.T.})
    aadd(sqlCAMPO,{"REQVICS",str1(M_REQVICS,2),.T.})
    aadd(sqlCAMPO,{"REQDP1",str1(M_REQDP1,2),.T.})
    aadd(sqlCAMPO,{"REQDP2",str1(M_REQDP2,2),.T.})
    aadd(sqlCAMPO,{"REQDP3",str1(M_REQDP3,2),.T.})
    aadd(sqlCAMPO,{"REQDP4",str1(M_REQDP4,2),.T.})
    aadd(sqlCAMPO,{"REQDP5",str1(M_REQDP5,2),.T.})
    aadd(sqlCAMPO,{"REQDP6",str1(M_REQDP6,2),.T.})
  endif

  executasql()

return ""

**************** 
function GRREQ02(cACAO)                      && grava reqido itens
**************** 
private R

if cACAO $ "#DELETE#INSERT#"
  sqlCAMPO = {}
  sqlCHAVE = {}
  sqlARQUI = {"AREQ01","DELETE"}
  aadd(sqlCHAVE,{"REQEMP",str(M_REQEMP,2)})
  aadd(sqlCHAVE,{"REQNUM",str(M_REQNUM,6)})
  aadd(sqlCHAVE,{"REQSER",aspas(M_REQSER)})
  executasql()
endif

if cACAO $ "#SELECT#"
  sqlCAMPO = {}
  sqlCHAVE = {}
  sqlARQUI = {"AREQ01","SELECT"}

  aadd(sqlCHAVE,{"REQEMP",str(nREQEMP, 2)})
  aadd(sqlCHAVE,{"REQNUM",str(M_REQNUM, 6)})
  aadd(sqlCHAVE,{"REQSER",aspas(M_REQSER)})
  executasql()
  return ""
endif

if !cACAO $ "#DELETE#SELECT#"
  for R = 1 to len(M_REQMAT)
    sqlCAMPO = {}
    sqlCHAVE = {}
    sqlARQUI = {"AREQ01",(cACAO)}

    aadd(sqlCHAVE,{"REQEMP",str(nREQEMP, 2)})
    aadd(sqlCHAVE,{"REQNUM",str(M_REQNUM, 6)})
    aadd(sqlCHAVE,{"REQSER",aspas(M_REQSER)})

    aadd(sqlCAMPO,{"REQEMP",str(nREQEMP,2),.T.})
    aadd(sqlCAMPO,{"REQNUM",str(M_REQNUM,6),.T.})
    aadd(sqlCAMPO,{"REQSER",M_REQSER,.T.})

    aadd(sqlCAMPO,{"REQSEQ",str(M_REQMAT[R, 8],3),.T.})
    aadd(sqlCAMPO,{"REQMAT",str(M_REQMAT[R, 2],6),.T.})
    aadd(sqlCAMPO,{"REQQDE",str1(M_REQMAT[R, 3],3),.T.})
    aadd(sqlCAMPO,{"REQPRB",str1(M_REQMAT[R, 4],2),.T.})
    aadd(sqlCAMPO,{"REQVLI",str1(M_REQMAT[R, 5],2),.T.})
    aadd(sqlCAMPO,{"REQLIQ",str1(M_REQMAT[R, 6],2),.T.})
    aadd(sqlCAMPO,{"PACIENTE",M_REQNOM,.T.})
    aadd(sqlCAMPO,{"INDICADO",M_REQMEM,.T.})
    aadd(sqlCAMPO,{"REQCLI",str(M_REQCLI,7),.T.})
    aadd(sqlCAMPO,{"REQDTE",formatdta(M_REQDTE),.T.})
    aadd(sqlCAMPO,{"REQIPL",M_REQIPL,.T.})
    executasql()
  next
endif

return ""

********************
function CALC_DUPREQ
********************

M_GERCPG = M_REQCPG
M_GERVLN = M_REQVLN
M_GERDTE = M_REQDTE

M_GERDP1 = 0
M_GERDP2 = 0
M_GERDP3 = 0
M_GERDP4 = 0
M_GERDP5 = 0
M_GERDP6 = 0

M_GERVC1 = ctod("  /  /  ")
M_GERVC2 = ctod("  /  /  ")
M_GERVC3 = ctod("  /  /  ")
M_GERVC4 = ctod("  /  /  ")
M_GERVC5 = date()
M_GERVC6 = ctod("  /  /  ")

if !CALC_DUPGER()
  return ""
endif

M_REQDP1 = M_GERDP1
M_REQDP2 = M_GERDP2
M_REQDP3 = M_GERDP3
M_REQDP4 = M_GERDP4
M_REQDP5 = M_GERDP5
M_REQDP6 = M_GERDP6

M_REQVC1 = M_GERVC1
M_REQVC2 = M_GERVC2
M_REQVC3 = M_GERVC3
M_REQVC4 = M_GERVC4
M_REQVC5 = M_GERVC5
M_REQVC6 = M_GERVC6

return ""

****************
function MSREQ04                     && mostra dados e calcula nota fiscal
****************
lOCAL aBlocks2 := {}
aLastPaint6 := WvtSetBlocks( aBlocks2 )

private  M_TELA ,;
         R

    M_TELA = savescreen(07, 20, 16, 61)

    nbox(07, 20, 11, 59,"W/W+",.t.)
    setcolor("B/W")
      @ 08, 21 say  "Valor do Produto  :                   "
      @ 09, 21 say  "Valor do Desconto :                   "
      @ 10, 21 say  "Valor Requisicao  :                   "
    setcolor("N/W*")
      @ 08, 41 say AREQ00->REQVLP                 picture "@E ###,###,###,###.##"
      @ 09, 41 say AREQ00->REQDSC                 picture "@E ###,###,###,###.##"
      @ 10, 41 say AREQ00->REQVLN                 picture "@E ###,###,###,###.##"
    set color to
     
    msg("* * * TECLE (ENTER) * * *")

    WvtSetBlocks( aLastPaint6 )
    restscreen(07, 20, 16, 61, M_TELA)

return ""

#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)

***************
function REEREQ
***************

private M_TELA  ,;
        M_REQEMP,;
        M_REQNUM,;
        M_REQSER

M_TELA = savescreen(11, 25, 15, 54)

save get to M_GETANT

M_REQEMP = nREQEMP
M_REQNUM = 0
M_REQSER = AEMP00->EMPRES


do while .t.

    nbox(11, 27, 13, 51,"W/W+",.F.)
    setcolor("B/W")

    @ 12, 28 say         " Requisi‡„o :          "

  SetColor(_COREDICAO_)

  @ 12, 42 get M_REQNUM picture "######"
  @ 12, 49 get M_REQSER picture "@!"
  read

  if lastkey() = 27
    exit
  endif


  if !BUSCAREGISTRO("AREQ00",1,{str(M_REQEMP, 2, 0),str(M_REQNUM, 6, 0),aspas(M_REQSER)},"SELECT")
    msg("* * * REQUISICAO NAO INCLUIDA * * *")
    loop
  endif

  M_IMPRE = impresn()

  lLaser = .f.

  if alltrim(AEMP00->EMPHS5) == "LASER"
    lLaser = .t.
    oPrinter := Win32Prn():New( )
    oPrinter:Landscape := .F.
    oPrinter:FormType  := 9
    inicio_impressao()
    oPrinter:LineHeight := Int( oPrinter:PixelsPerInchY / 7 )  // Default 6 lines per inch == # of pixels per line
  endif

  if M_IMPRE = "N"
    return ""
  endif

  if !lLaser
    ?? chr(27) + "0"
    ?? chr(27) + "C" + chr(44)
  endif
  
  BUSCAREGISTRO("ACLI00",1,{str(AREQ00->REQCLI,7,0)},"SELECT")
  BUSCAREGISTRO("AVEN00",1,{str(AREQ00->REQVEN,3,0)},"SELECT")

  for A = 1 to 2

    select AREQ00

    M_TOTLIN = 0

    if !lLaser
      ? cent_cab(AEMP00->EMPFAN,alltrim("R E Q U I S I C A O - 2a Via"),"Numero: " + str(M_REQNUM, 6, 0) ,80)
      ? cent_cab("Emissao: " + dtoc(REQDTE),"",time(),80)
      ? replicate("-",80)
    else
      oPrinter:TextOut("",.t.)
      oPrinter:TextOut(cent_cab(AEMP00->EMPFAN,alltrim("R E Q U I S I C A O - 2a Via"),"Numero: " + str(M_REQNUM, 6, 0) ,80),.t.)
      oPrinter:TextOut(cent_cab("Emissao: " + dtoc(REQDTE),"",time(),80),.t.)
      oPrinter:TextOut(replicate("-",80),.t.)
    endif

    nLinhaimp = "Cliente    : "
    nLinhaimp = nLinhaimp + REQNOM
    nLinhaimp = nLinhaimp + " Codigo: "
    nLinhaimp = nLinhaimp + str(REQCLI, 7, 0)
    nLinhaimp = nLinhaimp + "  Cpg: "
    nLinhaimp = nLinhaimp + str(REQCPG, 3, 0)

    if !lLaser
      ? nLinhaimp
    else
      oPrinter:TextOut(nLinhaimp,.t.)
    endif

    nLinhaimp = "Endereco   : "
    nLinhaimp = nLinhaimp + REQEND
    nLinhaimp = nLinhaimp + "      Tra: "
    nLinhaimp = nLinhaimp + str(REQTRA, 5, 0)
    if !lLaser
      ? nLinhaimp
    else
      oPrinter:TextOut(nLinhaimp,.t.)
    endif

    nLinhaimp = "Municipio  : "
    nLinhaimp = nLinhaimp + REQMUN
    nLinhaimp = nLinhaimp + " "
    nLinhaimp = nLinhaimp + REQEST
    nLinhaimp = nLinhaimp + " Cep: "
    nLinhaimp = nLinhaimp + strzero(REQCEP, 5, 0)
    nLinhaimp = nLinhaimp + " "
    nLinhaimp = nLinhaimp + strzero(REQCCL, 3, 0)
    nLinhaimp = nLinhaimp + "   Vendedor: "
    nLinhaimp = nLinhaimp + pad(AVEN00->VENNOM, 16)

    if !lLaser
      ? nLinhaimp
    else
      oPrinter:TextOut(nLinhaimp,.t.)
    endif

    nLinhaimp = "CGC(MF)/CPF: "
    if len(rtrim(REQCGC)) = 11
      nLinhaimp = nLinhaimp + transform(REQCGC,"@R 999.999.999/99")
      nLinhaimp = nLinhaimp + space(05)
    else
      nLinhaimp = nLinhaimp + transform(REQCGC,"@R 999.999.999/9999-99")
    endif
    nLinhaimp = nLinhaimp + "                    Inscr Est: "
    nLinhaimp = nLinhaimp + REQIES

    if !lLaser
      ? nLinhaimp
    else
      oPrinter:TextOut(nLinhaimp,.t.)
    endif

    nLinhaimp = "Telefone   : "
    nLinhaimp = nLinhaimp + alltrim(ACLI00->CLITEL3)

    if !lLaser
      ? nLinhaimp
    else
      oPrinter:TextOut(nLinhaimp,.t.)
    endif

    nLinhaimp = "Mensagem   : "
    nLinhaimp = nLinhaimp + REQHS1
    if !lLaser
      ? nLinhaimp
    else
      oPrinter:TextOut(nLinhaimp,.t.)
    endif

    nLinhaimp = "           : "
    nLinhaimp = nLinhaimp + REQHS2
    if !lLaser
      ? nLinhaimp
    else
      oPrinter:TextOut(nLinhaimp,.t.)
    endif

    nLinhaimp = "           : "
    nLinhaimp = nLinhaimp + REQHS3

    if !lLaser
      ? nLinhaimp
    else
      oPrinter:TextOut(nLinhaimp,.t.)
    endif

    if !lLaser
      ? replicate("-",80)
      ? "Produto         D e s c r i c a o            Un  Qtde      Unitario     Total  "
      ? replicate("-",80)
    else
      oPrinter:TextOut(replicate("-",80),.t.)
      oPrinter:TextOut("Produto         D e s c r i c a o            Un  Qtde      Unitario     Total  ",.t.)
      oPrinter:TextOut(replicate("-",80),.t.)
    endif


    BUSCAREGISTRO("AREQ01",1,{str(AREQ00->REQEMP, 2, 0),str(AREQ00->REQNUM, 6, 0),aspas(AREQ00->REQSER)},"SELECT")

    select AREQ01
    
    M_REQVLN = 0

    do while !eof()
      BUSCAREGISTRO("APCA00",1,{str(AREQ01->REQMAT,6,0)},"SELECT")
      select AREQ01


      nLinhaimp = " "
      nLinhaimp = nLinhaimp + str(AREQ01->REQMAT, 6, 0)
      nLinhaimp = nLinhaimp + " "
      nLinhaimp = nLinhaimp + chr(15)
      nLinhaimp = nLinhaimp + pad(APCA00->PCADES, 60)
      nLinhaimp = nLinhaimp + chr(18)
      nLinhaimp = nLinhaimp + " "
      nLinhaimp = nLinhaimp + pad(APCA00->PCAUNI, 02)
      nLinhaimp = nLinhaimp + " "
      nLinhaimp = nLinhaimp + transform(AREQ01->REQQDE,"@E #######")
      nLinhaimp = nLinhaimp + " "
      nLinhaimp = nLinhaimp + transform(AREQ01->REQPRB,"@E ###,###.##")
      nLinhaimp = nLinhaimp + " "
      nLinhaimp = nLinhaimp + transform(AREQ01->REQVLI,"@E ###,###.##")

      if !lLaser
        ? nLinhaimp
      else
        nLinhaimp = " "
        nLinhaimp = nLinhaimp + str(AREQ01->REQMAT, 6, 0)
        nLinhaimp = nLinhaimp + " "
        oPrinter:TextOut(nLinhaimp)
        oPrinter:SetFont( "Lucida Console", 10, { 3, 55 } )

*        oPrinter:SetPRC(oPrinter:PRow(),oPrinter:PCOL(),0)

        nLinhaimp = pad(APCA00->PCADES, 61)
        oPrinter:TextOut(nLinhaimp)
*        oPrinter:SetPRC(oPrinter:PRow(),oPrinter:PCOL(),0)
        oPrinter:SetFont( "Courier New", 11.5,0)  // normal

        nLinhaimp = " "
        nLinhaimp = nLinhaimp + pad(APCA00->PCAUNI, 02)
        nLinhaimp = nLinhaimp + " "
        nLinhaimp = nLinhaimp + transform(AREQ01->REQQDE,"@E #######")
        nLinhaimp = nLinhaimp + " "
        nLinhaimp = nLinhaimp + transform(AREQ01->REQPRB,"@E ###,###.##")
        nLinhaimp = nLinhaimp + " "
        nLinhaimp = nLinhaimp + transform(AREQ01->REQVLI,"@E ###,###.##")
        oPrinter:TextOut(nLinhaimp,.T.)
      endif

      M_TOTLIN = M_TOTLIN + 1
      M_REQVLN += AREQ01->REQVLI
      skip

    enddo

    if !lLaser
      for R = M_TOTLIN to 19
        ?
      next

      ? replicate("-",80)
      ? pad("EMITIDO: " + AREQ00->REQEMI,54)
      ?? "   Produto : R$ "
      ?? transform(AREQ00->REQVLP,"@E ###,###.##")
      ? "              "
      ?? iif(empty(AREQ00->REQVC2),space(08),AREQ00->REQVC2)
      ?? " "
      ?? transform(AREQ00->REQDP2,"@E@Z ###,###.##")
      ?? "  "
      ?? space(08)
      ?? " "
      ?? transform(AREQ00->REQDP5,"@E@Z ###,###.##")
      ?? "   Desconto: R$ "
      ?? transform(AREQ00->REQDSC,"@E ###,###.##")
      ? "              "
      ?? iif(empty(AREQ00->REQVC3),space(08),AREQ00->REQVC3)
      ?? " "
      ?? transform(AREQ00->REQDP3,"@E@Z ###,###.##")
      ?? "  "
      ?? space(08)
      ?? " "
      ?? transform(AREQ00->REQDP6,"@E@Z ###,###.##")
      ?? "   Total   : R$ "
      ?? chr(27) + "E"
      ?? transform(M_REQVLN-AREQ00->REQDSC,"@E ###,###.##")
      ?? chr(27) + "F"

      if A = 1
        ?
        ? replicate("-", 80)
        ?
      endif
    else
      for R = M_TOTLIN to 15
        oPrinter:TextOut("",.T.)
      next
      oPrinter:TextOut(replicate("-",80),.t.)

      nLinhaimp = pad("EMITIDO: " + AREQ00->REQEMI,54)
      nLinhaimp = nLinhaimp + "   Produto : R$ "
      nLinhaimp = nLinhaimp + transform(AREQ00->REQVLP,"@E ###,###.##")
      oPrinter:TextOut(nLinhaimp,.t.)

      nLinhaimp = "              "
      nLinhaimp = nLinhaimp + iif(empty(AREQ00->REQVC2),space(08),AREQ00->REQVC2)
      nLinhaimp = nLinhaimp + " "
      nLinhaimp = nLinhaimp + transform(AREQ00->REQDP2,"@E@Z ###,###.##")
      nLinhaimp = nLinhaimp + "  "
      nLinhaimp = nLinhaimp + space(08)
      nLinhaimp = nLinhaimp + " "
      nLinhaimp = nLinhaimp + transform(AREQ00->REQDP5,"@E@Z ###,###.##")
      nLinhaimp = nLinhaimp + "   Desconto: R$ "
      nLinhaimp = nLinhaimp + transform(AREQ00->REQDSC,"@E ###,###.##")
      oPrinter:TextOut(nLinhaimp,.t.)

      nLinhaimp = "              "
      nLinhaimp = nLinhaimp + iif(empty(AREQ00->REQVC3),space(08),AREQ00->REQVC3)
      nLinhaimp = nLinhaimp + " "
      nLinhaimp = nLinhaimp + transform(AREQ00->REQDP3,"@E@Z ###,###.##")
      nLinhaimp = nLinhaimp + "  "
      nLinhaimp = nLinhaimp + space(08)
      nLinhaimp = nLinhaimp + " "
      nLinhaimp = nLinhaimp + transform(AREQ00->REQDP6,"@E@Z ###,###.##")
      nLinhaimp = nLinhaimp + "   Total   : R$ "
      nLinhaimp = nLinhaimp + transform(M_REQVLN-AREQ00->REQDSC,"@E ###,###.##")
      oPrinter:TextOut(nLinhaimp,.t.)
      oPrinter:TextOut("",.t.)
      oPrinter:TextOut("",.t.)

    endif
  next

  if !lLaser
    ?
    ? "RECEBI DIA  ____/____/____     ASSIN. ______________________  "
    eject
    ?? chr(27) + "2"
    ?? chr(27) + "C" + chr(66)
    desliga1(,"F")
  else
    oPrinter:TextOut("",.T.)
    oPrinter:TextOut("RECEBI DIA  ____/____/____     ASSIN. ______________________  ",.T.)
    oPrinter:EndDoc()
    oPrinter:Destroy()
  endif

  exit

enddo

restore get from M_GETANT

restscreen(11, 25, 15, 54, M_TELA)

return ""

***************
function NUMREQ
***************

private M_NOME  ,;
        M_NSER  ,;
        M_TELA  ,;
        M_DATA  ,;
        M_NOVNUM,;
        M_NOVSER

M_TELA = savescreen(11, 25, 15, 54)

do while .t.

  sombra(11, 27, 14, 51,_SOMBRA_)

  set color to GR+/BG+
    @ 11, 27 say         "ÚÄÄÄÄÄNovo NumeroÄÄÄÄÄÄÄ¿"
    @ 12, 27 say         "³ Requisicao :          ³"
    @ 13, 27 say         "³ Serie Req. :          ³"
    @ 14, 27 say         "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
  set color to

  M_NOME = teclando(06, 12, 42,"GR+/BG+")
  M_NSER = teclando(02, 13, 42,"GR+/BG+")

  if lastkey() = 27
    exit
  endif

  M_NOVNUM = val(M_NOME)
  M_NOVSER = M_NSER      

  select AREQ00

  if dbseek(str(M_REQEMP, 2, 0) + str(M_NOVNUM, 6, 0) + M_NOVSER)
    msg("* * * REQUISICAO JA CADASTRADA * * *")
    loop
  endif

  M_FLG   = .f.
  M_REQNUM = M_NOVNUM
  M_REQSER = M_NOVSER

  set color to I
    @ 04, 12 say     M_REQNUM picture "######"  
    @ 04, 19 say     M_REQSER picture "@!"      
  set color to 

  if M_REQNUM = 0 
    loop
  endif

  if empty(M_REQSER)
    msg("* * * SERIE NAO PODE ESTAR VAZIA * * *")
    loop
  endif

  exit

enddo

restscreen(11, 25, 15, 54, M_TELA)

return ""

********************
function RET_ITENSRQ
********************

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"AKAR00","DELETE"}
  aadd(sqlCHAVE,{"KAREMP",str(M_REQEMP, 2)})
  aadd(sqlCHAVE,{"KARDOC",str(M_REQNUM, 9)})
  aadd(sqlCHAVE,{"KARSER",aspas(M_REQSER)})
  aadd(sqlCHAVE,{"KARCLF",str(M_REQCLI, 5)})
  executasql()

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"ADCR00","DELETE"}
  aadd(sqlCHAVE,{"DUPEMP",str(M_REQEMP, 2)})
  aadd(sqlCHAVE,{"DUPNUM",str(M_REQNUM, 6)})
  aadd(sqlCHAVE,{"DUPSER",aspas(M_REQSER)})
  executasql()

return ""

******************* 
function GRA_REQDCR                   && cria duplicatas contas a receber
******************* 

sqlCAMPO = {}
sqlCHAVE = {}
sqlARQUI = {"ADCR00","DELETE"}
aadd(sqlCHAVE,{"DUPEMP",str(nREQEMP,2)})
aadd(sqlCHAVE,{"DUPNUM",str(M_REQNUM,6)})
aadd(sqlCHAVE,{"DUPSER",aspas(M_REQSER)})
executasql()

for S = 1 to 6
  M_S = strzero(S, 1, 0)
  if M_REQDP&M_S > 0
    sqlCAMPO = {}
    sqlCHAVE = {}
    sqlARQUI = {"ADCR00","INSERT"}
    aadd(sqlCAMPO,{"DUPEMP",str(nREQEMP,2),.t.})
    aadd(sqlCAMPO,{"DUPNUM",str(M_REQNUM,6),.t.})
    aadd(sqlCAMPO,{"DUPORD",str(iif(ACPG00->CPGPAR=1, 0, S),2),.t.})
    aadd(sqlCAMPO,{"DUPCLI",str(M_REQCLI,5),.t.})
    aadd(sqlCAMPO,{"DUPNOM",M_REQNOM,.t.})
    aadd(sqlCAMPO,{"DUPDTE",formatdta(M_REQDTE),.t.})
    aadd(sqlCAMPO,{"DUPVCT",formatdta(M_REQVC&M_S),.t.})
    aadd(sqlCAMPO,{"DUPVEN",str(M_REQVEN,3),.t.})
    aadd(sqlCAMPO,{"DUPPOR",str(1,5),.t.})
    aadd(sqlCAMPO,{"DUPAPL",str(0,3),.t.})
    if M_REQ800 == "S" // aluguel
      aadd(sqlCAMPO,{"DUPOBS","PERIODO DE " + dtoc(M_REQVC5) + " A "  + dtoc(M_REQVC6),.t.})
    endif

    if M_REQCPG = 1
      aadd(sqlCAMPO,{"DUPVLP",str1(M_REQDP&M_S,2),.t.})
      aadd(sqlCAMPO,{"DUPVLA",str1(0,2),.t.})
      aadd(sqlCAMPO,{"DUPHIS",str(100,3),.t.})
      aadd(sqlCAMPO,{"DUPDTP",formatdta(date()),.t.})
    else
      aadd(sqlCAMPO,{"DUPHIS",str(500,3),.t.})
      aadd(sqlCAMPO,{"DUPVLA",str1(M_REQDP&M_S,2),.t.})
    endif

    aadd(sqlCAMPO,{"DUPNFS",str1(M_REQVLN,2),.t.})
    aadd(sqlCAMPO,{"DUPVLO",str1(M_REQDP&M_S,2),.t.})
    aadd(sqlCAMPO,{"DUPCPG",str(M_REQCPG,3),.t.})
    aadd(sqlCAMPO,{"DUPFISN",M_REQNATN,.t.})
    aadd(sqlCAMPO,{"DUPSER",M_REQSER,.t.})
    executasql()
  endif

  if M_REQDP&M_S > 0
    if M_REQCPG = 1
      sqlCAMPO = {}
      sqlCHAVE = {}
      sqlARQUI = {"ALCR00","INSERT"}
      aadd(sqlCAMPO,{"LANEMP",str(nREQEMP,2),.t.})
      aadd(sqlCAMPO,{"LANNUM",str(M_REQNUM,6),.t.})
      aadd(sqlCAMPO,{"LANORD",str(iif(ACPG00->CPGPAR=1, 0, S),2),.t.})
      aadd(sqlCAMPO,{"LANSER",M_REQSER,.t.})

      aadd(sqlCAMPO,{"LANHIS",str(100,3),.t.})
      aadd(sqlCAMPO,{"LANDTM",formatdta(date()),.t.})
      aadd(sqlCAMPO,{"LANCLI",str(M_REQCLI,5),.t.})
      aadd(sqlCAMPO,{"LANVAL",str1(M_REQDP&M_S,2),.t.})
      executasql()
    endif
  endif

next && S

return ""


******************* 
function GRA_RENOVA                   && cria duplicatas contas a receber
******************* 

sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {}
sqlORDEM = {}

aadd(sqlARQUI,{"ADCR00","ADCR00"})
aadd(sqlCAMPO,"DUPORD")
aadd(sqlCHAVE,"DUPEMP = " + str(nREQEMP,2))
aadd(sqlCHAVE,"DUPNUM = " + str(M_REQNUM,6))
sqlrelation()

nOrdem = 0
do while !eof()
  nOrdem = iif(nOrdem > DUPORD, nOrdem,DUPORD)
  skip
enddo

nOrdem ++

    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"ADCR00","INSERT"}

    aadd(sqlCAMPO,{"DUPEMP",str(nREQEMP,2),.t.})
    aadd(sqlCAMPO,{"DUPNUM",str(M_REQNUM,6),.t.})
    aadd(sqlCAMPO,{"DUPORD",str(nOrdem,2),.t.})
    aadd(sqlCAMPO,{"DUPCLI",str(M_REQCLI,5),.t.})
    aadd(sqlCAMPO,{"DUPNOM",M_REQNOM,.t.})
    aadd(sqlCAMPO,{"DUPDTE",formatdta(M_REQDTE),.t.})
    aadd(sqlCAMPO,{"DUPVCT",formatdta(M_REQVC1),.t.})
    aadd(sqlCAMPO,{"DUPVEN",str(M_REQVEN,3),.t.})
    aadd(sqlCAMPO,{"DUPPOR",str(1,5),.t.})
    aadd(sqlCAMPO,{"DUPAPL",str(0,3),.t.})
    aadd(sqlCAMPO,{"DUPOBS","PERIODO DE " + dtoc(M_REQVC5) + " A "  + dtoc(M_REQVC6),.t.})

    if M_REQCPG = 1
      aadd(sqlCAMPO,{"DUPVLP",str1(M_REQDP1,2),.t.})
      aadd(sqlCAMPO,{"DUPVLA",str1(0,2),.t.})
      aadd(sqlCAMPO,{"DUPHIS",str(100,3),.t.})
      aadd(sqlCAMPO,{"DUPDTP",formatdta(date()),.t.})
    else
      aadd(sqlCAMPO,{"DUPHIS",str(500,3),.t.})
      aadd(sqlCAMPO,{"DUPVLA",str1(M_REQDP1,2),.t.})
    endif

    aadd(sqlCAMPO,{"DUPNFS",str1(M_REQVLN,2),.t.})
    aadd(sqlCAMPO,{"DUPVLO",str1(M_REQDP1,2),.t.})
    aadd(sqlCAMPO,{"DUPCPG",str(M_REQCPG,3),.t.})
    aadd(sqlCAMPO,{"DUPFISN",M_REQNATN,.t.})
    aadd(sqlCAMPO,{"DUPSER",M_REQSER,.t.})
    executasql()
    
return ""

*****************
function LISREQ_N
***************** 

private M_REQ1 ,;
        M_REQ2 ,;
        M_SER1 ,;
        M_SER2 ,;
        LN     ,;
        PG     ,;
        M_ESC  ,;
        M_TELA
 
    do while .t.

        rodape("SINTETICO","REQUISI€AO",M_FAN,"EAGRO23","Mem: " + str(memory(0), 5),M_EMP) 

        store 0         to M_REQ1 ,;
                           M_REQ2

        store AEMP00->EMPRES to M_SER1 ,;
                                M_SER2

        store date()           to M_DTA1 ,;
                                  M_DTA2 

        store "3"              to M_REQIPL

       sombra(12, 41, 18, 73,_SOMBRA_)

       set color to B/W
         @ 12, 41 say                  "                                     " 
         @ 13, 41 say                  "   Nro Or‡amento Inicial:            " 
         @ 14, 41 say                  "                   Final:            " 
         @ 15, 41 say                  "    Data Emissao Inicial:            " 
         @ 16, 41 say                  "                   Final:            " 
         @ 17, 41 say                  " 1.Todas  2.Fat  3.A fat:            " 
         @ 18, 41 say                  "                                     " 
         @ 13, 67 get M_REQ1 picture "######"   color _COREDICAO_
         @ 13, 74 get M_SER1 picture "@!"   color _COREDICAO_
         @ 14, 67 get M_REQ2 picture "######"   color _COREDICAO_
         @ 14, 74 get M_SER2 picture "@!"    color _COREDICAO_
         @ 15, 67 get M_DTA1 color _COREDICAO_
         @ 16, 67 get M_DTA2 color _COREDICAO_
         @ 17, 67 get M_REQIPL valid(M_REQIPL $ "123") color _COREDICAO_
         read
       set color to

        if lastkey() = 27
          return ""
        endif

        M_REQ1 = iif(M_REQ1 = 0,     1,M_REQ1)
        M_REQ2 = iif(M_REQ2 = 0,999999,M_REQ2) 

        M_DTA1 = iif(dtoc(M_DTA1) = "  /  /  ",ctod("01/01/80"),M_DTA1)
        M_DTA2 = iif(dtoc(M_DTA2) = "  /  /  ",ctod("31/12/79"),M_DTA2) 

        select AREQ00

        set relation to REQNATN into AFIS00 ,;
                     to str(REQCLI, 7, 0)                     into ACLI00

        set order to 1

        set softseek on
          seek str(nREQEMP, 2, 0) + str(M_REQ1, 6, 0) + M_SER1
        set softseek off
       
        if eof()  .or. REQEMP != nREQEMP
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
                  LN,;
                  M_TOTPRO,M_TOTSER,M_PROPG,M_ALUPG


       cab_req1()                           && imprime cabecalho
       cab_req2()

       do while !eof()

          if str(REQEMP, 2, 0) + str(REQNUM, 6, 0) + REQSER > str(nREQEMP, 2, 0) + str(M_REQ2, 6, 0) + M_SER2
            go bottom
            skip
            loop
          endif

          if !M_REQIPL == "1"
            if M_REQIPL == "2"
              if !REQNATN == "5.104"
                skip 
                loop
              endif
            else
              if !REQNATN == "6.000"
                skip 
                loop
              endif
            endif 
          endif

          if REQDTE < M_DTA1 .or. REQDTE > M_DTA2
             skip
             loop
          endif

           ? str(REQNUM, 6, 0)
            ?? "  "
            ?? REQSER
            ?? " "
            ?? REQNATN
            ?? "  "
            ?? pad(AFIS00->FISNOM, 15) 
            ?? " " 
            ?? REQDTE
            ?? " "
            ?? str(REQCLI, 7, 0)
            ?? " "
            ?? left(ACLI00->CLINOM, 32)
            ?? " " 
            ?? transform(REQVLM,"@E@Z ###,###,###.##") 
            ?? " "
            ?? transform(REQVIC,"@E@Z ###,###,###.##") 
            ?? " "
            ?? transform(REQVIC+REQVLM,"@E@Z #,###,###.##") 

            M_TOTPRO += REQVLM
            M_TOTSER += REQVIC

            select ADCR00
            
            dbseek(str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0),.t.)

            do while !eof()
              if str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) == str(DUPEMP, 2, 0) + str(DUPNUM, 6, 0)
                if !DUPSER == "RQ" 
                  skip
                  loop
                endif
                if DUPHIS = 500
                else
                  ?? " PAGA"
                  if AREQ00->REQVLM > 0
                    if DUPVLP <= AREQ00->REQVLM
                      M_PROPG += DUPVLP
                    else
                      M_PROPG += AREQ00->REQVLM
                      M_ALUPG += DUPVLP-AREQ00->REQVLM
                    endif
                  else
                    M_ALUPG += DUPVLP
                  endif
                endif
              endif
              exit
            enddo

            select AREQ00

            LN = LN + 1

            if LN > 60
              cab_req1()
              cab_req2()
            endif  

            select AREQ00

            skip 

            if inkey() = 27
                if susimp()
                  ? replicate("-", 132)
                  ? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                endif
            endif

       enddo

       ? replicate("=", 132)

           ? space(06)
            ?? "  "
            ?? "  "
            ?? " "
            ?? space(06)
            ?? " "
            ?? space(20)
            ?? " " 
            ?? space(08)
            ?? " "
            ?? space(07)
            ?? " "
            ?? pad("          TOTAL GERAL -=> ",27)
            ?? " "         
            ?? transform(M_TOTPRO,"@E@Z ###,###,###.##") 
            ?? " "
            ?? transform(M_TOTSER,"@E@Z ###,###,###.##") 
            ?? " "
            ?? transform(M_TOTPRO+M_TOTSER,"@E@Z #,###,###.##") 

           ? space(06)
            ?? "  "
            ?? "  "
            ?? " "
            ?? space(06)
            ?? " "
            ?? space(20)
            ?? " " 
            ?? space(08)
            ?? " "
            ?? space(07)
            ?? " "
            ?? pad("          TOTAL PAGO  -=> ",27)
            ?? " " 
            ?? transform(M_PROPG,"@E@Z ###,###,###.##") 
            ?? " "
            ?? transform(M_ALUPG,"@E@Z ###,###,###.##") 
            ?? " "
            ?? transform(M_PROPG+M_ALUPG,"@E@Z #,###,###.##") 

           ? space(06)
            ?? "  "
            ?? "  "
            ?? " "
            ?? space(06)
            ?? " "
            ?? space(20)
            ?? " " 
            ?? space(08)
            ?? " "
            ?? space(07)
            ?? " "
            ?? pad("      TOTAL A RECEBER -=> ",27)
            ?? " " 
            ?? transform(M_TOTPRO-M_PROPG,"@E@Z ###,###,###.##") 
            ?? " "
            ?? transform(M_TOTSER-M_ALUPG,"@E@Z ###,###,###.##") 
            ?? " "
            ?? transform((M_TOTPRO+M_TOTSER)-(M_PROPG+M_ALUPG),"@E@Z #,###,###.##") 

       eject

desliga1()

enddo 

return "" 

*************
function LISREQ_H                  && relacao de vendas por produtos
*************

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

if file("AREQ02.CDX")                   
  erase("AREQ02.CDX")                   
endif

select 14         && req temporario

use AREQ02 alias AREQ02 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif


    rodape("REQUISICAO","PRODUTO",M_FAN,"EAGRO23","Mem: " + str(memory(0), 5),M_EMP)

    store date() to M_DATA1 ,;
                    M_DATA2

    store "S"    to M_TIPO, M_QUEFOR, M_IMPVAL

    M_PCAFOR = 0

     sombra(12, 41, 18, 67,_SOMBRA_)
     set color to B/W
       @ 12, 41 say                    "                           "
       @ 13, 41 say                    "      Fornecedor:          "
       @ 14, 41 say                    " Periodo Inicial:          "
       @ 15, 41 say                    "           Final:          "
       @ 16, 41 say                    "Quebra Fornecedo:          "
       @ 17, 41 say                    " Imprime Valores:          "
       @ 18, 41 say                    "                           "
     set color to 

     @ 13, 59 get     M_PCAFOR picture "9999999" color _COREDICAO_
     @ 14, 59 get     M_DATA1 color _COREDICAO_
     @ 15, 59 get     M_DATA2 color _COREDICAO_
     @ 16, 59 get     M_QUEFOR picture "@!" valid(M_QUEFOR $ "SN") color _COREDICAO_
     @ 17, 59 get     M_IMPVAL picture "@!" valid(M_IMPVAL $ "SN") color _COREDICAO_
     read

     if lastkey() = 27
        return ""
     endif

     store 0 to M_TOTGER

     select AREQ02

     if !flock()
       msg("* * * (AREQ02) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     if M_QUEFOR = "S"
       index on str(REQMAT, 6, 0)          tag 1 to AREQ02
       index on str(REQFOR, 7, 0) + REQDES tag 2 to AREQ02
     else
       index on str(REQMAT, 6, 0) tag 1 to AREQ02
       index on REQDES            tag 2 to AREQ02
     endif

     set index to AREQ02

     select AREQ00  // Le as requisicoes

        set order to 2 
         
        dbseek(str(nREQEMP, 2, 0) + dtos(M_DATA1),.t.)

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(REQEMP, 2, 0) + dtos(REQDTE) > str(nREQEMP, 2, 0) + dtos(M_DATA2)
            exit
          endif 

          if !REQNATN == "5.104"  // tem que ser venda
            skip
            loop
          endif
           
          select AREQ01

          dbseek(str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER,.t.)

          do while !eof()

            if str(AREQ01->REQEMP, 2, 0) + str(AREQ01->REQNUM, 6, 0) + AREQ01->REQSER > str(AREQ00->REQEMP, 2, 0) + str(AREQ00->REQNUM, 6, 0) + AREQ00->REQSER
              exit
            endif

            APCA00->(dbseek(str(AREQ01->REQMAT, 6, 0)))

            if APCA00->PCAGRP = 120 .or. APCA00->PCAGRP = 103 // aluguel - imobil
              skip
              loop
            endif

            if APCA00->PCAMAT = 1 // frete
              skip
              loop
            endif
            
            if M_PCAFOR > 0
              if APCA00->PCAFOR # M_PCAFOR
                skip
                loop
              endif
            endif 
 
            select AREQ02
            if !dbseek(str(AREQ01->REQMAT, 6, 0))
              append blank         
              replace REQFOR with APCA00->PCAFOR
              replace REQMAT with AREQ01->REQMAT
              replace REQDES with APCA00->PCADES
            endif

            replace REQQDE with REQQDE + AREQ01->REQQDE
            replace REQVLN with REQVLN + iif(AREQ01->REQLIQ=0,AREQ01->REQVLI,AREQ01->REQLIQ)
            replace REQVLI with REQVLI + iif(AREQ01->REQLIQ=0,AREQ01->REQVLI,AREQ01->REQLIQ)

            select AREQ01

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                return ""
              endif
            endif

            skip
 
          enddo
 
          select AREQ00
 
          skip

        enddo

        abre_nfs0( "2") && nfs mestre 4
        abre_nfs1( "3") && nfs itens  2

        select ANFS00  // Le as notas

        set order to 2 
         
        dbseek(str(1, 2, 0) + dtos(M_DATA1),.t.)

        msw("* * * PROCESSANDO NOTAS... (ESC) Cancela * * *")

        do while !eof()

          if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(1, 2, 0) + dtos(M_DATA2)
            exit
          endif 

          if NFSCAN == "C"
            skip
            loop
          endif
           
          if NFSCPG > 2 
            if NFSCPG < 10
              skip
              loop
            endif
          endif       
  
          select ANFS01

          dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER,.t.)

          do while !eof()

            if str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSNUM, 6, 0) + ANFS01->NFSSER > str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER
              exit
            endif

            APCA00->(dbseek(str(ANFS01->NFSMAT, 6, 0)))

            if APCA00->PCAGRP = 120 .or. APCA00->PCAGRP = 103 // aluguel - imobil
              skip
              loop
            endif

            if APCA00->PCAMAT = 1 // frete
              skip
              loop
            endif
            
            if M_PCAFOR > 0
              if APCA00->PCAFOR # M_PCAFOR
                skip
                loop
              endif
            endif 
 
            M_QDE = NFSQDE
            M_VAL = (ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP)/NFSQDE

            lDoped = .f.

            if ANFS01->NFSNATN = space(5)  // se foi emitido do pedido
              lDoped = .t.
              nNFSQDE = NFSQDE
            endif

            select AREQ02        
            if !dbseek(str(ANFS01->NFSMAT, 6, 0))
              append blank         
              replace REQFOR with APCA00->PCAFOR
              replace REQMAT with ANFS01->NFSMAT
              replace REQDES with APCA00->PCADES
            endif

            replace REQQDENT with REQQDENT + ANFS01->NFSQDE

            M_VALNOTA = ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP
            M_VALREQ  = REQVLN
            M_QDEREQ  = REQQDE

            if lDoped // se nota do pedido
              if ANFS01->NFSQDE <= REQQDE  // N=10 R=20
                replace REQQDE with REQQDE - ANFS01->NFSQDE
              else                         // N=20 R=10
                replace REQQDE with 0
                replace REQVLN with REQVLN + (M_QDEREQ * (M_VALNOTA / ANFS01->NFSQDE))
                replace REQVLI with REQVLI + (M_QDEREQ * (M_VALNOTA / ANFS01->NFSQDE))
              endif
            else
              replace REQVLN with REQVLN + M_VALNOTA
              replace REQVLI with REQVLI + M_VALNOTA
            endif

            select ANFS01

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                return ""
              endif
            endif

            skip
 
          enddo
 
          select ANFS00
 
          skip

        enddo

        abre_cup0( "2") && cup mestre 4
        abre_cup1( "3") && cup itens  2

        select ACUP00  // Le os cupons

        set order to 2
         
        dbseek(str(1, 2, 0) + dtos(M_DATA1),.t.)

        msw("* * * PROCESSANDO CUPONS... (ESC) Cancela * * *")

        do while !eof()

          if str(CUPEMP, 2) + dtos(CUPDTE) > str(1, 2) + dtos(M_DATA2)
            exit
          endif 

          if CUPCAN == "ZXC"
            skip
            loop
          endif
           
          if CUPCPG > 2 
            if CUPCPG < 10
              skip
              loop
            endif
          endif       
  
          select ACUP01

          dbseek(str(ACUP00->CUPEMP, 2) + str(ACUP00->CUPNUM, 6) + ACUP00->CUPSER,.t.)

          do while !eof()

            if str(ACUP01->CUPEMP, 2) + str(ACUP01->CUPNUM, 6) + ACUP01->CUPSER > str(ACUP00->CUPEMP, 2) + str(ACUP00->CUPNUM, 6) + ACUP00->CUPSER
              exit
            endif

            APCA00->(dbseek(str(ACUP01->CUPMAT, 6)))

            if APCA00->PCAGRP = 120 .or. APCA00->PCAGRP = 103 // aluguel - imobil
              skip
              loop
            endif

            if APCA00->PCAMAT = 1 // frete
              skip
              loop
            endif
            
            if M_PCAFOR > 0
              if APCA00->PCAFOR # M_PCAFOR
                skip
                loop
              endif
            endif 
 
            select AREQ02
            if !dbseek(str(ACUP01->CUPMAT, 6))
              append blank         
              replace REQFOR with APCA00->PCAFOR
              replace REQMAT with ACUP01->CUPMAT
              replace REQDES with APCA00->PCADES
            endif

            replace REQQDE with REQQDE + ACUP01->CUPQDE
            replace REQVLN with REQVLN + ACUP01->CUPLIQ
            replace REQVLI with REQVLI + ACUP01->CUPLIQ

            select ACUP01

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                return ""
              endif
            endif

            skip
 
          enddo
 
          select ACUP00
 
          skip

        enddo

        abre_req0( "2") && nfs mestre 4
        abre_req1( "3") && nfs itens  2
  
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
                    M_SOMPER ,; 
                    M_SOMQDE,; 
                    M_VENDIDO,;
                    M_COMPRA 
          
        select APCA00
        set order to 1
        select AFOR00
        set order to 1

        select AREQ02
        set relation to str(REQMAT, 6, 0) into APCA00,; 
                        str(REQFOR, 7, 0) into AFOR00

        set order to 2
        go top

        M_PROANT = 0
        M_FORANT = 0
        M_REQVLI = 0
        M_REQVLIS = 0

        AEMP00->(dbseek(str(1, 2, 0)))
        ?? chr(18)
        ?? chr(27) + "E"
        ? AEMP00->EMPNOM
        ? alltrim(AEMP00->EMPEND) + " - " + alltrim(AEMP00->EMPBAI)
        ? strzero(AEMP00->EMPCEP,5) + "-" + strzero(AEMP00->EMPCCE,3) + "  " + AEMP00->EMPMUN
        ? "Fone: " + AEMP00->EMPTEL
        ? 
        ? "PERIODO DE " + dtoc(M_DATA1) + " a " + dtoc(M_DATA2)
        ?? chr(15)
        ?? chr(27) + "F"
        AEMP00->(dbseek(str(nREQEMP, 2, 0)))

        LN = 6        
        
        do while !eof()
                              
            PG ++

            if PG > 1
              eject
              LN = 0
            endif

            ? "+------+------------------------------------------+-------+-------+-------+-------+-------+-------+-----------+-----------+-------+"
            ? "| COD  | DESCRICAO DO PRODUTO                     | SALDO | QTDE  | QTDE  | QTDE  | QTDE  | MEDIA | TOTAL     |  MEDIA    |ESTOQUE|"
            ? "| PROD |                                          |  ANT  | ENTR  | VEND  | TRANS | TOTAL |3 MESES|  R$       | UNITARIO  | FINAL |"
            ? "+------+------------------------------------------+-------+-------+-------+-------+-------+-------+-----------+-----------+-------+"

            LN += 4
  
            do while !eof() 
               
              if LN > 60
                exit
              endif 

              if M_QUEFOR = "S"
              if M_FORANT # REQFOR
                if M_REQVLI+M_REQVLIS > 0
                  ? "  Total Venda: "
                  ?? transform(M_REQVLI-M_REQVLIS,"@E@z ###,###,###.##")             
                  ?? "      Total Transferencia: "
                  ?? transform(M_REQVLIS,"@E@z ###,###,###.##")             
                  ?? "      Total Fornecedor. . "
                  ?? transform(M_REQVLI,"@E@z ###,###,###.##")             
                  M_REQVLI = 0
                  M_REQVLIS = 0
                  ? replicate("-",131)
                  LN += 2
                  if LN > 60 
                    eject
                    ? "+------+------------------------------------------+-------+-------+-------+-------+-------+-------+-----------+-----------+-------+"
                    ? "| COD  | DESCRICAO DO PRODUTO                     | SALDO | QTDE  | QTDE  | QTDE  | QTDE  | MEDIA | TOTAL     |  MEDIA    |ESTOQUE|"
                    ? "| PROD |                                          |  ANT  | ENTR  | VEND  | TRANS | TOTAL |3 MESES|  R$       | UNITARIO  | FINAL |"
                    ? "+------+------------------------------------------+-------+-------+-------+-------+-------+-------+-----------+-----------+-------+"
                    LN = 4
                  endif
                endif
                ? AFOR00->FORNOM
                ? 
                LN += 2
                M_FORANT = REQFOR
                if LN > 60 
                  eject
                  ? "+------+------------------------------------------+-------+-------+-------+-------+-------+-------+-----------+-----------+-------+"
                  ? "| COD  | DESCRICAO DO PRODUTO                     | SALDO | QTDE  | QTDE  | QTDE  | QTDE  | MEDIA | TOTAL     |  MEDIA    |ESTOQUE|"
                  ? "| PROD |                                          |  ANT  | ENTR  | VEND  | TRANS | TOTAL |3 MESES|  R$       | UNITARIO  | FINAL |"
                  ? "+------+------------------------------------------+-------+-------+-------+-------+-------+-------+-----------+-----------+-------+"
                  LN = 4
                endif
              endif
              endif
              
              M_SLD = 0
              M_CPA = 0
              M_SLD51 = 0
              M_CPA51 = 0
              M_MEDMES = 0

              M_PROANT = REQMAT
              saldoant()
              M_COMPRA += M_CPA

             select AREQ02

             ? " "
             ?? iif(APCA00->PCAMAT = 0, str(REQMAT, 6), str(APCA00->PCAMAT,6))
             ?? " " 
             ?? pad(APCA00->PCADES , 42)
             ?? " " 
             ?? str(M_SLD+M_SLD51,7)
             ?? " "
             ?? str(M_CPA+M_CPA51,7)
             ?? " "
             ?? str(REQQDENT,7)
             ?? " "
             ?? str(REQQDE,7)
             ?? " "
             ?? str(REQQDE+REQQDENT,7)
             ?? " "
             ?? str(M_MEDMES/3,7)
             ?? " "
             if M_IMPVAL = "S"
               ?? transform(REQVLN,"@E@Z ####,###.##")
               ?? " "
               ?? transform(REQVLN/(REQQDE+REQQDENT),"@E@Z ####,###.##")
             else
               ?? space(23)
             endif
             ?? " "
             ?? str(M_SLD+M_CPA+M_SLD51+M_CPA51-REQQDE-REQQDENT,7)

             M_VENDIDO = 0

             LN ++

             M_REQVLI += REQVLN       
             M_REQVLIS += REQVLI       
             M_SOMPER = M_SOMPER + REQVLN
             M_SOMQDE = M_SOMQDE + REQQDE

             skip
         
             if inkey() = 27
                if susimp()
                  ? replicate("-", 132)
                  ? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                endif
             endif

          enddo

      enddo

      if M_QUEFOR = "S" .and. M_IMPVAL = "S"
        if M_REQVLI+M_REQVLIS > 0
          ? "  Total Venda: "
           ?? transform(M_REQVLI-M_REQVLIS,"@E@z ###,###,###.##")             
           ?? "      Total Transferencia: "
           ?? transform(M_REQVLIS,"@E@z ###,###,###.##")             
           ?? "      Total Fornecedor. . "
           ?? transform(M_REQVLI,"@E@z ###,###,###.##")             
           M_REQVLI = 0
           M_REQVLIS = 0
        endif
      endif

      if M_IMPVAL = "S"
        ? replicate("-", 132)
        ? space(76)
         ?? "TOTAL GERAL . . . . "
         ?? transform(M_SOMPER,"@E@z ###,###,###.##")
      endif

    eject

    unlock all

select 14
use

desliga1()

return ""


function ACEREQ

select AREQ00
set order to 1


aJUSTE = {}
aadd(aJUSTE,{54697,"25/09/2019","25/10/2019"})
aadd(aJUSTE,{55228,"21/09/2019","21/10/2019"})
aadd(aJUSTE,{53163,"24/07/2019","24/08/2019"})
aadd(aJUSTE,{54064,"09/10/2019","08/11/2019"})
aadd(aJUSTE,{56313,"26/10/2019","26/11/2019"})
aadd(aJUSTE,{56068,"28/10/2019","28/11/2019"})
aadd(aJUSTE,{55785,"29/10/2019","29/11/2019"})
aadd(aJUSTE,{54677,"20/10/2019","20/11/2019"})
aadd(aJUSTE,{56587,"22/10/2019","22/11/2019"})
aadd(aJUSTE,{56063,"28/09/2019","28/10/2019"})
aadd(aJUSTE,{54549,"24/10/2019","24/11/2019"})
aadd(aJUSTE,{53837,"17/10/2019","17/11/2019"})
aadd(aJUSTE,{54417,"21/10/2019","21/11/2019"})
aadd(aJUSTE,{56781,"29/11/2019","09/12/2019"})
aadd(aJUSTE,{54047,"03/12/2019","03/01/2020"})
aadd(aJUSTE,{54009,"26/11/2019","26/12/2019"})
aadd(aJUSTE,{56624,"29/11/2019","14/12/2019"})
aadd(aJUSTE,{55846,"13/11/2019","13/12/2019"})
aadd(aJUSTE,{55704,"11/11/2019","11/12/2019"})
aadd(aJUSTE,{56754,"22/11/2019","22/12/2019"})
aadd(aJUSTE,{56743,"22/11/2019","22/12/2019"})
aadd(aJUSTE,{56594,"23/11/2019","23/12/2019"})
aadd(aJUSTE,{56046,"25/11/2019","25/12/2019"})
aadd(aJUSTE,{56759,"25/11/2019","25/12/2019"})
aadd(aJUSTE,{56351,"02/12/2019","02/01/2020"})
aadd(aJUSTE,{56468,"29/11/2019","29/12/2019"})
aadd(aJUSTE,{56656,"05/12/2019","05/01/2020"})
aadd(aJUSTE,{56720,"16/11/2019","16/12/2019"})
aadd(aJUSTE,{56723,"16/11/2019","16/12/2019"})
aadd(aJUSTE,{56648,"01/11/2019","01/12/2019"})
aadd(aJUSTE,{56066,"28/10/2019","28/11/2019"})
aadd(aJUSTE,{56376,"06/11/2019","06/12/2019"})
aadd(aJUSTE,{56722,"16/11/2019","16/12/2019"})
aadd(aJUSTE,{56613,"26/10/2019","26/11/2019"})
aadd(aJUSTE,{56635,"30/10/2019","30/11/2019"})
aadd(aJUSTE,{56686,"11/11/2019","11/12/2019"})
aadd(aJUSTE,{56659,"05/11/2019","05/12/2019"})
aadd(aJUSTE,{56651,"04/11/2019","04/12/2019"})
aadd(aJUSTE,{56750,"22/11/2019","22/12/2019"})
aadd(aJUSTE,{56599,"22/11/2019","22/12/2019"})
aadd(aJUSTE,{56330,"29/11/2019","29/12/2019"})
aadd(aJUSTE,{55713,"12/11/2019","12/12/2019"})
aadd(aJUSTE,{56715,"14/11/2019","14/12/2019"})
aadd(aJUSTE,{56367,"05/11/2019","05/12/2019"})
aadd(aJUSTE,{56372,"06/11/2019","06/12/2019"})
aadd(aJUSTE,{56571,"12/11/2019","02/12/2019"})
aadd(aJUSTE,{56756,"23/11/2019","23/12/2019"})
aadd(aJUSTE,{56752,"22/11/2019","07/12/2019"})
aadd(aJUSTE,{56751,"22/11/2019","07/12/2019"})
aadd(aJUSTE,{56747,"22/11/2019","07/12/2019"})
aadd(aJUSTE,{56106,"08/11/2019","08/12/2019"})
aadd(aJUSTE,{56500,"03/11/2019","03/12/2019"})
aadd(aJUSTE,{50673,"07/11/2019","07/12/2019"})
aadd(aJUSTE,{50632,"13/11/2019","13/12/2019"})
aadd(aJUSTE,{56657,"05/11/2019","05/12/2019"})
aadd(aJUSTE,{56335,"30/10/2019","30/11/2019"})
aadd(aJUSTE,{55984,"16/11/2019","16/12/2019"})
aadd(aJUSTE,{56590,"23/11/2019","23/12/2019"})
aadd(aJUSTE,{56735,"19/11/2019","19/12/2019"})
aadd(aJUSTE,{56111,"09/11/2019","09/12/2019"})
aadd(aJUSTE,{56760,"25/11/2019","25/12/2019"})
aadd(aJUSTE,{55587,"18/11/2019","18/12/2019"})
aadd(aJUSTE,{56706,"13/11/2019","13/12/2019"})
aadd(aJUSTE,{56690,"11/11/2019","11/12/2019"})
aadd(aJUSTE,{56664,"06/11/2019","06/12/2019"})
aadd(aJUSTE,{56347,"10/11/2019","10/12/2019"})
aadd(aJUSTE,{56035,"21/08/2019","21/09/2019"})
aadd(aJUSTE,{56537,"14/11/2019","14/12/2019"})
aadd(aJUSTE,{56650,"04/12/2019","04/01/2020"})
aadd(aJUSTE,{56647,"01/11/2019","01/12/2019"})
aadd(aJUSTE,{56655,"07/11/2019","07/12/2019"})
aadd(aJUSTE,{54064,"09/12/2019","09/01/2020"})
aadd(aJUSTE,{55946,"29/10/2019","29/11/2019"})
aadd(aJUSTE,{54963,"10/11/2019","10/12/2019"})
aadd(aJUSTE,{56529,"11/11/2019","11/12/2019"})
aadd(aJUSTE,{56510,"05/11/2019","05/12/2019"})
aadd(aJUSTE,{56697,"13/11/2019","13/12/2019"})
aadd(aJUSTE,{56319,"28/11/2019","28/12/2019"})
aadd(aJUSTE,{56511,"07/11/2019","07/12/2019"})
aadd(aJUSTE,{56520,"07/11/2019","07/12/2019"})
aadd(aJUSTE,{56758,"23/11/2019","23/12/2019"})
aadd(aJUSTE,{56753,"22/11/2019","22/12/2019"})
aadd(aJUSTE,{56736,"19/11/2019","19/12/2019"})
aadd(aJUSTE,{56749,"22/11/2019","22/12/2019"})
aadd(aJUSTE,{56581,"21/11/2019","21/12/2019"})
aadd(aJUSTE,{54091,"13/11/2019","13/12/2019"})
aadd(aJUSTE,{56090,"04/11/2019","04/12/2019"})
aadd(aJUSTE,{56502,"04/11/2019","04/12/2019"})
aadd(aJUSTE,{55991,"07/11/2019","07/12/2019"})
aadd(aJUSTE,{54199,"08/11/2019","08/12/2019"})
aadd(aJUSTE,{56278,"19/11/2019","19/12/2019"})
aadd(aJUSTE,{56643,"01/11/2019","01/12/2019"})
aadd(aJUSTE,{56666,"06/11/2019","06/12/2019"})
aadd(aJUSTE,{55753,"22/11/2019","22/12/2019"})
aadd(aJUSTE,{56153,"17/11/2019","17/12/2019"})
aadd(aJUSTE,{54831,"26/11/2019","26/12/2019"})
aadd(aJUSTE,{55002,"01/11/2019","01/12/2019"})
aadd(aJUSTE,{55080,"19/10/2019","19/11/2019"})
aadd(aJUSTE,{56709,"14/11/2019","14/12/2019"})
aadd(aJUSTE,{56461,"20/11/2019","20/12/2019"})
aadd(aJUSTE,{56693,"11/11/2019","11/12/2019"})
aadd(aJUSTE,{56612,"26/11/2019","26/12/2019"})
aadd(aJUSTE,{55529,"06/11/2019","06/12/2019"})
aadd(aJUSTE,{49222,"26/11/2019","26/12/2019"})
aadd(aJUSTE,{56769,"27/11/2019","27/12/2019"})
aadd(aJUSTE,{56249,"12/11/2019","12/12/2019"})
aadd(aJUSTE,{56630,"29/10/2019","29/11/2019"})
aadd(aJUSTE,{56435,"19/12/2019","19/01/2020"})

msg("PROCESSANDO PRESSIONE")

for ABC = 1 to len(aJUSTE)

  msG(str(aJUSTE[ABC][1],6))

  if dbseek(str(nREQEMP,2,0) + str(aJUSTE[ABC][1],6,0) + "RQ")
    do while .t.
      if rlock()
        replace REQFRC with "S"
        replace REQVC5 with ctod(aJUSTE[ABC][2])
        replace REQVC6 with ctod(aJUSTE[ABC][3])
        unlock
        exit
      endif
    enddo
  endif
next

return ""

*****************
function LISALUGUEL                    && relacao de vendas por produtos
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
    
rodape("REQUISICAO","ALUGUEL",M_FAN,"EAGRO23","Mem: " + str(memory(0), 5),M_EMP) 


store date() to M_DATA1

sombra(13, 41, 15, 70,_SOMBRA_)
set color to B/W
  @ 13, 41 say                    "                              " 
  @ 14, 41 say                    " Vencimento ate:              " 
  @ 15, 41 say                    "                              " 
set color to 
@ 14, 62 get     M_DATA1  color _COREDICAO_
read

if lastkey() = 27
  return ""
endif

sqlRELATION = {}
sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {}
sqlORDEM = {}


aadd(sqlARQUI,{"AREQ00","AREQ00"})
aadd(sqlCAMPO,"AREQ00.*")
aadd(sqlCAMPO,"AREQ01.REQMAT")
aadd(sqlCAMPO,"AREQ01.REQSEQ")
aadd(sqlCAMPO,"AREQ01.REQQDE")
aadd(sqlCAMPO,"AREQ01.REQPRB")
aadd(sqlCAMPO,"AREQ01.REQVLI")
aadd(sqlCAMPO,"APCA00.PCADES")
aadd(sqlCAMPO,"APCA00.PCAREF")
aadd(sqlCAMPO,"ACLI00.CLINOM")
aadd(sqlRELATION,{"AREQ01","AREQ01.REQEMP","AREQ00.REQEMP"})
aadd(sqlRELATION,{"","AREQ01.REQNUM","AREQ00.REQNUM"})
aadd(sqlRELATION,{"","AREQ01.REQSER","AREQ00.REQSER"})
aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","AREQ01.REQMAT"})
aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","AREQ00.REQCLI"})
aadd(sqlCHAVE,"AREQ00.REQVC6 <= " + aspas(formatdta(M_DATA1)))
aadd(sqlCHAVE,"AREQ00.REQEMP = " + str(nREQEMP, 2, 0))
aadd(sqlORDEM,"REQVC6 desc, REQNUM")
if !sqlrelation()
  msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
  return ""
endif
                
M_IMPRE = impresn()

if M_IMPRE = "N"
  return ""
endif

?? chr(18)                        && comprime

store  0 to PG, LN 
          
cab_alug()
?

do while !eof() 

  if LN > 60
    cab_alug()
  endif

  ? str(REQNUM, 6, 0)
  ?? " "
  ?? str(REQCLI, 6, 0)
  ?? " "
  ?? left(CLINOM, 32)
  ?? " "
  ?? transform(REQVLN,"@E ###,###.##") 
  ?? " "
  ?? REQVC5
  ?? " "
  ?? REQVC6
  ?

  LN += 2


  M_REQNUM = REQNUM

  do while !eof()

    if !str(M_REQNUM,6) == str(REQNUM,6)
      exit
    endif

    ? transform(str(REQMAT, 6, 0),"@R 999999")
    ?? " " 
    ?? PCADES
    ?? " " 
    ?? str(REQQDE,3)
    ?? " "
    ?? transform(REQPRB,"@E #####.##") 
    ?? " "
    ?? transform(REQVLI,"@E ##,###.##") 
                       
    LN = LN + 1

    if LN > 60 
      cab_alug()
    endif
  
    skip 

  enddo

  ? replicate("-",80)
  LN ++

enddo

eject

desliga1()

return ""

*****************
function CAB_ALUG
*****************

 PG = PG + 1

 if PG > 1
   eject
 endif

 ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE ALUGUEIS","EAGRO23",80) 
 ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 80)

 LN = 2

return ""
*****************
function SALDOANT
*****************

   M_DTAMED = M_DATA2-90
   M_MEDMES = 0
   M_PARTIDA = ctod("18/05/2006")

    select AKAR00
    dbseek(str(1, 2, 0) + str(APCA00->PCAMAT, 6, 0), .t.)

    M_SLD = 0
    M_CPA = 0

    do while !eof()

      if str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) > str(1, 2, 0) + str(APCA00->PCAMAT, 6, 0) + dtos(M_DATA2)
        exit
      endif

      msw("* * * Aguarde... Processando: " + str(KARMAT, 6) + " " + dtoc(KARDTA) + " * * *")

      AFIS00->(dbseek(AKAR00->KARFISN))

      if KARDTA > M_DTAMED
        if AFIS00->FISEST = "D"
          M_MEDMES = M_MEDMES + KARQDE
        endif
      endif

      if str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) < str(1, 2, 0) + str(APCA00->PCAMAT, 6, 0) + dtos(M_DATA1)
        if KARFISN = "1.000"
          M_SLD    = KARQDE
        else
          if AFIS00->FISEST = "D"
            M_SLD = M_SLD - KARQDE
          else
            if AFIS00->FISEST = "C"
              M_SLD = (M_SLD + KARQDE)
            endif
          endif
        endif
      else
        if str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) <= str(1, 2, 0) + str(APCA00->PCAMAT, 6, 0) + dtos(M_DATA2)
          if AFIS00->FISEST = "C"
            M_CPA += KARQDE
          endif
        endif
      endif
      skip
    enddo

    select AKAR00
    dbseek(str(nREQEMP, 2, 0) + str(APCA00->PCAMAT, 6, 0), .t.)

    M_SLD51 = 0
    M_CPA51 = 0

    do while !eof()

      if str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) > str(51, 2, 0) + str(APCA00->PCAMAT, 6, 0) + dtos(M_DATA2)
        exit
      endif

      AFIS00->(dbseek(AKAR00->KARFISN))

      if KARDTA >= M_PARTIDA
        if dtos(KARDTA) > dtos(M_DTAMED)
          if AFIS00->FISEST = "D"
            M_MEDMES = M_MEDMES + KARQDE
          endif
        endif
      endif

      if str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) < str(51, 2, 0) + str(APCA00->PCAMAT, 6, 0) + dtos(M_DATA1)
        if KARFISN == "1.000"
          M_SLD51    = KARQDE
        else
          if AFIS00->FISEST = "D"
            M_SLD51 = M_SLD51 - KARQDE
          else
            if AFIS00->FISEST = "C"
              M_SLD51 = (M_SLD51 + KARQDE)
            endif
          endif
        endif
      else
        if str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) <= str(51, 2, 0) + str(APCA00->PCAMAT, 6, 0) + dtos(M_DATA2)
          if AFIS00->FISEST = "C"
            M_CPA51 += KARQDE
          endif
        endif
      endif
      skip
    enddo

    return ""

***************
function REQDIA
***************

local ltela := savescreen(0,0,24,80)
!req.exe
restscreen(0,0,24,80,ltela)

return ""

*******************
function PEGACLIIND                      && consumidor
*******************

private M_TELA

M_TELA = savescreen(09, 17, 14, 70)

sombra(09, 17, 13, 69,_SOMBRA_)

setcolor("GR/BG")
  @ 09, 17 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
  @ 10, 17 say "³Cliente :                                          ³"
  @ 11, 17 say "³Indicado:                                          ³"
  @ 12, 17 say "³0800 S/N:                                          ³"
  @ 13, 17 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
setcolor("")

_FUNCLI1_ = _FUNCLI_

_FUNCLI_ = "KEYBOARD.t."

do while .t.
  @ 10, 28 get M_PACIENTE picture "@!"  color _COREDICAO_
  @ 11, 28 get M_INDICADO picture "@!" color _COREDICAO_
  @ 12, 28 get M_SN0800   picture "@!" valid M_SN0800 $ "SN" color _COREDICAO_
  read

  msg("* * * (ENTER) Continua  (PgDn) Sai * * *")

  if lastkey() = 3
    exit
  endif

enddo

_FUNCLI_ = _FUNCLI1_

restscreen(09, 17, 14, 70, M_TELA)


return ""

****************
function ALTITEM  && altera item da nota
****************


  M_REQMAT[M_OPC][9] = "N"

  edreq04(8 + M_LINPOS,M_OPC)

  LNPRO = 0

  for S = 1 to len(M_REQMAT)
    APCA00->(dbseek(str(M_REQMAT[S, 2], 6, 0)))
    M_VETORITE[S] = str(M_REQMAT[S, 1], 2, 0) + " " + ;
                    str(M_REQMAT[S, 2], 6, 0) + " " + ;
                    pad(M_REQMAT[S ,7], 31)   + " " + ;
                    str(M_REQMAT[S, 3], 9, 0) + " " + ;
                    str(M_REQMAT[S, 4],10, 2) + " " + ;
                    str(M_REQMAT[S, 5],10, 2)
  next

  APCA00->(dbseek(str(M_REQMAT[M_OPC, 2], 6, 0)))

  M_LINPOS = 0

return ""

*****************
function TIRAITEM && deleta item da nota
*****************

private M_REQ, R

M_REQ = alert("Confirma Exclusao deste Item",{"Nao","Sim"})

if M_REQ != 2
  return ""
endif

aadd(M_REQDEL,M_REQMAT[M_OPC][12])  // excluir este item

adel(M_REQMAT,M_OPC)
adel(M_VETORITE,M_OPC)

asize(M_REQMAT,len(M_REQMAT) - 1)
asize(M_VETORITE,len(M_VETORITE) - 1)

declare M_VETORITE[len(M_REQMAT)]

for S = 1 to len(M_REQMAT)
    M_REQMAT[S, 1]  = S
    APCA00->(dbseek(str(M_REQMAT[S, 2], 6, 0)))
    M_VETORITE[S] = str(M_REQMAT[S, 1], 2, 0) + " " + ;
                    str(M_REQMAT[S, 2], 6, 0) + " " + ;
                    pad(M_REQMAT[S ,7], 31)   + " " + ;
                    str(M_REQMAT[S, 3], 9, 0) + " " + ;
                    str(M_REQMAT[S, 4],10, 2) + " " + ;
                    str(M_REQMAT[S, 5],10, 2)

next

  setcolor("I")
    for zz = 08 to 19
    @ zz, 02 say     "                                                                           "
    next
  setcolor("")


M_LINPOS = 0

return ""

*****************
function NOVOITEM && insere item na nota
*****************

  R = len(M_REQMAT) + 1
  L = 8

  setcolor("I")
    for zz = 08 to 19
    @ zz, 02 say     "                                                                           "
    next
  setcolor("")

  do while .t.

    aadd(M_REQMAT,{0,  0,  0,  0,  0,  0,space(40),0,"N",space(40),space(20),0," "})

    M_REQMAT[R, 1] = lSeq
    M_REQMAT[R, 8] = lSeq

    edreq04(L,R)

    if lastkey() = 27
      adel(M_REQMAT,R)
      asize(M_REQMAT,len(M_REQMAT) - 1)
      exit
    endif

    APCA00->(dbseek(str(M_REQMAT[R, 2], 6, 0)))
    if APCA00->PCAFOR = 40702 // ABBOTT
      M_PACIENTE = M_REQMAT[M_OPC][10]
      M_INDICADO = M_REQMAT[M_OPC][11]
      M_SN0800   = M_REQMAT[M_OPC][13]
      pegacliind()
      M_REQMAT[M_OPC,10] = M_PACIENTE
      M_REQMAT[M_OPC,11] = M_INDICADO
      M_REQMAT[M_OPC,13] = M_SN0800
    endif

    if L = 19
      lpreq01()
      L = 7
    endif

    R ++
    L ++
    lSeq ++

    if lSeq > 98
      alert("LIMITE DE ITENS ESGOTADO;SALVE ESTA REQUISICAO;;AO ABRIR NOVAMENTE;SERA CRIADO;UMA NOVA REQUISICAO")
      exit
    endif

  enddo

  setcolor("I")
    for zz = 08 to 19
    @ zz, 02 say     "                                                                           "
    next
  setcolor("")


  asize(M_VETORITE, R)
  ains(M_VETORITE, len(M_VETORITE))

  for S = 1 to len(M_REQMAT)
    APCA00->(dbseek(str(M_REQMAT[S, 2], 6, 0)))
    M_VETORITE[S] = str(M_REQMAT[S, 1], 2, 0) + " " + ;
                    str(M_REQMAT[S, 2], 6, 0) + " " + ;
                    pad(M_REQMAT[S ,7], 31)   + " " + ;
                    str(M_REQMAT[S, 3], 9, 0) + " " + ;
                    str(M_REQMAT[S, 4],10, 2) + " " + ;
                    str(M_REQMAT[S, 5],10, 2)
  next

  M_LINPOS = 0

return ""

*******************
function GRREQITENS
*******************

private M_DEL,R

// vamos excluir os itens alterados, excluidos

if len(M_REQDEL) > 0
  for M_DEL = 1 to len(M_REQDEL)
    if M_REQDEL[M_DEL] > 0
      select AREQ01TM
      go M_REQDEL[M_DEL]
      MS = strzero(AREQ01TM->REQEMP,2)
      select APCA00

      if dbseek(str(AREQ01TM->REQMAT, 6, 0))
        do while .t.
          if rlock()
            replace SLD&MS with (SLD&MS + AREQ01TM->REQQDE)
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

      select AKAR00
      dbseek(str(AREQ01TM->REQEMP, 2, 0) + str(AREQ01TM->REQMAT, 6, 0) + dtos(AREQ00TM->REQDTE) + AREQ00TM->REQNATN + str(AREQ01TM->REQNUM, 6, 0) + AREQ01TM->REQSER,.t.)

      if str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) + KARFISN + str(KARDOC, 6, 0) + KARSER == str(AREQ01TM->REQEMP, 2, 0) + str(AREQ01TM->REQMAT, 6, 0) + dtos(AREQ00TM->REQDTE) + AREQ00TM->REQNATN + str(AREQ01TM->REQNUM, 6, 0) + AREQ01TM->REQSER
        elimina()
      endif

      select AREQ01TM

      elimina()
    endif
  next
endif

for R = 1 to len(M_REQMAT)

  if M_REQMAT[R][9] == "J" // ja existe nao precisa gravar de novo
    loop
  endif

  select AREQ01TM                      && seleciona REQ itens
  _append("AREQ01TM")

  do while .t.
    if rlock()
      replace REQEMP   with M_REQEMP
      replace REQNUM   with M_REQNUM
      replace REQSER   with M_REQSER
      replace REQSEQ   with M_REQMAT[R, 8]
      replace REQMAT   with M_REQMAT[R, 2]
      replace REQQDE   with M_REQMAT[R, 3]
      replace REQPRB   with M_REQMAT[R, 4]
      replace REQVLI   with M_REQMAT[R, 5]
      replace REQLIQ   with M_REQMAT[R, 6]
      replace PACIENTE with M_REQMAT[R,10]
      replace INDICADO with M_REQMAT[R,11]
      replace SN0800   with M_REQMAT[R,13]
      replace REQCLI   with M_REQCLI
      replace REQDTE   with M_REQDTE
      replace REQIPL   with M_REQIPL
      unlock
      exit
    else
      msg("* * * (AREQ01) REGISTRO SENDO USADO * * *")
    endif
    if lastkey()=17
      exit
    endif
  enddo

  select AKAR00
  _append("AKAR00")
  do while .t.
    if rlock()
      replace KAREMP       with M_REQEMP
      replace KARMAT       with M_REQMAT[R,2]
      replace KARDTA       with M_REQDTE
      replace KARFISN      with M_REQNATN
      replace KARDOC       with M_REQNUM
      replace KARSER       with M_REQSER
      replace KARSEQ       with M_REQMAT[R,1]
      replace KARQDE       with M_REQMAT[R,3]
      replace KARPRB       with M_REQMAT[R,4]
      replace KARVLI       with M_REQMAT[R,6]
      replace KARCLF       with M_REQCLI
      replace KARICM       with 0
      replace KARIPI       with 0
      replace KARDSP       with 0
      unlock
      exit
    else
      msg("* * * (AKAR00) REGISTRO SENDO USADO * * *")
    endif
    if lastkey()=27
      exit
    endif
  enddo

  MS = strzero(M_REQEMP,2)
  select APCA00            && procura saldo da peca
  if dbseek(str(M_REQMAT[R,2], 6, 0))
    do while .t.
      if rlock()
        replace SLD&MS with ( SLD&MS - M_REQMAT[R,3] )
        unlock
        exit
      else
        msw("* * * (APCA00) REGISTRO SENDO USADO * * *")
      endif
      if lastkey() = 17
        exit
      endif
    enddo
  endif

next && R

commit

return ""

***************
function MOSREQ2
***************

parameters  M_MODO, M_ELEM, M_POSI

  if str(lastkey(), 2, 0) $ " 3#27#18"
    return 0
  endif

  nPosach  = M_ELEM

  if str(lastkey(), 3, 0)  $ "# 49# 50# 51# 52# 53# 54# 13"
    M_OPC = M_ELEM
    return 1
  endif

  set color to GR+
    @ 24, 00 say "                     <1>.Total   <3>.Deleta   <4>.Adiciona   <6>.Sair"
  set color to R+
    @ 24, 22 say "1"
    @ 24, 34 say "3"
    @ 24, 47 say "4"
    @ 24, 62 say "6"
  set color to N/W,W+/N

  M_LINPOS = M_POSI


return 2

*****************
function CONTRATO
*****************
    lLaser = .t.
    oPrinter := Win32Prn():New( )
    oPrinter:Landscape := .F.
    oPrinter:FormType  := 9
    inicio_impressao()

    oPrinter:SetFont( "Times New Roman", 11.5,0)  // normal

*    oPrinter:LineHeight := Int( oPrinter:PixelsPerInchY / 7 )  // Default 6 lines per inch == # of pixels per line

  oPrinter:TextOut("",.t.)
  oPrinter:bold( FW_BOLD )
  oPrinter:TextOut(" Data da Locação: ",.T.)
  oPrinter:TextOut("         Cliente: ",.T.)
  oPrinter:TextOut("        Endereço: ",.T.)
  oPrinter:TextOut("          Cidade:                                            CEP:",.T.)
  oPrinter:TextOut("        CNPJ/CPF:                                       Telefone:",.T.)
  oPrinter:TextOut("",.T.)

  oPrinter:TextOut(" Código   Descrição do Produto                Dias             Valor Total",.T.)
  oPrinter:TextOut("",.T.)
  oPrinter:TextOut("",.T.)
  oPrinter:TextOut("              Valor Total:",.T.)
  oPrinter:TextOut(" Taxa de Entrega/Retirada:",.T.)
  oPrinter:TextOut("   Valor Total da Locação:",.T.)
  oPrinter:TextOut("",.T.)

  oPrinter:TextOut(" Contrato de Locação nº:",.T.)
  oPrinter:TextOut("",.T.)
  oPrinter:TextOut("",.T.)

  oPrinter:bold( FW_NORMAL )
*  oPrinter:SetFont( "Courier New", 11.5, { 4, -54 } )  // Alternative Compressed print
 * oPrinter:SetFont( "Courier New", 10.5, { 6,62 } )  // Alternative Compressed print
  *oPrinter:SetFont( "Courier New", 11.5, { 4, -80 } )  // Alternative Compressed print

  oPrinter:TextOut("De um lado denominado locador, a empresa Contrato de Locação nº:")
  *oPrinter:SetFont( "Courier New", 11.5,0)  // Compressed print
  oPrinter:bold( FW_BOLD )

  oPrinter:TextOut("CIRURCENTER PRODUTOS HOSPITALARES LTDA,",.T.)
  oPrinter:bold( FW_NORMAL )



  oPrinter:TextOut("Com sede à Av. Manoel Goulart, 595 - Presidente Prudente - SP., CEP: 19015-240, CNPJ: 02.715.655/0001-71",.T.)

*  oPrinter:TextOut("  EMPRESA: " + AEMP00->EMPNOM + " FONE: " + AEMP00->EMPTEL,.T.)
*  oPrinter:TextOut(" ENDERECO: " + AEMP00->EMPEND + " " + AEMP00->EMPMUN + " " + AEMP00->EMPEST,.T.)
  oPrinter:bold( FW_NORMAL )


  nColFixed:= 40 * oPrinter:CharWidth
  nColTTF  := 48 * oPrinter:CharWidth
	nColCharSet  := 60 * oPrinter:CharWidth

  aFonts:= oPrinter:GetFonts()
  FOR x:= 1 TO LEN(aFonts)
	        oPrinter:CharSet(aFonts[x,4])
	        IF oPrinter:SetFont(aFonts[x,1])       // Could use "IF oPrinter:SetFontOk" after call to oPrinter:SetFont()
	          IF oPrinter:FontName == aFonts[x,1]  // Make sure Windows didn't pick a different font
	            oPrinter:TextOut(aFonts[x,1])
	            oPrinter:SetPos(nColFixed)
	            oPrinter:TextOut(IIF(aFonts[x,2],'Yes','No'))
	            oPrinter:SetPos(nColTTF)
	            oPrinter:TextOut(IIF(aFonts[x,3],'Yes','No'))
              oPrinter:SetPos(nColCharSet)
	            oPrinter:TextOut(STR(aFonts[x,4],5))
	            oPrinter:SetPos(oPrinter:LeftMargin, oPrinter:PosY + (oPrinter:CharHeight*2))
	            IF oPrinter:PRow() > oPrinter:MaxRow() - 10  // Could use "oPrinter:NewPage()" to start a new page
                 oPrinter:NEWPAGE()
*                EXIT
	          ENDIF
	          ENDIF
	        ENDIF
	        oPrinter:Line(0, oPrinter:PosY+5, 2000, oPrinter:PosY+5)
	      NEXT


  oPrinter:EndDoc()
  oPrinter:Destroy()