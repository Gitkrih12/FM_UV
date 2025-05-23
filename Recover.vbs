'***************************************************************
' Function: RecoverFunction1
' Date Created: 5/7/2009
' Date Modifed: 5/7/2009
' Created By: Jason Craig
' Description:  Calls SUB when Member already exists
'***************************************************************
Function RecoveryFunction1(Object)

			Reporter.ReportEvent micFail, "Member Already Exists", "Launch Recovery"
			db="DRIVER={Microsoft Access Driver (*.mdb)};DBQ=" &Environment("runControlFile") 
			Set sub_rs = Createobject("ADODB.RecordSet")

			sub_sqlquery = "Select * from SUB_Member_Recover order by STEP"
			sub_rs.Open sub_sqlquery, db, 3, 4, 1

			sub_rs.MoveFirst
			For x =1 to sub_rs.recordcount

			FunctionCall = "Call " &sub_rs("OBJECT_TYPE") &"_" &sub_rs("ACTION") &"(""" &stepNum &"." &sub_rs("STEP") &""",""" &sub_rs("DESCRIPTION")&""","""&sub_rs("EXPECTED RESULT")&""","""&sub_rs("PAGE") &""",""" &sub_rs("OBJECT") &""",""" &sub_rs("EXPECTED_RESULTS") &""",""" &ucase(sub_rs("ARGUMENTS")) &""")"
		   
			
			If instr(sub_rs("DESCRIPTION"),"///") = 0 Then
				Execute (FunctionCall)
			end if 
			sub_rs.movenext
			Next
	
			sub_rs.close
			Set sub_rs = nothing
			
End Function 
 
'***************************************************************
' Function: RecoverFunction2
' Date Created: 5/7/2009
' Date Modifed: 5/7/2009
' Created By: Jason Craig
' Description:  Calls SUB when Provider already exists
'***************************************************************
 
Function RecoveryFunction2(Object)

			Reporter.ReportEvent micFail, "Provider Already Exists", "Launch Recovery"
			db="DRIVER={Microsoft Access Driver (*.mdb)};DBQ=" &Environment("runControlFile") 
			Set sub_rs = Createobject("ADODB.RecordSet")

			sub_sqlquery = "Select * from SUB_Provider_Recover order by STEP"
			sub_rs.Open sub_sqlquery, db, 3, 4, 1

			sub_rs.MoveFirst
			For x =1 to sub_rs.recordcount

			FunctionCall = "Call " &sub_rs("OBJECT_TYPE") &"_" &sub_rs("ACTION") &"(""" &stepNum &"." &sub_rs("STEP") &""",""" &sub_rs("DESCRIPTION")&""","""&sub_rs("EXPECTED RESULT")&""","""&sub_rs("PAGE") &""",""" &sub_rs("OBJECT") &""",""" &sub_rs("EXPECTED_RESULTS") &""",""" &ucase(sub_rs("ARGUMENTS")) &""")"
		   
			
			If instr(sub_rs("DESCRIPTION"),"///") = 0 Then
				Execute (FunctionCall)
			end if 
			sub_rs.movenext
			Next
	
			sub_rs.close
			Set sub_rs = nothing
			
End Function 
 

 '***************************************************************
' Function: RecoverMethod
' Date Created: 6/30/2021
' Date Modifed: 6/30/2021
' Created By: Sameen Hashmi
' Description:  Function to recover the application in case of failure
'***************************************************************

Sub recoveryMethod(processName)
	
	' Take application screenshot
	stepNum = Mid(Environment("FunctionCall"), Instr(Environment("FunctionCall"),"(")+2, Instr(Environment("FunctionCall"),",")-Instr(Environment("FunctionCall"),"(")-3)
	restOfCall = Mid(Environment("FunctionCall"), Instr(Environment("FunctionCall"),",")+2)
	stepName = Mid(restOfCall, 1, Instr(restOfCall,",")-2)
	fromExpectedResult = Mid(restOfCall, Instr(restOfCall,",")+2)
	expectedRes = Mid(fromExpectedResult, 1, Instr(fromExpectedResult,",")-2)
	If expectedRes = "" Then
		expectedRes = "The action should be performed"
	End If
	info = "Step: " &stepNum &" - "&stepName&CHR(13)& "Page: Object: "
	stepName = Mid(info,Instr(1,info,"Step:")+6,Instr(1,info," - ")-Instr(1,info,"Step:")-6)
	testDescription = Mid(info,Instr(1,info," - ")+3,Instr(1,info,"Page:")-Instr(1,info," - ")-3)
	
	Environment("TestPassed") = False
	Desktop.CaptureBitmap Environment("ProjectNamePath")&"\"&"Results"&"\"&Environment("currentResFolderName")&"\Screenshots\"&"Test_"&currentDateTime & ".png",True
	Environment("RunResults") = Environment("RunResults") & "<tr><td>"&stepName&"</td><td>"&testDescription&"</td><td>"&expectedRes&"</td><td>"&"The result is not as expected."&Replace(Err.Description,"""","'")&"</td><td><a style="&Chr(34)&"color:Red"&Chr(34)&" href="&Chr(34)&Environment("ProjectNamePath")&"\"&"Results"&"\"&Environment("currentResFolderName")&"\Screenshots\"&"Test_"&currentDateTime & ".png"&Chr(34)&">Failed</a></td></tr>"
	Err.Clear

	
	' Kill the browser object
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	Set processList = objWMIService.ExecQuery("Select * From Win32_Process Where Name = '" & processName & "'")
	
	For each objProcess in processList
		objProcess.Terminate()
	Next
	
	Set processList = Nothing
	Set objWMIService = Nothing
	
End Sub
