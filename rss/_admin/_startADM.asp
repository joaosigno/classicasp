<!-- #include file="./../_security/auth.security.asp" --> 
<html>

<head>
    <title>Noticias</title>

<!-- #include file="./../_lib/asp3tojson.lib.asp" -->
<!-- #include file="./../_view/_admin/_startADM.view.asp" -->

<script src="../_client/mjt.js"></script>

<script language="javascript" type="text/javascript">
    objNoticias = { "noticias": [], "pages": 0, "actualPage": 0 };
    function getNoticias(callback) {
        objNoticias = JSON.parse(callback);
        $_('theGrid').innerHTML = $_('theGridraw').innerHTML;
        $_('pages').innerHTML = $_('pagesraw').innerHTML;
        mjt.run('theGrid');
        mjt.run('pages');
    }

    new _startADM.listaNoticias(getNoticias, "0");
</script>

<style>
#theGrid, #Div1{
    height:200px;
    width:250px;
    overflow:auto;
    font:normal 8pt 'tahoma';
}
</style>

</head>

<body>

<div id="theGrid"></div>
<div id="pages"></div>

<div id="theGridraw" style="display:none;">
    <span  mjt.for="n in objNoticias.noticias">$n.idnoticia - $n.titulo <br />${n.textocurto==null?'-':n.textocurto}<br />${n.texto==null?'-':n.texto}<hr /></span>
</div>


<div id="pagesraw" style="display:none;">
    <span mjt.def="mklink(n)"><a href="javascript:_startADM.listaNoticias(getNoticias, $n);">$n</a></span>

    <span  mjt.for="(x = 0; x < objNoticias.pages; x++)">${mklink(x)} </span>
</div>


</body>


</html>
