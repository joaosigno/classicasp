<!-- #include file="./../_classes/blogger_rss.class.asp" -->
<%
Class Index
    Public Function listaRssImages(maxNews)
        Set r = new RssFlickr
        Dim tmp2
        tmp2 = r.rssFromFlickr("http://api.flickr.com/services/feeds/photos_public.gne?id=77449999@N00&lang=pt-br&format=rss_200", Clng(maxNews))
        listaRssImages = tmp2
    End Function

    Public Function listaRssVideos(maxNews)
        Set r = new RSSYoutube
        Dim tmp2
        tmp2 = r.rssFromYouTube(theUser, cLng(maxNews))
        listaRssVideos = tmp2
    End Function

    Public Function listaRssBlogger(maxNews)
        Set r = new RssBlogger
        Dim tmp2
        tmp2 = r.getPrincipalRss(maxNews)
        listaRssBlogger = tmp2
    End Function



    Public Function reflectMethod()
        Set reflectMethod = Server.CreateObject("Scripting.Dictionary")
        With reflectMethod
            .Add "function listaRssImages", "maxNews"
            .Add "function listaRssVideos", "maxNews"
            .Add "function listaRssBlogger", "maxNews"
        End With
    End Function
End Class


If request.QueryString("m") = "" Then
    path = "./_view/index.view.asp"
    writeMethodsToJson "Index", path
End If
%>
<!-- #include file="../_lib/asp3tojson_reflector.lib.asp" -->