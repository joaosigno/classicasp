<!-- #include file="./../_lib/pagecounter.lib.asp" -->
<!-- #include file="./../_lib/rss.lib.asp" -->
<!-- #include file="./../_classes/flickr_rss.class.asp" -->
<%
Class Index
	Public Sub Class_Initialize()
		If IsEmpty(Session("timeInit")) Then
			Session("timeInit") = now
		End If

		'Session.Abandon()
		'Response.Write DateDiff("n", Session("timeInit"), now)
	End Sub


    Public Function listaPrincipalRssFlickr()
        recordsPerPage = "50"
        Set r = new RssFlickr
        Dim tmp2
		If IsEmpty(Session("rssImages")) Then
			tmp2 = r.getPrincipalRssFeedElenco(recordsPerPage)
			Session("rssImagens") = tmp2
		ElseIf DateDiff("n", Session("timeInit"), now) > 10 then
			tmp2 = r.getPrincipalRssFeedElenco(recordsPerPage)
			Session("rssImagens") = tmp2
			Session("timeInit") = now
		End If
        listaPrincipalRssFlickr = Session("rssImagens")
    End Function


	Public Function listaRssFlickr(id)
		Dim theID : theID = id
		Dim tmp2 : tmp2 = ""

        Set r = new RssFlickr
		If IsEmpty(Session("rssImagens")) or Session("lastID") <> id Then
			tmp2 = r.getOneRssElenco(id)
			Session("rssImagens") = tmp2
			Session("lastID") = id
		ElseIf DateDiff("n", Session("timeInit"), now) > 10 then
			tmp2 = r.getOneRssElenco(id)
			Session("rssImagens") = tmp2
			Session("timeInit") = now
		ElseIf Session("lastID") <> id Then
			tmp2 = r.getOneRssElenco(id)
			Session("rssVideos") = tmp2
			Session("lastID") = id
		End If

		If IsEmpty(Session("lastID")) Then
			Session("lastID") = theID
		End if

		listaRssFlickr = Session("rssImagens")
	End Function


	Public Function listaMenuLeftImages(page)
        recordsPerPage = 3
        Set r = new RssFlickr
		listaMenuLeftImages = r.getRssElenco(page,recordsPerPage)
	End Function


    Public Function reflectMethod()
        Set reflectMethod = Server.CreateObject("Scripting.Dictionary")
        With reflectMethod
            .Add "function listaPrincipalRssFlickr", ""
			.Add "function listaMenuLeftImages", "page"
			.Add "function listaRssFlickr", "id"
        End With
    End Function
End Class


If request.QueryString("m") = "" Then
    path = "./_view/grupo.view.asp"
    writeMethodsToJson "Index", path
End If
%>
<!-- #include file="../_lib/asp3tojson_reflector.lib.asp" -->