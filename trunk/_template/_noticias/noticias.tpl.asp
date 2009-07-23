<script type="text/javascript">
	var news = null;
	function listNoticias(callBack) {
		news = JSON.parse(callBack);

		$_('listUltimasNoticias3').innerHTML = $_('listUltimasNoticias3Raw').innerHTML;
		mjt.run('listUltimasNoticias3');
	}
</script>

<style>
	#menu_center_right_2
	{
		float:left;
		width:852px;
		margin:5px 0 40px 0;
	}

	#box_news_images
	{
		float:left;
		width:100%;
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




	#listUltimasNoticias3
	{
		border-left:solid 1px #CCC;
		border-right:solid 1px #CCC;
		float:left;
		width:100%;
		height:250px;
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
	</style>
<!--
mjt.onclick="openNews(a.id)"
-->

	<span id="listUltimasNoticias3Raw" style="display:none;visibility:hidden;">
		<ul mjt.for="a in news.rss">
			<li class="list">
				<div class="numberNews">${(parseInt(a.id)+1)}°</div>
				<div class="titleNews">${a.title==''?'Sem titulo':a.title}</div>
			</li>
		</ul>
	</span>

	<div id="menu_center_right_2">
		<div id="box_news_images">
			<div id="ultimasNoticias3">
				<div id="titleUltimasNoticias3"><img src="_img/bg_menu_item_noticias_content.jpg" /></div>
				<div id="listUltimasNoticias3">
					<img class="videoInProgress" src="_img/loadinfo.net.gif" style="margin: 20% 35%;" />
				</div>
				<div class="vejaMais border" onclick="window.open(news.rss[0].userUrl,'_blank');">veja mais <img src="_img/bg_arrow_veja_mais.jpg" /></div>
			</div>
		</div>
	</div>

