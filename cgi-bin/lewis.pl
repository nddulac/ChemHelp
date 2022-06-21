#!/usr/bin/perl -wT

# A Virtual Lewis Structure Lab
# Patrick E. Fleming
# California State University, East Bay
# April 6, 2022 

# this virtual Denisty experiment is based on my own ridiculous
# notion that this was a good idea. And isn't about density.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');
my $i = 0;          # looping variable
my @molecule = (["sulfur hexafluoride",  "SF<sub>6</sub>",                   48, "S",  6, 0, 0, 18, "no",  "sulfurhexafluoride.jpg"],
                ["iodine pentafluoride", "IF<sub>5</sub>",                   42, "I",  5, 0, 0, 16, "no", "iodine_pentafluoride.jpg"],
                ["xenon tetrafluoride",  "XeF<sub>4</sub>",                  36, "Xe", 4, 0, 0, 14, "no",  "xenon_terafluoride.jpg"],
                ["SF<sub>4</sub<sup>2-</sup>", "SF<sub>4</sub<sup>2-</sup>", 36, "s",  4, 0, 0, 14, "no",  "sf42-.jpg"],
                ["phosphorus pentachloride", "PCl<sub>5</sub>",              42, "P",  5, 0, 0, 15, "no",  "phosporus_pentachloride.jpg"],
                ["sulfur tetrafluoride", "SF<sub>4</sub>",                   34, "S",  4, 0, 0, 13, "no",  "sulfur_tetrafluoride.jpg"],
                ["iodine trichloride",   "IF<sub>3</sub>",                   28, "I",  3, 0, 0, 11, "no",  "iodine_trichloride.jpg"],
                ["bromine trifluoride",  "BrF<sub>3</sub>",                  28, "Br", 3, 0, 0, 11, "no",  "bromine_trifluoride.jpg"],
                ["xenon difluoride",     "XeF<sub>2</sub>",                  22, "Xe", 2, 0, 0,  9, "no",  "xenon_difluoride.jpg"],
                ["tri iodide", "I<sub>3</sub><sup>-</sup>",                  22, "I",  2, 0, 0,  9, "no",  "triiodide.jpg"],
                ["methane",              "CH<sub>4</sub>",                    8, "C",  4, 0, 0,  0, "no",  "methane.jpg"],
                ["chloromethane",        "CClH<sub>3</sub>",                 14, "C",  4, 0, 0,  3, "no",  "chloromethane.jpg"],
                ["dichloromethane", "CCl<sub>2</sub>H<sub>2</sub>",          20, "C",  4, 0, 0,  6, "no",  "dichloromethane.jpg"],
                ["phosphate", "PO<sub>4</sub><sup>3-</sup>",                 32, "P",  3, 1, 0, 11, "yes", "phosphate.jpg"],
                ["sulfate", "SO<sub>4</sub><sup>2-</sup>",                   32, "S",  2, 2, 0, 10, "yes", "sulfate.jpg"],
                ["ammonia",              "NH<sub>3</sub>",                    8, "N",  3, 0, 0,  1, "no",  "ammonia.jpg"],
                ["phosphorus trichloride", "PCl<sub>3</sub>",                26, "P",  3, 0, 0, 10, "no",  "phosphorus_trichloride.jpg"],
                ["water",                "H<sub>2</sub>O",                    8, "O",  2, 0, 0,  2, "no",  "water.jpg"],
                ["sulfur difluoride",    "SF<sub>2</sub>",                   20, "S",  2, 0, 0,  8, "no",  "sulfur_difluoride.jpg"],
                ["formaldehyde",         "CH<sub>2</sub>O",                  12, "C",  2, 1, 0,  2, "no",  "formaldehyde.jpg"],
                ["carbonate", "CO<sub>3</sub><sup>2-</sup>",                 24, "C",  2, 1, 0,  8, "yes", "carbonate.jpg"],
                ["nitrate", "NO<sub>3</sub><sup>-</sup>",                    24, "N",  2, 1, 0,  8, "yes", "nitrate.jpg"],
                ["sulfur trioxide",      "SO<sub>3</sub>",                   24, "S",  0, 3, 0,  6, "no",  "sulfur_trioxide.jpg"],
                ["boron trifluiride",    "BF<sub>3</sub>",                   24, "B",  3, 0, 0,  9, "no",  "boron_trifluoride.jpg"],
                ["ozone",                "O<sub>3</sub>",                    18, "O",  1, 1, 0,  6, "yes", "ozone.jpg"],
                ["nitrite", "NO<sub>2</sub><sup>-</sup>",                    18, "N",  1, 1, 0,  6, "yes", "nitrite.jpg"],
                ["sulfur dioxide",       "SO<sub>2</sub>",                   18, "S",  0, 2, 0,  5, "no",  "sulfur_dioxide.jpg"],
                ["berylium dichloride",  "BeCl<sub>2</sub>",                 16, "Be", 2, 0, 0,  6, "no",  "beryllium_dichloride.jpg"],
                ["hydrogen cyanide",     "HCN",                              10, "C",  1, 0, 1,  0, "no",  "hydrogen_cyanide.jpg"],
                ["carbonyl sulfide",     "OCS",                              16, "C",  0, 2, 0,  4, "no",  "carbonyl_sulfide.jpg"],
                ["carbon dioxide",       "CO<sub>2</sub>",                   16, "C",  0, 2, 0,  4, "no",  "carbon_dioxide.jpg"]);
my $nmolec = scalar(@molecule);
# Molecule indices
#    0 - chemical name
#    1 - chemical formula
#    2 - number of electrons
#    3 - central atom
#    4 - number of single bonds
#    5 - number of double bonds
#    6 - number of triple bonds
#    7 - number of nonbonding pairs
#    8 - resonasce structures?
#    9 - Lewis structure image

# Begin html output
print header;
print start_html("Lewis Structures");
print "<h1>Lewis Structures</h1>\n";

if ($flow eq '') {
  my $molec = param('molec');
  # Must choose a molecule if one is not provided
  if ($molec eq '') {
    $molec = random_value(0, $nmolec);
  }
  
  print <<EOF;
  <p>Your molecule is <b>$molecule[$molec][0]</b> ($molecule[$molec][1]). Draw a Lewis structure for this molecule and answer the following questions.</p>
  <form action="/~pfleming/cgi-bin/lewis.pl" method="post">
    <table border="2" cellpadding="2">
      <tr>
        <th colspan="4" bgcolor="ccffcc"><center><font size="+1"><b>Lewis Structure</b></font></center></th>
      </tr>
      <tr>
        <td colspan="2" bgcolor="cccccc"><center>$molecule[$molec][0]</center></td>
        <td colspan="2" bgcolor="cccccc"><center>$molecule[$molec][1]</center></td>
      </tr>
      <tr>
        <td>Number of electrons in structure:</td>
        <td><input name="elecs"></td>
        <td>Chemical Symbol of Cenral Atom:</td>
        <td><input name="catom"></td>
      </tr>
      <tr>
        <td>Number of single bonds:</td>
        <td><input name="single"></td>
        <td>Number of double bonds:</td>
        <td><input name="double"></td>
      </tr>
      <tr>
        <td>Number of triple bonds:</td>
        <td><input name="triple"></td>
        <td>Number of non-bonding pairs:</td>
        <td><input name="nbpairs"></td>
      </tr>
      <tr>
        <td colspan="2">Does the structure suggest more than one resonance structure?</td>
        <td colspan="2"><input type="radio" name="res" value="yes">yes<br>
            <input type="radio" name="res" value="no">no</td>
      </tr>
    </table>
    <input type="hidden" name="molec" value="$molec">
    <input type="hidden" name="control_1" value="evaluate">
    <input type="submit" value="Am I right?">
    <input type="reset" value="Clear form">
  </form>
EOF
} elsif ($flow eq 'evaluate') {
  my $molec =   param('molec');
  my $elecs =   param('elecs');
  my $catom =   param('catom');
  my $single =  param('single');
  my $double =  param('double');
  my $triple =  param('triple');
  my $nbpairs = param('nbpairs');
  my $res =     param('res');
  my $response2 = "<font color=\"green\"><b>You are correct!</b></font>";
  my $response3 = "<font color=\"green\"><b>You are correct!</b></font>";
  my $response4 = "<font color=\"green\"><b>You are correct!</b></font>";
  my $response5 = "<font color=\"green\"><b>You are correct!</b></font>";
  my $response6 = "<font color=\"green\"><b>You are correct!</b></font>";
  my $response7 = "<font color=\"green\"><b>You are correct!</b></font>";
  my $response8 = "<font color=\"green\"><b>You are correct!</b></font>";
  
  # Let's grade the student's input, shall we?
  if ($elecs != $molecule[$molec][2]) {
    $response2 = "<font color=\"red\">You are incorrect.</font>";
  }

  if ($catom ne $molecule[$molec][3]) {
    $response3 = "<font color=\"red\">You are incorrect.</font>";
  }

  if ($single ne $molecule[$molec][4]) {
    $response4 = "<font color=\"red\">You are incorrect.</font>";
  }

  if ($double ne $molecule[$molec][5]) {
    $response5 = "<font color=\"red\">You are incorrect.</font>";
  }

  if ($triple ne $molecule[$molec][6]) {
    $response6 = "<font color=\"red\">You are incorrect.</font>";
  }
  
  if ($nbpairs != $molecule[$molec][7]) {
    $response7 = "<font color=\"red\">You are incorrect.</font>";
  }

  if ($res ne $molecule[$molec][8]) {
    $response8 = "<font color=\"red\">You are incorrect.</font>";
  }
  
  print <<EOF;
    <table border="2" cellpadding="2">
      <tr>
        <th colspan="5" bgcolor="ccffcc"><center><font size="+1"><b>Lewis Structures</b></font></center></th>
      </tr>
      <tr>
        <td>$molecule[$molec][0]</td>  
        <td>$molecule[$molec][1]</td>
        <td colspan="3" bgcolor="#cccccc"></td>
      </tr>
      <tr>
        <td bgcolor="pink">Question</td>
        <td bgcolor="pink">You said</td>
        <td bgcolor="pink" colspan="3">The correct answer is</td>
      </tr>
      <tr>
        <td>Number of electrons:</td>
        <td>$elecs</td>
        <td>$molecule[$molec][2]</td>
        <td>$response2</td>
        <td rowspan="7"><img src="/~pfleming/chem/111/chap07/lewis_structures/$molecule[$molec][9]" height="200"></td>
      </tr>
      <tr>
        <td>Central atom:</td>
        <td>$catom</td>
        <td>$molecule[$molec][3]</td>
        <td>$response3</td>
      </tr>
      <tr>
        <td>Single bonds:</td>
        <td>$single</td>
        <td>$molecule[$molec][4]</td>
        <td>$response4</td>
      </tr>
      <tr>
        <td>Double bonds:</td>
        <td>$double</td>
        <td>$molecule[$molec][5]</td>
        <td>$response5</td>
      </tr>
      <tr>
        <td>Triple bonds:</td>
        <td>$triple</td>
        <td>$molecule[$molec][6]</td>
        <td>$response6</td>
      </tr>
      <tr>
        <td>Non-bonding pairs:</td>
        <td>$nbpairs</td>
        <td>$molecule[$molec][7]</td>
        <td>$response7</td>
      </tr>
      <tr>
        <td>Are there resonance structures?</td>
        <td>$res</td>
        <td>$molecule[$molec][8]</td>
        <td>$response8</td>
      </tr>
    </table>
    
    <form action="/~pfleming/cgi-bin/lewis.pl" "method="post">
      <input type="hidden" name="molec" value="$molec">
      <input type="submit" value="Try again with this molecule">
    </form>
    <form action="/~pfleming/cgi-bin/lewis.pl" "method="post">
      <input type="hidden" name="molec" value="">
      <input type="submit" value="Try again with a NEW molecule">
    </form>
EOF
} else {
	print "Get thee to a nunnery!";
}

# Finish html output
print "<footer>\n";
print "		<hr>\n";
print "		<p><b>This work is made available under the <a href=\"https://creativecommons.org/licenses/by-nc/4.0/\">Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)</a> license.</b></p>\n";
print "		Patrick E. Fleming<br>\n";
print "		Department of Chemistry and Biochemistry<br>\n";
print "		California State University, East Bay<br>\n";
print "		<a href=\"mailto:patrick.fleming\@csueastbay.edu\">patrick.fleming\@csueastbay.edu</a>\n";
print "</footer>\n";

print end_html;

sub random_value {
	my $max = $_[0];
	my $min = $_[1];
	my $value = rand(1) * ($max - $min) + $min;
	return $value;
}