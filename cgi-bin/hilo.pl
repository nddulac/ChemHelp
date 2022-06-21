#!/usr/bin/perl -wT

# A game of higher/lower
# Patrick E. Fleming
# December 14, 2015

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# parse the form:
my $branch = param('branch');
my $guess = param('guess');
my $answer = param('answer');
my $number = param('number');

print header;
print start_html("The Great Game of Heigher or Lower");
print h2("Higher or Lower");

if ($branch eq "") {
  #Pick a random number between 1 and 10
  $answer = int(rand(9) + 1.1);
  $number = 0;
  print "I am thinking of a number between 1 and 10 . . .<p>\n";
  print "What is your guess?\n";
  print "<form action=\"/~pfleming/cgi-bin/hilo.pl\" method=\"post\">\n";
  print "<input type=\"hidden\" name=\"answer\" value=\"", $answer, "\">\n";
  print "<input type=\"hidden\" name=\"branch\" value=\"continue\">\n";
  print "<input type=\"input\" name=\"guess\" autofocus>\n";
  print "<input type=\"submit\" value=\"Guess!\">\n";
  print "</form>\n";
} 
if ($branch eq "continue") {
  if ($guess > $answer) {
    $number++;
    print "I am thinking of a number between 1 and 10 . . .<p>\n";
    print "Your guess was ", $guess, ".<p>\n";
    print "The answer is lower!<p>\n";
    print "What is your new guess?\n";
    print "<form action=\"/~pfleming/cgi-bin/hilo.pl\" method=\"post\">\n";
    print "<input type=\"hidden\" name=\"answer\" value=\"", $answer, "\">\n";
    print "<input type=\"hidden\" name=\"branch\" value=\"continue\">\n";
    print "<input type=\"hidden\" name=\"number\" value=\"",$number,"\">\n";
    print "<input type=\"input\" name=\"guess\" autofocus>\n";
    print "<input type=\"submit\" value=\"Guess!\">\n";
    print "</form>\n";
  }
  if ($guess < $answer) {
    $number++;
    print "I am thinking of a number between 1 and 10 . . .<p>\n";
    print "Your guess was ", $guess, ".<p>\n";
    print "The answer is higher!<p>\n";
    print "What is your new guess?<p>\n";
    print "<form action=\"/~pfleming/cgi-bin/hilo.pl\" method=\"post\">\n";
    print "<input type=\"hidden\" name=\"answer\" value=\"", $answer, "\">\n";
    print "<input type=\"hidden\" name=\"branch\" value=\"continue\">\n";
    print "<input type=\"hidden\" name=\"number\" value=\"",$number,"\">\n";
    print "<input type=\"input\" name=\"guess\" autofocus>\n";
    print "<input type=\"submit\" value=\"Guess!\">\n";
    print "</form>\n";
  }
  if ($guess == $answer) {
    $number++;
    print "I am thinking of a number between 1 and 10 . . .<p>\n";
    print "Your guess was ", $guess, ".<p>\n";
    print "Your guess was right on the nosey!<p>\n";
    print "You got it in $number guesses!<p>\n";
    print "<form action=\"/~pfleming/cgi-bin/hilo.pl\" method=\"post\">\n";
    print "<input type=\"hidden\" name=\"branch\" value=\"\">\n";
    print "<input type=\"submit\" value=\"Play Again!\">\n";
    print "</form><p>\n";
    print "I don't want to play any more. <a href=/~pfleming/>Get outta here!</a>\n";
  }
}
if ($branch ne "" && $branch ne "continue") {
  print "<a hreg=/~pfleming/>Get outta here!</a>\n";
}

print end_html;
