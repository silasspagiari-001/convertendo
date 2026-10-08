// Gerado por tools/gera_menu_minigui.py a partir de MENUAGRO.PRG (NOVOMENU).
// PROPOSTA - não compilada. Não está no atlas.xDev.
#include "minigui.ch"

FUNCTION MenuPrincipalMG()
   DEFINE WINDOW frmMenu AT 0,0 WIDTH 800 HEIGHT 600 TITLE 'Atlas' MAIN
      DEFINE FONT fMenu FONTNAME 'Segoe UI' SIZE 14
      DEFINE MAIN MENU
         POPUP '&Estoque' FONT fMenu
            POPUP '&Empresas' FONT fMenu
               MENUITEM '&Inclusão' ACTION manemp(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manemp(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manemp(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION manemp(4) FONT fMenu
               MENUITEM '&Listagem' ACTION manemp(5) FONT fMenu
               MENUITEM '&Parametro' ACTION manemp(6) FONT fMenu
            END POPUP
            POPUP '&Produtos' FONT fMenu
               MENUITEM '&Inclusão' ACTION manpro(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manpro(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manpro(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION manpro(4) FONT fMenu
               POPUP '&Listagem' FONT fMenu
                  MENUITEM '&Relaçäo de Compra' ACTION manpro(5,1) FONT fMenu
                  MENUITEM '&Relaçäo por Grupo' ACTION manpro(5,2) FONT fMenu
                  MENUITEM '&Lista Preços Venda' ACTION manpro(5,3) FONT fMenu
                  MENUITEM '&Planilha Balanco' ACTION manpro(5,4) FONT fMenu
                  MENUITEM '&Inventario Conferencia' ACTION manpro(5,5) FONT fMenu
                  POPUP '&Lista de Saldos' FONT fMenu
                     MENUITEM '&Saldos de todos os Produtos' ACTION manpro(5,6,1) FONT fMenu
                     MENUITEM '&Produtos Com Saldo Positivo' ACTION manpro(5,6,2) FONT fMenu
                     MENUITEM '&Produtos Com Saldo Negativo' ACTION manpro(5,6,3) FONT fMenu
                     MENUITEM '&Produtos Com Saldo Zerado' ACTION manpro(5,6,4) FONT fMenu
                     MENUITEM '&Näo Movimentados desde (MM/AA)' ACTION manpro(5,6,5) FONT fMenu
                     MENUITEM '&Produtos Acima Estoque MAXIMO' ACTION manpro(5,6,6) FONT fMenu
                     MENUITEM '&Produtos Abaixo Estoque MINIMO' ACTION manpro(5,6,7) FONT fMenu
                  END POPUP
                  MENUITEM '&Inventario Efetivo' ACTION manpro(5,7) FONT fMenu
                  POPUP '&Lista por Fabricante' FONT fMenu
                     MENUITEM '&Saldos de todos os Produtos' ACTION manpro(5,8,1) FONT fMenu
                     MENUITEM '&Produtos Com Saldo Positivo' ACTION manpro(5,8,2) FONT fMenu
                     MENUITEM '&Produtos Com Saldo Negativo' ACTION manpro(5,8,3) FONT fMenu
                     MENUITEM '&Produtos Com Saldo Zerado' ACTION manpro(5,8,4) FONT fMenu
                     MENUITEM '&Näo Movimentados desde (MM/AA)' ACTION manpro(5,8,5) FONT fMenu
                     MENUITEM '&Produtos Acima Estoque MAXIMO' ACTION manpro(5,8,6) FONT fMenu
                     MENUITEM '&Produtos Abaixo Estoque MINIMO' ACTION manpro(5,8,7) FONT fMenu
                  END POPUP
                  MENUITEM '&Classificacao Fiscal' ACTION manpro(5,9) FONT fMenu
               END POPUP
               POPUP '&Preços' FONT fMenu
                  MENUITEM '&Altera preço Custo' ACTION manpro(6,1) FONT fMenu
                  MENUITEM '&Altera preço Venda' ACTION manpro(6,2) FONT fMenu
                  MENUITEM '&Altera preço Geral' ACTION manpro(6,3) FONT fMenu
               END POPUP
               MENUITEM '&Arquivo Morto' ACTION manpro(7) FONT fMenu
               MENUITEM '&Codigos Fornecedores' ACTION manpro(8) FONT fMenu
            END POPUP
            POPUP '&Fornecedores' FONT fMenu
               MENUITEM '&Inclusão' ACTION manfor(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manfor(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manfor(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION manfor(4) FONT fMenu
               MENUITEM '&Listagem' ACTION manfor(5) FONT fMenu
               MENUITEM '&Etiquetas' ACTION manfor(6) FONT fMenu
               MENUITEM '&Arquivo Morto' ACTION manfor(7) FONT fMenu
            END POPUP
            POPUP '&Kardex' FONT fMenu
               MENUITEM '&Inclusão' ACTION mankar(1) FONT fMenu
               MENUITEM '&Alteração' ACTION mankar(2) FONT fMenu
               POPUP '&Consulta' FONT fMenu
                  MENUITEM '&Movimento' ACTION mankar(3,1) FONT fMenu
                  MENUITEM '&Compras' ACTION mankar(3,2) FONT fMenu
                  MENUITEM '&Vendas' ACTION mankar(3,3) FONT fMenu
                  MENUITEM '&Grafico V' ACTION mankar(3,4) FONT fMenu
                  MENUITEM '&Grafico C' ACTION mankar(3,5) FONT fMenu
               END POPUP
               MENUITEM '&Exclusão' ACTION mankar(4) FONT fMenu
               POPUP '&Listagem' FONT fMenu
                  MENUITEM '&Movimento' ACTION mankar(5,1) FONT fMenu
                  MENUITEM '&Entrada/Saida' ACTION mankar(5,2) FONT fMenu
               END POPUP
               POPUP '&Outros' FONT fMenu
                  MENUITEM '&Saldo Individual' ACTION mankar(6,1) FONT fMenu
                  MENUITEM '&Saldo Geral' ACTION mankar(6,2) FONT fMenu
                  MENUITEM '&Custo Medio' ACTION mankar(6,3) FONT fMenu
                  MENUITEM '&Grafico Anual' ACTION mankar(6,4) FONT fMenu
                  MENUITEM '&Finaliza Exercicio' ACTION mankar(6,5) FONT fMenu
               END POPUP
            END POPUP
            POPUP '&Grupos' FONT fMenu
               MENUITEM '&Inclusão' ACTION mangrp(1) FONT fMenu
               MENUITEM '&Alteração' ACTION mangrp(2) FONT fMenu
               MENUITEM '&Consulta' ACTION mangrp(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION mangrp(4) FONT fMenu
               MENUITEM '&Listagem' ACTION mangrp(5) FONT fMenu
            END POPUP
            POPUP '&Codigo NCM' FONT fMenu
               MENUITEM '&Inclusão' ACTION manncm(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manncm(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manncm(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION manncm(4) FONT fMenu
               MENUITEM '&Listagem' ACTION manncm(5) FONT fMenu
            END POPUP
            POPUP '&Nota Fiscal Entrada' FONT fMenu
               MENUITEM '&Inclusão' ACTION mannfe(1) FONT fMenu
               MENUITEM '&Alteração' ACTION mannfe(2) FONT fMenu
               MENUITEM '&Consulta' ACTION mannfe(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION mannfe(4) FONT fMenu
               POPUP '&Listagem' FONT fMenu
                  MENUITEM '&Analitico' ACTION mannfe(5,1) FONT fMenu
                  MENUITEM '&Sintético' ACTION mannfe(5,2) FONT fMenu
               END POPUP
               MENUITEM '&Implementacao' ACTION mannfe(6) FONT fMenu
               MENUITEM '&Ler XML' ACTION mannfe(7) FONT fMenu
            END POPUP
         END POPUP
         POPUP '&Faturar' FONT fMenu
            POPUP '&Nota Fiscal' FONT fMenu
               MENUITEM '&Emissão' ACTION mannfs(1) FONT fMenu
               POPUP '&Alteração' FONT fMenu
                  MENUITEM '&Nota Fiscal' ACTION mannfs(2,1) FONT fMenu
                  MENUITEM '&Escrituracao' ACTION mannfs(2,2) FONT fMenu
                  MENUITEM '&Natureza' ACTION mannfs(2,3) FONT fMenu
                  MENUITEM '&Relatorio' ACTION mannfs(2,4) FONT fMenu
               END POPUP
               MENUITEM '&Consulta' ACTION mannfs(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION mannfs(4) FONT fMenu
               POPUP '&Listagem' FONT fMenu
                  MENUITEM '&Sintetica Notas Fiscais' ACTION mannfs(5,1) FONT fMenu
                  MENUITEM '&Cliente Analitico' ACTION mannfs(5,2) FONT fMenu
                  MENUITEM '&Cliente Sintetico' ACTION mannfs(5,3) FONT fMenu
                  MENUITEM '&Nota de Servico' ACTION mannfs(5,4) FONT fMenu
                  MENUITEM '&Vendedor Notas' ACTION mannfs(5,5) FONT fMenu
                  MENUITEM '&Vendedor Sintetico' ACTION mannfs(5,6) FONT fMenu
                  MENUITEM '&Municipio Sintetico' ACTION mannfs(5,7) FONT fMenu
                  MENUITEM '&Produto Sintetico' ACTION mannfs(5,8) FONT fMenu
                  MENUITEM '&Notas Emitidas no Periodo' ACTION mannfs(5,9) FONT fMenu
                  MENUITEM '&Margem Bruta de Vendas' ACTION mannfs(5,11) FONT fMenu
                  MENUITEM '&Etiquetas de Caixa' ACTION mannfs(5,11) FONT fMenu
                  MENUITEM '&Faturamento' ACTION mannfs(5,12) FONT fMenu
                  MENUITEM '&Notas no Periodo (Antigo)' ACTION mannfs(5,14) FONT fMenu
                  MENUITEM '&Produtos Isentos' ACTION mannfs(5,15) FONT fMenu
                  MENUITEM '&IMS' ACTION mannfs(5,16) FONT fMenu
                  MENUITEM '&Prodiet' ACTION mannfs(5,17) FONT fMenu
               END POPUP
               POPUP '&Outros' FONT fMenu
                  MENUITEM '&Carta de Correcao' ACTION mannfs(6,1) FONT fMenu
                  MENUITEM '&Cancelamento' ACTION mannfs(6,2) FONT fMenu
                  MENUITEM '&Reemissao' ACTION mannfs(6,3) FONT fMenu
                  MENUITEM '&Enviar Email' ACTION mannfs(6,4) FONT fMenu
               END POPUP
               MENUITEM '&Transporte' ACTION mannfs(7) FONT fMenu
               MENUITEM '&Inclusao' ACTION mannfs(8) FONT fMenu
               MENUITEM '&Carta de Credito' ACTION emicre() FONT fMenu
               MENUITEM '&Etiqueta Argox' ACTION mangel1() FONT fMenu
            END POPUP
            POPUP '&Orcamento' FONT fMenu
               MENUITEM '&Emissão' ACTION manped(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manped(2) FONT fMenu
               POPUP '&Consulta' FONT fMenu
                  MENUITEM '&Pedido' ACTION manped(3,1) FONT fMenu
                  MENUITEM '&Cliente' ACTION manped(3,2) FONT fMenu
               END POPUP
               MENUITEM '&Exclusão' ACTION manped(4) FONT fMenu
               POPUP '&Listagem' FONT fMenu
                  MENUITEM '&Listagem de Pedidos' ACTION manped(5,1) FONT fMenu
                  MENUITEM '&Relacao por Produto' ACTION manped(5,2) FONT fMenu
                  MENUITEM '&Sintetica Pedidos' ACTION manped(5,3) FONT fMenu
                  MENUITEM '&Relacao por Grupo' ACTION manped(5,4) FONT fMenu
                  MENUITEM '&Relacao por Cliente' ACTION manped(5,5) FONT fMenu
                  MENUITEM '&Analitico Vendedor' ACTION manped(5,6) FONT fMenu
               END POPUP
               POPUP '&Agrupamento' FONT fMenu
                  MENUITEM '&Alteracao' ACTION manped(6,1) FONT fMenu
                  MENUITEM '&Emissao Nota' ACTION manped(6,2) FONT fMenu
               END POPUP
            END POPUP
            POPUP '&Requisição' FONT fMenu
               MENUITEM '&Emissão' ACTION manreq(1) FONT fMenu
               MENUITEM '&Reemissão' ACTION manreq(7) FONT fMenu
               MENUITEM '&Alteração' ACTION manreq(2) FONT fMenu
               POPUP '&Consulta' FONT fMenu
                  MENUITEM '&Aluguel' ACTION manreq(3,1) FONT fMenu
                  MENUITEM '&Cliente' ACTION manreq(3,2) FONT fMenu
               END POPUP
               MENUITEM '&Exclusão' ACTION manreq(4) FONT fMenu
               POPUP '&Listagem' FONT fMenu
                  MENUITEM '&Listagem de Requisicoes' ACTION manreq(5,1) FONT fMenu
                  MENUITEM '&Relacao por Produto' ACTION manreq(5,2) FONT fMenu
                  MENUITEM '&Analitica Requisicao' ACTION manreq(5,3) FONT fMenu
                  MENUITEM '&Sintetica Requisicao' ACTION manreq(5,4) FONT fMenu
                  MENUITEM '&Relacao por Cliente' ACTION manreq(5,5) FONT fMenu
                  MENUITEM '&Analitico Vendedor' ACTION manreq(5,6) FONT fMenu
                  MENUITEM '&Analitico Clilente' ACTION manreq(5,7) FONT fMenu
                  MENUITEM '&Resumo de Vendas' ACTION manreq(5,8) FONT fMenu
                  MENUITEM '&Mapa Resumido Indicado' ACTION manreq(5,9) FONT fMenu
               END POPUP
               POPUP '&Aluguel' FONT fMenu
                  MENUITEM '&Renovacao' ACTION manreq(6,1) FONT fMenu
                  MENUITEM '&Encerramento' ACTION manreq(6,2) FONT fMenu
                  MENUITEM '&Listagem' ACTION manreq(6,3) FONT fMenu
               END POPUP
            END POPUP
            POPUP '&Cupom Eletronico' FONT fMenu
               MENUITEM '&Emissão' ACTION mansat(1,1) FONT fMenu
               MENUITEM '&Inclusão' ACTION mansat(1,2) FONT fMenu
               MENUITEM '&Alteração' ACTION mansat(2) FONT fMenu
               POPUP '&Consulta' FONT fMenu
                  MENUITEM '&Cupom Fiscal' ACTION mansat(3,1) FONT fMenu
                  MENUITEM '&Cliente' ACTION mansat(3,2) FONT fMenu
               END POPUP
               MENUITEM '&Reemissão' ACTION mansat(4) FONT fMenu
               POPUP '&Listagem' FONT fMenu
                  MENUITEM '&Faturamento do Dia' ACTION mansat(5,1) FONT fMenu
                  MENUITEM '&Mapa Resumo Fiscal' ACTION mansat(5,2) FONT fMenu
                  MENUITEM '&Produto Sintetica' ACTION mansat(5,3) FONT fMenu
               END POPUP
               MENUITEM '&Cancelamento' ACTION mansat(6) FONT fMenu
            END POPUP
            POPUP '&Clientes' FONT fMenu
               MENUITEM '&Inclusão' ACTION mancli(1) FONT fMenu
               MENUITEM '&Alteração' ACTION mancli(2) FONT fMenu
               MENUITEM '&Consulta' ACTION mancli(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION mancli(4) FONT fMenu
               POPUP '&Listagem' FONT fMenu
                  MENUITEM '&Completa Codigo' ACTION mancli(5,1) FONT fMenu
                  MENUITEM '&Completa CPF/CNPJ' ACTION mancli(5,2) FONT fMenu
                  MENUITEM '&Completa Alfabetica' ACTION mancli(5,3) FONT fMenu
                  MENUITEM '&Catalogo Codigo' ACTION mancli(5,4) FONT fMenu
                  MENUITEM '&Catalogo CPF/CNPJ' ACTION mancli(5,5) FONT fMenu
                  MENUITEM '&Catalogo Alfabetica' ACTION mancli(5,6) FONT fMenu
                  MENUITEM '&Catalogo Municipio' ACTION mancli(5,7) FONT fMenu
               END POPUP
               POPUP '&Etiqueta' FONT fMenu
                  MENUITEM '&Codigo' ACTION mancli(6,1) FONT fMenu
                  MENUITEM '&Seleção' ACTION mancli(6,2) FONT fMenu
                  MENUITEM '&Nome' ACTION mancli(6,3) FONT fMenu
                  MENUITEM '&Parametro' ACTION mancli(6,4) FONT fMenu
               END POPUP
               MENUITEM '&Arquivo Morto' ACTION mancli(7) FONT fMenu
               POPUP '&Tipo Cliente' FONT fMenu
                  MENUITEM '&Inclusão' ACTION mancli(8,1) FONT fMenu
                  MENUITEM '&Alteração' ACTION mancli(8,2) FONT fMenu
                  MENUITEM '&Consulta' ACTION mancli(8,3) FONT fMenu
                  MENUITEM '&Exclusão' ACTION mancli(8,4) FONT fMenu
                  MENUITEM '&Listagem' ACTION mancli(8,5) FONT fMenu
               END POPUP
            END POPUP
            POPUP '&Vendedores' FONT fMenu
               MENUITEM '&Inclusão' ACTION manven(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manven(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manven(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION manven(4) FONT fMenu
               MENUITEM '&Listagem' ACTION manven(5) FONT fMenu
               POPUP '&Comissão' FONT fMenu
                  MENUITEM '&Pagameto' ACTION manven(6,1) FONT fMenu
                  MENUITEM '&Vencimento' ACTION manven(6,2) FONT fMenu
                  MENUITEM '&Emissao' ACTION manven(6,3) FONT fMenu
                  MENUITEM '&Aberto' ACTION manven(6,4) FONT fMenu
               END POPUP
            END POPUP
            POPUP '&Transportadora' FONT fMenu
               MENUITEM '&Inclusão' ACTION mantra(1) FONT fMenu
               MENUITEM '&Alteração' ACTION mantra(2) FONT fMenu
               MENUITEM '&Consulta' ACTION mantra(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION mantra(4) FONT fMenu
               MENUITEM '&Listagem' ACTION mantra(5) FONT fMenu
            END POPUP
            POPUP '&Pagamentos' FONT fMenu
               MENUITEM '&Inclusão' ACTION mancpg(1) FONT fMenu
               MENUITEM '&Alteração' ACTION mancpg(2) FONT fMenu
               MENUITEM '&Consulta' ACTION mancpg(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION mancpg(4) FONT fMenu
               MENUITEM '&Listagem' ACTION mancpg(5) FONT fMenu
            END POPUP
            POPUP '&Indicado' FONT fMenu
               MENUITEM '&Inclusão' ACTION manind(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manind(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manind(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION manind(4) FONT fMenu
               MENUITEM '&Listagem' ACTION manind(5) FONT fMenu
            END POPUP
            MENUITEM '&Mensagem NF' ACTION manmsg() FONT fMenu
         END POPUP
         POPUP '&Receber' FONT fMenu
            POPUP '&Duplicata' FONT fMenu
               MENUITEM '&Inclusão' ACTION mandcr(1) FONT fMenu
               POPUP '&Alteracao' FONT fMenu
                  MENUITEM '&Titulo' ACTION mandcr(2,1) FONT fMenu
                  MENUITEM '&Pagamento' ACTION mandcr(2,3) FONT fMenu
                  MENUITEM '&Exportar' ACTION mandcr(2,4) FONT fMenu
               END POPUP
               POPUP '&Consulta' FONT fMenu
                  MENUITEM '&Sequencia' ACTION mandcr(3,1) FONT fMenu
                  MENUITEM '&Vencidas' ACTION mandcr(3,2) FONT fMenu
                  MENUITEM '&Emissao' ACTION mandcr(3,3) FONT fMenu
                  MENUITEM '&Codigos' ACTION mandcr(3,4) FONT fMenu
                  MENUITEM '&Portador' ACTION mandcr(3,5) FONT fMenu
                  MENUITEM '&Pagamento' ACTION mandcr(3,6) FONT fMenu
               END POPUP
               MENUITEM '&Exclusão' ACTION mandcr(4) FONT fMenu
               POPUP '&Listagem' FONT fMenu
                  MENUITEM '&Perda' ACTION mandcr(5,1) FONT fMenu
                  MENUITEM '&Vencidas' ACTION mandcr(5,2) FONT fMenu
                  MENUITEM '&Nome' ACTION mandcr(5,3) FONT fMenu
                  MENUITEM '&Codigo' ACTION mandcr(5,4) FONT fMenu
                  MENUITEM '&Portador' ACTION mandcr(5,5) FONT fMenu
                  MENUITEM '&Pagamento' ACTION mandcr(5,6) FONT fMenu
                  MENUITEM '&Sequencia' ACTION mandcr(5,7) FONT fMenu
                  MENUITEM '&Emissão' ACTION mandcr(5,8) FONT fMenu
                  MENUITEM '&Cidade' ACTION mandcr(5,9) FONT fMenu
               END POPUP
               POPUP '&Titulos' FONT fMenu
                  MENUITEM '&Brasil' ACTION mandcr(6,1) FONT fMenu
                  MENUITEM '&Sicred    ' ACTION mandcr(6,2) FONT fMenu
               END POPUP
            END POPUP
            POPUP '&Instrução' FONT fMenu
               MENUITEM '&Inclusão' ACTION manlcr(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manlcr(2) FONT fMenu
               POPUP '&Consulta' FONT fMenu
                  MENUITEM '&Instrução' ACTION manlcr(3,1) FONT fMenu
                  MENUITEM '&Duplicata' ACTION manlcr(3,2) FONT fMenu
                  MENUITEM '&Cliente' ACTION manlcr(3,3) FONT fMenu
               END POPUP
               MENUITEM '&Exclusão' ACTION manlcr(4) FONT fMenu
               POPUP '&Listagem' FONT fMenu
                  MENUITEM '&Instrução' ACTION manlcr(5,1) FONT fMenu
                  MENUITEM '&Diario' ACTION manlcr(5,2) FONT fMenu
                  MENUITEM '&Razão' ACTION manlcr(5,3) FONT fMenu
               END POPUP
               MENUITEM '&Fechamento' ACTION manlcr(6) FONT fMenu
            END POPUP
            POPUP '&Baixas' FONT fMenu
               MENUITEM '&Documento' ACTION manbcr(1) FONT fMenu
               MENUITEM '&Clientes' ACTION manbcr(2) FONT fMenu
               MENUITEM '&Recepcão' ACTION manbcr(3) FONT fMenu
               MENUITEM '&Consiste' ACTION manbcr(4) FONT fMenu
               MENUITEM '&Listagem' ACTION manbcr(5) FONT fMenu
            END POPUP
            POPUP '&Operacoes' FONT fMenu
               MENUITEM '&Inclusao' ACTION manmcr(1) FONT fMenu
               MENUITEM '&Alteracao' ACTION manmcr(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manmcr(3) FONT fMenu
               MENUITEM '&Exclusao' ACTION manmcr(4) FONT fMenu
               MENUITEM '&Listagem' ACTION manmcr(5) FONT fMenu
            END POPUP
            POPUP '&Portadores' FONT fMenu
               MENUITEM '&Inclusão' ACTION manpor(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manpor(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manpor(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION manpor(4) FONT fMenu
               MENUITEM '&Listagem' ACTION manpor(5) FONT fMenu
            END POPUP
            POPUP '&Exportar' FONT fMenu
               MENUITEM '&Remessa' ACTION manexp(1) FONT fMenu
               MENUITEM '&Lista Retorno' ACTION manexp(2) FONT fMenu
               MENUITEM '&Baixa Retorno' ACTION manexp(3) FONT fMenu
            END POPUP
            POPUP '&Etiquetas' FONT fMenu
               MENUITEM '&Inclusão' ACTION manetq(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manetq(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manetq(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION manetq(4) FONT fMenu
               MENUITEM '&Listagem' ACTION manetq(5) FONT fMenu
               MENUITEM '&Parametro' ACTION manetq(6) FONT fMenu
            END POPUP
         END POPUP
         POPUP '&Pagar' FONT fMenu
            POPUP '&Duplicata' FONT fMenu
               MENUITEM '&Inclusão' ACTION mandcp(1) FONT fMenu
               POPUP '&Alteracao' FONT fMenu
                  MENUITEM '&Titulo' ACTION mandcp(2,1) FONT fMenu
                  MENUITEM '&Portador' ACTION mandcp(2,3) FONT fMenu
               END POPUP
               POPUP '&Consulta' FONT fMenu
                  MENUITEM '&Sequencia' ACTION mandcp(3,1) FONT fMenu
                  MENUITEM '&Vencidas' ACTION mandcp(3,2) FONT fMenu
                  MENUITEM '&Emissao' ACTION mandcp(3,3) FONT fMenu
                  MENUITEM '&Codigos' ACTION mandcp(3,4) FONT fMenu
                  MENUITEM '&Portador' ACTION mandcp(3,5) FONT fMenu
                  MENUITEM '&Pagamento' ACTION mandcp(3,6) FONT fMenu
               END POPUP
               MENUITEM '&Exclusão' ACTION mandcp(4) FONT fMenu
               POPUP '&Listagem' FONT fMenu
                  MENUITEM '&Sequencia' ACTION mandcp(5,1) FONT fMenu
                  MENUITEM '&Vencidas' ACTION mandcp(5,2) FONT fMenu
                  MENUITEM '&Nome' ACTION mandcp(5,3) FONT fMenu
                  MENUITEM '&Codigo' ACTION mandcp(5,4) FONT fMenu
                  MENUITEM '&Portador' ACTION mandcp(5,5) FONT fMenu
                  MENUITEM '&Pagamento' ACTION mandcp(5,6) FONT fMenu
               END POPUP
            END POPUP
            POPUP '&Instrução' FONT fMenu
               MENUITEM '&Inclusão' ACTION manlcp(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manlcp(2) FONT fMenu
               POPUP '&Consulta' FONT fMenu
                  MENUITEM '&Instrução' ACTION manlcp(3,1) FONT fMenu
                  MENUITEM '&Duplicata' ACTION manlcp(3,2) FONT fMenu
                  MENUITEM '&Fornecedor' ACTION manlcp(3,3) FONT fMenu
               END POPUP
               MENUITEM '&Exclusão' ACTION manlcp(4) FONT fMenu
               POPUP '&Listagem' FONT fMenu
                  MENUITEM '&Instrução' ACTION manlcp(5,1) FONT fMenu
                  MENUITEM '&Diario' ACTION manlcp(5,2) FONT fMenu
                  MENUITEM '&Razão' ACTION manlcp(5,3) FONT fMenu
               END POPUP
               MENUITEM '&Fechamento' ACTION manlcp(6) FONT fMenu
            END POPUP
            POPUP '&Baixas' FONT fMenu
               MENUITEM '&Documento' ACTION manbcp(1) FONT fMenu
               MENUITEM '&Fornecedor' ACTION manbcp(2) FONT fMenu
               MENUITEM '&Listagem' ACTION manbcp(3) FONT fMenu
            END POPUP
            POPUP '&Operacoes' FONT fMenu
               MENUITEM '&Inclusao' ACTION manmcp(1) FONT fMenu
               MENUITEM '&Alteracao' ACTION manmcp(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manmcp(3) FONT fMenu
               MENUITEM '&Exclusao' ACTION manmcp(4) FONT fMenu
               MENUITEM '&Listagem' ACTION manmcp(5) FONT fMenu
            END POPUP
         END POPUP
         POPUP '&Bancos' FONT fMenu
            POPUP '&Conta' FONT fMenu
               MENUITEM '&Inclusão' ACTION manban(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manban(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manban(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION manban(4) FONT fMenu
               MENUITEM '&Listagem' ACTION manban(5) FONT fMenu
               MENUITEM '&Exercicio' ACTION manban(6) FONT fMenu
            END POPUP
            POPUP '&Historico' FONT fMenu
               MENUITEM '&Inclusão' ACTION manhib(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manhib(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manhib(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION manhib(4) FONT fMenu
               MENUITEM '&Listagem' ACTION manhib(5) FONT fMenu
            END POPUP
            POPUP '&Movimento' FONT fMenu
               MENUITEM '&Inclusão' ACTION manlab(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manlab(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manlab(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION manlab(4) FONT fMenu
               POPUP '&Listagem' FONT fMenu
                  MENUITEM '&Instrução' ACTION manlcp(5,1) FONT fMenu
                  MENUITEM '&Diario' ACTION manlcp(5,2) FONT fMenu
                  MENUITEM '&Razão' ACTION manlcp(5,3) FONT fMenu
               END POPUP
               MENUITEM '&Conciliar' ACTION manlab(6) FONT fMenu
            END POPUP
            POPUP '&Cheque' FONT fMenu
               MENUITEM '&Inclusão' ACTION manche(1) FONT fMenu
               MENUITEM '&Alteracao' ACTION manche(2) FONT fMenu
               POPUP '&Consulta' FONT fMenu
                  MENUITEM '&Cheque' ACTION manche(3,1) FONT fMenu
                  MENUITEM '&Fornecedor' ACTION manche(3,2) FONT fMenu
               END POPUP
               MENUITEM '&Exclusao' ACTION manche(4) FONT fMenu
               MENUITEM '&Listagem' ACTION manche(5) FONT fMenu
               POPUP '&Outros' FONT fMenu
                  MENUITEM '&Emissao' ACTION manche(6,1) FONT fMenu
                  MENUITEM '&Copia' ACTION manche(6,2) FONT fMenu
                  MENUITEM '&Elimina' ACTION manche(6,3) FONT fMenu
               END POPUP
               MENUITEM '&Liberacao' ACTION manche(7) FONT fMenu
            END POPUP
            POPUP '&Cheque Pre' FONT fMenu
               MENUITEM '&Inclusão' ACTION manprd(1) FONT fMenu
               MENUITEM '&Alteracao' ACTION manprd(2) FONT fMenu
               POPUP '&Consulta' FONT fMenu
                  MENUITEM '&Cheque' ACTION manprd(3,1) FONT fMenu
                  MENUITEM '&Banco' ACTION manprd(3,2) FONT fMenu
                  MENUITEM '&Emissao' ACTION manprd(3,3) FONT fMenu
                  MENUITEM '&Vencimento' ACTION manprd(3,4) FONT fMenu
                  MENUITEM '&Cliente' ACTION manprd(3,5) FONT fMenu
                  MENUITEM '&Valor' ACTION manprd(3,6) FONT fMenu
                  MENUITEM '&Entrada' ACTION manprd(3,7) FONT fMenu
               END POPUP
               MENUITEM '&Exclusao' ACTION manprd(4) FONT fMenu
               POPUP '&Listagem' FONT fMenu
                  MENUITEM '&Cheque' ACTION manprd(5,1) FONT fMenu
                  MENUITEM '&Banco' ACTION manprd(5,2) FONT fMenu
                  MENUITEM '&Emissao' ACTION manprd(5,3) FONT fMenu
                  MENUITEM '&Vencimento' ACTION manprd(5,4) FONT fMenu
                  MENUITEM '&Cliente' ACTION manprd(5,5) FONT fMenu
                  MENUITEM '&Entrada' ACTION manprd(5,6) FONT fMenu
               END POPUP
               MENUITEM '&Baixa' ACTION manprd(6) FONT fMenu
            END POPUP
         END POPUP
         POPUP '&Caixa' FONT fMenu
            POPUP '&Aplicação' FONT fMenu
               MENUITEM '&Inclusão' ACTION manplx(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manplx(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manplx(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION manplx(4) FONT fMenu
               MENUITEM '&Listagem' ACTION manplx(5) FONT fMenu
            END POPUP
            POPUP '&Historico' FONT fMenu
               MENUITEM '&Inclusão' ACTION manhix(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manhix(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manhix(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION manhix(4) FONT fMenu
               MENUITEM '&Listagem' ACTION manhix(5) FONT fMenu
            END POPUP
            POPUP '&Fluxo de Caixa' FONT fMenu
               MENUITEM '&Inclusão' ACTION manlax(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manlax(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manlax(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION manlax(4) FONT fMenu
               POPUP '&Listagem' FONT fMenu
                  MENUITEM '&Periodo' ACTION manlax(5,1) FONT fMenu
                  MENUITEM '&Contas' ACTION manlax(5,2) FONT fMenu
               END POPUP
            END POPUP
            POPUP '&Analitico' FONT fMenu
               MENUITEM '&Titulos' ACTION mananx(1) FONT fMenu
               MENUITEM '&Aplicacao' ACTION mananx(2) FONT fMenu
               MENUITEM '&Caixa' ACTION mananx(3) FONT fMenu
            END POPUP
            POPUP '&Sintetico' FONT fMenu
               MENUITEM '&Titulos' ACTION mansix(1) FONT fMenu
               MENUITEM '&Aplicacao' ACTION mansix(2) FONT fMenu
            END POPUP
            MENUITEM '&Resultado' ACTION demonx() FONT fMenu
         END POPUP
         POPUP '&Outros' FONT fMenu
            POPUP '&Convenios' FONT fMenu
               MENUITEM '&Inclusão' ACTION mancve(1) FONT fMenu
               MENUITEM '&Alteração' ACTION mancve(2) FONT fMenu
               MENUITEM '&Consulta' ACTION mancve(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION mancve(4) FONT fMenu
               MENUITEM '&Listagem' ACTION mancve(5) FONT fMenu
            END POPUP
            POPUP '&CFOP Fiscal' FONT fMenu
               MENUITEM '&Inclusão' ACTION manfis(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manfis(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manfis(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION manfis(4) FONT fMenu
               MENUITEM '&Listagem' ACTION manfis(5) FONT fMenu
            END POPUP
            POPUP '&Fiscal' FONT fMenu
               MENUITEM '&Resumo ICMS' ACTION manapu(1) FONT fMenu
               MENUITEM '&Livro ICMS' ACTION manapu(2) FONT fMenu
               MENUITEM '&Apuracao ICMS' ACTION manapu(3) FONT fMenu
               MENUITEM '&Pis/Cofins' ACTION manapu(4) FONT fMenu
               MENUITEM '&Sped ICMS' ACTION manapu(5) FONT fMenu
            END POPUP
            POPUP '&Usuarios' FONT fMenu
               MENUITEM '&Inclusão' ACTION manlog(1) FONT fMenu
               MENUITEM '&Alteração' ACTION manlog(2) FONT fMenu
               MENUITEM '&Consulta' ACTION manlog(3) FONT fMenu
               MENUITEM '&Exclusão' ACTION manlog(4) FONT fMenu
               MENUITEM '&Restricoes' ACTION manlog(5) FONT fMenu
            END POPUP
            MENUITEM '&Salva Configuração' ACTION salvaconf() FONT fMenu
         END POPUP
      END MENU
   END WINDOW
   CENTER WINDOW frmMenu
   ACTIVATE WINDOW frmMenu
RETURN NIL

