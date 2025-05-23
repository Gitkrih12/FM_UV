
'***************************************************************
' Function: WinObject_Click (stepNum, stepName, page, object, expected, args)
' Date Created: 02/02/2023
' Date Modifed: 02/02/2023
' Created By: Shivani Raturi
' Description:  Click keyword for the WinObject type object

'***************************************************************   

Function WinObject_Click (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)
	
	'Parse Page Objects
	
	windowObj = getFields(0,page , "-")
	
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

Select Case UCase(args)
		
		Case "NO VALIDATION"

				If InStr(desc(0), ":=") <> 0 Then
				 	Window(windowObj).WinObject(desc(0), desc(1),desc(2)).Click
				Else
					Window(windowObj).WinObject(desc(0)).Click
				End If

				result = verificationPoint(True, True, logObject, logDetails, windowObj, expectedResult)
				
		Case "IFEXISTS"
				
				If InStr(desc(0), ":=") <> 0 Then
					  If Window(windowObj).WinObject(desc(0), desc(1),desc(2)).Exist Then
						  	Window(windowObj).WinObject(desc(0), desc(1),desc(2)).Click
							actual = Window(windowObj).WinObject(desc(0), desc(1),desc(2)).GetROProperty(prop)
							logDetails = logDetails & " Actual: " &actual				 
							result =  verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult )
					  End If
				Else
					If Window(windowObj).WinObject(desc(0)).Exist Then
						Window(windowObj).WinObject(desc(0)).Click
						actual = Window(windowObj).WinObject(desc(0)).GetROProperty(prop)
						logDetails = logDetails & " Actual: " &actual				 
						result =  verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult )
					End If
				End If
				
	
	
	Case Else


				If InStr(desc(0), ":=") <> 0 Then
					Window(windowObj).WinObject(desc(0), desc(1),desc(2)).Click
				Else
					Window(windowObj).WinObject(desc(0)).Click
				End If 	  
					 actual = Window(windowObj).WinObject(desc(0)).GetROProperty(prop)

				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails, windowObj, expectedResult)

		   
	End Select

End Function





Function WinObject_VerifyStatus (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)
	
	'Parse Page Objects
	
	windowObj = getFields(0,page , "-")
	
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

	Select Case UCase(args)
		
		Case "WORKFLOW"
			maxTimeout= expected 
			maxRegularInterval=20 
			maxIteration= (maxTimeout*60)/maxRegularInterval
			
			actual = False
			For mi = 1 To maxIteration Step 1
				workflow_status = Window("Workflow Monitor").WinObject("Workflow_Status").GetVisibleText
				initial_index= InStr(workflow_status,"Status")
				final_index = Instr(initial_index+9,workflow_status,chr(10))
				If final_index=0 Then
					Final_Status = Mid(workflow_status,initial_index+9)
				Else
					Final_Status = Mid(workflow_status,initial_index+9,final_index-initial_index-9)
				End If					
				
				If Final_Status="Succeeded" Then
					actual= True
			    	Exit For 
			    ElseIf Final_Status="Failed" OR  Final_Status="Stopped" OR Final_Status="Aborted" Then
			     	actual = False
			       	Exit For 
				else					
					wait 20					
				End If
			
			Next
						
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(True, actual, logObject, logDetails, windowObj, expectedResult )	 
		   
	End Select

End Function
