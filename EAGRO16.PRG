***************
function MANPEN
***************

#include "ptmenu.ch"

msw("* * * AGUARDE... ABRINDO ARQUIVOS * * *")

abre_pen("2") && pendencias 
abre_cli("3") && cliente    
abre_pca("4") && produtos   
abre_sld("5") && saldos     

@ 24, 00 clear

private M_OPC ,;
        M_TELA

    _FUNCLI_ = "PEN.t."
    _FUNPRO_ = "PEN.t."
    _FUNFOR_ = "PEN.f."
    _FUNCPG_ = "PEN.f."
    _FUNTRA_ = "PEN.f."
    _FUNVEN_ = "PEN.f."
    _FUNPLX_ = "PEN.f."

    do while .t.

      @ 24, 00 clear

      rodape("MENU","CONSIGNADA",M_FAN,"EAGRO51","Mem: " + str(memory(0), 5),M_EMP) 

      sombra(04, 07, 11, 17, _SOMBRA_)

      set color to N/BG
        @ 4, 7, 11, 17 box M_FRAME1
      set color to W+/BG,W+/N
        @ 05, 08 prompt "Inclus„o " HIGHLITE R/BG PERMITE 6,1,1
        @ 06, 08 prompt "Altera‡„o" HIGHLITE R/BG PERMITE 6,1,2
        @ 07, 08 prompt "Consulta " HIGHLITE R/BG PERMITE 6,1,3
        @ 08, 08 prompt "Exclus„o " HIGHLITE R/BG PERMITE 6,1,4
        @ 09, 08 prompt "Listagem " HIGHLITE R/BG PERMITE 6,1,5
        @ 10, 08 prompt "Outros   " HIGHLITE R/BG PERMITE 6,1,6
        menu to M_OPC
      set color to

      M_TELA = savescreen(02, 04, 21, 77)

      do case
         case M_OPC = 0
              exit
         case M_OPC = 1 
         case M_OPC = 2 
         case M_OPC = 3 
         case M_OPC = 4 
         case M_OPC = 5 
      endcase

      restscreen(02, 04, 21, 77, M_TELA)

      set key -1  to 
      set key -2  to 

    enddo

    fecha_arq()

return ""
