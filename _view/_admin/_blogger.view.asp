<!-- #include file="./../../_classes/noticias.class.asp" -->
<!-- #include file="./../../_classes/blogger_rss.class.asp" -->
<%
Class Start
    Public Function listaNoticias(page)
        recordsPerPage = "20"
        Set n = new Noticias
        listaNoticias = n.getNoticias(page,recordsPerPage)
    End Function



    Public Function createRSS(idrss,titulo,textoCurto,mediaTipo,url)
        Set r = new Rss
		If idrss = "0" Then
			res = r.toInsertRss(titulo,textoCurto,mediaTipo,url)
		Else
			res = r.toUpdateRSS(idrss,titulo,textoCurto,mediaTipo,url)
		End If
        createRSS =  res
    End Function


    Public Function readRSS(id, page)
        recordsPerPage = "5"
        Set n = new Rss
		If id = "0" Then
			res = n.getRss(page,recordsPerPage)
		Else
			res = n.getOneRss(id)
		End If
		readRss = res
    End Function


	Public Function setPrincipal(id)
        Set r = new Rss
		setPrincipal = r.setPrincipal(id)
	End Function


    Public Function deleteRSS(id)
        Set r = new Rss
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
    path = "./../_view/_admin/_blogger.view.asp"
    writeMethodsToJson "start", path
End If
%>
<!-- #include file="./../../_lib/asp3tojson_reflector.lib.asp" -->