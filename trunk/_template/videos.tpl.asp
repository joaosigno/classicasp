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
		descricao = obj.textDescription.substr(0, 170);
		url = obj.link;
		estrela0 = obj.starsDescription[0];
		estrela1 = obj.starsDescription[1];
		estrela2 = obj.starsDescription[2];
		estrela3 = obj.starsDescription[3];
		estrela4 = obj.starsDescription[4];


		$_('youtubePlayer').innerHTML = $_('rawVd').innerHTML;
		mjt.run('youtubePlayer');

		if (event == 'load') {
			$_('listUltimosVideos').innerHTML = $_('listLastVideos').innerHTML;
			mjt.run('listUltimosVideos');
		}
	}

	function videoOfList(id) {
		firstVideoOfList(videos.rss[id], '');
	}

</script>

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
		background-position:0 54px;
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
		width:169px;
		_width:166px;
		color:#FFF;
		font-family:'tahoma';
		font-weight: bold;
		font-size:7pt;
		margin:0;
		_margin:0;
		padding:0 0 0 2px;
		_padding:0 0 0 2px;
		background-image:url('./_img/bg_description.png');
		background-repeat:repeat-x;
		background-position:0 -35px;
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



/*Player*/
	#youtubePlayer
	{
		float:left;
		width:575px;
		padding:5px 0 0 3px;
		margin:0 5px 0 0;
	}
	

	
	#descriptionVd
	{
		float:left;
		width:572px;
		height:110px;
		background-image:url('./_img/bg_description.png');
	}


	#stars
	{
		float:right;
		text-align:right;
		width:280px;
		margin-top:-121px;
		_margin-top:0;
	}

	#contentVideosDesc
	{
		display:block;
		float:left;
	}
	#tituloVideo
	{
		display:block;
		float:left;
		width:290px;
		height:30px;
		padding: 0 3px;
		font-family:'trebuchet ms';
		font-weight: bold;
		font-size:10.3pt;
		line-height:15px;
		color:#FFF;
	}


	#descriptionVideo
	{
		display:block;
		float:left;
		width:290px;
		height:50px;
		padding: 0 3px;
		font-family:'trebuchet ms';
		font-weight: normal;
		font-size:8.5pt;
		line-height:15px;
		color:#FFF;
	}

	
	#moreVideos
	{
		height:25px;
		_height:10px;
		padding:8px;
		display:block;
		float:left;
		width:290px;
	}


	#description2
	{
		float:left;
		width:168px;
		_width:165px;
		font-family:'tahoma';
		font-weight: normal;
		font-size:7.5pt;
		margin:0;
		padding:0 0 0 2px;
	}
	</style>


	<div id="menu_center_right">
		<div id="boxVideos">
			<div id="youtubePlayer"></div>

			<div id="ultimosVideos">
				<div id="titleUltimosVideos"><img src="_img/bg_menu_item_videos_content.jpg" /></div>
				<div id="listUltimosVideos">

				</div>
				<div class="vejaMais border" onclick="">veja mais <img src="_img/bg_arrow_veja_mais.jpg" /></div>
			</div>
		</div>
	</div>

