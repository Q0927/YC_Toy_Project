#!/usr/bin/perl
#此脚本的目的是芯片烧录了设备锁，把第二段代码固件的偏移地址设为0x32


open(OPEN_FILE,"+<../output/otp.dat") || die "cannot open file $!";

$one=<OPEN_FILE>; #获取第一行数据，指针指向文件第二行
$pos=tell(OPEN_FILE); #获取文件指针位置


seek(OPEN_FILE,$pos,0); #从文件开头移动指针

print OPEN_FILE $ARGV[0]; #将参数写入文件

close(OPEN_FILE);
