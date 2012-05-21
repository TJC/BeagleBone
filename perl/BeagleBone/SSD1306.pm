package BeagleBone::SSD1306;
use 5.14.1;
use warnings;
use BeagleBone::Pins;
use BeagleBone::SPI;
use Time::HiRes qw(usleep);
use Carp qw(croak);

# This is meant to be a driver for the SSD1306 LCD controller.
# See http://www.adafruit.com/datasheets/SSD1306.pdf

# TODO: Allow these to be defined via parameters:
#my $data = BeagleBone::Pins->new('P9_11');
#my $clk = BeagleBone::Pins->new('P9_13');
my $dc = BeagleBone::Pins->new('P9_15');
my $rst = BeagleBone::Pins->new('P9_17');
#my $cs = BeagleBone::Pins->new('P9_19');

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
    usleep(1000);
    $rst->digitalWrite(0);
    usleep(10000);
    $rst->digitalWrite(1);
    usleep(10000);


    # this part originally cloned from:
    # https://github.com/adafruit/Adafruit_SSD1306
    # But then modified somewhat.

    $self->writeByte(0xAE, 'cmd');
    $self->writeByte(0xD5, 'cmd');
    $self->writeByte(0x80, 'cmd');
    $self->writeByte(0xA8, 'cmd');
    $self->writeByte(0x1F, 'cmd');
    $self->writeByte(0xD3, 'cmd');
    $self->writeByte(0x00, 'cmd');
    $self->writeByte(0x8D, 'cmd'); # enable chargepump regulator
    $self->writeByte(0x14, 'cmd'); # turn on. (off= 0x10 if external power?)

    $self->writeByte(0xDA, 'cmd');
    $self->writeByte(0x02, 'cmd');
    $self->writeByte(0x81, 'cmd');
    $self->writeByte(0x8F, 'cmd');

    $self->writeByte(0xD9, 'cmd');
    $self->writeByte(0xF1, 'cmd'); # 0x22 if ext power?

    $self->writeByte(0xDB, 'cmd');
    $self->writeByte(0x40, 'cmd');

    # Setup memory addressing mode, to horizontal
    $self->writeByte(0x20, 'cmd');
    $self->writeByte(0x00, 'cmd');

    # Set page range to be 0-3 (for 32px - change to 0-7 if on a 64px panel)
    $self->writeByte(0x22, 'cmd');
    $self->writeByte(0x0, 'cmd');
    $self->writeByte(0x3, 'cmd');

    $self->writeByte(0xA4, 'cmd');

    $self->writeByte(0xAF, 'cmd'); # Display on

    # Clear the screen:
    my @buf = map { 0 } (0..511);
    $self->writeBulk(\@buf);

    return;
}

# byte = byte to write to chip
# mode = screen data or command
# TODO: Convert to using SPI via kernel.. much more efficient.
sub writeByte {
    my ($self, $byte, $mode) = @_;
    $mode //= 'data';

    # This can't be efficient :(
    my @bits = split('', unpack('B8', pack('C', $byte)));

    $dc->digitalWrite($mode eq 'cmd' ? 0 : 1 ); 

    BeagleBone::SPI->SpiWrite([$byte]);

    # Done!
}

# Method to write an entire buffer of data to the controller
# Assumes it's all data, no commands.
# $bytes should be an array-reference
sub writeBulk {
    my ($self, $bytes) = @_;
    croak "\$bytes param should be array-ref"
        unless (ref $bytes eq 'ARRAY');

    $dc->digitalWrite(1); # data, not command
    BeagleBone::SPI->SpiWrite($bytes);
}

sub display_normal {
    my $self = shift;
    $self->writeByte(0xA6, 'cmd');
}

sub display_inverse {
    my $self = shift;
    $self->writeByte(0xA7, 'cmd');
}

1;
