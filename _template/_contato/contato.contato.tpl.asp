<style type="text/css">
	#menu_left
	{
		float:left;
		width:150px;
		margin:10px 0 40px 0;
		_margin:10px 0 40px 0 !important;
	}



	#menu_center_right
	{
		float:left;
		width:1004px;
		margin:10px 0 5px 0;
		_margin:10px 0 5px 0 !important;
	}


	#formContato
	{
		float:left;
		width:150px;
	}
	</style>





	<div id="menu_center_right">
		<span id="formContato">
			Email : <input id="rementente_" style="width:146px;" type="text" value=""  /><br />
			Mensagem : <textarea id="mensagem_" cols="20" rows="10"></textarea><br />
			<input type="button" onclick="enviar_('teste','ok');" value="Enviar" />
		</span>
	</div>


<script type="text/javascript">
	function enviar_(remetente, msg) {
		_Index.enviarEmail_(callbackSendMail, $_('rementente_').value, $_('mensagem_').value);
	}

	function callbackSendMail(msgCallback) {
		alert(msgCallback);
	}
</script>




