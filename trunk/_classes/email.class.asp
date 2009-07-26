<%
Class Email
    Public Function sendMail(remetente,assunto,msg)
		sendMail = remetente &"-"& assunto &"-"& msg
    End Function
End Class
%>