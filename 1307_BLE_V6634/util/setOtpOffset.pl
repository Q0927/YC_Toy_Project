#!/usr/bin/perl
#�˽ű���Ŀ����оƬ��¼���豸�����ѵڶ��δ���̼���ƫ�Ƶ�ַ��Ϊ0x32


open(OPEN_FILE,"+<../output/otp.dat") || die "cannot open file $!";

$one=<OPEN_FILE>; #��ȡ��һ�����ݣ�ָ��ָ���ļ��ڶ���
$pos=tell(OPEN_FILE); #��ȡ�ļ�ָ��λ��


seek(OPEN_FILE,$pos,0); #���ļ���ͷ�ƶ�ָ��

print OPEN_FILE $ARGV[0]; #������д���ļ�

close(OPEN_FILE);
