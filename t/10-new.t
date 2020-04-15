#!perl -T

use Test::More;

use CircularBuffer;

#  Try default size of ten.

{
    my $buffer = CircularBuffer->new;
    ok( defined($buffer), 'Buffer created' );

    my $data = $buffer->get;
    ok( !defined($data), 'New buffer is empty' );
}

#  Try a variety of larger sizes.

{
    foreach my $size ( 20, 200, 2_000, 20_000 ) {

        my $buffer = CircularBuffer->new( { size => $size } );
        ok( defined($buffer), 'Buffer created' );

        if ( defined $buffer ) {
            my $data = $buffer->get;
            ok( !defined($data), 'New buffer is empty' );
        }

        #  Try to fill up new, non-standard sized buffer.

        for my $value ( 1 .. $size ) {

            ok( $buffer->put($value), "Store $value" );
        }
        is( $buffer->put( $size + 1 ),
            0, "Unable to store one more than capacity" );

    }
}

#  Try to create a zero size buffer.

{
    my $buffer = CircularBuffer->new( { size => 0 } );
    ok( !defined($buffer), 'Buffer not created w/ zero size' );

    done_testing;
}
