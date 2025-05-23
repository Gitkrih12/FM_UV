
'***************************************************************
'File Name: Keyword_DialogWinButton.vbs
'Date Ceated: 12/27/2006
'Created By: Chris Thompson & Lance Howard
'Description: Library contains all keyword functions for the WebButton object type
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
' Function: WebButton_Click (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  Click keyword for the Image type object
'***************************************************************   

Function DialogWinButton_Click (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = AT_getFields(0,page , "-")
    page = AT_getFields(1,page , "-")

	'Parse out property and expected results

	prop=AT_getFields(0, expected, ":=")
	expected=AT_getFields(1, expected, ":=")
	expected=mid(expected,2)
	expected = AT_ReplaceConstants(expected)

	 'Parse object description

    desc(0) = AT_getFields(0, object, "~")
	desc(1) = AT_getFields(1, object, "~")
	desc(2) = AT_getFields(2, object, "~")

	'Set up log results

    logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	If (args = "") Then
		logDetails= "Expected:  " &expected &CHR(13)
		Else
		logDetails= "Expected: (" &args &")  " &expected &CHR(13)
	End If

	'Click WebButton

   

	'Branch on argument

	Select Case UCase(args)

		'Security argument to handle security dialog popup
			
		Case "SECURITY"
			If InStr(desc(0), ":=") Then
				Browser(browserObj).Dialog(page).WinButton(desc(0), desc(1),desc(2)).Click
				If  Browser(browserObj).Dialog("text:=Security Alert").Exist Then
					Browser(browserObj).Dialog("text:=Security Alert").WinButton("text:=&Yes").Click
				End If
				If  Browser(browserObj).Dialog("text:=Security Information").Exist Then
					Browser(browserObj).Dialog("text:=Security Information").WinButton("text:=&Yes").Click
				End If

			Else
 				Browser(browserObj).Dialog(page).WinButton(desc(0)).Click
				If  Browser(browserObj).Dialog("text:=Security Alert").Exist Then
					Browser(browserObj).Dialog("text:=Security Alert").WinButton("text:=&Yes").Click
				End If
				If  Browser(browserObj).Dialog("text:=Security Information").Exist Then
					Browser(browserObj).Dialog("text:=Security Information").WinButton("text:=&Yes").Click
				End If
			End If	   			 

'		Case "INSTRING"
'			If InStr(desc(0), ":=") Then
'				Browser(browserObj).Page(page).WebButton(desc(0), desc(1),desc(2)).Click
'			Else
'				Browser(browserObj).Page(page).WebButton(desc(0)).Click
'			End If
'			Wait(5)
'			actual = Browser(browserObj).Page("General").GetROProperty(prop) 	  
'			logDetails = logDetails & " Actual: " &actual  
'			result = AT_VerificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult) 	

'		Case "POPUP"
'			If InStr(desc(0), ":=") Then
'				Browser( browserObj ).Page(page).WebButton(desc(0), desc(1),desc(2)).Click
'			Else
'				Browser( browserObj ).Page(page).WebButton(desc(0), desc(1),desc(2)).Click
'			End If	
'			actual = Browser(AT_getFields(0,expected,"-")).Page(AT_getFields(1,expected,"-")).Exist	 
'			logDetails = logDetails & " Actual: " &actual  
'			result = AT_VerificationPoint(TRUE, actual, logObject, logDetails, browserObj, expectedResult)		

	'No Argument 

		Case Else
			If InStr(desc(0), ":=") Then
				Browser(browserObj).Dialog(page).WinButton(desc(0), desc(1),desc(2)).Click
			Else
				Browser(browserObj).Dialog(page).WebButton(desc(0)).Click
			End If 	  
		'	 actual = Browser(browserObj).Dialog(page).GetROproperty(prop) 
	        'result =  AT_VerificationPoint(expected, actual, logObject, logDetails , browserObj, expectedResult) 
			  
	End Select

End Function


'***************************************************************
' Function: WebButton_VerifyExists (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  VerifyExists keyword for the Link type object
' Modification: 04/03/07, BW, Changed the method of finding the actual to use browserObj instead of MAIN
'***************************************************************
Function DialogWinButton_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = AT_getFields(0,page , "-")
	page = AT_getFields(1,page , "-")

	'Parse object description
	
	desc(0) = AT_getFields(0, object, "~")
	desc(1) = AT_getFields(1, object, "~")
	desc(2) = AT_getFields(2, object, "~")

	'Set up log results
	
	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	logDetails= "Expected:  " &expected &CHR(13)

	If InStr(desc(0), ":=") Then
		actual = Browser(browserObj).Dialog(page).WinButton(desc(0), desc(1),desc(2)).Exist
	Else
		actual = Browser(browserObj).Dialog(page).WinButton(desc(0)).Exist
	End If	
	result =  AT_VerificationPoint(expected, actual, logObject, logDetails , browserObj, expectedResult)  
	
End Function
