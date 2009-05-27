#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Object::Simple::Error' );
}

diag( "Testing Object::Simple::Error $Object::Simple::Error::VERSION, Perl $], $^X" );
