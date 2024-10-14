use Test::Builder::Tester tests=>4;
use Test::More;
use Test::XML::Simple;
use XML::LibXML;

my $totally_invalid = <<EOS;
yarrgh there be no XML here
EOS

my $broken_xml = <<EOS;
<imatag> but this isn't good<nomatch>
EOS

my $not_xml_doc = bless {}, 'Foo::Bar';

test_out("not ok 1 - XML is not defined");
test_fail(+1);
xml_valid(undef, "no xml");
test_test('undef');

test_out("not ok 1 - string can't contain XML: no tags");
test_fail(+1);
xml_valid($totally_invalid, "invalid xml");
test_test('non-XML string');

my $err_str = "not ok 1 - :2: parser error : Premature end of data in tag nomatch line 1\n# \n# ^";
test_out($err_str);
test_fail(+1);

xml_valid($broken_xml, "invalid xml");
test_test(title=>'bad XML', skip_err=>1);

test_out("not ok 1 - accept only 'XML::LibXML::Document' as object");
test_fail(+1);
xml_valid( $not_xml_doc, 'not xml doc object' );
test_test('not xml doc object');
