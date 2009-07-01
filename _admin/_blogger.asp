<!-- #include file="./../_security/auth.security.asp" -->
<html>
<head>
	<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf-8">
    <title>RSS Blogger</title>

<!-- #include file="./../_lib/asp3tojson.lib.asp" -->
<!-- #include file="./../_view/_admin/_blogger.view.asp" -->

<script src="../_client/mjt.js"></script>

<script language="javascript" type="text/javascript">
	var objRss = { "rss": [], "pages": 0, "actualPage": 0 };
	var x1 = 1;

	function getRss(callback) {
		x1 = 1;

		objRss = JSON.parse(callback);
		$_('theGrid').style.visibility = 'hidden';
		$_('pages').style.visibility = 'hidden';
		$_('theGrid').innerHTML = $_('theGridraw').innerHTML;
		$_('pages').innerHTML = $_('pagesraw').innerHTML;
		mjt.run('theGrid');
		mjt.run('pages');
		$_('theGrid').style.visibility = 'visible';
		$_('pages').style.visibility = 'visible';
	}
	new _start.readRSS(getRss, "0", "0");


	function startEditRss(callback) {
		var objRssTmp = JSON.parse(callback);
		$_('idRss').value = objRssTmp.rss[0].idrss;
		$_('aRssTitle_').value = objRssTmp.rss[0].titulo;
		$_('aRssShortText_').value = objRssTmp.rss[0].textocurto;
		$_('aRssTipoMidia_').value = objRssTmp.rss[0].mediatipo;
		$_('aRssUrl_').value = objRssTmp.rss[0].url;
	}

	function startNewRss() {
		$_('idRss').value = 0;
		$_('aRssTitle_').value = '';
		$_('aRssShortText_').value = '';
		$_('aRssTipoMidia_').value = 'blogger';
		$_('aRssUrl_').value = '';
	}

	window.onload = function() { startNewRss(); }


	function saveRss() {
		var strError = '';
		if ($_('idRss').value == '') { }
		else if ($_('aRssTitle_').value == '') { strError = 'Preencha o titulo'; }
		else if ($_('aRssShortText_').value == '') { strError = 'Preencha  a descrição'; }
		else if (escape($_('aRssTipoMidia_').value) == '') { strError = 'Defina o tipo de midia'; }
		else if ($_('aRssUrl_').value == '') { strError = 'Preencha a URL do RSS Feed'; }

		if (strError == '') {
			$_('saveBox').style.visibility = 'visible';
			new _start.createRSS(callbackSaveRss, $_('idRss').value, $_('aRssTitle_').value, $_('aRssShortText_').value, $_('aRssTipoMidia_').value, escape($_('aRssUrl_').value));
		}
		else { alert(strError); }
	}

	function callbackSaveRss(strError) {
		var err = JSON.parse(strError);
		if (err.error == '') { startNewRss(); }
		else { alert(err.error); }
		new _start.readRSS(getRss, "0", "0");
		$_('saveBox').style.visibility = 'hidden';
	}
</script>

<style>
body{
	clear:both;
    font:normal 8pt 'tahoma';
}
#theGrid{
    height:200px;
    width:350px;
    overflow:auto;
}
#containerRSS
{
	float:right;
	margin-right:50px;
}
#formRSS .txtForm
{
	width:250px;
    font:normal 8pt 'tahoma';
}
#saveBox
{
	background:#FF0;
	width:350px;
	height:100px;
	text-align:center;
	padding:40px 50px;
	font:bold 12pt Tahoma;

	z-index:100;
	float:right;
	margin-right:-350px;
	margin-top:220px;
	_margin-top:230px;
	visibility:hidden;
}
</style>

</head>

<body>
<!-- #include file="./_amenu.asp" -->

<h1>RSS Feeds do Blogger</h1>

<div id="containerRSS">
	<div id="theGridraw" style="display:none;">
		<span mjt.def="editLink(n,url)"><a href="javascript:_start.readRSS(startEditRss, $n);">$url</a></span>
		<span mjt.def="deleteOneRSS(id)"><a href="javascript:if(confirm('Deseja apagar este post ?')){_start.deleteRSS(callbackSaveRss, $id);}">(X) Apagar este RSS</a></span>
		<span mjt.def="setPrincipalRSS(id)"><a href="javascript:_start.setPrincipal(callbackSaveRss, $id);"> >> SER PRINCIPAL << </a></span>

		<span mjt.for="n in objRss.rss">
			${n.principalblogger==1?'>>PRINCIPAL<<':setPrincipalRSS(n.idrss)}
			<br />
			${deleteOneRSS(n.idrss)}
			${(x1++) * (objRss.actualPage + 1) } - $n.titulo 
			<br />
			Mídia : ${n.mediatipo==null?'-':n.mediatipo=='blogger'?'blogger':n.mediatipo}
			<br />
			${n.textocurto==null?'-':n.textocurto}
			<br />
			${n.url==null?'':editLink(n.idrss,n.url)}
			<hr />
		</span>
	</div>
	<div id="pagesraw" style="display:none;">
		<span mjt.def="mklink(n)"><a href="javascript:_start.readRSS(getRss,0 , $n);">$n</a></span>
		<span  mjt.for="(x = 0; x < objRss.pages; x++)">${objRss.pages== 1?'':mklink(x)} </span>
	</div>


	<div id="theGrid"></div>
	<div id="pages"></div>


	<br />

	<div id="formRSS">
		<input type="hidden" value="0" id="idRss" />
		<br />
		<br />
		Titulo : <input type="text" value="" id="aRssTitle_" class="txtForm" />
		<br />
		Descrição : <input type="text" value="" id="aRssShortText_" class="txtForm" />
			<input type="hidden" id="aRssTipoMidia_" value="" />
		<br />
		Nome do blog : <input type="text" value="" id="aRssUrl_" class="txtForm" />
		<br />

		<input type="button" value="Salvar" onclick="saveRss();"/>
		<input type="button" value="Novo RSS" onclick="startNewRss();"/>
		<br />
	</div>

</div>

<div id="saveBox">salvando...</div>


</body>


</html>
