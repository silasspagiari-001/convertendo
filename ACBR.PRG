****************
function EXC_ARQ
****************


parameters aUNIDADE

if !ARQ_EXC(aUNIDADE + ":\NFE\ACBR.ANT", 5 )
  alert("ERRO: Nao foi possivel APAGAR o arquivo:; (" + aUNIDADE + ":\nfe\resnfe.txt). FError: "+str(FError())+".")
endif

if !ARQ_EXC(aUNIDADE + ":\NFE\ACBR.TXT", 5 )
  alert("ERRO: Nao foi possivel APAGAR o arquivo:; (" + aUNIDADE + ":\nfe\resnfe.txt). FError: "+str(FError())+".")
endif

if !ARQ_EXC(aUNIDADE + ":\NFE\RESNFE.TXT", 5 )
  alert("ERRO: Nao foi possivel APAGAR o arquivo:; (" + aUNIDADE + ":\nfe\resnfe.txt). FError: "+str(FError())+".")
endif

if !ARQ_EXC(aUNIDADE + ":\NFE\SAINFE.TXT", 5 )
  alert("ERRO: Nao foi possivel APAGAR o arquivo:; ("+ aUNIDADE + ":\nfe\SAINFE.txt). FError: "+str(FError())+".")
endif

if !ARQ_EXC(aUNIDADE + ":\NFE\NFE.XML", 5 )
  alert("ERRO: Nao foi possivel APAGAR o arquivo:; ("+ aUNIDADE + ":\nfe\nfe.xml). FError: "+str(FError())+".")
endif

if !ARQ_EXC(aUNIDADE + ":\NFE\ARQTEM.TXT", 5 )
  alert("ERRO: Nao foi possivel APAGAR o arquivo:; ("+ aUNIDADE + ":\nfe\arqtem.txt). FError: "+str(FError())+".")
endif

if !ARQ_EXC(aUNIDADE + ":\NFE\RESXML.TXT", 5 )
  alert("ERRO: Nao foi possivel APAGAR o arquivo:; ("+ aUNIDADE + ":\nfe\resxml.txt). FError: "+str(FError())+".")
endif

if !ARQ_EXC(aUNIDADE + ":\NFE\ENTNFE.TXT", 5 )
  alert("ERRO: Nao foi possivel APAGAR o arquivo:; ("+ aUNIDADE + ":\nfe\entnfe.txt). FError: "+str(FError())+".")
endif

return ""

****************
function EXC_ARQ2
****************

parameters aUNIDADE

if !ARQ_EXC(aUNIDADE + ":\NFE\ACBR.ANT", 5 )
  alert("ERRO: Nao foi possivel APAGAR o arquivo:; (" + aUNIDADE + ":\nfe2\resnfe.txt). FError: "+str(FError())+".")
endif

if !ARQ_EXC(aUNIDADE + ":\NFE\ACBR.TXT", 5 )
  alert("ERRO: Nao foi possivel APAGAR o arquivo:; (" + aUNIDADE + ":\nfe2\resnfe.txt). FError: "+str(FError())+".")
endif

if !ARQ_EXC(aUNIDADE + ":\NFE\RESNFE.TXT", 5 )
  alert("ERRO: Nao foi possivel APAGAR o arquivo:; (" + aUNIDADE + ":\nfe2\resnfe.txt). FError: "+str(FError())+".")
endif

if !ARQ_EXC(aUNIDADE + ":\NFE\SAINFE.TXT", 5 )
  alert("ERRO: Nao foi possivel APAGAR o arquivo:; ("+ aUNIDADE + ":\nfe2\SAINFE.txt). FError: "+str(FError())+".")
endif

if !ARQ_EXC(aUNIDADE + ":\NFE\NFE2.XML", 5 )
  alert("ERRO: Nao foi possivel APAGAR o arquivo:; ("+ aUNIDADE + ":\nfe2\nfe.xml). FError: "+str(FError())+".")
endif

if !ARQ_EXC(aUNIDADE + ":\NFE\ARQTEM.TXT", 5 )
  alert("ERRO: Nao foi possivel APAGAR o arquivo:; ("+ aUNIDADE + ":\nfe2\arqtem.txt). FError: "+str(FError())+".")
endif

if !ARQ_EXC(aUNIDADE + ":\NFE\RESXML.TXT", 5 )
  alert("ERRO: Nao foi possivel APAGAR o arquivo:; ("+ aUNIDADE + ":\nfe2\resxml.txt). FError: "+str(FError())+".")
endif

if !ARQ_EXC(aUNIDADE + ":\NFE\ENTNFE.TXT", 5 )
  alert("ERRO: Nao foi possivel APAGAR o arquivo:; ("+ aUNIDADE + ":\nfe2\entnfe.txt). FError: "+str(FError())+".")
endif

return ""

