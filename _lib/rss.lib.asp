<%
Class RSSLib
	Public Function rssTest(strFeedUri)
	    On Error resume next
        output = ""
		Dim strErrMsg

		strContactEmail = vbNullString
		strErrMsg = "Rss não encontrado, ou contém erros"


		Dim objXml, strXml, objDom
		Dim arrRssItems, intRssItems, objRssItem

		' Create XML object and open RSS feed
		Set objXml = Server.CreateObject("MSXML2.XMLHTTP.3.0")
		objXml.Open "GET", strFeedUri, false
		objXml.Send()
		strXml = objXml.ResponseText
		' Clean-up
		Set objXml = Nothing

		Set objDom = Server.CreateObject("MSXML2.DomDocument.3.0")
		objDom.async = false
		objDom.LoadXml(strXml)
		' Collect all "items" from downloaded RSS
		Set arrRssItems = objDom.getElementsByTagName("item")
		' Clean-up
		Set objDom = Nothing

		intRssItems = arrRssItems.Length - 1

		If intRssItems = 0 or Err.number <> 0 Then
			output = output &  Mid(Err.Description, 1, (Len(Err.Description) - 2) ) & ""
			Err.Clear()
		End If

        rssTest = output

        'Error.Clear
	End Function


	Public Function rssFromBlogger(strFeedUri, intMax)
        output = ""
		' ------- Configuration variables
			' strContactEmail. Webmaster contact email
			' strErrMsg. Error message that will be displayed if no items exist in the RSS feed
			Dim strContactEmail, strErrMsg

			strContactEmail = vbNullString
			strErrMsg = "An error occurred while trying to process " & strFeedUri & ".<br />Please contact the " & _
				"<a href=""mailto:" & strContactEmail & """>webmaster</a>."

		' ------- Template variables:
			' strTplHeader = HTML template header
			' strTplFooter = HTML template footer
			' strTplItem = HTML item template
				' {LINK} will be replaced with item link
				' {TITLE} will be replaced with item title
				' {DESCRIPTION} will be replaced with item description
			Dim strTplHeader, strTplFooter, strTplItem

			strTplHeader = "["
			strTplFooter = "]"
 			strTplItem = "{""link"":""{LINK}"",""title"":""{TITLE}"",""description"":""{DESCRIPTION}""}"

		' ------- End variables

		Dim objXml, strXml, objDom
		Dim arrRssItems, intRssItems, objRssItem
		Dim j, i
		Dim strRssTitle, strRssLink, strRssDesc, strRssImage, strRssImageSmall, strRssImageThumb
		Dim strItemContent
		Dim objChild

		' Create XML object and open RSS feed
		Set objXml = Server.CreateObject("MSXML2.XMLHTTP.3.0")
		objXml.Open "GET", strFeedUri, false
		objXml.Send()
		strXml = objXml.ResponseText
		' Clean-up
		Set objXml = Nothing

		Set objDom = Server.CreateObject("MSXML2.DomDocument.3.0")
		objDom.async = false
		objDom.LoadXml(strXml)
		' Collect all "items" from downloaded RSS
		Set arrRssItems = objDom.getElementsByTagName("item")
		' Clean-up
		Set objDom = Nothing

		intRssItems = arrRssItems.Length - 1

		If intRssItems > 0 Then
			output = output & (strTplHeader)
			j = -1
			
			
			For i = 0 To intRssItems
			    strRssDesc = ""

				Set objRSSItem = arrRssItems.Item(i)
				For Each objChild in objRSSItem.childNodes
					Select Case LCase(objChild.nodeName)
						Case "link"
							strRsslink = objChild.text
						Case "title"
							strRssTitle = objChild.text
						Case "description"
							strRssDesc = objChild.text
					End Select
				Next
 
				j = j + 1

                tmpOut = ""
				If j < Clng(intMax) Then
					strItemContent = Replace(strTplItem, "{LINK}", strRsslink)
					strItemContent = Replace(strItemContent, "{TITLE}", strRssTitle)
					strItemContent = Replace(strItemContent, "{DESCRIPTION}", Escape(strRssDesc))

					output = output & (strItemContent)
				ElseIf j > Clng(intMax) Then
                    exit for
				End If

				If (j < Clng(intMax) - 1) and (i < intRssItems) Then 
					output = output & "," & chr(13)
				End If
			Next

			output = output & (strTplFooter)
 
 			' Clean-up
			Set objChild = Nothing
			Set objRssItem = Nothing
 		Else
			output = output & (strErrMsg)
		End If

        rssFromBlogger = output
	End Function


	Public Function rssFromFlickr(strFeedUri, intMax)
        output = ""
		' ------- Configuration variables
			' strContactEmail. Webmaster contact email
			' strErrMsg. Error message that will be displayed if no items exist in the RSS feed
			Dim strContactEmail, strErrMsg

			strContactEmail = vbNullString
			strErrMsg = "An error occurred while trying to process " & strFeedUri & ".<br />Please contact the " & _
				"<a href=""mailto:" & strContactEmail & """>webmaster</a>."

		' ------- Template variables:
			' strTplHeader = HTML template header
			' strTplFooter = HTML template footer
			' strTplItem = HTML item template
				' {LINK} will be replaced with item link
				' {TITLE} will be replaced with item title
				' {DESCRIPTION} will be replaced with item description
			Dim strTplHeader, strTplFooter, strTplItem

			strTplHeader = "["
			strTplFooter = "]"
 			strTplItem = "{""link"":""{LINK}"",""title"":""{TITLE}"",""description"":""{DESCRIPTION}""," &_
 			             """image"":""{IMAGE}"",""imageSmall"":""{IMAGESMALL}"",""imageThumb"":""{IMAGETHUMB}""}"

		' ------- End variables

		Dim objXml, strXml, objDom
		Dim arrRssItems, intRssItems, objRssItem
		Dim j, i
		Dim strRssTitle, strRssLink, strRssDesc, strRssImage, strRssImageSmall, strRssImageThumb
		Dim strItemContent
		Dim objChild

		' Create XML object and open RSS feed
		Set objXml = Server.CreateObject("MSXML2.XMLHTTP.3.0")
		objXml.Open "GET", strFeedUri, false
		objXml.Send()
		strXml = objXml.ResponseText
		' Clean-up
		Set objXml = Nothing

		Set objDom = Server.CreateObject("MSXML2.DomDocument.3.0")
		objDom.async = false
		objDom.LoadXml(strXml)
		' Collect all "items" from downloaded RSS
		Set arrRssItems = objDom.getElementsByTagName("item")
		' Clean-up
		Set objDom = Nothing

		intRssItems = arrRssItems.Length - 1

		If intRssItems > 0 Then
			output = output & (strTplHeader)
			j = -1
			
			
			For i = 0 To intRssItems
			    strRssDesc = ""

				Set objRSSItem = arrRssItems.Item(i)
				For Each objChild in objRSSItem.childNodes
					Select Case LCase(objChild.nodeName)
						Case "link"
							strRsslink = objChild.text
						Case "media:title"
							strRssTitle = objChild.text
						Case "media:thumbnail"
							strRssImageThumb = objChild.attributes.getnameditem("url").text
							strRssImageSmall = Replace(strRssImageThumb, "_s.jpg", "_m.jpg")
						Case "media:content"
							strRssImage = objChild.attributes.getnameditem("url").text
						Case "media:description"
							strRssDesc = objChild.text
					End Select
				Next
 
				j = j + 1

                tmpOut = ""
				If j < Clng(intMax) Then
					strItemContent = Replace(strTplItem, "{LINK}", strRsslink)
					strItemContent = Replace(strItemContent, "{TITLE}", strRssTitle)
					strItemContent = Replace(strItemContent, "{DESCRIPTION}", Escape(strRssDesc))
					strItemContent = Replace(strItemContent, "{IMAGE}", strRssImage)
					strItemContent = Replace(strItemContent, "{IMAGESMALL}", strRssImageSmall)
					strItemContent = Replace(strItemContent, "{IMAGETHUMB}", strRssImageThumb)

					output = output & (strItemContent)
				ElseIf j > Clng(intMax) Then
                    exit for
				End If

				If (j < Clng(intMax) - 1) and (i < intRssItems) Then 
					output = output & "," & chr(13)
				End If
			Next

			output = output & (strTplFooter)
 
 			' Clean-up
			Set objChild = Nothing
			Set objRssItem = Nothing
 		Else
			output = output & (strErrMsg)
		End If

        rssFromFlickr = output
	End Function



	Public Function rssFromYouTube(strFeedUri, intMax)

        output = ""
		' ------- Configuration variables
			' strContactEmail. Webmaster contact email
			' strErrMsg. Error message that will be displayed if no items exist in the RSS feed
			Dim strContactEmail, strErrMsg

			strContactEmail = vbNullString
			strErrMsg = "An error occurred while trying to process " & strFeedUri & ".<br />Please contact the " & _
				"<a href=""mailto:" & strContactEmail & """>webmaster</a>."

		' ------- Template variables:
			' strTplHeader = HTML template header
			' strTplFooter = HTML template footer
			' strTplItem = HTML item template
				' {LINK} will be replaced with item link
				' {TITLE} will be replaced with item title
				' {DESCRIPTION} will be replaced with item description
			Dim strTplHeader, strTplFooter, strTplItem

			strTplHeader = "["
			strTplFooter = "]"
 			strTplItem = "{""link"":""{LINK}"",""title"":""{TITLE}"",""imgDescription"":""{imgDescription}""," &_
 			             """timeDescription"":""{timeDescription}"",""textDescription"":""{textDescription}""," &_
 			             """viewsDescription"":""{viewsDescription}"",""ratingsDescription"":""{ratingsDescription}""," &_
 			             """starsDescription"":[""{starsDescription1}"",""{starsDescription2}"",""{starsDescription3}"",""{starsDescription4}"",""{starsDescription5}""]}"

		' ------- End variables

		Dim objXml, strXml, objDom
		Dim arrRssItems, intRssItems, objRssItem
		Dim j, i
		Dim strRssTitle, strRssLink, strRssDesc
		Dim strItemContent
		Dim objChild

		' Create XML object and open RSS feed
		Set objXml = Server.CreateObject("MSXML2.XMLHTTP")
		objXml.Open "GET", strFeedUri, false
		objXml.Send()
		strXml = objXml.ResponseText
		' Clean-up
		Set objXml = Nothing

		Set objDom = Server.CreateObject("MSXML2.DomDocument")
		objDom.async = false
		objDom.LoadXml(strXml)
		' Collect all "items" from downloaded RSS
		Set arrRssItems = objDom.getElementsByTagName("item")
		' Clean-up
		Set objDom = Nothing

		intRssItems = arrRssItems.Length - 1

		If intRssItems > 0 Then

			output = output & (strTplHeader)

			j = -1

			For i = 0 To intRssItems
				Set objRSSItem = arrRssItems.Item(i)
				For Each objChild in objRSSItem.childNodes
					Select Case LCase(objChild.nodeName)
						Case "title"
							strRssTitle = objChild.text
						Case "link"
                            strRssLink = Replace(objChild.text, "?v=", "/v/")
						Case "description"
							strRssDesc = objChild.text
					End Select
				Next
 
				j = j + 1


                tmpOut = ""
				If j < Clng(intMax) Then
					

					pos1 = InStr(strRssDesc, "<img alt="""" src=""")
					pos2 = InStr(strRssDesc, "/default.jpg"">")
					tmpOut = Mid(strRssDesc, (pos1 + 17), ((pos2 - pos1) - 5))
					posTime1 = InStr(strRssDesc, "11px; font-weight: bold;"">")
					posTime2 = InStr(posTime1, strRssDesc, "</span>")
					tmpOutTime = Mid(strRssDesc, (posTime1 + Len("11px; font-weight: bold;"">")), 5 )

					posViews1 = InStr(strRssDesc, "Views:")
					posViews2 = InStr(posViews1, strRssDesc, "</div>")
					tmpOutViews = Mid(strRssDesc, (posViews1 + Len("Views:</span>") + 1), ((posViews2 - posViews1) - ((Len("</div>") * 2) + 2) )  )

					posText1 = InStr(strRssDesc, "<span>")
					posText2 = InStr(posText1, strRssDesc, "</span>")
					tmpOutText = Mid(strRssDesc, (posText1 + Len("<span>")), ((posText2 - posText1) - ((Len("</span>") * 2) - 8) )  )

					posRatings1 = InStr(strRssDesc, "<div style=""font-size: 11px;"">")
					posRatings2 = InStr(posRatings1, strRssDesc, "<span style=")
					tmpOutRatings = Mid(strRssDesc, (posRatings1 + Len("<div style=""font-size: 11px;"">")), ((posRatings2 - posRatings1) - ((Len("<span style=") *2) + 7 ) )  )

					pos1Stars1 = InStr(strRssDesc, "http://gdata.youtube.com/static/images/icn_star_")
					pos2Stars1 = InStr(pos1Stars1, strRssDesc, "_11x11.gif")
					tmpOutStar1 = Mid(strRssDesc, pos1Stars1 + Len("http://gdata.youtube.com/static/images/icn_star_"), ((pos2Stars1 - pos1Stars1) - Len("http://gdata.youtube.com/static/images/icn_star_")) )

					pos1Stars2 = Instr(pos2Stars1, strRssDesc, "http://gdata.youtube.com/static/images/icn_star_")
					pos2Stars2 = InStr(pos1Stars2, strRssDesc, "_11x11.gif")
					tmpOutStar2 = Mid(strRssDesc, pos1Stars2 + Len("http://gdata.youtube.com/static/images/icn_star_"), ((pos2Stars2 - pos1Stars2) - Len("http://gdata.youtube.com/static/images/icn_star_")) )

					pos1Stars3 = Instr(pos2Stars2, strRssDesc, "http://gdata.youtube.com/static/images/icn_star_")
					pos2Stars3 = InStr(pos1Stars3, strRssDesc, "_11x11.gif")
					tmpOutStar3 = Mid(strRssDesc, pos1Stars3 + Len("http://gdata.youtube.com/static/images/icn_star_"), ((pos2Stars3 - pos1Stars3) - Len("http://gdata.youtube.com/static/images/icn_star_")) )

					pos1Stars4 = Instr(pos2Stars3, strRssDesc, "http://gdata.youtube.com/static/images/icn_star_")
					pos2Stars4 = InStr(pos1Stars4, strRssDesc, "_11x11.gif")
					tmpOutStar4 = Mid(strRssDesc, pos1Stars4 + Len("http://gdata.youtube.com/static/images/icn_star_"), ((pos2Stars4 - pos1Stars4) - Len("http://gdata.youtube.com/static/images/icn_star_")) )

					pos1Stars5 = Instr(pos2Stars4, strRssDesc, "http://gdata.youtube.com/static/images/icn_star_")
					pos2Stars5 = InStr(pos1Stars5, strRssDesc, "_11x11.gif")
					tmpOutStar5 = Mid(strRssDesc, pos1Stars5 + Len("http://gdata.youtube.com/static/images/icn_star_"), ((pos2Stars5 - pos1Stars5) - Len("http://gdata.youtube.com/static/images/icn_star_")) )

					strItemContent = Replace(strTplItem, "{LINK}", strRsslink)
					strItemContent = Replace(strItemContent, "{TITLE}", strRssTitle)

					strItemContent = Replace(strItemContent, "{imgDescription}", tmpOut)
					strItemContent = Replace(strItemContent, "{timeDescription}", tmpOutTime)
					strItemContent = Replace(strItemContent, "{viewsDescription}", tmpOutViews)
					strItemContent = Replace(strItemContent, "{textDescription}", tmpOutText)
					strItemContent = Replace(strItemContent, "{ratingsDescription}", tmpOutRatings)
					strItemContent = Replace(strItemContent, "{starsDescription1}", tmpOutStar1)
					strItemContent = Replace(strItemContent, "{starsDescription2}", tmpOutStar2)
					strItemContent = Replace(strItemContent, "{starsDescription3}", tmpOutStar3)
					strItemContent = Replace(strItemContent, "{starsDescription4}", tmpOutStar4)
					strItemContent = Replace(strItemContent, "{starsDescription5}", tmpOutStar5)

					output = output & (strItemContent)
				ElseIf j >= Clng(intMax) Then
                    exit for
				End If

				If (j < Clng(intMax)) and (i < intRssItems) Then 
					output = output & "," & chr(13)
				End If

			Next

			output = output & (strTplFooter)
 
 			' Clean-up
			Set objChild = Nothing
			Set objRssItem = Nothing
 		Else
			output = output & (strErrMsg)
		End If

        rssFromYouTube = output
	End Function


    Public Function escape(val)
	    dim cDoubleQuote, cRevSolidus, cSolidus
	    cDoubleQuote = &h22
	    cRevSolidus = &h5C
	    cSolidus = &h2F
		
	    dim i, currentDigit
	    for i = 1 to (len(val))
		    currentDigit = mid(val, i, 1)
		    if asc(currentDigit) > &h00 and asc(currentDigit) < &h1F then
			    currentDigit = escapequence(currentDigit)
		    elseif asc(currentDigit) >= &hC280 and asc(currentDigit) <= &hC2BF then
			    currentDigit = "\u00" + right(padLeft(hex(asc(currentDigit) - &hC200), 2, 0), 2)
		    elseif asc(currentDigit) >= &hC380 and asc(currentDigit) <= &hC3BF then
			    currentDigit = "\u00" + right(padLeft(hex(asc(currentDigit) - &hC2C0), 2, 0), 2)
		    else
			    select case asc(currentDigit)
				    case cDoubleQuote: currentDigit = escapequence(currentDigit)
				    case cRevSolidus: currentDigit = escapequence(currentDigit)
				    case cSolidus: currentDigit = escapequence(currentDigit)
			    end select
		    end if
		    escape = escape & currentDigit
	    next
    End Function

    '******************************************************************************************
    '* JsonEscapeSquence 
    '******************************************************************************************
    private function escapequence(digit)
	    escapequence = "\u00" + right(padLeft(hex(asc(digit)), 2, 0), 2)
    end function

    '******************************************************************************************
    '* padLeft 
    '******************************************************************************************
    Private function padLeft(value, totalLength, paddingChar)
	    padLeft = right(clone(paddingChar, totalLength) & value, totalLength)
    end function


	'******************************************************************************************
	'* clone 
	'******************************************************************************************
	private function clone(byVal str, n)
		dim i
		for i = 1 to n : clone = clone & str : next
	end function

End Class

'//Flickr
'//http://api.flickr.com/services/feeds/photos_friends.gne?user_id=38549912@N07&friends=0&display_all=1&lang=pt-br&format=rss_200

'http://www.youtube.com/rss/user/irategamer/videos.rss
%>