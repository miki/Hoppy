package Hoppy::User;
use strict;
use warnings;
use base qw(Hoppy::Base);

__PACKAGE__->mk_accessors($_) for qw( user_id session_id);

1;