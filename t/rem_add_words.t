use strict;
use warnings;

use Test::More tests => 12;
BEGIN { use_ok('PrefixTree') };
use PrefixTree;

my $dic = new PrefixTree();

isa_ok($dic, 'PrefixTree');


my @pal = qw { aba abaco aberta aberto abertura aberturas ate ateu };
my @rem = qw { aba abertura ateu };

$dic->add_word($_) for (@pal);
$dic->rem_word($_) for (@rem);

my @expected = sort qw { abaco aberta aberto aberturas ate };
my @obtained = sort $dic->get_words_with_prefix('a');
is_deeply(\@obtained, \@expected, "checking if words were removed");

$dic->add_word('abertura');
$dic->rem_word('aberturas');
ok(!$dic->word_exists('aberturas'), "checking for word aberturas");
ok($dic->word_exists('abertura'), "checking for word abertura");
$dic->rem_word('abertura');
ok(!$dic->word_exists('abertura'), "checking for non-existing word abertura");


$dic = new PrefixTree();
$dic->add_word('palhaco');
ok($dic->prefix_exists('palh'), "checking for prefix palh");
ok(!$dic->prefix_exists('plh'), "checking for prefix plh");

$dic->rem_word('palhacos');
$dic->rem_word('palhac');
$dic->rem_word('p');

ok($dic->word_exists('palhaco'), "checking for word palhaco");

$dic->rem_word('palhaco');
ok(!$dic->word_exists('palhaco'), "checking for word palhaco");

my $dic2 = new PrefixTree();
is_deeply($dic, $dic2, "checking empty dictionaries");


$dic = new PrefixTree();
@pal = qw { aberta aberto abertura aberco};

$dic->add_word($_) for (@pal);
$dic->rem_word('aberco');
$dic->rem_word('aberto');

@expected = qw { aberta abertura};
@obtained = sort $dic->get_words_with_prefix('a');
is_deeply(\@obtained, \@expected, "checking if words were removed");
