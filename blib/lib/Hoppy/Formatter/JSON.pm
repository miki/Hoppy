package Hoppy::Formatter::JSON;
use strict;
use warnings;
use base qw( Hoppy::Base );
use JSON;
use Encode;
use Encode::Guess;

sub serialize {
    my ( $self, $data, $code ) = @_;
    my $json = JSON::to_json($data);
    $code ||= 'utf8';
    if ( Encode::is_utf8($json) ) {
        utf8::decode($json);
    }
    return Encode::encode( $code, $json );
}

sub deserialize {
    my ( $self, $json, $code ) = @_;
    if ( !Encode::is_utf8($json) ) {
        if ( !$code ) {
            my $enc = guess_encoding( $json, qw/euc-jp shiftjis utf8/ );
            $code = $enc->name;
        }
        $json = Encode::decode( $code, $json );
    }
    return JSON::from_json($json);
}

1;
__END__

=head1 NAME

Hoppy::Formatter::JSON - IO formatter that can translate from or to JSON. 

=head1 SYNOPSIS

  use Hoppy::Formatter::JSON;

  my $formatter = Hoppy::Formatter::JSON->new;

  # from perl data to JSON
  my $data = { method => "login", params => {user_id => "hoge"} };
  my $json = $formatter->serialize($data);

  # from JSON to perl data 
  $data = $formatter->deserialize($json);
 
=head1 DESCRIPTION

IO formatter that can translate from or to JSON. 

=head1 METHODS

=head2 serialize

=head2 deserialize

=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut