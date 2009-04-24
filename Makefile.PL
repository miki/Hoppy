use inc::Module::Install;
name 'Hoppy';
all_from 'lib/Hoppy.pm';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
