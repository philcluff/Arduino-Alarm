#!/usr/bin/env perl

# Reads from an arduino over the serial interface and parses the information it
# and decides if it should send an alert using the prowl notifications system.

use Device::SerialPort;
use WebService::Prowl;
use Time::HiRes qw(usleep);

# Set up the serial port - 9600, 81N
my $port = Device::SerialPort->new("/dev/ttyACM0");
$port->databits(8);
$port->baudrate(9600);
$port->parity("none");
$port->stopbits(1);

# Holds the timestamp of the last time that an alert was sent via prowl.
my $warning_last_sent;

# Time to wait between sending alerts.
my $backoff_time_seconds = 600;

while (1) {
    # Poll to see if any data is coming in.
    my $data = $port->lookfor();

    # If we get data, process it.
    if ($data) {

        $data =~ m/(OK|WARN).*/;
        print "Recieved data: " . $1 . " \n";

        # If a warning was triggered
        if ($1 eq "WARN") {

            # Check if we've sent an alert in the last 5 mins.
            if($warning_last_sent) {

                if ($warning_last_sent + $backoff_time_seconds > time()) {
                    print "WARN triggered, but alert not sent.\n";
                    next;
                }

            }

            # No, this isn't my API key... anylonger.
            my $ws = WebService::Prowl->new(apikey => "f4d6eeea81d811057581ec7f1df5f20b1d177008");
            $ws->verify || die $ws->error();

            $ws->add(application => "Door Alarm",
                     event       => "DOOR OPEN!",
                     description => "Door has been opened! Panic!");

            # Update the last time we sent an alert.
            $warning_last_sent = time();
        }


    } else {
        # Sleep for slightly less time than the frequency with which the arduino sends information.
        usleep(400000);
    }
}
