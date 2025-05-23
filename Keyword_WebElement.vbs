
'***************************************************************
'File Name: Keyword_WebElement.vbs
'Date Ceated: 12/27/2006
'Created By: Chris Thompson & Steve Truong
'Description: Library contains all keyword functions for the WebElement object type
'
'Common Arguments:
'stepNum - Test step number
'stepName - Test step Name
'page - An abbreviation for the active page
'object - the recognition string for the object. Up to 3 properties can be used.
'expected - the expected results
'args - optional arguments
'***************************************************************


'***************************************************************
' Function: WebElement_VerifyExists (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  VerifyExists keyword for the WebElement type object
'***************************************************************

Function WebElement_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

    browserObj = getFields(0,page , "-")
	windowObj = getfieldsUpperNull(3,page , "-")
	frameObj=getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")

	If windowObj = "" AND frameObj = "" Then
		ident = "None"
	ElseIf windowObj = "" Then
		ident = "Frame"
	Else
		ident = "Window"	
	End If
	
	'Parse object description
	
	desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")

	'Set up log results

	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	logDetails= "Expected:  " &expected &CHR(13)

	Select Case Ident

	Case "None"

		Select Case UCase(args)

		Case Else

			If InStr(desc(0), ":=") Then 
				actual = Browser(browserObj).Page(page).WebElement(desc(0), desc(1), desc(2)).Exist(5)
			Else
				actual = Browser(browserObj).Page(page).WebElement(desc(0)).Exist(5)
			End If	
			result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)   

		End Select
		
	Case "Window"

		Select Case UCase(args)

		Case Else

			If InStr(desc(0), ":=") Then 
				actual = Browser( browserObj).Window(windowobj).Page(page).Frame(frameObj).WebElement(desc(0), desc(1),desc(2)).Exist(5)
			Else
				actual = Browser( browserObj).Window(windowobj).Page(page).Frame(frameObj).WebElement(desc(0)).Exist(5)
			End If	
			result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)   	

		End Select

	Case "Frame"

		Select Case UCase(args)

		Case Else

			If InStr(desc(0), ":=") Then
				actual = Browser( browserObj).Page(page).Frame(frameObj).WebElement(desc(0), desc(1),desc(2)).Exist
			Else
				actual = Browser( browserObj).Page(page).Frame(frameObj).WebElement(desc(0)).Exist
			End If      		   
			result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)   				

		End Select
	End Select
	  	 
End Function


'***************************************************************
' Function: WebElement_VerifyProperty (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  VerifyProperty keyword for the WebElement  type object
' Modifications: 03/15/2007, BW, Added Timestamp Arguement that handles passing time stamp into expected
'***************************************************************

Function WebElement_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

    browserObj = getFields(0,page , "-")
	windowObj = getfieldsUpperNull(3,page , "-")
	frameObj=getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")

	If windowObj = "" AND frameObj = "" Then
		ident = "None"
	ElseIf windowObj = "" Then
		ident = "Frame"
	Else
		ident = "Window"	
	End If
	
	'Parse property and expected result

	prop=getFields(0, expected, ":=")
	expected=getFields(1, expected, ":=")
    expected=replaceConstants(expected)

	'Parse object description
	
	desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")

	'Set up log results

	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	If (args = "") Then
		logDetails= "Expected:  " &expected &CHR(13)
	Else
		logDetails= "Expected: (" &args &")  " &expected &CHR(13)
	End If

	'Verify Datestamps
	If Expected = "Environment('Datestamp')" Then
		Expected = environment("Datestamp")
	Elseif instr (Expected,"Environment('Datestamp')<") Then
		expected = getfields(2,Expected,"<")
		   expected = mid(expected,1,len(expected)-1)
		Call Utility_GenDatestamp(stepNum, stepName,expectedResult, page, object, expected, "Run Time")  
		expected= environment("Datestamp")
	End If
	
	Select Case ident

	Case "None"
	
		Select Case UCase(args)

		Case "INSTRING"

			If InStr(desc(0), ":=") Then
			   actual = Browser(browserObj).Page(page).WebElement(desc(0), desc(1),desc(2)).GetROproperty(prop)   
			Else
			   actual = Browser(browserObj).Page(page).WebElement(desc(0)).GetROproperty(prop) 
			End If      
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult)

		Case "NEGATIVE"

			temp = mid(expected, inStr(1, expected, "Environment"), inStr(inStr(1, expected, "Environment"), expected, ")") - inStr(1, expected, "Environment") + 1)
			temp2 = mid(temp, inStr(1, temp, "'") + 1, inStr(inStr(1, temp, "'")+1, temp, "'") - 3)
			expected = replace(expected, temp, Environment(""&mid(temp2, 1, len(temp2)-2)))

			If InStr(desc(0), ":=") Then
				actual = Browser(browserObj).Page(page).WebElement(desc(0), desc(1),desc(2)).GetROproperty(prop) 	  
			Else
				actual = Browser(browserObj).Page(page).WebElement(desc(0)).GetROproperty(prop)
			End If	
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPointInstrNeg(expected, actual, logObject, logDetails, browserObj, expectedResult)

		Case Else

			 If InStr(desc(0), ":=") Then
		       actual = Browser(browserObj).Page(page).WebElement(desc(0), desc(1),desc(2)).GetROproperty(prop)
			Else    	  
		       actual = Browser(browserObj).Page(page).WebElement(desc(0)).GetROproperty(prop)
			End If   			
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)

		End Select

	Case "Frame"

		Select Case UCase(args)	

		Case "INSTRING"

			If InStr(desc(0), ":=") Then
			   actual = Browser(browserObj).Page(page).Frame(frameObj).WebElement(desc(0), desc(1),desc(2)).GetROproperty(prop)   
			Else
			   actual = Browser(browserObj).Page(page).Frame(frameObj).WebElement(desc(0)).GetROproperty(prop) 
			End If      
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult)
		
		Case Else

			If InStr(desc(0), ":=") Then
		       actual = Browser(browserObj).Page(page).Frame(frameObj).WebElement(desc(0), desc(1),desc(2)).GetROproperty(prop)
			Else    	  
		       actual = Browser(browserObj).Page(page).Frame(frameObj).WebElement(desc(0)).GetROproperty(prop)
			End If   			
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)

		End Select

	Case "Window"

		Select Case UCase(args)

		Case Else
	
			If InStr(desc(0), ":=") Then
				actual = Browser( browserObj).Window(windowobj).Page(page).Frame(frameObj).WebElement(desc(0), desc(1),desc(2)).GetROProperty(prop)
			Else
				actual = Browser( browserObj).Window(windowobj).Page(page).Frame(frameObj).WebElement(desc(0)).GetROProperty(prop)
			End If      		   
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)

		End Select

	End Select
	
End Function

'***************************************************************
' Function: Link_Click (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 3/21/2008
' Created By: Chris Thompson
' Description:  Click keyword for the Link type object
'***************************************************************

Function WebElement_Click (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop				' property name
	Dim logObject
	Dim logDetails
	Dim desc(2)			' 3 descriptions for an object

	prop=getFields(0, expected, ":=")
	expected=getFields(1, expected, ":=")
	expected = replaceConstants(expected)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	windowObj = getfieldsUpperNull(3,page , "-")
	frameObj=getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")

	If windowObj = "" AND frameObj = "" Then
		ident = "None"
	ElseIf windowObj = "" Then
		ident = "Frame"
	Else
		ident = "Window"	
	End If
	
	 'Parse object description

    desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")

	'Set up log results
	
    logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	If (args = "") Then
		logDetails= "Expected: " &expected &CHR(13)
	Else
		logDetails= "Expected: (" &args &")  " &expected &CHR(13)
	End If
		
	Select Case ident

	Case "None"
	
		Select Case UCase(args)

			 'POPUP argument for dealing with when a popup is opened
	
			Case "POPUP"
				If InStr(desc(0), ":=") Then
					Browser( browserObj ).Page(page).WebElement(desc(0), desc(1),desc(2)).Click
				Else
					Browser( browserObj ).Page(page).WebElement(desc(0)).Click
				End If	
				actual = Browser(getFields(0,expected,"-")).Page(getFields(1,expected,"-")).Exist(5) 
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(TRUE, actual, logObject, logDetails, browserObj, expectedResult)	

			 'Back argument for clicking the back button after verification
			   
			Case "BACK"
				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).WebElement(desc(0), desc(1),desc(2)).Click
				Else
					Browser(browserObj).Page(page).WebElement(desc(0)).Click
				End If	
				actual = Browser(browserObj).Page("title:=.*").GetROProperty(prop) 	  
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult) 
				Browser(browserObj).Back
		
			Case "INSTRING"
				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).WebElement(desc(0), desc(1),desc(2)).Click
				Else
					Browser(browserObj).Page(page).WebElement(desc(0)).Click
				End If	
				actual = Browser(browserObj).Page("title:=.*").GetROProperty(prop) 	  
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult ) 	

			Case "WAIT"
				If InStr(desc(0), ":=") Then
					Browser(browserObj ).Page(page).WebElement(desc(0), desc(1),desc(2)).Click
				Else
					Browser(browserObj ).Page(page).WebElement(desc(0)).Click
				End If	
				Browser(browserObj).Page(page).WaitProperty "url", expected
				actual = Browser(browserObj).Page("title:=.*").GetROproperty(prop)	 
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)	

			Case "NO VALIDATION"
				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).WebElement(desc(0), desc(1),desc(2)).Click
				Else
					Browser(browserObj).Page(page).WebElement(desc(0)).Click
				End If  
				result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)	
			'No Argument 
			
			Case Else
				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).WebElement(desc(0), desc(1),desc(2)).Click
				Else
					Browser(browserObj).Page(page).WebElement(desc(0)).Click
				End If	
				actual = Browser(browserObj).Page(page).GetROProperty(prop) 	  
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails , browserObj, expectedResult) 

			End Select
			
		Case "Frame"
			
			Select Case UCase(args)

			Case Else
			
				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).Frame(frameObj).WebElement(desc(0), desc(1),desc(2)).Click
				Else
					Browser(browserObj).Page(page).Frame(frameObj).WebElement(desc(0)).Click
				End If

				result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)				  

			End Select				

		Case "Window"

			Select Case UCase(args)

			Case "DOUBLE WINDOW"   'This argument handles situation when a Window Object appears on top of another Window Object.     - Jason 4/10/2009
																		'The second Window must be manually nested within the first Window in the OR.  Also the second Window Object must be named the same as the first  Window Object.

			    If InStr(desc(0), ":=") Then
					Browser(browserObj).Window(windowObj).Window(windowObj).Page(page).Frame(frameObj).WebElement(desc(0), desc(1),desc(2)).Click
				Else
					Browser(browserObj).Window(windowObj).Window(windowObj).Page(page).Frame(frameObj).WebElement(desc(0)).Click
				End If
				actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).GetROproperty(prop)
				result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)					

			Case Else

				 If InStr(desc(0), ":=") Then
					Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebElement(desc(0), desc(1),desc(2)).Click
				Else

					Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebElement(desc(0)).Click
				End If
					actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).GetROproperty(prop)
				result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)					
					
			End Select
			
	End Select

End Function	

'***************************************************************
' Function: WebElement_Capture (stepNum, stepName, page, object, expected, args)
' Date Created: 5/7/2009
' Date Modifed: 5/7/2009
' Created By: Jason Craig
' Description:  Stores Object ROProperty as variable
'***************************************************************
Function WebElement_Capture (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	windowObj = getfieldsUpperNull(3,page , "-")
	frameObj = getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")

	If windowObj = "" AND frameObj = "" Then
		ident = "None"
	ElseIf windowObj = "" Then
		ident = "Frame"
	Else
		ident = "Window"	
	End If

	'Parse out property and expected results

	expected = replaceConstants(expected)

	'Parse object description

    desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")

	'Set up log results

    	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	If (args = "") Then
		logDetails= "Expected:  " &expected &CHR(13)
	Else
		logDetails= "Expected: (" &args &")  " &expected &CHR(13)
	End If

	'Branch on argument

	Select Case ident

		Case "Frame"
	    	
	    	If Instr(desc(0),":=") Then
	    		Environment("sData") = Browser(browserObj).Page(page).Frame(frameObj).WebElement(desc(0), desc(1), desc(2)).GetROProperty(expected)
	    	Else
	    		Environment("sData") = Browser(browserObj).Page(page).Frame(frameObj).WebElement(desc(0)).GetROProperty(expected)
	    	End If
			
		Case "Window"
			If Instr(desc(0),":=") Then
				Environment("sData") = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebElement(desc(0), desc(1), desc(2)).GetROProperty(prop)
			Else
				Environment("sData") = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebElement(desc(0)).GetROProperty(prop)
			End If
			
	
		Case "None"
			If Instr(desc(0),":=") Then
				Environment("sData") = Browser(browserObj).Page(page).WebElement(desc(0), desc(1), desc(2)).GetROProperty(prop)
			Else
				Environment("sData") = Browser(browserObj).Page(page).WebElement(desc(0)).GetROProperty(prop)
			End If

	End Select

End Function
