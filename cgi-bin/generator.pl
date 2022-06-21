#!/usr/bin/perl -wT

# A simple question generation script for simple quiz questions
# Patrick E. Fleming
# California State University, East Bay
# January 5, 2016

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# parse the form:
# my %form;
my $anchor = param('anchor');
my $question = param('question');
my $ans1 = param('ans1');
my $ans2 = param('ans2');
my $ans3 = param('ans3');
my $ans4 = param('ans4');
my $correct = param('correct');

if ($correct eq "ans1") {
  $correct = $ans1;
}
if ($correct eq "ans2") {
  $correct = $ans2;
}
if ($correct eq "ans3") {
  $correct = $ans3;
}
if ($correct eq "ans4") {
  $correct = $ans4;
}

print header;
print start_html("Question");
print h2("Question");
print "\n\n";
print"<hr>\n";
print "<a name=\"$anchor\">\n";
print "<form action=\"/~pfleming/cgi-bin/question.pl\" method=\"post\">\n";
print "<input type=\"hidden\" name=\"question\" value=\"$question\">\n";
print "<input type=\"hidden\" name=\"correct\" value=\"$correct\">\n";
print "<input type=\"hidden\" name=\"backurl\" value=\"/~pfleming/dummy.htm#$anchor\">\n";
print "<table>\n";
print "  <tr>\n";
print "    <td bgcolor=\"99ccff\" colspan=\"4\"> $question </td>\n";
print "  </tr>\n";
print "  <tr>\n";
print "    <td bgcolor=\"ccffcc\"><input type=\"radio\" name=\"answer\" value=\"$ans1\">$ans1</td>\n";
print "    <td bgcolor=\"ffffcc\"><input type=\"radio\" name=\"answer\" value=\"$ans2\">$ans2</td>\n";
print "    <td bgcolor=\"ccffcc\"><input type=\"radio\" name=\"answer\" value=\"$ans3\">$ans3</td>\n";
print "    <td bgcolor=\"ffffcc\"><input type=\"radio\" name=\"answer\" value=\"$ans4\">$ans4</td>\n";
print "  </tr>\n";
print "  <tr>\n";
print "    <td colspan=\"2\"><input type=\"submit\" value=\"Am I right?\"></td>\n";
print "    <td colspan=\"2\"><input type=\"reset\" value=\"Start over\"></td>\n";
print "  </tr>\n";
print "</table>\n";
print "</form><p>\n\n";
print "<hr>\n";
print end_html;