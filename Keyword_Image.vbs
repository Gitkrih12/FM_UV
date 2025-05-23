
'***************************************************************
'File Name: Keyword_Image.vbs
'Date Ceated: 12/27/2006
'Created By: Chris Thompson & Steve Truong
'Description: Library contains all keyword functions for the Image object type
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
' Function: Image_Click (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  Click keyword for the Image type object
'***************************************************************   

Function Image_Click (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	page = getFields(1,page , "-")
	
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

	'Branch on argument

	Select Case UCase(args)

	'POPUP argument for dealing with when a popup is opened

		Case "POPUP"
			If InStr(desc(0), ":=") Then
				Browser( browserObj ).Page(page).image(desc(0), desc(1),desc(2)).Click
			Else
				Browser( browserObj ).Page(page).image(desc(0)).Click
			End If	
			actual = Browser(getFields(0,expected,"-")).Page(getFields(1,expected,"-")).Exist(5)	 
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(TRUE, actual, logObject, logDetails, browserObj, expectedResult)	

	'Back argument for clicking the back button after verification
			    
		Case "BACK"
			If InStr(desc(0), ":=") Then
				Browser(browserObj).Page(page).Image(desc(0), desc(1),desc(2)).Click
			Else
				Browser(browserObj).Page(page).Image(desc(0)).Click
			End If
			actual = Browser(browserObj).Page("title:=.*").GetROproperty(prop) 	  
			logDetails = logDetails & " Actual: " &Actual  
			result = verificationPoint(expected, actual, logObject, logDetails , browserObj, expectedResult)
			Browser(browserObj).Back

		Case "INSTRING"
			If InStr(desc(0), ":=") Then
				Browser(browserObj).Page(page).Image(desc(0), desc(1),desc(2)).Click
			Else
				Browser(browserObj).Page(page).Image(desc(0)).Click
			End If					
			actual = Browser(browserObj).Page("title:=.*").GetROProperty(prop) 	  
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult ) 	
			
	'No Argument 
			
		Case Else
			If InStr(desc(0), ":=") Then
				Browser(browserObj).Page(page).Image( desc(0), desc(1),desc(2)).Click
				actual = Browser(browserObj).Page("title:=.*").GetROproperty(prop)
			Else
				Browser(browserObj).Page(page).Image(desc(0)).Click
				actual = Browser(browserObj).Page("title:=.*").GetROproperty(prop)
			End If					 	  
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )			
			   
	End Select

End Function


'***************************************************************
' Function: Image_VerifyExists (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson & Steve Truong
' Description:  VerifyExists keyword for the Image type object
'***************************************************************

Function Image_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

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
	If (args = "") Then
		logDetails= "Expected:  " &expected &CHR(13)
	Else
		logDetails= "Expected: (" &args &")  " &expected &CHR(13)
	End If

   'Branch on specific arguments

	Select Case ident

	Case "None"

		Select Case UCase(args)

			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).window(WindowObj).Page(page).Image(desc(0), desc(1), desc(2)).Exist
				Else
					actual = Browser(browserObj).window(WindowObj).Page(page).Image(desc(0)).Exist
				End If

				result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)    

		End Select

	Case "Window"	

		Select Case UCase(args)

			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).window(WindowObj).Page(page).Frame(frameObj).Image(desc(0), desc(1), desc(2)).Exist
				Else
					actual = Browser(browserObj).window(WindowObj).Page(page).Frame(frameObj).Image(desc(0)).Exist
				End If

				 result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)    

		End Select

	Case "Frame"		 

		Select Case UCase(args)
	
		Case Else

			If InStr(desc(0), ":=") Then
				actual = Browser(browserObj).Page(page).Frame(frameObj).Image(desc(0), desc(1), desc(2)).Exist
			Else
				actual = Browser(browserObj).Page(page).Frame(frameObj).Image(desc(0)).Exist
			End If
	
			result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)    

		End Select
				
	End Select

End Function

'***************************************************************
' Function: Image_VerifyProperty (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  Verify property keword for the image type object
'***************************************************************

Function Image_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	windowObj = getfieldsUpperNull(3,page , "-")
	frameObj = getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")
	
	'Parse property and expected result

	prop=getFields(0, expected, ":=")
	expected=getFields(1, expected, ":=")
    expected=replaceConstants(expected)

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
	
	'Branch on specific arguments

	Select Case ident

	Case "Frame"

		Select Case UCase(args)

	'INSTR argument for testing a string within a string

		Case "INSTRING"
			If InStr(desc(0), ":=") Then
			   actual = Browser(browserObj).Page(page).Frame(frameObj).Image(desc(0), desc(1),desc(2)).GetROproperty(prop)
			Else
			   actual = Browser(browserObj).Page(page).Frame(frameObj).Image(desc(0)).GetROproperty(prop)
			End If    	  
			   logDetails = logDetails & " Actual: " &actual  
			   result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult )

		'No Argument 
			
		Case Else
			If InStr(desc(0), ":=") Then
				actual = Browser(browserObj).Page(page).Frame(frameObj).Image(desc(0), desc(1),desc(2)).GetROproperty(prop) 
			Else
				actual = Browser(browserObj).Page(page).Frame(frameObj).Image(desc(0)).GetROproperty(prop)
			End If		  
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )  
			   
		End Select

		   Case "Window"

		Select Case UCase(args)

	'INSTR argument for testing a string within a string

		Case "INSTRING"
			If InStr(desc(0), ":=") Then
			   actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).Image(desc(0), desc(1),desc(2)).GetROproperty(prop)
			Else
			   actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).Image(desc(0)).GetROproperty(prop)
			End If    	  
			   logDetails = logDetails & " Actual: " &actual  
			   result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult )

		'No Argument 
			
		Case Else
			If InStr(desc(0), ":=") Then
				actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).Image(desc(0), desc(1),desc(2)).GetROproperty(prop) 
			Else
				actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).Image(desc(0)).GetROproperty(prop)
			End If		  
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )  
			   
		End Select

	   Case "None"

		Select Case UCase(args)

	'INSTR argument for testing a string within a string

		Case "INSTRING"
			If InStr(desc(0), ":=") Then
			   actual = Browser(browserObj).Page(page).Image(desc(0), desc(1),desc(2)).GetROproperty(prop)
			Else
			   actual = Browser(browserObj).Page(page).Image(desc(0)).GetROproperty(prop)
			End If    	  
			   logDetails = logDetails & " Actual: " &actual  
			   result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult )

		'No Argument 
			
		Case Else
			If InStr(desc(0), ":=") Then
				actual = Browser(browserObj).Page(page).Image(desc(0), desc(1),desc(2)).GetROproperty(prop) 
			Else
				actual = Browser(browserObj).Page(page).Image(desc(0)).GetROproperty(prop)
			End If		  
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )  
			   
		End Select
		
	End Select
    
End Function
