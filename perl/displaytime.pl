#!/usr/bin/env perl
use 5.14.1;
use warnings;
use BeagleBone::SSD1306;
use BeagleBone::Font::8x8;
use DateTime;

my $lcd = BeagleBone::SSD1306->new;

while (1) {
    my @buffer = map { 0 } (0..512);
    my $count = 0;
    #my $date = `date`; chomp ($date);
    my $date = DateTime->now;
    for my $c (split('', $date)) {
        my $char = BeagleBone::Font::8x8->charpixels($c);
        for (0..7) {
            $buffer[$count * 8 + $_] = $char->[$_];
        }
        $count++;
    }
    $lcd->writeBulk(\@buffer);
}

