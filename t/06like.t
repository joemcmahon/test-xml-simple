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

@results = run_tests(
    sub {
          xml_like($xml, "//ARTIST", qr/st/i, "good node")
    },
    {
       ok=>1,
    }
 );
ok($results[1]->{ok}, 'found node');

@results = run_tests(
    sub {
          xml_like($xml, "/CATALOG/CD/ARTIST", qr/ing/, "full path")
    },
    {
       ok=>1,
    }
 );
ok($results[1]->{ok}, 'found path');

=begin skip_tests

@results = run_tests(
    sub {
          xml_like($xml, "//ARTIST", qr/Weird Al/, "good node")
    },
    {
       ok=>0,
    }
 );

@results = run_tests(
    sub {
          xml_like($xml, "/CATALOG/CD/ARTIST", qr/Weird Al/, "full path")
    },
    {
       ok=>0,
    }
 );

=end skip_tests
