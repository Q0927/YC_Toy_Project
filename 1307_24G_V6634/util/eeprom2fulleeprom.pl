


$source_file = $ARGV[0];
$eeprom_size = $ARGV[1];

open(EEP,"$source_file") or die("cannot open files");
for ($i = 1 ;$i<=$eeprom_size*128-2;$i++)
{

    while (<EEP>) { 
        $c = hex();
        printf "%02x\n", $c;
        $i++;
    }

	printf "FF\n";
}
