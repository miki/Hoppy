package Hoppy::Service::Logout;
use strict;
use warnings;
use base qw( Hoppy::Service::Base );

sub work {
    my $self = shift;
    my $args = shift;
    my $poe  = shift;

    my $user_id = $args->{user_id};

    my $c = $self->context;

    my $result = $c->room->logout( $args, $poe );
    my $data;
    if ($result) {
        $data = { result => $result, error => "" };
    }
    else {
        my $message = "logout failed";
        $data = { result => "", error => $message };
    }
    my $serialized = $c->formatter->serialize($data);
}

1;