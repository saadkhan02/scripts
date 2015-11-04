#!/usr/bin/perl

# This script gets you the external IP address whenever it gets changed.

use strict;
use warnings;
use diagnostics;

use Getopt::Long;

use constant {
    TIMEOUT_S => 10,
    PROMPT => "\$ ",
    IP_RECORD => "/tmp/IPRecord",
    NEW_IP_RECORD => "/tmp/newIPRecord"
};

my $emailAddress;
my $verbose;

##
# Gets the external IP address.
#
# @return external IP address for success.
# @return undef for failure.
#
sub getIP()
{
    my $IP = undef;

    system("curl http://ipecho.net/plain > " . NEW_IP_RECORD);
#    $result =~ /([0-9]*[\.][0-9]*[\.][0-9]*[\.][0-9]*)/;
    open(FILE, NEW_IP_RECORD);
    $IP = <FILE>;
    close(FILE);

    unlink(NEW_IP_RECORD);

    return $IP;
}

##
# Update IP file and send email.
#
# @param IP External IP address of the network.
# @param emailAddress Email address which needs to be notified of the change.
# @param verbose Whether or not the display needs to be verbose.
#
sub updateFileAndSendEmail($$$)
{
    my ($IP, $emailAddress, $verbose) = @_;

    # Update or make the IP record file.
    open(WRITE_TO_FILE, ">", IP_RECORD);
    print(WRITE_TO_FILE $IP);
    close(WRITE_TO_FILE);

    # Send email.
    system("cat " . IP_RECORD .
           " | mail -s \"New IP address\" ${emailAddress}");

    if ($verbose) {
        print("The new IP address is ${IP}\n");
    }
}

##
# Main function.
#
sub main()
{

    GetOptions("email:s" => \$emailAddress,
               "verbose" => \$verbose);

    if (!$emailAddress) {
        print("Please provide an email address. Use --email\n");
    }
    else {
        while (1) {
            my $oldIP = undef;
            my $IP = getIP();

            if ($IP) {
                # If the record does'nt exist, create it.
                if (!-e IP_RECORD) {
                    updateFileAndSendEmail($IP, $emailAddress, $verbose);
                }
                # If record exists, compare with the old one and update if needed.
                else {
                    open(FILE, IP_RECORD);
                    $oldIP = <FILE>;
                    close(FILE);

                    if ($oldIP ne $IP) {
                        updateFileAndSendEmail($IP, $emailAddress, $verbose);
                    }
                }
            }

            sleep(3600);
        }
    }
}

main();
