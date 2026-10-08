#include "ACEL.CH"
#include "VISUAL2.CH"

#define IDM_NOVO     1001
#define IDM_GRAVAR   1002
#define IDM_SAIR     1003

#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)

#command @ <row> , <col>  GET <var> [<clauses,...>] F2 [<moreClauses,...>] funcao <func> retorno <Variavel>;
=>       @ <row> , <col>  GET <var> [<clauses>] SEND reader := {|oGet| Getf2(oGet,<func>,<Variavel>) } [<moreClauses>]


***************
function MANNFS
***************
local cRet := ""
parameters M_OPC,M_OPC1,M_OPC2


//IMAGEM()
*edbox()
*maxi()
*telas()
*diversos()
 
*if ME_EMP = 1
*  filecopy("C:\ACBrNfeMonitor\ACBrATLAS.ini","C:\ACBrNfeMonitor\ACBrMonitor.ini")           // Copy the file
*else
*  if ME_EMP = 10
*    filecopy("C:\ACBrNfeMonitor\ACBrNutri.ini","C:\ACBrNfeMonitor\ACBrMonitor.ini")           // Copy the file
*  endif
*endif

*mon_env("ACBr.Lerini")

X_SCAN = "N" // left(AEMP00->EMPJUN,1)      // impressao formulario comum
X_FSDA = "N" // substr(AEMP00->EMPJUN,2,1)  // impressao formulario especial
X_DENEGA = .f.
Z_EMAIL2 = space(50)
lRecnota = 0

zPCALOT = " "
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
zSLD10 = 0

zPCADES=space(50)

lNFSSER = .f.

M_NFSCOMP = "N" // COMPLEMENTO

      zCLICGC1  = space(15)
      zCLICDM2  = 0
      zCLITIP   = " "
      zCLICOD   = 0
      zCLINRO2  = space(5)
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

#include "ptmenu.ch"


    _FUNIND_ = "NFS.t."
    _FUNCLI_ = "NFS.t."
    _FUNPRO_ = "NFS.t."
    _FUNFOR_ = "NFS.t."
    _FUNCPG_ = "NFS.t."
    _FUNTRA_ = "NFS.t."
    _FUNVEN_ = "NFS.t."
    _FUNPLX_ = "NFS.f."
    lSosub = .t.  // so substituicao sim ou nao
    lSoser = .f.  // so servicos


      rodape("MENU", "NF PRODUTO", M_FAN, "EAGRO21", "Mem: " + str(memory(0), 5), M_EMP)

      do case
         case M_OPC = 1 ; incnfs("NORMAL")
         case M_OPC = 2 ; altnfs(M_OPC1)
         case M_OPC = 3 ; connfs()
         case M_OPC = 4 ; excnfs()
         case M_OPC = 5 ; lisnfs(M_OPC1)
         case M_OPC = 6 ; outnfs(M_OPC1)
         case M_OPC = 7 ; contra01()
         case M_OPC = 8 ; INCNFS("INCLUSAO")       
      endcase

    fecha_arq()

    AlteraRestauraTela("TLNFS01",.f.)

return ""

***************************
FUNCTION AlteraRestauraTela(cTela, lValor )
***************************
   LOCAL nPos

   nPos := AScan( aRestauratelas, { |aItem| aItem[1] == cTela } )

   IF nPos > 0
     aRestauratelas[nPos][2] := lValor
   else
     aadd(aRestauratelas,{cTela,lValor})
   ENDIF

RETURN .t.

***************
function INCNFS(TIPO)
***************

if TIPO = NIL
  TIPO = "NORMAL"
endif

private M_TELA ,;
        M_OPC

declare M_MSG[26] ,;
        M_HIS[6]  ,;
        M_CPL[6]  ,;
        M_CLA[4]

        M_TRANOM = AEMP00->EMPNOM
        M_TRAEND = AEMP00->EMPEND
        M_TRAMUN = left(AEMP00->EMPMUN, 15)
        M_TRAEST = AEMP00->EMPEST
        M_TRACEP = AEMP00->EMPCEP
        M_TRACCL = AEMP00->EMPCCE
        M_TRAPLC = space(07)
        M_TRAVIA = "RODOVIARIO "
        M_TRACGC = AEMP00->EMPCGC
        M_TRAIES = AEMP00->EMPIES

store 0 to R

M_HIS[1] = "                                                            "
M_HIS[2] = "                                                            "
M_HIS[3] = "                                                            "
M_HIS[4] = "                                                            "
M_HIS[5] = "                                                            "
M_HIS[6] = "                                                            "

M_CLA[1] = "            "
M_CLA[2] = "            "
M_CLA[3] = "            "
M_CLA[4] = "            "

private M_DUP[4, 3],M_ORD[4, 3],M_SER[4, 3],M_VAL[4, 3],M_DIA[4,3]
declare M_DUP[4, 3],M_ORD[4, 3],M_SER[4, 3],M_VAL[4, 3],M_DIA[4,3],M_REQ[30]

for R = 1 to 4
  for S = 1 to 3
    M_DUP[R,S] = 0
    M_ORD[R,S] = 0
    M_VAL[R,S] = 0
    M_DIA[R,S] = 0
  next
next

for R = 1 to 30
  M_REQ[R] = 0
next


LTALA20 := savescreen(0,0,maxrow(),maxcol())


*wvw_tbDestroy(0)

*wvw_tbCreate( , .f., NIL, 0, 48, 24 )
*wvw_tbAddButton( ,1001,"C:\Users\Administrador\OneDrive\Sistema\atlas\Clienlist.bmp",,0 )
*wvw_tbAddButton( ,1002,"C:\Users\Administrador\OneDrive\Sistema\atlas\alterar.bmp",,0 )

do while .t.

  store 0 to R

  set key -9 to CALCULA()
  set key 275 to NUMNFS()
  set key 304 to BOLNFS()

  rodape("EMISSAO","NOTA FISCAL",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP) 


  tlnfs01()
  AlteraRestauraTela("TLNFS01",.t.)
  
*  wvw_paint()

 // aqui
 

//  WVW_MessageBox( , "teste de mensagem", "titulo da mensagem", 3+16 )


*  wvw_pbSetFont( ,'Visuallib', _FONTET1_, _FONTEL2_, 0, 200)
*  nbt1 := wvw_pbCreate( 0, 29, 5, 29, 12, "1.Total", NIL, {|| VLKeyboard( CHR( 49 )) } )
*  nbt2 := wvw_pbCreate( 0, 29, 14, 29, 25, "2.Cabecario", NIL, {|| VLKeyboard( CHR( 50 )) } )
*  nbt3 := wvw_pbCreate( 0, 29, 27, 29, 35, "3.Apagar", NIL, {|| VLKeyboard( CHR( 51 )) } )
*  nbt4 := wvw_pbCreate( 0, 29, 37, 29, 47, "4.Adiciona", NIL, {|| VLKeyboard( CHR( 52 )) } )
*  nbt5 := wvw_pbCreate( 0, 29, 49, 29, 59, "5.Desconto", NIL, {|| VLKeyboard( CHR( 53 )) } )
*  nbt6 := wvw_pbCreate( 0, 29, 61, 29, 70, "6.Emissao", NIL, {|| VLKeyboard( CHR( 54 )) } )

  M_NFSEMP  = ME_EMP
  M_NFSNUM  = AEMP00->EMPNFS + 1
  M_NFSSER  = AEMP00->EMPSER
         
  do while .t.

    fecha_arq()
    SEATUALIZA()

    M_NFSMAT = {}

    set color to I
      @ 08, 18 say M_NFSNUM picture "########"
      @ 08, 40 say M_NFSSER picture "@!"
    set color to

    if BUSCAREGISTRO("ANFS00",1,{str(M_NFSEMP, 2, 0),str(M_NFSNUM, 6, 0),aspas(M_NFSSER)},"SELECT")
      if TIPO == "INCLUSAO"
        msg("NUMERO DE NF JA INCLUIDO")
        vlrestscreen(02, 04, 25, 79,M_TELA1)
        return ""
      endif
      M_NFSNUM = M_NFSNUM + 1
      loop
    endif
    exit

  enddo

  M_AUTFAT = 0
  M_NFSDTE = date()
  M_NFSDTS = date() && ctod("  /  /  ")
  M_NFSHOR = left(time(), 06) + "00"
  M_NFSCLI = 0
  M_NFSNATN = "5.102"
  M_NFSDSC  = 0
  M_NFSDSS  = 0
  M_DSCNFS  = 0
  M_NFSVEN  = 1
  M_NFSCPG  = 151
  M_NFSTRA  = 1
  M_NFSFRC  = "1"
  M_NFSPOR  = 1
  M_NFSAPL  = 0
  M_NFSHIS  = "N"
  M_NFSCPL  = "N"
  M_NFSSIT  = space(11)
  M_NFSCOM  = 0
  M_NFSVOL  = "N"
  M_NFSCAN  = " "
  M_NFSNEB  = space(06)
  M_NFSESP = space(15)
  M_NFSMAR = space(10)
  M_NFSIND = 0
  M_NFS800 = "N"
  M_NFSPLQ = 0
  M_NFSPRB = 0
  M_NFSITE = 0
  M_NFSVLM = 0
  M_NFSVLS = 0
  M_NFSBIC = 0
  M_NFSBIF = 0
  M_NFSVIC = 0
  M_NFSVIP = 0
  M_NFSFRE = 0
  M_NFSSEG = 0
  M_NFSDSP = 0
  M_NFSVLN = 0
  M_NFSSUB = 0
  M_NFSAGR = " "
  M_FISINT = " " 
  M_NFSREF = space(44)
  M_NFSCHAV = space(44) // chave nota complementar

  R        = 0
  M_ALT    = 1
  M_APC    = 1
  lSosub = .t.  // so substituicao sim ou nao
  lSoser = .f.
 
  M_NFSDEV = 0
  M_NFSSDE  = AEMP00->EMPSER
  M_NFSTDC = "   "
  M_NFSDOC = 0
  M_NFSDSE = "  "

  M_NFSVLD  = 0
  M_NFSTRI  = 0
  M_NFSISE  = 0
  M_NFSRED  = 0
  M_NFSOUT  = 0

  M_DUPDP1 = 0
  M_DUPDP2 = 0
  M_DUPDP3 = 0
  M_DUPDP4 = 0 
  M_DUPDP5 = 0
  M_DUPDP6 = 0
 
  M_DUPVC1 = ctod("  /  /  ")
  M_DUPVC2 = ctod("  /  /  ")
  M_DUPVC3 = ctod("  /  /  ")
  M_DUPVC4 = ctod("  /  /  ")
  M_DUPVC5 = ctod("  /  /  ")
  M_DUPVC6 = ctod("  /  /  ") 

  M_CPL[1] = "                                        "
  M_CPL[2] = "                                        "
  M_CPL[3] = "                                        "
  M_CPL[4] = "                                        "
  M_CPL[5] = "                                        "
  M_CPL[6] = "                                        "

  M_CLINOM   = space(40)
  M_CLIEND1  = space(40)
  M_CLIEND2  = space(40)
  M_CLIEND3  = space(40)
  M_CLINRO2  = space(5)
  M_CLIUF2   = AEMP00->EMPEST
  M_CLIBAI1  = space(15)
  M_CLIBAI2  = space(15)
  M_CLIBAI3  = space(15)
  M_CLICEP1  = AEMP00->EMPCEP
  M_CLICCL1  = AEMP00->EMPCCE
  M_CLICEP2  = AEMP00->EMPCEP
  M_CLICCL2  = AEMP00->EMPCCE
  M_CLICEP3  = AEMP00->EMPCEP
  M_CLICCL3  = AEMP00->EMPCCE
  M_CLIMUN1  = pad(AEMP00->EMPMUN, 20)
  M_CLIMUN2  = pad(AEMP00->EMPMUN, 20)
  M_CLIMUN3  = pad(AEMP00->EMPMUN, 20)
  M_CLIIES2  =  pad("N/C",17)
  M_CLIIBGE  = 0
  M_CLICGC2  = space(15)
  M_CLITEL3  = space(15)
  M_CLIDCC   = 1


  ednfs01()     

  if lastkey() = 27
    exit
  endif

  lEmiteboleto = .f.

  if M_NFSPOR = 3
    do while .t.
      M_ESCOLHA = msgbox3("Emite boleto",,,"Escolha","Sim","Nao")
      if M_ESCOLHA = 2
        lEmiteboleto = .t.
        exit
      endif
      if M_ESCOLHA = 3
        exit
      endif
    enddo
  endif

  if lNFSSER
    M_NFSNUM = 0
    SetColor(_COREDICAO_)
    @ 04, 15 get  M_NFSNUM picture "######"  valid M_NFSNUM > 0
    read
    M_NFSSER = "E "  // servico
  endif

  L      = 11
  LNPRO  = 0
  LNMEM  = 0
  LNSER  = 0
  M_IND  = 0
  M_TXT  = 0

  for R = 1 to 26
    M_MSG[R] = 0
  next 

  M_LIMITE = 13
  lJachamou = .f.

  if TIPO == "PEDIDO"  // estou emitindo do pedido que esta sendo selecionado
    if !chama_sel()                       && chama pedido
      msg("* * * NADA A FATURAR NO OR€AMENTO * * *")
      loop
    endif
    lJachamou = .t.
  endif

  if M_NFSTDC = "ORC"
    if !chama_ped()                       && chama pedido
      msg("* * * NADA A FATURAR NO OR€AMENTO * * *")
      loop
    endif
    lJachamou = .t.
  endif

  if M_NFSTDC = "REQ"
    if !chama_req()
      msg("* * * REQUISICAO NAO ENCONTRADA * * *")
      loop
    endif
    lJachamou = .t.
  endif

  if M_NFSTDC = "PRE"
    if !chama_pre()
      msg("* * * PRE-VENDA NAO ENCONTRADA * * *")
      loop
    endif
    lJachamou = .t.
  endif

  M_R = 0

  if !lJachamou
  
    R = 1        // sequencia
    L = 17       // linha inicial

    do while .t. 

*                    1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16                     17       18  19    20      21   22  23   24     25
*                  SEQ PSQ MAT QDE PRB VLI LIQ BIC VIC ISE OUT DSP VIP COM ISI OUI                    OBS      NAT CAS DESCRICAO TIPO SUB  lote vcte  PIC
      aadd(M_NFSMAT,{0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, "                   ",space(5)  ,0,space(40)," ",0,space(10),ctod("  /  /  "),0})

      M_NFSMAT[R,1 ] = R
      M_NFSMAT[R,18] = M_NFSNATN
      M_R = R

      ednfs04(L,R)

      if lastkey() = 27
        adel(M_NFSMAT,R)
        asize(M_NFSMAT,len(M_NFSMAT) - 1)
        exit
      endif

      valorespro(M_NFSMAT[R,3])

      LNPRO ++

      if L = 25
        lpnfs01()
        L = 17
      endif

      R ++
      L ++

    enddo

    if len(M_NFSMAT) = 0
      msg("* * * NOTA FISCAL NAO POSSUI ITENS * * *")
      loop
    endif
  endif

// --- SUBSTUTA O ANTIGO BLOCO DO ACHOICE POR ESTE LAÇO ---
  M_LINPOS   := 0
  nPosach    := 1
  lSaiEdicao := .f.
  lConsulta  := .f.

  do while .t.
    editaitensNfs("I") // "I" para Inclusão, "A" para Alteração, "C" para Consulta

    if lSaiEdicao
      exit
    endif
  enddo

  if len(M_NFSMAT) = 0
    loop
  endif
  // --------------------------------------------------------

  if len(M_NFSMAT) = 0
    loop
  endif


  msnfs01(.t.)                        && calcula bases

  if lastkey() = 27
    loop
  endif 
  
  emissao(TIPO)

  msg("* * * FIM DE EMISSAO * * *")

  exit

enddo

restscreen(0,0,maxrow(),maxcol(),LTALA20)

* wvw_lCloseWindow()

//vlrestscreen(02, 04, 25, 79,M_TELA1)

return ""

***********************
function LERLANCAMENTOS(sototal)
***********************

local nTOTALNFS := 0

if !sototal
  seexistesql("EDICOES")
  cSQL := "SELECT first 0 * from EDICOES"
  dbusearea(.t.,"SQLMIX",cSQL,"EDICOES")
endif

  for ABC = 1 to len(M_NFSMAT)
    if !sototal
     valorespro(M_NFSMAT[ABC, 3])
      select EDICOES
      append blank
      replace NFSSEQ with ABC
      replace NFSMAT with M_NFSMAT[ABC, 3]
      replace NFSQDE with M_NFSMAT[ABC, 4]
      replace NFSPRB with M_NFSMAT[ABC, 5]
      replace NFSVLI with M_NFSMAT[ABC, 6]
      replace PCADES with pad(APCA00->PCADES,30)
    endif
    
    nTOTALNFS += M_NFSMAT[ABC, 6]
  next

  setcolor("W+/B")
  @ 08, 61 say nTOTALNFS picture "@R 999,999,999.99"
  setcolor()

//*******************
function editaitensNfs(fAcao)
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

  lpnfs01()

  M_TELA1 = savescreen(06, 20, 18, 60)

  lerlancamentos(.f.)
  
  if fAcao $ "IA"

    wvw_pbSetFont( ,'Visuallib', _FONTET_ -1 , _FONTEL_ -1 , 0, 200)
    nbt1 := wvw_pbCreate( 0, 29, 5, 29, 12, "1.Total", NIL, {|| VLKeyboard( CHR( 49 )) } )
    nbt2 := wvw_pbCreate( 0, 29, 14, 29, 25, "2.Cabecario", NIL, {|| VLKeyboard( CHR( 50 )) } )
    nbt3 := wvw_pbCreate( 0, 29, 27, 29, 35, "3.Apagar", NIL, {|| VLKeyboard( CHR( 51 )) } )
    nbt4 := wvw_pbCreate( 0, 29, 37, 29, 47, "4.Adiciona", NIL, {|| VLKeyboard( CHR( 52 )) } )
    nbt5 := wvw_pbCreate( 0, 29, 49, 29, 59, "5.Desconto", NIL, {|| VLKeyboard( CHR( 53 )) } )
    nbt6 := wvw_pbCreate( 0, 29, 61, 29, 70, "6.Emissao", NIL, {|| VLKeyboard( CHR( 54 )) } )

                    
*    cOpcoes  := {"1.Total","2.Cabecario","3.Apagar","4.Adiciona","5.Desconto","6.Emissao"}
*    cOpcoesf := {K_SH_F3, K_SH_F4, K_SH_F5, K_SH_F6, K_SH_F7,K_SH_F8}
*    aPosicoes := { }

*    LinButton( LB_SHOW,,29,,,cOpcoes,,,,,,,,,3)

 *   for I := 1 to len(cOpcoes)
*      SetKeyMouse(cOpcoesf[I], { aPosicoes[I][1],  aPosicoes[I][2],  aPosicoes[I][3],  aPosicoes[I][4] } )

 *     do case
 *       case I = 1 ; SETKEY( cOpcoesf[I], { || nButton := 1, VLKeyboard( CHR( 49 ) + CHR( K_ENTER) ) } )
 *       case I = 2 ; SETKEY( cOpcoesf[I], { || nButton := 2, VLKeyboard( CHR( 50 ) + CHR( K_ENTER) ) } )
 *       case I = 3 ; SETKEY( cOpcoesf[I], { || nButton := 3, VLKeyboard( CHR( 51 ) + CHR( K_ENTER) ) } )
 *       case I = 4 ; SETKEY( cOpcoesf[I], { || nButton := 4, VLKeyboard( CHR( 52 ) + CHR( K_ENTER) ) } )
 *       case I = 5 ; SETKEY( cOpcoesf[I], { || nButton := 5, VLKeyboard( CHR( 53 ) + CHR( K_ENTER) ) } )
 *       case I = 6 ; SETKEY( cOpcoesf[I], { || nButton := 6, VLKeyboard( CHR( 54 ) + CHR( K_ENTER) ) } )
 *     endcase
 *   next

  endif

  select EDICOES
  go top

  // Inicializa o TBrowseDB na área física correta (Linhas 17 a 25)
  cColor  := SetColor( 'N/W*,W/N+,W/R,W/G,N/W*,GR+/BG,R/W,G/W' )
  oBrowse := TBrowseDB(17, 5, 25, 78 )

*@ LN, 08 get     M_NFSMAT[SQ, 3] picture "######"  F2 color _CORF2_ valid vernfs6() funcao "sele_arquivo('APCA00')" retorno @M_NFSMAT[SQ, 3]
*@ LN, 15 get     M_NFSMAT[SQ, 4] picture "########"   valid vernfs7()
*@ LN, 58 get     M_NFSMAT[SQ, 5] picture "#######.##" valid vernfs8()


  // Colunas perfeitamente alinhadas com o cabeçalho SAY da linha 15
  oBrowse:addColumn(TBColumnNew("",&("{||TRAN(NFSSEQ,[@R 99])}")))
  oBrowse:addColumn(TBColumnNew("",&("{||TRAN(NFSMAT,[@R 999999])}")))
  oBrowse:addColumn(TBColumnNew("",&("{||TRAN(NFSQDE,[@R 99999999])}")))
  oBrowse:addColumn(TBColumnNew("",&("{||pad(PCADES,33)}")))
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
    @ 27, 10 say PCADES // Mostra descrição longa na linha de status inferior

    SetColor( 'N/W*,W/N+,W/R,W/G,N/W*,GR+/BG,R/W,G/W' )
    oBrowse:RefreshAll()
    oBrowse:Stabilize()
    oBrowse:colPos := 1
    oBrowse:ColorRect( { oBrowse:RowPos, oBrowse:ColPos, oBrowse:RowPos, oBrowse:RightVisible },{2,5} )

    nKeyMouse := waitstate()

    select EDICOES
    
    if nKeyMouse:wsKey = 49 // .or. nKeyMouse:wsKey = K_F3 // 1
        AlteraRestauraTela("TLNFS01",.f.)
        wvw_pbenable(0,nbt1,.f.)
        totitenfs()
        wvw_pbenable(0,nbt1,.t.)
        AlteraRestauraTela("TLNFS01",.T.)
        select EDICOES
        loop
    ENDIF

    if nKeyMouse:wsKey = 50 // 2
        wvw_pbenable(0,nbt2,.f.)
        ednfs01()
        wvw_pbenable(0,nbt2,.t.)
        select EDICOES
        loop
    ENDIF

    if nKeyMouse:wsKey = 51 // 3 apagar
        AlteraRestauraTela("TLNFS01",.f.)
        wvw_pbenable(0,nbt3,.f.)
        delitenfs()
        lerlancamentos(.f.)
        wvw_pbenable(0,nbt3,.t.)
        AlteraRestauraTela("TLNFS01",.t.)

        select EDICOES
        go top

        oBrowse:RefreshAll()
        oBrowse:RefreshCurrent()
        oBrowse:Stabilize()
    ENDIF

    if nKeyMouse:wsKey = 52 // 4 adiciona
        wvw_pbenable(0,nbt4,.f.)
        additenfs()
        lerlancamentos(.f.)
        wvw_pbenable(0,nbt4,.t.)

        select EDICOES
        go top

        oBrowse:RefreshAll()
        oBrowse:RefreshCurrent()
        oBrowse:Stabilize()
    ENDIF


    if nKeyMouse:wsKey = 53 // 5
        wvw_pbenable(0,nbt5,.f.)
        dscitenfs()
        wvw_pbenable(0,nbt5,.t.)

        select EDICOES
        loop
    ENDIF



    do case
      case (nKeyMouse:wsKey == 27)  .or.  (nKeyMouse:wsKey = 54) // 6

        lBrowse := .F.
        lSaiEdicao := .t.

      case strzero(nKeyMouse:wsKey, 3) $ "007#097#065#" // F5 - Apagar Item
*        if !fAcao == "C"
*          lBrowse := .f.
*        endif

      case strzero(nKeyMouse:wsKey, 3) $ "073#105#" // F6 - Adicionar Item
 *       if !fAcao == "C"

 *         lBrowse := .f.
 *       endif

      case strzero(nKeyMouse:wsKey, 3) $ "069#101#" // F7 - Confirmar / Emissão
  *      lBrowse := .f.
  *      lSaiEdicao := .t.
  *      return 0

      case (nKeyMouse:wsKey == K_ENTER) // ENTER - Altera o item sob o cursor
        if !fAcao == "C"
          altitenfs()
          lerlancamentos(.f.)
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


    /*
    if mLeftDown()
      if nKeyMouse[2] == 29 + nLinped
        do case
          case (nKeyMouse[3] >= 05+nColped .and. nKeyMouse[3] <= 15+nColped) // Total/Desconto
            if !fAcao == "C"
              dscitenfs()
              lBrowse := .f.
            endif
          case (nKeyMouse[3] >= 17+nColped .and. nKeyMouse[3] <= 31+nColped) // Cabeçalho
            if !fAcao == "C"
              ednfs01()
            endif
          case (nKeyMouse[3] >= 33+nColped .and. nKeyMouse[3] <= 43+nColped) // Apagar
            if !fAcao == "C"
              delitenfs()
              lBrowse := .f.
            endif
          case (nKeyMouse[3] >= 45+nColped .and. nKeyMouse[3] <= 57+nColped) // Adiciona
            if !fAcao == "C"
              additenfs()
              lBrowse := .f.
            endif
          case (nKeyMouse[3] >= 59+nColped .and. nKeyMouse[3] <= 69+nColped) // Emissão/Sair
            lBrowse := .f.
            lSaiEdicao := .t.
            return 0
        endcase
      endif
    endif
    */
    
    select EDICOES
    oBrowse:RefreshCurrent()
    oBrowse:Stabilize()

  enddo



  // Desativa os gatilhos de teclas e cliques do mouse ao sair do grid

  wvw_pbdestroy(0,nbt1)
  wvw_pbdestroy(0,nbt2)
  wvw_pbdestroy(0,nbt3)
  wvw_pbdestroy(0,nbt4)
  wvw_pbdestroy(0,nbt5)
  wvw_pbdestroy(0,nbt6)

return ""

****************
function VERNFS17
****************

private M_TELALOT

M_TELALOT = savescreen(20, 20, 28, 69)

save get to M_GET999

nbox(21, 20, 24, 44,"W/W+",.t.)
setcolor("B/W")

@ 22, 21 say      "Lote     :             "
@ 23, 21 say      "Validade :             "

SetColor(_COREDICAO_)
@ 22, 32 get M_NFSMAT[SQ,23] picture "@!"
@ 23, 32 get M_NFSMAT[SQ,24]
read
setcolor("")

restore get from M_GET999

restscreen(20, 20, 28, 69, M_TELALOT)

return ""

******************
function CHAMA_SEL
******************

private AXS,lPos,ZMX

R = 0

for AXS = 1 to len(M_PEDMAT)

  if !M_PEDMAT[AXS][15] == "*"
    loop
  endif

  valorespro(M_PEDMAT[AXS][2])

  lPos = 0

  for ZMX = 1 to len(M_NFSMAT)
    if M_NFSMAT[ZMX][3]=M_PEDMAT[AXS][2]  // encontrei
      lPos = ZMX
    endif
  next

  if lPos = 0
    aadd(M_NFSMAT,{0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, "                   ",space(5)  ,0,space(40)," ",0,space(10),ctod("  /  /  "),0})
    lPos = len(M_NFSMAT)
    R++
  endif

  M_NFSMAT[lPos][1 ]=R
  M_NFSMAT[lPos][3 ]=M_PEDMAT[AXS][2]
  M_NFSMAT[lPos][4 ]+=M_PEDMAT[AXS][3]
  M_NFSMAT[lPos][5 ]=round(M_PEDMAT[AXS][5]/M_PEDMAT[AXS][3],2)
  M_NFSMAT[lPos][6 ]=M_NFSMAT[lPos][5]*M_NFSMAT[lPos][4]
  M_NFSMAT[lPos][20]=zPCADES

  num_mens()

next
   
return .t.

******************
function ALTITENFS  && altera item da nota
******************

  ednfs04(17 + M_LINPOS,M_OPC)

  if M_ALT = 2
     ednfs03(M_OPC)
  endif

  M_LINPOS = 0

return ""

******************
function DELITENFS && deleta item da nota
******************

private M_NFS, R


M_NFS = decide("Confirma Exclusao deste Item")

if M_NFS != 1
  return ""
endif

adel(M_NFSMAT,M_OPC)
asize(M_NFSMAT,len(M_NFSMAT) - 1)

lpnfs01()

M_LINPOS = 0

return ""

******************
function ADDITENFS && insere item na nota
******************


  R = len(M_NFSMAT) + 1
  M_R = R
  L = 16

  for S = 1 to len(M_NFSMAT)
    if L = 25
      lpnfs01()
      L = 17
    endif
    L ++
  next

  do while .t.

    aadd(M_NFSMAT,{0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, "                   ",space(5)  ,0,space(40)," ",0,space(10),ctod("  /  /  "),0})
    M_NFSMAT[R, 1] = R                 && SEQ
    M_NFSMAT[R,18] = M_NFSNATN

    ednfs04(L,R)
    M_R = R

    if lastkey() = 27 
      adel(M_NFSMAT,R)
      asize(M_NFSMAT,len(M_NFSMAT) - 1)
      exit
    endif

    valorespro(M_NFSMAT[R,3])

*    if "#" + alltrim(str(zPCAFOR,5)) + "#" $ M_ABBOTT // ABBOTT
*      if M_NFSIND = 0
*        alert("INFORME QUEM INDICOU")
*     SetColor(_COREDICAO_)
*        @ 06, 15 get     M_NFSIND picture "999"  valid VERIND()
*        @ 06, 47 get     M_NFS800 picture "@!" valid M_NFS800 $ "SN"
*        read
*      endif
*    endif


    if L = 25
      lpnfs01()
      L = 16
    endif

    R ++
    L ++

  enddo

  if len(M_NFSMAT) = 0
    msg("* * * NOTA DE ENTRADA NAO INCLUIDA * * *")
    return ""
  endif

return ""

******************
function DSCITENFS  && desconto na nota
******************

*  if !c_senha()
*    return ""
*  endif

*/*/*/
  SetColor(_COREDICAO_)
  @ 05, 61 get     M_DSCNFS picture "@R 999,999,999.99"
  @ 06, 61 get     M_NFSDSC picture "##.##"   valid vernfs4()
  read

return ""

******************
function TOTITENFS                     && mostra dados e calcula nota fiscal
******************
  LOCAL M_TELAP := savescreen(07, 20, 16, 62)

    store 11 to L

    M_TOTPRO = 0
    M_TOTIPI = 0
    M_TOTDSC = 0

    for S = 1 to len(M_NFSMAT)
      valorespro(M_NFSMAT[S,3])
      M_TOTPRO = M_TOTPRO + M_NFSMAT[S,6]
      M_TOTIPI = M_TOTIPI + ((M_NFSMAT[S,6] * .01) * iif(AFIS00->FISIPI="S",zPCAIPI,0))
      if M_NFSDSC > 0
        M_TOTDSC = M_TOTDSC + (M_NFSMAT[S, 6] - round(M_NFSMAT[S,6]  - ((M_NFSMAT[S,6] /100) * M_NFSDSC), 2))
      endif
    next && r

   nbox(07, 20, 13, 59,"W/W+",.t.)
   setcolor("B/W")
      @ 08, 21 say  "Total dos Produtos:                   "
      @ 09, 21 say  "Total do Ipi      :                   "
      @ 10, 21 say  "Total das Despesas:                   "
      @ 11, 21 say  "Total dos Desconto:                   "
      @ 12, 21 say  "Valor da Nota     :                   "
    setcolor("N/W*")
      @ 08, 41 say M_TOTPRO                                  picture "@E ###,###,###,###.##"
      @ 09, 41 say M_TOTIPI                                  picture "@E ###,###,###,###.##"
      @ 10, 41 say M_NFSFRE+M_NFSSEG+M_NFSDSP                picture "@E ###,###,###,###.##"
      @ 11, 41 say iif(M_DSCNFS > 0,M_DSCNFS,M_TOTDSC)       picture "@E ###,###,###,###.##"
      @ 12, 41 say ((M_TOTPRO+M_NFSFRE+M_NFSSEG+M_TOTIPI) - (M_DSCNFS+M_TOTDSC)) picture "@E ###,###,###,###.##"
    set color to

    M_TECLA = inkey(0)

    restscreen(07, 20, 16, 62, M_TELAP)

return ""

***************
function ALTNFS
***************
parameters M_ALT,M_OPC1,M_OPC2


rodape("ALTERA", "NFS", M_FAN, "EAGRO21", "Mem: " + str(memory(0), 5), M_EMP)

*        @ 10, 25 prompt "Normal   " HIGHLITE R/BG
*        @ 11, 25 prompt "Escritura" HIGHLITE R/BG
*        @ 12, 25 prompt "Natureza " HIGHLITE R/BG
*        @ 13, 25 prompt "Relatorio" HIGHLITE R/BG message "IMPRIME ESTA NOTA NOS RELATORIOS (SIM/NAO)" AT 24, 00 CENTER

do case
   case M_ALT = 1 ; nfsalt()
   case M_ALT = 2 ; nfsalt()
   case M_ALT = 3 ; nfsalt()
   case M_ALT = 4 ; nfsalt2("RELATORIO")
   case M_ALT = 5 ; nfsalt2("NESTLE")

endcase

return ""

***************
function NFSALT2(cTIPOALT)
***************

private M_TELA ,;
        M_ALT ,;
        M_OPC

private  M_NFSEMP ,;  
         M_NFSCLI ,;
         M_NFSDTE 

    do while .t.

      rodape("ALTERA", "NFS", M_FAN, "EAGRO21","Mem: " + str(memory(0), 5), M_EMP)

      tlnfs01()
      AlteraRestauraTela("TLNFS01",.t.)
  
         M_NFSEMP  = ME_EMP
         M_NFSNUM  = 0
         M_NFSSER  = AEMP00->EMPSER

         SetColor(_COREDICAO_)
         @ 04, 15 get M_NFSNUM picture "######"
         @ 04, 22 get M_NFSSER picture "@!"
         read

         if M_NFSNUM = 0
           exit
         endif

         if !BUSCAREGISTRO("ANFS00",1,{str(M_NFSEMP, 2, 0),str(M_NFSNUM, 6, 0),aspas(M_NFSSER)},"SELECT")
           msg("* * * NOTA NAO INCLUIDA * * *")
           loop
         endif



         msnfs03()
         msnfs04()

      select ANFS00

      M_ESTNOT = " "

      do case
         case cTIPOALT == "RELATORIO"
            @ 24, 00 say "Esta nota sera impressa nos relatorios S/N: "
            SetColor(_COREDICAO_)
            @ 24, col() get M_ESTNOT picture "@!" valid M_ESTNOT $ "SN"
            read
         case cTIPOALT == "NESTLE"
            M_NFSNESCLI = 0
            setcolor("B/W")
            @ 23, 07 say "Informe o Cliente que receber  os Produtos: "
            SetColor(_COREDICAO_)
            @ 23, col() get M_NFSNESCLI picture "9999999" F2 color _CORF2_ valid verclinestle() funcao "sele_arquivo('ACLI00')" retorno @M_NFSNESCLI
            read
      endcase

      if lastkey() = 27
        msg("* * * NOTA NAO ALTERADA * * *")
        exit
      endif


  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"ANFS00","UPDATE"}
  aadd(sqlCHAVE,{"NFSEMP",str(M_NFSEMP,2)})
  aadd(sqlCHAVE,{"NFSNUM",str(M_NFSNUM,6)})
  aadd(sqlCHAVE,{"NFSSER",aspas(M_NFSSER)})
  do case
    case cTIPOALT == "RELATORIO"
      aadd(sqlCAMPO,{"NFSLIS",M_ESTNOT,.t.})
    case cTIPOALT == "NESTLE"
      aadd(sqlCAMPO,{"NFSNESCLI",str(M_NFSNESCLI,7),.t.})
  endcase
  executasql()
  msg("* * * NOTA ALTERADA * * *")

  exit
    
enddo


return ""

***************
function NFSALT
***************

private M_FLAG ,;
        L      ,;
        R      ,;
        M_TELA ,;
        M_TELA1,;
        M_CPL[6]

    declare M_CPL[6]
    declare M_HIS[6]

    do while .t.

      M_NFSMAT = {}

      rodape("ALTERA", "NFS", M_FAN, "EAGRO21", "Mem: " + str(memory(0), 5), M_EMP)

      tlnfs01()
      AlteraRestauraTela("TLNFS01",.t.)
  
         M_NFSEMP  = ME_EMP
         M_NFSNUM  = 0
         M_NFSSER  = AEMP00->EMPSER

     SetColor(_COREDICAO_)
         @ 04, 15 get M_NFSNUM picture "######"
         @ 04, 22 get M_NFSSER picture "@!"
         read

         if M_NFSNUM = 0
           exit
         endif

          if !BUSCAREGISTRO("ANFS00",1,{str(M_NFSEMP, 2, 0),str(M_NFSNUM, 6, 0),aspas(M_NFSSER)},"SELECT")
            msg("* * * NOTA NAO INCLUIDA * * *")
            loop
          endif

         msnfs03()
         msnfs04()

         select ANFS00 

         if !rlock() 
           msg("* * * (ANFS00) REGISTRO SENDO USADO * * *")
           loop
         endif

         M_NFSDTE  = NFSDTE
         M_NFSCLI  = NFSCLI
         M_NFSNAT  = NFSNAT
         M_NFSNATN = NFSNATN
         M_NFSAPL  = NFSAPL
         M_NFSDSC  = NFSDSC
         M_NFSAGR  = " "
         M_NFSTDC  = NFSTDC
         M_NFSDOC  = NFSDOC
         M_NFSDSE  = NFSDSE
         M_FISINT  = " " 
         M_NFSNEB = NFSNEB
         M_NFSESP = NFSESP
         M_NFSMAR = NFSMAR
         M_NFSPLQ = NFSPLQ
         M_NFSPRB = NFSPRB
         M_NFSITE = NFSITE
         M_NFSIND = NFSIND
         M_NFS800 = substr(NFSMEM,21,1)
         M_NFSDEV = 0
         M_NFSSDE  = AEMP00->EMPSER
         M_NFSSUB = 0
         M_DSCNFS  = NFSVLD
         M_NFSDSS  = NFSDSS 
         M_NFSVEN  = NFSVEN
         M_NFSCOM  = NFSCOM
         M_NFSCPG  = NFSCPG
         M_NFSCPL  = NFSCPL
         M_NFSSIT  = NFSSIT
         M_NFSVLM  = NFSVLM
         M_NFSVLS  = NFSVLS
         M_NFSBIC  = NFSBIC
         M_NFSBIF  = NFSBIF
         M_NFSVIP  = NFSVIP
         M_NFSVIC  = NFSVIC
         M_NFSFRE  = NFSFRE
         M_NFSFRC  = NFSFRC
         M_NFSSEG  = NFSSEG
         M_NFSDSP  = NFSDSP
         M_NFSDTS  = NFSDTS
         M_NFSHOR  = NFSHOR
         M_NFSTRA  = NFSTRA
         M_NFSFRC  = NFSFRC
         M_NFSPOR  = NFSPOR
         M_CLIUF2  = space(02)
         M_CLICGC2 = space(15)
         M_CLIDCC  = 1
         M_NFSVOL  = NFSVOL
         M_NFSCAN  = NFSCAN
         M_NFSHIS  = "N"
         M_NFSVLN  = 0
         M_TOTNFS  = 0
         M_NFSVLD  = 0
         M_NFSTRI  = 0
         M_NFSISE  = 0
         M_NFSRED  = 0
         M_NFSOUT  = 0
         M_NFSTRA  = NFSTRA
         M_NFSFRC  = NFSFRC
         M_NFSPOR  = NFSPOR
         M_LIMITE  = 13
         M_CPL[1]  = NFSCPL1
         M_CPL[2]  = NFSCPL2
         M_CPL[3]  = NFSCPL3
         M_CPL[4]  = NFSCPL4
         M_CPL[5]  = NFSCPL5
         M_CPL[6]  = NFSCPL6

         M_HIS[1] = NFSHS1
         M_HIS[2] = NFSHS2
         M_HIS[3] = NFSHS3
         M_HIS[4] = NFSHS4
         M_HIS[5] = NFSHS5
         M_HIS[6] = NFSHS6

         M_CLINOM   = space(40)
         M_CLIEND2  = space(40)
         M_CLINRO2  = space(5)
         M_CLIUF2   = "SP"
         M_CLIBAI2  = space(15)
         M_CLICEP2  = 19100
         M_CLICCL2  = 0
         M_CLIMUN2  = "P PRUDENTE          "
         M_CLIIES2  = "N/C              "
         M_CLIIBGE = 0
         M_CLICGC2  = space(15)
         M_CLITEL3  = space(15)

         M_APC    = 2

         ednfs02()     

         if lastkey() = 27
           msg("* * * NOTA NAO ALTERADA * * *")
           loop
         endif

         BUSCAREGISTRO("ANFS01",1,{str(M_NFSEMP, 2, 0),str(M_NFSNUM, 6, 0),aspas(M_NFSSER)},"SELECT")

       do while !eof()

         aadd(M_NFSMAT,{0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, "                   ",space(5)  ,0,space(40)," ",0,space(10),ctod("  /  /  "),0})

         valorespro(NFSMAT)
 
         M_NFSMAT[NFSSEQ,  1] = NFSSEQ
         M_NFSMAT[NFSSEQ,  2] = NFSPSQ
         M_NFSMAT[NFSSEQ,  3] = NFSMAT
         M_NFSMAT[NFSSEQ,  4] = NFSQDE
         M_NFSMAT[NFSSEQ,  5] = NFSPRB
         M_NFSMAT[NFSSEQ,  6] = NFSVLI
         M_NFSMAT[NFSSEQ,  7] = NFSLIQ
         M_NFSMAT[NFSSEQ,  8] = NFSBIC
         M_NFSMAT[NFSSEQ,  9] = NFSVIC
         M_NFSMAT[NFSSEQ, 10] = NFSISE
         M_NFSMAT[NFSSEQ, 11] = NFSOUT
         M_NFSMAT[NFSSEQ, 12] = NFSDSP
         M_NFSMAT[NFSSEQ, 13] = NFSVIP
         M_NFSMAT[NFSSEQ, 14] = NFSCOM
         M_NFSMAT[NFSSEQ, 15] = NFSISI
         M_NFSMAT[NFSSEQ, 16] = NFSOUI
         M_NFSMAT[NFSSEQ, 17] = NFSOBS
         M_NFSMAT[NFSSEQ, 20] = zPCADES
         if M_ALT = 1
           M_NFSMAT[NFSSEQ, 18] = ANFS00->NFSNATN
         else
           M_NFSMAT[NFSSEQ, 18] = NFSNATN
         endif

         skip

       enddo

     M_TELA1 = savescreen(06, 20, 18, 60)

     lpnfs01()

     M_TELA1 = savescreen(06, 20, 18, 60)

     declare M_VETORITE[len(M_NFSMAT)]

     for R = 1 to len(M_NFSMAT)
       M_VETORITE[R] = str(M_NFSMAT[R, 1], 2, 0) + " " + ;
                       str(M_NFSMAT[R, 3], 6, 0) + " " + ;
                       str(M_NFSMAT[R, 4], 8, 0) + " " + ;
                       pad(M_NFSMAT[R,20],30)    + " " + ;
                       str(M_NFSMAT[R, 5], 10, 2)+ " " + ;
                       str(M_NFSMAT[R, 6], 10, 2)
     next

     M_LINPOS = 0

  do while .t.

    if len(M_NFSMAT) = 0
      exit
    endif

    valorespro(val(substr(M_VETORITE[1], 4, 6)))

    set color to GR+
      @ 21, 10 say "       1.Total  2.Cabecario 3.Deleta  4.Adiciona  5.Insere  6.Sair"
    set color to R+
      @ 21, 21-4 say "1"
      @ 21, 30-4 say "2"
      @ 21, 42-4 say "3"
      @ 21, 52-4 say "4"
      @ 21, 64-4 say "5"
      @ 21, 74-4 say "6"
    set color to N/W,W+/N
      M_OPC = achoice(11, 5,19,75,M_VETORITE,,"mosnfs")
    set color to 

    if lastkey() = 13
      altitenfs() && altera item
      loop
    endif

    if lastkey() = 49
      totitenfs() && total   
      loop
    endif

    if lastkey() = 50
      ednfs01() && desconto
      loop
    endif

    if lastkey() = 51
      delitenfs() && deleta item 
      loop
    endif

    if lastkey() = 52
      additenfs() && adiciona itens 
      loop
    endif

    if lastkey() = 53
*      insitenfs() && insere item
      loop
    endif

    if lastkey() = 54
     if !calc_dsc()
*       msg("* * * DESCONTO MAIOR QUE O PERMITIDO * * *")
*       if !c_senha()
*         loop
*       endif
     endif
     exit        && abandona operacao
    endif

  enddo

  if len(M_NFSMAT) = 0
    loop
  endif

  if M_ALT = 1
    msnfs01(.f.)                        && calcula bases
  endif

     msw("* * * GRAVANDO NOTA FISCAL * * *")
 
     grnfs00("UPDATE")                        && regrava nota mestre

     grnfs01("UPDATE")                        && regrava nota itens

     restscreen(06, 20, 18, 60, M_TELA1)

  enddo


return ""

*****************
function NUM_MENS                      && numero de mensagens
*****************

  if M_CLIUF2 = "SP"
    M_IND = rat(zPCACSP,"ABCDEFGHIJKLMNOPQRSTUVWXYZ")
  else
    M_IND = rat(zPCACOU,"ABCDEFGHIJKLMNOPQRSTUVWXYZ")
  endif

  if M_IND > 0
    if M_MSG[M_IND] = 0
      M_MSG[M_IND] = 1
      LNPRO ++
    endif
  endif

return ""

****************
function EMISSAO(F_TIPO)                  && emissao de nfs revenda
****************

LOCAL cInf:=""   // Variavel de Resposta das Informacoes Geradas.

private M_CGCNFS,;
        M_LP    ,;
        M_PROC  ,;
        R       ,;
        S       ,;  
        M_IND   ,;
        M_IDF   ,;
        M_EST   ,;
        M_TELA  

private M_MENS[26] ,;
        M_VMEN[26] ,;
        M_FMEN[26]

declare M_MENS[26] ,;
        M_VMEN[26] ,;
        M_FMEN[26]  

declare VAL_EXT[ 1 ] 

do while .t.
  select 0
  use "C:\ATLAS\EMITINDO" exclusive
  if neterr()
    setcolor("")
    msw("A NOTA FISCAL ESTA SENDO EMITIDA POR OUTRA MAQUINA AGUARDE")
    inkey(.1)
    loop
  endif
  exit
enddo
select EMITINDO
if lastrec() = 0
  append blank
endif
go 1


M_NFSSAI = " "

if left(M_NFSNATN,1) > "4"
  M_NFSSAI = "S"
  if !valorescli(M_NFSCLI)
    msg("* * * CLIENTE NAO CADASTRADO * * *")
    return ""
  endif
else
  M_NFSSAI = "E"
  if !BUSCAREGISTRO("AFOR00",1,{str(M_NFSCLI,7,0)},"SELECT")
    msg("* * * FORNECEDOR NAO CADASTRADO * * *")
    return ""
  endif
endif	

BUSCAREGISTRO("ACVE00",0,,"SELECT")

  for R = 1 to 26
    M_MENS[ R] = space(62)
  next

  go top                   

  if zCLIUF2 = "SP"
    M_EST = "SP"
  else
    M_EST = "OU"
  endif

  R = 1

  do while !eof()
    if !CVEEST == M_EST
       exit
    endif
    M_MENS[ R] = CVECOD + "-" + CVENOM
    R++
    skip
  enddo

*
**  carrega ultima nota emitida
*

  M_CGCNFS = right(transform(AEMP00->EMPCGC,"@R 999.999.999/9999-99"),18)

  store 0       to M_LP

if !BUSCAREGISTRO("AFIS00",1,{str(ME_EMP, 2, 0),aspas(M_NFSNATN)},"SELECT")
  msg("* * * NATUREZA NAO CADASTRADA * * *")
  return ""
endif

if !BUSCAREGISTRO("ACPG00",1,{str(M_NFSCPG,3,0)},"SELECT")
  msg("* * * CONDICAO PAGAMENTO NAO CADASTRADA * * *")
  return ""
endif

if !BUSCAREGISTRO("AVEN00",1,{str(M_NFSVEN,3,0)},"SELECT")
  msg("* * * VENDEDOR NAO CADASTRADO * * *")
  return ""
endif


  M_TELA = vlsavescreen(08, 15, 13, 51)

  for R = 1 to 26
    M_VMEN[R] = 0
    M_FMEN[R] = 0
  next

  M_IMPRE = imprenf()

  if M_IMPRE = "N"
    fecha_arq()
    return ""
  endif

  if !lNFSSER 
     M_NFSNUM = AEMP00->EMPNFS + 1  // 317128

     do while .t.
       if BUSCAREGISTRO("ANFS00",1,{str(ME_EMP, 2, 0),str(M_NFSNUM, 9, 0),aspas(M_NFSSER)},"SELECT")
         M_NFSNUM ++
         loop
       endif
       if BUSCAREGISTRO("ANFE00",1,{str(ME_EMP, 2, 0),str(M_NFSNUM, 9, 0),aspas(M_NFSSER)},"SELECT")
         M_NFSNUM ++
         loop
       endif
       exit
     enddo
  endif

  set color to I
    @ 04, 15 say M_NFSNUM picture "######"
    @ 04, 22 say M_NFSSER picture "@!" 
  set color to 


seexistesql("ANFE00")
cSQL := "SELECT first 1 * from ANFE00"
dbusearea(.t.,"SQLMIX",cSQL,"ANFE00")
cria_dbf("NOTAE0")  // CRIA DBF A PARTIR DO ARQUIVO ABERTO COM O NOME INDICADO
use
select 0
use NOTAE0 alias ANFE00 exclusive via "DBFCDX"


seexistesql("ANFE01")
cSQL := "SELECT first 1 * from ANFE01"
dbusearea(.t.,"SQLMIX",cSQL,"ANFE01")
cria_dbf("NOTAE1")  // CRIA DBF A PARTIR DO ARQUIVO ABERTO COM O NOME INDICADO
use
select 0
use NOTAE1 alias ANFE01 exclusive via "DBFCDX"

seexistesql("ANFS00")
cSQL := "SELECT first 1 * from ANFS00"
dbusearea(.t.,"SQLMIX",cSQL,"ANFS00")
cria_dbf("NOTA0")  // CRIA DBF A PARTIR DO ARQUIVO ABERTO COM O NOME INDICADO
use
select 0
use NOTA0 alias ANFS00 exclusive via "DBFCDX"

seexistesql("ANFS01")
cSQL := "SELECT first 1 * from ANFS01"
dbusearea(.t.,"SQLMIX",cSQL,"ANFS01")
cria_dbf("NOTA1")  // CRIA DBF A PARTIR DO ARQUIVO ABERTO COM O NOME INDICADO
use
select 0
use NOTA1 alias ANFS01 exclusive via "DBFCDX"

seexistesql("AKAR00")
cSQL := "SELECT first 1 * from AKAR00"
dbusearea(.t.,"SQLMIX",cSQL,"AKAR00")
cria_dbf("KAR00")  // CRIA DBF A PARTIR DO ARQUIVO ABERTO COM O NOME INDICADO
use
select 0
use KAR00 exclusive ALIAS AKAR00 via "DBFCDX"


select 0
use C:\ATLAS\NFE\ANFS00 alias ANFSAA exclusive  via "DBFCDX"
zap

select 0
use C:\ATLAS\NFE\ANFS01 alias ANFSAB exclusive via "DBFCDX"
zap

select 0
use C:\ATLAS\NFE\ACVE00 alias ACVEAA exclusive via "DBFCDX"
zap

select 0
use C:\ATLAS\NFE\ADCR00 alias ADCRAA exclusive via "DBFCDX"
zap

select 0
use C:\ATLAS\NFE\AHIS00 alias AHISAA exclusive via "DBFCDX"
zap

  if left(M_NFSNATN,1) > "4"
    select ANFS00
    _append("ANFS00")
    lRecnota = recno()
    grava_nfs()
  else
    select ANFE00
    _append("ANFE00")
    lRecnota = recno()
    grava_nfe()
    select ANFS00
    _append("ANFS00")
    grava_nfs()
  endif

aNFSNBM = { }

for R = 1 to len(M_NFSMAT)

  if M_NFSMAT[R][3] = 0
    loop
  endif

  BUSCAREGISTRO("APCA00",1,{str(M_NFSMAT[R,3],6,0)},"SELECT")

  if !empty(PCANCM)
    if len(aNFSNBM) = 0
      aadd(aNFSNBM,PCANCM)
    else
      lAcheinbm = .f.
      for A = 1 to len(aNFSNBM)
        if aNFSNBM[A] == PCANCM
          lAcheinbm = .t.
          exit
        endif
      next
      if !lAcheinbm
        aadd(aNFSNBM,PCANCM)
      endif
    endif
  endif
next

seexistesql("ANFS02")
cSQL := "SELECT first 1 * from ANFS02"
dbusearea(.t.,"SQLMIX",cSQL,"ANFS02")
cria_dbf("ANFS02")  // CRIA DBF A PARTIR DO ARQUIVO ABERTO COM O NOME INDICADO
use
select 0
use ANFS02 exclusive via "DBFCDX"
zap
index on PCADES tag 1 to "INDLOCAL"
set index to "INDLOCAL"

for R = 1 to len(M_NFSMAT)
  if M_NFSMAT[R, 3] = 0
    loop
  endif
  select ANFS02
  append blank
  replace PCADES  with M_NFSMAT[R,20]
  replace POSICAO with R
next

select ANFS02
go top

lay_normal()

msw("* * * GRAVANDO NOTA FISCAL * * *")

cCODCLI = 0

  if left(M_NFSNATN,1) > "4"
    // NOTA FISCAL ELETRONICA

    cCODCLI = ACLI00->CLICOD

    M_EMAIL1 = ""
    M_EMAIL2 = ""
    M_EMAIL3 = ""
    M_EMAIL4 = ""

    if BUSCAREGISTRO("MENSAGE2",1,{str(M_NFSCLI,7,0)},"SELECT")
      M_EMAIL1 = email1
      M_EMAIL2 = email2
      M_EMAIL3 = email3
      M_EMAIL4 = email4
    endif

    select ANFSAA                   && seleciona NFS mestre para gravacao

    _append("ANFSAA")
    replace TIPO   with "S" // nota entrada

    if M_NFSCOMP == "S" // COMPLEMENTO
      replace FINNFE  with "2"         //COMPEMENTO DE ICMS
      replace NFSCHAV with M_NFSCHAV // chave nota complementar
      replace NATOP  with "Complementar"
    else
      replace NATOP  with ACPG00->CPGDES
      replace FINNFE with "" 
     
      if M_NFSDEV > 0 .or. M_NFSCPG = 3 // devolucao
        replace FINNFE with "4"
        replace NFSREF with M_NFSREF
      endif
    endif

    if len(alltrim(M_CLICGC2)) = 15
      replace CNPJ with right(M_CLICGC2,14)
    else
      replace CNPJ with M_CLICGC2
    endif

    replace EMAIL    with ACLI00->CLIEMAIL
    replace EMAIL1   with M_EMAIL1
    replace EMAIL2   with M_EMAIL2
    replace EMAIL3   with M_EMAIL3
    replace EMAIL4   with M_EMAIL4

    replace NOME     with M_CLINOM
    replace CEP      with strzero(M_CLICEP2, 5, 0) + strzero(M_CLICCL2, 3, 0)
    replace ENDERECO with M_CLIEND2
    replace NUMERO   with M_CLINRO2
    replace COMPLE   with ""
    replace BAIRRO   with iif(empty(M_CLIBAI2),".",M_CLIBAI2)
    replace CIDADE   with M_CLIMUN2
    replace ESTADO   with M_CLIUF2
    replace FONE     with M_CLITEL3
    if alltrim(M_CLIIES2) = "ISENTO" .or. substr(M_CLIIES2, 1, 2) = "RG"
      replace IE       with ""
    else
      replace IE       with M_CLIIES2
    endif
    replace CODIBGE  with str(M_CLIIBGE,7)
    replace TRANOM   with M_TRANOM
    replace TRAEND   with M_TRAEND
    replace TRAMUN   with M_TRAMUN
    replace TRAUF    with M_TRAEST
    replace TRAPLC   with M_TRAPLC
    replace QVOL     with M_NFSITE
    replace ESP      with M_NFSESP
    replace MARCA    with M_NFSMAR
    replace PESOL    with M_NFSPLQ
    replace PESOB    with M_NFSPRB
    replace NFSEMP   with M_NFSEMP
    replace NFSNUM   with M_NFSNUM
    replace NFSSER   with M_NFSSER
    replace NFSDTE   with M_NFSDTE
    replace NFSDTS   with M_NFSDTS
    replace NFSCLI   with M_NFSCLI
    replace NFSTRA   with M_NFSTRA
    replace NFSPOR   with M_NFSPOR
    replace NFSCOM   with M_NFSCOM
    replace NFSNEB   with M_NFSNEB

    if M_NFSCOMP == "S" // COMPLEMENTO
      replace NFSVLM   with 0
      replace NFSBIC   with M_NFSBIC
      replace NFSVIC   with M_NFSVIC
      replace NFSPIC   with aliq_icm()
      replace NFSVLN   with 0
    else
      replace NFSVLM   with M_NFSVLM
      replace NFSBIC   with M_NFSBIC
      replace NFSVIC   with M_NFSVIC
      replace NFSPIC   with aliq_icm()
      replace NFSVLN   with M_NFSVLN
    endif

    replace NFSVIP   with M_NFSVIP
    replace NFSDSC   with M_NFSDSC
    replace NFSVEN   with M_NFSVEN
    replace NFSCPG   with M_NFSCPG
    replace NFSFRE   with M_NFSFRE
    replace NFSSEG   with M_NFSSEG

    replace NFSVLD   with M_NFSVLD
    replace NFSTRI   with M_NFSTRI
    replace NFSISE   with M_NFSISE
    replace NFSRED   with M_NFSRED
    replace NFSOUT   with M_NFSOUT
    replace NFSSAI   with M_NFSSAI
    replace NFSTRC   with M_NFSFRC
    replace NFSCNPJ  with M_CLICGC2
    replace NFSIESN  with M_CLIIES2
    replace NFSIPL   with "I"
    replace NFSHOR   with time()
  
    for AB = 1 to 6
      MS = str(AB,1)
      MS1 = strzero(AB,2)
      replace NFSVCT&MS1 with M_DUPVC&MS
      replace NFSDUP&MS1 with M_DUPDP&MS
    next

    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"ACLI00","UPDATE"}
    aadd(sqlCHAVE,{"CLICOD",str(M_NFSCLI,7)})
    aadd(sqlCAMPO,{"CLIULC",formatdta(M_NFSDTE),.t.})
    executasql()

  else
    select ANFSAA                   && seleciona NFS mestre para gravacao
    _append("ANFSAA")
    replace TIPO with "E" // nota entrada
    replace NATOP    with ACPG00->CPGDES

    if len(alltrim(M_CLICGC2)) = 15
      replace CNPJ     with right(M_CLICGC2,14)
    else
      replace CNPJ     with M_CLICGC2
    endif

    if M_NFSDEV > 0 .or. M_NFSCPG = 3 // devolucao
      replace FINNFE with "4"
      replace NFSREF with M_NFSREF
    endif

    replace EMAIL    with ""
    replace NOME     with M_CLINOM
    replace CEP      with strzero(M_CLICEP2, 5, 0) + strzero(M_CLICCL2, 3, 0)
    replace ENDERECO with M_CLIEND2
    replace NUMERO   with "."
    replace COMPLE   with ""
    replace BAIRRO   with iif(empty(M_CLIBAI2),".",M_CLIBAI2)
    replace CIDADE   with M_CLIMUN2
    replace ESTADO   with M_CLIUF2
    replace FONE     with M_CLITEL3
    replace IE       with M_CLIIES2
    replace CODIBGE  with str(M_CLIIBGE,7)
    replace TRANOM   with M_TRANOM
    replace TRAEND   with M_TRAEND
    replace TRAMUN   with M_TRAMUN
    replace TRAUF    with M_TRAEST
    replace TRAPLC   with M_TRAPLC
    replace QVOL     with M_NFSITE
    replace ESP      with M_NFSESP
    replace MARCA    with M_NFSMAR
    replace PESOL    with M_NFSPLQ
    replace PESOB    with M_NFSPRB
    replace NFSEMP   with M_NFSEMP
    replace NFSNUM   with M_NFSNUM
    replace NFSSER   with M_NFSSER
    replace NFSDTE   with M_NFSDTE
    replace NFSDTS   with M_NFSDTS
    replace NFSCLI   with M_NFSCLI
    replace NFSTRA   with M_NFSTRA
    replace NFSPOR   with M_NFSPOR
    replace NFSCOM   with M_NFSCOM
    replace NFSPIC   with aliq_icm()
    replace NFSNEB   with M_NFSNEB
    replace NFSVLM   with M_NFSVLM
    replace NFSBIC   with M_NFSBIC
    replace NFSVIC   with M_NFSVIC
    replace NFSVIP   with M_NFSVIP
    replace NFSDSC   with M_NFSDSC
    replace NFSVEN   with M_NFSVEN
    replace NFSCPG   with M_NFSCPG
    replace NFSFRE   with M_NFSFRE
    replace NFSSEG   with M_NFSSEG
    replace NFSVLN   with M_NFSVLN
    replace NFSVLD   with M_NFSVLD
    replace NFSTRI   with M_NFSTRI
    replace NFSISE   with M_NFSISE
    replace NFSRED   with M_NFSRED
    replace NFSOUT   with M_NFSOUT
    replace NFSSAI   with M_NFSSAI
    replace NFSTRC   with M_NFSFRC
    replace NFSCNPJ  with M_CLICGC2
    replace NFSIESN  with M_CLIIES2
    replace NFSIPL   with "I"
    replace NFSHOR   with time()

    for AB = 1 to 6
      MS = str(AB,1)
      MS1 = strzero(AB,2)
      replace NFSVCT&MS1 with M_DUPVC&MS
      replace NFSDUP&MS1 with M_DUPDP&MS
    next

    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"AFOR00","UPDATE"}
    aadd(sqlCHAVE,{"FORCOD",str(M_NFSCLI,7)})
    aadd(sqlCAMPO,{"FORULC",formatdta(M_NFSDTE),.t.})
    executasql()

  endif

if M_NFSHIS = "S"
  for S = 1 to 6
    select AHISAA
    if !empty(M_HIS[S])
      append blank
      replace HIS with M_HIS[S]
    endif
  next
endif

if cCODCLI > 0
  select AHISAA
  append blank
  replace HIS with "Codigo Cliente: " + alltrim(str(cCODCLI,7))
endif

  lTemerro = .f. // se tiver erro gravamos na empres 66 para pegar depois

  if !lNFSSER

    if !F_TIPO == "INCLUSAO"

      geraxml()

      M_NOAR = ""  // se retornar 100 grava normal

*      if !"TESTE" $ M_LOGNOM
        if !novo_xml()
          if !lTemerro  // se tiver erro gravamos na empres 66 para pegar depois
            return ""
          endif
        endif
 *     endif

      // ATUALIZAR EMPRESA

     sqlCAMPO = {}
     sqlCHAVE =  {}
     sqlARQUI = {"AEMP00","UPDATE"}
     aadd(sqlCHAVE,{"EMPCOD",str(ME_EMP,2)})
     aadd(sqlCAMPO,{"EMPNFS",str(ANFSAA->NFSNUM,7),.t.})
     executasql()
    endif
  endif

  msw("* * * GRAVANDO DUPLICATAS * * *")

  if M_FISINT = "R"
    grdcrdd()                   && cria duplicatas conta a receber
  endif

  BUSCAREGISTRO("AFIS00",1,{str(ME_EMP, 2, 0),aspas(M_NFSNATN)},"SELECT")
  MS = strzero(ME_EMP,2)

  for R = 1 to len(M_NFSMAT)

    if M_NFSMAT[R,3] = 0
      loop
    endif

    msw("* * * ATUALIZANDO SALDOS * * *")

    if left(M_NFSNATN,1) > "4"
      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {"ANFS01","INSERT"}

      aadd(sqlCAMPO,{"NFSEMP",str(M_NFSEMP,2),.t.})
      aadd(sqlCAMPO,{"NFSNUM",str(M_NFSNUM,6),.t.})
      aadd(sqlCAMPO,{"NFSSER",M_NFSSER,.t.})
      aadd(sqlCAMPO,{"NFSSEQ",str(M_NFSMAT[R,1],3),.t.})
      aadd(sqlCAMPO,{"NFSMAT",str(M_NFSMAT[R,3],6),.t.})
      aadd(sqlCAMPO,{"NFSQDE",str1(M_NFSMAT[R,4],2),.t.})
      aadd(sqlCAMPO,{"NFSPRB",str1(M_NFSMAT[R,5],2),.t.})
      aadd(sqlCAMPO,{"NFSVLI",str1(M_NFSMAT[R,6],2),.t.})
      aadd(sqlCAMPO,{"NFSLIQ",str1(M_NFSMAT[R,7],2),.t.})
      aadd(sqlCAMPO,{"NFSVIC",str1(M_NFSMAT[R,9],2),.t.})
      aadd(sqlCAMPO,{"NFSBIC",str1(M_NFSMAT[R,8],2),.t.})
      aadd(sqlCAMPO,{"NFSISE",str1(M_NFSMAT[R,10],2),.t.})
      aadd(sqlCAMPO,{"NFSOUT",str1(M_NFSMAT[R,11],2),.t.})
      aadd(sqlCAMPO,{"NFSDSP",str1(M_NFSMAT[R,12],2),.t.})
      aadd(sqlCAMPO,{"NFSPIC",str1(iif(M_NFSMAT[R, 9] > 0,M_NFSMAT[R,25],0),2),.t.})
      aadd(sqlCAMPO,{"NFSBIP",str1(iif(M_NFSMAT[R,13] > 0,M_NFSMAT[R,07],0),2),.t.})
      aadd(sqlCAMPO,{"NFSVIP",str1(M_NFSMAT[R,13],2),.t.})
      aadd(sqlCAMPO,{"NFSDTE",formatdta(M_NFSDTE),.t.})
      if empty(M_NFSMAT[R,18]) .and. M_NFSMAT[R,03] = 1
        aadd(sqlCAMPO,{"NFSNATN","5.102",.t.})
      else
        aadd(sqlCAMPO,{"NFSNATN",M_NFSMAT[R,18],.t.})
      endif
      aadd(sqlCAMPO,{"NFSEST",M_CLIUF2,.t.})
      aadd(sqlCAMPO,{"NFSCOM",str1(M_NFSMAT[R,14],2),.t.})
      aadd(sqlCAMPO,{"NFSISI",str1(M_NFSMAT[R,15],2),.t.})
      aadd(sqlCAMPO,{"NFSOUI",str1(M_NFSMAT[R,16],2),.t.})
      aadd(sqlCAMPO,{"NFSOBS",M_NFSMAT[R,17],.t.})
      aadd(sqlCAMPO,{"NFSLOTE",M_NFSMAT[R,23],.t.})
      aadd(sqlCAMPO,{"NFSVCT",formatdta(M_NFSMAT[R,24]),.t.})
      aadd(sqlCAMPO,{"NFSPIP",str1(iif(AFIS00->FISIPI=="S",zPCAIPI,0),2),.t.})
      aadd(sqlCAMPO,{"PACIENTE",M_CLINOM,.t.})
      executasql()
    else
      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {"ANFE01","INSERT"}

      aadd(sqlCAMPO,{"NFEEMP",str(M_NFSEMP,2),.t.})
      aadd(sqlCAMPO,{"NFENUM",str(M_NFSNUM,6),.t.})
      aadd(sqlCAMPO,{"NFESER",M_NFSSER,.t.})
      aadd(sqlCAMPO,{"NFEFOR",str(M_NFSCLI,5),.t.})
    	aadd(sqlCAMPO,{"NFESEQ",str(M_NFSMAT[R,1],3),.t.})
      aadd(sqlCAMPO,{"NFEDTE",formatdta(M_NFSDTE),.t.})
      aadd(sqlCAMPO,{"NFEDTR",formatdta(M_NFSDTE),.t.})
      aadd(sqlCAMPO,{"NFEMAT",str(M_NFSMAT[R,3],6),.t.})
      aadd(sqlCAMPO,{"NFEQDE",str1(M_NFSMAT[R,4],2),.t.})
      aadd(sqlCAMPO,{"NFEPUN",str1(M_NFSMAT[R,5],2),.t.})
      aadd(sqlCAMPO,{"NFEVLI",str1(M_NFSMAT[R,6],2),.t.})
      aadd(sqlCAMPO,{"NFEPIC",str1(iif(M_NFSMAT[R, 9] > 0,aliq_icm(),0),2),.t.})
      aadd(sqlCAMPO,{"NFEDST",str1(M_NFSMAT[R,12],2),.t.})
      aadd(sqlCAMPO,{"NFEBIC",str1(M_NFSMAT[R,8],2),.t.})
      aadd(sqlCAMPO,{"NFEVIC",str1(M_NFSMAT[R,9],2),.t.})
      aadd(sqlCAMPO,{"NFEISE",str1(M_NFSMAT[R,10],2),.t.})
      aadd(sqlCAMPO,{"NFEOUT",str1(M_NFSMAT[R,11],2),.t.})
    	aadd(sqlCAMPO,{"NFENATN",M_NFSMAT[R,18],.t.})
      aadd(sqlCAMPO,{"NFEESC",str(zPCAESC),.t.})
      aadd(sqlCAMPO,{"NFEEXE",str(AFIS00->FISEXE),.t.})
      executasql()
    endif

    msw("* * * GRAVANDO KARDEX * * *")

    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"AKAR00","INSERT"}
    aadd(sqlCAMPO,{"KAREMP",str(M_NFSEMP,2),.t.})
    aadd(sqlCAMPO,{"KARMAT",str(M_NFSMAT[R,3],6),.t.})
    aadd(sqlCAMPO,{"KARDTA",formatdta(M_NFSDTE),.t.})
  	aadd(sqlCAMPO,{"KARFISN",M_NFSMAT[R,18],.t.})
    aadd(sqlCAMPO,{"KARDOC",str(M_NFSNUM,7),.t.})
    aadd(sqlCAMPO,{"KARSER",M_NFSSER,.t.})
    aadd(sqlCAMPO,{"KARCLF",str(M_NFSCLI,5),.t.})
    aadd(sqlCAMPO,{"KARSEQ",str(M_NFSMAT[R,1],3),.t.})
    aadd(sqlCAMPO,{"KARQDE",str1(M_NFSMAT[R,4],3),.t.})
    aadd(sqlCAMPO,{"KARPRB",str1(M_NFSMAT[R,5],2),.t.})
    aadd(sqlCAMPO,{"KARVLI",str1(M_NFSMAT[R,7],2),.t.})
    aadd(sqlCAMPO,{"KARICM",str1(M_NFSMAT[R,9],2),.t.})
    aadd(sqlCAMPO,{"KARIPI",str1(M_NFSMAT[R,13],2),.t.})
    aadd(sqlCAMPO,{"KARDSP",str1(M_NFSMAT[R,12],2),.t.})
    aadd(sqlCAMPO,{"KARLIQ",str1(0,2),.t.})
    aadd(sqlCAMPO,{"KARTRN",formatdta(date()),.t.})
    executasql()
*   aadd(sqlCAMPO,{"KARQDEDC",str1(M_NFSMAT[R,4]*xx_FISEST,3),.t.})

  next && R

  *******************************************************

  if M_NFSNATN $ "1.202#2.202"
    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"ADCR00","ADCR00"})
    aadd(sqlCAMPO,"DUPBOL")
    aadd(sqlCAMPO,"DUPNUM")
    aadd(sqlCAMPO,"DUPORD")
    aadd(sqlCAMPO,"DUPVLA")
    aadd(sqlCHAVE,"DUPEMP = " + str(ME_EMP,2))
    aadd(sqlCHAVE,"DUPNUM = " + str(M_NFSDEV,6))
    aadd(sqlCHAVE,"DUPHIS = 500")
    sqlrelation()


    M_DUPS = { }
    M_TOTAL = 0
    do while !eof()
      aadd(M_DUPS,{DUPEMP,DUPNUM,DUPORD,DUPVLA})
      M_TOTAL += DUPVLA
      skip
    enddo

    if len(M_DUPS) > 0
      M_RESTO = 0
      if len(M_DUPS) > 1  // se mais de uma duplicata
        M_VAL1 = round(M_NFSVLN/len(M_DUPS),2)
        M_RESTO = M_NFSVLN - (M_VAL1*len(M_DUPS))
      else
        M_VAL1 = M_NFSVLN
      endif

      for A = 1 to len(M_DUPS)
        sqlCAMPO = {}
        sqlCHAVE =  {}
        sqlARQUI = {}
        sqlORDEM = {}

        aadd(sqlARQUI,{"ADCR00","ADCR00"})
        aadd(sqlCAMPO,"DUPNUM")
        aadd(sqlCAMPO,"DUPORD")
        aadd(sqlCAMPO,"DUPCLI")
        aadd(sqlCAMPO,"DUPVLA")
        aadd(sqlCAMPO,"DUPSER")
        aadd(sqlCAMPO,"DUPHIS")

        aadd(sqlCHAVE,"DUPEMP = " + str(M_DUPS[A,1],2))
        aadd(sqlCHAVE,"DUPNUM = " + str(M_DUPS[A,2],6))
        aadd(sqlCHAVE,"DUPORD = " + str(M_DUPS[A,3],2))
        sqlrelation()

        if !eof()
          sqlCAMPO = {}
          sqlCHAVE =  {}
          sqlARQUI = {"ALCR00","INSERT"}
          aadd(sqlCAMPO,{"LANEMP",str(ME_EMP,2),.t.})
          aadd(sqlCAMPO,{"LANNUM",str(ADCR00->DUPNUM,6),.t.})
          aadd(sqlCAMPO,{"LANSER",ADCR00->DUPSER,.t.})
          aadd(sqlCAMPO,{"LANORD",str(ADCR00->DUPORD,2),.t.})
          aadd(sqlCAMPO,{"LANHIS",str(iif(str(M_TOTAL,12,2) == str(M_NFSVLN,12,2),100,400),3),.t.})
          aadd(sqlCAMPO,{"LANDTM",formatdta(M_NFSDTE),.t.})
          aadd(sqlCAMPO,{"LANCLI",str(ADCR00->DUPCLI,5),.t.})
          aadd(sqlCAMPO,{"LANVAL",str1(iif(str(M_TOTAL,12,2) == str(M_NFSVLN,12,2),ADCR00->DUPVLA,M_VAL1+iif(A=1,M_RESTO,0)),2),.t.})
          aadd(sqlCAMPO,{"LANOBS","DEVOLUCAO DE NF",.t.})
          executasql()

          sqlCAMPO = {}
          sqlCHAVE =  {}
          sqlARQUI = {"ADCR00","UPDATE"}
          aadd(sqlCHAVE,{"DUPEMP",str(ME_EMP,2)})
          aadd(sqlCHAVE,{"DUPNUM",str(ADCR00->DUPNUM,6)})
          aadd(sqlCHAVE,{"DUPSER",aspas(ADCR00->DUPSER)})
          aadd(sqlCHAVE,{"DUPORD",str(ADCR00->DUPORD,2)})

          aadd(sqlCAMPO,{"DUPDTP",formatdta(iif(str(M_TOTAL,12,2) == str(M_NFSVLN,12,2),M_NFSDTE,ctod("  /  /  "))),.t.})
          aadd(sqlCAMPO,{"DUPOBS","DEVOLUCAO DE NF",.t.})
          aadd(sqlCAMPO,{"DUPHIS",str(iif(str(M_TOTAL,12,2) == str(M_NFSVLN,12,2),100,ADCR00->DUPHIS),3),.t.})
          aadd(sqlCAMPO,{"DUPVLP",str1(iif(str(M_TOTAL,12,2) == str(M_NFSVLN,12,2),ADCR00->DUPVLA,M_VAL1+iif(A=1,M_RESTO,0)),2),.t.})
          aadd(sqlCAMPO,{"DUPVLA",str1(iif(str(M_TOTAL,12,2) == str(M_NFSVLN,12,2),0,DUPVLA-(M_VAL1+iif(A=1,M_RESTO,0))),2),.t.})
          executasql()
        endif
      next
    endif
  endif

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"AETQ00","UPDATE OR INSERT"}
  aadd(sqlCHAVE,{"ETQCOD"})
  aadd(sqlCAMPO,{"ETQCOD",str(M_NFSCLI,10),.T.})
  aadd(sqlCAMPO,{"ETQDS4","",.T.})
  aadd(sqlCAMPO,{"ETQDS5","DANFE " + strzero(M_NFSNUM,6),.T.})
  if M_NFSITE > 1
    aadd(sqlCAMPO,{"ETQDS6",strzero(M_NFSITE,2) + " VOLUMES      TESTI EXPRESS         ",.T.})
  else
    aadd(sqlCAMPO,{"ETQDS6",strzero(M_NFSITE,2) + " VOLUME       TESTI EXPRESS         ",.T.})
  endif
  executasql()

  fecha_arq()

  if M_NFSSAI == "S"
    select 0
    use NOTA0 exclusive
    select NOTA0
    go top

    do while !eof()
      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {"ANFS00","INSERT"}
      DBFTOSQL("NOTA0")
      executasql()
      select NOTA0
      skip
    enddo
    select NOTA0
    use
  else
    select 0
    use NOTAE0 exclusive
    select NOTAE0
    go top

    do while !eof()
      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {"ANFE00","INSERT"}
      DBFTOSQL("NOTAE0")
      executasql()
      select NOTAE0
      skip
    enddo
    select NOTAE0
    use
  endif

  set margin to 0
  set print off
  set printer to
  set console on 
  set cursor on 
  set relation to

  restscreen(08, 15, 13, 51,M_TELA)

return ""

*******************
function LAY_NORMAL
*******************

XX_END = " "

if file("&_PATH_\LISTA.DBF")
  restore from &_PATH_\LISTA.DBF additive
endif

select ANFS02
go top

do while !eof()

  R = ANFS02->POSICAO
  
  if M_NFSMAT[R][3] = 0 .or. M_NFSMAT[R][3] = 1 // FRETE
    M_NFSMAT[R,18] = "5.102"
    skip
    loop
  endif

  valorespro(M_NFSMAT[R][3])

  if "ALUGUEL" $ M_NFSMAT[R][20]
    skip
    loop
  endif

  BUSCAREGISTRO("ANCM00",1,{zPCANCM},"SELECT")

  if M_NFSNATN $ "5.102#6.102"  // CFOP da nota
    if !M_CLIUF2 = AEMP00->EMPEST .and. sem_ies(M_CLIIES2)
//      M_NFSCFO := "5.102" // "6.108"
      M_NFSCFO := "6.108"
    else
      if zPCATRI = 4 .and. M_CLIUF2 = AEMP00->EMPEST
        M_NFSCFO := "5.405"
      else
        M_NFSCFO := AFIS00->FISNOV
      endif
    endif
  else
    if M_NFSNATN = "5.202" .and. zPCATRI = 4
      M_NFSCFO := "5.411"
    else
      M_NFSCFO := AFIS00->FISNOV
    endif
  endif

  do case
    case zPCATRI = 4 .and. M_CLIUF2 = AEMP00->EMPEST   // Se for produto com substitui‡Æo tribut ria
      bNATTRI = "060"
    case zPCATRI = 4 .and. M_CLIUF2 # AEMP00->EMPEST   // substituicao fora estado = tributado
      bNATTRI = "000"
    case zPCATRI = 2   // Se for isento
      bNATTRI = "040"
    case zPCATRI = 3   // reducao
      bNATTRI = "020"
    case zPCATRI = 1   // tributado
      bNATTRI = "000"
    case zPCATRI = 5   // nao tributada
      bNATTRI = "041"
  endcase

  if M_NFSCFO == "5.918" .or. M_NFSCFO == "5.202"
    bNATTRI = "000"  // outros icm na devolucao
  endif

  M_NFSMAT[R,18] = M_NFSCFO

  // ITEM NOTA FICAL ELETRONICA

  select ANFSAB                      && seleciona NFS itens

  _append("ANFSAB")

  replace NFSEMP   with M_NFSEMP
  replace NFSNUM   with M_NFSNUM
  replace NFSSER   with M_NFSSER
  replace NFSSEQ   with M_NFSMAT[R,01]
  replace NFSMAT   with M_NFSMAT[R,03]

  if M_NFSCOMP == "S" // COMPLEMENTO
    replace NFSQDE with 0
    replace NFSPRB with 0
    replace NFSVLI with 0
    replace NFSLIQ with 0
    replace NFSVIC with M_NFSMAT[R,09]
    replace NFSBIC with 0
  else
    replace NFSBIC   with M_NFSMAT[R,08]
    replace NFSQDE   with M_NFSMAT[R,04]
    replace NFSPRB   with M_NFSMAT[R,05]
    replace NFSVLI   with M_NFSMAT[R,06]
    replace NFSLIQ   with M_NFSMAT[R,07]
    replace NFSVIC   with M_NFSMAT[R,09]
  endif

  replace NFSVIP   with M_NFSMAT[R,13]
  replace NFSPIPI  with iif(AFIS00->FISIPI="S",zPCAIPI,0)
  replace NFSISE   with M_NFSMAT[R,10]
  replace NFSOUT   with M_NFSMAT[R,11]
  replace NFSDSP   with M_NFSMAT[R,12]
  replace NFSLOTE  with M_NFSMAT[R,23]
  replace NFSVCT   with M_NFSMAT[R,24]

  replace PCADES   with alltrim(zPCADES) + " " + alltrim(zPCAMAR)
  replace PCAUNI   with zPCAUNI
  replace PCANCM   with zPCANCM
  replace PCATRI   with bNATTRI
  replace NFSNATN  with M_NFSCFO

  if empty(PCADESADI)
    if !empty(M_NFSMAT[R,23])
      replace PCADESADI with "Lote: " + alltrim(M_NFSMAT[R,23]) + " - Validade: " + dtoc(M_NFSMAT[R,24])
    endif
  endif

  replace NFSPIC with iif(M_NFSMAT[R, 9] > 0,M_NFSMAT[R,25],0)
  replace NFSEST with M_CLIUF2

  lRecab = recno()

  select ANFS02
  skip

enddo

return ""

***************
function CONNFS(F_TIPO)
***************


if F_TIPO == NIL
  F_TIPO = "NORMAL"
endif

private M_TELA ,;
        M_ALT ,;
        M_OPC

private  M_NFSEMP ,;  
         M_NFSCLI ,;
         M_NFSDTE 

lPaint = .t.

    do while .t.

      rodape("CONSULTA", "NFS", M_FAN, "EAGRO21","Mem: " + str(memory(0), 5), M_EMP)

      tlnfs01()
      AlteraRestauraTela("TLNFS01",.t.)
      if lPaint
        lPaint = .f.
      endif

         M_NFSEMP  = ME_EMP
         M_NFSNUM  = 0
         M_NFSSER  = AEMP00->EMPSER

         SetColor(_COREDICAO_)
         @ 04, 15 get M_NFSNUM picture "######"
         @ 04, 22 get M_NFSSER picture "@!"
         read

         if M_NFSNUM = 0
           exit
         endif

         if !BUSCAREGISTRO("ANFS00",1,{str(M_NFSEMP, 2, 0),str(M_NFSNUM, 6, 0),aspas(M_NFSSER)},"SELECT")
           msg("* * * NOTA NAO INCLUIDA * * *")
           loop
         endif


         msnfs03()
         msnfs04()

         vernfs5a()

  select ANFS00

  if alltrim(F_TIPO) $ "EMAIL"  // se reemissao
    if empty(NFSID)
      msg("ESTA NOTA NAO FOI EMITIDA ELETRONICAMENTE")
      loop
    endif

    M_ARQE = "C:\ATLAS\NFE\ANFS00"
    M_ID = "C:\ATLAS\ENVIADO\" + alltrim(ANFS00->NFSUSU) + "\nfe\" + alltrim(ANFS00->NFSID)

    do while .t.
      select 0
      use &M_ARQE alias ANFSAA exclusive
      if neterr()
        setcolor("")
        msw("A NOTA FISCAL ESTA SENDO EMITIDA POR OUTRA MAQUINA AGUARDE")
        inkey(.1)
        loop
      endif
      exit
    enddo

    lTememail = .f.

    if "@" $ ACLI00->CLIEMAIL  // tem email
      msw("Enviando email para: " + alltrim(ACLI00->CLIEMAIL))
      nfe_ema(lower(alltrim(ACLI00->CLIEMAIL)),M_ID,"1")
      lTememail = .t.
    endif

    M_EMAIL1 = ""
    M_EMAIL2 = ""
    M_EMAIL3 = ""
    M_EMAIL4 = ""

    if BUSCAREGISTRO("MENSAGE2",1,{str(ANFS00->NFSCLI,7,0)},"SELECT")
      SELECT MENSAGE2
      if "@" $ EMAIL1  // tem email
        msw("Enviando email para: " + alltrim(EMAIL1))
        nfe_ema(lower(alltrim(EMAIL1)),M_ID,"1")
        lTememail = .t.
      endif
      if "@" $ EMAIL2  // tem email
        msw("Enviando email para: " + alltrim(EMAIL2))
        nfe_ema(lower(alltrim(EMAIL2)),M_ID,"1")
        lTememail = .t.
      endif
      if "@" $ EMAIL3  // tem email
        msw("Enviando email para: " + alltrim(EMAIL3))
        nfe_ema(lower(alltrim(EMAIL3)),M_ID,"1")
        lTememail = .t.
      endif
      if "@" $ EMAIL4  // tem email
        msw("Enviando email para: " + alltrim(EMAIL4))
        nfe_ema(lower(alltrim(EMAIL4)),M_ID,"1")
        lTememail = .t.
      endif

      if lTememail
        msg("* * * EMAIL ENVIADO * * *")
      endif
    endif

    select ANFSAA
    use

  endif

  if alltrim(F_TIPO) $ "REEMITE#AUTORIZA"  // se reemissao
    if empty(NFSID)
      msg("ESTA NOTA NAO FOI EMITIDA ELETRONICAMENTE")
      loop
    endif

    M_ARQE = "C:\ATLAS\NFE\ANFS00"

    do while .t.
      select 0
      use &M_ARQE alias ANFSAA exclusive
      if neterr()
        setcolor("")
        msw("A NOTA FISCAL ESTA SENDO EMITIDA POR OUTRA MAQUINA AGUARDE")
        inkey(.1)
        loop
      endif
      exit
    enddo
    zap

    select ANFSAA
    append blank
    replace NFSID with alltrim(ANFS00->NFSUSU) + "\nfe\" + alltrim(ANFS00->NFSID)
    use

    if alltrim(F_TIPO) $ "REEMITE"  // se reemissao
      msw("REEMITINDO NOTA FISCAL ELETRONICA")
    else
      msw("AUTORIZANDO NOTA EMITIDA")
    endif

    M_NOAR1 = "C:\ATLAS\ENVIADO\" + alltrim(ANFS00->NFSUSU) + "\nfe\" + alltrim(ANFS00->NFSID)

    if F_TIPO == "REEMITE"
      lReemitenfs = .t.
      M_MEMO := NFe_IMP(M_NOAR1)
      lReemitenfs = .f.
    else
      M_MEMO := NFe_CON(M_NOAR1)
    endif

    if !alltrim(F_TIPO) $ "REEMITE"  // se reemissao
      lTela2 = savescreen(04,03,19,75)
      M_MEMO += chr(13)+chr(10)
      M_MEMO += "PRESSIONE (ESC) PARA SAIR"+ chr(13)+chr(10)
      M_MEMO = memoedit(M_MEMO,04,03,19,75,.f.,,73)
      restscreen(04,03,19,75,lTela2)
    endif
  endif

  msg("* * * TECLE (ENTER) " + iif(ANFS00->NFSCAN="C","- NOTA CANCELADA","") + " * * *")
  ninkey(0)

enddo


return ""

****************
function ACHANFS
****************

parameters  M_MODO, M_ELEM, M_POSI

  if str(lastkey(), 2, 0) $ "27"
    return 0
  endif

  M_LINPOS = M_POSI

return 2

***************
function EXCNFS
***************

private  M_NFSEMP ,;  
         M_NFSCLI ,;
         M_NFSDTE 

    do while .t.

      rodape("EXCLUSAO", "NFS", M_FAN, "EAGRO21","Mem: " + str(memory(0), 5), M_EMP)

      tlnfs01()
      AlteraRestauraTela("TLNFS01",.t.)
  
         M_NFSEMP  = ME_EMP
         M_NFSNUM  = 0
         M_NFSSER  = AEMP00->EMPSER

     SetColor(_COREDICAO_)
         @ 04, 15 get M_NFSNUM picture "######"
         @ 04, 22 get M_NFSSER picture "@!"
         read

         if M_NFSNUM = 0
           exit
         endif

         select ANFS00

         if !dbseek(str(M_NFSEMP, 2, 0) + str(M_NFSNUM, 6, 0) + M_NFSSER)
           msg("* * * NOTA NAO INCLUIDA * * *")
           loop
         endif

         msnfs03()
         msnfs04()

         select ANFS00
 
         if !rlock()
           msg("* * * (ANFS00) REGISTRO SENDO USADO * * *")
           loop
         endif


         M_OPC = confirma("desta Nota")

         if M_OPC != 1
           msg("* * * NOTA FISCAL NAO EXCLUIDA * * *")
           unlock
           loop
         endif

         msw("* * * EXCLUINDO NOTA FISCAL * * *")

         select ANFS00

         if !rlock()
           msg("* * * (ANFS00) REGISTRO SENDO USADO * * *")
           loop
         endif       

         AFIS00->(dbseek(ANFS00->NFSNATN)) 
         MS = strzero(ME_EMP,2)

         select ANFS01

         do while .t.
  
           dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER,.t.)

           if !str(NFSEMP, 2, 0) + str(NFSNUM, 6, 0) + NFSSER == str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER
             exit
           endif

           select APCA00
           dbseek(str(ANFS01->NFSMAT, 6, 0))
           do while .t.
             if rlock()
               if AFIS00->FISEST = "C"
                 replace SLD&MS with (SLD&MS - ANFS01->NFSQDE)
               else
                 if AFIS00->FISEST = "D"
                   replace SLD&MS with (SLD&MS + ANFS01->NFSQDE)
                 endif
               endif
               unlock
               exit
             else
               msw("* * * (APCA00) REGISTRO SENDO USADO * * *")
             endif
             if lastkey()=17
               exit
             endif
           enddo

           select AKAR00

           dbseek(str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSMAT, 6, 0) + dtos(ANFS00->NFSDTE) + ANFS00->NFSNATN + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER,.t.)      

           if str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSMAT, 6, 0) + dtos(ANFS00->NFSDTE) + ANFS00->NFSNATN + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER == str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) + KARFISN + str(KARDOC, 6, 0) + KARSER
             elimina()
           endif

           select ANFS01
           elimina() 
         enddo

         select ADCR00

         M_PRI = .t.
 
         do while .t.
           dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0), .t.)
           if !str(DUPEMP, 2, 0) + str(DUPNUM, 6, 0) == str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0)
             if M_PRI = .t.
               msg("* * * DUPLICATA NAO ENCONTRADA * * *")
             endif 
             exit
           endif
           M_PRI = .f.
           do while .t.
             if rlock()
               replace DUPEMP with 99
               replace DUPUSU with M_LOGNOM
               unlock
               exit 
             endif
           enddo
         enddo

         select ALCR00

         do while .t.
           if dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0), .t.)
             if !str(LANEMP, 2, 0) + str(LANNUM, 6, 0) == str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0)
               exit
             endif
             elimina()
           else
             exit
           endif
         enddo

         select ANFS00
         elimina()
         msg("* * * NOTA FISCAL EXCLUIDA * * *")

    enddo

return ""

***************
function LISNFS
***************
parameters M_OPC,M_OPC1,M_OPC2

declare MT_CLIQDE[10] ,;
        MT_CLIVIS[10] ,;
        MT_CLIPRZ[10]

     for R = 1 to 10
        MT_CLIQDE[R] = 0
        MT_CLIVIS[R] = 0
        MT_CLIPRZ[R] = 0
     next

     M_MATNFS = {}

     rodape("LISTA","NFS",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP) 

*        @ 04, 25 prompt "Sintetica Notas Ficais     " POSITION 11 HIGHLITE R/BG
*        @ 05, 25 prompt "Cliente Analitica          " POSITION 1  HIGHLITE R/BG
*        @ 06, 25 prompt "Cliente Sintetica          " POSITION 9  HIGHLITE R/BG
*        @ 07, 25 prompt "Relacao de Notas de Servico" POSITION 1  HIGHLITE R/BG
*        @ 08, 25 prompt "Vendedor Notas             " POSITION 1  HIGHLITE R/BG
*        @ 09, 25 prompt "Vendedor Sintetica         " POSITION 2  HIGHLITE R/BG
*        @ 10, 25 prompt "Municipio Sintetica        " POSITION 1  HIGHLITE R/BG
*        @ 11, 25 prompt "Produto Sintetica          " POSITION 1  HIGHLITE R/BG
*        @ 12, 25 prompt "Notas Emitidas no Periodo  " POSITION 3  HIGHLITE R/BG
*        @ 13, 25 prompt "Margem Bruta de Vendas     " POSITION 8  HIGHLITE R/BG
*        @ 14, 25 prompt "Etiquetas de Caixa         " POSITION 3  HIGHLITE R/BG
*        @ 15, 25 prompt "Faturamento                " POSITION 1  HIGHLITE R/BG
*        @ 16, 25 prompt "Nota Fiscal Paulista       " POSITION 4  HIGHLITE R/BG
*        @ 17, 25 prompt "Notas no Periodo (Antigo)  " POSITION 4  HIGHLITE R/BG
*        @ 18, 25 prompt "Produtos Isentos           " POSITION 4  HIGHLITE R/BG
*        @ 19, 25 prompt "IMS                        " POSITION 1  HIGHLITE R/BG


        do case
           case M_OPC =  1 ; lisnfs_a()
           case M_OPC =  2 ; lisnfs_b()
           case M_OPC =  3 ; lisnfs_f()
           case M_OPC =  4 ; lisnfs_c()
           case M_OPC =  5 ; lisnfs_d()
           case M_OPC =  6 ; lisnfs_e()
           case M_OPC =  7 ; lisnfs_g()
           case M_OPC =  8 ; lisnfs_h()
           case M_OPC =  9 ; lisnfs_i()
           case M_OPC = 10 ; lisnfs_j()
           case M_OPC = 11 ; lisnfs_k()
           case M_OPC = 12 ; lisnfs_l()
           case M_OPC = 13 ; nfpaulista()
           case M_OPC = 14 ; lisnfs_ia()
           case M_OPC = 15 ; proisento()
*           case M_OPC = 16 ; iqvia()
        endcase

return ""

*****************
function LISNFS_A
***************** 

private M_REQ1 ,;
        M_REQ2 ,;
        M_SER1 ,;
        M_SER2 ,;
        LN     ,;
        PG     ,;
        M_TELA
 
    do while .t.

        rodape("SINTETICO","NF SAIDA",M_FAN,"EAGRO23","Mem: " + str(memory(0), 5),M_EMP) 

        store 0         to M_REQ1 ,;
                           M_REQ2

        store AEMP00->EMPSER to M_SER1 ,;
                                M_SER2

        store date()           to M_DTA1 ,;
                                  M_DTA2 

        store "3"              to M_REQIPL

       sombra(14, 41, 17, 73,_SOMBRA_)

       set color to GR/W
         @ 14, 41 say                  "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
         @ 15, 41 say                  "³   Data Emissao Inicial:           ³" 
         @ 16, 41 say                  "³                  Final:           ³" 
         @ 17, 41 say                  "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
     SetColor(_COREDICAO_)
         @ 15, 67 get M_DTA1
         @ 16, 67 get M_DTA2
         read
       set color to

        if lastkey() = 27
          return ""
        endif

        M_DTA1 = iif(dtoc(M_DTA1) = "  /  /  ",ctod("01/01/80"),M_DTA1)
        M_DTA2 = iif(dtoc(M_DTA2) = "  /  /  ",ctod("31/12/79"),M_DTA2) 

        select ANFS00

        set relation to NFSNATN into AFIS00 

        set order to 2

        dbseek(str(ME_EMP, 2, 0) + dtos(M_DTA1), .t.)
       
        if eof()  .or. NFSEMP != ME_EMP
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
                  M_TOTPRO,M_TOTSER ,M_TOTFRE

       cab_nfs10()                           && imprime cabecalho
       cab_nfs10a()

       do while !eof()

          if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DTA2)
            go bottom
            skip
            loop
          endif

          if NFSCAN == "C"   
            skip
            loop 
          endif

          if NFSCPG > 2 
            if NFSCPG < 21
              skip
              loop
            endif
          endif       

*          ? "DOCTO  SE CODFIS                       EMISSAO CLIENTE                                     PRODUTOS    ALUGUEIS    FRETE    TOTAL"
*             999999 99 999.99 AAAAAAAAAAAAAAAAAAAA 99/99/99 9999999 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 9999,999.99 9999,999.99 99999.99 9999,999.99

           valorescli(NFSCLI)

           ? str(NFSNUM, 6, 0)
            ?? " "
            ?? NFSSER
            ?? " "
            ?? NFSNATN
            ?? " "
            ?? pad(AFIS00->FISNOM, 20) 
            ?? " " 
            ?? NFSDTE
            ?? " "
            ?? str(NFSCLI, 7, 0)
            ?? " "
            ?? left(zCLINOM, 32)
            ?? " " 
            ?? transform(NFSVLM,"@E@Z ####,###.##") 
            ?? " "
            ?? transform(NFSVLS,"@E@Z ####,###.##") 
            ?? " "
            ?? transform(NFSFRE,"@E@Z #9###.##") 
            ?? " "
            ?? transform(NFSVLM+NFSVLS+NFSFRE,"@E@Z ####,###.##") 

            M_TOTPRO += NFSVLM
            M_TOTSER += NFSVLS
            M_TOTFRE += NFSFRE

            LN = LN + 1

            if LN > 60
              cab_nfs10()
              cab_req2()
            endif  

            select ANFS00

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
            ?? pad("               TOTAL GERAL -=> ",31)
            ?? " " 
            ?? transform(M_TOTPRO,"@E@Z ####,###.##") 
            ?? " "
            ?? transform(M_TOTSER,"@E@Z ####,###.##") 
            ?? " "
            ?? transform(M_TOTFRE,"@E@Z #####.##") 
            ?? " "
            ?? transform(M_TOTPRO+M_TOTSER+M_TOTFRE,"@E@Z ####,###.##") 

       eject

desliga1()

enddo 

return "" 

*******************
function CAB_NFS10A
*******************

 ? replicate("-",132)  
 ? "DOCTO  SE CODFIS                       EMISSAO CLIENTE                                     PRODUTOS    ALUGUEIS    FRETE       TOTAL"


 LN = LN + 2

return ""

***************
function VERTIP
***************

private M_TELA

      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {"ATIP00","SELECT"}
      executasql()
go top
aTIPCLI = { }

do while !eof()
  if empty(CVECOD)
    skip
    loop
  endif

  aadd(aTIPCLI," ³" + CVECOD + " " + CVENOM)

  skip

enddo


lTelaloc = savescreen(07,29,18,70)

nbox(07,29,17,69,"W/W+",.t.)
setcolor("B/W")
@ 16, 31 say "<T>odos  <ENTER>-Seleciona  <ESC>-SAI"
@ 07, 45 say  " Tipo Cliente " 

set color to N/W,W+/N
M_OP = achoice(08, 31, 16, 68,aTIPCLI,,"SELE_DU")
setcolor("GR+/N,W+/N")

restscreen(07,29,18,70,lTelaloc)

return .t.

****************
function SELE_DU
****************

local A

parameters  M_MODO, M_ELEM, M_POSI

if rat(str(lastkey(), 2, 0),"27") > 0
  return 0
endif

if rat(str(lastkey(), 3, 0),"116, 84") > 0
  for A = 1 to len(aTIPCLI)
    aTIPCLI[A] =  chr(247) + substr(aTIPCLI[A],2,38)
  next
  keyboard chr(3)
  return 2
endif

if rat(str(lastkey(), 2, 0),"13") > 0
  aTIPCLI[M_ELEM] = iif(left(aTIPCLI[M_ELEM],1)==chr(247)," ",chr(247)) + substr(aTIPCLI[M_ELEM],2,38)
  return 2
endif

return 2


*****************
function LISNFS_B                      && relacao de analitica por cliente */
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

select 0         && nfs temporario
M_IND = ""
acha_livre()


    rodape("ANALITICO","CLIENTE",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP) 

    store date() to M_DATA1 ,;
                    M_DATA2


    store 0      to M_DUPCLI,;
                    M_NFSCLI,;
                    M_CODINI,;
                    M_CODFIN,;
                    M_NFSFOR

     M_MOEDA = "R" 
     M_CLITIP = ""
     M_QUEBRA = " "
     M_REGIAO = 0
     aTIPCLI = { }

    nbox(12, 17, 18, 60,"W/W+",.t.)
    setcolor("B/W")
       @ 13, 18 say   "         Regiao:                          "
       @ 14, 18 say   "Periodo Inicial:          a               "
       @ 15, 18 say   "        Cliente:                          "
       @ 16, 18 say   "     Fornecedor:                          "
       @ 17, 18 say   " Quebra mes S/N:                          "
     set color to

     SetColor(_COREDICAO_)
     @ 13, 35 get M_REGIAO picture "99" when Seleregiao(@M_REGIAO,13,35)
     @ 14, 35 get M_DATA1
     @ 14, 46 get M_DATA2
     @ 15, 35 get M_NFSCLI picture "#######"  F2 color _CORF2_ funcao "sele_arquivo('ACLI00')" retorno @M_NFSCLI
     @ 16, 35 get M_NFSFOR picture "9999999"  F2 color _CORF2_ funcao "sele_arquivo('AFOR00')" retorno @M_NFSFOR
     @ 17, 35 get M_QUEBRA picture "@!" valid M_QUEBRA $ "SN"
     read

     if lastkey() = 27
       select ANFS02
       use
       return ""
     endif

     vertip(.t.)

     M_CLITIP = ""

     for A = 1 to len(aTIPCLI)
       if left(aTIPCLI[A],1) == chr(247)
         M_CLITIP += aspas(substr(aTIPCLI[A],3,1))
         M_CLITIP += ","
       endif
     next

     if right(M_CLITIP,1) == ","
       M_CLITIP = left(M_CLITIP,len(M_CLITIP)-1)
     endif

     store 0 to M_TOTGER

     select ANFS02

     if !flock()
       msg("* * * (ANFS02) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     // VAMOS USAR O NFSSER PARA O TIPO DO CLIENTE

     index on str(NFSEMP, 2, 0) + str(NFSCLI, 7, 0) + str(NFSMAT, 6, 0)  tag 1 to &M_IND
     index on str(NFSEMP, 2, 0) + str(NFSCLI, 7, 0) + str(NFSVLN, 14, 2) tag 2 to &M_IND
     index on str(NFSEMP, 2, 0) + str(NFSCLI, 7, 0) + NFSDES             tag 3 to &M_IND
     index on str(NFSEMP, 2, 0) + str(NFSCLI, 7, 0) + MESANO + str(NFSMAT, 6, 0) tag 4 to &M_IND
     index on str(NFSEMP, 2, 0) + str(NFSCLI, 7, 0) + MESANO + NFSDES     tag 5 to &M_IND
     index on str(NFSEMP, 2, 0) + CLITIP + str(NFSCLI, 7, 0) + NFSDES tag 6 to &M_IND

     set index to &M_IND

     Q_EMP = ME_EMP

     if ME_EMP = 10
       Q_EMP = 10
     endif

     if M_QUEBRA == "S"
       set order to 4
     else
       set order to 1
     endif
  
  
  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ANFS00","ANFS00"})
  aadd(sqlCAMPO,"ANFS00.NFSEMP")
  aadd(sqlCAMPO,"ANFS00.NFSSER")
  aadd(sqlCAMPO,"ANFS00.NFSNUM")
  aadd(sqlCAMPO,"ANFS00.NFSCLI")
  aadd(sqlCAMPO,"ANFS00.NFSCPG")
  aadd(sqlCAMPO,"ANFS00.NFSDTE")
  aadd(sqlCAMPO,"APCA00.PCADES")
  aadd(sqlCAMPO,"APCA00.PCAFOR")
  aadd(sqlCAMPO,"ACLI00.CLIVEN")
  aadd(sqlCAMPO,"ACLI00.CLITIP")
  aadd(sqlCAMPO,"ANFS01.NFSMAT")
  aadd(sqlCAMPO,"ANFS01.NFSLIQ")
  aadd(sqlCAMPO,"ANFS01.NFSVLI")
  aadd(sqlCAMPO,"ANFS01.NFSVIP")
  aadd(sqlCAMPO,"ANFS01.NFSQDE")
  aadd(sqlCAMPO,"ANFS01.NFSDSP")


  aadd(sqlRELATION,{"ANFS01","ANFS01.NFSEMP","ANFS00.NFSEMP"})
  aadd(sqlRELATION,{"","ANFS01.NFSNUM","ANFS00.NFSNUM"})
  aadd(sqlRELATION,{"","ANFS01.NFSSER","ANFS00.NFSSER"})
  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","ANFS01.NFSMAT"})
  aadd(sqlRELATION,{"AFIS00",str(Q_EMP,2,0),"AFIS00.FISEMP"})
  aadd(sqlRELATION,{"","AFIS00.FISNOV","ANFS00.NFSNATN"})
  aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ANFS00.NFSCLI"})

  aadd(sqlCHAVE,"ANFS00.NFSDTE BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
  aadd(sqlCHAVE,"ANFS00.NFSEMP = " + str(Q_EMP, 2, 0))
  aadd(sqlCHAVE,"ANFS00.nfscan not in ('C','D')")
  aadd(sqlCHAVE,"ANFS00.NFSNATN <> '5.929'")
  aadd(sqlCHAVE,"ANFS00.NFSLIS <> 'N'")
  aadd(sqlCHAVE,"(ANFS00.NFSCPG < 3 or ANFS00.NFSCPG > 24)")

  if M_REGIAO > 0
    aadd(sqlCHAVE,"ACLI00.CLIVEN = " + str(M_REGIAO,3))
  endif

  if !empty(M_CLITIP)
    aadd(sqlCHAVE,"ACLI00.CLITIP IN (" + M_CLITIP + ")")
  endif

  if M_NFSCLI > 0
    aadd(sqlCHAVE,"ANFS00.NFSCLI = " + str(M_NFSCLI, 5, 0))
  endif

  if M_NFSFOR > 0
    aadd(sqlCHAVE,"APCA00.PCAFOR = " + str(M_NFSFOR, 5, 0))
  endif

  sqlrelation()

*  if eof()
*          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
*         select ANFS02
*         use
*          return ""
*        endif
                
        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

          do while !eof()

            M_MESANO = strzero(month(ANFS00->NFSDTE),2) + strzero(year(ANFS00->NFSDTE),4)

            select ANFS02
       
            if M_QUEBRA == "S"     
              dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSCLI, 7, 0) + M_MESANO + str(ANFS00->NFSMAT, 6, 0))
            else
              dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSCLI, 7, 0) + str(ANFS00->NFSMAT, 6, 0))
            endif

            if eof()
              append blank         
              replace NFSEMP with ANFS00->NFSEMP
              replace NFSCLI with ANFS00->NFSCLI
              replace CLITIP with ANFS00->CLITIP
              replace NFSMAT with ANFS00->NFSMAT
              replace NFSDES with ANFS00->PCADES
              replace MESANO with M_MESANO
            endif

            replace NFSQDE with NFSQDE + ANFS00->NFSQDE
            replace NFSULC with ANFS00->NFSDTE

            M_LIQ = ANFS00->NFSLIQ + ANFS00->NFSDSP + ANFS00->NFSVIP

            replace NFSVLI with NFSVLI + M_LIQ
            replace NFSUQT with ANFS00->NFSQDE
            replace NFSNUM with ANFS00->NFSNUM
            replace NFSSER with ANFS00->NFSSER

            if ANFS00->NFSCPG = 1 .or. ANFS00->NFSCPG = 2
              replace NFSVIS with NFSVIS + M_LIQ
              replace NFSVLN with NFSVLN + M_LIQ
            else
              replace NFSPRZ with NFSPRZ + M_LIQ
              replace NFSVLN with NFSVLN + M_LIQ
            endif            

            M_TOTGER = M_TOTGER + M_LIQ

            select ANFS00

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                select ANFS02
                use
                return ""
              endif
            endif

            skip
 
          enddo


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
  aadd(sqlCAMPO,"ACUP00.CUPDTE")
  aadd(sqlCAMPO,"ACUP00.CUPSER")

  aadd(sqlCAMPO,"APCA00.PCADES")
  aadd(sqlCAMPO,"APCA00.PCAFOR")
  aadd(sqlCAMPO,"ACLI00.CLIVEN")
  aadd(sqlCAMPO,"ACLI00.CLITIP")
  aadd(sqlCAMPO,"ACUP01.CUPMAT")
  aadd(sqlCAMPO,"ACUP01.CUPLIQ")
  aadd(sqlCAMPO,"ACUP01.CUPVLI")
  aadd(sqlCAMPO,"ACUP01.CUPQDE")

  aadd(sqlRELATION,{"ACUP01","ACUP01.CUPEMP","ACUP00.CUPEMP"})
  aadd(sqlRELATION,{"","ACUP01.CUPNUM","ACUP00.CUPNUM"})
  aadd(sqlRELATION,{"","ACUP01.CUPSER","ACUP00.CUPSER"})
  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","ACUP01.CUPMAT"})
  aadd(sqlRELATION,{"AFIS00",str(ME_EMP,2,0),"AFIS00.FISEMP"})
  aadd(sqlRELATION,{"","AFIS00.FISNOV","ACUP00.CUPNATN"})
  aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ACUP00.CUPCLI"})

  aadd(sqlCHAVE,"ACUP00.CUPDTE BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
  aadd(sqlCHAVE,"ACUP00.CUPEMP = " + str(ME_EMP, 2, 0))
  aadd(sqlCHAVE,"ACUP00.CUPCAN not in ('Z','X','C')")

*  aadd(sqlCHAVE,"ACUP00.NFSNATN <> 5.929")
*  aadd(sqlCHAVE,"ANFS00.NFSLIS <> 'N'")
*  aadd(sqlCHAVE,"ANFS00.NFSCPG < 3 or ANFS00.NFSCPG > 24")


  if M_REGIAO > 0
    aadd(sqlCHAVE,"ACLI00.CLIVEN = " + str(M_REGIAO,3))
  endif

  if !empty(M_CLITIP)
    aadd(sqlCHAVE,"ACLI00.CLITIP IN (" + M_CLITIP + ")")
  endif

  if M_NFSCLI > 0
    aadd(sqlCHAVE,"ACUP00.CUPCLI = " + str(M_NFSCLI, 5, 0))
  endif

  if M_NFSFOR > 0
    aadd(sqlCHAVE,"APCA00.PCAFOR = " + str(M_NFSFOR, 5, 0))
  endif
  sqlrelation()


        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

            M_MESANO = strzero(month(ACUP00->CUPDTE),2) + strzero(year(ACUP00->CUPDTE),4)

            select ANFS02
     
            if M_QUEBRA == "S"     
              dbseek(str(ACUP00->CUPEMP, 2, 0) + str(ACUP00->CUPCLI, 7, 0) + M_MESANO + str(ACUP00->CUPMAT, 6, 0))
            else
              dbseek(str(ACUP00->CUPEMP, 2, 0) + str(ACUP00->CUPCLI, 7, 0) + str(ACUP00->CUPMAT, 6, 0))
            endif

            if eof()
              append blank         
              replace NFSEMP with ACUP00->CUPEMP
              replace NFSCLI with ACUP00->CUPCLI
              replace CLITIP with ACUP00->CLITIP
              replace NFSMAT with ACUP00->CUPMAT
              replace NFSDES with ACUP00->PCADES
              replace MESANO with M_MESANO
            endif

            replace NFSQDE with NFSQDE + ACUP00->CUPQDE
            replace NFSULC with ACUP00->CUPDTE

            replace NFSVLI with NFSVLI + ACUP00->CUPLIQ
            replace NFSUQT with ACUP00->CUPQDE
            replace NFSNUM with ACUP00->CUPNUM
            replace NFSSER with ACUP00->CUPSER

            replace NFSVIS with NFSVIS + ACUP00->CUPLIQ
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

        M_IMPRE = imprelaser()

        if M_IMPRE = "N"
          select ANFS02
          use
          return ""
        endif

        nTAMLIN = 66

        if M_IMPRE == "L"
          nTAMLIN = 66
        else
          if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
            ?? chr(15)                        && comprime
          endif
        endif

        store  0 to PG, LN   ,;
                    M_TOTVIS ,;
                    M_TOTPRZ ,;
                    M_CLIVIS ,;
                    M_CLIPRZ ,;
                    M_SOMPER ,;
                    M_CLIVIS ,;
                    M_CLIPRZ ,;
                    P_CLIVIS ,;
                    P_CLIPRZ ,;
                    T_CLIVIS ,;
                    T_CLIPRZ ,;
                    M_CLIANT
          
        
        select ANFS02

        if M_QUEBRA == "S"
          set order to 5
        else
          set order to 6
//          set order to 3
        endif

        M_MESANO = MESANO
        M_TIPCLI = ""

        go top
                 
        cab_nfsb()
        select ANFS02

        do while !eof() 
               
          if LN > nTAMLIN
            cab_nfsb()
            select ANFS02
          endif


          if M_QUEBRA == "S"
            if MESANO != M_MESANO
              if (M_CLIVIS + M_CLIPRZ) > 0
                if LN > 58
                  cab_nfsb()   
                  select ANFS02
                endif

                ? space(02) 
                ?? "SUB-TOTAL PERIODO. . . . . . .      VISTA: "
                ?? transform(P_CLIVIS,"@E ###,###,###.##")
                ?? "         PRAZO: "
                ?? transform(P_CLIPRZ,"@E ###,###,###.##")
                ?? "      TOTAL: "
                ?? transform((P_CLIVIS + P_CLIPRZ),"@E ###,###,###.##")
                ? replicate("-", 96)
                LN += 2
              endif

              if LN > nTAMLIN
                cab_nfsb()   
                select ANFS02
              endif

              M_MESANO = MESANO
              P_CLIVIS = 0
              P_CLIPRZ = 0
            endif       
          endif

          if NFSCLI != M_CLIANT
            if (M_CLIVIS + M_CLIPRZ) > 0
              if LN > nTAMLIN-2
                cab_nfsb()
                select ANFS02
              endif

              ? space(02) 
              ?? "TOTAL CLIENTE . . . . . . . .                                           TOTAL: "
              ?? transform((M_CLIVIS + M_CLIPRZ),"@E ###,###,###.##")
              ? replicate("=", 96)
              LN = LN + 2
            endif

            if LN > nTAMLIN
              cab_nfsb()
              select ANFS02
            endif

            if !M_CLITIP == ANFS02->CLITIP 
              if (T_CLIVIS + T_CLIPRZ) > 0
                if LN > 58
                  cab_nfsb()   
                  select ANFS02

                endif 

                ? space(02) 
                ?? "TOTAL "
                for A = 1 to len(aTIPCLI)
                 if substr(aTIPCLI[A],3,1) == M_CLITIP
                   ?? substr(aTIPCLI[A],3,30)
                  endif
                next
                ?? "                                    TOTAL: "
                ?? transform((T_CLIVIS + T_CLIPRZ),"@E ###,###,###.##")
                ? replicate("=", 96)
                T_CLIVIS = 0
                T_CLIPRZ = 0
                LN += 2
              endif

              ? " TIPO DE CLIENTE: " 
              for A = 1 to len(aTIPCLI)
               if substr(aTIPCLI[A],3,1) == ANFS02->CLITIP
                 ?? substr(aTIPCLI[A],3,30)
                endif
              next
              ?
              M_CLITIP = ANFS02->CLITIP
              LN += 2
            endif

            M_CLIANT = NFSCLI
            M_CLIVIS = 0
            M_CLIPRZ = 0

            valorescli(NFSCLI)

            select ANFS02

            ? "* CLI: "
            ?? str(NFSCLI, 7, 0)
            ?? " "
            ?? pad(zCLINOM,30)
            ?? " "
            ?? pad(zCLIMUN3,20)
            ?? " "
            ?? zCLIUF3 
            ?? " "
            ?? zCLITEL3
            ?
            LN = LN + 2
          endif       

*         valorespro(ANFS02->NFSMAT)

          ? " " 
          ?? transform(str(NFSMAT, 6, 0),"@R 999999")
          ?? " "
          ?? pad(NFSDES, 40)
          ?? " "
          ?? str(NFSNUM, 6, 0)
          ?? " "
          ?? NFSSER
          ?? " "
          ?? transform(NFSVLI/NFSQDE,"@E@Z ####,###.##")
          ?? " " 
          ?? str(NFSQDE, 8, 0)
          ?? " "
          ?? transform(NFSVLN,"@E@Z ####,###,###.##")

          LN++
                                
          M_CLIVIS = M_CLIVIS + NFSVIS
          M_CLIPRZ = M_CLIPRZ + NFSPRZ
          P_CLIVIS = P_CLIVIS + NFSVIS
          P_CLIPRZ = P_CLIPRZ + NFSPRZ
          M_TOTVIS = M_TOTVIS + NFSVIS
          M_TOTPRZ = M_TOTPRZ + NFSPRZ
          T_CLIVIS = T_CLIVIS + NFSVIS
          T_CLIPRZ = T_CLIPRZ + NFSPRZ

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

      if M_QUEBRA == "S"
        if (P_CLIVIS + P_CLIPRZ) > 0
          if LN > nTAMLIN-2
            cab_nfsb()   
            select ANFS02

          endif 

          ? space(02) 
          ?? "SUB-TOTAL PERIODO . . . . . . .                                           TOTAL: "
          ?? transform((P_CLIVIS + P_CLIPRZ),"@E ###,###,###.##")
          ? replicate("-", 96)
          LN = LN + 2
        endif

        if LN > nTAMLIN
          cab_nfsb()   
          select ANFS02
        endif
      endif

      if (M_CLIVIS + M_CLIPRZ) > 0
        ? space(02) 
        ?? "TOTAL CLIENTE . . . . . . . .                                           TOTAL: "
        ?? transform((M_CLIVIS + M_CLIPRZ),"@E ###,###,###.##")
      endif

              if (T_CLIVIS + T_CLIPRZ) > 0
                if LN > 58
                  cab_nfsb()   
                  select ANFS02
              endif
                ? replicate("=", 96)
                ? space(02) 
                ?? "TOTAL "
                for A = 1 to len(aTIPCLI)
                 if substr(aTIPCLI[A],3,1) == M_CLITIP
                   ?? substr(aTIPCLI[A],3,30)
                  endif
                next
                ?? "                                    TOTAL: "
                ?? transform((T_CLIVIS + T_CLIPRZ),"@E ###,###,###.##")
                ? replicate("=", 96)
                T_CLIVIS = 0
                T_CLIPRZ = 0
                LN += 2
              endif

      ? space(02) 
       ?? "TOTAL GERAL . . . . . . . . .                                           TOTAL: "
        ?? transform((M_TOTVIS + M_TOTPRZ),"@E ###,###,###.##")

    if !M_IMPRE $ "AL"
      eject
    else
      ?
    endif

desliga1(96)

select ANFS02
use

return ""

*****************
function CAB_NFSB
*****************

PG++

if PG > 1
  if M_IMPRE == "L"
    ?
  endif
  eject
endif

if M_REGIAO = 4
  ? cent_cab(AEMP00->EMPFAN,"RELACAO ANALITICA POR CLIENTE","REGIAO: PRUDENTE",96) 
else
  if M_REGIAO = 5
    ? cent_cab(AEMP00->EMPFAN,"RELACAO ANALITICA POR CLIENTE","REGIAO: MARILIA",96) 
  else
    if M_REGIAO = 10
      ? cent_cab(AEMP00->EMPFAN,"RELACAO ANALITICA POR CLIENTE","REGIAO: ARACATUBA",96) 
    else
      ? cent_cab(AEMP00->EMPFAN,"RELACAO ANALITICA POR CLIENTE","REGIAO: TODAS",96) 
    endif
  endif
endif
  
? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),96) 
? "*------*----------------------------------------*------*--*-----------*--------*---------------*"
? "* PROD *        DESCRICAO DO PRODUTO            * NFS  *SE* ULT PRECO *QT TOTAL* TOTAL VENDIDO *"
? "*------*----------------------------------------*------*--*-----------*--------*---------------*"
*   999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 XX ####,###.## 99999.99 ####,###,###.## 

LN = 5

if M_NFSFOR > 0
  BUSCAREGISTRO("AFOR00",1,{str(M_NFSFOR,7,0)},"SELECT")
  ? " FORNECEDOR -> "
  ?? AFOR00->FORNOM
  ?
  LN += 2
endif

return ""

*****************
function LISNFS_C                      && relacao de analitica por municipio
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
                   
select 0         && nfs temporario

M_IND = ""
M_INDA = ""
M_INDB = ""
acha_livre()

   rodape("ANALITICO","CLIENTE",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP)

    store date() to M_DATA1 ,;
                    M_DATA2

    store 0      to M_NFSCLI,;
                    M_NFSCLI1,;
                    M_CODINI,;
                    M_CODFIN

    store space(20) to M_CLIMUN

     M_MOEDA = "R"

     sombra(14, 35, 16, 72,_SOMBRA_)
     set color to GR/W
       @ 14, 35 say   "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 15, 35 say   "³Periodo Inicial:          a         ³" 
       @ 16, 35 say   "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
     set color to 

     SetColor(_COREDICAO_)
     @ 15, 53 get     M_DATA1
     @ 15, 64 get     M_DATA2
     read

     set key -3 to 
     set key -4 to 

     if lastkey() = 27
       select ANFS02
       use
       return ""
     endif

     store 0 to M_TOTGER

     select ANFS02

     if !flock()
       msg("* * * (ANFS02) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(NFSEMP, 2, 0) + str(NFSNUM,6,0)  tag 1 to &M_IND

     set index to &M_IND       
  
     select ANFS00

     go top

        set order to 2 
         
        dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1), .t.)

        if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2) .or. str(NFSEMP, 2, 0) + dtos(NFSDTE) < str(ME_EMP, 2, 0) + dtos(M_DATA1)
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          select ANFS02
          use
          return ""
        endif
                
        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
            exit
          endif 

          if !NFSNATN $ "5.933#6.933"
            skip
            loop
          endif

          valorescli(NFSCLI)           

          if NFSCAN = "C" 
            skip
            loop
          endif

          select ANFS01

          dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER,.t.)

          do while !eof()

            if str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSNUM, 6, 0) + ANFS01->NFSSER > str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER
              exit
            endif

            valorespro(ANFS01->NFSMAT)     

            select ANFS02
     
            seek str(ANFS01->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0)

            if eof()
              append blank         
              replace NFSEMP with ANFS01->NFSEMP
              replace NFSNUM with ANFS00->NFSNUM 
              replace NFSCLI with ANFS00->NFSCLI
              replace NFSDTE with ANFS00->NFSDTE 
            endif

            replace NFSVLN with NFSVLN + ANFS01->NFSLIQ

            M_TOTGER = M_TOTGER + ANFS01->NFSLIQ

            select ANFS01

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                select ANFS02
                use
                return ""
              endif
            endif

            skip
 
          enddo
 
          select ANFS00
 
          skip

        enddo
  
        M_IMPRE = impresn()

        if M_IMPRE = "N"
          select ANFS02
          use
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
                    M_SOMPER 

        store space(20) to M_MUNANT
          
        select ANFS02
        go top
                 
        do while !eof()
                              
            store PG + 1 to  PG 

            if PG > 1
              eject
            endif

            ?? chr(18)
            ?? chr(27) + "E"
            ? AEMP00->EMPNOM
            ? alltrim(AEMP00->EMPEND) + " - " + alltrim(AEMP00->EMPBAI)
            ? strzero(AEMP00->EMPCEP,5) + "-" + strzero(AEMP00->EMPCCE,3) + "  " + AEMP00->EMPMUN
            ? "Fone: " + AEMP00->EMPTEL
            ? 
            ? "RELACAO DE NOTAS FISCAIS DE SERVICO"
            ?? "  -  PERIODO DE " + dtoc(M_DATA1) + " a " + dtoc(M_DATA2)
            ?? chr(27) + "F"
            ?? chr(27) + "M"
            ? "+--------+------+-------------------+----------------------------------------+--------------+"
            ? "| DATA   | Nr.NF|  CPF/CNPJ         |                                        |  VALOR       |"
            ? "+--------+------+-------------------+----------------------------------------+--------------+"

            store 9 to LN
  
            do while !eof() 
               
              if LN > 60
                exit
              endif 

              valorescli(NFSCLI)
            
              ? " " 
               ?? NFSDTE
               ?? " "
               ?? str(NFSNUM,6)
               ?? " "
               if len(rtrim(zCLICGC2)) = 11
                 ?? padl(alltrim(transform(zCLICGC2,"@R 999.999.999/99")),19)
               else
                 ?? padl(right(transform(zCLICGC2,"@R 999.999.999/9999-99"),18),19)
               endif
               ?? " "
               ?? zCLINOM
               ?? " "
               ?? transform(NFSVLN,"@E@Z ###,###,###.##")

            LN = LN + 1
                                
            M_VENVIS = M_VENVIS + NFSVLN

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

      ? replicate("-", 93)

      if (M_VENVIS + M_VENPRZ) > 0
        ? space(43) 
        ?? "        TOTAL DO PERIODO  . . . . ."
        ?? transform(M_VENVIS,"@E ###,###,###.##")
      endif 

      ? replicate("-", 93)

    eject

    unlock all

    select ANFS02
    use

desliga1()

return ""

*****************
function LISNFS_D                      && relacao de notas por vendedor    
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
                   
select 0         && nfs temporario

M_IND = ""
M_INDA = ""
M_INDB = ""
acha_livre()

    rodape("NOTAS","VENDEDOR",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP)

    store date() to M_DATA1 ,;
                    M_DATA2


    store 0      to M_NFSVEN,;
                    M_NFSCLI1,;
                    M_NFSCLI,;
                    M_CODINI,;
                    M_CODFIN

     M_MOEDA = "R" 

     sombra(14, 35, 19, 72,_SOMBRA_)
     set color to GR/W
       @ 14, 35 say   "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 15, 35 say   "³Periodo Inicial:          a         ³" 
       @ 16, 35 say   "³       Vendedor:                    ³" 
       @ 17, 35 say   "³     Fornecedor:          a         ³" 
       @ 18, 35 say   "³          Moeda:                    ³" 
       @ 19, 35 say   "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
     set color to 

     SetColor(_COREDICAO_)
     @ 15, 53 get     M_DATA1
     @ 15, 64 get     M_DATA2
     @ 16, 53 get     M_NFSVEN picture "###"
     @ 17, 53 get     M_NFSCLI1 picture "#######" valid vernfs25()
     @ 17, 64 get     M_CODFIN picture "#######"
     @ 18, 53 get     M_MOEDA  picture "@!"  valid(M_MOEDA $ "RD")
     read

     if lastkey() = 27
       select ANFS02
       use
       return ""
     endif

     store 0 to M_TOTGER

     select ANFS02

     if !flock()
       msg("* * * (ANFS02) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(NFSEMP, 2, 0) + str(NFSVEN, 3, 0) + str(NFSNUM, 6, 0) + NFSSER + dtos(NFSDTE) tag 1 to &M_IND
     set index to &M_IND
  
     select ANFS00

     go top

        set order to 2 
         
        dbseek(str(ME_EMP, 2) + dtos(M_DATA1), .t.)

        if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2) .or. str(NFSEMP, 2, 0) + dtos(NFSDTE) < str(ME_EMP, 2, 0) + dtos(M_DATA1)
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          select ANFS02
          use
          return ""
        endif
                
        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
            exit
          endif 
           
          if M_NFSVEN > 0
            if NFSVEN != M_NFSVEN
              skip
              loop
            endif
          endif

          AVEN00->(dbseek(str(ANFS00->NFSVEN, 3, 0))) 

          if !M_LOGPRV == "S"
            if !alltrim(M_LOGNOM) $ AVEN00->VENNOM
              skip
              loop
            endif
          endif

          if NFSCAN = "C" 
            skip
            loop
          endif

          if NFSCPG > 2 
            if NFSCPG <= 20
              skip
              loop
            endif
          endif       
  
          select ANFS01

          dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER, .t.)

          do while !eof()

            if str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSNUM, 6, 0) + ANFS01->NFSSER > str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER
              exit
            endif

            valorespro(ANFS01->NFSMAT)     

            if (M_CODINI + M_CODFIN) > 0
              if zPCAFOR < M_CODINI .or. zPCAFOR > M_CODFIN
                skip
                loop
              endif
            endif

            select ANFS02
     
            append blank         

            replace NFSEMP with ANFS01->NFSEMP
            replace NFSVEN with ANFS00->NFSVEN
            replace NFSNUM with ANFS00->NFSNUM
            replace NFSSER with ANFS00->NFSSER
            replace NFSDTE with ANFS00->NFSDTE
            replace NFSCLI with ANFS00->NFSCLI
            replace NFSMAT with ANFS01->NFSMAT

            replace NFSQDE with NFSQDE + ANFS01->NFSQDE

            if ANFS00->NFSCPG = 1 .or. ANFS00->NFSCPG = 2
              replace NFSVIS with NFSVIS + ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP
              replace NFSVLN with NFSVLN + ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP
            endif            

            if ANFS00->NFSCPG > 20
              replace NFSPRZ with NFSPRZ + ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP
              replace NFSVLN with NFSVLN + ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP
            endif            

            M_TOTGER = M_TOTGER + ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP

            select ANFS01

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                select ANFS02
                use
                return ""
              endif
            endif

            skip
 
          enddo
 
          select ANFS00
 
          skip

        enddo
  
        M_IMPRE = impresn()

        if M_IMPRE = "N"
          select ANFS02
          use
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        store  0 to PG, LN   ,;
                    M_TOTREA ,;
                    M_TOTDOL ,;
                    M_REAVEN ,;
                    M_DOLVEN ,;
                    M_SOMPER ,;
                    M_VENANT

        store "  " to M_NOTSER
          
        select ANFS02

        set order to 2

        go top
                 
        do while !eof()
                              
            store PG + 1 to  PG 

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO DE VENDAS/NOTAS POR VENDEDOR - " + iif(M_MOEDA="R","REAL ","DOLAR"),"EAGRO21",132) 
            ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
            ? "*-----*--*--------*------------------------------*------*----------------------------*------*------*-----------*-----------*-------*"
            ? "* NOTA*SE*EMISSAO * C L I E N T E                * PRO  *     D E S C R I C A O      * DOSE * QTDE * VALOR R$  * VALOR U$  * %SFAT *"
            ? "*-----*--*--------*------------------------------*------*----------------------------*------*------*-----------*-----------*-------*"
*              ## 9999 - NOME DO VENDEDOR
*
*              999999 XX 99/99/99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXX 99,999 999999 ####,###.## ####,###.## ####.## 
*                                                                999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXX 99,999 999999 ####,###.## ####,###.## ####.##
*                                                                999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXX 99,999 999999 ####,###.## ####,###.## ####.##


            store 5 to LN
  
            do while !eof() 
               
              if  LN > 60
                exit
              endif 

              AVEN00->(dbseek(str(ANFS02->NFSVEN, 3, 0)))

             if NFSVEN != M_VENANT
                if M_REAVEN > 0
                  ? space(68) 
                    ?? "TOTAL DO VENDEDOR . . . . . ."
                    ?? transform(M_REAVEN,"@E ###,###,###.##")
                    ?? transform(M_DOLVEN,"@E #####,###.##")
                  ? replicate("-", 132)
                  LN = LN + 2
                 endif
                 M_VENANT = NFSVEN
                 M_REAVEN = 0
                 M_DOLVEN = 0
                ? "***** VENDEDOR: "
                 ?? str(NFSVEN, 3, 0)
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

              valorespro(ANFS02->NFSMAT)     
              valorescli(NFSCLI)
            
              if str(NFSNUM, 6, 0) + NFSSER == M_NOTSER
                ? space(49)
              else 
                ?
                ? str(NFSNUM, 6, 0)
                  ?? " "
                  ?? NFSSER
                  ?? " "
                  ?? NFSDTE
                  ?? " "
                  ?? pad(zCLINOM, 30)
                  M_NOTSER = str(NFSNUM, 6, 0) + NFSSER
                  LN = LN + 1
              endif
               ?? str((NFSMAT * .0001), 7, 4)
               ?? " "
               ?? pad(zPCADES, 28)
               ?? " "
               ?? transform((NFSQDE*zPCADOS),"@E ##,###")
               ?? " "
               ?? transform(NFSQDE,"@E ##,###")
               ?? " "
               ?? transform(NFSVLN,"@E@Z ####,###.##")
               ?? " "
               ?? transform(NFSVLN,"@E@Z ####,###.##")
               ?? " "
               ?? transform(((NFSVLN/M_TOTGER) * 100),"####.##")

            LN = LN + 1
                                
            M_REAVEN = M_REAVEN + NFSVLN
            M_DOLVEN = M_DOLVEN + NFSVLN
            M_TOTREA = M_TOTDOL + NFSVLN
            M_TOTDOL = M_TOTDOL + NFSVLN

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

      if M_REAVEN > 0
        ? space(68) 
         ?? "TOTAL DO VENDEDOR . . . . . ."
         ?? transform(M_REAVEN,"@E ###,###,###.##")
         ?? transform(M_DOLVEN,"@E #####,###.##")
      endif 
      ? replicate("-", 132)
      ? space(68) 
        ?? "TOTAL GERAL . . . . . . . . ."
        ?? transform(M_TOTREA,"@E ###,###,###.##")
        ?? transform(M_TOTDOL,"@E #####,###.##")

    eject

    select ANFS02
    use

    unlock all

desliga1()
return ""

*****************
function LISNFS_E                      && relacao de sintetica por vendedor
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
                   
select 0         && nfs temporario
                   
M_IND = ""
M_INDA = ""
M_INDB = ""
acha_livre()

    rodape("SINTETICO","VENDEDOR",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP)

    store date() to M_DATA1 ,;
                    M_DATA2


    store 0      to M_NFSVEN,;
                    M_NFSCLI1,;
                    M_NFSCLI,;
                    M_CODINI,;
                    M_CODFIN

     M_MOEDA = "R" 

     sombra(14, 35, 19, 72,_SOMBRA_)
     set color to GR/W
       @ 14, 35 say   "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 15, 35 say   "³Periodo Inicial:          a         ³" 
       @ 16, 35 say   "³       Vendedor:                    ³" 
       @ 17, 35 say   "³     Fornecedor:          a         ³" 
       @ 18, 35 say   "³          Moeda:                    ³" 
       @ 19, 35 say   "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
     set color to 

     SetColor(_COREDICAO_)
     @ 15, 53 get     M_DATA1
     @ 15, 64 get     M_DATA2
     @ 16, 53 get     M_NFSVEN picture "###"
     @ 17, 53 get     M_NFSCLI1 picture "#######" valid vernfs25()
     @ 17, 64 get     M_CODFIN picture "#######"
     @ 18, 53 get     M_MOEDA  picture "@!"  valid(M_MOEDA $ "RD")
     read

     if lastkey() = 27
       select ANFS02
       use
       return ""
     endif

     store 0 to M_TOTGER

     select ANFS02

     if !flock()
       msg("* * * (ANFS02) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(NFSEMP, 2, 0) + str(NFSVEN, 3, 0)   tag 1 to &M_IND
     index on str(NFSEMP, 2, 0) + str(NFSVLN, 14, 2)  tag 2 to &M_IND

     set index to &M_IND
  
     select ANFS00

     go top

        set order to 2 
         
        dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1), .t.)

        if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2) .or. str(NFSEMP, 2, 0) + dtos(NFSDTE) < str(ME_EMP, 2, 0) + dtos(M_DATA1)
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          select ANFS02
          use
          return ""
        endif
                
        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
            exit
          endif 
           
          if M_NFSVEN > 0
            if NFSVEN != M_NFSVEN
              skip
              loop
            endif
          endif

          AVEN00->(dbseek(str(ANFS00->NFSVEN, 3, 0))) 

          if !M_LOGPRV == "S"
            if !alltrim(M_LOGNOM) $ AVEN00->VENNOM
              skip
              loop
            endif
          endif

          if NFSCAN = "C" 
            skip
            loop
          endif

          if NFSCPG > 2 
            if NFSCPG <= 20
              skip
              loop
            endif
          endif       

          select ANFS01

          dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER, .t.)

          do while !eof()

            if str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSNUM, 6, 0) + ANFS01->NFSSER > str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER
              exit
            endif

            valorespro(ANFS01->NFSMAT)     

            if (M_CODINI + M_CODFIN) > 0
              if zPCAFOR < M_CODINI .or. zPCAFOR > M_CODFIN
                skip
                loop
              endif
            endif

            select ANFS02
     
            seek str(ANFS01->NFSEMP, 2, 0) + str(ANFS00->NFSVEN, 3, 0)

            if eof()
              append blank         
              replace NFSEMP with ANFS01->NFSEMP
              replace NFSVEN with ANFS00->NFSVEN
            endif

            replace NFSQDE with NFSQDE + ANFS01->NFSQDE

            if ANFS00->NFSCPG = 1 .or. ANFS00->NFSCPG = 2
              replace NFSVIS with NFSVIS + ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP
              replace NFSVLN with NFSVLN + ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP
            endif            

            if ANFS00->NFSCPG > 20
              replace NFSPRZ with NFSPRZ + calc_dol(ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP, ANFS00->NFSDTE)
              replace NFSVLN with NFSVLN + calc_dol(ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP, ANFS00->NFSDTE)
            endif            

            M_TOTGER = M_TOTGER + calc_dol(ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP, ANFS00->NFSDTE)

            select ANFS01

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                select ANFS02
                use
                return ""
              endif
            endif

            skip
 
          enddo
 
          select ANFS00
 
          skip

        enddo
  
        M_IMPRE = impresn()

        if M_IMPRE = "N"
          select ANFS02
          use
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
          
        select ANFS02

        set order to 2

        go bottom
                 
        do while !bof()
                              
            store PG + 1 to  PG 

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"VENDAS SINTETICA POR VENDEDOR - " + iif(M_MOEDA="R","REAL ","DOLAR"),"EAGRO21",132) 
            ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
            ? "*-------*--------------------------------------------------*------------------*------------------*------------------*------*-------*"
            ? "*CODIGO *        NOME DO VENDEDOR                          *    A VISTA       *     A PRAZO      *   TOTAL VENDIDO  *% SFAT* REGUA *"
            ? "*-------*--------------------------------------------------*------------------*------------------*------------------*------*-------*"
*               99999.9 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ###,###,###,###.## ###,###,###,###.## ###,###,###,###.## ###,## ###,###

            store 5 to LN
  
            do while !bof() 
               
              if  LN > 60
                exit
              endif 

              AVEN00->(dbseek(str(ANFS02->NFSVEN, 3, 0)))
         
              ? " " 
               ?? str(NFSVEN, 7, 0)
               ?? " "
               ?? pad(AVEN00->VENNOM, 50)
               ?? " "
               ?? transform(NFSVIS,"@E@Z ###,###,###,###.##")
               ?? " " 
               ?? transform(NFSPRZ,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(NFSVLN,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(((NFSVLN/M_TOTGER) * 100),"###.##")
               ?? " "
      
               M_SOMPER = M_SOMPER + ((NFSVLN/M_TOTGER) * 100)
              
               ?? transform(M_SOMPER,"####.##")

            LN = LN + 1
                                
            M_TOTVIS = M_TOTVIS + NFSVIS
            M_TOTPRZ = M_TOTPRZ + NFSPRZ

            skip - 1
         
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
      ? space(31) 
        ?? "TOTAL GERAL . . . . . . . . ."
        ?? transform(M_TOTVIS,"@E ###,###,###,###.##")
        ?? " "
        ?? transform(M_TOTPRZ,"@E ###,###,###,###.##")
        ?? " "
        ?? transform((M_TOTVIS + M_TOTPRZ),"@E ###,###,###,###.##")

    eject

    unlock all

    select ANFS02
    use

desliga1()
return ""

*****************
function LISNFS_F                      && relacao de sintetica por cliente 
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
                   
select 0         && nfs temporario

M_IND = ""
M_INDA = ""
M_INDB = ""
acha_livre()

    rodape("SINTETICO","CLIENTE",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP)

    store date() to M_DATA1 ,;
                    M_DATA2


    store 0      to M_DUPCLI,;
                    M_NFSCLI1,;
                    M_NFSCLI,;
                    M_CODINI,;
                    M_CODFIN

     M_MOEDA = "R" 
     M_CLITIP = " "

     sombra(14, 35, 19, 72,_SOMBRA_)
     set color to GR/W
       @ 14, 35 say   "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 15, 35 say   "³Periodo Inicial:          a         ³" 
       @ 16, 35 say   "³        Cliente:                    ³" 
       @ 17, 35 say   "³     Fornecedor:                    ³" 
       @ 18, 35 say   "³   Tipo Cliente:                    ³" 
       @ 19, 35 say   "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
     set color to 

     SetColor(_COREDICAO_)
     @ 15, 53 get     M_DATA1
     @ 15, 64 get     M_DATA2
     @ 16, 53 get     M_DUPCLI picture "#######"
     @ 17, 53 get     M_NFSCLI1 picture "#######"
     read

     if lastkey()=27
       select ANFS02
       use
       return ""
     endif

     SetColor(_COREDICAO_)
     @ 18, 53 get     M_CLITIP picture "@!" valid vercli02(.t.)
     read

     store 0 to M_TOTGER

     select ANFS02

     if !flock()
       msg("* * * (ANFS02) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(NFSEMP, 2, 0) + str(NFSCLI, 7, 0)   tag 1 to &M_IND
     index on str(NFSEMP, 2, 0) + str(NFSVLN, 14, 2)  tag 2 to &M_IND

     set index to &M_IND
  
     select ANFS00

     go top

        set order to 2 
         
        dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1), .t.)

        if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2) .or. str(NFSEMP, 2, 0) + dtos(NFSDTE) < str(ME_EMP, 2, 0) + dtos(M_DATA1)
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          select ANFS02
          use
          return ""
        endif
                
        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
            exit
          endif 

          if !empty(M_CLITIP)
            valorescli(NFSCLI)
            if !zCLITIP == M_CLITIP
              skip
              loop
            endif
          endif
           
          if M_DUPCLI > 0
            if NFSCLI != M_DUPCLI
              skip
              loop
            endif
          endif

          if NFSCAN = "C" 
            skip
            loop
          endif

          if NFSCPG > 2 
            if NFSCPG <= 24
              skip
              loop
            endif
          endif       

          select ANFS01

          dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER, .t.)

          do while !eof()

            if str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSNUM, 6, 0) + ANFS01->NFSSER > str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER
              exit
            endif

            valorespro(ANFS01->NFSMAT)     

            if M_NFSCLI1 > 0
              if !zPCAFOR == M_NFSCLI1
                skip
                loop
              endif
            endif

            select ANFS02
     
            seek str(ANFS01->NFSEMP, 2, 0) + str(ANFS00->NFSCLI, 7, 0)

            if eof()
              append blank         
              replace NFSEMP with ANFS01->NFSEMP
              replace NFSCLI with ANFS00->NFSCLI
            endif

            replace NFSQDE with NFSQDE + ANFS01->NFSQDE

            if ANFS00->NFSCPG = 1 .or. ANFS00->NFSCPG = 2
              replace NFSVIS with NFSVIS + ANFS01->NFSLIQ + ANFS01->NFSVIP
              replace NFSVLN with NFSVLN + ANFS01->NFSLIQ + ANFS01->NFSVIP
            else
              replace NFSPRZ with NFSPRZ + ANFS01->NFSLIQ + ANFS01->NFSVIP
              replace NFSVLN with NFSVLN + ANFS01->NFSLIQ + ANFS01->NFSVIP
            endif            

            M_TOTGER = M_TOTGER + (ANFS01->NFSLIQ + ANFS01->NFSVIP)

            select ANFS01

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                select ANFS02
                use
                return ""
              endif
            endif

            skip
 
          enddo
 
          select ANFS00
 
          skip

        enddo
  
        M_IMPRE = impresn()

        if M_IMPRE = "N"
          select ANFS02
          use
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
          
        select ANFS02

        set order to 2

        go bottom
                 
        do while !bof()
                              
            store PG + 1 to  PG 

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"VENDAS SINTETICA POR CLIENTE - " + iif(M_MOEDA="R","REAL ","DOLAR"),"EAGRO21",132) 
            ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
            ? "*-------*------------------------------*----------------*--*------------------*------------------*------------------*------*-------*"
            ? "*CODIGO *        NOME DO CLIENTE       *  MUNICIPIO     *UF*    A VISTA       *     A PRAZO      *   TOTAL VENDIDO  *% SFAT* REGUA *"
            ? "*-------*------------------------------*----------------*--*------------------*------------------*------------------*------*-------*"
*               99999.9 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXX XX ###,###,###,###.## ###,###,###,###.## ###,###,###,###.## ###,## ###,###

            store 5 to LN
  
            do while !bof() 
               
              if  LN > 60
                exit
              endif 

              valorescli(NFSCLI)
         
              ? " " 
               ?? str(NFSCLI, 7, 0)
               ?? " "
               ?? pad(zCLINOM, 30)
               ?? " "
               ?? pad(zCLIMUN2, 16)
               ?? " "
               ?? pad(zCLIUF2, 2)
               ?? " "
               ?? transform(NFSVIS,"@E@Z ###,###,###,###.##")
               ?? " " 
               ?? transform(NFSPRZ,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(NFSVLN,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(((NFSVLN/M_TOTGER) * 100),"###.##")
               ?? " "
      
               M_SOMPER = M_SOMPER + ((NFSVLN/M_TOTGER) * 100)
              
               ?? transform(M_SOMPER,"####.##")

            LN = LN + 1
                                
            M_TOTVIS = M_TOTVIS + NFSVIS
            M_TOTPRZ = M_TOTPRZ + NFSPRZ

            skip - 1
         
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
      ? space(31) 
        ?? "TOTAL GERAL . . . . . . . . ."
        ?? transform(M_TOTVIS,"@E ###,###,###,###.##")
        ?? " "
        ?? transform(M_TOTPRZ,"@E ###,###,###,###.##")
        ?? " "
        ?? transform((M_TOTVIS + M_TOTPRZ),"@E ###,###,###,###.##")

    eject

    unlock all

    select ANFS02
    use

desliga1()
return ""

*****************
function LISNFS_G                      && relacao de sintetica por cliente 
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

select 0         && nfs temporario

M_IND = ""
M_INDA = ""
M_INDB = ""
acha_livre()

    rodape("SINTETICO","MUNICIPIO",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP)

    store date() to M_DATA1 ,;
                    M_DATA2

    store 0      to M_DUPCLI,;
                    M_NFSCLI1,;
                    M_NFSCLI,;
                    M_CODINI,;
                    M_CODFIN

     M_MOEDA = "R" 

     store space(20) to M_CLIMUN

     sombra(14, 35, 19, 72,_SOMBRA_)
     set color to GR/W
       @ 14, 35 say   "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 15, 35 say   "³Periodo Inicial:          a         ³" 
       @ 16, 35 say   "³      Municipio:                    ³" 
       @ 17, 35 say   "³        Cliente:          a         ³"
       @ 18, 35 say   "³          Moeda:                    ³" 
       @ 19, 35 say   "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
     set color to 

     SetColor(_COREDICAO_)
     @ 15, 53 get     M_DATA1
     @ 15, 64 get     M_DATA2
     @ 16, 53 get     M_CLIMUN picture "@!@S19"
     @ 17, 53 get     M_NFSCLI1 picture "#######" valid vernfs25()
     @ 17, 64 get     M_CODFIN picture "#######"
     @ 18, 53 get     M_MOEDA  picture "@!"  valid(M_MOEDA $ "RD")
     read

     if lastkey() = 27
       select ANFS02
       use
       return ""
     endif

     store 0 to M_TOTGER

     select ANFS02

     if !flock()
       msg("* * * (ANFS02) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(NFSEMP, 2, 0) + NFSMUN              tag 1 to &M_IND
     index on str(NFSEMP, 2, 0) + str(NFSVLN, 14, 2)  tag 2 to &M_IND

     set index to &M_IND
  
     select ANFS00

     go top

        set order to 2 
         
        dbseek(str(ME_EMP, 2) + dtos(M_DATA1), .t.)

        if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2) .or. str(NFSEMP, 2, 0) + dtos(NFSDTE) < str(ME_EMP, 2, 0) + dtos(M_DATA1)
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          select ANFS02
          use
          return ""
        endif
                
        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
            exit
          endif 

          valorescli(NFSCLI)
           
          if !empty(M_CLIMUN)
            if !zCLIMUN2 == M_CLIMUN
              skip
              loop
            endif
          endif

          if NFSCAN = "C" 
            skip
            loop
          endif

          if NFSCPG > 2 
            if NFSCPG <= 20
              skip
              loop
            endif
          endif       

          select ANFS01

          dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER, .t.)

          do while !eof()

            if str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSNUM, 6, 0) + ANFS01->NFSSER > str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER
              exit
            endif

            valorespro(ANFS01->NFSMAT)     

            if (M_CODINI + M_CODFIN) > 0
              if zPCAFOR < M_CODINI .or. zPCAFOR > M_CODFIN
                skip
                loop
              endif
            endif

            select ANFS02
     
            seek str(ANFS01->NFSEMP, 2, 0) + ACLI00->CLIMUN2

            if eof()
              append blank         
              replace NFSEMP with ANFS01->NFSEMP
              replace NFSMUN with ACLI00->CLIMUN2
            endif

            replace NFSQDE with NFSQDE + ANFS01->NFSQDE

            if ANFS00->NFSCPG = 1 .or. ANFS00->NFSCPG = 2
              replace NFSVIS with NFSVIS + calc_dol(ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP, ANFS00->NFSDTE)
              replace NFSVLN with NFSVLN + calc_dol(ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP, ANFS00->NFSDTE)
            endif            

            if ANFS00->NFSCPG > 20
              replace NFSPRZ with NFSPRZ + calc_dol(ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP, ANFS00->NFSDTE)
              replace NFSVLN with NFSVLN + calc_dol(ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP, ANFS00->NFSDTE)
            endif            

            M_TOTGER = M_TOTGER + calc_dol(ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP, ANFS00->NFSDTE)

            select ANFS01

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                select ANFS02
                use
                return ""
              endif
            endif

            skip
 
          enddo
 
          select ANFS00
 
          skip

        enddo
  
        M_IMPRE = impresn()

        if M_IMPRE = "N"
          select ANFS02
          use
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
          
        select ANFS02

        set order to 2

        go bottom
                 
        do while !bof()
                              
            store PG + 1 to  PG 

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"VENDAS SINTETICA POR MUNICIPIO - " + iif(M_MOEDA="R","REAL ","DOLAR"),"EAGRO21",132) 
            ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
            ? "*----------------------------------------------------------*------------------*------------------*------------------*------*-------*"
            ? "*            M U N I C I P I O                             *    A VISTA       *     A PRAZO      *   TOTAL VENDIDO  *% SFAT* REGUA *"
            ? "*----------------------------------------------------------*------------------*------------------*------------------*------*-------*"
*               XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ###,###,###,###.## ###,###,###,###.## ###,###,###,###.## ###,## ###,###

            store 5 to LN
  
            do while !bof() 
               
              if  LN > 60
                exit
              endif 

              ? " " 
               ?? pad(NFSMUN, 58)
               ?? " "
               ?? transform(NFSVIS,"@E@Z ###,###,###,###.##")
               ?? " " 
               ?? transform(NFSPRZ,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(NFSVLN,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(((NFSVLN/M_TOTGER) * 100),"###.##")
               ?? " "
      
               M_SOMPER = M_SOMPER + ((NFSVLN/M_TOTGER) * 100)
              
               ?? transform(M_SOMPER,"####.##")

            LN = LN + 1
                                
            M_TOTVIS = M_TOTVIS + NFSVIS
            M_TOTPRZ = M_TOTPRZ + NFSPRZ

            skip - 1
         
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
      ? space(31) 
        ?? "TOTAL GERAL . . . . . . . . ."
        ?? transform(M_TOTVIS,"@E ###,###,###,###.##")
        ?? " "
        ?? transform(M_TOTPRZ,"@E ###,###,###,###.##")
        ?? " "
        ?? transform((M_TOTVIS + M_TOTPRZ),"@E ###,###,###,###.##")

    eject

    unlock all

    select ANFS02
    use

desliga1()
return ""

*****************
function LISNFS_H                      && vendas sintetica por produtos
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


select 0         && nfs temporario

M_IND = ""
M_INDA = ""
M_INDB = ""

acha_livre()

    rodape("SINTETICO","PRODUTO",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP)

    store date() to M_DATA1 ,;
                    M_DATA2


    store 0      to M_NFSMAT,;
                    M_NFSCLI1,;
                    M_NFSCLI,;
                    M_CODINI,;
                    M_CODFIN

     M_MOEDA = "R"
     M_TIPCL = "        "
     M_COMVEN = " "
     M_QUALEMP = 0
     aTIPCLI = { }

     nbox(12, 35, 19, 72,"W/W+",.t.)
     setcolor("B/W")
       @ 13, 36 say   "<1>ATLAS <2>Nutri <3>Todas:         "
       @ 14, 36 say   "<C>ompra ou <V>enda:                "
       @ 15, 36 say   "Periodo Inicial:          a         "
       @ 16, 36 say   "        Produto:                    "
       @ 17, 36 say   "     Fornecedor:                    "
*       @ 18, 36 say   "  Tipos Cliente:                    "
     SetColor(_COREDICAO_)
    @ 13, 64 get     M_QUALEMP picture "9" valid (M_QUALEMP > 0 .and. M_QUALEMP < 4)
    @ 14, 57 get     M_COMVEN picture "@!" valid M_COMVEN $ "CV"
    @ 15, 53 get     M_DATA1
    @ 15, 64 get     M_DATA2
    @ 16, 53 get     M_NFSMAT picture "######"  F2 color _CORF2_ funcao "sele_arquivo('APCA00')" retorno @M_NFSMAT
    @ 17, 53 get     M_NFSCLI1 picture "#######"  F2 color _CORF2_ funcao "sele_arquivo('AFOR00')" retorno @M_NFSCLI1
*   @ 18, 53 get     M_TIPCL  picture "@!"  valid(iif(empty(M_TIPCL), msg("* * * Informe os tipos de clientes ou (T)udo * * *"), .t.))
    read

     if lastkey() = 27
       select ANFS02
       use
       return ""
     endif

     M_CLITIP = ""

     if M_COMVEN == "V"
       vertip(.t.)
       M_CLITIP = ""
       for A = 1 to len(aTIPCLI)
         if left(aTIPCLI[A],1) == chr(247)
           M_CLITIP += aspas(substr(aTIPCLI[A],3,1))
           if A # len(aTIPCLI)
             M_CLITIP += ","
           endif
         endif
       next
     endif

     if right(M_CLITIP,1) == ","
       M_CLITIP = left(M_CLITIP,len(M_CLITIP)-1)
     endif
     
     store 0 to M_TOTGER

     select ANFS02

     if !flock()
       msg("* * * (ANFS02) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(NFSEMP, 2, 0) + str(NFSMAT, 6, 0)   tag 1 to &M_IND
     index on str(NFSEMP, 2, 0) + str(NFSVLN, 14, 2)  tag 2 to &M_IND

     set index to &M_IND 

**** Le as notas fiscais

     if M_COMVEN == "V"
       do case
         case M_QUALEMP = 1
           processa(1,"V")
         case M_QUALEMP = 2
           processa(10,"V")
         case M_QUALEMP = 3
           if AEMP00->EMPCGC == "037623347000109"
             processa(2,"V")
           else
             processa(1,"V")
             processa(10,"V")
           endif
       endcase
     else      // NOTAS DE ENTRADA
       do case
         case M_QUALEMP = 1
           processa(1,"C")
         case M_QUALEMP = 2
           processa(10,"C")
         case M_QUALEMP = 3
           if AEMP00->EMPCGC == "037623347000109"
             processa(2,"C")
           else
             processa(1,"C")
             processa(10,"C")
           endif
       endcase
     endif

*** Emite o relatorio
  
        M_IMPRE = imprelaser()

        if M_IMPRE = "N"
          select ANFS02
          use
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
          
        select ANFS02

        set order to 2

        go bottom
                 
        do while !bof()
                              
            PG++

            if PG > 1
              eject
            endif

            if M_COMVEN == "V" 
              ? cent_cab(AEMP00->EMPFAN,"VENDAS SINTETICA POR PRODUTOS - TIPOS: " + alltrim(M_TIPCL),"EAGRO21",132)
            else
              ? cent_cab(AEMP00->EMPFAN,"COMPRAS SINTETICA POR PRODUTOS - TIPOS: " + alltrim(M_TIPCL),"EAGRO21",132)
            endif

            ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132)
            ? "*-------*------------------------------*---*-------*-------*------------------*------------------*------------------*------*-------*"
            ? "*CODIGO *     D E S C R I C A O        *UNI* DOSE  *  QDE  *    A VISTA       *     A PRAZO      *   TOTAL VENDIDO  *% SFAT* REGUA *"
            ? "*-------*------------------------------*---*-------*-------*------------------*------------------*------------------*------*-------*"
*               9999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXX 999.999 999,999 ###,###,###,###.## ###,###,###,###.## ###,###,###,###.## ###,## ###,###

            store 5 to LN
  
            do while !bof() 
               
              if  LN > 60
                exit
              endif 

              valorespro(ANFS02->NFSMAT)     
              select ANFS02

              ? " " 
               ?? str(NFSMAT, 7, 0)
               ?? " "
               ?? pad(zPCADES, 30)
               ?? " "
               ?? pad(zPCAUNI, 03)
               ?? " "
               ?? transform(NFSQDE*zPCADOS,"@E ###,###")
               ?? " "
               ?? transform(NFSQDE,"@E ###,###")
               ?? " "
               ?? transform(NFSVIS,"@E@Z ###,###,###,###.##")
               ?? " " 
               ?? transform(NFSPRZ,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(NFSVLN,"@E@Z ###,###,###,###.##")
               ?? " "
               ?? transform(((NFSVLN/M_TOTGER) * 100),"###.##")
               ?? " "
      
               M_SOMPER = M_SOMPER + ((NFSVLN/M_TOTGER) * 100)
              
               ?? transform(M_SOMPER,"####.##")

            LN++
                                
            M_TOTVIS = M_TOTVIS + NFSVIS
            M_TOTPRZ = M_TOTPRZ + NFSPRZ

            skip - 1
         
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
      ? space(31) 
        ?? "TOTAL GERAL . . . . . . . . ."
        ?? transform(M_TOTVIS,"@E ###,###,###,###.##")
        ?? " "
        ?? transform(M_TOTPRZ,"@E ###,###,###,###.##")
        ?? " "
        ?? transform((M_TOTVIS + M_TOTPRZ),"@E ###,###,###,###.##")

    ?

*    eject
  desliga1(80)

  select ANFS02
  use

return ""

*****************
function PROCESSA(F_QEMP,F_CV)
*****************

if F_CV == "V"
  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ANFS00","ANFS00"})
  aadd(sqlCAMPO,"ANFS00.NFSEMP")
  aadd(sqlCAMPO,"ANFS00.NFSSER")
  aadd(sqlCAMPO,"ANFS00.NFSNUM")
  aadd(sqlCAMPO,"ANFS00.NFSCLI")
  aadd(sqlCAMPO,"ANFS00.NFSCPG")
  aadd(sqlCAMPO,"ANFS00.NFSDTE")
  aadd(sqlCAMPO,"APCA00.PCADES")
  aadd(sqlCAMPO,"APCA00.PCAFOR")
  aadd(sqlCAMPO,"ACLI00.CLIVEN")
  aadd(sqlCAMPO,"ACLI00.CLITIP")
  aadd(sqlCAMPO,"ANFS01.NFSMAT")
  aadd(sqlCAMPO,"ANFS01.NFSLIQ")
  aadd(sqlCAMPO,"ANFS01.NFSVLI")
  aadd(sqlCAMPO,"ANFS01.NFSVIP")
  aadd(sqlCAMPO,"ANFS01.NFSQDE")
  aadd(sqlCAMPO,"ANFS01.NFSDSP")

  aadd(sqlRELATION,{"ANFS01","ANFS01.NFSEMP","ANFS00.NFSEMP"})
  aadd(sqlRELATION,{"","ANFS01.NFSNUM","ANFS00.NFSNUM"})
  aadd(sqlRELATION,{"","ANFS01.NFSSER","ANFS00.NFSSER"})
  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","ANFS01.NFSMAT"})
  aadd(sqlRELATION,{"AFIS00",str(F_QEMP,2,0),"AFIS00.FISEMP"})
  aadd(sqlRELATION,{"","AFIS00.FISNOV","ANFS00.NFSNATN"})
  aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ANFS00.NFSCLI"})

  aadd(sqlCHAVE,"ANFS00.NFSDTE BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
  aadd(sqlCHAVE,"ANFS00.NFSEMP = " + str(F_QEMP, 2, 0))
  aadd(sqlCHAVE,"ANFS00.nfscan not in ('C','D')")
  aadd(sqlCHAVE,"ANFS00.NFSNATN <> '5.929'")
  aadd(sqlCHAVE,"ANFS00.NFSLIS <> 'N'")
  aadd(sqlCHAVE,"(ANFS00.NFSCPG < 3 or ANFS00.NFSCPG > 24)")

  if M_NFSMAT > 0
    aadd(sqlCHAVE,"ANFS01.NFSMAT = " + str(M_NFSMAT,6))
  endif

  if M_NFSCLI1 > 0
    aadd(sqlCHAVE,"APCA00.PCAFOR = " + str(M_NFSCLI1, 5, 0))
  endif

  if !empty(M_CLITIP)
    aadd(sqlCHAVE,"ACLI00.CLITIP IN (" + M_CLITIP + ")")
  endif


  sqlrelation()

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

          do while !eof()

            select ANFS02
     
            seek str(ME_EMP, 2, 0) + str(ANFS00->NFSMAT, 6, 0)

            if eof()
              append blank         
              replace NFSEMP with ME_EMP
              replace NFSMAT with ANFS00->NFSMAT
            endif

            replace NFSQDE with NFSQDE + ANFS00->NFSQDE

            if ANFS00->NFSCPG = 1 .or. ANFS00->NFSCPG = 2
              replace NFSVIS with NFSVIS + ANFS00->NFSLIQ + ANFS00->NFSDSP + ANFS00->NFSVIP
              replace NFSVLN with NFSVLN + ANFS00->NFSLIQ + ANFS00->NFSDSP + ANFS00->NFSVIP
            endif            

            if ANFS00->NFSCPG > 20
              replace NFSPRZ with NFSPRZ + ANFS00->NFSLIQ + ANFS00->NFSDSP + ANFS00->NFSVIP
              replace NFSVLN with NFSVLN + ANFS00->NFSLIQ + ANFS00->NFSDSP + ANFS00->NFSVIP
            endif            

            M_TOTGER = M_TOTGER + ANFS00->NFSLIQ + ANFS00->NFSDSP + ANFS00->NFSVIP

            select ANFS00

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                return ""
              endif
            endif

            skip
 
          enddo



*** Le os cupons fiscais

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ACUP00","ACUP00"})
  aadd(sqlCAMPO,"ACUP00.CUPNUM")
  aadd(sqlCAMPO,"ACUP00.CUPEMP")
  aadd(sqlCAMPO,"ACUP00.CUPCLI")
  aadd(sqlCAMPO,"ACUP00.CUPDTE")
  aadd(sqlCAMPO,"ACUP00.CUPSER")

  aadd(sqlCAMPO,"APCA00.PCADES")
  aadd(sqlCAMPO,"APCA00.PCAFOR")
  aadd(sqlCAMPO,"ACUP01.CUPMAT")
  aadd(sqlCAMPO,"ACUP01.CUPLIQ")
  aadd(sqlCAMPO,"ACUP01.CUPQDE")

  aadd(sqlRELATION,{"ACUP01","ACUP01.CUPEMP","ACUP00.CUPEMP"})
  aadd(sqlRELATION,{"","ACUP01.CUPNUM","ACUP00.CUPNUM"})
  aadd(sqlRELATION,{"","ACUP01.CUPSER","ACUP00.CUPSER"})
  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","ACUP01.CUPMAT"})
  aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ACUP00.CUPCLI"})

  aadd(sqlCHAVE,"ACUP00.CUPDTE BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
  aadd(sqlCHAVE,"ACUP00.CUPEMP = " + str(F_QEMP, 2, 0))
  aadd(sqlCHAVE,"ACUP00.CUPCAN not in ('Z','X','C')")

  if M_NFSMAT > 0
    aadd(sqlCHAVE,"ACUP01.CUPMAT = " + str(M_NFSMAT,6))
  endif

  if M_NFSCLI1 > 0
    aadd(sqlCHAVE,"APCA00.PCAFOR = " + str(M_NFSCLI1, 5, 0))
  endif

* if !M_CLITIP == ""
*   aadd(sqlCHAVE,"ACLI00.CLITIP IN (" + M_CLITIP + ")")
* endif

* if M_NFSCLI > 0
*   aadd(sqlCHAVE,"ACUP00.CUPCLI = " + str(M_NFSCLI, 5, 0))
* endif

  sqlrelation()

     select ACUP00

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

          do while !eof()

            select ANFS02
     
            seek str(ME_EMP, 2, 0) + str(ACUP00->CUPMAT, 6, 0)

            if eof()
              append blank         
              replace NFSEMP with ME_EMP
              replace NFSMAT with ACUP00->CUPMAT
            endif

            replace NFSQDE with NFSQDE + ACUP00->CUPQDE

*            if ACUP00->CUPCPG = 1 .or. ACUP00->CUPCPG = 2
              replace NFSVIS with NFSVIS + ACUP00->CUPLIQ
              replace NFSVLN with NFSVLN + ACUP00->CUPLIQ
*            endif            

*            if ACUP00->CUPCPG > 20
*              replace NFSPRZ with NFSPRZ + ACUP01->CUPLIQ 
*              replace NFSVLN with NFSVLN + ACUP01->CUPLIQ
*            endif            

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
 

else


  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ANFE00","ANFE00"})
  aadd(sqlCAMPO,"ANFE00.NFEEMP")
  aadd(sqlCAMPO,"ANFE00.NFESER")
  aadd(sqlCAMPO,"ANFE00.NFENUM")
  aadd(sqlCAMPO,"ANFE00.NFEFOR")
  aadd(sqlCAMPO,"ANFE00.NFECPG")
  aadd(sqlCAMPO,"ANFE00.NFEDTE")
  aadd(sqlCAMPO,"APCA00.PCADES")
  aadd(sqlCAMPO,"APCA00.PCAFOR")
  aadd(sqlCAMPO,"ANFE01.NFEMAT")
  aadd(sqlCAMPO,"ANFE01.NFELIQ")
  aadd(sqlCAMPO,"ANFE01.NFEVLI")
  aadd(sqlCAMPO,"ANFE01.NFEVIP")
  aadd(sqlCAMPO,"ANFE01.NFEFRE")
  aadd(sqlCAMPO,"ANFE01.NFESUB")
  aadd(sqlCAMPO,"ANFE01.NFEQDE")
  aadd(sqlCAMPO,"ANFE01.NFEDST")

  aadd(sqlRELATION,{"ANFE01","ANFE01.NFEEMP","ANFE00.NFEEMP"})
  aadd(sqlRELATION,{"","ANFE01.NFEFOR","ANFE00.NFEFOR"})
  aadd(sqlRELATION,{"","ANFE01.NFENUM","ANFE00.NFENUM"})
  aadd(sqlRELATION,{"","ANFE01.NFESER","ANFE00.NFESER"})
  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","ANFE01.NFEMAT"})
  aadd(sqlRELATION,{"AFOR00","AFOR00.FORCOD","ANFE00.NFEFOR"})

  aadd(sqlCHAVE,"ANFE00.NFEDTR BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
  aadd(sqlCHAVE,"ANFE00.NFEEMP = " + str(F_QEMP, 2, 0))
  aadd(sqlCHAVE,"ANFE00.NFENATN not in ('1.949','1.910')")

  if M_NFSMAT > 0
    aadd(sqlCHAVE,"ANFE01.NFEMAT = " + str(M_NFSMAT,6))
  endif

  if M_NFSCLI1 > 0
    aadd(sqlCHAVE,"APCA00.PCAFOR = " + str(M_NFSCLI1, 5, 0))
  endif

  sqlrelation()

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")


          do while !eof()

            select ANFS02
     
            seek str(ME_EMP, 2, 0) + str(ANFE00->NFEMAT, 6, 0)

            if eof()
              append blank         
              replace NFSEMP with ME_EMP
              replace NFSMAT with ANFE00->NFEMAT
            endif

            replace NFSQDE with NFSQDE + ANFE00->NFEQDE

            M_LIQ = iif(ANFE00->NFELIQ=0,ANFE00->NFEVLI,ANFE00->NFELIQ)

            if ANFE00->NFECPG = 501
              replace NFSVIS with NFSVIS + (M_LIQ + ANFE00->NFEDST + ANFE00->NFEVIP + ANFE00->NFEFRE + ANFE00->NFESUB)
              replace NFSVLN with NFSVLN + (M_LIQ + ANFE00->NFEDST + ANFE00->NFEVIP + ANFE00->NFEFRE + ANFE00->NFESUB)
            else
              replace NFSPRZ with NFSPRZ + (M_LIQ + ANFE00->NFEDST + ANFE00->NFEVIP + ANFE00->NFEFRE + ANFE00->NFESUB)
              replace NFSVLN with NFSVLN + (M_LIQ + ANFE00->NFEDST + ANFE00->NFEVIP + ANFE00->NFEFRE + ANFE00->NFESUB)
            endif            

            M_TOTGER = M_TOTGER + (M_LIQ + ANFE00->NFEDST + ANFE00->NFEVIP + ANFE00->NFEFRE + ANFE00->NFESUB)

            select ANFE00

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                return ""
              endif
            endif

            skip
 
          enddo
 

endif

return ""

*****************
function CALC_NFS
*****************

private M_NFSVLN

  M_NFSVLN = 0
  M_VALSUB = 0
  M_VALSER = 0

  select ANFS01

    dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER,.t.)

    do while !eof()

      if !str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSNUM, 6, 0) + ANFS01->NFSSER == str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER
        exit
      endif

      valorespro(ANFS01->NFSMAT)     

      // M_NFSVLN = M_NFSVLN + ANFS01->NFSVLI // (ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP)

      if ANFS01->NFSMAT # 1 // FRETE 
        if ANFS01->NFSNATN $ "5.403#5.405"
          M_NFSNATN = ANFS01->NFSNATN
          M_VALSUB += ANFS01->NFSLIQ + ANFS01->NFSVIP
        endif
      endif

      if zPCAGRP = 120 // servicos
        M_VALSER += ANFS01->NFSLIQ
      endif

      select ANFS01

      skip
 
    enddo

M_NFSVLN = ANFS00->NFSVLN

return M_NFSVLN

*****************
function CALC_NFS1
*****************

private M_NFSVLN

  M_NFSVLN = 0

  select ANFS01

    dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER, .t.)

    do while !eof()

      if !str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSNUM, 6, 0) + ANFS01->NFSSER == str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER
        exit
      endif

      valorespro(ANFS01->NFSMAT)     

      M_NFSVLN = M_NFSVLN + calc_dol(ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP, ANFS00->NFSDTE)

      select ANFS01

      skip
 
    enddo

    select ANFS00

return M_NFSVLN

*****************
function CALC_MIL
*****************

private M_NFSMIL

  M_NFSMIL = 0

  select ANFS01

  dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER, .t.)

  do while !eof()

    if !str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSNUM, 6, 0) + ANFS01->NFSSER == str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER
      exit
    endif

    valorespro(ANFS01->NFSMAT)     

    if zPCAGRP = M_NFSGRP
      M_NFSMIL = M_NFSMIL + calc_dol(ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP, ANFS00->NFSDTE)
    endif

    select ANFS01

    skip
 
  enddo

return M_NFSMIL

*****************
function LISNFS_J                      && margem bruta faturamento   */
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

                   
select 0         && nfs temporario
                   
M_IND = ""
M_INDA = ""
M_INDB = ""
acha_livre()

    rodape("MARGEM","BRUTA",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP)

    store date() to M_DATA1 ,;
                    M_DATA2


    store 0      to M_NFSMAT,;
                    M_NFSCLI1,;
                    M_NFSCLI,;
                    M_CODINI,;
                    M_CODFIN

     M_MOEDA = " " 

     sombra(14, 35, 19, 72,_SOMBRA_)
     set color to GR/W
       @ 14, 35 say   "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 15, 35 say   "³Periodo Inicial:          a         ³" 
       @ 16, 35 say   "³        Produto:                    ³" 
       @ 17, 35 say   "³     Fornecedor:          a         ³" 
       @ 18, 35 say   "³   Compra/cUsto:                    ³" 
       @ 19, 35 say   "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
     set color to 

     SetColor(_COREDICAO_)
     @ 15, 53 get     M_DATA1
     @ 15, 64 get     M_DATA2
     @ 16, 53 get     M_NFSMAT picture "######"
     @ 17, 53 get     M_NFSCLI1 picture "#######" valid vernfs25()
     @ 17, 64 get     M_CODFIN picture "#######"
     @ 18, 53 get     M_MOEDA  picture "@!"  valid(M_MOEDA $ "CU")
     read

     if lastkey() = 27
        select ANFS02
        use
        return ""
     endif

     store 0 to M_TOTGER

     select ANFS02

     if !flock()
       msg("* * * (ANFS02) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(NFSEMP, 2, 0) + str(NFSMAT, 6, 0)   tag 1 to &M_IND
     index on str(NFSEMP, 2, 0) + str(NFSVLN, 14, 2)  tag 2 to &M_IND

     set index to &M_IND
  
     select ANFS00

     go top

        set order to 2
         
        dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1), .t.)

        if str(NFSEMP, 2) + dtos(NFSDTE) > str(ME_EMP, 2) + dtos(M_DATA2) .or. str(NFSEMP, 2) + dtos(NFSDTE) < str(ME_EMP, 2) + dtos(M_DATA1)
          msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
          select ANFS02
          use
          return ""
        endif
                
        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
            exit
          endif 

          if NFSCAN = "C" 
            skip
            loop
          endif 
           
          if NFSCPG > 2 
            if NFSCPG <= 20
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

            valorespro(ANFS01->NFSMAT)

            if M_NFSMAT > 0
              if NFSMAT != M_NFSMAT
                skip
                loop
              endif
            endif

            if (M_CODINI + M_CODFIN) > 0
              if zPCAFOR < M_CODINI .or. zPCAFOR > M_CODFIN
                skip
                loop
              endif
            endif

            select ANFS02
     
            dbseek(str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSMAT, 6, 0))

            if eof()
              append blank         
              replace NFSEMP with ANFS01->NFSEMP
              replace NFSMAT with ANFS01->NFSMAT
            endif

            replace NFSQDE with NFSQDE + ANFS01->NFSQDE

            if ANFS00->NFSCPG = 1 .or. ANFS00->NFSCPG = 2
              replace NFSVIS with NFSVIS + ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP
              replace NFSVLN with NFSVLN + ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP
            endif            

            if ANFS00->NFSCPG > 20
              replace NFSPRZ with NFSPRZ + ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP
              replace NFSVLN with NFSVLN + ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP
            endif            

            M_TOTGER = M_TOTGER + ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP
            select ANFS01

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                select ANFS02
                use
                return ""
              endif
            endif

            skip
 
          enddo
 
          select ANFS00
 
          skip

        enddo
  
        M_IMPRE = impresn()

        if M_IMPRE = "N"
          select ANFS02
          use
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        store  0 to PG, LN   ,;
                    M_TOTVIS ,;
                    M_TOTPRZ ,;
                    M_VLRLIQ ,;
                    M_SOMPER 
          
        select ANFS02

        set relation to str(NFSMAT, 6, 0)                     into APCA00 ,;
                     to str(ME_EMP, 2, 0) + str(NFSMAT, 6, 0) into ASLD00

        set order to 2

        go bottom
                 
        do while !bof()
                              
            store PG + 1 to  PG 

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO DE MARGEM BRUTA - " + iif(M_MOEDA="R","REAL ","DOLAR"),"EAGRO21D",132) 
            ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
            ? "*-------*------------------------------------------*-----*--------------*--------------*--------------*--------------*------*------*"
            ? "* PROD  *           DESCRICAO DO PRODUTO           *QTDE * PCO UN CUSTO * TOTAL CUSTO  * PCO UN VENDA *  TOTAL VENDA *% MAR * % SFA*"
            ? "*-------*------------------------------------------*-----*--------------*--------------*--------------*--------------*------*------*"
*               99999.9 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99999 ###,###,###.## ###,###,###.## ###,###,###.## ###,###,###.## ###.## ###.##

            store 5 to LN
  
            do while !bof() 
               
              if  LN > 60
                exit
              endif 

              M_VALOR = iif(M_MOEDA=="C",ASLD00->SLDCPA,ASLD00->SLDCUS)

              ? " " 
               ?? transform(str(NFSMAT, 7, 0),"@R 9999999")
               ?? " "
               ?? pad(zPCADES , 37)
               ?? "      "
               ?? str(NFSQDE, 5, 0)
               ?? " "
               ?? transform(M_VALOR,"@E@Z ###,###,###.##")
               ?? " "
               ?? transform((M_VALOR * NFSQDE),"@E@Z ###,###,###.##")
               ?? " "
               ?? transform(((NFSVIS+NFSPRZ)/NFSQDE),"@E@Z ###,###,###.##")
               ?? " " 
               ?? transform((NFSVIS+NFSPRZ),"@E@Z ###,###,###.##")
               ?? " " 
               ?? transform(100-(M_VALOR/((NFSVIS+NFSPRZ)/NFSQDE) * 100),"###.##")
               ?? " " 
               ?? transform(((NFSVLN/M_TOTGER) * 100),"###.##")
      
            LN = LN + 1
                                
            M_TOTVIS = M_TOTVIS + NFSVIS
            M_TOTPRZ = M_TOTPRZ + NFSPRZ
            M_VLRLIQ = M_VLRLIQ + (NFSVIS+NFSPRZ) - (M_VALOR * NFSQDE)

            skip - 1
         
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
      ? space(01) 
        ?? "TOTAL GERAL ... VISTA: "
        ?? transform(M_TOTVIS,"@E ###,###,###.##")
        ?? " PRAZO: "
        ?? transform(M_TOTPRZ,"@E ###,###,###.##")
        ?? " (VISTA + PRAZO) : "
        ?? transform((M_TOTVIS + M_TOTPRZ),"@E ###,###,###.##")
        ?? " LIQUIDO : "
        ?? transform(M_VLRLIQ,"@E ###,###,###.##")

    eject

    unlock all
    select ANFS02
    use

desliga1()
return ""

*****************
function LISNFS_K                      && controle de despachos      
*****************

private M_TOTAL ,;
        M_DATA1 ,;
        M_DATA2 ,;
        PG, LN  ,;
        M_TELA

    rodape("ETIQUETAS","CAIXA",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP)


    store 0 to M_NFS1 ,;
               M_NFS2 ,;
               M_NCOP

    store AEMP00->EMPSER to M_SER1,;
                            M_SER2   

    store space(30) to M_NFSOBS,;
                       M_NFSCON

     sombra(14, 40, 20, 68,_SOMBRA_)
     set color to GR/W
       @ 14, 40 say                   "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 15, 40 say                   "³   Nota Inicial:           ³" 
       @ 16, 40 say                   "³          Final:           ³" 
       @ 17, 40 say                   "³            A/C:           ³" 
       @ 18, 40 say                   "³    Observacoes:           ³" 
       @ 19, 40 say                   "³  Nro de Copias:           ³" 
       @ 20, 40 say                   "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
     set color to 

     SetColor(_COREDICAO_)
     @ 15, 58 get     M_NFS1 picture "######"
     @ 15, 65 get     M_SER1 picture "@!"
     @ 16, 58 get     M_NFS2 picture "######"
     @ 16, 65 get     M_SER2 picture "@!"
     @ 17, 58 get     M_NFSCON picture "@!@S9"
     @ 18, 58 get     M_NFSOBS picture "@!@S9"
     @ 19, 58 get     M_NCOP picture "##" valid M_NCOP > 0
     read


     if lastkey() = 27
       return ""
     endif

     select ANFS00

     set order to 1
         
     dbseek(str(ME_EMP, 2, 0) + str(M_NFS1, 6, 0) + M_SER1,.t.)

     if str(NFSEMP, 2, 0) + str(NFSNUM, 6, 0) + NFSSER > str(ME_EMP, 2, 0) + str(M_NFS2) + M_SER2 
       msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
       return ""
     endif

     M_IMPRE = impresn()

     if M_IMPRE = "N"
       return ""
     endif

     do while !eof()

       if str(NFSEMP, 2, 0) + str(NFSNUM, 6, 0) + NFSSER  > str(ME_EMP, 2, 0) + str(M_NFS2) + M_SER2  
         go bottom
         skip
         loop
       endif 

       if !ANFS00->NFSVOL == "S"
         skip
         loop
       endif

       for C = 1 to M_NCOP
   
         for L = 1 to 10
           ?
         next
 
         ? space(17)

          valorescli(ANFS00->NFSCLI)
          ATRA00->(dbseek(str(ANFS00->NFSTRA, 3, 0)))

          ?? zCLINOM
 
         ?
         ? space(15)
          ?? zCLIEND2
  
         ?
         ? space(08)       
          ?? strzero(zCLICEP2, 5, 0)
          ?? "-"
          ?? strzero(zCLICCL2, 3, 0)
          ?? space(11)
          ?? zCLIMUN2
          ?? space(15)
          ?? zCLIUF2   
   
         ?
         ? space(08) +  M_NFSCON
         ?
         ? space(08) + M_NFSOBS
         ?
         ? space(22) + ATRA00->TRANOM
         ? 
         ? space(10)
          ?? strzero(ANFS00->NFSNUM, 6, 0) 
          ?? space(02)
          ?? ANFS00->NFSSER  
          ?? space(12)
          ?? str(ANFS00->NFSITE, 5, 0)
          ?? " "
          ?? pad(ANFS00->NFSESP, 10)
          ?? space(09)
          ?? substr(dtoc(NFSDTE), 1, 2) + space(02) +  substr(dtoc(NFSDTE), 4, 2) + space(03) + substr(dtoc(NFSDTE), 7, 2) 
  
          eject
        
       next   && C 
     
       select ANFS00

       skip
               
       if inkey() = 27
         if susimp()
           go bottom
           skip
         endif
       endif

     enddo

desliga1()

return ""

*****************
function LISNFS_L                      && relacao de notas no periodo
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
                   
    rodape("FATURAMENTO","NOTA",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP)

    store date() to M_DATA1 ,;
                    M_DATA2


    store 0      to M_DUPCLI,;
                    M_NFSCLI,;
                    M_CODINI,;
                    M_CODFIN,;
                    M_NFSVEN

     M_MOEDA = "R" 
     M_ENTRADA = "S"

     sombra(13, 35, 15, 72,_SOMBRA_)
     set color to GR/W
       @ 13, 35 say   "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 14, 35 say   "³Periodo Inicial:          a         ³" 
       @ 15, 35 say   "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
     set color to 

     SetColor(_COREDICAO_)
     @ 14, 53 get     M_DATA1
     @ 14, 64 get     M_DATA2
     read

     M_DATA3 = M_DATA1
     M_DATA4 = M_DATA2

     M_RESUMO = { }
    
     do while M_DATA4 # M_DATA3

      aadd(M_RESUMO,{M_DATA3,0,0,0})
      M_DATA3++

     enddo

     aadd(M_RESUMO,{M_DATA4,0,0,0})

     if lastkey() = 27
        return ""
     endif

*M_RESUMO = { }

for AAA = 1 to 2
      
     if AAA = 2
       M_ENTRADA = "E"
     endif

     if M_ENTRADA == "S"
       select ANFS00
       set order to 3
       go top
       dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)
       select ANFS00
       set relation to NFSNATN into AFIS00 
     else
       select ANFS00
       set relation to
       select ANFE00
       set order to 2 
       go top
       dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)
       select ANFE00
       set relation to NFENATN into AFIS00 
     endif

     do while !eof()

       if M_ENTRADA == "S"
         msw("* * * PROCESSANDO ..." + dtoc(NFSDTE) + " * * *")
         if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
           go bottom
           skip
           loop
         endif 
       else
         msw("* * * PROCESSANDO ..." + dtoc(NFEDTR) + " * * *")
         if str(NFEEMP, 2, 0) + dtos(NFEDTR) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
           go bottom
           skip
           loop
         endif 
       endif

       if M_ENTRADA == "S"
         if NFSNATN $ "5.202#6.202"  // devolucao
           skip
           loop
         endif
         if !NFSCAN = "C"
           M_NFSVLN = calc_nfs()
           select ANFS00 
            for PES = 1 to len(M_RESUMO)
             if M_RESUMO[PES,1] = NFSDTE
               if NFSNATN $ "1.202#2.202"  // devolucao
                 M_RESUMO[PES,3] += NFSVIC
                 M_RESUMO[PES,4] += M_NFSVLN
               else 
                 if !NFSNATN $ "1.910#2.910"    // se nao for simples
                   M_RESUMO[PES,3] += NFSVIC
                   M_RESUMO[PES,2] += M_NFSVLN
                 endif 
               endif
             endif
           next
         endif
       else
         for PES = 1 to len(M_RESUMO)
           if M_RESUMO[PES,1] = NFEDTR
             if NFENATN $ "1.202#2.202"
               M_RESUMO[PES,3] += NFEVIC
               M_RESUMO[PES,4] += NFEVLN
             endif
           endif
         next
       endif

       if M_ENTRADA == "S"
         select ANFS00
       else
         select ANFE00
       endif 

       skip  
         
     enddo

  next

*****************

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        store  0 to PG      ,;
                    LN      ,;
                    M_TOT1,;
                    M_TOT2,;
                    M_TOT3

            store PG + 1 to  PG 

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"F A T U R A M E N T O","EAGRO21",114) 
            ? cent_cab(M_DATA,"PEDIODO: " + dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),114) 
            ? "+----------------+---------------+---------------+---------------+---------------+---------------+---------------+"
            ? "| DATA           |  FARURAMENTO  |   ACUMULADO   | ICMS S/VENDAS |   ACUMULADO   |  DEVOLUCAO    |  ACUMULADO    |"
            ? "+----------------+---------------+---------------+---------------+---------------+---------------+---------------+"
*              | 99/99/9999 seg |  9999,999.99  |  9999,999.99  |  9999,999.99  |  9999,999.99  |  9999,999.99  |  9999,999.99  |

            set century on

            for AAA = 1 to len(M_RESUMO)
              if M_RESUMO[AAA,2] + M_RESUMO[AAA,3] + M_RESUMO[AAA,4] = 0
                loop
              endif

              M_TOT1 += M_RESUMO[AAA,2]
              M_TOT2 += M_RESUMO[AAA,3]
              M_TOT3 += M_RESUMO[AAA,4]

              ? "| " 
              ?? M_RESUMO[AAA,1]
              ?? " "
              ?? left(diasem(M_RESUMO[AAA,1]),3)
              ?? " |  "
              ?? transform(M_RESUMO[AAA,2],"@R 9999,999.99")  // FATURAMENTO
              ?? "  |  "
              ?? transform(M_TOT1,"@R 9999,999.99")  // FATURAMENTO
              ?? "  |  "
              ?? transform(M_RESUMO[AAA,3],"@R 9999,999.99")  // ICMS
              ?? "  |  "
              ?? transform(M_TOT2,"@R 9999,999.99")  // FATURAMENTO
              ?? "  |  "
              ?? transform(M_RESUMO[AAA,4],"@R 9999,999.99")  // DEVOLUCAO
              ?? "  |  " 
              ?? transform(M_TOT3,"@R 9999,999.99")  // FATURAMENTO
              ?? "  |" 
            next
            set century off
            ? "+----------------+---------------+---------------+---------------+---------------+---------------+---------------+"
            ?? chr(18)             
            ?
            ? transform(M_TOT1,"@R 9999,999.99") + " (+) Faturamento Bruto"
            ? transform(M_TOT3,"@R 9999,999.99") + " (-) Devolucao"
            ? "___________"
            ? transform(M_TOT1-M_TOT3,"@R 9999,999.99") + " (=) Liquido"
            ?

     eject

desliga1()
return ""

******************
function MONTA_RES
******************

  
  valorescli(ANFS00->NFSCLI)

if ANFS00->NFSCPG > 2 .and. ANFS00->NFSCPG <= 20
  return 0
endif

    if ANFS00->NFSCPG = 1 .or. ANFS00->NFSCPG = 2
      MT_CLIVIS[1] = MT_CLIVIS[1] + ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP
    else
      MT_CLIPRZ[1] = MT_CLIPRZ[1] + ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP
    endif

return .t.

******************
function MONTA_CLI
******************

  if len(M_MATNFS) > 0
    for R = 1 to len(M_MATNFS)
      if left(str(ANFS00->NFSCLI, 7, 0), 5) = M_MATNFS[R,1]
        return .t.
      endif
    next
  endif

  S = len(M_MATNFS)

  S ++

  aadd(M_MATNFS,{""})

  M_MATNFS[S, 1] = left(str(ANFS00->NFSCLI, 7, 0), 5)

  valorescli(ANFS00->NFSCLI)

  if val(zCLITIP) > 0
    if val(zCLITIP) > 3 .and. val(zCLITIP) < 7
      MT_CLIQDE[1] = MT_CLIQDE[1] + 1
    else
      MT_CLIQDE[val(zCLITIP)] = MT_CLIQDE[val(zCLITIP)] + 1
    endif
  else
    MT_CLIQDE[1] = MT_CLIQDE[1] + 1
  endif

return .t.

***************
function OUTNFS
***************
parameters M_OPC,M_OPC1,M_OPC2


      rodape("OUTROS", "NF PRODUTO", M_FAN, "EAGRO21", "Mem: " + str(memory(0), 5), M_EMP)

*        @ 11, 24 prompt "Corre‡„o " HIGHLITE R/BG
*        @ 12, 24 prompt "Cancelar " POSITION 2 HIGHLITE R/BG
*        @ 13, 24 prompt "Reemiss„o" POSITION 1 HIGHLITE R/BG
*        @ 14, 24 prompt "Email    " POSITION 1 HIGHLITE R/BG
*        @ 15, 24 prompt "Autoriza " POSITION 1 HIGHLITE R/BG

      do case
         case M_OPC = 1 ; mancrr()
         case M_OPC = 2 ; cannfs()
         case M_OPC = 3 ; connfs("REEMITE")
         case M_OPC = 4 ; connfs("EMAIL")
         case M_OPC = 5 ; connfs("AUTORIZA")
      endcase

return ""

****************
function OUTNFSB
****************

private  M_NFSEMP ,;  
         M_NFSCLI ,;
         M_NFSDTE 

    do while .t.

      rodape("CANCELAMENTO", "NF PRODUTO", M_FAN, "EAGRO21","Mem: " + str(memory(0), 5), M_EMP)

      tlnfs01()
      AlteraRestauraTela("TLNFS01",.t.)
         M_NFSEMP  = ME_EMP
         M_NFSNUM  = 0
         M_NFSSER  = AEMP00->EMPSER

     SetColor(_COREDICAO_)
         @ 04, 15 get M_NFSNUM picture "######"
         @ 04, 22 get M_NFSSER picture "@!"
         read

         if M_NFSNUM = 0
           exit
         endif

         select ANFS00

         if !dbseek(str(M_NFSEMP, 2, 0) + str(M_NFSNUM, 6, 0) + M_NFSSER)
           msg("* * * NOTA NAO INCLUIDA * * *")
           loop
         endif

         msnfs03()
         msnfs04()

         if ANFS00->NFSCAN = "C"
           msg("* * * NOTA FISCAL JA CANCELADA * * *")
           loop
         endif

         select ANFS00
 
         if !rlock()
           msg("* * * (ANFS00) REGISTRO SENDO USADO * * *")
           loop
         endif


         M_OPC = decide("Confirma Cancelamento desta Nota")

         if M_OPC != 1
           msg("* * * NOTA FISCAL NAO CANCELADA * * *")
           unlock
           loop
         endif

   M_HIS1 = space(50) 
   M_HIS2 = space(50) 
   M_HIS3 = space(50) 
   M_HIS4 = space(50) 
   M_HIS5 = space(50) 

sombra(08, 15, 14, 66,_SOMBRA_)

set color to GR+/BG+
@ 08, 15 say   " ÄÄÄÄÄ Motivo do cancelamento  -  OBRIGATORIO ÄÄÄÄÄ "
@ 09, 15 say   "                                                    "
@ 10, 15 say   "                                                    "
@ 11, 15 say   "                                                    "
@ 12, 15 say   "                                                    "
@ 13, 15 say   "                                                    "
@ 14, 15 say   "                                                    "
set color to

do while .t.

     SetColor(_COREDICAO_)
   @ 09, 16 get M_HIS1 picture "@!" valid !empty(M_HIS1)
   @ 10, 16 get M_HIS2 picture "@!"
   @ 11, 16 get M_HIS3 picture "@!"
   @ 12, 16 get M_HIS4 picture "@!"
   @ 13, 16 get M_HIS5 picture "@!"
   read

   msg("* * * (ENTER) Continua  (ESC) Sai * * *")

   if lastkey() = 27
      exit
   endif

enddo

MS = strzero(ME_EMP,2)
AFIS00->(dbseek(ANFS00->NFSNATN)) 

         msw("* * * CANCELANDO NOTA FISCAL * * *")

         select ANFS00

         if !rlock()
           msg("* * * (ANFS00) REGISTRO SENDO USADO * * *")
           loop
         endif       

         select ANFS01

         dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER,.t.)

         do while !eof()
  
           if !str(NFSEMP, 2, 0) + str(NFSNUM, 6, 0) + NFSSER == str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER
             exit
           endif

           select APCA00
           dbseek(str(ANFS01->NFSMAT, 6, 0))
           do while .t.
             if rlock()
               if AFIS00->FISEST = "C"
                 replace SLD&MS with (SLD&MS - ANFS01->NFSQDE)
               else
                 if AFIS00->FISEST = "D"
                   replace SLD&MS with (SLD&MS + ANFS01->NFSQDE)
                 endif
               endif
               unlock
               exit
             else
               msw("* * * (APCA00) REGISTRO SENDO USADO * * *")
             endif
             if lastkey()=17
               exit
             endif
           enddo

           select AKAR00

           dbseek(str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSMAT, 6, 0) + dtos(ANFS00->NFSDTE) + ANFS00->NFSNATN + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER,.t.)      

           if str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSMAT, 6, 0) + dtos(ANFS00->NFSDTE) + ANFS00->NFSNATN + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER == str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) + KARFISN + str(KARDOC, 6, 0) + KARSER
             elimina()
           endif

           select ANFS01

           do while .t.
             if rlock()
               replace NFSCAN  with "C"
               unlock
               exit
             else
               msw("* * * (ANFS01) REGISTRO SENDO USADO * * *") 
             endif
             if lastkey()=17
               exit
             endif
           enddo

           skip    
 
         enddo

         select ADCR00

         do while .t.
           if dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0), .t.)
             if !str(DUPEMP, 2, 0) + str(DUPNUM, 6, 0) == str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0)
               exit
             endif
             elimina()
           else
             exit
           endif
         enddo

         select ANFS00

         do while .t. 
           if rlock()
             replace NFSCAN  with "C"
             unlock
             exit
           else
             msw("* * * (ANFS00) REGISTRO SENDO USADO * * *")
           endif
           if lastkey()=17
             exit
           endif
         enddo

   select ANFSCAN
   _append("ANFSCAN")
   do while .t.
     if rlock()
       replace NFSEMP with ANFS00->NFSEMP
       replace NFSNUM with ANFS00->NFSNUM
       replace NFSSER with ANFS00->NFSSER
       replace MOTIVO with alltrim(M_HIS1) + " " +;
                           alltrim(M_HIS2) + " " +;
                           alltrim(M_HIS3) + " " +;
                           alltrim(M_HIS4) + " " +;
                           alltrim(M_HIS5)
 
       unlock
       exit
     endif
   enddo

         msg("* * * NOTA FISCAL CANCELADA * * *")

    enddo

return ""


****************
function TLNFS01                       && tela da nota fiscal
****************


nbox(03, 04, 26, 79,"RB+/W*",.t.)
setcolor("N+/W*")
*                          10        20        30        40        50        60        70
*                     56789 123456789 123456789 123456789 123456789 123456789 123456789 123456789
    setcolor("BG/W")
    @ 04, 05 say     " Identifica‡Æo                            Valores                         "
    setcolor("N/W*")
    @ 05, 05 say     " Origem....:     Doc:         Ser:        Desconto R$:                    "
    @ 06, 05 say     " Emissao...:            Volumes..:        Desconto %.:  99,99             "
    @ 07, 05 say     " Opera‡„o..:            Mensagem.:        Frete......:                    "
    @ 08, 05 say     " Nro Nota..:            Modelo...:        Total......:                    "
    setcolor("BG/W")
    @ 09, 05 say     " Cliente/Transporte                                                       "
    setcolor("N/W*")
    @ 10, 05 say     " Cliente...:                                                              "
    @ 11, 05 say     " Cond.Pgto.:                                                              "
    @ 12, 05 say     " Transporte:                            Tp.Frete:                         "
    @ 13, 05 say     " Portador..:                            Vendedor:                         "
    @ 14, 05 say     "                                                                          "
    setcolor("W+/B")
    @ 15, 05 say     " SQ C¢digo   Qtde             Descri‡„o              Unit rio     Total   "
    setcolor("B+/W*")
    @ 08, 47 say     "Total......:                 "
    setcolor("G/W*")
    for zz = 17 to 25
    @ zz, 05 say     "  ³      ³        ³                                 ³          ³          "
    next
set color to

return ""

****************
function EDNFS01  
****************


  setcolor("N/RB*")
    @ 08, 18 say     M_NFSNUM picture "########"
    @ 08, 40 say     M_NFSSER picture "@!"
  SetColor(_COREDICAO_)


    @ 05, 18 get     M_NFSTDC picture "@!"      valid vernfs19()
    @ 05, 26 get     M_NFSDOC picture "######"
    @ 05, 40 get     M_NFSDSE picture "@!"      valid vernfs20()

    @ 06, 18 get     M_NFSDTE                   valid vernfs14()

    @ 07, 21 get     M_NFSNATN picture "9.999"   F2 color _CORF2_ valid vernfs3() funcao "sele_arquivo('AFIS00')" retorno @M_NFSNATN
    @ 06, 41 get     M_NFSVOL picture "@!"      valid(M_NFSVOL $ "SN"+chr(05))
    @ 07, 41 get     M_NFSHIS picture "@!"      valid(M_NFSHIS $ "SN"+chr(05))

    @ 10, 18 get     M_NFSCLI picture "######"   F2 color _CORF2_ valid vernfs1() funcao "sele_arquivo('ACLI00')" retorno @M_NFSCLI
    @ 11, 21 get     M_NFSCPG picture "###"      F2 color _CORF2_ valid vernfs10() funcao "sele_arquivo('ACPG00')" retorno @M_NFSCPG
    @ 12, 21 get     M_NFSTRA picture "###"      F2 color _CORF2_ valid vernfs12() funcao "sele_arquivo('ATRA00')" retorno @M_NFSTRA
    @ 13, 21 get     M_NFSPOR picture "###"      F2 color _CORF2_ valid vernfs23(.t.) funcao "sele_arquivo('APOR00')" retorno @M_NFSPOR

    @ 12, 56 get     M_NFSFRC picture "@!"         valid vernfs15()
    @ 13, 55 get     M_NFSVEN F2 picture "###"  valid vernfs11() color _CORF2_ funcao "sele_arquivo('AVEN00')" retorno @M_NFSVEN

    @ 05, 61 get     M_DSCNFS picture "@R 999,999,999.99"
    @ 06, 61 get     M_NFSDSC picture "##.##"   valid vernfs4()
    @ 07, 61 get     M_NFSFRE picture "@R 999,999,999.99"
    read

  if M_NFSHIS = "S"
    vernfs5()                   && edita historico
  endif

  if M_NFSVOL = "S"
    vernfs13()                  && edita embalagens
  endif

  if M_NFSCPL = "S" // .or. M_NFSPOR = 2 .or. M_NFSPOR = 3 .or. M_NFSPOR = 31
    vernfs21()                  && edita historico
  endif

return ""

****************
function EDNFS02  
****************

     SetColor(_COREDICAO_)
    @ 04, 25 get     M_NFSTDC picture "@!"      valid vernfs19()
    @ 04, 30 get     M_NFSDOC picture "######"
    @ 04, 37 get     M_NFSDSE picture "@!"      valid vernfs20()

    @ 04, 46 get     M_NFSCPG picture "###"     valid vernfs10()
    @ 04, 64 get     M_DSCNFS picture "#########.##"

    @ 05, 15 get     M_NFSNATN picture "9.999"  valid vernfs3()
    @ 05, 30 get     M_NFSDTE                   valid vernfs14()
    @ 05, 46 get     M_NFSCLI picture "#######" valid vernfs1()

    @ 06, 64 get     M_NFSTRA picture "###"     valid vernfs12()
    @ 06, 68 get     M_NFSFRC picture "@!"      valid vernfs15()

    @ 07, 15 get     M_NFSCPL picture "@!"      valid(M_NFSCPL $ "SN"+chr(05))
    @ 07, 17 get     M_NFSHIS picture "@!"      valid(M_NFSHIS $ "SN"+chr(05))
    @ 07, 19 get     M_NFSPOR picture "###"     valid vernfs23(.f.)
    @ 07, 30 get     M_NFSVEN picture "###"     valid vernfs11()
    @ 07, 39 get     M_NFSVOL picture "@!"      valid(M_NFSVOL $ "SN"+chr(05))
    @ 07, 47 get     M_NFSDTS                   
    read

return ""

****************
function EDNFS03
****************

parameters SQ

private M_TELA

  M_TELA = savescreen(4, 18, 18, 60)

  do while .t.
    msw("* * * Digite (PgDn) para Sair * * *")
    sombra(08, 19, 16, 58, _SOMBRA_)
    set color to GR+/R
      @ 08, 19 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
      @ 09, 19 say     "³Despesa Fre/Seg/Dsp.......:           ³"
      @ 10, 19 say     "³Base Calculo Icms.........:           ³"
      @ 11, 19 say     "³Valor Credito Icms........:           ³"
      @ 12, 19 say     "³Valor Coluna Isentos Icms.:           ³"
      @ 13, 19 say     "³Valor Coluna Outros Icms..:           ³"
      @ 14, 19 say     "³Observacao no Livro Fiscal:           ³"
      @ 15, 19 say     "³Classificao Fiscal C.F.O..:           ³"
      @ 16, 19 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
    set color to

    SetColor(_COREDICAO_)
    @ 09, 48 get M_NFSMAT[SQ,12] picture "#######.##"
    @ 10, 48 get M_NFSMAT[SQ,08] picture "#######.##"
    @ 11, 48 get M_NFSMAT[SQ,09] picture "#######.##"
    @ 12, 48 get M_NFSMAT[SQ,10] picture "#######.##"
    @ 13, 48 get M_NFSMAT[SQ,11] picture "#######.##"
    @ 14, 48 get M_NFSMAT[SQ,17] picture "@!@S10"
    @ 15, 48 get M_NFSMAT[SQ,18] picture "#######.##" valid vernfs24()
    read

    if lastkey() = 3 .or. lastkey() = 27
      exit
    endif

    if M_NFSMAT[SQ, 18] = 0
      loop
    endif

  enddo

  restscreen(4, 18, 18, 60, M_TELA)

return ""

****************
function EDNFS04
****************

parameters LN,SQ

setcolor("N+/W*")
@ LN, 05 say     M_NFSMAT[SQ ,1] picture "99"
setcolor("")

SetColor(_COREDICAO_)
@ LN, 08 get     M_NFSMAT[SQ, 3] picture "######"  F2 color _CORF2_ valid vernfs6() funcao "sele_arquivo('APCA00')" retorno @M_NFSMAT[SQ, 3]
@ LN, 15 get     M_NFSMAT[SQ, 4] picture "########"   valid vernfs7()
@ LN, 58 get     M_NFSMAT[SQ, 5] picture "#######.##" valid vernfs8()
read

LERLANCAMENTOS(.t.) // .t. somente totaliza

set key 27 to

return .t.


****************
function MSNFS02                       && mostra dados e calcula nota fiscal
****************

parameters SQ,R

    set color to I
      for S = SQ to len(M_NFSMAT)
        valorespro(M_NFSMAT[S,3])     
        @ R, 05 say   M_NFSMAT[S, 1]            picture "##"
        @ R, 08 say   M_NFSMAT[S, 3]            picture "######"
        @ R, 15 say   M_NFSMAT[S, 4]            picture "########"
        @ R, 24 say   pad(zPCADES, 30)
        @ R, 55 say   M_NFSMAT[S, 5]            picture "#######.##"
        @ R, 66 say   M_NFSMAT[S, 6]            picture "#######.##"
        R++
        if R = 19
          exit
        endif
      next
    set color to

return ""

****************
function MSNFS03  
****************

  set color to I
    @ 04, 15 say     NFSNUM picture "######"  
    @ 04, 22 say     NFSSER picture "@!"      
    @ 04, 25 say     NFSTDC picture "@!"    
    @ 04, 30 say     NFSDOC picture "######"
    @ 04, 37 say     NFSDSE picture "@!"    

    @ 04, 46 say     NFSCPG picture "###"   
    @ 04, 64 say     NFSVLD picture "#########.##"             

    @ 05, 15 say     NFSNATN
    @ 05, 30 say     NFSDTE                 
    @ 05, 47 say     NFSCLI picture "#######" 
    @ 05, 64 say     NFSFRE picture "#########.##"             

    @ 06, 15 say     NFSMEM picture "@!@S25" 
    @ 06, 47 say     NFSTRA picture "###"   
    @ 06, 51 say     NFSFRC picture "@!"

    @ 07, 15 say     NFSCPL picture "@!"    
    @ 07, 19 say     NFSPOR picture "###"
    @ 07, 30 say     NFSVEN picture "###"   
    @ 07, 47 say     NFSDTS                   
    @ 07, 64 say     NFSDSP picture "#########.##" 
  setcolor("GR+/N") 
    if left(NFSNATN,1) > "4"
      if BUSCAREGISTRO("ACLI00",1,{str(ANFS00->NFSCLI,7,0)},"SELECT")
        @ 21, 6 say pad(ACLI00->CLINOM,40)
      endif   
     else
      if BUSCAREGISTRO("AFOR00",1,{str(ANFS00->NFSCLI,7,0)},"SELECT")
        @ 21, 6 say pad(AFOR00->FORNOM,40)
      endif
    endif
  set color to 

  select ANFS00

return ""

****************
function MSNFS04                       && mostra dados da nota
****************


private L        ,;
        M_TELA   ,;
        M_NFSVLM ,;
        M_NFSVLS ,;
        M_NFSVLD

    store 11 to L

    store  0 to LN       ,;
                M_NFSVLM ,;
                M_NFSVLS 

    BUSCAREGISTRO("ANFS01",1,{str(M_NFSEMP, 2, 0),str(M_NFSNUM, 6, 0),aspas(M_NFSSER)},"SELECT")

    do while !eof()
    
        zPCALOT = " "
        zPCAMAT = 0
        zPCADES = space(40)
        zPCAUNI = "  "
        zPCATRI = 0

        if !valorespro(ANFS01->NFSMAT)
          alertnew("Produto nao encontrado: " + str(ANFS01->NFSMAT,6))
        endif

        select ANFS01
        
        set color to I
          @ L, 05 say   NFSSEQ            picture "##"
          @ L, 08 say   NFSMAT            picture "######"
          @ L, 15 say   NFSQDE            picture "#####.##"
          @ L, 24 say   pad(zPCADES, 30)
          @ L, 55 say   NFSPRB            picture "#######.##"
          @ L, 66 say   NFSVLI            picture "#######.##"
        set color to

        if L > 18
          msg("* * * (ESC) Sai (ENTER) continua * * *")
          if lastkey() = 27
            exit
          endif
          lpnfs01()
          L=10
        endif
 
        skip

        L = L + 1

    enddo

 select ANFS00

 lDesligaRedraw := .t.

 M_TELA = savescreen(05, 20, 19, 61)

 nbox(05, 20, 18, 59,"W/W+",.t.)
 setcolor("B/W")
   @ 06, 21 say  "Valor da Mercadoria  :                "
   @ 07, 21 say  "Valor dos Servi‡os   :                "
   @ 08, 21 say  "Valor do Ipi         :                "
   @ 09, 21 say  "Valor da Despesas    :                "
   @ 10, 21 say  "Valor do Desconto    :                "
   @ 11, 21 say  "Valor da Nota Fiscal :                "
   @ 12, 21 say  "1. Tributadas        :                "
   @ 13, 21 say  "2. Isentas           :                "
   @ 14, 21 say  "3. Com Redu‡„o       :                "
   @ 15, 21 say  "4. Outras            :                "
   @ 16, 21 say  "Base Calculo ICMS    :                "
   @ 17, 21 say  "Valor do ICMS        :                "
 setcolor("N/W*")
   @ 06, 45 say NFSVLM                   picture "@E ###,###,###.##"
   @ 07, 45 say NFSVLS                   picture "@E ###,###,###.##"
   @ 08, 45 say NFSVIP                   picture "@E ###,###,###.##"
   @ 09, 45 say NFSFRE + NFSSEG + NFSDSP picture "@E ###,###,###.##"
   @ 10, 45 say NFSVLD                   picture "@E ###,###,###.##"
   @ 11, 45 say NFSVLN                   picture "@E ###,###,###.##"
   @ 12, 45 say NFSTRI                   picture "@E ###,###,###.##"
   @ 13, 45 say NFSISE                   picture "@E ###,###,###.##"
   @ 14, 45 say NFSRED                   picture "@E ###,###,###.##"
   @ 15, 45 say NFSOUT                   picture "@E ###,###,###.##"
   @ 16, 45 say NFSBIC                   picture "@E ###,###,###.##"
   @ 17, 45 say NFSVIC                   picture "@E ###,###,###.##"
 set color to
 
 msg("* * * Tecle (ENTER) * * *")

 lDesligaRedraw := .f.
 restscreen(05, 20, 19, 61, M_TELA)


return ""

****************
function LPNFS01
****************

private K

setcolor("N+/W*")
  for K = 17 to 25
    @ K, 05 say "  ³      ³        ³                                 ³          ³          "
  next &&  K
set color to 

return ""

***************
function APRNFS                       && apuracao da nfs
***************

 lOCAL aBlocks1 := {}
 local M_TELA2 := savescreen(01, 15, 22, 62)


 lDesligaRedraw := .t.

 nbox(05, 20, 18, 59,"W/W+",.t.)
 setcolor("B/W")
   @ 06, 21 say  "Valor da Mercadoria  :                "
   @ 07, 21 say  "Valor dos Servi‡os   :                "
   @ 08, 21 say  "Valor do Ipi         :                "
   @ 09, 21 say  "Valor da Despesa     :                "
   @ 10, 21 say  "Valor do Desconto    :                "
   @ 11, 21 say  "Valor da Nota Fiscal :                "
   @ 12, 21 say  "1. Tributadas        :                "
   @ 13, 21 say  "2. Isentas           :                "
   @ 14, 21 say  "3. Com Redu‡„o       :                "
   @ 15, 21 say  "4. Outros            :                "
   @ 16, 21 say  "Base Calculo ICMS    :                "
   @ 17, 21 say  "Valor do ICMS        :                "
 setcolor("N/W*")
   @ 06, 45 say M_NFSVLM                       picture "@E ###,###,###.##"
   @ 07, 45 say M_NFSVLS                       picture "@E ###,###,###.##"
   @ 08, 45 say M_NFSVIP                       picture "@E ###,###,###.##"
   @ 09, 45 say M_NFSFRE + M_NFSSEG + M_NFSDSP picture "@E ###,###,###.##"
   @ 10, 45 say M_NFSVLD                       picture "@E ###,###,###.##"
   @ 11, 45 say M_NFSVLN                       picture "@E ###,###,###.##"
   @ 12, 45 say M_NFSTRI                       picture "@E ###,###,###.##"
   @ 13, 45 say M_NFSISE                       picture "@E ###,###,###.##"
   @ 14, 45 say M_NFSRED                       picture "@E ###,###,###.##"
   @ 15, 45 say M_NFSOUT                       picture "@E ###,###,###.##"
   @ 16, 45 say M_NFSBIC                       picture "@E ###,###,###.##"
   @ 17, 45 say M_NFSVIC                       picture "@E ###,###,###.##"
 set color to
 
 msg("* * * Tecle (ENTER) * * *")

  lDesligaRedraw := .f.

 restscreen(01, 15, 22, 62, M_TELA2)

return .t.

****************
function VERNFS1                       && procura cliente
****************

    if lastkey() = 5
      return .t.
    endif

    if M_NFSCLI = 9000000
      return .t.
    endif

   if M_NFSCLI = 9999999
     return .t.
   endif

    if left(M_NFSNATN,1) > "4"
      if M_NFSCLI = 0 
*       sele_arquivo("ACLI00")
*       if nCodRetorno = 0
         return .f.
*       endif
*       M_NFSCLI = nCodRetorno
      endif
      if !valorescli(M_NFSCLI)
        msg("* * * CLIENTE NAO CADASTRADO * * *")
        M_NFSCLI = 0
        return .f.
      endif
      msg(rtrim(zCLINOM) + " - " + rtrim(zCLIMUN2) + " " + zCLIUF2)
      if zCLITIP == "6"
        msg("* * * CLIENTE COM MOVIMENTO CONTROLADO * * *")
        return .f.
      endif

      M_CLICGC1 = zCLICGC1

      if !verclicgc(.f.)
        return .f.
      endif

      M_CLIEND1  = zCLIEND1
      M_CLIIES2  = zCLIIES2
      M_CLIIBGE  = zCLICDM2
      M_CLICGC2  = zCLICGC1
      M_CLINOM   = zCLINOM 
      M_CLIEND2  = zCLIEND2
      M_CLINRO2  = zCLINRO2
      M_CLIUF2   = zCLIUF2
      M_CLIBAI1  = zCLIBAI1
      M_CLICEP1  = zCLICEP1
      M_CLICCL1  = zCLICCL1
      M_CLIBAI2  = zCLIBAI2
      M_CLICEP2  = zCLICEP2
      M_CLICCL2  = zCLICCL2
      M_CLIBAI3  = zCLIBAI3
      M_CLICEP3  = zCLICEP3
      M_CLICCL3  = zCLICCL3
      M_CLIMUN2  = zCLIMUN2
      M_CLIMUN3  = zCLIMUN3
      M_CLITEL3  = zCLITEL3
      M_CLIEND3  = zCLIEND3
      M_CLIDCC   = zCLIDCC

      if left(zCLIIES1,6) == "ISENTO" .and. !zCLIUF2 == "SP"
        M_CLIDCC   = 2
      endif
      if !left(zCLIIES1,6) == "ISENTO" .and. !zCLIUF2 == "SP"
        M_CLIDCC   = 1
      endif

    else

      if M_NFSCLI = 0
        return .f.
      endif
      if !BUSCAREGISTRO("AFOR00",1,{str(M_NFSCLI,7,0)},"SELECT")
        msg("* * * FORNECEDOR NAO CADASTRADO * * *")
        M_NFSCLI = 0
        return .f.
      endif
      msg(rtrim(FORNOM) + " - " + rtrim(FORMUN) + " " + FOREST)
      M_CLIIES2  = FORIES
      M_CLICGC2  = FORCGC 
      M_CLINOM   = FORNOM 
      M_CLIEND2  = FOREND 
      M_CLINRO2  = FORNRO
      M_CLIUF2   = FOREST
      M_CLIBAI1  = FORBAI 
      M_CLICEP1  = val(left(FORCEP, 5))
      M_CLICCL1  = val(right(FORCEP, 3))
      M_CLIMUN1  = FORMUN
      M_CLIIBGE  = FORCDM
      M_CLIBAI2  = FORBAI 
      M_CLICEP2  = val(left(FORCEP, 5))
      M_CLICCL2  = val(right(FORCEP, 3))
      M_CLIMUN2  = FORMUN

      M_CLIBAI3  = FORBAI 
      M_CLICEP3  = val(left(FORCEP, 5))
      M_CLICCL3  = val(right(FORCEP, 3))
      M_CLIMUN3  = FORMUN
      M_CLITEL3  = FORTEL
      M_CLIDCC   = 1
      if left(FORIES,6) == "ISENTO" .and. !FOREST == "SP"
        M_CLIDCC   = 2
      endif
      if !left(FORIES,6) == "ISENTO" .and. !FOREST == "SP"
        M_CLIDCC   = 1
      endif
      M_NFSVEN   = 1
      M_NFSTRA   = 1
      M_NFSPOR   = 1
    endif

    if M_NFSNATN $ "5.102#6.102"
      if M_CLIUF2 != "SP"
        if !M_NFSNATN $ "6.102"
          M_NFSNATN = "6.102"
        endif
      else
        if !M_NFSNATN $ "5.102"
          M_NFSNATN = "5.102"
        endif 
      endif
    endif

    setcolor("N/RB*")
      @ 07, 21 say     M_NFSNATN
    set color to 


    if left(M_NFSNATN,1) > "4"
      if M_NFSCLI = 20145 .or. M_NFSCLI = 25568  .or. M_NFSCLI = 23256
        save get to M_GETANT
        @ 24, 00 say "Autorizacao de Faturamento: "
        SetColor(_COREDICAO_)
        @ 24, col() get M_AUTFAT picture "99999999" valid M_AUTFAT > 0
        read
        restore get from M_GETANT
        set cursor on
      endif
    endif

  setcolor("N/RB*")
  @ 10, 26 say ACLI00->CLINOM
  setcolor("")
  
return .t.    

****************
function VERCLINESTLE                       && procura cliente
****************

if M_NFSNESCLI = 0
  return .f.
endif

if !valorescli(M_NFSNESCLI)
  msg("* * * CLIENTE NAO CADASTRADO * * *")
  M_NFSNESCLI = 0
  return .f.
endif
msg(rtrim(zCLINOM) + " - " + rtrim(zCLIMUN2) + " " + zCLIUF2)

return .t.

****************
function VERNFS2                       && transportadora
****************

private M_TELA

M_TELA = savescreen(09, 14, 16, 66)

sombra(09, 14, 15, 65,_SOMBRA_)

setcolor("GR+/BG+,GR+/BG+")
  @ 09, 14 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄTransportadoraÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
  @ 10, 14 say     "³Nome    :                                         ³"
  @ 11, 14 say     "³Endereco:                                         ³"
  @ 12, 14 say     "³Cidade  :                  Uf:      Cep:          ³"
  @ 13, 14 say     "³Placa   :                 Via:                    ³"
  @ 14, 14 say     "³Ins Est :                 CGC:                    ³"
  @ 15, 14 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
setcolor("")

do while .t.
  
  SetColor(_COREDICAO_)
  @ 10, 25 get M_TRANOM picture "@!"
  @ 11, 25 get M_TRAEND picture "@!"
  @ 12, 25 get M_TRAMUN picture "@!"
  @ 12, 46 get M_TRAEST picture "@!"
  @ 12, 56 get M_TRACEP picture "#####"
  @ 12, 62 get M_TRACCL picture "###"
  @ 13, 25 get M_TRAPLC picture "@!"
  @ 13, 46 get M_TRAVIA picture "@!"
  @ 14, 25 get M_TRAIES picture "@!"
  @ 14, 46 get M_TRACGC picture "@R 999.999.999/9999-99"
  read

  msg("* * * (ENTER) Continua  (PgDn) Sai * * *")

  if lastkey() = 3
    exit
  endif

enddo

restscreen(09, 14, 16, 66, M_TELA)


return ""

****************
function VERNFS3                       && ve natureza
****************

*    if !ver_afis00(@M_NFSNATN)
*      return .f.
*    endif

    if !BUSCAREGISTRO("AFIS00",1,{str(ME_EMP,2,0),aspas(M_NFSNATN)},"SELECT")
      msg("* * * NATUREZA NAO CADASTRADA * * *")
      M_NFSNATN = space(5)
      return .f.
    endif

    msg("* * * " + alltrim(FISNOM) + " * * *")

    if FISNOV = space(05)
      msg("* * * NOVO CODIGO NAO CADASTRADO. CADASTRE!!! * * *")
      return .f.
    endif

    M_NFSAPL  = FISAPL
    M_FISINT  = FISINT

    if M_NFSNATN $ "1.202#2.202"
      do while .t.
        nDevTipo = msgbox3("Qual o tipo da devolucao?",,,"Escolha","NFe","NFCe")
        if nDevTipo > 1
          exit
        endif
      enddo

      save get to M_GETANT

      if nDevtipo > 1
        M_NFSDEV1 = M_NFSDEV
        M_NFSSDE1 = M_NFSSDE
        @ 24, 00 say "Nota fiscal devolvida: "
        SetColor(_COREDICAO_)
        @ 24, col() get M_NFSDEV1 picture "999999"
        @ 24, col()+1 get M_NFSSDE1 picture "@!"
        read
        
        if !BUSCAREGISTRO("ANFS00",1,{str(M_NFSEMP, 2, 0),str(M_NFSDEV1, 6, 0),aspas(M_NFSSDE1)},"SELECT")
          msg("* * * NOTA FISCAL NAO CADASTRADA * * *")
          restore get from M_GETANT
          M_NFSDEV = 0
          set cursor on
          return .f.
        endif

        set cursor on
        M_NFSDEV = M_NFSDEV1
        M_NFSSDE = M_NFSSDE1
        M_NFSREF = left(ANFS00->NFSID,44)
      else
        M_NFSREF = "ECF"
        nCUPCCF = 0 
        nCUPCOO = 0 
        @ 24, 00 say "Cupom Fiscal              COO:                "
     SetColor(_COREDICAO_)
        @ 24, 31 get nCUPCOO picture "999999" valid nCUPCOO > 0
        read
        M_NFSREF = M_NFSREF + str(nCUPCOO,6)
      endif
      restore get from M_GETANT
    endif

    if M_NFSNATN $ "5.202#6.202#5.929#5.918#5.413#5.411#" 
      save get to M_GETANT
      if M_NFSNATN $ "#5.929#"
        @ 24, 00 say "Numero do Cupom Fiscal: "
     SetColor(_COREDICAO_)
        @ 24, col() get M_NFSREF picture "999999" valid val(alltrim(M_NFSREF)) > 0
      else
        @ 24, 00 say "Chave Nota fiscal devolvida: "
     SetColor(_COREDICAO_)
        @ 24, col() get M_NFSREF valid len(alltrim(M_NFSREF)) = 44
      endif
      read
      restore get from M_GETANT
      set cursor on
    endif

    lNFSSER = .f.

    if M_NFSNATN $ "5.933#6.933"
      lNFSSER = .t.
    endif


return .t.

****************
function VERNFS4                       && ve desconto na nota
****************

    if lastkey() = 5
        return .t.
    endif

    if M_DSCNFS > 0
      if M_NFSDSC > 0
        msg("* * * JA FOI DADO DESCONTO NA NOTA * * *")
        M_NFSDSC = 0
        return .f.
      endif
    endif

    if M_NFSDSC > 100
      msg("* * * DESCONTO NA PODE SER MAIOR QUE 100 % * * *")
      return .f.
    endif

return .t.

****************
function VERNFS5                       && edita historico
****************

private M_TELA

M_TELA = vlsavescreen(08, 10, 16, 73)

 do while .t.
   M_ESCOLHA = msgbox3("deseja escolher uma mensagem",,,"Escolha","Sim","Nao")
   if M_ESCOLHA = 2
     exit
   endif
   if M_ESCOLHA = 3
     exit
   endif
 enddo

 if M_ESCOLHA = 2
   do while .t.
     M_CODMEM = 0
     @ 24, 00 say "Digite o codigo: "
     @ 24, col() get M_CODMEM picture "999999"
     read

     if lastkey()=27
       exit
     endif
     
     if BUSCAREGISTRO("AMEM00",1,{str(M_CODMEM)},"SELECT")
         M_HIS[1] = ETQDS1
         M_HIS[2] = ETQDS2
         M_HIS[3] = ETQDS3
         M_HIS[4] = ETQDS4
         M_HIS[5] = ETQDS5
         M_HIS[6] = ETQDS6
         select AMEM00
         use
         exit
     else
         msg("* * * MENSAGEM NAO ENCONTRADA * * *")
         select AMEM00
         use
         loop
     endif
   enddo
 endif

 nbox(08, 10, 15, 71,"W/W+",.t.)
 setcolor("B/W")
 @ 08, 35 say     "Historico"
 @ 09, 11 say     "                                                            "
 @ 10, 11 say     "                                                            "
 @ 11, 11 say     "                                                            "
 @ 12, 11 say     "                                                            "
 @ 13, 11 say     "                                                            "
 @ 14, 11 say     "                                                            "
setcolor("")


 do while .t.
 
  SetColor(_COREDICAO_)
  @ 09, 11 get M_HIS[1] picture "@!"
  @ 10, 11 get M_HIS[2] picture "@!"
  @ 11, 11 get M_HIS[3] picture "@!"
  @ 12, 11 get M_HIS[4] picture "@!"
  @ 13, 11 get M_HIS[5] picture "@!"
  @ 14, 11 get M_HIS[6] picture "@!"
  read

  msg("* * * (ENTER) Continua  (PgDn) Sai * * *")

  if lastkey() = 3
    exit
  endif

enddo

vlrestscreen(08, 10, 16, 73, M_TELA)


return ""

****************
function VERNFS5A                      && edita historico
****************

select ANFS00

if len(alltrim(NFSHS1)+alltrim(NFSHS2)+alltrim(NFSHS3)+alltrim(NFSHS4)+alltrim(NFSHS5)+alltrim(NFSHS6)) > 0 .or.len(alltrim(NFSCPL1)+alltrim(NFSCPL2)+alltrim(NFSCPL3)+alltrim(NFSCPL4)+alltrim(NFSCPL5)+alltrim(NFSCPL6)) > 0
else
  return ""
endif

private M_TELA

M_TELA = savescreen(14, 10, 25, 76)

 nbox(14, 10, 21, 71,"W/W+",.t.)
 setcolor("B/W")
 @ 15, 35 say     "Historico"
 @ 16, 11 say     "                                                            "
 @ 17, 11 say     "                                                            "
 @ 18, 11 say     "                                                            "
 @ 19, 11 say     "                                                            "
 @ 20, 11 say     "                                                            "
 @ 21, 11 say     "                                                            "
 setcolor("N/W*")

 if len(alltrim(NFSCPL1)+alltrim(NFSCPL2)+alltrim(NFSCPL3)+alltrim(NFSCPL4)+alltrim(NFSCPL5)+alltrim(NFSCPL6)) > 0
   @ 15, 11 say ANFS00->NFSCPL1
   @ 16, 11 say ANFS00->NFSCPL2
   @ 17, 11 say ANFS00->NFSCPL3
   @ 18, 11 say ANFS00->NFSCPL4
   @ 19, 11 say ANFS00->NFSCPL5
   @ 20, 11 say ANFS00->NFSCPL6
 else
   @ 15, 11 say ANFS00->NFSHS1
   @ 16, 11 say ANFS00->NFSHS2
   @ 17, 11 say ANFS00->NFSHS3
   @ 18, 11 say ANFS00->NFSHS4
   @ 19, 11 say ANFS00->NFSHS5
   @ 20, 11 say ANFS00->NFSHS6
 endif

setcolor("")

msg("* * * PRESSIONE QUALQUER TECLA * * *")

restscreen(14, 10, 25, 76, M_TELA)

return ""

****************
function VERNFS6                       && procura produto
****************

  if lastkey() = 5
    return .t.
  endif

  if M_NFSMAT[SQ,3] = 0
    sele_arquivo("APCA00")
    if nCodRetorno = 0
      return .f.
    endif
    M_NFSMAT[SQ,3] = nCodRetorno
  endif


  
  if M_NFSMAT[SQ,3] = 900000
    if !valorespro(M_NFSMAT[SQ,3])
      msg("* * * PRODUTO NAO CADASTRADO * * *")
      M_NFSMAT[SQ,3] = 0
      return .f.
    endif

    save get to M_GETANT
    M_PCADES = zPCADES
     SetColor(_COREDICAO_)
    @ LN, 24 get M_PCADES picture "@!@S30"
    read
    select APCA00
    do while .t. 
      if rlock()
        replace PCADES   with M_PCADES
        exit 
      else
        msw("* * * (APCA00) REGISTRO SENDO USADO * * *")
      endif
      if lastkey()=27
        exit
      endif
    enddo
    restore get from M_GETANT
  endif



  if !valorespro(M_NFSMAT[SQ,3])
    msg("* * * PRODUTO NAO CADASTRADO * * *")
    M_NFSMAT[SQ,3] = 0
    return .f.
  endif

  setcolor("N/W*")
                    @ LN, 24 say left(zPCADES, 33)
  set color to

  M_NFSMAT[SQ, 14] = zPCACOM
  M_NFSMAT[SQ, 20] = zPCADES

  BUSCAREGISTRO("ASLD00",1,{str(ME_EMP, 2, 0),str(M_NFSMAT[SQ,3],6,0)},"SELECT")

  if M_NFSNATN $ "6.152#5.152#5.202#5.411#6.202#1.152#2.152#1.202#2.202#1102#2.202#5.413"
    M_NFSMAT[SQ,5] = ASLD00->SLDCUS
  else
    M_NFSMAT[SQ,5] = ASLD00->SLDPRC
  endif

  if M_NFSNATN = "5.102" .and. zPCATRI = 4
    M_NFSMAT[SQ, 18] = "5.405"
  endif

  if M_NFSNATN = "5.202" .and. zPCATRI = 4
    M_NFSMAT[SQ, 18] = "5.411"
  endif

  if empty(zPCANCM)
    msg("* * * Produto: " + str(zPCAMAT, 6) + " sem codigo NCM * * *")
    M_NFSMAT[SQ,3] = 0
    return .f.
  endif

  if !"ALUGUEL" $ zPCADES
    if !BUSCAREGISTRO("ANCM00",1,{zPCANCM},"SELECT")
      msg("* * * TRIBUTO NCM NAO CADASTRADO * * *")
      return .f.
    endif
  endif

  msw(zPCADES + " Saldo: " + str(saldo(zPCAMAT), 5, 0))

  setcursor(1)

set key 27 to nulo()
return .t.


**************
function SALDO(PRODUTO)
**************
cNomAberto := alias()

BUSCAREGISTRO("ASLD00",1,{str(ME_EMP, 2, 0),str(PRODUTO,6,0)},"SELECT")

select &cNomAberto

return ASLD00->SLDDIS

****************
function VERNFS7                       && valor > 0
****************

  if lastkey() = 5
    return .t.
  endif

  if M_NFSMAT[SQ,4] = 0
    return .f.
  endif

  if M_NFSCPG < 500
    if M_NFSMAT[SQ, 4] > saldo(M_NFSMAT[SQ,3])
       msg("* * * PRODUTO SEM SALDO DE ESTOQUE -=> " + str(saldo(M_NFSMAT[SQ,3]), 5, 0) + " * * * ")
    endif
  endif

return .t.

****************
function VERNFS8                       && quantidade * valor unitario
****************

  if lastkey() = 5
    return .t.
  endif

  if M_NFSMAT[SQ,5] = 0
    return .f.
  endif

  BUSCAREGISTRO("ASLD00",1,{str(ME_EMP, 2, 0),str(M_NFSMAT[SQ,3],6,0)},"SELECT")


  M_NFSMAT[SQ,6] = (M_NFSMAT[SQ,5] * M_NFSMAT[SQ,4])

  set color to I
    @ LN, 69 say     M_NFSMAT[SQ,6] picture "#######.##"
  set color to 

  vernfs17()



return .t.

****************
function VERNFS9                       && valor > 0
****************

  if lastkey() = 5
    return .t.
  endif

  if M_NFSMAT[R,6] = 0
    return .f.
  endif

return .t.

***************** 
function VERNFS10                      && condicao de pagamento
*****************

  if lastkey() = 5
    return .t.
  endif

  if M_NFSCPG = 0
    return .f.
  endif

  if !BUSCAREGISTRO("ACPG00",1,{str(M_NFSCPG,3,0)},"SELECT")
    msg("* * * CONDICAO DE PAGTO NAO CADASTRADA * * *")
    return .f.
  endif

  setcolor("N/RB*")
  @ 11, 26 say ACPG00->CPGDES
  setcolor("")


return .t.

*************** 
function VERINDD
***************

  if lastkey() = 5
    return .t.
  endif

  if M_NFSIND = 0
    funind() 
    return .f.
  endif

  select AIND00

  if !dbseek(str(M_NFSIND, 3, 0))
    msg("* * * CODIGO NAO CADASTRADA * * *")
    return .f.
  endif

  msg(rtrim(VENNOM))


return .t.

*************** 
function VERIND1D
***************

  if lastkey() = 5
    return .t.
  endif

  if M_NFSIND = 0
    return .t.
  endif

  select AIND00

  if !dbseek(str(M_NFSIND, 3, 0))
    msg("* * * CODIGO NAO CADASTRADA * * *")
    return .f.
  endif

  msg(rtrim(VENNOM))


return .t.

**************** 
function VERNFS11                      && procura vendedor
**************** 


if lastkey() = 5
  return .t.
endif

if M_NFSVEN = 0
  return .f.
endif

if !BUSCAREGISTRO("AVEN00",1,{str(M_NFSVEN,3,0)},"SELECT")
  msg("* * * VENDEDOR NAO CADASTRADO * * *")
  return .f.
endif

setcolor("N/RB*")
@ 13, 60 say pad(AVEN00->VENNOM,17)
setcolor("")

msg(rtrim(VENNOM) + " - " + rtrim(VENMUN) + " " + VENEST)

M_NFSCOM = VENCOM

return .t.

**************** 
function VERNFS12                      && procura transportadora
**************** 

    if lastkey() = 5
        return .t.
    endif

    if M_NFSTRA = 0 
        return .f.
    endif

    if M_NFSTRA = 999
        return .t.
    endif

    if M_NFSTRA = 100
      M_TRANOM = zCLINOM
      M_TRAEND = zCLIEND3
      M_TRAMUN = left(zCLIMUN3, 15)
      M_TRAEST = zCLIUF3
      M_TRACEP = zCLICEP3
      M_TRACCL = zCLICCL3
      M_TRAPLC = space(07)
      M_TRAVIA = "RODOVIARIA"
      M_TRAIES = zCLIIES1
      M_TRACGC = zCLICGC1
      return .t.
    endif

    if !BUSCAREGISTRO("ATRA00",1,{str(M_NFSTRA,3,0)},"SELECT")
      msg("* * * TRANPORTADORA NAO CADASTRADA * * *")
      return .f.
    endif

  setcolor("N/RB*")
  @ 12, 26 say pad(ATRA00->TRANOM,17)
  setcolor("")

    msg(rtrim(TRANOM) + " - " + rtrim(TRAMUN) + " " + TRAPLC)

    M_TRANOM = TRANOM
    M_TRAEND = TRAEND
    M_TRAMUN = TRAMUN
    M_TRAEST = TRAEST
    M_TRACEP = TRACEP
    M_TRACCL = TRACCL
    M_TRAPLC = space(07)
    M_TRAVIA = TRAVIA
    M_TRACGC = TRACGC
    M_TRAIES = TRAIES


return .t.    

*****************
function VERNFS13                      && Embalagem     
*****************

private M_TELA

M_TELA = savescreen(09, 18, 15, 63)

nbox(09, 18, 14, 60,"W/W+",.t.)
setcolor("B/W")
  @ 09, 26 say  "Caracteristica dos Volumes"
  @ 10, 19 say  "Marca     :                              "
  @ 11, 19 say  "Numero    :           Quantidade:        "
  @ 12, 19 say  "Especie   :                              "
  @ 13, 19 say  "Peso Bruto:         Peso Liquido:        "
do while .t.
  
  SetColor(_COREDICAO_)
  @ 10, 31 get M_NFSMAR picture "@!"
  @ 11, 31 get M_NFSNEB picture "@!"
  @ 11, 53 get M_NFSITE picture "####.##"
  @ 12, 31 get M_NFSESP picture "@!"
  @ 13, 31 get M_NFSPRB picture "####.##"
  @ 13, 53 get M_NFSPLQ picture "####.##"
  read 

  msg("* * * (ENTER) Continua  (PgDn) Sai * * *")

  if lastkey() = 3
    exit
  endif
enddo

restscreen(09, 18, 15, 63, M_TELA)
      
return ""

*****************
function VERNFS14
*****************

  if lastkey() = 5
     return .t.
  endif

  if empty(M_NFSDTE)
    msg("* * * EMISSAO NAO PODE SER BRANCOS * * *")
    return .f.
  endif

return .t.

*****************
function VERNFS15
*****************

  if lastkey() = 5
     return .t.
  endif

  if !M_NFSFRC $ "1#2" 
    msg("Frete por Conta (1) Emitente (2) Destinatario * * *")
    return .f.
  endif

return .t.


*****************
function VERNFS19                       
*****************

  if lastkey()=5
    return .t.
  endif

  if !M_NFSTDC $ "ORC#REQ#PRE#   "
    msg("* * * Digite (ORC) Orcamento (REQ) Requisicao (PRE) Pre-Venda * * *")
    M_NFSTDC = space(03)
    return .f.
  endif

  if M_NFSTDC == "ORC"
    M_NFSDSE =  AEMP00->EMPPSE
  else
    if M_NFSTDC = "REQ"
      M_NFSDSE =  AEMP00->EMPPSE
      pega_reqs()
    else
      if M_NFSTDC = "PRE"
        M_NFSDSE =  AEMP00->EMPOSE
      endif
    endif
  endif

return .t.    

******************
function PEGA_REQS
******************
local ltela := savescreen(12,33,20,70)
local AA


save get to M_GET9999

nbox(12, 33, 19, 69,"W/W+",.t.)
setcolor("B/W")
                @ 12, 33 say   "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
                @ 13, 33 say   "³                                   ³"
                @ 14, 33 say   "³                                   ³"
                @ 15, 33 say   "³                                   ³"
                @ 16, 33 say   "³                                   ³"
                @ 17, 33 say   "³                                   ³"
                @ 18, 33 say   "³                                   ³"
                @ 19, 33 say   "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
  SetColor(_COREDICAO_)

              @ 13, 34 get M_REQ[ 1] picture "######" valid ver_req2(M_REQ[ 1])
              @ 13, 41 get M_REQ[ 2] picture "######" valid ver_req2(M_REQ[ 2])
              @ 13, 48 get M_REQ[ 3] picture "######" valid ver_req2(M_REQ[ 3])
              @ 13, 55 get M_REQ[ 4] picture "######" valid ver_req2(M_REQ[ 4])
              @ 13, 62 get M_REQ[ 5] picture "######" valid ver_req2(M_REQ[ 5])

              @ 14, 34 get M_REQ[ 6] picture "######" valid ver_req2(M_REQ[ 6])
              @ 14, 41 get M_REQ[ 7] picture "######" valid ver_req2(M_REQ[ 7])
              @ 14, 48 get M_REQ[ 8] picture "######" valid ver_req2(M_REQ[ 8])
              @ 14, 55 get M_REQ[ 9] picture "######" valid ver_req2(M_REQ[ 9])
              @ 14, 62 get M_REQ[10] picture "######" valid ver_req2(M_REQ[10])

              @ 15, 34 get M_REQ[11] picture "######" valid ver_req2(M_REQ[11])
              @ 15, 41 get M_REQ[12] picture "######" valid ver_req2(M_REQ[12])
              @ 15, 48 get M_REQ[13] picture "######" valid ver_req2(M_REQ[13])
              @ 15, 55 get M_REQ[14] picture "######" valid ver_req2(M_REQ[14])
              @ 15, 62 get M_REQ[15] picture "######" valid ver_req2(M_REQ[15])

              @ 16, 34 get M_REQ[16] picture "######" valid ver_req2(M_REQ[16])
              @ 16, 41 get M_REQ[17] picture "######" valid ver_req2(M_REQ[17])
              @ 16, 48 get M_REQ[18] picture "######" valid ver_req2(M_REQ[18])
              @ 16, 55 get M_REQ[19] picture "######" valid ver_req2(M_REQ[19])
              @ 16, 62 get M_REQ[20] picture "######" valid ver_req2(M_REQ[20])

              @ 17, 34 get M_REQ[21] picture "######" valid ver_req2(M_REQ[21])
              @ 17, 41 get M_REQ[22] picture "######" valid ver_req2(M_REQ[22])
              @ 17, 48 get M_REQ[23] picture "######" valid ver_req2(M_REQ[23])
              @ 17, 55 get M_REQ[24] picture "######" valid ver_req2(M_REQ[24])
              @ 17, 62 get M_REQ[25] picture "######" valid ver_req2(M_REQ[25])

              @ 18, 34 get M_REQ[26] picture "######" valid ver_req2(M_REQ[26])
              @ 18, 41 get M_REQ[27] picture "######" valid ver_req2(M_REQ[27])
              @ 18, 48 get M_REQ[28] picture "######" valid ver_req2(M_REQ[28])
              @ 18, 55 get M_REQ[29] picture "######" valid ver_req2(M_REQ[29])
              @ 18, 62 get M_REQ[30] picture "######" valid ver_req2(M_REQ[30])
              read

restore get from M_GET9999
set cursor on

if lastkey()=27
  restscreen(12,33,20,70,ltela)
  return .t.
endif


M_DSCNFS = 0

select AREQ00
for AA = 1 to 30
  if M_REQ[AA] > 0
    BUSCAREGISTRO("AREQ00",1,{str(ME_EMP, 2, 0),str(M_REQ[AA], 6, 0),aspas(M_NFSDSE)},"SELECT")
    M_DSCNFS += REQDSC
  endif
next

restscreen(12,33,20,70,ltela)


****************
function VER_REQ2(TIPO)
****************

if lastkey() = 5 .OR. TIPO = 0
  return .t.
endif

if !BUSCAREGISTRO("AREQ00",1,{str(ME_EMP, 2, 0),str(TIPO, 6, 0),aspas(M_NFSDSE)},"SELECT")
  msg("* * * REQUISICAO NAO CADASTRADA * * *")
  return .f.
endif

if REQNFS > 0
  if M_APC = 1
    msg("* * * REQUISICAO JA EMITIDA " + str(REQNFS, 6, 0) + " " + REQNSE + " * * *")
    return .t.
  endif
endif

if M_NFSCLI = 0
  M_NFSCLI = REQCLI
  M_NFSVEN = REQVEN
else
  if REQCLI # M_NFSCLI
    msg("* * * REQUISICAO NAO PERTENCE AO MESMO CLIENTE * * *")
    return .f.
  endif
endif

M_DSCNFS = REQDSC

return .t.

*****************
function VERNFS20
*****************

  if lastkey() = 5
    return .t.
  endif

if M_NFSTDC = "ORC"
  if M_NFSDOC = 0 
    return .t.
  endif

  if !BUSCAREGISTRO("APED00",1,{str(ME_EMP, 2, 0),str(M_NFSDOC, 6, 0),aspas(M_NFSDSE)},"SELECT")
    msg("* * * PEDIDO NAO CADASTRADO * * *")
    return .f.
  endif
  M_NFSCLI = PEDCLI
  M_NFSVEN = PEDVEN
  M_NFSCPG = PEDCPG
  M_DSCNFS = PEDDSC
  M_NFSFRE = PEDFRE
  M_NFSPOR = PEDPOR
  M_NFSFRC = PEDFRC
  M_NFSTRA = PEDTRA
else
  if M_NFSTDC = "REQ"
    if M_NFSDOC = 0 
      return .t.
    endif
    select AREQ00                        && seleciona arquivo de pedidos mestre 
    if !dbseek(str(ME_EMP, 2, 0) + str(M_NFSDOC, 6, 0) + M_NFSDSE)
      msg("* * * REQUISICAO NAO CADASTRADA * * *") 
      return .f.
    endif
    if REQNFS > 0
      msg("* * * REQUISICAO JA EMITIDA " +  str(REQNFS, 6, 0) + " " + REQNSE + " * * *")
      return .f.
    endif
    M_NFSCLI = REQCLI
    M_NFSVEN = REQVEN
    M_NFSCPG = REQCPG
    M_DSCNFS = REQDSC
    M_NFSFRC = REQFRC
  else
    if M_NFSTDC = "PRE"
      if M_NFSDOC = 0 
        return .t.
      endif
      select AORC00                        && seleciona arquivo de pedidos mestre 
      if !dbseek(str(ME_EMP, 2, 0) + str(M_NFSDOC, 6, 0) + M_NFSDSE)
        msg("* * * PRE-VENDA NAO CADASTRADA * * *") 
        return .f.
      endif
      if ORCNFS > 0
        msg("* * * PRE-VENDA JA EMITIDA " +  str(ORCNFS, 6, 0) + " * * *")
      endif
      M_NFSCLI = ORCCLI
      M_NFSVEN = ORCVEN
      M_NFSCPG = ORCCPG
      M_DSCNFS = ORCDSC
    endif
  endif
endif

return .t.

*****************
function VERNFS21                     && edita complemento
*****************

private M_TELA

M_TELA = savescreen(08, 20, 16, 62)

sombra(08, 20, 15, 61,_SOMBRA_)

setcolor("GR+/BG+")
 @ 08, 20 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄDados AdicionaisÄÄÄÄÄÄÄÄÄÄÄÄ¿"
 @ 09, 20 say     "³                                        ³"
 @ 10, 20 say     "³                                        ³"
 @ 11, 20 say     "³                                        ³"
 @ 12, 20 say     "³                                        ³"
 @ 13, 20 say     "³                                        ³"
 @ 14, 20 say     "³                                        ³"
 @ 15, 20 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
setcolor("")

do while .t.
  
  SetColor(_COREDICAO_)
  @ 09, 21 get M_CPL[1] picture "@!"
  @ 10, 21 get M_CPL[2] picture "@!"
  @ 11, 21 get M_CPL[3] picture "@!"
  @ 12, 21 get M_CPL[4] picture "@!"
  @ 13, 21 get M_CPL[5] picture "@!"
  @ 14, 21 get M_CPL[6] picture "@!"
  read

  msg("* * * (ENTER) Continua  (PgDn) Sai * * *")

  if lastkey() = 3
    exit
  endif

enddo

restscreen(08, 20, 16, 62, M_TELA)


return ""

*****************
function VERNFS22                      && consumidor
***************** 

private M_TELA

M_TELA = savescreen(09, 14, 16, 66)

sombra(09, 14, 15, 65,_SOMBRA_)

setcolor("GR+/BG+")
  @ 09, 14 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄCliente ConsumidorÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
  @ 10, 14 say     "³Nome    :                                         ³"
  @ 11, 14 say     "³Endereco:                                         ³"
  @ 12, 14 say     "³Cidade  :                  Uf:      Cep:          ³"
  @ 13, 14 say     "³Entregar:                                         ³"
  @ 14, 14 say     "³Ins Est :                 Cgc:                    ³"
  @ 15, 14 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
setcolor("")

do while .t.
  
  SetColor(_COREDICAO_)
  @ 10, 25 get M_CLINOM  picture "@!"
  @ 11, 25 get M_CLIEND2 picture "@!"
  @ 12, 25 get M_CLIMUN2 picture "@!@S15"
  @ 12, 46 get M_CLIUF2  picture "@!"  valid  verest(M_CLIUF2)
  @ 12, 56 get M_CLICEP2 picture "#####"
  @ 12, 62 get M_CLICCL2 picture "###"
  @ 13, 25 get M_CLIEND1 picture "@!"
  @ 14, 25 get M_CLIIES2 picture "@!"
  @ 14, 46 get M_CLICGC2 picture "@R 999.999.999/9999-99"
  read

  msg("* * * (ENTER) Continua  (PgDn) Sai * * *")

  if lastkey() = 3
    exit
  endif

enddo

  if M_NFSNATN $ "5.102#6.102"
    if M_CLIUF2 != "SP"
      if M_NFSNATN != "6.102"
        M_NFSNATN = "6.102"
      endif
    else
      if M_NFSNATN != "5.102"
        M_NFSNATN = "5.102"
      endif
    endif
      set color to I 
        @ 05, 15 say     M_NFSNATN
      set color to 
  endif 

restscreen(09, 14, 16, 66, M_TELA)


return ""

*****************
function VERNFS23(TIPO)
*****************

  if lastkey() = 5
     return .t.
  endif

  if M_NFSPOR = 0
    msg("* * * CODIGO DO PORTADOR NAO PODE SER ZEROS * * *")
    return .f.
  endif

  if !BUSCAREGISTRO("APOR00",1,{str(M_NFSPOR,5,0)},"SELECT")
    msg("* * * PORTADOR NAO CADASTRADO * * *")
    return .f.
  endif

  setcolor("N/RB*")
  @ 13, 26 say pad(APOR00->PORNOM,17)
  setcolor("")

  msg("* * * " + alltrim(APOR00->PORNOM) + " * * *")

return .t.

**************
function VOLTA
**************

M_SAI  = .t.
M_NFSAGR = "N"
keyboard chr(13) + chr(05)
set key 5 to

return .t.

****************** 
function  VERNFS24
******************

  if lastkey() = 5
    return .t.
  endif
        
  if M_NFSMAT[SQ, 18] < 500.00
    msg("* * * OPERACAO INVALIDA PARA VENDA * * *")
    M_NFSMAT[SQ, 18] = 0
    return .f.
  endif

  if M_NFSMAT[SQ, 18] = 0
    return .f.
  endif

  select AFIS00

  if !dbseek(str(M_NFSEMP, 2, 0) + str((M_NFSMAT[SQ, 18] * 100), 5, 0))
    msg("* * * CODIGO FISCAL NAO CADASTRADO * * *")
    M_NFSMAT[SQ, 18] = 0
    return .f.
  endif

  msg("* * * " + alltrim(FISNOM) + " * * *")

return .t.

****************** 
function  VERNFS25
******************

  if lastkey() = 5
    return .t.
  endif
        
  if M_NFSCLI1 > 0
     M_CODINI = M_NFSCLI1
     M_CODFIN = M_NFSCLI1
  endif

return .t.

***************** 
function VERNFS50
*****************

  if lastkey() = 5
    return .t.
  endif
        
  if M_NFSCLI > 0
    M_CODINI = M_NFSCLI
    M_CODFIN = M_NFSCLI
  endif

return .t.

*****************
function CALC_DUP
*****************

private M_DUP[06] ,;
        M_VCT[06] ,;
        M_FER[08] ,;
        M_PR[06]  ,;
        M_PE[06]

declare M_DUP[06] ,;
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

  if M_NFSCPG >= 2 .and. M_NFSCPG <= 20
    return ""
  endif

  for R = 1 to 6
     M_DUP[ R ] = 0
     M_VCT[ R ] = ctod("  /  /  ")
  next &&  R

  if !BUSCAREGISTRO("ACPG00",1,{str(M_NFSCPG,3,0)},"SELECT")
    msg("* * * CONDICAO PAGAMENTO NAO CADASTRADA * * *")
    return ""
  endif    

  M_VALOR = M_NFSVLN

  select ACPG00
  M_PARC = CPGPAR

  for S = 1 to 6
    M_S = str(S, 1, 0)
    M_PE[ S ] = CPGPE&M_S
    M_PR[ S ] = CPGPR&M_S
  next && S

  for R = 1 to M_PARC            && calcula as duplicatas
    M_DUP[ R ] =  round((M_VALOR * .01) * M_PE[ R ], 2)
    M_VCT[ R ] = M_NFSDTE + M_PR[ R ]
  next &&  R
 
  for R = 1 to M_PARC            && verifica se vencimento e sabado ou domingo
    M_VLR = M_VLR + round(M_DUP[ R ], 2)   && somas as duplicatas
  next &&  R

  M_RES = ( M_VALOR - M_VLR )
  M_DUP[ M_PARC ] = M_DUP[ M_PARC ] + M_RES

  for S = 1 to 6
    M_S = str(S, 1, 0)      
    M_DUPDP&M_S = M_DUP[ S ] 
    M_DUPVC&M_S = M_VCT[ S ]
  next && S

  AlteraRestauraTela("TLNFS01",.f.) // ANTES DE ABRIR A TELA DESLIGAMOS O REDRAW

  */*/*/
  M_TELA = savescreen(06, 44, 20, 75)

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
       @ 18, 45 say     "N o t a  R$                "
     set color to

     setcolor("N/W*")
       @ 18, 60 say M_NFSVLN   picture "#########.##"
     SetColor(_COREDICAO_)
     @ 11, 49 get     M_DUPVC1
     @ 11, 60 get     M_DUPDP1 picture "#########.##"
     @ 12, 49 get     M_DUPVC2
     @ 12, 60 get     M_DUPDP2 picture "#########.##"
     @ 13, 49 get     M_DUPVC3
     @ 13, 60 get     M_DUPDP3 picture "#########.##"
     @ 14, 49 get     M_DUPVC4
     @ 14, 60 get     M_DUPDP4 picture "#########.##"
     @ 15, 49 get     M_DUPVC5
     @ 15, 60 get     M_DUPDP5 picture "#########.##"
     @ 16, 49 get     M_DUPVC6
     @ 16, 60 get     M_DUPDP6 picture "#########.##"
     read

     M_TOTDP = ( M_DUPDP1 + M_DUPDP2 + M_DUPDP3 + M_DUPDP4 + M_DUPDP5 + M_DUPDP6 )  

     if !str(M_NFSVLN, 12, 2) == str(M_TOTDP, 12, 2) 
        msg(str(M_NFSVLN, 12, 2) + "* * * SOMA DE DUPLICATA NAO BATE COM A NOTA * * *")
         if lastkey()=529
           exit
         endif 
        loop
     endif

     do case
        case ACPG00->CPGPAR = 1
          if M_DUPDP2 + M_DUPDP3 + M_DUPDP4 + M_DUPDP5 + M_DUPDP6 > 0
            msg("* * * DUPLICATA SOMENTE COM UMA PARCELA * * *")
            loop
          endif
        case ACPG00->CPGPAR = 2
          if M_DUPDP3 + M_DUPDP4 + M_DUPDP5 + M_DUPDP6 > 0
            msg("* * * DUPLICATA SOMENTE COM DUAS PARCELAS * * *")
            loop
          endif
        case ACPG00->CPGPAR = 3
          if M_DUPDP4 + M_DUPDP5 + M_DUPDP6 > 0
            msg("* * * DUPLICATA SOMENTE COM TRES PARCELAS * * *")
            loop
          endif
        case ACPG00->CPGPAR = 4
          if M_DUPDP5 + M_DUPDP6 > 0
            msg("* * * DUPLICATA SOMENTE COM QUATRO PARCELAS * * *")
            loop
          endif
        case ACPG00->CPGPAR = 5
          if M_DUPDP6 > 0
            msg("* * * DUPLICATA SOMENTE COM QUATRO PARCELAS * * *")
            loop
          endif
     endcase

     exit

  enddo

  AlteraRestauraTela("TLNFS01",.t.) // RELIGAMOS O REDRAW

  restscreen(06, 44, 20, 75, M_TELA)

return ""

****************
function GRDCRDD                       && cria duplicatas contas a receber
****************

aBoletos = { }

M_CPGPAR = 0

for S = 1 to 6 
  M_S = strzero(S, 1, 0)
  if M_DUPDP&M_S > 0
    M_CPGPAR = M_CPGPAR + 1
  endif
next

for S = 1 to 6
  M_S = strzero(S, 1, 0)
  if M_DUPDP&M_S > 0
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"ADCR00","INSERT"}

    aadd(sqlCAMPO,{"DUPEMP",str(M_NFSEMP,2),.t.})
    aadd(sqlCAMPO,{"DUPNUM",str(M_NFSNUM,6),.t.})
    aadd(sqlCAMPO,{"DUPORD",str(iif(M_CPGPAR=1, 0, S),2),.t.})
    aadd(sqlCAMPO,{"DUPCLI",str(M_NFSCLI,5),.t.})
    aadd(sqlCAMPO,{"DUPNOM",zCLINOM,.t.})
    aadd(sqlCAMPO,{"DUPDTE",formatdta(M_NFSDTE),.t.})
    aadd(sqlCAMPO,{"DUPVCT",formatdta(M_DUPVC&M_S),.t.})
    aadd(sqlCAMPO,{"DUPVEN",str(M_NFSVEN,3),.t.})
    aadd(sqlCAMPO,{"DUPPOR",str(M_NFSPOR,5),.t.})
    aadd(sqlCAMPO,{"DUPAPL",str(M_NFSAPL,3),.t.})
    aadd(sqlCAMPO,{"DUPNFS",str1(M_NFSVLN,2),.t.})

    aadd(sqlCAMPO,{"DUPVLO",str1(M_DUPDP&M_S,2),.t.})

    if M_NFSDTE = M_DUPVC&M_S // .or. M_NFSDTE = M_DUPVC&M_S
      aadd(sqlCAMPO,{"DUPVLP",str1(M_DUPDP&M_S,2),.t.})
      aadd(sqlCAMPO,{"DUPVLA",str1(0,2),.t.})
      aadd(sqlCAMPO,{"DUPHIS",str(100,3),.t.})
      aadd(sqlCAMPO,{"DUPDTP",formatdta(M_NFSDTE),.t.})
    else
      aadd(sqlCAMPO,{"DUPHIS",str(500,3),.t.})
      aadd(sqlCAMPO,{"DUPVLA",str1(M_DUPDP&M_S,2),.t.})
    endif
    aadd(sqlCAMPO,{"DUPCPG",str(M_NFSCPG,3),.t.})
    aadd(sqlCAMPO,{"DUPFISN",M_NFSNATN,.t.})
    aadd(sqlCAMPO,{"DUPSER",M_NFSSER,.t.})

    if M_NFSPOR = 7 .or. M_NFSPOR = 15
      aadd(sqlCAMPO,{"DUPEXP","E",.t.})
    endif
    aadd(sqlCAMPO,{"DUPAGR",M_NFSAGR,.t.})
    executasql()
  endif
next && S


if M_NFSPOR = 7 .or. M_NFSPOR = 15

  mon_env("BOLETO.LimparLista")
  cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
  M_JUROS = 10

  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"ADCR00","SELECT"}
  aadd(sqlCHAVE,{"DUPEMP",str(M_NFSEMP,2)})
  aadd(sqlCHAVE,{"DUPNUM",str(M_NFSNUM,6)})
  aadd(sqlCHAVE,{"DUPSER",aspas(M_NFSSER)})
  aadd(sqlCHAVE,{"DUPHIS","500"})
  executasql()

  // BRASIL 7
  // SICRED 15
  
  if M_NFSPOR = 15
    filecopy("C:\ACBrMonitorPLU\ACBrSicredi.ini","C:\ACBrMonitorPLU\ACBrMonitor.ini")           // Copy the file
    mon_env("ACBr.Lerini")
    cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

    do while !eof()
      sicredi(DUPVLA, str(DUPNUM, 6, 0) + "/" + strzero(DUPORD, 2, 0) + "-" + DUPSER,0) && emite duplicata
      select ADCR00
      skip
    enddo
  else
    filecopy("C:\ACBrMonitorPLU\ACBrBrasil.ini","C:\ACBrMonitorPLU\ACBrMonitor.ini")           // Copy the file
    mon_env("ACBr.Lerini")
    cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
    do while !eof()
      lay_sil(DUPVLA, str(DUPNUM, 6, 0) + "/" + strzero(DUPORD, 2, 0) + "-" + DUPSER,0) && emite duplicata
      select ADCR00
      skip
    enddo
  endif

  mon_env("BOLETO.Imprimir")
  cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

else
  // se imprime na impressora

  private VAL_EXT[ 3 ]
  declare VAL_EXT[ 3 ] 

  if len(aBoletos) > 0
    set printer to "RELATO.RPT"
    set print on
    set console off
    ?? chr(18)
    ?? chr(27) + "G"
    
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"ADCR00","SELECT"}
    aadd(sqlCHAVE,{"DUPEMP",str(M_NFSEMP,2)})
    aadd(sqlCHAVE,{"DUPNUM",str(M_NFSNUM,6)})
    aadd(sqlCHAVE,{"DUPSER",aspas(M_NFSSER)})
    aadd(sqlCHAVE,{"DUPHIS","500"})
    executasql()

    do while !eof()
      lay_dup(DUPVLA,DUPNUM,DUPORD,AEMP00->EMPSER, DUPDTE) && emite duplicata
      select ADCR00
      skip
    enddo

    M_IMPRE = "I"
    desliga1()

  endif
endif

return ""

****************
function IMPRENF
****************

#include "ptmenu.ch"

private M_OPC

  M_OPC = 0

  do while .t.
    M_OPC = msgbox3("Emite Nota Eletronica?",,,"Escolha","Sim","Nao")
    if M_OPC > 1
      exit
    endif
  enddo

  if M_OPC = 2
    msw("* * * AGUARDE ... IMPRIMINDO * * *")
    set console off
    return "I"
  endif

return "N"

****************
function SEL_NFA
****************

private M_OPC  ,;
        M_TELA

M_TELA = savescreen(11, 58, 18, 75)

sombra(11, 60, 16, 72,_SOMBRA_)

painel(11, 60, 16, 72,"W+/BG","N/BG")

set color to W+/BG,W+/N
  @ 12, 61 prompt "  Emissao  " POSITION 3 HIGHLITE R/BG     
  @ 13, 61 prompt "  Alterar  " POSITION 4 HIGHLITE R/BG     
  @ 14, 61 prompt "  Incluir  " POSITION 4 HIGHLITE R/BG     
  @ 15, 61 prompt "  Excluir  " POSITION 4 HIGHLITE R/BG     
menu to M_OPC
set color to

restscreen(11, 58, 18, 75,M_TELA)

return M_OPC


****************
function SEL_NFB
****************

private M_OPC  ,;
        M_TELA

M_TELA = savescreen(11, 58, 18, 75)

sombra(11, 60, 16, 72,_SOMBRA_)

painel(11, 60, 16, 72,"W+/BG","N/BG")

set color to W+/BG,W+/N
  @ 12, 61 prompt "  Regrava  " POSITION 3 HIGHLITE R/BG     
  @ 13, 61 prompt "  Alterar  " POSITION 4 HIGHLITE R/BG     
  @ 14, 61 prompt "  Incluir  " POSITION 4 HIGHLITE R/BG     
  @ 15, 61 prompt "  Excluir  " POSITION 4 HIGHLITE R/BG     
menu to M_OPC
set color to

restscreen(11, 58, 18, 75,M_TELA)

return M_OPC

****************
function GRNFS00
****************

  select ANFS00                   && seleciona NFS mestre para gravacao 

  do while .t. 
    if rlock()
      replace NFSEMP  with M_NFSEMP
      replace NFSNUM  with M_NFSNUM
      replace NFSSER  with M_NFSSER
      replace NFSDTE  with M_NFSDTE
      replace NFSCLI  with M_NFSCLI
      replace NFSTRA  with M_NFSTRA
      replace NFSFRC  with M_NFSFRC
      replace NFSPOR  with M_NFSPOR

      replace NFSTDC  with M_NFSTDC
      replace NFSDOC  with M_NFSDOC
      replace NFSDSE  with M_NFSDSE

      replace NFSVOL  with M_NFSVOL
      replace NFSMAR  with M_NFSMAR
      replace NFSNEB  with M_NFSNEB
      replace NFSITE  with M_NFSITE
      replace NFSIND  with M_NFSIND
      replace NFSHIS  with M_NFSHIS
      if M_NFSHIS = "S"
        replace NFSHS1  with M_HIS[1]
        replace NFSHS2  with M_HIS[2]
        replace NFSHS3  with M_HIS[3]
        replace NFSHS4  with M_HIS[4]
        replace NFSHS5  with M_HIS[5]
        replace NFSHS6  with M_HIS[6]
      endif
      replace NFSAPL  with M_NFSAPL
      replace NFSDTS  with M_NFSDTS
      replace NFSHOR  with M_NFSHOR
      replace NFSCAN  with M_NFSCAN
      replace NFSCPL  with M_NFSCPL
      if M_NFSCPL = "S"
        replace NFSCPL1 with M_CPL[1]
        replace NFSCPL2 with M_CPL[2]
        replace NFSCPL3 with M_CPL[3]
        replace NFSCPL4 with M_CPL[4]
        replace NFSCPL5 with M_CPL[5]
        replace NFSCPL6 with M_CPL[6]
      endif
      replace NFSCOM  with M_NFSCOM
      replace NFSSIT  with M_NFSSIT
      replace NFSNATN with M_NFSNATN
      replace NFSNAT  with M_NFSNAT
      replace NFSVLM  with M_NFSVLM
      replace NFSVLS  with M_NFSVLS
      replace NFSBIC  with M_NFSBIC
      replace NFSVIC  with M_NFSVIC
      replace NFSDSC  with M_NFSDSC
      replace NFSDSS  with M_NFSDSS
      replace DSCNFS  with M_DSCNFS
      replace NFSVEN  with M_NFSVEN
      replace NFSCPG  with M_NFSCPG  
      replace NFSFRE  with M_NFSFRE
      replace NFSSEG  with M_NFSSEG
      replace NFSDSP  with M_NFSDSP
      replace NFSVLN  with M_NFSVLN
      replace NFSVLD  with M_NFSVLD  
      replace NFSTRI  with M_NFSTRI  
      replace NFSISE  with M_NFSISE  
      replace NFSRED  with M_NFSRED  
      replace NFSOUT  with M_NFSOUT  
      replace NFSVIP  with M_NFSVIP  
      replace NFSIPL  with " "
      replace NFSITE  with M_NFSITE  
      replace NFSESP  with M_NFSESP
      unlock
      exit 
    else
      msw("* * * (ANFS00) REGISTRO SENDO USADO * * *")
    endif
    if lastkey()=17
      exit
    endif
  enddo

return ""

****************
function GRNFS01
****************

select ANFS01

do while .t.
  dbseek(str(M_NFSEMP, 2, 0) + str(M_NFSNUM, 6, 0) + M_NFSSER,.t.)

  if !str(NFSEMP, 2, 0) + str(NFSNUM, 6, 0) + NFSSER  == str(M_NFSEMP, 2, 0) + str(M_NFSNUM, 6, 0) + M_NFSSER 
    exit
  endif
  elimina()
enddo

for R = 1 to len(M_NFSMAT)

  APCA00->(dbseek(str(M_NFSMAT[R, 3], 6, 0)))

  select ANFS01                      && seleciona NFS itens 

  _append("ANFS01") 

*                     1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18
*                     SEQ PSQ MAT QDE PRB VLI LIQ BIC VIC ISE OUT DSP VIP COM ISI OUI OBS NAT

  do while .t.
    if rlock()
      replace NFSEMP  with M_NFSEMP
      replace NFSNUM  with M_NFSNUM
      replace NFSSER  with M_NFSSER
      replace NFSSEQ  with M_NFSMAT[R,01]
      replace NFSMAT  with M_NFSMAT[R,03]
      replace NFSQDE  with M_NFSMAT[R,04]
      replace NFSPRB  with M_NFSMAT[R,05]
      replace NFSVLI  with M_NFSMAT[R,06]
      replace NFSLIQ  with M_NFSMAT[R,07]
      replace NFSVIC  with M_NFSMAT[R,09]
      replace NFSBIC  with M_NFSMAT[R,08]
      replace NFSISE  with M_NFSMAT[R,10]
      replace NFSOUT  with M_NFSMAT[R,11]
      replace NFSDSP  with M_NFSMAT[R,12]
      replace NFSBIP  with iif(M_NFSMAT[R, 13]>0,M_NFSMAT[R,07],0)
      replace NFSVIP  with M_NFSMAT[R,13]
      replace NFSCOM  with M_NFSMAT[R,14]
      replace NFSISI  with M_NFSMAT[R,15]
      replace NFSOUI  with M_NFSMAT[R,16]
      replace NFSOBS  with M_NFSMAT[R,17]
      replace NFSNATN with M_NFSMAT[R,18]
      replace NFSDTE  with M_NFSDTE
      replace NFSEST  with M_CLIUF2 
      replace NFSCAN  with M_NFSCAN
      replace NFSPIC  with iif(M_NFSMAT[R, 9] > 0,M_NFSMAT[R,25],0)
      replace NFSPIP  with iif(AFIS00->FISIPI="S",zPCAIPI,0)
      exit
    else
      msw("* * * (ANFS01) REGISTRO SENDO USADO * * *") 
    endif
    if lastkey()=17
      exit
    endif
  enddo

next

return ""

******************
function GRAVA_NFE
******************

  select ANFE00

        replace NFEEMP   with M_NFSEMP
        replace NFENUM   with M_NFSNUM 
        replace NFESER   with M_NFSSER 
        replace NFEFOR   with M_NFSCLI 
        replace NFEDTR   with M_NFSDTE 
        replace NFEDTE   with M_NFSDTE 
        replace NFENATN  with M_NFSNATN
        replace NFEAPL   with M_NFSAPL 
        replace NFECPG   with M_NFSCPG 
        replace NFEVLM   with M_NFSVLM 
        replace NFEBIC   with M_NFSBIC 
        replace NFEVIC   with M_NFSVIC 
        replace NFEVIP   with M_NFSVIP 
        replace NFEVLN   with M_NFSVLN 
        replace NFESIT   with "L"
        replace NFEIPL   with "I"

return ""

******************
function GRAVA_NFS
******************

      replace NFSEMP  with M_NFSEMP
      replace NFSNUM  with M_NFSNUM
      replace NFSSER  with M_NFSSER
      replace NFSTDC  with M_NFSTDC
      replace NFSDOC  with M_NFSDOC
      replace NFSDSE  with M_NFSDSE
      replace NFSDTE  with M_NFSDTE
      replace NFSCLI  with M_NFSCLI
      replace NFSTRA  with M_NFSTRA
      replace NFSFRC  with M_NFSFRC
      replace NFSPOR  with M_NFSPOR
      replace NFSAPL  with M_NFSAPL
      replace NFSDTS  with M_NFSDTS
      replace NFSHOR  with M_NFSHOR
      replace NFSCAN  with M_NFSCAN
      replace NFSCPL  with M_NFSCPL
      replace NFSSIT  with M_NFSSIT
      replace NFSVIP  with M_NFSVIP
      replace NFSIND  with M_NFSIND
      replace NFSHIS  with M_NFSHIS
      if M_NFSHIS = "S"
        replace NFSHS1  with M_HIS[1]
        replace NFSHS2  with M_HIS[2]
        replace NFSHS3  with M_HIS[3]
        replace NFSHS4  with M_HIS[4]
        replace NFSHS5  with M_HIS[5]
        replace NFSHS6  with M_HIS[6]
      endif

      replace DUPVC1  with M_DUPVC1
      replace DUPDP1  with M_DUPDP1
      replace DUPVC2  with M_DUPVC2
      replace DUPDP2  with M_DUPDP2
      replace DUPVC3  with M_DUPVC3
      replace DUPDP3  with M_DUPDP3
      replace DUPVC4  with M_DUPVC4
      replace DUPDP4  with M_DUPDP4
      replace DUPVC5  with M_DUPVC5
      replace DUPDP5  with M_DUPDP5
      replace DUPVC6  with M_DUPVC6
      replace DUPDP6  with M_DUPDP6

      if M_NFSCPL = "S"
        replace NFSCPL1 with M_CPL[1]
        replace NFSCPL2 with M_CPL[2]
        replace NFSCPL3 with M_CPL[3]
        replace NFSCPL4 with M_CPL[4]
        replace NFSCPL5 with M_CPL[5]
        replace NFSCPL6 with M_CPL[6]
      endif
      replace NFSCOM  with M_NFSCOM
      replace NFSNATN with M_NFSNATN
      replace NFSVLM  with M_NFSVLM
      replace NFSVLS  with M_NFSVLS
      replace NFSBIC  with M_NFSBIC
      replace NFSVIC  with M_NFSVIC
      replace NFSDSC  with M_NFSDSC
      replace NFSDSS  with M_NFSDSS
      replace NFSVEN  with M_NFSVEN
      replace NFSCPG  with M_NFSCPG  
      replace NFSFRE  with M_NFSFRE
      replace NFSSEG  with M_NFSSEG
      replace NFSDSP  with M_NFSDSP
      replace NFSVLN  with M_NFSVLN
      replace NFSVLD  with M_NFSVLD  
      replace NFSTRI  with M_NFSTRI  
      replace NFSISE  with M_NFSISE  
      replace NFSRED  with M_NFSRED  
      replace NFSOUT  with M_NFSOUT  
      replace NFSVOL  with M_NFSVOL
      replace NFSITE  with M_NFSITE  
      replace NFSESP  with M_NFSESP

return ""

******************
function CHAMA_REQ
******************
local AA,BB
R = 1

for AA = 1 to 30

  if M_REQ[AA] = 0
    loop
  endif

  BUSCAREGISTRO("AREQ01",1,{str(ME_EMP, 2, 0),str(M_REQ[AA], 6, 0),aspas(M_NFSDSE)},"SELECT")

  do while !eof()

    BUSCAREGISTRO("APCA00",1,{str(AREQ01->REQMAT,6,0)},"SELECT")

    if empty(APCA00->PCANCM)
      msgbox1({"NCM NAO CADASTRADO","PRODUTO: ",str(APCA00->PCAMAT,6)})
      return .f.
    endif

    if !BUSCAREGISTRO("ANCM00",1,{APCA00->PCANCM},"SELECT")
      msg("* * * Produto: " + str(APCA00->PCAMAT, 6) + " TRIBUTO NCM NAO CADASTRADO * * *")
      return .f.
    endif

    select AREQ01
    
    if len(M_NFSMAT) = 0
      aadd(M_NFSMAT,{0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, "                   ",space(5)  ,0,space(40)," ",0,space(10),ctod("  /  /  "),0})
      M_NFSMAT[R,1]=R
      M_NFSMAT[R,3]=REQMAT
      M_NFSMAT[R,4]=REQQDE
      M_NFSMAT[R,5]=REQVLI/REQQDE
      M_NFSMAT[R,6]=REQVLI
      M_NFSMAT[R,20]=APCA00->PCADES
      R++
    else
      lAchei = .f.
      for BB = 1 to len(M_NFSMAT)
        if AREQ01->REQMAT == M_NFSMAT[BB,3]
          M_NFSMAT[BB,4]+=REQQDE
          M_NFSMAT[BB,6]+=REQVLI
          M_NFSMAT[BB,5]=(M_NFSMAT[BB,6]/M_NFSMAT[BB,4])
          lAchei = .t.
        endif
      next
      if !lAchei
        aadd(M_NFSMAT,{0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, "                   ",space(5)  ,0,space(40)," ",0,space(10),ctod("  /  /  "),0})
        M_NFSMAT[R,1]=R
        M_NFSMAT[R,3]=REQMAT
        M_NFSMAT[R,4]=REQQDE
        M_NFSMAT[R,5]=REQVLI/REQQDE
        M_NFSMAT[R,6]=REQVLI
        M_NFSMAT[R,20]=APCA00->PCADES
        R++
      endif
    endif

    num_mens()

    skip
 
  enddo

next

return .t.

******************
function CHAMA_PED
******************

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"APED01","APED01"})
  aadd(sqlCAMPO,"APED01.*")
  aadd(sqlCAMPO,"APCA00.PCAMAT")
  aadd(sqlCAMPO,"APCA00.PCADES")
  aadd(sqlCAMPO,"APCA00.PCALOT")
  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","APED01.PEDMAT"})
  aadd(sqlCHAVE,"PEDNUM = " + str(M_NFSDOC, 6, 0))
  aadd(sqlCHAVE,"PEDEMP = " + str(M_NFSEMP, 2, 0))
  aadd(sqlCHAVE,"PEDSER = " + aspas(M_NFSDSE))
  aadd(sqlORDEM,"PEDNUM,PCADES")
  if !sqlrelation()
    return .f.
  endif

  R = 1

  do while !eof()

    aadd(M_NFSMAT,{0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, "                   ",space(5)  ,0,space(40)," ",0,space(10),ctod("  /  /  "),0})

    M_NFSMAT[R,1 ]=PEDSEQ
    M_NFSMAT[R,3 ]=PEDMAT
    M_NFSMAT[R,4 ]=PEDQDE
    M_NFSMAT[R,5 ]=PEDVLI/PEDQDE
    M_NFSMAT[R,6 ]=PEDVLI
    M_NFSMAT[R,20]=PCADES
    M_R = R


    num_mens()

    R++

    select APED01
    
    skip
 
  enddo

return .t.

******************
function CHAMA_PRE
******************

  select AORC01

  dbseek(str(M_NFSEMP, 2, 0) + str(M_NFSDOC, 6, 0) + M_NFSDSE,.t.)

  if !str(ORCEMP, 2, 0) + str(ORCNUM, 6, 0) + ORCSER == str(M_NFSEMP, 2, 0) + str(M_NFSDOC, 6, 0) + M_NFSDSE
    return .f.
  endif

  R = 1

  do while !eof()

    if !str(ORCEMP, 2, 0) + str(ORCNUM, 6, 0) + ORCSER == str(M_NFSEMP, 2, 0) + str(M_NFSDOC, 6, 0) + M_NFSDSE
      exit
    endif

    APCA00->(dbseek(str(AORC01->ORCMAT, 6, 0)))
    valorespro(AORC01->ORCMAT)    

    aadd(M_NFSMAT,{0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, "                   ",space(5)  ,0,space(40)," ",0,space(10),ctod("  /  /  "),0})

    M_NFSMAT[R,1 ]=ORCSEQ
    M_NFSMAT[R,3 ]=ORCMAT
    M_NFSMAT[R,4 ]=ORCQDE
    M_NFSMAT[R,5 ]=ORCVLI/ORCQDE
    M_NFSMAT[R,6 ]=ORCVLI
    M_NFSMAT[R,20]=zPCADES

    num_mens()

    R++
   
    skip
 
  enddo

return .t.



*****************
function CALC_DSC
*****************

private M_TOTPRO ,;
        M_TOTIPI

  M_TOTPRO = 0
  M_TOTIPI = 0

  for S = 1 to len(M_NFSMAT)
    if M_NFSMAT[S,3] = 0
      loop
    endif
    valorespro(M_NFSMAT[S,3])
    M_TOTPRO = M_TOTPRO + M_NFSMAT[S,6]
    M_TOTIPI = M_TOTIPI + (M_NFSMAT[S,6] * iif(AFIS00->FISIPI="S",zPCAIPI,0))
  next && r

return .t.

******************  
function MONTA_CLA
******************

private R

  for R = 1 to 4
    if M_CLA[R] = pad(zPCACLA, 12)
      exit
    endif  
    if empty(M_CLA[R])
      M_CLA[R] = pad(zPCACLA, 12)
      exit
    endif
  next

return ""

***************
function NUMNFS
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
    @ 12, 27 say         "³ Nota Fiscal:          ³"
    @ 13, 27 say         "³ Serie Nota :          ³"
    @ 14, 27 say         "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
  set color to

  M_NOME = teclando(06, 12, 42,"GR+/BG+")
  M_NSER = teclando(02, 13, 42,"GR+/BG+")

  if lastkey() = 27
    exit
  endif

  M_NOVNUM = val(M_NOME)
  M_NOVSER = M_NSER      

  select ANFS00

  if dbseek(str(M_NFSEMP, 2, 0) + str(M_NOVNUM, 6, 0) + M_NOVSER)
    msg("* * * NOTA FISCAL JA CADASTRADA * * *")
    loop
  endif

  M_FLG   = .f.
  M_NFSNUM = M_NOVNUM
  M_NFSSER = M_NOVSER

  set color to I
    @ 04, 15 say     M_NFSNUM picture "######"  
    @ 04, 22 say     M_NFSSER picture "@!"      
  set color to 

  if M_NFSNUM = 0 
    loop
  endif

  if empty(M_NFSSER)
    msg("* * * SERIE NAO PODE ESTAR VAZIA * * *")
    loop
  endif

  exit

enddo

restscreen(11, 25, 15, 54, M_TELA)

return ""

***************
function MOSNFS
***************

parameters  M_MODO, M_ELEM, M_POSI

  if str(lastkey(), 2, 0) $ " 3#27#18"
    return 0
  endif

  nPosach = M_ELEM

  if str(lastkey(), 3, 0)  $ "# 49# 50# 51# 52# 53# 54# 13"
    M_OPC = M_ELEM
    return 1
  endif

  valorespro(val(substr(M_VETORITE[M_ELEM], 4, 6)))

  M_LINPOS = M_POSI

return 2

***************
function BOLNFS
***************

private M_NOME  ,;
        M_NSER  ,;
        M_TELA  ,;
        M_DATA  ,;
        M_DUPNUM,;
        M_DUPORD

  save get to M_GETANT

  M_TELA = savescreen(08, 26, 18, 54)

  store M_NFSNUM-1         to M_DUPNUM1,;
                              M_DUPNUM2
  store 0                  to M_DUPORD1,;
                              M_DUPORD2,;
                              M_DUPDSC
  store 12                 to M_JUROS 
  store AEMP00->EMPBOL + 1 to M_DUPBOL

  store " "                to M_BOL01, M_BOL02, M_BOL03

  do while .t.
 
    sombra(08, 26, 17, 52,_SOMBRA_)

    set color to GR+/BG+
      @ 08, 26 say      "ÚÄÄÄÄÄBoleto BancarioÄÄÄÄÄ¿"
      @ 09, 26 say      "³Titulo Inicial:       /  ³"
      @ 10, 26 say      "³         Final:       /  ³"
      @ 11, 26 say      "³      Desconto:          ³"
      @ 12, 26 say      "³        Boleto:          ³"
      @ 13, 26 say      "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
      @ 14, 26 say      "³     Santander:          ³"
      @ 15, 26 say      "³    Bamerindus:          ³"
      @ 16, 26 say      "³          Itau:          ³"
      @ 17, 26 say      "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
    set color to

    SetColor(_COREDICAO_)
    @ 09, 43 get M_DUPNUM1 picture "######"
    @ 09, 50 get M_DUPORD1 picture "##"
    @ 10, 43 get M_DUPNUM2 picture "######"
    @ 10, 50 get M_DUPORD2 picture "##"
    @ 11, 43 get M_DUPDSC  picture "######.##"
    @ 12, 43 get M_DUPBOL  picture "#######"
    @ 14, 43 get M_BOL01 picture "@!" valid M_BOL01 $ "X "
    @ 15, 43 get M_BOL02 picture "@!" valid M_BOL02 $ "X "
    @ 16, 43 get M_BOL03 picture "@!" valid M_BOL03 $ "X "
    read

    if lastkey() = 27
      exit
    endif

    if empty(M_BOL01)
      if empty(M_BOL02)
        if empty(M_BOL03)
          msg("* * * O LAYOUT DO BANCO NAO FOI SELECIONADO * * *")
          loop 
        endif
      endif
    endif
        

    M_DUPNUM1 = iif(M_DUPNUM1 = 0,     1,M_DUPNUM1)
    M_DUPNUM2 = iif(M_DUPNUM2 = 0,999999,M_DUPNUM2) 

    M_DUPORD1 = iif(M_DUPORD1 = 0, 0,M_DUPORD1)
    M_DUPORD2 = iif(M_DUPORD2 = 0,99,M_DUPORD2) 

    exit

  enddo

  if lastkey() = 27
    restore get from M_GETANT
    restscreen(08, 26, 18, 54, M_TELA)
    setcursor(1)
    return ""
  endif

  M_IMPRE = imprebl()

  if M_IMPRE = "N"
    restore get from M_GETANT
    restscreen(08, 26, 18, 54, M_TELA)
    setcursor(1)
    return ""
  endif

 ?? chr(27) + "x" + "1"
 ?? chr(27) + "M"
 ?? chr(27) + "0"

  select ADCR00

  dbsetorder(1)

  dbseek(str(ME_EMP, 2, 0) + str(M_DUPNUM1, 6, 0) + str(M_DUPORD1, 2, 0),.t.)

  if eof() .or. str(DUPEMP, 2, 0) + str(DUPNUM, 6, 0) + str(DUPORD, 2, 0) > str(ME_EMP, 2, 0) + str(M_DUPNUM2, 6, 0) + str(M_DUPORD2, 2, 0)
    msg("* * * NENHUM TITULO A EMITIR * * *")
    restore get from M_GETANT
    restscreen(08, 26, 18, 54, M_TELA)
    setcursor(1)
  endif

  do while !eof()
  
    if eof() .or. str(DUPEMP, 2, 0) + str(DUPNUM, 6, 0) + str(DUPORD, 2, 0) > str(ME_EMP, 2, 0) + str(M_DUPNUM2, 6, 0) + str(M_DUPORD2, 2, 0)
       go bottom
       skip
       loop
    endif

    if DUPSER != "M1"
      skip
      loop
    endif

    valorescli(ADCR00->DUPCLI)
    ACPG00->(dbseek(str(ADCR00->DUPCPG, 3, 0)))

    do while .t.
      if rlock()
        replace  DUPBOL   with  M_DUPBOL 
        replace  DUPDSC   with  M_DUPDSC 
        replace  DUPPOR   with  1
        unlock
        exit
      else
        msw("* * * (ADCR00) REGISTRO SENDO USADO * * *") 
      endif
      if lastkey()=17
        exit
      endif
    enddo

    if !empty(M_BOL01)
      lay_san(DUPVLA)
    else
      if !empty(M_BOL02)
        lay_bam(DUPVLA)
      else
        if !empty(M_BOL03)
          lay_ita(DUPVLA)
        endif
      endif
    endif

    select AEMP00                    && seleciona empresa e grava ultima nota fiscal

    do while .t.
      if rlock()
        replace EMPBOL with M_DUPBOL
        unlock
        exit
      else
        msw("* * * (AEMP00) REGISTRO SENDO USADO * * *")
        if lastkey()=17 
          exit
        endif
      endif
    enddo

    select ADCR00

    M_DUPBOL++

    skip

  enddo

  ?? chr(27) + "@"

  desliga1()

  restore get from M_GETANT

  restscreen(08, 26, 18, 54, M_TELA)

  setcursor(1)

return ""

*****************
function CONTRA01
*****************

  local aPesq := {"/","|","\","-"}

  do while .t.


    rodape("CONSULTA", "CLIENTE", M_FAN, "EAGRO21","Mem: " + str(memory(0), 5), M_EMP)

    tlnfs02()

    M_PEDEMP  = ME_EMP
    M_NFSCLI  = 0
    M_TECLA   = 0

    SetColor(_COREDICAO_)
    @ 04, 15 get M_NFSCLI picture "#######"
    read

    if lastkey() = 27
      exit
    endif

    if !valorescli(M_NFSCLI)
      msg("* * * CLIENTE NAO CADASTRADO * * *")
      loop
    endif
    
    set color to I
      @ 04, 29 say pad(zCLINOM, 29)
      @ 04, 64 say pad(zCLIMUN2, 12)
    set color to 
 
    select ANFS00
    set order to 4
    dbseek(str(ME_EMP, 2, 0) + str(M_NFSCLI, 7, 0),.t.)

    MT_ITENS = { }
    M_QDE  = 0
    M_QDE1 = 1 

    do while !eof()

      msw("Aguarde!!! Processando... " + aPesq[M_QDE1] )

      if NFSCLI # M_NFSCLI
        exit 
      endif
 
      M_QDE ++
         
      if M_QDE > 50
        M_QDE1 ++
        if M_QDE1 = 5
          M_QDE1 = 1
        endif
        M_QDE = 0 
      endif

      ATRA00->(dbseek(str(ANFS00->NFSTRA, 3, 0)))
      aadd(MT_ITENS,dtoc(NFSDTE) + "³" + str(NFSNUM, 6) + "³" + NFSSER+ "³" + str(NFSCPG, 3) +  "³" + pad(str(NFSTRA,2) + " - " + ATRA00->TRANOM,36)  + "³" + transform(NFSVLN,"@E ####,###.##"))

      if len(MT_ITENS) = 12
        exit
      endif

      skip

    enddo

    set color to N/W,W+/N
    achoice(08,05,19,75,MT_ITENS,,"mos001")
    setcolor("")

  enddo

  select ANFS00
  set order to 1

return ""

****************
function TLNFS02
****************

sombra(03, 04, 20, 76,_SOMBRA_)

set color to I
    @ 03, 04 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
    @ 04, 04 say     "³Cliente :         Nome:                               Mun:             ³"
    @ 05, 04 say     "ÃÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÂÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ´"
    @ 06, 04 say     "³  Data  ³NumNfs³Se³Cpg³  Transportadora                    ³  Total    ³"
    @ 07, 04 say     "ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄ´"
    for zz = 8 to 19
    @ zz, 04 say     "³        ³      ³  ³   ³                                    ³           ³"
    next
    @ 20, 04 say     "ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÁÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÙ"
set color to 

return ""

***************
function MOS001
***************

parameters  M_MODO, M_ELEM, M_POSI

 if rat(str(lastkey(), 2, 0),"27") > 0
    return 0
 endif

return 2

****************
function VERVIAS
****************

  LNPRO = 0
  LNMEM = 0

  if M_NFSHIS = "S"
    LNPRO = LNPRO + 6
  endif

  if M_DSCNFS > 0 
    LNPRO += 3
  endif

*  if zPCAIPI  > 0 
*    LNPRO = LNPRO + 1
*  endif

  for A = 1 to len(M_NFSMAT)
    if M_NFSMAT[A,3] = 1 // FRETE
      loop
    endif
    APCA00->(dbseek(str(M_NFSMAT[A,3],6,0)))
    num_mens()                      && conta mensagens
    LNPRO ++
    LNMEM ++
  next

  if LNPRO > 12
    return int((LNPRO/12)) + iif((LNPRO % 12)>0,1,0)
  else
    return 1
  endif

*************
function NULO
*************

return ""

******************
function CAB_NFS10
******************

 PG = PG + 1

 if PG > 1
   eject
 endif

 ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE NOTAS FISCAIS DE SAIDA","EAGRO21",132) 
 ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)

 LN = 2

return ""

****************
function MUDAFIS
****************

select AKAR00
set order to 0
go top

do while !eof()

  gauge()

  do while .t.
    if rlock()
      replace KARFISN with novofis(KARFIS)
      unlock
      exit
    endif
  enddo
 
  skip

enddo

select ADCP00
set order to 0
go top

do while !eof()
  gauge()

  do while .t.
    if rlock()
      replace DUPFISN with novofis(DUPFIS)
      unlock
      exit
    endif
  enddo
 
  skip

enddo

select ANFS00
set order to 0
go top

do while !eof()

  gauge()

  do while .t.
    if rlock()
      replace NFSNATN with novofis(NFSNAT)
      unlock
      exit
    endif
  enddo
 
  skip

enddo


select ANFS01
set order to 0
go top

do while !eof()

  gauge()

  do while .t.
    if rlock()
      replace NFSNATN with novofis(NFSNAT)
      unlock
      exit
    endif
  enddo
 
  skip

enddo

select APED00
set order to 0
go top

do while !eof()

  gauge()

  do while .t.
    if rlock()
      replace PEDNATN with novofis(PEDNAT)
      unlock
      exit
    endif
  enddo
 
  skip

enddo


select APED01
set order to 0
go top

do while !eof()
  gauge()

  do while .t.
    if rlock()
      replace REQNATN with novofis(REQNAT)
      unlock
      exit
    endif
  enddo
 
  skip

enddo


select ANFE00
set order to 0
go top

do while !eof()
  gauge()

  do while .t.
    if rlock()
      replace NFENATN with novofis(NFENAT)
      unlock
      exit
    endif
  enddo
 
  skip

enddo

select ANFE01
set order to 0
go top

do while !eof()
  gauge()

  do while .t.
    if rlock()
      replace NFENATN with novofis(NFENAT)
      unlock
      exit
    endif
  enddo
 
  skip

enddo


select ADCR00
set order to 0
go top

do while !eof()
  gauge()

  do while .t.
    if rlock()
      replace DUPFISN with novofis(DUPFIS)
      unlock
      exit
    endif
  enddo
 
  skip

enddo

select APEN00
set order to 0
go top

do while !eof()
  gauge()

  do while .t.
    if rlock()
      replace PENFISN with novofis(PENFIS)
      unlock
      exit
    endif
  enddo
 
  skip

enddo

select AREQ00
set order to 0
go top

do while !eof()
  gauge()

  do while .t.
    if rlock()
      replace REQNATN with novofis(REQNAT)
      unlock
      exit
    endif
  enddo
 
  skip

enddo


**********************
function NOVOFIS(TIPO)
**********************

do case
   case TIPO = 10000
        return "1.000"
   case TIPO = 11200
        return "1.102"
   case TIPO = 11212
        return "1.102"
   case TIPO = 11218
        return "1.102"
   case TIPO = 13200
        return "1.202"
   case TIPO = 19100
        return "1.551"
   case TIPO = 19118
        return "1.551"
   case TIPO = 19300
        return "1.556"
   case TIPO = 19501 // ACERTO ESTOQUE SAIDA
        return "1.991"
   case TIPO = 19502  // ACERTO ESTOQUE ENTRADA
        return "1.992"
   case TIPO = 19900
        return "1.949"
   case TIPO = 19901
        return "1.949"
   case TIPO = 21200
        return "2.102"
   case TIPO = 21212
        return "2.102"
   case TIPO = 21218
        return "2.102"
   case TIPO = 23200
        return "2.202"
   case TIPO = 29900
        return "2.556"
   case TIPO = 51200
        return "5.102"
   case TIPO = 51201
        return "5.102"
   case TIPO = 51204
        return "5.104"
   case TIPO = 53200
        return "5.202"
   case TIPO = 59300
        return "5.915"
   case TIPO = 59900
        return "5.949"
   case TIPO = 59901
        return "5.909"
   case TIPO = 59907
        return "5.910"
   case TIPO = 59918
        return "5.910"
   case TIPO = 60000
        return "6.000"
   case TIPO = 61200
        return "6.102"
   case TIPO = 61900
        return "6.108"
   case TIPO = 63200
        return "6.202"
   case TIPO = 50000
        return "5.000"
end case

return "9.999"

****************
function CAB_RNF  // Cabecalho do relatorio de notas no periodo
****************

PG++ 

if PG > 1
  ?
  eject
endif

? cent_cab(AEMP00->EMPFAN,"RELACAO SINTETICA DE NOTAS FISCAIS - " + iif(M_TIPNOT=="S","SAIDA","ENTRADA"),"EAGRO21",132) 
? cent_cab(M_DATA,"PERIODO: " + dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
? "*------*--*-----------------------------------*-*---*--*--------*---*------------*------*------------*--------------*--------------*"
? "*  NF  *SR*   NOME                            *T*CPG*UF* EMISSAO*VEN* VALOR NOTA * CFOP *   OUTRAS   *    A VISTA   *   A PRAZO    *"
? "*------*--*-----------------------------------*-*---*--*--------*---*------------*------*------------*--------------*--------------*"
*   999999 XX 9999999 AAAAAAAAAAAAAAXXXXXXXXXXXXX X 999

store 5 to LN

return ""

******************
function LISNFS_IA                      && relacao de notas no periodo (Antigo)
******************

private M_TOTAL ,;
        M_DATA1 ,;
        M_DATA2 ,;
        PG, LN  ,;
        M_TOTGER,;
        M_TOTVIS,;
        M_TOTPRZ,;
        M_SOMPER,;
        M_TELA 
                   
    rodape("SINTETICO","NOTA",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP)

    store date() to M_DATA1 ,;
                    M_DATA2


    store 0      to M_DUPCLI,;
                    M_NFSCLI1,;
                    M_NFSCLI,;
                    M_CODINI,;
                    M_CODFIN,;
                    M_NFSVEN

     M_MOEDA = "R" 
     M_ENTRADA = " "
     NTOTNOT = 0
     NQDENOT = 0
     M_RESUMO = " "

     sombra(12, 35, 19, 72,_SOMBRA_)
     set color to GR/W
       @ 12, 35 say   "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
       @ 13, 35 say   "³Resumo <D>iario / <M>ensal:         ³" 
       @ 14, 35 say   "³Periodo Inicial:          a         ³" 
       @ 15, 35 say   "³       Cliente :                    ³" 
       @ 16, 35 say   "³     Fornecedor:          a         ³" 
       @ 17, 35 say   "³  Entrada/Saida:                    ³" 
       @ 18, 35 say   "³       Vendedor:                    ³" 
       @ 19, 35 say   "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
     set color to 

     SetColor(_COREDICAO_)
     @ 13, 64 get     M_RESUMO   picture "@!"  valid M_RESUMO  $ "DM"
     @ 14, 53 get     M_DATA1
     @ 14, 64 get     M_DATA2
     @ 15, 53 get     M_DUPCLI picture "#######"
     @ 16, 53 get     M_NFSCLI1 picture "#######" valid vernfs25()
     @ 16, 64 get     M_CODFIN picture "#######"
     @ 17, 53 get     M_ENTRADA  picture "@!"  valid M_ENTRADA $ "ES"
     @ 18, 53 get     M_NFSVEN picture "999"
     read

     if lastkey() = 27
        return ""
     endif

     if M_ENTRADA == "S"
       select ANFS00
       set order to 3 
       go top
       dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)
       if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2) .or. str(NFSEMP, 2, 0) + dtos(NFSDTE) < str(ME_EMP, 2, 0) + dtos(M_DATA1)
         msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
         return ""
       endif
       select ANFS00
       set relation to NFSNATN into AFIS00 
     else
       select ANFE00
       set order to 2 
       go top
       dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)
       if str(NFEEMP, 2, 0) + dtos(NFEDTR) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
         msg( "* * * NADA A SER LISTADO NO INTERVALO * * *")
         return ""
       endif  
       select ANFE00
       set relation to NFENATN into AFIS00 
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
                    M_NFSOUT,;
                    M_NFSVIS,;
                    M_NFSPRZ,;
                    M_NFSAPR,;
                    M_NFSSUB,;
                    M_NFSSER,;
                    M_NFSENT,;
                    M_TOTOUT,;
                    M_TOTVIS,;
                    M_TOTPRZ,;
                    M_TOTAPR,;
                    M_TOTENT,;
                    M_TOTSUB,;
                    M_TOTSER,;
                    M_TOTCAN

        M_NFSDTE = ctod("  /  /  ")

        store space(5) to  M_NATANT
          
        do while !eof()
                              
            store PG + 1 to  PG 

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"RELACAO SINTETICA DE NOTAS FISCAIS - " + iif(M_ENTRADA=="S","SAIDA","ENTRADA"),"EAGRO21",132) 
            ? cent_cab(M_DATA,"PERIODO: " + dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),132) 
            ? "*------*--*-----------------------------------*-*---*--*--------*---*------------*------*------------*--------------*--------------*"
            ? "*  NF  *SR*   NOME                            *T*CPG*UF* EMISSAO*VEN* VALOR NOTA * OPE  *   OUTRAS   *    A VISTA   *   A PRAZO    *"
            ? "*------*--*-----------------------------------*-*---*--*--------*---*------------*------*------------*--------------*--------------*"
*               999999 XX 9999999 AAAAAAAAAAAAAAXXXXXXXXXXXXX X 999

            store 5 to LN

            if M_NFSVEN > 0
              AVEN00->(dbseek(str(M_NFSVEN, 3, 0)))
              ?
              ? " Vendedor: " + AVEN00->VENNOM
              ?
              LN += 3
            endif
  
            do while !eof() .and. LN < 60

              if M_ENTRADA == "S"
                if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
                  go bottom
                  skip
                  loop
                endif 
                if M_NFSVEN > 0
                  if NFSVEN # M_NFSVEN
                    skip
                    loop
                  endif
                endif
              else
                if str(NFEEMP, 2, 0) + dtos(NFEDTR) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
                  go bottom
                  skip
                  loop
                endif 
              endif

              if M_RESUMO == "D"
                if iif(M_ENTRADA=="S",NFSDTE,NFEDTR) != M_NFSDTE .and. M_NFSVEN = 0
                  if M_NFSPRZ+M_NFSVIS+M_NFSAPR+M_NFSOUT+M_NFSENT > 0
                    ?    space(39) 
                    ?? "TOTAIS DO DIA . . . . . . . .    A VISTA " 
                    ?? transform(M_NFSVIS,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "                                 A PRAZO " 
                    ?? transform(M_NFSPRZ,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "                    (A VISTA +  A PRAZO) " 
                    ?? transform(M_NFSPRZ+M_NFSVIS+M_NFSAPR,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "OUTRAS SAIDAS . . . . . . . .            " 
                    ?? transform(M_NFSOUT,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "SUBSTITUICAO  . . . . . . . .            " 
                    ?? transform(M_NFSSUB,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "SERVICOS. . . . . . . . . . .            " 
                    ?? transform(M_NFSSER,"@E ##,###,###.##")
                    ? replicate("-", 132)
                    LN = LN + 6

                    store 0 to M_NFSOUT,;
                               M_NFSVIS,;
                               M_NFSSUB,;
                               M_NFSSER,;
                               M_NFSPRZ,;
                               M_NFSAPR,;
                               M_NFSENT
                  endif
                  M_NFSDTE = iif(M_ENTRADA=="S",NFSDTE,NFEDTR)
                endif
              else
                if iif(M_ENTRADA=="S",month(NFSDTE),month(NFEDTR)) != month(M_NFSDTE) .and. M_NFSVEN = 0
                  if M_NFSPRZ+M_NFSVIS+M_NFSAPR+M_NFSOUT+M_NFSENT > 0
                    ?    space(39) 
                    ?? "TOTAIS DO MES . . . . . . . .    A VISTA " 
                    ?? transform(M_NFSVIS,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "                                 A PRAZO " 
                    ?? transform(M_NFSPRZ,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "                    (A VISTA +  A PRAZO) " 
                    ?? transform(M_NFSPRZ+M_NFSVIS+M_NFSAPR,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "OUTRAS SAIDAS . . . . . . . .            " 
                    ?? transform(M_NFSOUT,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "SUBSTITUICAO  . . . . . . . .            " 
                    ?? transform(M_NFSSUB,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "SERVICOS. . . . . . . . . . .            " 
                    ?? transform(M_NFSSER,"@E ##,###,###.##")
                    ? replicate("-", 132)
                    LN = LN + 7

                    store 0 to M_NFSOUT,;
                               M_NFSVIS,;
                               M_NFSSUB,;
                               M_NFSSER,;
                               M_NFSPRZ,;
                               M_NFSAPR,;
                               M_NFSENT
                  endif
                  M_NFSDTE = iif(M_ENTRADA=="S",NFSDTE,NFEDTR)
                endif
              endif

              if M_ENTRADA == "S"
                if M_DUPCLI > 0
                  if NFSCLI != M_DUPCLI
                    skip
                    loop
                  endif
                endif
              endif
 
              if M_ENTRADA == "S"
                if left(NFSNATN,1) < "5"
                  AFOR00->(dbseek(str(ANFS00->NFSCLI, 7, 0)))
                else
                  valorescli(NFSCLI)
                endif 
              else
                AFOR00->(dbseek(str(ANFE00->NFEFOR, 7, 0)))
              endif

              if M_ENTRADA == "S"
                if NFSCAN = "C"
                  ? " " 
                  ?? str(NFSNUM, 6, 0)
                  ?? " "
                  ?? NFSSER 
                  ?? " "
                  ?? str(NFSCLI, 7, 0) 
                  ?? " "
                  if left(NFSNATN,1) < "5"
                    ?? left(AFOR00->FORNOM, 40) 
                  else
                    ?? left(zCLINOM, 40) 
                  endif
                  ?? " *** CANCELADA *** " 

                  M_TOTCAN += NFSVLN

                  NTOTNOT += NFSVLN
                  NQDENOT ++

                  @ 24, 00 say str(NTOTNOT,12,2)
                  @ 24, 30 say str(NQDENOT,5)

                else
                  select ANFS00

                  M_NFSNATN = space(5)
                  M_VALSUB = 0  // VALOR SUBSTITUICAO
                  M_VALSER = 0  // VALOR SERVICOS
                  calc_nfs()

                  M_TOTSUB += M_VALSUB
                  M_NFSSUB += M_VALSUB
                  M_TOTSER += M_VALSER
                  M_NFSSER += M_VALSER

                  select ANFS00    
 
                  NTOTNOT += NFSVLN
                  NQDENOT ++

                  @ 24, 00 say str(NTOTNOT,12,2)
                  @ 24, 30 say str(NQDENOT,5)

                  ? " " 
                  ?? str(NFSNUM, 6, 0)
                  ?? " "
                  ?? NFSSER 
                  ?? " "
                  ?? str(NFSCLI, 7, 0) 
                  ?? " "
                  if left(NFSNATN,1) < "5"
                    ?? left(AFOR00->FORNOM, 27) 
                  else
                    ?? left(zCLINOM, 27) 
                    ?? " "
                    ?? zCLITIP
                  endif
                  ?? " " 
                  ?? str(NFSCPG, 03)
                  ?? " " 
                  if left(NFSNATN,1) < "5"
                    ?? AFOR00->FOREST
                  else
                    ?? zCLIUF2
                  endif
                  ?? " "
                  ?? NFSDTE
                  ?? " "
                  ?? str(NFSVEN, 3, 0)
                  ?? " "

                  if !NFSNATN $ "5.202"  // devolucao
                    if NFSCPG > 2 .and. NFSCPG <= 20
                      ?? transform(NFSVLN,"@E #,###,###.##")
                      ?? " "
                      ?? NFSNATN
                      ?? " "
                      ?? transform(NFSVLN - M_VALSUB,"@E #####,###.##")
                      M_NFSOUT = M_NFSOUT + NFSVLN //- M_VALSUB
                      M_TOTOUT = M_TOTOUT + NFSVLN //- M_VALSUB
                    else
                      AVISTA = 0
                      APRAZO = NFSVLN
                      for A = 1 to 6
                        MS = str(A,1)
                        if NFSDTE = DUPVC&MS
                          AVISTA += DUPDP&MS
                          APRAZO -= DUPDP&MS
                        endif
                      next

                      if AVISTA > 0
                        AVISTA -= M_VALSUB
                      else
                        APRAZO -= M_VALSUB
                      endif

                      if (AVISTA + APRAZO) > 0
                        ?? transform(NFSVLN,"@E #,###,###.##")
                        ?? " "
                        ?? NFSNATN
                        ?? " "
                        ?? space(14)
                        ?? " "
                        ?? transform(AVISTA,"@E@Z #####,###.##")
                        ?? " "
                        ?? transform(APRAZO,"@E@Z #####,###.##")
                        M_NFSVIS = M_NFSVIS + AVISTA
                        M_TOTVIS = M_TOTVIS + AVISTA
                        M_NFSPRZ = M_NFSPRZ + APRAZO
                        M_TOTPRZ = M_TOTPRZ + APRAZO
                      endif
                    endif
                  else
                    ?? transform(NFSVLN - M_VALSUB,"@E #####,###.##")
                    M_NFSOUT = M_NFSOUT + NFSVLN //- M_VALSUB
                    M_TOTOUT = M_TOTOUT + NFSVLN //- M_VALSUB
                  endif 

                  if M_VALSUB > 0  // se tem substituicao imprime
                    if (AVISTA + APRAZO) > 0
                      LN ++
                      ? space(69)
                    endif
                    ?? iif((AVISTA + APRAZO) > 0, space(12), transform(NFSVLN,"@E@Z #,###,###.##"))
                    ?? " "
                    ?? M_NFSNATN
                    ?? " "
                    if !NFSNATN $ "5.202"  // devolucao
                      if NFSCPG > 2 .and. NFSCPG <= 20
                        ?? transform(M_VALSUB,"@E #####,###.##")
                        M_NFSOUT = M_NFSOUT + M_VALSUB
                        M_TOTOUT = M_TOTOUT + M_VALSUB
                      else
                      AVISTA = 0
                      APRAZO = NFSVLN
                      for A = 1 to 6
                        MS = str(A,1)
                        if NFSDTE = DUPVC&MS
                          AVISTA += DUPDP&MS
                          APRAZO -= DUPDP&MS
                        endif
                      next

                        if AVISTA > 0
                          AVISTA = M_VALSUB
                        else
                          APRAZO = M_VALSUB
                        endif

                        ?? space(14)
                        ?? " "
                        ?? transform(AVISTA,"@E@Z #####,###.##")
                        ?? " "
                        ?? transform(APRAZO,"@E@Z #####,###.##")
                        M_NFSVIS = M_NFSVIS + AVISTA
                        M_TOTVIS = M_TOTVIS + AVISTA
                        M_NFSPRZ = M_NFSPRZ + APRAZO
                        M_TOTPRZ = M_TOTPRZ + APRAZO
                      endif
                    else
                      ?? transform(M_VALSUB,"@E #####,###.##")
                      M_NFSOUT = M_NFSOUT + NFSVLN //- M_VALSUB
                      M_TOTOUT = M_TOTOUT + NFSVLN //- M_VALSUB
                    endif 
                  endif

                endif
              else
                M_NFSVLN = NFEVLN
                select ANFE00
                ? " " 
                ?? str(NFENUM, 6, 0)
                ?? " "
                ?? NFESER 
                ?? " "
                ?? str(NFEFOR, 7, 0) 
                ?? " "
                ?? left(AFOR00->FORNOM, 27)
                ?? " " 
                ?? str(NFECPG, 03)
                ?? " " 
                ?? AFOR00->FOREST
                ?? " "
                ?? NFEDTR
                ?? " "
                ?? str(0, 3, 0)
                ?? " "
                ?? NFENATN
                ?? " "
                if NFENATN $ "1.912#2.912#1.911#2.911#1.910#2.910#1.202#2.202"
                  ?? transform(M_NFSVLN,"@E #####,###.##")
                  M_TOTENT = M_TOTENT + M_NFSVLN 
                  M_NFSENT = M_NFSENT + M_NFSVLN
                else
                  if NFECPG = 501
                    ?? space(14)
                    ?? " "
                    ?? transform(M_NFSVLN,"@E #####,###.##")
                    M_NFSVIS = M_NFSVIS + M_NFSVLN
                    M_TOTVIS = M_TOTVIS + M_NFSVLN
                  else
                    ?? space(29)
                    ?? " "
                    ?? transform(M_NFSVLN,"@E #####,###.##")
                    M_NFSPRZ = M_NFSPRZ + M_NFSVLN
                    M_TOTPRZ = M_TOTPRZ + M_NFSVLN
                  endif
                endif
              endif

               LN ++

              if M_ENTRADA == "S"                    
                select ANFS00
              else
                select ANFE00
              endif

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

      if LN > 53
         eject
      endif 

      if M_RESUMO == "D"
        if M_NFSVEN = 0
                if M_NFSPRZ+M_NFSVIS+M_NFSAPR+M_NFSOUT+M_NFSENT > 0
                  ?    space(39) 
                  ?? "TOTAIS DO DIA . . . . . . . .    A VISTA " 
                  ?? transform(M_NFSVIS,"@E ##,###,###.##")
                  ?    space(39) 
                  ?? "                                 A PRAZO " 
                  ?? transform(M_NFSPRZ,"@E ##,###,###.##")
                  ?    space(39) 
                  ?? "                     (A VISTA + A PRAZO) " 
                  ?? transform(M_NFSPRZ+M_NFSVIS+M_NFSAPR,"@E ##,###,###.##")
                  ?    space(39) 
                  ?? "OUTRAS SAIDAS . . . . . . . .            " 
                  ?? transform(M_NFSOUT,"@E ##,###,###.##")
                  ?    space(39) 
                  ?? "SUBSTITUICAO  . . . . . . . .            " 
                  ?? transform(M_NFSSUB,"@E ##,###,###.##")
                  ?    space(39) 
                  ?? "SERVICOS. . . . . . . . . . .            " 
                  ?? transform(M_NFSSER,"@E ##,###,###.##")
                  ? replicate("-", 132)
                  LN = LN + 7

                  store 0 to M_NFSOUT,;
                             M_NFSVIS,;
                             M_NFSPRZ,;
                             M_NFSSUB,;
                             M_NFSSER,;
                             M_NFSAPR,;
                             M_NFSENT
                endif
        endif
      else
                if iif(M_ENTRADA=="S",month(NFSDTE),month(NFEDTR)) != month(M_NFSDTE) .and. M_NFSVEN = 0
                  if M_NFSPRZ+M_NFSVIS+M_NFSAPR+M_NFSOUT+M_NFSENT > 0
                    ?    space(39) 
                    ?? "TOTAIS DO MES . . . . . . . .    A VISTA " 
                    ?? transform(M_NFSVIS,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "                                 A PRAZO " 
                    ?? transform(M_NFSPRZ,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "                    (A VISTA +  A PRAZO) " 
                    ?? transform(M_NFSPRZ+M_NFSVIS+M_NFSAPR,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "OUTRAS SAIDAS . . . . . . . .            " 
                    ?? transform(M_NFSOUT,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "SUBSTITUICAO  . . . . . . . .            " 
                    ?? transform(M_NFSSUB,"@E ##,###,###.##")
                    ?    space(39) 
                    ?? "SERVICOS. . . . . . . . . . .            " 
                    ?? transform(M_NFSSER,"@E ##,###,###.##")
                    ? replicate("-", 132)
                    LN = LN + 7

                    store 0 to M_NFSOUT,;
                               M_NFSVIS,;
                               M_NFSSUB,;
                               M_NFSSER,;
                               M_NFSPRZ,;
                               M_NFSAPR,;
                               M_NFSENT
                  endif
                  M_NFSDTE = iif(M_ENTRADA=="S",NFSDTE,NFEDTR)
                endif
      endif


       ?    replicate("-", 132)
       ?    space(39) 
        ?? "TOTAIS . . .  . . . . . . . .    A VISTA " 
        ?? transform(M_TOTVIS,"@E ##,###,###.##")
       ?    space(39) 
        ?? "                                 A PRAZO " 
        ?? transform(M_TOTPRZ,"@E ##,###,###.##")
       ?    space(39) 
        ?? "                     (A VISTA + A PRAZO) " 
        ?? transform(M_TOTPRZ+M_TOTVIS+M_TOTAPR,"@E ##,###,###.##")
       ?    space(39) 
        ?? "OUTRAS SAIDAS . . . . . . . .            " 
        ?? transform(M_TOTOUT,"@E ##,###,###.##")
       ?    space(39) 
        ?? "SUBSTITUICAO  . . . . . . . .            " 
        ?? transform(M_TOTSUB,"@E ##,###,###.##")
       ?    space(39) 
        ?? "SERVICOS. . . . . . . . . . .            " 
        ?? transform(M_TOTSER,"@E ##,###,###.##")
       ?    space(39) 
        ?? "CANCELADAS      . . . . . . .            " 
        ?? transform(M_TOTCAN,"@E ##,###,###.##")

     ? replicate("-", 132)


     eject
desliga1()
return ""


****************
function SEM_IES
****************

parameter M_IESANA

if empty(alltrim(tira_pto(M_IESANA)))
  return .t.
endif

if alltrim(M_IESANA) = "ISENTO" .or. substr(M_IESANA, 1, 2) = "RG"
  return .t.
endif

return .f.

***************
function TIPCLR  // Tipo de cliente do relatorio
***************

do case
   case M_TIPCL = "T"
     return "TODOS"
   case M_TIPCL = "H"
     return "HOSPITAIS"
   case M_TIPCL = "D"
     return "DEPTOS DE SAUDE"
   case M_TIPCL = "O"
     return "OUTROS"
endcase

return " "

*****************
function PROISENTO                     && vendas sintetica por produtos
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


select 0         && nfs temporario

M_IND = ""
M_INDA = ""
M_INDB = ""

acha_livre()

    rodape("SINTETICO","PRODUTO",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP)

    store date() to M_DATA1 ,;
                    M_DATA2

    store 0      to M_NFSMAT,;
                    M_NFSCLI1,;
                    M_NFSCLI,;
                    M_CODINI,;
                    M_CODFIN

     sombra(12, 35, 14, 72,_SOMBRA_)
     set color to GR/W
       @ 12, 35 say   "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
       @ 13, 35 say   "³Periodo Inicial:          a         ³"
       @ 14, 35 say   "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
     set color to

     SetColor(_COREDICAO_)
     @ 13, 53 get     M_DATA1
     @ 13, 64 get     M_DATA2
     read

     if lastkey() = 27
       select ANFS02
       use
       return ""
     endif

     store 0 to M_TOTGER

     select ANFS02

     if !flock()
       msg("* * * (ANFS02) ARQUIVO NAO DISPONIVEL * * *")
       return ""
     endif

     zap

     index on str(NFSEMP, 2, 0) + str(NFSMAT, 6, 0)   tag 1 to &M_IND

     set index to &M_IND

**** Le as notas fiscais

        M_IMPRE = imprelaser()

        if M_IMPRE = "N"
          select ANFS02
          use
          return ""
        endif


       select ANFS00

        set order to 2

        dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1), .t.)

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(NFSEMP, 2, 0) + dtos(NFSDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
            exit
          endif

          if NFSCAN = "C"
            skip
            loop
          endif

          if NFSCPG > 2
            if NFSCPG <= 20
              skip
              loop
            endif
          endif

          select ANFS01

          dbseek(str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER, .t.)

          do while !eof()

            if str(ANFS01->NFSEMP, 2, 0) + str(ANFS01->NFSNUM, 6, 0) + ANFS01->NFSSER > str(ANFS00->NFSEMP, 2, 0) + str(ANFS00->NFSNUM, 6, 0) + ANFS00->NFSSER
              exit
            endif

            valorespro(ANFS01->NFSMAT)

            if APCA00->PCATRI # 2
              skip
              loop
            endif

            select ANFS02

            seek str(ME_EMP, 2, 0) + str(ANFS01->NFSMAT, 6, 0)

            if eof()
              append blank
              replace NFSEMP with ME_EMP
              replace NFSMAT with ANFS01->NFSMAT
            endif

            replace NFSQDE with NFSQDE + ANFS01->NFSQDE

            replace NFSVLN with NFSVLN + ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP

            M_TOTGER = M_TOTGER + ANFS01->NFSLIQ + ANFS01->NFSDSP + ANFS01->NFSVIP

            select ANFS01

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                select ANFS02
                use
                return ""
              endif
            endif

            skip

          enddo

          select ANFS00

          skip

        enddo

*** Le os cupons fiscais

     select ACUP00

     go top

        set order to 2

        dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1), .t.)

        msw("* * * PROCESSANDO ... (ESC) Cancela * * *")

        do while !eof()

          if str(CUPEMP, 2, 0) + dtos(CUPDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
            exit
          endif

          if CUPCAN $ "ZXC"
            skip
            loop
          endif

          select ACUP01

          dbseek(str(ACUP00->CUPEMP, 2, 0) + str(ACUP00->CUPNUM, 6, 0) + ACUP00->CUPSER, .t.)

          do while !eof()

            if str(ACUP01->CUPEMP, 2, 0) + str(ACUP01->CUPNUM, 6, 0) + ACUP01->CUPSER > str(ACUP00->CUPEMP, 2, 0) + str(ACUP00->CUPNUM, 6, 0) + ACUP00->CUPSER
              exit
            endif

            valorespro(ACUP01->CUPMAT)

            if APCA00->PCATRI # 2
              skip
              loop
            endif

            select ANFS02

            seek str(ME_EMP, 2, 0) + str(ACUP01->CUPMAT, 6, 0)

            if eof()
              append blank
              replace NFSEMP with ME_EMP
              replace NFSMAT with ACUP01->CUPMAT
            endif

            replace NFSQDE with NFSQDE + ACUP01->CUPQDE
            replace NFSVLN with NFSVLN + ACUP01->CUPLIQ

            M_TOTGER = M_TOTGER + ACUP01->CUPLIQ

            select ACUP01

            if inkey() = 27
              if suspro()
                msg("* * * PROCESSO SUSPENSO * * *")
                select ANFS02
                use
                return ""
              endif
            endif

            skip

          enddo

          select ACUP00

          skip

        enddo

        store  0 to PG, LN   ,;
                    M_TOTVIS ,;
                    M_TOTPRZ ,;
                    M_VENVIS ,;
                    M_VENPRZ ,;
                    M_SOMPER ,;
                    M_VENANT

        select ANFS02
        go TOP

        do while !eof()

            PG++

            if PG > 1
              eject
            endif

            ? cent_cab(AEMP00->EMPFAN,"PRODUTOS ISENTOS","EAGRO21",67)

            ? cent_cab(M_DATA,dtoc(M_DATA1) + " A " + dtoc(M_DATA2),"PAG.: " + str(PG, 4),67)
            ? "*-------*------------------------------*-------*------------------*"
            ? "*CODIGO *     D E S C R I C A O        *  QDE  * VALOR TOTAL      *"
            ? "*-------*------------------------------*-------*------------------*"
*               9999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999 999,999 ###,###,###,###.## ###,###,###,###.## ###,###,###,###.## ###,## ###,###

            store 5 to LN

            do while !eof()

              if  LN > 60
                exit
              endif

              valorespro(ANFS02->NFSMAT)

              ? " "
               ?? str(NFSMAT, 7, 0)
               ?? " "
               ?? pad(zPCADES, 30)
               ?? " "
               ?? transform(NFSQDE,"@E ###,###")
               ?? " "
               ?? transform(NFSVLN,"@E@Z ###,###,###,###.##")
               ?? " "

            LN++

            M_TOTVIS = M_TOTVIS + NFSVLN

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

      ? replicate("-", 67)
      ? "                   TOTAL GERAL . . . . . . . . ."
        ?? transform(M_TOTVIS,"@E ###,###,###,###.##")
    ?

    unlock all

  desliga1(80)

  select ANFS02
  use

return ""

*****************
function ALIQ_ICM
*****************

*if ME_EMP = 10
*  if !M_NFSNATN == "5.202" // DEVOLUCAO
*    return 0
*  endif
*endif

if AFIS00->FISICM = "N"
  return 0
endif

*if M_CLIDCC = 2
*  return 18
*endif

*if !M_CLIUF2 = "SP"
*  if M_NFSNATN == "6.202" // DEVOLUCAO
*    return 12
*  endif
*endif

if M_CLIUF2 = "SP"
  return zPCAIC0
else
  if M_CLIUF2 $ "ES#PR#SC#RS#MG#RJ"
*    if empty(M_CLIIES2)
*      if zPCARG2 = 0
 *       if zPCAIC0 = 12
 *         return 12
 *       else
 *         return 18
 *       endif
 *     else
        return zPCAIC2
 *     endif
 *   else
 *     return zPCAIC2
 *   endif
  else
  *  if empty(M_CLIIES2)
  *    if zPCARG1 = 0
  *      if zPCAIC0 = 12
  *        return 12
  *      else
  *        return 18
  *      endif
  *    else
        return zPCAIC1
  *    endif
  *  else
  *    return zPCAIC1
  *  endif
  endif
endif

return 18

*****************
function LISNFS_I   && relacao de notas no periodo
*****************

SEEXISTESQL("ATNF00")
abre_tnf0("0")  // Temporario notas fiscais

private M_TOTAL, M_DATA1, M_DATA2, PG, LN,;
        M_TOTGER,M_TOTVIS,M_TOTPRZ,M_SOMPER, M_TELA


rodape("SINTETICO","NOTA",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP)

store date() to M_DATA1, M_DATA2


store 0 to M_DUPCLI, M_NFSCLI1, M_NFSCLI,;
           M_CODINI, M_CODFIN,  M_NFSVEN

M_MOEDA  = "R"
M_TIPNOT = " "
M_RESUMO = " "

nbox(12, 35, 19, 72,"W/W+",.t.)
setcolor("B/W")
  @ 13, 36 say   "Resumo <D>iario / <M>ensal:         "
  @ 14, 36 say   "Periodo Inicial:          a         "
  @ 15, 36 say   "       Cliente :                    "
  @ 16, 36 say   "     Fornecedor:                    "
  @ 17, 36 say   "  Entrada/Saida:                    "
  @ 18, 36 say   "       Vendedor:                    "
set color to

SetColor(_COREDICAO_)
@ 13, 64 get M_RESUMO  picture "@!"  valid M_RESUMO  $ "DM"
@ 14, 53 get M_DATA1
@ 14, 64 get M_DATA2
@ 15, 53 get M_DUPCLI  picture "#######"
@ 16, 53 get M_NFSCLI1 picture "#######" valid vernfs25()
@ 17, 53 get M_TIPNOT  picture "@!"  valid M_TIPNOT $ "ES"
@ 18, 53 get M_NFSVEN  picture "999"
read

if lastkey() = 27
  return ""
endif


if M_TIPNOT == "S"
  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  aadd(sqlARQUI,{"ANFS00","ANFS00"})
  aadd(sqlCAMPO,"ANFS00.NFSEMP")
  aadd(sqlCAMPO,"ANFS00.NFSSER")
  aadd(sqlCAMPO,"ANFS00.NFSNUM")
  aadd(sqlCAMPO,"ANFS00.NFSCLI")
  aadd(sqlCAMPO,"ANFS00.NFSCPG")
  aadd(sqlCAMPO,"ANFS00.NFSDTE")
  aadd(sqlCAMPO,"ANFS00.NFSVLN")
  aadd(sqlCAMPO,"ANFS00.NFSCAN")
  aadd(sqlCAMPO,"ANFS00.NFSVEN")
  aadd(sqlCAMPO,"AFIS00.FISNOV")

  aadd(sqlCAMPO,"APCA00.PCADES")
  aadd(sqlCAMPO,"ACLI00.CLIVEN")
  aadd(sqlCAMPO,"ACLI00.CLITIP")
  aadd(sqlCAMPO,"ANFS01.NFSMAT")
  aadd(sqlCAMPO,"ANFS01.NFSLIQ")
  aadd(sqlCAMPO,"ANFS01.NFSVLI")
  aadd(sqlCAMPO,"ANFS01.NFSVIP")
  aadd(sqlCAMPO,"ANFS01.NFSQDE")
  aadd(sqlCAMPO,"ANFS01.NFSNATN as NFSNATN1")

  aadd(sqlRELATION,{"ANFS01","ANFS01.NFSEMP","ANFS00.NFSEMP"})
  aadd(sqlRELATION,{"","ANFS01.NFSNUM","ANFS00.NFSNUM"})
  aadd(sqlRELATION,{"","ANFS01.NFSSER","ANFS00.NFSSER"})
  aadd(sqlRELATION,{"APCA00","APCA00.PCAMAT","ANFS01.NFSMAT"})
  aadd(sqlRELATION,{"AFIS00",str(ME_EMP,2,0),"AFIS00.FISEMP"})
  aadd(sqlRELATION,{"","AFIS00.FISNOV","ANFS00.NFSNATN"})
  aadd(sqlRELATION,{"ACLI00","ACLI00.CLICOD","ANFS00.NFSCLI"})

  aadd(sqlCHAVE,"ANFS00.NFSDTE BETWEEN " + aspas(formatdta(M_DATA1)) + " and " + aspas(formatdta(M_DATA2)))
  aadd(sqlCHAVE,"ANFS00.NFSEMP = " + str(ME_EMP, 2, 0))
* aadd(sqlCHAVE,"ANFS00.nfscan not in ('C','D')")
  aadd(sqlCHAVE,"SUBSTRING(ANFS00.NFSNATN FROM 1 FOR 1) >= '5'")


  if M_DUPCLI > 0
    aadd(sqlCHAVE,"ANFS00.NFSCLI = " + str(M_DUPCLI, 5, 0))
  endif

  if M_NFSCLI1 > 0
    aadd(sqlCHAVE,"APCA00.PCAFOR = " + str(M_NFSCLI1, 5, 0))
  endif

  if M_NFSVEN > 0
    aadd(sqlCHAVE,"ANFS00.NFSVEN = " + str(M_NFSVEN,3))
  endif




  if !sqlrelation()
    msg( "* * * Nada a ser listado no intervalo * * *")
    return ""
  endif

else
  select ANFE00
  go top
  (dbsetorder(2), dbseek(str(ME_EMP, 2) + dtos(M_DATA1),.t.))
  if str(NFEEMP, 2) + dtos(NFEDTR) > str(ME_EMP, 2) + dtos(M_DATA2)
    msg( "* * * Nada a ser listado no intervalo * * *")
    return ""
  endif
  select ANFE00
  set relation to NFENATN into AFIS00
endif

select ATNF00

if !flock()
  msg("* * * (ATNF00) Arquivo em uso exclusivo * * *")
  return ""
endif

zap

index on str(TNFNFS, 6) + TNFSER + TNFCFO tag 1 to C:\ATLAS\ATNF00
set index to C:\ATLAS\ATNF00

**** Agora o processamento


if M_TIPNOT == "S"
  select ANFS00
  do while !eof()
    msw("* * * Aguarde... Processando: " + str(ANFS00->NFSNUM, 6) + " " + ANFS00->NFSSER + " " + dtoc(ANFS00->NFSDTE) + " * * *")
    select ATNF00

    M_NFSNATN = ANFS00->NFSNATN1

    if ANFS00->NFSCAN == "C"
      M_NFSNATN = "5.102"
    endif

    if !dbseek(str(ANFS00->NFSNUM, 6) + ANFS00->NFSSER + M_NFSNATN)
      append blank
      if rlock()
        replace TNFNFS with ANFS00->NFSNUM
        replace TNFSER with ANFS00->NFSSER
        replace TNFDTE with ANFS00->NFSDTE
        replace TNFCFO with M_NFSNATN
        replace TNFCLI with ANFS00->NFSCLI
        replace TNFCPG with ANFS00->NFSCPG
        replace TNFVEN with ANFS00->NFSVEN
        replace TNFVLN with ANFS00->NFSVLN
        replace TNFVFO with ANFS00->NFSLIQ
        replace TNFVIS with iif(strzero(ANFS00->NFSCPG, 3) $ "001#151", ANFS00->NFSLIQ, 0)
        replace TNFPRZ with iif(!strzero(ANFS00->NFSCPG, 3) $ "001#151" .and. ANFS00->NFSCPG > 99, ANFS00->NFSLIQ, 0)
        replace TNFOUT with iif(ANFS00->NFSCPG > 1 .and. ANFS00->NFSCPG < 100, ANFS00->NFSLIQ, 0)
        replace TNFCAN with ANFS00->NFSCAN
        replace TNFSUB with iif(ANFS00->NFSMAT # 1 .and. M_NFSNATN $ "5.403#5.405", ANFS00->NFSLIQ + ANFS00->NFSVIP, 0)
        replace TNFVLS with iif("ALUGUEL" $ ANFS00->PCADES, ANFS00->NFSLIQ, 0)
        unlock
      else
        msg("* * * (ATNF00) Registro sendo usado * * *")
      endif
    else
      if rlock()
        replace TNFVFO with TNFVFO + ANFS00->NFSLIQ
        replace TNFVIS with TNFVIS + iif(strzero(ANFS00->NFSCPG, 3) $ "001#151", ANFS00->NFSLIQ, 0)
        replace TNFPRZ with TNFPRZ + iif(!strzero(ANFS00->NFSCPG, 3) $ "001#151" .and. ANFS00->NFSCPG > 99, ANFS00->NFSLIQ, 0)
        replace TNFOUT with TNFOUT + iif(ANFS00->NFSCPG > 1 .and. ANFS00->NFSCPG < 100, ANFS00->NFSLIQ, 0)
        replace TNFSUB with TNFSUB + iif(ANFS00->NFSMAT # 1 .and. M_NFSNATN $ "5.403#5.405", ANFS00->NFSLIQ + ANFS00->NFSVIP, 0)
        replace TNFVLS with TNFVLS + iif("ALUGUEL" $ ANFS00->PCADES, ANFS00->NFSLIQ, 0)
        unlock
      else
         msg("* * * (ATNF00) Registro sendo usado * * *")
      endif
    endif
    select ANFS00
    skip
  enddo
else   // Nota de entrada
  select ANFE00
  do while !eof()
    if str(NFEEMP, 2) + dtos(NFEDTR) > str(ME_EMP, 2) + dtos(M_DATA2)
      go bottom
      skip
      loop
    endif
    msw("* * * Aguarde... Processando: " + str(ANFE00->NFENUM, 6) + " " + ANFE00->NFESER + " " + dtoc(ANFE00->NFEDTR) + " * * *")
    select ANFE01
    (dbsetorder(1), dbseek(str(ANFE00->NFEEMP, 2) + str(ANFE00->NFENUM, 6) + ANFE00->NFESER + str(ANFE00->NFEFOR, 7), .t.))
    do while !eof()
      if !str(NFEEMP, 2) + str(NFENUM, 6) + NFESER + str(NFEFOR, 7) == str(ANFE00->NFEEMP, 2) + str(ANFE00->NFENUM, 6) + ANFE00->NFESER + str(ANFE00->NFEFOR, 7)
        exit
      endif
      select ATNF00
      if !dbseek(str(ANFE01->NFENUM, 6) + ANFE01->NFESER + ANFE01->NFENATN)
        append blank
        if rlock()
          replace TNFNFS with ANFE01->NFENUM
          replace TNFSER with ANFE01->NFESER
          replace TNFDTE with ANFE00->NFEDTR
          replace TNFCFO with ANFE01->NFENATN
          replace TNFFOR with ANFE00->NFEFOR
          replace TNFCLI with ANFE00->NFEFOR
          replace TNFCPG with ANFE00->NFECPG
          replace TNFVLN with ANFE00->NFEVLN
          replace TNFVFO with ANFE01->NFEVLI
          replace TNFVIS with iif(ANFE00->NFECPG = 501, ANFE01->NFEVLI + ANFE01->NFEVIP + ANFE01->NFEDST + ANFE01->NFEDSN, 0)
          replace TNFPRZ with iif(ANFE00->NFECPG >= 510, ANFE01->NFEVLI + ANFE01->NFEVIP + ANFE01->NFEDST + ANFE01->NFEDSN, 0)
          replace TNFOUT with iif(ANFE00->NFECPG > 501 .and. ANFE00->NFECPG < 510, ANFE01->NFEVLI + ANFE01->NFEVIP + ANFE01->NFEDST + ANFE01->NFEDSN, 0)
          unlock
        else
          msg("* * * (ATNF00) Registro sendo usado * * *")
        endif
      else
        if rlock()
          replace TNFVFO with TNFVFO + ANFE01->NFEVLI
          replace TNFVIS with TNFVIS + iif(ANFE00->NFECPG = 501, ANFE01->NFEVLI + ANFE01->NFEVIP + ANFE01->NFEDST + ANFE01->NFEDSN, 0)
          replace TNFPRZ with TNFPRZ + iif(ANFE00->NFECPG >= 510, ANFE01->NFEVLI + ANFE01->NFEVIP + ANFE01->NFEDST + ANFE01->NFEDSN, 0)
          replace TNFOUT with TNFOUT + iif(ANFE00->NFECPG > 501 .and. ANFE00->NFECPG < 510, ANFE01->NFEVLI + ANFE01->NFEVIP + ANFE01->NFEDST + ANFE01->NFEDSN, 0)
          unlock
        else
           msg("* * * (ATNF00) Registro sendo usado * * *")
        endif
      endif
      select ANFE01
      skip
    enddo
    select ANFE00
    skip
  enddo
endif

**** Impressao do relatorio

M_IMPRE = impresn()

if M_IMPRE = "N"
  return ""
endif

if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
  ?? chr(15)                        && comprime
endif

select ATNF00 // Temporario notas fiscais
go top

store  0 to PG, LN, M_TOTAL ,;
            M_NFSOUT, M_NFSVIS, M_NFSPRZ, M_NFSSUB, M_NFSVLS,;
            M_TOTOUT, M_TOTVIS, M_TOTPRZ, M_TOTSUB, M_TOTVLS,;
            M_TOTCAN

M_NFSDTE := ctod("  /  /  ")
M_NOTANT := space(08)

cab_rnf()  // Imprime o cabecalho

do while !eof()

  if M_NFSVEN > 0
    BUSCAREGISTRO("AVEN00",1,{str(M_NFSVEN,3,0)},"SELECT")
    ?
    ? " Vendedor: " + AVEN00->VENNOM
    ?
    LN += 3
  endif

  select ATNF00 // Temporario notas fiscais

  do while !eof()

    if M_RESUMO == "D"
      if TNFDTE != M_NFSDTE .and. M_NFSVEN = 0
        if M_NFSPRZ+M_NFSVIS+M_NFSOUT > 0
          ? space(39)
           ?? "TOTAIS DO DIA . . . . . . . .    A VISTA "
           ?? transform(M_NFSVIS,"@E ##,###,###.##")
          ?   space(39)
           ?? "                                 A PRAZO "
           ?? transform(M_NFSPRZ,"@E ##,###,###.##")
          ?   space(39)
           ?? "                    (A VISTA +  A PRAZO) "
           ?? transform(M_NFSPRZ+M_NFSVIS,"@E ##,###,###.##")
          ?   space(39)
           ?? "OUTRAS SAIDAS . . . . . . . .            "
           ?? transform(M_NFSOUT,"@E ##,###,###.##")
          ?   space(39)
           ?? "SUBSTITUICAO  . . . . . . . .            "
           ?? transform(M_NFSSUB,"@E ##,###,###.##")
          ?   space(39)
           ?? "SERVICOS. . . . . . . . . . .            "
           ?? transform(M_NFSVLS,"@E ##,###,###.##")
          ? replicate("-", 132)
          LN += 6

          store 0 to M_NFSOUT,;
                     M_NFSVIS,;
                     M_NFSSUB,;
                     M_NFSVLS,;
                     M_NFSPRZ
        endif
        M_NFSDTE = TNFDTE
      endif
    else
      if month(TNFDTE) != month(M_NFSDTE) .and. M_NFSVEN = 0
        if M_NFSPRZ+M_NFSVIS+M_NFSOUT > 0
          ?   space(39)
           ?? "TOTAIS DO MES . . . . . . . .    A VISTA "
           ?? transform(M_NFSVIS,"@E ##,###,###.##")
          ?   space(39)
           ?? "                                 A PRAZO "
           ?? transform(M_NFSPRZ,"@E ##,###,###.##")
          ?   space(39)
           ?? "                    (A VISTA +  A PRAZO) "
           ?? transform(M_NFSPRZ+M_NFSVIS,"@E ##,###,###.##")
          ?   space(39)
           ?? "OUTRAS SAIDAS . . . . . . . .            "
           ?? transform(M_NFSOUT,"@E ##,###,###.##")
          ?    space(39)
           ?? "SUBSTITUICAO  . . . . . . . .            "
           ?? transform(M_NFSSUB,"@E ##,###,###.##")
          ?    space(39)
           ?? "SERVICOS. . . . . . . . . . .            "
           ?? transform(M_NFSVLS,"@E ##,###,###.##")
          ? replicate("-", 132)
          LN += 7
          store 0 to M_NFSOUT,;
                     M_NFSVIS,;
                     M_NFSSUB,;
                     M_NFSVLS,;
                     M_NFSPRZ
        endif
        M_NFSDTE = iif(M_TIPNOT=="S",NFSDTE,NFEDTR)
      endif
    endif

    if M_TIPNOT == "S"
      valorescli(TNFCLI)
    else
      BUSCAREGISTRO("AFOR00",1,{str(ATNF00->TNFFOR,7,0)},"SELECT")
    endif

    select ATNF00

    if TNFCAN = "C"
      ? " "
       ?? str(TNFNFS, 6, 0)
       ?? " "
       ?? TNFSER
       ?? " "
       ?? str(TNFCLI, 7, 0)
       ?? " "
      if left(TNFCFO,1) < "5"
        ?? left(AFOR00->FORNOM, 40)
      else
        ?? left(zCLINOM, 40)
      endif
      ?? " *** CANCELADA *** "
      M_TOTCAN += TNFVLN
    else
      select ATNF00
      if !M_NOTANT = strzero(TNFNFS, 6) + TNFSER
        M_NOTANT := strzero(TNFNFS, 6) + TNFSER
        ? " "
         ?? str(TNFNFS, 6)
         ?? " "
         ?? TNFSER
         ?? " "
         ?? str(TNFCLI, 7)
         ?? " "
        if left(TNFCFO,1) < "5"
          ?? left(AFOR00->FORNOM, 29)
        else
          ?? left(zCLINOM, 27)
          ?? " "
          ?? zCLITIP
        endif
        ?? " "
        ?? str(TNFCPG, 3)
        ?? " "
        if left(TNFCFO,1) < "5"
          ?? AFOR00->FOREST
        else
          ?? zCLIUF2
        endif
        ?? " "
        ?? TNFDTE
        ?? " "
        ?? str(TNFVEN, 3)
        ?? " "
        ?? transform(TNFVLN, "@E #,###,###.##")
      else  // se for a mesma nota anterior
        ? space(81)
      endif

      ?? " "
      ?? TNFCFO
      ?? " "
      ?? transform(TNFOUT, "@E@Z ##,###,###.##")
      ?? " "
      ?? transform(TNFVIS, "@E@Z ##,###,###.##")
      ?? " "
      ?? transform(TNFPRZ, "@E@Z ##,###,###.##")

      LN++

      M_NFSOUT += TNFOUT
      M_NFSVIS += TNFVIS
      M_NFSSUB += TNFSUB
      M_NFSVLS += TNFVLS
      M_NFSPRZ += TNFPRZ

      M_TOTOUT += TNFOUT
      M_TOTVIS += TNFVIS
      M_TOTSUB += TNFSUB
      M_TOTVLS += TNFVLS
      M_TOTPRZ += TNFPRZ

    endif

    if LN > 60
      cab_rnf()  // imprime o cabecalho
    endif

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

  if LN > 53
    ?
    eject
  endif

  if M_RESUMO == "D"
    if M_NFSVEN = 0
      if M_NFSPRZ+M_NFSVIS+M_NFSOUT > 0
        ?    space(39)
         ?? "TOTAIS DO DIA . . . . . . . .    A VISTA "
         ?? transform(M_NFSVIS,"@E ##,###,###.##")
        ?    space(39)
         ?? "                                 A PRAZO "
         ?? transform(M_NFSPRZ,"@E ##,###,###.##")
        ?    space(39)
         ?? "                     (A VISTA + A PRAZO) "
         ?? transform(M_NFSPRZ+M_NFSVIS,"@E ##,###,###.##")
        ?    space(39)
         ?? "OUTRAS SAIDAS . . . . . . . .            "
         ?? transform(M_NFSOUT,"@E ##,###,###.##")
        ?    space(39)
         ?? "SUBSTITUICAO  . . . . . . . .            "
         ?? transform(M_NFSSUB,"@E ##,###,###.##")
        ?    space(39)
         ?? "SERVICOS. . . . . . . . . . .            "
         ?? transform(M_NFSVLS,"@E ##,###,###.##")
        ? replicate("-", 132)
        LN += 7
        store 0 to M_NFSOUT, M_NFSVIS, M_NFSPRZ,;
                   M_NFSSUB, M_NFSVLS
      endif
    endif
  else
    if iif(M_TIPNOT=="S",month(NFSDTE),month(NFEDTR)) != month(M_NFSDTE) .and. M_NFSVEN = 0
      if M_NFSPRZ+M_NFSVIS+M_NFSOUT > 0
        ? space(39)
         ?? "TOTAIS DO MES . . . . . . . .    A VISTA "
         ?? transform(M_NFSVIS,"@E ##,###,###.##")
        ? space(39)
         ?? "                                 A PRAZO "
         ?? transform(M_NFSPRZ,"@E ##,###,###.##")
        ? space(39)
         ?? "                    (A VISTA +  A PRAZO) "
         ?? transform(M_NFSPRZ+M_NFSVIS,"@E ##,###,###.##")
        ? space(39)
         ?? "OUTRAS SAIDAS . . . . . . . .            "
         ?? transform(M_NFSOUT,"@E ##,###,###.##")
        ? space(39)
         ?? "SUBSTITUICAO  . . . . . . . .            "
         ?? transform(M_NFSSUB,"@E ##,###,###.##")
        ? space(39)
         ?? "SERVICOS. . . . . . . . . . .            "
         ?? transform(M_NFSVLS,"@E ##,###,###.##")
        ? replicate("-", 132)
        LN += 7
        store 0 to M_NFSOUT, M_NFSVIS, M_NFSSUB, M_NFSVLS, M_NFSPRZ
      endif
      M_NFSDTE = iif(M_TIPNOT=="S",NFSDTE,NFEDTR)
    endif
  endif

  ? replicate("-", 132)
  ? space(39)
   ?? "TOTAIS . . .  . . . . . . . .    A VISTA "
   ?? transform(M_TOTVIS,"@E ##,###,###.##")
  ? space(39)
   ?? "                                 A PRAZO "
   ?? transform(M_TOTPRZ,"@E ##,###,###.##")
  ? space(39)
   ?? "                     (A VISTA + A PRAZO) "
   ?? transform(M_TOTPRZ+M_TOTVIS,"@E ##,###,###.##")
  ? space(39)
   ?? "OUTRAS SAIDAS . . . . . . . .            "
   ?? transform(M_TOTOUT,"@E ##,###,###.##")
  ? space(39)
   ?? "SUBSTITUICAO  . . . . . . . .            "
   ?? transform(M_TOTSUB,"@E ##,###,###.##")
  ? space(39)
   ?? "SERVICOS. . . . . . . . . . .            "
   ?? transform(M_TOTVLS,"@E ##,###,###.##")
  ? space(39)
   ?? "CANCELADAS      . . . . . . .            "
   ?? transform(M_TOTCAN,"@E ##,###,###.##")
  ? replicate("-", 132)
  ?

  eject

  desliga1()

  select ATNF00
enddo

return ""
****************
function MSNFS01  && mostra dados e calcula nota fiscal
****************

parameter _ACAO_

    private    M_TOTNFS  ,;
               M_ISENFS  ,;
               M_OUTNFS  ,;
               M_TOTDSP  ,;
               M_TOTBIC  ,;
               M_TOTVIC  ,;
               M_TOTISE  ,;
               M_TOTOUT  ,;
               M_NFSTOT,L,LPOSRAT

    store 0 to M_NFSVLM  ,;
               M_NFSVLD  ,;
               M_NFSVLS  ,;
               M_NFSVLN  ,;
               M_NFSTRI  ,;
               M_NFSISE  ,;
               M_NFSRED  ,;
               M_NFSOUT  ,;
               M_NFSVIC  ,;
               M_NFSBIC  ,;
               M_DSPNFS  ,;
               M_NFSVIP  ,;
               M_NFSBASSUB
    store 0 to M_TOTNFS  ,;
               M_ISENFS  ,;
               M_OUTNFS  ,;
               M_TOTDSP  ,;
               M_TOTBIC  ,;
               M_TOTVIC  ,;
               M_TOTISE  ,;
               M_TOTOUT  ,;
               M_NFSTOT  ,LPOSRAT

    store 11 to L
    store  0 to LN       ,;
                M_IND    ,;
                M_TOTNFS ,;
                M_TOTPRO ,;
                M_TOTSER ,;
                M_TOTSUB

    lposrat = 1

    for R = 1 to len(M_NFSMAT)            && calcula o valor bruto da nota
      if M_NFSMAT[R,3] = 0
        loop
      endif

      valorespro(M_NFSMAT[R,3])

      M_NFSMAT[R,9]=0
      M_NFSMAT[R,8]=0
      M_NFSMAT[R,10]=0
      M_NFSMAT[R,11]=0
      M_NFSMAT[R,12]=0
      M_NFSMAT[R,13]=0
      M_TOTNFS = M_TOTNFS + M_NFSMAT[R,6]
      M_TOTPRO = M_TOTPRO + M_NFSMAT[R,6]

     if M_NFSMAT[R,3] # 1 // frete
       LPOSRAT = R
     endif

      if !empty(AFIS00->FISOBS)                   && carrega observacao
        M_NFSMAT[R, 17] = AFIS00->FISOBS
      endif
    next

    lSoser = .f.

    for R = 1 to len(M_NFSMAT)                    && calcula o valor liquido da nota

      valorespro(M_NFSMAT[R,3])

     if M_DSCNFS > 0
       M_NFSMAT[R,7] = (M_NFSMAT[R,6] - ((M_DSCNFS/M_TOTPRO) * M_NFSMAT[R,6]))
     else
       M_NFSMAT[R,7] = round(M_NFSMAT[R,6] - ((M_NFSMAT[R,6] /100) * M_NFSDSC), 2)
     endif

      M_NFSMAT[R,13] = round(((M_NFSMAT[R,7] * .01) * iif(AFIS00->FISIPI="S",zPCAIPI,0)), 2)
      M_NFSVLM = M_NFSVLM + M_NFSMAT[R, 6]
      M_NFSVLD = M_NFSVLD + (M_NFSMAT[R,6] - M_NFSMAT[R,7])

      M_NFSVLN = M_NFSVLN + (M_NFSMAT[R,7] + M_NFSMAT[R,13])
      M_NFSVIP = M_NFSVIP + M_NFSMAT[R,13]
    next R

    if (M_NFSFRE + M_NFSSEG + M_NFSDSP) > 0
      M_TOTDSP = 0
      for R = 1 to len(M_NFSMAT)                    && rateia fretes no item
        if M_NFSMAT[R,3] = 0
          loop
        endif
        M_NFSMAT[R,12] = ((M_NFSFRE + M_NFSSEG + M_NFSDSP)/M_NFSVLN) * M_NFSMAT[R,7]
        M_TOTDSP = M_TOTDSP + M_NFSMAT[R,12]
      next
      M_NFSMAT[1,12] = M_NFSMAT[1,12] + ((M_NFSFRE + M_NFSSEG + M_NFSDSP) - M_TOTDSP)
    endif

    M_NFSVLN = M_NFSVLN + (M_NFSFRE + M_NFSSEG + M_NFSDSP)    && soma frete na nota

    if M_FISINT = "R"
      if M_NFSCPG < 3 .or. M_NFSCPG >= 20
        if _ACAO_
          calc_dup()                     && duplicata
        endif
      endif
    endif

    M_DSPNFS = 0
    M_NFSTOT = 0
    M_TOTBIC = 0
    M_TOTVIC = 0
    M_TOTISE = 0
    M_TOTOUT = 0
    M_TOTDSP = 0
    M_TOTVIP = 0
    M_TOTSUB = 0

    for R = 1 to len(M_NFSMAT)

        if M_NFSMAT[R,3] = 0
          loop
        endif

        valorespro(M_NFSMAT[R,3])

        set color to I
          @ L, 05 say   M_NFSMAT[R, 1]            picture "##"
          @ L, 08 say   M_NFSMAT[R, 3]            picture "######"
          @ L, 15 say   M_NFSMAT[R, 4]            picture "########"
          @ L, 24 say   pad(zPCADES, 30)
          @ L, 55 say   M_NFSMAT[R, 5]            picture "#######.##"
          @ L, 66 say   M_NFSMAT[R, 6]            picture "#######.##"
        set color to

        M_ICMICM = aliq_icm()
        M_PCATRI = zPCATRI

        if !M_CLIUF2 == "SP"  // SE NAO FOR DENTRO DO ESTADO TRIBUTACAO NORMAL 1
          if M_PCATRI = 4     // SE A TRIBUTACAO ERA 4 VAI PARA 1
            M_PCATRI = 1
          endif
        endif

        do case
           case M_PCATRI = 1
                lSosub = .f.  // so substituicao sim ou nao
                if M_ICMICM > 0
                  M_NFSTRI = M_NFSTRI + M_NFSMAT[R,7]
                else
                  if str(zPCAESC, 1, 0) $ "37"
                    M_NFSOUT = M_NFSOUT + M_NFSMAT[R,7]
                  else
                    M_NFSISE = M_NFSISE + M_NFSMAT[R,7]
                  endif
                endif
           case M_PCATRI = 2
                lSosub = .f.  // so substituicao sim ou nao
                if str(zPCAESC, 1, 0) $ "37"
                  M_NFSOUT = M_NFSOUT + M_NFSMAT[R,7]
                else
                  M_NFSISE = M_NFSISE + M_NFSMAT[R,7]
                endif
           case M_PCATRI = 3
                lSosub = .f.  // so substituicao sim ou nao
                if M_ICMICM > 0
                  M_NFSRED = M_NFSRED + M_NFSMAT[R,7]
                else
                  if str(zPCAESC, 1, 0) $ "37"
                    M_NFSOUT = M_NFSOUT + M_NFSMAT[R,7]
                  else
                    M_NFSISE = M_NFSISE + M_NFSMAT[R,7]
                  endif
                endif
           case M_PCATRI = 4
                if str(zPCAESC, 1, 0) $ "37"
                  M_NFSOUT = M_NFSOUT + M_NFSMAT[R,7]
                else
                  M_NFSISE = M_NFSISE + M_NFSMAT[R,7]
                endif
           otherwise
                M_NFSTRI = M_NFSTRI + M_NFSMAT[R,7]
        endcase

        if M_PCATRI = 1
          if M_ICMICM > 0
            M_NFSMAT[R,25] = M_ICMICM
            if AFIS00->FISICN = "S"
              M_NFSMAT[R,8] = (M_NFSMAT[R,7] + M_NFSMAT[R,12] + iif(M_CLIDCC=1,0,M_NFSMAT[R,13]))
            else
              M_NFSMAT[R,8] = M_NFSMAT[R,7]
            endif
            M_NFSMAT[R,9] = (M_NFSMAT[R,8]*.01) * M_ICMICM
          else
            if str(zPCAESC, 1, 0) $ "37"
              M_NFSMAT[R,11] = M_NFSMAT[R,7] + M_NFSMAT[R,12]
            else
              M_NFSMAT[R,10] = M_NFSMAT[R,7] + M_NFSMAT[R,12]
            endif
          endif
        endif

        if M_PCATRI = 2
          if str(zPCAESC, 1, 0) $ "37"
            M_NFSMAT[R,11] = M_NFSMAT[R,7] + M_NFSMAT[R,12]
            M_NFSMAT[R,9] = 0
          else
            M_NFSMAT[R,10] = M_NFSMAT[R,7] + M_NFSMAT[R,12]
            M_NFSMAT[R,9] = 0
          endif
        endif

        if M_PCATRI = 3
          if M_CLIUF2 = "SP"              && regiao 0
            if !empty(M_CLIIES2)
              if M_ICMICM > 0
                M_NFSMAT[R,25] = M_ICMICM
                if AFIS00->FISICN = "S"
                  M_NFSMAT[R,8] = ((M_NFSMAT[R,7] + M_NFSMAT[R,12] + iif(M_CLIDCC=1,0,M_NFSMAT[R,13])) - (((M_NFSMAT[R,7] + M_NFSMAT[R,12] + iif(M_CLIDCC=1,0,M_NFSMAT[R,13]))/100) * (100-zPCARG0)))
                  M_NFSMAT[R,9] = (M_NFSMAT[R,8] * .01) * M_ICMICM
                  if str(zPCAESC, 1, 0) $ "37"
                    M_NFSMAT[R,11] = ((M_NFSMAT[R,7] + M_NFSMAT[R,12] + iif(M_CLIDCC=1,0,M_NFSMAT[R,13]))) - M_NFSMAT[R,8]
                  else
                    M_NFSMAT[R,10] = ((M_NFSMAT[R,7] + M_NFSMAT[R,12] + iif(M_CLIDCC=1,0,M_NFSMAT[R,13]))) - M_NFSMAT[R,8]
                 endif
                else
                  M_NFSMAT[R,8] = M_NFSMAT[R,7] - (((M_NFSMAT[R,7]/100) * (100-zPCARG0)))
                  M_NFSMAT[R,9] = (M_NFSMAT[R,8] * .01) * M_ICMICM
                  if str(zPCAESC, 1, 0) $ "37"
                    M_NFSMAT[R,11] = M_NFSMAT[R,7] - M_NFSMAT[R,8]
                  else
                    M_NFSMAT[R,10] = M_NFSMAT[R,7] - M_NFSMAT[R,8]
                  endif
                endif
              else
                if str(zPCAESC, 1, 0) $ "37"
                  M_NFSMAT[R,11] = M_NFSMAT[R,7] + M_NFSMAT[R,12]
                else
                  M_NFSMAT[R,10] = M_NFSMAT[R,7] + M_NFSMAT[R,12]
                endif
              endif
            else
              if M_ICMICM > 0
                M_NFSMAT[R,25] = M_ICMICM
                if AFIS00->FISICN = "S"
                  M_NFSMAT[R,8] = (M_NFSMAT[R,7] + M_NFSMAT[R,12] + iif(M_CLIDCC=1,0,M_NFSMAT[R,13]))
                else
                  M_NFSMAT[R,8] = M_NFSMAT[R,7]
                endif
                M_NFSMAT[R,9] = (M_NFSMAT[R,8]*.01) * M_ICMICM
              else
                if str(zPCAESC, 1, 0) $ "37"
                  M_NFSMAT[R,11] = M_NFSMAT[R,7] + M_NFSMAT[R,12]
                else
                  M_NFSMAT[R,10] = M_NFSMAT[R,7] + M_NFSMAT[R,12]
                endif
              endif
            endif
          else
            if rat(M_CLIUF2,"PR#SC#RS#MG#RJ") > 0  && regiao 2
              if !empty(M_CLIIES2)
                if M_ICMICM > 0
                  M_NFSMAT[R,25] = M_ICMICM
                  if AFIS00->FISICN = "S"
                    M_NFSMAT[R,8] = ((M_NFSMAT[R,7] + M_NFSMAT[R,12] + iif(M_CLIDCC=1,0,M_NFSMAT[R,13])) - (((M_NFSMAT[R,7] + M_NFSMAT[R,12])/100) * (100-zPCARG2)))
                    M_NFSMAT[R,9] = (M_NFSMAT[R,8] * .01) * M_ICMICM
                    if str(zPCAESC, 1, 0) $ "37"
                      M_NFSMAT[R,11] = (M_NFSMAT[R,7] + M_NFSMAT[R,12] + iif(M_CLIDCC=1,0,M_NFSMAT[R,13])) - M_NFSMAT[R,8]
                    else
                      M_NFSMAT[R,10] = (M_NFSMAT[R,7] + M_NFSMAT[R,12] + iif(M_CLIDCC=1,0,M_NFSMAT[R,13])) - M_NFSMAT[R,8]
                    endif
                  else                                               && sem frete
                    M_NFSMAT[R,8] = (M_NFSMAT[R,7] - ((M_NFSMAT[R,7]/100) * (100-zPCARG2)))
                    M_NFSMAT[R,9] = (M_NFSMAT[R,8] * .01) * M_ICMICM
                    if str(zPCAESC, 1, 0) $ "37"
                      M_NFSMAT[R,11] = M_NFSMAT[R,7] - M_NFSMAT[R,8]
                    else
                      M_NFSMAT[R,10] = M_NFSMAT[R,7] - M_NFSMAT[R,8]
                    endif
                  endif
                else
                  if str(zPCAESC, 1, 0) $ "37"
                    M_NFSMAT[R,11] = M_NFSMAT[R,7] + M_NFSMAT[R,12]
                  else
                    M_NFSMAT[R,10] = M_NFSMAT[R,7] + M_NFSMAT[R,12]
                  endif
                endif
              else
                if AFIS00->FISICN = "S" .and. M_ICMICM > 0
                  M_NFSMAT[R,8] = ((M_NFSMAT[R,7] + M_NFSMAT[R,12] + iif(M_CLIDCC=1,0,M_NFSMAT[R,13])) - (((M_NFSMAT[R,7] + M_NFSMAT[R,12])/100) * (100-zPCARG0)))
                else
                  M_NFSMAT[R,8] = M_NFSMAT[R,7]
                endif
                M_NFSMAT[R,25] = M_ICMICM
                M_NFSMAT[R,9] = (M_NFSMAT[R,8]*.01) * M_ICMICM
              endif
            else
              if !empty(M_CLIIES2)
           	if M_ICMICM > 0
                  M_NFSMAT[R,25] = M_ICMICM
                  if AFIS00->FISICN = "S"
                    M_NFSMAT[R,8] = ((M_NFSMAT[R,7] + M_NFSMAT[R,12] + iif(M_CLIDCC=1,0,M_NFSMAT[R,13])) - (((M_NFSMAT[R,7] + M_NFSMAT[R,12])/100) * (100-zPCARG1)))
                    M_NFSMAT[R,9] = (M_NFSMAT[R,8] * .01) * M_ICMICM
                    if str(zPCAESC, 1, 0) $ "37"
                      M_NFSMAT[R,11] = (M_NFSMAT[R,7] + M_NFSMAT[R,12] + iif(M_CLIDCC=1,0,M_NFSMAT[R,13])) - M_NFSMAT[R,8]
                    else
                      M_NFSMAT[R,10] = (M_NFSMAT[R,7] + M_NFSMAT[R,12] + iif(M_CLIDCC=1,0,M_NFSMAT[R,13])) - M_NFSMAT[R,8]
                    endif
                  else
                    M_NFSMAT[R,8] = (M_NFSMAT[R,7] - ((M_NFSMAT[R,7]/100) * (100-zPCARG1)))
                    M_NFSMAT[R,9] = (M_NFSMAT[R,8] * .01) * M_ICMICM
                    if str(zPCAESC, 1, 0) $ "37"
                      M_NFSMAT[R,11] = M_NFSMAT[R,7] - M_NFSMAT[R,8]
                    else
                      M_NFSMAT[R,10] = M_NFSMAT[R,7] - M_NFSMAT[R,8]
                    endif
                  endif
                else
                  if str(zPCAESC, 1, 0) $ "37"
                    M_NFSMAT[R,11] = M_NFSMAT[R,7] + M_NFSMAT[R,12]
                  else
                    M_NFSMAT[R,10] = M_NFSMAT[R,7] + M_NFSMAT[R,12]
                  endif
                endif
              else
                if M_ICMICM > 0
                  if AFIS00->FISICN = "S"
                    M_NFSMAT[R,8] = ((M_NFSMAT[R,7] + M_NFSMAT[R,12] + iif(M_CLIDCC=1,0,M_NFSMAT[R,13])) - (((M_NFSMAT[R,7] + M_NFSMAT[R,12])/100) * (100-zPCARG0)))
                  else
                    M_NFSMAT[R,8] = M_NFSMAT[R,7]
                  endif
                  M_NFSMAT[R,25] = M_ICMICM
                  M_NFSMAT[R,9] = (M_NFSMAT[R,8]*.01) * M_ICMICM
                else
                  if str(zPCAESC, 1, 0) $ "37"
                    M_NFSMAT[R,11] = M_NFSMAT[R,7] + M_NFSMAT[R,12]
                  else
                    M_NFSMAT[R,10] = M_NFSMAT[R,7] + M_NFSMAT[R,12]
                  endif
                endif
              endif
            endif
          endif
        endif

        if M_PCATRI = 4   // substituicao
          M_NFSMAT[R,8] = 0
          M_NFSMAT[R,9] = 0
          M_NFSMAT[R,11] = M_NFSMAT[R,7]
          M_NFSMAT[R,22] = M_NFSMAT[R,7]
        endif

        if L > 18
          msg("* * * Tecle (ENTER) * * *")
          lpnfs01()
          L=10
        endif

        L = L + 1

        M_TOTDSP = M_TOTDSP + M_NFSMAT[R,12]
        M_TOTBIC = M_TOTBIC + M_NFSMAT[R,8]
        M_TOTVIC = M_TOTVIC + M_NFSMAT[R,9]
        M_TOTISE = M_TOTISE + M_NFSMAT[R,10]
        M_TOTOUT = M_TOTOUT + M_NFSMAT[R,11]
        M_TOTVIP = M_TOTVIP + M_NFSMAT[R,13]
        M_TOTSUB = M_TOTSUB + M_NFSMAT[R,22]

    next && r

    if M_NFSBIF > 0                    && se base e informada
      M_TOTDSP = 0
      M_TOTBIC = 0
      M_TOTVIC = 0
      M_TOTISE = 0
      M_TOTOUT = 0
      M_TOTVIP = 0

      for R = 1 to len(M_NFSMAT)

        if M_NFSMAT[R,3] = 0
          loop
        endif

        valorespro(M_NFSMAT[R,3])

        M_NFSMAT[R,8] = ((M_NFSBIF / M_NFSVLN) * M_NFSMAT[R,7])
        M_NFSMAT[R,9] = (M_NFSMAT[R,8] * .01) * M_ICMICM
        M_NFSMAT[R,10] = (M_NFSMAT[R,7] - M_NFSMAT[R,8])
        if AFIS00->FISESC4 = 4
          M_NFSMAT[R,11] = M_NFSMAT[R,10]
          M_NFSMAT[R,10] = 0
        endif
        M_TOTDSP = M_TOTDSP + M_NFSMAT[R,12]
        M_TOTBIC = M_TOTBIC + M_NFSMAT[R,8]
        M_TOTVIC = M_TOTVIC + M_NFSMAT[R,9]
        M_TOTISE = M_TOTISE + M_NFSMAT[R,10]
        M_TOTOUT = M_TOTOUT + M_NFSMAT[R,11]
        M_TOTVIP = M_TOTVIP + M_NFSMAT[R,13]
      next
    endif

    for R = 1 to len(M_NFSMAT)                    && rateio de isentos

      if M_NFSMAT[R,3] = 0
        loop
      endif

      M_NFSMAT[R,7] = val(str(M_NFSMAT[R,7], 12, 2))
      M_NFSMAT[R,12] = val(str(M_NFSMAT[R,12], 12, 2))
      M_NFSMAT[R,8] = val(str(M_NFSMAT[R,8], 12, 2))
      M_NFSMAT[R,9] = val(str(M_NFSMAT[R,9], 12, 2))
      M_NFSMAT[R,10] = val(str(M_NFSMAT[R,10], 12, 2))
      M_NFSMAT[R,11] = val(str(M_NFSMAT[R,11], 12, 2))
      M_NFSMAT[R,13] = val(str(M_NFSMAT[R,13], 12, 2))

      M_NFSTOT = M_NFSTOT + M_NFSMAT[R,7 ]
      M_NFSBIC = M_NFSBIC + M_NFSMAT[R,8 ]
      M_NFSVIC = M_NFSVIC + M_NFSMAT[R,9 ]
      M_ISENFS = M_ISENFS + M_NFSMAT[R,10]
      M_OUTNFS = M_OUTNFS + M_NFSMAT[R,11]
      M_DSPNFS = M_DSPNFS + M_NFSMAT[R,12]
      M_NFSSUB = M_NFSSUB + M_NFSMAT[R,22]
    next

    ** compensacao de rateio **

    M_NFSMAT[lPosrat,7 ] = M_NFSMAT[lPosrat,7 ] + ((M_NFSVLN-(M_NFSSEG + M_NFSDSP + M_NFSVIP)) - M_NFSTOT)
    M_NFSMAT[lPosrat,8 ] = M_NFSMAT[lPosrat,8 ] + (M_TOTBIC - M_NFSBIC)
    M_NFSMAT[lPosrat,9 ] = M_NFSMAT[lPosrat,9 ] + (M_TOTVIC - M_NFSVIC)
    M_NFSMAT[lPosrat,10] = M_NFSMAT[lPosrat,10] + (M_TOTISE - M_ISENFS)
    M_NFSMAT[lPosrat,11] = M_NFSMAT[lPosrat,11] + (M_TOTOUT - M_OUTNFS)
    M_NFSMAT[lPosrat,12] = M_NFSMAT[lPosrat,12] + (M_TOTDSP - M_DSPNFS)

    M_NFSBIC = 0
    M_NFSVIC = 0

    for R = 1 to len(M_NFSMAT)                    && recalculo

      valorespro(M_NFSMAT[R,3])

      if M_NFSMAT[R,3] = 0
        loop
      endif

      M_NFSBIC = M_NFSBIC + M_NFSMAT[R,8]
      M_NFSVIC = M_NFSVIC + M_NFSMAT[R,9]

** Tratamento do IPI

      if zPCAESC = 2
        M_NFSMAT[R, 15] = M_NFSMAT[R, 7]
        M_NFSMAT[R, 16] = 0
      endif
      if zPCAESC = 3
        M_NFSMAT[R, 15] = 0
        M_NFSMAT[R, 16] = M_NFSMAT[R, 7]

      endif
      if zPCAESC = 4
        M_NFSMAT[R, 15] = M_NFSMAT[R, 7]
        M_NFSMAT[R, 16] = 0
      endif
      if zPCAESC = 5
        M_NFSMAT[R, 15] = 0
        M_NFSMAT[R, 16] = M_NFSMAT[R, 7]
      endif

    next

    aprnfs()

return ""

*******************
function NFPAULISTA
*******************

msw("AGUARDE ... ABRINDO ARQUIVOS * * *")

abre_cup0("80") // Cupom Mestre
abre_cup1("81") // Cupom Itens
abre_pcamor("82") // Morto Produtos

select ACUP01
copy stru to ACUPTM

select ACUP00
copy stru to ACP0TM

if file("ACUPTM.CDX")
  erase("ACUPTM.CDX")
endif

if file("ACP0TM.CDX")
  erase("ACP0TM.CDX")
endif

select 0
use ACUPTM exclusive
index on CUPMAT tag 1 to ACUPTM

select 0
use ACP0TM exclusive
index on CUPNUM tag 1 to ACP0TM


private M_TELA

M_TELA = savescreen(01, 01, 23, 79)

set century off

do while .t.

   select ACUPTM
   zap
   select ACP0TM
   zap

   rodape("MANEXP1","CONTABILIDADE",M_FAN,"EAGRO41e","Mem: " + str(memory(0), 5),M_EMP)

   store ctod("  /  /  ")  to M_DATA1, M_DATA2
   store 0                 to M_TOTENT, M_TOTSAI, M_TOTFIS

   sombra(05, 16, 17, 63,_SOMBRA_)

   set color to GR+/R
   @ 05, 16 say  "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ 06, 16 say  "³ GERACAO ARQUIVO NOTA FISCAL PAULISTA         ³"
   @ 07, 16 say  "³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³"
   @ 08, 16 say  "³ Este processo gerar  um arquivo no diret¢rio ³"
   @ 09, 16 say  "³ \NFP  com a movimenta‡„o do periodo informa- ³"
   @ 10, 16 say  "³ do.                                          ³"
   @ 11, 16 say  "³                                              ³"
   @ 12, 16 say  "³----------------------------------------------³"
   @ 13, 16 say  "³            Periodo de:                       ³"
   @ 14, 16 say  "³                     a:                       ³"
   @ 15, 16 say  "³----------------------------------------------³"
   @ 16, 16 say  "³ Nome do Arquivo Gerado:                      ³"
   @ 17, 16 say  "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
   set color to

   SetColor(_COREDICAO_)
   @ 13, 41 get M_DATA1
   @ 14, 41 get M_DATA2
   read
   set color to

   if lastkey() = 27
      exit
   endif

   M_REL = "C:\NFP\N" + strzero(day(M_DATA1),2) + strzero(month(M_DATA1),2) + right(str(year(M_DATA1),4),2) + ".TXT"

   set color to GR+/R
   @ 16, 42 say M_REL
   set color to

   select ACUP01

   select ACUP00
   set relation to str(CUPCLI, 7, 0) into ACLI00,;
                to           CUPNATN into AFIS00

   set order to 2

   dbseek(str(ME_EMP, 2, 0) + dtos(M_DATA1),.t.)

   msw("* * * P R O C E S S A N D O   S A I D A - (ESC) Cancela * * *")

   msw("* * * AGUARDE!!! GERANDO ARQ EXPORTACAO (" + M_REL + " )... * * *")

   set century on
   set print on
   set printer to &M_REL
   set console off

   M_TIP50 = 0
   M_TIP54 = 0
   M_PROD = { }
   M_DTHANT := ctod(" ")  // Data e Hora para calculo do cupom
   M_TIMEAN := " "        // Hora para calculo do cupom

   N20 = 0
   N30 = 0
   N40 = 0
   N50 = 0
   N60 = 0

   ?? "ï»¿10"
   ?? "|"
   ?? "1,00" // versao do layout
   ?? "|"
   ?? right(AEMP00->EMPCGC,14)
   ?? "|"
   ?? M_DATA1
   ?? "|"
   ?? M_DATA2

        do while !eof()

          @ 24, 00 say CUPDTE

          if str(CUPEMP, 2, 0) + dtos(CUPDTE) > str(ME_EMP, 2, 0) + dtos(M_DATA2)
            exit
          endif

          if left(CUPNATN,1) < "5"
            skip
            loop
          endif

          if CUPCLI = 9999999 .or. CUPCLI = 99999
            skip
            loop
          endif

          if CUPDTE >= ctod("01/11/2010")
            if CUPNCU = 0
              msg("* * * Cupom: " + str(CUPNUM, 6) + " " + CUPSER + " Sem Ccf - Corrigir * * *")
            endif
          endif

          select ACP0TM
          if dbseek(ACUP00->CUPNUM)
            select ACUP00
            skip
            loop
          endif

          select ACP0TM
          append blank
          replace CUPNUM with ACUP00->CUPNUM
          replace CUPNCU with ACUP00->CUPNCU

          select ACUP00

          lNao = .f.

          if !valorescli(ACUP00->CUPCLI)
            lNao = .t.
            msg("* * * CLIENTE NAO CADASTRADO " + str(ACUP00->CUPCLI,7) + "CUPOM NUMERO: " + STR(ACUP00->CUPNUM,6) + " * * *")
            skip
            loop
          endif

          select ACLI00

          M_IES = strtran(zCLIIES1,".","")
          M_IES = strtran(M_IES,"-","")
          M_IES = strtran(M_IES,"/","")

          M_IES = strtran(M_IES," ","")
          M_IES = strtran(M_IES,"ME","")
          M_IES = iif("ISENT" $ M_IES,"",M_IES)

          AFIS00->(dbseek(ACUP00->CUPNATN))

          select ACUP00

          if !CUPDTE = M_DTHANT
            M_DTHANT := CUPDTE
            M_TIMEAN := ""
          endif

          ? "20" // tipo registro
          ?? "|"
          ?? "I" // tipo do registro (I)nclusao (R)etificacao (C)ancelamento
          ?? "|"
          ?? ""  // justificativa do cancelamento
          ?? "|"
          ?? AFIS00->FISNOM
          ?? "|"
          ?? "0" // serie unica
          ?? "|"
          ?? iif(CUPDTE >= ctod("01/11/2010"), strzero(CUPNCU, 6), strzero(CUPNUM,6))
          ?? "|"
          ?? CUPDTE
          ?? " "
          ?? iif(empty(CUPHOR), "08:00:00", CUPHOR)
          ?? "|"
          ?? CUPDTE
          ?? " "
          ?? iif(empty(CUPHOR), "08:00:00", CUPHOR)
          ?? "|"
          ?? "1" // tipo da nota (0)entrada ou (1)saida
          ?? "|"
          ?? alltrim(strtran(AFIS00->FISNOV,".",""))
          ?? "|"
          ?? ""  // ie do substituto tributario
          ?? "|"
          ?? ""  // inscricao municipal
          ?? "|"

          if len(alltrim(zCLICGC1))=15
            ?? right(zCLICGC1,14)
          else
            if !empty(zCLICGC1)
              ?? pad(alltrim(zCLICGC1),11)
            endif
          endif

          ?? "|"
          ?? zCLINOM
          ?? "|"
          ?? zCLIEND2
          ?? "|"
          ?? "0" // NUMERO
          ?? "|"
          ?? "" // COMPLEMENTO
          ?? "|"
          ?? zCLIBAI2
          ?? "|"
          ?? zCLIMUN2
          ?? "|"
          ?? zCLIUF2
          ?? "|"
          ?? strzero(zCLICEP2,5)
          ?? strzero(zCLICCL2,3)
          ?? "|"
          ?? "BRASIL"   // nome do pais
          ?? "|"
          ?? ""   // telefone
          ?? "|"
          ?? M_IES

          N20 ++

          select ACUP01
          go top
          dbseek(str(ACUP00->CUPEMP, 2) + str(ACUP00->CUPNUM, 6) + ACUP00->CUPSER,.t.)

          if !str(CUPEMP, 2) + str(CUPNUM, 6) + CUPSER = str(ACUP00->CUPEMP, 2) + str(ACUP00->CUPNUM, 6) + ACUP00->CUPSER
            msg("* * * Cupom: " + str(ACUP00->CUPNUM, 6, 0) + " "  + ACUP00->CUPSER + " sem itens - recadastre-o * * *")
          endif

          M_ALIQ = { }
          M_IT = 0
          M_FRETE = 0
          M_DIFER = ACUP00->CUPVLN
          M_IPI = 0

          do while !eof()

            if !str(CUPEMP, 2, 0) + str(CUPNUM, 6, 0) + CUPSER == str(ACUP00->CUPEMP, 2, 0) + str(ACUP00->CUPNUM, 6, 0) + ACUP00->CUPSER
              exit
            endif

            zPCALOT = " "
            zPCAMAT = 0
            zPCADES = space(40)
            zPCAUNI = "  "
            zPCATRI = 0

            if !valorespro(ACUP01->CUPMAT)
              alertnew("Produto nao encontrado: " + str(ACUP01->CUPMAT,6))
            endif

            if zPCAMAT = 1 // frete
              M_FRETE += CUPVLI
              M_DIFER -= CUPVLI
              skip
              loop
            endif

            ? "30"
            ?? "|"
            ?? alltrim(str(zPCAMAT,6)) // CODIGO DO PRODUTO
            ?? "|"
            ?? zPCADES
            ?? "|"
            ?? "" // CODIGO NCM
            ?? "|"
            ?? alltrim(zPCAUNI)
            ?? "|"
            ?? strtran(alltrim(str(CUPQDE,10,4)),".",",")
            ?? "|"
            ?? strtran(alltrim(str(ACUP01->CUPPRB,16,4)),".",",")
            ?? "|"
            ?? strtran(alltrim(str(ACUP01->CUPVLI,16,2)),".",",")
            ?? "|"
            ?? "0"

            M_DIFER -= CUPVLI

            // 00 tributado integral
            // 10 tributado e com cobranca de substituicao tributaria
            // 20 com reducao de base de calculo
            // 30 isenta ou nao tributado e com cobranca do icms por subs
            // 40 isenta
            // 41 nao tributada
            // 50 suspensao
            // 51 diferimento
            // 60 icms cobrado anteriormente por substituicao tributaria
            // 70 com reducao e cobranca por substituicao

            do case
              case zPCATRI = 1
                ?? "00"
              case zPCATRI = 2
                ?? "40"
              case zPCATRI = 3
                if M_CLIUF2 = "SP"
                  ?? "40"
                else
                  ?? "20"
                endif
             case zPCATRI = 5
               ?? "60"
             case ACUP01->CUPSUB == "S"
               ?? "30"
             case ACUP01->CUPSUB = "N"
               ?? "00"
            endcase

            ?? "|"
            ?? strtran(alltrim(str(0, 5, 2)),".",",")
            ?? "|"
            ?? strtran(alltrim(str(0, 5, 2)),".",",")
            ?? "|"
            ?? strtran(alltrim(str(0, 10,2)),".",",")
            M_IPI += 0

            N30 ++

            skip

          enddo

****** 40 REGISTRO TOTAL DO ICMS 40 ************

            ? "40"
            ?? "|"
*           ?? strtran(alltrim(str(ANFS00->NFSBIC,15,2)),".",",")  // 43 BASE ICMS
            ?? "0,00"
            ?? "|"
*           ?? strtran(alltrim(str(ANFS00->NFSVIC,15,2)),".",",")  // 44 VALOR ICMS
            ?? "0,00"
            ?? "|"
            ?? "0,00"                              // 45
            ?? "|"
            ?? "0,00"                              // 46
            ?? "|"
            ?? strtran(alltrim(str(ACUP00->CUPVLN,15,2)),".",",")  // 47
            ?? "|"
            ?? strtran(alltrim(str(M_FRETE,15,2)),".",",")  // 47
            ?? "|"
            ?? "0,00"                              // 49 SEGURO
            ?? "|"
            ?? strtran(alltrim(str(ACUP00->CUPDSC,15,2)),".",",")  // 50 DESCONTO
            ?? "|"
            ?? strtran(alltrim(str(M_IPI,15,2)),".",",")  // 51 IPI
            ?? "|"
            ?? "0,00"  // 52 OUTRAS DESPESAS
            ?? "|"
            ?? strtran(alltrim(str(ACUP00->CUPVLN,15,2)),".",",")  // 53 VALOR TOTAL CUPOM
            ?? "|"
            ?? "" // 54
            ?? "|"
            ?? "" // 55
            ?? "|"

            N40 ++

          select ACP0TM
          replace CUPNUM with ACUP00->CUPNUM
          replace CUPNCU with ACUP00->CUPNCU
          replace CUPVLP with ACUP00->CUPVLP
          replace CUPDSC with ACUP00->CUPDSC
          replace CUPVLN with ACUP00->CUPVLN
          replace CUPCPG with ACUP00->CUPCPG
          replace CUPNATN with ACUP00->CUPNATN

          select ACUP00

****** 50 REGISTRO FRETE 50 ************

            ? "50"
            ?? "|"
            ?? "1"  // 58
            ?? "|"
            ?? ""  // 59
            ?? "|"
            ?? ""  // 60
            ?? "|"
            ?? ""  // 61
            ?? "|"
            ?? ""  // 62
            ?? "|"
            ?? ""  // 63
            ?? "|"
            ?? ""  // 64
            ?? "|"
            ?? ""  // 65
            ?? "|"
            ?? ""  // 66
            ?? "|"
            ?? ""  // 67
            ?? "|"
            ?? ""  // 68
            ?? "|"
            ?? ""  // 69
            ?? "|"
            ?? ""  // 70
            ?? "|"
            ?? ""  // 71
            ?? "|"
            ?? ""  // 72

           ? "60|||"

           N50 ++
           N60 ++

********* CUPOM CANCELADO

          if CUPCAN == "C"
            ? "20" // tipo registro
            ?? "|"
            ?? "C" // tipo do registro (I)nclusao (R)etificacao (C)ancelamento
            ?? "|"
            select ANFSCAN
            if dbseek(str(ACUP00->CUPEMP, 2) + str(ACUP00->CUPNUM,6) + ACUP00->CUPSER)
              ?? alltrim(MOTIVO)
            else
              ?? "PROBLEMA NA IMPRESSAO DO CUPOM"  // justificativa do cancelamento
            endif

            select ACUP00

            ?? "|"
            ?? AFIS00->FISNOM
            ?? "|"
            ?? "0" // serie unica
            ?? "|"
            ?? iif(CUPDTE >= ctod("01/11/2010"), strzero(CUPNCU, 6), strzero(CUPNUM,6))
            ?? "|"
            ?? CUPDTE
            ?? " "
            ?? iif(empty(CUPHOR), "08:00:00", CUPHOR)
            ?? "|"
            ?? CUPDTE
            ?? " "
            ?? iif(empty(CUPHOR), "08:00:00", CUPHOR)
            ?? "|"
            ?? "1" // tipo da nota (0)entrada ou (1)saida
            ?? "|"
            ?? alltrim(strtran(AFIS00->FISNOV,".",""))
            ?? "|"
            ?? ""  // ie do substituto tributario
            ?? "|"
            ?? ""  // inscricao municipal
            ?? "|"

            if len(alltrim(zCLICGC1))=15
              ?? right(zCLICGC1,14)
            else
              if !empty(zCLICGC1)
                ?? pad(alltrim(zCLICGC1),11)
              endif
            endif
            ?? "|"
            ?? zCLINOM
            ?? "|"
            ?? zCLIEND2
            ?? "|"
            ?? "0" // NUMERO
            ?? "|"
            ?? "" // COMPLEMENTO
            ?? "|"
            ?? zCLIBAI2
            ?? "|"
            ?? zCLIMUN2
            ?? "|"
            ?? zCLIUF2
            ?? "|"
            ?? strzero(zCLICEP2,5)
            ?? strzero(zCLICCL2,3)
            ?? "|"
            ?? "BRASIL"   // nome do pais
            ?? "|"
            ?? ""   // telefone
            ?? "|"
            ?? M_IES

            N20 ++
          endif

          select ACUP00

          skip

        enddo

        ? "90" // RODAPE
        ?? "|"
        ?? strzero(N20,5)
        ?? "|"
        ?? strzero(N30,5)
        ?? "|"
        ?? strzero(N40,5)
        ?? "|"
        ?? strzero(N50,5)
        ?? "|"
        ?? strzero(N60,5)

   set print off
   set printer to
   set console on


   msg("* * * FIM DO PROCESSO DE GERACAO DE ARQUIVO * * *")
   exit


enddo

restscreen(01, 01, 23, 79, M_TELA)

fecha_arq()



****************
function MANGEL1
****************

private M_TELA,;
        M_OPC

M_TELA = savescreen(01, 01, 23, 79)
set key -1 to FUNCLI()

do while .t.

        rodape("ROTULO","ARGOX",M_FAN,"EAGRO21","Mem: " + str(memory(0), 5),M_EMP)

        store 0              to M_NFSINI,M_NFSFIN
        store AEMP00->EMPSER to M_SERINI,M_SERFIN
        M_VOLUME = 0
        M_NFSCLI = 0
        M_DESCRI =  space(25)

        nbox(09, 35, 14, 67,"W/W+",.t.)
          setcolor("B/W")
          @ 10, 36 say           "Cliente:                       "
          @ 11, 36 say           "Obs:                           "
          @ 12, 36 say           "Nota:         Serie:           "
          @ 13, 36 say           "Volumes:                       "
        set color to

        @ 10, 45 get     M_NFSCLI picture "#####"
        @ 11, 41 get     M_DESCRI
        @ 12, 42 get     M_NFSINI picture "######"
        @ 12, 57 get     M_SERINI picture "@!"
        @ 13, 45 get     M_VOLUME picture "##" valid M_VOLUME > 0
        read

        if lastkey()=27
          exit
        endif

        emigel1()

enddo

restscreen(01, 01, 23, 79,M_TELA)

return ""

***************
function EMIGEL1
***************

 lTemcli = .t.

 if M_NFSCLI = 0
  if !BUSCAREGISTRO("ANFS00",1,{str(ME_EMP, 2, 0),str(M_NFSINI, 6, 0),aspas(M_SERINI)},"SELECT")
     msg("* * * NOTA FISCAL NAO ENCONTRADA * * *")
     return ""
   endif
   M_NFSCLI = NFSCLI
   lTemcli = .f.
 endif

 if file("C:\NFE\SAINFE.TXT")
   erase("C:\NFE\SAINFE.TXT")
 endif

 ACBrNFe_ENT := "C:\NFE\ENTARG.TXT"
 ACBrNFe_SAI := "C:\NFE\SAIARG.TXT"
 ACBrNFe_TMP := "C:\NFE\ARQTMP.TXT"


 for ABC = 1 to M_VOLUME

   BUSCAREGISTRO("ACLI00",1,{str(M_NFSCLI,7,0)},"SELECT")
   BUSCAREGISTRO("ATRA00",1,{str(ANFS00->NFSTRA,3,0)},"SELECT")

   select ANFS00
   
   mon_env("ETQ.ativar")

   cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
   mon_env('ETQ.ImprimirTexto( 0, 3, 1, 1, 450, 45, "' + alltrim(ACLI00->CLINOM) + '")')
   cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
   mon_env('ETQ.ImprimirTexto( 0, 3, 1, 1, 380, 45, "' + alltrim(ACLI00->CLIEND2) + '")')
   cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
   mon_env('ETQ.ImprimirTexto( 0, 3, 1, 1, 310, 45, "' + alltrim(ACLI00->CLIBAI2) +    ' - ' + strzero(ACLI00->CLICEP2,5) + "-" + strzero(ACLI00->CLICCL2,3) + '")')
   cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
   mon_env('ETQ.ImprimirTexto( 0, 4, 1, 1, 230, 45, "' + alltrim(ACLI00->CLIMUN2) +    ' - ' + ACLI00->CLIUF2 + '")')
   cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

   if lTemcli = .t.
     mon_env('ETQ.ImprimirTexto( 0, 4, 1, 1, 130, 45, "' + M_DESCRI + '")')
     cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
   else
     mon_env('ETQ.ImprimirTexto( 0, 4, 1, 1, 130, 45, "NF. ' + strzero(NFSNUM,6) + " VOL: " + alltrim(str(ABC,2)) + " / " + alltrim(str(M_VOLUME,2)) + '")')
     cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
     mon_env('ETQ.ImprimirTexto( 0, 4, 1, 1,  40, 40, "' + alltrim(ATRA00->TRANOM) + '")')
     cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
   endif

   mon_env("etq.imprimir(1,0)")
   cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
   mon_env("ETQ.Desativar")
   cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

 next

  ACBrNFe_ENT = "C:\NFE\ENTNFE.TXT"
  ACBrNFe_SAI = "C:\NFE\SAINFE.TXT"

 return ""

*******************
function VALORESPRO(PRODUTO)
*******************

          seexistesql("APCA00")
          sqlRELATION = {}
          sqlCAMPO = {}
          sqlCHAVE =  {}
          sqlARQUI = {}
          sqlORDEM = {}

          aadd(sqlARQUI,{"APCA00","APCA00"})
          aadd(sqlCAMPO,"APCA00.*")
          aadd(sqlCAMPO,"S1.SLDDIS as SALDO1")
          aadd(sqlCAMPO,"S2.SLDDIS as SALDO2")
          aadd(sqlCAMPO,"S1.SLDPRC")
          aadd(sqlRELATION,{"ASLD00 S1",str(1, 2, 0),"S1.SLDEMP"})
          aadd(sqlRELATION,{"","S1.SLDMAT","APCA00.PCAMAT"})
          aadd(sqlRELATION,{"ASLD00 S2",str(10, 2, 0),"S2.SLDEMP"})
          aadd(sqlRELATION,{"","S2.SLDMAT","APCA00.PCAMAT"})
          aadd(sqlCHAVE,"PCAMAT = " + str(PRODUTO,6,0))

if !sqlrelation()
  return .f.
endif

*if !BUSCAREGISTRO("APCA00",1,{str(PRODUTO,6,0)},"SELECT")
*  if !BUSCAREGISTRO("APCMOR",1,{str(PRODUTO,6,0)},"SELECT")
*    return .f.
*  endif
*endif

zPCALOT = PCALOT
zPCAMAT = PCAMAT
zPCADES = PCADES
zPCAUNI = PCAUNI
zPCATRI = PCATRI
zPCAREF= PCAREF
zPCALIS= PCALIS
zPCAGRP= PCAGRP
zPCAMAR = PCAMAR
zPCANCM = PCANCM
zPCAPLQ= PCAPLQ
zPCAFOR= PCAFOR
zPCACSP= PCACSP
zPCACOU= PCACOU
zPCARG1= PCARG1
zPCARG2= PCARG2
zPCARG0= PCARG0
zPCAIC1= PCAIC1
zPCAIC2= PCAIC2
zPCAIC0= PCAIC0
zPCAIPI= PCAIPI
zPCAPRB= PCAPRB
zPCAEMB= PCAEMB
zPCADOS= PCADOS
zPCAESC= PCAESC
zPCACOM= PCACOM
zPCAFAB= PCAFAB
zPCADSC= PCADSC
zREFERE01 = REFERE01
zREFERENC = REFERENC

zSLD01 = SALDO1
zSLD51 = 0
zSLD10 = SALDO2

return .t.
