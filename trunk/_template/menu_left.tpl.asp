
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
		cursor:pointer;
		width:150px;
		height:195px;
		background-image:url('_img/diario_de_bordo.jpg');
		background-position:-3px 3px;
		background-repeat:no-repeat;
	}

	#grupo
	{
		cursor:pointer;
		width:150px;
		height:27px;
		background-image:url('./_img/bg_menu_top.jpg');
		background-repeat:repeat-x;
		margin:10px 0 0 0;
		text-align:center;
	}

	#videos
	{
		float:left;
		width:150px;
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
		float:left;
		width:150px;
		_width:150px;
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
		float:left;
		width:150px;
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
		width:100%;
		height:20px;
		color:#F00;
		font-size:9pt;
		text-align:right;
		padding:3px -2px 2px 0;
		margin:0 -1px 0 0;
		background-image:url('./_img/dot_gray.jpg');
		cursor:pointer;
	}

	.vejaMais img
	{
		margin:0 1px -2px 0;
		_margin:0 5px -1px 0;
		padding:3px 12px 2px 0;
	}
	



	</style>


	<script type="text/javascript">
		mediaList = null;
		newsList = null;
		imageList = null;
		function getMediaList(callBack) {
			mediaList = JSON.parse(callBack);
			$_('listVideos').innerHTML = $_('listVideosRaw').innerHTML;
			mjt.run('listVideos');
		}

		function getNoticiaList(callBack) {
			newsList = JSON.parse(callBack);
			$_('listNoticias').innerHTML = $_('listNoticiasRaw').innerHTML;
			mjt.run('listNoticias');
		}

		function getImagemList(callBack) {
			imageList = JSON.parse(callBack);
			$_('listImagens').innerHTML = $_('listImagensRaw').innerHTML;
			mjt.run('listImagens');
		}

		window.onload = function() {
			_Index.listaMenuLeftVideos(getMediaList, '0');
			_Index.listaMenuLeftNoticias(getNoticiaList, '0');
			_Index.listaMenuLeftImagens(getImagemList, '0');
			_Index.listaPrincipalRssYoutube(listVideos);
		}
	</script>



<span id="listVideosRaw" style="display:none;visibility:hidden;">
	<ul mjt.for="n in mediaList.rss">
		<li class="list" mjt.onclick="pegarEsteRss(n.idrss)">
			${n.titulo}
		</li>
	</ul>
</span>


<span id="listNoticiasRaw" style="display:none;visibility:hidden;">
	<ul mjt.for="o in newsList.rss">
		<li class="list" mjt.onclick="pegarEsteRss(o.idrss)">
			${o.titulo}
		</li>
	</ul>
</span>


<span id="listImagensRaw" style="display:none;visibility:hidden;">
	<ul mjt.for="p in imageList.rss">
		<li class="list" mjt.onclick="pegarEsteRss(p.idrss)">
			${p.titulo}
		</li>
	</ul>
</span>


<span id="listLastVideos" style="display:none;visibility:hidden;">
	<ul mjt.for="q in videos.rss">
		<li class="list" mjt.onclick="videoOfList(q.id)">
				${mjt.bless('&lt;img src="' + q.imgDescription + '" width="70" height="53" &gt;')}
				<span id="titleVideos2">${mjt.bless(q.title)}</span>
				<span id="description2">${mjt.bless(q.textDescription.substr(0,168))}</span>
		</li>
	</ul>
</span>


<span id="rawVd" style="display:none;visibility:hidden;">
	${mjt.bless(exibeflash(url, 'video1', 572, 343, false))}
	
	<div id="descriptionVd">
		<span id="contentVideosDesc">
			<span id="tituloVideo" >${mjt.bless(titulo)}</span>

			<span id="descriptionVideo">
				${mjt.bless(descricao)}
			</span>
			<span id="moreVideos">
				[mais &gt;&gt;]
			</span>
		</span>
		<span id="stars">${mjt.bless('&lt;img src="_img/stars/star_0_' + estrela0 +'.png" &gt;')}${mjt.bless('&lt;img src="_img/stars/star_1_' + estrela1 +'.png" &gt;')}${mjt.bless('&lt;img src="_img/stars/star_2_' + estrela2 +'.png" &gt;')}${mjt.bless('&lt;img src="_img/stars/star_3_' + estrela3 +'.png" &gt;')}${mjt.bless('&lt;img src="_img/stars/star_4_' + estrela4 +'.png" &gt;')}</span>
	</div>
</span>


	<div id="menu_left" style="background-color:#FFF;">
		<div id="diario">&nbsp;</div>
		<div id="grupo" onclick="document.location.href.replace('#',true);"><img src="_img/bg_menu_top_grupo.jpg" /></div>

		<div id="videos">
			<div id="titleVideos"><img src="_img/bg_menu_item_skull.jpg" /></div>
			<div id="listVideos">
				<img class="videoInProgress" src="_img/loadinfo.net.gif" style="margin: 20% 35%;" />
			</div>
			<div class="vejaMais" onclick="">veja mais <img src="_img/bg_arrow_veja_mais.jpg" /></div>
		</div>

		<div id="noticias">
			<div id="titleNoticias"><img src="_img/bg_menu_item_skull.jpg" /></div>
			<div id="listNoticias">
				<img class="videoInProgress" src="_img/loadinfo.net.gif" style="margin: 20% 35%;" />
			</div>
			<div class="vejaMais" onclick="">veja mais <img src="_img/bg_arrow_veja_mais.jpg" /></div>
		</div>

		<div id="imagens">
			<div id="titleImagens"><img src="_img/bg_menu_item_skull.jpg" /></div>
			<div id="listImagens">
				<img class="videoInProgress" src="_img/loadinfo.net.gif" style="margin: 20% 35%;" />
			</div>
			<div class="vejaMais" onclick="">veja mais <img src="_img/bg_arrow_veja_mais.jpg" /></div>
		</div>
	</div>



