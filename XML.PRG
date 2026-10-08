*****************
function NOVO_XML
*****************

local cRet := ""
local nBuffSize := 16                   // Read/write buffer size
local l7143Supp := .F.                  // Is function 7143h supported?

aMOTIVOS = { }

aadd(aMOTIVOS,{"100" ,{"Autorizado o uso da NF-e"}})
aadd(aMOTIVOS,{"101" ,{"Cancelamento de NF-e homologado"}})
aadd(aMOTIVOS,{"102" ,{"Inutilizacao de numero homologado"}})
aadd(aMOTIVOS,{"103" ,{"Lote recebido com sucesso"}})
aadd(aMOTIVOS,{"104" ,{"Lote processado"}})
aadd(aMOTIVOS,{"105" ,{"Lote em processamento"}})
aadd(aMOTIVOS,{"106" ,{"Lote nao localizado"}})
aadd(aMOTIVOS,{"107" ,{"Serviço em Operacao"}})
aadd(aMOTIVOS,{"108" ,{"Servico Paralisado Momentaneamente (curto prazo)"}})
aadd(aMOTIVOS,{"109" ,{"Servico Paralisado sem Previsao"}})
aadd(aMOTIVOS,{"110" ,{"Uso Denegado"}})

aadd(aMOTIVOS,{"111" ,{"Consulta cadastro com uma ocorrencia"}})
aadd(aMOTIVOS,{"112" ,{"Consulta cadastro com mais de uma ocorrencia"}})

aadd(aMOTIVOS,{"124" ,{"EPEC Autorizado"}})
aadd(aMOTIVOS,{"128" ,{"Lote de Evento Processado"}})

aadd(aMOTIVOS,{"135" ,{"Evento registrado e vinculado a NF-e"}})
aadd(aMOTIVOS,{"136" ,{"Evento registrado, mas nao vinculado a NF-e"}})
aadd(aMOTIVOS,{"137" ,{"Nenhum documento localizado para o Destinatario"}})
aadd(aMOTIVOS,{"138" ,{"Documento localizado para o Destinatario"}})
aadd(aMOTIVOS,{"139" ,{"Pedido de Download processado"}})

aadd(aMOTIVOS,{"140" ,{"Download disponibilizado"}})
aadd(aMOTIVOS,{"142" ,{"Ambiente de Contingencia","EPEC bloqueado para o Emitente"}})

aadd(aMOTIVOS,{"150" ,{"Autorizado o uso da NF-e, autorizacao fora de prazo"}})
aadd(aMOTIVOS,{"151" ,{"Cancelamento de NF-e homologado fora de prazo"}})

aadd(aMOTIVOS,{"201" ,{"Rejeicao: O numero maximo de numeracao de NF-e ","a inutilizar ultrapassou o limite"}})
aadd(aMOTIVOS,{"202" ,{"Rejeicao: Falha no reconhecimento da autoria ou ","integridade do arquivo digital"}})
aadd(aMOTIVOS,{"203" ,{"Rejeicao: Emissor nao habilitado para emissao da NF-e"}})
aadd(aMOTIVOS,{"204" ,{"Rejeicao: Duplicidade de NF-e"}})
aadd(aMOTIVOS,{"205" ,{"Rejeicao: NF-e esta denegada na base de dados da SEFAZ"}})
aadd(aMOTIVOS,{"206" ,{"Rejeicao: NF-e ja esta inutilizada na Base de dados da SEFAZ"}})
aadd(aMOTIVOS,{"207" ,{"Rejeicao: CNPJ do emitente invalido"}})
aadd(aMOTIVOS,{"208" ,{"Rejeicao: CNPJ do destinatario invalido"}})
aadd(aMOTIVOS,{"209" ,{"Rejeicao: IE do emitente invalida"}})
aadd(aMOTIVOS,{"210" ,{"Rejeicao: IE do destinatario invalida"}})

aadd(aMOTIVOS,{"211" ,{"Rejeicao: IE do substituto invalida"}})
aadd(aMOTIVOS,{"212" ,{"Rejeicao: Data de emissao NF-e posterior a data de recebimento"}})
aadd(aMOTIVOS,{"213" ,{"Rejeicao: CNPJ-Base do Emitente difere do CNPJ-Base ","do Certificado Digital"}})
aadd(aMOTIVOS,{"214" ,{"Rejeicao: Tamanho da mensagem excedeu o limite estabelecido"}})
aadd(aMOTIVOS,{"215" ,{"Rejeicao: Falha no schema XML"}})
aadd(aMOTIVOS,{"216" ,{"Rejeicao: Chave de Acesso difere da cadastrada"}})
aadd(aMOTIVOS,{"217" ,{"Rejeicao: NF-e nao consta na base de dados da SEFAZ"}})
aadd(aMOTIVOS,{"218" ,{"Rejeicao: NF-e ja esta cancelada na base de dados da SEFAZ"}})
aadd(aMOTIVOS,{"219" ,{"Rejeicao: Circulacao da NF-e verificada"}})
aadd(aMOTIVOS,{"220" ,{"Rejeicao: NF-e autorizada ha mais de 7 dias (168 horas)"}})

aadd(aMOTIVOS,{"221" ,{"Rejeicao: Confirmado o recebimento da ","NF-e pelo destinatario"}})
aadd(aMOTIVOS,{"222" ,{"Rejeicao: Protocolo de Autorizacao de ","Uso difere do cadastrado"}})
aadd(aMOTIVOS,{"223" ,{"Rejeicao: CNPJ do transmissor do lote difere ","do CNPJ do transmissor da consulta"}})
aadd(aMOTIVOS,{"224" ,{"Rejeicao: A faixa inicial eh maior que a faixa final"}})
aadd(aMOTIVOS,{"225" ,{"Rejeicao: Falha no Schema XML do lote de NFe"}})
aadd(aMOTIVOS,{"226" ,{"Rejeicao: Codigo da UF do Emitente diverge ","da UF autorizadora"}})
aadd(aMOTIVOS,{"227" ,{"Rejeicao: Erro na Chave de Acesso - Campo Id ","– falta a literal NFe"}})
aadd(aMOTIVOS,{"228" ,{"Rejeicao: Data de Emissao muito atrasada"}})
aadd(aMOTIVOS,{"229" ,{"Rejeicao: IE do emitente nao informada"}})
aadd(aMOTIVOS,{"230" ,{"Rejeicao: IE do emitente nao cadastrada"}})

aadd(aMOTIVOS,{"231" ,{"Rejeicao: IE do emitente nao vinculada ao CNPJ"}})
aadd(aMOTIVOS,{"232" ,{"Rejeicao: IE do destinatario nao informada"}})
aadd(aMOTIVOS,{"233" ,{"Rejeicao: IE do destinatario nao cadastrada"}})
aadd(aMOTIVOS,{"234" ,{"Rejeicao: IE do destinatario nao vinculada ao CNPJ"}})
aadd(aMOTIVOS,{"235" ,{"Rejeicao: Inscricao SUFRAMA invalida"}})
aadd(aMOTIVOS,{"236" ,{"Rejeicao: Chave de Acesso com digito ","verificador invalido"}})
aadd(aMOTIVOS,{"237" ,{"Rejeicao: CPF do destinatario invalido"}})
aadd(aMOTIVOS,{"238" ,{"Rejeicao: Cabecalho - Versao do arquivo ","XML superior a Versao vigente"}})
aadd(aMOTIVOS,{"239" ,{"Rejeicao: Cabecalho - Versao do arquivo ","XML nao suportada"}})
aadd(aMOTIVOS,{"240" ,{"Rejeicao: Cancelamento/Inutilizacao - ","Irregularidade Fiscal do Emitente"}})

aadd(aMOTIVOS,{"241" ,{"Rejeicao: Um numero da faixa ja foi utilizado"}})
aadd(aMOTIVOS,{"242" ,{"Rejeicao: Cabecalho - Falha no Schema XML"}})
aadd(aMOTIVOS,{"243" ,{"Rejeicao: XML Mal Formado"}})
aadd(aMOTIVOS,{"244" ,{"Rejeicao: CNPJ do Certificado Digital difere do ","CNPJ da Matriz e do CNPJ do Emitente"}})
aadd(aMOTIVOS,{"245" ,{"Rejeicao: CNPJ Emitente nao cadastrado"}})
aadd(aMOTIVOS,{"246" ,{"Rejeicao: CNPJ Destinatario nao cadastrado"}})
aadd(aMOTIVOS,{"247" ,{"Rejeicao: Sigla da UF do Emitente ","diverge da UF autorizadora"}})
aadd(aMOTIVOS,{"248" ,{"Rejeicao: UF do Recibo diverge da UF autorizadora"}})
aadd(aMOTIVOS,{"249" ,{"Rejeicao: UF da Chave de Acesso ","diverge da UF autorizadora"}})
aadd(aMOTIVOS,{"250" ,{"Rejeicao: UF diverge da UF autorizadora"}})

aadd(aMOTIVOS,{"251" ,{"Rejeicao: UF/Municipio destinatario ","nao pertence a SUFRAMA"}})
aadd(aMOTIVOS,{"252" ,{"Rejeicao: Ambiente informado diverge ","do Ambiente de recebimento"}})
aadd(aMOTIVOS,{"253" ,{"Rejeicao: Digito Verificador da chave ","de acesso composta invalida"}})
aadd(aMOTIVOS,{"254" ,{"Rejeicao: NF-e complementar nao ","possui NF referenciada"}})
aadd(aMOTIVOS,{"255" ,{"Rejeicao: NF-e complementar possui ","mais de uma NF referenciada"}})
aadd(aMOTIVOS,{"256" ,{"Rejeicao: Uma NF-e da faixa ja esta ","inutilizada na Base de dados da SEFAZ"}})
aadd(aMOTIVOS,{"257" ,{"Rejeicao: Solicitante nao habilitado ","para emissao da NF-e"}})
aadd(aMOTIVOS,{"258" ,{"Rejeicao: CNPJ da consulta invalido"}})
aadd(aMOTIVOS,{"259" ,{"Rejeicao: CNPJ da consulta nao cadastrado ","como contribuinte na UF"}})
aadd(aMOTIVOS,{"260" ,{"Rejeicao: IE da consulta invalida"}})

aadd(aMOTIVOS,{"261" ,{"Rejeicao: IE da consulta nao cadastrada como ","contribuinte na UF"}})
aadd(aMOTIVOS,{"262" ,{"Rejeicao: UF nao fornece consulta por CPF"}})
aadd(aMOTIVOS,{"263" ,{"Rejeicao: CPF da consulta invalido"}})
aadd(aMOTIVOS,{"264" ,{"Rejeicao: CPF da consulta nao cadastrado como ","contribuinte na UF"}})
aadd(aMOTIVOS,{"265" ,{"Rejeicao: Sigla da UF da consulta difere da ","UF do Web Service"}})
aadd(aMOTIVOS,{"266" ,{"Rejeicao: Serie utilizada nao permitida ","no Web Service"}})
aadd(aMOTIVOS,{"267" ,{"Rejeicao: NF Complementar referencia uma ","NF-e inexistente"}})
aadd(aMOTIVOS,{"268" ,{"Rejeicao: NF Complementar referencia uma ","outra NF-e Complementar"}})
aadd(aMOTIVOS,{"269" ,{"Rejeicao: CNPJ Emitente da NF Complementar ","difere do CNPJ da NF Referenciada"}})
aadd(aMOTIVOS,{"270" ,{"Rejeicao: Codigo Municipio do Fato Gerador: ","digito invalido"}})

aadd(aMOTIVOS,{"271" ,{"Rejeicao: Codigo Municipio do Fato Gerador: ","difere da UF do emitente"}})
aadd(aMOTIVOS,{"272" ,{"Rejeicao: Codigo Municipio do Emitente: ","digito invalido"}})
aadd(aMOTIVOS,{"273" ,{"Rejeicao: Codigo Municipio do Emitente: ","difere da UF do emitente"}})
aadd(aMOTIVOS,{"274" ,{"Rejeicao: Codigo Municipio do Destinatario: ","digito invalido"}})
aadd(aMOTIVOS,{"275" ,{"Rejeicao: Codigo Municipio do Destinatario: ","difere da UF do Destinatario"}})
aadd(aMOTIVOS,{"276" ,{"Rejeicao: Codigo Municipio do Local de Retirada: ","digito invalido"}})
aadd(aMOTIVOS,{"277" ,{"Rejeicao: Codigo Municipio do Local de Retirada: ","difere da UF do Local de Retirada"}})
aadd(aMOTIVOS,{"278" ,{"Rejeicao: Codigo Municipio do Local de Entrega: ","digito invalido"}})
aadd(aMOTIVOS,{"279" ,{"Rejeicao: Codigo Municipio do Local de Entrega: ","difere da UF do Local de Entrega"}})
aadd(aMOTIVOS,{"280" ,{"Rejeicao: Certificado Transmissor invalido"}})

aadd(aMOTIVOS,{"281" ,{"Rejeicao: Certificado Transmissor Data Validade"}})
aadd(aMOTIVOS,{"282" ,{"Rejeicao: Certificado Transmissor sem CNPJ"}})
aadd(aMOTIVOS,{"283" ,{"Rejeicao: Certificado Transmissor - ","erro Cadeia de Certificacao"}})
aadd(aMOTIVOS,{"284" ,{"Rejeicao: Certificado Transmissor revogado"}})
aadd(aMOTIVOS,{"285" ,{"Rejeicao: Certificado Transmissor ","difere ICP-Brasil"}})
aadd(aMOTIVOS,{"286" ,{"Rejeicao: Certificado Transmissor ","erro no acesso a LCR"}})
aadd(aMOTIVOS,{"287" ,{"Rejeicao: Codigo Municipio do FG - ","ISSQN: digito invalido"}})
aadd(aMOTIVOS,{"288" ,{"Rejeicao: Codigo Municipio do FG - ","Transporte: digito invalido"}})
aadd(aMOTIVOS,{"289" ,{"Rejeicao: Codigo da UF informada ","diverge da UF solicitada"}})
aadd(aMOTIVOS,{"290" ,{"Rejeicao: Certificado Assinatura invalido"}})

aadd(aMOTIVOS,{"291" ,{"Rejeicao: Certificado Assinatura ","Data Validade"}})
aadd(aMOTIVOS,{"292" ,{"Rejeicao: Certificado Assinatura sem CNPJ"}})
aadd(aMOTIVOS,{"293" ,{"Rejeicao: Certificado Assinatura - ","erro Cadeia de Certificacao"}})
aadd(aMOTIVOS,{"294" ,{"Rejeicao: Certificado Assinatura revogado"}})
aadd(aMOTIVOS,{"295" ,{"Rejeicao: Certificado Assinatura ","difere ICP-Brasil"}})
aadd(aMOTIVOS,{"296" ,{"Rejeicao: Certificado Assinatura ","erro no acesso a LCR"}})
aadd(aMOTIVOS,{"297" ,{"Rejeicao: Assinatura difere do calculado"}})
aadd(aMOTIVOS,{"298" ,{"Rejeicao: Assinatura difere do ","padrao do Projeto"}})
aadd(aMOTIVOS,{"299" ,{"Rejeicao: XML da area de cabecalho ","com codificacao diferente de UTF-8"}})

aadd(aMOTIVOS,{"301" ,{"Uso Denegado: Irregularidade ","fiscal do emitente"}})
aadd(aMOTIVOS,{"302" ,{"Rejeicao: Irregularidade ","fiscal do destinatario"}})
aadd(aMOTIVOS,{"303" ,{"Uso Denegado: Destinatario ","nao habilitado a operar na UF"}})
aadd(aMOTIVOS,{"304" ,{"Rejeicao: Pedido de Cancelamento ","para NF-e com evento da Suframa"}})
aadd(aMOTIVOS,{"305" ,{"Rejeicao: Destinatario bloqueado na UF"}})
aadd(aMOTIVOS,{"306" ,{"Rejeicao: IE do destinatario nao esta ativa na UF"}})

aadd(aMOTIVOS,{"315" ,{"Rejeicao: Data de Emissao anterior ao inicio","da autorizacao de Nota Fiscal na UF"}})
aadd(aMOTIVOS,{"316" ,{"Rejeicao: Chave de Acesso referenciada com a","mesma Chave de Acesso da Nota Fiscal atual [nOcor:nnn]"}})
aadd(aMOTIVOS,{"317" ,{"Rejeicao: NF modelo 1 referenciada com data","de emissao invalida [nOcor:nnn]"}})
aadd(aMOTIVOS,{"318" ,{"Rejeicao: Contranota de Produtor sem Nota Fiscal referenciada"}})
aadd(aMOTIVOS,{"319" ,{"Rejeicao: Contranota de Produtor nao pode","referenciar somente Nota Fiscal de entrada"}})
aadd(aMOTIVOS,{"320" ,{"Rejeicao: Contranota de Produtor referencia","somente NF de outro emitente"}})

aadd(aMOTIVOS,{"321" ,{"Rejeicao: NF-e de devolucao de","mercadoria nao possui documento fiscal referenciado"}})
aadd(aMOTIVOS,{"322" ,{"Rejeicao: NF de produtor referenciada","com data de emissao invalida [nOcor:nnn]"}})
aadd(aMOTIVOS,{"323" ,{"Rejeicao: CNPJ autorizado ","para download invalido"}})
aadd(aMOTIVOS,{"324" ,{"Rejeicao: CNPJ do destinatario ","ja autorizado para download"}})
aadd(aMOTIVOS,{"325" ,{"Rejeicao: CPF autorizado para ","download invalido"}})
aadd(aMOTIVOS,{"326" ,{"Rejeicao: CPF do destinatario ","ja autorizado para download"}})
aadd(aMOTIVOS,{"327" ,{"Rejeicao: CFOP invalido para ","NF-e com finalidade de devolucao de mercadoria"}})
aadd(aMOTIVOS,{"328" ,{"Rejeicao: CFOP de devolucao de mercadoria ","para NF-e que nao tem finalidade ","de devolucao de mercadoria"}})
aadd(aMOTIVOS,{"329" ,{"Rejeicao: Número da DI /DSI invalido"}})
aadd(aMOTIVOS,{"330" ,{"Rejeicao: Informar o Valor da AFRMM ","na importacao por via maritima"}})

aadd(aMOTIVOS,{"331" ,{"Rejeicao: Informar o CNPJ do adquirente ou ","do encomendante nesta forma de importacao"}})
aadd(aMOTIVOS,{"332" ,{"Rejeicao: CNPJ do adquirente ou do ","encomendante da importacao invalido"}})
aadd(aMOTIVOS,{"333" ,{"Rejeicao: Informar a UF do adquirente ou ","do encomendante nesta forma de importacao"}})
aadd(aMOTIVOS,{"334" ,{"Rejeicao: Número do processo de drawback ","nao informado na importacao"}})
aadd(aMOTIVOS,{"335" ,{"Rejeicao: Número do processo de drawback ","na importacao invalido"}})
aadd(aMOTIVOS,{"336" ,{"Rejeicao: Informado o grupo de exportacao ","no item para CFOP que nao e de exportacao"}})
aadd(aMOTIVOS,{"337" ,{"Rejeicao: Nao informado o grupo ","de exportacao no item"}})
aadd(aMOTIVOS,{"338" ,{"Rejeicao: Número do processo de ","drawback nao informado na exportacao"}})
aadd(aMOTIVOS,{"339" ,{"Rejeicao: Número do processo de ","drawback na exportacao invalido"}})
aadd(aMOTIVOS,{"340" ,{"Rejeicao: Nao informado o grupo ","de exportacao indireta no item"}})

aadd(aMOTIVOS,{"341" ,{"Rejeicao: Número do registro ","de exportacao invalido"}})
aadd(aMOTIVOS,{"342" ,{"Rejeicao: Chave de Acesso informada ","na Exportacao Indireta com DV invalido"}})
aadd(aMOTIVOS,{"343" ,{"Rejeicao: Modelo da NF-e informada na ","Exportacao Indireta diferente de 55"}})
aadd(aMOTIVOS,{"344" ,{"Rejeicao: Duplicidade de NF-e informada ","na Exportacao Indireta ","(Chave de Acesso informada mais de uma vez)"}})
aadd(aMOTIVOS,{"345" ,{"Rejeicao: Chave de Acesso informada ","na Exportacao Indireta nao consta ","como NF-e referenciada"}})
aadd(aMOTIVOS,{"346" ,{"Rejeicao: Somatorio das quantidades ","informadas na Exportacao Indireta ","nao corresponde a quantidade total do item"}})
aadd(aMOTIVOS,{"347" ,{"Rejeicao: Descricao do Combustivel ","diverge da descricao adotada pela ANP"}})
aadd(aMOTIVOS,{"348" ,{"Rejeicao: NFC-e com grupo RECOPI"}})
aadd(aMOTIVOS,{"349" ,{"Rejeicao: Número RECOPI nao informado"}})
aadd(aMOTIVOS,{"350" ,{"Rejeicao: Número RECOPI invalido"}})

aadd(aMOTIVOS,{"351" ,{"Rejeicao: Valor do ICMS da Operacao ","no CST=51 difere do produto ","BC e Aliquota"}})
aadd(aMOTIVOS,{"352" ,{"Rejeicao: Valor do ICMS Diferido no CST=51 ","difere do produto Valor ICMS Operacao ","e percentual diferimento"}})
aadd(aMOTIVOS,{"353" ,{"Rejeicao: Valor do ICMS no CST=51 ","nao corresponde a diferença do ICMS ","operacao e ICMS diferido"}})
aadd(aMOTIVOS,{"354" ,{"Rejeicao: Informado grupo de devolucao ","de tributos para NF-e que nao tem ","finalidade de devolucao de mercadoria"}})
aadd(aMOTIVOS,{"355" ,{"Rejeicao: Informar o local de","saida do Pais no caso da exportacao"}})
aadd(aMOTIVOS,{"356" ,{"Rejeicao: Informar o local de ","saida do Pais somente no caso da exportacao"}})
aadd(aMOTIVOS,{"357" ,{"Rejeicao: Chave de Acesso do grupo ","de Exportacao Indireta ","inexistente [nRef: xxx]"}})
aadd(aMOTIVOS,{"358" ,{"Rejeicao: Chave de Acesso do grupo ","de Exportacao Indireta cancelada ","ou denegada [nRef: xxx]"}})
aadd(aMOTIVOS,{"359" ,{"Rejeicao: NF-e de venda a ","orgao Público sem informar ","a Nota de Empenho"}})
aadd(aMOTIVOS,{"360" ,{"Rejeicao: NF-e com Nota de ","Empenho invalida para a UF."}})

aadd(aMOTIVOS,{"361" ,{"Rejeicao: NF-e com Nota de ","Empenho inexistente na UF."}})
aadd(aMOTIVOS,{"362" ,{"Rejeicao: Venda de combustivel","sem informacao do Transportador"}})
aadd(aMOTIVOS,{"363" ,{"Rejeicao: IE do substituto tributario","identica à IE do emitente ou do destinatario"}})
aadd(aMOTIVOS,{"364" ,{"Rejeicao: Total do valor da deducao ","do ISS difere do somatorio dos itens"}})
aadd(aMOTIVOS,{"365" ,{"Rejeicao: Total de outras retenções ","difere do somatorio dos itens"}})
aadd(aMOTIVOS,{"366" ,{"Rejeicao: Total do desconto incondicionado","ISS difere do somatorio dos itens"}})
aadd(aMOTIVOS,{"367" ,{"Rejeicao: Total do desconto condicionado ","ISS difere do somatorio dos itens"}})
aadd(aMOTIVOS,{"368" ,{"Rejeicao: Total de ISS retido difere ","do somatorio dos itens"}})
aadd(aMOTIVOS,{"369" ,{"Rejeicao: Nao informado o grupo ","avulsa na emissao pelo Fisco"}})
aadd(aMOTIVOS,{"370" ,{"Rejeicao: Nota Fiscal Avulsa ","com tipo de emissao invalido"}})

aadd(aMOTIVOS,{"372" ,{"Rejeicao: Destinatario com identificacao","de estrangeiro com caracteres invalidos"}})
aadd(aMOTIVOS,{"373" ,{"Rejeicao: Descricao do primeiro item diferente","de NOTA FISCAL EMITIDA EM AMBIENTE","DE HOMOLOGACAO - SEM VALOR FISCAL [nItem:nnn]"}})
aadd(aMOTIVOS,{"374" ,{"Rejeicao: CFOP incompativel com o","grupo de tributacao [nItem: nnn]"}})
aadd(aMOTIVOS,{"375" ,{"Rejeicao: NF-e com lançamento relativo","a Cupom Fiscal referencia","uma NFC-e [nItem: nnn]"}})
aadd(aMOTIVOS,{"376" ,{"Rejeicao: Data do Desembaraço","Aduaneiro invalida [nItem: nnn]"}})
aadd(aMOTIVOS,{"377" ,{"Rejeicao: Codigo de Pais do","destinatario inexistente"}})
aadd(aMOTIVOS,{"378" ,{"Rejeicao: Grupo de Combustivel sem a","informacao de Encerrante [nItem: nnn]"}})
aadd(aMOTIVOS,{"379" ,{"Rejeicao: Grupo de Encerrante na NF-e","(modelo 55) para CFOP diferente de","venda de combustivel para consumidor final [nItem:nnn]"}})
aadd(aMOTIVOS,{"380" ,{"Rejeicao: Valor do Encerrante final nao","e superior ao Encerrante inicial [nItem: nnn]"}})

aadd(aMOTIVOS,{"381" ,{"Rejeicao: Grupo de tributacao ICMS90,","informando dados do ICMS-ST [nItem:nnn]"}})
aadd(aMOTIVOS,{"382" ,{"Rejeicao: CFOP nao permitido para o","CST informado [nItem:nnn]"}})
aadd(aMOTIVOS,{"383" ,{"Rejeicao: Item com CSOSN indevido [nItem: nnn]"}})
aadd(aMOTIVOS,{"384" ,{"Rejeicao: CSOSN nao permitido para","a UF [nItem: nnn]"}})
aadd(aMOTIVOS,{"385" ,{"Rejeicao: Grupo de tributacao ICMSSN900,","informando dados do ICMS-ST [nItem: nnn]"}})
aadd(aMOTIVOS,{"386" ,{"Rejeicao: CFOP nao permitido para o CSOSN","informado [nItem: nnn]"}})
aadd(aMOTIVOS,{"387" ,{"Rejeicao: Codigo de Enquadramento Legal","do IPI invalido [nItem: nnn]"}})
aadd(aMOTIVOS,{"388" ,{"Rejeicao: Codigo de Situacao Tributaria","do IPI incompativel com o Codigo de Enquadramento Legal do IPI [nItem: nnn]"}})
aadd(aMOTIVOS,{"389" ,{"Rejeicao: Codigo Municipio ISSQN","inexistente [nItem:nnn]"}})
aadd(aMOTIVOS,{"390" ,{"Rejeicao: Nota Fiscal com grupo de","devolucao de Tributos [nItem: nnn]"}})

aadd(aMOTIVOS,{"391" ,{"Rejeicao: Nao informados os dados do","cartao de credito / debito nas Formas","de Pagamento da Nota Fiscal"}})
aadd(aMOTIVOS,{"392" ,{"Rejeicao: Nao informados os dados da","operacao de pagamento por cartao","de credito / debito"}})
aadd(aMOTIVOS,{"393" ,{"Rejeicao: NF-e com o grupo","de Informações Suplementares"}})
aadd(aMOTIVOS,{"394" ,{"Rejeicao: Nota Fiscal sem a","informacao do QR-Code"}})
aadd(aMOTIVOS,{"395" ,{"Rejeicao: Endereço do site da UF da","Consulta via QR-Code diverge do previsto"}})
aadd(aMOTIVOS,{"396" ,{"Rejeicao: Parâmetro do QR-Code inexistente:","[Nome do parâmetro do QR Code: xxx)]"}})
aadd(aMOTIVOS,{"397" ,{"Rejeicao: Parâmetro do QR-Code divergente","da Nota Fiscal: [Nome do parâmetro","do QR Code:: xxx)]"}})
aadd(aMOTIVOS,{"398" ,{"Rejeicao: Parâmetro Versao informada no","QR-Code diverge do previsto (“2”)"}})
aadd(aMOTIVOS,{"399" ,{"Rejeicao: Parâmetro de Identificacao do","destinatario no QR-Code para Nota","Fiscal sem identificacao do destinatario"}})
aadd(aMOTIVOS,{"400" ,{"Rejeicao: Parâmetro do QR-Code nao","esta no formato hexadecimal:","[Nome do parâmetro do QR Code: xxx)]"}})

aadd(aMOTIVOS,{"401" ,{"Rejeicao: CPF do remetente invalido"}})
aadd(aMOTIVOS,{"402" ,{"Rejeicao: XML da area de dados com ","codificacao diferente de UTF-8"}})
aadd(aMOTIVOS,{"403" ,{"Rejeicao: O grupo de informacoes da ","NF-e avulsa e de uso exclusivo do Fisco"}})
aadd(aMOTIVOS,{"404" ,{"Rejeicao: Uso de prefixo de namespace ","nao permitido"}})
aadd(aMOTIVOS,{"405" ,{"Rejeicao: Codigo do pais do emitente: ","digito invalido"}})
aadd(aMOTIVOS,{"406" ,{"Rejeicao: Codigo do pais do destinatario: ","digito invalido"}})
aadd(aMOTIVOS,{"407" ,{"Rejeicao: O CPF so pode ser informado no ","campo emitente para a NF-e avulsa"}})
aadd(aMOTIVOS,{"409" ,{"Rejeicao: Campo cUF inexistente no ","elemento nfeCabecMsg do SOAP Header"}})
aadd(aMOTIVOS,{"410" ,{"Rejeicao: UF informada no campo cUF ","nao e atendida pelo Web Service"}})

aadd(aMOTIVOS,{"411" ,{"Rejeicao: Campo versaoDados inexistente ","no elemento nfeCabecMsg do SOAP Header"}})
aadd(aMOTIVOS,{"416" ,{"Rejeicao: Falha na descompactacao","da area de dados"}})
aadd(aMOTIVOS,{"417" ,{"Rejeicao: Total do ICMS superior ao ","valor limite estabelecido"}})
aadd(aMOTIVOS,{"418" ,{"Rejeicao: Total do ICMS ST superior ","ao valor limite estabelecido"}})
aadd(aMOTIVOS,{"420" ,{"Rejeicao: Cancelamento para ","NF-e ja cancelada"}})

aadd(aMOTIVOS,{"434" ,{"Rejeicao: NF-e sem indicativo do","intermediador (NT 2020.006)"}})
aadd(aMOTIVOS,{"435" ,{"Rejeicao: NF-e nao pode ter o indicativo","do intermediador (NT 2020.006)"}})
aadd(aMOTIVOS,{"436" ,{"Rejeicao: Informado 99-Outros como meio","de pagamento (NT 2020.006)"}})
aadd(aMOTIVOS,{"437" ,{"Rejeicao: CNPJ da instituicao de pagamento","invalido (NT 2020.006)"}})
aadd(aMOTIVOS,{"438" ,{"Rejeicao: Obrigatoria as informações","do intermediador da transacao para","operacao por site de terceiros (NT 2020.006)"}})
aadd(aMOTIVOS,{"439" ,{"Rejeicao: Informações do intermediador","da transacao para operacao por site de terceiros","preenchido indevidamente (NT 2020.006)"}})
aadd(aMOTIVOS,{"440" ,{"Rejeicao: CNPJ do intermediador da","transacao invalido (NT 2020.006)"}})

aadd(aMOTIVOS,{"450" ,{"Rejeicao: Modelo da NF-e ","diferente de 55"}})
aadd(aMOTIVOS,{"451" ,{"Rejeicao: Processo de emissao ","informado invalido"}})
aadd(aMOTIVOS,{"452" ,{"Rejeicao: Tipo Autorizador do ","Recibo diverge do Orgao Autorizador"}})
aadd(aMOTIVOS,{"453" ,{"Rejeicao: Ano de inutilizacao ","nao pode ser superior ao Ano atual"}})
aadd(aMOTIVOS,{"454" ,{"Rejeicao: Ano de inutilizacao ","nao pode ser inferior a 2006"}})
aadd(aMOTIVOS,{"455" ,{"Rejeicao: orgao Autor do evento ","diferente da UF da Chave de Acesso"}})

aadd(aMOTIVOS,{"461" ,{"Rejeicao: Informado percentual de ","Gas Natural na mistura para produto","diferente de GLP"}})
aadd(aMOTIVOS,{"462" ,{"Rejeicao: Codigo Identificador do","CSC no QR-Code nao cadastrado na SEFAZ"}})
aadd(aMOTIVOS,{"463" ,{"Rejeicao: Codigo Identificador do","CSC no QR-Code foi revogado pela empresa"}})
aadd(aMOTIVOS,{"464" ,{"Rejeicao: Codigo de Hash no","QR-Code difere do calculado"}})
aadd(aMOTIVOS,{"465" ,{"Rejeicao: Número de Controle ","da FCI inexistente"}})
aadd(aMOTIVOS,{"466" ,{"Rejeicao: Evento com Tipo de ","Autor incompativel"}})
aadd(aMOTIVOS,{"467" ,{"Rejeicao: Dados da NF-e ","divergentes do EPEC"}})
aadd(aMOTIVOS,{"468" ,{"Rejeicao: NF-e com Tipo Emissao = 4,","sem EPEC correspondente"}})

aadd(aMOTIVOS,{"471" ,{"Rejeicao: Informado NCM=00 indevidamente"}})
aadd(aMOTIVOS,{"472" ,{"Rejeicao: CPF consultado difere do","CPF do Certificado Digital"}})
aadd(aMOTIVOS,{"476" ,{"Rejeicao: Codigo da UF diverge ","da UF da primeira NF-e do Lote"}})
aadd(aMOTIVOS,{"477" ,{"Rejeicao: Codigo do orgao diverge do ","orgao do primeiro evento do Lote"}})
aadd(aMOTIVOS,{"478" ,{"Rejeicao: Local da entrega nao informado ","para faturamento direto de veiculos novos"}})
aadd(aMOTIVOS,{"479" ,{"Rejeicao: Data de Emissao anterior a","data de credenciamento ou anterior a","Data de Abertura do estabelecimento"}})
aadd(aMOTIVOS,{"480" ,{"Rejeicao: Codigo Municipio do Emitente","diverge do cadastrado na UF"}})

aadd(aMOTIVOS,{"481" ,{"Rejeicao: Codigo Regime Tributario do","emitente diverge do cadastro na SEFAZ"}})
aadd(aMOTIVOS,{"482" ,{"Rejeicao: Codigo do Municipio do","Destinatario diverge do cadastrado na UF"}})
aadd(aMOTIVOS,{"483" ,{"Rejeicao: Valor do desconto maior que","valor do produto [nItem: nnn]"}})
aadd(aMOTIVOS,{"484" ,{"Rejeicao: Chave de Acesso com tipo ","de emissao diferente de 4 ","(posicao 35 da Chave de Acesso)"}})
aadd(aMOTIVOS,{"485" ,{"Rejeicao: Duplicidade de numeracao","do EPEC (Modelo, CNPJ, Serie e Número)"}})
aadd(aMOTIVOS,{"486" ,{"Rejeicao: Nao informado o Grupo","de Autorizacao para UF que exige a identificacao do","Escritorio de Contabilidade na Nota Fiscal"}})
aadd(aMOTIVOS,{"487" ,{"Rejeicao: Escritorio de Contabilidade","nao cadastrado na SEFAZ"}})
aadd(aMOTIVOS,{"488" ,{"Rejeicao: Vendas do Emitente","incompativeis com o Porte da Empresa"}})
aadd(aMOTIVOS,{"489" ,{"Rejeicao: CNPJ informado ","invalido (DV ou zeros)"}})
aadd(aMOTIVOS,{"490" ,{"Rejeicao: CPF informado ","invalido (DV ou zeros)"}})

aadd(aMOTIVOS,{"491" ,{"Rejeicao: O tpEvento ","informado invalido"}})
aadd(aMOTIVOS,{"492" ,{"Rejeicao: O verEvento ","informado invalido"}})
aadd(aMOTIVOS,{"493" ,{"Rejeicao: Evento nao ","atende o Schema XML especifico"}})
aadd(aMOTIVOS,{"494" ,{"Rejeicao: Chave de Acesso inexistente"}})
aadd(aMOTIVOS,{"495" ,{"Rejeicao: CPF do Emitente com Serie incompativel"}})

aadd(aMOTIVOS,{"501" ,{"Rejeicao: Pedido de Cancelamento ","intempestivo ","(NF-e autorizada a mais de 7 dias)"}})
aadd(aMOTIVOS,{"502" ,{"Rejeicao: Erro na Chave de Acesso - ","Campo Id nao corresponde a concatenacao ","dos campos correspondentes"}})
aadd(aMOTIVOS,{"503" ,{"Rejeicao: Serie utilizada ","fora da faixa permitida no SCAN (900-999)"}})
aadd(aMOTIVOS,{"504" ,{"Rejeicao: Data de Entrada/","Saida posterior ao permitido"}})
aadd(aMOTIVOS,{"505" ,{"Rejeicao: Data de Entrada/","Saida anterior ao permitido"}})
aadd(aMOTIVOS,{"506" ,{"Rejeicao: Data de Saida ","menor que a Data de Emissao"}})
aadd(aMOTIVOS,{"507" ,{"Rejeicao: O CNPJ do destinatario/remetente ","nao deve ser informado em operacao com o"}})
aadd(aMOTIVOS,{"508" ,{"Rejeicao: O CNPJ com conteudo nulo so e ","valido em operacao com o exterior"}})
aadd(aMOTIVOS,{"509" ,{"Rejeicao: Informado codigo de municipio ","diferente de 9999999 para operacao com o exterior"}})
aadd(aMOTIVOS,{"510" ,{"Rejeicao: Operacao com Exterior e ","Codigo Pais destinatario e 1058 ","(Brasil) ou nao informado"}})

aadd(aMOTIVOS,{"511" ,{"Rejeicao: Nao e de Operacao com Exterior"," e Codigo Pais destinatario ","difere de 1058 (Brasil)"}})
aadd(aMOTIVOS,{"512" ,{"Rejeicao: CNPJ do Local de ","Retirada invalido"}})
aadd(aMOTIVOS,{"513" ,{"Rejeicao: Codigo Municipio ","do Local de Retirada deve ser ","9999999 para UF retirada = EX"}})
aadd(aMOTIVOS,{"514" ,{"Rejeicao: CNPJ do Local de Entrega invalido"}})
aadd(aMOTIVOS,{"515" ,{"Rejeicao: Codigo Municipio do Local de ","Entrega deve ser 9999999 para UF entrega = EX"}})
aadd(aMOTIVOS,{"516" ,{"Rejeicao: Falha no schema XML e inexiste ","a tag raiz esperada para a mensagem"}})
aadd(aMOTIVOS,{"517" ,{"Rejeicao: Falha no schema XML e inexiste ","atributo versao na tag raiz da mensagem"}})
aadd(aMOTIVOS,{"518" ,{"Rejeicao: CFOP de entrada para NF-e de saida"}})
aadd(aMOTIVOS,{"519" ,{"Rejeicao: CFOP de saida para NF-e de entrada"}})
aadd(aMOTIVOS,{"520" ,{"Rejeicao: CFOP de Operacao com ","Exterior e UF destinatario difere de EX"}})

aadd(aMOTIVOS,{"521" ,{"Rejeicao: CFOP nao e de Operacao ","com Exterior e UF destinatario e EX"}})
aadd(aMOTIVOS,{"522" ,{"Rejeicao: CFOP de Operacao Estadual ","e UF emitente difere UF destinatario."}})
aadd(aMOTIVOS,{"523" ,{"Rejeicao: CFOP nao e de Operacao ","Estadual e UF emitente igual ","a UF destinatario."}})
aadd(aMOTIVOS,{"524" ,{"Rejeicao: CFOP de Operacao com ","Exterior e nao informado NCM"}})
aadd(aMOTIVOS,{"525" ,{"Rejeicao: CFOP de Importacao e ","nao informado dados da DI"}})
aadd(aMOTIVOS,{"526" ,{"Rejeicao: CFOP de Exportacao e ","nao informado Local de Embarque"}})
aadd(aMOTIVOS,{"527" ,{"Rejeicao: Operacao de Exportacao ","com informacao de ICMS incompativel"}})
aadd(aMOTIVOS,{"528" ,{"Rejeicao: Valor do ICMS difere ","do produto BC e Aliquota"}})
aadd(aMOTIVOS,{"529" ,{"Rejeicao: NCM de informacao obrigatoria ","para produto tributado pelo IPI"}})
aadd(aMOTIVOS,{"530" ,{"Rejeicao: Operacao com tributacao de ","ISSQN sem informar a Inscricao Municipal"}})

aadd(aMOTIVOS,{"531" ,{"Rejeicao: Total da BC ICMS difere ","do somatorio dos itens"}})
aadd(aMOTIVOS,{"532" ,{"Rejeicao: Total do ICMS difere do ","somatorio dos itens"}})
aadd(aMOTIVOS,{"533" ,{"Rejeicao: Total da BC ICMS-ST difere ","do somatorio dos itens"}})
aadd(aMOTIVOS,{"534" ,{"Rejeicao: Total do ICMS-ST difere ","do somatorio dos itens"}})
aadd(aMOTIVOS,{"535" ,{"Rejeicao: Total do Frete difere ","do somatorio dos itens"}})
aadd(aMOTIVOS,{"536" ,{"Rejeicao: Total do Seguro difere ","do somatorio dos itens"}})
aadd(aMOTIVOS,{"537" ,{"Rejeicao: Total do Desconto difere ","do somatorio dos itens"}})
aadd(aMOTIVOS,{"538" ,{"Rejeicao: Total do IPI difere do ","somatorio dos itens"}})
aadd(aMOTIVOS,{"539" ,{"Rejeicao: Duplicidade de NF-e, ","com diferenca na Chave de Acesso"}})
aadd(aMOTIVOS,{"540" ,{"Rejeicao: CPF do Local de ","Retirada invalido"}})

aadd(aMOTIVOS,{"541" ,{"Rejeicao: CPF do Local de ","Entrega invalido"}})
aadd(aMOTIVOS,{"542" ,{"Rejeicao: CNPJ do Transportador invalido"}})
aadd(aMOTIVOS,{"543" ,{"Rejeicao: CPF do Transportador invalido"}})
aadd(aMOTIVOS,{"544" ,{"Rejeicao: IE do Transportador invalida"}})
aadd(aMOTIVOS,{"545" ,{"Rejeicao: Falha no schema XML a ","versao informada na versaoDados do ","SOAPHeader diverge da versao da mensagem"}})
aadd(aMOTIVOS,{"546" ,{"Rejeicao: Erro na Chave de Acesso - ","Campo Id falta a literal NFe"}})
aadd(aMOTIVOS,{"547" ,{"Rejeicao: Digito Verificador da Chave de ","Acesso da NF-e Referenciada invalido"}})
aadd(aMOTIVOS,{"548" ,{"Rejeicao: CNPJ da NF referenciada invalido."}})
aadd(aMOTIVOS,{"549" ,{"Rejeicao: CNPJ da NF referenciada ","de produtor invalido."}})
aadd(aMOTIVOS,{"550" ,{"Rejeicao: CPF da NF referenciada ","de produtor invalido."}})

aadd(aMOTIVOS,{"551" ,{"Rejeicao: IE da NF referenciada ","de produtor invalido."}})
aadd(aMOTIVOS,{"552" ,{"Rejeicao: Digito Verificador da Chave de ","Acesso do CT-e Referenciado invalido"}})
aadd(aMOTIVOS,{"553" ,{"Rejeicao: Tipo autorizador do recibo ","diverge do orgao Autorizador."}})
aadd(aMOTIVOS,{"554" ,{"Rejeicao: Serie difere da faixa 0-899"}})
aadd(aMOTIVOS,{"555" ,{"Rejeicao: Tipo autorizador do protocolo ","diverge do Orgao Autorizador."}})
aadd(aMOTIVOS,{"556" ,{"Rejeicao: Justificativa de entrada ","em contingencia nao deve ser informada ","para tipo de emissao normal."}})
aadd(aMOTIVOS,{"557" ,{"Rejeicao: A Justificativa de ","entrada em contingencia deve ser informada."}})
aadd(aMOTIVOS,{"558" ,{"Rejeicao: Data de entrada em ","contingencia posterior a data de emissao."}})
aadd(aMOTIVOS,{"559" ,{"Rejeicao: UF do Transportador ","nao informada"}})
aadd(aMOTIVOS,{"560" ,{"Rejeicao: CNPJ base do emitente ","difere do CNPJ base da primeira ","NF-e do lote recebido"}})

aadd(aMOTIVOS,{"561" ,{"Rejeicao: Mes de Emissao informado na ","Chave de Acesso difere do ","Mes de Emissao da NFe"}})
aadd(aMOTIVOS,{"562" ,{"Rejeicao: Codigo Numerico informado na ","Chave de Acesso difere do ","Codigo Numerico da NF-e"}})
aadd(aMOTIVOS,{"563" ,{"Rejeicao: Ja existe pedido de Inutilizacao com a mesma faixa de inutilizacao"}})
aadd(aMOTIVOS,{"564" ,{"Rejeicao: Total do Produto / Servico difere ","do somatorio dos itens"}})
aadd(aMOTIVOS,{"565" ,{"Rejeicao: Falha no schema XML - inexiste a ","tag raiz esperada para o lote de NF-e"}})
aadd(aMOTIVOS,{"567" ,{"Rejeicao: Falha no schema XML - versao ","informada na versaoDados do ","SOAPHeader diverge da versao do lote de NF-e"}})
aadd(aMOTIVOS,{"568" ,{"Rejeicao: Falha no schema XML - inexiste ","atributo versao na tag raiz do ","lote de NF-e CODIGO MOTIVOS DE DENEGACAO DE USO"}})
aadd(aMOTIVOS,{"569" ,{"Rejeicao: Data de entrada em ","contingencia muito atrasada"}})
aadd(aMOTIVOS,{"570" ,{"Rejeicao: Tipo de Emissao 3, 6 ou 7 ","so e valido nas contingencias SCAN/SVC"}})

aadd(aMOTIVOS,{"571" ,{"Rejeicao: O tpEmis informado diferente ","de 3 para contingencia SCAN"}})
aadd(aMOTIVOS,{"572" ,{"Rejeicao: Erro Atributo ID do evento ","nao corresponde a concatenacao dos ","campos ('ID' + tpEvento + chNFe + nSeqEvento)"}})
aadd(aMOTIVOS,{"573" ,{"Rejeicao: Duplicidade de Evento"}})
aadd(aMOTIVOS,{"574" ,{"Rejeicao: O autor do evento ","diverge do emissor da NF-e"}})
aadd(aMOTIVOS,{"575" ,{"Rejeicao: O autor do evento ","diverge do destinatario da NF-e"}})
aadd(aMOTIVOS,{"576" ,{"Rejeicao: O autor do evento nao e ","um orgao autorizado a gerar o evento"}})
aadd(aMOTIVOS,{"577" ,{"Rejeicao: A data do evento nao pode ","ser menor que a data de emissao da NF-e"}})
aadd(aMOTIVOS,{"578" ,{"Rejeicao: A data do evento nao pode ","ser maior que a data do processamento"}})
aadd(aMOTIVOS,{"579" ,{"Rejeicao: A data do evento nao pode ","ser menor que a data de ","autorizacao para NF-e nao emitida em contingencia"}})
aadd(aMOTIVOS,{"580" ,{"Rejeicao: O evento exige uma NF-e autorizada"}})

aadd(aMOTIVOS,{"587" ,{"Rejeicao: Usar somente o ","namespace padrao da NF-e"}})
aadd(aMOTIVOS,{"588" ,{"Rejeicao: Nao e permitida a ","presença de caracteres de edicao ","no inicio/fim da mensagem ou entre as tags da mensagem"}})
aadd(aMOTIVOS,{"589" ,{"Rejeicao: Número do NSU informado ","superior ao maior NSU da base de dados da SEFAZ"}})
aadd(aMOTIVOS,{"590" ,{"Rejeicao: Informado CST para emissor ","do Simples Nacional (CRT=1)"}})

aadd(aMOTIVOS,{"591" ,{"Rejeicao: Informado CSOSN para emissor ","que nao e do Simples Nacional (CRT diferente de 1)"}})
aadd(aMOTIVOS,{"592" ,{"Rejeicao: A NF-e deve ter pelo menos um ","item de produto sujeito ao ICMS"}})
aadd(aMOTIVOS,{"593" ,{"Rejeicao: CNPJ-Base consultado difere do ","CNPJ-Base do Certificado Digital"}})
aadd(aMOTIVOS,{"594" ,{"Rejeicao: O número de sequencia do evento ","informado e maior que o permitido"}})
aadd(aMOTIVOS,{"595" ,{"Rejeicao: Obrigatoria a informacao ","da justificativa do evento."}})
aadd(aMOTIVOS,{"596" ,{"Rejeicao: Evento apresentado fora ","do prazo: [prazo vigente]"}})
aadd(aMOTIVOS,{"597" ,{"Rejeicao: CFOP de Importacao e nao ","informado dados de IPI"}})
aadd(aMOTIVOS,{"598" ,{"Rejeicao: NF-e emitida em ambiente ","de homologacao com Razao Social ","do destinatario diferente de NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL"}})
aadd(aMOTIVOS,{"599" ,{"Rejeicao: CFOP de Importacao e","nao informado dados de II"}})
aadd(aMOTIVOS,{"600" ,{"Rejeicao: CSOSN incompativel na","operacao com Nao Contribuinte [nItem: 999]"}})

aadd(aMOTIVOS,{"601" ,{"Rejeicao: Total do II difere ","do somatorio dos itens"}})
aadd(aMOTIVOS,{"602" ,{"Rejeicao: Total do PIS difere do ","somatorio dos itens sujeitos ao ICMS"}})
aadd(aMOTIVOS,{"603" ,{"Rejeicao: Total do COFINS difere ","do somatorio dos itens sujeitos ao ICMS"}})
aadd(aMOTIVOS,{"604" ,{"Rejeicao: Total do vOutro difere ","do somatorio dos itens"}})
aadd(aMOTIVOS,{"605" ,{"Rejeicao: Total do vISS difere do ","somatorio do vProd dos itens sujeitos ao ISSQN"}})
aadd(aMOTIVOS,{"606" ,{"Rejeicao: Total do vBC do ISS ","difere do somatorio dos itens"}})
aadd(aMOTIVOS,{"607" ,{"Rejeicao: Total do ISS difere ","do somatorio dos itens"}})
aadd(aMOTIVOS,{"608" ,{"Rejeicao: Total do PIS difere do ","somatorio dos itens sujeitos ao ISSQN"}})
aadd(aMOTIVOS,{"609" ,{"Rejeicao: Total do COFINS difere do ","somatorio dos itens sujeitos ao ISSQN"}})
aadd(aMOTIVOS,{"610" ,{"Rejeicao: Total da NF difere do somatorio ","dos Valores compõe o valor Total da NF."}})

aadd(aMOTIVOS,{"611" ,{"Rejeicao: cEAN invalido"}})
aadd(aMOTIVOS,{"612" ,{"Rejeicao: cEANTrib invalido"}})
aadd(aMOTIVOS,{"613" ,{"Rejeicao: Chave de Acesso ","difere da existente em BD"}})
aadd(aMOTIVOS,{"614" ,{"Rejeicao: Chave de Acesso ","invalida (Codigo UF invalido)"}})
aadd(aMOTIVOS,{"615" ,{"Rejeicao: Chave de Acesso ","invalida (Ano menor que 06 ou Ano ","maior que Ano corrente)"}})
aadd(aMOTIVOS,{"616" ,{"Rejeicao: Chave de Acesso ","invalida (Mes menor que 1 ou Mes maior que 12)"}})
aadd(aMOTIVOS,{"617" ,{"Rejeicao: Chave de Acesso ","invalida (CNPJ zerado ou digito invalido)"}})
aadd(aMOTIVOS,{"618" ,{"Rejeicao: Chave de Acesso ","invalida (modelo diferente de 55 e 65)"}})
aadd(aMOTIVOS,{"619" ,{"Rejeicao: Chave de Acesso ","invalida (número NF = 0)"}})
aadd(aMOTIVOS,{"620" ,{"Rejeicao: Chave de Acesso ","difere da existente em BD"}})

aadd(aMOTIVOS,{"621" ,{"Rejeicao: CPF Emitente ","nao cadastrado"}})
aadd(aMOTIVOS,{"622" ,{"Rejeicao: IE emitente ","nao vinculada ao CPF"}})
aadd(aMOTIVOS,{"623" ,{"Rejeicao: CPF Destinatario ","nao cadastrado"}})
aadd(aMOTIVOS,{"624" ,{"Rejeicao: IE Destinatario ","nao vinculada ao CPF"}})
aadd(aMOTIVOS,{"625" ,{"Rejeicao: Inscricao SUFRAMA ","deve ser informada na venda ","com isencao para ZFM"}})
aadd(aMOTIVOS,{"626" ,{"Rejeicao: CFOP de operacao ","isenta para ZFM ","diferente do previsto"}})
aadd(aMOTIVOS,{"627" ,{"Rejeicao: O valor do ICMS ","desonerado deve ser informado"}})
aadd(aMOTIVOS,{"628" ,{"Rejeicao: Total da NF superior ","ao valor limite estabelecido ","pela SEFAZ [Limite]"}})
aadd(aMOTIVOS,{"629" ,{"Rejeicao: Valor do Produto difere do ","produto Valor Unitario de ","Comercializacao e Quantidade Comercial"}})
aadd(aMOTIVOS,{"630" ,{"Rejeicao: Valor do Produto difere do ","produto Valor Unitario de ","Tributacao e Quantidade Tributavel"}})

aadd(aMOTIVOS,{"631" ,{"Rejeicao: CNPJ-Base do Destinatario ","difere do CNPJ-Base do Certificado Digital"}})
aadd(aMOTIVOS,{"632" ,{"Rejeicao: Solicitacao fora de prazo, ","a NF-e nao esta mais ","disponivel para download"}})
aadd(aMOTIVOS,{"633" ,{"Rejeicao: NF-e indisponivel para ","download devido a ausencia de ","Manifestacao do Destinatario"}})
aadd(aMOTIVOS,{"634" ,{"Rejeicao: Destinatario da NF-e nao tem","o mesmo CNPJ raiz do ","solicitante do download"}})
aadd(aMOTIVOS,{"635" ,{"Rejeicao: NF-e com mesmo número e serie","ja transmitida e ","aguardando processamento"}})
aadd(aMOTIVOS,{"636" ,{"Rejeicao: O tipo do evento de cancelamento","nao corresponde ao tipo do","evento a ser cancelado"}})
aadd(aMOTIVOS,{"638" ,{"Rejeicao: A quantidade de Pedidos de","Prorrogacao 1º prazo excede o valor","limite de 20 Pedidos de Prorrogacao","autorizados e sem resposta do Fisco"}})
aadd(aMOTIVOS,{"639" ,{"Rejeicao: A quantidade de Pedidos de","Prorrogacao 2º prazo excede o valor","limite de 20 Pedidos de Prorrogacao","autorizados e sem resposta do Fisco"}})
aadd(aMOTIVOS,{"640" ,{"Rejeicao: CNPJ/CPF do interessado nao","possui permissao para consultar esta NF-e"}})

aadd(aMOTIVOS,{"640" ,{"Rejeicao: ID do Pedido de","Prorrogacao invalido"}})
aadd(aMOTIVOS,{"641" ,{"Rejeicao: A data do evento nao pode","ser menor que a data de autorizacao","para o evento"}})
aadd(aMOTIVOS,{"641" ,{"Rejeicao: NF-e indisponivel para o emitente"}})
aadd(aMOTIVOS,{"650" ,{"Rejeicao: Evento de 'Ciencia da Emissao' ","para NF-e Cancelada ou Denegada"}})
aadd(aMOTIVOS,{"651" ,{"Rejeicao: Evento de 'Desconhecimento da ","Operacao' para NF-e Cancelada ou Denegada"}})
aadd(aMOTIVOS,{"652" ,{"Rejeicao: NF-e para emitente pessoa fisica"}})
aadd(aMOTIVOS,{"653" ,{"Rejeicao: NF-e Cancelada, arquivo ","indisponivel para download"}})
aadd(aMOTIVOS,{"654" ,{"Rejeicao: NF-e Denegada, arquivo ","indisponivel para download ","Nota Fiscal Eletrônica"}})
aadd(aMOTIVOS,{"655" ,{"Rejeicao: Evento de Ciencia da ","Emissao informado apos a manifestacao ","final do destinatario"}})
aadd(aMOTIVOS,{"656" ,{"Rejeicao: Consumo Indevido"}})
aadd(aMOTIVOS,{"657" ,{"Rejeicao: Codigo do orgao diverge ","do orgao autorizador"}})
aadd(aMOTIVOS,{"658" ,{"Rejeicao: UF do destinatario da","Chave de Acesso diverge da UF autorizadora"}})
aadd(aMOTIVOS,{"659" ,{"Rejeicao: Ano-Mes da Data de Emissao","diverge do Ano_Mes da Chave de Acesso"}})
aadd(aMOTIVOS,{"660" ,{"Rejeicao: CFOP de Combustivel e ","nao informado grupo de combustivel da NF-e"}})
aadd(aMOTIVOS,{"661" ,{"Rejeicao: NF-e ja existente para ","o número do EPEC informado"}})
aadd(aMOTIVOS,{"662" ,{"Rejeicao: Numeracao do EPEC esta ","inutilizada na Base de Dados da SEFAZ"}})
aadd(aMOTIVOS,{"663" ,{"Rejeicao: Aliquota do ICMS com ","valor superior a 4 por cento na ","operacao de saida interestadual ","com produtos importados"}})
aadd(aMOTIVOS,{"678" ,{"Rejeicao: NF referenciada com ","UF diferente da NF-e complementar"}})
aadd(aMOTIVOS,{"679" ,{"Rejeicao: Modelo da NF-e ","referenciada diferente de 55/65"}})
aadd(aMOTIVOS,{"680" ,{"Rejeicao: Duplicidade de NF-e ","referenciada (Chave de Acesso ","referenciada mais de uma vez)"}})
aadd(aMOTIVOS,{"681" ,{"Rejeicao: Duplicidade de NF Modelo 1 ","referenciada ","(CNPJ, Modelo, Serie e Número)"}})
aadd(aMOTIVOS,{"682" ,{"Rejeicao: Duplicidade de NF de Produtor ","referenciada ","(IE, Modelo, Serie e Número)"}})
aadd(aMOTIVOS,{"683" ,{"Rejeicao: Modelo do CT-e ","referenciado diferente de 57"}})
aadd(aMOTIVOS,{"684" ,{"Rejeicao: Duplicidade de ","Cupom Fiscal referenciado ","(Modelo, Número de Ordem e COO)"}})
aadd(aMOTIVOS,{"685" ,{"Rejeicao: Total do Valor Aproximado ","dos Tributos difere do somatorio dos itens"}})
aadd(aMOTIVOS,{"686" ,{"Rejeicao: NF Complementar ","referencia uma NF-e cancelada"}})
aadd(aMOTIVOS,{"687" ,{"Rejeicao: NF Complementar ","referencia uma NF-e denegada"}})
aadd(aMOTIVOS,{"688" ,{"Rejeicao: NF referenciada de ","Produtor com IE inexistente [nRef: xxx]"}})
aadd(aMOTIVOS,{"689" ,{"Rejeicao: NF referenciada de ","Produtor com IE nao vinculada ao ","CNPJ/CPF informado [nRef: xxx]"}})
aadd(aMOTIVOS,{"690" ,{"Rejeicao: Pedido de Cancelamento","para NF-e com CT-e"}})
aadd(aMOTIVOS,{"691" ,{"Rejeicao: Chave de Acesso da NF-e","diverge da Chave de Acesso do EPEC"}})

aadd(aMOTIVOS,{"692" ,{"Rejeicao: Existe EPEC registrado para","esta Serie e Número [Chave EPEC: xxxxxxxxxxx]"}})
aadd(aMOTIVOS,{"693" ,{"Rejeicao: Aliquota de ICMS superior","à definida para a operacao","interestadual [nItem: 999]"}})
aadd(aMOTIVOS,{"694" ,{"Rejeicao: Nao informado o grupo","de ICMS para a UF de destino [nItem: 999]"}})
aadd(aMOTIVOS,{"695" ,{"Rejeicao: Informado indevidamente","o grupo de ICMS para a UF de","destino [nItem:999]"}})
aadd(aMOTIVOS,{"696" ,{"Rejeicao: Operacao com nao contribuinte","deve indicar operacao com consumidor final"}})
aadd(aMOTIVOS,{"697" ,{"Rejeicao: Aliquota interestadual","do ICMS com origem diferente","do previsto [nItem:999]"}})
aadd(aMOTIVOS,{"698" ,{"Rejeicao: Aliquota interestadual do","ICMS incompativel com as UF envolvidas","na operacao [nItem:999]"}})
aadd(aMOTIVOS,{"699" ,{"Rejeicao: Percentual do ICMS Interestadual","para a UF de destino difere do previsto para","o ano da Data de Emissao [nItem: 999]"}})

aadd(aMOTIVOS,{"700" ,{"Rejeicao: Mensagem de Lote ","versao 3.xx. Enviar para o Web ","Service nfeAutorizacao"}})
aadd(aMOTIVOS,{"701" ,{"Rejeicao: NF-e nao pode ","utilizar a versao 3.00"}})
aadd(aMOTIVOS,{"702" ,{"Rejeicao: NFC-e nao e aceita ","pela UF do Emitente"}})
aadd(aMOTIVOS,{"703" ,{"Rejeicao: Data-Hora de Emissao ","posterior ao horario de recebimento"}})
aadd(aMOTIVOS,{"704" ,{"Rejeicao: NFC-e com Data-Hora ","de emissao atrasada"}})
aadd(aMOTIVOS,{"705" ,{"Rejeicao: NFC-e com data ","de entrada/saida"}})
aadd(aMOTIVOS,{"706" ,{"Rejeicao: NFC-e para ","operacao de entrada"}})
aadd(aMOTIVOS,{"707" ,{"Rejeicao: NFC-e para operacao ","interestadual ou com o exterior"}})
aadd(aMOTIVOS,{"708" ,{"Rejeicao: NFC-e nao pode ","referenciar documento fiscal"}})
aadd(aMOTIVOS,{"709" ,{"Rejeicao: NFC-e com formato ","de DANFE invalido"}})
aadd(aMOTIVOS,{"710" ,{"Rejeicao: NF-e com formato ","de DANFE invalido"}})
aadd(aMOTIVOS,{"711" ,{"Rejeicao: NF-e com ","contingencia off-line"}})
aadd(aMOTIVOS,{"712" ,{"Rejeicao: NFC-e com ","contingencia off-line para a UF"}})
aadd(aMOTIVOS,{"713" ,{"Rejeicao: Tipo de Emissao ","diferente de 6 ou 7 para ","contingencia da SVC acessada"}})
aadd(aMOTIVOS,{"714" ,{"Rejeicao: NFC-e com contingencia ","DPEC inexistente"}})
aadd(aMOTIVOS,{"715" ,{"Rejeicao: NFC-e com finalidade invalida"}})
aadd(aMOTIVOS,{"716" ,{"Rejeicao: NFC-e em operacao nao ","destinada a consumidor final"}})
aadd(aMOTIVOS,{"717" ,{"Rejeicao: NFC-e em operacao ","nao presencial"}})
aadd(aMOTIVOS,{"718" ,{"Rejeicao: NFC-e nao deve informar ","IE de Substituto Tributario"}})
aadd(aMOTIVOS,{"719" ,{"Rejeicao: NF-e sem a identificacao ","do destinatario"}})
aadd(aMOTIVOS,{"720" ,{"Rejeicao: Na operacao com Exterior ","deve ser informada tag idEstrangeiro"}})
aadd(aMOTIVOS,{"721" ,{"Rejeicao: Operacao interestadual deve ","informar CNPJ ou CPF."}})
aadd(aMOTIVOS,{"722" ,{"Rejeicao: CFOP de Transporte Inexistente"}})
aadd(aMOTIVOS,{"723" ,{"Rejeicao: Operacao interna com ","idEstrangeiro informado deve ","ser para consumidor final"}})
aadd(aMOTIVOS,{"724" ,{"Rejeicao: NF-e sem o ","nome do destinatario"}})
aadd(aMOTIVOS,{"725" ,{"Rejeicao: NFC-e com ","CFOP invalido"}})
aadd(aMOTIVOS,{"726" ,{"Rejeicao: NF-e sem a ","informacao de endereço do destinatario"}})
aadd(aMOTIVOS,{"727" ,{"Rejeicao: Operacao com ","Exterior e UF diferente de EX"}})
aadd(aMOTIVOS,{"728" ,{"Rejeicao: NF-e sem informacao ","da IE do destinatario"}})
aadd(aMOTIVOS,{"729" ,{"Rejeicao: NFC-e com informacao ","da IE do destinatario"}})
aadd(aMOTIVOS,{"730" ,{"Rejeicao: NFC-e com ","Inscricao Suframa"}})
aadd(aMOTIVOS,{"731" ,{"Rejeicao: CFOP de operacao ","com Exterior e idDest <> 3"}})
aadd(aMOTIVOS,{"732" ,{"Rejeicao: CFOP de operacao ","interestadual e idDest <> 2"}})
aadd(aMOTIVOS,{"733" ,{"Rejeicao: CFOP de operacao ","interna e idDest <> 1"}})
aadd(aMOTIVOS,{"734" ,{"Rejeicao: NFC-e com Unidade ","de Comercializacao invalida"}})
aadd(aMOTIVOS,{"735" ,{"Rejeicao: NFC-e com Unidade ","de Tributacao invalida"}})
aadd(aMOTIVOS,{"736" ,{"Rejeicao: NFC-e com grupo de ","Veiculos novos"}})
aadd(aMOTIVOS,{"737" ,{"Rejeicao: NFC-e com grupo ","de Medicamentos"}})
aadd(aMOTIVOS,{"738" ,{"Rejeicao: NFC-e com grupo ","de Armamentos"}})
aadd(aMOTIVOS,{"739" ,{"Rejeicao: NFC-e com grupo ","de Combustivel"}})
aadd(aMOTIVOS,{"740" ,{"Rejeicao: NFC-e com CST ","51-Diferimento"}})
aadd(aMOTIVOS,{"741" ,{"Rejeicao: NFC-e com Partilha ","de ICMS entre UF"}})
aadd(aMOTIVOS,{"742" ,{"Rejeicao: NFC-e com ","grupo do IPI"}})
aadd(aMOTIVOS,{"743" ,{"Rejeicao: NFC-e com ","grupo do II"}})
aadd(aMOTIVOS,{"745" ,{"Rejeicao: NF-e sem ","grupo do PIS"}})
aadd(aMOTIVOS,{"746" ,{"Rejeicao: NFC-e com ","grupo do PIS-ST"}})
aadd(aMOTIVOS,{"748" ,{"Rejeicao: NF-e sem ","grupo da COFINS"}})
aadd(aMOTIVOS,{"749" ,{"Rejeicao: NFC-e com ","grupo da COFINS-ST"}})
aadd(aMOTIVOS,{"750" ,{"Rejeicao: NFC-e com valor total ","superior ao permitido para ","destinatario nao identificado (Codigo) [Limite]"}})
aadd(aMOTIVOS,{"751" ,{"Rejeicao: NFC-e com valor total ","superior ao permitido para ","destinatario nao identificado (Nome) [Limite]"}})
aadd(aMOTIVOS,{"752" ,{"Rejeicao: NFC-e com valor total ","superior ao permitido para ","destinatario nao identificado (Endereço) [Limite]"}})
aadd(aMOTIVOS,{"753" ,{"Rejeicao: NFC-e com Frete"}})
aadd(aMOTIVOS,{"754" ,{"Rejeicao: NFC-e com ","dados do Transportador"}})
aadd(aMOTIVOS,{"755" ,{"Rejeicao: NFC-e com ","dados de Retencao do ICMS no Transporte"}})
aadd(aMOTIVOS,{"756" ,{"Rejeicao: NFC-e com ","dados do veiculo de Transporte"}})
aadd(aMOTIVOS,{"757" ,{"Rejeicao: NFC-e com ","dados de Reboque do veiculo de Transporte"}})
aadd(aMOTIVOS,{"758" ,{"Rejeicao: NFC-e com ","dados do Vagao de Transporte"}})
aadd(aMOTIVOS,{"759" ,{"Rejeicao: NFC-e com ","dados da Balsa de Transporte"}})
aadd(aMOTIVOS,{"760" ,{"Rejeicao: NFC-e com ","dados de cobrança (Fatura, Duplicata)"}})
aadd(aMOTIVOS,{"761" ,{"Rejeicao: Codigo de ","Produto ANP inexistente [nItem: 999]"}})
aadd(aMOTIVOS,{"762" ,{"Rejeicao: NFC-e com ","dados de compras (Empenho, Pedido, Contrato)"}})
aadd(aMOTIVOS,{"763" ,{"Rejeicao: NFC-e com ","dados de aquisicao de Cana"}})
aadd(aMOTIVOS,{"764" ,{"Rejeicao: Solicitada ","resposta sincrona para Lote com ","mais de uma NF-e (indSinc=1)"}})
aadd(aMOTIVOS,{"765" ,{"Rejeicao: Lote so podera ","conter NF-e ou NFC-e"}})
aadd(aMOTIVOS,{"766" ,{"Rejeicao: NFC-e com ","CST 50-Suspensao"}})
aadd(aMOTIVOS,{"767" ,{"Rejeicao: NFC-e com ","somatorio dos pagamentos diferente ","do total da Nota Fiscal"}})
aadd(aMOTIVOS,{"768" ,{"Rejeicao: NF-e nao deve possuir ","o grupo de Formas de Pagamento"}})
aadd(aMOTIVOS,{"769" ,{"Rejeicao: A criterio da UF NFC-e ","deve possuir o grupo de ","Formas de Pagamento"}})
aadd(aMOTIVOS,{"770" ,{"Rejeicao: NFC-e autorizada ","ha mais de 24 horas."}})
aadd(aMOTIVOS,{"771" ,{"Rejeicao: Operacao Interestadual ","e UF de destino com EX"}})
aadd(aMOTIVOS,{"772" ,{"Rejeicao: Operacao Interestadual ","e UF de destino igual à UF do emitente"}})
aadd(aMOTIVOS,{"773" ,{"Rejeicao: Operacao Interna e UF ","de destino difere da UF do emitente"}})
aadd(aMOTIVOS,{"774" ,{"Rejeicao: NFC-e com indicador de ","item nao participante do total"}})
aadd(aMOTIVOS,{"775" ,{"Rejeicao: Modelo da NFC-e ","diferente de 65"}})
aadd(aMOTIVOS,{"776" ,{"Rejeicao: Solicitada resposta ","sincrona para UF que nao disponibiliza ","este atendimento (indSinc=1)"}})
aadd(aMOTIVOS,{"777" ,{"Rejeicao: Obrigatoria a ","informacao do NCM completo"}})
aadd(aMOTIVOS,{"778" ,{"Rejeicao: Informado NCM inexistente"}})
aadd(aMOTIVOS,{"779" ,{"Rejeicao: NFC-e com NCM incompativel"}})
aadd(aMOTIVOS,{"780" ,{"Rejeicao: Total da NFC-e ","superior ao valor limite estabelecido ","pela SEFAZ [Limite]"}})
aadd(aMOTIVOS,{"781" ,{"Rejeicao: Emissor nao habilitado ","para emissao da NFC-e"}})
aadd(aMOTIVOS,{"782" ,{"Rejeicao: NFC-e nao e autorizada ","pelo SCAN"}})
aadd(aMOTIVOS,{"783" ,{"Rejeicao: NFC-e nao e autorizada ","pela SVC"}})
aadd(aMOTIVOS,{"784" ,{"Rejeicao: NFC-e nao permite ","o evento de Carta de Correcao"}})
aadd(aMOTIVOS,{"785" ,{"Rejeicao: NFC-e com entrega ","a domicilio nao permitida pela UF"}})
aadd(aMOTIVOS,{"786" ,{"Rejeicao: NFC-e de entrega a ","domicilio sem dados do Transportador"}})
aadd(aMOTIVOS,{"787" ,{"Rejeicao: NFC-e de entrega a ","domicilio sem a identificacao do destinatario"}})
aadd(aMOTIVOS,{"788" ,{"Rejeicao: NFC-e de entrega a ","domicilio sem o endereço do destinatario"}})
aadd(aMOTIVOS,{"789" ,{"Rejeicao: NFC-e para destinatario contribuinte de ICMS"}})
aadd(aMOTIVOS,{"790" ,{"Rejeicao: Operacao com Exterior ","para destinatario Contribuinte de ICMS"}})
aadd(aMOTIVOS,{"791" ,{"Rejeicao: NF-e com indicacao de ","destinatario isento de IE, com a informacao ","da IE do destinatario"}})
aadd(aMOTIVOS,{"792" ,{"Rejeicao: Informada a IE do ","destinatario para operacao ","com destinatario no Exterior"}})
aadd(aMOTIVOS,{"793" ,{"Rejeicao: Informado Capitulo ","do NCM inexistente"}})
aadd(aMOTIVOS,{"794" ,{"Rejeicao: NF-e com indicativo ","de NFC-e com entrega a domicilio"}})
aadd(aMOTIVOS,{"795" ,{"Rejeicao: Total do ICMS desonerado ","difere do somatorio dos itens"}})
aadd(aMOTIVOS,{"796" ,{"Rejeicao: Empresa sem Chave de","Segurança para o QR-Code"}})
aadd(aMOTIVOS,{"798" ,{"Rejeicao: Valor total do ICMS","relativo Fundo de Combate","à Pobreza (FCP) da UF de destino","difere do somatorio do valor dos itens"}})
aadd(aMOTIVOS,{"799" ,{"Rejeicao: Valor total do ICMS Interestadual","da UF de destino difere do somatorio dos itens"}})
aadd(aMOTIVOS,{"800" ,{"Rejeicao: Valor total do ICMS Interestadual","da UF do remetente difere do somatorio dos itens"}})
aadd(aMOTIVOS,{"805" ,{"Rejeicao: A SEFAZ do destinatario nao permite","Contribuinte Isento de Inscricao Estadual"}})
aadd(aMOTIVOS,{"806" ,{"Rejeicao: Operacao com ICMS-ST sem","informacao do CEST [nItem: 999]"}})
aadd(aMOTIVOS,{"807" ,{"Rejeicao: NFC-e com grupo de ICMS","para a UF do destinatario"}})
aadd(aMOTIVOS,{"811" ,{"Rejeicao: Pedido de Prorrogacao deferido","impede o cancelamento da NF-e"}})
aadd(aMOTIVOS,{"812" ,{"Rejeicao: Regime Tributario SN, com excesso","de sublimite nao e permitido para","Emitentes desta UF"}})
aadd(aMOTIVOS,{"813" ,{"Rejeicao: QR-Code com sequencia de escape","para o e-comercial. Usar CDATA"}})
aadd(aMOTIVOS,{"814" ,{"Rejeicao: Nota Fiscal com grupo de comercio exterior"}})
aadd(aMOTIVOS,{"815" ,{"Rejeicao: Valor do ICMS Interestadual para","UF de Destino difere do calculado","[nItem: 999] (Valor Informado: XXX, Valor Calculado:XXX)"}})
aadd(aMOTIVOS,{"816" ,{"Rejeicao: Valor do ICMS Interestadual para","UF do Remetente difere do calculado","[nItem: 999] (Valor Informado: XXX, Valor Calculado:XXX)"}})
aadd(aMOTIVOS,{"817" ,{"Rejeicao: Unidade Tributavel incompativel","com o NCM informado na operacao com","Comercio Exterior [nItem: 999]"}})
aadd(aMOTIVOS,{"827" ,{"Rejeicao: Obrigatorio informar","o tipo de autorizacao"}})
aadd(aMOTIVOS,{"828" ,{"Rejeicao: Nao permitido informar","o campo tipo de autorizacao"}})
aadd(aMOTIVOS,{"829" ,{"Rejeicao: Condicao de uso nao informado","para o tipo de autorizacao de uso"}})
aadd(aMOTIVOS,{"830" ,{"Rejeicao: Nao permitido preencher","o campo Condicao de Uso"}})

aadd(aMOTIVOS,{"840" ,{"Rejeicao: NCM de medicamento e nao","informado o grupo de medicamento (med) [nItem:nnn]"}})
aadd(aMOTIVOS,{"841" ,{"Rejeicao: Codigo do Tipo de","Veiculo Inexistente"}})
aadd(aMOTIVOS,{"842" ,{"Rejeicao: Codigo da especie","de Veiculo Inexistente"}})
aadd(aMOTIVOS,{"843" ,{"Rejeicao: Codigo da especie de","Veiculo incompativel com o tipo do Veiculo."}})
aadd(aMOTIVOS,{"844" ,{"Rejeicao: Codigo de Item da Lista","de Serviços inexistente."}})
aadd(aMOTIVOS,{"845" ,{"Rejeicao: O Grupo Transportador nao","pode ser preenchido para Modalidade","do frete informada"}})
aadd(aMOTIVOS,{"846" ,{"Rejeicao: Transporte proprio por conta","do Remetente e CNPJ Base","ou CPF do Transportador difere do","CNPJ Base ou CPF do Remetente"}})
aadd(aMOTIVOS,{"847" ,{"Rejeicao: Transporte nao e proprio por","conta do Remetente e CNPJ Base","ou CPF do Transportador igual ao","CNPJ Base ou CPF do Remetente"}})
aadd(aMOTIVOS,{"848" ,{"Rejeicao: Transporte proprio por conta","do Destinatario e CNPJ Base ou","CPF do Transportador difere do","CNPJ Base ou CPF do Destinatario"}})
aadd(aMOTIVOS,{"849" ,{"Rejeicao: Transporte nao e proprio por","conta do Destinatario e CNPJ Base","CPF do Transportador igual ao","CNPJ Base ou CPF do Destinatario"}})
aadd(aMOTIVOS,{"850" ,{"Rejeicao: Data de vencimento da parcela","nao informada ou menor que a Data de","vencimento da parcela anterior [nOcor: 999]"}})
aadd(aMOTIVOS,{"851" ,{"Rejeicao: Soma do valor das parcelas","difere do Valor Liquido da Fatura"}})
aadd(aMOTIVOS,{"852" ,{"Rejeicao: Número da parcela invalido","ou nao informado [nOcor: 999]"}})
aadd(aMOTIVOS,{"854" ,{"Rejeicao: Unidade Tributavel (tag:uTrib)","incompativel com produto informado","[nItem: 999] Nota Fiscal Eletrônica"}})
aadd(aMOTIVOS,{"855" ,{"Rejeicao: Somatorio percentuais de GLP","derivado do petroleo, GLGNn","e GLGNi diferente de 100 [nItem: 999]."}})
aadd(aMOTIVOS,{"856" ,{"Rejeicao: Campo valor de partida nao preenchido","para produto GLP [nItem: 999]."}})
aadd(aMOTIVOS,{"857" ,{"Rejeicao: Informado Duplicata Mercantil","como Forma de Pagamento"}})
aadd(aMOTIVOS,{"858" ,{"Rejeicao: Grupo de Tributacao informado","indevidamente [nItem: 999]"}})
aadd(aMOTIVOS,{"859" ,{"Rejeicao: Total do FCP retido anteriormente","por Substituicao Tributaria difere","do somatorio dos itens"}})
aadd(aMOTIVOS,{"860" ,{"Rejeicao: Valor do FCP informado difere","de base de calculo*aliquota [nItem: 999]"}})
aadd(aMOTIVOS,{"861" ,{"Rejeicao: Total do FCP difere","do somatorio dos itens"}})
aadd(aMOTIVOS,{"862" ,{"Rejeicao: Total do FCP ST difere","do somatorio dos itens"}})
aadd(aMOTIVOS,{"863" ,{"Rejeicao: Total do IPI devolvido","difere do somatorio dos itens"}})
aadd(aMOTIVOS,{"864" ,{"Rejeicao: NF-e com indicativo de","Operacao presencial, fora do estabelecimento","e nao informada NF referenciada"}})
aadd(aMOTIVOS,{"865" ,{"Rejeicao: Total dos pagamentos","menor que o total da nota"}})
aadd(aMOTIVOS,{"866" ,{"Rejeicao: Ausencia de troco quando","o valor dos pagamentos informados","for maior que o total da nota"}})
aadd(aMOTIVOS,{"868" ,{"Rejeicao: Grupos Veiculo Transporte","e Reboque nao devem ser informados"}})
aadd(aMOTIVOS,{"869" ,{"Rejeicao: Valor do troco incorreto"}})
aadd(aMOTIVOS,{"870" ,{"Rejeicao: Data de validade incompativel","com data de fabricacao [nItem: 999]"}})
aadd(aMOTIVOS,{"871" ,{"Rejeicao: O campo Meio de Pagamento deve","ser preenchido com a opcao Sem Pagamento"}})
aadd(aMOTIVOS,{"873" ,{"Rejeicao: Operacao com medicamentos e nao","informado os campos de rastreabilidade [nItem: 999]"}})
aadd(aMOTIVOS,{"874" ,{"Rejeicao: Percentual de FCP invalido [nItem: 999]"}})
aadd(aMOTIVOS,{"875" ,{"Rejeicao: Percentual de FCPST invalido [nItem: 999]"}})
aadd(aMOTIVOS,{"876" ,{"Rejeicao: Operacao interestadual para","Consumidor Final e valor do FCP informado em","campo diferente de vFCPUFDest (id:NA13) [nItem: 999]"}})
aadd(aMOTIVOS,{"877" ,{"Rejeicao: Data de fabricacao maior","que a data de processamento [nItem: 999]"}})
aadd(aMOTIVOS,{"878" ,{"Rejeicao: Endereço do site da UF da","Consulta por chave de acesso","diverge do previsto"}})
aadd(aMOTIVOS,{"879" ,{"Rejeicao: Informado item 'Produzido em Escala NaO Relevante'","e nao informado CNPJ do Fabricante [nItem: 999]"}})
aadd(aMOTIVOS,{"880" ,{"Rejeicao: Percentual de FCP","igual a zero [nItem: 999]"}})
aadd(aMOTIVOS,{"881" ,{"Rejeicao: Percentual de FCPST","igual a zero [nItem: 999]"}})
aadd(aMOTIVOS,{"882" ,{"Rejeicao: GTIN (cEAN) com","prefixo invalido [nItem:999]"}})
aadd(aMOTIVOS,{"883" ,{"Rejeicao: GTIN (cEAN) sem","informacao [nItem: 999]"}})
aadd(aMOTIVOS,{"884" ,{"Rejeicao: GTIN da unidade tributavel (cEANTrib) com prefixo invalido [nItem:999]"}})
aadd(aMOTIVOS,{"885" ,{"Rejeicao: GTIN informado,","mas nao informado o GTIN da","unidade tributavel [nItem:999]"}})
aadd(aMOTIVOS,{"886" ,{"Rejeicao: GTIN da unidade","tributavel informado, mas nao","informado o GTIN [nItem:999]"}})
aadd(aMOTIVOS,{"888" ,{"Rejeicao: GTIN da unidade tributavel","(cEANTrib) sem informacao [nItem:999]"}})
aadd(aMOTIVOS,{"889" ,{"Rejeicao: Obrigatoria a informacao do","GTIN para o produto [nItem: 999]"}})
aadd(aMOTIVOS,{"890" ,{"Rejeicao: GTIN inexistente no Cadastro","Centralizado de GTIN (CCG) [nItem:999]"}})
aadd(aMOTIVOS,{"891" ,{"Rejeicao: GTIN incompativel com a NCM","[nItem:999; NCM esperada: 99999999]"}})
aadd(aMOTIVOS,{"892" ,{"Rejeicao: GTIN incompativel com CEST","[nItem:999; CEST esperado: 9999999]"}})
aadd(aMOTIVOS,{"893" ,{"Rejeicao: GTIN da unidade tributavel","diverge do GTIN Contido cadastrado","no CCG [nItem:999; GTIN Contido esperado: 99999999999999]"}})
aadd(aMOTIVOS,{"894" ,{"Rejeicao: GTIN da unidade tributavel","inexistente no Cadastro Centralizado","de GTIN (CCG) [nItem:999]"}})
aadd(aMOTIVOS,{"895" ,{"Rejeicao: GTIN da unidade tributavel","incompativel com a NCM [nItem:999;","NCM esperada: 99999999]"}})
aadd(aMOTIVOS,{"896" ,{"Rejeicao: GTIN da unidade tributavel","incompativel com CEST [nItem:999;","CEST esperado: 9999999]"}})
aadd(aMOTIVOS,{"899" ,{"Rejeicao: Informado incorretamente","o campo meio de pagamento"}})
aadd(aMOTIVOS,{"900" ,{"Rejeicao: Data de vencimento da","parcela nao informada ou menor","que Data de Emissao [nOcor: 999]"}})
aadd(aMOTIVOS,{"901" ,{"Rejeicao: Valor do Desconto da Fatura","maior que Valor Original da Fatura"}})
aadd(aMOTIVOS,{"902" ,{"Rejeicao: Valor Liquido da Fatura difere","do Valor Original menos o Valor do Desconto"}})
aadd(aMOTIVOS,{"903" ,{"Rejeicao: Versao informada no QR-Code ('100')","nao e mais valida para a data de emissao"}})
aadd(aMOTIVOS,{"904" ,{"Rejeicao: Informado indevidamente","campo valor de pagamento"}})
aadd(aMOTIVOS,{"905" ,{"Rejeicao: Campos do grupo","Fatura nao informados"}})
aadd(aMOTIVOS,{"906" ,{"Rejeicao: Nao informados os campos","para informações do ICMS Efetivo.","[nItem: nnn] [NT 2018.005]"}})
aadd(aMOTIVOS,{"910" ,{"Rejeicao: Chave de Acesso NF-e Substituta","invalida (<nome do campo>) [NT 2018.004]"}})
aadd(aMOTIVOS,{"911" ,{"Rejeicao: Chave de Acesso NF-e Substituta","incorreta (<nome do campo>) [NT 2018.004]"}})
aadd(aMOTIVOS,{"912" ,{"Rejeicao: NF-e Substituta","inexistente [NT 2018.004]"}})
aadd(aMOTIVOS,{"913" ,{"Rejeicao: NF-e Substituta Denegada","ou Cancelada [NT 2018.004]"}})
aadd(aMOTIVOS,{"914" ,{"Rejeicao: Data de emissao da NF-e","Substituta maior que 2 horas da data de emissao","da NF-e a ser cancelada [NT 2018.004]"}})
aadd(aMOTIVOS,{"915" ,{"Rejeicao: Valor total da NF-e Substituta","difere do valor da NF-e a ser cancelada [NT 2018.004]"}})
aadd(aMOTIVOS,{"916" ,{"Rejeicao: Valor total do ICMS da NF-e","Substituta difere do valor da NF-e a","ser cancelada [NT 2018.004]"}})
aadd(aMOTIVOS,{"917" ,{"Rejeicao: Identificacao do destinatario","da NF-e Substituta difere da identificacao do","destinatario da NF-e a ser cancelada. [NT 2018.004]"}})
aadd(aMOTIVOS,{"918" ,{"Rejeicao: Quantidade de itens da NF-e","Substituta difere da quantidade de itens","da NF-e a ser cancelada. [NT 2018.004]"}})
aadd(aMOTIVOS,{"919" ,{"Rejeicao: Item da NF-e Substituta difere","do mesmo item da NF-e a ser cancelada. [NT 2018.004]"}})
aadd(aMOTIVOS,{"920" ,{"Rejeicao: Tipo de Emissao invalido no","Cancelamento por Substituicao [NT 2018.004]"}})
aadd(aMOTIVOS,{"922" ,{"Rejeicao: Contranota de Produtor so pode","referenciar NF-e ou NF de Produtor","Modelo 4 [NT 2019.001]"}})
aadd(aMOTIVOS,{"923" ,{"Rejeicao: Referenciado documento de operacao","interna em operacao interestadual ou","com o exterior [NT 2019.001]"}})
aadd(aMOTIVOS,{"924" ,{"Rejeicao: Informado Cupom Fiscal","referenciado. [NT 2019.001]"}})
aadd(aMOTIVOS,{"925" ,{"Rejeicao: NF-e com identificacao","de estrangeiro e inscricao estadual informada","para destinatario [NT 2019.001]"}})
aadd(aMOTIVOS,{"926" ,{"Rejeicao: Operacao com Exterior e pais","de destino igual a Brasil. [NT 2019.001]"}})
aadd(aMOTIVOS,{"927" ,{"Rejeicao: Número do item fora da ordem","sequencial. [NT 2019.001]"}})
aadd(aMOTIVOS,{"928" ,{"Rejeicao: Informado codigo de beneficio","fiscal para CST sem beneficio","fiscal [nItem: nnn] [NT 2019.001]"}})
aadd(aMOTIVOS,{"929" ,{"Rejeicao: Informado CST de diferimento","sem as informações de diferimento","[nItem: nnn] [NT 2019.001]"}})
aadd(aMOTIVOS,{"930" ,{"Rejeicao: CST com beneficio fiscal e","nao informado o codigo de beneficio","fiscal [nItem: nnn] [NT 2019.001]"}})
aadd(aMOTIVOS,{"931" ,{"Rejeicao: CST nao corresponde ao tipo","de codigo de beneficio fiscal","[nItem: nnn] [NT 2019.001]"}})
aadd(aMOTIVOS,{"932" ,{"Rejeicao: Informada modalidade de","determinacao da BC da ST como MVA","e nao informado o campo pMVAST","[nItem: nnn] [NT 2019.001]"}})
aadd(aMOTIVOS,{"933" ,{"Rejeicao: Informada modalidade de","determinacao da BC da ST diferente","de MVA e informado o campo pMVAST","[nItem: nnn] [NT 2019.001]"}})
aadd(aMOTIVOS,{"934" ,{"Rejeicao: Nao informado valor do","ICMS desonerado ou o Motivo","de desoneracao [nItem: nnn] [NT 2019.001]"}})
aadd(aMOTIVOS,{"935" ,{"Rejeicao: Valor total da Base de","Calculo superior ao valor limite","estabelecido [Valor Limite: R$ XXX.XXX,XX]","(valor definido pela UF) [NT 2019.001]"}})
aadd(aMOTIVOS,{"936" ,{"Rejeicao: Razao Social do emitente","diverge do informado no cadastro da SEFAZ"}})
aadd(aMOTIVOS,{"938" ,{"Rejeicao: Nao informada BCST, pST e","ICMSST retido na operacao anterior","[nItem: 999] [NT 2018.005]"}})

aadd(aMOTIVOS,{"941" ,{"Rejeicao: Número do Regime especial invalido."}})
aadd(aMOTIVOS,{"942" ,{"Rejeicao: IE do local de","retirada nao cadastrada"}})
aadd(aMOTIVOS,{"943" ,{"Rejeicao: IE do local de","retirada nao vinculada ao CNPJ"}})
aadd(aMOTIVOS,{"944" ,{"Rejeicao: IE do local de","retirada nao vinculada ao CPF"}})
aadd(aMOTIVOS,{"945" ,{"Rejeicao: IE do local de","entrega nao cadastrada"}})

aadd(aMOTIVOS,{"946" ,{"Rejeicao: Informado codigo de beneficio","fiscal incorreto ou inexistente na UF [nItem: nnn]"}})

aadd(aMOTIVOS,{"947" ,{"Rejeicao: IE do local de","entrega nao vinculada ao CNPJ"}})
aadd(aMOTIVOS,{"948" ,{"Rejeicao: IE do local de","entrega nao vinculada ao CPF"}})
aadd(aMOTIVOS,{"949" ,{"Rejeicao: NFC-e sem preenchimento","das Informações Adicionais de Interesse do Fisco"}})
aadd(aMOTIVOS,{"950" ,{"Rejeicao: Informações Adicionais de","Interesse do Fisco abaixo do","tamanho minimo exigido pela UF."}})

aadd(aMOTIVOS,{"970" ,{"Rejeicao: Codigo de Pais inexistente","[local de retirada/entrega] [NT 2018.005]"}})
aadd(aMOTIVOS,{"971" ,{"Rejeicao: IE invalida [local de","retirada/entrega] [NT 2018.005]"}})
aadd(aMOTIVOS,{"972" ,{"Rejeicao: Obrigatoria as informações","do responsavel tecnico [NT 2018.005]"}})
aadd(aMOTIVOS,{"973" ,{"Rejeicao: CNPJ do responsavel tecnico","invalido [NT 2018.005]"}})
aadd(aMOTIVOS,{"974" ,{"Rejeicao: CNPJ do responsavel tecnico","diverge do cadastrado [NT 2018.005]"}})
aadd(aMOTIVOS,{"975" ,{"Rejeicao: Obrigatoria a informacao do","identificador do CSRT e do Hash do","CSRT [NT 2018.005]"}})
aadd(aMOTIVOS,{"976" ,{"Rejeicao: Identificador do CSRT nao","cadastrado na SEFAZ [NT 2018.005]"}})
aadd(aMOTIVOS,{"977" ,{"Rejeicao: Identificador do CSRT","revogado [NT 2018.005]"}})
aadd(aMOTIVOS,{"978" ,{"Rejeicao: Hash do CSRT diverge","do calculado [NT 2018.005]"}})

aadd(aMOTIVOS,{"999" ,{"Rejeicao: Erro nao catalogado ","(informar a mensagem de erro capturado ","no tratamento da excecao)"}})


nTela2 := savescreen(0,0,24,80)

X_DENEGA = .f.

lDesligaRedraw := .t.

nbox(5,10,18,70,"G+/G",.t.)

setcolor("G+/G,G+/G")

@  6, 11 say padc("EMITINDO NOTA FISCAL ELETRONICA",59)

exc_arq(ACBrNFe_UNI)

if "TESTE" $ M_LOGNOM
  mon_env("NFE.SetAmbiente(2)")
else
  mon_env("NFE.SetAmbiente(1)")
endif

cRet := MON_RET(ACBrNFe_SAI)   // Verifica Retorno do Arquivo de Resposta.
exc_arq(ACBrNFe_UNI)

cRet := nfe_xml("C:\ATLAS\NFE\XML.INI")

if "ERRO" $ cRet
  memoedit(cret,07,11,17,69,.f.,,60)
endif

M_NOAR = substr(cRet,28,52)  // NOME DO XML
M_LOGXML = substr(cRet,5,75)  // onde ficou gravado no ACBR

// Fim pedido gerar xml

if M_NFSSAI == "S"
  select ANFS00
else
  select ANFE00
endif

go lRecnota

M_NFSMES = str(year(M_NFSDTE),4) + strzero(month(M_NFSDTE),2)
M_NFSID = M_NOAR

replace NFSID with M_NFSID
replace NFSUSU with M_NFSMES
replace NFSLOG with M_LOGXML

select EMITINDO
replace PCADES    with "XML GERADO"
replace PCADESADI with "\\SERVIDOR\C\ATLAS\ENVIADO\" + alltrim(M_NFSMES) + "\NFE\" + M_NFSID
replace NFSLOG    with M_LOGXML
replace NFSKEY    with M_NFSMES

M_ID  = "\\SERVIDOR\C\ATLAS\ENVIADO\" + alltrim(M_NFSMES) + "\nfe\" + alltrim(M_NFSID)

// GEROU O XML E GRAVAMOS NA NOTA TEMPORARIA
// VAMOS ENVIAR E VER O QUE VAI DAR

M_MEMO= memoread(M_ID)

if "<cStat>100" $ M_MEMO
  alert("Nota fiscal ja emitida;e ja gravada no site;da receita")
  lDesligaRedraw := .f.
  fecha_arq()
  RestScreen(0,0,24,80,nTela2)
  return .f.
else
  if "<cStat>101" $ M_MEMO
    alert("Nota fiscal ja emitida;e consta como;cancelada no site;da receita")
    fecha_arq()
    RestScreen(0,0,24,80,nTela2)
    lDesligaRedraw := .f.
    return .f.
  endif
endif

lTemretorno = .f.
nTentativa = 1
exc_arq(ACBrNFe_UNI)

M_MEMO := NFe_ENV(M_LOGXML,,,"0") // Envia xml para receita NAO MANDA IMPRIMIR
cRetorno = M_MEMO

select EMITINDO
replace PCADES with "ENVIADO"

pos = rat("CSTAT=100",upper(M_MEMO))
lAprovou = .t.

if pos = 0 // nao foi aprovado
  lAprovou = .f.
  lTentativa = 0

  do while .t.

    pos = rat("CSTAT=",upper(M_MEMO))  // pegamos o erro
    M_NOAR = substr(M_MEMO,POS+6,3)

    if val(M_NOAR) = 999 .or. val(M_NOAR) = 0 // erro nao catalogado, vamos fazer consulta
      M_MEMO := NFe_ENV(M_LOGXML,,,"0") // Envia xml para receita NAO MANDA IMPRIMIR
      pos = rat("CSTAT=",upper(M_MEMO))  // pegamos o erro
      M_NOAR = substr(M_MEMO,POS+6,3)
    endif

    if "CSTAT=100" $ upper(M_MEMO)
      M_NOAR = "100"
      lAprovou = .t.
    endif

    if M_NOAR $ "#204#"   // JA CONSTA
      M_MEMO := NFe_CON(M_ID)
      setcolor("N/W*")
      keyboard chr(30) + chr(27)
      M_NOAR = "100"
      lAprovou = .t.
    endif

    if M_NOAR $ "#217#" // nao consta enviamos de novo
      exc_arq(ACBrNFe_UNI)
      inkey(10)
      M_MEMO := NFe_ENV(M_LOGXML,,,"0") // Envia xml para receita NAO MANDA IMPRIMIR
      loop
    endif

    if M_NOAR $ "#656#" // CONSUMO INDEVIDO
      if lTentativa = 3
        lAprovou = .f.
        msgbox1({"Codigo de erro nao encontrado","Informe este codigo ao Desenvolvedor","Codigo = " + M_NOAR})
        RestScreen(0,0,24,80,nTela2)
        lDesligaRedraw := .f.
        return .f.
      endif
      exc_arq(ACBrNFe_UNI)
      inkey(10)
      M_MEMO := NFe_CON(M_LOGXML)        // entao vamos consultar pra saber se esta autorizada
      lTentativa ++
      loop
    endif

    if !M_NOAR == "100"
      if val(M_NOAR) > 0
        msg = ascan(aMOTIVOS, {|_1| _1[1] == M_NOAR})
        msgbox1(aMOTIVOS[msg][2])
        if M_NOAR $ "#205#301#302#110#" // NOTA FISCAL DENEGADA
          RestScreen(0,0,24,80,nTela2)
          X_DENEGA = .t.
          lAprovou = .f.
          return .t.
        endif
      RestScreen(0,0,24,80,nTela2)
      lDesligaRedraw := .f.
        return .f.
      else
        lAprovou = .f.
        msgbox1({"Codigo de erro nao encontrado","Informe este codigo ao Desenvolvedor","Codigo = " + M_NOAR})
        RestScreen(0,0,24,80,nTela2)
        lDesligaRedraw := .f.
        return .f.
      endif
    endif

    exit
  enddo
endif

if lAprovou
  M_ID  = "\\SERVIDOR\C\ATLAS\ENVIADO\" + alltrim(M_NFSMES) + "\nfe\" + alltrim(M_NFSID)
  NFe_IMP(M_ID,1)
  select EMITINDO
  replace PCADES with "OK"
  if !"TESTE" $ M_LOGNOM  // so enviar email
    if "@" $ ANFSAA->EMAIL  // tem email
      msw("* * * ENVIANDO EMAIL PRINCIPAL - AGUARDE!!! * * *")
      nfe_ema(lower(alltrim(ANFSAA->EMAIL)),M_ID,"1")
    endif
    if "@" $ ANFSAA->EMAIL1  // tem email
      msw("* * * ENVIANDO EMAIL 01 - AGUARDE!!! * * *")
      nfe_ema(lower(alltrim(ANFSAA->EMAIL1)),M_ID,"1")
    endif
    if "@" $ ANFSAA->EMAIL2  // tem email
      msw("* * * ENVIANDO EMAIL 02 - AGUARDE!!! * * *")
      nfe_ema(lower(alltrim(ANFSAA->EMAIL2)),M_ID,"1")
    endif
    if "@" $ ANFSAA->EMAIL3  // tem email
      msw("* * * ENVIANDO EMAIL 03 - AGUARDE!!! * * *")
      nfe_ema(lower(alltrim(ANFSAA->EMAIL3)),M_ID,"1")
    endif
    if "@" $ ANFSAA->EMAIL4  // tem email
      msw("* * * ENVIANDO EMAIL 04 - AGUARDE!!! * * *")
      nfe_ema(lower(alltrim(ANFSAA->EMAIL4)),M_ID,"1")
    endif
  endif
else
  if M_NOAR = "204" // DUPLICIDADE MUDAR PARAMETRO
    select AEMP00                    && seleciona empresa e grava ultima nota fiscal
    do while .t.
      if rlock()
        replace EMPNFS with EMPNFS+1
        unlock
        exit
      else
        msw("(AEMP00) REGISTRO SENDO GRAVADO POR OUTRO USUARIO... AGUARDE")
        if lastkey()=17
          exit
        endif
      endif
    enddo
    lRecage = recno()
  endif

  setcolor("G+/G,G+/G")
  memoedit(cRetorno,07,11,17,69,.f.,,60)

  setcolor("")
  restscreen(0,0,24,80,nTela2)

  if M_NOAR = "205" .or. M_NOAR = "302"  // NOTA FISCAL DENEGADA
    X_DENEGA = .t.
    lDesligaRedraw := .f.
    return .t.
  endif

  fecha_arq()
  lEmitindonota = .f.
  lDesligaRedraw := .f.
  return .f.
endif

restscreen(0,0,24,80,nTela2)
lDesligaRedraw := .f.
return .t.

*************************
function FECHA_ELETRONICA
*************************

select EMITINDO
use
select ANFE00
use
select ANFE01
use
select ANFS00
use
select ANFS01
use
select AKAR00
use
select ANFSAA
use
select ANFSAB
use
select ACVEAA
use
select ADCRAA
use
select AHISAA
use

abre_nfs0( "2") // nfs mestre
abre_nfs1( "3") // nfs itens
abre_kar ( "9") // kardex
abre_nfe0("14") // Nfe Mestre
abre_nfe1("15") // Nfe Intens

return ""

****************
function GERAXML
****************

M_ARQX = "C:\ATLAS\NFE\XML.INI"

set print on
set printer to &M_ARQX
set console off
set century on

select ANFSAB
GO 1

select ANFSAA
go top

?? "[Identificacao]"

? "IndPres=1"

if M_CLIDCC == 1  // contribuinte ICMS
  if left(ANFSAB->NFSNATN,1) == "6"
    ? "idDest=2"  // OPERACAO INTERNA 2-INTERESTADUAL
  ELSE
    ? "idDest=1"  // OPERACAO INTERNA 2-INTERESTADUAL
  ENDIF
else
  if ESTADO == "SP"
    ? "idDest=1"
  else
    ? "idDest=2"
  endif
endif

*if ESTADO == "SP"
*  ? "idDest=1"
*else
*  ? "idDest=2"
*endif

? "IndFinal=1"

? "cUF=35"
? "Codigo=" + alltrim(str(NFSNUM+10,8))
? "NaturezaOperacao=" + NATOP
if NFSCPG < 3
  ? "FormaPag=0"  // vista(0)  prazo(1) outras(2)
else
  if NFSCPG <  9
    ? "FormaPag=1"
  else
    ? "FormaPag=2"
  endif
endif
? "Modelo=55"
if X_SCAN == "S"
  ? "Serie=999"
else
  ? "Serie=1"
endif

? "Numero=" + alltrim(str(NFSNUM,6))
? "Emissao=" + dtoc(NFSDTE)  // 30/06/2010

if !empty(NFSDTS)
  ? "Saida=" + dtoc(NFSDTS)  //30/06/2010
endif

? "hSaiEnt=" + time()  //00:00:00"

if ANFSAA->TIPO == "S"
  ? "Tipo=1"   // 0=entrada 1=saida
else
  ? "Tipo=0"   // 0=entrada 1=saida
endif

? "CidadeCod=3541406"
? "tpImp=1"

if X_SCAN == "S"
  ? "tpemis=3" // (2) scan
else
  if X_FSDA == "S"
    ? "tpemis=5" // (4)fsda
  else
    ? "tpemis=0" // (0)normal (1)contingencia (2)scan (3)dpec (4)fsda
  endif
endif

if ANFSAA->FINNFE == "2" // complementar
  ? "Finalidade=2"  // (1)normal (2)complementar (3)ajuste
  ? "[NFRef001]"
  ? "Tipo=NFe"
  ? "refNFe="+ANFSAA->NFSCHAV
else
  if ANFSAA->FINNFE == "4"
    ? "Finalidade=4"  // (1)normal (2)complementar (3)ajuste
    if !left(ANFSAA->NFSREF,3) == "ECF"
      ? "[NFRef001]"
      ? "Tipo=NFe"   // "ECF"
      ? "refNFe="+ANFSAA->NFSREF
    else
      ? "[NFRef001]"
      ? "Tipo=Ecf"   // "ECF"
      ? "ModEcf=2D"
      ? "nEcf=1"
      ? "nCOO=" + alltrim(substr(ANFSAA->NFSREF,4,6))
    endif
  else
    ? "Finalidade=1"  // (1)normal (2)complementar (3)ajuste
  endif
endif

if M_NFSNATN == "5.929"
  ? "[NFRef001]"
  ? "Tipo=Ecf"   // "ECF"
  ? "ModEcf=2D"
  ? "nEcf=1"
  ? "nCOO=" + alltrim(M_NFSREF)
endif


? "procEmi=0"
? "verProc=1.0.0.0"

if X_SCAN == "S" .or. X_FSDA == "S"
 ? "dhCont=" + dtoc(xx_data)
 ? "xJust=" + xx_motivo
endif

? "[Emitente]"


? "CNPJ=" + right(AEMP00->EMPCGC,14)
? "Razao=" + AEMP00->EMPNOM
? "Fantasia=" + AEMP00->EMPFAN
? "IE=" + AEMP00->EMPIES
? "IEST="
? "IM="
? "CNAE="
? "CRT=" + alltrim(AEMP00->EMPCFE)  // REGIME NORMAL
? "Logradouro=RUA TENENTE NICOLAU MAFFEI"
? "Numero=2013"
? "Complemento=SALA A"
? "Bairro=" + AEMP00->EMPBAI
? "CidadeCod=3541406"
? "Cidade=PRESIDENTE PRUDENTE"
? "UF=SP"
? "CEP=" + strzero(AEMP00->EMPCEP,5) + strzero(AEMP00->EMPCCE,3)
? "PaisCod=1058"
? "Pais=BRASIL"
? "Fone=" + tira_pto(AEMP00->EMPTEL)
? "[Destinatario]"
? "CNPJ=" + CNPJ

if "TESTE" $ M_LOGNOM
  ? "NomeRazao=NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL"
  if "ISENTO" $ IE .or. empty(IE)
    ? "IE="
    ? "IndIEDest=9"
  else
    ? "IE=" + IE
    ? "IndIEDest=1"
  endif
  //? "IndIEDest=9"
else
  ? "NomeRazao=" + NOME
  if "ISENTO" $ IE .or. empty(IE)
    ? "IE="
    ? "IndIEDest=9"
  else
    ? "IndIEDest=1"
    ? "IE=" + IE
  endif
endif

if ESTADO == "SP"
 ? "idDest=1"
else
 ? "idDest=2"
endif

*if ESTADO == "SP"
*  ? "idDest=1"
*else
*  ? "idDest=2"
*endif


? "ISUF="
? "Email="
? "Logradouro=" + ENDERECO
? "Numero=."
? "Complemento="
? "Bairro=" + BAIRRO
? "CidadeCod=" + CODIBGE
? "Cidade=" + CIDADE
? "UF=" + ESTADO
? "CEP=" + CEP
? "PaisCod=1058"
? "Pais=BRASIL"
? "Fone=" + FONE

? "[autXML001]"
*? "CNPJCPF=23809139000186"



select ANFSAB
go top
nSeq = 1

LOC_NFSQDE = 0
LOC_NFSVLI = 0
LOC_PCANCM = PCANCM
LOC_NFSNATN = NFSNATN
LOC_PCAUNI = PCAUNI
LOC_NFSDSP = NFSDSP
nTOTPIS = 0
nTOTCOF = 0
nTOTPISST = 0
nTOTCOFST = 0
nTOTFRE = 0
nTOTFREIT = { }
M_TOTTRI = 0
M_TOTDES =0
M_TOTREM =0

nValCBS  = 0
nValgCBS = 0
tValCBS  = 0
tValgCBS = 0
nValBICCBS = 0

if ANFSAA->FINNFE == "2" // complementar
  do while !eof()
    LOC_NFSQDE += NFSQDE
    LOC_NFSVLI += NFSVLI
    skip
  enddo

  ? "[Produto" + strzero(nSeq,3) + "]"
  ? "nItem=" + alltrim(str(nSeq,3))
  ? "infAdProd=" + alltrim(PCADESADI)
  ? "Codigo=" + str(15148)
  ? "EAN=SEM GTIN"
  ? "Descricao=Documento fiscal emitido nos termos do inciso IV do art 182 do RICMS/2000"
  ? "NCM=38089991"
  ? "EXTIPI="
  ? "CFOP=" + LOC_NFSNATN
  ? "Unidade=R$"

* ? "Quantidade=" + alltrim(strtran(str(1,8,2),".",","))
* ? "ValorUnitario=" + alltrim(strtran(str(ANFSAA->NFSBIC,12,3),".",","))
* ? "ValorTotal=" + alltrim(strtran(str(ANFSAA->NFSBIC,12,2),".",","))


  ? "Quantidade=" + alltrim(strtran(str(0,8,2),".",","))
  ? "ValorUnitario=" + alltrim(strtran(str(0,12,3),".",","))
  ? "ValorTotal=" + alltrim(strtran(str(0,12,2),".",","))

  ? "cEANTrib=SEM GTIN"
  if empty(LOC_PCAUNI)
    ? "uTrib=R$"
  else
    ? "uTrib=R$"
  endif

* ? "qTrib=" + alltrim(strtran(str(1,8,2),".",","))
* ? "vUnTrib="+ alltrim(strtran(str(ANFSAA->NFSBIC,12,3),".",","))

  ? "qTrib=" + alltrim(strtran(str(0,8,2),".",","))
  ? "vUnTrib="+ alltrim(strtran(str(0,12,3),".",","))

  ? "vFrete="+ alltrim(strtran(str(0,12,2),".",","))
  ? "vSeg=0"

  ? "ValorDesconto=" + alltrim(strtran(str(0,10,2),".",","))

  ? "vOutro=0"
  ? "IndTot=1"
  ? "xPed="
  ? "nItemPed=0"

  // ICMS

  ? "[ICMS" + strzero(nSeq,3) + "]"
  ? "Origem=0"
  ? "CST=00"
* ? "ValorBase=" + alltrim(strtran(str(M_NFSBIC,12,2),".",","))
* ? "Aliquota=" + alltrim(strtran(str(((M_NFSVIC/M_NFSBIC)*100),6,2),".",","))
* ? "Valor=" + alltrim(strtran(str(M_NFSVIC,12,2),".",","))

* ? "ValorBase=" + alltrim(strtran(str(ANFSAA->NFSBIC,12,2),".",","))
* ? "Aliquota=" + alltrim(strtran(str(((ANFSAA->NFSVIC/ANFSAA->NFSBIC)*100),6,2),".",","))

  ? "ValorBase=" + alltrim(strtran(str(0,12,2),".",","))
  ? "Aliquota=" + alltrim(strtran(str(0,6,2),".",","))
  ? "Valor=" + alltrim(strtran(str(ANFSAA->NFSVIC,12,2),".",","))

  ? "ValorBaseST=" + alltrim(strtran(str(0,12,2),".",","))


  if LOC_NFSNATN $ "#6.917#5.411#6.411#5.910#5.929#5.908#"
    ? "CSOSN=400"
  else
    if LOC_NFSNATN $ "#1.202#1.102#2.102#5.102#6.102#"
      ? "CSOSN=102"
    else
      if LOC_NFSNATN $ "#5.405#"
        ? "CSOSN=500"
      else
        ? "CSOSN=0"
      endif
    endif
  endif
  
  ? "Modalidade=3"
  ? "PercentualReducao=0"
  ? "ModalidadeST=0"
  ? "PercentualMargemST=0"
  ? "PercentualReducaoST=0"
  ? "UFST="
  ? "pBCOp=0"
  ? "vBCSTRet=0"
  ? "vICMSSTRet=0"
  ? "motDesICMS=1"
  ? "pCredSN=0"
  ? "vCredICMSSN=0"
  ? "vBCSTDest=0"
  ? "vICMSSTDest=0"

  ? "[IPI" + strzero(nSeq,3) + "]"
  ? "CST=50"
  ? "ValorBase=" + alltrim(strtran(str(M_NFSVLN,12,2),".",","))
  ? "Aliquota=" + alltrim(strtran(str(0,12,2),".",","))
  ? "Valor=" + alltrim(strtran(str(0,12,2),".",","))

  ? "[PIS" + strzero(nSeq,3) + "]"
  ? "CST=01"
  ? "ValorBase=0"
  ? "Aliquota=0"
  ? "Valor=0"
  ? "[COFINS" + strzero(nSeq,3) + "]"
  ? "CST=01"
  ? "ValorBase=0"
  ? "Aliquota=0"
  ? "Valor=0"

else

  do while !eof()
    LOC_NFSQDE += NFSQDE
    LOC_NFSVLI += NFSVLI

    nTOTFRE    += NFSDSP   // despesa + frete

    if ANFSAA->NFSSEG > 0 .and. ANFSAA->NFSFRE > 0
    else
      aadd(nTOTFREIT,0)
    endif
    skip
  enddo

  nTOTFRE1 = 0

  if ANFSAA->NFSSEG > 0 .and. ANFSAA->NFSFRE > 0
    M_PERFRE = (ANFSAA->NFSFRE/nTOTFRE) // PERCENTUAL FRETE
    select ANFSAB
    go top

    do while !eof()
      nValfre = round(NFSDSP*M_PERFRE,2)
      aadd(nTOTFREIT,nValfre)
      nTOTFRE1 += nValfre
      skip
    enddo

    if !str(nTOTFRE1,12,2) == str(ANFSAA->NFSFRE,12,2)
      if nTOTFRE1 > ANFSAA->NFSFRE
        nTOTFREIT[1] -= (nTOTFRE1 - ANFSAA->NFSFRE)
      else
        nTOTFREIT[1] += (ANFSAA->NFSFRE - nTOTFRE1)
      endif
    endif
  endif

  select ANFSAB
  go top

  M_TOTTRI = 0

  do while !eof()
    ? "[Produto" + strzero(nSeq,3) + "]"
    ? "nItem=" + alltrim(str(nSeq,3))
    ? "infAdProd=" + alltrim(PCADESADI)

    BUSCAREGISTRO("APCA00",1,{str(ANFSAB->NFSMAT,6,0)},"SELECT")
    BUSCAREGISTRO("ANCM00",1,{APCA00->PCANCM},"SELECT")
    select ANFSAB


    if PCATRI $ "#040#020#"
      ? "cBenef=" + APCA00->CBNEF
    endif

    M_TOTTRI += round(((NFSLIQ/100)*ANCM00->ALIQNAC),2)  // TOTAL TRIBUTOS

    M_ORIG = alltrim(APCA00->PCAORI)

    if M_ORIG == ""
      M_ORIG = "0"
    endif

    if len(alltrim(PCADESADI)) > 0
      ? ";Total aproximado de tributos federais, estaduais e municipais: " + alltrim(strtran(str(round(((NFSLIQ/100)*ANCM00->ALIQNAC),2),12,2),".",","))
    endif

    ? "Codigo=" + str(NFSMAT)

    if !empty(APCA00->PCABAR)
      ? "EAN=" + alltrim(APCA00->PCABAR)
    else
      ? "EAN=SEM GTIN"
    endif

    lNaopis = .t.  // NAO TEM PIS E COFINS

    ? "Descricao=" + PCADES

    ? "NCM=" + PCANCM
    ? "EXTIPI="
    ? "CFOP=" + NFSNATN
    ? "Unidade=" + PCAUNI
    ? "Quantidade=" + alltrim(strtran(str(NFSQDE,12,3),".",","))
    ? "ValorUnitario=" + alltrim(strtran(str(NFSVLI/NFSQDE,12,5),".",","))
    ? "ValorTotal=" + alltrim(strtran(str(NFSVLI,12,2),".",","))

    if !empty(APCA00->PCABAR)
      ? "cEANTrib=" + alltrim(APCA00->PCABAR)
    else
      ? "cEANTrib=SEM GTIN"
    endif

    if !empty(APCA00->PCACLA)
      ? "CEST=" + alltrim(APCA00->PCACLA)
    else
      ? "CEST="
    endif

    if empty(PCAUNI)
      ? "uTrib=PC"
    else
      ? "uTrib=" + PCAUNI
    endif

    ? "qTrib=" + alltrim(strtran(str(NFSQDE,12,3),".",","))
    ? "vUnTrib="+ alltrim(strtran(str(NFSVLI/NFSQDE,12,5),".",","))
    ? "vSeg=0"

    if ANFSAA->NFSSEG = 0
      ? "vFrete="+ alltrim(strtran(str(NFSDSP,12,2),".",","))
      ? "vOutro=0"
    else
      ? "vOutro="+ alltrim(strtran(str(NFSDSP-nTOTFREIT[nSeq],12,2),".",","))
      ? "vFrete="+ alltrim(strtran(str(nTOTFREIT[nSeq],12,2),".",","))
    endif

    M_VDESC = (NFSVLI-NFSLIQ)
    if M_VDESC < 0
      M_VDESC = 0
    endif
    ? "ValorDesconto=" + alltrim(strtran(str(M_VDESC,10,2),".",","))

    ? "IndTot=1"
    ? "xPed="
    if M_AUTFAT > 0
      ?? alltrim(str(M_AUTFAT,8))
    endif

    ? "nItemPed=0"

    // ICMS

    ? "[ICMS" + strzero(nSeq,3) + "]"

  if alltrim(AEMP00->EMPCFE) $ "3" .or. left(AEMP00->EMPECF,1) == "S" // simples nacional
    ? "Origem=" + M_ORIG

    do case
      case (PCATRI == "000" .or. PCATRI == "060")  .and. NFSVICS > 0
        ? "CST=10"
        ? "ValorBase=" + alltrim(strtran(str(NFSBIC,12,2),".",","))
        if NFSBIC > 0
          ? "Aliquota=" + alltrim(strtran(str(NFSPIC,6,2),".",","))
        else
          ? "Aliquota=" + alltrim(strtran(str(0,6,2),".",","))
        endif

        ? "Valor=" + alltrim(strtran(str(NFSVIC,12,2),".",","))
        ? "ValorBaseST=" + alltrim(strtran(str(NFSBICS,12,2),".",","))
        ? "AliquotaST=0"
        ? "ValorST=" + alltrim(strtran(str(NFSVICS,12,2),".",","))
      case PCATRI == "000"
        ? "CST=00"
        ? "ValorBase=" + alltrim(strtran(str(NFSBIC,12,2),".",","))
        if NFSBIC > 0
          ? "Aliquota=" + alltrim(strtran(str(NFSPIC,6,2) ,".",","))
        else
          ? "Aliquota=" + alltrim(strtran(str(0,6,2),".",","))
        endif

        ? "Valor=" + alltrim(strtran(str(NFSVIC,12,2),".",","))
      case PCATRI == "090"
        ? "CST=90"
        ? "ValorBase=" + alltrim(strtran(str(NFSBIC,12,2),".",","))
        if NFSBIC > 0
          ? "Aliquota=" + alltrim(strtran(str(NFSPIC,6,2),".",","))
        else
          ? "Aliquota=" + alltrim(strtran(str(0,6,2),".",","))
        endif
        ? "Valor=" + alltrim(strtran(str(NFSVIC,12,2),".",","))
      case PCATRI == "040"
        ? "CST=40"
        ? "ValorBase=0"
        ? "Aliquota=0"
        ? "Valor=0"
      case PCATRI == "041"
        ? "CST=41"
        ? "ValorBase=0"
        ? "Aliquota=0"
        ? "Valor=0"
      case PCATRI == "020"
        ? "CST=20"
        ? "ValorBase=" + alltrim(strtran(str(NFSBIC,12,2),".",","))
        ? "Aliquota=" + alltrim(strtran(str(NFSPIC,6,2),".",","))
        ? "Valor=" + alltrim(strtran(str(NFSVIC,12,2),".",","))
      case PCATRI == "060"
        ? "CST=60"
        ? "ValorBase=" + alltrim(strtran(str(NFSBIC,12,2),".",","))
        if NFSBIC > 0
          ? "Aliquota=" + alltrim(strtran(str(NFSPIC,6,2),".",","))
        else
          ? "Aliquota=" + alltrim(strtran(str(0,6,2),".",","))
        endif

        ? "Valor=" + alltrim(strtran(str(NFSVIC,12,2),".",","))
    endcase

    if !ANFSAA->ESTADO == "SP"
      if "ISENTO" $ ANFSAA->IE .or. empty(ANFSAA->IE)
        vICMinter = round((NFSBIC/100)*aliq_fora(ANFSAA->ESTADO),2)  // 7
        vICMintra = round(((NFSBIC/100)*aliq_dest(ANFSAA->ESTADO)) - vICMinter,2)
        vPartDest = (vICMintra/100)*partilha(M_NFSDTE)
        vPartOrig = vICMintra - vPartDest
        M_TOTDES += vPartDest
        M_TOTREM += vPartOrig
        ? "[ICMSUFDest"  + strzero(nSeq,3) + "]"
        ? "vBCUFDest =" + alltrim(strtran(str(NFSBIC,12,2),".",",")) //     1000.00
        ? "pFCPUFDest =0.00"
        ? "pICMSUFDest =" + alltrim(strtran(str(aliq_dest(ANFSAA->ESTADO),6,2),".",",")) // 12.00
        ? "pICMSInter =" + alltrim(strtran(str(aliq_fora(ANFSAA->ESTADO),6,2),".",",")) // 12.00   17.00
        ? "pICMSInterPart =" + alltrim(strtran(str(partilha(M_NFSDTE),6,2),".",",")) // 40.00
        ? "vFCPUFDest = 0.00"
        ? "vICMSUFDest =" + alltrim(strtran(str(vPartDest,12,2),".",",")) //     1000.00
        ? "vICMSUFRemet = "+ alltrim(strtran(str(vPartOrig,12,2),".",",")) //     1000.00
      endif
    endif
  endif



  if alltrim(AEMP00->EMPCFE) $ "12"  // simples nacional
    if NFSNATN $ "#6.917#5.411#6.411#5.910#5.929#5.908#"
      ? "CSOSN=400"
    else

    if NFSNATN $ "#6.102#6.108#"
      ? "CSOSN=102"
    else
      if NFSNATN $ "#5.102#5.108#"
        ? "CSOSN=102"
      else
      if NFSNATN $ "#5.551#1.202#1.102#2.102#"
        ? "CSOSN=900"
      else
        if NFSNATN $ "#5.405#"
          ? "CSOSN=500"
        else
          if NFSNATN $ CSOSN_900
            ? "CSOSN=900"
          else
            ? "CSOSN=0"
          endif
        endif
      endif
      endif
    endif
    endif
  else
    ? "CSOSN=0"
  endif
  
    ? "Modalidade=3"
    ? "PercentualReducao=0"
    ? "ModalidadeST=0"
    ? "PercentualMargemST=0"
    ? "PercentualReducaoST=0"
    ? "UFST="
    ? "pBCOp=0"
    ? "vBCSTRet=0"
    ? "vICMSSTRet=0"
    ? "motDesICMS=1"
    ? "pCredSN=0"
    ? "vCredICMSSN=0"
    ? "vBCSTDest=0"
    ? "vICMSSTDest=0"

    ? "[IPI" + strzero(nSeq,3) + "]"
    ? "CST=50"
    ? "ValorBase=" + alltrim(strtran(str(NFSVLI,12,2),".",","))
    ? "Aliquota=" + alltrim(strtran(str(NFSPIPI,12,2),".",","))
    ? "Valor=" + alltrim(strtran(str(NFSVIP,12,2),".",","))

    if ANCM00->ALIQZERO == "S" .or. ANCM00->SUBSTRIB == "S" .or. lNaopis
      lNaopis = .t.
    endif

    if lNaopis
      ? "[PIS" + strzero(nSeq,3) + "]"
      if ANCM00->ALIQZERO == "S"
        ? "CST=06"
        ? "ValorBase=0"
        ? "Aliquota=0"
        ? "Valor=0"
      else
        ? "CST=08"  // ANTES ESTAVA 05
        ? "[PISST" + strzero(nSeq,3) + "]"

*        ? "ValorBase=" + alltrim(strtran(str(NFSLIQ,12,2),".",","))
*        ? "AliquotaPerc=" + alltrim(strtran(str(ANCM00->PERPIS,6,2),".",","))
*        nValpisst = round(((NFSLIQ/100) * ANCM00->PERPIS),2)
*        nTOTPISst += nValpisst
*        ? "ValorPISST=" + alltrim(strtran(str(nValpisst,12,2),".",","))

        ? "ValorBase=0"
        ? "AliquotaPerc=0"
        ? "ValorPISST=0"
      endif

      ? "[COFINS" + strzero(nSeq,3) + "]"

      if ANCM00->ALIQZERO == "S"
        ? "CST=06"
        ? "ValorBase=0"
        ? "Aliquota=0"
        ? "Valor=0"
      else
        ? "CST=08"  //  ANTES 05
        ? "[COFINSST" + strzero(nSeq,3) + "]"
*        ? "ValorBase=" + alltrim(strtran(str(NFSLIQ,12,2),".",","))
*        ? "AliquotaPerc=" + alltrim(strtran(str(ANCM00->PERCOF,6,2),".",","))
*        nValcofst = round(((NFSLIQ/100) * ANCM00->PERCOF),2)
*        nTOTCOFst += nValcofst
*        ? "ValorCOFINSST=" + alltrim(strtran(str(nValcofst,12,2),".",","))


        ? "ValorBase=0"
        ? "AliquotaPerc=0"
        ? "ValorCOFINSST=0"

      endif
    else
      ? "[PIS" + strzero(nSeq,3) + "]"
      ? "CST=02"
      ? "ValorBase=" + alltrim(strtran(str(NFSLIQ,12,2),".",","))
      ? "Aliquota=" + alltrim(strtran(str(ANCM00->PERPIS,6,2),".",","))
      nValpis = round(((NFSLIQ/100) * ANCM00->PERPIS),2)

      nTOTPIS += nValpis

      ? "Valor=" + alltrim(strtran(str(nValpis,12,2),".",","))

      ? "[COFINS" + strzero(nSeq,3) + "]"
      ? "CST=02"
      ? "ValorBase=" + alltrim(strtran(str(NFSLIQ,12,2),".",","))
      ? "Aliquota=" + alltrim(strtran(str(ANCM00->PERCOF,6,2),".",","))
      nValcof = round(((NFSLIQ/100) * ANCM00->PERCOF),2)

      nTOTCOF += nValcof

      ? "Valor=" + alltrim(strtran(str(nValcof,12,2),".",","))
    endif

    nValCBS  = round(((NFSLIQ/100) * 0.1),2)
    nValgCBS = round(((NFSLIQ/100) * 0.9),2)


    tValCBS  += nValCBS
    tValgCBS += nValgCBS
    nValBICCBS += NFSLIQ


    ? "[IBSCBS" + strzero(nSeq,3) + "]"
    ? "CST=000"
    ? "cClassTrib=000001"
    ? "indDoacao="

    ? "[gIBSCBS" + strzero(nSeq,3) + "]"
    ? "vBC=" + alltrim(strtran(str(NFSLIQ,12,2),".",","))
    ? "vIBS=" + alltrim(strtran(str(nValCBS,12,2),".",","))

    ? "[gIBSUF" + strzero(nSeq,3) + "]"
    ? "pIBSUF=0,1"
    ? "vIBSUF=" + alltrim(strtran(str(nValCBS,12,2),".",","))
    ? "pDif=0"
    ? "vDif=0"
    ? "vDevTrib=0"
    ? "pRedAliq=0"
    ? "pAliqEfet=0"

    ? "[gIBSMun" + strzero(nSeq,3) + "]"
    ? "pIBSMun=0"
    ? "vIBSMun=0"
    ? "pDif=0"
    ? "vDif=0"
    ? "vDevTrib=0"
    ? "pRedAliq=0"
    ? "pAliqEfet=0"

    ? "[gCBS" + strzero(nSeq,3) + "]"
    ? "pCBS=0,9"
    ? "vCBS=" + alltrim(strtran(str(nValgCBS,12,2),".",","))
    ? "pDif=0"
    ? "vDif=0"
    ? "vDevTrib=0"
    ? "pRedAliq=0"
    ? "pAliqEfet=0"

    skip
    nSeq ++
  enddo
endif

select ANFSAA

? "[Total]"

if ANFSAA->FINNFE == "2" // complementar
  ? "BaseICMS=" 			+ alltrim(strtran(str(0,12,2),".",","))
else
  ? "BaseICMS=" 			+ alltrim(strtran(str(NFSBIC,12,2),".",","))
endif

? "ValorICMS=" 			+ alltrim(strtran(str(NFSVIC,12,2),".",","))
? "BaseICMSSubstituicao=" 	+ alltrim(strtran(str(NFSBICS,12,2),".",","))
? "ValorICMSSubstituicao=" 	+ alltrim(strtran(str(NFSVICS,12,2),".",","))

? "vFCPUFDest=0.00"
? "vICMSUFDest="  + alltrim(strtran(str(M_TOTDES,12,2),".",","))
? "vICMSUFRemet=" + alltrim(strtran(str(M_TOTREM,12,2),".",","))


? "ValorProduto="  		+ alltrim(strtran(str(NFSVLM,12,2),".",","))
? "ValorFrete=" 		+ alltrim(strtran(str(NFSFRE,12,2),".",","))
? "ValorSeguro=0" 	//	+ alltrim(strtran(str(NFSSEG,12,2),".",","))
? "ValorDesconto=" 		+ alltrim(strtran(str(NFSVLD,12,2),".",","))
? "ValorIPI=" 			+ alltrim(strtran(str(NFSVIP,12,2),".",","))
? "ValorNota=" 			+ alltrim(strtran(str(NFSVLN+NFSVICS+NFSVDE,12,2),".",","))
? "ValorII=0"
? "ValorPIS="			+ alltrim(strtran(str(nTOTPIS,12,2),".",","))
? "ValorCOFINS="		+ alltrim(strtran(str(nTOTCOF,12,2),".",","))
? "ValorOutrasDespesas="   + alltrim(strtran(str(NFSSEG,12,2),".",","))
? "ValorServicos=0"
? "ValorBaseISS=0"
? "ValorISSQN=0"
? "ValorPISISS=0"
? "ValorCONFINSISS=0"
? "[retTrib]"
? "vRetPIS=0"
? "vRetCOFINS=0"
? "vRetCSLL=0"
? "vBCIRRF=0"
? "vIRRF=0"
? "vBCRetPrev=0"
? "vRetPrev=0"

? "[IBSCBSTot]"
? "vBCIBSCBS="			+ alltrim(strtran(str(nValBICCBS,12,2),".",","))
? "[gIBS]"
? "vIBS="			+ alltrim(strtran(str(tValCBS,12,2),".",","))
? "vCredPres=0"
? "vCredPresCondSus=0"
? "[gIBSUFTot]"
? "vDif=0"
? "vDevTrib=0"
? "vIBSUF="			+ alltrim(strtran(str(tValCBS,12,2),".",","))
? "[gIBSMunTot]"
? "vDif=0"
? "vDevTrib=0"
? "vIBSMun=0"
? "[gCBSTot]"
? "vDif=0"
? "vDevTrib=0"
? "vCBS="			+ alltrim(strtran(str(tValgCBS,12,2),".",","))
? "vCredPres=0"
? "vCredPresCondSus=0"

? "[Transportador]"

? "FretePorConta=" 	+ str((val(NFSTRC)-1),1)  // (0)emitente (1)destinatario
? "CnpjCpf=" 		+ right(alltrim(M_TRACGC),14)
? "NomeRazao=" 		+ M_TRANOM
? "IE=" 		+ tira_pto(M_TRAIES)
? "Endereco=" 		+ M_TRAEND
? "Cidade=" 		+ M_TRAMUN
? "UF=" 		+ M_TRAEST
? "ValorServico=0"
? "ValorBase=0"
? "Aliquota=0"
? "Valor=0"
? "CFOP="
? "CidadeCod=0"

if ANFSAA->TIPO == "S"
  if ANFSAA->ESTADO == "SP"
    if empty(M_TRAPLC)
      ? "Placa=XXX9999"
    else
      ? "Placa=" + M_TRAPLC
    endif
    ? "UFPlaca=" + M_TRAEST
  endif
endif

? "RNTC="
? "[Volume001]"
? "Quantidade=" 	+ str(QVOL,5)
? "Especie=" 		+ ESP
? "Marca=" 		+ MARCA
? "PesoLiquido=" 	+ alltrim(strtran(str(PESOL,12,2),".",","))
? "PesoBruto=" 		+ alltrim(strtran(str(PESOB,12,2),".",","))
? "Numeracao="

*tPag (01=Dinheiro  02=Cheque  03=Carto de Crdito  04=Carto de Dbito  05=Crdito Loja  10=Vale Alimenta;o  11=Vale Refei;o  12=Vale Presente  13=Vale Combustvel 99=Outros)
*indPag 0 - pagamento  vista/ 1 - pagamento  prazo, 2 - outros.

nTOTDUP = 0
nParcelas = 0
lAvista = .f.

if !ANFSAA->FINNFE $ "234" // complementar
  nTOTDUP = 0
  for S = 1 to 6
    M_S = alltrim(str(S, 2))
    if M_DUPDP&M_S > 0
      nTOTDUP += M_DUPDP&M_S
      nParcelas ++
      if M_DUPVC&M_S = M_NFSDTE
        lAvista = .t.
      endif
    endif
  next
  if nTOTDUP = 0
    nTOTDUP = M_NFSVLN
  endif

  Eavista = .f.

  if lAvista .and. nParcelas < 2
    Eavista = .t.
    tpIntegra = 2
    * 1=Pagamento integrado com o sistema de automação da empresa
    * (Ex.: equipamento TEF, Comércio Eletrônico);
    * 2=Pagamento não integrado com o sistema de automação da empresa
    * (Ex.: equipamento POS);
  else
    if !ANFSAA->FINNFE == "2" // complementar
      for S = 1 to 6
        M_S = alltrim(str(S, 2))
        if M_DUPDP&M_S > 0
          ? "[Duplicata" + strzero(S,3) + "]"
          ? "Numero=" + strzero(S,3)
          ? "DataVencimento=" + dtoc(M_DUPVC&M_S)
          ? "Valor=" + alltrim(strtran(str(M_DUPDP&M_S,12,2),".",","))
        endif
      next

      ? "[Fatura]"
      ? "nFat=001"
      ? "vOrig=" + alltrim(strtran(str(nTOTDUP+.01,12,2),".",","))
      ? "vLiq=" + alltrim(strtran(str(nTOTDUP,12,2),".",","))
      ? "vDesc=" + alltrim(strtran(str(0.01,12,2),".",","))

    endif
  endif

  if nTOTDUP = 0
    nTOTDUP = M_NFSVLN
  endif

  * (campo indPag)
  * 0=Pagamento à Vista
  * 1=Pagamento à Prazo

  * (campo tPag):
  * 01=Dinheiro
  * 02=Cheque
  * 03=Cartão de Crédito
  * 04=Cartão de Débito
  * 05=Crédito Loja
  * 10=Vale Alimentação
  * 11=Vale Refeição
  * 12=Vale Presente
  * 13=Vale Combustível
  * 14=Duplicata Mercantil
  * 15=Boleto Bancário
  * 90=Sem Pagamento
  * 99=Outros

  *Grupo de Cartões (campo card)
  *Aqui são preenchidos detalhes do pagamento feito via cartão de crédito ou débito.

  *Tipo de Integração para pagamento (campo tpIntegra) – qual o processo de pagamento com o sistema de automação da empresa:
  *1 = Pagamento integrado com o sistema de automação da empresa (Ex.: equipamento TEF, Comércio Eletrônico);
  *2 = Pagamento não integrado com o sistema de automação da empresa (Ex.: equipamento POS);
  *CNPJ da Credenciadora de cartão (campo CNPJ)
  *Bandeira da operadora de cartão (campo tBand)

  * 01=Visa
  * 02=Mastercard
  * 03=American Express
  * 04=Sorocred
  * 05=Diners Club
  * 06=Elo
  * 07=Hipercard
  * 08=Aura
  * 09=Cabal
  * 99=Outros

  ? "[PAG001]"

  if Eavista
    ? "indPag=0"
  else
    ? "indPag=1"
  endif

  if M_NFSPOR = 3 // banco
    ? "tpag=15"
  else
    ? "tpag=01"
  endif

  ? "vPag=" + alltrim(strtran(str(nTOTDUP,12,2),".",","))
else
  ? "[PAG001]"
  ? "tpag=90"
endif

? "[DadosAdicionais]"
? "Fisco="
? "Complemento="
?? "Total aproximado de tributos federais, estaduais e municipais: " + alltrim(strtran(str(M_TOTTRI,12,2),".",","))

MS = strzero(ME_EMP,2)

XMSG_1&MS = space(80)
XMSG_2&MS = space(80)
XMSG_3&MS = space(80)
XMSG_4&MS = space(80)
XMSG_5&MS = space(80)
XMSG_6&MS = space(80)
XMSG_7&MS = space(80)
XMSG_8&MS = space(80)
XMSG_9&MS = space(80)

if file("ANOTA.MSG")
  restore from ANOTA.MSG additive
endif

*for ABCD = 1 to 9
*  MSA = str(ABCD,1)
*  if !empty("XMSG_&MSA&MS")
*    ?? "|" + alltrim(XMSG_&MSA&MS) + " "
*  endif
*next

*if !AEMP00->EMPCGC == "002715655000171"  // ATLASCENTER
*  ?? ";ESTABELECIMENTO IMPEDIDO DE RECOLHER O ICMS/ISS PELO SIMPLES NACIONAL, NOS TERMOS DO 1 DO ART. 20 DA LEI COMPLEMENTAR N 123, DE 2006"
*  ?? ";NAO GERA DIREITO A CREDITO FISCAL DE IPI."
*endif

if !ANFSAA->FINNFE == "2" // complementar
  select ACVEAA
  go top
  do while !eof()
    ?? CVEDES
    ?? "|"
    skip
  enddo
endif

select AHISAA
go top
do while !eof()
  ?? HIS
  if !empty(HIS)
    ?? "|"
  endif
  skip
enddo

? "[cana]"
? "safra="
? "ref="

set printer to
set print off
set console on

set century off

return .t.

*****************
function TIRA_PTO
*****************

parameter M_CPOPTO

 M_CPOPTO = strtran(M_CPOPTO, ".","")
 M_CPOPTO = strtran(M_CPOPTO, "-","")
 M_CPOPTO = strtran(M_CPOPTO, "/","")
 M_CPOPTO = strtran(M_CPOPTO, "]","")
 M_CPOPTO = strtran(M_CPOPTO, "\","")
 M_CPOPTO = strtran(M_CPOPTO, ",","")
 M_CPOPTO = strtran(M_CPOPTO, "(","")
 M_CPOPTO = strtran(M_CPOPTO, ")","")
 M_CPOPTO = strtran(M_CPOPTO, " ","")

return M_CPOPTO

******************
function ALIQ_FORA(F_EST)
******************

if ANFSAB->NFSPIC = 4
  return 4
else
  if F_EST $ "#MT#MS#"
    return 7
  else
    return 12
  endif
endif

******************
function ALIQ_DEST(F_EST)
******************

do case
  case F_EST $ "#ES#MT#MS#RS#SC#"
    return 17
  case F_EST $ "#AP#MG#SP#"
    return 18
  case F_EST $ "#AC#AL#GO#PA#SE#"
    return 19
  case F_EST $ "#PR#RO#"
    return 19.5
  case F_EST $ "#AM#CE#DF#PB#RJ#RN#RR#TO#"
    return 20
  case F_EST $ "#BA#PE#"
    return 20.5
  case F_EST $ "#PI#"
    return 22.5
  case F_EST $ "#MA#"
    return 23
endcase

*****************
function PARTILHA
*****************

do case
  case year(M_NFSDTE) = 2016
    return 40
  case year(M_NFSDTE) = 2017
    return 60
  case year(M_NFSDTE) = 2018
    return 80
  otherwise
    return 100
endcase

return ""