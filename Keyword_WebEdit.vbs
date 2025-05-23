
'***************************************************************
'File Name: Keyword_WebEdit.vbs
'Date Ceated: 12/27/2006
'Created By: Chris Thompson & Steve Truong
'Description: Library contains all keyword functions for the WebEdit object type
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
' Function: WebEdit_TypeText (stepNum, stepName, page, object, sValue, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  TypeText keyword for the WebEdit type object
' Modifications: 03/15/07, BW, Added Timestamp arguement to handle Timestamp value in sValue
'***************************************************************

Function WebEdit_TypeText (stepNum, stepName, expectedResult, page, object, sValue, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	windowObj = getfieldsUpperNull(3,page , "-")
	frameObj=getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")

	If windowObj = "" AND frameObj = "" Then
		ident = "None"
	ElseIf windowObj = "" Then
		ident = "Frame"
	Else
		ident = "Window"	
	End If
	
	'Parse property and expected result

	prop=getFields(0, sValue, ":=")
	sValue=getFields(1, sValue, ":=")

	'Parse object description
	
	desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")

	'Set up log results

	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	If (args = "") Then
		logDetails= "Expected:  " &sValue &CHR(13)
	Else
		logDetails= "Expected: (" &args &")  " &sValue &CHR(13)
	End If

' Convert Datestamp

	If sValue = "Environment('Datestamp')" Then
		sValue = environment("Datestamp")
	Elseif instr (sValue,"Environment('Datestamp')<") Then
		expected = getfields(2,sValue,"<")
		expected = mid(expected,1,len(expected)-1)
		Call Utility_GenDatestamp(stepNum, stepName,expectedResult, page, object, expected, "Run Time")  
		sValue = environment("Datestamp")
	Elseif sValue = "Environment('sData')" Then
		sValue = Environment("sData")
	Elseif sValue = "Environment('Timestamp')" Then
		sValue = Environment("Timestamp")
	ElseIf sValue = "TestVariable" Then
		sValue = Environment("TestVariable")
	End If
	expectedResult = "Verify user should be able to input "&Chr(34)&sValue&Chr(34)&" to the field"
  'Branch on argument

	Select Case ident

	Case "None"

		Select Case UCase(args)
			
			Case "MOUSEOVERCLICK"
					
					Setting.WebPackage("ReplayType") = 2
					If InStr(desc(0), ":=") Then
						Browser(browserObj).Page(page).WebEdit(desc(0), desc(1),desc(2)).Set sValue
						actual = Browser( browserObj).Page(page).WebEdit(desc(0), desc(1),desc(2)).GetROProperty("value")
					Else
						Browser(browserObj).Page(page).WebEdit(desc(0)).Set sValue
						actual = Browser( browserObj).Page(page).WebEdit(desc(0)).GetROProperty("value")
					End If
				       	Setting.WebPackage("ReplayType") = 1	   
				If sValue <> "" Then
					result =  verificationPoint(sValue, actual, logObject, logDetails, browserObj, expectedResult )
				End If
		Case  Else

				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).WebEdit(desc(0), desc(1),desc(2)).Set sValue
					actual = Browser( browserObj).Page(page).WebEdit(desc(0), desc(1),desc(2)).GetROProperty("value")
				Else
					Browser(browserObj).Page(page).WebEdit(desc(0)).Set sValue
					actual = Browser( browserObj).Page(page).WebEdit(desc(0)).GetROProperty("value")
				End If
				       		   
				If sValue <> "" Then
					result =  verificationPoint(sValue, actual, logObject, logDetails, browserObj, expectedResult )
							
				End If
			   
		End Select

	Case "Frame"

		Select Case UCase(args)

			Case "DIALOG"

				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).Set sValue
					If Browser("Provider Module").Dialog("Dialog").Exist  Then
					Browser("Provider Module").Dialog("Dialog").winbutton("Yes").Click
					End If
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).GetROProperty("value")
				Else
					Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).Set sValue
					If Browser(browserObj).Dialog("Dialog").Exist  Then
					Browser(browserObj).Dialog("Dialog").winbutton("Yes").Click
					End If
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).GetROProperty("value")
				End If
				
				result = verificationPoint(expected,actual, logObject, logDetails, browserObj, expectedResult)
				
			Case "NO VALIDATION"

				  If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).Set sValue
					
				Else
					Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).Set sValue
				End If
				
				result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)
				
			Case "WO COMMIT"

				  If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).Set sValue,False
					
				Else
					Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).Set sValue,False
				End If
				
				result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)

			Case "IFEXISTS"
				
				If InStr(desc(0), ":=") Then
					  If Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).Exist Then
						  	Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).Set sValue
							actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).GetROProperty("value")
							result = verificationPoint(sValue,actual, logObject, logDetails, browserObj, expectedResult)					  		
					  End If
				Else
					If Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).Exist Then
						Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).Set sValue
						actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).GetROProperty("value")
						result = verificationPoint(sValue,actual, logObject, logDetails, browserObj, expectedResult) 
					End If
				End If
		
		Case "MOUSEOVERCLICK"
		
			Setting.WebPackage("ReplayType") = 2
				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).Set sValue
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).GetROProperty("value")
				Else
					Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).Set sValue
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).GetROProperty("value")
				End If
			       	Setting.WebPackage("ReplayType") = 1	   
			If sValue <> "" Then
				result =  verificationPoint(sValue, actual, logObject, logDetails, browserObj, expectedResult )
			End If
			
		Case Else
  		
				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).Set sValue
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).GetROProperty("value")
				Else
					Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).Set sValue
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).GetROProperty("value")
				End If      		   

				 If sValue <> "" Then
					result =  verificationPoint(sValue, actual, logObject, logDetails, browserObj, expectedResult )
				End If
			   
		End Select

	Case "Window"

		Select Case UCase(args)

			Case "DOUBLE WINDOW"

				  If InStr(desc(0), ":=") Then
					Browser(browserObj).window(WindowObj).window(WindowObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).Set sValue
					actual = Browser( browserObj).window(WindowObj).window(WindowObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).GetROProperty("value")
				Else
					Browser(browserObj).window(WindowObj).window(WindowObj).Page(page).Frame(frameObj).WebEdit(desc(0)).Set sValue
					actual = Browser( browserObj).window(WindowObj).window(WindowObj).Page(page).Frame(frameObj).WebEdit(desc(0)).GetROProperty("value")
				End If

			Case "NO VALIDATION"

				  If InStr(desc(0), ":=") Then
					Browser(browserObj).window(WindowObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).Set sValue
					actual = Browser( browserObj).window(WindowObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).GetROProperty("value")
				Else
					Browser(browserObj).window(WindowObj).Page(page).Frame(frameObj).WebEdit(desc(0)).Set sValue
					actual = Browser( browserObj).window(WindowObj).Page(page).Frame(frameObj).WebEdit(desc(0)).GetROProperty("value")
				End If

			Case Else
			
			   If InStr(desc(0), ":=") Then
					Browser(browserObj).window(WindowObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).Set sValue
					actual = Browser( browserObj).window(WindowObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).GetROProperty("value")
				Else
					Browser(browserObj).window(WindowObj).Page(page).Frame(frameObj).WebEdit(desc(0)).Set sValue
					actual = Browser( browserObj).window(WindowObj).Page(page).Frame(frameObj).WebEdit(desc(0)).GetROProperty("value")
				End If      		    

				If sValue <> "" Then
					result =  verificationPoint(sValue, actual, logObject, logDetails, browserObj, expectedResult )
				End If
	
		End Select

	End Select
  	
End Function


'***************************************************************
' Function: WebEdit_VerifyProperty (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  Verify Property keyword for the WebEdit type object
' Modification: 03/30/07, BW, Added Timestamp arguement to handle verifying timestamp value
'***************************************************************

Function WebEdit_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	windowObj = getfieldsUpperNull(3,page , "-")
	frameObj=getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")

	If windowObj = "" AND frameObj = "" Then
		ident = "None"
	ElseIf windowObj = "" Then
		ident = "Frame"
	Else
		ident = "Window"	
	End If
	
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
	End If

	Select Case ident

	Case "None"
 
		Select Case UCase(args)

			Case "WAIT"
			    If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).WebEdit(desc(0), desc(1),desc(2)).WaitProperty(prop, expected, 10000)
				Else
					actual = Browser(browserObj).Page(page).WebEdit(desc(0)).WaitProperty(prop, expected, 10000)
				End If		  
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(True, actual, logObject, logDetails, browserObj, expectedResult)

			'Verify Instring  
			Case "INSTRING"

				If InStr(desc(0), ":=") Then
					actual = Browser( browserObj).Page(page).WebEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
				Else
					actual = Browser( browserObj).Page(page).WebEdit(desc(0)).GetROproperty(prop)
				End If
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPointInstr(expected, actual, logObject, logDetails , browserObj, expectedResult)
			   
			'No Argument     
			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser( browserObj).Page(page).WebEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
				Else
					actual = Browser( browserObj).Page(page).WebEdit(desc(0)).GetROproperty(prop)
				End If
			
			   logDetails = logDetails & " Actual: " &actual  
			   result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )	   
			   
			End Select

	Case "Window"

		Select Case UCase(args)

				 'Verify Instring  
				Case "INSTRING"

				If InStr(desc(0), ":=") Then
					actual = Browser( browserObj).Window(windowobj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
				Else
					actual = Browser( browserObj).Window(windowobj).Page(page).Frame(frameObj).WebEdit(desc(0)).GetROproperty(prop)
				End If
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult )
				
			Case Else
				If Instr(desc(0), ":=") Then
					actual = Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1), desc(2)).GetROProperty(prop)
				Else
					actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebEdit(desc(0)).GetROProperty(prop)
				End If

				logDetails = logDetails & " Actual: " &actual
				result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)

		End Select

	Case "Frame"
	
		Select Case UCase(args)

			 'Verify Instring  
			Case "INSTRING"

				If InStr(desc(0), ":=") Then
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
				Else
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).GetROproperty(prop)
				End If
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult )
				
			Case "COMPARE"

				If InStr(desc(0), ":=") Then
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
				Else
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).GetROproperty(prop)
				End If
				logDetails = logDetails & " Actual: " &actual
				
				If IsDate(actual) Then
					actual = CDAte(actual)
				End If

				result = verificationPointCmp(expected, actual, logObject, logDetails, browserObj, expectedResult, comparisonFactor)

			Case Else
		
			If InStr(desc(0), ":=") Then
				actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).GetROproperty(prop) 
			Else
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).GetROproperty(prop)
			End If

			logDetails = logDetails & " Actual: " &actual
			result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)

		End Select

	End Select
		
End Function


'***************************************************************
' Function: WebEdit_VerifyExists (stepNum, stepName, page, object, expected, args)
' Date Created: 01/25/2007
' Date Modifed: 01/25/2007
' Created By: Chris Thompson & Steve Truong & Ben Wu
' Description:  VerifyExists keyword for the WebEdit type object
'***************************************************************

Function WebEdit_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

   	browserObj = getFields(0,page , "-")
	windowObj = getfieldsUpperNull(3,page , "-")
	frameObj=getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")

	If windowObj = "" AND frameObj = "" Then
		ident = "None"
	ElseIf windowObj = "" Then
		ident = "Frame"
	Else
		ident = "Window"	
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

	Case "None"

		Select Case UCase(args)

			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).WebEdit(desc(0), desc(1), desc(2)).Exist
				Else
					actual = Browser(browserObj).Page(page).WebEdit(desc(0)).Exist
				End If

		result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)    
				
		End Select

	Case "Window"

		Select Case UCase(args)

			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).window(windowobj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1), desc(2)).Exist
				Else
					actual = Browser(browserObj).window(windowobj).Page(page).Frame(frameObj).WebEdit(desc(0)).Exist
				End If

				result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult) 
 
		End Select		

	Case "Frame"

		Select Case  UCase(args)

			Case Else
			
			If InStr(desc(0), ":=") Then
				actual = Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1), desc(2)).Exist
			Else
				actual = Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).Exist
			End If

			result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult) 

		End Select

	End Select				
 	   
End Function

'***************************************************************
' Function: WebEdit_Click (stepNum, stepName, page, object, expected, args)
' Date Created: 01/25/2007
' Date Modifed: 01/25/2007
' Created By: Chris Thompson & Steve Truong & Ben Wu
' Description:  VerifyExists keyword for the WebEdit type object
'***************************************************************

Function WebEdit_Click (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

    browserObj = getFields(0,page , "-")
	windowObj = getfieldsUpperNull(3,page , "-")
	frameObj=getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")

	If windowObj = "" AND frameObj = "" Then
		ident = "None"
	ElseIf windowObj = "" Then
		ident = "Frame"
	Else
		ident = "Window"	
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

	Case "None"

		Select Case UCase(args)

			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser( browserObj).Page(page).WebEdit(desc(0), desc(1),desc(2)).Click
				Else
					actual = Browser( browserObj).Page(page).WebEdit(desc(0)).Click
				End If

			End Select
	
	Case "Frame"

		Select Case UCase(args)

			Case "IFEXISTS"
				
				If InStr(desc(0), ":=") Then
					  If Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).Exist Then
						  	actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).Click
					  End If
				Else
					If Browser(browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).Exist Then
					   actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).Click
					End If
				End If
			
			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2)).Click
				Else
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0)).Click
				End If

		End Select

	End Select

End Function


'***************************************************************
' Function: WebEdit_GetProperty (stepNum, stepName, page, object, expected, args)
' Date Created: 02/03/2021
' Date Modifed: 02/03/2021
' Created By: Sameen Hashmi
' Description:  Get Property keyword for the WebEdit type object
' Modification: 
'***************************************************************

Function WebEdit_GetProperty(stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables	
	Dim prop
	Dim desc(2)

	'Parse Page Objects
	browserObj = getFields(0,page , "-")
	windowObj = getfieldsUpperNull(3,page , "-")
	frameObj=getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")

	If windowObj = "" AND frameObj = "" Then
		ident = "None"
	ElseIf windowObj = "" Then
		ident = "Frame"
	Else
		ident = "Window"	
	End If

	'Parse object description	
	desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")

	Select Case ident

	Case "None"
 
		If InStr(desc(0), ":=") Then
			Set testObj = Browser( browserObj).Page(page).WebEdit(desc(0), desc(1),desc(2)) 
		Else
			Set testObj = Browser( browserObj).Page(page).WebEdit(desc(0))
		End If	   

	Case "Frame"
	
		If InStr(desc(0), ":=") Then
			Set testObj = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0), desc(1),desc(2))
		Else
			Set testObj = Browser( browserObj).Page(page).Frame(frameObj).WebEdit(desc(0))
		End If

	End Select
	
	Environment("TestVariable") = testObj.GetROproperty(expected)
		
End Function
