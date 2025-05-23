
'***************************************************************
'File Name: Keyword_WebButton.vbs
'Date Ceated: 12/27/2006
'Created By: Chris Thompson & Steve Truong
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
' Date Modifed: 05/21/2021
' Created By: Chris Thompson
' Updated by : Sameen Hashmi - Included the IfExists condition to handle dynamic runtime pop-up
' Description:  Click keyword for the WebButton type object

'***************************************************************   

Function WinButton_Click (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	windowObj = getFields(0,page , "-")
    dialogobj = getFields(1,page , "-")

	If dialogobj = "" Then
		ident = "Window"
	
	Else
		ident = "Dialog"	
	End If

	'Parse out property and expected results

	prop=getFields(0, expected, ":=")
	expected=getFields(1, expected, ":=")
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

	'Click WebButton
	'Branch on argument

	Select Case ident

	Case "Window"

		Select Case UCase(args)

			Case "NO VALIDATION"

					If InStr(desc(0), ":=") <>0 Then
						Window(windowObj).WinButton(desc(0), desc(1),desc(2)).Click
					Else
						Window(windowObj).WinButton(desc(0)).Click
					End If
	
					result = verificationPoint(True, True, logObject, logDetails, windowObj, expectedResult)
					
					


			Case "WAIT"
				If InStr(desc(0), ":=") <>0 Then
					Window(windowObj).WinButton(desc(0), desc(1),desc(2)).Click
				Else
					Window(windowObj).WinButton(desc(0)).Click
				End If	
				actual = Window(windowObj).WaitProperty(prop, expected, 10000) 	  
						LogDetails = logDetails & " Actual: " &actual  
						result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)
				
			Case "IFEXISTS"
			If InStr(desc(0), ":=") <>0 Then
					If Window(windowObj).WinButton(desc(0), desc(1),desc(2)).Exist(10) Then
						Window(windowObj).WinButton(desc(0), desc(1),desc(2)).Click
						actual = Window(windowObj).GetROProperty(prop) 
						LogDetails = logDetails & " Actual: " &actual  
						result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)
					End If
				Else
					If Window(windowObj).WinButton(desc(0)).Exist(10) Then
						Window(windowObj).WinButton(desc(0)).Click
						actual = Window(windowObj).GetROProperty(prop) 
						LogDetails = logDetails & " Actual: " &actual  
						result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)
					End If	
				End If				

			Case Else

				If InStr(desc(0), ":=") <>0 Then
					Window(windowObj).WinButton(desc(0), desc(1),desc(2)).Click
				Else
					Window(windowObj).WinButton(desc(0)).Click
				End If 	  
					 actual = Window(windowObj).GetROProperty(prop)

				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)

			End Select
				

		Case "Dialog"
			
			Select Case UCase(args)

			Case "NO VALIDATION"

					If InStr(desc(0), ":=") <>0 Then
						Window(windowObj).Dialog(dialogobj).WinButton(desc(0), desc(1),desc(2)).Click
					Else
						Window(windowObj).Dialog(dialogobj).WinButton(desc(0)).Click
					End If
	
					result = verificationPoint(True, True, logObject, logDetails, windowObj, expectedResult)
					
					


			Case "WAIT"
				If InStr(desc(0), ":=") <>0 Then
					Window(windowObj).Dialog(dialogobj).WinButton(desc(0), desc(1),desc(2)).Click
				Else
					Window(windowObj).Dialog(dialogobj).WinButton(desc(0)).Click
				End If	
				actual = Window(windowObj).WaitProperty(prop, expected, 10000) 	  	  
						LogDetails = logDetails & " Actual: " &actual  
						result = verificationPointInstr(expected, actual, logObject, logDetails, windowObj, expectedResult)
				
			Case "IFEXISTS"
			If InStr(desc(0), ":=") <>0 Then
					If Window(windowObj).Dialog(dialogobj).WinButton(desc(0), desc(1),desc(2)).Exist(10) Then
						Window(windowObj).Dialog(dialogobj).WinButton(desc(0), desc(1),desc(2)).Click
						actual = Window(windowObj).GetROProperty(prop) 
						LogDetails = logDetails & " Actual: " &actual  
						result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)
					End If
				Else
					If Window(windowObj).Dialog(dialogobj).WinButton(desc(0)).Exist(10) Then
						Window(windowObj).Dialog(dialogobj).WinButton(desc(0)).Click
						actual = Window(windowObj).GetROProperty(prop) 
						LogDetails = logDetails & " Actual: " &actual  
						result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)
					End If	
				End If				

			Case Else

				If InStr(desc(0), ":=") <>0 Then
					Window(windowObj).Dialog(dialogobj).WinButton(desc(0), desc(1),desc(2)).Click
				Else
					Window(windowObj).Dialog(dialogobj).WinButton(desc(0)).Click
				End If 	  
					 actual = Window(windowObj).GetROProperty(prop)

				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)

			End Select
							


		
  		   
	End Select

End Function


'

