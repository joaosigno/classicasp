<!-- #include file="./../_security/auth.security.asp" -->
<html>

<head>
<META CONTENT="text/html; charset=ISO-8859-1">
<script language="javascript" type="text/javascript">
    function getPessoas(callback) {
        //alert(callback);
        if (eval(callback)) {
            document.location.replace('_start.asp', false);
        }
        else {
            alert('Login e Usuario não conferem');
        }
    }
</script>

</head>

<body>

<!-- #include file="./_amenu.asp" -->



</body>


</html>