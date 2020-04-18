#!perl -T

use Test::More;

use CircularBuffer;

{
    #  Create a buffer ..

    my $size   = 12;
    my $buffer = CircularBuffer->new( { size => $size } );
    ok( defined($buffer), 'Buffer created' );

    my @values = ( 1 .. $size );

  TODO: {
        local $TODO = 'Site of future development';
        for my $count ( 0 .. $size - 1 ) {

            cmp_ok( $buffer->space, '>=', $count, "Check space" );
            ok( $buffer->put( @values[ 0 .. $count ] ),
                "Stored $count values" );

            for my $inner ( 0 .. $count + 1 ) {

                is( $buffer->get, $inner, "Get $inner from buffer" );
            }
        }
    }

    done_testing;
}
