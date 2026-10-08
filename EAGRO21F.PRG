#xtranslate CLEARESC() => ( __keyboard(chr(0)), inkey() )

***************
function MANCRR
***************

select 0
use &_PATH_\USR\FATURA\CORRE2 exclusive
zap

private M_TELA,;
M_OPC

M_TELA = savescreen(10, 29, 15, 75)
M_TELA2 = savescreen(2, 0, 24, 80)


do while .t.

  lPrimeiro = .t.

  rodape("CORRECAO","NOTA FISCAL",M_FAN,"EAGRO21F","Mem: " + str(memory(0), 5),M_EMP)

  store 0              to M_NFSNUM
  store AEMP00->EMPSER to M_NFSSER
  store date()         to M_NFSDTA

  M_COR1 = space(70)
  M_COR2 = space(70)
  M_COR3 = space(70)
  M_COR4 = space(70)
  M_COR5 = space(70)
  M_COR6 = space(70)
  M_COR7 = space(70)
  M_COR8 = space(70)
  M_COR9 = space(70)

  nbox(10, 29, 14, 74,"W/W+",.t.)
  setcolor("B/W")
  @ 11, 30 say     "Numero  :                  Serie  :         "
  @ 12, 30 say     "Operacao:                  Emissao:         "
  @ 13, 30 say     "Valor   :                  Data   :         "
  SetColor(_COREDICAO_)
  @ 11, 40 get     M_NFSNUM picture "######"
  @ 11, 66 get     M_NFSSER picture "@!" valid vercrr2()
  @ 13, 66 get     M_NFSDTA
  read

  if M_NFSNUM = 0 .or. lastkey() = 27
    restscreen(10, 29, 15, 75, M_TELA)
    exit
  endif

  M_MEMO = ""
  M_NFSID = ANFS00->NFSID
  M_NFSCLI = ANFS00->NFSCLI
  
  BUSCAREGISTRO("ACLI00",1,{str(ANFS00->NFSCLI,7,0)},"SELECT")

  moinf01()
  edinf11()

  M_ESCOLHA = 0
  
  do while .t.
    M_ESCOLHA = msgbox3("Confirma emissao da carta de correcao",,,"Escolha","Sim","Nao")
    if M_ESCOLHA > 1
      exit
    endif
  enddo

  if M_ESCOLHA != 2
    loop
  endif

  restscreen(10, 29, 15, 75, M_TELA)


  if correcao()

    hanmdf=fopen(ACBrNFe_SAI)
    lPrimeiro = .f.

    feof = .f.

    do while .t.

      if feof
        exit
      endif

      M_FRAZE = upper(alltrim(fReadline(hanmdf)))

      if left(M_FRAZE, 8) == "ARQUIVO="
        M_CHAV = substr(alltrim(M_FRAZE),9,len(alltrim(M_FRAZE))-8)
        exit
      endif

    enddo

    fclose(hanmdf)


    m_env = 'NFe.ImprimirEvento("' + M_CHAV + '")'
    mon_env(m_env)
    cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
    m_env = 'NFe.ImprimirEventoPDF("' + M_CHAV + '")'

    mon_env(m_env)
    cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

    hanmdf=fopen(ACBrNFe_SAI)
    lPrimeiro = .f.

    feof = .f.

    do while .t.

      if feof
        exit
      endif

      M_FRAZE = upper(alltrim(fReadline(hanmdf)))

      if left(M_FRAZE, 23) == "OK: ARQUIVO CRIADO EM: "
        M_PDF = substr(alltrim(M_FRAZE),24,len(alltrim(M_FRAZE))-23)
        exit
      endif

    enddo

    fclose(hanmdf)

    cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.


    emailcor()

  endif

  exit

enddo

restscreen(2, 0, 24, 80, M_TELA2)

fecha_arq()

return ""

*****************
function EMAILCOR
*****************

M_EMAIL = "scilas@hotmail.com.br"

mon_env("EMAIL.novo")
cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

mon_env("EMAIL.UsarHtml(true)")
cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

mon_env('EMAIL.Assunto("Carta de Correcao CC-e")')
cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

txt1 := '<div style="text-align: center;">&nbsp;</div>'
txt1 += '<div style="text-align: center;">'
txt1 += '<div style="line-height: 21.3px; white-space: normal; font-family: '
txt1 += "'Segoe UI', 'Segoe UI Web Regular', 'Segoe UI Symbol', 'Helvetica Neue'," 
txt1 += "'BBAlpha Sans',   'S60 Sans', Arial, sans-serif; color: #444444; font-size: "
txt1 += '15px; background-color: #ffffff;">'
txt1 += 'Segue anexo Carta de Correcao</div>'
txt1 += '<div style="line-height: 21.3px; white-space: normal; font-family: '
txt1 += "'Segoe UI', 'Segoe UI Web Regular', 'Segoe UI Symbol', 'Helvetica Neue', "
txt1 += "'BBAlpha Sans',   'S60 Sans', Arial, sans-serif; color: #444444; font-size: "
txt1 += '15px; background-color: #ffffff;">'
txt1 += 'Referente a nota fiscal de N&uacute;mero:</div>'
txt1 += '<div style="line-height: 21.3px; white-space: normal; font-family: '
txt1 += "'Segoe UI', 'Segoe UI Web   Regular', 'Segoe UI Symbol', 'Helvetica Neue', "
txt1 += "'BBAlpha Sans', 'S60 Sans', Arial, sans-serif; color: #444444; font-size: "
txt1 += '15px; background-color: #ffffff;">&nbsp;</div>'
txt1 += '</div>'
txt1 += '<h1 style="text-align: center;"><strong>' + alltrim(str(ANFS00->NFSNUM,6)) + '</strong></h1>'
txt1 += '<div style="text-align: center;">'
txt1 += '<div style="line-height: 21.3px; white-space: normal; font-family: '
txt1 += "'Segoe UI', 'Segoe UI Web Regular', 'Segoe UI Symbol', 'Helvetica Neue', "
txt1 += "'BBAlpha Sans',   'S60 Sans', Arial, sans-serif; color: #444444; font-size: "
txt1 += '15px; background-color: #ffffff;">&nbsp;</div>'
txt1 += '<div style="line-height: 21.3px; white-space: normal; font-family: '
txt1 += "'Segoe UI', 'Segoe UI Web Regular', 'Segoe UI Symbol', 'Helvetica Neue', "
txt1 += "'BBAlpha Sans',   'S60 Sans', Arial, sans-serif; color: #444444; font-size: "
txt1 += '15px; background-color: #ffffff;">'
txt1 += 'Estamos a disposi&ccedil;&atilde;o para dirimir quaisquer '
txt1 += 'd&uacute;vidas.&nbsp;</div>'
txt1 += '<div style="line-height: 21.3px; white-space: normal; font-family: '
txt1 += "'Segoe UI', 'Segoe UI Web   Regular', 'Segoe UI Symbol', 'Helvetica Neue', "
txt1 += "'BBAlpha Sans', 'S60 Sans', Arial, sans-serif; color: #444444; font-size: "
txt1 += '15px; background-color: #ffffff;">Atenciosamente;&nbsp;</div>'
txt1 += '<div style="line-height: 21.3px; white-space: normal; font-family: '
txt1 += "'Segoe UI', 'Segoe UI Web Regular', 'Segoe UI Symbol', 'Helvetica Neue', "
txt1 += "'BBAlpha Sans', 'S60 Sans', Arial, sans-serif; color: #444444; font-size: "
txt1 += '15px; background-color: #ffffff;"><span style="font-size: 18px;">'
txt1 += '<strong>Cirurcenter Produtos Hospitalares '
txt1 += 'Ltda - Epp.&nbsp;&nbsp;</strong></span></div>'
txt1 += '<div><span style="line-height: 21.3px; color: #444444; font-family: '
txt1 += "'Segoe UI', 'Segoe UI Web Regular', 'Segoe UI Symbol', 'Helvetica Neue', "
txt1 += "'BBAlpha Sans', 'S60   Sans', Arial, sans-serif; font-size: 15px; "
txt1 += 'background-color: #ffffff;">Presidente Prudente - SP</span></div>'
txt1 += '<div style="line-height: 21.3px; white-space: normal; font-family: '
txt1 += "'Segoe UI', 'Segoe UI Web Regular', 'Segoe UI Symbol', 'Helvetica Neue',   "
txt1 += "'BBAlpha Sans', 'S60 Sans', Arial, sans-serif; color: #444444; font-size: "
txt1 += '15px; background-color: #ffffff;"><span style="font-size: 18px;">'
txt1 += 'fone/fax: (18) 2104-6060</span></div>'
txt1 += '<div style="line-height: 21.3px; white-space: normal; font-family: '
txt1 += "'Segoe UI', 'Segoe UI Web Regular', 'Segoe UI Symbol', 'Helvetica Neue', "
txt1 += "'BBAlpha Sans', 'S60 Sans', Arial, sans-serif; color: #444444; font-size: "
txt1 += '15px; background-color: #ffffff;"><a style="line-height: 21.3px; font-weight: '
txt1 += 'inherit; color: #0068cf; cursor: pointer;" href="" '
txt1 += 'target=""></a></div>'
txt1 += '<div style="line-height: 21.3px; white-space: normal; font-family: '
txt1 += "'Segoe UI', 'Segoe UI Web Regular', 'Segoe UI Symbol', 'Helvetica Neue', "
txt1 += "'BBAlpha Sans', 'S60 Sans', Arial, sans-serif; color: #444444; font-size: "
txt1 += '15px; background-color: #ffffff;">&nbsp;</div>'
txt1 += '</div>'
txt1 += '<h1>&nbsp;</h1>'

mon_env('EMAIL.TextoMensagem("' + txt1 + '")')
cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

if !"SCILAS" $ M_LOGNOM
  if !empty(ACLI00->CLIEMAIL)
    mon_env('EMAIL.AdicionaPara(' + alltrim(ACLI00->CLIEMAIL) + ")")  //
    cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
  endif

  if BUSCAREGISTRO("MENSAGE2",1,{str(ANFS00->NFSCLI,7,0)},"SELECT")
    if !empty(EMAIL1)
      mon_env('EMAIL.AdicionaPara(' + alltrim(EMAIL1) + ")")  //
      cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
    endif
    if !empty(EMAIL2)
      mon_env('EMAIL.AdicionaPara(' + alltrim(EMAIL2) + ")")  //
      cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
    endif
    if !empty(EMAIL3)
      mon_env('EMAIL.AdicionaPara(' + alltrim(EMAIL3) + ")")  //
      cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
    endif
    if !empty(EMAIL4)
      mon_env('EMAIL.AdicionaPara(' + alltrim(EMAIL4) + ")")  //
      cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
    endif
  endif
endif

if "SCILAS" $ M_LOGNOM
  mon_env('EMAIL.AdicionaPara(' + alltrim(M_EMAIL) + ")")  // 
  cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
endif


mon_env('EMAIL.AdicionaAnexo("' + M_PDF + '")')
cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

mon_env('EMAIL.Enviar()')
cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

msg("* * * EMAIL ENVIADO * * *")

return ""

****************
function EDINF11
****************

private TESTE,MENSAGEM,M_ARQ,lSaida,lGrava

do while .t.

  SetColor(_COREDICAO_)
  @ 06, 04 get M_COR1
  @ 07, 04 get M_COR2 
  @ 08, 04 get M_COR3 
  @ 09, 04 get M_COR4 
  @ 10, 04 get M_COR5 
  @ 11, 04 get M_COR6 
  @ 12, 04 get M_COR7 
  @ 13, 04 get M_COR8 
  @ 14, 04 get M_COR9 
  read

  msg("* * * (ENTER) Continua  (PageDown) Sai * * *")

  if lastkey() = 3
    exit
  endif

enddo

setcolor("")

return ""

****************
function IMPTEL5
****************

if lastkey() = 23 // CTR W
  lGrava = .t.
  lSaida = .t.
  return ""
endif

if !chr(lastkey()) $ "qwertyuiop[]asdfghjkl;'zxcvbnm,./1234567890-=!@#$%^*()_+)" .and. !chr(lastkey()) $ upper("qwertyuiop[]asdfghjkl;'zxcvbnm,./1234567890-=!@#$%^*()_+)")
  return ""
endif

*keyboard(chr(lastkey()))

*TESTE = ""
*TESTE = memoedit(TESTE,04,03,19,75,.t.,,73)

*if !lastkey() == 27
*  MENSAGEM = ""
*  MENSAGEM +=TESTE+chr(13)+chr(10)
*  MENSAGEM +=M_MEMO+=chr(13)+chr(10)
*  lGrava = .t.
*endif

*memowrit("&M_ARQ",MENSAGEM)
*keyboard chr(27)
lSaida = .f.

return ""

****************
function VERCRR1                       && ve natureza
****************

select AFIS00

if !dbseek(ANFS00->NFSNATN)
  return .f.
endif

set color to I
@ 12, 47 say left(FISNOM, 16)
set color to

return .t.

****************
function VERCRR2                       && ve nota fiscal
****************

if lastkey() = 5
  return .t.
endif

if !BUSCAREGISTRO("ANFS00",1,{str(ME_EMP, 2, 0),str(M_NFSNUM, 6, 0),aspas(M_NFSSER)},"SELECT")
  msg("* * * NOTA FISCAL NAO ENCONTRADA * * *")
  M_NFSNUM = 0
  M_NFSSER = AEMP00->EMPSER
  keyboard chr(05)
  return .f.
endif

set color to I
@ 12, 66 say     NFSDTE
@ 12, 40 say     NFSNATN picture "###.##"
@ 13, 40 say     NFSVLN  picture "@E ###,###,###.##"
set color to

if NFSCAN = "C"
  msg("* * * NOTA FISCAL CANCELADA * * *")
  return .f.
endif

M_NFSDTA = NFSDTE

return .t.

****************
function MOINF01
****************

sombra(03, 02, 20, 76,_SOMBRA_)

nbox(03, 02, 20, 76,"W/W+",.t.)
setcolor("B/W")
@ 03, 19 say     ACLI00->CLINOM
@ 04, 03 say     "                                                                         "
@ 05, 03 say     "                                                                         "
@ 06, 03 say     "                                                                         "
@ 07, 03 say     "                                                                         "
@ 08, 03 say     "                                                                         "
@ 09, 03 say     "                                                                         "
@ 10, 03 say     "                                                                         "
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
