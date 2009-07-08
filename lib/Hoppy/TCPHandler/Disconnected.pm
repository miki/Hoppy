package Hoppy::TCPHandler::Disconnected;
use strict;
use warnings;
use base qw( Hoppy::Base );

sub do_handle {
    my $self       = shift;
    my $poe        = shift;
    my $c          = $self->context;
    my $session_id = $poe->session->ID;
    my $user       = $c->room->fetch_user_from_session_id($session_id);
    if ($user) {
        $c->room->logout( { user_id => $user->user_id }, $poe );
    }
    delete $c->{sessions}->{$session_id};
    delete $c->{not_authorized}->{$session_id};
    $poe->kernel->yield("shutdown");
    if ( ref $c->hook->{client_disconnect} eq 'HASH' ) {
        $c->hook->{client_disconnect}->work();
    }
}

1;
__END__

=head1 NAME

Hoppy::TCPHandler::Disconnected - TCP handler class that will be used when client disconnected. 

=head1 SYNOPSIS

=head1 DESCRIPTION

TCP handler class that will be used when client disconnected. 

=head1 METHODS

=head2 do_handle($poe)

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut