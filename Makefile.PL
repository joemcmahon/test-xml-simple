use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Test::XML::Simple',
    'VERSION_FROM'	=> 'lib/Test/XML/Simple.pm', # finds $VERSION
    'LICENSE'           => 'artistic',
    'PREREQ_PM'		=> {
                             Test::Builder => 0,
                             Test::Tester => 0,
                             Test::More => 0,
                             Test::LongString => 0,
                             XML::LibXML => 0,
                           }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'lib/Test/XML/Simple.pm', 
                      # retrieve abstract from module
       AUTHOR     => 'Joe McMahon <mcmahon@cpan.org>') : ()),
);
