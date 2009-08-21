use Test::Tester;
use Test::More tests=>8;
use Test::XML::Simple;

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
is($results[1]->{diag}, '', "skipped");
ok(!$results[1]->{ok}, 'failed as expected');

@results = run_tests(
    sub {
          xml_valid($totally_invalid, "invalid xml")
    }
  );
is($results[1]->{diag}, '', "skipped");
ok(!$results[1]->{ok}, 'failed as expected');

@results = run_tests(
    sub {
          xml_valid($broken_xml, "invalid xml")
    },
    {
       ok=>undef
    }
  );
is($results[1]->{diag}, '', "skipped");
ok(!$results[1]->{ok}, 'failed as expected');

@results = run_tests(
    sub {
          xml_valid($valid, "good xml")
    },
    {
       ok=>1,
    }
  );

is($results[1]->{diag}, '', "ran");
ok($results[1]->{ok}, 'succeeded as expected');
