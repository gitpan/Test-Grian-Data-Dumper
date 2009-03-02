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
    while($s=~s/^(.{32})//s){
        push @numbers , $1;

    }#grep { defined $_ } split /(.{32})/s, $s;
    print STDERR scalar @numbers, "\n";
    close(FH);
}

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
my ($x, $y, $z, $decimal);
while(@numbers){
    local $_;
    ($x, $y, $_, $decimal) = unpack_rec shift @numbers;
    is(pack('d',$x), pack('d', $y), "packet comply with IEEE for $y");
    $z = eval $y;
    is(pack('d',$x), pack('d', $y), "packet comply with IEEE for $y eval");
}
