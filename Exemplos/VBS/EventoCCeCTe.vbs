'---------------------------------------------------------
'Evento CCe CTe
'---------------------------------------------------------
 Dim oConfiguracao
 Dim oEventoCTe
 Dim oDetEventoCCE
 Dim oEventoCCeCTe
 Dim oInfCorrecao
 Dim oInfEvento
 Dim oRecepcaoEvento

 'Criar configuraçao básica para consumir o serviço
 Set oConfiguracao = CreateObject("Uni.Business.DFe.Servicos.Configuracao")
 oConfiguracao.TipoDFe = 2 '2=CTe
 oConfiguracao.CertificadoSenha = "12345678"
 oConfiguracao.CertificadoArquivo = "C:\Projetos\certificados\UnimakePV.pfx"

 'Criar tag do lote de eventos <eventoCTe>
 Set oEventoCTe = CreateObject("Uni.Business.DFe.Xml.CTe.EventoCTe")
 oEventoCTe.Versao = "3.00"

 'Criar tag <detEvento>
 Set oDetEventoCCE = CreateObject("Uni.Business.DFe.Xml.CTe.DetEventoCCE")
 oDetEventoCCE.VersaoEvento = "3.00"
 
 'Criar várias correções dentro do evento
 'Criar a tag <evCCeCTe>
 Set oEventoCCeCTe = CreateObject("Uni.Business.DFe.Xml.CTe.EventoCCeCTe")
 
 'Criar a tag <infCorrecao> da 1a correção
 Set oInfCorrecao = CreateObject("Uni.Business.DFe.Xml.CTe.InfCorrecao")
 oInfCorrecao.GrupoAlterado = "ide"
 oInfCorrecao.CampoAlterado = "cfop"
 oInfCorrecao.ValorAlterado = "6353"
 oInfCorrecao.NroItemAlterado = ""
 
 'Adicionar o conteúdo da 1a tag de correção <infCorrecao> dentro da tag <evCCeCTe>
 oEventoCCeCTe.AddInfCorrecao (oInfCorrecao)
 
 'Criar a tag <infCorrecao> da 2a correção
 Set oInfCorrecao = CreateObject("Uni.Business.DFe.Xml.CTe.InfCorrecao")
 oInfCorrecao.GrupoAlterado = "ide"
 oInfCorrecao.CampoAlterado = "cfop"
 oInfCorrecao.ValorAlterado = "6352"
 oInfCorrecao.NroItemAlterado = ""
 
 'Adicionar o conteúdo da 2a tag de correção <infCorrecao> dentro da tag <evCCeCTe>
 oEventoCCeCTe.AddInfCorrecao (oInfCorrecao)  
 
 'Criar a tag <infCorrecao> da 3a correção
 Set oInfCorrecao = CreateObject("Uni.Business.DFe.Xml.CTe.InfCorrecao")
 oInfCorrecao.GrupoAlterado = "ide"
 oInfCorrecao.CampoAlterado = "cfop"
 oInfCorrecao.ValorAlterado = "6351"
 oInfCorrecao.NroItemAlterado = ""
 
 'Adicionar o conteúdo da 3a tag de correção <infCorrecao> dentro da tag <evCCeCTe>
 oEventoCCeCTe.AddInfCorrecao (oInfCorrecao)   
 
 'Atualizar o conteúdo da tag de detalhes do evento com o objeto criado.  
 oDetEventoCCe.EventoCCeCTe = oEventoCCeCTe 
 
 'Criar tag <infEvento>
 Set oInfEvento = CreateObject("Uni.Business.DFe.Xml.CTe.InfEvento")
 
 'Adicionar o Objeto oDetEventoCCE dentro do objeto DetEvento
 oInfEvento.DetEvento = oDetEventoCCE
 
 'Atualizar propriedades da oInfEvento
 'IMPORTANTE: Atualização da propriedade TpEvento deve acontecer depois que o DetEvento recebeu o oDetEventoCCE para que funcione sem erro
 oInfEvento.COrgao = 41 'UFBrasil.PR
 oInfEvento.ChCTe = "41191006117473000150550010000579281779843610"
 oInfEvento.CNPJ = "06117473000150"
 oInfEvento.DhEvento = Now
 oInfEvento.TpEvento = 110110 'TipoEventoCTe.CartaCorrecao
 oInfEvento.NSeqEvento = 1
 oInfEvento.TpAmb = 2 'TipoAmbiente.Homologacao

 'Adicionar a tag <infEvento> dentro da tag <eventoCTe>
 oEventoCTe.InfEvento = oInfEvento

 'Demonstrar alguns valores informados no XML para ficar o modelo de como resgatar a informação
 MsgBox oEventoCTe.Versao 'Demonstrar a versão informada no XML
 MsgBox oEventoCTe.InfEvento.COrgao 'Demonstrar o cOrgao informado no XML
 MsgBox oEventoCTe.InfEvento.CNPJ 'Demonstrar o CNPJ infomrado no XML
 MsgBox oEventoCTe.InfEvento.DhEvento 'Demonstrar o CNPJ infomrado no XML
 
 'Enviar carta de correcao
 Set oRecepcaoEvento = CreateObject("Uni.Business.DFe.Servicos.CTe.RecepcaoEvento")
 oRecepcaoEvento.Executar (oEventoCTe),  (oConfiguracao)
  
 MsgBox oRecepcaoEvento.RetornoWSString
 MsgBox oRecepcaoEvento.Result.InfEvento.CStat 'Status retornado pela SEFAZ
 MsgBox oRecepcaoEvento.Result.InfEvento.XMotivo 'XMotivo
 
 if oRecepcaoEvento.Result.InfEvento.CStat = 134 Then
    oRecepcaoEvento.GravarXmlDistribuicao ("tmp\testenfe") 'Grava o XML de distribuição
 end if