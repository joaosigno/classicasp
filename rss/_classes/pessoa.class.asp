<%
Class Pessoa
    public id
    public name
    public lastName
    public Usuario
    
    Public Sub Class_Initialize()
        id = 1111
        name = "aaaa"
        lastName = "bbbb"
        Set Usuario = Server.CreateObject("Scripting.Dictionary")
    End Sub
    
    Public Sub addUsuario(objUser)
        with Usuario
            .Add objUser.id, objUser
        End with
    End Sub

    Public Sub removeUsuario(id)
        Usuario.Remove(id)
    End Sub

    Public function reflect()
        set reflect = Server.CreateObject("Scripting.Dictionary")
        with reflect
            .Add "id", id
            .Add "name", name
            .Add "lastName", lastName
            .Add "Usuario", Usuario
        End with
    End Function
End Class
%>