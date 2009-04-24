package Hoppy::Base;
use strict;
use warnings;
use Carp;
use base qw(Class::Accessor::Fast Class::Data::ConfigHash);

$|++;

__PACKAGE__->mk_accessors($_) for qw(context);

sub new {
    my $class  = shift;
    my %args   = @_;
    my $config = delete $args{config};
    my $self   = $class->SUPER::new( {@_} );
    $self->config($config) if $config;
    return $self;
}

sub mk_virtual_methods {
    my $class = shift;
    foreach my $method (@_) {
        my $slot = "${class}::${method}";
        {
            no strict 'refs';
            *{$slot} = sub {
                Carp::croak( ref( $_[0] ) . "::${method} is not overridden" );
              }
        }
    }
    return ();
}

1;