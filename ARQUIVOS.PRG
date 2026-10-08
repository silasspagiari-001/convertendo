*****************
function ABRE_EMP
*****************

do while .t.
  veremp()                               && carrega variavel M_EMP
  if lastkey() = 27
    finaliza()
    loop
  endif
  exit
enddo

return .t.

*****************
function ABRE_PCA
*****************

parameters M_AREA

select &M_AREA

fechaexist("APCA00")

use &_PATH_\USR\ESTOQUE\APCA00 alias APCA00

if neterr()
  msg("* * * (APCA00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !pca_ntx()                              && verifica a existencia de indices
  msg("* * * (APCA00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\ESTOQUE\APCA00

return ""

*****************
function ABRE_SLD
*****************

parameter M_AREA

fechaexist("ASLD00")

select &M_AREA
 
use &_PATH_\USR\ESTOQUE\ASLD00 alias ASLD00

if neterr()
  msg("* * * (ASLD00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !sld_ntx()                              && verifica a existencia de indices
  msg("* * * (ASLD00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\ESTOQUE\ASLD00        

return ""

*****************
function ABRE_SLD10
*****************

parameter M_AREA

fechaexist("ASLD10")

select &M_AREA
 
use &_PATH_\USR\ESTOQUE\ASLD00 alias ASLD10

if neterr()
  msg("* * * (ASLD00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !sld_ntx()                              && verifica a existencia de indices
  msg("* * * (ASLD00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\ESTOQUE\ASLD00        

return ""

*****************
function ABRE_CVE
*****************

parameter M_AREA

fechaexist("ACVE00")

select &M_AREA

use &_PATH_\USR\ESTOQUE\ACVE00 alias ACVE00

if neterr()
  msg("* * * (ACVE00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !cve_ntx()                              && verifica a existencia de indices
  msg("* * * (ACVE00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\ESTOQUE\ACVE00 

return ""

*****************
function ABRE_GRP
*****************

parameter M_AREA

fechaexist("AGRP00")

select &M_AREA

use &_PATH_\USR\ESTOQUE\AGRP00 alias AGRP00

if neterr()
  msg("* * * (AGRP00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !grp_ntx()                              && verifica a existencia de indices
  msg("* * * (AGRP00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\ESTOQUE\AGRP00  

return ""

*****************
function ABRE_KAR
*****************

parameter M_AREA

fechaexist("AKAR00")

select &M_AREA

use &_PATH_\USR\ESTOQUE\AKAR00 alias AKAR00

if neterr()
    msg("* * * (AKAR00) ARQUIVO NAO DISPONIVEL * * *")
    clear
    clear all
    quit
endif

if !kar_ntx()                              
  msg("* * * (AKAR00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to  &_PATH_\USR\ESTOQUE\AKAR00 
                                           
return ""

*****************
function ABRE_FIS
*****************

parameter M_AREA

fechaexist("AFIS00")

select &M_AREA

use &_PATH_\USR\FATURA\AFIS00 alias AFIS00

if neterr()
  msg("* * * (AFIS00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !fis_ntx()                              && verifica a existencia de indices
  msg("* * * (AFIS00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\AFIS00  

return ""

*****************
function ABRE_CLI
*****************

parameter M_AREA

fechaexist("ACLI00")

select &M_AREA

use &_PATH_\USR\FATURA\ACLI00 alias ACLI00

if neterr()
  msg("* * * (ACLI00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !cli_ntx()                              && verifica a existencia de indices
  msg("* * * (ACLI00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\ACLI00 

return ""

*****************
function ABRE_DOL
*****************

parameter M_AREA

fechaexist("ADOL00")

select &M_AREA

use &_PATH_\USR\ESTOQUE\ADOL00 alias ADOL00

if neterr()
  msg("* * * (ADOL00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !dol_ntx()                              
  msg("* * * (ADOL00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\ESTOQUE\ADOL00   

return ""


*****************
function ABRE_ANO
*****************

parameter M_AREA

fechaexist("AANO00")

select &M_AREA

use &_PATH_\USR\ESTOQUE\AANO00 alias AANO00 

if neterr()
  msg("* * * (AANO00) ARQUIVO NéO DISPONIVEL * * *")
  return ""
endif

if !ano_ntx()                              && verifica a existencia de indices
  msg("* * * (AANO00) NéO CONSEGUI CRIAR OS INDICES * * *")
  return ""
endif

set index to &_PATH_\USR\ESTOQUE\AANO00  

return ""

*****************
function ABRE_CPG
*****************

parameter M_AREA

fechaexist("ACPG00")

select &M_AREA

use &_PATH_\USR\FATURA\ACPG00 alias ACPG00

if neterr()
  msg("* * * (ACPG00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !cpg_ntx()                              && verifica a existencia de indices
  msg("* * * (ACPG00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\ACPG00 

return ""

*****************
function ABRE_VEN
*****************

parameter M_AREA

fechaexist("AVEN00")

select &M_AREA

use &_PATH_\USR\FATURA\AVEN00 alias AVEN00

if neterr()
  msg("* * * (AVEN00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !ven_ntx()                              && verifica a existencia de indices
  msg("* * * (AVEN00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\AVEN00 

return ""

*****************
function ABRE_FOR
*****************

parameter M_AREA

fechaexist("AFOR00")

select &M_AREA

use &_PATH_\USR\ESTOQUE\AFOR00 alias AFOR00

if neterr()
  msg("* * * (AFOR00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !for_ntx()                              && verifica a existencia de indices
  msg("* * * (AFOR00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\ESTOQUE\AFOR00 

return ""

******************
function ABRE_NFE0
******************

parameter M_AREA

fechaexist("ANFE00")

select &M_AREA

use &_PATH_\USR\ESTOQUE\ANFE00 alias ANFE00

if neterr()
  msg("* * * (ANFE00) ARQUIVO NAO DISPONIVEL * * *")
  clear all
  clear
  quit
endif

if !nfe0_ntx()                              
  msg("* * * (ANFE00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\ESTOQUE\ANFE00 

return ""

******************
function ABRE_NFE1
******************

parameter M_AREA

fechaexist("ANFE01")

select &M_AREA

use &_PATH_\USR\ESTOQUE\ANFE01 alias ANFE01

if neterr()
  msg("* * * (ANFE01) ARQUIVO NAO DISPONIVEL * * *")
  clear all
  clear
  quit
endif

if !nfe1_ntx()                             
  msg("* * * (ANFE01) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\ESTOQUE\ANFE01  

return ""

******************
function ABRE_NFS0
******************

parameter M_AREA

fechaexist("ANFS00")

select &M_AREA

use &_PATH_\USR\FATURA\ANFS00 alias ANFS00

if neterr()
    msg("* * * (ANFS00) ARQUIVO NAO DISPONIVEL * * *")
    clear 
    clear all
    quit
endif

if !nfs0_ntx()                              && verifica a existencia de indices
  msg("* * * (ANFS00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\ANFS00 

return ""

******************
function ABRE_NFS1
******************

parameter M_AREA

fechaexist("ANFS01")

select &M_AREA

use &_PATH_\USR\FATURA\ANFS01 alias ANFS01

if neterr()
    msg("* * * (ANFS01) ARQUIVO NAO DISPONIVEL * * *")
    clear
    clear all
    quit
endif

if !nfs1_ntx()                             
  msg("* * * (ANFS01) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\ANFS01   

return ""

*****************
function ABRE_TRA
*****************

parameter M_AREA

fechaexist("ATRA00")

select &M_AREA

use &_PATH_\USR\FATURA\ATRA00 alias ATRA00

if neterr()
  msg("* * * (ATRA00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !tra_ntx()                              && verifica a existencia de indices
  msg("* * * (ATRA00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\ATRA00 

return ""

*****************
function ABRE_POR
*****************

parameter M_AREA

fechaexist("APOR00")

select &M_AREA

use &_PATH_\USR\CONREC\APOR00 alias APOR00

if neterr()
  msg("* * * (APOR00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !por_ntx()                              && verifica a existencia de indices
  msg("* * * (APOR00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\CONREC\APOR00  

return ""

*****************
function ABRE_CHE
*****************

parameter M_AREA

fechaexist("ACHE00")

select &M_AREA

use &_PATH_\USR\BANCO\ACHE00 alias ACHE00 

if neterr()
   msg("* * * (ACHE00) ARQUIVO NAO DISPONIVEL * * *")
   return ""
endif

if !che_ntx()                              && verifica a existencia de indices
  msg("* * * (ACHE00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\BANCO\ACHE00 

return ""

*****************
function ABRE_CTA
*****************

parameter M_AREA

fechaexist("ACTA00")

select &M_AREA

use &_PATH_\USR\BANCO\ACTA00 alias ACTA00 

if neterr()
   msg("* * * (ACTA00) ARQUIVO NAO DISPONIVEL * * *")
   return ""
endif

if !cta_ntx()                              && verifica a existencia de indices
  msg("* * * (ACTA00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\BANCO\ACTA00 

return ""

*****************
function ABRE_LAB
*****************

parameter M_AREA

fechaexist("ALAB00")

select &M_AREA

use &_PATH_\USR\BANCO\ALAB00 alias ALAB00 

if neterr()
  msg("* * * (ALAB00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !lab_ntx()                              && verifica a existencia de indices
  msg("* * * (ALAB00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\BANCO\ALAB00 

return ""


*****************
function ABRE_LAP
*****************

parameter M_AREA

fechaexist("ALAP00")

select &M_AREA

use &_PATH_\USR\BANCO\ALAP00 alias ALAP00 

if neterr()
  msg("* * * (ALAP00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !lap_ntx()                              && verifica a existencia de indices
  msg("* * * (ALAP00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\BANCO\ALAP00 

return ""

*****************
function ABRE_HIB
*****************

parameter M_AREA

fechaexist("AHIS00")

select &M_AREA

use &_PATH_\USR\BANCO\AHIS00 alias AHIS00                && historicos

if neterr()
  msg("* * * (AHIS00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !hib_ntx()                              && verifica a existencia de indices
  msg("* * * (AHIS00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\BANCO\AHIS00

return ""

*****************
function ABRE_DCP
*****************

parameter M_AREA

fechaexist("ADCP00")

select &M_AREA

use &_PATH_\USR\CONPAG\ADCP00 alias ADCP00

if neterr()
  msg("* * * (ADCP00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !dcp_ntx()                              && verifica a existencia de indices
  msg("* * * (ADCP00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\CONPAG\ADCP00 

return ""

*****************
function ABRE_LCP
*****************

parameter M_AREA

fechaexist("ALCP00")

select &M_AREA

use &_PATH_\USR\CONPAG\ALCP00 alias ALCP00

if neterr()
  msg("* * * (ALCP00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !lcp_ntx()                              && verifica a existencia de indices
  msg("* * * (ALCP00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\CONPAG\ALCP00 

return ""

*****************
function ABRE_LOG
*****************

parameter M_AREA

fechaexist("ALOG10")

select &M_AREA

use &_PATH_\USR\ESTOQUE\ALOG10 alias ALOG10

if neterr()
  msg("* * * (ALOG10) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !log_ntx()   
  msg("* * * (ALOG10) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\ESTOQUE\ALOG10

return ""

*****************
function ABRE_MCR
*****************

parameter M_AREA

fechaexist("AMOV00")

select &M_AREA

use &_PATH_\USR\CONREC\AMOV00 alias AMOV00R

if neterr()
  msg("* * * (AMOV00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !mcr_ntx()                              && verifica a existencia de indices
  msg("* * * (AMOV00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\CONREC\AMOV00 

return ""

*****************
function ABRE_MCP
*****************

parameter M_AREA

fechaexist("AMOV00")

select &M_AREA

use &_PATH_\USR\CONPAG\AMOV00 alias AMOV00P

if neterr()
  msg("* * * (AMOV00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !mcp_ntx()                              && verifica a existencia de indices
  msg("* * * (AMOV00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\CONPAG\AMOV00 

return ""

*****************
function ABRE_DCR
*****************

parameter M_AREA

fechaexist("ADCR00")

select &M_AREA

use &_PATH_\USR\CONREC\ADCR00 alias ADCR00

if neterr()
  msg("* * * (ADCR00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !dcr_ntx()                              && verifica a existencia de indices
  msg("* * * (ADCR00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\CONREC\ADCR00  


return ""

*****************
function ABRE_RET
*****************

parameter M_AREA

fechaexist("ARET00")

select &M_AREA

use &_PATH_\USR\CONREC\ARET00 alias ARET00 exclusive

if neterr()
  msg("* * * (ARET00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

return ""



*****************
function ABRE_SCI0
*****************

parameter M_AREA

fechaexist("ASCI00")

select &M_AREA

use &_PATH_\USR\CONREC\ASCI00 alias ASCI00 exclusive

if neterr()
  msg("* * * (ASCI00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

return ""

*****************
function ABRE_SCI1
*****************

parameter M_AREA

fechaexist("ASCI01")

select &M_AREA

use &_PATH_\USR\CONREC\ASCI01 alias ASCI01 exclusive

if neterr()
  msg("* * * (ASCI00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

return ""

*****************
function ABRE_LCR
*****************

parameter M_AREA

fechaexist("ALCR00")

select &M_AREA

use &_PATH_\USR\CONREC\ALCR00 alias ALCR00

if neterr()
  msg("* * * (ALCR00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !lcr_ntx()                         
  msg("* * * (ALCR00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\CONREC\ALCR00 

return ""

*****************
function ABRE_BCR
*****************

parameter M_AREA

fechaexist("ABCR00")

select &M_AREA

use &_PATH_\USR\CONREC\ABCR00 alias ABCR00

if neterr()
  msg("* * * (ABCR00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !bcr_ntx()
  msg("* * * (ABCR00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\CONREC\ABCR00 

return ""

*****************
function ABRE_BCP
*****************

parameter M_AREA

fechaexist("ABCP00")

select &M_AREA

use &_PATH_\USR\CONPAG\ABCP00 alias ABCP00

if neterr()
  msg("* * * (ABCP00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !bcp_ntx()                              && verifica a existencia de indices
  msg("* * * (ABCP00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\CONPAG\ABCP00 

return ""

*****************
function ABRE_PCH
*****************

parameter M_AREA

fechaexist("APCH00")

select &M_AREA

use &_PATH_\USR\BANCO\APCH00 alias APCH00

if neterr()
  msg("* * * (APCH00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !pch_ntx()                              && verifica a existencia de indices
  msg("* * * (APCH00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\BANCO\APCH00 

return ""

*****************
function ABRE_PAR
*****************

parameter M_AREA

fechaexist("APAR00")

select &M_AREA

use &_PATH_\USR\LIVRO\APAR00 alias APAR00

if neterr()
  msg("* * * (APAR00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !par_ntx()   
  msg("* * * (APAR00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\LIVRO\APAR00

return ""

*****************
function ABRE_FIN
*****************

parameter M_AREA

fechaexist("AFIN00")

select &M_AREA

use &_PATH_\USR\LIVRO\AFIN00 alias AFIN00

if neterr()
  msg("* * * (AFIN00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !fin_ntx()   
  msg("* * * (AFIN00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\LIVRO\AFIN00

return ""

******************
function ABRE_PED0
******************

parameter M_AREA

fechaexist("APED00")

select &M_AREA

use &_PATH_\USR\FATURA\APED00 alias APED00

if neterr()
    msg("* * * (APED00) ARQUIVO NAO DISPONIVEL * * *")
    clear 
    clear all
    quit
endif

if !ped0_ntx()                              && verifica a existencia de indices
  msg("* * * (APED00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\APED00 

return ""

******************
function ABRE_PED1
******************

parameter M_AREA

fechaexist("APED01")

select &M_AREA

use &_PATH_\USR\FATURA\APED01 alias APED01

if neterr()
    msg("* * * (APED01) ARQUIVO NAO DISPONIVEL * * *")
    clear
    clear all
    quit
endif

if !ped1_ntx()                             
  msg("* * * (APED01) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\APED01   

return ""

******************
function ABRE_REQ0
******************

parameter M_AREA

fechaexist("AREQ00")

select &M_AREA

use &_PATH_\USR\FATURA\AREQ00 alias AREQ00

if neterr()
    msg("* * * (AREQ00) ARQUIVO NAO DISPONIVEL * * *")
    clear 
    clear all
    quit
endif

if !req0_ntx()                              && verifica a existencia de indices
  msg("* * * (AREQ00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\AREQ00  

return ""

******************
function ABRE_REQ1
******************

parameter M_AREA

fechaexist("AREQ01")

select &M_AREA

use &_PATH_\USR\FATURA\AREQ01 alias AREQ01

if neterr()
    msg("* * * (AREQ01) ARQUIVO NAO DISPONIVEL * * *")
    clear
    clear all
    quit
endif

if !req1_ntx()                             
  msg("* * * (AREQ01) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\AREQ01   

return ""

********************
function ABRE_REQ0TM
********************

parameter M_AREA

fechaexist("AREQ00TM")

select &M_AREA

use &_PATH_\USR\FATURA\AREQ00 alias AREQ00TM

if neterr()
    msg("* * * (AREQ00) ARQUIVO NAO DISPONIVEL * * *")
    clear 
    clear all
    quit
endif

if !req0_ntx()                              && verifica a existencia de indices
  msg("* * * (AREQ00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\AREQ00  

return ""

********************
function ABRE_REQ1TM
********************

parameter M_AREA

fechaexist("AREQ01TM")

select &M_AREA

use &_PATH_\USR\FATURA\AREQ01 alias AREQ01TM

if neterr()
    msg("* * * (AREQ01) ARQUIVO NAO DISPONIVEL * * *")
    clear
    clear all
    quit
endif

if !req1_ntx()                             
  msg("* * * (AREQ01) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\AREQ01   

return ""

*****************
function ABRE_PEN
*****************

parameter M_AREA

fechaexist("APEN00")

select &M_AREA

use &_PATH_\USR\FATURA\APEN00 alias APEN00

if neterr()
  msg("* * * (APEN00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !pen_ntx()   
  msg("* * * (APEN00) NAO CONSIGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\APEN00 

return ""

*****************
function ABRE_ETQ
*****************

parameter M_AREA

fechaexist("AETQ00")

select &M_AREA

use &_PATH_\USR\FATURA\AETQ00 alias AETQ00

if neterr()
  msg("* * * (AETQ00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !etq_ntx()                              && verifica a existencia de indices
  msg("* * * (AETQ00) NAO CONSIGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\AETQ00 

return ""

*****************
function ABRE_GRU
*****************

parameters M_AREA

fechaexist("AGRP00")

select &M_AREA

use &_PATH_\USR\CONREC\AGRP00 exclusive alias AGRP00

if neterr()
  msg("* * * (AGRP00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

zap

delete file &_PATH_\USR\CONREC\AGRP00.NTX

if !gru_ntx()                              && verifica a existencia de indices
  msg("* * * (AGRP00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\CONREC\AGRP00

return ""

*****************
function ABRE_PRD
*****************

parameter M_AREA

fechaexist("APRD00")

select &M_AREA

use &_PATH_\USR\BANCO\APRD00 alias APRD00

if neterr()
  msg("* * * (APRD00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !prd_ntx()                              && verifica a existencia de indices
  msg("* * * (APRD00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\BANCO\APRD00 

return ""


*****************
function ABRE_TEL
*****************

parameters M_AREA

fechaexist("ATEL00")

select &M_AREA

use &_PATH_\USR\FATURA\ATEL00 alias ATEL00

if neterr()
  msg("* * * (ATEL00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !tel_ntx()                              && verifica a existencia de indices
  msg("* * * (ATEL00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\ATEL00 

return ""

*****************
function ABRE_AGE
*****************

parameter M_AREA

fechaexist("AAGE00")

select &M_AREA

use &_PATH_\USR\FATURA\AAGE00 alias AAGE00

if neterr()
  msg("* * * (AAGE00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !age_ntx()                              && verifica a existencia de indices
  msg("* * * (AAGE00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\AAGE00

return ""

*****************
function ABRE_PLX
*****************

parameter M_AREA

fechaexist("APLX00")

select &M_AREA

use &_PATH_\USR\FLUXO\APLX00 alias APLX00 

if neterr()
   msg("* * * (APLX00) ARQUIVO NAO DISPONIVEL * * *")
   return ""
endif

if !plx_ntx()  
  msg("* * * (APLX00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FLUXO\APLX00 

return ""

*****************
function ABRE_HIX
*****************

parameter M_AREA

fechaexist("AHIX00")

select &M_AREA

use &_PATH_\USR\FLUXO\AHIX00 alias AHIX00 

if neterr()
   msg("* * * (AHIX00) ARQUIVO NAO DISPONIVEL * * *")
   return ""
endif

if !hix_ntx()  
  msg("* * * (AHIX00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FLUXO\AHIX00 

return ""

*****************
function ABRE_LAX
*****************

parameter M_AREA

fechaexist("ALAX00")

select &M_AREA

use &_PATH_\USR\FLUXO\ALAX00 alias ALAX00 

if neterr()
  msg("* * * (ALAX00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !lax_ntx()                              && verifica a existencia de indices
  msg("* * * (ALAX00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FLUXO\ALAX00

return ""

*****************
function ABRE_BAM
*****************

parameter M_AREA

fechaexist("ABAM00")

select &M_AREA

use &_PATH_\USR\CONREC\ABAM00 alias ABAM00 exclusive

if neterr()
  msg("* * * (ABAM00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

return ""

*****************
function ABRE_SIL
*****************

parameter M_AREA

fechaexist("ASIL00")

select &M_AREA

use &_PATH_\USR\CONREC\ASIL00 alias ASIL00 exclusive

if neterr()
  msg("* * * (ASIL00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

return ""

*****************
function ABRE_BAN
*****************

parameter M_AREA

fechaexist("ABAN00")

select &M_AREA

if file("&_PATH_\USR\CONREC\ABAN00.CDX")
  erase("&_PATH_\USR\CONREC\ABAN00.CDX")
endif

use &_PATH_\USR\CONREC\ABAN00 alias ABAN00 exclusive

if neterr()
  msg("* * * (ABAN00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

return ""

*****************
function ABRE_BCO
*****************

parameter M_AREA

fechaexist("ABCO00")

select &M_AREA

use &_PATH_\USR\BANCO\ABCO00 alias ABCO00 

if neterr()
  msg("* * * (ABCO00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !bco_ntx()                              && verifica a existencia de indices
  msg("* * * (ABCO00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\BANCO\ABCO00

return ""

*****************
function CRIA_TMP
*****************

parameters M_ARQTMP

local MT_STR := {}

set exclusive on

  aadd(MT_STR, {"NFSEMP","N",  2, 0}) 
  aadd(MT_STR, {"NFSMAT","N",  6, 0})
  aadd(MT_STR, {"NFSQDE","N",  9, 3})
  aadd(MT_STR, {"NFSVIS","N", 14, 2})
  aadd(MT_STR, {"NFSPRZ","N", 14, 2})
  aadd(MT_STR, {"NFSVLN","N", 14, 2})
  aadd(MT_STR, {"NFSGRP","N",  4, 0})
  aadd(MT_STR, {"NFSMUN","C", 20, 0})
  aadd(MT_STR, {"NFSCLI","N",  7, 0})
  aadd(MT_STR, {"CLICOD","N",  7, 0})
  aadd(MT_STR, {"CLIVIS","N", 14, 2})
  aadd(MT_STR, {"CLIPRZ","N", 14, 2})
  aadd(MT_STR, {"CLITOT","N", 14, 2})
  aadd(MT_STR, {"FISCOD","N",  5, 0})
  aadd(MT_STR, {"FISVIS","N", 14, 2})
  aadd(MT_STR, {"FISPRZ","N", 14, 2})
  aadd(MT_STR, {"FISOUT","N", 14, 2})
  aadd(MT_STR, {"NFSULC","D",  8, 0})
  aadd(MT_STR, {"NFSDTE","D",  8, 0})
  aadd(MT_STR, {"NFSVEN","N",  3, 0})
  aadd(MT_STR, {"NFSVLI","N", 14, 2})
  aadd(MT_STR, {"NFSUQT","N",  9, 3})
  aadd(MT_STR, {"NFSNUM","N",  6, 0})
  aadd(MT_STR, {"NFSSER","C",  2, 0})
  aadd(MT_STR, {"NFSNAT","N",  5, 0})
  aadd(MT_STR, {"NFSOUT","N", 14, 2})
  aadd(MT_STR, {"NFSOBS","C", 73, 0})

  dbcreate("&M_ARQTMP",MT_STR)

set exclusive off

return ""

******************
function ABRE_LFS && livro fiscal saida
******************

parameter M_AREA

fechaexist("ALFS00")

select &M_AREA

use &_PATH_\USR\LIVRO\ALFS00 alias ALFS00 exclusive

if neterr()
  msg("* * * (ALFS00) ARQUIVO NAO DISPONIVEL * * *")
  clear all
  clear
  quit
endif

return ""

******************
function ABRE_LFE && livro fiscal entrada
******************

parameter M_AREA

fechaexist("ALFE00")

select &M_AREA

use &_PATH_\USR\LIVRO\ALFE00 alias ALFE00 exclusive

if neterr()
  msg("* * * (ALFE00) ARQUIVO NAO DISPONIVEL * * *")
  clear all
  clear
  quit
endif

return ""


******************
function ABRE_RIE && resumo icms entrada 
******************

parameter M_AREA

fechaexist("ARIE00")

select &M_AREA

use &_PATH_\USR\LIVRO\ARIE00 alias ARIE00 exclusive

if neterr()
  msg("* * * (ARIE00) ARQUIVO NAO DISPONIVEL * * *")
  clear all
  clear
  quit
endif

return ""

******************
function ABRE_RIS && resumo icms entrada 
******************

parameter M_AREA

fechaexist("ARIS00")

select &M_AREA

use &_PATH_\USR\LIVRO\ARIS00 alias ARIS00 exclusive

if neterr()
  msg("* * * (ARIS00) ARQUIVO NAO DISPONIVEL * * *")
  clear all
  clear
  quit
endif

return ""

******************
function ABRE_APX && sintetivo aplicacao fluxo de caixa
******************

parameter M_AREA

fechaexist("AAPX00")

select &M_AREA

if file("&_PATH_\USR\FLUXO\AAPX00.CDX")
  erase("&_PATH_\USR\FLUXO\AAPX00.CDX")
endif

use &_PATH_\USR\FLUXO\AAPX00 alias AAPX00 exclusive

if neterr()
  msg("* * * (AAPX00) ARQUIVO NAO DISPONIVEL * * *")
  clear all
  clear
  quit
endif

return ""

*****************
function ABRE_NCN
*****************

parameter M_AREA

fechaexist("ANCN00")

select &M_AREA

use &_PATH_\USR\CONREC\ANCN00 alias ANCN00 exclusive

if neterr()
  msg("* * * (ANCN00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

return ""

*****************
function ABRE_BTD
*****************

parameter M_AREA

fechaexist("ABTD00")

select &M_AREA

use &_PATH_\USR\CONREC\ABTD00 alias ABTD00 exclusive

if neterr()
  msg("* * * (ABTD00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

return ""

*****************
function ABRE_DGR
*****************

parameter M_AREA

fechaexist("ADGR00")

select &M_AREA

use &_PATH_\USR\CONREC\ADGR00 alias ADGR00 exclusive

if neterr()
  msg("* * * (ADGR00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

return ""

******************
function ABRE_ORC0
******************

parameter M_AREA

fechaexist("AORC00")

select &M_AREA

use &_PATH_\USR\FATURA\AORC00 alias AORC00

if neterr()
    msg("* * * (AORC00) ARQUIVO NAO DISPONIVEL * * *")
    clear 
    clear all
    quit
endif

if !orc0_ntx()                              && verifica a existencia de indices
  msg("* * * (AORC00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\AORC00 

return ""

******************
function ABRE_ORC1
******************

parameter M_AREA

fechaexist("AORC01")

select &M_AREA

use &_PATH_\USR\FATURA\AORC01 alias AORC01

if neterr()
    msg("* * * (AORC01) ARQUIVO NAO DISPONIVEL * * *")
    clear
    clear all
    quit
endif

if !orc1_ntx()                             
  msg("* * * (AORC01) NAO CONSIGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\AORC01   

return ""

*****************
function ABRE_TAD
*****************

parameters M_AREA

fechaexist("PORTADOR")

select &M_AREA

use &_PATH_\USR\BANCO\PORTADOR alias PORTADOR

if neterr()
  msg("* * * (PORTADOR) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !pta_ntx()                              && verifica a existencia de indices
  msg("* * * (PORTADOR) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\BANCO\PORTADOR

return ""

*******************
function FECHAEXIST
*******************

local A
parame F_ABREARQUIVO

if select(F_ABREARQUIVO) > 0
  select &F_ABREARQUIVO
  use
endif

return .t.

********************
function ABRE_NFSCAN
********************

parameter M_AREA

fechaexist("ANFSCAN")

select &M_AREA

use &_PATH_\USR\FATURA\ANFSCAN alias ANFSCAN

if neterr()
    msg("* * * (ANFSCAN) ARQUIVO NAO DISPONIVEL * * *")
    clear 
    clear all
    quit
endif

if !can_ntx()                              && verifica a existencia de indices
  msg("* * * (ANFSCAN) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\ANFSCAN 

return ""

********************
function ABRE_CLIMOR
********************

parameter M_AREA

fechaexist("ACLMOR")

select &M_AREA

use &_PATH_\USR\FATURA\ACLMOR alias ACLMOR

if neterr()
  msg("* * * (ACLMOR) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !climor_ntx()                              && verifica a existencia de indices
  msg("* * * (ACLMOR) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\ACLMOR 

return ""

********************
function ABRE_FORMOR
********************

parameter M_AREA

fechaexist("AFOMOR")

select &M_AREA

use &_PATH_\USR\ESTOQUE\AFOMOR alias AFOMOR

if neterr()
  msg("* * * (AFOMOR) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !formor_ntx()                              && verifica a existencia de indices
  msg("* * * (AFOMOR) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\ESTOQUE\AFOMOR 

return ""

*****************
function ABRE_PCAMOR
*****************

parameters M_AREA

select &M_AREA

fechaexist("APCMOR")

use &_PATH_\USR\ESTOQUE\APCMOR alias APCMOR

if neterr()
  msg("* * * (APCMOR) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !pcamor_ntx()                              && verifica a existencia de indices
  msg("* * * (APCMOR) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\ESTOQUE\APCMOR

return ""


*****************
function ALIASPCA
*****************

parameters M_AREA

select &M_AREA

fechaexist("APCMOR")

use &_PATH_\USR\ESTOQUE\APCMOR alias APCA00

if neterr()
  msg("* * * (APCMOR) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !pcamor_ntx()                              && verifica a existencia de indices
  msg("* * * (APCMOR) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\ESTOQUE\APCMOR

return ""

*****************
function ALIASFOR
*****************

parameter M_AREA

fechaexist("AFOMOR")

select &M_AREA

use &_PATH_\USR\ESTOQUE\AFOMOR alias AFOR00

if neterr()
  msg("* * * (AFOMOR) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !formor_ntx()                              && verifica a existencia de indices
  msg("* * * (AFOMOR) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\ESTOQUE\AFOMOR 

return ""

*****************
function ALIASCLI
*****************

parameter M_AREA

fechaexist("ACLMOR")

select &M_AREA

use &_PATH_\USR\FATURA\ACLMOR alias ACLI00

if neterr()
  msg("* * * (ACLMOR) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !climor_ntx()                              && verifica a existencia de indices
  msg("* * * (ACLMOR) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\ACLMOR 

return ""

*****************
function ABRE_TIP
*****************

parameter M_AREA

fechaexist("ATIP00")

select &M_AREA

use &_PATH_\USR\FATURA\ATIP00 alias ATIP00

if neterr()
  msg("* * * (ATIP00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !tip_ntx()                              && verifica a existencia de indices
  msg("* * * (ATIP00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\ATIP00 

return ""

*****************
function ABRE_MUN   && Munic°pios
*****************

parameter M_AREA

select &M_AREA

use &_PATH_\USR\FATURA\AMUN00 alias AMUN00

if neterr()
  msg("* * * (AMUN00) Arquivo n∆o dispon°vel * * *")
  clear
  clear all
  quit
endif

if !mun_ntx()           && verifica a existencia de indices
  msg("* * * (AMUN00) N∆o consegui criar os °ndices * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\AMUN00

return ""

******************
function ABRE_CUP0
******************

parameter M_AREA

fechaexist("ACUP00")

select &M_AREA

use &_PATH_\USR\FATURA\ACUP00 alias ACUP00

if neterr()
    msg("* * * (ACUP00) ARQUIVO NAO DISPONIVEL * * *")
    clear 
    clear all
    quit
endif

if !cup0_ntx()                              && verifica a existencia de indices
  msg("* * * (ACUP00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\ACUP00  

return ""

******************
function ABRE_CUP1
******************

parameter M_AREA

fechaexist("ACUP01")

select &M_AREA

use &_PATH_\USR\FATURA\ACUP01 alias ACUP01

if neterr()
    msg("* * * (ACUP01) ARQUIVO NAO DISPONIVEL * * *")
    clear
    clear all
    quit
endif

if !cup1_ntx()                             
  msg("* * * (ACUP01) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\ACUP01   

return ""

******************
function ABRE_TNF0   // Temporario notas fiscais de entrada e saida
******************

parameter M_AREA

if !file("C:\CIRUR\ATNF00.DBF")
  cria_tnf() // Cria o arquivo temporario
endif

fechaexist("ATNF00")

if file("C:\CIRUR\ATNF00.CDX")
  delete file C:\CIRUR\ATNF00.CDX
endif

select &M_AREA

use C:\CIRUR\ATNF00 alias ATNF00 exclusive

if neterr()
  msg("* * * (ATNF00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

return ""

*****************
function CRIA_TNF   // Cria o temporario notas fiscais
*****************

local MT_STR := {}

set exclusive on

  aadd(MT_STR, {"TNFNFS","N",  6, 0}) 
  aadd(MT_STR, {"TNFSER","C",  2, 0}) 
  aadd(MT_STR, {"TNFCLI","N",  7, 0}) 
  aadd(MT_STR, {"TNFFOR","N",  7, 0}) 
  aadd(MT_STR, {"TNFCPG","N",  3, 0}) 
  aadd(MT_STR, {"TNFVLN","N", 14, 2}) 
  aadd(MT_STR, {"TNFCFO","C",  5, 0}) 
  aadd(MT_STR, {"TNFVFO","N", 14, 2}) 
  aadd(MT_STR, {"TNFVIS","N", 14, 2})
  aadd(MT_STR, {"TNFPRZ","N", 14, 2})
  aadd(MT_STR, {"TNFOUT","N", 14, 2})
  aadd(MT_STR, {"TNFSUB","N", 14, 2})
  aadd(MT_STR, {"TNFVLS","N", 14, 2})
  aadd(MT_STR, {"TNFDTE","D",  8, 0}) 
  aadd(MT_STR, {"TNFVEN","N",  3, 0}) 
  aadd(MT_STR, {"TNFCAN","C",  1, 0}) 

  dbcreate("C:\CIRUR\ATNF00",MT_STR)

set exclusive off

return ""


******************
function ABRE_NFSEL
******************

fechaexist("ANFSEL")

select 0

use &_PATH_\USR\FATURA\ANFS00 alias ANFSEL

if neterr()
  msg("* * * (ANFS00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !file("&_PATH_\USR\FATURA\ANFS00.CDX")
  if !flock()
    return .f.
  endif

  msw("* * * CRIANDO INDICES (ANFS00) AGUARDE !!! * * *")

  index on  str(NFSEMP, 2, 0) + str(NFSNUM, 6, 0) + NFSSER                tag 1 to &_PATH_\USR\FATURA\ANFS00
  index on  str(NFSEMP, 2, 0) + dtos(NFSDTE) + str(NFSNUM, 6, 0) + NFSSER tag 2 to &_PATH_\USR\FATURA\ANFS00
  index on  str(NFSEMP, 2, 0) + dtos(NFSDTE) + NFSNATN                    tag 3 to &_PATH_\USR\FATURA\ANFS00
  index on  str(NFSEMP, 2, 0) + str(NFSCLI, 7, 0) + dtos(NFSDTE)          tag 4 to &_PATH_\USR\FATURA\ANFS00

  @ 24, 00 clear
  unlock all
  select ANFSEL
  use
  select ANFSEL
endif

set index to &_PATH_\USR\FATURA\ANFS00

return ""

******************
function ABRE_MSG2
******************

fechaexist("MENSAGE2")

select 0

use &_PATH_\USR\FATURA\MENSAGE2 alias MENSAGE2

if neterr()
  msg("* * * (MENSAGE2) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !file("&_PATH_\USR\FATURA\MENSAGE2.CDX")               && ordem 1
  if !flock()
    return .f.
  endif
  msw("* * * CRIANDO INDICES (MENSAGE2) AGUARDE !!! * * *")
  index on str(CLICOD,7) tag 1 to &_PATH_\USR\FATURA\MENSAGE2
  @  24, 00 clear
  unlock all
  select MENSAGE2
  use
  select MENSAGE2
endif

set index to &_PATH_\USR\FATURA\MENSAGE2

return ""

*****************
function ABRE_PCAFOR
*****************

fechaexist("APCFOR")

select 0

use &_PATH_\USR\ESTOQUE\APCFOR alias APCFOR

if neterr()
  msg("* * * (APCFOR) ARQQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !file("&_PATH_\USR\ESTOQUE\APCFOR.CDX")
  if !flock()
    return .f.
  endif
  msw("* * * CRIANDO INDICES (APCFOR) AGUARDE !!! * * *")

  index on str(PCAMAT,6) 			     tag 1 to &_PATH_\USR\ESTOQUE\APCFOR
  index on str(PCAMAT,6) + str(PCAFOR,5) + PCACODFOR tag 2 to &_PATH_\USR\ESTOQUE\APCFOR
  index on PCACODFOR  			   	     tag 3 to &_PATH_\USR\ESTOQUE\APCFOR
  unlock all
  select APCFOR
  use
  select APCFOR
  @ 24, 00 clear
endif

set index to &_PATH_\USR\ESTOQUE\APCFOR

return ""

*****************
function ABRE_BOL // abre ADCR00 para pesquisa boleto
*****************

fechaexist("ADCBOL")

select 0

use &_PATH_\USR\CONREC\ADCR00 alias ADCBOL

if neterr()
  msg("* * * (ADCR00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !dcr_ntx()                              && verifica a existencia de indices
  msg("* * * (ADCR00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\CONREC\ADCR00  

return ""

*****************
function ABRE_IND
*****************

parameter M_AREA

fechaexist("AIND00")

select &M_AREA

use &_PATH_\USR\FATURA\AIND00 alias AIND00

if neterr()
  msg("* * * (AIND00) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !ind_ntx()                              && verifica a existencia de indices
  msg("* * * (AIND00) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\FATURA\AIND00 

return ""


*****************
function ABRE_CONFIG
*****************

parameters M_AREA
select &M_AREA

fechaexist("ACONFIG")

use &_PATH_\USR\ESTOQUE\ACONFIG

if neterr()
  msg("* * * (ACONFIG) ARQUIVO NAO DISPONIVEL * * *")
  clear
  clear all
  quit
endif

if !config_ntx()                              && verifica a existencia de indices
  msg("* * * (ACONFIG) NAO CONSEGUI CRIAR OS INDICES * * *")
  clear
  clear all
  quit
endif

set index to &_PATH_\USR\ESTOQUE\ACONFIG

return ""
