
'***************************************************************
'File Name: Keyword_Dialog.vbs
'Date Ceated: 06/25/2007
'Created By: Chris Thompson & Lance Howard & Benjamin Wu
'Description: Library contains all keyword functions for the Dialog object type
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
' Function: Browser_VerifyExists (stepNum, stepName, page, object, expected, args)
' Date Created: 6/25/2007
' Date Modifed: 6/25/2007
' Created By: Chris Thompson & Lance Howard & Benjamin Wu
' Description:  VerifyExists keyword for the dialog type object
'***************************************************************

Function Dialog_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)


	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	WindowObj=getfieldsUpperNull(2,page,"-")
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

	'Branch on argument

	Select Case UCase(args)

	'No Argument 

		Case "DIALOG"
			actual = Dialog(object).Exist
			result =  VerificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )

		Case "ONERROR"

			 prop=getFields(0, expected, ":=")
			 expected=getFields(1, expected, ":=")
			expected=mid(expected,1)

				actual = Dialog(object).Exist
				result =  VerificationPoint(prop, actual, logObject, logDetails, browserObj, expectedResult )
				If actual = "True" Then
					Environment("RunComments") = expected 
					Environment ("RunStatus") = "Failed" 
					ExitAction 
				End If

			
		   
		Case "STATIC"

			If windowobj <>"" Then

				actual = Browser(browserObj ).window(windowobj).dialog(page).static(object).Exist
			
			elseif BrowserObj <> "" then

			 actual = Browser(browserObj ).dialog(page).static(object).Exist

			else

			actual =dialog(desc(0)).static(desc(1)).Exist

			End If


		  logDetails = logDetails & " Actual: " &actual  
     		result = VerificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )	
			  
		Case Else
				actual = Browser( browserObj).Dialog(page).Exist
				result =  VerificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )   
				 
	End Select
	
End Function


'*******************************************************************************************************
' Function: Dialog_VerifyProperty(stepNum, stepName, page, object, sValue, args)
' Date Created: 6/25/2007
' Date Modifed: 6/25/2007
' Created By: Chris Thompson & Lance Howard & Benjamin Wu
' Description:  Verify roperty keyword for the Dialog object type
'*******************************************************************************************************

Function Dialog_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	page = "Dialog"
	
	'Parse property and expected result

	prop=getFields(0, expected, ":=")
	expected=getFields(1, expected, ":=")
	expected=mid(expected,1)
	expected = ReplaceConstants(expected)

	'Parse object description
	
	desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")

	'Set up log results

	If (args = "") Then
		logDetails= "Expected:  " &expected &CHR(13)
		Else
		logDetails= "Expected: (" &args &")  " &expected &CHR(13)
	End If

	'Branch on argument

	Select Case UCase(args)

		Case "SECURITY"
			If  Browser(browserObj).Dialog("text:=Security Alert").Exist Then
				 Browser(browserObj).Dialog("text:=Security Alert").WinButton("text:=&Yes").Click
			End If 
			If  Browser(browserObj).Dialog("text:=Security Information").Exist Then
				 Browser(browserObj).Dialog("text:=Security Information").WinButton("text:=&Yes").Click
			End If 

			' Security Check for IE7			
			If Browser(browserObj).Page("title:=Certificate Error.*").Exist(2) Then
					Browser(browserObj).Page("title:=Certificate Error.*").Link("text:=Continue to this website.*.").Click
			End If
			
			actual = Browser(browserObj).Page(Page).GetROProperty(prop) 	  
			logDetails = logDetails & " Actual: " &Actual  
			result = VerificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult ) 
		 Case "STATIC"
			actual = Dialog(object).getROProperty(prop)
			result =  VerificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )
		Case "INSTRING"
			actual = Browser(browserObj ).Page(page).GetROproperty(prop)	  
			logDetails = logDetails & " Actual: " &actual  
			result = VerificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult ) 	

		'No Argument 
				
		Case Else
			actual = Browser(browserObj ).page(page).GetROproperty(prop)
			logDetails = logDetails & " Actual: " &actual  
     		result = VerificationPoint(expected, actual, logObject, logDetails , browserObj, expectedResult)
			   
	End Select
	
End Function

'***************************************************************
' Function: Dialog_Click (stepNum, stepName, page, object, expected, args)
' Date Created: 06/25/2006
' Date Modifed: 06/25/2006
' Created By: Chris Thompson & Benjamin Wu
' Description:  Click keyword for the Dialog type object
'***************************************************************

Function Dialog_Click (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	prop=getFields(0, expected, ":=")
	expected=getFields(1, expected, ":=")
	expected=mid(expected,1)
	expected = ReplaceConstants(expected)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
  WindowObj=getfieldsUpperNull(2,page,"-")
 page = getfieldsUpperNull(1,page , "-")

   if page = "" then
	 page= "Dialog"
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
		
	'Branch on argument
	
	Select Case UCase(args)

	'POPUP argument for dealing with when a popup is opened
	
		Case "POPUP"
			If InStr(desc(0), ":=") Then
				Browser( browserObj ).Dialog(page).Webbutton(desc(0), desc(1),desc(2)).Click
			Else
				Browser( browserObj ).Dialog(page).Webbutton(desc(0)).Click
			End If	
			actual = Browser(getFields(0,expected,"-")).Page(getFields(1,expected,"-")).Exist	 
			logDetails = logDetails & " Actual: " &actual  
			result = VerificationPoint(TRUE, actual, logObject, logDetails, browserObj, expectedResult)	
	
		Case "INSTRING"
			If InStr(desc(0), ":=") Then
				Browser(browserObj).Dialog(page).Winbutton(desc(0), desc(1),desc(2)).Click
			Else
				Browser(browserObj).Dialog(page).Winbutton(desc(0)).Click
			End If	
			Wait(5)
			actual = Browser(browserObj).Page(browserObj).GetROProperty(prop) 	  
			logDetails = logDetails & " Actual: " &actual  
			result = VerificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult ) 	

		 Case "DIALOG"
			If InStr(desc(0), ":=") Then
				If windowobj = "" and browserobj = "" Then
					Dialog ("text:=Windows Internet Explorer").WinButton(desc(0), desc(1),desc(2)).Click
				Else
				Dialog(page).WinButton(desc(0), desc(1),desc(2)).Click
				End If
			Else
				Dialog(page).WinButton(desc(0)).Click
			End If	
'			actual = Browser(getFields(0,expected,"-")).Page(getFields(1,expected,"-")).Exist 	  
'			logDetails = logDetails & " Actual: " &actual  
'			result = VerificationPoint(True, actual, logObject, logDetails, browserObj, expectedResult) 	

		Case "WINDOW"
			If InStr(desc(0), ":=") Then
				Browser(browserObj).Window(WindowObj).Dialog(page).WinButton(desc(0), desc(1), desc(2)).Click
			Else
				Browser(browserObj).Window(WindowObj).Dialog(page).WinButton(object).Click
			End If
'			actual = Browser(browserObj).Window(WindowObj).Exist
'			logDetails = logDetails & " Actual: " &actual  
'			result = VerificationPoint(True, actual, logObject, logDetails, browserObj, expectedResult) 	

		 Case "DOUBLE WINDOW"
			If InStr(desc(0), ":=") Then
				Browser(browserObj).Window(WindowObj).Window(WindowObj).Dialog(page).WinButton(desc(0), desc(1), desc(2)).Click
			Else
				Browser(browserObj).Window(WindowObj).Window(WindowObj).Dialog(page).WinButton(object).Click
			End If

		Case "IFEXISTS"
			If WindowObj <> "" Then
				If InStr(desc(0), ":=" )Then
					If Browser(browserObj).Window(WindowObj).Dialog(page).Exist then
						If Browser(browserObj).Window(WindowObj).Dialog(page).Winbutton(desc(0), desc(1),desc(2)).Exist Then
							Browser(browserObj).Window(WindowObj).Dialog(page).Winbutton(desc(0), desc(1),desc(2)).Click
						End If
					End If
				else
					If Browser(browserObj).Window(WindowObj).Dialog(page).Exist Then
						If Browser(browserObj).Window(WindowObj).Dialog(page).Winbutton(desc(0)).Exist Then
							Browser(browserObj).Window(WindowObj).Dialog(page).Winbutton(desc(0)).Click
						End If
					End If
				End If
			else
				If InStr(desc(0), ":=" )Then
					If Browser(browserObj).Dialog(page).Exist then
						If Browser(browserObj).Dialog(page).Winbutton(desc(0), desc(1),desc(2)).Exist  Then
							Browser(browserObj).Dialog(page).Winbutton(desc(0), desc(1),desc(2)).Click
						End If
					End If
				else
					If Browser(browserObj).Dialog(page).Exist Then
						If Browser(browserObj).Dialog(page).Winbutton(desc(0)).Exist  Then
							Browser(browserObj).Dialog(page).Winbutton(desc(0)).Click
						End If
					End If
				End If				
			End If
	'No Argument 
			
		Case Else
			If InStr(desc(0), ":=") Then
				Browser(browserObj).Page(page).Webbutton(desc(0), desc(1),desc(2)).Click
			Else
				Browser(browserObj).Page(page).Webbutton(desc(0)).Click
			End If	
		  
			   
	End Select

End Function	

'***************************************************************
' Function: WebEdit_TypeText (stepNum, stepName, page, object, sValue, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  TypeText keyword for the WebEdit type object
' Modifications: 03/15/07, BW, Added Timestamp arguement to handle Timestamp value in sValue
'***************************************************************

Function Dialog_TypeText (stepNum, stepName, expectedResult, page, object, sValue, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	page = "Dialog"
	
	'Parse property and expected result

	prop=getFields(0, sValue, ":=")
	sValue=getFields(1, sValue, ":=")
	sValue = replaceConstants(sValue)
	'sValue=mid(sValue,2)

	'Parse object description
	
	desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")

	'Set up log results

	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	If (args = "") Then
		logDetails= "Expected:  " &sValue &CHR(13)
		Else
		logDetails= "Expected: (" &args &")  " &sValue &CHR(13)
	End If

	'Branch on argument
	If object = "User Name" Then
		result = Browser(browserObj).Dialog(page).Exist(45)
	End If

 
	Select Case UCase(args)

		Case "NO VALIDATION"
			 If InStr(desc(0), ":=") Then
			   Browser(browserObj).Dialog(page).WinEdit(desc(0), desc(1),desc(2)).Set sValue
			Else
 			   Browser(browserObj).Dialog(page).WinEdit(desc(0)).Set sValue
			End If       

		Case "LOCAL"

			sValue = Environment(sValue)
			 If InStr(desc(0), ":=") Then
			   Browser(browserObj).Dialog(page).WinEdit(desc(0), desc(1),desc(2)).Set sValue
			   actual = Browser( browserObj).Dialog(page).WinEdit(desc(0), desc(1),desc(2)).GetROProperty("text")
			Else
				wait(1)
 			   Browser(browserObj).Dialog(page).WinEdit(desc(0)).Set sValue
			   actual = Browser( browserObj).Dialog(page).WinEdit(desc(0)).GetROProperty("text")
			End If      		   
			 ' result =  VerificationPoint(sValue, actual, logObject, logDetails, browserObj, expectedResult )
			

		Case  Else
			If InStr(desc(0), ":=") Then
			   Browser(browserObj).Dialog(page).WinEdit(desc(0), desc(1),desc(2)).Set sValue
			   actual = Browser( browserObj).Dialog(page).WinEdit(desc(0), desc(1),desc(2)).GetROProperty("text")
			Else
 			   Browser(browserObj).Dialog(page).WinEdit(desc(0)).Set sValue
			   actual = Browser( browserObj).Dialog(page).WinEdit(desc(0)).GetROProperty("text")
			End If      		   
			   result =  VerificationPoint(sValue, actual, logObject, logDetails , browserObj, expectedResult)
			   
	End Select


	
End Function
