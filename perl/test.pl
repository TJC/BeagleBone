#!/usr/bin/env perl
use 5.14.1;
use warnings;
use BeagleBone::Pins;

my $id = shift || die "Please specify a pin name (eg. P9_11)\n";

say "This simply blinks power through the given pin at 1 Hz";

my $pin = BeagleBone::Pins->new($id);
say "Mux: " . $pin->mux;
say "GPIO: " . $pin->gpio;

while (1) {
    $pin->digitalWrite(1);
    sleep 1;
    $pin->digitalWrite(0);
    sleep 1;
}
