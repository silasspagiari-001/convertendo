"""Gera a casca do menu principal em MiniGUI a partir de MENUAGRO.PRG (NOVOMENU).

Uso: python3 tools/gera_menu_minigui.py > interface/menu_minigui.prg
Não altera o MENUAGRO.PRG nem o build atual. O arquivo gerado é uma
proposta para o executável MiniGUI e precisa ser compilado e testado.
"""
import re, sys
sys.path.insert(0, 'tools')
from extrai_menu_lib import le_menu  # noqa: E402

itens, barra = le_menu('MENUAGRO.PRG')  # barra: (nome, var, inst)

# filhos por variável de menu-pai, na ordem do código
filhos = {}
for pai, rot, acao, sub, idn, ip, isub in itens:
    filhos.setdefault((pai.lower(), ip), []).append((rot, acao, sub, isub))

def caption(rot):
    return rot.strip('"').replace('"', "'")

def emite(chave, nivel):
    out = []
    ind = '   ' * nivel
    for rot, acao, sub, isub in filhos.get(chave, []):
        if acao:  # item com ação direta: {|| funcao(args) }
            chamada = re.sub(r'^\{\s*\|\|\s*', '', acao)
            chamada = re.sub(r'\s*\}\s*$', '', chamada).strip()
            out.append(f"{ind}MENUITEM '{caption(rot)}' ACTION {chamada}")
        elif sub:  # abre submenu (instância correta)
            out.append(f"{ind}POPUP '{caption(rot)}'")
            out += emite((sub.lower(), isub), nivel + 1)
            out.append(f"{ind}END POPUP")
        else:  # opção sem destino
            out.append(f"{ind}MENUITEM '{caption(rot)}' ACTION MsgInfo('Em migração: {caption(rot)}')")
    return out

linhas = [
    '// Gerado por tools/gera_menu_minigui.py a partir de MENUAGRO.PRG (NOVOMENU).',
    '// PROPOSTA - não compilada. Não está no atlas.xDev.',
    '#include "minigui.ch"',
    '',
    'FUNCTION MenuPrincipalMG()',
    "   DEFINE WINDOW frmMenu AT 0,0 WIDTH 800 HEIGHT 600 TITLE 'Atlas' MAIN",
    '      DEFINE MAIN MENU',
]
for nome_barra, var, iv in barra:
    linhas.append(f"         POPUP '{caption(nome_barra)}'")
    linhas += emite((var.lower(), iv), 4)
    linhas.append('         END POPUP')
linhas += [
    '      END MENU',
    '   END WINDOW',
    '   CENTER WINDOW frmMenu',
    '   ACTIVATE WINDOW frmMenu',
    'RETURN NIL',
    '',
]
print('\n'.join(linhas))
