#!/usr/bin/env perl

# Sample Perl script to transmit number
# to Arduino then listen for the Arduino
# to echo it back

use Device::SerialPort;
use Time::HiRes qw(usleep);
use WebService::Prowl;

# Set up the serial port
# 19200, 81N on the USB ftdi driver
my $port = Device::SerialPort->new("/dev/ttyACM0");
$port->databits(8);
$port->baudrate(9600);
$port->parity("none");
$port->stopbits(1);

my $count = 0;
my $warning_last_sent;

while (1) {
    # Poll to see if any data is coming in
    my $char = $port->lookfor();

    # If we get data, then print it
    # Send a number to the arduino
    if ($char) {

        $char =~ m/(OK|WARN).*/;
        print "Recieved data: " . $1 . " \n";

        # If a warning was triggered
        if ($1 eq "WARN") {

            # Check if we've sent an alert in the last 5 mins.
            if($warning_last_sent) {

                if ($warning_last_sent + 600 > time()) {
                    print "WARN triggered, but alert not sent.\n";
                    next;
                }

            }

            my $ws = WebService::Prowl->new(apikey => "f4d6eeea81d811057581ec7f1df5f20b1d177008");
            $ws->verify || die $ws->error();

            $ws->add(application => "Door Alarm",
                     event       => "DOOR OPEN!",
                     description => "Door has been opened! Panic!");

            $warning_last_sent = time();
        }


    } else {
        # Sleep for slightly less time than the frequency with which the arduino sends information
        usleep(400000);
    }
}
