#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package Rex::Virt::list;

use strict;
use warnings;

use Rex::Logger;

sub run {
   my ($class, $arg1, %opt) = @_;

   my @domains;

   if($arg1 eq "all") {
      @domains = map { $_->get_name } Rex::Virt::connection()->list_defined_domains();
   }

   if($arg1 eq "running") {
      @domains = map { $_->get_name } Rex::Virt::connection()->list_domains();
   }

   return @domains;
}

1;
