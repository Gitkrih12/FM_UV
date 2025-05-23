'***************************************************************
' Function: SwfEdit_TypeText (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 12/06/2023
' Date Modifed: 12/06/2023
' Created By: Shivani Raturi 
' Description:  TypeText keyword for the SwfEdit type object
'***************************************************************

Function SwfEdit_TypeText (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	swfWindowObj = getFields(0,page , "-")
    
    ident="SwfWindow"
	
	'Parse property and expected result

	If Instr(expected,":=") <> 0 Then
		prop=getFields(0, expected, ":=")
	Else
		prop="text"
		
	End If
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

' Convert Datestamp

	If expected = "Environment('Datestamp')" Then
		expected = environment("Datestamp")
	Elseif instr (expected,"Environment('Datestamp')<") Then
		expected = getfields(2,expected,"<")
		expected = mid(expected,1,len(expected)-1)
		Call Utility_GenDatestamp(stepNum, stepName,expectedResult, page, object, expected, "Run Time")  
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

  'Branch on argument
	
	Select Case ident

		Case "SwfWindow"

			Select Case UCase(args)

				Case "NO VALIDATION"

						If InStr(desc(0), ":=") <>0 Then
							SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).Set expected
						Else
							SwfWindow(swfWindowObj).SwfEdit(desc(0)).Set expected
						End If
		
						result = verificationPoint(True, True, logObject, logDetails, swfWindowObj, expectedResult)
						
				Case "IFEXISTS"
					
					If InStr(desc(0), ":=") <>0 Then
						If SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).Exist(10) Then
							SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).Set expected
							actual = SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).GetROProperty(prop)
							LogDetails = logDetails & " Actual: " &actual  
							result = verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult)
						End If
					Else
						If SwfWindow(swfWindowObj).SwfEdit(desc(0)).Exist(10) Then
							SwfWindow(swfWindowObj).SwfEdit(desc(0)).Set expected
							actual = SwfWindow(swfWindowObj).SwfEdit(desc(0)).GetROProperty(prop)
							LogDetails = logDetails & " Actual: " &actual  
							result = verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult)
						End If	
					End If				
	
				Case "WO COMMIT"
					
					If InStr(desc(0), ":=") <> 0 Then  
						SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).Set expected,False
						actual = SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						SwfWindow(swfWindowObj).SwfEdit(desc(0)).Set expected,False
						actual = SwfWindow(swfWindowObj).SwfEdit(desc(0)).GetROProperty(prop)
					End If
					 
					logDetails = logDetails & " Actual: " &actual				 
					result =  verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult)
	
				Case Else
	
					If InStr(desc(0), ":=") <> 0 Then
						SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).Set expected
						actual = SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						SwfWindow(swfWindowObj).SwfEdit(desc(0)).Set expected
						actual = SwfWindow(swfWindowObj).SwfEdit(desc(0)).GetROProperty(prop)
					End If
					 
					logDetails = logDetails & " Actual: " &actual				 
					result =  verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult )
					
			End Select
	
	End  Select 
	
End Function
	
'***************************************************************
' Function: SwfEdit_Click (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 12/07/2023
' Date Modifed: 12/07/2023
' Created By: Shivani Raturi
' Description:  Click keyword for the SwfEdit type object
'***************************************************************

Function SwfEdit_Click (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	swfWindowObj = getFields(0,page , "-")
	ident="SwfWindow"
	
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

  'Branch on argument
	
	Select Case ident

		Case "SwfWindow"

			Select Case UCase(args)
					
				Case "IFEXISTS"
				
					If InStr(desc(0), ":=") <>0 Then
						If SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).Exist(10) Then
							SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).Click
							actual = SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).GetROProperty(prop)
							LogDetails = logDetails & " Actual: " &actual  
							result = verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult)
						End If
					Else
						If SwfWindow(swfWindowObj).SwfEdit(desc(0)).Exist(10) Then
							SwfWindow(swfWindowObj).SwfEdit(desc(0)).Click
							actual = SwfWindow(swfWindowObj).SwfEdit(desc(0)).GetROProperty(prop)
							LogDetails = logDetails & " Actual: " &actual  
							result = verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult)
						End If	
					End If				
	
				Case Else
	
					If InStr(desc(0), ":=") <> 0 Then
						SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).Click
						actual = SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						SwfWindow(swfWindowObj).SwfEdit(desc(0)).Click
						actual = SwfWindow(swfWindowObj).SwfEdit(desc(0)).GetROProperty(prop)
					End If
					 
					logDetails = logDetails & " Actual: " &actual				 
					result =  verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult )
				
			End Select
	
	End  Select 
	
End Function
	
'***************************************************************
' Function: SwfEdit_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 12/11/2023
' Date Modifed: 12/11/2023
' Created By: Shivani Raturi
' Description:  Verify Property keyword for the SwfEdit type object
'***************************************************************

Function SwfEdit_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	swfWindowObj = getFields(0,page , "-")
	ident="SwfWindow"
	
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

	
  'Branch on argument
	
	Select Case ident

		Case "SwfWindow"

			Select Case UCase(args)
		
				Case "WAIT"
			    	
			    	If InStr(desc(0), ":=") Then
						actual = SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).WaitProperty(prop, expected, 10000)
					Else
						actual = SwfWindow(swfWindowObj).SwfEdit(desc(0)).WaitProperty(prop, expected, 10000)
					End If		  
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(True, actual, logObject, logDetails, swfWindowObj, expectedResult)
					
				Case "INSTRING"
				
					If InStr(desc(0), ":=") Then
						actual = SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
					Else
						actual = SwfWindow(swfWindowObj).SwfEdit(desc(0)).GetROproperty(prop)
					End If
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPointInstr(expected, actual, logObject, logDetails , swfWindowObj, expectedResult)
			
				Case "COMPARE"
	
					If InStr(desc(0), ":=") Then
						actual = SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
					Else
						actual = SwfWindow(swfWindowObj).SwfEdit(desc(0)).GetROproperty(prop)
					End If
					logDetails = logDetails & " Actual: " &actual
					
					If IsDate(actual) Then
						actual = CDAte(actual)
					End If
	
					result = verificationPointCmp(expected, actual, logObject, logDetails, swfWindowObj, expectedResult, comparisonFactor)		

				Case Else
	
					If InStr(desc(0), ":=") <> 0 Then
						SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).Click
						actual = SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						SwfWindow(swfWindowObj).SwfEdit(desc(0)).Click
						actual = SwfWindow(swfWindowObj).SwfEdit(desc(0)).GetROProperty(prop)
					End If
					 
					logDetails = logDetails & " Actual: " &actual				 
					result =  verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult )
					
			End Select
	
	End  Select 
	
End Function
	
'***************************************************************
' Function: SwfEdit_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 12/07/2023
' Date Modifed: 12/07/2023
' Created By: Shivani Raturi
' Description:  Verify Exists keyword for the SwfEdit type object
'***************************************************************

Function SwfEdit_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	swfWindowObj = getFields(0,page , "-")
	ident="SwfWindow"
	
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
	
	Select Case ident

		Case "SwfWindow"

			Select Case UCase(args)
					
				Case Else

					If InStr(desc(0), ":=") Then
						actual = SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1), desc(2)).Exist(20)
					Else
						actual = SwfWindow(swfWindowObj).SwfEdit(desc(0)).Exist(20)
					End If
	
					result =  verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult) 
					
			End Select
	
	End  Select 
	
End Function


'***************************************************************
' Function: SwfEdit_GetProperty (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 12/13/2023
' Date Modifed: 12/13/2023
' Created By: Shivani Raturi
' Description:  Get Property keyword for the SwfEdit type object
'***************************************************************

Function SwfEdit_GetProperty (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	swfWindowObj = getFields(0,page , "-")
	ident="SwfWindow"

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
	
	Select Case ident

		Case "SwfWindow"

			Select Case UCase(args)
					
				Case Else

					If InStr(desc(0), ":=") Then
						Set testObj = SwfWindow(swfWindowObj).SwfEdit(desc(0), desc(1),desc(2)) 
					Else
						Set testObj = SwfWindow(swfWindowObj).SwfEdit(desc(0))
					End If	   
		
			End Select
		
			Environment("TestVariable") = testObj.GetROproperty(expected)
	
	End  Select 
	
End Function
	
	
	
	
