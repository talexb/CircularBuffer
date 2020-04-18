package CircularBuffer;

use warnings;
use strict;

our $VERSION = '0.02';
my $default_size = 10;

sub new {
    my ( $class, $args ) = @_;

    #  A size of less than one (zero, or a negative number) doesn't make sense.
    #  Similarly, a non-integer size doesn't make sense.

    my $size = $default_size;
    if ( exists $args->{size} ) {

        if ( $args->{size} < 1 ) { return undef; }
        else {

            $size = int( $args->{size} ) // $default_size;
        }
    }

    my $self = {
      in   => 0,
      out  => 0,
      full => 0,
      data => [],
      size => $size,
    };
    bless $self, $class;
    return $self;
}

sub put {
    my ( $self, @array ) = @_;

    if ( $self->{full} ) {
        return 0;
    }
    else {

        #  Let's make sure there's space.

        if ( @array > $self->space ) { return 0; }

        #  Don't store the undef value.

        foreach my $data (grep { defined } @array) {

            $self->{data}->[ $self->{in}++ ] = $data;
            if ( $self->{in} == $self->{size} ) {

                $self->{in} = 0;
            }
            if ( $self->{in} == $self->{out} ) {

                $self->{full} = 1;
            }
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

sub space {
    my ($self) = @_;
    my $space;

    if ( $self->{full} ) {
    
        #  If it's full, there's no space.

        $space = 0;
    }
    elsif ( $self->{in} == $self->{out} ) {

        #  If it's not full, and the pointers point to the same place, there's
        #  all the space.

        $space = $self->{size};

    } else {

        #  If the in pointer is below the out pointer, the only the space
        #  between the in and out are free; otherwise, everything outside that
        #  space is free.

        if ( $self->{in} < $self->{out} ) {

            $space = ( $self->{out} - $self->{in} );

        } else {

            $space = $self->{size} - ( $self->{in} - $self->{out} );
        }
    }

    return ( $space );
}

=head1 NAME

CircularBuffer - A simple circular buffer object

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

This module implements a circular buffer, something also known as a FIFO (First
In, First Out) buffer.

Perhaps a little code snippet.

    use CircularBuffer;

    my $cb = CircularBuffer->new();
    ...
    $cb->put ( $some_data ) or die "Failed to store $data";
    ...
    my $this_data = $cb->get;
    if ( defined $this_data ) {
        #  Handle this data ..
    } else {
        #  There was no data in the buffer ..
    }

=head1 METHODS

=head2 new

This creates a new circular buffer. The stock size is 10 entries, but this size
can be specified in the constructor.

=head2 put

This puts one to many objects into the circular buffer.
Note that, because the get function uses undef to signal that there is no data
left in the buffer, it's not possible to store the undef value in a buffer.
Returns 1 on success, 0 on failure.

=head2 get

This gets the first available object from the circular buffer.
Returns data on success, undef on an empty buffer.

=head2 space

This returns how much space there is in the buffer.
If the buffer's full, the answer is zero.
If the buffer's empty, the answer is the size of the buffer.
Otherwise, the space available is calculated based on the in/out pointers, and
which one is less than the other.
Returns the space available.

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
