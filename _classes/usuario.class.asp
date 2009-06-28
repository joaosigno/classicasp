<!-- #include file="./../_security/hexmd5.hexsha1.security.asp" -->
<%
Class Usuario
    Public login
    Public senha

    Public Function getUsuario()
        Set conn = Session("objConn")
        sql = "select * from usuario where login='" & login & "' and senha='" & hex_sha1(senha) & "'"
        Set rs = conn.execute(sql)
        exits = "false"        

        If not rs.EOF Then
            exists = "true"
            Session("user") = toJSON(rs)
        Else
            Set Session("user") = nothing
        End If
        
        getUsuario = exists
    End Function
End Class
%>