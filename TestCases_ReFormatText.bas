Attribute VB_Name = "TestCases_ReFormatText"
'$Id$
'
'This module defines test cases that can be run to test if the quotefix macros
'return the expected results.
'
'Required settings:
'USE_COLORIZER unset
'INCLUDE_QUOTES_TO_LEVEL = -1
'LINE_WRAP_AFTER = 75
'
'These test cases are part of the macros4outlook project
'see http://sourceforge.net/projects/macros4outlook/ for more information
'
'For more information on Outlook see http://www.microsoft.com/outlook
'Outlook is (C) by Microsoft

'****************************************************************************
'License:
'
'QuoteFixMacro testcases
'  copyright 2009 Lars Monsees. All rights reserved.
'
'
'Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
'
'   1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
'   2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
'   3. The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.
'
'THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
'****************************************************************************

'Changelog
'
'$Revision$ - not released

Option Explicit

Private Type typeTestCase
    OutlookOutput As String
    ExpectedResult As String
End Type

Private mTestCases() As typeTestCase
Private Sub addTestCaseToArray(ByRef testcase As typeTestCase)
    
    ReDim Preserve mTestCases(UBound(mTestCases) + 1)
    mTestCases(UBound(mTestCases)) = testcase

End Sub

'Helper function to compare the results and find differences
Private Sub compareResults(ByVal sProcessedMail As String, ByVal sExpectedResult As String)

    Dim i As Long
    Dim bExtraenousChars As Boolean
    Dim char1 As String
    Dim char2 As String
    
    
    If True Then
        Debug.Print "Expected Result"
        Debug.Print sExpectedResult
        Debug.Print "Processed Mail"
        Debug.Print sProcessedMail
        For i = 1 To Len(sProcessedMail)
            If i > Len(sExpectedResult) Then
                'output is longer than expected result
                'print out extraenous chars
                Debug.Print mid$(sProcessedMail, i)
                bExtraenousChars = True
            Else
                char1 = mid$(sProcessedMail, i, 1)
                char2 = mid$(sExpectedResult, i, 1)
                
                If Not char1 = char2 Then
                    Debug.Print "Position: " + CStr(i)
                    Debug.Print "Processed: " + char1 + ", " + CStr(Asc(char1))
                    Debug.Print "Expected:  " + char2 + ", " + CStr(Asc(char2))
                End If
            End If
        Next i
    End If
    
    Debug.Assert Not bExtraenousChars
    Debug.Assert False
    
End Sub

'Puts all test cases into the passed array.
'Text has to be formatted as it is returned by Outlook.
Private Sub initTestCases()
    
    Dim testcase As typeTestCase
    
    
    ReDim mTestCases(0)
    'add dummy entry
    mTestCases(0) = testcase
    
    testcase.OutlookOutput = "" + _
        "> >>" + vbNewLine + _
        "> >> I have a Win 2k3 SBS and I want to replicate the users into my" + vbNewLine + _
        "> OpenLDAP" + vbNewLine + _
        "> >> 2.4.11." + vbNewLine + _
        "> >" + vbNewLine + _
        "> > This is not possible. You could however implement your own sync" + vbNewLine + _
        "> process" + vbNewLine + _
        "> > in your favourite scripting/programming language." + vbNewLine + _
        "> " + vbNewLine + _
        "> Actually we have done some preliminary work..."
    testcase.ExpectedResult = "" + _
        ">>> " + vbNewLine + _
        ">>> I have a Win 2k3 SBS and I want to replicate the users into my" + vbNewLine + _
        ">>> OpenLDAP 2.4.11." + vbNewLine + _
        ">> " + vbNewLine + _
        ">> This is not possible. You could however implement your own sync process" + vbNewLine + _
        ">> in your favourite scripting/programming language." + vbNewLine + _
        "> " + vbNewLine + _
        "> Actually we have done some preliminary work..."
    Call addTestCaseToArray(testcase)

    
    testcase.OutlookOutput = "" + _
        "> Moin," + vbNewLine + _
        "> " + vbNewLine + _
        "> Kurzanleitung """"Deckel �ffnen"""":" + vbNewLine + _
        "> 1. Unten rechts die Kunststoff-Abdeckung mit einem Schraubendreher" + vbNewLine + _
        "> nach rechts schieben." + vbNewLine + _
        "> 2. Das Blech nach links schieben." + vbNewLine + _
        "> 3. Kreuzschlitzschraube l�sen." + vbNewLine + _
        "> " + vbNewLine + _
        "> " + vbNewLine + _
        "> Mit freundlichen Gr��en" + vbNewLine + _
        "> " + vbNewLine + _
        "> company" + vbNewLine + _
        "> Jon Doe"
    testcase.ExpectedResult = testcase.OutlookOutput
    Call addTestCaseToArray(testcase)


    'This testcase currently does not run through
    'The algorithm has to be adapted not to requote greetings
    testcase.OutlookOutput = "" + _
        "> Hallo Jon, ich hatte mal von xxxxxx ein Anti-Virus Programm, aber ich" + vbNewLine + _
        "> habe" + vbNewLine + _
        "> so viele Spams trotzdem erhalten, dass ich das nicht mehr abonniert" + vbNewLine + _
        "> habe." + vbNewLine + _
        "> xxx xxxxx? Haste eine L�sung f�r mein Virenprogramm, kann ich was" + vbNewLine + _
        "> runterladen?" + vbNewLine + _
        "> Lieben Gru� Jane"
    testcase.ExpectedResult = "" + _
        "> Hallo Jon, ich hatte mal von xxxxxx ein Anti-Virus Programm, aber ich" + vbNewLine + _
        "> habe so viele Spams trotzdem erhalten, dass ich das nicht mehr abonniert" + vbNewLine + _
        "> habe. xxx xxxxx? Haste eine L�sung f�r mein Virenprogramm, kann" + vbNewLine + _
        "> ich was runterladen?" + vbNewLine + _
        "> Lieben Gru� Jane"
    Call addTestCaseToArray(testcase)
    
End Sub

'Runs a single test case
Private Function runTestCase(ByRef testcase As typeTestCase) As Boolean
    
    Dim processedMail As String
    
    
    'pass original mail to quotefix function
    processedMail = QuoteFixMacro.ReFormatText(testcase.OutlookOutput)
    
    'return result
    runTestCase = (processedMail = testcase.ExpectedResult)
    
    'compare results to find differences (perhaps a better way would be to use WinMerge)
    If Not runTestCase Then
        Call compareResults(processedMail, testcase.ExpectedResult)
    End If
    
End Function


Public Function runTestCaseNo(ByVal nIndex As Integer) As Boolean
    
    Call initTestCases
    
    If nIndex >= LBound(mTestCases) And nIndex <= UBound(mTestCases) Then
        runTestCaseNo = runTestCase(mTestCases(nIndex))
    End If
    
End Function


Public Sub runTests_ReformatText()

    Dim i As Integer
    
    
    Call initTestCases
    
    For i = 0 To UBound(mTestCases)
        If Not runTestCase(mTestCases(i)) Then
            MsgBox "TestCase " + CStr(i) + " failed", vbExclamation
        End If
    Next i
        
End Sub


