#include "ptmenu.ch"

***************
function MANETQ
***************
parameters M_OPC,M_OPC1,M_OPC2

      rodape("MENU","ETIQUETAS",M_FAN,"EAGRO37","Mem: " + str(memory(0), 5),M_EMP) 

*        @ 05, 30 prompt "Inclus꼘 " HIGHLITE R/BG
*        @ 06, 30 prompt "Altera뇙o" HIGHLITE R/BG
*        @ 07, 30 prompt "Consulta " HIGHLITE R/BG
*        @ 08, 30 prompt "Exclus꼘 " HIGHLITE R/BG
*        @ 09, 30 prompt "Listagem " HIGHLITE R/BG
*        @ 10, 30 prompt "Parametro" HIGHLITE R/BG

      do case
         case M_OPC = 1
            incetq()
         case M_OPC = 2
            altetq()
         case M_OPC = 3
            conetq()
         case M_OPC = 4
            excetq()
         case M_OPC = 5
            emietq()
         case M_OPC = 6
            paretq()
      endcase


fecha_arq()

return ""

***************
function INCETQ
***************
        
    do while .t.

        M_ETQCOD = space(10)  
        M_ETQDS1 = space(38)  
        M_ETQDS2 = space(38)  
        M_ETQDS3 = space(38)  
        M_ETQDS4 = space(38)  
        M_ETQDS5 = space(38)  
        M_ETQDS6 = space(38)
        M_ETQDS7 = space(38)  
        M_ETQDS8 = space(38)

      tletq01() 

       rodape("INCLUI","ETIQUETAS",M_FAN,"EAGRO37","Mem: " + str(memory(0), 5),M_EMP) 

        SetColor(_COREDICAO_)
        @ 08, 25 get     M_ETQCOD   picture "@!"
        read

        if empty(M_ETQCOD)
          exit
        endif

        if BUSCAREGISTRO("AETQ00",1,{aspas(M_ETQCOD)},"SELECT")
          msg("* * * ETIQUETA JA CADASTRADA * * *")
          loop
        endif

        if !BUSCAREGISTRO("ACLI00",1,{str(val(M_ETQCOD), 7, 0)},"SELECT")
          msg("* * * CLIENTE NAO CADASTRADO * * *")
          loop
        endif

        M_ETQDS1 = pad(ACLI00->CLINOM,38)
        M_ETQDS2 = pad(ACLI00->CLIEND2,38)
        M_ETQDS3 = pad(strzero(ACLI00->CLICEP2, 5, 0)+"-"+strzero(ACLI00->CLICCL2, 3, 0) + " " + alltrim(ACLI00->CLIMUN2) + " " + ACLI00->CLIUF2,38)

        edetq01()

        if lastkey() = 27
          msg("* * * ETIQUETA NAO INCLUIDA * * *")
          loop
        endif

        gretq01("INSERT")                      && grava dados da etqnsportadora
        
        msg("* * * ETIQUETA INCLUIDO * * *")

    enddo

return ""

***************
function ALTETQ
***************
             
    do while .t.

    tletq01() 

       rodape("ALTERA","ETIQUETAS",M_FAN,"EAGRO37","Mem: " + str(memory(0), 5),M_EMP) 

        store space(10) to M_ETQCOD
        SetColor(_COREDICAO_)
        @ 08, 25 get     M_ETQCOD   picture "@!"
        read

        if empty(M_ETQCOD)
          exit
        endif

        if !BUSCAREGISTRO("AETQ00",1,{aspas(M_ETQCOD)},"SELECT")
          msg("* * * ETIQUETA NAO CADASTRADA * * *")
          loop
        endif

        if !BUSCAREGISTRO("ACLI00",1,{str(val(M_ETQCOD),7,0)},"SELECT")
          msg("* * * CLIENTE NAO CADASTRADO * * *")
          loop
        endif

        select AETQ00
        
        M_ETQDS1 = pad(ACLI00->CLINOM,38)
        M_ETQDS2 = pad(ACLI00->CLIEND2,38)
        M_ETQDS3 = pad(strzero(ACLI00->CLICEP2, 5, 0)+"-"+strzero(ACLI00->CLICCL2, 3, 0) + " " + alltrim(ACLI00->CLIMUN2) + " " + ACLI00->CLIUF2,38)

        msetq01()  

        M_ETQCOD = ETQCOD
        M_ETQDS4 = ETQDS4     
        M_ETQDS5 = ETQDS5     
        M_ETQDS6 = ETQDS6
        M_ETQDS7 = ETQDS7     
        M_ETQDS8 = ETQDS8

        edetq01()

        if lastkey() = 27
          msg("* * * ETIQUETA NAO ALTERADA * * *")
          loop
        endif

        gretq01("UPDATE")                      && grava dados da etqnsportadora

        msg("* * * ETIQUETA ALTERADA * * *")

    enddo

return ""

***************
function CONETQ
***************
        
private M_ETQCOD
             
    do while .t.

      tletq01() 

        rodape("CONSULTA","ETIQUETAS",M_FAN,"EAGRO37","Mem: " + str(memory(0), 5),M_EMP) 

        store space(10) to M_ETQCOD
        SetColor(_COREDICAO_)
        @ 08, 25 get     M_ETQCOD   picture "@!"
        read

        if empty(M_ETQCOD)
          exit
        endif

        if !BUSCAREGISTRO("AETQ00",1,{aspas(M_ETQCOD)},"SELECT")
          msg("* * * ETIQUETA NAO CADASTRADA * * *")
          loop
        endif

        if !BUSCAREGISTRO("ACLI00",1,{str(val(M_ETQCOD),7,0)},"SELECT")
          msg("* * * CLIENTE NAO CADASTRADO * * *")
          loop
        endif

        select AETQ00
        
        do while .t.

          if ETQCOD = space(10)
            skip
            if eof()
              msg("* * * ARQUIVO VAZIO * * *")
              exit
            endif
            loop
          endif          

          msetq01()

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

    enddo


return ""

***************
function EXCETQ
***************
        
private M_ETQCOD ,;
        M_OPC
             
    do while .t.

      tletq01() 
 
        rodape("EXCLUI","ETIQUETAS",M_FAN,"EAGRO37","Mem: " + str(memory(0), 5),M_EMP)

        store space(10) to M_ETQCOD
        SetColor(_COREDICAO_)
        @ 08, 25 get     M_ETQCOD   picture "@!"
        read

        if empty(M_ETQCOD)
          exit
        endif

        if !BUSCAREGISTRO("AETQ00",1,{aspas(M_ETQCOD)},"SELECT")
          msg("* * * ETIQUETA NAO CADASTRADA * * *")
          loop
        endif

        if !BUSCAREGISTRO("ACLI00",1,{str(val(M_ETQCOD),7,0)},"SELECT")
          msg("* * * CLIENTE NAO CADASTRADO * * *")
          loop
        endif

        msetq01()

        M_OPC = confirma("desta Etiqueta")

        if M_OPC != 1
          msg("* * * ETIQUETA NAO EXCLUIDA * * *")
          loop
        endif

        gretq01("DELETE")

        msg("* * * ETIQUETA EXCLUIDO * * *")

    enddo

return ""

***************
function EMIETQ
*************** 

    if file("ETIPRO.MEM")
      restore from ETIPRO.MEM additive
    else
      ME_PUL  = 0
      ME_CAR  = 1
      ME_TAM  = 38
      ME_LIE  = 1
      ME_COE  = 1
      ME_CPP  = 10
      ME_QLT  = "N"
      ME_TLI  = 8
    endif
 
    do while .t.

        tletq01()

        rodape("EMITE","ETIQUETAS",M_FAN,"EAGRO37","Mem: " + str(memory(0), 5),M_EMP) 

        store space(10) to M_ETQCOD
        SetColor(_COREDICAO_)
        @ 08, 25 get     M_ETQCOD   picture "@!"
        read

        if empty(M_ETQCOD)
          exit
        endif

        if !BUSCAREGISTRO("AETQ00",1,{aspas(M_ETQCOD)},"SELECT")
          msg("* * * ETIQUETA NAO CADASTRADA * * *")
          loop
        endif

        if !BUSCAREGISTRO("ACLI00",1,{str(val(M_ETQCOD),7,0)},"SELECT")
          msg("* * * CLIENTE NAO CADASTRADO * * *")
          loop
        endif

        select AETQ00
        
        M_ETQDS1 = pad(ACLI00->CLINOM,38)
        M_ETQDS2 = pad(ACLI00->CLIEND2,38)
        M_ETQDS3 = pad(strzero(ACLI00->CLICEP2, 5, 0)+"-"+strzero(ACLI00->CLICCL2, 3, 0) + " " + alltrim(ACLI00->CLIMUN2) + " " + ACLI00->CLIUF2,38)

        M_ETQCOD = ETQCOD     
        M_ETQDS4 = ETQDS4     
        M_ETQDS5 = ETQDS5     
        M_ETQDS6 = ETQDS6        
        M_ETQDS7 = ETQDS7     
        M_ETQDS8 = ETQDS8        
       
        edetq01()  

        ET       = 0
        M_COPIAS = 1

        @ 24, 24 say "Informe o Numero de Copias:     "
        SetColor(_COREDICAO_)
        @ 24, 52 get M_COPIAS picture "#####" valid(M_COPIAS > 0)
        read

        if lastkey() = 27
          loop
        endif

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          loop
        endif

        if ME_CPP = 12
          ?? chr(27) + "M"
        else
          if ME_CPP = 15
            ?? chr(15)
          endif
        endif
        
        if ME_CPP = 10
          if ME_QLT = "S"
            ?? chr(27) + "G"
          endif
        endif

        for R = 1 to ME_PUL
         ?
        next

        for R = 1 to ME_CAR
          U = str(R, 1, 0)
          for S = 1 to ME_TLI
            T = str(S, 1, 0)
            M_ETIQ&T&U = pad(M_ETQDS&T,ME_TAM)
          next
        next

        do while .t.
 
            M_ESC = inkey()

            if M_ESC = 27
                if susimp()
                  ? "------------------------------"
                  ? "* * * IMPRESSAO SUSPENSA * * *"
                  exit
                else
                  M_ESC = inkey()
                endif
            endif

            ET = ET + ME_CAR

            if ET > M_COPIAS               
              for R = ((ET - M_COPIAS) + 1) to ME_CAR
                U = str(R, 1, 0)
                for S = 1 to ME_TLI
                 T = str(S, 1, 0)
                 M_ETIQ&T&U = space(ME_TAM)
               next
              next
              impreetq()
              exit
            endif 

            impreetq()

            msw("* * * IMPRIMINDO : " + str((M_COPIAS - ET), 5, 0) + " * * *")

            if ET = M_COPIAS 
              exit
            endif

        enddo

desliga1()

enddo 

return "" 

***************
function PARETQ
*************** 

private M_TELA 

 if file("ETIPRO.MEM")
   restore from ETIPRO.MEM additive
 else
   ME_PUL  = 0
   ME_CAR  = 2
   ME_TAM  = 38
   ME_LIE  = 4
   ME_COE  = 4
   ME_CPP  = 10
   ME_QLT  = "N"
   ME_TLI  = 8
 endif

M_TELA = savescreen(06, 20, 21, 75)

 nbox(06, 35, 15, 68,"W/W+",.t.)
 setcolor("B/W")
      @ 07, 36 say               " Pular linhas no inicio :       "
      @ 08, 36 say               " Numero de Carreiras    :       "
      @ 09, 36 say               " Tamanho em Caracteres  :       "
      @ 10, 36 say               " Linhas Entre Etiquetas :       "
      @ 11, 36 say               " Colunas Entre Etiquetas:       "
      @ 12, 36 say               " Tamanho do Caracter cpp:       "
      @ 13, 36 say               " Total Linhas Etiqueta  :       "
      @ 14, 36 say               " Qualidade Carta        :       "
    SetColor(_COREDICAO_)
    @ 07, 62 get ME_PUL  picture "##"
    @ 08, 62 get ME_CAR  picture "#"
    @ 09, 62 get ME_TAM  picture "##"
    @ 10, 62 get ME_LIE  picture "#"
    @ 11, 62 get ME_COE  picture "#"
    @ 12, 62 get ME_CPP  picture "##" valid(rat(str(ME_CPP, 2, 0),"10#12#15") > 0)
    @ 13, 62 get ME_TLI  picture "##" valid(ME_TLI > 0 .and. ME_TLI < 9)
    @ 14, 62 get ME_QLT  picture "@!" valid(rat(ME_QLT,"S#N") > 0) 
    read

    if lastkey() = 27
      restscreen(06, 20, 21, 75, M_TELA)
      return ""
    endif

  save all like ME_* to ETIPRO

  msg("* * * PARAMETRO ALTERADO * * *")
 
  restscreen(07, 20, 21, 75, M_TELA)

return ""

*****************
function IMPREETQ
*****************

for R = 1 to ME_TLI
  U = str(R, 1, 0)
  for S = 1 to ME_CAR
    T = str(S, 1, 0)
    ?? M_ETIQ&U&T
    ?? space(ME_COE)
  next 
    ?
next

for R = 1 to ME_LIE
 ?
next

return "" 

****************
function TLETQ01
****************

 nbox(07, 13, 18, 66,"W/W+",.t.)
 setcolor("B/W")
    @ 08, 14 say     " Codigo  :                                          "
    @ 09, 14 say     "컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴"
    @ 10, 14 say     "  M    1 :                                          "
    @ 11, 14 say     "  E    2 :                                          "
    @ 12, 14 say     "  N    3 :                                          "
    @ 13, 14 say     "  S    4 :                                          "
    @ 14, 14 say     "  A    5 :                                          "
    @ 15, 14 say     "  G    6 :                                          "
    @ 16, 14 say     "  E    7 :                                          "
    @ 17, 14 say     "  M    8 :                                          "
set color to

return ""

****************
function EDETQ01
****************

    SetColor(_COREDICAO_)
    @ 10, 25 get     M_ETQDS1 picture "@!"
    @ 11, 25 get     M_ETQDS2 picture "@!"    
    @ 12, 25 get     M_ETQDS3 picture "@!"    
    @ 13, 25 get     M_ETQDS4 picture "@!"            
    @ 14, 25 get     M_ETQDS5 picture "@!"            
    @ 15, 25 get     M_ETQDS6 picture "@!"               
    @ 16, 25 get     M_ETQDS7 picture "@!"            
    @ 17, 25 get     M_ETQDS8 picture "@!"               
    read

return ""

****************
function MSETQ01
****************

  setcolor("N/W*")
    @ 08, 25 say ETQCOD
    @ 10, 25 say ETQDS1 
    @ 11, 25 say ETQDS2 
    @ 12, 25 say ETQDS3 
    @ 13, 25 say ETQDS4 
    @ 14, 25 say ETQDS5 
    @ 15, 25 say ETQDS6 
    @ 16, 25 say ETQDS7 
    @ 17, 25 say ETQDS8 
 set color to
  
return ""

****************
function GRETQ01(cACAO)                       && grava pedido
****************

  sqlCAMPO = {}
  sqlCHAVE = {}
  sqlARQUI = {"AETQ00",(cACAO)}

  aadd(sqlCHAVE,{"ETQCOD",aspas(M_ETQCOD)})
  if !cACAO $ "#DELETE#SELECT#"
    aadd(sqlCAMPO,{"ETQCOD",M_ETQCOD,.T.})
    aadd(sqlCAMPO,{"ETQDS1",M_ETQDS1,.T.})
    aadd(sqlCAMPO,{"ETQDS2",M_ETQDS2,.T.})
    aadd(sqlCAMPO,{"ETQDS3",M_ETQDS3,.T.})
    aadd(sqlCAMPO,{"ETQDS4",M_ETQDS4,.T.})
    aadd(sqlCAMPO,{"ETQDS5",M_ETQDS5,.T.})
    aadd(sqlCAMPO,{"ETQDS6",M_ETQDS6,.T.})
    aadd(sqlCAMPO,{"ETQDS7",M_ETQDS7,.T.})
    aadd(sqlCAMPO,{"ETQDS8",M_ETQDS8,.T.})
  endif

  executasql()
  return ""

  
return ""
