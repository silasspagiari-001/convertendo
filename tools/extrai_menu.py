"""Extrai as opções do menu de NOVOMENU (MENUAGRO.PRG) para uma tabela de dados.

Uso: python3 tools/extrai_menu.py > docs/menu_dados.txt
Não altera o MENUAGRO.PRG; apenas lê e gera o inventário.
"""
import re, sys

SRC = 'MENUAGRO.PRG'
raw = open(SRC, 'rb').read().decode('cp850')
lines = raw.replace('\r\n', '\n').split('\n')

# só dentro de NOVOMENU, ignorando linhas comentadas e blocos /* */
start = next(i for i, l in enumerate(lines) if re.match(r'^FUNCTION NOVOMENU', l, re.I))
end = next(i for i in range(start + 1, len(lines)) if re.match(r'^(FUNCTION|PROCEDURE)\s', lines[i], re.I))
body = lines[start:end]

ativo, em_bloco = [], False
for l in body:
    s = l.strip()
    if s.startswith('/*'):
        em_bloco = True
    if not em_bloco and not s.startswith('*') and not s.startswith('//'):
        ativo.append(l)
    if em_bloco and '*/' in s:
        em_bloco = False
code = '\n'.join(ativo)

def args_de(chamada):
    """Divide os argumentos de uma chamada respeitando (), {} e aspas."""
    out, cur, prof, q = [], '', 0, None
    for ch in chamada:
        if q:
            cur += ch
            if ch == q:
                q = None
            continue
        if ch in '"\'':
            q = ch; cur += ch; continue
        if ch in '({[': prof += 1
        if ch in ')}]': prof -= 1
        if ch == ',' and prof == 0:
            out.append(cur.strip()); cur = ''
        else:
            cur += ch
    out.append(cur.strip())
    return out

itens, subs, seps = [], [], 0
for m in re.finditer(r'AddDownItem\s*\(', code):
    i = m.end(); prof = 1; q = None
    while prof:
        ch = code[i]
        if q:
            if ch == q: q = None
        elif ch in '"\'': q = ch
        elif ch == '(': prof += 1
        elif ch == ')': prof -= 1
        i += 1
    a = args_de(code[m.end():i - 1])
    itens.append(a)

seps = len(re.findall(r'AddDownSep\s*\(', code))
subs = re.findall(r'(\w+)\s*:=\s*NewDownMenu\(\)', code)
barra = re.findall(r'AddBarItem\(\s*mBar\s*,\s*"([^"]*)"\s*,\s*,\s*(\w+)', code)

print(f'# Menu extraído de NOVOMENU ({SRC}) - gerado por tools/extrai_menu.py')
print(f'# Itens ativos: {len(itens)} | Submenus: {len(subs)} | Separadores: {seps} | Barra: {len(barra)}')
print('# Formato: menu-pai | rótulo | ação (bloco ou chamada) | id')
print()
for a in barra:
    print(f'BARRA | {a[0]} | submenu {a[1]}')
print()
for a in itens:
    pai, rot = a[0], a[1].strip('"')
    bloco = next((x for x in a[2:] if x.startswith('{')), '(sem ação)')
    idn = a[-1]
    print(f'{pai} | {rot} | {bloco} | {idn}')
