<!-- #include file="./_lib/asp3tojson.lib.asp" -->
<!-- #include file="./_view/index.view.asp" -->
<html>

<head>



<script src="_client/mjt.js"></script>
<script src="_client/exibe_flash.js"></script>

<script language="javascript" type="text/javascript">
</script>

<style>
#theGrid{
    height:200px;
    width:250px;
    overflow:auto;
    font:normal 8pt 'tahoma';
}
</style>

<script>
	function retorna(msg) {
		alert(msg);
	}

	window.onload = function(){
		new _Index.listaRssBlogger(retorna,50);
	}

</script>


</head>


<body>







</body>


</html>
