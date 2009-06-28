<%
Class Pessoa
    Public Function getPessoa()
        Set conn = Session("objConn")
        sql = "select * from usuario"
        Set rs = conn.execute(sql)
        getPessoa = toJSON(rs)
    End Function
End Class
%>