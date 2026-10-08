
*****************
function NOVO_XMLSAT(F_OQUE)
*****************

local cRet := ""
local nBuffSize := 16                   // Read/write buffer size
local l7143Supp := .F.                  // Is function 7143h supported?
lOCAL aBlocks2 := {}

aLastPaint6 := WvtSetBlocks( aBlocks2 )

aMOTIVOS = { }

aadd(aMOTIVOS,{"100" ,"Autorizado o uso da NF-e"})
aadd(aMOTIVOS,{"101" ,"Cancelamento de NF-e homologado"})
aadd(aMOTIVOS,{"102" ,"Inutilizacao de numero homologado"})
aadd(aMOTIVOS,{"103" ,"Lote recebido com sucesso"})
aadd(aMOTIVOS,{"104" ,"Lote processado"})
aadd(aMOTIVOS,{"105" ,"Lote em processamento"})
aadd(aMOTIVOS,{"106" ,"Lote nao localizado"})
aadd(aMOTIVOS,{"107" ,"Serviço em Operacao"})
aadd(aMOTIVOS,{"108" ,"Servico Paralisado Momentaneamente (curto prazo)"})
aadd(aMOTIVOS,{"109" ,"Servico Paralisado sem Previsao"})
aadd(aMOTIVOS,{"110" ,"Uso Denegado"})
aadd(aMOTIVOS,{"111" ,"Consulta cadastro com uma ocorrencia"})
aadd(aMOTIVOS,{"112" ,"Consulta cadastro com mais de uma ocorrencia"})

aadd(aMOTIVOS,{"201" ,"Rejeicao: O numero maximo de numeracao de NF-e a inutilizar ultrapassou o limite"})
aadd(aMOTIVOS,{"202" ,"Rejeicao: Falha no reconhecimento da autoria ou integridade do arquivo digital"})
aadd(aMOTIVOS,{"203" ,"Rejeicao: Emissor nao habilitado para emissao da NF-e"})
aadd(aMOTIVOS,{"204" ,"Rejeicao: Duplicidade de NF-e"})
aadd(aMOTIVOS,{"205" ,"Rejeicao: NF-e esta denegada na base de dados da SEFAZ"})
aadd(aMOTIVOS,{"206" ,"Rejeicao: NF-e ja esta inutilizada na Base de dados da SEFAZ"})
aadd(aMOTIVOS,{"207" ,"Rejeicao: CNPJ do emitente invalido"})
aadd(aMOTIVOS,{"208" ,"Rejeicao: CNPJ do destinatario invalido"})
aadd(aMOTIVOS,{"209" ,"Rejeicao: IE do emitente invalida"})
aadd(aMOTIVOS,{"210" ,"Rejeicao: IE do destinatario invalida"})
aadd(aMOTIVOS,{"211" ,"Rejeicao: IE do substituto invalida"})
aadd(aMOTIVOS,{"212" ,"Rejeicao: Data de emissao NF-e posterior a data de recebimento"})
aadd(aMOTIVOS,{"213" ,"Rejeicao: CNPJ-Base do Emitente difere do CNPJ-Base do Certificado Digital"})
aadd(aMOTIVOS,{"214" ,"Rejeicao: Tamanho da mensagem excedeu o limite estabelecido"})
aadd(aMOTIVOS,{"215" ,"Rejeicao: Falha no schema XML"})
aadd(aMOTIVOS,{"216" ,"Rejeicao: Chave de Acesso difere da cadastrada"})
aadd(aMOTIVOS,{"217" ,"Rejeicao: NF-e não consta na base de dados da SEFAZ"})
aadd(aMOTIVOS,{"218" ,"Rejeicao: NF-e ja esta cancelada na base de dados da SEFAZ"})
aadd(aMOTIVOS,{"219" ,"Rejeicao: Circulacao da NF-e verificada"})
aadd(aMOTIVOS,{"220" ,"Rejeicao: NF-e autorizada ha mais de 7 dias (168 horas)"})
aadd(aMOTIVOS,{"221" ,"Rejeicao: Confirmado o recebimento da NF-e pelo destinatario"})
aadd(aMOTIVOS,{"222" ,"Rejeicao: Protocolo de Autorizacao de Uso difere do cadastrado"})
aadd(aMOTIVOS,{"223" ,"Rejeicao: CNPJ do transmissor do lote difere do CNPJ do transmissor da consulta"})
aadd(aMOTIVOS,{"224" ,"Rejeicao: A faixa inicial eh maior que a faixa final"})
aadd(aMOTIVOS,{"225" ,"Rejeicao: Falha no Schema XML do lote de NFe"})
aadd(aMOTIVOS,{"226" ,"Rejeicao: Codigo da UF do Emitente diverge da UF autorizadora"})
aadd(aMOTIVOS,{"227" ,"Rejeicao: Erro na Chave de Acesso - Campo Id – falta a literal NFe"})
aadd(aMOTIVOS,{"228" ,"Rejeicao: Data de Emissao muito atrasada"})
aadd(aMOTIVOS,{"229" ,"Rejeicao: IE do emitente nao informada"})
aadd(aMOTIVOS,{"230" ,"Rejeicao: IE do emitente nao cadastrada"})
aadd(aMOTIVOS,{"231" ,"Rejeicao: IE do emitente nao vinculada ao CNPJ"})
aadd(aMOTIVOS,{"232" ,"Rejeicao: IE do destinatario nao informada"})
aadd(aMOTIVOS,{"233" ,"Rejeicao: IE do destinatario nao cadastrada"})
aadd(aMOTIVOS,{"234" ,"Rejeicao: IE do destinatario nao vinculada ao CNPJ"})
aadd(aMOTIVOS,{"235" ,"Rejeicao: Inscricao SUFRAMA invalida"})
aadd(aMOTIVOS,{"236" ,"Rejeicao: Chave de Acesso com digito verificador invalido"})
aadd(aMOTIVOS,{"237" ,"Rejeicao: CPF do destinatario invalido"})
aadd(aMOTIVOS,{"238" ,"Rejeicao: Cabecalho - Versao do arquivo XML superior a Versao vigente"})
aadd(aMOTIVOS,{"239" ,"Rejeicao: Cabecalho - Versao do arquivo XML nao suportada"})
aadd(aMOTIVOS,{"240" ,"Rejeicao: Cancelamento/Inutilizacao - Irregularidade Fiscal do Emitente"})
aadd(aMOTIVOS,{"241" ,"Rejeicao: Um numero da faixa ja foi utilizado"})
aadd(aMOTIVOS,{"242" ,"Rejeicao: Cabecalho - Falha no Schema XML"})
aadd(aMOTIVOS,{"243" ,"Rejeicao: XML Mal Formado"})
aadd(aMOTIVOS,{"244" ,"Rejeicao: CNPJ do Certificado Digital difere do CNPJ da Matriz e do CNPJ do Emitente"})
aadd(aMOTIVOS,{"245" ,"Rejeicao: CNPJ Emitente nao cadastrado"})
aadd(aMOTIVOS,{"246" ,"Rejeicao: CNPJ Destinatario nao cadastrado"})
aadd(aMOTIVOS,{"247" ,"Rejeicao: Sigla da UF do Emitente diverge da UF autorizadora"})
aadd(aMOTIVOS,{"248" ,"Rejeicao: UF do Recibo diverge da UF autorizadora"})
aadd(aMOTIVOS,{"249" ,"Rejeicao: UF da Chave de Acesso diverge da UF autorizadora"})
aadd(aMOTIVOS,{"250" ,"Rejeicao: UF diverge da UF autorizadora"})
aadd(aMOTIVOS,{"251" ,"Rejeicao: UF/Municipio destinatario nao pertence a SUFRAMA"})
aadd(aMOTIVOS,{"252" ,"Rejeicao: Ambiente informado diverge do Ambiente de recebimento"})
aadd(aMOTIVOS,{"253" ,"Rejeicao: Digito Verificador da chave de acesso composta invalida"})
aadd(aMOTIVOS,{"254" ,"Rejeicao: NF-e complementar nao possui NF referenciada"})
aadd(aMOTIVOS,{"255" ,"Rejeicao: NF-e complementar possui mais de uma NF referenciada"})
aadd(aMOTIVOS,{"256" ,"Rejeicao: Uma NF-e da faixa ja esta inutilizada na Base de dados da SEFAZ"})
aadd(aMOTIVOS,{"257" ,"Rejeicao: Solicitante nao habilitado para emissao da NF-e"})
aadd(aMOTIVOS,{"258" ,"Rejeicao: CNPJ da consulta invalido"})
aadd(aMOTIVOS,{"259" ,"Rejeicao: CNPJ da consulta nao cadastrado como contribuinte na UF"})
aadd(aMOTIVOS,{"260" ,"Rejeicao: IE da consulta invalida"})
aadd(aMOTIVOS,{"261" ,"Rejeicao: IE da consulta nao cadastrada como contribuinte na UF"})
aadd(aMOTIVOS,{"262" ,"Rejeicao: UF nao fornece consulta por CPF"})
aadd(aMOTIVOS,{"263" ,"Rejeicao: CPF da consulta invalido"})
aadd(aMOTIVOS,{"264" ,"Rejeicao: CPF da consulta nao cadastrado como contribuinte na UF"})
aadd(aMOTIVOS,{"265" ,"Rejeicao: Sigla da UF da consulta difere da UF do Web Service"})
aadd(aMOTIVOS,{"266" ,"Rejeicao: Serie utilizada nao permitida no Web Service"})
aadd(aMOTIVOS,{"267" ,"Rejeicao: NF Complementar referencia uma NF-e inexistente"})
aadd(aMOTIVOS,{"268" ,"Rejeicao: NF Complementar referencia uma outra NF-e Complementar"})
aadd(aMOTIVOS,{"269" ,"Rejeicao: CNPJ Emitente da NF Complementar difere do CNPJ da NF Referenciada"})
aadd(aMOTIVOS,{"270" ,"Rejeicao: Codigo Municipio do Fato Gerador: digito invalido"})
aadd(aMOTIVOS,{"271" ,"Rejeicao: Codigo Municipio do Fato Gerador: difere da UF do emitente"})
aadd(aMOTIVOS,{"272" ,"Rejeicao: Codigo Municipio do Emitente: digito invalido"})
aadd(aMOTIVOS,{"273" ,"Rejeicao: Codigo Municipio do Emitente: difere da UF do emitente"})
aadd(aMOTIVOS,{"274" ,"Rejeicao: Codigo Municipio do Destinatario: digito invalido"})
aadd(aMOTIVOS,{"275" ,"Rejeicao: Codigo Municipio do Destinatario: difere da UF do Destinatario"})
aadd(aMOTIVOS,{"276" ,"Rejeicao: Codigo Municipio do Local de Retirada: digito invalido"})
aadd(aMOTIVOS,{"277" ,"Rejeicao: Codigo Municipio do Local de Retirada: difere da UF do Local de Retirada"})
aadd(aMOTIVOS,{"278" ,"Rejeicao: Codigo Municipio do Local de Entrega: digito invalido"})
aadd(aMOTIVOS,{"279" ,"Rejeicao: Codigo Municipio do Local de Entrega: difere da UF do Local de Entrega"})
aadd(aMOTIVOS,{"280" ,"Rejeicao: Certificado Transmissor invalido"})
aadd(aMOTIVOS,{"281" ,"Rejeicao: Certificado Transmissor Data Validade"})
aadd(aMOTIVOS,{"282" ,"Rejeicao: Certificado Transmissor sem CNPJ"})
aadd(aMOTIVOS,{"283" ,"Rejeicao: Certificado Transmissor - erro Cadeia de Certificacao"})
aadd(aMOTIVOS,{"284" ,"Rejeicao: Certificado Transmissor revogado"})
aadd(aMOTIVOS,{"285" ,"Rejeicao: Certificado Transmissor difere ICP-Brasil"})
aadd(aMOTIVOS,{"286" ,"Rejeicao: Certificado Transmissor erro no acesso a LCR"})
aadd(aMOTIVOS,{"287" ,"Rejeicao: Codigo Municipio do FG - ISSQN: digito invalido"})
aadd(aMOTIVOS,{"288" ,"Rejeicao: Codigo Municipio do FG - Transporte: digito invalido"})
aadd(aMOTIVOS,{"289" ,"Rejeicao: Codigo da UF informada diverge da UF solicitada"})
aadd(aMOTIVOS,{"290" ,"Rejeicao: Certificado Assinatura invalido"})
aadd(aMOTIVOS,{"291" ,"Rejeicao: Certificado Assinatura Data Validade"})
aadd(aMOTIVOS,{"292" ,"Rejeicao: Certificado Assinatura sem CNPJ"})
aadd(aMOTIVOS,{"293" ,"Rejeicao: Certificado Assinatura - erro Cadeia de Certificacao"})
aadd(aMOTIVOS,{"294" ,"Rejeicao: Certificado Assinatura revogado"})
aadd(aMOTIVOS,{"295" ,"Rejeicao: Certificado Assinatura difere ICP-Brasil"})
aadd(aMOTIVOS,{"296" ,"Rejeicao: Certificado Assinatura erro no acesso a LCR"})
aadd(aMOTIVOS,{"297" ,"Rejeicao: Assinatura difere do calculado"})
aadd(aMOTIVOS,{"298" ,"Rejeicao: Assinatura difere do padrão do Projeto"})
aadd(aMOTIVOS,{"299" ,"Rejeicao: XML da area de cabecalho com codificacao diferente de UTF-8"})
aadd(aMOTIVOS,{"401" ,"Rejeicao: CPF do remetente invalido"})
aadd(aMOTIVOS,{"402" ,"Rejeicao: XML da area de dados com codificacao diferente de UTF-8"})
aadd(aMOTIVOS,{"403" ,"Rejeicao: O grupo de informacoes da NF-e avulsa e de uso exclusivo do Fisco"})
aadd(aMOTIVOS,{"404" ,"Rejeicao: Uso de prefixo de namespace nao permitido"})
aadd(aMOTIVOS,{"405" ,"Rejeicao: Codigo do pais do emitente: digito invalido"})
aadd(aMOTIVOS,{"406" ,"Rejeicao: Codigo do pais do destinatario: digito invalido"})
aadd(aMOTIVOS,{"407" ,"Rejeicao: O CPF so pode ser informado no campo emitente para a NF-e avulsa"})
aadd(aMOTIVOS,{"409" ,"Rejeicao: Campo cUF inexistente no elemento nfeCabecMsg do SOAP Header"})
aadd(aMOTIVOS,{"410" ,"Rejeicao: UF informada no campo cUF nao e atendida pelo Web Service"})
aadd(aMOTIVOS,{"411" ,"Rejeicao: Campo versaoDados inexistente no elemento nfeCabecMsg do SOAP Header"})
aadd(aMOTIVOS,{"420" ,"Rejeicao: Cancelamento para NF-e ja cancelada"})
aadd(aMOTIVOS,{"450" ,"Rejeicao: Modelo da NF-e diferente de 55"})
aadd(aMOTIVOS,{"451" ,"Rejeicao: Processo de emissao informado invalido"})
aadd(aMOTIVOS,{"452" ,"Rejeicao: Tipo Autorizador do Recibo diverge do Orgao Autorizador"})
aadd(aMOTIVOS,{"453" ,"Rejeicao: Ano de inutilizacao nao pode ser superior ao Ano atual"})
aadd(aMOTIVOS,{"454" ,"Rejeicao: Ano de inutilizacao nao pode ser inferior a 2006"})
aadd(aMOTIVOS,{"478" ,"Rejeicao: Local da entrega nao informado para faturamento direto de veiculos novos"})
aadd(aMOTIVOS,{"502" ,"Rejeicao: Erro na Chave de Acesso - Campo Id nao corresponde a concatenacao dos campos correspondentes"})
aadd(aMOTIVOS,{"503" ,"Rejeicao: Serie utilizada fora da faixa permitida no SCAN (900-999)"})
aadd(aMOTIVOS,{"504" ,"Rejeicao: Data de Entrada/Saida posterior ao permitido"})
aadd(aMOTIVOS,{"505" ,"Rejeicao: Data de Entrada/Saida anterior ao permitido"})
aadd(aMOTIVOS,{"506" ,"Rejeicao: Data de Saida menor que a Data de Emissao"})
aadd(aMOTIVOS,{"507" ,"Rejeicao: O CNPJ do destinatario/remetente nao deve ser informado em operacao com o"})
aadd(aMOTIVOS,{"510" ,"Rejeicao: Operacao com Exterior e Codigo Pais destinatario e 1058 (Brasil) ou nao informado"})
aadd(aMOTIVOS,{"511" ,"Rejeicao: Nao e de Operacao com Exterior e Codigo Pais destinatario difere de 1058 (Brasil)"})
aadd(aMOTIVOS,{"512" ,"Rejeicao: CNPJ do Local de Retirada invalido"})
aadd(aMOTIVOS,{"513" ,"Rejeicao: Codigo Municipio do Local de Retirada deve ser 9999999 para UF retirada = EX"})
aadd(aMOTIVOS,{"514" ,"Rejeicao: CNPJ do Local de Entrega invalido"})
aadd(aMOTIVOS,{"515" ,"Rejeicao: Codigo Municipio do Local de Entrega deve ser 9999999 para UF entrega = EX"})
aadd(aMOTIVOS,{"516" ,"Rejeicao: Falha no schema XML e inexiste a tag raiz esperada para a mensagem"})
aadd(aMOTIVOS,{"517" ,"Rejeicao: Falha no schema XML e inexiste atributo versao na tag raiz da mensagem"})
aadd(aMOTIVOS,{"518" ,"Rejeicao: CFOP de entrada para NF-e de saida"})
aadd(aMOTIVOS,{"519" ,"Rejeicao: CFOP de saida para NF-e de entrada"})
aadd(aMOTIVOS,{"520" ,"Rejeicao: CFOP de Operacao com Exterior e UF destinatario difere de EX"})
aadd(aMOTIVOS,{"521" ,"Rejeicao: CFOP nao e de Operacao com Exterior e UF destinatario e EX"})
aadd(aMOTIVOS,{"522" ,"Rejeicao: CFOP de Operacao Estadual e UF emitente difere UF destinatario."})
aadd(aMOTIVOS,{"523" ,"Rejeicao: CFOP nao e de Operacao Estadual e UF emitente igual a UF destinatario."})
aadd(aMOTIVOS,{"524" ,"Rejeicao: CFOP de Operacao com Exterior e nao informado NCM"})
aadd(aMOTIVOS,{"525" ,"Rejeicao: CFOP de Importacao e nao informado dados da DI"})
aadd(aMOTIVOS,{"526" ,"Rejeicao: CFOP de Exportacao e nao informado Local de Embarque"})
aadd(aMOTIVOS,{"527" ,"Rejeicao: Operacao de Exportacao com informacao de ICMS incompativel"})
aadd(aMOTIVOS,{"528" ,"Rejeicao: Valor do ICMS difere do produto BC e Aliquota"})
aadd(aMOTIVOS,{"529" ,"Rejeicao: NCM de informacao obrigatoria para produto tributado pelo IPI"})
aadd(aMOTIVOS,{"530" ,"Rejeicao: Operacao com tributacao de ISSQN sem informar a Inscricao Municipal"})
aadd(aMOTIVOS,{"531" ,"Rejeicao: Total da BC ICMS difere do somatorio dos itens"})
aadd(aMOTIVOS,{"532" ,"Rejeicao: Total do ICMS difere do somatorio dos itens"})
aadd(aMOTIVOS,{"533" ,"Rejeicao: Total da BC ICMS-ST difere do somatorio dos itens"})
aadd(aMOTIVOS,{"534" ,"Rejeicao: Total do ICMS-ST difere do somatorio dos itens"})
aadd(aMOTIVOS,{"535" ,"Rejeicao: Total do Frete difere do somatorio dos itens"})
aadd(aMOTIVOS,{"536" ,"Rejeicao: Total do Seguro difere do somatorio dos itens"})
aadd(aMOTIVOS,{"537" ,"Rejeicao: Total do Desconto difere do somatorio dos itens"})
aadd(aMOTIVOS,{"538" ,"Rejeicao: Total do IPI difere do somatorio dos itens"})
aadd(aMOTIVOS,{"539" ,"Rejeicao: Duplicidade de NF-e, com diferenca na Chave de Acesso"})
aadd(aMOTIVOS,{"540" ,"Rejeicao: CPF do Local de Retirada invalido"})
aadd(aMOTIVOS,{"541" ,"Rejeicao: CPF do Local de Entrega invalido"})
aadd(aMOTIVOS,{"542" ,"Rejeicao: CNPJ do Transportador invalido"})
aadd(aMOTIVOS,{"543" ,"Rejeicao: CPF do Transportador invalido"})
aadd(aMOTIVOS,{"544" ,"Rejeicao: IE do Transportador invalida"})
aadd(aMOTIVOS,{"545" ,"Rejeicao: Falha no schema XML a versao informada na versaoDados do SOAPHeader diverge da versao da mensagem"})
aadd(aMOTIVOS,{"546" ,"Rejeicao: Erro na Chave de Acesso - Campo Id falta a literal NFe"})
aadd(aMOTIVOS,{"547" ,"Rejeicao: Digito Verificador da Chave de Acesso da NF-e Referenciada invalido"})
aadd(aMOTIVOS,{"548" ,"Rejeicao: CNPJ da NF referenciada invalido."})
aadd(aMOTIVOS,{"549" ,"Rejeicao: CNPJ da NF referenciada de produtor invalido."})
aadd(aMOTIVOS,{"550" ,"Rejeicao: CPF da NF referenciada de produtor invalido."})
aadd(aMOTIVOS,{"551" ,"Rejeicao: IE da NF referenciada de produtor invalido."})
aadd(aMOTIVOS,{"552" ,"Rejeicao: Digito Verificador da Chave de Acesso do CT-e Referenciado invalido"})
aadd(aMOTIVOS,{"553" ,"Rejeicao: Tipo autorizador do recibo diverge do Órgao Autorizador."})
aadd(aMOTIVOS,{"554" ,"Rejeicao: Serie difere da faixa 0-899"})
aadd(aMOTIVOS,{"555" ,"Rejeicao: Tipo autorizador do protocolo diverge do Orgao Autorizador."})
aadd(aMOTIVOS,{"556" ,"Rejeicao: Justificativa de entrada em contingencia nao deve ser informada para tipo de emissao normal."})
aadd(aMOTIVOS,{"557" ,"Rejeicao: A Justificativa de entrada em contingencia deve ser informada."})
aadd(aMOTIVOS,{"558" ,"Rejeicao: Data de entrada em contingência posterior a data de emissao."})
aadd(aMOTIVOS,{"559" ,"Rejeicao: UF do Transportador nao informada"})
aadd(aMOTIVOS,{"560" ,"Rejeicao: CNPJ base do emitente difere do CNPJ base da primeira NF-e do lote recebido"})
aadd(aMOTIVOS,{"561" ,"Rejeicao: Mes de Emissao informado na Chave de Acesso difere do Mes de Emissao da NFe"})
aadd(aMOTIVOS,{"562" ,"Rejeicao: Codigo Numerico informado na Chave de Acesso difere do Codigo Numerico da NF-e"})
aadd(aMOTIVOS,{"563" ,"Rejeicao: Ja existe pedido de Inutilizacao com a mesma faixa de inutilizacao"})
aadd(aMOTIVOS,{"564" ,"Rejeicao: Total do Produto / Servico difere do somatorio dos itens"})
aadd(aMOTIVOS,{"565" ,"Rejeicao: Falha no schema XML - inexiste a tag raiz esperada para o lote de NF-e"})
aadd(aMOTIVOS,{"567" ,"Rejeicao: Falha no schema XML - versao informada na versaoDados do SOAPHeader diverge da versao do lote de NF-e"})
aadd(aMOTIVOS,{"568" ,"Rejeicao: Falha no schema XML - inexiste atributo versao na tag raiz do lote de NF-e CODIGO MOTIVOS DE DENEGACAO DE USO"})
aadd(aMOTIVOS,{"301" ,"Uso Denegado: Irregularidade fiscal do emitente"})
aadd(aMOTIVOS,{"999" ,"Rejeicao: Erro nao catalogado (informar a mensagem de erro capturado no tratamento da excecao)"})

nTela2 := savescreen(0,0,24,80)

setcolor("B/W")
nbox(5,10,18,70,"W/W+",.t.)

@  6, 11 say padc("EMITINDO NOTA FISCAL ELETRONICA",59)

  ACBrNFe_ENT = "C:\NFE\ENTNFE.TXT"
  ACBrNFe_SAI = "C:\NFE\SAINFE.TXT"
  ACBrNFe_TMP = "C:\NFE\ARQTMP.TXT"
  ACBrNFe_UNI = "C:"

mon_env("Sat.Inicializar")  // vamos ver status
cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

setcolor("N/W*")
keyboard chr(30) + chr(27)
memoedit(cret,07,11,17,69,.f.,,60)

mon_env('Sat.CriarEnviarCfe("C:\CIRUR\NFE\SAT.INI")')
cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

setcolor("N/W*")
keyboard chr(30) + chr(27)
memoedit(cret,07,11,17,69,.f.,,60)

if !"CodigoDeRetorno=6000" $ cRet
  memoedit(cret,07,11,17,69,.f.,,60)
  restscreen(0,0,24,80,nTela2)
  WvtSetBlocks( aLastPaint6 )
  return .f.
endif

N_POS = rat("Arquivo=F:\CIRUR\ENVIADO\SAT\Vendas",cRet)

M_NFSMES = substr(cRet,n_pos+36,6)  // NOME DO XML
M_NOAR   = substr(cRet,n_pos+43,50)  // NOME DO XML
M_NFSID = M_NOAR

if F_OQUE = 3
  if upper(alltrim(netname())) == "CIRUR03"
    nEnv = 'SAT.ImprimirExtratoVenda("' +  substr(cRet,rat("Arquivo=",CRET)+8,85) + '")'
  else
    nEnv = 'SAT.ImprimirExtratoVenda("' +  substr(cRet,rat("Arquivo=",CRET)+8,85) + '")'
  endif
  mon_env(nEnv)
  cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

  setcolor("N/W*")
  keyboard chr(30) + chr(27)
  memoedit(cret,07,11,17,69,.f.,,60)
endif


nEnv = 'SAT.ConsultarStatusOperacional()'
mon_env(nEnv)
cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.

  hanmdf=fopen(ACBrNFe_SAI)

  feof = .f.

  M_ID = ""

  do while .t.
    if feof
      exit
    endif

    M_FRAZE = upper(alltrim(fReadline(hanmdf)))
    if left(M_FRAZE, 11) == "ULTIMO_CFE="
      M_ID = substr(alltrim(M_FRAZE),42,7)
      exit
    endif
  enddo

  fclose(hanmdf)

M_CUPNUM = val(M_ID)

WvtSetBlocks( aLastPaint6 )
restscreen(0,0,24,80,nTela2)

return .t.

****************
function GERAXMLSAT
****************

M_ARQX = "C:\CIRUR\NFE\SAT.INI"

// VAMOS GERAR O XML NA MAQUINA LOCAL
// DEPOIS COPIAMOS

if file("C:\CIRUR\SAT.INI")
  erase("C:\CIRUR\SAT.INI")
endif

set print on
set printer to "C:\CIRUR\SAT.INI"
set console off
set century on



GERAXMLnfce()
return ""

if ME_EMP = 1
  ?? "[infCFe]"
  ? "versao=0.07"
  ? "[Identificacao]"
  ? "CNPJ=01291979000167"
  ? "signAC=jMvqeoT93kzO9neXc8g01iSeTb/fjXZATO4TAPoy1idaDF0U36n7SiEvbPhqVL2+2Nr/y0YTPUbw/mvDIz4/eu2KlRjt9F803EEKAUFn2c1kN+nj9IR1scqKY1Akhw2tdttihfIRON520UQ0uEtxpgKSdyQyMEU2Zb6Ipt5MtfBmLH3ATG8hPA2jzvHRVE75dwqYs+g4RnAj+lwBQNwUGiQKdwRsClGrJLoEhzg2aoJEq0pm36OZS1kw70Ew2oB8HseU65LnVgG66L58Flfr0vsz5TuR7NpGgyMes/9jpGjaG+q7SoI+NgBPZkJfcG44WtrnPYxS5dOuY57tXlsbOg=="
  ? "numeroCaixa=1"
  ? "[Emitente]"
  ? "CNPJ=02715655000171"
  ? "IE=562165596111"
  ? "IM=00300"
else
  ?? "[infCFe]"
  ? "versao=0.08"
  ? "[Identificacao]"
  ? "CNPJ=01291979000167"
  ? "signAC=fiEI5fBaw+rJofUcCnQy3MDk4h3sjqKX7tbz4PDh4+P9gzM1StlPXIB/QHMD5icOs0mgCDFxF6oBjIoaHQZXi74J8scbqlLbeqxe5PiGS9UNhB7TazJ7Ide1IxEIJuOwByLk1UwEAMpelsmmYk2D6HrNe+KTie7wqegWURHwvp4LN/uv+TQAhJONyAwpdMIf4sU4xnXfPOtfcVQ6hVaxV4YpcPiShzXy5s4DatOjjafAypdR22xTWfDTF3yBlPE+4XhKxhX74S7wGSUz3AGj6fDwZwvfomXcNEiyUNkQ+yxSoaY7+4mB+WGCZWBhuQlmEi5l/GeEg0U4I/gWznebcw=="
  ? "numeroCaixa=1"
  ? "[Emitente]"
  ? "CNPJ=27435570000160"
  ? "IE=562404703115"
endif

? "indRatISSQN=S"
? "[Destinatario]"

if len(alltrim(M_CLICGC2)) = 11
  ? "CNPJCPF=" + M_CLICGC2
else
  ? "CNPJCPF=" + right(M_CLICGC2,14)
endif

? "xNome=" + M_CLINOM
? "[Entrega]"
? "xLgr=" + M_CLIEND2
? "nro=."
? "xCpl="
? "xBairro=" + M_CLIBAI2
? "xMun=" + M_CLIMUN2
? "UF=" + M_CLIUF2

nSeq = 1

vTotPis = 0
vTotCof = 0
M_TOTTRI = 0

// 5 VLI
// 6 LIQ

*for R = 1 to len(M_CUPMAT)
*  if M_CUPDSC > 0
*    M_CUPMAT[R,6] = (M_CUPMAT[R,5] - ((M_CUPDSC/M_CUPVLP) * M_CUPMAT[R,5]))
*  else
*    M_CUPMAT[R,6] = M_CUPMAT[R,5]
*  endif
*next

for R = 1 to len(M_CUPMAT)

  ? "[Produto" + strzero(nSeq,3) + "]"

  BUSCAREGISTRO("APCA00",1,{str(M_CUPMAT[R, 2],6,0)},"SELECT")
  BUSCAREGISTRO("ANCM00",1,{APCA00->PCANBM},"SELECT")

  M_TOTTRI += round(((M_CUPMAT[R, 6]/100)*ANCM00->ALIQNAC),2)  // TOTAL TRIBUTOS

  ? "cProd=" + str(M_CUPMAT[R, 2])
  ? "infAdProd="
  ? "EAN=SEM GTIN"
  ? "xProd=" + APCA00->PCADES
  ? "NCM=" + APCA00->PCANBM

  if APCA00->PCATRI = 4
    ? "CFOP=5405"
    M_CUPMAT[R, 7] = "5.405"
  else
    ? "CFOP=5102"
    M_CUPMAT[R, 7] = "5.102"
  endif

  ? "uCom=" + APCA00->PCAUNI
  ? "qCom=" + alltrim(strtran(str(M_CUPMAT[R, 3],8,3),".",","))
  ? "vUnCom=" + alltrim(strtran(str((M_CUPMAT[R, 5]/M_CUPMAT[R, 3]),12,5),".",","))

  M_VDESC = 0 // M_CUPMAT[R,5]-M_CUPMAT[R,6]

  if M_CUPMAT[R,5] > 0 .and. M_CUPMAT[R,6] > 0
    if M_CUPMAT[R,5] > M_CUPMAT[R,6]
      M_VDESC = M_CUPMAT[R,5]-M_CUPMAT[R,6]
    endif
  endif

  ? "vDesc=" + alltrim(strtran(str(M_VDESC,10,2),".",","))
  ? "vOutro=0"

  ? "vProd=" + alltrim(strtran(str(M_CUPMAT[R,5],12,2),".",","))
  if empty(APCA00->PCAUNI)
    ? "uTrib=PC"
  else
    ? "uTrib=" + APCA00->PCAUNI
  endif
  ? "qTrib=" + alltrim(strtran(str(M_CUPMAT[R, 3],12,3),".",","))
  ? "vUnTrib="+ alltrim(strtran(str((M_CUPMAT[R, 5]/M_CUPMAT[R, 3]),12,5),".",","))

  ? "[ICMS" + strzero(nSeq,3) + "]"
  if alltrim(AEMP00->EMPCFE) $ "3" .or. left(AEMP00->EMPECF,1) == "S"  // regime normal
    ? "Orig=0"
    do case
    case APCA00->PCATRI = 1
      M_NFSVICL = round(((M_CUPMAT[R, 5]/100)*APCA00->PCAIC0),2)
      ? "CST=00"
      ? "vBC=" + alltrim(strtran(str(M_CUPMAT[R, 5],6,2),".",","))
      ? "pICMS=" + alltrim(strtran(str(APCA00->PCAIC0,6,2),".",","))
      ? "vICMS=" + alltrim(strtran(str(M_NFSVICL,12,2),".",","))
      M_NFSBIC += M_CUPMAT[R, 5]
      M_NFSVIC += M_NFSVICL
    case APCA00->PCATRI = 2
      ? "CST=40"
      ? "pICMS=0"
    case APCA00->PCATRI = 7
      ? "CST=41"
      ? "pICMS=0"
    case APCA00->PCATRI = 4
      ? "CST=60"
      ? "pICMS=0"
    endcase
  endif

  if alltrim(AEMP00->EMPCFE) $ "12"  // simples nacional
    if M_CUPMAT[R, 7] $ "#6.917#5.411#6.411#5.910#5.929#5.908#"
      ? "CSOSN=400"
    else

    if M_CUPMAT[R, 7] $ "#6.102#6.108#"
      ? "CSOSN=102"
    else
      if M_CUPMAT[R, 7] $ "#5.551#1.202#1.102#2.102#5.102#"
        ? "CSOSN=900"
      else
        if M_CUPMAT[R, 7] $ "#5.405#"
          ? "CSOSN=500"
        else
          if M_CUPMAT[R, 7] $ CSOSN_900
            ? "CSOSN=900"
          else
            ? "CSOSN=0"
          endif
        endif
      endif
    endif
    endif
  else
    ? "CSOSN=0"
  endif

  lPiscof = .f.

  if lPiscof
    vPis = round(((M_CUPMAT[R, 5]/100)*1.65),2)
    vTotPis += vPis

    vCof = round(((M_CUPMAT[R, 5]/100)*7.6),2)
    vTotCof += vCof
  else
    vPis = 0
    vTotPis += vPis

    vCof = 0
    vTotCof += vCof
  endif

  ? "[PIS" + strzero(nSeq,3) + "]"

  if lPiscof
    ? "CST=01"
    ? "vBC=" + alltrim(strtran(str(M_CUPMAT[R, 5],12,2),".",","))
    ? "pPIS=0,0165"
    ? "qBCProd=0"
    ? "vAliqProd=0"
    ? "vPIS=" + alltrim(strtran(str(vPis,12,2),".",","))

    ? "[COFINS" + strzero(nSeq,3) + "]"
    ? "CST=01"
    ? "vBC=" + alltrim(strtran(str(M_CUPMAT[R, 5],12,2),".",","))
    ? "pCOFINS=0,076"
    ? "qBCProd=0"
    ? "vAliqProd=0"
    ? "vCOFINS=" + alltrim(strtran(str(vCof,12,2),".",","))
  else
    ? "CST=49"
    ? "vBC=" + alltrim(strtran(str(0,12,2),".",","))
    ? "pPIS=0"
    ? "qBCProd=0"
    ? "vAliqProd=0"
    ? "vPIS=" + alltrim(strtran(str(0,12,2),".",","))

    ? "[COFINS" + strzero(nSeq,3) + "]"
    ? "CST=49"
    ? "vBC=" + alltrim(strtran(str(0,12,2),".",","))
    ? "pCOFINS=0"
    ? "qBCProd=0"
    ? "vAliqProd=0"
    ? "vCOFINS=" + alltrim(strtran(str(0,12,2),".",","))
  endif

  nSeq ++
next

*01 - Dinheiro
*02 - Cheque
*03 - Carto de Crdito
*04 - Carto de Dbito
*05 - Crdito Loja
*10 - Vale Alimenao
*11 - Vale Refeio
*12 - Vale Presente
*13 - Vale Combustvel
*99 - Outros

? "[Total]"
? "vBC=" 			+ alltrim(strtran(str(M_NFSBIC,12,2),".",","))
? "vICMS=" 			+ alltrim(strtran(str(M_NFSVIC,12,2),".",","))
? "vICMSDeson=0"
? "vBCST=0"
? "vST=0"


? "vProd="  		+ alltrim(strtran(str(M_CUPVLN,12,2),".",","))
? "vFrete=" 		+ alltrim(strtran(str(0,12,2),".",","))
? "vSeg=0" 	//	+ alltrim(strtran(str(NFSSEG,12,2),".",","))
? "vDesc=" 		+ alltrim(strtran(str(M_CUPDSC,12,2),".",","))
? "vIPI=" 			+ alltrim(strtran(str(0,12,2),".",","))
? "vPIS="			+ alltrim(strtran(str(vTotPis,12,2),".",","))
? "vCOFINS="		+ alltrim(strtran(str(vTotCof,12,2),".",","))
? "ValorNota=" 			+ alltrim(strtran(str(M_CUPVLP,12,2),".",","))


? "[Transportador]"
? "modFrete=9"

? "[PAG001]"
? "tPag=0" + M_CUPCPG
? "indPag=0"
if M_CUPVLN > 0
  ? "vPag=" + alltrim(strtran(str(M_CUPVLN,12,2),".",","))
else
  ? "vPag=" + alltrim(strtran(str(M_CUPVLP,12,2),".",","))
endif


? "[DadosAdicionais]"
? "Fisco="
? "Complemento="
?? "Fone: " + alltrim(M_CLITEL3)
if empty(M_CLICGC2)
   ?? ";" + M_CLINOM
   ?? ";" + M_CLIEND2
   ?? ";" + M_CLIBAI2
   ?? ";" + M_CLIMUN2 + " - " + M_CLIUF2
endif

set printer to
set print off
set console on

set century off

Filecopy("C:\CIRUR\SAT.INI","C:\CIRUR\NFE\SAT.INI")           // Copy the file

return .t.

****************
function GERAXMLNFCE
****************

M_ARQX = "C:\CIRUR\NFE\SAT.INI"

// VAMOS GERAR O XML NA MAQUINA LOCAL
// DEPOIS COPIAMOS

if file("C:\CIRUR\SAT.INI")
  erase("C:\CIRUR\SAT.INI")
endif

set print on
set printer to "C:\CIRUR\SAT.INI"
set console off
set century on


*juridico
*CIRUR
*000001
*b478a6cb-a59a-4214-9479-b2abcd7cf8b4

*Nutr
*000001
*c8a53126-d7fb-4e16-a8fd-3b2ce48d9fcb

*teste
*CIRUR
* 2bf9054b-e945-4beb-a8b9-9a71463581bd
* 000001

*NUTRI
*000001
* 3e1f3a65-7e2c-425d-b3b5-e8363c63ca73

*/*/*/

  M_CUPNUM = AEMP00->EMPCUP

  do while .t.
    if BUSCAREGISTRO("ACUP00",1,{str(M_CUPEMP, 2, 0),str(M_CUPNUM, 6, 0),aspas(M_CUPSER)},"SELECT")
      M_CUPNUM ++
      loop
    endif
    exit
    // SAT JA GRAVADO
  enddo

  ?? "[infNFE]"
  ? "versao=4.0"
  ? "[Identificacao]"
  ? "natOp=Venda de Mercadoria"
  ? "indPag=0"
  ? "mod=65"
  ? "serie=1"
  ? "nNF=" + alltrim(str(M_CUPNUM,6))
  ? "tpNF=1"
  ? "Finalidade=0"
  ? "Emissao=" + dtoc(date())
  ?? " " + time()
  ? "Saida=" + dtoc(date())
  ?? " " + time()

   if M_CLIDCC == 1  // contribuinte ICMS
     ? "idDest=1"  // OPERACAO INTERNA 2-INTERESTADUAL
   else
     if ESTADO == "SP"
       ? "idDest=1"
     else
       ? "idDest=2"
     endif
   endif

  ? "indFinal=1"
  ? "indPres=1"
  ? "tpimp=4"
  
  if !lNFEprod
    ? "tpAmb=2"
  else
    ? "tpAmb=1"
  endif

  ? "[Emitente]"
  ? "CRT=" + alltrim(AEMP00->EMPCFE)  // REGIME NORMAL
  ? "CNPJ=" + right(AEMP00->EMPCGC,14)
  ? "Razao=" + AEMP00->EMPNOM
  ? "IE=" + AEMP00->EMPIES
  ? "Fantasia=" + AEMP00->EMPFAN
  ? "Fone=" + tira_pto(AEMP00->EMPTEL)
  ? "CEP=" + strzero(AEMP00->EMPCEP,5) + strzero(AEMP00->EMPCCE,3)
  ? "Logradouro=" + "AV MANOEL GOULART"
  if ME_EMP = 10
    ? "Numero=587/587 A"
  else
    ? "Numero=595"
  endif
  ? "Complemento="
  ? "Bairro=" + AEMP00->EMPBAI
  ? "CidadeCod=3541406"
  ? "Cidade=PRESIDENTE PRUDENTE"
  ? "UF=SP"

? "[Destinatario]"
? "IndIEDest=9"
? "IE="

if len(alltrim(M_CLICGC2)) = 11
  ? "CNPJCPF=" + M_CLICGC2
else
  ? "CNPJCPF=" + right(M_CLICGC2,14)
endif
? "xNome=" + M_CLINOM

*? "[Entrega]"
? "xLgr=" + M_CLIEND2
? "nro=."
? "xCpl="
? "cMun=" + str(M_CLICDM2,7)

? "xBairro=" + M_CLIBAI2
? "xMun=" + M_CLIMUN2
? "UF=" + M_CLIUF2
? "Fone=" + M_CLITEL3
nSeq = 1

vTotPis = 0
vTotCof = 0
M_TOTTRI = 0

// 5 VLI
// 6 LIQ

*for R = 1 to len(M_CUPMAT)
*  if M_CUPDSC > 0
*    M_CUPMAT[R,6] = (M_CUPMAT[R,5] - ((M_CUPDSC/M_CUPVLP) * M_CUPMAT[R,5]))
*  else
*    M_CUPMAT[R,6] = M_CUPMAT[R,5]
*  endif
*next

M_NFSBIC = 0
M_NFSVIC = 0

for R = 1 to len(M_CUPMAT)

  ? "[Produto" + strzero(nSeq,3) + "]"

  BUSCAREGISTRO("APCA00",1,{str(M_CUPMAT[R, 2],6,0)},"SELECT")
  BUSCAREGISTRO("ANCM00",1,{APCA00->PCANBM},"SELECT")

  M_TOTTRI += round(((M_CUPMAT[R, 6]/100)*ANCM00->ALIQNAC),2)  // TOTAL TRIBUTOS

  ? "cProd=" + str(M_CUPMAT[R, 2])
  ? "infAdProd="
  ? "EAN=SEM GTIN"
  ? "xProd=" + APCA00->PCADES
  ? "NCM=" + APCA00->PCANBM

  if APCA00->PCATRI = 4
    ? "CFOP=5405"
    M_CUPMAT[R, 7] = "5.405"
  else
    ? "CFOP=5102"
    M_CUPMAT[R, 7] = "5.102"
  endif

  ? "uCom=" + APCA00->PCAUNI

  ? "qCom=" + alltrim(strtran(str(M_CUPMAT[R, 3],8,3),".",","))
  ? "vUnCom=" + alltrim(strtran(str((M_CUPMAT[R, 5]/M_CUPMAT[R, 3]),12,5),".",","))

  M_VDESC = 0 // M_CUPMAT[R,5]-M_CUPMAT[R,6]

  if M_CUPMAT[R,5] > 0 .and. M_CUPMAT[R,6] > 0
    if M_CUPMAT[R,5] > M_CUPMAT[R,6]
      M_VDESC = M_CUPMAT[R,5]-M_CUPMAT[R,6]
    endif
  endif

  ? "vDesc=" + alltrim(strtran(str(M_VDESC,10,2),".",","))
  ? "vOutro=0"
  ? "vProd=" + alltrim(strtran(str(M_CUPMAT[R,5],12,2),".",","))
  if empty(APCA00->PCAUNI)
    ? "uTrib=PC"
  else
    ? "uTrib=" + APCA00->PCAUNI
  endif
  ? "qTrib=" + alltrim(strtran(str(M_CUPMAT[R, 3],12,3),".",","))
  ? "vUnTrib="+ alltrim(strtran(str((M_CUPMAT[R, 5]/M_CUPMAT[R, 3]),12,5),".",","))

*  ? "vItem12741=" + alltrim(strtran(str(round(((M_CUPMAT[R, 5]/100)*ANCM00->ALIQNAC),2),10,2),".",","))

*  ? "[ObsFiscoDet001001]"
*  ? "xCampoDet="
*  ? "xTextoDet="

  ? "[ICMS" + strzero(nSeq,3) + "]"

  if alltrim(AEMP00->EMPCFE) $ "3" .or. left(AEMP00->EMPECF,1) == "S"  // regime normal
    ? "Orig=0"
    do case
    case APCA00->PCATRI = 1
      M_NFSVICL = round(((M_CUPMAT[R, 5]/100)*APCA00->PCAIC0),2)
      ? "CST=00"
      ? "vBC=" + alltrim(strtran(str(M_CUPMAT[R, 5],6,2),".",","))
      ? "pICMS=" + alltrim(strtran(str(APCA00->PCAIC0,6,2),".",","))
      ? "vICMS=" + alltrim(strtran(str(M_NFSVICL,12,2),".",","))
      M_NFSBIC += M_CUPMAT[R, 5]
      M_NFSVIC += M_NFSVICL
    case APCA00->PCATRI = 2
      ? "CST=40"
      ? "pICMS=0"
    case APCA00->PCATRI = 7
      ? "CST=41"
      ? "pICMS=0"
    case APCA00->PCATRI = 4
      ? "CST=60"
      ? "pICMS=0"
    endcase
  endif

  if alltrim(AEMP00->EMPCFE) $ "12"  // simples nacional
    if M_CUPMAT[R, 7] $ "#5.411#6.411#5.910#5.929#5.908#"
      ? "CSOSN=400"
    else

    if M_CUPMAT[R, 7] $ "#6.102#6.108#"
      ? "CSOSN=202"
    else
      if M_CUPMAT[R, 7] $ "#5.551#1.202#1.102#2.102#5.102#"
        ? "CSOSN=900"
      else
        if M_CUPMAT[R, 7] $ "#5.405#"
          ? "CSOSN=500"
        else
          if M_CUPMAT[R, 7] $ CSOSN_900
            ? "CSOSN=900"
          else
            ? "CSOSN=0"
          endif
        endif
      endif
    endif
    endif
  else
    ? "CSOSN=0"
  endif


  lPiscof = .f.

  if lPiscof
    vPis = round(((M_CUPMAT[R, 5]/100)*1.65),2)
    vTotPis += vPis

    vCof = round(((M_CUPMAT[R, 5]/100)*7.6),2)
    vTotCof += vCof
  else
    vPis = 0
    vTotPis += vPis

    vCof = 0
    vTotCof += vCof
  endif

  ? "[PIS" + strzero(nSeq,3) + "]"

  if lPiscof
    ? "CST=01"
    ? "vBC=" + alltrim(strtran(str(M_CUPMAT[R, 5],12,2),".",","))
    ? "pPIS=0,0165"
    ? "qBCProd=0"
    ? "vAliqProd=0"
    ? "vPIS=" + alltrim(strtran(str(vPis,12,2),".",","))

    ? "[COFINS" + strzero(nSeq,3) + "]"
    ? "CST=01"
    ? "vBC=" + alltrim(strtran(str(M_CUPMAT[R, 5],12,2),".",","))
    ? "pCOFINS=0,076"
    ? "qBCProd=0"
    ? "vAliqProd=0"
    ? "vCOFINS=" + alltrim(strtran(str(vCof,12,2),".",","))
  else
    ? "CST=49"
    ? "vBC=" + alltrim(strtran(str(0,12,2),".",","))
    ? "pPIS=0"
    ? "qBCProd=0"
    ? "vAliqProd=0"
    ? "vPIS=" + alltrim(strtran(str(0,12,2),".",","))

    ? "[COFINS" + strzero(nSeq,3) + "]"
    ? "CST=49"
    ? "vBC=" + alltrim(strtran(str(0,12,2),".",","))
    ? "pCOFINS=0"
    ? "qBCProd=0"
    ? "vAliqProd=0"
    ? "vCOFINS=" + alltrim(strtran(str(0,12,2),".",","))
  endif

  nSeq ++
next

*01 - Dinheiro
*02 - Cheque
*03 - Carto de Crdito
*04 - Carto de Dbito
*05 - Crdito Loja
*10 - Vale Alimenao
*11 - Vale Refeio
*12 - Vale Presente
*13 - Vale Combustvel
*99 - Outros

? "[Total]"
? "vBC=" 			+ alltrim(strtran(str(M_NFSBIC,12,2),".",","))
? "vICMS=" 			+ alltrim(strtran(str(M_NFSVIC,12,2),".",","))
? "vICMSDeson=0"
? "vBCST=0"
? "vST=0"


? "vProd="  		+ alltrim(strtran(str(M_CUPVLN,12,2),".",","))
? "vFrete=" 		+ alltrim(strtran(str(0,12,2),".",","))
? "vSeg=0" 	//	+ alltrim(strtran(str(NFSSEG,12,2),".",","))
? "vDesc=" 		+ alltrim(strtran(str(M_CUPDSC,12,2),".",","))
? "vIPI=" 			+ alltrim(strtran(str(0,12,2),".",","))
? "vPIS="			+ alltrim(strtran(str(vTotPis,12,2),".",","))
? "vCOFINS="		+ alltrim(strtran(str(vTotCof,12,2),".",","))
? "ValorNota=" 			+ alltrim(strtran(str(M_CUPVLP,12,2),".",","))


? "[Transportador]"
? "modFrete=9"


*tPag (01=Dinheiro  02=Cheque  03=Carto de Crdito  04=Carto de Dbito  05=Crdito Loja  10=Vale Alimenta;o  11=Vale Refei;o  12=Vale Presente  13=Vale Combustvel 99=Outros)
*  aadd(M_TIPOS,"1-Dinheiro      ")
*  aadd(M_TIPOS,"2-Cheque        ")
*  aadd(M_TIPOS,"3-Cartao Credito")
*  aadd(M_TIPOS,"4-Cartao Debito ")



? "[PAG001]"
? "tPag=0" + M_CUPCPG
? "indPag=0"
if M_CUPVLN > 0
  ? "vPag=" + alltrim(strtran(str(M_CUPVLN,12,2),".",","))
else
  ? "vPag=" + alltrim(strtran(str(M_CUPVLP,12,2),".",","))
endif


? "[DadosAdicionais]"
? "Fisco="
? "Complemento="
?? "Fone: " + alltrim(M_CLITEL3)
if empty(M_CLICGC2)
   ?? ";" + M_CLINOM
   ?? ";" + M_CLIEND2
   ?? ";" + M_CLIBAI2
   ?? ";" + M_CLIMUN2 + " - " + M_CLIUF2
endif



set printer to
set print off
set console on

set century off

Filecopy("C:\CIRUR\SAT.INI","C:\CIRUR\NFE\SAT.INI")           // Copy the file

return .t.



*****************
function XMLNFCE(F_OQUE)
*****************

local cRet := ""
local nBuffSize := 16                   // Read/write buffer size
local l7143Supp := .F.                  // Is function 7143h supported?
lOCAL aBlocks2 := {}

aLastPaint6 := WvtSetBlocks( aBlocks2 )

aMOTIVOS = { }

aadd(aMOTIVOS,{"100" ,"Autorizado o uso da NF-e"})
aadd(aMOTIVOS,{"101" ,"Cancelamento de NF-e homologado"})
aadd(aMOTIVOS,{"102" ,"Inutilizacao de numero homologado"})
aadd(aMOTIVOS,{"103" ,"Lote recebido com sucesso"})
aadd(aMOTIVOS,{"104" ,"Lote processado"})
aadd(aMOTIVOS,{"105" ,"Lote em processamento"})
aadd(aMOTIVOS,{"106" ,"Lote nao localizado"})
aadd(aMOTIVOS,{"107" ,"Serviço em Operacao"})
aadd(aMOTIVOS,{"108" ,"Servico Paralisado Momentaneamente (curto prazo)"})
aadd(aMOTIVOS,{"109" ,"Servico Paralisado sem Previsao"})
aadd(aMOTIVOS,{"110" ,"Uso Denegado"})
aadd(aMOTIVOS,{"111" ,"Consulta cadastro com uma ocorrencia"})
aadd(aMOTIVOS,{"112" ,"Consulta cadastro com mais de uma ocorrencia"})

aadd(aMOTIVOS,{"201" ,"Rejeicao: O numero maximo de numeracao de NF-e a inutilizar ultrapassou o limite"})
aadd(aMOTIVOS,{"202" ,"Rejeicao: Falha no reconhecimento da autoria ou integridade do arquivo digital"})
aadd(aMOTIVOS,{"203" ,"Rejeicao: Emissor nao habilitado para emissao da NF-e"})
aadd(aMOTIVOS,{"204" ,"Rejeicao: Duplicidade de NF-e"})
aadd(aMOTIVOS,{"205" ,"Rejeicao: NF-e esta denegada na base de dados da SEFAZ"})
aadd(aMOTIVOS,{"206" ,"Rejeicao: NF-e ja esta inutilizada na Base de dados da SEFAZ"})
aadd(aMOTIVOS,{"207" ,"Rejeicao: CNPJ do emitente invalido"})
aadd(aMOTIVOS,{"208" ,"Rejeicao: CNPJ do destinatario invalido"})
aadd(aMOTIVOS,{"209" ,"Rejeicao: IE do emitente invalida"})
aadd(aMOTIVOS,{"210" ,"Rejeicao: IE do destinatario invalida"})
aadd(aMOTIVOS,{"211" ,"Rejeicao: IE do substituto invalida"})
aadd(aMOTIVOS,{"212" ,"Rejeicao: Data de emissao NF-e posterior a data de recebimento"})
aadd(aMOTIVOS,{"213" ,"Rejeicao: CNPJ-Base do Emitente difere do CNPJ-Base do Certificado Digital"})
aadd(aMOTIVOS,{"214" ,"Rejeicao: Tamanho da mensagem excedeu o limite estabelecido"})
aadd(aMOTIVOS,{"215" ,"Rejeicao: Falha no schema XML"})
aadd(aMOTIVOS,{"216" ,"Rejeicao: Chave de Acesso difere da cadastrada"})
aadd(aMOTIVOS,{"217" ,"Rejeicao: NF-e não consta na base de dados da SEFAZ"})
aadd(aMOTIVOS,{"218" ,"Rejeicao: NF-e ja esta cancelada na base de dados da SEFAZ"})
aadd(aMOTIVOS,{"219" ,"Rejeicao: Circulacao da NF-e verificada"})
aadd(aMOTIVOS,{"220" ,"Rejeicao: NF-e autorizada ha mais de 7 dias (168 horas)"})
aadd(aMOTIVOS,{"221" ,"Rejeicao: Confirmado o recebimento da NF-e pelo destinatario"})
aadd(aMOTIVOS,{"222" ,"Rejeicao: Protocolo de Autorizacao de Uso difere do cadastrado"})
aadd(aMOTIVOS,{"223" ,"Rejeicao: CNPJ do transmissor do lote difere do CNPJ do transmissor da consulta"})
aadd(aMOTIVOS,{"224" ,"Rejeicao: A faixa inicial eh maior que a faixa final"})
aadd(aMOTIVOS,{"225" ,"Rejeicao: Falha no Schema XML do lote de NFe"})
aadd(aMOTIVOS,{"226" ,"Rejeicao: Codigo da UF do Emitente diverge da UF autorizadora"})
aadd(aMOTIVOS,{"227" ,"Rejeicao: Erro na Chave de Acesso - Campo Id – falta a literal NFe"})
aadd(aMOTIVOS,{"228" ,"Rejeicao: Data de Emissao muito atrasada"})
aadd(aMOTIVOS,{"229" ,"Rejeicao: IE do emitente nao informada"})
aadd(aMOTIVOS,{"230" ,"Rejeicao: IE do emitente nao cadastrada"})
aadd(aMOTIVOS,{"231" ,"Rejeicao: IE do emitente nao vinculada ao CNPJ"})
aadd(aMOTIVOS,{"232" ,"Rejeicao: IE do destinatario nao informada"})
aadd(aMOTIVOS,{"233" ,"Rejeicao: IE do destinatario nao cadastrada"})
aadd(aMOTIVOS,{"234" ,"Rejeicao: IE do destinatario nao vinculada ao CNPJ"})
aadd(aMOTIVOS,{"235" ,"Rejeicao: Inscricao SUFRAMA invalida"})
aadd(aMOTIVOS,{"236" ,"Rejeicao: Chave de Acesso com digito verificador invalido"})
aadd(aMOTIVOS,{"237" ,"Rejeicao: CPF do destinatario invalido"})
aadd(aMOTIVOS,{"238" ,"Rejeicao: Cabecalho - Versao do arquivo XML superior a Versao vigente"})
aadd(aMOTIVOS,{"239" ,"Rejeicao: Cabecalho - Versao do arquivo XML nao suportada"})
aadd(aMOTIVOS,{"240" ,"Rejeicao: Cancelamento/Inutilizacao - Irregularidade Fiscal do Emitente"})
aadd(aMOTIVOS,{"241" ,"Rejeicao: Um numero da faixa ja foi utilizado"})
aadd(aMOTIVOS,{"242" ,"Rejeicao: Cabecalho - Falha no Schema XML"})
aadd(aMOTIVOS,{"243" ,"Rejeicao: XML Mal Formado"})
aadd(aMOTIVOS,{"244" ,"Rejeicao: CNPJ do Certificado Digital difere do CNPJ da Matriz e do CNPJ do Emitente"})
aadd(aMOTIVOS,{"245" ,"Rejeicao: CNPJ Emitente nao cadastrado"})
aadd(aMOTIVOS,{"246" ,"Rejeicao: CNPJ Destinatario nao cadastrado"})
aadd(aMOTIVOS,{"247" ,"Rejeicao: Sigla da UF do Emitente diverge da UF autorizadora"})
aadd(aMOTIVOS,{"248" ,"Rejeicao: UF do Recibo diverge da UF autorizadora"})
aadd(aMOTIVOS,{"249" ,"Rejeicao: UF da Chave de Acesso diverge da UF autorizadora"})
aadd(aMOTIVOS,{"250" ,"Rejeicao: UF diverge da UF autorizadora"})
aadd(aMOTIVOS,{"251" ,"Rejeicao: UF/Municipio destinatario nao pertence a SUFRAMA"})
aadd(aMOTIVOS,{"252" ,"Rejeicao: Ambiente informado diverge do Ambiente de recebimento"})
aadd(aMOTIVOS,{"253" ,"Rejeicao: Digito Verificador da chave de acesso composta invalida"})
aadd(aMOTIVOS,{"254" ,"Rejeicao: NF-e complementar nao possui NF referenciada"})
aadd(aMOTIVOS,{"255" ,"Rejeicao: NF-e complementar possui mais de uma NF referenciada"})
aadd(aMOTIVOS,{"256" ,"Rejeicao: Uma NF-e da faixa ja esta inutilizada na Base de dados da SEFAZ"})
aadd(aMOTIVOS,{"257" ,"Rejeicao: Solicitante nao habilitado para emissao da NF-e"})
aadd(aMOTIVOS,{"258" ,"Rejeicao: CNPJ da consulta invalido"})
aadd(aMOTIVOS,{"259" ,"Rejeicao: CNPJ da consulta nao cadastrado como contribuinte na UF"})
aadd(aMOTIVOS,{"260" ,"Rejeicao: IE da consulta invalida"})
aadd(aMOTIVOS,{"261" ,"Rejeicao: IE da consulta nao cadastrada como contribuinte na UF"})
aadd(aMOTIVOS,{"262" ,"Rejeicao: UF nao fornece consulta por CPF"})
aadd(aMOTIVOS,{"263" ,"Rejeicao: CPF da consulta invalido"})
aadd(aMOTIVOS,{"264" ,"Rejeicao: CPF da consulta nao cadastrado como contribuinte na UF"})
aadd(aMOTIVOS,{"265" ,"Rejeicao: Sigla da UF da consulta difere da UF do Web Service"})
aadd(aMOTIVOS,{"266" ,"Rejeicao: Serie utilizada nao permitida no Web Service"})
aadd(aMOTIVOS,{"267" ,"Rejeicao: NF Complementar referencia uma NF-e inexistente"})
aadd(aMOTIVOS,{"268" ,"Rejeicao: NF Complementar referencia uma outra NF-e Complementar"})
aadd(aMOTIVOS,{"269" ,"Rejeicao: CNPJ Emitente da NF Complementar difere do CNPJ da NF Referenciada"})
aadd(aMOTIVOS,{"270" ,"Rejeicao: Codigo Municipio do Fato Gerador: digito invalido"})
aadd(aMOTIVOS,{"271" ,"Rejeicao: Codigo Municipio do Fato Gerador: difere da UF do emitente"})
aadd(aMOTIVOS,{"272" ,"Rejeicao: Codigo Municipio do Emitente: digito invalido"})
aadd(aMOTIVOS,{"273" ,"Rejeicao: Codigo Municipio do Emitente: difere da UF do emitente"})
aadd(aMOTIVOS,{"274" ,"Rejeicao: Codigo Municipio do Destinatario: digito invalido"})
aadd(aMOTIVOS,{"275" ,"Rejeicao: Codigo Municipio do Destinatario: difere da UF do Destinatario"})
aadd(aMOTIVOS,{"276" ,"Rejeicao: Codigo Municipio do Local de Retirada: digito invalido"})
aadd(aMOTIVOS,{"277" ,"Rejeicao: Codigo Municipio do Local de Retirada: difere da UF do Local de Retirada"})
aadd(aMOTIVOS,{"278" ,"Rejeicao: Codigo Municipio do Local de Entrega: digito invalido"})
aadd(aMOTIVOS,{"279" ,"Rejeicao: Codigo Municipio do Local de Entrega: difere da UF do Local de Entrega"})
aadd(aMOTIVOS,{"280" ,"Rejeicao: Certificado Transmissor invalido"})
aadd(aMOTIVOS,{"281" ,"Rejeicao: Certificado Transmissor Data Validade"})
aadd(aMOTIVOS,{"282" ,"Rejeicao: Certificado Transmissor sem CNPJ"})
aadd(aMOTIVOS,{"283" ,"Rejeicao: Certificado Transmissor - erro Cadeia de Certificacao"})
aadd(aMOTIVOS,{"284" ,"Rejeicao: Certificado Transmissor revogado"})
aadd(aMOTIVOS,{"285" ,"Rejeicao: Certificado Transmissor difere ICP-Brasil"})
aadd(aMOTIVOS,{"286" ,"Rejeicao: Certificado Transmissor erro no acesso a LCR"})
aadd(aMOTIVOS,{"287" ,"Rejeicao: Codigo Municipio do FG - ISSQN: digito invalido"})
aadd(aMOTIVOS,{"288" ,"Rejeicao: Codigo Municipio do FG - Transporte: digito invalido"})
aadd(aMOTIVOS,{"289" ,"Rejeicao: Codigo da UF informada diverge da UF solicitada"})
aadd(aMOTIVOS,{"290" ,"Rejeicao: Certificado Assinatura invalido"})
aadd(aMOTIVOS,{"291" ,"Rejeicao: Certificado Assinatura Data Validade"})
aadd(aMOTIVOS,{"292" ,"Rejeicao: Certificado Assinatura sem CNPJ"})
aadd(aMOTIVOS,{"293" ,"Rejeicao: Certificado Assinatura - erro Cadeia de Certificacao"})
aadd(aMOTIVOS,{"294" ,"Rejeicao: Certificado Assinatura revogado"})
aadd(aMOTIVOS,{"295" ,"Rejeicao: Certificado Assinatura difere ICP-Brasil"})
aadd(aMOTIVOS,{"296" ,"Rejeicao: Certificado Assinatura erro no acesso a LCR"})
aadd(aMOTIVOS,{"297" ,"Rejeicao: Assinatura difere do calculado"})
aadd(aMOTIVOS,{"298" ,"Rejeicao: Assinatura difere do padrão do Projeto"})
aadd(aMOTIVOS,{"299" ,"Rejeicao: XML da area de cabecalho com codificacao diferente de UTF-8"})
aadd(aMOTIVOS,{"401" ,"Rejeicao: CPF do remetente invalido"})
aadd(aMOTIVOS,{"402" ,"Rejeicao: XML da area de dados com codificacao diferente de UTF-8"})
aadd(aMOTIVOS,{"403" ,"Rejeicao: O grupo de informacoes da NF-e avulsa e de uso exclusivo do Fisco"})
aadd(aMOTIVOS,{"404" ,"Rejeicao: Uso de prefixo de namespace nao permitido"})
aadd(aMOTIVOS,{"405" ,"Rejeicao: Codigo do pais do emitente: digito invalido"})
aadd(aMOTIVOS,{"406" ,"Rejeicao: Codigo do pais do destinatario: digito invalido"})
aadd(aMOTIVOS,{"407" ,"Rejeicao: O CPF so pode ser informado no campo emitente para a NF-e avulsa"})
aadd(aMOTIVOS,{"409" ,"Rejeicao: Campo cUF inexistente no elemento nfeCabecMsg do SOAP Header"})
aadd(aMOTIVOS,{"410" ,"Rejeicao: UF informada no campo cUF nao e atendida pelo Web Service"})
aadd(aMOTIVOS,{"411" ,"Rejeicao: Campo versaoDados inexistente no elemento nfeCabecMsg do SOAP Header"})
aadd(aMOTIVOS,{"420" ,"Rejeicao: Cancelamento para NF-e ja cancelada"})
aadd(aMOTIVOS,{"450" ,"Rejeicao: Modelo da NF-e diferente de 55"})
aadd(aMOTIVOS,{"451" ,"Rejeicao: Processo de emissao informado invalido"})
aadd(aMOTIVOS,{"452" ,"Rejeicao: Tipo Autorizador do Recibo diverge do Orgao Autorizador"})
aadd(aMOTIVOS,{"453" ,"Rejeicao: Ano de inutilizacao nao pode ser superior ao Ano atual"})
aadd(aMOTIVOS,{"454" ,"Rejeicao: Ano de inutilizacao nao pode ser inferior a 2006"})
aadd(aMOTIVOS,{"478" ,"Rejeicao: Local da entrega nao informado para faturamento direto de veiculos novos"})
aadd(aMOTIVOS,{"502" ,"Rejeicao: Erro na Chave de Acesso - Campo Id nao corresponde a concatenacao dos campos correspondentes"})
aadd(aMOTIVOS,{"503" ,"Rejeicao: Serie utilizada fora da faixa permitida no SCAN (900-999)"})
aadd(aMOTIVOS,{"504" ,"Rejeicao: Data de Entrada/Saida posterior ao permitido"})
aadd(aMOTIVOS,{"505" ,"Rejeicao: Data de Entrada/Saida anterior ao permitido"})
aadd(aMOTIVOS,{"506" ,"Rejeicao: Data de Saida menor que a Data de Emissao"})
aadd(aMOTIVOS,{"507" ,"Rejeicao: O CNPJ do destinatario/remetente nao deve ser informado em operacao com o"})
aadd(aMOTIVOS,{"510" ,"Rejeicao: Operacao com Exterior e Codigo Pais destinatario e 1058 (Brasil) ou nao informado"})
aadd(aMOTIVOS,{"511" ,"Rejeicao: Nao e de Operacao com Exterior e Codigo Pais destinatario difere de 1058 (Brasil)"})
aadd(aMOTIVOS,{"512" ,"Rejeicao: CNPJ do Local de Retirada invalido"})
aadd(aMOTIVOS,{"513" ,"Rejeicao: Codigo Municipio do Local de Retirada deve ser 9999999 para UF retirada = EX"})
aadd(aMOTIVOS,{"514" ,"Rejeicao: CNPJ do Local de Entrega invalido"})
aadd(aMOTIVOS,{"515" ,"Rejeicao: Codigo Municipio do Local de Entrega deve ser 9999999 para UF entrega = EX"})
aadd(aMOTIVOS,{"516" ,"Rejeicao: Falha no schema XML e inexiste a tag raiz esperada para a mensagem"})
aadd(aMOTIVOS,{"517" ,"Rejeicao: Falha no schema XML e inexiste atributo versao na tag raiz da mensagem"})
aadd(aMOTIVOS,{"518" ,"Rejeicao: CFOP de entrada para NF-e de saida"})
aadd(aMOTIVOS,{"519" ,"Rejeicao: CFOP de saida para NF-e de entrada"})
aadd(aMOTIVOS,{"520" ,"Rejeicao: CFOP de Operacao com Exterior e UF destinatario difere de EX"})
aadd(aMOTIVOS,{"521" ,"Rejeicao: CFOP nao e de Operacao com Exterior e UF destinatario e EX"})
aadd(aMOTIVOS,{"522" ,"Rejeicao: CFOP de Operacao Estadual e UF emitente difere UF destinatario."})
aadd(aMOTIVOS,{"523" ,"Rejeicao: CFOP nao e de Operacao Estadual e UF emitente igual a UF destinatario."})
aadd(aMOTIVOS,{"524" ,"Rejeicao: CFOP de Operacao com Exterior e nao informado NCM"})
aadd(aMOTIVOS,{"525" ,"Rejeicao: CFOP de Importacao e nao informado dados da DI"})
aadd(aMOTIVOS,{"526" ,"Rejeicao: CFOP de Exportacao e nao informado Local de Embarque"})
aadd(aMOTIVOS,{"527" ,"Rejeicao: Operacao de Exportacao com informacao de ICMS incompativel"})
aadd(aMOTIVOS,{"528" ,"Rejeicao: Valor do ICMS difere do produto BC e Aliquota"})
aadd(aMOTIVOS,{"529" ,"Rejeicao: NCM de informacao obrigatoria para produto tributado pelo IPI"})
aadd(aMOTIVOS,{"530" ,"Rejeicao: Operacao com tributacao de ISSQN sem informar a Inscricao Municipal"})
aadd(aMOTIVOS,{"531" ,"Rejeicao: Total da BC ICMS difere do somatorio dos itens"})
aadd(aMOTIVOS,{"532" ,"Rejeicao: Total do ICMS difere do somatorio dos itens"})
aadd(aMOTIVOS,{"533" ,"Rejeicao: Total da BC ICMS-ST difere do somatorio dos itens"})
aadd(aMOTIVOS,{"534" ,"Rejeicao: Total do ICMS-ST difere do somatorio dos itens"})
aadd(aMOTIVOS,{"535" ,"Rejeicao: Total do Frete difere do somatorio dos itens"})
aadd(aMOTIVOS,{"536" ,"Rejeicao: Total do Seguro difere do somatorio dos itens"})
aadd(aMOTIVOS,{"537" ,"Rejeicao: Total do Desconto difere do somatorio dos itens"})
aadd(aMOTIVOS,{"538" ,"Rejeicao: Total do IPI difere do somatorio dos itens"})
aadd(aMOTIVOS,{"539" ,"Rejeicao: Duplicidade de NF-e, com diferenca na Chave de Acesso"})
aadd(aMOTIVOS,{"540" ,"Rejeicao: CPF do Local de Retirada invalido"})
aadd(aMOTIVOS,{"541" ,"Rejeicao: CPF do Local de Entrega invalido"})
aadd(aMOTIVOS,{"542" ,"Rejeicao: CNPJ do Transportador invalido"})
aadd(aMOTIVOS,{"543" ,"Rejeicao: CPF do Transportador invalido"})
aadd(aMOTIVOS,{"544" ,"Rejeicao: IE do Transportador invalida"})
aadd(aMOTIVOS,{"545" ,"Rejeicao: Falha no schema XML a versao informada na versaoDados do SOAPHeader diverge da versao da mensagem"})
aadd(aMOTIVOS,{"546" ,"Rejeicao: Erro na Chave de Acesso - Campo Id falta a literal NFe"})
aadd(aMOTIVOS,{"547" ,"Rejeicao: Digito Verificador da Chave de Acesso da NF-e Referenciada invalido"})
aadd(aMOTIVOS,{"548" ,"Rejeicao: CNPJ da NF referenciada invalido."})
aadd(aMOTIVOS,{"549" ,"Rejeicao: CNPJ da NF referenciada de produtor invalido."})
aadd(aMOTIVOS,{"550" ,"Rejeicao: CPF da NF referenciada de produtor invalido."})
aadd(aMOTIVOS,{"551" ,"Rejeicao: IE da NF referenciada de produtor invalido."})
aadd(aMOTIVOS,{"552" ,"Rejeicao: Digito Verificador da Chave de Acesso do CT-e Referenciado invalido"})
aadd(aMOTIVOS,{"553" ,"Rejeicao: Tipo autorizador do recibo diverge do Órgao Autorizador."})
aadd(aMOTIVOS,{"554" ,"Rejeicao: Serie difere da faixa 0-899"})
aadd(aMOTIVOS,{"555" ,"Rejeicao: Tipo autorizador do protocolo diverge do Orgao Autorizador."})
aadd(aMOTIVOS,{"556" ,"Rejeicao: Justificativa de entrada em contingencia nao deve ser informada para tipo de emissao normal."})
aadd(aMOTIVOS,{"557" ,"Rejeicao: A Justificativa de entrada em contingencia deve ser informada."})
aadd(aMOTIVOS,{"558" ,"Rejeicao: Data de entrada em contingência posterior a data de emissao."})
aadd(aMOTIVOS,{"559" ,"Rejeicao: UF do Transportador nao informada"})
aadd(aMOTIVOS,{"560" ,"Rejeicao: CNPJ base do emitente difere do CNPJ base da primeira NF-e do lote recebido"})
aadd(aMOTIVOS,{"561" ,"Rejeicao: Mes de Emissao informado na Chave de Acesso difere do Mes de Emissao da NFe"})
aadd(aMOTIVOS,{"562" ,"Rejeicao: Codigo Numerico informado na Chave de Acesso difere do Codigo Numerico da NF-e"})
aadd(aMOTIVOS,{"563" ,"Rejeicao: Ja existe pedido de Inutilizacao com a mesma faixa de inutilizacao"})
aadd(aMOTIVOS,{"564" ,"Rejeicao: Total do Produto / Servico difere do somatorio dos itens"})
aadd(aMOTIVOS,{"565" ,"Rejeicao: Falha no schema XML - inexiste a tag raiz esperada para o lote de NF-e"})
aadd(aMOTIVOS,{"567" ,"Rejeicao: Falha no schema XML - versao informada na versaoDados do SOAPHeader diverge da versao do lote de NF-e"})
aadd(aMOTIVOS,{"568" ,"Rejeicao: Falha no schema XML - inexiste atributo versao na tag raiz do lote de NF-e CODIGO MOTIVOS DE DENEGACAO DE USO"})
aadd(aMOTIVOS,{"301" ,"Uso Denegado: Irregularidade fiscal do emitente"})
aadd(aMOTIVOS,{"999" ,"Rejeicao: Erro nao catalogado (informar a mensagem de erro capturado no tratamento da excecao)"})


if !lNFEprod
  msgbox1("NFCE EM HOMOLOGACAO")
endif

nTela2 := savescreen(0,0,24,80)

setcolor("B/W")
nbox(5,10,18,70,"W/W+",.t.)

@  6, 11 say padc("EMITINDO NFCE",59)

  ACBrNFe_ENT = "C:\NFE\ENTNFE.TXT"
  ACBrNFe_SAI = "C:\NFE\SAINFE.TXT"
  ACBrNFe_TMP = "C:\NFE\ARQTMP.TXT"
  ACBrNFe_UNI = "C:"

mon_env('NFe.CriarEnviarNFe("C:\CIRUR\NFE\SAT.INI",1,1,1,,0)')
cRet := upper(MON_RET(ACBrNFe_SAI))   // Verifica Retorno do Arquivo de Resposta.



if "CSTAT=539" $ cRet // duplicidade
   handle=fopen("C:\NFE\SAINFE.TXT")
   feof = .f.

   do while .t.

     if feof
       exit
     endif
     M_FRASE =  alltrim(upper(freadline(handle)))
     if "CHNFE:" $ M_FRASE
        pos = rat("CHNFE:",upper(M_FRASE))

        M_NOAR = substr(M_FRASE,POS+6,44)
        fclose(handle)
        NFe_CON(M_NOAR)
        cRet := upper(MON_RET(ACBrNFe_SAI))
        exit
     endif
   enddo

   fclose(handle)
	WvtSetBlocks( aLastPaint6 )
	restscreen(0,0,24,80,nTela2)


   if "CSTAT=100" $ cRet .or. "AUTORIZADO O USO DA NF-E" $ cRet
     M_NFSMES = "20" + SUBSTR(M_NOAR,3,4)

     cFileDanfe = "C:\CIRUR\ENVIADO\" + M_NFSMES + "\NFCE\"+ M_NOAR + "-nfe.xml"
     iFileDanfe = "&_PATH_\ENVIADO\" + M_NFSMES + "\NFCE\"+ M_NOAR + "-nfe.xml"
     nDircriar = "&_PATH_\ENVIADO\" + M_NFSMES

     aFiles  := directory("&_PATH_\ENVIADO\&M_NFSMES\*.*", "D")
     if len( aFiles ) = 0
       makedir("&_PATH_\ENVIADO\" + M_NFSMES)
       makedir("&_PATH_\ENVIADO\" + M_NFSMES + "\NFCe")
     endif

     Filecopy(cFileDanfe,iFileDanfe)           // Copy the file

*     nCop = 1
*     cCmd := ["]+cFileDanfe+[","TANCA TP-550","]+nCop+["]

     cCmd := ["]+cFileDanfe+[",""]
     cRet := MON_ENV( "NFE.ImprimirDanfe", cCmd, ACBrNFe_ENT, ACBrNFe_SAI, ACBrNFe_TMP )

*     NFe_IMP(cFileDanfe,1)

     M_NOAR = M_NOAR + "-nfe.xml"
     M_NFSMES = "20" + SUBSTR(M_NOAR,3,4)

     return .t.
   endif

endif

if "CSTAT=100" $ cRet .or. "AUTORIZADO O USO DA NF-E" $ cRet
   handle=fopen("C:\NFE\SAINFE.TXT")
   feof = .f.

   do while .t.

     if feof
       exit
     endif
     M_FRASE =  alltrim(upper(freadline(handle)))
     if "CHDFE=" $ M_FRASE
        M_NOAR = right(M_FRASE,44) + "-nfe.xml"
        M_NFSMES = "20" + SUBSTR(M_FRASE,9,4)
        exit
     endif
   enddo

   fclose(handle)
	WvtSetBlocks( aLastPaint6 )
	restscreen(0,0,24,80,nTela2)


  cFileDanfe = "C:\CIRUR\ENVIADO\" + M_NFSMES + "\NFCE\"+ M_NOAR
  iFileDanfe = "&_PATH_\ENVIADO\" + M_NFSMES + "\NFCE\"+ M_NOAR
  nDircriar = "&_PATH_\ENVIADO\" + M_NFSMES

  aFiles  := directory("&_PATH_\ENVIADO\&M_NFSMES\*.*", "D")
  if len( aFiles ) = 0
    makedir("&_PATH_\ENVIADO\" + M_NFSMES)
    makedir("&_PATH_\ENVIADO\" + M_NFSMES + "\NFCe")
  endif

  Filecopy(cFileDanfe,iFileDanfe)           // Copy the file

   return .t.
endif

setcolor("N/W*")
keyboard chr(30)
memoedit(cret,07,11,17,69,.f.,,60)

WvtSetBlocks( aLastPaint6 )
restscreen(0,0,24,80,nTela2)


return .f.
