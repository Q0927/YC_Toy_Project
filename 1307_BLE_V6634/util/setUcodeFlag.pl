#!/usr/bin/perl
#此脚本的目的把eeprom.OTP_OFFSET_UCODE_FLAG改为$ARGV[0]参数的值。
=pod   多行注释
$ARGV[0]：
7 UCODE_FLAG_ENC
6 UCODE_FLAG_SKIP_EEP
5 UCODE_FLAG_SKIP_FLASH
4 UCODE_FLAG_HCI
=cut
use File::Copy;
use File::Path;
use Cwd;

open(OPEN_FILE, "+<../output/eeprom.dat") || die "cannot open file $!";
@file_content=<OPEN_FILE>;

seek OPEN_FILE, 0, 0;
print OPEN_FILE $ARGV[0];

close(OPEN_FILE);
