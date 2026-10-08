# Inventário da interface: menu principal e cadastro de clientes

Gerado a partir do código atual (branch `limpeza-arquivos-nao-usados`).

## 1. Menu principal (`MENUAGRO.PRG`)

- Ponto de entrada: `PROCEDURE Main()` (linha ~118), que chama `NOVOMENU()`.
- Interface atual: **Visual Lib** (`VISUAL2.CH`, `NewBarMenu()`, `NewDownMenu()`, `AddDownItem()`, `DrawFn()`) sobre **WVT** (`wvw_*`, `WvtSetObjects`).
- Tamanho: 493 itens de menu (`AddDownItem`), 91 submenus.
- Padrão dos itens: cada item chama uma função de módulo, por exemplo `{ || mancli(1) }`, `{ || manemp(2) }`, `{ || manpro(5,1) }`.
- Barra de status com `wvw_sbCreate` / `wvw_sbSetText`; timer com `wvw_SetTimer(1000)`.

**Implicação para a migração:** o conteúdo do menu é dados (rótulo, tecla, ação). Dá para extrair para uma tabela
`{ rótulo, tecla de atalho, bloco de ação }` e montar o menu da HwGUI a partir dela. Os blocos de ação não precisam mudar,
então a troca do menu afeta a casca da interface e não as telas.

## 2. Cadastro de clientes (`EAGRO24.PRG`)

- Dispatcher: `MANCLI(M_OPC, M_OPC1, M_OPC2)` (linha 7). Opções:
  1 Inclusão → `INCCLI` · 2 Alteração → `ALTCLI` · 3 Consulta → `CONCLI("NORMAL")` · 4 Exclusão → `EXCCLI`
  5 Listagem → `LISCLI` · 6 Etiqueta → `ETICLI` · 7 Consulta mortos → `CONCLI("MORTO")` · 8 TipoCli → `TIPOCLI`.
- Tamanho: 3069 linhas no arquivo, com 371 comandos `@ ... SAY/GET`.
- Validações já em funções separadas: `VERCLICGC`, `VALORESCLI` (em `ALT.PRG`), `VERMSGCLI`.
- Outros pontos de entrada: o menu de faturamento chama `mancli(1..4)` e `mancli(5,1)` (itens 183–187). Qualquer mudança em `MANCLI` afeta o faturamento.
- Campos de cliente também são usados em NF-e/ACBr (`ACBR_NFE.PRG`, `XML.PRG`). Mudanças de campo quebram a parte fiscal.

**Implicação para a migração:** separar primeiro a lógica (gravação, validação, SQL) da tela (`@ SAY/GET`). Depois,
cada opção vira um diálogo HwGUI que chama a mesma lógica.

## 3. Dependências compartilhadas (afetam ambos)

- `VLIB.PRG`, `FUNCOES.PRG`, `ARQUIVOS.PRG`: `sombra`, `RODAPE`, `SALVACONF`, `SEEXISTESQL`, `ABRE_CLI`, `ALIASCLI`.
- `ptmenu.ch`, `ACEL.CH`, `VISUAL2.CH`: constantes e macros usadas nas telas.
- 23 arquivos `.PRG` chamam funções WVT/VL. Eles precisam de migração ou de camada de compatibilidade.

## 4. Riscos

1. Migrar o menu sem migrar as telas exige manter WVT e HwGUI convivendo durante a transição.
2. `MANCLI` é chamado por outros módulos. A mudança precisa manter a mesma assinatura.
3. Testes manuais são obrigatórios: a validação de CNPJ/CPF, o cadastro de município e o faturamento devem ser comparados antes e depois com uma cópia dos dados.

## 5. Sequência proposta

1. Escolher e confirmar a versão do HwGUI.
2. Extrair a tabela de menu de `NOVOMENU` para dados, sem mudar o comportamento.
3. Criar a casca HwGUI do menu principal, chamando os mesmos blocos de ação.
4. Separar a lógica de `INCCLI`, `ALTCLI`, `CONCLI` e `EXCCLI` da tela.
5. Criar os diálogos HwGUI do cadastro de clientes, um por opção.
6. Testar com cópia dos dados e aprovação do cliente antes de substituir a versão em produção.

## 6. Achados do passo 2 (tabela de menu)

- 455 opções ativas em `NOVOMENU`: 374 com ação direta e 81 que só abrem submenu (todas verificadas).
- `mFisCfop` é reutilizada: "CFOP Fiscal" e "Fiscal" apontam para menus diferentes. O gerador resolve por instância.
- `mFinBanMovLis` (opções Analítico, Sintético, Conciliar, Extrato, função `manlab`) é criado, mas nunca ligado ao menu. Essas 4 opções não aparecem hoje no sistema. Confirmar com o cliente se devem ser mantidas.
- `interface/menu_minigui.prg` é a proposta gerada para o MiniGUI (373 opções alcançáveis). Não está no `atlas.xDev`. Precisa de compilação e teste.

**Decisão:** as opções de `mFinBanMovLis` (Analítico, Sintético, Conciliar, Extrato) ficam fora da migração. O menu gerado não as inclui.
