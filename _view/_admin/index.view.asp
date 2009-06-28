<!-- #include file="./../../_classes/usuario.class.asp" -->
<%
Class IndexADM
    Public Function executeLogin(login_,pass_)
        Set u = new Usuario
        u.login = login_
        u.senha = pass_
        executeLogin = u.getUsuario()
    End Function

    Public Function reflectMethod()
        Set reflectMethod = Server.CreateObject("Scripting.Dictionary")
        With reflectMethod
            .Add "function executeLogin", "login_,pass_"
        End With
    End Function
End Class


If request.QueryString("m") = "" Then
    path = "./../_view/_admin/index.view.asp"
    writeMethodsToJson "IndexADM", path
End If
%>
<!-- #include file="./../../_lib/asp3tojson_reflector.lib.asp" -->