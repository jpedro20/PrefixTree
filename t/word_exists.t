use strict;
use warnings;

use Test::More tests => 23;
BEGIN { use_ok('PrefixTree') };
use PrefixTree;

my $dic = new PrefixTree();

isa_ok($dic, 'PrefixTree');


my @words = qw { aba abaco abada acorda acordar bombo bola bimbo pimpar alho alhada abraco};
my @stuff = qw { ab alh pim acordaremos acordada abacos abr bom xpto};

$dic->add_word($_) for (@words);

for (@words) {
    ok($dic->word_exists($_), "checking for $_");
}

for (@stuff) {
    ok(!$dic->word_exists($_), "checking for non-existing word $_");
}
