#
# Ejecutar script para paso a Produccion
#
# Parametros:
#    script_id
#    database
#    schema
#

use strict;
use warnings;
use Capture::Tiny ':all';
use Config::Tiny;
use Getopt::Long;



if ( scalar @ARGV < 3 ) {
    print scalar @_;
    die "Error:\n$0 <script_id> <database> <schema>";
}

my $script_id   = shift;
my $database    = shift;
my $schema      = shift;

my $config_file = 'scr2p.cfg';
my $config = Config::Tiny->new;
$config = Config::Tiny->read( $config_file, 'utf8' );

my $execfile;

if ( $config ) {
   $execfile = $config->{_}->{execfile};
} else {
    die "$0\nError: no se pudo leer variables de configuracion desde $config_file";
}

my $vault_pass = '';

my $file_script = getfile($script_id);
my $logfile     = getlogfilename($file_script);
my $pass        = getpass($database, $schema);

my $comand2exec = "$execfile -o .... -u -p $pass -i $file_script -log $logfile";
my $comand2exec_sinpass = $comand2exec;
$comand2exec_sinpass =~ s/$pass/------------/;

print "Ejecutando $comand2exec_sinpass ...";
my ($stdout, $stderr, $exit) = capture {
    #system( $omand2exec, @args );
    print $comand2exec;
  };


sub getpass {
    return "secret";
}

sub getfile {
    my $scr_file = shift;
    return "script_${scr_file}\.sql"
}

sub getlogfilename {
    my $filename = shift;
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    $year += 1900; 
    my $fecha = "$year$mon${mday}_$min$sec";
    my $logfilename = "$filename\.$fecha\.log";
    return $logfilename;
}



