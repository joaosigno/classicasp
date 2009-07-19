<style>
	#menu_center_right
	{
		float:left;
		width:852px;
		margin:10px 0 40px 0;
		_margin:10px 0 40px 0 !important;
	}

	#boxVideos
	{
		width:852px;
	}

	#youtubePlayer
	{
		float:left;
		width:575px;
		padding:5px 0 0 3px;
		margin:0 5px 0 0;
	}

	#ultimosvideos
	{
		float:left;
		width:260px;
		margin:5px 0 0 0;
	}

	#titleUltimosVideos
	{
		float:left;
		width:262px;
		_width:260px;
		height:26px;
		background-image:url('./_img/bg_menu_item.jpg');
		background-repeat:repeat-x;
		background-position:0 -1px;
		text-align:right;
	}

	#listUltimosVideos
	{
		border-left:solid 1px #CCC;
		border-right:solid 1px #CCC;
		float:left;
		width:100%;
		height:395px;
		_height:405px !important;
		overflow:auto;
	}

	#listUltimosVideos ul
	{
		background-image:url('./_img/dot_gray.jpg');
	}

	#listUltimosVideos li
	{
		height:80px;
		background-image:url('./_img/bg_menu_sub_item.jpg');
		background-repeat:repeat-x;
		background-position:0 50px;
		line-height:9px;
		cursor:pointer;
	}

	#listUltimosVideos img
	{
		float:left;
		margin:0 0 0 -8px;
		_margin:0 0 0 -11px;
	}

	#titleVideos2
	{
		float:left;
		width:168px;
		_width:165px;
		color:#FFF;
		font-family:'tahoma';
		font-weight: bold;
		font-size:7pt;
		margin:0 0 0 1px;
		_margin:0 0 0 0;
		padding:0 0 0 2px;
		_padding:0 0 0 2px;
		background-image:url('./_img/bg_description.png');
		background-repeat:repeat-x;
		background-position:0 -35px;
	}
	
	#description2
	{
		float:left;
		width:168px;
		_width:165px;
		font-family:'trebuchet ms';
		font-weight: normal;
		font-size:7pt;
		margin:0;
		padding:0 0 0 2px;
	}



	.border
	{
		float:left;
		background-image:url('./_img/dot_gray.jpg');
		border-left:solid 1px #CCC;
		border-right:solid 1px #CCC;
		border-bottom:solid 1px #CCC;
		padding:3px 0 -3px 0;
		_padding:5px 0;
	}
	
	#stars
	{
		float:right;
		text-align:right;
	}

	
	#descriptionVd
	{
		float:left;
		width:572px;
		background-image:url('./_img/bg_description.png');
	}

	#stars img
	{
		border:none;
		margin:0;
		padding:0;
	}

	#descriptionVideo
	{
		width:290px;
		height:70px;
		_height:70px;
		font-family:'trebuchet ms';
		font-weight: normal;
		font-size:8pt;
		line-height:14px;
		color:#CCC;
		_margin:-10px 0 0 0;
	}

	#tituloVideo
	{
		width:290px;
		height:150px;
		font-family:'trebuchet ms';
		font-weight: bold;
		font-size:10.5pt;
		padding:0 0 0 0.5px;
		color:#FFF;
		height:20px;
		_height:30px;
	}

	#descr
	{
		float:left;
		width:290px;
		height:100px;
		padding:2px;
	}
	
	#moreVideos
	{
		height:25px;
		_height:10px;
		padding:8px;
	}
</style>


<script type="text/javascript">
	var nVideos = 0;
	var videos = null;
	var titulo = '';
	var descricao = '';
	var url = '';
	var estrela0 = '';
	var estrela1 = '';
	var estrela2 = '';
	var estrela3 = '';
	var estrela4 = '';

	function listVideos(callBack) {
		videos = JSON.parse(callBack);

		firstVideoOfList(videos.rss[0], 'load');
	}

	function firstVideoOfList(obj, event) {
		titulo = obj.title;
		descricao = obj.textDescription.substr(0, 255);
		url = obj.link;
		estrela0 = obj.starsDescription[0];
		estrela1 = obj.starsDescription[1];
		estrela2 = obj.starsDescription[2];
		estrela3 = obj.starsDescription[3];
		estrela4 = obj.starsDescription[4];

		$_('youtubePlayer').innerHTML = $_('rawVd').innerHTML;
		mjt.run('youtubePlayer');

		if (event == 'load') {
			mjt.run('listUltimosVideos');
		}
	}

	function videoOfList(id) {
		firstVideoOfList(videos.rss[id],'');
	}



	window.onload = function() {
		_Index.listaPrincipalRssYoutube(listVideos);
	}
</script>

		<div id="menu_center_right">

			<div id="boxVideos">
				<div id="youtubePlayer">
				</div>
				<div id="ultimosVideos">
					<div id="titleUltimosVideos"><img src="_img/bg_menu_item_videos_content.jpg" /></div>
					<div id="listUltimosVideos">
						<ul mjt.for="n in videos.rss">
							<li class="list" mjt.onclick="videoOfList(n.id)">
									<img src="${n.imgDescription}" width="70" height="53" />
									<span id="titleVideos2">${mjt.bless(n.title)}</span>
									<span id="description2">${mjt.bless(n.textDescription.substr(0,180))}</span>
							</li>
						</ul>
					</div>

					<div class="vejaMais border" onclick="">veja mais <img src="_img/bg_arrow_veja_mais.jpg" /></div>
				</div>
			</div>

		</div>


<span id="rawVd" style="display:none;">
	${mjt.bless(exibeflash(url, 'video1', 572, 343, false))}
	
	<div id="descriptionVd">
		<div id="descr">
			<div id="tituloVideo">
				${titulo}
			</div>

			<br />

			<div id="descriptionVideo">
				${mjt.bless(descricao)}
				<div id="moreVideos">
				[mais &gt;&gt;]
				</div>
			</div>
		</div>
		<div id="strs">
			<div id="stars">${mjt.bless('&lt;img src="_img/stars/star_0_' + estrela0 +'.png" &gt;')}${mjt.bless('&lt;img src="_img/stars/star_1_' + estrela1 +'.png" &gt;')}${mjt.bless('&lt;img src="_img/stars/star_2_' + estrela2 +'.png" &gt;')}${mjt.bless('&lt;img src="_img/stars/star_3_' + estrela3 +'.png" &gt;')}${mjt.bless('&lt;img src="_img/stars/star_4_' + estrela4 +'.png" &gt;')}</div>
		</div>
	</div>
</span>
