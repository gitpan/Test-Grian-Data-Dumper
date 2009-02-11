# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Test-Grian-Data-Dumper.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More 'no_plan'; 
use strict;
use warnings;
use bytes;


our $big_endian = (pack ("n", 1) eq pack ("s", 1));
my @numbers;
{
    local $/;
    open FH, "<t/x-numbers-IEEE.dump" or warn "no IEEE test";
    binmode(FH);
    my $s = <FH>;
    @numbers = unpack "(w/a)*", $s;
    #print STDERR scalar @numbers, "\n";
    close(FH);
}

sub unpack_rec{
    my $rec = shift;
    my @r = unpack "w/aw/ann", $rec;
    $r[0] = reverse $r[0] unless ($big_endian);
    $r[0] = unpack "d", $r[0];
    return (@r)[0..3];
}
my ($x, $y, $z, $decimal);
while(@numbers){
    local $_;
    ($x, $y, $_, $decimal) = unpack_rec shift @numbers;
    ok ( $y=~m/$_$/, " $x : $y ($decimal)");
    is( length($x), length($y), " $x : $y ($decimal)  length");
    $z = eval $y;
    ok ( $z=~m/$_$/, " $z : $y ($decimal) eval");
    is( length($z), length($y), " $z : $y ($decimal)  length eval");
}
