"""Leitura compartilhada do menu de NOVOMENU (MENUAGRO.PRG)."""
import re

def _args(chamada):
    out, cur, prof, q = [], '', 0, None
    for ch in chamada:
        if q:
            cur += ch
            if ch == q: q = None
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

def le_menu(src):
    """Retorna (itens, barra). Cada item é (pai, rótulo, ação, submenu, id, inst_pai, inst_sub).

    inst_* identifica a instância do menu: a variável pode ser reatribuída com
    NewDownMenu() (ex.: mFisCfop), e cada item guarda o objeto vigente naquele momento.
    """
    raw = open(src, 'rb').read().decode('cp850').replace('\r\n', '\n').split('\n')
    s = next(i for i, l in enumerate(raw) if re.match(r'^FUNCTION NOVOMENU', l, re.I))
    e = next(i for i in range(s + 1, len(raw)) if re.match(r'^(FUNCTION|PROCEDURE)\s', raw[i], re.I))
    ativo, bloco = [], False
    for l in raw[s:e]:
        t = l.strip()
        if t.startswith('/*'): bloco = True
        if not bloco and not t.startswith('*') and not t.startswith('//'): ativo.append(l)
        if bloco and '*/' in t: bloco = False
    code = '\n'.join(ativo)

    inst, contador = {}, 0
    itens = []
    eventos = [(m.start(), 'novo', m) for m in re.finditer(r'(\w+)\s*:=\s*NewDownMenu\s*\(\s*\)', code, re.I)]
    eventos += [(m.start(), 'item', m) for m in re.finditer(r'AddDownItem\s*\(', code)]
    for pos, tipo, m in sorted(eventos, key=lambda x: x[0]):
        if tipo == 'novo':
            contador += 1
            inst[m.group(1).lower()] = contador
            continue
        i = m.end(); prof = 1; q = None
        while prof:
            ch = code[i]
            if q:
                if ch == q: q = None
            elif ch in '"\'': q = ch
            elif ch == '(': prof += 1
            elif ch == ')': prof -= 1
            i += 1
        a = _args(code[m.end():i - 1])
        pai, rot = a[0], a[1]
        arg3 = a[3] if len(a) > 3 else ''
        if arg3.startswith('{'):
            acao, sub = arg3, ''
        else:
            acao, sub = '', arg3
        ip = inst.get(pai.lower(), 0)
        isub = inst.get(sub.lower(), 0) if sub else 0
        itens.append((pai, rot, acao, sub, a[-1], ip, isub))
    barra = re.findall(r'AddBarItem\(\s*mBar\s*,\s*"([^"]*)"\s*,\s*,\s*(\w+)', code)
    barra_inst = [(n, v, inst.get(v.lower(), 0)) for n, v in barra]
    return itens, barra_inst
