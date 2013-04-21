#!/usr/bin/perl

=encoding UTF-8
=cut

=head1 DESCRIPTION

=cut

# common modules
use strict;
use warnings FATAL => 'all';
use LWP;
use File::Slurp;

# subs

# main
sub main {

    my $url = "http://friendfeed-api.com/v2/entry/e/dc1eff2e2fb848e2a3b41824d16470a4?pretty=1";
    my $file = "post.json";

    my $browser = LWP::UserAgent->new();
    my $request = HTTP::Request->new(
        'GET',
        $url,
    );

    my $response = $browser->request($request);
    my $json = $response->content();

    write_file($file, $json);

}

main();
__END__
