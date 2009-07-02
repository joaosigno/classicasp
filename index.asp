<!-- #include file="./_lib/asp3tojson.lib.asp" -->
<!-- #include file="./_view/index.view.asp" -->
<html>

<head>



<script src="_client/mjt.js"></script>
<script src="_client/exibe_flash.js"></script>

<style>
body{
	clear:both;
    font:normal 8pt 'tahoma';
}
#theGrid{
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


<script>
	var objBlogger = null;

	function retorna(msg) {
		objBlogger = JSON.parse(msg);
		$_('theGrid').style.visibility = 'hidden';
		$_('pages').style.visibility = 'hidden';
		$_('theGrid').innerHTML = $_('theGridraw').innerHTML;
		$_('pages').innerHTML = $_('pagesraw').innerHTML;
		mjt.run('theGrid');
		mjt.run('pages');
		$_('theGrid').style.visibility = 'visible';
		$_('pages').style.visibility = 'visible';
	}

	window.onload = function(){
	    new _Index.listaPrincipalRssBlogger(retorna);
	}



</script>




</head>


<body>

<img width='1' height='1' src='https://blogger.googleusercontent.com/tracker/3529317068477049888-1923876767128121849?l=kodomonotoki.blogspot.com'/>


<div id="containerRSS">

	<div id="theGridraw" style="visibility:hidden;">
		<span mjt.for="n in objBlogger.rss">
			${n.title} <br />
			${mjt.bless(n.description)} <br />
		</span>
	</div>

	<div id="pagesraw" style="visibility:hidden;">
		<span mjt.def="alerta(n)">${alert(n)}</span>
		<span mjt.def="mklink(n)"><a href="javascript:_Index.listaRssBlogger(retorna,0 , $n);">$n</a></span>
		<span  mjt.for="(x = 0; x < objBlogger.pages; x++)">${objBlogger.pages== 1?'':mklink(x)} </span>
	</div>


	<div id="theGrid"></div>
	<div id="pages"></div>


</div>





</body>


</html>
