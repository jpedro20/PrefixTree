use 5.016002;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'PrefixTree',
    VERSION_FROM      => 'lib/PrefixTree.pm',
    PREREQ_PM         => {},
    ($] >= 5.005 ?
        (ABSTRACT_FROM => 'lib/PrefixTree.pm',
        AUTHOR         => 'João Pereira <jpedro2011(at)gmail(dot)com>') : ()),
);
