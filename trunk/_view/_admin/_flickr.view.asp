<!-- #include file="./../../_classes/noticias.class.asp" -->
<!-- #include file="./../../_lib/rss.lib.asp" -->
<!-- #include file="./../../_classes/flickr_rss.class.asp" -->
<%
Class Start
    Public Function createRSS(idrss,titulo,textoCurto,mediaTipo,url)
        Set r = new RSSFlickr
		If idrss = "0" Then
			res = r.toInsertRss(titulo,textoCurto,mediaTipo,url)
		Else
			res = r.toUpdateRSS(idrss,titulo,textoCurto,mediaTipo,url)
		End If
        createRSS =  res
    End Function


    Public Function readRSS(id, page)
        recordsPerPage = "5"
        Set n = new RSSFlickr
		If id = "0" Then
			res = n.getRss(page,recordsPerPage)
		Else
			res = n.getOneRss(id)
		End If
		readRss = res
    End Function


	Public Function setPrincipal(id)
        Set r = new RSSFlickr
		setPrincipal = r.setPrincipal(id)
	End Function


    Public Function deleteRSS(id)
        Set r = new RSSFlickr
        deleteRSS = r.toDeleteRss (id)
    End Function


    Public Function reflectMethod()
        Set reflectMethod = Server.CreateObject("Scripting.Dictionary")
        With reflectMethod
            .Add "function listaNoticias"	, "page"
            .Add "function createRSS"		, "idrss,titulo,textoCurto,mediaTipo,url"
            .Add "function readRSS"			, "id, page"
            .Add "function deleteRSS"		, "id"
            .Add "function setPrincipal"	, "id"
        End With
    End Function
End Class


If request.QueryString("m") = "" Then
    path = "./../_view/_admin/_flickr.view.asp"
    writeMethodsToJson "start", path
End If
%>
<!-- #include file="./../../_lib/asp3tojson_reflector.lib.asp" -->