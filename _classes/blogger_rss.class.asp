<%
Class RssBlogger
    Public Function getMedias(page,quantity)
        Set conn = Session("objConn")
        sqlCount = "select count(idRss) as tot from rss where mediaTipo='blogger' "
        Set rs2 = conn.execute(sqlCount)

        totPages = toCount(rs2("tot"),quantity)
        page = page * quantity

        sql = "select idRss,titulo,textoCurto,mediatipo,principalBlogger,url from rss where mediaTipo='blogger' order by principalBlogger DESC,idRss DESC Limit " & page & "," & quantity & ""
        Set rs = conn.execute(sql)
        getMedias = "{""rss"":" & toJSON(rs) &",""pages"":"& totPages &",""actualPage"":"& page &"}"
    End Function

    Public Function getRss(page,quantity)
        Set conn = Session("objConn")
        sqlCount = "select count(idRss) as tot from rss where mediaTipo='blogger' "
        Set rs2 = conn.execute(sqlCount)

        totPages = toCount(rs2("tot"),quantity)
        page = page * quantity

        sql = "select idRss,titulo,textoCurto,mediatipo,principalBlogger,url from rss where mediaTipo='blogger' order by principalBlogger DESC,idRss DESC Limit " & page & "," & quantity & ""
        Set rs = conn.execute(sql)
        getRss = "{""rss"":" & toJSON(rs) &",""pages"":"& totPages &",""actualPage"":"& page &"}"
    End Function


    Public Function getOneRss(id)
        Set conn = Session("objConn")
        sql = "select idRss,titulo,textoCurto,mediatipo,url from rss where idRss = " & id & " "
        Set rs = conn.execute(sql)
        getOneRss = "{""rss"":" & toJSON(rs) &"}"
    End Function


    Public Function getPrincipalRssFeed(maxNews)
        Set r = new RSSLib
        Set conn = Session("objConn")
        sql = "select url from rss where principalBlogger = 1 "
        Set rs = conn.execute(sql)

        tmp2 = r.rssFromBlogger(rs("url"), maxNews)

        getPrincipalRssFeed = "{""rss"":" & tmp2 &"}"
    End Function



    Public Function toInsertRss(titulo,textoCurto,mediaTipo,url)
        Set n = new RSSLib
        strError = n.rssTest(url, "blogger")
        
        If strError = "" Then
            Set conn = Session("objConn")
            sql_ = "insert into rss (titulo,textoCurto,mediaTipo,url) " &_
                   "values ('" & titulo & "','" & textoCurto & "','" & mediaTipo & "','" & url & "')"

            conn.execute(sql_)
        End If
        
       toInsertRss = "{""error"":""" & strError & """}"
    End Function


    Public Function toUpdateRss(id,titulo,textoCurto,mediaTipo,url)
        Set n = new RSSLib
        strError = n.rssTest(url, "blogger")
        
        If strError = "" Then
			Set conn = Session("objConn")
			sql_ = "update rss set " &_
				   "titulo='" & titulo & "',textoCurto='" & textoCurto & "',mediaTipo='" & mediaTipo & "',url='" & url & "' " &_
				   "where idRss="& id
			conn.execute(sql_)
		End If

		toUpdateRss = "{""error"":""" & strError & """}"
	End Function


    Public Function setPrincipal(id)
		On Error resume next
		Set conn = Session("objConn")
		sql_ = "update rss set " &_
			   "principalBlogger=0 "
		conn.execute(sql_)

		sql_ = "update rss set " &_
			   "principalBlogger=1 " &_
			   "where idRss="& id
		conn.execute(sql_)

		Dim strError
		strError = ""
		If Err.number <> 0 Then
			strError = Err.Description
		End If

		setPrincipal = "{""error"":""" & strError & """}"
	End Function


    Public Function toDeleteRss(id)
		On Error resume next
		Set conn = Session("objConn")
		sql_ = "delete from rss where idRss="& id
		conn.execute(sql_)
	
		Dim strError
		strError = ""
		If Err.number <> 0 Then
			strError = Err.Description
		End If

		toDeleteRss = "{""error"":""" & strError & """}"
    End Function

End Class
%>