#!perl -T

use Test::More tests => 122;

use CircularBuffer;

{

    #  Create a buffer ..

    my $buffer = CircularBuffer->new;
    ok( defined($buffer), 'Buffer created' );

    #  Make sure it's empty to start off with ..

    my $result = $buffer->get;
    ok( !defined($result), "Buffer empty when it should be" );

    #  Now for a rolling test going down. Have an outter loop that counts from
    #  ten to one, and an inner test that does one to n. This is the same as
    #  the load test, but in a more complex way.

    for my $outter ( 1 .. 10 ) {

	$outter = 11 - $outter;
        for my $inner ( 1 .. $outter ) {

            $result = $buffer->put($inner);
            ok( $result, "Stored $inner" );
        }

        for my $inner ( 1 .. $outter ) {

            my $data = $buffer->get;
            is( $data, $inner, "Retrieved $inner" );
        }
        $result = $buffer->get;
        ok( !defined($result), "Buffer empty when it should be" );
    }
}
