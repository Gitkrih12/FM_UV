
'***************************************************************
' Function: Windows_Open()
' Date Created: 05/27/2023
' Created By: Raghunath Konda
' Description: Opens Windows application
'***************************************************************   

Public Function Windows_Open(stepNum, stepName, expectedResult, page, object, expected, args)

	If Instr(expected,"URL") <> 0 Then
		db="DRIVER={Microsoft Access Driver (*.mdb)};DBQ=" &Environment("runControlFile") 
		Set sub_rs = Createobject("ADODB.RecordSet")
		sqlqueryGlobal = "Select * from CONSTANTS where CONSTANT ='"&expected&"'"
		sub_rs.Open sqlqueryGlobal, db, 1, 3
		appUrl= sub_rs("VALUE").value
		sub_rs.close
	Else
		appUrl= expected
	End If
	
	windowObj = getFields(0,page , "-")
	
	strAppName = Mid(appUrl, InStrRev(appUrl, "\") + 1)
	
	appCount = 0
	strComputer = "."
    Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
    Set colProcessList = objWMIService.ExecQuery ("Select * from Win32_Process Where Name = '"&strAppName&"'")
    For Each objProcess in colProcessList
        appCount = appCount + 1        
    Next

	If appCount = 0 Then
		If Instr(expected,"URL") <> 0 Then
			path = Split(appUrl, strAppName)
			StrApppath = Path(0)
			
			Systemutil.Run strAppName,,StrApppath
		Else
			SystemUtil.Run expected
		End If
		Wait 5
		
		Set colProcessList = objWMIService.ExecQuery ("Select * from Win32_Process Where Name = '"&strAppName&"'")
	    For Each objProcess in colProcessList
	        actual = True      
	    Next
		
		'Set up log results
		Dim logObject, logDetails
	     logObject = "Step: " &stepNum &"  -  "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	     logDetails= "Expected:  " &expected &CHR(13)
		logDetails = logDetails & " Actual: " &actual  
		result = verificationPoint(True, actual, logObject, logDetails, windowObj, expectedResult)
	End If

End Function

Public Function Windows_Close(stepNum, stepName, expectedResult, page, object, expected, args)

	windowObj = getFields(0,page , "-")
		
		Window(windowObj).Close
		Wait 30
		actual = Window(windowObj).Exist(5)
		Dim logObject, logDetails
	     logObject = "Step: " &stepNum &"  -  "&stepName&CHR(13)& "Page: " &page &CHR(13) &" Object: " &object
	     logDetails= "Expected:  " &expected &CHR(13)
		logDetails = logDetails & " Actual: " &actual  
		result = verificationPoint(False, actual, logObject, logDetails, windowObj, expectedResult)
		
End Function

	
	
