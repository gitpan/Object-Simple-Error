use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Object::Simple::Error',
    license             => 'perl',
    dist_author         => 'Yuki Kimoto <kimoto.yuki@gmail.com>',
    dist_version_from   => 'lib/Object/Simple/Error.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'Carp' => 1.04,
    },
    add_to_cleanup      => [ 'Object-Simple-Error-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
