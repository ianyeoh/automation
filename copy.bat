@echo off

:: Source Directory
SET "source=.."

:: Destination Directory
SET "destination=..\errlog"

:: Include These Files
SET "include_file=*.*"

:: Exclude These Files
SET "exclude_file=autosend.* autorun_txt.*"

:: Exclude Files Newer/Older Than
SET "exclude_if=/MINAGE:1"
:: SET "exclude_if=/MAXAGE:n"

:: Script Log File Output Directory and File Name
SET "log_name=errlog.log"
SET "log_directory=.\%log_name%"



IF EXIST %log_directory% (
GOTO :continue
) ELSE (
echo =================== > %log_directory%
)

:continue
echo Started %DATE% %TIME% >> %log_directory%
robocopy %source% %destination% %include_file% /XF %exclude_file% %0 %log_name% %exclude_if% /MOV /R:10 /W:5 /njh /njs /ndl /np /xx >> %log_directory%
echo Completed %DATE% %TIME% Exit code: %ERRORLEVEL% >> %log_directory%

if %ERRORLEVEL% GEQ 8 echo Error has occurred, check exit code for more information. >> %log_directory%
if %ERRORLEVEL% EQU 3 echo One or more files moved successfully. >> %log_directory%
if %ERRORLEVEL% EQU 2 echo No files moved. >> %log_directory%
if %ERRORLEVEL% EQU 1 echo One or more files moved successfully. >> %log_directory%
if %ERRORLEVEL% EQU 0 echo No files moved. >> %log_directory%
echo =================== >> %log_directory%
EXIT /B