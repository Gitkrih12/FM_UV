'***************************************************************
'File Name: Keyword_Subprocedure.vbs
'Date Ceated: 10/24/2007
'Created By:  Jason Craig
'Description: Library contains all keyword functions for the Subprocedure functionality
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
' Function: SubProcedure_RunSub(stepNum, stepName, page, object, expected, args)
' Date Created: 10/24/2007
' Date Modifed: 10/24/2007
' Created By: Jason Craig
' Description:  Executes a given Subprocedure
'***************************************************************   

Function SubProcedure_RunSub(stepNum, stepName, expectedResult, page, object, expected, args)

	Dim temp, varArray
	db="DRIVER={Microsoft Access Driver (*.mdb)};DBQ=" &Environment("runControlFile") 
	Set sub_rs = Createobject("ADODB.RecordSet")
	
	If args <> "" Then
		If args = "UAT" Then
			sqlqueryGlobal = "Select * from CONSTANTS where CONSTANT ='Login_URL_UAT'"
		ElseIf args = "MA" Then
			sqlqueryGlobal = "Select * from CONSTANTS where CONSTANT ='Login_URL_MA'"
		ElseIf args = "ERW" Then
			sqlqueryGlobal = "Select * from CONSTANTS where CONSTANT ='Login_URL_ERW'"
		ElseIf args = "SESWeb" Then
			sqlqueryGlobal = "Select * from CONSTANTS where CONSTANT ='SESWeb_URL'"
		ElseIf args = "ReadyToPaySSRS" Then
			sqlqueryGlobal = "Select * from CONSTANTS where CONSTANT ='Login_SSRS'"
		End If
	
		sub_rs.Open sqlqueryGlobal, db, 1, 3
		Environment("RunEnvironment")= sub_rs("VALUE").value
		sub_rs.close
	End If
	

	sub_sqlquery = "Select * from " &object &" order by STEP"
	sub_rs.Open sub_sqlquery, db, 3, 4, 1


	If expected <> "" Then
		varArray = split(mid(expected,1,(len(expected)-1)), "^")
	End If

	sub_rs.MoveFirst
	For x =1 to sub_rs.recordcount
		temp = ""
		If expected <> "" Then
		
		For y = 1 to UBound(varArray)
			If instr(1,sub_rs("EXPECTED_RESULTS"),getFields(0,mid(varArray(y),1),"[")) Then
			    temp = getFields(1,varArray(y),"[")
				temp = mid(temp,1,len(temp)-1)
			End If
		Next
		End If

		If temp = "" Then
			temp = sub_rs("EXPECTED_RESULTS")
		End If

		' Convert Datestamp

		If temp = "Environment('Datestamp')" Then
			temp = environment("Datestamp")
		Elseif instr (temp,"Environment('Datestamp')<") Then
			expected = getfields(2,temp,"<")
			expected = mid(expected,1,len(expected)-1)
			Call Utility_GenDatestamp(stepNum, stepName,expectedResult, page, object, expected, "Run Time")  
			temp = environment("Datestamp")
		Elseif temp = "Environment('sData')" Then
			temp = Environment("sData")
		Elseif temp = "Environment('Timestamp')" Then
			temp = Environment("Timestamp")
		End If

		temp = ReplaceSQLReference(temp)

	   
    
		FunctionCall = "Call " &sub_rs("OBJECT_TYPE") &"_" &sub_rs("ACTION") &"(""" &stepNum &"." &sub_rs("STEP") &""",""" &sub_rs("DESCRIPTION")&""","""&sub_rs("EXPECTED RESULT")&""","""&sub_rs("PAGE") &""",""" &sub_rs("OBJECT") &""",""" &temp &""",""" &sub_rs("ARGUMENTS") &""")"
		If instr(sub_rs("DESCRIPTION"),"///") = 0 Then
			'	Creating a new appHandler object for the test case to execute
			Environment("FunctionCall")	= FunctionCall
			Execute FunctionCall
		end if 
		sub_rs.movenext
	Next
	
	sub_rs.close
	Set sub_rs = nothing

End Function

'***************************************************************
' Function: SubProcedure_RunSub(stepNum, stepName, page, object, expected, args)
' Date Created: 10/24/2007
' Date Modifed: 10/24/2007
' Created By: Jason Craig
' Description:  Executes a given Subprocedure
'***************************************************************   

Function SubProcedure_RunMultipleSub(stepNum, stepName, expectedResult, page, object, expected, args)

	Dim temp, varArray
	db="DRIVER={Microsoft Access Driver (*.mdb)};DBQ=" &Environment("runControlFile") 
	Set sub_rs = Createobject("ADODB.RecordSet")

	sub_sqlquery = "Select * from " &object &" order by STEP"
	sub_rs.Open sub_sqlquery, db, 3, 4, 1

	'Retrieve Data set

	expected2 = expected
	expected = getfields(0,expected,"^")

	prop=getFields(0, expected, ":=")
	field=getFields(1, expected, ":=")
	expected=getFields(2, expected, ":=")


	db4="DRIVER={Microsoft Access Driver (*.mdb)};DBQ=" &Environment("runControlFile") 
	Set rs8 = Createobject("ADODB.RecordSet")
	sqlquery4 = "Select * from " &Prop &" where " &field &" = " &Expected

	rs8.Open sqlquery4, db4, 3, 4, 1

	'Branch for special cases

	If object = "SUB_EnterRule"then
		t=t
	End if

   If expected2 <> "" Then
	   'varArray = split(mid(expected2,1,len(expected2)), "^"
	   varArray = split(mid(expected2,1,(len(expected2)-1)), "^")
   End If

	rs8.movefirst
	For z = 1 to rs8.recordcount

	sub_rs.MoveFirst
	For x =1 to sub_rs.recordcount

		expected3 = sub_rs("EXPECTED_RESULTS")

		 If instr(expected3,"~")  Then
			temp = getfields(1,expected3,"~")
			If isnull(rs8(temp).value)  then
				expected3 = ""
			else
				expected3 = Replace(expected3, "~" &temp &"~", cstr(rs8(temp).value))
			End If
		End If

		If expected3 <> "" Then
		For y = 1 to UBound(varArray)
			If instr(1,sub_rs("EXPECTED_RESULTS"),getFields(0,mid(varArray(y),1),"[")) Then
				temp2 = getFields(0,varArray(y),"[")
			    temp = getFields(1,varArray(y),"[")
				temp = mid(temp,1,len(temp)-1)
				prop2=getFields(0, temp, ":=")
				field2=getFields(1, temp, ":=")
				If instr(field2,"~") Then
					field2 = getfields(1,field2,"~")
					temp = prop2 &":=" &rs8(field2)
				Else
					temp = prop2 &":=" &field2
				End If			   
		
				Select Case object

					Case "SUB_EnterAttribute"
						If temp2 = "GROUP" Then
							temp = replace(temp,"Yes","#3")
						End If
		
				End Select

				
		End If
	Next
	End If

	If temp = "" Then
			temp = sub_rs("EXPECTED_RESULTS")
	End If
	
		If x = 13 Then
			x=x
		End If

		temp = ReplaceSQLReference(temp)	
    
		FunctionCall = "Call " &sub_rs("OBJECT_TYPE") &"_" &sub_rs("ACTION") &"(""" &stepNum &"." &sub_rs("STEP") &""",""" &sub_rs("DESCRIPTION")&""","""&sub_rs("EXPECTED RESULT")&""","""&sub_rs("PAGE") &""",""" &sub_rs("OBJECT") &""",""" &temp &""",""" &ucase(sub_rs("ARGUMENTS")) &""")"
		If instr(sub_rs("DESCRIPTION"),"///") = 0 Then
			'	Creating a new appHandler object for the test case to execute
			Environment("FunctionCall" )= FunctionCall
			Execute FunctionCall
			sub_rs.movenext
			temp = ""
		end if 

	Next

rs8.movenext
Next

	rs8.close
	Set rs8=nothing
	
	sub_rs.close
	Set sub_rs = nothing

End Function
