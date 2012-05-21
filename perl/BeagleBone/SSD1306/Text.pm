package BeagleBone::SSD1306::Text;
use 5.14.1;
use warnings;
use parent 'BeagleBone::SSD1306';
use BeagleBone::Font::8x8;

=head1 NAME

BeagleBone::SSD1306::Text

=head1 SYNOPSIS

Displays a text string on the LCD screen.

Example:

  my $lcd = BeagleBone::SSD1306::Text->new;
  $lcd->display_string("Hello world!");

=cut

sub display_string {
    my ($self, $text) = @_;
    if (length $text > 64) {
        warn "String too long, truncating to 64 chars.";
        $text = substr($text, 0, 64);
    }
    my @buffer = map { 0 } (0..511);
    my $pos = 0;
    for my $c (split('', $text)) {
        my $char = BeagleBone::Font::8x8->charpixels($c);
        $buffer[$pos++] = $char->[$_] for (0..7);
    }
    $self->writeBulk(\@buffer);
    return;
}

1;
