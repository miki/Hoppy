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