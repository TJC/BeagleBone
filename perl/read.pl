#!/usr/bin/env perl
use 5.14.1;
use warnings;
use BeagleBone::Pins;
use Time::HiRes qw(usleep);

say "This simply reads the value from P9_21 and graphs it.";

my $pin = BeagleBone::Pins->new('P9_21');
say "Mux: " . $pin->mux;
say "GPIO: " . $pin->gpio;
sleep 1;

while (1) {
    my $v = $pin->digitalRead;
    given ($v) {
        when (0) {
            say "*";
        }
        when (1) {
            say "****************";
        }
    }
    usleep(100);
}
