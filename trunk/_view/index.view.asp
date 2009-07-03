<!-- #include file="./../_classes/blogger_rss.class.asp" -->
<%
Class Index
    Public Function listaRssImages(maxNews)
        Set r = new RssFlickr
        Dim tmp2
        tmp2 = r.rssFromFlickr(Clng(maxNews))
        listaRssImages = "foo"
    End Function

    Public Function listaRssVideos(maxNews)
        Set r = new RSSYoutube
        Dim tmp2
        tmp2 = r.rssFromYouTube(theUser, cLng(maxNews))
        listaRssVideos = tmp2
    End Function


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


    Public Function principalRssYoutube(maxNews)
        Set r = new RssYoutube
        Dim tmp2
        tmp2 = r.getPrincipalRssFeed(maxNews)
        principalRssYoutube = "foo"
    End Function


    Public Function principalRssFlickr(maxNews)
        Set r = new RssFlickr
        Dim tmp2
        tmp2 = r.getPrincipalRssFeed(maxNews)
        principalRssFlickr = "foo"
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
            .Add "function listaRssImages", "maxNews"
            .Add "function listaRssVideos", "maxNews"
            .Add "function listaRssBlogger", "id,page"
            .Add "function listaPrincipalRssBlogger", ""
            .Add "function principalRssBlogger", "maxNews"
        End With
    End Function
End Class


If request.QueryString("m") = "" Then
    path = "./_view/index.view.asp"
    writeMethodsToJson "Index", path
End If
%>
<!-- #include file="../_lib/asp3tojson_reflector.lib.asp" -->