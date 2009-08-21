use Test::More tests=>6;
use Test::XML::Simple;
use Test::Tester;

my $totally_invalid = <<EOS;
yarrgh there be no XML here
EOS

my $broken_xml = <<EOS;
<imatag> but this isn't good<nomatch>
EOS

my $valid = <<EOS;
<CATALOG>
  <CD>
    <TITLE>Sacred Love</TITLE>
    <ARTIST>Sting</ARTIST>
    <COUNTRY>USA</COUNTRY>
    <COMPANY>A&amp;M</COMPANY>
    <PRICE>12.99</PRICE>

    <YEAR>2003</YEAR>
  </CD>
</CATALOG>
EOS

@results = run_tests(
    sub {
          xml_valid(undef, "no xml")
    }
  );
is($results[1]->{diag}, undef, "1 skipped");
ok(!$results[1]->{ok}, '2 failed as expected');

@results = run_tests(
    sub {
          xml_valid($totally_invalid, "invalid xml")
    }
  );
is($results[1]->{diag}, undef, "3 skipped");
ok(!$results[1]->{ok}, '4 failed as expected');

@results = run_tests(
    sub {
          xml_valid($valid, "good xml")
    },
    {
       ok=>1,
    }
  );

@results = run_tests(
    sub {
          xml_valid($broken_xml, "invalid xml")
    },
    {
       ok=>undef
    }
  );
