
'***************************************************************
'File Name: Keyword_WinRadioButton.vbs
'Date Ceated: 07/19/2023
'Created By: Keerthi Singh
'Description: Library contains all keyword functions for the WinRadioButton object type
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
' Function: WinRadioButton_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 07/19/2023
' Created By: Keerthi Singh
' Description: VerifyExists  keyword for the WinRadioButton type object

'***************************************************************   

Function WinRadioButton_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	windowObj = getFields(0,page , "-")
    dialogObj = getFieldsUpperNull(1,page , "-")
    winObj    = getFieldsUpperNull(2,page , "-")

	If dialogObj = "" and WinObj = ""  Then
		ident = "Window"
	ElseIf winObj = "" and dialogObj <> "" Then 
		ident = "Dialog"
	Else	
		ident = "Double_Window"	
		windowObj1 = getFields(0,page , "-")
		windowObj2 = getFields(1,page , "-")
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

	'VerifyExists RadioButton
	'Branch on argument

	Select Case ident
	
		Case "Window"
			
			Select Case UCase(args)
			
				Case Else
					
					If InStr(desc(0), ":=") <>0 Then
						actual = Window(windowObj).WinRadioButton(desc(0), desc(1),desc(2)).Exist(20)
					Else
						actual = Window(windowObj).WinRadioButton(desc(0)).Exist(20)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)
					
			End Select
	
		Case "Dialog"
		
			Select Case UCase(args)
			
				Case Else
					
					If InStr(desc(0), ":=") <>0 Then
						actual = Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0), desc(1),desc(2)).Exist(20)
					Else
						actual = Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0)).Exist(20)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)
					
			End Select
					
		Case "Double_Window"
		
			Select Case UCase(args)
			
				Case Else
					
					If InStr(desc(0), ":=") <>0 Then
						actual = Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0), desc(1),desc(2)).Exist(20)
					Else
						actual = Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0)).Exist(20)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(expected, actual, logObject, logDetails, windowObj1, expectedResult)
					
			End Select
						 
	End Select

End Function


'***************************************************************
' Function: WinRadioButton_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 07/20/2023
' Created By: Keerthi Singh
' Description: VerifyProperty  keyword for the WinRadioButton type object

'***************************************************************   

Function WinRadioButton_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	windowObj = getFields(0,page , "-")
    dialogObj = getFieldsUpperNull(1,page , "-")
    winObj    = getFieldsUpperNull(2,page , "-")

	If dialogObj = "" and WinObj = ""  Then
		ident = "Window"
	ElseIf winObj = "" and dialogObj <> "" Then 
		ident = "Dialog"
	Else	
		ident = "Double_Window"	
		windowObj1 = getFields(0,page , "-")
		windowObj2 = getFields(1,page , "-")
	End If

	'Parse out property and expected results

	prop=getFields(0, expected, ":=")
	expected=getFields(1, expected, ":=")
	expected = replaceConstants(expected)
	
	If expected = "Environment('Datestamp')" Then
		expected = environment("Datestamp")
	Elseif instr (expected,"Environment('Datestamp')<") Then
		expected1 = getfields(2,expected,"<")
		expected1 = mid(expected1,1,len(expected1)-1)
		Call Utility_GenDatestamp(stepNum, stepName,expectedResult, page, object, expected1, "Run Time")  
		expected = environment("Datestamp")
	Elseif expected = "Environment('sData')" Then
		expected = Environment("sData")
	Elseif expected = "Environment('Timestamp')" Then
		expected = Environment("Timestamp")
	ElseIf expected = "TestVariable" Then
		expected = Environment("TestVariable")
	ElseIf Left(expected,4) = "ENV_" Then
		expected = Environment(Mid(expected,5))
	
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

	'VerifyProperty RadioButton
	'Branch on argument

	Select Case ident
	
		Case "Window"
			
			Select Case UCase(args)

				Case "INSTRING"
				
					If InStr(desc(0), ":=") <>0 Then
						actual = Window(windowObj).WinRadioButton(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						actual = Window(windowObj).WinRadioButton(desc(0)).GetROProperty(prop)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPointInstr(expected, actual, logObject, logDetails, windowObj, expectedResult)
					
						
				Case "WAIT"
				
			   		If InStr(desc(0), ":=") <> 0 Then
						actual = Window(windowObj).WinRadioButton(desc(0), desc(1),desc(2)).WaitProperty(prop, expected, 10000)
					Else
						actual = Window(windowObj).WinRadioButton(desc(0)).WaitProperty(prop, expected, 10000)
					End If		
					
					logDetails = logDetails & " Actual: " &actual  	
					result = verificationPoint(True, actual, logObject, logDetails, windowObj, expectedResult)
							
			
				Case Else	
				
					If InStr(desc(0), ":=") <>0 Then
						actual = Window(windowObj).WinRadioButton(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						actual = Window(windowObj).WinRadioButton(desc(0)).GetROProperty(prop)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)
				
			End Select
	
		Case "Dialog"
		
			Select Case UCase(args)

				Case "INSTRING"
				
					If InStr(desc(0), ":=") <>0 Then
						actual = Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						actual = Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0)).GetROProperty(prop)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPointInstr(expected, actual, logObject, logDetails, windowObj, expectedResult)
					
				Case "WAIT"
				
			   		If InStr(desc(0), ":=") <> 0 Then
						actual = Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0), desc(1),desc(2)).WaitProperty(prop, expected, 10000)
					Else
						actual = Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0)).WaitProperty(prop, expected, 10000)
					End If		
					
					logDetails = logDetails & " Actual: " &actual  	
					result = verificationPoint(True, actual, logObject, logDetails, windowObj, expectedResult)
			
				Case Else	
				
					If InStr(desc(0), ":=") <>0 Then
						actual = Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						actual = Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0)).GetROProperty(prop)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)
				
			End Select
			
		Case "Double_Window"
		
			Select Case UCase(args)
			
				Case "INSTRING"
				
					If InStr(desc(0), ":=") <>0 Then
						actual = Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						actual = Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0)).GetROProperty(prop)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPointInstr(expected, actual, logObject, logDetails, windowObj1, expectedResult)
			
				Case "WAIT"
				
			   		If InStr(desc(0), ":=") <> 0 Then
						actual = Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0), desc(1),desc(2)).WaitProperty(prop, expected, 10000)
					Else
						actual = Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0)).WaitProperty(prop, expected, 10000)
					End If		
					
					logDetails = logDetails & " Actual: " &actual  	
					result = verificationPoint(True, actual, logObject, logDetails, windowObj1, expectedResult)
				
				Case Else
					
					If InStr(desc(0), ":=") <>0 Then
						actual = Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						actual = Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0)).GetROProperty(prop)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(expected, actual, logObject, logDetails, windowObj1, expectedResult)
					
			End Select
		
	End Select

End Function


'***************************************************************
' Function: WinRadioButton_Set (stepNum, stepName,expectedResult, page, object, expected, args)
' Date Created: 07/24/2023
' Created By: Keerthi Singh
' Description: Set  keyword for the WinRadioButton type object

'***************************************************************   

Function WinRadioButton_Set(stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	windowObj = getFields(0,page , "-")
    dialogObj = getFieldsUpperNull(1,page , "-")
    winObj = getFieldsUpperNull(2,page , "-")

	If dialogObj = "" and WinObj = ""  Then
		ident = "Window"
	ElseIf winObj = "" and dialogObj <> "" Then 
		ident = "Dialog"
	Else	
		ident = "Double_Window"	
		windowObj1 = getFields(0,page , "-")
		windowObj2 = getFields(1,page , "-")
	End If

	'Parse out property and expected results

	'prop=getFields(0, expected, ":=")
	'expected=getFields(1, expected, ":=")
	'expected = replaceConstants(expected)
	
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

	'Set RadioButton
	'Branch on argument

	Select Case ident
				
		Case "Window"
			
			Select Case UCase(args)
									
				Case "NO VALIDATION"
				
			   		If InStr(desc(0), ":=") <> 0 Then
						 Window(windowObj).WinRadioButton(desc(0), desc(1), desc(2)).set 
					Else
						 Window(windowObj).WinRadioButton(desc(0)).set 
					End If		
					result = verificationPoint(True, True, logObject, logDetails, windowObj, expectedResult)
					
				Case "IFEXISTS"
				
			   		If InStr(desc(0), ":=") <> 0 Then
			   			If Window(windowObj).WinRadioButton(desc(0), desc(1),desc(2)).Exist(10) Then
			   				Window(windowObj).WinRadioButton(desc(0), desc(1),desc(2)).Set 
			   				actual = Window(windowObj).WinRadioButton(desc(0), desc(1),desc(2)).GetROProperty("checked")
			   			End If
			   			
			   		Else
			   			If Window(windowObj).WinRadioButton(desc(0)).Exist(10) Then
			   				Window(windowObj).WinRadioButton(desc(0)).set 
			   				actual = Window(windowObj).WinRadioButton(desc(0)).GetROProperty("checked")
			   			End If			   	
					End If	
					logDetails = logDetails & " Actual: " &actual  					
					result = verificationPoint("ON", actual, logObject, logDetails, windowObj, expectedResult)
					
				Case Else	
				
					If InStr(desc(0), ":=") <>0 Then
						Window(windowObj).WinRadioButton(desc(0), desc(1),desc(2)).set 
						actual = Window(windowObj).WinRadioButton(desc(0), desc(1),desc(2)).GetROProperty("checked")
					Else
						Window(windowObj).WinRadioButton(desc(0)).set 
						actual = Window(windowObj).WinRadioButton(desc(0)).GetROProperty("checked")
					End If 	  
									
					logDetails = logDetails & " Actual: " &actual  	
					result = verificationPoint("ON", actual, logObject, logDetails, windowObj, expectedResult)	
					 							
			End Select
	
		Case "Dialog"
			
			Select Case UCase(args)
												
				Case "NO VALIDATION"
				
			   		If InStr(desc(0), ":=") <> 0 Then
						Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0), desc(1),desc(2)).set 
					Else
						Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0)).set 
					End If	
 					result = verificationPoint(True, True, logObject, logDetails, windowObj, expectedResult)
					
				Case "IFEXISTS"
				
			   		If InStr(desc(0), ":=") <> 0 Then
			   			If Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0), desc(1),desc(2)).Exist(10) Then
			   				Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0), desc(1),desc(2)).set 
			   				actual = Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0), desc(1),desc(2)).GetROProperty("checked")
			   			End If
			   			
			   		Else
			   			If Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0)).Exist(10) Then
			   				Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0)).set 
			   				actual = Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0)).GetROProperty("checked")
			   			End If			   	
					End If	
					logDetails = logDetails & " Actual: " &actual 					
					result = verificationPoint("ON", actual, logObject, logDetails, windowObj, expectedResult)	
					
				Case Else	
				
					If InStr(desc(0), ":=") <>0 Then
						Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0), desc(1),desc(2)).set 
						actual = Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0), desc(1),desc(2)).GetROProperty("checked")
					Else
						Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0)).set 
						actual = Window(windowObj).Dialog(dialogObj).WinRadioButton(desc(0)).GetROProperty("checked")
					End If 	 				
					logDetails = logDetails & " Actual: " &actual  	
					result = verificationPoint("ON", actual, logObject, logDetails, windowObj, expectedResult)					
					 							
			End Select
			
	Case "Double_Window"
			
			Select Case UCase(args)
												
				Case "NO VALIDATION"
				
			   		If InStr(desc(0), ":=") <> 0 Then
						 Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0), desc(1),desc(2)).set 
					Else
						 Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0)).set 
					End If	
					logDetails = logDetails & " Actual: " &actual  					
					result = verificationPoint(True, True, logObject, logDetails, windowObj1, expectedResult)
					
				Case "IFEXISTS"
				
			   		If InStr(desc(0), ":=") <> 0 Then
			   			If Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0), desc(1),desc(2)).Exist(10) Then
			   				Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0), desc(1),desc(2)).set 	
			   				actual = Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0), desc(1),desc(2)).GetROProperty("checked")
			   			End If
			   			
			   		Else
			   			If Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0)).Exist(10) Then
			   				Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0)).set 
			   				actual = Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0)).GetROProperty("checked")
			   			End If			   	
					End If
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint("ON", actual, logObject, logDetails, windowObj1, expectedResult)					
												
				Case Else	
				
					If InStr(desc(0), ":=") <>0 Then
						Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0), desc(1),desc(2)).set
						actual = Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0), desc(1),desc(2)).GetROProperty("checked")
					Else
						Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0)).Set
						actual = Window(windowObj1).Window(windowObj2).WinObject(winObj).WinRadioButton(desc(0)).GetROProperty("checked")
					End If 	 
					
					logDetails = logDetails & " Actual: " &actual  	
					result = verificationPoint("ON", actual, logObject, logDetails, windowObj1, expectedResult)	

		End Select
					 							 
	End Select

End Function


