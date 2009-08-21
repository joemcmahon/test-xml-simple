package Test::XML::Simple;

use strict;
use warnings;

our $VERSION = '0.04';

use Test::Builder;
use Test::More;
use XML::XPath;

my $Test = Test::Builder->new();
my $Xml;
my $last_xml_string = "";

sub import {
   my $self = shift;
   my $caller = caller;
   no strict 'refs';
   *{$caller.'::xml_valid'}      = \&xml_valid;
   *{$caller.'::xml_node'}       = \&xml_node;
   *{$caller.'::xml_is'}         = \&xml_is;
   *{$caller.'::xml_is_deeply'}  = \&xml_is_deeply;
   *{$caller.'::xml_like'}       = \&xml_like;

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

  return $Test->diag("XML is not defined") unless defined $xml;
  return $Test->diag("XML is missing")     unless $xml;
  return $Test->diag("string can't contain XML: no tags") 
    unless ($xml =~ /</ and $xml =~/>/);
  eval {$Xml = XML::XPath->new(xml=>$xml)};
  $@ ? return $Test->diag($@)
     : return $Xml;
}

sub _find {
  my ($xml_xpath, $xpath) = @_;
  my $nodeset = $xml_xpath->find($xpath);
  return $Test->diag("Couldn't find $xpath") unless @$nodeset;
  wantarray ? @$nodeset : $nodeset;
}
  

sub xml_node($$;$) {
  my ($xml, $xpath, $comment) = @_;

  my $parsed_xml = _valid_xml($xml);
  return 0 unless $parsed_xml;

  my $nodeset = _find($parsed_xml, $xpath);
  return 0 if !$nodeset;

  ok(scalar $nodeset->get_nodelist, $comment);
}

sub xml_is($$$;$) {
  my ($xml, $xpath, $value, $comment) = @_;

  my $parsed_xml = _valid_xml($xml);
  return 0 unless $parsed_xml;

  my $nodeset = _find($parsed_xml, $xpath);
  return 0 if !$nodeset;

  foreach my $node ($nodeset->get_nodelist) {
    my @kids = $node->getChildNodes;
    if (@kids) {
      is($kids[0]->toString, $value, $comment);
    }
    else {
      my $got =  $node->toString;
      $got =~ s/^.*="(.*)"/$1/;
      is $got, $value, $comment;
    }
  }
}

sub xml_is_deeply($$$;$) {
  my ($xml, $xpath, $candidate, $comment) = @_;

  my $parsed_xml = _valid_xml($xml);
  return 0 unless $parsed_xml;

  my $candidate_xp = XML::XPath->new(xml=>$candidate);
  is($parsed_xml->findnodes_as_string($xpath), 
     $candidate_xp->findnodes_as_string('/'),
     $comment);
}

sub xml_like($$$;$) {
  my ($xml, $xpath, $regex, $comment) = @_;

  my $parsed_xml = _valid_xml($xml);
  return 0 unless $parsed_xml;

  my $nodeset = _find($parsed_xml, $xpath);
  return 0 if !$nodeset;

  foreach my $node ($nodeset->get_nodelist) {
    my @kids = $node->getChildNodes;
    if (@kids) {
      like($kids[0]->toString, $regex, $comment);
    }
    else {
      my $got =  $node->toString;
      $got =~ s/^.*="(.*)"/$1/;
      like $got, $regex, $comment;
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

=head2 xml_is $xml, $xpath, $value, 'test description'

Finds the node corresponding to the supplied XPath expression and
compares it to the supplied value. Succeeds if the two values match.

=head2 xml_like $xml, $xpath, $regex, 'test description'

Find the XML corresponding to the the XPath expression and check it
against the supplied regular expression. Succeeds if they match.

=head2 xml_is_deeply $xml, $xpath, $xml2, 'test description'

Find the piece of XML corresponding to the XPath expression,
and compare its structure and contents to the second XML
(fragment) supplied. Succeeds if they match in structure and
content.

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