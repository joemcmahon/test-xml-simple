#!/usr/bin/env perl

use strict;
use warnings;

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

test_out( 'ok 1 - xml', 'ok 2 - $XML_DOC is a XML::LibXML::Document' );
xml_valid( $xml, 'xml' );
my $xml_doc = do {
    no warnings 'once';    ## no critic (TestingAndDebugging::ProhibitNoWarnings)
    $Test::XML::Simple::XML_DOC;
};
is( ref($xml_doc), 'XML::LibXML::Document', '$XML_DOC is a XML::LibXML::Document' );
test_test('$XML_DOC is a XML::LibXML::Document');
