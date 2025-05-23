'***************************************************************
' Function: WpfTabStrip_Select (stepNum, stepName, page, object, expected, args)
' Date Modifed: 12/10/2022
' Created By: Raghunath konda
' Description:  Select keyword for the WpfTabStrip type object

'***************************************************************

Function WpfTabStrip_Select (stepNum, stepName, expectedResult, page, object, expected, args)

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

Select Case UCase(args)
	
	Case "NO VALIDATION"

				If InStr(desc(0), ":=") <> 0 Then
				 	WpfWindow(wpfWindowObj).WpfTabStrip(desc(0), desc(1),desc(2)).Select expected
				Else
					WpfWindow(wpfWindowObj).WpfTabStrip(desc(0)).Select expected
				End If

				result = verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult)
				
	Case "IFEXISTS"
				
				If InStr(desc(0), ":=") <> 0 Then
					  If WpfWindow(wpfWindowObj).WpfTabStrip(desc(0), desc(1),desc(2)).Exist Then
					  		
						  	WpfWindow(wpfWindowObj).WpfTabStrip(desc(0), desc(1),desc(2)).Select expected
							actual = WpfWindow(wpfWindowObj).WpfTabStrip(desc(0), desc(1),desc(2)).GetROProperty("selection")
							logDetails = logDetails & " Actual: " &actual				 
							result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
					  End If
				Else
					If WpfWindow(wpfWindowObj).WpfTabStrip(desc(0)).Exist Then
						wait 4
						WpfWindow(wpfWindowObj).WpfTabStrip(desc(0)).Select expected
						actual = WpfWindow(wpfWindowObj).WpfTabStrip(desc(0)).GetROProperty("selection")
						logDetails = logDetails & " Actual: " &actual				 
						result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
					End If
				End If
				
	
	
	Case Else

			If InStr(desc(0), ":=") <> 0 Then
				WpfWindow(wpfWindowObj).WpfTabStrip(desc(0), desc(1),desc(2)).Select expected
				actual = WpfWindow(wpfWindowObj).WpfTabStrip(desc(0), desc(1),desc(2)).GetROProperty("selection")
			Else
				WpfWindow(wpfWindowObj).WpfTabStrip(desc(0)).Select expected
				actual = WpfWindow(wpfWindowObj).WpfTabStrip(desc(0)).GetROProperty("selection")
			End If		
			logDetails = logDetails & " Actual: " &actual				 
			result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
		
	End Select	
End Function



