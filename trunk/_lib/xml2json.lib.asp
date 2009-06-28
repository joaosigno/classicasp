<%
Public Function getXML(url)
    ' Create XML object and open RSS feed
    Set objXml = Server.CreateObject("MSXML2.XMLHTTP.3.0")
    objXml.Open "GET", url, false
    objXml.Send()
    getXML = objXml.ResponseText
    ' Clean-up
    Set objXml = Nothing
End Function
%>