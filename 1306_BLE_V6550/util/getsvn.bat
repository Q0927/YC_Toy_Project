rem @echo off
set svnpath=format\svn.format
for /f "delims=" %%i in ('svn info ^| findstr "Last" ^| findstr "Changed" ^| findstr "Rev"') do set rev=%%i
echo %rev%
set rev=%rev:~18%
echo %rev%|findstr "^[0-9][0-9]*$"|| goto svnend
echo /*svn revision auto generate*/ >%svnpath%
echo ( >>%svnpath%
set tab=	
echo %tab%%rev%  SVN_REVISON>>%svnpath%
echo ) >>%svnpath%
:svnend
