'***************************************************************
' Function: WpfEdit_TypeText (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 07/19/2023
' Created By: Raghunath Konda
' Description:  TypeText keyword for the WpfEdit type object
'***************************************************************

Function WpfEdit_TypeText (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	wpfWindowObj = getFields(0,page , "-")
	wpfObj = getfieldsUpperNull(1,page , "-")
	
	If wpfObj = "" Then
		ident = "WpfWindow"
	Else
		ident = "WpfObject"  
	End If
	
'	'Parse property and expected result
	If instr(expected, ":=") <> 0 Then
		prop=getFields(0, expected, ":=")
	Else	
		prop = "text"
	End If
	expected=getFields(1, expected, ":=")
	expected=replaceConstants(expected)

'	'Parse object description
'	
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
	ElseIf expected = "CurrentPRTime" Then
		expected = Environment("CurrentPRTime")
	ElseIf instr(expected, "ENV_") Then	
		expected = Environment.Value(expected)
	End If
	
	expectedResult = "Verify user should be able to input "&Chr(34)&sValue&Chr(34)&" to the field"

  'Branch on argument
Select Case ident
 
 Case "WpfWindow"
  
	Select Case UCase(args)
	
		Case "NO VALIDATION"

			If InStr(desc(0), ":=") <> 0 Then
				WpfWindow(wpfWindowObj).WpfEdit(desc(0), desc(1),desc(2)).Set expected
			Else
				WpfWindow(wpfWindowObj).WpfEdit(desc(0)).Set expected
			End If
			result = verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult)

		Case "IFEXISTS"
				
			If InStr(desc(0), ":=") <> 0 Then
			  If WpfWindow(wpfWindowObj).WpfEdit(desc(0), desc(1),desc(2)).Exist(20) Then
			     WpfWindow(wpfWindowObj).WpfEdit(desc(0), desc(1),desc(2)).Set expected
				 actual = WpfWindow(wpfWindowObj).WpfEdit(desc(0), desc(1),desc(2)).GetROProperty(prop)
				 logDetails = logDetails & " Actual: " &actual				 
				 result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
			  End If
			Else
			  If WpfWindow(wpfWindowObj).WpfEdit(desc(0)).Exist(20) Then
			     WpfWindow(wpfWindowObj).WpfEdit(desc(0)).Set expected
			     actual = WpfWindow(wpfWindowObj).WpfEdit(desc(0)).GetROProperty(prop)
			     logDetails = logDetails & " Actual: " &actual				 
			     result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
			  End If
			End If
		
		Case "WO COMMIT"
				
			If InStr(object, ":=") <> 0 Then
				WpfWindow(wpfWindowObj).WpfEdit(desc(0), desc(1),desc(2)).Set expected,False
			Else
				WpfWindow(wpfWindowObj).WpfEdit(desc(0)).Set expected,False
			End If
			result =  verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult )

		Case Else

			If InStr(object, ":=") <> 0 Then
				WpfWindow(wpfWindowObj).WpfEdit(desc(0), desc(1),desc(2)).Set expected
				actual = WpfWindow(wpfWindowObj).WpfEdit(desc(0), desc(1),desc(2)).GetROProperty(prop)
			Else
				WpfWindow(wpfWindowObj).WpfEdit(desc(0)).Set expected
				actual = WpfWindow(wpfWindowObj).WpfEdit(desc(0)).GetROProperty(prop)
			End If
			logDetails = logDetails & " Actual: " &actual				 
			result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
			
		End Select
		
Case "WpfObject"		   
		
	Select Case UCase(args)
	
		Case "NO VALIDATION"

			If InStr(desc(0), ":=") <> 0 Then
				WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0), desc(1),desc(2)).Set expected
			Else
				WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0)).Set expected
			End If
			result = verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult)

		Case "IFEXISTS"
		
			If InStr(desc(0), ":=") <> 0 Then
				 If WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0), desc(1),desc(2)).Exist(20) Then
					WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0), desc(1),desc(2)).Set expected
					actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0), desc(1),desc(2)).GetROProperty(prop)
					logDetails = logDetails & " Actual: " &actual				 
					result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
				 End If
			Else
				If WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0)).Exist(20) Then
				   WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0)).Set expected
				   actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0)).GetROProperty(prop)
				   logDetails = logDetails & " Actual: " &actual				 
				   result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )
				End If
			End If
		
		Case "WO COMMIT"
			
			If InStr(object, ":=") <> 0 Then
				WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0), desc(1),desc(2)).Set expected,False
			Else
				WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0)).Set expected,False
			End If
			result =  verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult )

		Case Else

			If InStr(object, ":=") <> 0 Then
				WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0), desc(1),desc(2)).Set expected
				actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0), desc(1),desc(2)).GetROProperty(prop)
			Else
				WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0)).Set expected
				actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0)).GetROProperty(prop)
			End If
			 
			logDetails = logDetails & " Actual: " &actual				 
			result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )

	End Select
  
  End Select
  
End Function


'***************************************************************
' Function: WpfEdit_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 07/22/2023
' Created By: Raghunath Konda
' Description:  VerifyProperty keyword for the WpfEdit Verify Property
'***************************************************************

Function WpfEdit_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

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
				actual = WpfWindow(wpfWindowObj).WpfEdit(desc(0), desc(1),desc(2)).WaitProperty(prop, expected, 10000)
			Else
				actual = WpfWindow(wpfWindowObj).WpfEdit(desc(0)).WaitProperty(prop, expected, 10000)
			End If		  
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(True, actual, logObject, logDetails, wpfWindowObj, expectedResult)

		Case "INSTRING"

			If InStr(desc(0), ":=")  <> 0 Then
				actual = WpfWindow(wpfWindowObj).WpfEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
			Else
				actual = WpfWindow(wpfWindowObj).WpfEdit(desc(0)).GetROproperty(prop)
			End If
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPointInstr(expected, actual, logObject, logDetails , wpfWindowObj, expectedResult)

		Case Else
				
			If InStr(desc(0), ":=")  <> 0 Then
				actual = WpfWindow(wpfWindowObj).WpfEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
			Else
				actual = WpfWindow(wpfWindowObj).WpfEdit(desc(0)).GetROproperty(prop)
			End If
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )	   
	
		End Select

Case "WpfObject"	

  Select Case UCase(args)

		Case "WAIT"
			   
		    If InStr(desc(0), ":=") <> 0 Then
				actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0), desc(1),desc(2)).WaitProperty(prop, expected, 10000)
			Else
				actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0)).WaitProperty(prop, expected, 10000)
			End If		  
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(True, actual, logObject, logDetails, wpfWindowObj, expectedResult)

		Case "INSTRING"

			If InStr(desc(0), ":=")  <> 0 Then
				actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
			Else
				actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0)).GetROproperty(prop)
			End If
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPointInstr(expected, actual, logObject, logDetails , wpfWindowObj, expectedResult)

		Case Else
				
			If InStr(desc(0), ":=")  <> 0 Then
				actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
			Else
				actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0)).GetROproperty(prop)
			End If
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )	   
	
	End Select
		
End Select		

End Function

'***************************************************************
' Function: WpfEdit_GetProperty (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 06/25/2023
' Created By: Raghunath Konda
' Description:  GetProperty keyword for the WpfEdit Get Property
'***************************************************************

Function WpfEdit_GetProperty (stepNum, stepName, expectedResult, page, object, expected, args)

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

Select Case ident
  
  Case "WpfWindow"
  
	Select Case UCase(args)
	
		Case "IFEXISTS"
		
			If InStr(desc(0), ":=")  <> 0 Then
				  If WpfWindow(wpfWindowObj).WpfEdit(desc(0), desc(1),desc(2)).Exist(20) Then			
					 actual = WpfWindow(wpfWindowObj).WpfEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
				  Else 
					 actual = "NO_VALUE"
				  End If
			Else
				  If WpfWindow(wpfWindowObj).WpfEdit(desc(0)).Exist(20) Then			
					 actual = WpfWindow(wpfWindowObj).WpfEdit(desc(0)).GetROproperty(prop)
				  Else
				  	 actual = "NO_VALUE"
				  End If
			End If
			environment.Value(expected) = actual
		
		Case Else
		
	 		If InStr(desc(0), ":=")  <> 0 Then
				actual = WpfWindow(wpfWindowObj).WpfEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
			Else
				actual = WpfWindow(wpfWindowObj).WpfEdit(desc(0)).GetROproperty(prop)
			End If
			environment.Value(expected) = actual
			 
	End Select	
		
Case "WpfObject"

	Select Case UCase(args)

	  Case "IFEXISTS"
		
		  If InStr(desc(0), ":=")  <> 0 Then
			  If WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0), desc(1),desc(2)).Exist(20) Then			
				 actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
			  Else 
				 actual = "NO_VALUE"
			  End If	   
		  Else
			  If WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0)).Exist(20) Then			
				 actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0)).GetROproperty(prop)
			  Else 
				 actual = "NO_VALUE"
			  End If
		  End If
		  environment.Value(expected) = actual
		
	 Case Else
	 		
 		If InStr(desc(0), ":=")  <> 0 Then
			actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
		Else
			actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0)).GetROproperty(prop)
		End If
		environment.Value(expected) = actual
		
	End Select	
		
End Select
	
End Function


'***************************************************************
' Function: WpfEdit_Verifyexist (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 07/10/2023
' Created By: Raghunath Konda
' Description:  Verifyexist keyword for the WpfEdit Verify exist
'***************************************************************


Function WpfEdit_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

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
					actual = WpfWindow(wpfWindowObj).WpfEdit(desc(0), desc(1), desc(2)).Exist(20)
				Else
					actual = WpfWindow(wpfWindowObj).WpfEdit(desc(0)).Exist(20)
				End If
				result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult)  
		
		 End Select
		 
	 Case "WpfObject"
		  
		 Select Case UCase(args)
		
		  	Case Else
		  	
				If InStr(desc(0), ":=") Then
					actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0), desc(1), desc(2)).Exist(20)
				Else
					actual = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0)).Exist(20)
				End If
				result =  verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult)  
				
		  End Select		

	End Select		

End Function


'***************************************************************
' Function: WpfEdit_Click (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 06/27/2023
' Created By: Raghunath Konda
' Description:  Click keyword to Click on WpfEdit  

'***************************************************************   

Function WpfEdit_Click (stepNum, stepName, expectedResult, page, object, expected, args)

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
			
			Case "IFEXISTS"
				
				If InStr(desc(0), ":=") <> 0 Then
					 If WpfWindow(wpfWindowObj).WpfEdit(desc(0), desc(1),desc(2)).Exist(20) Then
					  	WpfWindow(wpfWindowObj).WpfEdit(desc(0), desc(1),desc(2)).Click
						logDetails = logDetails & " Actual: " &actual				 
						result =  verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult )
					 End If
				Else
					If WpfWindow(wpfWindowObj).WpfEdit(desc(0)).Exist(20) Then
						WpfWindow(wpfWindowObj).WpfEdit(desc(0)).Click
						logDetails = logDetails & " Actual: " &actual				 
						result =  verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult )
					End If
				End If
					
			Case Else
					
				If InStr(desc(0), ":=") <> 0 Then
					WpfWindow(wpfWindowObj).WpfEdit(desc(0), desc(1),desc(2)).Click
				Else
					WpfWindow(wpfWindowObj).WpfEdit(desc(0)).Click
				End If
				result = verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult)
		   
		End Select
	 
	 Case "WpfObject"
	
		Select Case UCase(args)
			
			Case "IFEXISTS"
					
				If InStr(desc(0), ":=") <> 0 Then
					 If WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0), desc(1),desc(2)).Exist(20) Then
					  	WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0), desc(1),desc(2)).Click
						logDetails = logDetails & " Actual: " &actual				 
						result =  verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult )
					 End If
				Else
					If WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0)).Exist(20) Then
						WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0)).Click
						logDetails = logDetails & " Actual: " &actual				 
						result =  verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult )
					End If
				End If
						
			Case Else
				
				If InStr(desc(0), ":=") <> 0 Then
					WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0), desc(1),desc(2)).Click
				Else
					WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfEdit(desc(0)).Click
				End If
				result = verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult)
		   
		End Select
	
	End Select
  
End Function


