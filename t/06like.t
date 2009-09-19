use Test::Builder::Tester tests=>4;
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

test_out('ok 1 - good node');
xml_like($xml, "//ARTIST", qr/st/i, "good node");
test_test('node match');

test_out('ok 1 - full path');
xml_like($xml, "/CATALOG/CD/ARTIST", qr/ing/, "full path");
test_test('full path match');

test_out('not ok 1 - good node - no match in tag contents (including CDATA)');
test_err(qq(#   Failed test 'good node - no match in tag contents (including CDATA)'
#   at t/06like.t line 29.) );
xml_like($xml, "//ARTIST", qr/Weird Al/, "good node");
test_test('bad node match');

test_out('not ok 1 - full path - no match in tag contents (including CDATA)');
test_err(qq(#   Failed test 'full path - no match in tag contents (including CDATA)'
#   at t/06like.t line 35.) );
xml_like($xml, "/CATALOG/CD/ARTIST", qr/Weird Al/, "full path");
test_test('bad full path match');
