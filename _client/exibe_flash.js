function exibeflash(arquivo, id, largura, altura, transparente) {
	arquivo += '&color1=0x2b405b&color2=0x000000&border=0&title=1&fullscreen=1';
	var film = "";
	film =	'<OBJECT classid=clsid:D27CDB6E-AE6D-11cf-96B8-444553540000 codebase=\\"http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0\" WIDTH=\"'+ largura +'\" HEIGHT=\"'+ altura +'\" id=\\"'+ id +'\\" ALIGN=\\"\\">' +
			'<PARAM NAME=movie VALUE=\"'+ arquivo +'\">' +
			'<param name=\"allowScriptAccess\" value=\"always\" />' +
            '<param name=\"wmode\" value=\"' + transparente + '\"></param>' +
            '<param name=\"allowFullScreen\" value=\"true\"></param>' +
			'<EMBED src=\"' + arquivo + '\" quality=high allowScriptAccess=\"always\"  wmode=\"' + transparente + '\" WIDTH=\"' + largura + '\" HEIGHT=\"' + altura + '\" NAME=\"' + id + '\" ALIGN=\"\" TYPE=\"application/x-shockwave-flash\" PLUGINSPAGE=\"http://www.macromedia.com/go/getflashplayer\"></EMBED>' +
			'</OBJECT>';

	return film;
}

function write_flash(arquivo, id, largura, altura, transparente) {
	document.write( exibeflash(arquivo, id, largura, altura, transparente) );
}