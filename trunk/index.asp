<!-- #include file="./_template/header.tpl.asp" -->

<!-- #include file="./_lib/asp3tojson.lib.asp" -->
<!-- #include file="./_view/index.view.asp" -->


<!-- #include file="./_template/menu_left.tpl.asp" -->

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
		height:400px;
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
		width:269px;
		_width:270px;
		height:380px;
		border-left:solid 1px #CCC;
		border-right:solid 1px #CCC;
		float:left;
		width:100%;
		height:374px;
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
</style>

<script type="text/javascript" src="_client/exibe_flash.js"></script>

		<div id="menu_center_right">

			<div id="boxVideos">
				<div id="youtubePlayer">

					<script>write_flash('http://www.youtube.com/v/iewQ45wJ7JA', 'video1', 572, 343, false); </script>
				</div>
				<div id="ultimosVideos">
					<div id="titleUltimosVideos"><img src="_img/bg_menu_item_videos_content.jpg" /></div>
					<div id="listUltimosVideos"></div>

					<div class="vejaMais border" onclick="">veja mais <img src="_img/bg_arrow_veja_mais.jpg" /></div>
				</div>
			</div>

		</div>






<!-- #include file="./_template/footer.tpl.asp" -->