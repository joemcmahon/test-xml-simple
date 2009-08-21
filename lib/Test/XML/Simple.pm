package Test::XML::Simple;

use strict;
use warnings;

our $VERSION = '0.07';

use Test::Builder;
use Test::More;
use Test::LongString;
use XML::LibXML;

my $Test = Test::Builder->new();
my $Xml;
my $last_xml_string = "";

sub import {
   my $self = shift;
   my $caller = caller;
   no strict 'refs';
   *{$caller.'::xml_valid'}          = \&xml_valid;
   *{$caller.'::xml_node'}           = \&xml_node;
   *{$caller.'::xml_is'}             = \&xml_is;
   *{$caller.'::xml_is_long'}        = \&xml_is_long;
   *{$caller.'::xml_is_deeply'}      = \&xml_is_deeply;
   *{$caller.'::xml_is_deeply_long'} = \&xml_is_deeply_long;
   *{$caller.'::xml_like'}           = \&xml_like;
   *{$caller.'::xml_like_long'}      = \&xml_like_long;

   $Test->exported_to($caller);
   $Test->plan(@_);
}

sub xml_valid($;$) {
  my ($xml, $comment) = @_;
  my $parsed_xml = _valid_xml($xml);
  return 0 unless $parsed_xml;

  ok $parsed_xml, $comment;
}

sub _valid_xml {
  my $xml = shift;
  return $Xml if defined($xml) and $xml eq $last_xml_string;

  return fail("XML is not defined") unless defined $xml;
  return fail("XML is missing")     unless $xml;
  return fail("string can't contain XML: no tags") 
    unless ($xml =~ /</ and $xml =~/>/);
  eval {$Xml = XML::LibXML->new->parse_string($xml)};
  $@ ? return fail($@)
     : return $Xml;
}

sub _find {
  my ($xml_xpath, $xpath) = @_;
  my @nodeset = $xml_xpath->findnodes($xpath);
  return fail("Couldn't find $xpath") unless @nodeset;
  wantarray ? @nodeset : \@nodeset;
}
  

sub xml_node($$;$) {
  my ($xml, $xpath, $comment) = @_;

  my $parsed_xml = _valid_xml($xml);
  return 0 unless $parsed_xml;

  my $nodeset = _find($parsed_xml, $xpath);
  return 0 if !$nodeset;

  ok(scalar @$nodeset, $comment);
}


sub xml_is($$$;$) {
  _xml_is(\&is_string, @_);
}

sub xml_is_long($$$;$) {
  _xml_is(\&is, @_);
}

sub _xml_is {
  my ($comp_sub, $xml, $xpath, $value, $comment) = @_;

  my $parsed_xml = _valid_xml($xml);
  return 0 unless $parsed_xml;

  my $nodeset = _find($parsed_xml, $xpath);
  return 0 if !$nodeset;

  foreach my $node (@$nodeset) {
    my @kids = $node->getChildNodes;
    if (@kids) {
      $comp_sub->($kids[0]->toString, $value, $comment);
    }
    else {
      my $got =  $node->toString;
      $got =~ s/^.*="(.*)"/$1/;
      is $got, $value, $comment;
    }
  }
}

sub xml_is_deeply($$$;$) {
  _xml_is_deeply(\&is_string, @_);
}

sub xml_is_deeply_long($$$;$) {
  _xml_is_deeply(\&is, @_);
}

sub _xml_is_deeply {
  my ($is_sub, $xml, $xpath, $candidate, $comment) = @_;

  my $parsed_xml = _valid_xml($xml);
  return 0 unless $parsed_xml;

  my $candidate_xp;
  eval {$candidate_xp = XML::LibXML->new->parse_string($candidate) };
  return 0 unless $candidate_xp; 

  my $parsed_thing    = $parsed_xml->findnodes($xpath)->[0];
  my $candidate_thing = $candidate_xp->findnodes('/')->[0];

  $candidate_thing = $candidate_thing->documentElement
    if $parsed_thing->isa('XML::LibXML::Element');

  $is_sub->($parsed_thing->toString, 
            $candidate_thing->toString,
            $comment);
}

sub xml_like($$$;$) {
  _xml_like(\&like_string, @_);
}

sub xml_like_long($$$;$) {
  _xml_like(\&like, @_);
}

sub _xml_like {
  my ($like_sub, $xml, $xpath, $regex, $comment) = @_;

  my $parsed_xml = _valid_xml($xml);
  return 0 unless $parsed_xml;

  my $nodeset = _find($parsed_xml, $xpath);
  return 0 if !$nodeset;

  foreach my $node (@$nodeset) {
    my @kids = $node->getChildNodes;
    my $found;
    if (@kids) {
      foreach my $kid (@kids) {
        if ($kid->toString =~ /$regex/) {
          $found = 1;
          $like_sub->($kid->toString, $regex, $comment);
        }
      }
      if (! $found) {
        ok(0, "no match in tag contents (including CDATA)");
      }
    }
    else {
      my $got =  $node->toString;
      $got =~ s/^.*="(.*)"/$1/;
      $like_sub->(like $got, $regex, $comment);
    }
  }
}

1;
__END__

=head1 NAME

Test::XML::Simple - easy testing for XML

=head1 SYNOPSIS

  use Test::XML::Simple tests=>5;
  xml_valid $xml, "Is valid XML";
  xml_node $xml, "/xpath/expression", "specified xpath node is present";
  xml_is, $xml, '/xpath/expr', "expected value", "specified text present";
  xml_like, $xml, '/xpath/expr', qr/expected/, "regex text present";
  xml_is_deeply, $xml, '/xpath/expr', $xml2, "structure and contents match";

  # Not yet implemented:
  # xml_like_deeply would be nice too...

=head1 DESCRIPTION

C<Test::XML::Simple> is a very basic class for testing XML. It uses the XPath
syntax to locate nodes within the XML. You can also check all or part of the
structure vs. an XML fragment.

=head1 TEST ROUTINES

=head2 xml_valid $xml, 'test description'

Pass an XML file or fragment to this test; it succeeds if the XML (fragment)
is valid.

=head2 xml_node $xml, $xpath, 'test description'

Checks the supplied XML to see if the node described by the supplied XPath
expression is present. Test fails if it is not present.

=head2 xml_is_long $xml, $xpath, $value, 'test description'

Finds the node corresponding to the supplied XPath expression and
compares it to the supplied value. Succeeds if the two values match.
Uses Test::More's C<is> function to do the comparison.

=head2 xml_is $xml, $xpath, $value, 'test description'

Finds the node corresponding to the supplied XPath expression and
compares it to the supplied value. Succeeds if the two values match.
Uses Test::LongString's C<is_string> function to do the test.

=head2 xml_like_long $xml, $xpath, $regex, 'test description'

Find the XML corresponding to the the XPath expression and check it
against the supplied regular expression. Succeeds if they match.
Uses Test::More's C<like> function to do the comparison.

=head2 xml_like $xml, $xpath, $regex, 'test description'

Find the XML corresponding to the the XPath expression and check it
against the supplied regular expression. Succeeds if they match.
Uses Test::LongString's C<like_string> function to do the test.

=head2 xml_is_deeply_long $xml, $xpath, $xml2, 'test description'

Find the piece of XML corresponding to the XPath expression,
and compare its structure and contents to the second XML
(fragment) supplied. Succeeds if they match in structure and
content. Uses Test::More's C<is> function to do the comparison.

=head2 xml_is_deeply $xml, $xpath, $xml2, 'test description'

Find the piece of XML corresponding to the XPath expression,
and compare its structure and contents to the second XML
(fragment) supplied. Succeeds if they match in structure and
content. Uses Test::LongString's C<is_string> function to do the test.

=head1 AUTHOR

Joe McMahon, E<lt>mcmahon@cpan.orgE<gt>

=head1 LEGAL

Copyright (c) 2005 by Yahoo!

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself, either Perl version 5.6.1 or, at
your option, any later version of Perl 5 you may have available.

=head1 SEE ALSO

L<XML::XPath>, L<Test::More>, L<Test::Builder>.


=cut
