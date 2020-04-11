#!perl -T

use Test::More tests => 2;

use CircularBuffer;

{
    my $buffer = CircularBuffer->new;
    ok(defined($buffer),'Buffer created');

    my $data = $buffer->get;
    ok(!defined($data),'New buffer is empty');
}

