
'***************************************************************
' Function: Database_ExecuteSQL (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  Runs an SQL query and stores the results in an Environment variable
'***************************************************************

Function Database_ExecuteSQL (stepNum, stepName, expectedResult, page, object, expected, args)

	'Set up log results
	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	If (args = "") Then
		logDetails= "Expected:  " &expected &CHR(13)
	Else
		logDetails= "Expected: (" &args &")  " &expected &CHR(13)
	End If
	
	expected = replaceConstants(expected)
	object = replaceConstants(object)
	
	set con = createObject("ADODB.Connection")
	con.ConnectionTimeout = 0
	con.open object
	con.CursorLocation = 3
	
	Set ss= Createobject("ADODB.RecordSet")
	set comObj = createObject("ADODB.Command")
	comObj.activeConnection = con
	comObj.commandText = expected
	comObj.commandTimeout = 0
	comObj.CommandType = 1
	Set ss = comObj.execute
	
	Environment ("SQLResults") = ""

	If ss.recordcount > 0 Then	
		For x = 1 to ss.fields.count
			Environment ("SQLResults") = Environment ("SQLResults") & "~" &trim(cstr(ss.fields.item(x-1).name)) &"~|" 
			ss.movefirst 
			While not ss.eof
				Environment ("SQLResults") = Environment ("SQLResults") & trim(cstr(ss(ss.fields.item(x-1).name).VALUE)) &"|"
				ss.movenext
			Wend
		Next		
	Else
		Environment("RunValidation") = "SQL Validation returned no rows"
		verificationPoint True, False, logObject, logDetails, "MAIN", expectedResult
		exitaction
	End if

End Function

'***************************************************************
' Function: Database_ExecuteSQL (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  Runs an SQL query and stores the results in an Environment variable
'***************************************************************

Function Database_VerifySQL (stepNum, stepName, expectedResult, page, object, expected, args)

	prop=getFields(0, expected, ":=")
	expected=getFields(1, expected, ":=")
	sitem=expected
	expected = replaceConstants(expected)

	expected=replaceSQLReference(expected)
	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	logDetails= "Actual:  " &expected &" Expected: " &Prop 
	If args = "INSTRING" Then
		result = verificationPointInstr(prop, expected, logObject, logDetails, browserObj, expectedResult)
	Else
		result =  verificationPoint(Prop, expected, logObject, logDetails, browserObj, expectedResult )
	End If
	If result = False Then
		Environment("RunValidation") = Environment("RunValidation") &" Field: " &sItem &" - Actual: " &expected &" Expected: " &Prop
	End If
	

End Function

'*****************************************************************************
'Function: Database_GetDate (stepNum, StepName. page, object, expected, args)
'Date Created; 10/29/2008
'Date Modified: 10/29/2008
'Created By: Jason Craig
'Description: Retrieves the current date + or - expected value from the database.  Stores the results in an Environment variable
'******************************************************************************

Function Database_GetDate (stepNum, stepName, expectedResult, page, object, expected, args)

	expected = replaceConstants(expected)
	object = replaceConstants(object)
	Set ss = CreateObject("ADODB.RecordSet")
	sqlquery = "select CONVERT(varchar(10), GETDATE() "&expected&", 101) AS [Date];"
	ss.Open sqlquery, object, 3, 4, 1

	Environment ("SQLResults") = ""

	If ss.recordcount <> -1 Then
		For x = 1 to ss.fields.count
			Environment("SQLResults") = Environment ("SQLResults") & "~" &trim(cstr(ss.fields.item(x-1).name)) &"~|" 
			ss.movefirst 
			While not ss.eof
				Environment("SQLResults") = Environment ("SQLResults") & trim(cstr(ss(ss.fields.item(x-1).name).VALUE)) &"|"
				'Environment("SQLResults") = replace(Environment("SQLResults", "|", ""))

				Set objRegEx = CreateObject("VBScript.RegExp") 'checks Month Format
				objRegEx.Global = True
				objRegEx.Pattern = "0\d/"

				Set ColMatches = objRegEx.Execute(Environment("SQLResults"))

				If ColMatches.Count > 0 Then
					Environment("SQLResults") = replace(Environment("SQLResults"), "|0", "|")
				End If

				Set objRegEx = CreateObject("VBScript.RegExp") 'checks Day Format
				objRegEx.Global = True
				objRegEx.Pattern = "/0\d"

				Set ColMatches = objRegEx.Execute(Environment("SQLResults"))

				If ColMatches.Count > 0 Then
					Environment("SQLResults") = replace(Environment("SQLResults"), "/0", "/")
				End If
					ss.movenext
			Wend
		Next
		
	Else

		Environment("RunValidation") = "SQL Validation returned no rows"
		exitaction
	End if

	a=a
End Function
