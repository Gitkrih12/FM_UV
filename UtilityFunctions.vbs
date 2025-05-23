 
'***************************************************************
'File Name: UtilityFunctions.vbs
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
' Function: replaceConstants(sString)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description: Removes contants used in database exepected results
'		   with the baseline value required
'			Constants in database are indicated between pipes ( e.g., |URL| )
'***************************************************************

Function replaceConstants(sString)

	If instr(sString, "|") <> 0 Then
		constant = getfields(1,sString, "|")
		db2="DRIVER={Microsoft Access Driver (*.mdb)};DBQ=" &Environment("runControlFile") 
		Set rs2 = Createobject("ADODB.RecordSet")
		sqlquery = "Select * from CONSTANTS where CONSTANT ='" &constant &"'"
		rs2.Open sqlquery, db2, 1, 3
		sString= Replace(sString, "|" &constant &"|", rs2("VALUE"))
	End If

	replaceConstants = sString

End Function

'***************************************************************
' Function: replaceSQLReference(sString)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description: Removes SQL References used in database exepected results
'		   with the baseline value required
'***************************************************************

Function replaceSQLReference(sString)

	bcounter = instr(1, sString, "SQL.")
	If bcounter <> 0 Then

		fields = mid (sString,bcounter+4) 
		If instr(fields,"~") Then
			fields = mid(fields,1,instr(1,fields,"~")-1)
		End If

		fields2 = fields
		If instr(fields, "[") <> 0 Then
			fields2 = mid(fields, 1, instr(fields,"[")-1)
		End If

		cutoff = mid (Environment("SQLResults"), instr(Environment("SQLResults"),"~"&fields2&"~"))
		cutoff = mid (cutoff, instr(cutoff, "~")+1)
		cutoff = mid (cutoff, instr(cutoff, "~")+1)
	
		If instr(cutoff, "~") <> 0Then
			cutoff = mid(cutoff,1,instr(cutoff, "~")-1)
		End If

		If instr (sString, "]") Then
			ecounter = instr(bcounter , sString, "[")
			constant = mid (sString, bcounter , ecounter-bcounter+3 )
			col = mid(sString, bcounter+4, (ecounter-bcounter-4)) 
			index = mid(sString, ecounter+1, instr(ecounter ,sString, "]")-1-ecounter)
			replacement =getFields(cint(index), cutoff,  "|")
			replacement = replace(sString, "SQL." &fields, replacement)
		Else
			cutoff = replace(cutoff,"|","")
			replacement = replace(sString, "SQL." &fields, cutoff)
		End If

		sString = replacement
		
	End If

	replaceSQLReference = sString

End Function


'***************************************************************
' Function: verificationPoint(baseline, capture, info, details)
' Date Created: 10/6/2005
' Date Modifed:  02/23/2022
' Created By:  Chris Thompson
' Description:  Writes pass/fail results to the log.
'***************************************************************

Function verificationPoint(baseline, capture, info, details, browserObj, expectedResult)
		
	dim count
	capture = trim(capture)
	baseline = trim(baseline)
	
	count = instr(capture, "*.*")
	If count <> 0 Then
		capture = mid(capture,1,count-1)
		baseline = mid(baseline,1,count-1)
	End If
	
	count = instr(baseline, "*.*")
	If count <> 0 Then
		baseline = mid(baseline,1,count-1)
		capture = mid(capture,1,count-1)
	End If

	stepName = Mid(info,Instr(1,info,"Step:")+6,Instr(1,info," - ")-Instr(1,info,"Step:")-6)
	testDescription = Mid(info,Instr(1,info," - ")+3,Instr(1,info,"Page:")-Instr(1,info," - ")-3)
	
	If CStr(baseline) = CStr(capture) Then
		verificationPoint = True 
		testStepStatus = True		
		If Environment("RunFrom") = "LOCAL" Then
			Reporter.ReportEvent micPass, info, details
		ElseIf Environment("RunFrom") = "ALM" And browserObj <> "" and expectedResult <> "" Then
				verifyResultsInALM browserObj, stepName, "Passed", testDescription, expectedResult, "The result is as expected"	
				
		End If
		If browserObj <> "" and expectedResult <> "" and Environment("RunFrom") <> "ALM" and Environment("RunFrom") <> "LOCAL" Then
			createTestStepDetails browserObj,stepName,testDescription,expectedResult,"The result is as expected",testStepStatus
		End If
		
	Else
		verificationPoint = False
		Environment("TestPassed") = False
		testStepStatus = False
		If Environment("RunFrom") = "LOCAL" Then
			Reporter.ReportEvent micFail, info, details
		ElseIf  Environment("RunFrom") = "ALM" And browserObj <> "" and expectedResult <> "" Then
				verifyResultsInALM browserObj, stepName, "Failed", testDescription, expectedResult, "The result is not as expected"
				Reporter.ReportEvent micFail, info, details	
			
		End If
		If  browserObj <> "" and expectedResult <> "" and Environment("RunFrom") <> "ALM" and Environment("RunFrom") <> "LOCAL" Then
			createTestStepDetails browserObj,stepName,testDescription,expectedResult,"The result is not as expected",testStepStatus
'			createTestStepDetails browserObj,stepName,testDescription,expectedResult,"The result is not as expected."&Replace(Err.Description,"""","'"),testStepStatus
		End If
	End If
	
End Function

'***************************************************************
' Function: verificationPointInstr(baseline, capture, info, details)
' Date Created: 10/6/2005
' Date Modifed:  10/6/2005
' Created By:  Chris Thompson
' Description:  Writes pass/fail results to the log.
'***************************************************************

Function verificationPointInstr(baseline, capture, info, details, browserObj, expectedResult)
		
	dim count
	capture = trim(capture)
	baseline = trim(baseline)
	
	stepName = Mid(info,Instr(1,info,"Step:")+6,Instr(1,info," - ")-Instr(1,info,"Step:")-6)
	testDescription = Mid(info,Instr(1,info," - ")+3,Instr(1,info,"Page:")-Instr(1,info," - ")-3)
	
	If instr(CStr(capture), CStr(baseline)) <> 0 OR capture = baseline Then
		verificationPointInStr = True
		testStepStatus = True
		If Environment("RunFrom") = "LOCAL" Then
			Reporter.ReportEvent micPass, info, details
		ElseIf Environment("RunFrom") = "ALM" and browserObj <> "" and expectedResult <> "" Then
			verifyResultsInALM browserObj, stepName, "Passed", testDescription, expectedResult, "The result is as expected"
		End If
		If browserObj <> "" and expectedResult <> "" and Environment("RunFrom") <> "ALM" and Environment("RunFrom") <> "LOCAL" Then
			createTestStepDetails browserObj,stepName,testDescription,expectedResult,"The result is as expected",testStepStatus
		End If
	Else
		verificationPointInStr = False
		Environment("TestPassed") = False
		testStepStatus = False
		
		If Environment("RunFrom") = "LOCAL" Then
			Reporter.ReportEvent micFail, info, details
		ElseIf Environment("RunFrom") = "ALM" and browserObj <> "" and expectedResult <> "" Then
			verifyResultsInALM browserObj, stepName, "Failed", testDescription, expectedResult, "The result is not as expected"
			Reporter.ReportEvent micFail, info, details
		End If 
		If  browserObj <> "" and expectedResult <> "" and Environment("RunFrom") <> "ALM" and Environment("RunFrom") <> "LOCAL" Then
			createTestStepDetails browserObj,stepName,testDescription,expectedResult,"The result is not as expected."&Replace(Err.Description,"""","'"),testStepStatus
			Err.Clear	
		End If
		
	End If


End Function


'***************************************************************
' Function: verificationPointInstrNeg(baseline, capture, info, details)
' Date Created: 10/6/2005
' Date Modifed:  10/6/2005
' Created By:  Chris Thompson
' Description:  Writes pass/fail results to the log.
'***************************************************************

Function verificationPointInstrNeg(baseline, capture, info, details, browserObj, expectedResult)
		
	dim count
	capture = trim(capture)
	baseline = trim(baseline)
	
	stepName = Mid(info,Instr(1,info,"Step:")+6,Instr(1,info," - ")-Instr(1,info,"Step:")-6)
	testDescription = Mid(info,Instr(1,info," - ")+3,Instr(1,info,"Page:")-Instr(1,info," - ")-3)
		
	If instr(CStr(capture), CStr(baseline)) <> 0 Then
		verificationPointInStrNeg = False
		Environment("TestPassed") = False
		testStepStatus = False
		If Environment("RunFrom") = "LOCAL" Then
			Reporter.ReportEvent micFail, info, details
		ElseIf Environment("RunFrom") = "ALM" and browserObj <> "" and expectedResult <> "" Then
			verifyResultsInALM browserObj, stepName, "Failed", testDescription, expectedResult, "The result is not as expected"
			Reporter.ReportEvent micFail, info, details
		End If
		
		 If  browserObj <> "" and expectedResult <> "" and Environment("RunFrom") <> "ALM" and Environment("RunFrom") <> "LOCAL" Then
			createTestStepDetails browserObj,stepName,testDescription,expectedResult,"The result is not as expected."&Replace(Err.Description,"""","'"),testStepStatus
			Err.Clear	
		End If
	Else
		 verificationPointInStrNeg = True
       		 testStepStatus = True
		If Environment("RunFrom") = "LOCAL" Then
			Reporter.ReportEvent micPass, info, details
		ElseIf Environment("RunFrom") = "ALM" and browserObj <> "" and expectedResult <> "" Then
			verifyResultsInALM browserObj, stepName, "Passed", testDescription, expectedResult, "The result is as expected"
		End If 
       		If browserObj <> "" and expectedResult <> "" and Environment("RunFrom") <> "ALM" and Environment("RunFrom") <> "LOCAL" Then
			createTestStepDetails browserObj,stepName,testDescription,expectedResult,"The result is as expected",testStepStatus
		End If
       		
	End If

End Function

'***************************************************************
' Function: VerificationPointNeg(baseline, capture, info, details)
' Date Created: 10/6/2005
' Date Modifed:  10/6/2005
' Created By:  Chris Thompson
' Description:  Writes pass/fail results to the log.
'***************************************************************

Function verificationPointNeg(baseline, capture, info, details, browserObj, expectedResult)

	stepName = Mid(info,Instr(1,info,"Step:")+6,Instr(1,info," - ")-Instr(1,info,"Step:")-6)
	testDescription = Mid(info,Instr(1,info," - ")+3,Instr(1,info,"Page:")-Instr(1,info," - ")-3)
	
	If CStr(baseline) <> CStr(capture) Then
		verificationPointNeg = True
		testStepStatus = True
		If Environment("RunFrom") = "LOCAL" Then
			Reporter.ReportEvent micPass, info, details
		ElseIf Environment("RunFrom") = "ALM" and browserObj <> "" and expectedResult <> "" Then
			verifyResultsInALM browserObj, stepName, "Passed", testDescription, expectedResult, "The result is as expected"
		End If
		
		If browserObj <> "" and expectedResult <> "" and Environment("RunFrom") <> "ALM" and Environment("RunFrom") <> "LOCAL" Then
			createTestStepDetails browserObj,stepName,testDescription,expectedResult,"The result is as expected",testStepStatus
		End If
	Else
		verificationPointNeg = False
		Environment("TestPassed") = False
		testStepStatus = False
		If Environment("RunFrom") = "LOCAL" Then
			Reporter.ReportEvent micFail, info, details
		ElseIf Environment("RunFrom") = "ALM" and browserObj <> "" and expectedResult <> "" Then
			verifyResultsInALM browserObj, stepName, "Failed", testDescription, expectedResult, "The result is not as expected"
			Reporter.ReportEvent micFail, info, details
		End If
		If  browserObj <> "" and expectedResult <> "" and Environment("RunFrom") <> "ALM" and Environment("RunFrom") <> "LOCAL" Then
			createTestStepDetails browserObj,stepName,testDescription,expectedResult,"The result is not as expected."&Replace(Err.Description,"""","'"),testStepStatus
			Err.Clear	
		End If
		
	End If
 
End Function


'***************************************************************
' Function:  decodePercents(text)
' Date Created: ??/??/2006
' Date Modifed: ??/??/2006 - 01/10/2007
' Created By: Ben
' Description: Function decodePercents will return the text string with the %25
'	repleaced with a %.  This is to accommadate the precent url encoding schemes
'***************************************************************

Function decodePercents(text)

	Dim temp

	If inStr(1, text, "%25") <> 0 Then
		temp = Replace(text, "%25", "%")
		decodePercents = temp
	Else
		decodePercents = text
	End If

	If inStr(1, text, "%26") <> 0 Then
		temp = Replace(temp, "%26", "&")
		decodePercents = temp
	End If

	If inStr(1, text, "%3D") <> 0 Then
		temp = Replace(temp, "%3D", "=")
		decodePercents = temp
	End If

	If temp = "" Then
		decodePercents = text
	End If
	
End Function

'***************************************************************
' Function:  typeKeys(keys)
' Date Created: 12/28/2005
' Date Modifed: 12/28/2005
' Created By: Benjamin Wu
' Description: typeKeys will type the keys specfied in parameter 'keys' through 
'		a Windows Shell
'		Parameter, 'keys' should contain a string in the format '{key}'
'***************************************************************

Function typeKeys(keys)

	'Create a windows shell object
	Set WshShell = CreateObject("WScript.Shell")

	'Send the keys to the shell
	wait(1)
	WshShell.SendKeys ""&keys	
	wait(1)
	'End shell object
	Set WshShell = Nothing
	
End Function

'***************************************************************
'Function: getFields (index, datafields, delimiter)
' Date Created: 3/21/2008
' Date Modifed: 3/21/2008
' Created By: Steve Truong
' Description:  Function getFields will get the data at the indicated index, given
'		    the indicated data and the delimiter seperating each index.
'		    Basically it takes a complex simple data object like CSV and parses
'		    it for the text data of the given index.
'		    Arguments Supplied are the index of the data, the actual data text, and the delimiter.
'		    Precondition:  index is valid, that is it corresponds to a real section of the data text.
'				       delimiter is correct
' 		    Returns the data text of the given position when using the given delimiter
'		    NOTE:  index begins from 1 to Number of Elements, actually 0
'***************************************************************

Function getFields(index, datafields, delimiter)

	'Declare Variables
	
	Dim temp		' holds the data to be returned
	Dim tempArr		' array to hold data returned by Split function
	Dim upperIndex	' last index of tempArr

	temp = datafields
	tempArr = Split(datafields, delimiter)	' returns the data between delimiters into an array
	upperIndex = ubound(tempArr)
	
	'return an empy string if datafields contains no data
	
	If upperIndex = -1 Then
		getFields = ""
		Exit Function
	End If
	
	' return the datafield for the specified index
	' if the specified index is greater than the size of the array, then return the value from the last index of the array
	
	If upperIndex >= index Then
		temp = tempArr(index)
	Else
		temp = tempArr(upperIndex)
	End If
	
	getFields = temp
    
End Function

'***************************************************************
'Function: getFieldsUpperNull (index, datafields, delimiter)
' Date Created: 3/21/2008
' Date Modifed: 3/21/2008
' Created By: Steve Truong
' Description:  Function getFields will get the data at the indicated index, given
'		    the indicated data and the delimiter seperating each index.
'		    Basically it takes a complex simple data object like CSV and parses
'		    it for the text data of the given index.
'		    Arguments Supplied are the index of the data, the actual data text, and the delimiter.
'		    Precondition:  index is valid, that is it corresponds to a real section of the data text.
'				       delimiter is correct
' 		    Returns the data text of the given position when using the given delimiter
'		    NOTE:  index begins from 1 to Number of Elements, actually 0
'***************************************************************

Function getFieldsUpperNull(index, datafields, delimiter)

	'Declare Variables
	
	Dim temp		' holds the data to be returned
	Dim tempArr		' array to hold data returned by Split function
	Dim upperIndex	' last index of tempArr

	temp = datafields
	tempArr = Split(datafields, delimiter)	' returns the data between delimiters into an array
	upperIndex = ubound(tempArr)
	
	'return an empy string if datafields contains no data
	
	If upperIndex = -1 Then
		getFieldsUpperNull = ""
		Exit Function
	End If
	
	' return the datafield for the specified index
	' if the specified index is greater than the size of the array, then return the value from the last index of the array
	
	If upperIndex >= index Then
		temp = tempArr(index)
		getFieldsUpperNull = temp
	Else
		getfieldsUpperNull = ""
	End If
	 
End Function



Function verifyTableCellValue(stepNum, stepName, expectedResult, page, object, expected, args)

	browserObj = getFields(0,page , "-")
	windowObj = getFieldsUpperNull(3,page, "-")
	frameObj=getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")
	
	Select Case UCase(args)

	Case "WINDOW"    'verifies a row in a table that is located within a Window

		If Instr(object, ":=") Then	
			Dim desc(2)
			desc(0) = getFields(0, object, "~")
			desc(1) = getFields(1, object, "~")
			desc(2) = getFields(2, object, "~")
			tableObj = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).webtable(desc(0), desc(1), desc(2))		
		Else
			tableObj = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).webtable(object)
		End If
		
	Case Else 'No Argument

		If Instr(object, ":=") Then
	
			Dim des(2)	
			des(0) = getFields(0, object, "~")
			des(1) = getFields(1, object, "~")
			des(2) = getFields(2, object, "~")
			tableObj = Browser(browserObj).Page(page).Frame(frameobj).webtable(des(0), des(1), des(2))
		Else
			tableObj = Browser(browserObj).Page(page).Frame(frameobj).WebTable(object)
		End If

	End Select
	
	If instr(1,expected,"?") then
		ExpectArray = Split(expected, "?")
	Else 
		ExpectArray = Split(expected, "~")
	End If
	
	colNames = Split(tableObj.GetROProperty("column names"),";")
	testColumn = ExpectArray(0)		
		
	For cn = 0 To UBound(colNames) Step 1
		If colNames(cn) = testColumn Then
			y = cn + 1
			Exit For
		End If
	Next
	
	rc = tableObj.GetROProperty("rows")
		
	For x = 1 To rc Step 1
		sValue = tableObj.GetCellData(x,y)	
		If trim(sValue) <> trim(ExpectArray(y-1)) Then
			sFail = True 
			Exit For
		Else sFail = False
		End If

		If y = (ubound(ExpectArray)+1) AND sFail = False Then
			Exit For
		End If

		If y = (ubound(ExpectArray)+1) Then
			Exit For
		End If
		
	next


		logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object

		If sFail = True Then
		logDetails= "Expected: " &expected &CHR(13) & "Actual: " &"This row does not exist in the table. Compare the expected results to the table."
		Else
		logDetails= "Expected: " &expected &CHR(13) & "Actual: " &"The row was found"
		End If

 	result = verificationPoint("False", sFail, logObject, logDetails)	
 
	
End Function



'***********************************************************************
' Function: verificationPointCmp(baseline, capture, info, details)
' Date Created: 01/07/2020
' Date Modifed: 01/07/2020
' Created By:  Sameen Hashmi
' Description: Compares the result based on the comparison operator
'**********************************************************************

Function verificationPointCmp(baseline, capture, info, details, browserObj, expectedResult, comparisonFactor)
		
	capture = trim(capture)
	baseline = trim(baseline)
	comparisonFactor = Trim(comparisonFactor)
	
	If capture = "" Then
		capture = "2078-12-31"
	End If

	stepName = Mid(info,Instr(1,info,"Step:")+6,Instr(1,info," - ")-Instr(1,info,"Step:")-6)
	testDescription = Mid(info,Instr(1,info," - ")+3,Instr(1,info,"Page:")-Instr(1,info," - ")-3)
	
	Execute "Res = " & "DateValue(" &Chr(34)& capture &Chr(34) &")"& comparisonFactor & "DateValue(" &Chr(34)& baseline &Chr(34) &")"
	
	If Res Then		
		verificationPointCmp = True
		testStepStatus = True	
		
		If Environment("RunFrom") = "LOCAL" Then
			Reporter.ReportEvent micPass, info, details
		ElseIf Environment("RunFrom") = "ALM" and browserObj <> "" Then
			verifyResultsInALM browserObj, stepName, "Passed", testDescription, expectedResult, "The result is as expected"
		End If
		If browserObj <> "" and expectedResult <> "" and Environment("RunFrom") <> "ALM" and Environment("RunFrom") <> "LOCAL" Then
			createTestStepDetails browserObj,stepName,testDescription,expectedResult,"The result is as expected",testStepStatus
		End If
			
	Else
		verificationPointCmp = False
	      Environment("TestPassed") = False
	      testStepStatus = False
		If Environment("RunFrom") = "LOCAL" Then
			Reporter.ReportEvent micFail, info, details
		ElseIf Environment("RunFrom") = "ALM" and browserObj <> "" Then
			verifyResultsInALM browserObj, stepName, "Failed", testDescription, expectedResult, "The result is not as expected"
			Reporter.ReportEvent micFail, info, details
		End If
		If  browserObj <> "" and expectedResult <> "" and Environment("RunFrom") <> "ALM" and Environment("RunFrom") <> "LOCAL" Then
			createTestStepDetails browserObj,stepName,testDescription,expectedResult,"The result is not as expected."&Replace(Err.Description,"""","'"),testStepStatus
			Err.Clear	
		End If
	    
	End If



End Function

