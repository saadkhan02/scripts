#!/usr/bin/perl

# This script gets you the external IP address whenever it gets changed.
# NOTE: You will need the following packages to run this script:
# * libexpect-perl
# * lynx-cur

use strict;
use warnings;
use diagnostics;

use Expect;
use Data::Dumper;

use constant {
    TIMEOUT_S => 10,
    PROMPT => "\$ ",
    IP_RECORD => "/tmp/ipRecord"
};

##
# Gets the external IP address.
#
# @return external IP address for success.
# @return undef for failure.
#
sub getIP()
{
    my $expect = new Expect;
    $expect->log_stdout(0);

    my $IP = undef;

    $expect->spawn("/bin/bash");
    $expect->expect(TIMEOUT_S, PROMPT);
    $expect->send("lynx --dump http://ipecho.net/plain\n");
    $expect->expect(TIMEOUT_S, PROMPT);
    my $result = $expect->before();
    $result =~ /([0-9]*[\.][0-9]*[\.][0-9]*[\.][0-9]*)/;
    $IP = $1;

    return $IP;
}

##
# Checks whether the IP address has changed from the time we checked earlier.
#
# @param IP Current IP address of the machine.
#
# @return 1 IP has not changed.
# @return 0 IP has changed.
#
sub checkEarlierIP($)
{
    my ($IP) = @_;

    my $returnCode = 1;

    if (-e IP_RECORD) {
        newRecord($IP);
    }
}


print Dumper getIP();
