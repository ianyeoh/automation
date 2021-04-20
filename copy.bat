@echo off

:: Source Directory
SET "source=.\"

:: Destination Directory
SET "destination=.\errlog"

:: Temp File Directory, stores list of copied files for later use. Generated on script run and deleted on close. 
SET "tmp_dir=.\copiedfiles_tmp.txt"

:: Include These Files
SET "include_file=*.*"

:: Exclude These Files
SET "exclude_file=autosend.* autorun_txt.* %tmp_dir%"

:: Exclude Files Newer/Older Than
SET "exclude_if=/MINAGE:1"
:: SET "exclude_if=/MAXAGE:n"

:: Script Log File Output Directory and File Name
SET "log_name=errlog.log"
SET "log_dir=.\%log_name%"


:: ---------------------------------------

:: Recording script start run time
SET "start_date=%DATE%"
SET "start_time=%TIME%"

:: In the case the temp file exists prior to running the file, delete it 
:: NOTE: this is unexpected behaviour, as the temp file should only ever exist within the lifecycle of the script.
if EXIST %tmp_dir% (
	del %tmp_dir%
)

:: Runs copy command, creates and stores a list of copied files in temp file.
robocopy %source% %destination% %include_file% /XF %exclude_file% %0 %log_name% %exclude_if% /MOV /R:10 /W:5 /njh /njs /ndl /np /nc /ns /ts /xx > %tmp_dir%

:: Writes to log file if robocopy returns errors.
if %ERRORLEVEL% GEQ 8 (
	:: Creates log file if not already present.
	if NOT EXIST %log_dir% (
		echo. 2> %log_dir%
	)
	echo Started: %start_date%-%start_time% Completed: %DATE%-%TIME% Exit code: %ERRORLEVEL% >> %log_dir%
	echo Error occurred while copying files, check robocopy exit code above for more information. >> %log_dir%
)

:: Writes to log file if files are copied. Does not generate a zero length file if no files are copied.
SET "copied=0"
if %ERRORLEVEL% EQU 5 SET "copied=1"
if %ERRORLEVEL% EQU 4 SET "copied=1"
if %ERRORLEVEL% EQU 3 SET "copied=1"
if %ERRORLEVEL% EQU 1 SET "copied=1"
if "%copied%" == "1" (
	:: Creates log file if not already present.
	if NOT EXIST %log_dir% (
		echo. 2> %log_dir%
	)

	echo Started: %start_date%-%start_time% Completed: %DATE%-%TIME% Exit code: %ERRORLEVEL% >> %log_dir%
	for /f "tokens=*" %%a in (%tmp_dir%) do (
  		echo %%a >> %log_dir%
	)
	echo One or more files moved. >> %log_dir%
)

:: Deleting temp file.
if EXIST %tmp_dir% (
	del %tmp_dir%
)

EXIT /B