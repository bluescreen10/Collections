use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Collections',
    AUTHOR              => 'Mariano Wahlmann <dichoso@gmail.com>',
    VERSION_FROM        => 'lib/Collections/Ordered.pm',
    ABSTRACT            => 'Easy to use iterators',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Test::Exception' => 0,
        'Try::Tiny'	=> 0,
        'Class::Accessor' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Collections-*' },
);
