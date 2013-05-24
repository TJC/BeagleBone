#!/usr/bin/env perl
use 5.14.1;
use warnings;
use BeagleBone::SSD1306::Text;

my $lcd = BeagleBone::SSD1306::Text->new;
$lcd->display_string(shift || "Hello world!");


