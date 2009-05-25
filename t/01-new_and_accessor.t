use Test::More 'no_plan';
use strict;
use warnings;

package Some;
use Object::Simple::Error;

sub err{
    die Object::Simple::Error->new( message => 'a' );
}

sub throw_err{
    Object::Simple::Error->throw( message => 'a' );
}

package main;

{
    my $t = Object::Simple::Error->new(
        type => 1,
        message => 2,
        position => 3,
        info => { a => 1 },
        class => 4,
        attr => 5,
        value => 6
    );
    isa_ok( $t, 'Object::Simple::Error' );
    
    my $setter_return_type = $t->type( 11 );
    my $setter_return_message = $t->message( 22 );
    my $setter_return_position = $t->position( 33 );
    my $setter_return_info = $t->info( { b => 2 } );
    my $setter_return_class = $t->class( 44 );
    my $setter_return_attr = $t->attr( 55 );
    my $setter_return_value = $t->value( 66 );
    
    is_deeply( [ $setter_return_type, $setter_return_message, $setter_return_position, $setter_return_info, $setter_return_class, $setter_return_attr, $setter_return_value ], 
               [ undef, undef, undef, undef, undef, undef, undef ], 'setter_return value' );
    is_deeply( [ $t->type, $t->message, $t->position, $t->info, $t->class, $t->attr, $t->value ],
               [ 11, 22, 33, { b => 2 }, 44, 55, 66 ], 'set value' );
}

{
    my $t = Object::Simple::Error->new( { type => 1 } );
    is( $t->type, 1, 'hash pass to new' );
}

{
    my $t = Object::Simple::Error->new( position => 1 );
    is_deeply( [ $t->type, $t->message, $t->position, $t->info] , [ 'unknown', '', 1, {} ], 'default value' );
}

{
    my $t = Object::Simple::Error->new( message => 'a', position => 'b' );
    is( $t, 'ab', 'overload ""' );
}

{
    my $t = Object::Simple::Error->new;
    like( $t->position, qr/at/, 'err positiontion' );
    is( $t->class, '', 'class default' );
    is( $t->attr, '', 'attr default' );
}

{
    eval{ Object::Simple::Error->new( 1 ) };
    like( $@, qr/key-value pairs must be passed to new/, 'pass not key-value paris to new' );
}

{
    eval{ Object::Simple::Error->new( 'noexist' => 1 ) };
    like( $@, qr/Invalid key 'noexist' is passed to new/, 'no exists key is passed' );
}


{
    eval{ Some::err()}; my $line = __LINE__;
    like( $@, qr/ at /, 'err' );
    like( $@, qr/$line/, 'err line' );
    is( $@->type, 'unknown', 'object member type' );
    is( $@->message, 'a', 'object member message' );
}

{
    eval{ Some::throw_err()}; my $line = __LINE__;
    
    like( $@, qr/ at /, 'err' );
    like( $@, qr/$line/, 'err line' );
    is( $@->type, 'unknown', 'object member type' );
    is( $@->message, 'a', 'object member message' );
}

{
    my $t = Object::Simple::Error->new( position => '' );
    is( $t->position, '' , 'empty string' );
}
