# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Test-Grian-Data-Dumper.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More 'no_plan'; 
use strict;
use warnings;

our $big_endian = (pack ("n", 1) eq pack ("s", 1));
BEGIN { use_ok('Test::Grian::Data::Dumper') };
my @numbers;
sub pack_rec{
    my ($f , $s, $last_digit, $decimal) = @_;
    my $df = pack "d", $f;
    $df = reverse $df unless $big_endian;
    pack "w/a", (pack "w/aw/ann", $df, $s, $last_digit, $decimal);
}

sub unpack_rec{
    my $rec = shift;
    my @r = unpack "w/aw/ann", $rec;
    $r[0] = reverse $r[0] unless ($big_endian);
    $r[0] = unpack "d", $r[0];
    return (@r)[0..3];
}
for my $decimal (0..14){
    my $s = ("9" x (14-$decimal)) . ".".  ("9" x $decimal);
    my ($x, $y, $z);
    for (1..9){
# + number
        $x = 0 + ($s . $_);
        $y = $x ."";
        push @numbers , pack_rec($x, $y, $_, $decimal);
        ok ( $y=~m/$_$/, " $x : $y ($decimal)");
        is( length($x), length($y), " $x : $y ($decimal)  length");
        $z = eval $y;
        ok ( $z=~m/$_$/, " $z : $y ($decimal) eval");
        is( length($z), length($y), " $z : $y ($decimal)  length eval");


# - number
        $x = 0 - ($s . $_);
        $y = $x ."";
        push @numbers ,  pack_rec( $x, $y, $_, $decimal);
        ok ( $y=~m/$_$/, " $x : $y ($decimal)");
        is( length($x), length($y), " $x : $y ($decimal)  length");

        $z = eval $y;
        ok ( $z=~m/$_$/, " $z : $y ($decimal) eval");
        is( length($z), length($y), " $z : $y ($decimal)  length eval");

    }
    $x = 0 + ($s .'0');
    $y = $x ."";
    ok ( $y=~m/9$/, " $x : $y ($decimal)");
    is( length($x), length($y), " $x : $y ($decimal)  length");
    $z = eval $y;
    ok ( $z=~m/9$/, " $z : $y ($decimal) eval");
    is( length($z), length($y), " $z : $y ($decimal)  length eval");
}
#~ print scalar @numbers, "\n";
#~ open FH, ">t/x-numbers-IEEE.dump" or warn "no IEEE test";
#~ binmode(FH);
#~ print FH join "", @numbers;
#~ close(FH);
#~ my @n = unpack "(w/a)*",join "", @numbers;
#print scalar @numbers, "\n";


#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

