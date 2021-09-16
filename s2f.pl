sto2fas($ARGV[0],$ARGV[1]);
sub sto2fas{
        my $sto = $_[0];
        my $fas = $_[1];
        my @seq;
        my $FAS;
        my $line;
        open(STO,$sto);
        while($line = <STO>){
                chomp($line);
                if(substr($line,0,1) ne "#"){
                        my @tm = split(/ +/,$line);
                        if(exists $tm[1]){
                                my $bob = $tm[1];
                                $FAS .= ">$tm[0]\n$bob\n";
                        }
                }
        }
        close(STO);
        open(FAS,">$fas");
        print FAS $FAS;
        close(FAS);
}