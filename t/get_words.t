use strict;
use warnings;
use Data::Dumper;

use Test::More tests => 38;
BEGIN { use_ok('PrefixTree') };
use PrefixTree;

my $dic = PrefixTree->new();

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
	'ac' => [],
	'ad' => [qw{adesao aderir}]
);

sub nub {
	my %seen = map {($_, 1)} @_;

	sort keys %seen;
}

my @words = nub map {@{$tests{$_}}} keys %tests;

$dic->add_word($_) for (@words);

ok(!$dic->get_words_with_prefix('xyz'), "non existing words");

for my $w (@words) {
	ok(grep {$_ eq $w} $dic->get_words_with_prefix($w), "checking for $w");
}

for my $p (keys %tests) {
	my @expected = sort @{$tests{$p}};
	my @obtained = sort $dic->get_words_with_prefix($p);
	is_deeply(\@obtained, \@expected, "checking for prefix $p") or diag(Data::Dumper->Dump([\@obtained, \@expected], [qw{obtained expected}]));
}

$dic = PrefixTree->new();

my $palavra = "abracadabra";
my @palavras = map {substr $palavra, 0, $_} reverse 1..length($palavra);

for (@palavras) {
	ok(!$dic->get_words_with_prefix($_), "checking for non-existing word $_");
}
