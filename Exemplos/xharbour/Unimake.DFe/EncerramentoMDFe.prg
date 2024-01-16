* ---------------------------------------------------------------------------------
* Enviar evento de encerramento do MDFe
* ---------------------------------------------------------------------------------
#IfNdef __XHARBOUR__
   #xcommand TRY => BEGIN SEQUENCE WITH {| oErr | Break( oErr ) }
   #xcommand CATCH [<!oErr!>] => RECOVER [USING <oErr>] <-oErr->
#endif
 
Function EncerramentoMDFe()
   Local oErro, oExceptionInterop
   Local oConfiguracao
   Local oEnvEvento, oEventoMDFe, oDetEventoEncMDFe, oInfEvento
   
 * Criar configuraçao básica para consumir o serviço
   oConfiguracao = CreateObject("Uni.Business.DFe.Servicos.Configuracao")
   oConfiguracao:TipoDfe = 4 // 4=MDFe
   oConfiguracao:CertificadoSenha = "12345678"
   oConfiguracao:CertificadoArquivo = "C:\Projetos\certificados\UnimakePV.pfx"

 * Criar tag EnvEvento
   oEnvEvento = CreateObject("Uni.Business.DFe.Xml.NFe.EnvEvento")
   oEnvEvento:Versao = "3.00"
   oEnvEvento:IdLote = "000000000000001"

 * -------------------------------------------------
 * Criar tags do evento sequencia
 * -------------------------------------------------
 * Criar tag Evento
   oEventoMDFe = CreateObject("Uni.Business.DFe.Xml.MDFe.EventoMDFe")
   oEventoMDFe:Versao = "3.00"
 
 * Criar tag DetEventoEncMDFe
 //NEW
   oDetEventoEncMDFe = CreateObject("Uni.Business.DFe.Xml.MDFe.DetEventoEncMDFe")
   oDetEventoEncMDFe:VersaoEvento = "3.00"
   oDetEventoEncMDFe:NProt = "141200000007987"
   oDetEventoEncMDFe:CMun = 3106200
   oDetEventoEncMDFe:CUF = 41
   oDetEventoEncMDFe:DtEnc = DateTime()

 * Criar tag InfEvento
   oInfEvento = CreateObject("Uni.Business.DFe.Xml.MDFe.InfEvento")
 
 * Adicionar a tag DetEventoCanc dentro da Tag DetEvento
   oInfEvento:DetEvento = oDetEventoEncMDFe
 
 * Atualizar propriedades da oInfEvento
 * IMPORTANTE: Atualização da propriedade TpEvento deve acontecer depois que o DetEvento recebeu o oDetEventoCanc para que funcione sem erro
   oInfEvento:COrgao = 41 // UFBrasil.PR
   oInfEvento:ChMDFe = "41200210859283000185570010000005671227070615"
   oInfEvento:CNPJ = "10859283000185"
   oInfEvento:DhEvento = DateTime()
   oInfEvento:TpEvento = 110112 // TipoEventoNFe.Encerramento  //NEW
   oInfEvento:NSeqEvento = 1
   oInfEvento:TpAmb = 2 // TipoAmbiente.Homologacao

 * Adicionar a tag InfEvento dentro da tag Evento
   oEventoMDFe:InfEvento = oInfEvento

 * Resgatando alguns dados do objeto do XML do evento
   ? "<versao>:", oEventoMDFe:Versao
   ? "<cOrgao>:", oEventoMDFe:InfEvento:COrgao
   ? "<chMDFe>:", oEventoMDFe:InfEvento:ChMDFe
   ? "<nProt>: ", oEventoMDFe:InfEvento:DetEvento:NProt
   ?
   ?
   Wait   
   
   // Criar objeto para pegar exceção do lado do CSHARP
   oExceptionInterop = CreateObject("Uni.Exceptions.ThrowHelper")   
   
   Try 
    * Enviar evento
      oRecepcaoEvento = CreateObject("Uni.Business.DFe.Servicos.MDFe.RecepcaoEvento")
      oRecepcaoEvento:Executar(oEventoMDFe,  oConfiguracao)
      
	  //Demonstrar o XML retornado pela SEFAZ
      ? oRecepcaoEvento:RetornoWSString
	  ?
	  ?
	  Wait
	  
      ? "CStat do Lote Retornado:", oRecepcaoEvento:Result:InfEvento:CStat, "- XMotivo:", oRecepcaoEvento:Result:InfEvento:XMotivo
 
      if oRecepcaoEvento:Result:InfEvento:CStat == 135 //Recebido pelo Sistema de Registro de Eventos, com vinculação do evento no respetivo MDFe
         oRecepcaoEvento:GravarXmlDistribuicao("d:\testenfe") //Grava o XML de distribuição
      Else
         //Foi rejeitado, fazer devidos tratamentos	  
      EndIf 
	  ?
	  ?
	  Wait

   Catch oErro
      //Demonstrar exceções geradas no proprio Harbour, se existir.
	  ? "ERRO"
	  ? "===="
	  ? "Falha ao tentar consultar o status do servico."
      ? oErro:Description
      ? oErro:Operation
	  
      //Demonstrar a exceção do CSHARP
	  ?
      ? "Excecao do CSHARP - Message: ", oExceptionInterop:GetMessage()
      ? "Excecao do CSHARP - Codigo: ", oExceptionInterop:GetErrorCode()
      ?     
	  
	  Wait
	  cls   
   End	   
Return