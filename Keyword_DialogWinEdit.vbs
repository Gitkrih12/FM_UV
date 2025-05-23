

'***************************************************************
'File Name: Keyword_WebEdit.vbs
'Date Ceated: 12/27/2006
'Created By: Chris Thompson & Lance Howard
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
' Function: WebEdit_TypeText (stepNum, stepName, page, object, sValue, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  TypeText keyword for the WebEdit type object
' Modifications: 03/15/07, BW, Added Timestamp arguement to handle Timestamp value in sValue
'***************************************************************

Function DialogWinEdit_TypeText (stepNum, stepName, expectedResult, page, object, sValue, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = AT_getFields(0,page , "-")
	page = AT_getFields(1,page , "-")
	
	'Parse property and expected result

	prop=AT_getFields(0, sValue, ":=")
	sValue=AT_getFields(1, sValue, ":=")
	sValue=mid(sValue,2)

	'Parse object description
	
	desc(0) = AT_getFields(0, object, "~")
	desc(1) = AT_getFields(1, object, "~")
	desc(2) = AT_getFields(2, object, "~")

	'Set up log results

	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	If (args = "") Then
		logDetails= "Expected:  " &sValue &CHR(13)
		Else
		logDetails= "Expected: (" &args &")  " &sValue &CHR(13)
	End If

	'Branch on argument
 
	Select Case UCase(args)

		'Timestamp - handles a timestamp variable in expected

		Case  Else
			If InStr(desc(0), ":=") Then
			   Browser(browserObj).Dialog(page).WinEdit(desc(0), desc(1),desc(2)).Set sValue
			   actual = Browser( browserObj).Dialog(page).WinEdit(desc(0), desc(1),desc(2)).GetROProperty("text")
			Else
 			   Browser(browserObj).Dialog(page).WinEdit(desc(0)).Set sValue
			   actual = Browser( browserObj).Dialog(page).WinEdit(desc(0)).GetROProperty("value")
			End If      		   
			   result =  AT_VerificationPoint(sValue, actual, logObject, logDetails, browserObj, expectedResult )
			   
	End Select


	
End Function


'***************************************************************
' Function: WebEdit_VerifyProperty (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  Verify Property keyword for the WebEdit type object
' Modification: 03/30/07, BW, Added Timestamp arguement to handle verifying timestamp value
'***************************************************************

Function WebEdit_DialogVerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = AT_getFields(0,page , "-")
	page = AT_getFields(1,page , "-")
	
	'Parse property and expected result

	prop=AT_getFields(0, expected, ":=")
	expected=AT_getFields(1, expected, ":=")
	expected=mid(expected,2)
    expected=AT_ReplaceConstants(expected)

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

	'Branch on argument
 
	Select Case UCase(args)

		'Timestamp - handles a timestamp variable in expected
		

   'No Argument    

		Case Else
			If InStr(desc(0), ":=") Then
			   actual = Browser( browserObj).Dialog(page).WinEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
			Else
			   actual = Browser( browserObj).Dialog(page).WinEdit(desc(0)).GetROproperty(prop)
			End If
			   	  
			   logDetails = logDetails & " Actual: " &actual  
			   result = AT_VerificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )
			   
	End Select
	
End Function
