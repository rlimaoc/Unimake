Try
	Local LcSchema,LoConfig,LoMsg,LoError,LcErr
	m.LcErr    = ""
	m.LcSchema = "http://schemas.microsoft.com/cdo/configuration/"
	m.LoConfig = CreateObject("CDO.Configuration")
	With LoConfig.Fields
		.Item(m.LcSchema+"smtpserver")            = "smtp.gmail.com"
		.Item(m.LcSchema+"smtpserverport")        = 587
		.Item(m.LcSchema+"sendusing")             = 2
		.Item(m.LcSchema+"smtpauthenticate")      = .T.
		.Item(m.LcSchema+"smtpusessl")            = .F.
		.Item(m.LcSchema+"sendusername")          = "awbinfo23@gmail.com"
		.Item(m.LcSchema+"sendpassword")          = "@Awbinfo12"
		.Item(m.LcSchema+"smtpconnectiontimeout") = 60
	    .Item(m.LcSchema+"urn:schemas:mailheader:X-Priority") = 1
		.Update
	EndWith
	LoMsg = CreateObject ("CDO.Message")
	With LoMsg
		.Configuration = m.LoConfig
		.From          = "Teste <teste@teste.com.br>"
		.To            = "awbinfo23@gmail.com"
		.Subject       = "Teste"
   	    .TextBody      = "Isto � um teste."
        .HtmlBody      = "Isto � um teste"
   	    .AddAttachment("C:\Teste\arquivo.txt") && envia o anexo
		.Send()
	EndWith
Catch To m.LoError
    m.LcErr = [N�o foi poss�vel enviar o e-mail, poss�veis raz�es:]+Chr(13)+;
              [O E-Mail do remetente pode n�o existir;]            +Chr(13)+;
              [A Senha pode est� errada;]                          +Chr(13)+;
              [O Nome do Usu�rio pode estar errado;]               +Chr(13)+;
              [O Servidor de SMTP do E-Mail pode estar errado;]    +Chr(13)+;
              [A Porta do Servidor de SMTP pode estar errada;]     +Chr(13)+;
              [O requerimento da Autentica��o pode est� errado;]   +Chr(13)+;
              [O requerimento do protocolo SSL pode estar errado;] +Chr(13)+;
              [O E-Mail "Cc" pode n�o existir;]                    +Chr(13)+;
              [O E-Mail "Cco" pode n�o existir;]                   +Chr(13)+;
              [Pode ter passado o n�mero de e-mails que o seu provedor aceita.]
Finally
	Release LoConfig,LoMsg
	If !Empty(m.LcErr)
		MessageBox(m.LcErr)
	EndIf
EndTry