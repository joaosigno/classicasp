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
	var videos = null;
	var titulo = '';
	var descricao = '';
	var url = '';
	var estrelas = '';

	function listVideos(callBack) {
		videos = JSON.parse(callBack);

		firstVideoOfList(videos.rss[0]);
	}

	function firstVideoOfList(obj) {
		titulo = obj.title;
		descricao = obj.textDescription;
		url = obj.link;
		estrelas = obj.starsDescription;

		mjt.run('youtubePlayer');
		$_('youtubePlayer').style.visibility = 'visible';
	}

	window.onload = function() {
		_Index.listaPrincipalRssYoutube(listVideos);
	}
</script>

		<div id="menu_center_right">

			<div id="boxVideos">
				<div id="youtubePlayer" style="visibility:hidden;">

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
							<div id="stars"><img src="_img/stars/star_0_${estrelas[0]}.png" /><img src="_img/stars/star_1_${estrelas[1]}.png" /><img src="_img/stars/star_2_${estrelas[2]}.png" /><img src="_img/stars/star_3_${estrelas[3]}.png" /><img src="_img/stars/star_4_${estrelas[4]}.png" /></div>
						</div>
					</div>

				</div>
				<div id="ultimosVideos">
					<div id="titleUltimosVideos"><img src="_img/bg_menu_item_videos_content.jpg" /></div>
					<div id="listUltimosVideos">
						<ul>
							<li class="list">lista</li>
							<li class="list">lista</li>
						</ul>
					</div>

					<div class="vejaMais border" onclick="">veja mais <img src="_img/bg_arrow_veja_mais.jpg" /></div>
				</div>
			</div>

		</div>


