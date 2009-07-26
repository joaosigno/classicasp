<!-- #include file="./../_classes/email.class.asp" -->
<%
Class Index
	Public Sub Class_Initialize()
		If IsEmpty(Session("timeInit")) Then
			Session("timeInit") = now
		End If

		'Session.Abandon()
		'Response.Write DateDiff("n", Session("timeInit"), now)
	End Sub


    Public Function enviarEmail_(remetente,msg)
		Set e = new Email
		assunto = "Contato"
        enviarEmail_ = e.sendMail (remetente,assunto,msg)
    End Function


    Public Function reflectMethod()
        Set reflectMethod = Server.CreateObject("Scripting.Dictionary")
        With reflectMethod
            .Add "function enviarEmail_", "remetente,msg"
        End With
    End Function
End Class


If request.QueryString("m") = "" Then
    path = "./_view/contato.view.asp"
    writeMethodsToJson "Index", path
End If
%>
<!-- #include file="../_lib/asp3tojson_reflector.lib.asp" -->