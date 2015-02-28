package Tickit::Widget::Figlet;
# ABSTRACT: render text using Text::FIGlet
use strict;
use warnings;

use parent qw(Tickit::Widget);

our $VERSION = '0.003';

=head1 NAME

Tickit::Widget::Figlet - trivial wrapper around L<Text::FIGlet> for banner rendering

=head1 SYNOPSIS

# EXAMPLE: examples/synopsis.pl

=head1 DESCRIPTION

Provides a minimal implementation for wrapping L<Text::FIGlet>. Essentially just creates
a L<Text::FIGlet> instance and calls C< figify > for rendering into a window.

=begin HTML

<p>Basic rendering:</p>
<p><img src="http://tickit.perlsite.co.uk/cpan-screenshot/tickit-widget-figlet-basic.png" alt="Simple FIGlet rendering with Tickit" width="508" height="78"></p>

=end HTML

=cut

use Text::FIGlet;
use Tickit::Style;
use constant WIDGET_PEN_FROM_STYLE => 1;

BEGIN {
	style_definition base => ;
}

=head1 METHODS

=cut

=head2 new

Creates a new instance.

Named parameters:

=over 4

=item * text - the string to display

=item * font - which font to use

=item * path (optional) - path to load fonts from, will obey $ENV{FIGLIB} by default

=back

Returns the instance.

=cut

sub new {
	my ($class, %args) = @_;
	my $text = delete $args{text};
	my $font = delete $args{font};
	my $path = delete $args{path};
	my $self = $class->SUPER::new(%args);
	$self->{figlet} = Text::FIGlet->new(
		-f => $font,
		(
			defined($path)
			? (-d => $path)
			: (),
		)
	);
	$self->{text} = $text;
	$self
}

=head2 render_to_rb

Handles rendering.

=cut

sub render_to_rb {
	my ($self, $rb, $rect) = @_;
	$rb->clip($rect);
	$rb->clear;

	chomp(my @lines = $self->figlet->figify(
		-A => $self->text
	));
	my $y = 0;
	$rb->text_at($y++, 0, shift(@lines), $self->get_style_pen) while @lines;
}

=head2 text

Returns the current text to display. Pass a new string in to update the rendered text.

 $figlet->text('new text');
 is($figlet->text, 'new text');

=cut

sub text {
	my ($self) = shift;
	return $self->{text} unless @_;
	$self->{text} = shift;
	$self->window->expose if $self->window;
	$self
}

=head2 figlet

Returns the L<Text::FIGlet> instance. Probably a L<Text::FIGlet::Font> subclass.

=cut

sub figlet { shift->{figlet} }

sub lines { 1 }
sub cols { 1 }

1;

__END__

=head1 SEE ALSO

L<Text::FIGlet>, L<http://www.figlet.org/>, L<http://www.jave.de/figlet/fonts.html>

=head1 AUTHOR

Tom Molesworth <cpan@perlsite.co.uk>

=head1 LICENSE

Copyright Tom Molesworth 2015. Licensed under the same terms as Perl itself.

