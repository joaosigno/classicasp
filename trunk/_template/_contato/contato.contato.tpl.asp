<style type="text/css">

	#menu_center_right
	{
		float:left;
		width:1004px;
		margin:10px 0 5px 0;
	}



	#lblMsg
	{
		float:left;
		width:1004px;
		font-family:'Trebuchet MS';
		font-size:15pt;
		font-weight:bold;
		color:#777;
	}

	#formcontato
	{
		float:left;
		margin:20px 200px 20px 200px;
	}

	#formContato div
	{
		float:left;
		font-family:'Trebuchet MS';
		font-size:15pt;
		font-weight:bold;
		color:#777;
	}

	input, textarea
	{
		float:left;
		font-family:'Trebuchet MS';
		font-size:15pt;
		font-weight:bold;
		color:#777;
		width:600px;
	}
	
	</style>





	<div id="menu_center_right">
		<div id="lblMsg">
			<br />
			Gostaria de falar com o grupo "OS SERES" ? 
			<br />
			Preencha este formúlario com suas sugestões, pedidos de apresentações na sua localidade ou empresa .
			<br />
			O mais breve possível entraremos em contato . Obrigado .
			
			<br />
			<br />
		</div>
		<span id="formContato">
			<div>Email : <input id="rementente_" type="text" value=""  /></div>
			<div>Mensagem : <textarea id="mensagem_" cols="20" rows="10"></textarea></div>
			<div><input type="button" id="btnE" onclick="enviar_();" value="Enviar" /></div>
		</span>
	</div>


<script type="text/javascript">
	function validMail(email) {
		var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
		var address = email;
		result = true;
		if (reg.test(address) == false) {
			result = false;
		}
		return result;
	}

	function enviar_() {
		err_ = '';
		if (!validMail($_('rementente_').value)) {
			err_ = 'Email inválido.';
		}
		else if ($_('mensagem_').value == '') {
			err_ = 'Preencha a mensagem.';
			}
		else {
			_Index.enviarEmail_(callbackSendMail, $_('rementente_').value, $_('mensagem_').value);
		}
		if (err_ != '') {
			alert(err_)
		}
	}

	function callbackSendMail(msgCallback) {
		$_('rementente_').disabled = true;
		$_('mensagem_').disabled = true;
		$_('btnE').disabled = true;
		alert(msgCallback);
	}
</script>




