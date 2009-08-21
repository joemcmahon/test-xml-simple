use Test::Tester;
use Test::More tests=>2;
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

my $fragment = <<EOS;
<ARTIST>Sting</ARTIST>
EOS

my @results = run_tests(
    sub {
          xml_is_deeply($xml, "//ARTIST", $fragment, "deep match")
    },
    {
       ok=>1,
    }
 );
ok $results[1]->{ok}, "deep match";

@results = run_tests(
    sub {
          xml_is_deeply($xml, "/", $xml, "identical match")
    },
    {
       ok=>1,
    }
 );
ok $results[1]->{ok}, "identity match";
