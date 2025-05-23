'***************************************************************
'File Name: Keyword_SwfObject.vbs
'Date Ceated: 12/19/2023
'Created By: Shivani Raturi
'Description: Library contains all keyword functions for the SwfObject object type
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
' Function: SwfObject_Click (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 12/19/2023
' Created By: Shivani Raturi
' Description: Click  keyword for the SwfObject type object

'***************************************************************   

Function SwfObject_Click (stepNum, stepName, expectedResult, page, object, expected, args)

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
					 	SwfWindow(swfWindowObj).SwfObject(desc(0), desc(1),desc(2)).Click
					Else
						SwfWindow(swfWindowObj).SwfObject(desc(0)).Click
					End If
					result = verificationPoint(True, True, logObject, logDetails, swfWindowObj, expectedResult)
				
				 Case "IFEXISTS"
				
					If InStr(desc(0), ":=") <> 0 Then
						  If SwfWindow(swfWindowObj).SwfObject(desc(0), desc(1),desc(2)).Exist(20) Then
							  	SwfWindow(swfWindowObj).SwfObject(desc(0), desc(1),desc(2)).Click
								actual = SwfWindow(swfWindowObj).SwfObject(desc(0), desc(1),desc(2)).GetROProperty(prop)
								logDetails = logDetails & " Actual: " &actual				 
								result =  verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult )
						  End If
					Else
						If SwfWindow(swfWindowObj).SwfObject(desc(0)).Exist(20) Then
							SwfWindow(swfWindowObj).SwfObject(desc(0)).Click
							actual = SwfWindow(swfWindowObj).SwfObject(desc(0)).GetROProperty(prop)
							logDetails = logDetails & " Actual: " &actual				 
							result =  verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult )
						End If
					End If		

				 Case Else
					
					If InStr(desc(0), ":=") <>0 Then
						SwfWindow(swfWindowObj).SwfObject(desc(0), desc(1),desc(2)).Click
						actual = SwfWindow(swfWindowObj).SwfObject(desc(0), desc(1),desc(2)).GetROProperty(prop)
					Else
						SwfWindow(swfWindowObj).SwfObject(desc(0)).Click
						actual = SwfWindow(swfWindowObj).SwfObject(desc(0)).GetROProperty(prop)
					End If 	  
					 
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(expected, actual, logObject, logDetails, swfWindowObj, expectedResult)
				
			End Select
	
	End  Select 
	
End Function
