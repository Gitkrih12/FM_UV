
'***************************************************************
'File Name: Keyword_SwfButton.vbs
'Date Ceated: 12/06/2023
'Created By: Keerthi Singh
'Description: Library contains all keyword functions for the SwfButton object type
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
' Function: SwfButton_Click (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 12/06/2023
' Created By: Keerthi Singh
' Updated by : -
' Description:  Click keyword for the SwfButton type object

'***************************************************************   

Function SwfButton_Click (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	swfWindowObj = getFields(0,page , "-")
	ident = "SwfWindow"

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

	Case "SwfWindow"

		Select Case UCase(args) 

			Case "NO VALIDATION"

				If InStr(desc(0), ":=") <> 0 Then
					SwfWindow(swfWindowObj).SwfButton(desc(0), desc(1),desc(2)).Click
				Else
					SwfWindow(swfWindowObj).SwfButton(desc(0)).Click
				End If
	
				result = verificationPoint(True, True, logObject, logDetails, swfWindowObj, expectedResult)	

			Case "WAIT"
			
				If InStr(desc(0), ":=") <> 0 Then
					SwfWindow(swfWindowObj).SwfButton(desc(0), desc(1),desc(2)).Click
				Else
					SwfWindow(swfWindowObj).SwfButton(desc(0)).Click
				End If	
	
				actual = SwfWindow(swfWindowObj).WaitProperty(prop, expected, 10000 )	 
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(True, actual, logObject, logDetails, swfWindowObj, expectedResult)
				
			Case "IFEXISTS"
			
				If InStr(desc(0), ":=") <> 0 Then
					If SwfWindow(swfWindowObj).SwfButton(desc(0), desc(1),desc(2)).Exist(10) Then
						SwfWindow(swfWindowObj).SwfButton(desc(0), desc(1),desc(2)).Click	
						actual = SwfWindow(swfWindowObj).GetROproperty(prop)
						logDetails = logDetails & " Actual: " &actual 
						result = verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult)	
					End If
				Else
					If SwfWindow(swfWindowObj).SwfButton(desc(0)).Exist(10) Then
						SwfWindow(swfWindowObj).SwfButton(desc(0)).Click
						actual = SwfWindow(swfWindowObj).GetROproperty(prop)
						logDetails = logDetails & " Actual: " &actual 
						result = verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult)	
					End If	
				End If				

			Case Else

				If InStr(desc(0), ":=") <> 0 Then
					SwfWindow(swfWindowObj).SwfButton(desc(0), desc(1),desc(2)).Click
				Else
					SwfWindow(swfWindowObj).SwfButton(desc(0)).Click
				End If 	  
				
				actual = SwfWindow(swfWindowObj).GetROproperty(prop)
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult)

		End Select
  		   
	End Select

End Function


'***************************************************************
' Function: SwfButton_VerifyExists (stepNum, stepName,expectedResult, page, object, expected, args)
' Date Created: 12/06/2023
' Date Modifed: -
' Created By: Keerthi Singh
' Description:  VerifyExists keyword for the SwfButton type object
' Modification: -
'***************************************************************

Function SwfButton_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	swfWindowObj = getFields(0,page , "-")
	ident = "SwfWindow"
	
	'Parse object description
	
	desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")

	'Set up log results
	
	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	logDetails= "Expected:  " &expected &CHR(13)

	Select Case ident

		Case "SwfWindow"					

			Select Case UCase(args)
			
				Case Else
	
					If InStr(desc(0), ":=") <> 0 Then
						actual = SwfWindow(swfWindowObj).SwfButton(desc(0), desc(1),desc(2)).Exist(20)
					Else
						actual = SwfWindow(swfWindowObj).SwfButton(desc(0)).Exist(20)
					End If	 
  
					logDetails = logDetails & " Actual: " &actual  
					result =  verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult )  

			End Select	
  
	End Select
	
End Function


'***************************************************************
' Function: SwfButton_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 12/06/2023
' Date Modifed: -
' Created By: Keerthi Singh
' Description:  Verify property keword for the SwfButton type object
'***************************************************************

Function SwfButton_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	swfWindowObj = getFields(0,page , "-")
	ident = "SwfWindow"
		
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
	
	'Branch on specific arguments

	Select Case ident

		Case "SwfWindow"	

			Select Case UCase(args)
			
				Case "INSTRING"
		   
					If InStr(desc(0), ":=") <> 0 Then
						actual = SwfWindow(swfWindowObj).SwfButton(desc(0), desc(1),desc(2)).GetROproperty(prop)
					Else
						actual = SwfWindow(swfWindowObj).SwfButton(desc(0)).GetROproperty(prop)
					End If	 
  
					logDetails = logDetails & " Actual: " &actual  
					result =  verificationPointInstr(expected, actual, logObject, logDetails, swfWindowObj, expectedResult) 
					
				Case "WAIT"
		   
					If InStr(desc(0), ":=") <> 0 Then
					
						actual = SwfWindow(swfWindowObj).SwfButton(desc(0), desc(1),desc(2)).WaitProperty(prop, expected, 10000)
					Else
						actual = SwfWindow(swfWindowObj).SwfButton(desc(0)).WaitProperty(prop, expected, 10000)
					End If	 
  
					logDetails = logDetails & " Actual: " &actual  
					result =  verificationPoint(True, actual, logObject, logDetails, swfWindowObj, expectedResult) 

				Case Else
		   
					If InStr(desc(0), ":=") <> 0 Then
						actual = SwfWindow(swfWindowObj).SwfButton(desc(0), desc(1),desc(2)).GetROproperty(prop)
					Else
						actual = SwfWindow(swfWindowObj).SwfButton(desc(0)).GetROproperty(prop)
					End If	 
  
					logDetails = logDetails & " Actual: " &actual  
					result =  verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult) 

			End Select

	End Select
	
End Function
