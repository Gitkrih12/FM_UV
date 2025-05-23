'***************************************************************
' Function: WpfComboBox_Select (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Modifed: 02/10/2023
' Created By: Raghunath konda
' Description:  Select keyword for the WpfComboBox Select

'***************************************************************

Function WpfComboBox_Select (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)
	wpfWindowObj = getFields(0,page , "-")
	wpfObj = getfieldsUpperNull(1,page , "-")
	
	If wpfObj = "" Then
		ident = "WpfWindow"
	Else
		ident = "WpfObject"  
	End If
	
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

	Select Case ident
	  
	  Case "WpfWindow"
		
		Select Case UCase(args)
		
			Case "NO VALIDATION"
	
				If InStr(desc(0), ":=") <> 0 Then
				 	WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).Select expected
				Else
					WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).Select expected
				End If
				result = verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult)

			Case "IFEXISTS"
					
				If InStr(desc(0), ":=") <> 0 Then
				  If WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).Exist(20) Then
				  	 WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).Select expected
					 actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).GetROProperty(prop)
					 logDetails = logDetails & " Actual: " &actual				 
					 result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
				  End If
				Else
				  If WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).Exist(20) Then
				 	 WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).Select expected
					 actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).GetROProperty(prop)
					 logDetails = logDetails & " Actual: " &actual				 
					 result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
				   End If
				End If
		
			Case "VISIBLE"
					
				If InStr(desc(0), ":=") <> 0 Then
				  If WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).GetROProperty("visible") Then
					 WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).Select expected
					 actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).GetROProperty(prop)
					 logDetails = logDetails & " Actual: " &actual				 
					 result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
				  End If
				Else
				  If WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).GetROProperty("visible") Then
					 WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).Select expected
					 actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).GetROProperty(prop)
					 logDetails = logDetails & " Actual: " &actual				 
					 result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
				  End If
				End If
			
			Case Else
	
				If InStr(desc(0), ":=") <> 0 Then
					WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).Select expected
					actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).GetROProperty(prop)
				Else
					WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).Select expected
					actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).GetROProperty(prop)
				End If	
				logDetails = logDetails & " Actual: " &actual				 
				result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )

			End Select
			
	Case "WpfObject"
		
     	Select Case UCase(args)
		
			Case "NO VALIDATION"
	
				If InStr(desc(0), ":=") <> 0 Then
				 	WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).Select expected
				Else
					WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).Select expected
				End If
				result = verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult)

			Case "IFEXISTS"
					
				If InStr(desc(0), ":=") <> 0 Then
				  If WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).Exist(20) Then
				     WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).Select expected
					 actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).GetROProperty(prop)
					 logDetails = logDetails & " Actual: " &actual				 
					 result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
				  End If
				Else
				  If WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).Exist(20) Then
				     WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).Select expected
				     actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).GetROProperty(prop)
				     logDetails = logDetails & " Actual: " &actual				 
				     result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
				  End If
				End If
		
			Case "VISIBLE"
					
				If InStr(desc(0), ":=") <> 0 Then
					  If WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).GetROProperty("visible")  Then
						 WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).Select expected
						 actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).GetROProperty(prop)
						 logDetails = logDetails & " Actual: " &actual				 
						 result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
					  End If
				Else
					  If WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).GetROProperty("visible") Then
					     WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).Select expected
				         actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).GetROProperty(prop)
					     logDetails = logDetails & " Actual: " &actual				 
					     result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
					  End If
				End If
		
			Case Else
	
				If InStr(desc(0), ":=") <> 0 Then
					WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).Select expected
					actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).GetROProperty(prop)
				Else
					WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).Select expected
					actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).GetROProperty(prop)
				End If	
						
				logDetails = logDetails & " Actual: " &actual				 
				result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
	
		End Select
		
	End Select		
	
End Function

'***************************************************************
' Function: WpfComboBox_TypeText (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Modifed: 02/10/2023
' Created By: Raghunath konda
' Description:  TypeText keyword for the WpfComboBox type object

'***************************************************************

Function WpfComboBox_TypeText (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)
	wpfWindowObj = getFields(0,page , "-")
	wpfObj = getfieldsUpperNull(1,page , "-")
	
	If wpfObj = "" Then
		ident = "WpfWindow"
	Else
		ident = "WpfObject"  
	End If
	
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
	

	If instr(expected, "ENV_") Then	
		expected = Environment.Value(expected)
	End If
	Select Case ident
	  
	  Case "WpfWindow"
	  
		Select Case UCase(args)
	
			Case "NO VALIDATION"
	
				If InStr(desc(0), ":=") <> 0 Then
				 	WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).Type expected
				Else
					WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).Type expected
				End If
				result = verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult)

			Case "IFEXISTS"
				
				If InStr(desc(0), ":=") <> 0 Then
				  If WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).Exist(20) Then
					 WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).Type expected
					 actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).GetROProperty(prop)
					 logDetails = logDetails & " Actual: " &actual				 
					 result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
				  End If
				Else
				  If WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).Exist(20) Then
				   	 WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).Type expected
					 actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).GetROProperty(prop)
					 logDetails = logDetails & " Actual: " &actual				 
					 result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
					End If
				End If
		
			Case Else
	
				If InStr(desc(0), ":=") <> 0 Then
					WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).Type expected
					actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).GetROProperty(prop)
				Else
					WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).Type expected
					actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).GetROProperty(prop)
				End If	
				logDetails = logDetails & " Actual: " &actual				 
				result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
	
		End Select
		
	Case "WpfObject"
	
		Select Case UCase(args)
	
			Case "NO VALIDATION"
	
				If InStr(desc(0), ":=") <> 0 Then
				 	WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).Type expected
				Else
					WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).Type expected
				End If
				result = verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult)
		
		Case "IFEXISTS"
					
			If InStr(desc(0), ":=") <> 0 Then
			  If WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).Exist(20) Then
				 WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).Type expected
				 actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).GetROProperty(prop)
				 logDetails = logDetails & " Actual: " &actual				 
				 result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
			  End If
			Else
			  If WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).Exist(20) Then
			     WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).Type expected
				 actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).GetROProperty(prop)
				 logDetails = logDetails & " Actual: " &actual				 
				 result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
				End If
			End If
					
		Case Else
	
			If InStr(desc(0), ":=") <> 0 Then
				WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).Type expected
				actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).GetROProperty(prop)
			Else
				WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).Type expected
				actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).GetROProperty(prop)
			End If	
			logDetails = logDetails & " Actual: " &actual				 
			result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )

		End Select
		
	End Select
	
End Function



'***************************************************************
' Function: WpfComboBox_Verifyexist (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 02/10/2023
' Created By: Raghunath Konda
' Description:  Verifyexist keyword for the WpfComboBox Verify exist
'***************************************************************

Function WpfComboBox_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)
	wpfWindowObj = getFields(0,page , "-")
	wpfObj = getfieldsUpperNull(1,page , "-")
	
	If wpfObj = "" Then
		ident = "WpfWindow"
	Else
		ident = "WpfObject"  
	End If
	
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

	Select Case ident
	        
	   Case "WpfWindow"
	 
		 Select Case UCase(args)
	
	  	  Case Else
	 
			If InStr(desc(0), ":=") Then
				actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1), desc(2)).Exist(20)
			Else
				actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).Exist(20)
			End If
			logDetails = logDetails & " Actual: " &actual  
			result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult)  
			
		  End Select		
	
	   Case "WpfObject"
		
		  Select Case UCase(args)
	
	  		Case Else
				
				If InStr(desc(0), ":=") Then
				   actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1), desc(2)).Exist(20)
				Else
				   actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).Exist(20)
				End If
				logDetails = logDetails & " Actual: " &actual  
				result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult)  
							
		  End Select		
		
	End Select		
	
End Function


'***************************************************************
' Function: WpfComboBox_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 06/10/2023
' Created By: Raghunath Konda
' Description:  VerifyProperty keyword for the WpfComboBox's Verify Property
'***************************************************************

Function WpfComboBox_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)
	wpfWindowObj = getFields(0,page , "-")
	wpfObj = getfieldsUpperNull(1,page , "-")
	
	If wpfObj = "" Then
		ident = "WpfWindow"
	Else
		ident = "WpfObject"  
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
	ElseIf instr(expected, "ENV_") Then	
		expected = Environment.Value(expected)
	End If

	Select Case ident
	  
	  Case "WpfWindow"
	
		Select Case UCase(args)
	  	
			Case "WAIT"
					  
			 	If InStr(desc(0), ":=") <> 0 Then
					actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).WaitProperty(prop, expected, 10000)
				Else
					actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).WaitProperty(prop, expected, 10000)
				End If		  
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(True, actual, logObject, logDetails, wpfWindowObj, expectedResult)
		
			Case "INSTRING"
		
				If InStr(desc(0), ":=")  <> 0 Then
					actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).GetROproperty(prop) 
				Else
					actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).GetROproperty(prop)
				End If
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPointInstr(expected, actual, logObject, logDetails , wpfWindowObj, expectedResult)
			
			Case Else
					
				If InStr(desc(0), ":=")  <> 0 Then
					actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0), desc(1),desc(2)).GetROproperty(prop) 
				Else
					actual = WpfWindow(wpfWindowObj).WpfComboBox(desc(0)).GetROproperty(prop)
				End If
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )	   
	
		 End Select
		
	 Case "WpfObject"	
	
		  Select Case UCase(args)
		
			Case "WAIT"
					   
			   If InStr(desc(0), ":=") <> 0 Then
					actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).WaitProperty(prop, expected, 10000)
				Else
					actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).WaitProperty(prop, expected, 10000)
				End If		  
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(True, actual, logObject, logDetails, wpfWindowObj, expectedResult)
		
			Case "INSTRING"
		
				If InStr(desc(0), ":=")  <> 0 Then
					actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).GetROproperty(prop) 
				Else
					actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).GetROproperty(prop)
				End If
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPointInstr(expected, actual, logObject, logDetails , wpfWindowObj, expectedResult)
			
			Case Else
				
				If InStr(desc(0), ":=")  <> 0 Then
					actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0), desc(1),desc(2)).GetROproperty(prop) 
				Else
					actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfComboBox(desc(0)).GetROproperty(prop)
				End If
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )	   
				
		End Select
		
	 End Select		

End Function

