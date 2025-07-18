#!/usr/bin/perl
use File::Copy;
use File::Path;
use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
use Cwd;
use POSIX qw(strftime);


sub get_svn_version{
	$revisionfile="./format/svn.format";					#�汾���ļ�·��
	$version="V";
	
	open(f_revision,$revisionfile)||die("Can not open the file!$!n");#���ļ�
	@content=<f_revision>;												#��ȡ�ļ�����ÿһ�зŵ�content����
	close(f_revision);														#�ر��ļ�
	#unlink ($revisionfile); #ɾ���ļ�

	foreach $eachline(@content){									#ִ�е��б�򼯺��¸�Ԫ�ز�����ʱ���������
		   
		   foreach($eachline){
			s/^\s+// ;																#ȥ���������пհ�
			}
		   $back=index($eachline,"SVN_REVISON");		#����$eachline�е�һ�γ���SVN_REVISON��λ��
			if ( $back > 0 ) {
				@words=split(/\s+/,$eachline); 					#���ַ������зָ�ѷָ��Ľ������������
				$words_size=@words; 										#�����С
				if($words_size==2) {
					$version=$version . $words[0];				#�汾�����ɣ�V+����
					#print "$version\n"										#��ӡ������ʾ�汾��
				} 
				
				last;																		#�˳�ѭ�����飬����ѭ������һ�䲻��ִ��
			}
	}
	
}



sub get_localtimer{
	
$datestring = strftime "%y%m%d%H%M%S", localtime;#�Զ���localtimer��ʽ
#printf("$version - $datestring\n");					 #���ɰ汾��+������+ʱ�����ӡ����
}

																							 #��ֻ����ʽ��do.bat�ļ�
open(DO_FILE, "<do.bat") || die "cannot open file $!";
@content=<DO_FILE>;
close(DO_FILE);

$i = 0;
$release_lable_flag = 0;
foreach $eachline(@content){
	$_ = $eachline;															 #$_Ĭ�ϲ���
	foreach($eachline){
        s/^\s+//;
		}
			
	if(/\@\W*set/ && /device_option/){ 
		$release_lable_flag = 1;
		#print "$eachline\n";
		@words=split(/=/,$eachline); 						   #�Ⱥ���������ָ��device_option = 1308AC_BLE/n
		chomp($words[1]);   										   #ȥ���ַ��еĻ��з�
		$release_lable = $words[1];							 	 #��Ӧ����Ԫ��1308AC_BLE
		print "The project is \"$release_lable\"\n";
	}

	
	if($eachline =~ /setlocal/){								 #ƥ��setlocal������ѭ��
		last;
	}
		
}

if ( $release_lable_flag == 0 ) {
	die("No project seletct,please check!");
}

@arr1=split(/_/,$release_lable);							 #�»�������ָ�
@arr2=("1308AC","1307");											 #�ж�SDK���

get_svn_version;
get_localtimer;
$directory =Cwd;

$release_dir = $release_lable . "_dat_" . $version . "_" . $datestring;
$source_dir = "output";
																							 #������Ŀ¼
mkdir($release_dir) or die "Create $release_dir error, $!";
mkdir "$release_dir\\output";
mkdir "$release_dir\\debug";
mkdir "$release_dir\\debug\\output";
																							 #�����ļ�����
$copy_source_file1 = "./output";
$copy_source_file2 = "./output/eeprom.dat";
$copy_source_file3 = "./output/otp.dat";
$copy_source_file4 = "./eep.bat";
$copy_source_file5 = "./eotp.bat";


$copy_aim_file1 = "./$release_dir/debug/output";
$copy_aim_file2 = "./$release_dir/output";
$copy_aim_file3 = "./$release_dir";

dircopy($copy_source_file1,$copy_aim_file1);	

if($arr1[0]==$arr2[0]){												 #1308AC
		copy($copy_source_file2,$copy_aim_file2);
		copy($copy_source_file4,$copy_aim_file3);
}
elsif($arr1[0]==$arr2[1]){										 #1307
		copy($copy_source_file3,$copy_aim_file2);
		copy($copy_source_file5,$copy_aim_file3);
}
else{
		print "output copy error!\n";	
}