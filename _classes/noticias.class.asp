<!-- #include file="./../_lib/pagecounter.lib.asp" -->
<%
Class Noticias
    Public Function getNoticias(page,quantity)
        Set conn = Session("objConn")
        sqlCount = "select count(idNoticia) as tot from noticias "
        Set rs2 = conn.execute(sqlCount)

        totPages = toCount(rs2("tot"),quantity)
        page = page * quantity

        sql = "select * from noticias Limit " & page & "," & quantity & ""
        Set rs = conn.execute(sql)
        getNoticias = "{""noticias"":" & toJSON(rs) &",""pages"":"& totPages &",""actualPage"":"& page &"}"
    End Function
End Class
%>