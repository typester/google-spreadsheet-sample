#!/usr/bin/env perl

use strict;
use warnings;

use HTTP::Request::Common;
use Net::Google::AuthSub;
use Google::Data::JSON qw/gdata/;
use String::TT qw/tt strip/;
use YAML;

my $username = 'example@gmail.com';
my $password = 'your google password';

my $auth = Net::Google::AuthSub->new(
    service => 'wise',
);

my $edit_link = $ARGV[0];

my $ua = $auth->{_ua};

my $res = $auth->login($username, $password) or die;
die unless $res->is_success;

if ($edit_link) {
    $res = $ua->request(GET $edit_link, $auth->auth_params );
    die unless $res->is_success;

    my $data  = gdata($res->content)->as_hash;
    my @entry = map {
        title => $_->{title}{'$t'},
        map {
            $_->{rel} eq 'http://schemas.google.com/spreadsheets/2006#listfeed' ? ( edit_link => $_->{href} )
          : $_->{rel} eq 'alternate'                                            ? ( link => $_->{href} )
          :                                                                       ()
        } @{ $_->{link} },
    }, @{ $data->{feed}{entry} };

    warn Dump \@entry;
}
else {
    $res = $ua->request( GET 'http://spreadsheets.google.com/feeds/spreadsheets/private/full', $auth->auth_params );
    die unless $res->is_success;

    my $data  = gdata($res->content)->as_hash;
    my @entry = map {
        title => $_->{title}{'$t'},
        map {
            $_->{rel} eq 'http://schemas.google.com/spreadsheets/2006#worksheetsfeed' ? ( edit_link => $_->{href} )
          : $_->{rel} eq 'alternate'                                                  ? ( link => $_->{href} )
          :                                                                             ()
        } @{ $_->{link} },
    }, @{ $data->{feed}{entry} };

    warn Dump \@entry;
}
