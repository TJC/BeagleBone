#!/usr/bin/env perl
use 5.14.1;
use warnings;
use BeagleBone::Pins;

say "This simply blinks power through the P9_11 pin at 1 Hz";

my $pin = BeagleBone::Pins->new('P9_11');
say "Mux: " . $pin->mux;
say "GPIO: " . $pin->gpio;

while (1) {
    $pin->digitalWrite(1);
    sleep 1;
    $pin->digitalWrite(0);
    sleep 1;
}
