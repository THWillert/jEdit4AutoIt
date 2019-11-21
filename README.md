# jEdit4AutoIt

In Arbeit ...

Bis dahin bitte [jEdit4AutoIt](http://jedit4autoit.thorsten-willert.de/) benutzen.

## Übersicht
Erweitert jEdit zu einer IDE für AutoIt.

### Behinhaltet:

- Edit-mode
- Commando files
- XInsert library
- Clipper libraries
- ctags
- Macros

### Benötigte Plugins und Software:

- Console-plugin
- Clipper-plugin
- XInsert-plugin
- Sidekick-plugin
- CtagsSideKick-plugin

An installation of AutoIt3 and all the other tools you want e.g. Tidy ...

### Zusätzliche empfohlene Plugins:

- Context Menu
- Column Ruler
- jDiff
- MyDoggyPlugin
- Project Viewer
- TextTools
- WhiteSpace

## Installation
Just copy all directories in the archiv to the following directories:



|Source|Destination|
|--------|--------|
|%programfiles% | %programfiles% |
|C:\Program Files\ | %appdata% |
|%appdata%\jedit|C:\Users\YourUserName\AppData\Roaming\jedit|


and add the edit-mode to your catalog-file. After you have installed all files, you have to run the macro "Macros/AutoIt/Update UDFs".
It updates the edit-mode, XInsert and Clipper files to your installed UDFs.

Edit-Mode
Installation in:
`%programfiles%/jEdit/modes/`
Edit-mode entry in:
`%programfiles%/jEdit/modes/catalog`

```xml
<MODE NAME="autoitscript"       FILE="au3.xml"
                                FILE_NAME_GLOB="*.{au3}"/>
```




Requires:
Console-plugin

### XInsert library
It includes all:

- Keywords
- Statements (incl. macros for Select / Switch / Message-Loops)
- Build-in functions
- Options (incl. comment)
- Macros
- Keycodes
- Windows Messages Codes
- OSLang Codes
- (some) CLSIDs
- ENV variables
- ENV variables available on the current system
- Directives (incl. AutoIt3Wrapper, Obfuscator, Au3Check and Tidy)
- All UDFs in the AutoIt/Include directory
- All functions from this UDFs
- GUI Control Styles
- ...

Xinsert Requires:
XInsert-plugin


### Clipper
If XInsert is to complex you can use instead this (or booth):
Entries for all AutoIt Keywords, Functions, Statements and UDFs:
Installation in:
`%appdata%/jedit/clipper/`
Requires:
Clipper-plugin

### Ctags + Sidekick-plugin + CtagsSidekick-plugin:
Lists all Functions, Include-Files, Global and Local Variables, Enums, Regions and Options in the Sidekick-Plugin.

Entry for the ctags.cnf:

```
--langdef=AutoItScript
--langmap=AutoItScript:.au3.AU3
--regex-AutoItScript=/^[ \t]*func[ \t]+(.*?)[\(]/\1/Functions/i
--regex-AutoItScript=/^[ \t]*global[ \t]+(.*?)[ \t]*/\1/Global Variables/i
--regex-AutoItScript=/^[ \t]*local[ \t]+(.*?)[ \t]*/\1/Local Variables/i
--regex-AutoItScript=/^[ \t]*(local|global)?[ \t]+enum[ \t]+(.*)/\1 \2/Enum/i
--regex-AutoItScript=/^#include(.*?)(<|")(.*?)("|>)/\3/Include Files/i
--regex-AutoItScript=/^#region[ \t]*(.*?)/\1/Regions/i
--regex-AutoItScript=/^[ \t]*(Opt|AutoItSetOption)[ \t]*[\(](.*),(.*)[\)]/\2 \3/Options/i
--regex-AutoItScript=/^(.*?);#__DEBUG__/\1/Debug/i
```

Installation in:
`%ProgramFiles%\jEdit\ctags.cnf`
Requires:
ctags + Sidekick-plugin + CtagsSideKick-plugin

Installation of ctags in:
`%ProgramFiles%\ctags\`

### Macros only for AutoIt:
|Macro|Description|Location|
|--------|--------|--------|
|AutoItStartUp.bsh|	Some functions used in the other macros.| 	%programfiles%/jEdit/startup|
|Buffer_Switch_to_AutoIt_Mode.bsh |	Switches the current buffer mode to "AutoItScript"||
|Debug_Phrase_To_Console (IF).bsh|||
|Debug_Phrase_To_MessageBox (IF).bsh|||
|Debug_Remove (If).bsh 	|Removes all the ConsoleWrite commandos inserted with||
|Debug_Variable_To_Console (IF).bsh|||
|Debug_Toggle.bsh 	Enables / disables debugging.|||
|Debug_Variable_To_Console (IF).bsh|Inserts a ConsoleWrite commando in the next line for the variable at the cursor-position.||
|Debug_Variable_To_Console (IF)_Before.bsh|||
|Debug_Variable_To_MessageBox (IF).bsh|||
|Debug_Variable_To_MessageBox (IF)_Before.bsh|||
|Function_Goto_Definition.bsh| 	Jumps to the definition of the function under the cursor. (only for standard UDFs and the current buffer)||
|Include.bsh|Creates #include "..." directives via file-dialog, from the current buffer - dir.||
|Include_Auto_Insert.bsh|Inserts the required includes at the top of the file, or after a #region include ... (only for the UDFs in AutoIt/Include)||
|Include_lib.bsh|Creates #include <...> directives via file-dialog, from the AutoIt/Include - dir.||
|Include_Open.bsh|Opens the include-file from the current line in a new buffer.||
|Insert_AutoItVersion|Inserts the version of AutoItScript at cursor position.||
|Insert_Message_Loop_(Select)|(variable number of cases)||
|Insert_Message_Loop_(Switch)|(variable number of cases)||
|Insert_Select|(variable number of cases)||
|Insert_Switch|(variable number of cases)||

### Function_Wizzard.bsh
Creates a new function with description:

```autoit
; #FUNCTION# ===================================================================
; Name ..........: _FF_DM_DownloadPause
; Description ...: Pauses the specified download
; AutoIt Version : V3.3.0.0
; Requirement(s).: FF.au3 / MozRepl
; Syntax ........: _FF_DM_DownloadPause($iID)
; Parameter(s): .: $iID         - Download ID
; Return Value ..: Success      - 1
;                  Failure      - 0
;                  @ERROR       -
; Author(s) .....: Thorsten Willert
; Date ..........: Sat Mar 28 00:24:15 CET 2009
; Related .......:
; Link ..........:
; ==============================================================================
Func _FF_DM_DownloadPause($iID)

EndFunc   ;==>_FF_DM_DownloadPause
```

	

PP 	Simple preprocessor:

With the following statements and constants:
#define	Definition of simple macros
#undefine / #undef	removing a macro
#ifdef / #elif / #else / #endif	Conditional statement (not nestable yet)
__TIME__	Replaced with the current time
__DATE__	Replaced with the current date
__DATE_AND_TIME__	Replaced with the current date and time
__NAME__	Replaced with full filename
__FILE__	Replaced with filename
__AUTOIT_VERSION__	Replaced with the version of AutoIt
__AUTOIT_BETAVERSION__	Replaced with the beta-version of AutoIt


Replaces:
```autoit
var++	var += 1
var--	var -= 1
var=(a?b:c)	If a Then var=b Else var=c
a?b:c	If a Then b Else c
a<<b	BitShift(a, b)
a>>b	BitShift(a, -(b))
~a	BitNot(a)
!a	Not a
!(	Not (...
a % b	Mod(a, b)
a <<= b	a = BitShift(a, b)
a >>= b	a = BitShift(a, -(b))
a %= b	a = Mod(a, b)
For $i : $Array	For $i = 0 To UBound($Array)-1
```


Input e.g.:

; File ............: __NAME__
; AutoItVersion ...: __AUTOIT_VERSION__
; Time ............: __TIME__
; Date ............: __DATE__

#define Text "foo bar"
#define Var1 $ok[$i]
#define Var2 $test
#define Beta

~$b[$i]
$a %= $b
$a <<= $v[$i]
$a >>= $v

#ifdef Beta
        #include <test_beta.au3>
#else
        #include <test.au3>
#endif


Var1 = ( 1 > $a ? "ok" : Text )

For $i : $aArray
        MsgBox(64,"",$aArray[$i])
Next

#undef Var2

#ifdef Var2
        MsgBox(64,"","1")
#elif Test
        MsgBox(64,"",Var2)
#elif Var1
        MsgBox(64,"",Text)
#else
        MsgBox(64,"","3")
#endif

Output: (after tidy)

; File ............: pp_test.au3
; AutoItVersion ...: v3.3.0.0
; Time ............: 20:20:35
; Date ............: Mi Mai 2009

BitNOT($b[$i])
$a = Mod($a, $b)
$a = BitShift($a, $v[$i])
$a = BitShift($a, -($v))

#include <test_beta.au3>

If 1 > $a Then
        $ok[$i] = "ok"
Else
        $ok[$i] = "foo bar"
EndIf

For $i = 0 To UBound($aArray) -1
        MsgBox(64, "", $aArray[$i])
Next

MsgBox(64, "", "foo bar")

Update_Syntax 	Updates the function-syntax in the function description. 	
Update_UDFs 	Updates edit-mode, Xinsert, clipper and the cache-file for Include-Auto_Insert. 	
Variable_Goto_Declaration.bsh 	Searches the declaration for the variable under the cursor.
(only in the current buffer) 	
Macros for all modes:
Macro:	Description:	Location:
Insert_Filename.bsh 	Inserts at cursor-postion a filename from a file-dialog. 	
Insert_Line.bsh 	Inserts a single "line" comment, depending on the buffer mode. 	
Number_decr_1.bsh 	Int on cursor position -1 	
Number_decr_10.bsh 	Int on cursor position -10 	
Number_incr_1.bsh 	Int on cursor position +1 	
Number_incr_10.bsh 	Int on cursor position +10 	
Quoted_String_Delete.bsh 	Deletes the quoted string at cursor position. 	
Quoted_String_Select.bsh 	Selects the quoted string at cursor position. 	
Quoted_String_Select_Next.bsh 	Searches and selects the next quoted string. 	
Toggle.bsh 	Toggles words at cursor position, depending on the edit-mode.

AutoItScript:
True	False
And	Or
BitOR	BitAND
$GUI_CHECKED	$GUI_UNCHECKED
$GUI_ENABLE	$GUI_DISABLE
$GUI_SHOW 	$GUI_HIDE
$SW_SHOW	$SW_HIDE
$SW_ENABLE	$SW_DISABLE
$SW_LOCK	$SW_UNLOCK
$SW_MINIMIZE	$SW_MAXIMIZE
Global	Local
Else	ElseIf
Select	Switch
EndSelect	EndSwitch

Installation of the config-files:
%appdata%/jEdit/toggle/EDITMODE/toggle.config 	
KeyWord_Search.bsh 	Online-Help.
