package PrefixTree;

our $VERSION = '1.00';

use 5.016002;
use strict;
use warnings;
use Storable qw(store retrieve);

use constant false => 0;
use constant true  => 1;


sub new {
    my ($self, @files) = @_;

    my $dict = {dict => {}};
    $self = bless $dict, $self;

    $self->add_dict(@files);

    return $self;
}

sub save {
    my ($self, $filename) = @_;

    my $res = store $self->{dict}, $filename;
    return $res;
}

sub load {
    my ($self, $filename) = @_;

    my $dict = retrieve($filename);
    if($dict) {
        $self->{dict} = $dict;
        return true;
    }

    return false;
}

sub add_dict {
    my ($self, @files) = @_;

    for my $file (@files) {
        my $fh;

        if($file =~ /\.bz2$/)   { open $fh, "bzcat $file |"; }
        elsif($file =~ /\.gz$/) { open $fh, "gzcat $file |"; }
        else { open $fh, '<', $file; }

        while(<$fh>) {
            chomp;
            $self->add_word($_);
        }

        close $fh;
    }

    return true;
}

sub add_word {
    my ($self, $word) = @_;

    my $dict = $self->{dict};
    my @letters = split '', $word;

    for (@letters) {
        $dict->{$_} = {} unless exists $dict->{$_};
        $dict = $dict->{$_};
    }

    $dict->{'$$'} = 1;

    return $word;
}

sub rem_word {
    my ($self, $word) = @_;

    my $dict = $self->{dict};
    my @refs = ();
    my @letters = split '', $word;
    my $res = true;

    for (@letters) {
        if(exists $dict->{$_}) {
            unshift @refs, [$dict, $_];
            $dict = $dict->{$_};
        } else {
            $res = false;
            last;
        }
    }

    if($res && exists $dict->{'$$'}) {
        unshift @refs, [$dict, '$$'];
        for my $ref (@refs) {
            delete $ref->[0]{$ref->[1]};
            last if scalar keys %{$ref->[0]} > 0;
        }
    }

    return $res;
}

sub get_words_with_prefix {
    my ($self, $prefix) = @_;

    my ($res, $dict) = $self->parseword($prefix);
    my @words = ();

    $self->get_words($dict, $prefix, \@words) if $res;

    return @words;
}

sub get_words {
    my ($self, $dict, $word, $wordlist) = @_;

    for (keys %{$dict}) {
        if($_ eq '$$') {
            push @{$wordlist}, $word;
        } else {
            $self->get_words($dict->{$_}, $word . $_, $wordlist);
        }
    }
}

sub prefix_exists {
    my ($self, $prefix) = @_;

    my ($found, $dict) = $self->parseword($prefix);
    return $found;
}

sub word_exists {
    my ($self, $word) = @_;

    my ($found, $dict) = $self->parseword($word);
    return $found && exists $dict->{'$$'};
}

sub parseword {
    my ($self, $word) = @_;

    my $res = true;
    my $dict = $self->{dict};
    my @letters = split '', $word;

    for (@letters) {
        if(exists $dict->{$_}) {
            $dict = $dict->{$_};
        } else {
            $res = false;
            last;
        }
    }

    return ($res, $dict);
}


1;
__END__

=head1 NAME

PrefixTree - Perl extension for a PrefixTree

=head1 AUTHOR

João Pereira, E<lt>jpedro2011(at)gmail(dot)comE<gt>
