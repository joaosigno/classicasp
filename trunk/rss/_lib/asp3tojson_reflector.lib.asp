<%
''**************************************************************************************************************
'* RSoft Web Copyright (C) 2009
'* Under GPL License
'**************************************************************************************************************

'**************************************************************************************************************

'' @CLASSTITLE:		JSON
'' @CREATOR:		Paulo Rodrigues
'' @CREATEDON:		2009-04-16
'' @CDESCRIPTION:	JSON Reflector Methods to ASP3
'' @OPTIONEXPLICIT:	yes
'' @VERSION:		0.0.1.1

'Use as include for class files only

'-------JSON Alternative------------------
'Pseudo call for JSON class (avoid bug)
'-----------------------------------------
public function toJSON(val)
    out = "null"

    If isArray(val) then
	    out = generateArray(val)
    ElseIf isObject(val) then
	    If typename(val) = "Recordset" then
	    	out = generateRecordset(val)
	    ElseIf typename(val) = "Dictionary" then
            out = readDictionary(val, true)
	    Else
            out = readDictionary(val.reflect(), true)
	    End If
    End If

    toJSON = out
end function

'******************************************************************************************
'Escape characters
'******************************************************************************************
public function escape(val)
	dim cDoubleQuote, cRevSolidus, cSolidus
	cDoubleQuote = &h22
	cRevSolidus = &h5C
	cSolidus = &h2F
	
	dim i, currentDigit
	for i = 1 to (len(val))
		currentDigit = mid(val, i, 1)
		if asc(currentDigit) > &h00 and asc(currentDigit) < &h1F then
			currentDigit = escapequence(currentDigit)
		elseif asc(currentDigit) >= &hC280 and asc(currentDigit) <= &hC2BF then
			currentDigit = "\u00" + right(padLeft(hex(asc(currentDigit) - &hC200), 2, 0), 2)
		elseif asc(currentDigit) >= &hC380 and asc(currentDigit) <= &hC3BF then
			currentDigit = "\u00" + right(padLeft(hex(asc(currentDigit) - &hC2C0), 2, 0), 2)
		else
			select case asc(currentDigit)
				case cDoubleQuote: currentDigit = escapequence(currentDigit)
				case cRevSolidus: currentDigit = escapequence(currentDigit)
				case cSolidus: currentDigit = escapequence(currentDigit)
			end select
		end if
		escape = escape & currentDigit
	next
end function




'******************************************************************************************************************
'* generateArray 
'******************************************************************************************************************
Private Function generateArray(val)
	dim item, i
	out = out & "["
	i = 0
	'the for each allows us to support also multi dimensional arrays
	for each item in val
		if i > 0 then out = out & ","
		out = out & getValueEmptyNull(item)
		i = i + 1
	next
	out = out & "]"
	generateArray = out
End Function



'******************************************************************************************************************
'* readDictionary
'******************************************************************************************************************
Private Function readDictionary(avalue, isInner)
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
			    out = out & """" & c &""":[" & readDictionary(aa, false) & "]"
		    else
		        set bb = avalue.Item(c).reflect()
		        if typename(bb) = "Dictionary" then
				    If isInner Then out = out &"""" & c &""":"

				    If isInner Then out = out &"["
			        out = out &"{"&  readDictionary(bb, false) &"}"
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




'******************************************************************************************************************
'* generateRecordset 
'******************************************************************************************************************
Private Function generateRecordset(val)
	dim i
	out = ""
	out = out & "["
	while not val.eof
		innerCall = innerCall + 1
		out = out & "{"
		for i = 0 to val.fields.count - 1
			if i > 0 and i < val.fields.count then out = out & ","
			out = out & """"& lCase(val.fields(i).name) &""":"& getValueEmptyNull(val.fields(i).value) &""
		next
		out = out & "}"
		val.movenext()
		if not val.eof then out = out & ","
		innerCall = innerCall - 1
	wend
	out = out & "]"
	generateRecordset = out
end Function



'******************************************************************************************
'* JsonEscapeSquence 
'******************************************************************************************
private function escapequence(digit)
	escapequence = "\u00" + right(padLeft(hex(asc(digit)), 2, 0), 2)
end function


'******************************************************************************************
'* getValueEmptyNull
'******************************************************************************************
Private function getValueEmptyNull(val)
    value = """"""
    If isEmpty(val) or isNull(val) or val = "" Then
        value = "null"
	else
		'bool
		varTyp = varType(val)
		if varTyp = 11 then
			if val then value = "true" else value = "false"
		'int, long, byte
		elseif varTyp = 2 or varTyp = 3 or varTyp = 17 or varTyp = 19 then
			value = cLng(val)
		'single, double, currency
		elseif varTyp = 4 or varTyp = 5 or varTyp = 6 or varTyp = 14 then
			value = replace(cDbl(val), ",", ".")
		else
			value = """" & escape(val) & """"
		end if
	end if

	getValueEmptyNull = value
end function



'******************************************************************************************
'* padLeft 
'******************************************************************************************
Private function padLeft(value, totalLength, paddingChar)
	padLeft = right(clone(paddingChar, totalLength) & value, totalLength)
end function



'******************************************************************************************
'* clone 
'******************************************************************************************
private function clone(byVal str, n)
	dim i
	for i = 1 to n : clone = clone & str : next
end function
'-------JSON Alternative------------------
'Pseudo call for JSON class (avoid bug)
'-------End             ------------------



'******************************************************************************************
'* Prevent SQL Inject Attack
'******************************************************************************************
Public Function scanSQL(str)
    lixo = Array("select " ,"drop " ,";" ,"–","--" ,"insert " ,"delete " ,"xp_", "'")
    for i = lBound(lixo) to uBound(lixo)
       str = replace(str, lixo(i), "")
    next
    scanSQL = str
end function
'******************************************************************************************



'******************************************************************************************
'* Write the Methods ASP to JavaScript
'******************************************************************************************
Public Function writeMethodsToJsonA(aType, path)
    tmpType = aType
    Set obj = eval("(new "& aType &")")
    Set r = obj.reflectMethod()
    tmpMethod = ""
    tmpMethod = tmpMethod & chr(13) &("<script>")

    a = 0

    tmpMethod = tmpMethod & chr(13) & "var _" & tmpType & " = {" & chr(13)
    for each c in r
        arrParams = Split(r(c),",")
        arrMethod = Split(c," ")
        withReturn = false
        aMethod = ""

        If(Ubound(arrMethod) > 0) Then
            tmpMethod = tmpMethod & ""& arrMethod(1) & " : function"
            aMethod = arrMethod(1)
            If(lcase(arrMethod(0)) = "function") Then
                withReturn = true
            End If
        ElseIf(Ubound(arrMethod) = 0) Then
            tmpMethod = tmpMethod & ""& arrMethod(0) & " : function"
            aMethod = arrMethod(0)
        End If

        tmpMethod = tmpMethod & "("
        
        tmpParam = ""
        If(Ubound(arrParams) > -1) Then
            tmpMethod = tmpMethod & "method,"
            for n = 0 to Ubound(arrParams)
                tmpMethod = tmpMethod & arrParams(n)
                tmpParam = tmpParam & "_param= ""' + "& arrParams(n) &" + '"" "
                If(n < Ubound(arrParams)) Then
                    tmpMethod = tmpMethod & ","
                    tmpParam = tmpParam & "&"
                End If
            next
        ElseIf(Ubound(arrParams) = -1) Then
            tmpMethod = tmpMethod & "method"
        End If

        tmpMethod = tmpMethod & "){" & chr(13)
        tmpMethod = tmpMethod & "       var ___ajaxurl = '"& path &"?m="& aMethod  &"&o="& aType  &"';" & chr(13)
        tmpMethod = tmpMethod & "       a = new objectAjax.Ajax(___ajaxurl,{update:"""", onComplete:" & chr(13)
        tmpMethod = tmpMethod & "       function(_text,_xml)" & chr(13)
        tmpMethod = tmpMethod & "       {" & chr(13)
        If withReturn = true Then
            tmpMethod = tmpMethod & "          method(_text);"& chr(13)
        Else
            tmpMethod = tmpMethod & "          method();" & chr(13)
        End If
        tmpMethod = tmpMethod & "       }" & chr(13)
        tmpMethod = tmpMethod & "       });" & chr(13)

        If tmpParam <> "" Then
           tmpParam = "'"& tmpParam &"'"
        End If

        tmpMethod = tmpMethod & "       a.post("& tmpParam &");" & chr(13)
        tmpMethod = tmpMethod & "}"

        If a < r.count - 1 Then 
            tmpMethod = tmpMethod & "," & chr(13)
        Else
            tmpMethod = tmpMethod & "" & chr(13)
        End If

        a = a + 1
    next
    tmpMethod = tmpMethod & "};" & chr(13)

    tmpMethod = tmpMethod & ""
    tmpMethod = tmpMethod &("</script>" & chr(13))
    
    writeMethodsToJsonA = tmpMethod
End Function



'Execute
If request.querystring("m") <> "" Then
    atmp = ""

    aType_ = request.querystring("o")
    functionName = request.querystring("m")
    params_ = scanSQL(request.form("_param"))
    
    Public Function writeMethodsToJsonB(aType,params)
        if isEmpty(params) then
            atmp = eval("(new "& aType &")."& functionName & "()")
        else
            atmp = eval("(new "& aType &")."& functionName & "(" & params & ")")
        end if

        response.write atmp
    End Function
    
    writeMethodsToJsonB aType_,params_

'Write
ElseIf request.querystring("m") = "" Then
    Public Function writeMethodsToJson(aType, path)
        response.write writeMethodsToJsonA(aType, path)
    End Function
End If
%>