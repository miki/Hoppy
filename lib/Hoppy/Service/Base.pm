package Hoppy::Service::Base;
use strict;
use warnings;
use base qw(Hoppy::Base);

__PACKAGE__->mk_virtual_methods($_) for qw( work );
1;