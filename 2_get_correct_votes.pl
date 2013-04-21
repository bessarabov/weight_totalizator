#!/usr/bin/perl

=encoding UTF-8
=cut

=head1 DESCRIPTION

=cut

# common modules
use strict;
use warnings FATAL => 'all';
use 5.010;
use DDP;
use Carp;
use utf8;
use JSON;
use File::Slurp;
use Perl6::Form;
use Term::ANSIColor qw(colored);

# global vars
my $true = 1;
my $false = '';

# subs

sub get_data_from_file {
    my ($file) = @_;

    my $json = read_file($file);

    my $data = decode_json($json);

    return $data;
}

# main
sub main {

    my $file = "post.json";

    my $data = get_data_from_file($file);

    my $i = 0;
    my $j = 0;
    my $note = '';
    my %voted;
    my %bets;
    my @saved;

    foreach my $comment (@{$data->{comments}}) {
        my $text = $comment->{body};
        my $author = $comment->{from}->{id};

        # In bessarabov's comments there are some numbers that are not needed
        # to be part of the totalizator.
        next if $author eq 'bessarabov';

        if ($text =~ /(\d+([\.,]\d+)?)/) {
            my $prediction = $1;
            $prediction =~ s/,/./;

            if ($voted{$author}) {
                $note = "Already voted!";
            } elsif ($bets{$prediction}) {
                $note = "This number has already been taken!";
            } else {
                $note = "";
            }

            $i++;
            print form "{>}   {<<<<<<<<<<<<<<<<<<<} {<<<<<<<<} {<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<}",
                $i,
                $author . "@",
                $prediction,
                colored(['red'], $note),
                ;

            if ($note eq '') {
                # It means the bet is correct
                $j++;
                push @saved, {
                    n => $j,
                    author => $author,
                    vote => $prediction,
                };
            }

            $voted{$author} = $true;
            $bets{$prediction} = $true;

        }
    }

    my $json = JSON->new();
    my $pretty_printed = $json->pretty->encode( \@saved );

    write_file('votes.json', $pretty_printed);

}

main();
__END__
