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
use lib::abs qw(
    ./lib
);
use File::Slurp;
use JSON;
use Perl6::Form;

# global vars

# subs

# main
sub main {

    my $the_number = 81;

    p "The number is $the_number";

    my $json = read_file("votes.json");
    my $data = decode_json($json);

    my %values;

    foreach my $vote (@{$data}) {
        my $difference = abs($vote->{vote} - $the_number);
        $difference = sprintf("%0.2f", $difference);

        if (not exists $values{$difference}) {
            $values{$difference} = $vote;
        } else {
            warn "The same difference already was recored!";
            p $difference;
            p $vote;
        }

    }

    my @sorted_keys = sort {
        ($a <=> $b)
    } keys %values;

    my $format = "{<<<<} {<<<<} {<<<<} {<<<<<<<<<<<<<<<}";
    print form $format,
        "diff",
        "bet",
        "order",
        "",
        ;

    foreach my $key (@sorted_keys) {

        print form $format,
            $key,
            $values{$key}->{vote},
            $values{$key}->{n},
            $values{$key}->{author},
            ;

    }

    say '#END';
}

main();
__END__
