#!/usr/bin/perl -w
# ========================================================================
# str
# by Iain Truskett,
# $Id: str,v 1.2 2002/02/03 14:29:04 koschei Exp $
# ========================================================================

 
=head1 NAME
 
str - SDA handler
 
=head1 SYNOPSIS
 
str [-V | -h | -v [ -i ip ] [ -s host ] [ -p port] ]
 
=head1 OPTIONS
 
=over 4
 
=item -V
 
Display version line and exit.
 
=item -h
 
Display program help and exit.
 
=item -v
 
Verbose mode (off)
 
=item -i ip
 
Specify ip or hostname of machine to allow enabling of machines
remotely. Defaults to localhost's IP.
 
=item -s host
 
Specify the SDA server's hostname/ip. Defaults to the BB&G
server.
 
=item -s port
 
Specify the SDA server's port. Defaults to 8000.
 
=back
 
=head1 RECOMMENDED INSTALLATION FOR PERMANENT EXECUTION (under Unix variants)
 
Head over to http://cr.yp.to/daemontools.html and install them.
 
=head2 The Quick Way
 
    mkdir -p /etc/svscan/str/log
    mkdir -p /var/log/str
    groupadd nofiles
    groupadd -g nofiles sdaclnt
    chown sdaclnt:nofiles /var/log/str
    cp str /etc/svscan/str
    cd /etc/svscan/str
    echo "username\npassword\n" > logindetails
 
Create run as per:
 
    #!/bin/sh
    exec /usr/local/bin/setuidgid sdaclnt ./str < ./logindetails 2>&1
 
and log/run
 
    #!/bin/sh
    exec /usr/local/bin/setuidgid sdaclnt \
    /usr/local/bin/multilog t /var/log/str
 
Then
 
    chmod 755 run log/run
    ln -s /etc/svscan/str /service
 
And if you 'pstree' or similar, you should see str happily running.
 
=head2 Explanatory
 
Make a directory /etc/svscan/str and put the following 'run' file into it:
 
    #!/bin/sh
    exec /usr/local/bin/setuidgid sdaclnt ./str < ./logindetails 2>&1
 
Create /etc/svscan/str/log/run as per:
 
    #!/bin/sh
    exec /usr/local/bin/setuidgid sdaclnt \
    /usr/local/bin/multilog t /var/log/str
 
Create a 'logindetails' file that has your username on one line and your
password on the next.
 
Your directory structure should look like:
 
    /etc/svscan/str/
      |- log/
      |  '- run
      |- logindetails
      |- run
      '- str
 
Create a group 'nofiles' if you haven't already got one (see
groupadd(8)).  Create a user 'sdaclnt' in that group (useradd(8)).
 
Create a directory /var/log/str and chown sdaclnt:nofiles it.
 
Ensure str is in /etc/svscan/str and then link the
str directory in to /service.
 
Then, if you want to logout, do 'svc -d /service/str' To
login after that do 'svc -u /service/str'.  To give it a kick
(log you off, log you back in), do 'svc -t /service/str'.
 
 
Basically, this all means that you get a log of what str does
while it's being a daemon and you can also easily stop it, start it,
restart it, whatever.
 
=head1 AUTHOR
 
Iain Truskett <ict@eh.org> <L<http://eh.org/~koschei/>>
 
=head1 COPYRIGHT
 
This program is Copyright (c) 2001 Iain Truskett. All rights reserved.
 
You may distribute under the terms of either the GNU General Public
License or the Artistic License, as specified in the Perl README file.
 
=head1 ACKNOWLEDGEMENTS
 
I would like to thank TBBle for his initial research into the protocol,
Starnet for providing such a dodgy protocol, and Bruceo and JT for
providing incentive to actually bother to write this program.
 
=head1 SEE ALSO
 
Um.
 
=cut
 
use strict;
use Carp;
use Getopt::Std;

$|++;
 
# Declare constants:
use constant DEBUG => 0;
 
use constant SDA_LOGIN_YES  => 1;
use constant SDA_LOGIN_NO  => 0;
use constant SDA_LOGIN_INCORRECT_USERPASS => 1;
use constant SDA_LOGIN_NO_QUOTA           => 3;
use constant SDA_LOGIN_ALREADY_CONNECTED  => 4;
 
use constant SDA_UPDATE_YES => 1;
use constant SDA_UPDATE_NO  => 0;
 
use constant SDA_UPDATE_TIME => 60;
 
# Initialise input:
 
my %opts;
getopt('Vvhi:s:', \%opts) or croak "Couldn't parse options";
 
if (exists $opts{h})
{
    print "$0 [-v | -h | -v [-i ip] [-s host ] [ -p port] ]\n";
    exit 0;
}
else
{
    print "Starnet Data Accounting System Login.\n";
}
exit 0 if exists($opts{V});
 
my $VERBOSE = 0;
$VERBOSE++ if exists $opts{v};
 
my ($user,$pass) = <>;
for ($user, $pass)
{
    chomp if defined;
};
 
my ($hostname, $server, $port) = @opts{qw/h s p/};
 
print `pwd` if $VERBOSE;
 
my $sda = Net::Starnet::DataAccounting->new(
    user => $user,
    pass => $pass,
    verbose => $VERBOSE,
    login  => \&login,
    logout => \&logout,
    update => \&update,
    (defined($hostname) ? ( host => $hostname ) : ()),
    (defined($server) ? ( server => $server ) : ()),
);
 
# Do stuff
my $connected = $sda->login();
 
if ($connected)
{
    $SIG{INT} = $SIG{TERM} = sub {
        $sda->logout();
        exit 0;
    };
    while ($connected)
    {
        sleep SDA_UPDATE_TIME;
        $connected = $sda->update();
    }
    my $disconnected = $sda->logout();
}
 
# ------------------------------------------------------------------------
#                                                                    Login
# ------------------------------------------------------------------------
sub login
{
    my $connected = 0;
    my ($sda, $response) = @_;
 
# Handle response:
 
    do
    {
        my ($type, $success, $code, $msg) =
        ($response  =~ /^(\d)\s(\d)\s(\d)\s(.+)\s*$/);
        if (SDA_LOGIN_YES == $success)
        {
            print "Connected: [$code] $msg\n";
            $connected = 1;
        }
        elsif (SDA_LOGIN_NO == $success)
        {
            print "Couldn't connect: [$code] $msg\n";
            $connected = 1 if (SDA_LOGIN_ALREADY_CONNECTED == $code);
        }
        else
        {
            print "Unknown response: $success $code $msg\n";
        }
    };
 
# Return:
    return $connected;
}
 
# ------------------------------------------------------------------------
#                                                                   Update
# ------------------------------------------------------------------------
sub update
{
    my $updated = 0;
    my ($sda, $response) = @_;
 
    do
    {
        my ($type, $success, $msg) =
        ($response  =~ /^(\d)\s(\d)\s(.+)\s*$/);
        if (SDA_UPDATE_YES == $success)
        {
            $updated = 1;
            print "Updated: [$success] $msg\n";
        }
        elsif (SDA_UPDATE_NO == $success)
        {
            $updated = 0;
            print "Couldn't update: [$success] $msg\n";
        }
        else
        {
            print "Unknown update response: [$success] $msg\n";
        }
    };
 
    return $updated;
}
# ------------------------------------------------------------------------
#                                                                   Logout
# ------------------------------------------------------------------------
sub logout
{
    my $disconnected = 0;
    my ($sda, $response) = @_;
 
    if ($response =~ /^2\s1\s(.+)\sMb\sQuota_Remaing\.$/)
    {
        print "Logging out: $1 Mb quota remaining.\n";
    }
    elsif ($response =~ /^2\s1\s-1\sLogoff_Confirmed\.$/)
    {
        print "Logoff confirmed.\n";
        $disconnected = 1;
    }
    else
    {
        print "Unknown logout response: $response\n";
    }
 
    unless ($disconnected)
    {
        $sda->logout;
    }
 
    return $disconnected;
}
 
 
 
 
# ========================================================================
# The End.
