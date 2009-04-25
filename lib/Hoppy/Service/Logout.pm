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
__END__

=head1 NAME

Hoppy::Service::Logout - Default logout service.

=head1 SYNOPSIS

=head1 DESCRIPTION

Default logout service.

=head1 METHODS

=head2 work

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut