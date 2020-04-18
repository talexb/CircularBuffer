#!/usr/bin/perl

use Test::More;

use CircularBuffer;

#  Try a buffer size of 15, just to be different.

{
    my $size = 15;

    my $buffer = CircularBuffer->new( { size => $size } );
    ok( defined($buffer), 'Buffer created' );

    can_ok( 'CircularBuffer', qw/space/ );
    is ( $buffer->space, $size, 'Empty buffer has all the space' );

    for my $value ( 0..$size-1 ) {

        ok ( $buffer->put ( $value ), "Stored value $value" );
        my $space = $buffer->space;
        is ( $space, $size-$value-1, "Now $space left" );
    }

    for my $value ( 0..$size-1 ) {

        is ( $buffer->get, $value, "Retrieved value $value" );
        my $space = $buffer->space;
        is ( $space, $value+1, "Now $space left" );
    }
}

{
    my $size = 24;

    my $buffer = CircularBuffer->new( { size => $size } );
    ok( defined($buffer), 'Buffer created' );

    my $space = $size;
    my $value = 1;

    #  This confirms that when the circular buffer wraps around, that we're
    #  doing the space left calculation correctly. We end up adding 109
    #  elements to the buffer, add 1/3 and then taking away 1/4 each time
    #  through the loop. At one point there's not enough space, we skip adding
    #  values.

    for my $loop ( 0 .. $size / 2 ) {

        if ( $buffer->space > $size / 3 ) {

            for my $add ( 0 .. $size / 3 ) {

                ok( $buffer->put( $value++ ), "Add step value $value" );
                $space--;

                is( $buffer->space, $space, "Check space is $space" );
            }
        }

        for my $sub ( 0 .. $size / 4 ) {

            my $ret = $buffer->get;
            cmp_ok( $ret, '<', $value, "Buffer value $ret less than $value" );
            $space++;

            is( $buffer->space, $space, "Check space is $space" );
        }
    }
    done_testing;
}
