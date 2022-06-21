#!/usr/bin/perl -wT

use strict;
use warnings;
use CGI qw(:standard);

my $file = param('TestBank');                     # File in which the testbank is located
$file = "TestBankVault/" . $file;                 # hide the location of the testbank file
my $nquestions = param('nquestions');             # Set the number of questions in the practice test
if ($nquestions < 5) {
  $nquestions = 5;                                # Make five qustions the minimum number
}
if ($nquestions > 25) {
  $nquestions = 25;                               # Make twenty five qustions the maximum number
}
my $nques = 0;                                    # Counter for number of question in testbank
my @Question;                                     # Array to hold questions
my @Correct;                                      # Array to hold correct answers
my @Answer;                                       # Matrix holding answer choices


open (my $data, '<', $file) or die "File $file no found, you bozo!\n";
while (my $line = <$data>) {                      # Read Test File
  chomp $line;
  $nques += 1;                                    # count the number of qquestions read
  my @field = split ",", $line;
  $Question[$nques] = $field[0];
  $Correct[$nques] = $field[1];
  $Answer[$nques][1] = $field[1];
  $Answer[$nques][2] = $field[2];
  $Answer[$nques][3] = $field[3];
  $Answer[$nques][4] = $field[4];
  $Answer[$nques][5] = $field[5];
}

###############################################################################
## Begin form for test
###############################################################################
print header;
print start_html("A Paractice Test");
print "<h1>A Practice Test</h1>\n\n";

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
  ## Randomize the answers
  ###############################################################################
  foreach my $j (1 .. 5) {                        # Go through each answer one by one
	my $k = 1 + int rand(5);                      # Choose a randome answer to swap it with
	my $dummy = $Answer[$q][$k];                  #
	$Answer[$q][$k] = $Answer[$q][$j];            # Swap it
	$Answer[$q][$j] = $dummy;                     #
  }

  ###############################################################################
  ## Now write the question
  ###############################################################################
  print "<a name=\"", $Qno, "\">\n";
  print "<input type=\"hidden\" name=\"", $Qno, "\" value=\"", $Question[$q], "\">\n";
  print "<input type=\"hidden\" name=\"", $Cno, "\" value=\"", $Correct[$q], "\">\n";
  print "<table align=\"center\" width=\"60%\">\n";
  print "  <tr>\n";
  print "    <td bgcolor=\"99ccff\" colspan=\"5\">", $Question[$q], "</td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td bgcolor=\"ffccff\" width=\"20%\"><input type=\"radio\" name=\"", $Ano, "\" value=\"", $Answer[$q][1], "\">", $Answer[$q][1], "</td>\n";
  print "    <td bgcolor=\"ccffcc\" width=\"20%\"><input type=\"radio\" name=\"", $Ano, "\" value=\"", $Answer[$q][2], "\">", $Answer[$q][2], "</td>\n";
  print "    <td bgcolor=\"ffccff\" width=\"20%\"><input type=\"radio\" name=\"", $Ano, "\" value=\"", $Answer[$q][3], "\">", $Answer[$q][3], "</td>\n";
  print "    <td bgcolor=\"ccffcc\" width=\"20%\"><input type=\"radio\" name=\"", $Ano, "\" value=\"", $Answer[$q][4], "\">", $Answer[$q][4], "</td>\n";
  print "    <td bgcolor=\"ffccff\" width=\"20%\"><input type=\"radio\" name=\"", $Ano, "\" value=\"", $Answer[$q][5], "\">", $Answer[$q][5], "</td>\n";
  print "  </tr>\n";
  print "  </table></a><p>\n\n";
}

###############################################################################
## Finish form for test
###############################################################################
print "<table align=\"center\" width=\"60%\">\n";
print "  <tr>\n";
print "    <td><center><input type=\"submit\" value=\"Grade my Test!\"></center></td>\n";
print "    <td><center><input type=\"reset\" value=\"Reset\"></center></td>\n";
print "  </tr>\n";
print "</table>\n";
print "</form>\n";


