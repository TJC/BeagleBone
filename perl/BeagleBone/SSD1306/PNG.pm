package BeagleBone::SSD1306::PNG;
use 5.14.1;
use warnings;
use parent 'BeagleBone::SSD1306';
use Image::PNG;

=head1 NAME

BeagleBone::SSD1306::PNG

=head1 SYNOPSIS

Displays a 128x32 monochrome PNG image on the LCD screen.

You can make an appropriate file by running:

  convert input.jpg -adaptive-resize 128x32 -monochrome output.png

Example:

  my $lcd = BeagleBone::SSD1306::PNG->new;
  $lcd->display_png('tiny.png');

=cut

sub display_png {
    my ($self, $filename) = @_;
    die "File ($filename) not available" unless ($filename and -r $filename);

    my $png = Image::PNG->new;
    $png->read('tiny.png');
    say "Image width: " . $png->width;
    say "Image height: " . $png->height;
    say "Bit depth: " . $png->bit_depth;
    say "Row bytes: " . $png->rowbytes;

    die "Only works with monochrome images" unless $png->bit_depth == 1;

    # Need to calculate value of 8 pixels in a column, but we get given pixels
    # as a hex value 8 across :(

    my @buf;
    my $rows = $png->rows;
    for (@$rows) {
        push @buf, unpack('B*', $_);
    }

    my @final;
    for my $row (0..3) {
        for my $col (0..127) {
            my @tmp = reverse map { substr($buf[$_], $col, 1) } ($row*8 .. ($row*8)+7);
            my $val = unpack('C', pack('B8', join('', @tmp)));
            push @final, $val;
        }
    }

    my $lcd = BeagleBone::SSD1306->new;
    $lcd->writeBulk(\@final);
}

1;
