use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'Rex-Virt',
   VERSION_FROM => 'lib/Rex/Virt.pm',
   PREREQ_PM => {'Rex' => '0.3.99.4', 'Sys::Virt' => 0},
   LICENSE => 'perl'
);

