#!/usr/bin/perl -wT

#################################################################################
## ions.pl
## Patrick E. Fleming
## February 2, 2016
##
## This script will generate a quiz asking the user to match ion formulae to ion
## names. Hopefully, it will be useful for General Chemistry students for review.
#################################################################################

use strict;
use warnings;
use CGI qw(:standard);

#################################################################################
## Get the control to see what to do
#################################################################################

my $control = param('control');

#################################################################################
## Read the ions in the data section at the end of the script
#################################################################################

my $i = 0;
my @name;
my @form;
while (my $line = <DATA>) {                      # Get each ion name and formua from one line of data
  chomp $line;
  my @fields = split ",", $line;
  $i += 1;
  $name[$i] = $fields[0];                        # contains the name of the ith ion
  $form[$i] = $fields[1];                        # contains the formula of the ith ion
}
my $nions = $i;                                  # stores the number of ions and frees $i for later

#################################################################################
## Begin HTML output
#################################################################################

print header;
print start_html(-title=>"Ions");
print "\n<h1>Ions</h1>\n\n";

#################################################################################
## Print a table of all of the ions
#################################################################################

if ($control eq "table") {
  print "<table border=\"1\">\n";
  print "  <tr>\n";
  print "    <td bgcolor=\"ffff33\"></td>\n";
  print "    <td bgcolor=\"ffff33\"><b>Name</b></td>\n";
  print "    <td bgcolor=\"ffff33\"><b>Formula</b></td>\n";
  print "  </tr>\n";
  for ($i = 1; $i <= $nions; $i += 1) {
    print "  <tr>\n";
    print "    <td> $i </td>\n";
    print "    <td bgcolor=\"ffcccc\"> $name[$i] </td>\n";
    print "    <td bgcolor=\"ccffcc\"> $form[$i] </td>\n";
    print "  </tr>\n";
  }
  print "</table><p>\n\n";
}

#################################################################################
## And now for a quiz
#################################################################################

if ($control eq "quiz") {
print "<form action=\"/~pfleming/cgi-bin/quiz.pl\" method=\"post\">\n";

my $nquestions = param('nquestions');            # number of questions from form
if ($nquestions < 5) {
  $nquestions = 5;                               # set a minimum of 5 questions
}
if ($nquestions > 25) {
  $nquestions = 25;                              # set a maximum of 25 questions
}

print "<input type=\"hidden\" name=\"nquestions\" value=\"", $nquestions, "\">\n\n";

my @qion;                                        # create an array to contain ion numbers in quiz

foreach my $Pno (1..$nquestions) {
  my $Qno = "Question" . $Pno;                   # which question is it
  my $Cno = "Correct" . $Pno;                    # passed as answer to question $Qno
  my $Ano = "Answer" . $Pno;                     # selected answer to question $Qno
  my $flag;
  my $goodness;

  $flag = "up";                                  # choose a unique ion for each question
  do {
    $flag = "down";
    $goodness = 1 + int rand($nions);
    foreach $i (@qion) {
      if ($i == $goodness) {
        $flag = "up";
      }
    }
  } while ($flag eq "up");
  $qion[$Pno] = $goodness;                       # which ion is used in the question
  my $nanswer = 1 + int rand(5);                 # choose which will be the correct answer

#################################################################################
## Now to generate a question
#################################################################################

  print "<a name=\"", $Qno, "\">\n";
  print "<input type=\"hidden\" name=\"", $Qno, "\" value=\"What is the formula for the $name[$qion[$Pno]] ion?\">\n";
  print "<input type=\"hidden\" name=\"", $Cno, "\" value=\"", $form[$qion[$Pno]], "\">\n";
  print "<table align=\"center\" width=\"60%\">\n";
  print "  <tr>\n";
  print "    <td bgcolor=\"99ccff\" colspan=\"5\">What is the formula for the $name[$qion[$Pno]] ion?</td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  foreach my $j (1..5) {
    my $choice = 1 + int rand($nions);
    if ($j == $nanswer) {
      if ($j/2 == int $j/2) {
        print "    <td bgcolor=\"ccffcc\" width=\"20%\"><input type=\"radio\" name=\"", $Ano, "\" value=\"", $form[$qion[$Pno]], "\">", $form[$qion[$Pno]], "</td>\n";
      } else {
        print "    <td bgcolor=\"ffccff\" width=\"20%\"><input type=\"radio\" name=\"", $Ano, "\" value=\"", $form[$qion[$Pno]], "\">", $form[$qion[$Pno]], "</td>\n";
      }
    } else {
      my $wrong = 1 + int rand($nions);
      if ($j/2 == int $j/2) {
        print "    <td bgcolor=\"ccffcc\" width=\"20%\"><input type=\"radio\" name=\"", $Ano, "\" value=\"", $form[$wrong], "\">", $form[$wrong], "</td>\n";
      } else {
        print "    <td bgcolor=\"ffccff\" width=\"20%\"><input type=\"radio\" name=\"", $Ano, "\" value=\"", $form[$wrong], "\">", $form[$wrong], "</td>\n";
      }
    }
  }
  print "  </tr>\n";
  print "  </table></a><p>\n\n";
}

#################################################################################
## Add Submit and Reset Buttons
#################################################################################

print "<table align=\"center\" width=\"60%\">\n";
print "  <tr>\n";
print "    <td><center><input type=\"submit\" value=\"Grade my Quiz!\"></center></td>\n";
print "    <td><center><input type=\"reset\" value=\"Reset my quiz\"></center></td>\n";
print "  </tr>\n";
print "</table>\n";
print "</form>\n\n";

}
#################################################################################
## Add a signature
#################################################################################

print "<hr>\n";
print "Patrick E. Fleming<br>\n";
print "Department of Chemistry and Biochemistry<br>\n";
print "California State University, East Bay<br>\n";

#################################################################################
## End html output
#################################################################################

print end_html;

#################################################################################
## Data follows __END__
#################################################################################

__END__
borate,BO<sub>3</sub><sup>3-</sup>
carbonate,CO<sub>3</sub><sup>2-</sup>
hydrogen carbonate,HCO<sub>3</sub><sup>-</sup>
nitrate,NO<sub>3</sub><sup>-</sup>
nitrite,NO<sub>2</sub><sup>-</sup>
ortho-silicate,SiO<sub>4</sub><sup>4-</sup>
meta-silicate,SiO<sub>3</sub><sup>2-</sup>
ortho-phosphate,PO<sub>4</sub><sup>3-</sup>
meta-phosphate,PO<sub>3</sub><sup>-</sup>
hydrogen phosphate,HPO<sub>4</sub><sup>2-</sup>
dihydrogen phosphate,H<sub>2</sub>PO<sub>4</sub><sup>-</sup>
sulfate,SO<sub>4</sub><sup>2-</sup>
sulfite,SO<sub>3</sub><sup>2-</sup>
hydrogen sulfate,HSO<sub>4</sub><sup>-</sup>
hydrogen sulfite,HSO<sub>3</sub><sup>-</sup>
thiosulfate,S<sub>2</sub>O<sub>3</sub><sup>2-</sup>
chlorate,ClO<sub>3</sub><sup>-</sup>
perchlorate,ClO<sub>4</sub><sup>-</sup>
chlorite,ClO<sub>2</sub><sup>-</sup>
hypochlorite,ClO<sup>-</sup>
arsenate,AsO<sub>4</sub><sup>3-</sup>
ortho-arsenite,AsO<sub>3</sub><sup>3-</sup>
meta-arsenite,AsO<sub>2</sub><sup>-</sup>
selenate,SeO<sub>4</sub><sup>2-</sup>
hydrogen selenate,HSeO<sub>4</sub><sup>-</sup>
bromrate,BrO<sub>3</sub><sup>-</sup>
perbromate,BrO<sub>4</sub><sup>-</sup>
bromrite,BrO<sub>2</sub><sup>-</sup>
hypobromite,BrO<sup>-</sup>
iodate,IO<sub>3</sub><sup>-</sup>
periodate,IO<sub>4</sub><sup>-</sup>
iodite,IO<sub>2</sub><sup>-</sup>
hypoiodite,IO<sup>-</sup>
hydrogen sulfide,SH<sup>-</sup>
hydroxide,OH<sup>-</sup>
cyanide,CN<sup>-</sup>
cyanate,OCN<sup>-</sup>
thiocyante,SCN<sup>-</sup>
ammonium,NH<sub>4</sub><sup>+</sup>
chromate,CrO<sub>4</sub><sup>2-</sup>
dichromate,Cr<sub>2</sub>O<sub>7</sub><sup>2-</sup>
permanganate,MnO<sub>4</sub><sup>-</sup>
nitride,N<sup>3-</sup>
oxide,O<sup>2-</sup>
fluoride,F<sup>-</sup>
phosphide,P<sup>3-</sup>
sulfide,S<sup>2-</sup>
chloride,Cl<sup>-</sup>
selenide,Se<sup>2-</sup>
bromide,Br<sup>-</sup>
iodide,I<sup>-</sup>
acetate,C<sub>2</sub>H<sub>3</sub>O<sub>2</sub><sup>-</sup>
oxalate,C<sub>2</sub>O<sub>4</sub><sup>2-</sup>
formate,CHO<sub>2</sub><sup>-</sup>
sterate,C<sub>17</sub>H<sub>35</sub>O<sub>2</sub><sup>-</sup>
benzoate,C<sub>7</sub>H<sub>5</sub>O<sub>2</sub><sup>-</sup>
tungstate,WO<sub>4</sub><sup>-</sup>
plumbate,PbO<sub>3</sub><sup>2-</sup>
stannate,SnO<sub>3</sub><sup>2-</sup>
molybdate,MoO<sub>4</sub><sup>2-</sup>
aluminate,AlO<sub>2</sub><sup>-</sup>
aurate,AuO<sub>2</sub><sup>-</sup>
platinate,PtO<sub>3</sub><sup>2-</sup>
antimonate,SbO<sub>3</sub><sup>-</sup>