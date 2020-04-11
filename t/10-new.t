#!perl -T

use Test::More;

use CircularBuffer;

{
    my $buffer = CircularBuffer->new;
    ok(defined($buffer),'Buffer created');

    my $data = $buffer->get;
    ok(!defined($data),'New buffer is empty');
}

{
    my $size   = 20;
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
    is( $buffer->put( $size + 1 ), 0, "Unable to store one more than capacity" );

    done_testing;
}



