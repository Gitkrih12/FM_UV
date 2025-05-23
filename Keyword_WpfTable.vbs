
'***************************************************************
' Function: WpfTable_VerifyCellData (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 05/27/2023
' Created By: Raghunath Konda
' Description:  Verify cell data in a table
' Modification: 
'***************************************************************

Function WpfTable_VerifyCellData (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)
	wpfWindowObj = getFields(0,page , "-")
	wpfObj = getfieldsUpperNull(1,page , "-")
	
	If wpfObj = "" Then
		ident = "WpfWindow"
	Else
		ident = "WpfObject"  
	End If
	
	'Parse property and expected result
	
	coords=getFields(0, expected, ":=")
	
	If instr(expected,":?") <> 0 Then
		exp_Value=getFields(1, expected, ":=")
		minwait = cint(getFields(1, exp_Value, ":?"))
		expected = getFields(0, exp_Value, ":?")
		expected = replaceConstants(expected)
	Else 
		minwait = 0
		expected = getFields(1, expected, ":=")
		expected=replaceConstants(expected)
	End If
	
    

	'Parse object description
	
	desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")

 	
    If Instr(expected,"~") <> 0 Then
 		comparisonFactor = getFields(0, Expected, "~")
		expected = getFields(1, Expected, "~")' 	
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
	ElseIf instr(expected, "ENV_") Then	
		expected = Environment.Value(expected)
	End If


	'Set up log results

	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	logDetails= "Expected:  " &expected &CHR(13)
	
	Select Case ident
 
	 	Case "WpfWindow"
	  
			If InStr(desc(0), ":=") <> 0 Then
				Set tableobj = WpfWindow(wpfWindowObj).WpfTable(desc(0), desc(1),desc(2))
			Else
				Set tableobj = WpfWindow(wpfWindowObj).WpfTable(desc(0))
			End If
		
		Case "WpfObject"
			
			If InStr(desc(0), ":=") <> 0 Then
				Set tableobj = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfTable(desc(0), desc(1),desc(2))
			Else
				Set tableobj = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfTable(desc(0))
			End If
	
	 End Select
	
'	row,1;=ENDED OK. NUMBER OF FAILURES SET TO 0
	coord = Split(coords,",")
	
	colm = cint(coord(1))
	isFound = False
	
	Select Case UCase(args)
	
		Case "CONTROLM"
			'Verify Property
			minwait = minwait * 6
			For wmin = 1 To minwait Step 1
				If coord(0) = "Rnum" Then
				rc = tableobj.RowCount
					For td = 0 To rc-1 Step 1
						If instr(tableobj.GetCellData(td,colm), expected) Then
							isFound = True
							Exit For
						End If
					Next
					
					If isFound Then
						actual = Trim(tableobj.GetCellData(td,colm))
						Exit for
					Else
						wait 8
						WpfWindow(wpfWindowObj).WpfButton("Refresh").Click
						wait 2
		
					End If
				ElseIf coord(0) = "-1" or coord(0) = "RowIndex" Then
					actual = Trim(tableobj.GetCellData(Environment("RowIndex"),colm))
				ElseIf coord(0) = "TestVariable" Then
					actual = Trim(tableobj.GetCellData(Environment("TestVariable"),colm))
				Else
					actual = Trim(tableobj.GetCellData(coord(0),colm))
				End If
			Next		
			
			If not isFound Then
				actual = "Job failed or didn't complete in expected time"
			End If
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )	   
			
		Case Else 
		'Verify Property
		
			If coord(0) = "Rnum" Then
				For td = 0 To rc-1 Step 1
					If instr(tableobj.GetCellData(td,colm), expected) Then
						isFound = True
						Exit For
					End If
				Next
				
				If isFound Then
					actual = Trim(tableobj.GetCellData(td,colm))
				Else
					actual = "Exected text is not fount in the table"
				End If
			ElseIf coord(0) = "-1" or coord(0) = "RowIndex" Then
				actual = Trim(tableobj.GetCellData(Environment("RowIndex"),colm))
			ElseIf coord(0) = "TestVariable" Then
				actual = Trim(tableobj.GetCellData(Environment("TestVariable"),colm))
			Else
				actual = Trim(tableobj.GetCellData(coord(0),colm))
			End If
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(expected, actual, logObject, logDetails, wpfWindowObj, expectedResult )	   
		
	End Select
	
End Function


'***************************************************************
' Function: WpfTable_selectTableRow (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 12/11/2023
' Date Modifed: 12/11/2023
' Created By: Raghunath Konda
' Description:  Selects row in wpftable
' Modification: 
'***************************************************************


Function WpfTable_selectTableRow (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)
	wpfWindowObj = getFields(0,page , "-")
	
	'Parse object description
	
	desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")


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
		expectd = Environment("TestVariable")
	End If


	'Set up log results

	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	logDetails= "Expected:  " &expected &CHR(13)
	
	Select Case ident
 
	  Case "WpfWindow"
	  
		Select Case UCase(args)
		
		   Case Else
			
				If InStr(desc(0), ":=") Then
					Set tableobj = WpfWindow(wpfWindowObj).WpfTable(desc(0), desc(1),desc(2))
				Else
					Set tableobj = WpfWindow(wpfWindowObj).WpfTable(desc(0))
				End If
				tableobj.SelectRow(Cint(expected))
		 End Select
	
		Case "WpfObject"
		  
			Select Case UCase(args)
			
				Case Else
				
					If InStr(desc(0), ":=") Then
						Set tableobj = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfTable(desc(0), desc(1),desc(2))
					Else
						Set tableobj = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfTable(desc(0))
					End If
					tableobj.SelectRow(Cint(expected))
					
			End Select
			 
		End Select
			
	logDetails = logDetails & " Actual: " &actual  
	result = verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult )	   
			   
	
End Function

'***************************************************************
' Function: WpfTable_GetCellData (stepNum, stepName, expectedResult, page, object, expected, args)
' Date Created: 05/27/2023
' Created By: Raghunath Konda
' Description:  Get cell data in a table
' Modification: 
'***************************************************************

Function WpfTable_GetCellData (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables

	Dim prop, logObject, logDetails
	Dim desc(2)
	wpfWindowObj = getFields(0,page , "-")
	wpfObj = getfieldsUpperNull(1,page , "-")
	
	If wpfObj = "" Then
		ident = "WpfWindow"
	Else
		ident = "WpfObject"  
	End If
		
	'Parse object description
	
	desc(0) = getFields(0, object, "~")
	desc(1) = getFields(1, object, "~")
	desc(2) = getFields(2, object, "~")
	
	'Set up log results

	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	logDetails= "Expected:  " &expected &CHR(13)
	
	Select Case ident
 
	 	Case "WpfWindow"
	  
			If InStr(desc(0), ":=") <> 0 Then
				Set tableobj = WpfWindow(wpfWindowObj).WpfTable(desc(0), desc(1),desc(2))
			Else
				Set tableobj = WpfWindow(wpfWindowObj).WpfTable(desc(0))
			End If
		
		Case "WpfObject"
			
			If InStr(desc(0), ":=") <> 0 Then
				Set tableobj = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfTable(desc(0), desc(1),desc(2))
			Else
				Set tableobj = WpfWindow(wpfWindowObj).WpfObject(wpfObj).WpfTable(desc(0))
			End If
	
	 End Select
	
'	row,1;=ENDED OK. NUMBER OF FAILURES SET TO 0

	coord = Split(expected,",")
	If coord(0) = "RowIndex" Then
		coord(0) = CInt(Environment("RowIndex"))
	ElseIf coord(0) = "TestVariable" Then
		coord(0) = CInt(Environment("TestVariable"))
	End If
	
	Select Case UCase(args)

		Case Else 
		'GetCell data
			actual  = tableobj.GetCellData(coord(0),coord(1))
			Environment(coord(2)) = actual  
			logDetails = logDetails & " Actual: " &actual  
			result = verificationPoint(True, True, logObject, logDetails, wpfWindowObj, expectedResult )	   
		
	End Select
	
End Function




