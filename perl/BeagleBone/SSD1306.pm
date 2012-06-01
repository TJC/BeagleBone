package BeagleBone::SSD1306;
use 5.14.1;
use warnings;
use BeagleBone::Pins;
use BeagleBone::SPI;
use Time::HiRes qw(usleep);
use Carp qw(croak);
use parent qw(Class::Accessor::Fast);
__PACKAGE__->mk_accessors(qw(dc_pin rst_pin));

=head1 NAME

BeagleBone::SSD1306

=head1 SYNOPSIS

This is a driver for the SSD1306 LCD controller, for use from the BeagleBone.
That said, it would probably work on other similar systems.

See http://www.adafruit.com/datasheets/SSD1306.pdf for the LCD controller
datasheet.

Note that this driver requires the LCD controller's SPI pins (clk, cs, data) to
be hooked up to the spi1 pins on the beaglebone, and for you to be using a
distro with the spidev patches applied to the kernel.

The ubuntu 12.04 distro seems to have them already applied. Angstrom probably
does too -- check for existence of /dev/spidev2.0

=head1 METHODS

=cut

=head2 new

Constructor.

Takes arguments for dc_pin and rst_pin.

  my $lcd = BeagleBone::SSD1306->new(
    dc_pin => 'P9_15',
    rst_pin => 'P9_17',
  );

=cut

sub new {
    my ($class, %args) = @_;
    my $self = {};
    bless $self, $class;
    $self->dc_pin( BeagleBone::Pins->new($args{dc_pin} || 'P8_05') );
    $self->rst_pin( BeagleBone::Pins->new($args{rst_pin} || 'P8_03') );
    $self->init_display;
    return $self;
}

=head2 init_display

Initialises the display.

Automatically called by new().

=cut

sub init_display {
    my $self = shift;

    # Using very paranoid delays here!
    $self->rst_pin->digitalWrite(1);
    usleep(1000);
    $self->rst_pin->digitalWrite(0);
    usleep(10000);
    $self->rst_pin->digitalWrite(1);
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

=head2 writeByte

Writes a single byte to the LCD controller. Can be either 'data' or 'cmd'
(command).

Examples:

  $lcd->writeByte(0x255, 'data'); # write 8 solid pixels
  $lcd->writeByte(0xAF, 'cmd');   # Turns on screen if it was off..

=cut

sub writeByte {
    my ($self, $byte, $mode) = @_;
    $mode //= 'data';

    # This can't be efficient :(
    my @bits = split('', unpack('B8', pack('C', $byte)));

    $self->dc_pin->digitalWrite($mode eq 'cmd' ? 0 : 1 ); 

    BeagleBone::SPI->SpiWrite([$byte]);

    # Done!
}

=head2 writeBulk

Method to write an entire buffer of data to the controller

Assumes it's all data, no commands.

$bytes should be an array-reference

Example:

  # Fill screen with static:
  my @buf = map { int(rand(255)) } (0..511);
  $lcd->writeBulk(\@buf);

=cut

sub writeBulk {
    my ($self, $bytes) = @_;
    croak "\$bytes param should be array-ref"
        unless (ref $bytes eq 'ARRAY');

    $self->dc_pin->digitalWrite(1); # data, not command
    BeagleBone::SPI->SpiWrite($bytes);
}

=head2 display_normal

Sets display to normal mode -- opposite of inverse.

=cut

sub display_normal {
    my $self = shift;
    $self->writeByte(0xA6, 'cmd');
}

=head2 display_inverse

Switch to inverse display mode. (ie. Black on white)

=cut

sub display_inverse {
    my $self = shift;
    $self->writeByte(0xA7, 'cmd');
}

=head1 AUTHOR

Toby Corkindale (tjc @ wintrmute dot net)

=cut

1;
