# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Test-Grian-Data-Dumper.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More 'no_plan'; 
use strict;
use warnings;

our $big_endian = (pack ("n", 1) eq pack ("s", 1));
my @numbers;
sub pack_rec{
    my ($f , $s, $last_digit, $decimal) = @_;
    my $df = pack "d", $f;
    $df = reverse $df unless $big_endian;

    pack "a32", (pack "a8a20nn", $df, $s, $last_digit, $decimal);
}

sub unpack_rec{
    my $rec = shift;
    my @r = unpack "a8a20nn", $rec;
    $r[1]=~s/\0.*//s;
    $r[0] = reverse $r[0] unless ($big_endian);
    $r[0] = unpack "d", $r[0];
    return (@r)[0..3];
}
for my $decimal (0..14){
    my $s = ("9" x (14-$decimal)) . ".".  ("9" x $decimal);
    my ($x);
    for (0..9){
# + number
        $x = 0 + ($s . $_);
        push @numbers , pack_rec($x, $x."", $_, $decimal);
        $x = 0 - ($s . $_);
        push @numbers ,  pack_rec( $x, $x."", $_, $decimal);

    }
}
#print scalar @numbers, "\n";
#~  open FH, ">t/x-numbers-IEEE.dump" or warn "no IEEE test";
#~  binmode(FH);
#~  print FH join "", @numbers;
#~  close(FH);
#print scalar @numbers, "\n";

my ($x, $y, $z, $decimal);
while(@numbers){
    local $_;
    ($x, $y, $_, $decimal) = unpack_rec shift @numbers;
    $_=9 if ($_ == 0);
    ok ( $y=~m/$_$/, " $x (df): $y ($decimal)");
    is( length($x), length($y), " $x : $y ($decimal)length");
    $z = eval $y;
    ok ( $z=~m/$_$/, " $z (eval df) : $y ($decimal)");
    is( length($z), length($y), " $z : $y ($decimal)length");
}


#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

