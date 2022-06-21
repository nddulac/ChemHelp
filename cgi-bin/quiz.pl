#!/usr/bin/perl -wT

################################################################################
# A simple grading script for quizzes with multiple multiple choice questions
# Patrick E. Fleming
# California State University, East Bay
# February 3, 2016
################################################################################

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

################################################################################
# declare some variables
################################################################################
my @Question;                                    # array to hold questions
my @Answer;                                      # array to hold selected answers
my @Correct;                                     # array to hold correct answers

################################################################################
# parse the form
################################################################################
my $nq = param('nquestions');                    # how many questions were there?
foreach my $i (1..$nq) {                         
  my $qkey = "Question" . $i;                    # Generate question key
  my $akey = "Answer" . $i;                      # Generate selected answer key
  my $ckey = "Correct" . $i;                     # Generate correct answer key
  $Question[$i] = param($qkey);                  # Get the Question from form data
  $Answer[$i] = param($akey);                    # Get the seleced answer from form data
  $Correct[$i] = param($ckey);                   # Get the correct answer from form data
}

################################################################################
# begin the html output
################################################################################
print header;
print start_html("Your Grade");
print "<h2>Your Grade</h2>\n\n";

################################################################################
# grade the quiz
################################################################################
my $grade = 0;                                   # initialize the score
foreach my $i (1 .. $nq) {
  my $qkey = "Question" . $i;                    # Generate question key
  my $akey = "Answer" . $i;                      # Generate selected answer key
  my $ckey = "Correct" . $i;                     # Generate correct answer key
  print "<table>\n";
  print "  <tr>\n";
  print "    <td bgcolor=\"ffccff\">\n";
  print "Question", $i, " was:<br>\n";
  print $Question[$i], "\n";
  print "    </td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td bgcolor=\"ccffff\">\n";
  print "You selected: ", $Answer[$i], "\n";
  print "    </td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td bgcolor=\"ffffcc\">\n";
  print "The correct answer is: ", $Correct[$i], "\n";
  print "    </td>\n";
  print "  </tr>\n";
  print "</table>\n";
  if ($Answer[$i] eq $Correct[$i]) {
    $grade += 1;                                 # you get a point!
    print "<font color=\"green\">You are correct!</font><p>\n\n";
  } else {
    print "<font color=\"red\">You are incorrect.</font><p>\n\n";
  }
}

print "<font size=\"+2\" color=\"blue\">You got $grade out of $nq correct.</font><p>\n";
print "<hr>\n";
print "Patrick E. Fleming<br>\n";
print "Department of Chemistry and Biochemistry<br>\n";
print "California State University, East Bay<p>\n";

################################################################################
# End the html
################################################################################

print end_html;
