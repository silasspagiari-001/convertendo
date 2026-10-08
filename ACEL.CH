
/*
TITULO     : ACEL - Controle de Faturamento e Caixa
DATA       : 14/07/05
PROGRAMA   : ACEL.CH
COMENTARIO : DIRETIVAS DE PRE-PROCESSADOR
*/
 
#define DESLIGA  0
#define LIGA     1
#define CURSOR(P_CUR) (SETCURSOR( IIF( P_CUR = 0, 0, IIF( READINSERT()=.T. , 3, 1 ) ) ))
#define SOS(TEX_TO)  (SOS += TEX_TO + CHR(13) + CHR(10))
#define BEEP()         TONE( 250, 4 )
#define T_ENTER         13
#define T_ESC           27
#define T_INSERT        22
#define T_CIMA           5
#define T_BAIXO         24
#define T_ESQUERDA      19
#define T_DIREITA        4
#define T_HOME           1
#define T_END            6
#define T_PGUP          18
#define T_PGDN           3
#define T_BACKSPACE      8
#define T_CTRL_W        23
#define T_F1            28
#define T_F2            -1
#define T_F3            -2
#define T_F4            -3
#define T_F5            -4
#define T_F6            -5
#define T_F7            -6
#define T_F10           -9
#define T_CTRL_PGDN     30
#define T_CTRL_PGUP     31
#define T_DEL            7
#define T_CTRL_HOME     29
#define T_CTRL_END      23
#define T_CTRL_ESQUERDA 26
#define T_CTRL_DIREITA   2
#define T_TAB            9
#define T_SH_TAB       271
#define TB_COR_DEL      CONTECOR[ 4 ]  // Cor dos registros DELETADOS
#define TB_RODAPE       "ÄÁÄ"  // Caracteres para o rodape do TBROWSE
#define TB_SEP_LIN      " ³ "  // Separadores de coluna do TBROWSE
#define TB_SEP_CAB      "ÄÂÄ"  // Separadores do cabecalho do TBROWSE
#define TB_JANELA       "ÚÄ¿³´³ÙÄÀ³Ã³"
#define MOSTRA_PAG_1      "M"
#define CONSULTA          "C"
#define ALTERACAO         "A"
#define EXCLUSAO          "E"
#define INCLUSAO          "I"
#define SUB_MENU       1
#define MENU_PRINCIPAL 0
#define COLUNAR             1
#define COLUNAR_AUTOMATICO  2
#define FICHA               3
#define ETIQUETA            4
#define SIM  .T.
#define NAO  .F.
#define _TIPO_REL      1
#define _TITULOS       2
#define _CONTEUDO      3
#define _REDUCAO       4
#define _LIN_SUP       5
#define _LIN_INF       6
#define _COL_INI       7
#define _SEPARADOR     8
#define _TOTALIZA      9
#define _SEP_CAB      10
#define _SUB_TOT      11
#define _TIT_TOT      12
#define _TIT_SUB_TOT  13
#define _QUEBRA       14
#define _RESUMO       15
#define _LARGURA      16
#define _LINHA        17
#define _PAGINA       18
#define _BLOCO_CAB    19
#define _TIPO_SAIDA   20
#define _TIT_STOT_QUE 21
#define _FILTRO       22
#define _LARG_MEMO    23
#define _PRE_CONTEUDO 24
#define _NUM_COL_ET   25
#define _COL_DISTANC  26
#define _LIN_DISTANC  27
#define _QUANT_LIN    28
#translate relatorio:TIPO                   => ObjRelatorio\[ _TIPO_REL ]
#translate relatorio:TITULOS                => ObjRelatorio\[ _TITULOS ]
#translate relatorio:CONTEUDO               => ObjRelatorio\[ _CONTEUDO ]
#translate relatorio:REDUCAO                => ObjRelatorio\[ _REDUCAO ]
#translate relatorio:LIN_SUPERIOR           => ObjRelatorio\[ _LIN_SUP ]
#translate relatorio:LIN_INFERIOR           => ObjRelatorio\[ _LIN_INF ]
#translate relatorio:COL_INICIAL            => ObjRelatorio\[ _COL_INI ]
#translate relatorio:SEPARADOR              => ObjRelatorio\[ _SEPARADOR ]
#translate relatorio:TOTALIZA               => ObjRelatorio\[ _TOTALIZA ]
#translate relatorio:SEP_CABECALHO          => ObjRelatorio\[ _SEP_CAB ]
#translate relatorio:SUB_TOTALIZACAO        => ObjRelatorio\[ _SUB_TOT ]
#translate relatorio:TITULO_TOTAL           => ObjRelatorio\[ _TIT_TOT ]
#translate relatorio:TITULO_SUB_TOTAL       => ObjRelatorio\[ _TIT_SUB_TOT ]
#translate relatorio:TIT_SUBTOTAL_QUEBRA    => ObjRelatorio\[ _TIT_STOT_QUE ]
#translate relatorio:RESUMO                 => ObjRelatorio\[ _RESUMO ]
#translate relatorio:LARGURA                => ObjRelatorio\[ _LARGURA ]
#translate relatorio:LINHA                  => ObjRelatorio\[ _LINHA ]
#translate relatorio:PAGINA                 => ObjRelatorio\[ _PAGINA ]
#translate relatorio:SAIDA                  => ObjRelatorio\[ _TIPO_SAIDA ]
#translate relatorio:BLOCO_CABECALHO        => ObjRelatorio\[ _BLOCO_CAB ]
#translate relatorio:QUEBRA                 => ObjRelatorio\[ _QUEBRA ]
#translate relatorio:FILTRO                 => ObjRelatorio\[ _FILTRO ]
#translate relatorio:MEMO_LARGURA           => ObjRelatorio\[ _LARG_MEMO ]
#translate relatorio:PRE_CONTEUDO           => ObjRelatorio\[ _PRE_CONTEUDO ]
#translate relatorio:NUM_COLUNAS_ETQ        => ObjRelatorio\[ _NUM_COL_ET ]
#translate relatorio:COL_DISTANCIA          => ObjRelatorio\[ _COL_DISTANC ]
#translate relatorio:LIN_DISTANCIA          => ObjRelatorio\[ _LIN_DISTANC ]
#translate relatorio:QUANTIDADE_LIN         => ObjRelatorio\[ _QUANT_LIN ]
#translate relatorio:CONTEUDO()             => ObjMenu
#translate relatorio:RODA()                 => IIF( relatorio:TIPO = FICHA,;
                                       IMP_FICHA( PROCNAME(), PROCLINE() ),;
         IIF( relatorio:TIPO = ETIQUETA, IMP_ETQ( PROCNAME(), PROCLINE() ),;
                                       IMP_REL( PROCNAME(), PROCLINE() ) ) )
#translate relatorio:FILTRO( <X1> )         => ObjRelatorio\[ _FILTRO ] :=;
                                               { || <X1> }
#translate relatorio:LIMPA()             =>;
   ObjRelatorio := { 1,;      // Tipo do relatorio
                    {},;      // Titulos do relatorio
                    {},;      // Conteudo
                   NIL,;      // Reducao de caracteres
                     1,;      // Linha superior
                    61,;      // Linha inferior
                     1,;      // Coluna inicial
                     3,;      // Separador de colunas p/COLUNAR_AUTOMATICO
                    {},;      // Totalizacao
                   "-",;      // Separador de cabecalho
                   .F.,;      // Define se SUB-TOTALIZA
               "TOTAL",;      // Titulo para totalizacao
           "SUB-TOTAL",;      // Titulo para sub_total
                    {},;      // Quebras
                   NIL,;      // Resumo ( Rel. tipo balancetes )
                     0,;      // Largura -> Este dado e' de controle interno do objeto
                     0,;      // Linha -> Este dado e' de controle interno do objeto
                     1,;      // Pagina -> Este dado e' de controle interno do objeto
                   NIL,;      // Bloco de codigo para desvio do cabecalho
                   "I",;      // Tipo saida -> Este dado e' de controle interno do objeto
           "Sub-Total",;      // Titulo para sub_total de quebras
                   NIL,;      // Codigo de bloco contendo a expressao do filtro
                    75,;      // Largura dos campos tipo MEMO
                    {},;      // Pre-conteudo
                     2,;      // Numero de colunas da etiquetas
                     2,;      // Colunas entre etiquetas
                     1,;      // Linhas entre etiquetas
                     0 }      // Quantidade de linhas
#translate relatorio:ADD( <X1>, <X2>[, <X3>][, <X4>][ ,<X5>] )  =>;
           AADD( ObjRelatorio\[ _CONTEUDO ], { <X1>, { || <X2> },;
                 <"X2">[, <X3>][, <X4>][, <X5>] } )
#translate relatorio:ADDTOTAL( <X1>[, <X2>][, <X3>] )  =>;
           AADD( ObjRelatorio\[ _TOTALIZA ], { { || <X1> },;
                 <"X1">[, <X2>][, <X3>] } )
#translate relatorio:ADDQUEBRA( <X1>, <X2>[, <X3>][, <X4>] )  =>;
           AADD( ObjRelatorio\[ _QUEBRA ], { { || <X1> },;
                 <X2>[, <X3>][, <X4>] } )
#translate relatorio:ADDTITULO( <X1> )  =>;
           AADD( ObjRelatorio\[ _TITULOS ], { || <X1> } )
#translate relatorio:ADDPRECONTEUDO( <X1> )  =>;
           AADD( ObjRelatorio\[ _PRE_CONTEUDO ], { || <X1> } )
#define SALTA_PAGINA     0
#define SALTA_1_LINHA    1
#define SALTA_2_LINHAS   2
#define SALTA_3_LINHAS   3
#define TOTALIZA_QUEBRA .T.
#define _CABECALHO  1
#define _DADOS      2
#define _NOME_CAMPO 3
#define _COLUNA     4
#define _MASCARA    5
#define _TIPO_MENU     1
#define _OPCOES_MENU   2
#define _CHAMADA_MENU  3
#translate menu:LIMPA() => ObjMenu := { 0, {}, {} }
#translate menu:TIPO_MENU  =>  ObjMenu\[ _TIPO_MENU ]
#translate menu:RODA()  =>  MENU( ObjMenu, PROCNAME(), PROCLINE() )
#translate menu:ADD( <X1>, <X2>[, <X3> ] )  => ;
           AADD( ObjMenu\[ _OPCOES_MENU ], <X1> )\; AADD( ObjMenu\[ _CHAMADA_MENU ], { || <X2>[, <X3> ] } )
#translate menu:ADD( <X1> )  => ;
           AADD( ObjMenu\[ _OPCOES_MENU ], <X1> )\; AADD( ObjMenu\[ _CHAMADA_MENU ], { || NIL } )
#translate menu:CONTEUDO()  =>  ObjMenu
#define MOSTRA_BOTOES    0
#define EDITA_BOTOES     1
#define MOVIMENTA_BOTAO  2
#translate botao:LIMPA()     =>  ObjBotao := {}
#translate botao:RODA()      =>  BOTAO()
#translate botao:RODA( <X> ) =>  BOTAO( <X> )
#translate botao:MOSTRA()  =>  BOTAO( .T., .T. )
#translate botao:MOVIMENTA( <X1>, <X2>, <X3> )  =>  BOTAO( <X1>, <X2>, <X3> )
#translate botao:ADD( <X1>, <X2>, <X3> )  => ;
           AADD( ObjBotao, { <X1>, <X2>, <X3> } )
#translate botao:CONTEUDO()  =>  ObjBotao
 
/* Final ACEL.CH */
