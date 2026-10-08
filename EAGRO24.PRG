#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)
#command @ <row> , <col>  GET <var> [<clauses,...>] F2 [<moreClauses,...>] funcao <func> retorno <Variavel>;
=>       @ <row> , <col>  GET <var> [<clauses>] SEND reader := {|oGet| Getf2(oGet,<func>,<Variavel>) } [<moreClauses>]
#define CRLF   chr( 13 )+chr( 10 )
***************
function MANCLI
***************
parameters M_OPC,M_OPC1,M_OPC2

nLincli = 3
#include "ptmenu.ch"

    _FUNCLI_ = "CLIENTE.t."
    _FUNPRO_ = "CLIENTE.f."
    _FUNFOR_ = "CLIENTE.f."
    _FUNCPG_ = "CLIENTE.f."
    _FUNTRA_ = "CLIENTE.f."
    _FUNVEN_ = "CLIENTE.f."
    _FUNPLX_ = "CLIENTE.f."
    _FUNMUN_ = "CLIENTE"

*        @ 05, 19 prompt "InclusÑo " HIGHLITE R/BG            PERMITE 4,2,1
*        @ 06, 19 prompt "AlteraáÑo" HIGHLITE R/BG            PERMITE 4,2,2
*        @ 07, 19 prompt "Consulta " HIGHLITE R/BG            PERMITE 4,2,3
*        @ 08, 19 prompt "ExclusÑo " HIGHLITE R/BG            PERMITE 4,2,4
*        @ 09, 19 prompt "Listagem " HIGHLITE R/BG            PERMITE 4,2,5
*        @ 10, 19 prompt "Etiqueta " HIGHLITE R/BG POSITION 2 PERMITE 4,2,6
 *       @ 11, 19 prompt "Morto    " HIGHLITE R/BG POSITION 2 PERMITE 4,2,6
 *       @ 12, 19 prompt "TipoCli  " HIGHLITE R/BG POSITION 2 PERMITE 4,2,6

      do case
         case M_OPC = 1 ; inccli()
         case M_OPC = 2 ; altcli()
         case M_OPC = 3 ; concli("NORMAL")
         case M_OPC = 4 ; exccli()
         case M_OPC = 5 ; liscli(M_OPC1)
         case M_OPC = 6 ; eticli(M_OPC1)
         case M_OPC = 7 ; concli("MORTO")
         case M_OPC = 8 ; tipocli(M_OPC1)
      endcase

    fecha_arq()

return ""

***************
function INCCLI
***************
   LOCAL aPalette   := Wvt_GetPalette()
   LOCAL aNewPalette:= aclone( aPalette )
   LOCAL aObjects   := WvtSetObjects( {} )
   LOCAL aBlocks    := {}

   aAdd( aBlocks, {|| Wvt_DrawLine( 03+nLincli,29,03+nLincli,92 ) })
   aAdd( aBlocks, {|| Wvt_DrawLine( 07+nLincli,36,07+nLincli,92 ) })
   aAdd( aBlocks, {|| Wvt_DrawLine( 11+nLincli,33,11+nLincli,92 ) })
   aAdd( aBlocks, {|| Wvt_DrawLine( 15+nLincli,40,15+nLincli,92 ) })
   aAdd( aBlocks, {|| Wvt_DrawLine( 18+nLincli,41,18+nLincli,92 ) })
   aAdd( aBlocks, {|| Wvt_DrawBoxGroupRaised(nLincli, 04, 21+nLincli, 93) } )

   aAdd( aBlocks, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )

   aLastPaint := WvtSetBlocks( aBlocks )


*   @ 03+nLincli, 04 say     "           Dados Cliente ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ "


   do while .t.

     tlcli01() 

      keyfun()

      rodape("INCLUI","CLIENTE",M_FAN,"EAGRO24","Mem: " + str(memory(0), 5),M_EMP)

      M_CLICOD = AEMP00->EMPCLI + 1

*      SetColor(_COREDICAO_)
*      @ 02+nLincli, 15 get     M_CLICOD   picture "#######"
*      read

      if lastkey() = 27
        msg("* * * CLIENTE NAO INCLUIDO * * *")
        exit
      endif

      M_CLICGC1  = space(15)
      M_CLITIP   = "C"
      M_CLINOM   = space(40)
      M_CLIDTE   = date()
      M_CLIEND1  = space(40)
      M_CLINRO1  = space(05)
      M_CLICPE1  = space(10)
      M_CLIUF1   = space(02)
      M_CLIBAI1  = space(20)
      M_CLICEP1  = 0
      M_CLICCL1  = 0
      M_CLICCL2  = 0
      M_CLICCL3  = 0
      M_CLICDM1  = 0
      M_CLIMUN1  = space(32)
      M_CLITEL1  = space(15)
      M_CLIFAX1  = space(15)
      M_CLITEX1  = space(15)
      M_CLIIES1  = pad("N/C",17)
      M_CLIREG   = 0
      M_CLIDCC   = 0
      M_CLIVEN   = 0
      M_CLICLF   = " "
      M_CLIEND2  = space(40)
      M_CLINRO2  = space(05)
      M_CLICPE2  = space(10)
      M_CLITRA   = 0
      M_CLIUF2   = space(2)
      M_CLIBAI2  = space(20)
      M_CLICEP2  = 0
      M_CLICDM2  = 0
      M_CLIMUN2  = space(32)
      M_CLIIES2  = pad("N/C",17)
      M_CLICGC2  = space(15)
      M_CLIAC    = space(15)
      M_CLIEND3  = space(40)
      M_CLINRO3  = space(05)
      M_CLICPE3  = space(10)
      M_CLIUF3   = space(2)
      M_CLIBAI3  = space(20)
      M_CLICEP3  = 0 
      M_CLICDM3  = 0
      M_CLIMUN3  = space(32)
      M_CLITEL3  = space(15)
      M_CLIFAX3  = space(15)
      M_CLITEX3  = space(15)
      M_CLICON   = space(15)
      M_CLIBCO   = 0
      M_CLIULC   = date()      // ctod("  /  /  ")
      M_CLISITE = space(40)
      M_CLIEMAIL = space(40)
      M_INDICADO = space(20)
      M_REVENDA = "N"

      set key 3 to nulo()
      set key 18 to nulo()

      edcli01(.t.)

      set key 3 to 
      set key 18 to

      if lastkey() = 27
        msg("* * * CLIENTE NAO INCLUIDO * * *")
        exit
      endif

    seexistesql("ACLIID")
    cSql := "select first 1 gen_id(ACLI00_id,1) from ACLI00"
    dbusearea(.t.,"SQLMIX",cSql,"ACLIID")
    M_ID = GEN_ID
    select ACLIID
    use
    M_CLICOD = M_ID

    do while .t.
      grcli01("SELECT")
      if !eof()
        seexistesql("ACLIID")
        cSql := "select first 1 gen_id(ACLI00_id,1) from ACLI00"
        dbusearea(.t.,"SQLMIX",cSql,"ACLIID")
        M_ID = GEN_ID
        select ACLIID
        use
        M_CLICOD = M_ID
        msw(str(M_CLICOD,7))
        loop
      endif
      exit
    enddo

    set color to I
       @ 01+nLincli, 15 say M_CLICOD   picture "#######"
    set color to

    grcli01("INSERT")                      && grava o cliente

    msg("* * * CLIENTE INCLUIDO * * *")

   enddo

   Wvt_SetPalette( aPalette )
   WvtSetObjects( aObjects )
   WvtSetBlocks( aLastPaint )

return ""

***************
function ALTCLI
***************

private aBlocks2 := { }
*aAdd( aBlocks2, {|| WVT_DRAWBOXGROUP(nLincli, 04, 21+nLincli, 93) } )
aAdd( aBlocks2, {|| Wvt_DrawBoxGroupRaised(nLincli, 04, 21+nLincli, 93) } )
aAdd( aBlocks2, {|| Wvt_DrawLine( 03+nLincli,29,03+nLincli,92 ) })
aAdd( aBlocks2, {|| Wvt_DrawLine( 07+nLincli,36,07+nLincli,92 ) })
aAdd( aBlocks2, {|| Wvt_DrawLine( 11+nLincli,33,11+nLincli,92 ) })
aAdd( aBlocks2, {|| Wvt_DrawLine( 15+nLincli,40,15+nLincli,92 ) })
aAdd( aBlocks2, {|| Wvt_DrawLine( 18+nLincli,41,18+nLincli,92 ) })
aAdd( aBlocks2, {|| Wvt_DrawBoxGroupRaised(nLincli, 04, 21+nLincli, 93) } )
aAdd( aBlocks2, {|| aEval( GetList, {|oGet| Wvt_DrawBoxGet( oGet:Row, oGet:Col, Len( Transform( oGet:VarGet(), oGet:Picture ) ) ) } ) } )

      aLastPaint1 := WvtSetBlocks( aBlocks2 )
      aLastPaint9 := aLastPaint1

    do while .t.

      tlcli01() 


      rodape("ALTERA","CLIENTE",M_FAN,"EAGRO24","Mem: " + str(memory(0), 5),M_EMP)

        store 0 to M_CLICOD
        SetColor(_COREDICAO_)
        @ 01+nLincli, 15 get M_CLICOD picture "#######"  F2 color _CORF2_ funcao "sele_arquivo('ACLI00')" retorno @M_CLICOD
        read

        if M_CLICOD = 0
          exit
        endif

        if !BUSCAREGISTRO("ACLI00",1,{str(M_CLICOD,7,0)},"SELECT")
          msg("* * * CLIENTE NAO CADASTRADO * * *")
          loop
        endif

        save get to M_G1
        MSCLI01a()
        restore get from M_G1

*       mscli01()

        M_CLICOD   = CLICOD
        M_CLICGC1  = CLICGC1
        M_CLITIP   = CLITIP
        M_CLINOM   = CLINOM
        M_CLIDTE   = iif(HB_ISNIL(CLIDTE),ctod("  /  /  "),CLIDTE)
        M_CLIEND1  = CLIEND1
        M_CLIUF1   = CLIUF1
        M_CLIBAI1  = CLIBAI1
        M_CLICEP1  = CLICEP1
        M_CLICCL1  = CLICCL1
        M_CLICCL2  = CLICCL2
        M_CLICCL3  = CLICCL3
        M_CLIMUN1  = CLIMUN1
        M_CLITEL1  = CLITEL1
        M_CLIFAX1  = CLIFAX1
        M_CLITEX1  = CLITEX1
        M_CLIIES1  = CLIIES1
        M_CLIREG   = CLIREG
        M_CLIDCC   = CLIDCC
        M_CLIVEN   = CLIVEN
        M_CLICLF   = CLICLF
        M_CLIEND2  = CLIEND2
        M_CLITRA   = CLITRA
        M_CLIUF2   = CLIUF2
        M_CLIBAI2  = CLIBAI2
        M_CLICEP2  = CLICEP2
        M_CLIMUN2  = CLIMUN2
        M_CLIIES2  = CLIIES1
        M_CLICGC2  = CLICGC1
        M_CLIAC    = CLIAC
        M_CLIEND3  = CLIEND3
        M_CLIUF3   = CLIUF3
        M_CLIBAI3  = CLIBAI3
        M_CLICEP3  = CLICEP3
        M_CLIMUN3  = CLIMUN3
        M_CLITEL3  = CLITEL3
        M_CLIFAX3  = CLIFAX3
        M_CLITEX3  = CLITEX3
        M_CLICON   = CLICON
        M_CLIBCO   = CLIBCO
        M_CLIULC   = iif(HB_ISNIL(CLIULC),ctod("  /  /  "),CLIULC)
        M_CLISITE  = CLISITE
        M_CLIEMAIL = CLIEMAIL
        M_INDICADO = pad(NOMEPAI,20)
        M_REVENDA = REVENDA

        M_CLINRO1  = CLINRO1
        M_CLICPE1  = CLICPE1
        M_CLICDM1  = CLICDM1

        M_CLINRO2  = CLINRO2
        M_CLICPE2  = CLICPE2
        M_CLICDM2  = CLICDM2

        M_CLINRO3  = CLINRO3
        M_CLICPE3  = CLICPE3
        M_CLICDM3  = CLICDM3

        edcli01(.f.)

        if lastkey() = 27
          msg("* * * CLIENTE NAO ALTERADO * * *")
          exit
        endif

        grcli01("UPDATE")                      && regrava o cliente

        aLastPaint1 := aLastPaint9
        WvtSetBlocks( aLastPaint1 )

        vermsgcli()

        aLastPaint1 := WvtSetBlocks( aBlocks2 )
        aLastPaint9 := aLastPaint1

        msg("* * * CLIENTE ALTERADO * * *")


    enddo

aLastPaint1 := aLastPaint9
WvtSetBlocks( aLastPaint1 )

return ""

******************
function VERMSGCLI
******************
local cInicIMG4ORIG := Wvt_SaveScreen(05, 05, 17, 78)  // salva a tela
local scr := SaveScreen(05, 05, 17, 78 )

private TESTE,MENSAGEM,M_MEMO,M_ARQ,lSaida,lGrava
private M_LINHA1,M_LINHA2,M_LINHA3,M_LINHA4,M_LINHA5
private M_VISTA,M_CHEQUE,M_BOLETO




  M_LINHA1 = space(69)
  M_LINHA2 = space(69)
  M_LINHA3 = space(61)
  M_LINHA4 = space(61)
  M_LINHA5 = space(61)
  M_LINHA6 = space(61)

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}
  aadd(sqlARQUI,{"MENSAGE2","MENSAGE2"})
  aadd(sqlCAMPO,"*")
  aadd(sqlCHAVE,"CLICOD = " + str(M_CLICOD, 7, 0))
  if sqlrelation()
    M_LINHA1 = MOTIVO0
    M_LINHA2 = MOTIVO1
    M_LINHA3 = email1
    M_LINHA4 = email2
    M_LINHA5 = email3
    M_LINHA6 = email4
  endif

  save get to M_LOCGEG


nbox(05, 05, 15, 76,"W/W+",.t.)
setcolor("B/W")
  @ 06, 06 say   padc(alltrim(ACLI00->CLINOM),71)
  @ 07, 06 say   "                                                                     "
  @ 08, 06 say   "                                                                     "
  @ 09, 06 say   "                                                                     "
  @ 10, 06 say   "                                                                     "
  @ 11, 06 say   "email:                                                               "
  @ 12, 06 say   "email:                                                               "
  @ 13, 06 say   "email:                                                               "
  @ 14, 06 say   "email:                                                               "
  SetColor(_COREDICAO_)

  @ 08, 06 get M_LINHA1
  @ 09, 06 get M_LINHA2
  @ 11, 13 get M_LINHA3
  @ 12, 13 get M_LINHA4
  @ 13, 13 get M_LINHA5
  @ 14, 13 get M_LINHA6
  read
  setcolor("")


  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {"MENSAGE2","UPDATE OR INSERT"}
  aadd(sqlCHAVE,{"CLICOD"})
  aadd(sqlCAMPO,{"CLICOD",str(M_CLICOD,7),.T.})
  aadd(sqlCAMPO,{"MOTIVO0",M_LINHA1,.T.})
  aadd(sqlCAMPO,{"MOTIVO1",M_LINHA2,.T.})
  aadd(sqlCAMPO,{"email1",M_LINHA3,.T.})
  aadd(sqlCAMPO,{"email2",M_LINHA4,.T.})
  aadd(sqlCAMPO,{"email3",M_LINHA5,.T.})
  aadd(sqlCAMPO,{"email4",M_LINHA6,.T.})
  executasql()

   RestScreen(05, 05, 17, 78, scr )
   Wvt_RestScreen(05, 05, 17, 78, cInicIMG4ORIG,.t. )


  restore get from M_LOCGEG
  set cursor on
  return .t.

return .t.

***************
function CONCLI(TIPO)
***************

if TIPO == "NORMAL"
*  select ACLI00
*  use
*  abre_cli("0")
else
*  select ACLI00
*  use
*  aliascli("0")  // abre arquivo morto com alias APCA00
endif


    do while .t.

      store 0         to M_CLICOD
      store space(40) to M_CLINOM
      store space(15) to M_CLICGC
      store space(32) to M_CLIMUN1

      tlcli01() 

      save get to M_G1

      sqlRELATION = {}
      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {}
      sqlORDEM = {}
      aadd(sqlARQUI,{"ACLI00","ACLI00"})
      aadd(sqlCAMPO,"first 0 *")
      sqlrelation()

      SELECT ACLI00
      go top
      skip -1

*      DispBegin()
      MSCLI01a()
 *     DispEnd()

      restore get from M_G1

      keyfun()

      rodape("CONSULTA","CLIENTE",M_FAN,"EAGRO24","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 01+nLincli, 15 get  M_CLICOD   picture "#######" F2 color _CORF2_ funcao "sele_arquivo('ACLI00')" retorno @M_CLICOD

        read

        if lastkey() = 27
          exit
        endif


        if M_CLICOD = 0
          SetColor(_COREDICAO_)
          @ 01+nLincli, 33 get     M_CLICGC  picture "@R 999.999.999/9999-99"
          read
        endif

        if lastkey() = 27
          exit
        endif

        if empty(M_CLICGC) .and. M_CLICOD = 0
          SetColor(_COREDICAO_)
          @ 02+nLincli, 15 get     M_CLINOM picture "@!"
          read
          if lastkey() = 27
            exit 
          endif
          if empty(M_CLINOM)
            SetColor(_COREDICAO_)
            @ 04+nLincli, 51 get     M_CLIMUN1 picture "@!"
            read
            if empty(M_CLIMUN1)
              exit 
            endif
          endif
        endif

        select ACLI00

        do case
           case M_CLICOD > 0
              sqlRELATION = {}
              sqlCAMPO = {}
              sqlCHAVE =  {}
              sqlARQUI = {}
              sqlORDEM = {}
              aadd(sqlARQUI,{"ACLI00","ACLI00"})
              aadd(sqlCAMPO,"first 100 *")
              aadd(sqlCHAVE,"CLICOD >= " + str(M_CLICOD, 6, 0))
              aadd(sqlORDEM,"CLICOD")

              sqlrelation()

           case M_CLICGC != space(15)
              sqlRELATION = {}
              sqlCAMPO = {}
              sqlCHAVE =  {}
              sqlARQUI = {}
              sqlORDEM = {}
              aadd(sqlARQUI,{"ACLI00","ACLI00"})
              aadd(sqlCAMPO,"first 100 *")
              aadd(sqlCHAVE,"CLICGC1 >= " + aspas(alltrim(M_CLICGC)))
              aadd(sqlORDEM,"CLICGC1")
              sqlrelation()
           case M_CLINOM != space(40)
              sqlRELATION = {}
              sqlCAMPO = {}
              sqlCHAVE =  {}
              sqlARQUI = {}
              sqlORDEM = {}
              aadd(sqlARQUI,{"ACLI00","ACLI00"})
              aadd(sqlCAMPO,"first 100 *")
              aadd(sqlCHAVE,"CLINOM >= " + aspas(alltrim(M_CLINOM)))
              aadd(sqlORDEM,"CLINOM")
              sqlrelation()
           case M_CLIMUN1 != space(20)
              sqlRELATION = {}
              sqlCAMPO = {}
              sqlCHAVE =  {}
              sqlARQUI = {}
              sqlORDEM = {}
              aadd(sqlARQUI,{"ACLI00","ACLI00"})
              aadd(sqlCAMPO,"first 100 *")
              aadd(sqlCHAVE,"CLIMUN1 >= " + aspas(alltrim(M_CLIMUN1)))
              aadd(sqlORDEM,"CLIMUN1")
              sqlrelation()
        endcase


*       setasmor()

        do while .t.



      save get to M_G1

*      set console off
  *    DispBegin()
      MSCLI01a()
  *    DispEnd()
 *     set console on

      restore get from M_G1

*          mscli01()

          WAITSTATE()

          if TIPO == "NORMAL"
            if lastkey()= -41  // envia para arquivo morto
              nEnvia = 0
              do while .t.
                nEnvia = alertnew("Deseja enviar este cliente para;o arquivo morto",{"Escolha","Sim","Nao"})
                if nEnvia > 1
                  exit
                endif
              enddo
              if nEnvia = 2  // arquivo morto
                arecord = getrecord(recno())

                select ACLMOR
                append blank

                do while .t.
                  if rlock()
                    putrecord(arecord,recno())
                    unlock   
                    commit
                    exit
                  else
                    msg("* * * (" + alias() + ") REGISTRO SENDO USADO * * *") 
                  endif
                  if lastkey()=17
                    exit
                  endif
                enddo
                select ACLI00
                elimina()
                dbskip(+1)
              endif
            endif
          endif

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

    enddo

return ""

***************
function EXCCLI
***************

private M_OPC

    do while .t.

      tlcli01() 


       keyfun()

        rodape("EXCLUI","CLIENTE",M_FAN,"EAGRO24","Mem: " + str(memory(0), 5),M_EMP) 

        store 0 to M_CLICOD
        SetColor(_COREDICAO_)
        @ 04+nLincli, 15 get     M_CLICOD   picture "#######"
        read

        if M_CLICOD = 0 
          exit
        endif

        select ACLI00

        if !dbseek(str(M_CLICOD, 7, 0))
          msg("* * * CLIENTE NAO CADASTRADO * * *")
          loop
        endif
        
        mscli01()

        if !rlock()
          msg("* * * (ACLI00) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_OPC = confirma("Deste Cliente")

        if M_OPC != 1
          msg("* * * CLIENTE NAO EXCLUIDO * * *")
          unlock
          loop
        endif

        elimina() 

        msg("* * * CLIENTE EXCLUIDO * * *")

    enddo

return ""

***************
function LISCLI
*************** 
parameters M_OPC,M_OPC1,M_OPC2

private M_CLI1 ,;
        M_CLI2 ,;
        M_NOM1 ,;
        M_NOM2 ,;
        M_CGC1 ,;
        M_CGC2 ,;
        M_TIPO ,;
        M_REGI ,;
        M_VEND 

        M_CLI1 = 0
        M_CLI2 = 0
        M_NOM1 = space(40)
        M_NOM2 = space(40)
        M_MUN1 = space(20)
        M_MUN2 = space(20)
        M_CGC1 = space(15)
        M_CGC2 = space(15)
        M_TIPO = space(01)
        M_REGI = 0
        M_VEND = 0

*          @ 10, 25 prompt   "Completa Codigo     "  POSITION 10 HIGHLITE R/BG
*          @ 11, 25 prompt   "Completa CPF/CGC    "  POSITION 11 HIGHLITE R/BG
*          @ 12, 25 prompt   "Completa Alfabetica "  POSITION 10 HIGHLITE R/BG
*          @ 13, 25 prompt   "Catalogo Codigo     "  POSITION 12 HIGHLITE R/BG
*          @ 14, 25 prompt   "Catalogo CPF/CGC    "  POSITION 12 HIGHLITE R/BG
*          @ 15, 25 prompt   "Catalogo Alfabetica "  POSITION 11 HIGHLITE R/BG
 *         @ 16, 25 prompt   "Catalogo Municipio  "  POSITION 10 HIGHLITE R/BG

        do case
           case M_OPC = 1 .or. M_OPC = 4
              sombra(14, 40, 20, 63,_SOMBRA_)
              set color to GR+/W
                @ 14, 40 say          "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø" 
                @ 15, 40 say          "≥ CODIGO Inicial:      ≥" 
                @ 16, 40 say          "≥          Final:      ≥" 
                @ 17, 40 say          "≥   TIPO Cliente:      ≥" 
                @ 18, 40 say          "≥         Regiao:      ≥" 
                @ 19, 40 say          "≥       Vendedor:      ≥" 
                @ 20, 40 say          "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ" 
  SetColor(_COREDICAO_)

                @ 15, 58 get     M_CLI1 picture "#####"  
                @ 16, 58 get     M_CLI2 picture "#####"   
                @ 17, 58 get     M_TIPO picture "@!"
                @ 18, 58 get     M_REGI picture "##"
                @ 19, 58 get     M_VEND picture "###"
                read 
                if lastkey() = 27
                  return ""
                endif
                M_CLI1 = iif(M_CLI1 = 0,      1,M_CLI1)
                M_CLI2 = iif(M_CLI2 = 0,9999999,M_CLI2) 
                if M_OPC = 1
                  lisclia("CLIENTES EM ORDEM DE CODIGO")
                else
                  lisclib("CLIENTES EM ORDEM DE CODIGO")
                endif
           case M_OPC = 2 .or. M_OPC = 5
              sombra(14, 40, 20, 77,_SOMBRA_)
              set color to GR+/W
                @ 14, 40 say          "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø" 
                @ 15, 40 say          "≥CGC/CPF Inicial:                    ≥" 
                @ 16, 40 say          "≥          Final:                    ≥" 
                @ 17, 40 say          "≥   TIPO Cliente:                    ≥" 
                @ 18, 40 say          "≥         Regiao:                    ≥" 
                @ 19, 40 say          "≥       Vendedor:                    ≥" 
                @ 20, 40 say          "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ" 
  SetColor(_COREDICAO_)

                @ 15, 58 get     M_CGC1 picture "@R 999.999.999/9999-99"  
                @ 16, 58 get     M_CGC2 picture "@R 999.999.999/9999-99"   
                @ 17, 58 get     M_TIPO picture "@!"
                @ 18, 58 get     M_REGI picture "##"
                @ 19, 58 get     M_VEND picture "###"
                read
                if lastkey() = 27
                  return ""
                endif
                M_CGC1 = iif(empty(M_CGC1),space(14)+"1"    ,M_CGC1)
                M_CGC2 = iif(empty(M_CGC2),"999999999999999",M_CGC2) 
                if M_OPC = 2
                  lisclia("CLIENTES EM ORDEM DE CGC/CPF")
                else
                  lisclib("CLIENTES EM ORDEM DE CGC/CPF")
                endif
           case M_OPC = 3 .or. M_OPC = 6
              sombra(14, 40, 20, 77,_SOMBRA_)
              set color to GR+/W
                @ 14, 40 say          "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø" 
                @ 15, 40 say          "≥NOME Inicial:                       ≥" 
                @ 16, 40 say          "≥       Final:                       ≥" 
                @ 17, 40 say          "≥TIPO Cliente:                       ≥" 
                @ 18, 40 say          "≥      Regiao:                       ≥" 
                @ 19, 40 say          "≥    Vendedor:                       ≥" 
                @ 20, 40 say          "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ" 
  SetColor(_COREDICAO_)

                @ 15, 55 get     M_NOM1 picture "@!@S22"
                @ 16, 55 get     M_NOM2 picture "@!@S22"
                @ 17, 55 get     M_TIPO picture "@!"
                @ 18, 55 get     M_REGI picture "##"
                @ 19, 55 get     M_VEND picture "###"
                read
                if lastkey() = 27
                  return ""
                endif
                M_NOM1 = iif(empty(M_NOM1),                     "A",M_NOM1)
                M_NOM2 = iif(empty(M_NOM2),"ZZZZZZZZZZZZZZZZZZZZZZ",M_NOM2) 
                if M_OPC = 3
                  lisclia("CLIENTES EM ORDEM ALFABETICA")
                else
                  lisclib("CLIENTES EM ORDEM ALFABETICA")
                endif
           case M_OPC = 7
              sombra(14, 40, 20, 77,_SOMBRA_)
              set color to GR+/W
                @ 14, 40 say          "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø" 
                @ 15, 40 say          "≥CIDADE Inicial:                     ≥" 
                @ 16, 40 say          "≥         Final:                     ≥" 
                @ 17, 40 say          "≥  TIPO Cliente:                     ≥" 
                @ 18, 40 say          "≥        Regiao:                     ≥" 
                @ 19, 40 say          "≥      Vendedor:                     ≥" 
                @ 20, 40 say          "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ" 
  SetColor(_COREDICAO_)

                @ 15, 57 get     M_MUN1 picture "@!"
                @ 16, 57 get     M_MUN2 picture "@!"
                @ 17, 57 get     M_TIPO picture "@!"
                @ 18, 57 get     M_REGI picture "##"
                @ 19, 57 get     M_VEND picture "###"
                read
                if lastkey() = 27
                  return ""
                endif
                M_MUN1 = iif(empty(M_MUN1),                     "A",M_MUN1)
                M_MUN2 = iif(empty(M_MUN2),"ZZZZZZZZZZZZZZZZZZZZZZ",M_MUN2) 
                lisclib("CLIENTES EM ORDEM DE MUNICIPIO")
        endcase

return ""

****************
function LISCLIa
****************

parameters M_RELATO

private M_ESC,;
        LN,;
        PG

        select ACLI00

        do case 
           case M_OPC = 1
               (dbsetorder(1), dbseek(str(M_CLI1, 7), .t.))
           case M_OPC = 2
               (dbsetorder(3), dbseek(M_CGC1, .t.))
           case M_OPC = 3
               (dbsetorder(2), dbseek(M_NOM1, .t.))
        endcase

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

      store 0 to PG

      do while !eof()

        PG++

        if PG > 1
            eject
        endif

          ? cent_cab(AEMP00->EMPFAN,M_RELATO,"EAGRO24",132) 
          ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
          ? "*-----*----------------------------------------*--------------------*---------------*-------------*---------------*----------------*"
          ? "*     * NOME                                   * CGC (MF)           *INSCR ESTADUAL *  BAIRRO     *               *                *"
          ? "* COD * ENDERECO FATURA                        *                    *--*------------*  CONTATO    *   TELEFONE    *   FAX-SIMILE   *"
          ? "*     * ENDERECO COBRANCA                      * MUNICIPIO          *UF* CEP        *             *               *                *"
          ? "*-----*----------------------------------------*--------------------*--*------------*-------------*---------------*----------------*"
*             99999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999.999/999-99   XXXXXXXXXXXXXXX                                                               
*                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XX 99999 999    XXXXXXXXXXXXX (9999) 999-9999 (9999) 999-9999   
*                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XX 99999 999    XXXXXXXXXXXXX (9999) 999-9999 (9999) 999-9999                           


        store 7 to LN

        do while !eof() .and. LN < 60

          if !empty(M_TIPO)
            if !M_TIPO == CLITIP
              skip
              loop
            endif
          endif

          if M_REGI > 0
            if CLIREG != M_REGI
              skip
              loop
            endif
          endif 

          if M_VEND > 0
            if CLIVEN != M_VEND
              skip
              loop
            endif
          endif 

          if M_OPC = 1 
            if  CLICOD > M_CLI2
              go bottom
              skip
              loop
             endif 
           endif

          if M_OPC = 2 
            if  CLICGC1 > M_CGC2
              go bottom
              skip
              loop
             endif 
           endif

          if M_OPC = 3 
            if  left(CLINOM, len(alltrim(M_NOM2))) > alltrim(M_NOM2)
              go bottom
              skip
              loop
             endif 
           endif

            ? " "
              ?? str(CLICOD, 7, 0)
              ?? " "
              ?? pad(CLINOM, 40) 
              ?? " "
              if len(alltrim(CLICGC2)) = 11
                ?? transform(CLICGC2,"@R 999.999.999/99")
                ?? space(05)
              else
                if len(alltrim(CLICGC2)) = 15
                  ?? transform(CLICGC2,"@R 999.999.999/9999-99")
                else
                  ?? space(19)
                endif
              endif 
              ?? "  "
              ?? CLIIES2
              ?? " "
              ?? CLIBAI1

             ? space(07)  
              ?? CLIEND2
              ?? " "
              ?? CLIMUN2
              ?? " "
              ?? CLIUF2
              ?? " "
              ?? str(CLICEP2, 5, 0)
              ?? " "
              ?? strzero(CLICCL2, 3, 0)
              ?? "    "
              ?? left(CLIAC, 13)
              ?? " "
              ?? CLITEL1
              ?? " "
              ?? CLIFAX1

             ? space(07)  
              ?? CLIEND3
              ?? " "
              ?? CLIMUN3
              ?? " "
              ?? CLIUF3
              ?? " "
              ?? str(CLICEP3, 5, 0)
              ?? " "
              ?? strzero(CLICCL3, 3, 0)
              ?? "    "
              ?? left(CLICON, 13)
              ?? " "
              ?? CLITEL3
              ?? " "
              ?? CLIFAX3
                
             ? replicate("-", 132)


            store LN + 4 to LN

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

return "" 

****************
function LISCLIB
****************

parameters M_RELATO

private M_ESC  ,;
        LN     ,;
        PG

        select ACLI00

        do case 
           case M_OPC = 4
             set order to 1
             set softseek on
               seek str(M_CLI1, 7, 0)
             set softseek off
           case M_OPC = 5
             set order to 3
             set softseek on
               seek M_CGC1
             set softseek off
           case M_OPC = 6
             set order to 2
             set softseek on
               seek M_NOM1
             set softseek off
           case M_OPC = 7
             set order to 4
             set softseek on
               seek M_MUN1
             set softseek off
        endcase

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

          ? cent_cab(AEMP00->EMPFAN,M_RELATO,"EAGRO24",132) 
          ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
          ? "*-------*------------------------------------*-----------------------------------*--------------*---------*--*--------------*---*--*"
          ? "*  COD  * NOME                               * ENDERECO ENTREGA                  * CIDADE       * CEP     *UF* TELEFONE     *VEN*RG*"
          ? "*-------*------------------------------------*-----------------------------------*--------------*---------*--*--------------*---*--*"
*             9999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXX XXXXX XXX XX XXXXXXXXXXXXXX 999 99

        store 5 to LN

        do while !eof() .and. LN < 60


          if !empty(M_TIPO)
            if !M_TIPO == CLITIP
              skip
              loop
            endif
          endif

          if M_VEND > 0
            if CLIVEN != M_VEND
              skip
              loop
            endif
          endif 

          if M_REGI > 0
            if CLIREG != M_REGI
              skip
              loop
            endif
          endif 

          if M_OPC = 4
            if  CLICOD > M_CLI2
              go bottom
              skip
              loop
             endif 
           endif

          if M_OPC = 5
            if  CLICGC1 > M_CGC2
              go bottom
              skip
              loop
             endif 
           endif

          if M_OPC = 6
            if left(CLINOM, len(alltrim(M_NOM2))) > alltrim(M_NOM2)
              go bottom
              skip
              loop
             endif 
           endif

          if M_OPC = 7
            if left(CLIMUN1, len(alltrim(M_MUN2))) > alltrim(M_MUN2)
              go bottom
              skip
              loop
             endif 
           endif

            ? " "
              ?? str(CLICOD, 7)
              ?? " "
              ?? pad(CLINOM, 36)
              ?? " "
              ?? left(CLIEND2, 35)
              ?? " "
              ?? left(CLIMUN2, 14)
              ?? " "
              ?? str(CLICEP2, 5, 0)
              ?? " "
              ?? strzero(CLICCL2, 3, 0)
              ?? " "
              ?? CLIUF2
              ?? " "
              ?? pad(CLITEL1, 14)
              ?? " "
              ?? str(CLIVEN, 3, 0)
              ?? " "
              ?? str(CLIREG, 2, 0)

            store LN + 1 to LN

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

return "" 

***************
function ETICLI
*************** 
parameters M_OPC,M_OPC1,M_OPC2

private M_CLI1   ,;
        M_CLI2   ,;
        M_NOM1   ,;
        M_NOM2   ,;
        M_TIPO   ,;
        M_ETI[24]

        M_CLI1 = 0
        M_CLI2 = 0
        M_NOM1 = space(40)
        M_NOM2 = space(40)
        M_TIPO = space(01)

        rodape("ETIQUETA","CLIENTE",M_FAN,"EAGRO24","Mem: " + str(memory(0), 5),M_EMP) 

*           @ 11, 25 prompt   "Codigo   " HIGHLITE R/BG
*           @ 12, 25 prompt   "Selecao  " HIGHLITE R/BG
*           @ 13, 25 prompt   "Nome     " HIGHLITE R/BG
*           @ 14, 25 prompt   "Parametro" HIGHLITE R/BG

        do case
           case M_OPC = 1
              sombra(13, 33, 17, 58,_SOMBRA_)
              set color to GR+/W+
                @ 13, 33 say   "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø" 
                @ 14, 33 say   "≥ CODIGO Inicial:        ≥" 
                @ 15, 33 say   "≥          Final:        ≥" 
                @ 16, 33 say   "≥   TIPO Cliente:        ≥" 
                @ 17, 33 say   "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ" 
  SetColor(_COREDICAO_)

                @ 14, 51 get     M_CLI1 picture "#######"  
                @ 15, 51 get     M_CLI2 picture "#######"   
                @ 16, 51 get     M_TIPO picture "@!"
                read 
                if lastkey() = 27
                  return ""
                endif
                M_CLI1 = iif(M_CLI1 = 0,       1,M_CLI1)
                M_CLI2 = iif(M_CLI2 = 0,9999999,M_CLI2) 
                eticli_a()
           case M_OPC = 2
              for R = 1 to 24
                M_ETI[R] = 0 
              next
              sombra(13, 15, 18, 63,_SOMBRA_)
              set color to N/RB+
                @ 13, 15 say   "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø" 
                @ 14, 15 say   "≥                                               ≥" 
                @ 15, 15 say   "≥                                               ≥" 
                @ 16, 15 say   "≥                                               ≥" 
                @ 17, 15 say   "≥                                               ≥" 
                @ 18, 15 say   "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"  
  SetColor(_COREDICAO_)

              @ 14, 16 get M_ETI[ 1] picture "#######" valid vercli03(M_ETI[ 1])
              @ 14, 24 get M_ETI[ 2] picture "#######" valid vercli03(M_ETI[ 2])
              @ 14, 32 get M_ETI[ 3] picture "#######" valid vercli03(M_ETI[ 3])
              @ 14, 40 get M_ETI[ 4] picture "#######" valid vercli03(M_ETI[ 4])
              @ 14, 48 get M_ETI[ 5] picture "#######" valid vercli03(M_ETI[ 5])
              @ 14, 56 get M_ETI[ 6] picture "#######" valid vercli03(M_ETI[ 6])

              @ 15, 16 get M_ETI[ 7] picture "#######" valid vercli03(M_ETI[ 7])
              @ 15, 24 get M_ETI[ 8] picture "#######" valid vercli03(M_ETI[ 8])
              @ 15, 32 get M_ETI[ 9] picture "#######" valid vercli03(M_ETI[ 9])
              @ 15, 40 get M_ETI[10] picture "#######" valid vercli03(M_ETI[10])
              @ 15, 48 get M_ETI[11] picture "#######" valid vercli03(M_ETI[11])
              @ 15, 56 get M_ETI[12] picture "#######" valid vercli03(M_ETI[12])

              @ 16, 16 get M_ETI[13] picture "#######" valid vercli03(M_ETI[13])
              @ 16, 24 get M_ETI[14] picture "#######" valid vercli03(M_ETI[14])
              @ 16, 32 get M_ETI[15] picture "#######" valid vercli03(M_ETI[15])
              @ 16, 40 get M_ETI[16] picture "#######" valid vercli03(M_ETI[16])
              @ 16, 48 get M_ETI[17] picture "#######" valid vercli03(M_ETI[17])
              @ 16, 56 get M_ETI[18] picture "#######" valid vercli03(M_ETI[18])

              @ 17, 16 get M_ETI[19] picture "#######" valid vercli03(M_ETI[19])
              @ 17, 24 get M_ETI[20] picture "#######" valid vercli03(M_ETI[20])
              @ 17, 32 get M_ETI[21] picture "#######" valid vercli03(M_ETI[21])
              @ 17, 40 get M_ETI[22] picture "#######" valid vercli03(M_ETI[22])
              @ 17, 48 get M_ETI[23] picture "#######" valid vercli03(M_ETI[23])
              @ 17, 56 get M_ETI[24] picture "#######" valid vercli03(M_ETI[24])
              read
              if lastkey() = 27
                return ""
              endif
              eticli_b()
           case M_OPC = 3
              sombra(13, 33, 17, 70,_SOMBRA_)
              set color to GR+/W+
                @ 13, 33 say   "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø" 
                @ 14, 33 say   "≥NOME Inicial:                       ≥" 
                @ 15, 33 say   "≥       Final:                       ≥" 
                @ 16, 33 say   "≥TIPO Cliente:                       ≥" 
                @ 17, 33 say   "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ" 
  SetColor(_COREDICAO_)

                @ 14, 48 get     M_NOM1 picture "@!@S22"
                @ 15, 48 get     M_NOM2 picture "@!@S22"
                @ 16, 51 get     M_TIPO picture "@!"
                read
                if lastkey() = 27
                  return ""
                endif
                M_NOM1 = iif(empty(M_NOM1),                     "A",M_NOM1)
                M_NOM2 = iif(empty(M_NOM2),"ZZZZZZZZZZZZZZZZZZZZZZ",M_NOM2) 
                eticli_a()
           case M_OPC = 4       
                if file("ETIQUETA.MEM")
                  restore from ETIQUETA.MEM additive
                else
                  ME_CAR  = 1
                  ME_TAM  = 40
                  ME_LIE  = 1
                  ME_COE  = 1
                  ME_CPP  = 10
                  ME_QLT  = "N"
                  ME_DAD  = 1
                endif
                sombra(12, 34, 20, 67, _SOMBRA_)        
                set color to BG+/G                                    
                  @ 12, 34 say  "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø"
                  @ 13, 34 say  "≥ Numero de Carreiras    :       ≥"
                  @ 14, 34 say  "≥ Tamanho em Caracteres  :       ≥"
                  @ 15, 34 say  "≥ Linhas Entre Etiquetas :       ≥"
                  @ 16, 34 say  "≥ Colunas Entre Etiquetas:       ≥"
                  @ 17, 34 say  "≥ Tamanho do Caracter cpp:       ≥"
                  @ 18, 34 say  "≥ Qualidade Carta        :       ≥"
                  @ 19, 34 say  "≥ Dados na Etiqueta      :       ≥"
                  @ 20, 34 say  "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
  SetColor(_COREDICAO_)


             @ 13, 61 get ME_CAR  picture "#"
             @ 14, 61 get ME_TAM  picture "##"
             @ 15, 61 get ME_LIE  picture "#"
             @ 16, 61 get ME_COE  picture "#"
             @ 17, 61 get ME_CPP  picture "##" valid(rat(str(ME_CPP, 2, 0),"10#12#18") > 0)
             @ 18, 61 get ME_QLT  picture "@!" valid(rat(ME_QLT,"S#N") > 0) 
             @ 19, 61 get ME_DAD  picture "#"  valid vercli04()
             read

             if lastkey() = 27
               return ""
             endif

             save all like ME_* to ETIQUETA
 
        endcase

return ""

*****************
function ETICLI_A
*****************

private M_ESC  

         if file("ETIQUETA.MEM")
            restore from ETIQUETA.MEM additive
         else
            ME_CAR  = 1
            ME_TAM  = 40
            ME_LIE  = 1
            ME_COE  = 2
            ME_CPP  = 10
            ME_QLT  = "N"
            ME_DAD  = 1
         endif

        select ACLI00

        do case 
           case M_OPC = 1
             (dbsetorder(1), dbseek(str(M_CLI1, 7, 0),.t.))
           case M_OPC = 3
             (dbsetorder(2), dbseek(M_NOM1,.t.))
        endcase

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if ME_CPP = 12
          ?? chr(27) + "M"
        else
          if ME_CPP = 17
            ?? chr(15)
          endif
        endif
        
        if ME_CPP = 10
          if ME_QLT = "S"
            ?? chr(27) + "G"
          endif
        endif

        declare MT_ETINOM[ME_CAR] ,;
                MT_ETIEND[ME_CAR] ,;
                MT_ETIBAI[ME_CAR] ,;
                MT_LINECT[ME_CAR] 

        for R = 1 to ME_CAR
          MT_ETINOM[R] = space(ME_TAM)
          MT_ETIEND[R] = space(ME_TAM)
          MT_ETIBAI[R] = space(ME_TAM)
          MT_LINECT[R] = space(ME_TAM)
        next
     
        do while !eof()

             for R = 1 to ME_CAR
               MT_ETINOM[R] = space(ME_TAM)
               MT_ETIEND[R] = space(ME_TAM)
               MT_ETIBAI[R] = space(ME_TAM)
               MT_LINECT[R] = space(ME_TAM)
             next

             for R = 1 to ME_CAR

               if ME_DAD = 1
                 MT_ETINOM[R] = pad(CLINOM, ME_TAM)
                 MT_ETIEND[R] = pad(CLIEND1, ME_TAM)
                 MT_ETIBAI[R] = pad(CLIBAI1, ME_TAM)
                 MT_LINECT[R] = pad((strzero(CLICEP1, 5, 0) + " " + strzero(CLICCL1, 3, 0) + " " + rtrim(CLIMUN1) + " " + CLIUF1), ME_TAM)
               else
                 if ME_DAD = 2
                   MT_ETINOM[R] = pad(CLINOM, ME_TAM)
                   MT_ETIEND[R] = pad(CLIEND2, ME_TAM)
                   MT_ETIBAI[R] = pad(CLIBAI2, ME_TAM)
                   MT_LINECT[R] = pad((strzero(CLICEP2, 5, 0) + " " + strzero(CLICCL2, 3, 0) + " " + rtrim(CLIMUN2) + " " + CLIUF2), ME_TAM)
                 else
                   MT_ETINOM[R] = pad(CLINOM, ME_TAM)
                   MT_ETIEND[R] = pad(CLIEND3, ME_TAM)
                   MT_ETIBAI[R] = pad(CLIBAI3, ME_TAM)
                   MT_LINECT[R] = pad((strzero(CLICEP3, 5, 0) + " " + strzero(CLICCL3, 3, 0) + " " + rtrim(CLIMUN3) + " " + CLIUF3), ME_TAM)
                 endif
               endif
    
               skip

               if eof()
                 exit
               endif

               if M_OPC = 1
                 if CLICOD > M_CLI2
                   go bottom
                   skip
                   exit
                 endif
               endif

               if M_OPC = 3
                 if left(CLINOM, len(alltrim(M_NOM2))) > alltrim(M_NOM2)
                   go bottom
                   skip
                   loop
                 endif 
               endif

            next && R

            cab_etq()                  && emite etiqueta

            M_ESC = inkey()

            if M_ESC = 27
               if susimp()
                 ? "------------------------------"
                 ? "* * * IMPRESSAO SUSPENSA * * *"
                 go bottom
                 skip
             else
                 M_ESC = inkey()
             endif
           endif

        enddo

    ?? chr(27) + "@"

desliga1()

return "" 

****************
function CAB_ETQ
****************

  for R = 1 to ME_CAR
    ?? MT_ETINOM[R]
    ?? space(ME_COE)
  next && R

?
  for R = 1 to ME_CAR
     ?? MT_ETIEND[R]
     ?? space(ME_COE)
  next && R

?
  for R = 1 to ME_CAR
     ?? MT_ETIBAI[R]
     ?? space(ME_COE)
  next && R

?
  for R = 1 to ME_CAR
     ?? MT_LINECT[R]
     ?? space(ME_COE)
  next && R

for R = 1 to ME_LIE
  ?
next && R

return ""

*****************
function ETICLI_B
*****************

private M_ESC  

         if file("ETIQUETA.MEM")
            restore from ETIQUETA.MEM additive
         else
            ME_CAR  = 1
            ME_TAM  = 40
            ME_LIE  = 1
            ME_COE  = 2
            ME_CPP  = 10
            ME_QLT  = "N"
            ME_DAD  = 1
         endif

        select ACLI00

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if ME_CPP = 12
          ?? chr(27) + "M"
        else
          if ME_CPP = 17
            ?? chr(15)
          endif
        endif
        
        if ME_CPP = 10
          if ME_QLT = "S"
            ?? chr(27) + "G"
          endif
        endif

        declare MT_ETINOM[ME_CAR] ,;
                MT_ETIEND[ME_CAR] ,;
                MT_ETIBAI[ME_CAR] ,;
                MT_LINECT[ME_CAR] 

        for R = 1 to ME_CAR
          MT_ETINOM[R] = space(ME_TAM)
          MT_ETIEND[R] = space(ME_TAM)
          MT_ETIBAI[R] = space(ME_TAM)
          MT_LINECT[R] = space(ME_TAM)
        next

        S = 1
     
        do while .t.

             for R = 1 to ME_CAR
               MT_ETINOM[R] = space(ME_TAM)
               MT_ETIEND[R] = space(ME_TAM)
               MT_ETIBAI[R] = space(ME_TAM)
               MT_LINECT[R] = space(ME_TAM)
             next

             for R = 1 to ME_CAR
               
               if M_ETI[S] = 0
                 R = R - 1
                 S = S + 1
                 if S > 24 
                   exit
                 endif
                 loop
               endif 
               
               seek str(M_ETI[S], 7, 0)

               if ME_DAD = 1
                 MT_ETINOM[R] = pad(CLINOM, ME_TAM)
                 MT_ETIEND[R] = pad(CLIEND1, ME_TAM)
                 MT_ETIBAI[R] = pad(CLIBAI1, ME_TAM)
                 MT_LINECT[R] = pad((strzero(CLICEP1, 5, 0) + " " + strzero(CLICCL1, 3, 0) + " " + rtrim(CLIMUN1) + " " + CLIUF1), ME_TAM)
               else
                 if ME_DAD = 2
                   MT_ETINOM[R] = pad(CLINOM, ME_TAM)
                   MT_ETIEND[R] = pad(CLIEND2, ME_TAM)
                   MT_ETIBAI[R] = pad(CLIBAI2, ME_TAM)
                   MT_LINECT[R] = pad((strzero(CLICEP2, 5, 0) + " " + strzero(CLICCL2, 3, 0) + " " + rtrim(CLIMUN2) + " " + CLIUF2), ME_TAM)
                 else
                   MT_ETINOM[R] = pad(CLINOM, ME_TAM)
                   MT_ETIEND[R] = pad(CLIEND3, ME_TAM)
                   MT_ETIBAI[R] = pad(CLIBAI3, ME_TAM)
                   MT_LINECT[R] = pad((strzero(CLICEP3, 5, 0) + " " + strzero(CLICCL3, 3, 0) + " " + rtrim(CLIMUN3) + " " + CLIUF3), ME_TAM)
                 endif
               endif

               S = S + 1

               if S > 24 
                 exit
               endif

            next && R

            cab_etq()                  && emite etiqueta

            if S > 24 
              exit
            endif

            M_ESC = inkey()

            if M_ESC = 27
               if susimp()
                 ? "------------------------------"
                 ? "* * * IMPRESSAO SUSPENSA * * *"
                 go bottom
                 skip
             else
                 M_ESC = inkey()
             endif
           endif

        enddo

    ?? chr(27) + "@"

desliga1()

return "" 


****************
function TLCLI01
****************

nbox(nLincli, 04, 21+nLincli, 93,"W/W+",.t.)
setcolor("B/W")

    @ 01+nLincli, 04 say     "   C¢digo:         Cpf/Cnpj:                     Ies:                    Dte:            "
    @ 02+nLincli, 04 say     "     Nome:                                                                               "
    @ 03+nLincli, 04 say     "           Dados Cliente                                                                 "
    @ 04+nLincli, 04 say     "      Cep:           Cod.IBGE:            Mun:                                    UF:    "
    @ 05+nLincli, 04 say     " Endereáo:                                                Numero:       Comp:            "
    @ 06+nLincli, 04 say     "   Bairro:                      Fones:                                                   "
    @ 07+nLincli, 04 say     "           Dados de Faturamento                                                          "
    @ 08+nLincli, 04 say     "      Cep:           Cod.IBGE:            Mun:                                    UF:    "
    @ 09+nLincli, 04 say     " Endereáo:                                                Numero:       Comp:            "
    @ 10+nLincli, 04 say     "   Bairro:                                                                               "
    @ 11+nLincli, 04 say     "           Dados de Cobranáa                                                             "
    @ 12+nLincli, 04 say     "      Cep:           Cod.IBGE:            Mun:                                    UF:    "
    @ 13+nLincli, 04 say     " Endereáo:                                                Numero:       Comp:            "
    @ 14+nLincli, 04 say     "   Bairro:                      Fones:                                                   "
    @ 15+nLincli, 04 say     "           Classificacao do Cliente                                                      "
    @ 16+nLincli, 04 say     "  Contato:                 Regiao:     Vendedor:        Transporte:     Ultima:          "
    @ 17+nLincli, 04 say     "  Credito:                 Bco:            Tipo:     Classificacao:        Dcc:          "
    @ 18+nLincli, 04 say     "           Informacoes para Internet                                                     "
    @ 19+nLincli, 04 say     "     site:                                                                               "
    @ 20+nLincli, 04 say     "   e-mail:                                                                               "
    @ 21+nLincli, 04 say     "                                                                                         "
  set color to R/W
*   @ 03+nLincli, 04 say     " Dados Cliente ƒƒƒ "
*   @ 08+nLincli, 04 say     " Dados de Faturamento "
*   @ 11+nLincli, 04 say     " Dados de Cobranáa "
*   @ 15+nLincli, 04 say     " Classificacao do Cliente "
*   @ 18+nLincli, 04 say     " Informacoes para Internet "
  set color to B/W
*    @ 08+nLincli, 26 say     "ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  "
*    @ 11+nLincli, 23 say     "ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  "
*    @ 15+nLincli, 30 say     "ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  "
*    @ 18+nLincli, 31 say     "ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  "
  set color to 

return ""

****************
function TLCLI02
****************
   
 sombra(03, 04, 20, 76,_SOMBRA_)

  setcolor("B/W")
    @ 03, 04 say     "                                                                         "
    @ 04, 04 say     " C¢digo  :           Cpf/Cgc:                      Ies:                  "
    @ 05, 04 say     " ƒƒDados do Clienteƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ "
    @ 06, 04 say     " N o m e :                                                 Dte:          "
    @ 07, 04 say     " Endereáo:                                                 Est:          "
    @ 08, 04 say     " Bairro  :                 Cep:      -          Mun:                     "
    @ 09, 04 say     " Telefone:                 Fax:                            Pro:          "
    @ 10, 04 say     " ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ "
    @ 11, 04 say     " " + space(71) + " "
    @ 12, 04 say     " " + space(71) + " "
    @ 13, 04 say     " " + space(71) + " "
    @ 14, 04 say     " " + space(71) + " "
    @ 15, 04 say     " " + space(71) + " "
    @ 16, 04 say     " " + space(71) + " "
    @ 17, 04 say     " " + space(71) + " "
    @ 18, 04 say     " " + space(71) + " "
    @ 19, 04 say     " " + space(71) + " "
    @ 20, 04 say     "                                                                         "
  set color to 

return ""

******************
function VERCLICGC(TIPO)
******************

if empty(M_CLICGC1)
  return .t.
endif     

if len(alltrim(M_CLICGC1))=15         
  if !cgc(right(M_CLICGC1,14))
    msg("* * * CGC INVALIDO * * *")
    return .f.
  endif 
else
  if len(alltrim(M_CLICGC1))=11
    if !cpf(left(M_CLICGC1,11))
      msg("* * * CPF INVALIDO * * *")
      return .f.
    endif 
  else
    msg("* * * NAO E' CGC/CPF * * *")
    return .f.
  endif
endif

if TIPO
  if !vercli01()
    return .f.
  endif
endif

return .t.

****************
function EDCLI01(fTIPO)
****************


SETCOLOR(_COREDICAO_)
    @ 01+nLincli, 33 get    M_CLICGC1   picture "@R 999.999.999/9999-99"  valid verclicgc(fTIPO)
    @ 01+nLincli, 58 get    M_CLIIES1   picture "@!"                      valid vercli09()
    @ 01+nLincli, 82 get    M_CLIDTE
    @ 02+nLincli, 15 get    M_CLINOM    picture "@!@S40"  valid !empty(M_CLINOM)

*   @ 02+nLincli, 65 get    M_REVENDA   picture "@!" valid M_REVENDA $ "SN"
*    @ 02+nLincli, 77 get    M_INDICADO  picture "@!@S15"

    @ 04+nLincli, 15 get    M_CLICEP1   picture "#####"
    @ 04+nLincli, 21 get    M_CLICCL1   picture "###"     valid edm_cli("1")
    @ 04+nLincli, 35 get    M_CLICDM1   picture "9999999"
    @ 04+nLincli, 51 get    M_CLIMUN1   picture "@!@S34"
    @ 04+nLincli, 90 get    M_CLIUF1    picture "@!"
    @ 05+nLincli, 15 get    M_CLIEND1   picture "@!" // valid diginro("CLI1")
    @ 05+nLincli, 70 get    M_CLINRO1   picture "@!"  valid !empty(M_CLINRO1)
    @ 05+nLincli, 82 get    M_CLICPE1
    @ 06+nLincli, 15 get    M_CLIBAI1   picture "@!"
    @ 06+nLincli, 43 get    M_CLITEL1   picture "@!"
    @ 06+nLincli, 60 get    M_CLIFAX1   picture "@!"
    @ 06+nLincli, 77 get    M_CLITEX1   picture "@!"                      valid troca()


    @ 08+nLincli, 15 get    M_CLICEP2   picture "#####"
    @ 08+nLincli, 21 get    M_CLICCL2   picture "###" valid edm_cli("2")
    @ 08+nLincli, 35 get    M_CLICDM2   picture "9999999"
    @ 08+nLincli, 51 get    M_CLIMUN2   picture "@!@S34"
    @ 08+nLincli, 90 get    M_CLIUF2    picture "@!"
    @ 09+nLincli, 15 get    M_CLIEND2   picture "@!" // valid diginro("CLI1")
    @ 09+nLincli, 70 get    M_CLINRO2   picture "@!"  valid !empty(M_CLINRO2)
    @ 09+nLincli, 82 get    M_CLICPE2
    @ 10+nLincli, 15 get    M_CLIBAI2   picture "@!"


    @ 12+nLincli, 15 get    M_CLICEP3   picture "#####"
    @ 12+nLincli, 21 get    M_CLICCL3   picture "###"     valid edm_cli("3")
    @ 12+nLincli, 35 get    M_CLICDM3   picture "9999999"
    @ 12+nLincli, 51 get    M_CLIMUN3   picture "@!@S34"
    @ 12+nLincli, 90 get    M_CLIUF3    picture "@!"
    @ 13+nLincli, 15 get    M_CLIEND3   picture "@!" // valid diginro("CLI1")
    @ 13+nLincli, 70 get    M_CLINRO3   picture "@!"  valid !empty(M_CLINRO3)
    @ 13+nLincli, 82 get    M_CLICPE3
    @ 14+nLincli, 15 get    M_CLIBAI3   picture "@!"
    @ 14+nLincli, 43 get    M_CLITEL3   picture "@!"
    @ 14+nLincli, 60 get    M_CLIFAX3   picture "@!"
    @ 14+nLincli, 77 get    M_CLITEX3   picture "@!"


    @ 16+nLincli, 15 get    M_CLICON    picture "@!"
    @ 16+nLincli, 39 get    M_CLIREG    picture "##"
    @ 16+nLincli, 53 get    M_CLIVEN    picture "###"                     valid vercli05()
    @ 16+nLincli, 72 get    M_CLITRA    picture "###"                     valid vercli06()
    @ 16+nLincli, 84 get    M_CLIULC

    @ 17+nLincli, 15 get    M_CLIAC     picture "@!"
    @ 17+nLincli, 36 get    M_CLIBCO    picture "#####"
*   @ 17+nLincli, 53 get    M_CLITIP    picture "@!"                      valid vercli02(.f.)
    @ 17+nLincli, 72 get    M_CLICLF    picture "@!"
    @ 17+nLincli, 84 get    M_CLIDCC    picture "#"                        valid vercli08()
    @ 19+nLincli, 15 get    M_CLISITE
    @ 20+nLincli, 15 get    M_CLIEMAIL
    read

return ""

****************
function MSCLI01
****************

  setcolor("N/W*")
*  @ 01+nLincli, 15 say    REVENDA    picture "@!"
   @ 02+nLincli, 15 say    CLICOD     picture "#######"
   @ 02+nLincli, 33 say    CLICGC1    picture "@R 999.999.999/9999-99"
   @ 03+nLincli, 33 say    pad(NOMEPAI,20)   picture "@!"
   @ 02+nLincli, 58 say    CLIIES1    picture "@!"

   @ 04+nLincli, 15 say    CLINOM     picture "@!@S40"
   @ 04+nLincli, 68 say    CLIDTE

   @ 05+nLincli, 15 say    CLIEND1    picture "@!"
   @ 05+nLincli, 68 say    CLIUF1     picture "@!"

   @ 06+nLincli, 15 say    CLIBAI1    picture "@!"
   @ 06+nLincli, 36 say    CLICEP1    picture "#####"
   @ 06+nLincli, 42 say    CLICCL1    picture "###"
   @ 06+nLincli, 57 say    CLIMUN1    picture "@!@S19"

   @ 07+nLincli, 15 say    CLITEL1    picture "@!"
   @ 07+nLincli, 36 say    CLIFAX1    picture "@!"
   @ 07+nLincli, 57 say    CLITEX1    picture "@!"

   @ 09+nLincli, 15 say    CLIEND2    picture "@!"
   @ 09+nLincli, 68 say    CLIUF2     picture "@!"

   @ 10+nLincli, 15 say    CLIBAI2    picture "@!"
   @ 10+nLincli, 36 say    CLICEP2    picture "#####"
   @ 10+nLincli, 42 say    CLICCL2    picture "###"
   @ 10+nLincli, 57 say    CLIMUN2    picture "@!@S19"

   @ 12+nLincli, 15 say     CLIEND3    picture "@!"
   @ 12+nLincli, 68 say     CLIUF3     picture "@!"

   @ 13+nLincli, 15 say     CLIBAI3    picture "@!"
   @ 13+nLincli, 36 say     CLICEP3    picture "#####"
   @ 13+nLincli, 42 say     CLICCL3    picture "###"
   @ 13+nLincli, 57 say     CLIMUN3    picture "@!@S19"

   @ 14+nLincli, 15 say     CLITEL3    picture "@!"
   @ 14+nLincli, 36 say     CLIFAX3    picture "@!"
   @ 14+nLincli, 57 say     CLITEX3    picture "@!"

   @ 16+nLincli, 15 say     CLICON     picture "@!"
   @ 16+nLincli, 36 say     CLIREG     picture "##"
   @ 16+nLincli, 48 say     CLIVEN     picture "###"
   @ 16+nLincli, 57 say     CLITRA     picture "###"
   @ 16+nLincli, 68 say     CLIULC

   @ 17+nLincli, 15 say     CLIAC      picture "@!"
   @ 17+nLincli, 36 say     CLIBCO     picture "#####"
   @ 17+nLincli, 48 say     CLITIP     picture "@!"
   @ 17+nLincli, 57 say     CLICLF     picture "@!"
   @ 17+nLincli, 68 say     CLIDCC     picture "#"
   @ 19+nLincli, 15 say     CLISITE
   @ 20+nLincli, 15 say     CLIEMAIL
   @ 22+nLincli, 01 say     space(66)  color("GR+/N")
  set color to GR+
   @ 22+nLincli, 01 say " Res: " + alltrim(CLINRO1) + " " + alltrim(CLICPE1) + ;
              "|Fat: " + alltrim(CLINRO2) + " " + alltrim(CLICPE2) + ;
              "|Cob: " + alltrim(CLINRO3) + " " + alltrim(CLICPE3)
 set color to
  
return ""

****************
function MSCLI02
****************

  set color to I
*  @ 01, 15 say    REVENDA    picture "@!"
   @ 04, 15 say    CLICOD     picture "#######"
   @ 04, 33 say    CLICGC1    picture "@R 999.999.999/9999-99"
   @ 04, 58 say    CLIIES1    picture "@!"

   @ 06, 15 say    CLINOM     picture "@!@S40"
   @ 06, 68 say    CLIDTE                                            

   @ 07, 15 say    CLIEND1    picture "@!"                           
   @ 07, 68 say    CLIUF1     picture "@!"

   @ 08, 15 say    CLIBAI1    picture "@!"                           
   @ 08, 36 say    CLICEP1    picture "#####"                        
   @ 08, 42 say    CLICCL1    picture "###"                          
   @ 08, 57 say    CLIMUN1    picture "@!@S19"                           

   @ 09, 15 say    CLITEL1    picture "@!"                           
   @ 09, 36 say    CLIFAX1    picture "@!"                           
   @ 09, 57 say    CLITEX1    picture "@!"


  set color to
  
return ""

**************
function TROCA
**************

M_CLICGC2   =  M_CLICGC1
M_CLIEND2   =  M_CLIEND1
M_CLIEND3   =  M_CLIEND1
M_CLINRO2   =  M_CLINRO1
M_CLINRO3   =  M_CLINRO1
M_CLICPE2   =  M_CLICPE1
M_CLICPE3   =  M_CLICPE1
M_CLIUF2    =  M_CLIUF1
M_CLIUF3    =  M_CLIUF1
M_CLIBAI2   =  M_CLIBAI1
M_CLIBAI3   =  M_CLIBAI1
M_CLICEP2   =  M_CLICEP1
M_CLICEP3   =  M_CLICEP1
M_CLICCL2   =  M_CLICCL1
M_CLICCL3   =  M_CLICCL1
M_CLICDM2   =  M_CLICDM1
M_CLICDM3   =  M_CLICDM1
M_CLIMUN2   =  M_CLIMUN1
M_CLIMUN3   =  M_CLIMUN1
M_CLIIES2   =  M_CLIIES1
M_CLITEL3   =  M_CLITEL1
M_CLIFAX3   =  M_CLIFAX1

return .t.    

****************
function GRCLI01(cACAO)                       && grava dados do cliente
****************

sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {"ACLI00",cACAO}

aadd(sqlCHAVE,{"CLICOD",str(M_CLICOD,7)})

if !cACAO $ "#DELETE#SELECT#"
  aadd(sqlCAMPO,{"CLICOD",str(M_CLICOD),.t.})
  aadd(sqlCAMPO,{"CLICGC1",M_CLICGC1,.t.})
  aadd(sqlCAMPO,{"CLITIP",M_CLITIP,.t.})
  aadd(sqlCAMPO,{"CLINOM",M_CLINOM,.t.})

  aadd(sqlCAMPO,{"CLIDTE",formatdta(M_CLIDTE),.t.})
  aadd(sqlCAMPO,{"CLIEND1",M_CLIEND1,.t.})
  aadd(sqlCAMPO,{"CLIUF1",M_CLIUF1,.t.})
  aadd(sqlCAMPO,{"CLIBAI1",M_CLIBAI1,.t.})
  aadd(sqlCAMPO,{"CLICEP1",str(M_CLICEP1),.t.})
  aadd(sqlCAMPO,{"CLICCL1",str(M_CLICCL1),.t.})
  aadd(sqlCAMPO,{"CLICCL2",str(M_CLICCL2),.t.})
  aadd(sqlCAMPO,{"CLICCL3",str(M_CLICCL3),.t.})
  aadd(sqlCAMPO,{"CLIMUN1",M_CLIMUN1,.t.})
  aadd(sqlCAMPO,{"CLITEL1",M_CLITEL1,.t.})
  aadd(sqlCAMPO,{"CLIFAX1",M_CLIFAX1,.t.})
  aadd(sqlCAMPO,{"CLITEX1",M_CLITEX1,.t.})
  aadd(sqlCAMPO,{"CLIIES1",M_CLIIES1,.t.})
  aadd(sqlCAMPO,{"CLIREG",str(M_CLIREG),.t.})
  aadd(sqlCAMPO,{"CLIDCC",str(M_CLIDCC),.t.})
  aadd(sqlCAMPO,{"CLIVEN",str(M_CLIVEN),.t.})
  aadd(sqlCAMPO,{"CLICLF",M_CLICLF,.t.})
  aadd(sqlCAMPO,{"CLIEND2",M_CLIEND2,.t.})
  aadd(sqlCAMPO,{"CLITRA",str(M_CLITRA),.t.})
  aadd(sqlCAMPO,{"CLIUF2",M_CLIUF2,.t.})
  aadd(sqlCAMPO,{"CLIBAI2",M_CLIBAI2,.t.})
  aadd(sqlCAMPO,{"CLICEP2",str(M_CLICEP2),.t.})
  aadd(sqlCAMPO,{"CLIMUN2",M_CLIMUN2,.t.})
  aadd(sqlCAMPO,{"CLIIES2",M_CLIIES2,.t.})
  aadd(sqlCAMPO,{"CLICGC2",M_CLICGC2,.t.})
  aadd(sqlCAMPO,{"CLIAC",M_CLIAC,.t.})
  aadd(sqlCAMPO,{"CLIEND3",M_CLIEND3,.t.})
  aadd(sqlCAMPO,{"CLIUF3",M_CLIUF3,.t.})
  aadd(sqlCAMPO,{"CLIBAI3",M_CLIBAI3,.t.})
  aadd(sqlCAMPO,{"CLICEP3",str(M_CLICEP3),.t.})
  aadd(sqlCAMPO,{"CLIMUN3",M_CLIMUN3,.t.})
  aadd(sqlCAMPO,{"CLITEL3",M_CLITEL3,.t.})
  aadd(sqlCAMPO,{"CLIFAX3",M_CLIFAX3,.t.})
  aadd(sqlCAMPO,{"CLITEX3",M_CLITEX3,.t.})
  aadd(sqlCAMPO,{"CLICON",M_CLICON,.t.})
  aadd(sqlCAMPO,{"CLIBCO",str(M_CLIBCO),.t.})
  aadd(sqlCAMPO,{"CLIULC",formatdta(M_CLIULC),.t.})
  aadd(sqlCAMPO,{"CLISITE",M_CLISITE,.t.})
  aadd(sqlCAMPO,{"CLIEMAIL",M_CLIEMAIL,.t.})
  aadd(sqlCAMPO,{"NOMEPAI",M_INDICADO,.t.})
  aadd(sqlCAMPO,{"REVENDA",M_REVENDA,.t.})
  aadd(sqlCAMPO,{"CLINRO1",M_CLINRO1,.t.})
  aadd(sqlCAMPO,{"CLICPE1",M_CLICPE1,.t.})
  aadd(sqlCAMPO,{"CLICDM1",str(M_CLICDM1),.t.})

  aadd(sqlCAMPO,{"CLINRO2",M_CLINRO2,.t.})
  aadd(sqlCAMPO,{"CLICPE2",M_CLICPE2,.t.})
  aadd(sqlCAMPO,{"CLICDM2",str(M_CLICDM2),.t.})

  aadd(sqlCAMPO,{"CLINRO3",M_CLINRO3,.t.})
  aadd(sqlCAMPO,{"CLICPE3",M_CLICPE3,.t.})
  aadd(sqlCAMPO,{"CLICDM3",str(M_CLICDM3),.t.})
endif

executasql()

return ""

*****************
function VERCLI01
*****************

sqlRELATION = {}
sqlCAMPO = {}
sqlCHAVE =  {}
sqlARQUI = {}
sqlORDEM = {}
aadd(sqlARQUI,{"ACLI00","ACLI00"})
aadd(sqlCAMPO,"CLICOD")
aadd(sqlCHAVE,"CLICGC1 = " + aspas(alltrim(M_CLICGC1)))
aadd(sqlCHAVE,"CLICOD <> " + str(M_CLICOD))
if sqlrelation()
  do while .t.
    M_ESCOLHA = msgbox3({"Cliente ja cadastrado - Codigo: " + alltrim(str(CLICOD,7)),"Novo cadastro?"},,,"Escolha","Sim","Nao")
    if M_ESCOLHA = 2
      return .t.
    endif
    if M_ESCOLHA = 3
      return .F.
    endif
  enddo
endif

return .t.

*****************
function VERCLI02(TIPO)
*****************
LOCAL aBlocks := {}
aLastPaint4 := WvtSetBlocks( aBlocks )

private M_TELA

      sqlCAMPO = {}
      sqlCHAVE =  {}
      sqlARQUI = {"ATIP00","SELECT"}
      executasql()

select ATIP00
go top
aTIPCLI = { }
aLETRA = ""

do while !eof()
  if empty(CVECOD)
    skip
    loop
  endif

  aadd(aTIPCLI,CVECOD + " " + CVENOM)
  aLETRA += CVECOD

  skip

enddo
  
 if !M_CLITIP $ aLETRA
   nOPCLOC = 0
   
lTelaloc = savescreen(06,15,18,70)

nbox(06,18,16,60,"W/W+",.t.)
setcolor("B/W")
set color to N/W,W+/N
   nOPCLOC = achoice(07,19,15,59,aTIPCLI,.T.,"MOVE")

   if lastkey()=27 .or. nOPCLOC = 0
     M_CLITIP = " "
   else
     M_CLITIP = left(aTIPCLI[nOPCLOC],1)
   endif

   set color to
restscreen(06,15,18,70,lTelaloc)
WvtSetBlocks( aLastPaint4 )

   return TIPO
 endif

return .t.

*************
function MOVE
*************

parameters  M_MODO, M_ELEM, M_POSI

if str(lastkey(), 2, 0) $ " 3#27#18"
  return 0
endif

if str(lastkey(), 2, 0) $ "13"
  return 1
endif

return 2

*****************
function VERCLI03
*****************

parameters M_CLICOD

if M_CLICOD = 0
  return .t.
endif

select ACLI00

if !dbseek(str(M_CLICOD, 7, 0))
  msg("* * * CLIENTE NAO CADASTRADO * * *")
  return .f.
endif

msg(alltrim(CLINOM))

return .t.

*****************
function VERCLI04
*****************

if rat(str(ME_DAD, 1, 0),"1#2#3") = 0
  msg("* * * (1) RESIDENCIA  (2) ENTREGA  (3) COBRANCA * * *")
  return .f.
endif

return .t.

*****************
function VERCLI05
*****************

 if lastkey() = 5
   return .t.
 endif

 if M_CLIVEN = 0
   return .f.
 endif

if !BUSCAREGISTRO("AVEN00",1,{str(M_CLIVEN,3,0)},"SELECT")
  msg("* * * VENDEDOR NAO CADASTRADO * * *")
  return .f.
endif

msw("* * * " + alltrim(AVEN00->VENNOM) + " * * *")

return .t.

*****************
function VERCLI06
*****************

if lastkey() = 5
  return .t.
endif

if M_CLITRA = 0
  return .f.
endif

if !BUSCAREGISTRO("ATRA00",1,{str(M_CLITRA,3,0)},"SELECT")
  msg("* * * TRANPORTADORA NAO CADASTRADA * * *")
  return .f.
endif

msw("* * * " + alltrim(ATRA00->TRANOM) + " * * *")

return .t.

*****************
function VERCLI07
*****************

parameters M_VER

  if lastkey() = 5
    return .t.
  endif

  if !M_VER $ "AC#SP#PR#MT#MS#TO#PA#AM#SC#RJ#RD#RN#SE#PE#MG#ES#RO#AP#AL#CE#BA#DF#GO#MA#NO#RS"
    msg("* * * ESTADO INEXISTENTE * * *")
    return .f.
  endif

return .t.


*****************
function VERCLI08
*****************

 if lastkey() = 5
   return .t.
 endif

if !str(M_CLIDCC, 1)  $ "12"
  msg("* * * (1) Consumidor  (2) Especial * * *")
  return .f.
endif

*if M_CLIDCC = 2
*   return .f.
*endif

return .t.

*****************
function VERCLI09
*****************

 if lastkey() = 5
   return .t.
 endif

*if empty(M_CLIIES1)
*  msg("* * * INSCRICAO NAO PODE SER BRANCOS * * *")
*  return .f.
*endif

return .t.

*****************
function VERCLI10
*****************

 if lastkey() = 5
   return .t.
 endif

if empty(M_CLIIES2)
  msg("* * * INSCRICAO NAO PODE SER BRANCOS * * *")
  return .f.
endif

return .t.

****************
function SETACLI
****************

  set cursor off

  set color to R+
    @ 24,  14 say "  Pr¢ximo    Anterior  (ENTER) Ocorrencia  (ESC) Sai"
  set color to 

  set color to GR+
    @ 24, 14 say chr(25)
    @ 24, 25 say chr(24)
    @ 24, 38 say "ENTER"
    @ 24, 58 say "ESC"
  set color to 

return ""

********************
function CARREGA_CLI
********************
       
   M_CLICGC1  = CLICGC1
   M_CLITIP   = CLITIP
   M_CLINOM   = CLINOM
   M_CLIDTE   = CLIDTE
   M_CLIEND1  = CLIEND1
   M_CLIUF1   = CLIUF1
   M_CLIBAI1  = CLIBAI1
   M_CLICEP1  = CLICEP1
   M_CLICCL1  = CLICCL1
   M_CLICCL2  = CLICCL2
   M_CLICCL3  = CLICCL3
   M_CLIMUN1  = CLIMUN1
   M_CLITEL1  = CLITEL1
   M_CLIFAX1  = CLIFAX1
   M_CLITEX1  = CLITEX1
   M_CLIIES1  = CLIIES1
   M_CLIREG   = CLIREG
   M_CLIDCC   = CLIDCC
   M_CLIVEN   = CLIVEN
   M_CLICLF   = CLICLF
   M_CLIEND2  = CLIEND2
   M_CLITRA   = CLITRA
   M_CLIUF2   = CLIUF2
   M_CLIBAI2  = CLIBAI2
   M_CLICEP2  = CLICEP2
   M_CLIMUN2  = CLIMUN2
   M_CLIIES2  = CLIIES2
   M_CLICGC2  = CLICGC2
   M_CLIAC    = CLIAC
   M_CLIEND3  = CLIEND3
   M_CLIUF3   = CLIUF3
   M_CLIBAI3  = CLIBAI3
   M_CLICEP3  = CLICEP3
   M_CLIMUN3  = CLIMUN3
   M_CLITEL3  = CLITEL3
   M_CLIFAX3  = CLIFAX3
   M_CLITEX3  = CLITEX3
   M_CLICON   = CLICON
   M_CLIBCO   = CLIBCO
   M_CLIULC   = CLIULC

return ""


****************
function TIPOCLI
****************
parameters M_OPC,M_OPC1,M_OPC2


      rodape("MENU","TIPO",M_FAN,"EAGRO24","Mem: " + str(memory(0), 5),M_EMP) 

*        @ 08, 24 prompt "Inclusao " HIGHLITE R/BG PERMITE 1,7,1
*        @ 09, 24 prompt "Alteracao" HIGHLITE R/BG PERMITE 1,7,2
*        @ 10, 24 prompt "Consulta " HIGHLITE R/BG PERMITE 1,7,3
*        @ 11, 24 prompt "Exclusao " HIGHLITE R/BG PERMITE 1,7,4
*        @ 12, 24 prompt "Listagem " HIGHLITE R/BG PERMITE 1,7,5
*        @ 13, 24 prompt "Outros   " HIGHLITE R/BG PERMITE 1,7,6

      do case
         case M_OPC = 1 ; inctip()
         case M_OPC = 2 ; alttip()
         case M_OPC = 3 ; contip()
         case M_OPC = 4 ; exctip()
         case M_OPC = 5 ; listip()
      endcase

return ""

***************
function INCTIP
***************

    do while .t.

      M_CVECOD = space(01)
      M_CVENOM = space(30)

      motip01() 

      rodape("INCLUI","TIPO",M_FAN,"EAGRO24","Mem: " + str(memory(0), 5),M_EMP) 

      SetColor(_COREDICAO_)
      @ 13, 36 get M_CVECOD picture "@!" valid !M_CVECOD $ "0123456789"
      read

      if M_CVECOD = " " .or. lastkey() = 27
        exit
      endif


      if BUSCAREGISTRO("ATIP00",1,{aspas(M_CVECOD)},"SELECT")
        msg("* * * TIPO JA CADASTRADO * * *")
        loop
      endif

        edtip01()             

        if lastkey() = 27
          msg("* * * TIPO NAO CADASTRADO * * *")
          loop
        endif

        grtip01("INSERT")
        
        msg("* * * TIPO INCLUIDO * * *")

    enddo

return ""

***************
function ALTTIP
***************
        
    do while .t.

        M_CVECOD = " "

      motip01() 

      rodape("ALTERA","TIPO",M_FAN,"EAGRO24","Mem: " + str(memory(0), 5),M_EMP) 

      SetColor(_COREDICAO_)
      @ 13, 36 get     M_CVECOD   picture "@!"
      read

      if M_CVECOD = " " .or. lastkey() = 27
        exit
      endif

      if !BUSCAREGISTRO("ATIP00",1,{aspas(M_CVECOD)},"SELECT")
        msg("* * * TIPO NAO CADASTRADO * * *")
        loop
      endif

      mstip01()

        M_CVECOD = CVECOD
        M_CVENOM = CVENOM

        edtip01()                      

        if lastkey() = 27
          msg("* * * TIPO NAO ALTERADO * * *")
          loop
        endif

        grtip01("UPDATE")
        
        msg("* * * TIPO ALTERADO * * *")

    enddo

return ""

***************
function CONTIP
***************

    do while .t.

        M_CVECOD = " "
        M_CVENOM = space(30)

      motip01() 

      rodape("CONSULTA","TIPO",M_FAN,"EAGRO24","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 13, 36 get     M_CVECOD   picture "@!"
        read
       
        if lastkey() = 27 .or. empty(M_CVECOD)
          exit
        endif

        if !BUSCAREGISTRO("ATIP00",1,{aspas(M_CVECOD)},"SELECT")
          msg("TIPO NAO CADASTRADO")
          loop
        endif
        
        setas()

        do while .t.

          if empty(CVECOD)
            skip 
            if eof()
              msg("* * * ARQUIVO VAZIO * * *")
              exit
            endif
            loop
          endif

          mstip01()

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
function EXCTIP
***************

private M_OPC
        
    do while .t.

        M_CVECOD = space(01)

      motip01() 

      rodape("EXCLUI","TIPO",M_FAN,"EAGRO24","Mem: " + str(memory(0), 5),M_EMP) 

      SetColor(_COREDICAO_)
        @ 13, 36 get     M_CVECOD   picture "@!"
        read

        if lastkey() = 27
          exit
        endif

        if !BUSCAREGISTRO("ATIP00",1,{aspas(M_CVECOD)},"SELECT")
          msg("* * * TIPO NAO CADASTRADO * * *")
          loop
        endif

        mstip01()

        M_OPC = confirma("deste tipo")

        if M_OPC != 1
          msg("* * * TIPO NAO EXCLUIDO * * *")
          loop
        endif

        grtip01("DELETE")

        msg("* * * TIPO EXCLUIDO * * *")

    enddo

return ""

***************
function LISTIP
*************** 

private M_CVE1  ,;
        M_CVE2  ,; 
        LN      ,;
        PG      ,;
        M_ESC   ,;
        M_TELA
 
        rodape("LISTA","TIPOS",M_FAN,"EAGRO24","Mem: " + str(memory(0), 5),M_EMP)

        BUSCAREGISTRO("ATIP00",3,"","SELECT")


        select ATIP00

        go top

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

        ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE TIPOS","EAGRO24",132) 
        ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
        ? "*-*--*---------------------------------------------------------*-*--*--------------------------------------------------------------*"
        ? "*C*UF* TIPO                                                *C*UF* TIPO                                                     *"
        ? "*-*--*---------------------------------------------------------*-*--*--------------------------------------------------------------*"
*           X XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX X XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

        store 5 to LN

        do while !eof() .and. LN < 60

            ? " "
              store 1 to CL
              do while !eof() .and. CL < 3
                ?? CVECOD
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

return "" 

**************
function MOTIP01
**************

sombra(12, 26, 15, 66,_SOMBRA_)

set color to I
    @ 12, 26 say        "                                         "
    @ 13, 26 say        "  Codigo:                                "
    @ 14, 26 say        "  Tipo  :                                "
    @ 15, 26 say        "                                         "
set color to

return ""

****************
function EDTIP01
****************

  SetColor(_COREDICAO_)
    @ 14, 36 get  M_CVENOM
    read

return ""

****************
function MSTIP01
****************

  set color to I
    @ 13, 36 say     CVECOD picture "@!"  
    @ 14, 36 say     CVENOM
  set color to
  
return ""

****************
function GRTIP01(cACAO)
****************

sqlCAMPO = {}
sqlCHAVE = {}
sqlARQUI = {"ATIP00",cACAO}

aadd(sqlCHAVE,{"CVECOD",aspas(M_CVECOD)})

if !cACAO $ "#DELETE#SELECT#"
  aadd(sqlCAMPO,{"CVECOD",M_CVECOD,.t.})
  aadd(sqlCAMPO,{"CVENOM",M_CVENOM,.t.})
endif

executasql()

return ""

****************
function EDM_CLI    // Edita o c¢digo do munic°pio do cliente
****************

parameter Ideend    // Identificador do endereáo de res/ent/cob.

M_CEP = STRZERO(M_CLICEP&Ideend,5) + strzero(M_CLICCL&Ideend,3)
oCep := buscacep(M_CEP)

*   ? '  CEP...:', oCep:cCEP
*   ? '  IBGE..:', oCep:cIBGE
*   ? '  LOGRAD:', oCep:cLogradouro
*   ? '  COMPLE:', oCep:cComplemento
*   ? '  BAIRRO:', oCep:cBairro
*   ? '  CIDADE:', oCep:cLocalidade
*   ? '  UF....:', oCep:cUF

lMuda = .f.

if Ideend == "2"
  if !str(M_CLICEP1,5) == str(M_CLICEP2,5) .or. !str(M_CLICCL1,3) == str(M_CLICCL2,3)
    lMuda = .t.
  endif
endif

if !type("oCep") == "C"
  if empty(M_CLIEND&Ideend) .or. lMuda = .t.
    M_CLIEND&Ideend= pad(TIRA_ACENTUACAO(oCep:cLogradouro),40)
  endif
  if empty(M_CLIBAI&Ideend) .or. lMuda = .t.
    M_CLIBAI&Ideend= pad(oCep:cBairro,20)
  endif
  if empty(M_CLIMUN&Ideend) .or. lMuda = .t.
    M_CLIMUN&Ideend= pad(oCep:cLocalidade,20)
  endif
  M_CLIUF&Ideend= oCep:cUF
  M_CLICDM&Ideend = val(oCep:cIBGE)
endif

if lastkey() = 5
  return .t.
endif

M_CLICDM = M_CLICDM&Ideend // var usada para jogar o c¢digo

*save get to M_GETANT

*dTela = savescreen(09, 52, 13, 77)

*sombra(09, 52, 11, 76, _SOMBRA_)

*painel(09, 52, 11, 76, "B+/B", "N/B")

*set color to W+/B
*  @ 09, 59 say "Munic°pio"
*  @ 10, 53 say "C¢digo IBGE.:          "
*set color to

*SetColor(_COREDICAO_)
*@ 10, 67 get M_CLICDM picture "#######" color _COREDICAO_
*read

if M_CLICDM = 0
  sele_arquivo("AMUN00")
  M_CLICDM = MUNCOD
endif

if !BUSCAREGISTRO("AMUN00",1,{str(M_CLICDM,7,0)},"SELECT")
  msg("* * * MUNICIPIO NAO CADASTRADO * * *")
  M_CLICDM = 0
  restscreen(09, 52, 13, 77, dTela)
  return .f.
endif

*restscreen(09, 52, 13, 77, dTela)

*setcolor("N/W*")
do case
   case Ideend = "1"
        M_CLICDM1 = M_CLICDM
        M_CLIMUN1 = AMUN00->MUNNOM
        M_CLIUF1  = AMUN00->MUNEST
*        @ 06+nLincli, 57 say M_CLIMUN1 picture "@!@S19"
*        @ 05+nLincli, 68 say M_CLIUF1  picture "@!"
   case Ideend = "2"
        M_CLICDM2 = M_CLICDM
        M_CLIMUN2 = AMUN00->MUNNOM
        M_CLIUF2  = AMUN00->MUNEST
*        @ 10+nLincli, 57 say M_CLIMUN2 picture "@!@S19"
*        @ 09+nLincli, 68 say M_CLIUF2  picture "@!"
   case Ideend = "3"
        M_CLICDM3 = M_CLICDM
        M_CLIMUN3 = AMUN00->MUNNOM
        M_CLIUF3  = AMUN00->MUNEST
*        @ 13+nLincli, 57 say M_CLIMUN3 picture "@!@S19"
*        @ 12+nLincli, 68 say M_CLIUF3  picture "@!"
endcase

*restore get from M_GETANT

*setcursor(1)

*set key -41 to
return .t.

************************
FUNCTION TIRA_ACENTUACAO( cStr )
************************


	   local cStrNew := "", nX
	   cAcentos := {"'","ó","É","∆","«"," ","µ","Ö","∑","Ç","…","Í","à","ê","“","Ì","Õ","Û","¢","‡","‰","Â","ì","‚","˙","È","Å","ö","Á","Ä","„","√","·","¡","‡","¿","È","…","Í"," ","Ì","Õ","Û","”","ı","’","Ù","‘","˙","⁄","¸","‹","Á","˘","AAO","ß","¶","∫","™","Ä","á","«","Á","'","`","¯","°","ﬁ","◊","ÿ", chr(239)}
	   cLetras  := {"","U","A","A","A"," ","A","A"," ","E","E","E","E","E","E","I","I","O","O","O","O","O","O","O"," ","U","U","U","C","C","A","A","A","A","A","A","E","E","E","E","I","I","O","O","O","O","O","O","U","U","U","U","C"," ","CAO",".",".",".",".","C","C","C","C","" ,"" ,".","I","I","I","I",    ""   }
	   For nX := 1 TO LEN(cAcentos)
       cStrNew := StrTran(cStr, cAcentos[nX], cLetras[nX])
       cStr := cStrNew
	   Next
	Return( cStrNew )


******************
PROCEDURE BUSCACEP( cCEP )
******************

   LOCAL oCep

   oCep := cepWeb( cCEP )

   IF oCep == NIL
     return ""
   ENDIF

RETURN oCep

***************
FUNCTION cepWeb( cCEP)
***************
   LOCAL oCEP := ViaCEP():New( cCEP )
RETURN oCEP

/*
 *  ViaCEP Class
 */

#include 'hbclass.ch'

CREATE CLASS ViaCEP
   VAR oCep
   VAR cCep         INIT ''
   VAR cIBGE        INIT ''
   VAR cLogradouro  INIT ''
   VAR cComplemento INIT ''
   VAR cBairro      INIT ''
   VAR cLocalidade  INIT ''
   VAR cUF          INIT ''
   METHOD New( cCEP )
ENDCLASS


METHOD New( cCEP )




*REQUEST HB_CODEPAGE_PT850
*REQUEST HB_CODEPAGE_PTISO
*HB_SETCODEPAGE( "PT850" )

*cCEP = "19023030"

*URLLer := "https://opencep.com/v1/19023650.json"

URLLer := "http://viacep.com.br/ws/" + cCEP + "/json/"
oHttp1:= CreateObject( 'MSXML2.ServerXMLHTTP.6.0' )
oHttp1:Open( "GET",URLLer, .f. )
oHttp1:setRequestHeader('Accept','application/json')
oHttp1:setRequestHeader('Content-Type'  , 'application/json')

*oHttp1:setRequestHeader('Accept','application/json')
*oHttp1:setRequestHeader('Content-Type'  , 'application/json')

oHttp1:Send()

IF oHttp1:status != 200
  IF oHttp1:status = 400  // nenhum pedido encontrado
    lTempedido = .f.
  else
    ALERT( Alltrim(Str(oHttp1:status)) +" - "+ oHttp1:statusText , "Erro na requisiÁ„o")
    RETURN NIL
  endif
ENDIF

cHtml := HB_UTF8TOSTR( oHttp1:ResponseBody )
cHtml := TIRA_ACENTUACAO(cHtml)
aHtml := upper(cHtml)

*
*aHtml := hb_aTokens( aHtml, ',' )
*aHtml := HB_ATokens( aHtml, chr( 13 ) )
*alert(aHtml)

lCep = AT( '"CEP":', aHtml) + 1

lLogra = AT( '"LOGRADOURO":', aHtml) + 1
lCom = AT( '"COMPLEMENTO":', aHtml) + 1
lUni = AT( '"UNIDADE":', aHtml) + 1
lBai = AT( '"BAIRRO":', aHtml) + 1

lLoc = AT( '"LOCALIDADE":', aHtml) + 1
lUF  = AT( '"UF":', aHtml) + 1
lEst = AT( '"ESTADO":', aHtml) + 1
lReg = AT( '"REGIAO":', aHtml) + 1
lIbg = AT( '"IBGE":', aHtml) + 1

lGia = AT( '"GIA":', aHtml) + 1
lddd = AT( '"DDD":', aHtml) + 1
lsia = AT( '"SIAFI":', aHtml) + 1

*altd()

cCEP := SUBSTR( aHtml, lCep+7 , lLogra-(lCep+7+6) )
*alert(cCEP)
cLogradouro  := SUBSTR( aHtml, lLogra+14 , lCom-(lLogra+14+6) )
*alert(cLogradouro)

cComplemento := SUBSTR( aHtml, lCom+15 , lUni-(lCom+15+6) )
*alert(cComplemento)
cBairro      := SUBSTR( aHtml, lBai+10 , lLoc-(lBai+10+6) )
*alert(cBairro)
cLocalidade  := SUBSTR( aHtml, lLoc+14 , luf-(lLoc+14+6) )
*alert(cLocalidade)
cUF          := SUBSTR( aHtml, luf+6   , lest-(luf+6+6) )
*alert(cUF)
cIBGE        := SUBSTR( aHtml, libg+8 , lgia-(libg+8+6) )
*alert(cIBGE)




*atexto1 := hb_aTokens( aHtml, ',' )

*alert(atexto)

*aHtml := HB_ATokens( atexto, CRLF )

*For i := 1 to Len(aTexto1)
 //-- Cada linha da matriz È uma linha do seu TXT
*end

*M_MEMO = memoedit(aHtml,04,03,19,75,.f.,,73)
* oHttp := TIPClientHTTP():new( "https://opencep.com/v1/19023650.json" )

   *oHttp := TIPClientHTTP():new( "http://viacep.com.br/ws/" + cCEP + "/piped/" )

*   IF ! oHttp:open()
*      RETURN NIL
*   ENDIF

*   cHtml := oHttp:readAll()
*   oHttp:close()
   
*   alert(cHtml)
   
   
*   cUtf8 := hb_strToUTF8( cStr )
   
   
*	cHtml := HB_UTF8TOSTR( cHtml )

   IF LEN( aHtml ) < 7
      RETURN NIL
   ENDIF


*   cCEP         := SUBSTR( aHtml[1], AT( ':', aHtml[1] ) + 1 )
*   cLogradouro  := SUBSTR( aHtml[2], AT( ':', aHtml[2] ) + 1 )
*   cComplemento := SUBSTR( aHtml[3], AT( ':', aHtml[3] ) + 1 )
*
*   cBairro      := SUBSTR( aHtml[5], AT( ':', aHtml[5] ) + 1 )
*   cLocalidade  := SUBSTR( aHtml[6], AT( ':', aHtml[6] ) + 1 )
*   cUF          := SUBSTR( aHtml[7], AT( ':', aHtml[7] ) + 1 )
*   cIBGE        := SUBSTR( aHtml[10], AT( ':', aHtml[10] ) + 1 )

   ::cCEP         := cCEP
   ::cLogradouro  := cLogradouro
   ::cComplemento := cComplemento
   ::cBairro      := cBairro
   ::cLocalidade  := cLocalidade
   ::cUF          := cUF
   ::cIBGE        := cIBGE

RETURN Self


****************
function MSCLI01a
****************

dCLIDTE = iif(HB_ISNIL(CLIDTE),ctod("  /  /  "),CLIDTE)
dCLIULC = iif(HB_ISNIL(CLIULC),ctod("  /  /  "),CLIULC)

   SetColor(_COREDICAO_)
    @ 01+nLincli, 33 get    CLICGC1   picture "@R 999.999.999/9999-99"
    @ 01+nLincli, 58 get    CLIIES1   picture "@!"
    @ 01+nLincli, 82 get    dCLIDTE
    @ 02+nLincli, 15 get    CLINOM    picture "@!@S40"

*   @ 02+nLincli, 65 get    REVENDA   picture "@!"
    @ 02+nLincli, 77 get    NOMEPAI   picture "@!@S15"

    @ 04+nLincli, 15 get    CLICEP1   picture "#####"
    @ 04+nLincli, 21 get    CLICCL1   picture "###"
    @ 04+nLincli, 35 get    CLICDM1   picture "9999999"
    @ 04+nLincli, 51 get    CLIMUN1   picture "@!@S34"
    @ 04+nLincli, 90 get    CLIUF1    picture "@!"
    @ 05+nLincli, 15 get    CLIEND1   picture "@!"
    @ 05+nLincli, 70 get    CLINRO1   picture "@!"
    @ 05+nLincli, 82 get    CLICPE1
    @ 06+nLincli, 15 get    CLIBAI1   picture "@!"
    @ 06+nLincli, 43 get    CLITEL1   picture "@!"
    @ 06+nLincli, 60 get    CLIFAX1   picture "@!"
    @ 06+nLincli, 77 get    CLITEX1   picture "@!"


    @ 08+nLincli, 15 get    CLICEP2   picture "#####"
    @ 08+nLincli, 21 get    CLICCL2   picture "###"
    @ 08+nLincli, 35 get    CLICDM2   picture "9999999"
    @ 08+nLincli, 51 get    CLIMUN2   picture "@!@S34"
    @ 08+nLincli, 90 get    CLIUF2    picture "@!"
    @ 09+nLincli, 15 get    CLIEND2   picture "@!"
    @ 09+nLincli, 70 get    CLINRO2   picture "@!"
    @ 09+nLincli, 82 get    CLICPE2
    @ 10+nLincli, 15 get    CLIBAI2   picture "@!"


    @ 12+nLincli, 15 get    CLICEP3   picture "#####"
    @ 12+nLincli, 21 get    CLICCL3   picture "###"
    @ 12+nLincli, 35 get    CLICDM3   picture "9999999"
    @ 12+nLincli, 51 get    CLIMUN3   picture "@!@S34"
    @ 12+nLincli, 90 get    CLIUF3    picture "@!"
    @ 13+nLincli, 15 get    CLIEND3   picture "@!"
    @ 13+nLincli, 70 get    CLINRO3   picture "@!"
    @ 13+nLincli, 82 get    CLICPE3
    @ 14+nLincli, 15 get    CLIBAI3   picture "@!"
    @ 14+nLincli, 43 get    CLITEL3   picture "@!"
    @ 14+nLincli, 60 get    CLIFAX3   picture "@!"
    @ 14+nLincli, 77 get    CLITEX3   picture "@!"

    @ 16+nLincli, 15 get    CLICON    picture "@!"
    @ 16+nLincli, 39 get    CLIREG    picture "##"
    @ 16+nLincli, 53 get    CLIVEN    picture "###"
    @ 16+nLincli, 72 get    CLITRA    picture "###"
    @ 16+nLincli, 84 get    dCLIULC

    @ 17+nLincli, 15 get    CLIAC     picture "@!"
    @ 17+nLincli, 36 get    CLIBCO    picture "#####"
    @ 17+nLincli, 53 get    CLITIP    picture "@!"
    @ 17+nLincli, 72 get    CLICLF    picture "@!"
    @ 17+nLincli, 84 get    CLIDCC    picture "#"
    @ 19+nLincli, 15 get    CLISITE
    @ 20+nLincli, 15 get    CLIEMAIL
 set color to

return ""
