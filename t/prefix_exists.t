use strict;
use warnings;

use Test::More tests => 19;
BEGIN { use_ok('PrefixTree') };
use PrefixTree;

my $dic = new PrefixTree();

isa_ok($dic, 'PrefixTree');


my %tests = (
    'ab' => [qw{aba abaco abeto abrir aberto abertura}],
    'aba' => [qw{aba abaco}],
    'abe' => [qw{abeto aberto abertura}],
    'aber' => [qw{aberto abertura}],
    'ap' => [qw{aparecer aparece aparecida apurar apurado}],
    'apa' => [qw{aparecer aparece aparecida}],
    'aparec' => [qw{aparecer aparece aparecida}],
    'apu' => [qw{apurar apurado}],
    'apura' => [qw{apurar apurado}],
    'ad' => [qw{adesao aderir}]
);

my @tests2 = qw {al aj abec aparecidas bo c adere};

my @words = map {@{$tests{$_}}} keys %tests;

$dic->add_word($_) for (@words);


for (keys %tests) {
    ok($dic->prefix_exists($_), "checking for prefix $_");
}

for (@tests2) {
    ok(!$dic->prefix_exists($_), "checking for non-existing prefix $_");
}
