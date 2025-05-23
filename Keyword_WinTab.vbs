
'***************************************************************
'File Name: Keyword_WinTab.vbs
'Date Ceated: 07/31/2023
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
' Function: WinTab_Select (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 07/31/2023
' Created By: Keerthi Singh
' Description: Select  keyword for the WinTab type object

'***************************************************************   

Function WinTab_Select(stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	windowObj = getFields(0,page , "-")
    winObj = getFieldsUpperNull(1,page , "-")

	If winObj = ""  Then
		ident = "Window"
	Else	
		ident = "WinObject"	
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
				 	Window(windowObj).WinTab(desc(0), desc(1),desc(2)).Select expected
				Else
					Window(windowObj).WinTab(desc(0)).Select expected
				End If
				result = verificationPoint(True, True, logObject, logDetails, windowObj, expectedResult)
				
		    Case "IFEXISTS"
				
				If InStr(desc(0), ":=") <> 0 Then
				  If Window(windowObj).WinTab(desc(0), desc(1),desc(2)).Exist(10) Then
					  	Window(windowObj).WinTab(desc(0), desc(1),desc(2)).Select expected
						actual = Window(windowObj).WinTab(desc(0), desc(1),desc(2)).GetROProperty(prop)   
				  End If
				Else
					If Window(windowObj).WinTab(desc(0)).Exist(10) Then
						Window(windowObj).WinTab(desc(0)).Select expected
						actual = Window(windowObj).WinTab(desc(0)).GetROProperty(prop)
					End If
				logDetails = logDetails & " Actual: " &actual				 
				result =  verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult )
				End If
				
			Case Else
		
				If InStr(desc(0), ":=") <> 0 Then
					Window(windowObj).WinTab(desc(0), desc(1),desc(2)).Select expected
					actual = Window(windowObj).WinTab(desc(0), desc(1),desc(2)).GetROProperty(prop)
				Else
					Window(windowObj).WinTab(desc(0)).Select expected
					actual = Window(windowObj).WinTab(desc(0)).GetROProperty(prop)
				End If		
				logDetails = logDetails & " Actual: " &actual				 
				result =  verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult )
				
			End Select
	
	Case "WinObject"

		Select Case UCase(args)

			Case "NO VALIDATION"

				If InStr(desc(0), ":=") <> 0 Then
				 	Window(windowObj).WinObject(winObj).WinTab(desc(0), desc(1),desc(2)).Select expected 
				Else
					Window(windowObj).WinObject(winObj).WinTab(desc(0)).Select expected
				End If
				result = verificationPoint(True, True, logObject, logDetails, windowObj, expectedResult)
				
		    Case "IFEXISTS"
				
				If InStr(desc(0), ":=") <> 0 Then
				  If Window(windowObj).WinObject(winObj).WinTab(desc(0), desc(1),desc(2)).Exist(10) Then
					  	Window(windowObj).WinObject(winObj).WinTab(desc(0), desc(1),desc(2)).Select expected
						actual = Window(windowObj).WinObject(winObj).WinTab(desc(0), desc(1),desc(2)).GetROProperty(prop)   
				  End If
				Else
					If Window(windowObj).WinObject(winObj).WinTab(desc(0)).Exist(10) Then
						Window(windowObj).WinObject(winObj).WinTab(desc(0)).Select expected
						actual = Window(windowObj).WinObject(winObj).WinTab(desc(0)).GetROProperty(prop)
					End If
				End If
				logDetails = logDetails & " Actual: " &actual				 
				result =  verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult )
				
			Case Else
		
				If InStr(desc(0), ":=") <> 0 Then
					Window(windowObj).WinObject(winObj).WinTab(desc(0), desc(1),desc(2)).Select expected
					actual = Window(windowObj).WinObject(winObj).WinTab(desc(0), desc(1),desc(2)).GetROProperty(prop)
				Else
					Window(windowObj).WinObject(winObj).WinTab(desc(0)).Select expected
					actual = Window(windowObj).WinObject(winObj).WinTab(desc(0)).GetROProperty(prop)
				End If		
				logDetails = logDetails & " Actual: " &actual				 
				result =  verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult )
				
			End Select
			
	End Select
			
End Function

