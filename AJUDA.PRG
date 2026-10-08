#xcommand save get to <var> => <var> := aclone(M->GetList) ; M->GetList := {}
#xcommand restore get from <var> => M->GetList := aclone(<var>)

#include "inkey.ch"

***************
function FUNCLI
***************

  M_TELA40 = savescreen(02, 02, 22, 78) 

  sai = .f.
  save get to M_GETANT

  SET COLOR TO

  tk :=0  && valor da tecla de controle pressionada pelo usuario
  CONTADOR := nPOSICAO := L_INICIAL := 7 && linha da tela
  L_FINAL := U_LINHA := 18 && LINHA FINAL

  tlfuncli()
  DrawFn( 03, "Altera" )   //VL-Desenha fun‡Æo na linha 24

  select ACLI00
  set order to 2
  set filter to CLICOD # 0
  dbseek("A",.t.)

  do while !SAI

    CONTADOR:=L_INICIAL    && primeira linha da tela l = 7

    do while CONTADOR<=L_FINAL .and. !eof()
      setcolor("GR+/BG")
      if dadoscli(CONTADOR,"I")
        skip
      endif
      setcolor("")
      CONTADOR++
    enddo

    CONTADOR:=CONTADOR-1
    U_LINHA:=CONTADOR

    skip nPOSICAO-(CONTADOR+1)

    if CONTADOR<L_FINAL
      if nPOSICAO>L_INICIAL  
        nPOSICAO:=CONTADOR
        go bottom
      endif

      do while CONTADOR<L_FINAL
        CONTADOR:=CONTADOR+1
        setcolor("GR+/BG+")
        @ CONTADOR, 05 say "³       ³                                     ³                   ³  ³" 
        setcolor("")
      enddo
    endif

    setcolor("W+/N")
    dadoscli(nPOSICAO,"N")
    setcolor("")

    lPesq = .f.

    do while .t.
      TK:=inkey(0)
      do case

        case TK=4 .or. TK = 19
          loop
        case TK=24
          skip
          if eof()
            msg("Fim do Arquivo !")
            loop
          else
            skip -1
          endif
        
          if nPOSICAO<L_FINAL
            setcolor("GR+/BG")
            dadoscli(nPOSICAO,"I")
            nPOSICAO:=nPOSICAO+1
            skip
            set color to W+/N
            dadoscli(nPOSICAO,"N")
            set color to
            loop
          else
            * Caso a tela deva ser "rolada"
            setcolor("GR+/BG")
            dadoscli(CONTADOR,"I")
            skip

            if !eof()
              scroll(7,6,18,73,1)
            endif
          
            setcolor("W+/N")
            dadoscli(CONTADOR,"N")
            set color to
            loop
          endif
        case TK=K_F3 // ALTERA CLIENTE
          M_COR = setcolor()
          setcolor("")
          M_PROC  = CLINOM
          setcolor("N/W,BG+/B") 
          @ 20, 06 get M_PROC picture "@!"
          read
          select ACLI00
          do while .t.
            if rlock()
              replace CLINOM with M_PROC
              unlock
              commit
              exit
            endif
          enddo
          setcolor("W+/N")
          dadoscli(nPOSICAO,"I")
          set color to GR+/BG+
            @ 20, 05 say  "³       ³                                     ³                   ³  ³" 
          setcolor("")       
          loop 
        case TK=5
          if bof()
            set color to rb+
            msg("Inicio do Arquivo !")
            set color to
            loop
          endif
        
          IF nPOSICAO>L_INICIAL 
            * Caso a tela nao precise ser "rolada"
          
            if eof()
              skip -1
            endif

            setcolor("GR+/BG")
            Dadoscli(nPOSICAO,"I")
            nPOSICAO:=nPOSICAO-1
            skip -1
            set color to W+/N
            Dadoscli(nPOSICAO,"N")
            set color to
            loop
          else
            * Caso a tela deva ser "rolada"
            set color to
          
            if eof()
              skip -1
            endif
          
            setcolor("GR+/BG")
            dadoscli(nPOSICAO,"I")
            skip -1
          
            if !bof()
              scroll(7,6,18,73,-1)
            endif
          
            setcolor("W+/N")
            dadoscli(nPOSICAO,"N")
            set color to
            loop
          endif
        
      CASE tk=18
        if bof()
          set color to rg+
          msg("Inicio do Arquivo !")
          set color to
          loop
        endif

        if lastrec()>= (L_FINAL-L_INICIAL)
          skip -(((L_FINAL+1)-L_INICIAL)+(nPOSICAO-L_INICIAL))
        else
          go top
        endif

        exit
      CASE tk=16
        if bof()
          set color to rg+
          msg("Inicio do Arquivo !")
          set color to
          loop
        endif

        if lastrec()>=9
          skip L_INICIAL-(U_LINHA+1)    
        else
          go top
        endif
        exit
      case TK=3
*        if U_LINHA<L_FINAL
*          set color to "g+b/*8"
*          msg("Fim do Arquivo !")
*          set color to
*          loop
*        endif

        skip -(nPOSICAO-L_INICIAL)
        skip (L_FINAL-L_INICIAL)+1

        if eof()
          set color to "g+b/*8"
          msg("Fim do Arquivo !")
          set color to
          loop
        endif

        exit
      case TK=1
        go top
        exit
      case TK=-9
        calcula()
      case TK=6
        go bottom
        
        if lastrec()>=9
          skip -9
        else
          go top
        endif
        
        exit

      case TK=27
         clear typeahead
         keyboard " "
         sai:=.T.
        exit
      case TK=13
        do case 
       case _FUNCLI_ = "KEYBOARD"
         m_key = CLINOM
         if !empty(left(NOMEPAI,20))
           m_key += left(NOMEPAI,20)
           m_key += left(CLITEL1,20)
         endif
         keyboard m_key
       case _FUNCLI_ = "NFS"
          if M_NFSCLI = 0 
            M_NFSCLI=CLICOD
            M_DUPCLI=CLICOD
          endif
       case _FUNCLI_ = "NFE"
            if M_NFEFOR = 0
              M_NFEFOR=CLICOD
            endif
       case _FUNCLI_ = "CLIENTE"
              M_CLICOD=CLICOD
       case _FUNCLI_ = "PEDIDO"
            if M_PEDCLI = 0
              M_PEDCLI=CLICOD
            endif
       case _FUNCLI_ = "CONREC"
            if M_DUPCLI = 0
              M_DUPCLI=CLICOD
            endif
       case _FUNCLI_ = "CONPAG"
            if M_DUPCLI = 0
              M_DUPCLI=CLICOD
            endif
       case _FUNCLI_ = "KARDEX"
            if M_KARCLF = 0
              M_KARCLF=CLICOD
            endif
       case _FUNCLI_ = "PRODUTO"
            if M_PCAFOR = 0
              M_PCAFOR=CLICOD
            endif
       case _FUNCLI_ = "REQUISICAO"
            if M_REQCLI = 0
              M_REQCLI=CLICOD
              M_CODFIN=CLICOD
            endif
       case _FUNCLI_ = "PEN"
            if M_PENCLI = 0
              M_PENCLI=CLICOD
            endif
       case _FUNCLI_ = "ORCAMENTO"
            if M_ORCCLI = 0
              M_ORCCLI=CLICOD
            endif
       case _FUNCLI_ = "CUPOM"
            if M_CUPCLI = 0
              M_CUPCLI=CLICOD
            endif
        endcase 
        sai:=.T.
        exit        
      case TK # 13
          keyboard chr(TK)
          M_COR = setcolor()
          setcolor("")
          M_PROC = space(37)
          setcolor("N/W,BG+/B") 
          @ nPOSICAO, 14 get M_PROC picture "@!"
          read
          select ACLI00
          dbseek(M_PROC, .t.)

          nPOSICAO := 7
          CONTADOR := 7   && PRIMEIRA LINHA DA TELA L = 7

          setcolor("GR+/BG+")
            for ZZ = 7 to 18
              @ ZZ, 05 say "³       ³                                     ³                   ³  ³" 
            next
          setcolor("")
          
          do while CONTADOR<=L_FINAL .and. !eof()
            setcolor("GR+/BG")
            dadoscli(CONTADOR,"I")
            skip
            CONTADOR++
          enddo
    
          CONTADOR:=CONTADOR-1
          U_LINHA:=CONTADOR
    
          skip nPOSICAO-(CONTADOR+1)

          setcolor("W+/N")
          dadoscli(nPOSICAO,"N")
          setcolor("")
          lPesq = .t.
      endcase
    enddo

  enddo

select ACLI00
set cursor on
set relation to
set order to 1
set cursor on
set filter to

restore get from M_GETANT

restscreen(02, 02, 22, 78, M_TELA40)

keyfun()
return ""

***************
function DADOSCLI
***************

  PARAMETERS lin,tipo

  M_COR = setcolor()

  setcolor("GR+/BG+")
   @  lin, 05 say "³       ³                                     ³                   ³  ³" 
  setcolor(M_COR)

  setcolor(M_COR)
  @ lin, 06  say  str(CLICOD, 7)
  @ lin, 14  say  pad(CLINOM, 37)
  @ lin, 52  say  pad(CLIMUN2,19)
  @ lin, 72  say  CLIUF2

  @ 20,  06 say  pad(CLIEND2, 52)
  @ 20,  59 say  pad(CLITEL1, 15)

return .t.

*****************
function TLFUNCLI
*****************

* sombra(06, 05, 18, 74,_SOMBRA_)

  set color to GR+/BG+
    @ 04, 05 say     "ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄ¿" 
    @ 05, 05 say     "³Codigo ³           NOME DO CLIENTE           ³    Municipio      ³Uf³" 
    @ 06, 05 say     "ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄ´" 
    @ 07, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 08, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 09, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 10, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 11, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 12, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 13, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 14, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 15, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 16, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 17, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 18, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 19, 05 say     "ÃÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄ´"
    @ 20, 05 say     "³                                                    ³               ³"
    @ 21, 05 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
  set color to

return ""

***************
function FUNPRO
***************

funpronovo()

return ""


***************
function FUNVEN
***************

private M_NOME ,;
        M_NOME1,;
        K      ,; 
        Y      ,;
        L      ,;
        M_TELA ,;
        M_TECLA

private MT_VEN[7] 
declare MT_VEN[7]
 
    M_TELA = savescreen(04, 04, 18, 75) 

    save get to M_GETANT

    do while .t.

      tlfunven()

      L = 10  

      M_NOME = space(30)

      setcolor("GR+/BG+,GR+/BG")
        @ 08, 19 get M_NOME picture "@!"
        read
      setcolor("")

      if lastkey() = 27
        exit
      endif

      M_TECLA = 32

      select AVEN00

      set order to 2

      go top

        set softseek on
          seek M_NOME
        set softseek off

        if eof()
          loop
        endif

        for S = 1 to 7
          MT_VEN[S] = "      ³                                    ³                     ³  ³" 
        next

        do while !eof()

          if VENCOD = 0
            skip
            loop
          endif

          MT_VEN[L - 9] = str(VENCOD, 6) + "³" + pad(VENNOM, 36) + "³" + pad(VENTEL, 21) + "³" + VENEST + "³"

            if L > 15
              M_TECLA = visualven(MT_VEN)
              if M_TECLA = 27
                exit
              endif
              if M_TECLA = 13
                exit
              endif
              if M_TECLA = 18
                skip - 13
              endif
              set color to GR+/BG+
                for K = 10 to 16 
                  @ K, 05 say "³      ³                                    ³                     ³  ³" 
                next
              set color to 
              L = 9
            endif

            L = L + 1

            skip

        enddo

       L = L - 1

       if M_TECLA = 13
         exit
       endif  

       if M_TECLA != 27 
         if M_TECLA != 13
           visualven(MT_VEN)
         endif
       endif

       if lastkey() = 13
         exit
       endif  

       set cursor on

    enddo

    set relation to
    set order to 1
    set cursor on

    restscreen(04, 04, 18, 75, M_TELA) 

    keyfun()

    restore get from M_GETANT

return ""

*****************
function TLFUNVEN
*****************

  sombra(07, 05, 17, 74,_SOMBRA_)

  set color to GR+/BG+
    @ 07, 05 say     "ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄVendedorÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄ¿" 
    @ 08, 05 say     "³Codigo³Nome:                               ³     Telefone        ³Uf³" 
    @ 09, 05 say     "ÃÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄ´" 
    @ 10, 05 say     "³      ³                                    ³                     ³  ³" 
    @ 11, 05 say     "³      ³                                    ³                     ³  ³" 
    @ 12, 05 say     "³      ³                                    ³                     ³  ³" 
    @ 13, 05 say     "³      ³                                    ³                     ³  ³" 
    @ 14, 05 say     "³      ³                                    ³                     ³  ³" 
    @ 15, 05 say     "³      ³                                    ³                     ³  ³" 
    @ 16, 05 say     "³      ³                                    ³                     ³  ³" 
    @ 17, 05 say     "ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÙ" 
  set color to
   
return ""

******************
function VISUALVEN
******************

parameters V1 

private S      ,;
        M_OPC  ,;
        M_AREA ,;
        M_TELA

  M_AREA = alias()

  do while .t.

    set color to GR+/BG+,N/W
      M_OPC = achoice(10,6,16,73,V1,,"mostra")
    set color to 

    if rat(str(lastkey(), 2, 0)," 3#27#18") > 0
      exit
    endif

    do case 
       case _FUNVEN_ = "NFS"
            M_NFSVEN=val(left(V1[M_OPC],6))
       case _FUNVEN_ = "PRE-VENDA"
            M_PREVEN=val(left(V1[M_OPC],6))
       case _FUNVEN_ = "PEDIDO"
            M_PEDVEN=val(left(V1[M_OPC],6))
       case _FUNVEN_ = "CONREC"
            M_DUPVEN=val(left(V1[M_OPC],6))
       case _FUNVEN_ = "CONPAG"
            M_DUPVEN=val(left(V1[M_OPC],6))
       case _FUNVEN_ = "CLIENTE"
            M_CLIVEN=val(left(V1[M_OPC],6))
       case _FUNVEN_ = "ORCAMENTO"
            M_ORCVEN=val(left(V1[M_OPC],6))
    endcase

    exit

  enddo

  select &M_AREA

return lastkey()

***************
function FUNCPG
***************

private M_NOME ,;
        M_NOME1,;
        K      ,; 
        Y      ,;
        L      ,;
        M_TELA ,;
        M_TECLA

private MT_CPG[7] 
declare MT_CPG[7]
 
    M_TELA = savescreen(04, 04, 18, 75) 

    save get to M_GETANT

    do while .t.

        tlfuncpg()
  
        L = 10

        M_NOME = space(29)
 
        setcolor("GR+/BG+,GR+/BG")
          @ 08, 19 get M_NOME picture "@!"
          read
        setcolor("")

        if lastkey() = 27
          exit
        endif

        M_TECLA = 32

        select ACPG00
        set order to 1
        go top

        dbseek(str(val(M_NOME), 3, 0),.t.)

        if eof()
          loop
        endif


        for S = 1 to 7
          MT_CPG[S] = "      ³                                   ³ ³   ³   ³   ³   ³   ³   ³" 
        next

        do while !eof()

          if CPGCOD = 0
            skip
            loop
          endif

            MT_CPG[L - 9] = str(CPGCOD, 6) + "³" + pad(CPGDES, 35) + "³" + str(CPGPAR, 1, 0) + "³" + str(CPGPR1, 3 , 0) + "³" + str(CPGPR2, 3, 0) + "³" + str(CPGPR3, 3, 0) + "³" + str(CPGPR4, 3, 0) + "³" + str(CPGPR5, 3, 0) + "³" + str(CPGPR6, 3, 0) + "³" 

            if L > 15
              M_TECLA = visualcpg(MT_CPG)
              if M_TECLA = 27
                exit
              endif
              if M_TECLA = 13
                exit
              endif
              if M_TECLA = 18
                skip - 13
              endif
              set color to GR+/BG+
                for K = 10 to 16 
                  @ K, 05 say     "³      ³                                   ³ ³   ³   ³   ³   ³   ³   ³" 
                next
              set color to 
              L = 9
            endif

            L = L + 1

            skip

        enddo

       L = L - 1

       if M_TECLA = 13
         exit
       endif  

       if M_TECLA != 27 
         if M_TECLA != 13
           visualcpg(MT_CPG)
         endif
       endif

       if lastkey() = 13
         exit
       endif  

       set cursor on

    enddo

    set relation to
    set order to 1
    set cursor on

    restscreen(04, 04, 18, 75, M_TELA) 

    keyfun()

    restore get from M_GETANT

return ""

*****************
function TLFUNCPG
*****************

  sombra(07, 05, 17, 74,_SOMBRA_)

  set color to GR+/BG+
    @ 07, 05 say     "ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄPagamentosÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄ¿" 
    @ 08, 05 say     "³C¢digo³Nome:                              ³P³Pz1³Pz2³Pz3³Pz4³Pz5³Pz6³" 
    @ 09, 05 say     "ÃÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄ´" 
    @ 10, 05 say     "³      ³                                   ³ ³   ³   ³   ³   ³   ³   ³" 
    @ 11, 05 say     "³      ³                                   ³ ³   ³   ³   ³   ³   ³   ³" 
    @ 12, 05 say     "³      ³                                   ³ ³   ³   ³   ³   ³   ³   ³" 
    @ 13, 05 say     "³      ³                                   ³ ³   ³   ³   ³   ³   ³   ³" 
    @ 14, 05 say     "³      ³                                   ³ ³   ³   ³   ³   ³   ³   ³" 
    @ 15, 05 say     "³      ³                                   ³ ³   ³   ³   ³   ³   ³   ³" 
    @ 16, 05 say     "³      ³                                   ³ ³   ³   ³   ³   ³   ³   ³" 
    @ 17, 05 say     "ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÙ" 
  set color to

return ""

******************
function VISUALCPG
******************

parameters V1 

private S      ,;
        M_OPC  ,;
        M_AREA ,;
        M_TELA

  M_AREA = alias()


  do while .t.

    set color to GR+/BG+,N/W
      M_OPC = achoice(10,6,16,73,V1,,"mostra")
    set color to 

    if rat(str(lastkey(), 2, 0)," 3#27#18") > 0
      exit
    endif

    do case 
       case _FUNCPG_ = "NFS"
              M_NFSCPG=val(left(V1[M_OPC], 6))
       case _FUNCPG_ = "NFE"
              M_NFECPG=val(left(V1[M_OPC], 6))
       case _FUNCPG_ = "PEDIDO"
              M_PEDCPG=val(left(V1[M_OPC], 6))
       case _FUNCPG_ = "CONREC"
              M_DUPCPG=val(left(V1[M_OPC], 6))
       case _FUNCPG_ = "CONPAG"
              M_DUPCPG=val(left(V1[M_OPC], 6))
       case _FUNCPG_ = "ORCAMENTO"
              M_ORCCPG=val(left(V1[M_OPC], 6))
    endcase

    exit

  enddo

  select &M_AREA


return lastkey()

***************
function FUNTRA
***************

private M_NOME ,;
        M_NOME1,;
        K      ,; 
        Y      ,;
        L      ,;
        M_TELA ,;
        M_TECLA

private MT_TRA[7] 
declare MT_TRA[7]
 
    M_TELA = savescreen(04, 04, 18, 75) 

    save get to M_GETANT

    do while .t.

      tlfuntra()

      L = 10  

      M_NOME = space(30)

      setcolor("GR+/BG+,GR+/BG")
        @ 08, 19 get M_NOME picture "@!"
        read
      setcolor("")

      if lastkey() = 27
        exit
      endif

      M_TECLA = 32

      select ATRA00

      set order to 2

      go top

        set softseek on
          seek M_NOME
        set softseek off

        if eof()
          loop
        endif


        for S = 1 to 7
          MT_TRA[S] = "      ³                                    ³                   ³ ³  ³"
        next

        do while !eof()

          if TRACOD = 0
            skip
            loop
          endif

          MT_TRA[L - 9] = str(TRACOD, 6) + "³" + pad(TRANOM, 36) + "³" + pad(TRAEND, 19) + "³" + left(TRAVIA, 1) + "³" + TRAEST + "³"

            if L > 15
              M_TECLA = visualtra(MT_TRA)
              if M_TECLA = 27
                exit
              endif
              if M_TECLA = 13
                exit
              endif
              if M_TECLA = 18
                skip - 13
              endif
              set color to GR+/BG+
                for K = 10 to 16 
                  @ K, 05 say "³      ³                                    ³                   ³ ³  ³" 
                next
              set color to 
              L = 9
            endif

            L = L + 1

            skip

        enddo

       L = L - 1

       if M_TECLA = 13
         exit
       endif  

       if M_TECLA != 27 
         if M_TECLA != 13
           visualtra(MT_TRA)
         endif
       endif

       if lastkey() = 13
         exit
       endif  

       set cursor on

    enddo

    set relation to
    set order to 1
    set cursor on

    restscreen(04, 04, 18, 75, M_TELA) 

    keyfun()


    restore get from M_GETANT

return ""

*****************
function TLFUNTRA
*****************

  sombra(07, 05, 17, 74,_SOMBRA_)

  set color to GR+/BG+

    @ 07, 05 say     "ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄTransporteÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÂÄÄ¿" 
    @ 08, 05 say     "³Codigo³Nome:                               ³     Endereco      ³V³Uf³" 
    @ 09, 05 say     "ÃÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÅÄÄ´" 
    @ 10, 05 say     "³      ³                                    ³                   ³ ³  ³" 
    @ 11, 05 say     "³      ³                                    ³                   ³ ³  ³" 
    @ 12, 05 say     "³      ³                                    ³                   ³ ³  ³" 
    @ 13, 05 say     "³      ³                                    ³                   ³ ³  ³" 
    @ 14, 05 say     "³      ³                                    ³                   ³ ³  ³" 
    @ 15, 05 say     "³      ³                                    ³                   ³ ³  ³" 
    @ 16, 05 say     "³      ³                                    ³                   ³ ³  ³" 
    @ 17, 05 say     "ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÁÄÄÙ" 
  set color to
   
return ""

******************
function VISUALTRA
******************

parameters V1 

private S      ,;
        M_OPC  ,;
        M_AREA ,;
        M_TELA

  M_AREA = alias()


  do while .t.

    set color to GR+/BG+,N/W
      M_OPC = achoice(10,6,16,73,V1,,"mostra")
    set color to 

    if rat(str(lastkey(), 2, 0)," 3#27#18") > 0
      exit
    endif

    do case 
       case _FUNTRA_ = "NFS"
            if M_NFSTRA = 0
              M_NFSTRA=val(left(V1[M_OPC],6))
            endif
       case _FUNTRA_ = "PEDIDO"
            if M_PEDTRA = 0
              M_PEDTRA=val(left(V1[M_OPC],6))
            endif
       case _FUNTRA_ = "CLIENTE"
            if M_CLITRA = 0
              M_CLITRA=val(left(V1[M_OPC],6))
            endif
       case _FUNTRA_ = "ORCAMENTO"
            if M_ORCTRA = 0
              M_ORCTRA=val(left(V1[M_OPC],6))
            endif
    endcase

    exit

  enddo

  select &M_AREA


return lastkey()


***************
function MOSTRA
***************

parameters  M_MODO, M_ELEM, M_POSI

 if rat(str(lastkey(), 2, 0)," 3#27#18") > 0
    return 0
 endif

 if rat(str(lastkey(), 2, 0),"13") > 0
   M_OPC = M_ELEM
   return 1
 endif

return 2

***************
function FUNFOR
***************

  M_TELA40 = savescreen(02, 02, 22, 78) 

  sai = .f.
  save get to M_GETANT

  SET COLOR TO

  tk :=0  && valor da tecla de controle pressionada pelo usuario
  CONTADOR := nPOSICAO := L_INICIAL := 7 && linha da tela
  L_FINAL := U_LINHA := 18 && LINHA FINAL

  tlfunfor()

  select AFOR00
  set order to 2
  set filter to FORCOD # 0
  dbseek("A",.t.)

  DrawFn( 03, "Altera" )   //VL-Desenha fun‡Æo na linha 24

  do while !SAI

    CONTADOR:=L_INICIAL    && primeira linha da tela l = 7

    do while CONTADOR<=L_FINAL .and. !eof()
      setcolor("GR+/BG")
      if dadosfor(CONTADOR,"I")
        skip
      endif
      setcolor("")
      CONTADOR++
    enddo

    CONTADOR:=CONTADOR-1
    U_LINHA:=CONTADOR

    skip nPOSICAO-(CONTADOR+1)

    if CONTADOR<L_FINAL
      if nPOSICAO>L_INICIAL  
        nPOSICAO:=CONTADOR
        go bottom
      endif

      do while CONTADOR<L_FINAL
        CONTADOR:=CONTADOR+1
        setcolor("GR+/BG+")
        @ CONTADOR, 05 say "³       ³                                     ³                   ³  ³" 
        setcolor("")
      enddo
    endif

    setcolor("W+/N")
    dadosfor(nPOSICAO,"N")
    setcolor("")

    lPesq = .f.

    do while .t.
      TK:=inkey(0)
      do case

        case TK=4 .or. TK = 19
          loop
        case TK=24
          skip
          if eof()
            msg("Fim do Arquivo !")
            loop
          else
            skip -1
          endif
        
          if nPOSICAO<L_FINAL
            setcolor("GR+/BG")
            dadosfor(nPOSICAO,"I")
            nPOSICAO:=nPOSICAO+1
            skip
            set color to W+/N
            dadosfor(nPOSICAO,"N")
            set color to
            loop
          else
            * Caso a tela deva ser "rolada"
            setcolor("GR+/BG")
            dadosfor(CONTADOR,"I")
            skip

            if !eof()
              scroll(7,6,18,73,1)
            endif
          
            setcolor("W+/N")
            dadosfor(CONTADOR,"N")
            set color to
            loop
          endif
        case TK=K_F3 // ALTERA CLIENTE
          M_COR = setcolor()
          setcolor("")
          M_PROC  = FORNOM
          setcolor("N/W,BG+/B") 
          @ 20, 06 get M_PROC picture "@!"
          read
          select AFOR00
          do while .t.
            if rlock()
              replace FORNOM with M_PROC
              unlock
              commit
              exit
            endif
          enddo
          setcolor("W+/N")
          dadosfor(nPOSICAO,"I")
          set color to GR+/BG+
             @ 20, 05 say     "³                                                    ³               ³"
          setcolor("")       
          loop 
        case TK=5
          if bof()
            set color to rb+
            msg("Inicio do Arquivo !")
            set color to
            loop
          endif
        
          IF nPOSICAO>L_INICIAL 
            * Caso a tela nao precise ser "rolada"
          
            if eof()
              skip -1
            endif

            setcolor("GR+/BG")
            dadosfor(nPOSICAO,"I")
            nPOSICAO:=nPOSICAO-1
            skip -1
            set color to W+/N
            Dadosfor(nPOSICAO,"N")
            set color to
            loop
          else
            * Caso a tela deva ser "rolada"
            set color to
          
            if eof()
              skip -1
            endif
          
            setcolor("GR+/BG")
            dadosfor(nPOSICAO,"I")
            skip -1
          
            if !bof()
              scroll(7,6,18,73,-1)
            endif
          
            setcolor("W+/N")
            dadosfor(nPOSICAO,"N")
            set color to
            loop
          endif
        
      CASE tk=18
        if bof()
          set color to rg+
          msg("Inicio do Arquivo !")
          set color to
          loop
        endif

        if lastrec()>= (L_FINAL-L_INICIAL)
          skip -(((L_FINAL+1)-L_INICIAL)+(nPOSICAO-L_INICIAL))
        else
          go top
        endif

        exit
      CASE tk=16
        if bof()
          set color to rg+
          msg("Inicio do Arquivo !")
          set color to
          loop
        endif

        if lastrec()>=9
          skip L_INICIAL-(U_LINHA+1)    
        else
          go top
        endif
        exit
      case TK=3
*        if U_LINHA<L_FINAL
*          set color to "g+b/*8"
*          msg("Fim do Arquivo !")
*          set color to
*          loop
*        endif

        skip -(nPOSICAO-L_INICIAL)
        skip (L_FINAL-L_INICIAL)+1

        if eof()
          set color to "g+b/*8"
          msg("Fim do Arquivo !")
          set color to
          loop
        endif

        exit
      case TK=1
        go top
        exit
      case TK=-9
        calcula()
      case TK=6
        go bottom
        
        if lastrec()>=9
          skip -9
        else
          go top
        endif
        
        exit

      case TK=27
         clear typeahead
         keyboard " "
         sai:=.T.
        exit
      case TK=13
    do case 
       case _FUNFOR_ = "NFS"
            if M_NFSCLI = 0
              M_NFSCLI=FORCOD
            endif
       case _FUNFOR_ = "NFE"
            if M_NFEFOR = 0
              M_NFEFOR=FORCOD
            endif
       case _FUNFOR_ = "CONPAG"
            if M_DUPFOR = 0
              M_DUPFOR=FORCOD
            endif
       case _FUNFOR_ = "KARDEX"
            if M_KARCLF = 0
              M_KARCLF=FORCOD
            endif
       case _FUNFOR_ = "PRODUTO"
            if M_PCAFOR = 0
              M_PCAFOR=FORCOD
            endif
       case _FUNFOR_ = "PEDIDO"
            if M_PCAFOR = 0
              M_PCAFOR=FORCOD
            endif
            if type("M_PEDCLI") = "N"
              if M_PEDCLI = 0
                M_PEDCLI=FORCOD
              endif
            endif
       case _FUNFOR_ = "ORCAMENTO"
            if M_PCAFOR = 0
              M_PCAFOR=FORCOD
            endif
       case _FUNFOR_ = "REQUISICAO"
            if M_PCAFOR = 0
              M_PCAFOR=FORCOD
            endif
       case _FUNFOR_ = "FORNECEDOR"
            if M_FORCOD = 0
              M_FORCOD=FORCOD
            endif
    endcase
        sai:=.T.
        exit        
      case TK # 13
          keyboard chr(TK)
          M_COR = setcolor()
          setcolor("")
          M_PROC = space(37)
          setcolor("N/W,BG+/B") 
          @ nPOSICAO, 14 get M_PROC picture "@!"
          read
          select AFOR00
          dbseek(M_PROC, .t.)
          nPOSICAO := 7
          CONTADOR := 7   && PRIMEIRA LINHA DA TELA L = 7

          setcolor("GR+/BG+")
            for ZZ = 7 to 18
              @ ZZ, 05 say "³       ³                                     ³                   ³  ³" 
            next
          setcolor("")
          
          do while CONTADOR<=L_FINAL .and. !eof()
            setcolor("GR+/BG")
            dadosfor(CONTADOR,"I")
            skip
            CONTADOR++
          enddo
    
          CONTADOR:=CONTADOR-1
          U_LINHA:=CONTADOR
    
          skip nPOSICAO-(CONTADOR+1)

          setcolor("W+/N")
          dadosfor(nPOSICAO,"N")
          setcolor("")
          lPesq = .t.
      endcase
    enddo
  enddo

select AFOR00
set cursor on
set relation to
set order to 1
set cursor on
set filter to

restore get from M_GETANT

restscreen(02, 02, 22, 78, M_TELA40)

keyfun()
return ""

***************
function DADOSFOR
***************

  PARAMETERS lin,tipo

  M_COR = setcolor()

  setcolor("GR+/BG+")
   @  lin, 05 say "³       ³                                     ³                   ³  ³" 
  setcolor(M_COR)

  setcolor(M_COR)
  @ lin, 06  say  str(FORCOD, 7)
  @ lin, 14  say  pad(FORNOM, 37)
  @ lin, 52  say  pad(FORMUN,19)
  @ lin, 72  say  FOREST

  @ 20,  06 say  pad(FOREND, 52)
  @ 20,  59 say  pad(FORTEL, 15)

return .t.

*****************
function TLFUNFOR
*****************

* sombra(06, 05, 18, 74,_SOMBRA_)

  set color to GR+/BG+
    @ 04, 05 say     "ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄ¿" 
    @ 05, 05 say     "³Codigo ³        NOME DO FORNECEDOR           ³    Municipio      ³Uf³" 
    @ 06, 05 say     "ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄ´" 
    @ 07, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 08, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 09, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 10, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 11, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 12, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 13, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 14, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 15, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 16, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 17, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 18, 05 say     "³       ³                                     ³                   ³  ³" 
    @ 19, 05 say     "ÃÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄ´"
    @ 20, 05 say     "³                                                    ³               ³"
    @ 21, 05 say     "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
  set color to

return ""

***************
function FUNPLX
***************

private M_NOME ,;
        M_NOME1,;
        K      ,; 
        Y      ,;
        L      ,;
        M_TELA ,;
        M_TECLA

private MT_PLX[7] 
declare MT_PLX[7]
 
    M_TELA = savescreen(04, 04, 18, 75) 


    save get to M_GETANT

    do while .t.

      tlfunplx()

      L = 10  

      M_NOME = space(30)

      setcolor("GR+/BG+,GR+/BG+")
        @ 08, 19 get M_NOME picture "@!"
        read
      setcolor("")

      if lastkey() = 27
        exit
      endif

      M_TECLA = 32

      select APLX00

      ( dbsetorder(2) , dbseek(str(ME_EMP, 2, 0) + M_NOME, .t.) )

      if eof()
        loop
      endif


      for S = 1 to 7
        MT_PLX[S] =  "      ³                                    ³          ³             ³" 
      next

      do while !eof()

        if PLXAPL = 0
          skip
          loop
        endif

        if PLXEMP != ME_EMP
          exit
        endif

        MT_PLX[L - 9] = str(PLXAPL, 6) + "³" + pad(PLXNOM, 36) + "³" + iif(PLXSIT="A","ANALITICA ","SINTETICA ") + "³" + iif(PLXTIP="D","DEVEDORA     ","CREDORA     ") 

        if L > 15
          M_TECLA = visualplx(MT_PLX)
          if M_TECLA = 27
            exit
          endif
          if M_TECLA = 13
            exit
          endif
          if M_TECLA = 18
            skip - 13
          endif
          set color to GR+/BG+
            for K = 10 to 16 
              @ K, 05 say "³      ³                                    ³          ³             ³" 
            next
          set color to 
          L = 9
        endif

        L = L + 1

        skip

      enddo

      L = L - 1

      if M_TECLA = 13
        exit
      endif  

      if M_TECLA != 27 
        if M_TECLA != 13
          visualplx(MT_PLX)
        endif
      endif

      if lastkey() = 13
        exit
      endif  

      setcursor(1)

    enddo
 
    ( dbsetorder(1) , setcursor(1) )
    
    restscreen(04, 04, 18, 75, M_TELA) 

    keyfun()

    restore get from M_GETANT

return ""

*****************
function TLFUNPLX
*****************

  sombra(07, 05, 17, 74,_SOMBRA_)

  set color to GR+/BG+

    @ 07, 05 say     "ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄAplica‡„oÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
    @ 08, 05 say     "³Codigo³Nome:                               ³ Situa‡„o ³   T i p o   ³" 
    @ 09, 05 say     "ÃÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´" 
    @ 10, 05 say     "³      ³                                    ³          ³             ³" 
    @ 11, 05 say     "³      ³                                    ³          ³             ³" 
    @ 12, 05 say     "³      ³                                    ³          ³             ³" 
    @ 13, 05 say     "³      ³                                    ³          ³             ³" 
    @ 14, 05 say     "³      ³                                    ³          ³             ³" 
    @ 15, 05 say     "³      ³                                    ³          ³             ³" 
    @ 16, 05 say     "³      ³                                    ³          ³             ³" 
    @ 17, 05 say     "ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
  set color to
   
return ""

******************
function VISUALPLX
******************

parameters V1 

private S      ,;
        M_OPC  ,;
        M_AREA ,;
        M_TELA

  M_AREA = alias()


  do while .t.

    set color to GR+/BG+,N/W
      M_OPC = achoice(10,6,16,73,V1,,"mostra")
    set color to 

    if rat(str(lastkey(), 2, 0)," 3#27#18") > 0
      exit
    endif

    do case 
       case _FUNPLX_ = "NFE"
            if M_NFEAPL = 0
              M_NFEAPL=val(left(V1[M_OPC],6))
            endif
       case _FUNPLX_ = "CONREC"
            if M_DUPAPL = 0
              M_DUPAPL=val(left(V1[M_OPC],6))
            endif
       case _FUNPLX_ = "CONPAG"
            if M_DUPAPL = 0
              M_DUPAPL=val(left(V1[M_OPC],6))
            endif
    endcase

    exit

  enddo

  select &M_AREA


return lastkey()


***************
function FUNFIN
***************

private K       ,; 
        Y       ,;
        L       ,;
        M_TELA  ,;
        M_CLICOD
 
    M_TELA = savescreen(04, 04, 21, 76) 

    save get to M_GETANT

    do while .t.

      tlfunfin()

      L = 10  

      M_DUPCLI = 0
      M_TOTDUP = 0
      M_CLICOD = ""

      M_CLICOD = space(7)

      setcolor("I")
        @ 06, 15 get M_CLICOD picture "@R 9999999"
        read
      setcolor("")
   
      M_DUPCLI = val(M_CLICOD)

      if lastkey() = 27 
        exit
      endif

      if M_DUPCLI = 0
        funcli()
        set color to GR+/RB        
          @ 06, 15 say M_DUPCLI picture "#######"
        set color to
      endif

      select ACLI00

      if !dbseek(str(M_DUPCLI, 7, 0))
        msg("* * * CLIENTE NAO CADASTADO * * *")
        loop
      endif

      set color to GR+/RB
        @ 06, 23 say pad(CLINOM, 23)
      set color to 

      select ADCR00

      dbsetorder(2)

      dbseek(str(ME_EMP, 2, 0) + str(M_DUPCLI, 7, 0), .t.)

      do while !eof()

        if !str(DUPEMP, 2, 0) + str(DUPCLI, 7, 0) == str(ME_EMP, 2, 0) + str(M_DUPCLI, 7, 0) 
          exit
        endif

        if DUPHIS != 500
          skip
          loop
        endif

        set color to GR+/RB
          @ L,  5 say DUPNUM   
          @ L, 12 say DUPORD
          @ L, 15 say DUPDTE
          @ L, 24 say DUPVCT
          @ L, 33 say DUPDTP
          @ L, 42 say iif(DUPVLA=0,DUPVLO,DUPVLA) picture "@E ####,###,###.##"
          @ L, 58 say DUPCLI picture "#######"
          @ L, 66 say DUPPOR picture "###"
          @ L, 70 say iif(DUPHIS = 500,str((DUPVCT - date()), 5, 0),"PAGA ") 
        set color to

        if DUPHIS = 500
          M_TOTDUP = M_TOTDUP + DUPVLA
        endif

        if L = 18
          msg("* * * (ENTER) Continua  (ESC) Sai * * *")
          if lastkey() = 27
            exit
          endif
          set color to GR+/RB
            for K = 10 to 18
              @ K,  4 say "³      ³  ³        ³        ³        ³               ³       ³   ³     ³"
            next 
          set color to
          L = 9
        endif

        L = L + 1

        skip

      enddo

      set color to GR+/RB+
        @ 06, 60 say M_TOTDUP picture "@E ###,###,###.##"
      set color to

      msg("* * * FIM DO CLIENTE - TECLE (ENTER) * * *")

      set color to GR+/RB
        for K = 10 to 18
          @ K,  4 say "³      ³  ³        ³        ³        ³               ³       ³   ³     ³"
        next 
      set color to
   
    enddo

    restscreen(04, 04, 21, 76, M_TELA) 

    keyfun()

    restore get from M_GETANT

    setcursor(1)

return ""

*****************
function TLFUNFIN
*****************

sombra(05, 04, 19, 75,_SOMBRA_)

set color to GR+/RB
  @ 05, 04 say     "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
  @ 06, 04 say     "³ Cliente:                                      Debito:                ³"
  @ 07, 04 say     "ÃÄÄÄÄÄÄÂÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÂÄÄÄÄÄ´"
  @ 08, 04 say     "³Titulo³Or³Emissao ³ Vencto ³ Pagto  ³   V a l o r   ³ Cli   ³Bco³Prazo³"
  @ 09, 04 say     "ÃÄÄÄÄÄÄÅÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÅÄÄÄÄÄ´"
  @ 10, 04 say     "³      ³  ³        ³        ³        ³               ³       ³   ³     ³"
  @ 11, 04 say     "³      ³  ³        ³        ³        ³               ³       ³   ³     ³"
  @ 12, 04 say     "³      ³  ³        ³        ³        ³               ³       ³   ³     ³"
  @ 13, 04 say     "³      ³  ³        ³        ³        ³               ³       ³   ³     ³"
  @ 14, 04 say     "³      ³  ³        ³        ³        ³               ³       ³   ³     ³"
  @ 15, 04 say     "³      ³  ³        ³        ³        ³               ³       ³   ³     ³"
  @ 16, 04 say     "³      ³  ³        ³        ³        ³               ³       ³   ³     ³"
  @ 17, 04 say     "³      ³  ³        ³        ³        ³               ³       ³   ³     ³"
  @ 18, 04 say     "³      ³  ³        ³        ³        ³               ³       ³   ³     ³"
  @ 19, 04 say     "ÀÄÄÄÄÄÄÁÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÁÄÄÄÄÄÙ"
set color to 

return "" 

*
* SELECAO
*

*****************
function SELE_HIS
*****************

private M_TELA

M_TELA = savescreen(07, 38, 20, 78)

declare MT_VET1[3],;
        MT_VET2[3],;
        MT_VET3[3]

MT_VET1[1] = "HISDES"
MT_VET1[2] = "HISCOD"
MT_VET1[3] = "HISTIP"

MT_VET2[1] = "@!"
MT_VET2[2] = "#####"
MT_VET2[3] = "@!"

MT_VET3[1] = "Nome do Historico         "
MT_VET3[2] = "Codigo do Historico       "
MT_VET3[3] = "Tipo do Historico         "

 select AHIS00

 set softseek on
   seek "0"
 set softseek off

 keyboard chr(32)

 sombra(07, 38, 19, 77,_SOMBRA_)
 set color to GR+/BG+
   @ 07, 38, 19, 77 box M_FRAME3
   painel(07, 39, 19, 76,"W+/BG+","N/BG+")
   dbedit(08, 40, 18, 75,MT_VET1,"FUNGEN",MT_VET2,MT_VET3)
 set color to 

 restscreen(07, 38, 20, 78, M_TELA)

 set order to 1

return ""

*****************
function SELE_CTA
*****************

private M_TELA

M_TELA = savescreen(07, 38, 20, 78)

declare MT_VET1[3],;
        MT_VET2[3],;
        MT_VET3[3]

MT_VET1[1] = "CTAAGE"
MT_VET1[2] = "CTACTA"
MT_VET1[3] = "CTABAN"

MT_VET2[1] = "@!"
MT_VET2[2] = "@!"
MT_VET2[3] = "###"

MT_VET3[1] = "Nome da Agencia           "
MT_VET3[2] = "Numero da Conta           "
MT_VET3[3] = "Numero do Banco           "

 select ACTA00
 set order to 1

 set softseek on
   seek str(ME_EMP, 2, 0) + "13"
 set softseek off

 keyboard chr(32)

 sombra(07, 38, 19, 77,_SOMBRA_)
 set color to GR+/BG+
   @ 07, 38, 19, 77 box M_FRAME3
   painel(07, 39, 19, 76,"W+/BG+","N/BG+")
   dbedit(08, 40, 18, 75,MT_VET1,"FUNBAN",MT_VET2,MT_VET3)
 set color to 

 restscreen(07, 38, 20, 78, M_TELA)

 set order to 1

return ""

***************
function FUNBAN
***************

parameters MODO    ,;
           PONTEIRO

private POS_CURSOR,REGISTRO,SALVA_TELA

POS_CURSOR = MT_VET1[PONTEIRO]

do case
   case lastkey() = 27
        return(0)
   case lastkey() = 13
        return(0) 
   case CTAEMP   != ME_EMP
        return(1) 
endcase

return(1)

*****************
function SELE_GRP
*****************

private M_TELA

M_TELA = savescreen(07, 38, 20, 78)

declare MT_VET1[3],;
        MT_VET2[3],;
        MT_VET3[3]

MT_VET1[1] = "GRPNOM"
MT_VET1[2] = "GRPCOD"

MT_VET2[1] = "@!"
MT_VET2[2] = "#####"

MT_VET3[1] = "Nome do Grupo             "
MT_VET3[2] = "Codigo do Grupo           "

select AGRP00

( dbsetorder(2) , dbseek("0",.t.) )

keyboard chr(32)

sombra(07, 38, 19, 77,_SOMBRA_)
set color to GR+/BG+
  @ 07, 38, 19, 77 box M_FRAME3
  painel(07, 39, 19, 76,"W+/BG+","N/BG+")
  dbedit(08, 40, 18, 75,MT_VET1,"FUNGEN",MT_VET2)
set color to 

restscreen(07, 38, 20, 78, M_TELA)

dbsetorder(1)

return ""

***************
function FUNGEN
***************

parameters MODO    ,;
           PONTEIRO

private POS_CURSOR,REGISTRO,SALVA_TELA

POS_CURSOR = MT_VET1[PONTEIRO]

do case
   case lastkey() = 27
        return(0)
   case lastkey() = 13
        return(0) 
endcase

return(1)

*****************
function SELE_POR
*****************

private M_TELA

M_TELA = savescreen(07, 38, 20, 78)

declare MT_VET1[3],;
        MT_VET2[3],;
        MT_VET3[3]

MT_VET1[1] = "PORNOM"
MT_VET1[2] = "PORCOD"
MT_VET1[3] = "POROPE"

MT_VET2[1] = "@!"
MT_VET2[2] = "#####"
MT_VET2[3] = "@!"

MT_VET3[1] = "Nome do Portador          "
MT_VET3[2] = "Codigo do Portador        "
MT_VET3[3] = "Operacao do Portador      "

 select APOR00

 set order to 2

 set softseek on
   seek "0"
 set softseek off

 keyboard chr(32)

 sombra(07, 38, 19, 77,_SOMBRA_)
 set color to GR+/BG+
   @ 07, 38, 19, 77 box M_FRAME3
   painel(07, 39, 19, 76,"W+/BG+","N/BG+")
   dbedit(08, 40, 18, 75,MT_VET1,"FUNGEN",MT_VET2,MT_VET3)
 set color to 

 restscreen(07, 38, 20, 78, M_TELA)

 set order to 1

return ""

***************
function KEYFUN
***************

DrawFn( 02, "Ajuda" )   //VL-Desenha fun‡Æo na linha 24
lKeyfun = .t.

return ""

***************
function FUNPRONOVO
***************

#include "inkey.ch"

#define UL_ROW  5
#define UL_COL  5
#define LR_ROW  18
#define LR_COL  73

LOCAL oBrow, lBrowse, nKey, nX, xOldKey, xNewKey, lBlink
LOCAL cColor, nCol, oGet, nMaxRow := MaxRow()
LOCAL nRec := 0, lKeyWaiting := .F.
LOCAL lShowTagged:=.f., nHandle := 0

M_TELA40 = savescreen(02, 02, 22, 78)

save get to M_GETANT
nCurs := SetCursor(0)

oBrow := TBrowseDB( UL_ROW, UL_COL, LR_ROW, LR_COL )
oBrow:colorSpec := "N/W*, N/BG*,, B/BG*, B/W*, B/BG*, R/W*, B/R*"
SetColor( oBrow:colorSpec )

oBrow:headsep:="Ä"
oBrow:colsep:=chr(179)

lBlink := SetBlink(.f.)

select APCA00
set relation to str(ME_EMP, 2, 0) + str(PCAMAT, 6, 0) into ASLD00

set order to 3
if lPosFunpro > 0
  go lPosFunpro
else
  dbseek("A",.t.)
endif

MS = strzero(ME_EMP,2)

oBrow:addColumn(TBColumnNew("Codigo", FieldBlock("PCAMAT")))
oBrow:addColumn(TBColumnNew("Descricao dos Produtos",&("{||TRAN(pad(PCADES,40),[@!])}")))
oBrow:addColumn(TBColumnNew("Un",&("{||TRAN(pad(PCAUNI,2),[@!])}")))

if ME_EMP = 1
  oBrow:addColumn(TBColumnNew("Saldo",&("{||TRAN(SLD01,[99999999])}")))
ELSE
  oBrow:addColumn(TBColumnNew("Saldo",&("{||TRAN(SLD10,[99999999])}")))
endif

oBrow:addColumn(TBColumnNew("Preco",&("{||TRAN(ASLD00->SLDPRC,[@R 9,999.99])}")))

oBrow:freeze := 1
oBrow:colPos := 2
lKeyWaiting := .F.
lBrowse := .t.

tlfunpro2()

DO WHILE (lBrowse)

  oBrow:colPos := iif( oBrow:colPos == 1, 2, oBrow:colPos )

  // If no key waiting then stabilize
  IF (!lKeyWaiting)
    DO WHILE (!oBrow:stabilize())
      // Interrupt stabilization if a key is hit
      IF ((nKey := Inkey()) != 0)
        lKeyWaiting := .T.
        EXIT
      ENDIF
    ENDDO
  ENDIF

  setcolor("N/W*")
  @ 20,  06 say  pad(APCA00->PCADES + APCA00->PCAMAR,68)

  // Get a keystroke
  nKey := Inkey(0)

  // Handle the keystroke
  DO CASE
    CASE (nKey == K_ENTER)
        do case
       case _FUNPRO_ = "NFS"
          if !type("SQ") = "U"
            if R > 0
              if M_NFSMAT[SQ,3]=0
                if _NOMEMP_ = "PAULISTA"
                  M_NFSMAT[SQ,3]=PCAMAT
                else
                  M_NFSMAT[SQ,3]=PCAMAT
                endif
              endif
            endif
          endif
       case _FUNPRO_ = "NFE"
            if R > 0
              if M_NFEMAT[SQ,6]=0
                M_NFEMAT[SQ,6]=PCAMAT
              endif
            endif
       case _FUNPRO_ = "PRE-VENDA"
          if R > 0 .and. R < 31
            if M_PREMATIT[R] = 0
              M_PREMATIT[R]=PCAMAT
            endif
          endif
       case _FUNPRO_ = "PEDIDO"
          if R > 0
            if M_PEDMAT[SQ, 2] = 0
              M_PEDMAT[SQ, 2]=PCAMAT
            endif
          endif
       case _FUNPRO_ = "REQUISICAO"
          if !type("SQ") = "U"
            if R > 0
              if M_REQMAT[SQ, 2] = 0
                M_REQMAT[SQ, 2]=PCAMAT
              endif
            endif
          endif
       case _FUNPRO_ = "CUPOM"
          if !type("SQ") = "U"
            if R > 0
              if M_CUPMAT[SQ, 2] = 0
                M_CUPMAT[SQ, 2]=PCAMAT
              endif
            endif
          endif
       case _FUNPRO_ = "ORCAMENTO"
          if R > 0
            if M_ORCMATIT[R] = 0
              M_ORCMATIT[R]=PCAMAT
            endif
          endif
       case _FUNPRO_ = "KARDEX"
            if M_KARMAT = 0
              M_KARMAT=PCAMAT
            endif
       case _FUNPRO_ = "PRODUTO"
            if M_PCAMAT = 0
              M_PCAMAT=PCAMAT
            endif
       case _FUNPRO_ = "PEN"
            if M_PENMAT = 0
              M_PENMAT=PCAMAT
            endif
       endcase
      lBrowse := .F.
    CASE (nKey == K_DOWN)
      oBrow:down()

    CASE (nKey == K_UP)
      oBrow:up()

    CASE (nKey == K_PGDN)
      oBrow:pageDown()

    CASE (nKey == K_PGUP)
      oBrow:pageUp()

    CASE (nKey == K_CTRL_PGUP)
      oBrow:goTop()

    CASE (nKey == K_CTRL_PGDN)
      oBrow:goBottom()

    CASE (nKey == K_RIGHT)
      oBrow:right()

    CASE (nKey == K_LEFT)
      oBrow:left()

    CASE (nKey == K_HOME)
      oBrow:home()

    CASE (nKey == K_END)
      oBrow:end()

    CASE (nKey == K_CTRL_LEFT)
      oBrow:panLeft()

    CASE (nKey == K_CTRL_RIGHT)
      oBrow:panRight()

    CASE (nKey == K_CTRL_HOME)
      oBrow:panHome()

    CASE (nKey == K_CTRL_END)
      oBrow:panEnd()
    CASE nKey=K_F3 // ALTERA PRODUTO
       M_COR = setcolor()
       setcolor("")
       M_PROC  = PCADES
       M_PROC1 = PCAUNI
       setcolor("N/W,BG+/B")
       @ oBrow:rowPos+UL_ROW+1, 12 get M_PROC picture "@!@S40"
       @ oBrow:rowPos+UL_ROW+1, 12+40+1 get M_PROC1 picture "@!"
       read
       select APCA00
       do while .t.
         if rlock()
           replace PCADES with M_PROC
           replace PCAUNI with M_PROC1
           unlock
           commit
           exit
         endif
       enddo
       oBrow:refreshCurrent()
       loop
    CASE (nKey == 27)
      lBrowse := .F.
    CASE (nKey # 13)
          keyboard chr(nKey)
          M_COR = setcolor()
          setcolor("")
          M_PROC = space(40)
          setcolor("N/W,BG+/B")
          @ oBrow:rowPos+UL_ROW+1, 12 get M_PROC picture "@!"
          read
          select APCA00
          if left(M_PROC, 2) = "R "
            ( dbsetorder(5) , dbseek(substr(M_PROC, 3, 27), .t.) )
          else
            ( dbsetorder(3) , dbseek(M_PROC, .t.) )
          endif
          setcolor(M_COR)
          lPesq = .t.
          oBrow:refreshALL()


  ENDCASE

  lKeyWaiting := .F.             // Reset key waiting flag

ENDDO

lBlink := SetBlink(.t.)

setcolor("")

select APCA00
lPosFunpro = recno()
set cursor on
set relation to
set order to 1

restore get from M_GETANT

restscreen(02, 02, 22, 78, M_TELA40)

keyfun()

return ""

*****************
function TLFUNPRO2
*****************

  sombra(04, 04, 21, 74,_SOMBRA_)

  setcolor("N/W*")
    @ 04, 04 say     "                                                                       "
    @ 05, 04 say     " Codigo³       DESCRICAO DOS PRODUTOS           ³Un³ Saldo  ³ Preco    "
    @ 06, 04 say     " ÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄ "
    @ 07, 04 say     "       ³                                        ³  ³        ³          "
    @ 08, 04 say     "       ³                                        ³  ³        ³          "
    @ 09, 04 say     "       ³                                        ³  ³        ³          "
    @ 10, 04 say     "       ³                                        ³  ³        ³          "
    @ 11, 04 say     "       ³                                        ³  ³        ³          "
    @ 12, 04 say     "       ³                                        ³  ³        ³          "
    @ 13, 04 say     "       ³                                        ³  ³        ³          "
    @ 14, 04 say     "       ³                                        ³  ³        ³          "
    @ 15, 04 say     "       ³                                        ³  ³        ³          "
    @ 16, 04 say     "       ³                                        ³  ³        ³          "
    @ 17, 04 say     "       ³                                        ³  ³        ³          "
    @ 18, 04 say     "       ³                                        ³  ³        ³          "
    @ 19, 04 say     " ÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ "
    @ 20, 04 say     "                                                                       "
    @ 21, 04 say     "                                                                       "
  set color to

return ""



***************
function FUNIND
***************

private M_NOME ,;
        M_NOME1,;
        K      ,; 
        Y      ,;
        L      ,;
        M_TELA ,;
        M_TECLA

private MT_VEN[7] 
declare MT_VEN[7]
 
    M_TELA = savescreen(04, 04, 18, 75) 

    save get to M_GETANT

    do while .t.

      tlfunind()

      L = 10  

      M_NOME = space(30)

      setcolor("GR+/BG+,GR+/BG")
        @ 08, 19 get M_NOME picture "@!"
        read
      setcolor("")

      if lastkey() = 27
        exit
      endif

      M_TECLA = 32

      select AIND00

      set order to 2

      go top

        set softseek on
          seek M_NOME
        set softseek off

        if eof()
          loop
        endif


        for S = 1 to 7
          MT_VEN[S] = "      ³                                    ³                     ³  ³" 
        next

        do while !eof()

          if VENCOD = 0
            skip
            loop
          endif

          MT_VEN[L - 9] = str(VENCOD, 6) + "³" + pad(VENNOM, 36) + "³" + pad(VENTEL, 21) + "³" + VENEST + "³"

            if L > 15
              M_TECLA = visualind(MT_VEN)
              if M_TECLA = 27
                exit
              endif
              if M_TECLA = 13
                exit
              endif
              if M_TECLA = 18
                skip - 13
              endif
              set color to GR+/BG+
                for K = 10 to 16 
                  @ K, 05 say "³      ³                                    ³                     ³  ³" 
                next
              set color to 
              L = 9
            endif

            L = L + 1

            skip

        enddo

       L = L - 1

       if M_TECLA = 13
         exit
       endif  

       if M_TECLA != 27 
         if M_TECLA != 13
           visualind(MT_VEN)
         endif
       endif

       if lastkey() = 13
         exit
       endif  

       set cursor on

    enddo

    set relation to
    set order to 1
    set cursor on

    restscreen(04, 04, 18, 75, M_TELA) 

    keyfun()

    restore get from M_GETANT

return ""

*****************
function TLFUNIND
*****************

  sombra(07, 05, 17, 74,_SOMBRA_)

  set color to GR+/BG+
    @ 07, 05 say     "ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄIndicadoÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄ¿" 
    @ 08, 05 say     "³Codigo³Nome:                               ³     Telefone        ³Uf³" 
    @ 09, 05 say     "ÃÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄ´" 
    @ 10, 05 say     "³      ³                                    ³                     ³  ³" 
    @ 11, 05 say     "³      ³                                    ³                     ³  ³" 
    @ 12, 05 say     "³      ³                                    ³                     ³  ³" 
    @ 13, 05 say     "³      ³                                    ³                     ³  ³" 
    @ 14, 05 say     "³      ³                                    ³                     ³  ³" 
    @ 15, 05 say     "³      ³                                    ³                     ³  ³" 
    @ 16, 05 say     "³      ³                                    ³                     ³  ³" 
    @ 17, 05 say     "ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÙ" 
  set color to
   
return ""

******************
function VISUALIND
******************

parameters V1 

private S      ,;
        M_OPC  ,;
        M_AREA ,;
        M_TELA

  M_AREA = alias()


  do while .t.

    set color to GR+/BG+,N/W
      M_OPC = achoice(10,6,16,73,V1,,"mostra")
    set color to 

    if rat(str(lastkey(), 2, 0)," 3#27#18") > 0
      exit
    endif

    do case 
       case _FUNIND_ = "NFS"
            if M_NFSIND = 0
              M_NFSIND=val(left(V1[M_OPC],6))
            endif
       case _FUNIND_ = "PRE-VENDA"
            if M_PREVEN = 0
              M_PREVEN=val(left(V1[M_OPC],6))
            endif
       case _FUNIND_ = "PEDIDO"
            if M_PEDVEN = 0
              M_PEDVEN=val(left(V1[M_OPC],6))
            endif
       case _FUNIND_ = "CONREC"
            if M_DUPVEN = 0
              M_DUPVEN=val(left(V1[M_OPC],6))
            endif
       case _FUNIND_ = "CONPAG"
            if M_DUPVEN = 0
              M_DUPVEN=val(left(V1[M_OPC],6))
            endif
       case _FUNIND_ = "CLIENTE"
            if M_CLIVEN = 0
              M_CLIVEN=val(left(V1[M_OPC],6))
            endif
       case _FUNIND_ = "ORCAMENTO"
            if M_ORCVEN = 0
              M_ORCVEN=val(left(V1[M_OPC],6))
            endif
    endcase

    exit

  enddo

  select &M_AREA


return lastkey()
