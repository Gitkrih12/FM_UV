
'***************************************************************
' Function: WpfImage_Click (stepNum, stepName, page, object, expected, args)
' Date Created: 03/04/2023
' Created By: Raghunath Konda
' Description:  Click keyword for the WpfImage type object
'***************************************************************   

Function WpfImage_Click (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	
	Dim prop, logObject, logDetails
	Dim desc(2)
	wpfWindowObj = getFields(0,page , "-")
	
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
						WpfWindow(wpfWindowObj).Wpfimage(desc(0), desc(1),desc(2)).Click
					Else
						WpfWindow(wpfWindowObj).Wpfimage(desc(0)).Click
					End If

					result = verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult)
		Case "IFEXISTS"
				
				If InStr(desc(0), ":=") <> 0 Then
					  If WpfWindow(wpfWindowObj).Wpfimage(desc(0), desc(1),desc(2)).Exist Then
						  	WpfWindow(wpfWindowObj).Wpfimage(desc(0), desc(1),desc(2)).Click
							actual = WpfWindow(wpfWindowObj).GetROproperty(prop)
							logDetails = logDetails & " Actual: " &actual				 
							result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
					  End If
				Else
					If WpfWindow(wpfWindowObj).Wpfimage(desc(0)).Exist Then
						WpfWindow(wpfWindowObj).Wpfimage(desc(0)).Click
						actual = WpfWindow(wpfWindowObj).GetROproperty(prop)
						logDetails = logDetails & " Actual: " &actual				 
						result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
					End If
				End If
				
	

	Case Else

			If InStr(desc(0), ":=") <> 0 Then
				WpfWindow(wpfWindowObj).Wpfimage(desc(0), desc(1),desc(2)).Click
			Else
				WpfWindow(wpfWindowObj).Wpfimage(desc(0)).Click
			End If	
			actual = WpfWindow(wpfWindowObj).GetROproperty(prop)
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult)	
	
	End Select

End Function


