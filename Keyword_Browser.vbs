
'***************************************************************
'File Name: Keyword_Browser.vbs
'Date Ceated: 12/27/2006
'Created By: Chris Thompson & Steve Truong
'Description: Library contains all keyword functions for the Browser object type
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
' Function: Browser_Back (stepNum, stepName, page, object, expected, args)
' Date Created: 3/21/2008
' Date Modifed: 3/21/2008
' Created By: Steve Truong
' Description:  Back keyword for the Browser type object
'*************************************************************** 
Function Browser_Back(stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
     Dim prop, logObject, logDetails

	'Parse property and expected result
	
	prop=getFields(0, expected, ":=")
	expected=getFields(1, expected, ":=")
	expected = replaceConstants(expected)
	browserObj = getFields(0,page , "-")
	'Click the back button on browser

     Browser(browserObj).Back

	'Set up log results
	
     logObject = "Step: " &stepNum &"  -  "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
     logDetails= "Expected:  " &expected &CHR(13)

	'Verify expected results

	 actual = Browser("opentitle:=.*").Page("title:=.*").GetROproperty(prop) 	  
	 logDetails = logDetails & " Actual: " &actual  
	 result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )
   
End Function


'***************************************************************
' Function: Browser_Close (stepNum, stepName, page, object, expected, args)
' Date Created: 2/1/2007
' Date Modifed: 2/1/2007
' Created By: Chris Thompson & Steve Truong
' Description:  VerifyExists keyword for the Browser type object
'***************************************************************

Function Browser_Close (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	page = getFields(1,page , "-")
	expected = replaceConstants(expected)

	'Set up log results

	logObject = "Step: " &stepNum &"  -  "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	If (args = "") Then
		logDetails= "Expected:  " &expected &CHR(13)
	Else
		logDetails= "Expected: (" &args &")  " &expected &CHR(13)
	End If

	'Close Browser

	Browser(browserObj).Close
	wait(4)
	actual = Browser( browserObj).Exist(1)
	result =  verificationPoint(False, actual, logObject, logDetails, "", expectedResult)   

	If expected = "Open" Then
		Browser_Open ()
	End If
				 
End Function


'***************************************************************
' Function: Browser_Open()
' Date Created: 12/27/2006
' Date Modifed: 4/22/2008
' Created By: Chris Thompson
' Description: Opens web site
'***************************************************************   

Public Function Browser_Open(stepNum, stepName, expectedResult, page, object, expected, args)
	
	Set fs = CreateObject("Scripting.FileSystemObject")
	Environment("IsWindows") = False
	
	If Environment("RunEnvironment")="" Then
		db="DRIVER={Microsoft Access Driver (*.mdb)};DBQ=" &Environment("runControlFile") 
		Set sub_rs = Createobject("ADODB.RecordSet")
		
		sqlqueryGlobal = "Select * from CONSTANTS where CONSTANT ='AppURL'"
		
		sub_rs.Open sqlqueryGlobal, db, 1, 3
		Environment("RunEnvironment")= sub_rs("VALUE").value
		sub_rs.close
		Set sub_rs = Nothing		
	End If

	If UCase(Environment("BrowserToUse")) = "CHROME" Then
		If fs.fileExists("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe") Then
			SystemUtil.Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe", Environment("RunEnvironment")
		ElseIf fs.fileExists("C:\Program Files\Google\Chrome\Application\chrome.exe") Then
			SystemUtil.Run "C:\Program Files\Google\Chrome\Application\chrome.exe", Environment("RunEnvironment")
		End If
	Elseif UCase(Environment("BrowserToUse")) = "EDGE" Then
		SystemUtil.Run "MicrosoftEdge.exe", Environment("RunEnvironment")
	ElseIf UCase(Environment("BrowserToUse")) = "IE" Then
		SystemUtil.Run "iexplore.exe", Environment("RunEnvironment")
	End If
   
	Wait 3
	actual = Browser("opentitle:=.*").Exist
	browserObj = getFields(0,page , "-")
	If actual Then
		Browser("opentitle:=.*").Maximize
		bwrTitle = Browser("opentitle:=.*").GetROProperty("title")
		Window("micclass:=Window", "text:=" & bwrTitle&".*").Activate
	End If
	
	'Set up log results
	Dim logObject, logDetails
     logObject = "Step: " &stepNum &"  -  "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
     logDetails= "Expected:  " &expected &CHR(13)
	logDetails = logDetails & " Actual: " &actual 
'print actual	
	result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)
	Set fs = Nothing

End Function

'***************************************************************
' Function: Browser_VerifyExists (stepNum, stepName, page, object, expected, args)
' Date Created: 2/1/2007
' Date Modifed: 2/1/2007
' Created By: Chris Thompson
' Description:  VerifyExists keyword for the Browser type object
'***************************************************************

Function Browser_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)


	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	page = getFields(1,page , "-")
	
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

	'No Argument 
			  
		Case Else
			actual = Browser( browserObj).Page(page).Exist
			result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )   
				 
	End Select
	
End Function


'*******************************************************************************************************
' Function: Browser_VerifyProperty(stepNum, stepName, page, object, sValue, args)
' Date Created: 1/22/2007
' Date Modifed: 1/22/2007
' Created By: Chris Thompson 
' Description:  Verify roperty keyword for the Browser object type
'*******************************************************************************************************

Function Browser_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	page = getFields(1,page , "-")
	
	'Parse property and expected result

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

		Case "INSTRING"
			actual = Browser(browserObj ).Page("title:=.*").GetROproperty(prop)	  
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult ) 	

		'No Argument 
				
		Case Else
			actual = Browser(browserObj ).Page("title:=.*").GetROproperty(prop)
			logDetails = logDetails & " Actual: " &actual  
     		result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )
			   
	End Select
	
End Function

'***************************************************************
' Function: Browser_Navigate (stepNum, stepName, page, object, expected, args)
' Date Created: 3/1/2007
' Date Modifed: 3/1/2007
' Created By: Steve Truong
' Description:  Navigate keyword for the Browser type object
'***************************************************************

Function Browser_Navigate (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	page = getFields(1,page , "-")
	expected = replaceConstants(expected)
	object = replaceConstants(object)
	
	'Set up log results

	logObject = "Step: " &stepNum &"  -  "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	If (args = "") Then
		logDetails= "Expected:  " &expected &CHR(13)
	Else
		logDetails= "Expected: (" &args &")  " &expected &CHR(13)
	End If

	Browser(browserObj).Navigate object
	Browser(browserObj).Sync
	actual = Browser(browserObj).GetROProperty("url")
	result =  verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult )   
				 
End Function
