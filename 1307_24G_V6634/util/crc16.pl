$debug = 0;
$crc = 0xffff;
$i = 0;
$offset = 0xffff;
$source_file = $ARGV[0];
$offset = $ARGV[1];

open(EEP,"$source_file") or die $!;

while (<EEP>) {    
	$c = hex();

  if($i >= $offset){
  	if($debug){printf "%02x\t", $c;}
  	$crc  = ($crc >> 8) | ($crc << 8);
		$crc ^= $c & 0xff;
		$crc ^= ($crc & 0xff) >> 4;
		$crc ^= $crc << 12;
		$crc ^= ($crc & 0xff) << 5;
		$crc &= 0xffff;
  }
  $i ++;
  if($debug){printf "%02x\t", $crc;}
  printf "%02x\n", $c;
}

printf "%02x\n%02x\n", (($crc >> 8) & 0xff),($crc & 0xff);
