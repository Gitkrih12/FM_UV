 
'***************************************************************
'File Name: UtilityFunctions.vbs
'Date Ceated: 7/20/2008
'Created By: Chris Thompson & Steve Truong & Jason Craig
'Description: Library contains all keyword functions created specifically for QNXT
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
' Function: ProviderUtility_VerifySearch(stepNum, stepName, page, object, expected, args)
' Date Created: 7/20/2008
' Date Modifed: 11/20/2008
' Created By: Chris Thompson
' Description:  Verifies the correct results exist in a WebTable
'***************************************************************

Function ProviderUtility_VerifySearch (stepNum, stepName, expectedResult, page, object, expected, args)

	browserObj = getFields(0,page , "-")
	windowObj = getfieldsUpperNull(3,page , "-")
	frameObj=getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")
	prop=getFields(0, expected, ":=")
	fielded=getFields(1, expected, ":=")
	fielded = replaceConstants(fielded)

	Select Case Prop

		Case "Provider", "Code ID", "Code", "Contract Program"
			y = 1
		Case "Full Name","Description", "Attribute Description","Policy ID", "School Name"
			y = 2
		Case "Title", "Carrier"
			y=3
		Case "Credential Status", "Attribute Effective Date","Effective Date"
			y = 4
		Case "Expiration Date"	
			y=5
		Case "Per Claim Amount"
			y=6
		Case "Provider ID"
			y=1
		Case "Zip Code"
			y=8
		Case "State", "Coverage Limit"
			y=7
		Case else
			y = cint(prop)
		
	End Select

	If Browser("Provider Module").Dialog("Dialog").Exist(2)  Then
		Browser("Provider Module").Dialog("Dialog").winbutton("OK").Click
	End If

	logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	logDetails= "Expected: " &expected &CHR(13)

	If windowObj <> "" Then

		expected = environment("SQLResults")
		sFail ="False"
		x=1
		z=1
		pagenum = 2
		
		Do 

			sValue = trim(Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).webtable(object).GetCellData(x,y))
			If instr(sValue, "ERROR") and x > 100 Then																																														''This block of code
				 If  Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).Link("text:=" &pagenum,"html tag:=A"). exist  Then						''takes the place of the 
						Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).Link("text:=" &pagenum,"html tag:=A").Click									''x mod 100 = 0
						pagenum = pagenum +1																																																								''section of code
						x=1																																																																																							''located below
						sValue = trim(Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).webtable(object).GetCellData(x,y))
					End If
			End If
			If expected = "BLANK" Then
				If sValue <> "" Then
					sFail = "True"
				End If	   	
			Else
				current = replacesqlreference("SQL."&fielded&"["&z&"]")                  ''adjustment for data entry scripts (3/25/2009)
				If instr(current, "SURGERY, ORAL & MAXILLOFACIAL") <> 0 and instr(svalue, "SURGERY, ORAL & MAXILLOFACIAL") <>0 Then
					current = replace(current, "  ", " ")
				End If
				If instr(current, "DURABLE") Then
					current = replace(current, "  "," ")
				End If
				If current <> sValue AND instr(svalue, "ERROR") = 0 Then
					sFail = "True"
					logDetails = "Expected: " + current + " Actual: " + sValue
					Exit Do
				End If
				''If x mod 100 = 0 Then
					''If  Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).Link("text:=" &pagenum,"html tag:=A"). exist  Then
						''Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).Link("text:=" &pagenum,"html tag:=A").Click
						''pagenum = pagenum +1
						''x=0
					''End If	
				''End If	
			End If
			x = x + 1
			z=z + 1
			
		loop until instr(svalue, "ERROR") = 1
		result = verificationPoint("False", sFail, logObject, logDetails, browserObj, expectedResult)	

	Else
   
		expected = environment("SQLResults")
		sFail ="False"
		x=1
		z=1
		pagenum = 2
		Do 
			sValue = trim(Browser(browserObj).Page(page).Frame(frameObj).webtable(object).GetCellData(x,y))
			 If instr(sValue, "ERROR") and x > 100 Then																																														''This block of code
				 If  Browser(browserObj).Page(page).Frame(frameObj).Link("text:=" &pagenum,"html tag:=A"). exist  Then						 									'takes the place of the 
					  Browser(browserObj).Page(page).Frame(frameObj).Link("text:=" &pagenum,"html tag:=A").Click																			'x mod 100 = 0
					  pagenum = pagenum +1																																																								''section of code
					  x=1																																																																																							''located below
					  sValue = trim(Browser(browserObj).Page(page).Frame(frameObj).webtable(object).GetCellData(x,y))
					End If
			End If  
			If expected = "BLANK" Then
				If sValue <> "" Then
					sFail = "True"
				End If
			Else
				current = replacesqlreference("SQL."&fielded&"["&z&"]") '  CHANGE 3/24/2009 to adjust for data entry
				If instr(current, "SURGERY, ORAL & MAXILLOFACIAL") <> 0 and instr(svalue, "SURGERY, ORAL & MAXILLOFACIAL") <>0 Then
					current = replace(current, "  ", " ")
				End If
				If instr(current, "DURABLE") Then
					current = replace(current, "  "," ")
				End If
				If current <> sValue AND instr(svalue, "ERROR") = 0 Then
					sFail = "True"
					logDetails = "Expected: " + current + " Actual: " + sValue
					Exit Do
				End If
				''If x mod 100 = 0 Then
					''If  Browser(browserObj).Page(page).Frame(frameObj).Link("text:=" &pagenum,"html tag:=A"). exist  Then
						''Browser(browserObj).Page(page).Frame(frameObj).Link("text:=" &pagenum,"html tag:=A").Click
						''pagenum = pagenum +1
						''x=0
					''End If	
				''End If
			End If
			x = x + 1
			z=z + 1
		loop until instr(svalue, "ERROR") = 1
		result = verificationPoint("False", sFail, logObject, logDetails, browserObj, expectedResult)	
	End If

End Function


'***************************************************************
' Function: ProviderUtility_TypeText(stepNum, stepName, page, object, expected, args)
' Date Created: 10/27/2006
' Date Modifed: 10/21/2008
' Created By: Chris Thompson
' Description:  Types text into whichever field the cursor is in
'***************************************************************

Function ProviderUtility_TypeText (stepNum, stepName, expectedResult, page, object, expected, args)

   Dim prop, logObject, logDetails
prop=getFields(0, expected, ":=")
expected=getFields(1, expected, ":=")
expected = replaceConstants(expected)

' Convert Datestamp

	If expected = "Environment('Datestamp')" Then
		expected = environment("Datestamp")
	Elseif instr (expected,"Environment('Datestamp')<") Then
		expected = getfields(2,expected,"<")
		expected = mid(expected,1,len(expected)-1)
		Call Utility_GenDatestamp(stepNum, stepName, expectedResult, page, object, expected, "Run Time")  
		expected = environment("Datestamp")
	End If
	If expected = "Environment('Timestamp')" Then
		Call Utility_GenTimestamp(stepNum, stepName, expectedResult, page, object, expected, "Run Time")
		expected = Environment("Timestamp")
	End If
	

Call typekeys (expected)

	logObject = "Step: " &stepNum &"  -  "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
     logDetails= "Expected:  " &expected &CHR(13)	  
	 logDetails = logDetails & " Actual: True"
	 
result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)


End Function


'***************************************************************
' Function: ProviderUtility_VerifySort(stepNum, stepName, page, object, expected, args)
' Date Created: 9/23/2008
' Date Modifed: 9/23/2008
' Created By: Chris Thompson
' Description:  Verifies that a Table is sorted correctly by alpha, numeric, monetary, and date
'***************************************************************

Function ProviderUtility_VerifySort (stepNum, stepName, expectedResult, page, object, expected, args)

prop=getFields(0, expected, ":=")
fielded=getFields(1, expected, ":=")
fielded = replaceConstants(fielded)

 browserObj = getFields(0,page , "-")
	windowObj = getFields(3,page , "-")
	 frameObj=getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")

If Browser(browserObj).Dialog("Dialog").Exist(2)  Then
	Browser(browserObj).Dialog("Dialog").winbutton("OK").Click
End If

Select Case prop
	Case "Full Name","Advanced Status",  "Assigned Attribute Name", "Contract Program", "Attribute Group", "Individual Attribute Name", "Plan Program", "Affiliate Name", "Plan Relationship", "Policy Number","Licensing Board", "Plan Rel Active", "Assigned Specialties Specialty", "Specialties Description", "Primary Specialty Code", "Contracts Contract","Certification", "Certifying Board","License Number"
		y = 2
	Case "Address", "Advanced City", "Assigned Termination Date", "Individual Termination Date", "Expiration Date", "Memo User", "Plan Rel Effective Date", "Assigned Specialties Status", "Contracts Effective Date", "Certification Column"
		y = 5
	Case "City", "Advanced State", "Per Claim Amount", "Memo Created", "Plan Rel Termination Date", "Assigned Specialties Effective Date", "Contracts Termination Date", "Certification Year"
		y = 6

	Case "Credential Status", "Advanced Address", "Assigned Effective Date",  "Contract Termination Date", "Individual Effective Date", "Plan Termination Date", "Affiliate Address", "Effective Date", "Alert Type", "Plan Rel Provider ID", "Assigned Specialties Type", "Contracts Contracted By", "Certification Expiration Date"
		y = 4

	Case "Provider ID", "Advanced Name", "Contract Program", "Plan Rel Health Plan", "Contracts Program"
		y=1

	Case "Zip Code", "Advanced Federal ID", "Memo Source", "Plan Rel New Members"
		y=8

	Case "State", "Advanced Zip Code", "Memo Last Edit", "Plan Rel PCP", "Assigned Specialties Termination Date", "Recertification Year"
		y=7

	Case "Phone", "Plan Rel Max Number"
		y=11

	Case "NPI", "Advanced Phone", "Plan Rel Min Number"
		y=10

	Case "Federal ID", "Advanced NPI", "Plan Rel Max Members"
		y=9

	Case "Status", "Advanced Credential Status", "Assigned Attribute Value", "Contract Effective Date", "Individual Attribute Value", "Plan Effective Date", "Affiliate Type", "Carrier", "Memo Type", "License Number", "Plan Rel Program", "Assigned Specialties Description", "Primary Specialty Description", "Contracts Participation","Level Number", "Certification Effective Date"
		y=3

	Case "ProviderID"
		y=1

	Case "Plan Rel EPSDT"
		y = 12
		
	Case "Plan Rel Assign Delegation"
		y = 13

	Case Else

		y = cint(prop)

End Select

logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
logDetails= "Expected: " &expected &CHR(13)

	sFail ="False"

	 If y = ""  Then
		 sfail = "True"
	End If
	
	x=1
	pagenum = 2
	sValue = Browser(browserObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,y)
     sValue = replace(svalue,"Í","I")
	sValue = replace (svalue,"Ñ","N")
	sValue = replace(svalue,"Ó","O")
	
	If instr(sValue, "SURGERY, ORAL & MAXILLOFACIAL") Then         'handles one unique data entry
		sValue = sValue2
	End If

	 If sValue = " " then
		sValue = ""
	End If

Set objRegEx = CreateObject("VBScript.RegExp") 'checks for String
objRegEx.Global = True
objRegEx.Pattern = "[A-Z]+|[a-z]+|(-)"

Set ColMatches = objRegEx.Execute(sValue)

If ColMatches.Count > 0 Then
	svalue=ucase(svalue)
	sValue = sValue
End If

If ColMatches.Count < 1 Then
	Set objRegEx = CreateObject("VBScript.RegExp") 'checks for Dates
	objRegEx.Global = True
	objRegEx.Pattern = "\d+/\d+/\d+"

	Set ColMatches = objRegEx.Execute(sValue)

	If ColMatches.Count > 0 Then
		sValue = CDate(sValue)
	End If
End If

If ColMatches.Count < 1 Then     'check for money
	Set objRegEx = CreateObject("VBScript.RegExp") 
	objRegEx.Global = True
	objRegEx.Pattern = "[$].*"

	Set ColMatches = objRegEx.Execute(sValue)

	If ColMatches.Count > 0 Then
	 sValue = Mid(svalue,2)
	 sValue = replace(svalue,",","")
	sValue = Cdbl(sValue)
	End If
End If 

If ColMatches.Count < 1 Then     'checks for Numbers of 9 digits or more and converts them to Strings (this compensates or the fact that NPI and Federal ID only use the first 9 digits for sorting)
 Set objRegEx = CreateObject("VBScript.RegExp")                                    
	objRegEx.Global = True																						    
	objRegEx.Pattern = "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]"				

	Set ColMatches = objRegEx.Execute(sValue)											  
																																		 
	If ColMatches.Count > 0 Then
	sValue = cstr(sValue)                        
	End If
End If

If ColMatches.Count < 1 Then      'check for numbers
	Set obRegEx = CreateObject("VBscript.RegExp")
	objRegEx.Global = True
	objRegEx.Pattern = "[0-9]+" 
	
	Set ColMatches = objRegEx.Execute(sValue)

	If ColMatches.Count > 0 Then
		sValue = Clng(sValue)
	End If
End If

If ColMatches.Count < 1 Then
	sValue = null                     'if it's not a string, not a date, and not a currency...it's null (blank values)
End If

	Do 
	x = x + 1
	sValue2 = Browser(browserObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,y)

	sValue2 = replace(svalue2,"Í","I")
	sValue2 = replace (svalue2,"Ñ","N")
	sValue2 = replace(svalue2,"Ó","O")

	 If instr(sValue2, "SURGERY, ORAL & MAXILLOFACIAL") Then         'handles one unique data entry
		sValue2 = sValue
	End If

	If sValue2 = " " then
		sValue2 = ""
	End If
	
   	If instr(sValue2, "ERROR") = 1 Then
		Exit Do
	End If 

Set objRegEx = CreateObject("VBScript.RegExp") 'checks for String
objRegEx.Global = True
objRegEx.Pattern = "[A-Z]+|[a-z]+|(-)"

Set ColMatches = objRegEx.Execute(sValue2)

If sValue <> "" Then
	If sValue = cstr(sValue) Then 'This code allows for a number to be considered a string if the sValue has already been declared a string
		Set ColMatches = objRegEx.Execute("abcd")
	End If
End If

If ColMatches.Count > 0 Then
	sValue2=ucase(sValue2)
	sValue2 = sValue2
End If

If ColMatches.Count < 1 Then	'checks for Dates
	Set objRegEx = CreateObject("VBScript.RegExp") 
	objRegEx.Global = True
	objRegEx.Pattern = "\d+/\d+/\d+"

	Set ColMatches = objRegEx.Execute(sValue2)

	If ColMatches.Count > 0 Then
		sValue2 = CDate(sValue2)
	End If
End If

If ColMatches.Count < 1 Then     'check for money
	Set objRegEx = CreateObject("VBScript.RegExp") 
	objRegEx.Global = True
	objRegEx.Pattern = "[$].*"

	Set ColMatches = objRegEx.Execute(sValue2)

	If ColMatches.Count > 0 Then
	 sValue2 = Mid(svalue2,2)
	 sValue2 = replace(svalue2,",","")
	sValue2 = Cdbl(sValue2)
	End If
End If 


If ColMatches.Count < 1 Then
	Set objRegEx = CreateObject("VBScript.RegExp") ''checks for Numbers of 9 digits or more and converts them to Strings (this compensates or the fact that NPI and Federal ID only use the first 9 digits for sorting)                 
	objRegEx.Global = True
	objRegEx.Pattern = "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]"

	Set ColMatches = objRegEx.Execute(sValue2)

	If ColMatches.Count > 0 Then
		sValue2 = Cstr(sValue2)    
	End If
End If

If ColMatches.Count < 1 Then
	Set objRegEx = CreateObject("VBScript.RegExp") 'check for numbers
	objRegEx.Global = True
	objRegEx.Pattern = "[0-9]+"

	Set ColMatches = objRegEx.Execute(sValue2)

	If ColMatches.Count > 0  Then
		sValue2 = cLng(sValue2)
	End If

	If sValue2 = "" Then
		Set ColMatches = objRegEx.Execute("1234")
		sValue2 = null   'Allows for a blank space to be considered an integer if interger type has already been established by sValue
	End If
End If

If ColMatches.Count < 1 Then
	sValue2 = ucase(sValue2)                   'If it's not a string, not a date, and not a currency...it's a string (eliminates issues with number sorting)
End If

	If fielded = "Descending" Then
    		If (sValue) < (sValue2) AND instr(sValue2,"ERROR") = 0 Then
 				sFail = "True"
  		       ' msgbox "fail"
			End If
		
	Elseif fielded = "Ascending" then
			If (sValue) > (sValue2) AND instr(sValue2,"ERROR") = 0 Then
				sFail = "True"
				' msgbox "fail"
			End If
	End If


	If x mod 100 = 0 Then
		If  Browser(browserObj).Page(page).Frame(frameobj).Link("text:=" &pagenum,"html tag:=A").Exist Then
		Browser(browserObj).Page(page).Frame(frameobj).Link("text:=" &pagenum,"html tag:=A").Click
		pagenum = pagenum +1
		x=1
		End If
	End If
	sValue = sValue2
	loop until instr(svalue, "ERROR") = 1
	result = verificationPoint("False", sFail, logObject, logDetails, browserObj, expectedResult)	



End Function

'***************************************************************
' Function: ProviderUtility_SelectRadio(stepNum, stepName, page, object, expected, args)
' Date Created: 9/26/2008
' Date Modifed: 9/26/2008
' Created By: Chris Thompson
' Description:  Selects a radio button inside a table
'***************************************************************
Function ProviderUtility_SelectRadioGroup (stepNum, stepName, expectedResult, page, object, expected, args)

 Dim logObject, logDetails
 browserObj = getFields(0,page , "-")
	 windowObj = getfieldsUpperNull(3,page , "-")
	 frameObj=getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")

prop=getFields(0, expected, ":=")
expected=getFields(1, expected, ":=")
expected = replaceConstants(expected)

object2 = getFields(1, object, "~")
object = getFields(0, object, "~")

Select Case UCase(args)

	Case "SPLIT"
	'Selects the radio button with an index that matches the WebTable Description Index - used when radio buttons act as a group within a WebTable

		If windowObj <> "" Then

				 Allitems =Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebRadioGroup(object2).GetROProperty("all items")

				arrAllitems = Split(Allitems, ";")
				
				Do
					x = x + 1
					If Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).webtable(object).Exist(10) Then
						sValue = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,2)
					Else
						sValue = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).wbfgrid(object).GetCellData(x,2)
					End If

						If instr(1, expected, "SQL") Then
							expected = Environment("SQLResults")
						End If

					   ' Convert Datestamp

						If expected = "Environment('Datestamp')" Then
							expected = environment("Datestamp")
						Elseif instr (expected,"Environment('Datestamp')<") Then
							expected = getfields(2,expected,"<")
							expected = mid(expected,1,len(expected)-1)
							Call Utility_GenDatestamp(stepNum, stepName,expectedResult, page, object, expected, "Run Time")  
							expected = environment("Datestamp")
						Elseif expected = "Environment('Timestamp')" Then
							expected = Environment("Timestamp")
						ElseIf expected = "TestVariable" Then
							expected = Environment("TestVariable")
						End If

							If instr(1, sValue, expected) Then
								Exit Do
							End If
						
				Loop until instr(sValue, "ERROR") = 1

				If object2 = "Exception" Then
					Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebRadioGroup(object2).Select arrAllitems(x - 2)	
				Else
					Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebRadioGroup(object2).Select arrAllitems(x - 1)
				'actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebRadioGroup(object2).GetROProperty("value")
				End If

		Else
	
				Allitems = Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(object2).GetROProperty("all items")

				arrAllitems = Split(Allitems, ";")
				
				Do
					x = x + 1
					If Browser(browserObj).Page(page).Frame(frameobj).webtable(object).Exist(10) Then
						sValue = Browser(browserObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,2)
						rdValue = Browser(browserObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,1)
					ElseIf Browser(browserObj).Page(page).Frame(frameobj).wbfgrid(object).Exist(10) Then
						If object = "CCBilling" Then
							x= x+1
							y = 1
							z = y
						Else
							y = 2
							z = 1
						End If
'						sValue = arrAllitems(0)
						sValue = arrAllitems(x)
'						rdValue = Browser(browserObj).Page(page).Frame(frameobj).wbfgrid(object).GetCellData(x,z)
						rdValue = Browser(browserObj).Page(page).Frame(frameobj).wbfgrid(object).GetCellData(x,y)
						
					End If
					
						If expected = "Environment('Datestamp')" Then
							expected = environment("Datestamp")
						Elseif instr (expected,"Environment('Datestamp')<") Then
							expected = getfields(2,expected,"<")
							expected = mid(expected,1,len(expected)-1)
							Call Utility_GenDatestamp(stepNum, stepName,expectedResult, page, object, expected, "Run Time")  
							expected = environment("Datestamp")
						Elseif expected = "Environment('Timestamp')" Then
							expected = Environment("Timestamp")
						ElseIf expected = "TestVariable" Then
							expected = Environment("TestVariable")
						End If

						If instr(1, expected, "SQL") Then
							expected = Environment("SQLResults")
						End If

					   '  If Environment("RunTest") =  "z_Initialize07_CreateProviders" Then
						'	If trim(sValue) = trim(expected) Then
						'		Exit Do
						'	End If
					   'Else
						If instr(1, sValue, expected) Then
							Exit Do
					    End If
						If instr(1, rdValue, expected) Then
							Exit Do
					    End If
					'	End If
						
'					If trim(sValue) = expected Then
'							Exit Do
'						End If
				Loop until instr(sValue, "ERROR") = 1

				If instr(sValue, "ERROR") = 1 Then
					If object2 = "Contract" Then
						Environment("RunComments") = "Contract "&expected&" not found"
						Environment("RunFailures") = Environment("RunFailures") + 1
						Environment("RunTimeError") = "No"
						ExitAction
					Else
						Environment("RunComments") = "Radio button description: "&expected&" not found"
						Environment("RunFailures") = Environment("RunFailures") + 1
						Environment("RunTimeError") = "No"
						ExitAction
					End If
				End If
				
				If arrAllitems(UBound(arrAllitems)) = "on" or Len(arrAllitems(x-1))>150 Then
					Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(object2).Select "#"&x-1
'				ElseIf Browser(browserObj).Page(page).Frame(frameobj).wbfgrid(object2).Exist(10) Then
'					Browser(browserObj).Page(page).Frame(frameobj).wbfgrid(object2).SetCellData x,1,sValue
				Else
'					Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(object2).Select arrAllitems(UBound(arrAllitems))
					Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(object2).Select arrAllitems(x-1)
				End If
					
				
		End If

	   Case "DOUBLE WINDOW"

				Allitems = Browser(browserObj).Window(windowObj).Window(windowObj).Page(page).Frame(frameObj).WebRadioGroup(object2).GetROProperty("all items")

				arrAllitems = Split(Allitems, ";")
				
				Do
					x = x + 1
					sValue = Browser(browserObj).Window(windowObj).Window(windowObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,2)

						If instr(1, expected, "SQL") Then
							expected = Environment("SQLResults")
						End If

					   ' Convert Datestamp

						If expected = "Environment('Datestamp')" Then
							expected = environment("Datestamp")
						Elseif instr (expected,"Environment('Datestamp')<") Then
							expected = getfields(2,expected,"<")
							expected = mid(expected,1,len(expected)-1)
							Call Utility_GenDatestamp(stepNum, stepName, expectedResult, page, object, expected, "Run Time")  
							expected = environment("Datestamp")
						Elseif expected = "Environment('Timestamp')" Then
							expected = Environment("Timestamp")
						End If

						If instr(1, sValue, expected) Then
							Exit Do
						End If
				Loop until instr(sValue, "ERROR") = 1

		If object2 = "Restriction" Then 'handles a specific webtable issue
					Browser(browserObj).Window(windowObj).Window(windowObj).Page(page).Frame(frameObj).WebRadioGroup(object2).Select arrAllitems(x - 2)
		Else
					Browser(browserObj).Window(windowObj).Window(windowObj).Page(page).Frame(frameObj).WebRadioGroup(object2).Select arrAllitems(x - 1)
		End If
				 
	Case "IFEXISTS"	' For Data Entry use ONLY
		If Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).Exist Then
			Allitems = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebRadioGroup(object2).GetROProperty("all items")
			arrAllitems = Split(Allitems, ";")
			Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebRadioGroup(object).Select arrAllitems(0)
		End If

	Case "SPLIT2"	
		  Do 
		x = x + 1
		sValue = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,5)

		If  (svalue) = expected Then
			Exit do
		End If
	
	
		loop until instr(svalue, "ERROR") = 1

   Set  result = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).WebTable(object).ChildItem(x,1,"WebRadioGroup", 0)
	   result.Click


	
	Case Else  'used when radio buttons act individual within a WebTable
   
	If windowObj <> "" Then
		colNames = Split(Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).WebTable("Select").GetROProperty("text")," ")
		For cn = 0 To UBound(colNames) Step 1
			If colNames(cn) = "Description" Then
				y = cn + 1
				Exit For
			End If
		Next
		Do
		x = x + 1
		If windowObj = "Reason" Then
			sValue = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).WbfGrid(object).GetCellData(x,y)
		Else
			sValue = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,2)
		End If
		


		If trim(svalue) = expected Then
			Exit do
		End If
	
	
		loop until instr(svalue, "ERROR") = 1

		object2=replace(object2,"##",cstr(x+1))
		
		
		If windowObj = "Reason" Then
			result = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).WebRadioGroup(object2).click
		Else
			result = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).WebRadioGroup("name:=" & object2,"html tag:=INPUT").click
		End If
		
	Else
		y =0
		If object = "Affiliates" Then
			header = Split(Browser(browserObj).Page(page).Frame(frameobj).webtable("Select Affiliate").GetROProperty("column names"), ";")
			testColumn = "Type"
		ElseIf object = "Contract Info" Then
			header = Split(Browser(browserObj).Page(page).Frame(frameobj).webtable("Select Contract").GetROProperty("column names"), ";")
			testColumn = "Program"
		Else
			header = Split(Browser(browserObj).Page(page).Frame(frameobj).webtable(object).GetROProperty("column names"), ";")
			y=2
		End If
		
		For h = 0 To UBound(header) Step 1
			If header(h) = testColumn Then
				y = h
				Exit For
			End If
		Next
		Do 
		x = x + 1
		
		If header(y) = "Type" Then
			sValue = Browser(browserObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,y)
		ElseIf header(y) = "Program" Then
			sValue = Browser(browserObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,y+1)
		Else
			sValue = Browser(browserObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,2)
		End If
		
		If trim(svalue) = expected Then
			Exit do
		End If
	
	
		loop until instr(svalue, "ERROR") = 1


		If object = "Affiliates" Then
			object2=replace(object2,"##",cstr(x+2))
		Else
			object2=replace(object2,"##",cstr(x+1))
		End if

		If instr(svalue, "ERROR") Then
            Environment("RunComments") = object2&" not found.  Expected: "&expected
		End If

		result = Browser(browserObj).Page(page).Frame(frameobj).WebRadioGroup("name:=" & object2,"html tag:=INPUT").click
		
	End IF
	
	End Select
	
	logObject = "Step: " &stepNum &"  -  "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	logDetails= "Expected:  " &expected &CHR(13)	  
	logDetails = logDetails & " Actual: True"
	result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)

'Browser("Provider Module").Page("Provider Module").Frame("NewProvider3").WebRadioGroup("dgSelectTitle:_ctl8:rdoSelect").Select "0~56   
   End Function


'***************************************************************
' Function: ProviderUtility_VerifyTableRow(stepNum, stepName, page, object, expected, args)
' Date Created: 9/26/2008
' Date Modifed: 9/26/2008
' Created By: Chris Thompson
' Description:  Verifies a row in a table
'***************************************************************

Function ProviderUtility_VerifyTableRow_Old (stepNum, stepName, expectedResult, page, object, expected, args)

	browserObj = getFields(0,page , "-")
	windowObj = getFieldsUpperNull(3,page, "-")
	frameObj=getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")

'Parse Object Description

   
	expected = replaceSQLReference(expected)   'This was entered to handle multiple instances of SQL calls within a VerifyTableRow (probably can expand to loop and replace all SQL calls or simply add this line again to verify 3 SQL calls etc.)  Jason - 3/30/2009
	expected = replaceSQLReference(expected)
	expected = replaceSQLReference(expected)
	expected = replaceSQLReference(expected)
	expected = replaceSQLReference(expected)
	
	Select Case UCase(args)

	Case "WINDOW"    'verifies a row in a table that is located within a Window

	If Instr(object, ":=") Then

		Dim desc(2)
	
		desc(0) = getFields(0, object, "~")
		desc(1) = getFields(1, object, "~")
		desc(2) = getFields(2, object, "~")

		sFail = True

	 ExpectArray = Split(expected, "~")

		Do 
		x = x + 1

		For y = 1 to (ubound(ExpectArray) +1)

		sValue = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).webtable(desc(0), desc(1), desc(2)).GetCellData(x,y)
		
		If instr(sValue, "ERROR") = 1 Then
			sFail = True
		   Exit Do
		End If
		
		'Verify Datestamps
 If trim(ExpectArray(y-1)) = "Environment('Datestamp')" Then
		ExpectArray(y-1) = environment("Datestamp")
	Elseif instr (ExpectArray(y-1),"Environment('Datestamp')<") Then
		ExpectArray(y-1) = getfields(2,ExpectArray(y-1),"<")
		   ExpectArray(y-1)  = mid(ExpectArray(y-1) ,1,len(ExpectArray(y-1) )-1)
		Call Utility_GenDatestamp(stepNum, stepName, expectedResult, page, object,ExpectArray(y-1), "Run Time")  
		ExpectArray(y-1) = environment("Datestamp")
End If

		
		'Verify SQL
		If instr(1, ExpectArray(y-1), "SQL") Then
			ExpectArray(y-1) = Environment("SQLResults")
		End If

		'Verify Timestamp
		If trim(ExpectArray(y-1)) = "Environment('Timestamp')" Then
			ExpectArray(y-1) = Environment("Timestamp")
		End If
		
		If trim(sValue) <> trim(ExpectArray(y-1)) Then
		   sFail = True
		   Exit For
		Else sFail = False
		End If

	   If y = (ubound(ExpectArray)+1) AND sFail = False Then
			Exit Do
		End If

		If y = (ubound(ExpectArray)+1) Then
			Exit For
		End If
				
		next

		loop
		
	Else
	
		sFail = True

		ExpectArray = Split(expected, "~")

		Do 
		x = x + 1

		For y = 1 to (ubound(ExpectArray) +1)


		sValue = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,y)

		If instr(sValue, "ERROR") Then
			sFail = True
			Exit Do
		End If


		
'		'Verify Datestamps
	If trim(ExpectArray(y-1)) = "Environment('Datestamp')" Then
		ExpectArray(y-1) = environment("Datestamp")
	Elseif instr (ExpectArray(y-1),"Environment('Datestamp')<") Then
		ExpectArray(y-1) = getfields(1,ExpectArray(y-1),"<")
		   ExpectArray(y-1)  = mid(ExpectArray(y-1) ,1,len(ExpectArray(y-1) )-1)
		Call Utility_GenDatestamp(stepNum, stepName, expectedResult, page, object,ExpectArray(y-1), "Run Time")  
		ExpectArray(y-1) = environment("Datestamp")
	End If

		'Verify Timestamp
		If trim(ExpectArray(y-1)) = "Environment('Timestamp')" Then
			ExpectArray(y-1) = Environment("Timestamp")
		End If
		
		'Verify SQL
		If instr(1, ExpectArray(y-1), "SQL") Then
			ExpectArray(y-1) = Environment("SQLResults")
		End If
		
		If trim(sValue) <> trim(ExpectArray(y-1)) Then
			sFail = True
			Exit For
		Else sFail = False
		End If

		If y = (ubound(ExpectArray)+1) AND sFail = False Then
			Exit Do
		End If

		 If y = (ubound(ExpectArray)+1) Then
			Exit For
		End If
				
		next
		
		loop

	End If
	
	Case "INSTRING"  'verifies that a portion of each column in a row is correct - use when datestamp + timestamp exist

		If Instr(object, ":=") Then

			Dim descr(2)
	
			descr(0) = getFields(0, object, "~")
			descr(1) = getFields(1, object, "~")
			descr(2) = getFields(2, object, "~")

			sFail = True
			
			ExpectArray = Split(expected, "~")

			Do 
			x = x + 1

			For y = 1 to (ubound(ExpectArray) +1)

			If windowObj <> "" Then
			sValue = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).webtable(descr(0), descr(1), descr(2)).GetCellData(x,y)
			Else
			sValue = Browser(browserObj).Page(page).Frame(frameobj).webtable(descr(0), descr(1), descr(2)).GetCellData(x,y)
			End If

			If instr(sValue, "ERROR") = 1 Then
				sFail = True
				Exit Do
			End If

			If trim(ExpectArray(y-1)) = "Environment('Datestamp')" Then
				ExpectArray(y-1) = environment("Datestamp")
			Elseif instr (ExpectArray(y-1),"Environment('Datestamp')<") Then
				ExpectArray(y-1) = getfields(2,ExpectArray(y-1),"<")
				ExpectArray(y-1)  = mid(ExpectArray(y-1) ,1,len(ExpectArray(y-1) )-1)
				Call Utility_GenDatestamp(stepNum, stepName, expectedResult, page, object,ExpectArray(y-1), "Run Time")  
				ExpectArray(y-1) = environment("Datestamp")
			End If

			'Verify Timestamp
			If trim(ExpectArray(y-1)) = "Environment('Timestamp')" Then
				ExpectArray(y-1) = Environment("Timestamp")
			End If
		
		'	Verify SQL
			If instr(1, ExpectArray(y-1), "SQL") Then
				ExpectArray(y-1) = Environment("SQLResults")
			End If

			If trim(sValue) = trim(ExpectArray(y-1)) Then
			sFail = False
			ElseIf instr(1, sValue, ExpectArray(y-1)) then
				sFail = False
			Else
				sFail = True
				Exit For
			End If

			If y = (ubound(ExpectArray)+1) AND sFail = False Then
				Exit Do
			End If

			If y = (ubound(ExpectArray)+1) Then
				Exit For
			End If
				
			next
		
			loop

		Else
	
		'sFail = True

			ExpectArray = Split(expected, "~")

			Do 
			x = x + 1

			For y = 1 to (ubound(ExpectArray) +1)

			If windowObj <> "" Then
			sValue = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,y)
			Else
			sValue = Browser(broswerObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,y)
			End If

			If instr(sValue, "ERROR") = 1 Then
				sFail = True
				Exit Do
			End If

		
		'	Verify Datestamps
			If trim(ExpectArray(y-1)) = "Environment('Datestamp')" Then
				ExpectArray(y-1) = environment("Datestamp")
			Elseif instr (ExpectArray(y-1),"Environment('Datestamp')<") Then
				ExpectArray(y-1) = getfields(2,ExpectArray(y-1),"<")
				ExpectArray(y-1)  = mid(ExpectArray(y-1) ,1,len(ExpectArray(y-1) )-1)
				Call Utility_GenDatestamp(stepNum, stepName, expectedResult, page, object,ExpectArray(y-1), "Run Time")  
				ExpectArray(y-1) = environment("Datestamp")
			End If
	
			'Verify Timestamp
			If trim(ExpectArray(y-1)) = "Environment('Timestamp')" Then
				ExpectArray(y-1) = Environment("Timestamp")
			End If
		
		'	Verify SQL
			If instr(1, ExpectArray(y-1), "SQL") Then
				ExpectArray(y-1) = Environment("SQLResults")
			End If
		
			If instr(sValue, ExpectArray(y-1)) Then
				sFail = False
			Else
				sFail = True
				Exit For
			End If

			If y = (ubound(ExpectArray)+1) AND sFail = False Then
				Exit Do
			End If

			If y = (ubound(ExpectArray)+1) Then
				Exit For
			End If
		
			next
		
			loop

		End If

	Case "NEGATIVE"	'For Data Entry
		' Exit script if table row exists
		 If instr(1,expected,"?") then
			ExpectArray = Split(expected, "?")
		Else ExpectArray = Split(expected, "~")
		End If
		Do 
			x = x + 1

			For y = 1 to (ubound(ExpectArray) +1)
	
				sValue = Browser(browserObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,y)

				If instr(sValue, "ERROR") = 1 Then
					sFail = True
					Exit Do
				End If
		
			If trim(sValue) <> trim(ExpectArray(y-1)) Then
				sFail = True 
				Exit For
			Else sFail = False
			End If

			If y = (ubound(ExpectArray)+1) AND sFail = False Then
				Exit Do
			End If

			If y = (ubound(ExpectArray)+1) Then
				Exit For
			End If
		
			next
		loop

		logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object

		If sFail = True Then
			logDetails= "Expected: " &expected &CHR(13) & "Actual: " &"This row does not exist in the table."
		Else
			logDetails= "Expected: " &expected &CHR(13) & "Actual: " &"The row was found"
		End If

		result = verificationPoint("True", sFail, logObject, logDetails, browserObj, expectedResult)	

		If sFail ="False" Then
			Environment("RunComments") = expected & " already exists"
			Environment("RunFailures") = Environment("RunFailures") + 1
			Environment("RunTimeError") = "No"
			ExitAction
		End If
		Exit Function

		

	Case "ONERROR" ''For Data Entry
		' Exit script if table row does not exist
		 If instr(1,expected,"?") then
			ExpectArray = Split(expected, "?")
		Else ExpectArray = Split(expected, "~")
		End If

		If object = "Program" Then
			If Browser(browserObj).Page(page).Frame(frameobj).webtable(object).Exist = false Then
				Environment("RunComments") = "Health Plan associated with contract does not exist"
				Environment("RunFailures") = Environment("RunFailures") + 1
				Environment("RunTimeError") = "No"
				ExitAction
			End If
		End If
		Do 
			x = x + 1

			For y = 1 to (ubound(ExpectArray) +1)
	
				sValue = Browser(browserObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,y)

				If instr(sValue, "ERROR") = 1 Then
					sFail = True
					Exit Do
				End If
		
			If trim(sValue) <> trim(ExpectArray(y-1)) Then
				sFail = True 
				Exit For
			Else sFail = False
			End If

			If y = (ubound(ExpectArray)+1) AND sFail = False Then
				Exit Do
			End If

			If y = (ubound(ExpectArray)+1) Then
				Exit For
			End If
		
			next
		loop

		logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
		logDetails= "Expected: " &expected &CHR(13)
		
		result = verificationPoint("True", sFail, logObject, logDetails, browserObj, expectedResult)	

		If sFail ="False" and object = "Contract Info" Then
			Environment("RunComments") = object & " already added"
			Environment("RunFailures") = Environment("RunFailures") + 1
			Environment("RunTimeError") = "No"
			ExitAction
		End If
		Exit Function
	
	Case Else 'No Argument

	If Instr(object, ":=") Then

		Dim des(2)
	
		des(0) = getFields(0, object, "~")
		des(1) = getFields(1, object, "~")
		des(2) = getFields(2, object, "~")

		sFail = True

		ExpectArray = Split(expected, "~")

		Do 
		x = x + 1

		For y = 1 to (ubound(ExpectArray) +1)


		sValue = Browser(browserObj).Page(page).Frame(frameobj).webtable(des(0), des(1), des(2)).GetCellData(x,y)

		If instr(sValue, "ERROR") = 1 Then
			sFail = True
			Exit Do
		End If

 If trim(ExpectArray(y-1)) = "Environment('Datestamp')" Then
		ExpectArray(y-1) = environment("Datestamp")
	Elseif instr (ExpectArray(y-1),"Environment('Datestamp')<") Then
		ExpectArray(y-1) = getfields(2,ExpectArray(y-1),"<")
		ExpectArray(y-1)  = mid(ExpectArray(y-1) ,1,len(ExpectArray(y-1) )-1)
		Call Utility_GenDatestamp(stepNum, stepName, expectedResult, page, object,ExpectArray(y-1), "Run Time")  
		ExpectArray(y-1) = environment("Datestamp")
	End If

		'Verify Timestamp
		If trim(ExpectArray(y-1)) = "Environment('Timestamp')" Then
			ExpectArray(y-1) = Environment("Timestamp")
		End If
		
		'Verify SQL
		If instr(1, ExpectArray(y-1), "SQL") Then
			ExpectArray(y-1) = Environment("SQLResults")
		End If
		
		If trim(sValue) <> trim(ExpectArray(y-1)) Then
			sFail = True
			Exit For
		Else sFail = False
		End If

		If y = (ubound(ExpectArray)+1) AND sFail = False Then
		   Exit Do
		End If

		If y = (ubound(ExpectArray)+1) Then
			Exit For
		End If
				
		next
		
		loop

	Else
	
		'sFail = True
		
		If instr(1,expected,"?") then
			ExpectArray = Split(expected, "?")
		Else ExpectArray = Split(expected, "~")
		End If
		
		If Instr(object,"Contract") <> 0 Then
			colNames = Split(Browser(browserObj).Page(page).Frame(frameobj).WebTable("Select Contract").GetROProperty("column names"),";")
			testColumn = "Program"
		ElseIf Instr(object,"Plan") <> 0 Then
			colNames = Split(Browser(browserObj).Page(page).Frame(frameobj).WebTable("Select Plan").GetROProperty("column names"),";")
			testColumn = "Program"
'		ElseIf Instr(object,"Affili") <> 0 Then
'			colNames = Split(Browser(browserObj).Page(page).Frame(frameobj).WebTable("Select Affiliate").GetROProperty("column names"),";")
'			testColumn = "Type"
		Else
			colNames = Split(Browser(browserObj).Page(page).Frame(frameobj).WebTable(object).GetROProperty("column names"),";")
			testColumn = "Program"
		End If
		
		
		For cn = 0 To UBound(colNames) Step 1
			If colNames(cn) = testColumn Then
				y = cn + 1
				Exit For
			End If
		Next
		
		If object ="Contract Info" Then
			rc = Browser(browserObj).Page(page).Frame(frameobj).wbfgrid(object).GetROProperty("rows")
			Set tableObj = Browser(browserObj).Page(page).Frame(frameobj).wbfgrid(object)
		Else
			rc = Browser(browserObj).Page(page).Frame(frameobj).webtable(object).GetROProperty("rows")
			Set tableObj = Browser(browserObj).Page(page).Frame(frameobj).webtable(object)
		End If
		For x = 1 To rc Step 1
			sValue = tableObj.GetCellData(x,y)

		If instr(sValue, "ERROR") = 1 Then
			sFail = True
			Exit For
		End If

		
		'Verify Datestamps
		 If trim(ExpectArray(y-1)) = "Environment('Datestamp')" Then
		ExpectArray(y-1) = environment("Datestamp")
	Elseif instr (ExpectArray(y-1),"Environment('Datestamp')<") Then
		ExpectArray(y-1) = getfields(2,ExpectArray(y-1),"<")
		   ExpectArray(y-1)  = mid(ExpectArray(y-1) ,1,len(ExpectArray(y-1) )-1)
		Call Utility_GenDatestamp(stepNum, stepName, expectedResult, page, object,ExpectArray(y-1), "Run Time")  
		ExpectArray(y-1) = environment("Datestamp")
	End If

		'Verify Timestamp
		If trim(ExpectArray(y-1)) = "Environment('Timestamp')" Then
			ExpectArray(y-1) = Environment("Timestamp")
		End If
		
		'Verify SQL
		If instr(1, ExpectArray(y-1), "SQL") Then
			ExpectArray(y-1) = Environment("SQLResults")
		End If
		
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


	End If

	End Select

		logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object

		If sFail = True Then
		logDetails= "Expected: " &expected &CHR(13) & "Actual: " &"This row does not exist in the table. Compare the expected results to the table."
		Else
		logDetails= "Expected: " &expected &CHR(13) & "Actual: " &"The row was found"
		End If

 result = verificationPoint("False", sFail, logObject, logDetails, browserObj, expectedResult)	
 

End Function


Function ProviderUtility_VerifyTableRow (stepNum, stepName, expectedResult, page, object, expected, args)

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

		sFail = True

	 	ExpectArray = Split(expected, "~")
		x=0
		
		Do 
			x = x + 1

			For y = 1 to (ubound(ExpectArray) +1)

				sValue = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).webtable(desc(0), desc(1), desc(2)).GetCellData(x,y)
		
				If instr(sValue, "ERROR") = 1 Then
					sFail = True
				    Exit Do
				End If
		
				'Verify Datestamps
				 If trim(ExpectArray(y-1)) = "Environment('Datestamp')" Then
					ExpectArray(y-1) = environment("Datestamp")
				 Elseif instr (ExpectArray(y-1),"Environment('Datestamp')<") Then
					ExpectArray(y-1) = getfields(2,ExpectArray(y-1),"<")
					ExpectArray(y-1)  = mid(ExpectArray(y-1) ,1,len(ExpectArray(y-1) )-1)
					Call Utility_GenDatestamp(stepNum, stepName, expectedResult, page, object,ExpectArray(y-1), "Run Time")  
					ExpectArray(y-1) = environment("Datestamp")
				 End If

		
				 'Verify SQL
				 If instr(1, ExpectArray(y-1), "SQL") Then
					ExpectArray(y-1) = Environment("SQLResults")
				 End If
			
					'Verify Timestamp
					If trim(ExpectArray(y-1)) = "Environment('Timestamp')" Then
						ExpectArray(y-1) = Environment("Timestamp")
					End If
					
					If trim(sValue) <> trim(ExpectArray(y-1)) Then
					   sFail = True
					   Exit For
					Else sFail = False
					End If

				   If y = (ubound(ExpectArray)+1) AND sFail = False Then
						Exit Do
					End If
			
					If y = (ubound(ExpectArray)+1) Then
						Exit For
					End If
				
				next

			loop
		
	Else
	
		sFail = True

		ExpectArray = Split(expected, "~")

		Do 
		x = x + 1

		For y = 1 to (ubound(ExpectArray) +1)


		sValue = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,y)

		If instr(sValue, "ERROR") Then
			sFail = True
			Exit Do
		End If


		
'		'Verify Datestamps
	If trim(ExpectArray(y-1)) = "Environment('Datestamp')" Then
		ExpectArray(y-1) = environment("Datestamp")
	Elseif instr (ExpectArray(y-1),"Environment('Datestamp')<") Then
		ExpectArray(y-1) = getfields(1,ExpectArray(y-1),"<")
		   ExpectArray(y-1)  = mid(ExpectArray(y-1) ,1,len(ExpectArray(y-1) )-1)
		Call Utility_GenDatestamp(stepNum, stepName, expectedResult, page, object,ExpectArray(y-1), "Run Time")  
		ExpectArray(y-1) = environment("Datestamp")
	End If

		'Verify Timestamp
		If trim(ExpectArray(y-1)) = "Environment('Timestamp')" Then
			ExpectArray(y-1) = Environment("Timestamp")
		End If
		
		'Verify SQL
		If instr(1, ExpectArray(y-1), "SQL") Then
			ExpectArray(y-1) = Environment("SQLResults")
		End If
		
		If trim(sValue) <> trim(ExpectArray(y-1)) Then
			sFail = True
			Exit For
		Else sFail = False
		End If

		If y = (ubound(ExpectArray)+1) AND sFail = False Then
			Exit Do
		End If

		 If y = (ubound(ExpectArray)+1) Then
			Exit For
		End If
				
		next
		
		loop

	End If
	
	Case "INSTRING"  'verifies that a portion of each column in a row is correct - use when datestamp + timestamp exist

		If Instr(object, ":=") Then

			Dim descr(2)
	
			descr(0) = getFields(0, object, "~")
			descr(1) = getFields(1, object, "~")
			descr(2) = getFields(2, object, "~")

			sFail = True
			
			ExpectArray = Split(expected, "~")

			Do 
			x = x + 1

			For y = 1 to (ubound(ExpectArray) +1)

			If windowObj <> "" Then
			sValue = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).webtable(descr(0), descr(1), descr(2)).GetCellData(x,y)
			Else
			sValue = Browser(browserObj).Page(page).Frame(frameobj).webtable(descr(0), descr(1), descr(2)).GetCellData(x,y)
			End If

			If instr(sValue, "ERROR") = 1 Then
				sFail = True
				Exit Do
			End If

			If trim(ExpectArray(y-1)) = "Environment('Datestamp')" Then
				ExpectArray(y-1) = environment("Datestamp")
			Elseif instr (ExpectArray(y-1),"Environment('Datestamp')<") Then
				ExpectArray(y-1) = getfields(2,ExpectArray(y-1),"<")
				ExpectArray(y-1)  = mid(ExpectArray(y-1) ,1,len(ExpectArray(y-1) )-1)
				Call Utility_GenDatestamp(stepNum, stepName, expectedResult, page, object,ExpectArray(y-1), "Run Time")  
				ExpectArray(y-1) = environment("Datestamp")
			End If

			'Verify Timestamp
			If trim(ExpectArray(y-1)) = "Environment('Timestamp')" Then
				ExpectArray(y-1) = Environment("Timestamp")
			End If
		
		'	Verify SQL
			If instr(1, ExpectArray(y-1), "SQL") Then
				ExpectArray(y-1) = Environment("SQLResults")
			End If

			If trim(sValue) = trim(ExpectArray(y-1)) Then
			sFail = False
			ElseIf instr(1, sValue, ExpectArray(y-1)) then
				sFail = False
			Else
				sFail = True
				Exit For
			End If

			If y = (ubound(ExpectArray)+1) AND sFail = False Then
				Exit Do
			End If

			If y = (ubound(ExpectArray)+1) Then
				Exit For
			End If
				
			next
		
			loop

		Else
	
		'sFail = True

			ExpectArray = Split(expected, "~")

			Do 
			x = x + 1

			For y = 1 to (ubound(ExpectArray) +1)

			If windowObj <> "" Then
			sValue = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,y)
			Else
			sValue = Browser(broswerObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,y)
			End If

			If instr(sValue, "ERROR") = 1 Then
				sFail = True
				Exit Do
			End If

		
		'	Verify Datestamps
			If trim(ExpectArray(y-1)) = "Environment('Datestamp')" Then
				ExpectArray(y-1) = environment("Datestamp")
			Elseif instr (ExpectArray(y-1),"Environment('Datestamp')<") Then
				ExpectArray(y-1) = getfields(2,ExpectArray(y-1),"<")
				ExpectArray(y-1)  = mid(ExpectArray(y-1) ,1,len(ExpectArray(y-1) )-1)
				Call Utility_GenDatestamp(stepNum, stepName, expectedResult, page, object,ExpectArray(y-1), "Run Time")  
				ExpectArray(y-1) = environment("Datestamp")
			End If
	
			'Verify Timestamp
			If trim(ExpectArray(y-1)) = "Environment('Timestamp')" Then
				ExpectArray(y-1) = Environment("Timestamp")
			End If
		
		'	Verify SQL
			If instr(1, ExpectArray(y-1), "SQL") Then
				ExpectArray(y-1) = Environment("SQLResults")
			End If
		
			If instr(sValue, ExpectArray(y-1)) Then
				sFail = False
			Else
				sFail = True
				Exit For
			End If

			If y = (ubound(ExpectArray)+1) AND sFail = False Then
				Exit Do
			End If

			If y = (ubound(ExpectArray)+1) Then
				Exit For
			End If
		
			next
		
			loop

		End If

	Case "NEGATIVE"	'For Data Entry
		' Exit script if table row exists
		 If instr(1,expected,"?") then
			ExpectArray = Split(expected, "?")
		Else ExpectArray = Split(expected, "~")
		End If
		Do 
			x = x + 1

			For y = 1 to (ubound(ExpectArray) +1)
	
				sValue = Browser(browserObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,y)

				If instr(sValue, "ERROR") = 1 Then
					sFail = True
					Exit Do
				End If
		
			If trim(sValue) <> trim(ExpectArray(y-1)) Then
				sFail = True 
				Exit For
			Else sFail = False
			End If

			If y = (ubound(ExpectArray)+1) AND sFail = False Then
				Exit Do
			End If

			If y = (ubound(ExpectArray)+1) Then
				Exit For
			End If
		
			next
		loop

		logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object

		If sFail = True Then
			logDetails= "Expected: " &expected &CHR(13) & "Actual: " &"This row does not exist in the table."
		Else
			logDetails= "Expected: " &expected &CHR(13) & "Actual: " &"The row was found"
		End If

		result = verificationPoint("True", sFail, logObject, logDetails, browserObj, expectedResult)	

		If sFail ="False" Then
			Environment("RunComments") = expected & " already exists"
			Environment("RunFailures") = Environment("RunFailures") + 1
			Environment("RunTimeError") = "No"
			ExitAction
		End If
		Exit Function

		

	Case "ONERROR" ''For Data Entry
		' Exit script if table row does not exist
		 If instr(1,expected,"?") then
			ExpectArray = Split(expected, "?")
		Else ExpectArray = Split(expected, "~")
		End If

		If object = "Program" Then
			If Browser(browserObj).Page(page).Frame(frameobj).webtable(object).Exist = false Then
				Environment("RunComments") = "Health Plan associated with contract does not exist"
				Environment("RunFailures") = Environment("RunFailures") + 1
				Environment("RunTimeError") = "No"
				ExitAction
			End If
		End If
		Do 
			x = x + 1

			For y = 1 to (ubound(ExpectArray) +1)
	
				sValue = Browser(browserObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,y)

				If instr(sValue, "ERROR") = 1 Then
					sFail = True
					Exit Do
				End If
		
			If trim(sValue) <> trim(ExpectArray(y-1)) Then
				sFail = True 
				Exit For
			Else sFail = False
			End If

			If y = (ubound(ExpectArray)+1) AND sFail = False Then
				Exit Do
			End If

			If y = (ubound(ExpectArray)+1) Then
				Exit For
			End If
		
			next
		loop

		logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
		logDetails= "Expected: " &expected &CHR(13)
		
		result = verificationPoint("True", sFail, logObject, logDetails, browserObj, expectedResult)	

		If sFail ="False" and object = "Contract Info" Then
			Environment("RunComments") = object & " already added"
			Environment("RunFailures") = Environment("RunFailures") + 1
			Environment("RunTimeError") = "No"
			ExitAction
		End If
		Exit Function
	
	Case Else 'No Argument

	If Instr(object, ":=") Then

		Dim des(2)
	
		des(0) = getFields(0, object, "~")
		des(1) = getFields(1, object, "~")
		des(2) = getFields(2, object, "~")

		sFail = True

		ExpectArray = Split(expected, "~")

		Do 
		x = x + 1

		For y = 1 to (ubound(ExpectArray) +1)


		sValue = Browser(browserObj).Page(page).Frame(frameobj).webtable(des(0), des(1), des(2)).GetCellData(x,y)

		If instr(sValue, "ERROR") = 1 Then
			sFail = True
			Exit Do
		End If

 If trim(ExpectArray(y-1)) = "Environment('Datestamp')" Then
		ExpectArray(y-1) = environment("Datestamp")
	Elseif instr (ExpectArray(y-1),"Environment('Datestamp')<") Then
		ExpectArray(y-1) = getfields(2,ExpectArray(y-1),"<")
		ExpectArray(y-1)  = mid(ExpectArray(y-1) ,1,len(ExpectArray(y-1) )-1)
		Call Utility_GenDatestamp(stepNum, stepName, expectedResult, page, object,ExpectArray(y-1), "Run Time")  
		ExpectArray(y-1) = environment("Datestamp")
	End If

		'Verify Timestamp
		If trim(ExpectArray(y-1)) = "Environment('Timestamp')" Then
			ExpectArray(y-1) = Environment("Timestamp")
		End If
		
		'Verify SQL
		If instr(1, ExpectArray(y-1), "SQL") Then
			ExpectArray(y-1) = Environment("SQLResults")
		End If
		
		If trim(sValue) <> trim(ExpectArray(y-1)) Then
			sFail = True
			Exit For
		Else sFail = False
		End If

		If y = (ubound(ExpectArray)+1) AND sFail = False Then
		   Exit Do
		End If

		If y = (ubound(ExpectArray)+1) Then
			Exit For
		End If
				
		next
		
		loop

	Else
	
		'sFail = True
		
		If instr(1,expected,"?") then
			ExpectArray = Split(expected, "?")
		Else ExpectArray = Split(expected, "~")
		End If
		
		If Instr(object,"Contract") <> 0 Then
			colNames = Split(Browser(browserObj).Page(page).Frame(frameobj).WebTable("Select Contract").GetROProperty("column names"),";")
			testColumn = "Program"
		ElseIf Instr(object,"Plan") <> 0 Then
			colNames = Split(Browser(browserObj).Page(page).Frame(frameobj).WebTable("Select Plan").GetROProperty("column names"),";")
			testColumn = "Program"
'		ElseIf Instr(object,"Affili") <> 0 Then
'			colNames = Split(Browser(browserObj).Page(page).Frame(frameobj).WebTable("Select Affiliate").GetROProperty("column names"),";")
'			testColumn = "Type"
		Else
			colNames = Split(Browser(browserObj).Page(page).Frame(frameobj).WebTable(object).GetROProperty("column names"),";")
			testColumn = "Program"
		End If
		
		
'		For cn = 0 To UBound(colNames) Step 1
'			If colNames(cn) = testColumn Then
'				y = cn + 1
'				Exit For
'			End If
'		Next
		

			rc = Browser(browserObj).Page(page).Frame(frameobj).webtable(object).GetROProperty("rows")
			Set tableObj = Browser(browserObj).Page(page).Frame(frameobj).webtable(object)		


		Do 
		x = x + 1

		For y = 1 to (ubound(ExpectArray) +1)


		sValue = tableObj.GetCellData(x,y)

		If instr(sValue, "ERROR") = 1 Then
			sFail = True
			Exit Do
		End If

 If trim(ExpectArray(y-1)) = "Environment('Datestamp')" Then
		ExpectArray(y-1) = environment("Datestamp")
	Elseif instr (ExpectArray(y-1),"Environment('Datestamp')<") Then
		ExpectArray(y-1) = getfields(2,ExpectArray(y-1),"<")
		ExpectArray(y-1)  = mid(ExpectArray(y-1) ,1,len(ExpectArray(y-1) )-1)
		Call Utility_GenDatestamp(stepNum, stepName, expectedResult, page, object,ExpectArray(y-1), "Run Time")  
		ExpectArray(y-1) = environment("Datestamp")
	End If

		'Verify Timestamp
		If trim(ExpectArray(y-1)) = "Environment('Timestamp')" Then
			ExpectArray(y-1) = Environment("Timestamp")
		End If
		
		'Verify SQL
		If instr(1, ExpectArray(y-1), "SQL") Then
			ExpectArray(y-1) = Environment("SQLResults")
		End If
		
		If trim(sValue) <> trim(ExpectArray(y-1)) Then
			sFail = True
			Exit For
		Else sFail = False
		End If

		If y = (ubound(ExpectArray)+1) AND sFail = False Then
		   Exit Do
		End If

		If y = (ubound(ExpectArray)+1) Then
			Exit For
		End If
				
		next
		
		loop


	End If

	End Select

		logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object

		If sFail = True Then
		logDetails= "Expected: " &expected &CHR(13) & "Actual: " &"This row does not exist in the table. Compare the expected results to the table."
		Else
		logDetails= "Expected: " &expected &CHR(13) & "Actual: " &"The row was found"
		End If

 result = verificationPoint("False", sFail, logObject, logDetails, browserObj, expectedResult)	
 

End Function
