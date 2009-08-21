use Test::Tester;
use Test::More tests=>3;
use Test::XML::Simple;

my $with_attr = <<EOS;
<results total="1">this is a result</results>
EOS

my @results = run_tests(
    sub {
          xml_is($with_attr, '//results/@total', "1", "nonempty works")
    },
    {
       ok=>1,
    }
 );
ok($results[1]->{ok}, "nonempty");

my $two_tag = <<EOS;
<results total="0"></results>
EOS

@results = run_tests(
    sub {
          xml_is($two_tag, '//results/@total', "0", "two-tag works")
    },
    {
       ok=>1,
    }
 );

ok($results[1]->{ok}, "two-tag");

my $collapsed = <<EOS;
<results total="0"/>
EOS

@results = run_tests(
    sub {
          xml_is($collapsed, '//results/@total', "0", "collapsed works")
    },
    {
       ok=>1,
    }
 );
ok($results[1]->{ok}, "collapsed");
