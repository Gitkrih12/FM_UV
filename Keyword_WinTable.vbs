
'***************************************************************
'File Name: Keyword_WinTable.vbs
'Date Ceated: 07/26/2023
'Created By: Keerthi Singh
'Description: Library contains all keyword functions for the WinRadioButton object type
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
' Function: WinTable_VerifyCellData(stepNum, stepName, page, object, expected, args)
' Date Created: 07/26/2023
' Created By: Keerthi Singh
' Description: VerifyCellData  keyword for the WinTable type object

'*************************************************************** 
Function WinTable_VerifyCellData (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

 	windowObj = getFields(0,page , "-")
    dialogObj = getFieldsUpperNull(1,page , "-")

	'Parse property and expected result

	coords=getFields(0, expected, ":=")
	expected=getFields(1, expected, ":=")
    expected=replaceConstants(expected)
    
    If Instr(expected,"~") <> 0 Then
 		comparisonFactor = getFields(0, Expected, "~")
		expected = getFields(1, Expected, "~")
 	End If
 	
    If expected = "Environment('Datestamp')" Then
		expected = environment("Datestamp")
	Elseif instr (expected,"Environment('Datestamp')<") Then
		expected1 = getfields(2,expected,"<")
		expected1 = mid(expected1,1,len(expected1)-1)
		Call Utility_GenDatestamp(stepNum, stepName,expectedResult, page, object, expected1, "Run Time")  
		expected = environment("Datestamp")
	Elseif expected = "Environment('sData')" Then
		expected = Environment("sData")
	Elseif expected = "Environment('Timestamp')" Then
		expected = Environment("Timestamp")
	ElseIf expected = "TestVariable" Then
		expected = Environment("TestVariable")
	End If

	'Parse object description
	
	desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")

	'Set up log results

	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	logDetails= "Expected:  " &expected &CHR(13)
	
	If  dialogObj <> "" Then
		If InStr(desc(0), ":=") Then
			Set tableobj = Window(windowObj).Dialog(dialogObj).WinTable(desc(0), desc(1),desc(2))
		Else
			Set tableobj = Window(windowObj).Dialog(dialogObj).WinTable(desc(0))
		End If
	Else
		If InStr(desc(0), ":=") Then
			Set tableobj =  Window(windowObj).WinTable(desc(0), desc(1),desc(2))
		Else
			Set tableobj = Window(windowObj).WinTable(desc(0))
		End If
	End If
	
	coord = Split(coords,",")
	rc = tableobj.RowCount
	isFound = False
	
	'Verify Property
	If coord(0) = "0" Then
		For td = 1 To rc Step 1
			If tableobj.GetCellData(td,coord(1)) = expected Then
				isFound = True
				Exit For
			End If
		Next
		
		If isFound Then
			actual = Trim(tableobj.GetCellData(td,coord(1)))
		Else
			actual = "Error"
		End If
	ElseIf coord(0) = "-1" or coord(0) = "RowIndex" Then
		actual = Trim(tableobj.GetCellData(Environment("RowIndex"),coord(1)))
	ElseIf coord(0) = "TestVariable" Then
		actual = Trim(tableobj.GetCellData(Environment("TestVariable"),coord(1)))
	Else
		actual = Trim(tableobj.GetCellData(coord(0),coord(1)))
	End If
			   	  
	logDetails = logDetails & " Actual: " &actual  

	Select Case UCase(args)

		'Verify Instring  
		Case "INSTRING"
			result = verificationPointInstr(expected, actual, logObject, logDetails , browserObj, expectedResult)
		
		' Verify by comparing
		Case "COMPARE"
			result = verificationPointCmp(expected, actual, logObject, logDetails, browserObj, expectedResult, comparisonFactor)

		'No Argument     
		Case Else
			result = verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )	   
			   
	End Select
	
End Function



'***************************************************************
' Function: WinTable_GetCellData(stepNum, stepName, page, object, expected, args)
' Date Created: 07/26/2023
' Created By: Keerthi Singh
' Description: GetCellData  keyword for the WinTable type object

'***************************************************************

Function WinTable_GetCellData (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects
 	windowObj = getFields(0,page , "-")
    dialogObj = getFieldsUpperNull(1,page , "-")

	'Parse object description	
	desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")

	'Set up log results
	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	logDetails= "Expected:  " &expected &CHR(13)
	
	If  dialogObj <> "" Then
		If InStr(desc(0), ":=") Then
			Set tableobj = Window(windowObj).Dialog(dialogObj).WinTable(desc(0), desc(1),desc(2))
		Else
			Set tableobj = Window(windowObj).Dialog(dialogObj).WinTable(desc(0))
		End If
	Else
		If InStr(desc(0), ":=") Then
			Set tableobj =  Window(windowObj).WinTable(desc(0), desc(1),desc(2))
		Else
			Set tableobj = Window(windowObj).WinRadioButton(desc(0))
		End If
	End If
	
	coord = Split(expected,",")
	If coord(0) = "RowIndex" Then
		coord(0) = CInt(Environment("RowIndex"))
	ElseIf coord(0) = "TestVariable" Then
		coord(0) = CInt(Environment("TestVariable"))
	End If
	
	Environment("TestVariable") = tableobj.GetCellData(coord(0),coord(1))
	
End Function
