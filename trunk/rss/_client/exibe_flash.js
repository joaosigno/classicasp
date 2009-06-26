function exibeflash(arquivo, id, largura, altura){
	var film = "";
	film =	'<OBJECT classid=clsid:D27CDB6E-AE6D-11cf-96B8-444553540000 codebase=\\"http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0\" WIDTH=\"'+ largura +'\" HEIGHT=\"'+ altura +'\" id=\\"'+ id +'\\" ALIGN=\\"\\">' +
			'<PARAM NAME=movie VALUE=\"'+ arquivo +'\">' +
			'<param name=\"allowScriptAccess\" value=\"always\" />' +
            '<param name=\"allowFullScreen\" value=\"true\"></param>' +
			'<EMBED src=\"'+ arquivo +'\" quality=high allowScriptAccess=\"always\" WIDTH=\"'+ largura +'\" HEIGHT=\"'+ altura +'\" NAME=\"'+ id +'\" ALIGN=\"\" TYPE=\"application/x-shockwave-flash\" PLUGINSPAGE=\"http://www.macromedia.com/go/getflashplayer\"></EMBED>' +
			'</OBJECT>';

	return film;
}

function write_flash(arquivo, id, largura, altura, transparente){
	document.write('<OBJECT classid=clsid:D27CDB6E-AE6D-11cf-96B8-444553540000 codebase=\\"http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0\" WIDTH=\"'+ largura +'\" HEIGHT=\"'+ altura +'\" id=\"'+ id +'\" ALIGN=\\"\\">');
	document.write('<PARAM NAME=movie VALUE=\"'+ arquivo +'\">');
	document.write('<param name=\"allowScriptAccess\" value=\"always\" />');
	document.write('<PARAM NAME=quality VALUE=high>');
	document.write('<PARAM NAME=wmode VALUE='+ transparente +'>');
	document.write('<PARAM NAME=bgcolor VALUE=#FFFFFF>');
	document.write('<EMBED src=\"'+ arquivo +'\" quality=high wmode=\"'+ transparente +'\" bgcolor=#FFFFFF  WIDTH=\"'+ largura +'\" HEIGHT=\"'+ altura +'\" NAME=\"'+ id +'\" ALIGN=\"\" TYPE=\"application/x-shockwave-flash\" allowScriptAccess=\"always\" PLUGINSPAGE=\"http://www.macromedia.com/go/getflashplayer\"></EMBED>');
	document.write('</OBJECT>');
}