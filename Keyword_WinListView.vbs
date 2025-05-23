
'***************************************************************
'File Name: Keyword_WinListView.vbs
'Date Ceated: 08/02/2023
'Created By: Keerthi Singh
'Description: Library contains all keyword functions for the WinListView object type
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
' Function: WinListView_VerifyExists (stepNum, stepName, page, object, expected, args)
' Date Created: 08/02/2023
' Created By: Keerthi Singh
' Description: VerifyExists  keyword for the WinListView type object

'***************************************************************   

Function WinListView_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	windowObj = getFields(0,page , "-")
    dialogObj = getFieldsUpperNull(1,page , "-")

	If dialogObj = "" Then
		ident = "Window"
	Else
		ident = "Dialog"
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
						actual = Window(windowObj).WinListView(desc(0), desc(1),desc(2)).Exist(20)
					Else
						actual = Window(windowObj).WinListView(desc(0)).Exist(20)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)
					
			End Select
	
		Case "Dialog"
		
			Select Case UCase(args)
			
				Case "DOUBLE WINDOW"
				
					If InStr(desc(0), ":=") <>0 Then
						actual = Window(windowObj).Window(dialogObj).WinListView(desc(0), desc(1),desc(2)).Exist(20)
					Else
						actual = Window(windowObj).Window(dialogObj).WinListView(desc(0)).Exist(20)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)
			
				Case Else
					
					If InStr(desc(0), ":=") <>0 Then
						actual = Window(windowObj).Dialog(dialogObj).WinListView(desc(0), desc(1),desc(2)).Exist(20)
					Else
						actual = Window(windowObj).Dialog(dialogObj).WinListView(desc(0)).Exist(20)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)
					
			End Select
						 
	End Select

End Function


'***************************************************************
' Function: WinListView_VerifyProperty (stepNum, stepName, page, object, expected, args)
' Date Created: 08/04/2023
' Created By: Keerthi Singh
' Description: VerifyProperty  keyword for the WinListView type object

'***************************************************************   

Function WinListView_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	windowObj = getFields(0,page , "-")
    dialogObj = getFieldsUpperNull(1,page , "-")

	If dialogObj = "" Then
		ident = "Window"
	Else
		ident = "Dialog"
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
						actual = Window(windowObj).WinListView(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						actual = Window(windowObj).WinListView(desc(0)).GetROProperty(prop)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPointInstr(expected, actual, logObject, logDetails, windowObj, expectedResult)
					
						
				Case "WAIT"
				
			   		If InStr(desc(0), ":=") <> 0 Then
						actual = Window(windowObj).WinListView(desc(0), desc(1),desc(2)).WaitProperty(prop, expected, 10000)
					Else
						actual = Window(windowObj).WinListView(desc(0)).WaitProperty(prop, expected, 10000)
					End If		
					
					logDetails = logDetails & " Actual: " &actual  	
					result = verificationPoint(True, actual, logObject, logDetails, windowObj, expectedResult)
							
			
				Case Else	
				
					If InStr(desc(0), ":=") <>0 Then
						actual = Window(windowObj).WinListView(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						actual = Window(windowObj).WinListView(desc(0)).GetROProperty(prop)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)
				
			End Select
	
		Case "Dialog"
		
			Select Case UCase(args)
				
				Case "DOUBLE WINDOW"
				
					If InStr(desc(0), ":=") <>0 Then
						actual = Window(windowObj).Window(dialogObj).WinListView(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						actual = Window(windowObj).Window(dialogObj).WinListView(desc(0)).GetROProperty(prop)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)

				Case "INSTRING"
				
					If InStr(desc(0), ":=") <>0 Then
						actual = Window(windowObj).Dialog(dialogObj).WinListView(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						actual = Window(windowObj).Dialog(dialogObj).WinListView(desc(0)).GetROProperty(prop)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPointInstr(expected, actual, logObject, logDetails, windowObj, expectedResult)
					
				Case "WAIT"
				
			   		If InStr(desc(0), ":=") <> 0 Then
						actual = Window(windowObj).Dialog(dialogObj).WinListView(desc(0), desc(1),desc(2)).WaitProperty(prop, expected, 10000)
					Else
						actual = Window(windowObj).Dialog(dialogObj).WinListView(desc(0)).WaitProperty(prop, expected, 10000)
					End If		
					
					logDetails = logDetails & " Actual: " &actual  	
					result = verificationPoint(True, actual, logObject, logDetails, windowObj, expectedResult)
			
				Case Else	
				
					If InStr(desc(0), ":=") <>0 Then
						actual = Window(windowObj).Dialog(dialogObj).WinListView(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						actual = Window(windowObj).Dialog(dialogObj).WinListView(desc(0)).GetROProperty(prop)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)
				
			End Select
		
	End Select

End Function


'***************************************************************
' Function: WinListView_Select (stepNum, stepName, page, object, expected, args)
' Date Created: 08/07/2023
' Created By: Keerthi Singh
' Description: Select  keyword for the WinListView type object

'***************************************************************   

Function WinListView_Select (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	windowObj = getFields(0,page , "-")
    dialogObj = getFieldsUpperNull(1,page , "-")

	If dialogObj = "" Then
		ident = "Window"
	Else
		ident = "Dialog"
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

	'Set RadioButton
	'Branch on argument

	Select Case ident
				
		Case "Window"
			
			Select Case UCase(args)
									
				Case "NO VALIDATION"
				
			   		If InStr(desc(0), ":=") <> 0 Then
						 Window(windowObj).WinListView(desc(0), desc(1), desc(2)).Select expected 
					Else
						 Window(windowObj).WinListView(desc(0)).Select expected 
					End If		
					result = verificationPoint(True, True, logObject, logDetails, windowObj, expectedResult)
					
				Case "IFEXISTS"
				
			   		If InStr(desc(0), ":=") <> 0 Then
			   			If Window(windowObj).WinListView(desc(0), desc(1),desc(2)).Exist(10) Then
			   				Window(windowObj).WinListView(desc(0), desc(1),desc(2)).Select expected 
			   				actual = Window(windowObj).WinListView(desc(0), desc(1),desc(2)).GetROProperty(prop)
			   			End If
			   			
			   		Else
			   			If Window(windowObj).WinListView(desc(0)).Exist(10) Then
			   				Window(windowObj).WinListView(desc(0)).Select expected 
			   				actual = Window(windowObj).WinListView(desc(0)).GetROProperty(prop)
			   			End If			   	
					End If	
					logDetails = logDetails & " Actual: " &actual  					
					result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)
					
				Case Else	
				
					If InStr(desc(0), ":=") <>0 Then
						Window(windowObj).WinListView(desc(0), desc(1),desc(2)).Select expected 
						actual = Window(windowObj).WinListView(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						Window(windowObj).WinListView(desc(0)).Select expected 
						actual = Window(windowObj).WinListView(desc(0)).GetROProperty(prop)
					End If 	  
									
					logDetails = logDetails & " Actual: " &actual  	
					result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)	
					 							
			End Select
	
		Case "Dialog"
			
			Select Case UCase(args)
			
				Case "DOUBLE WINDOW"
				
					If InStr(desc(0), ":=") <>0 Then
						Window(windowObj).Window(dialogObj).WinListView(desc(0), desc(1),desc(2)).Select expected
						actual = Window(windowObj).Window(dialogObj).WinListView(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						Window(windowObj).Window(dialogObj).WinListView(desc(0)).Select expected
						actual = Window(windowObj).Window(dialogObj).WinListView(desc(0)).GetROProperty(prop)
					End If 	 
					
					logDetails = logDetails & " Actual: " &actual  	
					result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)	

												
				Case "NO VALIDATION"
				
			   		If InStr(desc(0), ":=") <> 0 Then
						Window(windowObj).Dialog(dialogObj).WinListView(desc(0), desc(1),desc(2)).Select expected 
					Else
						Window(windowObj).Dialog(dialogObj).WinListView(desc(0)).Select expected 
					End If	
 					result = verificationPoint(True, True, logObject, logDetails, windowObj, expectedResult)
					
				Case "IFEXISTS"
				
			   		If InStr(desc(0), ":=") <> 0 Then
			   			If Window(windowObj).Dialog(dialogObj).WinListView(desc(0), desc(1),desc(2)).Exist(10) Then
			   				Window(windowObj).Dialog(dialogObj).WinListView(desc(0), desc(1),desc(2)).Select expected 
			   				actual = Window(windowObj).Dialog(dialogObj).WinListView(desc(0), desc(1),desc(2)).GetROProperty(prop)
			   			End If
			   			
			   		Else
			   			If Window(windowObj).Dialog(dialogObj).WinListView(desc(0)).Exist(10) Then
			   				Window(windowObj).Dialog(dialogObj).WinListView(desc(0)).Select expected 
			   				actual = Window(windowObj).Dialog(dialogObj).WinListView(desc(0)).GetROProperty(prop)
			   			End If			   	
					End If	
					logDetails = logDetails & " Actual: " &actual 					
					result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)	
					
				Case Else	
				
					If InStr(desc(0), ":=") <>0 Then
						Window(windowObj).Dialog(dialogObj).WinListView(desc(0), desc(1),desc(2)).Select expected 
						actual = Window(windowObj).Dialog(dialogObj).WinListView(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						Window(windowObj).Dialog(dialogObj).WinListView(desc(0)).Select expected 
						actual = Window(windowObj).Dialog(dialogObj).WinListView(desc(0)).GetROProperty(prop)
					End If 	 				
					logDetails = logDetails & " Actual: " &actual  	
					result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)					
					 							
			End Select
					 							 
	End Select

End Function


