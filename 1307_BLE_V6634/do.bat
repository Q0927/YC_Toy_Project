@set FPGA_PATH=fpgajic\fpga
@set ROM_PATH=.
@set MV_PATCH=mv\src\yichip
@set YC_PATCH_FILE=yc_patch_yc1021.h
@set enc=1
@set enckey=0000000000000000
@set device_option=1307_BLE
@rem set device_option=1307_24G
@echo off

setlocal enabledelayedexpansion
if "%1" equ "getsvn" (
	svn revert -R .
	svn up
	call util\getsvn.bat
	goto end
)

for /f %%f in ('dir /b /o program_patch\*.prog') do @if not %%f==main_patch.prog set progs_patch=!progs_patch! program_patch\%%f
if "%device_option%" equ "1307_BLE" (
for /f %%f in ('dir /b /o program_patch\1307_BLE\*.prog') do @if not %%f==macro_define_ble.prog set progs_patch=!progs_patch! program_patch\1307_BLE\%%f
for /f %%f in ('dir /b /o format_patch\1307_BLE\*.format') do set fmts=!fmts! format_patch\1307_BLE\%%f
set marco_def=program_patch\1307_BLE\macro_define_ble.prog
)else if "%device_option%" equ "1307_24G" (
for /f %%f in ('dir /b /o program_patch\1307_24G\*.prog') do  @if not %%f==macro_define_24g.prog set progs_patch=!progs_patch! program_patch\1307_24G\%%f
for /f %%f in ('dir /b /o format_patch\1307_24G\*.format') do set fmts=!fmts! format_patch\1307_24G\%%f
set marco_def=program_patch\1307_24G\macro_define_24g.prog
)
type !marco_def! program_patch\main_patch.prog !progs_patch! > program\patch.prog
copy program\patch_sdk.prog + program\patch.prog output\bt_program23.meta

for /f %%f in ('dir /b /o format_patch\*.format') do @if not %%f==patch_format.format @if not %%f==patch_memalloc_end.format @set fmts=!fmts! format_patch\%%f
type format\rom.format format_patch\patch_format.format %fmts% format_patch\patch_memalloc_end.format format\labels.format format\command.format > output\bt_format.meta
::perl util/memalloc.pl output/bt_format.meta

if "%device_option%" equ "1307_24G" (
  copy sched\1307_sys.dat + sched\1307_24G\1307_24g.dat output\sched.rom
) else if "%device_option%" equ "1307_BLE" (
  copy sched\1307_sys.dat + sched\1307_BLE\1307_ble.dat output\sched.rom
) else (

cd ..
echo **********************************
echo Error: illegal device_option !
echo **********************************
goto end
) 

perl util/mergepatch.pl 

cd output
osiuasm bt_program23 -O-W

cd..
del program\patch.prog
cd output

geneep -n 


::geneep -n -s
::cd ..\util
::rem config UCODE_FLAG
::perl setUcodeFlag.pl 80

::create otp.dat
cd ..\output
copy eeprom.dat ..\util\otp1.dat
cd ..\util
perl eeprom2otp.pl otp1.dat otp.dat
copy otp.dat ..\output\otp.dat
del otp1.dat
del otp.dat

::otp lock offset
::cd ..\util
::perl setOtpOffset.pl 19


if "%device_option%" equ "mouse" (
cd ..\output
copy eeprom.dat ..\util\eeprom.dat
cd ..\util
eeprom2fulleeprom.exe eeprom.dat 64>compare2.dat
crc16.exe compare2.dat 2 >..\output\eeprom.dat
del eeprom.dat
del compare2.dat
cd ..\output
copy eeprom.dat ..\output\flash.dat 

)


if "%device_option%" equ "module" (
	cd ..\output
	perl eeprom2hciimage_1021s.pl 
	 perl bin2array.pl > bt_patch.h
)


:end

