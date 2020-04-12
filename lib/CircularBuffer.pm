package CircularBuffer;

use warnings;
use strict;

our $VERSION = '0.01';
my $default_size = 10;

sub new {
    my ( $class, $args ) = @_;

    my $self = {
      in   => 0,
      out  => 0,
      full => 0,
      data => [],
      size => $args->{size} // $default_size
    };
    bless $self, $class;
    return $self;
}

sub put {
    my ( $self, $data ) = @_;
    if ( $self->{full} ) {
        return 0;
    }
    else {
        $self->{data}->[ $self->{in}++ ] = $data;
        if ( $self->{in} == $self->{size} ) {
            $self->{in} = 0;
        }
        if ( $self->{in} == $self->{out} ) {
            $self->{full} = 1;
        }
    }
    return 1;
}

sub get {
    my ($self) = @_;
    my $data;

    if ( $self->{in} == $self->{out} && !$self->{full} ) {
        return undef;
    }
    else {
        $data = $self->{data}->[ $self->{out}++ ];
        if ( $self->{out} == $self->{size} ) {
            $self->{out} = 0;
        }
        $self->{full} = 0;
    }
    return $data;
}

=head1 NAME

CircularBuffer - The great new CircularBuffer!

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use CircularBuffer;

    my $foo = CircularBuffer->new();
    ...

=head1 METHODS

=head2 new

This creates a new circular buffer. The stock size is 10 entries, but this size
can be specified in the constructor.

=head2 put

This puts something into the circular buffer.
Returns 1 on success, 0 on failure.

=head2 get

This gets the first available itm from the circular buffer.
Returns data on success, undef on failure.

=head1 AUTHOR

T. Alex Beamish, C<< <talexb at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-circularbuffer at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CircularBuffer>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CircularBuffer


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=CircularBuffer>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/CircularBuffer>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/CircularBuffer>

=item * Search CPAN

L<http://search.cpan.org/dist/CircularBuffer/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 T. Alex Beamish.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;    # End of CircularBuffer
