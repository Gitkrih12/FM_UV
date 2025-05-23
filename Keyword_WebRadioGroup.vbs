   
'***************************************************************
'File Name: Keyword_WebRadioGroup.vbs
'Date Ceated: 12/27/2006
'Created By: Chris Thompson & Steve Truong
'Description: Library contains all keyword functions for the WebRadioGroup object type
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
' Function: WebRadioGroup_Select (stepNum, stepName, page, object, sValue, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  Select keyword for the WebRadioGroup type object
'***************************************************************

Function WebRadioGroup_Select (stepNum, stepName, expectedResult, page, object, sValue, args)

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

	prop=getFields(0, sValue, ":=")
	sValue=getFields(1, sValue, ":=")
	If Instr(sValue,";") <> 0 Then
		sValue = Mid(sValue,1,Len(sValue)-1)
	ElseIf Instr(sValue,"TestVariable") <> 0 Then
		sValue = Replace(sValue,"TestVariable",Environment("TestVariable"))
		If Instr(sValue,"#") <> 0 Then
			sValue = "#"&Cstr(CInt(Mid(sValue,2))-1)
		End If
	ElseIf Instr(sValue,"RowIndex") <> 0 Then
		sValue = Replace(sValue,"RowIndex",Environment("RowIndex"))
		If Instr(sValue,"#") <> 0 Then
			sValue = "#"&Cstr(CInt(Mid(sValue,2))-1)
		End If
	End If

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

	Select Case ident

	Case "None"

		Select Case UCase(args)

			Case "DIALOG"

				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).WebRadioGroup(desc(0), desc(1),desc(2)).Select sValue
				Else
				Browser(browserObj).Page(page).WebRadioGroup(desc(0)).Select sValue
				End If	
				result =  verificationPoint(sValue, actual, logObject, logDetails, browserObj, expectedResult)   

			Case Else

				 If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).WebRadioGroup(desc(0), desc(1),desc(2)).Select sValue
					actual = Browser(browserObj).Page(page).WebRadioGroup(desc(0), desc(1),desc(2)).GetROProperty("value")
				Else
					Browser(browserObj).Page(page).WebRadioGroup(desc(0)).Select sValue
					actual = Browser(browserObj).Page(page).WebRadioGroup(desc(0)).GetROProperty("value")
				End If	
				result =  verificationPoint(sValue, actual, logObject, logDetails, browserObj, expectedResult)   

		End Select

	Case "Frame"

		Select Case UCase(args)

			 Case "DIALOG" 'handles when selecting WebRadioGroup causes dialog
	  
				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0), desc(1),desc(2)).Select sValue
				Else
					Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0)).Select sValue
				End If
				result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)

			Case "NO VALIDATION"

				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0), desc(1),desc(2)).Select sValue
				Else
					Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0)).Select sValue
				End If
				result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)
				
			Case "IFEXISTS"
				
				If InStr(desc(0), ":=") Then
					If Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0), desc(1),desc(2)).Exist(10) Then	
						Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0), desc(1),desc(2)).Select sValue
					End If
				Else
					If Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0)).Exist(10) Then	
						Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0)).Select sValue
					End If 				
				End If
				result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)
					  
			Case Else

				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0), desc(1),desc(2)).Select sValue
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0), desc(1),desc(2)).GetROProperty("value")
				Else
					Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0)).Select sValue
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0)).GetROProperty("value")
				End If	
				If instr(svalue,"#") = 0 and instr(svalue,"+") = 0 Then
					result =  verificationPoint(sValue, actual, logObject, logDetails, browserObj, expectedResult)
				Else
					result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)			
				End If  

		End Select

	Case "Window"

		Select Case UCase(args)

			Case Else

				If InStr(desc(0), ":=") Then
					Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebRadioGroup(desc(0), desc(1),desc(2)).Select sValue
					actual = Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebRadioGroup(desc(0), desc(1),desc(2)).GetROProperty("value")
				Else
					Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebRadioGroup(desc(0)).Select sValue
					actual = Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebRadioGroup(desc(0)).GetROProperty("value")
				End If	
				result =  verificationPoint(sValue, actual, logObject, logDetails, browserObj, expectedResult)   

		End Select	
		
  End Select
	
End Function



'***************************************************************
' Function: WebRadioGroup_VerifyExists (stepNum, stepName, page, object, expected, args)
' Date Created: 1/25/2006
' Date Modifed: 1/25/2006
' Created By: Chris Thompson & Steve Truong
' Description:  VerifyExists keyword for the WebRadioGroup type object
'***************************************************************

Function WebRadioGroup_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

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

	Select Case ident

		Case "None"

			If InStr(desc(0), ":=") Then
				actual = Browser(browserObj).Page(page).WebRadioGroup(desc(0), desc(1), desc(2)).Exist
			Else
				actual = Browser(browserObj).Page(page).WebRadioGroup(desc(0)).Exist
			End if

		Case "Frame"

			If InStr(desc(0), ":=") Then
				actual = Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0), desc(1), desc(2)).Exist
			Else
				actual = Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0)).Exist
			End If

	End Select
			
 	result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)    

End Function


'***************************************************************
' Function: WebRadioGroup_VerifyProperty (stepNum, stepName, page, object, expected, args)
' Date Created: 1/22/2007
' Date Modifed: 1/22/2007
' Created By: Chris Thompson & Steve Truong
' Description:  Verify property keword for the WebRadioGroup type object
'***************************************************************

Function WebRadioGroup_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

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

    Select Case ident

	Case "None"

		Select Case UCase(args)

			Case "INSTRING"

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).WebRadioGroup(desc(0), desc(1),desc(2)).GetROProperty(prop) 
				Else
					actual = Browser(browserObj).Page(page).WebRadioGroup(desc(0)).GetROProperty(prop)
				End If    
				    
				logDetails = logDetails & " Actual: " &actual  
				Result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult )

			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser( browserObj).Page(page).WebRadioGroup(desc(0), desc(1),desc(2)).GetROproperty(prop)
				Else
					actual = Browser( browserObj).Page(page).WebRadioGroup(desc(0)).GetROproperty(prop)
				End If   
				  		    	  
				logDetails = logDetails & " Actual: " &actual  
				Result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult )

			End Select

	Case "Frame"

		Select Case UCase(args)
		
			Case "INSTRING"

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0), desc(1),desc(2)).GetROProperty(prop) 
				Else
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0)).GetROProperty(prop)
				End If    
				    
				logDetails = logDetails & " Actual: " &actual  
				Result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult )
				
			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0), desc(1),desc(2)).GetROproperty(prop)
				Else
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0)).GetROproperty(prop)
				End If   
				 
				logDetails = logDetails & " Actual: " &actual  
				Result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult )

		End Select

	Case "Window"

		Select Case UCase(args)

			Case Else

				If Instr(desc(0), ":=") Then
					actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0), desc(1), desc(2)).GetROProperty(prop)
				Else
					actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebRadioGroup(desc(0)).GetROProperty(prop)
				End If
				
				logDetails = logDetails & " Actual: " &actual  
				Result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult )

		End Select	
	
	End Select
	
End Function
