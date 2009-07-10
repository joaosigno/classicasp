
	<style>

	#menu_left
	{
		float:left;
		width:150px;
		margin:10px 0 40px 0;
		_margin:10px 0 40px 0 !important;
	}


	#diario
	{
		width:150px;
		height:195px;
		background-image:url('_img/diario_de_bordo.jpg');
		background-position:-3px 3px;
		background-repeat:no-repeat;
	}

	#grupo
	{
		width:150px;
		height:27px;
		background-image:url('./_img/bg_menu_top.jpg');
		background-repeat:repeat-x;
		margin:10px 0 0 0;
		text-align:center;
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

	
	.list
	{
		list-style:none;
		font-weight:normal;
		height:25px;
		_height:27px;
		background-image:url('./_img/bg_menu_sub_item.jpg');
		background-repeat:repeat-x;
		margin:0 0 -5px -40px;
		_margin:0 0 -5px 0;
		padding:2px 0 0 10px;
	}
	
	.vejaMais
	{
		height:20px;
		color:#F00;
		font-size:9pt;
		text-align:right;
		padding:3px 5px 2px 0;
		background-image:url('./_img/dot_gray.jpg');
		cursor:pointer;
	}

	</style>


		<div id="menu_left">
			<div id="diario">&nbsp;</div>
			<div id="grupo" onclick="document.location.href.replace('#',true);"><img src="_img/bg_menu_top_grupo.jpg" /></div>

			<div id="videos">
				<div id="titleVideos"><img src="_img/bg_menu_item_skull.jpg" /></div>
				<div id="listVideos">
					<ul>
						<li class="list">lista</li>
						<li class="list">lista</li>
					</ul>
				</div>
				<div class="vejaMais" onclick="">veja mais <img src="_img/bg_arrow_veja_mais.jpg" /></div>
			</div>

			<div id="noticias">
				<div id="titleNoticias"><img src="_img/bg_menu_item_skull.jpg" /></div>
				<div id="listNoticias">
					<ul>
						<li class="list">lista</li>
						<li class="list">lista</li>
					</ul>
				</div>
				<div class="vejaMais" onclick="">veja mais <img src="_img/bg_arrow_veja_mais.jpg" /></div>
			</div>

			<div id="imagens">
				<div id="titleImagens"><img src="_img/bg_menu_item_skull.jpg" /></div>
				<div id="listImagens">
					<ul>
						<li class="list">lista</li>
						<li class="list">lista</li>
					</ul>
				</div>
				<div class="vejaMais" onclick="">veja mais <img src="_img/bg_arrow_veja_mais.jpg" /></div>
			</div>
		</div>


