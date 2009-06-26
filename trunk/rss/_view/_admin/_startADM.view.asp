<!-- #include file="./../../_classes/noticias.class.asp" -->
<%
Class startADM
    Public Function listaNoticias(page)
        recordsPerPage = "20"
        Set n = new Noticias
        listaNoticias = n.getNoticias(page,recordsPerPage)
    End Function



    Public Function reflectMethod()
        Set reflectMethod = Server.CreateObject("Scripting.Dictionary")
        With reflectMethod
            .Add "function listaNoticias", "page"
        End With
    End Function
End Class


If request.QueryString("m") = "" Then
    path = "./../_view/_admin/_startADM.view.asp"
    writeMethodsToJson "startADM", path
End If
%>
<!-- #include file="./../../_lib/asp3tojson_reflector.lib.asp" -->