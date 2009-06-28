<%

'+-----------------------------------------------------------------------------+
'|This file is part of ASP Xtreme Evolution.                                   |
'|Copyright (C) 2007, 2008 Fabio Zendhi Nagao                                  |
'|                                                                             |
'|ASP Xtreme Evolution is free software: you can redistribute it and/or modify |
'|it under the terms of the GNU Lesser General Public License as published by  |
'|the Free Software Foundation, either version 3 of the License, or            |
'|(at your option) any later version.                                          |
'|                                                                             |
'|ASP Xtreme Evolution is distributed in the hope that it will be useful,      |
'|but WITHOUT ANY WARRANTY; without even the implied warranty of               |
'|MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                |
'|GNU Lesser General Public License for more details.                          |
'|                                                                             |
'|You should have received a copy of the GNU Lesser General Public License     |
'|along with ASP Xtreme Evolution.  If not, see <http://www.gnu.org/licenses/>.|
'+-----------------------------------------------------------------------------+

' Class: Json
' 
' This Class goal is to provide a simple way to parse JSON (JavaScript Object 
' Notation) data directly from vbscript.
' 
' Notes:
' 
'   - JScript Class approach is inspired by CCB.JSONParser.asp <http://blog.crayoncowboy.com/?p=7> Copyright (c) 2007 Cliff Pruitt.
' 
' About:
' 
'   - Written by Fabio Zendhi Nagao <http://zend.lojcomm.com.br/> @ January 2008
' 
class JsonToASP

    private root

    private sub Class_Terminate()
        set root = nothing
    end sub

    ' Subroutine: loadJson
    ' 
    ' Since ASP Classes strangely doesn't accept parameters at it's initializa-
    ' tion. Use this subroutine to load the object.
    ' 
    ' Parameters:
    ' 
    '   (string)sJson - The Json string representation
    ' 
    public sub loadJson(sJson)
        set root = new_JsonEngine(sJson)
    end sub

    ' Function: getElement
    ' 
    ' This function takes a dot separated path and look for the element value in
    ' the JSON.
    ' 
    ' Parameters:
    ' 
    '   (string)sPath - Relative path from root
    ' 
    ' Returns:
    ' 
    '   (string) - The element value
    ' 
    ' Example:
    ' 
    ' (start code)
    ' 
    ' dim sJson, oJson
    ' 
    ' sJson = "" & _
    ' "{" & vbCrLf & _
    ' "    'hello' : 'Hello World !'," & vbCrLf & _
    ' "    'howdy' : 'How do you do ?'," & vbCrLf & _
    ' "    'fields' : {" & vbCrLf & _
    ' "       'one': 1," & vbCrLf & _
    ' "       'two': 2," & vbCrLf & _
    ' "       'three': 3" & vbCrLf & _
    ' "    }" & vbCrLf & _
    ' "};"
    ' 
    ' set oJson = new Json
    ' oJson.loadJson(sJson)
    ' Response.write(oJson.getElement("hello") & "<br />" & vbCrLf)
    ' Response.write(oJson.getElement("howdy") & "<br />" & vbCrLf)
    ' set oJson = nothing
    ' 
    ' (end)
    ' 
    public function getElement(sPath)
        getElement = root.getElement(sPath)
    end function

    ' Function: getChildNodes
    ' 
    ' Look for all element child keys and enumerate them.
    ' 
    ' Parameters:
    ' 
    '   (string)sPath - Path to the parent element relative to root.
    ' 
    ' Returns:
    ' 
    '  (string[]) - With the child keys
    ' 
    ' Example:
    ' 
    ' (start code)
    ' 
    ' dim sJson, oJson, key
    ' 
    ' sJson = "" & _
    ' "{" & vbCrLf & _
    ' "    'hello' : 'Hello World !'," & vbCrLf & _
    ' "    'howdy' : 'How do you do ?'," & vbCrLf & _
    ' "    'fields' : {" & vbCrLf & _
    ' "       'one': 1," & vbCrLf & _
    ' "       'two': 2," & vbCrLf & _
    ' "       'three': 3" & vbCrLf & _
    ' "    }" & vbCrLf & _
    ' "};"
    ' 
    ' set oJson = new Json
    ' oJson.loadJson(sJson)
    ' for each key in oJson.getChildNodes("")
    '     Response.write(key & " : " & oJson.getElement(key) & "<br />" & vbCrLf)
    ' next
    ' set oJson = nothing
    ' 
    ' (end)
    ' 
    public function getChildNodes(sPath)
        getChildNodes = split(root.getChildNodes(sPath), ",")
    end function

end class

%>
<script language="javascript" runat="server">

/* Function: new_JsonEngine
 * 
 * Private function used to create a new instance of the JsonEngine Class.
 * 
 * Parameters:
 * 
 *  (string)sJson - The Json string representation
 * 
 * Returns:
 * 
 *  (object) - The Json root.
 */
function new_JsonEngine(sJson) {
    return new JsonEngine(sJson);
};

/* Class: JsonEngine
 * 
 * Since VBScript doesn't provide a native method to handle JSON, this class ma-
 * kes the magic of wrapping JScript JSON to VBScript. Note that this class me-
 * thods are the same of the Json class above and just make what they was suppo-
 * sed to do.
 */
function JsonEngine(sJson) {
    var me = this;
    this.data = {};

    this.initialize = function(sJson) {
        eval("this.data = " + sJson);
    };

    this.getElement = function(sPath) {
        var node = me.data;
        var aPath = sPath.split('.');
        for(var i = 0, len = aPath.length; i < len; i++) {
            node = node[aPath[i]];
        }
        return (typeof node == "object" && node.length)? "[object Array]" : node;
    };

    this.getChildNodes = function(sPath) {
        var keys = [];
        var parentNode = me.data;
        if( sPath.length > 0 ) {
            var aPath = sPath.split('.');
            for(var i = 0, len = aPath.length; i < len; i++) {
                parentNode = parentNode[aPath[i]];
            }
        }
        for(var key in parentNode) {
            (sPath.length > 0)? keys.push(sPath + "." + key) : keys.push(key);
        }
        return keys;
    };

    this.initialize(sJson);
}

</script>