<!-- #include file="./../_lib/pagecounter.lib.asp" -->
<!-- #include file="./../_lib/rss.lib.asp" -->
<!-- #include file="./../_classes/youtube_rss.class.asp" -->
<%
Class Index
	Public Sub Class_Initialize()
		If IsEmpty(Session("timeInit")) Then
			Session("timeInit") = now
		End If

		'Response.Write DateDiff("n", Session("timeInit"), now)
	End Sub


    Public Function listaRssBlogger(id, page)
        recordsPerPage = "5"
        Set n = new RssBlogger
		If id = "0" Then
			res = n.getRss(page,recordsPerPage)
		Else
			res = n.getOneRss(id)
		End If
		listaRssBlogger = res
    End Function

    Public Function listaPrincipalRssBlogger()
        recordsPerPage = "50"
        Set n = new RssBlogger
		res = n.getPrincipalRssFeed(recordsPerPage)
		listaPrincipalRssBlogger = res
    End Function


    Public Function listaPrincipalRssYoutube()
        recordsPerPage = "50"
        Set r = new RssYoutube
        Dim tmp2
		If IsEmpty(Session("rssVideos")) Then
			tmp2 = r.getPrincipalRssFeed(recordsPerPage)
			Session("rssVideos") = tmp2
		ElseIf DateDiff("n", Session("timeInit"), now) > 10 then
			tmp2 = r.getPrincipalRssFeed(recordsPerPage)
			Session("rssVideos") = tmp2
			Session("timeInit") = now
		End If
        listaPrincipalRssYoutube = Session("rssVideos")
    End Function



    Public Function principalRssBlogger(maxNews)
        Set r = new RssBlogger
        Dim tmp2
        tmp2 = r.getPrincipalRssFeed(maxNews)
        principalRssBlogger = tmp2
    End Function


    Public Function reflectMethod()
        Set reflectMethod = Server.CreateObject("Scripting.Dictionary")
        With reflectMethod
            .Add "function listaPrincipalRssBlogger", ""
            .Add "function listaPrincipalRssYoutube", ""
        End With
    End Function
End Class


If request.QueryString("m") = "" Then
    path = "./_view/index.view.asp"
    writeMethodsToJson "Index", path
End If
%>
<!-- #include file="../_lib/asp3tojson_reflector.lib.asp" -->