#!perl -T

use Test::More;

use CircularBuffer;

#  Try default size of ten.

{
    my $size = 15;

    my $buffer = CircularBuffer->new( { size => $size } );
    ok( defined($buffer), 'Buffer created' );

    can_ok( 'CircularBuffer', qw/space/ );
    is ( $buffer->space, $size, 'Empty buffer has all the space' );

    done_testing;
}
