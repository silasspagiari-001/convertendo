#command @ <row> , <col>  GET <var> [<clauses,...>] F2 [<moreClauses,...>] funcao <func> retorno <Variavel>;
=>       @ <row> , <col>  GET <var> [<clauses>] SEND reader := {|oGet| Getf2(oGet,<func>,<Variavel>) } [<moreClauses>]

***************
function MANLCP
***************
parameters M_OPC,M_OPC1,M_OPC2


      rodape("MENU","LANCAMENTO",M_FAN,"EAGRO42","Mem: " + str(memory(0), 5),M_EMP) 

*        @ 05, 41 prompt "Inclus„o " HIGHLITE R/BG  PERMITE 2,4,1
*        @ 06, 41 prompt "Altera‡„o" HIGHLITE R/BG  PERMITE 2,4,2
*        @ 07, 41 prompt "Consultas" HIGHLITE R/BG  PERMITE 2,4,3
*        @ 08, 41 prompt "Exclus„o " HIGHLITE R/BG  PERMITE 2,4,4
*        @ 09, 41 prompt "Listagens" HIGHLITE R/BG  PERMITE 2,4,5
*        @ 10, 41 prompt "Elimina  " POSITION 4 HIGHLITE R/BG PERMITE 2,4,6

      do case
         case M_OPC = 1 ; inclcp()
         case M_OPC = 2 ; altlcp()   
         case M_OPC = 3 ; conlcp(M_OPC1)
         case M_OPC = 4 ; exclcp()   
         case M_OPC = 5 ; lislcp(M_OPC1)
         case M_OPC = 6 ; prolcp()   
      endcase

    fecha_arq()

return ""

***************
function INCLCP
***************

private M_OPC

set key -9 to CALCULA()

        select ADCP00 

        set relation to str(DUPPOR, 5, 0) into APOR00 ,;
                     to str(DUPFOR, 7, 0) into AFOR00

  do while .t.

        M_LANEMP = M_EMP 
        M_LANNUM = 0 
        M_LANORD = 0 

        tllcp01()

        rodape("INCLUI","INSTRUCAO",M_FAN,"EAGRO42","Mem: " + str(memory(0), 5),M_EMP) 
 
        SetColor(_COREDICAO_)
        @ 10, 18 get    M_LANNUM  picture "######"
        @ 10, 25 get    M_LANORD  picture "##"        
        read

        if M_LANNUM = 0
            exit
        endif

        select ADCP00 

        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0)) 
          msg("* * * DUPLICATA NAO CADASTRADA * * *")
          loop
        endif

        mslcp01() 
      
        M_LANFOR = DUPFOR 

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

     lplcp01()  

        SetColor(_COREDICAO_)
        @ 15, 19 get M_LANHIS picture "###" valid verlcp01()
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

        select ALCP00                  && procura lancamento em branco

        _append("ALCP00") 

        do while .t.                     && grava a chave para nao permitir
          if rlock()                     && que outro lance a mesma instrucao
            replace LANEMP with M_LANEMP          
            replace LANNUM with M_LANNUM
            replace LANORD with M_LANORD   
            replace LANHIS with M_LANHIS   
            exit 
          else
            msg("* * * (ALCP00) REGISTRO SENDO USADO * * *")
          endif
          if lastkey() = 17
            exit
          endif 
        enddo

        edlcp01()                      && edita os lancamentos

        select ALCP00

        if lastkey() = 27              && se pressionou ESC
          do while .t.                 && exclui a chave do lancamento
            if rlock()
              replace LANEMP with 0
              replace LANNUM with 0
              replace LANORD with 0
              replace LANHIS with 0
              unlock
              commit
              exit 
            else
              msg("* * * (ALCP00) REGISTRO SENDO USADO * * *")
            endif
            if lastkey() = 17
              exit
            endif 
          enddo
          msg("* * * INSTRUCAO NAO INCLUIDA * * *")   
          loop
        endif 

        M_OPC = decide("Confirma Instrucao da Duplicata")

        if M_OPC = 2                   && nao confirmacao
          do while .t.                 && exclui a chave do lancamento
            if rlock()
              replace LANEMP with 0
              replace LANNUM with 0
              replace LANORD with 0
              replace LANHIS with 0
              unlock
              commit
              exit 
            else
              msg("* * * (ALCP00) REGISTRO SENDO USADO * * *")
            endif
            if lastkey() = 17
              exit
            endif 
          enddo
          msg("* * * INSTRUCAO NAO EFETUADA * * *")
          loop
        endif          
 
        grlcp01()                      && grava o lancamento 

        select ADCP00                  && atualiza dados na duplicata

        do case
           case AMOV00P->MOVTIP = "C"
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
                  msg("* * * (ADCP00) REGISTRO SENDO USADO * * *")
                endif
                 if lastkey() = 17
                   exit
                 endif
             enddo 
           case AMOV00P->MOVTIP = "D"
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
                  msg("* * * (ADCP00) REGISTRO SENDO USADO * * *")
                endif
                 if lastkey() = 17
                   exit
                 endif
             enddo 
        endcase

        msg("* * * INSTRUCAO EFETUADA * * *")
    
   enddo

  enddo

select ADCP00
 
set relation to 

return ""

*************** 
function ALTLCP
***************

        select ADCP00 

        set relation to str(DUPPOR, 5, 0) into APOR00 ,;
                     to str(DUPFOR, 7, 0) into AFOR00

  set key -9 to CALCULA()

  do while .t.
        
        M_LANEMP = M_EMP 
        M_LANNUM = 0
        M_LANORD = 0
        M_LANHIS = 0  

        tllcp01()

        rodape("ALTERA","INSTRUCAO",M_FAN,"EAGRO42","Mem: " + str(memory(0), 5),M_EMP) 
 
        SetColor(_COREDICAO_)
        @ 10, 18 get    M_LANNUM  picture "######"
        @ 10, 25 get    M_LANORD  picture "##"       
        read

        if M_LANNUM = 0
            exit
        endif

        select ADCP00 

        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0)) 
          msg("* * * DUPLICATA NAO CADASTRADA * * *")
          loop
        endif

        if !rlock()
          msg("* * * (ADCP00) REGISTRO SENDO USADO * * *")
          loop
        endif 

        mslcp01() 
      
   do while .t.

        lplcp01()  

        M_LANHIS = 0 

        SetColor(_COREDICAO_)
        @ 15, 19 get M_LANHIS picture "###"
        read 

        if M_LANHIS = 0
          exit
        endif 
             
        select AMOV00P

        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANHIS, 3, 0))  
          msg("* * * CODIGO DE MOVIMENTO NAO CADASTRADO * * *")
          loop 
        endif

        set color to I
          @ 15, 23 say left(MOVDES,23) 
        set color to
       


        select ALCP00 

        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0) + str(M_LANHIS, 3, 0)) 
          msg("* * * INSTRUCAO NAO CADASTRADA * * *")
          loop
        endif  
         
        mslcp03()                      && mostra lancamento

        if !rlock()
          msg("* * * (ALCP00) REGISTRO SENDO USADO * * *")
          loop
        endif  

        M_LANEMP = LANEMP          
        M_LANNUM = LANNUM
        M_LANORD = LANORD   
        M_LANHIS = LANHIS   
        M_LANDTM = LANDTM   
        M_LANFOR = LANFOR 
        M_LANVAL = LANVAL   
        M_LANJUR = LANJUR   
        M_LANDSC = LANDSC   
        M_LANTAX = LANTAX   
        M_LANOBS = LANOBS
        M_LANDOC = LANDOC

        select ADCP00

        do case
           case AMOV00P->MOVTIP = "C"
             do while .t.
                if rlock()
                  replace DUPVLA with DUPVLA + M_LANVAL
                  commit
                  exit 
                else
                  msg("* * * (ADCP00) REGISTRO SENDO USADO * * *")
                endif
                 if lastkey() = 17
                   exit
                 endif
             enddo 
           case AMOV00P->MOVTIP = "D"
             do while .t.
                if rlock()
                  replace DUPVLA with DUPVLA - M_LANVAL
                  commit
                  exit 
                else
                  msg("* * * (ADCP00) REGISTRO SENDO USADO * * *")
                endif
                 if lastkey() = 17
                   exit
                 endif
             enddo 
        endcase

        edlcp02()

            if lastkey() = 27
               msg("* * * INSTRUCAO NAO ALTERADA * * *")           
               loop
            endif 

        grlcp01()                      && regrava duplicata

        select ADCP00                  && atualiza dados em duplicata

        do case
           case AMOV00P->MOVTIP = "C"
             do while .t.
                if rlock()
                  replace DUPVLA with DUPVLA - M_LANVAL
                  commit
                  exit 
                else
                  msg("* * * (ADCP00) REGISTRO SENDO USADO * * *")
                endif
                 if lastkey() = 17
                   exit
                 endif
             enddo 
           case AMOV00P->MOVTIP = "D"
             do while .t.
                if rlock()
                  replace DUPVLA with DUPVLA + M_LANVAL
                  commit
                  exit 
                else
                  msg("* * * (ADCP00) REGISTRO SENDO USADO * * *")
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
              msg("* * * (ADCP00) REGISTRO SENDO USADO * * *")
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
              msg("* * * (ADCP00) REGISTRO SENDO USADO * * *")
            endif
            if lastkey() = 17
              exit
            endif
          enddo        
        endif 

        msg("* * * INSTRUCAO ALTERADA * * *")
    
   enddo

  enddo

select ADCP00
 
set relation to 

return ""

*************** 
function CONLCP                         && consulta ocorrencia 
***************
parameters M_OPC,M_OPC1,M_OPC2


*      @ 09, 46 prompt "Instrucao" HIGHLITE R/BG
*      @ 10, 46 prompt "Duplicata" HIGHLITE R/BG
*      @ 11, 46 prompt "Fornecedo" HIGHLITE R/BG

  do case
     case M_OPC = 1
       conlcp_a()
     case M_OPC = 2
       conlcp_b()
     case M_OPC = 3 
       conlcp_c()
  endcase

return ""

*****************
function CONLCP_A
*****************

  select ADCP00 

  set relation to str(DUPPOR, 5, 0) into APOR00 ,;
               to str(DUPFOR, 7, 0) into AFOR00

  do while .t.
        
        M_LANEMP = M_EMP 
        M_LANNUM = 0
        M_LANORD = 0
        M_LANHIS = 0  

        tllcp01()

        rodape("CONSULTA","INSTRUCAO",M_FAN,"EAGRO42","Mem: " + str(memory(0), 5),M_EMP) 
 
        SetColor(_COREDICAO_)
        @ 10, 18 get    M_LANNUM  picture "######"
        @ 10, 25 get    M_LANORD  picture "##"       
        read

        if M_LANNUM = 0
            exit
        endif

        select ADCP00 

        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0)) 
          msg("* * * DUPLICATA NAO CADASTRADA * * *")
          loop
        endif

        if !rlock()
          msg("* * * (ADCP00) REGISTRO SENDO USADO * * *")
          loop
        endif 

        mslcp01() 
      
     do while .t.

        lplcp01()  

        M_LANHIS = 0 

        SetColor(_COREDICAO_)
        @ 15, 19 get M_LANHIS picture "###"
        read 

        if M_LANHIS = 0
          exit
        endif 
             
        select AMOV00P

        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANHIS, 3, 0))  
          msg("* * * CODIGO DE MOVIMENTO NAO CADASTRADO * * *")
          loop 
        endif

        set color to I
          @ 15, 23 say left(MOVDES,23) 
        set color to

        select ALCP00 

        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0) + str(M_LANHIS, 3, 0)) 
          msg("* * * INSTRUCAO NAO CADASTRADA * * *")
          loop
        endif  
         
        mslcp03()                      && mostra lancamento

        msg("* * * TECLE (ENTER) * * *")
    
   enddo

  enddo

  select ADCP00
 
  set relation to 

return ""

***************** 
function CONLCP_B                         && consulta ocorrencia por Duplicata 
*****************

private M_LANEMP,; 
        M_LANNUM,; 
        M_LANORD,;
        M_LANHIS,;
        M_OPC   ,;
        K       ,;
        L

        select ALCP00 

        set relation to str(LANEMP, 2, 0) + str(LANHIS, 3, 0) into AMOV00P

      do while .t.

        M_LANEMP = M_EMP 
        M_LANNUM = 0 
        M_LANORD = 0 
        M_LANHIS = 0 

        tllcp02()

        rodape("CONSULTA","DUPLICATA",M_FAN,"EAGRO42","Mem: " + str(memory(0), 5),M_EMP) 
 
        SetColor(_COREDICAO_)
        @ 06, 18 get    M_LANNUM  picture "######"
        @ 06, 25 get    M_LANORD  picture "##"       
        read

        if M_LANNUM = 0
            exit
        endif

        select ADCP00 
   
        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0)) 
          msg("* * * DUPLICATA NAO CADASTRADA * * *")
          loop
        endif

        select AFOR00

        if !dbseek(str(ADCP00->DUPFOR, 7, 0))
          msg("* * * FORNECEDOR NAO CADASTRADO * * *")
        endif

        select APOR00

        if !dbseek(str(ADCP00->DUPPOR, 5, 0))
          msg("* * * PORTADOR NAO CADASTRADO * * *")
        endif

        select ADCP00 

        mslcp02() 

        select ALCP00 

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
            @ L, 10 say left(AMOV00P->MOVDES,15)
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

       select ALCP00
 
       set relation to

       set order to 1
 
       select ADCP00
         
       set relation to 

return ""

***************** 
function CONLCP_C                         && consulta ocorrencia por fornecedor
*****************

private M_LANFOR,; 
        M_LANEMP,; 
        M_LANDTM,;
        M_OPC
 
      select ALCP00 

      set relation to str(LANEMP, 2, 0)+ str(LANHIS, 3, 0) into AMOV00P

      do while .t.

        M_LANEMP = M_EMP 
        M_LANFOR = 0 
        M_LANDTM = ctod("  /  /  ") 

        tllcp03()

        rodape("CONSULTA","FORNECEDOR",M_FAN,"EAGRO42","Mem: " + str(memory(0), 5),M_EMP) 
 
        SetColor(_COREDICAO_)
        @ 06, 18 get    M_LANFOR  picture "#######"
        read

        if M_LANFOR = 0
            exit
        endif

        select AFOR00 
   
        if !dbseek(str(M_LANFOR, 7, 0)) 
          msg("* * * FORNECEDOR NAO CADASTRADO * * *")
          loop
        endif

        set color to I
          @ 06, 26 say left(FORNOM, 20)                        
          @ 06, 55 say FORCGC  picture "@R 999.999.999/9999-99" 
          @ 07, 18 say left(FOREND,28)                        
          @ 07, 55 say left(FORMUN,15)                        
          @ 07, 72 say FOREST                                   
          @ 08, 18 say FOREST                                   
          @ 08, 55 say pad(FORTEL, 19)                          
        set color to

        select ALCP00 

        set order to 3 

        set softseek on
          seek str(M_LANEMP, 2, 0) + str(M_LANFOR, 7, 0) + dtos(M_LANDTM) 
        set softseek off 

        if LANEMP != M_LANEMP
          msg("* * * DUPLICATA SEM MOVIMENTO * * *")
          loop
        endif

        L = 12 

        do while !eof()

          if !str(LANEMP, 2, 0) + str(LANFOR, 7, 0)  == str(M_LANEMP, 2, 0) + str(M_LANFOR, 7, 0)
            exit
          endif 

          set color to I
            @ L, 06 say LANHIS            picture "###"
            @ L, 10 say left(AMOV00P->MOVDES,20)
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

       select ALCP00

       set order to 1 

       set relation to

return ""

*************** 
function EXCLCP 
***************

private M_LANEMP,; 
        M_LANNUM,; 
        M_LANORD,;
        M_LANHIS,;
        M_LANVAL,;   
        M_OPC           

        select ADCP00 

        set relation to str(DUPPOR, 5, 0) into APOR00 ,;
                     to str(DUPFOR, 7, 0) into AFOR00

      do while .t.

        M_LANEMP = M_EMP 
        M_LANNUM = 0 
        M_LANORD = 0 
        M_LANVAL = 0

        tllcp01()

        rodape("EXCLUI","INSTRUCAO",M_FAN,"EAGRO42","Mem: " + str(memory(0), 5),M_EMP) 
 
        SetColor(_COREDICAO_)
        @ 10, 18 get    M_LANNUM  picture "######"
        @ 10, 25 get    M_LANORD  picture "##"       
        read

        if M_LANNUM = 0
            exit
        endif

        select ADCP00 

        if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0)) 
          msg("* * * DUPLICATA NAO CADASTRADA * * *")
          loop
        endif

        mslcp01() 

        do while .t.
        
          lplcp01() 

          M_LANHIS = 0 

        SetColor(_COREDICAO_)
          @ 15, 19 get    M_LANHIS  picture "###"
          read 

          if M_LANHIS = 0
            exit
          endif  

          select ALCP00 

          if !dbseek(str(M_LANEMP, 2, 0) + str(M_LANNUM, 6, 0) + str(M_LANORD, 2, 0) + str(M_LANHIS, 3, 0)) 
            msg("* * * INSTRUCAO NAO CADASTRADA * * *")
            loop
          endif  

        select AMOV00P

        seek str(ALCP00->LANEMP, 2, 0) + str(ALCP00->LANHIS, 3, 0)

        select ALCP00

        M_LANVAL = LANVAL 
          
        mslcp03()

        if !rlock()
          msg("* * * (ALCP00) REGISTRO SENDO USADO * * *")
          loop
        endif

        M_OPC = confirma("da Instrucao")

        if M_OPC != 1
          msg("* * * INSTRUCAO NAO EXCLUIDA * * *")
          loop
        endif          
        elimina()

        select ADCP00

        do case
           case AMOV00P->MOVTIP = "C"
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
                  msg("* * * (ADCP00) REGISTRO SENDO USADO * * *")
                endif
                 if lastkey() = 17
                   exit
                 endif
             enddo 
           case AMOV00P->MOVTIP = "D"
             do while .t.
                if rlock()
                  replace DUPVLA with DUPVLA - M_LANVAL
                  commit
                  unlock
                  exit 
                else
                  msg("* * * (ADCP00) REGISTRO SENDO USADO * * *")
                endif
                 if lastkey() = 17
                   exit
                 endif
             enddo 
        endcase
   
        msg("* * * INSTRUCAO EXCLUIDA * * *")

        enddo

       enddo 

    select ADCP00
 
    set relation to 
        
    select ALCP00

    set relation to 

return ""

*************** 
function LISLCP                         && consulta ocorrencia 
***************
parameters M_OPC,M_OPC1,M_OPC2

*      @ 09, 46 prompt "Instrucao" HIGHLITE R/BG
*      @ 10, 46 prompt "Diario   " HIGHLITE R/BG
*      @ 11, 46 prompt "Razao    " HIGHLITE R/BG


  do case
     case M_OPC = 1
       lislcp_a()
     case M_OPC = 2 
       lislcp_b()
     case M_OPC = 3 
       lislcp_c()
  endcase

return ""

***************** 
function LISLCP_A 
*****************

private M_NUMINI,; 
        M_ORDINI,; 
        M_NUMFIN,;
        M_ORDFIN,;
        M_OPC           

    do while .t.

        rodape("LISTA","LANCAMENTOS",M_FAN,"EAGRO42","Mem: " + str(memory(0), 5),M_EMP) 

        store 0        to M_NUMINI,;
                          M_NUMFIN,;
                          M_ORDINI,;
                          M_ORDFIN,;
                          LN

 nbox(15, 27, 18, 56,"W/W+",.t.)
 setcolor("B/W")
         @ 16, 28 say    "Duplicata Inicial:       /  "
         @ 17, 28 say    "            Final:       /  "

        SetColor(_COREDICAO_)
        @ 16, 47 get M_NUMINI picture "######"
        @ 16, 54 get M_ORDINI picture "##"   
        @ 17, 47 get M_NUMFIN picture "######"  
        @ 17, 54 get M_ORDFIN picture "##"   
        read

        if lastkey() = 27
            return ""
        endif

        M_NUMINI = iif(M_NUMINI = 0, 1,M_NUMINI)
        M_ORDINI = iif(M_ORDINI = 0, 0,M_ORDINI) 
        M_NUMFIN = iif(M_NUMFIN = 0, 999999,M_NUMFIN)
        M_ORDFIN = iif(M_ORDFIN = 0,     99,M_ORDFIN) 

        select ALCP00

        set relation to str(LANEMP, 2, 0) + str(LANHIS, 3, 0) into AMOV00P

        select ADCP00

        set relation to str(DUPFOR, 7, 0) into AFOR00 

        go top

        set softseek on
          seek str(ME_EMP, 2, 0) + str(M_NUMINI, 6, 0) + str(M_ORDINI, 2, 0)
        set softseek off

        if str(DUPEMP, 2, 0) + str(DUPNUM, 6, 0) + str(DUPORD, 2, 0) > str(ME_EMP, 2, 0) + str(M_NUMFIN, 6, 0) + str(M_ORDFIN, 2, 0)
          msg("* * * NADA A LISTAR NO INTERVALO * * *")
          loop
        endif

        M_IMPRE = impresn()

        if M_IMPRE = "N"
          return ""
        endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

    store 0 to PG

    cab_lanlcp()

    do while !eof()

       if str(DUPEMP, 2, 0) + str(DUPNUM, 6, 0) + str(DUPORD, 2, 0) > str(ME_EMP, 2, 0) + str(M_NUMFIN, 6, 0) + str(M_ORDFIN, 2, 0)
         go bottom
         skip 
         loop
       endif

        select ALCP00

        set softseek on
          seek str(ADCP00->DUPEMP, 2, 0) + str(ADCP00->DUPNUM, 6, 0) + str(ADCP00->DUPORD, 2, 0)
        set softseek off

        if !str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) == str(ADCP00->DUPEMP, 2, 0) + str(ADCP00->DUPNUM, 6, 0) + str(ADCP00->DUPORD, 2, 0)        
          select ADCP00
          skip
          loop
        endif

        store 0 to M_SLDDUP

          ? " "
           ?? str(ADCP00->DUPNUM, 6, 0)
            ?? "/"
            ?? strzero(ADCP00->DUPORD, 2, 0)
            ?? " Fornece: "
            ?? " "
            ?? str(ADCP00->DUPFOR, 7, 0)
            ?? " "
            ?? left(AFOR00->FORNOM, 40)
            ?? "      Valor Atual: "
            ?? transform(ADCP00->DUPVLA,"@E ###,###,###.##")
          ?

          LN = LN + 2

          if LN > 60
            cab_lanlcp()
          endif

        do while !eof() 

            if !str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) == str(ADCP00->DUPEMP, 2, 0) + str(ADCP00->DUPNUM, 6, 0) + str(ADCP00->DUPORD, 2, 0)        
            go bottom
            skip
            loop
          endif 

          ? space(13)
           ?? str(LANHIS, 3, 0)
           ?? " " 
           ?? left(AMOV00P->MOVDES, 29)
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
    
           if AMOV00P->MOVTIP = "D"
             M_SLDDUP = M_SLDDUP - LANVAL 
           else
             if AMOV00P->MOVTIP="C"
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
                  select ADCP00
                  go bottom
                  skip
                  select ALCP00 
                  go bottom
                  skip
                  loop
                else
                  M_ESC = inkey()
                endif
            endif

        enddo

        select ADCP00

        if abs(M_SLDDUP) != abs(DUPVLA) 
          ? "*** DIVERGENCIA -=> "
            ?? space(97)
            ?? transform((M_SLDDUP - DUPVLA),"@E ###,###,###.##")
          LN = LN + 1
          if LN > 60
             cab_lanlcp()
           endif
        endif

        ? replicate("-", 132)
  
        LN = LN + 1

        if LN > 60
           cab_lanlcp()
        endif

        skip

    enddo

    eject

desliga1()

enddo 

return "" 

*****************
function LISLCP_B                       && Diario Auxiliar de fornecedor    
*****************

private M_PERINI ,;
        M_PERFIN ,;
        M_NUMDIA ,; 
        M_SLDDEB ,;
        M_SLDCPE ,; 
        M_DIADEB ,;
        M_DIARRE ,; 
        M_DIAANT ,; 
        PG       ,; 
        LN     

  do while .t.

      rodape("LISTA","DIARIO",M_FAN,"EAGRO42","Mem: " + str(memory(0), 5),M_EMP) 

        M_SLDDEB = 0
        M_SLDCPE = 0
        M_DIADEB = 0
        M_DIACRE = 0 
        M_PERINI = ctod("  /  /  ")
        M_DIAANT = ctod("  /  /  ")
        M_PERFIN = date()
        M_NUMDIA = 1
        PG       = 0

 nbox(15, 30, 18, 56,"W/W+",.t.)
 setcolor("B/W")
          @ 16, 31 say      "Periodo Inicial:         "
          @ 17, 31 say      "          Final:         "
        SetColor(_COREDICAO_)
        @ 16, 48 get M_PERINI F2 color _CORF2_ funcao "pegadata(16,48,@M_PERINI)" retorno "re"
        @ 17, 48 get M_PERFIN F2 color _CORF2_ funcao "pegadata(17,48,@M_PERFIN)" retorno "re"
        read

        if lastkey() = 27
          exit
        endif

  M_PERINI = iif(empty(M_PERINI),ctod("01/01/80"),M_PERINI)
  M_PERFIN = iif(empty(M_PERFIN),ctod("31/12/79"),M_PERFIN)

  sqlRELATION = {}
  sqlCAMPO = {}
  sqlCHAVE =  {}
  sqlARQUI = {}
  sqlORDEM = {}

  seexistesql("ADCP00")

  cSQL = "select * from ("
  cSQL = cSQL + "SELECT 'AB' as ABERTA, ADCP00.dupnum, ADCP00.DUPDTE as DATAMOV, AMOV00P.MOVTIP,"
  cSQL = cSQL + "ADCP00.DUPVLO,AMOV00P.MOVDES,ADCP00.DUPFOR, ADCP00.DUPORD, "
  cSQL = cSQL + "AFOR00.FORNOM FROM ADCP00 left outer join AMOV00P ON AMOV00P.MOVCOD = ADCP00.DUPHIS "
  cSQL = cSQL + "left outer join AFOR00 ON AFOR00.FORCOD = ADCP00.DUPFOR "
  cSQL = cSQL + "left outer join APOR00 ON APOR00.PORCOD = ADCP00.DUPPOR "
  cSQL = cSQL + "where DUPDTE BETWEEN " + aspas(formatdta(M_PERINI)) + ' and ' + aspas(formatdta(M_PERFIN))
  cSQL = cSQL + " and ADCP00.DUPEMP =  1 "
  cSQL = cSQL + "UNION ALL "
  cSQL = cSQL + "SELECT 'PG' as PAGA  , ADCP00.DUPNUM, ADCP00.DUPDTP as DATAMOV, AMOV00P.MOVTIP, "
  cSQL = cSQL + "ADCP00.DUPVLO,AMOV00P.MOVDES, ADCP00.DUPFOR, ADCP00.DUPORD, "
  cSQL = cSQL + "AFOR00.FORNOM FROM ADCP00 left outer join AMOV00P ON AMOV00P.MOVCOD = ADCP00.DUPHIS "
  cSQL = cSQL + "left outer join AFOR00 ON AFOR00.FORCOD = ADCP00.DUPFOR "
  cSQL = cSQL + "left outer join APOR00 ON APOR00.PORCOD = ADCP00.DUPPOR "
  cSQL = cSQL + "where DUPDTP BETWEEN " + aspas(formatdta(M_PERINI)) + ' and ' + aspas(formatdta(M_PERFIN))
  cSQL = cSQL + " and ADCP00.DUPEMP =  1 ) "
  cSQL = cSQL + "order by DATAMOV"

  dbusearea(.t.,"SQLMIX",cSQL,"ADCP00")

  if eof()
    msg("* * * NADA A LISTAR NO PERIODO * * *")
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

         store PG + 1 to PG 

           if PG > 1
              eject
           endif  

            ? cent_cab(AEMP00->EMPFAN,"DIARIO AUXILIAR DE FORNECEDORES","EAGRO42",132) 
            ? cent_cab(M_DATA,"DIARIO NUMERO: " + str(M_NUMDIA, 4, 0) + " - PERIODO: " + dtoc(M_PERINI) + " A " + dtoc(M_PERFIN),"PAG.: " + str(PG, 4, 0), 132)
            ?     "*--------*-----*--------------------*-----*-------------------*---------*--------------------*------------------*------------------*" 
            ?     "* DATA   * COD * NOME DO FORNECEDOR * POR * CONTRA PARTIDA    *  DOCTO  *     HISTORICO      *   VALOR DEBITO   *   VALOR CREDITO  *" 
            ?     "*--------*-----*--------------------*-----*-------------------*---------*--------------------*------------------*------------------*" 
*                   99/99/99 99999 XXXXXXXXXXXXXXXXXXXX 99999 XXXXXXXXXXXXXXXXXXX 999999/99 XXXXXXXXXXXXXXXXXXXX ###,###,###,###.## ###,###,###,###.##  

            ?     space(70)              
               ?? "De Transporte . . .     "              
               ?? transform(M_SLDDEB,"@E ###,###,###,###.##")
               ?? " " 
               ?? transform(M_SLDCPE,"@E ###,###,###,###.##")            

            store 6 to LN 
         
            do while !eof() .and. LN < 59


              ?     " "
                 ?? DATAMOV
                 ?? " "
                 ?? str(DUPFOR, 7, 0)
                 ?? " "
                 ?? pad(FORNOM, 43)
                 ?? " "
                 ?? str(DUPNUM, 6, 0)
                 ?? "/"
                 ?? strzero(DUPORD, 2, 0)
                 ?? " "
                 ?? left(MOVDES, 19)
                 ?? "  " 
                 if MOVTIP == "D"
                   ?? transform(DUPVLO,"@E ###,###,###,###.##")
                 else
                   ?? space(17)
                   ?? transform(DUPVLO,"@E #####,###,###,###.##")
                 endif 

              if MOVTIP == "D"
                M_SLDDEB = M_SLDDEB + DUPVLO
                M_DIADEB = M_DIADEB + DUPVLO
              else
                if MOVTIP == "C"
                  M_SLDCPE = M_SLDCPE + DUPVLO
                  M_DIACRE = M_DIACRE + DUPVLO
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

          enddo

       ?     space(60)
         ?? "Saldo Final do Periodo . . . . . "              
         ?? transform(M_SLDDEB,"@E ####,###,###,###.##")
         ?? " " 
         ?? transform(M_SLDCPE,"@E ###,###,###,###.##")             

    eject 
 
desliga1()

  enddo

return ""

*****************
function LISLCP_C
*****************

private M_LANEMP ,; 
        M_LANFOR ,; 
        M_LANDTM ,;
        M_FORINI ,;
        M_FORFIN ,;
        M_PERINI ,;
        M_PERFIN ,;
        M_SALDO  ,;
        LN       ,;
        M_TELA 

  do while .t.

     rodape("LISTA","RAZAO",M_FAN,"EAGRO42","Mem: " + str(memory(0), 5),M_EMP) 

        M_LANEMP = M_EMP
        M_LANFOR = 0
        M_LANDTM = ctod("  /  /  ")
        M_FORINI = 0
        M_FORFIN = 0
        M_PERINI = ctod("  /  /  ")
        M_PERFIN = date()

 nbox(15, 30, 20, 56,"W/W+",.t.)
 setcolor("B/W")
          @ 16, 31 say      "Fornece Inicial:         "
          @ 17, 31 say      "          Final:         "
          @ 18, 31 say      "Periodo Inicial:         "
          @ 19, 31 say      "          Final:         "
        SetColor(_COREDICAO_)

        @ 16, 48 get M_FORINI  picture "#######"  
        @ 17, 48 get M_FORFIN  picture "#######"  
        @ 18, 48 get M_PERINI                   
        @ 19, 48 get M_PERFIN                   
        read

        if lastkey() = 27
          exit
        endif

        M_FORINI = iif(M_FORINI = 0,       1,M_FORINI)
        M_FORFIN = iif(M_FORFIN = 0, 9999999,M_FORFIN) 
        M_PERINI = iif(empty(M_PERINI),ctod("01/01/80"),M_PERINI)
        M_PERFIN = iif(empty(M_PERFIN),ctod("31/12/79"),M_PERFIN) 

        select ALCP00

        set order to 3

        set relation to str(LANEMP, 2, 0) + str(LANHIS, 3, 0)                     into AMOV00P ,;
                     to str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) into ADCP00 ,; 
                     to str(ADCP00->DUPPOR, 5, 0)                                 into APOR00 


      M_IMPRE = impresn()

      if M_IMPRE = "N"
        exit
      endif

        if AEMP00->EMPIMP = 80              && se impressora e de 80 colunas
          ?? chr(15)                        && comprime
        endif

        select AFOR00 

        set softseek on
          seek str(M_FORINI, 7, 0)  
        set softseek off

      do while !eof()                   && acli00 

        if FORCOD > M_FORFIN 
          go bottom
          skip
          loop
        endif

        store 0 to M_SALDO 

        select ALCP00 

        set softseek on
          seek str(M_EMP, 2, 0) + str(AFOR00->FORCOD, 7, 0)  
        set softseek off

        if str(LANEMP, 2, 0) + str(LANFOR, 7, 0) > str(M_EMP, 2, 0) + str(AFOR00->FORCOD, 7, 0) .or.  str(LANEMP, 2, 0) + str(LANFOR, 7, 0) < str(M_EMP, 2, 0) + str(AFOR00->FORCOD, 7, 0)                 
          select AFOR00 
          skip
          loop
        endif 

       do while !eof()                 && calcula saldo de transporte 

         if str(LANEMP, 2, 0) + str(LANFOR, 7, 0) + dtos(LANDTM) >= str(M_EMP, 2, 0) + str(AFOR00->FORCOD, 7, 0) + dtos(M_PERINI) 
           exit
         endif

         if !AMOV00P->MOVDIA == "S"
           skip
           loop
         endif 

         if AMOV00P->MOVTIP == "D"
           M_SALDO = M_SALDO - LANVAL
         else
           if AMOV00P->MOVTIP == "C"
             M_SALDO = M_SALDO + LANVAL
           endif 
         endif
  
         skip

       enddo

       if !str(LANEMP, 2, 0) + str(LANFOR, 7, 0) == str(M_EMP, 2, 0) + str(AFOR00->FORCOD, 7, 0) 
         select AFOR00
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
            ?     "| Fornece : "
               ?? str(AFOR00->FORCOD, 7, 0)
               ?? " "
               ?? left(AFOR00->FORNOM , 38)
               ??  "               CGC: "
               ?? transform(AFOR00->FORCGC,"@R 999.999.999/9999-99")
               ?? "               " 
               ?? AEMP00->EMPFAN 
               ?? "  |"
            ?     "| Endereco:   "
               ??  AFOR00->FOREND 
               ?? " * * * RAZAO ANALITICO FORNECEDORES  * *  " 
               ?? "Municipio: "
               ?? left(AFOR00->FORMUN1, 17)
               ?? " "
               ?? AFOR00->FOREST 
               ?? space(02) 
               ?? "|"
            ?     "| Inscr Est : "
               ?? AFOR00->FORIES 
               ?? space(42) 
               ?? "Fone : "
               ?? AFOR00->FORTEL 
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

              if !str(LANEMP, 2, 0) + str(LANFOR, 7, 0) == str(M_EMP, 2, 0) + str(AFOR00->FORCOD, 7, 0)
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
                 ?? str(ADCP00->DUPPOR, 5, 0)
                 ?? "    "
                 ?? left(APOR00->PORNOM, 27)
                 ?? " " 
                 ?? str(LANNUM, 6, 0)
                 ?? "/"
                 ?? strzero(LANORD, 2, 0)
                 ?? " "
                 ?? pad(AMOV00P->MOVDES,24)
                 ?? " "
                 if AMOV00P->MOVTIP == "D"
                   ?? transform(LANVAL,"@E ###,###,###,###.##")
                   ?? space(18) 
                   ?? "    "
                   ?? AMOV00P->MOVTIP
                 else
                   ?? space(18)
                   ?? transform(LANVAL,"@E ###,###,###,###.##")            
                   ?? "    "
                   ?? AMOV00P->MOVTIP
                 endif 

              if AMOV00P->MOVTIP == "D"
                M_SALDO = M_SALDO - LANVAL
              else
                if AMOV00P->MOVTIP == "C"
                  M_SALDO = M_SALDO + LANVAL
                endif 
              endif

              skip

              LN = LN + 1

                M_ESC = inkey()

                if M_ESC = 27
                  if susimp()
                    select AFOR00
                    go bottom
                    select ALCP00
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
               ?? "Saldo Atual do Fornece:"              
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

          select AFOR00 

          skip 

       enddo                   

    eject 
desliga1()

  enddo

return ""

***************
function PROLCP
***************

private M_DTAFIN,; 
        M_OPC           

    do while .t.

        rodape("ELIMINA","LANCAMENTOS",M_FAN,"EAGRO42","Mem: " + str(memory(0), 5),M_EMP) 

        store date()  to M_DTAFIN

       sombra(13, 22, 16, 51,_SOMBRA_)

 nbox(13, 22, 16, 51,"W/W+",.t.)
 setcolor("B/W")
         @ 14, 23 say    " Elimina Lancamento Fechado "
         @ 15, 23 say    "    Ate Data:               "
        SetColor(_COREDICAO_)

        @ 15, 38 get M_DTAFIN
        read

        if lastkey() = 27
            return ""
        endif

        select ADCP00

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
  
            select ALCP00

            set softseek on
              seek str(ME_EMP, 2, 0) + str(ADCP00->DUPNUM, 6, 0) + str(ADCP00->DUPORD, 2, 0)
            set softseek off
 
            if !str(LANEMP, 2, 0) + str(LANNUM, 6, 0) + str(LANORD, 2, 0) == str(ADCP00->DUPEMP, 2, 0) + str(ADCP00->DUPNUM, 6, 0) + str(ADCP00->DUPORD, 2, 0)
              exit
            endif

            do while .t. 
              if rlock()
                replace LANEMP with 0
                replace LANNUM with 0
                replace LANORD with 0
                replace LANHIS with 0
                replace LANDTM with ctod("  /  /  ") 
                replace LANFOR with 0 
                replace LANVAL with 0 
                unlock
                exit 
              else
                msg("* * * (ALCP00) REGISTRO SENDO USADO * * *")
              endif
              if lastkey() = 17
                 exit
              endif 
            enddo

          enddo

          select ADCP00

          do while .t.
            if rlock()
              replace  DUPEMP   with  0
              replace  DUPNUM   with  0
              replace  DUPORD   with  0
              replace  DUPSER   with  "  "
              replace  DUPFOR   with  0
              replace  DUPDTE   with  ctod("  /  /  ")
              replace  DUPVCT   with  ctod("  /  /  ")
              replace  DUPPOR   with  0
              replace  DUPVLO   with  0
              replace  DUPVLA   with  0
              replace  DUPNFS   with  0
              replace  DUPDTP   with  ctod("  /  /  ")
              replace  DUPVLP   with  0
              replace  DUPHIS   with  0
              replace  DUPOBS   with  space(14)
              replace  DUPNOM   with  space(30)
              replace  DUPCPG   with  0
              replace  DUPVEN   with  0
              replace  DUPFIS   with  0
              unlock   
              exit
            else
              msg("* * * (ADCP00) REGISTRO SENDO USADO * * *") 
            endif
            if lastkey()=17
              exit
            endif
          enddo
 
        enddo

      commit

      msg("* * * FIM DO PROCESSAMENTO * * *")

    enddo 

return "" 

*******************
function CAB_LANLCP
*******************

  store PG + 1 to PG

  if PG > 1
    eject
  endif

  ? cent_cab(AEMP00->EMPFAN,"LISTAGEM DE LANCAMENTOS","EAGRO42",132) 
  ? cent_cab(M_DATA,"","PAG.: " + str(PG, 4, 0), 132)
  ? "*-----------*---*-----------------------------*--------*--------------*--------------*--------------*---------------*--------------*"
  ? "* DUPLICATA *COD*           DESCRICAO         *  DATA  *    VALOR     *    JUROS     *   DESPESA    *   DOCUMENTO   *  OBSERVACAO  *"
  ? "*-----------*---*-----------------------------*--------*--------------*--------------*--------------*---------------*--------------*"
*      999999/99      Fornece: 99999  Nome: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Valor Atual: ###,###,###.## 

*                 999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 ###,###,###.## ###,###,###.## ###,###,###.## XXXXXXXXXXXXXX XXXXXXXXXXXXXXX


  store 5 to LN

return ""

***************** 
function VERLCP01
*****************

select AMOV00P

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

select ALCP00

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
function TLLCP01
****************

 nbox(09, 05, 18, 74,"W/W+",.t.)
 setcolor("B/W")
  @ 10, 06 say     " Duplicata:       /   Forneced:                                     "
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
function TLLCP02
****************

sombra(05, 05, 19, 74,_SOMBRA_)

 nbox(05, 05, 19, 74,"W/W+",.t.)
 setcolor("B/W")
  @ 06, 06 say     " Duplicata:       /     Forneced:                                   "
  @ 07, 06 say     " Emissao  :             Portador:                                   "
  @ 08, 06 say     " Vencto   :             Original:                                   "
  @ 09, 06 say     " Pagamento:                Atual:                           SIT:    "
  @ 10, 06 say     "ÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ"
  @ 11, 06 say     "Mov³  Descricao    ³  Data  ³    Valor     ³  Juros/Desp  ³   Obs   "
  @ 12, 06 say     "ÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄ"
  @ 13, 06 say     "   ³               ³        ³              ³              ³         "
  @ 14, 06 say     "   ³               ³        ³              ³              ³         "
  @ 15, 06 say     "   ³               ³        ³              ³              ³         "
  @ 16, 06 say     "   ³               ³        ³              ³              ³         "
  @ 17, 06 say     "   ³               ³        ³              ³              ³         "
  @ 18, 06 say     "   ³               ³        ³              ³              ³         "
  set color to

return "" 

****************
function TLLCP03
****************

 nbox(05, 05, 19, 74,"W/W+",.t.)
 setcolor("B/W")
  @ 06, 06 say     " Forneced :                                 Cgc:                    "
  @ 07, 06 say     " Endereco :                              Cidade:                    "
  @ 08, 06 say     " Insc Est :                                Fone:                    "
  @ 09, 06 say     "ÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ"
  @ 10, 06 say     "Mov³    Descricao       ³  Data  ³Titulo³Or³  V a l o r   ³   Obs   "
  @ 11, 06 say     "ÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄ"
  @ 12, 06 say     "   ³                    ³        ³      ³  ³              ³         "
  @ 13, 06 say     "   ³                    ³        ³      ³  ³              ³         "
  @ 14, 06 say     "   ³                    ³        ³      ³  ³              ³         "
  @ 15, 06 say     "   ³                    ³        ³      ³  ³              ³         "
  @ 16, 06 say     "   ³                    ³        ³      ³  ³              ³         "
  @ 17, 06 say     "   ³                    ³        ³      ³  ³              ³         "
  @ 18, 06 say     "   ³                    ³        ³      ³  ³              ³         "
set color to

return "" 

**************** 
function MSLCP01
**************** 

setcolor("N/W*")
  @ 10, 38 say DUPFOR 
  @ 10, 44 say left(AFOR00->FORNOM, 30)
  @ 11, 18 say DUPDTE
  @ 11, 38 say DUPPOR 
  @ 11, 44 say left(APOR00->PORNOM, 30) 
  @ 12, 18 say DUPVCT
  @ 12, 38 say DUPVLO picture "@E ###,###,###.##"
  @ 12, 60 say DUPVLA picture "@E ###,###,###.##" 
  @ 13, 38 say AFOR00->FORMUN
  @ 13, 71 say iif(DUPHIS=100,"PAG","ABE") 
set color to 

return ""      

**************** 
function MSLCP02
****************
 
setcolor("N/W*")
  @ 06, 40 say DUPFOR
  @ 06, 46 say left(AFOR00->FORNOM, 28) 
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
function MSLCP03 
****************

setcolor("N/W*")
  @ 15, 19 say LANHIS
  @ 15, 54 say LANDOC 
  @ 16, 19 say LANDTM               
  @ 16, 54 say LANOBS 
  @ 17, 19 say LANVAL picture "#########.##"
set color to
 
return "" 
 
**************** 
function EDLCP01 
****************

  SetColor(_COREDICAO_)
  @ 15, 54 get M_LANDOC picture "@!"
  @ 16, 19 get M_LANDTM valid(!M_LANDTM = ctod("  /  /  "))              
  @ 16, 54 get M_LANOBS picture "@!" 
  @ 17, 19 get M_LANVAL picture "#########.##"
  read 

return "" 

**************** 
function EDLCP02 
****************
                                              
  SetColor(_COREDICAO_)
  @ 15, 54 get M_LANDOC picture "@!"
  @ 16, 19 get M_LANDTM valid(!M_LANDTM = ctod("  /  /  "))                
  @ 16, 54 get M_LANOBS picture "@!"              
  @ 17, 19 get M_LANVAL picture "#########.##"   
  read 

return "" 

**************** 
function LPLCP01 
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
function GRLCP01                       && grava lancamento
****************

  select ALCP00

        do while .t. 
          if rlock()
            replace LANEMP with M_LANEMP          
            replace LANNUM with M_LANNUM
            replace LANORD with M_LANORD   
            replace LANHIS with M_LANHIS   
            replace LANDTM with M_LANDTM   
            replace LANFOR with M_LANFOR 
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
            msg("* * * (ALCP00) REGISTRO SENDO USADO * * *")
          endif
          if lastkey() = 17
            exit
          endif 
        enddo

return ""
