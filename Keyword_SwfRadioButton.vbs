
'***************************************************************
'File Name: Keyword_SwfRadioButton.vbs
'Date Ceated: 12/23/2023
'Created By: Shivani Raturi
'Description: Library contains all keyword functions for the SwfRadioButton object type
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
' Function: SwfRadioButton_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 12/23/2023
' Created By: Shivani Raturi
' Description: VerifyExists  keyword for the SwfRadioButton type object

'***************************************************************   

Function SwfRadioButton_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

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
					
					If InStr(desc(0), ":=") <>0 Then
						actual = SwfWindow(swfWindowObj).SwfRadioButton(desc(0), desc(1),desc(2)).Exist(20)
					Else
						actual = SwfWindow(swfWindowObj).SwfRadioButton(desc(0)).Exist(20)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult)
				
			End Select
	
	End  Select 
	
End Function

'***************************************************************
' Function: SwfRadioButton_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 12/13/2023
' Date Modifed: 12/13/2023
' Created By: Shivani Raturi
' Description: VerifyProperty keyword for the SwfRadioButton type object
'***************************************************************

Function SwfRadioButton_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

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
					
				Case "INSTRING"
				
					If InStr(desc(0), ":=") <>0 Then
						actual = SwfWindow(swfWindowObj).SwfRadioButton(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						actual = SwfWindow(swfWindowObj).SwfRadioButton(desc(0)).GetROProperty(prop)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPointInstr(expected, actual, logObject, logDetails, swfWindowObj, expectedResult)
					
						
				Case "WAIT"
				
			   		If InStr(desc(0), ":=") <> 0 Then
						actual = SwfWindow(swfWindowObj).SwfRadioButton(desc(0), desc(1),desc(2)).WaitProperty(prop, expected, 10000)
					Else
						actual = SwfWindow(swfWindowObj).SwfRadioButton(desc(0)).WaitProperty(prop, expected, 10000)
					End If		
					
					logDetails = logDetails & " Actual: " &actual  	
					result = verificationPoint(True, actual, logObject, logDetails, swfWindowObj, expectedResult)
							
			
				Case Else	
				
					If InStr(desc(0), ":=") <>0 Then
						actual = SwfWindow(swfWindowObj).SwfRadioButton(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						actual = SwfWindow(swfWindowObj).SwfRadioButton(desc(0)).GetROProperty(prop)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult)
				
			End Select
	
	End  Select 
	
End Function


'***************************************************************
' Function: SwfRadioButton_Set (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 12/14/2023
' Date Modifed: 12/14/2023
' Created By: Shivani Raturi
' Description: Set keyword for the SwfRadioButton type object
'***************************************************************

Function SwfRadioButton_Set (stepNum, stepName, expectedResult, page, object, expected, args)

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
					
				Case "NO VALIDATION"
				
			   		If InStr(desc(0), ":=") <> 0 Then
						 SwfWindow(swfWindowObj).SwfRadioButton(desc(0), desc(1),desc(2)).set 
					Else
						 SwfWindow(swfWindowObj).SwfRadioButton(desc(0)).set 
					End If	
					logDetails = logDetails & " Actual: " &actual  					
					result = verificationPoint(True, True, logObject, logDetails, swfWindowObj, expectedResult)
					
				Case "IFEXISTS"
				
			   		If InStr(desc(0), ":=") <> 0 Then
			   			If SwfWindow(swfWindowObj).SwfRadioButton(desc(0), desc(1),desc(2)).Exist(20) Then
			   				SwfWindow(swfWindowObj).SwfRadioButton(desc(0), desc(1),desc(2)).set 	
			   				actual = SwfWindow(swfWindowObj).SwfRadioButton(desc(0), desc(1),desc(2)).GetROProperty(prop)
			   			End If
			   			
			   		Else
			   			If SwfWindow(swfWindowObj).SwfRadioButton(desc(0)).Exist(20) Then
			   				SwfWindow(swfWindowObj).SwfRadioButton(desc(0)).set 
			   				actual = SwfWindow(swfWindowObj).SwfRadioButton(desc(0)).GetROProperty(prop)
			   			End If			   	
					End If
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult)					
												
				Case Else	
				
					If InStr(desc(0), ":=") <>0 Then
						SwfWindow(swfWindowObj).SwfRadioButton(desc(0), desc(1),desc(2)).set
						actual = SwfWindow(swfWindowObj).SwfRadioButton(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						SwfWindow(swfWindowObj).SwfRadioButton(desc(0)).Set
						actual = SwfWindow(swfWindowObj).SwfRadioButton(desc(0)).GetROProperty(prop)
					End If 	 
					
					logDetails = logDetails & " Actual: " &actual  	
					result = verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult)	

				
			End Select
	
	End  Select 
	
End Function

