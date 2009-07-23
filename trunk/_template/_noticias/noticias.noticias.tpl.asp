
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
		width:150px;
		height:22px;
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


<style type="text/css">
	#menu_center_right_2
	{
		float:left;
		width:1004px;
		margin:5px 0 40px 0;
	}

	#box_news_images
	{
		float:left;
	}



	#ultimasNoticias3
	{
		float:left;
		width:310px;
		margin:0 0 0 3px;
	}

	#titleUltimasNoticias3
	{
		float:left;
		width:312px;
		_width:310px;
		height:27px;
		_height:26px;
		text-align:right;
		color:#FFF;
		font-family:'tahoma';
		font-weight: bold;
		font-size:7pt;
		margin:0;
		padding:0;
		background-image:url('./_img/bg_menu_item.jpg');
		background-repeat:repeat-x;
		background-position:0 0;
	}




	#listUltimasNoticias3
	{
		border-left:solid 1px #CCC;
		border-right:solid 1px #CCC;
		float:left;
		width:100%;
		height:352px;
		overflow:auto;
	}

	#listUltimasNoticias3 ul
	{
		background-image:url('./_img/dot_gray.jpg');
	}

	#listUltimasNoticias3 li
	{
		height:80px;
		background-image:url('./_img/bg_menu_sub_item.jpg');
		background-repeat:repeat-x;
		background-position:0 61px;
		_background-position:0 59px;
		cursor:pointer;
		margin:0 0 0 -44px;
		_margin:0 0 0 -1px;
	}

	
	.numberNews
	{
		float:left;
		width:45px;
		font-size:20pt;
		color:#888;
	}

	.titleNews
	{
		float:left;
		width:230px;
		font-family:'trebuchet ms';
		font-size:11.5pt;
		color:#555;
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
	
	.num
	{
		font-family:'trebuchet ms';
		font-weight: bold;
		font-size:10.5pt;
		padding:5px;
	}
	
	#noticia
	{
		float:left;
		width:519px;
		height:400px;
		padding:10px;
		overflow:auto;
	}
	</style>


<script type="text/javascript">
	var news = null;
	var newsAtLoad = null;

	function listNoticias(callBack) {
		news = JSON.parse(callBack);

		$_('listUltimasNoticias3').style.visibility = 'hidden';
		$_('listUltimasNoticias3').innerHTML = $_('listUltimasNoticias3Raw').innerHTML;
		$_('listUltimasNoticias3').style.visibility = 'visible';
		mjt.run('listUltimasNoticias3');

		firstNewsOfList(news.rss[0]);
	}



	function getNoticiaList(callBack) {
		newsList = JSON.parse(callBack);
		$_('noticias').style.visibility = 'hidden';
		$_('listNoticias').innerHTML = $_('listNoticiasRaw').innerHTML;
        $_('pages').innerHTML = $_('pagesraw').innerHTML;
        $_('pages2').innerHTML = $_('pagesraw').innerHTML;
		mjt.run('listNoticias');
		mjt.run('pages');
		mjt.run('pages2');
		$_('noticias').style.visibility = 'visible';

	}


	function firstNewsOfList(obj) {
		newsAtLoad = obj;
		$_('noticia').style.visibility = 'hidden';
		$_('noticia').innerHTML = $_('noticiaRaw').innerHTML;
		mjt.run('noticia');
		$_('noticia').style.visibility = 'visible';
	}




	function pegarRssBlogger(id) {
		_Index.listaRssBlogger(listNoticias, id);
	}


	window.onload = function() {
		_Index.listaMenuLeftNoticias(getNoticiaList, '0');
	<%If Not IsEmpty(Request.QueryString("id")) AND Request.QueryString("id") <> "" Then%>
		_Index.listaRssBlogger(listNoticias, '<%=Request.QueryString("id")%>');
	<%Else%>
		_Index.listaPrincipalRssBlogger(listNoticias);
	<%End If%>
	}
</script>




	<span id="listUltimasNoticias3Raw" style="display:none;visibility:hidden;">
		<ul mjt.for="a in news.rss">
			<li class="list" mjt.onclick="document.location.replace('noticias.asp?id=' + news.idDB, true);">
				<div class="numberNews">${(parseInt(a.id)+1)}°</div>
				<div class="titleNews">${a.title==''?'Sem titulo':a.title}</div>
			</li>
		</ul>
	</span>


	<span id="listNoticiasRaw" style="display:none;visibility:hidden;">
		<ul mjt.for="o in newsList.rss">
			<li class="list" mjt.onclick="pegarRssBlogger(o.idrss)" style="cursor:pointer;">
				${o.titulo}
			</li>
		</ul>
	</span>


	<div id="pagesraw" style="display:none;">
		<span mjt.def="mklink(n)"><span class="num" mjt.onclick="_Index.listaMenuLeftNoticias(getNoticiaList, n);">$n</span></span>
		<span  mjt.for="(x = 0; x < newsList.pages; x++)">${newsList.pages== 1?'':mklink(x)} </span>
	</div>

	<div id="noticiaRaw" style="display:none;visibility:hidden;">
		<span class="titleN" id="titleN">${newsAtLoad.title}</span>
		<span class="descriptionN" id="descriptionN">${mjt.bless(newsAtLoad.description)}</span>
	</div>



	<div id="menu_center_right_2">
		<div id="noticias">
			<div id="titleNoticias"><img src="_img/bg_menu_item_skull.jpg" /></div>
			<div class="vejaMais"><div id="pages"></div></div>
			<div id="listNoticias">
				<img class="videoInProgress" src="_img/loadinfo.net.gif" style="margin: 20% 35%;" />
			</div>
			<div class="vejaMais"><div id="pages2"></div></div>
			
		</div>

		<div id="noticia"></div>


		<div id="box_news_images">
			<div id="ultimasNoticias3">
				<div id="titleUltimasNoticias3"><img src="_img/bg_menu_item_noticias_content.jpg" /></div>
				<div id="listUltimasNoticias3">
					<img class="videoInProgress" src="_img/loadinfo.net.gif" style="margin: 20% 35%;" />
				</div>
				<div class="vejaMais border" onclick="window.open(news.rss[0].userUrl,'_blank');">veja mais notícias <img src="_img/bg_arrow_veja_mais.jpg" /></div>
			</div>
		</div>
	</div>