package BeagleBone::SPI;
use Inline C;
use 5.14.1;
use warnings;
use Carp qw(croak);

sub new {
    my ($class, %args) = @_;
    my $self = {};
    bless $self, $class;
    return $self;
}

# Method to write an entire buffer of data to the controller
# $bytes should be an array-reference
sub SpiWrite {
    my ($self, $bytes) = @_;
    croak "\$bytes param should be array-ref"
        unless (ref $bytes eq 'ARRAY');

    # Convert byte array into appropriate string:
    my $data = join('', map { pack('C', $_) } @$bytes);

    my $length = scalar(@$bytes);

    my $r = c_spi_write($data, $length);
    # warn "spi_write() returned $r\n";
    return $r;
}

1;
__DATA__
__C__
#include <linux/spi/spidev.h>
#include <linux/types.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <errno.h>
#include <stdio.h>
int c_spi_write(unsigned char* bytes, unsigned int length) {
    int i;
    int fd;
    int ret;

    // for debugging:
    // for (i=0; i < length; i++) {
    //    printf("%x ", bytes[i]);
    // }
    // printf("\n");

    // See /usr/include/linux/spi/spidev.h for documentation..

    fd = open("/dev/spidev2.0", O_RDWR);
    if (fd == -1) {
        perror("Error opening /dev/spidev2.0");
        exit(2);
    }

    uint8_t bits = 8;
    uint16_t delay = 1;
    uint32_t speed = 10000000;
    // uint8_t tx[4096];

    struct spi_ioc_transfer tr = {
        .tx_buf = (unsigned long)bytes,
        .rx_buf = NULL,
        .len = length,
        .delay_usecs = delay,
        .speed_hz = speed,
        .bits_per_word = bits,
    };

    ret = ioctl(fd, SPI_IOC_MESSAGE(1), &tr);
    if (ret == -1) {
        perror("failed to send SPI");
        exit(2);
    }
    if (close(fd) == -1) {
        perror("failed to close SPI fiehandle");
        exit(2);
    }
    return ret;
}

