#!/usr/bin/env perl
use 5.14.1;
use warnings;
use BeagleBone::SSD1306;

my @ay = qw(0 30 112 144 112 30 0 0);
# 0 0 0 0 0 0 0 0
# 0 0 0 1 1 1 1 0
# 0 1 1 1 0 0 0 0
# 1 0 0 1 0 0 0 0 
# 0 1 1 1 0 0 0 0
# 0 0 0 1 1 1 1 0
# 0 0 0 0 0 0 0 0
# 0 0 0 0 0 0 0 0

my @zed = qw(0 66 98 82 74 70 66 0);
# 0 0 0 0 0 0 0 0     0
# 0 1 0 0 0 0 1 0    66
# 0 1 1 0 0 0 1 0    98
# 0 1 0 1 0 0 1 0    82
# 0 1 0 0 1 0 1 0    74
# 0 1 0 0 0 1 1 0    70
# 0 1 0 0 0 0 1 0    66
# 0 0 0 0 0 0 0 0     0

my $lcd = BeagleBone::SSD1306->new;
while (1) {
    if (rand() > 0.5) {
        $lcd->writeByte($_, 'data') for @ay;
    }
    else {
        $lcd->writeByte($_, 'data') for @zed;
    }
}

