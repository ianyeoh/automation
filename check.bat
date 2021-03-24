@echo off

:: Directory Path
SET "path=..\errlog" 

:: Program Path
SET "execute_path=.\email.exe"

for /F %%i in ('dir /b /a "%path%"') do (
  GOTO :not_empty
) 
GOTO :EOF

:not_empty
start %execute_path%

EXIT /B