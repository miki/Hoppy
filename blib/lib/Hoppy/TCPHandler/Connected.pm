package Hoppy::TCPHandler::Connected;
use strict;
use warnings;
use base qw( Hoppy::Base );

sub do_handle {
    my $self = shift;
    my $poe  = shift;
    my $c    = $self->context;
    my $session_id = $poe->session->ID; 
    $c->{sessions}->{$session_id} = 1;
    $c->{not_authorized}->{$session_id} = 1;
}

1;