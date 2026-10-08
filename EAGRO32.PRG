#include "ptmenu.ch"
***************
function MANLCR
***************
parameters M_OPC,M_OPC1,M_OPC2


      rodape("MENU","LANCAMENTO",M_FAN,"EAGRO32","Mem: " + str(memory(0), 5),M_EMP) 

*        @ 05, 30 prompt "Inclus„o " HIGHLITE R/BG PERMITE 2,3,1
*        @ 06, 30 prompt "Altera‡„o" HIGHLITE R/BG PERMITE 2,3,2
*        @ 07, 30 prompt "Consulta " HIGHLITE R/BG PERMITE 2,3,3
*        @ 08, 30 prompt "Exclus„o " HIGHLITE R/BG PERMITE 2,3,4
*        @ 09, 30 prompt "Listagem " HIGHLITE R/BG PERMITE 2,3,5
*        @ 10, 30 prompt "Outros   " HIGHLITE R/BG PERMITE 2,3,6

      do case
         case M_OPC = 1 ; inclcr()
         case M_OPC = 2 ; altlcr()   
         case M_OPC = 3 ; conlcr(M_OPC1)
         case M_OPC = 4 ; exclcr()   
         case M_OPC = 5 ; lislcr(M_OPC1)
         case M_OPC = 6 ; prolcr()   
      endcase

    fecha_arq()

return ""

***************
function INCLCR
***************

private M_OPC

set key -9 to CALCULA()

        select ADCR00 

        set relation to str(DUPPOR, 5, 0) into APOR00 ,;
                     to str(DUPCLI, 7, 0) into ACLI00

  do while .t.

        M_LANEMP = M_EMP 
        M_LANNUM = 0 
        M_LANORD = 0 

        tllcr01()

        rodape("INCLUI","INSTRUCAO",M_FAN,"EAGRO32","Mem: " + str(memory(0), 5),M_EMP) 
 
  SetColor(_COREDICAO_)
        @ 10, 18 get    M_LANNUM  picture "######"
        @ 10, 25 get    M_LANORD  picture "##"        
        read

        if M_LANNUM = 0
            exit
        endif

        select ADCR00 

        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0)) 
          msg("* * * DUPLICATA NAO CADASTRADA * * *")
          loop
        endif

        mslcr01() 
      
        M_LANCLI = DUPCLI 

   do while .t.

     M_LANHIS = 0 
     M_LANDTM = ctod("  /  /  ") 
     M_LANVAL = 0 
     M_LANJUR = 0 
     M_LANDSC = 0 
     M_LANTAX = 0 
     M_LANOBS = space(15) 
     M_LANDOC = space(15) 
     M_LANHIS = 0 

     lplcr01()  

  SetColor(_COREDICAO_)
        @ 15, 19 get M_LANHIS picture "###" valid verlcr01()
        read 

        if M_LANHIS = 0
          exit
        endif 

        if M_LANHIS = 500 
          msg("* * * CODIGO DE (EMISSAO) - NAO PERMITIDO * * *")
          loop 
        endif

        if M_LANHIS = 100
          msg("* * * CODIGO DE (BAIXA) - NAO PERMITIDO * * *")
          loop   
        endif 

        edlcr01()                      && edita os lancamentos

        M_OPC = decide("Confirma Instrucao da Duplicata")

        if M_OPC != 1
          msg("* * * INSTRUCAO NAO EFETUADA * * *")
          loop
        endif

        select ALCR00                  && procura lancamento em branco

        _append("ALCR00")

        grlcr01()                      && grava o lancamento 

        select ADCR00                  && atualiza dados na duplicata

           if M_LANHIS = 201 // PERDA
             do while .t.
               if rlock()
                 replace DUPPER with "S"
                 unlock
                 exit 
               else
                 msg("* * * (ADCR00) REGISTRO SENDO USADO * * *")
               endif
               if lastkey() = 17
                  exit
               endif
             enddo 
           endif

           if M_LANHIS = 200
             do while .t.
               if rlock()
                 replace DUPDSC with DUPDSC + M_LANVAL
                 unlock
                 exit 
               else
                 msg("* * * (ADCR00) REGISTRO SENDO USADO * * *")
               endif
               if lastkey() = 17
                  exit
               endif
             enddo 
           endif

        do case
           case AMOV00R->MOVTIP = "C"
             do while .t.
                if rlock()
                  replace DUPVLA with DUPVLA - M_LANVAL
                  if DUPVLA = 0 
                    replace DUPHIS with 100
                    replace DUPDTP with M_LANDTM 
                    replace DUPJUR with M_LANJUR          
                    replace DUPDSC with M_LANDSC          
                    replace DUPTAX with M_LANTAX          
                    replace DUPVLP with M_LANVAL          
                  endif 
                  commit
                  unlock
                  exit 
                else
                  msg("* * * (ADCR00) REGISTRO SENDO USADO * * *")
                endif
                 if lastkey() = 17
                   exit
                 endif
             enddo 
           case AMOV00R->MOVTIP = "D"
             do while .t.
                if rlock()
                  replace DUPVLA with DUPVLA + M_LANVAL
                  if M_LANHIS = 600
                     M_LANHIS = 500  
                    replace DUPDTP with ctod("  /  /  ")
                    replace DUPJUR with 0          
                    replace DUPDSC with 0          
                    replace DUPTAX with 0          
                  endif 
                  commit
                  unlock
                  exit 
                else
                  msg("* * * (ADCR00) REGISTRO SENDO USADO * * *")
                endif
                 if lastkey() = 17
                   exit
                 endif
             enddo 
        endcase

        if M_LANHIS < 200
          select ABCR00 
          if !dbseek(str(M_LANEMP, 2, 0) + dtos(M_LANDTM) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0))
            _append("ABCR00")
          endif
          do while .t. 
            if rlock()
              replace BAIEMP with M_LANEMP          
              replace BAIDTM with M_LANDTM
              replace BAINUM with M_LANNUM
              replace BAIORD with M_LANORD   
              replace BAISER with ADCR00->DUPSER
              replace BAIVAL with M_LANVAL
              replace BAIJUR with 0
              replace BAITAX with 0
              replace BAISIT with "M" 
              unlock
              exit 
            else
              msg("* * * (ABCR00) REGISTRO SENDO USADO * * *")
            endif
            if lastkey() = 17
              exit
            endif 
          enddo
        endif

        msg("* * * INSTRUCAO EFETUADA * * *")
    
   enddo

  enddo

select ADCR00
 
set relation to 

return ""

*************** 
function ALTLCR
***************

        select ADCR00 

        set relation to str(DUPPOR, 5, 0) into APOR00 ,;
                     to str(DUPCLI, 7, 0) into ACLI00

  set key -9 to CALCULA()

  do while .t.
        
        M_LANEMP = M_EMP 
        M_LANNUM = 0
        M_LANORD = 0
        M_LANHIS = 0  

        tllcr01()

        rodape("ALTERA","INSTRUCAO",M_FAN,"EAGRO32","Mem: " + str(memory(0), 5),M_EMP) 
 
  SetColor(_COREDICAO_)
        @ 10, 18 get    M_LANNUM  picture "######"
        @ 10, 25 get    M_LANORD  picture "##"       
        read

        if M_LANNUM = 0
            exit
        endif

        select ADCR00 

        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0)) 
          msg("* * * DUPLICATA NAO CADASTRADA * * *")
          loop
        endif

        if !rlock()
          msg("* * * (ADCR00) REGISTRO SENDO USADO * * *")
          loop
        endif 

        mslcr01() 
      
   do while .t.

        lplcr01()  

        M_LANHIS = 0 

  SetColor(_COREDICAO_)
        @ 15, 19 get M_LANHIS picture "###"
        read 

        if M_LANHIS = 0
          exit
        endif 
             
        select AMOV00R

        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANHIS, 3, 0))  
          msg("* * * CODIGO DE MOVIMENTO NAO CADASTRADO * * *")
          loop 
        endif

        set color to I
          @ 15, 23 say left(MOVDES,23) 
        set color to
       


        select ALCR00 

        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0) + str(M_LANHIS, 3, 0)) 
          msg("* * * INSTRUCAO NAO CADASTRADA * * *")
          loop
        endif  
         
        mslcr03()                      && mostra lancamento

        if !rlock()
          msg("* * * (ALCR00) REGISTRO SENDO USADO * * *")
          loop
        endif  

        M_LANEMP = LANEMP          
        M_LANNUM = LANNUM
        M_LANORD = LANORD   
        M_LANHIS = LANHIS   
        M_LANDTM = LANDTM   
        M_LANCLI = LANCLI 
        M_LANVAL = LANVAL   
        M_LANJUR = LANJUR   
        M_LANDSC = LANDSC   
        M_LANTAX = LANTAX   
        M_LANOBS = LANOBS
        M_LANDOC = LANDOC

        select ADCR00

        do case
           case AMOV00R->MOVTIP = "C"
             do while .t.
                if rlock()
                  replace DUPVLA with DUPVLA + M_LANVAL
                  commit
                  exit 
                else
                  msg("* * * (ADCR00) REGISTRO SENDO USADO * * *")
                endif
                 if lastkey() = 17
                   exit
                 endif
             enddo 
           case AMOV00R->MOVTIP = "D"
             do while .t.
                if rlock()
                  replace DUPVLA with DUPVLA - M_LANVAL
                  commit
                  exit 
                else
                  msg("* * * (ADCR00) REGISTRO SENDO USADO * * *")
                endif
                 if lastkey() = 17
                   exit
                 endif
             enddo 
        endcase

        edlcr02()

            if lastkey() = 27
               msg("* * * INSTRUCAO NAO ALTERADA * * *")           
               loop
            endif 

        grlcr01()                      && regrava duplicata

        select ADCR00                  && atualiza dados em duplicata

        do case
           case AMOV00R->MOVTIP = "C"
             do while .t.
                if rlock()
                  replace DUPVLA with DUPVLA - M_LANVAL
                  commit
                  exit 
                else
                  msg("* * * (ADCR00) REGISTRO SENDO USADO * * *")
                endif
                 if lastkey() = 17
                   exit
                 endif
             enddo 
           case AMOV00R->MOVTIP = "D"
             do while .t.
                if rlock()
                  replace DUPVLA with DUPVLA + M_LANVAL
                  commit
                  exit 
                else
                  msg("* * * (ADCR00) REGISTRO SENDO USADO * * *")
                endif
                 if lastkey() = 17
                   exit
                 endif
             enddo 
        endcase

        if DUPVLA > 0 .and. DUPHIS = 100 
          do while .t.
            if rlock()
              replace DUPHIS with val("500")
              commit
              unlock 
              exit 
            else
              msg("* * * (ADCR00) REGISTRO SENDO USADO * * *")
            endif
            if lastkey() = 17
              exit
            endif
          enddo        
        endif 

        if DUPVLA = 0 .and. DUPHIS = 500 
          do while .t.
            if rlock()
              replace DUPHIS with val("100") 
              commit
              unlock 
              exit 
            else
              msg("* * * (ADCR00) REGISTRO SENDO USADO * * *")
            endif
            if lastkey() = 17
              exit
            endif
          enddo        
        endif 

        msg("* * * INSTRUCAO ALTERADA * * *")
    
   enddo

  enddo

select ADCR00
 
set relation to 

return ""

*************** 
function CONLCR                         && consulta ocorrencia 
***************
parameters M_OPC,M_OPC1,M_OPC2


*      @ 09, 37 prompt "Instrucao" HIGHLITE R/BG
*      @ 10, 37 prompt "Duplicata" HIGHLITE R/BG
*      @ 11, 37 prompt "Cliente  " HIGHLITE R/BG

  do case
     case M_OPC = 1
       conlcr_a()
     case M_OPC = 2
       conlcr_b()
     case M_OPC = 3 
       conlcr_c()
  endcase

return ""

*****************
function CONLCR_A
*****************

  select ADCR00 

  set relation to str(DUPPOR, 5, 0) into APOR00 ,;
               to str(DUPCLI, 7, 0) into ACLI00

  do while .t.
        
        M_LANEMP = M_EMP 
        M_LANNUM = 0
        M_LANORD = 0
        M_LANHIS = 0  

        tllcr01()

        rodape("CONSULTA","INSTRUCAO",M_FAN,"EAGRO32","Mem: " + str(memory(0), 5),M_EMP) 
 
  SetColor(_COREDICAO_)
        @ 10, 18 get    M_LANNUM  picture "######"
        @ 10, 25 get    M_LANORD  picture "##"       
        read

        if M_LANNUM = 0
            exit
        endif

        select ADCR00 

        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0)) 
          msg("* * * DUPLICATA NAO CADASTRADA * * *")
          loop
        endif

        if !rlock()
          msg("* * * (ADCR00) REGISTRO SENDO USADO * * *")
          loop
        endif 

        mslcr01() 
      
     do while .t.

        lplcr01()  

        M_LANHIS = 0 

  SetColor(_COREDICAO_)
        @ 15, 19 get M_LANHIS picture "###"
        read 

        if M_LANHIS = 0
          exit
        endif 
             
        select AMOV00R

        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANHIS, 3, 0))  
          msg("* * * CODIGO DE MOVIMENTO NAO CADASTRADO * * *")
          loop 
        endif

        set color to I
          @ 15, 23 say left(MOVDES,23) 
        set color to

        select ALCR00 

        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0) + str(M_LANHIS, 3, 0)) 
          msg("* * * INSTRUCAO NAO CADASTRADA * * *")
          loop
        endif  
         
        mslcr03()                      && mostra lancamento

        msg("* * * TECLE (ENTER) * * *")
    
   enddo

  enddo

  select ADCR00
 
  set relation to 

return ""

***************** 
function CONLCR_B                         && consulta ocorrencia por Duplicata 
*****************

private M_LANEMP,; 
        M_LANNUM,; 
        M_LANORD,;
        M_LANHIS,;
        M_OPC   ,;
        K       ,;
        L

        select ALCR00 

        set relation to str(LANEMP, 2, 0) + str(LANHIS, 3, 0) into AMOV00R

      do while .t.

        M_LANEMP = M_EMP 
        M_LANNUM = 0 
        M_LANORD = 0 
        M_LANHIS = 0 

        tllcr02()

        rodape("CONSULTA","DUPLICATA",M_FAN,"EAGRO32","Mem: " + str(memory(0), 5),M_EMP) 
 
  SetColor(_COREDICAO_)
        @ 06, 18 get    M_LANNUM  picture "######"
        @ 06, 25 get    M_LANORD  picture "##"       
        read

        if M_LANNUM = 0
            exit
        endif

        select ADCR00 
   
        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0)) 
          msg("* * * DUPLICATA NAO CADASTRADA * * *")
          loop
        endif

        select ACLI00

        if !dbseek(str(ADCR00->DUPCLI, 7, 0))
          msg("* * * CLIENTE NAO CADASTRADO * * *")
        endif

        select APOR00

        if !dbseek(str(ADCR00->DUPPOR, 5, 0))
          msg("* * * PORTADOR NAO CADASTRADO * * *")
        endif

        select ADCR00 

        mslcr02() 

        select ALCR00 

        set order to 2 

        set softseek on
          seek str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0)
        set softseek off 

        if LANEMP != M_LANEMP
          msg("* * * DUPLICATA SEM MOVIMENTO * * *")
          loop
        endif

        L = 13 

        do while !eof()

          if !str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) == str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0)
            exit
          endif 
  
          set color to I
            @ L, 06 say LANHIS            picture "###"
            @ L, 10 say left(AMOV00R->MOVDES,15)
            @ L, 26 say LANDTM 
            @ L, 35 say LANVAL            picture "@E ###,###,###.##" 
            @ L, 50 say (LANJUR + LANTAX) picture "@E ###,###,###.##" 
            @ L, 65 say left(LANOBS,09)
          set color to 

            L = L + 1 

            if L > 18
              msg("* * * (ESC) Sai  (ENTER) Continua * * *")
               if lastkey() = 27
                 exit
               endif
                 set color to I
                   for K = 13 to 18 
                       @ K, 5 say     "³   ³               ³        ³              ³              ³         ³"
                   next
                  set color to
             L = 13
           endif
 
           skip 

        enddo

        msg("* * * FIM DAS INSTRUCOES * * *") 

       enddo 

       select ALCR00
 
       set relation to

       set order to 1
 
       select ADCR00
         
       set relation to 

return ""

***************** 
function CONLCR_C                         && consulta ocorrencia por Cliente
*****************

private M_LANCLI,; 
        M_LANEMP,; 
        M_LANDTM,;
        M_OPC
 
      select ALCR00 

      set relation to str(LANEMP, 2, 0)+ str(LANHIS, 3, 0) into AMOV00R

      do while .t.

        M_LANEMP = M_EMP 
        M_LANCLI = 0 
        M_LANDTM = ctod("  /  /  ") 

        tllcr03()

        rodape("CONSULTA","CLIENTE",M_FAN,"EAGRO32","Mem: " + str(memory(0), 5),M_EMP) 
 
  SetColor(_COREDICAO_)
        @ 06, 18 get    M_LANCLI  picture "#######"
        read

        if M_LANCLI = 0
            exit
        endif

        select ACLI00 
   
        if !dbseek(str(M_LANCLI, 7, 0)) 
          msg("* * * CLIENTE NAO CADASTRADO * * *")
          loop
        endif

        set color to I
          @ 06, 26 say left(CLINOM, 20)                        
          @ 06, 55 say CLICGC1 picture "@R 999.999.999/9999-99" 
          @ 07, 18 say left(CLIEND3,28)                        
          @ 07, 55 say left(CLIMUN3,15)                        
          @ 07, 72 say CLIUF3                                   
          @ 08, 18 say CLIIES2                                  
          @ 08, 55 say pad(CLITEL3, 19)                          
        set color to

        select ALCR00 

        set order to 3 

        set softseek on
          seek str(M_LANEMP, 2, 0) + str(M_LANCLI, 7, 0) + dtos(M_LANDTM) 
        set softseek off 

        if LANEMP != M_LANEMP
          msg("* * * DUPLICATA SEM MOVIMENTO * * *")
          loop
        endif

        L = 12 

        do while !eof()

          if !str(LANEMP, 2, 0) + str(LANCLI, 7, 0)  == str(M_LANEMP, 2, 0) + str(M_LANCLI, 7, 0)
            exit
          endif 

          set color to I
            @ L, 06 say LANHIS            picture "###"
            @ L, 10 say left(AMOV00R->MOVDES,20)
            @ L, 31 say LANDTM 
            @ L, 40 say LANNUM            picture "######" 
            @ L, 47 say LANORD            picture "##"  
            @ L, 50 say LANVAL            picture "@E ###,###,###.##" 
            @ L, 65 say left(LANOBS, 09)
          set color to 

            L = L + 1 

            if L > 18
              msg("* * * (ESC) Sai  (ENTER) Continua * * *")
               if lastkey() = 27
                 exit
               endif
                 set color to I
                   for K = 12 to 18 
                       @ K, 06 say     space(03) 
                       @ K, 10 say     space(20) 
                       @ K, 31 say     space(08) 
                       @ K, 40 say     space(06) 
                       @ K, 47 say     space(02) 
                       @ K, 50 say     space(14) 
                       @ K, 65 say     space(09) 
                   next
                  set color to
             L = 12
           endif

           skip 

        enddo

        msg("* * * FIM DAS INSTRUCOES * * *") 

       enddo 

       select ALCR00

       set order to 1 

       set relation to

return ""

*************** 
function EXCLCR 
***************

private M_LANEMP,; 
        M_LANNUM,; 
        M_LANORD,;
        M_LANHIS,;
        M_LANVAL,;   
        M_OPC           

        select ADCR00 

        set relation to str(DUPPOR, 5, 0) into APOR00 ,;
                     to str(DUPCLI, 7, 0) into ACLI00

      do while .t.

        M_LANEMP = M_EMP 
        M_LANNUM = 0 
        M_LANORD = 0 
        M_LANVAL = 0

        tllcr01()

        rodape("EXCLUI","INSTRUCAO",M_FAN,"EAGRO32","Mem: " + str(memory(0), 5),M_EMP) 
 
  SetColor(_COREDICAO_)
        @ 10, 18 get    M_LANNUM  picture "######"
        @ 10, 25 get    M_LANORD  picture "##"       
        read

        if M_LANNUM = 0
            exit
        endif

        select ADCR00 

        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0)) 
          msg("* * * DUPLICATA NAO CADASTRADA * * *")
          loop
        endif

        mslcr01() 

        do while .t.
        
          lplcr01() 

          M_LANHIS = 0 

  SetColor(_COREDICAO_)
          @ 15, 19 get    M_LANHIS  picture "###"
          read 

          if M_LANHIS = 0
            exit
          endif  

          select ALCR00 

          if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0) + str(M_LANHIS, 3, 0)) 
            msg("* * * INSTRUCAO NAO CADASTRADA * * *")
            loop
          endif  

        select AMOV00R

        seek str(ALCR00->LANEMP, 2, 0) + str(ALCR00->LANHIS, 3, 0)

        select ALCR00

        M_LANVAL = LANVAL 
          
        mslcr03()

        if !rlock()
          msg("* * * (ALCR00) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_OPC = confirma("da Instrucao")

        if M_OPC != 1
          msg("* * * INSTRUCAO NAO EXCLUIDA * * *")
          loop
        endif          

        select ABCR00

        if dbseek(str(M_LANEMP, 2, 0) + dtos(ALCR00->LANDTM) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0)) 
          elimina()
        endif

        select ALCR00
        elimina() 

        select ADCR00

        do case
           case AMOV00R->MOVTIP = "C"
             do while .t.
                if rlock()
                  replace DUPVLA with DUPVLA + M_LANVAL
                  if DUPVLA > 0
                    replace DUPHIS with val("500")
                    replace DUPDTP with ctod("  /  /  ")
                    replace DUPJUR with 0          
                    replace DUPDSC with 0          
                    replace DUPTAX with 0          
                    replace DUPVLP with 0
                  endif 
                  commit
                  unlock
                  exit 
                else
                  msg("* * * (ADCR00) REGISTRO SENDO USADO * * *")
                endif
                 if lastkey() = 17
                   exit
                 endif
             enddo 
           case AMOV00R->MOVTIP = "D"
             do while .t.
                if rlock()
                  replace DUPVLA with DUPVLA - M_LANVAL
                  commit
                  unlock
                  exit 
                else
                  msg("* * * (ADCR00) REGISTRO SENDO USADO * * *")
                endif
                 if lastkey() = 17
                   exit
                 endif
             enddo 
        endcase
   
        msg("* * * INSTRUCAO EXCLUIDA * * *")

        enddo

       enddo 

    select ADCR00
 
    set relation to 
        
    select ALCR00

    set relation to 

return ""

*************** 
function LISLCR                         && consulta ocorrencia 
***************
parameters M_OPC,M_OPC1,M_OPC2

*      @ 09, 37 prompt "Instrucao" HIGHLITE R/BG
*      @ 10, 37 prompt "Diario   " HIGHLITE R/BG
*      @ 11, 37 prompt "Razao    " HIGHLITE R/BG

  do case
     case M_OPC = 1
       lislcr_a()
     case M_OPC = 2 
       lislcr_b()
     case M_OPC = 3 
       lislcr_c()
  endcase

return ""

***************** 
function LISLCR_A 
*****************

private M_NUMINI,; 
        M_ORDINI,; 
        M_NUMFIN,;
        M_ORDFIN,;
        M_OPC           

    do while .t.

        rodape("LISTA","LANCAMENTOS",M_FAN,"EAGRO32","Mem: " + str(memory(0), 5),M_EMP) 

        store 0        to M_NUMINI,;
                          M_NUMFIN,;
                          M_ORDINI,;
                          M_ORDFIN,;
                          LN

       M_SELEC := " "

 nbox(14, 27, 18, 56,"W/W+",.t.)
 setcolor("B/W")
         @ 15, 28 say    "    Seleciona S/N:          "
         @ 16, 28 say    "Duplicata Inicial:       /  "
         @ 17, 28 say    "            Final:       /  "
       set color to

       M_DUPS = { }
       R = 1
       L = 11

  SetColor(_COREDICAO_)
        @ 15, 47 get M_SELEC  picture "@!"  valid M_SELEC $ "SN"
        read
        if M_SELEC == "N"
          @ 16, 47 get M_NUMINI picture "######"  
          @ 16, 54 get M_ORDINI picture "##"   
          @ 17, 47 get M_NUMFIN picture "######"  
          @ 17, 54 get M_ORDFIN picture "##"   
          read
        else
          setcolor("I")
          @ 10,49,20,59 box M_FRAME1a
          setcolor("")
          do while .t.
            aadd(M_DUPS,{0,0,0})
            incdup04(L,R)
            if lastkey() = 27 
              adel(M_DUPS,R)
              asize(M_DUPS,len(M_DUPS) - 1)
              exit
            endif

            if L = 19
              setcolor("I")
               @ 10,49,20,59 box M_FRAME1a
              setcolor("")
              L = 10
            endif

            R ++
            L ++
          enddo
          declare M_VETORITE[len(M_DUPS)]

          for R = 1 to len(M_DUPS)
            M_VETORITE[R] = str(M_DUPS[R, 1], 6, 0) + "/" + str(M_DUPS[R, 2], 2, 0)
          next

          M_LINPOS = 0
          nPosach  = 1
 
          do while .t.

            if len(M_DUPS) = 0
              exit
            endif

            set color to GR+
              @ 24, 00 say "                                          3.Deleta  4.Adiciona  5.Insere  6.Sair"
            set color to R+
              @ 24, 42 say "3"
              @ 24, 52 say "4"
              @ 24, 64 say "5"
              @ 24, 74 say "6"
            set color to N/W,W+/N
              M_OPC = achoice(11,50,19,58,M_VETORITE,,"mosdup01",nPosach)
            set color to 

            if lastkey() = 13
              altitedup() && altera item
              loop
            endif

            if lastkey() = 51
              delitedup() && deleta item 
              setcolor("I")
              @ 10,49,20,59 box M_FRAME1a
              setcolor("")
              loop
            endif

            if lastkey() = 52
              additedup() && adiciona itens 
              loop
            endif

            if lastkey() = 53
              insitedup() && insere item
              loop
            endif

            if lastkey() = 54
              exit        && abandona operacao
            endif
 
          enddo
        endif

        if lastkey() = 27
          return ""
        endif

        M_NUMINI = iif(M_NUMINI = 0, 1,M_NUMINI)
        M_ORDINI = iif(M_ORDINI = 0, 0,M_ORDINI) 
        M_NUMFIN = iif(M_NUMFIN = 0, 999999,M_NUMFIN)
        M_ORDFIN = iif(M_ORDFIN = 0,     99,M_ORDFIN) 

        select ALCR00

        set relation to str(LANEMP, 2, 0) + str(LANHIS, 3, 0) into AMOV00R

        select ADCR00

        set relation to str(DUPCLI, 7, 0) into ACLI00 

        go top

        if M_SELEC == "N"
          set softseek on
            seek str(ME_EMP, 2, 0) + str(M_NUMINI, 6, 0) + str(M_ORDINI, 2, 0)
          set softseek off

          if str(DUPEMP, 2, 0) + str(DUPNUM, 6, 0) + str(DUPORD, 2, 0) > str(ME_EMP, 2, 0) + str(M_NUMFIN, 6, 0) + str(M_ORDFIN, 2, 0)
            msg("* * * NADA A LISTAR NO INTERVALO * * *")
            loop
          endif
        else
          llocpos = 1
          select ADCR00
          go M_DUPS[llocpos,3]
        endif

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

    store 0 to PG

    cab_lanlcr()

    do while !eof()

       if M_SELEC == "N"
         if str(DUPEMP, 2, 0) + str(DUPNUM, 6, 0) + str(DUPORD, 2, 0) > str(ME_EMP, 2, 0) + str(M_NUMFIN, 6, 0) + str(M_ORDFIN, 2, 0)
           go bottom
           skip 
           loop
         endif
       else
         if llocpos > len(M_DUPS)
           exit
         endif
          select ADCR00
          go M_DUPS[llocpos,3]
          llocpos ++
       endif

        select ALCR00

        set softseek on
          seek str(ADCR00->DUPEMP, 2, 0) + str(ADCR00->DUPNUM, 6, 0) + str(ADCR00->DUPORD, 2, 0)
        set softseek off

        if !str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) == str(ADCR00->DUPEMP, 2, 0) + str(ADCR00->DUPNUM, 6, 0) + str(ADCR00->DUPORD, 2, 0)        
          select ADCR00
          skip
          loop
        endif

        store 0 to M_SLDDUP

          ? " "
           ?? str(ADCR00->DUPNUM, 6, 0)
            ?? "/"
            ?? strzero(ADCR00->DUPORD, 2, 0)
            ?? " Cliente: "
            ?? " "
            ?? str(ADCR00->DUPCLI, 7, 0)
            ?? " "
            ?? left(ACLI00->CLINOM, 40)
            ?? "      Valor Atual: "
            ?? transform(ADCR00->DUPVLA,"@E ###,###,###.##")
          ?

          LN = LN + 2

          if LN > 60
            cab_lanlcr()
          endif

        do while !eof() 

            if !str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) == str(ADCR00->DUPEMP, 2, 0) + str(ADCR00->DUPNUM, 6, 0) + str(ADCR00->DUPORD, 2, 0)        
            go bottom
            skip
            loop
          endif 

          ? space(13)
           ?? str(LANHIS, 3, 0)
           ?? " " 
           ?? left(AMOV00R->MOVDES, 29)
           ?? " "
           ?? LANDTM
           ?? " "
           ?? transform(LANVAL,"@E ###,###,###.##")
           ?? " "
           ?? transform(LANJUR,"@E ###,###,###.##")
           ?? " "
           ?? transform(LANDSC,"@E ###,###,###.##")
           ?? " "
           ?? LANDOC
           ?? " "
           ?? left(LANOBS, 14)
    
           if AMOV00R->MOVTIP = "D"
             M_SLDDUP = M_SLDDUP - LANVAL 
           else
             if AMOV00R->MOVTIP="C"
               M_SLDDUP = M_SLDDUP + LANVAL
             endif
           endif    

          store LN + 1 to LN

          skip

          M_ESC = inkey()

            if M_ESC = 27
                if susimp()
                  ? replicate("-", 132)
                  ? "* * * IMPRESSAO SUSPENSA * * *"
                  select ADCR00
                  go bottom
                  skip
                  select ALCR00 
                  go bottom
                  skip
                  loop
                else
                  M_ESC = inkey()
                endif
            endif

        enddo

        select ADCR00

        if abs(M_SLDDUP) != abs(DUPVLA) 
          ? "*** DIVERGENCIA -=> "
            ?? space(97)
            ?? transform((M_SLDDUP - DUPVLA),"@E ###,###,###.##")
          LN = LN + 1
          if LN > 60
             cab_lanlcr()
           endif
        endif

        ? replicate("-", 132)
  
        LN = LN + 1

        if LN > 60
           cab_lanlcr()
        endif

        skip

    enddo

    eject

desliga1()

enddo 

return "" 

*****************
function MOSDUP01
*****************

parameters  M_MODO, M_ELEM, M_POSI

  if str(lastkey(), 2, 0) $ "27"
    return 0
  endif

  nPosach = M_ELEM

  if str(lastkey(), 3, 0)  $ "# 49# 50# 51# 52# 53# 54# 13"
    M_OPC = M_ELEM
    return 1
  endif

  set color to GR+
    @ 24, 00 say "                                          3.Deleta  4.Adiciona  5.Insere  6.Sair"
  set color to R+
    @ 24, 42 say "3"
    @ 24, 52 say "4"
    @ 24, 64 say "5"
    @ 24, 74 say "6"
  set color to N/W,W+/N

  M_LINPOS = M_POSI

return 2

*****************
function INCDUP04
*****************

parameters LN,SQ

  SetColor(_COREDICAO_)
@ LN, 50 get     M_DUPS[SQ, 1] picture "######"
@ LN, 57 get     M_DUPS[SQ, 2] picture "##"      valid verdup04()
read

return .t.

*****************
function VERDUP04
***************** 

if lastkey()=5
  return .t.
endif

select ADCR00 
if !dbseek(str(ME_EMP, 2, 0) + str(M_DUPS[SQ,1], 6, 0) + str(M_DUPS[SQ,2], 2, 0))
  msg("* * * DUPLICATA NAO CADASTRADA * * *")
  return .f.
endif

M_DUPS[SQ, 3] = recno()

return .t.

******************
function ALTITEDUP  && altera item da nota
******************

  incdup04(11 + M_LINPOS,M_OPC)

          for R = 1 to len(M_DUPS)
            M_VETORITE[R] = str(M_DUPS[R, 1], 6, 0) + "/" + str(M_DUPS[R, 2], 2, 0)
          next

  M_LINPOS = 0

return ""

******************
function INSITEDUP && insere item na nota
******************

private R,S

  aadd(M_DUPS,{0,0,0})

  R = len(M_DUPS)

  M_MATANT = aclone(M_DUPS)

  acopy(M_MATANT,M_DUPS,R,1,M_OPC)

  if M_OPC-1 = 1
    acopy(M_MATANT,M_DUPS,M_OPC-1,M_OPC-1,1)
  endif

  acopy(M_MATANT,M_DUPS,M_OPC,R-M_OPC,M_OPC+1)

  incdup04(11 + M_LINPOS, M_OPC)

  asize(M_VETORITE, R)
  ains(M_VETORITE, len(M_VETORITE))

          for R = 1 to len(M_DUPS)
            M_VETORITE[R] = str(M_DUPS[R, 1], 6, 0) + "/" + str(M_DUPS[R, 2], 2, 0)
          next

return ""

******************
function DELITEDUP && deleta item da nota
******************

private M_NFS, R

M_NFS = decide("Confirma Exclusao deste Item")

if M_NFS != 1
  return ""
endif

adel(M_DUPS,M_OPC)
adel(M_VETORITE,M_OPC)

asize(M_DUPS,len(M_DUPS) - 1)
asize(M_VETORITE,len(M_VETORITE) - 1)

          for R = 1 to len(M_DUPS)
            M_VETORITE[R] = str(M_DUPS[R, 1], 6, 0) + "/" + str(M_DUPS[R, 2], 2, 0)
          next

M_LINPOS = 0

return ""

******************
function ADDITEDUP && insere item na nota
******************

  R = len(M_DUPS) + 1
  L = 11

  for S = 1 to len(M_DUPS)
    if L = 19
      setcolor("I")
      @ 10,49,20,59 box M_FRAME1a
      setcolor("")
      L = 10
    endif
    L ++
  next

  do while .t.

    aadd(M_DUPS,{0,0,0})

    incdup04(L,R)

    if lastkey() = 27 
      adel(M_DUPS,R)
      asize(M_DUPS,len(M_DUPS) - 1)
      exit
    endif

    if L = 19
          setcolor("I")
          @ 10,49,20,59 box M_FRAME1a
          setcolor("")
      L = 10
    endif

    R ++
    L ++

  enddo

  asize(M_VETORITE, R)

  ains(M_VETORITE, len(M_VETORITE))

          for R = 1 to len(M_DUPS)
            M_VETORITE[R] = str(M_DUPS[R, 1], 6, 0) + "/" + str(M_DUPS[R, 2], 2, 0)
          next

return ""

*****************
function LISLCR_B                       && Diario Auxiliar de Clientes      
*****************

private M_PERINI ,;
        M_PERFIN ,;
        M_NUMDIA ,; 
        M_SLDDEB ,;
        M_SLDCRE ,; 
        M_DIADEB ,;
        M_DIARRE ,; 
        M_DIAANT ,; 
        PG       ,; 
        LN     

  do while .t.

      rodape("LISTA","DIARIO",M_FAN,"EAGRO32","Mem: " + str(memory(0), 5),M_EMP) 

        M_SLDDEB = 0
        M_SLDCRE = 0
        M_DIADEB = 0
        M_DIACRE = 0 
        M_PERINI = ctod("  /  /  ")
        M_DIAANT = ctod("  /  /  ")
        M_PERFIN = date()
        M_NUMDIA = 1
        PG       = 2

 nbox(15, 30, 20, 56,"W/W+",.t.)
 setcolor("B/W")
          @ 16, 31 say      "Periodo Inicial:         "
          @ 17, 31 say      "          Final:         "
          @ 18, 31 say      " Pagina Inicial:         "
          @ 19, 31 say      "  Diario Numero:         "
        set color to

  SetColor(_COREDICAO_)
        @ 16, 48 get M_PERINI
        @ 17, 48 get M_PERFIN                   
        @ 18, 48 get PG       picture "####"    
        @ 19, 48 get M_NUMDIA picture "####"    
        read

        if lastkey() = 27
          exit
        endif

        select ALCR00

        set order to 4

        set relation to str(LANEMP, 2, 0) + str(LANHIS, 3, 0)                     into AMOV00R ,;
                     to str(LANCLI, 7, 0)                                         into ACLI00 ,; 
                     to str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) into ADCR00 ,; 
                     to str(ADCR00->DUPPOR, 5, 0)                                 into APOR00 


      select ALCR00 

      go top 

      set softseek on
        seek str(M_EMP, 2, 0)
      set softseek off

      if eof() .or. LANEMP > M_EMP 
        msg("* * * NADA A LISTAR NA EMPRESA * * *")
        exit
      endif 


      M_IMPRE = impresn()

      if M_IMPRE = "N"
        exit
      endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

      do while !eof() 

         if str(LANEMP, 2, 0) + dtos(LANDTM) >= str(M_EMP, 2, 0) + dtos(M_PERINI) 
           exit
         endif

         if !AMOV00R->MOVDIA == "S"
           skip
           loop
         endif 

         if AMOV00R->MOVTIP == "D"
           M_SLDDEB = M_SLDDEB - LANVAL
         else
           if AMOV00R->MOVTIP == "C"
             M_SLDCRE = M_SLDCRE + LANVAL
           endif 
         endif
  
         skip

       enddo

       store PG - 1 to PG 

       do while !eof()   

         store PG + 1 to PG 

           if PG > 1
              eject
           endif  

            ? cent_cab(AEMP00->EMPFAN,"DIARIO AUXILIAR DE CLIENTES","EAGRO32",132) 
            ? cent_cab(M_DATA,"DIARIO NUMERO: " + str(M_NUMDIA, 4, 0) + " - PERIODO: " + dtoc(M_PERINI) + " A " + dtoc(M_PERFIN),"PAG.: " + str(PG, 4, 0), 132)
            ?     "*--------*-----*--------------------*-----*-------------------*---------*--------------------*------------------*------------------*" 
            ?     "* DATA   * COD * NOME DO CLIENTE    * POR * CONTRA PARTIDA    *  DOCTO  *     HISTORICO      *   VALOR DEBITO   *   VALOR CREDITO  *" 
            ?     "*--------*-----*--------------------*-----*-------------------*---------*--------------------*------------------*------------------*" 
*                   99/99/99 99999 XXXXXXXXXXXXXXXXXXXX 99999 XXXXXXXXXXXXXXXXXXX 999999/99 XXXXXXXXXXXXXXXXXXXX ###,###,###,###.## ###,###,###,###.##  

            ?     space(70)              
               ?? "De Transporte . . .     "              
               ?? transform(M_SLDDEB,"@E ###,###,###,###.##")
               ?? " " 
               ?? transform(M_SLDCRE,"@E ###,###,###,###.##")            

            store 6 to LN 
         
            do while !eof() .and. LN < 59

              if str(LANEMP, 2, 0) + dtos(LANDTM) > str(M_EMP, 2, 0) + dtos(M_PERFIN)
                go bottom
                skip
                loop 
              endif

              if M_DIAANT != LANDTM
                if (M_DIADEB + M_DIACRE) != 0
                  ?     
                   ?? space(70)              
                   ?? "Total do Dia . . . .    "              
                   ?? transform(M_DIADEB,"@E ###,###,###,###.##")
                   ?? " " 
                   ?? transform(M_DIACRE,"@E ###,###,###,###.##")
                   ??  
                   store 0 to M_DIACRE ,;
                              M_DIADEB
                   LN = LN + 1 
                endif 
                store LANDTM to M_DIAANT
              endif 
 
              ?     " "
                 ?? LANDTM
                 ?? " "
                 ?? str(LANCLI, 7, 0)
                 ?? " "
                 ?? left(ACLI00->CLINOM, 18) 
                 ?? " " 
                 ?? str(ADCR00->DUPPOR, 5, 0)
                 ?? " "
                 ?? left(APOR00->PORNOM, 19) 
                 ?? " " 
                 ?? str(LANNUM, 6, 0)
                 ?? "/"
                 ?? strzero(LANORD, 2, 0)
                 ?? " "
                 ?? left(AMOV00R->MOVDES, 19)
                 ?? "  " 
                 if AMOV00R->MOVTIP == "D"
                   ?? transform(LANVAL,"@E ###,###,###,###.##")
                 else
                   ?? space(17)
                   ?? transform(LANVAL,"@E #####,###,###,###.##")
                 endif 

              if AMOV00R->MOVTIP == "D"
                M_SLDDEB = M_SLDDEB + LANVAL
                M_DIADEB = M_DIADEB + LANVAL 
              else
                if AMOV00R->MOVTIP == "C"
                  M_SLDCRE = M_SLDCRE + LANVAL
                  M_DIACRE = M_DIACRE + LANVAL  
                endif 
              endif

              skip

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

            if !eof() 
              ?     space(70)
                 ?? "A Transportar . . .     "              
                 ?? transform(M_SLDDEB,"@E ###,###,###,###.##")
                 ?? " " 
                 ?? transform(M_SLDCRE,"@E ###,###,###,###.##")             
            endif
 
          enddo

       ?     
         ?? space(70)              
         ?? "Total do Dia . . . .    "              
         ?? transform(M_DIADEB,"@E ###,###,###,###.##")
         ?? " " 
         ?? transform(M_DIACRE,"@E ###,###,###,###.##")             
         ??  
       ?     space(60)
         ?? "Saldo Final do Periodo . . . . . "              
         ?? transform(M_SLDDEB,"@E ####,###,###,###.##")
         ?? " " 
         ?? transform(M_SLDCRE,"@E ###,###,###,###.##")             

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(18)                        && descomprime
        endif

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(18)                        && descomprime
    endif

    eject 
 
desliga1()

  enddo

return ""

*****************
function LISLCR_C
*****************

private M_LANEMP ,; 
        M_LANCLI ,; 
        M_LANDTM ,;
        M_CLIINI ,;
        M_CLIFIN ,;
        M_PERINI ,;
        M_PERFIN ,;
        M_SALDO  ,;
        LN       ,;
        M_TELA 

  do while .t.

     rodape("LISTA","RAZAO",M_FAN,"EAGRO32","Mem: " + str(memory(0), 5),M_EMP) 

        M_LANEMP = M_EMP
        M_LANCLI = 0
        M_LANDTM = ctod("  /  /  ")
        M_CLIINI = 0
        M_CLIFIN = 0
        M_PERINI = ctod("  /  /  ")
        M_PERFIN = date()


 nbox(15, 30, 20, 56,"W/W+",.t.)
 setcolor("B/W")
          @ 16, 31 say      "Cliente Inicial:         "
          @ 17, 31 say      "          Final:         "
          @ 18, 31 say      "Periodo Inicial:         "
          @ 19, 31 say      "          Final:         "
        set color to

  SetColor(_COREDICAO_)
        @ 16, 48 get M_CLIINI  picture "#######"
        @ 17, 48 get M_CLIFIN  picture "#######"  
        @ 18, 48 get M_PERINI                   
        @ 19, 48 get M_PERFIN                   
        read

        if lastkey() = 27
          exit
        endif

        M_CLIINI = iif(M_CLIINI = 0,       1,M_CLIINI)
        M_CLIFIN = iif(M_CLIFIN = 0, 9999999,M_CLIFIN) 
        M_PERINI = iif(empty(M_PERINI),ctod("01/01/80"),M_PERINI)
        M_PERFIN = iif(empty(M_PERFIN),ctod("31/12/79"),M_PERFIN) 

        select ALCR00

        set order to 3

        set relation to str(LANEMP, 2, 0) + str(LANHIS, 3, 0)                     into AMOV00R ,;
                     to str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) into ADCR00 ,; 
                     to str(ADCR00->DUPPOR, 5, 0)                                 into APOR00 


      M_IMPRE = impresn()

      if M_IMPRE = "N"
        exit
      endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        select ACLI00 

        set softseek on
          seek str(M_CLIINI, 7, 0)  
        set softseek off

      do while !eof()                   && acli00 

        if CLICOD > M_CLIFIN 
          go bottom
          skip
          loop
        endif

        store 0 to M_SALDO 

        select ALCR00 

        set softseek on
          seek str(M_EMP, 2, 0) + str(ACLI00->CLICOD, 7, 0)  
        set softseek off

        if str(LANEMP, 2, 0) + str(LANCLI, 7, 0) > str(M_EMP, 2, 0) + str(ACLI00->CLICOD, 7, 0) .or.  str(LANEMP, 2, 0) + str(LANCLI, 7, 0) < str(M_EMP, 2, 0) + str(ACLI00->CLICOD, 7, 0)                 
          select ACLI00 
          skip
          loop
        endif 

       do while !eof()                 && calcula saldo de transporte 

         if str(LANEMP, 2, 0) + str(LANCLI, 7, 0) + dtos(LANDTM) >= str(M_EMP, 2, 0) + str(ACLI00->CLICOD, 7, 0) + dtos(M_PERINI) 
           exit
         endif

         if !AMOV00R->MOVDIA == "S"
           skip
           loop
         endif 

         if AMOV00R->MOVTIP == "D"
           M_SALDO = M_SALDO - LANVAL
         else
           if AMOV00R->MOVTIP == "C"
             M_SALDO = M_SALDO + LANVAL
           endif 
         endif
  
         skip

       enddo

       if !str(LANEMP, 2, 0) + str(LANCLI, 7, 0) == str(M_EMP, 2, 0) + str(ACLI00->CLICOD, 7, 0) 
         select ACLI00
         skip
         loop 
       endif

       store 0 to PG 
                
       do while !eof()   

         store PG + 1 to PG 

           if PG > 1
              eject
           endif  

            ?     "*--------------------------------------------------------------------------------------------------------------------------------*"
            ?     "| Cliente : "
               ?? str(ACLI00->CLICOD, 5, 0)
               ?? " "
               ?? left(ACLI00->CLINOM , 40)
               ??  "               CGC: "
               ?? transform(ACLI00->CLICGC1,"@R 999.999.999/9999-99")
               ?? "               " 
               ?? AEMP00->EMPFAN 
               ?? "  |"
            ?     "| Endereco:   "
               ??  ACLI00->CLIEND1
               ?? " * * * RAZAO ANALITICO DE CLIENTES * * *  " 
               ?? "Municipio: "
               ?? left(ACLI00->CLIMUN1, 17)
               ?? " "
               ?? ACLI00->CLIUF1 
               ?? space(02) 
               ?? "|"
            ?     "| Inscr Est : "
               ?? ACLI00->CLIIES1
               ?? space(42) 
               ?? "Fone : "
               ?? ACLI00->CLITEL1
               ?? space(10)
               ?? M_DATA
               ?? "       Pag: "
               ?? str(PG, 4, 0)
               ?? space(02) 
               ?? "|"

            ?     "+----------+---------+----------------------------+---------+------------------------+------------------+------------------+-----+"               
            ?     "|   DATA   |  PORT   |  NOME CONTRAPARTIDA        | DUPCTA  |       HISTORICO        |     DEBITO       |     CREDITO      | TIP |"
            ?     "+----------+---------+----------------------------+---------+------------------------+------------------+------------------+-----+"
            ?     space(63)
               ?? "De Transporte . . .    "              
           
            if M_SALDO < 0
               ?? transform(M_SALDO,"@E ###,###,###,###.##")
               ?? space(18) 
               ?? "    "
               ?? "D"
            else
               ?? space(18)
               ?? transform(M_SALDO,"@E ###,###,###,###.##")            
               ?? "    "
               ?? "C" 
            endif  

            store 8 to LN 
         
            do while !eof() .and. LN < 56

              if !str(LANEMP, 2, 0) + str(LANCLI, 7, 0) == str(M_EMP, 2, 0) + str(ACLI00->CLICOD, 7, 0)
                go bottom
                skip
                loop 
              endif
         
              if LANDTM > M_PERFIN 
                go bottom
                skip
                loop 
              endif

              ?     " "
                 ?? LANDTM
                 ?? "     "
                 ?? str(ADCR00->DUPPOR, 5, 0)
                 ?? "    "
                 ?? left(APOR00->PORNOM, 27)
                 ?? " " 
                 ?? str(LANNUM, 6, 0)
                 ?? "/"
                 ?? strzero(LANORD, 2, 0)
                 ?? " "
                 ?? pad(AMOV00R->MOVDES,24)
                 ?? " "
                 if AMOV00R->MOVTIP == "D"
                   ?? transform(LANVAL,"@E ###,###,###,###.##")
                   ?? space(18) 
                   ?? "    "
                   ?? AMOV00R->MOVTIP
                 else
                   ?? space(18)
                   ?? transform(LANVAL,"@E ###,###,###,###.##")            
                   ?? "    "
                   ?? AMOV00R->MOVTIP
                 endif 

              if AMOV00R->MOVTIP == "D"
                M_SALDO = M_SALDO - LANVAL
              else
                if AMOV00R->MOVTIP == "C"
                  M_SALDO = M_SALDO + LANVAL
                endif 
              endif

              skip

              LN = LN + 1

                M_ESC = inkey()

                if M_ESC = 27
                  if susimp()
                    select ACLI00
                    go bottom
                    select ALCR00
                    skip
                    loop
                    ? replicate("-", 132)
                    ? "* * * IMPRESSAO SUSPENSA * * *"
                  else
                    M_ESC = inkey()
                  endif
                endif

            enddo 

            ?     space(63)
               ?? "A Transportar . . .    "              
            if M_SALDO < 0
               ?? transform(M_SALDO,"@E ###,###,###,###.##")
               ?? space(18) 
               ?? "    "
               ?? "D"
            else
               ?? space(18)
               ?? transform(M_SALDO,"@E ###,###,###,###.##")            
               ?? "    "
               ?? "C" 
            endif 
 
          enddo
            ?     replicate("-",132) 
            ?     space(63)
               ?? "Saldo Atual do Cliente:"              
            if M_SALDO < 0
               ?? transform(M_SALDO,"@E ###,###,###,###.##")
               ?? space(18) 
               ?? "    "
               ?? "D"
            else
               ?? space(18)
               ?? transform(M_SALDO,"@E ###,###,###,###.##")            
               ?? "    "
               ?? "C" 
            endif 
            ?     replicate("-",132) 

          eject

          select ACLI00 

          skip 

       enddo                   

    if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
      ?? chr(18)                        && descomprime
    endif

    eject 
 
desliga1()

  enddo

return ""

***************
function PROLCR
***************

private M_DTAFIN,; 
        M_OPC           

    do while .t.

        rodape("ELIMINA","LANCAMENTOS",M_FAN,"EAGRO32","Mem: " + str(memory(0), 5),M_EMP) 

        store date()  to M_DTAFIN

       sombra(13, 22, 16, 51,_SOMBRA_)

       set color to GR+/W+
         @ 13, 22 say    "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" 
         @ 14, 22 say    "³ Elimina Lancamento Fechado ³" 
         @ 15, 22 say    "³    Ate Data:               ³" 
         @ 16, 22 say    "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" 
  SetColor(_COREDICAO_)
        @ 15, 38 get M_DTAFIN
        read

        if lastkey() = 27
            return ""
        endif

        select ADCR00

        set order to 7

        do while .t.

          set softseek on
            seek str(ME_EMP, 2, 0) + dtos(ctod("01/01/80"))
          set softseek off

          if eof() .or. str(DUPEMP, 2, 0) + dtos(DUPDTP) > str(ME_EMP, 2, 0) + dtos(M_DTAFIN) 
            exit
          endif

          msw("* * * Eliminando Duplicata: "  + str(DUPNUM, 6, 0) + "/" + str(DUPORD, 2, 0) + " Pagamento: " + dtoc(DUPDTP) + " * * *")

          do while .t.
  
            select ALCR00

            set softseek on
              seek str(ME_EMP, 2, 0) + str(ADCR00->DUPNUM, 6, 0) + str(ADCR00->DUPORD, 2, 0)
            set softseek off
 
            if !str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) == str(ADCR00->DUPEMP, 2, 0) + str(ADCR00->DUPNUM, 6, 0) + str(ADCR00->DUPORD, 2, 0)
              exit
            endif

            elimina()

          enddo

          select ADCR00
          elimina()
 
        enddo

      commit

      msg("* * * FIM DO PROCESSAMENTO * * *")

    enddo 

return "" 

*******************
function CAB_LANLCR
*******************

  store PG + 1 to PG

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE LANCAMENTOS","EAGRO32",132) 
  ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
  ? "*-----------*---*-----------------------------*--------*--------------*--------------*--------------*---------------*--------------*"
  ? "* DUPLICATA *COD*           DESCRICAO         *  DATA  *    VALOR     *    JUROS     *   DESPESA    *   DOCUMENTO   *  OBSERVACAO  *"
  ? "*-----------*---*-----------------------------*--------*--------------*--------------*--------------*---------------*--------------*"
*      999999/99      Cliente: 99999  Nome: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Valor Atual: ###,###,###.## 

*                 999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 ###,###,###.## ###,###,###.## ###,###,###.## XXXXXXXXXXXXXX XXXXXXXXXXXXXXX


  store 5 to LN

return ""

***************** 
function VERLCR01
*****************

select AMOV00R

if M_LANHIS = 0
  return .f.
endif 

if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANHIS, 3, 0))  
  msg("* * * CODIGO DE MOVIMENTO NAO CADASTRADO * * *")
  set color to I
    @ 15, 19 say space(26) 
  set color to
  M_LANHIS = 0 
  return .f.
endif

set color to I
  @ 15, 23 say left(MOVDES,23) 
set color to

select ALCR00

if dbseek(str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0) + str(M_LANHIS, 3, 0))
  msg("* * * INSTRUCAO JA CADASTRADA * * *")
  set color to I
    @ 15, 19 say space(26) 
  set color to
  M_LANHIS = 0 
  return .f.
endif

return .t.

****************
function TLLCR01
****************

 nbox(09, 05, 18, 74,"W/W+",.t.)
 setcolor("B/W")
  @ 10, 06 say     " Duplicata:       /   Cliente :                                     "
  @ 11, 06 say     " Emissao  :           Portador:                                     "
  @ 12, 06 say     " Vencto   :           Original:                Atual:               "
  @ 13, 06 say     " Pagamento:           Cidade  :                             SIT:    "
  @ 14, 06 say     "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
  @ 15, 06 say     " Codigo    :                             Docto:                     "
  @ 16, 06 say     " Data Movto:                               Obs:                     "
  @ 17, 06 say     " Valor Lcto:                                                        "
set color to

return "" 

****************
function TLLCR02
****************

 nbox(05, 05, 19, 74,"W/W+",.t.)
 setcolor("B/W")

  @ 06, 06 say     " Duplicata:       /     Cliente :                                   "
  @ 07, 06 say     " Emissao  :             Portador:                                   "
  @ 08, 06 say     " Vencto   :             Original:                                   "
  @ 09, 06 say     " Pagamento:                Atual:                           SIT:    "
  @ 10, 06 say     "ÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ"
  @ 11, 06 say     "Mov³  Descricao    ³  Data  ³    Valor     ³  Juros/Desp  ³   Obs   "
  @ 12, 06 say     "ÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄ"
  for zz = 13 to 18
  @ zz, 06 say     "   ³               ³        ³              ³              ³         "
  next
set color to

return "" 

****************
function TLLCR03
****************

 nbox(05, 05, 19, 74,"W/W+",.t.)
 setcolor("B/W")
  @ 06, 06 say     " Cliente  :                                 Cgc:                    "
  @ 07, 06 say     " Endereco :                              Cidade:                    "
  @ 08, 06 say     " Insc Est :                                Fone:                    "
  @ 09, 06 say     "ÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ"
  @ 10, 06 say     "Mov³    Descricao       ³  Data  ³Titulo³Or³  V a l o r   ³   Obs   "
  @ 11, 06 say     "ÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄ"
  for zz = 12 to 18
  @ zz, 06 say     "   ³                    ³        ³      ³  ³              ³         "
  next
set color to

return "" 

**************** 
function MSLCR01
**************** 

set color to I 
  @ 10, 38 say DUPCLI 
  @ 10, 44 say left(ACLI00->CLINOM, 30)
  @ 11, 18 say DUPDTE
  @ 11, 38 say DUPPOR 
  @ 11, 44 say left(APOR00->PORNOM, 30) 
  @ 12, 18 say DUPVCT
  @ 12, 38 say DUPVLO picture "@E ###,###,###.##"
  @ 12, 60 say DUPVLA picture "@E ###,###,###.##" 
  @ 13, 38 say ACLI00->CLIMUN3
  @ 13, 71 say iif(DUPHIS=100,"PAG","ABE") 
set color to 

return ""      

**************** 
function MSLCR02
****************
 
set color to I 
  @ 06, 40 say DUPCLI 
  @ 06, 46 say left(ACLI00->CLINOM, 28) 
  @ 07, 18 say DUPDTE
  @ 07, 40 say DUPPOR 
  @ 07, 46 say left(APOR00->PORNOM, 28)
  @ 08, 18 say DUPVCT
  @ 08, 40 say DUPVLO picture "@E ###,###,###.##"
  @ 09, 18 say DUPDTP
  @ 09, 40 say DUPVLA picture "@E ###,###,###.##" 
  @ 09, 71 say iif(DUPHIS=100,"PAG","ABE") 
set color to 

return ""

**************** 
function MSLCR03 
****************

set color to I 
  @ 15, 19 say LANHIS 
  @ 15, 54 say LANDOC 
  @ 16, 19 say LANDTM               
  @ 16, 54 say LANOBS 
  @ 17, 19 say LANVAL picture "#########.##"
set color to
 
return "" 
 
**************** 
function EDLCR01 
****************

  SetColor(_COREDICAO_)
  @ 15, 54 get M_LANDOC picture "@!"
  @ 16, 19 get M_LANDTM valid(!M_LANDTM = ctod("  /  /  "))              
  @ 16, 54 get M_LANOBS picture "@!" 
  @ 17, 19 get M_LANVAL picture "#########.##"
  read 

return "" 

**************** 
function EDLCR02 
****************
                                              
  SetColor(_COREDICAO_)
  @ 15, 54 get M_LANDOC picture "@!"
  @ 16, 19 get M_LANDTM valid(!M_LANDTM = ctod("  /  /  "))                
  @ 16, 54 get M_LANOBS picture "@!"              
  @ 17, 19 get M_LANVAL picture "#########.##"   
  read 

return "" 

**************** 
function LPLCR01 
****************

setcolor("N/W*")
  @ 15, 19 say space(26) 
  @ 15, 54 say space(15) 
  @ 16, 19 say space(08)              
  @ 16, 54 say space(15) 
  @ 17, 19 say space(12)
set color to

return ""

****************
function GRLCR01                       && grava lancamento
****************

  select ALCR00

        do while .t. 
          if rlock()
            replace LANEMP with M_LANEMP          
            replace LANNUM with M_LANNUM
            replace LANORD with M_LANORD   
            replace LANHIS with M_LANHIS   
            replace LANDTM with M_LANDTM   
            replace LANCLI with M_LANCLI 
            replace LANVAL with M_LANVAL   
            replace LANJUR with M_LANJUR   
            replace LANDSC with M_LANDSC   
            replace LANTAX with M_LANTAX   
            replace LANOBS with M_LANOBS
            replace LANDOC with M_LANDOC
            unlock
            commit
            exit 
          else
            msg("* * * (ALCR00) REGISTRO SENDO USADO * * *")
          endif
          if lastkey() = 17
            exit
          endif 
        enddo

return ""
