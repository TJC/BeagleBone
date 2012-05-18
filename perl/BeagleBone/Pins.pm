package BeagleBone::Pins;
use 5.14.1;
use warnings;
use YAML::Tiny;
use BeagleBone::Pin;

our $data;

sub import {
    # $data = YAML::XS::Load(join('',<DATA>));
    my $tmp = YAML::Tiny->read_string(join('',<DATA>));
    $data = $tmp->[0];
}

sub new {
    my ($class, $id) = @_;
    die "Pin $id not yet defined\n" unless exists $data->{$id};
    return BeagleBone::Pin->new(
        $data->{$id}
    );
}

# TODO: Just import the JSON from here:
# https://github.com/jadonk/bonescript/blob/master/bonescript/bone.js

1;
__DATA__
---
P9_1:
    desc: GND
P9_2:
    desc: GND
P9_3:
    desc: DC_3V3
P9_4:
    desc: DC_3V3
P9_5:
    desc: VDD_5V
P9_6:
    desc: VDD_5V
P9_7:
    desc: SYS_5V
P9_8:
    desc: SYS_5V
P9_9:
    desc: PWR_BUT
P9_10:
    desc: RESET_OUT
P9_11:
    mux: gpmc_wait0
    gpio: 30
P9_12:
    mux: gpmc_ben1
    gpio: 40
P9_13:
    mux: gpmc_wpn
    gpio: 31
P9_14:
    mux: gpmc_a2
    gpio: 50
P9_15:
    mux: gpmc_a0
    gpio: 48
P9_16:
    mux: gpmc_a3
    gpio: 51
P9_17:
    mux: spi0_cs0
    gpio: 5
P9_18:
    mux: spi0_d1
    gpio: 4
P9_19:
    mux: uart1_rtsn
    gpio: 13
P9_20:
    mux: spi0_d0
    gpio: 12
P9_21:
    mux: spi0_d0
    gpio: 3
P9_22:
    mux: spi0_sclk
    gpio: 2
P9_23:
    mux: gpmc_a1
    gpio: 49
P9_24:
    mux: uart1_txd
    gpio: 15

