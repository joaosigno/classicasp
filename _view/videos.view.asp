<!-- #include file="./../_lib/pagecounter.lib.asp" -->
<!-- #include file="./../_lib/rss.lib.asp" -->
<!-- #include file="./../_classes/youtube_rss.class.asp" -->
<%
Class Index
	Public Sub Class_Initialize()
		If IsEmpty(Session("timeInit")) Then
			Session("timeInit") = now
		End If

		'Session.Abandon()
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


	Public Function listaRssYoutube(id)
		Dim theID : theID = id
		Dim tmp2 : tmp2 = ""

		If IsEmpty(Session("lastID")) Then
			Session("lastID") = theID
		End if

        Set r = new RssYoutube
		If IsEmpty(Session("rssVideos")) or Session("lastID") <> id Then
			tmp2 = r.getOneRss(id)
			Session("rssVideos") = tmp2
			Session("lastID") = id
		ElseIf DateDiff("n", Session("timeInit"), now) > 10 then
			tmp2 = r.getOneRss(id)
			Session("rssVideos") = tmp2
			Session("timeInit") = now
		End If

		listaRssYoutube = Session("rssVideos")
	End Function

	Public Function listaMenuLeftVideos(page)
        recordsPerPage = 100
        Set r = new RssYoutube
		listaMenuLeftVideos = r.getMedias(page,recordsPerPage)
	End Function


    Public Function reflectMethod()
        Set reflectMethod = Server.CreateObject("Scripting.Dictionary")
        With reflectMethod
            .Add "function listaPrincipalRssYoutube", ""
			.Add "function listaMenuLeftVideos", "page"
			.Add "function listaRssYoutube", "id"
        End With
    End Function
End Class


If request.QueryString("m") = "" Then
    path = "./_view/videos.view.asp"
    writeMethodsToJson "Index", path
End If
%>
<!-- #include file="../_lib/asp3tojson_reflector.lib.asp" -->