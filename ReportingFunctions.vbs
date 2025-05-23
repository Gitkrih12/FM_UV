
'***************************************************************
' Function: verifyResults(status, capture, info, details)
' Date Created: 12/22/2020
' Date Modifed: 12/22/2020
' Created By:  Sameen Hashmi
' Description:  Writes pass/fail results to the log.
'***************************************************************

Sub verifyResultsInALM(browserObj, stepName, status, testDescription, expectedResult, actualResult)
	
	scriptName = Mid(Environment("RunTest"),3)
	' Connect to ALM
	Set almConn = QCUtil.QCConnection	
'	Set testRun = QCUtil.CurrentRun	
	Set currentTestSet = QCUtil.CurrentTestSet
	Set ts = currentTestSet.TSTestFactory.NewList("")
	For each testCase in ts
		If Instr(testCase.Name,scriptName)<>0 Then
			Set newRun = testCase.RunFactory.NewList("")
			newRunKey = newRun.Count
			Set testRun = newRun.Item(newRunKey)
			
			Exit For
		End If				
	Next
	
	Set testStepFactory = testRun.StepFactory
	Set tStep = testStepFactory.AddItem("Step " & stepName)
	Set testStepList = testStepFactory.NewList("")
	testStepKey = testStepList.Count
	
	testStepList.Item(testStepKey).Field("ST_STATUS") = status
	testStepList.Item(testStepKey).Field("ST_DESCRIPTION") = testDescription
	testStepList.Item(testStepKey).Field("ST_EXPECTED") = expectedResult
	testStepList.Item(testStepKey).Field("ST_ACTUAL") = actualResult
	testStepList.Item(testStepKey).Field("ST_ATTACHMENT") = "Y"
	testStepList.Item(testStepKey).status = status
	testStepList.Post
	
	'Get current timestamp
	currentTime = Now()
	currentDateTime = Year(currentTime) & Month(currentTime) & Day(currentTime) & "_" & Hour(currentTime) & Minute (currentTime) & Second(currentTime)
		
	'	Çapture screenshot
	If Environment("IsWinForm") Then
		If Window(browserObj).Exist Then
			Window(browserObj).CaptureBitmap Environment("SystemTempDir") & "\Test_" & currentDateTime & ".png",True
		Else
			Desktop.CaptureBitmap Environment("SystemTempDir") & "\Test_" & currentDateTime & ".png",True
		End If
	ElseIf Environment("IsWpf") Then
		If WpfWindow(browserObj).Exist Then
			WpfWindow(browserObj).CaptureBitmap Environment("SystemTempDir") & "\Test_" & currentDateTime & ".png",True
		Else
			Desktop.CaptureBitmap Environment("SystemTempDir") & "\Test_" & currentDateTime & ".png",True
		End If
	ElseIf Environment("IsSwf") Then
		If SwfWindow(browserObj).Exist Then
			SwfWindow(browserObj).CaptureBitmap Environment("SystemTempDir") & "\Test_" & currentDateTime & ".png",True
		Else
			Desktop.CaptureBitmap Environment("SystemTempDir") & "\Test_" & currentDateTime & ".png",True
		End If
	Else
		If Browser(browserObj).Exist Then
			Browser(browserObj).CaptureBitmap Environment("SystemTempDir") & "\Test_" & currentDateTime & ".png",True
		Else
			Desktop.CaptureBitmap Environment("SystemTempDir") & "\Test_" & currentDateTime & ".png",True
		End If
	End If
	
	Set attachmentFactory = testStepList.Item(testStepKey).Attachments
	Set attachObj = attachmentFactory.AddItem(Null)
	attachObj.FileName = Environment("SystemTempDir") & "\Test_" & currentDateTime & ".png"
	attachObj.Type = 1
	attachObj.Post
	
	tStep.Post
	
	If Environment("TestPassed") Then
		testRun.Status = "Passed"
	Else
		testRun.Status = "Failed"
	End If
	testRun.Post

	Set fs = CreateObject("Scripting.FileSystemObject")
	fs.DeleteFile Environment("SystemTempDir") & "\Test_" & currentDateTime & ".png"
	Set fs = Nothing
		
	Set attachObj = Nothing
	Set attachmentFactory = Nothing
	Set testStepList = Nothing
	Set testStepFactory = Nothing
	Set testRun = Nothing
	Set newRun = Nothing
	Set almConn = Nothing
	
End Sub

'***************************************************************


'***************************************************************
' Function: verifyResults(status, capture, info, details)
' Date Created: 12/22/2020
' Date Modifed: 12/22/2020
' Created By:  Sameen Hashmi
' Description:  Writes pass/fail results to the log.
'***************************************************************

Function connectToALM()
	
	' Connect to ALM
	Set almConn = QCUtil.QCConnection	
	Set testRun = QCUtil.CurrentRun
	Set testStepFactory = testRun.StepFactory
	
	connectToALM = testStepFactory
	
End Function

'***************************************************************


'***************************************************************
' Function: verifyResults(status, capture, info, details)
' Date Created: 12/22/2020
' Date Modifed: 12/22/2020
' Created By:  Sameen Hashmi
' Description:  Writes pass/fail results to the log.
'***************************************************************

Sub verifyResultsInALM_New(browserObj, stepName, status, testDescription, expectedResult, actualResult)
	
	testStepFactoryObj.AddItem("Step " & stepName)
	Set testStepList = testStepFactory.NewList("")
	testStepKey = testStepList.Count
	
	testStepList.Item(testStepKey).Field("ST_STATUS") = status
	testStepList.Item(testStepKey).Field("ST_DESCRIPTION") = testDescription
	testStepList.Item(testStepKey).Field("ST_EXPECTED") = expectedResult
	testStepList.Item(testStepKey).Field("ST_ACTUAL") = actualResult
	testStepList.Item(testStepKey).Field("ST_ATTACHMENT") = "Y"
	testStepList.Post
	
	'Get current timestamp
	currentTime = Now()
	currentDateTime = Year(currentTime) & Month(currentTime) & Day(currentTime) & "_" & Hour(currentTime) & Minute (currentTime) & Second(currentTime)
		
	'	Çapture screenshot
	Browser(browserObj).CaptureBitmap Environment("FilePath") & "Test_" & currentDateTime & ".png",True
		
	Set attachmentFactory = testStepList.Item(testStepKey).attachments
	Set attachObj = attachmentFactory.AddItem(Null)
	attachObj.FileName = Environment("FilePath") & "Test_" & currentDateTime & ".png"
	attachObj.Type = 1
	attachObj.Post
		
	Set fs = CreateObject("Scripting.FileSystemObject")
	fs.DeleteFile Environment("FilePath") & "Test_" & currentDateTime & ".png"
	Set fs = Nothing
		
	Set attachObj = Nothing
	Set attachmentFactory = Nothing
	Set testStepList = Nothing
	Set testStepFactory = Nothing
	Set almConn = Nothing
	
End Sub

'***************************************************************


'***************************************************************
' Function: verifyResults(status, capture, info, details)
' Date Created: 12/22/2020
' Date Modifed: 12/22/2020
' Created By:  Sameen Hashmi
' Description:  Writes pass/fail results to the log.
'***************************************************************

Sub disConnectALM(browserObj, stepName, status, testDescription, expectedResult, actualResult)
		
	Set testStepList = Nothing
	Set testStepFactory = Nothing
	Set almConn = Nothing
	
End Sub

'***************************************************************
