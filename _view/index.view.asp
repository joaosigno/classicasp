<!-- #include file="./../_lib/pagecounter.lib.asp" -->
<!-- #include file="./../_lib/rss.lib.asp" -->
<!-- #include file="./../_classes/youtube_rss.class.asp" -->
<!-- #include file="./../_classes/blogger_rss.class.asp" -->
<!-- #include file="./../_classes/flickr_rss.class.asp" -->
<%
Class Index
	Public Sub Class_Initialize()
		If IsEmpty(Session("timeInit")) Then
			Session("timeInit") = now
		End If

		'Response.Write DateDiff("n", Session("timeInit"), now)
	End Sub


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


	Public Function listaMenuLeftVideos(page)
        recordsPerPage = 5
        Set r = new RssYoutube
		listaMenuLeftVideos = r.getMedias(page,recordsPerPage)
	End Function


	Public Function listaMenuLeftNoticias(page)
        recordsPerPage = 5
        Set r = new RssBlogger
		listaMenuLeftNoticias = r.getMedias(page,recordsPerPage)
	End Function

	Public Function listaMenuLeftImagens(page)
        recordsPerPage = 5
        Set r = new RssFlickr
		listaMenuLeftImagens = r.getMedias(page,recordsPerPage)
	End Function


    Public Function reflectMethod()
        Set reflectMethod = Server.CreateObject("Scripting.Dictionary")
        With reflectMethod
            .Add "function listaPrincipalRssYoutube", ""
			.Add "function listaMenuLeftVideos", "page"
			.Add "function listaMenuLeftNoticias", "page"
			.Add "function listaMenuLeftImagens", "page"
        End With
    End Function
End Class


If request.QueryString("m") = "" Then
    path = "./_view/index.view.asp"
    writeMethodsToJson "Index", path
End If
%>
<!-- #include file="../_lib/asp3tojson_reflector.lib.asp" -->