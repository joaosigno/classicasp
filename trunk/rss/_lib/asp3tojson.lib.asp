<%
'**************************************************************************************************************
'* RSoft Web Copyright (C) 2009
'* Under GPL License
'**************************************************************************************************************

'**************************************************************************************************************

'' @CLASSTITLE:		JSON
'' @CREATOR:		Paulo Rodrigues
'' @CREATEDON:		2009-04-16
'' @CDESCRIPTION:	Full Pack JSON RPC ASP3
'' @OPTIONEXPLICIT:	yes
'' @VERSION:		0.0.2.2

'**************************************************************************************************************

class JSON
	'******************************************************************************************
	'Parses ASP3 Objects to JSON Format
	'******************************************************************************************
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
end class
%>
<script type="text/javascript" language="javascript">
//Json (server and client) And Ajax Pack
function $_(obj) {
    return document.getElementById(obj);
}

var is={ie:navigator.appName=='Microsoft Internet Explorer',java:navigator.javaEnabled(),ns:navigator.appName=='Netscape',ua:navigator.userAgent.toLowerCase(),version:parseFloat(navigator.appVersion.substr(21))||parseFloat(navigator.appVersion),win:navigator.platform=='Win32'}
is.mac=is.ua.indexOf('mac')>=0;if(is.ua.indexOf('opera')>=0){is.ie=is.ns=false;is.opera=true;}
if(is.ua.indexOf('gecko')>=0){is.ie=is.ns=false;is.gecko=true;}

if (!this.JSON) {
    JSON = {};
}
(function () {

    function f(n) {
        // Format integers to have at least two digits.
        return n < 10 ? '0' + n : n;
    }

    if (typeof Date.prototype.toJSON !== 'function') {

        Date.prototype.toJSON = function (key) {

            return this.getUTCFullYear()   + '-' +
                 f(this.getUTCMonth() + 1) + '-' +
                 f(this.getUTCDate())      + 'T' +
                 f(this.getUTCHours())     + ':' +
                 f(this.getUTCMinutes())   + ':' +
                 f(this.getUTCSeconds())   + 'Z';
        };

        String.prototype.toJSON =
        Number.prototype.toJSON =
        Boolean.prototype.toJSON = function (key) {
            return this.valueOf();
        };
    }

    var cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        gap,
        indent,
        meta = {    // table of character substitutions
            '\b': '\\b',
            '\t': '\\t',
            '\n': '\\n',
            '\f': '\\f',
            '\r': '\\r',
            '"' : '\\"',
            '\\': '\\\\'
        },
        rep;


    function quote(string) {
        escapable.lastIndex = 0;
        return escapable.test(string) ?
            '"' + string.replace(escapable, function (a) {
                var c = meta[a];
                return typeof c === 'string' ? c :
                    '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
            }) + '"' :
            '"' + string + '"';
    }


    function str(key, holder) {
        var i,          // The loop counter.
            k,          // The member key.
            v,          // The member value.
            length,
            mind = gap,
            partial,
            value = holder[key];
        if (value && typeof value === 'object' &&
                typeof value.toJSON === 'function') {
            value = value.toJSON(key);
        }

        if (typeof rep === 'function') {
            value = rep.call(holder, key, value);
        }

        switch (typeof value) {
        case 'string':
            return quote(value);
        case 'number':
            return isFinite(value) ? String(value) : 'null';
        case 'boolean':
        case 'null':
            return String(value);
        case 'object':
            if (!value) {
                return 'null';
            }
            gap += indent;
            partial = [];
            if (Object.prototype.toString.apply(value) === '[object Array]') {
                length = value.length;
                for (i = 0; i < length; i += 1) {
                    partial[i] = str(i, value) || 'null';
                }
                v = partial.length === 0 ? '[]' :
                    gap ? '[\n' + gap +
                            partial.join(',\n' + gap) + '\n' +
                                mind + ']' :
                          '[' + partial.join(',') + ']';
                gap = mind;
                return v;
            }
            if (rep && typeof rep === 'object') {
                length = rep.length;
                for (i = 0; i < length; i += 1) {
                    k = rep[i];
                    if (typeof k === 'string') {
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            } else {
                for (k in value) {
                    if (Object.hasOwnProperty.call(value, k)) {
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            }
            v = partial.length === 0 ? '{}' :
                gap ? '{\n' + gap + partial.join(',\n' + gap) + '\n' +
                        mind + '}' : '{' + partial.join(',') + '}';
            gap = mind;
            return v;
        }
    }
    if (typeof JSON.stringify !== 'function') {
        JSON.stringify = function (value, replacer, space) {
            var i;
            gap = '';
            indent = '';

            if (typeof space === 'number') {
                for (i = 0; i < space; i += 1) {
                    indent += ' ';
                }
            } else if (typeof space === 'string') {
                indent = space;
            }

            rep = replacer;
            if (replacer && typeof replacer !== 'function' &&
                    (typeof replacer !== 'object' ||
                     typeof replacer.length !== 'number')) {
                throw new Error('JSON.stringify');
            }

            return str('', {'': value});
        };
    }

    if (typeof JSON.parse !== 'function') {
        JSON.parse = function (text, reviver) {
            var j;
            function walk(holder, key) {
                var k, v, value = holder[key];
                if (value && typeof value === 'object') {
                    for (k in value) {
                        if (Object.hasOwnProperty.call(value, k)) {
                            v = walk(value, k);
                            if (v !== undefined) {
                                value[k] = v;
                            } else {
                                delete value[k];
                            }
                        }
                    }
                }
                return reviver.call(holder, key, value);
            }
            cx.lastIndex = 0;
            if (cx.test(text)) {
                text = text.replace(cx, function (a) {
                    return '\\u' +
                        ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
                });
            }

            if (/^[\],:{}\s]*$/.
test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, '@').
replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, ']').
replace(/(?:^|:|,)(?:\s*\[)+/g, ''))) {
                j = eval('(' + text + ')');
                return typeof reviver === 'function' ?
                    walk({'': j}, '') : j;
            }
            throw new SyntaxError('JSON.parse');
        };
    }
})();

function asp3wrap(str)
{
    return str.replace(/"/g,'""');
}
//------------------------------------------------------------------------
//Ajax Module
//------------------------------------------------------------------------
if(typeof window.objectAjax === "undefined") var objectAjax = new Object();

objectAjax.Ajax = function(url,options){
   this.xmlHttp = this.createXMLHttp();
   this.url = url;
   this.update = options.update || null;
   this.onComplete = options.onComplete || function(){};
};

objectAjax.Ajax.prototype = Object({
   get:
      function(){
         var thisObj = this;
         this.xmlHttp.onreadystatechange = function(){thisObj.updateFunc();};
         this.url += (this.url.indexOf("?") === -1)?"?":"&";
         this.url += "mathrandomvar="+Math.random();
         this.xmlHttp.open("get",this.url,true);
         this.xmlHttp.send();
      },
   post:
      function(params){
         params = params == undefined ? '': params;
         var thisObj = this;
         this.xmlHttp.onreadystatechange = function(){thisObj.updateFunc();};
         this.url += (this.url.indexOf("?") === -1)?"?":"&";
         this.url += "mathrandomvar="+Math.random();
         this.xmlHttp.open("post",this.url,true);
         this.xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
         this.xmlHttp.setRequestHeader("Content-length", params.length);
         this.xmlHttp.setRequestHeader("Connection", "close");
         this.xmlHttp.send(params.replace(/ /g,'%20'));
      },
   updateFunc:
      function(){
         if (this.xmlHttp.readyState==4 || this.xmlHttp.readyState=="complete"){
            if (this.xmlHttp.status == 200){
               if (this.update != ""){
                   //this.update(this.xmlHttp.responseText);
               }
               this.onComplete(this.xmlHttp.responseText, this.xmlHttp.responseXML);
            }
         }
      },
   createXMLHttp:
      function(){
         if(typeof XMLHttpRequest != "undefined")
              return new XMLHttpRequest();
         else if (window.ActiveXObject) {
            var aVersions = [ "MSXML2.XMLHttp.5.0","MSXML2.XMLHttp.4.0","MSXML2.XMLHttp.3.0","MSXML2.XMLHttp","Microsoft.XMLHttp"];

           for (var i = 0; i < aVersions.length; i++) {
              try{
                  var oXmlHttp = new ActiveXObject(aVersions[i]);
                  return oXmlHttp;
              }catch (oError){}
            }
          }
         alert("Objeto XMLHttp no pode ser criado.");
      }
});


/*
xml2json v 1.1
copyright 2005-2007 Thomas Frank

This program is free software under the terms of the 
GNU General Public License version 2 as published by the Free 
Software Foundation. It is distributed without any warranty.
*/

xml2json={
	parser:function(xmlcode,ignoretags,debug){
		if(!ignoretags){ignoretags=""};
		xmlcode=xmlcode.replace(/\s*\/>/g,'/>');
		xmlcode=xmlcode.replace(/<\?[^>]*>/g,"").replace(/<\![^>]*>/g,"");
		if (!ignoretags.sort){ignoretags=ignoretags.split(",")};
		var x=this.no_fast_endings(xmlcode);
		x=this.attris_to_tags(x);
		x=escape(x);
		x=x.split("%3C").join("<").split("%3E").join(">").split("%3D").join("=").split("%22").join("\"");
		for (var i=0;i<ignoretags.length;i++){
			x=x.replace(new RegExp("<"+ignoretags[i]+">","g"),"*$**"+ignoretags[i]+"**$*");
			x=x.replace(new RegExp("</"+ignoretags[i]+">","g"),"*$***"+ignoretags[i]+"**$*")
		};
		x='<JSONTAGWRAPPER>'+x+'</JSONTAGWRAPPER>';
		this.xmlobject={};
		var y=this.xml_to_object(x).jsontagwrapper;
		if(debug){y=this.show_json_structure(y,debug)};
		return y
	},
	xml_to_object:function(xmlcode){
		var x=xmlcode.replace(/<\//g,"");
		x=x.split("<");
		var y=[];
		var level=0;
		var opentags=[];
		for (var i=1;i<x.length;i++){
			var tagname=x[i].split(">")[0];
			opentags.push(tagname);
			level++
			y.push(level+"<"+x[i].split("㧧")[0]);
			while(x[i].indexOf("�"+opentags[opentags.length-1]+">")>=0){level--;opentags.pop()}
		};
		var oldniva=-1;
		var objname="this.xmlobject";
		for (var i=0;i<y.length;i++){
			var preeval="";
			var niva=y[i].split("<")[0];
			var tagnamn=y[i].split("<")[1].split(">")[0];
			tagnamn=tagnamn.toLowerCase();
			var rest=y[i].split(">")[1];
			if(niva<=oldniva){
				var tabort=oldniva-niva+1;
				for (var j=0;j<tabort;j++){objname=objname.substring(0,objname.lastIndexOf("."))}
			};
			objname+="."+tagnamn;
			var pobject=objname.substring(0,objname.lastIndexOf("."));
			if (eval("typeof "+pobject) != "object"){preeval+=pobject+"={value:"+pobject+"};\n"};
			var objlast=objname.substring(objname.lastIndexOf(".")+1);
			var already=false;
			for (k in eval(pobject)){if(k==objlast){already=true}};
			var onlywhites=true;
			for(var s=0;s<rest.length;s+=3){
				if(rest.charAt(s)!="%"){onlywhites=false}
			};
			if (rest!="" && !onlywhites){
				if(rest/1!=rest){
					rest="'"+rest.replace(/\'/g,"\\'")+"'";
					rest=rest.replace(/\*\$\*\*\*/g,"</");
					rest=rest.replace(/\*\$\*\*/g,"<");
					rest=rest.replace(/\*\*\$\*/g,">")
				}
			} 
			else {rest="{}"};
			if(rest.charAt(0)=="'"){rest='unescape('+rest+')'};
			if (already && !eval(objname+".sort")){preeval+=objname+"=["+objname+"];\n"};
			var before="=";after="";
			if (already){before=".push(";after=")"};
			var toeval=preeval+objname+before+rest+after;
			eval(toeval);
			if(eval(objname+".sort")){objname+="["+eval(objname+".length-1")+"]"};
			oldniva=niva
		};
		return this.xmlobject
	},
	show_json_structure:function(obj,debug,l){
		var x='';
		if (obj.sort){x+="[\n"} else {x+="{\n"};
		for (var i in obj){
			if (!obj.sort){x+=i+":"};
			if (typeof obj[i] == "object"){
				x+=this.show_json_structure(obj[i],false,1)
			}
			else {
				if(typeof obj[i]=="function"){
					var v=obj[i]+"";
					//v=v.replace(/\t/g,"");
					x+=v
				}
				else if(typeof obj[i]!="string"){x+=obj[i]+",\n"}
				else {x+="'"+obj[i].replace(/\'/g,"\\'").replace(/\n/g,"\\n").replace(/\t/g,"\\t").replace(/\r/g,"\\r")+"',\n"}
			}
		};
		if (obj.sort){x+="],\n"} else {x+="},\n"};
		if (!l){
			x=x.substring(0,x.lastIndexOf(","));
			x=x.replace(new RegExp(",\n}","g"),"\n}");
			x=x.replace(new RegExp(",\n]","g"),"\n]");
			var y=x.split("\n");x="";
			var lvl=0;
			for (var i=0;i<y.length;i++){
				if(y[i].indexOf("}")>=0 || y[i].indexOf("]")>=0){lvl--};
				tabs="";for(var j=0;j<lvl;j++){tabs+="\t"};
				x+=tabs+y[i]+"\n";
				if(y[i].indexOf("{")>=0 || y[i].indexOf("[")>=0){lvl++}
			};
			if(debug=="html"){
				x=x.replace(/</g,"&lt;").replace(/>/g,"&gt;");
				x=x.replace(/\n/g,"<BR>").replace(/\t/g,"&nbsp;&nbsp;&nbsp;&nbsp;")
			};
			if (debug=="compact"){x=x.replace(/\n/g,"").replace(/\t/g,"")}
		};
		return x
	},
	no_fast_endings:function(x){
		x=x.split("/>");
		for (var i=1;i<x.length;i++){
			var t=x[i-1].substring(x[i-1].lastIndexOf("<")+1).split(" ")[0];
			x[i]="></"+t+">"+x[i]
		}	;
		x=x.join("");
		return x
	},
	attris_to_tags: function(x){
		var d=' ="\''.split("");
		x=x.split(">");
		for (var i=0;i<x.length;i++){
			var temp=x[i].split("<");
			for (var r=0;r<4;r++){temp[0]=temp[0].replace(new RegExp(d[r],"g"),"_jsonconvtemp"+r+"_")};
			if(temp[1]){
				temp[1]=temp[1].replace(/'/g,'"');
				temp[1]=temp[1].split('"');
				for (var j=1;j<temp[1].length;j+=2){
					for (var r=0;r<4;r++){temp[1][j]=temp[1][j].replace(new RegExp(d[r],"g"),"_jsonconvtemp"+r+"_")}
				};
				temp[1]=temp[1].join('"')
			};
			x[i]=temp.join("<")
		};
		x=x.join(">");
		x=x.replace(/ ([^=]*)=([^ |>]*)/g,"><$1>$2</$1");
		x=x.replace(/>"/g,">").replace(/"</g,"<");
		for (var r=0;r<4;r++){x=x.replace(new RegExp("_jsonconvtemp"+r+"_","g"),d[r])}	;
		return x
	}
};


if(!Array.prototype.push){
	Array.prototype.push=function(x){
		this[this.length]=x;
		return true
	}
};

if (!Array.prototype.pop){
	Array.prototype.pop=function(){
  		var response = this[this.length-1];
  		this.length--;
  		return response
	}
};
</script>