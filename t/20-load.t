#!perl -T

use Test::More;

use CircularBuffer;

{
    #  Create a buffer ..

    my $buffer = CircularBuffer->new;
    ok( defined($buffer), 'Buffer created' );

    #  Make sure it's empty to start off with ..

    my $result = $buffer->get;
    is( $result, undef, "Buffer empty when it should be" );

    #  Stuff it full, then make sure adding one more fails ..

    for ( 1 .. 10 ) {
        $result = $buffer->put($_);
        is( $result, 1, "Stored $_" );
    }
    $result = $buffer->put(11);
    is( $result, 0, "Failed to store 11" );

    #  Pull the data out, and make sure it's in the same order as it went in ..

    for ( 1 .. 10 ) {
        my $data = $buffer->get;
        is( $data, $_, "Retrieved $_" );
    }

    #  .. and finally, make sure that the buffer's empty again at the end.

    $result = $buffer->get;
    is( $result, undef, "Buffer empty when it should be" );

    done_testing;
}

