@echo off & setLocal EnableDelayedExpansion
:: Copyright Conor McKnight
:: https://github.com/C0nw0nk
:: https://www.facebook.com/C0nw0nk
:: Automatically sets up plexcleaner for windows
:: all you need is the batch script it will download the latest versions from their github pages
:: simple fast efficient easy to move and manage
:: converts non direct playable content to MKV to be direct playable

:: Script Settings

:: Directory to scan
:: Path format can be Network share or Drive name "C:\path\Movies"
set media_path="\\NAS\FOLDER\Movies"

:: Instead of just closing the window after our automated tasking we pause to view and check once your happy you can set this to 0
:: 1 enabled
:: 0 disabled
set pause_window=1

:: Wait number of seconds
:: 0 disabled
:: 60 = 60 seconds etc
set wait_interval=120

:: If you want this script to not exit once finished and after task complete / wait interval passed recheck plex folders in a loop
:: 1 enabled
:: 0 disabled
set looping=1

:: End Edit DO NOT TOUCH ANYTHING BELOW THIS POINT UNLESS YOU KNOW WHAT YOUR DOING!

:: Make script configurable via command line with arguements example
:: "C:\path\PlexCleaner.cmd" "\\NAS\path" "pause_window" "wait_interval" "looping" 2^>nul
:: Working example
:: "C:\path\PlexCleaner.cmd" "\\NAS\path" "1" "120" "1" 2^>nul

if "%~1"=="" goto :script_arguments_not_defined
set media_path=%~1
set pause_window=%~2
set wait_interval=%~3
set looping=%~4
:script_arguments_not_defined

TITLE PlexCleaner

set root_path="%~dp0"

if %PROCESSOR_ARCHITECTURE%==x86 (
	set programs_path=%ProgramFiles(x86)%
) else (
	set programs_path=%ProgramFiles%
)

goto :next_download

:start_exe

::PlexCleaner code

if not exist "%root_path:"=%win-x64\PlexCleaner.json" (
"%root_path:"=%win-x64\PlexCleaner" defaultsettings --settingsfile "%root_path:"=%win-x64\PlexCleaner.json"
)

if not exist "%root_path:"=%win-x64\PlexCleaner.log" (
echo >"%root_path:"=%win-x64\PlexCleaner.log"
)

"%root_path:"=%win-x64\PlexCleaner" process --parallel --settingsfile %root_path:"=%win-x64\PlexCleaner.json --logfile "%root_path:"=%win-x64\PlexCleaner.log" --mediafiles %media_path%

::End PlexCleaner code

goto :end_script

goto :next_download
:start_download
set downloadurl=%downloadurl: =%
FOR /f %%i IN ("%downloadurl:"=%") DO set filename="%%~ni"& set fileextension="%%~xi"
set downloadpath="%root_path:"=%%filename%%fileextension%"
(
echo Dim oXMLHTTP
echo Dim oStream
echo Set fso = CreateObject^("Scripting.FileSystemObject"^)
echo If Not fso.FileExists^("%downloadpath:"=%"^) Then
echo Set oXMLHTTP = CreateObject^("MSXML2.ServerXMLHTTP.6.0"^)
echo oXMLHTTP.Open "GET", "%downloadurl:"=%", False
echo oXMLHTTP.SetRequestHeader "User-Agent", "Mozilla/5.0 ^(Windows NT 10.0; Win64; rv:51.0^) Gecko/20100101 Firefox/51.0"
echo oXMLHTTP.SetRequestHeader "Referer", "https://www.google.co.uk/"
echo oXMLHTTP.SetRequestHeader "DNT", "1"
echo oXMLHTTP.Send
echo If oXMLHTTP.Status = 200 Then
echo Set oStream = CreateObject^("ADODB.Stream"^)
echo oStream.Open
echo oStream.Type = 1
echo oStream.Write oXMLHTTP.responseBody
echo oStream.SaveToFile "%downloadpath:"=%"
echo oStream.Close
echo End If
echo End If
echo ZipFile="%downloadpath:"=%"
echo ExtractTo="%root_path:"=%"
echo ext = LCase^(fso.GetExtensionName^(ZipFile^)^)
echo If NOT fso.FolderExists^(ExtractTo^) Then
echo fso.CreateFolder^(ExtractTo^)
echo End If
echo Set app = CreateObject^("Shell.Application"^)
echo Sub ExtractByExtension^(fldr, ext, dst^)
echo For Each f In fldr.Items
echo If f.Type = "File folder" Then
echo ExtractByExtension f.GetFolder, ext, dst
echo End If
echo If instr^(f.Path, "\%file_name_to_extract%"^) ^> 0 Then
echo If fso.FileExists^(dst ^& f.Name ^& "." ^& LCase^(fso.GetExtensionName^(f.Path^)^) ^) Then
echo Else
echo call app.NameSpace^(dst^).CopyHere^(f.Path^, 4^+16^)
echo End If
echo End If
echo Next
echo End Sub
echo If instr^(ZipFile, "zip"^) ^> 0 Then
echo ExtractByExtension app.NameSpace^(ZipFile^), "exe", ExtractTo
echo End If
if [%file_name_to_extract%]==[*] echo set FilesInZip = app.NameSpace^(ZipFile^).items
if [%file_name_to_extract%]==[*] echo app.NameSpace^(ExtractTo^).CopyHere FilesInZip, 4
if [%delete_download%]==[1] echo fso.DeleteFile ZipFile
echo Set fso = Nothing
echo Set objShell = Nothing
)>"%root_path:"=%%~n0.vbs"
cscript //nologo "%root_path:"=%%~n0.vbs"
del "%root_path:"=%%~n0.vbs"
:next_download

if not exist "%root_path:"=%win-x64\PlexCleaner.exe" (

winget install Microsoft.DotNet.DesktopRuntime.6 >nul
winget install Microsoft.DotNet.DesktopRuntime.7 >nul

if not defined plexcleaner_exe (
	set downloadurl=https://github.com/ptr727/PlexCleaner/releases/latest/download/PlexCleaner.7z
	set delete_download=0
	set plexcleaner_exe=true
	goto :start_download
)


if not exist "%programs_path%\WinRAR\winrar.exe" (
if not defined winrar_exe (
	if %PROCESSOR_ARCHITECTURE%==x86 (
		set downloadurl=https://www.rarlab.com/rar/winrar-x32-620b2.exe
	) else (
		set downloadurl=https://www.rarlab.com/rar/winrar-x64-620b2.exe
	)
	set delete_download=0
	set winrar_exe=true
	goto :start_download
)
start /wait %downloadpath% /s
del %downloadpath%
(
echo RAR registration data
echo WinRAR
echo Unlimited Company License
echo UID=4b914fb772c8376bf571
echo 6412212250f5711ad072cf351cfa39e2851192daf8a362681bbb1d
echo cd48da1d14d995f0bbf960fce6cb5ffde62890079861be57638717
echo 7131ced835ed65cc743d9777f2ea71a8e32c7e593cf66794343565
echo b41bcf56929486b8bcdac33d50ecf773996052598f1f556defffbd
echo 982fbe71e93df6b6346c37a3890f3c7edc65d7f5455470d13d1190
echo 6e6fb824bcf25f155547b5fc41901ad58c0992f570be1cf5608ba9
echo aef69d48c864bcd72d15163897773d314187f6a9af350808719796
)>"%programs_path%\WinRAR\rarreg.key"
) else (
	call ^"%programs_path%\WinRAR\winrar.exe^" x ^"%root_path:"=%PlexCleaner.7z^" ^"*^" ^"%root_path:"=%^"
	del "%root_path:"=%PlexCleaner.7z"
)

)

goto :start_exe
:end_script

if %pause_window% == 1 pause

if not %wait_interval% == 0 TIMEOUT /T %wait_interval%

if %looping% == 1 goto :start_exe

exit /b
