use Test::Tester;
use Test::More tests=>4;
use Test::XML::Simple;

my $xml = <<EOS;
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
          xml_node($xml, "//ARTIST", "good node")
    },
    {
       ok=>1,
    }
 );
ok($results[1]->{ok}, 'found node');

@results = run_tests(
    sub {
          xml_node($xml, "/CATALOG/ARTIST", "bad path")
    },
 );
ok(!$results[1]->{ok}, 'failed as expected');

@results = run_tests(
    sub {
          xml_node($xml, "/CATALOG/CD/ARTIST", "full path")
    },
    {
       ok=>1,
    }
 );
ok($results[1]->{ok}, 'found full path');

@results = run_tests(
    sub {
          xml_node($xml, "//FORMAT", "bad node")
    },
    {
       ok=>0,
    }
  );
ok(!$results[1]->{ok}, 'failed as expected');
