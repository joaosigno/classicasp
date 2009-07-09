<!-- #include file="./_template/header.tpl.asp" -->

<!-- #include file="./_lib/asp3tojson.lib.asp" -->
<!-- #include file="./_view/index.view.asp" -->





<script src="_client/mjt.js"></script>
<script src="_client/exibe_flash.js"></script>



<style>
body{
	clear:both;
    font:normal 8pt 'tahoma';
}
#theGrid{
	height:250px;
	width:500px;
    overflow:auto;
}
#containerRSS
{
	float:right; 
	margin-right:50px;
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







<div id="containerRSS">

	<div id="theGridraw" style="visibility:hidden;">
		<span mjt.for="n in objBlogger.rss">
			<hr />
			${n.title} <br />
			${mjt.bless(n.description)} <br />
		</span>
	</div>

	<div id="pagesraw" style="visibility:hidden;">
		<span mjt.def="alerta(n)">${alert(n)}</span>
		<span mjt.def="mklink(n)"><a href="javascript:_Index.listaRssBlogger(retorna,0 , $n);">$n</a></span>
		<span  mjt.for="(x = 0; x < objBlogger.pages; x++)">${objBlogger.pages== 1?'':mklink(x)} </span>
	</div>


	<div id="theGrid"><img src="_img/icon_inprogress.gif" /></div>
	<div id="pages"></div>


</div>

<div id="Div0">
	<div id="Div1" style="visibility:hidden;">
		<span mjt.for="n in objBlogger.rss">
			<hr />
			${n.title} <br />
			${mjt.bless(n.description)} <br />
		</span>
	</div>

	<div id="Div2" style="visibility:hidden;">
		<span mjt.def="alerta(n)">${alert(n)}</span>
		<span mjt.def="mklink(n)"><a href="javascript:_Index.listaRssBlogger(retorna,0 , $n);">$n</a></span>
		<span  mjt.for="(x = 0; x < objBlogger.pages; x++)">${objBlogger.pages== 1?'':mklink(x)} </span>
	</div>


	<div id="Div3"></div>
	<div id="Div4"></div>
</div>


<div id="Div5">
	<div id="Div6" style="visibility:hidden;">
		<span mjt.for="n in objBlogger.rss">
			<hr />
			${n.title} <br />
			${mjt.bless(n.description)} <br />
		</span>
	</div>

	<div id="Div7" style="visibility:hidden;">
		<span mjt.def="alerta(n)">${alert(n)}</span>
		<span mjt.def="mklink(n)"><a href="javascript:_Index.listaRssBlogger(retorna,0 , $n);">$n</a></span>
		<span  mjt.for="(x = 0; x < objBlogger.pages; x++)">${objBlogger.pages== 1?'':mklink(x)} </span>
	</div>


	<div id="Div8"></div>
	<div id="Div9"></div>
</div>



<!-- #include file="./_template/footer.tpl.asp" -->