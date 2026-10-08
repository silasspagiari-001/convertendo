                                  /**
---------------------------------------------------------------------------
Rotinas codificadas em Harbour 3.4
Yugi386
---------------------------------------------------------------------------
*/

#include "constantes.prg"
#include "inkey.ch"

function teste4()

// SET( _SET_EVENTMASK, INKEY_ALL - INKEY_MOVE + HB_INKEY_GTEVENT )   // mouse automatico no harbour

	ylib_iniciar()	// Configurações Iniciais
	ylib_cls()

	do while .t.

		ylib_JanelaMain("H a r b o u r",YLIB_COR_TITULO,YLIB_COR_JANELA,YLIB_COR_MENU,YLIB_COR_STATUS)

		opc :=	ylib_criaMenu(01,01,{{" Iniciar ","Iniciar"},{" Menu ","Menu de opções"},{" Abas ","Abas"},{" Sair ","Sair"}},YLIB_COR_MENU,1)

		Do case
			case opc = 4 .or. opc = 0

				ylib_status()
				ret:= ylib_caixa_dialogo("ATENÇÃO!!!",08,20,13,60,YLIB_COR_CAIXA_TITULO,YLIB_COR_CAIXA_JANELA,1,;
					"Deseja fechar o sistema agora?",{{"  SIM  ","Volta ao sistema operacional"},{"  NÃO  ","Retorna ao menu principal"}},;
                        YLIB_COR_CAIXA_BOTAO, 6, 10,3)
				IF ret == 1
					EXIT
				ENDIF


			case opc = 2

				menuVertical := {{"Clientes","Clientes"},{"Fornecedores","Fornecedores"},{"Movimento","Movimento"},;
						{"-"},{"Configurações do Sistema Gerais","Config"},{"-"},{"Nota Fiscal","Notas"},{"-"},{"Sair","Sair"}}

				opc := ylib_criaMenuVertical(02,11,menuVertical,YLIB_COR_SUBMENU)

			case opc = 3

                ylib_abas("USANDO COMPONENTE TAB - <ESC = SAIR> <SHIFT + TAB = NAVEGAR>",3,2,18,80,"W+/BG","N/W", {{"Apresentação","tab(1)"},{"Novidades","tab(2)"},{"Conveniados","tab(3)"},;
                        {"Pagamentos","tab(4)"},{"Recebimentos","tab(5)"}},3)

			case opc = 1
                cliente()
		Endcase

	Enddo

// saindo do sistema
set color to
cls
close all
clear all
quit

return nil

// ======================================================================================================================================
function cliente()
                // Informações dos campos: campo, tipo, tamanho, cabeçalho, mascara, edição, conteudo
				campos := { ;
						  {"Codigo","N",12,  "     Código","999999999999",.F.,1},;
						  {"Nome","C",50,    "       Nome","@s50 ",.t.,padr("",50," ")},;
						  {"CPF","C",12,     "        CPF","9999999999-9",.t.,padr("",12," ")},;
						  {"Data","D",10,    "       Data","",.t.,date()},;
						  {"Endereço","C",50,"   Endereço","@s50 ",.t.,padr("",50," ")}	,;
						  {"Bairro","C",50,  "     Bairro","@s50 ",.t.,padr("",50," ")}	,;
	  	                  {"Complemento","C",50,"Complemento","@s50 ",.t.,padr("",50," ")}	,;
						  {"Cidade","C",50,  "     Cidade","@s50 ",.t.,padr("",50," ")}	,;
						  {"Estado","C",2,   "     Estado","",.t.,padr("",2," ")} }

				ylib_status()
				ylib_center(YLIB_LINHA_STATUS,"Cadastro",YLIB_COR_STATUS,YLIB_TOTAL_COLUNAS,-1)

				do while.t.
					ret := ylib_formulario("Clientes",05,10,16,76,YLIB_COR_FORM_TITULO,YLIB_COR_FORM_JANELA,1,campos,YLIB_COR_FORM_GET,3)

					if ret == nil
						exit
					else
						campos = aclone(ret)
						posic = ylib_len(alltrim(campos[2][7])) //  verifica o tamanho do campo nome

						// rotinas de validação (???)

						if posic <> 0
							ylib_Msg("Aviso",09,18,14,45,YLIB_COR_AVISO_TITULO,YLIB_COR_AVISO_JANELA,1,"Dados Corretos!!!",3)
							exit
						else
							ylib_Msg("Erro",09,18,14,63,YLIB_COR_ERRO_TITULO,YLIB_COR_ERRO_JANELA,1,"O Nome está vazio!!!",3)
						endif
					endif

				enddo

				// cancelamento do cadastro
				if ret == nil
					ylib_Msg("Advertência",07,18,12,55,YLIB_COR_ADVERTE_TITULO,YLIB_COR_ADVERTE_JANELA,1,"Você cancelou o cadastro!!!",3)
				endif

return nil

// ========================================================================================================================
function tab(valor)
   do case
     case valor = 1
      M_EMPCOD = 0

      SetColor(_COREDICAO_)
      @ 08, 25 get     M_EMPCOD   picture "##"
      read
      BUSCAREGISTRO("AEMP00",1,{str(M_EMPCOD,2,0)},"SELECT")

      nEMPCOD = EMPCOD

        msemp01()
        waitstate()

   endcase
   
    set color to  r+/w
    @14,25 say space(70)
    @14,25 say space(valor*10) + "aba " + alltrim(str(valor))
return



/**
---------------------------------------------------------------------------
Rotinas de interface para Harbour Rodando no Linux
Codificação: UTF-8
Yugi386
---------------------------------------------------------------------------
*/
/**
--------------------------------------------------------------------------------------------------------------------
Descrição:
[001] Criar Janela Genérica com controle de cor, posição, cor do título e sombra com 4 posições
Parâmetros:
1. mTitulo....: Titulo da janela
2. l1.........: Linha inicial da janela
3. c1.........: Coluna inicial da janela
4. l2.........: Linha final da janela
5. c2.........: Coluna final da janela
6. corTitulo..: Cor do Título da janela (Frente e Fundo)
7. corJanela..: Cor da janela (Frente e Fundo)
8. tipoSombra.: pode ser 1, 2, 3, 4, respectivamente, sombra na posição inferior esquerdo, inferior direito, superior esquerdo e superior direito
9. autocenter: centraliza a janela na tela (0 = desativado, 1= centraliza vertical, 2=centraliza horizontal, 3=centraliza vert. e Horiz.
--------------------------------------------------------------------------------------------------------------------
*/
function ylib_janela(mTitulo,l1,c1,l2,c2,corTitulo,corJanela,tipoSombra,autocentraliza)

        if autocentraliza == 1  //  centralizando a janela verticalmente
            t1 = l2 - l1
            t2 = int((maxrow()+1-t1)/2)
            l1 = t2
            l2 = t2 + t1
        elseif autocentraliza == 2 // centraliza horizontalmente
            t1 = c2 - c1
            t2 = int((maxcol()+1-t1)/2)
            c1 = t2
            c2 = t2 + t1
        elseif autocentraliza == 3 // centraliza horizontalmente e verticalmente
            t1 = c2 - c1
            t2 = int((maxcol()+1-t1)/2)
            c1 = t2
            c2 = t2 + t1
            t1 = l2 - l1
            t2 = int((maxrow()+1-t1)/2)
            l1 = t2
            l2 = t2 + t1
        endif

	if corTitulo == NIL
		corTitulo = "W/B"
	endif

	if corJanela == NIL
		corJanela = "N/W"
	endif

	// Posicionamento da sombra da Janela
	setcolor("N/N+")
	do case
		case tipoSombra == 1	// inferior esquerdo
			ylib_Sombra(l1+1,c1-1,l2+1,c2-1)
		case tipoSombra == 2	// inferior direito
			ylib_Sombra(l1+1,c1+1,l2+1,c2+1)
		case tipoSombra == 3	// superior esquerdo
			ylib_Sombra(l1-1,c1-1,l2-1,c2-1)
		case tipoSombra == 4	// superior direito
			ylib_Sombra(l1-1,c1+1,l2-1,c2+1)
		otherwise
			ylib_Sombra(l1+1,c1-1,l2+1,c2-1) // Padrão inferior esquerdo
	endcase

	// Posicionamento da Janela e Título
	setcolor(corJanela)
	@ l1,c1 clear to l2,c2
	setcolor(corTitulo)
	@ l1,c1 clear to l1,c2
	@ l1,c1+1 say mTitulo

return nil


/**
--------------------------------------------------------------------------------------------------------------------
Descrição:
[002] Construindo a Janela Principal do Programa
Parâmetros:
1. mTitulo.....: Título da tela principal do programa
2. CorTitulo...: Cor do título da janela (frente e fundo)
3. CorJanela...: Cor da Janela Principal do sistema
4. CorMenu.....: Cor do Menu principal do sistema
5. CorStatus...: Cor da barra de status do sistema (frente e fundo)
--------------------------------------------------------------------------------------------------------------------
*/
function ylib_JanelaMain(mTitulo,CorTitulo,CorJanela,CorMenu,CorStatus)

	if CorTitulo == nil
		CorTitulo = "W+/B"
	endif

	if CorJanela == nil
		CorJanela = "N/BG"
	endif

	if CorMenu = nil
		CorMenu = "N/W,W+/R"
	endif

	if CorStatus = nil
		CorStatus = "N/W,W+/R"
	endif

	setcolor(CorJanela)
	ylib_cls()

	setcolor(CorTitulo)
	@ 00,00 clear to 00,YLIB_TOTAL_COLUNAS-1
	ylib_center(00,mTitulo,CorTitulo,YLIB_TOTAL_COLUNAS,0)

	setcolor(CorStatus)
	@ YLIB_LINHA_STATUS,00 clear to YLIB_LINHA_STATUS,YLIB_TOTAL_COLUNAS-1

	setcolor(CorMenu)
	@ 01,00 clear to 01,YLIB_TOTAL_COLUNAS-1

return nil


/**
--------------------------------------------------------------------------------------------------------------------
Descrição:
[003] Centraliza mensagem na Tela em uma determinada linha ou em uma janela
Parâmetros:
1. linha.........: Linha em que a mensagem vai aparecer
2. mensagem......: Informação a ser apresentada
3. cor...........: Cor que a mensagem será apresentada (Frente e Fundo)
4. tamanhoLinha..: Define o tamanho da linha do sistema (padrão 80)
5. inicio........: Coluna inicial a ser considerada para a centralização da mensagem
--------------------------------------------------------------------------------------------------------------------
*/
function ylib_center(linha,mensagem,cor,tamanhoLinha,inicio)
	local lcor := setcolor(), posicao := 0

	if cor == nil
		cor = "N/W"
	endif

	if tamanhoLinha == nil
		tamanhoLinha = YLIB_TOTAL_COLUNAS
	endif

	if inicio == nil
		inicio = 0
	endif

	posicao = int((tamanhoLinha - ylib_len(alltrim(Mensagem))) / 2) + inicio

	setcolor(cor)
	@linha,posicao say mensagem

	setcolor(lcor)

return nil

/**
--------------------------------------------------------------------------------------------------------------------
Descrição:
[004] Cria um Menu Horizontal
Parâmetros:
1. l1...........: Linha inicial do Menu
2. c1...........: Coluna inicial do Menu
3. opcoes.......: Matriz com opções e mensagens de status do Menu
4. corMenu......: Cor do menu padrão e selecionado
5. espacamento..: Espaçamento entre os menus
--------------------------------------------------------------------------------------------------------------------
*/
function ylib_criaMenu(l1,c1,opcoes,corMenu,espacamento)
	local tam := 0, ct:=0, opc:= 0

	if corMenu == nil
		corMenu = "N/W,W+/R"
	endif

	if espacamento == nil
		espacamento = 2
	endif

	tam:= len(opcoes)
	setcolor(corMenu)
	ylib_status()

	for ct:= 1 to tam
		@ l1,c1 prompt opcoes[ct][1] message alltrim(opcoes[ct][2])
		c1 = c1 + ylib_len(opcoes[ct][1]) + espacamento
	next
	menu to opc

return opc

/**
--------------------------------------------------------------------------------------------------------------------
Descrição:
[005] Cria Um Formulário para Edição de Dados tipo Caracter, Numérico e Data
Parâmetros:
01. mTitulo....: Titulo do formulário
02. l1.........: Linha inicial da janela
03. c1.........: Coluna inicial da janela
04. l2.........: Linha final da janela
05. c2.........: Coluna final da janela
06. corTitulo..: Cor do Título da janela (Frente e Fundo)
07. corJanela..: Cor da janela (Frente e Fundo)
08. tipoSombra.: pode ser 1, 2, 3, 4, respectivamente, sombra na posição inferior esquerdo, inferior direito, superior esquerdo e superior direito
09. campos.....: Matriz com o nome do campo, tipo e tamanho
10. cor do get.: Cor do campo de leitura de variáveis
11. autocenter: centraliza a janela na tela (0 = desativado, 1= centraliza vertical, 2=centraliza horizontal, 3=centraliza vert. e Horiz.
--------------------------------------------------------------------------------------------------------------------
*/
function ylib_formulario(mTitulo,l1,c1,l2,c2,corTitulo,corJanela,tipoSombra,campos,corGet,autocentraliza)
	local maxCabecalho := 0, ct:=0, tam:=0, wcampos := Array(len(campos))

        if autocentraliza == 1  //  centralizando a janela verticalmente
            t1 = l2 - l1
            t2 = int((maxrow()+1-t1)/2)
            l1 = t2
            l2 = t2 + t1
        elseif autocentraliza == 2 // centraliza horizontalmente
            t1 = c2 - c1
            t2 = int((maxcol()+1-t1)/2)
            c1 = t2
            c2 = t2 + t1
        elseif autocentraliza == 3 // centraliza horizontalmente e verticalmente
            t1 = c2 - c1
            t2 = int((maxcol()+1-t1)/2)
            c1 = t2
            c2 = t2 + t1
            t1 = l2 - l1
            t2 = int((maxrow()+1-t1)/2)
            l1 = t2
            l2 = t2 + t1
        endif

	set cursor On
	ylib_janela(mTitulo,l1,c1,l2,c2,corTitulo,corJanela,tipoSombra)

	tam := len(campos)
	for ct:= 1 to tam
		maxCabecalho := max(maxCabecalho,ylib_len(alltrim(campos[ct][4])))
	next

	++maxcabecalho

	for ct:= 1 to tam
		if at(":",campos[ct][4]) == 0
			campos[ct][4] := alltrim(campos[ct][4]) + replicate(".",maxcabecalho - ylib_len(alltrim(campos[ct][4]))) + ":"
		endif
	next

	l1 = l1+2

	for ct:= 1 to tam
		if campos[ct][7] == NIL
			do case
				case upper(campos[ct][2]) == "C"
					wcampos[ct] = space(campos[ct][3])
				case upper(campos[ct][2]) == "D"
					wcampos[ct]  = CtoD("  /  /    ")
				case upper(campos[ct][2]) == "N"
					wcampos[ct]  = 0
			endcase
		else
			wcampos[ct] = campos[ct][7]
		endif
	next

	setcolor(corGet)
	for ct:= 1 to tam
		if campos[ct][6]
			@ l1,c1+1 say campos[ct][4] get wcampos[ct] pict campos[ct][5]
		else
			@ l1,c1+1 say alltrim(campos[ct][4]) get wcampos[ct] pict campos[ct][5] WHEN .F.
		endif
		++l1
	next
	read

	if lastkey() = 27	// se pressionar ESC o retorno é NIL
		return NIL
	else
		for ct:= 1 to tam	// preenchendo os campos de retorno
			campos[ct][7] = wcampos[ct]
		next
	endif

	set cursor off

return campos

/**
--------------------------------------------------------------------------------------------------------------------
Descrição:
[006] Tela Para Mensagem
Parâmetros:
01. mTitulo....: Titulo da Janela
02. l1.........: Linha inicial da janela
03. c1.........: Coluna inicial da janela
04. l2.........: Linha final da janela
05. c2.........: Coluna final da janela
06. corTitulo..: Cor do Título da janela (Frente e Fundo)
07. corJanela..: Cor da janela (Frente e Fundo)
08. tipoSombra.: pode ser 1, 2, 3, 4, respectivamente, sombra na posição inferior esquerdo, inferior direito, superior esquerdo e superior direito
09. Mensagem...: Mensagem de Erro ou aviso
10. autocenter: centraliza a janela na tela (0 = desativado, 1= centraliza vertical, 2=centraliza horizontal, 3=centraliza vert. e Horiz.
--------------------------------------------------------------------------------------------------------------------
*/
function ylib_Msg(mTitulo,l1,c1,l2,c2,corTitulo,corJanela,tipoSombra,mensagem,autocentraliza)
local t1, t2

       if autocentraliza == 1  //  centralizando a janela verticalmente
            t1 = l2 - l1
            t2 = int((maxrow()+1-t1)/2)
            l1 = t2
            l2 = t2 + t1
        elseif autocentraliza == 2 // centraliza horizontalmente
            t1 = c2 - c1
            t2 = int((maxcol()+1-t1)/2)
            c1 = t2
            c2 = t2 + t1
        elseif autocentraliza == 3 // centraliza horizontalmente e verticalmente
            t1 = c2 - c1
            t2 = int((maxcol()+1-t1)/2)
            c1 = t2
            c2 = t2 + t1
            t1 = l2 - l1
            t2 = int((maxrow()+1-t1)/2)
            l1 = t2
            l2 = t2 + t1
        endif

	set cursor off
	ylib_janela(mTitulo,l1,c1,l2,c2,corTitulo,corJanela,tipoSombra)
	setcolor(corJanela)
	keyboard chr(27)
	memoedit(mensagem,l1+2,c1+1,l2-1,c2-1,.F.)
	setcolor(cortitulo)
    @ l2-1,c1 + int(((c2-c1+1)-6)/2) say "  OK  "
	inkey(0)

return nil

/**
--------------------------------------------------------------------------------------------------------------------
Descrição:
[007] Sombra Real na tela
Parâmetros:
01. l1...: Linha inicial
02. c1...: Coluna Inicial
03. l2...: Linha final
04. c2...: Coluna final
---------------------------------------------------------------------------------------------------------------------
*/
function ylib_Sombra(l1,c1,l2,c2)
	local ret := "", ct:= 0, tela, coluna:=c1, linha:=l1, cor, tam:=0, acumula := ""

	tela :=savescreen(l1,c1,l2,c2)

	cor := setcolor()
	setcolor("N+/N")
    tela := hb_utf8tostr(tela)
	tam := len(tela)

	for ct:= 1 to tam step 4
		@ linha,coluna say substr(tela,ct,1)

		++ coluna
		if coluna > c2
			coluna = c1
			++ linha
		endif

		if linha > l2
			exit
		endif

	next
	// inkey(0)
	setcolor(cor)

return nil

/**
--------------------------------------------------------------------------------------------------------------------
Descrição:
[008] Cria um Menu Vertical
Parâmetros:
1. l1...........: Linha inicial do Menu
2. c1...........: Coluna inicial do Menu
3. opcoes.......: Matriz com opções e mensagens de status do Menu
4. corMenu......: Cor do menu padrão e selecionado
--------------------------------------------------------------------------------------------------------------------
*/
function ylib_criaMenuVertical(l1,c1,opcoes,corMenu)
	local tam := 0, ct:=0, opc:= 0, maxMenu:=0, l2, c2, contador:=1
	local sep_menu_direito:= chr(226) + chr(148) + chr(164),;
		  sep_menu_esquerdo:= chr(226) + chr(148) + chr(156)

	if corMenu == nil
		corMenu = "N/W,W+/R"
	endif

	// verificando o tamanho do Menu
	tam:= len(opcoes)

	for ct:= 1 to tam
		maxMenu = Max(maxMenu,ylib_len(alltrim(opcoes[ct][1])))
	next

	l2 = l1 + tam + 1
	c2 = c1 + 8 + maxMenu

	setcolor(corMenu)
	ylib_status()
	ylib_Sombra(l1+1,c1-1,l2+1,c2-1)
	@ l1,c1 clear to l2,c2
	@ l1,c1+1 to l2,c2-1
	++l1

	for ct:= 1 to tam
		if alltrim(opcoes[ct][1]) == "-"
			@ l1,c1+1 say sep_menu_esquerdo
			@ l1,c1+2 to l1,c2-2
			@l1,c2-1 say sep_menu_direito
		else
			@ l1,c1+2 prompt alltrim(str(contador)) + ". " + padr(opcoes[ct][1],c2-c1-6+(len(opcoes[ct][1])-ylib_len(opcoes[ct][1]))," ") message alltrim(opcoes[ct][2])
			++contador
		endif
		++l1
	next
	menu to opc

return opc

/**
--------------------------------------------------------------------------------------------------------------------
Descrição:
[009] Limpa a Barra de Status
--------------------------------------------------------------------------------------------------------------------
*/
function ylib_status()

	setcolor(YLIB_COR_STATUS)
	@ YLIB_LINHA_STATUS,00 clear to YLIB_LINHA_STATUS,YLIB_TOTAL_COLUNAS-1

return nil


/**
--------------------------------------------------------------------------------------------------------------------
Descrição:
[010] Caixa de Dialogo
Parâmetros:
01. mTitulo....: Titulo da Janela
02. l1.........: Linha inicial da janela
03. c1.........: Coluna inicial da janela
04. l2.........: Linha final da janela
05. c2.........: Coluna final da janela
06. corTitulo..: Cor do Título da janela (Frente e Fundo)
07. corJanela..: Cor da janela (Frente e Fundo)
08. tipoSombra.: pode ser 1, 2, 3, 4, respectivamente, sombra na posição inferior esquerdo, inferior direito, superior esquerdo e superior direito
09. Mensagem...: Mensagem de Erro ou aviso
10. opções.....: Botoes com as opcoes de saida
11. corMenu....: Cor do menu padrão e selecionado
12. espacamento: espacamento entre os itens do menu
13. margem.....: margem a partir da janela
14. autocenter: centraliza a janela na tela (0 = desativado, 1= centraliza vertical, 2=centraliza horizontal, 3=centraliza vert. e Horiz.
--------------------------------------------------------------------------------------------------------------------
*/
function ylib_caixa_dialogo(mTitulo,l1,c1,l2,c2,corTitulo,corJanela,tipoSombra,mensagem,opcoes,corMenu, espacamento, margem, autocentraliza)
	local tela, ret:=nil, t1, t2

        if autocentraliza == 1  //  centralizando a janela verticalmente
            t1 = l2 - l1
            t2 = int((maxrow()+1-t1)/2)
            l1 = t2
            l2 = t2 + t1
        elseif autocentraliza == 2 // centraliza horizontalmente
            t1 = c2 - c1
            t2 = int((maxcol()+1-t1)/2)
            c1 = t2
            c2 = t2 + t1
        elseif autocentraliza == 3 // centraliza horizontalmente e verticalmente
            t1 = c2 - c1
            t2 = int((maxcol()+1-t1)/2)
            c1 = t2
            c2 = t2 + t1
            t1 = l2 - l1
            t2 = int((maxrow()+1-t1)/2)
            l1 = t2
            l2 = t2 + t1
        endif

	save screen to tela

	set cursor off
	ylib_janela(mTitulo,l1,c1,l2,c2,corTitulo,corJanela,tipoSombra)
	setcolor(corJanela)
	keyboard chr(27)
	memoedit(mensagem,l1+2,c1+1,l2-1,c2-1,.F.)
	setcolor(cortitulo)
	ret := ylib_criaMenu(l2-1,c1+margem,opcoes,corMenu,espacamento)

	restore screen from tela

return ret

/**
--------------------------------------------------------------------------------------------------------------------
Descrição:
[011] Limpa toda a tela
--------------------------------------------------------------------------------------------------------------------
*/
function ylib_cls(l1,c1,l2,c2)
	setcolor(YLIB_COR_JANELA)
	if pcount()==0
		@ 00,00 clear to YLIB_TOTAL_LINHAS-1,YLIB_TOTAL_COLUNAS-1
	else
		@ l1,c1 clear to l2,c2
	endif
return nil

/**
--------------------------------------------------------------------------------------------------------------------
Descrição:
[012] Cria uma tela para controlar abas
Parãmetros:
1. Título
2. Linha inicial
3. Coluna inicial
4. Linha Final
5. Coluna Final
6. Cor Título
7. Cor frente e fundo da janela
8. título das abas: array com o título das abas e funções executadas em cada uma
9. autocenter: centraliza a janela na tela (0 = desativado, 1= centraliza vertical, 2=centraliza horizontal, 3=centraliza vert. e Horiz.
--------------------------------------------------------------------------------------------------------------------
*/


*                ylib_abas("USANDO COMPONENTE TAB - <ESC = SAIR> <SHIFT + TAB = NAVEGAR>",3,2,18,80,"W+/BG","N/W", {{"Apresentação","tab(1)"},{"Novidades","tab(2)"},{"Conveniados","tab(3)"},;
*                        {"Pagamentos","tab(4)"},{"Recebimentos","tab(5)"}},3)

function ylib_abas(titulo,l1,c1,l2,c2,corTitulo, corJanela, abas,autocentraliza)
    local lcabecalho:=0, ct:=0, tam:=0, pcor, cor1, cor2, posicao, t1, t2

        if autocentraliza == 1  //  centralizando a janela verticalmente
            t1 = l2 - l1
            t2 = int((maxrow()+1-t1)/2)
            l1 = t2
            l2 = t2 + t1
        elseif autocentraliza == 2 // centraliza horizontalmente
            t1 = c2 - c1
            t2 = int((maxcol()+1-t1)/2)
            c1 = t2
            c2 = t2 + t1
        elseif autocentraliza == 3 // centraliza horizontalmente e verticalmente
            t1 = c2 - c1
            t2 = int((maxcol()+1-t1)/2)
            c1 = t2
            c2 = t2 + t1
            t1 = l2 - l1
            t2 = int((maxrow()+1-t1)/2)
            l1 = t2
            l2 = t2 + t1
        endif

        lcabecalho := l1 + 1

        ylib_janela(titulo,l1,c1,l2,c2,corTitulo,corJanela,1)
        ylib_janela(titulo,l1,c1,l2,c2,corTitulo,corJanela,2)

        tam := len(abas) // verificando a quantidade de abas

        // Calculando a cor inversa para criar o efetio das abas
        cor1 = corJanela
        pcor2 = at("/",corjanela)
        cor2 = substr(corjanela,pcor2+1) + "/" + substr(corjanela,1,pcor2-1)

        ct = 1
        posicao = 1

		do while.t.
		    setcolor("n/n")
		    @ lcabecalho,c1 clear to lcabecalho,c2

            setpos(lcabecalho,c1)

            for ct:= 1 to tam
                if posicao == ct
                    setcolor(cor1)
                else
                    setcolor(cor2)
                endif
                ?? " " + abas[ct][1] + " "
            next

            &(abas[posicao][2])    //  executando funcao

            // gerenciando a mudança de abas
            do while.t.
            	inkey(0)
                if lastkey() == 271     //  shift + tab
                    ++posicao
                    if posicao > tam
                        posicao = 1
                    endif
                    exit
                endif
      			    if lastkey() = 27
			      	    exit
			          endif
            enddo

		    if lastkey() = 27
			    exit
		    endif

		enddo

return nil

/**
--------------------------------------------------------------------------------------------------------------------
Descrição:
[013] Conta quantos caracteres existem na codificação utf-8 para letras acentuadas
Substitui a função len() quando se usa a codificação utf-8
Parâmetros:
1. palavra.....: String para verificar o tamanho
--------------------------------------------------------------------------------------------------------------------
*/
function ylib_len(palavra)
	local tam:= 0

    palavra := hb_utf8tostr(palavra)
	tam := len(palavra)

return tam



function ylib_iniciar()

	REQUEST HB_LANG_PT
*	REQUEST HB_CODEPAGE_UTF8EX
	HB_LANGSELECT( 'PT' )
	HB_CDPSELECT( "UTF8EX" )

	set date french
	set century on
	set scoreboard off
	set cursor off
	setblink(.f.)
	set confirm on
	setmode(YLIB_TOTAL_LINHAS,YLIB_TOTAL_COLUNAS)
	set message to YLIB_LINHA_STATUS center
	set wrap On

return nil



********************
function IMPORTARDBF
********************



*ABRE_ETQ()
*CRIADBFTOSQL("AETQ00",.T.)  // IMPORTADO

*ABRE_pcamor()
*CRIADBFTOSQL("APCMOR",.T.)  // IMPORTADO

*ABRE_climor()
*CRIADBFTOSQL("ACLMOR",.T.)  // IMPORTADO

*ABRE_TIP()
*CRIADBFTOSQL("ATIP00",.T.)  // IMPORTADO


*MyDialogOne()

*ABRE_REQ0()
*CRIADBFTOSQL("AREQ00",.T.)  // IMPORTADO
*ABRE_REQ1()
*CRIADBFTOSQL("AREQ01",.T.)  // IMPORTADO

*ABRE_POR()
*CRIADBFTOSQL("APOR00",.T.)  // IMPORTADO

*ABRE_MUN()
*CRIADBFTOSQL("AMUN00",.T.)  // IMPORTADO

*ABRE_LOG()
*CRIADBFTOSQL("ALOG10",.T.)  // IMPORTADO

*ABRE_MCP()
*CRIADBFTOSQL("AMOV00P",.T.)  // IMPORTADO

*ABRE_HIB()


**********************
function BUSCAREGISTRO(cArquivo,cIndice,aChaRegistro,cAcao)
**********************

local ABCD

sqlORDEM = {}

*    index on str(REQEMP, 2, 0) + dtos(REQVC6) tag 7 to &_PATH_\USR\FATURA\AREQ00 for REQFRC == "S"  // somente aluguel


do case
case cArquivo == "ALOG10"
   do case
      case cIndice = 1
         aCamposSQL := {"LOGEMP","LOGNOM"}
      case cIndice = 2
         aCamposSQL := {"LOGEMP","LOGSEN"}
      case cIndice = 3
         aCamposSQL := {"LOGEMP","LOG21"}
   endcase
case cArquivo == "CBNEF"
    aCamposSQL := {"CODCBNEF"}
case cArquivo == "AANO00"
    do case
      case cIndice = 1
        aCamposSQL := {"ANOEMP","ANOFAB","ANONUM"}
    endcase
    
case cArquivo == "AMEM00"
    do case
      case cIndice = 1
        aCamposSQL := {"ETQCOD"}
    endcase
    
    
case cArquivo == "AETQ00"
    do case
      case cIndice = 1
        aCamposSQL := {"ETQCOD"}
    endcase

case cArquivo == "AMOV00P"
   aCamposSQL := {"MOVCOD"}

case cArquivo == "AHIS00"
    do case
      case cIndice = 1
        aCamposSQL := {"HISCOD"}
    endcase
case cArquivo == "APCH00"
    do case
      case cIndice = 1
        aCamposSQL := {"PCHBAN"}
    endcase

case cArquivo == "APCMOR"
    do case
      case cIndice = 1
             aCamposSQL := {"PCAMAT"}
    endcase

case cArquivo == "AREQ00"
    do case
      case cIndice = 1
        aCamposSQL := {"REQEMP","REQNUM","REQSER"}
      case cIndice = 2
        aCamposSQL := {"REQEMP","REQDTE","REQNUM","REQSER"}
      case cIndice = 3
        aCamposSQL := {"REQEMP","REQDTE","REQCLI"}
      case cIndice = 4
        aCamposSQL := {"REQEMP","REQCLI","REQDTE"}
     case cIndice = 5
        aCamposSQL := {"REQEMP","REQCLI","REQDTE","REQNUM","REQSER"}
     case cIndice = 6
        aCamposSQL := {"REQEMP","REQCLI","REQDTE","REQNUM","REQSER"}
          sqlORDEM := {"REQDTE desc"}
     case cIndice = 6
        aCamposSQL := {"REQEMP","REQVC6","CONDICAO"}
        aadd(aChaRegistro,"REQFRC == 'S'")
        sqlORDEM := {"REQDTE desc"}
    endcase

case cArquivo == "AREQ01"
    do case
      case cIndice = 1
        aCamposSQL := {"REQEMP","REQNUM","REQSER","REQSEQ"}
    endcase
case cArquivo == "MENSAGE2"
    do case
      case cIndice = 1
        aCamposSQL := {"CLICOD"}
    endcase
case cArquivo == "AESTADO"
    do case
      case cIndice = 1
        aCamposSQL := {"UFSIGLA"}
    endcase
case cArquivo == "ACUP00"
    do case
      case cIndice = 1
        aCamposSQL := {"CUPEMP","CUPNUM","CUPSER"}
      case cIndice = 2
        aCamposSQL := {"CUPEMP","CUPNFS"}
      case cIndice = 3
        aCamposSQL := {"CUPEMP","CUPDTE","CUPNUM"}
      case cIndice = 4
        aCamposSQL := {"CUPEMP","CUPCLI","CUPDTE"}
          sqlORDEM := {"CUPDTE desc"}
    endcase
case cArquivo == "ACUP01"
    do case
      case cIndice = 1
        aCamposSQL := {"CUPEMP","CUPNUM","CUPSER","CUPSEQ"}
      case cIndice = 2
        aCamposSQL := {"CUPEMP","CUPNUM","CUPSER"}
    endcase
case cArquivo == "APEDDEP"
    do case
      case cIndice = 1
             aCamposSQL := {"PEDEMP","PEDNUM","PEDSER"}
    endcase
case cArquivo == "ADCBOL"
    do case
      case cIndice = 1
        aCamposSQL := {"DUPBOL"}
    endcase
case cArquivo == "USUIMP"
    do case
      case cIndice = 1
        aCamposSQL := {"MAQUINA"}
    endcase
case cArquivo == "AEMP00"
    do case
      case cIndice = 1
        aCamposSQL := {"EMPCOD"}
          sqlORDEM := {"EMPCOD"}
    endcase
case cArquivo == "APCFOR"
    do case
      case cIndice = 1
        aCamposSQL := {"PCAMAT"}
      case cIndice = 2
        aCamposSQL := {"PCAMAT","PCAFOR","PCACODFOR"}
      case cIndice = 3
        aCamposSQL := {"PCACODFOR"}
    endcase
case cArquivo == "ANCM00"
    do case
      case cIndice = 1
        aCamposSQL := {"NCMCOD"}
      case cIndice = 2
        aCamposSQL := {"NCMNOM01"}
    endcase
case cArquivo == "ANFS00"
    do case
      case cIndice = 1
        aCamposSQL := {"NFSEMP","NFSNUM","NFSSER"}
      case cIndice = 2
        aCamposSQL := {"NFSEMP","NFSDTE","NFSNUM","NFSSER"}
      case cIndice = 3
        aCamposSQL := {"NFSEMP","NFSDTE","NFSNAT"}
      case cIndice = 4
        aCamposSQL := {"NFSEMP","NFSDTE","NFSCLI"}
      case cIndice = 5
        aCamposSQL := {"NFSEMP","NFSIPL"}
      case cIndice = 6
        aCamposSQL := {"NFSEMP","NFSTDC","NFSDOC"} // for NFSDOC > 0
      case cIndice = 7
        aCamposSQL := {"NFSEMP","NFSCLI","NFSDTE"} //+ descend(dtos(NFSDTE))
          sqlORDEM := {"NFSDTE desc"}
    endcase
case cArquivo == "ADCR00"
    do case
      case cIndice = 1
           aCamposSQL := {"DUPEMP","DUPNUM","DUPORD","DUPSER"}
      case cIndice = 2
           aCamposSQL := {"DUPEMP","DUPCLI","DUPVCT"}
      case cIndice = 3
           aCamposSQL := {"DUPEMP","DUPPOR","DUPCLI","DUPVCT"}
      case cIndice = 4
           aCamposSQL := {"DUPEMP","DUPDTE"}
      case cIndice = 5
           aCamposSQL := {"DUPEMP","DUPVCT","DUPCLI"}
      case cIndice = 6
           aCamposSQL := {"DUPEMP","DUPNOM","DUPVCT"}
      case cIndice = 7
           aCamposSQL := {"DUPEMP","DUPDTP","DUPNUM","DUPORD"}
      case cIndice = 8
           aCamposSQL := {"DUPBOL"}
      case cIndice = 9
           aCamposSQL := {"DUPEMP","DUPEXP"}

    endcase
case cArquivo == "ALCR00"
    do case
      case cIndice = 1
           aCamposSQL := {"LANEMP","LANSER","LANNUM","LANORD","LANHIS"}
      case cIndice = 2
           aCamposSQL := {"LANEMP","LANSER","LANNUM","LANORD","LANDTM"}
      case cIndice = 3
           aCamposSQL := {"LANEMP","LANCLI","LANDTM"}
      case cIndice = 4
           aCamposSQL := {"LANEMP","LANDTM"}
    endcase
case cArquivo == "APED01"
    do case
      case cIndice = 1
           aCamposSQL := {"PEDEMP","PEDNUM","PEDSER","PEDSEQ"}
      case cIndice = 2
           aCamposSQL := {"PEDEMP","PEDENT","PEDDTE"}
    endcase
case cArquivo == "ACLI00"
    do case
      case cIndice = 1
             aCamposSQL := {"CLICOD"}
      case cIndice = 2
             aCamposSQL := {"CLINOM"}
      case cIndice = 3
             aCamposSQL := {"CLICGC1"}
      case cIndice = 4
             aCamposSQL := {"CLIMUN1"}
      case cIndice = 5
             aCamposSQL := {"CLINOM"}    //    tag 5 to &_PATH_\USR\FATURA\ACLI00 for CLIATI == "S"
    endcase
case cArquivo == "AFIS00"
    do case
      case cIndice = 1
             aCamposSQL := {"FISEMP","FISNOV"}
      case cIndice = 2
             aCamposSQL := {"FISEMP","FISNOV"}
    endcase
case cArquivo == "AGRP00"
    do case
      case cIndice = 1
             aCamposSQL := {"GRPCOD"}
      case cIndice = 2
             aCamposSQL := {"GRPNOM"}
    endcase
case cArquivo == "ACVE00"
    do case
      case cIndice = 1
             aCamposSQL := {"CVEEST","CVECOD"}
    endcase
case cArquivo == "APCA00"
    do case
      case cIndice = 1
             aCamposSQL := {"PCAMAT"}
      case cIndice = 2
             aCamposSQL := {"PCAGRP","PCAMAT"}
      case cIndice = 3
             aCamposSQL := {"PCADES"}                      //         for ATIVO == "S"
      case cIndice = 4
             aCamposSQL := {"PCAGRP","PCASUBGRU","PCADES"} //        	for ATIVO == "S"
      case cIndice = 5
             aCamposSQL := {"PCAREF"}                      //         for ATIVO == "S"
      case cIndice = 6
             aCamposSQL := {"PCATIP","PCADES"} 				//	for ATIVO == "S"
      case cIndice = 7
             aCamposSQL := {"PCAGRP","PCADES"}        //   for ATIVO == "S"
      case cIndice = 8
             aCamposSQL := {"PCAFOR","PCADES"}        //   for ATIVO == "S"
      case cIndice = 9
             aCamposSQL := {"PCADES"}            			//  for !ATIVO == "S"
    endcase
case cArquivo == "APCA02"
    do case
      case cIndice = 1
             aCamposSQL := {"PCAMAT"}
    endcase
case cArquivo == "ASLD00"
    do case
      case cIndice = 1
             aCamposSQL := {"SLDEMP","SLDMAT"}
    endcase
case cArquivo == "AKAR00"
    do case
      case cIndice = 1
             aCamposSQL := {"KAREMP","KARMAT","KARDTA","KARFIS","KARDOC","KARSEQ"}
      case cIndice = 2
             aCamposSQL := {"KAREMP","KARMAT","KARDTA","KARFIS","KARDOC","KARSEQ"} // for KARFIS < 50000
    endcase
case cArquivo == "AVEN00"
    do case
      case cIndice = 1
             aCamposSQL := {"VENCOD"}
      case cIndice = 3
             aCamposSQL := {"VENNOM"}
    endcase
case cArquivo == "AFOR00"
    do case
      case cIndice = 1
             aCamposSQL := {"FORCOD"}
      case cIndice = 2
             aCamposSQL := {"FORNOM"}
      case cIndice = 3
             aCamposSQL := {"FORCGC"}
    endcase
case cArquivo == "ATRA00"
    do case
      case cIndice = 1
             aCamposSQL := {"TRACOD"}
      case cIndice = 2
             aCamposSQL := {"TRANOM"}
    endcase
case cArquivo == "ACPG00"
    do case
      case cIndice = 1
             aCamposSQL := {"CPGCOD"}
      case cIndice = 2
             aCamposSQL := {"CPGDES"}
    endcase
case cArquivo == "ANFS01"
    do case
      case cIndice = 1
             aCamposSQL := {"NFSEMP","NFSNUM","NFSSER","NFSSEQ"}
    endcase
case cArquivo == "ADCRDD"
    do case
      case cIndice = 1
             aCamposSQL := {"DUPEMP","DUPSER","DUPNUM","DUPORD"}
      case cIndice = 2
             aCamposSQL := {"DUPEMP","DUPDTE"}
      case cIndice = 3
             aCamposSQL := {"DUPEMP","DUPSIT"}
    endcase
case cArquivo == "ADCPDD"
    do case
      case cIndice = 1
             aCamposSQL := {"DUPEMP","DUPNUM","DUPORD"}
      case cIndice = 2
             aCamposSQL := {"DUPEMP","DUPDTE"}
      case cIndice = 3
             aCamposSQL := {"DUPEMP","DUPSIT"}
    endcase
case cArquivo == "APOR00"
    do case
      case cIndice = 1
             aCamposSQL := {"PORCOD"}
      case cIndice = 2
             aCamposSQL := {"PORNOM"}
    endcase
case cArquivo == "ANFE00"
    do case
      case cIndice = 1
             aCamposSQL := {"NFEEMP","NFENUM","NFESER","NFEFOR"}
      case cIndice = 2
             aCamposSQL := {"NFEEMP","NFEDTR","NFENUM","NFESER","NFEFOR"}
    endcase
case cArquivo == "ANFE01"
    do case
      case cIndice = 1
             aCamposSQL := {"NFEEMP","NFENUM","NFESER","NFEFOR","NFESEQ"}
      case cIndice = 2
             aCamposSQL := {"NFEEMP","NFEMAT","NFEDTR"} 	//descend(str(NFEEMP, 2, 0)
      case cIndice = 3
             aCamposSQL := {"NFEEMP","NFENUM","NFEFOR"}
    endcase
case cArquivo == "ANFE50"
    do case
      case cIndice = 1
             aCamposSQL := {"NFEEMP","NFEDTR","NFENUM","NFESER","NFEFOR","NFENAT"}
      case cIndice = 2
             aCamposSQL := {"NFEFOR"}
    endcase
case cArquivo == "ADCP00"
    do case
      case cIndice = 1
             aCamposSQL := {"DUPEMP","DUPNUM","DUPORD"}
      case cIndice = 2
             aCamposSQL := {"DUPEMP","DUPFOR","DUPVCT"}
      case cIndice = 3
             aCamposSQL := {"DUPEMP","DUPPOR","DUPVCT"}
      case cIndice = 4
             aCamposSQL := {"DUPEMP","DUPDTE","DUPFOR"}
      case cIndice = 5
             aCamposSQL := {"DUPEMP","DUPVCT"}
      case cIndice = 6
             aCamposSQL := {"DUPEMP","DUPNOM"}
      case cIndice = 7
             aCamposSQL := {"DUPEMP","DUPDTP","DUPNUM","DUPORD"}
    endcase
case cArquivo == "ALCP00"
    do case
      case cIndice = 1
             aCamposSQL := {"LANEMP","LANNUM","LANORD","LANHIS"}
      case cIndice = 2
             aCamposSQL := {"LANEMP","LANNUM","LANORD","LANDTM"}
      case cIndice = 3
             aCamposSQL := {"LANEMP","LANFOR","LANDTM"}
      case cIndice = 4
             aCamposSQL := {"LANEMP","LANDTM"}
    endcase
case cArquivo == "AMOV00"
    do case
      case cIndice = 1
             aCamposSQL := {"MOVEMP","MOVCOD"}
    endcase
case cArquivo == "APLX00"
    do case
      case cIndice = 1
             aCamposSQL := {"PLXEMP","PLXCTA"}
      case cIndice = 2
             aCamposSQL := {"PLXEMP","PLXNOM"}
    endcase
case cArquivo == "ALAX00"
    do case
      case cIndice = 1
             aCamposSQL := {"LAXEMP","LAXDTA","LAXCTA","LAXSEQ"}
      case cIndice = 2
             aCamposSQL := {"LAXEMP","LAXCTA","LAXDTA","LAXSEQ"}
    endcase
case cArquivo == "ACTA00"
    do case
      case cIndice = 1
             aCamposSQL := {"CTAEMP","CTACTA"}
      case cIndice = 2
             aCamposSQL := {"CTAEMP","CTABAN"}
    endcase
case cArquivo == "ALAB00"
    do case
      case cIndice = 1
             aCamposSQL := {"LANEMP","LANCTA","LANSEQ"}
      case cIndice = 2
             aCamposSQL := {"LANEMP","LANCTA","LANDTA","LANSEQ"}
    endcase
case cArquivo == "ACHE00"
    do case
      case cIndice = 1
             aCamposSQL := {"CHEEMP","CHECTA","CHENUM"}
      case cIndice = 2
             aCamposSQL := {"CHEEMP","CHEIPL"}
    endcase
case cArquivo == "ACHEQ0"
    do case
      case cIndice = 1
             aCamposSQL := {"CHEEMP","CHEBCO","CHEAGE","CHENUM"}
      case cIndice = 2
             aCamposSQL := {"CHEEMP","CHESIT"}
      case cIndice = 3
             aCamposSQL := {"CHEEMP","CHEVCT"}
      case cIndice = 4
             aCamposSQL := {"CHEEMP","CHEDTE"}
    endcase
case cArquivo == "ALOG10"
    do case
      case cIndice = 1
             aCamposSQL := {"LOGEMP","LOGNOM"}
      case cIndice = 2
             aCamposSQL := {"LOGEMP","LOGSEN"}
    endcase
case cArquivo == "APED00"
    do case
      case cIndice = 1
             aCamposSQL := {"PEDEMP","PEDNUM","PEDSER"}
      case cIndice = 2
             aCamposSQL := {"PEDEMP","PEDDTE","PEDNUM","PEDSER"}
      case cIndice = 3
             aCamposSQL := {"PEDEMP","PEDDTE","PEDNAT"}
      case cIndice = 4
             aCamposSQL := {"PEDEMP","PEDDTE","PEDCLI"}
      case cIndice = 5
             aCamposSQL := {"PEDEMP","PEDIPL"}
      case cIndice = 6
             aCamposSQL := {"PEDEMP","PEDCLI","PEDDTE"}
    endcase
case cArquivo == "APEDDEP"
    do case
      case cIndice = 1
             aCamposSQL := {"PEDEMP","PEDNUM","PEDSER"}
    endcase
case cArquivo == "APRD00"
    do case
      case cIndice = 1
             aCamposSQL := {"PRDEMP","PRDCHE","PRDORD"}
      case cIndice = 2
             aCamposSQL := {"PRDEMP","PRDBAN"}
      case cIndice = 3
             aCamposSQL := {"PRDEMP","PRDDTE"}
      case cIndice = 4
             aCamposSQL := {"PRDEMP","PRDVCT"}
      case cIndice = 5
             aCamposSQL := {"PRDEMP","PRDPOR"}
      case cIndice = 6
             aCamposSQL := {"PRDEMP","PRDCTA"}
    endcase
case cArquivo == "ATEL00"
    do case
      case cIndice = 1
             aCamposSQL := {"TELNUM","TELDDD"}
      case cIndice = 2
             aCamposSQL := {"TELNOM"}
      case cIndice = 3
             aCamposSQL := {"TELMUN"}
    endcase
case cArquivo == "AMUN00"
    do case
      case cIndice = 1
             aCamposSQL := {"MUNCOD"}
      case cIndice = 2
             aCamposSQL := {"MUNNOM"}

    endcase
case cArquivo == "ABSP00"
    do case
      case cIndice = 1
             aCamposSQL := {"BANEMP","BANSER","BANNUM","BANORD"}
      case cIndice = 2
             aCamposSQL := {"BANEMP","BANDTE"}
    endcase
case cArquivo == "ASUB00"
    do case
      case cIndice = 1
             aCamposSQL := {"SUBCOD"}
      case cIndice = 2
             aCamposSQL := {"SUBNOM"}
    endcase
case cArquivo == "AMAR00"
    do case
      case cIndice = 1
             aCamposSQL := {"MARGRU","MARSUB"}
    endcase
case cArquivo == "ATIP00"
    do case
      case cIndice = 1
             aCamposSQL := {"CVECOD"}
      case cIndice = 2
             aCamposSQL := {"CVENOM"}
    endcase
case cArquivo == "AIMP00"
    do case
      case cIndice = 1
               aCamposSQL := {"IMPCOD"}
      case cIndice = 2
               aCamposSQL := {"IMPNOM"}
    endcase
case cArquivo == "AMAR01"
    do case
      case cIndice = 1
             aCamposSQL := {"MARGRU"}
    endcase
case cArquivo == "ACLISE"
    do case
      case cIndice = 1
             aCamposSQL := {"CLICOD"}
    endcase
case cArquivo == "ANFSCAN"
    do case
      case cIndice = 1
             aCamposSQL := {"NFSEMP","NFSNUM","NFSSER"}
    endcase
case cArquivo == "APROF0"
    do case
      case cIndice = 1
             aCamposSQL := {"VENCOD"}
      case cIndice = 2
             aCamposSQL := {"VENNOM"}
      case cIndice = 3
             aCamposSQL := {"VENCPF"}
      case cIndice = 4
             msgbox1("data aniversario como")
*            aCamposSQL := {"strzero(month(VENDTE),2) +  strzero(day(VENDTE),2) tag 4 to &_PATH_\USR\FATURA\APROF0

*           aCamposSQL := {"SELECT * FROM APROF0 WHERE EXTRACT(MONTH FROM VENDTE) BETWEEN '01' AND '01'

    endcase
case cArquivo == "ADEV00"
    do case
      case cIndice = 1
             aCamposSQL := {"PEDEMP","PEDNUM","PEDSER","NFSMAT"}
      case cIndice = 2
             aCamposSQL := {"NFSEMP","NFSNUM","NFSSER","NFSMAT"}
    endcase
case cArquivo == "CLIEMA"
    do case
      case cIndice = 1
             aCamposSQL := {"CLICOD"}
    endcase

otherwise
  msgbox1(cArquivo + " nao cadastrado no sql")
endcase

sqlCAMPO = {}
sqlCHAVE = {}
sqlARQUI = {cArquivo,cAcao}


if cIndice = 0  // select * from
else
  for ABCD = 1 to len(aChaRegistro)
    aadd(sqlCHAVE,{aCamposSQL[ABCD],aChaRegistro[ABCD]})
  next
endif

if !executasql()
  return .f.
endif

select &cArquivo
return .t.

*CRIADBFTOSQL("AHIS00",.T.)  // IMPORTADO

*SELECT 0
*use &_PATH_\USR\ESTOQUE\AEMP00
*CRIADBFTOSQL("AEMP00",.T.)  // IMPORTADO


*ABRE_PCH()
*CRIADBFTOSQL("APCH00",.T.)  // IMPORTADO
*ABRE_PCA()
*CRIADBFTOSQL("APCA00",.T.)  // IMPORTADO
*ABRE_SLD()
*CRIADBFTOSQL("ASLD00",.T.)  // IMPORTADO
*ABRE_TEL()
*CRIADBFTOSQL("ATEL00",.T.)  // IMPORTADO
*ABRE_FIS()
*CRIADBFTOSQL("AFIS00",.T.)  // IMPORTADO
*ABRE_nfe0()
*CRIADBFTOSQL("ANFE00",.T.)   // IMPORTADO
*ABRE_nfe1()
*CRIADBFTOSQL("ANFE01",.t.)   // IMPORTADO
*ABRE_NFS0()
*CRIADBFTOSQL("ANFS00",.f.) //IMPORTADO
*ABRE_NFS1()
*CRIADBFTOSQL("ANFS01",.f.) //IMPORTADO
*ABRE_dcr()
*CRIADBFTOSQL("ADCR00",.f.) //IMPORTADO
*ABRE_LCR()
*CRIADBFTOSQL("ALCR00",.f.) //IMPORTADO
*ABRE_PED0()
*CRIADBFTOSQL("APED00",.f.) // IMPORTADO
*ABRE_PED1()
*CRIADBFTOSQL("APED01",.f.) // IMPORTADO

*ABRE_CLI()
*CRIADBFTOSQL("ACLI00",.f.) // IMPORTADO

*ABRE_CTA()
*CRIADBFTOSQL("ACTA00",.f.)

*ABRE_cpg()
*CRIADBFTOSQL("ACPG00",.f.)

*ABRE_SAT0()
*CRIADBFTOSQL("ASAT00",.f.)
*ABRE_SAT1()
*CRIADBFTOSQL("ASAT01",.T.)
*ABRE_CHEQ()
*CRIADBFTOSQL("ACHEQ0",.T.)
*ABRE_PRD()
*CRIADBFTOSQL("APRD00",.T.)
*ABRE_DCP()
*CRIADBFTOSQL("ADCP00",.T.)
*ABRE_LCP()
*CRIADBFTOSQL("ALCP00",.T.)
*ABRE_CVE()
*CRIADBFTOSQL("ACVE00",.T.)

*ABRE_FORMOR()
*CRIADBFTOSQL("AFOMOR",.T.)

*ABRE_FOR()
*CRIADBFTOSQL("AFOR00",.T.)

*ABRE_KAR()
*CRIADBFTOSQL("AKAR00",.T.)
*ABRE_NCM()
*CRIADBFTOSQL("ANCM00",.T.)
*ABRE_PCAFOR()
*CRIADBFTOSQL("APCFOR",.T.)
*ABRE_CUP0()
*CRIADBFTOSQL("ACUP00",.T.)
*ABRE_CUP1()
*CRIADBFTOSQL("ACUP01",.T.)
*ABRE_DEV()
*CRIADBFTOSQL("ADEV00",.T.)
*ABRE_TRA()
*CRIADBFTOSQL("ATRA00",.T.)
*ABRE_EMA()
*CRIADBFTOSQL("CLIEMA",.T.)
*ABRE_PAR()
*CRIADBFTOSQL("APAR00",.T.)
*ABRE_GRP()
*CRIADBFTOSQL("AGRP00",.T.)
*ABRE_MAR()
*CRIADBFTOSQL("AMAR00",.T.)
*ABRE_MAR1()
*CRIADBFTOSQL("AMAR01",.T.)
*ABRE_CHE()
*CRIADBFTOSQL("ACHE00",.T.)
*ABRE_LAB()
*CRIADBFTOSQL("ALAB00",.T.)
*ABRE_TAD()
*CRIADBFTOSQL("PORTADOR",.T.)
*ABRE_IND()
*CRIADBFTOSQL("AIND00",.T.)
*ABRE_PEN()
*CRIADBFTOSQL("APEN00",.T.)
*ABRE_VEN()
*CRIADBFTOSQL("AVEN00",.T.)
*ABRE_MSG2()
*CRIADBFTOSQL("MENSAGE2",.T.)
*ABRE_APX()
*CRIADBFTOSQL("AAPX00",.T.)
*ABRE_LAX()
*CRIADBFTOSQL("ALAX00",.T.)
*ABRE_PLX()
*CRIADBFTOSQL("APLX00",.T.)



QUIT

*******************
function VER_AFIS00(fFISNOV)         && ve natureza
*******************

    if lastkey() = 5
      return .t.
    endif

    if val(fFISNOV) = 0
      return .f.
    endif

    if !BUSCAREGISTRO("AFIS00",1,{str(ME_EMP,2,0),aspas(fFISNOV)},"SELECT")
      msg("* * * NATUREZA NAO CADASTRADA * * *")
      fFISNOV = space(5)
      return .f.
    endif

    msw("* * * " + alltrim(FISNOM) + " * * *")
    set cursor on

    if FISNOV = space(05)
      msg("* * * NOVO CODIGO NAO CADASTRADO. CADASTRE!!! * * *")
      return .f.
    endif

return .t.
