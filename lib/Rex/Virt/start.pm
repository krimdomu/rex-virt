#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package Rex::Virt::start;

use strict;
use warnings;

use Rex::Logger;

sub run {
   my ($class, $arg1, %opt) = @_;

   unless($arg1) {
      Rex::Logger::info("You have to define the vm name!");
      exit 2;
   }

   Rex::Logger::debug("starting domain: $arg1");
   my $dom = Rex::Virt::connection()->get_domain_by_name($arg1);

   unless($dom) {
      Rex::Logger::info("VM $arg1 not found.");
      exit 2;
   }

   eval {
      $dom->create();
   };

   if($@) {
      Rex::Logger::info("Error starting vm $arg1");
      exit 2;
   }

}

1;

