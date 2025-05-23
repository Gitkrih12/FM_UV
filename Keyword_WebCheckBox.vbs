'***************************************************************
'File Name: Keyword_WebCheckBox.vbs
'Date Ceated: 1/25/2006
'Created By: Chris Thompson & Steve Truong
'Description: Library contains all keyword functions for the WebCheckBox object type
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
' Function: WebCheckBox_Select (stepNum, stepName, page, object, sValue, args)
' Date Created: 1/25/2006
' Date Modifed: 05/27/2021
' Created By: Chris Thompson & Steve Truong
' Description:  Select keyword for the WebCheckBox type object
' Updated By : Sameen Hashmi
' Last Update Comments : Included ifexists case to select the checkbox only if it exists
'***************************************************************

Function WebCheckBox_Select (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2), descVal(2)

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
	
	descVal(0) = getFields(1, desc(0), ":=")
	If descVal(0) = "RowIndex" Then
		desc(0) = Replace(desc(0),"RowIndex",Cstr(CInt(Environment("RowIndex"))-1))
	End If
	descVal(1) = getFields(1, desc(1), ":=")
	If descVal(1) = "RowIndex" Then
		desc(1) = Replace(desc(1),"RowIndex",Cstr(CInt(Environment("RowIndex"))-1))
	End If
	descVal(2) = getFields(1, desc(2), ":=")
	If descVal(2) = "RowIndex" Then
		desc(2) = Replace(desc(2),"RowIndex",Cstr(CInt(Environment("RowIndex"))-1))
	End If

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

			Case Else

			If InStr(desc(0), ":=") Then
				Browser(browserObj).Page(page).WebCheckBox(desc(0), desc(1),desc(2)).Set expected
				actual = Browser(browserObj).Page(page).WebCheckBox(desc(0), desc(1),desc(2)).GetROProperty("checked")
			Else
				Browser(browserObj).Page(page).WebCheckBox(desc(0)).Set expected
				actual = Browser(browserObj).Page(page).WebCheckBox(desc(0)).GetROProperty("checked")
			End If		

		End Select

	Case "Window"

		Select Case UCase(args)

			Case "SPLIT"

					'Selects the Checkbox  with a description in a Column  that matches the sValue 
					'takes WebTable Object
					'tester must chose "ON" or "OFF"

					' Parse on either ? or ~

					 If instr(1,expected,"?") then
						sValue = getFields(0, expected, "?")
						expected = getFields(1, expected, "?")
					Else
						sValue = getFields(0, expected, "~")
						expected = getFields(1, expected, "~")
					End If

					x = 1  
					y = 2  

				   'This section handles the situation when all of the checkboxes and text are considerted to be within the same row and column of a webtable
				   'does not currently handle descriptive programming for WebTable Object 1-16-2009
				   Dim cCount
					If Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).ColumnCount (x) = 1 Then
						y = 1
						Do
							Allitems = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x,y)
						If instr(1, Allitems, sValue) > 0 Then
						   strProp =  Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetROProperty("outerhtml")
						   arrProp = split(strProp, "<BR>")
						   z = 0
						   Do
							   If instr(arrProp(z), sValue) > 0 Then
								   Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x ,1, "WebCheckBox", z).Set expected
								   wait (1)
								   actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x,1,"WebCheckBox", z).GetROProperty("checked")
								   Exit Do
							   End If
								z = z + 1
							Loop until z = ubound(arrProp) + 1
						End If
						x = x + 1
						Loop until instr(Allitems, "ERROR") = 1
					'end same row same column
					
					ElseIf Instr(desc(0), ":=") Then
					Do
						Allitems = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1), desc(2)).GetCellData(x,y)

						If instr (1, Allitems, sValue) > 0 Then
							Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1), desc(2)).ChildItem(x ,1, "WebCheckBox", 0).Set expected
							actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1), desc(2)).ChildItem(x , 1, "WebCheckBox", 0).GetROProperty("checked")
							Exit Do
						End If
						x = x + 1
					Loop until instr(Allitems, "ERROR") = 1
					
					Else
					 x = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetRowWithCellText (sValue, y, 1)
					Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x ,1, "WebCheckBox", 0).Set expected 
					actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x , 1, "WebCheckBox", 0).GetROProperty("checked")  
				   '' Do
						''Allitems = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x,y)

						''If instr (1, Allitems, sValue) > 0 Then
						   '' Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x ,1, "WebCheckBox", 0).Set expected
							''actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x , 1, "WebCheckBox", 0).GetROProperty("checked")
						   '' Exit Do
					   '' End If
						''x = x + 1
					''Loop until instr(Allitems, "ERROR") = 1

					' For Data Entry: Exit script if not found
					
					If instr(Allitems, "ERROR") = 1 Then
						Environment("RunComments") = "Checkbox description: "&sValue&" not found."
						Environment("RunFailures") = Environment("RunFailures") + 1
						Environment("RunTimeError") = "No"
						If (expected = "ON") Then
							result =  verificationPoint("1","Checkbox description: "&sValue&" not found." , logObject, logDetails, browserObj, expectedResult )
						Else
							result =  verificationPoint("0", "Checkbox description: "&sValue&" not found.", logObject, logDetails , browserObj, expectedResult)
						End If
						ExitAction
					End If

				End If

			Case "SPLIT2"
				'Selects the Checkbox  in a WebTable that matches the values from the next two cells in the same row
				'takes WebTable Object
				'tester must choose "ON" or "OFF"

				sValue1 = getFields(0, expected, "~") 'WebCheckbox Description from next column
				sValue2 = getFields(1, expected, "~") 'WebCheckbox Description from the next column following sValue1
				expected = getFields(2, expected, "~") 'checked property (ON or OFF)
				x = 1  'Row
				y = 2  'Column

				'This section handles the situation when all of the checkboxes and text are considerted to be within the same row and column of a webtable
				'Does not currently handle descriptive programming for WebTable Object 1-16-2009
				   
					If Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ColumnCount (x) = 1 Then
						y = 1
						Do
							cellValue1 = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x,y)
							cellValue2 = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x,y+1)
							If instr(1, cellValue1, sValue1) > 0 and instr(1, cellValue2, sValue2) > 0 Then
								strProp =  Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetROProperty("outerhtml")
								arrProp = split(strProp, "<BR>")
								z = 0
								Do
									If instr(arrProp(z), sValue) > 0 Then
										Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x ,1, "WebCheckBox", z).Set expected
										wait (1)
										actual = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x,1,"WebCheckBox", z).GetROProperty("checked")
										Exit Do
									 End If
									z = z + 1
								Loop until z = ubound(arrProp) + 1
							End If
							x = x + 1
						Loop until instr(cellValue1, "ERROR") = 1
					'End same row same column
						
					ElseIf Instr(desc(0), ":=") Then
						Do
							cellValue1 =Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1), desc(2)).GetCellData(x,y)
							cellValue2 = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1), desc(2)).GetCellData(x,y+1)
							If instr(1, cellValue1, sValue1) > 0 and instr(1, cellValue2, sValue2) > 0 Then
								Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1),desc(2)).ChildItem(x , 1, "WebCheckBox", 0).Set expected
								actual = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1),desc(2)).ChildItem(x , 1, "WebCheckBox", 0).GetROProperty("checked")
								Exit Do
							End If
							x = x + 1
						Loop until instr(cellValue1, "ERROR") = 1
					Else
						Do
							cellValue1 = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x, y)
							cellValue2 = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x, y+1)
							If instr(1, cellValue1, sValue1) > 0 and instr(1, cellValue2, sValue2) > 0 Then
								Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x ,1, "WebCheckBox", 0).Set expected
								actual = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x ,1, "WebCheckBox", 0).GetROProperty("checked")
								Exit Do
							End If
							x = x + 1
						Loop until instr(cellValue1, "ERROR") = 1
					End If

		Case Else

			If InStr(desc(0), ":=") Then
				Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebCheckBox(desc(0), desc(1),desc(2)).Set expected
				actual = Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebCheckBox(desc(0), desc(1),desc(2)).GetROProperty("checked")
			Else
				Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebCheckBox(desc(0)).Set expected
				actual = Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebCheckBox(desc(0)).GetROProperty("checked")
			End If	

		End Select

	Case "Frame"
			
		Select Case UCase(args)
		

			Case "SPLIT2"
				'Selects the Checkbox  in a WebTable that matches the values from the next two cells in the same row
				'takes WebTable Object
				'tester must choose "ON" or "OFF"

				sValue1 = getFields(0, expected, "~") 'WebCheckbox Description from next column
				sValue2 = getFields(1, expected, "~") 'WebCheckbox Description from the next column following sValue1
				expected = getFields(2, expected, "~") 'checked property (ON or OFF)
				x = 1  'Row
				y = 2  'Column

				'This section handles the situation when all of the checkboxes and text are considerted to be within the same row and column of a webtable
				'Does not currently handle descriptive programming for WebTable Object 1-16-2009
				   
					If Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ColumnCount (x) = 1 Then
						y = 1
						Do
							cellValue1 = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x,y)
							cellValue2 = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x,y+1)
							If instr(1, cellValue1, sValue1) > 0 and instr(1, cellValue2, sValue2) > 0 Then
								strProp =  Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetROProperty("outerhtml")
								arrProp = split(strProp, "<BR>")
								z = 0
								Do
									If instr(arrProp(z), sValue) > 0 Then
										Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x ,1, "WebCheckBox", z).Set expected
										wait (1)
										actual = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x,1,"WebCheckBox", z).GetROProperty("checked")
										Exit Do
									 End If
									z = z + 1
								Loop until z = ubound(arrProp) + 1
							End If
							x = x + 1
						Loop until instr(cellValue1, "ERROR") = 1
					'End same row same column
						
					ElseIf Instr(desc(0), ":=") Then
						Do
							cellValue1 =Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1), desc(2)).GetCellData(x,y)
							cellValue2 = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1), desc(2)).GetCellData(x,y+1)
							If instr(1, cellValue1, sValue1) > 0 and instr(1, cellValue2, sValue2) > 0 Then
								Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1),desc(2)).ChildItem(x , 1, "WebCheckBox", 0).Set expected
								actual = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1),desc(2)).ChildItem(x , 1, "WebCheckBox", 0).GetROProperty("checked")
								Exit Do
							End If
							x = x + 1
						Loop until instr(cellValue1, "ERROR") = 1
					Else
						Do
							cellValue1 = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x, y)
							cellValue2 = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x, y+1)
							If instr(1, cellValue1, sValue1) > 0 and instr(1, cellValue2, sValue2) > 0 Then
								Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x ,1, "WebCheckBox", 0).Set expected
								actual = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x ,1, "WebCheckBox", 0).GetROProperty("checked")
								Exit Do
							End If
							x = x + 1
						Loop until instr(cellValue1, "ERROR") = 1
					End If

			Case "SPLIT"

				'Selects the Checkbox  with a description in Column 2 that matches the sValue 
				'takes WebTable Object
				'tester must chose "ON" or "OFF"
				' Parse on either ? or ~

				If instr(1,expected,"?") then
					sValue = getFields(0, expected, "?")
					expected = getFields(1, expected, "?")
					If instr(1,expected, ">") Then
						y=getFields(1, expected, ">")
						expected = getFields(0, expected, ">")
				   else
						y=2
					end if
					If instr(1,y, "<") Then
						 z=cint(getFields(1, y, "<"))
					   y= cint(getFields(0, y, "<"))
					else 
					y=cint(y)
					z=1
					end if
				Else
					sValue = getFields(0, expected, "~")
					expected = getFields(1, expected, "~")
					 y = 2
					 z=1
				End If

				x = 1  'Row
			   '' y = 2  'Column

				'This section handles the situation when all of the checkboxes and text are considerted to be within the same row and column of a webtable
				'Does not currently handle descriptive programming for WebTable Object 1-16-2009
				   
					If Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ColumnCount (x) = 1 Then
						y = 1
						Do
							Allitems = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x,y)
						If instr(1, Allitems, sValue) > 0 Then
						   strProp =  Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetROProperty("outerhtml")
						   arrProp = split(strProp, "<BR>")
						   z = 0
						   Do
							   If instr(arrProp(z), sValue) > 0 Then
								   Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x ,1, "WebCheckBox", z).Set expected
								   wait (1)
								   actual = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x,1,"WebCheckBox", z).GetROProperty("checked")
								   Exit Do
							   End If
								z = z + 1
							Loop until z = ubound(arrProp) + 1
						End If
						x = x + 1
						Loop until instr(Allitems, "ERROR") = 1
					'End same row same column
						
				ElseIf Instr(desc(0), ":=") Then
					Do
						'Allitems = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1), desc(2)).GetCellData(x,y)
						Allitems = trim(Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1), desc(2)).GetCellData(x,y))
					   ' If instr (1, Allitems, sValue) > 0 Then
					   If Allitems = trim(sValue)  Then
							Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1),desc(2)).ChildItem(x , 1, "WebCheckBox", 0).Set expected
							actual = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1),desc(2)).ChildItem(x , 1, "WebCheckBox", 0).GetROProperty("checked")
							Exit Do
						End If
						x = x + 1
					Loop until instr(Allitems, "ERROR") = 1
				Else
				x = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetRowWithCellText (sValue, y, 1)
			   rowCheck = trim(Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x,y))
					If rowCheck = trim(sValue) Then  'In case the first row with the specified text is not the correct row, search again starting from row x + 1
						Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x ,z, "WebCheckBox", 0).Set expected
						actual = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x , z, "WebCheckBox", 0).GetROProperty("checked")
					Else
						w = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetRowWithCellText (sValue, y, x + 1)
						Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(w ,1, "WebCheckBox", 0).Set expected	
						actual = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(w , 1, "WebCheckBox", 0).GetROProperty("checked")
					End If
					''Do
					'Allitems = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x, y)
					''Allitems = trim(Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x,y))

						'If instr (1, Allitems, sValue) > 0 Then
						''If Allitems = trim(sValue) Then
							''Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x ,1, "WebCheckBox", 0).Set expected
							'actual = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x ,1, "WebCheckBox", 0).GetROProperty("checked")
						'Exit Do
						'End If
						''x = x + 1
					'Loop until instr(Allitems, "ERROR") = 1

					' For Data Entry: Exit script if not found
					
					If instr(Allitems, "ERROR") = 1 Then
						If instr(Environment("runControlFile"),"DataEntry") <> 0 Then
							Environment("RunComments") = "Checkbox description: "&sValue&" not found."
							Environment("RunFailures") = Environment("RunFailures") + 1
							Environment("RunTimeError") = "Yes"
							If (expected = "ON") Then
								result =  verificationPoint("1","Checkbox description: "&sValue&" not found." , logObject, logDetails, browserObj, expectedResult )
							Else
								result =  verificationPoint("0", "Checkbox description: "&sValue&" not found.", logObject, logDetails , browserObj, expectedResult)
							End If
							ExitAction
						End If
					End If
					
				End If

		Case "IFEXISTS"

			If InStr(desc(0), ":=") Then
				If Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0), desc(1),desc(2)).Exist(5) Then
					Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0), desc(1),desc(2)).Set expected
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0), desc(1),desc(2)).GetROProperty("checked")
				Else
					expected = "NO TEST"
				End If				
			Else
				If Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0)).Exist(5) Then
					Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0)).Set expected
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0)).GetROProperty("checked")
				Else
					expected = "NO TEST"
				End If				
			End If
			
		Case Else

			    If InStr(desc(0), ":=") Then
				Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0), desc(1),desc(2)).Set expected
				actual = Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0), desc(1),desc(2)).GetROProperty("checked")
			Else
				Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0)).Set expected
				actual = Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0)).GetROProperty("checked")
			End If	

		End Select
		  
	End Select


	If (expected = "ON") Then
		 result =  verificationPoint("1", actual, logObject, logDetails, browserObj, expectedResult )
	ElseIf expected = "OFF" Then
		 result =  verificationPoint("0", actual, logObject, logDetails , browserObj, expectedResult)
	End If
			
End Function


'***************************************************************
' Function: WebCheckBox_VerifyExists (stepNum, stepName, page, object, expected, args)
' Date Created: 1/25/2006
' Date Modifed: 1/25/2006
' Created By: Chris Thompson & Steve Truong
' Description:  VerifyExists keyword for the WebCheckBox type object
'***************************************************************

Function WebCheckBox_VerifyExists (stepNum, stepName, expectedResult, page, object, expected, args)

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

	Select Case ident

	Case "None"

		Select Case UCase(args)
	
			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).WebCheckBox(desc(0), desc(1), desc(2)).Exist
				Else
					actual = Browser(browserObj).Page(page).WebCheckBox(desc(0)).Exist
				End If

		End Select	

	Case "Window"

		Select Case UCase(args)

			Case Else
		
				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebCheckBox(desc(0), desc(1), desc(2)).Exist
				Else
					actual = Browser(browserObj).Window(windowobj).Page(page).Frame(frameObj).WebCheckBox(desc(0)).Exist
				End If	

		End Select

	Case "Frame"

		Select Case UCase(args)
	
			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0), desc(1), desc(2)).Exist
				Else
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0)).Exist
				End If	
   
		End Select

	End Select
		
 	result =  verificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)    
  
End Function


'***************************************************************
' Function: WebCheckBox_VerifyProperty (stepNum, stepName, page, object, expected, args)
' Date Created: 1/25/2006
' Date Modifed: 3/24/2009
' Created By: Chris Thompson & Steve Truong
' Description:  Verify property keword for the WebCheckBox type object
'***************************************************************

Function WebCheckBox_VerifyProperty (stepNum, stepName, expectedResult, page, object, expected, args)

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
	
	'Perform action and validation

	Select Case ident

	Case "None"

		Select Case UCase(args)

			Case "CONVERT"  'Converts database to a numerical description  - to be used with the checked property

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).WebCheckBox(desc(0), desc(1),desc(2)).GetROProperty(prop)
					If expected = "-1" Then
						expected = "1"
					End If
					If expected = "Y" Then 
						expected = "1"
					End If
					If expected = "N" Then
						expected = "0"
					End If
				Else
					actual = Browser(browserObj).Page(page).WebCheckBox(desc(0)).GetROProperty(prop)
					If expected = "-1"Then
						expected = "1"
					End If
					If expected = "Y" Then 
						expected = "1"
					End If
					If expected = "N" Then
						expected = "0"
					End If
				End if
   
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult)

			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).WebCheckBox(desc(0), desc(1),desc(2)).GetROProperty(prop)
				Else
					actual = Browser(browserObj).Page(page).WebCheckBox(desc(0)).GetROProperty(prop)
				end if
 
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult)

			End Select

	Case "Window"

		Select Case UCase(args)

			Case "SPLIT"

					'Verifies Properties  for checkbox with a description in a Column  that matches the sValue 
					'takes WebTable Object
					'tester must chose "ON" or "OFF"
					
					sValue = getFields(0, expected, "~") 'WebCheckbox Description
					sProperty= getFields(1, expected, "~") 'checked property (ON or OFF)
					Expected=	getFields(2, expected, "~") 
					x = 1  
					y = 2  

				   'This section handles the situation when all of the checkboxes and text are considerted to be within the same row and column of a webtable
				   'does not currently handle descriptive programming for WebTable Object 1-16-2009
				   Dim cCount
					If Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).ColumnCount (x) = 1 Then
						y = 1
						Do
							Allitems = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x,y)
						If instr(1, Allitems, sValue) > 0 Then
						   strProp =  Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetROProperty("outerhtml")
						   arrProp = split(strProp, "<BR>")
						   z = 0
						   Do
							   If instr(arrProp(z), sValue) > 0 Then
								   wait (1)
								   actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x,1,"WebCheckBox", z).GetROProperty(sProperty)
								   Exit Do
							   End If
								z = z + 1
							Loop until z = ubound(arrProp)
						End If
						x = x + 1
						Loop until instr(Allitems, "ERROR") = 1
					'end same row same column
					
					ElseIf Instr(desc(0), ":=") Then
					Do
						Allitems = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1), desc(2)).GetCellData(x,y)

						If instr (1, Allitems, sValue) > 0 Then
							actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1), desc(2)).ChildItem(x , 1, "WebCheckBox", 0).GetROProperty(sProperty)
							Exit Do
						End If
						x = x + 1
					Loop until instr(Allitems, "ERROR") = 1
					
					Else
				
					Do
						Allitems = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x,y)

						If instr (1, Allitems, sValue) > 0 Then
							actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x , 1, "WebCheckBox", 0).GetROProperty(sProperty)
							Exit Do
						End If
						x = x + 1
					Loop until instr(Allitems, "ERROR") = 1

				End If

				logDetails = logDetails & " Actual: " &actual  
				result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult)	

			Case Else

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebCheckBox(desc(0), desc(1),desc(2)).GetROProperty(prop)
				Else
					actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebCheckBox(desc(0)).GetROProperty(prop)
				End If	 	  
		
				logDetails = logDetails & " Actual: " &actual  
				result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult)

		End Select		

	Case "Frame"

		Select Case UCase(args)

			Case "CONVERT"

				If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0), desc(1),desc(2)).GetROProperty(prop)
					If expected = -1 Then
						expected = 1
					End If
					If expected = "Y"  Then
						expected = 1
					End If
					If expected = "N"  Then
						expected = 0
					End If
				Else
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0)).GetROProperty(prop)

					'Case when developers did the opposite of what they should be doing
					If expected = "neg0" then
						expected = 1
					End If
					If expected = "neg-1" then
						expected = 0
					End If  	
					If expected = "-1" Then
						expected = "1"
					End If 	  
					If expected = "Y" Then 
						expected = "1"
					End If
					If expected = "N" Then
						expected = "0"
					End If
				End If

				   logDetails = logDetails & " Actual: " &actual  
				   result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult)

			Case Else

				 If InStr(desc(0), ":=") Then
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0), desc(1),desc(2)).GetROProperty(prop)
				Else
					actual = Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0)).GetROProperty(prop)
				End If	 	  

				logDetails = logDetails & " Actual: " &actual  
				result = verificationPointInstr(expected, actual, logObject, logDetails, browserObj, expectedResult)

			End Select

	 End Select

End Function
