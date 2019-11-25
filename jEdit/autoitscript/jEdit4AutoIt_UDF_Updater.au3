#include <AutoItConstants.au3>
#include <File.au3>
#include <GUIConstantsEx.au3>

ConsoleWrite(@AppDataDir & @CRLF)
Global $STEMPLATEPATH = @ScriptDir & "\Templates\"
Global $SXINSERTTEMPLATE, $SXINSERTFILE, $SCLIPPERTEMPLATE, $SCLIPPERFILE

If @CPUArch = "X64" Then
    Global $SDIRINCLUDES = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\AutoIt v3\AutoIt\", "InstallDir") & "\Include\"
    Global $SDIRUSERINCLUDES = RegRead("HKEY_CURRENT_USER\Software\Wow6432Node\AutoIt v3\AutoIt", "Include")
Else
    Global $SDIRINCLUDES = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt\", "InstallDir") & "\Include\"
    Global $SDIRUSERINCLUDES = RegRead("HKEY_CURRENT_USER\Software\AutoIt v3\AutoIt", "Include")
EndIf

If Not FileExists($SDIRINCLUDES) Then
    MsgBox(64, "", "AutoIt includes not found in:" & @CRLF & $SDIRINCLUDES)
    Exit
EndIf
;===============================================================================

GUICreate("jEdit4AutoIt_UDF_Updater", 340, 75)
Global $HSTATUS = GUICtrlCreateLabel("Updating:", 10, 10)
Global $HLABEL = GUICtrlCreateLabel("", 60, 10, 270, 20)
Global $HFILELABEL = GUICtrlCreateLabel("", 10, 30, 320, 20)
Global $HPROGRESS2 = GUICtrlCreateProgress(10, 50, 320, 10)
Global $HPROGRESS1 = GUICtrlCreateProgress(10, 60, 320, 10)
GUISetState(@SW_SHOW)
;===============================================================================

Global $SEDITMODETEMPLATE = $STEMPLATEPATH & "au3.xml"
Global $SEDITMODEFILE = @AppDataDir & "\jEdit\modes\au3.xml"

If Not FileExists($SEDITMODEFILE) Then $SEDITMODEFILE = @ProgramFilesDir & "\jEdit\modes\au3.xml"
If FileExists(@AppDataDir & "\jedit\xinsert\") Then
    $SXINSERTTEMPLATE = $STEMPLATEPATH & "AutoItScript.insert.xml"
    $SXINSERTFILE = @AppDataDir & "\jedit\xinsert\AutoItScript.insert.xml"
EndIf

If FileExists(@AppDataDir & "\jedit\clipper\") Then
    $SCLIPPERTEMPLATE = $STEMPLATEPATH & "AutoItScript_UDFs.cliplibrary"
    $SCLIPPERFILE = @AppDataDir & "\jedit\clipper\AutoItScript_UDFs.cliplibrary"
EndIf

GUICtrlSetData($HPROGRESS1, 20)
_LABEL2($SDIRINCLUDES)
Global $AINCLUDES = READINCLUDES($SDIRINCLUDES)
If FileExists(@AppDataDir & "\jedit\AutoItScript\") Then
    GUICtrlSetData($HLABEL, "Include_Auto_Insert")
    GUICtrlSetData($HPROGRESS1, 40)
    Global $SAUTOINSERTFILE = @AppDataDir & "\jedit\AutoItScript\includes.xml"
    _LABEL2($SAUTOINSERTFILE)
    AUTOINSERT_UPDATE()
EndIf
If FileExists($SXINSERTTEMPLATE) Then
    GUICtrlSetData($HLABEL, "XInsert ...")
    _LABEL2($SXINSERTFILE)
    GUICtrlSetData($HPROGRESS1, 60)
    XINSERT_UPDATE()
EndIf
If FileExists($SEDITMODETEMPLATE) Then
    GUICtrlSetData($HLABEL, "Edit Mode ...")
    _LABEL2($SEDITMODEFILE)
    GUICtrlSetData($HPROGRESS1, 80)
    EDITMODE_UPDATE()
EndIf
If FileExists($SCLIPPERTEMPLATE) Then
    GUICtrlSetData($HLABEL, "Clipper ...")
    _LABEL2($SCLIPPERFILE)
    GUICtrlSetData($HPROGRESS1, 100)
    CLIPPER_UPDATE()
EndIf
;===============================================================================
Sleep(2000)
GUICtrlSetData($HSTATUS, "Ready!")
GUICtrlSetData($HLABEL, "")
_LABEL2("2009 - " & @YEAR & " by thorsten.willert@gmx.de")
GUICtrlSetData($HPROGRESS1, 100)
GUICtrlSetData($HPROGRESS2, 100)
While 1
    If GUIGetMsg() = $GUI_EVENT_CLOSE Then Exit
    Sleep(50)
WEnd
Exit
;===============================================================================
Func AUTOINSERT_UPDATE()
    ConsoleWrite("Updating includes.xml ..." & @CRLF)
    Local $SXML, $AFUNC, $SFILE, $I, $J
    $SXML = '<?xml version="1.0" ?>' & @CRLF
    $SXML &= "<!-- :collapseFolds=1:folding=indent: -->" & @CRLF
    $SXML &= '<include path="DEFAULT">' & @CRLF
    For $I = 1 To UBound($AINCLUDES) - 1
        $SFILE = $AINCLUDES[$I][0]
        If $SFILE = "" Then ContinueLoop
        $SXML &= @TAB & '<file name="' & $SFILE & '">' & @CRLF
        $AFUNC = StringSplit($AINCLUDES[$I][1], "|")
        For $J = 1 To $AFUNC[0] - 1
            $SXML &= @TAB & @TAB & "<func>" & $AFUNC[$J] & "</func>" & @CRLF
        Next
        $SXML &= @TAB & "</file>" & @CRLF
    Next
    $SXML &= "</include>" & @CRLF
    STRING2FILE($SAUTOINSERTFILE, $SXML)
    Return
EndFunc   ;==>AUTOINSERT_UPDATE
;===============================================================================
Func CLIPPER_FUNCTION_LIST()
    Local $AFUNC
    Local $SFILE, $I, $J
    Local $SXML = ""
    For $I = 1 To UBound($AINCLUDES) - 1
        GUICtrlSetData($HPROGRESS2, 100 / UBound($AINCLUDES) * $I)
        $SFILE = $AINCLUDES[$I][0]
        If $SFILE = "" Then ContinueLoop
        $AFUNC = StringSplit($AINCLUDES[$I][1], "|")
        For $J = 1 To $AFUNC[0] - 1
            $SXML &= $AFUNC[$J] & "=" & $AFUNC[$J] & "(|)" & @CRLF
        Next
    Next
    GUICtrlSetData($HPROGRESS2, 100)
    Return $SXML
EndFunc   ;==>CLIPPER_FUNCTION_LIST
;===============================================================================
Func CLIPPER_UPDATE()
    ConsoleWrite("Updating Clipper ..." & @CRLF)
    Local $SDATA
    Local $STEMPLATE = FILE2STRING($SCLIPPERTEMPLATE)
    $SDATA = StringReplace($STEMPLATE, "UDF_INCLUDE 1uQBCpPGfQgIV-F971NY", CLIPPER_FUNCTION_LIST())
    STRING2FILE($SCLIPPERFILE, $SDATA)
    Return
EndFunc   ;==>CLIPPER_UPDATE
;===============================================================================
Func EDITMODE_FUNCTION_LIST()
    Local $AFUNC
    Local $SFILE, $I, $J
    Local $SXML = "<!-- UDFs -->" & @CRLF
    For $I = 1 To UBound($AINCLUDES) - 1
        GUICtrlSetData($HPROGRESS2, 100 / UBound($AINCLUDES) * $I)
        $SFILE = $AINCLUDES[$I][0]
        If $SFILE = "" Then ContinueLoop
        $SXML &= "<!-- " & $SFILE & " -->" & @CRLF
        $AFUNC = StringSplit($AINCLUDES[$I][1], "|")
        For $J = 1 To $AFUNC[0] - 1
            $SXML &= StringFormat("<KEYWORD3>%s</KEYWORD3>", $AFUNC[$J]) & @CRLF
        Next
    Next
    $SXML &= "<!-- END UDFs -->" & @CRLF
    GUICtrlSetData($HPROGRESS2, 100)
    Return $SXML
EndFunc   ;==>EDITMODE_FUNCTION_LIST
;===============================================================================
Func EDITMODE_UPDATE()
    ConsoleWrite("Updating Edit-Mode ..." & @CRLF)
    Local $SDATA
    Local $STEMPLATE = FILE2STRING($SEDITMODETEMPLATE)
    $SDATA = StringReplace($STEMPLATE, "<!-- UDF_INCLUDE 1uQBCpPGfQgIV-F971NY -->", EDITMODE_FUNCTION_LIST())
    STRING2FILE($SEDITMODEFILE, $SDATA)
    Return
EndFunc   ;==>EDITMODE_UPDATE
;===============================================================================
Func XINSERT_UDF_LIST($SMENU)
    Local $SFILE, $SNAME, $I
    Local $SXML = TAB(4) & '<menu name="' & $SMENU & '">' & @CRLF
    For $I = 1 To UBound($AINCLUDES) - 1
        GUICtrlSetData($HPROGRESS2, 100 / UBound($AINCLUDES) * $I)
        $SFILE = $AINCLUDES[$I][0]
        If $SFILE = "" Then ContinueLoop
        $SNAME = STRIPSUFFIX($SFILE)
        $SXML &= TAB(5) & StringFormat('<item name="%s">#include &lt;%s&gt;</item>', $SNAME, $SFILE) & @CRLF
    Next
    $SXML &= TAB(4) & "</menu>"
    GUICtrlSetData($HPROGRESS2, 100)
    Return $SXML
EndFunc   ;==>XINSERT_UDF_LIST
;===============================================================================
Func XINSERT_UDF_MENU()
    Local $AFUNC
    Local $SFILE, $SNAME, $I, $J
    Local $SXML = TAB(2) & '<menu name="UDFs">' & @CRLF
    For $I = 1 To UBound($AINCLUDES) - 1
        GUICtrlSetData($HPROGRESS2, 100 / UBound($AINCLUDES) * $I)
        $SFILE = $AINCLUDES[$I][0]
        If $SFILE = "" Then ContinueLoop
        $SNAME = STRIPSUFFIX($SFILE)
        $SXML &= TAB(3) & StringFormat('<menu name="%s Management">', $SNAME) & @CRLF
        $SXML &= TAB(4) & StringFormat('<item name="Include %s">#include &lt;%s&gt;</item>', $SNAME, $SFILE) & @CRLF
        $AFUNC = StringSplit($AINCLUDES[$I][1], "|")
        For $J = 1 To $AFUNC[0] - 1
            $SXML &= TAB(4) & StringFormat('<item name="%s">%s(|)</item>', $AFUNC[$J], $AFUNC[$J]) & @CRLF
        Next
        $SXML &= TAB(3) & "</menu>" & @CRLF
    Next
    $SXML &= TAB(2) & "</menu>"
    GUICtrlSetData($HPROGRESS2, 100)
    Return $SXML
EndFunc   ;==>XINSERT_UDF_MENU
;===============================================================================
Func XINSERT_ENV_LIST()
    Local $I
    Local $SSET = Run(@ComSpec & " /c " & "set", @SystemDir, Default, $STDOUT_CHILD)
    Local $LINE = ""
    While 1
        $LINE &= StdoutRead($SSET)
        If @error Then ExitLoop
    WEnd
    Local $AENV = StringRegExp($LINE, "(.*?)=.*?\n", 3)
    If Not @error And IsArray($AENV) Then
        Local $SXML = TAB(4) & '<menu name="Current ENVs">' & @CRLF
        For $I = 0 To UBound($AENV) - 1
            GUICtrlSetData($HPROGRESS2, 100 / UBound($AINCLUDES) * $I)
            $SXML &= TAB(5) & StringFormat('<item name="%s">%s</item>', $AENV[$I], $AENV[$I]) & @CRLF
        Next
        $SXML &= TAB(4) & "</menu>" & @CRLF
    Else
        Return ""
    EndIf
    GUICtrlSetData($HPROGRESS2, 100)
    Return $SXML
EndFunc   ;==>XINSERT_ENV_LIST
;===============================================================================
Func XINSERT_UPDATE()
    ConsoleWrite("Updating Xinsert ..." & @CRLF)
    Local $SUSER_MENU = "", $SDATA
    Local $STEMPLATE = FILE2STRING($SXINSERTTEMPLATE)
    GUICtrlSetData($HLABEL, "XInsert UDF-menu ...")
    $SDATA = StringReplace($STEMPLATE, "<!-- UDF_INCLUDE 1uQBCpPGfQgIV-F971NY -->", XINSERT_UDF_MENU())
    $SDATA = StringReplace($SDATA, "<!-- UDF_USERINCLUDE 1uQBCpPGfQgIV-F971NY -->", $SUSER_MENU)
    GUICtrlSetData($HLABEL, "XInsert UDF-list ...")
    $SDATA = StringReplace($SDATA, "<!-- UDF_INCLUDE_LIST 1uQBCpPGfQgIV-F971NY -->", XINSERT_UDF_LIST("UDFs"))
    GUICtrlSetData($HLABEL, "XInsert ENV-list ...")
    $SDATA = StringReplace($SDATA, "<!-- ENV 1uQBCpPGfQgIV-F971NY -->", XINSERT_ENV_LIST())
    STRING2FILE($SXINSERTFILE, $SDATA)
    Return
EndFunc   ;==>XINSERT_UPDATE
;===============================================================================
Func READFUNCTIONS($SFILE, $BINTERNAL)
    Local $AFILE, $SRET
    Local $SREGEX = "^[\s]*[Ff]unc[\s]+([\w]+)"
    Local $AREGEX
    _FileReadToArray($SFILE, $AFILE)
    For $I = 1 To $AFILE[0]
        $AREGEX = StringRegExp($AFILE[$I], $SREGEX, 3)
        If IsArray($AREGEX) Then
            If Not $BINTERNAL And StringLeft($AREGEX[0], 2) = "__" Then ContinueLoop
            $SRET &= $AREGEX[0] & "|"
        EndIf
    Next
    Return $SRET
EndFunc   ;==>READFUNCTIONS
;===============================================================================
Func READCONSTANTS($SFILE)
    Local $AFILE, $SRET
    Local $SREGEX = "^[\s]*[Gg]lobal[\s]*[Cc]onst[\s]*(\$[\w]+)(.*?)$"
    Local $AREGEX
    _FileReadToArray($SFILE, $AFILE)
    For $I = 1 To $AFILE[0]
        $AREGEX = StringRegExp($AFILE[$I], $SREGEX, 3)
        If IsArray($AREGEX) Then $SRET &= $AREGEX[0] & "|"
    Next
    Return $SRET
EndFunc   ;==>READCONSTANTS
;===============================================================================
Func READINCLUDES($SDIR, $BINTERNAL = False)
    Local $AFILES = _FileListToArray($SDIRINCLUDES, "*.au3", 1)
    Local $ARET[$AFILES[0] + 1][2]
    For $I = 1 To $AFILES[0]
        If Not StringInStr($AFILES[$I], "constants") And Not StringInStr($AFILES[$I], "dll") And Not StringInStr($AFILES[$I], "~") Then
            GUICtrlSetData($HLABEL, "Analyzing: " & $AFILES[$I] & "...")
            GUICtrlSetData($HPROGRESS2, 100 / $AFILES[0] * $I + 1)
            $ARET[$I][0] = $AFILES[$I]
            $ARET[$I][1] = READFUNCTIONS($SDIR & $AFILES[$I], $BINTERNAL)
        EndIf
    Next
    Return $ARET
EndFunc   ;==>READINCLUDES
;===============================================================================
Func FILE2STRING($SFILE)
    Local $HFILE = FileOpen($SFILE, 0)
    Local $STEMP = FileRead($HFILE)
    FileClose($HFILE)
    Return $STEMP
EndFunc   ;==>FILE2STRING
;===============================================================================
Func STRING2FILE($SFILE, $SSTRING)
    Local $HFILE = FileOpen($SFILE, 2)
    FileWrite($HFILE, $SSTRING)
    FileClose($HFILE)
    Return
EndFunc   ;==>STRING2FILE
;===============================================================================
Func STRIPSUFFIX($SFILE)
    Return StringMid($SFILE, 1, StringInStr($SFILE, ".") - 1)
EndFunc   ;==>STRIPSUFFIX
;===============================================================================
Func TAB($N)
    Local $TMP = ""
    For $I = 1 To $N
        $TMP &= @TAB
    Next
    Return $TMP
EndFunc   ;==>TAB
;===============================================================================
Func _LABEL2($SSTRING)
    If StringLen($SSTRING) > 70 Then $SSTRING = "..." & StringRight($SSTRING, 70)
    GUICtrlSetData($HFILELABEL, $SSTRING)
EndFunc   ;==>_LABEL2
