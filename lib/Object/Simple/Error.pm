package Object::Simple::Error;
use 5.008_001;

our $VERSION = '0.0301';

use warnings;
use strict;
use Carp;
use overload '""' => sub{
    my $self = shift;
    return $self->message . $self->position;
};

### accessor
sub type{
    my $self = shift;
    
    if( @_ ){
        $self->{ type } = $_[0];
        return;
    }
    else{
        return $self->{ type };
    }
}

sub message{
    my $self = shift;
    
    if( @_ ){
        $self->{ message } = $_[0];
        return;
    }
    else{
        return $self->{ message };
    }
}

sub class{
    my $self = shift;
    
    if( @_ ){
        $self->{ class } = $_[0];
        return;
    }
    else{
        return $self->{ class };
    }
}

sub attr{
    my $self = shift;
    
    if( @_ ){
        $self->{ attr } = $_[0];
        return;
    }
    else{
        return $self->{ attr };
    }
}

sub value{
    my $self = shift;
    
    if( @_ ){
        $self->{ value } = $_[0];
        return;
    }
    else{
        return $self->{ value };
    }
}

sub position{
    my $self = shift;
    
    if( @_ ){
        $self->{ position } = $_[0];
        return;
    }
    else{
        return $self->{ position };
    }
}

sub info{
    my $self = shift;
    
    if( @_ ){
        $self->{ info } = $_[0];
        return;
    }
    else{
        return $self->{ info };
    }
}

sub new{
    my ( $proto, @args ) = @_;

    # bless
    my $self = {};
    my $class = ref $proto || $proto;
    bless $self, $class;
    
    # check args
    @args = %{ $args[0] } if ref $args[0] eq 'HASH';
    croak 'key-value pairs must be passed to new.' if @args % 2;
    
    # set args
    while( my ( $attr, $value ) = splice( @args, 0, 2 ) ){
        croak "Invalid key '$attr' is passed to new." unless $self->can( $attr );
        
        $self->{ $attr } = $value;
    }
    
    $self->type( 'unknown' ) unless defined $self->type;
    $self->message( '' ) unless defined $self->message;
    $self->class( '' ) unless defined $self->class;
    $self->attr( '' ) unless defined $self->attr;
    $self->info( {} ) unless defined $self->info;
    
    local $Carp::CarpLevel += 1;
    $self->position( Carp::shortmess("") ) unless defined $self->position;
    
    return $self;
}

# die with Object::Simple::Error object
sub throw{
    my $self = shift;
    local $Carp::CarpLevel += 1;
    my $err_obj = $self->new( @_ );
    die $err_obj;
}

=head1 NAME

Object::Simple::Error - Error object for Object::Simple [DISCOURAGED]

=head1 CAUTION

This module is discouraged now, because I feel L<Object::Simple> do not need error object.

=head1 VERSION

Version 0.0301

=cut

=head1 

=head1 DESCRIPTION

Object::Simple::Error provide structured error system to Object::Simple.

You can create structure err message.

If err is ocuured, You can get err object;

=cut

=head1 CAUTION

Object::Simple::Error is yet experimental stage.

Please wait untill Object::Simple::Error is stable.

=cut

=head1 SYNOPSIS

    use Object::Simple::Error;
    
    # create error object;
    my $err_str = Object::Simple::Error->new( 
        type => 'err_type',
        message => 'message',
        info => { some1 => 'some info1', some2 => 'some info2' }
    );
    
    # throw err
    Object::Simple::Error->throw( 
        type => 'err_type',
        message => 'message',
        info => { some1 => 'some info1', some2 => 'some info2' }
    );

=head1 ACCESSOR

You can contain variouse error information.

=head2 type

is error type.

=head2 message

is error message

=head2 position

is position in which error is occured.

You do not have to specify this attr in create_err_str argument.

position is automatically set, parsing croak message or die message.

=head2 class

class name

=head2 attr

is attr name

=head2 value

is attribute value

=head3 info

is information other than type, message or position.

This is hash ref.

=cut

=head1 METHOD

=head2 new

is constructor;

    my $err_obj = Object::Simple::Error->new(
        type => 'err_type',
        message => 'message',
        info => { some1 => 'some info1', some2 => 'some info2' }
    );

=head2 throw

thorw error.

    Object::Simple::Error->throw( 
        type => 'err_type',
        message => 'message',
        info => { some1 => 'some info1', some2 => 'some info2' }
    );
    
This is same as

    die Object::Simple::Error->new( 
        type => 'err_type',
        message => 'message',
        info => { some1 => 'some info1', some2 => 'some info2' }
    );

=head1 AUTHOR

Yuki Kimoto, C<< <kimoto.yuki at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-simo-error at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Object-Simple-Error>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Object::Simple::Error


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Object::Simple-Error>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Object::Simple-Error>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Object::Simple-Error>

=item * Search CPAN

L<http://search.cpan.org/dist/Object::Simple-Error/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Yuki Kimoto, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Object::Simple::Error
