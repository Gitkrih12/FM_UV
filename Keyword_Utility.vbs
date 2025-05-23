

'***************************************************************
'File Name: Keyword_Utility.vbs
'Date Ceated: 02/09/2007
'Created By: Chris Thompson & Steve Truong & Ben Wu
'Description: Library contains all keyword functions for the Utility object type
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
' Function: Utility_Wait(stepNum, stepName, page, object, expected, args)
' Date Created: 02/15/2007
' Date Modifed: 02/15/2007
' Created By: Steve Truong
' Description:  Utility Wait Keyword. Pauses test given time (in milliseconds)
'***************************************************************   

Function Utility_Wait(stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	Dim prop, logObject, logDetails
	
	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
    	logDetails= "Expected: " &expected &CHR(13)

	wait expected

	actual = expected

	'Always return a pass result
	
	result = verificationPoint(expected, actual, logObject, logDetails, "", expectedResult )	
	
End Function

'***************************************************************
' Function: Utility_GenTimestamp(stepNum, stepName, page, object, expected, args)
' Date Created: 03/14/2007
' Date Modifed: 03/14/2007
' Created By: Ben Wu
' Description:  Generates a unique string value based off of system time in an Environment variable specified in the expected
'***************************************************************   

Function Utility_GenTimestamp(stepNum, stepName, expectedResult, page, object, expected, args)

   	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	expected = ""

	Environment("Timestamp") = ""
	Environment("Timestamp") = Time()
	Environment("Timestamp") = Replace(Environment("Timestamp"), "/", "")
	Environment("Timestamp") = Replace(Environment("Timestamp"), ":", "")
	Environment("Timestamp") = Replace(Environment("Timestamp"), "PM", "")
	Environment("Timestamp") = Replace(Environment("Timestamp"), "AM", "")
	Environment("Timestamp") = Replace(Environment("Timestamp"), " ", "")

	'msgbox  Environment("Timestamp")
	'Set up log results
   
    	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	If (args = "") Then
		logDetails= "Expected:  " &expected &CHR(13)
		Else
		logDetails= "Expected: (" &args &")  " &expected &CHR(13)
	End If
	
	'Declare variables
	Dim result
	
	actual = Environment("Timestamp")
	result =  verificationPointNeg(expected, actual, logObject, logDetails , "", expectedResult) 
	
End Function

'***************************************************************
' Function: Utility_GenDatestamp(stepNum, stepName, page, object, expected, args)
' Date Created: 03/29/2007
' Date Modifed: 03/29/2007
' Created By: Ben Wu
' Description:  Generates a unique date based off of system datetime in an Environment variable
'***************************************************************   

Function Utility_GenDatestamp(stepNum, stepName, expectedResult, page, object, expected, args)

   	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	If args = "Run Time" Then
		prop=getFieldsupperNull(1, expected, "=")
		expected=getFields(0, expected, "=")
	Else
		prop=getFieldsupperNull(1, expected, ":=")
		expected=getFields(0, expected, ":=")
	End if
 

	'Setup Environment variable
	Environment("Datestamp") = ""

	'Grab the datetime value

	If prop = "" Then
		Prop=0
	End If
			
	
	Environment("Datestamp") = dateadd("d",prop,now)

	

	Select Case Expected
		Case "m/d/yy"
			Environment("Datestamp") = Month(Environment("Datestamp")) &"/"& Day(Environment("Datestamp")) &"/"& mid(YeAR(Environment("Datestamp")),3)
	Case "m/d/yyyy"
			Environment("Datestamp") = Month(Environment("Datestamp")) &"/"& Day(Environment("Datestamp")) &"/"& YeAR(Environment("Datestamp"))
		Case "m"
			 Environment("Datestamp") = Month(Environment("Datestamp"))
		Case "mm/dd/yyyy"
			months = Month(Environment("Datestamp"))
			days = Day(Environment("Datestamp"))
			years = Year(Environment("Datestamp"))

			If len(months) = 1 Then
				months = "0" &months
			End If

			If len(days) = 1 Then
				days = "0" &days
			End If

			Environment("Datestamp") = months &"/" &days &"/" &years
		Case "mm/yyyy"
			months = Month(Environment("Datestamp"))
			years = Year(Environment("Datestamp"))

			If len(months) = 1 Then
				months = "0" &months
			End If

			Environment("Datestamp") = months &"/" &years
		
		Case else 'Format the value for the date

		Environment ("Datestamp") = FormatDateTime(Environment("Datestamp"), vblongDate)

	End Select
		
	'Set up log results
   
    	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	If (args = "") Then
		logDetails= "Expected:  " &expected &CHR(13)
		Else
		logDetails= "Expected: (" &args &")  " &expected &CHR(13)
	End If
	
	'Declare variables
	Dim result

	actual = Environment("Datestamp")
	result =  verificationPointNeg(expected, actual, logObject, logDetails, "", expectedResult ) 
	
End Function

'***************************************************************
' Function: Utility_TypeText (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  TypeText keyword for the utility type objects
'***************************************************************   

Function Utility_TypeText (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	frameObj=getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")
		

	'Parse out property and expected results

	prop=getFields(0, expected, ":=")
	expected=getFields(1, expected, ":=")
	'expected=mid(expected,2)
	expected = ReplaceConstants(expected)

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

			Case "STATIC"

				wait(1)
				typeKeys(expected)
				wait(1)	 
				
			Case Else
			
			wait(1)
			If frameObj <> "" Then
			   If InStr(desc(0), ":=") Then
			     	Browser(browserObj).page(page).Frame(frameObj).WebEdit( desc(0), desc(1),desc(2)).Click 1,1
				Else
			     	Browser(browserObj).page(page).Frame(frameObj).WebEdit( desc(0)).Click 1,1
				End If
			Else
				   If InStr(desc(0), ":=") Then
			     	Browser(browserObj).page(page).WebEdit( desc(0), desc(1),desc(2)).Click 1,1
				Else
			     	Browser(browserObj).page(page).WebEdit( desc(0)).Click 1,1
				End If
			End If
			
			wait(1)
			typeKeys(expected)
			wait(1)	 
			 
	End Select

End Function

'***************************************************************
' Function: Utility_TypeText (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  TypeText keyword for the utility type objects
'***************************************************************   

Function Utility_SpecialCase (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	Select Case object

	Case "COB_SelectMethod"

		window("text:=Sponsor Select COB Method -- Webpage Dialog").weblist("name:=lblmethod").Select expected
		window("text:=Sponsor Select COB Method -- Webpage Dialog").webbutton("name:=Save").click

	
	End Select

	Select Case UCase(args)

	Case "REASON DIALOG"

		Browser("Claims Module").Window("SelEOB").Window("Select Message -- Webpage").Page("Select Message").Frame("Frame").WebCheckBox("dgSelectMessageCountGrid:_ctl8").Set "ON"
		Browser("Claims Module").Window("SelEOB").Window("Select Message -- Webpage").Page("Select Message").Frame("Frame").WebButton("Save").Click
'
'		sCheck = getFields(1,expected , ":=")
'
'	  x= window("Select Message").webtable("html id:=dgSelectMessageCountGrid").GetRowWithCellText(sCheck, 2, 1)
'		window("Select Message").webtable("html id:=dgSelectMessageCountGrid").ChildItem (x ,1, "WebCheckBox", 0).set"ON"
'		 window("Select Message").webbutton("name:=Save").click
'Browser("QNXT - Sponsor 4.62.00.057").Window("Quick Member Wizard --").Window("Member Attributes -- Webpage").Page("Member Attributes").Frame("Frame").WebButton("Cancel").Click
'Browser("QNXT - Sponsor 4.62.00.057").Window("Quick Member Wizard --").Window("Select Action Reason --").Page("Select Action Reason").Frame("Frame").WebRadioGroup("radReason").Select "TSS000007619   "
'Browser("QNXT - Sponsor 4.62.00.057").Window("Quick Member Wizard --").Window("Select Action Reason --").Page("Select Action Reason").Frame("Frame").WebButton("Save").Click

	End Select

 

End Function


'***************************************************************
' Function:  Utility_VerifyStatement (stepNum, stepName, page, object, expected, args)
' Date Created: 12/19/2022
' Date Modifed: 12/19/2022
' Created By: Sameen Hashmi
' Description:  Verify the equation or statement in the expected results
' Modification: 
'***************************************************************

Function Utility_VerifyStatement (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)
	
	'Parse property and expected result
    expected=replaceConstants(expected)
    
 	
    If Instr(expected,"Environment('Datestamp')") <> 0 Then
    	expected = Replace(expected,"Environment('Datestamp')",environment("Datestamp"))
	Elseif instr (expected,"Environment('Datestamp')<") Then
		expected1 = getfields(2,expected,"<")
		expected1 = mid(expected1,1,len(expected1)-1)
		Call Utility_GenDatestamp(stepNum, stepName,expectedResult, page, object, expected1, "Run Time")  
		expected = Replace(expected,"Environment('Datestamp')<",environment("Datestamp"))
	Elseif Instr(expected,"Environment('sData')") <> 0 Then
		expected = Replace(expected,"Environment('sData')",environment("sData"))
	Elseif Instr(expected,"Environment('Timestamp')") <> 0 Then
		expected = Replace(expected,"Environment('Timestamp')",environment("Timestamp"))
	ElseIf Instr(expected , "TestVariable") <> 0 Then
		expected = Replace(expected,"TestVariable",environment("TestVariable"))
	ElseIf Instr(expected , "RowIndex") <> 0 Then
		expected = Replace(expected,"RowIndex",environment("RowIndex"))	
	End If


	'Set up log results

	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	logDetails= "Expected:  " &expected &CHR(13)
	
	actual = False
	Execute "If "& expected & " Then actual=True End If"
			   	  
	logDetails = logDetails & " Actual: " &actual  

	result = verificationPoint(True, actual, logObject, logDetails, browserObj, expectedResult )	   
			   
	
End Function



'***************************************************************
' Function:  Utility_VerifyFileCreation (stepNum, stepName, page, object, expected, args)
' Date Created: 6/8/2023
' Date Modifed: 6/8/2023
' Created By: Sameen Hashmi
' Description:  Verify the file creation in local FTP
' Modification: 
'***************************************************************

Function Utility_VerifyFileCreation (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)
	
	windowObj = getFields(0,page , "-")
	
	Set fs = CreateObject("Scripting.FileSystemObject")
   
	actual = fs.FileExists(expected)

	'Set up log results

	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	logDetails= "Expected:  " &expected &CHR(13)
			   	  
	logDetails = logDetails & " Actual: " &actual  

	result = verificationPoint(True, actual, logObject, logDetails, windowObj, expectedResult )	
	
	Set fs = Nothing	
			   
	
End Function
