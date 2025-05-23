  
'***************************************************************
' Function:  ConfigurationUtility_VerifyDialogExists (stepNum, stepName, page, object, expected, args)
' Date Created: 6/25/2007
' Date Modifed: 6/25/2007
' Created By: Chris Thompson
' Description:  VerifyDialogExists keyword for the dialog type object
'***************************************************************

Function ConfigurationUtility_VerifyDialogExists (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	'Parse Page Objects

	browserObj = getFields(0,page , "-")
	WindowObj=getfieldsUpperNull(2,page,"-")
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

		' Case for when the Dialog is the top object in OR heirarchy

		Case "DIALOG"
			actual = Dialog(object).Exist
			result =  VerificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult)			

		' Case for exiting script when error dialog appears

		Case "ONERROR"

			prop=getFields(0, expected, ":=")
			expected=getFields(1, expected, ":=")
			expected=mid(expected,1)

			If windowObj <> "" Then

				actual = Browser(browserObj ).window(windowobj).dialog(page).Exist
				If actual = "True" Then
					actual = Browser(browserObj).Window(windowObj).Dialog(page).Static(object).Exist
				End If
				If actual = "True" Then
					reason = Browser(browserObj ).window(windowobj).dialog(page).Static(object).GetTOProperty("text")
					Environment("RunComments") = reason
					result =  VerificationPoint(prop, actual, logObject, logDetails, browserObj, expectedResult )
					Environment("RunFailures") = Environment("RunFailures") + 1
					Environment("RunTimeError") = "No"
					ExitAction
				End If
			Else
				actual = Browser(browserObj).Dialog(page).Exist
				If actual = "True" Then
					actual = Browser(browserObj).Dialog(page).Static(object).Exist
				End If
				If actual = "True" Then

					' Write error message to Comments field of data entry script and exit the test
					
					reason = Browser(browserObj).Dialog(page).Static(object).GetTOProperty("text")
					Environment("RunComments") = reason
					   ' If reason <> "Affiliation Exists" Then
							result =  VerificationPoint(prop, actual, logObject, logDetails, browserObj, expectedResult )
							Environment("RunFailures") = Environment("RunFailures") + 1
							Environment("RunTimeError") = "Yes"
							ExitAction
					  '  End If
				End If		
				
			End If
			
		' Case for skipping next action if  error message does not appear
		
		Case "SKIPNEXT"

			prop=getFields(0, expected, ":=")
			expected=getFields(1, expected, ":=")
			expected=mid(expected,1)
			actual = Browser(browserObj).Dialog(page).Exist
			If actual = "True" Then
				actual = Browser(browserObj).Dialog(page).Static(object).Exist
			End If
			If actual = "True" Then
				reason = Browser(browserObj).Dialog(page).Static(object).GetTOProperty("text")
				Environment("RunComments") = reason
				Environment("SkipNext") = False
				Browser(browserObj).Dialog(page).WinButton("No").Click
				result =  VerificationPoint(prop, actual, logObject, logDetails, browserObj, expectedResult )
			Else
				Environment("SkipNext") = True
				result =  VerificationPoint(prop, actual, logObject, logDetails, browserObj, expectedResult )
			End If

		' Case for verifying if error message in dialog box exists or not
		
		Case "STATIC"

			If windowobj <>"" Then
				actual = Browser(browserObj ).window(windowobj).dialog(page).static(object).Exist			
			elseif BrowserObj <> "" then
				actual = Browser(browserObj ).dialog(page).static(object).Exist
			else
				actual =dialog(desc(0)).static(desc(1)).Exist
			End If

			If actual = true Then

				' Continue provider data entry when Federal ID exists for another provider
				
				If object = "Fed ID Exists" Then
					Browser(browserObj).Dialog(page).WinButton("Yes").Click
					Exit Function
				End If

				' Stop data entry if SSN or Name & DOB exists for another provider
				
				If object = "SSN Exists" or object = "Name and DOB Exists" Then
					Environment("SubError") = "Yes"
					Environment("RunSubComments") = object
					Environment("RunComments") = object
					Browser(browserObj).Dialog(page).WinButton("No").Click
				End If

				' Write error to log but continue if premum detail already exists

				If object = "Premium Detail Exists" Then
					Environment("RunSubComments") = Browser(browserObj ).dialog(page).static(object).GetTOProperty("text")
					Environment("RunComments") = Browser(browserObj ).dialog(page).static(object).GetTOProperty("text")
					Environment("RunFailures") = Environment("RunFailures") + 1
					Environment("RunTimeError") = "No"
					Browser(browserObj).Dialog(page).WinButton("OK").Click
				End If
				
			End If

			logDetails = logDetails & " Actual: " &actual  
     		result = VerificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )	
			  
		' No argument
		
		Case Else
				actual = Browser( browserObj).Dialog(page).Exist
				result =  VerificationPoint(expected, actual, logObject, logDetails, browserObj, expectedResult )   
				 
	End Select
	
End Function

'***************************************************************
' Function: ConfigurationUtility_RunMultipleSub(stepNum, stepName, page, object, expected, args)
' Date Created: 10/24/2007
' Date Modifed: 10/24/2007
' Created By: Jason Craig
' Description:  Executes a given Subprocedure multiple numbers of times based on record count of SQL query for data set
'***************************************************************   

Function ConfigurationUtility_RunMultipleSub(stepNum, stepName, expectedResult, page, object, expected, args)

	' Retrieve Subprocedure
	' sub_rs = recordset for subprocedure
	
	Dim temp, varArray
	db="DRIVER={Microsoft Access Driver (*.mdb)};DBQ=" &Environment("runControlFile") 
	Set sub_rs = Createobject("ADODB.RecordSet")
	sub_sqlquery = "Select * from " &object &" order by STEP"
	sub_rs.Open sub_sqlquery, db, 3, 4, 1

	' Retrieve Data set
	' rs8 = recordset for data set

	expected2 = expected
	expected = getfields(0,expected,"^")

	table=getFields(0, expected, ":=")
	field=getFields(1, expected, ":=")
	expected=getFields(2, expected, ":=")

	db4="DRIVER={Microsoft Access Driver (*.mdb)};DBQ=" &Environment("runControlFile") 
	Set rs8 = Createobject("ADODB.RecordSet")
	If isnumeric(expected) = false Then
		sqlquery4 = "Select * from " &table &" where " &field &" = '" &Expected&"' order by Id"		
	else
		sqlquery4 = "Select * from " &table &" where " &field &" = " &Expected&" order by Id"
	End If
	'sqlquery4 = "Select * from " &table &" where " &field &" = " &Expected&" order by Id"
	rs8.Open sqlquery4, db4, 1, 3

	'Branch for special cases

	If object = "SUB_EnterOrgPolicy_OptRel"then
		t=t
	End if

	subName = object

	Reporter.ReportEvent micDone, object, "Executing"

	' Retrieve any data variables for subprocedure
	
	If expected2 <> "" Then
	   varArray = split(mid(expected2,1,len(expected2)), "^")
	End If

	' Execute the subprocedure once for each row in the data set

	rs8.movefirst
	Environment ("RunRow2") = ""
	
	For z = 1 to rs8.recordcount

		If rs8.recordcount <> 0 Then	
			Environment ("RunRow2") = cstr(rs8("Id").Value)
			rs8.update
		End If

		sub_rs.MoveFirst
		
		For x =1 to sub_rs.recordcount

			expected3 = sub_rs("EXPECTED_RESULTS")
			object = sub_rs("OBJECT")
			 
			skipAction = false

			' Convert Gender value for Members in data set to QNXT value

			If expected3 = "value:=~Gender~" Then
				temp = getfields(1,expected3,"~")
				If isnull(rs8(temp).value)  then
					expected3 = "value:=rdoGenderUnknown"
				else
					expected3 = Replace(expected3, "~" &temp &"~", cstr(rs8(temp).value))
					If expected3 = "value:=M" Then
						expected3 = "value:=rdoGenderMale"
					elseif expected3 = "value:=F" then
						expected3 = "value:=rdoGenderFemale"
					else
						expected3 = "value:=rdoGenderUnknown"
					End If
				End If
			End If

			'Custom Code for SUB_EnterRateTable
			If subName = "SUB_EnterRateTable" Then
				If isnull(rs8("Rate Table").value) Then
					Exit For
				End If
			End If
			'Custom Code for SUB_EnterPolicyPlan
		If subName = "SUB_EnterPolicyPlan" Then
			If instr(1, expected3, "Policy Plan1") Then
				If rs8("Policy Plan1") = "NA" Then
					skipAction = True
				End If
			End If
			If instr(1, expected3, "Policy Plan2") Then
				If rs8("Policy Plan2") = "NA" Then
					skipAction = True
				End If
			End If
			If instr(1, expected3, "Policy Plan3") Then
				If rs8("Policy Plan3") = "NA" Then
					skipAction = True
				End If
			End If
		End If
			' Custom code for SUB_EnterPremiumRateTable_Details subprocedure for PremiumRateTable script

			If subName = "SUB_EnterPremiumRateTable_Details" Then

				' Max Age field value is entered in months, but display value in row when added is in years, so need to convert
				' when verifying table row

				If sub_rs("ACTION") = "VerifyTableRow" OR sub_rs("ACTION") = "SelectRow" Then
					If instr(expected3, "~Max Age (Months)~") Then
						temp = "Max Age (Months)"
						If isnull(rs8(temp).value) then
							expected3 = Replace(expected3, "~" &temp& "~", "")
						else
							months2years = int(cint(rs8(temp).value)/12)
							expected3 = Replace(expected3, "~" &temp &"~", cstr(months2years))
						end if
					End If
					If instr(expected3, "~Maximum Age(Months)~") Then
						temp = "Maximum Age"
						If isnull(rs8(temp).value) Then
							expected3 = replace(expected3, "~" &temp&"~", "")
							else
							months2years = int(cint(rs8(temp).value)/12)
							expected3 = Replace(expected3, "~Maximum Age(Months)~",cstr(months2years))
						End If
					End If
					If instr(expected3, "~Benefit Plan~") Then
						temp = "Benefit Plan"
						If rs8(temp) = "NO BENEFITPLAN" Then
							expected3 = Replace(expected3, "~"&temp&"~","")
						End If
					End If
					 If instr(expected3, "~Coverage Type~") Then
						temp = "Coverage Type"
						If ucase(rs8(temp)) = "NO COVERAGE TYPE" Then
							expected3 = Replace(expected3, "~"&temp&"~", "I")
						End If
					End If
				End If

				' Add leading zeros to dates
				
				If instr(expected3,"~Effective Date~") Then
					temp = "Effective Date"
					dateConversion = rs8(temp)
					months = Month(dateConversion)
					days = Day(dateConversion)
					years = Year(dateConversion)
					If len(months) = 1 Then
						months = "0" &months
					End If
					If len(days) = 1 Then
						days = "0" &days
					End If
					dateConversion = months &"/" &days &"/" &years
					expected3 = Replace(expected3, "~"&temp&"~",dateConversion)
				End If

				' When Billing Methodology = "Bill each Member", coverage type is not applicable
				
				If object = "Coverage Type" Then
					If rs8("Coverage Type") = "No coverage Type" Then
						skipAction = true
					End If
				End If
				
			End If

			' Custom code for SUB_EnterAttributeOrgPolicy
			If subName = "SUB_EnterAttributeOrgPolicy" Then
				temp = "Attribute Value"
				If ucase(rs8(temp)) = "NA" Then
					skipAction = true
				End If

				If instr(expected3,"~Attribute Value~:=SQL.thevalue") Then
					temp = "Attribute Value"
					expected3 = Replace(expected3, "~" &temp &"~", cstr(rs8(temp).value))
					If instr(expected3,"Yes") Then
						expected3 = Replace(expected3, "Yes", "Y")
					elseif instr(expected3,"No") then
						expected3 = Replace(expected3, "No", "N")
					End If
				End If
			End If

			' Custom code for SUB_EnterOrgPolicy_EligRule
			If subName = "SUB_EnterOrgPolicy_EligRule" Then
				x = sub_rs.recordcount  'There appears to only be on EligRule per OrgPolicy....
				If rs8("Wait Time Frame") = "NA" Then
					Exit For
				End If
				If instr(expected3,"~Allow Late Enrollees~:=SQL.allowlateenrollee") Then
					temp = "Allow Late Enrollees"
					expected3 = Replace(expected3, "~" &temp &"~", cstr(rs8(temp).value))
					If instr(expected3,"YES") Then
						expected3 = Replace(expected3, "YES", "Y")
					End If
				elseif instr(expected3,"~Day After Waiting Period Specified~:=SQL.waitrule") Then
					temp = "Day After Waiting Period Specified"
					expected3 = Replace(expected3, "~" &temp &"~", cstr(rs8(temp).value))
					If instr(expected3,"YES") Then
						expected3 = Replace(expected3, "YES", "A")
					End If
				End If
			End If

			' Custom code for SUB_AddCOB
			If subName = "SUB_AddCOB" Then
				If instr(expected3,"~Accumulation Year Area~:=SQL.creditreserveyear") Then
					temp = "Accumulation Year Area"
					expected3 = Replace(expected3, "~" &temp &"~", cstr(rs8(temp).value))
					If instr(expected3,"Policy") Then
						expected3 = Replace(expected3, "Policy", "POLICY")
					End If
				elseif instr(expected3,"~COB Method~:=SQL.coblessoramtmethod") Then
					temp = "COB Method"
					expected3 = Replace(expected3, "~" &temp &"~", cstr(rs8(temp).value))
					If instr(expected3,"Method 1") Then
						expected3 = Replace(expected3, "Method 1", "1")
					elseif instr(expected3,"Method 12") then
						expected3 = Replace(expected3, "Method 12", "12")
					End If
				elseif instr(expected3,"~COB for Professional~:=SQL.cobfor1500") then
					temp = "COB for Professional"
					expected3 = Replace(expected3, "~" &temp &"~", cstr(rs8(temp).value))
					If instr(expected3,"Yes")Then
						expected3 = Replace(expected3,"Yes","Y")
					End If
				elseif instr(expected3,"~COB for Institutional~:=SQL.cobforub") then
					temp = "COB for Institutional"
					expected3 = Replace(expected3, "~" &temp &"~", cstr(rs8(temp).value))
					If instr(expected3,"Yes")Then
						expected3 = Replace(expected3,"Yes","Y")
					End If
				End If
			End If

			'Custom code for SUB_EnterAdministrationFees_""
			If subName = "SUB_EnterAdministrationFees_COB"Then
				If rs8("Administration Fees COB") = "NA" Then
					Exit For
				Else
					If object = "Administration Fees" Then
						expected3 = "value:=COB"
					End If
				End If
			End If
			If subName = "SUB_EnterAdministrationFees_IDCard"Then
				If rs8("Administration Fees ID Card Printing Fee") = "NA"Then
					Exit For
				Else
					If object = "Administration Fees" Then
						expected3 = "value:=ID Card Printing Fee"
					End If
				End If
			End If
			If subName = "SUB_EnterAdministrationFees_Member"Then
				If rs8("Administration Fees Member Eligibility Transmission") = "NA"Then
					Exit For
				Else
					If object = "Administration Fees" Then
						expected3 = "value:=Member Eligibility Transmission"
					End If
				End If
			End If
			If subName = "SUB_EnterAdministrationFees_Obesity"Then
				If rs8("Administration Fees Obesity Program") = "NA"Then
					Exit For
				Else
					If object = "Administration Fees" Then
						expected3 = "value:=Obesity Program"
					End If
				End If
			End If
			If subName = "SUB_EnterAdministrationFees_Teleconsulta"Then
				If rs8("Administration Fees Teleconsulta") = "NA"Then
					Exit For
				Else
					If object = "Administration Fees" Then
						expected3 = "value:=Teleconsulta"
					End If
				End If
			End If
			'Custom code for SUB_EnterPremium
			If subName = "SUB_EnterPremium" Then

				If instr(expected3,"~Billing Methodology~:=SQL.premiumtype") Then
					temp = "Billing Methodology"
					expected3 = Replace(expected3, "~" &temp &"~", cstr(rs8(temp).value))
					If instr(expected3,"Bill as a Family") Then
						expected3 = Replace(expected3,"Bill as a Family","F")
					End If
				elseif instr(expected3,"~Premium Generation Cycle~:=SQL.period") then
					temp = "Premium Generation Cycle"
					expected3 = Replace(expected3, "~" &temp &"~", cstr(rs8(temp).value))
					If instr(expected3,"Monthly") Then
						expected3 = replace(expected3,"Monthly","1")
					End If
				Elseif instr(expected3,"~Premium Generation Type~:=SQL.billmethod") then
					temp = "Premium Generation Type"
					expected3 = Replace(expected3, "~" &temp &"~", cstr(rs8(temp).value))
					If instr(expected3, "Daily Proration") Then
						expected3 = replace(expected3, "Daily Proration", "1")
					Elseif instr(expected3, "Front End Back End Wash") Then
						expected3 = replace(expected3, "Front End Back End Wash", "2")
					Elseif instr(expected3, "Half Wash") Then
						expected3 = replace(expected3, "Half Wash", "3")
					Elseif instr(expected3, "Back End") Then
						expected3 = replace(expected3, "Back End", "4")
					End If
				Elseif instr(expected3, "~Adopted Billing~:=SQL.adoptionbilltype") then
					temp = "Adopted Billing"
					expected3 = Replace(expected3, "~" &temp &"~", cstr(rs8(temp).value))
					If instr(expected3, "Always Bill Adoptee") Then
						expected3 = replace(expected3, "Always Bill Adoptee", "A")
					Elseif instr(expected3, "Effective Day After Adoptee Period") then
						expected3 = replace(expected3, "Effective Day After Adoptee Period", "D")
					Elseif instr(expected3, "Effective Month After Adoptee Period") then
						expected3 = replace(expected3, "Effective Month After Adoptee Period", "M")
					End If
				Elseif instr(expected3, "~Newborn Premiums~:=SQL.newbornbilltype") then
					temp = "Newborn Premiums"
					expected3 = Replace(expected3, "~" &temp &"~", cstr(rs8(temp).value))
					If instr(expected3, "Always Bill Newborn") Then
						expected3 = replace(expected3, "Always Bill Newborn", "A")
					Elseif instr(expected3, "Effective Day After Newborn Period") then
						expected3 = replace(expected3, "Effective Day After Newborn Period", "D")
					Elseif instr(expected3, "Effective Month After Newborn Period") then
						expected3 = replace(expected3, "Effective Month After Newborn Period", "M")
					End If
				'This block verifies that the correct Age Change Rule and Initial Age Calculation have been selected according to the Enter Premium table
				Elseif instr(expected3, "~Age Change Rule~:=SQL.agechangerule") then
					temp = "Policy Anniversary"
					If rs8(temp) = "Yes" Then
					expected3 = replace(expected3, "~Age Change Rule~", "A")
					Elseif rs8(temp) <> "Yes" Then
						temp = "Subscriber's Anniversary"
						If rs8(temp) = "Yes" Then
							expected3 = replace(expected3, "~Age Change Rule~", "S")
						End If
					End If
				Elseif instr(expected3, "~Initial Age Calculation~:=SQL.initialagecalculation") Then
					temp = "Attained Age"
					If rs8(temp) = "Yes" Then
						expected3 = replace(expected3, "~Initial Age Calculation~", "T")
					Elseif rs8(temp) <> "Yes" Then
						temp = "Age at Anniversary"
						If rs8(temp) = "Yes" Then
							expected3 = replace(expected3, "~Initial Age Calculation~", "A")
						Elseif rs8(temp) <> "Yes" Then
							temp = "Sponsor"
							If rs8(temp) = "Yes" Then
								expected3 = replace(expected3, "~Intial Age Calculation~", "E")
								expected 3 = replace(expected3, "SQL.initialagecalculation", "SQL.subsanniversaryrule")
							Elseif rs8(temp) <> "Yes" Then
								temp = "Sponsor/Benefit Plan"
								If rs8(temp) = "Yes" Then
									expected3 = replace(expected3, "~Initial Age Calculation~", "B")
									expected3 = replace(expected3, "SQL.initialagecalculation", "SQL.subsanniversaryrule")
								End If
							End If
						End If
						If expected3 = "~Initial Age Calculation~:=SQL.initialagecalculation" Then
							skipAction = True
						End If
					End If
				'This block searches Premium Details for correct Age Change Rule and Initial Age Calculation to select
				Elseif instr(expected3, "Select Age Change Rule") then
					temp = "Policy Anniversary"
					If rs8(temp) = "Yes" Then
						expected3 = temp
					Elseif  rs8(temp) <> "Yes" then
						temp = "Subscriber's Anniversary"
						If rs8(temp) = "Yes" Then
							expected3 = temp
						Elseif rs8(temp) <> "Yes" then
							temp = "First of Month"
							If rs8(temp) = "Yes" Then
								expected3 = temp
							Elseif rs8(temp) <> "Yes" then
								temp = "First of Month FOM B-Day"
									If rs8(temp) = "Yes" Then
										expected3 = temp
									End If
							End If
						End If
					End If
					If expected3 = "Select Age Change Rule" Then
						skipAction = True
					End If
				Elseif instr(expected3, "Select Initial Age Calculation") then
					temp = "Age at Anniversary"
					If rs8(temp) = " Yes" Then
						expected3 = temp
					Elseif rs8(temp) <> "Yes" then
						temp = "Attained Age"
						If rs8(temp) = "Yes" Then
							expected3 = temp
						Elseif rs8(temp) <> "Yes" then
							temp = "Sponsor"
								If rs8(temp) = "Yes" Then
									expected3 = temp
								Elseif rs8(temp) <> "Yes" then
									temp = "Sponsor/Benefit Plan"
										If rs8(temp) = "Yes" Then
											expected3 = temp
										End If
								End If
						End If
					End If
					If expected3 = "Select Initial Age Calculation" Then
					skipAction = True
					End If
				End If
				
			End If

			' Custom code for SUB_EnterOrgPolicy_OptRel subprocedure for OrgPolicy script

			If subName = "SUB_EnterOrgPolicy_OptRel" Then
			   ' If instr(expected3,"~Triple-S Optional Dependents Standard~") Then
					temp = "Triple-S Optional Dependents Standard"
					If ucase(rs8(temp)) = "NO" Then
						skipAction = true
					End If
			   ' End If
			End If

			' Replace Subprocedure variable with data set value
			
			temp = ""
			If expected3 <> "" Then
				temp3 = expected3
				For y = 1 to UBound(varArray)
					If instr(1,sub_rs("EXPECTED_RESULTS")&"[",getFields(0,mid(varArray(y),1),"[")&"[") Then
						temp = getFields(1,varArray(y),"[")
						temp = mid(temp,1,len(temp)-1)
						temp3 = replace (temp3, getfields(0,vararray(y),"["),temp)
					End If
				Next
			End If
			expected3 = temp3

			' Replace variables with data set value
			
			Do 
				If instr(expected3,"~")  Then
					temp = getfields(1,expected3,"~")
					If isnull(rs8(temp).value) then
						expected3 = Replace(expected3, "~" &temp& "~", "")
					else
						expected3 = Replace(expected3, "~" &temp &"~", cstr(rs8(temp).value))
					End If
				End If
				If instr(expected3,"<Skip>") Then
					expected3 = Replace(expected3, "<Skip>", "")
				End If
			Loop While instr(expected3,"~") <> 0
			temp3 = expected3



			' Replace Subprocedure variable with direct value

		   ' If temp3 = sub_rs("EXPECTED_RESULTS") Then
				For y = 1 to UBound(varArray)
					If instr(1,sub_rs("EXPECTED_RESULTS"),getFields(0,mid(varArray(y),1),"[")) Then
						temp = getFields(1,varArray(y),"[")
						temp = mid(temp,1,len(temp)-1)
						temp3 = replace (temp3, getfields(0,vararray(y),"["),temp)
					End If
				Next
			'End If

			temp = temp3

			If temp = "" Then
				temp = sub_rs("EXPECTED_RESULTS")
			End If

			If x = 5 Then
				x=x
			End If

			'temp = ReplaceSQLReference(temp)

'			If instr(sub_rs("DESCRIPTION"),"Another Member") then
'				anotherMember = cstr(rs8("Another Member").value)
'				object = anotherMember
'			end if

			' For Claims entry: get the correct row for service entry

			If instr(1,object,"name:=dgService:_ctl.*") Then
				serviceRow = cint(rs8("LINE")) + 1
				object = Replace(object, ".*", cstr(serviceRow))
			End If

			' For Institutional claims: get the correct row for service entry

			If instr(1,object,"name:=dgSrvUB92:_ctl.*") Then
				serviceRow = cint(rs8("LINE")) + 1
				object = Replace(object, ".*", cstr(serviceRow))
			End If

			Environment("RunSubValidation") = ""
			Environment ("RunSubStatus") = "PASSED"
			Environment("RunTimeSubError")="Yes"
			Environment("RunSubTimeout")=2
			  
			Environment("RunSubComments") = ""
			Environment("SubError") = ""
			subError = Environment("RunFailures")

			' Execute the function call 
		
			FunctionCall = "Call " &sub_rs("OBJECT_TYPE") &"_" &sub_rs("ACTION") &"(""" &stepNum &"." &sub_rs("STEP") &""",""" &sub_rs("DESCRIPTION")&""","""&sub_rs("PAGE") &""",""" &object &""",""" &temp &""",""" &ucase(sub_rs("ARGUMENTS")) &""")"

			 If skipAction = false and instr(sub_rs("DESCRIPTION"),"///") = 0 Then
				Execute (FunctionCall)
			End If
		
			If Environment("SubError") <> "" Then
				Environment("RunComments") = "Dependent Member Error: "&Environment("RunComments")
				Exit For
			End If
		
			sub_rs.movenext
			temp = ""
			Environment("RunTimeSubError") = "No"
			
		Next

		If Environment("RunTimeSubError") = "Yes" Then
			Environment("RunSubStatus") = "RUN TIME ERROR"
		elseif Environment("RunFailures") <> 0 then
			Environment("RunStatus") = "FAILED"
			If Environment("RunFailures") > subError Then
				Environment("RunSubStatus") = "FAILED"
			End If
		End If

		If Environment("RunSubValidation") = "" Then
			Environment("RunSubValidation") = "PASSED"
		End If

		If Environment("RunTimeSubError") = "Yes" Then
			Environment("RunSubValidation") = "FAILED"
		End If

		' record results to sub data set
				
		rs8("STATUS").Value = Environment("RunSubStatus")
		rs8("RUN_COMPUTER").Value = runComputer
		rs8("VALIDATION").Value = cstr(Environment("RunSubValidation"))
		rs8("ENVIRONMENT").Value = Environment("Environment")
		rs8("COMMENTS").Value=Environment("RunSubComments")
		''rs8("DATE_EXECUTED").Value = Now
		rs8.update
		rs8.movenext

		' Org Policy Eligibilty rule subprocedure should only be run once
		
		If subName = "SUB_EnterOrgPolicy_EligRule" Then
		   Exit For
		End If
		
	Next

	rs8.close
	Set rs8=nothing
	
	sub_rs.close
	Set sub_rs = nothing

	If args = "EXIT" Then
		ExitAction
	End If
End Function

'***************************************************************
' Function: ConfigurationUtility_RunSub(stepNum, stepName, page, object, expected, args)
' Date Created: 10/24/2007
' Date Modifed: 10/24/2007
' Created By: Jason Craig
' Description:  Executes a given Subprocedure
'***************************************************************   
Function ConfigurationUtility_RunSub(stepNum, stepName, expectedResult, page, object, expected, args)

   ' Exit Subprocedure if there is no data for Provider Details

	If args = "CHECKDETAILS" Then

		' Get the Address Effective Date passed in from the Expected Results parameter

		If expected <> "" Then
			myArray = split(mid(expected,1,(len(expected)-1)), "^")
		End If

		For y = 1 to UBound(myArray)
			If instr(1,myArray(y),"DATE[") Then
				addrEffDate = getFields(1,myArray(y),"[")
				addrEffDate = mid(addrEffDate,1,len(addrEffDate)-1)
				Exit for
			End If
		Next

		If addrEffDate = ""  Then
			Exit function
		End If
		
   End If

   ' Exit Subprocedure if no Provider Carrier-Program Plan Relationship data
   
	If args = "CHECKPLAN" Then

		' Get the Carrier passed in from the Expected Results parameter

		If expected <> "" Then
			myArray = split(mid(expected,1,(len(expected)-1)), "^")
		End If

		For y = 1 to UBound(myArray)
			If instr(1,myArray(y),"CARRIER1[") Then
				carrier = getFields(1,myArray(y),"[")
				carrier = mid(carrier,1,len(carrier)-1)
				Exit for
			End If
		Next

		If carrier = ""  Then
			Exit function
		End if

   End If

   ' Exit Subprocedure if there is no Provider Contract data

   If args = "CHECKCONTRACT" Then

		' Get the Contract passed in from Expected Results parameter
		
		If expected <> "" Then
			myArray = split(mid(expected,1,(len(expected)-1)), "^")
		End If

		For y = 1 to UBound(myArray)
			If instr(1,myArray(y),"CONTRACT[") Then
				contract = getFields(1,myArray(y),"[")
				contract = mid(contract,1,len(contract)-1)
				Exit for
			End If
		Next

		If contract = ""  Then
			Exit function
		End If
		
   End If

   ' Exit Suprocedure if there is no Provider Specialty data or if Specialty has already been added

	If args = "CHECKSPECIALTY" Then

		'Get the Specialty description passed in from Expected Results parameter
		
		If expected <> "" Then
			myArray = split(mid(expected,1,(len(expected)-1)), "^")
		End If
		
		For y = 1 to UBound(myArray)
			If instr(1,myArray(y),"PROVIDER_SPECIALTY[") Then
				specialty = getFields(1,myArray(y),"[")
				specialty = mid(specialty,1,len(specialty)-1)
				Exit for
			End If
		Next

		' Exit if specialty already added
		
		If Browser("Provider Module").Page("Provider Module").Frame("Specialty").WebElement("innerText:="&specialty).exist Then
			' TODO:
			' add code for SQL Call and verifyResult for specialty added to the DB.
			Exit Function
		End If
		
	End If

	' Exit subprocedure if Provider Specialty is not required

	If args = "CHECKSPECIALTYREQUIRED" Then

		' The frame NewProvider4 occurs when a specialty is required; if QNXT skipped NewProvider4 and is on NewProvider5 instead,
		' then the specialty was not required.
		
		If Browser("Provider Module").Page("Provider Module").Frame("NewProvider5").WebElement("innertext:=5","class:=activestep").Exist Then
			Exit Function
		End If
		
	End If

	' Retrieve and open the Subprocedure

	Dim temp, varArray
	db="DRIVER={Microsoft Access Driver (*.mdb)};DBQ=" &Environment("runControlFile") 
	Set sub_rs = Createobject("ADODB.RecordSet")

	sub_sqlquery = "Select * from " &object &" order by STEP"
	sub_rs.Open sub_sqlquery, db, 3, 4, 1

	Reporter.ReportEvent micDone, object, "Executing"

	' Put variables into an array

	If expected <> "" Then
		varArray = split(mid(expected,1,(len(expected)-1)), "^")
	End If

	sub_rs.MoveFirst
	For x =1 to sub_rs.recordcount

		temp = ""
		If expected <> "" Then

			 ' Convert Gender value for Members in data set to QNXT value
			 
			If expected3 = "value:=~Gender~" Then
				temp = getfields(1,expected3,"~")
				If isnull(rs8(temp).value)  then
					expected3 = "value:=rdoGenderUnknown"
				else
					expected3 = Replace(expected3, "~" &temp &"~", cstr(rs8(temp).value))
					If expected3 = "value:=M" Then
						expected3 = "value:=rdoGenderMale"
					elseif expected3 = "value:=F" then
						expected3 = "value:=rdoGenderFemale"
					else
						expected3 = "value:=rdoGenderUnknown"
					End If
				End If
			End If

			' Replace Subprocedure variable with data set value

			temp3=sub_rs("EXPECTED_RESULTS")
			For y = 1 to UBound(varArray)
				If instr(1,sub_rs("EXPECTED_RESULTS")&"[",getFields(0,mid(varArray(y),1),"[")&"[") Then
					temp = getFields(1,varArray(y),"[")
					temp = mid(temp,1,len(temp)-1)
					temp = rtrim(temp)
					temp3 = replace (temp3, getfields(0,vararray(y),"["),temp)
				End If
			Next
			
		End If

		' Replace Subprocedure variable with data set value

		If temp3 = sub_rs("EXPECTED_RESULTS") Then
			 For y = 1 to UBound(varArray)
				If instr(1,sub_rs("EXPECTED_RESULTS"),getFields(0,mid(varArray(y),1),"[")) Then
					 temp = getFields(1,varArray(y),"[")
					temp = mid(temp,1,len(temp)-1)
					temp3 = replace (temp3, getfields(0,vararray(y),"["),temp)
				End If
			Next
		End If

		' Convert Gender value for Members in data set to QNXT value
		
		If sub_rs("OBJECT") = "Gender" Then
			If temp3 = "M" or temp3 = "Male" Then
				temp3 =	"value:=rdoGenderMale"
			elseif temp3 = "F" or temp3 = "Female" then
				temp3 = "value:=rdoGenderFemale"
			else
				temp3 = "value:=rdoGenderUnknown"
			End If
		End If
		
		temp = temp3

		If temp = "" Then
			temp = sub_rs("EXPECTED_RESULTS")
		End If

		If x = 15 Then
			x=x
		End If

        temp = ReplaceSQLReference(temp)

		' Execute Function Call

		FunctionCall = "Call " &sub_rs("OBJECT_TYPE") &"_" &sub_rs("ACTION") &"(""" &stepNum &"." &sub_rs("STEP") &""",""" &sub_rs("DESCRIPTION")&""","""&sub_rs("PAGE") &""",""" &sub_rs("OBJECT") &""",""" &temp &""",""" &ucase(sub_rs("ARGUMENTS")) &""")"
		If instr(sub_rs("DESCRIPTION"),"///") = 0 Then
			Execute (FunctionCall)
		end if 
		sub_rs.movenext
	Next
	
	sub_rs.close
	Set sub_rs = nothing
	
	If object = "SUB_EnterFamily" Then
		Environment("RunTimeError") = "No"
		ExitAction
	End If
	
End Function

'***************************************************************
' Function: ConfigurationUtility_Select (stepNum, stepName, page, object, sValue, args)
' Date Created: 1/25/2006
' Date Modifed: 1/25/2006
' Created By: Chris Thompson & Steve Truong
' Description:  Select keyword for the WebCheckBox type object
'***************************************************************

Function ConfigurationUtility_SelectCheckBox (stepNum, stepName, expectedResult, page, object, expected, args)

	'Declare Variables
	
	Dim prop, logObject, logDetails
	Dim desc(2)

	If Instr(object,"Elegible") <> 0 Then
		If expected = 1  Then
			expected = "ON"
		else
			expected = "OFF"
		End If
	End If
	
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

				' No argurment

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

				' Case for selecting a checkbox in a table based on value of column to directly to the right of the webcheckbox on the same row

				Case "SPLIT"

					'Selects the Checkbox  with a description in a Column  that matches the sValue 
					'takes WebTable Object
					'tester must chose "ON" or "OFF"

					sValue = getFields(0, expected, "~") 'WebCheckbox Description
					expected = getFields(1, expected, "~") 'checked property (ON or OFF)
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
								Loop until z = ubound(arrProp)
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
						Do
							Allitems = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x,y)
							If instr (1, Allitems, sValue) > 0 Then
								Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x ,1, "WebCheckBox", 0).Set expected
								actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x , 1, "WebCheckBox", 0).GetROProperty("checked")
								Exit Do
							End If
							x = x + 1
						Loop until instr(Allitems, "ERROR") = 1

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

				Case "ONERROR"
					If InStr(desc(0), ":=") Then
						Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0), desc(1),desc(2)).Set expected
						If Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0), desc(1),desc(2)).Exist = false Then
							Exit Function
						End If
						actual = Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0), desc(1),desc(2)).GetROProperty("checked")
					Else
						Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0)).Set expected
						If Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0)).Exist = false Then
							Exit Function
						End If
						actual = Browser(browserObj).Page(page).Frame(frameObj).WebCheckBox(desc(0)).GetROProperty("checked")
					End If	

				' Case for selecting a checkbox in a web table based on the next two columns on the same row to the right of the checkbox

				Case "SPLIT2"
					'Selects the Checkbox  with a description in Column 2 that matches the sValue 
					'takes WebTable Object
					'tester must chose "ON" or "OFF"

					sValue1 = getFields(0, expected, "~") 'WebCheckbox Description
					sValue2 = getFields(1, expected, "~")
					expected = getFields(2, expected, "~") 'checked property (ON or OFF)
					x = 1  'Row
					y = 2  'Column 1

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
								Loop until z = ubound(arrProp)
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

				If instr (expected, "~") Then
				
					sValue = getFields(0, expected, "~") 'WebCheckbox Description
					expected = getFields(1, expected, "~") 'checked property (ON or OFF)

			Elseif instr(expected, "=" )then

					 sValue = getFields(0, expected, "=") 'WebCheckbox Description
					expected = getFields(1, expected, "=") 'checked property (ON or OFF)
			
			end if
				x = 1  'Row
				y = 2  'Column
				If Instr(sValue,",") <> 0 Then
					temp = sValue
					y = getFields(0, temp, ",") 'WebCheckbox Description
					sValue = getFields(1, temp, ",")
				End If

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
							Loop until z = ubound(arrProp)
						End If
						x = x + 1
						Loop until instr(Allitems, "ERROR") = 1
					'End same row same column
						
				ElseIf Instr(desc(0), ":=") Then
					Do
						Allitems = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1), desc(2)).GetCellData(x,y)
						If instr (1, Allitems, sValue) > 0 Then
							Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1),desc(2)).ChildItem(x , 1, "WebCheckBox", 0).Set expected
							actual = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0), desc(1),desc(2)).ChildItem(x , 1, "WebCheckBox", 0).GetROProperty("checked")
						Exit Do
						End If
						x = x + 1
					Loop until instr(Allitems, "ERROR") = 1
				Else
					Do
					Allitems = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).GetCellData(x, y)

						If instr (1, Allitems, sValue) > 0 Then
							Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x ,1, "WebCheckBox", 0).Set expected
							actual = Browser(browserObj).Page(page).Frame(frameObj).WebTable(desc(0)).ChildItem(x ,1, "WebCheckBox", 0).GetROProperty("checked")
						Exit Do
						End If
						x = x + 1
					Loop until instr(Allitems, "ERROR") = 1
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
	Else
		 result =  verificationPoint("0", actual, logObject, logDetails, browserObj, expectedResult )
	End If
			
End Function

'***************************************************************
' Function: ConfigurationUtility_SelectRadio(stepNum, stepName, page, object, expected, args)
' Date Created: 9/26/2008
' Date Modifed: 9/26/2008
' Created By: Chris Thompson
' Description:  Selects a radio button inside a table
'***************************************************************
Function ConfigurationUtility_SelectRadio (stepNum, stepName, expectedResult, page, object, expected, args)

   'If expected is an empty string, just exit function
   
   If expected = "" Then
	   Exit Function
   End If

   ' Parse Page Objects

	browserObj = getFields(0,page , "-")
	windowObj = getfieldsUpperNull(3,page , "-")
	frameObj=getfieldsUpperNull(2,page,"-")
	fullPage = page
	page = getFields(1,page , "-")

	' Exit the function if Subscriber checkbox not found

	If object = "Subscribers~Subscriber" Then
	   If windowObj <> "" Then
		   If Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebRadioGroup("Subscriber").Exist = false then
			   Exit Function
			End If
		else
			If Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup("Subscriber").Exist = false Then
				Exit Function
			End If
	   End If
   End If

   ' Exit the function if Provider by Affiliation or Pay to Provider Page does not exist

   If fullPage = "Claims Module-Provider-Provider-Provider by Aff" or fullPage = "Claims Module-Pay To Aff-Pay To Aff-Pay To Aff" Then
	   If Browser(browserObj).Window(windowObj).Exist = false Then
		   Exit Function
	   End If
   End If


	prop=getFields(0, expected, ":=")
	expected=getFields(1, expected, ":=")
	expected = replaceConstants(expected)

	y = getFields(2, object, "~")
	If Len(y)>=4 Then
		y = 0
	End If
	object2 = getFields(1, object, "~")
	object = getFields(0, object, "~")

	Select Case UCase(args)

		Case "SPLIT"

		'Selects the radio button with an index that matches the WebTable Description Index
		If object2 = "Age Change Rules" OR object2 = "Initial Age Calculation" Then
			y = 1
			If instr(expected, "Sponsor") Then
				object2 = "Subscriber Anniversary"
				object = object2
			End If
		ElseIf y = object2 Then
			y = 2
		End If
		
		If windowObj <> "" Then

			Allitems = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebRadioGroup(object2).GetROProperty("all items")
			arrAllitems = Split(Allitems, ";")
			Do
				x = x + 1
				sValue = Browser(browserObj).Window(windowObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x, y)
				If instr(1, expected, "SQL") Then
					expected = Environment("SQLResults")
				End If
				If trim(sValue) = expected Then
					Exit Do
				End If
			Loop until instr(sValue, "ERROR") = 1
				
				Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebRadioGroup(object2).Select arrAllitems(x - 1)
				'actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebRadioGroup(object2).GetROProperty("value")
					
		Else
	
			Allitems = Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(object2).GetROProperty("all items")
			arrAllitems = Split(Allitems, ";")
			z = 0
				
			Do
				x = x + 1
				y= CInt(y)
				If Browser(browserObj).Page(page).Frame(frameobj).webtable(object).Exist(10) Then
					sValue = Browser(browserObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,y)
				ElseIf Browser(browserObj).Page(page).Frame(frameobj).WbfGrid(object).Exist(10) Then
					sValue = Browser(browserObj).Page(page).Frame(frameobj).WbfGrid(object).GetCellData(x,y)
				End If

				
				If instr(sValue, "ERROR") Then
					If object2 = "Contract" Then
						If Browser(browserObj).Page(page).Frame(frameobj).Link("Contracts Page 2").Exist Then
							Browser(browserObj).Page(page).Frame(frameobj).Link("Contracts Page 2").Click
							Allitems = Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(object2).GetROProperty("all items")
							arrAllitems = Split(Allitems, ";")
							x = 1
							z = 0
'							 sValue = Browser(browserObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,y)
							 sValue = Browser(browserObj).Page(page).Frame(frameobj).WbfGrid(object).GetCellData(x,y)
						End If
					End If
				End If

				If instr(1, expected, "policyvariabledefid") Then
					expected = replaceSQLReference(expected)
				End If
				If instr(1, expected, "SQL") Then
					expected = Environment("SQLResults")
				End If
				'For Data Entry Script (DataEntry_OrgPolicy
				If object2 = "Policy Variable" Then
					sValue = arrAllitems(z)
				End If
				If instr(1, sValue, expected) Then
					Exit do
				End If		
				z = z + 1
			Loop until instr(sValue, "ERROR") = 1


				'For Data Entry script
				If object2 = "Contract" Then
					wait 1
					If instr(sValue, "ERROR") Then
						Environment("RunComments") = "ERROR: Affiliation Exists, Contract not found"
						Environment("RunTimeError") = "Yes"
						ExitAction
					else
					   Browser(browserObj).Page(page).Frame(frameobj).WebRadioGroup("name:=QMXCT.*", "html tag:=INPUT", "index:="&x-1).click
					End If
				Else
					If arrAllitems(x-1) = "on" Then
						Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(object2).Select "#"&x-1'
					Else
						Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(object2).Select arrAllitems(x - 1)
						'actual = Browser(browserObj).Window(windowObj).Page(page).Frame(frameObj).WebRadioGroup(object2).GetROProperty("value")
					End If				
				End If


					
				
		End If
	
	Case Else
  
  Do 
	x = x + 1
	y=CInt(y)

	If Browser(browserObj).Page(page).Frame(frameobj).WbfGrid(object).Exist(10) Then
		sValue = Browser(browserObj).Page(page).Frame(frameobj).WbfGrid(object).GetCellData(x,y)
	ElseIf Browser(browserObj).Page(page).Frame(frameobj).webtable(object).Exist(10) Then
		sValue = Browser(browserObj).Page(page).Frame(frameobj).webtable(object).GetCellData(x,y)
	End If

   If trim(svalue) = expected Then
	Exit do
   End If
	
	
	loop until instr(svalue, "ERROR") = 1


	If object = "Affiliates" Then
    object2=replace(object2,"##",cstr(x))
'    object2=replace(object2,"##",cstr(x+2))
	Else
	object2=replace(object2,"##",cstr(x+1))
    End if
	
	
	result = Browser(browserObj).Page(page).Frame(frameobj).WebRadioGroup("name:=" & object2,"html tag:=INPUT").click

	End Select
	
	logObject = "Step: " &stepNum &"  -  "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	logDetails= "Expected:  " &expected &CHR(13)	  
	logDetails = logDetails & " Actual: True"
	result = verificationPoint(True, True, logObject, logDetails, browserObj, expectedResult)

'Browser("Provider Module").Page("Provider Module").Frame("NewProvider3").WebRadioGroup("dgSelectTitle:_ctl8:rdoSelect").Select "0~56   
   End Function
   
'***************************************************************
' Function: ConfigurationUtility_SelectRow(stepNum, stepName, page, object, expected, args)
' Date Created: 8/24/2009
' Date Modifed: 8/24/2009
' Created By: Chris Thompson
' Description:  Selects a radio button within a row based on the entire row's data
'***************************************************************

Function ConfigurationUtility_SelectRow (stepNum, stepName, expectedResult, page, object, expected, args)

	browserObj = getFields(0,page , "-")
	windowObj = getFieldsUpperNull(3,page, "-")
	frameObj=getfieldsUpperNull(2,page,"-")
    page = getFields(1,page , "-")
	object2 = getFields(1, object, "~")
	object = getFields(0, object, "~")

'Parse Object Description

   
	expected = replaceSQLReference(expected)   'This was entered to handle multiple instances of SQL calls within a VerifyTableRow (probably can expand to loop and replace all SQL calls or simply add this line again to verify 3 SQL calls etc.)  Jason - 3/30/2009
	expected = replaceSQLReference(expected)
	expected = replaceSQLReference(expected)
	expected = replaceSQLReference(expected)
	expected = replaceSQLReference(expected)
	
	Select Case UCase(args)

	Case "SPLIT"

		Allitems = Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(object2).GetROProperty("all items")
			arrAllitems = Split(Allitems, ";")
			
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

		
		'Verify Datestamps
		 If trim(ExpectArray(y-1)) = "Environment('Datestamp')" Then
		ExpectArray(y-1) = environment("Datestamp")
	Elseif instr (ExpectArray(y-1),"Environment('Datestamp')<") Then
		ExpectArray(y-1) = getfields(2,ExpectArray(y-1),"<")
		   ExpectArray(y-1)  = mid(ExpectArray(y-1) ,1,len(ExpectArray(y-1) )-1)
		Call Utility_GenDatestamp(stepNum, stepName,expectedResult, page, object,ExpectArray(y-1), "Run Time")  
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
			Browser(browserObj).Page(page).Frame(frameObj).WebRadioGroup(object2).Select arrAllitems(x - 1)
			Exit Do
		End If
		
		If y = (ubound(ExpectArray)+1) Then
			Exit For
		End If
		
		next
		
		loop

	End Select

		logObject = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object

		If sFail = True Then
		logDetails= "Expected: " &expected &CHR(13) & "Actual: " &"This row does not exist in the table. Compare the expected results to the table."
		Else
		logDetails= "Expected: " &expected &CHR(13) & "Actual: " &"The row was found"
		End If

 result = verificationPoint("False", sFail, logObject, logDetails, browserObj, expectedResult)	
 

End Function
