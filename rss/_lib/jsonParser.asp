<%

'=================================================================================================================
'	JsonParser version 0.1 & JsonParser 0.1
'	Copyright © 2007 Cliff Pruitt
'
'	Created  by cpruitt on Thu 06/07/2007 at 16:56:41 EDT
'	http://www.crayoncowboy.com/software
'=================================================================================================================

' 	JsonParser (including the JSONTranslator JScript object) is a simple JSON parser for ASP scripts
' 	The current development version includes only basic functionality and very little error handling
' 	
' 	* CONTENTS *
' 	+	JsonParser						- Parses a JSON formatted Object Representation
' 	+	JSONTranslator (JScript object)	- Helper Object used to manuiplate load JSON representation.
' 											  This object will probably never be used directly & is not documented.
' 	+	newJSONTranslator(<JSON string>)	- Utility function to create a new instance of JSONTranslator in VBScript
' 	+	JsonParser_undefined (constant) 			- A unique constant value used to represent a
' 											  JScript JsonParser_undefined value (used for comparisons & "if" statements)
' 	
' 	* PURPOSE *
' 	JsonParser is intended only to translate a JSON formatted data representation into something usable in
' 	an ASP script.  Currently the entire representation is returned as one or more VBScript Doctionary objects.
' 	This means that, although JSON representations of arrays are accurately parsed into memory, they are returned
' 	as VBScript Safe Arrays.  Instead they are returned as dictionaries with keys 0 - (array.length). This will
' 	probablybe fixed in the future.
' 	
' 	
' 	Using the following few properties and methods you should be able to access any data indicated by a JSON representation.
' 	
' 	
' 	* USAGE *
' 	+ 	After creating an instance of the Object, the JSON representation (string) is assigned to the objects .JSON property.
' 		(This populates the contents of the JSONTranslator object but does not actually create any VBScript objects)
' 		
' 	+	After the JSON property is populated, VBScript can access the data in one of two ways.
' 		1.	Call the .parse method on the object.  This will load the complete contents of the JSON
' 			representation into memory and assign it to the objects .dictionary property.
' 		2.	Use the .valueFor() method to fetch a sub-section of the JSON representation.
' 		
' 	* OBJECT PROPERTIES & METHODS *
' 	
' 	-- PROPERTIES --
' 
' 	+	version		: (string) (r/o) returns the version of the class
' 	+	className	: (string) (r/o) returns the name of the class (JsonParser)
' 	+	JSON		: (string) sets / returns the JSON representation of the data
' 	+	dictionary	: (dictionary) (r/o) returns a doctionary representation of the entire JSON data structure
' 	+	description	: (string) (r/o) returns an HTML description of the object instace comparing the JSON string to the obj.dictionary value.
' 	
' 	-- METHODS --
' 	+	parse					: parses the JSON representation of the data, builds a collection of nested dictionaries
' 					  			  and sets the value of the .dictionary property
' 	+	valueFor(<scopeString>)	: returns a the value of the object indicated by the "scopeString".  If the object is a
' 								  collection, a doctionary is returned, otherwise a primitive (string, integer, boolean, etc...)
' 		- scopeString	: The scopeString argument should be a "path" to the data sub-item in JavaScript dot/array notation format.
' 						  For example, consider the following statement:
' 						
' 							set fName = Obj.valueFor("Sports.Soccer.Grade10.Games[4].Score.Winner")
' 						
' 						  This would Look into the Sports > Soccer > Grade10 > Games array
' 						  From there it would examine the 4th element and get the element's Score object.
' 						  It would then get the "Winner" proerty of the Score object which is what would
' 						  be returned by Obj.valueFor.
' 						
' 	
' 	==== SEE THE EXAMPLE FILE FOR MORE USAGE EXAMPLES ====
' 

'=================================================================================================================



const JsonParser_undefined = "{7LV65C98O-UOB5-0SDF-MGDN-INLLDDJQ94CD}"
class JsonParser
	
	
	
	'/-----------------------------  DECLARE VARIABLES  ----------------------------/
	
	private p_lastError, P_Data, p_json, P_JST
	private p_className, p_version

	'/-------------------------  INITIALIZE AND TERMINATE  -------------------------/
	
	private sub Class_Initialize()
		p_className	= "JsonParser"
		p_version	= "0.1"
		call init()
	end sub
	
	private sub Class_Terminate()
		set P_Data = nothing
	end sub
	
	'	/***  Designated Initializer  ***/
	private function init()
		dim v_out : v_out = true
		p_json = "{}"
		
		if isObject(P_Data) then set P_Data = nothing
		set P_Data = Server.CreateObject("Scripting.Dictionary")
		P_Data.CompareMode = VBTextCompare '// or = 1
		
		if isObject(P_JST) then set P_JST = nothing
		set P_JST = newJSONTranslator(p_json)
		
		init = v_out
	end function
	
	'/----------------------------- PROPERTY ACCESSORS  ----------------------------/
	
	'--	GET version from p_version
	public property Get version()
		version = p_version
	end Property
	
	'--	GET JSON from p_JSON
	public property get JSON()
		JSON = p_JSON
	end property

	'--	LET p_JSON = JSON
	public property let JSON(newValue)
		if trim(newValue) & "" = "" then newValue = "{}"
		P_JST.setData(newValue)
		p_JSON = newValue
	end property
	
	'--	GET dictionary from p_dictionary
	public property get dictionary()
		set dictionary = P_Data
	end property
	
	'/------------------------------  OBJECT METHODS  ------------------------------/
	
	public function parse()
		dim v_out : v_out = true
		if isObject(P_Data) then set P_Data = nothing
		set P_Data = JSObjectToVBDictionary(P_JST)
		parse = v_out
	end function
	
	public function description()
		dim v_out : v_out = null
		v_out = v_out & "<h1>" & p_className & " object: Version " & p_version & "</h1>"
		
		v_out = v_out & li("JSON: " & code(Me.JSON))
		v_out = v_out & li("DICTIONARY REPRESENTATION:" & describeDict(P_Data))
		
		v_out = ul(v_out)
		
		description = v_out
	end function
	
	public function valueFor(scopeString)
		dim v_out
		
		scopeString = scopeString & ""
		if inStr(scopeString, ".") > 0 then
			scopeString = replace(scopeString, ".", "['", 1,1)
			scopeString = replace(scopeString, ".", "']['")
			scopeString = scopeString & "']"
		end if
		
		typ = P_JST.typeForKey(scopeString)
		if typ = "object" then
			set	valueFor = JSObjecttoVBDictionaryByScope(P_JST,scopeString)
		else
			v_out = P_JST.valForKey(scopeString)
			valueFor = v_out
		end if
	end function
	
	'/-----------------------------  PRIVATE FUNCTIONS  ----------------------------/
	private function JSObjectToVBDictionary(JSTranslationObject)
		set JSObjectToVBDictionary = JSObjecttoVBDictionaryByScope(JSTranslationObject,null)
	end function
	
	private function JSObjecttoVBDictionaryByScope(JT,path)
		dim v_out, jkeys
		dim a()
		set v_out = Server.CreateObject("Scripting.Dictionary")
		v_out.CompareMode = VBTextCompare '// or = 1

		jkeys = split(JT.keysFor(path), ",")
		dim k, jkey, typ, O
		for each k in jkeys
			if trim(k) <> "" then
				if trim(path & "") <> "" then
					jkey = path & "['" & k & "']"
				else
					jkey = k
				end if
				
				typ = JT.typeForKey(jkey)
		
				select case typ
					case "object", "array"
						set O = JSObjecttoVBDictionaryByScope(JT,jkey)
						v_out.add k, O
						set O = nothing
					case "arrayx"
						length = JT.lengthForKey(jkey)
						reDim a(length)
						for i = 0 to length - 1
							subKey = jkey & "['" & i & "']"
							innerType = JT.typeForKey(subKey)
							
							select case innerType & ""
								case "object"
									set a(i) = JSObjecttoVBDictionaryByScope(JT,subKey)
								case "array"
									set a(i) = JSObjecttoVBDictionaryByScope(JT,subKey)
								case else
									a(i) = typeName(JT.valForKey(subKey))
							end select
							
							 'typeName(JSObjecttoVBDictionaryByScope(JT,subKey))
						neXt
						v_out.add k, a
					case else
						v_out.add k, JT.valForKey(jkey)
				end select
			end if
		neXt

		set JSObjecttoVBDictionaryByScope = v_out
		set v_out = nothing
	end function
	
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
	
	private function describeDict(dictObj)
		dim v_out : v_out = null
		dim val   : val = ""
		dim k
		
		
		if dictObj.count > 0 then
			for each k in dictObj.keys
				val = ""
				if isObject(dictObj(k)) then
					if lCase(typeName(dictObj(k))) = "dictionary" then
						val = DescribeDict(dictObj(k))
					else
						val = "[OBJECT]"
					end if
				elseIf isArray(dictObj(k)) then
					val = "Array:"
					for i = 0 to uBound(dictObj(k))
						if isObject(dictObj(k)(i)) or isArray(dictObj(k)(i)) then
							val = DescribeDict(dictObj(k)(i))
						else
							val = val & li(dictObj(k)(i))
						end if
						val = ul(val)
					neXt
					
				else
					val = dictObj(k)
				end if
				v_out = v_out & li(k & ": " & val)
			next
		else
			v_out = v_out & li("This JSON representation has no properties. JSON = {}")
		end if

		DescribeDict = ul(v_out)
	end function
	
	'	/***  UNUSED FOR NOW  ***/
	'	//	Get last object Error
	public function lastError()
		dim v_out : v_out = null		
		v_out = p_lastError
		lastError = v_out
	end function
	
	'	//	Clear Last Error
	public function clearError()
		p_lastError = null
	end function
	
end class

%>
<script language="jscript" runat="server">
	function JSONTranslator(inputData){
		var JsonParser_undefined = "{7LV65C98O-UOB5-0SDF-MGDN-INLLDDJQ94CD}"
		var _this = this;
		
		this.init = function(inputData){
			this.setData(inputData);
		}
		
		this.setData = function(strJSON){
			eval('this.data =' + strJSON);
		}
		
		this.data = {}
		
		this.valForKey = function(keyString){
			var v_out;
			if(!keyString){
				val = this.data
			} else {
				try{
					val = eval("this.data." + keyString);
				} catch(e) {
					val = JsonParser_undefined;
				}
			}

			if(_this.isArray(val) && false){
				val = eval("this.data." + keyString)
				var O = {}
				for(i=0; i<val.length; i++){
					O['' + i + ''] = val[i];
				}
				return O;
			} else {
				return val;
			}
		}
		
		this.typeForKey = function(keyString){
			if(_this.valForKey(keyString) == JsonParser_undefined){
				return typeof(JsonParser_undefined);
			} else if(_this.isArray(_this.valForKey(keyString))){
				return 'array'
			} else {
				return typeof(_this.valForKey(keyString));
			}
			
			
		}
		
		this.lengthForKey = function(keyString){
			var val = _this.valForKey(keyString);
			if(_this.isArray(val)){
				return val.length;
			} else {
				val = eval("this.data." + keyString);
				return 0;
			}
			
		}

		this.keysFor = function(dataTarget){
			if(!dataTarget) {
				dataTarget = this.data;
			} else {
				dataTarget = eval("this.data." + dataTarget);
			}
			
			var v_out = '';
			for(itm in dataTarget){
				v_out += itm + ',';
			}
			return v_out;
		}
		
		this.isArray = function(obj){
			if (obj && obj.constructor && obj.constructor.toString().indexOf("Array") == -1)
			      return false;
			   else
			      return true;
		}
		
		this.init(inputData);
	}

	function newJSONTranslator(data){
		return new JSONTranslator(data);
	}
	
	function URLDecode(psEncodeString){
	  return unescape(psEncodeString);
	}
</script>