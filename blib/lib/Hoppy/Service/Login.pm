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
__END__

=head1 NAME

Hoppy::Service::Login - Default login service.

=head1 SYNOPSIS

=head1 DESCRIPTION

Default login service.

=head1 METHODS

=head2 work

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut