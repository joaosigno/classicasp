<!-- #include file="./_lib/jsonParser.asp" -->
<!-- #include file="./_view/index.view.asp" -->

<html>

<head>

<script language="javascript" type="text/javascript">
    var teste = {
        'hello': 'Hello World !',
        'howdy': 'How do you do ?',
        'fields': [
            {
            'one': 1,
            'two': 2,
            'three': 3
            },
            {
            'one': 11,
            'two': 22,
            'three': 33
            }
        ]
    };

    window.onload = function() {
        alert(teste.fields[0].one);
    }

</script>

</head>

<body>


<%

sJson = "APessoa = {""id"":1,""name"":""Principal"",""lastName"":""Sobrenome"",""Usuario"":[{""id"":21,""login"":""login 1"",""senha"":""senha 1""},{""id"":32,""login"":""login 2"",""senha"":""senha 2""},{""id"":80,""login"":""login 3"",""senha"":""senha 3""}]}"

set oJson = new JsonParser
oJson.JSON = sJson
oJson.parse
Set dictObj = oJson.dictionary

    Dim t : Set t = nothing

	private function parseToObject(dictObj, anObject_, isInner)
		dim v_out : v_out = null
		dim val   : val = ""
		dim k
		dim tp    : tp = ""

        If isInner Then
            Set t = Eval("(new " & anObject_ &")" )
        End If

		if dictObj.count > 0 then
			for each k in dictObj.keys
				val = ""
				tp = anObject_

				if isObject(dictObj(k)) then
					if lCase(typeName(dictObj(k))) = "dictionary" then
				        if not IsNumeric(tp) and isInner then
				            tp = k
'        					Eval("Set t" & "." & tp & "=" & dictObj(k))
				        end if
				        
                        'isInner = false

						val = parseToObject(dictObj(k), k, false)

					else
						val = "[OBJECT]"
					end if
				elseIf isArray(dictObj(k)) then
					val = "Array:"
					for i = 0 to uBound(dictObj(k))
						if isObject(dictObj(k)(i)) or isArray(dictObj(k)(i)) then
							val = parseToObject(dictObj(k)(i), anObject_, false)
						else
							val = val & li(dictObj(k)(i))
						end if
						val = ul(val)
					next
				else
					'val = dictObj(k)


					'Response.Write(anObject_ &"-<br />")
					'Response.Write(k &"-<br />")
					If isInner Then
					'    a =  Eval("t" & "." & k)
					'    Response.Write(TypeName(a) & "<br />")
					End If

				    if not IsNumeric(tp) then
				       Response.Write( tp &" type<br />")
				    end if

				end if
				v_out = v_out & li(k & ": " & val)
			next
		else
			v_out = v_out & li("This JSON representation has no properties. JSON = {}")
		end if

		'parseToObject = ul(v_out)
	end function

    parseToObject dictObj, "Pessoa", true

'Response.write(oJson.getElement("user") & "<br />" & vbCrLf)
'set oJson = nothing



	private function ul(str)
		dim v_out : v_out = "<ul>" & str & "</ul>"
		ul = v_out
	end function

	private function li(str)
		dim v_out : v_out = "<li>" & str & "</li>"
		li = v_out
	end function
	
	private function code(str)
		dim v_out : v_out = "<div style=""white-space:pre; font-family:monospace; margin:0px; padding:4px; font-size:11px;"">" & str & "</div>"
		code = v_out
	end function




Set p = new Pessoa


Set u = new Usuario
u.id = 1
u.login = "login 1"
u.senha = "senha 1"
p.addUsuario(u)

Set u = new Usuario
u.id = 2
u.login = "login 2"
u.senha = "senha 2"
p.addUsuario(u)

Set u = new Usuario
u.id = 3
u.login = "login 3"
u.senha = "senha 3"
p.addUsuario(u)


'Response.Write((new JSON).toJSON(p))

'p.removeUsuario(2)
%>


</body>


</html>
