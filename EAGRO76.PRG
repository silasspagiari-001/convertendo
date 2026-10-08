***************
function MANIDX
***************

  private M_TELA

  rodape("RETIRA","REORGANIZA",M_FAN,"EAGRO76","Mem: " + str(memory(0), 5),M_EMP) 

  M_TELA =  savescreen(06, 20, 21, 70) 

 nbox(06, 16, 18, 62,"W/W+",.t.)
 setcolor("B/W")
     @ 07, 17 say  "         REORGANIZACAO DOS ARQUIVOS          "
     @ 08, 17 say  "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
     @ 09, 17 say  "           *** A T E N C A O ***             "
     @ 10, 17 say  "                                             "
     @ 11, 17 say  " Este processo reorganiza os Banco de Dados, "
     @ 12, 17 say  " elemina todos os registros  em branco e faz "
     @ 13, 17 say  " compacta‡„o de dados. Quando for sistema de "
     @ 14, 17 say  " REDE todos os terminais dever„o  estar fora "
     @ 15, 17 say  " do sistema.  Caso  contr rio  poder   haver "
     @ 16, 17 say  " perda de dados.                             "
     @ 17, 17 say  "                                             "
   set color to

   M_OPC = decide("Confirma inicio da retirada")
  
   if M_OPC != 1
     msg("* * * NADA FOI EFETUADO * * *")
     restscreen(06, 20, 21, 70, M_TELA) 
     return ""
   endif

   close database

   *
   ** retira indices do estoque
   *

   msw("* * * RETIRANDO INDICES ESTOQUE * * *")

   declare MT_ARQ[adir("&_path_\usr\estoque\*.ntx")]

   adir("&_path_\usr\estoque\*.ntx",MT_ARQ)

   M_ARQ = adir("&_path_\usr\estoque\*.ntx")

   for R = 1 to M_ARQ
     M_FILE =  "&_path_\usr\estoque\" + alltrim(MT_ARQ[R])
     delete file &M_FILE
   next 

   declare MT_ARQ[adir("&_path_\usr\estoque\*.dbf")]

   adir("&_path_\usr\estoque\*.dbf",MT_ARQ)

   M_ARQ = adir("&_path_\usr\estoque\*.dbf")

   for R = 1 to M_ARQ
     M_FILE =  "&_path_\usr\estoque\" + alltrim(MT_ARQ[R])
     use &M_FILE exclusive
     if upper(right(M_FILE, 10)) = "AKAR00.DBF"
       delete all for KAREMP = 0
     endif
     pack
   next 

   *
   ** retira indices do faturamento
   *

   msw("* * * RETIRANDO INDICES FATURAMENTO * * *")

   declare MT_ARQ[adir("&_path_\usr\fatura\*.ntx")]

   adir("&_path_\usr\fatura\*.ntx",MT_ARQ)

   M_ARQ = adir("&_path_\usr\fatura\*.ntx")

   for R = 1 to M_ARQ
     M_FILE =  "&_path_\usr\fatura\" + alltrim(MT_ARQ[R])
     delete file &M_FILE
   next 

   declare MT_ARQ[adir("&_path_\usr\fatura\*.dbf")]

   adir("&_path_\usr\fatura\*.dbf",MT_ARQ)

   M_ARQ = adir("&_path_\usr\fatura\*.dbf")

   for R = 1 to M_ARQ
     M_FILE =  "&_path_\usr\fatura\" + alltrim(MT_ARQ[R])
     if upper(right(M_FILE, 10)) = "ATEL00.DBF"
        loop
     endif 
     use &M_FILE exclusive
     if upper(right(M_FILE, 10)) = "APED00.DBF"
       delete all for PEDEMP = 0
     endif
     if upper(right(M_FILE, 10)) = "APED01.DBF"
       delete all for PEDEMP = 0
     endif
     if upper(right(M_FILE, 10)) = "APRE00.DBF"
       delete all for PREEMP = 0
     endif
     if upper(right(M_FILE, 10)) = "APRE01.DBF"
       delete all for PREEMP = 0
     endif
     if upper(right(M_FILE, 10)) = "ANFS00.DBF"
       delete all for NFSEMP = 0
     endif
     if upper(right(M_FILE, 10)) = "ANFS01.DBF"
       delete all for NFSEMP = 0
     endif
     pack
   next 

   *
   ** retira indices do contas a pagar
   *

   msw("* * * RETIRANDO INDICES CONTAS A PAGAR * * *")

   declare MT_ARQ[adir("&_path_\usr\conpag\*.ntx")]

   adir("&_path_\usr\conpag\*.ntx",MT_ARQ)

   M_ARQ = adir("&_path_\usr\conpag\*.ntx")

   for R = 1 to M_ARQ
     M_FILE =  "&_path_\usr\conpag\" + alltrim(MT_ARQ[R])
     delete file &M_FILE
   next 

   declare MT_ARQ[adir("&_path_\usr\conpag\*.dbf")]

   adir("&_path_\usr\conpag\*.dbf",MT_ARQ)

   M_ARQ = adir("&_path_\usr\conpag\*.dbf")

   for R = 1 to M_ARQ
     M_FILE =  "&_path_\usr\conpag\" + alltrim(MT_ARQ[R])
     use &M_FILE exclusive
     pack
   next 

   *
   ** retira indices do contas a receber
   *

   msw("* * * RETIRANDO INDICES CONTAS A RECEBER * * *")

   declare MT_ARQ[adir("&_path_\usr\conrec\*.ntx")]

   adir("&_path_\usr\conrec\*.ntx",MT_ARQ)

   M_ARQ = adir("&_path_\usr\conrec\*.ntx")

   for R = 1 to M_ARQ
     M_FILE =  "&_path_\usr\conrec\" + alltrim(MT_ARQ[R])
     delete file &M_FILE
   next 

   declare MT_ARQ[adir("&_path_\usr\conrec\*.dbf")]

   adir("&_path_\usr\conrec\*.dbf",MT_ARQ)

   M_ARQ = adir("&_path_\usr\conrec\*.dbf")

   for R = 1 to M_ARQ
     M_FILE =  "&_path_\usr\conrec\" + alltrim(MT_ARQ[R])
     use &M_FILE exclusive
     pack
   next 


   *
   ** retira indices do banco
   *

   msw("* * * RETIRANDO INDICES BANCO * * *")

   declare MT_ARQ[adir("&_path_\usr\banco\*.ntx")]

   adir("&_path_\usr\banco\*.ntx",MT_ARQ)

   M_ARQ = adir("&_path_\usr\banco\*.ntx")

   for R = 1 to M_ARQ
     M_FILE =  "&_path_\usr\banco\" + alltrim(MT_ARQ[R])
     delete file &M_FILE
   next 

   declare MT_ARQ[adir("&_path_\usr\banco\*.dbf")]

   adir("&_path_\usr\banco\*.dbf",MT_ARQ)

   M_ARQ = adir("&_path_\usr\banco\*.dbf")

   for R = 1 to M_ARQ
     M_FILE =  "&_path_\usr\banco\" + alltrim(MT_ARQ[R])
     use &M_FILE exclusive
     pack
   next 

   *
   ** retira indices do fluxo
   *

   msw("* * * RETIRANDO INDICES FLUXO * * *")

   declare MT_ARQ[adir("&_path_\usr\fluxo\*.ntx")]

   adir("&_path_\usr\fluxo\*.ntx",MT_ARQ)

   M_ARQ = adir("&_path_\usr\fluxo\*.ntx")

   for R = 1 to M_ARQ
     M_FILE =  "&_path_\usr\fluxo\" + alltrim(MT_ARQ[R])
     delete file &M_FILE
   next 

   declare MT_ARQ[adir("&_path_\usr\fluxo\*.dbf")]

   adir("&_path_\usr\fluxo\*.dbf",MT_ARQ)

   M_ARQ = adir("&_path_\usr\fluxo\*.dbf")

   for R = 1 to M_ARQ
     M_FILE =  "&_path_\usr\fluxo\" + alltrim(MT_ARQ[R])
     use &M_FILE exclusive
     pack
   next 

   *
   ** retira indices do livro
   *

   msw("* * * RETIRANDO INDICES LIVRO * * *")

   declare MT_ARQ[adir("&_path_\usr\livro\*.ntx")]

   adir("&_path_\usr\livro\*.ntx",MT_ARQ)

   M_ARQ = adir("&_path_\usr\livro\*.ntx")

   for R = 1 to M_ARQ
     M_FILE =  "&_path_\usr\livro\" + alltrim(MT_ARQ[R])
     delete file &M_FILE
   next 

   declare MT_ARQ[adir("&_path_\usr\livro\*.dbf")]

   adir("&_path_\usr\livro\*.dbf",MT_ARQ)

   M_ARQ = adir("&_path_\usr\livro\*.dbf")

   for R = 1 to M_ARQ
     M_FILE =  "&_path_\usr\livro\" + alltrim(MT_ARQ[R])
     use &M_FILE exclusive
     pack
   next 

   fecha_arq()
 
   msg("* * * FIM DO PROCESSO * * *")

   restscreen(06, 20, 21, 70, M_TELA) 

return ""

