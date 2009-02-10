# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Test-Grian-Data-Dumper.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More 'no_plan'; 
use strict;
use warnings;

BEGIN { use_ok('Test::Grian::Data::Dumper') };
my @numbers;

for my $decimal (0..14){
    my $s = ("9" x (14-$decimal)) . ".".  ("9" x $decimal);
    my ($x, $y, $z);
    for (1..9){
# + number
        $x = 0 + ($s . $_);
        $y = $x ."";
        push @numbers , pack "dw/ann", $x, $y, $_, $decimal;
        ok ( $y=~m/$_$/, " $x : $y ($decimal)");
        is( length($x), length($y), " $x : $y ($decimal)  length");
        $z = eval $y;
        ok ( $z=~m/$_$/, " $z : $y ($decimal) eval");
        is( length($z), length($y), " $z : $y ($decimal)  length eval");


# - number
        $x = 0 - ($s . $_);
        $y = $x ."";
        push @numbers ,  pack "dw/ann", $x, $y, $_, $decimal;
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
#~ open FH, ">t/x-numbers-IEEE.dump" or warn "no IEEE test";
#~ binmode(FH);
#~ print FH join "", @numbers;
#~ close(FH);
#print scalar @numbers, "\n";


#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

