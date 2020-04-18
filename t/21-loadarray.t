#!perl -T

use Test::More;

use CircularBuffer;

{
    #  Create a buffer, check that it's OK and empty.

    my $size   = 12;
    my $buffer = CircularBuffer->new( { size => $size } );
    ok( defined($buffer), 'Buffer created' );
    is( $buffer->space, $size, 'Check size at start' );

    my @values = ( 1 .. $size );

    #  Put a known number of values into the buffer, then fetch each value and
    #  check that each one is correct. Then check that the buffer's empty.

    for my $count ( 0 .. $size - 1 ) {

        cmp_ok( $buffer->space, '>=', $count, "Check space" );
        ok( $buffer->put( @values[ 0 .. $count ] ), "Stored $count values" );

        for my $inner ( 1 .. $count + 1 ) {

            is( $buffer->get, $inner, "Get $inner from buffer" );
        }
        is( $buffer->space, $size, 'Check size at end of loop' );
    }

    #  Final check that the buffer's empty.

    is( $buffer->space, $size, 'Check size at end' );

    done_testing;
}
