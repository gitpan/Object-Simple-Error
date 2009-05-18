use Test::More 'no_plan';
use strict;
use warnings;

package Some;
use Object::Simple::Error;

sub err{
    die Object::Simple::Error->new( msg => 'a' );
}

sub throw_err{
    Object::Simple::Error->throw( msg => 'a' );
}

package main;

{
    my $t = Object::Simple::Error->new(
        type => 1,
        msg => 2,
        pos => 3,
        info => { a => 1 },
        pkg => 4,
        attr => 5,
        val => 6
    );
    isa_ok( $t, 'Object::Simple::Error' );
    
    my $setter_return_type = $t->type( 11 );
    my $setter_return_msg = $t->msg( 22 );
    my $setter_return_pos = $t->pos( 33 );
    my $setter_return_info = $t->info( { b => 2 } );
    my $setter_return_pkg = $t->pkg( 44 );
    my $setter_return_attr = $t->attr( 55 );
    my $setter_return_val = $t->val( 66 );
    
    is_deeply( [ $setter_return_type, $setter_return_msg, $setter_return_pos, $setter_return_info, $setter_return_pkg, $setter_return_attr, $setter_return_val ], 
               [ undef, undef, undef, undef, undef, undef, undef ], 'setter_return value' );
    is_deeply( [ $t->type, $t->msg, $t->pos, $t->info, $t->pkg, $t->attr, $t->val ],
               [ 11, 22, 33, { b => 2 }, 44, 55, 66 ], 'set value' );
}

{
    my $t = Object::Simple::Error->new( { type => 1 } );
    is( $t->type, 1, 'hash pass to new' );
}

{
    my $t = Object::Simple::Error->new( pos => 1 );
    is_deeply( [ $t->type, $t->msg, $t->pos, $t->info] , [ 'unknown', '', 1, {} ], 'default value' );
}

{
    my $t = Object::Simple::Error->new( msg => 'a', pos => 'b' );
    is( $t, 'ab', 'overload ""' );
}

{
    my $t = Object::Simple::Error->new;
    like( $t->pos, qr/at/, 'err postion' );
    is( $t->pkg, '', 'pkg default' );
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
    is( $@->msg, 'a', 'object member msg' );
}

{
    eval{ Some::throw_err()}; my $line = __LINE__;
    
    like( $@, qr/ at /, 'err' );
    like( $@, qr/$line/, 'err line' );
    is( $@->type, 'unknown', 'object member type' );
    is( $@->msg, 'a', 'object member msg' );
}

{
    my $t = Object::Simple::Error->new( pos => '' );
    is( $t->pos, '' , 'empty string' );
}
