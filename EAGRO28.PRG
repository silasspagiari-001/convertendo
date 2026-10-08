#include "Fileio.ch"
#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)

#command @ <row> , <col>  GET <var> [<clauses,...>] F2 [<moreClauses,...>] funcao <func> retorno <Variavel>;
=>       @ <row> , <col>  GET <var> [<clauses>] SEND reader := {|oGet| Getf2(oGet,<func>,<Variavel>) } [<moreClauses>]

***************
function MANSAT
***************
parameters M_OPC,M_OPC1,M_OPC2


P_TENT = 3
p_net = .t.
p_cor3 = "w/b"
p_cor2 = "w/b"
p_box = M_FRAME1

cPCC_ESC = " "
cPCC_SIM = " "
cPCC_POS = "  "
cPCC_07  = "  "
cPCC_12  = "  "
cPCC_18  = "  "

zPCALOT = " "
zPCAMAT = 0
zPCAREF=space(50)
zPCALIS="   "
zPCAGRP=0
zPCAMAR = space(30)
zPCANBM = space(8)
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

lNFE = .t.
lNFEprod = .t.

#include "ptmenu.ch"

_FUNIND_ = "NFS.t."
_FUNCLI_ = "CUPOM.t."
_FUNPRO_ = "CUPOM.t."
_FUNFOR_ = "CUPOM.f."
_FUNCPG_ = "CUPOM.t."
_FUNTRA_ = "CUPOM.t."
_FUNVEN_ = "CUPOM.t."

ACBrNFe_ENT = "C:\NFE\ENTNFE.TXT"
ACBrNFe_SAI = "C:\NFE\SAINFE.TXT"
ACBrNFe_TMP = "C:\NFE\ARQTMP.TXT"
ACBrNFe_UNI = "C:"


  rodape("MENU", "CUPOM", M_FAN, "EAGRO28", "Mem: " + str(memory(0), 5), M_EMP)
  
*  @ 05, 19 prompt "Emissao  " HIGHLITE R/BG            PERMITE 3,2,1 SENHA 222
*  @ 06, 19 prompt "Alteracao" HIGHLITE R/BG            PERMITE 3,2,2 SENHA 223
*  @ 07, 19 prompt "Consulta " HIGHLITE R/BG            PERMITE 3,2,3 SENHA 224
*  @ 08, 19 prompt "Reemissao" HIGHLITE R/BG            PERMITE 3,2,4 SENHA 225
*  @ 09, 19 prompt "Listagem " HIGHLITE R/BG            PERMITE 3,2,5 SENHA 226
*  @ 10, 19 prompt "Cancelar " POSITION 2 HIGHLITE R/BG PERMITE 3,2,6 SENHA 227

  do case
    case M_OPC = 1 ; incsat(M_OPC1)
    case M_OPC = 2 ; altsat()
    case M_OPC = 3 ; consat(M_OPC1)
    case M_OPC = 4 ; reesat()
    case M_OPC = 5 ; liscup(M_OPC1)
    case M_OPC = 6 ; outsat_aa()
  endcase

  ACBrNFe_ENT = "C:\NFE\ENTNFE.TXT"
  ACBrNFe_SAI = "C:\NFE\SAINFE.TXT"
  ACBrNFe_TMP = "C:\NFE\ARQTMP.TXT"
  ACBrNFe_UNI = "C:"

fecha_arq()

return ""

***************
function INCSAT
***************
LOCAL aBlocks1 := {}
local lTelasat := wvt_savescreen(03, 02, 25, 80)
local aLastPaint1
local lPri

parameters M_OPX,M_OPC1,M_OPC2


  aAdd( aBlocks1, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
  aAdd( aBlocks1, {|| Wvt_DRAWBOXRECESSED( 03, 02, 20, 76) } )
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 11, 76,{+15,,-15,})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 20, 5 ,{+15,,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 06, 20, 12,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 13, 20, 41,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 42, 20, 44,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 45, 20, 54,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 55, 20, 65,{+15,-10,,-10})})

*    aLastPaint1 := WvtSetBlocks( aBlocks1 )

M_NFSCOMP = "N"

*@ 07, 26 prompt "Emissao  " POSITION 1 HIGHLITE R/BG SENHA 228
*@ 08, 26 prompt "Inclusao " POSITION 2 HIGHLITE R/BG SENHA 229

lPri = .t.

do while .t.

  if ME_EMP = 1
    filecopy("C:\ACBrNfeMonitor\ACBrCirur.ini","C:\ACBrNfeMonitor\ACBrMonitor.ini")           // Copy the file
  else
    filecopy("C:\ACBrNfeMonitor\ACBrNutri.ini","C:\ACBrNfeMonitor\ACBrMonitor.ini")           // Copy the file
  endif

  mon_env("ACBr.Lerini")

  fecha_arq()
  SEATUALIZA()

  rodape(iif(M_OPX=1,"EMISSAO","INCLUSAO"),"CUPOM",M_FAN,"EAGRO28","Mem: " + str(memory(0), 5),M_EMP)
  
  tlsat01()

  if lPri
    aLastPaint1 := WvtSetBlocks( aBlocks1 )
    lPri = .f.
  endif
  
  M_CUPNUM = AEMP00->EMPCUP

  M_NFSMES = ""
  M_NOAR   = ""

  M_CUPSER = "1 "

  SetColor(_COREDICAO_)
  @ 04, 12 say M_CUPNUM picture "######"
  @ 04, 19 say M_CUPSER picture "@!"
  read

  if M_OPX = 1
    M_CUPEMP  = ME_EMP
  else
    M_CUPEMP  = ME_EMP
    M_CUPNUM  = 0

    SetColor(_COREDICAO_)
    @ 04, 12 get M_CUPNUM picture "######"
    @ 04, 19 get M_CUPSER picture "@!"
    read
    if M_CUPNUM = 0 .or. lastkey() = 27
      exit
    endif
  endif


  M_APC = 2
  
  M_CUPNFS  = 0
  M_CUPPED  = 0
  M_CUPPSE  = "ST"

  M_CUPDTE  = date()
  
  M_CUPCLI  = 0
  M_CUPVEN  = 0
  M_CUPCPG  = " "
  M_PEDCPG  = 0
  
  M_CUPNAT  = "5.102"

  M_CUPOBS  = "N"
  M_CUPTRA  = "  "
  M_NFSIND  = 0  
  M_CUPVLP  = 0
  M_CUPDSC  = 0
  M_CUPVLN  = 0
  M_CUPIPL  = "V"  // VENDA
  
  M_CLINOM   = space(40)
  M_CLIEND1  = space(40)
  M_CLIIES2  = space(15)
  M_CLICGC2  = space(15)
  M_CLIEND2  = space(40)
  M_CLIUF2   = "SP"
  M_CLIBAI2  = space(15)
  M_CLICEP2  = 0
  M_CLICCL2  = 0
  M_CLIMUN2  = space(15)
  M_CLITEL3  = space(15)
  M_CLIEND3  = space(40)
  M_CLICONT  = "N"
  M_CLICDM2  = 3541406

  M_CUPHS1 = space(60)

  for A = 1 TO 12
    R = alltrim(str(A,2))
    M_CUPDP&R = 0
    M_CUPVC&R = ctod("  /  /  ")
  next
  
  M_CLIDCC  = 1
  
  R         = 0

  lRecposped = 0
  

  R = 1        // sequencia
  L = 12       // linha inicial
  LNPRO  = 0
  M_LIMITE = 99
  
  M_CUPMAT = {}
  M_NFSNAT = M_CUPNAT
  

  do while .t.

    *
    *                  1   2   3   4   5   6 7
    *                SEQ MAT QDE PRB VLI LIQ TRI
    
    aadd(M_CUPMAT,{0,  0,  0,  0,  0,  0, "  "})
    
    M_CUPMAT[R,1] = R
    
    edsat04(L,R)
    
    if lastkey() = 27
      adel(M_CUPMAT,R)
      asize(M_CUPMAT,len(M_CUPMAT) - 1)
      exit
    endif

    valorespro(M_CUPMAT[R,2])

*    if "#" + alltrim(str(zPCAFOR,5)) + "#" $ M_ABBOTT // ABBOTT
*      if M_NFSIND = 0
*        alert("INFORME QUEM INDICOU")
*        SetColor(_COREDICAO_)
*        @ 07, 15 get     M_NFSIND picture "999" valid VERIND()
*        read
*      endif
*    endif

    calc_sat()     && calcula total do 
    
    if L = 19
      lpsat01()
      L = 11
    endif
    
    R ++
    L ++
    
    if ++ LNPRO >=  M_LIMITE
      exit
    endif
    
  enddo
  
  set key 46  to
  
  if len(M_CUPMAT) = 0
    exit
  endif
  
  lpsat01()
  
  M_TELA1 = savescreen(06, 20, 18, 60)
  
  declare M_VETORITE[len(M_CUPMAT)]
  
  for R = 1 to len(M_CUPMAT)
    BUSCAREGISTRO("APCA00",1,{str(M_CUPMAT[R,2],6,0)},"SELECT")
    M_VETORITE[R] = str(M_CUPMAT[R, 1], 2, 0) + " " + ;
    str(M_CUPMAT[R, 2], 6, 0) + " " + ;
    pad(APCA00->PCADES, 28)   + " " + ;
    pad(APCA00->PCAUNI, 02)   + " " + ;
    str(M_CUPMAT[R, 3], 9, 2) + " " + ;
    str(M_CUPMAT[R, 4],10, 2) + " " + ;
    str(M_CUPMAT[R, 5],10, 2)
  next
  
  M_LINPOS = 0
  
  do while .t.
    
    calc_sat()     && calcula total do 

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
    M_OPC = achoice(12, 3,19,75,M_VETORITE,,"mossat")
    set color to

    if lastkey() = 13
      altitesat() && altera item
      loop
    endif
    
    if lastkey() = 49
      totitesat() && total
      loop
    endif
    
    if lastkey() = 50
      dscitesat() && desconto
      loop
    endif
    
    if lastkey() = 51
      delitesat() && deleta item
      loop
    endif
    
    if lastkey() = 52
      additesat() && adiciona itens
      loop
    endif
    
    if lastkey() = 53
      insitesat() && insere item
      loop
    endif
    
    if lastkey() = 54
      exit        && abandona operacao
    endif
    
  enddo
  
  calc_sat()     && calcula total do

  lCancela = .f.

  edsat01()
  
  if lastkey() = 27
    lCancela = .t.
  endif

  cRet := ""

  if ME_EMP = 1
    Filecopy("C:\ACBrNfeMonitor\ACBrCirur.ini","C:\ACBrNfeMonitor\ACBrMonitor.ini")           // Copy the file
  else
    Filecopy("C:\ACBrNfeMonitor\ACBrNutri.ini","C:\ACBrNfeMonitor\ACBrMonitor.ini")           // Copy the file
  endif

  mon_env("ACBr.Lerini")

  do while .t.

    opcao1 := msgbox4("O que voce deseja?",,,"Escolha","Gravar","Imprimir","Cancelar")

    If opcao1 = 4
      lCancela = .t.
      exit
    endif

    If opcao1 = 2 .or.  opcao1 = 3

      M_CUPTRA = ""
      M_CUPTRA = "05"

      if M_CUPTRA == "" .or. lastkey() = 27
        loop
      endif


      if M_OPX = 1
        if impcpsat(opcao1)
          set color to I
          @ 04, 12 say M_CUPNUM picture "######"
          @ 4, 19 say M_CUPSER picture "@!"
          set color to
          msw("* * * Gravando cFe * * *")
          gravasat()

          sqlCAMPO = {}
          sqlCHAVE =  {}
          sqlARQUI = {"AEMP00","UPDATE"}
          aadd(sqlCHAVE,{"EMPCOD",str(ME_EMP,2)})
          aadd(sqlCAMPO,{"EMPCUP",str(M_CUPNUM+1,9),.t.})
          executasql()

          sqlCAMPO = {}
          sqlCHAVE =  {}
          sqlARQUI = {"AEMP00","SELECT"}
          aadd(sqlCHAVE,{"EMPCOD",str(ME_EMP,2)})
          executasql()

          msg("* * * cFe incluido * * *")
        endif
      else
       gravasat()
      endif

      exit
    endif
  enddo

enddo

wvt_restscreen(03, 02, 25, 80,lTelasat)
WvtSetBlocks( aLastPaint1 )

return ""

******************
function ALTITESAT  && altera item da nota
******************

edsat04(12 + M_LINPOS,M_OPC)

LNPRO = 0

for S = 1 to len(M_CUPMAT)
  BUSCAREGISTRO("APCA00",1,{str(M_CUPMAT[S,2],6,0)},"SELECT")

  M_VETORITE[S] = str(M_CUPMAT[S, 1], 2, 0) + " " + ;
  str(M_CUPMAT[S, 2], 6, 0) + " " + ;
  pad(APCA00->PCADES, 28)   + " " + ;
  pad(APCA00->PCAUNI, 02)   + " " + ;
  str(M_CUPMAT[S, 3], 9, 2) + " " + ;
  str(M_CUPMAT[S, 4],10, 2) + " " + ;
  str(M_CUPMAT[S, 5],10, 2)
next

M_LINPOS = 0

return ""

******************
function INSITESAT && insere item na nota
******************

private R,S

LNPRO = 0

for A = 1 to len(M_CUPMAT)
  if ++ LNPRO >=  M_LIMITE
    msg("* * * EXCEDIDO O NUMERO DE ITENS * * *")
    return ""
  endif
next

aadd(M_CUPMAT,{0,  0,  0,  0,  0,  0, "  "})

R = len(M_CUPMAT)

M_MATANT = aclone(M_CUPMAT)

acopy(M_MATANT,M_CUPMAT,R,1,M_OPC)

if M_OPC-1 = 1
  acopy(M_MATANT,M_CUPMAT,M_OPC-1,M_OPC-1,1)
endif

acopy(M_MATANT,M_CUPMAT,M_OPC,R-M_OPC,M_OPC+1)

M_CUPMAT[M_OPC, 1] = R                 && SEQ

for S = 1 to len(M_CUPMAT)
  M_CUPMAT[S,1] = S
next

mssat02(M_OPC, 12 + M_LINPOS)

edsat04(12 + M_LINPOS, M_OPC)

asize(M_VETORITE, R)

ains(M_VETORITE, len(M_VETORITE))

LNPRO = 0

for S = 1 to len(M_CUPMAT)
  BUSCAREGISTRO("APCA00",1,{str(M_CUPMAT[S,2],6,0)},"SELECT")
  M_VETORITE[S] = str(M_CUPMAT[S, 1], 2, 0) + " " + ;
  str(M_CUPMAT[S, 2], 6, 0) + " " + ;
  pad(APCA00->PCADES, 28)   + " " + ;
  pad(APCA00->PCAUNI, 02)   + " " + ;
  str(M_CUPMAT[S, 3], 9, 2) + " " + ;
  str(M_CUPMAT[S, 4],10, 2) + " " + ;
  str(M_CUPMAT[S, 5],10, 2)
next

M_LINPOS = 0

return ""

******************
function DELITESAT && deleta item da nota
******************

private M_CUP, R

M_CUP = decide("Confirma Exclusao deste Item")

if M_CUP != 1
  return ""
endif

adel(M_CUPMAT,M_OPC)
adel(M_VETORITE,M_OPC)

asize(M_CUPMAT,len(M_CUPMAT) - 1)
asize(M_VETORITE,len(M_VETORITE) - 1)

declare M_VETORITE[len(M_CUPMAT)]

for S = 1 to len(M_CUPMAT)
  M_CUPMAT[S, 1]  = S
  BUSCAREGISTRO("APCA00",1,{str(M_CUPMAT[S,2],6,0)},"SELECT")
  M_VETORITE[S] = str(M_CUPMAT[S, 1], 2, 0) + " " + ;
  str(M_CUPMAT[S, 2], 6, 0) + " " + ;
  pad(APCA00->PCADES, 28)   + " " + ;
  pad(APCA00->PCAUNI, 02)   + " " + ;
  str(M_CUPMAT[S, 3], 9, 2) + " " + ;
  str(M_CUPMAT[S, 4],10, 2) + " " + ;
  str(M_CUPMAT[S, 5],10, 2)
  
next

lpsat01()

M_LINPOS = 0

return ""

******************
function ADDITESAT && insere item na nota
******************

R = len(M_CUPMAT) + 1
L = 12

for S = 1 to len(M_CUPMAT)
  if L = 19
    lpsat01()
    L = 12
  endif
  L ++
next

if len(M_CUPMAT) - (int(len(M_CUPMAT)/9)*9) != 0
  mssat02((int(len(M_CUPMAT)/9)*9)+1 , 12)
endif

do while .t.
  
  LNPRO = 0
  
  for A = 1 to len(M_CUPMAT)
    
    if ++ LNPRO >=  M_LIMITE
      msg("* * * EXCEDIDO O NUMERO DE ITENS * * *")
      asize(M_VETORITE, R)
      ains(M_VETORITE, len(M_VETORITE))
      for S = 1 to len(M_CUPMAT)
        BUSCAREGISTRO("APCA00",1,{str(M_CUPMAT[S,2],6,0)},"SELECT")
        M_VETORITE[S] = str(M_CUPMAT[S, 1], 2, 0) + " " + ;
        str(M_CUPMAT[S, 2], 6, 0) + " " + ;
        pad(APCA00->PCADES, 28)   + " " + ;
        pad(APCA00->PCAUNI, 02)   + " " + ;
        str(M_CUPMAT[S, 3], 9, 2) + " " + ;
        str(M_CUPMAT[S, 4],10, 2) + " " + ;
        str(M_CUPMAT[S, 5],10, 2)
      next
      return ""
    endif
  next
  
  aadd(M_CUPMAT,{0,  0,  0,  0,  0,  0, "  "})
  
  M_CUPMAT[R, 1] = R                 && SEQ
  
  edsat04(L,R)
  
  if lastkey() = 27
    adel(M_CUPMAT,R)
    asize(M_CUPMAT,len(M_CUPMAT) - 1)
    exit
  endif
  
  if L = 19
    lpsat01()
    L = 11
  endif
  
  R ++
  L ++
  
enddo

if len(M_CUPMAT) = 0
  msg("* * * CUPOM FISCAL NAO INCLUIDO * * *")
  return ""
endif

lpsat01()

asize(M_VETORITE, R)

ains(M_VETORITE, len(M_VETORITE))

for S = 1 to len(M_CUPMAT)
  BUSCAREGISTRO("APCA00",1,{str(M_CUPMAT[S,2],6,0)},"SELECT")
  M_VETORITE[S] = str(M_CUPMAT[S, 1], 2, 0) + " " + ;
  str(M_CUPMAT[S, 2], 6, 0) + " " + ;
  pad(APCA00->PCADES, 28)   + " " + ;
  pad(APCA00->PCAUNI, 02)   + " " + ;
  str(M_CUPMAT[S, 3], 9, 2) + " " + ;
  str(M_CUPMAT[S, 4],10, 2) + " " + ;
  str(M_CUPMAT[S, 5],10, 2)
next

M_LINPOS = 0

return ""

******************
function DSCITESAT  && desconto na nota
******************

private M_TELA

*   if !c_senha()
*      return ""
*    endif


M_TELA = savescreen(07, 20, 16, 60)

set color to W+/R

sombra(08, 20, 10, 59, _SOMBRA_)

set color to GR+/R
@ 08, 20 say  "                                        "
@ 09, 20 say  " Valor do Desconto :                    "
@ 10, 20 say  "                                        "
set color to

painel(08, 20, 10, 59,"W+/R","N/R")

SetColor(_COREDICAO_)
@ 09, 49 get M_CUPDSC  picture "#######.##"
read
set color to

msg("* * * TECLE (ENTER) * * *")

restscreen(07, 20, 16, 60, M_TELA)

return ""

******************
function TOTITESAT                     && mostra dados e calcula nota fiscal
******************

private  M_TELA ,;
R

M_CUPVLP = 0
M_CUPVLN = 0

for R = 1 to len(M_CUPMAT)            && calcula o valor bruto da nota
  M_CUPVLP = M_CUPVLP + M_CUPMAT[R,5]
next

for R = 1 to len(M_CUPMAT)                    && calcula o valor liquido da nota
  
  M_CUPVLN = M_CUPVLN + M_CUPMAT[R,6]
  
next R

M_TELA = savescreen(07, 20, 16, 60)

set color to W+/R

sombra(07, 20, 11, 59, _SOMBRA_)

set color to GR+/R
@ 07, 20 say  "                                        "
@ 08, 20 say  " Valor do Produto  :                    "
@ 09, 20 say  " Valor do Desconto :                    "
@ 10, 20 say  " Valor do Cupom    :                    "
@ 11, 20 say  "                                        "
set color to

painel(07, 20, 11, 59,"W+/R","N/R")

set color to GR+/R
@ 08, 41 say M_CUPVLP            picture "@E ###,###,###,###.##"
@ 09, 41 say M_CUPDSC            picture "@E ###,###,###,###.##"
@ 10, 41 say M_CUPVLN - M_CUPVLP picture "@E ###,###,###,###.##"
set color to

msg("* * * TECLE (ENTER) * * *")

restscreen(07, 20, 16, 60, M_TELA)

return ""

*****************
function CALC_SAT                      && calcula total do 
*****************

private R

M_CUPVLP = 0
M_CUPVLN = 0
M_PERC = 100

for R = 1 to len(M_CUPMAT)            && calcula o valor bruto da nota
  M_CUPVLP = M_CUPVLP + M_CUPMAT[R,5]
next

if M_CUPDSC > 0
  M_PERC = ((M_CUPVLP-M_CUPDSC)/M_CUPVLP)    // 51614.20 - 6614.20 = 45000
endif

for R = 1 to len(M_CUPMAT)                    && calcula o valor liquido da nota
  if M_CUPDSC > 0
    M_CUPMAT[R,6] = round((M_CUPMAT[R,5]*M_PERC),2)
  else
    M_CUPMAT[R,6] = M_CUPMAT[R,5]
  endif
  M_CUPVLN = M_CUPVLN + M_CUPMAT[R,6]
next R

TOTAL = 0

if M_CUPDSC > 0
  for R = 1 to len(M_CUPMAT)
    TOTAL += M_CUPMAT[R,6]
  next R

  if !str(TOTAL+M_CUPDSC,12,2) == str(M_CUPVLP,12,2)
    if TOTAL+M_CUPDSC > M_CUPVLP
      M_CUPMAT[1,6] -= ((TOTAL+M_CUPDSC) - M_CUPVLP)
    else
      M_CUPMAT[1,6] += (M_CUPVLP - (TOTAL+M_CUPDSC))
    endif
  endif
endif

setcolor("G/W")
@ 08, 63 say M_CUPVLP picture "@R 999,999.99"
setcolor("")

return ""

***************
function ALTSAT
***************
LOCAL aBlocks1 := {}

  aAdd( aBlocks1, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
  aAdd( aBlocks1, {|| Wvt_DRAWBOXRECESSED( 03, 02, 20, 76) } )
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 11, 76,{+15,,-15,})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 20, 5 ,{+15,,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 06, 20, 12,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 13, 20, 41,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 42, 20, 44,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 45, 20, 54,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 55, 20, 65,{+15,-10,,-10})})

  aLastPaint1 := WvtSetBlocks( aBlocks1 )

private M_TELA ,;
M_OPC


do while .t.
  
  M_CUPMAT = {}
  
  rodape("ALTERA","CUPOM",M_FAN,"EAGRO28","Mem: " + str(memory(0), 5),M_EMP)
  
  tlsat01()
  
  M_CUPEMP  = ME_EMP
  M_CUPNUM  = 0
  M_CUPSER = "1 "

  SetColor(_COREDICAO_)
  @ 04, 12 get M_CUPNUM picture "######"
  @ 04, 19 get M_CUPSER picture "@!"
  read
  
  if M_CUPNUM = 0 .or. lastkey() = 27
    exit
  endif
  
  select ACUP00
  
  if !dbseek(str(M_CUPEMP, 2, 0) + str(M_CUPNUM, 6, 0) + M_CUPSER)
    msg("* * * CUPUISI€AO NAO INCLUIDA * * *")
    loop
  endif
  
  if !rlock()
    msg("* * * (ACUP00) REGISTRO SENDO USADO * * *")
    loop
  endif
  
  M_APC = 2
  
  M_CUPNFS  = CUPNFS
  M_CUPNSE  = CUPNSE
  M_CUPDTE  = CUPDTE
  
  M_CUPCLI  = CUPCLI
  M_CUPVEN  = CUPVEN
  M_CUPCPG  = CUPCPG
  M_PEDCPG  = 0
  M_CUPNAT  = CUPNAT * .01
  M_CUPTRA  = CUPTRA
  
  M_CUPOBS  = CUPOBS
  
  M_CUPVLP  = CUPVLP
  M_CUPDSC  = CUPDSC
  M_CUPVLN  = 0
  M_CUPIPL  = CUPIPL
  R         = 0
  
  
  M_CLINOM   = CUPNOM
 * M_CLIEND1  = CUPEND
 * M_CLIIES2  = CUPIES
  M_CLICGC2  = CUPCGC
*  M_CLIEND2  = CUPEND
*  M_CLIUF2   = CUPEST
*  M_CLIBAI2  = CUPBAI
*  M_CLICEP2  = CUPCEP
*  M_CLICCL2  = CUPCCL
*  M_CLIMUN2  = CUPMUN
*  M_CLITEL3  = space(15)
*  M_CLIEND3  = CUPEND
*  M_CLICONT = left(ACLI00->CLIBCO,1)
  
  M_CUPHS1 = CUPHS1
  
  M_CUPDP1 = 0
  M_CUPDP2 = 0
  M_CUPDP3 = 0
  M_CUPDP4 = 0
  M_CUPDP5 = 0
  M_CUPDP6 = 0
  
  M_CUPVC1 = ctod("  /  /  ")
  M_CUPVC2 = ctod("  /  /  ")
  M_CUPVC3 = ctod("  /  /  ")
  M_CUPVC4 = ctod("  /  /  ")
  M_CUPVC5 = ctod("  /  /  ")
  M_CUPVC6 = ctod("  /  /  ")
  
  M_CLIDCC   = 2
  
  edsat01()
  
  if lastkey() = 27
    exit
  endif
  
  LNPRO  = 0
  M_LIMITE = 16
  
  R = 1        // sequencia
  L = 12       // linha inicial
  
  select ACUP01                   && carrega matriz com os itens
  
  dbseek(str(M_CUPEMP, 2, 0) + str(M_CUPNUM, 6, 0) + M_CUPSER, .t.)
  
  do while !eof()
    
    if !str(CUPEMP, 2, 0) + str(CUPNUM, 6, 0) + CUPSER == str(M_CUPEMP, 2, 0) + str(M_CUPNUM, 6, 0) + M_CUPSER
      exit
    endif
    
    aadd(M_CUPMAT,{0,  0,  0,  0,  0,  0, "  "})
    
    M_CUPMAT[R,  1] = CUPSEQ
    M_CUPMAT[R,  2] = CUPMAT
    M_CUPMAT[R,  3] = CUPQDE
    M_CUPMAT[R,  4] = CUPPRB
    M_CUPMAT[R,  5] = CUPVLI
    M_CUPMAT[R,  6] = CUPLIQ
    
    R++
    
    skip
    
  enddo
  
  lpsat01()
  
  M_TELA1 = savescreen(06, 20, 18, 60)
  
  declare M_VETORITE[len(M_CUPMAT)]
  
  for R = 1 to len(M_CUPMAT)
    BUSCAREGISTRO("APCA00",1,{str(M_CUPMAT[R,2],6,0)},"SELECT")
    M_VETORITE[R] = str(M_CUPMAT[R, 1], 2, 0) + " " + ;
    str(M_CUPMAT[R, 2], 6, 0) + " " + ;
    pad(APCA00->PCADES, 28)   + " " + ;
    pad(APCA00->PCAUNI, 02)   + " " + ;
    str(M_CUPMAT[R, 3], 9, 2) + " " + ;
    str(M_CUPMAT[R, 4],10, 2) + " " + ;
    str(M_CUPMAT[R, 5],10, 2)
  next
  
  M_LINPOS = 0
  
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
    M_OPC = achoice(12, 3,19,75,M_VETORITE,,"mossat")
    set color to
    
    if lastkey() = 13
      altitesat() && altera item
      loop
    endif
    
    if lastkey() = 49
      totitesat() && total
      loop
    endif
    
    if lastkey() = 50
      dscitesat() && desconto
      loop
    endif
    
    if lastkey() = 51
      delitesat() && deleta item
      loop
    endif
    
    if lastkey() = 52
      additesat() && adiciona itens
      loop
    endif
    
    if lastkey() = 53
      insitesat() && insere item
      loop
    endif
    
    if lastkey() = 54
      exit        && abandona operacao
    endif
    
  enddo
  
  M_OPX = 2
  
  calc_sat()     && calcula total do 
  
  emisatb()       && emite o 
  
enddo

WvtSetBlocks( aLastPaint1 )


return ""

***************
function CONSAT
***************
parameters M_OPC,M_OPC1,M_OPC2

*        @ 11, 24 prompt "Cupom    " HIGHLITE R/BG POSITION 2
*        @ 12, 24 prompt "Cliente  " HIGHLITE R/BG


      do case
         case M_OPC = 1 ; consat_a()
         case M_OPC = 2 ; consat_b()
      endcase             


return ""


***************
function CONSAT_A(TIPO)
***************
LOCAL aBlocks1 := {}

  aAdd( aBlocks1, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
  aAdd( aBlocks1, {|| Wvt_DRAWBOXRECESSED( 03, 02, 20, 76) } )
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 11, 76,{+15,,-15,})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 20, 5 ,{+15,,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 06, 20, 12,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 13, 20, 41,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 42, 20, 44,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 45, 20, 54,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 55, 20, 65,{+15,-10,,-10})})

* tlsat01()

lPaint = .t.

if TIPO  = NIL
  TIPO = ""
endif

private M_OPC ,;
M_TELA

do while .t.
  
  if !TIPO == "CLIENTE"
    rodape("CONSULTA", "CUPOM", M_FAN, "EAGRO28","Mem: " + str(memory(0), 5), M_EMP)
  endif
  
  tlsat01()

  if lPaint
    aLastPaint1 := WvtSetBlocks( aBlocks1 )
    lPaint = .f.
  endif

  if !TIPO == "CLIENTE"
    M_CUPEMP  = ME_EMP
    M_CUPNUM  = 0
    M_CUPSER = "ST"
    M_CUPNFS  = 0
  
    SetColor(_COREDICAO_)
    @ 04, 12 get M_CUPNUM picture "######"
    @ 04, 19 get M_CUPSER picture "@!"
    read
  
    if lastkey()=27
      exit
    endif
  
    if !BUSCAREGISTRO("ACUP00",1,{str(M_CUPEMP, 2, 0),str(M_CUPNUM, 6, 0),aspas(M_CUPSER)},"SELECT")
      msg("* * * CUPOM NAO INCLUIDO * * *")
      loop
    endif
  endif
  
  mssat01()

  if ACUP00->CUPCAN == "C"
     alertnew("SAT CANCELADO")
  endif
  
  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ACUP01","ACUP01"})
  aadd(sqlCAMPO,"APCA00.PCADES")
  aadd(sqlCAMPO,"APCA00.PCAUNI")
  aadd(sqlCAMPO,"ACUP01.CUPSEQ")
  aadd(sqlCAMPO,"ACUP01.CUPMAT")
  aadd(sqlCAMPO,"ACUP01.CUPPRB")
  aadd(sqlCAMPO,"ACUP01.CUPVLI")
  aadd(sqlCAMPO,"ACUP01.CUPQDE")
  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","ACUP01.CUPMAT"})
  aadd(sqlCHAVE,"ACUP01.CUPEMP = " + str(M_CUPEMP, 2))
  aadd(sqlCHAVE,"ACUP01.CUPNUM = " + str(M_CUPNUM, 9))
  aadd(sqlCHAVE,"ACUP01.CUPSER = " + aspas(M_CUPSER))
  sqlrelation()

  M_VETORITE = { }
  
  do while !eof()
    
    aadd(M_VETORITE,str(CUPSEQ, 2, 0) + " " + ;
    str(CUPMAT, 6, 0) + " " + ;
    pad(PCADES, 28)   + " " + ;
    pad(PCAUNI, 02)   + " " + ;
    str(CUPQDE, 9, 3) + " " + ;
    str(CUPPRB,10, 3) + " " + ;
    str(CUPVLI,10, 2) + " ")

    skip

  enddo
  
  M_LINPOS = 0
  
  do while .t.
    
    set color to N/W,W+/N
    M_OPC = achoice(12, 3,19,75,M_VETORITE,,"mostec")
    set color to
    
    if lastkey() = 13
      mssat04()
      loop
    endif
    
    if lastkey() = 27
      exit        && abandona operacao
    endif
    
  enddo

  if TIPO == "CANCELA"
    select ACUP00
    lRecnoCup = recno()
  endif

  if TIPO == "CLIENTE"
    exit
  endif

enddo

WvtSetBlocks( aLastPaint1 )

return ""

*****************
function CONSAT_B
*****************

private MT_ITENS ,;
        MT_NUMPE ,;
        MT_OBSE1 ,;
        MT_OBSE2 ,;
        MT_OBSE3 ,;
        M_TECLA     ,;
        M_TELA

do while .t.

  rodape("CONSULTA", "CUPOM FISCAL", M_FAN, "EAGRO28","Mem: " + str(memory(0), 5), M_EMP)
  tlcup02()

  M_CUPEMP  = ME_EMP
  M_CUPCLI  = 0
  M_TECLA   = 0

  SetColor(_COREDICAO_)
  @ 04, 15 get M_CUPCLI picture "#######"  F2 color _CORF2_ funcao "sele_arquivo('ACLI00')" retorno @M_CUPCLI
  read

  if lastkey() = 27
    exit
  endif

  if !BUSCAREGISTRO("ACLI00",1,{str(M_CUPCLI,7,0)},"SELECT")
    msg("* * * CLIENTE NAO CADASTRADO * * *")
    loop
  endif

  set color to I
    @ 04, 29 say pad(ACLI00->CLINOM, 29)
    @ 04, 64 say pad(ACLI00->CLIMUN2, 12)
  set color to 

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ACUP00","ACUP00"})
  aadd(sqlCAMPO,"ACUP00.*")
  aadd(sqlCAMPO,"AVEN00.VENNOM")
  aadd(sqlCHAVE,"CUPEMP = " + str(M_CUPEMP, 2))
  aadd(sqlCHAVE,"CUPCLI = " + str(M_CUPCLI, 7))

  aadd(sqlRELATION,{"AVEN00","ACUP00.CUPVEN","AVEN00.VENCOD"})

  aadd(sqlORDEM,"CUPDTE desc,ACUP00.CUPNUM")
  sqlrelation()
  if eof()
    msgbox1("CLIENTE SEM NFCe")
    loop
  endif

    MT_ITENS = { }
    MT_NUMPE = { }
    MT_OBSE1 = { }
    MT_OBSE2 = { }
    MT_OBSE3 = { }

    do while !eof()

      if CUPCLI != M_CUPCLI
        M_TECLA = visualcup(MT_ITENS,MT_NUMPE,MT_OBSE1,MT_OBSE2,MT_OBSE3)
        if M_TECLA = 27
          exit
        endif
        ( dbsetorder(6) , dbseek(str(M_CUPEMP, 2, 0) + str(M_CUPCLI, 7, 0), .t.) )
        MT_ITENS = { }
        MT_NUMPE = { }
        MT_OBSE1 = { }
        MT_OBSE2 = { }
        MT_OBSE3 = { }
        loop
      endif

      set century on
      aadd(MT_ITENS, dtoc(CUPDTE)  + "³" +  str(CUPNUM, 6, 0) + "³" + CUPSER + "³" + str(CUPCPG, 3, 0) + "³" + str(CUPTRA, 3, 0) + "³" + str(CUPVEN, 3, 0) + "³" + pad(VENNOM, 09) + "³" + str(CUPNAT * .01, 6, 2) + "³" + str(CUPNCU, 6, 0) + "³" + CUPSER +  "³" + transform(CUPVLN,"@E ####,###.##"))
      aadd(MT_NUMPE,{ME_EMP,CUPNUM,CUPSER})
      aadd(MT_OBSE1, "")  // CUPHS1
      aadd(MT_OBSE2, "")  //CUPHS2
      aadd(MT_OBSE3, "")  //CUPHS3
      set century off
      skip

    enddo
    
        M_TECLA = visualcup(MT_ITENS,MT_NUMPE,MT_OBSE1,MT_OBSE2,MT_OBSE3)
        if M_TECLA = 27
          exit
        endif
        if M_TECLA = 13
          exit
        endif

    enddo


    if M_TECLA != 27 
      if M_TECLA != 13
        visualcup(MT_ITENS,MT_NUMPE,MT_OBSE1,MT_OBSE2,MT_OBSE3)
      endif
    endif

    setcursor(1)


return ""

******************
function VISUALCUP
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
      M_OPC = achoice(08,05,15,75,V1,,"mosvre")
    set color to 

    if rat(str(lastkey(), 2, 0)," 3#27#18") > 0
      exit
    endif
  
    if rat(str(lastkey(), 2, 0),"13#") > 0
      if BUSCAREGISTRO("ACUP00",1,{str(V2[M_OPC][1], 2, 0),str(V2[M_OPC][2], 9, 0),aspas(V2[M_OPC][3])},"SELECT")

        M_CUPNUM = V2[M_OPC][2]
        M_CUPSER = V2[M_OPC][3]

        lTelloc = WVT_savescreen(0,0,maxrow(),maxcol())
        consat_a("CLIENTE")
        wvt_restscreen(0,0,maxrow(),maxcol(),lTelloc)
        select ACUP00
        loop
      endif
    endif

    exit

  enddo

  select &M_AREA

return lastkey()

***************
function MOSVRE
***************

parameters  M_MODO, M_ELEM, M_POSI

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


***************
function REESAT
***************
LOCAL aBlocks1 := {}

  aAdd( aBlocks1, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
  aAdd( aBlocks1, {|| Wvt_DRAWBOXRECESSED( 03, 02, 20, 76) } )
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 11, 76,{+15,,-15,})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 20, 5 ,{+15,,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 06, 20, 12,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 13, 20, 41,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 42, 20, 44,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 45, 20, 54,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 55, 20, 65,{+15,-10,,-10})})

  aLastPaint1 := WvtSetBlocks( aBlocks1 )

private M_OPC

do while .t.
  
  rodape("REEMITE", "cFE", M_FAN, "EAGRO28A","Mem: " + str(memory(0), 5), M_EMP)
  
  tlsat01()
  
  M_CUPEMP  = ME_EMP
  M_CUPNUM  = 0

  M_CUPSER = "1 "

  SetColor(_COREDICAO_)
  @ 04, 12 get M_CUPNUM picture "######"
  @ 04, 19 get M_CUPSER picture "@!"
  read
  
  
  if M_CUPNUM = 0
    exit
  endif
  
  if !BUSCAREGISTRO("ACUP00",1,{str(M_CUPEMP, 2, 0),str(M_CUPNUM, 9, 0),aspas(M_CUPSER)},"SELECT")
    msg("* * * NFC-E NAO INCLUIDA * * *")
    loop
  endif

  mssat01()
  mssat03()
  
  select ACUP00
  
  nEMINOVO = 0

  do while .t.
    nEMINOVO = msgbox3("Confirma reemissao",,,"Escolha","Sim","Nao")

    if nEMINOVO = 3
      return .f.
    endif

    if nEMINOVO = 2
      cFileDanfe = "&_PATH_\ENVIADO\" + alltrim(CUPTRN) + "\NFCE\"+ CUPHS6
      nCop = 1
      cCmd := ["]+cFileDanfe+[","TANCA TP-550"]
      cRet := MON_ENV( "NFE.ImprimirDanfe", cCmd, ACBrNFe_ENT, ACBrNFe_SAI, ACBrNFe_TMP )
      exit
    endif
  enddo

enddo

WvtSetBlocks( aLastPaint1 )

return ""

***************
function LISCUP
***************
parameters M_OPC,M_OPC1,M_OPC2

*        @ 11, 24 prompt "Faturamento do Dia " HIGHLITE R/BG POSITION 2
*        @ 12, 24 prompt "Mapa Resumo Fiscal " HIGHLITE R/BG
*        @ 13, 24 prompt "Produto Sint‚tica  " HIGHLITE R/BG

      do case
         case M_OPC = 1 ; liscup_a()
         case M_OPC = 2 ; liscup_b()
         case M_OPC = 3 ; liscup_c()
      endcase             

return ""


****************
function CUPOMNOTA(fVALOR,nLinha,nColuna)  // CLASSIFICACAO PARA DESCONTO
****************

LOCAL scr, clr
LOCAL aBlocks := {}
local M_CODIGO

private PosAcho

M_TIPOS = { }

  aadd(M_TIPOS,"     Escolha    ")
  aadd(M_TIPOS,"Todas           ")
  aadd(M_TIPOS,"Cupom Eletronico")
  aadd(M_TIPOS,"Nota Eletronica ")

  PosAcho = 1

  scr := SaveScreen(nLinha-2,nColuna-2,nLinha+len(M_TIPOS)+2,nColuna+len(M_TIPOS[1])+2)
  clr := SetColor( 'N/W*,GR+/B*,,,GR+/B' )

  Wvt_DrawBoxRaised( nLinha,nColuna,nLinha+len(M_TIPOS)-1,nColuna+len(M_TIPOS[1]))
  aLastPaint4 := WvtSetBlocks( aBlocks )

do while .t.

  TIPO1 = achoice(nLinha,nColuna,nLinha+len(M_TIPOS),nColuna+len(M_TIPOS[1]),M_TIPOS,,,PosAcho)

  if lastkey()=27
    M_NFSTIPPAG = " "
    setColor( clr )
    RestScreen(nLinha-2,nColuna-2,nLinha+len(M_TIPOS)+2,nColuna+len(M_TIPOS[1])+2, scr )
    WvtSetBlocks( aLastPaint4 )
    return .f.
  endif

  if TIPO1 = 0
    loop
  endif

  fVALOR = left(M_TIPOS[TIPO1],1)

  if fVALOR == " "
    loop
  endif

  exit

enddo

setColor( clr )

 WvtSetBlocks( aLastPaint4 )
 RestScreen(nLinha-2,nColuna-2,nLinha+len(M_TIPOS)+2,nColuna+len(M_TIPOS[1])+2, scr )

keyboard chr(13)

return .t.

****************
function TIPOVENDA(fVALOR,nLinha,nColuna)  // CLASSIFICACAO PARA DESCONTO
****************

LOCAL scr, clr
LOCAL aBlocks := {}
local M_CODIGO

private PosAcho

M_TIPOS = { }

  aadd(M_TIPOS," Escolha ")
  aadd(M_TIPOS,"Vendas   ")
  aadd(M_TIPOS,"Cancelada")
  aadd(M_TIPOS,"Todas    ")

  PosAcho = 1

  scr := SaveScreen(nLinha-2,nColuna-2,nLinha+len(M_TIPOS)+2,nColuna+len(M_TIPOS[1])+2)
  clr := SetColor( 'N/W*,GR+/B*,,,GR+/B' )

  Wvt_DrawBoxRaised( nLinha,nColuna,nLinha+len(M_TIPOS)-1,nColuna+len(M_TIPOS[1]))
  aLastPaint4 := WvtSetBlocks( aBlocks )

do while .t.

  TIPO1 = achoice(nLinha,nColuna,nLinha+len(M_TIPOS),nColuna+len(M_TIPOS[1]),M_TIPOS,,,PosAcho)

  if lastkey()=27
    M_NFSTIPPAG = " "
    setColor( clr )
    RestScreen(nLinha-2,nColuna-2,nLinha+len(M_TIPOS)+2,nColuna+len(M_TIPOS[1])+2, scr )
    WvtSetBlocks( aLastPaint4 )
    return .f.
  endif

  if TIPO1 = 0
    loop
  endif

  fVALOR = left(M_TIPOS[TIPO1],1)

  if fVALOR == " "
    loop
  endif

  exit

enddo

setColor( clr )

 WvtSetBlocks( aLastPaint4 )
 RestScreen(nLinha-2,nColuna-2,nLinha+len(M_TIPOS)+2,nColuna+len(M_TIPOS[1])+2, scr )

keyboard chr(13)

return .t.

****************
function ANASINT(fVALOR,nLinha,nColuna)  // CLASSIFICACAO PARA DESCONTO
****************

LOCAL scr, clr
LOCAL aBlocks := {}
local M_CODIGO

private PosAcho

M_TIPOS = { }

  aadd(M_TIPOS," Escolha ")
  aadd(M_TIPOS,"Sintetico")
  aadd(M_TIPOS,"Analitico")

  PosAcho = 1

  scr := SaveScreen(nLinha-2,nColuna,nLinha+len(M_TIPOS)+2,nColuna+len(M_TIPOS[1])+2)
  clr := SetColor( 'N/W*,GR+/B*,,,GR+/B' )

  Wvt_DrawBoxRaised( nLinha,nColuna,nLinha+len(M_TIPOS)-1,nColuna+len(M_TIPOS[1]))
  aLastPaint4 := WvtSetBlocks( aBlocks )

do while .t.

  TIPO1 = achoice(nLinha,nColuna,nLinha+len(M_TIPOS),nColuna+len(M_TIPOS[1]),M_TIPOS,,,PosAcho)

  if lastkey()=27
    M_NFSTIPPAG = " "
    setColor( clr )
    RestScreen(nLinha-2,nColuna,nLinha+len(M_TIPOS)+2,nColuna+len(M_TIPOS[1])+2, scr )
    WvtSetBlocks( aLastPaint4 )
    return .f.
  endif

  if TIPO1 = 0
    loop
  endif

  fVALOR = left(M_TIPOS[TIPO1],1)

  if fVALOR == " "
    loop
  endif

  exit

enddo

setColor( clr )

 WvtSetBlocks( aLastPaint4 )
 RestScreen(nLinha-2,nColuna,nLinha+len(M_TIPOS)+2,nColuna+len(M_TIPOS[1])+2, scr )

keyboard chr(13)

return .t.

*****************
function LISCUP_A
*****************

do while .t.

  rodape("LISTA", "CUPOM", M_FAN, "EAGRO28","Mem: " + str(memory(0), 5), M_EMP)

  store 0         to M_CUP1 ,;
                   M_CUP2

  store AEMP00->EMPCFE to M_SER1 ,;
                        M_SER2

  store ctod("  /  /  ") to M_DTA1 ,;
                          M_DTA2

*  M_CUPVEN  = 0
*  M_CUPIPL  = "S"
*  M_CUPSIT  = "G"
*  M_CUPIMP  = "T"

  lAnalitico = .f.

  lVendas = .t.
  lCanceladas = .t.

  lCupom = .t.
  lNotas = .f.

  nbox(09, 30, 16, 73,"W/W+",.t.)
  setcolor("B/W")

  @ 10, 31 say       " Periodo:           a                     "
  @ 11, 31 say       "                                          "
  @ 12, 31 say       "                                          "
  @ 13, 31 say       "                                          "
  @ 14, 31 say       "                                          "
  @ 15, 31 say       "                                          "
  SetColor(_COREDICAO_)



  @ 10, 42 get M_DTA1 F2 valid(M_DTA1 != ctod("  /  /  ")) color _CORF2_ funcao "pegadata(10,42,@M_DTA1)" retorno "re"
  @ 10, 54 get M_DTA2 F2 valid(M_DTA2 != ctod("  /  /  ")) color _CORF2_ funcao "pegadata(10,54,@M_DTA2)" retorno "re"
* @ 12, 52 get M_CUPVEN  picture "###"

  @ 13, 32 GET lAnalitico  CHECKBOX CAPTION "Analitico" COLOR "B/W,W+/W,B/W,G/W"
  @ 14, 32 GET lVendas     CHECKBOX CAPTION "Vendas" COLOR "B/W,W+/W,B/W,G/W"
  @ 14, 55 GET lCanceladas CHECKBOX CAPTION "Canceladas" COLOR "B/W,W+/W,B/W,G/W"

  @ 15, 32 GET lCupom      CHECKBOX CAPTION "Cupom Eletronico" COLOR "B/W,W+/W,B/W,G/W"
  @ 15, 55 GET lNotas      CHECKBOX CAPTION "Nota Fiscal" COLOR "B/W,W+/W,B/W,G/W"


* @ 13, 52 get M_CUPIPL  picture "@!"  when AnaSint(@M_CUPIPL,13,52)
* @ 14, 52 get M_CUPSIT  picture "@!"  when TipoVenda(@M_CUPSIT,14,52)
* @ 15, 52 get M_CUPIMP  picture "@!"  when CupomNota(@M_CUPIMP,15,52)
  read

  if lastkey() = 27
    return ""
  endif



  
  M_DTA1 = iif(empty(M_DTA1),ctod("01/01/1951"),M_DTA1)
  M_DTA2 = iif(empty(M_DTA2),ctod("31/12/2099"),M_DTA2)

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ACUP00","ACUP00"})
  aadd(sqlCAMPO,"ACUP00.CUPNUM")
  aadd(sqlCAMPO,"ACUP00.CUPEMP")
  aadd(sqlCAMPO,"ACUP00.CUPCLI")
  aadd(sqlCAMPO,"ACUP00.CUPCPG")
  aadd(sqlCAMPO,"ACUP00.CUPCAN")
  aadd(sqlCAMPO,"ACUP00.CUPDTE")
  aadd(sqlCAMPO,"ACUP00.CUPSER")
  aadd(sqlCAMPO,"ACUP00.CUPNATN")
  aadd(sqlCAMPO,"ACUP00.CUPVEN")
  aadd(sqlCAMPO,"ACUP00.CUPVLP")
  aadd(sqlCAMPO,"ACLI00.CLINOM")
  aadd(sqlCAMPO,"ACLI00.CLITIP")
  aadd(sqlCAMPO,"AFIS00.FISNOM")
  aadd(sqlRELATION,{"AFIS00",str(ME_EMP,2,0),"AFIS00.FISEMP"})
  aadd(sqlRELATION,{"","AFIS00.FISNOV","ACUP00.CUPNATN"})
  aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ACUP00.CUPCLI"})
  aadd(sqlCHAVE,"ACUP00.CUPDTE BETWEEN " + aspas(formatdta(M_DTA1)) + " and " + aspas(formatdta(M_DTA2)))
  aadd(sqlCHAVE,"ACUP00.CUPEMP = " + str(ME_EMP, 2, 0))

*  if M_CUPVEN > 0
*    aadd(sqlCHAVE,"ACUP00.CUPVEN = " + str(M_CUPVEN,3))
*  endif

  if lVendas .and. lCanceladas
    aadd(sqlCHAVE,"ACUP00.CUPCAN in ('E','C')")
  else
    if lVendas
      aadd(sqlCHAVE,"ACUP00.CUPCAN in ('E')")
    else
      aadd(sqlCHAVE,"ACUP00.CUPCAN in ('C')")
    endif
  endif

  aadd(sqlORDEM,"ACUP00.CUPDTE,ACUP00.CUPNUM")

  sqlrelation()

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ACUP00","ACUP01"})
  aadd(sqlCAMPO,"AFIS00.FISNOM")
  aadd(sqlCAMPO,"APCA00.PCADES")
  aadd(sqlCAMPO,"APCA00.PCAREF")
  aadd(sqlCAMPO,"APCA00.PCAGRP")
  aadd(sqlCAMPO,"APCA00.PCATRI")
  aadd(sqlCAMPO,"ACUP01.CUPNUM")
  aadd(sqlCAMPO,"ACUP01.CUPSEQ")
  aadd(sqlCAMPO,"ACUP01.CUPMAT")
  aadd(sqlCAMPO,"ACUP01.CUPPRB")
  aadd(sqlCAMPO,"ACUP01.CUPLIQ")
  aadd(sqlCAMPO,"ACUP01.CUPVLI")
  aadd(sqlCAMPO,"ACUP01.CUPQDE")
  aadd(sqlRELATION,{"ACUP01","ACUP01.CUPEMP","ACUP00.CUPEMP"})
  aadd(sqlRELATION,{"","ACUP01.CUPNUM","ACUP00.CUPNUM"})
  aadd(sqlRELATION,{"","ACUP01.CUPSER","ACUP00.CUPSER"})
  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","ACUP01.CUPMAT"})
  aadd(sqlRELATION,{"AFIS00",str(ME_EMP,2,0),"AFIS00.FISEMP"})
  aadd(sqlRELATION,{"","AFIS00.FISNOV","ACUP00.CUPNATN"})
  aadd(sqlCHAVE,"ACUP00.CUPDTE BETWEEN " + aspas(formatdta(M_DTA1)) + " and " + aspas(formatdta(M_DTA2)))
  aadd(sqlCHAVE,"ACUP00.CUPEMP = " + str(ME_EMP, 2, 0))

*  if M_CUPVEN > 0
*    aadd(sqlCHAVE,"ACUP00.CUPVEN = " + str(M_CUPVEN,3))
*  endif

  if lVendas .and. lCanceladas
    aadd(sqlCHAVE,"ACUP00.CUPCAN in ('E','C')")
  else
    if lVendas
      aadd(sqlCHAVE,"ACUP00.CUPCAN in ('E')")
    else
      aadd(sqlCHAVE,"ACUP00.CUPCAN in ('C')")
    endif
  endif

  aadd(sqlORDEM,"ACUP00.CUPDTE,ACUP00.CUPNUM")
  sqlrelation()

  index on CUPNUM tag 1 to ACUPTM


  select ACUP00

  M_IMPRE = impresn()

  if M_IMPRE = "N"
    return ""
  endif

  if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
    ?? chr(15)                        && comprime
  endif

  cSUB := 0  // Substituicao
  cSER := 0  // Servico

  store 0 to PG ,;
            LN ,;
            C_DIAPRZ ,;  // Cupons Dia
            C_DIAAPR ,;
            C_DIAVIS ,;
            C_DIATRA ,;
            C_DIACAN ,;
            C_DIASUB ,;
            C_DIASER ,;
            N_DIAPRZ ,;  // Notas Dia
            N_DIAAPR ,;
            N_DIAVIS ,;
            N_DIATRA ,;
            N_DIACAN ,;
            N_DIASUB ,;
            N_DIASER ,;
            C_TOTPRZ ,;  // Cupons Total
            C_TOTAPR ,;
            C_TOTVIS ,;
            C_TOTTRA ,;
            C_TOTCAN ,;
            C_TOTSUB ,;
            C_TOTSER ,;
            N_TOTPRZ ,;  // Notas Total
            N_TOTAPR ,;
            N_TOTVIS ,;
            N_TOTTRA ,;
            N_TOTCAN ,;
            N_TOTSUB ,;
            N_TOTSER

  cab_cup1()                           && imprime cabecalho

  M_DIAANT = ctod(" ")

  cab_cup2()                           && imprime cabecalho

  if lCupom

    do while !eof()

      if lAnalitico
        cab_cup2()
      endif

      if !M_DIAANT = CUPDTE
        if !empty(M_DIAANT)
        
          if LN > 58
            cab_cup1()
            cab_cup2()
          endif

          imptot("DIACUP")

        endif
        
        M_DIAANT := CUPDTE
        N_DIAPRZ := 0
        N_DIAAPR := 0
        N_DIAVIS := 0
        N_DIATRA := 0
        N_DIACAN := 0
        N_DIASUB := 0
        N_DIASER := 0
        C_DIAPRZ := 0
        C_DIAAPR := 0
        C_DIAVIS := 0
        C_DIATRA := 0
        C_DIACAN := 0
        C_DIASUB := 0
        C_DIASER := 0
      endif
  
      calsubser("CUP")

      C_DIASUB += cSUB
      C_DIASER += cSER
      C_TOTSUB += cSUB
      C_TOTSER += cSER

      ?
      ?? transform(CUPNUM, "@Z ######")
      ?? " "
      ?? CUPSER
      ?? " "
      ?? transform(0, "@Z ######")
      ?? "  "
      ?? CUPNATN
      ?? " "
      ?? pad(FISNOM, 13)
      ?? " " 
      ?? CUPDTE
      ?? " "
      ?? str(CUPCLI, 7, 0)
      ?? " "
      ?? iif(CUPCLI=90000,pad(CUPNOM, 38),pad(CLINOM, 38))
      ?? " " 
      ?? str(CUPCPG, 3, 0)
      ?? " "
      ?? str(CUPVEN, 3, 0)
      ?? " "
      ?? transform(CUPVLP,"@E ###,###,###.##") 
      ?? " "
      if CUPCAN = "C"
        ?? "CANCELADA"
      else
        ?? "VENDA    "
      endif

      select ACUP00

      if !CUPCAN $ "C"
        if CUPCPG = 151 .or. CUPCPG < 3
          C_DIAVIS = C_DIAVIS + CUPVLP
          C_TOTVIS = C_TOTVIS + CUPVLP
        else
          C_DIAPRZ = C_DIAPRZ + CUPVLP
          C_TOTPRZ = C_TOTPRZ + CUPVLP
        endif 
      else
        C_DIACAN += CUPVLP
        C_TOTCAN += CUPVLP
      endif

      LN++

      if LN > 62
        cab_cup1()
        cab_cup2()
      endif  

      if lAnalitico
        select ACUP01
        seek ACUP00->CUPNUM

        cab_cup3()

        do while !eof()

          if !str(ACUP00->CUPNUM,9) == STR(ACUP01->CUPNUM,9)
            exit
          endif

          ? "   "
          ?? str(CUPSEQ, 2, 0)
          ?? "     "
          ?? transform(str(CUPMAT, 6, 0),"@R 99999-9")
          ?? "            "
          ?? PCAREF
          ?? "   "
          ?? PCADES
          ?? "  "
          ?? space(05)
          ?? " "
          ?? str(CUPQDE, 9, 3)
          ?? "  "
          ?? transform(CUPPRB,"@E #,###,###.####")
          ?? "  "
          ?? transform(CUPVLI,"@E ###,###,###.##")

          LN = LN + 1

          if LN > 54
            cab_cup1()
            cab_cup3()
          endif

          skip

        enddo

      endif

      select ACUP00
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

    if LN > 58
      cab_cup1()
      cab_cup2()
    endif

    imptot("DIACUP") // Carrega e imprime os totais

  endif


  // FIN CUPOM



  if lNotas

    M_DIAANT := ctod("")

    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"ANFS00","ANFS00"})
    aadd(sqlCAMPO,"ANFS00.NFSNUM")
    aadd(sqlCAMPO,"ANFS00.NFSEMP")
    aadd(sqlCAMPO,"ANFS00.NFSCLI")
    aadd(sqlCAMPO,"ANFS00.NFSCPG")
    aadd(sqlCAMPO,"ANFS00.NFSCAN")
    aadd(sqlCAMPO,"ANFS00.NFSDTE")
    aadd(sqlCAMPO,"ANFS00.NFSSER")
    aadd(sqlCAMPO,"ANFS00.NFSNATN")
    aadd(sqlCAMPO,"ANFS00.NFSVEN")
    aadd(sqlCAMPO,"ANFS00.NFSVLN")
    aadd(sqlCAMPO,"ACLI00.CLINOM")
    aadd(sqlCAMPO,"ACLI00.CLITIP")
    aadd(sqlCAMPO,"AFIS00.FISNOM")
    aadd(sqlRELATION,{"AFIS00",str(ME_EMP,2,0),"AFIS00.FISEMP"})
    aadd(sqlRELATION,{"","AFIS00.FISNOV","ANFS00.NFSNATN"})
    aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ANFS00.NFSCLI"})
    aadd(sqlCHAVE,"ANFS00.NFSDTE BETWEEN " + aspas(formatdta(M_DTA1)) + " and " + aspas(formatdta(M_DTA2)))
    aadd(sqlCHAVE,"ANFS00.NFSEMP = " + str(ME_EMP, 2, 0))
    if M_CUPVEN > 0
      aadd(sqlCHAVE,"ANFS00.NFSVEN = " + str(M_CUPVEN,3))
    endif


    if lVendas .and. lCanceladas
    else
      if lCanceladas
        aadd(sqlCHAVE,"ANFS00.NFSCAN in ('C')")
      else
        aadd(sqlCHAVE,"ANFS00.NFSCAN not in ('C')")
      endif
    endif

    aadd(sqlORDEM,"ANFS00.NFSDTE,ANFS00.NFSNUM")

    sqlrelation()

    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"ANFS00","ANFS01"})
    aadd(sqlCAMPO,"AFIS00.FISNOM")
    aadd(sqlCAMPO,"APCA00.PCADES")
    aadd(sqlCAMPO,"APCA00.PCAREF")
    aadd(sqlCAMPO,"APCA00.PCAGRP")
    aadd(sqlCAMPO,"APCA00.PCATRI")
    aadd(sqlCAMPO,"ANFS01.NFSNATN")
    aadd(sqlCAMPO,"ANFS01.NFSNUM")
    aadd(sqlCAMPO,"ANFS01.NFSSEQ")
    aadd(sqlCAMPO,"ANFS01.NFSMAT")
    aadd(sqlCAMPO,"ANFS01.NFSPRB")
    aadd(sqlCAMPO,"ANFS01.NFSLIQ")
    aadd(sqlCAMPO,"ANFS01.NFSVLI")
    aadd(sqlCAMPO,"ANFS01.NFSVIP")
    aadd(sqlCAMPO,"ANFS01.NFSQDE")
    aadd(sqlRELATION,{"ANFS01","ANFS01.NFSEMP","ANFS00.NFSEMP"})
    aadd(sqlRELATION,{"","ANFS01.NFSNUM","ANFS00.NFSNUM"})
    aadd(sqlRELATION,{"","ANFS01.NFSSER","ANFS00.NFSSER"})
    aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","ANFS01.NFSMAT"})
    aadd(sqlRELATION,{"AFIS00",str(ME_EMP,2,0),"AFIS00.FISEMP"})
    aadd(sqlRELATION,{"","AFIS00.FISNOV","ANFS00.NFSNATN"})
    aadd(sqlCHAVE,"ANFS00.NFSDTE BETWEEN " + aspas(formatdta(M_DTA1)) + " and " + aspas(formatdta(M_DTA2)))
    aadd(sqlCHAVE,"ANFS00.NFSEMP = " + str(ME_EMP, 2, 0))

*    if M_CUPVEN > 0
*      aadd(sqlCHAVE,"ANFS00.NFSVEN = " + str(M_CUPVEN,3))
*    endif

    if lVendas .and. lCanceladas
    else
      if lCanceladas
        aadd(sqlCHAVE,"ANFS00.NFSCAN in ('C')")
      else
        aadd(sqlCHAVE,"ANFS00.NFSCAN not in ('C')")
      endif
    endif

    aadd(sqlORDEM,"ANFS00.NFSDTE,ANFS00.NFSNUM")
    sqlrelation()
    index on NFSNUM tag 1 to ANFSTM
    select ANFS00

   do while !eof()

   if !M_DIAANT = NFSDTE
     if !empty(M_DIAANT)
       imptot("DIANOT") // Carrega e imprime os totais
       if LN > 54
         cab_cup1()
         cab_cup2()
       endif  
     endif
     M_DIAANT := NFSDTE
     N_DIAPRZ := 0
     N_DIAAPR := 0
     N_DIAVIS := 0
     N_DIATRA := 0
     N_DIACAN := 0
     N_DIASUB := 0
     N_DIASER := 0
     C_DIAPRZ := 0
     C_DIAAPR := 0
     C_DIAVIS := 0
     C_DIATRA := 0
     C_DIACAN := 0
     C_DIASUB := 0
     C_DIASER := 0
   endif

       calsubser("NFS")
       N_DIASUB += cSUB
       N_DIASER += cSER
       N_TOTSUB += cSUB
       N_TOTSER += cSER

       ? str(NFSNUM, 6, 0)
        ?? "  "
        ?? NFSSER
        ?? " "
        ?? NFSNATN
        ?? "  "
        ?? left(FISNOM, 22)
        ?? " " 
        ?? NFSDTE
        ?? " "
        ?? str(NFSCLI, 5, 0)
        ?? " "
        ?? pad(CLINOM, 40)
        ?? " " 
        ?? str(NFSCPG, 3, 0)
        ?? " "
        ?? str(NFSVEN, 3, 0)
        ?? " "
        ?? transform(NFSVLN,"@E ###,###,###.##") 
        ?? " "
        if NFSCAN = "C"
          ?? "CANCELADA"
        endif

        select ANFS00

        if empty(NFSCAN) .and. !NFSNATN = "5.929"
          if NFSCPG < 3 .or. NFSCPG > 9
            if NFSCPG < 3 .or. NFSCPG = 151
              N_DIAVIS = N_DIAVIS + NFSVLN
              N_TOTVIS = N_TOTVIS + NFSVLN
            else
              N_DIAPRZ = N_DIAPRZ + NFSVLN
              N_TOTPRZ = N_TOTPRZ + NFSVLN
            endif 
          else
            if NFSCPG = 5
              N_DIATRA = N_DIATRA + NFSVLN
              N_TOTTRA = N_TOTTRA + NFSVLN
            endif
          endif   
        endif

        LN++

        if LN > 54
          cab_cup1()
          cab_cup2()
        endif  

       skip

     enddo

     imptot("DIANOT") // Carrega e imprime os totais
     if LN > 54
       cab_cup1()
       cab_cup2()
     endif

   endif

   imptot("GERAL") // Carrega e imprime os totais

    eject

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(18)                        && descomprime
    endif
 
    desliga1()

  enddo 

return ""

*****************
function LISCUP_B
*****************

msw("* * * AGUARDE... ABRINDO ARQUIVOS * * *")

select 0          // arquivo temporario de resumo fiscal

use &_PATH_\ACUP02 alias ACUP02 exclusive

if neterr()
  msg("* * ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

private M_OPC ,;
        M_TELA

  do while .t.     // loop principal

      rodape("MENU","MAPA FISCAL",M_FAN,"EAGRO28","Mem: " + str(memory(0), 5),M_EMP) 

        store 0               to M_TOTVLA ,;
                                 M_TOTSUB ,;
                                 M_TOTISE ,;
                                 M_TOTNTR ,;
                                 M_TOT001 ,;
                                 M_TOT002 ,;
                                 M_TOT003 ,;
                                 M_TOT004

        store ctod("  /  /  ") to M_PERINI,;
                                  M_PERFIN

       sombra(09, 23, 12, 52,_SOMBRA_)

       set color to GR/W+
         @ 09, 23 say      "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
         @ 10, 23 say      "³ Periodo Inicial:           ³" 
         @ 11, 23 say      "³           Final:           ³" 
         @ 12, 23 say      "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
  SetColor(_COREDICAO_)

        @ 10, 42 get M_PERINI 
        @ 11, 42 get M_PERFIN 
        read

        if lastkey() = 27
          exit
        endif

        M_PERINI = iif(dtoc(M_PERINI) = "  /  /  ",ctod("01/01/1901"),M_PERINI)
        M_PERFIN = iif(dtoc(M_PERFIN) = "  /  /  ",ctod("31/12/2099"),M_PERFIN) 

        select ACUP02

        if !flock()
          msg("* * * (ACUP02) ARQUIVO NAO DISPONIVEL * * *")
          exit
        endif

        zap

        index on dtos(CUPDTE) to &_PATH_\ACUP02

        set index to &_PATH_\ACUP02

        select ACUP00              // cupom fiscal mestre

        set order to 2 

        dbseek(str(ME_EMP, 2, 0) + dtos(M_PERINI), .t.)

        M_CUPINI = 0
        M_CUPDTE = ctod("  /  /  ")

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()     // loop do arquivo de cupom fiscal mestre

          if str(CUPEMP, 2, 0) + dtos(CUPDTE) > str(ME_EMP, 2, 0) + dtos(M_PERFIN)
            exit
          endif 

          if CUPCAN $ "CZX"    // se cancelado, reducao z ou leitura x, pula
            skip
            loop
          endif 
           
          if CUPCPG > 2 
            if CUPCPG < 10
              skip
              loop
            endif
          endif       

          if M_CUPDTE != CUPDTE 
            M_CUPINI = CUPNUM
            M_CUPDTE = CUPDTE
          endif

          select ACUP01        // cupom fiscal itens

          dbsetorder(1)

          dbseek(str(ACUP00->CUPEMP, 2, 0) + str(ACUP00->CUPNUM, 6, 0) + ACUP00->CUPSER + "  ", .t.) 

          do while !eof()   // loop do arquivo cupom fiscal itens

             if !str(CUPEMP, 2, 0) + str(CUPNUM, 6, 0) + CUPSER == str(ACUP00->CUPEMP, 2, 0) + str(ACUP00->CUPNUM, 6, 0) + ACUP00->CUPSER
               exit
             endif 

             select ACUP02         // resumo temporario
     
             if !dbseek(dtos(ACUP00->CUPDTE))
                append blank         
             endif

             replace CUPDTE with ACUP00->CUPDTE
             replace CUPINI with M_CUPINI      
             replace CUPFIN with ACUP00->CUPNUM
             replace CUPVLA with CUPVLA + ACUP01->CUPLIQ  

             do case
                case ACUP01->CUPECF = "01"
                   replace CUP001 with CUP001 + ((ACUP01->CUPLIQ * .01) * 18)
                case ACUP01->CUPECF = "02"
                   replace CUP002 with CUP002 + ((ACUP01->CUPLIQ * .01) * 12)
                case ACUP01->CUPECF = "03"
                   replace CUP003 with CUP003 + ((ACUP01->CUPLIQ * .01) *  7)
                case ACUP01->CUPECF = "04"
                   replace CUP004 with CUP004 + ((ACUP01->CUPLIQ * .01) * 25)
                case ACUP01->CUPECF = "I "
                   replace CUPISE with CUPISE + ACUP01->CUPLIQ
                case ACUP01->CUPECF = "F "
                   replace CUPSUB with CUPSUB + ACUP01->CUPLIQ
                case ACUP01->CUPECF = "N "
                   replace CUPNTR with CUPNTR + ACUP01->CUPLIQ
                otherwise
                   replace CUPSUB with CUPSUB + ACUP01->CUPLIQ 
             endcase

             M_ESC = inkey()

             if M_ESC = 27
               if suspro()
                 msg("* * * PROCESSO SUSPENSO * * *")
                 go bottom
                 skip
                 loop
               else
                 M_ESC = inkey()
               endif
             endif 

             select ACUP01      // arquivo cupom fiscal itens
          
             skip

          enddo      // fim do loop do cupom fiscal itens

          select ACUP00

          skip
 
        enddo        // fim do loop do cupom fiscal mestre

        set order to 1
 
        M_IMPRE = impresn()

        if M_IMPRE = "N"
          exit
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        PG = 0
        LN = 0

        select ACUP02

        go top

        cab_cupb()

        do while !eof()

          ? space(01)
            ?? DTOC(CUPDTE)
            ?? " "
            ?? str(CUPINI)
            ?? " "
            ?? str(CUPFIN)
            ?? " "            
            ?? transform(CUPVLA,"@E ###,###,###.##")
            ?? " "            
            ?? transform(CUPSUB,"@E ###,###,###.##")
            ?? " "
            ?? transform(CUPISE,"@E ###,###,###.##")
            ?? " "
            ?? transform(CUPNTR,"@E ###,###,###.##")
            ?? " "
            ?? transform(CUP001,"@E #,###,###.##")
            ?? " "
            ?? transform(CUP002,"@E ###,###.##")
            ?? " "
            ?? transform(CUP003,"@E ###,###.##")
            ?? " "
            ?? transform(CUP004,"@E ###,###.##")


             M_TOTVLA += CUPVLA
             M_TOTSUB += CUPSUB
             M_TOTISE += CUPISE
             M_TOTNTR += CUPNTR
             M_TOT001 += CUP001
             M_TOT002 += CUP002
             M_TOT003 += CUP003
             M_TOT004 += CUP004

            select ACUP02

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

      ? replicate("=",132)
      ? space(15)
        ?? "TOTAIS -=> "
        ?? transform(M_TOTVLA,"@E ###,###,###.##")
        ?? " "
        ?? transform(M_TOTSUB,"@E ###,###,###.##")
        ?? " "
        ?? transform(M_TOTISE,"@E ###,###,###.##")
        ?? " "
        ?? transform(M_TOTNTR,"@E ###,###,###.##")
        ?? " "
        ?? transform(M_TOT001,"@E #,###,###.##")
        ?? " "
        ?? transform(M_TOT002,"@E ###,###.##")
        ?? " "
        ?? transform(M_TOT003,"@E ###,###.##")
        ?? " "
        ?? transform(M_TOT004,"@E ###,###.##")

      eject

      if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
        ?? chr(18)                        && descomprime
      endif
 
    desliga1()

  enddo     // fim do loop principal 

return "" 

*****************
function LISCUP_C
*****************

private M_TOTAL ,;
        M_DATA1 ,;
        M_DATA2 ,;
        PG, LN  ,;
        M_TOTGER,;
        M_TOTVIS,;
        M_TOTPRZ,;
        M_SOMPER,;
        M_TELA 


seexistesql("ANFS02")
cSQL := "SELECT first 1 * from ANFS02"
dbusearea(.t.,"SQLMIX",cSQL,"ANFS02")
cria_dbf("ANFS02")  // CRIA DBF A PARTIR DO ARQUIVO ABERTO COM O NOME INDICADO
select ANFS02
index on str(NFSEMP, 2, 0) + str(NFSMAT, 6, 0)   tag 1 to "ANFS02"
index on str(NFSEMP, 2, 0) + str(NFSVLN, 14, 2)  tag 2 to "ANFS02"

set order to 1

    rodape("SINTETICO","PRODUTO",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP)

    store date() to M_DATA1 ,;
                    M_DATA2


    store 0      to M_NFSMAT,;
                    M_NFSCLI1,;
                    M_NFSCLI,;
                    M_CODINI,;
                    M_CODFIN

     M_MOEDA = "R" 
     M_IMPVAL= "S"

     sombra(14, 35, 19, 72,_SOMBRA_)
     set color to GR/W
       @ 14, 35 say   "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 15, 35 say   "³Periodo Inicial:          a         ³" 
       @ 16, 35 say   "³        Produto:                    ³" 
       @ 17, 35 say   "³        Cliente:                    ³" 
       @ 18, 35 say   "³  Imprime Valor:                    ³" 
       @ 19, 35 say   "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
  SetColor(_COREDICAO_)
     @ 15, 53 get     M_DATA1
     @ 15, 64 get     M_DATA2 
     @ 16, 53 get     M_NFSMAT picture "######"
     @ 17, 53 get     M_NFSCLI1 picture "#######"
     @ 18, 53 get     M_IMPVAL picture "@!"  valid(M_IMPVAL $ "SN")
     read


     if lastkey() = 27
       select ANFS02 
       use
       return ""
     endif

     store 0 to M_TOTGER

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

*  aadd(sqlARQUI,{"ACUP00","ACUP00"})
*  aadd(sqlCAMPO,"ACUP00.CUPNUM")
*  aadd(sqlCAMPO,"ACUP00.CUPEMP")
*  aadd(sqlCAMPO,"ACUP00.CUPCLI")
*  aadd(sqlCAMPO,"ACUP00.CUPCPG")
*  aadd(sqlCAMPO,"ACUP00.CUPCAN")
*  aadd(sqlCAMPO,"ACUP00.CUPDTE")
*  aadd(sqlCAMPO,"ACUP00.CUPSER")
*  aadd(sqlCAMPO,"ACUP00.CUPNATN")
*  aadd(sqlCAMPO,"ACUP00.CUPVEN")
*  aadd(sqlCAMPO,"ACUP00.CUPVLP")
*  aadd(sqlCAMPO,"ACLI00.CLINOM")
*  aadd(sqlCAMPO,"ACLI00.CLITIP")
*  aadd(sqlCAMPO,"AFIS00.FISNOM")
*  aadd(sqlRELATION,{"AFIS00",str(ME_EMP,2,0),"AFIS00.FISEMP"})
*  aadd(sqlRELATION,{"","AFIS00.FISNOV","ACUP00.CUPNATN"})
*  aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ACUP00.CUPCLI"})
*  aadd(sqlCHAVE,"ACUP00.CUPDTE BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
*  aadd(sqlCHAVE,"ACUP00.CUPEMP = " + str(ME_EMP, 2, 0))


  aadd(sqlARQUI,{"ACUP00","ACUP00"})
  aadd(sqlCAMPO,"ACUP00.CUPNUM")
  aadd(sqlCAMPO,"ACUP00.CUPEMP")
  aadd(sqlCAMPO,"ACUP00.CUPCLI")
  aadd(sqlCAMPO,"ACUP00.CUPCPG")
  aadd(sqlCAMPO,"ACUP00.CUPCAN")
  aadd(sqlCAMPO,"ACUP00.CUPDTE")
  aadd(sqlCAMPO,"ACUP00.CUPSER")
  aadd(sqlCAMPO,"ACUP00.CUPNATN")
  aadd(sqlCAMPO,"ACUP00.CUPVEN")
  aadd(sqlCAMPO,"ACUP00.CUPVLP")
  aadd(sqlCAMPO,"ACLI00.CLINOM")
  aadd(sqlCAMPO,"ACLI00.CLITIP")

  aadd(sqlCAMPO,"AFIS00.FISNOM")
  aadd(sqlCAMPO,"APCA00.PCADES")
  aadd(sqlCAMPO,"APCA00.PCAREF")
  aadd(sqlCAMPO,"APCA00.PCAGRP")
  aadd(sqlCAMPO,"APCA00.PCATRI")
  aadd(sqlCAMPO,"ACUP01.CUPNUM")
  aadd(sqlCAMPO,"ACUP01.CUPSEQ")
  aadd(sqlCAMPO,"ACUP01.CUPMAT")
  aadd(sqlCAMPO,"ACUP01.CUPPRB")
  aadd(sqlCAMPO,"ACUP01.CUPLIQ")
  aadd(sqlCAMPO,"ACUP01.CUPVLI")
  aadd(sqlCAMPO,"ACUP01.CUPQDE")
  aadd(sqlRELATION,{"ACUP01","ACUP01.CUPEMP","ACUP00.CUPEMP"})
  aadd(sqlRELATION,{"","ACUP01.CUPNUM","ACUP00.CUPNUM"})
  aadd(sqlRELATION,{"","ACUP01.CUPSER","ACUP00.CUPSER"})
  aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ACUP00.CUPCLI"})
  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","ACUP01.CUPMAT"})
  aadd(sqlRELATION,{"AFIS00",str(ME_EMP,2,0),"AFIS00.FISEMP"})
  aadd(sqlRELATION,{"","AFIS00.FISNOV","ACUP00.CUPNATN"})
  aadd(sqlCHAVE,"ACUP00.CUPDTE BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
  aadd(sqlCHAVE,"ACUP00.CUPEMP = " + str(ME_EMP, 2, 0))
  aadd(sqlCHAVE,"ACUP00.CUPCAN in ('E')")

  if M_NFSCLI1 > 0
    aadd(sqlCHAVE,"ACUP00.CUPCLI = " + str(M_NFSCLI1, 7, 0))
  endif
  
  if M_NFSMAT > 0
    aadd(sqlCHAVE,"ACUP01.CUPMAT = " + str(M_NFSMAT, 6, 0))
  endif

  aadd(sqlORDEM,"ACUP00.CUPDTE,ACUP00.CUPNUM")

  sqlrelation()
  
  select ACUP00
  go top

  msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

  do while !eof()

  *            valorespro(ACUP01->CUPMAT)

    select ANFS02
    seek str(ACUP00->CUPEMP, 2, 0) + str(ACUP00->CUPMAT, 6, 0)

    if eof()
      append blank
      replace NFSEMP with ACUP00->CUPEMP
      replace NFSMAT with ACUP00->CUPMAT
    endif

    replace NFSQDE with NFSQDE + ACUP00->CUPQDE
    replace NFSVLN with NFSVLN + ACUP00->CUPLIQ

    M_TOTGER = M_TOTGER + ACUP00->CUPLIQ

    select ACUP00

    if inkey() = 27
      if suspro()
        msg("* * * PROCESSO SUSPENSO * * *")
        return ""
      endif
    endif

    skip

  enddo

*** Emite o relatorio
  

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          select ANFS02
          use
          return ""
        endif

        store  0 to PG, LN   ,;
                    M_TOTVIS ,;
                    M_TOTPRZ ,;
                    M_VENVIS ,;
                    M_VENPRZ ,;
                    M_SOMPER ,;
                    M_VENANT
          
        select ANFS02
        set order to 2

        go bottom
                 
        do while !bof()
                              
            PG++

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"VENDAS SINTETICA POR PRODUTOS CUPOM FISCAL - " + iif(M_MOEDA="R","REAL ","DOLAR"),"EAGRO21",80) 
            ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),80) 
            ? "*-------*---------------------------------------*---*-------*------------------*"
            ? "*CODIGO *     D E S C R I C A O                 *UNI*  QDE  *   TOTAL VENDIDO  *"
            ? "*-------*---------------------------------------*---*-------*------------------*"
*               9999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXX 999.999 999,999 ###,###,###,###.## ###,###,###,###.## ###,###,###,###.## ###,## ###,###

            store 5 to LN

            if M_NFSCLI1 > 0
              BUSCAREGISTRO("ACLI00",1,{str(M_NFSCLI1,7,0)},"SELECT")
              ? "CLIENTE: " + alltrim(str(M_NFSCLI1,7)) + " - " + alltrim(ACLI00->CLINOM)

              if len(rtrim(ACLI00->CLICGC1)) = 11
                ?? " CPF: " + alltrim(transform(ACLI00->CLICGC1,"@R 999.999.999/99"))
              else
                ?? " CNPJ: " + right(transform(ACLI00->CLICGC1,"@R 999.999.999/9999-99"),18)
              endif
              ?
              LN += 2
            endif

            select ANFS02
            
            do while !bof() 
               
              if  LN > 60
                exit
              endif 

              BUSCAREGISTRO("APCA00",1,{str(ANFS02->NFSMAT,6,0)},"SELECT")

              select ANFS02
              
*             valorespro(ANFS02->NFSMAT)

              ? " " 
               ?? str(NFSMAT, 7, 0)
               ?? " "
               ?? pad(APCA00->PCADES, 39)
               ?? " "
               ?? pad(APCA00->PCAUNI, 03)
               ?? " "
               ?? transform(NFSQDE,"@E ###,###")
               ?? " "
               if M_IMPVAL = "S"
                 ?? transform(NFSVLN,"@E@Z ###,###,###,###.##")
               endif

            LN++
                                
            M_TOTVIS = M_TOTVIS + NFSVLN
*            M_TOTPRZ = M_TOTPRZ + NFSPRZ

            skip - 1
         
            if inkey() = 27
                if susimp()
                  ? replicate("-", 80)
                  ? "* * * IMPRESSAO SUSPENSA * * *"
                  go bottom
                  skip
                endif
            endif

          enddo

      enddo

      ? replicate("-", 80)
      if M_IMPVAL = "S"
        ? space(31) 
         ?? "TOTAL GERAL . . . . . . . . ."
         ?? transform((M_TOTVIS + M_TOTPRZ),"@E ###,###,###,###.##")
      endif

      ?
      
    eject

  desliga1()

  select ANFS02
  use

return ""

*****************
function CAB_CUPB
*****************

  PG = PG + 1

  if PG > 1
    ?
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"MAPA RESUMO FISCAL","EAGRO28",132) 
  ? cent_cab(M_DATA,"PERIODO: " + dtoc(M_PERINI) + " A " + dtoc(M_PERFIN),"PAG.: " + str(PG, 4, 0), 132)
  ? cent_cab(alltrim(AEMP00->EMPNOM) + "    CNPJ/MF: " + transform(AEMP00->EMPCGC,"@R 999.999.999/9999-99") + "     IE: " + AEMP00->EMPIES,"","", 132)
  ? cent_cab(alltrim(AEMP00->EMPEND) + "     MUNICIPIO: " + alltrim(AEMP00->EMPMUN) + "     UF: " + AEMP00->EMPEST,"","", 132)
  ? "*----------*------*------*--------------*--------------*--------------*--------------*------------*----------*----------*----------*"
  ? "*   DATA   * INIC * FIN  *  MOVIM. DIA  *  SUBS TRIB.  *   ISENTAS    * NAO TRIBUT.  *    18 %    *   12 %   *   07 %   *   25 %   *"
  ? "*----------*------*------*--------------*--------------*--------------*--------------*------------*----------*----------*----------*"
 *    99/99/9999 999999 999999 ###,###,###.## ###,###,###.## ###,###,###.## ###,###,###.## #,###,###.## ###,###.## ###,###.## ###,###.##
  LN = 7

return ""

*****************
function CAB_CUP1
*****************

 PG = PG + 1

 if PG > 1
   ?
   eject
 endif

 ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE CUPONS FISCAIS","EAGRO28",132) 
 ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)

 LN = 2

return ""

*****************
function CAB_CUP2
*****************

 ? replicate("-",132)  
 ? "   COO SE  CUPOM CODFIS                  EMISSAO  CLIENTE                                        CPG VEN    VLR TOTAL   SITUACAO"
*   ###### XX ######  5.929 XXXXXXXXXXXXX 99/99/9999
 LN += 2

return ""

*****************
function CAB_CUP3
*****************

  ?
  ? "   SEQ    CODIGO             REFERENCIA   DESCRICAO                                 % COM     QTDE     VLR UNITARIO    VALOR  TOTAL" 

  LN = LN + 2

return ""

****************
function EMISATN
****************

select ACUP00

dbsetorder(1)

dbseek(str(ME_EMP, 2, 0) + str(1, 6, 0) +  "ST", .t.)

? replicate("-",132)

M_CUPNUM = 1

do while .t.
  
  select ACUP00
  
  if dbseek(str(ME_EMP, 2, 0) + str(M_CUPNUM, 6, 0) + "ST")
    if M_CUPNUM > M_CUP2
      exit
    endif
    M_CUPNUM = M_CUPNUM + 1
    loop
  endif
  
  ? str(M_CUPNUM, 6, 0)
  ?? "  "
  ?? "ST"
  ?? space(110)
  ?? "NAO INCLUIDO"
  
  M_CUPNUM = M_CUPNUM + 1
  
  if M_CUPNUM > M_CUP2
    exit
  endif
  
enddo

? replicate("-",132)

eject

if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
  ?? chr(18)                        && descomprime
endif

set print off
set printer to
set console on
set cursor on
set relation to

if M_IMPRE = "A"
  editrel()
else
  msg("* * * FIM DE EMISSAO * * *")
endif

return ""

*****************
function CAB_SAT1
*****************

PG = PG + 1

if PG > 1
  eject
endif

? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE CUPOMS FISCAIS","EAGRO28",132)
? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)

LN = 2

return ""

*****************
function CAB_SAT2
*****************

? replicate("-",132)
? " DOCTO  SE CODFIS                        EMISSAO  CLIENTE                                      CPG VEN    VLR TOTAL   SITUACAO"

LN = LN + 2

return ""

*****************
function CAB_SAT3
*****************

?
? "   SEQ    CODIGO             REFERENCIA   DESCRICAO                                 % COM     QTDE     VLR UNITARIO    VALOR  TOTAL"

LN = LN + 2

return ""

****************
function TLSAT01
****************

nbox(03, 02, 20, 76,"W/W+",.t.)
setcolor("B/W")
@ 04, 03 say     "cFe    :           Nom:                                          Cpg:    "
@ 05, 03 say     "NfSaida:           End:                                          Ven:    "
@ 06, 03 say     "Emissao:           Bai:                 Mun:                     Pag:    "
@ 07, 03 say     "Indicar:           Cep:      -          Est:                     Obs:    "
@ 08, 03 say     "Cliente:           CPF:                              Total:              "
@ 09, 03 say     "                                                                         "
@ 10, 03 say     "Sq C¢digo         Descri‡„o            Un   Qtde     Unit rio    Total   "
@ 11, 03 say     "                                                                         "
@ 12, 03 say     "                                                                         "
@ 13, 03 say     "                                                                         "
@ 14, 03 say     "                                                                         "
@ 15, 03 say     "                                                                         "
@ 16, 03 say     "                                                                         "
@ 17, 03 say     "                                                                         "
@ 18, 03 say     "                                                                         "
@ 19, 03 say     "                                                                         "
set color to

return ""

****************
function TLSAT02
****************

sombra(03, 04, 20, 76,_SOMBRA_)

setcolor("B/W")
@ 03, 04 say     "                                                                         "
@ 04, 04 say     " Cliente :        Nome:                                Mun:              "
@ 05, 04 say     " ÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÂÄÄÄÄÄÄÄÄÄÄÄ "
@ 06, 04 say     "   Data  ³NumOrc³Se³Cpg³Tra³Ven³Nome       ³ Ope  ³ Nfs  ³Se³  Total     "
@ 07, 04 say     " ÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÅÄÄÄÄÄÄÄÄÄÄÄ "
@ 08, 04 say     "         ³      ³  ³   ³   ³   ³           ³      ³      ³  ³            "
@ 09, 04 say     "         ³      ³  ³   ³   ³   ³           ³      ³      ³  ³            "
@ 10, 04 say     "         ³      ³  ³   ³   ³   ³           ³      ³      ³  ³            "
@ 11, 04 say     "         ³      ³  ³   ³   ³   ³           ³      ³      ³  ³            "
@ 12, 04 say     "         ³      ³  ³   ³   ³   ³           ³      ³      ³  ³            "
@ 13, 04 say     "         ³      ³  ³   ³   ³   ³           ³      ³      ³  ³            "
@ 14, 04 say     "         ³      ³  ³   ³   ³   ³           ³      ³      ³  ³            "
@ 15, 04 say     "         ³      ³  ³   ³   ³   ³           ³      ³      ³  ³            "
@ 16, 04 say     " ÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÁÄÄÄÄÄÄÄÄÄÄÄ "
@ 17, 04 say     "                                                                         "
@ 18, 04 say     "                                                                         "
@ 19, 04 say     "                                                                         "
@ 20, 04 say     "                                                                         "
set color to

return ""

****************
function PEGAPAGSAT  // CLASSIFICACAO PARA DESCONTO
****************

LOCAL scr, clr
LOCAL aBlocks := {}
local M_CODIGO

private PosAcho

parameters TIPO

M_TIPOS = { }

  aadd(M_TIPOS,"  Escolha       ")
  aadd(M_TIPOS,"1-Dinheiro      ")
  aadd(M_TIPOS,"2-Cheque        ")
  aadd(M_TIPOS,"3-Cartao Credito")
  aadd(M_TIPOS,"4-Cartao Debito ")

  PosAcho = 1

  scr := SaveScreen( 5,58,15,78 )
  clr := SetColor( 'N/W*,GR+/B*,,,GR+/B' )

  Wvt_DrawBoxRaised( 6,59,10,75 )
  aLastPaint4 := WvtSetBlocks( aBlocks )

do while .t.

  TIPO1 = achoice(6,59,10,75,M_TIPOS,,,PosAcho)

  if lastkey()=27
    M_NFSTIPPAG = " "
    setColor( clr )
    RestScreen( 5,58,15,78, scr )
    WvtSetBlocks( aLastPaint4 )
    return .f.
  endif

  if TIPO1 = 0
    loop
  endif

  M_CUPCPG = left(M_TIPOS[TIPO1],1)

  if M_CUPCPG == " "
    loop
  endif

  exit

enddo

    setColor( clr )

 WvtSetBlocks( aLastPaint4 )
 RestScreen( 5,58,15,78, scr )

keyboard chr(13)

return .t.

****************
function EDSAT01
****************


SetColor(_COREDICAO_)
@ 06, 12 get M_CUPDTE                   valid !empty(M_CUPDTE)
@ 08, 12 get M_CUPCLI picture "#######"  F2 color _CORF2_ valid versat01() funcao "sele_arquivo('ACLI00')" retorno @M_CUPCLI
@ 04, 73 get M_CUPCPG picture "@!"     when pegapagsat(M_CUPCPG)
@ 05, 73 get M_CUPVEN picture "###"     valid versat03()
read

return ""

****************
function EDSAT02
****************

  SetColor(_COREDICAO_)
@ 06, 12 get M_CUPDTE
@ 08, 12 get M_CUPCLI picture "#####"   valid versat01()

@ 04, 73 get M_CUPCPG picture "###"     valid versat04()
@ 05, 73 get M_CUPVEN picture "###"     valid versat03()
@ 06, 73 get M_CUPTRA picture "@!"     valid versat06()
@ 07, 73 get M_CUPOBS picture "@!"      valid versat11()
read

return ""

****************
function EDSAT04
****************

parameters LN,SQ

set color to I
@ LN, 03 say     M_CUPMAT[SQ,1] picture "##"
  SetColor(_COREDICAO_)

@ LN, 06 get     M_CUPMAT[SQ, 2] picture "######"   F2 color _CORF2_ valid versat07() funcao "sele_arquivo('APCA00')" retorno @M_CUPMAT[SQ, 2]
@ LN, 45 get     M_CUPMAT[SQ, 3] picture "####.###"    valid versat08()
@ LN, 55 get     M_CUPMAT[SQ, 4] picture "#######.##"   valid versat09()
read

return .t.

****************
function MSSAT01
****************

setcolor("N/W*")
@ 04, 12 say CUPNUM picture "######"
@ 04, 19 say CUPSER picture "@!"
@ 05, 12 say CUPNFS picture "######"
@ 05, 19 say CUPNSE picture "@!"
@ 06, 12 say CUPDTE
@ 07, 12 say (CUPNAT*.01) picture "###.##"
@ 08, 12 say CUPCLI       picture "#####"

if BUSCAREGISTRO("ACLI00",1,{str(ACUP00->CUPCLI,7,0)},"SELECT")
  @ 05, 27 say ACLI00->CLIEND2 picture "@!"
  @ 06, 27 say ACLI00->CLIBAI2 picture "@!"
  @ 06, 48 say pad(ACLI00->CLIMUN2,20) picture "@!"
  @ 07, 48 say ACLI00->CLIUF2  picture "@!"
endif
select ACUP00

@ 04, 27 say CUPNOM picture "@!"
@ 08, 27 say CLICGC picture "@R 999.999.999/9999-99"
@ 04, 73 say CUPCPG       picture "###"
@ 05, 73 say CUPVEN       picture "###"
@ 06, 73 say CUPTRA       picture "###"
@ 07, 73 say CUPOBS       picture "@!"
set color to

return ""


****************
function MSSAT02
****************

parameters SQ,R

set color to I
for S = SQ to len(M_CUPMAT)
  BUSCAREGISTRO("APCA00",1,{str(M_CUPMAT[S,2],6,0)},"SELECT")
  @ R, 03 say     M_CUPMAT[S, 1] picture "##"
  @ R, 06 say     M_CUPMAT[S, 2] picture "######"
  @ R, 13 say     pad(APCA00->PCADES, 28)
  @ R, 42 say     pad(APCA00->PCAUNI, 02)
  @ R, 45 say     M_CUPMAT[S, 3] picture "######.##"
  @ R, 55 say     M_CUPMAT[S, 4] picture "#######.##"
  @ R, 66 say     M_CUPMAT[S, 5] picture "#######.##"
  R++
  if R = 19
    exit
  endif
next
set color to

return ""

****************
function MSSAT03
****************


store 12 to L

sqlRELATION = {}
sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {}
sqlORDEM = {}

aadd(sqlARQUI,{"ACUP01","ACUP01"})
aadd(sqlCAMPO,"ACUP01.*")
aadd(sqlCAMPO,"APCA00.PCADES")
aadd(sqlCAMPO,"APCA00.PCAUNI")
aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","ACUP01.CUPMAT"})
aadd(sqlCHAVE,"CUPNUM = " + str(ACUP00->CUPNUM, 9, 0))
aadd(sqlCHAVE,"CUPEMP = " + str(ACUP00->CUPEMP, 2, 0))
aadd(sqlCHAVE,"CUPSER = " + aspas(ACUP00->CUPSER))
sqlrelation()

do while !eof()
  set color to I
  @ L, 03 say     CUPSEQ    picture "##"
  @ L, 06 say     CUPMAT    picture "######"
  @ L, 13 say     pad(PCADES, 28)
  @ L, 42 say     pad(PCAUNI, 02)
  @ L, 45 say     CUPQDE    picture "#####.###"
  @ L, 55 say     CUPPRB    picture "######.###"
  @ L, 66 say     CUPVLI    picture "#######.##"
  set color to
  if L > 18
    msg("* * * (ESC) Sai (ENTER) continua * * *")
    if lastkey() = 27
      exit
    endif
    lpsat01()
    L=11
  endif
  skip
  L = L + 1
enddo

return ""

****************
function LPSAT01
****************

private K

set color to I
for K = 12 to 19
  @ K, 02 say "                                                                           "
next
set color to

return ""

#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)

*****************
function VERSAT01
*****************

if lastkey() = 5
  return .t.
endif

if M_CUPCLI = 0
  return .f.
endif


if M_CUPCLI = 1
  if !valorescli(M_CUPCLI)
    msg("* * * CLIENTE NAO CADASTRADO * * *")
    return .f.
  endif

  save get to M_GETANT
  M_CLINOM  = pad(ACLI00->CLINOM, 40)
  M_CLICGC2 = ACLI00->CLICGC1
  M_CLIUF2  = ACLI00->CLIUF2

  if empty(M_CLIUF2)
    M_CLIUF2 = "SP"
  endif

  M_CLIEND2 = pad(ACLI00->CLIEND2, 40)
  M_CLIBAI2 = pad(ACLI00->CLIBAI2, 15)
  M_CLIMUN2 = pad(ACLI00->CLIMUN2, 19)
  M_CLICEP2 = ACLI00->CLICEP2
  M_CLICCL2 = ACLI00->CLICCL2

  M_CLIIES2 = ACLI00->CLIIES2
  M_CLITEL3 = ACLI00->CLITEL1
  M_CLIEND3 = ACLI00->CLIEND3

  SetColor(_COREDICAO_)
  @ 04, 27 get M_CLINOM  picture "@!"
  @ 05, 27 get M_CLIEND2 picture "@!"
  @ 06, 27 get M_CLIBAI2 picture "@!"
  @ 06, 48 get M_CLIMUN2 picture "@!"
  @ 07, 48 get M_CLIUF2  picture "@!" valid verest(M_CLIUF2)
  @ 08, 27 get M_CLICGC2 picture "@R 999.999.999/9999-99" valid ecpf()
  read
  restore get from M_GETANT
else
  if !valorescli(M_CUPCLI)
    msg("* * * CLIENTE NAO CADASTRADO * * *")
    return .f.
  endif
  M_CLINOM  = pad(ACLI00->CLINOM, 40)
  M_CLIEND2 = pad(ACLI00->CLIEND2, 40)
  M_CLIBAI2 = pad(ACLI00->CLIBAI2, 15)
  M_CLIMUN2 = pad(ACLI00->CLIMUN2, 19)
  M_CLICEP2 = ACLI00->CLICEP2
  M_CLICCL2 = ACLI00->CLICCL2
  M_CLIUF2  = ACLI00->CLIUF2
  M_CLIIES2 = ACLI00->CLIIES1
  M_CLICGC2 = ACLI00->CLICGC1
  M_CLITEL3 = ACLI00->CLITEL1
  M_CLIEND3 = ACLI00->CLIEND3
  M_CLICDM2 = ACLI00->CLICDM2
  set color to I
  @ 04, 27 say M_CLINOM picture "@!"
  @ 05, 27 say M_CLIEND2 picture "@!"
  @ 06, 27 say M_CLIBAI2 picture "@!"
  @ 06, 48 say M_CLIMUN2 picture "@!"
  @ 07, 48 say M_CLIUF2  picture "@!"
  @ 08, 27 say M_CLICGC2 picture "@R 999.999.999/9999-99"
  set color to

  M_PEDCLI = M_CUPCLI

endif

setcursor(1)

return .t.

*****************
function VERSAT02
*****************

if lastkey() = 5
  return .t.
endif

if empty(M_CUPDTE)
  msg("* * * DATA DE EMISSAO NAO PODE ESTAR VAZIA  * * *")
  return .f.
endif

return .t.

*****************
function VERSAT03
*****************

if lastkey() = 5
  return .t.
endif

if M_CUPVEN = 0
  return .f.
endif

if !BUSCAREGISTRO("AVEN00",1,{str(M_CUPVEN,3,0)},"SELECT")
  msg("* * * VENDEDOR NAO CADASTRADO * * *")
  return .f.
endif

msg("* * * " + alltrim(AVEN00->VENNOM) + " * * *")


return .t.

*****************
function VERSAT04
*****************

if lastkey() = 5
  return .t.
endif

if M_CUPCPG = 0
  return .f.
endif

if !BUSCAREGISTRO("ACPG00",1,{str(M_CUPCPG,3,0)},"SELECT")
  msg("* * * CONDICAO NAO CADASTRADA * * *")
  return .f.
endif

if M_CUPCLI = 90000
  if !strzero(M_CUPCPG, 3, 0) $ "001#008"
    msg("* * * CONDICAO DE PAGAMENTO INVALIDA PARA CONSUMIDOR * * *")
    return .f.
  endif
endif

if left(str(M_CUPNAT, 6, 2), 3) $ "512#612"
  if M_CLIUF2 != "SP"
    if M_CUPNAT != 612.01
      M_CUPNAT = 612.00
    endif
  else
    if M_CUPNAT != 512.01
      M_CUPNAT = 512.00
    endif
  endif
endif

*if M_CUPCPG = 5
*  if M_CLIUF2 != "SP"
*    M_CUPNAT = 622.00
*  else
*    M_CUPNAT = 522.00
*  endif
*endif

*if M_CUPCPG = 3
*  if M_CLIUF2 != "SP"
*    M_CUPNAT = 632.00
*  else
*    M_CUPNAT = 532.00
*  endif
*endif

set color to I
@ 07, 12 say     M_CUPNAT picture "###.##"
set color to

if M_CUPCPG = 5
  M_CUPIPL  = "T"
else
  if M_CUPCPG = 8
    M_CUPIPL  = "C"
  else
    if M_CUPCPG = 3
      M_CUPIPL  = "D"
    else
      M_CUPIPL  = "V"
    endif
  endif
endif

*ALOG00->(dbseek(str(ME_EMP, 2, 0) + M_LOGNOM))

*if M_APC = 1
*  M_CUPVEN  = ALOG00->LOGVEN
*endif

set color to I
@ 05, 73 say M_CUPVEN picture "###"
set color to


return .t.

*****************
function VERSAT06
*****************

if lastkey() = 5
  return .t.
endif

if !M_CUPTRA $ "04#05#06"
  nOpc = 0
  lTela = savescreen(06,49,14,67)
  sombra(06,49,10,66,_SOMBRA_)
  setcolor("GR+/R,W+/N")
  @ 06, 49, 10, 66 box M_FRAME1
  @ 07, 50 prompt "04-Cartao       " POSITION 2 HIGHLITE W+/R
  @ 08, 50 prompt "05-Dinheiro     " POSITION 2 HIGHLITE W+/R
  @ 09, 50 prompt "06-Cheque Papel " POSITION 2 HIGHLITE W+/R
  menu to nOpc
  
  if nOpc = 0
    return .f.
  endif
  
  do case
    case nOpc = 1 ; M_CUPTRA = "04"
    case nOpc = 2 ; M_CUPTRA = "05"
    case nOpc = 3 ; M_CUPTRA = "06"
  endcase
  
  restscreen(06,49,14,67,lTela)
endif


return .t.

*****************
function VERSAT07                      && procura produto
*****************

if lastkey() = 5
  return .t.
endif

if M_CUPMAT[SQ,2] = 0
  sele_arquivo('APCA00')
  if nCodRetorno = 0
    return .f.
  endif
  M_CUPMAT[SQ,2] = nCodRetorno
endif

if !BUSCAREGISTRO("APCA00",1,{str(M_CUPMAT[SQ,2],6,0)},"SELECT")
  msg("* * * PRODUTO NAO CADASTRADO * * *")
  M_CUPMAT[SQ,2] = 0
  return .f.
endif

setcolor("N/W*")
@ LN, 13 say pad(APCA00->PCADES, 28)
@ LN, 42 say pad(APCA00->PCAUNI, 2)
set color to

BUSCAREGISTRO("ASLD00",1,{str(ME_EMP, 2, 0),str(M_CUPMAT[SQ,2],6,0)},"SELECT")

M_CUPMAT[SQ, 4] = ASLD00->SLDPRC

msw(alltrim(APCA00->PCADES))

setcursor(1)

return .t.

*****************
function VERSAT08
*****************

if lastkey() = 5
  return .t.
endif

if M_CUPMAT[SQ, 3] = 0
  return .f.
endif

M_CUPMAT[SQ, 3] = round(M_CUPMAT[SQ, 3], 2)

return .t.

*****************
function VERSAT09
*****************

if lastkey() = 5
  return .t.
endif

if M_CUPMAT[SQ, 4] = 0
  msg("* * * VALOR UNITARIO NAO PODE SER ZEROS * * *")
  return .f.
endif

BUSCAREGISTRO("ASLD00",1,{str(ME_EMP, 2, 0),str(M_CUPMAT[SQ,2],6,0)},"SELECT")

if M_CUPMAT[SQ, 4] < (ASLD00->SLDPRC - ((ASLD00->SLDPRC * .01) * ASLD00->SLDDSC))
  msg("* * * PRECO MENOR QUE DESCONTO PERMITIDO * * * ")
endif

M_CUPMAT[SQ, 5] = round(M_CUPMAT[SQ, 4] * M_CUPMAT[SQ, 3], 2)
M_CUPMAT[SQ, 6] = M_CUPMAT[SQ, 5]

set color to I
@ LN, 66 say M_CUPMAT[SQ, 5] picture "#######.##"
set color to

return .t.

*****************
function VERSAT10
*****************

if lastkey() = 5
  return .t.
endif

if M_CUPCLI > 0
  M_CUPCFN = M_CUPCLI
endif

return .t.

*****************
function VERSAT11
*****************

if lastkey() = 5
  return .t.
endif

if !M_CUPOBS $ "SN"
  msg("* * * VALIDO SOMENTE (S)im ou (N)ao * * *")
  return .f.
endif


return .t.

*****************
function VERSAT13
*****************

if lastkey() = 5
  return .t.
endif

if !M_CUPIPL $ "XZCVD"
  msg("* * * VALIDO SOMENTE Lei(X) Lei(Z) (C)anc (V)enda (D)ev * * *")
  return .f.
endif


return .t.

*****************
function VERSAT14
*****************

if lastkey() = 5
  return .t.
endif

if !M_CUPSIT $ "CVG"
  msg("Valido: (C)anc (V)enda (G)eral")
  return .f.
endif


return .t.

***************
function MOSSAT
***************

parameters  M_MODO, M_ELEM, M_POSI

if str(lastkey(), 2, 0) $ " 3#27#18"
  return 0
endif

if str(lastkey(), 3, 0)  $ "# 49# 50# 51# 52# 53# 54# 13"
  M_OPC = M_ELEM
  return 1
endif

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

M_LINPOS = M_POSI

return 2

****************
function MSSAT04                     && mostra dados e calcula nota fiscal
****************

lOCAL aBlocks2 := {}
aLastPaint6 := WvtSetBlocks( aBlocks2 )

private  M_TELA ,;
R

M_TELA = savescreen(07, 20, 16, 62)

nbox(07, 20, 11, 59,"W/W+",.t.)
setcolor("B/W")
@ 08, 21 say  "Valor do Produto  :                   "
@ 09, 21 say  "Valor do Desconto :                   "
@ 10, 21 say  "Valor do Cupom    :                   "
set color to

setcolor("N/W*")
@ 08, 41 say ACUP00->CUPVLP                 picture "@E ###,###,###,###.##"
@ 09, 41 say ACUP00->CUPDSC                 picture "@E ###,###,###,###.##"
@ 10, 41 say ACUP00->CUPVLN                 picture "@E ###,###,###,###.##"
set color to

msg("* * * TECLE (ENTER) * * *")

WvtSetBlocks( aLastPaint6 )
restscreen(07, 20, 16, 62, M_TELA)

return ""

******************
function GRAVA_SAT(cACAO)
******************

sqlCAMPO = {}
sqlCHAVE = {}
sqlARQUI = {"ACUP00",(cACAO)}

aadd(sqlCHAVE,{"CUPEMP",str(M_CUPEMP, 2)})
aadd(sqlCHAVE,{"CUPNUM",str(M_CUPNUM, 9)})
aadd(sqlCHAVE,{"CUPSER",aspas(M_CUPSER)})

if !cACAO $ "#DELETE#SELECT#"
  aadd(sqlCAMPO,{"CUPEMP",str(M_CUPEMP,2),.T.})
  aadd(sqlCAMPO,{"CUPNUM",str(M_CUPNUM,9),.T.})
  aadd(sqlCAMPO,{"CUPSER",M_CUPSER,.T.})
  aadd(sqlCAMPO,{"CUPCAN","E",.T.})
  aadd(sqlCAMPO,{"CUPDTE",formatdta(M_CUPDTE),.T.})
  aadd(sqlCAMPO,{"CUPDTS",formatdta(M_CUPDTE),.T.})
  aadd(sqlCAMPO,{"CUPNAT",str(51200,5),.T.})
  aadd(sqlCAMPO,{"CUPCLI",str(M_CUPCLI,5),.T.})
  aadd(sqlCAMPO,{"CUPCPG",str(val(M_CUPCPG),3),.T.})
  aadd(sqlCAMPO,{"CUPVEN",str(M_CUPVEN,3),.T.})
  aadd(sqlCAMPO,{"CUPVLP",str1(M_CUPVLP,2),.T.})
  aadd(sqlCAMPO,{"CUPDSC",str1(M_CUPDSC,2),.T.})
  aadd(sqlCAMPO,{"CUPVLN",str1(M_CUPVLN,2),.T.})
  aadd(sqlCAMPO,{"CUPHS6",M_NOAR,.T.})
  aadd(sqlCAMPO,{"CUPNATN","5.102",.T.})
  aadd(sqlCAMPO,{"CLICGC",M_CLICGC2,.T.})
  aadd(sqlCAMPO,{"CUPNOM",M_CLINOM,.T.})
  aadd(sqlCAMPO,{"CUPIND",str(M_NFSIND,5),.T.})
  aadd(sqlCAMPO,{"CUPTRN",M_NFSMES,.T.})

endif

executasql()

return ""

*******************
function RETIRA_SAT
*******************

select ACUP00 
if !dbseek(str(M_CUPEMP, 2, 0) + str(M_CUPNUM, 6, 0) + M_CUPSER)
  return ""
endif

select ACUP01

do while .t.
  
  dbseek(str(ACUP00->CUPEMP, 2, 0) + str(ACUP00->CUPNUM, 6, 0) + ACUP00->CUPSER,.t.)
  
  if !str(CUPEMP, 2, 0) + str(CUPNUM, 6, 0) + CUPSER == str(ACUP00->CUPEMP, 2, 0) + str(ACUP00->CUPNUM, 6, 0) + ACUP00->CUPSER
    exit
  endif
  
  select AKAR00
  MS = strzero(ME_EMP,2)

  if dbseek(str(ACUP00->CUPEMP, 2, 0) + str(ACUP01->CUPMAT, 6, 0) + dtos(ACUP00->CUPDTE) + str(ACUP00->CUPNAT, 5, 0) + str(ACUP00->CUPNUM, 6, 0) + ACUP00->CUPSER + str(ACUP01->CUPSEQ, 2, 0))
    AFIS00->(dbseek(ACUP00->CUPNATN))
    select APCA00
    if dbseek(str(ACUP01->CUPMAT, 6, 0))
      do while .t.
        if rlock()
          if AFIS00->FISEST = "C"
            replace SLD&MS with (SLD&MS - AKAR00->KARQDE)
          else
            if AFIS00->FISEST = "D"
              replace SLD&MS with (SLD&MS + AKAR00->KARQDE)
            endif
          endif
          unlock
          commit
          exit
        else
          msg("* * * (ASLD00) REGISTRO SENDO USADO * * *")
        endif
        if lastkey()=17
          exit
        endif
      enddo
    endif
    select AKAR00
    elimina()
  endif
  
  select ACUP01
  elimina()
enddo

select ACUP00
elimina()

return ""

***************
function NUMSAT
***************

save get to M_GETCUP

private M_NOME  ,;
M_NSER  ,;
M_TELA  ,;
M_DATA  ,;
M_NOVNUM,;
M_NOVSER

M_NOVNUM = 0
M_NOVSER = "  "

M_TELA = savescreen(11, 25, 15, 54)

do while .t.
  
  sombra(11, 27, 14, 51,_SOMBRA_)
  
  set color to GR+/BG+
  @ 11, 27 say         "ÚÄÄÄÄÄNovo NumeroÄÄÄÄÄÄÄ¿"
  @ 12, 27 say         "³ Cup. Fiscal:          ³"
  @ 13, 27 say         "³ Serie Cupom:          ³"
  @ 14, 27 say         "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
  SetColor(_COREDICAO_)

  @ 12, 42 get M_NOVNUM picture "999999"
  @ 13, 42 get M_NOVSER picture "@!"
  read
  
  if lastkey() = 27
    exit
  endif
  
  select ACUP00
  
  if dbseek(str(ME_EMP, 2, 0) + str(M_NOVNUM, 6, 0) + M_NOVSER)
    msg("* * * CUPOM FISCAL JA CADASTRADA * * *")
    loop
  endif
  
  M_FLG   = .f.
  M_CUPNUM = M_NOVNUM
  M_CUPSER = M_NOVSER
  
  set color to I
  @ 04, 12 say     M_CUPNUM picture "######"
  @ 04, 19 say     M_CUPSER picture "@!"
  set color to
  
  if M_CUPNUM = 0
    loop
  endif
  
  if empty(M_CUPSER)
    msg("* * * SERIE NAO PODE ESTAR VAZIA * * *")
    loop
  endif
  
  exit
  
enddo

restore get from M_GETCUP

set cursor on

restscreen(11, 25, 15, 54, M_TELA)

lAltr = .t.

return ""

****************
function EMISATB
****************

msw("* * * Gravando cFe * * *")

select ACUP00

append blank

grava_sat("INSERT")

select ACLI00            && atualiza ultima compra do Cliente

do while .t.
  if rlock()
    replace CLIULC with M_CUPDTE
    unlock
    exit
  else
    msg("* * * (ACLI00) Registro sendo usado * * *")
    if lastkey()=17
      exit
    endif
  endif
enddo

AFIS00->(dbseek(M_CUPNAT))

for Y = 1 to len(M_CUPMAT)
  
  if M_CUPMAT[Y,3] = 0
    loop
  endif
  
  APCA00->(dbseek(str(M_CUPMAT[Y, 2], 6, 0)))
  
  select ACUP01
  
  append blank
  
  do while .t.
    if rlock()
      replace CUPEMP  with M_CUPEMP
      replace CUPNUM  with M_CUPNUM
      replace CUPSER  with M_CUPSER
      replace CUPSEQ  with M_CUPMAT[Y, 1]
      replace CUPMAT  with M_CUPMAT[Y, 2]
      replace CUPQDE  with M_CUPMAT[Y, 3]
      replace CUPPRB  with M_CUPMAT[Y, 4]
      replace CUPVLI  with M_CUPMAT[Y, 5]
      replace CUPLIQ  with M_CUPMAT[Y, 6]
      replace CUPCLI  with M_CUPCLI
      replace CUPDTE  with M_CUPDTE
      replace CUPVEN  with M_CUPVEN
      replace CUPNAT  with M_CUPNAT * 100
      replace CUPCPG  with val(M_CUPCPG)
      replace CUPIPL  with iif(empty(M_CUPIPL),"V",M_CUPIPL)
      replace CUPTRN  with date()
      unlock
      commit
      exit
    else
      msg("* * * (ACUP01) REGISTRO SENDO USADO * * *")
    endif
    if lastkey()=17
      exit
    endif
  enddo
  
  select AKAR00
  _append("AKAR00")
      do while .t.
        if rlock()
          replace KAREMP       with M_CUPEMP
          replace KARMAT       with M_CUPMAT[Y, 2]
          replace KARDTA       with M_CUPDTE
          replace KARFISN      with M_CUPMAT[Y, 7]
          replace KARDOC       with M_CUPNUM
          replace KARSER       with M_CUPSER
          replace KARSEQ       with M_CUPMAT[Y, 1]
          replace KARCLF       with M_CUPCLI
          replace KARQDE       with M_CUPMAT[Y, 3]
          replace KARVLI       with M_CUPMAT[Y, 5]
          unlock
          commit
          exit
        else
          msg("* * * (AKAR00) Registro sendo usado * * *")
        endif
        if lastkey()=27
          exit
        endif
      enddo
  
next && R

commit

restscreen(11, 24, 15, 51, M_TELA)

msg("* * * Fim de Emissao * * *")

return ""

******************
function OUTSAT_AA 
******************
LOCAL aBlocks1 := {}
lOCAL aBlocks6 := {}

  aAdd( aBlocks1, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )
  aAdd( aBlocks1, {|| Wvt_DRAWBOXRECESSED( 03, 02, 20, 76) } )
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 11, 76,{+15,,-15,})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 02, 20, 5 ,{+15,,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 06, 20, 12,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 13, 20, 41,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 42, 20, 44,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 45, 20, 54,{+15,-10,,-10})})
  aAdd( aBlocks1, {|| WVT_DRAWBOXGROUP( 09, 55, 20, 65,{+15,-10,,-10})})

  aLastPaint1 := WvtSetBlocks( aBlocks1 )

private M_OPC

tlsat01()

M_CUPEMP = ME_EMP

M_CUPSER = "1 "


M_CUPNUM = 0

SetColor(_COREDICAO_)
@ 04, 12 get M_CUPNUM picture "######"
read
setcolor("N/W*")
@ 04, 19 say M_CUPSER picture "@!"
set color to

if !BUSCAREGISTRO("ACUP00",1,{str(M_CUPEMP, 2, 0),str(M_CUPNUM, 6, 0),aspas(M_CUPSER)},"SELECT")
  msg("* * * CFe NAO INCLUIDO * * *")
  WvtSetBlocks( aLastPaint1 )
endif

setcolor("N/W*")
@ 04, 12 say M_CUPNUM picture "######"
@ 04, 19 say M_CUPSER picture "@!"
set color to

mssat01()
mssat03()

M_OPC = decide("Confirma Cancelamento deste CFe")

if M_OPC != 1
  msg("* * * NADA FOI EFETUADO * * *")
  WvtSetBlocks( aLastPaint1 )
  return ""
endif

*  mon_env("Sat.Inicializar")  // vamos ver status
*  cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

*  cCFE = "F:\CIRUR\ENVIADO\SAT\Vendas\" + alltrim(ACUP00->CUPTRN) + "\" + alltrim(ACUP00->CUPHS6)

   cFileDanfe = "F:\CIRUR\ENVIADO\" + alltrim(ACUP00->CUPTRN) + "\NFCE\" + alltrim(ACUP00->CUPHS6)

   M_MEMO := NFe_CAN(alltrim(ACUP00->CUPHS6))

nTela2 := savescreen(0,0,24,80)

aLastPaint6 := WvtSetBlocks( aBlocks6 )

nbox(2,10,23,70,"W/W+",.t.)
setcolor("B/W")

@  3, 11 say padc("CANCELANDO NFC-e",59)

setcolor("N/W*")
keyboard chr(30) + chr(27)
memoedit(M_MEMO,04,11,22,69,.f.,,60)


*  mon_env('SAT.CancelarCFe("' + cCFE + '")')
*  cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
  
*  if !"|07000|" $ cRet
*    msg("PROBLEMA NO CANCELAMENTO")
*    WvtSetBlocks( aLastPaint1 )
*    return ""
*  endif

 * N_POS = rat("Arquivo=F:\CIRUR\ENVIADO\SAT\Cancelamentos",cRet)

 * cCAN   = "F:\CIRUR\ENVIADO\SAT\Cancelamentos\" + alltrim(ACUP00->CUPTRN) + "\" + substr(cRet,n_pos+49,51)  // NOME DO XML

 * mon_env('SAT.ImprimirExtratoCancelamento("'  + cCFE + '", "' + cCAN + '")')

if "<CSTAT>135</CSTAT>" $ upper(M_MEMO)

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"ACUP01","UPDATE"}
  aadd(sqlCHAVE,{"CUPEMP",str(ACUP00->CUPEMP,2)})
  aadd(sqlCHAVE,{"CUPNUM",str(ACUP00->CUPNUM,6)})
  aadd(sqlCHAVE,{"CUPSER",aspas(ACUP00->CUPSER)})
  aadd(sqlCAMPO,{"CUPCAN","C",.t.})
  executasql()

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"ACUP00","UPDATE"}
  aadd(sqlCHAVE,{"CUPEMP",str(ACUP00->CUPEMP,2)})
  aadd(sqlCHAVE,{"CUPNUM",str(ACUP00->CUPNUM,6)})
  aadd(sqlCHAVE,{"CUPSER",aspas(ACUP00->CUPSER)})
  aadd(sqlCAMPO,{"CUPCAN","C",.t.})
  executasql()

  msg("* * * CFe CANCELADO * * *")
else
  msg("* * * CFe NAO CANCELADO - VERIFIQUE O PROBLEMA * * *")
endif

WvtSetBlocks( aLastPaint6 )
restscreen(0,0,24,80,nTela2)
WvtSetBlocks( aLastPaint1 )

return ""

*****************
function GRAVASAT
*****************

grava_sat("INSERT")

sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"ACLI00","UPDATE"}
aadd(sqlCHAVE,{"CLICOD",str(M_CUPCLI,5)})
aadd(sqlCAMPO,{"CLIULC",formatdta(M_CUPDTE),.t.})
executasql()

for Y = 1 to len(M_CUPMAT)

  if M_CUPMAT[Y,3] = 0
    loop
  endif

  sqlCAMPO = {}
  sqlCHAVE = {}
  sqlARQUI = {"ACUP01","INSERT"}

  aadd(sqlCAMPO,{"CUPEMP",str(M_CUPEMP,2),.T.})
  aadd(sqlCAMPO,{"CUPNUM",str(M_CUPNUM,6),.T.})
  aadd(sqlCAMPO,{"CUPSER",M_CUPSER,.T.})
  aadd(sqlCAMPO,{"CUPSEQ",str(M_CUPMAT[Y, 1],3),.T.})
  aadd(sqlCAMPO,{"CUPMAT",str(M_CUPMAT[Y, 2],6),.T.})
  aadd(sqlCAMPO,{"CUPQDE",str1(M_CUPMAT[Y, 3],2),.T.})
  aadd(sqlCAMPO,{"CUPPRB",str1(M_CUPMAT[Y, 4],2),.T.})
  aadd(sqlCAMPO,{"CUPVLI",str1(M_CUPMAT[Y, 5],2),.T.})
  aadd(sqlCAMPO,{"CUPLIQ",str1(M_CUPMAT[Y, 6],2),.T.})
  aadd(sqlCAMPO,{"CUPDTE",formatdta(M_CUPDTE),.T.})
  executasql()

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"AKAR00","INSERT"}

  aadd(sqlCAMPO,{"KAREMP",str(M_CUPEMP, 2),.t.})
  aadd(sqlCAMPO,{"KARMAT",str(M_CUPMAT[Y, 2], 6),.t.})
  aadd(sqlCAMPO,{"KARDTA",FORMATDTA(M_CUPDTE),.t.})
  aadd(sqlCAMPO,{"KARFISN",M_CUPMAT[Y, 7],.t.})
  aadd(sqlCAMPO,{"KARDOC",str(M_CUPNUM, 7),.t.})
  aadd(sqlCAMPO,{"KARSER",M_CUPSER,.t.})
  aadd(sqlCAMPO,{"KARSEQ",str(M_CUPMAT[Y, 1], 2),.T.})
  aadd(sqlCAMPO,{"KARCLF",str(M_CUPCLI,5),.t.})
  aadd(sqlCAMPO,{"KARQDE",str1(M_CUPMAT[Y, 3],3),.t.})
  aadd(sqlCAMPO,{"KARVLI",str1(M_CUPMAT[Y, 5],2),.t.})
  executasql()

next && R

return ""
*****************
function IMPCPSAT(F_IMPRIME)
*****************

if !BUSCAREGISTRO("AVEN00",1,{str(M_CUPVEN,3,0)},"SELECT")
  msg("* * * Vendedor nao cadastrado * * *")
  return ""
endif

geraxmlsat()

if !"TESTE" $ M_LOGNOM
  if lNFE
    if xmlnfce(F_IMPRIME)
      return(.t.)
    endif
  else
    if novo_xmlsat(F_IMPRIME)
      return(.t.)
    endif
  endif
else
  return .t.
endif


* 2 = grava
* 3 = imprime


return .f.

*************
function ECPF
*************

if empty(M_CLICGC2)
  return .t.
endif

if len(alltrim(M_CLICGC2))=15
  if !cgc(right(M_CLICGC2,14))
    msg("* * * CGC INVALIDO * * *")
    return .f.
  endif 
else
  if len(alltrim(M_CLICGC2))=11
    if !cpf(left(M_CLICGC2,11))
      msg("* * * CPF INVALIDO * * *")
      return .f.
    endif 
  else
    msg("* * * NAO E' CGC/CPF * * *")
    return .f.
  endif
endif


  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ACLI00","ACLI00"})
  aadd(sqlCAMPO,"ACLI00.*")
  aadd(sqlCHAVE,"CLICGC2 = " + aspas(M_CLICGC2))
  sqlrelation()


if !eof()
*  msg("* * * CLIENTE COM CADASTRO - CODIGO: " + str(CLICOD, 7, 0) + " * * *")
  M_CUPCLI = CLICOD


  M_CLINOM  = pad(ACLI00->CLINOM, 40)
  M_CLIEND2 = pad(ACLI00->CLIEND2, 40)
  M_CLIBAI2 = pad(ACLI00->CLIBAI2, 15)
  M_CLIMUN2 = pad(ACLI00->CLIMUN2, 19)
  M_CLICEP2 = ACLI00->CLICEP2
  M_CLICCL2 = ACLI00->CLICCL2
  M_CLIUF2  = ACLI00->CLIUF2
  M_CLIIES2 = ACLI00->CLIIES1
  M_CLICGC2 = ACLI00->CLICGC1
  M_CLITEL3 = ACLI00->CLITEL1
  M_CLIEND3 = ACLI00->CLIEND3
  set color to I
  @ 04, 27 say M_CLINOM picture "@!"
  @ 05, 27 say M_CLIEND2 picture "@!"
  @ 06, 27 say M_CLIBAI2 picture "@!"
  @ 06, 48 say M_CLIMUN2 picture "@!"
  @ 07, 48 say M_CLIUF2  picture "@!"
  @ 08, 27 say M_CLICGC2 picture "@R 999.999.999/9999-99"
  set color to

  M_PEDCLI = M_CUPCLI
  return .t.
endif

return .t.


****************
function EMICUPN
****************

  select ACUP00

  dbsetorder(1)

  dbseek(str(ME_EMP, 2, 0) + str(1, 6, 0) +  AEMP00->EMPCFE, .t.)

  ? replicate("-",132)  

  M_CUPNUM = 1

  do while .t.

    select ACUP00
     
    if dbseek(str(ME_EMP, 2, 0) + str(M_CUPNUM, 6, 0) + AEMP00->EMPCFE)
      if M_CUPNUM > M_CUP2
        exit
      endif
      M_CUPNUM = M_CUPNUM + 1
      loop
    endif 

    ? str(M_CUPNUM, 6)
      ?? "  "
      ?? AEMP00->EMPCFE
      ?? space(110)
      ?? "NAO INCLUIDO"

    M_CUPNUM = M_CUPNUM + 1

    if M_CUPNUM > M_CUP2
      exit
    endif

  enddo

  ? replicate("-",132)  

  eject

  if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
    ?? chr(18)                        && descomprime
  endif
 
  desliga1()

return ""

***************
function IMPTOT
***************

parameter PASSO

do case
   case PASSO = "DIANOT"
                if (N_DIAVIS + N_DIAPRZ) > 0
                    ?    space(39) 
                    ?? "TOTAIS DO DIA . . . . . . . .    A VISTA " 
                    ?? transform(N_DIAVIS,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "                                 A PRAZO " 
                    ?? transform(N_DIAPRZ,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "                    (A VISTA +  A PRAZO) " 
                    ?? transform(N_DIAPRZ+N_DIAVIS,"@E ##,###,###.##")
                    if N_DIACAN > 0
                      ? space(39)
                      ?? "CANCELADAS.............................. " 
                      ?? transform(N_DIACAN,"@E ##,###,###.##")
                      LN++
                    endif
                    ?    space(39) 
                    ?? "                 SUBSTITUICAO TRIBUTARIA " 
                    ?? transform(N_DIASUB,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "                                SERVICOS " 
                    ?? transform(N_DIASER,"@E ##,###,###.##")
            
                    ? replicate("-", 132)
                    LN += 6
                endif
   case PASSO = "DIACUP"
                if (C_DIAVIS + C_DIAPRZ) > 0
                    ?    space(39)
                    ?? "TOTAIS DO DIA . . . . . . . .    A VISTA " 
                    ?? transform(C_DIAVIS,"@E ##,###,###.##")
                    ?    space(39)
                    ?? "                                 A PRAZO " 
                    ?? transform(C_DIAPRZ,"@E ##,###,###.##")
                    ?    space(39)
                    ?? "                    (A VISTA +  A PRAZO) " 
                    ?? transform(C_DIAPRZ+C_DIAVIS,"@E ##,###,###.##")
                    if C_DIACAN > 0
                      ? space(39)
                      ?? "CANCELADOS.............................. " 
                      ?? transform(C_DIACAN,"@E ##,###,###.##")
                      LN++
                    endif
                    ?    space(39) 
                    ?? "                 SUBSTITUICAO TRIBUTARIA " 
                    ?? transform(C_DIASUB,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "                                SERVICOS " 
                    ?? transform(C_DIASER,"@E ##,###,###.##")
                    ? replicate("-", 132)
                    LN += 6
                endif
   case PASSO = "GERAL"
                    ?    space(39) 
                    ?? "TOTAL GERAL . . . . . . . . .    A VISTA " 
                    ?? transform(N_TOTVIS + C_TOTVIS,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "                                 A PRAZO " 
                    ?? transform(N_TOTPRZ + C_TOTPRZ,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "                    (A VISTA +  A PRAZO) " 
                    ?? transform(N_TOTPRZ+N_TOTVIS+C_TOTPRZ+C_TOTVIS,"@E ##,###,###.##")
                    if C_TOTCAN + N_TOTCAN > 0
                      ? space(39)
                      ?? "CANCELADOS.............................. " 
                      ?? transform(C_TOTCAN + N_TOTCAN,"@E ##,###,###.##")
                      LN++
                    endif
                    ?    space(39) 
                    ?? "                 SUBSTITUICAO TRIBUTARIA " 
                    ?? transform(C_TOTSUB + N_TOTSUB,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "                                SERVICOS " 
                    ?? transform(C_TOTSER + N_TOTSER,"@E ##,###,###.##")
                    ? replicate("-", 132)
                    LN += 6
endcase

return ""  

******************
function CALSUBSER   // Substituicao e servicos
******************

parameter pARQBUS

cSUB := 0
cSER := 0
cTOT := 0

if pARQBUS = "NFS"
  if !ANFS00->NFSCAN = "C"
    select ANFS01
    seek ANFS00->NFSNUM

    do while !eof()
      if !str(ANFS00->NFSNUM,9) == STR(ANFS01->NFSNUM,9)
        exit
      endif
    if PCAGRP = 120  // Servicos
      cSER += NFSLIQ
    endif
    if NFSMAT # 1 // FRETE
      if NFSNATN $ "5.403#5.405"
        cSUB += NFSLIQ + NFSVIP
      endif
    endif
    skip
  enddo
  endif
  select ANFS00
endif

if pARQBUS = "CUP"
  if !CUPCAN $ "C"
    select ACUP01
    seek ACUP00->CUPNUM

    do while !eof()
      if !str(ACUP00->CUPNUM,9) == STR(ACUP01->CUPNUM,9)
        exit
      endif

      cTOT += CUPLIQ
      if PCAGRP = 120  // Servicos
        cSER += CUPLIQ
      endif
      if PCATRI = 4  // Substituicao Tributaria
        cSUB += CUPLIQ
      endif
      skip
    enddo
  endif
  select ACUP00
endif

return ""

****************
function TLCUP02    
****************

nbox(03, 04, 20, 76,"W/W+",.t.)
setcolor("B/W")
    @ 04, 04 say     " Cliente :         Nome:                               Mun:              "
    @ 05, 04 say     " ÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÂÄÄÄÄÄÄÄÄÄÄÄ "
    @ 06, 04 say     "    Data   ³NumEcf³Se³Cpg³Tra³Ven³Nome     ³ Ope  ³ Nfs  ³Se³  Total     "
    @ 07, 04 say     " ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÅÄÄÄÄÄÄÄÄÄÄÄ "
    @ 08, 04 say     "           ³      ³  ³   ³   ³   ³         ³      ³      ³  ³            "
    @ 09, 04 say     "           ³      ³  ³   ³   ³   ³         ³      ³      ³  ³            "
    @ 10, 04 say     "           ³      ³  ³   ³   ³   ³         ³      ³      ³  ³            "
    @ 11, 04 say     "           ³      ³  ³   ³   ³   ³         ³      ³      ³  ³            "
    @ 12, 04 say     "           ³      ³  ³   ³   ³   ³         ³      ³      ³  ³            "
    @ 13, 04 say     "           ³      ³  ³   ³   ³   ³         ³      ³      ³  ³            "
    @ 14, 04 say     "           ³      ³  ³   ³   ³   ³         ³      ³      ³  ³            "
    @ 15, 04 say     "           ³      ³  ³   ³   ³   ³         ³      ³      ³  ³            "
    @ 16, 04 say     " ÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÁÄÄÄÄÄÄÄÄÄÄÄ "
    @ 17, 04 say     "                                                                         "
    @ 18, 04 say     "                                                                         "
    @ 19, 04 say     "                                                                         "
set color to

return ""

******************
function MOSDATCUP
******************

parameters F_CHAVE

private M_TELA, R, L, M_OPC , M_VERTORITE


  M_TELA = savescreen(03, 02, 21, 77)

  tlsat01()

  select ACUP00

  if !dbseek(F_CHAVE)
    msg("* * * CUPOM FISCAL NAO INCLUIDO * * *")
    restscreen(03, 02, 21, 77, M_TELA)
    return ""
  endif

  mssat01()

  select ACUP01

  dbseek(str(ACUP00->CUPEMP, 2, 0) + str(ACUP00->CUPNUM, 6, 0) + ACUP00->CUPSER,.t.)

  L = 0

  do while !eof()
    if !str(CUPEMP, 2, 0) + str(CUPNUM, 6, 0) + CUPSER == str(ACUP00->CUPEMP, 2, 0) + str(ACUP00->CUPNUM, 6, 0) + ACUP00->CUPSER
      exit
    endif
    skip
    L = L + 1
  enddo

  if L = 0
    msg("* * * CUPOM FISCAL NAO POSSUE ITENS * * *")
    restscreen(03, 02, 21, 77, M_TELA)
    return ""
  endif

  declare M_VETORITE[L]

  R = 1

  dbseek(str(ACUP00->CUPEMP, 2, 0) + str(ACUP00->CUPNUM, 6, 0) + ACUP00->CUPSER,.t.)


  do while !eof()

    if !str(CUPEMP, 2, 0) + str(CUPNUM, 6, 0) + CUPSER == str(ACUP00->CUPEMP, 2, 0) + str(ACUP00->CUPNUM, 6, 0) + ACUP00->CUPSER
      exit
    endif

      BUSCAREGISTRO("APCA00",1,{str(ACUP01->CUPMAT,6,0)},"SELECT")

      select ACUP01

      M_VETORITE[R] = str(CUPSEQ, 2, 0) + " " + ;
                      str(CUPMAT, 6, 0) + " " + ;
                      pad(PCADES,21)  + " " + ;
                      pad(PCAUNI,02)  + " " + ;
                      str(CUPCOM, 6, 2) + " " + ;
                      str(CUPQDE, 9, 3) + " " + ;
                      str(CUPPRB,10, 2) + " " + ;
                      str(CUPVLI,10, 2) + " "
  
    skip

    R = R + 1

  enddo

  M_LINPOS = 0

  do while .t.

    setas()

    set color to N/W,W+/N
      M_OPC = achoice(12, 3,19,75,M_VETORITE,,"mostec")
    set color to 

    if lastkey() = 27
      exit        && abandona operacao
    endif

  enddo

  restscreen(03, 02, 21, 77, M_TELA)

return ""


