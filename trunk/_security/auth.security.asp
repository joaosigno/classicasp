<%
	If trim(Session("user")) = "" Then
		Response.Redirect("./")
	ElseIf LCase(TypeName(Session("objConn"))) = "empty" Then
		Response.Redirect("./")
	ElseIf IsNull(Session("objConn")) Then
		Response.Redirect("./")
	ElseIf IsEmpty(Session("objConn")) Then
		Response.Redirect("./")
	End If
%>