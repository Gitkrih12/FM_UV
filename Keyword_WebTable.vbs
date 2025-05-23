
'***************************************************************
'File Name: Keyword_WebTable.vbs
'Date Ceated: 10/02/2008
'Created By: Chris Thompson
'Description: Library contains all keyword functions for the WebTable object type
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
' Function: WebTable_VerifyExists (stepNum, stepName, page, object, expected, args)
' Date Created: 10/02/2007
' Date Modifed: 10/02/2007
' Created By: Chris Thompson
' Description:  VerifyExists keyword for the WebTable type object
'***************************************************************

Function WebTable_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

 	browserObj = getFields(0,page , "-")
	windowObj=getFields(3, page, "-")
    frameObj=getfieldsUpperNull(2,page,"-")
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

	'Verify existence

	Select Case UCase(args)
	
	Case "WINDOW"
		If Instr(desc(0), ":=") Then
			actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1), desc(2)).Exist
		Else
			actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).Exist
		End If

	Case Else

	If  frameObj <> "" Then
		If InStr(desc(0), ":=") Then
			actual = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1), desc(2)).Exist
		Else
			actual = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).Exist
		End If	
	Else
		 If InStr(desc(0), ":=") Then
			actual = Browser(browserObj).Page(page).WebTable(desc(0), desc(1), desc(2)).Exist
		Else
			actual = Browser(browserObj).Page(page).WebTable(desc(0)).Exist
		End If	
	End If

	End Select
	
	result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)    

End Function


'***************************************************************
' Function: WebTable_VerifyProperty (stepNum, stepName, page, object, expected, args)
' Date Created: 12/27/2006
' Date Modifed: 12/27/2006
' Created By: Chris Thompson
' Description:  Verify Property keyword for the WebEdit type object
' Modification: 03/30/07, BW, Added Timestamp arguement to handle verifying timestamp value
'***************************************************************

Function WebTable_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

 	browserObj = getFields(0,page , "-")
	windowObj=getFields(3, page, "-")
    frameObj=getfieldsUpperNull(2,page,"-")
	page = getFields(1,page , "-")
	
	'Parse property and expected result

	prop=getFields(0, expected, ":=")
	expected=getFields(1, expected, ":=")
    expected=replaceConstants(expected)
    
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
	If (args = "") Then
		logDetails= "Expected:  " &expected &CHR(13)
	Else
		logDetails= "Expected: (" &args &")  " &expected &CHR(13)
	End If

	'Verify Property
	Select Case UCase(args)

	Case "WINDOW"
				If InStr(desc(0), ":=") Then
					actual = Browser( browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1),desc(2)).GetROproperty(prop) 
				Else
					actual = Browser( browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetROproperty(prop)
				End If
		
	Case Else
			If  frameObj <> "" Then
				If InStr(desc(0), ":=") Then
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1),desc(2)).GetROproperty(prop) 
				Else
					actual = Browser( browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetROproperty(prop)
				End If

			Else

				 If InStr(desc(0), ":=") Then
					actual = Browser( browserObj).Page(page).WebTable(desc(0), desc(1),desc(2)).GetROproperty(prop) 
				Else
					actual = Browser( browserObj).Page(page).WebTable(desc(0)).GetROproperty(prop)
				End If
			End If
			
	End Select
			   	  
			   logDetails = logDetails & " Actual: " &actual  
			   result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult )	   
	
End Function


'***************************************************************
' Function: WebTable_VerifyProperty (stepNum, stepName, page, object, expected, args)
' Date Created: 12/07/2020
' Date Modifed: 12/07/2020
' Created By: Sameen Hashmi
' Description:  Verify cell data in a table
' Modification: 
'***************************************************************

Function WebTable_VerifyCellData (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

 	browserObj = getFields(0,page , "-")
	windowObj=getFields(3, page, "-")
    frameObj=getfieldsUpperNull(2,page,"-")
	page = getFields(1,page , "-")
	
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
	
	If  frameObj <> "" Then
		If InStr(desc(0), ":=") Then
			Set tableobj = Browser( browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1),desc(2))
		Else
			Set tableobj = Browser( browserObj).Page(page).Frame(frameObj).WebTable(desc(0))
		End If
	Else
		If InStr(desc(0), ":=") Then
			Set tableobj = Browser( browserObj).Page(page).WebTable(desc(0), desc(1),desc(2))
		Else
			Set tableobj = Browser( browserObj).Page(page).WebTable(desc(0))
		End If
	End If
	
	coord = Split(coords,",")
	rc = tableobj.RowCount
	isFound = False
	
	'Verify Property
	If coord(0) = "0" Then
		If UCase(args) = "INSTRING" Then
	    	For td = 1 To rc Step 1
				If Instr(tableobj.GetCellData(td,coord(1)),expected) <> 0 Then
					isFound = True
					Exit For
				End If
			Next
		Else
			For td = 1 To rc Step 1
				If tableobj.GetCellData(td,coord(1)) = expected Then
					isFound = True
					Exit For
				End If
			Next
	    End If
		
		
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
' Function: WebTable_VerifyProperty (stepNum, stepName, page, object, expected, args)
' Date Created: 12/11/2020
' Date Modifed: 12/11/2020
' Created By: Sameen Hashmi
' Description:  Verify row data in a table
' Modification: 
'***************************************************************

Function WebTable_VerifyTableRow (stepNum, stepName, expectedResult, page, object, expected, args)

	browserObj = getFields(0,page , "-")
	windowObj = getFieldsUpperNull(3,page, "-")
	frameObj=getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")
    
    sFail = True

	If Instr(object, ":=") Then
		Dim des(2)

		des(0) = getFields(0, object, "~")
		des(1) = getFields(1, object, "~")
		des(2) = getFields(2, object, "~")
		Set tableObj = Browser(browserObj).Page(page).Frame(frameobj).webtable(des(0), des(1), des(2))
	Else
		Set tableObj = Browser(browserObj).Page(page).Frame(frameobj).webtable(object)		
	End If
	
	If instr(1,expected,"?") then
		ExpectArray = Split(expected, "?")
	Else 
		ExpectArray = Split(expected, "~")
	End If
	
	If args = "" Then
		x = 1
	Else
		x = tableObj.GetRowWithCellText(args)
	End If
		
	For y = 1 to (ubound(ExpectArray) +1)
		sValue = tableObj.GetCellData(x,y)
		If instr(sValue, "ERROR") = 1 Then
			sFail = True
			Exit For
		End If

		If trim(ExpectArray(y-1)) = "Environment('Datestamp')" Then
			ExpectArray(y-1) = Environment("Datestamp")
		Elseif Instr (ExpectArray(y-1),"Environment('Datestamp')<") Then
			ExpectArray(y-1) = getfields(2,ExpectArray(y-1),"<")
			ExpectArray(y-1) = mid(ExpectArray(y-1) ,1,len(ExpectArray(y-1) )-1)
			Call Utility_GenDatestamp(stepNum, stepName, expectedResult, page, object,ExpectArray(y-1), "Run Time")  
			ExpectArray(y-1) = Environment("Datestamp")
		ElseIf trim(ExpectArray(y-1)) = "Environment('Timestamp')" Then
			ExpectArray(y-1) = Environment("Timestamp")
		ElseIf instr(1, ExpectArray(y-1), "SQL") Then
			ExpectArray(y-1) = Environment("SQLResults")
		End If

		If trim(sValue) <> trim(ExpectArray(y-1)) Then
			sFail = True
			Exit For
		Else 
			sFail = False
		End If

		If y = (ubound(ExpectArray)+1) Then
			Exit For
		End If				
	Next	

	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object

	If sFail Then
		logDetails = "Expected: " &expected &CHR(13) & "Actual: " &"This row does not exist in the table. Compare the expected results to the table."
	Else
		logDetails = "Expected: " &expected &CHR(13) & "Actual: " &"The row was found"
	End If

 	result = verificationPoint("False", sFail, logObject, logDetails, browserObj, expectedResult)

End Function



'***************************************************************
' Function: WebTable_GetRowIndex (stepNum, stepName, page, object, expected, args)
' Date Created: 03/02/2021
' Date Modifed: 03/02/2021
' Created By: Sameen Hashmi
' Description:  Verify cell data in a table
' Modification: 
'***************************************************************

Function WebTable_GetRowIndex (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

 	browserObj = getFields(0,page , "-")
	windowObj=getFields(3, page, "-")
    frameObj=getfieldsUpperNull(2,page,"-")
	page = getFields(1,page , "-")
	
	'Parse property and expected result

	col=getFields(0, expected, ":=")
	expected=getFields(1, expected, ":=")
    expected=replaceConstants(expected)
    
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
	
	If  frameObj <> "" Then
		If InStr(desc(0), ":=") Then
			Set tableobj = Browser( browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1),desc(2))
		Else
			Set tableobj = Browser( browserObj).Page(page).Frame(frameObj).WebTable(desc(0))
		End If
	Else
		If InStr(desc(0), ":=") Then
			Set tableobj = Browser( browserObj).Page(page).WebTable(desc(0), desc(1),desc(2))
		Else
			Set tableobj = Browser( browserObj).Page(page).WebTable(desc(0))
		End If
	End If
	
	Environment("RowIndex") = tableobj.GetRowWithCellText(expected,CInt(col))
	
End Function



'***************************************************************
' Function: WebTable_GetCellData (stepNum, stepName, page, object, expected, args)
' Date Created: 04/02/2021
' Date Modifed: 04/02/2021
' Created By: Sameen Hashmi
' Description:  Verify cell data in a table
' Modification: 
'***************************************************************

Function WebTable_GetCellData (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects
 	browserObj = getFields(0,page , "-")
	windowObj=getFields(3, page, "-")
    frameObj=getfieldsUpperNull(2,page,"-")
	page = getFields(1,page , "-")

	'Parse object description	
	desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")

	'Set up log results
	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	logDetails= "Expected:  " &expected &CHR(13)
	
	If  frameObj <> "" Then
		If InStr(desc(0), ":=") Then
			Set tableobj = Browser( browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1),desc(2))
		Else
			Set tableobj = Browser( browserObj).Page(page).Frame(frameObj).WebTable(desc(0))
		End If
	Else
		If InStr(desc(0), ":=") Then
			Set tableobj = Browser( browserObj).Page(page).WebTable(desc(0), desc(1),desc(2))
		Else
			Set tableobj = Browser( browserObj).Page(page).WebTable(desc(0))
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


'***************************************************************
' Function: WebTable_GetProperty (stepNum, stepName, page, object, expected, args)
' Date Created: 02/11/2021
' Date Modifed: 02/11/2021
' Created By: Sameen Hashmi
' Description:  Get Property keyword for the WebTable type object
' Modification: 
'***************************************************************

Function WebTable_GetProperty(stepNum, stepName, expectedResult, page, object, expected, args)

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
			Set testObj = Browser( browserObj).Page(page).WebTable(desc(0), desc(1),desc(2)) 
		Else
			Set testObj = Browser( browserObj).Page(page).WebTable(desc(0))
		End If	   

	Case "Frame"
	
		If InStr(desc(0), ":=") Then
			Set testObj = Browser( browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1),desc(2))
		Else
			Set testObj = Browser( browserObj).Page(page).Frame(frameObj).WebTable(desc(0))
		End If

	End Select
	
	Environment("TestVariable") = testObj.GetROproperty(expected)
		
End Function
