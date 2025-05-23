
'***************************************************************
'File Name: Keyword_Link.vbs 
'Date Ceated: 12/27/2006
'Created By: Chris Thompson
'Description: Library contains all keyword functions for the Link object type
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
' Function: Link_Click (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 3/21/2008
' Created By: Chris Thompson
' Description:  Click keyword for the Link type object
'***************************************************************

Function Link_Click (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop				' property name
	Dim logObject
	Dim logDetails
	Dim desc(2), descVal(2)			' 3 descriptions for an object

	prop=getFields(0, expected, ":=")
	expected=getFields(1, expected, ":=")
	expected = replaceConstants(expected)

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
	
	 'Parse object description

    desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")
	
	descVal(0) = getFields(1, desc(0), ":=")
	If descVal(0) = "TestVariable" Then
		desc(0) = Replace(desc(0),"TestVariable",Environment("TestVariable"))
	End If
	descVal(1) = getFields(1, desc(1), ":=")
	If descVal(1) = "TestVariable" Then
		desc(1) = Replace(desc(1),"TestVariable",Environment("TestVariable"))
	End If
	descVal(2) = getFields(1, desc(2), ":=")
	If descVal(2) = "TestVariable" Then
		desc(2) = Replace(desc(2),"TestVariable",Environment("TestVariable"))
	End If

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
				Browser( browserObj ).Page(page).link(desc(0), desc(1),desc(2)).Click
			Else
				Browser( browserObj ).Page(page).link(desc(0)).Click
			End If	
			actual = Browser(getFields(0,expected,"-")).Page(getFields(1,expected,"-")).Exist(30) 
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(TRUE, actual, logObject, logDetails, browserObj, expectedResult)	
			'Browser(getFields(0,expected,"-")).Sync
			
		 'Back argument for clicking the back button after verification
			   
		Case "BACK"
			If InStr(desc(0), ":=") Then
				Browser(browserObj).Page(page).Link(desc(0), desc(1),desc(2)).Click
			Else
				Browser(browserObj).Page(page).Link(desc(0)).Click
			End If	
			actual = Browser(browserObj).Page("title:=.*").GetROProperty(prop) 	  
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult) 
			Browser(browserObj).Back
		
		Case "INSTRING"
			If InStr(desc(0), ":=") Then
				Browser(browserObj).Page(page).Link(desc(0), desc(1),desc(2)).Click
			Else
				Browser(browserObj).Page(page).Link(desc(0)).Click
			End If	
			Wait(5)
			actual = Browser(browserObj).Page("title:=.*").GetROProperty(prop) 	  
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult ) 	

		Case "WAIT"
			If InStr(desc(0), ":=") Then
				Browser(browserObj ).Page(page).Link(desc(0), desc(1),desc(2)).Click
			Else
				Browser(browserObj ).Page(page).Link(desc(0)).Click
			End If	
			Browser(browserObj).Page(page).WaitProperty "url", expected
			actual = Browser(browserObj).Page("title:=.*").GetROproperty(prop)	 
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)	
  	
		  Case "NO VALIDATION"

			 If InStr(desc(0), ":=") Then
				Browser(browserObj).Page(page).Link(desc(0), desc(1),desc(2)).Click
			Else
				Browser(browserObj).Page(page).Link(desc(0)).Click
			End If
			result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)			
		Case "IFEXISTS"

			 If InStr(desc(0), ":=") Then
				 If Browser(browserObj).Page(page).Link(desc(0), desc(1),desc(2)).Exist Then
				 	Browser(browserObj).Page(page).Link(desc(0), desc(1),desc(2)).Click
				 	result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)	
				End If
			Else
				If Browser(browserObj).Page(page).Link(desc(0)).Exist Then
					Browser(browserObj).Page(page).Link(desc(0)).Click
					result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)	
				End If
			End If
		'No Argument 	
		Case Else

			 If InStr(desc(0), ":=") Then
				Browser(browserObj).Page(page).Link(desc(0), desc(1),desc(2)).Click
			Else
				Browser(browserObj).Page(page).Link(desc(0)).Click
				'Browser("MAIN").Page("Start Page").Link("User Security").Click
			End If	
		
			actual = Browser(browserObj).Page("title:=.*").GetROProperty(prop) 	  
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult ) 
			
		End Select

	Case "Window"

		Select Case UCase(args)
        

		Case Else

			If InStr(desc(0), ":=") Then
				Browser(browserObj).window(WindowObj).Page(page).Frame(frameObj).Link(desc(0), desc(1),desc(2)).Click 
			Else
		object = expected
				Browser(browserObj).window(WindowObj).Page(page).Frame(frameObj).Link(desc(0)).Click   
			End If   
			
			'Conditional used if clicking link closes window
			If InStr(expected, ":=") Then
				actual = Browser( browserObj).window(WindowObj).Page(page).Frame(frameObj).GetROProperty(prop)
			Else
				actual = expected
			End If
			logDetails = logDetais & " Actual: " &actual
			result = verificationPoint(expected, actual, logObjet, logDetails, browserObj, expectedResult)

		End Select

	Case "Frame"

		Select Case UCase(args)

			 Case "NO VALIDATION"

			 If InStr(desc(0), ":=") Then
				Browser(browserObj).Page(page).Frame(frameObj).Link(desc(0), desc(1),desc(2)).Click
			Else
				Browser(browserObj).Page(page).Frame(frameObj).Link(desc(0)).Click
			End If
			result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)			

			' For Data Entry scripts:  Click on link if it exists, if Link does not exist, write to log and exit

			Case "IFEXISTS"
				If Browser(browserObj).Page(page).Frame(frameObj).Exist Then
					If InStr(desc(0), ":=") Then
						If Browser(browserObj).Page(page).Frame(frameObj).Link(desc(0), desc(1),desc(2)).Exist = false Then
							Environment("RunComments") = "Link "&desc(0) &" "&desc(1)&" "&desc(2)&" does not exist."
							Environment("RunFailures") = Environment("RunFailures") + 1
							Environment("RunTimeError") = "No"
							ExitAction
						Else
							Browser(browserObj).Page(page).Frame(frameObj).Link(desc(0), desc(1),desc(2)).Click
						End If						
					Else
						If Browser(browserObj).Page(page).Frame(frameObj).Link(desc(0)).Exist = false Then
							Environment("RunComments") = "Link "&desc(0)&" does not exist."
							Environment("RunFailures") = Environment("RunFailures") + 1
							Environment("RunTimeError") = "No"
							ExitAction
						Else
							Browser(browserObj).Page(page).Frame(frameObj).Link(desc(0)).Click
						End If						
					End If
					actual = Browser(browserObj).Page(page).Frame(frameObj).GetROproperty(prop)
					logDetails = logDetails & " Actual: " &actual
					result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)		
				End If

			Case Else

				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).Frame(frameObj).Link(desc(0), desc(1),desc(2)).Click
				Else
					Browser(browserObj).Page(page).Frame(frameObj).Link(desc(0)).Click
				End If
				result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)
'				  actual = Browser(browserObj).Page(page).Frame(frameObj).GetROproperty(prop) 	  

		End Select

	End Select

	'If Environment("BrowserToUse") = "Chrome" Then
		'Browser(browserObj).Maximize
	'End If

End Function

'***************************************************************
' Function: Link_VerifyExists (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  VerifyExists keyword for the Link type object
'***************************************************************
Function Link_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	page = getFields(1,page , "-")

	'Parse object description
	
	desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")

	'Set up log results
	
	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	logDetails= "Expected:  " &expected &CHR(13)

	If InStr(desc(0), ":=") Then 
		actual = Browser(browserObj).Page(page).Link(desc(0), desc(1), desc(2)).Exist
	Else
		actual = Browser(browserObj).Page(page).Link(desc(0)).Exist
	End If	
	result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)  
  
End Function

'***************************************************************
' Function: Link_VerifyProperty (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  VerifyProperty keyword for the Link type object
'***************************************************************

Function Link_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

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

	'Branch on argument

	Select Case ident

	Case "None"

		Select Case UCase(args)

		 'INSTRING argument for testing a string within a string

		Case "INSTRING"
			If InStr(desc(0), ":=") Then
			   actual = Browser(browserObj).Page(page).Link(desc(0), desc(1),desc(2)).GetROProperty(prop)
			Else
			   actual = Browser(browserObj).Page(page).Link(desc(0)).GetROProperty(prop)
			End If    	  
			   logDetails = logDetails & " Actual: " &actual  
			   Result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult )
			   
		'No Argument 

		Case Else
			If InStr(desc(0), ":=") Then
		       actual = Browser(browserObj).Page(page).Link(desc(0), desc(1),desc(2)).GetROProperty(prop)
			Else
		       actual = Browser(browserObj).Page(page).Link(desc(0)).GetROProperty(prop)
			End If    	  
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)

		End Select

	Case "Frame"

		Select Case UCase(args)

		 'INSTRING argument for testing a string within a string

		Case "INSTRING"
			If InStr(desc(0), ":=") Then
			   actual = Browser(browserObj).Page(page).Frame(frameObj).Link(desc(0), desc(1),desc(2)).GetROProperty(prop)
			Else
			   actual = Browser(browserObj).Page(page).Frame(frameObj).Link(desc(0)).GetROProperty(prop)
			End If    	  
			   logDetails = logDetails & " Actual: " &actual  
			   Result = verificationPointInstr(expected, actual, logObject, logDetails , browserObj, expectedResult)
			   
		'No Argument 

		Case Else
			If InStr(desc(0), ":=") Then
		       actual = Browser(browserObj).Page(page).Frame(frameObj).Link(desc(0), desc(1),desc(2)).GetROProperty(prop)
			Else
		       actual = Browser(browserObj).Page(page).Frame(frameObj).Link(desc(0)).GetROProperty(prop)
			End If    	  
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)

		End Select

	Case "Window"

		Select Case UCase(args)

		 'INSTRING argument for testing a string within a string

		Case "INSTRING"
			If InStr(desc(0), ":=") Then
			   actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).Link(desc(0), desc(1),desc(2)).GetROProperty(prop)
			Else
			   actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).Link(desc(0)).GetROProperty(prop)
			End If    	  
			   logDetails = logDetails & " Actual: " &actual  
			   Result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult )
			   
		'No Argument 

		Case Else
			If InStr(desc(0), ":=") Then
		       actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).Link(desc(0), desc(1),desc(2)).GetROProperty(prop)
			Else
		       actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).Link(desc(0)).GetROProperty(prop)
			End If    	  
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)

		End Select

	End Select
		
End Function

