
'***************************************************************
'File Name: Keyword_WebList.vbs
'Date Ceated: 12/27/2006
'Created By: Chris Thompson & Steve Truong
'Description: Library contains all keyword functions for the WebList object type
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
' Function: WebList_Select (stepNum, stepName, page, object, sValue, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  Select keyword for the WebList type object
'***************************************************************

Function WebList_Select (stepNum, stepName, expectedResult, page, object, sValue, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails, temp
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

	prop=getFields(0, sValue, ":=")
	sValue=getFields(1, sValue, ":=")
	sValue = replaceConstants(sValue)

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

	Select Case ident

	Case "None"

		Select Case UCase(args)		

			'NEGATIVE argument for negative testing

			Case "NEGATIVE"

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).WebList(desc(0), desc(1),desc(2)).GetROProperty("innertext")
				Else
					actual = Browser(browserObj).Page(page).WebList(desc(0)).GetROProperty("innertext")
				End If	
				result =  verificationPointInstrNeg(sValue, actual, logObject, logDetails, browserObj, expectedResult )

			Case Else

				  If InStr(desc(0), ":=") Then
'					Browser(browserObj).Page(page).WebList(desc(0), desc(1),desc(2)).Select sValue
					actual = Browser( browserObj).Page(page).WebList(desc(0), desc(1),desc(2)).GetROProperty("value")
				Else
'					Browser(browserObj).Page(page).WebList(desc(0)).Select sValue
					actual = Browser( browserObj).Page(page).WebList(desc(0)).GetROProperty("value")
				End If
				      		   
				result =  verificationPoint(sValue, actual, logObject, logDetails , browserObj, expectedResult)

			End Select

	Case "Frame"

		Select Case UCase(args)

			'NEGATIVE argument for negative testing

			Case "NEGATIVE"

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebList(desc(0), desc(1),desc(2)).GetROProperty("innertext")
				Else
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebList(desc(0)).GetROProperty("innertext")
				End If	
				result =  verificationPointInstrNeg(sValue, actual, logObject, logDetails, browserObj, expectedResult )

				If instr(Environment("runControlFile"),"DataEntry") Then
					If result = False Then
						Environment("RunComments") = sValue & " already in " &object&" list"
						ExitAction
					End If
				End If

				

			Case "NO VALIDATION"

				If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).Frame(frameObj).WebList(desc(0), desc(1),desc(2)).Select sValue
				Else
					Browser(browserObj).Page(page).Frame(frameObj).WebList(desc(0)).Select sValue
				End If
				result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)				
	
			Case Else

				 If InStr(desc(0), ":=") Then
					Browser(browserObj).Page(page).Frame(frameObj).WebList(desc(0), desc(1),desc(2)).Select sValue
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebList(desc(0), desc(1),desc(2)).GetROProperty("value")
				Else
					Browser(browserObj).Page(page).Frame(frameObj).WebList(desc(0)).Select sValue
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebList(desc(0)).GetROProperty("value")
				End If      		   
				result =  verificationPoint(sValue, actual, logObject, logDetails, browserObj, expectedResult )
				
		End Select

	Case "Window"		 

		Select Case UCase(args)
	
			Case "NO VALIDATION"

				 If InStr(desc(0), ":=") Then
					Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebList(desc(0), desc(1),desc(2)).Select sValue
					actual = Browser( browserObj).Window(windowobj).Page(page).Frame(frameObj).WebList(desc(0), desc(1),desc(2)).GetROProperty("value")
				Else
					Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebList(desc(0)).Select sValue
					actual = Browser( browserObj).Window(windowobj).Page(page).Frame(frameObj).WebList(desc(0)).GetROProperty("value")
				End If
					result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)

			Case "DOUBLE WINDOW"                             'This argument handles situation when a Window Object appears on top of another Window Object.     - Jason 4/10/2009
																								'The second Window must be manually nested within the first Window in the OR.  Also the second Window Object must be named the same as the first  Window Object.

				 If InStr(desc(0), ":=") Then
					Browser(browserObj).Window(windowObj).Window(windowobj).Page(page).Frame(frameObj).WebList(desc(0), desc(1),desc(2)).Select sValue
					actual = Browser( browserObj).Window(windowObj).Window(windowobj).Page(page).Frame(frameObj).WebList(desc(0), desc(1),desc(2)).GetROProperty("value")
				Else
					Browser(browserObj).Window(windowObj).Window(windowobj).Page(page).Frame(frameObj).WebList(desc(0)).Select sValue
					actual = Browser( browserObj).Window(windowObj).Window(windowobj).Page(page).Frame(frameObj).WebList(desc(0)).GetROProperty("value")
				End If
				      		   
				result =  verificationPoint(sValue, actual, logObject, logDetails, browserObj, expectedResult )
				
				
			Case Else
		
				If InStr(desc(0), ":=") Then
					Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebList(desc(0), desc(1),desc(2)).Select sValue
					actual = Browser( browserObj).Window(windowobj).Page(page).Frame(frameObj).WebList(desc(0), desc(1),desc(2)).GetROProperty("value")
				Else
					Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebList(desc(0)).Select sValue
					actual = Browser( browserObj).Window(windowobj).Page(page).Frame(frameObj).WebList(desc(0)).GetROProperty("value")
				End If
				      		   
				result =  verificationPoint(sValue, actual, logObject, logDetails, browserObj, expectedResult )
				
		End Select	

	End Select
	
End Function


'***************************************************************
' Function: WebList_VerifyExists (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  VerifyExists keyword for the Link type object
' Modification: 04/03/07, BW, Changed the method of finding the actual to use browserObj instead of MAIN
'***************************************************************
Function WebList_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

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
					actual = Browser(browserObj).page(page).WebList(desc(0), desc(1),desc(2)).Exist
				Else
					actual = Browser(browserObj).page(page).WebList(desc(0)).Exist
				End If
						
				result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )  

		End Select

	Case "Frame"

		Select Case UCase(args)

			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).page(page).Frame(frameObj).WebList(desc(0), desc(1),desc(2)).Exist
				Else
					actual = Browser(browserObj).page(page).Frame(frameObj).WebList(desc(0)).Exist
				End If

				 logDetails = logDetails & " Actual: " &actual
				result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)

		End Select

	Case "Window"

		Select Case UCase(args)

			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser( browserObj).Window(windowobj).Page(page).Frame(frameObj).WebList(desc(0), desc(1),desc(2)).Exist
				Else
					actual = Browser( browserObj).Window(windowobj).Page(page).Frame(frameObj).WebList(desc(0)).Exist
				End If         
				 	   
				logDetails = logDetails & " Actual: " &actual
				result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)
				
		End Select
	
	End Select
End Function


'***************************************************************
' Function: WebList_VerifyProperty (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  Verify property keword for the WebList type object
'***************************************************************
	
Function WebList_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

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

	Select Case ident

	Case "None"

		Select Case UCase(args)

			'Argument for using waitproperty function

			Case "WAIT"
				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).WebList(desc(0), desc(1),desc(2)).WaitProperty(prop, expected, 10000)
				Else
					actual = Browser(browserObj).Page(page).WebList(desc(0)).WaitProperty(prop, expected, 10000)
				End If		  
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(True, actual, logObject, logDetails, browserObj, expectedResult)

			Case "INLIST"
					If InStr(desc(0), ":=") Then
						Allitems = Browser(browserObj).Page(page).WebList(desc(0),desc(1),desc(2)).GetROproperty("all items")
					Else
						Allitems = Browser(browserObj).Page(page).WebList(desc(0)).GetROproperty("all items")
					End If
					arrAllitems = Split(Allitems, ";")

					upperIndex = ubound(arrAllitems)
					For i = 0 to upperIndex
						If arrAllitems(i) = expected Then
							itemFound = "True"
							actual = arrAllitems(i)
							Exit for
						End If
						itemFound = "False"
					Next

					logDetails = logDetails & " Actual: " &actual
					result =  VerificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )
					If itemFound = "False" Then
						Environment("RunComments") = expected & " not found in " &object&" list"
						Environment("RunStatus") = "Failed"
						If instr(Environment("runControlFile"),"DataEntry") Then
							ExitAction
						End If
					End If

			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).WebList(desc(0), desc(1),desc(2)).GetROproperty(prop)
				Else
					actual = Browser(browserObj).Page(page).WebList(desc(0)).GetROproperty(prop)
				End If    	  
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)
			
			End Select

	Case "Frame"

		Select Case UCase(args)

		Case "ALL ITEMS" 
	
				sFail = False
		  	
					If Instr(desc(0), ":=") Then
						Allitems = Browser(browserObj).Page(page).Frame(frameObj).WebList(desc(0), desc(1), desc(2)).GetROProperty("all items")
						arrAllitems = Split(Allitems, ";")
						arrSQL = Split(Environment("SQLResults"), "|")
						i = 1
						z = 2
					
						Do

							If  i = ubound(arrAllitems) + 1 Then     'fails if WebList runs out of options before the SQL call does
								sFail = True
								Exit Do
							End If
						
							sValue = arrAllitems(i)
							current = arrSQL(z)
				
							If sValue = "" Then                                       ' compensates for empty options at top of WebLists
								sValue = arrAllitems(i+1)
								i = i + 1
							End If

							If sValue = "select" OR sValue = "Select" Then						 	'compensates for "select" options at top of WebLists
								sValue = arrAllitems(i+1)
								i = i + 1
							End If
							
							If current = "" Then                                        'compensates for empty options at top of SQL Calls
								current = arrSQL(z+1)
								z = z + 1
							End If

							If trim(sValue) <> trim(current) Then     'VERIFICATION
								sFail = True
								 logDetails= "Expected:  " &current &CHR(13) &"Actual: " &sValue
								Exit Do
							End If
						
						i = i + 1
						z = z + 1

						If arrSQL(z) = "" Then                                       'compensates for empty options at bottom of SQL Calls....Once empty option is reached SQL Call is over
							Exit Do
						End If
					
						loop until i - 1 = ubound(arrSQL)               'loops until end of SQL call
					
					Else

						Allitems = Browser(browserObj).Page(page).Frame(frameObj).WebList(desc(0)).GetROProperty("all items")
						arrAllitems = Split(Allitems, ";")
						arrSQL = Split(Environment("SQLResults"), "|")
						i = 0
						z = 1
					
						Do

							If i = ubound(arrAllitems) + 1 Then 'fails if WebList runs out of options before the SQL call does
								sFail = True
								Exit Do
							End If
						
							sValue = arrAllitems(i)
							current = arrSQL(z)
				
							If sValue = "" Then                    ' compensates for empty options at top of WebLists
								sValue = arrAllitems(i+1)
								i = i + 1
							End If

							 If sValue = "select" OR sValue = "Select" Then						 	'compensates for "select" options at top of WebLists
								sValue = arrAllitems(i+1)
								i = i + 1
							End If
							
							If current = "" Then                     'compensates for empty options at top of SQL Calls
								current = arrSQL(z+1)
								z = z + 1
							End If

							If trim(sValue) <> trim(current) Then      'VERIFCATION
								sFail = True
								logDetails= "Expected:  " &current &CHR(13) &"Actual: " &sValue
								Exit Do
							End If
						
						i = i + 1
						z = z + 1

						If arrSQL(z) = "" Then                    'compensates for empty options at bottom of SQL Calls....Once empty option is reached SQL Call is over
							Exit Do
						End If

						loop until i - 1 = ubound(arrSQL) 'loops until end of SQL call
				  			
					End If
					result = verificationPoint(False, sFail, logObject, logDetails, browserObj, expectedResult)

			Case "INLIST"
					If InStr(desc(0), ":=") Then
						Allitems = Browser(browserObj).Page(page).Frame(frameObj).WebList(desc(0),desc(1),desc(2)).GetROproperty("all items")
					Else
						Allitems = Browser(browserObj).Page(page).Frame(frameObj).WebList(desc(0)).GetROproperty("all items")
					End If
					arrAllitems = Split(Allitems, ";")

					upperIndex = ubound(arrAllitems)
					For i = 0 to upperIndex
						If arrAllitems(i) = expected Then
							itemFound = "True"
							actual = arrAllitems(i)
							Exit for
						End If
						itemFound = "False"
					Next
					
					logDetails = logDetails & " Actual: " &actual
					result =  VerificationPoint(expected, actual, logObject, logDetails , browserObj, expectedResult)  
					If itemFound = "False" Then
						Environment("RunComments") = expected & " not found in " &object&" list"
						Environment("RunStatus") = "Failed"
						If instr(Environment("runControlFile"),"DataEntry") Then
							ExitAction
						End If
					End If

			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebList(desc(0), desc(1),desc(2)).GetROproperty(prop)
				Else
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebList(desc(0)).GetROproperty(prop)
				End If    	  
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)

			End Select

	Case "Window"
		Select Case UCase(args)

			Case "ALL ITEMS" 
	
				sFail = False
		  	
					If Instr(desc(0), ":=") Then
						Allitems = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebList(desc(0), desc(1), desc(2)).GetROProperty("all items")
						arrAllitems = Split(Allitems, ";")
						arrSQL = Split(Environment("SQLResults"), "|")
						i = 1
						z = 2
					
						Do

							If  i = ubound(arrAllitems) + 1 Then     'fails if WebList runs out of options before the SQL call does
								sFail = True
								Exit Do
							End If
						
							sValue = arrAllitems(i)
							current = arrSQL(z)
				
							If sValue = "" Then                                       ' compensates for empty options at top of WebLists
								sValue = arrAllitems(i+1)
								i = i + 1
							End If

							If sValue = "select" OR sValue = "Select" Then                    		'compensates for "select" options at top of WebLists
								sValue = arrAllitems(i+1)
								i = i + 1
							End If
							
							If current = "" Then                                        'compensates for empty options at top of SQL Calls
								current = arrSQL(z+1)
								z = z + 1
							End If

							If trim(sValue) <> trim(current) Then     'VERIFICATION
								sFail = True
								logDetails= "Expected:  " &current &CHR(13) &"Actual: " &sValue
								Exit Do
							End If
						
						i = i + 1
						z = z + 1

						If arrSQL(z) = "" Then                                       'compensates for empty options at bottom of SQL Calls....Once empty option is reached SQL Call is over
							Exit Do
						End If
					
						loop until i - 1 = ubound(arrSQL)               'loops until end of SQL call
					
					Else

						Allitems = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebList(desc(0)).GetROProperty("all items")
						arrAllitems = Split(Allitems, ";")
						arrSQL = Split(Environment("SQLResults"), "|")
						i = 0
						z = 1
					
						Do

							If i = ubound(arrAllitems) + 1 Then 'fails if WebList runs out of options before the SQL call does
								sFail = True
								Exit Do
							End If
						
							sValue = arrAllitems(i)
							current = arrSQL(z)
				
							If sValue = "" Then                    ' compensates for empty options at top of WebLists
								sValue = arrAllitems(i+1)
								i = i + 1
							End If

							If sValue = "select" OR sValue = "Select" Then						 	'compensates for "select" options at top of WebLists
								sValue = arrAllitems(i+1)
								i = i + 1
							End If
							
							If current = "" Then                     'compensates for empty options at top of SQL Calls
								current = arrSQL(z+1)
								z = z + 1
							End If

							If trim(sValue) <> trim(current) Then      'VERIFCATION
								sFail = True
								 logDetails= "Expected:  " &current &CHR(13) &"Actual: " &sValue
								Exit Do
							End If
						
						i = i + 1
						z = z + 1

						If arrSQL(z) = "" Then                    'compensates for empty options at bottom of SQL Calls....Once empty option is reached SQL Call is over
							Exit Do
						End If

						loop until i - 1 = ubound(arrSQL) 'loops until end of SQL call
				  			
					End If
					result = verificationPoint(False, sFail, logObject, logDetails, browserObj, expectedResult)

	    Case "INLIST"
					If InStr(desc(0), ":=") Then
						Allitems = Browser(browserObj).window(WindowObj).Page(page).Frame(frameObj).WebList(desc(0),desc(1),desc(2)).GetROproperty("all items")
					Else
						Allitems = Browser(browserObj).window(WindowObj).Page(page).Frame(frameObj).WebList(desc(0)).GetROproperty("all items")
					End If
					arrAllitems = Split(Allitems, ";")

					If browserObj = "Sponsor Moduel" AND windowObj = "Attribute" Then  'Data Entry
						upperIndex = ubound(arrAllitems)
							For i = 0 to upperIndex
								If instr(arrAllitems(i), trim(expected)) Then
									itemFound = "True"
									actual = arrAllitems(i)
									Exit for
								End If
								itemFound = "False"
							Next
					Else
					upperIndex = ubound(arrAllitems)
					For i = 0 to upperIndex
						If arrAllitems(i) = expected Then
							itemFound = "True"
							actual = arrAllitems(i)
							Exit for
						End If
						itemFound = "False"
					Next
					End If
					logDetails = logDetails & " Actual: " &actual
					result =  VerificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )      
					If itemFound = "False" Then
						Environment("RunComments") = expected & " not found in " &object&" list"
						Environment("RunStatus") = "Failed"
						If instr(Environment("runControlFile"),"DataEntry") Then
							ExitAction
						End If
					End If 
					 			
		'No Argument 

		Case Else

			If InStr(desc(0), ":=") Then
					actual = Browser( browserObj).Window(windowobj).Page(page).Frame(frameObj).WebList(desc(0), desc(1),desc(2)).GetROProperty(prop)
				Else
					actual = Browser( browserObj).Window(windowobj).Page(page).Frame(frameObj).WebList(desc(0)).GetROProperty(prop)
				End If      		   
			logDetails = logDetails & " Actual: " &actual
			result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)

       

		End Select	   
			   
	End Select
	
End Function
