<%
Class JsonToVBScript
    public str
    
    Public Sub Class_Initialize()
        'str = ""
        str = "{""id"":0,""name"":"""",""lastName"":""""," &_
        """user"":[{""id"":1,""login"":""login 1"",""senha"":[0,1,2]}," &_ 
        "{""id"":2,""login"":""login 2"",""senha"":[4,5,6]}," &_
        "{""id"":3,""login"":""login 3"",""senha"":[7,8,9]}]" &_
        ",""regras"":[{""ativo"":true,""nivel"":""adm""},{""ativo"":false,""nivel"":""user""}]" &_
        ",""cores"":[""azul"",""preto"",""branco""]" &_
        ",""nascimento"":""01/01/1990""" &_
        "}"
        scan str, "Pessoa"
    End Sub

    Public Function scan(str,aType_)
        Set t = Eval("new " & aType_)


        Response.Write readDictionary(t.reflect(), true, str, aType_)
    End Function


'***********************************************************************
'*  readDictionary
'***********************************************************************
	Private Function readDictionary(avalue, isInner, str, aType_)
	    cont = 0
	    out = ""
	    If isInner Then out = out & "{"

	    for each c in avalue
		    If isInner Then out = out & ""

		    if isNull(avalue.Item(c)) then
			    out = out & """" & c &""" : null"
		    elseif isArray(avalue.Item(c)) then
                val = avalue.Item(c)
			    out = out & """" & c &""":"& generateArray(val)
		    elseif isObject(avalue.Item(c)) then
		        set aa = avalue.Item(c)

			    if avalue.Item(c) is nothing then
				    out = out & """" & c &""" : null"
			    elseif typename(avalue.Item(c)) = "Recordset" then
			    	out = out &"""" & c &""":"& generateRecordset(avalue.Item(c))
			    elseif typename(avalue.Item(c)) = "Dictionary" then
				    'Nested Array
				    out = out & """" & c &""":[" & readDictionary(aa, false, str, aType_) & "]"
			    else
			        set bb = avalue.Item(c).reflect()
			        if typename(bb) = "Dictionary" then
					    If isInner Then out = out &"""" & c &""":"

					    If isInner Then out = out &"["
 				        out = out &"{"&  readDictionary(bb, false, str, aType_) &"}"
					    If isInner Then out = out &"]"
			        end if
			    end if
		    else
			    'bool
			    dim varTyp
			    varTyp = varType(avalue.Item(c))
			    if varTyp = 11 then
				    if avalue.Item(c) then
				        out = out & """" & c &""":true"
			        else
			            out = out & """" & c &""":false"
			        end if
			    'int, long, byte
			    elseif varTyp = 2 or varTyp = 3 or varTyp = 17 or varTyp = 19 then
				    out = out & """" & c &""":"& cLng(avalue.Item(c))
			    'single, double, currency
			    elseif varTyp = 4 or varTyp = 5 or varTyp = 6 or varTyp = 14 then
				    out = out & """" & c &""":"& replace(cDbl(avalue.Item(c)), ",", ".")
			    else
				    out = out & """" & c &""":""" & escape(avalue.Item(c)) &""""
			    end if
		    end if

		    If isInner Then out = out & ""
		    If cont < avalue.Count - 1 Then out = out & ","

            out = out & ""
		    cont = cont + 1
	    next
	    If isInner Then out = out & "}"
       
        readDictionary = out
    End Function

End Class
%>