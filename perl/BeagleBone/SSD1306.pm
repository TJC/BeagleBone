package BeagleBone::SSD1306;
use 5.14.1;
use warnings;
use BeagleBone::Pins;
use Time::HiRes qw(usleep);

# This is meant to be a driver for the SSD1306 LCD controller.
# See http://www.adafruit.com/datasheets/SSD1306.pdf

# TODO: Allow these to be defined via parameters:
my $data = BeagleBone::Pins->new('P9_11');
my $clk = BeagleBone::Pins->new('P9_13');
my $dc = BeagleBone::Pins->new('P9_15');
my $rst = BeagleBone::Pins->new('P9_17');
my $cs = BeagleBone::Pins->new('P9_19');

sub new {
    my ($class, %args) = @_;
    my $self = {};
    bless $self, $class;
    $self->init_display;
    return $self;
}

sub init_display {
    my $self = shift;

    # Using very paranoid delays here!
    $rst->digitalWrite(1);
    usleep(10000);
    $rst->digitalWrite(0);
    usleep(10000);
    $rst->digitalWrite(1);
    usleep(10000);


    # this part totally cloned from:
    # https://github.com/adafruit/Adafruit_SSD1306
    writeByte(0xAE, 'cmd');
    writeByte(0xD5, 'cmd');
    writeByte(0x80, 'cmd');
    writeByte(0xA8, 'cmd');
    writeByte(0x1F, 'cmd');
    writeByte(0xD3, 'cmd');
    writeByte(0x00, 'cmd');
    writeByte(0x8D, 'cmd'); # enable chargepump regulator
    writeByte(0x14, 'cmd'); # turn on. (off= 0x10 if external power?)

    writeByte(0xDA, 'cmd');
    writeByte(0x02, 'cmd');
    writeByte(0x81, 'cmd');
    writeByte(0x8F, 'cmd');

    writeByte(0xD9, 'cmd');
    writeByte(0xF1, 'cmd'); # 0x22 if ext power?

    writeByte(0xDB, 'cmd');
    writeByte(0x40, 'cmd');

    # Setup memory addressing mode, to horizontal
    writeByte(0x20, 'cmd');

    writeByte(0xA4, 'cmd');
    writeByte(0xA6, 'cmd');

    writeByte(0xAF, 'cmd'); # Display on
}

# byte = byte to write to chip
# mode = screen data or command
# TODO: Convert to using SPI via kernel.. much more efficient.
sub writeByte {
    my ($byte, $mode) = @_;
    $mode //= 'data';

    # Wow, this is crazily inefficient :(
    my @bits = split('', unpack('B8', pack('C', $byte)));

    $cs->digitalWrite(1);
    $clk->digitalWrite(0);
    $dc->digitalWrite($mode eq 'cmd' ? 0 : 1 ); 
    $cs->digitalWrite(0);

    # usleep(1);

    map {
        $data->digitalWrite($_);
        $clk->digitalWrite(1);
        $clk->digitalWrite(0);
    } @bits;

    $cs->digitalWrite(1);
    # Done!
}

sub pixels {
    my $self = shift;
    writeByte(shift, 'data');
}

1;
