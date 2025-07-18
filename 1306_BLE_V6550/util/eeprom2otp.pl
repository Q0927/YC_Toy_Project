
#改前三个字节为0200；
#输入一个文件，输出一个文件；

if(@ARGV < 2) {
	printf "less files\n";
	exit;
}
else{
	open(file, $ARGV[0]) or die "Can't open  file  : $!"; 
	open(file_out, ">$ARGV[1]")or die "Can't open out file  : $!"; 
	@lines = <file>;
	$length = @lines;
	
	my $j=2;
	print file_out "00\n01\n";
	while($j<$length){
			print file_out "$lines[$j]";
			$j++;
	}
#	print "----- reverse end -----";
	close(file);
	close(file_out);
}
