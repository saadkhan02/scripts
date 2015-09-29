#!/usr/bin/perl

use strict;
use diagnostics;
use warnings;

my $string = "Reboot not required...\n";
my $file = "/var/run/reboot-required.pkgs";
my $file2 = "/var/run/reboot-required";

if (-f $file) {
    open(FILE1, $file);
    my @lines = <FILE1>;
    close(FILE1);

    open(FILE2, $file2);
    push(@lines, <FILE2>);
    close(FILE2);

    $string = join("", @lines);
}

print($string);
