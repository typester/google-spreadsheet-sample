#!/usr/bin/env perl

use strict;
use warnings;

use Net::Google::AuthSub;
use HTTP::Request::Common;
use String::TT qw/strip tt/;

my $username = 'example@gmail.com';
my $password = 'your google password';

my $auth = Net::Google::AuthSub->new(
    service => 'wise',
);
my $ua = $auth->{_ua};

my $res = $auth->login($username, $password) or die;
die unless $res->is_success;

my $edit_link = $ARGV[0] or die 'require edit_link';

my $time      = time;
my $usercount = 10000;

$res = $ua->request(
    POST $edit_link,
    $auth->auth_params,
    'Content-Type' => 'application/atom+xml; charset=utf-8',
    'Content'      => tt strip q{
        <entry xmlns="http://www.w3.org/2005/Atom"
               xmlns:gsx="http://schemas.google.com/spreadsheets/2006/extended">
            <gsx:日付>[% time %]</gsx:日付>
            <gsx:会員数>[% usercount %]</gsx:会員数>
        </entry>
    },
);

