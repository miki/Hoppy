package Hoppy::Room::Memory;
use strict;
use warnings;
use Hoppy::User;
use base qw(Hoppy::Base);

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self->create_room('global');
    return $self;
}

sub create_room {
    my $self    = shift;
    my $room_id = shift;
    unless ( $self->{rooms}->{$room_id} ) {
        $self->{rooms}->{$room_id} = {};
    }
}

sub delete_room {
    my $self    = shift;
    my $room_id = shift;
    if ( $room_id ne 'global' ) {
        my $room = $self->{rooms}->{$room_id};
        for my $user_id ( keys %$room ) {
            $self->delete_user($user_id);
        }
        delete $self->{rooms}->{$room_id};
    }
}

sub login {
    my $self = shift;
    my $args = shift;
    my $poe  = shift;

    my $user_id    = $args->{user_id};
    my $password   = $args->{password};
    my $session_id = $args->{session_id};
    my $room_id    = $args->{room_id} || 'global';

    my $c = $self->context;

    if ( $c->service->{auth} ) {
        my $result = $c->service->{auth}->work( $args, $poe );
        return 0 unless $result;
    }
    delete $c->{not_authorized}->{$session_id};

    my $user = Hoppy::User->new(
        user_id    => $user_id,
        session_id => $session_id
    );

    $self->{rooms}->{$room_id}->{$user_id} = $user;
    $self->{where_in}->{$user_id}          = $room_id;
    $self->{sessions}->{$session_id}       = $user_id;
    return 1;
}

sub logout {
    my $self = shift;
    my $args = shift;
    my $poe  = shift;

    my $user_id = $args->{user_id};
    my $user    = $self->fetch_user_from_user_id($user_id);

    delete $self->{sessions}->{ $user->session_id };
    delete $self->{where_in}->{$user_id};
    delete $self->{rooms}->{$user_id};
    return 1;
}

sub fetch_user_from_user_id {
    my $self    = shift;
    my $user_id = shift;
    return unless ($user_id);
    my $room_id = $self->{where_in}->{$user_id};
    return $self->{rooms}->{$room_id}->{$user_id};
}

sub fetch_user_from_session_id {
    my $self       = shift;
    my $session_id = shift;
    return unless ($session_id);
    my $user_id    = $self->{sessions}->{$session_id};
    return $self->fetch_user_from_user_id($user_id);
}

sub fetch_users_from_room_id {
    my $self    = shift;
    my $room_id = shift;
    my @users   = values %{ $self->{rooms}->{$room_id} };
    return \@users;
}

1;