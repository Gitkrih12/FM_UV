'***************************************************************
'File Name: Keyword_SwfCheckBox.vbs
'Date Ceated: 12/08/2023
'Created By: Keerthi Singh
'Description: Library contains all keyword functions for the SwfCheckBox object type
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
' Function: SwfCheckBox_Set (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 12/08/2023
' Created By: Keerthi Singh
' Updated by : -
' Description:  Set keyword for the SwfCheckBox type object

'***************************************************************   

Function SwfCheckBox_Select (stepNum, stepName, expectedResult, page, object, expected, args)

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
	
	descVal(0) = getFields(1, desc(0), ":=") 
	If descVal(0) = "RowIndex" Then
		desc(0) = Replace(desc(0),"RowIndex",Cstr(CInt(Environment("RowIndex"))-1))
	End If
	descVal(1) = getFields(1, desc(1), ":=")
	If descVal(1) = "RowIndex" Then
		desc(1) = Replace(desc(1),"RowIndex",Cstr(CInt(Environment("RowIndex"))-1))
	End If
	descVal(2) = getFields(1, desc(2), ":=")
	If descVal(2) = "RowIndex" Then
		desc(2) = Replace(desc(2),"RowIndex",Cstr(CInt(Environment("RowIndex"))-1))
	End If
	
	
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
					SwfWindow(swfWindowObj).SwfCheckBox(desc(0), desc(1),desc(2)).Set expected
				Else
					SwfWindow(swfWindowObj).SwfCheckBox(desc(0)).Set expected
				End If
				
				result = verificationPoint(True, True, logObject, logDetails, swfWindowObj, expectedResult)  
			
			Case "IFEXISTS"
			
				If InStr(desc(0), ":=") <> 0 Then
					If SwfWindow(swfWindowObj).SwfCheckBox(desc(0), desc(1),desc(2)).Exist(10) Then
						SwfWindow(swfWindowObj).SwfCheckBox(desc(0), desc(1),desc(2)).Set expected	
						actual = SwfWindow(swfWindowObj).SwfCheckBox(desc(0), desc(1),desc(2)).GetROproperty("checked")
						logDetails = logDetails & " Actual: " &actual 		
					Else
						expected = "NO TEST" 
					End If
				Else
					If SwfWindow(swfWindowObj).SwfCheckBox(desc(0)).Exist(10) Then
						SwfWindow(swfWindowObj).SwfCheckBox(desc(0)).Set expected
						actual = SwfWindow(swfWindowObj).SwfCheckBox(desc(0)).GetROproperty("checked")
						logDetails = logDetails & " Actual: " &actual 
					Else
						expected = "NO TEST"
					End If	
				End If				

			Case Else

				If InStr(desc(0), ":=") <> 0 Then
					SwfWindow(swfWindowObj).SwfCheckBox(desc(0), desc(1),desc(2)).Set expected
					actual = SwfWindow(swfWindowObj).SwfCheckBox(desc(0), desc(1),desc(2)).GetROproperty("checked")
					logDetails = logDetails & " Actual: " &actual  
				Else
					SwfWindow(swfWindowObj).SwfCheckBox(desc(0)).Set expected
					actual = SwfWindow(swfWindowObj).SwfCheckBox(desc(0)).GetROproperty("checked")
					logDetails = logDetails & " Actual: " &actual
				End If 	    

		End Select
		
		If (expected = "ON") Then 
			 result =  verificationPoint("1", actual, logObject, logDetails, swfWindowObj, expectedResult ) 
		ElseIf expected = "OFF" Then
			 result =  verificationPoint("0", actual, logObject, logDetails , swfWindowObj, expectedResult)
		End If
  		   
	End Select

End Function

'***************************************************************
' Function: SwfCheckBox_VerifyExists (stepNum, stepName,expectedResult, page, object, expected, args)
' Date Created: 12/08/2023
' Date Modifed: -
' Created By: Keerthi Singh
' Description:  VerifyExists keyword for the SwfCheckBox type object
' Modification: -
'***************************************************************

Function SwfCheckBox_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

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
						actual = SwfWindow(swfWindowObj).SwfCheckBox(desc(0), desc(1),desc(2)).Exist(20)
					Else
						actual = SwfWindow(swfWindowObj).SwfCheckBox(desc(0)).Exist(20)
					End If	 
  
					logDetails = logDetails & " Actual: " &actual  
					result =  verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult )  

			End Select	
  
	End Select
	
End Function



'***************************************************************
' Function: SwfCheckBox_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 12/08/2023
' Date Modifed: -
' Created By: Keerthi Singh
' Description:  Verify property keword for the SwfCheckBox type object
'***************************************************************

Function SwfCheckBox_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

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
		
				Case "WAIT"
		   
					If InStr(desc(0), ":=") <> 0 Then   
					
						actual = SwfWindow(swfWindowObj).SwfCheckBox(desc(0), desc(1),desc(2)).WaitProperty(prop, expected, 10000)
					Else
						actual = SwfWindow(swfWindowObj).SwfCheckBox(desc(0)).WaitProperty(prop, expected, 10000)
					End If	 
  
					logDetails = logDetails & " Actual: " &actual  
					result =  verificationPoint(True, actual, logObject, logDetails, swfWindowObj, expectedResult) 
					
				Case "INSTRING"
		   
					If InStr(desc(0), ":=") <> 0 Then
						actual = SwfWindow(swfWindowObj).SwfCheckBox(desc(0), desc(1),desc(2)).GetROproperty(prop)
					Else
						actual = SwfWindow(swfWindowObj).SwfCheckBox(desc(0)).GetROproperty(prop)
					End If	 
  
					logDetails = logDetails & " Actual: " &actual  
					result =  verificationPointInstr(expected, actual, logObject, logDetails, swfWindowObj, expectedResult)
				
				Case Else
		   
					If InStr(desc(0), ":=") <> 0 Then
						actual = SwfWindow(swfWindowObj).SwfCheckBox(desc(0), desc(1),desc(2)).GetROproperty(prop)
					Else
						actual = SwfWindow(swfWindowObj).SwfCheckBox(desc(0)).GetROproperty(prop)
					End If	 
  
					logDetails = logDetails & " Actual: " &actual  
					result =  verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult) 

			End Select

	End Select
	
End Function

