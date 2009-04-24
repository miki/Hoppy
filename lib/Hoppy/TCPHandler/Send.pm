package Hoppy::TCPHandler::Send;
use strict;
use warnings;
use base qw( Hoppy::Base );

sub do_handle {
    my $self    = shift;
    my $poe     = shift;
    my $message = shift;
    $message ||= $poe->args->[0];
    my $heap = $poe->heap;
    if ( $heap->{client} ) {
        $heap->{client}->put($message);
    }
}

1;