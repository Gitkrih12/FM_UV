'***************************************************************
'File Name: Keyword_WebButton.vbs
'Date Ceated: 12/27/2006
'Created By: Chris Thompson & Steve Truong
'Description: Library contains all keyword functions for the WebButton object type
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
' Function: WebButton_Click (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 05/21/2021
' Created By: Chris Thompson
' Updated by : Sameen Hashmi - Included the IfExists condition to handle dynamic runtime pop-up
' Description:  Click keyword for the WebButton type object

'***************************************************************   

Function WebButton_Click (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	windowObj = getfieldsUpperNull(3,page , "-")
	frameObj = getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")

	If windowObj = "" AND frameObj = "" Then
		ident = "None"
	ElseIf windowObj = "" Then
		ident = "Frame"
	Else
		ident = "Window"	
	End If

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

	Case "None"

		Select Case UCase(args)

			Case "INSTRING"

				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).WebButton(desc(0), desc(1),desc(2)).Click
				Else
					Browser(browserObj).Page(page).WebButton(desc(0)).Click
				End If
				Wait(2)
				actual = Browser(browserObj).Page("title:=.*").GetROProperty(prop) 	  
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult)   

			Case "NO VALIDATION"

					If InStr(desc(0), ":=") Then
						Browser(browserObj).Page(page).WebButton(desc(0), desc(1),desc(2)).Click
					Else
						Browser(browserObj).Page(page).WebButton(desc(0)).Click
					End If
	
					result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)

			Case "DIALOG"

					If InStr(desc(0), ":=") Then
						Browser(browserObj).Page(page).WebButton(desc(0), desc(1),desc(2)).Click
					Else
						Browser(browserObj).Page(page).WebButton(desc(0)).Click
					End If 	  
						 actual = Browser(browserObj).Page(page).GetROproperty(prop)
				  
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)

			Case "POPUP"

				If InStr(desc(0), ":=") Then
					Browser( browserObj ).Page(page).WebButton(desc(0), desc(1),desc(2)).Click
				Else
					Browser( browserObj ).Page(page).WebButton(desc(0)).Click
				End If	
				actual = Browser(getFields(0,expected,"-")).Page(getFields(1,expected,"-")).Exist	 
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(TRUE, actual, logObject, logDetails, browserObj, expectedResult)		

			Case "WAIT"
				If InStr(desc(0), ":=") Then
					Browser(browserObj ).Page(page).WebButton(desc(0), desc(1),desc(2)).Click
				Else
					Browser(browserObj ).Page(page).WebButton(desc(0)).Click
				End If	
				Browser(browserObj).Page(page).WaitProperty "url", micRegExpMatch(expected), 5000
				actual = Browser(browserObj).Page("title:=.*").GetROproperty(prop)	 
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)
				
			Case "IFEXISTS"
			If InStr(desc(0), ":=") Then
					If Browser(browserObj).Page(page).WebButton(desc(0), desc(1),desc(2)).Exist(10) Then
						Browser(browserObj).Page(page).WebButton(desc(0), desc(1),desc(2)).Click
						result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)
					End If
				Else
					If Browser(browserObj).Page(page).WebButton(desc(0)).Exist(10) Then
						Browser(browserObj).Page(page).WebButton(desc(0)).Click
						result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)
					End If	
				End If
				
			Case "MOUSEOVERCLICK"
			
				Setting.WebPackage("ReplayType") = 2
'				wait 2
				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).WebButton(desc(0), desc(1),desc(2)).Click
				Else
					Browser(browserObj).Page(page).WebButton(desc(0)).Click
				End If 	  
				Setting.WebPackage("ReplayType") = 1
				 actual = Browser(browserObj).Page(page).GetROproperty(prop)
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)

			
			Case Else

				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).WebButton(desc(0), desc(1),desc(2)).Click
				Else
					Browser(browserObj).Page(page).WebButton(desc(0)).Click
				End If 	  
					 actual = Browser(browserObj).Page(page).GetROproperty(prop)

				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)

			End Select
				
		Case "Window"		

			Select Case UCase(args)

			Case "IFEXISTS"
				If Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).Exist Then
					Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebButton(desc(0)).Click
				End If

			Case "DOUBLE WINDOW"             'This argument handles situation when a Window Object appears on top of another Window Object.    - Jason 4/10/2009
																				'The second Window must be manually nested within the first Window in the OR.  Also the second Window Object must be named the same as the first  Window Object. 
				If instr (desc(0), ":=") Then
					Browser(browserObj).Window(windowObj).Window(windowObj).Page(page).Frame(frameObj).WebButton(desc(0), desc(1), desc(2)).Click
					Else
                    Browser(browserObj).Window(windowObj).Window(windowObj).Page(page).Frame(frameObj).WebButton(desc(0)).Click
				End If
					actual = Browser(browserObj).Window(windowObj).GetROproperty(prop)

			Case "NO VALIDATION"

				If InStr(desc(0), ":=") Then
					Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebButton(desc(0), desc(1),desc(2)).Click
				Else
					Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebButton(desc(0)).Click
				End If	
			  	
			Case "DIALOG"

				If InStr(desc(0), ":=") Then
					Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebButton(desc(0), desc(1),desc(2)).Click
				Else
					Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebButton(desc(0)).Click
				End If 	  
					 actual = Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).GetROproperty(prop)
			  
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)

				If Browser(browserObj).Window(windowobj).Dialog("Dialog").Exist  Then
					Browser(browserObj).Window(windowobj).Dialog("Dialog").winbutton("OK").Click
				End If
				
			Case Else

					If InStr(desc(0), ":=") Then
						Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebButton(desc(0), desc(1),desc(2)).Click
					Else
						Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebButton(desc(0)).Click
					End If
		  
				End Select

		Case "Frame"

			Select Case UCase(args)

				Case "INSTRING"

					If InStr(desc(0), ":=") Then
						Browser(browserObj).Page(page).Frame(frameObj).WebButton(desc(0), desc(1),desc(2)).Click
					Else
						Browser(browserObj).Page(page).Frame(frameObj).WebButton(desc(0)).Click
					End If
					  actual = Browser(browserObj).Page("title:=.*").GetROProperty(prop) 	  
					LogDetails = logDetails & " Actual: " &actual  
					result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult)

				Case "NO VALIDATION"

					If InStr(desc(0), ":=") Then
						Browser(browserObj).Page(page).Frame(frameObj).WebButton(desc(0), desc(1),desc(2)).Click
					Else
						Browser(browserObj).Page(page).Frame(frameObj).WebButton(desc(0)).Click
					End If
					result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)

				Case "DIALOG"

					If InStr(desc(0), ":=") Then
						Browser(browserObj).Page(page).Frame(frameObj).WebButton(desc(0), desc(1),desc(2)).Click
					Else
						Browser(browserObj).Page(page).Frame(frameObj).WebButton(desc(0)).Click
					End If
					actual = Browser(browserObj).Page(page).GetROproperty(prop) 	  

					If Browser(browserObj).Dialog("Dialog").winbutton("Yes").Exist Then
						Browser(browserObj).Dialog("Dialog").winbutton("Yes").Click
					End If  
					
					  If Browser("Provider Module").Dialog("Dialog").Exist  Then
						Browser("Provider Module").Dialog("Dialog").winbutton("OK").Click
					End If
					
					result = verificationPoint(expected,actual, logObject, logDetails, browserObj, expectedResult)

				Case "IFEXISTS"
					If Instr(desc(0),":=") Then
						If Browser(browserObj).Page(page).Frame(frameObj).WebButton(desc(0), desc(1),desc(2)).Exist(30) Then
							Browser(browserObj).Page(page).Frame(frameObj).WebButton(desc(0), desc(1),desc(2)).Click
							actual = Browser(browserObj).Page(page).GetROproperty(prop) 
							result = verificationPoint(expected,actual, logObject, logDetails, browserObj, expectedResult)
						End If
					Else
						If Browser(browserObj).Page(page).Frame(frameObj).WebButton(desc(0)).Exist(40) Then
							Browser(browserObj).Page(page).Frame(frameObj).WebButton(desc(0)).Click
							actual = Browser(browserObj).Page(page).GetROproperty(prop) 
							result = verificationPoint(expected,actual, logObject, logDetails, browserObj, expectedResult)
						End If
					End If
				
				Case "MOUSEOVERCLICK"
			
					Setting.WebPackage("ReplayType") = 2
	'				wait 2
					If InStr(desc(0), ":=") Then
						Browser(browserObj).Page(page).Frame(frameObj).WebButton(desc(0), desc(1),desc(2)).Click
					Else
						Browser(browserObj).Page(page).Frame(frameObj).WebButton(desc(0)).Click
					End If 	  
					Setting.WebPackage("ReplayType") = 1
					
					 logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)

				Case Else
					If InStr(desc(0), ":=") Then
						Browser(browserObj).Page(page).Frame(frameObj).WebButton(desc(0), desc(1),desc(2)).Click
					Else
						Browser(browserObj).Page(page).Frame(frameObj).WebButton(desc(0)).Click
					End If
'					actual = Browser(browserObj).Page(page).GetROproperty(prop) 	  
			  
					logDetails = logDetails & " Actual: " &actual  
					result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)

				End Select
  		   
	End Select

End Function


'***************************************************************
' Function: WebButton_VerifyExists (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  VerifyExists keyword for the WebButton type object
' Modification: 04/03/07, BW, Changed the method of finding the actual to use browserObj instead of MAIN
'***************************************************************
Function WebButton_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	windowObj = getfieldsUpperNull(3,page , "-")
	frameObj = getfieldsUpperNull(2,page,"-")
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
	logDetails= "Expected:  " &expected &CHR(13)

	Select Case ident

	Case "None"

		Select Case UCase(args)

			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).page(page).WebButton(desc(0), desc(1),desc(2)).Exist
				Else
					actual = Browser(browserObj).page(page).WebButton(desc(0)).Exist
				End If	

				result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )  

		End Select

	Case "Window"					

		Select Case UCase(args)

			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).window(windowobj).page(page).Frame(frameObj).WebButton(desc(0), desc(1),desc(2)).Exist
				Else
					actual = Browser(browserObj).window(windowobj).page(page).Frame(frameObj).WebButton(desc(0)).Exist
				End If	 
   
				result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )  

		End Select	

	Case "Frame"  

		Select Case UCase(args)

			Case Else
  
				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).page(page).Frame(frameObj).WebButton(desc(0), desc(1),desc(2)).Exist
				Else
					actual = Browser(browserObj).page(page).Frame(frameObj).WebButton(desc(0)).Exist
				End If	 
				   		
				result =  verificationPoint(expected, actual, logObject, logDetails , browserObj, expectedResult)  

			End Select
  
	End Select
	
End Function


'***************************************************************
' Function: WebButton_VerifyProperty (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  Verify property keword for the WebButton type object
'***************************************************************

Function WebButton_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	windowObj = getfieldsUpperNull(3,page , "-")
	frameObj = getfieldsUpperNull(2,page,"-")
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
	
	'Branch on specific arguments

	Select Case ident

	Case "None"

		Select Case UCase(args)

			'INSTRING argument for testing a string within a string

			Case "INSTRING"

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).WebButton(desc(0), desc(1),desc(2)).GetROproperty(prop)
				Else
					actual = Browser(browserObj).Page(page).WebButton(desc(0)).GetROproperty(prop)
				End If    	  
			   logDetails = logDetails & " Actual: " &actual  
			   result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult )

			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).WebButton(desc(0), desc(1),desc(2)).GetROproperty(prop)
				Else
					actual = Browser(browserObj).Page(page).WebButton(desc(0)).GetROproperty(prop)
				End If   
								  
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )

			End Select

	Case "Window"	

		Select Case UCase(args)

			 Case "DOUBLE WINDOW"             'This argument handles situation when a Window Object appears on top of another Window Object.    - Jason 4/10/2009
																				'The second Window must be manually nested within the first Window in the OR.  Also the second Window Object must be named the same as the first  Window Object. 
				If instr (desc(0), ":=") Then
					actual = Browser(browserObj).Window(windowObj).Window(windowObj).Page(page).Frame(frameObj).WebButton(desc(0), desc(1), desc(2)).GetROProperty(prop)
					Else
					actual = Browser(browserObj).Window(windowObj).Window(windowObj).Page(page).Frame(frameObj).WebButton(desc(0)).GetROProperty(prop)
				End If

				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )

			Case Else
		   
				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebButton(desc(0), desc(1),desc(2)).GetROProperty(prop)
				Else
					actual = Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebButton(desc(0)).GetROProperty(prop)
				End If
				
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )

		End Select

	Case "Frame"				

		Select Case UCase(args)

			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebButton(desc(0), desc(1),desc(2)).GetROproperty(prop)
				Else
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebButton(desc(0)).GetROproperty(prop)
				End If   
								  
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )

		End Select

	End Select
	
End Function
