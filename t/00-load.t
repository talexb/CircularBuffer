#!/usr/bin/perl

use Test::More tests => 1;

BEGIN {
    use_ok( 'CircularBuffer' );
}

diag( "Testing CircularBuffer $CircularBuffer::VERSION, Perl $], $^X" );
