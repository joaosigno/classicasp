<!-- #include file="./_template/header.tpl.asp" -->

<!-- #include file="./_lib/asp3tojson.lib.asp" -->
<!-- #include file="./_view/index.view.asp" -->

	<style>
	#content
	{
		width:1002px;
		text-align:left;
		display:block;
	}

	#diario
	{
		width:150px;
		height:195px;
		background-image:url('_img/diario_de_bordo.jpg');
		background-position:-3px 3px;
		background-repeat:no-repeat;
	}
	#menu_left
	{
		border:solid 1px;
		float:left;
		width:150px;
		margin:10px 0 40px 0;
	}


	#grupo
	{
		width:150px;
		height:27px;
		background-image:url('./_img/bg_menu_top.jpg');
		background-repeat:repeat-x;
		margin:10px 0 0 0;
		text-align:center;
		cursor:pointer;
	}

	#videos
	{
		width:150px;
		height:150px;
		background-image:url('./_img/bg_menu_item.jpg');
		background-repeat:repeat-x;
		margin:0 0 5px 0;
	}

	#titleVideos
	{
		width:150px;
		height:28px;
		background-image:url('./_img/bg_menu_item_videos.jpg');
		background-repeat:no-repeat;
		background-position:50px 0;
		text-align:right;
	}

	#noticias
	{
		width:150px;
		height:150px;
		background-image:url('./_img/bg_menu_item.jpg');
		background-repeat:repeat-x;
		margin:0 0 5px 0;
	}

	#titleNoticias
	{
		width:150px;
		height:28px;
		background-image:url('./_img/bg_menu_item_noticias.jpg');
		background-repeat:no-repeat;
		background-position:50px 0;
		text-align:right;
	}

	#imagens
	{
		width:150px;
		height:150px;
		background-image:url('./_img/bg_menu_item.jpg');
		background-repeat:repeat-x;
		margin:0 0 5px 0;
	}

	#titleImagens
	{
		width:150px;
		height:28px;
		background-image:url('./_img/bg_menu_item_imagens.jpg');
		background-repeat:no-repeat;
		background-position:50px 0;
		text-align:right;
	}


	</style>


	<div id="content">
		<div id="menu_left">
			<div id="diario">&nbsp;</div>
			<div id="grupo" onclick="document.location.href.replace('#',true);"><img src="_img/bg_menu_top_grupo.jpg" /></div>

			<div id="videos">
				<div id="titleVideos"><img src="_img/bg_menu_item_skull.jpg" /></div>
				<div id="listVideos">lista</div>
				<div class="vejaMais">veja mais &gt;&gt;</div>
			</div>

			<div id="noticias">
				<div id="titleNoticias"><img src="_img/bg_menu_item_skull.jpg" /></div>
				<div id="listNoticias">lista</div>
				<div class="vejaMais">veja mais &gt;&gt;</div>
			</div>

			<div id="imagens">
				<div id="titleImagens"><img src="_img/bg_menu_item_skull.jpg" /></div>
				<div id="listImagens">lista</div>
				<div class="vejaMais">veja mais &gt;&gt;</div>
			</div>
		</div>




		<div id="menu_center_right">
			Conteudo aqui
		</div>
	</div>






<!-- #include file="./_template/footer.tpl.asp" -->