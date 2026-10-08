// Gerado por tools/gera_menu_minigui.py a partir de MENUAGRO.PRG (NOVOMENU).
// PROPOSTA - não compilada. Não está no atlas.xDev.
#include "minigui.ch"

FUNCTION MenuPrincipalMG()
   DEFINE WINDOW frmMenu AT 0,0 WIDTH 800 HEIGHT 600 TITLE 'Atlas' MAIN
      DEFINE MAIN MENU
         POPUP '&Estoque'
            POPUP '&Empresas'
               MENUITEM '&Inclusão' ACTION manemp(1)
               MENUITEM '&Alteração' ACTION manemp(2)
               MENUITEM '&Consulta' ACTION manemp(3)
               MENUITEM '&Exclusão' ACTION manemp(4)
               MENUITEM '&Listagem' ACTION manemp(5)
               MENUITEM '&Parametro' ACTION manemp(6)
            END POPUP
            POPUP '&Produtos'
               MENUITEM '&Inclusão' ACTION manpro(1)
               MENUITEM '&Alteração' ACTION manpro(2)
               MENUITEM '&Consulta' ACTION manpro(3)
               MENUITEM '&Exclusão' ACTION manpro(4)
               POPUP '&Listagem'
                  MENUITEM '&Relaçäo de Compra' ACTION manpro(5,1)
                  MENUITEM '&Relaçäo por Grupo' ACTION manpro(5,2)
                  MENUITEM '&Lista Preços Venda' ACTION manpro(5,3)
                  MENUITEM '&Planilha Balanco' ACTION manpro(5,4)
                  MENUITEM '&Inventario Conferencia' ACTION manpro(5,5)
                  POPUP '&Lista de Saldos'
                     MENUITEM '&Saldos de todos os Produtos' ACTION manpro(5,6,1)
                     MENUITEM '&Produtos Com Saldo Positivo' ACTION manpro(5,6,2)
                     MENUITEM '&Produtos Com Saldo Negativo' ACTION manpro(5,6,3)
                     MENUITEM '&Produtos Com Saldo Zerado' ACTION manpro(5,6,4)
                     MENUITEM '&Näo Movimentados desde (MM/AA)' ACTION manpro(5,6,5)
                     MENUITEM '&Produtos Acima Estoque MAXIMO' ACTION manpro(5,6,6)
                     MENUITEM '&Produtos Abaixo Estoque MINIMO' ACTION manpro(5,6,7)
                  END POPUP
                  MENUITEM '&Inventario Efetivo' ACTION manpro(5,7)
                  POPUP '&Lista por Fabricante'
                     MENUITEM '&Saldos de todos os Produtos' ACTION manpro(5,8,1)
                     MENUITEM '&Produtos Com Saldo Positivo' ACTION manpro(5,8,2)
                     MENUITEM '&Produtos Com Saldo Negativo' ACTION manpro(5,8,3)
                     MENUITEM '&Produtos Com Saldo Zerado' ACTION manpro(5,8,4)
                     MENUITEM '&Näo Movimentados desde (MM/AA)' ACTION manpro(5,8,5)
                     MENUITEM '&Produtos Acima Estoque MAXIMO' ACTION manpro(5,8,6)
                     MENUITEM '&Produtos Abaixo Estoque MINIMO' ACTION manpro(5,8,7)
                  END POPUP
                  MENUITEM '&Classificacao Fiscal' ACTION manpro(5,9)
               END POPUP
               POPUP '&Preços'
                  MENUITEM '&Altera preço Custo' ACTION manpro(6,1)
                  MENUITEM '&Altera preço Venda' ACTION manpro(6,2)
                  MENUITEM '&Altera preço Geral' ACTION manpro(6,3)
               END POPUP
               MENUITEM '&Arquivo Morto' ACTION manpro(7)
               MENUITEM '&Codigos Fornecedores' ACTION manpro(8)
            END POPUP
            POPUP '&Fornecedores'
               MENUITEM '&Inclusão' ACTION manfor(1)
               MENUITEM '&Alteração' ACTION manfor(2)
               MENUITEM '&Consulta' ACTION manfor(3)
               MENUITEM '&Exclusão' ACTION manfor(4)
               MENUITEM '&Listagem' ACTION manfor(5)
               MENUITEM '&Etiquetas' ACTION manfor(6)
               MENUITEM '&Arquivo Morto' ACTION manfor(7)
            END POPUP
            POPUP '&Kardex'
               MENUITEM '&Inclusão' ACTION mankar(1)
               MENUITEM '&Alteração' ACTION mankar(2)
               POPUP '&Consulta'
                  MENUITEM '&Movimento' ACTION mankar(3,1)
                  MENUITEM '&Compras' ACTION mankar(3,2)
                  MENUITEM '&Vendas' ACTION mankar(3,3)
                  MENUITEM '&Grafico V' ACTION mankar(3,4)
                  MENUITEM '&Grafico C' ACTION mankar(3,5)
               END POPUP
               MENUITEM '&Exclusão' ACTION mankar(4)
               POPUP '&Listagem'
                  MENUITEM '&Movimento' ACTION mankar(5,1)
                  MENUITEM '&Entrada/Saida' ACTION mankar(5,2)
               END POPUP
               POPUP '&Outros'
                  MENUITEM '&Saldo Individual' ACTION mankar(6,1)
                  MENUITEM '&Saldo Geral' ACTION mankar(6,2)
                  MENUITEM '&Custo Medio' ACTION mankar(6,3)
                  MENUITEM '&Grafico Anual' ACTION mankar(6,4)
                  MENUITEM '&Finaliza Exercicio' ACTION mankar(6,5)
               END POPUP
            END POPUP
            POPUP '&Grupos'
               MENUITEM '&Inclusão' ACTION mangrp(1)
               MENUITEM '&Alteração' ACTION mangrp(2)
               MENUITEM '&Consulta' ACTION mangrp(3)
               MENUITEM '&Exclusão' ACTION mangrp(4)
               MENUITEM '&Listagem' ACTION mangrp(5)
            END POPUP
            POPUP '&Codigo NCM'
               MENUITEM '&Inclusão' ACTION manncm(1)
               MENUITEM '&Alteração' ACTION manncm(2)
               MENUITEM '&Consulta' ACTION manncm(3)
               MENUITEM '&Exclusão' ACTION manncm(4)
               MENUITEM '&Listagem' ACTION manncm(5)
            END POPUP
            POPUP '&Nota Fiscal Entrada'
               MENUITEM '&Inclusão' ACTION mannfe(1)
               MENUITEM '&Alteração' ACTION mannfe(2)
               MENUITEM '&Consulta' ACTION mannfe(3)
               MENUITEM '&Exclusão' ACTION mannfe(4)
               POPUP '&Listagem'
                  MENUITEM '&Analitico' ACTION mannfe(5,1)
                  MENUITEM '&Sintético' ACTION mannfe(5,2)
               END POPUP
               MENUITEM '&Implementacao' ACTION mannfe(6)
               MENUITEM '&Ler XML' ACTION mannfe(7)
            END POPUP
         END POPUP
         POPUP '&Faturar'
            POPUP '&Nota Fiscal'
               MENUITEM '&Emissão' ACTION mannfs(1)
               POPUP '&Alteração'
                  MENUITEM '&Nota Fiscal' ACTION mannfs(2,1)
                  MENUITEM '&Escrituracao' ACTION mannfs(2,2)
                  MENUITEM '&Natureza' ACTION mannfs(2,3)
                  MENUITEM '&Relatorio' ACTION mannfs(2,4)
               END POPUP
               MENUITEM '&Consulta' ACTION mannfs(3)
               MENUITEM '&Exclusão' ACTION mannfs(4)
               POPUP '&Listagem'
                  MENUITEM '&Sintetica Notas Fiscais' ACTION mannfs(5,1)
                  MENUITEM '&Cliente Analitico' ACTION mannfs(5,2)
                  MENUITEM '&Cliente Sintetico' ACTION mannfs(5,3)
                  MENUITEM '&Nota de Servico' ACTION mannfs(5,4)
                  MENUITEM '&Vendedor Notas' ACTION mannfs(5,5)
                  MENUITEM '&Vendedor Sintetico' ACTION mannfs(5,6)
                  MENUITEM '&Municipio Sintetico' ACTION mannfs(5,7)
                  MENUITEM '&Produto Sintetico' ACTION mannfs(5,8)
                  MENUITEM '&Notas Emitidas no Periodo' ACTION mannfs(5,9)
                  MENUITEM '&Margem Bruta de Vendas' ACTION mannfs(5,11)
                  MENUITEM '&Etiquetas de Caixa' ACTION mannfs(5,11)
                  MENUITEM '&Faturamento' ACTION mannfs(5,12)
                  MENUITEM '&Notas no Periodo (Antigo)' ACTION mannfs(5,14)
                  MENUITEM '&Produtos Isentos' ACTION mannfs(5,15)
                  MENUITEM '&IMS' ACTION mannfs(5,16)
                  MENUITEM '&Prodiet' ACTION mannfs(5,17)
               END POPUP
               POPUP '&Outros'
                  MENUITEM '&Carta de Correcao' ACTION mannfs(6,1)
                  MENUITEM '&Cancelamento' ACTION mannfs(6,2)
                  MENUITEM '&Reemissao' ACTION mannfs(6,3)
                  MENUITEM '&Enviar Email' ACTION mannfs(6,4)
               END POPUP
               MENUITEM '&Transporte' ACTION mannfs(7)
               MENUITEM '&Inclusao' ACTION mannfs(8)
               MENUITEM '&Carta de Credito' ACTION emicre()
               MENUITEM '&Etiqueta Argox' ACTION mangel1()
            END POPUP
            POPUP '&Orcamento'
               MENUITEM '&Emissão' ACTION manped(1)
               MENUITEM '&Alteração' ACTION manped(2)
               POPUP '&Consulta'
                  MENUITEM '&Pedido' ACTION manped(3,1)
                  MENUITEM '&Cliente' ACTION manped(3,2)
               END POPUP
               MENUITEM '&Exclusão' ACTION manped(4)
               POPUP '&Listagem'
                  MENUITEM '&Listagem de Pedidos' ACTION manped(5,1)
                  MENUITEM '&Relacao por Produto' ACTION manped(5,2)
                  MENUITEM '&Sintetica Pedidos' ACTION manped(5,3)
                  MENUITEM '&Relacao por Grupo' ACTION manped(5,4)
                  MENUITEM '&Relacao por Cliente' ACTION manped(5,5)
                  MENUITEM '&Analitico Vendedor' ACTION manped(5,6)
               END POPUP
               POPUP '&Agrupamento'
                  MENUITEM '&Alteracao' ACTION manped(6,1)
                  MENUITEM '&Emissao Nota' ACTION manped(6,2)
               END POPUP
            END POPUP
            POPUP '&Requisição'
               MENUITEM '&Emissão' ACTION manreq(1)
               MENUITEM '&Reemissão' ACTION manreq(7)
               MENUITEM '&Alteração' ACTION manreq(2)
               POPUP '&Consulta'
                  MENUITEM '&Aluguel' ACTION manreq(3,1)
                  MENUITEM '&Cliente' ACTION manreq(3,2)
               END POPUP
               MENUITEM '&Exclusão' ACTION manreq(4)
               POPUP '&Listagem'
                  MENUITEM '&Listagem de Requisicoes' ACTION manreq(5,1)
                  MENUITEM '&Relacao por Produto' ACTION manreq(5,2)
                  MENUITEM '&Analitica Requisicao' ACTION manreq(5,3)
                  MENUITEM '&Sintetica Requisicao' ACTION manreq(5,4)
                  MENUITEM '&Relacao por Cliente' ACTION manreq(5,5)
                  MENUITEM '&Analitico Vendedor' ACTION manreq(5,6)
                  MENUITEM '&Analitico Clilente' ACTION manreq(5,7)
                  MENUITEM '&Resumo de Vendas' ACTION manreq(5,8)
                  MENUITEM '&Mapa Resumido Indicado' ACTION manreq(5,9)
               END POPUP
               POPUP '&Aluguel'
                  MENUITEM '&Renovacao' ACTION manreq(6,1)
                  MENUITEM '&Encerramento' ACTION manreq(6,2)
                  MENUITEM '&Listagem' ACTION manreq(6,3)
               END POPUP
            END POPUP
            POPUP '&Cupom Eletronico'
               MENUITEM '&Emissão' ACTION mansat(1,1)
               MENUITEM '&Inclusão' ACTION mansat(1,2)
               MENUITEM '&Alteração' ACTION mansat(2)
               POPUP '&Consulta'
                  MENUITEM '&Cupom Fiscal' ACTION mansat(3,1)
                  MENUITEM '&Cliente' ACTION mansat(3,2)
               END POPUP
               MENUITEM '&Reemissão' ACTION mansat(4)
               POPUP '&Listagem'
                  MENUITEM '&Faturamento do Dia' ACTION mansat(5,1)
                  MENUITEM '&Mapa Resumo Fiscal' ACTION mansat(5,2)
                  MENUITEM '&Produto Sintetica' ACTION mansat(5,3)
               END POPUP
               MENUITEM '&Cancelamento' ACTION mansat(6)
            END POPUP
            POPUP '&Clientes'
               MENUITEM '&Inclusão' ACTION mancli(1)
               MENUITEM '&Alteração' ACTION mancli(2)
               MENUITEM '&Consulta' ACTION mancli(3)
               MENUITEM '&Exclusão' ACTION mancli(4)
               POPUP '&Listagem'
                  MENUITEM '&Completa Codigo' ACTION mancli(5,1)
                  MENUITEM '&Completa CPF/CNPJ' ACTION mancli(5,2)
                  MENUITEM '&Completa Alfabetica' ACTION mancli(5,3)
                  MENUITEM '&Catalogo Codigo' ACTION mancli(5,4)
                  MENUITEM '&Catalogo CPF/CNPJ' ACTION mancli(5,5)
                  MENUITEM '&Catalogo Alfabetica' ACTION mancli(5,6)
                  MENUITEM '&Catalogo Municipio' ACTION mancli(5,7)
               END POPUP
               POPUP '&Etiqueta'
                  MENUITEM '&Codigo' ACTION mancli(6,1)
                  MENUITEM '&Seleção' ACTION mancli(6,2)
                  MENUITEM '&Nome' ACTION mancli(6,3)
                  MENUITEM '&Parametro' ACTION mancli(6,4)
               END POPUP
               MENUITEM '&Arquivo Morto' ACTION mancli(7)
               POPUP '&Tipo Cliente'
                  MENUITEM '&Inclusão' ACTION mancli(8,1)
                  MENUITEM '&Alteração' ACTION mancli(8,2)
                  MENUITEM '&Consulta' ACTION mancli(8,3)
                  MENUITEM '&Exclusão' ACTION mancli(8,4)
                  MENUITEM '&Listagem' ACTION mancli(8,5)
               END POPUP
            END POPUP
            POPUP '&Vendedores'
               MENUITEM '&Inclusão' ACTION manven(1)
               MENUITEM '&Alteração' ACTION manven(2)
               MENUITEM '&Consulta' ACTION manven(3)
               MENUITEM '&Exclusão' ACTION manven(4)
               MENUITEM '&Listagem' ACTION manven(5)
               POPUP '&Comissão'
                  MENUITEM '&Pagameto' ACTION manven(6,1)
                  MENUITEM '&Vencimento' ACTION manven(6,2)
                  MENUITEM '&Emissao' ACTION manven(6,3)
                  MENUITEM '&Aberto' ACTION manven(6,4)
               END POPUP
            END POPUP
            POPUP '&Transportadora'
               MENUITEM '&Inclusão' ACTION mantra(1)
               MENUITEM '&Alteração' ACTION mantra(2)
               MENUITEM '&Consulta' ACTION mantra(3)
               MENUITEM '&Exclusão' ACTION mantra(4)
               MENUITEM '&Listagem' ACTION mantra(5)
            END POPUP
            POPUP '&Pagamentos'
               MENUITEM '&Inclusão' ACTION mancpg(1)
               MENUITEM '&Alteração' ACTION mancpg(2)
               MENUITEM '&Consulta' ACTION mancpg(3)
               MENUITEM '&Exclusão' ACTION mancpg(4)
               MENUITEM '&Listagem' ACTION mancpg(5)
            END POPUP
            POPUP '&Indicado'
               MENUITEM '&Inclusão' ACTION manind(1)
               MENUITEM '&Alteração' ACTION manind(2)
               MENUITEM '&Consulta' ACTION manind(3)
               MENUITEM '&Exclusão' ACTION manind(4)
               MENUITEM '&Listagem' ACTION manind(5)
            END POPUP
            MENUITEM '&Mensagem NF' ACTION manmsg()
         END POPUP
         POPUP '&Receber'
            POPUP '&Duplicata'
               MENUITEM '&Inclusão' ACTION mandcr(1)
               POPUP '&Alteracao'
                  MENUITEM '&Titulo' ACTION mandcr(2,1)
                  MENUITEM '&Pagamento' ACTION mandcr(2,3)
                  MENUITEM '&Exportar' ACTION mandcr(2,4)
               END POPUP
               POPUP '&Consulta'
                  MENUITEM '&Sequencia' ACTION mandcr(3,1)
                  MENUITEM '&Vencidas' ACTION mandcr(3,2)
                  MENUITEM '&Emissao' ACTION mandcr(3,3)
                  MENUITEM '&Codigos' ACTION mandcr(3,4)
                  MENUITEM '&Portador' ACTION mandcr(3,5)
                  MENUITEM '&Pagamento' ACTION mandcr(3,6)
               END POPUP
               MENUITEM '&Exclusão' ACTION mandcr(4)
               POPUP '&Listagem'
                  MENUITEM '&Perda' ACTION mandcr(5,1)
                  MENUITEM '&Vencidas' ACTION mandcr(5,2)
                  MENUITEM '&Nome' ACTION mandcr(5,3)
                  MENUITEM '&Codigo' ACTION mandcr(5,4)
                  MENUITEM '&Portador' ACTION mandcr(5,5)
                  MENUITEM '&Pagamento' ACTION mandcr(5,6)
                  MENUITEM '&Sequencia' ACTION mandcr(5,7)
                  MENUITEM '&Emissão' ACTION mandcr(5,8)
                  MENUITEM '&Cidade' ACTION mandcr(5,9)
               END POPUP
               POPUP '&Titulos'
                  MENUITEM '&Brasil' ACTION mandcr(6,1)
                  MENUITEM '&Sicred    ' ACTION mandcr(6,2)
               END POPUP
            END POPUP
            POPUP '&Instrução'
               MENUITEM '&Inclusão' ACTION manlcr(1)
               MENUITEM '&Alteração' ACTION manlcr(2)
               POPUP '&Consulta'
                  MENUITEM '&Instrução' ACTION manlcr(3,1)
                  MENUITEM '&Duplicata' ACTION manlcr(3,2)
                  MENUITEM '&Cliente' ACTION manlcr(3,3)
               END POPUP
               MENUITEM '&Exclusão' ACTION manlcr(4)
               POPUP '&Listagem'
                  MENUITEM '&Instrução' ACTION manlcr(5,1)
                  MENUITEM '&Diario' ACTION manlcr(5,2)
                  MENUITEM '&Razão' ACTION manlcr(5,3)
               END POPUP
               MENUITEM '&Fechamento' ACTION manlcr(6)
            END POPUP
            POPUP '&Baixas'
               MENUITEM '&Documento' ACTION manbcr(1)
               MENUITEM '&Clientes' ACTION manbcr(2)
               MENUITEM '&Recepcão' ACTION manbcr(3)
               MENUITEM '&Consiste' ACTION manbcr(4)
               MENUITEM '&Listagem' ACTION manbcr(5)
            END POPUP
            POPUP '&Operacoes'
               MENUITEM '&Inclusao' ACTION manmcr(1)
               MENUITEM '&Alteracao' ACTION manmcr(2)
               MENUITEM '&Consulta' ACTION manmcr(3)
               MENUITEM '&Exclusao' ACTION manmcr(4)
               MENUITEM '&Listagem' ACTION manmcr(5)
            END POPUP
            POPUP '&Portadores'
               MENUITEM '&Inclusão' ACTION manpor(1)
               MENUITEM '&Alteração' ACTION manpor(2)
               MENUITEM '&Consulta' ACTION manpor(3)
               MENUITEM '&Exclusão' ACTION manpor(4)
               MENUITEM '&Listagem' ACTION manpor(5)
            END POPUP
            POPUP '&Exportar'
               MENUITEM '&Remessa' ACTION manexp(1)
               MENUITEM '&Lista Retorno' ACTION manexp(2)
               MENUITEM '&Baixa Retorno' ACTION manexp(3)
            END POPUP
            POPUP '&Etiquetas'
               MENUITEM '&Inclusão' ACTION manetq(1)
               MENUITEM '&Alteração' ACTION manetq(2)
               MENUITEM '&Consulta' ACTION manetq(3)
               MENUITEM '&Exclusão' ACTION manetq(4)
               MENUITEM '&Listagem' ACTION manetq(5)
               MENUITEM '&Parametro' ACTION manetq(6)
            END POPUP
         END POPUP
         POPUP '&Pagar'
            POPUP '&Duplicata'
               MENUITEM '&Inclusão' ACTION mandcp(1)
               POPUP '&Alteracao'
                  MENUITEM '&Titulo' ACTION mandcp(2,1)
                  MENUITEM '&Portador' ACTION mandcp(2,3)
               END POPUP
               POPUP '&Consulta'
                  MENUITEM '&Sequencia' ACTION mandcp(3,1)
                  MENUITEM '&Vencidas' ACTION mandcp(3,2)
                  MENUITEM '&Emissao' ACTION mandcp(3,3)
                  MENUITEM '&Codigos' ACTION mandcp(3,4)
                  MENUITEM '&Portador' ACTION mandcp(3,5)
                  MENUITEM '&Pagamento' ACTION mandcp(3,6)
               END POPUP
               MENUITEM '&Exclusão' ACTION mandcp(4)
               POPUP '&Listagem'
                  MENUITEM '&Sequencia' ACTION mandcp(5,1)
                  MENUITEM '&Vencidas' ACTION mandcp(5,2)
                  MENUITEM '&Nome' ACTION mandcp(5,3)
                  MENUITEM '&Codigo' ACTION mandcp(5,4)
                  MENUITEM '&Portador' ACTION mandcp(5,5)
                  MENUITEM '&Pagamento' ACTION mandcp(5,6)
               END POPUP
            END POPUP
            POPUP '&Instrução'
               MENUITEM '&Inclusão' ACTION manlcp(1)
               MENUITEM '&Alteração' ACTION manlcp(2)
               POPUP '&Consulta'
                  MENUITEM '&Instrução' ACTION manlcp(3,1)
                  MENUITEM '&Duplicata' ACTION manlcp(3,2)
                  MENUITEM '&Fornecedor' ACTION manlcp(3,3)
               END POPUP
               MENUITEM '&Exclusão' ACTION manlcp(4)
               POPUP '&Listagem'
                  MENUITEM '&Instrução' ACTION manlcp(5,1)
                  MENUITEM '&Diario' ACTION manlcp(5,2)
                  MENUITEM '&Razão' ACTION manlcp(5,3)
               END POPUP
               MENUITEM '&Fechamento' ACTION manlcp(6)
            END POPUP
            POPUP '&Baixas'
               MENUITEM '&Documento' ACTION manbcp(1)
               MENUITEM '&Fornecedor' ACTION manbcp(2)
               MENUITEM '&Listagem' ACTION manbcp(3)
            END POPUP
            POPUP '&Operacoes'
               MENUITEM '&Inclusao' ACTION manmcp(1)
               MENUITEM '&Alteracao' ACTION manmcp(2)
               MENUITEM '&Consulta' ACTION manmcp(3)
               MENUITEM '&Exclusao' ACTION manmcp(4)
               MENUITEM '&Listagem' ACTION manmcp(5)
            END POPUP
         END POPUP
         POPUP '&Bancos'
            POPUP '&Conta'
               MENUITEM '&Inclusão' ACTION manban(1)
               MENUITEM '&Alteração' ACTION manban(2)
               MENUITEM '&Consulta' ACTION manban(3)
               MENUITEM '&Exclusão' ACTION manban(4)
               MENUITEM '&Listagem' ACTION manban(5)
               MENUITEM '&Exercicio' ACTION manban(6)
            END POPUP
            POPUP '&Historico'
               MENUITEM '&Inclusão' ACTION manhib(1)
               MENUITEM '&Alteração' ACTION manhib(2)
               MENUITEM '&Consulta' ACTION manhib(3)
               MENUITEM '&Exclusão' ACTION manhib(4)
               MENUITEM '&Listagem' ACTION manhib(5)
            END POPUP
            POPUP '&Movimento'
               MENUITEM '&Inclusão' ACTION manlab(1)
               MENUITEM '&Alteração' ACTION manlab(2)
               MENUITEM '&Consulta' ACTION manlab(3)
               MENUITEM '&Exclusão' ACTION manlab(4)
               POPUP '&Listagem'
                  MENUITEM '&Instrução' ACTION manlcp(5,1)
                  MENUITEM '&Diario' ACTION manlcp(5,2)
                  MENUITEM '&Razão' ACTION manlcp(5,3)
               END POPUP
               MENUITEM '&Conciliar' ACTION manlab(6)
            END POPUP
            POPUP '&Cheque'
               MENUITEM '&Inclusão' ACTION manche(1)
               MENUITEM '&Alteracao' ACTION manche(2)
               POPUP '&Consulta'
                  MENUITEM '&Cheque' ACTION manche(3,1)
                  MENUITEM '&Fornecedor' ACTION manche(3,2)
               END POPUP
               MENUITEM '&Exclusao' ACTION manche(4)
               MENUITEM '&Listagem' ACTION manche(5)
               POPUP '&Outros'
                  MENUITEM '&Emissao' ACTION manche(6,1)
                  MENUITEM '&Copia' ACTION manche(6,2)
                  MENUITEM '&Elimina' ACTION manche(6,3)
               END POPUP
               MENUITEM '&Liberacao' ACTION manche(7)
            END POPUP
            POPUP '&Cheque Pre'
               MENUITEM '&Inclusão' ACTION manprd(1)
               MENUITEM '&Alteracao' ACTION manprd(2)
               POPUP '&Consulta'
                  MENUITEM '&Cheque' ACTION manprd(3,1)
                  MENUITEM '&Banco' ACTION manprd(3,2)
                  MENUITEM '&Emissao' ACTION manprd(3,3)
                  MENUITEM '&Vencimento' ACTION manprd(3,4)
                  MENUITEM '&Cliente' ACTION manprd(3,5)
                  MENUITEM '&Valor' ACTION manprd(3,6)
                  MENUITEM '&Entrada' ACTION manprd(3,7)
               END POPUP
               MENUITEM '&Exclusao' ACTION manprd(4)
               POPUP '&Listagem'
                  MENUITEM '&Cheque' ACTION manprd(5,1)
                  MENUITEM '&Banco' ACTION manprd(5,2)
                  MENUITEM '&Emissao' ACTION manprd(5,3)
                  MENUITEM '&Vencimento' ACTION manprd(5,4)
                  MENUITEM '&Cliente' ACTION manprd(5,5)
                  MENUITEM '&Entrada' ACTION manprd(5,6)
               END POPUP
               MENUITEM '&Baixa' ACTION manprd(6)
            END POPUP
         END POPUP
         POPUP '&Caixa'
            POPUP '&Aplicação'
               MENUITEM '&Inclusão' ACTION manplx(1)
               MENUITEM '&Alteração' ACTION manplx(2)
               MENUITEM '&Consulta' ACTION manplx(3)
               MENUITEM '&Exclusão' ACTION manplx(4)
               MENUITEM '&Listagem' ACTION manplx(5)
            END POPUP
            POPUP '&Historico'
               MENUITEM '&Inclusão' ACTION manhix(1)
               MENUITEM '&Alteração' ACTION manhix(2)
               MENUITEM '&Consulta' ACTION manhix(3)
               MENUITEM '&Exclusão' ACTION manhix(4)
               MENUITEM '&Listagem' ACTION manhix(5)
            END POPUP
            POPUP '&Fluxo de Caixa'
               MENUITEM '&Inclusão' ACTION manlax(1)
               MENUITEM '&Alteração' ACTION manlax(2)
               MENUITEM '&Consulta' ACTION manlax(3)
               MENUITEM '&Exclusão' ACTION manlax(4)
               POPUP '&Listagem'
                  MENUITEM '&Periodo' ACTION manlax(5,1)
                  MENUITEM '&Contas' ACTION manlax(5,2)
               END POPUP
            END POPUP
            POPUP '&Analitico'
               MENUITEM '&Titulos' ACTION mananx(1)
               MENUITEM '&Aplicacao' ACTION mananx(2)
               MENUITEM '&Caixa' ACTION mananx(3)
            END POPUP
            POPUP '&Sintetico'
               MENUITEM '&Titulos' ACTION mansix(1)
               MENUITEM '&Aplicacao' ACTION mansix(2)
            END POPUP
            MENUITEM '&Resultado' ACTION demonx()
         END POPUP
         POPUP '&Outros'
            POPUP '&Convenios'
               MENUITEM '&Inclusão' ACTION mancve(1)
               MENUITEM '&Alteração' ACTION mancve(2)
               MENUITEM '&Consulta' ACTION mancve(3)
               MENUITEM '&Exclusão' ACTION mancve(4)
               MENUITEM '&Listagem' ACTION mancve(5)
            END POPUP
            POPUP '&CFOP Fiscal'
               MENUITEM '&Inclusão' ACTION manfis(1)
               MENUITEM '&Alteração' ACTION manfis(2)
               MENUITEM '&Consulta' ACTION manfis(3)
               MENUITEM '&Exclusão' ACTION manfis(4)
               MENUITEM '&Listagem' ACTION manfis(5)
            END POPUP
            POPUP '&Fiscal'
               MENUITEM '&Resumo ICMS' ACTION manapu(1)
               MENUITEM '&Livro ICMS' ACTION manapu(2)
               MENUITEM '&Apuracao ICMS' ACTION manapu(3)
               MENUITEM '&Pis/Cofins' ACTION manapu(4)
               MENUITEM '&Sped ICMS' ACTION manapu(5)
            END POPUP
            POPUP '&Usuarios'
               MENUITEM '&Inclusão' ACTION manlog(1)
               MENUITEM '&Alteração' ACTION manlog(2)
               MENUITEM '&Consulta' ACTION manlog(3)
               MENUITEM '&Exclusão' ACTION manlog(4)
               MENUITEM '&Restricoes' ACTION manlog(5)
            END POPUP
            MENUITEM '&Salva Configuração' ACTION salvaconf()
         END POPUP
      END MENU
   END WINDOW
   CENTER WINDOW frmMenu
   ACTIVATE WINDOW frmMenu
RETURN NIL

