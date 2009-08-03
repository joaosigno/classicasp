<%
Class Email
    Public Function sendMail(remetente,assunto,msg)
		Dim resposta : resposta = ""
		Set Mailer = Server.CreateObject("SMTPsvg.Mailer")
		Mailer.RemoteHost = "mail.seresteatro.com.br"
		Mailer.FromName = remetente
		Mailer.FromAddress = remetente
		Mailer.AddRecipient "[Elenco - OS SERES]", "elencoseres@yahoo.com.br"
		Mailer.Subject = assunto

		Mailer.BodyText = msg

		if Mailer.SendMail then 
			resposta = "E-mail enviado com sucesso, aguarde o elenco entrar em contato ." 
		else 
			resposta = "Ocorreu um erro ao enviar o e-mail " & mailer.response
		end if
		sendMail = resposta
    End Function
End Class
%>