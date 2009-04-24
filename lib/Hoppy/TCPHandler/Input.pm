package Hoppy::TCPHandler::Input;
use strict;
use warnings;
use base qw( Hoppy::Base );

sub do_handle {
    my $self  = shift;
    my $poe   = shift;
    my $c     = $self->context;
    my $input = $poe->args->[0];
    if ( $input =~ /policy-file-request/ ) {
        my $xml = $self->cross_domain_policy_xml;
        $c->handler->{Send}->do_handle( $poe, $xml );
    }
    else {
        my $data = '';
        eval { $data = $c->formatter->deserialize($input); };
        if ($@) {
            warn "IO Format Error: $@";
        }
        else {
            my $method = $data->{method};
            my $params = $data->{params};
            $c->dispatch( $method, $params, $poe );
        }
    }
}

sub cross_domain_policy_xml {
    my $self = shift;
    my $xml  = <<"    END";
        <?xml version="1.0"?>
        <!DOCTYPE cross-domain-policy SYSTEM "http://www.macromedia.com/xml/dtds/cross-domain-policy.dtd">
        <cross-domain-policy>
        <allow-access-from domain="*" to-ports="*" />
        </cross-domain-policy>
    END
    return $xml;
}

1;