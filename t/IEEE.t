# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Test-Grian-Data-Dumper.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More 'no_plan'; 
use strict;
use warnings;

my @numbers;
{
    local $/;
    open FH, "<t/x-numbers-IEEE.dump" or warn "no IEEE test";
    binmode(FH);
    @numbers = unpack "(dw/ann)*",<FH>;
    print STDERR scalar @numbers;
    close(FH);
}
my ($x, $y, $z, $decimal);
while(@numbers){
    local $_;
    ($x, $y, $_, $decimal) = splice @numbers, 0, 4;
    ok ( $y=~m/$_$/, " $x : $y ($decimal)");
    is( length($x), length($y), " $x : $y ($decimal)  length");
    $z = eval $y;
    ok ( $z=~m/$_$/, " $z : $y ($decimal) eval");
    is( length($z), length($y), " $z : $y ($decimal)  length eval");
}
