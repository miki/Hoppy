package Hoppy::Service::Login;
use strict;
use warnings;
use base qw( Hoppy::Service::Base );

sub work {
    my $self = shift;
    my $args = shift;
    my $poe  = shift;

    my $user_id    = $args->{user_id};
    my $password   = $args->{password};
    my $room_id    = $args->{room_id};
    my $session_id = $poe->session->ID;

    my $c = $self->context;

    my $result = $c->room->login(
        {
            user_id    => $user_id,
            password   => $password,
            room_id    => $room_id,
            session_id => $session_id,
        },
        $poe
    );

    my $data;
    if ($result) {
        $data = { result => $result, error => "" };
    }
    else {
        my $message = "login failed";
        $data = { result => "", error => $message };
    }
    my $serialized = $c->formatter->serialize($data);
    $c->unicast( user_id => $user_id, message => $serialized );
}

1;