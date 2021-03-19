::
:: ------> Empty Folder Check Script <------
:: Script that checks if a folder is empty. If folder contains any file, executes code.
::
:: Written by Ian Yeoh, last updated 19/03/2021
::

::
:: -----> SCRIPT VARIABLES <------
:: Change as needed, format as follows -> SET "VARIABLE_NAME=VALUE" 
::

::
:: --> Directory Path <--
::
	SET "path=..\errlog"  :: Path to folder that script will check
			      :: Some useful relative paths :
			      ::   .\   =    Home directory, the directory this script is placed
			      ::   ..   =    The directory one level higher than the home directory
			      ::   \    =    Root directory, highest level on the drive

::
:: --> Program to Execute Path <--
::
	SET "execute_path=.\smtpscript.exe"

:: -----> Script <-----

@echo off

:: For loop through %path% directory, if there is a file GOTO :not_empty.
:: If loop is exited naturally (i.e. no file present), GOTO :EOF (terminate script)
for /F %%i in ('dir /b /a "%path%"') do (
  GOTO :not_empty
) 
GOTO :EOF

:not_empty :: Code to be executed if directory is not empty.
start %execute_path%