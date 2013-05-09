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
P8_03:
    mux: gpmc_ad6
    gpio: 38
P8_05:
    mux: gpmc_ad2
    gpio: 34
P8_21:
    mux: gpmc_csn1
    gpio: 62
P8_23:
    mux: gpmc_ad4
    gpio: 36
P8_25:
    mux: gpmc_ad0
    gpio: 32
P8_27:
    mux: lcd_vsync
    gpio: 86
P8_28:
    mux: lcd_pclk
    gpio: 88
P8_29:
    mux: lcd_hsync
    gpio: 87
P8_30:
    mux: lcd_ac_bias_en
    gpio: 89
P8_32:
    mux: lcd_data15
    gpio: 11
P8_34:
    mux: lcd_data11
    gpio: 81
P8_36:
    mux: lcd_data10
    gpio: 80
P8_38:
    mux: lcd_data9
    gpio: 79
P8_40:
    mux: lcd_data7
    gpio: 77
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
