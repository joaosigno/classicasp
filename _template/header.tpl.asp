<%Response.CharSet = "utf-8" %>
<!-- START HEADER -->

<html>

<head>

<title>OS Seres - Grupo Teatral</title>

<script type="text/javascript" src="_client/mjt.js"></script>
<script type="text/javascript" src="_client/exibe_flash.js"></script>

<style> 
*,body,div,span
{
	margin:0;
	font-family:'Arial';
	font-size:8pt;
	font-weight:bold;
}

.videoInProgress
{
	margin: 25% 43%;
}

.contentVideoInProgress
{
	margin-left:50px;
}

#conteiner
{
	width:100%;
	text-align:-moz-center;
	_text-align:center;
}



#topo
{
	width:100%;
	background:#000;
}

#banner
{
	text-align:right;
	height:162px;
	width:1002px;
	background-image:url('./_img/header_right_big.jpg');
	background-repeat:no-repeat;
	background-position:right;
}

body:nth-of-type(1) #banner
{
	margin:0;
	text-align:center;
	background:#000;
}


#title_left
{
	display:block;
	float:left;
	height:162px;
	width:450px;
	background-image:url('_img/os_seres_big.jpg');
	background-position:30px 30px;
	background-repeat:no-repeat;
	cursor:pointer;
}

#header_center
{
	display:block;
	float:left;
	height:162px;
	width:272px;
	background-image:url('_img/header_center_big.jpg');
	background-position:20px 10px;
	background-repeat:no-repeat;
}

#line
{
	_margin:0 0 -10px 0;
	height:10px;
	width:100%;
	background-image:url('_img/gray_bar_header.jpg');
}

#menu_top
{
	text-align:center;
	height:26px;
	width:100%;
	background-image:url('_img/bg_menu_top.jpg');
	background-repeat:repeat-x;
}


#top_items
{
	text-align:-moz-center;
	_text-align:center;
	height:26px;
	width:1000px;
}

#bg_menu_top_home
{
	cursor:pointer;
	margin:0 30px 0 10px;
}
#bg_menu_top_noticias
{
	cursor:pointer;
	margin:0 30px 0 30px;
}
#bg_menu_top_imagens
{
	cursor:pointer;
	margin:0 30px 0 30px;
}
#bg_menu_top_videos
{
	cursor:pointer;
	margin:0 30px 0 30px;
}
#bg_menu_top_diario
{
	cursor:pointer;
	margin:0 30px 0 30px;
}
#bg_menu_top_contato
{
	cursor:pointer;
	margin:0 30px 0 30px;
}
#bg_menu_top_grupo
{
	cursor:pointer;
	margin:0 30px 0 30px;
}

#footer
{
	float:left;
	display:block;
	height:300px;
	width:100%;
	background-image:url('_img/bones_footer.jpg');
	background-color:#000;
	background-repeat:repeat-x;
}

#boxfooter
{
	width:1002px;
	text-align:left;
}

#seres
{
	float:left;
	height:150px;
	width:400px;
	background-image:url('./_img/bg_skull_pointer.jpg');
	background-repeat:no-repeat;
	background-position:0 120px;
	color:#FFF;
	padding:130px 0 0 50px;
}

#logoSeres
{
	float:right;
	padding:80px 0 0 0;
	text-align:right;
}

.quickLink:hover
{
	color:#FFF;
	text-decoration:none;
}

.quickLink:visited
{
	color:#FFF;
	text-decoration:none;
}

.quickLink:link
{
	color:#FFF;
	text-decoration:none;
}

#content
{
	width:1002px;
	text-align:left;
	display:block;
	background:#FFF;
}

</style>

</head>

<body bgcolor="#ffffff">


<div id="conteiner" align="center">

	<div id="topo">
		<div id="banner">
			<div id="title_left"></div>
			<div id="header_center"></div>
			<img src="_img/header_right_big.jpg" />
		</div>
		<div id="line"></div>
	</div>



	<div id="menu_top">
		<span id="top_items">
			<img id="bg_menu_top_home" src="_img/bg_menu_top_home.jpg" />
			<img id="bg_menu_top_grupo" src="_img/bg_menu_top_grupo.jpg" />
			<img id="bg_menu_top_noticias" src="_img/bg_menu_top_noticias.jpg" />
			<img id="bg_menu_top_imagens" src="_img/bg_menu_top_imagens.jpg" />
			<img id="bg_menu_top_videos" src="_img/bg_menu_top_videos.jpg" />
			<img id="bg_menu_top_diario" src="_img/bg_menu_top_diario.jpg" />
			<img id="bg_menu_top_contato" src="_img/bg_menu_top_contato.jpg" />
		</span>
	</div>

<!-- END HEADER -->


	<div id="content">