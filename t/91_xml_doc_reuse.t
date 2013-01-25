#!/usr/bin/env perl

use strict;
use warnings;

use Scalar::Util 'refaddr';
use Test::Builder::Tester tests => 1;
use Test::More;
use Test::XML::Simple;

my $xml = <<'EOS';
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

test_out( 'ok 1 - xml_valid', 'ok 2 - xml_valid', 'ok 3 - XML_DOC objects are same' );
{
    no warnings 'once';    ## no critic (TestingAndDebugging::ProhibitNoWarnings)
    $Test::XML::Simple::XML_DOC_REUSE = 1;
}
xml_valid( $xml, 'xml_valid' );
my $xml_doc1 = $Test::XML::Simple::XML_DOC;
xml_valid( $xml, 'xml_valid' );
my $xml_doc2 = $Test::XML::Simple::XML_DOC;
ok( ( $xml_doc1 and ref($xml_doc1) and $xml_doc2 and ref($xml_doc2) and refaddr($xml_doc1) == refaddr($xml_doc2) ),
    'XML_DOC objects are same' )
  or diag refaddr($xml_doc1) . ' != ' . refaddr($xml_doc2);
test_test('$XML_DOC reused');
