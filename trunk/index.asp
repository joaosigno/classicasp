<!-- #include file="./_lib/asp3tojson.lib.asp" -->
<!-- #include file="./_lib/jsontoasp3.lib.asp" -->
<!-- #include file="./_view/index.view.asp" -->
<html>

<head>



<script src="_client/mjt.js"></script>
<script src="_client/exibe_flash.js"></script>

<script language="javascript" type="text/javascript">
    objNoticias = { "noticias": [], "pages": 0, "actualPage": 0 };
    function getNoticias(callback) {
        objNoticias = JSON.parse(callback);
        $_('theGrid').innerHTML = $_('theGridraw').innerHTML;
        $_('pages').innerHTML = $_('pagesraw').innerHTML;
        mjt.run('theGrid');
        mjt.run('pages');
    }


</script>

<style>
#theGrid{
    height:200px;
    width:250px;
    overflow:auto;
    font:normal 8pt 'tahoma';
}
</style>

</head>


<body>



<div id="pages"></div>
<div id="theGrid"></div>


<div id="pagesraw" style="display:none;">
	<span mjt.def="mklink(n)"><a href="javascript: _Index.listaNoticias(getNoticias,$n);">$n</a></span>
	<span  mjt.for="(x = 0; x < objNoticias.pages; x++)">${objNoticias.pages== 1?'':mklink(x)} </span>
</div>

<div id="theGridraw" style="display:none;">
	<span mjt.for="n in objNoticias.noticias">
		${n.textocurto==null?'-':n.textocurto}
		<hr />
	</span>
</div>


<input type="button" onclick="new _Index.listaNoticias(getNoticias, 0);" value="rss Flickr" />



<br />
<br />
<br />


<%
Dim aStr
aStr = "{""noticias"":[{""idnoticia"":1,""titulo"":""noticia 1"",""textocurto"":""noticia 1"",""texto"":""noticia 1"",""principal"":""0""},{""idnoticia"":2,""titulo"":""noticia"",""textocurto"":""noticia"",""texto"":""noticia"",""principal"":""0""}],""pages"":4,""actualPage"":0}"


Set j = new JsonToASP
j.loadJson(aStr)

'Response.Write j.getElement("pages")

for each key in j.getChildNodes("noticias")
	Response.write(key & " : " & j.getElement(key) & "<br />" & vbCrLf)
next

%>


</body>


</html>
