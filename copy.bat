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
echo Errorlog for %0. Exit codes refer to robocopy exit codes. > %log_directory%
)

:continue
SET "start_date=%DATE%"
SET "start_time=%TIME%"

robocopy %source% %destination% %include_file% /XF %exclude_file% %0 %log_name% %exclude_if% /MOV /R:10 /W:5 /njh /njs /ndl /np /nc /ns /ts /xx >> %log_directory%

if %ERRORLEVEL% GEQ 8 (
	echo 			 	Started: %start_date%-%start_time% Completed: %DATE%-%TIME% Exit code: %ERRORLEVEL% >> %log_directory%
	echo 				Error has occurred, check exit code for more information. >> %log_directory%
)

SET "copied=0"
if %ERRORLEVEL% EQU 5 SET "copied=1"
if %ERRORLEVEL% EQU 4 SET "copied=1"
if %ERRORLEVEL% EQU 3 SET "copied=1"
if %ERRORLEVEL% EQU 1 SET "copied=1"
if "%copied%" == "1" (
	echo 			 	Started: %start_date%-%start_time% Completed: %DATE%-%TIME% Exit code: %ERRORLEVEL% >> %log_directory%
	echo 				One or more files moved successfully. >> %log_directory%
)
EXIT /B