'***************************************************************
'File Name: Keyword_Frame.vbs
'Date Ceated: 8/20/2008
'Created By: Chris Thompson
'Description: Library contains all keyword functions for the Frame object type
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
' Function: Frame_VerifyExists (stepNum, stepName, page, object, expected, args)
' Date Created: 08/20/2008
' Date Modifed: 08/20/2008
' Created By: Chris Thompson 
' Description:  VerifyExists keyword for the Frame type object
'***************************************************************

Function Frame_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	windowobj = getFields(3,page , "-")
	frameObj=getfields(2,page,"-")
	page = getFields(1,page , "-")
	
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

	Select Case UCase(args)

	Case "WINDOW"

	If InStr(desc(0), ":=") Then
		actual = Browser(browserObj).window(windowobj).Page(page).Frame(frameObj).Exist
	Else
		actual = Browser(browserObj).window(windowobj).Page(page).Frame(frameObj).Exist
	End If	
 	result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)    

	Case Else

  'Verify existence
	If InStr(desc(0), ":=") Then
		actual = Browser(browserObj).Page(page).Frame(frameObj).Exist
	Else
		actual = Browser(browserObj).Page(page).Frame(frameObj).Exist
	End If	
 	result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)    
		
	End Select

  

End Function
