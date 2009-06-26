<!-- #include file="./../_lib/asp3tojson.lib.asp" -->
<!-- #include file="./../_view/_admin/index.view.asp" -->
<html>

<head>
<META CONTENT="text/html; charset=ISO-8859-1">
<script language="javascript" type="text/javascript">
    function getPessoas(callback) {
        //alert(callback);
        if (eval(callback)) {
            document.location.replace('_startADM.asp', false);
        }
        else {
            alert('Login e Usuario não conferem');
        }
    }
</script>

</head>

<body>


<input type="text" id="l" value=""/><br />
<input type="text" id="p" value=""/><br />

<input type="button" value="get" onclick="new _IndexADM.executeLogin(getPessoas,$_('l').value,$_('p').value)" />


</body>


</html>