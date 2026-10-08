****************
function EMP_NTX
****************

  if !file("&_PATH_\USR\ESTOQUE\AEMP00.CDX")
    if !flock()
      return .f.
    endif
    index on str(EMPCOD, 2, 0) tag 1 to &_PATH_\USR\ESTOQUE\AEMP00
    unlock all
  endif

return .t.

****************
function CLI_NTX
****************
 
  if !file("&_PATH_\USR\FATURA\ACLI00.CDX")               && ordem 1
    if !flock()
      return .f.
    endif
    index on str(CLICOD, 7, 0) tag 1 to &_PATH_\USR\FATURA\ACLI00
    index on CLINOM            tag 2 to &_PATH_\USR\FATURA\ACLI00
    index on CLICGC1           tag 3 to &_PATH_\USR\FATURA\ACLI00
    index on CLIMUN1           tag 4 to &_PATH_\USR\FATURA\ACLI00
    index on CLIMUN2 + CLINOM  tag 5 to &_PATH_\USR\FATURA\ACLI00
    unlock all
  endif

return .t.

****************
function FIS_NTX
****************
 
  if !file("&_PATH_\USR\FATURA\AFIS00.CDX")
    if !flock()
      return .f.
    endif
    index on FISNOV tag 1 to &_PATH_\USR\FATURA\AFIS00
    unlock all
  endif

return .t.

****************
function GRP_NTX
****************
 
  if !file("&_PATH_\USR\ESTOQUE\AGRP00.CDX")
    if !flock()
      return .f.
    endif
    index on str(GRPCOD, 4, 0) tag 1 to &_PATH_\USR\ESTOQUE\AGRP00
    index on  GRPNOM           tag 2 to &_PATH_\USR\ESTOQUE\AGRP00
    unlock all
  endif

return .t.

*****************
function CVE_NTX
*****************
 
  if !file("&_PATH_\USR\ESTOQUE\ACVE00.CDX")
    if !flock()
      return .f.
    endif
    index on CVEEST + CVECOD tag 1 to &_PATH_\USR\ESTOQUE\ACVE00
    unlock all
  endif

return .t.

****************
function PCA_NTX
****************
 
  if !file("&_PATH_\USR\ESTOQUE\APCA00.CDX")             && ordem 1
    if !flock()
      return .f.
    endif
    index on str(PCAMAT, 6, 0)                     tag 1 to &_PATH_\USR\ESTOQUE\APCA00
    index on str(PCAGRP, 4, 0) + str(PCAMAT, 6, 0) tag 2 to &_PATH_\USR\ESTOQUE\APCA00
    index on PCADES                                tag 3 to &_PATH_\USR\ESTOQUE\APCA00
    index on str(PCAGRP, 4, 0) + PCADES            tag 4 to &_PATH_\USR\ESTOQUE\APCA00
    index on PCAREF                                tag 5 to &_PATH_\USR\ESTOQUE\APCA00
    index on str(PCAFOR, 7, 0) + PCADES            tag 6 to &_PATH_\USR\ESTOQUE\APCA00
    index on PCAFAB + PCADES                       tag 7 to &_PATH_\USR\ESTOQUE\APCA00
    unlock all
  endif 

return .t.

*****************
function PCA1_NTX
*****************
 
  if !file("&_PATH_\USR\ESTOQUE\APCA02.CDX")
    if !flock()
      return .f.
    endif
    index on str(PCAMAT, 6, 0) tag 1 to &_PATH_\USR\ESTOQUE\APCA02
    unlock all
  endif 

return .t.

****************
function SLD_NTX
****************
 
  if !file("&_PATH_\USR\ESTOQUE\ASLD00.CDX")
    if !flock()
      return .f.
    endif
    index on str(SLDEMP, 2, 0) + str(SLDMAT, 6, 0) tag 1 to &_PATH_\USR\ESTOQUE\ASLD00
    unlock all
  endif 

return .t.


****************
function KAR_NTX
****************
 
  if !file("&_PATH_\USR\ESTOQUE\AKAR00.CDX")
    if !flock()
      return .f.
    endif
    index on str(KAREMP, 2, 0) +  str(KARMAT, 6, 0) + dtos(KARDTA) + KARFISN + str(KARDOC, 6, 0) + KARSER + str(KARSEQ, 2, 0) tag 1 to &_PATH_\USR\ESTOQUE\AKAR00
    index on str(KAREMP, 2, 0) +  str(KARCLF, 7, 0) + dtos(KARDTA)                                                                      tag 2 to &_PATH_\USR\ESTOQUE\AKAR00
    index on str(KAREMP, 2, 0) + dtos(KARDTA)                                                                                           tag 3 to &_PATH_\USR\ESTOQUE\AKAR00
    unlock all
  endif 

return .t.

****************
function DOL_NTX
****************
 
  if !file("&_PATH_\USR\ESTOQUE\ADOL00.CDX")
    if !flock()
      return .f.
    endif
    index on dtos(DOLDTA) tag 1 to &_PATH_\USR\ESTOQUE\ADOL00
    unlock all
  endif 

return .t.


****************
function ANO_NTX
****************
 
  if !file("&_PATH_\USR\ESTOQUE\AANO00.CDX")
    if !flock()
      return .f.
    endif
    index on str(ANOEMP, 2, 0) + str(ANOMAT, 6, 0) + str(ANONUM, 4, 0) tag 1 to &_PATH_\USR\ESTOQUE\AANO00
    unlock all
  endif 

return .t.

****************
function VEN_NTX
****************
 
  if !file("&_PATH_\USR\FATURA\AVEN00.CDX")
    if !flock()
      return .f.
    endif
    index on str(VENCOD, 3, 0) tag 1 to &_PATH_\USR\FATURA\AVEN00
    index on VENNOM            tag 2 to &_PATH_\USR\FATURA\AVEN00
    unlock all
  endif 

return .t.

****************
function FOR_NTX
****************
 
  if !file("&_PATH_\USR\ESTOQUE\AFOR00.CDX")
    if !flock()
      return .f.
    endif
    index on str(FORCOD, 7, 0) tag 1 to &_PATH_\USR\ESTOQUE\AFOR00
    index on FORNOM            tag 2 to &_PATH_\USR\ESTOQUE\AFOR00
    index on FORCGC            tag 3 to &_PATH_\USR\ESTOQUE\AFOR00
    unlock all
  endif 

return .t.

****************
function TRA_NTX
****************
 
  if !file("&_PATH_\USR\FATURA\ATRA00.CDX")
    if !flock()
      return .f.
    endif
    index on str(TRACOD, 3, 0) tag 1 to &_PATH_\USR\FATURA\ATRA00
    index on TRANOM            tag 2 to &_PATH_\USR\FATURA\ATRA00
    unlock all
  endif 

return .t.

****************
function CPG_NTX
****************
 
  if !file("&_PATH_\USR\FATURA\ACPG00.CDX")
    if !flock()
      return .f.
    endif
    index on str(CPGCOD, 3, 0) tag 1 to &_PATH_\USR\FATURA\ACPG00
    index on CPGDES            tag 2 to &_PATH_\USR\FATURA\ACPG00
    unlock all
  endif 
 
return .t.

*****************
function NFS0_NTX
*****************
 
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
  endif 

return .t.

*****************
function NFS1_NTX
*****************
 
  if !file("&_PATH_\USR\FATURA\ANFS01.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ANFS01) AGUARDE !!! * * *")
    index on  str(NFSEMP, 2, 0) + str(NFSNUM, 6, 0) + NFSSER + str(NFSSEQ, 2, 0) tag 1 to &_PATH_\USR\FATURA\ANFS01
    index on  str(NFSEMP, 2, 0) + str(NFSMAT,6,0) + dtos(NFSDTE)  tag 2 to &_PATH_\USR\FATURA\ANFS01
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function CRD_NTX
****************
 
  if !file("&_PATH_\USR\FATURA\ADCRDD.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ADCRDD) AGUARDE !!! * * *")
    index on  str(DUPEMP, 2, 0) + str(DUPNUM, 6, 0) + str(DUPORD, 2, 0) tag 1 to &_PATH_\USR\FATURA\ADCRDD
    index on  str(DUPEMP, 2, 0) + dtos(DUPDTE)                          tag 2 to &_PATH_\USR\FATURA\ADCRDD
    index on  str(DUPEMP, 2, 0) + DUPSIT                                tag 3 to &_PATH_\USR\FATURA\ADCRDD
    @ 24, 00 clear
    unlock all
  endif 

return .t.

*****************
function CPD_NTX
*****************
 
  if !file("&_PATH_\USR\ESTOQUE\ADCPDD.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ADCRDD) AGUARDE !!! * * *")
    index on  str(DUPEMP, 2, 0) + str(DUPNUM, 6, 0) + str(DUPORD, 2, 0) tag 1 to &_PATH_\USR\ESTOQUE\ADCPDD
    index on  str(DUPEMP, 2, 0) + dtos(DUPDTE)                          tag 2 to &_PATH_\USR\ESTOQUE\ADCPDD
    index on  str(DUPEMP, 2, 0) + DUPSIT                                tag 3 to &_PATH_\USR\ESTOQUE\ADCPDD
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function POR_NTX
****************

  if !file("&_PATH_\USR\CONREC\APOR00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (APOR00) AGUARDE !!! * * *")
    index on str(PORCOD, 5, 0) tag 1 to &_PATH_\USR\CONREC\APOR00
    index on PORNOM            tag 2 to &_PATH_\USR\CONREC\APOR00
    @ 24, 00 clear
    unlock all    
  endif

return .t.

****************
function BCO_NTX
****************

  if !file("&_PATH_\USR\BANCO\ABCO00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ABCO00) AGUARDE !!! * * *")
    index on str(BCOCOD, 3, 0) tag 1 to &_PATH_\USR\BANCO\ABCO00
    @ 24, 00 clear
    unlock all    
  endif

return .t.

*****************
function NFE0_NTX
*****************
 
  if !file("&_PATH_\USR\ESTOQUE\ANFE00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ANFE00) AGUARDE !!! * * *")
    index on str(NFEEMP, 2, 0) + str(NFENUM, 6, 0) + NFESER + str(NFEFOR, 7, 0)                 tag 1 to &_PATH_\USR\ESTOQUE\ANFE00
    index on str(NFEEMP, 2, 0) + dtos(NFEDTR) + str(NFENUM, 6, 0) + NFESER  + str(NFEFOR, 7, 0) tag 2 to &_PATH_\USR\ESTOQUE\ANFE00
    @ 24, 00 clear
    unlock all
  endif 

return .t.

*****************
function NFE1_NTX
*****************
 
  if !file("&_PATH_\USR\ESTOQUE\ANFE01.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ANFE01) AGUARDE !!! * * *")
    index on str(NFEEMP, 2, 0) + str(NFENUM, 6, 0) + NFESER + str(NFEFOR, 7, 0) + str(NFESEQ, 2, 0) tag 1 to &_PATH_\USR\ESTOQUE\ANFE01
    @ 24, 00 clear
    unlock all
  endif 

return .t.

******************
function NFE50_NTX
******************
 
  if !file("&_PATH_\USR\LIVRO\ANFE50.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ANFE50) AGUARDE !!! * * *")
    index on str(NFEEMP, 2, 0) + dtos(NFEDTR) + str(NFENUM, 6, 0) + NFESER + str(NFEFOR, 7, 0) + NFENATN tag 1 to &_PATH_\USR\LIVRO\ANFE50
    index on str(NFEFOR, 7, 0)                                                                                     tag 2 to &_PATH_\USR\LIVRO\ANFE50
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function DCR_NTX
****************

  if !file("&_PATH_\USR\CONREC\ADCR00.CDX")                && order 1
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ADCR00) AGUARDE !!! * * *")
    index on str(DUPEMP, 2, 0) + str(DUPNUM, 6, 0) + str(DUPORD, 2, 0)                tag 1 to &_PATH_\USR\CONREC\ADCR00
    index on str(DUPEMP, 2, 0) + str(DUPCLI, 7, 0) + dtos(DUPVCT)                     tag 2 to &_PATH_\USR\CONREC\ADCR00
    index on str(DUPEMP, 2, 0) + str(DUPPOR, 5, 0) + str(DUPCLI, 7, 0) + dtos(DUPVCT) tag 3 to &_PATH_\USR\CONREC\ADCR00
    index on str(DUPEMP, 2, 0) + dtos(DUPDTE)                                         tag 4 to &_PATH_\USR\CONREC\ADCR00
    index on str(DUPEMP, 2, 0) + dtos(DUPVCT) + str(DUPCLI, 7, 0)                     tag 5 to &_PATH_\USR\CONREC\ADCR00
    index on str(DUPEMP, 2, 0) + DUPNOM + dtos(DUPVCT)                                tag 6 to &_PATH_\USR\CONREC\ADCR00
    index on str(DUPEMP, 2, 0) + dtos(DUPDTP) + str(DUPNUM, 6, 0) + str(DUPORD, 2, 0) tag 7 to &_PATH_\USR\CONREC\ADCR00
    index on str(DUPEMP, 2, 0) + str(DUPBOL, 12, 0)                                   tag 8 to &_PATH_\USR\CONREC\ADCR00 for DUPBOL > 0
    index on str(DUPEMP, 2, 0) + DUPEXP                                               tag 9 to &_PATH_\USR\CONREC\ADCR00
    unlock all
    @ 24, 00 clear
  endif

return .t.

****************
function LCR_NTX
****************
 
  if !file("&_PATH_\USR\CONREC\ALCR00.CDX")               && ordem 1
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ALCR00) AGUARDE !!! * * *")
    index on str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) + str(LANHIS, 3, 0) tag 1 to &_PATH_\USR\CONREC\ALCR00
    index on str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) + dtos(LANDTM)      tag 2 to &_PATH_\USR\CONREC\ALCR00
    index on str(LANEMP, 2, 0) + str(LANCLI, 7, 0) + dtos(LANDTM)                          tag 3 to &_PATH_\USR\CONREC\ALCR00
    index on str(LANEMP, 2, 0) + dtos(LANDTM)                                              tag 4 to &_PATH_\USR\CONREC\ALCR00
    unlock all
    @ 24, 00 clear
  endif

return .t.

****************
function DCP_NTX
****************

  if !file("&_PATH_\USR\CONPAG\ADCP00.CDX")                && order 1
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ADCP00) AGUARDE !!! * * *")
    index on str(DUPEMP, 2, 0) + str(DUPNUM, 6, 0) + str(DUPORD, 2, 0)                tag 1 to &_PATH_\USR\CONPAG\ADCP00
    index on str(DUPEMP, 2, 0) + str(DUPFOR, 7, 0) + dtos(DUPVCT)                     tag 2 to &_PATH_\USR\CONPAG\ADCP00
    index on str(DUPEMP, 2, 0) + str(DUPPOR, 5, 0) + str(DUPFOR, 7, 0) + dtos(DUPVCT) tag 3 to &_PATH_\USR\CONPAG\ADCP00
    index on str(DUPEMP, 2, 0) + dtos(DUPDTE)                                         tag 4 to &_PATH_\USR\CONPAG\ADCP00
    index on str(DUPEMP, 2, 0) + dtos(DUPVCT) + str(DUPFOR, 7, 0)                     tag 5 to &_PATH_\USR\CONPAG\ADCP00
    index on str(DUPEMP, 2, 0) + DUPNOM                                               tag 6 to &_PATH_\USR\CONPAG\ADCP00
    index on str(DUPEMP, 2, 0) + dtos(DUPDTP) + str(DUPNUM, 6, 0) + str(DUPORD, 2, 0) tag 7 to &_PATH_\USR\CONPAG\ADCP00
    index on str(DUPEMP, 2, 0) + str(DUPBOL, 7, 0)                                    tag 8 to &_PATH_\USR\CONPAG\ADCP00
    unlock all
    @ 24, 00 clear
  endif

return .t.

****************
function LCP_NTX
****************
 
  if !file("&_PATH_\USR\CONPAG\ALCP00.CDX")               && ordem 1
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ALCP00) AGUARDE !!! * * *")
    index on str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) + str(LANHIS, 3, 0) tag 1 to &_PATH_\USR\CONPAG\ALCP00
    index on str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) + dtos(LANDTM)      tag 2 to &_PATH_\USR\CONPAG\ALCP00
    index on str(LANEMP, 2, 0) + str(LANFOR, 7, 0) + dtos(LANDTM)                          tag 3 to &_PATH_\USR\CONPAG\ALCP00
    index on str(LANEMP, 2, 0) + dtos(LANDTM)                                              tag 4 to &_PATH_\USR\CONPAG\ALCP00
    unlock all
    @ 24, 00 clear
  endif

return .t.

****************
function MCR_NTX
****************

  if !file("&_PATH_\USR\CONREC\AMOV00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (AMOV00) AGUARDE !!! * * *")
    index on str(MOVEMP, 2, 0) + str(MOVCOD, 3, 0) tag 1 to &_PATH_\USR\CONREC\AMOV00
    @ 24, 00 clear
    unlock all    
  endif

return .t.

****************
function MCP_NTX
****************

  if !file("&_PATH_\USR\CONPAG\AMOV00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (AMOV00) AGUARDE !!! * * *")
    index on str(MOVEMP, 2, 0) + str(MOVCOD, 3, 0) tag 1 to &_PATH_\USR\CONPAG\AMOV00
    @ 24, 00 clear
    unlock all    
  endif

return .t.

****************
function BCR_NTX
****************

  if !file("&_PATH_\USR\CONREC\ABCR00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ABCR00) AGUARDE !!! * * *")
    index on str(BAIEMP, 2, 0) + dtos(BAIDTM) + str(BAINUM, 6, 0) + str(BAIORD, 2, 0) tag 1 to &_PATH_\USR\CONREC\ABCR00
    @ 24, 00 clear
    unlock all
  endif

return .t.

****************
function BCP_NTX
****************

  if !file("&_PATH_\USR\CONPAG\ABCP00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ABCP00) AGUARDE !!! * * *")
    index on str(BAIEMP, 2, 0) + dtos(BAIDTM) + str(BAINUM, 6, 0) + str(BAIORD, 2, 0) tag 1 to &_PATH_\USR\CONPAG\ABCP00
    @ 24, 00 clear
    unlock all
  endif

return .t.

****************
function DED_NTX
****************
 
  if !file("&_PATH_\USR\FATURA\ADED00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ADED00) AGUARDE !!! * * *")
    index on DEDCOD tag 1 to &_PATH_\USR\FATURA\ADED00
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function COM_NTX
****************

  if !file("&_PATH_\USR\CONREC\ACOM00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ACOM00) AGUARDE !!! * * *")
    index on str(EMPCOM, 2, 0) + CODCOM tag 1 to &_PATH_\USR\CONREC\ACOM00
    @ 24, 00 clear
    unlock all    
  endif

return .t.

****************
function CTA_NTX
****************

  if !file("&_PATH_\USR\BANCO\ACTA00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ACTA00) AGUARDE !!! * * *")
    index on str(CTAEMP, 2, 0) + CTACTA            tag 1 to &_PATH_\USR\BANCO\ACTA00
    index on str(CTAEMP, 2, 0) + str(CTABAN, 3, 0) tag 2 to &_PATH_\USR\BANCO\ACTA00
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function HIB_NTX
****************
 
  if !file("&_PATH_\USR\BANCO\AHIS00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (AHIS00) AGUARDE !!! * * *")
    index on str(HISCOD, 3, 0) tag 1 to &_PATH_\USR\BANCO\AHIS00
    @ 24, 00 clear
    unlock all
  endif 
return .t.

****************
function LAB_NTX
****************

  if !file("&_PATH_\USR\BANCO\ALAB00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ALAB00) AGUARDE !!! * * *")
    index on str(LANEMP, 2, 0) + dtos(LANDTA) + LANCTA + str(LANSEQ, 6, 0) tag 1 to &_PATH_\USR\BANCO\ALAB00
    index on str(LANEMP, 2, 0) + LANCTA + dtos(LANDTA) + str(LANSEQ, 6, 0) tag 2 to &_PATH_\USR\BANCO\ALAB00
    @ 24, 00 clear
    unlock all    
  endif

return .t.

****************
function LAP_NTX
****************

  if !file("&_PATH_\USR\BANCO\ALAP00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ALAP00) AGUARDE !!! * * *")
    index on  str(LAPEMP, 2, 0) + dtos(LAPDTA) + str(LAPSEQ, 6, 0) tag 1 to &_PATH_\USR\BANCO\ALAP00
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function CHE_NTX
****************

  if !file("&_PATH_\USR\BANCO\ACHE00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ACHE00) AGUARDE !!! * * *")
    index on str(CHEEMP, 2, 0) + CHECTA + str(CHENUM, 6, 0) tag 1 to &_PATH_\USR\BANCO\ACHE00
    index on str(CHEEMP, 2, 0) + CHEIPL                     tag 2 to &_PATH_\USR\BANCO\ACHE00
    index on str(CHEEMP, 2, 0) + dtos(CHEDTE)               tag 3 to &_PATH_\USR\BANCO\ACHE00
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function LOG_NTX
****************

  if !file("&_PATH_\USR\ESTOQUE\ALOG10.CDX")
    if !flock()
      return .f.
    endif
    index on str(LOGEMP, 2, 0) + LOGNOM tag 1 to &_PATH_\USR\ESTOQUE\ALOG10
    index on str(LOGEMP, 2, 0) + LOGSEN tag 2 to &_PATH_\USR\ESTOQUE\ALOG10
    unlock all
  endif 

return .t.

****************
function PCH_NTX
****************

  if !file("&_PATH_\USR\BANCO\APCH00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (APCH00) AGUARDE !!! * * *")
    index on  str(PCHBAN, 3, 0) tag 1 to &_PATH_\USR\BANCO\APCH00
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function PAR_NTX
****************
 
  if !file("&_PATH_\USR\LIVRO\APAR00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (APAR00) AGUARDE !!! * * *")
    index on str(PAREMP, 2, 0) + PARMES tag 1 to &_PATH_\USR\LIVRO\APAR00
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function FIN_NTX
****************
 
  if !file("&_PATH_\USR\LIVRO\AFIN00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (AFIN00) AGUARDE !!! * * *")
    index on str(FINEMP, 2, 0) + FINMES tag 1 to &_PATH_\USR\LIVRO\AFIN00
    @ 24, 00 clear
    unlock all
  endif 

return .t.

*****************
function PED0_NTX
*****************
 
  if !file("&_PATH_\USR\FATURA\APED00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (APED00) AGUARDE !!! * * *")
    index on str(PEDEMP, 2, 0) + str(PEDNUM, 6, 0) + PEDSER                                             tag 1 to &_PATH_\USR\FATURA\APED00
    index on str(PEDEMP, 2, 0) + dtos(PEDDTE) + str(PEDNUM, 6, 0) + PEDSER                              tag 2 to &_PATH_\USR\FATURA\APED00
    index on str(PEDEMP, 2, 0) + str(PEDCLI, 7, 0) + dtos(PEDDTE) + str(PEDNUM, 6, 0) + PEDSER          tag 3 to &_PATH_\USR\FATURA\APED00
    @ 24, 00 clear
    unlock all
  endif 

return .t.

*****************
function PED1_NTX
*****************
 
  if !file("&_PATH_\USR\FATURA\APED01.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (APED01) AGUARDE !!! * * *")
    index on str(PEDEMP, 2, 0) + str(PEDNUM, 6, 0) + PEDSER + str(PEDSEQ, 2, 0) tag 1 to &_PATH_\USR\FATURA\APED01
    @ 24, 00 clear
    unlock all
  endif 

return .t.

*****************
function REQ0_NTX
*****************

  if !file("&_PATH_\USR\FATURA\AREQ00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (AREQ00) AGUARDE !!! * * *")
    index on str(REQEMP, 2, 0) + str(REQNUM, 6, 0) + REQSER                                    tag 1 to &_PATH_\USR\FATURA\AREQ00
    index on str(REQEMP, 2, 0) + dtos(REQDTE) + str(REQNUM, 6, 0) + REQSER                     tag 2 to &_PATH_\USR\FATURA\AREQ00
    index on str(REQEMP, 2, 0) + dtos(REQDTE) + str(REQCLI, 7, 0)                              tag 3 to &_PATH_\USR\FATURA\AREQ00
    index on str(REQEMP, 2, 0) + str(REQCLI, 7, 0) + dtos(REQDTE)                              tag 4 to &_PATH_\USR\FATURA\AREQ00
    index on str(REQEMP, 2, 0) + str(REQCLI, 7, 0) + dtos(REQDTE) + str(REQNUM, 6, 0) + REQSER tag 5 to &_PATH_\USR\FATURA\AREQ00
    index on str(REQEMP, 2, 0) + str(REQCLI, 7, 0) + descend(dtos(REQDTE)) + str(REQNUM, 6, 0) + REQSER tag 6 to &_PATH_\USR\FATURA\AREQ00
    index on str(REQEMP, 2, 0) + dtos(REQVC6) tag 7 to &_PATH_\USR\FATURA\AREQ00 for REQFRC == "S"  // somente aluguel
    @ 24, 00 clear
    unlock all
  endif 

return .t.

*****************
function REQ1_NTX
*****************
 
  if !file("&_PATH_\USR\FATURA\AREQ01.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (AREQ01) AGUARDE !!! * * *")
    index on str(REQEMP, 2, 0) + str(REQNUM, 6, 0) + REQSER + str(REQSEQ, 2, 0) tag 1 to &_PATH_\USR\FATURA\AREQ01
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function ETQ_NTX
****************
 
  if !file("&_PATH_\USR\FATURA\AETQ00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (AETQ00) AGUARDE !!! * * *")
    index on ETQCOD tag 1 to &_PATH_\USR\FATURA\AETQ00
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function GRU_NTX
****************
 
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (AGRP00) AGUARDE !!! * * *")
    index on str(AGREMP, 2, 0) + str(AGRCLI, 7, 0) + str(AGRDUP, 6, 0) + str(AGRORD, 2 ,0) tag 1 to &_PATH_\USR\CONREC\AGRP00
    @ 24, 00 clear
    unlock all

return .t.

****************
function SER_NTX
****************
 
  if !file("&_PATH_\USR\ESTOQUE\ASER00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ASER00) AGUARDE !!! * * *")
    index on str(SERCOD, 6, 0) tag 1 to &_PATH_\USR\ESTOQUE\ASER00
    index on SERDES            tag 2 to &_PATH_\USR\ESTOQUE\ASER00
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function PRD_NTX
****************
 
  if !file("&_PATH_\USR\BANCO\APRD00.CDX")     && ordem 1
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (APRD00) AGUARDE !!! * * *")
    index on str(PRDEMP, 2, 0) + str(PRDCHE, 6, 0) + str(PRDORD, 2, 0) tag 1 to &_PATH_\USR\BANCO\APRD00
    index on str(PRDEMP, 2, 0) + str(PRDBAN, 3, 0) + dtos(PRDVCT)      tag 2 to &_PATH_\USR\BANCO\APRD00
    index on str(PRDEMP, 2, 0) + dtos(PRDDTE)                          tag 3 to &_PATH_\USR\BANCO\APRD00
    index on str(PRDEMP, 2, 0) + dtos(PRDVCT)                          tag 4 to &_PATH_\USR\BANCO\APRD00
    index on str(PRDEMP, 2, 0) + PRDPOR + dtos(PRDVCT)                 tag 5 to &_PATH_\USR\BANCO\APRD00
    index on str(PRDEMP, 2, 0) + dtos(PRDENT)                          tag 6 to &_PATH_\USR\BANCO\APRD00
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function PEN_NTX
****************
 
  if !file("&_PATH_\USR\FATURA\APEN00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (APEN00) AGUARDE !!! * * *")
    index on str(PENEMP, 2, 0) +  str(PENNFS, 6, 0) + PENSER + str(PENSEQ, 2, 0)                                   tag 1 to &_PATH_\USR\FATURA\APEN00
    index on str(PENEMP, 2, 0) + str(PENMAT, 6, 0) + dtos(PENDTE) + str(PENNFS, 6, 0) + PENSER + str(PENSEQ, 2, 0) tag 2 to &_PATH_\USR\FATURA\APEN00
    index on str(PENEMP, 2, 0) + str(PENCLI, 7, 0) + str(PENMAT, 6, 0) + dtos(PENDTE)                              tag 3 to &_PATH_\USR\FATURA\APEN00
    @ 24, 00 clear
    unlock all
  endif 
 
return .t.

****************
function TEL_NTX
****************
 
  if !file("&_PATH_\USR\FATURA\ATEL00.CDX")  && ordem 1
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ATEL00) AGUARDE !!! * * *")
    index on TELNUM + TELDDD tag 1 to &_PATH_\USR\FATURA\ATEL00
    index on TELNOM          tag 2 to &_PATH_\USR\FATURA\ATEL00
    index on TELMUN          tag 3 to &_PATH_\USR\FATURA\ATEL00
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function AGE_NTX
****************
 
  if !file("&_PATH_\USR\FATURA\AAGE00.CDX")    && ordem 1
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (AAGE00) AGUARDE !!! * * *")
    index on str(AGEEMP, 2, 0) + AGENOM + dtos(AGEDTA) + AGEHOR tag 1 to &_PATH_\USR\FATURA\AAGE00
    index on str(AGEEMP, 2, 0) + dtos(AGEDTA) + AGEHOR          tag 2 to &_PATH_\USR\FATURA\AAGE00
    @ 24, 00 clear
    unlock all
  endif 


return .t.

****************
function PLX_NTX
****************

  if !file("&_PATH_\USR\FLUXO\APLX00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (APLC00) AGUARDE !!! * * *")
    index on str(PLXEMP, 2, 0) + str(PLXAPL, 3, 0)                              tag 1 to &_PATH_\USR\FLUXO\APLX00
    index on str(PLXEMP, 2, 0) + PLXNOM                                         tag 2 to &_PATH_\USR\FLUXO\APLX00
    index on str(PLXEMP, 2, 0) + left(str(PLXAPL, 3, 0), 1) + str(PLXGRP, 3, 0) tag 3 to &_PATH_\USR\FLUXO\APLX00
    @ 24, 00 clear
    unlock all    
  endif

return .t.

****************
function LAX_NTX
****************

  if !file("&_PATH_\USR\FLUXO\ALAX00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ALAX00) AGUARDE !!! * * *")
    index on str(LAXEMP, 2, 0) + dtos(LAXDTA) + str(LAXSEQ, 6, 0)                     tag 1 to &_PATH_\USR\FLUXO\ALAX00
    index on str(LAXEMP, 2, 0) + str(LAXAPL, 3, 0) + dtos(LAXDTA) + str(LAXSEQ, 6, 0) tag 2 to &_PATH_\USR\FLUXO\ALAX00
    @ 24, 00 clear
    unlock all    
  endif

return .t.

****************
function HIX_NTX
****************
 
  if !file("&_PATH_\USR\FLUXO\AHIX00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (AHIX00) AGUARDE !!! * * *")
    index on str(HIXCOD, 3, 0) tag 1 to &_PATH_\USR\FLUXO\AHIX00
    index on HIXDES            tag 2 to &_PATH_\USR\FLUXO\AHIX00
    @ 24, 00 clear
    unlock all
  endif 

return .t.

*****************
function ORC0_NTX
*****************
 
  if !file("&_PATH_\USR\FATURA\AORC00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (AORC00) AGUARDE !!! * * *")
    index on str(ORCEMP, 2, 0) + str(ORCNUM, 6, 0) + ORCSER                tag 1 to &_PATH_\USR\FATURA\AORC00
    index on str(ORCEMP, 2, 0) + dtos(ORCDTE) + str(ORCNUM, 6, 0) + ORCSER tag 2 to &_PATH_\USR\FATURA\AORC00
    index on str(ORCEMP, 2, 0) + dtos(ORCDTE) + ORCNATN          tag 3 to &_PATH_\USR\FATURA\AORC00
    index on str(ORCEMP, 2, 0) + dtos(ORCDTE) + str(ORCCLI, 5, 0)          tag 4 to &_PATH_\USR\FATURA\AORC00
    index on str(ORCEMP, 2, 0) + ORCIPL                                    tag 5 to &_PATH_\USR\FATURA\AORC00
    index on str(ORCEMP, 2, 0) + str(ORCCLI, 5, 0) + dtos(ORCDTE)          tag 6 to &_PATH_\USR\FATURA\AORC00
    @ 24, 00 clear
    unlock all
  endif 

return .t.

*****************
function ORC1_NTX
*****************
 
  if !file("&_PATH_\USR\FATURA\AORC01.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (AORC01) AGUARDE !!! * * *")
    index on str(ORCEMP, 2, 0) + str(ORCNUM, 6, 0) + ORCSER + str(ORCSEQ, 2, 0) tag 1 to &_PATH_\USR\FATURA\AORC01
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function PTA_NTX
****************
 
  if !file("&_PATH_\USR\BANCO\PORTADOR.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (PORTADOR) AGUARDE !!! * * *")
    index on NOME tag 1 to &_PATH_\USR\BANCO\PORTADOR
    @ 24, 00 clear
    unlock all
  endif 

return .t.

**************
function GAUGE
**************

setcolor("W+/N")
  @ 24, 00 say str(((recno()/lastrec()) * 100),5,2) + "%"
setcolor("")

return .t.

****************
function CAN_NTX
****************
 
  if !file("&_PATH_\USR\FATURA\ANFSCAN.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ANFSCAN) AGUARDE !!! * * *")
    index on  str(NFSEMP, 2, 0) + str(NFSNUM, 6, 0) + NFSSER                tag 1 to &_PATH_\USR\FATURA\ANFSCAN
    select ANFSCAN
    use
    abre_nfscan("0")
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function FORMOR_NTX
****************
 
  if !file("&_PATH_\USR\ESTOQUE\AFOMOR.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (AFOMOR) AGUARDE !!! * * *")
    index on str(FORCOD, 7, 0) tag 1 to &_PATH_\USR\ESTOQUE\AFOMOR
    index on FORNOM            tag 2 to &_PATH_\USR\ESTOQUE\AFOMOR
    @ 24, 00 clear
    unlock all
    select AFOMOR
    use
    abre_formor("0")
  endif 

return .t.

****************
function PCAMOR_NTX
****************
 
  if !file("&_PATH_\USR\ESTOQUE\APCMOR.CDX")             && ordem 1
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (APCMOR) AGUARDE !!! * * *")
    index on str(PCAMAT, 6, 0)                     tag 1 to &_PATH_\USR\ESTOQUE\APCMOR
    index on str(PCAGRP, 4, 0) + str(PCAMAT, 6, 0) tag 2 to &_PATH_\USR\ESTOQUE\APCMOR
    index on PCADES                                tag 3 to &_PATH_\USR\ESTOQUE\APCMOR
    index on str(PCAGRP, 4, 0) + PCADES            tag 4 to &_PATH_\USR\ESTOQUE\APCMOR
    index on PCAREF                                tag 5 to &_PATH_\USR\ESTOQUE\APCMOR
    index on str(PCAFOR, 7, 0) + PCADES            tag 6 to &_PATH_\USR\ESTOQUE\APCMOR
    index on PCAFAB + PCADES                       tag 7 to &_PATH_\USR\ESTOQUE\APCMOR
    @ 24, 00 clear
    unlock all
    select PCAMOR
    use
    abre_pcamor("0")
  endif 

return .t.

****************
function CLIMOR_NTX
****************
 
  if !file("&_PATH_\USR\FATURA\ACLMOR.CDX")               && ordem 1
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ACLMOR) AGUARDE !!! * * *")
    index on str(CLICOD, 7, 0) tag 1 to &_PATH_\USR\FATURA\ACLMOR
    index on CLINOM            tag 2 to &_PATH_\USR\FATURA\ACLMOR
    index on CLICGC1           tag 3 to &_PATH_\USR\FATURA\ACLMOR
    index on CLIMUN1           tag 4 to &_PATH_\USR\FATURA\ACLMOR
    index on CLIMUN2 + CLINOM  tag 5 to &_PATH_\USR\FATURA\ACLMOR
    unlock all
    select ACLMOR
    use
    abre_climor("0")
    @  24, 00 clear 
  endif

return .t.

****************
function TIP_NTX
****************
 
  if !file("&_PATH_\USR\FATURA\ATIP00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ATIP00) AGUARDE !!! * * *")
    index on CVECOD tag 1 to &_PATH_\USR\FATURA\ATIP00
    @ 24, 00 clear
    unlock all
    select ATIP00
    use
    abre_tip("0")
  endif 

return .t.

****************
function MUN_NTX
****************
 
  if !file("&_PATH_\USR\FATURA\AMUN00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * Criando ¡ndices (amun00) aguarde !!! * * *")
    index on  str(MUNCOD, 7) tag 1 to &_PATH_\USR\FATURA\AMUN00 eval(gauge())
    index on  MUNNOM         tag 2 to &_PATH_\USR\FATURA\AMUN00 eval(gauge())
    @ 24, 00 clear
    unlock all
  endif 

return .t.

*****************
function CUP0_NTX
*****************
 
  if !file("&_PATH_\USR\FATURA\ACUP00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ACUP00) AGUARDE !!! * * *")
    index on str(CUPEMP, 2, 0) + str(CUPNUM, 6, 0) + CUPSER                                    tag 1 to &_PATH_\USR\FATURA\ACUP00
    index on str(CUPEMP, 2, 0) + dtos(CUPDTE) + str(CUPNUM, 6, 0) + CUPSER                     tag 2 to &_PATH_\USR\FATURA\ACUP00
    index on str(CUPEMP, 2, 0) + dtos(CUPDTE) + str(CUPCLI, 7, 0)                              tag 3 to &_PATH_\USR\FATURA\ACUP00
    index on str(CUPEMP, 2, 0) + str(CUPCLI, 7, 0) + dtos(CUPDTE)                              tag 4 to &_PATH_\USR\FATURA\ACUP00
    index on str(CUPEMP, 2, 0) + str(CUPCLI, 7, 0) + dtos(CUPDTE) + str(CUPNUM, 6, 0) + CUPSER tag 5 to &_PATH_\USR\FATURA\ACUP00
*    index on str(CUPEMP, 2, 0) + str(CUPCLI, 7, 0) + descend(dtos(CUPDTE)) + str(CUPNUM, 6, 0) + CUPSER tag 6 to &_PATH_\USR\FATURA\ACUP00
    index on str(CUPEMP, 2, 0) + str(CUPCLI, 7, 0) + dtos(CUPDTE) + str(CUPNUM, 6, 0) + CUPSER tag 6 to &_PATH_\USR\FATURA\ACUP00 DESCENDING

    @ 24, 00 clear
    unlock all
  endif 

return .t.

*****************
function CUP1_NTX
*****************
 
  if !file("&_PATH_\USR\FATURA\ACUP01.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ACUP01) AGUARDE !!! * * *")
    index on str(CUPEMP, 2, 0) + str(CUPNUM, 6, 0) + CUPSER + str(CUPSEQ, 2, 0) tag 1 to &_PATH_\USR\FATURA\ACUP01
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function IND_NTX
****************
 
  if !file("&_PATH_\USR\FATURA\AIND00.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (AIND00) AGUARDE !!! * * *")
    index on str(VENCOD, 3, 0) tag 1 to &_PATH_\USR\FATURA\AIND00
    index on VENNOM            tag 2 to &_PATH_\USR\FATURA\AIND00
    @ 24, 00 clear
    unlock all
  endif 

return .t.

****************
function CONFIG_NTX
****************

  if !file("&_PATH_\USR\ESTOQUE\ACONFIG.CDX")
    if !flock()
      return .f.
    endif
    msw("* * * CRIANDO INDICES (ACONFIG) AGUARDE !!! * * *")
    index on MAQUINA tag 1 to &_PATH_\USR\ESTOQUE\ACONFIG
    unlock all
    use
    abre_config()
  endif

return .t.
