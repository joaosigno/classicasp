<style type="text/css">
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


	#menu_center_right
	{
		float:left;
		width:1004px;
		margin:5px 0 40px 0;
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

	#menu_center_right
	{
		float:left;
		width:1004px;
		margin:10px 0 5px 0;
		_margin:10px 0 5px 0 !important;
	}


	.num
	{
		font-family:'trebuchet ms';
		font-weight: bold;
		font-size:10.5pt;
		padding:5px;
	}
	</style>







<script type="text/javascript">
	<%Dim idImage : idImage = Request.QueryString("idImage")%>
	<%If IsEmpty(idImage) or idImage = "" Then idImage = 0 End If%>
	var idImage = '<%=idImage%>';
	var images = null;
	var imageList = null;
	var imageAtLoad = null;
	var nImages = 0;



	function listImagens(callBack) {
		images = JSON.parse(callBack);

		$_('listUltimasImagens3').style.visibility = 'hidden';
		$_('listUltimasImagens3').innerHTML = $_('listUltimasImagens3Raw').innerHTML;
		mjt.run('listUltimasImagens3');
		$_('listUltimasImagens3').style.visibility = 'visible';

		firstImageOfList(images.rss[0], 'load');
	}

	function firstImageOfList(obj) {
		imageAtLoad = obj;
		$_('imagemPrincipal').style.visibility = 'hidden';
		$_('imagemPrincipal').innerHTML = $_('imagemPrincipalRaw').innerHTML;
		mjt.run('imagemPrincipal');
		$_('imagemPrincipal').style.visibility = 'visible';
	}

	function imageOfList(id) {
		firstImageOfList(images.rss[id]);
	}



	function pegarRssFlickr(id) {
		_Index.listaRssFlickr(listImagens, id);
	}



	function getImagesList(callBack) {
		imageList = JSON.parse(callBack);
		$_('listImagens').innerHTML = $_('listImagensRaw').innerHTML;
        $_('pages').innerHTML = $_('pagesraw').innerHTML;
		mjt.run('listImagens');
		mjt.run('pages');
	}


	window.onload = function() {
		_Index.listaMenuLeftImages(getImagesList, '0');
		<%If Not IsEmpty(Request.QueryString("id")) AND Request.QueryString("id") <> "" Then%>
		_Index.listaRssFlickr(listImagens, '<%=Request.QueryString("id")%>');
		<%Else%>
		idImage = 0;
		_Index.listaPrincipalRssFlickr(listImagens);
		<%End If%>
	}
</script>




<style type="text/css">
	#box_news_images2
	{
		float:left;
	}
	

	#ultimasImagens3
	{
		float:left;
		width:220px;
		margin:0 0 0 5px;
		border-left:solid 1px #CCC;
		border-right:solid 1px #CCC;
	}

	#titleUltimasImagens3
	{
		float:left;
		width:220px;
		_width:220px;
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
		width:623px;
		margin:0;
	}

	#listUltimasImagens3
	{
		float:left;
		overflow:auto;
		width:220px;
		height:450px;
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

	#theImage
	{
		float:left;
		width:100%;
		text-align:center;
	}

	.imagesFlickrPrincipal
	{
		margin:13px;
	}
	
	.titleOfImage
	{
		float:left;
		width:500px;
		margin:3px 3px 0 3px;
		font-family:'trebuchet ms';
		font-size:10.5pt;
		color:#555;
	}
	
	.descriptionOfImage
	{
		float:left;
		width:610px;
		height:200px;
		margin:3px;
		padding:5px;
		font-family:'trebuchet ms';
		font-size:10.5pt;
		color:#444;
		overflow:auto;
	}
</style>


<span id="listImagensRaw" style="display:none;visibility:hidden;">
	<ul mjt.for="p in imageList.rss">
		<li class="list" mjt.onclick="pegarRssFlickr(p.idrss)" style="cursor:pointer;">
			${p.titulo}
		</li>
	</ul>
</span>

<span id="imagemPrincipalRaw" style="display:none;visibility:hidden;">
	<span id="theImage" mjt.onclick="window.open(imageAtLoad.image,'_blank');" style="cursor:pointer;">
		${mjt.bless('&lt;img class="imagesFlickrPrincipal"  alt="' + imageAtLoad.title + '"  src="' + imageAtLoad.imageSmall + '" /&gt;')}
	</span>
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

<div id="pagesraw" style="display:none;">
	${imageList.pages==1?'':'Páginas'}
	<span mjt.def="mklink(n)"><span class="num" mjt.onclick="_Index.listaMenuLeftImages(getImagesList, n);">${parseInt(n+1)}</span></span>
	<span  mjt.for="(x = 0; x < imageList.pages; x++)">${imageList.pages== 1?'':(imageList.actualPage==x?x+1:mklink(x))} </span>
</div>


	<div id="menu_center_right">
		<div id="imagens">
			<div id="titleImagens"><img src="_img/bg_menu_item_skull.jpg" /></div>
			<div id="listImagens">
				<img class="videoInProgress" src="_img/loadinfo.net.gif" style="margin: 20% 35%;" />
			</div>
			<div class="vejaMais"><div id="pages"></div></div>
		</div>


		<div id="box_news_images2">
			<div id="imagemPrincipal">
				<img class="videoInProgress" src="_img/loadinfo.net.gif" style="margin: 20% 35%;" />
			</div>

			<div id="ultimasImagens3">
				<div id="titleUltimasImagens3"><img src="_img/bg_menu_item_Imagens_content.jpg" /></div>
				<div id="listUltimasImagens3">
				</div>
				<div class="vejaMais border" onclick="window.open(urlBlogImages,'_blank');" style="border-left:none;border-right:none;">
					mais imagens do mesmo no Flickr <img src="_img/bg_arrow_veja_mais.jpg" />
				</div>
			</div>
		</div>
	</div>

