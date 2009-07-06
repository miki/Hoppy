package Hoppy::Service::Login;
use strict;
use warnings;
use Data::GUID;
use base qw( Hoppy::Service::Base );

sub work {
    my $self = shift;
    my $args = shift;

    my $in_data    = $args->{in_data};
    my $poe        = $args->{poe};
    my $session_id = $poe->session->ID;
    my $c          = $self->context;

    ## It can distribute the ID automatically
    if ( $in_data->{params}->{auto} ) {
        $args->{user_id} = Data::GUID->new->as_string;
    }
    else {
        $args->{user_id} = $in_data->{params}->{user_id};
    }

    my $result = $c->room->login(
        {
            user_id    => $args->{user_id},
            password   => $in_data->{params}->{password},
            room_id    => $in_data->{params}->{room_id},
            session_id => $session_id,
        },
        $poe
    );

    my $out_data;
    if ($result) {
        $out_data = {
            result => {
                method_name => "login",
                login_id    => $args->{user_id},
                login_time  => time()
            },
            error => ""
        };
    }
    else {
        my $message = "login failed";
        $out_data = { result => "", error => $message };
    }
    if ( $in_data->{id} ) {
        $out_data->{id} = $in_data->{id};
    }
    my $serialized = $c->formatter->serialize($out_data);
    $c->unicast(
        {
            session_id => $session_id,
            user_id    => $args->{user_id},
            message    => $serialized
        }
    );
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