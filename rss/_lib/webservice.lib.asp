<%
Class Webservice
    Public Function callCEPWebservices(anCEP)
        Response.Charset="ISO-8859-1"
        Dim objSoapClient : objSoapClient   = NULL
        Dim strMsg        : strMsg          = NULL

        Set objSoapClient = Server.CreateObject("MSSOAP.SoapClient")
        objSoapClient.ClientProperty("ServerHTTPRequest") = TRUE

        'Chama o Web Service, passando URL, NOME do WS
        Call objSoapClient.mssoapinit("http://www.byjg.com.br/site/webservice.php/ws/cep?wsdl", "CEPService")

        'Consome chamando o método
        strMsg = objSoapClient.obterLogradouroAuth(anCEP, "rsoftweb", "zo1f2lf")

        callCEPWebservices = strMsg
    End Function
End Class
%>