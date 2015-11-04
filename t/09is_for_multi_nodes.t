#!/usr/bin/env perl

use strict;
use warnings;

use Test::Builder::Tester;
use Test::More tests => 6;
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
  <CD>
    <TITLE>Another Great Album</TITLE>
    <ARTIST>Sting</ARTIST>
    <COUNTRY>USA</COUNTRY>
    <COMPANY>A&amp;M</COMPANY>
    <PRICE>12.99</PRICE>
    <YEAR>2003</YEAR>
  </CD>
</CATALOG>
EOS

test_out( 'ok 1', 'ok 2' );
my $ok = xml_is( $xml, "//ARTIST", 'Sting' );
test_test('all nodes are equal');
ok( $ok, 'xml_is() return true for "all nodes are equal"' );

test_out( 'ok 1', 'not ok 2' );
my $line_num = line_num(+2);
test_err(qr/#\s+Failed test.*at $0 line $line_num.*/s);
$ok = xml_is( $xml, '//TITLE', 'Sacred Love' );
test_test('different nodes values');
ok( !$ok, 'xml_is() return false for "different nodes values"' );

test_out( 'not ok 1', 'ok 2' );
$line_num = line_num(+2);
test_err(qr/#\s+Failed test.*at $0 line $line_num.*/s);
$ok = xml_is( $xml, '//TITLE', 'Another Great Album' );
test_test('different nodes values, another order');
ok( !$ok, 'xml_is() return false for "different nodes values"' );
