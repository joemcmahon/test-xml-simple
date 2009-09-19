use Test::Builder::Tester;
use Test::More tests=>6;
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

test_out("ok 1 - good node");
xml_is($xml, "//ARTIST", 'Sting', "good node");
test_test("node match");

test_out('ok 1 - good node');
xml_is_long($xml, "//ARTIST", 'Sting', "good node");
test_test("long node match");

test_out('ok 1 - full path');
xml_is($xml, "/CATALOG/CD/ARTIST", 'Sting', "full path");
test_test("node match");

test_out('ok 1 - full path');
xml_is_long($xml, "/CATALOG/CD/ARTIST", 'Sting', "full path");
test_test("long node match");

test_out('not ok 1 - good node');
test_err(qq(#   Failed test 'good node'
#   at t/05is.t line 43.
#          got: "Sting"
#       length: 5
#     expected: "Weird Al"
#       length: 8
#     strings begin to differ at char 1) );
xml_is($xml, "//ARTIST", 'Weird Al', "good node");
test_test("node miss");

test_out('not ok 1 - full path');
test_err(qq(#   Failed test 'full path'
#   at t/05is.t line 54.
#          got: "Sting"
#       length: 5
#     expected: "Weird Al"
#       length: 8
#     strings begin to differ at char 1) );
xml_is($xml, "/CATALOG/CD/ARTIST", 'Weird Al', "full path");
test_test("full path miss");
