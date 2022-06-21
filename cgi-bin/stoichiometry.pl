#!/usr/bin/perl -wT

use strict;
use warnings;
use CGI qw(:standard);

my $file = "stoich.csv";                          # File in which the testbank is located
my $nquestions = 1;                               # Set the number of questions in the practice test
my $nques = 0;                                    # Counter for number of question in testbank
my @Question;                                     # Array to hold questions
my @Correct;                                      # Array to hold correct answers
my @Answer;                                       # Matrix holding answer choices

open (my $data, '<', $file) or die "File $file not found, you bozo!\n";
while (my $line = <$data>) {                      # Read Test File
  chomp $line;
  $nques += 1;                                    # count the number of questions read
  my @field = split ",", $line;                   # split the input line by comma
  $Flag[$nques] = $field[0];                      # $Flag indicates the type of question (simple, limiting reagent, etc.)
  $max1[$nques] = $field[1];                      # $max1 indicates maximum for random value
  $min1[$nques] = $field[2];                      # $min1 indicates minimum for random value
  $sigfig[$nques] = $field[3];                    # $sigfig indicates number of sig. figures to be used in problem
  $Question[$nques] = $field[4];                  # $Question is the question
  $multiplier[$nques] = $field[5];                # $multiplier is used to generate the answer
  $reaction[$nques] = $field[6];                  # $reaction indicates the reaction (if needed)
}

###############################################################################
## Begin form for test
###############################################################################
print header;
print start_html("A Stoichiometry Quiz");
print "<h1>A Stoichiometry Quiz</h1>\n\n";

print "<form action=\"/~pfleming/cgi-bin/quiz.pl\" method=\"post\">\n";
print "<input type=\"hidden\" name=\"nquestions\" value=\"", $nquestions, "\">\n\n";

my @used;                                        # array to store used question numbers
foreach my $i (1 .. $nquestions) {
  $used[$i] = 0;
  my $Qno = "Question" . $i;
  my $Cno = "Correct" . $i;
  my $Ano = "Answer" . $i;

  ###############################################################################
  ## Choose a Question from the bank
  ###############################################################################
  my $q = 0;
  my $flag = "up";                                # put the flag up until we are sure
  do {
	$flag = "down";                               # put the flag down
	$q = 1 + int rand($nques);                    # choose a random item
	for my $j (1 .. $i) {
	  if ($q == $used[$j]) {                      # check to make sure it hasn't been used
		$flag = "up";                             # it has! put the flag up!
	  }
    }
  } while ($flag eq "up");
  $used[$i] = $q;                                 # finally found a unique question! store it!
  
  ###############################################################################
  ## Calculate the answer
  ###############################################################################
  my $answer = (rand($max1[$q] - $min1[$q]) + $min1[$q]) * $multiplier[$q];

  ###############################################################################
  ## Now write the question
  ###############################################################################
  print "<a name=\"", $Qno, "\">\n";
  print "<input type=\"hidden\" name=\"", $Qno, "\" value=\"", $Question[$q], "\">\n";
  print "<input type=\"hidden\" name=\"", $Cno, "\" value=\"", $answer, "\">\n";
  print "<table align=\"center\" width=\"60%\">\n";
  print "  <tr>\n";
  print "    <td bgcolor=\"99ccff\" colspan=\"5\">", $Question[$q], "</td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td> $reaction[$q] </td\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td bgcolor=\"ffccff\" width=\"20%\"><input name=\"", $Ano, "\" >", " g", "</td>\n";
  print "  </tr>\n"
  print "  </table></a><p>\n\n";
}

###############################################################################
## Finish form for test
###############################################################################
print "<table align=\"center\" width=\"60%\">\n";
print "  <tr>\n";
print "    <td><center><input type=\"submit\" value=\"Grade my quiz!\"></center></td>\n";
print "    <td><center><input type=\"reset\" value=\"Reset\"></center></td>\n";
print "  </tr>\n";
print "</table>\n";
print "</form>\n";


