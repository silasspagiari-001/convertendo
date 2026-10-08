"""Gera stubs para o teste do menu MiniGUI: cada função chamada pelo menu
vira uma função que apenas avisa 'Em migração'. Não usa os módulos antigos.

Uso: python3 tools/gera_stubs.py interface/menu_minigui.prg > interface/atlas_mg/stubs_migracao.prg
"""
import re, sys

src = open(sys.argv[1], encoding='utf-8').read()
chamadas = re.findall(r'ACTION\s+(\w+)\s*\(([^)]*)\)', src)
funcs = {}
for nome, args in chamadas:
    n = 0 if not args.strip() else len([a for a in args.split(',') if a.strip()])
    funcs[nome] = max(funcs.get(nome, 0), n)

print('// Gerado por tools/gera_stubs.py. Substitui as funções dos módulos antigos no teste.')
print('#include "minigui.ch"')
print()
for nome in sorted(funcs, key=str.lower):
    params = ', '.join(f'p{i}' for i in range(1, funcs[nome] + 1))
    print(f'FUNCTION {nome}({params})')
    print(f"   MsgInfo('Opção em migração: {nome}', 'Atlas')")
    print('RETURN NIL')
    print()
print(f'// {len(funcs)} funções')
