#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package Rex::Virt;

use strict;
use warnings;

require Exporter;
use base qw(Exporter);
use vars qw(@EXPORT $conn $username $password $type);

use Rex::Logger;
use Sys::Virt;

our $VERSION = "0.3.99.4";

@EXPORT = qw(virt virt_username virt_password virt_type);

sub virt {
   my ($action, $arg1, %opt) = @_;

   my $mod = "Rex::Virt::$action";
   eval "use $mod;";

   if($@) {
      Rex::Logger::info("No action $action available.");
      exit 2;
   }

   return $mod->run($arg1, %opt);
}

sub virt_username {
   $username = shift;
}

sub virt_password {
   $password = shift;
}

sub virt_type {
   $type = shift;
}

sub connection {
   if($conn) {
      return $conn;
   }

   my $server = Rex::get_current_connection();
   my $server_name = $server->{"server"};

   Rex::Logger::debug("Creating libvirt connection to $server_name");
   Rex::Logger::debug("Virt-User: $username");
   Rex::Logger::debug("Virt-Password: $password");

   my $address = "$type+tcp://$server_name";
   eval {
      $conn = Sys::Virt->new(address => $address,
                             auth => 1,
                             credlist => [
                               Sys::Virt::CRED_AUTHNAME,
                               Sys::Virt::CRED_PASSPHRASE,
                             ],
                             callback =>
         sub {
               my $creds = shift;

               foreach my $cred (@{$creds}) {
                  if ($cred->{type} == Sys::Virt::CRED_AUTHNAME) {
                      $cred->{result} = $username;
                  }
                  if ($cred->{type} == Sys::Virt::CRED_PASSPHRASE) {
                      $cred->{result} = $password;
                  }
               }
               return 0;
         });
      };

      if($@) {
         Rex::Logger::info("Can't connect to libvirt on $server_name");
         exit 2;
      }

      return $conn;
}

1;
