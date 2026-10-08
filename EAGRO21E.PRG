***************
function CANNFS
***************

private M_TELA,;
M_OPC

M_TELA = savescreen(02, 04, 21, 77)

do while .t.

  rodape("CANCELA","NOTA FISCAL",M_FAN,"EAGRO21E","Mem: " + str(memory(0), 5),M_EMP)

  store 0              to M_NFSNUM
  store AEMP00->EMPSER to M_NFSSER
  store 512.99         to M_NFSNAT
  lJacancelada = .f.

  nbox(09, 29, 15, 74,"W/W+",.t.)
  setcolor("B/W")
  @ 10, 30 say     "                                            "
  @ 11, 30 say     "Numero  :                  Serie  :         "
  @ 12, 30 say     "Operacao:                                   "
  @ 13, 30 say     "Valor   :                  Emissao:         "
  @ 14, 30 say     "Cliente :                                   "
  SetColor(_COREDICAO_)
  @ 11, 40 get     M_NFSNUM picture "#######"
  @ 11, 66 get     M_NFSSER picture "@!"
  read

  if M_NFSNUM = 0 .or. lastkey() = 27
    exit
  endif

  lCannfs = .f.
  lCannfe = .f.
  M_CODCAN = 0
  M_NFSID = ""

  if !BUSCAREGISTRO("ANFS00",1,{str(ME_EMP, 2, 0),str(M_NFSNUM, 9, 0),aspas(M_NFSSER)},"SELECT")
    sqlRELATION = {}
    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {}
    sqlORDEM = {}

    aadd(sqlARQUI,{"ANFE00","ANFE00"})
    aadd(sqlCAMPO,"ANFE00.*")
    aadd(sqlCHAVE,"NFEEMP = " + str(ME_EMP, 2, 0))
    aadd(sqlCHAVE,"NFENUM = " + str(M_NFSNUM, 6, 0))
    aadd(sqlCHAVE,"NFESER = " + aspas(M_NFSSER))
    sqlrelation()

    if !str(NFEEMP,2, 0) + str(NFENUM,6,0) + NFESER == str(ME_EMP, 2, 0) + str(M_NFSNUM, 6, 0) + M_NFSSER
      msg("* * * NOTA FISCAL NAO ENCONTRADA * * *")
      loop
    else
      lCannfe = .t.
    endif
  else
    lCannfs = .t.
  endif


    if lCannfs
      if NFSCAN = "C"
        msg("* * * NOTA FISCAL JA CANCELADA * * *")
        loop
      endif
      if NFSCAN = "C"
        lJacancelada = .f.
      endif

      BUSCAREGISTRO("ACLI00",1,{str(ANFS00->NFSCLI,7,0)},"SELECT")
      select ANFS00
      M_NFSNAT = val(left(str(NFSNAT, 5, 0), 3) + ".99")
      M_NFSVLN = NFSVLN
      M_NFSDTE = NFSDTE
      M_CLINOM = left(ACLI00->CLINOM,33)
    else
      if NFECAN = "C"
        msg("* * * NOTA FISCAL JA CANCELADA * * *")
        loop
      endif
      if NFECAN = "C"
        lJacancelada = .f.
      endif
      BUSCAREGISTRO("AFOR00",1,{str(ANFE00->NFEFOR,5,0)},"SELECT")
      select ANFE00
      M_NFSNAT = NFENAT/100
      M_NFSVLN = NFEVLN
      M_NFSDTE = NFEDTR
      M_CLINOM = left(AFOR00->FORNOM,33)
    endif

    setcolor("N/W*")
    @ 12, 40 say     M_NFSNAT picture "###.##"
    @ 13, 40 say     M_NFSVLN  picture "@E ###,###,###.##"
    @ 13, 66 say     M_NFSDTE
    @ 14, 40 say     left(M_CLINOM,33)

    set color to

    do while .t.
      M_OPC = msgbox3("Confirma Cancelamento desta Nota Fiscal",,18,"Escolha","Sim","Nao")
      if M_OPC = 2
        exit
      endif
      if M_OPC = 3
        exit
      endif
    enddo

    M_OPC --

    if M_OPC != 1
      msg("* * * NOTA FISCAL NAO CANCELADA * * *")
      loop
    endif

  M_HIS1 = space(50)
  M_HIS2 = space(50)
  M_HIS3 = space(50)
  M_HIS4 = space(50)
  M_HIS5 = space(50)

  nbox(08, 15, 10, 66,"W/W+",.t.)
  setcolor("B/W")
  @ 08, 16 say   "Motivo do cancelamento  -  Minimo 15 digitos ÄÄÄÄÄ"
  @ 09, 16 say   "                                                  "
  @ 10, 16 say   "                                                  "
  set color to

  do while .t.

    SetColor(_COREDICAO_)
    @ 09, 16 get M_HIS1 picture "@!" valid (!empty(M_HIS1) .and. len(alltrim(M_HIS1)) > 15)
    read

    msg("* * * (ENTER) Continua  (ESC) Sai * * *")

    if lastkey() = 27
      exit
    endif

  enddo

  if lCannfs
    M_NOAR1 = "\\SERVIDOR\C\ATLAS\ENVIADO\" + alltrim(ANFS00->NFSUSU) + "\nfe\" + alltrim(ANFS00->NFSID)
    M_NOAR = left(alltrim(ANFS00->NFSID),44)
    M_MEMO= memoread(M_NOAR1)
    lScan = .f.

    msw("CANCELANDO NOTA FISCAL ELETRONICA")

    M_MEMO := NFe_CAN(M_NOAR,alltrim(M_HIS1))
    M_MEMO = upper(M_MEMO) 

    mon_env("NFE.SetFormaEmissao(1)")
    cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

    lTela2 = savescreen(04,03,19,75)

    pos = rat("CSTAT=",M_MEMO)
    M_NOAR = substr(M_MEMO,POS+6,3)

    if !M_NOAR $ "135#101#218#420#155" // NAO CANCELOU DEU PROBLEMA
      M_MEMO += chr(13)+chr(10)
      M_MEMO += "PROBLENA NO CANCELAMENTO (ESC) PARA SAIR"+ chr(13)+chr(10)
      M_MEMO += chr(13)+chr(10)
      M_MEMO += "VERIFIQUE NO SITE DA RECEITA SE A NOTA FOI CANCELADA"+ chr(13)+chr(10)
      keyboard chr(30)  // CTRL + PageDown
      M_MEMO = memoedit(M_MEMO,04,03,19,75,.f.,,73)
      clear
      restscreen(4,3,19,75,lTela2)
      return ""
    endif

    NFe_CON(M_NOAR1)

    M_MEMO = "NOTA FISCAL CANCELADA"
    M_MEMO += chr(13)+chr(10)
    M_MEMO += "PRESSIONE (ESC) PARA SAIR"+ chr(13)+chr(10)
    M_MEMO = memoedit(M_MEMO,04,03,19,75,.f.,,73)
    restscreen(04,03,19,75,lTela2)

    msw("Excluindo titulos")

    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"ADCR00","DELETE"}
    aadd(sqlCHAVE,{"DUPEMP",str(ME_EMP, 2)})
    aadd(sqlCHAVE,{"DUPNUM",str(M_NFSNUM, 9)})
    aadd(sqlCHAVE,{"DUPSER",aspas(M_NFSSER)})
    executasql()

    msw("Marcando nota como cancelada")

    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"ANFS00","UPDATE"}
    aadd(sqlCHAVE,{"NFSEMP",str(ME_EMP,2)})
    aadd(sqlCHAVE,{"NFSNUM",str(M_NFSNUM,9)})
    aadd(sqlCHAVE,{"NFSSER",aspas(M_NFSSER)})
    aadd(sqlCAMPO,{"NFSCAN","C",.t.})
    aadd(sqlCAMPO,{"NFSHS1","CANCELADO POR " + M_LOGNOM + " EM " + dtoc(date()),.t.})
    executasql()

    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"ANFS01","UPDATE"}
    aadd(sqlCHAVE,{"NFSEMP",str(ME_EMP,2)})
    aadd(sqlCHAVE,{"NFSNUM",str(M_NFSNUM,9)})
    aadd(sqlCHAVE,{"NFSSER",aspas(M_NFSSER)})
    aadd(sqlCAMPO,{"NFSCAN","C",.t.})
    executasql()

    sqlCAMPO = {}
    sqlCHAVE =  {}
    sqlARQUI = {"AKAR00","DELETE"}
    aadd(sqlCHAVE,{"KAREMP",str(ME_EMP, 2)})
    aadd(sqlCHAVE,{"KARDOC",str(M_NFSNUM, 9)})
    aadd(sqlCHAVE,{"KARCLI",str(ANFS00->NFSCLI, 5)})
    aadd(sqlCHAVE,{"KARDTA",aspas(formatdta(ANFS00->NFSDTE))})
    executasql()
  else

*    do while .t.
*      select 0
*      M_ARQC = ACBrNFe_UNI + ":\CIRUR\NFE\ANFS00"

*      use &M_ARQC alias ANFSAA exclusive
*      if neterr()
*        setcolor("")
*        msw("A NOTA FISCAL ESTA SENDO EMITIDA POR OUTRA MAQUINA AGUARDE")
*        inkey(.1)
*        loop
*      endif
*      exit
*    enddo
*    zap

 *   M_NOAR1 = "C:\CIRUR\ENVIADO\" + alltrim(ANFE00->NFSUSU) + "\nfe\" + alltrim(ANFE00->NFSID)
 *   M_NOAR = left(alltrim(ANFE00->NFSID),44)

  *  msw("CANCELANDO NOTA FISCAL ELETRONICA")

  *  M_MEMO := NFe_CAN(M_NOAR,alltrim(M_HIS1))
  *  M_MEMO = upper(M_MEMO)

  *  lTela2 = savescreen(04,03,19,75)

  *  pos = rat("CSTAT=",M_MEMO)
  *  M_NOAR = substr(M_MEMO,POS+6,3)

   * if !M_NOAR $ "135#101#218#420" // NAO CANCELOU DE PROBLEMA
   *   M_MEMO += chr(13)+chr(10)
   *   M_MEMO += "PROBLENA NO CANCELAMENTO (ESC) PARA SAIR"+ chr(13)+chr(10)
   *   M_MEMO += chr(13)+chr(10)
   *   M_MEMO += "VERIFIQUE NO SITE DA RECEITA SE A NOTA FOI CANCELADA"+ chr(13)+chr(10)
   *   keyboard chr(30)  // CTRL + PageDown
   *   M_MEMO = memoedit(M_MEMO,04,03,19,75,.f.,,73)
   *   clear
   *   restscreen(4,3,19,75,lTela2)
   *   select ANFSAA
   *   use
   *   return ""
   * endif

   * NFe_CON(M_NOAR1)

   * M_MEMO = "NOTA FISCAL CANCELADA"
   * M_MEMO += chr(13)+chr(10)
   * M_MEMO += "PRESSIONE (ESC) PARA SAIR"+ chr(13)+chr(10)
   * M_MEMO = memoedit(M_MEMO,04,03,19,75,.f.,,73)
   * restscreen(04,03,19,75,lTela2)

*    select ADCP00
*    set order to 1

 *   for A = 0 to 99
 *     if dbseek(str(ANFE00->NFEEMP,2) + str(ANFE00->NFENUM,7) + str(A,2) + ANFE00->NFESER + str(ANFE00->NFEFOR,5))
 *       select ALCP00
 *       do while .t.
 *         dbseek(str(ADCP00->DUPEMP,2) + str(ADCP00->DUPNUM,7) + str(ADCP00->DUPORD,2) + ADCP00->DUPSER,.t.)
 *         if !str(LANEMP,2) + str(LANNUM,7) + str(LANORD,2) + LANSER  == str(ADCP00->DUPEMP,2) + str(ADCP00->DUPNUM,7) + str(ADCP00->DUPORD,2) + ADCP00->DUPSER
 *           exit
 *         endif
 *         elimina()
 *       enddo
 *       select ADCP00
 *       elimina()
 *     endif
 *   next

 *   select ANFE01
 *   dbseek(str(ANFE00->NFEEMP, 2, 0) + str(ANFE00->NFENUM, 7, 0) + ANFE00->NFESER + str(ANFE00->NFEFOR, 5, 0),.t.)

  *  do while !eof()

  *    if !str(NFEEMP, 2, 0) + str(NFENUM, 7, 0) + NFESER + str(NFEFOR, 5, 0)  == str(ANFE00->NFEEMP, 2, 0) + str(ANFE00->NFENUM, 7, 0) + ANFE00->NFESER + str(ANFE00->NFEFOR, 5, 0)
   *     exit
   *   endif

    **  select AKAR00
    *  if dbseek(str(ANFE01->NFEEMP,2) + str(ANFE01->NFEMAT,6) + dtos(ANFE01->NFEDTR) + str(ANFE00->NFENAT,5) + str(ANFE01->NFENUM,7) + str(ANFE01->NFESEQ,2))
    *    elimina()
    *  endif

    *  select APCA00            && procura saldo da peca

    *  if dbseek(str(ANFE01->NFEMAT, 6, 0))
    *    do while .t.
    *      if rlock()
    *        if AFIS00->FISEST = "C"
    *          replace SLDDIS&MSEMP with ( SLDDIS&MSEMP - ANFE01->NFEQDE )
    *        else
    *          if AFIS00->FISEST = "D"
    *            replace SLDDIS&MSEMP with ( SLDDIS&MSEMP + ANFE01->NFEQDE )
    *          endif
    *        endif
    *        unlock
    *        exit
    *      else
    *        msg("* * * (APCA00) REGISTRO SENDO USADO * * *")
    *      endif
    *      if lastkey() = 17
    *        exit
    *      endif
    *    enddo
    *  endif

    *  select ANFE01
    *  skip

    *enddo

    *select ANFE00                && seleciona mestre NFS para flag "C"

    *do while .t.
    *  if rlock()
     *   replace NFECAN   with "C"
     *   replace NFELIV with M_LOGNOM + " " + dtoc(date()) + " " + time()
     *   commit
     *   unlock
     *   exit
     * else
     *   msg("* * * (ANFS00) REGISTRO SENDO USADO * * *")
     * endif
     * if lastkey() = 17
     *   exit
     * endif
    *enddo

  endif

  msg("* * * NOTA FISCAL CANCELADA * * *")

enddo

restscreen(02, 04, 21, 77, M_TELA)

return ""

****************
function VERCAN1                       && ve natureza
****************

select AFIS00

if !dbseek(str(ME_EMP, 2, 0) + str((M_NFSNAT*100), 5, 0))
  return .f.
endif

set color to I
@ 12, 47 say left(FISNOM, 27)
set color to

return .t.

