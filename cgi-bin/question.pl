#!/usr/bin/perl -wT

# A simple question-response script for simple quiz questions
# Patrick E. Fleming
# California State University, East Bay
# December 14, 2015

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# parse the form:
# my %form;
my $q = param('question');
my $a = param('answer');
my $c = param('correct');
my $u = param('units');
if ($u ne "") {
  $a = $a . " " . $u;
}
my $burl = param('backurl');

print header;
print start_html("Response");
print h2("Question response");

print "<b><u>The question was</u></b>:<br>\n";
print "", $q, "<p>\n";

print "<b><u>You selected</u></b>:<br>\n";
print "", $a, "<p>\n";

print "<b><u>The correct answer is</u></b>:<br>\n";
print "", $c, "<p>\n";

if ($a eq $c) {
  print "<font size=\"+3\" color=\"green\"><b>You are correct!</b></font><p>\n";
} else {
  print "<font color=\"red\"> Oops. You are incorrect.</font><p>\n";
}

print "<a href=\"", $burl, "\">Back</a>";
print end_html;