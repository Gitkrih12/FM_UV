'***************************************************************
' Function: WinTreeView_Select (stepNum, stepName, page, object, expected, args)
' Date Modifed: 04/21/2023
' Created By:  Shivani Raturi 
' Description:  Select keyword for the WinTreeView type object

'***************************************************************

Function WinTreeView_Select (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	windowObj = getFields(0,page , "-")
    windowObj = getFields(1,page , "-")

	If dialogobj = "" Then
		ident = "Window"
	
	Else
		ident = "Dialog"	
	End If
''
'	'Parse property and expected result

	prop=getFields(0, sValue, ":=")
	sValue=getFields(1, sValue, ":=")
	sValue=replaceConstants(sValue)
'
'	'Parse object description
'	
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

' Convert Datestamp

	If sValue = "Environment('Datestamp')" Then
		sValue = environment("Datestamp")
	Elseif instr (sValue,"Environment('Datestamp')<") Then
		expected = getfields(2,sValue,"<")
		expected = mid(expected,1,len(expected)-1)
		Call Utility_GenDatestamp(stepNum, stepName,expectedResult, page, object, expected, "Run Time")  
		sValue = environment("Datestamp")
	Elseif sValue = "Environment('sData')" Then
		sValue = Environment("sData")
	Elseif sValue = "Environment('Timestamp')" Then
		sValue = Environment("Timestamp")
	ElseIf sValue = "TestVariable" Then
		sValue = Environment("TestVariable")
	End If

  'Branch on argument
	
	Select Case ident

	Case "Window"

		Select Case UCase(args)

			Case "NO VALIDATION"

				If InStr(desc(0), ":=") <> 0 Then
				 	Window(windowObj).WinTreeView(desc(0), desc(1),desc(2)).Select expected 
				Else
					Window(windowObj).WinTreeView(desc(0)).Select expected
					
				End If

				result = verificationPoint(True, True, logObject, logDetails, windowObj, expectedResult)
				
		    Case "IFEXISTS"
				
				If InStr(desc(0), ":=") <> 0 Then
				  If Window(windowObj).WinTreeView(desc(0), desc(1),desc(2)).Exist Then
					  	Window(windowObj).WinTreeView(desc(0), desc(1),desc(2)).Select expected
						actual = Window(windowObj).GetROProperty(prop)   
						logDetails = logDetails & " Actual: " &actual				 
						result =  verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult )
				  End If
				Else
					If Window(windowObj).WinTreeView(desc(0)).Exist Then
						Window(windowObj).WinTreeView(desc(0)).Select expected
						actual = Window(windowObj).GetROProperty(prop)
						logDetails = logDetails & " Actual: " &actual				 
						result =  verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult )
					End If
				End If
				
			 Case "RIGHT CLICK"

				If InStr(desc(0), ":=") <> 0 Then
				 	Window(windowObj).WinTreeView(desc(0), desc(1),desc(2)).Select expected, micRightBtn 
				Else
					Window(windowObj).WinTreeView(desc(0)).Select expected, micRightBtn
					
				End If

				result = verificationPoint(True, True, logObject, logDetails, windowObj, expectedResult)
				
	

			Case Else
		
					If InStr(desc(0), ":=") <> 0 Then
						Window(windowObj).WinTreeView(desc(0), desc(1),desc(2)).Select expected
						actual = Window(windowObj).GetROProperty(prop)
					Else
						Window(windowObj).WinTreeView(desc(0)).Select expected
						actual = Window(windowObj).GetROProperty(prop)
					End If		
						logDetails = logDetails & " Actual: " &actual				 
						result =  verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult )
				
			End Select
	End Select


			
End Function

Function WinTreeView_Activate (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	windowObj = getFields(0,page , "-")
    windowObj = getFields(1,page , "-")

	If dialogobj = "" Then
		ident = "Window"
	
	Else
		ident = "Dialog"	
	End If

'	'Parse property and expected result

	prop=getFields(0, sValue, ":=")
	sValue=getFields(1, sValue, ":=")
	sValue=replaceConstants(sValue)
'
'	'Parse object description
'	
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

' Convert Datestamp

	If sValue = "Environment('Datestamp')" Then
		sValue = environment("Datestamp")
	Elseif instr (sValue,"Environment('Datestamp')<") Then
		expected = getfields(2,sValue,"<")
		expected = mid(expected,1,len(expected)-1)
		Call Utility_GenDatestamp(stepNum, stepName,expectedResult, page, object, expected, "Run Time")  
		sValue = environment("Datestamp")
	Elseif sValue = "Environment('sData')" Then
		sValue = Environment("sData")
	Elseif sValue = "Environment('Timestamp')" Then
		sValue = Environment("Timestamp")
	ElseIf sValue = "TestVariable" Then
		sValue = Environment("TestVariable")
	End If

  'Branch on argument
	
	Select Case ident

	Case "Window"

		Select Case UCase(args)

			Case "NO VALIDATION"

				If InStr(desc(0), ":=") <> 0 Then
				 	Window(windowObj).WinTreeView(desc(0), desc(1),desc(2)).Activate expected 
				Else
					Window(windowObj).WinTreeView(desc(0)).Activate expected
					
				End If

				result = verificationPoint(True, True, logObject, logDetails, windowObj, expectedResult)
				
		    Case "IFEXISTS"
				
				If InStr(desc(0), ":=") <> 0 Then
				  If Window(windowObj).WinTreeView(desc(0), desc(1),desc(2)).Exist Then
					  	Window(windowObj).WinTreeView(desc(0), desc(1),desc(2)).Activate expected
						actual = Window(windowObj).GetROProperty(prop)   
						logDetails = logDetails & " Actual: " &actual				 
						result =  verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult )
				  End If
				Else
					If Window(windowObj).WinTreeView(desc(0)).Exist Then
						Window(windowObj).WinTreeView(desc(0)).Activate expected
						actual = Window(windowObj).GetROProperty(prop)
						logDetails = logDetails & " Actual: " &actual				 
						result =  verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult )
					End If
				End If
				
	

	Case Else

			If InStr(desc(0), ":=") <> 0 Then
				Window(windowObj).WinTreeView(desc(0), desc(1),desc(2)).Activate expected
				actual = Window(windowObj).GetROProperty(prop)
			Else
				Window(windowObj).WinTreeView(desc(0)).Activate expected
				actual = Window(windowObj).GetROProperty(prop)
			End If		
				logDetails = logDetails & " Actual: " &actual				 
				result =  verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult )
		
	End Select
	End Select


			
End Function

Function WinTreeView_Expand (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	windowObj = getFields(0,page , "-")
    windowObj = getFields(1,page , "-")

	If dialogobj = "" Then
		ident = "Window"
	
	Else
		ident = "Dialog"	'
	End If

'	'Parse property and expected result

	prop=getFields(0, sValue, ":=")
	sValue=getFields(1, sValue, ":=")
	sValue=replaceConstants(sValue)
'
'	'Parse object description
'	
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

' Convert Datestamp

	If sValue = "Environment('Datestamp')" Then
		sValue = environment("Datestamp")
	Elseif instr (sValue,"Environment('Datestamp')<") Then
		expected = getfields(2,sValue,"<")
		expected = mid(expected,1,len(expected)-1)
		Call Utility_GenDatestamp(stepNum, stepName,expectedResult, page, object, expected, "Run Time")  
		sValue = environment("Datestamp")
	Elseif sValue = "Environment('sData')" Then
		sValue = Environment("sData")
	Elseif sValue = "Environment('Timestamp')" Then
		sValue = Environment("Timestamp")
	ElseIf sValue = "TestVariable" Then
		sValue = Environment("TestVariable")
	End If

  'Branch on argument
	
	Select Case ident

	Case "Window"

		Select Case UCase(args)

			Case "NO VALIDATION"

				If InStr(desc(0), ":=") <> 0 Then
				 	Window(windowObj).WinTreeView(desc(0), desc(1),desc(2)).Expand expected 
				Else
					Window(windowObj).WinTreeView(desc(0)).Expand expected
					
				End If

				result = verificationPoint(True, True, logObject, logDetails, windowObj, expectedResult)
				
		    Case "IFEXISTS"
				
				If InStr(desc(0), ":=") <> 0 Then
				  If Window(windowObj).WinTreeView(desc(0), desc(1),desc(2)).Exist Then
					  	Window(windowObj).WinTreeView(desc(0), desc(1),desc(2)).Expand expected
						actual = Window(windowObj).GetROProperty(prop)   
						logDetails = logDetails & " Actual: " &actual				 
						result =  verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult )
				  End If
				Else
					If Window(windowObj).WinTreeView(desc(0)).Exist Then
						Window(windowObj).WinTreeView(desc(0)).Expand expected
						actual = Window(windowObj).GetROProperty(prop)
						logDetails = logDetails & " Actual: " &actual				 
						result =  verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult )
					End If
				End If
				
	

	Case Else

			If InStr(desc(0), ":=") <> 0 Then
				Window(windowObj).WinTreeView(desc(0), desc(1),desc(2)).Expand expected
				actual = Window(windowObj).GetROProperty(prop)
			Else
				Window(windowObj).WinTreeView(desc(0)).Expand expected
				actual = Window(windowObj).GetROProperty(prop)
			End If		
				logDetails = logDetails & " Actual: " &actual				 
				result =  verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult )
		
	End Select
	End Select


			
End Function






