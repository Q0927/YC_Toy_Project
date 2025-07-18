#!/usr/bin/perl
use File::Copy;
use File::Path;
use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
use Cwd;
use POSIX qw(strftime);


sub get_svn_version{
	$revisionfile="./format/svn.format";					#版本号文件路径
	$version="V";
	
	open(f_revision,$revisionfile)||die("Can not open the file!$!n");#打开文件
	@content=<f_revision>;												#读取文件并将每一行放到content数组
	close(f_revision);														#关闭文件
	#unlink ($revisionfile); #删除文件

	foreach $eachline(@content){									#执行到列表或集合下个元素不存在时跳过代码块
		   
		   foreach($eachline){
			s/^\s+// ;																#去除首行所有空白
			}
		   $back=index($eachline,"SVN_REVISON");		#返回$eachline中第一次出现SVN_REVISON的位置
			if ( $back > 0 ) {
				@words=split(/\s+/,$eachline); 					#把字符串进行分割并把分割后的结果放入数组中
				$words_size=@words; 										#数组大小
				if($words_size==2) {
					$version=$version . $words[0];				#版本号生成，V+数字
					#print "$version\n"										#打印测试显示版本号
				} 
				
				last;																		#退出循环语句块，结束循环，下一句不再执行
			}
	}
	
}



sub get_localtimer{
	
$datestring = strftime "%y%m%d%H%M%S", localtime;#自定义localtimer格式
#printf("$version - $datestring\n");					 #生成版本号+年月日+时分秒打印测试
}

																							 #以只读方式打开do.bat文件
open(DO_FILE, "<do.bat") || die "cannot open file $!";
@content=<DO_FILE>;
close(DO_FILE);

$i = 0;
$release_lable_flag = 0;
foreach $eachline(@content){
	$_ = $eachline;															 #$_默认参数
	foreach($eachline){
        s/^\s+//;
		}
			
	if(/\@\W*set/ && /device_option/){ 
		$release_lable_flag = 1;
		#print "$eachline\n";
		@words=split(/=/,$eachline); 						   #等号左右两侧分割，如device_option = 1308AC_BLE/n
		chomp($words[1]);   										   #去除字符中的换行符
		$release_lable = $words[1];							 	 #对应数组元素1308AC_BLE
		print "The project is \"$release_lable\"\n";
	}

	
	if($eachline =~ /setlocal/){								 #匹配setlocal，结束循环
		last;
	}
		
}

if ( $release_lable_flag == 0 ) {
	die("No project seletct,please check!");
}

@arr1=split(/_/,$release_lable);							 #下划线两侧分割
@arr2=("1308AC","1307");											 #判断SDK类别

get_svn_version;
get_localtimer;
$directory =Cwd;

$release_dir = $release_lable . "_dat_" . $version . "_" . $datestring;
$source_dir = "output";
																							 #生成新目录
mkdir($release_dir) or die "Create $release_dir error, $!";
mkdir "$release_dir\\output";
mkdir "$release_dir\\debug";
mkdir "$release_dir\\debug\\output";
																							 #拷贝文件内容
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