		<div id="box_news_images2">
			<div id="ultimasImagens3">
				<div id="titleUltimasImagens3"><img src="_img/bg_menu_item_Imagens_content.jpg" /></div>
				<div id="imagemPrincipal">
					<img class="videoInProgress" src="_img/loadinfo.net.gif" style="margin: 20% 35%;" />
				</div>
				<div id="listUltimasImagens3" class="border">
				</div>

				<div class="vejaMais border" onclick="window.open(urlBlogImages,'_blank');" style="border-left:none;border-right:none;">
					veja mais imagens <img src="_img/bg_arrow_veja_mais.jpg" />
				</div>
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


	<span id="imagemPrincipalRaw" style="display:none;visibility:hidden;">
		${mjt.bless('&lt;img class="imagesFlickrPrincipal"  alt="' + imageAtLoad.title + '"  src="' + imageAtLoad.imageSmall + '" width="270" height="203" /&gt;')}
		<span class="titleOfImage">${imageAtLoad.title}</span>
		<span class="descriptionOfImage">${mjt.bless(imageAtLoad.description)}</span>
	</span>


	<span id="listUltimasImagens3Raw" style="display:none;visibility:hidden;">
		<span mjt.for="a in images.rss" style="background-color:#FFF;">
			<span mjt.onclick="imageOfList(a.id)" style="margin:0;padding:0;cursor:pointer;">
				${mjt.bless('&lt;image class="imagesFlickr" src="' + a.imageThumb + '" alt="' + a.title + '" &gt;')}
			</span>
		</span>
	</span>



<script type="text/javascript">
	var nS = 0;
	var images = null;
	var imageAtLoad = null;
	var urlBlogImages = '';
	function listImagens(callBack) {
		images = JSON.parse(callBack);

		urlBlogImages = images.rss[0].userUrl;

		$_('listUltimasImagens3').innerHTML = $_('listUltimasImagens3Raw').innerHTML;
		mjt.run('listUltimasImagens3');

		firstImageOfList(images.rss[0], 'load');
	}

	function firstImageOfList(obj) {
		imageAtLoad = obj;

		$_('imagemPrincipal').innerHTML = $_('imagemPrincipalRaw').innerHTML;
		mjt.run('imagemPrincipal');
	}

	function imageOfList(id) {
		firstImageOfList(images.rss[id]);
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
		width:525px;
		margin:0 0 0 5px;
		border-left:solid 1px #CCC;
		border-right:solid 1px #CCC;
	}

	#titleUltimasImagens3
	{
		float:right;
		width:527px;
		_width:523px;
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
		_background-position:0 0;
	}

	#imagemPrincipal
	{
		float:left;
		width:315px;
		_width:325px;
		margin:0;
	}

	#listUltimasImagens3
	{
		overflow:auto;
		width:200px;
		_width:190px;
		height:350px;
	}

	#listUltimasImagens3 ul
	{
		float:left;
		_float:right;
		list-style:none;
	}

	#listUltimasImagens3 li
	{
		cursor:pointer;
		text-align:center;
	}

	.imagesFlickr
	{
		float:left;
		margin:5px;
		padding:0;
	}

	.imagesFlickrPrincipal
	{
		margin:13px;
	}
	
	.titleOfImage
	{
		float:left;
		width:315px;
		margin:3px;
		font-family:'trebuchet ms';
		font-size:10.5pt;
		color:#555;
	}
	
	.descriptionOfImage
	{
		float:left;
		width:315px;
		margin:3px;
		padding:5px;
		font-family:'trebuchet ms';
		font-size:10.5pt;
		color:#444;
	}
	</style>
