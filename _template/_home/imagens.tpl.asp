		<div id="box_news_images2">
			<div id="ultimasImagens3">
				<div id="titleUltimasImagens3"><img src="_img/bg_menu_item_Imagens_content.jpg" /></div>
				<div id="imagemPrincipal">
					<img class="videoInProgress" src="_img/loadinfo.net.gif" style="margin: 20% 35%;" />
				</div>
				<div id="listUltimasImagens3">
					<img class="videoInProgress" src="_img/loadinfo.net.gif" style="margin: 20% 35%;" />
				</div>
				<div class="vejaMais border" onclick="window.open(urlBlogImages,'_blank');" style="border-left:none;border-right:none;">veja mais imagens no Flickr <img src="_img/bg_arrow_veja_mais.jpg" /></div>
			</div>
		</div>

	</div>




	<span id="listUltimasNoticias3Raw" style="display:none;visibility:hidden;">
		<ul mjt.for="a in news.rss">
			<li class="list">
				<div class="numberNews">${(parseInt(a.id)+1)}°</div>
				<div class="titleNews">${a.title==''?'Sem titulo':a.title}</div>
			</li>
		</ul>
	</span>



	<span id="listUltimasImagens3Raw" style="display:none;visibility:hidden;">
		<ul mjt.for="a in images.rss">
			<li class="list">
				<div class="titleNews">${a.title==''?'Sem titulo':a.title}</div>
			</li>
		</ul>
	</span>



<script type="text/javascript">
	var images = null;
	var urlBlogImages = '';
	function listImagens(callBack) {
		images = JSON.parse(callBack);

		urlBlogImages = images.rss[0].userUrl;

		$_('listUltimasImagens3').innerHTML = $_('listUltimasImagens3Raw').innerHTML;
		mjt.run('listUltimasImagens3');
	}
</script>

<style>
	#box_news_images2
	{
		float:left;
	}



	#ultimasImagens3
	{
		float:left;
		width:520px;
		margin:0 0 0 10px;
		border-left:solid 1px #CCC;
		border-right:solid 1px #CCC;
	}

	#titleUltimasImagens3
	{
		float:right;
		width:522px;
		_width:520px;
		height:26px;
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

	#imagemPrincipal
	{
		float:left;
		width:293px;
		height:250px;
		margin:0;
	}

	#listUltimasImagens3
	{
		float:left;
		width:225px;
		height:250px;
		overflow:auto;
		margin:0;
	}

	#listUltimasImagens3 ul
	{
		background-image:url('./_img/dot_gray.jpg');
	}

	#listUltimasImagens3 li
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

	
	</style>
