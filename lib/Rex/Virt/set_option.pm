#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package Rex::Virt::set_option;

use strict;
use warnings;

use Rex::Logger;

my $FUNC_MAP = {
   max_memory  => "set_max_memory",
   memory      => "set_memory",
};

sub run {
   my ($class, $arg1, %opt) = @_;

   unless($arg1) {
      Rex::Logger::info("You have to define the vm name!");
      exit 2;
   }

   Rex::Logger::debug("setting some options for: $arg1");
   my $dom = Rex::Virt::connection()->get_domain_by_name($arg1);

   unless($dom) {
      Rex::Logger::info("VM $arg1 not found.");
      exit 2;
   }

   for my $opt (keys %opt) {
      my $val = $opt{$opt};

      unless(exists $FUNC_MAP->{$opt}) {
         Rex::Logger::info("$opt can't be set right now.");
         next;
      }

      eval {
         my $func = $FUNC_MAP->{$opt};
         $dom->$func($val);
      };

      if($@) {
         Rex::Logger::info("Error setting $opt to $val on $arg1 ($@)");
      }

   }

}

1;

