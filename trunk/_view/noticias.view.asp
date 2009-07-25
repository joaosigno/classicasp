<!-- #include file="./../_lib/pagecounter.lib.asp" -->
<!-- #include file="./../_lib/rss.lib.asp" -->
<!-- #include file="./../_classes/blogger_rss.class.asp" -->
<%
Class Index
	Public Sub Class_Initialize()
		If IsEmpty(Session("timeInit")) Then
			Session("timeInit") = now
		End If

		'Session.Abandon()
		'Response.Write DateDiff("n", Session("timeInit"), now)
	End Sub

    Public Function listaPrincipalRssBlogger()
        recordsPerPage = "50"
        Set r = new RssBlogger
        Dim tmp2
		If IsEmpty(Session("rssNoticias")) Then
			tmp2 = r.getPrincipalRssFeed(recordsPerPage)
			Session("rssNoticias") = tmp2
		ElseIf DateDiff("n", Session("timeInit"), now) > 10 then
			tmp2 = r.getPrincipalRssFeed(recordsPerPage)
			Session("rssNoticias") = tmp2
			Session("timeInit") = now
		End If

        listaPrincipalRssBlogger = Session("rssNoticias")
    End Function


	Public Function listaRssBlogger(id)
		Dim theID : theID = id
		Dim tmp2 : tmp2 = ""

        Set r = new RssBlogger
		If IsEmpty(Session("rssNoticias")) or Session("lastID") <> id Then
			tmp2 = r.getOneRss(id)
			Session("rssNoticias") = tmp2
			Session("lastID") = id
		ElseIf DateDiff("n", Session("timeInit"), now) > 10 then
			tmp2 = r.getOneRss(id)
			Session("rssNoticias") = tmp2
			Session("timeInit") = now
		End If

		If IsEmpty(Session("lastID")) Then
			Session("lastID") = theID
		End if

		listaRssBlogger = Session("rssNoticias")
	End Function

	Public Function listaMenuLeftNoticias(page)
        recordsPerPage = 100
        Set r = new RssBlogger
		listaMenuLeftNoticias = r.getMedias(page,recordsPerPage)
	End Function


    Public Function reflectMethod()
        Set reflectMethod = Server.CreateObject("Scripting.Dictionary")
        With reflectMethod
            .Add "function listaPrincipalRssBlogger", ""
			.Add "function listaMenuLeftNoticias", "page"
			.Add "function listaRssBlogger", "id"
        End With
    End Function
End Class


If request.QueryString("m") = "" Then
    path = "./_view/noticias.view.asp"
    writeMethodsToJson "Index", path
End If
%>
<!-- #include file="../_lib/asp3tojson_reflector.lib.asp" -->