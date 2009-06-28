<!-- #include file="./../_classes/noticias.class.asp" -->
<!-- #include file="./../_classes/pessoa.class.asp" -->
<!-- #include file="./../_lib/rss.lib.asp" -->
<!-- #include file="./../_lib/xml2json.lib.asp" -->
<%
Class Index
    Public Function listaNoticias(page)
        recordsPerPage = "3"
        Set n = new Noticias
        listaNoticias = n.getNoticias(page,recordsPerPage)
    End Function

    Public Function listaPessoas()
        Set p = new Pessoa
        listaPessoas = p.getPessoa()
    End Function

    Public Function listaRssImages(maxNews)
        Set r = new RSS
        Dim tmp2
        tmp2 = r.rssFromFlickr("http://api.flickr.com/services/feeds/photos_public.gne?id=77449999@N00&lang=pt-br&format=rss_200", Clng(maxNews))
        listaRssImages = tmp2
    End Function

    Public Function listaRssVideos(maxNews)
        Set r = new RSS
        Dim tmp2
        'tmp2 = r.rssFromYouTube("http://gdata.youtube.com/feeds/base/users/Irategamer/uploads?alt=rss&v=2&orderby=published&client=ytapi-youtube-profile", cLng(maxNews))
        tmp2 = r.rssFromYouTube("http://gdata.youtube.com/feeds/base/users/dvddatv/uploads?alt=rss&v=2&orderby=published&client=ytapi-youtube-profile", cLng(maxNews))
        listaRssVideos = tmp2
    End Function


    Public Function listaRssBlogger(maxNews)
        Set r = new RSS
        Dim tmp2
        tmp2 = r.rssFromBlogger("http://yes-downloads.blogspot.com/feeds/posts/default?alt=rss", cLng(maxNews))
        'tmp2 = r.rssFromBlogger("http://feeds.feedburner.com/IssoMesmo", cLng(maxNews))
        listaRssBlogger = tmp2
    End Function



    Public Function reflectMethod()
        Set reflectMethod = Server.CreateObject("Scripting.Dictionary")
        With reflectMethod
            .Add "function listaRssImages", "maxNews"
            .Add "function listaRssVideos", "maxNews"
            .Add "function listaRssBlogger", "maxNews"
            .Add "function listaNoticias", "page"
            .Add "function listaPessoas", ""
        End With
    End Function
End Class


If request.QueryString("m") = "" Then
    path = "./_view/index.view.asp"
    writeMethodsToJson "Index", path
End If
%>
<!-- #include file="../_lib/asp3tojson_reflector.lib.asp" -->