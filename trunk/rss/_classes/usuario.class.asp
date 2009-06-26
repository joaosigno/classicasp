<!-- #include file="./../_security/hexmd5.hexsha1.security.asp" -->
<%
Class Usuario
    Public id
    Public login
    Public senha
    
    Public function reflect()
        set reflect = Server.CreateObject("Scripting.Dictionary")
        with reflect
            .Add "id"       , id
            .Add "login"    , login
            .Add "senha"    , senha
        End with
    End Function
End Class
%>