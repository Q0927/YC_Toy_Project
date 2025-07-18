@set FPGA_PATH=fpgajic\fpga
@set ROM_PATH=.
@set MV_PATCH=mv\src\yichip
@set YC_PATCH_FILE=yc_patch_yc1021.h
@set enc=1
@set enckey=0000000000000000

@echo off
@rem set device_option=1306_BLE
@set device_option=1306_24G

setlocal enabledelayedexpansion
if "%1" equ "getsvn" (
	svn revert -R .
	svn up
	call util\getsvn.bat
	goto end
)

for /f %%f in ('dir /b /o program_patch\*.prog') do @if not %%f==main_patch.prog set progs_patch=!progs_patch! program_patch\%%f

if "%device_option%" equ "1306_BLE" (
for /f %%f in ('dir /b /o program_patch\1306_BLE\*.prog') do @if not %%f==macro_define_ble.prog set progs_patch=!progs_patch! program_patch\1306_BLE\%%f
for /f %%f in ('dir /b /o format_patch\1306_BLE\*.format') do set fmts=!fmts! format_patch\1306_BLE\%%f
set marco_def=program_patch\1306_BLE\macro_define_ble.prog
)else if "%device_option%" equ "1306_24G" (
for /f %%f in ('dir /b /o program_patch\1306_24G\*.prog') do  @if not %%f==macro_define_24g.prog set progs_patch=!progs_patch! program_patch\1306_24G\%%f
for /f %%f in ('dir /b /o format_patch\1306_24G\*.format') do set fmts=!fmts! format_patch\1306_24G\%%f
set marco_def=program_patch\1306_24G\macro_define_24g.prog
)
type %marco_def% program_patch\main_patch.prog %progs_patch% > program\patch.prog
type program\patch_sdk.prog program\patch.prog > output\bt_program23.meta


for /f %%f in ('dir /b /o format_patch\*.format') do @if not %%f==patch_format.format @if not %%f==patch_memalloc_end.format @set fmts=!fmts! format_patch\%%f
type format\rom.format format_patch\patch_format.format %fmts% format_patch\patch_memalloc_end.format format\labels.format format\command.format > output\bt_format.meta


if "%device_option%" equ "1306_24G" (
   copy sched\1306.dat + sched\1306_24G\1306_24g.dat output\sched.rom
) else if "%device_option%" equ "1306_BLE" (
   copy sched\1306.dat + sched\1306_BLE\1306_ble.dat output\sched.rom
)else (

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
copy eeprom.dat ..\output\otp.dat 


echo create auth rom





:end

