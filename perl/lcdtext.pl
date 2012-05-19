#!/usr/bin/env perl
use 5.14.1;
use warnings;
use BeagleBone::SSD1306;
use BeagleBone::Font::8x8;

my @buffer = map { 0 } (0..512);

my $lcd = BeagleBone::SSD1306->new;

my $count = 0;
for my $i (0..9, 'A'..'Z', 'a'..'z') {
    my $char = BeagleBone::Font::8x8->charpixels($i);
    for (0..7) {
        $buffer[$count * 8 + $_] = $char->[$_];
    }
    $count++;
    # $lcd->writeByte($_, 'data') for @$char;
}
$lcd->writeBulk(\@buffer);

say "Flashing display now.";
while (1) {
    $lcd->display_inverse;
    sleep 1;
    $lcd->display_normal;
    sleep 1;
}


