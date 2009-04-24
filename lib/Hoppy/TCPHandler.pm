package Hoppy::TCPHandler;
use strict;
use warnings;

sub Hoppy::TCPHandler::import {
    my $package = ( caller() )[0];
    eval <<"    END";
        package $package;
        # load the handler packages
        use Hoppy::TCPHandler::Input;
        use Hoppy::TCPHandler::Connected;
        use Hoppy::TCPHandler::Disconnected;
        use Hoppy::TCPHandler::Error;
        use Hoppy::TCPHandler::Send;
    END
}

1;
