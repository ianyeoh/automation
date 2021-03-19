::
:: ------> Robocopy Script <------
:: Script that copies files from source to destination with changeable filters.
::
:: Written by Ian Yeoh, last updated 19/03/2021
::

:: 
:: -----> SCRIPT VARIABLES <-----
:: Change as needed, format as follows -> SET "VARIABLE_NAME=VALUE"
::

::
:: --> Source Directory <--
::
	SET "source=.."    :: Some useful relative paths :
			   ::   .\   =    Home directory, the directory this script is placed
			   ::   ..   =    The directory one level higher than the home directory
			   ::   \    =    Root directory, highest level on the drive

::
:: --> Destination Directory <--
::
	SET "destination=..\errlog"

::
:: --> Include These Files <--
::
	SET "include_file=*.*" :: Include Files matching these names and file extensions (all (*) wildcard accepted)

::
:: --> Exclude These Files <--
::
	SET "exclude_file=autosend.* autorun_txt.*" :: Exclude files matching these names

::
:: --> Exclude Files Newer/Older Than <--
:: 
	SET "exclude_if=/MINAGE:1"  :: If set to /MINAGE:n, Excludes files newer than n days
				    :: If set to /MAXAGE:n, Excludes files older than n days


::
:: Script Log File Output Directory and File Name
::
	SET "log_name=scriptlog.log"
	SET "log_directory=.\%log_name%"


:: -----> Script <-----
@echo off 
robocopy %source% %destination% %include_file% /XF %exclude_file% %0 %log_name% %exclude_if% /MOV /V /R:10 /W:5 /LOG+:%log_directory%