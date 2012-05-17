#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use Fcntl qw(:DEFAULT);

unless (-w "/sys/class/leds/beaglebone::usr0/brightness") {
    die "I think you need to run this as root..\n";
}

my @leds = map {
    my $tmp;
    sysopen($tmp, "/sys/class/leds/beaglebone::usr$_/brightness", O_WRONLY);
    $tmp;
} (0..3);

print "Hit Ctrl-C to exit..\n";
while (1) {
 
  led(0,0,0,1);
  led(0,0,1,0);
  led(0,1,0,0);
  led(1,0,0,0);
  led(0,1,0,0);
  led(0,0,1,0);
 
}

sub led {
    my @vals = @_;
    for my $i (0..3) {
        syswrite($leds[$i], "$vals[$i]", 1);
    }
    select(undef, undef, undef, 0.05);
}

