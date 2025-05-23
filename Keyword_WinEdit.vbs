'***************************************************************
' Function: WinEdit_TypeText (stepNum, stepName, page, object, sValue, args)
' Date Created: 12/10/2022
' Date Modifed: 12/10/2022
' Created By: Raghunath Konda
' Description:  TypeText keyword for the WpfEdit type object
' Modifications: 03/15/07, BW, Added Timestamp arguement to handle Timestamp value in sValue
'***************************************************************

Function WinEdit_TypeText (stepNum, stepName, expectedResult, page, object, sValue, args)

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
	
	expectedResult = "Verify user should be able to input "&Chr(34)&sValue&Chr(34)&" to the field"

  'Branch on argument
	
	Select Case ident

	Case "Window"

		Select Case UCase(args)

			Case "NO VALIDATION"

					If InStr(desc(0), ":=") <>0 Then
						Window(windowObj).WinEdit(desc(0), desc(1),desc(2)).Set sValue
					Else
						Window(windowObj).WinEdit(desc(0)).Set sValue
					End If
	
					result = verificationPoint(True, True, logObject, logDetails, windowObj, expectedResult)
					
		Case "IFEXISTS"
				
				If InStr(desc(0), ":=") <>0 Then
					If Window(windowObj).WinEdit(desc(0), desc(1),desc(2)).Exist(10) Then
						Window(windowObj).WinEdit(desc(0), desc(1),desc(2)).Set sValue
						actual = Window(windowObj).WinEdit(desc(0), desc(1),desc(2)).GetROProperty("text")
						LogDetails = logDetails & " Actual: " &actual  
						result = verificationPoint(sValue, actual, logObject, logDetails, windowObj, expectedResult)
					End If
				Else
					If Window(windowObj).WinEdit(desc(0)).Exist(10) Then
						Window(windowObj).WinEdit(desc(0)).Click
						actual = Window(windowObj).WinEdit(desc(0)).GetROProperty("text")
						LogDetails = logDetails & " Actual: " &actual  
						result = verificationPoint(sValue, actual, logObject, logDetails, windowObj, expectedResult)
					End If	
				End If				

				
	
	Case "WO COMMIT"
				
				If InStr(desc(0), ":=") <> 0 Then  
					Window(windowObj).WinEdit(desc(0), desc(1),desc(2)).Set sValue,False
					actual = Window(windowObj).WinEdit(desc(0), desc(1),desc(2)).GetROProperty("text")
				Else
					Window(windowObj).WinEdit(desc(0)).Set sValue,False
					actual = Window(windowObj).WinEdit(desc(0)).GetROProperty("text")
				End If
				 
				logDetails = logDetails & " Actual: " &actual				 

					result =  verificationPoint(sValue, actual, logObject, logDetails, windowObj, expectedResult )

			
	Case Else

				If InStr(desc(0), ":=") <> 0 Then
					Window(windowObj).WinEdit(desc(0), desc(1),desc(2)).Set sValue
					actual = Window(windowObj).WinEdit(desc(0), desc(1),desc(2)).GetROProperty("text")
				Else
					Window(windowObj).WinEdit(desc(0)).Set sValue
					actual = Window(windowObj).WinEdit(desc(0)).GetROProperty("text")
				End If
				 
				logDetails = logDetails & " Actual: " &actual				 

					result =  verificationPoint(sValue, actual, logObject, logDetails, windowObj, expectedResult )

			   
		
	End Select
  		
  		Case "Dialog"
			
			Select Case UCase(args)

			Case "NO VALIDATION"

					If InStr(desc(0), ":=") <>0 Then
						Window(windowObj).Dialog(dialogobj).WinEdit(desc(0), desc(1),desc(2)).Set sValue
					Else
						Window(windowObj).Dialog(dialogobj).WinEdit(desc(0)).Set sValue
					End If
	
					result = verificationPoint(True, True, logObject, logDetails, windowObj, expectedResult)
			
			Case "IFEXISTS"
				
				If InStr(desc(0), ":=") <>0 Then
					If Window(windowObj).Dialog(dialogobj).WinEdit(desc(0), desc(1),desc(2)).Exist(10) Then
						Window(windowObj).Dialog(dialogobj).WinEdit(desc(0), desc(1),desc(2)).Set sValue
						actual = Window(windowObj).Dialog(dialogobj).WinEdit(desc(0), desc(1),desc(2)).GetROProperty("text") 'do we need to take GetROproerty with Dialog like Window(windowObj).Dialog(dialogobj).WinEdit(desc(0), desc(1),desc(2)).GetROProperty("text") '
						LogDetails = logDetails & " Actual: " &actual  
						result = verificationPoint(sValue, actual, logObject, logDetails, windowObj, expectedResult)
					End If
				Else
					If Window(windowObj).Dialog(dialogobj).WinEdit(desc(0)).Exist(10) Then
						Window(windowObj).Dialog(dialogobj).WinEdit(desc(0)).Set sValue
						actual = Window(windowObj).GetROProperty("text")
						LogDetails = logDetails & " Actual: " &actual  
						result = verificationPoint(sValue, actual, logObject, logDetails, windowObj, expectedResult)
					End If	
				End If				

				
	
	Case "WO COMMIT"
				
				If InStr(desc(0), ":=") <> 0 Then
					Window(windowObj).Dialog(dialogobj).WinEdit(desc(0), desc(1),desc(2)).Set sValue,False
					actual = Window(windowObj).Dialog(dialogobj).WinEdit(desc(0), desc(1),desc(2)).GetROProperty("text") '"how to take getROproperty, do we need to include dialogobject as well'
				Else
					Window(windowObj).WinEdit(desc(0)).Set sValue,False
					actual = Window(windowObj).Dialog(dialogobj).WinEdit(desc(0)).GetROProperty("text")
				End If
				 
				logDetails = logDetails & " Actual: " &actual				 

					result =  verificationPoint(sValue, actual, logObject, logDetails, windowObj, expectedResult )
	
	Case "ENV_VARIABLE"

                If InStr(desc(0), ":=") <> 0 Then
                     If  Window(windowObj).Dialog(dialogobj).WinEdit(desc(0), desc(1),desc(2)).Exist Then
 						 Window(windowObj).Dialog(dialogobj).WinEdit(desc(0), desc(1),desc(2)).Set Environment.Value(sValue)
 						 result = verificationPoint(True, True, logObject, logDetails, windowObj, expectedResult)
                     End  If
                 Else
                    If Window(windowObj).Dialog(dialogobj).WinEdit(desc(0)).Exist Then
                           Window(windowObj).Dialog(dialogobj).WinEdit(desc(0)).Set Environment.Value(sValue)
                            result = verificationPoint(True, True, logObject, logDetails, windowObj, expectedResult)
                    End If
                 End  If 


			
	Case Else

				If InStr(desc(0), ":=") <> 0 Then
					Window(windowObj).Dialog(dialogobj).WinEdit(desc(0), desc(1),desc(2)).Set sValue
					actual = Window(windowObj).Dialog(dialogobj).WinEdit(desc(0), desc(1),desc(2)).GetROProperty("text")
				Else
					Window(windowObj).Dialog(dialogobj).WinEdit(desc(0)).Set sValue
					actual = Window(windowObj).Dialog(dialogobj).WinEdit(desc(0)).GetROProperty("text")
				End If
				 
				logDetails = logDetails & " Actual: " &actual				 

					result =  verificationPoint(sValue, actual, logObject, logDetails, windowObj, expectedResult )

			   
		
	End Select
	End  Select 
End Function



'***************************************************************
' Function: WpfEdit_VerifyProperty (stepNum, stepName, page, object, expected, args)
' Date Created: 12/10/2022
' Date Modifed: 12/10/2022
' Created By: Raghunath Konda
' Description:  Verify Property keyword for the WpEdit type object
' Modification: 03/30/07, BW, Added Timestamp arguement to handle verifying timestamp value
'***************************************************************

Function WinEdit_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

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
	
	prop=getFields(0, expected, ":=")
	expected=getFields(1, expected, ":=")
    expected=replaceConstants(expected)

	'Parse object description
	
	desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")
'
	'Set up log results

	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	If (args = "") Then
		logDetails= "Expected:  " &expected &CHR(13)
	Else
		logDetails= "Expected: (" &args &")  " &expected &CHR(13)
	End If

	'Branch on argument

 	If Instr(expected,"~") <> 0 Then
 		comparisonFactor = getFields(0, Expected, "~")
		expected = getFields(1, Expected, "~")
 	End If
 	
 	If Expected = "Environment('Datestamp')" Then
		Expected = Environment("Datestamp")
	Elseif instr (Expected,"Environment('Datestamp')<") Then
		expected = getfields(2,Expected,"<")
		expected = mid(expected,1,len(expected)-1)
		Call Utility_GenDatestamp(stepNum, stepName,expectedResult, page, object, expected, "Run Time")  
		expected= environment("Datestamp")
	ElseIf expected = "TestVariable" Then
		expected = Environment("TestVariable")
	End If
	
	
	Select Case ident

	Case "Window"

		Select Case UCase(args)

			Case "WAIT"
			    If InStr(desc(0), ":=") <> 0 Then
					actual = Window(windowObj).WinEdit(desc(0), desc(1),desc(2)).WaitProperty(prop, expected, 10000)
				Else
					actual = Window(windowObj).WinEdit(desc(0)).WaitProperty(prop, expected, 10000)
				End If		  
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(True, actual, logObject, logDetails, windowObj, expectedResult)
					
		
	        Case "INSTRING"

				If InStr(desc(0), ":=")  <> 0 Then
					actual = Window(windowObj).WinEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
				Else
					actual = Window(windowObj).WinEdit(desc(0)).GetROproperty(prop)
				End If
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPointInstr(expected, actual, logObject, logDetails , windowObj, expectedResult)
	
	        Case Else
				If InStr(desc(0), ":=")  <> 0 Then
					actual =  Window(windowObj).WinEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
				Else
					actual =  Window(windowObj).WinEdit(desc(0)).GetROproperty(prop)
				End If
			
					   logDetails = logDetails & " Actual: " &actual  
					   result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult )	 
		
	End Select
  		
  		Case "Dialog"
			
			Select Case UCase(args)

			Case "WAIT"
			    If InStr(desc(0), ":=") <> 0 Then
					actual = Window(windowObj).Dialog(dialogobj).WinEdit(desc(0), desc(1),desc(2)).WaitProperty(prop, expected, 10000)
				Else
					actual = Window(windowObj).Dialog(dialogobj).WinEdit(desc(0)).WaitProperty(prop, expected, 10000)
				End If		  
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(True, actual, logObject, logDetails, windowObj, expectedResult)
					
		
	        Case "INSTRING"

				If InStr(desc(0), ":=")  <> 0 Then
					actual = Window(windowObj).Dialog(dialogobj).WinEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
				Else
					actual = Window(windowObj).Dialog(dialogobj).WinEdit(desc(0)).GetROproperty(prop)
				End If
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPointInstr(expected, actual, logObject, logDetails , windowObj, expectedResult)
	
	        Case Else
				If InStr(desc(0), ":=")  <> 0 Then
					actual =  Window(windowObj).Dialog(dialogobj).WinEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
				Else
					actual =  Window(windowObj).Dialog(dialogobj).WinEdit(desc(0)).GetROproperty(prop)
				End If
			
					   logDetails = logDetails & " Actual: " &actual  
					   result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult )
			   
		
	End Select
	End  Select 

	
  
				
		
End Function





