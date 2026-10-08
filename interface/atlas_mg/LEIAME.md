# Atlas_MG - teste da casca do menu (MiniGUI)

Teste inicial: só o menu principal, com todas as opções chamando avisos de "em migração".
Não usa nenhum módulo do sistema atual (EAGRO*.PRG, MENUAGRO.PRG etc.).

## Arquivos
- `atlas_mg.prg`: programa principal (`Main`).
- `menu_minigui.prg`: menu gerado a partir do `NOVOMENU` (função `MenuPrincipalMG`).
- `stubs_migracao.prg`: funções que as opções do menu chamam; só mostram um aviso.

## Como criar no HMGS IDE
1. Novo projeto **Harbour MiniGUI** (ou projeto vazio com a biblioteca MiniGUI).
2. Adicionar os 3 arquivos `.prg` desta pasta.
3. Definir `atlas_mg.prg` como programa principal.
4. Compilar e executar.

## O que testar
- A janela abre com o menu principal (7 menus: Estoque, Faturar, Receber, Pagar, Bancos, Caixa, Outros).
- Os submenus abrem na ordem certa.
- Cada opção mostra "Opção em migração: <nome>".
- Compilação sem erros. Se houver erro, enviar a mensagem completa.

Nota: os acentos estão em UTF-8. Se aparecerem quebrados, avisar.


## Compilar pelo console (alternativa ao HMGS)
1. Ajuste `MINIGUI_DIR` em `build_atlas_mg.bat` para a pasta do seu MiniGUI (a que contém `Compile.bat`).
2. Dê dois cliques em `build_atlas_mg.bat` (ou rode no prompt dentro desta pasta).
3. Se aparecer `OK: atlas_mg.exe gerado`, execute o `atlas_mg.exe`.
